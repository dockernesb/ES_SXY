package com.udatech.objectionComplaint.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.wa.framework.util.DateUtils;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * @author beijh
 * @date 2018-12-07 14:37
 */
@Entity
@Table(name = "DT_UPLOAD_FILE")
public class DtUploadFile implements Serializable {
    private static final long serialVersionUID = 36927087060132563L;
    private String uploadFileId;
    private String fileName;
    private String filePath;
    private String fileType;
    private Date createDate;
    private String sysUserId;
    private String businessId;
    private String fileviewPath;
    private String icon;

    @Id
    @GeneratedValue(
            strategy = GenerationType.AUTO,
            generator = "uuid"
    )
    @GenericGenerator(
            name = "uuid",
            strategy = "uuid2"
    )
    @Column(name = "UPLOAD_FILE_ID", length = 50)
    public String getUploadFileId() {
        return uploadFileId;
    }

    public void setUploadFileId(String uploadFileId) {
        this.uploadFileId = uploadFileId;
    }

    @Column(name = "FILE_NAME", length = 200)
    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    @Column(name = "FILE_PATH", length = 200)
    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    @Column(name = "FILE_TYPE", length = 50)
    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    @Column(name = "CREATE_DATE")
    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    @Column(name = "SYS_USER_ID", length = 50)
    public String getSysUserId() {
        return sysUserId;
    }

    public void setSysUserId(String sysUserId) {
        this.sysUserId = sysUserId;
    }

    @Column(name = "BUSINESS_ID", length = 50)
    public String getBusinessId() {
        return businessId;
    }

    public void setBusinessId(String businessId) {
        this.businessId = businessId;
    }

    @Column(name = "FILE_VIEWPATH", length = 50)
    public String getFileviewPath() {
        return fileviewPath;
    }

    public void setFileviewPath(String fileviewPath) {
        this.fileviewPath = fileviewPath;
    }

    @Column(name = "ICON", length = 50)
    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }
}
