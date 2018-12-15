package com.udatech.sszj.model;

import java.io.Serializable;
import java.util.Date;

/**
 * @author dwc
 * @Title: SszjJbxx
 * @ProjectName creditservice
 * @Description: SSZJ_JBXX 涉审中介基本信息表
 * @date 2018/12/11  13:55
 */
public class SszjJbxx implements Serializable {

    private static final long serialVersionUID = 5709756167285566444L;
    private String id;//主键
    private String tyshxydm;//统一社会信用代码
    private String zzjgdm;//组织机构代码
    private String jgqc;//机构全称中文
    private String gszch;//工商注册号（单位注册号）
    private String swJgdm;//税务机构代码
    private String frdbFzr;//法人代表（负责人）
    private String wz;//网址
    private String jydz;//经营地址
    private String lxdh;//联系电话
    private String deptId;//部门选择
    private String fwsx;//服务时限
    private String sfyj;//收费依据
    private String sfbz;//收费标准
    private String fwxm;//服务项目
    private String czlc;//操作流程
    private String dysp;//对应审批
    private Date createTime;//创建时间
    private String createId;//创建人ID
    private Date updateTime;//更新时间
    private String updateId;//更新人ID

    /*非数据库属性*/
    private int rowIndex; // 批量上传记录的行号
    private String type; // 用于区分新增还是修改

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

    public String getZzjgdm() {
        return zzjgdm;
    }

    public void setZzjgdm(String zzjgdm) {
        this.zzjgdm = zzjgdm;
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

    public String getSwJgdm() {
        return swJgdm;
    }

    public void setSwJgdm(String swJgdm) {
        this.swJgdm = swJgdm;
    }

    public String getFrdbFzr() {
        return frdbFzr;
    }

    public void setFrdbFzr(String frdbFzr) {
        this.frdbFzr = frdbFzr;
    }

    public String getWz() {
        return wz;
    }

    public void setWz(String wz) {
        this.wz = wz;
    }

    public String getJydz() {
        return jydz;
    }

    public void setJydz(String jydz) {
        this.jydz = jydz;
    }

    public String getLxdh() {
        return lxdh;
    }

    public void setLxdh(String lxdh) {
        this.lxdh = lxdh;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getFwsx() {
        return fwsx;
    }

    public void setFwsx(String fwsx) {
        this.fwsx = fwsx;
    }

    public String getSfyj() {
        return sfyj;
    }

    public void setSfyj(String sfyj) {
        this.sfyj = sfyj;
    }

    public String getSfbz() {
        return sfbz;
    }

    public void setSfbz(String sfbz) {
        this.sfbz = sfbz;
    }

    public String getFwxm() {
        return fwxm;
    }

    public void setFwxm(String fwxm) {
        this.fwxm = fwxm;
    }

    public String getCzlc() {
        return czlc;
    }

    public void setCzlc(String czlc) {
        this.czlc = czlc;
    }

    public String getDysp() {
        return dysp;
    }

    public void setDysp(String dysp) {
        this.dysp = dysp;
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

    public int getRowIndex() {
        return rowIndex;
    }

    public void setRowIndex(int rowIndex) {
        this.rowIndex = rowIndex;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
