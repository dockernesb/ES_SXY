package com.udatech.sszj.dao.Impl;

import com.udatech.sszj.dao.SszjStatisticsDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 作者:zhanglei
 * @version 创建时间:2018/12/13 0013 10:41
 * @Description 描述:
 */
@Repository
public class SszjStatisticsDaoImpl extends BaseDaoImpl implements SszjStatisticsDao {

	/**
	 * @author zhanglei
	 * @date 15:36 2018/12/13 0013
	 * @Description: 获得统计页面标签数据
	 */
	@Override
	public Map<String, Object> getTotalData(String startDate, String endDate) {
		StringBuffer sb = new StringBuffer();
		Map<String, Object> params = new HashMap<>();
		sb.append(" select sum(t2.glbmSize) glbmSize,                                                      ");
		sb.append("        sum(t2.sszjSize) sszjSize,                                                      ");
		sb.append("        sum(t2.cyrySize) cyrySize,                                                      ");
		sb.append("        sum(t2.pjxxSize) pjxxSize                                                       ");
		sb.append("   from (select count(*) as glbmSize,                                                   ");
		sb.append("                0 as sszjSize,                                                          ");
		sb.append("                0 as cyrySize,                                                          ");
		sb.append("                0 as pjxxSize                                                           ");
		sb.append("           from (select t1.dept_id                                                      ");
		sb.append("                   from sszj_jbxx t1                                                    ");
		sb.append("                  where 1 = 1                                                           ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                  group by t1.dept_id)                                                  ");
		sb.append("         union all                                                                      ");
		sb.append("         select 0 as glbmSize,                                                          ");
		sb.append("                count(*) as sszjSize,                                                   ");
		sb.append("                0 as cyrySize,                                                          ");
		sb.append("                0 as pjxxSize                                                           ");
		sb.append("           from (select *                                                               ");
		sb.append("                   from sszj_jbxx t1                                                    ");
		sb.append("                  where 1 = 1                                                           ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                    )                                                                   ");
		sb.append("         union all                                                                      ");
		sb.append("         select 0 as glbmSize,                                                          ");
		sb.append("                0 as sszjSize,                                                          ");
		sb.append("                count(*) as cyrySize,                                                   ");
		sb.append("                0 as pjxxSize                                                           ");
		sb.append("           from (select *                                                               ");
		sb.append("                   from sszj_zyry t1                                                    ");
		sb.append("                  where 1 = 1                                                           ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                    )                                                                   ");
		sb.append("         union all                                                                      ");
		sb.append("         select 0 as glbmSize,                                                          ");
		sb.append("                0 as sszjSize,                                                          ");
		sb.append("                0 as cyrySize,                                                          ");
		sb.append("                count(*) as pjxxSize                                                    ");
		sb.append("           from (select *                                                               ");
		sb.append("                   from sszj_pjdj t1                                                    ");
		sb.append("                  where 1 = 1                                                           ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
			params.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
			params.put("endDate", endDate);
		}
		sb.append("                    )) t2                                                               ");

		List<Map<String, Object>> list = this.findBySql(sb.toString(), params);
		if (list != null && list.size() > 0) {
			return list.get(0);
		}
		return null;
	}

