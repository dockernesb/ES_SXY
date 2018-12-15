DROP TABLE DP_WEBSERVICE_LOG CASCADE CONSTRAINTS;
drop table DP_COLLECTION_TASK cascade constraints;
drop table DP_PROCESS_RESULT cascade constraints;
drop table DP_LOGIC_TABLE cascade constraints;
drop table DP_LOGIC_COLUMN cascade constraints;
drop table DP_DATA_SIZE cascade constraints;
drop table DP_RULE cascade constraints;
drop table DP_COLUMN_RULE cascade constraints;
drop table DP_FILE_PARSE_LOG cascade constraints;
drop table DP_MULTI_REPORT_RELATION cascade constraints;
drop table DP_QRTZ_FILE_PARSE cascade constraints;
drop table DP_QRTZ_LOG cascade constraints;
drop table DP_TASK_STATUS_CHANGE_LOG cascade constraints;
drop table DP_UPLOAD_FILE cascade constraints;
drop table ETL_ENTERPRISE_TYPE_CHECKLIST cascade constraints;
drop table ETL_ERROR_CODE cascade constraints;
drop table ETL_INDUSTRY_CODE_CHECKLIST cascade constraints;
drop table ETL_ORGAN_SIGN cascade constraints;
drop table DP_ERROR_UPLOAD_FILE cascade constraints;
drop table DP_SUMMARY_INVALID_DATA cascade constraints;


create table DP_COLLECTION_TASK
(
  id                    VARCHAR2(50) not null,
  task_code             VARCHAR2(50) not null,
  task_name             VARCHAR2(100) not null,
  status                VARCHAR2(2) not null,
  taskbegin_time        DATE not null,
  taskend_time          DATE not null,
  create_time           DATE not null,
  updata_time           DATE,
  task_type             VARCHAR2(2) not null,
  logic_table_id        VARCHAR2(50) not null,
  create_user           VARCHAR2(50),
  update_user           VARCHAR2(50),
  upload_file_count     NUMBER,
  revocation_file_count NUMBER
)
;

comment on table DP_COLLECTION_TASK
  is '数据采集任务记录表';
comment on column DP_COLLECTION_TASK.id
  is '主键id';
comment on column DP_COLLECTION_TASK.task_code
  is '任务编号';
comment on column DP_COLLECTION_TASK.task_name
  is '任务名称';
comment on column DP_COLLECTION_TASK.status
  is '任务状态(0待上报 1待处理 2已处理 3待补充 4延期 5已完成)';
comment on column DP_COLLECTION_TASK.taskbegin_time
  is '任务开始时间';
comment on column DP_COLLECTION_TASK.taskend_time
  is '任务截止时间';
comment on column DP_COLLECTION_TASK.create_time
  is '创建时间';
comment on column DP_COLLECTION_TASK.updata_time
  is '更新时间';
comment on column DP_COLLECTION_TASK.task_type
  is '任务类型（0自动生成 1手工生成）';
comment on column DP_COLLECTION_TASK.logic_table_id
  is '外键（DP_LOGIC_TABLE表主键）';
comment on column DP_COLLECTION_TASK.create_user
  is '创建人';
comment on column DP_COLLECTION_TASK.update_user
  is '更新人';
comment on column DP_COLLECTION_TASK.upload_file_count
  is '上报文件数';
comment on column DP_COLLECTION_TASK.revocation_file_count
  is '撤回文件数';
alter table DP_COLLECTION_TASK
  add constraint PK_DP_COLLECTION_TASK primary key (ID);
alter table DP_COLLECTION_TASK
  add constraint U_DP_COLLECTION_TASK unique (TASK_CODE);
  
create table DP_PROCESS_RESULT
(
  id           VARCHAR2(50) default sys_guid() not null,
  type         NUMBER,
  process_size NUMBER,
  process_time DATE,
  table_code   VARCHAR2(50),
  ETL_TYPE     VARCHAR2(2),
  TASK_CODE    VARCHAR2(50),
  DEPT_ID      VARCHAR2(50)
)
;
comment on table DP_PROCESS_RESULT
  is '数据处理结果(数据质量统计页面使用)';
comment on column DP_PROCESS_RESULT.id
  is '主键';
comment on column DP_PROCESS_RESULT.type
  is '类别（1：正确，2：错误， 3：更新，4：未关联）';
comment on column DP_PROCESS_RESULT.process_size
  is '处理数据量';
comment on column DP_PROCESS_RESULT.process_time
  is '处理时间';
comment on column DP_PROCESS_RESULT.table_code
  is '目录编码（数据库实体表名）';
comment on column DP_PROCESS_RESULT.ETL_TYPE is
'kettle处理类型（0原始到有效，1有效到业务）';
comment on column DP_PROCESS_RESULT.TASK_CODE is
'批次编号（原任务编号）';
comment on column DP_PROCESS_RESULT.DEPT_ID is
'部门ID';
alter table DP_PROCESS_RESULT
  add primary key (ID);

create table DP_LOGIC_TABLE
(
  id                 VARCHAR2(50) not null,
  code               VARCHAR2(50) not null,
  name               VARCHAR2(100),
  create_id          VARCHAR2(50),
  create_time        DATE,
  update_id          VARCHAR2(50),
  update_time        DATE,
  dept_id            VARCHAR2(50),
  ds_type            NUMBER default 0,
  status             NUMBER default 1,
  mapped_code        VARCHAR2(50),
  task_period        VARCHAR2(20),
  data_category      VARCHAR2(20),
  days               NUMBER,
  table_desc 		 varchar2(2000),
  LOGIC_CLASSIFY_ID  VARCHAR2(50),
  TABLE_SORT         NUMBER(5),
  TEMPLATE_ID        VARCHAR2(50),
  person_Type          VARCHAR2(50)
)
;
 comment on table DP_LOGIC_TABLE
  is '数据目录配置表信息';
comment on column DP_LOGIC_TABLE.id
  is '主键';
comment on column DP_LOGIC_TABLE.code
  is '表名';
comment on column DP_LOGIC_TABLE.name
  is '表注释';
comment on column DP_LOGIC_TABLE.create_id
  is '创建人id';
comment on column DP_LOGIC_TABLE.create_time
  is '创建时间';
comment on column DP_LOGIC_TABLE.update_id
  is '更新人id';
comment on column DP_LOGIC_TABLE.update_time
  is '更新时间';
comment on column DP_LOGIC_TABLE.dept_id
  is '部门ID';
comment on column DP_LOGIC_TABLE.ds_type
  is '数据源类型（0文件、1数据库）';
comment on column DP_LOGIC_TABLE.status
  is '状态（1启用，0禁用）';
comment on column DP_LOGIC_TABLE.mapped_code
  is '映射关联表名（数据源为DB的表名）';
comment on column DP_LOGIC_TABLE.task_period
  is '归集周期(0周 1月 2季度 3半年 4年)';
comment on column DP_LOGIC_TABLE.data_category
  is '数据类别';
comment on column DP_LOGIC_TABLE.days
  is '上报天数';
comment on column DP_LOGIC_TABLE.table_desc
  is '目录描述';
COMMENT ON COLUMN DP_LOGIC_TABLE.LOGIC_CLASSIFY_ID IS
'数据分类ID';
COMMENT ON COLUMN DP_LOGIC_TABLE.TABLE_SORT IS
'目录排序';
COMMENT ON COLUMN DP_LOGIC_TABLE.TEMPLATE_ID IS
'数据目录模板ID';
comment on column  dp_logic_table.PERSON_TYPE  
IS '目录类型，1：自然人 0：法人';
alter table 
alter table DP_LOGIC_TABLE
  add primary key (ID);
  
create table DP_LOGIC_COLUMN
(
  id             VARCHAR2(50) not null,
  logic_table_id VARCHAR2(50) not null,
  code           VARCHAR2(50) not null,
  name           VARCHAR2(50),
  type           VARCHAR2(10) not null,
  length         NUMBER(5),
  status         NUMBER default 1,
  mapped_code    VARCHAR2(50),
  is_core        NUMBER,
  is_nullable    NUMBER,
  is_repeat      NUMBER,
  is_update      NUMBER,
  is_search      NUMBER,
  REQUIRED_GROUP VARCHAR2(200),
  POSTIL VARCHAR2(400),
  FIELD_SORT NUMBER(5),
  COMMON_FIELD_ID    VARCHAR2(50)
)
;
comment on table DP_LOGIC_COLUMN
  is '数据目录配置列信息';
comment on column DP_LOGIC_COLUMN.id
  is '主键';
comment on column DP_LOGIC_COLUMN.logic_table_id
  is '外键（dp_logic_table表主键）';
comment on column DP_LOGIC_COLUMN.code
  is '列名';
comment on column DP_LOGIC_COLUMN.name
  is '列注释';
comment on column DP_LOGIC_COLUMN.type
  is '列在数据库中的类型（VARCHAR2/NUMBER/DATE）';
comment on column DP_LOGIC_COLUMN.length
  is '列在数据库中的长度';
comment on column DP_LOGIC_COLUMN.status
  is '状态（1启用，0禁用）';
comment on column DP_LOGIC_COLUMN.mapped_code
  is '映射关联的数据源中指定的列';
comment on column DP_LOGIC_COLUMN.is_core
  is '是否是核心项';
comment on column DP_LOGIC_COLUMN.is_nullable
  is '是否允许为空（0否，1允许）';
comment on column DP_LOGIC_COLUMN.is_repeat
  is '是否去重字段（0否，1是）';
comment on column DP_LOGIC_COLUMN.is_update
  is '是否是更新字段（0否，1是）';
comment on column DP_LOGIC_COLUMN.is_search
  is '是否是查询字段（0否，1是）';
comment on column DP_LOGIC_COLUMN.REQUIRED_GROUP
  is '组（多选一）';
comment on column DP_LOGIC_COLUMN.POSTIL
  is '批注';
comment on column DP_LOGIC_COLUMN.FIELD_SORT
  is '排序';
COMMENT ON COLUMN DP_LOGIC_COLUMN.COMMON_FIELD_ID IS
'公共指标ID';
alter table DP_LOGIC_COLUMN
  add primary key (ID);
alter table DP_LOGIC_COLUMN
  add foreign key (LOGIC_TABLE_ID)
  references DP_LOGIC_TABLE (ID) on delete cascade;
  
create table DP_DATA_SIZE
(
  id             VARCHAR2(50) default sys_guid() not null,
  dept_id        VARCHAR2(50) not null,
  logic_table_id VARCHAR2(50) not null,
  table_version_id VARCHAR2(50),
  success_size   NUMBER,
  fail_size      NUMBER,
  all_size       NUMBER,
  task_code      VARCHAR2(50) not null,
  create_time    DATE not null
)
;
comment on table DP_DATA_SIZE
  is '本次操作数据入库量';
comment on column DP_DATA_SIZE.id
  is '主键';
comment on column DP_DATA_SIZE.dept_id
  is '部门ID';
comment on column DP_DATA_SIZE.logic_table_id
  is '逻辑表id';
comment on column dp_data_size.table_version_id
  is '外键（DP_TABLE_VERSION表主键）';
comment on column DP_DATA_SIZE.success_size
  is '本次操作入库数据量';
comment on column DP_DATA_SIZE.fail_size
  is '本次操作错误数据量';
comment on column DP_DATA_SIZE.all_size
  is '本次操作合计数据量';
comment on column DP_DATA_SIZE.task_code
  is '任务code';
comment on column DP_DATA_SIZE.create_time
  is '创建时间';
alter table DP_DATA_SIZE
  add primary key (ID);
 
create table DP_RULE
(
  id          VARCHAR2(50) not null,
  pattern     VARCHAR2(600),
  msg         VARCHAR2(600),
  create_id   VARCHAR2(50),
  create_time DATE,
  update_id   VARCHAR2(50),
  update_time DATE,
  rulename    VARCHAR2(600)
)
;
comment on table DP_RULE
  is '字段校验规则表';
comment on column DP_RULE.id
  is '主键';
comment on column DP_RULE.pattern
  is '规则(正则表达式)';
comment on column DP_RULE.msg
  is '提示消息';
comment on column DP_RULE.create_id
  is '创建人';
comment on column DP_RULE.create_time
  is '创建时间';
comment on column DP_RULE.update_id
  is '更新人';
comment on column DP_RULE.update_time
  is '更新时间';
comment on column DP_RULE.rulename
  is '规则名称';
alter table DP_RULE
  add primary key (ID);

  insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b8dfb8a000b', '[a-zA-Z0-9]{8}[a-zA-Z0-9]', '请输入正确的组织机构代码!', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:49:05', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:51:17', 'dd-mm-yyyy hh24:mi:ss'), '组织机构代码');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b8e7fa9000d', '^普通$|^特许$|^认可$|^核准$|^登记$|^其他$', '请输入正确的审批类别!', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:49:39', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:51:12', 'dd-mm-yyyy hh24:mi:ss'), '审批类别');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b8ed2d6000f', '^\d{6}$', '请输入正确的地方编码!', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:50:00', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:51:08', 'dd-mm-yyyy hh24:mi:ss'), '地方编码');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b8f3a350011', '^[0-3]$', '请输入正确的当前状态!', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:50:26', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:51:03', 'dd-mm-yyyy hh24:mi:ss'), '当前状态');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b8fba720013', '^[0-2]$', '请输入正确的使用范围!', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:50:59', 'dd-mm-yyyy hh24:mi:ss'), '', null, '信息使用范围');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b90837b0019', '^[0-3]$', '请输入正确的失信严重程度！', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:51:51', 'dd-mm-yyyy hh24:mi:ss'), '', null, '失信严重程度');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b90e510001b', '^警告$|^罚款$|^没收违法所得、没收非法财物$|^责令停产停业$|^暂扣或者吊销许可证、暂扣或者吊销执照$|^行政拘留$|^其他$', '请输入正确的处罚类别！', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:52:16', 'dd-mm-yyyy hh24:mi:ss'), '', null, '处罚类别');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b914215001d', '^[1-9A-GY]{1}[1239]{1}[1-5]{1}[0-9]{5}[0-9A-HJ-NPQRTUWXY]{10}$', '请输入正确的统一社会信用代码！', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:52:39', 'dd-mm-yyyy hh24:mi:ss'), '', null, '统一社会信用代码');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b91eb84001f', '/^[A-Z0-9]{15}$|^[A-Z0-9]{17}$|^[A-Z0-9]{18}$|^[A-Z0-9]{20}$/', '请输入正确的纳税人识别号！', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:53:23', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 10:01:26', 'dd-mm-yyyy hh24:mi:ss'), '纳税人识别号');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b923c7b0021', '^\d{4}(\-|\/|\.)\d{1,2}\1\d{1,2}$', '请输入正确的日期格式！', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:53:44', 'dd-mm-yyyy hh24:mi:ss'), '', null, '日期');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('40288c81611b845e01611b9288470023', '^\d{15}$', '请输入正确的工商注册号！', '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:54:03', 'dd-mm-yyyy hh24:mi:ss'), '', null, '工商注册号');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('402894ee58d889d40158dbf83b8e0030', '^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$', '请输入正确的IP地址！', '8aa0bef8446c32a301446c409a950002', to_date('08-12-2016 09:07:08', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:45:48', 'dd-mm-yyyy hh24:mi:ss'), 'IP地址');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('402894ee58d889d40158dbf70821002e', '^[男女]$', '请输入男或女！', '8aa0bef8446c32a301446c409a950002', to_date('08-12-2016 09:05:49', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('12-12-2016 14:55:03', 'dd-mm-yyyy hh24:mi:ss'), '性别');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('402894ee58d889d40158dbf7898e002f', '^[a-zA-Z0-9_@#$%^&*-]{6,18}$', '该输入项由6-18位的字母、数字、特殊字符组成！', '8aa0bef8446c32a301446c409a950002', to_date('08-12-2016 09:06:22', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:46:30', 'dd-mm-yyyy hh24:mi:ss'), '用户名密码等');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('402894ee58d889d40158dbf8b76a0031', '^((0\d{2,3}-\d{7,8})|(1[345789]\d{9}))$', '固定电话或手机号码如0512-12345678或13012345678', '8aa0bef8446c32a301446c409a950002', to_date('08-12-2016 09:07:40', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:46:52', 'dd-mm-yyyy hh24:mi:ss'), '固话或移动电话');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('402894ee58d889d40158dbf8e7cc0032', '^1[345789]\d{9}$', '请输入正确的手机号码！', '8aa0bef8446c32a301446c409a950002', to_date('08-12-2016 09:07:52', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('22-01-2018 09:47:20', 'dd-mm-yyyy hh24:mi:ss'), '手机号码');

insert into dp_rule (ID, PATTERN, MSG, CREATE_ID, CREATE_TIME, UPDATE_ID, UPDATE_TIME, RULENAME)
values ('402894ee58f734300158f73aaaaa0008', '%', '%', '8aa0bef8446c32a301446c409a950002', to_date('13-12-2016 16:09:26', 'dd-mm-yyyy hh24:mi:ss'), '8aa0bef8446c32a301446c409a950002', to_date('13-12-2016 16:29:24', 'dd-mm-yyyy hh24:mi:ss'), '%');

commit;

  
create table DP_COLUMN_RULE
(
  id        VARCHAR2(50) not null,
  column_id VARCHAR2(50) not null,
  rule_id   VARCHAR2(50) not null,
  column_version_config_id   VARCHAR2(50) not null
)
;
comment on table DP_COLUMN_RULE
  is '字段规则关系表';
comment on column DP_COLUMN_RULE.id
  is '主键';
comment on column DP_COLUMN_RULE.column_id
  is '字段ID';
comment on column DP_COLUMN_RULE.rule_id
  is '规则ID';
comment on column DP_COLUMN_RULE.column_version_config_id
  is '外键（DP_COLUMN_VERSION_CONFIG表主键）';
alter table DP_COLUMN_RULE
  add primary key (ID);
  
  
create table DP_FILE_PARSE_LOG
(
  id          VARCHAR2(50) not null,
  file_path   VARCHAR2(250) not null,
  task_code   VARCHAR2(50) not null,
  type        VARCHAR2(1) not null,
  create_time DATE not null,
  create_user VARCHAR2(50)
)
;
comment on table DP_FILE_PARSE_LOG
  is '数据文件解析入库日志表（暂不使用）';
comment on column DP_FILE_PARSE_LOG.id
  is '主键';
comment on column DP_FILE_PARSE_LOG.file_path
  is '文件路径';
comment on column DP_FILE_PARSE_LOG.task_code
  is '任务编号';
comment on column DP_FILE_PARSE_LOG.type
  is '日志类型（0成功，1失败,2文件不存在）';
comment on column DP_FILE_PARSE_LOG.create_time
  is '创建时间（解析时间）';
comment on column DP_FILE_PARSE_LOG.create_user
  is '创建人';
alter table DP_FILE_PARSE_LOG
  add constraint PK_DP_FILE_PARSE_LOG primary key (ID);
  
create table DP_MULTI_REPORT_RELATION
(
  id              VARCHAR2(50) not null,
  first_record_id VARCHAR2(50) not null,
  multi_record_id VARCHAR2(50) not null,
  insert_time     TIMESTAMP(0) not null
)
;
comment on table DP_MULTI_REPORT_RELATION
  is '记录多次上报关系表';
comment on column DP_MULTI_REPORT_RELATION.id
  is '主键id';
comment on column DP_MULTI_REPORT_RELATION.first_record_id
  is '首次上报记录的主键id';
comment on column DP_MULTI_REPORT_RELATION.multi_record_id
  is '非首次上报记录的主键id';
comment on column DP_MULTI_REPORT_RELATION.insert_time
  is '非首次上报记录插入时间';
alter table DP_MULTI_REPORT_RELATION
  add constraint PK_DP_MULTI_REPORT_RELATION primary key (ID);
  
-- Create table
create table DP_QRTZ_FILE_PARSE
(
  id                        VARCHAR2(50) not null,
  task_code                 VARCHAR2(50) not null,
  task_name                 VARCHAR2(250) not null,
  file_path                 VARCHAR2(250) not null,
  table_code                VARCHAR2(50) not null,
  dept_code                 VARCHAR2(50) not null,
  login_table_id            VARCHAR2(50) not null,
  table_version_id            VARCHAR2(50),
  table_column_code         VARCHAR2(4000) not null,
  create_time               DATE not null,
  create_user               VARCHAR2(50),
  file_name                 VARCHAR2(250) not null,
  dept_name                 VARCHAR2(250),
  status                    INTEGER default 0,
  parse_time_start          DATE,
  parse_time_end            DATE,
  parse_cnt_success         INTEGER default 0,
  parse_cnt_fail            INTEGER default 0,
  file_storage_host_name    VARCHAR2(2000),
  file_storage_host_address VARCHAR2(2000),
  file_parse_host_name      VARCHAR2(2000),
  file_parse_host_address   VARCHAR2(2000)
);
-- Add comments to the table 
comment on table DP_QRTZ_FILE_PARSE
  is '数据上报文件定时解析表';
-- Add comments to the columns 
comment on column DP_QRTZ_FILE_PARSE.id
  is '主键';
comment on column DP_QRTZ_FILE_PARSE.task_code
  is '任务编号';
comment on column DP_QRTZ_FILE_PARSE.task_name
  is '任务名称（也是表名的注释）';
comment on column DP_QRTZ_FILE_PARSE.file_path
  is '要解析的文件路径';
comment on column DP_QRTZ_FILE_PARSE.table_code
  is '表名编码';
comment on column DP_QRTZ_FILE_PARSE.dept_code
  is '部门编码';
comment on column DP_QRTZ_FILE_PARSE.login_table_id
  is '外键（关联DP_LOGIN_TABLE主键id）';
comment on column dp_qrtz_file_parse.table_version_id
  is '外键（DP_TABLE_VERSION表主键）';
comment on column DP_QRTZ_FILE_PARSE.table_column_code
  is '表字段编码（多个之间用逗号隔开）';
comment on column DP_QRTZ_FILE_PARSE.create_time
  is '创建时间';
comment on column DP_QRTZ_FILE_PARSE.create_user
  is '创建人id';
comment on column DP_QRTZ_FILE_PARSE.file_name
  is '原始文件名';
comment on column DP_QRTZ_FILE_PARSE.dept_name
  is '部门名称';
comment on column DP_QRTZ_FILE_PARSE.status
  is '0：待解析，1：解析中，2：解析成功，3：解析失败，4：文件不存在';
comment on column DP_QRTZ_FILE_PARSE.parse_time_start
  is '解析开始时间';
comment on column DP_QRTZ_FILE_PARSE.parse_time_end
  is '解析结束时间';
comment on column DP_QRTZ_FILE_PARSE.parse_cnt_success
  is '解析成功数据量';
comment on column DP_QRTZ_FILE_PARSE.parse_cnt_fail
  is '解析失败数据量';
comment on column DP_QRTZ_FILE_PARSE.file_storage_host_name
  is '文件存放主机名称';
comment on column DP_QRTZ_FILE_PARSE.file_storage_host_address
  is '文件存放主机地址';
comment on column DP_QRTZ_FILE_PARSE.file_parse_host_name
  is '文件解析主机名称';
comment on column DP_QRTZ_FILE_PARSE.file_parse_host_address
  is '文件解析主机地址';
-- Create/Recreate primary, unique and foreign key constraints 
alter table DP_QRTZ_FILE_PARSE
  add constraint PK_DP_QRTZ_FILE_PARSE primary key (ID)
  using index;

  
create table DP_QRTZ_LOG
(
  jobname    VARCHAR2(200) not null,
  jobdesc    VARCHAR2(500) not null,
  status     VARCHAR2(1),
  createtime DATE
)
;
comment on table DP_QRTZ_LOG
  is '定时任务执行记录表';
comment on column DP_QRTZ_LOG.jobname
  is '定时任务名';
comment on column DP_QRTZ_LOG.jobdesc
  is '定时任务描述';
comment on column DP_QRTZ_LOG.status
  is '执行状态（1开始 2结束 3异常）';
comment on column DP_QRTZ_LOG.createtime
  is '创建时间';

create table DP_TASK_STATUS_CHANGE_LOG
(
  id          VARCHAR2(50) not null,
  status      VARCHAR2(2) not null,
  taskcode    VARCHAR2(50) not null,
  create_time DATE not null,
  create_user VARCHAR2(50) not null
)
;
comment on table DP_TASK_STATUS_CHANGE_LOG
  is '采集任务状态变更日志表';
comment on column DP_TASK_STATUS_CHANGE_LOG.id
  is '主键';
comment on column DP_TASK_STATUS_CHANGE_LOG.status
  is '变更的状态';
comment on column DP_TASK_STATUS_CHANGE_LOG.taskcode
  is '任务编号';
comment on column DP_TASK_STATUS_CHANGE_LOG.create_time
  is '变更时间';
comment on column DP_TASK_STATUS_CHANGE_LOG.create_user
  is '变更人';
alter table DP_TASK_STATUS_CHANGE_LOG
  add constraint PK_DP_TASK_STATUS_CHANGE_LOG primary key (ID);
  
create table DP_UPLOAD_FILE
(
  id            VARCHAR2(50) not null,
  file_name     VARCHAR2(200),
  file_path     VARCHAR2(200),
  file_type     VARCHAR2(50),
  create_date   DATE,
  create_user   VARCHAR2(50),
  TASK_CODE   VARCHAR2(50),
  file_realname VARCHAR2(200),
  status        VARCHAR2(50)
)
;
comment on table DP_UPLOAD_FILE
  is '数据文件上传记录表（暂不使用）';
comment on column DP_UPLOAD_FILE.id
  is '主键';
comment on column DP_UPLOAD_FILE.file_name
  is '原始文件名';
comment on column DP_UPLOAD_FILE.file_path
  is '服务器文件路径';
comment on column DP_UPLOAD_FILE.file_type
  is '文件类型';
comment on column DP_UPLOAD_FILE.create_date
  is '创建日期';
comment on column DP_UPLOAD_FILE.create_user
  is '创建者';
comment on column DP_UPLOAD_FILE.TASK_CODE
  is '批次编号';
comment on column DP_UPLOAD_FILE.file_realname
  is '服务器文件名';
comment on column DP_UPLOAD_FILE.status
  is '文件状态（0：未解析 1：解析成功 2：有错误数据  9：已删除）,预留字段暂未启用';
alter table DP_UPLOAD_FILE
  add constraint PK_DP_UPLOAD_FILE primary key (ID);
  
  create table ETL_ENTERPRISE_TYPE_CHECKLIST
(
  old_qylxdm VARCHAR2(50),
  old_qylxmc VARCHAR2(250),
  qylxdm     VARCHAR2(50),
  qylxmc     VARCHAR2(250)
)
;
comment on table ETL_ENTERPRISE_TYPE_CHECKLIST
  is '数据清洗企业类型对照表';
comment on column ETL_ENTERPRISE_TYPE_CHECKLIST.old_qylxdm
  is '原企业类型代码';
comment on column ETL_ENTERPRISE_TYPE_CHECKLIST.old_qylxmc
  is '原企业类型名称';
comment on column ETL_ENTERPRISE_TYPE_CHECKLIST.qylxdm
  is '匹配后企业类型代码';
comment on column ETL_ENTERPRISE_TYPE_CHECKLIST.qylxmc
  is '匹配后企业类型名称';
  
  create table ETL_ERROR_CODE
(
  id          VARCHAR2(50) default sys_guid() not null,
  error_code  VARCHAR2(250) not null,
  error_desc  VARCHAR2(2000) not null,
  create_time DATE,
  error_order number
)
;
comment on table ETL_ERROR_CODE
  is 'ETL处理错误码';
comment on column ETL_ERROR_CODE.id
  is '主键';
comment on column ETL_ERROR_CODE.error_code
  is '错误码';
comment on column ETL_ERROR_CODE.error_desc
  is '错误描述';
comment on column ETL_ERROR_CODE.create_time
  is '创建时间';
comment on column ETL_ERROR_CODE.error_order
  is '顺序';
alter table ETL_ERROR_CODE
  add constraint PK_ETL_ERROR_CODE primary key (ID);
  
  create table ETL_INDUSTRY_CODE_CHECKLIST
(
  old_industry_name VARCHAR2(250) not null,
  industry_code     VARCHAR2(50),
  industry_name     VARCHAR2(250)
)
;
comment on table ETL_INDUSTRY_CODE_CHECKLIST
  is '数据清洗行业代码对照表';
comment on column ETL_INDUSTRY_CODE_CHECKLIST.old_industry_name
  is '原行业代码名称';
comment on column ETL_INDUSTRY_CODE_CHECKLIST.industry_code
  is '匹配后行业代码';
comment on column ETL_INDUSTRY_CODE_CHECKLIST.industry_name
  is '匹配后行业名称';
alter table ETL_INDUSTRY_CODE_CHECKLIST
  add primary key (OLD_INDUSTRY_NAME);


  
  create table ETL_ORGAN_SIGN
(
  id          VARCHAR2(50) default sys_guid() not null,
  zzjgdm      VARCHAR2(200),
  jgqc        VARCHAR2(2500),
  gszch       VARCHAR2(200),
  tyshxydm    VARCHAR2(200),
  create_time DATE,
  fzrq        VARCHAR2(20),
  hzrq        VARCHAR2(20)
)
;
comment on table ETL_ORGAN_SIGN
  is 'ETL数据清洗企业标识补全表';
comment on column ETL_ORGAN_SIGN.id
  is '主键';
comment on column ETL_ORGAN_SIGN.zzjgdm
  is '组织机构代码';
comment on column ETL_ORGAN_SIGN.jgqc
  is '机构全称中文';
comment on column ETL_ORGAN_SIGN.gszch
  is '工商注册号（单位注册号）';
comment on column ETL_ORGAN_SIGN.tyshxydm
  is '统一社会信用代码';
comment on column ETL_ORGAN_SIGN.create_time
  is '创建时间';
comment on column ETL_ORGAN_SIGN.fzrq
  is '发证日期';
comment on column ETL_ORGAN_SIGN.hzrq
  is '核准日期';
alter table ETL_ORGAN_SIGN
  add constraint PK_ETL_ORGAN_SIGN primary key (ID);
  
-- 中间表增加索引
create index FK_ETL_GSZCH on ETL_ORGAN_SIGN (GSZCH);
create index FK_ETL_TYSHXYDM on ETL_ORGAN_SIGN (TYSHXYDM);
create index FK_ETL_ZZJGDM on ETL_ORGAN_SIGN (ZZJGDM);

CREATE TABLE DP_ERROR_UPLOAD_FILE
(
  ID VARCHAR2(50) NOT NULL,
  FILE_NAME      VARCHAR2(200),
  FILE_PATH      VARCHAR2(200),
  TASK_CODE      VARCHAR2(50),
  DEPT_CODE      VARCHAR2(50),
  LOGIC_TABLE_ID VARCHAR2(50),
  CREATE_USER   VARCHAR2(50),
  CREATE_DATE    DATE,
  PRIMARY KEY (ID)
);
COMMENT ON TABLE  DP_ERROR_UPLOAD_FILE IS '错误记录表';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.ID IS '主键ID';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.FILE_NAME IS '错误文件名称';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.FILE_PATH IS '错误文件路径';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.TASK_CODE IS '任务编号';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.LOGIC_TABLE_ID IS 'dp_logic_table的主键';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.DEPT_CODE IS '部门编码';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.CREATE_USER IS '创建用户';
COMMENT ON COLUMN DP_ERROR_UPLOAD_FILE.CREATE_DATE IS '记录时间';

CREATE TABLE DP_SUMMARY_INVALID_DATA
(
   ID VARCHAR2(50) NOT NULL, 
   DATA_SOURCE VARCHAR2(2), 
   STATUS VARCHAR2(2), 
   CREATE_TIME DATE,
   INVALID_SIZE  number,
   DEPT_ID VARCHAR2(50),
   LOGIC_TABLE_ID VARCHAR2(50),
   TABLE_VERSION_ID VARCHAR2(50),
   TASK_CODE VARCHAR2(50)
);

comment on table DP_SUMMARY_INVALID_DATA
  is '疑问数据按部门和目录汇总表';
comment on column DP_SUMMARY_INVALID_DATA.ID
  is '主键';
comment on column DP_SUMMARY_INVALID_DATA.DATA_SOURCE
  is '数据源,0:文件解析 1:原始库 2:有效库 ';
comment on column DP_SUMMARY_INVALID_DATA.STATUS
  is '状态（表示该条无效数据是否进行过后续的处理，0未处理，1已处理，2已忽略，4已修改） ';
comment on column DP_SUMMARY_INVALID_DATA.CREATE_TIME
  is '创建时间';
comment on column DP_SUMMARY_INVALID_DATA.INVALID_SIZE
  is '疑问数据量';
comment on column DP_SUMMARY_INVALID_DATA.DEPT_ID
  is '部门id';
comment on column DP_SUMMARY_INVALID_DATA.LOGIC_TABLE_ID
  is '目录id';
comment on column DP_SUMMARY_INVALID_DATA.table_version_id
  is '版本ID（DP_TABLE_VERSION表主键）';
comment on column DP_SUMMARY_INVALID_DATA.TASK_CODE
  is '任务编号';

drop sequence SQ_RWBH;
-- Create sequence 
create sequence SQ_RWBH
minvalue 1
maxvalue 99999999999999999
start with 2
increment by 1
nocache;
  
create or replace view view_task as
(
select a."ID",a."TASK_CODE",a."TASK_NAME",a."STATUS",a."TASKBEGIN_TIME",a."TASKEND_TIME",a."CREATE_TIME",a."UPDATA_TIME",a."TASK_TYPE",a."LOGIC_TABLE_ID",a."CREATE_USER",a."UPDATE_USER",a."UPLOAD_FILE_COUNT",a."REVOCATION_FILE_COUNT", c.department_name dept_name, c.sys_department_id dept_id
  from DP_COLLECTION_TASK a
  left join dp_logic_table b
    on a.logic_table_id = b.id
  left join sys_department c
    on b.dept_id = c.sys_department_id
 where sysdate <= a.taskend_time or (sysdate > a.taskend_time and  a.status <> '5')
);

create or replace view view_task_his as
(
select a."ID",a."TASK_CODE",a."TASK_NAME",a."STATUS",a."TASKBEGIN_TIME",a."TASKEND_TIME",a."CREATE_TIME",a."UPDATA_TIME",a."TASK_TYPE",a."LOGIC_TABLE_ID",a."CREATE_USER",a."UPDATE_USER",a."UPLOAD_FILE_COUNT",a."REVOCATION_FILE_COUNT",
       c.department_name         dept_name,
       c.sys_department_id       dept_id,d.username
  from DP_COLLECTION_TASK a
  left join dp_logic_table b
    on a.logic_table_id = b.id
  left join sys_department c
    on b.dept_id = c.sys_department_id
    left join sys_user d on a.create_user=d.sys_user_id
    where a.create_user <> 'system'
union all
select a."ID",a."TASK_CODE",a."TASK_NAME",a."STATUS",a."TASKBEGIN_TIME",a."TASKEND_TIME",a."CREATE_TIME",a."UPDATA_TIME",a."TASK_TYPE",a."LOGIC_TABLE_ID",a."CREATE_USER",a."UPDATE_USER",a."UPLOAD_FILE_COUNT",a."REVOCATION_FILE_COUNT",
       c.department_name         dept_name,
       c.sys_department_id       dept_id,'system' username
  from DP_COLLECTION_TASK a
  left join dp_logic_table b
    on a.logic_table_id = b.id
  left join sys_department c
    on b.dept_id = c.sys_department_id
    left join sys_user d on a.create_user=d.sys_user_id
    where a.create_user = 'system' );

	create or replace view view_task_status_count as
(
select a.status, count(1) gs,b.dept_id
  FROM DP_COLLECTION_TASK a
   left join dp_logic_table b
    on a.logic_table_id = b.id
 where sysdate <= a.taskend_time or (sysdate > a.taskend_time and  a.status <> '5')
 group by a.status,b.dept_id
 );
 

-- 任务量统计、数据量统计、数据质量统计
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281588489c001588588c7df006c', 'ROOT_1', '统计分析', null, 'icon-pie-chart', 32);

insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281588489c00158858932fa0071', '2c90c281588489c001588588c7df006c', '数据采集统计', null, 'icon-bar-chart', 3200);

insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281588489c00158858b7c60007b', '2c90c281588489c00158858932fa0071', '数据量统计', 'dataSize/dataSize.action', 'fa fa-circle-o', 320005);
insert into SYS_MENU (sys_menu_id, parent_id, menu_name, menu_url, menu_icon, display_order)
values ('2c90c281588489c00158858be7b00080', '2c90c281588489c00158858932fa0071', '数据质量统计', 'dataQuality/dataQuality.action', 'fa fa-circle-o', 320010);

insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c281588489c00158858c99bc008f', '2c90c281588489c00158858be7b00080', 'statisAnalyze.dataQuality', '数据质量统计', null, null, null, null, null);
insert into SYS_PRIVILEGE (sys_privilege_id, sys_menu_id, privilege_code, privilege_name, description, users_count, roles_count, all_users_count, display_order)
values ('2c90c281588489c00158858cdace0099', '2c90c281588489c00158858b7c60007b', 'statisAnalyze.dataSize', '数据量统计', null, null, null, null, null);

insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '2c90c281588489c00158858c99bc008f');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('2c90c28158761b550158762482b50015', '2c90c281588489c00158858cdace0099');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c281588489c00158858c99bc008f');
insert into SYS_ROLE_TO_PRIVILEGE (sys_role_id, sys_privilege_id)
values ('8aa0bef544713ca60144713d364a0000', '2c90c281588489c00158858cdace0099');

commit;

-- '数据上报', '历史任务', '数据管理', '目录配置', '任务查询', '字段规则管理'
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875a8d3f20089', '2c90c281587574200158759d3ced0062', '征集目录管理', 'schema/schemaList.action', 'fa fa-circle-o', 2505);

insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875abd92a0093', '2c90c281587574200158759d3ced0062', '征集记录', 'dp/task/toHisTask.action', 'fa fa-circle-o', 2515);

insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('4028946a586c9b6f0158755405ce023a', 'ROOT_2', '数据上报', null, 'icon-cloud-upload', 10);

insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee58d889d40158d88b54e20007', '2c90c281587574200158759d3ced0062', '字段规则管理', 'rule/ruleList.action', 'fa fa-circle-o', 2520);

insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c281587574200158757f9a6d001d', '4028946a586c9b6f0158755405ce023a', '数据上报', 'dp/task/toGovTask.action', 'fa fa-circle-o', 1000);

insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c281587574200158758630d4002b', '4028946a586c9b6f0158755405ce023a', '历史任务', 'dp/task/toGovTaskHis.action', 'fa fa-circle-o', 1005);

insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c281587574200158759d3ced0062', 'ROOT_1', '数据管理', null, 'icon-shuffle', 25);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875b7f5aa00d5', '2c90c281587574200158758630d4002b', 'his.task.query', '历史任务页面查看', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875baef1300dc', '2c90c281587574200158757f9a6d001d', 'dp.dataReport.query', '上报数据', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875bb85e900e8', '2c90c281587574200158757f9a6d001d', 'dp.dataReport.file', '上传数据file', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875ce7bc001a5', '2c90c28158757420015875a8d3f20089', 'schema.field', '字段维护', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f858ec631c0158ec69956d000a', '2c90c281587574200158757f9a6d001d', 'dp.dataReport.checkFile', '数据上报页面-模板相关', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('297e11b45a270c6b015a271048670008', '2c90c281587574200158758630d4002b', 'his.task.dataReport', '任务上报记录详情', '任务上报记录详情', null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee58d889d40158d88cec970016', '402894ee58d889d40158d88b54e20007', 'rule.list', '字符规则管理', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f858fc8cf30158fc98c46d0007', '2c90c281587574200158757f9a6d001d', 'dp.dataReport.edit', '修改数据', '修改数据', null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('4028498159061fc60159070588f200bb', '2c90c281587574200158757f9a6d001d', 'task.realtime.btn', '新建任务', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('4028498159061fc601590706f5a300d0', '2c90c281587574200158757f9a6d001d', 'task.confirm.btns', '确认完成s', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('297e11b45a270c6b015a27139fda001e', '2c90c281587574200158757f9a6d001d', 'dp.dataReport.dataReportCheck', '数据校验疑和问数据操作', '数据校验疑、问数据操作、数据血缘', null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('4028498158e80cd20158e80f65270013', '2c90c281587574200158757f9a6d001d', 'dataReport.task.list', '上报任务列表', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875ce11c8019a', '2c90c28158757420015875a8d3f20089', 'schema.list', '数据目录配置列表', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875ceedae01ae', '2c90c28158757420015875abd92a0093', 'his.task.queryzx', '历史任务页面查看zx', null, null, null, null, null);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f858ec631c0158ec6772080003', '2c90c281587574200158757f9a6d001d', 'dp.dataReport.dataReport', '数据上报页面', null, null, null, null, null);

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '297e11b45a270c6b015a271048670008');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '297e11b45a270c6b015a27139fda001e');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875ce11c8019a');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875ce7bc001a5');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '2c90c28158757420015875ceedae01ae');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee58d889d40158d88cec970016');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '297e11b45a270c6b015a271048670008');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '297e11b45a270c6b015a27139fda001e');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '2c90c28158757420015875b7f5aa00d5');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '2c90c28158757420015875baef1300dc');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '2c90c28158757420015875bb85e900e8');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '4028498158e80cd20158e80f65270013');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '4028498159061fc60159070588f200bb');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '4028498159061fc601590706f5a300d0');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894f858ec631c0158ec6772080003');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894f858ec631c0158ec69956d000a');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894f858fc8cf30158fc98c46d0007');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '297e11b45a270c6b015a271048670008');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '297e11b45a270c6b015a27139fda001e');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875b7f5aa00d5');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875baef1300dc');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875bb85e900e8');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875ce11c8019a');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875ce7bc001a5');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875ceedae01ae');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '4028498158e80cd20158e80f65270013');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '4028498159061fc60159070588f200bb');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '4028498159061fc601590706f5a300d0');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee58d889d40158d88cec970016');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f858ec631c0158ec6772080003');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f858ec631c0158ec69956d000a');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894f858fc8cf30158fc98c46d0007');
commit;

