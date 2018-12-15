insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894ee5a0cd798015a0cdf470a0009', 'ROOT_1', '信用承诺管理', 'promise/toPromiseList.action', 'icon-wrench', 55);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894ee5a1122b8015a112568a00009', 'ROOT_2', '信用承诺管理', 'promise/toPromiseList.action', 'icon-wrench', 40);

insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894ee5a0cd798015a0ce1078c0016', '402894ee5a0cd798015a0cdf470a0009', 'center.promise.list', '中心端信用承诺管理', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894ee5a1122b8015a1129aa550015', '402894ee5a1122b8015a112568a00009', 'gov.promise.list', '政务端信用承诺管理', null, null, null, null, null);

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('2c90c28158761b550158762482b50015', '402894ee5a0cd798015a0ce1078c0016');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('8aa0bef544713ca60144713d364a0000', '402894ee5a0cd798015a0ce1078c0016');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('40289454547b159d01547b1efe25000c', '402894ee5a1122b8015a1129aa550015');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('8aa0bef544713ca60144713d364a0000', '402894ee5a1122b8015a1129aa550015');

insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894ee5a06bd2c015a0830c46f0006', 'cnlb', '承诺类别', '承诺类别');

insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ee5a06bd2c015a0830c46f0007', '402894ee5a06bd2c015a0830c46f0006', '0', '资金审批', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ee5a06bd2c015a0830c4700008', '402894ee5a06bd2c015a0830c46f0006', '1', '项目申报', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ee5a06bd2c015a0830c4700009', '402894ee5a06bd2c015a0830c46f0006', '3', '其他服务', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('402894ee5a06bd2c015a0830c470000a', '402894ee5a06bd2c015a0830c46f0006', '2', '企业认定', null);

commit;

drop table CN_CREDIT_COMMITMENT cascade constraints;
drop table CN_CREDIT_COMMITMENT_QY cascade constraints;

create table CN_CREDIT_COMMITMENT
(
  id          VARCHAR2(50) not null,
  cnlb        VARCHAR2(50),
  dept_id     VARCHAR2(50),
  create_time DATE,
  update_time DATE
)
;
comment on table CN_CREDIT_COMMITMENT
  is '信用承诺事项信息';
comment on column CN_CREDIT_COMMITMENT.id
  is '主键';
comment on column CN_CREDIT_COMMITMENT.cnlb
  is '承诺类别（字典项key）';
comment on column CN_CREDIT_COMMITMENT.dept_id
  is '监管部门ID';
comment on column CN_CREDIT_COMMITMENT.create_time
  is '创建时间';
comment on column CN_CREDIT_COMMITMENT.update_time
  is '更新时间';
alter table CN_CREDIT_COMMITMENT
  add constraint PK_CN_CREDIT_COMMITMENT primary key (ID);

create table CN_CREDIT_COMMITMENT_QY
(
  id          VARCHAR2(50) not null,
  qymc        VARCHAR2(500),
  gszch       VARCHAR2(200),
  zzjgdm      VARCHAR2(200),
  tyshxydm    VARCHAR2(100),
  cnlb        VARCHAR2(50),
  dept_id     VARCHAR2(50),
  create_time DATE,
  create_user VARCHAR2(50),
  yxq         VARCHAR2(50),
  clyj        VARCHAR2(2500)
)
;
comment on table CN_CREDIT_COMMITMENT_QY
  is '信用承诺事项关联的企业信息';
comment on column CN_CREDIT_COMMITMENT_QY.id
  is '主键';
comment on column CN_CREDIT_COMMITMENT_QY.qymc
  is '企业名称';
comment on column CN_CREDIT_COMMITMENT_QY.gszch
  is '工商注册号';
comment on column CN_CREDIT_COMMITMENT_QY.zzjgdm
  is '组织机构代码';
comment on column CN_CREDIT_COMMITMENT_QY.tyshxydm
  is '统一社会信用代码';
comment on column CN_CREDIT_COMMITMENT_QY.cnlb
  is '承诺类别';
comment on column CN_CREDIT_COMMITMENT_QY.dept_id
  is '监管部门ID';
comment on column CN_CREDIT_COMMITMENT_QY.create_time
  is '创建时间';
comment on column CN_CREDIT_COMMITMENT_QY.yxq
  is '加入黑名单有效期';
comment on column CN_CREDIT_COMMITMENT_QY.clyj
  is '加入黑名单处理意见';
alter table CN_CREDIT_COMMITMENT_QY
  add constraint PK_CN_CREDIT_COMMITMENT_QY primary key (ID);


