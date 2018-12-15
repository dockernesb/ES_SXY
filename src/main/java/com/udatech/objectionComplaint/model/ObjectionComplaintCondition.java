package com.udatech.objectionComplaint.model;

public class ObjectionComplaintCondition {
    private String id;
    /**办件编号*/
    private String bjbh;
    /**申诉人姓名*/
    private String name;
    /**驾驶证号/身份证*/
    private String jsz;
    /**申诉时间始*/
    private String startDate;
    /**申诉时间止*/
    private String endDate;
    /**状态*/
    private String status;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getBjbh() {
        return bjbh;
    }

    public void setBjbh(String bjbh) {
        this.bjbh = bjbh;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getJsz() {
        return jsz;
    }

    public void setJsz(String jsz) {
        this.jsz = jsz;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    /**状态*/
    private String state;
}
