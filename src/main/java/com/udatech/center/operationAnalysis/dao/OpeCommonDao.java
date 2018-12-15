package com.udatech.center.operationAnalysis.dao;

import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.wa.framework.dao.BaseDao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述：运行分析公用dao（中心端）
 * 创建人：guoyt
 * 创建时间：2017年2月3日上午10:58:34
 * 修改人：guoyt
 * 修改时间：2017年2月3日上午10:58:34
 */
public interface OpeCommonDao extends BaseDao {
    
    /**
     * @Description: 封装统一方法获取图表数据
     * @param: @param dataSourceSql
     * @param: @param param
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public List<Map<String, Object>> getChartDatas(String dataSourceSql, HashMap<String, Object> param);
    
    /**
     * @Description: 根据sql封装图表查询结果
     * @param: @param dataSourceSql
     * @param: @param param
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getAllChartDatas(String dataSourceSql, HashMap<String, Object> param);
    
    /**
     * @Description: 获取所有失信或者诚信记录的最早统计时间
     * @param: @param allDataSql
     * @param: @param param
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String getEarliestDate(String allDataSql, HashMap<String, Object> param);
    
    /**
     * @Description: 统计趋势分析同比、环比、累计等数据开头sql
     * @param: @param OperationCriteria
     * @param: @param isTable 是否用于表格统计
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String getTrendSqlBegin(OperationCriteria operationCriteria, boolean isTable);
    
    /**
     * @Description: 统计趋势分析同比、环比、累计等数据结尾sql
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String getTrendSqlEnd();
    
    /**
     * @Description: 统计表格分析开头sql
     * @param: @param category 区分是区域表格还是行业表格
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String getTableSqlBegin(String category, String orderFiled);
    
    /**
     * @Description: 统计表格分析中间sql,计算累计以及新增同比、环比等数据
     * @param: @param OperationCriteria
     * @param: @param sql
     * @param: @param param
     * @param: @param startDate
     * @param: @param endDate
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public void getTableSqlBetween(OperationCriteria operationCriteria, StringBuffer sql, HashMap<String, Object> param,
                                   String endDate);
    
    /**
     * @Description: 获取需要打印的关键日志字符串
     * @param: @param functionName
     * @param: @param dataSourceSql
     * @param: @param param
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String getLogStr(String functionName, String dataSourceSql, HashMap<String, Object> param);
    
}
