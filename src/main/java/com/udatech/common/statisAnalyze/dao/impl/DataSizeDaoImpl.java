package com.udatech.common.statisAnalyze.dao.impl;

import com.udatech.common.statisAnalyze.dao.DataSizeDao;
import com.udatech.common.statisAnalyze.dao.DataStatisticsCommonDao;
import com.udatech.common.statisAnalyze.model.DataSize;
import com.udatech.common.statisAnalyze.vo.StatisticsCriteria;
import com.wa.framework.Page;
import com.wa.framework.dao.BaseDaoSupport;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.*;

/**
 * @author Administrator
 * @category 数据量统计
 */
@Repository
public class DataSizeDaoImpl extends BaseDaoSupport implements DataSizeDao {

	@Autowired
	private DataStatisticsCommonDao dataStatisticsCommonDao;

	/**
	 * @param deptcode
	 * @return
	 * @Title: getDeptIdByCode
	 * @category 根绝部门Code获取部门ID
	 * @return: String
	 */
	public String getDeptIdByCode(String deptcode) {
		String sql = "SELECT SYS_DEPARTMENT_ID AS DEPTID FROM SYS_DEPARTMENT WHERE CODE = :I_CODE AND STATUS = '0' ";
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("I_CODE", deptcode);
		Map<String, Object> resMap = this.findBySql(sql, param).get(0);
		return resMap.get("DEPTID").toString();
	}

