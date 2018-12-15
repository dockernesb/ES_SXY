package com.udatech.center.creditRepair.dao.impl;

import com.udatech.center.creditRepair.dao.CenterRepairDao;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.CreditDataStatusEnum;
import com.udatech.common.enmu.ObjectionEnmu;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseRepair;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @category 信用修复（中心端）
 * @author ccl
 */
@Repository
public class CenterRepairDaoImpl extends BaseDaoImpl implements CenterRepairDao {

	@Autowired
	private CreditCommonDao commonDao;

	/**
	 * @category 根据ID获取信用修复
	 * @param id
	 * @return
	 */
	public EnterpriseRepair getRepairById(String id) {
		Session session = getSession();
		Criteria criteria = session.createCriteria(EnterpriseRepair.class);
		criteria.add(Restrictions.eq("id", id));
		EnterpriseRepair er = (EnterpriseRepair) criteria.uniqueResult();
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
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT A.*, B.ID DETAIL_ID, B.THIRD_ID, B.DATA_TABLE, ");
		sb.append(" 	B.BJBH, B.STATUS, B.DEPT_CODE, B.DEPT_NAME, B.ZXSHYJ, D.CODE, ");
		sb.append(" 	B.ZXSHR, B.ZXSHSJ, B.BMSHYJ, B.BMSHR, B.BMSHSJ, B.CATEGORY, D.DEPARTMENT_NAME BJBM ");
		sb.append(" FROM DT_ENTERPRISE_REPAIR A ");
		sb.append(" JOIN DT_ENTERPRISE_CREDIT B ON A.ID = B.BUSINESS_ID ");
		sb.append(" JOIN SYS_USER C ON A.CREATE_ID = C.SYS_USER_ID ");
		sb.append(" JOIN SYS_DEPARTMENT D ON C.SYS_DEPARTMENT_ID = D.SYS_DEPARTMENT_ID ");
		sb.append(" WHERE 1 = 1 ");

		if("2".equals(statusType)){
		    sb.append(" and B.STATUS=2 ");
		}else if ("0".equals(statusType)){
		    sb.append(" and B.STATUS=0 ");
		}
		Map<String, Object> params = new HashMap<String, Object>();

		String qymc = ei.getJgqc();
		if (StringUtils.isNotBlank(qymc)) {
			sb.append(" AND A.QYMC LIKE '%' || :qymc || '%' escape '\\' ");
			params.put("qymc", EscapeChar.escape(qymc));
		}

		String zzjgdm = ei.getZzjgdm();
		if (StringUtils.isNotBlank(zzjgdm)) {
			sb.append(" AND A.ZZJGDM LIKE '%' || :zzjgdm || '%' escape '\\' ");
			params.put("zzjgdm", EscapeChar.escape(zzjgdm));
		}

		String gszch = ei.getGszch();
		if (StringUtils.isNotBlank(gszch)) {
			sb.append(" AND A.GSZCH LIKE '%' || :gszch || '%' escape '\\' ");
			params.put("gszch", EscapeChar.escape(gszch));
		}

		String bjbh = ei.getBjbh();
		if (StringUtils.isNotBlank(bjbh)) {
			sb.append(" AND B.BJBH LIKE '%' || :bjbh || '%' escape '\\' ");
			params.put("bjbh", EscapeChar.escape(bjbh));
		}

		String tyshxydm = ei.getTyshxydm();
		if (StringUtils.isNotBlank(tyshxydm)) {
			sb.append(" AND A.TYSHXYDM LIKE '%' || :tyshxydm || '%' escape '\\' ");
			params.put("tyshxydm", EscapeChar.escape(tyshxydm));
		}

		String beginDate = ei.getBeginDate();
		if (StringUtils.isNotBlank(beginDate)) {
			sb.append(" AND TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') >= :beginDate ");
			params.put("beginDate", beginDate);
		}

		String endDate = ei.getEndDate();
		if (StringUtils.isNotBlank(endDate)) {
			sb.append(" AND TO_CHAR(A.CREATE_DATE, 'YYYY-MM-DD') <= :endDate ");
			params.put("endDate", endDate);
		}

		String status = ei.getStatus();
		if (StringUtils.isNotBlank(status)) {
			sb.append(" AND B.STATUS = :status ");
			params.put("status", status);
		}

        String bjbm = ei.getBjbm();
        if (StringUtils.isNotBlank(bjbm)) {
            sb.append(" AND C.SYS_DEPARTMENT_ID = :bjbm ");
            params.put("bjbm", bjbm);
        }

		String countSql = "SELECT COUNT(*) FROM ( " + sb.toString() + " ) ";

		sb.append(" ORDER BY B.STATUS ASC, A.CREATE_DATE DESC ");

		Pageable<Map<String, Object>> pageable = findBySqlWithPage(
				sb.toString(), countSql, page, params);

		return pageable;
	}

