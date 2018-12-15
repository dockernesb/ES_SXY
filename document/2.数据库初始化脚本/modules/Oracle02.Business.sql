drop table DT_CREDIT_REPORT_PRINT cascade constraints;
drop table DT_ENTERPRISE_CREDIT cascade constraints;
drop table DT_ENTERPRISE_FIELD cascade constraints;
drop table DT_ENTERPRISE_OBJECTION cascade constraints;
drop table DT_ENTERPRISE_REPAIR cascade constraints;
drop table DT_ENTERPRISE_REPORT_APPLY cascade constraints;
drop table DT_PERSON_REPORT_APPLY cascade constraints;
drop table ST_HONGHEIBANG_CONFIG cascade constraints;

drop sequence SQ_BGBH;

begin
    dbms_scheduler.drop_job(job_name => 'P_DISPOSE_RED_BLACK_LIST_JOB',force => TRUE);
    EXCEPTION WHEN OTHERS THEN NULL;
end;
/

create table DT_CREDIT_REPORT_PRINT
(
  id          VARCHAR2(50) not null,
  bgbh        VARCHAR2(50) not null,
  print_date  DATE not null,
  sys_user_id VARCHAR2(50) not null
)
;
comment on table DT_CREDIT_REPORT_PRINT
  is '信用报告打印记录表';
comment on column DT_CREDIT_REPORT_PRINT.id
  is '主键';
comment on column DT_CREDIT_REPORT_PRINT.bgbh
  is '报告编号';
comment on column DT_CREDIT_REPORT_PRINT.print_date
  is '打印日期';
comment on column DT_CREDIT_REPORT_PRINT.sys_user_id
  is '创建者id';
alter table DT_CREDIT_REPORT_PRINT
  add constraint PK_CREDIT_REPORT_PRINT primary key (ID);

create table DT_ENTERPRISE_CREDIT
(
  id          VARCHAR2(50) not null,
  business_id VARCHAR2(50),
  third_id    VARCHAR2(50),
  data_table  VARCHAR2(50),
  bjbh        VARCHAR2(50),
  status      VARCHAR2(4),
  dept_code   VARCHAR2(50),
  zxshyj      VARCHAR2(1000),
  zxshr       VARCHAR2(50),
  zxshsj      DATE,
  bmshyj      VARCHAR2(1000),
  bmshr       VARCHAR2(50),
  bmshsj      DATE,
  category    VARCHAR2(50),
  dept_name   VARCHAR2(50),
  type        VARCHAR2(4)
)
;
comment on table DT_ENTERPRISE_CREDIT
  is '企业异议申诉修复信用关系表';
comment on column DT_ENTERPRISE_CREDIT.id
  is '主键';
comment on column DT_ENTERPRISE_CREDIT.business_id
  is '异议或修复ID';
comment on column DT_ENTERPRISE_CREDIT.third_id
  is '信用信息ID(行政处罚ID、欠税ID...)';
comment on column DT_ENTERPRISE_CREDIT.data_table
  is '表名';
comment on column DT_ENTERPRISE_CREDIT.bjbh
  is '办件编号';
comment on column DT_ENTERPRISE_CREDIT.status
  is '处理状态(0:待审核,1:待核实,2:已通过,3:未通过,4:已完成)';
comment on column DT_ENTERPRISE_CREDIT.dept_code
  is '数据提供部门编码';
comment on column DT_ENTERPRISE_CREDIT.zxshyj
  is '中心审核意见';
comment on column DT_ENTERPRISE_CREDIT.zxshr
  is '中心审核人';
comment on column DT_ENTERPRISE_CREDIT.zxshsj
  is '中心审核时间';
comment on column DT_ENTERPRISE_CREDIT.bmshyj
  is '部门审核意见';
comment on column DT_ENTERPRISE_CREDIT.bmshr
  is '部门审核人';
comment on column DT_ENTERPRISE_CREDIT.bmshsj
  is '部门审核时间';
comment on column DT_ENTERPRISE_CREDIT.category
  is '信息名称';
comment on column DT_ENTERPRISE_CREDIT.dept_name
  is '数据提供部门名称';
comment on column DT_ENTERPRISE_CREDIT.type
  is '信用类型(1：异议，2：修复)';
alter table DT_ENTERPRISE_CREDIT
  add primary key (ID);

create table DT_ENTERPRISE_FIELD
(
  id          VARCHAR2(50) not null,
  business_id VARCHAR2(50),
  data_table  VARCHAR2(50),
  third_id    VARCHAR2(50),
  label       VARCHAR2(200),
  code        VARCHAR2(100),
  old_value   VARCHAR2(4000),
  new_value   VARCHAR2(4000)
)
;
comment on table DT_ENTERPRISE_FIELD
  is '企业异议申诉修正字段信息表';
comment on column DT_ENTERPRISE_FIELD.id
  is '主键';
comment on column DT_ENTERPRISE_FIELD.business_id
  is '异议明细ID';
comment on column DT_ENTERPRISE_FIELD.data_table
  is '表标识';
comment on column DT_ENTERPRISE_FIELD.third_id
  is '信用信息ID(行政处罚ID、欠税ID...)';
comment on column DT_ENTERPRISE_FIELD.label
  is '字段描述';
comment on column DT_ENTERPRISE_FIELD.code
  is '字段编码';
comment on column DT_ENTERPRISE_FIELD.old_value
  is '旧值';
comment on column DT_ENTERPRISE_FIELD.new_value
  is '新值';
alter table DT_ENTERPRISE_FIELD
  add primary key (ID);

create table DT_ENTERPRISE_OBJECTION
(
  id          VARCHAR2(50) not null,
  zzjgdm      VARCHAR2(50),
  qymc        VARCHAR2(200),
  gszch       VARCHAR2(200),
  jbrxm       VARCHAR2(200),
  jbrlxdh     VARCHAR2(50),
  create_date DATE,
  create_id   VARCHAR2(50),
  ssbz        VARCHAR2(2000),
  tyshxydm    VARCHAR2(200),
  jbrsfzhm    VARCHAR2(50)
)
;
comment on table DT_ENTERPRISE_OBJECTION
  is '企业异议申诉表';
comment on column DT_ENTERPRISE_OBJECTION.id
  is '主键';
comment on column DT_ENTERPRISE_OBJECTION.zzjgdm
  is '组织机构代码';
comment on column DT_ENTERPRISE_OBJECTION.qymc
  is '企业名称';
comment on column DT_ENTERPRISE_OBJECTION.gszch
  is '工商注册号';
comment on column DT_ENTERPRISE_OBJECTION.jbrxm
  is '经办人姓名';
comment on column DT_ENTERPRISE_OBJECTION.jbrlxdh
  is '经办人联系电话';
comment on column DT_ENTERPRISE_OBJECTION.create_date
  is '申请时间';
comment on column DT_ENTERPRISE_OBJECTION.create_id
  is '录入人';
comment on column DT_ENTERPRISE_OBJECTION.ssbz
  is '申诉备注';
comment on column DT_ENTERPRISE_OBJECTION.tyshxydm
  is '统一社会信用代码';
comment on column DT_ENTERPRISE_OBJECTION.jbrsfzhm
  is '经办人身份证号码';
alter table DT_ENTERPRISE_OBJECTION
  add constraint DT_ENTERPRISE_OBJECTION_PK primary key (ID);

create table DT_ENTERPRISE_REPAIR
(
  id          VARCHAR2(50) not null,
  zzjgdm      VARCHAR2(50),
  qymc        VARCHAR2(200),
  gszch       VARCHAR2(200),
  jbrxm       VARCHAR2(200),
  jbrlxdh     VARCHAR2(50),
  xfzt        VARCHAR2(200),
  create_date DATE,
  create_id   VARCHAR2(50),
  tyshxydm    VARCHAR2(200),
  jbrsfzhm    VARCHAR2(50),
  xfbz        VARCHAR2(2000)
)
;
comment on table DT_ENTERPRISE_REPAIR
  is '企业信用修复申请表';
comment on column DT_ENTERPRISE_REPAIR.id
  is '主键';
comment on column DT_ENTERPRISE_REPAIR.zzjgdm
  is '组织机构代码';
comment on column DT_ENTERPRISE_REPAIR.qymc
  is '企业名称';
comment on column DT_ENTERPRISE_REPAIR.gszch
  is '工商注册号';
comment on column DT_ENTERPRISE_REPAIR.jbrxm
  is '经办人姓名';
comment on column DT_ENTERPRISE_REPAIR.jbrlxdh
  is '经办人联系电话';
comment on column DT_ENTERPRISE_REPAIR.xfzt
  is '修复主题';
comment on column DT_ENTERPRISE_REPAIR.create_date
  is '申请时间';
comment on column DT_ENTERPRISE_REPAIR.create_id
  is '录入人';
comment on column DT_ENTERPRISE_REPAIR.tyshxydm
  is '统一社会信用代码';
comment on column DT_ENTERPRISE_REPAIR.jbrsfzhm
  is '经办人身份证号码';
comment on column DT_ENTERPRISE_REPAIR.xfbz
  is '修复备注';
alter table DT_ENTERPRISE_REPAIR
  add constraint DT_ENTERPRISE_REPAIR_PK primary key (ID);

