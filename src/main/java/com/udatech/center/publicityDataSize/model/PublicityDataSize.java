package com.udatech.center.publicityDataSize.model;

/**
 * 双公示数据量统计
 */
public class PublicityDataSize {

    private String startDate;
    private String endDate;
    private String deptId;
    private String zt;  //  统计主体(B:区县,A:部门)

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

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getZt() {
        return zt;
    }

    public void setZt(String zt) {
        this.zt = zt;
    }

}
