package com.udatech.center.publishedMonthlyReport.model;

import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import java.util.Date;

/**
 * @author IT-20170331ROM3
 * @category 双公示月报表
 * @time 2017-12-05 15:12:27
 */
@Entity
@Table(name = "DT_PUBLISHED_MONTHLY_REPORT")
public class PublishedMonthlyReport {

    private String id;    // 主键
    private SysDepartment dept;    // 部门
    private String month;    // 上报月份
    private String webUrl;    // 本单位公示网址
    private Integer xzxkCssl = 0;    // 行政许可 - 产生数量
    private Integer xzxkBdwgssl = 0;    // 行政许可 - 本单位公示数量
    private Integer xzxkBssl = 0;    // 行政许可 - 报送数量
    private Integer xzxkWbssl = 0;    // 行政许可 - 未报送数量
    private String xzxkWbsyj;    // 行政许可 - 未报送依据
    private Integer xzcfCssl = 0;    // 行政处罚 - 产生数量
    private Integer xzcfBdwgssl = 0;    // 行政处罚 - 本单位公示数量
    private Integer xzcfBssl = 0;    // 行政处罚 - 报送数量
    private Integer xzcfWbssl = 0;    // 行政处罚 - 未报送数量
    private String xzcfWbsyj;    // 行政处罚 - 未报送依据
    private String status;    // 状态（1：正常，2：删除）
    private SysUser createUser;    // 创建人
    private Date createTime;    // 创建时间
    private SysUser updateUser;    // 更新人
    private Date updateTime;    // 更新时间

    private String beginDate;
    private String endDate;

    @Id
    @GenericGenerator(name = "system-uuid", strategy = "uuid.hex")
    @GeneratedValue(generator = "system-uuid")
    @Column(name = "ID", unique = true, nullable = false, length = 50)
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @OneToOne
    @JoinColumn(name = "DEPT_ID")
    public SysDepartment getDept() {
        return dept;
    }

    public void setDept(SysDepartment dept) {
        this.dept = dept;
    }

    @Column(name = "MONTH")
    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    @Column(name = "WEB_URL")
    public String getWebUrl() {
        return webUrl;
    }

    public void setWebUrl(String webUrl) {
        this.webUrl = webUrl;
    }

    @Column(name = "XZXK_CSSL")
    public Integer getXzxkCssl() {
        return xzxkCssl;
    }

    public void setXzxkCssl(Integer xzxkCssl) {
        this.xzxkCssl = xzxkCssl;
    }

    @Column(name = "XZXK_BDWGSSL")
    public Integer getXzxkBdwgssl() {
        return xzxkBdwgssl;
    }

    public void setXzxkBdwgssl(Integer xzxkBdwgssl) {
        this.xzxkBdwgssl = xzxkBdwgssl;
    }

    @Column(name = "XZXK_BSSL")
    public Integer getXzxkBssl() {
        return xzxkBssl;
    }

    public void setXzxkBssl(Integer xzxkBssl) {
        this.xzxkBssl = xzxkBssl;
    }

    @Column(name = "XZXK_WBSSL")
    public Integer getXzxkWbssl() {
        return xzxkWbssl;
    }

    public void setXzxkWbssl(Integer xzxkWbssl) {
        this.xzxkWbssl = xzxkWbssl;
    }

    @Column(name = "XZXK_WBSYJ")
    public String getXzxkWbsyj() {
        return xzxkWbsyj;
    }

    public void setXzxkWbsyj(String xzxkWbsyj) {
        this.xzxkWbsyj = xzxkWbsyj;
    }

    @Column(name = "XZCF_CSSL")
    public Integer getXzcfCssl() {
        return xzcfCssl;
    }

    public void setXzcfCssl(Integer xzcfCssl) {
        this.xzcfCssl = xzcfCssl;
    }

    @Column(name = "XZCF_BDWGSSL")
    public Integer getXzcfBdwgssl() {
        return xzcfBdwgssl;
    }

    public void setXzcfBdwgssl(Integer xzcfBdwgssl) {
        this.xzcfBdwgssl = xzcfBdwgssl;
    }

    @Column(name = "XZCF_BSSL")
    public Integer getXzcfBssl() {
        return xzcfBssl;
    }

    public void setXzcfBssl(Integer xzcfBssl) {
        this.xzcfBssl = xzcfBssl;
    }

    @Column(name = "XZCF_WBSSL")
    public Integer getXzcfWbssl() {
        return xzcfWbssl;
    }

    public void setXzcfWbssl(Integer xzcfWbssl) {
        this.xzcfWbssl = xzcfWbssl;
    }

    @Column(name = "XZCF_WBSYJ")
    public String getXzcfWbsyj() {
        return xzcfWbsyj;
    }

    public void setXzcfWbsyj(String xzcfWbsyj) {
        this.xzcfWbsyj = xzcfWbsyj;
    }

    @Column(name = "STATUS")
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @OneToOne
    @JoinColumn(name = "CREATE_ID")
    public SysUser getCreateUser() {
        return createUser;
    }

    public void setCreateUser(SysUser createUser) {
        this.createUser = createUser;
    }

    @Column(name = "CREATE_TIME")
    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @OneToOne
    @JoinColumn(name = "UPDATE_ID")
    public SysUser getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(SysUser updateUser) {
        this.updateUser = updateUser;
    }

    @Column(name = "UPDATE_TIME")
    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Transient
    public String getBeginDate() {
        return beginDate;
    }

    public void setBeginDate(String beginDate) {
        this.beginDate = beginDate;
    }

    @Transient
    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

}