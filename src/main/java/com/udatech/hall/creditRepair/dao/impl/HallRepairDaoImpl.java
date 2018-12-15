package com.udatech.hall.creditRepair.dao.impl;

import com.udatech.common.dataTrace.dao.DataTraceDao;
import com.udatech.common.dataTrace.vo.DataTraceVo;
import com.udatech.common.enmu.DataTraceItemEnum;
import com.udatech.common.enmu.DataTraceItemTypeEnum;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseRepair;
import com.udatech.hall.creditRepair.dao.HallRepairDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.utils.EscapeChar;
import com.wa.framework.utils.RandomString;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @category 信用修复（业务大厅端）
 * @author ccl
 */
@Repository
public class HallRepairDaoImpl extends BaseDaoImpl implements HallRepairDao {

	@Autowired
	private DataTraceDao dataTraceDao;

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
	public Pageable<Map<String, Object>> getRepairList(EnterpriseInfo ei,
			Page page) {
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT A.*, B.ID DETAIL_ID, B.THIRD_ID, B.DATA_TABLE, ");
		sb.append(" 	B.BJBH, B.STATUS, B.DEPT_CODE, B.DEPT_NAME, B.ZXSHYJ, D.CODE, ");
		sb.append(" 	B.ZXSHR, B.ZXSHSJ, B.BMSHYJ, B.BMSHR, B.BMSHSJ, D.DEPARTMENT_NAME BJBM  ");
		sb.append(" FROM DT_ENTERPRISE_REPAIR A ");
		sb.append(" JOIN DT_ENTERPRISE_CREDIT B ON A.ID = B.BUSINESS_ID ");
        sb.append(" JOIN SYS_USER C ON A.CREATE_ID = C.SYS_USER_ID ");
        sb.append(" JOIN SYS_DEPARTMENT D ON C.SYS_DEPARTMENT_ID = D.SYS_DEPARTMENT_ID ");
		sb.append(" WHERE 1 = 1 ");

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
	 * @category 保存修复与信用关系表
	 * @param er
	 */
	public List<String> saveCreditInfo(EnterpriseRepair er) {
		String[] dataTables = er.getDataTable();
		String[] thirdIds = er.getThirdId();
		String[] categorys = er.getCategory();
		String[] deptCodes = er.getDeptCode();
		String[] deptNames = er.getDeptName();

		List<String> bjbhs = new ArrayList<String>();
		if (dataTables != null && thirdIds != null && categorys != null
				&& deptCodes != null && deptNames != null
				&& dataTables.length == thirdIds.length
				&& dataTables.length == categorys.length
				&& dataTables.length == deptCodes.length
				&& dataTables.length == deptNames.length) {

			for (int i = 0, len = dataTables.length; i < len; i++) {
				String bjbh = getBjbh();
				bjbhs.add(bjbh);

				CreditInfo ci = new CreditInfo();
				ci.setBusinessId(er.getId());
				ci.setDataTable(dataTables[i]);
				ci.setThirdId(thirdIds[i]);
				ci.setBjbh(bjbh);
				ci.setCategory(categorys[i]);
				ci.setDeptCode(deptCodes[i]);
				ci.setDeptName(deptNames[i]);
				ci.setType("2");

				this.save(ci);

				DataTraceVo vo = new DataTraceVo();
				vo.setTableName(ci.getDataTable());
				vo.setId(ci.getThirdId());
				vo.setItem(DataTraceItemEnum.信用修复申请.getKey());
				vo.setItemType(DataTraceItemTypeEnum.信用修复.getKey());
				vo.setServiceNo(bjbh);
				dataTraceDao.saveDataTrace(vo);
			}
		}
		return bjbhs;
	}

	/**
	 * @category 获取办件编号
	 * @return
	 */
	private String getBjbh() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String bjbh = "SS" + sdf.format(new Date())
				+ new RandomString().getRandomString(5, "i");
		return bjbh;
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
	 * @category 获取修复记录
	 * @param businessId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<String> getBjbhList(String businessId) {
		Session session = getSession();
		Criteria criteria = session.createCriteria(CreditInfo.class);
		criteria.add(Restrictions.eq("businessId", businessId));
		List<CreditInfo> list = criteria.list();
		List<String> bjbhList = new ArrayList<String>();
		if (list != null && !list.isEmpty()) {
			for (CreditInfo ci : list) {
				bjbhList.add(ci.getBjbh());
			}
		}
		return bjbhList;
	}

}
