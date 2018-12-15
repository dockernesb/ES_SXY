-- 接口配置-------------------------begin-------------------
drop table LD_DATA_ACCESS_RULE;
create table LD_DATA_ACCESS_RULE
(
  id                 VARCHAR2(50) not null,
  rulecode           NUMBER,
  accesslimit        NUMBER,
  startdate          TIMESTAMP(0),
  enddate            TIMESTAMP(0),
  interfacemanagerid VARCHAR2(50)
)
;
comment on table LD_DATA_ACCESS_RULE
  is '接口访问规则';
comment on column LD_DATA_ACCESS_RULE.id
  is '主键';
comment on column LD_DATA_ACCESS_RULE.rulecode
  is '规则编码';
comment on column LD_DATA_ACCESS_RULE.accesslimit
  is '访问次数限制';
comment on column LD_DATA_ACCESS_RULE.startdate
  is '开始日期';
comment on column LD_DATA_ACCESS_RULE.enddate
  is '结束日期';
comment on column LD_DATA_ACCESS_RULE.interfacemanagerid
  is '接口ID';
alter table LD_DATA_ACCESS_RULE
  add primary key (ID);
  
drop table LD_INTERFACE_APPLY;
create table LD_INTERFACE_APPLY
(
  id                 VARCHAR2(50) not null,
  item               VARCHAR2(100),
  appname            VARCHAR2(1000),
  offeree            VARCHAR2(50),
  ipaddr             VARCHAR2(50),
  requirement        VARCHAR2(4000),
  accessrule         VARCHAR2(100),
  createuser         VARCHAR2(50),
  createdate         TIMESTAMP(0),
  status             VARCHAR2(4),
  departid           VARCHAR2(50),
  interfacemanagerid VARCHAR2(50)
)
;
comment on table LD_INTERFACE_APPLY
  is '接口申请表';
comment on column LD_INTERFACE_APPLY.id
  is '主键';
comment on column LD_INTERFACE_APPLY.item
  is '事项类别';
comment on column LD_INTERFACE_APPLY.appname
  is '应用名称';
comment on column LD_INTERFACE_APPLY.offeree
  is '相对人';
comment on column LD_INTERFACE_APPLY.ipaddr
  is '对接ip地址';
comment on column LD_INTERFACE_APPLY.requirement
  is '需求数据字段';
comment on column LD_INTERFACE_APPLY.accessrule
  is '访问频率';
comment on column LD_INTERFACE_APPLY.createuser
  is '申请人';
comment on column LD_INTERFACE_APPLY.createdate
  is '申请时间';
comment on column LD_INTERFACE_APPLY.status
  is '状态';
comment on column LD_INTERFACE_APPLY.departid
  is '应用单位';
comment on column LD_INTERFACE_APPLY.interfacemanagerid
  is '接口配置id';
alter table LD_INTERFACE_APPLY
  add primary key (ID);
  
  drop table LD_INTERFACE_MANAGER;
  create table LD_INTERFACE_MANAGER
(
  id                VARCHAR2(50) not null,
  appname           VARCHAR2(50),
  marking           VARCHAR2(50) not null,
  departmentid      VARCHAR2(50),
  ipaddr            VARCHAR2(50),
  state             NUMBER,
  incrementalstatus NUMBER,
  parameterstatus   NUMBER,
  interfacetype     NUMBER,
  sqlstring         VARCHAR2(2000),
  dictionaryid      VARCHAR2(50),
  createdate        TIMESTAMP(0) not null,
  createuserid      VARCHAR2(50),
  updatedate        TIMESTAMP(0),
  updateuserid      VARCHAR2(50),
  templeateid       VARCHAR2(50)
)
;
comment on table LD_INTERFACE_MANAGER
  is '接口管理';
comment on column LD_INTERFACE_MANAGER.id
  is '主键';
comment on column LD_INTERFACE_MANAGER.appname
  is '应用名称';
comment on column LD_INTERFACE_MANAGER.marking
  is '标识key';
comment on column LD_INTERFACE_MANAGER.departmentid
  is '部门id';
