package com.udatech.gov.dataAnalysis.dao.impl;

import com.udatech.common.statisAnalyze.model.DataSize;
import com.udatech.common.statisAnalyze.vo.StatisticsCriteria;
import com.udatech.gov.dataAnalysis.dao.DataAnalysisCommonDao;
import com.udatech.gov.dataAnalysis.dao.DataAnalysisDao;
import com.udatech.gov.dataAnalysis.vo.AnalysisCriteria;
import com.wa.framework.Page;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.EscapeChar;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述：数据量统计dao实现类
 * 创建人：caohy
 * 创建时间：2017年7月20日上午11:25:59
 * 修改人：caohy
 * 修改时间：2017年7月20日上午11:25:59
 */
@Repository
public class DataAnalysisDaoImpl extends BaseDaoImpl implements DataAnalysisDao {

    @Autowired
    private DataAnalysisCommonDao dataAnalysisCommonDao;
    /**
     * @Description:分别统计各种上传方式的上报数据量            
     * @param: @return
     * @return: Map<String, Object>
     * @throws
     * @since JDK 1.7.0_79
     */
    @Override
    public Map<String, Object> getTotalByCategory(AnalysisCriteria analysisCriteria) {
        HashMap<String,Object> param = new HashMap<String,Object>();
        Map<String, Object> res = new HashMap<String, Object>();
        StringBuffer strb = new StringBuffer();
        strb.append("select sum(allSize) as allSize,");// 上报量
        strb.append(" sum(failSize) as failSize,");// 疑问总量
        strb.append(" sum(updateSize) as updateSize,");// 更新量
        strb.append(" sum(successSize) as successSize,");// 入库量
        strb.append(" sum(notRelatedSize) as notRelatedSize ");// 未关联数据
        strb.append("from (select sum(allSize) as allSize,");// 上报量
        strb.append(" sum(failSize) as failSize,");// 疑问总量
        strb.append(" sum(updateProcess) as updateSize,");// 更新量
        strb.append(" sum(successSize) as successSize,");// 入库量
        strb.append(" sum(notRelatedSize) as notRelatedSize ");// 未关联数据
        strb.append(" from (");
        getCommonQuerySql(strb);
        strb.append(" )s left join dp_logic_table t on s.logic_table_id=t.id   ");
        getCondition(strb, analysisCriteria , param);
        strb.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept) ");
        strb.append("  group by s.dept_id) ");
        String sql = strb.toString();
        
        // 打印日志
        if (logger.isInfoEnabled()) {
            logger.info(dataAnalysisCommonDao.getLogStr("getTotalByCategory", sql, param));
        }
        List<Map<String, Object>> list = this.findBySql(sql,param);
        if (list != null && list.size() > 0) {
            res.put("allSize", MapUtils.getIntValue(list.get(0), "ALLSIZE"));
            res.put("failSize", MapUtils.getIntValue(list.get(0), "FAILSIZE"));
            res.put("updateSize", MapUtils.getIntValue(list.get(0), "UPDATESIZE"));
            res.put("notRelatedSize", MapUtils.getIntValue(list.get(0), "NOTRELATEDSIZE"));
            res.put("successSize", MapUtils.getIntValue(list.get(0), "SUCCESSSIZE"));
        }
        
