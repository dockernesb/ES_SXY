package com.udatech.center.dpProcess.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.udatech.center.dpProcess.dao.DpProcessDao;
import com.udatech.common.statisAnalyze.dao.DataStatisticsCommonDao;
import com.wa.framework.dao.BaseDaoImpl;
/**
 * 描述：入库数据统计、双公示入库统计
 * 创建人： luqb
 * 创建时间：2018年6月25日上午9:23:52
 */
@Repository
public class DpProcessDaoImpl extends BaseDaoImpl implements DpProcessDao {
    @Autowired
    private DataStatisticsCommonDao dataStatisticsCommonDao;
    private static String QX = "qx";//区县部门
    private static String SZ = "sz";//市辖部门
    private static String SBRQ = "sbrq";
	@Override
	public List<Map<String, Object>> getAllProcessCount() {
		StringBuffer sql = new StringBuffer();
		sql.append(" select t.person_type type,sum(t.process_size) ctn ");
        sql.append("  from ( ").append(getCommSql()).append(" ) t group by t.person_type ");
        sql.append("  union all ");
		sql.append(" select substr(t.dept_code, 0, 1) type,sum(t.process_size) ctn ");
        sql.append("  from ( ").append(getCommSql()).append(" ) t group by substr(t.dept_code, 0, 1) ");
        return this.findBySql(sql.toString());
	}
    public String getCommSql(){
    	StringBuffer sql = new StringBuffer();
    	sql.append(" select d.department_name dept_name,                           ");
    	sql.append("        dr.dept_id,                                            ");
    	sql.append("        d.code dept_code,                                      ");
    	sql.append("        dt.id table_id,                                        ");
    	sql.append("        dt.code table_code,                                    ");
    	sql.append("        dt.name table_name,                                    ");
    	sql.append("        dt.data_category,                                      ");
    	sql.append("        dt.person_type,                                        ");
    	sql.append("        nvl(dr.process_size, 0) process_size,                  ");
    	sql.append("        dr.process_time,                                       ");
    	sql.append("        t.dict_key,                                            ");
    	sql.append("        t.dict_value,                                          ");
    	sql.append("        dr.task_code,                                          ");
    	sql.append("        dr.type,                                               ");
    	sql.append("        dr.etl_type                                            ");
    	sql.append("   from dp_process_result dr                                   ");
    	sql.append("   left join dp_logic_table dt                                 ");
    	sql.append("     on dr.table_code = dt.code                                ");
    	sql.append("   left join sys_department d                                  ");
    	sql.append("     on dr.dept_id = d.sys_department_id                       ");
    	sql.append("   left join (select sd.dict_value, sd.dict_key                ");
    	sql.append("                from sys_dictionary sd, sys_dictionary_group g "); 
    	sql.append("               where sd.group_id = g.id                        ");
    	sql.append("                 and g.group_key = 'data_category') t          ");
    	sql.append("     on dt.data_category = t.dict_key                          ");
    	sql.append("  where 1 = 1 and dr.type = 1 and dr.etl_type = 1              ");
		return sql.toString();
    }
    public void addQueryDate(StringBuffer sql,String startDate,String endDate){
    	if(StringUtils.isNotBlank(startDate))
    		sql.append(" and t.process_time >= to_date(:startDate,'yyyy-mm-dd') ");
    	if(StringUtils.isNotBlank(endDate))
    		sql.append(" and t.process_time <= to_date(:endDate,'yyyy-mm-dd')+1 ");
    }
	
    @Override
    public List<Map<String, Object>> queryStorageQuantity(String type,
    		String startDate, String endDate) {
    	StringBuffer sql = new StringBuffer();
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        sql.append(" select sum(t.process_size) allsize, t.dept_id, t.dept_name  ");
        sql.append("  from ( ").append(getCommSql()).append(" ) t where 1=1 ");
        if(QX.equals(type)){
    		sql.append(" and substr(t.dept_code,0,1)='B' ");
    	}else if(SZ.equals(type)){
    		sql.append(" and substr(t.dept_code,0,1)='A' ");
    	}
        addQueryDate(sql, startDate, endDate);
        sql.append(" group by t.dept_id, t.dept_name ");
        return this.findBySql(sql.toString(), param);
    }
    

