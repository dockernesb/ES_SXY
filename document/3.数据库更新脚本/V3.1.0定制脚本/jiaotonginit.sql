-- Create tablen ODS 失信信息主表
create table YW_ODS_JTSX_MAIN
(
  ID      VARCHAR2(38) not null,
  NAME    VARCHAR2(100),
  JSZ     VARCHAR2(50),
  DW      VARCHAR2(200),
  ZDJSRZL VARCHAR2(2),
  SXRDRQ  DATE,
  JTSXYY  VARCHAR2(2000),
  SXDJ    VARCHAR2(2),
  YXSJ    DATE,
  SXRDDW  VARCHAR2(1000),
  RYTYPE  VARCHAR2(10),
  STATE   VARCHAR2(10) default 0,
  DM      VARCHAR2(10),
  WFJLID1 VARCHAR2(2000),
  ISBS    VARCHAR2(10),
  BSSJ    DATE,
  ISMTC   VARCHAR2(10),
  WFJLID  CLOB,
  SPSJ    DATE,
  JLTYPE  VARCHAR2(10),
  TYPE  VARCHAR2(10) default 0,
  SFGS VARCHAR2(10) default 0,
  JDGSRQ DATE
);

alter table YW_ODS_JTSX_MAIN
  add constraint YW_ODS_JTSX_MAIN_ID primary key (ID);

-- Add comments to the table
comment on table YW_ODS_JTSX_MAIN
  is '失信名单主表';
-- Add comments to the columns
comment on column YW_ODS_JTSX_MAIN.ID
  is '主键';
comment on column YW_ODS_JTSX_MAIN.NAME
  is '姓名';
comment on column YW_ODS_JTSX_MAIN.JSZ
  is '驾驶证号';
comment on column YW_ODS_JTSX_MAIN.DW
  is '单位';
comment on column YW_ODS_JTSX_MAIN.ZDJSRZL
  is '重点驾驶人种类   01公路客运、02旅游客运、03危险品运输、04校车服务、90渣土运输';
comment on column YW_ODS_JTSX_MAIN.SXRDRQ
  is '失信认定日期';
comment on column YW_ODS_JTSX_MAIN.JTSXYY
  is '交通失信原因';
comment on column YW_ODS_JTSX_MAIN.SXDJ
  is '失信等级 (1:一般失信 2:较重失信 3:严重失信)';
comment on column YW_ODS_JTSX_MAIN.YXSJ
  is '有效时间  一般失信1年  较重失信3年  严重失信5年';
comment on column YW_ODS_JTSX_MAIN.SXRDDW
  is '失信认定单位';
comment on column YW_ODS_JTSX_MAIN.RYTYPE
  is '1：驾驶人  2所有人';
comment on column YW_ODS_JTSX_MAIN.STATE
  is '0.正常状态,1.已删除,2.正在修复,3.修复未通过';
comment on column YW_ODS_JTSX_MAIN.DM
  is '认定标准代码';
comment on column YW_ODS_JTSX_MAIN.WFJLID1
  is '违法记录id';
comment on column YW_ODS_JTSX_MAIN.ISBS
  is '是否报送  空则为未报送   1为已报送';
comment on column YW_ODS_JTSX_MAIN.BSSJ
  is '报送时间';
comment on column YW_ODS_JTSX_MAIN.ISMTC
  is '是否摩托车';
comment on column YW_ODS_JTSX_MAIN.WFJLID
  is '违法记录id';
comment on column YW_ODS_JTSX_MAIN.SPSJ
  is '审批时间';
comment on column YW_ODS_JTSX_MAIN.JLTYPE
  is '1违法信息的认定 2累计的认定 3车辆的认定';

  comment on column YW_ODS_JTSX_MAIN.TYPE
  is '1NORMAL 2YELLOW 3BLACK';

  comment on column YW_ODS_JTSX_MAIN.SFGS
  is '是否公示 0：不公示   1：公示';






