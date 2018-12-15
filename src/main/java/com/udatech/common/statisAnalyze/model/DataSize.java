package com.udatech.common.statisAnalyze.model;


public class DataSize {
	public static final String CITY="1";
	public static final String AREA="2";
	public static final String PROVINCE="3";

	private String startDate;
	private String endDate;
	private String deptId;
	private String deptName;
	private long successSize;
	private long failSize;
	private long allSize;
	private String category;
	private String queryType;//1：市 2：区 3：省
    private String successRate;
    private String failRate;
    
	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public long getSuccessSize() {
		return successSize;
	}

	public void setSuccessSize(long successSize) {
		this.successSize = successSize;
	}

	public long getFailSize() {
		return failSize;
	}

	public void setFailSize(long failSize) {
		this.failSize = failSize;
	}

	public long getAllSize() {
		return allSize;
	}

	public void setAllSize(long allSize) {
		this.allSize = allSize;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}

	public String getSuccessRate() {
		return successRate;
	}

	public void setSuccessRate(String successRate) {
		this.successRate = successRate;
	}

	public String getFailRate() {
		return failRate;
	}

	public void setFailRate(String failRate) {
		this.failRate = failRate;
	}

}
