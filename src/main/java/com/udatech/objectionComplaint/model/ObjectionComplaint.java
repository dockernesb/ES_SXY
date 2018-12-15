package com.udatech.objectionComplaint.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.wa.framework.util.DateUtils;
import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.Date;

/**
 * 异议申请表
 * @author beijh
 * @date 2018-11-29 15:23
 */
@Entity
@Table(name = "DT_OBJECTION_COMPLAINT")
public class ObjectionComplaint implements java.io.Serializable {

    private static final long serialVersionUID = -3339693924314580821L;

    public static final String COMPLAINT_APPLYING ="0";//申请中
    public static final String COMPLAINT_AUDIT ="1";//已初审
    public static final String COMPLAINT_SECOND_AUDIT ="2";//已终审

    private String id;
    //申请类型
    private String complaintType;
    //申请人姓名
    private String name;
    //申请驾驶证
    private String jsz;
    //申请手机
    private String phoneNumber;
    //申诉备注
    private String ssbz;
    //申请时间
    private Date createDate;
    //申请记录人Id
    private String createId;
    //申请状态（0：申请中，1：已初审，2：已终审）
    private String state;
    //申请主表的id
    private String linkId;
    //申办件编号
    private String bjbh;
    //申请申诉的类型（1：申诉失信等级 2：申诉失信记录）
    private String type;
    //申诉数据表
    private String dataTable;
    //申诉途径
    private String source;


    @Id
    @GeneratedValue(
            strategy = GenerationType.AUTO,
            generator = "uuid"
    )
    @GenericGenerator(
            name = "uuid",
            strategy = "uuid2"
    )
    @Column(name = "ID", length = 50)
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Column(name = "COMPLAINT_TYPE", length = 50)
    public String getComplaintType() {
        return complaintType;
    }

    public void setComplaintType(String complaintType) {
        this.complaintType = complaintType;
    }

    @Column(name = "NAME", length = 50)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "JSZ", length = 50)
    public String getJsz() {
        return jsz;
    }

    public void setJsz(String jsz) {
        this.jsz = jsz;
    }

    @Column(name = "PHONE_NUMBER", length = 50)
    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Column(name = "SSBZ", length = 2000)
    public String getSsbz() {
        return ssbz;
    }

    public void setSsbz(String ssbz) {
        this.ssbz = ssbz;
    }

    @Column(name = "CREATE_DATE")
    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    @Column(name = "CREATE_ID", length = 50)
    public String getCreateId() {
        return createId;
    }

    public void setCreateId(String createId) {
        this.createId = createId;
    }

    @Column(name = "STATE", length = 4)
    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    @Column(name = "LINK_ID", length = 50)
    public String getLinkId() {
        return linkId;
    }

    public void setLinkId(String linkId) {
        this.linkId = linkId;
    }

    @Column(name = "BJBH", length = 50)
    public String getBjbh() {
        return bjbh;
    }

    public void setBjbh(String bjbh) {
        this.bjbh = bjbh;
    }

    @Column(name = "TYPE", length = 4)
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Column(name = "DATA_TABLE", length = 50)
    public String getDataTable() {
        return dataTable;
    }

    public void setDataTable(String dataTable) {
        this.dataTable = dataTable;
    }

    @Column(name = "SOURCE", length = 50)
    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }
}