---DROP  TABLE YW_ODS_T_CCM_WFXW_XXGJ;
create table YW_ODS_T_CCM_WFXW_XXGJ
(
  ID     VARCHAR2(38) not null,
  JDSBH  VARCHAR2(15),
  WSJYW  VARCHAR2(100),
  RYFL   VARCHAR2(100),
  JSZH   VARCHAR2(18),
  DABH   VARCHAR2(12),
  FZJG   VARCHAR2(10),
  ZJCX   VARCHAR2(10),
  DSR    VARCHAR2(130),
  CLFL   VARCHAR2(100),
  HPZL   VARCHAR2(100),
  HPHM   VARCHAR2(15),
  JDCSYR VARCHAR2(128),
  SYXZ   VARCHAR2(100),
  JTFS   VARCHAR2(300),
  WFSJ   DATE,
  WFDD   VARCHAR2(500),
  LDDM   VARCHAR2(400),
  DDMS   VARCHAR2(300),
  DDJDWZ VARCHAR2(100),
  WFDZ   VARCHAR2(128),
  WFXW   VARCHAR2(500),
  WFJFS  NUMBER(2),
  FKJE   NUMBER(6),
  FXJG   VARCHAR2(12),
  FXJGMC VARCHAR2(128),
  CLJG   VARCHAR2(12),
  CLJGMC VARCHAR2(128),
  JKBJ   VARCHAR2(100),
  JKRQ   DATE,
  PZBH   VARCHAR2(15),
  XXLY   VARCHAR2(100),
  SGDJ   VARCHAR2(15),
  ISRD   VARCHAR2(10) default 0,
  CLSJ   DATE,
  GXSJ   DATE,
  STATE  VARCHAR2(4)
);


comment on table YW_ODS_T_CCM_WFXW_XXGJ
  is '违法行为信息归集';

comment on column YW_ODS_T_CCM_WFXW_XXGJ.JDSBH
  is '决定书编号';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.WSJYW
  is '文书校验位';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.RYFL
  is '人员分类';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.JSZH
  is '驾驶证号';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.DABH
  is '档案编号';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.FZJG
  is '发证机关';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.ZJCX
  is '准驾车型';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.DSR
  is '当事人';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.CLFL
  is '车辆分类';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.HPZL
  is '号牌种类';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.HPHM
  is '号牌号码';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.JDCSYR
  is '机动车所有人';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.SYXZ
  is '机动车使用性质';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.JTFS
  is '交通方式';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.WFSJ
  is '违法时间';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.WFDD
  is '违法地点';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.LDDM
  is '路口路段代码，当为城市道路时存放路口号，为高速、省道等时存放公里数';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.DDMS
  is '地点米数';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.DDJDWZ
  is '地点绝对位置';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.WFDZ
  is '违法地址';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.WFXW
  is '违法行为';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.WFJFS
  is '违法记分数';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.FKJE
  is '罚款金额';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.FXJG
  is '发现机关';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.FXJGMC
  is '发现机关名称';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.CLJG
  is '处理机关';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.CLJGMC
  is '处理机关名称';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.JKBJ
  is '交款标记';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.JKRQ
  is '交款日期';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.PZBH
  is '强制措施凭证号';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.XXLY
  is '信息来源';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.SGDJ
  is '事故等级（0无事故）';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.ISRD
  is '是否认定';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.CLSJ
  is '处理时间';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.GXSJ
  is '更新时间';
comment on column YW_ODS_T_CCM_WFXW_XXGJ.STATE
  is '0.正常状态,1.已删除,2.正在修复,3.修复未通过';
-- Create/Recreate primary, unique and foreign key constraints
alter table YW_ODS_T_CCM_WFXW_XXGJ
  add constraint PK_WFXW primary key (ID);

Create Index indexJSZH On YW_ODS_T_CCM_WFXW_XXGJ(JSZH);