-- Create table
create table DT_ENTERPRISE_REPORT_APPLY
(
  id              VARCHAR2(50) not null,
  zzjgdm          VARCHAR2(50),
  qymc            VARCHAR2(200),
  gszch           VARCHAR2(200),
  jbrxm           VARCHAR2(200),
  jbrlxdh         VARCHAR2(50),
  bjbh            VARCHAR2(50),
  status          VARCHAR2(4),
  create_date     DATE,
  create_id       VARCHAR2(50),
  bz              VARCHAR2(2000),
  update_id       VARCHAR2(50),
  tyshxydm        VARCHAR2(200),
  jbrsfzhm        VARCHAR2(50),
  zxshyj          VARCHAR2(1000),
  zxshr           VARCHAR2(50),
  zxshsj          DATE,
  sqbgqssj        DATE,
  sqbgjzsj        DATE,
  sqzzjgdm        VARCHAR2(50),
  sqqymc          VARCHAR2(200),
  sqgszch         VARCHAR2(200),
  sqtyshxydm      VARCHAR2(200),
  type            VARCHAR2(1),
  purpose         VARCHAR2(50),
  xybgbh          VARCHAR2(100),
  is_has_basic    VARCHAR2(2) default '0',
  is_has_report   VARCHAR2(2) default '0',
  no_report_cause VARCHAR2(2000),
  is_issue        VARCHAR2(2) default '0',
  issue_opition   VARCHAR2(2000),
  issue_date      DATE,
  is_audit_back   VARCHAR2(2) default '0',
  audit_back_date DATE,
  audit_back_user VARCHAR2(50)
);
-- Add comments to the table 
comment on table DT_ENTERPRISE_REPORT_APPLY
  is '企业信用报告申请表';
-- Add comments to the columns 
comment on column DT_ENTERPRISE_REPORT_APPLY.id
  is '主键';
comment on column DT_ENTERPRISE_REPORT_APPLY.zzjgdm
  is '组织机构代码';
comment on column DT_ENTERPRISE_REPORT_APPLY.qymc
  is '企业名称';
comment on column DT_ENTERPRISE_REPORT_APPLY.gszch
  is '工商注册号';
comment on column DT_ENTERPRISE_REPORT_APPLY.jbrxm
  is '经办人姓名';
comment on column DT_ENTERPRISE_REPORT_APPLY.jbrlxdh
  is '经办人联系电话';
comment on column DT_ENTERPRISE_REPORT_APPLY.bjbh
  is '办件编号';
comment on column DT_ENTERPRISE_REPORT_APPLY.status
  is '处理状态  0:待审核,1:已通过,2:未通过';
comment on column DT_ENTERPRISE_REPORT_APPLY.create_date
  is '申请时间';
comment on column DT_ENTERPRISE_REPORT_APPLY.create_id
  is '录入人';
comment on column DT_ENTERPRISE_REPORT_APPLY.bz
  is '备注';
comment on column DT_ENTERPRISE_REPORT_APPLY.update_id
  is '修改人';
comment on column DT_ENTERPRISE_REPORT_APPLY.tyshxydm
  is '统一社会信用代码';
comment on column DT_ENTERPRISE_REPORT_APPLY.jbrsfzhm
  is '经办人身份证号码';
comment on column DT_ENTERPRISE_REPORT_APPLY.zxshyj
  is '中心审核意见';
comment on column DT_ENTERPRISE_REPORT_APPLY.zxshr
  is '中心审核人';
comment on column DT_ENTERPRISE_REPORT_APPLY.zxshsj
  is '中心审核时间';
comment on column DT_ENTERPRISE_REPORT_APPLY.sqbgqssj
  is '申请报告起始时间';
comment on column DT_ENTERPRISE_REPORT_APPLY.sqbgjzsj
  is '申请报告截止时间';
comment on column DT_ENTERPRISE_REPORT_APPLY.sqzzjgdm
  is '授权组织机构代码';
comment on column DT_ENTERPRISE_REPORT_APPLY.sqqymc
  is '授权企业名称';
comment on column DT_ENTERPRISE_REPORT_APPLY.sqgszch
  is '授权工商注册号';
comment on column DT_ENTERPRISE_REPORT_APPLY.sqtyshxydm
  is '授权统一社会信用代码';
comment on column DT_ENTERPRISE_REPORT_APPLY.type
  is '查询类型（0:企业自查,1:委托查询）';
comment on column DT_ENTERPRISE_REPORT_APPLY.purpose
  is '申请报告用途（字典项值）';
comment on column DT_ENTERPRISE_REPORT_APPLY.xybgbh
  is '信用报告编号';
comment on column DT_ENTERPRISE_REPORT_APPLY.is_has_basic
  is '是否有企业基本信息（0：无，1：有）';
comment on column DT_ENTERPRISE_REPORT_APPLY.is_has_report
  is '是否有省报告（0：无，1：有）';
comment on column DT_ENTERPRISE_REPORT_APPLY.no_report_cause
  is '无省报告的原因';
comment on column DT_ENTERPRISE_REPORT_APPLY.is_issue
  is '是否已下发（0：未下发，1：已下发）';
comment on column DT_ENTERPRISE_REPORT_APPLY.issue_opition
  is '下发意见';
comment on column DT_ENTERPRISE_REPORT_APPLY.issue_date
  is '下发时间';
comment on column DT_ENTERPRISE_REPORT_APPLY.is_audit_back
  is '是否已退回审核（0：未退回，1：已退回）';
comment on column DT_ENTERPRISE_REPORT_APPLY.audit_back_date
  is '审核退回时间';
comment on column DT_ENTERPRISE_REPORT_APPLY.audit_back_user
  is '审核退回用户ID';
-- Create/Recreate primary, unique and foreign key constraints 
alter table DT_ENTERPRISE_REPORT_APPLY
  add constraint DT_ENTERPRISE_REPORT_APPLY_PK primary key (ID);

create table DT_PERSON_REPORT_APPLY
(
  id          VARCHAR2(50) not null,
  bjbh        VARCHAR2(50),
  cxrxm       VARCHAR2(50),
  cxrsfzh     VARCHAR2(50),
  wtrxm       VARCHAR2(50),
  wtrsfzh     VARCHAR2(50),
  wtrlxdh     VARCHAR2(50),
  purpose     VARCHAR2(50),
  sqbgqssj    DATE,
  sqbgjzsj    DATE,
  bz          VARCHAR2(2000),
  status      VARCHAR2(4),
  create_date DATE,
  create_id   VARCHAR2(50),
  update_id   VARCHAR2(50),
  zxshyj      VARCHAR2(1000),
  zxshr       VARCHAR2(50),
  zxshsj      DATE,
  type        VARCHAR2(1),
  xybgbh      VARCHAR2(100)
)
;
comment on table DT_PERSON_REPORT_APPLY
  is '自然人信用报告申请表';
comment on column DT_PERSON_REPORT_APPLY.id
  is '主键';
comment on column DT_PERSON_REPORT_APPLY.bjbh
  is '办件编号';
comment on column DT_PERSON_REPORT_APPLY.cxrxm
  is '查询人姓名';
comment on column DT_PERSON_REPORT_APPLY.cxrsfzh
  is '查询人身份证号';
comment on column DT_PERSON_REPORT_APPLY.wtrxm
  is '委托人姓名';
comment on column DT_PERSON_REPORT_APPLY.wtrsfzh
  is '委托人身份证号';
comment on column DT_PERSON_REPORT_APPLY.wtrlxdh
  is '委托人系电话';
comment on column DT_PERSON_REPORT_APPLY.purpose
  is '申请报告用途（字典项值）';
comment on column DT_PERSON_REPORT_APPLY.sqbgqssj
  is '申请报告起始时间';
comment on column DT_PERSON_REPORT_APPLY.sqbgjzsj
  is '申请报告截止时间';
comment on column DT_PERSON_REPORT_APPLY.bz
  is '备注';
comment on column DT_PERSON_REPORT_APPLY.status
  is '处理状态  0:待审核,1:已通过,2:未通过';
comment on column DT_PERSON_REPORT_APPLY.create_date
  is '申请时间';
comment on column DT_PERSON_REPORT_APPLY.create_id
  is '录入人';
comment on column DT_PERSON_REPORT_APPLY.update_id
  is '修改人';
comment on column DT_PERSON_REPORT_APPLY.zxshyj
  is '中心审核意见';
comment on column DT_PERSON_REPORT_APPLY.zxshr
  is '中心审核人';
comment on column DT_PERSON_REPORT_APPLY.zxshsj
  is '中心审核时间';
comment on column DT_PERSON_REPORT_APPLY.type
  is '查询类型（0:本人查询,1:委托查询）';
comment on column DT_PERSON_REPORT_APPLY.xybgbh
  is '信用报告编号';
alter table DT_PERSON_REPORT_APPLY
  add constraint PK_DT_PERSON_REPORT_APPLY primary key (ID);

-- Create table
create table ST_HONGHEIBANG_CONFIG
(
  id          VARCHAR2(50) not null,
  type        NUMBER,
  level_order NUMBER,
  level_name  VARCHAR2(100),
  level_count NUMBER,
  create_time DATE
);

comment on table ST_HONGHEIBANG_CONFIG
  is '红黑榜设置（配置需列入红黑榜的必要条件信息）';
comment on column ST_HONGHEIBANG_CONFIG.id
  is '主键';
comment on column ST_HONGHEIBANG_CONFIG.type
  is '种类（0：红榜，1：黑榜）';
comment on column ST_HONGHEIBANG_CONFIG.level_order
  is '级别，递增关系（失信分三种：一般0，较重1，严重2；荣誉分三种：县级0，市级1，省级2）';
comment on column ST_HONGHEIBANG_CONFIG.level_name
  is '数量（每个级别下到达要求的数据，则级别晋级。目前一般失信3次，记一次较重失信；较重失信3次记一次严重失信；严重失信3次记入黑榜；2、县级荣誉3次记1次市级荣誉；市级荣誉3次记一次省级荣誉；省级荣誉3次记一次红榜；）';
comment on column ST_HONGHEIBANG_CONFIG.level_count
  is '数量（每个级别下到达要求的数据，则级别晋级。目前一般失信3次，记一次较重失信；较重失信3次记一次严重失信；严重失信3次记入黑榜；2、县级荣誉3次记1次市级荣誉；市级荣誉3次记一次省级荣誉；省级荣誉3次记一次红榜；）';
comment on column ST_HONGHEIBANG_CONFIG.create_time
  is '创建时间';
  
insert into ST_HONGHEIBANG_CONFIG (ID, TYPE, LEVEL_ORDER, LEVEL_NAME, LEVEL_COUNT, CREATE_TIME)
values ('1', 0, 0, '县级', 3, sysdate);

