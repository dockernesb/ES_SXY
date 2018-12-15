package com.udatech.common.statisAnalyze.service.impl;

import com.udatech.common.constant.Constants;
import com.udatech.common.service.CreditCommonService;
import com.udatech.common.statisAnalyze.dao.DataQualityDao;
import com.udatech.common.statisAnalyze.service.DataQualityService;
import com.wa.framework.log.ExpLog;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;

import java.util.*;

/**
 * @category 数据质量统计
 * @author Administrator
 */
@Service
@ExpLog(type="数据质量统计")
public class DataQualityServiceImpl implements DataQualityService {

	@Autowired
	private DataQualityDao dataQualityDao;

	@Autowired
	private CreditCommonService creditCommonService;

	@Override
	public Map<String, Object> packageCriteria(HttpServletRequest request) {
		creditCommonService.checkDept(request);
		String sysDeptId = request.getParameter("sysDeptId"); // 中心端的查询字段，不为空
		String schemaName = request.getParameter("schemaName");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String isDeptGroup = request.getParameter("isDeptGroup");
		String linkSchemaName = request.getParameter("linkSchemaName");
		String linkDeptName = request.getParameter("linkDeptName");
		String deptQueryType = request.getParameter("deptQueryType");
		SysUser user = (SysUser)request.getAttribute("user");
		
		String deptId = (String) request.getAttribute("deptId");// 政务端不为空
		if (Constants.ADMIN.equals(user.getType()) || Constants.CENTER.equals(user.getType())) {
				deptId = sysDeptId;
		}

		if (StringUtils.isNotBlank(startDate)) {
			startDate = startDate + " 00:00:00";
		}

		if (StringUtils.isNotBlank(endDate)) {
			endDate = endDate + " 23:59:59";
		}

		Map<String,Object> criteriaMap = new HashMap<>();
		criteriaMap.put("deptId", deptId);
		criteriaMap.put("schemaName", schemaName);
		criteriaMap.put("startDate", startDate);
		criteriaMap.put("endDate", endDate);
		criteriaMap.put("isDeptGroup", isDeptGroup);
		criteriaMap.put("linkSchemaName", linkSchemaName);
		criteriaMap.put("linkDeptName", linkDeptName);
		criteriaMap.put("deptQueryType", deptQueryType);
		return criteriaMap;
	}

	@Override
	public Map<String, Object> getErrorCount(Map<String, Object> criteriaMap) {
		return dataQualityDao.getErrorCount(criteriaMap);
	}

	@Override
	public Map<String, Object> getErrorStatistics(Map<String, Object> criteriaMap) {
		// 获取疑问数据各状态数据量
		List<Map<String, Object>> list1 = dataQualityDao.getErrorStatusStatistics(criteriaMap);

		// 获取疑问数据各疑问类型数据量
		//List<Map<String, Object>> list2 = dataQualityDao.getErrorCodeStatistics(criteriaMap);
		List<Map<String, Object>> list2 = dataQualityDao.getErrorDateStatistics(criteriaMap);
		
		Map<String, Object> map2 = creditCommonService.getAllChartDatas(list2);

		Map<String, Object> returnMap = new HashMap<>();
		returnMap.put("statusData",list1);
		returnMap.put("codeData",map2);
		return returnMap;
	}

	@Override
	public Map<String, Object> getErrorHandleSituation(Map<String, Object> criteriaMap, boolean isDeptGroup) {
		// 获取疑问数据处理情况数据量
		List<Map<String, Object>> list1 = dataQualityDao.getErrorHandleSituation(criteriaMap, isDeptGroup);
		Map<String, Object> returnMap = creditCommonService.getAllChartDatas(list1);
		return returnMap;
	}

	@Override
	public Map<String, Object> getErrorHandleMonthStatistics(Map<String, Object> criteriaMap) {
		String startMonth = dataQualityDao.getMinDate(criteriaMap);

		String startDate = MapUtils.getString(criteriaMap, "startDate");
		if (StringUtils.isNotBlank(startDate)) {
			startMonth = DateUtils.format(DateUtils.parseDate(startDate, DateUtils.YYYYMMDDHHMMSS_19), Constants.YYYYMMDD_7);
		}

		Date newDate = new Date();

		String endMonth = DateUtils.format(newDate, Constants.YYYYMMDD_7);
		String endDate = MapUtils.getString(criteriaMap, "endDate");

		if (StringUtils.isNotBlank(endDate)) {
			endMonth = DateUtils.format(DateUtils.parseDate(endDate, DateUtils.YYYYMMDDHHMMSS_19), Constants.YYYYMMDD_7);
		}

		criteriaMap.put("startMonth", startMonth);
		criteriaMap.put("endMonth", endMonth);
		criteriaMap.put("isLinkQuery", true); // 是否是联动查询
		List<Map<String, Object>> list = dataQualityDao.getErrorHandleMonthStatistics(criteriaMap);
		Map<String, Object> returnMap = creditCommonService.getAllChartDatas(list);
		return returnMap;
	}

	@Override
	public List<Map<String, Object>> getErrorDataTable(Map<String, Object> criteriaMap) {
		List<Map<String, Object>> list  = dataQualityDao.getErrorDataTable(criteriaMap);
		for (Map<String, Object> map : list) {
			map.put("CLL", MapUtils.getString(map, "CLL", "0") + "%");
			map.put("HLL", MapUtils.getString(map, "HLL", "0") + "%");
			map.put("XGL", MapUtils.getString(map, "XGL", "0") + "%");
		}
		return list;
	}

	@Override
	public List<Map<String, Object>> queryDetailsBySchema(Map<String, Object> criteriaMap) {
		List<Map<String, Object>> list  = dataQualityDao.queryDetailsBySchema(criteriaMap);
		for (Map<String, Object> map : list) {
			map.put("CLL", MapUtils.getString(map, "CLL", "0") + "%");
			map.put("HLL", MapUtils.getString(map, "HLL", "0") + "%");
			map.put("XGL", MapUtils.getString(map, "XGL", "0") + "%");
		}
		return list;
	}

}
