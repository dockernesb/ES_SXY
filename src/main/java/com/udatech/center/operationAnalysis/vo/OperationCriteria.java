package com.udatech.center.operationAnalysis.vo;

 
/**
 * 描述：运行分析搜索字段
 * 创建人：guoyt
 * 创建时间：2017年2月3日上午10:57:21
 * 修改人：guoyt
 * 修改时间：2017年2月3日上午10:57:21
 */
public class OperationCriteria implements java.io.Serializable {
    
    private static final long serialVersionUID = -2529723179886476176L;

    // 统计主题：1-信用报告统计；2-异议处理统计；3-信用修复统计；4-信用核查统计；
    private String category;
    
    // 维度分析：1-申诉内容分析； 2-数据提供部门分析； 3-修复内容分析；4-审查类别分析；5-申请部门分析；6-决定日期；7-上报时间
    private String dimension;
    
    // 趋势类别：1-累计；2-新增
    private String trendType;

    // 统计开始期
    private String startDate;
    
    // 统计截止期
    private String endDate;
    
    //部门
    private String department;
    
    // 父级条件 , 如：报告用途、申诉内容、修复内容、审查类别、法人类型、重点人群等
    private String parentCondtion;
    
    // 图表主题：1-分布情况； 2-趋势分析； 
    private String chartTheme;
    
    // 1-行政许可；2-行政处罚
    private String publicityType;

    //区分自然人与法人
    private String personType;

    //市辖部门与区县板块划分
    private String dataSource;

    //办件部门
    private String department_bj;

    private String data;

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getDepartment_bj() {
        return department_bj;
    }

    public void setDepartment_bj(String department_bj) {
        this.department_bj = department_bj;
    }

    public String getDataSource() {
        return dataSource;
    }

    public void setDataSource(String dataSource) {
        this.dataSource = dataSource;
    }

    public String getPersonType() {
        return personType;
    }

    public void setPersonType(String personType) {
        this.personType = personType;
    }

    public String getChartTheme() {
        return chartTheme;
    }

    public void setChartTheme(String chartTheme) {
        this.chartTheme = chartTheme;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDimension() {
        return dimension;
    }

    public void setDimension(String dimension) {
        this.dimension = dimension;
    }

    public String getTrendType() {
        return trendType;
    }

    public void setTrendType(String trendType) {
        this.trendType = trendType;
    }

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

    public String getParentCondtion() {
        return parentCondtion;
    }

    public void setParentCondtion(String parentCondtion) {
        this.parentCondtion = parentCondtion;
    }

    public String getPublicityType() {
        return publicityType;
    }

    public void setPublicityType(String publicityType) {
        this.publicityType = publicityType;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }
    
}
