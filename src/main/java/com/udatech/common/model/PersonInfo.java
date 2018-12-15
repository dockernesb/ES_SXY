package com.udatech.common.model;

/**
 * 描述：  个人信息   PersonInfo 
 * 创建人： xulj
 * 创建时间：2017年9月11日下午4:47:57
 */
public class PersonInfo {

	private String dataTable; // 表
	private String fieldColumns; // 字段
	private String sfzh; // 异议或修复ID

	public String getSfzh() {
		return sfzh;
	}

	public void setSfzh(String sfzh) {
		this.sfzh = sfzh;
	}

	private String id; // 主键

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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

}
