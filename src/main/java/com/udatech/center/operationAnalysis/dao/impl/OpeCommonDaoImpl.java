package com.udatech.center.operationAnalysis.dao.impl;

import com.udatech.center.operationAnalysis.dao.OpeCommonDao;
import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.udatech.common.constant.Constants;
import com.udatech.common.util.ReportDateUtil;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.util.DateUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 描述：运行分析公用dao实现类（中心端）
 * 创建人：guoyt
 * 创建时间：2017年2月3日上午11:04:53
 * 修改人：guoyt
 * 修改时间：2017年2月3日上午11:04:53
 */
@Repository
public class OpeCommonDaoImpl extends BaseDaoImpl implements OpeCommonDao {
    
    /**
     * @Description: 封装统一方法获取图表数据
     * @param: @param dataSourceSql
     * @param: @param param
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public List<Map<String, Object>> getChartDatas(String dataSourceSql, HashMap<String, Object> param) {
        List<Map<String, Object>> list = this.findBySql(dataSourceSql, param);
        return list;
    }
    
    /**
     * @Description: 根据sql封装图表查询结果
     * @param: @param dataSourceSql
     * @param: @param param
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getAllChartDatas(String dataSourceSql, HashMap<String, Object> param) {
        List<Map<String, Object>> dataList = getChartDatas(dataSourceSql, param);
        
        List<String> keyList = new ArrayList<String>();
        if (dataList != null && dataList.size() > 0){
            Map<String, Object> data = dataList.get(0);
            for (Entry<String, Object> main : data.entrySet()) {
                keyList.add(main.getKey());
            }
        }
        
        Map<String,Object> dataMap = new HashMap<String, Object>();
        for (String key : keyList) {
            List<Object> list = new ArrayList<Object>();
            dataMap.put(key, list);
        }
        
        
        Map<String, Object> chartsMap = new HashMap<String, Object>();
        for(Map<String, Object> data : dataList ){
            for (Entry<String, Object> main : data.entrySet()) {
                String key = main.getKey();
                Object value = main.getValue();
                
                List<Object> dataKeyList = (List<Object>) dataMap.get(key);
                dataKeyList.add(value);
            }
        }
        
        for (Entry<String, Object> main : dataMap.entrySet()) {
            String key = main.getKey();
            Object value = main.getValue();
            
            chartsMap.put(key, value);
        }
        
        return chartsMap;
    }
    
    /**
     * @Description: 获取所有记录的最早统计时间
     * @param: @param OperationCriteria
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String getEarliestDate (String allDataSql, HashMap<String, Object> param){
        StringBuffer sql = new StringBuffer();
        sql.append("select min(happendate) as happendate from ( ");
        sql.append(allDataSql);
        sql.append(") bb");
        
        List<Map<String, Object>> list = this.findBySql(sql.toString(), param);
        
        String formatHappendate = "";
        if (list != null && list.size() > 0){
            Map<String, Object> map = list.get(0);
            
            String happendate = MapUtils.getString(map, "HAPPENDATE", "");
            if (StringUtils.isNotEmpty(happendate)){
                SimpleDateFormat fmt = new SimpleDateFormat(DateUtils.YYYYMMDDHHMMSS_19);
                formatHappendate = fmt.format(DateUtils.parseDate(happendate.replace(".0", ""), DateUtils.YYYYMMDDHHMMSS_19));
            }
        }
        
        return formatHappendate;
    }
    
    /**
     * @Description: 统计趋势分析同比、环比、累计等数据开头sql
     * @param: @param OperationCriteria
     * @param: @param isTable 是否用于表格统计
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String getTrendSqlBegin(OperationCriteria operationCriteria, boolean isTable) {
        StringBuffer sql = new StringBuffer();
        
        // 如果是表格统计，需要同时统计累计数、累计环比、新增数、新增占比、新增环比、新增同比
        if (isTable){
            sql.append("select category as shijian, leiji, total as xinzeng,");
            sql.append("case when sumtotal = 0 then 0 else round(100 * total/sumtotal, 2) end as xzzhanbi,");
            sql.append("case when leijitotal = 0 then 0 else round(100 * leiji/leijitotal, 2) end as ljzhanbi,");
            sql.append("case when (lag(leiji,1,0) over(order by category)) = 0 then 0 else nvl(round(leiji/lag(leiji,1,0) over(order by category)*100,2)-100,'0') end as ljhuanbi, ");
            sql.append("case when (lag(total,1,0) over(order by category)) = 0 then 0 else nvl(round(total/lag(total,1,0) over(order by category)*100,2)-100,'0') end as xzhuanbi, ");
            sql.append("case when (lag(total,12,0) over(order by category)) = 0 then 0 else nvl(round(total/lag(total,12,0) over(order by category)*100,2)-100,'0') end as xztongbi ");
        } else {
            if (Constants.TREND_TYPE_LEIJI.equals(operationCriteria.getTrendType())){
                sql.append("select category, leiji as total, ");
                sql.append("case when (lag(leiji,1,0) over(order by category)) = 0 then 0 else nvl(round(leiji/lag(leiji,1,0) over(order by category)*100,2)-100,'0') end as huanbi ");
            } else {
                sql.append("select category, total, ");
                sql.append("case when (lag(total,1,0) over(order by category)) = 0 then 0 else nvl(round(total/lag(total,1,0) over(order by category)*100,2)-100,'0') end as huanbi, ");
                sql.append("case when (lag(total,12,0) over(order by category)) = 0 then 0 else nvl(round(total/lag(total,12,0) over(order by category)*100,2)-100,'0') end as tongbi ");
            }
        }
        
        sql.append("from (select category, total, SUM(total) OVER(ORDER BY category RANGE UNBOUNDED PRECEDING) as leiji ");
        
        // 表格需要计算报告用途占比
        if (isTable){
            sql.append(", sumtotal, SUM(sumtotal) OVER(ORDER BY category RANGE UNBOUNDED PRECEDING) as leijitotal ");
        }
        sql.append("from (select yearMonth as category, case when total is null then 0 else total end as total ");
        
        // 表格需要计算报告用途占比
        if (isTable){
            sql.append(",");
            sql.append(getProportionSql(operationCriteria));
        }
        sql.append("from (SELECT TO_CHAR(add_months(to_date('").append(operationCriteria.getStartDate().substring(0,7));
        sql.append("', 'yyyy-mm'), ROWNUM - 1), 'YYYY-MM') as yearMonth FROM DUAL ");
        sql.append("CONNECT BY ROWNUM <= (select months_between(add_months(to_date('").append(operationCriteria.getEndDate().substring(0,7));
        sql.append("', 'yyyy-mm'),1), to_date('").append(operationCriteria.getStartDate().substring(0,7));
        sql.append("', 'yyyy-mm')) from dual )) tt ");
        sql.append("left join ( ");

        return sql.toString();
    }
    
    /**
     * @Description: 表格下钻之后需要计算报告用途占比
     * @param: @param operationCriteria
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    private String getProportionSql(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();
        if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
            sql.append("(select count(1) from DT_ENTERPRISE_REPORT_APPLY g ");
            sql.append("where to_char(g.create_date, 'yyyy-MM') = tt.yearMonth) as sumtotal ");
        } else if (Constants.CATEGORY_OBJECTION_HANDLING.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_APPEAL_CONTENT.equals(operationCriteria.getDimension())){
                sql.append("(select count(1) from DT_ENTERPRISE_OBJECTION g ");
                sql.append("left join DT_ENTERPRISE_CREDIT d on g.id = d.business_id ");
                sql.append("where to_char(g.create_date, 'yyyy-MM') = tt.yearMonth) as sumtotal ");
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append("(select count(1) from DT_ENTERPRISE_OBJECTION g ");
                sql.append("where to_char(g.create_date, 'yyyy-MM') = tt.yearMonth) as sumtotal ");
            } 
        } else if (Constants.CATEGORY_CREDIT_REPAIR.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_REPAIR_CONTENT.equals(operationCriteria.getDimension())){
                sql.append("(select count(1) from DT_ENTERPRISE_REPAIR g ");
                sql.append("left join DT_ENTERPRISE_CREDIT d on g.id = d.business_id ");
                sql.append("where to_char(g.create_date, 'yyyy-MM') = tt.yearMonth) as sumtotal ");
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append("(select count(1) from DT_ENTERPRISE_REPAIR g ");
                sql.append("where to_char(g.create_date, 'yyyy-MM') = tt.yearMonth) as sumtotal ");
            } 
        } else if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())){
                sql.append("(select count(1) from (select d.dict_value dict_value, d.dict_key from sys_dictionary d ");
                sql.append("left join sys_dictionary_group g on d.group_id = g.id where g.group_key = 'reviewCategory') ");
                sql.append("left join (select gg.scxxl, gg.apply_date as happendate from dt_credit_examine gg ");
                sql.append("left join dt_enterprise_examine d on gg.id = d.credit_examine_id)tt on instr(tt.scxxl, dict_value) > 0 ");
                sql.append("where to_char(happendate, 'yyyy-MM') = tt.yearMonth) as sumtotal ");
            } else if (Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())){
                sql.append("(select count(1) from dt_credit_examine g ");
                sql.append("left join dt_enterprise_examine d on g.id = d.credit_examine_id ");
                sql.append("where to_char(g.apply_date, 'yyyy-MM') = tt.yearMonth) as sumtotal ");
            } 
        } 
        
        return sql.toString();
    }
    
    /** 
     * @Description: 统计趋势分析同比、环比、累计等数据结尾sql
     * @see： @see com.udatech.center.multipleAnalysis.dao.MultiCommonDao#getTrendSqlEnd()
     * @since JDK 1.6
     */
    public String getTrendSqlEnd() {
        String sql = ")yyy on tt.yearMonth = yyy.category order by yearMonth)) ";
        return sql;
    }
    