	/**
	 * @throws
	 * @Description:分别统计各种上传方式的上报数据量
	 * @param: @return
	 * @return: Map<String       ,               Object>
	 * @since JDK 1.7.0_79
	 */
	@Override
	public Map<String, Object> getTotalByCategory(StatisticsCriteria statisticsCriteria) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> res = new HashMap<String, Object>();
		StringBuffer strb = new StringBuffer();
		strb.append("select sum(allSize) as allSize,");// 上报量
		strb.append(" sum(failSize) as failSize,");// 疑问总量
		strb.append(" sum(updateSize) as updateSize,");// 更新量
		strb.append(" sum(successSize) as successSize,");// 入库量
		strb.append(" sum(notRelatedSize) as notRelatedSize ");// 未关联数据
		strb.append(" from (select sum(allSize) as allSize,");// 上报量
		strb.append(" sum(failSize) as failSize,");// 疑问总量
		strb.append(" sum(updateProcess) as updateSize,");// 更新量
		strb.append(" sum(successSize) as successSize,");// 入库量
		strb.append(" sum(notRelatedSize) as notRelatedSize ");// 未关联数据
		strb.append(" from (");
		getCommonQuerySql(strb);
		strb.append(" )s left join dp_logic_table t on s.logic_table_id=t.id   ");
		getCondition(strb, statisticsCriteria, param);
		strb.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept)            ");
		strb.append("  group by s.dept_id) ");
		String sql = strb.toString();

		// 打印日志
		if (logger.isInfoEnabled()) {
			logger.info(dataStatisticsCommonDao.getLogStr("getTotalByCategory", sql, param));
		}
		List<Map<String, Object>> list = this.findBySql(sql, param);
		if (list != null && list.size() > 0) {
			res.put("allSize", MapUtils.getIntValue(list.get(0), "ALLSIZE"));
			res.put("failSize", MapUtils.getIntValue(list.get(0), "FAILSIZE"));
			res.put("updateSize", MapUtils.getIntValue(list.get(0), "UPDATESIZE"));
			res.put("notRelatedSize", MapUtils.getIntValue(list.get(0), "NOTRELATEDSIZE"));
			res.put("successSize", MapUtils.getIntValue(list.get(0), "SUCCESSSIZE"));
		}

		getSchemaTotal(res, statisticsCriteria);
		return res;
	}

	/**
	 * @throws
	 * @Description: 归集目录总计 ： 当前部门的数据目录总和；
	 * @param: @param res
	 * @return: void
	 * @since JDK 1.7.0_79
	 */
	private void getSchemaTotal(Map<String, Object> res, StatisticsCriteria statisticsCriteria) {
		StringBuffer sb = new StringBuffer();
		HashMap<String, Object> params = new HashMap<String, Object>();
		sb.append("SELECT COUNT(1) as SCHEMA_SIZE FROM ");
		sb.append("(select s.LOGIC_TABLE_ID from ");
		sb.append("(select  to_char(create_time, 'yyyy-mm-dd') as create_time,");
		sb.append(" dept_id,LOGIC_TABLE_ID  ");
		sb.append("  from dp_data_size) s  ");
		sb.append(" INNER JOIN DP_LOGIC_TABLE t ON t.ID=s.LOGIC_TABLE_ID ");
		getCondition(sb, statisticsCriteria, params);
		sb.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept)            ");
		sb.append(" group by s.LOGIC_TABLE_ID)");
		String sql = sb.toString();
		List<Map<String, Object>> list = this.findBySql(sql, params);
		int schemaSize = 0;
		if (list != null && list.size() > 0) {
			schemaSize = MapUtils.getIntValue(list.get(0), "SCHEMA_SIZE");
		}
		res.put("schemaSize", schemaSize);
	}

	/**
	 * @Description: 根据上传方式，查询类型查询上报量、有效量、疑问量
	 * @see： @see com.udatech.center.dataStatistics.dao.DataStatisticsDao#queryStorageQuantity(java.lang.String, java.lang.String)
	 * @since JDK 1.7.0_79
	 */
	@Override
	public Map<String, Object> queryStorageQuantity(StatisticsCriteria statisticsCriteria) {
		StringBuffer sql = new StringBuffer();
		HashMap<String, Object> param = new HashMap<String, Object>();

		//上报数据量统计
		if (StatisticsCriteria.PIE_DATA.equals(statisticsCriteria.getChartsType())) {
			getPieSql(sql, statisticsCriteria, param);

			// 上报方式统计
		} else if (StatisticsCriteria.PIE_WAY.equals(statisticsCriteria.getChartsType())) {
			getPieWaySql(sql, statisticsCriteria, param);

			// 数据上报月度统计
		} else if (StatisticsCriteria.TREND.equals(statisticsCriteria.getChartsType())
				|| StatisticsCriteria.TREND_DEPT.equals(statisticsCriteria.getChartsType())) {
			getHistogramSql(sql, statisticsCriteria, param);

			// 数据上报统计
		} else if (StatisticsCriteria.HISTOGRAM.equals(statisticsCriteria.getChartsType())
				|| StatisticsCriteria.HISTOGRAM_DEPT.equals(statisticsCriteria.getChartsType())) {
			getSqlByCatalog(sql, statisticsCriteria, param);
		}

		Map<String, Object> retMap = dataStatisticsCommonDao.getAllChartDatas(sql.toString(), param);

		if (logger.isInfoEnabled()) {
			logger.info(dataStatisticsCommonDao.getLogStr("queryStorageQuantity", sql.toString(), param));
		}

		return retMap;
	}

	private void getHistogramSql(StringBuffer sql, StatisticsCriteria statisticsCriteria, HashMap<String, Object> param) {
		sql.append("select startDate,                                                               ");
		sql.append("        allSize,                           ");//上报量
		sql.append("        successSize,                   ");//入库量
		sql.append("        failSize,                          ");//疑问量
		sql.append("        updateProcess ,               ");//更新量
		sql.append("        notRelatedSize               ");//未关联量
		sql.append("  from (select startDate,                                                       ");
		sql.append("               sum(nvl(allSize,0)) allSize,                                      ");
		sql.append("               sum(nvl(successSize,0)) successSize,                             ");
		sql.append("               sum(nvl(failSize,0)) failSize,                                    ");
		sql.append("               sum(nvl(updateProcess,0)) updateProcess,                         ");
		sql.append("               sum(nvl(notRelatedSize,0)) notRelatedSize                        ");
		sql.append("          from (select startDate,                                               ");
		sql.append("                       allSize,                                                 ");
		sql.append("                       successSize,                                             ");
		sql.append("                       failSize,                                                 ");
		sql.append("                       updateProcess,                                            ");
		sql.append("                       notRelatedSize                                           ");
		sql.append("                  from(                                                         ");
		sql.append(dataStatisticsCommonDao.getDaysListSql());
		sql.append("                  )left join                                                    ");
		sql.append("                          ( select s.*,t.name from (                            ");
		getCommonQuerySql(sql);
		sql.append("              )s  left join dp_logic_table t on s.logic_table_id=t.id            ");
		getCondition(sql, statisticsCriteria, param);
		sql.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept)            ");
		sql.append("            )s on startDate = to_char(to_date(create_time,'yyyy-mm-dd'),'yyyy-mm') ");
		sql.append("         ) group by startDate                                                   ");
		sql.append("         order by startDate)                                                    ");
	}

	/**
	 * @throws
	 * @Description:按目录名称统计上报量、有效量、疑问量等
	 * @param: @param statisticsCriteria
	 * @param: @param page
	 * @param: @return
	 * @return: List<Map       <       String       ,       Object>>
	 * @since JDK 1.7.0_79
	 */
	public List<Map<String, Object>> queryTableDetails(StatisticsCriteria statisticsCriteria, Page page) {
		StringBuffer sql = new StringBuffer();

		HashMap<String, Object> param = new HashMap<String, Object>();

		getSqlByCatalog(sql, statisticsCriteria, param);

		String querySql = sql.toString();

		if (logger.isInfoEnabled()) {
			logger.info(dataStatisticsCommonDao.getLogStr("queryTableDetails", querySql.toString(), param));
		}

		return this.findBySql(querySql, param);
	}

	/**
	 * @throws
	 * @Description: 获取上报数据量统计sql(饼图)
	 * @param: @param sql
	 * @param: @param statisticsCriteria
	 * @param: @param param
	 * @return: void
	 * @since JDK 1.7.0_79
	 */
	private void getPieSql(StringBuffer sql, StatisticsCriteria statisticsCriteria, HashMap<String, Object> param) {
		sql.append("select sum(category0) as category0, ");// 上报量
		sql.append(" sum(category1) as category1, ");// 疑问总量
		sql.append(" sum(category3) as category3, ");// 更新量
		sql.append(" sum(category4) as category4, ");// 入库量
		sql.append(" sum(category5) as category5 ");// 未关联数据
		sql.append(" from(select sum(nvl(allSize,0)) as category0, ");// 上报量
		sql.append(" sum(nvl(failSize,0)) as category1,");// 疑问总量
		sql.append(" sum(nvl(updateProcess,0)) as category3,");// 更新量
		sql.append(" sum(nvl(successSize,0)) as category4,");// 入库量
		sql.append(" sum(nvl(notRelatedSize,0)) as category5 ");// 未关联数据
		sql.append(" from (");
		getCommonQuerySql(sql);
		sql.append(" )s left join dp_logic_table t on s.logic_table_id=t.id   ");
		getCondition(sql, statisticsCriteria, param);
		sql.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept)            ");
		sql.append("  group by s.dept_id) ");
	}

	/**
	 * @throws
	 * @Description: 获取上报方式的饼图
	 * @param: @param sql
	 * @param: @param statisticsCriteria
	 * @param: @param param
	 * @return: void
	 * @since JDK 1.7.0_79
	 */
	public void getPieWaySql(StringBuffer sql, StatisticsCriteria statisticsCriteria, HashMap<String, Object> param) {

		statisticsCriteria.setQueryType(StatisticsCriteria.QUERY_TOTAL);
		sql.append("select sum(category0) as category0,sum(category1) as category1,");
		sql.append("  sum(category2) as category2,sum(category3) as category3,");
		sql.append("  sum(category4) as category4 from (");
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
		getCondition(sql, statisticsCriteria, param);
		sql.append(" and s.logic_table_id in(select logic_table_id from dp_logic_table_dept)            ");
		sql.append(" group by log.report_way)                                                           ");

	}

	/**
	 * @throws
	 * @Description：封装按目录名称统计数据的sql字符串 （柱状图和表格）
	 * @param: @param sql,statisticsCriteria,param
	 * @param: @return
	 * @return: String
	 * @since JDK 1.7.0_79
	 */
	private void getSqlByCatalog(StringBuffer strb, StatisticsCriteria statisticsCriteria, HashMap<String, Object> param) {
		strb.append("select id,name,allSize,failSize,updateSize,successSize,notRelatedSize,");// 上报量
		strb.append(" case when round(((decode(allSize,0,0,successSize/allSize)))*100,2) < 1 and round(((decode(allSize,0,0,successSize/allSize)))" +
                "*100,2) >0");
		strb.append(" then to_char(round(((decode(allSize,0,0,successSize/allSize)))*100,2), 'fm999990.99')||'%' ");
		strb.append(" else round((decode(allSize,0,0,successSize/allSize))*100,2)||'%' end as succSizeRate, ");// 入库率

		strb.append(" case when round((decode(allSize,0,0,failSize/allSize))*100,2) < 1 and round((decode(allSize,0,0,failSize/allSize))*100,2) >0");
		strb.append(" then to_char(round((decode(allSize,0,0,failSize/allSize))*100,2), 'fm999990.99')||'%' ");
		strb.append(" else round((decode(allSize,0,0,failSize/allSize))*100,2)||'%' end as failSizeRate, ");// 疑问率

		strb.append(" case when round((decode(allSize,0,0,updateSize/allSize))*100,2) < 1 and round((decode(allSize,0,0,updateSize/allSize))*100,2) " +
                ">0");
		strb.append(" then to_char(round((decode(allSize,0,0,updateSize/allSize))*100,2), 'fm999990.99')||'%' ");
		strb.append(" else round((decode(allSize,0,0,updateSize/allSize))*100,2)||'%' end as updateSizeRate, ");// 更新率

		strb.append(" case when round((decode(allSize,0,0,notRelatedSize/allSize))*100,2) < 1 and round((decode(allSize,0,0,notRelatedSize/allSize))" +
                "*100,2) >0");
		strb.append(" then to_char(round((decode(allSize,0,0,notRelatedSize/allSize))*100,2), 'fm999990.99')||'%' ");
		strb.append(" else round((decode(allSize,0,0,notRelatedSize/allSize))*100,2)||'%' end as notRelatedSizeRate ");// 未关联率

		strb.append(" from (");
		strb.append("select out_id as id,name,sum(nvl(allSize,0)) as allSize, ");// 上报量
		strb.append(" sum(nvl(failSize,0)) as failSize,");// 疑问总量
		strb.append(" sum(nvl(updateProcess,0)) as updateSize,");// 更新量
		strb.append(" sum(nvl(successSize,0)) as successSize,");// 入库量
		strb.append(" sum(nvl(notRelatedSize,0)) as notRelatedSize ");// 未关联数据
		if (StatisticsCriteria.HISTOGRAM.equals(statisticsCriteria.getChartsType())) {//部门统计
			strb.append(" from (select s.*,t.name,t.id as out_id from dp_logic_table t left join (");
			getCommonQuerySql(strb);
			strb.append(" )s on  s.logic_table_id=t.id ");
			getCondition(strb, statisticsCriteria, param);
			strb.append(" and t.id in(select logic_table_id from dp_logic_table_dept)            ");
			strb.append(" ) group by out_id,name order by allSize desc)");
		} else { // 目录统计
			strb.append("  from (select s.*, t.dept_name as name,t.sys_department_id as out_id");
			strb.append(" from (select st.sys_department_id,st.DEPARTMENT_NAME as dept_name,lt.logic_table_id,dt.name ");
			strb.append(" from sys_department st ");
			strb.append(" left join dp_logic_table_dept lt on lt.dept_id=st.sys_department_id ");
			strb.append(" left join dp_logic_table dt on dt.id=lt.logic_table_id ");
			strb.append(" group by st.sys_department_id,st.DEPARTMENT_NAME,lt.logic_table_id,dt.name)t ");
			strb.append(" left join (");
			getCommonQuerySql(strb);
			strb.append(" )s on  s.dept_id=t.sys_department_id ");
			strb.append(" and s.logic_table_id=t.logic_table_id ");
			getCondition(strb, statisticsCriteria, param);
			/*strb.append(" and s.dept_id in(select dept_id from dp_logic_table_dept)            ");*/
			strb.append(" ) group by out_id,name order by allSize desc)");
		}

	}

	/**
	 * @throws
	 * @Description: 查询上报量、有效量、疑问量的通用sql
	 * @param: @param sql
	 * @return: void
	 * @since JDK 1.7.0_79
	 */
	private void getCommonQuerySql(StringBuffer sql) {
		sql.append("select * from(select (nvl(allSize,0)) as allSize,                              ");
		sql.append("              nvl(successSize,0) as successSize,                               ");
		sql.append("              nvl(failSize,0) as failSize,                                    ");
		sql.append("              nvl(updateProcess,0) as updateProcess,                         ");
		sql.append("              nvl(notRelatedSize,0) as notRelatedSize,                       ");
		sql.append("              dept_id,                                                       ");
		sql.append("              logic_table_id,                                                ");
		sql.append("              create_time                                                   ");
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
		sql.append("                              sum(nvl(fail_size,0)) fail_size,                ");
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
		sql.append("                   on s.task_code = r.task_code)aa                           ");
		sql.append("             )s ");

	}

	/**
	 * @throws
	 * @Description：封装查询条件
	 * @param: @param sql,statisticsCriteria,param
	 * @param: @return
	 * @return: String
	 * @since JDK 1.7.0_79
	 */
	private void getCondition(StringBuffer sql, StatisticsCriteria statisticsCriteria, HashMap<String, Object> param) {
		sql.append(" where 1=1 ");

		// 统计主题：0-手动上传；1-文件上传；2-数据库上传；3-FTP上传；4-接口上传；
		if (StringUtils.isNotEmpty(statisticsCriteria.getCategory())
				&& StringUtils.isNotEmpty(statisticsCriteria.getQueryType())) {
			param.put("reportWay", statisticsCriteria.getCategory());
			sql.append("  and log.report_way=:reportWay");
		}

		if (StringUtils.isNotEmpty(statisticsCriteria.getDeptId())) {
			param.put("deptId", statisticsCriteria.getDeptId());
			sql.append("  and s.dept_id=:deptId ");
		}

		if (!StatisticsCriteria.TREND.equals(statisticsCriteria.getChartsType())) {
			if (StringUtils.isNotEmpty(statisticsCriteria.getTableName())) {
				String name = EscapeChar.escape(statisticsCriteria.getTableName().trim());
				sql.append(" and  t.name like :tableName  escape '\\' ");
				param.put("tableName", "%" + name + "%");
			}
		} else {
			if (StringUtils.isNotEmpty(statisticsCriteria.getTableName())) {//部门趋势图精确查询
				String name = EscapeChar.escape(statisticsCriteria.getTableName().trim());
				sql.append(" and  t.name =:tableName ");
				param.put("tableName", name);
			}
		}

		if (StatisticsCriteria.TREND.equals(statisticsCriteria.getChartsType())
				|| StatisticsCriteria.TREND_DEPT.equals(statisticsCriteria.getChartsType())) {
			if (StringUtils.isEmpty(statisticsCriteria.getStartDate())) {
				String startDate = getEarliestDate(statisticsCriteria.getDeptId());

				if (StringUtils.isEmpty(startDate)) {
					startDate = DateUtils.format(new Date(), DateUtils.YYYYMMDD_10);
				}
				param.put("startDate", startDate);
			} else {
				param.put("startDate", statisticsCriteria.getStartDate());
			}

			if (StringUtils.isEmpty(statisticsCriteria.getEndDate())) {
				String endDate = DateUtils.format(new Date(), DateUtils.YYYYMMDD_10);
				param.put("endDate", endDate);
			} else {
				param.put("endDate", statisticsCriteria.getEndDate());
			}

		} else {
			if (StringUtils.isNotEmpty(statisticsCriteria.getStartDate())) {
				param.put("startDate", statisticsCriteria.getStartDate());
			}

			if (StringUtils.isNotEmpty(statisticsCriteria.getEndDate())) {
				param.put("endDate", statisticsCriteria.getEndDate());
			}
		}
		if (StringUtils.isNotEmpty(statisticsCriteria.getStartDate())) {
			sql.append("  AND s.CREATE_TIME >= :startDate ");
		}

		if (StringUtils.isNotEmpty(statisticsCriteria.getEndDate())) {

			sql.append("  AND s.CREATE_TIME <= :endDate     ");
		}

	}

	/**
	 * @throws
	 * @Description:获得部门入库最早日期
	 * @param: @param deptId
	 * @param: @return
	 * @return: String
	 * @since JDK 1.7.0_79
	 */
	private String getEarliestDate(String deptId) {
		StringBuffer sql = new StringBuffer();
		sql.append("select to_char(tdStartDate,'yyyy-mm-dd') as tdStartDate");
		sql.append("  from (select min(create_time) as tdStartDate from dp_data_size");
		Map<String, Object> params = new HashMap<String, Object>();

		if (StringUtils.isNotEmpty(deptId)) {
			sql.append(" where dept_id=:deptId)");
			params.put("deptId", deptId);
		} else {
			sql.append(" )");
		}
		List<Map<String, Object>> list = this.findBySql(sql.toString(), params);

		String formatHappendate = "";
		if (list != null && list.size() > 0) {
			Map<String, Object> map = list.get(0);
			formatHappendate = MapUtils.getString(map, "TDSTARTDATE", "");
		}

		return formatHappendate;
	}

	/**
	 * @param dataSize
	 * @return
	 * @category 根据数据类别统计有效量
	 */
	@Override
	public List<DataSize> getReceiptsByCategory(StatisticsCriteria statisticsCriteria) {
		StringBuilder sb = new StringBuilder();
		HashMap<String, Object> params = new HashMap<String, Object>();
		sb.append("  SELECT c.dict_value, a.successSize                                                     ");
		sb.append("    FROM (SELECT a.data_category, sum(a.successSize) successSize                         ");
		sb.append("            FROM (SELECT s.successSize, b.data_category                                  ");
		sb.append("                    FROM (select (case                                                   ");
		sb.append("                                   when allSize is null then                             ");
		sb.append("                                    0                                                    ");
		sb.append("                                   else                                                  ");
		sb.append("                                    allSize                                              ");
		sb.append("                                 end) as allSize,                                        ");
		sb.append("                                 (case                                                   ");
		sb.append("                                   when successSize is null then                         ");
		sb.append("                                    0                                                    ");
		sb.append("                                   else                                                  ");
		sb.append("                                    successSize                                          ");
		sb.append("                                 end) as successSize,                                    ");
		sb.append("                                 (case                                                   ");
		sb.append("                                   when failSize is null then                            ");
		sb.append("                                    0                                                    ");
		sb.append("                                   else                                                  ");
		sb.append("                                    failSize                                             ");
		sb.append("                                 end) as failSize,                                       ");
		sb.append("                                 dept_id,                                                ");
		sb.append("                                 logic_table_id,                                         ");
		sb.append("                                 create_time                                             ");
		sb.append("                            from (select create_time,                                    ");
		sb.append("                                         all_size as allSize,                            ");
		sb.append("                                         dept_id,                                        ");
		sb.append("                                         s.logic_table_id,                               ");
		sb.append("                                         r.successSize as successSize,                   ");
		sb.append("                                         (fail_size + (case                              ");
		sb.append("                                           when failSizeProcess is null then             ");
		sb.append("                                            0                                            ");
		sb.append("                                           else                                          ");
		sb.append("                                            failSizeProcess                              ");
		sb.append("                                         end)) as failSize                               ");
		sb.append("                                    from (select task_code,                              ");
		sb.append("                                                 max(logic_table_id) logic_table_id,     ");
		sb.append("                                                 max(create_time) as create_time,        ");
		sb.append("                                                 max(dept_id) dept_id,                   ");
		sb.append("                                                 sum(fail_size) fail_size,               ");
		sb.append("                                                 sum(all_Size) all_Size                  ");
		sb.append("                                            from dp_data_size                            ");
		sb.append("                                           group by task_code) s                         ");
		sb.append("                                    left join (select task_code,                         ");
		sb.append("                                                     sum(case                            ");
		sb.append("                                                           when (type = 1 and            ");
		sb.append("                                                                etl_type = 1) or         ");
		sb.append("                                                                type = 3 then            ");
		sb.append("                                                            process_size                 ");
		sb.append("                                                           else                          ");
		sb.append("                                                            0                            ");
		sb.append("                                                         end) as successSize,            ");
		sb.append("                                                     sum(case                            ");
		sb.append("                                                           when type = 2 then            ");
		sb.append("                                                            process_size                 ");
		sb.append("                                                           else                          ");
		sb.append("                                                            0                            ");
		sb.append("                                                         end) as failSizeProcess         ");
		sb.append("                                                from dp_process_result                   ");
		sb.append("                                               where task_code is not null               ");
		sb.append("                                               group by task_code) r                     ");
		sb.append("                                      on s.task_code = r.task_code)) s                   ");
		sb.append("                    JOIN DP_LOGIC_TABLE b                                                ");
		sb.append("                      ON s.logic_table_id = b.id                                         ");
		sb.append("                   where 1 = 1                                                           ");
		if(StringUtils.isNotEmpty(statisticsCriteria.getStartDate())){
			sb.append("  and TO_CHAR( s.CREATE_TIME, 'yyyy-mm-dd') >= :startDate ");
			params.put("startDate", statisticsCriteria.getStartDate());
		}

		if(StringUtils.isNotEmpty(statisticsCriteria.getEndDate())){
			sb.append("  AND TO_CHAR( s.CREATE_TIME, 'yyyy-mm-dd') <= :endDate     ");
			params.put("endDate", statisticsCriteria.getEndDate());
		}
		if (StringUtils.isNotEmpty(statisticsCriteria.getDeptId())) {
			params.put("deptId", statisticsCriteria.getDeptId());
			sb.append("  and s.dept_id=:deptId ");
		}
		if (StringUtils.isNotEmpty(statisticsCriteria.getTableName())) {
			String name = EscapeChar.escape(statisticsCriteria.getTableName().trim());
			sb.append(" and  b.name like :tableName  escape '\\' ");
			params.put("tableName", "%" + name + "%");
		}
		sb.append("                     ) a                                                                 ");
		sb.append("           GROUP BY a.data_category) a                                                   ");
		sb.append("    JOIN Sys_Dictionary_Group b                                                          ");
		sb.append("      ON b.group_key = 'data_category'                                                   ");
		sb.append("    JOIN SYS_DICTIONARY c                                                                ");
		sb.append("      ON b.id = c.group_id                                                               ");
		sb.append("     AND a.data_category = c.dict_key                                                    ");
		sb.append("   order by successSize desc                                                             ");
		List<Map<String, Object>> list = this.findBySql(sb.toString(), params);

		List<DataSize> dataSizeList = new LinkedList<DataSize>();
		if (list != null && !list.isEmpty()) {
			for (Map<String, Object> map : list) {
				DataSize temp = new DataSize();
				temp.setCategory((String) map.get("DICT_VALUE"));
				BigDecimal decimal = (BigDecimal) map.get("SUCCESSSIZE");
				temp.setSuccessSize(decimal.longValue());
				dataSizeList.add(temp);
			}
		}

		return dataSizeList;
	}

}
