package com.udatech.sszj.model;

import java.io.Serializable;

/**
 * @author dwc
 * @Title: YwLZzDjbg
 * @ProjectName creditservice
 * @Description: TODO
 * @date 2018/12/12  20:20
 */
public class YwLZzDjbg implements Serializable {

    private static final long serialVersionUID = 5990502523529728994L;
    private String id;//主键
    private String zzmc;//资质名称
    private String zsbh;//资质证书编号
    private String zzdj;//资质等级
    private String jgqc;//机构全称中文

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getZzmc() {
        return zzmc;
    }

    public void setZzmc(String zzmc) {
        this.zzmc = zzmc;
    }

    public String getZsbh() {
        return zsbh;
    }

    public void setZsbh(String zsbh) {
        this.zsbh = zsbh;
    }

    public String getZzdj() {
        return zzdj;
    }

    public void setZzdj(String zzdj) {
        this.zzdj = zzdj;
    }

    public String getJgqc() {
        return jgqc;
    }

    public void setJgqc(String jgqc) {
        this.jgqc = jgqc;
    }
}
