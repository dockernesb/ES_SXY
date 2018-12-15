drop table LD_JGBM cascade constraints;
drop table LD_JGBMQX cascade constraints;
drop table LD_JGQY cascade constraints;
drop table LD_JGZT cascade constraints;
drop table LD_JGQYJGCS cascade constraints;

begin
    dbms_scheduler.drop_job(job_name => 'P_UPDATE_JGZT_STATUS_JOB',force => TRUE);
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

create table LD_JGBM
(
  id          VARCHAR2(50) not null,
  type        VARCHAR2(1),
  dept_id     VARCHAR2(50),
  jgzt_id     VARCHAR2(50),
  create_user VARCHAR2(50),
  create_time DATE
)
;
comment on table LD_JGBM
  is '监管主题部门表';
comment on column LD_JGBM.id
  is '主键';
comment on column LD_JGBM.type
  is '监管部门类型（0负责部门，1协同部门）';
comment on column LD_JGBM.dept_id
  is '部门id（关联部门表中的主键id）';
comment on column LD_JGBM.jgzt_id
  is '监管主题id（关联监管主题表主键）';
comment on column LD_JGBM.create_user
  is '创建人ID';
comment on column LD_JGBM.create_time
  is '创建时间';
alter table LD_JGBM
  add constraint PK_LD_JGBM primary key (ID);

create table LD_JGBMQX
(
  id          VARCHAR2(50) not null,
  type        VARCHAR2(1),
  jgzt_id     VARCHAR2(50),
  zy_id       VARCHAR2(50),
  create_user VARCHAR2(50),
  create_time DATE
)
;
comment on table LD_JGBMQX
  is '监管部门权限表（也即监管事项）';
comment on column LD_JGBMQX.id
  is '主键';
comment on column LD_JGBMQX.type
  is '权限类型（0负责部门权限，1协同部门权限）';
comment on column LD_JGBMQX.jgzt_id
  is '监管主题id（关联监管主题表主键）';
comment on column LD_JGBMQX.zy_id
  is '联合奖惩二级资源id（关联资源库二级资源id）';
comment on column LD_JGBMQX.create_user
  is '创建人ID';
comment on column LD_JGBMQX.create_time
  is '创建时间';
alter table LD_JGBMQX
  add constraint PK_LD_JGBMQX primary key (ID);

create table LD_JGQY
(
  id          VARCHAR2(50) default SYS_GUID() not null,
  qymc        VARCHAR2(200),
  gszch       VARCHAR2(200),
  zzjgdm      VARCHAR2(200),
  tyshxydm    VARCHAR2(200),
  jgzt_id     VARCHAR2(50),
  create_user VARCHAR2(50),
  create_time DATE
)
;
comment on table LD_JGQY
  is '监管企业信息';
comment on column LD_JGQY.id
  is '主键';
comment on column LD_JGQY.qymc
  is '企业名称';
comment on column LD_JGQY.gszch
  is '工商注册号（单位注册号）';
comment on column LD_JGQY.zzjgdm
  is '组织机构代码';
comment on column LD_JGQY.tyshxydm
  is '统一社会信用代码';
comment on column LD_JGQY.jgzt_id
  is '监管主题id（关联监管主题表主键）';
comment on column LD_JGQY.create_user
  is '创建人ID（监管人员）';
comment on column LD_JGQY.create_time
  is '创建时间';
alter table LD_JGQY
  add constraint PK_LD_JGQY primary key (ID);

-- Create table
create table LD_JGZT
(
  id          VARCHAR2(50) not null,
  type        VARCHAR2(1),
  name        VARCHAR2(500),
  description VARCHAR2(4000),
  end_time    DATE,
  begin_time  DATE,
  status      VARCHAR2(1),
  shyj        VARCHAR2(4000),
  bz          VARCHAR2(4000),
  create_user VARCHAR2(50),
  create_time DATE,
  update_time DATE,
  update_user VARCHAR2(50),
  jgdx        VARCHAR2(4000),
  ssfs        VARCHAR2(4000),
  jgztlx      VARCHAR2(100)
);
-- Add comments to the table 
comment on table LD_JGZT
  is '监管主题信息表';
-- Add comments to the columns 
comment on column LD_JGZT.id
  is '主键';
comment on column LD_JGZT.type
  is '监管主题类型（0奖励，1惩戒）';
comment on column LD_JGZT.name
  is '监管主题名称';
comment on column LD_JGZT.description
  is '监管主题描述';
