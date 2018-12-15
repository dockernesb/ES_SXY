package com.udatech.sszj.model;

import java.io.Serializable;
import java.util.Date;

/**
 * @author dwc
 * @Title: SszjZyry
 * @ProjectName creditservice
 * @Description: SSZJ_ZYRY 涉审中介执业人员
 * @date 2018/12/11  14:16
 */
public class SszjZyry implements Serializable {

    private static final long serialVersionUID = 7965425695215347645L;

    private String id;//主键
    private String tyshxydm;//统一社会信用代码
    private String xm;//姓名
    private String sfzh;//身份证号
    private String zzZsmc;//资质证书名称
    private String zzZsbh;//资质证书编号
    private String zzDj;//资质等级
    private Date createTime;//创建时间
    private String createId;//创建人ID
    private Date updateTime;//更新时间
    private String updateId;//更新人ID
    private Date zzsxqTime;//资质生效期
    private Date zzjzqTime;//资质截止期

    /*非数据库属性*/
    private int rowIndex; // 批量上传记录的行号

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

    public String getXm() {
        return xm;
    }

    public void setXm(String xm) {
        this.xm = xm;
    }

    public String getSfzh() {
        return sfzh;
    }

    public void setSfzh(String sfzh) {
        this.sfzh = sfzh;
    }

    public String getZzZsmc() {
        return zzZsmc;
    }

    public void setZzZsmc(String zzZsmc) {
        this.zzZsmc = zzZsmc;
    }

    public String getZzZsbh() {
        return zzZsbh;
    }

    public void setZzZsbh(String zzZsbh) {
        this.zzZsbh = zzZsbh;
    }

    public String getZzDj() {
        return zzDj;
    }

    public void setZzDj(String zzDj) {
        this.zzDj = zzDj;
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

    public Date getZzsxqTime() {
        return zzsxqTime;
    }

    public void setZzsxqTime(Date zzsxqTime) {
        this.zzsxqTime = zzsxqTime;
    }

    public Date getZzjzqTime() {
        return zzjzqTime;
    }

    public void setZzjzqTime(Date zzjzqTime) {
        this.zzjzqTime = zzjzqTime;
    }

    public int getRowIndex() {
        return rowIndex;
    }

    public void setRowIndex(int rowIndex) {
        this.rowIndex = rowIndex;
    }
}