        getSchemaTotal(res,analysisCriteria);
        return res;
    }
   
    

    /**
     * @Description: 归集目录总计 ： 当前部门的数据目录总和；
     * @param: @param res
     * @return: void
     * @throws
     * @since JDK 1.7.0_79
     */
    private void getSchemaTotal(Map<String, Object> res,AnalysisCriteria analysisCriteria) {
        StringBuffer sb = new StringBuffer();
        HashMap<String,Object> params = new HashMap<String,Object>();
        sb.append("SELECT COUNT(1) as SCHEMA_SIZE FROM ");
        sb.append("(select s.LOGIC_TABLE_ID from ");
        sb.append("(select  to_char(create_time, 'yyyy-mm-dd') as create_time,");
        sb.append(" dept_id,LOGIC_TABLE_ID  ");
        sb.append("  from dp_data_size) s  ");
        sb.append(" INNER JOIN DP_LOGIC_TABLE t ON t.ID=s.LOGIC_TABLE_ID ");
        getCondition(sb, analysisCriteria , params);
        sb.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept) ");
        sb.append( " group by s.LOGIC_TABLE_ID)");
        String sql = sb.toString();
        List<Map<String, Object>> list = this.findBySql(sql,params);
        int schemaSize = 0;
        if (list != null && list.size() > 0) {
            schemaSize = MapUtils.getIntValue(list.get(0), "SCHEMA_SIZE");
        }
        res.put("schemaSize", schemaSize);
    }
    
    /** 
     * @Description: 根据上传方式，查询类型查询上报量、有效量、疑问量 
     * @see： @see com.udatech.center.dataAnalysis.dao.DataAnalysisDao#queryStorageQuantity(java.lang.String, java.lang.String)
     * @since JDK 1.7.0_79
     */
    @Override
    public Map<String, Object> queryStorageQuantity(AnalysisCriteria analysisCriteria) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();
        
       //上报数据量统计
        if(AnalysisCriteria.PIE_DATA.equals(analysisCriteria.getChartsType())){
            getPieSql(sql,analysisCriteria ,param );

        //上报方式统计
        }else if(AnalysisCriteria.PIE_WAY.equals(analysisCriteria.getChartsType())){
            getPieWaySql(sql,analysisCriteria ,param );
            
         //数据上报月度统计
        }else if(AnalysisCriteria.TREND.equals(analysisCriteria.getChartsType())){
            getHistogramSql(sql,analysisCriteria ,param );
            
        //数据目录上报统计
        }else if(AnalysisCriteria.HISTOGRAM.equals(analysisCriteria.getChartsType())){
            getSqlByCatalog(sql,analysisCriteria ,param );
        }

        Map<String, Object> retMap = dataAnalysisCommonDao.getAllChartDatas(sql.toString(), param);

        if (logger.isInfoEnabled()) {
            logger.info(dataAnalysisCommonDao.getLogStr("queryStorageQuantity", sql.toString(), param));
        }

        return retMap;
    }
    
    private void getHistogramSql(StringBuffer sql,AnalysisCriteria analysisCriteria , HashMap<String, Object> param ){
        sql.append("select startDate,                                                               ");
        sql.append("        allSize,                           ");//上报量
        sql.append("        successSize,                   ");//入库量
        sql.append("        failSize,                          ");//疑问量
        sql.append("       updateProcess ,               ");//更新量
        sql.append("        notRelatedSize                ");//未关联量
        sql.append("  from (select startDate,                                                       ");
        sql.append("               sum(nvl(allSize,0)) allSize,                                     ");
        sql.append("               sum(nvl(successSize,0)) successSize,                             ");
        sql.append("               sum(nvl(failSize,0)) failSize,                                   ");
        sql.append("               sum(nvl(updateProcess,0)) updateProcess,                         ");
        sql.append("               sum(nvl(notRelatedSize,0)) notRelatedSize                         ");
        sql.append("          from (select startDate,                                               ");
        sql.append("                       allSize,                                                 ");
        sql.append("                       successSize,                                             ");
        sql.append("                       failSize,                                                 ");
        sql.append("                       updateProcess,                                            ");
        sql.append("                       notRelatedSize                                           ");
        sql.append("                  from(                                                         ");
        sql.append(dataAnalysisCommonDao.getDaysListSql()                                            );
        sql.append("                  )left join                                                    ");
        sql.append("                          ( select s.*,t.name from (                            ");
        getCommonQuerySql(sql);
        sql.append("              )s  left join dp_logic_table t on s.logic_table_id=t.id            ");
        getCondition(sql, analysisCriteria , param);  
        sql.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept)         ");
        sql.append("            )s on startDate = to_char(to_date(create_time,'yyyy-mm-dd'),'yyyy-mm') ");
        sql.append("         ) group by startDate                                                   ");
        sql.append("         order by startDate)                                                    ");
    }
    
    /**
     * @Description:按目录名称统计上报量、有效量、疑问量等  
     * @param: @param analysisCriteria
     * @param: @param page
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.7.0_79
     */
    public List<Map<String,Object>> queryTableDetails(AnalysisCriteria analysisCriteria,Page page){
        StringBuffer sql = new StringBuffer();

        HashMap<String, Object> param = new HashMap<String, Object>();
        analysisCriteria.setChartsType(AnalysisCriteria.HISTOGRAM);
        getSqlByCatalog(sql, analysisCriteria, param);

        String querySql = sql.toString();

        if (logger.isInfoEnabled()) {
            logger.info(dataAnalysisCommonDao.getLogStr("queryTableDetails", querySql.toString(), param));
        }

        List<Map<String, Object>> list = this.findBySql(querySql, param);

        return list;
    }

    @Override
    public List<Map<String, Object>> queryDetails(AnalysisCriteria analysisCriteria, Page page) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<>();

        getSql4Detail(sql, analysisCriteria, param);

        String querySql = sql.toString();
        if (logger.isInfoEnabled()) {
            logger.info(dataAnalysisCommonDao.getLogStr("queryDetails", querySql, param));
        }

        return this.findBySql(querySql, param);
    }

    private void getSql4Detail(StringBuffer strb, AnalysisCriteria analysisCriteria, HashMap<String, Object> param) {
        strb.append(" SELECT CREATE_TIME,                                                                        ");
        strb.append("        id,                                                                                 ");
        strb.append("        name,                                                                               ");
        strb.append("        allSize,                                                                            ");
        strb.append("        failSize,                                                                           ");
        strb.append("        updateSize,                                                                         ");
        strb.append("        successSize,                                                                        ");
        strb.append("        notRelatedSize,                                                                     ");
        strb.append("        CASE                                                                                ");
        strb.append("          WHEN round(((decode(allSize, 0, 0, successSize / allSize))) * 100,                ");
        strb.append("                     2) < 1 AND                                                             ");
        strb.append("               round(((decode(allSize, 0, 0, successSize / allSize))) * 100,                ");
        strb.append("                     2) > 0 THEN                                                            ");
        strb.append("           to_char(round(((decode(allSize, 0, 0, successSize / allSize))) * 100,            ");
        strb.append("                         2),                                                                ");
        strb.append("                   'fm999990.99') || '%'                                                    ");
        strb.append("          ELSE                                                                              ");
        strb.append("           round((decode(allSize, 0, 0, successSize / allSize)) * 100, 2) || '%'            ");
        strb.append("        END AS succSizeRate,                                                                ");
        strb.append("        CASE                                                                                ");
        strb.append("          WHEN round((decode(allSize, 0, 0, failSize / allSize)) * 100, 2) < 1 AND          ");
        strb.append("               round((decode(allSize, 0, 0, failSize / allSize)) * 100, 2) > 0 THEN         ");
        strb.append("           to_char(round((decode(allSize, 0, 0, failSize / allSize)) * 100, 2),             ");
        strb.append("                   'fm999990.99') || '%'                                                    ");
        strb.append("          ELSE                                                                              ");
        strb.append("           round((decode(allSize, 0, 0, failSize / allSize)) * 100, 2) || '%'               ");
        strb.append("        END AS failSizeRate,                                                                ");
        strb.append("        CASE                                                                                ");
        strb.append("          WHEN round((decode(allSize, 0, 0, updateSize / allSize)) * 100, 2) < 1 AND        ");
        strb.append("               round((decode(allSize, 0, 0, updateSize / allSize)) * 100, 2) > 0 THEN       ");
        strb.append("           to_char(round((decode(allSize, 0, 0, updateSize / allSize)) * 100,               ");
        strb.append("                         2),                                                                ");
        strb.append("                   'fm999990.99') || '%'                                                    ");
        strb.append("          ELSE                                                                              ");
        strb.append("           round((decode(allSize, 0, 0, updateSize / allSize)) * 100, 2) || '%'             ");
        strb.append("        END AS updateSizeRate,                                                              ");
        strb.append("        CASE                                                                                ");
        strb.append("          WHEN round((decode(allSize, 0, 0, notRelatedSize / allSize)) * 100,               ");
        strb.append("                     2) < 1 AND                                                             ");
        strb.append("               round((decode(allSize, 0, 0, notRelatedSize / allSize)) * 100,               ");
        strb.append("                     2) > 0 THEN                                                            ");
        strb.append("           to_char(round((decode(allSize, 0, 0, notRelatedSize / allSize)) * 100,           ");
        strb.append("                         2),                                                                ");
        strb.append("                   'fm999990.99') || '%'                                                    ");
        strb.append("          ELSE                                                                              ");
        strb.append("           round((decode(allSize, 0, 0, notRelatedSize / allSize)) * 100, 2) || '%'         ");
        strb.append("        END AS notRelatedSizeRate                                                           ");
        strb.append("   FROM (SELECT out_id AS id,                                                               ");
        strb.append("                name,                                                                       ");
        strb.append("                substr(CREATE_TIME, 0, 7) as CREATE_TIME,                                   ");
        strb.append("                sum(nvl(allSize, 0)) AS allSize,                                            ");
        strb.append("                sum(nvl(failSize, 0)) AS failSize,                                          ");
        strb.append("                sum(nvl(updateProcess, 0)) AS updateSize,                                   ");
        strb.append("                sum(nvl(successSize, 0)) AS successSize,                                    ");
        strb.append("                sum(nvl(notRelatedSize, 0)) AS notRelatedSize                               ");
        strb.append("           FROM (SELECT s.*,                                                                ");
        strb.append("                        t.dept_name         AS name,                                        ");
        strb.append("                        t.sys_department_id AS out_id                                       ");
        strb.append("                   FROM (SELECT st.sys_department_id,                                       ");
        strb.append("                                st.DEPARTMENT_NAME AS dept_name,                            ");
        strb.append("                                lt.logic_table_id,                                          ");
        strb.append("                                dt.name                                                     ");
        strb.append("                           FROM sys_department st                                           ");
        strb.append("                           LEFT JOIN dp_logic_table_dept lt                                 ");
        strb.append("                             ON lt.dept_id = st.sys_department_id                           ");
        strb.append("                           LEFT JOIN dp_logic_table dt                                      ");
        strb.append("                             ON dt.id = lt.logic_table_id                                   ");
        strb.append("                          GROUP BY st.sys_department_id,                                    ");
        strb.append("                                   st.DEPARTMENT_NAME,                                      ");
        strb.append("                                   lt.logic_table_id,                                       ");
        strb.append("                                   dt.name) t                                               ");
        strb.append("                   LEFT JOIN (                                                              ");
        getCommonQuerySql(strb);
        strb.append("                     ) s ON s.dept_id = t.sys_department_id                                 ");
        strb.append("                    AND s.logic_table_id = t.logic_table_id                                 ");
        getCondition(strb, analysisCriteria, param);
        strb.append("          ) GROUP BY out_id, name, substr(CREATE_TIME, 0, 7))                                ");

    }

    /**
     * @Description: 获取上报数据量统计sql(饼图)           
     * @param: @param sql
     * @param: @param analysisCriteria
     * @param: @param param
     * @return: void
     * @throws
     * @since JDK 1.7.0_79
     */
    private void getPieSql(StringBuffer sql,AnalysisCriteria analysisCriteria , HashMap<String, Object> param ){
    	  sql.append("select sum(category0) as category0, ");// 上报量
          sql.append(" sum(category1) as category1, ");// 疑问总量
          sql.append(" sum(category3) as category3, ");// 更新量
          sql.append(" sum(category4) as category4, ");// 入库量
          sql.append(" sum(category5) as category5 ");// 未关联数据
        sql.append("from(select sum(nvl(allSize,0)) as category0, ");// 上报量
        sql.append(" sum(nvl(failSize,0)) as category1,");// 疑问总量
        sql.append(" sum(nvl(updateProcess,0)) as category3,");// 更新量
        sql.append(" sum(nvl(successSize,0)) as category4,");// 入库量
        sql.append(" sum(nvl(notRelatedSize,0)) as category5 ");// 未关联数据
        sql.append(" from (");
        getCommonQuerySql(sql);
        sql.append(" )s left join dp_logic_table t on s.logic_table_id=t.id   ");
        getCondition(sql, analysisCriteria , param);
        sql.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept) ");
        sql.append("  group by s.dept_id) ");
    }
    
    /**
     * @Description: 获取上报方式的饼图                      
     * @param: @param sql
     * @param: @param analysisCriteria
     * @param: @param param
     * @return: void
     * @throws
     * @since JDK 1.7.0_79
     */
    public void getPieWaySql(StringBuffer sql,AnalysisCriteria analysisCriteria , HashMap<String, Object> param ){
        
        analysisCriteria.setQueryType(AnalysisCriteria.QUERY_TOTAL);
        sql.append("select sum(category0) as category0,sum(category1) as category1,");
        sql.append("  sum(category2) as category2,sum(category3) as category3,");
        sql.append("  sum(category4) as category4 from (" );
        sql.append("select sum(case when report_way=0 then all_size else 0 end) as category0,         ");    
        sql.append(" sum(case when report_way=1 then all_size else 0 end) as category1 ,              "); 
        sql.append(" sum(case when report_way=2 then all_size else 0 end) as category2 ,              ");  
        sql.append(" sum(case when report_way=3 then all_size else 0 end) as category3 ,              ");  
        sql.append(" sum(case when report_way=4 then all_size else 0 end) as category4                ");  
        sql.append("  from (                                                                          ");
        sql.append("      select *                                                                    ");
        sql.append("      from (select id,                                                            ");
        sql.append("              task_code,                                                          ");
        sql.append("              create_date,                                                         ");
        sql.append("              report_way,                                                          ");
        sql.append("              confirm_status,                                                      ");
        sql.append("              logic_table_id,                                                       ");
        sql.append("              row_number() over(partition by task_code order by create_date desc) rn");
        sql.append("                      from dp_data_report_log)                                       ");
        sql.append("                             where rn = 1) log                                      ");  
        sql.append(" inner join                                                                         ");
        sql.append(" (select  to_char(create_time, 'yyyy-mm-dd') as create_time,                         ");
        sql.append(" dept_id,LOGIC_TABLE_ID,task_code,ALL_SIZE                                           ");
        sql.append("  from dp_data_size) s                                                               ");
        sql.append("    on log.task_code = s.task_code                                                  ");  
        sql.append("    and log.logic_table_id = s.logic_table_id                                       ");  
        sql.append("  left join dp_logic_table t                                                        ");  
        sql.append("    on s.logic_table_id = t.id                                                      ");  
        getCondition(sql, analysisCriteria , param);
        sql.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept)            ");
        sql.append(" group by log.report_way)                                                           ");  
        
    }
    
    
     /**
     * @Description：封装按目录名称统计数据的sql字符串 （柱状图和表格）     
     * @param: @param sql,analysisCriteria,param
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    private void getSqlByCatalog(StringBuffer strb,AnalysisCriteria analysisCriteria , HashMap<String, Object> param ){
        strb.append("select name,allSize,failSize,updateSize,successSize,notRelatedSize,");// 上报量
        strb.append(" case when round(((decode(allSize,0,0,successSize/allSize)))*100,2) < 1 and round(((decode(allSize,0,0,successSize/allSize)))*100,2) >0");
        strb.append(" then to_char(round(((decode(allSize,0,0,successSize/allSize)))*100,2), 'fm999990.99')||'%' ");
        strb.append(" else round((decode(allSize,0,0,successSize/allSize))*100,2)||'%' end as succSizeRate, ");// 入库率
        
        strb.append(" case when round((decode(allSize,0,0,failSize/allSize))*100,2) < 1 and round((decode(allSize,0,0,failSize/allSize))*100,2) >0");
        strb.append(" then to_char(round((decode(allSize,0,0,failSize/allSize))*100,2), 'fm999990.99')||'%' ");
        strb.append(" else round((decode(allSize,0,0,failSize/allSize))*100,2)||'%' end as failSizeRate, ");// 疑问率
        
        strb.append(" case when round((decode(allSize,0,0,updateSize/allSize))*100,2) < 1 and round((decode(allSize,0,0,updateSize/allSize))*100,2) >0");
        strb.append(" then to_char(round((decode(allSize,0,0,updateSize/allSize))*100,2), 'fm999990.99')||'%' ");
        strb.append(" else round((decode(allSize,0,0,updateSize/allSize))*100,2)||'%' end as updateSizeRate, ");// 更新率
        
        strb.append(" case when round((decode(allSize,0,0,notRelatedSize/allSize))*100,2) < 1 and round((decode(allSize,0,0,notRelatedSize/allSize))*100,2) >0");
        strb.append(" then to_char(round((decode(allSize,0,0,notRelatedSize/allSize))*100,2), 'fm999990.99')||'%' ");
        strb.append(" else round((decode(allSize,0,0,notRelatedSize/allSize))*100,2)||'%' end as notRelatedSizeRate ");// 未关联率
        
        strb.append(" from (");
        strb.append("select name,sum(nvl(allSize,0)) as allSize, ");// 上报量
        strb.append(" sum(nvl(failSize,0)) as failSize,");// 疑问总量
        strb.append(" sum(nvl(updateProcess,0)) as updateSize,");// 更新量
        strb.append(" sum(nvl(successSize,0)) as successSize,");// 入库量
        strb.append(" sum(nvl(notRelatedSize,0)) as notRelatedSize ");// 未关联数据
        strb.append(" from (select s.*,t.name,t.id from ");
        strb.append("(select dt.logic_table_id as id,dt.dept_id,(select name from dp_logic_table t where t.id=dt.logic_table_id) as name from dp_logic_table_dept dt ) t ");
        strb.append("left join (");
        getCommonQuerySql(strb);
        strb.append(" )s on  s.logic_table_id=t.id and s.dept_id=t.dept_id ");
        getCondition(strb, analysisCriteria , param);
        getDeptCondition(strb, analysisCriteria ,  param);  //封装部门查询条件
        strb.append(" and t.id in(select logic_table_id from dp_logic_table_dept) ");
        strb.append(" ) group by id,name order by allSize desc)");
        
    }
    
    
    /**
     * @Description: 查询上报量、有效量、疑问量的通用sql
     * @param: @param sql
     * @return: void
     * @throws
     * @since JDK 1.7.0_79
     */
    private void getCommonQuerySql(StringBuffer sql) {
        sql.append("select * from(select nvl(allSize,0) as allSize,                              ");
        sql.append("              nvl(successSize,0) as successSize,                             ");
        sql.append("              nvl(failSize,0) as failSize,                                   ");
        sql.append("              nvl(updateProcess,0) as updateProcess,                         ");
        sql.append("              nvl(notRelatedSize,0) as notRelatedSize,                       ");
        sql.append("              dept_id,                                                       ");
        sql.append("              logic_table_id,                                                ");
        sql.append("              create_time,                                                   ");
        sql.append("              aa.task_code                                                   ");
        sql.append("         from (select create_time,                                           ");
        sql.append("                      all_size as allSize,                                   ");
        sql.append("                      dept_id,                                               ");
        sql.append("                      s.logic_table_id,                                      ");
        sql.append("                      r.successSize as successSize,                          ");
        sql.append("                      (nvl(fail_size,0) + nvl(failSizeProcess,0)) as failSize, ");
        sql.append("                      updateProcess as updateProcess,                        ");
        sql.append("                      r.notRelatedSize as notRelatedSize,                    ");
        sql.append("                      s.task_code                                            ");
        sql.append("                 from (select task_code,                                     ");
        sql.append("                              max(logic_table_id) logic_table_id,            ");
        sql.append("                              to_char(create_time, 'yyyy-mm-dd') create_time,");
        sql.append("                              max(dept_id) dept_id,                          ");
        sql.append("                              sum(nvl(fail_size,0)) fail_size,               ");
        sql.append("                              sum(nvl(all_Size,0)) all_Size                  ");
        sql.append("                         from dp_data_size                                   ");
        sql.append("                        group by task_code,                                  ");
        sql.append("                                 to_char(create_time, 'yyyy-mm-dd')) s       ");
        sql.append("                 left join (select task_code,                                ");
        sql.append("                                  sum(case                                   ");
        sql.append("                                        when (type = 1 and etl_type = 1) then ");
        sql.append("                                         process_size                        ");
        sql.append("                                        else                                 ");
        sql.append("                                         0                                   ");
        sql.append("                                      end) as successSize,                   ");
        sql.append("                                  sum(case                                   ");
        sql.append("                                        when type = 2 then                   ");
        sql.append("                                         process_size                        ");
        sql.append("                                        else                                 ");
        sql.append("                                         0                                   ");
        sql.append("                                      end) as failSizeProcess,               ");
        sql.append("                                  sum(case                                   ");
        sql.append("                                        when type = 3 then                   ");
        sql.append("                                         process_size                        ");
        sql.append("                                        else                                 ");
        sql.append("                                         0                                   ");
        sql.append("                                      end) as updateProcess,                 ");
        sql.append("                                  sum(case                                   ");
        sql.append("                                        when type = 4 then                   ");
        sql.append("                                         process_size                        ");
        sql.append("                                        else                                 ");
        sql.append("                                         0                                   ");
        sql.append("                                      end) as notRelatedSize                 ");
        sql.append("                             from dp_process_result                          ");
        sql.append("                            where task_code is not null                      ");
        sql.append("                            group by task_code) r                            ");
        sql.append("                   on s.task_code = r.task_code)aa)s                           ");

    }
    
    /**
     * @Description：封装查询条件      
     * @param: @param sql,analysisCriteria,param
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    private void getCondition(StringBuffer sql,AnalysisCriteria analysisCriteria , HashMap<String, Object> param){
        sql.append(" where 1=1 ");

        // 统计主题：0-手动上传；1-文件上传；2-数据库上传；3-FTP上传；4-接口上传；
        if (StringUtils.isNotEmpty(analysisCriteria.getCategory())
                        && StringUtils.isNotEmpty(analysisCriteria.getQueryType())) {
            param.put("reportWay", analysisCriteria.getCategory());
            sql.append("  and log.report_way=:reportWay");
        }

        if(StatisticsCriteria.HISTOGRAM.equals(analysisCriteria.getChartsType())){
        	if (StringUtils.isNotBlank(analysisCriteria.getDeptId())) {
        		param.put("deptId", analysisCriteria.getDeptId());
        		sql.append("  and t.dept_id=:deptId ");
        	}

        }else{
        	
        	if (StringUtils.isNotBlank(analysisCriteria.getDeptId())) {
        		param.put("deptId", analysisCriteria.getDeptId());
        		sql.append("  and s.dept_id=:deptId ");
        	}
        }

        if(StatisticsCriteria.TREND.equals(analysisCriteria.getChartsType())){
            if (StringUtils.isNotEmpty(analysisCriteria.getTableName())) {
                sql.append(" and  t.name = :tableName ");
                param.put("tableName", analysisCriteria.getTableName());
            }
        }else{
        	if (StringUtils.isNotEmpty(analysisCriteria.getTableName())) {
                String name = EscapeChar.escape(analysisCriteria.getTableName().trim());
                sql.append(" and  t.name like :tableName  escape '\\' ");
                param.put("tableName", "%" + name + "%");
            }
        }
        

       if(AnalysisCriteria.TREND.equals(analysisCriteria.getChartsType())){
           if (StringUtils.isEmpty(analysisCriteria.getStartDate())) {
               String startDate = getEarliestDate(analysisCriteria.getDeptId());

               if (StringUtils.isEmpty(startDate)) {
                   startDate = DateUtils.format(new Date(), DateUtils.YYYYMMDD_10);
               }
               param.put("startDate", startDate);
           } else {
               param.put("startDate", analysisCriteria.getStartDate());
           }

           if (StringUtils.isEmpty(analysisCriteria.getEndDate())) {
               String endDate = DateUtils.format(new Date(), DateUtils.YYYYMMDD_10);
               param.put("endDate", endDate);
           } else {
               param.put("endDate", analysisCriteria.getEndDate());
           }
           
       }else{
           if (StringUtils.isNotEmpty(analysisCriteria.getStartDate())) {
               param.put("startDate", analysisCriteria.getStartDate());
           }

           if (StringUtils.isNotEmpty(analysisCriteria.getEndDate())) {
               param.put("endDate", analysisCriteria.getEndDate());
           }
       }
       if (StringUtils.isNotEmpty(analysisCriteria.getStartDate())) {
           sql.append("  AND s.CREATE_TIME >= :startDate ");
       }

       if (StringUtils.isNotEmpty(analysisCriteria.getEndDate())) {

           sql.append("  AND s.CREATE_TIME <= :endDate     ");
       }

        
        
    }
    
    /**
     * @Description:获得部门入库最早日期          
     * @param: @param deptId
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    private String getEarliestDate (String deptId){
        StringBuffer sql = new StringBuffer();
        sql.append("select to_char(tdStartDate,'yyyy-mm-dd') as tdStartDate");
        sql.append("  from (select min(create_time) as tdStartDate from dp_data_size");
        Map<String,Object> params = new HashMap<String,Object>();
        
        if(StringUtils.isNotEmpty(deptId)){
            sql.append(" where dept_id=:deptId)");
            params.put("deptId", deptId);
        }else{
            sql.append(" )");
        }
        List<Map<String, Object>> list = this.findBySql(sql.toString(),params);
        
        String formatHappendate = "";
        if (list != null && list.size() > 0){
            Map<String, Object> map = list.get(0);
            formatHappendate = MapUtils.getString(map, "TDSTARTDATE", "");
        }
        
        return formatHappendate;
    }

    private void getDeptCondition(StringBuffer sql,AnalysisCriteria statisticsCriteria,HashMap<String,Object> param){
  	   
  	   if(DataSize.CITY.equals(statisticsCriteria.getDeptQueryType())){
        	 sql.append("  and s.dept_id in (select sys_department_id from sys_department where code like 'A%') ");
        }else  if(DataSize.AREA.equals(statisticsCriteria.getDeptQueryType())){
        	 sql.append("  and s.dept_id in (select sys_department_id from sys_department where code like 'B%') ");
        }else  if(DataSize.PROVINCE.equals(statisticsCriteria.getDeptQueryType())){
        	 sql.append("  and s.dept_id in (select sys_department_id from sys_department where code like 'C%') ");
        }
        if(StringUtils.isNotBlank(statisticsCriteria.getDeptId())){
            sql.append("  and s.dept_id=:deptId ");
            param.put("deptId", statisticsCriteria.getDeptId());
        }
        
     }
}