comment on column LD_JGZT.end_time
  is '结束时间';
comment on column LD_JGZT.begin_time
  is '开始时间';
comment on column LD_JGZT.status
  is '状态（待设置("0"), 未启用("1"), 监管中("2"), 已中止("3"), 已结束("4"), 已删除("5")）';
comment on column LD_JGZT.shyj
  is '审核意见';
comment on column LD_JGZT.bz
  is '备注';
comment on column LD_JGZT.create_user
  is '创建人ID';
comment on column LD_JGZT.create_time
  is '创建时间';
comment on column LD_JGZT.update_time
  is '更新时间';
comment on column LD_JGZT.update_user
  is '更新人ID';
comment on column LD_JGZT.jgdx
  is '监管对象';
comment on column LD_JGZT.ssfs
  is '实施方式';
comment on column LD_JGZT.jgztlx
  is '监管主体类型（1企业法人，2自然人，3企业法人和自然人）';
-- Create/Recreate primary, unique and foreign key constraints 
alter table LD_JGZT
  add constraint PK_LD_JGZT primary key (ID);


create table LD_JGQYJGCS
(
  id          VARCHAR2(50) not null,
  jgzt_id     VARCHAR2(50),
  jgqy_id     VARCHAR2(50),
  dept_id     VARCHAR2(50),
  zy_id       VARCHAR2(50),
  jgcslb      VARCHAR2(250),
  jgcsxq      VARCHAR2(2000),
  create_user VARCHAR2(50),
  create_time DATE,
  zdycslb     VARCHAR2(500)
)
;
comment on table LD_JGQYJGCS
  is '监管企业监管措施记录表（被部门执行监管时，记录的监管信息）';
comment on column LD_JGQYJGCS.id
  is '主键';
comment on column LD_JGQYJGCS.jgzt_id
  is '监管主题id（关联监管主题表主键）';
comment on column LD_JGQYJGCS.jgqy_id
  is '监管企业id（关联监管企业信息表主键）';
comment on column LD_JGQYJGCS.dept_id
  is '执行监管的部门id';
comment on column LD_JGQYJGCS.zy_id
  is '监管事项id（关联资源库一级资源id）';
comment on column LD_JGQYJGCS.jgcslb
  is '监管措施类别';
comment on column LD_JGQYJGCS.jgcsxq
  is '监管措施详情';
comment on column LD_JGQYJGCS.create_user
  is '创建人ID（监管人员）';
comment on column LD_JGQYJGCS.create_time
  is '创建时间';
comment on column LD_JGQYJGCS.zdycslb
  is '自定义措施类别';
alter table LD_JGQYJGCS
  add constraint PK_LD_JGQYJGCS primary key (ID);
alter table LD_JGQYJGCS
  add constraint FK_LD_JGQYJ_REFERENCE_LD_JGQY foreign key (JGQY_ID)
  references LD_JGQY (ID) on delete cascade;
alter table LD_JGQYJGCS
  add constraint FK_LD_JGQYJ_REFERENCE_LD_JGZT foreign key (JGZT_ID)
  references LD_JGZT (ID) on delete cascade;


CREATE OR REPLACE PROCEDURE P_UPDATE_JGZT_STATUS IS

-- 游标-已经到开始日期的且尚未开始监管的ID集合
CURSOR IDS1 IS
    SELECT ID FROM LD_JGZT A WHERE A.STATUS = 1
    AND TO_CHAR(A.BEGIN_TIME, 'YYYYMMDD') || '000000' <=  TO_CHAR(SYSDATE, 'YYYYMMDDhh24miss') FOR UPDATE;

-- 游标-已经到结束日期的且开始或中止监管的ID集合
CURSOR IDS2 IS
    SELECT ID FROM LD_JGZT A WHERE (A.STATUS = 2 OR A.STATUS = 3)
    AND TO_CHAR(A.END_TIME, 'YYYYMMDD') || '235959' <=  TO_CHAR(SYSDATE, 'YYYYMMDDhh24miss') FOR UPDATE;

BEGIN

    -- 更新专题状态为监管中
    FOR ID IN IDS1 LOOP
        UPDATE LD_JGZT SET STATUS = '2' WHERE CURRENT OF IDS1;
    END LOOP;

    -- 更新专题状态为已结束
    FOR ID IN IDS2 LOOP
        UPDATE LD_JGZT SET STATUS = '4' WHERE CURRENT OF IDS2;
    END LOOP;

    COMMIT;
END;
/