insert into ST_HONGHEIBANG_CONFIG (ID, TYPE, LEVEL_ORDER, LEVEL_NAME, LEVEL_COUNT, CREATE_TIME)
values ('2', 0, 1, '市级', 3, sysdate);

insert into ST_HONGHEIBANG_CONFIG (ID, TYPE, LEVEL_ORDER, LEVEL_NAME, LEVEL_COUNT, CREATE_TIME)
values ('3', 0, 2, '省级', 3, sysdate);

insert into ST_HONGHEIBANG_CONFIG (ID, TYPE, LEVEL_ORDER, LEVEL_NAME, LEVEL_COUNT, CREATE_TIME)
values ('4', 1, 0, '一般', 3, sysdate);

insert into ST_HONGHEIBANG_CONFIG (ID, TYPE, LEVEL_ORDER, LEVEL_NAME, LEVEL_COUNT, CREATE_TIME)
values ('5', 1, 1, '较重', 3, sysdate);

insert into ST_HONGHEIBANG_CONFIG (ID, TYPE, LEVEL_ORDER, LEVEL_NAME, LEVEL_COUNT, CREATE_TIME)
values ('6', 1, 2, '严重', 3, sysdate);
commit;
  
insert into dt_upload_file (UPLOAD_FILE_ID, FILE_NAME, FILE_PATH, FILE_TYPE, CREATE_DATE, SYS_USER_ID, BUSINESS_ID, FILE_VIEWPATH, ICON)
values ('4028946a5afff929015afffa6f3a0001', 'weizhibj.png', 'D:/work/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/CreditService2.0/app/images/creditReport/1490420183364.png', '1', to_date('24-03-2017 19:01:26', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', '4028946a5afff929015afffa6f150000', null, null);
insert into dt_upload_file (UPLOAD_FILE_ID, FILE_NAME, FILE_PATH, FILE_TYPE, CREATE_DATE, SYS_USER_ID, BUSINESS_ID, FILE_VIEWPATH, ICON)
values ('4028946a5afff929015afffa8f8d0003', 'defaultbj.png', 'D:/work/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp1/wtpwebapps/CreditService2.0/app/images/creditReport/1490420141537.png', '1', to_date('24-03-2017 19:01:35', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', '4028946a5afff929015afffa8f730002', null, null);

-- Create sequence 
create sequence SQ_BGBH
minvalue 1
maxvalue 99999999999999999
start with 2
increment by 1
nocache;


--  处理红黑名单
CREATE OR REPLACE PROCEDURE P_DISPOSE_RED_BLACK_LIST IS

-- 游标(有表彰荣誉且不在红名单中的企业)
CURSOR RED_LIST IS
    SELECT A.JGQC, A.GSZCH, A.ZZJGDM, A.TYSHXYDM FROM YW_L_QYBZRY A
    WHERE NOT EXISTS
    (SELECT * FROM YW_L_HONGMINGDAN B WHERE A.JGQC = B.JGQC OR A.GSZCH = B.GSZCH
    OR A.ZZJGDM = B.ZZJGDM OR A.TYSHXYDM = B.TYSHXYDM)
    GROUP BY A.JGQC, A.GSZCH, A.ZZJGDM, A.TYSHXYDM;

-- 游标(有行政处罚且不在黑名单中的企业)
CURSOR BLACK_LIST IS
    SELECT A.JGQC, A.GSZCH, A.ZZJGDM, A.TYSHXYDM FROM YW_L_XZCF A
    WHERE NOT EXISTS
    (SELECT * FROM YW_L_HEIMINGDAN B WHERE A.JGQC = B.JGQC OR A.GSZCH = B.GSZCH
    OR A.ZZJGDM = B.ZZJGDM OR A.TYSHXYDM = B.TYSHXYDM)
    GROUP BY A.JGQC, A.GSZCH, A.ZZJGDM, A.TYSHXYDM;

-- 游标(红名单配置)
CURSOR RED_CONFIG IS
    SELECT * FROM ST_HONGHEIBANG_CONFIG
    WHERE TYPE = 0 ORDER BY LEVEL_ORDER ASC;

-- 游标(黑名单配置)
CURSOR BLACK_CONFIG IS
    SELECT * FROM ST_HONGHEIBANG_CONFIG
    WHERE TYPE = 1 ORDER BY LEVEL_ORDER ASC;

RED_COUNT NUMBER;   --  红名单个数

BLACK_COUNT NUMBER; --  黑名单个数

JGSLBGDJ_ID VARCHAR2(50); -- 机构基本信息表主键ID

TEMP_VAR NUMBER;    --  临时变量

BEGIN

    -- 处理红名单
    FOR RED IN RED_LIST LOOP

        RED_COUNT := 0;

        --  处理表彰数量
        FOR CONFIG IN RED_CONFIG LOOP

            SELECT COUNT(1) INTO TEMP_VAR FROM YW_L_QYBZRY A
            WHERE A.RYDJ = CONFIG.LEVEL_NAME
            AND ( A.JGQC = RED.JGQC OR A.GSZCH = RED.GSZCH
            OR A.ZZJGDM = RED.ZZJGDM OR A.TYSHXYDM = RED.TYSHXYDM );

            SELECT FLOOR((TEMP_VAR + RED_COUNT) / CONFIG.LEVEL_COUNT)
            INTO RED_COUNT FROM DUAL;

        END LOOP;

        --  判断是否达到加入红名单的条件
        IF RED_COUNT >= 1 THEN

            SELECT COUNT(1) INTO TEMP_VAR FROM YW_L_HONGMINGDAN A
            WHERE A.JGQC = RED.JGQC OR A.GSZCH = RED.GSZCH
            OR A.ZZJGDM = RED.ZZJGDM OR A.TYSHXYDM = RED.TYSHXYDM;
            
            SELECT A.ID INTO JGSLBGDJ_ID FROM YW_L_JGSLBGDJ A
            WHERE A.JGQC = RED.JGQC OR A.GSZCH = RED.GSZCH
            OR A.ZZJGDM = RED.ZZJGDM OR A.TYSHXYDM = RED.TYSHXYDM;

            --  不在红名单中，则加入红名单
            IF TEMP_VAR <= 0 THEN
                INSERT INTO YW_L_HONGMINGDAN (
                    ID, STATUS, CREATE_TIME, TGRQ, JGQC, GSZCH, ZZJGDM, TYSHXYDM, BZ, JGDJ_ID, RDRQ
                ) VALUES (
                    SYS_GUID(), '1', SYSDATE, SYSDATE, RED.JGQC,
                    RED.GSZCH, RED.ZZJGDM, RED.TYSHXYDM, '系统自动加入红名单',JGSLBGDJ_ID, trunc（sysdate,'dd'）
                );
            END IF;

        END IF;

    END LOOP;


    -- 处理黑名单
    FOR BLACK IN BLACK_LIST LOOP

        BLACK_COUNT := 0;

        --  处理处罚数量
        FOR CONFIG IN BLACK_CONFIG LOOP

            SELECT COUNT(1) INTO TEMP_VAR FROM YW_L_XZCF A
            WHERE A.CFDJ = CONFIG.LEVEL_NAME
            AND ( A.JGQC = BLACK.JGQC OR A.GSZCH = BLACK.GSZCH
            OR A.ZZJGDM = BLACK.ZZJGDM OR A.TYSHXYDM = BLACK.TYSHXYDM );

            SELECT FLOOR((TEMP_VAR + BLACK_COUNT) / CONFIG.LEVEL_COUNT)
            INTO BLACK_COUNT FROM DUAL;

        END LOOP;

        --  判断是否达到加入红名单的条件
        IF BLACK_COUNT >= 1 THEN

            SELECT COUNT(1) INTO TEMP_VAR FROM YW_L_HEIMINGDAN A
            WHERE A.JGQC = BLACK.JGQC OR A.GSZCH = BLACK.GSZCH
            OR A.ZZJGDM = BLACK.ZZJGDM OR A.TYSHXYDM = BLACK.TYSHXYDM;
            
            SELECT A.ID INTO JGSLBGDJ_ID FROM YW_L_JGSLBGDJ A
            WHERE A.JGQC = BLACK.JGQC OR A.GSZCH = BLACK.GSZCH
            OR A.ZZJGDM = BLACK.ZZJGDM OR A.TYSHXYDM = BLACK.TYSHXYDM;

            --  不在红名单中，则加入黑名单
            IF TEMP_VAR <= 0 THEN
                INSERT INTO YW_L_HEIMINGDAN (
                    ID, STATUS, CREATE_TIME, TGRQ, JGQC, GSZCH, ZZJGDM, TYSHXYDM, BZ, JGDJ_ID, QRYZSXRQ
                ) VALUES (
                    SYS_GUID(), '1', SYSDATE, SYSDATE, BLACK.JGQC,
                    BLACK.GSZCH, BLACK.ZZJGDM, BLACK.TYSHXYDM, '系统自动加入黑名单', JGSLBGDJ_ID, trunc（sysdate,'dd'）
                );
            END IF;

        END IF;

    END LOOP;

    COMMIT;
END;
/

--添加索引，提高存储过程P_DISPOSE_RED_BLACK_LIST的执行速度
create index YW_L_XZCF_SY_JGQC on YW_L_XZCF (JGQC);
create index YW_L_XZCF_SY_GSZCH on YW_L_XZCF (GSZCH);
create index YW_L_XZCF_SY_ZZJGDM on YW_L_XZCF (ZZJGDM);
create index YW_L_XZCF_SY_TYSHXYDM on YW_L_XZCF (TYSHXYDM);

create index YW_L_QYBZRY_SY_JGQC on YW_L_QYBZRY (JGQC);
create index YW_L_QYBZRY_SY_GSZCH on YW_L_QYBZRY (GSZCH);
create index YW_L_QYBZRY_SY_ZZJGDM on YW_L_QYBZRY (ZZJGDM);
create index YW_L_QYBZRY_SY_TYSHXYDM on YW_L_QYBZRY (TYSHXYDM);

begin
  sys.dbms_scheduler.create_job(job_name            => 'P_DISPOSE_RED_BLACK_LIST_JOB',
                                job_type            => 'STORED_PROCEDURE',
                                job_action          => 'P_DISPOSE_RED_BLACK_LIST',
                                start_date          => trunc(sysdate + 1),
                                repeat_interval     => 'Freq=Daily;Interval=1',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => '定期处理红黑榜数据');
end;
/

-- 菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875ada135009f', 'ROOT_3', '业务办理', null, 'icon-user-following', 10);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875addca500a4', 'ROOT_3', '业务查询', null, 'icon-magnifier', 15);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875ae474600a9', 'ROOT_3', '报告打印', null, 'icon-printer', 20);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c2815875742001587598fda00058', 'ROOT_1', '业务管理', null, 'icon-user-following', 15);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875aec1f100af', '2c90c28158757420015875ada135009f', '法人信用报告申请', 'hallReport/toReportApply.action', 'fa fa-circle-o', 1000);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85996651f015996afaa360016', '2c90c28158757420015875ada135009f', '自然人信用报告申请', 'hallPReport/toReportApply.action', 'fa fa-circle-o', 1001);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875b12f5700c0', '2c90c28158757420015875addca500a4', '法人信用报告查询', 'hallReport/toReportList.action', 'fa fa-circle-o', 1500);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85996651f015996b03903001b', '2c90c28158757420015875addca500a4', '自然人信用报告查询', 'hallPReport/toReportList.action', 'fa fa-circle-o', 1501);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('4028946a5a169e66015a17f29cf6008e', '2c90c28158757420015875ae474600a9', '法人信用报告', 'hallReport/toReportPrintList.action', 'fa fa-circle-o', 2005);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('4028946a5a169e66015a17f3629b0095', '2c90c28158757420015875ae474600a9', '自然人信用报告', 'hallPReport/toReportPrintList.action', 'fa fa-circle-o', 2010);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875a40a75006e', '2c90c2815875742001587598fda00058', '法人信用报告审核', 'creditReport/toReportList.action', 'fa fa-circle-o', 1500);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c93ca8159a6814a0159a68370270008', '2c90c2815875742001587598fda00058', '自然人信用报告审核', 'creditPReport/toReportList.action', 'fa fa-circle-o', 1501);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c281587574200158757811750011', 'ROOT_2', '异议申诉审核', 'govObjection/toObjectionList.action', 'icon-speech', 20);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c2815875742001587578c8ba0016', 'ROOT_2', '信用修复审核', 'govRepair/toRepairList.action', 'icon-flag', 25);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875af9dd900b5', '2c90c28158757420015875ada135009f', '异议申诉申请', 'hallObjection/toObjectionApply.action', 'fa fa-circle-o', 1005);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875b0521f00ba', '2c90c28158757420015875ada135009f', '信用修复申请', 'hallRepair/toRepairApply.action', 'fa fa-circle-o', 1010);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875a4de210074', '2c90c2815875742001587598fda00058', '异议申诉审核', 'centerObjection/toObjectionList.action', 'fa fa-circle-o', 1505);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875b1ced000c6', '2c90c28158757420015875addca500a4', '异议申诉查询', 'hallObjection/toObjectionList.action', 'fa fa-circle-o', 1505);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875b25d6f00cc', '2c90c28158757420015875addca500a4', '信用修复查询', 'hallRepair/toRepairList.action', 'fa fa-circle-o', 1510);
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875a5990a0079', '2c90c2815875742001587598fda00058', '信用修复审核', 'centerRepair/toRepairList.action', 'fa fa-circle-o', 1510);

