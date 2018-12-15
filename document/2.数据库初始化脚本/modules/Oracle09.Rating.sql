--评分模型表
drop table XY_PF_PFMX cascade constraints;
--评分指标(表内数据保留)
drop table XY_PF_PFZB cascade constraints;
--评分模型与指标关系表
drop table XY_PF_PFMXZBGX cascade constraints;
--指标与数据获取接口对应关系表
drop table XY_PF_PFZBSJJKGXB cascade constraints;
-- 评分指标区间分
drop table XY_PF_PFZB_QJF cascade constraints;
--评分指标种类分
drop table XY_PF_PFZB_ZLF cascade constraints;
--模型规则文件关系表
drop table XY_PF_PFMXGZGXB cascade constraints;

/*==============================================================*/
/* Table: XY_PF_PFMX                                            */
/*==============================================================*/
create table XY_PF_PFMX 
(
   MXBH                 VARCHAR2(50)         not null,
   MXMC                 VARCHAR2(200)        not null,
   MXMS                 VARCHAR2(500)        not null,
   STATUS               VARCHAR2(1),
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   UPDATE_TIME          DATE,
   UPDATE_USER          VARCHAR2(50),
   BZ                   VARCHAR2(500)
);

comment on table XY_PF_PFMX is
'评分模型模板表';

comment on column XY_PF_PFMX.MXBH is
'模型编号';

comment on column XY_PF_PFMX.MXMC is
'模型名称';

comment on column XY_PF_PFMX.MXMS is
'模型描述';

comment on column XY_PF_PFMX.STATUS is
'状态（0已启用、1已禁用）';

comment on column XY_PF_PFMX.CREATE_TIME is
'创建时间';

comment on column XY_PF_PFMX.CREATE_USER is
'创建人ID';

comment on column XY_PF_PFMX.UPDATE_TIME is
'更新时间';

comment on column XY_PF_PFMX.UPDATE_USER is
'更新人ID';

comment on column XY_PF_PFMX.BZ is
'备注';

alter table XY_PF_PFMX
   add constraint PK_XY_PF_PFMX primary key (MXBH);

/*==============================================================*/
/* Table: XY_PF_PFMXGZGXB                                       */
/*==============================================================*/
create table XY_PF_PFMXGZGXB 
(
   MXBH                 VARCHAR2(50)         not null,
   RULE                 CLOB                 not null
);

comment on table XY_PF_PFMXGZGXB is
'模型规则文件关系表';

comment on column XY_PF_PFMXGZGXB.MXBH is
'模型编号';

comment on column XY_PF_PFMXGZGXB.RULE is
'规则内容';

alter table XY_PF_PFMXGZGXB
   add constraint PK_XY_PF_PFMXGZGXB primary key (MXBH);

/*==============================================================*/
/* Table: XY_PF_PFMXZBGX                                        */
/*==============================================================*/
create table XY_PF_PFMXZBGX 
(
   PF_MX_ID             VARCHAR2(50)         not null,
   PF_ZB_ID             VARCHAR2(50)         not null,
   SCORE                NUMBER
);

comment on table XY_PF_PFMXZBGX is
'评分模型与指标关系表';

comment on column XY_PF_PFMXZBGX.PF_MX_ID is
'评分模型ID';

comment on column XY_PF_PFMXZBGX.PF_ZB_ID is
'评分指标ID';

comment on column XY_PF_PFMXZBGX.SCORE is
'指标总分';

alter table XY_PF_PFMXZBGX
   add constraint PK_XY_PF_PFMXZBGX primary key (PF_MX_ID, PF_ZB_ID);

/*==============================================================*/
/* Table: XY_PF_PFZB                                            */
/*==============================================================*/
create table XY_PF_PFZB 
(
   ID                   VARCHAR2(50)         not null,
   ZBMC                 VARCHAR2(200)        not null,
   PARENTID             VARCHAR2(50),
   ZBLX                 VARCHAR2(1),
   ZBJFLX               VARCHAR2(1)          not null,
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   UPDATE_TIME          DATE,
   UPDATE_USER          VARCHAR2(50),
   BZ                   VARCHAR2(500)
);

comment on table XY_PF_PFZB is
'评分指标';

comment on column XY_PF_PFZB.ID is
'主键';

comment on column XY_PF_PFZB.ZBMC is
'指标名称';

comment on column XY_PF_PFZB.PARENTID is
'父ID';

comment on column XY_PF_PFZB.ZBLX is
'指标类型（0区间分，1种类分）';

comment on column XY_PF_PFZB.ZBJFLX is
'指标计分类型（0加分，1扣分）';

comment on column XY_PF_PFZB.CREATE_TIME is
'创建时间';

comment on column XY_PF_PFZB.CREATE_USER is
'创建人ID';

comment on column XY_PF_PFZB.UPDATE_TIME is
'更新时间';

