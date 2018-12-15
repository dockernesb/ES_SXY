package com.udatech.sszj.model;

import java.io.Serializable;
import java.util.Date;

/**
 * @author dwc
 * @Title: SszjPjdj
 * @ProjectName creditservice
 * @Description: SSZJ_PJDJ 涉审中介评价等级
 * @date 2018/12/11  14:11
 */
public class SszjPjdj implements Serializable {

    private static final long serialVersionUID = 6329203497299140594L;
    private String id;//主键
    private String tyshxydm;//统一社会信用代码
    private String pjnd;//评价年度
    private String pjdj;//评价等级
    private String pjjg;//评价结果
    private Date createTime;//创建时间
    private String createId;//创建人ID
    private Date updateTime;//更新时间
    private String updateId;//更新人ID

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTyshxydm() {
        return tyshxydm;
    }

    public void setTyshxydm(String tyshxydm) {
        this.tyshxydm = tyshxydm;
    }

    public String getPjnd() {
        return pjnd;
    }

    public void setPjnd(String pjnd) {
        this.pjnd = pjnd;
    }

    public String getPjdj() {
        return pjdj;
    }

    public void setPjdj(String pjdj) {
        this.pjdj = pjdj;
    }

    public String getPjjg() {
        return pjjg;
    }

    public void setPjjg(String pjjg) {
        this.pjjg = pjjg;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateId() {
        return createId;
    }

    public void setCreateId(String createId) {
        this.createId = createId;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateId() {
        return updateId;
    }

    public void setUpdateId(String updateId) {
        this.updateId = updateId;
    }
}