-- 权限
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875c6f68f0141', '2c90c28158757420015875aec1f100af', 'credit.report.apply', '法人信用报告申请', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85996651f015996b13232002a', '402894f85996651f015996afaa360016', 'p.report.apply', '自然人信用报告申请', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875c86a530155', '2c90c28158757420015875b12f5700c0', 'report.apply.read', '信用报告申请查询及报告查看', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875d1076c01cb', '2c90c28158757420015875a40a75006e', 'credit.reportList.audit', '信用报告审核列表', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('4028498158d36f1f0158d37c167b0008', '2c90c28158757420015875a40a75006e', 'credit.report.data.query', '信用报告数据查询', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c93ca8159a6814a0159a68636310012', '2c93ca8159a6814a0159a68370270008', 'credit.p.reportList', '自然人信用报告审核列表', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c93ca8159a6814a0159a68762e7001c', '2c93ca8159a6814a0159a68370270008', 'credit.p.report.data', '自然人信用报告数据获取', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('4028946a58b849670158b85113d4001e', '2c90c28158757420015875aec1f100af', 'credit.report.apply.print', '法人信用报告申请单打印', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85996651f015996b18cfa0034', '402894f85996651f015996afaa360016', 'p.report.apply.print', '自然人信用报告申请单打印', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85996651f015996b1ff3d0039', '402894f85996651f015996b03903001b', 'p.report.apply.read', '自然人信用报告申请及报告查询', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('4028946a5a169e66015a17f415c100a4', '4028946a5a169e66015a17f29cf6008e', 'report.print', '信用报告打印列表', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('4028946a5a169e66015a17f4e10600b0', '4028946a5a169e66015a17f3629b0095', 'p.report.print', '自然人信用报告打印列表', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c5ac990130', '2c90c28158757420015875af9dd900b5', 'hallObjection.apply', '法人异议申诉申请', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c6c3e3013c', '2c90c28158757420015875af9dd900b5', 'hallObjection.print', '异议申诉申请打印', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c7e2230146', '2c90c28158757420015875b0521f00ba', 'hallRepair.apply', '法人信用修复申请', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c84728014b', '2c90c28158757420015875b0521f00ba', 'hallRepair.print', '信用修复申请打印', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c910b4015a', '2c90c28158757420015875b1ced000c6', 'hallObjection.list', '异议申诉部门查看', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c9b2bc0161', '2c90c28158757420015875b25d6f00cc', 'hallRepair.list', '修复申诉查看', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875cfd14501b4', '2c90c28158757420015875a5990a0079', 'centerRepair.list', '信用修复中心审核', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875d05b4301bd', '2c90c28158757420015875a4de210074', 'centerObjection.list', '异议申诉审核', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee58d6db230158d71cad9b0093', '2c90c28158757420015875a4de210074', 'centerObjection.amend', '异议申诉修正', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee58aa11540158aa17b785002b', '2c90c281587574200158757811750011', 'govObjection.list', '异议申诉部门审核', null, null, null, null, null);
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee58b964c60158b966933f0013', '2c90c2815875742001587578c8ba0016', 'govRepair.list', '信用修复部门审核', null, null, null, null, null);

-- 角色赋权限
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c6f68f0141');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c6f68f0141');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '402894f85996651f015996b13232002a');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85996651f015996b13232002a');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c86a530155');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c86a530155');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875d1076c01cb');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875d1076c01cb');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '4028498158d36f1f0158d37c167b0008');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '4028498158d36f1f0158d37c167b0008');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '2c93ca8159a6814a0159a68636310012');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c93ca8159a6814a0159a68636310012');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '2c93ca8159a6814a0159a68762e7001c');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c93ca8159a6814a0159a68762e7001c');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '4028946a58b849670158b85113d4001e');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '4028946a58b849670158b85113d4001e');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '402894f85996651f015996b18cfa0034');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85996651f015996b18cfa0034');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '402894f85996651f015996b1ff3d0039');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85996651f015996b1ff3d0039');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '4028946a5a169e66015a17f415c100a4');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '4028946a5a169e66015a17f415c100a4');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b5501587622bd340011', '4028946a5a169e66015a17f4e10600b0');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '4028946a5a169e66015a17f4e10600b0');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c5ac990130');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c6c3e3013c');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c7e2230146');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c84728014b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c910b4015a');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c9b2bc0161');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875cfd14501b4');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875d05b4301bd');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee58d6db230158d71cad9b0093');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ee58aa11540158aa17b785002b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ee58b964c60158b966933f0013');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c5ac990130');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c6c3e3013c');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c7e2230146');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c84728014b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c910b4015a');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c9b2bc0161');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875cfd14501b4');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875d05b4301bd');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee58aa11540158aa17b785002b');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee58b964c60158b966933f0013');
insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee58d6db230158d71cad9b0093');