--字典项
insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894ee58dd73780158dd7ae78b0005', 'common_fields', '公共字段列表', '数据目录配置 - 字段维护 - 选择公共字段');

insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894ee58dd73780158dd7c5c98000e', 'data_category', '数据类别', '作为数据的统计类别使用');

insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894ee58dd73780158dd7da49d001d', 'task_period', '归集周期', '数据采集任务-归集周期');

insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('4028946a5bf5214d015bf52373880006', 'checkdate', '日期校验', '不能大于当前日期');

insert into SYS_DICTIONARY_GROUP (id, group_key, group_name, description)
values ('402894bc5d63ea27015d63ec615d0004', 'reportWay', '上报方式', '疑问数据查询条件，统计分析');



insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('4028946a5bf5214d015bf52373880007', '4028946a5bf5214d015bf52373880006', 'CFJDRQ', '处罚决定日期', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('4028946a5bf5214d015bf52373880008', '4028946a5bf5214d015bf52373880006', 'XKJDRQ', '许可决定日期', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4a249b630018', '402894ee58dd73780158dd7c5c98000e', '2', '资质信息', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4a249b630019', '402894ee58dd73780158dd7c5c98000e', '0', '其它', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4a249b64001a', '402894ee58dd73780158dd7c5c98000e', '3', '履行约定', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4a249b64001b', '402894ee58dd73780158dd7c5c98000e', '4', '失信信息', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4a249b65001c', '402894ee58dd73780158dd7c5c98000e', '5', '表彰荣誉', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4a249b65001d', '402894ee58dd73780158dd7c5c98000e', '1', '基本信息', null);


insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4aaad60e0062', '402894ee58dd73780158dd7ae78b0005', 'TYSHXYDM', '统一社会信用代码', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4aaad610006f', '402894ee58dd73780158dd7ae78b0005', 'JGQC', '机构全称', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4aaad6110072', '402894ee58dd73780158dd7ae78b0005', 'ZZJGDM', '组织机构代码', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('2c92b4815a49f771015a4aaad6110073', '402894ee58dd73780158dd7ae78b0005', 'GSZCH', '工商注册号', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894ee58dd73780158dd7da49d001e', '402894ee58dd73780158dd7da49d001d', '1', '月', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894ee58dd73780158dd7da49d001f', '402894ee58dd73780158dd7da49d001d', '0', '周', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894ee58dd73780158dd7da49d0020', '402894ee58dd73780158dd7da49d001d', '5', '实时', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894ee58dd73780158dd7da49d0021', '402894ee58dd73780158dd7da49d001d', '4', '年', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894ee58dd73780158dd7da49e0022', '402894ee58dd73780158dd7da49d001d', '2', '季度', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894ee58dd73780158dd7da49e0023', '402894ee58dd73780158dd7da49d001d', '3', '半年', null);


insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894bc5d63ea27015d63ec615d0005', '402894bc5d63ea27015d63ec615d0004', '2', '数据库上报', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894bc5d63ea27015d63ec615d0006', '402894bc5d63ea27015d63ec615d0004', '0', '手动录入', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894bc5d63ea27015d63ec615e0007', '402894bc5d63ea27015d63ec615d0004', '3', 'FTP上报', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894bc5d63ea27015d63ec615e0008', '402894bc5d63ea27015d63ec615d0004', '1', '文件上传', null);

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894bc5d63ea27015d63ec615e0009', '402894bc5d63ea27015d63ec615d0004', '4', '接口上报', null);

commit;

--定时任务

insert into QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA)
values ('scheduler', 'fileParseJob', 'DEFAULT', '定时解析数据文件，将数据入库', 'com.wa.framework.quartz.job.FileParseJob', '1', '0', '0', '0', 'ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C770800000010000000007800');

insert into QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA)
values ('scheduler', 'refreshCacheJob', 'DEFAULT', '刷新用户缓存，提高登录性能', 'com.wa.framework.quartz.job.RefreshCacheJob', '1', '0', '0', '0', 'ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C770800000010000000007800');

insert into QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_NONCONCURRENT, IS_UPDATE_DATA, REQUESTS_RECOVERY, JOB_DATA)
values ('scheduler', 'generateLngAndLatJob', 'DEFAULT', '调用高德API，更新企业经纬度，将数据入库', 'com.wa.framework.quartz.job.GenerateLngAndLatJob', '1', '0', '0', '0', 'ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787000737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C770800000010000000007800');

insert into QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP, DESCRIPTION, NEXT_FIRE_TIME, PREV_FIRE_TIME, PRIORITY, TRIGGER_STATE, TRIGGER_TYPE, START_TIME, END_TIME, CALENDAR_NAME, MISFIRE_INSTR, JOB_DATA)
values ('scheduler', '数据文件解析入库-10秒钟一次', 'DEFAULT', 'fileParseJob', 'DEFAULT', null, 1488613800000, 1488613544909, 5, 'PAUSED', 'CRON', 1487033762000,
0, null, 0, null);

insert into QRTZ_CRON_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, CRON_EXPRESSION, TIME_ZONE_ID)
values ('scheduler', '数据文件解析入库-10秒钟一次', 'DEFAULT', '0/10 * * ? * *', 'Asia/Shanghai');
commit;

