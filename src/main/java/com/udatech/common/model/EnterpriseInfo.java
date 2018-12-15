package com.udatech.common.model;

/**
 * @category 企业信息(异议用)
 * @author ccl
 */
public class EnterpriseInfo {

	private String bjbh; // 办件编号
	private String jgqc; // 机构全称
	private String gszch; // 工商注册号
	private String zzjgdm; // 组织机构代码
	private String tyshxydm; // 统一社会信用代码
	private String beginDate; // 开始日期
	private String endDate; // 结束日期
	private String status; // 状态(0:待审核,1:待核实,2:已通过,3:未通过,4:已完成)
	private String deptId; // 部门ID
	private String dataTable; // 表
	private String fieldColumns; // 字段
	private String businessId; // 异议或修复ID
	private String type; // 类型（1：申请，其它待定）
	private String tableKey;
	private String deptCode;

	
	
	private String field;
	private String order;

	private String id; // 主键
	private String oderColName; // 排序字段名
	private String orderType; // 排序类型
	public String getOderColName() {
		return oderColName;
	}

	public void setOderColName(String oderColName) {
		this.oderColName = oderColName;
	}

	public String getOrderType() {
		return orderType;
	}

	public void setOrderType(String orderType) {
		this.orderType = orderType;
	}

	private String bjbm;	//	办件部门

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getJgqc() {
		return jgqc;
	}

	public void setJgqc(String jgqc) {
		this.jgqc = jgqc;
	}

	public String getGszch() {
		return gszch;
	}

	public void setGszch(String gszch) {
		this.gszch = gszch;
	}

	public String getZzjgdm() {
		return zzjgdm;
	}

	public void setZzjgdm(String zzjgdm) {
		this.zzjgdm = zzjgdm;
	}

	public String getTyshxydm() {
		return tyshxydm;
	}

	public void setTyshxydm(String tyshxydm) {
		this.tyshxydm = tyshxydm;
	}

	public String getBjbh() {
		return bjbh;
	}

	public void setBjbh(String bjbh) {
		this.bjbh = bjbh;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public String getBusinessId() {
		return businessId;
	}

	public void setBusinessId(String businessId) {
		this.businessId = businessId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDataTable() {
		return dataTable;
	}

	public void setDataTable(String dataTable) {
		this.dataTable = dataTable;
	}

	public String getFieldColumns() {
		return fieldColumns;
	}

	public void setFieldColumns(String fieldColumns) {
		this.fieldColumns = fieldColumns;
	}

	public String getTableKey() {
		return tableKey;
	}

	public void setTableKey(String tableKey) {
		this.tableKey = tableKey;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public String getBjbm() {
		return bjbm;
	}

	public void setBjbm(String bjbm) {
		this.bjbm = bjbm;
	}

}