comment on column XY_PF_PFZB.UPDATE_USER is
'更新人ID';

comment on column XY_PF_PFZB.BZ is
'备注';

alter table XY_PF_PFZB
   add constraint PK_XY_PF_PFZB primary key (ID);

/*==============================================================*/
/* Table: XY_PF_PFZBSJJKGXB                                     */
/*==============================================================*/
create table XY_PF_PFZBSJJKGXB 
(
   PF_ZB_ID             VARCHAR2(50)         not null,
   PF_SERVICE_BEAN      VARCHAR2(250),
   PF_SERVICE_METHOD    VARCHAR2(250)
);

comment on table XY_PF_PFZBSJJKGXB is
'指标与数据获取接口对应关系表';

comment on column XY_PF_PFZBSJJKGXB.PF_ZB_ID is
'评分指标ID';

comment on column XY_PF_PFZBSJJKGXB.PF_SERVICE_BEAN is
'提供获取数据服务的bean名称，值为Spring的@Service的id名';

comment on column XY_PF_PFZBSJJKGXB.PF_SERVICE_METHOD is
'方法名';

alter table XY_PF_PFZBSJJKGXB
   add constraint PK_XY_PF_PFZBSJJKGXB primary key (PF_ZB_ID);

/*==============================================================*/
/* Table: XY_PF_PFZB_QJF                                        */
/*==============================================================*/
create table XY_PF_PFZB_QJF 
(
   ID                   VARCHAR2(50)         not null,
   PF_MX_ID             VARCHAR2(50)         not null,
   PF_ZB_ID             VARCHAR2(50)         not null,
   MIN                  NUMBER               not null,
   MAX                  NUMBER,
   SCORE                NUMBER               not null,
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BZ                   VARCHAR2(500)
);

comment on table XY_PF_PFZB_QJF is
'评分指标区间分';

comment on column XY_PF_PFZB_QJF.ID is
'主键';

comment on column XY_PF_PFZB_QJF.PF_MX_ID is
'评分模型ID';

comment on column XY_PF_PFZB_QJF.PF_ZB_ID is
'评分指标ID';

comment on column XY_PF_PFZB_QJF.MIN is
'区间最小值';

comment on column XY_PF_PFZB_QJF.MAX is
'区间最大值';

comment on column XY_PF_PFZB_QJF.SCORE is
'数值在该区间内的分数';

comment on column XY_PF_PFZB_QJF.CREATE_TIME is
'创建时间';

comment on column XY_PF_PFZB_QJF.CREATE_USER is
'创建人ID';

comment on column XY_PF_PFZB_QJF.BZ is
'备注';

alter table XY_PF_PFZB_QJF
   add constraint PK_XY_PF_PFZB_QJF primary key (ID);

/*==============================================================*/
/* Table: XY_PF_PFZB_ZLF                                        */
/*==============================================================*/
create table XY_PF_PFZB_ZLF 
(
   ID                   VARCHAR2(50)         not null,
   PF_MX_ID             VARCHAR2(50)         not null,
   PF_ZB_ID             VARCHAR2(50)         not null,
   ZLMC                 VARCHAR2(250)        not null,
   SCORE                NUMBER               not null,
   CREATE_TIME          DATE,
   CREATE_USER          VARCHAR2(50),
   BZ                   VARCHAR2(500)
);

comment on table XY_PF_PFZB_ZLF is
'评分指标种类分';

comment on column XY_PF_PFZB_ZLF.ID is
'主键';

comment on column XY_PF_PFZB_ZLF.PF_MX_ID is
'评分模型ID';

comment on column XY_PF_PFZB_ZLF.PF_ZB_ID is
'评分指标ID';

comment on column XY_PF_PFZB_ZLF.ZLMC is
'种类名称';

comment on column XY_PF_PFZB_ZLF.SCORE is
'种类分数';

comment on column XY_PF_PFZB_ZLF.CREATE_TIME is
'创建时间';

comment on column XY_PF_PFZB_ZLF.CREATE_USER is
'创建人ID';

comment on column XY_PF_PFZB_ZLF.BZ is
'备注';

alter table XY_PF_PFZB_ZLF
   add constraint PK_XY_PF_PFZB_ZLF primary key (ID);

alter table XY_PF_PFMXGZGXB
   add constraint "FK_PF_Reference_23" foreign key (MXBH)
      references XY_PF_PFMX (MXBH)
      on delete cascade;

alter table XY_PF_PFMXZBGX
   add constraint FK_XY_PF_PFMXZBGX_PF_MX_ID foreign key (PF_MX_ID)
      references XY_PF_PFMX (MXBH)
      on delete cascade;

alter table XY_PF_PFMXZBGX
   add constraint FK_XY_PF_PFMXZBGX_PF_ZB_ID foreign key (PF_ZB_ID)
      references XY_PF_PFZB (ID)
      on delete cascade;