comment on column LD_INTERFACE_MANAGER.ipaddr
  is 'IP地址 为空时表示无IP限制，不为空时需要校验IP';
comment on column LD_INTERFACE_MANAGER.state
  is '状态（0：禁用 1：启用';
comment on column LD_INTERFACE_MANAGER.incrementalstatus
  is '是否增量，0否，1是';
comment on column LD_INTERFACE_MANAGER.parameterstatus
  is '是否带参数，0不带，1带';
comment on column LD_INTERFACE_MANAGER.interfacetype
  is '接口类型 0：普通接口 1：高级接口';
comment on column LD_INTERFACE_MANAGER.sqlstring
  is '高级模式接口使用的sql语句';
comment on column LD_INTERFACE_MANAGER.dictionaryid
  is '数据字典ID';
comment on column LD_INTERFACE_MANAGER.createdate
  is '创建时间';
comment on column LD_INTERFACE_MANAGER.createuserid
  is '创建人';
comment on column LD_INTERFACE_MANAGER.updatedate
  is '更新时间';
comment on column LD_INTERFACE_MANAGER.updateuserid
  is '更新人';
comment on column LD_INTERFACE_MANAGER.templeateid
  is '普通接口模板ID';
alter table LD_INTERFACE_MANAGER
  add primary key (ID);

drop table LD_INTERFACE_SHENHE;
create table LD_INTERFACE_SHENHE
(
  id                 VARCHAR2(50) not null,
  createdate         TIMESTAMP(0),
  createuser         VARCHAR2(50),
  interface_apply_id VARCHAR2(50),
  status             VARCHAR2(4),
  opinion            VARCHAR2(1000)
)
;
comment on table LD_INTERFACE_SHENHE
  is '接口申请审核表';
comment on column LD_INTERFACE_SHENHE.id
  is '主键';
comment on column LD_INTERFACE_SHENHE.createdate
  is '审核时间';
comment on column LD_INTERFACE_SHENHE.createuser
  is '审核人';
comment on column LD_INTERFACE_SHENHE.interface_apply_id
  is '外键';
comment on column LD_INTERFACE_SHENHE.status
  is '审核状态';
comment on column LD_INTERFACE_SHENHE.opinion
  is '审核意见';
alter table LD_INTERFACE_SHENHE
  add primary key (ID);

drop table LD_INTERFACE_STATISTICS;
create table LD_INTERFACE_STATISTICS
(
  id                 VARCHAR2(50) not null,
  interfacemanagerid VARCHAR2(50),
  visitdate          TIMESTAMP(0) not null,
  datacount          VARCHAR2(50),
  token              VARCHAR2(200)
)
;
comment on table LD_INTERFACE_STATISTICS
  is '接口统计';
comment on column LD_INTERFACE_STATISTICS.id
  is '主键';
comment on column LD_INTERFACE_STATISTICS.interfacemanagerid
  is '接口管理id';
comment on column LD_INTERFACE_STATISTICS.visitdate
  is '访问日期';
comment on column LD_INTERFACE_STATISTICS.datacount
  is '数据返回数量';
comment on column LD_INTERFACE_STATISTICS.token
  is '数据访问标识';
alter table LD_INTERFACE_STATISTICS
  add primary key (ID);
--删除信用报告模板用途中的字典项【接口配置】
delete from sys_dictionary a  where a.id='4028498159001426015900615d460025';
commit;
--建个顶级资源 - 接口配置
insert into dz_theme (ID, PARENT_ID, TYPE, TYPE_NAME, DATA_SOURCE, DATA_TABLE, STATUS, CREATE_TIME, ZYYT)
values ('ROOT_99', 'ROOT', '0', '接口配置', null, null, '1', to_timestamp('27-DEC-16 12.00.00 AM','dd-MM-yy hh:mi:ss pm'), '99');
--添加字典项 - 接口配置
insert into sys_dictionary_group (ID, GROUP_KEY, GROUP_NAME, DESCRIPTION)
values ('4028498159001426015900659eaf0029', 'zyyt', '资源用途', '资源库中资源用途');