begin
  sys.dbms_scheduler.create_job(job_name            => 'P_UPDATE_JGZT_STATUS_JOB',
                                job_type            => 'STORED_PROCEDURE',
                                job_action          => 'P_UPDATE_JGZT_STATUS',
                                start_date          => trunc(sysdate + 1),
                                repeat_interval     => 'Freq=Daily;Interval=1',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => '定期修改联合奖惩监管专题的状态');
end;
/

COMMIT;

-- 菜单
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee58f717110158f71a756e0009', 'ROOT_1', '联合奖惩', null, 'icon-badge', 50);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee58f786890158fc9a3cf20069', '402894ee58f717110158f71a756e0009', '联动监管', 'centerSupervision/toSupervisionList.action?come=1', 'fa fa-circle-o', 5005);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee58f786890158fca262d70084', 'ROOT_2', '联合奖惩', null, 'icon-badge', 35);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee58f786890158fca2afc90089', '402894ee58f786890158fca262d70084', '联动监管', 'govSupervision/toSupervisionList.action?come=1', 'fa fa-circle-o', 3505);

-- 权限
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c93ca81594a34d801594a399f590007', '402894ee58f786890158fc9a3cf20069', 'center.jgsx', '中心端监管事项', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee58f786890158fc9af1e70071', '402894ee58f786890158fc9a3cf20069', 'center.supervision.list', '中心端联动监管', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee5943e1ea015943e605f30009', '402894ee58f786890158fc9a3cf20069', 'center.supervision.measure', '中心端监管措施', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee5925afc9015925b270930007', '402894ee58f786890158fc9a3cf20069', 'center.supervision.operate', '中心端联动监管按钮操作', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f8593f7efb01593f96a66e0011', '402894ee58f786890158fc9a3cf20069', 'center.supvEnterprise.enterListExport', '中心端联动监管企业目录导出', '中心端联动监管企业目录导出', null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f8591b6adf01591f151482003b', '402894ee58f786890158fc9a3cf20069', 'center.supvEnterprise.enterListManage', '中心端联动监管企业目录', '中心端联动监管企业目录', null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f85948764c0159494cc5b6002b', '402894ee58f786890158fc9a3cf20069', 'center.supvEnterprise.executeSupv', '中心端联动监管企业执行监管', '中心端联动监管企业执行监管', null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f8593f57a901593f595f4e000d', '402894ee58f786890158fc9a3cf20069', 'center.supvEnterprise.toView', '中心端联动监管企业详细', 'center.supvEnterprise.toView', null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c93ca81594ee71201594eebe1d70007', '402894ee58f786890158fc9a3cf20069', 'common.zxjg', '公用执行监管', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c93ca81594f693901594f6b7fac000f', '402894ee58f786890158fca2afc90089', 'common.zxjg.gov', '公用执行监管gov', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c93ca81594f693901594f6aad190008', '402894ee58f786890158fca2afc90089', 'gov.jgsx', '政务端监管事项', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee58f786890158fca467d50094', '402894ee58f786890158fca2afc90089', 'gov.supervision.list', '政务端联动监管', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee5943e1ea015943e6a2c5000f', '402894ee58f786890158fca2afc90089', 'gov.supervision.measure', '政务端监管措施', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('40287d815939291c0159392fdca10018', '402894ee58f786890158fca2afc90089', 'gov.supervision.operate', '政务端联动监管按钮操作', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f8594e8b5401594e9e84940019', '402894ee58f786890158fca2afc90089', 'gov.supv.addUupv', '政务端联动监管企业目录执行监管', '政务端联动监管企业目录执行监管', null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f8594e8b5401594e9bcc340008', '402894ee58f786890158fca2afc90089', 'gov.supv.enterList', '政务端联动监管企业目录', '政务端联动监管企业目录', null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f8594e8b5401594e9d724c0010', '402894ee58f786890158fca2afc90089', 'gov.supv.supv', '政务端联动监管企业目录按钮操作', '政务端联动监管企业目录执行监管', null, null, null, null);