--初始化ETL_ENTERPRISE_TYPE_CHECKLIST数据
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('100', '有限公司', '1100', '有限责任公司');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('11', '股份有限公司', '1200', '股份有限公司');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('119', '非公司外商投资企业（中外合作）', '5310', '非公司外商投资企业(中外合作)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('130', '有限公司(中外合资经营)', '5120', '有限责任公司(中外合作)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('137', '外国(地区)企业承包工程', '7300', '外国(地区)企业在中国境内从事经营活动');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('138', '外国(地区)企业承包经营管理', '7300', '外国(地区)企业在中国境内从事经营活动');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('139', '外国(地区)企业受托经营管理', '7300', '外国(地区)企业在中国境内从事经营活动');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('140', '外国(地区)企业其它经营活动', '7300', '外国(地区)企业在中国境内从事经营活动');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('143', '有限公司(独资经营－台港澳资)', '6150', '有限责任公司(台港澳法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('152', '外国(地区)企业常驻代表机构', '7200', '外国(地区)企业常驻代表机构');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('16', '股份有限公司(自然人控股)', '1222', '股份有限公司(非上市、自然人投资或控股)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('164', '外国银行', '7100', '外国（地区）公司分支机构');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('165', '外国保险公司', '7100', '外国（地区）公司分支机构');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('166', '外国保险公司营销部', '7100', '外国（地区）公司分支机构');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('167', '个体工商户(香港居民)', '9999', '个体');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('17', '股份有限公司(上市)', '1210', '股份有限公司(上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('170', '有限公司(自然人控股)', '1130', '有限责任公司(自然人投资或控股)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('180', '有限公司(自然人独资)', '1151', '有限责任公司(自然人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('181', '有限公司(法人独资)内资', '1153', '有限责任公司（非自然人投资或控股的法人独资）');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('182', '有限公司(法人独资)私营', '1152', '有限责任公司（自然人投资或控股的法人独资）');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('184', '有限责任公司(中外合资)', '5110', '有限责任公司(中外合资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('185', '有限责任公司(台港澳与境内合资)', '6110', '有限责任公司(台港澳与境内合资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('186', '有限责任公司(中外合作)', '5120', '有限责任公司(中外合作)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('187', '有限责任公司(台港澳与境内合作)', '6120', '有限责任公司(台港澳与境内合作)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('188', '有限责任公司(外商独资)', '5150', '有限责任公司(外国法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('189', '有限责任公司(外商合资)', '5130', '有限责任公司(外商合资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('190', '有限责任公司(外国法人独资)', '5150', '有限责任公司(外国法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('192', '有限责任公司(外国自然人独资)', '5140', '有限责任公司(外国自然人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('193', '有限责任公司(台港澳与外国投资者合资)', '6170', '有限责任公司(台港澳与外国投资者合资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('194', '有限责任公司(台港澳合资)', '6130', '有限责任公司(台港澳合资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('195', '有限责任公司(台港澳法人独资)', '6150', '有限责任公司(台港澳法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('196', '有限责任公司(台港澳非法人经济组织独资)', '6160', '有限责任公司(台港澳非法人经济组织独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('197', '有限责任公司(台港澳自然人独资)', '6150', '有限责任公司(台港澳法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('199', '股份有限公司(中外合资，未上市)', '5210', '股份有限公司(中外合资、未上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('200', '股份有限公司(中外合资，上市)', '5220', '股份有限公司(中外合资、上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('204', '股份有限公司(台港澳与外国投资者合资，上市)', '6260', '股份有限公司(台港澳与外国投资者合资、上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('205', '股份有限公司(台港澳与境内合资，未上市)', '6210', '股份有限公司(台港澳与境内合资、未上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('206', '股份有限公司(台港澳与境内合资，上市)', '6220', '股份有限公司(台港澳与境内合资、上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('207', '股份有限公司(台港澳合资，未上市)', '6230', '股份有限公司(台港澳合资、未上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('211', '特殊的普通合伙企业', '4532', '特殊普通合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('212', '有限合伙企业', '4533', '有限合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('213', '农民专业合作社', '9100', '农民专业合作社');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('214', '个体工商户(台湾居民)', '9999', '个体');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('216', '外商投资普通合伙企业', '5410', '普通合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('217', '外商投资特殊的普通合伙企业', '5420', '特殊普通合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('218', '外商投资有限合伙企业', '5430', '有限合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('22', '股份有限公司(上市,自然人控股)', '2212', '股份有限公司分公司(上市、自然人投资或控股)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('220', '农民专业合作联社', '9100', '农民专业合作社');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('222', '非公司台、港、澳企业（台港澳与境内合资）', '6310', '非公司台、港、澳企业(台港澳与境内合作)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('223', '非公司台、港、澳企业（台港澳合资）', '6320', '非公司台、港、澳企业(台港澳合资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('23', '个人独资', '4540', '个人独资企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('24', '普通合伙企业', '4531', '普通合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('25', '全民所有制', '3100', '全民所有制');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('26', '集体所有制', '3200', '集体所有制');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('27', '集体所有制(股份合作制)', '3400', '股份合作制');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('28', '集体所有制(合作制)', '3300', '股份制');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('29', '联营', '3500', '联营');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('49', '有限公司', '1100', '有限责任公司');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('50', '有限公司(国有独资)', '1110', '有限责任公司(国有独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('51', '有限公司(自然人控股)', '1130', '有限责任公司(自然人投资或控股)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('77', '个体工商户', '9999', '个体');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('91', '集体所有制(股份合作制-股份制)', '3400', '股份合作制');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('93', '外国(地区)企业生产经营活动', '7300', '外国(地区)企业在中国境内从事经营活动');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('98', '有限公司(外商独资经营)', '5150', '有限责任公司(外国法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values ('99', '有限公司(独资经营－港资)', '6150', '有限责任公司(台港澳法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '个体工商户(台湾农民)', '9999', '个体');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '有限公司(独资经营－台资)', '6150', '有限责任公司(台港澳法人独资)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '合伙企业(9000)', '4530', '合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '中外合作经营', '5120', '有限责任公司(中外合作)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '农民专业合作社(E100)', '9100', '农民专业合作社');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '全民所有制企业(1000)', '3100', '全民所有制');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '非公司外商投资企业（中外合作）', '5310', '非公司外商投资企业(中外合作)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '外国银行分行', '7100', '外国（地区）公司分支机构');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '股份有限公司(中外合资)', '5210', '股份有限公司(中外合资、未上市)');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '其他有限责任公司(7800)', '1190', '其他有限责任公司');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '其它类型', '9900', '其他');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '有限公司(法人独资)', '1153', '有限责任公司（非自然人投资或控股的法人独资）');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '合伙企业', '4530', '合伙企业');
insert into ETL_ENTERPRISE_TYPE_CHECKLIST (old_qylxdm, old_qylxmc, qylxdm, qylxmc)
values (null, '农民专业合作社法人', '9100', '农民专业合作社');
commit;
--初始化ETL_ERROR_CODE数据
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('1', '10001', '企业注册资金非纯数字', null, 8);
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('2', '30001', '企业所属行业名称错误', null, 2);
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('3', '30002', '企业类型代码或企业类型名称错误', null, 1);
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('4', '10002', '企业名称为空', null, 5);
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('92DC8415FCBA4E8294D01ACEDA1E971F', '10003', '必填日期为空', null, 4);
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('A92A4A8F9BAE4CD6B44227A84490C17A', '20001', '重复数据，旧数据', null, 3);
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('3787B3D1683A45A9B5DAEDDF6AC9CBB7', 10004, '格式转换错误',null, 6);
insert into ETL_ERROR_CODE (id, error_code, error_desc, create_time, error_order)
values ('5', 40001, '规则解析错误',null, 7);
commit;
--初始化ETL_INDUSTRY_CODE_CHECKLIST数据
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('集装箱及金属包装容器制造', '3330', '集装箱及金属包装容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('集装箱制造', '3331', '集装箱制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属压力容器制造', '3332', '金属压力容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属包装容器制造', '3333', '金属包装容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属丝绳及其制品的制造', '3340', '金属丝绳及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属丝绳及其制品制造', '3340', '金属丝绳及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑、安全用金属制品制造', '3350', '建筑、安全用金属制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑、家具用金属配件制造', '3351', '建筑、家具用金属配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑装饰及水暖管道零件制造', '3352', '建筑装饰及水暖管道零件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('安全、消防用金属制品制造', '3353', '安全、消防用金属制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他建筑、安全用金属制品制造', '3359', '其他建筑、安全用金属制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属表面处理及热处理加工', '3360', '金属表面处理及热处理加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('搪瓷制品制造', '3370', '搪瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生产专用搪瓷制品制造', '3371', '生产专用搪瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工业生产配套用搪瓷制品制造', '3371', '生产专用搪瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('搪瓷卫生洁具制造', '3373', '搪瓷卫生洁具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制日用品制造', '3380', '金属制日用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用金属制品制造', '3380', '金属制日用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制厨用器皿及餐具制造', '3380', '金属制日用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制厨房调理及卫生器具制造', '3380', '金属制日用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制厨房用器具制造', '3381', '金属制厨房用器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制餐具和器皿制造', '3382', '金属制餐具和器皿制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他金属制日用品制造', '3389', '其他金属制日用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他金属制品制造', '3390', '其他金属制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锻件及粉末冶金制品制造', '3391', '锻件及粉末冶金制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('交通及公共管理用金属标牌制造', '3392', '交通及公共管理用金属标牌制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('交通管理用金属标志及设施制造', '3392', '交通及公共管理用金属标牌制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明金属制品制造', '3399', '其他未列明金属制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的金属制品制造', '3399', '其他未列明金属制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通用设备制造业', '3400', '通用设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锅炉及原动设备制造', '3410', '锅炉及原动设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锅炉及原动机制造', '3410', '锅炉及原动设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锅炉及辅助设备制造', '3411', '锅炉及辅助设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('内燃机及配件制造', '3412', '内燃机及配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽轮机及辅机制造', '3413', '汽轮机及辅机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他原动机制造', '3419', '其他原动设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属加工机械制造', '3420', '金属加工机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属切削机床制造', '3421', '金属切削机床制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属成形机床制造', '3422', '金属成形机床制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铸造机械制造', '3423', '铸造机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属切割及焊接设备制造', '3424', '金属切割及焊接设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机床附件制造', '3425', '机床附件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他金属加工机械制造', '3429', '其他金属加工机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('物料搬运设备制造', '3430', '物料搬运设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('起重运输设备制造', '3430', '物料搬运设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('起重机制造', '3432', '起重机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生产专用车辆制造', '3433', '生产专用车辆制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电梯、自动扶梯及升降机制造', '3435', '电梯、自动扶梯及升降机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他物料搬运设备制造', '3439', '其他物料搬运设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('泵、阀门、压缩机及类似机械制造', '3440', '泵、阀门、压缩机及类似机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('泵、阀门、压缩机及类似机械的制造', '3440', '泵、阀门、压缩机及类似机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('泵及真空设备制造', '3441', '泵及真空设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('气体压缩机械制造', '3442', '气体压缩机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('阀门和旋塞制造', '3443', '阀门和旋塞制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('阀门和旋塞的制造', '3443', '阀门和旋塞制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('液压和气压动力机械及元件制造', '3444', '液压和气压动力机械及元件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('轴承、齿轮和传动部件制造', '3450', '轴承、齿轮和传动部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('轴承、齿轮、传动和驱动部件的制造', '3450', '轴承、齿轮和传动部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('齿轮、传动和驱动部件制造', '3450', '轴承、齿轮和传动部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('轴承制造', '3451', '轴承制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('齿轮及齿轮减、变速箱制造', '3452', '齿轮及齿轮减、变速箱制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他传动部件制造', '3459', '其他传动部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('烘炉、风机、衡器、包装等设备制造', '3460', '烘炉、风机、衡器、包装等设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('风机、衡器、包装设备等通用设备制造', '3460', '烘炉、风机、衡器、包装等设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('烘炉、熔炉及电炉制造', '3461', '烘炉、熔炉及电炉制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('风机、风扇制造', '3462', '风机、风扇制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('气体、液体分离及纯净设备制造', '3463', '气体、液体分离及纯净设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制冷、空调设备制造', '3464', '制冷、空调设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('风动和电动工具制造', '3465', '风动和电动工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('衡器制造', '3467', '衡器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('包装专用设备制造', '3468', '包装专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化、办公用机械制造', '3470', '文化、办公用机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电影机械制造', '3471', '电影机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('幻灯及投影设备制造', '3472', '幻灯及投影设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('照相机及器材制造', '3473', '照相机及器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('复印和胶印设备制造', '3474', '复印和胶印设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算器及货币专用设备制造', '3475', '计算器及货币专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化、办公用机械制造', '3479', '其他文化、办公用机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通用零部件制造', '3480', '通用零部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通用零部件制造及机械修理', '3480', '通用零部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('紧固件、弹簧制造', '3480', '通用零部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属密封件制造', '3481', '金属密封件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('紧固件制造', '3482', '紧固件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('弹簧制造', '3483', '弹簧制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机械零部件加工', '3484', '机械零部件加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机械零部件加工及设备修理', '3484', '机械零部件加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他通用零部件制造', '3489', '其他通用零部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他通用设备制造', '3490', '其他通用设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他通用设备制造业', '3490', '其他通用设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专用设备制造业', '3500', '专用设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('采矿、冶金、建筑专用设备制造', '3510', '采矿、冶金、建筑专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('矿山、冶金、建筑专用设备制造', '3510', '采矿、冶金、建筑专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('采矿、采石设备制造', '3510', '采矿、冶金、建筑专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('矿山机械制造', '3511', '矿山机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石油钻采专用设备制造', '3512', '石油钻采专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑工程用机械制造', '3513', '建筑工程用机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海洋工程专用设备制造', '3514', '海洋工程专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑材料生产专用机械制造', '3515', '建筑材料生产专用机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('冶金专用设备制造', '3516', '冶金专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化工、木材、非金属加工专用设备制造', '3520', '化工、木材、非金属加工专用设备制造');
commit;
prompt 100 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('炼油、化工生产专用设备制造', '3521', '炼油、化工生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶加工专用设备制造', '3522', '橡胶加工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料加工专用设备制造', '3523', '塑料加工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木材加工机械制造', '3524', '木材加工机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('模具制造', '3525', '模具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他非金属加工专用设备制造', '3529', '其他非金属加工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食品、饮料、烟草及饲料生产专用设备制造', '3530', '食品、饮料、烟草及饲料生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食品、饮料、烟草工业专用设备制造', '3530', '食品、饮料、烟草及饲料生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('商业、饮食、服务业专用设备制造', '3530', '食品、饮料、烟草及饲料生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食品、酒、饮料及茶生产专用设备制造', '3531', '食品、酒、饮料及茶生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('印刷、制药、日化及日用品生产专用设备制造', '3540', '印刷、制药、日化及日用品生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('印刷、制药、日化生产专用设备制造', '3540', '印刷、制药、日化及日用品生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制浆和造纸专用设备制造', '3541', '制浆和造纸专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制桨和造纸专用设备制造', '3541', '制浆和造纸专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('印刷专用设备制造', '3542', '印刷专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用化工专用设备制造', '3543', '日用化工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制药专用设备制造', '3544', '制药专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('照明器具生产专用设备制造', '3545', '照明器具生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃、陶瓷和搪瓷制品生产专用设备制造', '3546', '玻璃、陶瓷和搪瓷制品生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用品生产专用设备制造', '3549', '其他日用品生产专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织、服装和皮革加工专用设备制造', '3550', '纺织、服装和皮革加工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织、服装和皮革工业专用设备制造', '3550', '纺织、服装和皮革加工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他服装加工专用设备制造', '3550', '纺织、服装和皮革加工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织专用设备制造', '3551', '纺织专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮革、毛皮及其制品加工专用设备制造', '3552', '皮革、毛皮及其制品加工专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('缝制机械制造', '3553', '缝制机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('缝纫机械制造', '3553', '缝制机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('洗涤机械制造', '3554', '洗涤机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子和电工机械专用设备制造', '3560', '电子和电工机械专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电工机械专用设备制造', '3561', '电工机械专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子工业专用设备制造', '3562', '电子工业专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农、林、牧、渔专用机械制造', '3570', '农、林、牧、渔专用机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机械化农业及园艺机具制造', '3572', '机械化农业及园艺机具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('营林及木竹采伐机械制造', '3573', '营林及木竹采伐机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('渔业机械制造', '3575', '渔业机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农林牧渔机械配件制造', '3576', '农林牧渔机械配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他农、林、牧、渔业机械制造', '3579', '其他农、林、牧、渔业机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他农业牧渔业机械制造及机械修理', '3579', '其他农、林、牧、渔业机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗仪器设备及器械制造', '3580', '医疗仪器设备及器械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗诊断、监护及治疗设备制造', '3581', '医疗诊断、监护及治疗设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗诊断、监扩及治疗设备制造', '3581', '医疗诊断、监护及治疗设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('口腔科用设备及器具制造', '3582', '口腔科用设备及器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('口腔料用设备及器具制造', '3582', '口腔科用设备及器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗实验室及医用消毒设备和器具制造', '3583', '医疗实验室及医用消毒设备和器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('实验室及医用消毒设备和器具的制造', '3583', '医疗实验室及医用消毒设备和器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗、外科及兽医用器械制造', '3584', '医疗、外科及兽医用器械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗、外料及兽医用器械制造', '3584', '医疗、外科及兽医用器械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机械治疗及病房护理设备制造', '3585', '机械治疗及病房护理设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('假肢、人工器官及植（介）入器械制造', '3586', '假肢、人工器官及植（介）入器械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他医疗设备及器械制造', '3589', '其他医疗设备及器械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环保、社会公共服务及其他专用设备制造', '3590', '环保、社会公共服务及其他专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环保、社会公共安全及其他专用设备制造', '3590', '环保、社会公共服务及其他专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境保护专用设备制造', '3591', '环境保护专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境污染防治专用设备制造', '3591', '环境保护专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('邮政专用机械及器材制造', '3593', '邮政专用机械及器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('商业、饮食、服务专用设备制造', '3594', '商业、饮食、服务专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会公共安全设备及器材制造', '3595', '社会公共安全设备及器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('交通安全、管制及类似专用设备制造', '3596', '交通安全、管制及类似专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('交通安全及管制专用设备制造', '3596', '交通安全、管制及类似专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水资源专用机械制造', '3597', '水资源专用机械制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他专用设备制造', '3599', '其他专用设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车制造业', '3600', '汽车制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车制造', '3600', '汽车制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车整车制造', '3610', '汽车整车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('改装汽车制造', '3620', '改装汽车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电车制造', '3640', '电车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车车身、挂车的制造', '3650', '汽车车身、挂车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车车身、挂车制造', '3650', '汽车车身、挂车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车零部件及配件制造', '3660', '汽车零部件及配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路、船舶、航空航天和其他运输设备制造业', '3700', '铁路、船舶、航空航天和其他运输设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('交通运输设备制造业', '3700', '铁路、船舶、航空航天和其他运输设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('交通器材及其他交通运输设备制造', '3700', '铁路、船舶、航空航天和其他运输设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路运输设备制造', '3710', '铁路运输设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路专用设备及器材、配件制造', '3714', '铁路专用设备及器材、配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他铁路运输设备制造', '3719', '其他铁路运输设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他铁路设备制造及设备修理', '3719', '其他铁路运输设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城市轨道交通设备制造', '3720', '城市轨道交通设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('船舶及相关装置制造', '3730', '船舶及相关装置制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('船舶及浮动装置制造', '3730', '船舶及相关装置制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航标器材及其他浮动装置的制造', '3730', '船舶及相关装置制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属船舶制造', '3731', '金属船舶制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非金属船舶制造', '3732', '非金属船舶制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('娱乐船和运动船制造', '3733', '娱乐船和运动船制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('娱乐船和运动船的建造和修理', '3733', '娱乐船和运动船制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('船用配套设备制造', '3734', '船用配套设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('船舶改装与拆除', '3735', '船舶改装与拆除');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空、航天器及设备制造', '3740', '航空、航天器及设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空航天器制造', '3740', '航空、航天器及设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空、航天及其他专用设备制造', '3740', '航空、航天器及设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('飞机制造', '3741', '飞机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('飞机制造及修理', '3741', '飞机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航天器制造', '3742', '航天器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空、航天相关设备制造', '3743', '航空、航天相关设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他航空航天器制造', '3749', '其他航空航天器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他飞行器制造', '3749', '其他航空航天器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('摩托车制造', '3750', '摩托车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('摩托车零部件及配件制造', '3752', '摩托车零部件及配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自行车制造', '3760', '自行车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('脚踏自行车及残疾人座车制造', '3761', '脚踏自行车及残疾人座车制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('助动自行车制造', '3762', '助动自行车制造');
commit;
prompt 200 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非公路休闲车及零配件制造', '3770', '非公路休闲车及零配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('潜水救捞及其他未列明运输设备制造', '3790', '潜水救捞及其他未列明运输设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('潜水及水下救捞装备制造', '3791', '潜水及水下救捞装备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明运输设备制造', '3799', '其他未列明运输设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他交通运输设备制造', '3799', '其他未列明运输设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电气机械和器材制造业', '3800', '电气机械和器材制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电气机械及器材制造业', '3800', '电气机械和器材制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电机制造', '3810', '电机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('发电机及发电机组制造', '3811', '发电机及发电机组制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电动机制造', '3812', '电动机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('微电机及其他电机制造', '3819', '微电机及其他电机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('输配电及控制设备制造', '3820', '输配电及控制设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('变压器、整流器和电感器制造', '3821', '变压器、整流器和电感器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电容器及其配套设备制造', '3822', '电容器及其配套设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('配电开关控制设备制造', '3823', '配电开关控制设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电力电子元器件制造', '3824', '电力电子元器件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('光伏设备及元器件制造', '3825', '光伏设备及元器件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他输配电及控制设备制造', '3829', '其他输配电及控制设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电线、电缆、光缆及电工器材制造', '3830', '电线、电缆、光缆及电工器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电线、电缆制造', '3831', '电线、电缆制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电线电缆制造', '3831', '电线、电缆制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('光纤、光缆制造', '3832', '光纤、光缆制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('绝缘制品制造', '3833', '绝缘制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他电工器材制造', '3839', '其他电工器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电池制造', '3840', '电池制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锂离子电池制造', '3841', '锂离子电池制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('镍氢电池制造', '3842', '镍氢电池制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用电力器具制造', '3850', '家用电力器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用制冷电器具制造', '3851', '家用制冷电器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用空气调节器制造', '3852', '家用空气调节器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用通风电器具制造', '3853', '家用通风电器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用厨房电器具制造', '3854', '家用厨房电器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用清洁卫生电器具制造', '3855', '家用清洁卫生电器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用美容、保健电器具制造', '3856', '家用美容、保健电器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用电力器具专用配件制造', '3857', '家用电力器具专用配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他家用电力器具制造', '3859', '其他家用电力器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非电力家用器具制造', '3860', '非电力家用器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('燃气、太阳能及类似能源家用器具制造', '3861', '燃气、太阳能及类似能源家用器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('燃气、太阳能及类似能源的器具制造', '3861', '燃气、太阳能及类似能源家用器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他非电力家用器具制造', '3869', '其他非电力家用器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('照明器具制造', '3870', '照明器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电光源制造', '3871', '电光源制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('照明灯具制造', '3872', '照明灯具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('灯用电器附件及其他照明器具制造', '3879', '灯用电器附件及其他照明器具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他电气机械及器材制造', '3890', '其他电气机械及器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电气信号设备装置制造', '3891', '电气信号设备装置制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('车辆专用照明及电气信号设备装置制造', '3891', '电气信号设备装置制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明电气机械及器材制造', '3899', '其他未列明电气机械及器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的电气机械制造', '3899', '其他未列明电气机械及器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机、通信和其他电子设备制造业', '3900', '计算机、通信和其他电子设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通信设备、计算机及其他电子设备制造业', '3900', '计算机、通信和其他电子设备制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机制造', '3910', '计算机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子计算机制造', '3910', '计算机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机整机制造', '3911', '计算机整机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子计算机整机制造', '3911', '计算机整机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机零部件制造', '3912', '计算机零部件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机外围设备制造', '3913', '计算机外围设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子计算机外部设备制造', '3913', '计算机外围设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他计算机制造', '3919', '其他计算机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通信设备制造', '3920', '通信设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他通信设备制造', '3920', '通信设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机网络设备制造', '3920', '通信设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通信传输设备制造', '3920', '通信设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通信系统设备制造', '3921', '通信系统设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通信终端设备制造', '3922', '通信终端设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('移动通信及终端设备制造', '3922', '通信终端设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通信交换设备制造', '3922', '通信终端设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广播电视设备制造', '3930', '广播电视设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广播电视节目制作及发射设备制造', '3931', '广播电视节目制作及发射设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广播电视接收设备及器材制造', '3932', '广播电视接收设备及器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('应用电视设备及其他广播电视设备制造', '3939', '应用电视设备及其他广播电视设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('雷达及配套设备制造', '3940', '雷达及配套设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('视听设备制造', '3950', '视听设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农业', '0100', '农业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('谷物种植', '0110', '谷物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('谷物及其他作物的种植', '0110', '谷物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('谷物的种植', '0110', '谷物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('稻谷种植', '0111', '稻谷种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他谷物种植', '0119', '其他谷物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('豆类、油料和薯类种植', '0120', '豆类、油料和薯类种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蔬菜、食用菌及园艺作物种植', '0140', '蔬菜、食用菌及园艺作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蔬菜、园艺作物的种植', '0140', '蔬菜、食用菌及园艺作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蔬菜种植', '0141', '蔬菜种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蔬菜的种植', '0141', '蔬菜种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食用菌种植', '0142', '食用菌种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('花卉种植', '0143', '花卉种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('花卉的种植', '0143', '花卉种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他园艺作物种植', '0149', '其他园艺作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他园艺作物的种植', '0149', '其他园艺作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水果种植', '0150', '水果种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水果、坚果的种植', '0150', '水果种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('葡萄种植', '0152', '葡萄种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水果种植', '0159', '其他水果种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('坚果、含油果、香料和饮料作物种植', '0160', '坚果、含油果、香料和饮料作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水果、坚果、饮料和香料作物种植', '0160', '坚果、含油果、香料和饮料作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('香料作物的种植', '0163', '香料作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('茶及其他饮料作物种植', '0169', '茶及其他饮料作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('茶及其他饮料作物的种植', '0169', '茶及其他饮料作物种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中药材的种植', '0170', '中药材种植');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中药材种植', '0170', '中药材种植');
commit;
prompt 300 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他作物的种植', '0190', '其他农业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他农业', '0190', '其他农业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林业', '0200', '林业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林木育种和育苗', '0210', '林木育种和育苗');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林木的培育和种植', '0210', '林木育种和育苗');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('育种和育苗', '0210', '林木育种和育苗');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林木的抚育和管理', '0210', '林木育种和育苗');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林木育种', '0211', '林木育种');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林木育苗', '0212', '林木育苗');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('造林', '0220', '造林和更新');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('造林和更新', '0220', '造林和更新');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('畜牧业', '0300', '畜牧业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('牲畜饲养', '0310', '牲畜饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('牲畜的饲养', '0310', '牲畜饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('牛的饲养', '0311', '牛的饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('马的饲养', '0312', '马的饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('猪的饲养', '0313', '猪的饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('羊的饲养', '0314', '羊的饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他牲畜饲养', '0319', '其他牲畜饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家禽饲养', '0320', '家禽饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家禽的饲养', '0320', '家禽饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他家禽饲养', '0329', '其他家禽饲养');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('狩猎和捕捉动物', '0330', '狩猎和捕捉动物');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他畜牧业', '0390', '其他畜牧业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('渔业', '0400', '渔业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('内陆渔业', '0400', '渔业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水产养殖', '0410', '水产养殖');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海水养殖', '0411', '海水养殖');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海洋渔业', '0411', '海水养殖');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('内陆养殖', '0412', '内陆养殖');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水产捕捞', '0420', '水产捕捞');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海水捕捞', '0421', '海水捕捞');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海洋捕捞', '0421', '海水捕捞');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农、林、牧、渔服务业', '0500', '农、林、牧、渔服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农业服务业', '0510', '农业服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农业机械服务', '0511', '农业机械服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('灌溉服务', '0512', '灌溉服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农产品初加工服务', '0513', '农产品初加工服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他农业服务', '0519', '其他农业服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林业服务业', '0520', '林业服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林业有害生物防治服务', '0521', '林业有害生物防治服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他林业服务', '0529', '其他林业服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('渔业服务业', '0540', '渔业服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('煤炭开采和洗选业', '0600', '煤炭开采和洗选业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石油和天然气开采业', '0700', '石油和天然气开采业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('天然原油和天然气开采', '0700', '石油和天然气开采业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石油开采', '0710', '石油开采');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有色金属矿采选业', '0900', '有色金属矿采选业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('常用有色金属矿采选', '0910', '常用有色金属矿采选');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非金属矿采选业', '1000', '非金属矿采选业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('土砂石开采', '1010', '土砂石开采');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石棉及其他非金属矿采选', '1090', '石棉及其他非金属矿采选');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('宝石、玉石采选', '1093', '宝石、玉石采选');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('与石油和天然气开采有关的服务活动', '1120', '石油和天然气开采辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石油和天然气开采辅助活动', '1120', '石油和天然气开采辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农副食品加工业', '1300', '农副食品加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('谷物磨制', '1310', '谷物磨制');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饲料加工', '1320', '饲料加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('植物油加工', '1330', '植物油加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食用植物油加工', '1331', '食用植物油加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非食用植物油加工', '1332', '非食用植物油加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制糖', '1340', '制糖业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制糖业', '1340', '制糖业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('屠宰及肉类加工', '1350', '屠宰及肉类加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('畜禽屠宰', '1351', '牲畜屠宰');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('牲畜屠宰', '1351', '牲畜屠宰');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肉制品及副产品加工', '1353', '肉制品及副产品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水产品加工', '1360', '水产品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水产品冷冻加工', '1361', '水产品冷冻加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('鱼糜制品及水产品干腌制加工', '1362', '鱼糜制品及水产品干腌制加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水产饲料制造', '1363', '水产饲料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水产品加工', '1369', '其他水产品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蔬菜、水果和坚果加工', '1370', '蔬菜、水果和坚果加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蔬菜加工', '1371', '蔬菜加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水果和坚果加工', '1372', '水果和坚果加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他农副食品加工', '1390', '其他农副食品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('淀粉及淀粉制品制造', '1391', '淀粉及淀粉制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('淀粉及淀粉制品的制造', '1391', '淀粉及淀粉制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('豆制品制造', '1392', '豆制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蛋品加工', '1393', '蛋品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明农副食品加工', '1399', '其他未列明农副食品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的农副食品加工', '1399', '其他未列明农副食品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食品制造业', '1400', '食品制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('焙烤食品制造', '1410', '焙烤食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('糕点、面包制造', '1411', '糕点、面包制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饼干及其他焙烤食品制造', '1419', '饼干及其他焙烤食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('糖果、巧克力及蜜饯制造', '1420', '糖果、巧克力及蜜饯制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('糖果、巧克力制造', '1421', '糖果、巧克力制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蜜饯制作', '1422', '蜜饯制作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('方便食品制造', '1430', '方便食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('米、面制品制造', '1431', '米、面制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('速冻食品制造', '1432', '速冻食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('方便面及其他方便食品制造', '1439', '方便面及其他方便食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('液体乳及乳制品制造', '1440', '乳制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('乳制品制造', '1440', '乳制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('罐头食品制造', '1450', '罐头食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('罐头制造', '1450', '罐头食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肉、禽类罐头制造', '1451', '肉、禽类罐头制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('蔬菜、水果罐头制造', '1453', '蔬菜、水果罐头制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('调味品、发酵制品制造', '1460', '调味品、发酵制品制造');
commit;
prompt 400 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('味精制造', '1461', '味精制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酱油、食醋及类似制品制造', '1462', '酱油、食醋及类似制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酱油、食醋及类似制品的制造', '1462', '酱油、食醋及类似制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他调味品、发酵制品制造', '1469', '其他调味品、发酵制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他食品制造', '1490', '其他食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('营养、保健食品制造', '1490', '其他食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('保健食品制造', '1492', '保健食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('冷冻饮品及食用冰制造', '1493', '冷冻饮品及食用冰制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('盐加工', '1494', '盐加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食品及饲料添加剂制造', '1495', '食品及饲料添加剂制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明食品制造', '1499', '其他未列明食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的食品制造', '1499', '其他未列明食品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酒、饮料和精制茶制造业', '1500', '酒、饮料和精制茶制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酒的制造', '1510', '酒的制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酒精制造', '1511', '酒精制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('白酒制造', '1512', '白酒制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('啤酒制造', '1513', '啤酒制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('黄酒制造', '1514', '黄酒制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('葡萄酒制造', '1515', '葡萄酒制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他酒制造', '1519', '其他酒制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饮料制造', '1520', '饮料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饮料制造业', '1520', '饮料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('软饮料制造', '1520', '饮料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('瓶（罐）装饮用水制造', '1522', '瓶（罐）装饮用水制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('果菜汁及果菜汁饮料制造', '1523', '果菜汁及果菜汁饮料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('固体饮料制造', '1525', '固体饮料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('茶饮料及其他饮料制造', '1529', '茶饮料及其他饮料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('茶饮料及其他软饮料制造', '1529', '茶饮料及其他饮料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('精制茶加工', '1530', '精制茶加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他烟草制品加工', '1690', '其他烟草制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他烟草制品制造', '1690', '其他烟草制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织业', '1700', '纺织业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织、面料、鞋的制造', '1700', '纺织业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉及化纤制品制造', '1700', '纺织业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉纺织及印染精加工', '1710', '棉纺织及印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉、化纤印染精加工', '1710', '棉纺织及印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉纺纱加工', '1711', '棉纺纱加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉、化纤纺织加工', '1711', '棉纺纱加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉织造加工', '1712', '棉织造加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉印染精加工', '1713', '棉印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛纺织及染整精加工', '1720', '毛纺织及染整精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛纺织', '1720', '毛纺织及染整精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛纺织和染整精加工', '1720', '毛纺织及染整精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛条和毛纱线加工', '1721', '毛条和毛纱线加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛条加工', '1721', '毛条和毛纱线加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛织造加工', '1722', '毛织造加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛染整精加工', '1723', '毛染整精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('麻纺织及染整精加工', '1730', '麻纺织及染整精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('麻纺织', '1730', '麻纺织及染整精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('麻纤维纺前加工和纺纱', '1731', '麻纤维纺前加工和纺纱');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('麻织造加工', '1732', '麻织造加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('丝绢纺织及印染精加工', '1740', '丝绢纺织及印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('丝绢纺织及精加工', '1740', '丝绢纺织及印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('丝制品制造', '1740', '丝绢纺织及印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('缫丝加工', '1741', '缫丝加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('绢纺和丝织加工', '1742', '绢纺和丝织加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('丝印染精加工', '1743', '丝印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化纤织造及印染精加工', '1750', '化纤织造及印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉、化纤纺织及印染精加工', '1750', '化纤织造及印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化纤织造加工', '1751', '化纤织造加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('无纺布制造', '1751', '化纤织造加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化纤织物染整精加工', '1752', '化纤织物染整精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('针织或钩针编织物及其制品制造', '1760', '针织或钩针编织物及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('针织品、编织品及其制品制造', '1760', '针织或钩针编织物及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他针织及编织品制造', '1760', '针织或钩针编织物及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉、化纤针织品及编织品制造', '1760', '针织或钩针编织物及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛针织品及编织品制造', '1760', '针织或钩针编织物及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('丝针织品及编织品制造', '1760', '针织或钩针编织物及其制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('针织或钩针编织物织造', '1761', '针织或钩针编织物织造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('针织或钩针编织物印染精加工', '1762', '针织或钩针编织物印染精加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('针织或钩针编织品制造', '1763', '针织或钩针编织品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用纺织制成品制造', '1770', '家用纺织制成品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织制成品制造', '1770', '家用纺织制成品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('床上用品制造', '1771', '床上用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛巾类制品制造', '1772', '毛巾类制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('窗帘、布艺类产品制造', '1773', '窗帘、布艺类产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他家用纺织制成品制造', '1779', '其他家用纺织制成品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他纺织制成品制造', '1779', '其他家用纺织制成品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非家用纺织制成品制造', '1780', '非家用纺织制成品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非织造布制造', '1781', '非织造布制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('绳、索、缆制造', '1782', '绳、索、缆制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('绳、索、缆的制造', '1782', '绳、索、缆制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织带和帘子布制造', '1783', '纺织带和帘子布制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('篷、帆布制造', '1784', '篷、帆布制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他非家用纺织制成品制造', '1789', '其他非家用纺织制成品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织服装、服饰业', '1800', '纺织服装、服饰业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织服装制造', '1800', '纺织服装、服饰业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织服装、鞋、帽制造业', '1800', '纺织服装、服饰业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机织服装制造', '1810', '机织服装制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('针织或钩针编织服装制造', '1820', '针织或钩针编织服装制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制帽', '1830', '服饰制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('服饰制造', '1830', '服饰制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮革、毛皮、羽毛及其制品和制鞋业', '1900', '皮革、毛皮、羽毛及其制品和制鞋业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮革、毛皮、羽毛（绒）及其制品业', '1900', '皮革、毛皮、羽毛及其制品和制鞋业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮革鞣制加工', '1910', '皮革鞣制加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮革制品制造', '1920', '皮革制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮革服装制造', '1921', '皮革服装制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮箱、包(袋)制造', '1922', '皮箱、包(袋)制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮箱、包（袋）制造', '1922', '皮箱、包（袋）制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮手套及皮装饰制品制造', '1923', '皮手套及皮装饰制品制造');
commit;
prompt 500 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他皮革制品制造', '1929', '其他皮革制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛皮鞣制及制品加工', '1930', '毛皮鞣制及制品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛制品制造', '1930', '毛皮鞣制及制品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('毛皮服装加工', '1932', '毛皮服装加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他毛皮制品加工', '1939', '其他毛皮制品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('羽毛(绒)加工及制品制造', '1940', '羽毛(绒)加工及制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('羽毛（绒）加工及制品制造', '1940', '羽毛(绒)加工及制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('羽毛(绒)加工', '1941', '羽毛(绒)加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('羽毛（绒）加工', '1941', '羽毛（绒）加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('羽毛(绒)制品加工', '1942', '羽毛(绒)制品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('羽毛（绒）制品加工', '1942', '羽毛（绒）制品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制鞋业', '1950', '制鞋业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织面料鞋制造', '1951', '纺织面料鞋制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('皮鞋制造', '1952', '皮鞋制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料鞋制造', '1953', '塑料鞋制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶鞋制造', '1954', '橡胶鞋制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶靴鞋制造', '1954', '橡胶鞋制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他制鞋业', '1959', '其他制鞋业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木材加工和木、竹、藤、棕、草制品业', '2000', '木材加工和木、竹、藤、棕、草制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木材加工及木、竹、藤、棕、草制品业', '2000', '木材加工和木、竹、藤、棕、草制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木材加工', '2010', '木材加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锯材、木片加工', '2010', '木材加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锯材加工', '2011', '锯材加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木片加工', '2012', '木片加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他木材加工', '2019', '其他木材加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('人造板制造', '2020', '人造板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('胶合板制造', '2021', '胶合板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纤维板制造', '2022', '纤维板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('刨花板制造', '2023', '刨花板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他人造板制造', '2029', '其他人造板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他人造板、材制造', '2029', '其他人造板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木制品制造', '2030', '木制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑用木料及木材组件加工', '2031', '建筑用木料及木材组件加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木门窗、楼梯制造', '2032', '木门窗、楼梯制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('地板制造', '2033', '地板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木制容器制造', '2034', '木制容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木容器制造', '2034', '木制容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('软木制品及其他木制品制造', '2039', '软木制品及其他木制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('竹、藤、棕、草等制品制造', '2040', '竹、藤、棕、草等制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('竹、藤、棕、草制品制造', '2040', '竹、藤、棕、草等制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('竹制品制造', '2041', '竹制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棕制品制造', '2043', '棕制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('草及其他制品制造', '2049', '草及其他制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家具制造业', '2100', '家具制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木质家具制造', '2110', '木质家具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('竹、藤家具制造', '2120', '竹、藤家具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属家具制造', '2130', '金属家具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料家具制造', '2140', '塑料家具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他家具制造', '2190', '其他家具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('造纸和纸制品业', '2200', '造纸和纸制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('造纸及纸制品业', '2200', '造纸和纸制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纸浆制造', '2210', '纸浆制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('造纸', '2220', '造纸');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机制纸及纸板制造', '2221', '机制纸及纸板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('加工纸制造', '2223', '加工纸制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纸制品制造', '2230', '纸制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纸和纸板容器制造', '2231', '纸和纸板容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纸和纸板容器的制造', '2231', '纸和纸板容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他纸制品制造', '2239', '其他纸制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('印刷和记录媒介复制业', '2300', '印刷和记录媒介复制业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('印刷业和记录媒介的复制', '2300', '印刷和记录媒介复制业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('记录媒介的复制', '2300', '印刷和记录媒介复制业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('印刷', '2310', '印刷');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('书、报刊印刷', '2311', '书、报刊印刷');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('本册印制', '2312', '本册印制');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('包装装潢及其他印刷', '2319', '包装装潢及其他印刷');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('装订及其他印刷服务活动', '2320', '装订及印刷相关服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('装订及印刷相关服务', '2320', '装订及印刷相关服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('记录媒介复制', '2330', '记录媒介复制');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文教、工美、体育和娱乐用品制造业', '2400', '文教、工美、体育和娱乐用品制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化用品制造', '2400', '文教、工美、体育和娱乐用品制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文教体育用品制造业', '2400', '文教、工美、体育和娱乐用品制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文教办公用品制造', '2410', '文教办公用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文具制造', '2411', '文具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('笔的制造', '2412', '笔的制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('教学用模型及教具制造', '2413', '教学用模型及教具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('墨水、墨汁制造', '2414', '墨水、墨汁制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文教办公用品制造', '2419', '其他文教办公用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化用品制造', '2419', '其他文教办公用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('乐器制造', '2420', '乐器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中乐器制造', '2421', '中乐器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('西乐器制造', '2422', '西乐器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子乐器制造', '2423', '电子乐器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他乐器及零件制造', '2429', '其他乐器及零件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工艺美术品制造', '2430', '工艺美术品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工艺品及其他制造业', '2430', '工艺美术品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('雕塑工艺品制造', '2431', '雕塑工艺品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属工艺品制造', '2432', '金属工艺品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('漆器工艺品制造', '2433', '漆器工艺品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('花画工艺品制造', '2434', '花画工艺品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('天然植物纤维编织工艺品制造', '2435', '天然植物纤维编织工艺品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('抽纱刺绣工艺品制造', '2436', '抽纱刺绣工艺品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('地毯、挂毯制造', '2437', '地毯、挂毯制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('珠宝首饰及有关物品制造', '2438', '珠宝首饰及有关物品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('珠宝首饰及有关物品的制造', '2438', '珠宝首饰及有关物品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他工艺美术品制造', '2439', '其他工艺美术品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育用品制造', '2440', '体育用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育器材及配件制造', '2442', '体育器材及配件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('训练健身器材制造', '2443', '训练健身器材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('运动防护用具制造', '2444', '运动防护用具制造');
commit;
prompt 600 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他体育用品制造', '2449', '其他体育用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玩具制造', '2450', '玩具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('游艺器材及娱乐用品制造', '2460', '游艺器材及娱乐用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('露天游乐场所游乐设备制造', '2461', '露天游乐场所游乐设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石油加工、炼焦和核燃料加工业', '2500', '石油加工、炼焦和核燃料加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石油加工、炼焦及核燃料加工业', '2500', '石油加工、炼焦和核燃料加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('精炼石油产品制造', '2510', '精炼石油产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('精炼石油产品的制造', '2510', '精炼石油产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('原油加工及石油制品制造', '2511', '原油加工及石油制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('人造原油制造', '2512', '人造原油制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('人造原油生产', '2512', '人造原油制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学原料和化学制品制造业', '2600', '化学原料和化学制品制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学原料及化学制品制造业', '2600', '化学原料和化学制品制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('基础化学原料制造', '2610', '基础化学原料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('无机酸制造', '2611', '无机酸制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('无机盐制造', '2613', '无机盐制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有机化学原料制造', '2614', '有机化学原料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他基础化学原料制造', '2619', '其他基础化学原料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肥料制造', '2620', '肥料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('复混肥料制造', '2624', '复混肥料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有机肥料及微生物肥料制造', '2625', '有机肥料及微生物肥料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他肥料制造', '2629', '其他肥料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农药制造', '2630', '农药制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学农药制造', '2631', '化学农药制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生物化学农药及微生物农药制造', '2632', '生物化学农药及微生物农药制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生物、生化制品的制造', '2632', '生物化学农药及微生物农药制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('涂料、油墨、颜料及类似产品制造', '2640', '涂料、油墨、颜料及类似产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('涂料制造', '2641', '涂料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('油墨及类似产品制造', '2642', '油墨及类似产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('颜料制造', '2643', '颜料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('染料制造', '2644', '染料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('密封用填料及类似品制造', '2645', '密封用填料及类似品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('合成材料制造', '2650', '合成材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('初级形态塑料及合成树脂制造', '2651', '初级形态塑料及合成树脂制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('初级形态的塑料及合成树脂制造', '2651', '初级形态塑料及合成树脂制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('合成橡胶制造', '2652', '合成橡胶制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('合成纤维单(聚合)体制造', '2653', '合成纤维单(聚合)体制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('合成纤维单（聚合）体的制造', '2653', '合成纤维单（聚合）体制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他合成材料制造', '2659', '其他合成材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专用化学产品制造', '2660', '专用化学产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学试剂和助剂制造', '2661', '化学试剂和助剂制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专项化学品制造', '2662', '专项化学用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('信息化学品制造', '2664', '信息化学品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境污染处理专用药剂材料制造', '2665', '环境污染处理专用药剂材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他专用化学产品制造', '2669', '其他专用化学产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用化学产品制造', '2680', '日用化学产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肥皂及合成洗涤剂制造', '2681', '肥皂及合成洗涤剂制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化妆品制造', '2682', '化妆品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('口腔清洁用品制造', '2683', '口腔清洁用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('香料、香精制造', '2684', '香料、香精制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用化学产品制造', '2689', '其他日用化学产品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医药制造业', '2700', '医药制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学药品原药制造', '2710', '化学药品原料药制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学药品原料药制造', '2710', '化学药品原料药制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学药品制剂制造', '2720', '化学药品制剂制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中药饮片加工', '2730', '中药饮片加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中成药制造', '2740', '中成药生产');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中成药生产', '2740', '中成药生产');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('兽用药品制造', '2750', '兽用药品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生物药品制造', '2760', '生物药品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('卫生材料及医药用品制造', '2770', '卫生材料及医药用品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化学纤维制造业', '2800', '化学纤维制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纤维素纤维原料及纤维制造', '2810', '纤维素纤维原料及纤维制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化纤浆粕制造', '2811', '化纤浆粕制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('人造纤维（纤维素纤维）制造', '2812', '人造纤维（纤维素纤维）制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('合成纤维制造', '2820', '合成纤维制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锦纶纤维制造', '2821', '锦纶纤维制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('涤纶纤维制造', '2822', '涤纶纤维制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('腈纶纤维制造', '2823', '腈纶纤维制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('氨纶纤维制造', '2826', '氨纶纤维制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他合成纤维制造', '2829', '其他合成纤维制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶和塑料制品业', '2900', '橡胶和塑料制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶制品业', '2910', '橡胶制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('轮胎制造', '2911', '轮胎制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('轮胎翻新加工', '2911', '轮胎制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('力车胎制造', '2911', '轮胎制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶板、管、带制造', '2912', '橡胶板、管、带制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶板、管、带的制造', '2912', '橡胶板、管、带制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('橡胶零件制造', '2913', '橡胶零件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('再生橡胶制造', '2914', '再生橡胶制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用及医用橡胶制品制造', '2915', '日用及医用橡胶制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他橡胶制品制造', '2919', '其他橡胶制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料制品业', '2920', '塑料制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料薄膜制造', '2921', '塑料薄膜制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料板、管、型材制造', '2922', '塑料板、管、型材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料板、管、型材的制造', '2922', '塑料板、管、型材制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料丝、绳及编织品制造', '2923', '塑料丝、绳及编织品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料丝、绳及编织品的制造', '2923', '塑料丝、绳及编织品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('泡沫塑料制造', '2924', '泡沫塑料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料人造革、合成革制造', '2925', '塑料人造革、合成革制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料包装箱及容器制造', '2926', '塑料包装箱及容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用塑料制品制造', '2927', '日用塑料制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用塑料杂品制造', '2927', '日用塑料制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用塑料制造', '2927', '日用塑料制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('塑料零件制造', '2928', '塑料零件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他塑料制品制造', '2929', '其他塑料制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非金属矿物制品业', '3000', '非金属矿物制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水泥、石灰和石膏制造', '3010', '水泥、石灰和石膏制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水泥及石膏制品制造', '3010', '水泥、石灰和石膏制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水泥、石灰和石膏的制造', '3010', '水泥、石灰和石膏制造');
commit;
prompt 700 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水泥制造', '3011', '水泥制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石灰和石膏制造', '3012', '石灰和石膏制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石膏、水泥制品及类似制品制造', '3020', '石膏、水泥制品及类似制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水泥制品制造', '3021', '水泥制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('砼结构构件制造', '3022', '砼结构构件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石棉水泥制品制造', '3023', '石棉水泥制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('轻质建筑材料制造', '3024', '轻质建筑材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水泥类似制品制造', '3029', '其他水泥类似制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水泥制品制造', '3029', '其他水泥类似制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('砖瓦、石材等建筑材料制造', '3030', '砖瓦、石材等建筑材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('砖瓦、石材及其他建筑材料制造', '3030', '砖瓦、石材等建筑材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('粘土砖瓦及建筑砌块制造', '3031', '粘土砖瓦及建筑砌块制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('粘土砖瓦及建筑砌 块制造', '3031', '粘土砖瓦及建筑砌块制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑陶瓷制品制造', '3032', '建筑陶瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑用石加工', '3033', '建筑用石加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('防水建筑材料制造', '3034', '防水建筑材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('隔热和隔音材料制造', '3035', '隔热和隔音材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他建筑材料制造', '3039', '其他建筑材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃制造', '3040', '玻璃制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃及玻璃制品制造', '3040', '玻璃制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('平板玻璃制造', '3041', '平板玻璃制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他玻璃制造', '3049', '其他玻璃制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃制品制造', '3050', '玻璃制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用玻璃制品及玻璃包装容器制造', '3050', '玻璃制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('技术玻璃制品制造', '3051', '技术玻璃制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('光学玻璃制造', '3052', '光学玻璃制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃仪器制造', '3053', '玻璃仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用玻璃制品制造', '3054', '日用玻璃制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃包装容器制造', '3055', '玻璃包装容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃保温容器制造', '3056', '玻璃保温容器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('制镜及类似品加工', '3057', '制镜及类似品加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他玻璃制品制造', '3059', '其他玻璃制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃纤维和玻璃纤维增强塑料制品制造', '3060', '玻璃纤维和玻璃纤维增强塑料制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃纤维及制品制造', '3061', '玻璃纤维及制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('玻璃纤维增强塑料制品制造', '3062', '玻璃纤维增强塑料制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('陶瓷制品制造', '3070', '陶瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('卫生陶瓷制品制造', '3071', '卫生陶瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('特种陶瓷制品制造', '3072', '特种陶瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用陶瓷制品制造', '3073', '日用陶瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('园林、陈设艺术及其他陶瓷制品制造', '3079', '园林、陈设艺术及其他陶瓷制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('耐火材料制品制造', '3080', '耐火材料制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石棉制品制造', '3081', '石棉制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('耐火陶瓷制品及其他耐火材料制造', '3089', '耐火陶瓷制品及其他耐火材料制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石墨及其他非金属矿物制品制造', '3090', '石墨及其他非金属矿物制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石墨及碳素制品制造', '3091', '石墨及碳素制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他非金属矿物制品制造', '3099', '其他非金属矿物制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('黑色金属冶炼和压延加工业', '3100', '黑色金属冶炼和压延加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('黑色金属冶炼及压延加工业', '3100', '黑色金属冶炼和压延加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('炼铁', '3110', '炼铁');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('炼钢', '3120', '炼钢');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('黑色金属铸造', '3130', '黑色金属铸造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('钢压延加工', '3140', '钢压延加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁合金冶炼', '3150', '铁合金冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有色金属冶炼和压延加工业', '3200', '有色金属冶炼和压延加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有色金属冶炼及压延加工业', '3200', '有色金属冶炼和压延加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属铸、锻加工', '3200', '有色金属冶炼和压延加工业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('常用有色金属冶炼', '3210', '常用有色金属冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('常用有色金属压延加工', '3210', '常用有色金属冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铜冶炼', '3211', '铜冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('锡冶炼', '3214', '锡冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铝冶炼', '3216', '铝冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他常用有色金属冶炼', '3219', '其他常用有色金属冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('贵金属冶炼', '3220', '贵金属冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('稀有稀土金属冶炼', '3230', '稀有稀土金属冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('稀土金属冶炼', '3232', '稀土金属冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他稀有金属冶炼', '3239', '其他稀有金属冶炼');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有色金属合金制造', '3240', '有色金属合金制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有色金属铸造', '3250', '有色金属铸造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有色金属压延加工', '3260', '有色金属压延加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铜压延加工', '3261', '铜压延加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铝压延加工', '3262', '铝压延加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('贵金属压延加工', '3263', '贵金属压延加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('稀有稀土金属压延加工', '3264', '稀有稀土金属压延加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他有色金属压延加工', '3269', '其他有色金属压延加工');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制品业', '3300', '金属制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('钢铁铸件制造', '3300', '金属制品业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('结构性金属制品制造', '3310', '结构性金属制品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属结构制造', '3311', '金属结构制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属门窗制造', '3312', '金属门窗制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属工具制造', '3320', '金属工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('不锈钢及类似日用金属制品制造', '3320', '金属工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('切削工具制造', '3321', '切削工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('手工具制造', '3322', '手工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农用及园林用金属工具制造', '3323', '农用及园林用金属工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('刀剪及类似日用金属工具制造', '3324', '刀剪及类似日用金属工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他金属工具制造', '3329', '其他金属工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('节能技术推广服务', '7514', '节能技术推广服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他技术推广服务', '7519', '其他技术推广服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('科技中介服务', '7520', '科技中介服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他科技服务', '7590', '其他科技推广和应用服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他科技推广和应用服务业', '7590', '其他科技推广和应用服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水利管理业', '7600', '水利管理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('防洪管理', '7610', '防洪除涝设施管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水资源管理', '7620', '水资源管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水利管理', '7690', '其他水利管理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水资源管理', '7690', '其他水利管理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水利管理业', '7690', '其他水利管理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生态保护和环境治理业', '7700', '生态保护和环境治理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生态保护', '7710', '生态保护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自然保护', '7710', '生态保护');
commit;
prompt 800 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自然保护区管理', '7711', '自然保护区管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('野生动物保护', '7712', '野生动物保护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('野生植物保护', '7713', '野生植物保护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他自然保护', '7719', '其他自然保护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境治理业', '7720', '环境治理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境治理', '7720', '环境治理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境管理业', '7720', '环境治理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水污染治理', '7721', '水污染治理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('大气污染治理', '7722', '大气污染治理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('固体废物治理', '7723', '固体废物治理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('危险废物治理', '7724', '危险废物治理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他污染治理', '7729', '其他污染治理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他环境治理', '7729', '其他污染治理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公共设施管理业', '7800', '公共设施管理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('市政公共设施管理', '7810', '市政设施管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('市政设施管理', '7810', '市政设施管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城市环境卫生管理', '7820', '环境卫生管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境卫生管理', '7820', '环境卫生管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城市市容管理', '7830', '城乡市容管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城乡市容管理', '7830', '城乡市容管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城市绿化管理', '7840', '绿化管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('绿化管理', '7840', '绿化管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公园和游览景区管理', '7850', '公园和游览景区管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他游览景区管理', '7850', '公园和游览景区管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公园管理', '7851', '公园管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('游览景区管理', '7852', '游览景区管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('风景名胜区管理', '7852', '游览景区管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('居民服务业', '7900', '居民服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家庭服务', '7910', '家庭服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('洗染服务', '7930', '洗染服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('理发及美容保健服务', '7940', '理发及美容服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('理发及美容服务', '7940', '理发及美容服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('洗浴服务', '7950', '洗浴服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('保健服务', '7960', '保健服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('婚姻服务', '7970', '婚姻服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('殡葬服务', '7980', '殡葬服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他居民服务', '7990', '其他居民服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他居民服务业', '7990', '其他居民服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机动车、电子产品和日用产品修理业', '8000', '机动车、电子产品和日用产品修理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('修理与维护', '8000', '机动车、电子产品和日用产品修理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车、摩托车修理与维护', '8010', '汽车、摩托车修理与维护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车、摩托车维护与保养', '8010', '汽车、摩托车修理与维护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车修理', '8010', '汽车、摩托车修理与维护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车修理与维护', '8011', '汽车修理与维护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('摩托车修理与维护', '8012', '摩托车修理与维护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机和办公设备维修', '8020', '计算机和办公设备维修');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('办公设备维修', '8020', '计算机和办公设备维修');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机和辅助设备修理', '8021', '计算机和辅助设备修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机维修', '8021', '计算机和辅助设备修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通讯设备修理', '8022', '通讯设备修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他办公设备维修', '8029', '其他办公设备维修');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用电器修理', '8030', '家用电器修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用电子产品修理', '8031', '家用电子产品修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用电器修理', '8032', '日用电器修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用产品修理业', '8090', '其他日用产品修理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用品修理', '8090', '其他日用产品修理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自行车修理', '8091', '自行车修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('鞋和皮革修理', '8092', '鞋和皮革修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家具和相关物品修理', '8093', '家具和相关物品修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明日用产品修理业', '8099', '其他未列明日用产品修理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他服务业', '8100', '其他服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('清洁服务', '8110', '清洁服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑物清洁服务', '8111', '建筑物清洁服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他清洁服务', '8119', '其他清洁服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的服务', '8190', '其他未列明服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明服务业', '8190', '其他未列明服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('教育', '8200', '教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('学前教育', '8210', '学前教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中等教育', '8230', '中等教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('技工学校教育', '8236', '中等职业学校教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('普通高等教育', '8241', '普通高等教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('特殊教育', '8250', '特殊教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('技能培训、教育辅助及其他教育', '8290', '技能培训、教育辅助及其他教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他教育', '8290', '技能培训、教育辅助及其他教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('职业技能培训', '8291', '职业技能培训');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体校及体育培训', '8292', '体校及体育培训');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化艺术培训', '8293', '文化艺术培训');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('教育辅助服务', '8294', '教育辅助服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明教育', '8299', '其他未列明教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的教育', '8299', '其他未列明教育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('卫生', '8300', '卫生');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医院', '8310', '医院');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('综合医院', '8311', '综合医院');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中医医院', '8312', '中医医院');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中西医结合医院', '8313', '中西医结合医院');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专科医院', '8315', '专科医院');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社区医疗与卫生院', '8320', '社区医疗与卫生院');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('卫生院及社区医疗活动', '8320', '社区医疗与卫生院');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社区卫生服务中心（站）', '8321', '社区卫生服务中心（站）');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('门诊部医疗活动', '8330', '门诊部（所）');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('门诊部（所）', '8330', '门诊部（所）');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专科疾病防治活动', '8360', '专科疾病防治院（所、站）');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专科疾病防治院（所、站）', '8360', '专科疾病防治院（所、站）');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('疾病预防控制及防疫活动', '8370', '疾病预防控制中心');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他卫生活动', '8390', '其他卫生活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会工作', '8400', '社会工作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会福利业', '8400', '社会工作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('提供住宿社会工作', '8410', '提供住宿社会工作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('提供住宿的社会福利', '8410', '提供住宿社会工作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('护理机构服务', '8412', '护理机构服务');
commit;
prompt 900 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('老年人、残疾人养护服务', '8414', '老年人、残疾人养护服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会看护与帮助服务', '8421', '社会看护与帮助服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('新闻和出版业', '8500', '新闻和出版业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('出版业', '8520', '出版业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('图书出版', '8521', '图书出版');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('报纸出版', '8522', '报纸出版');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('期刊出版', '8523', '期刊出版');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他出版业', '8529', '其他出版业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广播、电视、电影和影视录音制作业', '8600', '广播、电视、电影和影视录音制作业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广播、电视、电影和音像业', '8600', '广播、电视、电影和影视录音制作业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电影', '8600', '广播、电视、电影和影视录音制作业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广播', '8610', '广播');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电视', '8620', '电视');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电影制作与发行', '8630', '电影和影视节目制作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电影和影视节目制作', '8630', '电影和影视节目制作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电影和影视节目发行', '8640', '电影和影视节目发行');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电影放映', '8650', '电影放映');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('音像制作', '8660', '录音制作');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化艺术业', '8700', '文化艺术业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文艺创作与表演', '8710', '文艺创作与表演');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('艺术表演场馆', '8720', '艺术表演场馆');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('图书馆与档案馆', '8730', '图书馆与档案馆');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('档案馆', '8732', '档案馆');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文物及文化保护', '8740', '文物及非物质文化遗产保护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文物及非物质文化遗产保护', '8740', '文物及非物质文化遗产保护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('博物馆', '8750', '博物馆');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('群众文化活动', '8770', '群众文化活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化艺术', '8790', '其他文化艺术业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化艺术业', '8790', '其他文化艺术业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育', '8800', '体育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育组织', '8810', '体育组织');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育场馆', '8820', '体育场馆');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('休闲健身娱乐活动', '8830', '休闲健身活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('休闲健身活动', '8830', '休闲健身活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他体育', '8890', '其他体育');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('娱乐业', '8900', '娱乐业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('室内娱乐活动', '8910', '室内娱乐活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('歌舞厅娱乐活动', '8911', '歌舞厅娱乐活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子游艺厅娱乐活动', '8912', '电子游艺厅娱乐活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('网吧活动', '8913', '网吧活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他室内娱乐活动', '8919', '其他室内娱乐活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('游乐园', '8920', '游乐园');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化、娱乐、体育经纪代理', '8940', '文化、娱乐、体育经纪代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化艺术经纪代理', '8940', '文化、娱乐、体育经纪代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化娱乐经纪人', '8941', '文化娱乐经纪人');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育经纪人', '8942', '体育经纪人');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化艺术经纪代理', '8949', '其他文化艺术经纪代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他娱乐活动', '8990', '其他娱乐业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他娱乐业', '8990', '其他娱乐业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('综合事务管理机构', '9121', '综合事务管理机构');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公共安全管理机构', '9123', '公共安全管理机构');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会事务管理机构', '9124', '社会事务管理机构');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('经济事务管理机构', '9125', '经济事务管理机构');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会保障', '9300', '社会保障');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会保障业', '9300', '社会保障');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用视听设备制造', '3950', '视听设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电视机制造', '3951', '电视机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('音响设备制造', '3952', '音响设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用音响设备制造', '3952', '音响设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('影视录放设备制造', '3953', '影视录放设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用影视设备制造', '3953', '影视录放设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子器件制造', '3960', '电子器件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子真空器件制造', '3961', '电子真空器件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('半导体分立器件制造', '3962', '半导体分立器件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('集成电路制造', '3963', '集成电路制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('光电子器件及其他电子器件制造', '3969', '光电子器件及其他电子器件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子元件制造', '3970', '电子元件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子元件及组件制造', '3971', '电子元件及组件制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('印制电路板制造', '3972', '印制电路板制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他电子设备制造', '3990', '其他电子设备制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('仪器仪表制造业', '4000', '仪器仪表制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('仪器仪表及文化、办公用机械制造业', '4000', '仪器仪表制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通用仪器仪表制造', '4010', '通用仪器仪表制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工业自动控制系统装置制造', '4011', '工业自动控制系统装置制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电工仪器仪表制造', '4012', '电工仪器仪表制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('绘图、计算及测量仪器制造', '4013', '绘图、计算及测量仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('实验分析仪器制造', '4014', '实验分析仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('试验机制造', '4015', '试验机制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('供应用仪表及其他通用仪器制造', '4019', '供应用仪表及其他通用仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专用仪器仪表制造', '4020', '专用仪器仪表制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境监测专用仪器仪表制造', '4021', '环境监测专用仪器仪表制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('运输设备及生产用计数仪表制造', '4022', '运输设备及生产用计数仪表制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车及其他用计数仪表制造', '4022', '运输设备及生产用计数仪表制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('导航、气象及海洋专用仪器制造', '4023', '导航、气象及海洋专用仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('地质勘探和地震专用仪器制造', '4025', '地质勘探和地震专用仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('教学专用仪器制造', '4026', '教学专用仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电子测量仪器制造', '4028', '电子测量仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他专用仪器制造', '4029', '其他专用仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('钟表与计时仪器制造', '4030', '钟表与计时仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('光学仪器及眼镜制造', '4040', '光学仪器及眼镜制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('光学仪器制造', '4041', '光学仪器制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('眼镜制造', '4042', '眼镜制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他仪器仪表的制造及修理', '4090', '其他仪器仪表制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他仪器仪表制造业', '4090', '其他仪器仪表制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他制造业', '4100', '其他制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用杂品制造', '4110', '日用杂品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('鬃毛加工、制刷及清扫工具制造', '4111', '鬃毛加工、制刷及清扫工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('鬃毛加工、制刷及清扫工具的制造', '4111', '鬃毛加工、制刷及清扫工具制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用杂品制造', '4119', '其他日用杂品制造');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('煤制品制造', '4120', '煤制品制造');
commit;
prompt 1000 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的制造业', '4190', '其他未列明制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明制造业', '4190', '其他未列明制造业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('废弃资源综合利用业', '4200', '废弃资源综合利用业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('废弃资源和废旧材料回收加工业', '4200', '废弃资源综合利用业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属废料和碎屑的加工处理', '4210', '金属废料和碎屑加工处理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属废料和碎屑加工处理', '4210', '金属废料和碎屑加工处理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非金属废料和碎屑的加工处理', '4220', '非金属废料和碎屑加工处理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非金属废料和碎屑加工处理', '4220', '非金属废料和碎屑加工处理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制品、机械和设备修理业', '4300', '金属制品、机械和设备修理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属制品修理', '4310', '金属制品修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通用设备修理', '4320', '通用设备修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专用设备修理', '4330', '专用设备修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路、船舶、航空航天等运输设备修理', '4340', '铁路、船舶、航空航天等运输设备修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('船舶修理', '4342', '船舶修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('船舶修理及拆船', '4342', '船舶修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空航天器修理', '4343', '航空航天器修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电气设备修理', '4350', '电气设备修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('仪器仪表修理', '4360', '仪器仪表修理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他机械和设备修理业', '4390', '其他机械和设备修理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电力、热力的生产和供应业', '4400', '电力、热力生产和供应业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电力、热力生产和供应业', '4400', '电力、热力生产和供应业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电力生产', '4410', '电力生产');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('火力发电', '4411', '火力发电');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('太阳能发电', '4415', '太阳能发电');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他能源发电', '4419', '其他电力生产');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他电力生产', '4419', '其他电力生产');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电力供应', '4420', '电力供应');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('热力生产和供应', '4430', '热力生产和供应');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('燃气生产和供应业', '4500', '燃气生产和供应业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水的生产和供应业', '4600', '水的生产和供应业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自来水的生产和供应', '4610', '自来水生产和供应');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自来水生产和供应', '4610', '自来水生产和供应');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('污水处理及其再生利用', '4620', '污水处理及其再生利用');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水的处理、利用与分配', '4690', '其他水的处理、利用与分配');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('房屋建筑业', '4700', '房屋建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('房屋和土木工程建筑业', '4700', '房屋建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('房屋工程建筑', '4700', '房屋建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('土木工程建筑业', '4800', '土木工程建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('土木工程建筑', '4800', '土木工程建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路、道路、隧道和桥梁工程建筑', '4810', '铁路、道路、隧道和桥梁工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路工程建筑', '4811', '铁路工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公路工程建筑', '4812', '公路工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('市政道路工程建筑', '4813', '市政道路工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他道路、隧道和桥梁工程建筑', '4819', '其他道路、隧道和桥梁工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水利和内河港口工程建筑', '4820', '水利和内河港口工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水利和港口工程建筑', '4820', '水利和内河港口工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水源及供水设施工程建筑', '4821', '水源及供水设施工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('河湖治理及防洪设施工程建筑', '4822', '河湖治理及防洪设施工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('港口及航运设施工程建筑', '4823', '港口及航运设施工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海洋工程建筑', '4830', '海洋工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工矿工程建筑', '4840', '工矿工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('架线和管道工程建筑', '4850', '架线和管道工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('架线及设备工程建筑', '4851', '架线及设备工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('管道工程建筑', '4852', '管道工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他建筑业', '4890', '其他土木工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他土木工程建筑', '4890', '其他土木工程建筑');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑安装业', '4900', '建筑安装业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电气安装', '4910', '电气安装');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('管道和设备安装', '4920', '管道和设备安装');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他建筑安装业', '4990', '其他建筑安装业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑装饰和其他建筑业', '5000', '建筑装饰和其他建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑装饰业', '5010', '建筑装饰业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程准备活动', '5020', '工程准备活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程准备', '5020', '工程准备活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑物拆除活动', '5021', '建筑物拆除活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他工程准备活动', '5029', '其他工程准备活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('提供施工设备服务', '5030', '提供施工设备服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的建筑活动', '5090', '其他未列明建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明建筑业', '5090', '其他未列明建筑业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('批发业', '5100', '批发业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农、林、牧产品批发', '5110', '农、林、牧产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农畜产品批发', '5110', '农、林、牧产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('种子、饲料批发', '5110', '农、林、牧产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('谷物、豆及薯类批发', '5111', '谷物、豆及薯类批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('种子批发', '5112', '种子批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饲料批发', '5113', '饲料批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('棉、麻批发', '5114', '棉、麻批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('林业产品批发', '5115', '林业产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('牲畜批发', '5116', '牲畜批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他农牧产品批发', '5119', '其他农牧产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他农畜产品批发', '5119', '其他农牧产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食品、饮料及烟草制品批发', '5120', '食品、饮料及烟草制品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('米、面制品及食用油批发', '5121', '米、面制品及食用油批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('糕点、糖果及糖批发', '5122', '糕点、糖果及糖批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('果品、蔬菜批发', '5123', '果品、蔬菜批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肉、禽、蛋、奶及水产品批发', '5124', '肉、禽、蛋、奶及水产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肉、禽、蛋及水产品批发', '5124', '肉、禽、蛋、奶及水产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('盐及调味品批发', '5125', '盐及调味品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('营养和保健品批发', '5126', '营养和保健品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酒、饮料及茶叶批发', '5127', '酒、饮料及茶叶批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饮料及茶叶批发', '5127', '酒、饮料及茶叶批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('烟草制品批发', '5128', '烟草制品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他食品批发', '5129', '其他食品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织、服装及家庭用品批发', '5130', '纺织、服装及家庭用品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织、服装及日用品批发', '5130', '纺织、服装及家庭用品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织品、针织品及原料批发', '5131', '纺织品、针织品及原料批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('服装批发', '5132', '服装批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('鞋帽批发', '5133', '鞋帽批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化妆品及卫生用品批发', '5134', '化妆品及卫生用品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('厨房、卫生间用具及日用杂货批发', '5135', '厨房、卫生间用具及日用杂货批发');
commit;
prompt 1100 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('灯具、装饰物品批发', '5136', '灯具、装饰物品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用电器批发', '5137', '家用电器批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他家庭用品批发', '5139', '其他家庭用品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用品批发', '5139', '其他家庭用品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化、体育用品及器材批发', '5140', '文化、体育用品及器材批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文具用品批发', '5141', '文具用品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育用品及器材批发', '5142', '体育用品及器材批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育用品批发', '5142', '体育用品及器材批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('图书批发', '5143', '图书批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('报刊批发', '5144', '报刊批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('音像制品及电子出版物批发', '5145', '音像制品及电子出版物批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('首饰、工艺品及收藏品批发', '5146', '首饰、工艺品及收藏品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化用品批发', '5149', '其他文化用品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医药及医疗器材批发', '5150', '医药及医疗器材批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('西药批发', '5151', '西药批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中药批发', '5152', '中药批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中药材及中成药批发', '5152', '中药批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗用品及器材批发', '5153', '医疗用品及器材批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('矿产品、建材及化工产品批发', '5160', '矿产品、建材及化工产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('煤炭及制品批发', '5161', '煤炭及制品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('石油及制品批发', '5162', '石油及制品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非金属矿及制品批发', '5163', '非金属矿及制品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金属及金属矿批发', '5164', '金属及金属矿批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建材批发', '5165', '建材批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化肥批发', '5166', '化肥批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农药批发', '5167', '农药批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农用薄膜批发', '5168', '农用薄膜批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他化工产品批发', '5169', '其他化工产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机械设备、五金产品及电子产品批发', '5170', '机械设备、五金产品及电子产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机械设备、五金交电及电子产品批发', '5170', '机械设备、五金产品及电子产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('五金、交电批发', '5170', '机械设备、五金产品及电子产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农业机械批发', '5171', '农业机械批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车批发', '5172', '汽车批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车零配件批发', '5173', '汽车零配件批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车、摩托车及零配件批发', '5173', '汽车零配件批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('摩托车及零配件批发', '5174', '摩托车及零配件批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('五金产品批发', '5175', '五金产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电气设备批发', '5176', '电气设备批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机、软件及辅助设备批发', '5177', '计算机、软件及辅助设备批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通讯及广播电视设备批发', '5178', '通讯及广播电视设备批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他机械设备及电子产品批发', '5179', '其他机械设备及电子产品批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('贸易经纪与代理', '5180', '贸易经纪与代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('贸易代理', '5181', '贸易代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('拍卖', '5182', '拍卖');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他贸易经纪与代理', '5189', '其他贸易经纪与代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他批发业', '5190', '其他批发业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他批发', '5190', '其他批发业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('再生物资回收与批发', '5191', '再生物资回收与批发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明批发业', '5199', '其他未列明批发业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的批发', '5199', '其他未列明批发业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('零售业', '5200', '零售业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('综合零售', '5210', '综合零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('百货零售', '5211', '百货零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('超级市场零售', '5212', '超级市场零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他综合零售', '5219', '其他综合零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('食品、饮料及烟草制品专门零售', '5220', '食品、饮料及烟草制品专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('粮油零售', '5221', '粮油零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('糕点、面包零售', '5222', '糕点、面包零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('果品、蔬菜零售', '5223', '果品、蔬菜零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肉、禽、蛋、奶及水产品零售', '5224', '肉、禽、蛋、奶及水产品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('肉、禽、蛋及水产品零售', '5224', '肉、禽、蛋、奶及水产品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('营养和保健品零售', '5225', '营养和保健品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酒、饮料及茶叶零售', '5226', '酒、饮料及茶叶零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饮料及茶叶零售', '5226', '酒、饮料及茶叶零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('烟草制品零售', '5227', '烟草制品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他食品零售', '5229', '其他食品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织、服装及日用品专门零售', '5230', '纺织、服装及日用品专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('纺织品及针织品零售', '5231', '纺织品及针织品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('服装零售', '5232', '服装零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('鞋帽零售', '5233', '鞋帽零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('化妆品及卫生用品零售', '5234', '化妆品及卫生用品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('钟表、眼镜零售', '5235', '钟表、眼镜零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('箱、包零售', '5236', '箱、包零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('厨房用具及日用杂品零售', '5237', '厨房用具及日用杂品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自行车零售', '5238', '自行车零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他日用品零售', '5239', '其他日用品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('花卉零售', '5239', '其他日用品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化、体育用品及器材专门零售', '5240', '文化、体育用品及器材专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文具用品零售', '5241', '文具用品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育用品及器材零售', '5242', '体育用品及器材零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('体育用品零售', '5242', '体育用品及器材零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('图书、报刊零售', '5243', '图书、报刊零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('图书零售', '5243', '图书、报刊零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('报刊零售', '5243', '图书、报刊零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('音像制品及电子出版物零售', '5244', '音像制品及电子出版物零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('珠宝首饰零售', '5245', '珠宝首饰零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工艺美术品及收藏品零售', '5246', '工艺美术品及收藏品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('乐器零售', '5247', '乐器零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('照相器材零售', '5248', '照相器材零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化用品零售', '5249', '其他文化用品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医药及医疗器材专门零售', '5250', '医药及医疗器材专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('药品零售', '5251', '药品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医疗用品及器材零售', '5252', '医疗用品及器材零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车、摩托车、燃料及零配件专门零售', '5260', '汽车、摩托车、燃料及零配件专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车零售', '5261', '汽车零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车零配件零售', '5262', '汽车零配件零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('摩托车及零配件零售', '5263', '摩托车及零配件零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机动车燃料零售', '5264', '机动车燃料零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用电器及电子产品专门零售', '5270', '家用电器及电子产品专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用电器零售', '5270', '家用电器及电子产品专门零售');
commit;
prompt 1200 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家用视听设备零售', '5271', '家用视听设备零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('日用家电设备零售', '5272', '日用家电设备零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机、软件及辅助设备零售', '5273', '计算机、软件及辅助设备零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通信设备零售', '5274', '通信设备零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他电子产品零售', '5279', '其他电子产品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('五金、家具及室内装饰材料专门零售', '5280', '五金、家具及室内装饰材料专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('五金、家具及室内装修材料专门零售', '5280', '五金、家具及室内装饰材料专门零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('五金零售', '5281', '五金零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('灯具零售', '5282', '灯具零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('家具零售', '5283', '家具零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('涂料零售', '5284', '涂料零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('卫生洁具零售', '5285', '卫生洁具零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('木质装饰材料零售', '5286', '木质装饰材料零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('陶瓷、石材装饰材料零售', '5287', '陶瓷、石材装饰材料零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他室内装饰材料零售', '5289', '其他室内装饰材料零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他室内装修材料零售', '5289', '其他室内装饰材料零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货摊、无店铺及其他零售业', '5290', '货摊、无店铺及其他零售业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('无店铺及其他零售', '5290', '货摊、无店铺及其他零售业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货摊食品零售', '5291', '货摊食品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货摊纺织、服装及鞋零售', '5292', '货摊纺织、服装及鞋零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货摊日用品零售', '5293', '货摊日用品零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('互联网零售', '5294', '互联网零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('邮购及电子销售', '5295', '邮购及电视、电话零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('旧货零售', '5296', '旧货零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生活用燃料零售', '5297', '生活用燃料零售');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明零售业', '5299', '其他未列明零售业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的零售', '5299', '其他未列明零售业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路运输业', '5300', '铁路运输业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路货物运输', '5320', '铁路货物运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('铁路运输辅助活动', '5330', '铁路运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货运火车站', '5332', '货运火车站');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他铁路运输辅助活动', '5339', '其他铁路运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('道路运输业', '5400', '道路运输业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城市公共交通运输', '5410', '城市公共交通运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城市公共交通业', '5410', '城市公共交通运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公共电汽车客运', '5411', '公共电汽车客运');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('城市轨道交通', '5412', '城市轨道交通');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('轨道交通', '5412', '城市轨道交通');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('出租车客运', '5413', '出租车客运');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他城市公共交通运输', '5419', '其他城市公共交通运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他城市公共交通', '5419', '其他城市公共交通运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公路旅客运输', '5420', '公路旅客运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('道路货物运输', '5430', '道路货物运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('道路运输辅助活动', '5440', '道路运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('客运汽车站', '5441', '客运汽车站');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公路管理与养护', '5442', '公路管理与养护');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他道路运输辅助活动', '5449', '其他道路运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水上运输业', '5500', '水上运输业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水上旅客运输', '5510', '水上旅客运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海洋旅客运输', '5511', '海洋旅客运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('远洋旅客运输', '5511', '海洋旅客运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('内河旅客运输', '5512', '内河旅客运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水上货物运输', '5520', '水上货物运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('沿海货物运输', '5522', '沿海货物运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('内河货物运输', '5523', '内河货物运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('水上运输辅助活动', '5530', '水上运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('客运港口', '5531', '客运港口');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货运港口', '5532', '货运港口');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他水上运输辅助活动', '5539', '其他水上运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空运输业', '5600', '航空运输业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空客货运输', '5610', '航空客货运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空货物运输', '5612', '航空货物运输');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('通用航空服务', '5620', '通用航空服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('航空运输辅助活动', '5630', '航空运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他航空运输辅助活动', '5639', '其他航空运输辅助活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('管道运输业', '5700', '管道运输业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('装卸搬运和运输代理业', '5800', '装卸搬运和运输代理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('装卸搬运和其他运输服务业', '5800', '装卸搬运和运输代理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('装卸搬运', '5810', '装卸搬运');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('运输代理业', '5820', '运输代理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('运输代理服务', '5820', '运输代理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货物运输代理', '5821', '货物运输代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('旅客票务代理', '5822', '旅客票务代理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他运输代理业', '5829', '其他运输代理业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('仓储业', '5900', '仓储业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('谷物、棉花等农产品仓储', '5910', '谷物、棉花等农产品仓储');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他仓储', '5990', '其他仓储业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他仓储业', '5990', '其他仓储业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('邮政业', '6000', '邮政业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('国家邮政', '6000', '邮政业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('邮政基本服务', '6010', '邮政基本服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他寄递服务', '6020', '快递服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('快递服务', '6020', '快递服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('住宿业', '6100', '住宿业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('旅游饭店', '6110', '旅游饭店');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('一般旅馆', '6120', '一般旅馆');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他住宿服务', '6190', '其他住宿业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他住宿业', '6190', '其他住宿业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('餐饮业', '6200', '餐饮业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('正餐服务', '6210', '正餐服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('快餐服务', '6220', '快餐服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('饮料及冷饮服务', '6230', '饮料及冷饮服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('茶馆服务', '6231', '茶馆服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('咖啡馆服务', '6232', '咖啡馆服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('酒吧服务', '6233', '酒吧服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他饮料及冷饮服务', '6239', '其他饮料及冷饮服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他餐饮业', '6290', '其他餐饮业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他餐饮服务', '6290', '其他餐饮业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('小吃服务', '6291', '小吃服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('餐饮配送服务', '6292', '餐饮配送服务');
commit;
prompt 1300 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明餐饮业', '6299', '其他未列明餐饮业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电信、广播电视和卫星传输服务', '6300', '电信、广播电视和卫星传输服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电信和其他信息传输服务业', '6300', '电信、广播电视和卫星传输服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('电信', '6310', '电信');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('固定电信服务', '6311', '固定电信服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('移动电信服务', '6312', '移动电信服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他电信服务', '6319', '其他电信服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广播电视传输服务', '6320', '广播电视传输服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('有线广播电视传输服务', '6321', '有线广播电视传输服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('互联网和相关服务', '6400', '互联网和相关服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('互联网接入及相关服务', '6410', '互联网接入及相关服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('互联网信息服务', '6420', '互联网信息服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他互联网服务', '6490', '其他互联网服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('软件和信息技术服务业', '6500', '软件和信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机服务业', '6500', '软件和信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('软件业', '6500', '软件和信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机系统服务', '6500', '软件和信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公共软件服务', '6500', '软件和信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('应用软件服务', '6500', '软件和信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('基础软件服务', '6510', '软件开发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('软件开发', '6510', '软件开发');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('信息系统集成服务', '6520', '信息系统集成服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('信息技术咨询服务', '6530', '信息技术咨询服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('数据处理', '6540', '数据处理和存储服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('数据处理和存储服务', '6540', '数据处理和存储服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('集成电路设计', '6550', '集成电路设计');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他信息技术服务业', '6590', '其他信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他计算机服务', '6590', '其他信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他软件服务', '6590', '其他信息技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('数字内容服务', '6591', '数字内容服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('呼叫中心', '6592', '呼叫中心');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货币金融服务', '6600', '货币金融服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('银行业', '6600', '货币金融服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的金融活动', '6600', '货币金融服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他金融活动', '6600', '货币金融服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他银行', '6600', '货币金融服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('邮政储蓄', '6600', '货币金融服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('中央银行', '6610', '中央银行服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('商业银行', '6620', '货币银行服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('货币银行服务', '6620', '货币银行服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金融租赁服务', '6631', '金融租赁服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金融租赁', '6631', '金融租赁服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('财务公司', '6632', '财务公司');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('典当', '6633', '典当');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他非货币银行服务', '6639', '其他非货币银行服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('资本市场服务', '6700', '资本市场服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('证券业', '6700', '资本市场服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('证券市场服务', '6710', '证券市场服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('证券市场管理服务', '6711', '证券市场管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('证券经纪交易服务', '6712', '证券经纪交易服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('证券经纪与交易', '6712', '证券经纪交易服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('基金管理服务', '6713', '基金管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('期货市场服务', '6720', '期货市场服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他期货市场服务', '6729', '其他期货市场服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('证券期货监管服务', '6730', '证券期货监管服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('资本投资服务', '6740', '资本投资服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他资本市场服务', '6790', '其他资本市场服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('保险业', '6800', '保险业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('人身保险', '6810', '人身保险');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('人寿保险', '6811', '人寿保险');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('健康和意外保险', '6812', '健康和意外保险');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非人寿保险', '6812', '健康和意外保险');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('财产保险', '6820', '财产保险');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('保险经纪与代理服务', '6850', '保险经纪与代理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他保险活动', '6890', '其他保险活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('保险辅助服务', '6890', '其他保险活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('风险和损失评估', '6891', '风险和损失评估');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明保险活动', '6899', '其他未列明保险活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他金融业', '6900', '其他金融业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金融信托与管理', '6910', '金融信托与管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金融信托与管理服务', '6910', '金融信托与管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('控股公司服务', '6920', '控股公司服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('非金融机构支付服务', '6930', '非金融机构支付服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('金融信息服务', '6940', '金融信息服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明金融业', '6990', '其他未列明金融业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('房地产业', '7000', '房地产业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他房地产活动', '7000', '房地产业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('房地产开发经营', '7010', '房地产开发经营');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('物业管理', '7020', '物业管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('房地产中介服务', '7030', '房地产中介服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自有房地产经营活动', '7040', '自有房地产经营活动');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他房地产业', '7090', '其他房地产业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('租赁业', '7100', '租赁业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('机械设备租赁', '7110', '机械设备租赁');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('汽车租赁', '7111', '汽车租赁');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('建筑工程机械与设备租赁', '7113', '建筑工程机械与设备租赁');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('计算机及通讯设备租赁', '7114', '计算机及通讯设备租赁');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他机械与设备租赁', '7119', '其他机械与设备租赁');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('文化及日用品出租', '7120', '文化及日用品出租');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('娱乐及体育设备出租', '7121', '娱乐及体育设备出租');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('图书出租', '7122', '图书出租');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('图书及音像制品出租', '7123', '音像制品出租');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他文化及日用品出租', '7129', '其他文化及日用品出租');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('商务服务业', '7200', '商务服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('企业管理服务', '7210', '企业管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('企业管理机构', '7210', '企业管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('企业总部管理', '7211', '企业总部管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('投资与资产管理', '7212', '投资与资产管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('单位后勤管理服务', '7213', '单位后勤管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他企业管理服务', '7219', '其他企业管理服务');
commit;
prompt 1400 records committed...
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('法律服务', '7220', '法律服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('律师及相关法律服务', '7221', '律师及相关法律服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('律师及相关的法律服务', '7221', '律师及相关法律服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他法律服务', '7229', '其他法律服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('咨询与调查', '7230', '咨询与调查');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('会计、审计及税务服务', '7231', '会计、审计及税务服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('市场调查', '7232', '市场调查');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会经济咨询', '7233', '社会经济咨询');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他专业咨询', '7239', '其他专业咨询');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('广告业', '7240', '广告业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('知识产权服务', '7250', '知识产权服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('人力资源服务', '7260', '人力资源服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('公共就业服务', '7261', '公共就业服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('职业中介服务', '7262', '职业中介服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('劳务派遣服务', '7263', '劳务派遣服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他人力资源服务', '7269', '其他人力资源服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('旅行社及相关服务', '7270', '旅行社及相关服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('旅行社', '7270', '旅行社及相关服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('旅行社服务', '7271', '旅行社服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('旅游管理服务', '7272', '旅游管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他旅行社相关服务', '7279', '其他旅行社相关服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('安全保护服务', '7280', '安全保护服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('保安服务', '7280', '安全保护服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('安全服务', '7281', '安全服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('安全系统监控服务', '7282', '安全系统监控服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他安全保护服务', '7289', '其他安全保护服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他商务服务业', '7290', '其他商务服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他商务服务', '7290', '其他商务服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('市场管理', '7291', '市场管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('会议及展览服务', '7292', '会议及展览服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('包装服务', '7293', '包装服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('办公服务', '7294', '办公服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('信用服务', '7295', '信用服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('担保服务', '7296', '担保服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明商务服务业', '7299', '其他未列明商务服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明的商务服务', '7299', '其他未列明商务服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('研究和试验发展', '7300', '研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('研究与试验发展', '7300', '研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自然科学研究与试验发展', '7310', '自然科学研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('自然科学研究和试验发展', '7310', '自然科学研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程和技术研究与试验发展', '7320', '工程和技术研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程和技术研究和试验发展', '7320', '工程和技术研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农业科学研究与试验发展', '7330', '农业科学研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农业科学研究和试验发展', '7330', '农业科学研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医学研究与试验发展', '7340', '医学研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('医学研究和试验发展', '7340', '医学研究和试验发展');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会人文科学研究与试验发展', '7350', '社会人文科学研究');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('社会人文科学研究', '7350', '社会人文科学研究');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专业技术服务业', '7400', '专业技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('气象服务', '7410', '气象服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('海洋服务', '7430', '海洋服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('测绘服务', '7440', '测绘服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('技术检测', '7450', '质检技术服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('质检技术服务', '7450', '质检技术服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境与生态监测', '7460', '环境与生态监测');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境监测', '7460', '环境与生态监测');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('环境保护监测', '7461', '环境保护监测');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('地质勘查', '7470', '地质勘查');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('地质勘查业', '7470', '地质勘查');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('基础地质勘查', '7474', '基础地质勘查');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('地质勘查技术服务', '7475', '地质勘查技术服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程技术', '7480', '工程技术');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程技术与规划管理', '7480', '工程技术');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程管理服务', '7481', '工程管理服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('工程勘察设计', '7482', '工程勘察设计');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('规划管理', '7483', '规划管理');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他专业技术服务业', '7490', '其他专业技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他专业技术服务', '7490', '其他专业技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('专业化设计服务', '7491', '专业化设计服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('摄影扩印服务', '7492', '摄影扩印服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('兽医服务', '7493', '兽医服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('其他未列明专业技术服务业', '7499', '其他未列明专业技术服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('科技推广和应用服务业', '7500', '科技推广和应用服务业');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('技术推广服务', '7510', '技术推广服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('科技交流和推广服务业', '7510', '技术推广服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('农业技术推广服务', '7511', '农业技术推广服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('生物技术推广服务', '7512', '生物技术推广服务');
insert into ETL_INDUSTRY_CODE_CHECKLIST (old_industry_name, industry_code, industry_name)
values ('新材料技术推广服务', '7513', '新材料技术推广服务');
commit;

--政务端-统计分析
--菜单
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ba5d5e6a02015d5e7705990004', 'ROOT_2', '统计分析', '', 'icon-pie-chart', 401);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ba5d5e6a02015d5e7705990050', '402894ba5d5e6a02015d5e7705990004', '数据量统计', 'gov/dataAnalysis/toDataAnalysis.action', 'fa fa-circle-o', 40101);

--权限
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ba5d5e6a02015d5e7a7a900008', '402894ba5d5e6a02015d5e7705990050', 'dataAnalysis.query', '查看数据量统计', null, null, null, null, null);


--角色权限表
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ba5d5e6a02015d5e7a7a900008');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ba5d5e6a02015d5e7a7a900008');


commit;

--用户权限表
insert into SYS_USER_TO_PRIVILEGE (SYS_USER_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef8446c32a301446c409a950002', '402894ba5d5e6a02015d5e7a7a900008');


commit;

--添加批次上报记录表
alter table DP_DATA_REPORT_LOG
   drop unique (TASK_CODE) cascade;

alter table DP_DATA_REPORT_LOG
   drop primary key cascade;

drop table DP_DATA_REPORT_LOG cascade constraints;

/*==============================================================*/
/* Table: DP_DATA_REPORT_LOG                                    */
/*==============================================================*/
create table DP_DATA_REPORT_LOG 
(
   ID                   VARCHAR2(50)         not null,
   TASK_CODE            VARCHAR2(50),
   REPORT_WAY           VARCHAR2(100),
   CONFIRM_STATUS       VARCHAR2(50),
   table_status         VARCHAR2(50),
   LOGIC_TABLE_ID       VARCHAR2(50),
   table_version_id       VARCHAR2(50),
   dept_id      	    VARCHAR2(50),
   CREATE_DATE          DATE,
   CREATE_USER          VARCHAR2(50)
);

comment on table DP_DATA_REPORT_LOG is
'数据上报批次记录日志表';

comment on column DP_DATA_REPORT_LOG.ID is
'主键';

comment on column DP_DATA_REPORT_LOG.TASK_CODE is
'任务编号';

comment on column DP_DATA_REPORT_LOG.REPORT_WAY is
'上报方式';

comment on column DP_DATA_REPORT_LOG.CONFIRM_STATUS is
'上报确认状态（自动确认，手动确认）';

comment on column DP_DATA_REPORT_LOG.table_status
  is '上报该批次数据时数据目录当时的状态（待上报、已上报、超时）';

comment on column DP_DATA_REPORT_LOG.LOGIC_TABLE_ID is
'外键（DP_LOGIC_TABLE表主键）';
comment on column dp_data_report_log.table_version_id
  is '版本ID（DP_TABLE_VERSION表主键）';

comment on column DP_DATA_REPORT_LOG.dept_id
  is '部门id';

comment on column DP_DATA_REPORT_LOG.CREATE_DATE is
'创建时间';

comment on column DP_DATA_REPORT_LOG.CREATE_USER is
'创建人';

alter table DP_DATA_REPORT_LOG
   add constraint PK_DP_DATA_REPORT_LOG primary key (ID);
   
   --删除以前采集任务相关的无用视图
drop view view_task;
drop view view_task_his;
drop view view_task_status_count;

--修改视图view_data_report_log
create or replace view view_data_report_log as
(
--该视图的结果集，能保证批次编号task_code不会有重复值
 (select * from (select t.*,
       row_number() over(partition by t.task_code order by create_date desc) rn
  from dp_data_report_log t)
 where rn = 1)
);

--添加个人信用数据表
/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     2017/7/31 星期一 13:45:35                       */
/*==============================================================*/



/*==============================================================*/
/* Table: YW_P_GRBZDJXX                                         */
/*==============================================================*/
create table YW_P_GRBZDJXX 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   DJRQ                 DATE,
   SWRQ                 DATE,
   JSLXFS               VARCHAR2(500),
   JSLXRXM              VARCHAR2(500),
   LXRDZ                VARCHAR2(2500),
   jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRBZDJXX is
'个人殡葬登记信息';

comment on column YW_P_GRBZDJXX.ID is
'主键';

comment on column YW_P_GRBZDJXX.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRBZDJXX.SOURCE is
'数据来源';

comment on column YW_P_GRBZDJXX.CREATE_TIME is
'创建时间';

comment on column YW_P_GRBZDJXX.CREATE_USER is
'创建人ID';

comment on column YW_P_GRBZDJXX.BMMC is
'信息提供部门名称';

comment on column YW_P_GRBZDJXX.BMBM is
'信息提供部门编码';

comment on column YW_P_GRBZDJXX.TGRQ is
'信息提供日期';

comment on column YW_P_GRBZDJXX.XM is
'姓名';

comment on column YW_P_GRBZDJXX.SFZH is
'身份证号';

comment on column YW_P_GRBZDJXX.ZJLX is
'证件类型';

comment on column YW_P_GRBZDJXX.RWBH is
'任务编号';

comment on column YW_P_GRBZDJXX.BZ is
'备注';

comment on column YW_P_GRBZDJXX.DJRQ is
'登记日期';

comment on column YW_P_GRBZDJXX.SWRQ is
'死亡日期';

comment on column YW_P_GRBZDJXX.JSLXFS is
'家属联系方式';

comment on column YW_P_GRBZDJXX.JSLXRXM is
'家属联系人姓名';

comment on column YW_P_GRBZDJXX.LXRDZ is
'联系人地址';
comment on column YW_P_GRBZDJXX.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';
alter table YW_P_GRBZDJXX
   add constraint PK_YW_P_GRBZDJXX primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRDBJTCYXX                                       */
/*==============================================================*/
create table YW_P_GRDBJTCYXX 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   XB                   VARCHAR2(50),
   MZ                   VARCHAR2(200),
   WHCD                 VARCHAR2(500),
   LDNL                 VARCHAR2(500),
   JZLX                 VARCHAR2(500),
   JKZK                 VARCHAR2(500),
   CJDJ                 VARCHAR2(500),
   CJLB                 VARCHAR2(500),
   DTBHLX               VARCHAR2(500),
   BHNY                 VARCHAR2(100),
   S                    VARCHAR2(200),
   JD                   VARCHAR2(500),
   SQ                   VARCHAR2(500),
   HZSFZH               VARCHAR2(100),
   HZXM                 VARCHAR2(100),
   JTGX                 VARCHAR2(500),
    jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRDBJTCYXX is
'个人低保家庭成员信息';

comment on column YW_P_GRDBJTCYXX.ID is
'主键';

comment on column YW_P_GRDBJTCYXX.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRDBJTCYXX.SOURCE is
'数据来源';

comment on column YW_P_GRDBJTCYXX.CREATE_TIME is
'创建时间';

comment on column YW_P_GRDBJTCYXX.CREATE_USER is
'创建人ID';

comment on column YW_P_GRDBJTCYXX.BMMC is
'信息提供部门名称';

comment on column YW_P_GRDBJTCYXX.BMBM is
'信息提供部门编码';

comment on column YW_P_GRDBJTCYXX.TGRQ is
'信息提供日期';

comment on column YW_P_GRDBJTCYXX.XM is
'姓名';

comment on column YW_P_GRDBJTCYXX.SFZH is
'身份证号';

comment on column YW_P_GRDBJTCYXX.ZJLX is
'证件类型';

comment on column YW_P_GRDBJTCYXX.RWBH is
'任务编号';

comment on column YW_P_GRDBJTCYXX.BZ is
'备注';

comment on column YW_P_GRDBJTCYXX.XB is
'性别';

comment on column YW_P_GRDBJTCYXX.MZ is
'民族';

comment on column YW_P_GRDBJTCYXX.WHCD is
'文化程度';

comment on column YW_P_GRDBJTCYXX.LDNL is
'劳动能力';

comment on column YW_P_GRDBJTCYXX.JZLX is
'救助类型';

comment on column YW_P_GRDBJTCYXX.JKZK is
'健康状况';

comment on column YW_P_GRDBJTCYXX.CJDJ is
'残疾等级';

comment on column YW_P_GRDBJTCYXX.CJLB is
'残疾类别';

comment on column YW_P_GRDBJTCYXX.DTBHLX is
'动态变化类型';

comment on column YW_P_GRDBJTCYXX.BHNY is
'变化年月';

comment on column YW_P_GRDBJTCYXX.S is
'市（区）';

comment on column YW_P_GRDBJTCYXX.JD is
'街道(乡镇)';

comment on column YW_P_GRDBJTCYXX.SQ is
'社区(村)';

comment on column YW_P_GRDBJTCYXX.HZSFZH is
'户主身份证号码';

comment on column YW_P_GRDBJTCYXX.HZXM is
'户主姓名';

comment on column YW_P_GRDBJTCYXX.JTGX is
'家庭关系';
comment on column YW_P_GRDBJTCYXX.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';
alter table YW_P_GRDBJTCYXX
   add constraint PK_YW_P_GRDBJTCYXX primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRDBJTXX                                         */
/*==============================================================*/
create table YW_P_GRDBJTXX 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   BZRKS                NUMBER,
   JTRKS                NUMBER,
   LXDH                 VARCHAR2(50),
   JZDZ                 VARCHAR2(3000),
   DTBHLX               VARCHAR2(500),
   DTBHNY               VARCHAR2(100),
   S                    VARCHAR2(200),
   JD                   VARCHAR2(500),
   SQ                   VARCHAR2(500),
    jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRDBJTXX is
'个人低保家庭信息';

comment on column YW_P_GRDBJTXX.ID is
'主键';

comment on column YW_P_GRDBJTXX.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRDBJTXX.SOURCE is
'数据来源';

comment on column YW_P_GRDBJTXX.CREATE_TIME is
'创建时间';

comment on column YW_P_GRDBJTXX.CREATE_USER is
'创建人ID';

comment on column YW_P_GRDBJTXX.BMMC is
'信息提供部门名称';

comment on column YW_P_GRDBJTXX.BMBM is
'信息提供部门编码';

comment on column YW_P_GRDBJTXX.TGRQ is
'信息提供日期';

comment on column YW_P_GRDBJTXX.XM is
'姓名';

comment on column YW_P_GRDBJTXX.SFZH is
'身份证号';

comment on column YW_P_GRDBJTXX.ZJLX is
'证件类型';

comment on column YW_P_GRDBJTXX.RWBH is
'任务编号';

comment on column YW_P_GRDBJTXX.BZ is
'备注';

comment on column YW_P_GRDBJTXX.BZRKS is
'保障人口数';

comment on column YW_P_GRDBJTXX.JTRKS is
'家庭人口数';

comment on column YW_P_GRDBJTXX.LXDH is
'联系电话';

comment on column YW_P_GRDBJTXX.JZDZ is
'居住地址';

comment on column YW_P_GRDBJTXX.DTBHLX is
'动态变化类型';

comment on column YW_P_GRDBJTXX.DTBHNY is
'动态变化年月';

comment on column YW_P_GRDBJTXX.S is
'市（区）';

comment on column YW_P_GRDBJTXX.JD is
'街道(乡镇)';

comment on column YW_P_GRDBJTXX.SQ is
'社区(村)';
comment on column YW_P_GRDBJTXX.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';
alter table YW_P_GRDBJTXX
   add constraint PK_YW_P_GRDBJTXX primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRETJZYM                                         */
/*==============================================================*/
create table YW_P_GRETJZYM 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   XB                   VARCHAR2(50),
   CSRQ                 DATE,
   ZHYMJZRQ             DATE,
   CS                   NUMBER,
    jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRETJZYM is
'个人儿童接种疫苗';

comment on column YW_P_GRETJZYM.ID is
'主键';

comment on column YW_P_GRETJZYM.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRETJZYM.SOURCE is
'数据来源';

comment on column YW_P_GRETJZYM.CREATE_TIME is
'创建时间';

comment on column YW_P_GRETJZYM.CREATE_USER is
'创建人ID';

comment on column YW_P_GRETJZYM.BMMC is
'信息提供部门名称';

comment on column YW_P_GRETJZYM.BMBM is
'信息提供部门编码';

comment on column YW_P_GRETJZYM.TGRQ is
'信息提供日期';

comment on column YW_P_GRETJZYM.XM is
'姓名';

comment on column YW_P_GRETJZYM.SFZH is
'儿童身份证号';

comment on column YW_P_GRETJZYM.ZJLX is
'证件类型';

comment on column YW_P_GRETJZYM.RWBH is
'任务编号';

comment on column YW_P_GRETJZYM.BZ is
'备注';

comment on column YW_P_GRETJZYM.XB is
'儿童性别';

comment on column YW_P_GRETJZYM.CSRQ is
'出生日期';

comment on column YW_P_GRETJZYM.ZHYMJZRQ is
'最后一次疫苗接种日期';

comment on column YW_P_GRETJZYM.CS is
'接种疫苗次数';
comment on column YW_P_GRETJZYM.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRETJZYM
   add constraint PK_YW_P_GRETJZYM primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRJSZXX                                          */
/*==============================================================*/
create table YW_P_GRJSZXX 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   ZJCX                 VARCHAR2(500),
   JDZZT                VARCHAR2(500),
   CCLZSJ               DATE,
   GXRQ                 DATE,
   JZDZ                 VARCHAR2(3000),
    jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRJSZXX is
'个人驾驶证信息';

comment on column YW_P_GRJSZXX.ID is
'主键';

comment on column YW_P_GRJSZXX.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRJSZXX.SOURCE is
'数据来源';

comment on column YW_P_GRJSZXX.CREATE_TIME is
'创建时间';

comment on column YW_P_GRJSZXX.CREATE_USER is
'创建人ID';

comment on column YW_P_GRJSZXX.BMMC is
'信息提供部门名称';

comment on column YW_P_GRJSZXX.BMBM is
'信息提供部门编码';

comment on column YW_P_GRJSZXX.TGRQ is
'信息提供日期';

comment on column YW_P_GRJSZXX.XM is
'姓名';

comment on column YW_P_GRJSZXX.SFZH is
'身份证号';

comment on column YW_P_GRJSZXX.ZJLX is
'证件类型';

comment on column YW_P_GRJSZXX.RWBH is
'任务编号';

comment on column YW_P_GRJSZXX.BZ is
'备注';

comment on column YW_P_GRJSZXX.ZJCX is
'准驾车型';

comment on column YW_P_GRJSZXX.JDZZT is
'驾驶证状态';

comment on column YW_P_GRJSZXX.CCLZSJ is
'初次领证时间';

comment on column YW_P_GRJSZXX.GXRQ is
'更新日期';

comment on column YW_P_GRJSZXX.JZDZ is
'居住地址';
comment on column YW_P_GRJSZXX.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRJSZXX
   add constraint PK_YW_P_GRJSZXX primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRQTBLXX                                         */
/*==============================================================*/
create table YW_P_GRQTBLXX 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   SXYZCD               VARCHAR2(150),
   SXXWYXRQ             DATE,
   BLXWSS               VARCHAR2(4000),
   CFRQ                 DATE,
   JZRQ                 DATE,
   CFDWQC               VARCHAR2(250),
   WJWH                 VARCHAR2(200),
    jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRQTBLXX is
'个人其他不良信息';

comment on column YW_P_GRQTBLXX.ID is
'主键';

comment on column YW_P_GRQTBLXX.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRQTBLXX.SOURCE is
'数据来源';

comment on column YW_P_GRQTBLXX.CREATE_TIME is
'创建时间';

comment on column YW_P_GRQTBLXX.CREATE_USER is
'创建人ID';

comment on column YW_P_GRQTBLXX.BMMC is
'信息提供部门名称';

comment on column YW_P_GRQTBLXX.BMBM is
'信息提供部门编码';

comment on column YW_P_GRQTBLXX.TGRQ is
'信息提供日期';

comment on column YW_P_GRQTBLXX.XM is
'姓名';

comment on column YW_P_GRQTBLXX.SFZH is
'儿童身份证号';

comment on column YW_P_GRQTBLXX.ZJLX is
'证件类型';

comment on column YW_P_GRQTBLXX.RWBH is
'任务编号';

comment on column YW_P_GRQTBLXX.BZ is
'备注';

comment on column YW_P_GRQTBLXX.SXYZCD is
'失信严重程度';

comment on column YW_P_GRQTBLXX.SXXWYXRQ is
'失信行为有效日期';

comment on column YW_P_GRQTBLXX.BLXWSS is
'不良行为事实';

comment on column YW_P_GRQTBLXX.CFRQ is
'处罚日期';

comment on column YW_P_GRQTBLXX.JZRQ is
'截止日期';

comment on column YW_P_GRQTBLXX.CFDWQC is
'处罚单位全称';

comment on column YW_P_GRQTBLXX.WJWH is
'文件文号';

comment on column YW_P_GRQTBLXX.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRQTBLXX
   add constraint PK_YW_P_GRQTBLXX primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRRYXX                                           */
/*==============================================================*/
create table YW_P_GRRYXX 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   PDDW                 VARCHAR2(1000),
   PDRQ                 DATE,
   RYMC                 VARCHAR2(500),
   RYSX                 VARCHAR2(1000),
   ZSBH                 VARCHAR2(500),
   SZDWMC               VARCHAR2(500),
   SZDWZZJGDM           VARCHAR2(50),
    jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRRYXX is
'个人荣誉信息';

comment on column YW_P_GRRYXX.ID is
'主键';

comment on column YW_P_GRRYXX.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRRYXX.SOURCE is
'数据来源';

comment on column YW_P_GRRYXX.CREATE_TIME is
'创建时间';

comment on column YW_P_GRRYXX.CREATE_USER is
'创建人ID';

comment on column YW_P_GRRYXX.BMMC is
'信息提供部门名称';

comment on column YW_P_GRRYXX.BMBM is
'信息提供部门编码';

comment on column YW_P_GRRYXX.TGRQ is
'信息提供日期';

comment on column YW_P_GRRYXX.XM is
'姓名';

comment on column YW_P_GRRYXX.SFZH is
'身份证号';

comment on column YW_P_GRRYXX.ZJLX is
'证件类型';

comment on column YW_P_GRRYXX.RWBH is
'任务编号';

comment on column YW_P_GRRYXX.BZ is
'备注';

comment on column YW_P_GRRYXX.PDDW is
'评（认）定单位';

comment on column YW_P_GRRYXX.PDRQ is
'评（认）定日期';

comment on column YW_P_GRRYXX.RYMC is
'荣誉名称（含级别）';

comment on column YW_P_GRRYXX.RYSX is
'荣誉事项';

comment on column YW_P_GRRYXX.ZSBH is
'证书编号';

comment on column YW_P_GRRYXX.SZDWMC is
'所在单位名称';

comment on column YW_P_GRRYXX.SZDWZZJGDM is
'所在单位组织机构代码';
comment on column YW_P_GRRYXX.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRRYXX
   add constraint PK_YW_P_GRRYXX primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRSGSXZCF                                        */
/*==============================================================*/
create table YW_P_GRSGSXZCF 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   AJMC                 VARCHAR2(1000),
   XZCFJDSWH            VARCHAR2(200),
   XZCFBM               VARCHAR2(100),
   CFLB                 VARCHAR2(100),
   SXYZCD               VARCHAR2(100),
   CFYJ                 VARCHAR2(4000),
   CFSY                 VARCHAR2(4000),
   CFJG                 VARCHAR2(3000),
   CFJDRQ               DATE,
   CFJGMC               VARCHAR2(250),
   DQZT                 VARCHAR2(100),
   GSJZQ                DATE,
   XXSYFW               VARCHAR2(200),
   jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRSGSXZCF is
'个人双公示行政处罚';

comment on column YW_P_GRSGSXZCF.ID is
'主键';

comment on column YW_P_GRSGSXZCF.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRSGSXZCF.SOURCE is
'数据来源';

comment on column YW_P_GRSGSXZCF.CREATE_TIME is
'创建时间';

comment on column YW_P_GRSGSXZCF.CREATE_USER is
'创建人ID';

comment on column YW_P_GRSGSXZCF.BMMC is
'信息提供部门名称';

comment on column YW_P_GRSGSXZCF.BMBM is
'信息提供部门编码';

comment on column YW_P_GRSGSXZCF.TGRQ is
'信息提供日期';

comment on column YW_P_GRSGSXZCF.XM is
'姓名';

comment on column YW_P_GRSGSXZCF.SFZH is
'身份证号';

comment on column YW_P_GRSGSXZCF.ZJLX is
'证件类型';

comment on column YW_P_GRSGSXZCF.RWBH is
'任务编号';

comment on column YW_P_GRSGSXZCF.BZ is
'备注';

comment on column YW_P_GRSGSXZCF.AJMC is
'案件名称';

comment on column YW_P_GRSGSXZCF.XZCFJDSWH is
'行政处罚决定书文号';

comment on column YW_P_GRSGSXZCF.XZCFBM is
'行政处罚编码';

comment on column YW_P_GRSGSXZCF.CFLB is
'处罚类别';

comment on column YW_P_GRSGSXZCF.SXYZCD is
'失信严重程度';

comment on column YW_P_GRSGSXZCF.CFYJ is
'处罚依据';

comment on column YW_P_GRSGSXZCF.CFSY is
'处罚事由';

comment on column YW_P_GRSGSXZCF.CFJG is
'处罚结果';

comment on column YW_P_GRSGSXZCF.CFJDRQ is
'处罚决定日期';

comment on column YW_P_GRSGSXZCF.CFJGMC is
'处罚机关名称';

comment on column YW_P_GRSGSXZCF.DQZT is
'当前状态';

comment on column YW_P_GRSGSXZCF.GSJZQ is
'公示截止期';

comment on column YW_P_GRSGSXZCF.XXSYFW is
'信息使用范围';

comment on column YW_P_GRSGSXZCF.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRSGSXZCF
   add constraint PK_YW_P_GRSGSXZCF primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRSGSXZXK                                        */
/*==============================================================*/
create table YW_P_GRSGSXZXK 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   XMMC                 VARCHAR2(1000),
   XZXKJDSWH            VARCHAR2(200),
   XZXKBM               VARCHAR2(100),
   SPLB                 VARCHAR2(100),
   XKNR                 VARCHAR2(4000),
   XKJDRQ               DATE,
   XKJG                 VARCHAR2(250),
   XKJZQ                DATE,
   DQZT                 VARCHAR2(100),
   XXSYFW               VARCHAR2(200),
   jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRSGSXZXK is
'个人双公示行政许可';

comment on column YW_P_GRSGSXZXK.ID is
'主键';

comment on column YW_P_GRSGSXZXK.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRSGSXZXK.SOURCE is
'数据来源';

comment on column YW_P_GRSGSXZXK.CREATE_TIME is
'创建时间';

comment on column YW_P_GRSGSXZXK.CREATE_USER is
'创建人ID';

comment on column YW_P_GRSGSXZXK.BMMC is
'信息提供部门名称';

comment on column YW_P_GRSGSXZXK.BMBM is
'信息提供部门编码';

comment on column YW_P_GRSGSXZXK.TGRQ is
'信息提供日期';

comment on column YW_P_GRSGSXZXK.XM is
'姓名';

comment on column YW_P_GRSGSXZXK.SFZH is
'身份证号';

comment on column YW_P_GRSGSXZXK.ZJLX is
'证件类型';

comment on column YW_P_GRSGSXZXK.RWBH is
'任务编号';

comment on column YW_P_GRSGSXZXK.BZ is
'备注';

comment on column YW_P_GRSGSXZXK.XMMC is
'项目名称';

comment on column YW_P_GRSGSXZXK.XZXKJDSWH is
'行政许可决定书文号';

comment on column YW_P_GRSGSXZXK.XZXKBM is
'行政许可编码';

comment on column YW_P_GRSGSXZXK.SPLB is
'审批类别';

comment on column YW_P_GRSGSXZXK.XKNR is
'许可内容';

comment on column YW_P_GRSGSXZXK.XKJDRQ is
'许可决定日期';

comment on column YW_P_GRSGSXZXK.XKJG is
'许可机关';

comment on column YW_P_GRSGSXZXK.XKJZQ is
'许可截止期';

comment on column YW_P_GRSGSXZXK.DQZT is
'当前状态';

comment on column YW_P_GRSGSXZXK.XXSYFW is
'信息使用范围';

comment on column YW_P_GRSGSXZXK.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRSGSXZXK
   add constraint PK_YW_P_GRSGSXZXK primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRSQJZRYXX                                       */
/*==============================================================*/
create table YW_P_GRSQJZRYXX 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   FXLB                 VARCHAR2(500),
   SQJZLX               VARCHAR2(300),
   JYQK                 VARCHAR2(500),
   JZQSRQ               DATE,
   JZZZRQ               DATE,
   PJJG                 VARCHAR2(1000),
   PJRQ                 DATE,
   jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRSQJZRYXX is
'个人社区矫正人员信息';

comment on column YW_P_GRSQJZRYXX.ID is
'主键';

comment on column YW_P_GRSQJZRYXX.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRSQJZRYXX.SOURCE is
'数据来源';

comment on column YW_P_GRSQJZRYXX.CREATE_TIME is
'创建时间';

comment on column YW_P_GRSQJZRYXX.CREATE_USER is
'创建人ID';

comment on column YW_P_GRSQJZRYXX.BMMC is
'信息提供部门名称';

comment on column YW_P_GRSQJZRYXX.BMBM is
'信息提供部门编码';

comment on column YW_P_GRSQJZRYXX.TGRQ is
'信息提供日期';

comment on column YW_P_GRSQJZRYXX.XM is
'姓名';

comment on column YW_P_GRSQJZRYXX.SFZH is
'身份证号';

comment on column YW_P_GRSQJZRYXX.ZJLX is
'证件类型';

comment on column YW_P_GRSQJZRYXX.RWBH is
'任务编号';

comment on column YW_P_GRSQJZRYXX.BZ is
'备注';

comment on column YW_P_GRSQJZRYXX.FXLB is
'服刑类别';

comment on column YW_P_GRSQJZRYXX.SQJZLX is
'社区矫正类型';

comment on column YW_P_GRSQJZRYXX.JYQK is
'就业情况';

comment on column YW_P_GRSQJZRYXX.JZQSRQ is
'矫正起始日期';

comment on column YW_P_GRSQJZRYXX.JZZZRQ is
'矫正终止日期';

comment on column YW_P_GRSQJZRYXX.PJJG is
'判决机关';

comment on column YW_P_GRSQJZRYXX.PJRQ is
'判决日期';
comment on column YW_P_GRSQJZRYXX.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRSQJZRYXX
   add constraint PK_YW_P_GRSQJZRYXX primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRXHFZAJ                                         */
/*==============================================================*/
create table YW_P_GRXHFZAJ 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   ZW                   VARCHAR2(200),
   AJXZ                 VARCHAR2(500),
   AJZY                 VARCHAR2(1000),
   CLQK                 VARCHAR2(1000),
   HYLY                 VARCHAR2(1000),
   PJJG                 VARCHAR2(1000),
   SAJE                 NUMBER,
   SSDW                 VARCHAR2(500),
   XXTGBMQC             VARCHAR2(500),
   jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRXHFZAJ is
'个人行贿犯罪案件';

comment on column YW_P_GRXHFZAJ.ID is
'主键';

comment on column YW_P_GRXHFZAJ.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRXHFZAJ.SOURCE is
'数据来源';

comment on column YW_P_GRXHFZAJ.CREATE_TIME is
'创建时间';

comment on column YW_P_GRXHFZAJ.CREATE_USER is
'创建人ID';

comment on column YW_P_GRXHFZAJ.BMMC is
'信息提供部门名称';

comment on column YW_P_GRXHFZAJ.BMBM is
'信息提供部门编码';

comment on column YW_P_GRXHFZAJ.TGRQ is
'信息提供日期';

comment on column YW_P_GRXHFZAJ.XM is
'姓名';

comment on column YW_P_GRXHFZAJ.SFZH is
'身份证号';

comment on column YW_P_GRXHFZAJ.ZJLX is
'证件类型';

comment on column YW_P_GRXHFZAJ.RWBH is
'任务编号';

comment on column YW_P_GRXHFZAJ.BZ is
'备注';

comment on column YW_P_GRXHFZAJ.ZW is
'职务';

comment on column YW_P_GRXHFZAJ.AJXZ is
'案件性质';

comment on column YW_P_GRXHFZAJ.AJZY is
'案情摘要';

comment on column YW_P_GRXHFZAJ.CLQK is
'处理情况';

comment on column YW_P_GRXHFZAJ.HYLY is
'行业领域';

comment on column YW_P_GRXHFZAJ.PJJG is
'判决结果';

comment on column YW_P_GRXHFZAJ.SAJE is
'涉案金额';

comment on column YW_P_GRXHFZAJ.SSDW is
'所属单位';

comment on column YW_P_GRXHFZAJ.XXTGBMQC is
'信息提供部门全称';
comment on column YW_P_GRXHFZAJ.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';

alter table YW_P_GRXHFZAJ
   add constraint PK_YW_P_GRXHFZAJ primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRXYPJ                                           */
/*==============================================================*/
create table YW_P_GRXYPJ 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   PDJB                 VARCHAR2(1000),
   PDSJ                 DATE,
   jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRXYPJ is
'个人信用评级';

comment on column YW_P_GRXYPJ.ID is
'主键';

comment on column YW_P_GRXYPJ.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRXYPJ.SOURCE is
'数据来源';

comment on column YW_P_GRXYPJ.CREATE_TIME is
'创建时间';

comment on column YW_P_GRXYPJ.CREATE_USER is
'创建人ID';

comment on column YW_P_GRXYPJ.BMMC is
'信息提供部门名称';

comment on column YW_P_GRXYPJ.BMBM is
'信息提供部门编码';

comment on column YW_P_GRXYPJ.TGRQ is
'信息提供日期';

comment on column YW_P_GRXYPJ.XM is
'姓名';

comment on column YW_P_GRXYPJ.SFZH is
'身份证号';

comment on column YW_P_GRXYPJ.ZJLX is
'证件类型';

comment on column YW_P_GRXYPJ.RWBH is
'任务编号';

comment on column YW_P_GRXYPJ.BZ is
'备注';

comment on column YW_P_GRXYPJ.PDJB is
'评定级别';

comment on column YW_P_GRXYPJ.PDSJ is
'评定时间';
comment on column YW_P_GRXYPJ.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';


alter table YW_P_GRXYPJ
   add constraint PK_YW_P_GRXYPJ primary key (ID);

/*==============================================================*/
/* Table: YW_P_GRZYZFW                                          */
/*==============================================================*/
create table YW_P_GRZYZFW 
(
   ID                   VARCHAR2(50)         not null,
   STATUS               VARCHAR2(2)          default '0' not null,
   SOURCE               VARCHAR2(2),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BMMC                 VARCHAR2(200),
   BMBM                 VARCHAR2(50),
   TGRQ                 DATE,
   XM                   VARCHAR2(50),
   SFZH                 VARCHAR2(50),
   ZJLX                 VARCHAR2(200),
   RWBH                 VARCHAR2(50),
   BZ                   VARCHAR2(500),
   JF                   VARCHAR2(150),
   ZZMM                 VARCHAR2(200),
   GZDW                 VARCHAR2(500),
   FWSC                 VARCHAR2(200),
   jgdj_id              VARCHAR2(50)
);

comment on table YW_P_GRZYZFW is
'个人志愿者服务';

comment on column YW_P_GRZYZFW.ID is
'主键';

comment on column YW_P_GRZYZFW.STATUS is
'数据的状态（是否可用，是否变更过等）';

comment on column YW_P_GRZYZFW.SOURCE is
'数据来源';

comment on column YW_P_GRZYZFW.CREATE_TIME is
'创建时间';

comment on column YW_P_GRZYZFW.CREATE_USER is
'创建人ID';

comment on column YW_P_GRZYZFW.BMMC is
'信息提供部门名称';

comment on column YW_P_GRZYZFW.BMBM is
'信息提供部门编码';

comment on column YW_P_GRZYZFW.TGRQ is
'信息提供日期';

comment on column YW_P_GRZYZFW.XM is
'姓名';

comment on column YW_P_GRZYZFW.SFZH is
'儿童身份证号';

comment on column YW_P_GRZYZFW.ZJLX is
'证件类型';

comment on column YW_P_GRZYZFW.RWBH is
'任务编号';

comment on column YW_P_GRZYZFW.BZ is
'备注';

comment on column YW_P_GRZYZFW.JF is
'积分';

comment on column YW_P_GRZYZFW.ZZMM is
'政治面貌';

comment on column YW_P_GRZYZFW.GZDW is
'工作单位';

comment on column YW_P_GRZYZFW.FWSC is
'服务时长';
comment on column YW_P_GRZYZFW.jgdj_id
  is '关联个人基本信息YW_P_GRJBXX表主键ID';
alter table YW_P_GRZYZFW
   add constraint PK_YW_P_GRZYZFW primary key (ID);

   
CREATE TABLE DP_WEBSERVICE_LOG (
  ID VARCHAR(50) NOT NULL,
  TASK_CODE VARCHAR(50) DEFAULT NULL,
  URL VARCHAR(200) DEFAULT NULL,
  IP VARCHAR(100) DEFAULT NULL,
  REQUEST_TIME DATE DEFAULT NULL,
  USER_NAME VARCHAR(50) DEFAULT NULL,
  JSON_BODY CLOB,
  ERROR_CODE VARCHAR(50) DEFAULT NULL,
  ERROR_MSG VARCHAR(200) DEFAULT NULL,
  LOG_TYPE CHAR(1) DEFAULT NULL,
  PRIMARY KEY (ID)
);
comment on table DP_WEBSERVICE_LOG
  is 'ETL数据清洗企业标识补全表';
comment on column DP_WEBSERVICE_LOG.ID
  is '主键';
comment on column DP_WEBSERVICE_LOG.TASK_CODE
  is '上报记录编号';
comment on column DP_WEBSERVICE_LOG.URL
  is '调用接口类';
comment on column DP_WEBSERVICE_LOG.IP
  is '调用端的ip';
comment on column DP_WEBSERVICE_LOG.REQUEST_TIME
  is '接口调用时间';
comment on column DP_WEBSERVICE_LOG.USER_NAME
  is '接口调用用户';
comment on column DP_WEBSERVICE_LOG.JSON_BODY
  is '接口调用参数详细信息';
comment on column DP_WEBSERVICE_LOG.ERROR_CODE
  is '错误码';
  comment on column DP_WEBSERVICE_LOG.ERROR_MSG
  is '错误描述';
comment on column DP_WEBSERVICE_LOG.LOG_TYPE
  is '日志类型（调动成功or失败0：成功；1：失败）';
  
---------------------------------------------数据目录 修改 begin-------------------------------------
DROP TABLE DP_LOGIC_CLASSIFY CASCADE CONSTRAINTS;
DROP TABLE DP_LOGIC_COMMON_COLUMN CASCADE CONSTRAINTS;
DROP TABLE DP_LOGIC_TABLE_DEPT CASCADE CONSTRAINTS;

/*==============================================================*/
/* Table: DP_LOGIC_CLASSIFY                                     */
/*==============================================================*/
CREATE TABLE DP_LOGIC_CLASSIFY
(
  ID                   VARCHAR(50)          NOT NULL,
  CLASSIFY_NAME        VARCHAR(200),
  CLASSIFY_REMARK      VARCHAR(1200),
  CLASSIFY_SORT        NUMBER(5),
  PID                  VARCHAR(50),
  CREATE_USER          VARCHAR(50),
  CREATE_TIME          DATE,
  UPDATE_USER          VARCHAR(50),
  UPDATE_TIME          DATE,
  CONSTRAINT PK_DP_LOGIC_CLASSIFY PRIMARY KEY (ID)
);

COMMENT ON TABLE DP_LOGIC_CLASSIFY IS
'数据分类';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.ID IS
'主键';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.CLASSIFY_NAME IS
'分类名称';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.CLASSIFY_REMARK IS
'分类描述';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.CLASSIFY_SORT IS
'分类排序';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.PID IS
'父节点ID';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.CREATE_USER IS
'创建人';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.CREATE_TIME IS
'创建时间';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.UPDATE_USER IS
'更新人';

COMMENT ON COLUMN DP_LOGIC_CLASSIFY.UPDATE_TIME IS
'更新时间';

/*==============================================================*/
/* Table: DP_LOGIC_COMMON_COLUMN                                */
/*==============================================================*/
CREATE TABLE DP_LOGIC_COMMON_COLUMN
(
  ID                   VARCHAR2(50)         NOT NULL,
  CODE                 VARCHAR2(50),
  NAME                 VARCHAR2(50),
  COLUMN_TYPE          VARCHAR2(10),
  COLUMN_LENGTH               NUMBER(5),
  POSTIL               VARCHAR2(400),
  FIELD_SORT           NUMBER(5),
  CONSTRAINT PK_DP_LOGIC_COMMON_COLUMN PRIMARY KEY (ID)
);

COMMENT ON TABLE DP_LOGIC_COMMON_COLUMN IS
'公共指标';

COMMENT ON COLUMN DP_LOGIC_COMMON_COLUMN.ID IS
'主键';

COMMENT ON COLUMN DP_LOGIC_COMMON_COLUMN.CODE IS
'指标编码';

COMMENT ON COLUMN DP_LOGIC_COMMON_COLUMN.NAME IS
'指标名称';

COMMENT ON COLUMN DP_LOGIC_COMMON_COLUMN.COLUMN_TYPE IS
'指标类型';

COMMENT ON COLUMN DP_LOGIC_COMMON_COLUMN.COLUMN_LENGTH IS
'指标长度';

COMMENT ON COLUMN DP_LOGIC_COMMON_COLUMN.POSTIL IS
'批注';

COMMENT ON COLUMN DP_LOGIC_COMMON_COLUMN.FIELD_SORT IS
'排序';

/*==============================================================*/
/* Table: DP_LOGIC_TABLE_DEPT                                   */
/*==============================================================*/
CREATE TABLE DP_LOGIC_TABLE_DEPT
(
  ID                   VARCHAR(50)          NOT NULL,
  LOGIC_TABLE_ID       VARCHAR(50),
  DEPT_ID              VARCHAR(50),
  TABLE_VERSION_CONFIG_ID              VARCHAR(50),
  TABLE_VERSION_ID              VARCHAR(50),
  CREATE_USER          VARCHAR(50),
  CREATE_TIME          DATE,
  CONSTRAINT PK_DP_LOGIC_TABLE_DEPT PRIMARY KEY (ID)
);

COMMENT ON TABLE DP_LOGIC_TABLE_DEPT IS
'数据目录与部门关系表';

COMMENT ON COLUMN DP_LOGIC_TABLE_DEPT.ID IS
'主键';

COMMENT ON COLUMN DP_LOGIC_TABLE_DEPT.LOGIC_TABLE_ID IS
'数据目录ID';

COMMENT ON COLUMN DP_LOGIC_TABLE_DEPT.DEPT_ID IS
'部门ID';
comment on column DP_LOGIC_TABLE_DEPT.TABLE_VERSION_CONFIG_ID
  is '外键（DP_TABLE_VERSION_CONFIG表主键）';
comment on column DP_LOGIC_TABLE_DEPT.TABLE_VERSION_ID
  is '版本ID';
COMMENT ON COLUMN DP_LOGIC_TABLE_DEPT.CREATE_USER IS
'创建人';

COMMENT ON COLUMN DP_LOGIC_TABLE_DEPT.CREATE_TIME IS
'创建时间';

/*==============================================================*/
/* Table: DP_LOGIC_TABLE_TEMPLATE                                   */
/*==============================================================*/

drop table DP_LOGIC_TABLE_TEMPLATE cascade constraints;
create table DP_LOGIC_TABLE_TEMPLATE
(
  id                 VARCHAR2(50) not null,
  code               VARCHAR2(50) not null,
  name               VARCHAR2(100),
  create_id          VARCHAR2(50),
  create_time        DATE,
  update_id          VARCHAR2(50),
  update_time        DATE,
  ds_type            NUMBER default 0,
  mapped_code        VARCHAR2(50),
  task_period        VARCHAR2(20),
  data_category      VARCHAR2(20),
  days               NUMBER,
  table_desc 		 varchar2(2000),
  person_Type          VARCHAR2(50)
)
;
 comment on table DP_LOGIC_TABLE_TEMPLATE
  is '数据目录模板';
comment on column DP_LOGIC_TABLE_TEMPLATE.id
  is '主键';
comment on column DP_LOGIC_TABLE_TEMPLATE.code
  is '表名';
comment on column DP_LOGIC_TABLE_TEMPLATE.name
  is '表注释';
comment on column DP_LOGIC_TABLE_TEMPLATE.create_id
  is '创建人id';
comment on column DP_LOGIC_TABLE_TEMPLATE.create_time
  is '创建时间';
comment on column DP_LOGIC_TABLE_TEMPLATE.update_id
  is '更新人id';
comment on column DP_LOGIC_TABLE_TEMPLATE.update_time
  is '更新时间';
comment on column DP_LOGIC_TABLE_TEMPLATE.ds_type
  is '数据源类型（0文件、1数据库）';
comment on column DP_LOGIC_TABLE_TEMPLATE.mapped_code
  is '映射关联表名（数据源为DB的表名）';
comment on column DP_LOGIC_TABLE_TEMPLATE.task_period
  is '归集周期(0周 1月 2季度 3半年 4年)';
comment on column DP_LOGIC_TABLE_TEMPLATE.data_category
  is '数据类别';
comment on column DP_LOGIC_TABLE_TEMPLATE.days
  is '上报天数';
comment on column DP_LOGIC_TABLE_TEMPLATE.table_desc
  is '目录描述';
comment on column  dp_logic_table_template.PERSON_TYPE  
IS '目录类型，1：自然人 0：法人';
alter table DP_LOGIC_TABLE_TEMPLATE
  add primary key (ID);

/*==============================================================*/
/* Table: DP_LOGIC_COLUMN_TEMPLATE                                */
/*==============================================================*/
drop table DP_LOGIC_COLUMN_TEMPLATE cascade constraints;
create table DP_LOGIC_COLUMN_TEMPLATE
(
  id             VARCHAR2(50) not null,
  logic_table_id VARCHAR2(50) not null,
  code           VARCHAR2(50) not null,
  name           VARCHAR2(50),
  column_type    VARCHAR2(10) not null,
  column_length  NUMBER(5),
  mapped_code    VARCHAR2(50),
  is_core        NUMBER,
  is_nullable    NUMBER,
  is_repeat      NUMBER,
  is_update      NUMBER,
  is_search      NUMBER,
  REQUIRED_GROUP VARCHAR2(200),
  POSTIL VARCHAR2(400),
  FIELD_SORT NUMBER(5)
)
;
comment on table DP_LOGIC_COLUMN_TEMPLATE
  is '模板指标信息';
comment on column DP_LOGIC_COLUMN_TEMPLATE.id
  is '主键';
comment on column DP_LOGIC_COLUMN_TEMPLATE.logic_table_id
  is '外键（DP_LOGIC_TABLE_TEMPLATE表主键）';
comment on column DP_LOGIC_COLUMN_TEMPLATE.code
  is '列名';
comment on column DP_LOGIC_COLUMN_TEMPLATE.name
  is '列注释';
comment on column DP_LOGIC_COLUMN_TEMPLATE.column_type
  is '列在数据库中的类型（VARCHAR2/NUMBER）';
comment on column DP_LOGIC_COLUMN_TEMPLATE.column_length
  is '列在数据库中的长度';
comment on column DP_LOGIC_COLUMN_TEMPLATE.mapped_code
  is '映射关联的数据源中指定的列';
comment on column DP_LOGIC_COLUMN_TEMPLATE.is_core
  is '是否是核心项';
comment on column DP_LOGIC_COLUMN.is_nullable
  is '是否允许为空（0否，1允许）';
comment on column DP_LOGIC_COLUMN_TEMPLATE.is_repeat
  is '是否去重字段（0否，1是）';
comment on column DP_LOGIC_COLUMN_TEMPLATE.is_update
  is '是否是更新字段（0否，1是）';
comment on column DP_LOGIC_COLUMN_TEMPLATE.is_search
  is '是否是查询字段（0否，1是）';
comment on column DP_LOGIC_COLUMN_TEMPLATE.REQUIRED_GROUP
  is '组（多选一）';
comment on column DP_LOGIC_COLUMN_TEMPLATE.POSTIL
  is '批注';
comment on column DP_LOGIC_COLUMN_TEMPLATE.FIELD_SORT
  is '排序';

alter table DP_LOGIC_COLUMN_TEMPLATE
  add primary key (ID);
alter table DP_LOGIC_COLUMN_TEMPLATE
  add foreign key (LOGIC_TABLE_ID)
  references DP_LOGIC_TABLE_TEMPLATE (ID) on delete cascade;
  
/*==============================================================*/
/* Table: DP_COLUMN_RULE_TEMPLATE                                */
/*==============================================================*/
drop table DP_COLUMN_RULE_TEMPLATE cascade constraints;
 create table DP_COLUMN_RULE_TEMPLATE
(
  id        VARCHAR2(50) not null,
  column_id VARCHAR2(50) not null,
  rule_id   VARCHAR2(50) not null
)
;
comment on table DP_COLUMN_RULE_TEMPLATE
  is '字段规则关系表-模板';
comment on column DP_COLUMN_RULE_TEMPLATE.id
  is '主键';
comment on column DP_COLUMN_RULE_TEMPLATE.column_id
  is '字段ID';
comment on column DP_COLUMN_RULE_TEMPLATE.rule_id
  is '规则ID';
alter table DP_COLUMN_RULE_TEMPLATE
  add primary key (ID);
  
--初始化目录模板数据
insert into DP_LOGIC_TABLE_TEMPLATE (id, code, name, create_id, create_time, update_id, update_time, ds_type, mapped_code, task_period, data_category, days, table_desc,person_Type)
values ('402894c05fc3cae6015fc3d544f00004', 'SGS_XZXK', '双公示行政许可', '8aa0bef8446c32a301446c409a950002', to_date('16-11-2017 15:57:34', 'dd-mm-yyyy hh24:mi:ss'), null, null, 1, null, '0', '7', 5, '行政许可信用信息作出决定后上网公示的信息','0');
insert into DP_LOGIC_TABLE_TEMPLATE (id, code, name, create_id, create_time, update_id, update_time, ds_type, mapped_code, task_period, data_category, days, table_desc,person_Type)
values ('402894c05fc3cae6015fc3f9eeec0027', 'SGS_XZCF', '双公示行政处罚', '8aa0bef8446c32a301446c409a950002', to_date('16-11-2017 16:37:37', 'dd-mm-yyyy hh24:mi:ss'), null, null, 1, null, '0', '6', 5, '行政处罚信用信息作出决定后上网公示的信息','0');
commit;

insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001cb0007', '402894c05fc3cae6015fc3d544f00004', 'XK_WSH', '行政许可决定书文号', 'VARCHAR2', 128, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '如前置许可无决定文书号,此处填文字“空”', 0);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001d30008', '402894c05fc3cae6015fc3d544f00004', 'XK_XMMC', '项目名称', 'VARCHAR2', 256, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 1);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001d50009', '402894c05fc3cae6015fc3d544f00004', 'XK_BM', '行政许可编码', 'VARCHAR2', 40, null, 0, 0, 0, 0, 0, null, '参考省权利清单中行政权力编码进行填写' || chr(10) || '1、必填项校检', 2);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001d7000a', '402894c05fc3cae6015fc3d544f00004', 'XK_SPLB', '审批类别', 'VARCHAR2', 16, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '普通、特许、认可、核准、登记、其他（需注明）' || chr(10) || '1、检查是否在给定的审批类别范围内', 3);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001d9000b', '402894c05fc3cae6015fc3d544f00004', 'XK_NR', '许可内容', 'VARCHAR2', 2048, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '行政许可的详细内容', 4);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001de000c', '402894c05fc3cae6015fc3d544f00004', 'XK_XDR', '行政相对人名称', 'VARCHAR2', 256, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 5);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001e1000d', '402894c05fc3cae6015fc3d544f00004', 'XK_XDR_SHXYM', '行政相对人代码_1(统一社会信用代码)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '自然人此项空白,如行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)均无则必填' || chr(10) || '1、如果填写，检查是否符合统一社会信用代码规则', 6);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001e5000e', '402894c05fc3cae6015fc3d544f00004', 'XK_XDR_ZDM', '行政相对人代码_2(组织机构代码)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '非自然人时为选填项（行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)三项中必填一项）' || chr(10) || '自然人此项空白' || chr(10) || '1、如果填写，检查是否符合组织机构代码规则。', 7);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001e8000f', '402894c05fc3cae6015fc3d544f00004', 'XK_XDR_GSDJ', '行政相对人代码_3(工商登记码)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '非自然人时为选填项（行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)三项中必填一项）' || chr(10) || '自然人此项空白' || chr(10) || '1、如果填写，检查是否符合工商注册号规则。', 8);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001ea0010', '402894c05fc3cae6015fc3d544f00004', 'XK_XDR_SWDJ', '行政相对人代码_4(税务登记号)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '非自然人时为选填项（行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)三项中必填一项）' || chr(10) || '自然人此项空白' || chr(10) || '1、如果填写，检查是否符合纳税人识别号校验规则', 9);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001eb0011', '402894c05fc3cae6015fc3d544f00004', 'XK_XDR_SFZ', '行政相对人代码_5(居民身份证号)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '为非自然人时为填法定代表人身份证；为自然人时填行政相对人身份证；如外籍人员，须填写护照号，并在备注中注明证件类型' || chr(10) || '（对外公示时将隐去部分证件号码）' || chr(10) || '1、如果填写，检查是否符合身份证件号码校验规则', 10);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e001ee0012', '402894c05fc3cae6015fc3d544f00004', 'XK_FR', '法定代表人姓名', 'VARCHAR2', 256, null, 0, 1, 0, 0, 0, null, null, 11);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1aa0016', '402894c05fc3cae6015fc3d544f00004', 'XK_JDRQ', '许可决定日期', 'VARCHAR2', 200, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '1、日期格式校验,如文本格式为:YYYY/MM/DD。' || chr(10) || '2、许可决定日期 不可超过当前数据报送日期（报送系统所在服务器当时时间）', 12);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1ad0017', '402894c05fc3cae6015fc3d544f00004', 'XK_JZQ', '许可截止期', 'VARCHAR2', 200, null, 0, 1, 0, 0, 0, null, '（选填）' || chr(10) || '1、如果填写，必须符合日期格式要求,如文本格式为:YYYY/MM/DD,2099/12/31含义为长期。' || chr(10) || '2、如果填写，许可截止期要不小于许可决定日期', 13);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1af0018', '402894c05fc3cae6015fc3d544f00004', 'XK_XZJG', '许可机关', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '作出许可行为的批准机关名称（全名）', 14);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1b10019', '402894c05fc3cae6015fc3d544f00004', 'XK_ZT', '当前状态', 'VARCHAR2', 1, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '0=正常（或空白）；1=撤销；2=异议；3=其他（备注说明）' || chr(10) || '1、校检当前状态是否在备注要求的范围内,即只能填写0或1或2或3（只能填写其中一个数字）', 15);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1b4001a', '402894c05fc3cae6015fc3d544f00004', 'DFBM', '地方编码', 'VARCHAR2', 6, null, 0, 0, 0, 0, 0, null, '根据国家行政区划编码' || chr(10) || '1、必填项校检', 16);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1b6001b', '402894c05fc3cae6015fc3d544f00004', 'SJC', '数据更新时间戳', 'VARCHAR2', 200, null, 0, 0, 0, 0, 0, null, '数据归集的时间（戳），为数据上报部门归集到数据源单位的日期' || chr(10) || '1、必填项校检' || chr(10) || '2、日期格式校检,文本格式为:YYYY/MM/DD' || chr(10) || '3、数据更新时间戳不可小于许可决定日期' || chr(10) || '4、数据更新时间戳不可大于当前数据报送日期（报送系统所在服务器当时时间）', 17);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1b9001c', '402894c05fc3cae6015fc3d544f00004', 'BZ', '备注', 'VARCHAR2', 4000, null, 0, 1, 0, 0, 0, null, null, 18);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc3e5c1be001d', '402894c05fc3cae6015fc3d544f00004', 'XK_SYFW', '信息使用范围', 'VARCHAR2', 1, null, 0, 1, 0, 0, 0, null, '（选填）' || chr(10) || '0.公示；1.仅政府部门内部共享；2.仅可授权查询；不填写默认为0' || chr(10) || '如果填写，只能填写0或1或2（只能填写其中一个数字）', 19);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586a1002a', '402894c05fc3cae6015fc3f9eeec0027', 'CF_WSH', '行政处罚决定书文号', 'VARCHAR2', 128, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 0);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586a3002b', '402894c05fc3cae6015fc3f9eeec0027', 'CF_CFMC', '处罚名称', 'VARCHAR2', 256, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 1);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586a6002c', '402894c05fc3cae6015fc3f9eeec0027', 'CF_BM', '行政处罚编码', 'VARCHAR2', 40, null, 0, 0, 0, 0, 0, null, '参考省权利清单中行政处罚编码进行填写' || chr(10) || '1、必填项校检', 2);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586a9002d', '402894c05fc3cae6015fc3f9eeec0027', 'CF_CFLB1', '处罚类别1', 'VARCHAR2', 36, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '包括：警告；罚款；没收违法所得、没收非法财物；责令停产停业；暂扣或者吊销许可证、暂扣或者吊销执照；行政拘留；其他（需注明）' || chr(10) || '1、检查处罚类别1是否在备注要求的范围内。即只能填写警告或罚款或没收违法所得、没收非法财物或责令停产停业或暂扣或者吊销许可证、暂扣或者吊销', 3);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586ac002e', '402894c05fc3cae6015fc3f9eeec0027', 'CF_CFLB2', '处罚类别2', 'VARCHAR2', 36, null, 0, 1, 0, 0, 0, null, '（选填）' || chr(10) || '包括：警告；罚款；没收违法所得、没收非法财物；责令停产停业；暂扣或者吊销许可证、暂扣或者吊销执照；行政拘留；其他（需注明）' || chr(10) || '（如3项及以上处罚类别，可在[处罚类别2]中填写）', 4);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586ae002f', '402894c05fc3cae6015fc3f9eeec0027', 'CF_SY', '处罚事由', 'VARCHAR2', 2048, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 5);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586b20030', '402894c05fc3cae6015fc3f9eeec0027', 'CF_YJ', '处罚依据', 'VARCHAR2', 2048, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 6);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586b40031', '402894c05fc3cae6015fc3f9eeec0027', 'CF_XDR_MC', '行政相对人名称', 'VARCHAR2', 128, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 7);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586b70032', '402894c05fc3cae6015fc3f9eeec0027', 'CF_XDR_SHXYM', '行政相对人代码_1(统一社会信用代码)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '自然人此项空白' || chr(10) || '如行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)均无则必填' || chr(10) || '1、如果填写，检查是否符合统一社会信用代码规则', 8);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40586ba0033', '402894c05fc3cae6015fc3f9eeec0027', 'CF_XDR_ZDM', '行政相对人代码_2(组织机构代码)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '非自然人时为选填项（行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)三项中必填一项）' || chr(10) || '自然人此项空白' || chr(10) || '1、如果填写，检查是否符合组织机构代码规则。', 9);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc407eae20036', '402894c05fc3cae6015fc3f9eeec0027', 'CF_XDR_GSDJ', '行政相对人代码_3(工商登记码)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '非自然人时为选填项（行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)三项中必填一项）' || chr(10) || '自然人此项空白' || chr(10) || '1、如果填写，检查是否符合工商注册号规则。', 10);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc407eae40037', '402894c05fc3cae6015fc3f9eeec0027', 'CF_XDR_SWDJ', '行政相对人代码_4(税务登记号)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '非自然人时为选填项（行政相对人代码_2(组织机构代码)、行政相对人代码_3(工商登记码)、行政相对人代码_4(税务登记号)三项中必填一项）' || chr(10) || '自然人此项空白' || chr(10) || '1、如果填写，检查是否符合纳税人识别号校验规则', 11);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc407eaea0038', '402894c05fc3cae6015fc3f9eeec0027', 'CF_XDR_SFZ', '行政相对人代码_5(居民身份证号)', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, '1', '为非自然人时为填法定代表人身份证；为自然人时填行政相对人身份证；如外籍人员，须填写护照号，并在备注中注明证件类型。' || chr(10) || '（对外公示时将隐去部分证件号码）' || chr(10) || '1、如果填写，检查是否符合身份证件号码校验规则', 12);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d9237003b', '402894c05fc3cae6015fc3f9eeec0027', 'CF_FR', '法定代表人姓名', 'VARCHAR2', 256, null, 0, 1, 0, 0, 0, null, '行政相对人为非自然人时为必填项，为自然人时此项空白', 13);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d9239003c', '402894c05fc3cae6015fc3f9eeec0027', 'CF_JG', '处罚结果', 'VARCHAR2', 2048, null, 0, 0, 0, 0, 0, null, '1、必填项校检', 14);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d923b003d', '402894c05fc3cae6015fc3f9eeec0027', 'CF_JDRQ', '处罚决定日期', 'VARCHAR2', 200, null, 0, 0, 0, 0, 0, null, '1、必填项校检' || chr(10) || '2、日期格式校检，如文本格式为:YYYY/MM/DD' || chr(10) || '3、处罚决定日期 不可超过当前数据报送日期（报送系统所在服务器当时时间）', 15);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d923d003e', '402894c05fc3cae6015fc3f9eeec0027', 'CF_XZJG', '处罚机关', 'VARCHAR2', 64, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '作出行政处罚决定机关名称（全名）', 16);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d923f003f', '402894c05fc3cae6015fc3f9eeec0027', 'CF_ZT', '当前状态', 'VARCHAR2', 1, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '0=正常（或空白）；1=撤销；2=异议；3=其他（备注说明）' || chr(10) || '1、校检当前状态是否在备注要求的范围内。即只能填写0或1或2或3（只能填写其中一个数字）', 17);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d92410040', '402894c05fc3cae6015fc3f9eeec0027', 'DFBM', '地方编码', 'VARCHAR2', 6, null, 0, 0, 0, 0, 0, null, '（必填）' || chr(10) || '根据国家行政区划编码', 18);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d92430041', '402894c05fc3cae6015fc3f9eeec0027', 'SJC', '数据更新时间戳', 'VARCHAR2', 200, null, 0, 0, 0, 0, 0, null, '数据归集的时间（戳），为数据上报部门归集到的数据源单位的日期' || chr(10) || '1、必填项校检' || chr(10) || '2、日期格式校检，如文本格式为:YYYY/MM/DD' || chr(10) || '3、数据更新时间戳不可小于处罚决定日期' || chr(10) || '4、数据更新时间戳不可大于当前数据报送日期（报送系统所在服务器当时时间）', 19);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d92480042', '402894c05fc3cae6015fc3f9eeec0027', 'BZ', '备注', 'VARCHAR2', 4000, null, 0, 1, 0, 0, 0, null, null, 20);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d924a0043', '402894c05fc3cae6015fc3f9eeec0027', 'CF_SYFW', '信息使用范围', 'VARCHAR2', 1, null, 0, 1, 0, 0, 0, null, '（选填）' || chr(10) || '0.公示；1.仅政府部门内部共享；2.仅可授权查询。不填写默认为0' || chr(10) || '1、如果填写，只能填写0或1或2（只能填写其中一个数字）', 21);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d924c0044', '402894c05fc3cae6015fc3f9eeec0027', 'CF_SXYZCD', '失信严重程度', 'VARCHAR2', 1, null, 0, 1, 0, 0, 0, null, '（选填）' || chr(10) || '0.未定；1.一般；2.较重；3.严重' || chr(10) || '1、如果填写，，只能填写0或1或2或3（只能填写其中一个数字）', 22);
insert into DP_LOGIC_COLUMN_TEMPLATE (id, logic_table_id, code, name, column_type, column_length, mapped_code, is_core, is_nullable, is_repeat, is_update, is_search, required_group, postil, field_sort)
values ('402894c05fc3cae6015fc40d924e0045', '402894c05fc3cae6015fc3f9eeec0027', 'CF_GSJZQ', '公示截止期', 'VARCHAR2', 200, null, 0, 1, 0, 0, 0, null, '（选填）' || chr(10) || '填写公示的截止日期' || chr(10) || '1、如果填写，必须符合日期格式要求，如文本格式为:YYYY/MM/DD。' || chr(10) || '2、如果填写，公示截止期要不小于处罚决定日期', 23);
commit;

-- 目录配置改为征集目录管理
update sys_menu set menu_name='征集目录管理' where sys_menu_id='2c90c28158757420015875a8d3f20089';

-- 数据分类初始化脚本
insert into DP_LOGIC_CLASSIFY (ID, CLASSIFY_NAME, CLASSIFY_REMARK, CLASSIFY_SORT, PID, CREATE_USER, CREATE_TIME, UPDATE_USER, UPDATE_TIME)
values ('4028949f5eb861b4015eb8671e760004', '法人信用数据库', '法人信用数据库', 0, '0', '1', sysdate, null, null);

insert into DP_LOGIC_CLASSIFY (ID, CLASSIFY_NAME, CLASSIFY_REMARK, CLASSIFY_SORT, PID, CREATE_USER, CREATE_TIME, UPDATE_USER, UPDATE_TIME)
values ('4028949f5ebb9a81015ebba3894b0017', '自然人信用数据库', '自然人信用数据库', 1, '0', '1', sysdate, null, null);

insert into DP_LOGIC_CLASSIFY (ID, CLASSIFY_NAME, CLASSIFY_REMARK, CLASSIFY_SORT, PID, CREATE_USER, CREATE_TIME, UPDATE_USER, UPDATE_TIME)
values ('402894bf5fc7df63015fc80ae92100af', '非企业法人信用数据库', '非企业法人信用数据库', 2, '0', '1', sysdate, null, null);


----------------------------------------数据目录修改 end-----------------------------------------

commit;


-------------------------------------------- 公共指标初始化数据start------------------------------------------

insert into dp_logic_common_column (ID, CODE, NAME, COLUMN_TYPE, COLUMN_LENGTH, POSTIL, FIELD_SORT)
values ('2c9951815fc3f242015fc40b72d200a3', 'JGQC', '企业名称', 'VARCHAR2', 800, null, null);

insert into dp_logic_common_column (ID, CODE, NAME, COLUMN_TYPE, COLUMN_LENGTH, POSTIL, FIELD_SORT)
values ('2c9951815fc3f242015fc40b5264009f', 'TYSHXYDM', '统一社会信用代码', 'VARCHAR2', 200, null, null);

insert into dp_logic_common_column (ID, CODE, NAME, COLUMN_TYPE, COLUMN_LENGTH, POSTIL, FIELD_SORT)
values ('2c9951815fc3f242015fc40b641300a1', 'ZZJGDM', '组织机构代码', 'VARCHAR2', 200, null, null);

insert into dp_logic_common_column (ID, CODE, NAME, COLUMN_TYPE, COLUMN_LENGTH, POSTIL, FIELD_SORT)
values ('2c9951815fc3f242015fc40b81df00a5', 'GSZCH', '工商注册号', 'VARCHAR2', 200, null, null);

insert into dp_logic_common_column (ID, CODE, NAME, COLUMN_TYPE, COLUMN_LENGTH, POSTIL, FIELD_SORT)
values ('2c9951815fc3f242015fc40b917400a7', 'XM', '姓名', 'VARCHAR2', 50, null, null);

insert into dp_logic_common_column (ID, CODE, NAME, COLUMN_TYPE, COLUMN_LENGTH, POSTIL, FIELD_SORT)
values ('2c9951815fc3f242015fc40b917f00a8', 'SFZH', '身份证号', 'VARCHAR2', 50, null, null);

commit;
-------------------------------------------- 公共指标初始化数据end------------------------------------------
--部门目录管理菜单及权限
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('4028949f5e98de60015e98e65f260010', '2c90c281587574200158759d3ced0062', '部门目录管理', 'schema/grant/index.action', 'fa fa-circle-o', 2510);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('4028949f5e98de60015e98e78af00013', '4028949f5e98de60015e98e65f260010', 'schema.grant.list', '部门目录管理', '部门目录管理', null, null, null, null);

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '4028949f5e98de60015e98e78af00013');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '4028949f5e98de60015e98e78af00013');

-- 数据征集 --
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894b85fe776ad015fe7ead26100f2', '2c90c281587574200158759d3ced0062', '数据征集', 'schema/collection/toCollectionList.action', 'fa fa-circle-o', 2511);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894b85fe776ad015fe7ec1f3600f7', '402894b85fe776ad015fe7ead26100f2', 'schema.collection.list', '数据征集查询', null, null, null, null, null);

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) 
values ('8aa0bef544713ca60144713d364a0000', '402894b85fe776ad015fe7ec1f3600f7');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) 
values ('2c90c28158761b550158762482b50015', '402894b85fe776ad015fe7ec1f3600f7');



COMMIT;


--数据处理过程日志表
drop table DP_PROCESS_PROCEDURE_LOG cascade constraints;

/*==============================================================*/
/* Table: DP_PROCESS_PROCEDURE_LOG                              */
/*==============================================================*/
create table DP_PROCESS_PROCEDURE_LOG
(
   ID                   VARCHAR2(50)         not null,
   DEAL_TYPE            VARCHAR2(2),
   TASK_CODE            VARCHAR2(50),
   START_TIME           DATE,
   END_TIME             DATE
);

comment on table DP_PROCESS_PROCEDURE_LOG is
'数据处理过程日志表';

comment on column DP_PROCESS_PROCEDURE_LOG.ID is
'主键';

comment on column DP_PROCESS_PROCEDURE_LOG.DEAL_TYPE is
'处理类别 1-数据上报 2-规则校验 3-关联入库';

comment on column DP_PROCESS_PROCEDURE_LOG.TASK_CODE is
'上报批次编号';

comment on column DP_PROCESS_PROCEDURE_LOG.START_TIME is
'开始时间';

comment on column DP_PROCESS_PROCEDURE_LOG.END_TIME is
'结束时间';

--原始业务表对应关系表
drop table DP_YSYW_RELATION cascade constraints;

/*==============================================================*/
/* Table: DP_YSYW_RELATION                                      */
/*==============================================================*/
create table DP_YSYW_RELATION
(
   ID                   VARCHAR2(50)  default sys_guid() not null,
   TABLE_CODE            VARCHAR2(50) ,
   YW_TABLE_NAME            VARCHAR2(100)
);

comment on table DP_YSYW_RELATION is
'原始业务表对应关系表';

comment on column DP_YSYW_RELATION.ID is
'主键';

comment on column DP_YSYW_RELATION.TABLE_CODE is
'目录编码';

comment on column DP_YSYW_RELATION.YW_TABLE_NAME is
'业务库表名';

-- 业务库中表字段对应的别名
DROP TABLE DZ_YW_TABLE_COLUMN CASCADE CONSTRAINTS;
create table DZ_YW_TABLE_COLUMN
(
  id              VARCHAR2(50) not null,
  table_code        VARCHAR2(50) not null,
  column_name     VARCHAR2(200),
  column_alias    VARCHAR2(200),
  DISPLAY_ORDER   NUMBER
)
;
comment on table DZ_YW_TABLE_COLUMN
  is '与业务库对应的字段表';
comment on column DZ_YW_TABLE_COLUMN.id
  is '主键';
comment on column DZ_YW_TABLE_COLUMN.table_code
  is '表code';
comment on column DZ_YW_TABLE_COLUMN.column_name
  is '字段code';
comment on column DZ_YW_TABLE_COLUMN.column_alias
  is '字段别名';
  
comment on column DZ_YW_TABLE_COLUMN.DISPLAY_ORDER
  is '字段排序顺序';
alter table DZ_YW_TABLE_COLUMN
  add primary key (ID);
 


insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10357', 'YW_L_FZCHRD', 'rdrq', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10358', 'YW_L_FZCHRD', 'yynx', '应用年限', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10359', 'YW_L_FZCHRD', 'gljg', '管理机构', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10360', 'YW_L_GD', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10361', 'YW_L_GD', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10362', 'YW_L_GD', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10363', 'YW_L_GD', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10364', 'YW_L_GD', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10365', 'YW_L_GD', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10366', 'YW_L_GD', 'gdlx', '股东类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10367', 'YW_L_GD', 'gdmc', '股东名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10368', 'YW_L_GD', 'rjcz', '认缴出资（万元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10369', 'YW_L_GD', 'sjcz', '实缴出资（万元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10370', 'YW_L_GD', 'djjgmc', '登记机关名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10371', 'YW_L_GD', 'djrq', '登记日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10372', 'YW_L_GD', 'gsgqczzm', '公司股权出质证明', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10373', 'YW_L_GD', 'bgrq', '变更日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10374', 'YW_L_HEIMINGDAN', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10375', 'YW_L_HEIMINGDAN', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10376', 'YW_L_HEIMINGDAN', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10377', 'YW_L_HEIMINGDAN', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10378', 'YW_L_HEIMINGDAN', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10379', 'YW_L_HEIMINGDAN', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10380', 'YW_L_HEIMINGDAN', 'rddw', '认定单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10381', 'YW_L_HEIMINGDAN', 'rdwh', '认定文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10382', 'YW_L_HEIMINGDAN', 'zcdz', '注册地址', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10383', 'YW_L_HEIMINGDAN', 'fddbr', '法定代表人', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10384', 'YW_L_HEIMINGDAN', 'fzrxm', '负责人姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10385', 'YW_L_HEIMINGDAN', 'zysxss', '主要失信事实 ', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10386', 'YW_L_HEIMINGDAN', 'scfzynr', '行政处理处罚或法院判决决定的主要内容', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10387', 'YW_L_HEIMINGDAN', 'qryzsxrq', '确认严重失信日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10388', 'YW_L_HEIMINGDAN', 'gsjzq', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10389', 'YW_L_HEIMINGDAN', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10390', 'YW_L_HEIMINGDAN', 'dqzt', '当前状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10391', 'YW_L_HONGMINGDAN', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10392', 'YW_L_HONGMINGDAN', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10393', 'YW_L_HONGMINGDAN', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10394', 'YW_L_HONGMINGDAN', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10395', 'YW_L_HONGMINGDAN', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10396', 'YW_L_HONGMINGDAN', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10397', 'YW_L_HONGMINGDAN', 'bzwjh', '表彰文件号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10398', 'YW_L_HONGMINGDAN', 'rymc', '荣誉名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10399', 'YW_L_HONGMINGDAN', 'rdwh', '认定文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10400', 'YW_L_HONGMINGDAN', 'rdjgqc', '认定机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10401', 'YW_L_HONGMINGDAN', 'rdrq', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10402', 'YW_L_HONGMINGDAN', 'gsjzq', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10403', 'YW_L_HONGMINGDAN', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10404', 'YW_L_HONGMINGDAN', 'dqzt', '当前状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10405', 'YW_L_JGSLBGDJ', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10406', 'YW_L_JGSLBGDJ', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10407', 'YW_L_JGSLBGDJ', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10408', 'YW_L_JGSLBGDJ', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10409', 'YW_L_JGSLBGDJ', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10410', 'YW_L_JGSLBGDJ', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10411', 'YW_L_JGSLBGDJ', 'sldjlx', '设立登记类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10412', 'YW_L_JGSLBGDJ', 'zl', '种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10413', 'YW_L_JGSLBGDJ', 'fddbrxm', '法定代表人姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10414', 'YW_L_JGSLBGDJ', 'fddbrzjlx', '法定代表人证件名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10415', 'YW_L_JGSLBGDJ', 'fddbrzjhm', '法定代表人证件号码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10416', 'YW_L_JGSLBGDJ', 'zczj', '注册资金（万元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10417', 'YW_L_JGSLBGDJ', 'sszj', '实收资金（万元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10418', 'YW_L_JGSLBGDJ', 'jyfw', '经营范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10419', 'YW_L_JGSLBGDJ', 'qylxdm', '企业类型代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10420', 'YW_L_JGSLBGDJ', 'qylxmc', '企业类型名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10421', 'YW_L_JGSLBGDJ', 'sshymc', '所属行业名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10422', 'YW_L_JGSLBGDJ', 'sshydm', '所属行业代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10423', 'YW_L_JGSLBGDJ', 'jgdz', '机构地址', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10424', 'YW_L_JGSLBGDJ', 'fzjgmc', '发证机关名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10425', 'YW_L_JGSLBGDJ', 'fzrq', '发证日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10426', 'YW_L_JGSLBGDJ', 'hzrq', '核准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10427', 'YW_L_JGSLBGDJ', 'jjlx', '经济类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10428', 'YW_L_JGSLBGDJ', 'xzqh', '行政区划', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10429', 'YW_L_JGSLBGDJ', 'lxdh', '联系电话', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10430', 'YW_L_JGSLBGDJ', 'jgdw', '监管单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10431', 'YW_L_JGSLBGDJ', 'gdfqr', '股东', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10432', 'YW_L_JGSLBGDJ', 'zjbz', '资金币种', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10433', 'YW_L_JGSLBGDJ', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10434', 'YW_L_JGSLBGDJ', 'longitude', '企业经度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10435', 'YW_L_JGSLBGDJ', 'latitude', '企业纬度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2001', 'YW_P_GRBZDJXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2002', 'YW_P_GRBZDJXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2003', 'YW_P_GRBZDJXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2004', 'YW_P_GRBZDJXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2005', 'YW_P_GRBZDJXX', 'DJRQ', '登记日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2006', 'YW_P_GRBZDJXX', 'SWRQ', '死亡日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2007', 'YW_P_GRBZDJXX', 'JSLXFS', '家属联系方式', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2008', 'YW_P_GRBZDJXX', 'JSLXRXM', '家属联系人姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2009', 'YW_P_GRBZDJXX', 'LXRDZ', '联系人地址', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2010', 'YW_P_GRCL', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2011', 'YW_P_GRCL', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2012', 'YW_P_GRCL', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2013', 'YW_P_GRCL', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2014', 'YW_P_GRCL', 'HPZL', '号牌种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2015', 'YW_P_GRCL', 'ZWPP', '中文品牌', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2016', 'YW_P_GRCL', 'CLXH', '车辆型号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2017', 'YW_P_GRCL', 'CCLZSJ', '初次领证时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2018', 'YW_P_GRCL', 'SYXZ', '使用性质', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2019', 'YW_P_GRCL', 'GXRQ', '更新日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2020', 'YW_P_GRCL', 'SYSXQ', '使用生效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2021', 'YW_P_GRCL', 'SYJZQ', '使用截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2022', 'YW_P_GRCL', 'FZRQ', '发证日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2023', 'YW_P_GRCYZG', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2024', 'YW_P_GRCYZG', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2025', 'YW_P_GRCYZG', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2026', 'YW_P_GRCYZG', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2027', 'YW_P_GRCYZG', 'CYZGMC', '从业资格名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2028', 'YW_P_GRCYZG', 'CYZGDJ', '从业资格等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2029', 'YW_P_GRCYZG', 'FZRQ', '发证日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2030', 'YW_P_GRCYZG', 'YXQZ', '有效期至', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2031', 'YW_P_GRCYZG', 'FZDW', '发证单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2032', 'YW_P_GRDB', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2033', 'YW_P_GRDB', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2034', 'YW_P_GRDB', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2035', 'YW_P_GRDB', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2036', 'YW_P_GRDB', 'SSDQ', '所属地区', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2037', 'YW_P_GRDB', 'SSX', '所属县', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2038', 'YW_P_GRDB', 'SSZ', '所属镇', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2039', 'YW_P_GRDB', 'DBDJRQ', '低保登记日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2040', 'YW_P_GRDB', 'DBZXRQ', '低保注销日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2041', 'YW_P_GRDB', 'JZLX', '救助类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2042', 'YW_P_GRDBJTCYXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2043', 'YW_P_GRDBJTCYXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2044', 'YW_P_GRDBJTCYXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2045', 'YW_P_GRDBJTCYXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2046', 'YW_P_GRDBJTCYXX', 'XB', '性别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2047', 'YW_P_GRDBJTCYXX', 'MZ', '民族', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2048', 'YW_P_GRDBJTCYXX', 'WHCD', '文化程度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2049', 'YW_P_GRDBJTCYXX', 'LDNL', '劳动能力', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2050', 'YW_P_GRDBJTCYXX', 'JZLX', '救助类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2051', 'YW_P_GRDBJTCYXX', 'JKZK', '健康状况', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2052', 'YW_P_GRDBJTCYXX', 'CJDJ', '残疾等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2053', 'YW_P_GRDBJTCYXX', 'CJLB', '残疾类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2054', 'YW_P_GRDBJTCYXX', 'DTBHLX', '动态变化类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2055', 'YW_P_GRDBJTCYXX', 'BHNY', '变化年月', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2056', 'YW_P_GRDBJTCYXX', 'S', '市（区）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2057', 'YW_P_GRDBJTCYXX', 'JD', '街道(乡镇)', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2058', 'YW_P_GRDBJTCYXX', 'SQ', '社区(村)', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2059', 'YW_P_GRDBJTCYXX', 'HZSFZH', '户主身份证号码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2060', 'YW_P_GRDBJTCYXX', 'HZXM', '户主姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2061', 'YW_P_GRDBJTCYXX', 'JTGX', '家庭关系', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2062', 'YW_P_GRDBJTXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2063', 'YW_P_GRDBJTXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2064', 'YW_P_GRDBJTXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2065', 'YW_P_GRDBJTXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2066', 'YW_P_GRDBJTXX', 'BZRKS', '保障人口数', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2067', 'YW_P_GRDBJTXX', 'JTRKS', '家庭人口数', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2068', 'YW_P_GRDBJTXX', 'LXDH', '联系电话', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2069', 'YW_P_GRDBJTXX', 'JZDZ', '居住地址', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2070', 'YW_P_GRDBJTXX', 'DTBHLX', '动态变化类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2071', 'YW_P_GRDBJTXX', 'DTBHNY', '动态变化年月', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2072', 'YW_P_GRDBJTXX', 'S', '市（区）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2073', 'YW_P_GRDBJTXX', 'JD', '街道(乡镇)', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2074', 'YW_P_GRDBJTXX', 'SQ', '社区(村)', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2075', 'YW_P_GRETJZYM', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2076', 'YW_P_GRETJZYM', 'SFZH', '儿童身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2077', 'YW_P_GRETJZYM', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2078', 'YW_P_GRETJZYM', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2079', 'YW_P_GRETJZYM', 'XB', '儿童性别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2080', 'YW_P_GRETJZYM', 'CSRQ', '出生日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2081', 'YW_P_GRETJZYM', 'ZHYMJZRQ', '最后一次疫苗接种日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2082', 'YW_P_GRETJZYM', 'CS', '接种疫苗次数', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2083', 'YW_P_GRFYQZZX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2084', 'YW_P_GRFYQZZX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2085', 'YW_P_GRFYQZZX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2086', 'YW_P_GRFYQZZX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2087', 'YW_P_GRFYQZZX', 'AH', '案号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2088', 'YW_P_GRFYQZZX', 'SLFY', '受理法院', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2089', 'YW_P_GRFYQZZX', 'AJZT', '案件状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2090', 'YW_P_GRFYQZZX', 'JARQ', '结案日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2091', 'YW_P_GRGZ', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2092', 'YW_P_GRGZ', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2093', 'YW_P_GRGZ', 'DJJG', '登记机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2094', 'YW_P_GRGZ', 'DJRQ', '登记日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2095', 'YW_P_GRGZ', 'ZZJGDM', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2096', 'YW_P_GRGZ', 'JGQCYW', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2097', 'YW_P_GRGZ', 'JGQCZW', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2098', 'YW_P_GRGZ', 'GSZCH', '工商注册号（单位注册号）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2099', 'YW_P_GRGZ', 'TYSHXYDM', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2100', 'YW_P_GRGZ', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2101', 'YW_P_GRHEIMINGDAN', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2102', 'YW_P_GRHEIMINGDAN', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2103', 'YW_P_GRHEIMINGDAN', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2104', 'YW_P_GRHEIMINGDAN', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2105', 'YW_P_GRHEIMINGDAN', 'ZYSXSS', '主要失信事实', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2106', 'YW_P_GRHEIMINGDAN', 'XZCLJDNR', '行政处理决定内容', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2107', 'YW_P_GRHEIMINGDAN', 'RDWH', '认定文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2108', 'YW_P_GRHEIMINGDAN', 'RDDW', '认定单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2109', 'YW_P_GRHEIMINGDAN', 'RDRQ', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2110', 'YW_P_GRHEIMINGDAN', 'GSJZQ', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2111', 'YW_P_GRHONGMINGDAN', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2112', 'YW_P_GRHONGMINGDAN', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2113', 'YW_P_GRHONGMINGDAN', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2114', 'YW_P_GRHONGMINGDAN', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2115', 'YW_P_GRHONGMINGDAN', 'RYMC', '荣誉名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2116', 'YW_P_GRHONGMINGDAN', 'RYSX', '荣誉事项', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2117', 'YW_P_GRHONGMINGDAN', 'RDWH', '认定文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2118', 'YW_P_GRHONGMINGDAN', 'RDDW', '认定单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2119', 'YW_P_GRHONGMINGDAN', 'RDRQ', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2120', 'YW_P_GRHONGMINGDAN', 'GSJZQ', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2121', 'YW_P_GRHYDJ', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2122', 'YW_P_GRHYDJ', 'DJJG', '登记机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2123', 'YW_P_GRHYDJ', 'DJRQ', '登记日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2124', 'YW_P_GRHYDJ', 'NANFXM', '男方姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2125', 'YW_P_GRHYDJ', 'NANFSFZH', '男方身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2126', 'YW_P_GRHYDJ', 'NVFXM', '女方姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2127', 'YW_P_GRHYDJ', 'NVFSFZH', '女方身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2128', 'YW_P_GRHYDJ', 'YWLX', '业务类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2129', 'YW_P_GRHYDJ', 'HYZKNV', '婚姻状况（女）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2130', 'YW_P_GRHYDJ', 'HYZKNAN', '婚姻状况（男）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2131', 'YW_P_GRJBXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2132', 'YW_P_GRJBXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2133', 'YW_P_GRJBXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2134', 'YW_P_GRJBXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2135', 'YW_P_GRJBXX', 'RKJLID', '人口记录ID', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2136', 'YW_P_GRJBXX', 'XB', '性别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2137', 'YW_P_GRJBXX', 'CSRQ', '出生日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2138', 'YW_P_GRJBXX', 'HJDZ', '户籍地址', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2139', 'YW_P_GRJBXX', 'JFJG', '签发机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2140', 'YW_P_GRJBXX', 'QFRQ', '签发日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2141', 'YW_P_GRJBXX', 'MZ', '民族', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2142', 'YW_P_GRJBXX', 'LXDH', '联系电话', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2143', 'YW_P_GRJSZXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2144', 'YW_P_GRJSZXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2145', 'YW_P_GRJSZXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2146', 'YW_P_GRJSZXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2147', 'YW_P_GRJSZXX', 'ZJCX', '准驾车型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2148', 'YW_P_GRJSZXX', 'JDZZT', '驾驶证状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2149', 'YW_P_GRJSZXX', 'CCLZSJ', '初次领证时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2150', 'YW_P_GRJSZXX', 'GXRQ', '更新日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2151', 'YW_P_GRJSZXX', 'JZDZ', '居住地址', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2152', 'YW_P_GRJTSX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2153', 'YW_P_GRJTSX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2154', 'YW_P_GRJTSX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2155', 'YW_P_GRJTSX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2156', 'YW_P_GRJTSX', 'JTSXXW', '交通失信行为', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2157', 'YW_P_GRJTSX', 'SXYZCD', '失信严重程度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2158', 'YW_P_GRJTSX', 'RDJG', '认定机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2159', 'YW_P_GRJTSX', 'RDRQ', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2160', 'YW_P_GRJTSX', 'JLYXQ', '记录有效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2161', 'YW_P_GRJYZK', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2162', 'YW_P_GRJYZK', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2163', 'YW_P_GRJYZK', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2164', 'YW_P_GRJYZK', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2165', 'YW_P_GRJYZK', 'JYZK', '就业状况', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2166', 'YW_P_GRJYZK', 'DJJG', '登记机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2167', 'YW_P_GRJYZK', 'DJRQ', '登记日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2168', 'YW_P_GRNS', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2169', 'YW_P_GRNS', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2170', 'YW_P_GRNS', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2171', 'YW_P_GRNS', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2172', 'YW_P_GRNS', 'SZ', '税种', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2173', 'YW_P_GRNS', 'JNZT', '缴纳状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2174', 'YW_P_GRNS', 'SKSSQSRQ', '税款所属起始日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2175', 'YW_P_GRNS', 'SKSSZZRQ', '税款所属终止日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2176', 'YW_P_GRNS', 'NSRQ', '纳税日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2177', 'YW_P_GRNS', 'ZGSWJG', '主管税务机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2178', 'YW_P_GRPJ', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2179', 'YW_P_GRPJ', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2180', 'YW_P_GRPJ', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2181', 'YW_P_GRPJ', 'AH', '案号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2182', 'YW_P_GRPJ', 'PJJG', '判决结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2183', 'YW_P_GRPJ', 'ZXJG', '执行结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2184', 'YW_P_GRPJ', 'PJJIGUAN', '判决机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2185', 'YW_P_GRPJ', 'PJRQ', '判决日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2186', 'YW_P_GRPJ', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2187', 'YW_P_GRQS', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2188', 'YW_P_GRQS', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2189', 'YW_P_GRQS', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2190', 'YW_P_GRQS', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2191', 'YW_P_GRQS', 'SZDM', '税种代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2192', 'YW_P_GRQS', 'SZMC', '税种名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2193', 'YW_P_GRQS', 'QSYE', '欠税余额', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2194', 'YW_P_GRQS', 'ZGSWJG', '主管税务机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2195', 'YW_P_GRQS', 'JZRQ', '截止日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2196', 'YW_P_GRQTBLXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2197', 'YW_P_GRQTBLXX', 'SFZH', '儿童身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2198', 'YW_P_GRQTBLXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2199', 'YW_P_GRQTBLXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2200', 'YW_P_GRQTBLXX', 'SXYZCD', '失信严重程度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2201', 'YW_P_GRQTBLXX', 'SXXWYXRQ', '失信行为有效日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2202', 'YW_P_GRQTBLXX', 'BLXWSS', '不良行为事实', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2203', 'YW_P_GRQTBLXX', 'CFRQ', '处罚日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2204', 'YW_P_GRQTBLXX', 'JZRQ', '截止日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2205', 'YW_P_GRQTBLXX', 'CFDWQC', '处罚单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2206', 'YW_P_GRQTBLXX', 'WJWH', '文件文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2207', 'YW_P_GRRYXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2208', 'YW_P_GRRYXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2209', 'YW_P_GRRYXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2210', 'YW_P_GRRYXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2211', 'YW_P_GRRYXX', 'PDDW', '评（认）定单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2212', 'YW_P_GRRYXX', 'PDRQ', '评（认）定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2213', 'YW_P_GRRYXX', 'RYMC', '荣誉名称（含级别）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2214', 'YW_P_GRRYXX', 'RYSX', '荣誉事项', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2215', 'YW_P_GRRYXX', 'ZSBH', '证书编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2216', 'YW_P_GRRYXX', 'SZDWMC', '所在单位名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2217', 'YW_P_GRRYXX', 'SZDWZZJGDM', '所在单位组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2218', 'YW_P_GRSFBD', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2219', 'YW_P_GRSFBD', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2220', 'YW_P_GRSFBD', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2221', 'YW_P_GRSFBD', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2222', 'YW_P_GRSFBD', 'BGYY', '变更原因', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2223', 'YW_P_GRSFBD', 'BGDJJG', '变更登记机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2224', 'YW_P_GRSFBD', 'BGRQ', '变更日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2225', 'YW_P_GRSGSXZCF', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2226', 'YW_P_GRSGSXZCF', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2227', 'YW_P_GRSGSXZCF', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2228', 'YW_P_GRSGSXZCF', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2229', 'YW_P_GRSGSXZCF', 'AJMC', '案件名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2230', 'YW_P_GRSGSXZCF', 'XZCFJDSWH', '行政处罚决定书文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2231', 'YW_P_GRSGSXZCF', 'XZCFBM', '行政处罚编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2232', 'YW_P_GRSGSXZCF', 'CFLB', '处罚类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2233', 'YW_P_GRSGSXZCF', 'SXYZCD', '失信严重程度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2234', 'YW_P_GRSGSXZCF', 'CFYJ', '处罚依据', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2235', 'YW_P_GRSGSXZCF', 'CFSY', '处罚事由', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2236', 'YW_P_GRSGSXZCF', 'CFJG', '处罚结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2237', 'YW_P_GRSGSXZCF', 'CFJDRQ', '处罚决定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2238', 'YW_P_GRSGSXZCF', 'CFJGMC', '处罚机关名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2239', 'YW_P_GRSGSXZCF', 'DQZT', '当前状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2240', 'YW_P_GRSGSXZCF', 'GSJZQ', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2241', 'YW_P_GRSGSXZCF', 'XXSYFW', '信息使用范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2242', 'YW_P_GRSGSXZXK', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2243', 'YW_P_GRSGSXZXK', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2244', 'YW_P_GRSGSXZXK', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2245', 'YW_P_GRSGSXZXK', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2246', 'YW_P_GRSGSXZXK', 'XMMC', '项目名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2247', 'YW_P_GRSGSXZXK', 'XZXKJDSWH', '行政许可决定书文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2248', 'YW_P_GRSGSXZXK', 'XZXKBM', '行政许可编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2249', 'YW_P_GRSGSXZXK', 'SPLB', '审批类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2250', 'YW_P_GRSGSXZXK', 'XKNR', '许可内容', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2251', 'YW_P_GRSGSXZXK', 'XKJDRQ', '许可决定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2252', 'YW_P_GRSGSXZXK', 'XKJG', '许可机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2253', 'YW_P_GRSGSXZXK', 'XKJZQ', '许可截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2254', 'YW_P_GRSGSXZXK', 'DQZT', '当前状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2255', 'YW_P_GRSGSXZXK', 'XXSYFW', '信息使用范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2256', 'YW_P_GRSQJZRYXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2257', 'YW_P_GRSQJZRYXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2258', 'YW_P_GRSQJZRYXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2259', 'YW_P_GRSQJZRYXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2260', 'YW_P_GRSQJZRYXX', 'FXLB', '服刑类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2261', 'YW_P_GRSQJZRYXX', 'SQJZLX', '社区矫正类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2262', 'YW_P_GRSQJZRYXX', 'JYQK', '就业情况', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2263', 'YW_P_GRSQJZRYXX', 'JZQSRQ', '矫正起始日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2264', 'YW_P_GRSQJZRYXX', 'JZZZRQ', '矫正终止日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2265', 'YW_P_GRSQJZRYXX', 'PJJG', '判决机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2266', 'YW_P_GRSQJZRYXX', 'PJRQ', '判决日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2267', 'YW_P_GRSYWY', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2268', 'YW_P_GRSYWY', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2269', 'YW_P_GRSYWY', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2270', 'YW_P_GRSYWY', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2271', 'YW_P_GRSYWY', 'ZHH', '账户号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2272', 'YW_P_GRSYWY', 'SXYZCD', '失信严重程度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2273', 'YW_P_GRSYWY', 'QFJE', '欠费金额', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2274', 'YW_P_GRSYWY', 'BZQQFBJRQ', '本账期欠费补缴日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2275', 'YW_P_GRSYWY', 'SXXWYXQ', '失信行为有效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2276', 'YW_P_GRSYWY', 'ZQSJ', '账期时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2277', 'YW_P_GRXHFZAJ', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2278', 'YW_P_GRXHFZAJ', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2279', 'YW_P_GRXHFZAJ', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2280', 'YW_P_GRXHFZAJ', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2281', 'YW_P_GRXHFZAJ', 'ZW', '职务', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2282', 'YW_P_GRXHFZAJ', 'AJXZ', '案件性质', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2283', 'YW_P_GRXHFZAJ', 'AJZY', '案情摘要', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2284', 'YW_P_GRXHFZAJ', 'CLQK', '处理情况', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2285', 'YW_P_GRXHFZAJ', 'HYLY', '行业领域', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2286', 'YW_P_GRXHFZAJ', 'PJJG', '判决结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2287', 'YW_P_GRXHFZAJ', 'SAJE', '涉案金额', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2288', 'YW_P_GRXHFZAJ', 'SSDW', '所属单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2289', 'YW_P_GRXHFZAJ', 'XXTGBMQC', '信息提供部门全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2290', 'YW_P_GRXIANXIE', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2291', 'YW_P_GRXIANXIE', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2292', 'YW_P_GRXIANXIE', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2293', 'YW_P_GRXIANXIE', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2294', 'YW_P_GRXIANXIE', 'JLID', '记录ID', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2295', 'YW_P_GRXIANXIE', 'XXM', '献血码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2296', 'YW_P_GRXIANXIE', 'XXRQ', '献血日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2297', 'YW_P_GRXIANXIE', 'XXLX', '献血类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2298', 'YW_P_GRXIANXIE', 'XYLX', '血液类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2299', 'YW_P_GRXIANXIE', 'XXL', '献血量', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2300', 'YW_P_GRXIANXIE', 'ZSXXL', '折算献血量', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2301', 'YW_P_GRXL', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2302', 'YW_P_GRXL', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2303', 'YW_P_GRXL', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2304', 'YW_P_GRXL', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2305', 'YW_P_GRXL', 'XL', '学历', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2306', 'YW_P_GRXL', 'XLBYXX', '学历毕业学校', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2307', 'YW_P_GRXL', 'XLBYSJ', '学历毕业时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2308', 'YW_P_GRXL', 'XLBYZY', '学历毕业专业', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2309', 'YW_P_GRXL', 'XW', '学位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2310', 'YW_P_GRXL', 'XWBYXX', '学位毕业信息', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2311', 'YW_P_GRXL', 'XWBYSJ', '学位毕业时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2312', 'YW_P_GRXL', 'XWBYZY', '学位毕业专业', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2313', 'YW_P_GRXYPJ', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2314', 'YW_P_GRXYPJ', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2315', 'YW_P_GRXYPJ', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2316', 'YW_P_GRXYPJ', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2317', 'YW_P_GRXYPJ', 'PDJB', '评定级别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2318', 'YW_P_GRXYPJ', 'PDSJ', '评定时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2319', 'YW_P_GRXZCF', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2320', 'YW_P_GRXZCF', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2321', 'YW_P_GRXZCF', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2322', 'YW_P_GRXZCF', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2323', 'YW_P_GRXZCF', 'CFWH', '处罚文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2324', 'YW_P_GRXZCF', 'CFMC', '处罚名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2325', 'YW_P_GRXZCF', 'CFSY', '处罚事由', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2326', 'YW_P_GRXZCF', 'CFYJ', '处罚依据', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2327', 'YW_P_GRXZCF', 'CFZL', '处罚种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2328', 'YW_P_GRXZCF', 'CFJG', '处罚结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2329', 'YW_P_GRXZCF', 'CFDJ', '处罚等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2330', 'YW_P_GRXZCF', 'CFRQ', '处罚日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2331', 'YW_P_GRXZCF', 'CFSXQ', '处罚生效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2332', 'YW_P_GRXZCF', 'CFJZQ', '处罚截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2333', 'YW_P_GRXZCF', 'CFJGMC', '处罚机关名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2334', 'YW_P_GRXZCF', 'ZXQK', '执行情况（当前状态）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2335', 'YW_P_GRXZCF', 'ZXWCRQ', '执行完成日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2336', 'YW_P_GRXZCF', 'GSJZQ', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2337', 'YW_P_GRXZCF', 'GXSJC', '数据更新时间戳', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2338', 'YW_P_GRXZCF', 'XZCFBM', '行政处罚编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2339', 'YW_P_GRXZCF', 'XXSYFW', '信息使用范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2340', 'YW_P_GRXZXK', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2341', 'YW_P_GRXZXK', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2342', 'YW_P_GRXZXK', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2343', 'YW_P_GRXZXK', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2344', 'YW_P_GRXZXK', 'XKJDSWH', '许可决定书文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2345', 'YW_P_GRXZXK', 'XKZBH', '许可证编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2346', 'YW_P_GRXZXK', 'XKZMC', '许可证名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2347', 'YW_P_GRXZXK', 'XKZFW', '许可证内容（范围）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2348', 'YW_P_GRXZXK', 'ZL', '种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2349', 'YW_P_GRXZXK', 'XKSXQ', '许可生效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2350', 'YW_P_GRXZXK', 'XKJZQ', '许可截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2351', 'YW_P_GRXZXK', 'PZJGQC', '批准机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2352', 'YW_P_GRXZXK', 'PZRQ', '批准(注/撤/吊销)日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2353', 'YW_P_GRXZXK', 'BGHZRQ', '（变更）核准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2354', 'YW_P_GRXZXK', 'XKZDQZT', '许可证当前状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2355', 'YW_P_GRXZXK', 'GXSJC', '数据更新时间戳', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2356', 'YW_P_GRXZXK', 'XMMC', '项目名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2357', 'YW_P_GRXZXK', 'SPLB', '审批类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2358', 'YW_P_GRXZXK', 'DFBM', '地方编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2359', 'YW_P_GRXZXK', 'GSJZQ', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2360', 'YW_P_GRYLBXZT', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2361', 'YW_P_GRYLBXZT', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2362', 'YW_P_GRYLBXZT', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2363', 'YW_P_GRYLBXZT', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2364', 'YW_P_GRYLBXZT', 'YLBXZT', '养老保险状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2365', 'YW_P_GRZGZC', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2366', 'YW_P_GRZGZC', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2367', 'YW_P_GRZGZC', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2368', 'YW_P_GRZGZC', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2369', 'YW_P_GRZGZC', 'ZCZSMC', '注册证书名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2370', 'YW_P_GRZGZC', 'ZYZGDJ', '执业资格等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2371', 'YW_P_GRZGZC', 'ZCZSBH', '注册证书编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2372', 'YW_P_GRZGZC', 'ZCRQ', '注册日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2373', 'YW_P_GRZGZC', 'ZSSXQ', '证书生效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2374', 'YW_P_GRZGZC', 'ZSJZQ', '证书截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2375', 'YW_P_GRZGZC', 'FZDW', '发证单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2376', 'YW_P_GRZGZC', 'ZGZT', '资格状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2377', 'YW_P_GRZGZC', 'ZYDWMC', '执业单位名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2378', 'YW_P_GRZGZC', 'ZYDWZZJGDM', '执业单位组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2379', 'YW_P_GRZGZC', 'ZYDWGSZCH', '执业单位工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2380', 'YW_P_GRZGZC', 'ZYDWTYSHXYDM', '执业单位统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2381', 'YW_P_GRZGZCX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2382', 'YW_P_GRZGZCX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2383', 'YW_P_GRZGZCX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2384', 'YW_P_GRZGZCX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2385', 'YW_P_GRZGZCX', 'ZSBH', '证书编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2386', 'YW_P_GRZGZCX', 'ZGMC', '资格名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2387', 'YW_P_GRZGZCX', 'ZCXLX', '注（撤）销类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2388', 'YW_P_GRZGZCX', 'ZCXRQ', '注（撤）销日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2389', 'YW_P_GRZGZCX', 'ZCXJG', '注（撤）销机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2390', 'YW_P_GRZYFWSC', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2391', 'YW_P_GRZYFWSC', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2392', 'YW_P_GRZYFWSC', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2393', 'YW_P_GRZYFWSC', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2394', 'YW_P_GRZYFWSC', 'ZZMM', '政治面貌', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2395', 'YW_P_GRZYFWSC', 'GZDW', '工作单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2396', 'YW_P_GRZYFWSC', 'FWSC', '服务时长', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2397', 'YW_P_GRZYHZXX', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2398', 'YW_P_GRZYHZXX', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2399', 'YW_P_GRZYHZXX', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2400', 'YW_P_GRZYHZXX', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2401', 'YW_P_GRZYHZXX', 'ZYMC', '职业名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2402', 'YW_P_GRZYJSZG', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2403', 'YW_P_GRZYJSZG', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2404', 'YW_P_GRZYJSZG', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2405', 'YW_P_GRZYJSZG', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2406', 'YW_P_GRZYJSZG', 'ZYJSZGMC', '专业技术资格名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2407', 'YW_P_GRZYJSZG', 'ZYLB', '专业类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2408', 'YW_P_GRZYJSZG', 'QDRQ', '取得日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2409', 'YW_P_GRZYJSZG', 'SPDW', '审批单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2410', 'YW_P_GRZYZFW', 'ZZMM', '政治面貌', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2411', 'YW_P_GRZYZFW', 'GZDW', '工作单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2412', 'YW_P_GRZYZFW', 'FWSC', '服务时长', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2413', 'YW_P_GRZYZFW', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2414', 'YW_P_GRZYZFW', 'SFZH', '儿童身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2415', 'YW_P_GRZYZFW', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2416', 'YW_P_GRZYZFW', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2417', 'YW_P_GRZYZFW', 'JF', '积分', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2418', 'YW_P_GRZYZYZG', 'XM', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2419', 'YW_P_GRZYZYZG', 'SFZH', '身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2420', 'YW_P_GRZYZYZG', 'ZJLX', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2421', 'YW_P_GRZYZYZG', 'BZ', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2422', 'YW_P_GRZYZYZG', 'ZCZSMC', '注册证书名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2423', 'YW_P_GRZYZYZG', 'ZYZGDJ', '执业资格等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2424', 'YW_P_GRZYZYZG', 'ZCRQ', '注册日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2425', 'YW_P_GRZYZYZG', 'ZCYXQZ', '注册有效期至', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2426', 'YW_P_GRZYZYZG', 'FZDW', '发证单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('2427', 'YW_P_GRZYZYZG', 'ZYDWMC', '执业单位名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10001', 'yw_l_xzcf', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10002', 'yw_l_xzcf', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10003', 'yw_l_xzcf', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10004', 'yw_l_xzcf', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10005', 'yw_l_xzcf', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10006', 'yw_l_xzcf', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10007', 'yw_l_xzcf', 'xzcfbm', '行政处罚编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10008', 'yw_l_xzcf', 'cfjdswh', '处罚决定书文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10009', 'yw_l_xzcf', 'cfmc', '处罚名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10010', 'yw_l_xzcf', 'cfsy', '处罚事由', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10011', 'yw_l_xzcf', 'cfyj', '处罚依据', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10012', 'yw_l_xzcf', 'wfxwlx', '违法行为类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10013', 'yw_l_xzcf', 'cfzl', '处罚种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10014', 'yw_l_xzcf', 'cfjg', '处罚结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10015', 'yw_l_xzcf', 'cfdj', '处罚等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10016', 'yw_l_xzcf', 'cfjdrq', '处罚决定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10017', 'yw_l_xzcf', 'syyxq', '使用有效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10018', 'yw_l_xzcf', 'cfcsz', '处罚承受者名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10019', 'yw_l_xzcf', 'cfcszzjlx', '处罚承受者证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10020', 'yw_l_xzcf', 'cfcszzjhm', '处罚承受者证件号码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10021', 'yw_l_xzcf', 'cfjdjgmc', '处罚决定机关名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10022', 'yw_l_xzcf', 'zxqk', '执行情况', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10023', 'yw_l_xzcf', 'zxwcrq', '执行完成日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10024', 'yw_l_xzcf', 'fkje', '罚款金额（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10025', 'yw_l_xzcf', 'msje', '没收金额（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10026', 'yw_l_xzcf', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10027', 'YW_L_ZZZCDX', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10028', 'YW_L_ZZZCDX', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10029', 'YW_L_ZZZCDX', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10030', 'YW_L_ZZZCDX', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10031', 'YW_L_ZZZCDX', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10032', 'YW_L_ZZZCDX', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10033', 'YW_L_ZZZCDX', 'zl', '种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10034', 'YW_L_ZZZCDX', 'zsbh', '资质证书编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10035', 'YW_L_ZZZCDX', 'zzmc', '资质名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10036', 'YW_L_ZZZCDX', 'zyfw', '执业范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10037', 'YW_L_ZZZCDX', 'zcdxyy', '注（撤、吊）销原因', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10038', 'YW_L_ZZZCDX', 'pzjgqc', '注（撤、吊）销批准机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10039', 'YW_L_ZZZCDX', 'pzrq', '注（撤、吊）销批准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10040', 'YW_L_ZZZCDX', 'qlbm', '权力编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10041', 'YW_L_ZZZCDX', 'qlmc', '权力名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10042', 'YW_L_ZZZCDX', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10043', 'YW_L_ZZDJBG', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10044', 'YW_L_ZZDJBG', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10045', 'YW_L_ZZDJBG', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10046', 'YW_L_ZZDJBG', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10047', 'YW_L_ZZDJBG', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10048', 'YW_L_ZZDJBG', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10049', 'YW_L_ZZDJBG', 'zl', '种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10050', 'YW_L_ZZDJBG', 'zsbh', '资质证书编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10051', 'YW_L_ZZDJBG', 'zzmc', '资质名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10052', 'YW_L_ZZDJBG', 'zyfw', '执业范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10053', 'YW_L_ZZDJBG', 'zzdj', '资质等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10054', 'YW_L_ZZDJBG', 'zzsxq', '资质生效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10055', 'YW_L_ZZDJBG', 'zzjzq', '资质截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10056', 'YW_L_ZZDJBG', 'rdjgqc', '认定机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10057', 'YW_L_ZZDJBG', 'rdrq', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10058', 'YW_L_ZZDJBG', 'bghzrq', '变更核准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10059', 'YW_L_ZZDJBG', 'qlbm', '权力编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10060', 'YW_L_ZZDJBG', 'qlmc', '权力名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10061', 'YW_L_ZZDJBG', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10062', 'YW_L_XZXKZCDX', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10063', 'YW_L_XZXKZCDX', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10064', 'YW_L_XZXKZCDX', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10065', 'YW_L_XZXKZCDX', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10066', 'YW_L_XZXKZCDX', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10067', 'YW_L_XZXKZCDX', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10068', 'YW_L_XZXKZCDX', 'zl', '种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10069', 'YW_L_XZXKZCDX', 'xkzbh', '许可证编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10070', 'YW_L_XZXKZCDX', 'xkzmc', '许可证名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10071', 'YW_L_XZXKZCDX', 'xknr', '许可内容', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10072', 'YW_L_XZXKZCDX', 'zcdxyy', '注（撤、吊）销原因', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10073', 'YW_L_XZXKZCDX', 'pzjgqc', '注（撤、吊）销批准机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10074', 'YW_L_XZXKZCDX', 'pzrq', '注（撤、吊）销批准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10075', 'YW_L_XZXKZCDX', 'qlbm', '权力编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10076', 'YW_L_XZXKZCDX', 'qlmc', '权力名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10077', 'YW_L_XZXKZCDX', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10078', 'YW_L_XZXKDJBG', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10079', 'YW_L_XZXKDJBG', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10080', 'YW_L_XZXKDJBG', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10081', 'YW_L_XZXKDJBG', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10082', 'YW_L_XZXKDJBG', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10083', 'YW_L_XZXKDJBG', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10084', 'YW_L_XZXKDJBG', 'xzxkbm', '行政许可编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10085', 'YW_L_XZXKDJBG', 'zl', '种类', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10086', 'YW_L_XZXKDJBG', 'xkzbh', '许可证编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10087', 'YW_L_XZXKDJBG', 'xkzmc', '许可证名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10088', 'YW_L_XZXKDJBG', 'xknr', '许可内容', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10089', 'YW_L_XZXKDJBG', 'splb', '审批类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10090', 'YW_L_XZXKDJBG', 'xksxq', '许可生效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10091', 'YW_L_XZXKDJBG', 'xkjzq', '许可截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10092', 'YW_L_XZXKDJBG', 'pzjgqc', '批准机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10093', 'YW_L_XZXKDJBG', 'pzrq', '批准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10094', 'YW_L_XZXKDJBG', 'bghzrq', '变更核准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10095', 'YW_L_XZXKDJBG', 'qlbm', '权力编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10096', 'YW_L_XZXKDJBG', 'qlmc', '权力名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10097', 'YW_L_XZXKDJBG', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10098', 'YW_L_XKZZNJ', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10099', 'YW_L_XKZZNJ', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10100', 'YW_L_XKZZNJ', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10101', 'YW_L_XKZZNJ', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10102', 'YW_L_XKZZNJ', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10103', 'YW_L_XKZZNJ', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10104', 'YW_L_XKZZNJ', 'zsbh', '证书编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10105', 'YW_L_XKZZNJ', 'njnd', '年检年度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10106', 'YW_L_XKZZNJ', 'njjg', '年检结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10107', 'YW_L_XKZZNJ', 'njjgqc', '年检机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10108', 'YW_L_XKZZNJ', 'njsxmc', '年检事项名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10109', 'YW_L_XKZZNJ', 'njrq', '年检日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10110', 'YW_L_XKZZNJ', 'qlbm', '权力编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10111', 'YW_L_XKZZNJ', 'qlmc', '权力名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10112', 'YW_L_XKZZNJ', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10113', 'YW_L_SJSFQYXX', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10114', 'YW_L_SJSFQYXX', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10115', 'YW_L_SJSFQYXX', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10116', 'YW_L_SJSFQYXX', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10117', 'YW_L_SJSFQYXX', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10118', 'YW_L_SJSFQYXX', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10119', 'YW_L_SJSFQYXX', 'rdrq', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10120', 'YW_L_SJSFQYXX', 'rdbm', '市级认定部门', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10121', 'YW_L_SJSFQYXX', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10122', 'YW_L_SGSXZXK', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10123', 'YW_L_SGSXZXK', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10124', 'YW_L_SGSXZXK', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10125', 'YW_L_SGSXZXK', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10126', 'YW_L_SGSXZXK', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10127', 'YW_L_SGSXZXK', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10128', 'YW_L_SGSXZXK', 'xkjdswh', '许可决定书文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10129', 'YW_L_SGSXZXK', 'xmmc', '项目名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10130', 'YW_L_SGSXZXK', 'xzxkbm', '行政许可编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10131', 'YW_L_SGSXZXK', 'splb', '审批类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10132', 'YW_L_SGSXZXK', 'xknr', '许可内容', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10133', 'YW_L_SGSXZXK', 'xzxdrmc', '行政相对人名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10134', 'YW_L_SGSXZXK', 'swdjh', '税务登记码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10135', 'YW_L_SGSXZXK', 'fddbrmc', '法定代表人名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10136', 'YW_L_SGSXZXK', 'fddbrsfzh', '居民身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10137', 'YW_L_SGSXZXK', 'xksxq', '许可决定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10138', 'YW_L_SGSXZXK', 'xkjzq', '许可截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10139', 'YW_L_SGSXZXK', 'xkjg', '许可机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10140', 'YW_L_SGSXZXK', 'dqzt', '登记状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10141', 'YW_L_SGSXZXK', 'dfbm', '地方编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10142', 'YW_L_SGSXZXK', 'gxsjc', '数据更新时间戳', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10143', 'YW_L_SGSXZXK', 'syfw', '信息使用范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10144', 'YW_L_SGSXZXK', 'gsjzq', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10145', 'YW_L_SGSXZXK', 'xzxdrswdjh', '行政相对人税务登记号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10146', 'YW_L_SGSXZCF', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10147', 'YW_L_SGSXZCF', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10148', 'YW_L_SGSXZCF', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10149', 'YW_L_SGSXZCF', 'gszch', '工商登记码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10150', 'YW_L_SGSXZCF', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10151', 'YW_L_SGSXZCF', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10152', 'YW_L_SGSXZCF', 'cfjdswh', '行政处罚决定书文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10153', 'YW_L_SGSXZCF', 'ajmc', '处罚名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10154', 'YW_L_SGSXZCF', 'cfbm', '行政处罚编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10155', 'YW_L_SGSXZCF', 'cfsy', '处罚事由', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10156', 'YW_L_SGSXZCF', 'cfyj', '处罚依据', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10157', 'YW_L_SGSXZCF', 'cfzl', '处罚类别1', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10158', 'YW_L_SGSXZCF', 'cfjg', '处罚结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10159', 'YW_L_SGSXZCF', 'cfdj', '处罚等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10160', 'YW_L_SGSXZCF', 'cfsxq', '处罚生效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10161', 'YW_L_SGSXZCF', 'cfjzq', '处罚截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10162', 'YW_L_SGSXZCF', 'xzxdrmc', '行政相对人名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10163', 'YW_L_SGSXZCF', 'fddbrmc', '法定代表人姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10164', 'YW_L_SGSXZCF', 'fddbrsfzh', '居民身份证号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10165', 'YW_L_SGSXZCF', 'cfjgmc', '处罚机关', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10166', 'YW_L_SGSXZCF', 'dqzt', '登记状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10167', 'YW_L_SGSXZCF', 'dfbm', '地方编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10168', 'YW_L_SGSXZCF', 'gxsjc', '数据更新时间戳', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10169', 'YW_L_SGSXZCF', 'syfw', '信息使用范围', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10170', 'YW_L_SGSXZCF', 'gsjzq', '公示截止期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10171', 'YW_L_SGSXZCF', 'xzxdrswdjh', '税务登记号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10172', 'YW_L_SGSXZCF', 'cflb2', '处罚类别2', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10173', 'YW_L_QYXYGBXX', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10174', 'YW_L_QYXYGBXX', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10175', 'YW_L_QYXYGBXX', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10176', 'YW_L_QYXYGBXX', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10177', 'YW_L_QYXYGBXX', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10178', 'YW_L_QYXYGBXX', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10179', 'YW_L_QYXYGBXX', 'gbrdbmqc', '贯标认定部门全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10180', 'YW_L_QYXYGBXX', 'gbrq', '贯标日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10181', 'YW_L_QYXYGBXX', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10182', 'YW_L_QYSWDJ', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10183', 'YW_L_QYSWDJ', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10184', 'YW_L_QYSWDJ', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10185', 'YW_L_QYSWDJ', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10186', 'YW_L_QYSWDJ', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10187', 'YW_L_QYSWDJ', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10188', 'YW_L_QYSWDJ', 'swglm', '税务管理码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10189', 'YW_L_QYSWDJ', 'nsrsbh', '纳税人识别号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10190', 'YW_L_QYSWDJ', 'fddbrxm', '法定代表人姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10191', 'YW_L_QYSWDJ', 'fddbrzjlx', '法定代表人证件名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10192', 'YW_L_QYSWDJ', 'fddbrzjhm', '法定代表人证件号码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10193', 'YW_L_QYSWDJ', 'djzclx', '登记注册类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10194', 'YW_L_QYSWDJ', 'shjg', '审核结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10195', 'YW_L_QYSWDJ', 'shsj', '审核时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10196', 'YW_L_QYSWDJ', 'shdw', '审核单位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10197', 'YW_L_QYSWDJ', 'qy', '区域', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10198', 'YW_L_QYCBQJ', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10199', 'YW_L_QYCBQJ', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10200', 'YW_L_QYCBQJ', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10201', 'YW_L_QYCBQJ', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10202', 'YW_L_QYCBQJ', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10203', 'YW_L_QYCBQJ', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10204', 'YW_L_QYCBQJ', 'byqjje', '本月欠缴金额（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10205', 'YW_L_QYCBQJ', 'qjny', '欠缴年月', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10206', 'YW_L_QYCBQJ', 'ljqjje', '累计欠缴金额合计（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10207', 'YW_L_QYCBQJ', 'ljqjys', '累计欠缴月数', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10208', 'YW_L_QYCBQJ', 'jbjgqc', '经办机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10209', 'YW_L_QYCBQJ', 'rdrq', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10210', 'YW_L_QYCBQJ', 'sfbj', '是否补缴', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10211', 'YW_L_QYCBQJ', 'sxyzcd', '失信严重程度', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10212', 'YW_L_QYCBQJ', 'sxxwyxq', '失信行为有效期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10213', 'YW_L_QYCBQJ', 'tcqdm', '统筹区代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10214', 'YW_L_QYCBQJ', 'tcqmc', '统筹区名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10215', 'YW_L_QYCBQJ', 'lb', '类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10216', 'YW_L_QYCBQJ', 'dwbm', '单位编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10217', 'YW_L_QYCBQJ', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10218', 'YW_L_QYCBJF', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10219', 'YW_L_QYCBJF', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10220', 'YW_L_QYCBJF', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10221', 'YW_L_QYCBJF', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10222', 'YW_L_QYCBJF', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10223', 'YW_L_QYCBJF', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10224', 'YW_L_QYCBJF', 'jfny', '缴费年月', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10225', 'YW_L_QYCBJF', 'swjfjs', '单位缴费基数', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10226', 'YW_L_QYCBJF', 'grjfjs', '个人缴费基数', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10227', 'YW_L_QYCBJF', 'byyjje', '本月应缴金额合计（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10228', 'YW_L_QYCBJF', 'bysjje', '本月实缴金额合计（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10229', 'YW_L_QYCBJF', 'tcqdm', '统筹区代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10230', 'YW_L_QYCBJF', 'tcqmc', '统筹区名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10231', 'YW_L_QYCBJF', 'cbrs', '参保人数', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10232', 'YW_L_QYCBJF', 'lb', '类别', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10233', 'YW_L_QYCBJF', 'dwbm', '单位编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10234', 'YW_L_QYCB', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10235', 'YW_L_QYCB', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10236', 'YW_L_QYCB', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10237', 'YW_L_QYCB', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10238', 'YW_L_QYCB', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10239', 'YW_L_QYCB', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10240', 'YW_L_QYCB', 'shbxdjzbh', '社会保险登记证编号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10241', 'YW_L_QYCB', 'dwcbjfzt', '单位参保缴费状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10242', 'YW_L_QYCB', 'cbqsrq', '参保起始日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10243', 'YW_L_QYCB', 'jbjgdm', '经办机关代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10244', 'YW_L_QYCB', 'jbjgmc', '经办机关名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10245', 'YW_L_QYCB', 'dwbm', '单位编码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10246', 'YW_L_QYBZRY', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10247', 'YW_L_QYBZRY', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10248', 'YW_L_QYBZRY', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10249', 'YW_L_QYBZRY', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10250', 'YW_L_QYBZRY', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10251', 'YW_L_QYBZRY', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10252', 'YW_L_QYBZRY', 'bzwjh', '表彰文件号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10253', 'YW_L_QYBZRY', 'bzmc', '表彰名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10254', 'YW_L_QYBZRY', 'rydj', '荣誉等级', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10255', 'YW_L_QYBZRY', 'rynr', '荣誉内容', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10256', 'YW_L_QYBZRY', 'rdjgqc', '认定机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10257', 'YW_L_QYBZRY', 'rdrq', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10258', 'YW_L_QYBZRY', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10259', 'YW_L_QS', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10260', 'YW_L_QS', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10261', 'YW_L_QS', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10262', 'YW_L_QS', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10263', 'YW_L_QS', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10264', 'YW_L_QS', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10265', 'YW_L_QS', 'qsszdm', '欠税税种代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10266', 'YW_L_QS', 'qsszmc', '欠税税种名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10267', 'YW_L_QS', 'zjjgqc', '征缴机关全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10268', 'YW_L_QS', 'dqqsje', '当期欠税金额（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10269', 'YW_L_QS', 'ljqsje', '累计欠税金额合计', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10270', 'YW_L_QS', 'qsksrq', '欠税开始日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10271', 'YW_L_QS', 'qsjzrq', '欠税截止日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10272', 'YW_L_QS', 'nsrsbh', '纳税人识别号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10273', 'YW_L_QS', 'fddbrmc', '法定代表人名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10274', 'YW_L_QS', 'fddbrzjlx', '法定代表人证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10275', 'YW_L_QS', 'fddbrzjhm', '法定代表人证件号码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10276', 'YW_L_QS', 'djzclx', '登记注册类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10277', 'YW_L_QS', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10278', 'YW_L_QJF', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10279', 'YW_L_QJF', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10280', 'YW_L_QJF', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10281', 'YW_L_QJF', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10282', 'YW_L_QJF', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10283', 'YW_L_QJF', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10284', 'YW_L_QJF', 'qjlxmc', '欠缴类型名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10285', 'YW_L_QJF', 'qfsd', '欠费时段', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10286', 'YW_L_QJF', 'qfje', '欠费金额（元）', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10287', 'YW_L_QJF', 'qfjsrq', '欠费开始日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10288', 'YW_L_QJF', 'qfjzrq', '欠费截止日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10289', 'YW_L_QJF', 'qfl', '欠费量', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10290', 'YW_L_QJF', 'rdbmqc', '认定部门全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10291', 'YW_L_QJF', 'rdrq', '认定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10292', 'YW_L_QJF', 'jhdwqc', '交换单位全称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10293', 'YW_L_DSJSGG', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10294', 'YW_L_DSJSGG', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10295', 'YW_L_DSJSGG', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10296', 'YW_L_DSJSGG', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10297', 'YW_L_DSJSGG', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10298', 'YW_L_DSJSGG', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10299', 'YW_L_DSJSGG', 'xm', '姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10300', 'YW_L_DSJSGG', 'zjlx', '证件类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10301', 'YW_L_DSJSGG', 'zjhm', '证件号码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10302', 'YW_L_DSJSGG', 'zwlx', '职务类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10303', 'YW_L_DSJSGG', 'gj', '国籍', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10304', 'YW_L_DSJSGG', 'bghzrq', '（变更）核准日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10305', 'YW_L_FRHYPD', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10306', 'YW_L_FRHYPD', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10307', 'YW_L_FRHYPD', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10308', 'YW_L_FRHYPD', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10309', 'YW_L_FRHYPD', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10310', 'YW_L_FRHYPD', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10311', 'YW_L_FRHYPD', 'pdmc', '评定名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10312', 'YW_L_FRHYPD', 'pdjg', '评定结果', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10313', 'YW_L_FRHYPD', 'pdjgmc', '评定机关名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10314', 'YW_L_FRHYPD', 'pdrq', '评定日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10315', 'YW_L_FYPJ', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10316', 'YW_L_FYPJ', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10317', 'YW_L_FYPJ', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10318', 'YW_L_FYPJ', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10319', 'YW_L_FYPJ', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10320', 'YW_L_FYPJ', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10321', 'YW_L_FYPJ', 'ah', '案号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10322', 'YW_L_FYPJ', 'bzxrmc', '被执行人名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10323', 'YW_L_FYPJ', 'zxbd', '执行标的', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10324', 'YW_L_FYPJ', 'ajzt', '案件状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10325', 'YW_L_FYPJ', 'lasj', '立案时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10326', 'YW_L_FYPJ', 'zxfy', '执行法院', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10327', 'YW_L_FYZX', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10328', 'YW_L_FYZX', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10329', 'YW_L_FYZX', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10330', 'YW_L_FYZX', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10331', 'YW_L_FYZX', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10332', 'YW_L_FYZX', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10333', 'YW_L_FYZX', 'ah', '案号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10334', 'YW_L_FYZX', 'ay', '案由', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10335', 'YW_L_FYZX', 'ssdw', '诉讼地位', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10336', 'YW_L_FYZX', 'slfy', '受理法院', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10337', 'YW_L_FYZX', 'lasj', '立案时间', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10338', 'YW_L_FYZX', 'labd', '立案标的', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10339', 'YW_L_FYZX', 'zxyjwh', '执行依据文号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10340', 'YW_L_FYZX', 'jarq', '结案日期', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10341', 'YW_L_FYZX', 'jafs', '结案方式', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10342', 'YW_L_FZCHRD', 'zzjgdm', '组织机构代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10343', 'YW_L_FZCHRD', 'jgqcyw', '机构全称英文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10344', 'YW_L_FZCHRD', 'jgqc', '机构全称中文', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10345', 'YW_L_FZCHRD', 'gszch', '工商注册号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10346', 'YW_L_FZCHRD', 'tyshxydm', '统一社会信用代码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10347', 'YW_L_FZCHRD', 'bz', '备注', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10348', 'YW_L_FZCHRD', 'swglm', '税务管理码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10349', 'YW_L_FZCHRD', 'nsrsbh', '纳税人识别号', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10350', 'YW_L_FZCHRD', 'nsrmc', '纳税人名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10351', 'YW_L_FZCHRD', 'nsrzt', '纳税人状态', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10352', 'YW_L_FZCHRD', 'fddbrxm', '法定代表人姓名', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10353', 'YW_L_FZCHRD', 'fddbrzjlx', '法定代表人证件名称', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10354', 'YW_L_FZCHRD', 'fddbrzjhm', '法定代表人证件号码', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10355', 'YW_L_FZCHRD', 'djzclx', '登记注册类型', null);

insert into dz_yw_table_column (ID, TABLE_CODE, COLUMN_NAME, COLUMN_ALIAS, DISPLAY_ORDER)
values ('10356', 'YW_L_FZCHRD', 'zcdz', '注册地址', null);

commit;


-----------------------------------------政务端数据质量分析begin------------------------------------------
--菜单
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ba5d5e6a02015d5e7705990051', '402894ba5d5e6a02015d5e7705990004', '数据质量统计', 'dataQuality/dataQuality.action', 'fa fa-circle-o', 40102);

--权限
insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ba5d5e6a02015d5e7a7a900009', '402894ba5d5e6a02015d5e7705990051', 'statisAnalyze.dataQuality', '查看数据质量统计分析', null, null, null, null, null);

--角色权限表
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ba5d5e6a02015d5e7a7a900009');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ba5d5e6a02015d5e7a7a900009');

-----------------------------------------政务端数据质量分析end--------------------------------------------
commit;

-- Create table
create table DP_DATA_REPORT_FORGET
(
  id              VARCHAR2(50) not null,
  logic_table_id  VARCHAR2(50),
  dept_id         VARCHAR2(50),
  task_begin_date DATE,
  task_end_date   DATE,
  create_date     DATE
);
-- Add comments to the table 
comment on table DP_DATA_REPORT_FORGET
  is '数据上报漏报信息(各部门的各目录每个周期只会有一次漏报，漏报一次产生一条记录)';
-- Add comments to the columns 
comment on column DP_DATA_REPORT_FORGET.id
  is '主键';
comment on column DP_DATA_REPORT_FORGET.logic_table_id
  is '目录id（DP_LOGIC_TABLE表主键）';
comment on column DP_DATA_REPORT_FORGET.dept_id
  is '部门id';
comment on column DP_DATA_REPORT_FORGET.task_begin_date
  is '漏报批次开始时间';
comment on column DP_DATA_REPORT_FORGET.task_end_date
  is '漏报批次结束时间';
comment on column DP_DATA_REPORT_FORGET.create_date
  is '创建时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table DP_DATA_REPORT_FORGET
  add constraint PK_DP_DATA_REPORT_FORGET primary key (ID);
  

-- 法人业务表索引
Create index INX_YW_L_FRHYPD_RWBH on YW_L_FRHYPD(RWBH);
Create index INX_YW_L_FYZX_RWBH on YW_L_FYZX(RWBH);
Create index INX_YW_L_QS_RWBH on YW_L_QS(RWBH);
Create index INX_YW_L_QYCB_RWBH on YW_L_QYCB(RWBH);
Create index INX_YW_L_QYCBQJ_RWBH on YW_L_QYCBQJ(RWBH);
Create index INX_YW_L_QYSWDJ_RWBH on YW_L_QYSWDJ(RWBH);
Create index INX_YW_L_XZXKDJBG_RWBH on YW_L_XZXKDJBG(RWBH);
Create index INX_YW_L_FZJGBAXX_RWBH on YW_L_FZJGBAXX(RWBH);
Create index INX_YW_L_HEIMINGDAN_RWBH on YW_L_HEIMINGDAN(RWBH);
Create index INX_YW_L_DSJSGG_RWBH on YW_L_DSJSGG(RWBH);
Create index INX_YW_L_FYPJ_RWBH on YW_L_FYPJ(RWBH);
Create index INX_YW_L_JGBGINFO_RWBH on YW_L_JGBGINFO(RWBH);
Create index INX_YW_L_XZCF_RWBH on YW_L_XZCF(RWBH);
Create index INX_YW_L_DJGBGJILU_RWBH on YW_L_DJGBGJILU(RWBH);
Create index INX_YW_L_FRLXFL_RWBH on YW_L_FRLXFL(RWBH);
Create index INX_YW_L_QYXYGBXX_RWBH on YW_L_QYXYGBXX(RWBH);
Create index INX_YW_L_HONGMINGDAN_RWBH on YW_L_HONGMINGDAN(RWBH);
Create index INX_YW_L_ZZZCDX_RWBH on YW_L_ZZZCDX(RWBH);
Create index INX_YW_L_FZCHRD_RWBH on YW_L_FZCHRD(RWBH);
Create index INX_YW_L_ZZDJBG_RWBH on YW_L_ZZDJBG(RWBH);
Create index INX_YW_L_GD_RWBH on YW_L_GD(RWBH);
Create index INX_YW_L_JGBGJILU_RWBH on YW_L_JGBGJILU(RWBH);
Create index INX_YW_L_JGSLBGDJ_RWBH on YW_L_JGSLBGDJ(RWBH);
Create index INX_YW_L_QYBZRY_RWBH on YW_L_QYBZRY(RWBH);
Create index INX_YW_L_QYCBJF_RWBH on YW_L_QYCBJF(RWBH);
Create index INX_YW_L_SJSFQYXX_RWBH on YW_L_SJSFQYXX(RWBH);
Create index INX_YW_L_GDBGJILU_RWBH on YW_L_GDBGJILU(RWBH);
Create index INX_YW_L_QJF_RWBH on YW_L_QJF(RWBH);
Create index INX_YW_L_XKZZNJ_RWBH on YW_L_XKZZNJ(RWBH);
Create index INX_YW_L_XZXKZCDX_RWBH on YW_L_XZXKZCDX(RWBH);

--自然人业务表索引

Create index INX_YW_P_GRJYZK_RWBH on YW_P_GRJYZK(RWBH);
Create index INX_YW_P_GRSGSXZCF_RWBH on YW_P_GRSGSXZCF(RWBH);
Create index INX_YW_P_GRSQJZRYXX_RWBH on YW_P_GRSQJZRYXX(RWBH);
Create index INX_YW_P_GRXIANXIE_RWBH on YW_P_GRXIANXIE(RWBH);
Create index INX_YW_P_GRXZCF_RWBH on YW_P_GRXZCF(RWBH);
Create index INX_YW_P_GRYLBXZT_RWBH on YW_P_GRYLBXZT(RWBH);
Create index INX_YW_P_GRZYZFW_RWBH on YW_P_GRZYZFW(RWBH);
Create index INX_YW_P_GRHONGMINGDAN_RWBH on YW_P_GRHONGMINGDAN(RWBH);
Create index INX_YW_P_GRJBXX_RWBH on YW_P_GRJBXX(RWBH);
Create index INX_YW_P_GRQS_RWBH on YW_P_GRQS(RWBH);
Create index INX_YW_P_GRRYXX_RWBH on YW_P_GRRYXX(RWBH);
Create index INX_YW_P_GRSYWY_RWBH on YW_P_GRSYWY(RWBH);
Create index INX_YW_P_GRXYPJ_RWBH on YW_P_GRXYPJ(RWBH);
Create index INX_YW_P_GRZYFWSC_RWBH on YW_P_GRZYFWSC(RWBH);
Create index INX_YW_P_GRCL_RWBH on YW_P_GRCL(RWBH);
Create index INX_YW_P_GRDB_RWBH on YW_P_GRDB(RWBH);
Create index INX_YW_P_GRJTSX_RWBH on YW_P_GRJTSX(RWBH);
Create index INX_YW_P_GRQTBLXX_RWBH on YW_P_GRQTBLXX(RWBH);
Create index INX_YW_P_GRXZXK_RWBH on YW_P_GRXZXK(RWBH);
Create index INX_YW_P_GRCYZG_RWBH on YW_P_GRCYZG(RWBH);
Create index INX_YW_P_GRSGSXZXK_RWBH on YW_P_GRSGSXZXK(RWBH);
Create index INX_YW_P_GRZGZC_RWBH on YW_P_GRZGZC(RWBH);
Create index INX_YW_P_GRZYJSZG_RWBH on YW_P_GRZYJSZG(RWBH);
Create index INX_YW_P_GRBZDJXX_RWBH on YW_P_GRBZDJXX(RWBH);
Create index INX_YW_P_GRFYQZZX_RWBH on YW_P_GRFYQZZX(RWBH);
Create index INX_YW_P_GRGZ_RWBH on YW_P_GRGZ(RWBH);
Create index INX_YW_P_GRHEIMINGDAN_RWBH on YW_P_GRHEIMINGDAN(RWBH);
Create index INX_YW_P_GRSFBD_RWBH on YW_P_GRSFBD(RWBH);
Create index INX_YW_P_GRXL_RWBH on YW_P_GRXL(RWBH);
Create index INX_YW_P_GRZGZCX_RWBH on YW_P_GRZGZCX(RWBH);
Create index INX_YW_P_GRZYHZXX_RWBH on YW_P_GRZYHZXX(RWBH);
Create index INX_YW_P_GRDBJTCYXX_RWBH on YW_P_GRDBJTCYXX(RWBH);
Create index INX_YW_P_GRHYDJ_RWBH on YW_P_GRHYDJ(RWBH);
Create index INX_YW_P_GRXHFZAJ_RWBH on YW_P_GRXHFZAJ(RWBH);
Create index INX_YW_P_GRZYZYZG_RWBH on YW_P_GRZYZYZG(RWBH);
Create index INX_YW_P_GRDBJTXX_RWBH on YW_P_GRDBJTXX(RWBH);
Create index INX_YW_P_GRETJZYM_RWBH on YW_P_GRETJZYM(RWBH);
Create index INX_YW_P_GRJSZXX_RWBH on YW_P_GRJSZXX(RWBH);
Create index INX_YW_P_GRNS_RWBH on YW_P_GRNS(RWBH);
Create index INX_YW_P_GRPJ_RWBH on YW_P_GRPJ(RWBH);

--本存储过程统计各部门各目录的漏报记录，记录下漏报的部门和其目录，以及漏报的征集周期的开始结束时间
create or replace procedure P_DP_DATA_REPORT_FORGET is

  -- 游标(主要计算出各部门各目录上个征集周期的开始结束时间)
  CURSOR temp_list IS
    select a.id,
           a.code,
           a.name,
           a.task_period,
           a.days,
           c.dept_id,
           c.create_time,
           case a.task_period
             when '0' then
              trunc(sysdate, 'd') - 6
             when '1' then
              add_months(trunc(sysdate, 'mm'), -1)
             when '2' then
              add_months(Trunc(SYSDATE, 'Q'), -3)
             when '3' then
              (case
                when sysdate < add_months(trunc(sysdate, 'yyyy'), 6) then
                 add_months(trunc(sysdate, 'yyyy'), -6)
                else
                 trunc(sysdate, 'yyyy')
              end)
             when '4' then
              add_months(trunc(sysdate, 'yyyy'), -12)
             else
              null
           end as begintime,
           case a.task_period
             when '0' then
              trunc(sysdate, 'd')
             when '1' then
              trunc(sysdate, 'mm') - 1
             when '2' then
              Trunc(SYSDATE, 'Q') - 1
             when '3' then
              (case
                when sysdate < add_months(trunc(sysdate, 'yyyy'), 6) then
                 trunc(sysdate, 'yyyy') - 1
                else
                 add_months(trunc(sysdate, 'yyyy'), 6) - 1
              end)
             when '4' then
              trunc(sysdate, 'yyyy') - 1
             else
              null
           end as realEndtime
      from dp_logic_table a
      join dp_logic_table_dept c
        on a.id = c.logic_table_id
     where a.status = '1'
       and exists (select *
              from dp_logic_column dpc
             where a.id = dpc.logic_table_id);

  CURCOUNT number;

begin

  for line in temp_list loop
    CURCOUNT := 0;
  
    -- line.create_time <= line.realendtime，如果部门分配到目录的时间在上个征集周期内时，才统计上个周期内的漏报次数，反之不用统计
    if (line.create_time <= line.realendtime) then
    
      --查询上个征集周期内存在的上报记录次数
      select count(*)
        into CURCOUNT
        from dp_data_report_log t
       where t.create_date between line.begintime and line.realendtime
         and t.logic_table_id = line.id
         and t.dept_id = line.dept_id;
    
      --如果在目录的上个征集周期内不存在上报记录，则作为漏报处理，记录漏报信息
      if (CURCOUNT = 0) then
      
        -- 查询漏报记录表中是否已存在同周期内相同部门的相同目录，如果有就不在重复记录
        select count(*)
          into CURCOUNT
          from dp_data_report_forget t
         where t.logic_table_id = line.id
           and t.dept_id = line.dept_id
           and t.task_begin_date = line.begintime
           and t.task_end_date = line.realendtime;
      
        if (CURCOUNT = 0) then
          -- 记录漏报信息
          insert into dp_data_report_forget
            (id,
             logic_table_id,
             dept_id,
             task_begin_date,
             task_end_date,
             create_date)
          values
            (sys_guid(),
             line.id,
             line.dept_id,
             line.begintime,
             line.realendtime,
             sysdate);
        
          commit;
        end if;
      end if;
    end if;
  
  end loop;

end P_DP_DATA_REPORT_FORGET;
/

--添加定时任务，记录漏报的部门和目录的周期信息，执行频率每周一的1点
begin
  sys.dbms_scheduler.create_job(job_name        => 'p_dp_data_report_forget_job',
                                job_type        => 'STORED_PROCEDURE',
                                job_action      => 'p_dp_data_report_forget',
                                start_date      => sysdate,
                                repeat_interval => 'Freq=Weekly;Interval=1;ByHour=1;ByDay=MON;',
                                end_date        => to_date(null),
                                job_class       => 'DEFAULT_JOB_CLASS',
                                enabled         => true,
                                auto_drop       => false,
                                comments        => '记录漏报的部门和目录的周期信息');
end;
/

--上报时效统计菜单及权限
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('4028946a603517960160351edbe20008', '2c90c281588489c00158858932fa0071', '上报时效统计', 'dp/timeliness/centerIndex.action', 'fa fa-circle-o', 320015);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('4028946a603517960160351ba6080003', '402894ba5d5e6a02015d5e7705990004', '上报时效统计', 'dp/timeliness/govIndex.action', 'fa fa-circle-o', 40105);
commit;

insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('4028946a603517960160351fa3a3000b', '4028946a603517960160351ba6080003', 'statisAnalyze.timeliness', '查看上报时效性统计', null, null, null, null, null);

insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('4028946a6035179601603520fbb2000e', '4028946a603517960160351edbe20008', 'center.statisAnalyze.timeliness', '中心-查看上报时效性统计', null, null, null, null, null);
commit;

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '4028946a603517960160351fa3a3000b');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '4028946a6035179601603520fbb2000e');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '4028946a603517960160351fa3a3000b');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '4028946a6035179601603520fbb2000e');
commit;

 create public database link dbl_ysk  
        connect to credit_ysk identified by credit_ysk 
        using '(DESCRIPTION =  
                    (ADDRESS_LIST =  
                    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.0.31 

)(PORT = 1522))  
                    )  
                    (CONNECT_DATA =  
                        (SERVICE_NAME = citgcdev.citgc.com)  
                    )  
                )';  
                 
drop procedure p_dp_process_result_calc;
create or replace procedure p_dp_process_result_calc is
  --处理数据清洗完成后各个类型的数据量，然后记录到dp_process_result表中，供统计分析查询使用
  --有效量：  etl_type=1 and type=1  业务库表中的rwbh字段为关联条件，计算count
  --未关联量：etl_type=1 and type=4  业务库表中的rwbh字段关联条件，计算jgdj_id is null的count
  --疑问量:etl_type=0 and type=2  DP_SUMMARY_INVALID_DATA表中的logic_table_id，task_code未关联条件，计算count
  --更新量：  etl_type=0 and type=3  dp_data_size的总量-dp_data_size疑问数据量-业务库有效量

  --为了提高执行效率可以增加一些索引：
  --1、业务库所有YW_开头的表，对字段 RWBH 加索引
  --2、业务库dp_data_size表，对字段 logic_table_id和task_code加联合索引，不过此表数据量应该比较小，不加也可以，影响不大
  --PS:加了索引插入更新速度会相应变慢，可酌情处理

  -- 游标
  CURSOR handle_list IS
    select UPPER(a.table_code) table_code,
           UPPER(a.yw_table_name) yw_table_name,
           c.task_code,
           c.logic_table_id,
           c.dept_id
      from dp_ysyw_relation a
      join dp_logic_table b
        on UPPER(a.table_code) = UPPER(b.code)
      join dp_data_report_log c
        on b.id = c.logic_table_id;

  YOUXIAO_COUNT number; --有效量
  WGL_COUNT     number; --未关联量
  GENXIN_COUNT  number; --更新量
  FAIL_COUNT    number; --疑问数据量
  ALL_COUNT     number; --总量
  v_sql         varchar2(32767); --用于存放SQL的变量

  INDEX_COUNT number; --循环索引
  END_COUNT   number; --kettle执行有效到业务后，dp_process_procedure_log结束时间不为空的数量
  CREATE_TIME  varchar2(50); --创建时间，取业务库时间

begin

  INDEX_COUNT := 0;
  --删除旧数据
  delete from dp_process_result;
    --处理本kettle处理结束但是结束时间为空的批次
   update dp_process_procedure_log a set end_time=sysdate
   where  a.deal_type = '3'
   and a.end_time is  null;

  for line in handle_list loop

    INDEX_COUNT := INDEX_COUNT + 1;
    
    CREATE_TIME:='';
     v_sql := 'select min(create_time)  from ' || line.yw_table_name ||
             ' yw where yw.RWBH = ''' || line.task_code || '''';

    execute immediate v_sql
      into CREATE_TIME;
      
    if CREATE_TIME  is null  then 
       v_sql := 'select min(create_time)  from jc_' || line.table_code ||
             '@dbl_ysk ys where ys.task_code = ''' || line.task_code || '''';

    execute immediate v_sql
      into CREATE_TIME;
      end if ;

    /*---------------计算有效量并记录----------------*/
    YOUXIAO_COUNT := 0;
    --查询数据量（全量的）
    v_sql := 'select count(*)  from ' || line.yw_table_name ||
             ' yw where yw.RWBH = ''' || line.task_code || '''';

    execute immediate v_sql
      into YOUXIAO_COUNT;

    IF YOUXIAO_COUNT > 0 THEN
      --插入新数据
      insert into dp_process_result
        (type,
         process_size,
         process_time,
         table_code,
         etl_type,
         task_code,
         dept_id)
      values
        (1,
         YOUXIAO_COUNT,
         CREATE_TIME,
         line.table_code,
         '1',
         line.task_code,
         line.dept_id);
    END IF;

    /*---------------计算未关联量并记录----------------*/
    --YW_L_JGSLBGDJ机构基本信息表不需要统计未关联量,自然人表不统计未关联量
    IF line.yw_table_name != 'YW_L_JGSLBGDJ' and
       SUBSTR(line.yw_table_name, 0, 4) = 'YW_L' THEN

      WGL_COUNT := 0;
      --查询数据量（全量的）
      v_sql := 'select count(*)  from ' || line.yw_table_name ||
               ' yw where yw.RWBH = ''' || line.task_code ||
               ''' and yw.JGDJ_ID is null';
               
      execute immediate v_sql
      into WGL_COUNT;

      IF WGL_COUNT > 0 THEN

      
        --插入新数据
        insert into dp_process_result
          (type,
           process_size,
           process_time,
           table_code,
           etl_type,
           task_code,
           dept_id)
        values
          (4,
           WGL_COUNT,
           CREATE_TIME,
           line.table_code,
           '1',
           line.task_code,
           line.dept_id);
      END IF;
    END IF;

    /*---------------计算更新量并记录----------------*/
    ALL_COUNT  := 0;
    FAIL_COUNT := 0;
    END_COUNT  := 0;

    --查询数据量（全量的）
    select sum(nvl(a.all_size, 0))
      into ALL_COUNT
      from dp_data_size a
     where a.logic_table_id = line.logic_table_id
       and a.task_code = line.task_code;

    select sum(nvl(a.fail_size, 0))
      into FAIL_COUNT
      from dp_data_size a
     where a.logic_table_id = line.logic_table_id
       and a.task_code = line.task_code;

    -- 更新量 = 总量-总疑问量-总有效量
    GENXIN_COUNT := ALL_COUNT - FAIL_COUNT - YOUXIAO_COUNT ;

    select count(*)
      into END_COUNT
      from dp_process_procedure_log a
     where a.task_code = line.task_code
       and a.deal_type = '3'
       and a.end_time is not null;

    -- 如果END_COUNT为0，表示kettle还未执行完成，更新量为0
    IF END_COUNT = 0 THEN
      GENXIN_COUNT := 0;
    END IF;

    IF GENXIN_COUNT > 0 THEN
      --插入新数据
      insert into dp_process_result
        (type,
         process_size,
         process_time,
         table_code,
         etl_type,
         task_code,
         dept_id)
      values
        (3,
         GENXIN_COUNT,
         CREATE_TIME,
         line.table_code,
         '0',
         line.task_code,
         line.dept_id);
    END IF;

    --每500条提交一次事务
    IF mod(INDEX_COUNT, 500) = 0 THEN
      commit;
    END IF;
  end loop;
  -- 提交循环后不能整除的剩余事务
  commit;

end p_dp_process_result_calc;
/


------重新计算 dp_data_size 和 DP_SUMMARY_INVALID_DATA 表中数据
 create or replace procedure p_dp_data_size_calc is
  CURSOR TABLE_LIST IS
    select t.dept_id, t.id, t.code, s.code as dept_code
      from view_version_table_dept t
      join sys_department s
        on t.dept_id = s.sys_department_id
     where 'JC_' || t.code || '_E' in
           (select TABLE_NAME
              from user_tab_columns@dbl_ysk
             where UPPER(TABLE_NAME) LIKE '%_E'
             group by table_name)
     group by t.dept_id, t.id, t.code, s.code;

  v_sql varchar2(32767); --用于存放SQL的变量

BEGIN
  delete from dp_data_size; --删除dp_data_size记录
  delete from DP_SUMMARY_INVALID_DATA; -- 删除DP_SUMMARY_INVALID_DATA记录

  FOR table_row IN TABLE_LIST LOOP

    v_sql := 'insert into dp_data_size (ID, DEPT_ID, LOGIC_TABLE_ID, SUCCESS_SIZE, FAIL_SIZE, ALL_SIZE, TASK_CODE,TABLE_VERSION_ID, CREATE_TIME)
      select sys_guid(),''' || table_row.dept_id || ''',''' ||
             table_row.id || ''',
      sum(case when status<>999 and status <> -3 then 1 else 0 end) as success_size,
      sum(case when status=999 or status=-3 then 1 else 0 end) fail_size,
      count(1) as all_size,
      task_code ,
      TABLE_VERSION_ID,
      min(create_time)as create_time
      from jc_' || table_row.code ||
             '@dbl_ysk where dept_code=''' || table_row.dept_code || '''
      group by task_code,TABLE_VERSION_ID
      ';
    execute immediate v_sql;
    COMMIT;

    v_sql := 'insert into DP_SUMMARY_INVALID_DATA (ID, data_source , status , create_time , invalid_size , dept_id , logic_table_id , task_code,TABLE_VERSION_ID )
      select  sys_guid(),data_sourse,OPERATE_STATUS,min(create_time) as create_time,
      count(1) as invalid_size,
      ''' || table_row.dept_id || ''',
      ''' || table_row.id || ''',
      task_code,TABLE_VERSION_ID
      from jc_' || table_row.code ||
             '_E@dbl_ysk where dept_id=''' || table_row.dept_id || '''
      group by data_sourse,dept_id,task_code,TABLE_VERSION_ID,OPERATE_STATUS
      ';
    execute immediate v_sql;
    COMMIT;

  END LOOP;
  begin
    -- Call the procedure
    p_dp_process_result_calc;
  end;
end p_dp_data_size_calc;

/
--添加定时任务，为防止数据出现不一致，处理完dp_data_size后同时处理dp_process_result表，供统计分析查询使用
begin
  sys.dbms_scheduler.create_job(job_name        => 'p_dp_data_size_calc_job',
                                job_type        => 'STORED_PROCEDURE',
                                job_action      => 'p_dp_data_size_calc',
                                start_date      => sysdate,
                                repeat_interval => 'Freq=Minutely;Interval=30',
                                end_date        => to_date(null),
                                job_class       => 'DEFAULT_JOB_CLASS',
                                enabled         => true,
                                auto_drop       => false,
                                comments        => '处理完dp_data_size后同时处理dp_process_result表，供统计分析查询使用');
end;
/



commit;


--添加疑问数据导入文件待解析表
drop table DP_QRTZ_ERROR_FILE_PARSE;
-- Create table
create table DP_QRTZ_ERROR_FILE_PARSE
(
  id                        VARCHAR2(50) not null,
  task_code                 VARCHAR2(50),
  task_name                 VARCHAR2(250) not null,
  file_path                 VARCHAR2(250) not null,
  table_code                VARCHAR2(50) not null,
  dept_code                 VARCHAR2(50) not null,
  login_table_id            VARCHAR2(50) not null,
  table_column_code         VARCHAR2(4000) not null,
  create_time               DATE not null,
  create_user               VARCHAR2(50),
  file_name                 VARCHAR2(250) not null,
  dept_name                 VARCHAR2(250),
  status                    INTEGER default 0,
  parse_time_start          DATE,
  parse_time_end            DATE,
  parse_cnt_success         INTEGER default 0,
  parse_cnt_fail            INTEGER default 0,
  file_storage_host_name    VARCHAR2(2000),
  file_storage_host_address VARCHAR2(2000),
  file_parse_host_name      VARCHAR2(2000),
  file_parse_host_address   VARCHAR2(2000)
);
-- Add comments to the table 
comment on table DP_QRTZ_ERROR_FILE_PARSE
  is '数据上报文件定时解析表';
-- Add comments to the columns 
comment on column DP_QRTZ_ERROR_FILE_PARSE.id
  is '主键';
comment on column DP_QRTZ_ERROR_FILE_PARSE.task_code
  is '任务编号';
comment on column DP_QRTZ_ERROR_FILE_PARSE.task_name
  is '任务名称（也是表名的注释）';
comment on column DP_QRTZ_ERROR_FILE_PARSE.file_path
  is '要解析的文件路径';
comment on column DP_QRTZ_ERROR_FILE_PARSE.table_code
  is '表名编码';
comment on column DP_QRTZ_ERROR_FILE_PARSE.dept_code
  is '部门编码';
comment on column DP_QRTZ_ERROR_FILE_PARSE.login_table_id
  is '外键（关联DP_LOGIN_TABLE主键id）';
comment on column DP_QRTZ_ERROR_FILE_PARSE.table_column_code
  is '表字段编码（多个之间用逗号隔开）';
comment on column DP_QRTZ_ERROR_FILE_PARSE.create_time
  is '创建时间';
comment on column DP_QRTZ_ERROR_FILE_PARSE.create_user
  is '创建人id';
comment on column DP_QRTZ_ERROR_FILE_PARSE.file_name
  is '原始文件名';
comment on column DP_QRTZ_ERROR_FILE_PARSE.dept_name
  is '部门名称';
comment on column DP_QRTZ_ERROR_FILE_PARSE.status
  is '0：待解析，1：解析中，2：解析成功，3：解析失败，4：文件不存在';
comment on column DP_QRTZ_ERROR_FILE_PARSE.parse_time_start
  is '解析开始时间';
comment on column DP_QRTZ_ERROR_FILE_PARSE.parse_time_end
  is '解析结束时间';
comment on column DP_QRTZ_ERROR_FILE_PARSE.parse_cnt_success
  is '解析成功数据量';
comment on column DP_QRTZ_ERROR_FILE_PARSE.parse_cnt_fail
  is '解析失败数据量';
comment on column DP_QRTZ_ERROR_FILE_PARSE.file_storage_host_name
  is '文件存放主机名称';
comment on column DP_QRTZ_ERROR_FILE_PARSE.file_storage_host_address
  is '文件存放主机地址';
comment on column DP_QRTZ_ERROR_FILE_PARSE.file_parse_host_name
  is '文件解析主机名称';
comment on column DP_QRTZ_ERROR_FILE_PARSE.file_parse_host_address
  is '文件解析主机地址';
-- Create/Recreate primary, unique and foreign key constraints 
alter table DP_QRTZ_ERROR_FILE_PARSE
  add constraint PK_DP_QRTZ_ERROR_FILE_PARSE primary key (ID)
  using index;





-------------------新增数据目录的版本控制相关表-----begin-----------------------------
alter table DP_TABLE_VERSION
   drop unique (VERSION) cascade;

alter table DP_TABLE_VERSION
   drop primary key cascade;

drop table DP_TABLE_VERSION cascade constraints;

/*==============================================================*/
/* Table: DP_TABLE_VERSION                                      */
/*==============================================================*/
create table DP_TABLE_VERSION
(
   ID                   VARCHAR2(50)         not null,
   VERSION              VARCHAR2(250)        not null,
   DESCRIPTION          VARCHAR2(2000),
   STATUS               VARCHAR2(2)          default '1' not null,
   CREATE_TIME          DATE                 not null,
   UPDATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   UPDATE_USER          VARCHAR2(50)
);

comment on table DP_TABLE_VERSION is
'数据目录版本';

comment on column DP_TABLE_VERSION.ID is
'主键';

comment on column DP_TABLE_VERSION.VERSION is
'版本号';

comment on column DP_TABLE_VERSION.DESCRIPTION is
'描述';

comment on column DP_TABLE_VERSION.STATUS is
'启用状态(0未启用 1已启用)';

comment on column DP_TABLE_VERSION.CREATE_TIME is
'创建时间';

comment on column DP_TABLE_VERSION.UPDATE_TIME is
'更新时间';

comment on column DP_TABLE_VERSION.CREATE_USER is
'创建人';

comment on column DP_TABLE_VERSION.UPDATE_USER is
'更新人';

alter table DP_TABLE_VERSION
   add constraint PK_DP_TABLE_VERSION primary key (ID);

alter table DP_TABLE_VERSION
   add constraint AK_WY_DP_TABLE unique (VERSION);
alter table DP_CLASSIFY_VERSION_CONFIG
   drop primary key cascade;

drop table DP_CLASSIFY_VERSION_CONFIG cascade constraints;

/*==============================================================*/
/* Table: DP_CLASSIFY_VERSION_CONFIG                            */
/*==============================================================*/
create table DP_CLASSIFY_VERSION_CONFIG
(
   ID                   VARCHAR2(50)         not null,
   LOGIC_CLASSIFY_ID    VARCHAR2(50)         not null,
   TABLE_VERSION_ID     VARCHAR2(50)         not null,
   CREATE_USER          VARCHAR2(50),
   CREATE_TIME          DATE,
   UPDATE_USER          VARCHAR2(50),
   UPDATE_TIME          DATE
);

comment on table DP_CLASSIFY_VERSION_CONFIG is
'数据目录分类版本配置';

comment on column DP_CLASSIFY_VERSION_CONFIG.ID is
'主键';

comment on column DP_CLASSIFY_VERSION_CONFIG.LOGIC_CLASSIFY_ID is
'数据分类ID（外键DP_LOGIC_CLASSIFY的id）';

comment on column DP_CLASSIFY_VERSION_CONFIG.TABLE_VERSION_ID is
'外键（DP_TABLE_VERSION表主键）';

comment on column DP_CLASSIFY_VERSION_CONFIG.CREATE_USER is
'创建人';

comment on column DP_CLASSIFY_VERSION_CONFIG.CREATE_TIME is
'创建时间';

comment on column DP_CLASSIFY_VERSION_CONFIG.UPDATE_USER is
'更新人id';

comment on column DP_CLASSIFY_VERSION_CONFIG.UPDATE_TIME is
'更新时间';

alter table DP_CLASSIFY_VERSION_CONFIG
   add constraint PK_DP_CLASSIFY_VERSION_CONFIG primary key (ID);
alter table DP_TABLE_VERSION_CONFIG
   drop primary key cascade;

drop table DP_TABLE_VERSION_CONFIG cascade constraints;

/*==============================================================*/
/* Table: DP_TABLE_VERSION_CONFIG                               */
/*==============================================================*/
create table DP_TABLE_VERSION_CONFIG
(
   ID                   VARCHAR2(50)         not null,
   LOGIC_TABLE_ID       VARCHAR2(50)         not null,
   TABLE_VERSION_ID     VARCHAR2(50)         not null,
   IS_CHECK_DATE        VARCHAR2(2)          default '0' not null,
   IS_CHECK_REPEAT      VARCHAR2(2)          default '0' not null,
   BEGIN_DATE_CODE      VARCHAR2(50),
   END_DATE_CODE        VARCHAR2(50),
   REPEAT_CODES         VARCHAR2(500),
   CREATE_TIME          DATE                 not null,
   UPDATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   UPDATE_USER          VARCHAR2(50)
);

comment on table DP_TABLE_VERSION_CONFIG is
'数据目录版本配置';

comment on column DP_TABLE_VERSION_CONFIG.ID is
'主键';

comment on column DP_TABLE_VERSION_CONFIG.LOGIC_TABLE_ID is
'外键（DP_LOGIC_TABLE表主键）';

comment on column DP_TABLE_VERSION_CONFIG.TABLE_VERSION_ID is
'外键（DP_TABLE_VERSION表主键）';

comment on column DP_TABLE_VERSION_CONFIG.IS_CHECK_DATE is
'是否校验日期（0否 ，1是）';

comment on column DP_TABLE_VERSION_CONFIG.IS_CHECK_REPEAT is
'是否校验重复（0否，1是）';

comment on column DP_TABLE_VERSION_CONFIG.BEGIN_DATE_CODE is
'待校验的起始日期字段编码';

comment on column DP_TABLE_VERSION_CONFIG.END_DATE_CODE is
'待校验的结束日期字段编码';

comment on column DP_TABLE_VERSION_CONFIG.REPEAT_CODES is
'用来校验数据是否重复的字段编码集，字段编码使用;分号隔开';

comment on column DP_TABLE_VERSION_CONFIG.CREATE_TIME is
'创建时间';

comment on column DP_TABLE_VERSION_CONFIG.UPDATE_TIME is
'更新时间';

comment on column DP_TABLE_VERSION_CONFIG.CREATE_USER is
'创建人';

comment on column DP_TABLE_VERSION_CONFIG.UPDATE_USER is
'更新人';

alter table DP_TABLE_VERSION_CONFIG
   add constraint PK_DP_TABLE_VERSION_CONFIG primary key (ID);
alter table DP_COLUMN_VERSION_CONFIG
   drop primary key cascade;

drop table DP_COLUMN_VERSION_CONFIG cascade constraints;

/*==============================================================*/
/* Table: DP_COLUMN_VERSION_CONFIG                              */
/*==============================================================*/
create table DP_COLUMN_VERSION_CONFIG
(
   ID                   VARCHAR2(50)         not null,
   TABLE_VERSION_CONFIG_ID VARCHAR2(50)         not null,
   LOGIC_COLUMN_ID      VARCHAR2(50)         not null,
   IS_NULLABLE          VARCHAR2(2)          default '1',
   REQUIRED_GROUP       VARCHAR2(200),
   POSTIL               VARCHAR2(400),
   FIELD_SORT           NUMBER(5)
);

comment on table DP_COLUMN_VERSION_CONFIG is
'数据目录列信息版本配置';

comment on column DP_COLUMN_VERSION_CONFIG.ID is
'主键';

comment on column DP_COLUMN_VERSION_CONFIG.TABLE_VERSION_CONFIG_ID is
'外键（DP_TABLE_VERSION_CONFIG表主键）';

comment on column DP_COLUMN_VERSION_CONFIG.LOGIC_COLUMN_ID is
'外键（DP_LOGIC_COLUMN表主键）';

comment on column DP_COLUMN_VERSION_CONFIG.IS_NULLABLE is
'是否允许为空（0否，1允许）';

comment on column DP_COLUMN_VERSION_CONFIG.REQUIRED_GROUP is
'组（多选一）';

comment on column DP_COLUMN_VERSION_CONFIG.POSTIL is
'批注';

comment on column DP_COLUMN_VERSION_CONFIG.FIELD_SORT is
'排序';

alter table DP_COLUMN_VERSION_CONFIG
   add constraint PK_DP_COLUMN_VERSION_CONFIG primary key (ID);

-------------------新增数据目录的版本控制相关表------end----------------------------=======
------版本——表——部门关系视图
create or replace view view_version_table_dept as
(
 select lt.ID,
        lt.ID                logic_table_id,
        lt.CODE,
        lt.NAME,
        lt.CREATE_ID,
        lt.CREATE_TIME,
        lt.UPDATE_ID,
        lt.UPDATE_TIME,
        ltd.DEPT_ID,
        lt.DS_TYPE,
        lt.STATUS,
        lt.MAPPED_CODE,
        lt.TASK_PERIOD,
        lt.DATA_CATEGORY,
        lt.DAYS,
        lt.TABLE_DESC,
        lt.LOGIC_CLASSIFY_ID,
        lt.TABLE_SORT,
        lt.TEMPLATE_ID,
        lt.PERSON_TYPE,
        tvc.id               table_version_config_id,
        tv.id table_version_id,
        tv.version
   from DP_TABLE_VERSION_CONFIG tvc
   join DP_TABLE_VERSION tv
     on tv.id = tvc.table_version_id
   join DP_LOGIC_TABLE lt
     on tvc.logic_table_id = lt.id
   join DP_LOGIC_TABLE_DEPT ltd
     on tvc.id = ltd.table_version_config_id
);
--归集信息配置菜单脚本
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894b86729921901672b6297ad0094', '2c90c281587574200158759d3ced0062', '归集信息配置', 'schema/allocationList.action', 'fa fa-circle-o', 2550);

insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894b86729921901672b641c580097', '402894b86729921901672b6297ad0094', 'allocation.list', '归集信息配置', '归集信息配置', null, null, null, null);

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894b86729921901672b641c580097');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894b86729921901672b641c580097');

commit;