package com.udatech.center.creditObjection.service;

import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseObjection;
import com.udatech.common.model.FieldInfo;
import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.List;
import java.util.Map;

/**
 * @category 信用异议（中心端）
 * @author ccl
 */
public interface CenterObjectionService {

	/**
	 * @category 根据ID获取异议申诉
	 * @param id
	 * @return
	 */
	EnterpriseObjection getObjectionById(String id);

	/**
	 * @category 根据ID查询申请信息
	 * @param id
	 * @return
	 */
	CreditInfo getCreditInfoById(String id);

	/**
	 * @category 获取异议申诉列表
	 * @param ei
	 * @param page
	 * @return
	 */
	Pageable<Map<String, Object>> getObjectionList(EnterpriseInfo ei, String statusType, Page page);

	/**
	 * @category 审核异议申诉
	 * @param ei
	 */
	void saveObjectionAudit(CreditInfo ci);

	/**
	 * @category 查看历史修正数据
	 * @param ci
	 * @return
	 */
	List<FieldInfo> viewHistory(CreditInfo ci);

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
	 * @category 删除异议
	 * @param ci
	 */
	void deleteObjection(CreditInfo ci);

	/**
	 * @category 修正异议
	 * @param ci
	 */
	void amendObjection(CreditInfo ci);

	/**
	 * @category 获取数据状态
	 * @param dataTable
	 * @param thirdId
	 * @return
	 */
	String getDataStatus(String dataTable, String thirdId);
	
	/**
	 * @category 保存修正数据追溯
	 * @param ci
	 */
	void saveAmendDataTrace(CreditInfo ci);

}