-- 角色-权限
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c93ca81594a34d801594a399f590007');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c93ca81594ee71201594eebe1d70007');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee58f786890158fc9af1e70071');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee5925afc9015925b270930007');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee5943e1ea015943e605f30009');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894f8591b6adf01591f151482003b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894f8593f57a901593f595f4e000d');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894f8593f7efb01593f96a66e0011');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894f85948764c0159494cc5b6002b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '2c93ca81594f693901594f6aad190008');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '2c93ca81594f693901594f6b7fac000f');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '40287d815939291c0159392fdca10018');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ee58f786890158fca467d50094');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ee5943e1ea015943e6a2c5000f');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894f8594e8b5401594e9bcc340008');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894f8594e8b5401594e9d724c0010');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894f8594e8b5401594e9e84940019');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c93ca81594a34d801594a399f590007');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c93ca81594ee71201594eebe1d70007');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c93ca81594f693901594f6aad190008');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c93ca81594f693901594f6b7fac000f');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '40287d815939291c0159392fdca10018');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee58f786890158fc9af1e70071');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee58f786890158fca467d50094');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5925afc9015925b270930007');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5943e1ea015943e605f30009');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5943e1ea015943e6a2c5000f');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f8591b6adf01591f151482003b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f8593f57a901593f595f4e000d');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f8593f7efb01593f96a66e0011');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f85948764c0159494cc5b6002b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f8594e8b5401594e9bcc340008');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f8594e8b5401594e9d724c0010');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f8594e8b5401594e9e84940019');

COMMIT;

-- 字典项
insert into sys_dictionary_group (ID, GROUP_KEY, GROUP_NAME, DESCRIPTION)
values ('402894ee59445596015944596d370006', 'jgcslb', '监管措施类别', '监管措施类别，对企业执行监管时需要选择的分类');

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af693001e', '402894ee59445596015944596d370006', '1', '信用提醒或诚信约谈', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af693001c', '402894ee59445596015944596d370006', '2', '减少优惠政策和资金扶持力度', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af6920018', '402894ee59445596015944596d370006', '3', '加大优惠政策和资金扶持力度', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af693001d', '402894ee59445596015944596d370006', '4', '公示或书面告知', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af6930019', '402894ee59445596015944596d370006', '5', '给予荣誉称号，优先评优、评先', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af693001b', '402894ee59445596015944596d370006', '6', '撤销荣誉称号，禁止参与评优、评先', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af694001f', '402894ee59445596015944596d370006', '7', '限制或取消招标投标活动', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af693001a', '402894ee59445596015944596d370006', '8', '严格限制新增项目审批、核准', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af6920017', '402894ee59445596015944596d370006', '9', '其他惩戒方式', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca81594d61b901594d6af6920016', '402894ee59445596015944596d370006', '91', '其他激励方式', null);

COMMIT;

-- 联合奖惩统计分析
-- 菜单
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('57', '402894ee58f717110158f71a756e0009', '统计分析', null, '	fa fa-circle-o', 5431);
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c9951815f716214015f71803bde00da', '57', '专题应用分析', '/themeStatistics/toThemeStatisticsApply.action', 'fa fa-circle-o', 5556);
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c9951815f716214015f717f491800d8', '57', '专题统计概况', '/themeStatistics/toThemeStatisticsGeneral.action', 'fa fa-circle-o', 5555);

-- 权限
insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c9951815f716214015f7182502d00dd', '2c9951815f716214015f717f491800d8', 'center.themeStatisticsGeneral.query', '统计分析专题统计概况查询', null, null, null, null, null);
insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c9951815f716214015f7183f4dc00e1', '2c9951815f716214015f71803bde00da', 'center.themeStatisticsApply.query', '统计分析专题应用分析查询', null, null, null, null, null);

-- 角色权限
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c9951815f716214015f7182502d00dd');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c9951815f716214015f7182502d00dd');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c9951815f716214015f7183f4dc00e1');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c9951815f716214015f7183f4dc00e1');

commit;

-- 执行反馈查询菜单
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894b55e510a9a015e511d12920004', '402894ee58f717110158f71a756e0009', '执行反馈查询', 'centerFeedback/toFeedbackQuery.action', 'fa fa-circle-o', 5006);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894b55e510a9a015e511d12920005', '402894ee58f786890158fca262d70084', '执行反馈查询', 'govFeedback/toFeedbackQuery.action', 'fa fa-circle-o', 3506);

-- 执行反馈权限
insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894b55e512d0d015e5134aca70009', '402894b55e510a9a015e511d12920004', 'center.feedback.query', '执行反馈查询', '执行反馈查询', null, null, null, null);

insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894c05e6e9878015e6ef27648002f', '402894b55e510a9a015e511d12920005', 'gov.feedback.query', '反馈查询', null, null, null, null, null);

-- 执行反馈角色权限
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894b55e512d0d015e5134aca70009');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894c05e6e9878015e6ef27648002f');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894c05e6e9878015e6ef27648002f');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894b55e512d0d015e5134aca70009');

