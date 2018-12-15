package com.udatech.sszj.model;

import java.io.Serializable;
import java.util.Date;

/**
 * @author dwc
 * @Title: SszjXycn
 * @ProjectName creditservice
 * @Description: sszj_credit_commitment_qy 涉审中介信用承诺事项关联的中介信息
 * @date 2018/12/13  10:40
 */
public class SszjCreditCommitmentQy implements Serializable {

    private static final long serialVersionUID = -5515720890709317351L;
    private String id;//主键
    private String qymc;//企业名称
    private String gszch;//工商注册号
    private String zzjgdm;//组织机构代码
    private String tyshxydm;//统一社会信用代码
    private String cnlb;//承诺类别
    private String dept_id;//监管部门ID
    private Date create_time;//创建时间
    private String create_user;//创建人ID
    private String yxq;//加入黑名单有效期
    private String clyj;//加入黑名单处理意见

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getQymc() {
        return qymc;
    }

    public void setQymc(String qymc) {
        this.qymc = qymc;
    }

    public String getGszch() {
        return gszch;
    }

    public void setGszch(String gszch) {
        this.gszch = gszch;
    }

    public String getZzjgdm() {
        return zzjgdm;
    }

    public void setZzjgdm(String zzjgdm) {
        this.zzjgdm = zzjgdm;
    }

    public String getTyshxydm() {
        return tyshxydm;
    }

    public void setTyshxydm(String tyshxydm) {
        this.tyshxydm = tyshxydm;
    }

    public String getCnlb() {
        return cnlb;
    }

    public void setCnlb(String cnlb) {
        this.cnlb = cnlb;
    }

    public String getDept_id() {
        return dept_id;
    }

    public void setDept_id(String dept_id) {
        this.dept_id = dept_id;
    }

    public Date getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Date create_time) {
        this.create_time = create_time;
    }

    public String getCreate_user() {
        return create_user;
    }

    public void setCreate_user(String create_user) {
        this.create_user = create_user;
    }

    public String getYxq() {
        return yxq;
    }

    public void setYxq(String yxq) {
        this.yxq = yxq;
    }

    public String getClyj() {
        return clyj;
    }

    public void setClyj(String clyj) {
        this.clyj = clyj;
    }
}