	/**
	 * @category 审核信用修复
	 * @param ei
	 */
	public void saveRepairAudit(CreditInfo ci) {
		String id = ci.getId();
		CreditInfo old = this.get(CreditInfo.class, id);
		if (old != null) {
			old.setStatus(ci.getStatus());
			old.setZxshyj(ci.getZxshyj());
			old.setZxshr(ci.getZxshr());
			old.setZxshsj(new Date());
			this.save(old);
		}
	}

	/**
	 * @category 根据ID查询申请信息
	 * @param id
	 * @return
	 */
	public CreditInfo getCreditInfoById(String id) {
		Session session = getSession();
		Criteria criteria = session.createCriteria(CreditInfo.class);
		criteria.add(Restrictions.eq("id", id));
		return (CreditInfo) criteria.uniqueResult();
	}

	/**
	 * @category 获取数据状态
	 * @param dataTable
	 * @param thirdId
	 * @return
	 */
	public String getDataStatus(String dataTable, String thirdId) {
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT STATUS FROM ").append(dataTable);
		sb.append(" WHERE ID = '").append(thirdId).append("'");
		SQLQuery query = getSession().createSQLQuery(sb.toString());
		return (String) query.uniqueResult();
	}

	/**
	 * @category 根据表名，记录ID，字段名查询数据
	 * @param dataTable
	 * @param thirdId
	 * @param fieldList
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCreditDetail(String dataTable,
			String thirdId, List<Map<String, Object>> fieldList) {
		if (StringUtils.isNotBlank(dataTable)
				&& StringUtils.isNotBlank(thirdId) && fieldList != null
				&& !fieldList.isEmpty()) {

			StringBuilder sb = new StringBuilder();
			sb.append(" SELECT ID ");

			for (Map<String, Object> map : fieldList) {
				String col = (String) map.get("COLUMN_NAME");
				if (StringUtils.isNotBlank(col)) {
					sb.append(", ").append(col);
				}
			}

			sb.append(" FROM ").append(dataTable);
			sb.append(" WHERE ID = :id ");

			SQLQuery query = getSession().createSQLQuery(sb.toString());
			query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
			query.setString("id", thirdId);

			Map<String, Object> result = (Map<String, Object>) query
					.uniqueResult();

			if (result != null && !result.isEmpty()) {
				for (Map<String, Object> map : fieldList) {
					String col = (String) map.get("COLUMN_NAME");
					if (StringUtils.isNotBlank(col)) {
						Object obj = result.get(col);
						map.put("DATA", obj);
					}
				}
				return fieldList;
			}

		}
		return null;
	}

	/**
	 * @category 修复信用
	 * @param ci
	 */
	public void amendRepair(CreditInfo ci) {
		CreditInfo old = this.get(CreditInfo.class, ci.getId());
		if (old != null) {
			old.setStatus(ObjectionEnmu.已完成.getKey());
			this.save(old);
		}

		String dataTable = ci.getDataTable();
		String thirdId = ci.getThirdId();
		if (StringUtils.isNotBlank(dataTable)
				&& StringUtils.isNotBlank(thirdId)) {
			StringBuilder sb = new StringBuilder();

			sb.append(" UPDATE ").append(dataTable).append(" SET ");
			sb.append(" STATUS = '").append(CreditDataStatusEnum.已修复.getKey());
			sb.append("',CREATE_TIME = SYSDATE ");
			sb.append(" WHERE ID = '").append(thirdId).append("'");

			Session session = this.getSession();
			SQLQuery query = session.createSQLQuery(sb.toString());
			query.executeUpdate();
		}
	}

}
