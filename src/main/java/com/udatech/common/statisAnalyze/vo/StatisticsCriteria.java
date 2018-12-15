package com.udatech.common.statisAnalyze.vo;

/**
 * 描述：统计分析搜索字段
 * 创建人：caohy
 * 创建时间：2017年7月20日上午11:16:52
 * 修改人：caohy
 * 修改时间：2017年7月20日上午11:16:52
 */
public class StatisticsCriteria implements java.io.Serializable {
    
    private static final long serialVersionUID = -2529723179886476176L;
    public static final String PIE_DATA = "1";//数据量统计饼图
    public static final String TREND = "2";//趋势图
    public static final String HISTOGRAM = "3";//目录柱状图
    public static final String QUERY_TOTAL = "0";//总计
    public static final String PIE_WAY = "4";//上报方式饼图
    public static final String HISTOGRAM_DEPT = "5";//部门柱状图
    public static final String TREND_DEPT = "6";//趋势图部门

    // 统计主题：0-手动上传；1-文件上传；2-数据库上传；3-FTP上传；
    private String category;
    
    // 统计类型：0-总计；
    private String queryType;
    
    // 图表类型：1-饼图； 2-趋势图； 3-柱状图 ；
    private String chartsType;
    
    // 统计开始期
    private String startDate;
    
    // 统计截止期
    private String endDate;
    
    // 统计部门id
    private String deptId;
    
    //统计目录
    private String tableName;
    
    private String deptQueryType;
    
    public String getDeptQueryType() {
		return deptQueryType;
	}

	public void setDeptQueryType(String deptQueryType) {
		this.deptQueryType = deptQueryType;
	}

	public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }


    public String getChartsType() {
        return chartsType;
    }

    public void setChartsType(String chartsType) {
        this.chartsType = chartsType;
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

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getQueryType() {
        return queryType;
    }

    public void setQueryType(String queryType) {
        this.queryType = queryType;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
    
    
}