CREATE OR REPLACE PROCEDURE P_CN_ADD_CREDIT_CNLB IS
-- 游标-承诺类别的字典项key集合
CURSOR KEYS IS
    SELECT K.* FROM SYS_DICTIONARY_GROUP T, SYS_DICTIONARY K WHERE T.ID = K.GROUP_ID AND T.GROUP_KEY = 'cnlb';
-- 游标-所有部门ID集合
CURSOR IDS2 IS
    SELECT * FROM SYS_DEPARTMENT ;

bEXIST NUMBER;

BEGIN
  bEXIST := 0;
    FOR SYS_DEPARTMENT IN IDS2 LOOP
      FOR SYS_DICTIONARY IN KEYS LOOP
       SELECT COUNT(*) INTO bEXIST FROM CN_CREDIT_COMMITMENT T WHERE T.CNLB = SYS_DICTIONARY.DICT_KEY AND T.DEPT_ID = SYS_DEPARTMENT.SYS_DEPARTMENT_ID ;

       IF (bEXIST = 0)
       THEN
          INSERT INTO CN_CREDIT_COMMITMENT VALUES (sys_guid(), SYS_DICTIONARY.DICT_KEY, SYS_DEPARTMENT.SYS_DEPARTMENT_ID,  sysdate, null);
        END IF;
      END LOOP;
    END LOOP;

    COMMIT;
END;
/

begin
  sys.dbms_scheduler.create_job(job_name        => 'P_CN_ADD_CREDIT_CNLB_JOB',
                                job_type        => 'STORED_PROCEDURE',
                                job_action      => 'P_CN_ADD_CREDIT_CNLB',
                                start_date      => sysdate,
                                repeat_interval => 'Freq=MINUTELY;Interval=5',
                                end_date        => to_date(null),
                                job_class       => 'DEFAULT_JOB_CLASS',
                                enabled         => true,
                                auto_drop       => false,
                                comments        => '生成部门承诺项');
end;
/

-- 信用承诺管理
update sys_menu set menu_url = '' where sys_menu_id = '402894ee5a0cd798015a0cdf470a0009';

insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order) values ('15', '402894ee5a0cd798015a0cdf470a0009', '信用承诺管理', 'promise/toPromiseList.action', 'fa fa-circle-o', 56);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order) values ('16', '402894ee5a0cd798015a0cdf470a0009', '信用承诺查询', 'promise/toPromiseQyViewList.action', 'fa fa-circle-o', 57);

insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c9951815e8347e1015e835df47e0021', '16', 'center.promise.list.query', '中心端信用承诺查询', null, null, null, null, null);

update sys_privilege set sys_menu_id = '15' where sys_privilege_id='402894ee5a0cd798015a0ce1078c0016';

insert into sys_role_to_privilege (sys_role_id, sys_privilege_id) values ('2c90c28158761b550158762482b50015', '2c9951815e8347e1015e835df47e0021');
insert into sys_role_to_privilege (sys_role_id, sys_privilege_id) values ('8aa0bef544713ca60144713d364a0000', '2c9951815e8347e1015e835df47e0021');
commit;

CREATE OR REPLACE PROCEDURE P_CN_ADD_CREDIT_CNLB IS
-- 游标-承诺类别的字典项key集合
CURSOR KEYS IS
    SELECT K.* FROM SYS_DICTIONARY_GROUP T, SYS_DICTIONARY K WHERE T.ID = K.GROUP_ID AND T.GROUP_KEY = 'cnlb';
-- 游标-所有部门ID集合
CURSOR IDS2 IS
    SELECT * FROM SYS_DEPARTMENT WHERE STATUS <> 1;

bEXIST NUMBER;

BEGIN
  bEXIST := 0;
    FOR SYS_DEPARTMENT IN IDS2 LOOP
      FOR SYS_DICTIONARY IN KEYS LOOP
       SELECT COUNT(*) INTO bEXIST FROM CN_CREDIT_COMMITMENT T WHERE T.CNLB = SYS_DICTIONARY.DICT_KEY AND T.DEPT_ID = SYS_DEPARTMENT.SYS_DEPARTMENT_ID ;

       IF (bEXIST = 0)
       THEN
          INSERT INTO CN_CREDIT_COMMITMENT VALUES (sys_guid(), SYS_DICTIONARY.DICT_KEY, SYS_DEPARTMENT.SYS_DEPARTMENT_ID,  sysdate, null);
        END IF;
      END LOOP;
    END LOOP;

    COMMIT;
END;
/