    /** 
     * @Description: 统计表格分析开头sql
     * @see： @see com.udatech.center.multipleAnalysis.dao.MultiCommonDao#getTableSqlBegin()
     * @since JDK 1.6
     */
    public String getTableSqlBegin(String category, String orderField) {
        StringBuffer sql = new StringBuffer();
        sql.append("select category as shijian, ljthismonth as leiji, round(100 * ratio_to_report(ljthismonth) OVER(), 2) as ljzhanbi, ");
        sql.append("case when ljlastmonth = 0 then 0 else round(100 * (ljthismonth-ljlastmonth)/ljlastmonth,2) end as ljhuanbi, ");
        sql.append("xzthismonth as xinzeng, round(100 * ratio_to_report(xzthismonth) OVER(), 2) as xzzhanbi, ");
        sql.append("case when xzlastmonth = 0 then 0 else round(100 * (xzthismonth-xzlastmonth)/xzlastmonth,2) end as xzhuanbi, ");
        sql.append("case when xzlastyearmonth = 0 then 0 else round(100 * (xzthismonth-xzlastyearmonth)/xzlastyearmonth,2) end as xztongbi from( ");
        
        if (StringUtils.isNotEmpty(orderField)) {
        	sql.append("select distinct ").append(category).append(" as category, ").append(orderField).append(", ").append("case when ljthismonth is null then 0 else ljthismonth end as ljthismonth, ");
        } else {
        	sql.append("select distinct ").append(category).append(" as category, ").append("case when ljthismonth is null then 0 else ljthismonth end as ljthismonth, ");
        }
        sql.append("case when ljlastmonth is null then 0 else ljlastmonth end as ljlastmonth, ");
        sql.append("case when xzthismonth is null then 0 else xzthismonth end as xzthismonth, ");
        sql.append("case when xzlastmonth is null then 0 else xzlastmonth end as xzlastmonth, ");
        sql.append("case when xzlastyearmonth is null then 0 else xzlastyearmonth end as xzlastyearmonth ");
        
        return sql.toString();
    }
    
