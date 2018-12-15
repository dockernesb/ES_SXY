package com.udatech.common.statisAnalyze.dao.impl;

import com.udatech.common.constant.Constants;
import com.udatech.common.statisAnalyze.dao.DataQualityDao;
import com.udatech.common.statisAnalyze.model.DataSize;
import com.wa.framework.dao.BaseDaoSupport;
import com.wa.framework.utils.EscapeChar;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @category 数据质量统计
 * @author Administrator
 */
@Repository
public class DataQualityDaoImpl extends BaseDaoSupport implements
		DataQualityDao {

	@Override
	public String getMinDate(Map<String, Object> criteriaMap) {
		Map<String, String> parameterMap = new HashMap<String, String>();
		StringBuffer sb = new StringBuffer();
		sb.append(" SELECT to_char(min(s.create_date), 'yyyy-mm') CREATE_DATE ");
		sb.append(" FROM dp_data_report_log s 		                          ");

		getCommonSql(sb);

		sb.append("	WHERE 1=1              			                          ");

		getWhereSql(sb, criteriaMap, parameterMap);

		List<Map<String, Object>> list = findBySql(sb.toString(), parameterMap);

		String minDate = "";
		if (list != null && list.size() > 0) {
			minDate = MapUtils.getString(list.get(0), "CREATE_DATE");
		}

		return minDate;
	}

	@Override
	public Map<String, Object> getErrorCount(Map<String, Object> criteriaMap) {
		Map<String, String> parameterMap = new HashMap<String, String>();

		// 疑问总数
		StringBuffer sb1 = new StringBuffer();
		sb1.append("SELECT sum(a1.fail_size + a2.fail_size) TOTAL_FAILSIZE                ");
		sb1.append("FROM (                                                                ");
		sb1.append("	SELECT nvl(sum(nvl(s.fail_size, 0)),0) fail_size                  ");
		sb1.append("	FROM dp_data_size s                                    			  ");

		getCommonSql(sb1);

		sb1.append("	WHERE 1=1              			                     			  ");

		getWhereSql(sb1, criteriaMap, parameterMap);

		sb1.append("	) a1                                                              ");
		sb1.append("	,(                                                                ");
		sb1.append("		SELECT nvl(sum(nvl(s.process_size, 0)),0) fail_size           ");
		sb1.append("		FROM dp_process_result s                                      ");

		getCommonSql(sb1);

		sb1.append("		 WHERE 1=1 AND  s.type = 2                                    ");

		getWhereSql(sb1, criteriaMap, parameterMap);

		sb1.append("		) a2                                                          ");

		long ywzs = this.countBySql(sb1.toString(), parameterMap); // 疑问总数

		long  ywlxzs = 0; // 疑问数据类型总数
		long sjsbSize = 0; // 数据上报产生的疑问量

		if (sjsbSize > 0) {
			ywlxzs += 1;
		}

		// 修改总数
		long xgzs = getFailSizeByStatus(Constants.UPLOAD_ERROR_MODIFY, criteriaMap, parameterMap);

		// 处理总数
		long clzs = getFailSizeByStatus(Constants.UPLOAD_ERROR_FINISH, criteriaMap, parameterMap);

		// 忽略总数
		long hlzs = getFailSizeByStatus(Constants.UPLOAD_ERROR_IGNORE, criteriaMap, parameterMap);

		float xgl = 0;// 修改率
		float cll = 0;// 处理率
		float hll = 0;// 忽略率

		if (ywzs > 0) {
			xgl = (float) (100 * xgzs / (clzs+ywzs));
			cll = (float) (100 * clzs / (clzs+ywzs));
			hll = (float) (100 * hlzs / (clzs+ywzs));
		}
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("ywzs", ywzs);// 疑问总数
		returnMap.put("ywlxzs", ywlxzs);// 疑问类型总数
		returnMap.put("xgzs", xgzs);// 修改总数
		returnMap.put("clzs", clzs);// 处理总数
		returnMap.put("hlzs", hlzs);// 忽略总数
		//returnMap.put("xgl", xgl);// 修改率
		//returnMap.put("cll", cll);// 处理率
		//returnMap.put("hll", hll);// 忽略率

		return returnMap;
	}

	@Override
	public List<Map<String, Object>> getErrorStatusStatistics(Map<String, Object> criteriaMap) {
		Map<String, String> parameterMap = new HashMap<String, String>();

		StringBuffer sb = new StringBuffer();
		sb.append("select sum(n.fail_size) value, n.CATEGORY  name ");
		sb.append(" from (select sum(FAIL_SIZE) fail_size,       ");
		sb.append("              case s.status             ");
		sb.append("                when '0' then           ");
		sb.append("                 '未处理'               ");
		sb.append("                when '1' then           ");
		sb.append("                 '已处理'               ");
		sb.append("                when '2' then           ");
		sb.append("                 '已忽略'               ");
		sb.append("                when '4' then           ");
		sb.append("                 '已修改'                ");
		sb.append("              end CATEGORY              ");
		sb.append("FROM                                    ");
		sb.append(" (SELECT sum(INVALID_SIZE) FAIL_SIZE 			   ");
		sb.append("	,s.STATUS                			   ");
		sb.append("	,s.task_code             			   ");
		sb.append("FROM dp_summary_invalid_data s   			   ");
		sb.append("GROUP BY s.STATUS         			   ");
		sb.append("	,s.task_code )            			   ");
		sb.append(" s                                  	   ");

		getCommonSql(sb);

		sb.append("	WHERE 1=1              			       ");

		getWhereSql(sb, criteriaMap, parameterMap);

		sb.append("        group by s.status ) n    ");
		sb.append("group by n.Category                     ");

		List<Map<String, Object>> list = findBySql(sb.toString(), parameterMap);
		return list;
	}

	@Override
	public List<Map<String, Object>> getErrorHandleSituation(Map<String, Object> criteriaMap, boolean isDeptGroup) {
		Map<String, String> parameterMap = new HashMap<String, String>();

		StringBuffer sb = new StringBuffer();
		sb.append("SELECT  nvl(sum(wcl_size),0) wcl_size,                                   ");
		sb.append("        nvl(sum(ycl_size),0) ycl_size,                                   ");
		sb.append("        nvl(sum(yhl_size),0) yhl_size,                                   ");
		sb.append("        nvl(sum(yxg_size),0) yxg_size,                                   ");
		if (isDeptGroup) {
			sb.append("       n.department_name category                               ");
		} else {
			sb.append("       n.name  category                              		   ");
		}

		if (isDeptGroup) {
			sb.append("  FROM (                               						");
			sb.append("SELECT g.department_name department_name     				");
			sb.append(",k.wcl_size                                  				");
			sb.append(",k.ycl_size                                  				");
			sb.append(",k.yhl_size                                  				");
			sb.append(",k.yxg_size                          						");
			sb.append("FROM sys_department g                    					");
			sb.append(" JOIN (                                  				");
		} else {
			sb.append(" FROM (SELECT g.NAME			                             	");
			sb.append(" 		,k.wcl_size		                                 	");
			sb.append(" 		,k.ycl_size		                                 	");
			sb.append(" 		,k.yhl_size		                                 	");
			sb.append(" 		,k.yxg_size		                                 	");
			sb.append(" FROM dp_logic_table g	                                 	");
			sb.append(" LEFT JOIN (													");
		}

		sb.append("  SELECT sum(CASE                               				");
		sb.append("                       WHEN s.STATUS = '0' THEN          	");
		sb.append("                        s.FAIL_SIZE                      	");
		sb.append("                     END) AS wcl_size,                   	");
		sb.append("               sum(CASE                               		");
		sb.append("                       WHEN s.STATUS = '1' THEN          	");
		sb.append("                        s.FAIL_SIZE                      	");
		sb.append("                     END) AS ycl_size,                   	");
		sb.append("               sum(CASE                               		");
		sb.append("                       WHEN s.STATUS = '2' THEN          	");
		sb.append("                        s.FAIL_SIZE                      	");
		sb.append("                     END) AS yhl_size,                  		");
		sb.append("               sum(CASE                               		");
		sb.append("                       WHEN s.STATUS = '4' THEN         		");
		sb.append("                        s.FAIL_SIZE                     		");
		sb.append("                     END) AS yxg_size,                  		");

		if (isDeptGroup) {
			sb.append("       d.department_name                                	");
		} else {
			sb.append("       t.name                                		   	");
		}

		sb.append("FROM (SELECT sum(INVALID_SIZE) FAIL_SIZE 					");
		sb.append("	,s.STATUS                 									");
		sb.append("	,s.task_code              									");
		sb.append("FROM DP_SUMMARY_INVALID_DATA s    							");
		sb.append("GROUP BY s.STATUS          									");
		sb.append("	,s.task_code   )  s        									");

		getCommonSql(sb);

		sb.append("	WHERE 1=1              			                  	   ");

		getWhereSql(sb, criteriaMap, parameterMap);

		sb.append("         GROUP BY                      				   ");

		if (isDeptGroup) {
			sb.append("       d.department_name                                ");
		} else {
			sb.append("       t.name                                		   ");
		}

		if (isDeptGroup) {
			String deptId = MapUtils.getString(criteriaMap, "deptId", "");
			sb.append("	) k ON g.department_name = k.department_name          			   ");
			sb.append("WHERE 1 = 1                                            			   ");

 			if (StringUtils.isNotBlank(deptId)) {
				sb.append(" AND g.sys_department_id = :deptId                              ");
			}

			sb.append("	AND g.sys_department_id IN (                          			   ");
			sb.append("		SELECT dept_id                                    			   ");
			sb.append("		FROM dp_logic_table_dept                          			   ");
			sb.append("		)                                                 			   ");
		} else {
			String schemaName = MapUtils.getString(criteriaMap, "schemaName", "");

			sb.append("	) k ON g.NAME = k.NAME                                			   ");
			sb.append("WHERE 1 = 1                                            			   ");

			if (StringUtils.isNotBlank(schemaName)) {
				sb.append(" AND g.NAME like :schemaName                                    ");
			}

			sb.append("	AND g.id IN (                                         			   ");
			sb.append("		SELECT logic_table_id                             			   ");
			sb.append("		FROM dp_logic_table_dept                          			   ");
			sb.append("		)                                                 			   ");
		}

		sb.append("         ) n                  						   ");

		sb.append(" GROUP BY                              				   ");
		if (isDeptGroup) {
			sb.append("   n.department_name  order by n.department_name    ");
		} else {
			sb.append("       n.name  order by n.name                      ");
		}

		return findBySql(sb.toString(), parameterMap);
	}

	@Override
	public List<Map<String, Object>> getErrorHandleMonthStatistics(Map<String, Object> criteriaMap) {
		Map<String, String> parameterMap = new HashMap<String, String>();

		StringBuffer sb = new StringBuffer();

		sb.append("SELECT a.yearMonth AS CATEGORY                                                                            ");
		sb.append("	,nvl(b.wcl_size, 0) WCL_SIZE                                                                             ");
		sb.append("	,nvl(b.ycl_size, 0) YCL_SIZE                                                                             ");
		sb.append("	,nvl(b.yhl_size, 0) YHL_SIZE                                                                             ");
		sb.append("	,nvl(b.yxg_size, 0) YXG_SIZE                                                                             ");
		sb.append("FROM (                                                                                                    ");
		sb.append("	SELECT TO_CHAR(add_months(to_date(:startMonth, 'yyyy-mm'), ROWNUM - 1), 'YYYY-MM') AS yearMonth             ");
		sb.append("	FROM DUAL CONNECT BY ROWNUM <= (                                                                         ");
		sb.append("			SELECT months_between(add_months(to_date(:endMonth, 'yyyy-mm'), 1), to_date(:startMonth, 'yyyy-mm'))");
		sb.append("			FROM dual                                                                                        ");
		sb.append("			)                                                                                                ");
		sb.append("	) a                                                                                                      ");
		sb.append("LEFT JOIN (                                                                                               ");
		sb.append("	SELECT sum(wcl_size) wcl_size                                                                            ");
		sb.append("		,sum(ycl_size) ycl_size                                                                              ");
		sb.append("		,sum(yhl_size) yhl_size                                                                              ");
		sb.append("		,sum(yxg_size) yxg_size                                                                              ");
		sb.append("		,n.create_date                                                                                       ");
		sb.append("  FROM (SELECT sum(CASE                               													 ");
		sb.append("                       WHEN s.STATUS = '0' THEN          												 ");
		sb.append("                        s.FAIL_SIZE                      												 ");
		sb.append("                     END) AS wcl_size,                   												 ");
		sb.append("               sum(CASE                               													 ");
		sb.append("                       WHEN s.STATUS = '1' THEN          												 ");
		sb.append("                        s.FAIL_SIZE                      												 ");
		sb.append("                     END) AS ycl_size,                   												 ");
		sb.append("               sum(CASE                               													 ");
		sb.append("                       WHEN s.STATUS = '2' THEN          												 ");
		sb.append("                        s.FAIL_SIZE                      												 ");
		sb.append("                     END) AS yhl_size,                  													 ");
		sb.append("               sum(CASE                               													 ");
		sb.append("                       WHEN s.STATUS = '4' THEN         													 ");
		sb.append("                        s.FAIL_SIZE                     													 ");
		sb.append("                     END) AS yxg_size                  													 ");
		sb.append("			,to_char(l.create_date, 'yyyy-MM') create_date                                                   ");
		sb.append("			FROM (SELECT sum(s.INVALID_SIZE) FAIL_SIZE 																 ");
		sb.append("				,s.STATUS                 																	 ");
		sb.append("				,s.task_code              																	 ");
		sb.append("			FROM DP_SUMMARY_INVALID_DATA s    																		 ");
		sb.append("			GROUP BY s.STATUS          																		 ");
		sb.append("				,s.task_code   )  s        																	 ");

		getCommonSql(sb);

		sb.append("	WHERE 1=1              			                  	   ");

		getWhereSql(sb, criteriaMap, parameterMap);

		sb.append("		GROUP BY to_char(l.create_date, 'yyyy-MM')                                                           ");
		sb.append("		) n                                                                                                  ");
		sb.append("	GROUP BY n.create_date                                                                                   ");
		sb.append("	) b ON a.yearMonth = b.create_date                                                                       ");
		sb.append("ORDER BY category                                                                                         ");

		parameterMap.put("startMonth", MapUtils.getString(criteriaMap, "startMonth",""));
		parameterMap.put("endMonth", MapUtils.getString(criteriaMap, "endMonth",""));
		logger.info("getErrorHandleMonthStatistics=====" + sb.toString());
		return findBySql(sb.toString(), parameterMap);
	}

	@Override
	public List<Map<String, Object>> getErrorDataTable(Map<String, Object> criteriaMap) {
		String isDeptGroup = MapUtils.getString(criteriaMap, "isDeptGroup", "");// 1：部门

		Map<String, String> parameterMap = new HashMap<String, String>();

		StringBuffer sb = new StringBuffer();
		sb.append("SELECT m.*                                                         ");
		sb.append("	,round(((decode(all_size,0,0,ycl_size/(ycl_size+all_size))))*100,2)  cll     ");
		sb.append("	,round(((decode(all_size,0,0,yhl_size/(ycl_size+all_size))))*100,2)  hll     ");
		sb.append("	,round(((decode(all_size,0,0,yxg_size/(ycl_size+all_size))))*100,2)  xgl     ");
		sb.append("FROM (                                                             ");
		sb.append("	SELECT nvl(sum(wcl_size),0) wcl_size                                     ");
		sb.append("		,nvl(sum(ycl_size),0) ycl_size                                       ");
		sb.append("		,nvl(sum(yhl_size),0) yhl_size                                       ");
		sb.append("		,nvl(sum(yxg_size),0) yxg_size                                       ");
		sb.append("		,(nvl(sum(all_size),0) - nvl(sum(ycl_size),0)) all_size                                       ");
		sb.append("       ,n.id			                                ");

		if ("1".equals(isDeptGroup)) {
			sb.append("       ,n.department_name			                           ");
		} else {
			sb.append("       ,n.name  			                              		   ");
		}

		if ("1".equals(isDeptGroup)) {
			sb.append("FROM (                                    						  ");
			sb.append("	SELECT g.department_name department_name, g.SYS_DEPARTMENT_ID id     		  ");
			sb.append("		,k.wcl_size                          						  ");
			sb.append("		,k.ycl_size                          						  ");
			sb.append("		,k.yhl_size                          						  ");
			sb.append("		,k.yxg_size                          						  ");
			sb.append("		,k.all_size                          						  ");
			sb.append("	FROM sys_department g                    						  ");
			sb.append("	LEFT JOIN (                              						  ");
		} else {
			sb.append(" FROM (SELECT g.NAME, g.id id 			                       ");
			sb.append(" 		,k.wcl_size		                                          ");
			sb.append(" 		,k.ycl_size		                                          ");
			sb.append(" 		,k.yhl_size		                                          ");
			sb.append(" 		,k.yxg_size		                                          ");
			sb.append(" 		,k.all_size		                                          ");
			sb.append(" FROM dp_logic_table g	                                          ");
			sb.append(" LEFT JOIN (														  ");
		}

		sb.append("  SELECT sum(CASE                               			  		  ");
		sb.append("                       WHEN s.STATUS = '0' THEN          		  ");
		sb.append("                        s.FAIL_SIZE                      		  ");
		sb.append("                     END) AS wcl_size,                   		  ");
		sb.append("               sum(CASE                               			  ");
		sb.append("                       WHEN s.STATUS = '1' THEN          		  ");
		sb.append("                        s.FAIL_SIZE                      		  ");
		sb.append("                     END) AS ycl_size,                   		  ");
		sb.append("               sum(CASE                               			  ");
		sb.append("                       WHEN s.STATUS = '2' THEN          		  ");
		sb.append("                        s.FAIL_SIZE                      		  ");
		sb.append("                     END) AS yhl_size,                  			  ");
		sb.append("               sum(CASE                               			  ");
		sb.append("                       WHEN s.STATUS = '4' THEN         			  ");
		sb.append("                        s.FAIL_SIZE                     			  ");
		sb.append("                     END) AS yxg_size                  			  ");
		sb.append("			,sum(s.FAIL_SIZE) all_size                                ");

		if ("1".equals(isDeptGroup)) {
			sb.append("       ,d.department_name			                          ");
		} else {
			sb.append("       ,t.name  			                              		  ");
		}

		sb.append("			FROM (SELECT sum(INVALID_SIZE) FAIL_SIZE 						  ");
		sb.append("				,s.STATUS                 							  ");
		sb.append("				,s.task_code              							  ");
		sb.append("			FROM DP_SUMMARY_INVALID_DATA s    			");
		sb.append("			GROUP BY s.STATUS          								  ");
		sb.append("				,s.task_code   )  s        							  ");

		getCommonSql(sb);

		sb.append("	WHERE 1=1              			                  	   ");

		getWhereSql(sb, criteriaMap, parameterMap);

		if ("1".equals(isDeptGroup)) {
			sb.append("       GROUP BY d.department_name			                   ");
		} else {
			sb.append("       GROUP BY t.name  			                               ");
		}

		if ("1".equals(isDeptGroup)) {
			String deptId = MapUtils.getString(criteriaMap, "deptId", "");

			sb.append("	) k ON g.department_name = k.department_name          			   ");
			sb.append("WHERE 1 = 1                                            			   ");

			if (StringUtils.isNotBlank(deptId)) {
				sb.append(" AND g.sys_department_id = :deptId                              ");
			}

			sb.append("	AND g.sys_department_id IN (                          			   ");
			sb.append("		SELECT dept_id                                    			   ");
			sb.append("		FROM dp_logic_table_dept                          			   ");
			sb.append("		)                                                 			   ");
		} else {
			String schemaName = MapUtils.getString(criteriaMap, "schemaName", "");

			sb.append("	) k ON g.NAME = k.NAME                                			   ");
			sb.append("WHERE 1 = 1                                            			   ");

			if (StringUtils.isNotBlank(schemaName)) {
				sb.append(" AND g.NAME like :schemaName                                    ");
			}

			sb.append("	AND g.id IN (                                         			   ");
			sb.append("		SELECT logic_table_id                             			   ");
			sb.append("		FROM dp_logic_table_dept                          			   ");
			sb.append("		)                                                 			   ");
		}

		sb.append("		) n                                                            ");

		if ("1".equals(isDeptGroup)) {
			sb.append("       GROUP BY n.id, n.department_name ORDER BY n.department_name	   ");
		} else {
			sb.append("       GROUP BY n.id, n.name ORDER BY n.name        		           ");
		}

		sb.append("	) m                                                                ");
		sb.append("      WHERE M.all_size > 0                                          ");
		
		return findBySql(sb.toString(), parameterMap);
	}

	@Override
	public List<Map<String, Object>> queryDetailsBySchema(Map<String, Object> criteriaMap) {
		StringBuffer str = new StringBuffer();
		str.append("    SELECT                                                                                                                               ");
		str.append("      m.*,                                                                                                                               ");
		str.append("      round(((decode(all_size, 0, 0, ycl_size / (ycl_size+all_size)))) * 100, 2) cll,                                                               ");
		str.append("      round(((decode(all_size, 0, 0, yhl_size / (ycl_size+all_size)))) * 100, 2) hll,                                                               ");
		str.append("      round(((decode(all_size, 0, 0, yxg_size / (ycl_size+all_size)))) * 100, 2) xgl                                                           ");
		str.append("    FROM (SELECT                                                                                                                         ");
		str.append("            nvl(sum(wcl_size), 0)                           wcl_size,                                                                    ");
		str.append("            nvl(sum(ycl_size), 0)                           ycl_size,                                                                    ");
		str.append("            nvl(sum(yhl_size), 0)                           yhl_size,                                                                    ");
		str.append("            nvl(sum(yxg_size), 0)                           yxg_size,                                                                    ");
		str.append("            (nvl(sum(all_size), 0) - nvl(sum(ycl_size), 0)) all_size,                                                                    ");
		str.append("            n.id,                                                                                                                        ");
		str.append("            n.name,                                                                                                                      ");
		str.append("            n.CREATE_TIME                                                                                                                ");
		str.append("          FROM (SELECT                                                                                                                   ");
		str.append("                  g.NAME,                                                                                                                ");
		str.append("                  g.id id,                                                                                                               ");
		str.append("                  k.wcl_size,                                                                                                            ");
		str.append("                  k.ycl_size,                                                                                                            ");
		str.append("                  k.yhl_size,                                                                                                            ");
		str.append("                  k.yxg_size,                                                                                                            ");
		str.append("                  k.all_size,                                                                                                            ");
		str.append("                  k.CREATE_TIME                                                                                                          ");
		str.append("                FROM dp_logic_table g                                                                                                    ");
		str.append("                  LEFT JOIN (SELECT                                                                                                      ");
		str.append("                               sum(CASE WHEN s.STATUS = '0'                                                                              ");
		str.append("                                 THEN s.FAIL_SIZE END) AS wcl_size,                                                                      ");
		str.append("                               sum(CASE WHEN s.STATUS = '1'                                                                              ");
		str.append("                                 THEN s.FAIL_SIZE END) AS ycl_size,                                                                      ");
		str.append("                               sum(CASE WHEN s.STATUS = '2'                                                                              ");
		str.append("                                 THEN s.FAIL_SIZE END) AS yhl_size,                                                                      ");
		str.append("                               sum(CASE WHEN s.STATUS = '4'                                                                              ");
		str.append("                                 THEN s.FAIL_SIZE END) AS yxg_size,                                                                      ");
		str.append("                               sum(s.FAIL_SIZE)           all_size,                                                                      ");
		str.append("                               t.name,                                                                                                   ");
		str.append("                               s.CREATE_TIME                                                                                             ");
		str.append("                             FROM (SELECT                                                                                                ");
		str.append("                                     count(1)                          FAIL_SIZE,                                                        ");
		str.append("                                     s.STATUS,                                                                                           ");
		str.append("                                     s.task_code,                                                                                        ");
		str.append("                                     to_char(s.CREATE_TIME, 'yyyy-mm') CREATE_TIME                                                       ");
		str.append("                                   FROM etl_invalid_data s                                                                               ");
		str.append("                                   GROUP BY s.STATUS, s.task_code, to_char(s.CREATE_TIME, 'yyyy-mm')                                     ");
		str.append("                                  ) s LEFT JOIN dp_data_report_log l ON s.task_code = l.task_code                                        ");
		str.append("                               LEFT JOIN dp_logic_table t ON l.logic_table_id = t.id                                                     ");
		str.append("                               LEFT JOIN sys_department d ON l.dept_id = d.sys_department_id                                             ");
		str.append("                             WHERE 1 = 1 AND d.sys_department_id = :deptId AND t.name = :schemaName ");
		str.append("                             GROUP BY t.name, s.CREATE_TIME                                                                              ");
		str.append("                             UNION ALL                                                                                                   ");
		str.append("                             SELECT                                                                                                      ");
		str.append("                               count(CASE WHEN s.STATUS = '0'                                                                    ");
		str.append("                                 THEN 1 END) AS                  wcl_size,                                                               ");
		str.append("                               count(CASE WHEN s.STATUS = '1'                                                                    ");
		str.append("                                 THEN 1 END) AS                  ycl_size,                                                               ");
		str.append("                               count(CASE WHEN s.STATUS = '2'                                                                    ");
		str.append("                                 THEN 1 END) AS                  yhl_size,                                                               ");
		str.append("                               count(CASE WHEN s.STATUS = '4'                                                                    ");
		str.append("                                 THEN 1 END) AS                  yxg_size,                                                               ");
		str.append("                               count(1)                          all_size,                                                               ");
		str.append("                               t.name,                                                                                                   ");
		str.append("                               to_char(s.CREATE_TIME, 'yyyy-mm') CREATE_TIME                                                             ");
		str.append("                             FROM dp_summary_invalid_data s LEFT JOIN dp_data_report_log l ON s.task_code = l.task_code                 ");
		str.append("                               LEFT JOIN dp_logic_table t ON l.logic_table_id = t.id                                                     ");
		str.append("                               LEFT JOIN sys_department d ON l.dept_id = d.sys_department_id                                             ");
		str.append("                             WHERE 1 = 1 AND d.sys_department_id = :deptId AND t.name = :schemaName ");
		str.append("                             GROUP BY t.name, to_char(s.CREATE_TIME, 'yyyy-mm')                                                          ");
		str.append("                            ) k ON g.NAME = k.NAME                                                                                     ");
		str.append("               WHERE 1 = 1 AND g.NAME LIKE :schemaName AND g.id IN (SELECT logic_table_id FROM dp_logic_table_dept)");
		str.append("               ) n                                                                                                                       ");
		str.append("          GROUP BY n.id, n.name, n.CREATE_TIME                                                                                           ");
		str.append("          ORDER BY n.CREATE_TIME DESC                                                                                                    ");
		str.append("         ) m                                                                                                                             ");
		str.append("      WHERE M.all_size > 0                                                                                                               ");

		return findBySql(str.toString(), criteriaMap);
	}

	private long getFailSizeByStatus(int status, Map<String, Object> criteriaMap, Map<String, String> parameterMap) {
		StringBuffer sb = new StringBuffer();
		sb.append("	SELECT nvl(SUM(FAIL_SIZE),0) FAIL_SIZE                            ");
		sb.append("FROM                                    							  ");
		sb.append(" (SELECT sum(s.INVALID_SIZE) FAIL_SIZE 			   							  ");
		sb.append("	,s.STATUS                			   							  ");
		sb.append("	,s.task_code             			   							  ");
		sb.append(" FROM dp_summary_invalid_data s   			   							  ");
		sb.append(" GROUP BY s.STATUS         			   							  ");
		sb.append("	,s.task_code )            			   							  ");
		sb.append(" s                                  	   							  ");

		getCommonSql(sb);

		sb.append("	WHERE s.STATUS = :status                                          ");

		getWhereSql(sb, criteriaMap, parameterMap);

		parameterMap.put("status", String.valueOf(status));

		long size = this.countBySql(sb.toString(), parameterMap); // 修改总数

		return size;
	}

	/**
	 * 公共条件
	 * @param sb
	 */
	private void getWhereSql(StringBuffer sb, Map<String, Object> criteriaMap, Map<String, String> parameterMap) {
		String deptId = MapUtils.getString(criteriaMap, "deptId", "");
		String schemaName = MapUtils.getString(criteriaMap, "schemaName", "");
		String startDate = MapUtils.getString(criteriaMap, "startDate", "");
		String endDate = MapUtils.getString(criteriaMap, "endDate", "");
		String linkSchemaName = MapUtils.getString(criteriaMap, "linkSchemaName", ""); // 联动查询条件-目录名称
		String linkDeptName = MapUtils.getString(criteriaMap, "linkDeptName", "");// 联动查询条件-部门名称
		boolean isLinkQuery = MapUtils.getBooleanValue(criteriaMap, "isLinkQuery", false);
		String isDeptGroup = MapUtils.getString(criteriaMap, "isDeptGroup", "");
		String deptQueryType = MapUtils.getString(criteriaMap, "deptQueryType", "");//省市县查询
		

		// 月份关联查询
		if (isLinkQuery) {
			// 按部门分组查询
			if ("1".equals(isDeptGroup)) {
				if (StringUtils.isNotBlank(linkDeptName)) {
					sb.append(" AND d.department_name = :linkDeptName ");
					parameterMap.put("linkDeptName", linkDeptName);
				}
				if (StringUtils.isNotBlank(schemaName)) {
					sb.append(" AND t.name =:schemaName ");
					parameterMap.put("schemaName", schemaName);
				}
			} else {
				if (StringUtils.isNotBlank(linkSchemaName)) {
					sb.append(" AND t.name = :linkSchemaName ");
					parameterMap.put("linkSchemaName", linkSchemaName);
				}
				if (DataSize.CITY.equals(deptQueryType)) {
					sb.append("  and d.code like 'A%' ");
				} else if (DataSize.AREA.equals(deptQueryType)) {
					sb.append("  and d.code like 'B%' ");
				} else if (DataSize.PROVINCE.equals(deptQueryType)) {
					sb.append("  and d.code  like 'C%' ");
				}
				if (StringUtils.isNotBlank(deptId)) {
					sb.append(" AND d.sys_department_id = :deptId ");
					parameterMap.put("deptId", deptId);
				}
			}
		} else {
			if (DataSize.CITY.equals(deptQueryType)) {
				sb.append("  and d.code like 'A%' ");
			} else if (DataSize.AREA.equals(deptQueryType)) {
				sb.append("  and d.code like 'B%' ");
			} else if (DataSize.PROVINCE.equals(deptQueryType)) {
				sb.append("  and d.code  like 'C%' ");
			}
			if (StringUtils.isNotBlank(deptId)) {
				sb.append(" AND d.sys_department_id = :deptId ");
				parameterMap.put("deptId", deptId);
			}
			if (StringUtils.isNotBlank(schemaName)) {
				sb.append(" AND t.name =:schemaName ");
				parameterMap.put("schemaName", schemaName);
			}
		}

		if (StringUtils.isNotBlank(startDate)) {
			sb.append(" AND l.create_date >= to_date(:startDate, 'yyyy-MM-dd hh24:mi:ss') ");
			parameterMap.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append(" AND l.create_date <= to_date(:endDate, 'yyyy-MM-dd hh24:mi:ss') ");
			parameterMap.put("endDate", endDate);
		}

	}

	/**
	 * 公共sql
	 * @param sb
	 */
	private void getCommonSql(StringBuffer sb) {
		sb.append("	LEFT JOIN dp_data_report_log l ON s.task_code = l.task_code       ");

		sb.append("	LEFT JOIN dp_logic_table t ON l.logic_table_id = t.id             ");

		sb.append("	LEFT JOIN sys_department d ON l.dept_id = d.sys_department_id    ");
	}

	/**
	 * 各部门疑问数据量统计
	 */
	@Override
	public List<Map<String, Object>> getErrorDateStatistics(
			Map<String, Object> criteriaMap) {
		String deptId = MapUtils.getString(criteriaMap, "deptId", "");
		String schemaName = MapUtils.getString(criteriaMap, "schemaName", "");
		String startDate = MapUtils.getString(criteriaMap, "startDate", "");
		String endDate = MapUtils.getString(criteriaMap, "endDate", "");
		String deptQueryType = MapUtils.getString(criteriaMap, "deptQueryType", "");//省市县
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		StringBuilder sb = new StringBuilder("SELECT A.*");
		sb.append("  FROM (SELECT SUM(INVALID_SIZE) INVALID_SIZE, DEPARTMENT_NAME DEPTNAME");
		sb.append("          FROM (SELECT D.INVALID_SIZE, S.DEPARTMENT_NAME");
		sb.append("                  FROM DP_SUMMARY_INVALID_DATA D ");
		sb.append("                  JOIN SYS_DEPARTMENT S");
		sb.append("                    ON D.DEPT_ID = S.SYS_DEPARTMENT_ID");
		sb.append("                  JOIN DP_DATA_REPORT_LOG L");
		sb.append("                    ON D.TASK_CODE = L.TASK_CODE");
		sb.append("                  JOIN DP_LOGIC_TABLE T");
		sb.append("                    ON D.LOGIC_TABLE_ID = T.ID");
		sb.append("                 WHERE 1 = 1 and d.status<>1 ");//排除已忽略
		if (DataSize.CITY.equals(deptQueryType)) {
			sb.append("  and s.code like 'A%' ");
		} else if (DataSize.AREA.equals(deptQueryType)) {
			sb.append("  and s.code like 'B%' ");
		} else if (DataSize.PROVINCE.equals(deptQueryType)) {
			sb.append("  and s.code  like 'C%' ");
		}
		if ( StringUtils.isNotBlank(deptId) ) {
			sb.append("                   AND D.DEPT_ID = :deptId");
			paramMap.put("deptId", deptId);
			
		}
		
		if ( StringUtils.isNotBlank(schemaName) ) {
			sb.append("                   AND T.NAME =:schemaName");
			paramMap.put("schemaName", schemaName);
		}
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                   AND L.CREATE_DATE >= TO_DATE(:startDate, 'yyyy-MM-dd hh24:mi:ss')");
			paramMap.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                   AND L.CREATE_DATE <= TO_DATE(:endDate, 'yyyy-MM-dd hh24:mi:ss')");
			paramMap.put("endDate", endDate);
		}
		sb.append("         ) GROUP BY DEPARTMENT_NAME");
		sb.append("         ORDER BY INVALID_SIZE DESC) A");
		sb.append(" WHERE ROWNUM <= 10");
		return findBySql(sb.toString(), paramMap);
	}

}