-- 字典
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('4028946a58bd15200158bd4685560008', 'applyReportPurpose', '法人申请信用报告用途', '法人申请信用报告用途');
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('2c93ca815996ea9801599753b2120038', '4028946a58bd15200158bd4685560008', '0', '专项资金', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('2c93ca815996ea9801599753b2120039', '4028946a58bd15200158bd4685560008', '2', '评优评先', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('2c93ca815996ea9801599753b212003a', '4028946a58bd15200158bd4685560008', '1', '招投标', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('2c93ca815996ea9801599753b212003b', '4028946a58bd15200158bd4685560008', '3', '其它', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b212003c', '4028946a58bd15200158bd4685560008', '4', '资质认定', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b212003d', '4028946a58bd15200158bd4685560008', '5', '财政专项申报', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b212003e', '4028946a58bd15200158bd4685560008', '6', '申请医保定点', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b212003f', '4028946a58bd15200158bd4685560008', '7', '商业贷款', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b2120040', '4028946a58bd15200158bd4685560008', '8', '信用调查', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b2120041', '4028946a58bd15200158bd4685560008', '9', '信用管理贯标', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b2120042', '4028946a58bd15200158bd4685560008', '10', '信用示范创建', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b2120043', '4028946a58bd15200158bd4685560008', '11', '信用审核', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b2120044', '4028946a58bd15200158bd4685560008', '12', '企业收购', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c93ca815996ea9801599753b2120045', '4028946a58bd15200158bd4685560008', '13', '项目申报', null);

insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('2c93ca815996ea9801599753879b0032', 'applyPReportPurpose', '自然人申请报告用途', '自然人申请报告用途');
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('2c93ca815996ea9801599753879b0033', '2c93ca815996ea9801599753879b0032', '1', '其他', null);
insert into SYS_DICTIONARY (id, group_id, dict_key, dict_value, dict_order)
values ('2c93ca815996ea9801599753879b0034', '2c93ca815996ea9801599753879b0032', '0', '信用审核', null);

-- 信用核查  表语句
drop table DT_CREDIT_EXAMINE cascade constraints;
drop table DT_CREDIT_EXAMINE_HIS cascade constraints;
drop table DT_ENTERPRISE_EXAMINE cascade constraints;
create table DT_CREDIT_EXAMINE
(
  id                VARCHAR2(50) not null,
  scxxl             VARCHAR2(200),
  scmc              VARCHAR2(200),
  scsm              VARCHAR2(1000),
  status            VARCHAR2(4),
  apply_date        DATE,
  sys_user_id       VARCHAR2(50),
  sys_department_id VARCHAR2(50),
  bjbh              VARCHAR2(50)
);
comment on table DT_CREDIT_EXAMINE
  is '法人信用核查申请表';
comment on column DT_CREDIT_EXAMINE.id
  is '主键';
comment on column DT_CREDIT_EXAMINE.scxxl
  is '审查信息类';
comment on column DT_CREDIT_EXAMINE.scmc
  is '审查名称';
comment on column DT_CREDIT_EXAMINE.scsm
  is '审查说明';
comment on column DT_CREDIT_EXAMINE.status
  is '审核状态   待审核("0"), 审核不通过("1"), 审核通过("2")';
comment on column DT_CREDIT_EXAMINE.apply_date
  is '申请时间';
comment on column DT_CREDIT_EXAMINE.sys_user_id
  is '申请人';
comment on column DT_CREDIT_EXAMINE.sys_department_id
  is '审查需求部门';
comment on column DT_CREDIT_EXAMINE.bjbh
  is '办件编号';
alter table DT_CREDIT_EXAMINE
  add constraint DT_CREDIT_EXAMINE_PK primary key (ID);

create table DT_CREDIT_EXAMINE_HIS
(
  id                VARCHAR2(50),
  status            VARCHAR2(4),
  opinion           VARCHAR2(1000),
  audit_date        DATE,
  sys_user_id       VARCHAR2(50),
  credit_examine_id VARCHAR2(50)
);
comment on table DT_CREDIT_EXAMINE_HIS
  is '法人信用核查审核表';
comment on column DT_CREDIT_EXAMINE_HIS.status
  is '审核状态   待审核("0"), 审核不通过("1"), 审核通过("2")';
comment on column DT_CREDIT_EXAMINE_HIS.opinion
  is '审核意见';
comment on column DT_CREDIT_EXAMINE_HIS.audit_date
  is '审核时间';
comment on column DT_CREDIT_EXAMINE_HIS.sys_user_id
  is '审核人';
comment on column DT_CREDIT_EXAMINE_HIS.credit_examine_id
  is '关联信用审查申请表';
alter table DT_CREDIT_EXAMINE_HIS
  add constraint PK_DT_CREDIT_EXAMINE_HIS_ID primary key (ID);

create table DT_ENTERPRISE_EXAMINE
(
  id                VARCHAR2(50) not null,
  qymc              VARCHAR2(500),
  gszch             VARCHAR2(200),
  zzjgdm            VARCHAR2(200),
  credit_examine_id VARCHAR2(50),
  bjbh              VARCHAR2(200),
  shxydm            VARCHAR2(100)
);
comment on table DT_ENTERPRISE_EXAMINE
  is '导入的需要核查的企业信息表';
comment on column DT_ENTERPRISE_EXAMINE.id
  is '主键';
comment on column DT_ENTERPRISE_EXAMINE.qymc
  is '企业名称';
comment on column DT_ENTERPRISE_EXAMINE.gszch
  is '工商注册号';
comment on column DT_ENTERPRISE_EXAMINE.zzjgdm
  is '组织机构代码';
comment on column DT_ENTERPRISE_EXAMINE.credit_examine_id
  is '关联信用审查申请表';
comment on column DT_ENTERPRISE_EXAMINE.bjbh
  is '办件编号';
comment on column DT_ENTERPRISE_EXAMINE.shxydm
  is '社会信用代码';
alter table DT_ENTERPRISE_EXAMINE
  add constraint PK_ENTERPRISE_EXAMINE primary key (ID);
alter table DT_ENTERPRISE_EXAMINE
  add constraint FK_ENTERPRISE_EXAMINE foreign key (CREDIT_EXAMINE_ID)
  references DT_CREDIT_EXAMINE (ID) on delete cascade;

-- 信用核查 菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281587574200158757500850008', 'ROOT_2', '信用核查', null, 'icon-shield', 15);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281587574200158759cd7a2005d', 'ROOT_1', '信用核查', null, 'icon-shield', 20);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85986ff2d01598708c772003a', '2c90c281587574200158759cd7a2005d', '信用核查上传', '/center/creditCheck/creditCheckUpload.action', 'fa fa-circle-o', 2000);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875a7090c007f', '2c90c281587574200158759cd7a2005d', '信用核查审核', '/center/creditCheck/toCreditExamineList.action', 'fa fa-circle-o', 1000);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875885e000030', '2c90c281587574200158757500850008', '信用核查申请', '/gov/creditCheck/toApply.action', 'fa fa-circle-o', 1500);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281587574200158758946380035', '2c90c281587574200158757500850008', '信用核查列表', '/gov/creditCheck/toHisQuery.action', 'fa fa-circle-o', 1505);

-- 信用核查 权限
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85986ff2d0159870ac3770062', '402894f85986ff2d01598708c772003a', 'center.creditCheck.upload', '信用核查上传', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f8598c5c6001598c664fe10009', '402894f85986ff2d01598708c772003a', 'center.creditCheckUpload.report', '信用核查上传生成报告', '信用核查上传生成报告', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875cae9f3016f', '2c90c28158757420015875a7090c007f', 'center.creditCheck.examine', '信用核查审核', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f858b954f20158b95beba20008', '2c90c28158757420015875a7090c007f', 'center.creditCheck.examineList', '信用核查审核列表', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875c278a60117', '2c90c28158757420015875885e000030', 'gov.creditCheck.apply', '信用核查申请', '发起核查申请', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875c35d460121', '2c90c281587574200158758946380035', 'gov.creditCheck.HisQuery', '信用核查历史查询', '信用核查历史查询', null, null, null, null);


-- 信用核查 角色权限关联表
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f85986ff2d0159870ac3770062');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85986ff2d0159870ac3770062');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f8598c5c6001598c664fe10009');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f8598c5c6001598c664fe10009');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875cae9f3016f');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875cae9f3016f');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f858b954f20158b95beba20008');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f858b954f20158b95beba20008');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('40289454547b159d01547b1efe25000c', '2c90c28158757420015875c278a60117');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c278a60117');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('40289454547b159d01547b1efe25000c', '2c90c28158757420015875c35d460121');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c35d460121');


-- 公示管理 菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85991695a01599170dae2000a', 'ROOT_1', '公示管理', null, 'icon-book-open', 33);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85991695a015991722bbe0015', '402894f85991695a01599170dae2000a', '行政许可公示', '/center/publicity/toLicensingList.action', 'fa fa-circle-o', 50);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85991695a015991736d4a001e', '402894f85991695a01599170dae2000a', '行政处罚公示', '/center/publicity/toPenaltyList.action', 'fa fa-circle-o', 60);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85a06b861015a06dde50d000d', '402894f85991695a01599170dae2000a', '红榜公示', '/center/publicity/toRedList.action', 'fa fa-circle-o', 70);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85a06b861015a0795425d002f', '402894f85991695a01599170dae2000a', '黑榜公示', '/center/publicity/toBlackList.action', 'fa fa-circle-o', 80);

-- 公示管理 权限
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85991695a01599174cb7d002c', '402894f85991695a015991722bbe0015', 'center.publicity.licensing', '行政许可公示', '行政许可公示权限', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85991695a01599176e4cb0043', '402894f85991695a015991736d4a001e', 'center.publicity.penalty', '行政处罚公示', '行政处罚公示权限', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85a06b861015a07a9ea38004a', '402894f85a06b861015a06dde50d000d', 'center.publicity.toRedList', '红榜公示', '红榜公示权限', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85a06b861015a07a952650044', '402894f85a06b861015a0795425d002f', 'center.publicity.toBlackList', '黑榜公示', '黑榜公示权限', null, null, null, null);


-- 公示管理 角色权限关联表
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f85991695a01599174cb7d002c');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85991695a01599174cb7d002c');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f85991695a01599176e4cb0043');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85991695a01599176e4cb0043');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f85a06b861015a07a9ea38004a');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85a06b861015a07a9ea38004a');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f85a06b861015a07a952650044');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85a06b861015a07a952650044');

--行政权力目录删表、建表
drop table LD_XZQLML cascade constraints;

/*==============================================================*/
/* Table: LD_XZQLML                                             */
/*==============================================================*/
create table LD_XZQLML 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(1),
   QL_CODE              VARCHAR2(50),
   QL_TYPE              VARCHAR2(2),
   QL_NAME              VARCHAR2(100),
   DEPT_ID              VARCHAR2(50),
   ACCORDING            VARCHAR2(4000),
   XZXDR_TYPE           VARCHAR2(2),
   CREATE_TIME          DATE
);

comment on table LD_XZQLML is
'行政权力目录';

comment on column LD_XZQLML.ID is
'主键';

comment on column LD_XZQLML.STATUS is
'状态（1启用，0禁用）';

comment on column LD_XZQLML.QL_CODE is
'权力编码';

comment on column LD_XZQLML.QL_TYPE is
'权力类型';

comment on column LD_XZQLML.QL_NAME is
'权力名称';

comment on column LD_XZQLML.DEPT_ID is
'实施主体（默认登录部门）';

comment on column LD_XZQLML.ACCORDING is
'实施依据';

comment on column LD_XZQLML.XZXDR_TYPE is
'法人和其他组织、自然人、法人和其他组织或自然人';

comment on column LD_XZQLML.CREATE_TIME is
'创建时间';