	/**
	 * @author zhanglei
	 * @date 15:37 2018/12/13 0013
	 * @Description: 获得机构等级柱状图数据
	 */
	@Override
	public List<Map<String, Object>> getJgdjBarData(String startDate, String endDate) {
		StringBuffer sb = new StringBuffer();
		Map<String, Object> params = new HashMap<>();
		sb.append(" select t4.pjdj, count(t4.pjdj) sszjSize                                                         ");
		sb.append("  from (select *                                                                                ");
		sb.append("          from (select row_number() over(partition by t3.tyshxydm                               ");
		sb.append("          order by t3.create_time desc nulls last, t3.update_time desc nulls last) rn,          ");
		sb.append("                       t3.*                                                                     ");
		sb.append("                  from (select t1.tyshxydm,                                                     ");
		sb.append("                               t2.pjdj,                                                         ");
		sb.append("                               t2.create_time,                                                  ");
		sb.append("                               t2.update_time                                                   ");

		sb.append("                          from sszj_jbxx t1                                                     ");
		sb.append("                          join sszj_pjdj t2                                                     ");
		sb.append("                            on t1.tyshxydm = t2.tyshxydm                                   ");
		if (StringUtils.isNotBlank(startDate)) {

			sb.append("                    and to_char(t2.create_time,'yyyy-mm-dd hh24:mi:ss')>=:startDate  ");
			params.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {

			sb.append("                     and to_char(t2.create_time,'yyyy-mm-dd hh24:mi:ss')<=:endDate  ");
			params.put("endDate", endDate);
		}
		sb.append("                               ) t3)        ");
		sb.append("         where rn = 1) t4                                                                       ");
		sb.append(" group by t4.pjdj                                                                               ");

		return this.findBySql(sb.toString(), params);
	}

	/**
	 * @author zhanglei
	 * @date 15:37 2018/12/13 0013
	 * @Description: 获得涉审中介监管信息柱状图数据
	 */
	@Override
	public List<Map<String, Object>> getZjxxBarData(String startDate, String endDate) {
		StringBuffer sb = new StringBuffer();
		Map<String, Object> params = new HashMap<>();
		sb.append(" select t4.*, t5.department_name dept_name                                      ");
		sb.append("   from (select t3.dept_id, sum(sszjSize) sszjSize, sum(pjdjSize) pjdjSize      ");
		sb.append("           from (select t1.dept_id, count(t1.dept_id) sszjSize, 0 as pjdjSize   ");
		sb.append("                   from sszj_jbxx t1                                            ");
		sb.append("                  where 1 = 1                                                           ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
			params.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
			params.put("endDate", endDate);
		}
		sb.append("                  group by t1.dept_id                                           ");
		sb.append("                 union all                                                      ");
		sb.append("                 select t1.dept_id, 0 sszjSize, count(t2.id) as pjdjSize        ");
		sb.append("                   from sszj_jbxx t1                                            ");
		sb.append("                   join sszj_pjdj t2                                            ");
		sb.append("                     on t1.tyshxydm = t2.tyshxydm                               ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                  group by t1.dept_id) t3                                       ");
		sb.append("          group by t3.dept_id) t4                                               ");
		sb.append("                                                                                ");
		sb.append("    left join sys_department t5                                                  ");
		sb.append("     on t4.dept_id = t5.sys_department_id                                       ");
		return this.findBySql(sb.toString(), params);
	}

	/**
	 * @author zhanglei
	 * @date 15:37 2018/12/13 0013
	 * @Description: 获得统计页面表格数据(分页)
	 */
	@Override
	public Pageable<Map<String, Object>> getDataTable(String startDate, String endDate, Page page) {
		StringBuffer sb = new StringBuffer();
		Map<String, Object> params = new HashMap<>();
		sb.append(" select t6.department_name dept_name,                    ");
		sb.append(" nvl(t5.sszjSize, 0) sszjSize,                           ");
		sb.append(" nvl(t5.pjdjSize, 0) pjdjSize,                           ");
		sb.append("  nvl(t5.cyrySize, 0) cyrySize,                           ");
		sb.append("  nvl(t5.hejiSize, 0) hejiSize                            ");
		sb.append("   from (select t4.dept_id,                                    ");
		sb.append("                sum(sszjSize) sszjSize,                        ");
		sb.append("                sum(pjdjSize) pjdjSize,                        ");
		sb.append("                sum(cyrySize) cyrySize,                        ");
		sb.append("                sum(hejiSize) hejiSize                         ");
		sb.append("           from (select t3.dept_id,                            ");
		sb.append("                        sszjSize,                              ");
		sb.append("                        pjdjSize,                              ");
		sb.append("                        cyrySize,                              ");
		sb.append("                        (sszjSize + pjdjSize) as hejiSize      ");
		sb.append("                   from (select t1.dept_id,                    ");
		sb.append("                                count(t1.dept_id) sszjSize,    ");
		sb.append("                                0 as pjdjSize,                 ");
		sb.append("                                0 as cyrySize,                 ");
		sb.append("                                0 as hejiSize                  ");
		sb.append("                           from sszj_jbxx t1                   ");
		sb.append("                  where 1 = 1                                                           ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
			params.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
			params.put("endDate", endDate);
		}
		sb.append("                          group by t1.dept_id                  ");
		sb.append("                         union all                             ");
		sb.append("                         select t1.dept_id,                    ");
		sb.append("                                0 sszjSize,                    ");
		sb.append("                                count(t2.id) as pjdjSize,      ");
		sb.append("                                0 as cyrySize,                 ");
		sb.append("                                0 as hejiSize                  ");
		sb.append("                           from sszj_jbxx t1                   ");
		sb.append("                           join sszj_pjdj t2                   ");
		sb.append("                             on t1.tyshxydm = t2.tyshxydm      ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                          group by t1.dept_id                  ");
		sb.append("                         union all                             ");
		sb.append("                         select t1.dept_id,                    ");
		sb.append("                                0 sszjSize,                    ");
		sb.append("                                0 as pjdjSize,                 ");
		sb.append("                                count(t2.id) as cyrySize,      ");
		sb.append("                                0 as hejiSize                  ");
		sb.append("                           from sszj_jbxx t1                   ");
		sb.append("                           join sszj_zyry t2                   ");
		sb.append("                             on t1.tyshxydm = t2.tyshxydm      ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                          group by t1.dept_id) t3) t4          ");
		sb.append("          group by t4.dept_id) t5                              ");
		sb.append("    right join sys_department t6                                 ");
		sb.append("     on t5.dept_id = t6.sys_department_id                      ");
		sb.append("   order by t5.sszjSize                                  ");

		String countSql = "select count(*) from (" + sb.toString() + " ) A ";
		return this.findBySqlWithPage(sb.toString(), countSql, page, params);
	}

	/**
	 * @author zhanglei
	 * @date 15:37 2018/12/13 0013
	 * @Description: 获得统计页面表格数据(导出)
	 */
	@Override
	public List<Map<String, Object>> getDataTable(String startDate, String endDate) {
		StringBuffer sb = new StringBuffer();
		Map<String, Object> params = new HashMap<>();
		sb.append("  select case                                          ");
		sb.append("           when t7.dept_name is null then              ");
		sb.append("            '小计'                                     ");
		sb.append("           else                                        ");
		sb.append("            dept_name                                  ");
		sb.append("         end as dept_name,                             ");
		sb.append("         sum(t7.sszjSize) sszjSize,                    ");
		sb.append("         sum(t7.pjdjSize) pjdjSize,                    ");
		sb.append("         sum(t7.cyrySize) cyrySize,                    ");
		sb.append("         sum(t7.hejiSize) hejiSize                     ");
		sb.append("    from (select t6.department_name dept_name,         ");
		sb.append("                 nvl(t5.sszjSize, 0) sszjSize,         ");
		sb.append("                 nvl(t5.pjdjSize, 0) pjdjSize,         ");
		sb.append("                 nvl(t5.cyrySize, 0) cyrySize,         ");
		sb.append("                 nvl(t5.hejiSize, 0) hejiSize          ");
		sb.append("            from (select t4.dept_id,                   ");
		sb.append("                sum(sszjSize) sszjSize,                        ");
		sb.append("                sum(pjdjSize) pjdjSize,                        ");
		sb.append("                sum(cyrySize) cyrySize,                        ");
		sb.append("                sum(hejiSize) hejiSize                         ");
		sb.append("           from (select t3.dept_id,                            ");
		sb.append("                        sszjSize,                              ");
		sb.append("                        pjdjSize,                              ");
		sb.append("                        cyrySize,                              ");
		sb.append("                        (sszjSize + pjdjSize) as hejiSize      ");
		sb.append("                   from (select t1.dept_id,                    ");
		sb.append("                                count(t1.dept_id) sszjSize,    ");
		sb.append("                                0 as pjdjSize,                 ");
		sb.append("                                0 as cyrySize,                 ");
		sb.append("                                0 as hejiSize                  ");
		sb.append("                           from sszj_jbxx t1                   ");
		sb.append("                  where 1 = 1                                                           ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
			params.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t1.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
			params.put("endDate", endDate);
		}
		sb.append("                          group by t1.dept_id                  ");
		sb.append("                         union all                             ");
		sb.append("                         select t1.dept_id,                    ");
		sb.append("                                0 sszjSize,                    ");
		sb.append("                                count(t2.id) as pjdjSize,      ");
		sb.append("                                0 as cyrySize,                 ");
		sb.append("                                0 as hejiSize                  ");
		sb.append("                           from sszj_jbxx t1                   ");
		sb.append("                           join sszj_pjdj t2                   ");
		sb.append("                             on t1.tyshxydm = t2.tyshxydm      ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                          group by t1.dept_id                  ");
		sb.append("                         union all                             ");
		sb.append("                         select t1.dept_id,                    ");
		sb.append("                                0 sszjSize,                    ");
		sb.append("                                0 as pjdjSize,                 ");
		sb.append("                                count(t2.id) as cyrySize,      ");
		sb.append("                                0 as hejiSize                  ");
		sb.append("                           from sszj_jbxx t1                   ");
		sb.append("                           join sszj_zyry t2                   ");
		sb.append("                             on t1.tyshxydm = t2.tyshxydm      ");
		if (StringUtils.isNotBlank(startDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') >=:startDate   ");
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append("                    and to_char(t2.create_time, 'yyyy-mm-dd hh24;mi:ss') <=:endDate     ");
		}
		sb.append("                          group by t1.dept_id) t3) t4          ");
		sb.append("          group by t4.dept_id) t5                              ");
		sb.append("   right join sys_department t6                                 ");
		sb.append("     on t5.dept_id = t6.sys_department_id                      ");
		sb.append("  order by t5.sszjSize ) t7                              ");
		sb.append("                group by rollup(t7.dept_name)                  ");

		return this.findBySql(sb.toString(), params);
	}
}
