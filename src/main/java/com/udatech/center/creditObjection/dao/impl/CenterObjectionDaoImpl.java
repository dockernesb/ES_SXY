package com.udatech.center.creditObjection.dao.impl;

import com.udatech.center.creditObjection.dao.CenterObjectionDao;
import com.udatech.common.dataTrace.dao.DataTraceDao;
import com.udatech.common.dataTrace.vo.DataTraceVo;
import com.udatech.common.enmu.CreditDataStatusEnum;
import com.udatech.common.enmu.DataTraceItemEnum;
import com.udatech.common.enmu.DataTraceItemTypeEnum;
import com.udatech.common.enmu.ObjectionEnmu;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseObjection;
import com.udatech.common.model.FieldInfo;
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

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @category 信用异议（中心端）
 * @author ccl
 */
@Repository
public class CenterObjectionDaoImpl extends BaseDaoImpl implements
        CenterObjectionDao {

	@Autowired
	private DataTraceDao dataTraceDao;

	/**
	 * @category 根据ID获取异议申诉
	 * @param id
	 * @return
	 */
	public EnterpriseObjection getObjectionById(String id) {
		Session session = getSession();
		Criteria criteria = session.createCriteria(EnterpriseObjection.class);
		criteria.add(Restrictions.eq("id", id));
		EnterpriseObjection eo = (EnterpriseObjection) criteria.uniqueResult();
		return eo;
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
	 * @category 获取异议申诉列表
	 * @param ei
	 * @param page
	 * @return
	 */
	public Pageable<Map<String, Object>> getObjectionList(EnterpriseInfo ei, String statusType,
                                                          Page page) {
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT A.*, B.ID DETAIL_ID, B.THIRD_ID, B.DATA_TABLE, ");
		sb.append(" 	B.BJBH, B.STATUS, B.DEPT_CODE, B.DEPT_NAME, B.ZXSHYJ, D.CODE, ");
		sb.append(" 	B.ZXSHR, B.ZXSHSJ, B.BMSHYJ, B.BMSHR, B.BMSHSJ, B.CATEGORY, D.DEPARTMENT_NAME BJBM ");
		sb.append(" FROM DT_ENTERPRISE_OBJECTION A ");
		sb.append(" JOIN DT_ENTERPRISE_CREDIT B ON A.ID = B.BUSINESS_ID ");
		sb.append(" JOIN SYS_USER C ON A.CREATE_ID = C.SYS_USER_ID ");
		sb.append(" JOIN SYS_DEPARTMENT D ON C.SYS_DEPARTMENT_ID = D.SYS_DEPARTMENT_ID ");
		sb.append(" WHERE 1 = 1 ");

		if("0".equals(statusType)){
		    sb.append(" and B.STATUS=0 ");
		}else if ("2".equals(statusType)){
		    sb.append(" and B.STATUS=2 ");
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
	 * @category 审核异议申诉
	 * @param ei
	 */
	public void saveObjectionAudit(CreditInfo ci) {
		String id = ci.getId();
		CreditInfo old = this.get(CreditInfo.class, id);
		if (old != null) {
			old.setStatus(ci.getStatus());
			old.setZxshyj(ci.getZxshyj());
			old.setZxshr(ci.getZxshr());
			old.setZxshsj(new Date());
			this.save(old);

			DataTraceVo vo = new DataTraceVo();
			vo.setTableName(old.getDataTable());
			vo.setId(old.getThirdId());
			if (ObjectionEnmu.已通过.getKey().equals(old.getStatus())) {
				vo.setItem(DataTraceItemEnum.异议申诉通过待修正.getKey());
			} else if (ObjectionEnmu.未通过.getKey().equals(old.getStatus())) {
				vo.setItem(DataTraceItemEnum.异议申诉审核未通过.getKey());
			} else if (ObjectionEnmu.待核实.getKey().equals(old.getStatus())) {
				vo.setItem(DataTraceItemEnum.异议申诉部门待核实.getKey());
			}
			vo.setItemType(DataTraceItemTypeEnum.异议申诉.getKey());
			vo.setServiceNo(old.getBjbh());
			dataTraceDao.saveDataTrace(vo);
		}
	}

	/**
	 * @category 是否是日期
	 * @param str
	 * @return
	 */
	private boolean isDate(String str) {
		Pattern pattern = Pattern.compile("^\\d{4}\\-\\d{2}-\\d{2}$");
		Matcher matcher = pattern.matcher(str);
		return matcher.matches();
	}

	/**
	 * @category 保存异议修正字段信息
	 * @param fi
	 * @param businessId异议ID
	 * @param tableKey表key通过TableEnmu获取表名
	 * @param thirdId股东信息行政处罚等表的ID
	 */
	private void saveFieldInfo(FieldInfo fi, String businessId,
                               String dataTable, String thirdId) {
		StringBuilder sb = new StringBuilder();
		sb.append(" INSERT INTO DT_ENTERPRISE_FIELD VALUES ( ");
		sb.append("'").append(UUID.randomUUID().toString()).append("', ");
		sb.append("'").append(businessId).append("', ");
		sb.append("'").append(dataTable).append("', ");
		sb.append("'").append(thirdId).append("', ");
		sb.append("'").append(fi.getLabel()).append("', ");
		sb.append("'").append(fi.getCode()).append("', ");
		sb.append("'").append(fi.getOldValue()).append("', ");
		sb.append("'").append(fi.getNewValue()).append("' ) ");
		Session session = this.getSession();
		SQLQuery query = session.createSQLQuery(sb.toString());
		query.executeUpdate();
	}

	/**
	 * @category 查看历史修正数据
	 * @param ci
	 * @return
	 */
	public List<FieldInfo> viewHistory(CreditInfo ci) {
		String sql = "SELECT * FROM DT_ENTERPRISE_FIELD WHERE BUSINESS_ID = :businessId AND THIRD_ID = :thirdId";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("businessId", ci.getBusinessId());
		params.put("thirdId", ci.getThirdId());
		List<Map<String, Object>> list = this.findBySql(sql, params);
		List<FieldInfo> fiList = new LinkedList<FieldInfo>();
		if (list != null && !list.isEmpty()) {
			for (Map<String, Object> map : list) {
				FieldInfo fi = new FieldInfo();
				fi.setLabel((String) map.get("LABEL"));
				fi.setOldValue((String) map.get("OLD_VALUE"));
				fi.setNewValue((String) map.get("NEW_VALUE"));
				fiList.add(fi);
			}
		}
		return fiList;
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
	 * @category 删除异议
	 * @param ci
	 */
	public void deleteObjection(CreditInfo ci) {
		CreditInfo old = this.get(CreditInfo.class, ci.getId());
		if (old != null) {
			old.setStatus(ObjectionEnmu.已完成.getKey());
			this.save(old);
		}

		StringBuilder sb = new StringBuilder();
		sb.append(" UPDATE ").append(ci.getDataTable());
		sb.append(" SET STATUS = '").append(CreditDataStatusEnum.已删除.getKey());
		sb.append("' WHERE ID = '").append(ci.getThirdId()).append("'");

		Session session = this.getSession();
		SQLQuery query = session.createSQLQuery(sb.toString());
		query.executeUpdate();

		DataTraceVo vo = new DataTraceVo();
		vo.setTableName(ci.getDataTable());
		vo.setId(ci.getThirdId());
		vo.setItem(DataTraceItemEnum.异议申诉删除数据.getKey());
		vo.setItemType(DataTraceItemTypeEnum.异议申诉.getKey());
		vo.setServiceNo(old.getBjbh());
		dataTraceDao.saveDataTrace(vo);
		
		vo = new DataTraceVo();
		vo.setTableName(ci.getDataTable());
		vo.setId(ci.getThirdId());
		vo.setItem(DataTraceItemEnum.数据周期结束.getKey());
		vo.setItemType(DataTraceItemTypeEnum.异议申诉.getKey());
		vo.setServiceNo(old.getBjbh());
		dataTraceDao.saveDataTrace(vo);
	}

	/**
	 * @category 修正异议
	 * @param ci
	 */
	public void amendObjection(CreditInfo ci) {
		CreditInfo old = this.get(CreditInfo.class, ci.getId());
		if (old != null) {
			old.setStatus(ObjectionEnmu.已完成.getKey());
			this.save(old);
		}

		List<FieldInfo> fieldList = ci.getFieldList();
		String dataTable = ci.getDataTable();
		String thirdId = ci.getThirdId();
		if (StringUtils.isNotBlank(dataTable) && fieldList != null
				&& !fieldList.isEmpty()) {
			StringBuilder sb = new StringBuilder();

			sb.append(" UPDATE ").append(dataTable).append(" SET ");
			for (FieldInfo fi : fieldList) {
				sb.append(fi.getCode()).append(" = ");

				String newValue = fi.getNewValue();
				if (isDate(newValue)) {
					sb.append("TO_DATE('").append(newValue);
					sb.append("', 'yyyy-mm-dd'), ");
				} else {
					sb.append("'").append(newValue).append("', ");
				}

				saveFieldInfo(fi, ci.getId(), dataTable, thirdId);
			}
			sb.append(" STATUS = '").append(CreditDataStatusEnum.已修正.getKey());
			sb.append("' WHERE ID = '").append(thirdId).append("'");

			Session session = this.getSession();
			SQLQuery query = session.createSQLQuery(sb.toString());
			query.executeUpdate();
		}
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

}
