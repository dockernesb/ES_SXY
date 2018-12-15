package com.udatech.center.creditObjection.service.impl;

import com.udatech.center.creditObjection.dao.CenterObjectionDao;
import com.udatech.center.creditObjection.service.CenterObjectionService;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseObjection;
import com.udatech.common.model.FieldInfo;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.log.ExpLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @category 信用异议（中心端）
 * @author ccl
 */
@Service
@ExpLog(type = "信用中心异议申诉审核")
public class CenterObjectionServiceImpl implements CenterObjectionService {

	@Autowired
	private CenterObjectionDao centerObjectionDao;

	@Autowired
	private CreditCommonDao commonDao;

	/**
	 * @category 根据ID获取异议申诉
	 * @param id
	 * @return
	 */
	public EnterpriseObjection getObjectionById(String id) {
		EnterpriseObjection eo = centerObjectionDao.getObjectionById(id);
		if (eo != null) {
			eo.setYyzz(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业异议申诉申请企业工商营业执照));
			eo.setZzjgdmz(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业异议申诉申请组织机构代码证));
			eo.setQysqs(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业异议申诉申请企业授权书));
			eo.setSfz(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业异议申诉申请经办人身份证));
			eo.setYyxxsqb(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业异议申诉申请申请表));
			eo.setZmcl(commonDao
					.getUploadFiles(id, UploadFileEnmu.企业异议申诉申请证明材料));
		}
		return eo;
	}

	/**
	 * @category 根据ID查询申请信息
	 * @param id
	 * @return
	 */
	public CreditInfo getCreditInfoById(String id) {
		return centerObjectionDao.getCreditInfoById(id);
	}

	/**
	 * @category 获取异议申诉列表
	 * @param ei
	 * @param page
	 * @return
	 */
	public Pageable<Map<String, Object>> getObjectionList(EnterpriseInfo ei, String statusType,
                                                          Page page) {
		return centerObjectionDao.getObjectionList(ei,statusType, page);
	}

	/**
	 * @category 审核异议申诉
	 * @param ei
	 */
	@Transactional
	public void saveObjectionAudit(CreditInfo ci) {
		centerObjectionDao.saveObjectionAudit(ci);
	}

	/**
	 * @category 查看历史修正数据
	 * @param ci
	 * @return
	 */
	public List<FieldInfo> viewHistory(CreditInfo ci) {
		return centerObjectionDao.viewHistory(ci);
	}

	/**
	 * @category 根据表名，记录ID，字段名查询数据
	 * @param dataTable
	 * @param thirdId
	 * @param fieldList
	 * @return
	 */
	public List<Map<String, Object>> getCreditDetail(String dataTable,
			String thirdId, List<Map<String, Object>> fieldList) {
		return centerObjectionDao
				.getCreditDetail(dataTable, thirdId, fieldList);
	}

	/**
	 * @category 删除异议
	 * @param ci
	 */
	@Transactional
	public void deleteObjection(CreditInfo ci) {
		centerObjectionDao.deleteObjection(ci);
	}

	/**
	 * @category 修正异议
	 * @param ci
	 */
	@Transactional
	public void amendObjection(CreditInfo ci) {
		centerObjectionDao.amendObjection(ci);
	}

	/**
	 * @category 获取数据状态
	 * @param dataTable
	 * @param thirdId
	 * @return
	 */
	public String getDataStatus(String dataTable, String thirdId) {
		return centerObjectionDao.getDataStatus(dataTable, thirdId);
	}

	/**
	 * @category 保存修正数据追溯
	 * @param ci
	 */
	public void saveAmendDataTrace(CreditInfo ci) {

	}

}
