-- 统一给kettle模板添加日志记录表
UPDATE R_TRANS_ATTRIBUTE T SET T.VALUE_STR = TO_CLOB('CETL')
  WHERE (T.CODE = 'STEP_LOG_TABLE_CONNECTION_NAME' OR T.CODE = 'TRANS_LOG_TABLE_CONNECTION_NAME') AND T.VALUE_STR is not null;
UPDATE R_TRANS_ATTRIBUTE T SET T.VALUE_STR = TO_CLOB('ODS_R_EXEC_LOG_TRANS')
  WHERE T.CODE = 'TRANS_LOG_TABLE_TABLE_NAME' AND T.VALUE_STR is not null;
UPDATE R_TRANS_ATTRIBUTE T SET T.VALUE_STR = TO_CLOB('ODS_R_EXEC_LOG_STEPS')
  WHERE T.CODE = 'STEP_LOG_TABLE_TABLE_NAME' AND T.VALUE_STR is not null;


-- 步骤日志记录表
create table ODS_R_EXEC_LOG_STEPS
(
  id_batch       INTEGER,
  channel_id     VARCHAR2(255),
  log_date       DATE,
  transname      VARCHAR2(255),
  stepname       VARCHAR2(255),
  step_copy      INTEGER,
  lines_read     INTEGER,
  lines_written  INTEGER,
  lines_updated  INTEGER,
  lines_input    INTEGER,
  lines_output   INTEGER,
  lines_rejected INTEGER,
  errors         INTEGER
);

-- 步骤日志记录表 添加注释
comment on table ODS_R_EXEC_LOG_STEPS is '步骤执行记录表';
comment on column ODS_R_EXEC_LOG_STEPS.id_batch is '执行次数ID （默认执行一次累加一次）';
comment on column ODS_R_EXEC_LOG_STEPS.log_date is '执行日期';
comment on column ODS_R_EXEC_LOG_STEPS.transname is '转换名称';
comment on column ODS_R_EXEC_LOG_STEPS.stepname is '步骤名';
comment on column ODS_R_EXEC_LOG_STEPS.step_copy is '复制的记录行数';
comment on column ODS_R_EXEC_LOG_STEPS.lines_read is '读';
comment on column ODS_R_EXEC_LOG_STEPS.lines_written is '写';
comment on column ODS_R_EXEC_LOG_STEPS.lines_updated is '更新';
comment on column ODS_R_EXEC_LOG_STEPS.lines_input is '输入';
comment on column ODS_R_EXEC_LOG_STEPS.lines_output is '输出';
comment on column ODS_R_EXEC_LOG_STEPS.lines_rejected is '拒绝';
comment on column ODS_R_EXEC_LOG_STEPS.errors is '错误';

-- 转换日志记录表
create table ODS_R_EXEC_LOG_TRANS
(
  id_batch       INTEGER,
  channel_id     VARCHAR2(255),
  transname      VARCHAR2(255),
  status         VARCHAR2(15),
  lines_read     INTEGER,
  lines_written  INTEGER,
  lines_updated  INTEGER,
  lines_input    INTEGER,
  lines_output   INTEGER,
  lines_rejected INTEGER,
  errors         INTEGER,
  startdate      DATE,
  enddate        DATE,
  logdate        DATE,
  depdate        DATE,
  replaydate     DATE,
  log_field      CLOB
);

commit;