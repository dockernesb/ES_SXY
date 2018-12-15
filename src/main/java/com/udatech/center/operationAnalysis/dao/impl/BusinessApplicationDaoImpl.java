package com.udatech.center.operationAnalysis.dao.impl;

import com.udatech.center.operationAnalysis.dao.BusinessApplicationDao;
import com.udatech.center.operationAnalysis.dao.OpeCommonDao;
import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.udatech.common.constant.Constants;
import com.udatech.common.enmu.DZThemeEnum;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述：业务应用分析dao实现类（中心端）
 * 创建人：guoyt
 * 创建时间：2016年12月28日下午5:52:13
 * 修改人：guoyt
 * 修改时间：2016年12月28日下午5:52:13
 */
@Repository
public class BusinessApplicationDaoImpl extends BaseDaoImpl implements BusinessApplicationDao {

    @Autowired
    private OpeCommonDao opeCommonDao;

    /**
     * @Description: 根据各种统计主题和统计时间阶段统计数量
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#getTotalByCategory(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public long getTotalByCategory(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();
        if (!Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
        	sql.append("select count(1) from ");
        }

        // 根据各种统计主题确定表名和时间字段
        String dateField = "";
        if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
            //信用报告增加自然人统计    
            sql.append("(select id, create_date from dt_enterprise_report_apply union all select id, create_date from dt_person_report_apply) t ");
            dateField = "create_date";
        } else if (Constants.CATEGORY_OBJECTION_HANDLING.equals(operationCriteria.getCategory())) {
            sql.append("dt_enterprise_objection t ");
            dateField = "create_date";
        } else if (Constants.CATEGORY_CREDIT_REPAIR.equals(operationCriteria.getCategory())) {
            sql.append("dt_enterprise_repair t ");
            dateField = "create_date";
        } else if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
            sql.append("select * from (select id,APPLY_DATE from dt_credit_examine t ");
            sql.append("union all  ");
            sql.append("select id,APPLY_DATE from DT_CREDIT_EXAMINE_P t)t ");
            //sql.append("left join dt_enterprise_examine d on t.id = d.credit_examine_id ");
            dateField = "apply_date";
        } else if (Constants.CATEGORY_DOUBLE_PUBLICITY.equals(operationCriteria.getCategory())) {
            sql.append("(select id, tgrq, create_time , BMBM from YW_L_SGSXZXK a where  exists (select 1 from sys_department t where  a.bmbm=t.code and status <> 1)");
            sql.append(" union all select id, tgrq, create_time, BMBM from YW_L_SGSXZCF a where  exists (select 1 from sys_department t where  a.bmbm=t.code and status <> 1)");
            sql.append(" ) t ");
            if (Constants.DIMENSION_REPORT_DATE.equals(operationCriteria.getDimension())) {
                dateField = "create_time";
            }  else {
                dateField = "tgrq";
            }
        } 

        sql.append("where 1 = 1 ");

        if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
            sql.append(" and t.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("START_DATE", operationCriteria.getStartDate());
        }

        if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
            sql.append(" and t.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("END_DATE", operationCriteria.getEndDate());
        }
        
        if (Constants.CATEGORY_DOUBLE_PUBLICITY.equals(operationCriteria.getCategory())) {
            if ( StringUtils.isNotBlank(operationCriteria.getDepartment())) {
                sql.append(" and t.BMBM =:bmbm ");
                param.put("bmbm", operationCriteria.getDepartment());
            }
       }
        long count = 0;
        if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
        	 count = this.countBySql("select count(1) from ("+sql.toString()+")", param);
        }else{
        	count = this.countBySql(sql.toString(), param);
        }

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("getTotalByCategory", sql.toString(), param));
        }
        return count;
    }

    /**
     * @Description: 根据各种统计主题统计信用报告、异议处理、信用修复、信用核查的分布情况
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryBusinessDistribution(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> queryBusinessDistribution(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 信用核查的审查类别保存在一个字段中，以，分隔，例如“许可资质信息,失信信息,履行约定,表彰荣誉,参保信息,其他信息”，所以统计方式与其他都不同
        if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())
                        && Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())) {
            sql.append("select distinct category,min(dict_key) as dict_key, sum(total) as total, ");
            sql.append("round(100*ratio_to_report(sum(total)) OVER (),2) as rating_num from ( ");
            sql.append("select category,dict_key,case when scxxl is null then 0 else 1 end as total from (");
        } else {
            
            ////信用报告增加自然人统计    
            if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                // 柱图中统计为0的category也需要展示，而非只展示有数据的category-处理开头sql
                   sql.append(getDistributionSql(operationCriteria));
                   sql.append("select distinct category, count(category) as total, round(100 * ratio_to_report(count(category)) OVER(), 2) as rating_num, group_key from (");
           } else {
            // 柱图中统计为0的category也需要展示，而非只展示有数据的category-处理开头sql
               sql.append(getDistributionSql(operationCriteria));
               sql.append("select distinct category, count(category) as total, round(100 * ratio_to_report(count(category)) OVER(), 2) as rating_num from (");
           }
        }

        // 根据统计维度类别统计数据
        sql.append(getCategorySql(operationCriteria));

        // 根据统计主题获取所有数据源
        sql.append(getAllDataSql(operationCriteria, param));

        // 信用核查的审查类别保存在一个字段中，以，分隔，例如“许可资质信息,失信信息,履行约定,表彰荣誉,参保信息,其他信息”，所以统计方式与其他都不同
        if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())
                        && Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())) {
            sql.append(") tt on instr(tt.scxxl,d.id)>0)) group by category order by dict_key");
        } else {
            
            ////信用报告增加自然人统计    
            if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                sql.append(" ))aa group by category, group_key ");

                // 柱图中统计为0的category也需要展示，而非只展示有数据的category-处理结尾sql
                if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())
                                || Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())) {
                    sql.append(" ) ttt on ttt.category = tt.department_name order by tt.department_name ");
                } else {
                    sql.append(" ) ttt on ttt.category = tt.dict_value and ttt.group_key = tt.group_key order by tt.dict_key ");
                }
            } else {
                sql.append(" ))aa group by category ");
    
                // 柱图中统计为0的category也需要展示，而非只展示有数据的category-处理结尾sql
                if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())
                                || Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())) {
                    sql.append(" ) ttt on ttt.category = tt.department_name order by tt.department_name ");
                } else {
                    sql.append(" ) ttt on ttt.category = tt.dict_value order by tt.dict_key ");
                }
            }
        }
        
        //信用报告增加自然人统计  ,所以表格需要区分是自然人还是法人   
        String querySql ="";
        if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
          StringBuffer reportTaleSql = new StringBuffer();
          reportTaleSql.append(" SELECT (case when group_key='applyReportPurpose' then category||'（法人）' else category||'（自然人）' end) as category, ");
          reportTaleSql.append(" dict_key,total,rating_num,group_key from  (").append(sql.toString()).append(")");
          querySql = reportTaleSql.toString();
        }else{
            querySql = sql.toString();
        }

        Map<String, Object> retMap = opeCommonDao.getAllChartDatas(querySql, param);

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryBusinessDistribution", querySql, param));
        }

        return retMap;
    }


    /**
     * @Description: 根据各种统计主题统计信用报告、异议处理、信用修复、信用核查的趋势分析
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryBusinessTrends(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> queryBusinessTrends(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 根据统计主题获取所有数据源
        String allDataSql = getAllDataSql(operationCriteria, param);

        // 如果页面不传开始时间，则设置开始时间为所有记录最早时间
        if (StringUtils.isEmpty(operationCriteria.getStartDate())) {
            String startDate = opeCommonDao.getEarliestDate(allDataSql, param);
            if (StringUtils.isNotEmpty(startDate)){
                operationCriteria.setStartDate(startDate);
            } else {
                operationCriteria.setStartDate(operationCriteria.getEndDate());
            }
        }

        // 统计新增、累计、环比、同比等数据，只有新增需要统计同比数据
        sql.append(opeCommonDao.getTrendSqlBegin(operationCriteria, false));
        sql.append("select distinct to_char(happendate, 'yyyy-MM') as category, count(to_char(happendate, 'yyyy-MM')) as total from (");
        sql.append(allDataSql);

        sql.append(") group by to_char(happendate, 'yyyy-MM') ");
        sql.append(opeCommonDao.getTrendSqlEnd());

        Map<String, Object> retMap = opeCommonDao.getAllChartDatas(sql.toString(), param);

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryBusinessTrends", sql.toString(), param));
        }

        return retMap;
    }

    /**
     * @Description: 根据各种统计主题（信用报告、异议处理、信用修复、信用核查）统计表格
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryTableDetails(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
     * @since JDK 1.6
     */
    @Override
    public Pageable<Map<String, Object>> queryTableDetails(OperationCriteria operationCriteria, Page page) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 根据统计主题获取所有数据源
        String allDataSql = getAllDataSql(operationCriteria, param);

