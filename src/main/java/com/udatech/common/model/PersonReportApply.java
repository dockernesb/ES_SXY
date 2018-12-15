package com.udatech.common.model;

import com.udatech.common.enmu.ReportApplyEnmu;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysUser;

import java.util.Date;
import java.util.List;

/**
 * <描述>：自然人信用报告申请 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午10:12:33
 */
public class PersonReportApply implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    private String id;// 主键
    private String bjbh;// 办件编号
    private String cxrxm;// 查询人姓名
    private String cxrsfzh;// 查询人身份证号
    private String wtrxm; // 委托人姓名
    private String wtrsfzh; // 委托人身份证号码
    private String wtrlxdh; // 委托人联系电话
    private Date sqbgqssj; // 申请报告起始时间
    private Date sqbgjzsj; // 申请报告截止时间
    private String bz; // 备注
    private String status = ReportApplyEnmu.待审核.getKey(); // 处理状态(0:待审核,1:已通过,2:未通过)
    private SysUser createUser;// 录入人
    private SysUser updateUser;// 修改人
    private Date createDate;// 申请时间
    private String zxshyj; // 中心审核意见
    private SysUser zxshr; // 中心审核人
    private Date zxshsj; // 中心审核时间

    private String isHasBasic; // 是否有企业基本信息（0：无，1：有）
    private String isHasReport; // 是否有省报告（0：无，1：有）
    private String noReportCause; // 无省报告的原因
    private String isIssue; // 是否已下发（0：未下发，1：已下发）
    private String issueOpition; // 下发意见
    private Date issueDate; // 下发时间
    private String isAuditBack; // 是否已退回审核（0：未退回，1：已退回）
    private Date auditBackDate; // 审核退回时间
    private String auditBackUser; // 审核退回用户id

    private String type; // 查询类型（0:本人自查,1:委托查询）
    private String purpose; // 申请报告用途（0信用审核、1其它）

    private String[] cxrsfzName; // 查询人身份证附件名称
    private String[] cxrsfzPath; // 查询人身份证附件路径
    private List<UploadFile> cxrsfz;

    private String[] wtrsfzName; // 委托人身份证附件名称
    private String[] wtrsfzPath; // 委托人身份证附件路径
    private List<UploadFile> wtrsfz;

    private String[] wtsqsName; // 委托授权书附件名称
    private String[] wtsqsPath; // 委托授权书附件路径
    private List<UploadFile> wtsqs;

    // 页面展示需要
    private String xybgbh;// 信用报告编号
    private String sqr;// 申请人

    private String beginDate; // 开始日期
    private String endDate; // 结束日期

    private String bjbm;

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

    public String getXybgbh() {
        return xybgbh;
    }

    public void setXybgbh(String xybgbh) {
        this.xybgbh = xybgbh;
    }

    public String getSqr() {
        return sqr;
    }

    public void setSqr(String sqr) {
        this.sqr = sqr;
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

    public String getCxrxm() {
        return cxrxm;
    }

    public void setCxrxm(String cxrxm) {
        this.cxrxm = cxrxm;
    }

    public String getCxrsfzh() {
        return cxrsfzh;
    }

    public void setCxrsfzh(String cxrsfzh) {
        this.cxrsfzh = cxrsfzh;
    }

    public String getWtrxm() {
        return wtrxm;
    }

    public void setWtrxm(String wtrxm) {
        this.wtrxm = wtrxm;
    }

    public String getWtrsfzh() {
        return wtrsfzh;
    }

    public void setWtrsfzh(String wtrsfzh) {
        this.wtrsfzh = wtrsfzh;
    }

    public String getWtrlxdh() {
        return wtrlxdh;
    }

    public void setWtrlxdh(String wtrlxdh) {
        this.wtrlxdh = wtrlxdh;
    }

    public Date getSqbgqssj() {
        return sqbgqssj;
    }

    public void setSqbgqssj(Date sqbgqssj) {
        this.sqbgqssj = sqbgqssj;
    }

    public Date getSqbgjzsj() {
        return sqbgjzsj;
    }

    public void setSqbgjzsj(Date sqbgjzsj) {
        this.sqbgjzsj = sqbgjzsj;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public SysUser getCreateUser() {
        return createUser;
    }

    public void setCreateUser(SysUser createUser) {
        this.createUser = createUser;
    }

    public SysUser getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(SysUser updateUser) {
        this.updateUser = updateUser;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getZxshyj() {
        return zxshyj;
    }

    public void setZxshyj(String zxshyj) {
        this.zxshyj = zxshyj;
    }

    public SysUser getZxshr() {
        return zxshr;
    }

    public void setZxshr(SysUser zxshr) {
        this.zxshr = zxshr;
    }

    public Date getZxshsj() {
        return zxshsj;
    }

    public void setZxshsj(Date zxshsj) {
        this.zxshsj = zxshsj;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String[] getCxrsfzName() {
        return cxrsfzName;
    }

    public void setCxrsfzName(String[] cxrsfzName) {
        this.cxrsfzName = cxrsfzName;
    }

    public String[] getCxrsfzPath() {
        return cxrsfzPath;
    }

    public void setCxrsfzPath(String[] cxrsfzPath) {
        this.cxrsfzPath = cxrsfzPath;
    }

    public List<UploadFile> getCxrsfz() {
        return cxrsfz;
    }

    public void setCxrsfz(List<UploadFile> cxrsfz) {
        this.cxrsfz = cxrsfz;
    }

    public String[] getWtrsfzName() {
        return wtrsfzName;
    }

    public void setWtrsfzName(String[] wtrsfzName) {
        this.wtrsfzName = wtrsfzName;
    }

    public String[] getWtrsfzPath() {
        return wtrsfzPath;
    }

    public void setWtrsfzPath(String[] wtrsfzPath) {
        this.wtrsfzPath = wtrsfzPath;
    }

    public List<UploadFile> getWtrsfz() {
        return wtrsfz;
    }

    public void setWtrsfz(List<UploadFile> wtrsfz) {
        this.wtrsfz = wtrsfz;
    }

    public String[] getWtsqsName() {
        return wtsqsName;
    }

    public void setWtsqsName(String[] wtsqsName) {
        this.wtsqsName = wtsqsName;
    }

    public String[] getWtsqsPath() {
        return wtsqsPath;
    }

    public void setWtsqsPath(String[] wtsqsPath) {
        this.wtsqsPath = wtsqsPath;
    }

    public List<UploadFile> getWtsqs() {
        return wtsqs;
    }

    public void setWtsqs(List<UploadFile> wtsqs) {
        this.wtsqs = wtsqs;
    }

    public String getIsHasBasic() {
        return isHasBasic;
    }

    public void setIsHasBasic(String isHasBasic) {
        this.isHasBasic = isHasBasic;
    }

    public String getIsHasReport() {
        return isHasReport;
    }

    public void setIsHasReport(String isHasReport) {
        this.isHasReport = isHasReport;
    }

    public String getNoReportCause() {
        return noReportCause;
    }

    public void setNoReportCause(String noReportCause) {
        this.noReportCause = noReportCause;
    }

    public String getIsIssue() {
        return isIssue;
    }

    public void setIsIssue(String isIssue) {
        this.isIssue = isIssue;
    }

    public String getIssueOpition() {
        return issueOpition;
    }

    public void setIssueOpition(String issueOpition) {
        this.issueOpition = issueOpition;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public String getIsAuditBack() {
        return isAuditBack;
    }

    public void setIsAuditBack(String isAuditBack) {
        this.isAuditBack = isAuditBack;
    }

    public Date getAuditBackDate() {
        return auditBackDate;
    }

    public void setAuditBackDate(Date auditBackDate) {
        this.auditBackDate = auditBackDate;
    }

    public String getAuditBackUser() {
        return auditBackUser;
    }

    public void setAuditBackUser(String auditBackUser) {
        this.auditBackUser = auditBackUser;
    }

    public String getBjbm() {
        return bjbm;
    }

    public void setBjbm(String bjbm) {
        this.bjbm = bjbm;
    }

}