--反馈记录导出权限
insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ba5ea74400015ea7a00573006d', '402894ee58f786890158fca2afc90089', 'gov.supvEnterprise.measureListExport', '政务端反馈记录导出', null, null, null, null, null);

insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894b55e5127df015e512a5fab000b', '402894ee58f786890158fc9a3cf20069', 'center.supvEnterprise.measureListExport', '中心端联动监管反馈记录导出', '中心端联动监管反馈记录导出', null, null, null, null);

--反馈记录导出角色权限
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894b55e5127df015e512a5fab000b');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ba5ea74400015ea7a00573006d');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ba5ea74400015ea7a00573006d');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894b55e5127df015e512a5fab000b');
commit;

-----------------------------------------------------------------------  
alter table LD_JGCSPZ
   drop constraint FK_LD_JGCSP_REFERENCE_LD_JGZT;

alter table LD_JGCSPZ
   drop primary key cascade;

drop table LD_JGCSPZ cascade constraints;

/*==============================================================*/
/* Table: LD_JGCSPZ                                             */
/*==============================================================*/
create table LD_JGCSPZ 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(1),
   JGZT_ID              VARCHAR2(50)         not null,
   DEPT_ID              VARCHAR2(50),
   CSMC                 VARCHAR2(250),
   CSXZ                 VARCHAR2(4000),
   FLJZCYJ              VARCHAR2(4000),
   XZQLML_ID            VARCHAR2(50),
   CREATE_USER          VARCHAR2(50),
   CREATE_TIME          DATE
);

comment on table LD_JGCSPZ is
'监管措施配置表';

comment on column LD_JGCSPZ.ID is
'主键';

comment on column LD_JGCSPZ.STATUS is
'状态（0正常，1删除）';

comment on column LD_JGCSPZ.JGZT_ID is
'监管主题id（关联监管主题表主键）';

comment on column LD_JGCSPZ.DEPT_ID is
'实施单位（关联部门表中的主键id）';

comment on column LD_JGCSPZ.CSMC is
'措施名称';

comment on column LD_JGCSPZ.CSXZ is
'措施细则';

comment on column LD_JGCSPZ.FLJZCYJ is
'法律及政策依据';

comment on column LD_JGCSPZ.XZQLML_ID is
'所属权力清单（关联权利目录表LD_XZQLML主键ID）';

comment on column LD_JGCSPZ.CREATE_USER is
'创建人ID';

comment on column LD_JGCSPZ.CREATE_TIME is
'创建时间';

alter table LD_JGCSPZ
   add constraint PK_LD_JGCSPZ primary key (ID);

alter table LD_JGCSPZ
   add constraint FK_LD_JGCSP_REFERENCE_LD_JGZT foreign key (JGZT_ID)
      references LD_JGZT (ID)
      on delete cascade;


-----------------------------------------------------------------
alter table LD_JGXXLY
   drop constraint FK_LD_JGXXL_REFERENCE_LD_JGZT;

alter table LD_JGXXSXTJ
   drop constraint FK_LD_JGXXS_REFERENCE_LD_JGXXL;

alter table LD_JGXXLY
   drop primary key cascade;

drop table LD_JGXXLY cascade constraints;

/*==============================================================*/
/* Table: LD_JGXXLY                                             */
/*==============================================================*/
create table LD_JGXXLY 
(
   ID                   VARCHAR2(50)         not null,
   JGZT_ID              VARCHAR2(50),
   ZY_ID                VARCHAR2(50),
   CREATE_USER          VARCHAR2(50),
   CREATE_TIME          DATE
);

comment on table LD_JGXXLY is
'监管信息来源表';

comment on column LD_JGXXLY.ID is
'主键';

comment on column LD_JGXXLY.JGZT_ID is
'监管主题id（关联监管主题表主键）';

comment on column LD_JGXXLY.ZY_ID is
'联合奖惩二级资源id（关联资源库二级资源id）';

comment on column LD_JGXXLY.CREATE_USER is
'创建人ID';

comment on column LD_JGXXLY.CREATE_TIME is
'创建时间';

alter table LD_JGXXLY
   add constraint PK_LD_JGXXLY primary key (ID);

alter table LD_JGXXLY
   add constraint FK_LD_JGXXL_REFERENCE_LD_JGZT foreign key (JGZT_ID)
      references LD_JGZT (ID)
      on delete cascade;


