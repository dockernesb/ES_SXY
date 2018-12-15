package com.udatech.common.model;

import java.util.Date;
import java.util.List;

import com.udatech.common.enmu.ReportApplyEnmu;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysUser;

/**
 * <描述>： 企业信用报告申请 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午10:12:33
 */
public class EnterpriseReportApply implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    private String id;// 主键
    private String bjbh;// 办件编号
    private String qymc;// 企业名称
    private String gszch;// 工商注册号
    private String zzjgdm;// 组织机构代码
    private String tyshxydm; // 社会信用代码
    private String jbrxm; // 经办人姓名
    private String jbrsfzhm; // 经办人身份证号码
    private String jbrlxdh; // 经办人联系电话
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

    private String sqzzjgdm;// 授权组织机构代码
    private String sqqymc;// 授权企业名称
    private String sqgszch;// 授权工商注册号
    private String sqtyshxydm; // 授权社会信用代码
    private String type; // 查询类型（0:企业自查,1:委托查询）
    private String purpose; // 申请报告用途（项目申报、招投标、资质认定、财政专项申报、评优选优、申请医保定点、商业贷款、信用调查、信用管理贯标、信用示范创建、信用审核、企业收购、其他）
    private String areaDepts; // 区域部门
    private String projectName;// 项目名称
    private String projectXL;// 项目细类

    
    private String[] yyzzName; // 营业执照附件名称
    private String[] yyzzPath; // 营业执照附件路径
    private List<UploadFile> yyzz;

    private String[] zzjgdmzName; // 组织机构代码证附件名称
    private String[] zzjgdmzPath; // 组织机构代码证附件路径
    private List<UploadFile> zzjgdmz;

    private String[] qysqsName; // 企业授权书附件名称
    private String[] qysqsPath; // 企业授权书附件路径
    private List<UploadFile> qysqs;

    private String[] sfzName; // 身份证附件名称
    private String[] sfzPath; // 身份证附件路径
    private List<UploadFile> sfz;

    private String[] sqqysqsName; // 授权企业授权书附件名称
    private String[] sqqysqsPath; // 授权企业授权书附件路径
    private List<UploadFile> sqqysqs;

    private String[] sqsfzName; // 授权身份证附件名称
    private String[] sqsfzPath; // 授权身份证附件路径
    private List<UploadFile> sqsfz;

    private String[] sqfrzmwjName; // 授权法人证明文件名称
    private String[] sqfrzmwjPath; // 授权法人证明文件路径
    private List<UploadFile> sqfrzmwj;

    private String[] sbgName; // 省报告文件名称
    private String[] sbgPath; // 省报告文件路径
    private List<UploadFile> sbg;

    // 页面展示需要
    private String xybgbh;// 信用报告编号
    private String sqr;// 申请人

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

    public String getJbrxm() {
        return jbrxm;
    }

    public void setJbrxm(String jbrxm) {
        this.jbrxm = jbrxm;
    }

    public String getJbrsfzhm() {
        return jbrsfzhm;
    }

    public void setJbrsfzhm(String jbrsfzhm) {
        this.jbrsfzhm = jbrsfzhm;
    }

    public String getJbrlxdh() {
        return jbrlxdh;
    }

    public void setJbrlxdh(String jbrlxdh) {
        this.jbrlxdh = jbrlxdh;
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

    public String[] getYyzzName() {
        return yyzzName;
    }

    public void setYyzzName(String[] yyzzName) {
        this.yyzzName = yyzzName;
    }

    public String[] getYyzzPath() {
        return yyzzPath;
    }

    public void setYyzzPath(String[] yyzzPath) {
        this.yyzzPath = yyzzPath;
    }

    public String[] getZzjgdmzName() {
        return zzjgdmzName;
    }

    public void setZzjgdmzName(String[] zzjgdmzName) {
        this.zzjgdmzName = zzjgdmzName;
    }

    public String[] getZzjgdmzPath() {
        return zzjgdmzPath;
    }

    public void setZzjgdmzPath(String[] zzjgdmzPath) {
        this.zzjgdmzPath = zzjgdmzPath;
    }

    public String[] getQysqsName() {
        return qysqsName;
    }

    public void setQysqsName(String[] qysqsName) {
        this.qysqsName = qysqsName;
    }

    public String[] getQysqsPath() {
        return qysqsPath;
    }

    public void setQysqsPath(String[] qysqsPath) {
        this.qysqsPath = qysqsPath;
    }

    public String[] getSfzName() {
        return sfzName;
    }

    public void setSfzName(String[] sfzName) {
        this.sfzName = sfzName;
    }

    public String[] getSfzPath() {
        return sfzPath;
    }

    public void setSfzPath(String[] sfzPath) {
        this.sfzPath = sfzPath;
    }

    public List<UploadFile> getYyzz() {
        return yyzz;
    }

    public void setYyzz(List<UploadFile> yyzz) {
        this.yyzz = yyzz;
    }

    public List<UploadFile> getZzjgdmz() {
        return zzjgdmz;
    }

    public void setZzjgdmz(List<UploadFile> zzjgdmz) {
        this.zzjgdmz = zzjgdmz;
    }

    public List<UploadFile> getQysqs() {
        return qysqs;
    }

    public void setQysqs(List<UploadFile> qysqs) {
        this.qysqs = qysqs;
    }

    public List<UploadFile> getSfz() {
        return sfz;
    }

    public void setSfz(List<UploadFile> sfz) {
        this.sfz = sfz;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
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

    public String getSqzzjgdm() {
        return sqzzjgdm;
    }

    public void setSqzzjgdm(String sqzzjgdm) {
        this.sqzzjgdm = sqzzjgdm;
    }

    public String getSqqymc() {
        return sqqymc;
    }

    public void setSqqymc(String sqqymc) {
        this.sqqymc = sqqymc;
    }

    public String getSqgszch() {
        return sqgszch;
    }

    public void setSqgszch(String sqgszch) {
        this.sqgszch = sqgszch;
    }

    public String getSqtyshxydm() {
        return sqtyshxydm;
    }

    public void setSqtyshxydm(String sqtyshxydm) {
        this.sqtyshxydm = sqtyshxydm;
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

    public String[] getSqqysqsName() {
        return sqqysqsName;
    }

    public void setSqqysqsName(String[] sqqysqsName) {
        this.sqqysqsName = sqqysqsName;
    }

    public String[] getSqqysqsPath() {
        return sqqysqsPath;
    }

    public void setSqqysqsPath(String[] sqqysqsPath) {
        this.sqqysqsPath = sqqysqsPath;
    }

    public List<UploadFile> getSqqysqs() {
        return sqqysqs;
    }

    public void setSqqysqs(List<UploadFile> sqqysqs) {
        this.sqqysqs = sqqysqs;
    }

    public String[] getSqsfzName() {
        return sqsfzName;
    }

    public void setSqsfzName(String[] sqsfzName) {
        this.sqsfzName = sqsfzName;
    }

    public String[] getSqsfzPath() {
        return sqsfzPath;
    }

    public void setSqsfzPath(String[] sqsfzPath) {
        this.sqsfzPath = sqsfzPath;
    }

    public List<UploadFile> getSqsfz() {
        return sqsfz;
    }

    public void setSqsfz(List<UploadFile> sqsfz) {
        this.sqsfz = sqsfz;
    }

    public String[] getSqfrzmwjName() {
        return sqfrzmwjName;
    }

    public void setSqfrzmwjName(String[] sqfrzmwjName) {
        this.sqfrzmwjName = sqfrzmwjName;
    }

    public String[] getSqfrzmwjPath() {
        return sqfrzmwjPath;
    }

    public void setSqfrzmwjPath(String[] sqfrzmwjPath) {
        this.sqfrzmwjPath = sqfrzmwjPath;
    }

    public List<UploadFile> getSqfrzmwj() {
        return sqfrzmwj;
    }

    public void setSqfrzmwj(List<UploadFile> sqfrzmwj) {
        this.sqfrzmwj = sqfrzmwj;
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

    public String[] getSbgName() {
        return sbgName;
    }

    public void setSbgName(String[] sbgName) {
        this.sbgName = sbgName;
    }

    public String[] getSbgPath() {
        return sbgPath;
    }

    public void setSbgPath(String[] sbgPath) {
        this.sbgPath = sbgPath;
    }

    public List<UploadFile> getSbg() {
        return sbg;
    }

    public void setSbg(List<UploadFile> sbg) {
        this.sbg = sbg;
    }

    public String getAreaDepts() {
        return areaDepts;
    }

    public void setAreaDepts(String areaDepts) {
        this.areaDepts = areaDepts;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getProjectXL() {
        return projectXL;
    }

    public void setProjectXL(String projectXL) {
        this.projectXL = projectXL;
    }

}
