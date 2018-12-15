package com.udatech.common.model;

import com.wa.framework.user.model.SysUser;

import java.util.Date;

/**
 * 自然人信用审查申请历史表
 *
 * @author 创建人：何斐
 * @version 创建时间：2016年5月17日上午9:24:52
 * @Description
 */
public class PCreditExamineHis implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private String id;// 主键
    private String status;// 审核状态 待审核("0"), 审核不通过("1"), 审核通过("2")
    private String opinion;// 审核意见
    private SysUser auditUser;// 审核人
    private Date auditDate;// 审核时间
    private PCreditExamine pCreditExamine;// 信用审查申请类

    public PCreditExamineHis() {
        super();
    }

    public PCreditExamineHis(String id, String status, String opinion, SysUser auditUser, Date auditDate,
                             PCreditExamine PCreditExamine) {
        super();
        this.id = id;
        this.status = status;
        this.opinion = opinion;
        this.auditUser = auditUser;
        this.auditDate = auditDate;
        this.pCreditExamine = PCreditExamine;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getOpinion() {
        return opinion;
    }

    public void setOpinion(String opinion) {
        this.opinion = opinion;
    }

    public SysUser getAuditUser() {
        return auditUser;
    }

    public void setAuditUser(SysUser auditUser) {
        this.auditUser = auditUser;
    }

    public Date getAuditDate() {
        return auditDate;
    }

    public void setAuditDate(Date auditDate) {
        this.auditDate = auditDate;
    }

    public PCreditExamine getpCreditExamine() {
        return pCreditExamine;
    }

    public void setpCreditExamine(PCreditExamine pCreditExamine) {
        this.pCreditExamine = pCreditExamine;
    }

}