--------------------------------------------------------------------------
alter table LD_JGXXSXTJ
   drop constraint FK_LD_JGXXS_REFERENCE_LD_JGXXL;

alter table LD_JGXXSXTJ
   drop primary key cascade;

drop table LD_JGXXSXTJ cascade constraints;

/*==============================================================*/
/* Table: LD_JGXXSXTJ                                           */
/*==============================================================*/
create table LD_JGXXSXTJ 
(
   ID                   VARCHAR2(50)         not null,
   JGXXLY_ID            VARCHAR2(50),
   SXTJLB               VARCHAR2(1),
   YI_ZDMC1             VARCHAR2(250),
   YI_ZDMC1NTJ          VARCHAR2(250),
   YI_ZDMC1ZDZ          VARCHAR2(250),
   YI_ZDMC1WTJ          VARCHAR2(250),
   YI_ZDMC2             VARCHAR2(250),
   YI_ZDMC2NTJ          VARCHAR2(250),
   YI_ZDMC2ZDZ          VARCHAR2(250),
   YI_ZDMC2WTJ          VARCHAR2(250),
   YI_ZDMC3             VARCHAR2(250),
   YI_ZDMC3NTJ          VARCHAR2(250),
   YI_ZDMC3ZDZ          VARCHAR2(250),
   FZTJ                 VARCHAR2(250),
   ER_ZDMC1             VARCHAR2(250),
   ER_ZDMC1NTJ          VARCHAR2(250),
   ER_ZDMC1ZDZ          VARCHAR2(250),
   ER_ZDMC1WTJ          VARCHAR2(250),
   ER_ZDMC2             VARCHAR2(250),
   ER_ZDMC2NTJ          VARCHAR2(250),
   ER_ZDMC2ZDZ          VARCHAR2(250),
   ER_ZDMC2WTJ          VARCHAR2(250),
   ER_ZDMC3             VARCHAR2(250),
   ER_ZDMC3NTJ          VARCHAR2(250),
   ER_ZDMC3ZDZ          VARCHAR2(250),
   CREATE_USER          VARCHAR2(50),
   CREATE_TIME          DATE
);

comment on table LD_JGXXSXTJ is
'监管信息筛选条件表';

comment on column LD_JGXXSXTJ.ID is
'主键';

comment on column LD_JGXXSXTJ.JGXXLY_ID is
'监管信息来源表id（关联监管信息来源表主键）';

comment on column LD_JGXXSXTJ.SXTJLB is
'筛选条件类别（0全部，1有具体筛选条件）';

comment on column LD_JGXXSXTJ.YI_ZDMC1 is
'第一组第一个条件字段名称';

comment on column LD_JGXXSXTJ.YI_ZDMC1NTJ is
'第一组第一个字段内条件';

comment on column LD_JGXXSXTJ.YI_ZDMC1ZDZ is
'第一组第一个字段要比较的值';

comment on column LD_JGXXSXTJ.YI_ZDMC1WTJ is
'第一组第一个字段外条件';

comment on column LD_JGXXSXTJ.YI_ZDMC2 is
'第一组第二个条件字段名称';

comment on column LD_JGXXSXTJ.YI_ZDMC2NTJ is
'第一组第二个字段内条件';

comment on column LD_JGXXSXTJ.YI_ZDMC2ZDZ is
'第一组第二个字段要比较的值';

comment on column LD_JGXXSXTJ.YI_ZDMC2WTJ is
'第一组第二个字段外条件';

comment on column LD_JGXXSXTJ.YI_ZDMC3 is
'第一组第三个条件字段名称';

comment on column LD_JGXXSXTJ.YI_ZDMC3NTJ is
'第一组第三个字段内条件';

comment on column LD_JGXXSXTJ.YI_ZDMC3ZDZ is
'第一组第三个字段要比较的值';

comment on column LD_JGXXSXTJ.FZTJ is
'第一组和第二组直接的比较条件（分组条件）';

comment on column LD_JGXXSXTJ.ER_ZDMC1 is
'第二组第一个条件字段名称';

comment on column LD_JGXXSXTJ.ER_ZDMC1NTJ is
'第二组第一个字段内条件';

comment on column LD_JGXXSXTJ.ER_ZDMC1ZDZ is
'第二组第一个字段要比较的值';

comment on column LD_JGXXSXTJ.ER_ZDMC1WTJ is
'第二组第一个字段外条件';

comment on column LD_JGXXSXTJ.ER_ZDMC2 is
'第二组第二个条件字段名称';

