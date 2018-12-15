package com.udatech.center.creditRepair.service.impl;

import com.udatech.center.creditRepair.dao.CenterRepairDao;
import com.udatech.center.creditRepair.service.CenterRepairService;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseRepair;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.log.ExpLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @category 信用修复（中心端）
 * @author ccl
 */
@Service
@ExpLog(type = "信用中心信用修复审核")
public class CenterRepairServiceImpl implements CenterRepairService {

	@Autowired
	private CenterRepairDao centerRepairDao;

	@Autowired
	private CreditCommonDao commonDao;

	/**
	 * @category 根据ID获取信用修复
	 * @param id
	 * @return
	 */
	public EnterpriseRepair getRepairById(String id) {
		EnterpriseRepair er = centerRepairDao.getRepairById(id);
		if (er != null) {
			er.setYyzz(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业信用修复申请企业工商营业执照));
			er.setZzjgdmz(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业信用修复申请组织机构代码证));
			er.setQysqs(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业信用修复申请企业授权书));
			er.setSfz(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业信用修复申请经办人身份证));
			er.setXfxxsqb(commonDao.getUploadFiles(id,
					UploadFileEnmu.企业信用修复申请申请表));
			er.setZmcl(commonDao
					.getUploadFiles(id, UploadFileEnmu.企业信用修复申请证明材料));
		}
		return er;
	}

	/**
	 * @category 获取信用修复列表
	 * @param ei
	 * @param page
	 * @return
	 */
	public Pageable<Map<String, Object>> getRepairList(EnterpriseInfo ei, String statusType,
                                                       Page page) {
		return centerRepairDao.getRepairList(ei,statusType, page);
	}

	/**
	 * @category 审核信用修复
	 * @param ei
	 */
	@Transactional
	public void saveRepairAudit(CreditInfo ci) {
		centerRepairDao.saveRepairAudit(ci);
	}

	/**
	 * @category 根据ID查询申请信息
	 * @param id
	 * @return
	 */
	public CreditInfo getCreditInfoById(String id) {
		return centerRepairDao.getCreditInfoById(id);
	}

	/**
	 * @category 获取数据状态
	 * @param dataTable
	 * @param thirdId
	 * @return
	 */
	public String getDataStatus(String dataTable, String thirdId) {
		return centerRepairDao.getDataStatus(dataTable, thirdId);
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
		return centerRepairDao.getCreditDetail(dataTable, thirdId, fieldList);
	}

	/**
	 * @category 修复信用
	 * @param ci
	 */
	public void amendRepair(CreditInfo ci) {
		centerRepairDao.amendRepair(ci);
	}

}