	@Override
	public List<Map<String, Object>> queryDeptQuantity(String type, String startDate,
			String endDate) {
		StringBuffer sql = new StringBuffer();
		HashMap<String, Object> param = new HashMap<String, Object>();
	    param.put("startDate", startDate);
	    param.put("endDate", endDate);
	    sql.append(" select * from ( ");
	    sql.append(" select t.dept_id, t.dept_name,nvl(sum(t.process_size), 0) allsize,");
	    sql.append(" nvl(sum(case when t.person_type = '0' then t.process_size end), 0) frsize,");
	    sql.append(" nvl(sum(case when t.person_type = '1' then t.process_size end), 0) zrrsize ");
        sql.append("  from ( ").append(getCommSql()).append(" ) t where 1=1 ");
        if(QX.equals(type)){
    		sql.append(" and substr(t.dept_code,0,1)='B' ");
    	}else if(SZ.equals(type)){
    		sql.append(" and substr(t.dept_code,0,1)='A' ");
    	}
        addQueryDate(sql, startDate, endDate);
        sql.append(" group by t.dept_id,t.dept_name ");
        sql.append(") order by  allsize desc ");
		return this.findBySql(sql.toString(), param);
	}
	

	@Override
	public List<Map<String, Object>> queryTableQuantityByDeptId(
			String startDate, String endDate, String deptId) {
		StringBuffer sql = new StringBuffer();
		HashMap<String, Object> param = new HashMap<String, Object>();
	    param.put("startDate", startDate);
	    param.put("endDate", endDate);
	    param.put("deptId", deptId);
	    sql.append(" select * from (");
	    sql.append(" select t.table_id, t.table_name, sum(t.process_size) allsize ");
        sql.append("  from ( ").append(getCommSql()).append(" ) t where 1=1 ");
        addQueryDate(sql, startDate, endDate);
	    sql.append(" and t.dept_id =:deptId ");
	    sql.append(" group by t.table_id, t.table_name ");
	    sql.append(") order by allsize desc ");
		return this.findBySql(sql.toString(), param);
	}