--政务端行政权力目录
--菜单
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894b65e1db21e015e1db56ebd0007', 'ROOT_2', '行政权力目录', '/executivePower/toExecutivePowerList.action', 'icon-bulb', 1502);

--权限
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894b65e1db21e015e1db67f97000a', '402894b65e1db21e015e1db56ebd0007', 'gov.power.list', '政务端行政权力目录查询', null, null, null, null, null);

--角色权限表
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894b65e1db21e015e1db67f97000a');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894b65e1db21e015e1db67f97000a');

--中心端行政权力目录
--菜单
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894c85e27b955015e27d104550042', '402894f85991695a01599170dae2000a', '行政权力目录', '/executivePower/toExecutivePowerList.action', 'fa fa-circle-o', 1007);

--权限
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894c85e27b955015e27d1e8140046', '402894c85e27b955015e27d104550042', 'center.power.list', '中心端行政权力目录查询', null, null, null, null, null);

--角色权限表
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894c85e27b955015e27d1e8140046');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894c85e27b955015e27d1e8140046');

--字典表
--权力类别
INSERT INTO SYS_DICTIONARY_GROUP (id, group_key, group_name, description) VALUES ('402894b65e1d0732015e1d09bfa70003', 'powerType', '权力类别', '权力类别');

INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d09bfa70004','402894b65e1d0732015e1d09bfa70003','6','行政裁决',NULL);	
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d09bfa70005','402894b65e1d0732015e1d09bfa70003','4','行政强制',NULL);
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d09bfa70006','402894b65e1d0732015e1d09bfa70003','5','行政给付',NULL);	
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d09bfa70007','402894b65e1d0732015e1d09bfa70003','1','行政许可和非许可行政审批',NULL);	
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d09bfa70008','402894b65e1d0732015e1d09bfa70003','7','行政确认和其他权力',NULL);	
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d09bfa80009','402894b65e1d0732015e1d09bfa70003','3','行政征收',NULL);
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d09bfa8000a','402894b65e1d0732015e1d09bfa70003','2','行政处罚',NULL);	

--行政相对人类别
INSERT INTO SYS_DICTIONARY_GROUP (id, group_key, group_name, description) VALUES ('402894b65e1d0732015e1d0a9324000c', 'xzxdrType', '行政相对人类别', '行政相对人类别');

INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d0a9325000d','402894b65e1d0732015e1d0a9324000c','2','自然人',NULL);	
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d0a9325000e','402894b65e1d0732015e1d0a9324000c','1','法人和其他组织',NULL);
INSERT INTO SYS_DICTIONARY(ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER) VALUES('402894b65e1d0732015e1d0a9325000f','402894b65e1d0732015e1d0a9324000c','3','法人和其他组织或自然人',NULL);	

--双公示数据质量分析
--菜单
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894c45e30ded4015e30f5a202000c', '402894f85991695a01599170dae2000a', '双公示数据质量分析', '/center/publicityDataQuality/toPublicityDataQuality.action', 'fa fa-circle-o', 1006);

--权限
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894c45e30ded4015e30f6aed90013', '402894c45e30ded4015e30f5a202000c', 'center.publicityDataQuality.query', '双公示数据质量分析查询', null, null, null, null, null);

--角色权限表
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894c45e30ded4015e30f6aed90013');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894c45e30ded4015e30f6aed90013');

--数据类别增加字典项
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c9951815ea1e762015ea1eb16ec0007', '402894ee58dd73780158dd7c5c98000e', '6', '双公示行政处罚', null);
insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c9951815ea1e762015ea1eb16ec0005', '402894ee58dd73780158dd7c5c98000e', '7', '双公示行政许可', null);

--2017年法定节假日删表、建表

drop table HOLIDAY_DATE cascade constraints;

create table HOLIDAY_DATE
(
  id       VARCHAR2(50) not null,
  holidate DATE
);