        // 如果查询时间期间内，系统中没有任何记录，则这个最早开始时间为空，此时把已设置为当前时间的结束时间赋给开始时间
        String startDate = opeCommonDao.getEarliestDate(allDataSql, param);
        if (StringUtils.isNotEmpty(startDate)){
            operationCriteria.setStartDate(startDate);
        } else {
            operationCriteria.setStartDate(operationCriteria.getEndDate());
        }

        // 下钻时，则按月份显示该类别下的统计情况
        if (StringUtils.isNotEmpty(operationCriteria.getParentCondtion())) {
            // 统计新增、累计、新增本期占比、累计本期占比、环比、同比等数据，只有新增需要统计同比数据
            sql.append(opeCommonDao.getTrendSqlBegin(operationCriteria, true));
            sql.append("select distinct to_char(happendate, 'yyyy-MM') as category, count(to_char(happendate, 'yyyy-MM')) as total from (");
            sql.append(allDataSql);

            // 根据统计类别联动趋势分析数据
            sql.append(getConditionSql(operationCriteria, param));

            sql.append(") group by to_char(happendate, 'yyyy-MM') ");
            sql.append(opeCommonDao.getTrendSqlEnd());
            sql.append(" order by shijian desc");
        } else {
            // 默认显示所有类别在统计期间内的累计、新增等情况
            String endDate = operationCriteria.getEndDate();

            // 信用核查的审查类别保存在一个字段中，以，分隔，例如“许可资质信息,失信信息,履行约定,表彰荣誉,参保信息,其他信息”，所以统计方式与其他都不同
            if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())
                            && Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())) {
                sql.append(opeCommonDao.getTableSqlBegin("category", "dict_key"));
                sql.append("from (select distinct category as category, min(dict_key) as dict_key, ");
            } else {
                // 分别处理部门和各种信用业务的内容类别
                if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())
                                || Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())) {
                    sql.append(opeCommonDao.getTableSqlBegin("ic.department_name", null));
                    sql.append("from sys_department ic ");
                    sql.append("left join (select distinct category as category, ");
                } else {
                    // 设定信用报告、异议处理、信用修复的内容类别的字典组编码
                    String groupKey = null;
                    if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                        groupKey = "'applyReportPurpose','applyPReportPurpose'";
                    } else if (Constants.DIMENSION_APPEAL_CONTENT.equals(operationCriteria.getDimension())){
                        groupKey = "appeal_content";
                    } else if(Constants.DIMENSION_REPAIR_CONTENT.equals(operationCriteria.getDimension())){
                        groupKey = "repair_content";
                    }

                    sql.append(opeCommonDao.getTableSqlBegin("ic.category", "ic.dict_key"));
                    if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                        //信用报告增加自然人统计
                        sql.append("from (SELECT (case when group_key='applyReportPurpose' then dict_value||'（法人）' else dict_value||'（自然人）' end) as category,group_key,");
                        sql.append(" sd.* from sys_dictionary sd left join sys_dictionary_group sg ");
                        sql.append("on sd.group_id = sg.id where sg.group_key in(").append(groupKey).append(" ))ic ");
                        sql.append("left join (select distinct category as category,group_key, ");
                    }else{
                        sql.append("from (select dict_value as category, sd.* from sys_dictionary sd left join sys_dictionary_group sg ");
                        sql.append("on sd.group_id = sg.id where sg.group_key = '").append(groupKey).append("') ic ");
                        sql.append("left join (select distinct category as category, ");
                    }
                }
            }

            // 统计表格分析中间sql,计算累计以及新增同比、环比等数据
            opeCommonDao.getTableSqlBetween(operationCriteria, sql, param, endDate);

            sql.append(" count(category) as total from (");

            // 根据统计维度类别统计数据
            sql.append(getCategorySql(operationCriteria));

            // 根据统计主题获取所有数据源
            sql.append(allDataSql);

            if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())
                            && Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())) {
                sql.append(") tt on instr(tt.scxxl,dict_value)>0) group by category)) order by dict_key");
            } else {
                if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())
                                || Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())) {
                 if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                    sql.append(")) group by category,group_key) ttt on ttt.category = ic.department_name where ic.status <> 1 order by ic.department_name) ");
                 }else{
                     sql.append(")) group by category) ttt on ttt.category = ic.department_name where ic.status <> 1 order by ic.department_name) "); 
                 }
                } else {
                    if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                        sql.append(")) group by category,group_key) ttt on ttt.category = ic.dict_value and ttt.group_key=ic.group_key order by ic.category) ");
                    }else{
                        sql.append(")) group by category) ttt on ttt.category = ic.dict_value  order by ic.category) ");
                    }
                }
            }
        }

        String querySql = sql.toString();
        String countSql = " SELECT COUNT(1) FROM ( " + querySql + " ) ";

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryTableDetails", sql.toString(), param));
        }

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(
                querySql, countSql, page, param);

        return pageable;
    }

    /**
     * @Description: 所有柱图的category全部列出来，包括统计为0的category-处理开头sql
     * @param: @param operationCriteria
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    private String getDistributionSql(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();

        // 分别处理部门和各种信用业务的内容类别
        if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())
                        || Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())) {
            sql.append("select distinct department_name as category, ");
            sql.append("case when total is null then 0 else total end as total, case when rating_num is null then 0 else rating_num end as rating_num from ( ");
            sql.append("select department_name from sys_department where status <> 1 ) tt left join ( ");
        } else {
            sql.append("select distinct tt.dict_value as category, tt.dict_key, ");
            //信用报告增加自然人统计            
            if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                sql.append("case when total is null then 0 else total end as total, case when rating_num is null then 0 else rating_num end as rating_num, tt.group_key group_key from ( ");
                sql.append("select d.dict_key dict_key, d.dict_value dict_value, g.group_key group_key from sys_dictionary d ");
            } else {
                sql.append("case when total is null then 0 else total end as total, case when rating_num is null then 0 else rating_num end as rating_num from ( ");
                sql.append("select d.dict_key dict_key, d.dict_value dict_value from sys_dictionary d ");
            }

            // 设定信用报告、异议处理、信用修复的内容类别的字典组编码
            String groupKey = null;
            if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
                //信用报告增加自然人统计
                groupKey = "applyReportPurpose' or g.group_key ='applyPReportPurpose";
            } else if (Constants.DIMENSION_APPEAL_CONTENT.equals(operationCriteria.getDimension())){
                groupKey = "appeal_content";
            } else if(Constants.DIMENSION_REPAIR_CONTENT.equals(operationCriteria.getDimension())){
                groupKey = "repair_content";
            }
            sql.append("left join sys_dictionary_group g on d.group_id = g.id where g.group_key = '");
            sql.append(groupKey).append("') tt left join ( ");
        }

        return sql.toString();
    }

    /**
     * @Description: 根据统计维度类别统计数据
     * @param: @param operationCriteria
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    private String getCategorySql(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();
        if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
            //增加自然人统计，group_key用来区分自然人和法人
            sql.append("select dict_value as category, happendate, group_key from (  ");
        } else if (Constants.CATEGORY_OBJECTION_HANDLING.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_APPEAL_CONTENT.equals(operationCriteria.getDimension())){
                sql.append("select type_name as category, happendate from ( ");
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append("select department_name as category, happendate from (  ");
            }
        } else if (Constants.CATEGORY_CREDIT_REPAIR.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_REPAIR_CONTENT.equals(operationCriteria.getDimension())){
                sql.append("select type_name as category, happendate from ( ");
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append("select department_name as category, happendate from (  ");
            }
        } else if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())){
/*                sql.append("select dict_value as category, dict_key, tt.scxxl, happendate from (select d.dict_value dict_value, d.dict_key from sys_dictionary d ");
                sql.append("left join sys_dictionary_group g on d.group_id = g.id where g.group_key = 'reviewCategory') ");
                sql.append("left join ( ");*/
            	sql.append(" select d.type_name as category ,d.id dict_key,tt.scxxl,happendate from dz_theme d ");
            	sql.append(" right join ( ");
            } else if (Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())){
                sql.append("select department_name as category, happendate from (  ");
            }
        }

        return sql.toString();
    }

    /**
     * @Description: 根据统计主题获取所有数据源
     * @param: @param operationCriteria
     * @param: @param param
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    private String getAllDataSql(OperationCriteria operationCriteria, HashMap<String, Object> param) {
        StringBuffer sql = new StringBuffer();
        String dateField = "";
        if (Constants.CATEGORY_CREDIT_REPORT.equals(operationCriteria.getCategory())) {
            dateField = "create_date";
            String personType = operationCriteria.getPersonType();
            if (Constants.NATURAL_PERSON.equals(personType)) {//自然人
                sql.append("(select AO2.dict_value,AO2.happendate,AO2.group_key FROM(");
                sql.append("(select dd2.dict_value, t2.create_date as happendate, dd2.group_key group_key,t2.create_id from DT_PERSON_REPORT_APPLY t2 ");
                sql.append("left join (select d2.dict_key dict_key, d2.dict_value dict_value, g2.group_key group_key from sys_dictionary d2 ");
                sql.append("left join sys_dictionary_group g2 on d2.group_id = g2.id where g2.group_key = 'applyPReportPurpose' ) dd2 on dd2.dict_key = t2.purpose ");
                sql.append("where 1 = 1 ");
                // 根据统计期间查询
                if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
                    sql.append(" and t2.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("START_DATE", operationCriteria.getStartDate());
                }
                if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
                    sql.append(" and t2.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("END_DATE", operationCriteria.getEndDate());
                }

                // 根据统计类别联动趋势分析数据
                if (StringUtils.isNotEmpty(operationCriteria.getParentCondtion())) {
                    sql.append(" and dd2.dict_value||'（自然人）' = :PURPOSE");
                    param.put("PURPOSE", operationCriteria.getParentCondtion());
                }

                sql.append(" ) AO2 LEFT JOIN SYS_USER UO2 ON AO2.CREATE_ID=UO2.SYS_USER_ID) " +
                        " LEFT JOIN SYS_DEPARTMENT DO2 ON UO2.SYS_DEPARTMENT_ID=DO2.SYS_DEPARTMENT_ID where 1=1 ");
                if (StringUtils.isNotEmpty(operationCriteria.getDataSource())) {
                    if("A".equals(operationCriteria.getDataSource())){
                        sql.append(" and DO2.CODE='A0000' ");
                    } else if ("B".equals(operationCriteria.getDataSource())) {
                        sql.append(" and DO2.CODE like 'B%' ");
                    }
                }
                if (StringUtils.isNotEmpty(operationCriteria.getDepartment_bj())) {
                    sql.append(" and DO2.CODE=:CODE ");
                    param.put("CODE", operationCriteria.getDepartment_bj());
                }
            } else if (Constants.LEGAL_PERSON.equals(personType)) {//法人
                sql.append("(select AO.dict_value,AO.happendate,AO.group_key FROM(");
                sql.append("(select dd.dict_value, t.create_date as happendate, dd.group_key group_key,t.create_id  from DT_ENTERPRISE_REPORT_APPLY t ");
                sql.append("left join (select d.dict_key dict_key, d.dict_value dict_value, g.group_key group_key from sys_dictionary d ");
                sql.append("left join sys_dictionary_group g on d.group_id = g.id where g.group_key = 'applyReportPurpose') dd on dd.dict_key = t.purpose ");
                sql.append("where 1 = 1 ");
                // 根据统计期间查询
                if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
                    sql.append(" and t.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("START_DATE", operationCriteria.getStartDate());
                }
                if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
                    sql.append(" and t.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("END_DATE", operationCriteria.getEndDate());
                }


                // 根据统计类别联动趋势分析数据
                if (StringUtils.isNotEmpty(operationCriteria.getParentCondtion())) {
                    sql.append(" and dd.dict_value||'（法人）' = :PURPOSE");
                    param.put("PURPOSE", operationCriteria.getParentCondtion());
                }
                sql.append(" ) AO LEFT JOIN SYS_USER UO ON AO.CREATE_ID=UO.SYS_USER_ID) " +
                        " LEFT JOIN SYS_DEPARTMENT DO ON UO.SYS_DEPARTMENT_ID=DO.SYS_DEPARTMENT_ID where 1=1 ");
                if (StringUtils.isNotEmpty(operationCriteria.getDataSource())) {
                    if("A".equals(operationCriteria.getDataSource())){
                        sql.append(" and DO.CODE='A0000' ");
                    } else if ("B".equals(operationCriteria.getDataSource())) {
                        sql.append(" and DO.CODE like 'B%' ");
                    }
                }
                if (StringUtils.isNotEmpty(operationCriteria.getDepartment_bj())) {
                    sql.append(" and DO.CODE=:CODE ");
                    param.put("CODE", operationCriteria.getDepartment_bj());
                }
            } else {
                sql.append("(select AO.dict_value,AO.happendate,AO.group_key FROM((");
                sql.append("(select dd.dict_value, t.create_date as happendate，dd.group_key group_key,t.create_id  from DT_ENTERPRISE_REPORT_APPLY t ");
                sql.append("left join (select d.dict_key dict_key, d.dict_value dict_value, g.group_key group_key from sys_dictionary d ");
                sql.append("left join sys_dictionary_group g on d.group_id = g.id where g.group_key = 'applyReportPurpose') dd on dd.dict_key = t.purpose ");
                sql.append("where 1 = 1 ");
                // 根据统计期间查询
                if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
                    sql.append(" and t.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("START_DATE", operationCriteria.getStartDate());
                }
                if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
                    sql.append(" and t.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("END_DATE", operationCriteria.getEndDate());
                }


                // 根据统计类别联动趋势分析数据
                if (StringUtils.isNotEmpty(operationCriteria.getParentCondtion())) {
                    sql.append(" and dd.dict_value||'（法人）' = :PURPOSE");
                    param.put("PURPOSE", operationCriteria.getParentCondtion());
                }


                sql.append(") union all (");
                sql.append("select dd2.dict_value, t2.create_date as happendate, dd2.group_key group_key,t2.create_id from DT_PERSON_REPORT_APPLY t2 ");
                sql.append("left join (select d2.dict_key dict_key, d2.dict_value dict_value, g2.group_key group_key from sys_dictionary d2 ");
                sql.append("left join sys_dictionary_group g2 on d2.group_id = g2.id where g2.group_key = 'applyPReportPurpose' ) dd2 on dd2.dict_key = t2.purpose ");
                sql.append("where 1 = 1 ");
                // 根据统计期间查询
                if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
                    sql.append(" and t2.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("START_DATE", operationCriteria.getStartDate());
                }
                if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
                    sql.append(" and t2.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                    param.put("END_DATE", operationCriteria.getEndDate());
                }

                // 根据统计类别联动趋势分析数据
                if (StringUtils.isNotEmpty(operationCriteria.getParentCondtion())) {
                    sql.append(" and dd2.dict_value||'（自然人）' = :PURPOSE");
                    param.put("PURPOSE", operationCriteria.getParentCondtion());
                }

                sql.append(" )) AO LEFT JOIN SYS_USER UO ON AO.CREATE_ID=UO.SYS_USER_ID) " +
                        " LEFT JOIN SYS_DEPARTMENT DO ON UO.SYS_DEPARTMENT_ID=DO.SYS_DEPARTMENT_ID where 1=1 ");
                if (StringUtils.isNotEmpty(operationCriteria.getDataSource())) {
                    if("A".equals(operationCriteria.getDataSource())){
                        sql.append(" and DO.CODE='A0000' ");
                    } else if ("B".equals(operationCriteria.getDataSource())) {
                        sql.append(" and DO.CODE like 'B%' ");
                    }
                }

                if (StringUtils.isNotEmpty(operationCriteria.getDepartment_bj())) {
                    sql.append(" and DO.CODE=:CODE ");
                    param.put("CODE", operationCriteria.getDepartment_bj());
                }

            }
            
            sql.append(")");
            return sql.toString();
        } else if (Constants.CATEGORY_OBJECTION_HANDLING.equals(operationCriteria.getCategory())) {
            dateField = "create_date";
            if (Constants.DIMENSION_APPEAL_CONTENT.equals(operationCriteria.getDimension())){
                sql.append("select dtp.type_name, t.create_date as happendate from DT_ENTERPRISE_OBJECTION t ");
                sql.append("left join DT_ENTERPRISE_CREDIT d on t.id = d.business_id ");
                sql.append("left join dz_theme dt on dt.DATA_TABLE = d.DATA_TABLE and ZYYT = ");
                sql.append("'"+ DZThemeEnum.资源用途_异议申诉.getKey()+"'");
                sql.append(" and dt.type=");
                sql.append("'"+ DZThemeEnum.二级资源.getKey()+"' ");
                sql.append("left join dz_theme dtp on dt.parent_id = dtp.id ");
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append("select d.department_name, t.create_date as happendate from DT_ENTERPRISE_OBJECTION t ");
                sql.append("left join DT_ENTERPRISE_CREDIT C on t.ID = C.BUSINESS_ID ");
                sql.append("left join sys_department d on C.DEPT_CODE = d.CODE ");
            }
        } else if (Constants.CATEGORY_CREDIT_REPAIR.equals(operationCriteria.getCategory())) {
            dateField = "create_date";
            if (Constants.DIMENSION_REPAIR_CONTENT.equals(operationCriteria.getDimension())){
                sql.append("select dtp.type_name, t.create_date as happendate from DT_ENTERPRISE_REPAIR t ");
                sql.append("left join DT_ENTERPRISE_CREDIT d on t.id = d.business_id ");
                sql.append("left join dz_theme dt on dt.DATA_TABLE = d.DATA_TABLE and ZYYT = ");
                sql.append("'"+ DZThemeEnum.资源用途_信用修复.getKey()+"'");
                sql.append(" and dt.type=");
                sql.append("'"+ DZThemeEnum.二级资源.getKey()+"' ");
                sql.append("left join dz_theme dtp on dt.parent_id = dtp.id ");
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append("select d.department_name, t.create_date as happendate from DT_ENTERPRISE_REPAIR t ");
                sql.append("left join DT_ENTERPRISE_CREDIT C on t.ID = C.BUSINESS_ID ");
                sql.append("left join sys_department d on C.DEPT_CODE = d.CODE ");
            }
        } else if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
            dateField = "apply_date";
            //法人
            if(Constants.LEGAL_PERSON.equals(operationCriteria.getPersonType())){
            	if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())){
                    sql.append("select t.scxxl, t.apply_date as happendate from dt_credit_examine t ");
                    sql.append("left join dt_enterprise_examine d on t.id = d.credit_examine_id ");
                } else if (Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())){
                    sql.append("select d.department_name, t.apply_date as happendate from dt_credit_examine t ");
                    sql.append("left join dt_enterprise_examine de on t.id = de.credit_examine_id ");
                    sql.append("left join sys_department d on t.sys_department_id = d.sys_department_id ");
                }
            //自然人
            }else if(Constants.NATURAL_PERSON.equals(operationCriteria.getPersonType())){
            	if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())){
                    sql.append("select t.scxxl, t.apply_date as happendate from dt_credit_examine_p t ");
                    sql.append("left join dt_people_examine d on t.id = d.credit_examine_p_id ");
                } else if (Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())){
                    sql.append("select d.department_name, t.apply_date as happendate from dt_credit_examine_p t ");
                    sql.append("left join dt_people_examine de on t.id = de.credit_examine_p_id ");
                    sql.append("left join sys_department d on t.sys_department_id = d.sys_department_id ");
                }
            //全部
            }else{
            	if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())){
                    sql.append("select t.scxxl, t.apply_date as happendate from dt_credit_examine t ");
                    sql.append("left join dt_enterprise_examine d on t.id = d.credit_examine_id ");
                    sql.append("where 1 = 1 ");
                    // 根据统计期间查询
                    if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
                        sql.append(" and t.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                        param.put("START_DATE", operationCriteria.getStartDate());
                    }

                    if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
                        sql.append(" and t.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                        param.put("END_DATE", operationCriteria.getEndDate());
                    }
                    sql.append("union all ");
                    sql.append("select t.scxxl, t.apply_date as happendate from dt_credit_examine_p t ");
                    sql.append("left join dt_people_examine d on t.id = d.credit_examine_p_id ");
                } else if (Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())){
                    sql.append("select d.department_name, t.apply_date as happendate from dt_credit_examine t ");
                    sql.append("left join dt_enterprise_examine de on t.id = de.credit_examine_id ");
                    sql.append("left join sys_department d on t.sys_department_id = d.sys_department_id ");
                    sql.append("where 1 = 1 ");
                    // 根据统计期间查询
                    if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
                        sql.append(" and t.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                        param.put("START_DATE", operationCriteria.getStartDate());
                    }

                    if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
                        sql.append(" and t.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
                        param.put("END_DATE", operationCriteria.getEndDate());
                    }
                    sql.append("union all ");
                    sql.append("select d.department_name, t.apply_date as happendate from dt_credit_examine_p t ");
                    sql.append("left join dt_people_examine de on t.id = de.credit_examine_p_id ");
                    sql.append("left join sys_department d on t.sys_department_id = d.sys_department_id ");
                }
            }
            
        }

        sql.append("where 1 = 1 ");

        // 根据统计期间查询
        if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
            sql.append(" and t.").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("START_DATE", operationCriteria.getStartDate());
        }

        if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
            sql.append(" and t.").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("END_DATE", operationCriteria.getEndDate());
        }

       // 根据统计类别联动趋势分析数据
        if (StringUtils.isNotEmpty(operationCriteria.getParentCondtion())) {
            sql.append(getConditionSql(operationCriteria, param));
        }
        
        return sql.toString();
    }

    /**
     * @Description: 根据统计类别联动趋势分析数据
     * @param: @param operationCriteria
     * @param: @param param
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    private String getConditionSql(OperationCriteria operationCriteria, HashMap<String, Object> param) {
        StringBuffer sql = new StringBuffer();
        if (Constants.CATEGORY_OBJECTION_HANDLING.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_APPEAL_CONTENT.equals(operationCriteria.getDimension())){
                sql.append(" and dtp.type_name = :PARENT_CONDITION ");
                param.put("PARENT_CONDITION", operationCriteria.getParentCondtion());
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append(" and d.department_name = :DEPARTMENT_NAME ");
                param.put("DEPARTMENT_NAME", operationCriteria.getParentCondtion());
            }
        } else if (Constants.CATEGORY_CREDIT_REPAIR.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_REPAIR_CONTENT.equals(operationCriteria.getDimension())){
                sql.append(" and dtp.type_name = :PARENT_CONDITION ");
                param.put("PARENT_CONDITION", operationCriteria.getParentCondtion());
            } else if (Constants.DIMENSION_DATA_PROVIDER.equals(operationCriteria.getDimension())){
                sql.append(" and d.department_name = :DEPARTMENT_NAME ");
                param.put("DEPARTMENT_NAME", operationCriteria.getParentCondtion());
            }
        } else if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())){
                sql.append(" and t.scxxl like :SCXXL ");
                param.put("SCXXL", "%" + operationCriteria.getParentCondtion() + "%");
            } else if (Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())){
                sql.append(" and d.department_name = :DEPARTMENT_NAME ");
                param.put("DEPARTMENT_NAME", operationCriteria.getParentCondtion());
            }
        }

        return sql.toString();
    }

    /** 
     * @Description: 统计双公示的情况
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryPublicity(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> queryPublicity(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();
        
        sql.append("select distinct department_name as category, case when xk is null then 0 else xk end as xk_total, ");
        sql.append("case when rating_num_xk is null then 0 else rating_num_xk end as rating_num_xk, ");
        sql.append("case when cf is null then 0 else cf end as cf_total, ");
        sql.append("case when rating_num_cf is null then 0 else rating_num_cf end as rating_num_cf ");
        sql.append("from (select department_name from sys_department where status <> 1) tt left join ( ");
        sql.append("select distinct category,  sum(case when publicityType = '0' then 1 else 0 end)  xk, ");
        sql.append("round(100 * ratio_to_report(sum(case when publicityType = '0' then 1 else 0 end)) OVER(), 2) as rating_num_xk, ");
        sql.append("sum(case when publicityType = '1' then 1 else 0 end)  cf, ");
        sql.append("round(100 * ratio_to_report(sum(case when publicityType = '1' then 1 else 0 end)) OVER(), 2) as rating_num_cf from ");
        getAllPublicitySql(operationCriteria, sql, param);
        
        sql.append(")y group by y.category) ttt on ttt.category = tt.department_name ");
        sql.append("order by tt.department_name ");

        Map<String, Object> retMap = opeCommonDao.getAllChartDatas(sql.toString(), param);

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryPublicity", sql.toString(), param));
        }

        return retMap;
    }

    private void getAllPublicitySql(OperationCriteria operationCriteria, StringBuffer sql, HashMap<String, Object> param) {
    	sql.append("(select * from ");
        sql.append("(select bmmc as category, 0 as publicityType, tgrq, status, create_time, BMBM from YW_L_SGSXZXK union all ");
        sql.append("select bmmc as category, 1 as publicityType, tgrq, status, create_time, BMBM from YW_L_SGSXZCF ");
        sql.append(" ) ");
        sql.append("where 1 = 1 ");
        
        String dateField = ""; 
        //双公示增加上报时间和决定日期查询
        if (Constants.DIMENSION_REPORT_DATE.equals(operationCriteria.getDimension())) {
            dateField = "create_time";
        }  else {
            dateField = "tgrq";
        }
        
       //双公示增加部门查询
        if ( StringUtils.isNotBlank(operationCriteria.getDepartment())) {
             sql.append(" and BMBM =:bmbm ");
             param.put("bmbm", operationCriteria.getDepartment());
        }

        // 根据统计期间查询
        if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
            sql.append(" and ").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("START_DATE", operationCriteria.getStartDate());
        }

        if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
            sql.append(" and ").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("END_DATE", operationCriteria.getEndDate());
        }
    }
    
    /** 
     * @Description: 查询行政许可、行政处罚排行榜
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryPublicityRanking(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public List<Map<String, Object>> queryPublicityRanking(OperationCriteria operationCriteria) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();
        
        sql.append("select * from (select * from (select distinct department_name as category, case when total is null then 0 else total end as total, ");
        sql.append("case when rating_num is null then 0 else rating_num end as rating_num from (select department_name from sys_department where status <> 1) tt ");
        sql.append("left join (select distinct category, count(category) as total, round(100 * ratio_to_report(count(category)) OVER(), 2) as rating_num ");
        sql.append("from (select bmmc as category from ");
        if (Constants.PUBLICITY_TYPE_XUKE.equals(operationCriteria.getPublicityType())){
            sql.append("YW_L_SGSXZXK");
        } else {
            sql.append("YW_L_SGSXZCF");
        }
        
        sql.append(" where 1 = 1 ");
        
        String dateField = "";   
      //双公示增加上报时间和决定日期查询
        if (Constants.DIMENSION_REPORT_DATE.equals(operationCriteria.getDimension())) {
            dateField = "create_time";
        }  else {
            dateField = "tgrq";
        }
    
        //双公示增加部门查询
        if ( StringUtils.isNotBlank(operationCriteria.getDepartment()) ) {
            sql.append(" and BMBM =:bmbm ");
            param.put("bmbm", operationCriteria.getDepartment());
        }

     // 根据统计期间查询
        if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
            sql.append(" and ").append(dateField).append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("START_DATE", operationCriteria.getStartDate());
        }

        if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
            sql.append(" and ").append(dateField).append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            param.put("END_DATE", operationCriteria.getEndDate());
        }
        
        sql.append(" )y group by y.category) ttt on ttt.category = tt.department_name)ggg order by ggg.total desc) where rownum <= 5 order by total ");
        
        List<Map<String, Object>> resMap = this.findBySql(sql.toString(), param);
        
        return resMap;
    }

    /** 
     * @Description: 统计双公示的表格情况
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryPublicityTable(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
     * @since JDK 1.6
     */
    @Override
    public Pageable<Map<String, Object>> queryPublicityTable(OperationCriteria operationCriteria, Page page) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();

        sql.append("select distinct department_name as category,case when total is null then 0 else total end as total,");
        sql.append("case when xk is null then 0 else xk end as xk_total, ");
        sql.append("case when cf is null then 0 else cf end as cf_total, ");
        sql.append(" (select to_char(create_time,'yyyy-MM-dd') as create_time  from (select max(create_time)as create_time,category from (select bmmc   as category, create_time ");                              
        sql.append("from YW_L_SGSXZXK union all select bmmc   as category,create_time ");
        sql.append("from YW_L_SGSXZCF) group by category) yy where yy.category=tt.department_name  )as create_time ");
        sql.append("from (select department_name from sys_department where status <> 1) tt left join ( ");
        sql.append("select distinct category, count(category) as total, sum(case when publicityType = '0' then 1 else 0 end)  xk, ");
        sql.append("sum(case when publicityType = '1' then 1 else 0 end)  cf ");
        sql.append(" from ");
        getAllPublicitySql(operationCriteria, sql, param);
        
        sql.append(")y group by y.category) ttt on ttt.category = tt.department_name ");
        sql.append("order by tt.department_name ");

        String querySql = sql.toString();
        String countSql = " SELECT COUNT(1) FROM ( " + querySql + " ) ";

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryPublicityTable", sql.toString(), param));
        }

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(
                querySql, countSql, page, param);

        return pageable;
    }

    /**
     * 
     * @Description: 信用审查的独立表格. 
     * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryCheckTable(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
     * @since JDK 1.6
     */
    public Pageable<Map<String, Object>> queryCheckTable1(OperationCriteria operationCriteria, Page page) {
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> params = new HashMap<String, Object>();
        if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
            if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria.getDimension())){
                sql.append(" select t1.type_name dept,nvl(fshu, 0) fshu,nvl(qyshu, 0) qyshu,nvl(tg_fshu, 0) tg_fshu,nvl(tg_qyshu, 0) tg_qyshu,nvl(btg_fshu, 0) btg_fshu,nvl(btg_qyshu, 0) btg_qyshu  from ( ");
                sql.append("  select p.type_name, count(*) fshu from DT_CREDIT_EXAMINE t join dz_theme p ");
                sql.append("  on instr(t.scxxl, p.id) > 0  ");
                sql.append(" where 1=1 ");
                compareDate(sql,operationCriteria,params);
                sql.append("  group by p.type_name) t1 ");
                sql.append(" left join (select p.type_name, count(h.qymc) qyshu from DT_CREDIT_EXAMINE t join dz_theme p ");
                sql.append("  on instr(t.scxxl, p.id) > 0 left join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id ");
                sql.append(" where 1=1 ");
                compareDate(sql,operationCriteria,params);
                sql.append(" group by p.type_name) t2 ");
                sql.append(" on t1.type_name = t2.type_name ");
                sql.append(" left join  (select p.type_name, count(*) tg_fshu from DT_CREDIT_EXAMINE t join dz_theme p ");
                sql.append(" on instr(t.scxxl, p.id) > 0  where t.status=2 ");
                compareDate(sql,operationCriteria,params);
                sql.append(" group by p.type_name) t3 ");
                sql.append(" on t1.type_name = t3.type_name ");
                if(Constants.NATURAL_PERSON.equals(operationCriteria.getPersonType())){
             	   sql.append(" left join (select p.type_name, count(h.xm) tg_qyshu from DT_CREDIT_EXAMINE_P t join dz_theme p ");
             	   sql.append(" on instr(t.scxxl, p.id) > 0 left join dt_people_examine h on h.credit_examine_p_id = t.id ");
             	   sql.append(" where t.status=2 ");
             	   compareDate(sql,operationCriteria,params);
             	   sql.append("  group by p.type_name) t4 ");
                }else if(Constants.LEGAL_PERSON.equals(operationCriteria.getPersonType())){
             	   sql.append(" left join (select p.type_name, count(h.qymc) tg_qyshu from DT_CREDIT_EXAMINE t join dz_theme p ");
             	   sql.append(" on instr(t.scxxl, p.id) > 0 left join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id ");
             	   sql.append(" where t.status=2 ");
             	   compareDate(sql,operationCriteria,params);
             	   sql.append("  group by p.type_name) t4 ");
                }else {
             	   sql.append(" left join (select type_name,count(1) tg_qyshu from( ");
             	   sql.append(" select p.type_name from DT_CREDIT_EXAMINE t join dz_theme p ");
             	   sql.append(" on instr(t.scxxl, p.id) > 0 left join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id ");
             	   sql.append(" where t.status=2 ");
             	   compareDate(sql,operationCriteria,params);
             	   sql.append("union all ");
             	   sql.append(" select p.type_name from DT_CREDIT_EXAMINE_P t join dz_theme p ");
             	   sql.append(" on instr(t.scxxl, p.id) > 0 left join dt_people_examine h on h.credit_examine_p_id = t.id ");
             	   sql.append(" where t.status=2 ");
             	   compareDate(sql,operationCriteria,params);
             	   sql.append(" ) group by type_name) t4 ");
                }
                sql.append("  on t1.type_name = t4.type_name ");
                sql.append(" left join (select p.type_name, count(*) btg_fshu  from DT_CREDIT_EXAMINE t ");
                sql.append(" join dz_theme p  on instr(t.scxxl, p.id) > 0 where t.status=1 ");
                compareDate(sql,operationCriteria,params);
                sql.append("  group by p.type_name) t5 ");
                sql.append("  on t1.type_name = t5.type_name ");
                sql.append(" left join (select p.type_name, count(h.qymc) btg_qyshu from DT_CREDIT_EXAMINE t join dz_theme p ");
                sql.append(" on instr(t.scxxl, p.id) > 0 left join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id ");
                sql.append(" where t.status=1 ");
                compareDate(sql,operationCriteria,params);
                sql.append("  group by p.type_name) t6 ");
                sql.append("  on t1.type_name = t6.type_name    ");
                sql.append(" order by t1.type_name desc ");
               
            } else if (Constants.DIMENSION_APPLICATION_DEPARTMENT.equals(operationCriteria.getDimension())){
                sql.append(" select f.gg dept,nvl(fShu, 0) fShu,nvl(qyShu, 0) qyShu,nvl(tg_fShu, 0) tg_fShu,nvl(tg_qyShu, 0) tg_qyShu,nvl(btg_fShu, 0) btg_fShu,nvl(btg_qyShu, 0) btg_qyShu ");
                sql.append(" from ( ");
                if(Constants.NATURAL_PERSON.equals(operationCriteria.getPersonType())){
             	   sql.append(" select p.department_name gg, count(h.xm) qyShu from DT_CREDIT_EXAMINE_P t");
             	   sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id ");
                    sql.append(" join dt_people_examine h  on h.credit_examine_p_id = t.id");
                    sql.append(" where 1=1 ");
                    compareDate(sql,operationCriteria,params);
                }else if(Constants.LEGAL_PERSON.equals(operationCriteria.getPersonType())){
             	   sql.append(" select p.department_name gg, count(h.qymc) qyShu from DT_CREDIT_EXAMINE t");
             	   sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id ");
                    sql.append(" join DT_ENTERPRISE_EXAMINE h  on h.credit_examine_id = t.id");
                    sql.append(" where 1=1 ");
                    compareDate(sql,operationCriteria,params);
                }else {
             	   sql.append(" select p.department_name gg, count(h.qymc) qyShu from (select * from DT_CREDIT_EXAMINE union all select * from DT_CREDIT_EXAMINE_P) t");
             	   sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id ");
                    sql.append(" join ");
                    sql.append(" (select qymc,credit_examine_id  from DT_ENTERPRISE_EXAMINE ");
                    sql.append(" union all ");
                    sql.append(" select xm,credit_examine_p_id from dt_people_examine)h ");
                    sql.append("   on h.credit_examine_id = t.id");
                    sql.append(" where 1=1 ");
                    compareDate(sql,operationCriteria,params);
                }
               
                sql.append(" group by p.department_name) f ");
                sql.append(" left join (select p.department_name ee, count(*) fShu  from DT_CREDIT_EXAMINE_P t");
                sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id ");
                sql.append(" where 1=1 ");
                compareDate(sql,operationCriteria,params);
                sql.append(" group by p.department_name) k ");
                sql.append(" on k.ee = f.gg");
                sql.append(" left join (select p.department_name tg_ee, count(*) tg_fShu  from DT_CREDIT_EXAMINE_P t");
                sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id  where t.status = 2");
                compareDate(sql,operationCriteria,params);
                sql.append(" group by p.department_name) l ");
                sql.append(" on f.gg = l.tg_ee");
                sql.append(" left join (select p.department_name gg, count(h.qymc) tg_qyShu  from DT_CREDIT_EXAMINE t ");
                sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id ");
                sql.append(" join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id  where t.status = 2 ");
                compareDate(sql,operationCriteria,params);
                sql.append(" group by p.department_name) m ");
                sql.append(" on f.gg = m.gg ");
                sql.append(" left join (select p.department_name tg_ee, count(*) btg_fShu from DT_CREDIT_EXAMINE_P t ");
                sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id where t.status = 1 ");
                compareDate(sql,operationCriteria,params);
                sql.append(" group by p.department_name) x  ");
                sql.append(" on f.gg = x.tg_ee ");
                sql.append(" left join (select p.department_name gg, count(*) btg_qyShu  from DT_CREDIT_EXAMINE t ");
                sql.append(" join sys_department p on t.sys_department_id = p.sys_department_id ");
                sql.append(" join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id where t.status = 1 ");
                compareDate(sql,operationCriteria,params);
                sql.append(" group by p.department_name) y  ");
                sql.append(" on f.gg = y.gg ");
                sql.append(" order by fShu desc ");
            }
        }     
                
            
        
        
        
        String querySql = sql.toString();
        String countSql = " SELECT COUNT(1) FROM ( " + querySql + " ) ";

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryCheckTable", sql.toString(), params));
        }
        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(
                        querySql, countSql, page, params);
        
        return pageable;
    }  
    
    /**
        * 
        * @Description: 信用审查的独立表格. 
        * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryCheckTable(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
        * @since JDK 1.6
        */
       public Pageable<Map<String, Object>> queryCheckTable(OperationCriteria operationCriteria, Page page) {
    	   StringBuffer sql = new StringBuffer();
    	   HashMap<String, Object> params = new HashMap<String, Object>();
    	   getCommonSql(sql,operationCriteria,params);
           String querySql = sql.toString();
           String countSql = " SELECT COUNT(1) FROM ( " + querySql + " ) ";
           if (logger.isInfoEnabled()) {
               logger.info(opeCommonDao.getLogStr("queryCheckTable", sql.toString(), params));
           }
           Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(
                           querySql, countSql, page, params);
           
           return pageable;
       }
       
       /**
     * @Description:查询申请部门分析            
     * @param: @param operationCriteria
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.7.0_79
     */
    public Map<String, Object>  queryCheckBar(OperationCriteria operationCriteria) {
    	   StringBuffer sql = new StringBuffer();
    	   HashMap<String, Object> params = new HashMap<String, Object>();
    	   getCommonSql(sql,operationCriteria,params);
           Map<String, Object> retMap = opeCommonDao.getAllChartDatas(sql.toString(), params);

           if (logger.isInfoEnabled()) {
               logger.info(opeCommonDao.getLogStr("queryCheckBar", sql.toString(), params));
           }

           return retMap;
           
       }
       
       private void getCommonSql(StringBuffer sql,OperationCriteria operationCriteria,HashMap<String, Object> params){
		if (Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria
				.getCategory())) {
			if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria
					.getDimension())) {
				sql.append(" 	select d.id did,                                            ");
				sql.append(" 		   d.type_name dept, d.type_name category, ");
			} else if (Constants.DIMENSION_APPLICATION_DEPARTMENT
					.equals(operationCriteria.getDimension())) {
				sql.append(" 	select d.sys_department_id,                                            ");
				sql.append(" 		   d.department_name dept,d.department_name category,                                         ");
			}
			sql.append(" 		   count(0) fshu, count(0) total_l,                               ");
			sql.append(" 		   sum(dws) qyshu,   sum(dws) total,                              ");
			sql.append(" 		   sum(case                                                        ");
			sql.append(" 				 when t.status = 1 then                                    ");
			sql.append(" 				  1                                                        ");
			sql.append(" 				 else                                                      ");
			sql.append(" 				  0                                                        ");
			sql.append(" 			   end) btg_fshu,                                                  ");
			sql.append(" 		   sum(case                                                        ");
			sql.append(" 				 when t.status = 1 then                                    ");
			sql.append(" 				  t.dws                                                    ");
			sql.append(" 				 else                                                      ");
			sql.append(" 				  0                                                        ");
			sql.append(" 			   end) btg_qyshu,                                                 ");
			sql.append(" 		   sum(case                                                        ");
			sql.append(" 				 when t.status = 2 then                                    ");
			sql.append(" 				  1                                                        ");
			sql.append(" 				 else                                                      ");
			sql.append(" 				  0                                                        ");
			sql.append(" 			   end) tg_fshu,                                                  ");
			sql.append(" 		   sum(case                                                        ");
			sql.append(" 				 when t.status = 2 then                                    ");
			sql.append(" 				  t.dws                                                    ");
			sql.append(" 				 else                                                      ");
			sql.append(" 				  0                                                        ");
			sql.append(" 			   end) tg_qyshu                                                  ");
			sql.append(" 	  from (select h.id,    h.scxxl,                                               ");
			sql.append(" 				   h.sys_department_id,                                    ");
			sql.append(" 				   h.status,                                               ");
			sql.append(" 				   h.apply_date,                                           ");
			sql.append(" 				   count(1) dws,                                           ");
			sql.append(" 				   '0' personType                                          ");
			sql.append(" 			  from DT_CREDIT_EXAMINE h, dt_enterprise_examine l            ");
			sql.append(" 			 where h.id = l.credit_examine_id                              ");
			sql.append(" 			 group by h.id,h.scxxl, h.sys_department_id, h.status, h.apply_date    ");
			sql.append(" 			union all                                                      ");
			sql.append(" 			select h.id, h.scxxl,                                                  ");
			sql.append(" 				   h.sys_department_id,                                    ");
			sql.append(" 				   h.status,                                               ");
			sql.append(" 				   h.apply_date,                                           ");
			sql.append(" 				   count(1) dws,                                           ");
			sql.append(" 				   '1' personType                                          ");
			sql.append(" 			  from DT_CREDIT_EXAMINE_p h, dt_people_examine l              ");
			sql.append(" 			 where h.id = l.credit_examine_p_id                            ");
			sql.append(" 			 group by h.id, h.scxxl,h.sys_department_id, h.status, h.apply_date) t ");
			if (Constants.DIMENSION_REVIEW_CATEGORY.equals(operationCriteria
					.getDimension())) {
				sql.append(" 	  left join dz_theme d                                           ");
				sql.append(" 		on instr(t.scxxl, d.id) > 0  where 1=1           ");
				compareDate(sql, operationCriteria, params);
				sql.append(" 	 group by d.id, d.type_name                       ");
			} else if (Constants.DIMENSION_APPLICATION_DEPARTMENT
					.equals(operationCriteria.getDimension())) {
				sql.append(" 	  left join sys_department d                                           ");
				sql.append(" 		on t.sys_department_id = d.sys_department_id where 1=1             ");
				compareDate(sql, operationCriteria, params);
				sql.append(" 	 group by d.sys_department_id, d.department_name                       ");
			}
		}
       }
       /**
        * 
        * @Description: 封装信用审查统计时间对比
        * @param: @param sql
        * @param: @param operationCriteria
        * @param: @param params
        * @return: void
        * @throws
        * @since JDK 1.6
        */
       private void compareDate(StringBuffer sql, OperationCriteria operationCriteria, Map<String, Object> params){

           // 根据统计期间查询
           if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
               sql.append(" and t.apply_date").append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
               params.put("START_DATE", operationCriteria.getStartDate());
           }

           if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
               sql.append(" and t.apply_date").append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
               params.put("END_DATE", operationCriteria.getEndDate());
           }
           
           //办件部门
           if(StringUtils.isNotEmpty(operationCriteria.getDepartment_bj())){
        	   sql.append(" and t.sys_department_id=:deptId ");
               params.put("deptId", operationCriteria.getDepartment_bj());
           }
           if(StringUtils.isNotEmpty(operationCriteria.getPersonType())){
        	   sql.append(" and t.personType=:personType ");
               params.put("personType", operationCriteria.getPersonType());
           }
       }

       /**
        * 
        * @Description: 封装信用报告一部分相同的sql
        * @param: @return
        * @return: String
        * @throws
        * @since JDK 1.6
        */
       public void getCreditReportPartSql(StringBuffer sql, OperationCriteria operationCriteria){
           sql.append("  left join (SELECT (case when group_key = 'applyReportPurpose' then ");
           sql.append(" dict_value || '（法人）' else dict_value || '（自然人）' end)  ");
           sql.append(" as category, group_key, sd.* ");
           sql.append(" from sys_dictionary sd left join sys_dictionary_group sg ");
           sql.append(" on sd.group_id = sg.id ");
           sql.append(" where sg.group_key in ");
           if (Constants.NATURAL_PERSON.equals(operationCriteria.getPersonType())) {//法人
               sql.append(" ('applyPReportPurpose'))  tt ");
           } else  if (Constants.LEGAL_PERSON.equals(operationCriteria.getPersonType())) {//法人
               sql.append(" ('applyReportPurpose'))  tt ");
           } else {
               sql.append(" ('applyReportPurpose', 'applyPReportPurpose'))  tt ");
           }
           sql.append(" on t.purpose = tt.dict_key and t.group_key=tt.group_key ");
       }
       
     

       /**
        * 
        * @Description: 封装信用审查统计时间对比
        * @param: @param sql
        * @param: @param operationCriteria
        * @param: @param params
        * @return: void
        * @throws
        * @since JDK 1.6
        */
       private void compareCreditReportDate(StringBuffer sql, OperationCriteria operationCriteria, Map<String, Object> params){

           // 根据统计期间查询
           if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
               sql.append(" and t.create_date").append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
               params.put("START_DATE", operationCriteria.getStartDate());
           }

           if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
               sql.append(" and t.create_date").append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
               params.put("END_DATE", operationCriteria.getEndDate());
           }
           
       }
       /**
        * 
        * @Description: 查询信用报告的表格. 
        * @see： @see com.udatech.center.operationAnalysis.dao.BusinessApplicationDao#queryCreditReportTable(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
        * @since JDK 1.6
        */
    @Override
    public Pageable<Map<String, Object>> queryCreditReportTable(OperationCriteria operationCriteria, Page page) {
        StringBuffer sql =new StringBuffer();
        HashMap<String, Object> params = new HashMap<String, Object>();
        sql.append(" SELECT CATEGORY,AREA_DEPTS,PROJECT_NAME,PROJECT_XL, COUNT(*) APPLYCOUNT,SUM(TG_COUNT) TG_COUNT,");
        sql.append("  SUM(BTG_COUNT) BTG_COUNT,SUM(ISSUE_COUNT) ISSUE_COUNT, SUM(END_COUNT) END_COUNT ");
        sql.append("   FROM " +
                " (SELECT A.CATEGORY,A.AREA_DEPTS,A.PROJECT_NAME,A.PROJECT_XL,TG_COUNT,BTG_COUNT,ISSUE_COUNT,END_COUNT FROM (" +
                " (SELECT TT.CATEGORY ,T.AREA_DEPTS,T.PROJECT_NAME,T.PROJECT_XL, T.CREATE_ID, CASE WHEN T.STATUS = 1 THEN  1 ELSE 0 END TG_COUNT, ");
        sql.append(" CASE WHEN T.STATUS = 2 THEN 1 ELSE 0 END BTG_COUNT, CASE WHEN T.IS_ISSUE =1 OR T.IS_ISSUE = 2 THEN 1 ELSE 0 END ISSUE_COUNT, CASE WHEN T.IS_ISSUE=2 THEN 1 ELSE 0 END END_COUNT ");
        if(operationCriteria.getData().indexOf("法人")>=0){
        	sql.append(" from (select t.*,'applyReportPurpose' group_key from  DT_ENTERPRISE_REPORT_APPLY t) t ");
        }else{
        	sql.append(" from (select t.*,'applyPReportPurpose' group_key ,'' PROJECT_XL ,'' AREA_DEPTS,'' PROJECT_NAME from  DT_PERSON_REPORT_APPLY t) t ");

        }
        getCreditReportPartSql(sql,operationCriteria);
        sql.append(" where 1=1 ");
        compareCreditReportDate(sql,operationCriteria,params);
        sql.append(" ) A JOIN SYS_USER U ON A.CREATE_ID=U.SYS_USER_ID) JOIN SYS_DEPARTMENT D ON U.SYS_DEPARTMENT_ID=D.SYS_DEPARTMENT_ID WHERE 1=1");
        if (StringUtils.isNotEmpty(operationCriteria.getDataSource())) {
            if("A".equals(operationCriteria.getDataSource())){
                sql.append(" and D.CODE='A0000' ");
            } else if ("B".equals(operationCriteria.getDataSource())) {
                sql.append(" and D.CODE like 'B%' ");
            }
        }

        if (StringUtils.isNotEmpty(operationCriteria.getDepartment_bj())) {
            sql.append(" and D.SYS_DEPARTMENT_ID=:deptId ");
            params.put("deptId", operationCriteria.getDepartment_bj());
        }
        sql.append(" )");

        if (StringUtils.isNotEmpty(operationCriteria.getData())) {
            sql.append(" where CATEGORY=:data ");
            params.put("data", operationCriteria.getData());
        }
        sql.append(" GROUP BY CATEGORY, AREA_DEPTS, PROJECT_NAME, PROJECT_XL ");
        sql.append(" ORDER BY APPLYCOUNT DESC ");
        
        String querySql = sql.toString();
        String countSql = " SELECT COUNT(1) FROM ( " + querySql + " ) ";

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryCreditReportTable", sql.toString(), params));
        }
        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(
                        querySql, countSql, page, params);
        
        return pageable;
    }

    @Override
    public Pageable<Map<String, Object>> queryCreditReportTable_5(OperationCriteria operationCriteria, Page page) {
        StringBuffer sql =new StringBuffer();
        HashMap<String, Object> params = new HashMap<String, Object>();
        sql.append(" SELECT CATEGORY, COUNT(*) APPLYCOUNT,SUM(TG_COUNT) TG_COUNT,");
        sql.append("  SUM(BTG_COUNT) BTG_COUNT,SUM(ISSUE_COUNT) ISSUE_COUNT, SUM(END_COUNT) END_COUNT ");
        sql.append("   FROM " +
                " (SELECT A.CATEGORY,TG_COUNT,BTG_COUNT,ISSUE_COUNT,END_COUNT FROM (" +
                " (SELECT TT.CATEGORY , T.CREATE_ID, CASE WHEN T.STATUS = 1 THEN  1 ELSE 0 END TG_COUNT, ");
        sql.append(" CASE WHEN T.STATUS = 2 THEN 1 ELSE 0 END BTG_COUNT, CASE WHEN T.IS_ISSUE =1 OR T.IS_ISSUE = 2 THEN 1 ELSE 0 END ISSUE_COUNT, CASE WHEN T.IS_ISSUE=2 THEN 1 ELSE 0 END END_COUNT ");
        if (Constants.LEGAL_PERSON.equals(operationCriteria.getPersonType())) {//法人
        	sql.append(" from (select create_date,PURPOSE,CREATE_ID,STATUS,IS_ISSUE, 'applyReportPurpose' group_key from DT_ENTERPRISE_REPORT_APPLY ) t ");
        }else if(Constants.NATURAL_PERSON.equals(operationCriteria.getPersonType())){//自然人
        	sql.append(" from (select  create_date,PURPOSE,CREATE_ID,STATUS,IS_ISSUE, 'applyPReportPurpose' group_key from DT_PERSON_REPORT_APPLY) t ");
        }else{
        	sql.append(" from ( ");
        	sql.append(" select  create_date,PURPOSE,CREATE_ID,STATUS,IS_ISSUE, 'applyReportPurpose' group_key from DT_ENTERPRISE_REPORT_APPLY t ");
        	sql.append(" union all ");
        	sql.append(" select  create_date,PURPOSE,CREATE_ID,STATUS,IS_ISSUE, 'applyPReportPurpose' group_key from DT_PERSON_REPORT_APPLY t ");
        	sql.append(" )t ");
        }
        getCreditReportPartSql(sql,operationCriteria);
        sql.append(" where 1=1 ");
        compareCreditReportDate(sql,operationCriteria,params);
        sql.append(" ) A JOIN SYS_USER U ON A.CREATE_ID=U.SYS_USER_ID) JOIN SYS_DEPARTMENT D ON U.SYS_DEPARTMENT_ID=D.SYS_DEPARTMENT_ID WHERE 1=1");
        if (StringUtils.isNotEmpty(operationCriteria.getDataSource())) {
            if("A".equals(operationCriteria.getDataSource())){
                sql.append(" and D.CODE='A0000' ");
            } else if ("B".equals(operationCriteria.getDataSource())) {
                sql.append(" and D.CODE like 'B%' ");
            }
        }

        if (StringUtils.isNotEmpty(operationCriteria.getDepartment_bj())) {
            sql.append(" and D.CODE=:CODE ");
            params.put("CODE", operationCriteria.getDepartment_bj());
        }
        sql.append(" )");


        sql.append(" GROUP BY CATEGORY ");
        sql.append(" ORDER BY APPLYCOUNT DESC ");

        String querySql = sql.toString();
        String countSql = " SELECT COUNT(1) FROM ( " + querySql + " ) ";

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryCreditReportTable", sql.toString(), params));
        }
        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(
                querySql, countSql, page, params);

        return pageable;
    }
    
    /**
     * @Description: 统计月办理量
     * @param: @param operationCriteria 封装查询条件，包括（统计开始日期、结束日期等）
     * @param: @return
     * @return: Map<String, Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> queryMonthlyHandle(OperationCriteria operationCriteria){
        StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();
        
        if(Constants.NATURAL_PERSON.equals(operationCriteria.getPersonType())){
        	 sql.append("select  count(1) as TOTAL,to_char(apply_date,'yyyy')||'.'||to_char(apply_date,'mm')as CATEGORY ");
             sql.append(" from DT_CREDIT_EXAMINE_P t ");
             //sql.append(" join DT_PEOPLE_EXAMINE h on h.credit_examine_p_id = t.id ");
             sql.append(" join sys_department s on s.sys_department_id = t.sys_department_id ");
             sql.append("  where t.status<>0 and 1=1 ");
             compareHandleDate(sql,operationCriteria,param);
             sql.append(" group by to_char(apply_date,'yyyy')||'.'||to_char(apply_date,'mm') order by  CATEGORY ");
        }else if(Constants.LEGAL_PERSON.equals(operationCriteria.getPersonType())){
        	 sql.append("select  count(1) as TOTAL,to_char(apply_date,'yyyy')||'.'||to_char(apply_date,'mm') as CATEGORY ");
             sql.append(" from DT_CREDIT_EXAMINE t ");
             //sql.append(" join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id ");
             sql.append(" join sys_department s on s.sys_department_id = t.sys_department_id ");
             sql.append("  where t.status<>0 and 1=1 ");
             compareHandleDate(sql,operationCriteria,param);
             sql.append(" group by to_char(apply_date,'yyyy')||'.'||to_char(apply_date,'mm') order by  CATEGORY ");
        }else{
        	 sql.append("select count(1) as TOTAL,CATEGORY from (");
        	 sql.append("select to_char(apply_date,'yyyy')||'.'||to_char(apply_date,'mm') as CATEGORY ");
             sql.append(" from DT_CREDIT_EXAMINE_P t ");
             //sql.append(" join DT_PEOPLE_EXAMINE h on h.credit_examine_p_id = t.id ");
             sql.append(" join sys_department s on s.sys_department_id = t.sys_department_id ");
             sql.append("  where t.status<>0 and 1=1 ");
             compareHandleDate(sql,operationCriteria,param);
             sql.append(" union all ");
             sql.append("select  to_char(apply_date,'yyyy')||'.'||to_char(apply_date,'mm')as month ");
             sql.append(" from DT_CREDIT_EXAMINE t ");
             //sql.append(" join DT_ENTERPRISE_EXAMINE h on h.credit_examine_id = t.id ");
             sql.append(" join sys_department s on s.sys_department_id = t.sys_department_id ");
             sql.append("  where t.status<>0 and 1=1 ");
             compareHandleDate(sql,operationCriteria,param);
             sql.append(" )group by CATEGORY order by  CATEGORY ");
        }
       
        Map<String, Object> retMap = opeCommonDao.getAllChartDatas(sql.toString(), param);

        if (logger.isInfoEnabled()) {
            logger.info(opeCommonDao.getLogStr("queryMonthlyHandle", sql.toString(), param));
        }

        return retMap;
    }
    
    /**
     * 
     * @Description: 封装信用审查统计时间对比
     * @param: @param sql
     * @param: @param operationCriteria
     * @param: @param params
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    private void compareHandleDate(StringBuffer sql, OperationCriteria operationCriteria, Map<String, Object> params){

    	if(StringUtils.isEmpty(operationCriteria.getStartDate()) && 
    			StringUtils.isEmpty(operationCriteria.getStartDate())){
    		Calendar calendar = Calendar.getInstance();
            Date date = new Date(System.currentTimeMillis());
            calendar.setTime(date);
//            calendar.add(Calendar.WEEK_OF_YEAR, -1);
            calendar.add(Calendar.MONTH, -6);
            date = calendar.getTime();
            System.out.println(date);
            sql.append(" and t.apply_date >=:START_DATE ");
            params.put("START_DATE", date);
    		 //sql.append(" and t.apply_date >=to_date(add_months(sysdate,-6),'yyyy-MM-dd hh24:mi:ss') ");
    	}
        // 根据统计期间查询
        if (StringUtils.isNotEmpty(operationCriteria.getStartDate())){
            sql.append(" and t.apply_date").append(" >= to_date(:START_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            params.put("START_DATE", operationCriteria.getStartDate());
        }

        if (StringUtils.isNotEmpty(operationCriteria.getEndDate())){
            sql.append(" and t.apply_date").append(" <= to_date(:END_DATE,'yyyy-MM-dd hh24:mi:ss') ");
            params.put("END_DATE", operationCriteria.getEndDate());
        }
        
        //办件部门
        if(StringUtils.isNotEmpty(operationCriteria.getDepartment_bj())){
     	   sql.append(" and t.sys_department_id=:deptId");
            params.put("deptId", operationCriteria.getDepartment_bj());
        }
        
    }
}
