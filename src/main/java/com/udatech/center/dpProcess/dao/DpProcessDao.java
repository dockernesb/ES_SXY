package com.udatech.center.dpProcess.dao;

import java.util.List;
import java.util.Map;
public interface DpProcessDao {

	/**
	 * 获取入库数据总量
	 * @return
	 */
	public List<Map<String, Object>> getAllProcessCount();
	/**
	 * 按条件查询入库数据量
	 * @return
	 */
	public List<Map<String, Object>> queryStorageQuantity(String type,String startDate,String endDate);
	/**
	 * 按条件查询部门入库数据量
	 * @return
	 */
	public List<Map<String, Object>> queryDeptQuantity(String type,String startDate,String endDate);
	/**
	 * 查询部门下的目录入库数据量
	 * @return
	 */
	public List<Map<String, Object>> queryTableQuantityByDeptId(String startDate, String endDate, String deptId);
	/**
	 * 双公示法人，自然人统计
	 * @return
	 */
	public List<Map<String, Object>>  queryDataCategoryQuantity(String type,String personType, String startDate, String endDate);
	public long countBySql(String sql);
	/**
	 * 部门编码 首字母查询
	 * @return
	 */
	public List<Map<String, Object>> getDeptByFirstCode(String code);
	/**
	 * 双公示查询数据量
	 * @return
	 */
	public List<Map<String, Object>> querySgsDataQuality(String type,String dimension, String startDate, String endDate);
	/**
	 * 双公示查询部门下的数据量
	 * @return
	 */
	public List<Map<String, Object>> queryDataTable(String type,String dimension, String startDate, String endDate,String deptId);
	/**
	 * 双公示月统计
	 * @return
	 */
	public List<Map<String, Object>> querySgsMonthData(String type, String dimension,String startDate, String endDate, String deptId);

}