    /** 
     * @Description: 统计表格分析中间sql,计算累计以及新增同比、环比等数据
     * @see： @see com.udatech.center.multipleAnalysis.dao.MultiCommonDao#getTableSqlBetween(com.udatech.center.multipleAnalysis.vo.OperationCriteria, java.lang.StringBuffer, java.util.HashMap, java.lang.String, java.lang.String)
     * @since JDK 1.6
     */
    public void getTableSqlBetween(OperationCriteria operationCriteria, StringBuffer sql, HashMap<String, Object> param,
                                   String endDate) {
        sql.append(getTimeStatisticsSql(operationCriteria, "ljthis", param));

        // 计算累计上个月数据
        String ljlastEndDate = ReportDateUtil.getAddMonthStr(operationCriteria.getEndDate(), -1);
        operationCriteria.setEndDate(ReportDateUtil.getEndDayOfMonth(ljlastEndDate, DateUtils.YYYYMMDDHHMMSS_19));
        sql.append(getTimeStatisticsSql(operationCriteria, "ljlast", param));

        // 计算新增本月数据
        operationCriteria.setStartDate(ReportDateUtil.getStartDayOfMonth(endDate, DateUtils.YYYYMMDDHHMMSS_19));
        operationCriteria.setEndDate(endDate);
        sql.append(getTimeStatisticsSql(operationCriteria, "xzthis", param));

        // 计算新增上月数据
        String xzlastmonth = ReportDateUtil.getAddMonthStr(operationCriteria.getEndDate(), -1);
        operationCriteria.setStartDate(ReportDateUtil.getStartDayOfMonth(xzlastmonth, DateUtils.YYYYMMDDHHMMSS_19));
        operationCriteria.setEndDate(ReportDateUtil.getEndDayOfMonth(xzlastmonth, DateUtils.YYYYMMDDHHMMSS_19));
        sql.append(getTimeStatisticsSql(operationCriteria, "xzlast", param));

        // 计算新增去年同期数据
        String xzlastyear = ReportDateUtil.getAddMonthStr(endDate, -12);
        operationCriteria.setStartDate(ReportDateUtil.getStartDayOfMonth(xzlastyear, DateUtils.YYYYMMDDHHMMSS_19));
        operationCriteria.setEndDate(ReportDateUtil.getEndDayOfMonth(xzlastyear, DateUtils.YYYYMMDDHHMMSS_19));
        sql.append(getTimeStatisticsSql(operationCriteria, "xzlastyear", param));
    }

