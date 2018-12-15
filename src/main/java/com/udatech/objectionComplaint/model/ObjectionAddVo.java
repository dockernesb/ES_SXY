package com.udatech.objectionComplaint.model;

/**
 * @author beijh
 * @date 2018-12-03 14:39
 */
public class ObjectionAddVo {

    private String  complaintType;
    private String  bjbh;
    private String  name;
    private String  jsz;
    private String  sjhm;
    private String  thirdId;
    private String  dataTable;
    private String  ssbz;
    private String[]  zmclName;
    private String[]  zmclPath;

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

    public String getSjhm() {
        return sjhm;
    }

    public void setSjhm(String sjhm) {
        this.sjhm = sjhm;
    }

    public String getThirdId() {
        return thirdId;
    }

    public void setThirdId(String thirdId) {
        this.thirdId = thirdId;
    }

    public String getSsbz() {
        return ssbz;
    }

    public void setSsbz(String ssbz) {
        this.ssbz = ssbz;
    }

    public String[] getZmclName() {
        return zmclName;
    }

    public void setZmclName(String[] zmclName) {
        this.zmclName = zmclName;
    }

    public String[] getZmclPath() {
        return zmclPath;
    }

    public void setZmclPath(String[] zmclPath) {
        this.zmclPath = zmclPath;
    }

    public String getComplaintType() {
        return complaintType;
    }

    public void setComplaintType(String complaintType) {
        this.complaintType = complaintType;
    }

    public String getDataTable() {
        return dataTable;
    }

    public void setDataTable(String dataTable) {
        this.dataTable = dataTable;
    }
}