---DROP  TABLE   ODS_T_CCM_WFXWDM;
create table  ODS_T_CCM_WFXWDM
(
  ID       VARCHAR2(38) not null,
  DM       VARCHAR2(50),
  MC       VARCHAR2(1000),
  WFYJ     VARCHAR2(1000),
  CFYJ     VARCHAR2(1000),
  JFFZ     VARCHAR2(100),
  FKJE     VARCHAR2(100),
  QTXZCF   VARCHAR2(1000),
  QTCS     VARCHAR2(1000),
  ISDELETE VARCHAR2(10)
);



-- Add comments to the table
comment on table  ODS_T_CCM_WFXWDM
  is '违法行为代码管理表';
-- Add comments to the columns
comment on column  ODS_T_CCM_WFXWDM.ID
  is '主键';
comment on column  ODS_T_CCM_WFXWDM.DM
  is '违法行为代码';
comment on column  ODS_T_CCM_WFXWDM.MC
  is '违法行为名称';
comment on column  ODS_T_CCM_WFXWDM.WFYJ
  is '违法依据';
comment on column  ODS_T_CCM_WFXWDM.CFYJ
  is '处罚依据';
comment on column  ODS_T_CCM_WFXWDM.JFFZ
  is '记分分值';
comment on column  ODS_T_CCM_WFXWDM.FKJE
  is '罚款金额';
comment on column  ODS_T_CCM_WFXWDM.QTXZCF
  is '其他行政处罚';
comment on column  ODS_T_CCM_WFXWDM.QTCS
  is '其他措施';
comment on column  ODS_T_CCM_WFXWDM.ISDELETE
  is '是否删除。默认0；1代表已删除';
-- Create/Recreate primary, unique and foreign key constraints

alter table  ODS_T_CCM_WFXWDM
  add constraint T_WORK_WFXWDM_PK primary key (ID);


----DROP  TABLE   ODS_JTSX_PEOPLE;
create table ODS_JTSX_PEOPLE
(
  ID      VARCHAR2(38) not null,
  NAME    VARCHAR2(100),
  JSZ     VARCHAR2(50)
);
alter table ODS_JTSX_PEOPLE
  add constraint ODS_JTSX_PEOPLE_ID primary key (ID);

  -----DROP  TABLE   DT_OBJECTION_COMPLAINT;
create table DT_OBJECTION_COMPLAINT
(
  ID             VARCHAR2(50) NOT NULL,
  COMPLAINT_TYPE VARCHAR2(50),
  NAME           VARCHAR2(50) NOT NULL,
  JSZ            VARCHAR2(50) NOT NULL,
  PHONE_NUMBER   VARCHAR2(50),
  SSBZ           VARCHAR2(2000),
  CREATE_DATE    DATE,
  CREATE_ID      VARCHAR2(50),
  STATE          VARCHAR2(4) DEFAULT 0 NOT NULL,
  LINK_ID        VARCHAR2(50) NOT NULL,
  BJBH           VARCHAR2(50) NOT NULL,
  TYPE           VARCHAR2(4) NOT NULL,
  DATA_TABLE     VARCHAR2(50),
  SOURCE         VARCHAR2(50)
);

comment on column DT_OBJECTION_COMPLAINT.ID
  is '主键';
comment on column DT_OBJECTION_COMPLAINT.COMPLAINT_TYPE
  is '申诉类型';
comment on column DT_OBJECTION_COMPLAINT.NAME
  is '申诉人姓名';
comment on column DT_OBJECTION_COMPLAINT.JSZ
  is '申诉人身份证号（驾驶证号）';
comment on column DT_OBJECTION_COMPLAINT.PHONE_NUMBER
  is '手机号码';
comment on column DT_OBJECTION_COMPLAINT.SSBZ
  is '申述备注';
comment on column DT_OBJECTION_COMPLAINT.CREATE_DATE
  is '申请时间';
