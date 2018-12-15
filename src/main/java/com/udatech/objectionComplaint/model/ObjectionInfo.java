package com.udatech.objectionComplaint.model;

/**
 * @author beijh
 * @date 2018-11-30 13:29
 */
public class ObjectionInfo {

    private String dataTable; // 表
    private String fieldColumns; // 字段
    private String businessId; // 异议或修复ID
    private String type; // 类型（1：申请，其它待定）
    private String tableKey;
    private String jsz;

    private String id; // 主键
    private String oderColName; // 排序字段名
    private String orderType; // 排序类型

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

    public String getTableKey() {
        return tableKey;
    }

    public void setTableKey(String tableKey) {
        this.tableKey = tableKey;
    }

    public String getJsz() {
        return jsz;
    }

    public void setJsz(String jsz) {
        this.jsz = jsz;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

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
}