insert into sys_dictionary (ID, GROUP_ID, DICT_KEY, DICT_VALUE, DICT_ORDER)
values ('402894ee5bf56f6e015bf575832c0011', '4028498159001426015900659eaf0029', '4', '接口配置', null);
commit;
-------------------------------信用信息共享start------------------------------------------
insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5bec0b07015bec68f0fb0040', 'ROOT_1', '信用信息共享', null, 'fa fa-share-alt', 70);
commit;
----
-------------------------------接口申请管理start------------------------------------------
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5beb1b02015beb1eb8800008', 'ROOT_2', '接口申请管理', 'gov/interfaceApply/interfaceApplyList.action', 'fa fa-circle-o', 45);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5bec0b07015bec69d4580045', '402894ee5bec0b07015bec68f0fb0040', '接口审核', 'center/interfaceAudit/interfaceAuditList.action', 'fa fa-circle-o', 7005);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5bf101fd015bf13d32910044', '402894ee5bec0b07015bec68f0fb0040', '接口管理', 'center/interfaceManager/interfaceManagerList.action', 'fa fa-circle-o', 7010);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5bfb2a62015bfb5f5c150086', '402894ee5bec0b07015bec68f0fb0040', '接口监控', 'center/interfaceMonitor/interfaceMonitorList.action', 'fa fa-circle-o', 7015);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5bfb2a62015bfb9df33d00cd', '402894ee5bec0b07015bec68f0fb0040', '接口统计', 'center/interfaceStatistics/interfaceStatistics.action', 'fa fa-circle-o', 7020);

insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5bf662dc015bf6e3d6ac0140', '402894ee5bec0b07015bec68f0fb0040', '接口测试', 'center/webservice/wsTest.action', 'fa fa-circle-o', 7090);

insert into sys_privilege (SYS_PRIVILEGE_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER, SYS_MENU_ID)
values ('402894ee5beb1b02015beb1f16090010', 'gov.interface.apply.list', '接口申请管理', null, null, null, null, null, '402894ee5beb1b02015beb1eb8800008');

insert into sys_privilege (SYS_PRIVILEGE_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER, SYS_MENU_ID)
values ('402894ee5bec0b07015bec6bf23c0051', 'center.interface.apply.audit', '接口申请审核', null, null, null, null, null, '402894ee5bec0b07015bec69d4580045');

insert into sys_privilege (SYS_PRIVILEGE_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER, SYS_MENU_ID)
values ('402894ee5bf101fd015bf13e2082004e', 'center.interface.manager', '接口管理', null, null, null, null, null, '402894ee5bf101fd015bf13d32910044');

insert into sys_privilege (SYS_PRIVILEGE_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER, SYS_MENU_ID)
values ('402894ee5bfb2a62015bfb5fce580091', 'center.webservice.monitor', '接口监控', null, null, null, null, null, '402894ee5bfb2a62015bfb5f5c150086');

insert into sys_privilege (SYS_PRIVILEGE_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER, SYS_MENU_ID)
values ('402894ee5bfb2a62015bfba1a22900d7', 'center.webservice.statistics', '接口统计', null, null, null, null, null, '402894ee5bfb2a62015bfb9df33d00cd');

insert into sys_privilege (SYS_PRIVILEGE_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER, SYS_MENU_ID)
values ('402894ee5bf662dc015bf6e43646014a', 'center.webservice.test', '接口测试', null, null, null, null, null, '402894ee5bf662dc015bf6e3d6ac0140');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5bfb2a62015bfb5fce580091');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee5bfb2a62015bfba1a22900d7');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5bf101fd015bf13e2082004e');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee5bfb2a62015bfb5fce580091');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('40289454547b159d01547b1efe25000c', '402894ee5beb1b02015beb1f16090010');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee5bec0b07015bec6bf23c0051');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5bfb2a62015bfba1a22900d7');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5bf662dc015bf6e43646014a');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee5bf662dc015bf6e43646014a');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5beb1b02015beb1f16090010');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b550158762482b50015', '402894ee5bf101fd015bf13e2082004e');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '402894ee5bec0b07015bec6bf23c0051');
commit;
-- 接口 -----------------------------------------end-----------------------
