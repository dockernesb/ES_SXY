package com.udatech.center.creditRepair.service;

import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseRepair;
import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.List;
import java.util.Map;

/**
 * @category 信用修复（中心端）
 * @author ccl
 */
public interface CenterRepairService {

	/**
	 * @category 根据ID获取信用修复
	 * @param id
	 * @return
	 */
	EnterpriseRepair getRepairById(String id);

	/**
	 * @category 获取信用修复列表
	 * @param ei
	 * @param page
	 * @return
	 */
	Pageable<Map<String, Object>> getRepairList(EnterpriseInfo ei, String statusType, Page page);

	/**
	 * @category 审核信用修复
	 * @param ei
	 */
	void saveRepairAudit(CreditInfo ci);

	/**
	 * @category 根据ID查询申请信息
	 * @param id
	 * @return
	 */
	CreditInfo getCreditInfoById(String id);

	/**
	 * @category 获取数据状态
	 * @param dataTable
	 * @param thirdId
	 * @return
	 */
	String getDataStatus(String dataTable, String thirdId);

	/**
	 * @category 根据表名，记录ID，字段名查询数据
	 * @param dataTable
	 * @param thirdId
	 * @param fieldList
	 * @return
	 */
	List<Map<String, Object>> getCreditDetail(String dataTable, String thirdId,
                                              List<Map<String, Object>> fieldList);
	
	/**
	 * @category 修复信用
	 * @param ci
	 */
	void amendRepair(CreditInfo ci);

}