insert into HOLIDAY_DATE (id, holidate)
values ('1', to_date('01-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('2', to_date('02-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('7', to_date('07-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('8', to_date('08-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('14', to_date('14-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('15', to_date('15-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('21', to_date('21-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('27', to_date('27-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('28', to_date('28-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('29', to_date('29-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('30', to_date('30-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('31', to_date('31-01-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('32', to_date('01-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('33', to_date('02-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('36', to_date('05-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('42', to_date('11-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('43', to_date('12-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('49', to_date('18-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('50', to_date('19-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('56', to_date('25-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('57', to_date('26-02-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('63', to_date('04-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('64', to_date('05-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('70', to_date('11-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('71', to_date('12-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('77', to_date('18-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('78', to_date('19-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('84', to_date('25-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('85', to_date('26-03-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('92', to_date('02-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('93', to_date('03-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('94', to_date('04-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('98', to_date('08-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('99', to_date('09-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('105', to_date('15-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('106', to_date('16-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('112', to_date('22-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('113', to_date('23-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('119', to_date('29-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('120', to_date('30-04-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('121', to_date('01-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('126', to_date('06-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('127', to_date('07-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('133', to_date('13-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('134', to_date('14-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('140', to_date('20-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('141', to_date('21-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('148', to_date('28-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('149', to_date('29-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('150', to_date('30-05-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('154', to_date('03-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('155', to_date('04-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('161', to_date('10-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('162', to_date('11-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('168', to_date('17-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('169', to_date('18-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('175', to_date('24-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('176', to_date('25-06-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('182', to_date('01-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('183', to_date('02-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('189', to_date('08-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('190', to_date('09-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('196', to_date('15-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('197', to_date('16-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('203', to_date('22-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('204', to_date('23-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('210', to_date('29-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('211', to_date('30-07-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('217', to_date('05-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('218', to_date('06-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('224', to_date('12-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('225', to_date('13-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('231', to_date('19-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('232', to_date('20-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('238', to_date('26-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('239', to_date('27-08-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('245', to_date('02-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('246', to_date('03-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('252', to_date('09-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('253', to_date('10-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('259', to_date('16-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('260', to_date('17-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('266', to_date('23-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('267', to_date('24-09-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('274', to_date('01-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('275', to_date('02-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('276', to_date('03-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('277', to_date('04-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('278', to_date('05-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('279', to_date('06-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('280', to_date('07-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('281', to_date('08-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('287', to_date('14-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('288', to_date('15-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('294', to_date('21-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('295', to_date('22-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('301', to_date('28-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('302', to_date('29-10-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('308', to_date('04-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('309', to_date('05-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('315', to_date('11-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('316', to_date('12-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('322', to_date('18-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('323', to_date('19-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('329', to_date('25-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('330', to_date('26-11-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('336', to_date('02-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('337', to_date('03-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('343', to_date('09-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('344', to_date('10-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('350', to_date('16-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('351', to_date('17-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('357', to_date('23-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('358', to_date('24-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('364', to_date('30-12-2017', 'dd-mm-yyyy'));
insert into HOLIDAY_DATE (id, holidate)
values ('365', to_date('31-12-2017', 'dd-mm-yyyy'));
-- 2018年节假日
insert into holiday_date (ID, HOLIDATE)
values ('500', to_date('01-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('501', to_date('06-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('502', to_date('07-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('503', to_date('13-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('504', to_date('14-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('505', to_date('20-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('506', to_date('21-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('507', to_date('27-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('508', to_date('28-01-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('509', to_date('03-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('510', to_date('04-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('511', to_date('10-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('512', to_date('15-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('513', to_date('16-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('514', to_date('17-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('515', to_date('18-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('516', to_date('19-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('517', to_date('20-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('518', to_date('21-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('519', to_date('25-02-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('520', to_date('03-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('521', to_date('04-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('522', to_date('10-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('523', to_date('11-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('524', to_date('17-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('525', to_date('18-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('526', to_date('24-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('527', to_date('25-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('528', to_date('31-03-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('529', to_date('01-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('530', to_date('05-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('531', to_date('06-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('532', to_date('07-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('533', to_date('14-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('534', to_date('15-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('535', to_date('21-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('536', to_date('22-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('537', to_date('29-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('538', to_date('30-04-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('539', to_date('01-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('540', to_date('05-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('541', to_date('06-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('542', to_date('12-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('543', to_date('13-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('544', to_date('19-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('545', to_date('20-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('546', to_date('26-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('547', to_date('27-05-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('548', to_date('02-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('549', to_date('03-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('550', to_date('09-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('551', to_date('10-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('552', to_date('16-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('553', to_date('17-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('554', to_date('18-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('555', to_date('23-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('556', to_date('24-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('557', to_date('30-06-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('558', to_date('01-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('559', to_date('07-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('560', to_date('08-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('561', to_date('14-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('562', to_date('15-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('563', to_date('21-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('564', to_date('22-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('565', to_date('28-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('566', to_date('29-07-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('567', to_date('04-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('568', to_date('05-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('569', to_date('11-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('570', to_date('12-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('571', to_date('18-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('572', to_date('19-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('573', to_date('25-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('574', to_date('26-08-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('575', to_date('01-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('576', to_date('02-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('577', to_date('08-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('578', to_date('09-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('579', to_date('15-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('580', to_date('16-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('581', to_date('22-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('582', to_date('23-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('583', to_date('24-09-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('584', to_date('01-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('585', to_date('02-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('586', to_date('03-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('587', to_date('04-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('588', to_date('05-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('589', to_date('06-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('590', to_date('07-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('591', to_date('13-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('592', to_date('14-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('593', to_date('20-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('594', to_date('21-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('595', to_date('27-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('596', to_date('28-10-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('597', to_date('03-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('598', to_date('04-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('599', to_date('10-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('600', to_date('11-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('601', to_date('17-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('602', to_date('18-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('603', to_date('24-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('604', to_date('25-11-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('605', to_date('01-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('606', to_date('02-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('607', to_date('08-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('608', to_date('09-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('609', to_date('15-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('610', to_date('16-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('611', to_date('22-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('612', to_date('23-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('613', to_date('29-12-2018', 'dd-mm-yyyy'));

insert into holiday_date (ID, HOLIDATE)
values ('614', to_date('30-12-2018', 'dd-mm-yyyy'));


--根据输入日期往后推7天工作日
create or replace function FindWorkDate(inputdate in date) return varchar as
  date2 date;
  date3 date;
  i     number;
begin
  i     := 0;
  date2 := inputdate;
  while (i < 7) loop
   
    begin
      select HOLIDATE into date3 from holiday_Date where   date2 >= to_date(to_char(holidate,'yyyy-MM-dd')||' 00:00:00','yyyy-MM-dd hh24:mi:ss') and date2 <= to_date(to_char(holidate,'yyyy-MM-dd')||' 23:59:59','yyyy-MM-dd hh24:mi:ss');
    exception
      when NO_DATA_FOUND then
        date3 := null;
    end;
    if date3 is null then
      i := i + 1;
    end if;
    
    date2 := date2 + 1;
    
  end loop;
  return date2;
end;
/

commit;


/* 信用报告操作日志表 */
DROP TABLE DT_CREDIT_REPORT_OPERATION_LOG CASCADE CONSTRAINTS;

CREATE TABLE DT_CREDIT_REPORT_OPERATION_LOG
(
  REPORT_OP_ID         VARCHAR2(50) NOT NULL,
  APPLY_ID             VARCHAR2(50),
  BUSINESS_NAME        VARCHAR2(50),
  OPERATION_DATE       DATE,
  OPERATION_USER_ID    VARCHAR2(50),
  REMARK               VARCHAR2(500)
);

/* Comments */
COMMENT ON TABLE  DT_CREDIT_REPORT_OPERATION_LOG IS '信用报告操作日志表';
COMMENT ON COLUMN DT_CREDIT_REPORT_OPERATION_LOG.REPORT_OP_ID IS '主键';
COMMENT ON COLUMN DT_CREDIT_REPORT_OPERATION_LOG.APPLY_ID IS '信用报告申请id';
COMMENT ON COLUMN DT_CREDIT_REPORT_OPERATION_LOG.BUSINESS_NAME IS '业务类型名称';
COMMENT ON COLUMN DT_CREDIT_REPORT_OPERATION_LOG.REMARK IS '备注（审核意见）';
COMMENT ON COLUMN DT_CREDIT_REPORT_OPERATION_LOG.OPERATION_DATE IS '操作时间';
COMMENT ON COLUMN DT_CREDIT_REPORT_OPERATION_LOG.OPERATION_USER_ID IS '操作人id';
alter table DT_CREDIT_REPORT_OPERATION_LOG
  add primary key (REPORT_OP_ID);
  
-- 添加  信用报告字体大小配置表
alter table ST_REPORT_FONT_SIZE_CONFIG
   drop primary key cascade;

drop table ST_REPORT_FONT_SIZE_CONFIG cascade constraints;

/*==============================================================*/
/* Table: ST_REPORT_FONT_SIZE_CONFIG                            */
/*==============================================================*/
create table ST_REPORT_FONT_SIZE_CONFIG 
(
   ID                   VARCHAR2(50)         default sys_guid() not null,
   COVER_BGBH           NUMBER(2),
   COVER_TITLE          NUMBER(2),
   COVER_SIGN           NUMBER(2),
   COVER_DATE           NUMBER(2),
   MAIN_BODY            NUMBER(2),
   MAIN_BODY_TITLE      NUMBER(2),
   TH                   NUMBER(2),
   TD                   NUMBER(2),
   CREATE_DATE          DATE                 default sysdate
);

comment on table ST_REPORT_FONT_SIZE_CONFIG is
'信用报告字体大小配置表';

comment on column ST_REPORT_FONT_SIZE_CONFIG.ID is
'主键';

comment on column ST_REPORT_FONT_SIZE_CONFIG.COVER_BGBH is
'封面报告编号';

comment on column ST_REPORT_FONT_SIZE_CONFIG.COVER_TITLE is
'封面标题';

comment on column ST_REPORT_FONT_SIZE_CONFIG.COVER_SIGN is
'封面签章';

comment on column ST_REPORT_FONT_SIZE_CONFIG.COVER_DATE is
'封面日期';

comment on column ST_REPORT_FONT_SIZE_CONFIG.MAIN_BODY is
'正文';

comment on column ST_REPORT_FONT_SIZE_CONFIG.MAIN_BODY_TITLE is
'正文标题';

comment on column ST_REPORT_FONT_SIZE_CONFIG.TH is
'列表头';

comment on column ST_REPORT_FONT_SIZE_CONFIG.TD is
'列表内容';

comment on column ST_REPORT_FONT_SIZE_CONFIG.CREATE_DATE is
'创建时间';

alter table ST_REPORT_FONT_SIZE_CONFIG
   add constraint PK_ST_REPORT_FONT_SIZE_CONFIG primary key (ID);
   
--初始化报告生成pdf需要的字体配置
insert into ST_REPORT_FONT_SIZE_CONFIG (ID, COVER_BGBH, COVER_TITLE, COVER_SIGN, COVER_DATE, MAIN_BODY, MAIN_BODY_TITLE, TH, TD, CREATE_DATE)
values ('CAA699928D3D443B80734E08C2AE90A2', 15, 37, 16, 14, 13, 14, 12, 11, to_date('04-09-2017 10:59:49', 'dd-mm-yyyy hh24:mi:ss'));



------------------------------------------- 双公示（许可、处罚） START -------------------------------------------
ALTER TABLE YW_L_SGSXZXK MODIFY STATUS DEFAULT 1;
COMMENT ON COLUMN YW_L_SGSXZXK.STATUS IS '状态（1：公示中，9：取消公示）';

COMMENT ON COLUMN YW_L_SGSXZXK.ZZJGDM IS '行政相对人代码＿2（组织机构代码）';
COMMENT ON COLUMN YW_L_SGSXZXK.GSZCH IS '行政相对人代码＿3（工商登记码）';
COMMENT ON COLUMN YW_L_SGSXZXK.TYSHXYDM IS '行政相对人代码＿1（统一社会信用代码）';
COMMENT ON COLUMN YW_L_SGSXZXK.SWDJH IS '行政相对人代码＿4（税务登记码）';
COMMENT ON COLUMN YW_L_SGSXZXK.FDDBRSFZH IS '行政相对人代码＿5（居民身份证号）';
COMMENT ON COLUMN YW_L_SGSXZXK.XKSXQ IS '许可决定日期';

ALTER TABLE YW_L_SGSXZCF MODIFY STATUS DEFAULT 1;
COMMENT ON COLUMN YW_L_SGSXZCF.STATUS IS '状态（1：公示中，9：取消公示）';

ALTER TABLE YW_L_SGSXZCF ADD CFLB2 VARCHAR2(200) NULL;
COMMENT ON COLUMN YW_L_SGSXZCF.CFLB2 IS '处罚类别2';
COMMENT ON COLUMN YW_L_SGSXZCF.ZZJGDM IS '行政相对人代码_2 (组织机构代码)';
COMMENT ON COLUMN YW_L_SGSXZCF.GSZCH IS '行政相对人代码_3 (工商登记码)';
COMMENT ON COLUMN YW_L_SGSXZCF.TYSHXYDM IS '行政相对人代码_1 (统一社会信用代码)';
COMMENT ON COLUMN YW_L_SGSXZCF.CFJDSWH IS '行政处罚决定书文号';
COMMENT ON COLUMN YW_L_SGSXZCF.AJMC IS '处罚名称';
COMMENT ON COLUMN YW_L_SGSXZCF.CFZL IS '处罚类别1';
COMMENT ON COLUMN YW_L_SGSXZCF.FDDBRMC IS '法定代表人姓名';
COMMENT ON COLUMN YW_L_SGSXZCF.FDDBRSFZH IS '行政相对人代码_5 (居民身份证号)';
COMMENT ON COLUMN YW_L_SGSXZCF.CFJGMC IS '处罚机关';
COMMENT ON COLUMN YW_L_SGSXZCF.XZXDRSWDJH IS '行政相对人代码_4 (税务登记号)';

------------------------------------------- 双公示（许可、处罚） END -------------------------------------------

------------------------------------------- 信用核查 start -------------------------------------------

-- 信用核查记录表添加起止时间
alter table DT_CREDIT_EXAMINE add SCSJ_START DATE;
COMMENT ON COLUMN "DT_CREDIT_EXAMINE"."SCSJ_START" IS '审查开始时间';
alter table DT_CREDIT_EXAMINE add SCSJ_END DATE;
COMMENT ON COLUMN "DT_CREDIT_EXAMINE"."SCSJ_END" IS '审查结束时间';

update sys_menu t set t.menu_name = '信用审查' where t.sys_menu_id = '2c90c281587574200158757500850008';
update sys_menu t set t.menu_name = '信用审查' where t.sys_menu_id = '2c90c281587574200158759cd7a2005d';
update sys_menu t set t.menu_name = '信用审查上传' where t.sys_menu_id = '402894f85986ff2d01598708c772003a';
update sys_menu t set t.menu_name = '信用审查审核' where t.sys_menu_id = '2c90c28158757420015875a7090c007f';
update sys_menu t set t.menu_name = '信用审查申请' where t.sys_menu_id = '2c90c28158757420015875885e000030';
update sys_menu t set t.menu_name = '信用审查查询' where t.sys_menu_id = '2c90c281587574200158758946380035';
------------------------------------------- 信用核查 END -------------------------------------------

-------------------- 修改公示表结构、注释 start------------------------------------------
COMMENT ON COLUMN YW_L_SGSXZCF.DQZT IS '0=正常（公示中），1=撤销（取消公示），2=异议，3=其他';
COMMENT ON COLUMN YW_L_SGSXZXK.DQZT IS '0=正常（公示中），1=撤销（取消公示），2=异议，3=其他';
COMMENT ON COLUMN YW_L_SGSXZCF.STATUS IS '数据状态（未整合("0"), 已整合("1"), 已修复("2"), 已删除("3"), 已修正("4")）';
COMMENT ON COLUMN YW_L_SGSXZXK.STATUS IS '数据状态（未整合("0"), 已整合("1"), 已修复("2"), 已删除("3"), 已修正("4")）';

ALTER TABLE YW_L_HONGMINGDAN ADD DQZT VARCHAR2(2) DEFAULT 1 NOT NULL;
COMMENT ON COLUMN YW_L_HONGMINGDAN.DQZT IS '1=待公示，2=公示中，3=已公示';
COMMENT ON COLUMN YW_L_HONGMINGDAN.STATUS IS '数据状态（未整合("0"), 已整合("1"), 已修复("2"), 已删除("3"), 已修正("4")）';
ALTER TABLE YW_L_HEIMINGDAN ADD DQZT VARCHAR2(2) DEFAULT 1 NOT NULL;
COMMENT ON COLUMN YW_L_HEIMINGDAN.DQZT IS '1=待公示，2=公示中，3=已公示';
COMMENT ON COLUMN YW_L_HEIMINGDAN.STATUS IS '数据状态（未整合("0"), 已整合("1"), 已修复("2"), 已删除("3"), 已修正("4")）';
-------------------- 修改公示表结构、注释 end------------------------------------------

-------------------- 公示表数据 状态值更新 start------------------------------------------
UPDATE YW_L_HONGMINGDAN set DQZT = '1' where STATUS = '1';
UPDATE YW_L_HONGMINGDAN set DQZT = '2' where STATUS = '2';
UPDATE YW_L_HONGMINGDAN set DQZT = '3' where STATUS = '3';
UPDATE YW_L_HEIMINGDAN set DQZT = '1' where STATUS = '1';
UPDATE YW_L_HEIMINGDAN set DQZT = '2' where STATUS = '2';
UPDATE YW_L_HEIMINGDAN set DQZT = '3' where STATUS = '3';

UPDATE YW_L_SGSXZXK set DQZT = '1' where STATUS = '9';
UPDATE YW_L_SGSXZXK set DQZT = '0' where STATUS <> '9' AND DQZT is null;
UPDATE YW_L_SGSXZXK set STATUS = '1' where STATUS = '9';

UPDATE YW_L_SGSXZCF set DQZT = '1' where STATUS = '9';
UPDATE YW_L_SGSXZCF set DQZT = '0' where STATUS <> '9' AND DQZT is null;
UPDATE YW_L_SGSXZCF set STATUS = '1' where STATUS = '9';
-------------------- 公示表数据 状态值更新 start------------------------------------------

-------------------------------------------- 信用审查 start------------------------------------------
-- 创建自然人信用审查申请表
DROP TABLE DT_CREDIT_EXAMINE_P CASCADE CONSTRAINTS;
CREATE TABLE DT_CREDIT_EXAMINE_P
(
  ID                VARCHAR2(50) NOT NULL,
  SCXXL             VARCHAR2(200),
  SCMC              VARCHAR2(200),
  SCSM              VARCHAR2(1000),
  STATUS            VARCHAR2(4),
  APPLY_DATE        DATE,
  SYS_USER_ID       VARCHAR2(50),
  SYS_DEPARTMENT_ID VARCHAR2(50),
  BJBH              VARCHAR2(50),
  SCSJ_START        DATE,
  SCSJ_END        DATE
);
COMMENT ON TABLE DT_CREDIT_EXAMINE_P IS '自然人信用审查申请表';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.ID IS '主键';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.SCXXL IS '审查信息类';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.SCMC IS '审查名称';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.SCSM IS '审查说明';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.STATUS IS '审核状态 待审核("0"), 审核不通过("1"), 审核通过("2")';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.APPLY_DATE IS '申请时间';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.SYS_USER_ID IS '申请人';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.SYS_DEPARTMENT_ID IS '审查需求部门';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.BJBH IS '办件编号';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.SCSJ_START IS '审查开始时间';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_P.SCSJ_END IS '审查结束时间';
ALTER TABLE DT_CREDIT_EXAMINE_P ADD CONSTRAINT DT_CREDIT_EXAMINE_P_PK PRIMARY KEY (ID);

-- 创建自然人信用审查审核表
DROP TABLE DT_CREDIT_EXAMINE_HIS_P CASCADE CONSTRAINTS;
CREATE TABLE DT_CREDIT_EXAMINE_HIS_P
(
  ID                VARCHAR2(50) NOT NULL,
  STATUS            VARCHAR2(4),
  OPINION           VARCHAR2(1000),
  AUDIT_DATE        DATE,
  SYS_USER_ID       VARCHAR2(50),
  CREDIT_EXAMINE_P_ID VARCHAR2(50)
);
COMMENT ON TABLE DT_CREDIT_EXAMINE_HIS_P IS '自然人信用审查审核表';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_HIS_P.STATUS IS '审核状态 待审核("0"), 审核不通过("1"), 审核通过("2")';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_HIS_P.OPINION IS '审核意见';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_HIS_P.AUDIT_DATE IS '审核时间';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_HIS_P.SYS_USER_ID IS '审核人';
COMMENT ON COLUMN DT_CREDIT_EXAMINE_HIS_P.CREDIT_EXAMINE_P_ID IS '关联自然人信用审查申请表';
ALTER TABLE DT_CREDIT_EXAMINE_HIS_P ADD CONSTRAINT PK_DT_CREDIT_EXAMINE_HIS_P_ID PRIMARY KEY (ID);

-- 创建需要审查的自然人信息表
DROP TABLE DT_PEOPLE_EXAMINE CASCADE CONSTRAINTS;
CREATE TABLE DT_PEOPLE_EXAMINE
(
  ID                VARCHAR2(50) NOT NULL,
  XM              VARCHAR2(500),
  SFZH             VARCHAR2(200),
  CREDIT_EXAMINE_P_ID VARCHAR2(50),
  BJBH              VARCHAR2(200)
);
COMMENT ON TABLE DT_PEOPLE_EXAMINE IS '导入的需要审查的自然人信息表';
COMMENT ON COLUMN DT_PEOPLE_EXAMINE.ID IS '主键';
COMMENT ON COLUMN DT_PEOPLE_EXAMINE.XM IS '姓名';
COMMENT ON COLUMN DT_PEOPLE_EXAMINE.SFZH IS '身份证号';
COMMENT ON COLUMN DT_PEOPLE_EXAMINE.CREDIT_EXAMINE_P_ID IS '关联自然人信用审查申请表';
COMMENT ON COLUMN DT_PEOPLE_EXAMINE.BJBH IS '办件编号';
ALTER TABLE DT_PEOPLE_EXAMINE ADD CONSTRAINT PK_PEOPLE_EXAMINE PRIMARY KEY (ID);
ALTER TABLE DT_PEOPLE_EXAMINE ADD CONSTRAINT FK_PEOPLE_EXAMINE FOREIGN KEY (CREDIT_EXAMINE_P_ID) REFERENCES DT_CREDIT_EXAMINE_P (ID) ON DELETE CASCADE;

-- 信用审查 菜单
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('402894f85986ff2d01598708c772003b', '2c90c281587574200158759cd7a2005d', '自然人信用审查上传', '/center/pCreditCheck/creditCheckUpload.action', 'fa fa-circle-o', 4000);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875a7090c007g', '2c90c281587574200158759cd7a2005d', '自然人信用审查审核', '/center/pCreditCheck/toCreditExamineList.action', 'fa fa-circle-o', 3000);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c28158757420015875885e000031', '2c90c281587574200158757500850008', '自然人信用审查申请', '/gov/pCreditCheck/toApply.action', 'fa fa-circle-o', 1506);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281587574200158758946380036', '2c90c281587574200158757500850008', '自然人信用审查查询', '/gov/pCreditCheck/toHisQuery.action', 'fa fa-circle-o', 1507);

-- 信用审查 权限
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f85986ff2d0159870ac3770063', '402894f85986ff2d01598708c772003b', 'center.pCreditCheck.upload', '自然人信用审查上传', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f8598c5c6001598c664fe10010', '402894f85986ff2d01598708c772003b', 'center.pCreditCheckUpload.report', '自然人信用审查上传生成报告', '自然人信用审查上传生成报告', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875cae9f3016g', '2c90c28158757420015875a7090c007g', 'center.pCreditCheck.examine', '自然人信用审查审核', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('402894f858b954f20158b95beba20009', '2c90c28158757420015875a7090c007g', 'center.pCreditCheck.examineList', '自然人信用审查审核列表', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875c278a60118', '2c90c28158757420015875885e000031', 'gov.pCreditCheck.apply', '自然人信用审查申请', '自然人发起审查申请', null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, SYS_MENU_ID, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c28158757420015875c35d460122', '2c90c281587574200158758946380036', 'gov.pCreditCheck.HisQuery', '自然人信用审查历史查询', '自然人信用审查历史查询', null, null, null, null);

-- 信用审查 角色权限关联表
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f85986ff2d0159870ac3770063');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f85986ff2d0159870ac3770063');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f8598c5c6001598c664fe10010');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f8598c5c6001598c664fe10010');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875cae9f3016g');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875cae9f3016g');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '402894f858b954f20158b95beba20009');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '402894f858b954f20158b95beba20009');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('40289454547b159d01547b1efe25000c', '2c90c28158757420015875c278a60118');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c278a60118');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('40289454547b159d01547b1efe25000c', '2c90c28158757420015875c35d460122');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c35d460122');

-- 更新原来信用审查菜单名改成 法人审查** 以区分于自然人
update SYS_MENU set menu_name = '法人信用审查上传' where menu_name = '信用审查上传';
update SYS_MENU set menu_name = '法人信用审查审核' where menu_name = '信用审查审核';
update SYS_MENU set menu_name = '法人信用审查申请' where menu_name = '信用审查申请';
update SYS_MENU set menu_name = '法人信用审查查询' where menu_name = '信用审查查询';


alter table DT_CREDIT_EXAMINE modify scxxl VARCHAR2(4000);
alter table DT_CREDIT_EXAMINE_P modify scxxl VARCHAR2(4000);
-------------------------------------------- 信用审查 end------------------------------------------


commit;