comment on column DT_OBJECTION_COMPLAINT.CREATE_ID
  is '录入人';
comment on column DT_OBJECTION_COMPLAINT.STATE
  is '申请状态（0：申诉中，1：待核实，2：已通过 3：未通过）';
comment on column DT_OBJECTION_COMPLAINT.LINK_ID
  is '申请需要修复的记录ID';
comment on column DT_OBJECTION_COMPLAINT.BJBH
  is '办件编号';
comment on column DT_OBJECTION_COMPLAINT.TYPE
  is '申诉的类型，（1：申诉失信等级 2：申诉失信记录）';
comment on column DT_OBJECTION_COMPLAINT.DATA_TABLE
  is '申诉数据表';
comment on column DT_OBJECTION_COMPLAINT.SOURCE
  is '申诉途径（1:市信用大厅 2:市公共信用平台 3：交通微警务）';
alter table DT_OBJECTION_COMPLAINT
  add primary key (ID,SOURCE);


insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875af9dd900b9', '2c90c28158757420015875ada135009f', '自然人异议申诉申请', 'objectionComplaint/toObjectionComplaint.action', 'fa fa-circle-o', 1005);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c5ac990139', '2c90c28158757420015875af9dd900b9', 'objectionComplaint.apply', '自然人异议申诉申请', null, null, null, null, null);

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c5ac990139');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c5ac990139');



insert into SYS_MENU (SYS_MENU_ID, PARENT_ID, MENU_NAME, MENU_URL, MENU_ICON, DISPLAY_ORDER)
values ('2c90c28158757420015875b1ced000c7', '2c90c28158757420015875addca500a4', '自然人异议申诉查询', 'objectionComplaint/toObjectionList.action', 'fa fa-circle-o', 1505);

insert into SYS_PRIVILEGE (SYS_PRIVILEGE_ID, SYS_MENU_ID, PRIVILEGE_CODE, PRIVILEGE_NAME, DESCRIPTION, USERS_COUNT, ROLES_COUNT, ALL_USERS_COUNT, DISPLAY_ORDER)
values ('2c90c28158757420015875c910b4015c', '2c90c28158757420015875b1ced000c7', 'objectionComplaint.list', '自然人异议申诉查询', null, null, null, null, null);

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('2c90c28158761b5501587622bd340011', '2c90c28158757420015875c910b4015c');

insert into SYS_ROLE_TO_PRIVILEGE (SYS_ROLE_ID, SYS_PRIVILEGE_ID)
values ('8aa0bef544713ca60144713d364a0000', '2c90c28158757420015875c910b4015c');

INSERT INTO DZ_THEME (id, parent_id, type, type_name, data_source, data_table, status, create_time, zyyt, display_order)
VALUES ('ROOT_9', 'ROOT', '0', '自然人异议申诉', NULL, NULL, '1', TO_TIMESTAMP('20180504225640', 'YYYYMMDDHH24MISS'), '9', NULL);
INSERT INTO DZ_THEME (id, parent_id, type, type_name, data_source, data_table, status, create_time, zyyt, display_order)
VALUES ('402894ef679bb89001679be28ae700c2', 'ROOT_9', '1', '失信等级', NULL, NULL, '1', TO_TIMESTAMP('20181211140934', 'YYYYMMDDHH24MISS'), '9', 1);

INSERT INTO DZ_THEME (id, parent_id, type, type_name, data_source, data_table, status, create_time, zyyt, display_order)
VALUES ('402894ef679bb89001679be2feac00c4', 'ROOT_9', '1', '失信行为记录', NULL, NULL, '1', TO_TIMESTAMP('20181211141004', 'YYYYMMDDHH24MISS'), '9', 2);

