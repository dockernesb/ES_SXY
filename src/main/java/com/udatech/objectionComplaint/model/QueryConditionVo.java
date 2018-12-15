package com.udatech.objectionComplaint.model;

/**
 * @author beijh
 * @date 2018-12-04 13:11
 */
public class QueryConditionVo {
    //办件编号
    private String bjbh;
    //申诉人姓名
    private String name;
    //申诉人驾驶证
    private String jsz;
    //开始时间
    private String beginDate;
    //结束时间
    private String endDate;

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
}
