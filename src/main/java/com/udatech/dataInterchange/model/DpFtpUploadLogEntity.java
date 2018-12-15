package com.udatech.dataInterchange.model;

import java.util.Date;
import java.util.Objects;

public class DpFtpUploadLogEntity {
    private String id;
    private String tableCode;
    private String xmlFileLocalPath;
    private Date createTime;
    private String ftpStatus;
    private Date ftpTime;
    private Integer currentPage;
    private Integer allPage;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTableCode() {
        return tableCode;
    }

    public void setTableCode(String tableCode) {
        this.tableCode = tableCode;
    }

    public String getXmlFileLocalPath() {
        return xmlFileLocalPath;
    }

    public void setXmlFileLocalPath(String xmlFileLocalPath) {
        this.xmlFileLocalPath = xmlFileLocalPath;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getFtpStatus() {
        return ftpStatus;
    }

    public void setFtpStatus(String ftpStatus) {
        this.ftpStatus = ftpStatus;
    }

    public Date getFtpTime() {
        return ftpTime;
    }

    public void setFtpTime(Date ftpTime) {
        this.ftpTime = ftpTime;
    }

    public Integer getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(Integer currentPage) {
        this.currentPage = currentPage;
    }

    public Integer getAllPage() {
        return allPage;
    }

    public void setAllPage(Integer allPage) {
        this.allPage = allPage;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DpFtpUploadLogEntity that = (DpFtpUploadLogEntity) o;
        return Objects.equals(id, that.id) &&
                Objects.equals(tableCode, that.tableCode) &&
                Objects.equals(xmlFileLocalPath, that.xmlFileLocalPath) &&
                Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {

        return Objects.hash(id, tableCode, xmlFileLocalPath, createTime);
    }
}