INSERT INTO DZ_THEME (id, parent_id, type, type_name, data_source, data_table, status, create_time, zyyt, display_order)
VALUES ('402894ef679bb89001679be8fa3500d7', '402894ef679bb89001679be28ae700c2', '2', '失信等级', 'jdbcTemplate', 'YW_ODS_JTSX_MAIN', '1', TO_TIMESTAMP('20181211141636', 'YYYYMMDDHH24MISS'), '9', 1);

INSERT INTO DZ_THEME (id, parent_id, type, type_name, data_source, data_table, status, create_time, zyyt, display_order)
VALUES ('402894ef679bb89001679bea26d100d9', '402894ef679bb89001679be2feac00c4', '2', '失信行为记录', 'jdbcTemplate', 'YW_ODS_T_CCM_WFXW_XXGJ', '1', TO_TIMESTAMP('20181211141753', 'YYYYMMDDHH24MISS'), '9', 1);

INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf233b900e8', '402894ef679bb89001679bea26d100d9', 'FKJE', '罚款金额', TO_TIMESTAMP('20181211142641', 'YYYYMMDDHH24MISS'), '罚款金额', 45, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf233ba00e9', '402894ef679bb89001679bea26d100d9', 'FXJGMC', '发现机关名称', TO_TIMESTAMP('20181211142641', 'YYYYMMDDHH24MISS'), '发现机关名称', 55, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf233bb00ea', '402894ef679bb89001679bea26d100d9', 'HPHM', '号牌号码', TO_TIMESTAMP('20181211142641', 'YYYYMMDDHH24MISS'), '号牌号码', 70, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf233bb00eb', '402894ef679bb89001679bea26d100d9', 'WFDZ', '违法地址', TO_TIMESTAMP('20181211142641', 'YYYYMMDDHH24MISS'), '违法地址', 150, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf233bb00ec', '402894ef679bb89001679bea26d100d9', 'WFJFS', '违法记分数', TO_TIMESTAMP('20181211142641', 'YYYYMMDDHH24MISS'), '违法记分数', 155, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf233bb00ed', '402894ef679bb89001679bea26d100d9', 'WFSJ', '违法时间', TO_TIMESTAMP('20181211142641', 'YYYYMMDDHH24MISS'), '违法时间', 160, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf233bd00ee', '402894ef679bb89001679bea26d100d9', 'WFXW', '违法行为', TO_TIMESTAMP('20181211142641', 'YYYYMMDDHH24MISS'), '违法行为', 165, NULL);

INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf0edea00e2', '402894ef679bb89001679be8fa3500d7', 'JTSXYY', '交通失信原因', TO_TIMESTAMP('20181211142517', 'YYYYMMDDHH24MISS'), '交通失信原因', 45, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf0edea00e3', '402894ef679bb89001679be8fa3500d7', 'SXDJ', '失信等级 (1:一般失信 2:较重失信 3:严重失信)', TO_TIMESTAMP('20181211142517', 'YYYYMMDDHH24MISS'), '失信等级', 75, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf0edea00e4', '402894ef679bb89001679be8fa3500d7', 'SXRDDW', '失信认定单位', TO_TIMESTAMP('20181211142517', 'YYYYMMDDHH24MISS'), '失信认定单位', 80, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf0edea00e5', '402894ef679bb89001679be8fa3500d7', 'SXRDRQ', '失信认定日期', TO_TIMESTAMP('20181211142517', 'YYYYMMDDHH24MISS'), '失信认定日期', 85, NULL);
INSERT INTO DZ_THEME_COLUMN (id, theme_id, column_name, column_comments, create_time, column_alias, display_order, data_order)
VALUES ('402894ef679bb89001679bf0edea00e6', '402894ef679bb89001679be8fa3500d7', 'YXSJ', '有效时间  一般失信1年  较重失信3年  严重失信5年', TO_TIMESTAMP('20181211142517', 'YYYYMMDDHH24MISS'), '有效时间  一般失信1年  较重失信3年  严重失信5年', 105, NULL);
