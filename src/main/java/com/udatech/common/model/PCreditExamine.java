package com.udatech.common.model;

import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;

import java.util.Date;

/**
 * 自然人信用审查申请表
 * @Description
 * @author 创建人：何斐
 * @version 创建时间：2016年5月17日上午9:24:33
 */
public class PCreditExamine implements java.io.Serializable {
	private static final long serialVersionUID = 1L;
	private String id;
	private SysDepartment scxqbm;// 审查需求部门
	private String scxxl;// 审查信息类
	private String scmc;// 审查名称
	private String scsm;// 审查说明
	private String status;// 审核状态 待审核("0"), 审核不通过("1"), 审核通过("2")
	private Date applyDate;// 申请时间
	private SysUser createUser;// 申请人
	private Date scsjs; // 审查开始时间
	private Date scsjz; // 审查开始时间
	private String bjbh;// 办件编号
	private String scxxlStr;// 审查信息类

	public PCreditExamine() {
		super();
	}

	public PCreditExamine(String id) {
		super();
		this.id = id;
	}

	public PCreditExamine(String id, SysDepartment scxqbm, String scxxl, String scmc, String scsm, String status,
						  Date applyDate, Date scsjs, Date scsjz, SysUser createUser, String bjbh, String scxxlStr) {
		super();
		this.id = id;
		this.scxqbm = scxqbm;
		this.scxxl = scxxl;
		this.scxxlStr = scxxlStr;
		this.scmc = scmc;
		this.scsm = scsm;
		this.status = status;
		this.applyDate = applyDate;
		this.createUser = createUser;
		this.scsjs = scsjs;
		this.scsjz = scsjz;
		this.bjbh = bjbh;
	}

	public String getScxxlStr() {
		return scxxlStr;
	}

	public void setScxxlStr(String scxxlStr) {
		this.scxxlStr = scxxlStr;
	}

	public Date getScsjs() {
		return scsjs;
	}

	public void setScsjs(Date scsjs) {
		this.scsjs = scsjs;
	}

	public Date getScsjz() {
		return scsjz;
	}

	public void setScsjz(Date scsjz) {
		this.scsjz = scsjz;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public SysDepartment getScxqbm() {
		return scxqbm;
	}

	public void setScxqbm(SysDepartment scxqbm) {
		this.scxqbm = scxqbm;
	}

	public String getScxxl() {
		return scxxl;
	}

	public void setScxxl(String scxxl) {
		this.scxxl = scxxl;
	}

	public String getScmc() {
		return scmc;
	}

	public void setScmc(String scmc) {
		this.scmc = scmc;
	}

	public String getScsm() {
		return scsm;
	}

	public void setScsm(String scsm) {
		this.scsm = scsm;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

	public SysUser getCreateUser() {
		return createUser;
	}

	public void setCreateUser(SysUser createUser) {
		this.createUser = createUser;
	}

	public String getBjbh() {
		return bjbh;
	}

	public void setBjbh(String bjbh) {
		this.bjbh = bjbh;
	}

}