	@Override
	public List<Map<String, Object>> queryDataCategoryQuantity(
			String type,String personType, String startDate, String endDate) {
		HashMap<String, Object> param = new HashMap<String, Object>();
	    param.put("startDate", startDate);
	    param.put("endDate", endDate);
	    param.put("personType", personType);
		StringBuffer sql = new StringBuffer();
		sql.append(" select t.dict_value,sum(t.process_size) allsize ");
        sql.append("  from ( ").append(getCommSql()).append(" ) t where 1=1 ");
    	if(QX.equals(type)){
    		sql.append(" and substr(t.dept_code,0,1)='B' ");
    	}else if(SZ.equals(type)){
    		sql.append(" and substr(t.dept_code,0,1)='A' ");
    	}
		if(StringUtils.isNotBlank(personType))
			sql.append(" and t.person_type =:personType ");
		addQueryDate(sql, startDate, endDate);
    	sql.append(" group by t.dict_value ");
		return this.findBySql(sql.toString(), param);
	}
	
	
	
	
	@Override
	public long countBySql(String sql) {
		Map<String, Object> map = new HashMap<String, Object>();
		return this.countBySql(sql, map);
	}
	@Override
	public List<Map<String, Object>> getDeptByFirstCode(String code) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("code", code);
		String sql = "select SYS_DEPARTMENT_ID ,DEPARTMENT_NAME  from sys_department where status = '0'  ";
		if(StringUtils.isNotBlank(code)){
			sql += " and substr(code,0,1) = :code ";
		}
		return this.findBySql(sql, param);
	}
	
	public String getSgsCommSql(String type,String dimension,String startDate,String endDate){
		StringBuffer sql = new StringBuffer();
		sql.append(" select t.create_time,t.xksxq jdrq,t.bmbm,t.bmmc,'XK' tab,subject_type from yw_l_sgsxzxk t where 1=1 ");
		if(SBRQ.equals(dimension)){
	    	if(StringUtils.isNotBlank(startDate))
	    		sql.append(" and t.create_time >= to_date(:startDate,'yyyy-mm-dd') ");
	    	if(StringUtils.isNotBlank(endDate))
	    		sql.append(" and t.create_time < to_date(:endDate,'yyyy-mm-dd')+1 ");
		}else{
	    	if(StringUtils.isNotBlank(startDate))
	    		sql.append(" and t.xksxq >= to_date(:startDate,'yyyy-mm-dd') ");
	    	if(StringUtils.isNotBlank(endDate))
	    		sql.append(" and t.xksxq < to_date(:endDate,'yyyy-mm-dd')+1 ");
		}
		if(SZ.equals(type)){
			sql.append(" and substr(bmbm,0,1)='A'");
		}else if(QX.equals(type)){
			sql.append(" and substr(bmbm,0,1)='B'");
		}
		sql.append(" union all ");
		sql.append(" select t.create_time,t.cfsxq jdrq,t.bmbm,t.bmmc,'CF' tab,subject_type from yw_l_sgsxzcf t where 1=1 ");
		if(SBRQ.equals(dimension)){
	    	if(StringUtils.isNotBlank(startDate))
	    		sql.append(" and t.create_time >= to_date(:startDate,'yyyy-mm-dd') ");
	    	if(StringUtils.isNotBlank(endDate))
	    		sql.append(" and t.create_time < to_date(:endDate,'yyyy-mm-dd')+1 ");
		}else{
	    	if(StringUtils.isNotBlank(startDate))
	    		sql.append(" and t.cfsxq >= to_date(:startDate,'yyyy-mm-dd') ");
	    	if(StringUtils.isNotBlank(endDate))
	    		sql.append(" and t.cfsxq < to_date(:endDate,'yyyy-mm-dd')+1 ");
		}
		if(SZ.equals(type)){
			sql.append(" and substr(bmbm,0,1)='A'");
		}else if(QX.equals(type)){
			sql.append(" and substr(bmbm,0,1)='B'");
		}
		return sql.toString();
	}
	
	
	@Override
	public List<Map<String, Object>> querySgsDataQuality(String type,
			String dimension, String startDate, String endDate) {
		HashMap<String, Object> param = new HashMap<String, Object>();
	    param.put("startDate", startDate);
	    param.put("endDate", endDate);
		StringBuffer sql = new StringBuffer();
		sql.append(" select * from (");
		sql.append(" select d.department_name bmmc,nvl(xksize,0) xksize,nvl(cfsize,0) cfsize from sys_department d left join  (");
		sql.append(" select bmbm,sum(case when t.tab = 'XK' then 1 end ) xksize,sum(case when t.tab = 'CF' then 1 end ) cfsize from (");
		sql.append(getSgsCommSql(type, dimension, startDate, endDate)).append(") t");
		sql.append(" group by bmbm");
		sql.append(") t on d.code = t.bmbm where 1=1 ");
		if(SZ.equals(type)){
			sql.append(" and substr(d.code,0,1)='A' ");
		}else if(QX.equals(type)){
			sql.append(" and substr(d.code,0,1)='B' ");
		}
		sql.append(") order by xksize desc");
		return this.findBySql(sql.toString(), param);
	}
	@Override
	public List<Map<String, Object>> queryDataTable(String type,
			String dimension, String startDate, String endDate, String deptId) {
		HashMap<String, Object> param = new HashMap<String, Object>();
	    param.put("startDate", startDate);
	    param.put("endDate", endDate);
	    param.put("deptId", deptId);
/*		String sdSql = " select t.code,t.department_name name from sys_department t where t.sys_department_id =:deptId ";
		Map<String, Object> sd = this.uniqueBySql(sdSql, param);*/
	    StringBuffer sql = new StringBuffer();
	    sql.append(" select department_name deptName,");
	    sql.append(" xksize_l+xksize_p+cfsize_l+cfsize_p allsize,");
	    sql.append(" xksize_l+xksize_p xksize,");
	    sql.append(" cfsize_l+cfsize_p cfsize,");
	    sql.append(" xksize_l,xksize_p,cfsize_l,cfsize_p ");
	    sql.append(" from (");
	    sql.append(" select d.department_name,");
	    sql.append(" sum(case when (t.tab = 'XK' and t.subject_type = 0) then 1 else 0 end ) xksize_l,");
	    sql.append(" sum(case when (t.tab = 'XK' and t.subject_type = 1) then 1 else 0 end ) xksize_p,");
	    sql.append(" sum(case when (t.tab = 'CF' and t.subject_type = 0) then 1 else 0 end ) cfsize_l,");
	    sql.append(" sum(case when (t.tab = 'CF' and t.subject_type = 1) then 1 else 0 end ) cfsize_p ");
	    sql.append(" from (");
	    sql.append(getSgsCommSql(type, dimension, startDate, endDate)).append(") t  ");
	    sql.append(" right join sys_department d on t.bmbm = d.code where 1=1 ");
	    if(StringUtils.isNotBlank(deptId)){
	    	sql.append(" and d.sys_department_id =:deptId ");
	    }
		if(SZ.equals(type)){
			sql.append(" and substr(d.code,0,1)='A'");
		}else if(QX.equals(type)){
			sql.append(" and substr(d.code,0,1)='B'");
		}
	    sql.append("group by d.department_name");
		sql.append(") order by allsize desc");
		
		return this.findBySql(sql.toString(), param);
	}
	@Override
	public List<Map<String, Object>> querySgsMonthData(String type,
			String dimension, String startDate, String endDate, String deptId) {
		HashMap<String, Object> param = new HashMap<String, Object>();
	    param.put("startDate", startDate);
	    param.put("endDate", endDate);
	    param.put("deptId", deptId);
		StringBuffer sql = new StringBuffer();
		String groupBy = SBRQ.equals(dimension) ? "create_time" : "jdrq";
		sql.append(" select m.mon,nvl(xksize,0) xksize,nvl(cfsize,0) cfsize  from (select to_char(add_months(trunc(sysdate),-rownum+1),'yyyy/mm') mon ");
		sql.append(" from all_objects where rownum <=1000) m left join (");
		sql.append(" select  ");
		sql.append(" to_char(").append(groupBy).append(",'yyyy/mm') mon, ");
	    sql.append(" sum(case when t.tab = 'XK' then 1 else 0 end ) xksize,");
	    sql.append(" sum(case when t.tab = 'CF' then 1 else 0 end ) cfsize ");
		sql.append(" from (");
		sql.append(getSgsCommSql(type, dimension, null, null)).append(") t  ");
		sql.append(" left join sys_department d on t.bmbm = d.code where 1=1 ");
	    if(StringUtils.isNotBlank(deptId)){
	    	sql.append(" and d.sys_department_id =:deptId ");
	    }
		sql.append(" group by ").append("to_char(").append(groupBy).append(",'yyyy/mm')");
		sql.append(") t on m.mon = t.mon where 1=1 ");
		if(StringUtils.isNotBlank(endDate)&& StringUtils.isBlank(startDate)){
			String monthEnd = getYearMoth(endDate, 0);
			String monthStart = getYearMoth(endDate, -36);
			param.put("monthStart", monthStart);
			param.put("monthEnd", monthEnd);
			sql.append(" and m.mon between :monthStart and :monthEnd ");
		}else {
			if(StringUtils.isNotBlank(startDate)){
				String monthStart = getYearMoth(startDate, 0);
				param.put("monthStart", monthStart);
				sql.append(" and m.mon >=:monthStart ");
			}
			if(StringUtils.isNotBlank(endDate)){
				String monthEnd = getYearMoth(endDate, 0);
				param.put("monthEnd", monthEnd);
				sql.append(" and m.mon <=:monthStart ");
			}
			if(StringUtils.isBlank(startDate)&&StringUtils.isBlank(endDate)){
				String monthStart = getYearMoth(null, -5);
				param.put("monthStart", monthStart);
				sql.append(" and m.mon >=:monthStart ");
			}
		}
		sql.append(" order by m.mon desc ");
		return this.findBySql(sql.toString(), param);
	}
	
	
	public static String getYearMoth(String day,int num){
		   SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		   Date date = new Date();
		   Calendar ca = Calendar.getInstance();
		   if(StringUtils.isNotBlank(day)){
			   try { 
				   date = format.parse(day); 
			   } catch (ParseException e) { 
				   e.printStackTrace(); 
			   }
		   }
		   ca.setTime(date);
		   ca.add(Calendar.MONTH, num);
		   int year = ca.get(Calendar.YEAR);
		   int month = ca.get(Calendar.MONTH)+1;
		   return ""+year+"/"+(month < 10 ? "0"+month : month );
	}
}