comment on column LD_JGXXSXTJ.ER_ZDMC2NTJ is
'第二组第二个字段内条件';

comment on column LD_JGXXSXTJ.ER_ZDMC2ZDZ is
'第二组第二个字段要比较的值';

comment on column LD_JGXXSXTJ.ER_ZDMC2WTJ is
'第二组第二个字段外条件';

comment on column LD_JGXXSXTJ.ER_ZDMC3 is
'第二组第三个条件字段名称';

comment on column LD_JGXXSXTJ.ER_ZDMC3NTJ is
'第二组第三个字段内条件';

comment on column LD_JGXXSXTJ.ER_ZDMC3ZDZ is
'第二组第三个字段要比较的值';

comment on column LD_JGXXSXTJ.CREATE_USER is
'创建人ID';

comment on column LD_JGXXSXTJ.CREATE_TIME is
'创建时间';

alter table LD_JGXXSXTJ
   add constraint PK_LD_JGXXSXTJ primary key (ID);

alter table LD_JGXXSXTJ
   add constraint FK_LD_JGXXS_REFERENCE_LD_JGXXL foreign key (JGXXLY_ID)
      references LD_JGXXLY (ID)
      on delete cascade;


--删除监管主体状态变更定时任务和其存储过程
drop procedure P_UPDATE_JGZT_STATUS;

begin
dbms_scheduler.drop_job(job_name => 'P_UPDATE_JGZT_STATUS_JOB',force => TRUE);
end;
/

--初始化联合奖惩自然人资源
insert into dz_theme (ID, PARENT_ID, TYPE, TYPE_NAME, DATA_SOURCE, DATA_TABLE, STATUS, CREATE_TIME, ZYYT)
values ('4028946a5ec1551f015ec1d694eb0021', 'ROOT_1', '1', '自然人失信信息', null, null, '1', '2017/09/27 13:36:59', '1');

insert into dz_theme (ID, PARENT_ID, TYPE, TYPE_NAME, DATA_SOURCE, DATA_TABLE, STATUS, CREATE_TIME, ZYYT)
values ('4028946a5ec1551f015ec1d7641a0023', '4028946a5ec1551f015ec1d694eb0021', '2', '商业违约', 'jdbcTemplate', 'YW_P_GRSYWY', '1', '2017/09/27 13:37:52', '1');

insert into dz_theme (ID, PARENT_ID, TYPE, TYPE_NAME, DATA_SOURCE, DATA_TABLE, STATUS, CREATE_TIME, ZYYT)
values ('4028946a5ec1551f015ec1d860270025', '4028946a5ec1551f015ec1d694eb0021', '2', '个人行政处罚', 'jdbcTemplate', 'YW_P_GRXZCF', '1', '2017/09/27 13:38:57', '1');

insert into dz_theme (ID, PARENT_ID, TYPE, TYPE_NAME, DATA_SOURCE, DATA_TABLE, STATUS, CREATE_TIME, ZYYT)
values ('4028946a5ec1551f015ec1d8ae6b0027', 'ROOT_1', '1', '自然人履行约定', null, null, '1', '2017/09/27 13:39:17', '1');

insert into dz_theme (ID, PARENT_ID, TYPE, TYPE_NAME, DATA_SOURCE, DATA_TABLE, STATUS, CREATE_TIME, ZYYT)
values ('4028946a5ec1551f015ec1d926740029', '4028946a5ec1551f015ec1d8ae6b0027', '2', '个人执行信息', 'jdbcTemplate', 'YW_P_GRFYQZZX', '1', '2017/09/27 13:39:47', '1');
commit;
insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e15c89002e', '4028946a5ec1551f015ec1d7641a0023', 'ZHH', '账户号', '2017/09/27 13:48:46', '账户号');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e15c89002f', '4028946a5ec1551f015ec1d7641a0023', 'SXYZCD', '失信严重程度', '2017/09/27 13:48:46', '失信严重程度');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e15c890030', '4028946a5ec1551f015ec1d7641a0023', 'QFJE', '欠费金额', '2017/09/27 13:48:46', '欠费金额');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e15c890031', '4028946a5ec1551f015ec1d7641a0023', 'ZQSJ', '账期时间', '2017/09/27 13:48:46', '账期时间');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e4d06a0033', '4028946a5ec1551f015ec1d860270025', 'CFSY', '处罚事由（违法事实、案由）', '2017/09/27 13:52:32', '处罚事由');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e4d06a0034', '4028946a5ec1551f015ec1d860270025', 'CFYJ', '处罚依据', '2017/09/27 13:52:32', '处罚依据');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e4d06a0035', '4028946a5ec1551f015ec1d860270025', 'CFJG', '处罚结果', '2017/09/27 13:52:32', '处罚结果');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e4d06a0036', '4028946a5ec1551f015ec1d860270025', 'CFRQ', '处罚日期', '2017/09/27 13:52:32', '处罚日期');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e4d06a0037', '4028946a5ec1551f015ec1d860270025', 'CFJGMC', '处罚机关名称（发出处罚决定的）', '2017/09/27 13:52:32', '处罚机关名称');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e51d1b0039', '4028946a5ec1551f015ec1d926740029', 'AH', '案号', '2017/09/27 13:52:51', '案号');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e51d1b003a', '4028946a5ec1551f015ec1d926740029', 'SLFY', '受理法院', '2017/09/27 13:52:51', '受理法院');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e51d1b003b', '4028946a5ec1551f015ec1d926740029', 'AJZT', '案件状态', '2017/09/27 13:52:51', '案件状态');