    /**
     * @Description: 根据时间计算同比或者环比等数据-用于表格详情统计
     * @param: @param OperationCriteria
     * @param: @param prefix
     * @param: @param param
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    private String getTimeStatisticsSql(OperationCriteria operationCriteria, String prefix, HashMap<String, Object> param) {
        StringBuffer sql = new StringBuffer();
        sql.append(" sum(case when (happendate between to_date(:").append(prefix).append("START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
        sql.append(" and to_date(:").append(prefix).append("END_DATE,'yyyy-MM-dd hh24:mi:ss') ) ");
        sql.append(" then 1 else 0 end) as ").append(prefix).append("month, ");
        param.put(prefix+"START_DATE", operationCriteria.getStartDate());
        param.put(prefix+"END_DATE", operationCriteria.getEndDate());
        
        return sql.toString();
    }
    
    /** 
     * @Description: 获取需要打印的关键日志字符串
     * @see： @see com.udatech.center.operationAnalysis.dao.OpeCommonDao#getLogStr(java.lang.String, java.lang.String, java.util.HashMap)
     * @since JDK 1.6
     */
    public String getLogStr(String functionName, String dataSourceSql, HashMap<String, Object> param) {
        StringBuffer log = new StringBuffer();
        log.append(functionName).append(".dataSourceSql = ").append(dataSourceSql).append("\n");
        log.append(functionName).append(".param = ").append("\n");
        for (Entry<String, Object> main : param.entrySet()) {
            log.append(main.getKey()).append(" : ").append(main.getValue()).append("\n");
        }

        return log.toString();
    }

}
