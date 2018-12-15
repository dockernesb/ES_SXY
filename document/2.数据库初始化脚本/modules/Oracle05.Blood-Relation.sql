drop table DP_DATA_REPROT_CETL cascade constraints;
create table DP_DATA_REPROT_CETL
(
  s_name    VARCHAR2(50) not null,
  TABLE_CODE VARCHAR2(100) not null,
  n_type    NUMBER not null
)
;
comment on table DP_DATA_REPROT_CETL
  is '数据血缘cetl关系表';
comment on column DP_DATA_REPROT_CETL.s_name
  is '数据血缘cetl转换名称';
comment on column DP_DATA_REPROT_CETL.TABLE_CODE
  is '目录编码';
comment on column DP_DATA_REPROT_CETL.n_type
  is '数据血缘cetl转换名称类型（1:原始-->>y）有效 2：有效-->>业务';
alter table DP_DATA_REPROT_CETL
  add constraint DP_DATA_REPROT_CETL_UK2 unique (TABLE_CODE, N_TYPE);