insert into dz_theme_column (ID, THEME_ID, COLUMN_NAME, COLUMN_COMMENTS, CREATE_TIME, COLUMN_ALIAS)
values ('4028946a5ec1551f015ec1e51d1b003c', '4028946a5ec1551f015ec1d926740029', 'JARQ', '结案日期', '2017/09/27 13:52:51', '结案日期');


------------------------------------------- 联动监管-奖惩主体 start -------------------------------------------
ALTER TABLE LD_JGQY ADD DELETE_TIME DATE NULL;
COMMENT ON COLUMN LD_JGQY.DELETE_TIME IS '移除时间';
ALTER TABLE LD_JGQY ADD "DELETE_USER" VARCHAR2(50) NULL;
COMMENT ON COLUMN LD_JGQY."DELETE_USER" IS '移除人ID';
ALTER TABLE LD_JGQY ADD STATUS INT DEFAULT 0 NULL;
COMMENT ON COLUMN LD_JGQY.STATUS IS '数据状态（0：正常，1：移除）';

CREATE TABLE LD_JGZRR
(
  id          VARCHAR2(50) default SYS_GUID() not null,
  XM        VARCHAR2(200),
  SFZH       VARCHAR2(200),
  jgzt_id     VARCHAR2(50),
  STATUS     VARCHAR2(50) DEFAULT '0' not null,
  create_user VARCHAR2(50),
  create_time DATE,
  DELETE_USER VARCHAR2(50),
  DELETE_TIME DATE
);
COMMENT ON TABLE LD_JGZRR IS '联动监管-自然人信息';
COMMENT ON COLUMN LD_JGZRR.XM IS '姓名';
COMMENT ON COLUMN LD_JGZRR.SFZH IS '身份证号';
COMMENT ON COLUMN LD_JGZRR.JGZT_ID IS '监管专题ID';
COMMENT ON COLUMN LD_JGZRR.STATUS IS '数据状态（0：正常，1：移除）';
COMMENT ON COLUMN LD_JGZRR.DELETE_TIME IS '移除时间';
COMMENT ON COLUMN LD_JGZRR.DELETE_USER IS '移除人ID';


-- 企业措施记录表 添加自然人id
ALTER TABLE LD_JGQYJGCS ADD JGZRR_ID VARCHAR2(50) NULL;
COMMENT ON COLUMN LD_JGQYJGCS.JGZRR_ID IS '监管自然人id（关联监管自然人信息表主键）';

-- 创建监管企业措施记录表和监管措施表的关联表
CREATE TABLE LD_JGQYJGCS_TO_JGCSPZ
(
  ID VARCHAR2(100) not null,
  JGQYJGCS_ID VARCHAR2(100),
  JGCSPZ_ID VARCHAR2(100)
);
alter table LD_JGQYJGCS_TO_JGCSPZ add constraint PK_ld_jgqyjgcs_to_jgcspz primary key (ID);
COMMENT ON COLUMN LD_JGQYJGCS_TO_JGCSPZ.JGQYJGCS_ID IS '监管企业监管措施记录表ID';
COMMENT ON COLUMN LD_JGQYJGCS_TO_JGCSPZ.JGCSPZ_ID IS '监管措施配置表ID';
COMMENT ON TABLE LD_JGQYJGCS_TO_JGCSPZ IS '监管企业措施记录表和监管措施表的关联表';
------------------------------------------- 联动监管-奖惩主体 end -------------------------------------------

commit;