alter table XY_PF_PFZB_QJF
   add constraint FK_XY_PF_PFZB_QJF_MXID foreign key (PF_MX_ID)
      references XY_PF_PFMX (MXBH)
      on delete cascade;

alter table XY_PF_PFZB_QJF
   add constraint FK_XY_PF_PFZB_QJF_ZBID foreign key (PF_ZB_ID)
      references XY_PF_PFZB (ID)
      on delete cascade;

alter table XY_PF_PFZB_ZLF
   add constraint FK_XY_PF_PFZB_ZLF_MXID foreign key (PF_MX_ID)
      references XY_PF_PFMX (MXBH)
      on delete cascade;

alter table XY_PF_PFZB_ZLF
   add constraint FK_XY_PF_PFZB_ZLF_ZBID foreign key (PF_ZB_ID)
      references XY_PF_PFZB (ID)
      on delete cascade;

-- 评分模型指标表初始数据
insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('1', '企业概况', 'ROOT', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('1_1', '经营时间', '1', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('1_2', '公司规模', '1', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('1_3', '固定资产额', '1', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('1_4', '注册资金', '1', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('1_5', '社保缴纳额', '1', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('1_6', '企业纳税额', '1', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('2', '失信信息', 'ROOT', '1', sysdate, null, sysdate, null, '手动录入-初始化数据', '1');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('3', '表彰荣誉', 'ROOT', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('4', '知识产权', 'ROOT', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '1');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('5', '企业资质', 'ROOT', '0', sysdate, null, sysdate, null, '手动录入-初始化数据', '1');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('6', '欠税欠费', 'ROOT', '1', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('6_1', '欠税信息', '6', '1', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('6_2', '欠费信息', '6', '1', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');

insert into XY_PF_PFZB (ID, ZBMC, PARENTID, ZBJFLX, CREATE_TIME, CREATE_USER, UPDATE_TIME, UPDATE_USER, BZ, ZBLX)
values ('6_3', '社保欠缴额', '6', '1', sysdate, null, sysdate, null, '手动录入-初始化数据', '0');


insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('1_1', 'XYPFQYGKService', 'getJYSJ');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('1_2', 'XYPFQYGKService', 'getGSGM');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('1_3', 'XYPFQYGKService', 'getGDZCE');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('1_4', 'XYPFQYGKService', 'getZCZJ');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('1_5', 'XYPFQYGKService', 'getSBJNE');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('1_6', 'XYPFQYGKService', 'getQYNSE');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('2', 'XYPFSXXXService', 'getSXXX');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('3', 'XYPFBZRYService', 'getBZRY');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('4', 'XYPFZSCQService', 'getZSCQ');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('5', 'XYPFQYZZService', 'getQYZZ');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('6_1', 'XYPFQSQFService', 'getQSXX');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('6_2', 'XYPFQSQFService', 'getQFXX');

insert into XY_PF_PFZBSJJKGXB (PF_ZB_ID, PF_SERVICE_BEAN, PF_SERVICE_METHOD)
values ('6_3', 'XYPFQSQFService', 'getSBQJE');

commit;

drop sequence  SQ_PFMXBH;
create sequence SQ_PFMXBH minvalue 1 maxvalue 9999999999999999999999999999
start with 61 increment by 1 cache 20;

--添加菜单-评分管理
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5b17f69a015b18007c6d0025', 'ROOT_1', '评分管理', null, 'icon-calendar', 60);
commit;

--添加菜单-评分模型模板-评分查询
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5b17f69a015b1814bbef0068', '402894ee5b17f69a015b18007c6d0025', '评分模型模板', 'center/scoreManage/modelList.action', 'fa fa-circle-o', 6010);
insert into sys_menu (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('402894ee5b17f69a015b181315a00063', '402894ee5b17f69a015b18007c6d0025', '评分查询', 'center/scoreManage/scoreQuery.action', 'fa fa-circle-o', 6005);
commit;

--添加权限-评分模型模板-评分查询
insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894f85b412057015b41260dab0015', '402894ee5b17f69a015b1814bbef0068', 'center.scoreManage.Model', '评分模型模板', '评分模型模板', null, null, null, null);
insert into sys_privilege (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('402894ee5b17f69a015b1815aaed0074', '402894ee5b17f69a015b181315a00063', 'center.scoreManage.query', '评分查询', null, null, null, null, null);
commit;

--绑定权限和角色关系
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('2c90c28158761b550158762482b50015', '402894f85b412057015b41260dab0015');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('8aa0bef544713ca60144713d364a0000', '402894f85b412057015b41260dab0015');

insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('2c90c28158761b550158762482b50015', '402894ee5b17f69a015b1815aaed0074');
insert into sys_role_to_privilege (SYS_ROLE_ID, SYS_PRIVILEGE_ID) values ('8aa0bef544713ca60144713d364a0000', '402894ee5b17f69a015b1815aaed0074');

commit;
