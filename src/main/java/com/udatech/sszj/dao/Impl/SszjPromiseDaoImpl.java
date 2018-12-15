package com.udatech.sszj.dao.Impl;

import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.model.CreditCommitmentQy;
import com.udatech.common.model.Promise;
import com.udatech.common.model.PromiseEnter;
import com.udatech.common.promise.dao.PromiseDao;
import com.udatech.sszj.dao.SszjPromiseDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @category 信用承诺
 * @author ccl
 */
@Repository
public class SszjPromiseDaoImpl extends BaseDaoImpl implements SszjPromiseDao {
	
	@Autowired
	private CreditCommonDao creditCommonDao;
	
	/**
	 * @category 获取信用承诺列表
	 * @param page
	 * @param promise
	 * @return
	 */
	@Override
	public Pageable<Map<String, Object>> getPromiseList(Page page,
			Promise promise) {

		StringBuilder countSb = new StringBuilder();
		StringBuilder listSb = new StringBuilder();
		Map<String, Object> params = new HashMap<String, Object>();

		// 列表sql
		listSb.append(" SELECT A.ID, C.DICT_KEY, C.DICT_VALUE, D.DEPARTMENT_NAME DEPT_NAME,          ");
		listSb.append("        TO_CHAR(A.UPDATE_TIME, 'YYYY-MM-DD HH24:MI:SS') UPDATE_TIME, A.DEPT_ID, ");
		listSb.append("        CASE WHEN E.QY_COUNT IS NULL THEN 0 ELSE E.QY_COUNT END QY_COUNT      ");
		listSb.append(" FROM SSZJ_CREDIT_COMMITMENT A                                                  ");
		listSb.append(" LEFT JOIN SYS_DICTIONARY_GROUP B ON B.GROUP_KEY = 'cnlb'                     ");
		listSb.append(" LEFT JOIN SYS_DICTIONARY C ON B.ID = C.GROUP_ID AND A.CNLB = C.DICT_KEY      ");
		listSb.append(" LEFT JOIN SYS_DEPARTMENT D ON A.DEPT_ID = D.SYS_DEPARTMENT_ID                ");
		listSb.append(" LEFT JOIN (                                                                  ");
		listSb.append("      SELECT CNLB, DEPT_ID, COUNT(*) QY_COUNT FROM SSZJ_CREDIT_COMMITMENT_QY    ");
		listSb.append("      GROUP BY CNLB, DEPT_ID                                                  ");
		listSb.append(" ) E ON A.CNLB = E.CNLB AND A.DEPT_ID = E.DEPT_ID                             ");
		listSb.append(" WHERE 1 = 1                                                                  ");

		// 承诺类别
		String deptId = promise.getDeptId();
		if (StringUtils.isNotBlank(deptId)) {
			listSb.append(" AND A.DEPT_ID = :deptId ");
			params.put("deptId", deptId);
		}

		// 部门条件
		String cnlbKey = promise.getCnlbKey();
		if (StringUtils.isNotBlank(cnlbKey)) {
			listSb.append(" AND C.DICT_KEY = :cnlbKey ");
			params.put("cnlbKey", cnlbKey);
		}

		countSb.append("SELECT COUNT(*) FROM ( ");
		countSb.append(listSb.toString());
		countSb.append(") A ");

		// 排序
		listSb.append(" ORDER BY D.CODE, C.DICT_KEY ");

		// 执行查询
		return this.findBySqlWithPage(listSb.toString(), countSb.toString(),
				page, params);
	}

	@Override
	public Pageable<Map<String, Object>> getSupvEnterList(
            PromiseEnter promiseEnter, Page page) {

		String cnlb = promiseEnter.getCnlb();
		String deptId = promiseEnter.getDeptId();
		String searchQymc = promiseEnter.getSearchQymc();
		String searchGszch = promiseEnter.getSearchGszch();
		String searchZzjgdm = promiseEnter.getSearchZzjgdm();
		String searchTyshxydm = promiseEnter.getSearchTyshxydm();
		String searchStatus = promiseEnter.getSearchStatus();
		String startDate = promiseEnter.getStartDate();
		String endDate = promiseEnter.getEndDate();

		Map<String, Object> parameters = new HashMap<String, Object>();
		
		String sqlHead = "";
		String sqlFoot = "";
		if (StringUtils.isNotBlank(searchStatus)) {
			sqlHead = " SELECT * FROM ( ";
			if ("2".equals(searchStatus)) {
				sqlFoot = " ) WHERE GSJZQ <= :curDate ";
			} else {
				sqlFoot = " ) WHERE STATUS = :I_STATUS AND ( GSJZQ IS NULL OR GSJZQ > :curDate ) ";
				parameters.put("I_STATUS", searchStatus);
			}
			parameters.put("curDate",
					DateUtils.format(new Date(), DateUtils.YYYYMMDD_10));
		}

		StringBuffer sb = new StringBuffer();
		sb.append(sqlHead);
		sb.append("  SELECT                                                          ");
		sb.append("      A.ID,                                                       ");
		sb.append("      A.QYMC,                                                     ");
		sb.append("      A.GSZCH,                                                    ");
		sb.append("      A.ZZJGDM,                                                   ");
		sb.append("      A.TYSHXYDM,                                                 ");
		sb.append("      D.CODE DEPT_CODE,                                			 ");
		sb.append("      D.DEPARTMENT_NAME DEPT_NAME,                                ");
		sb.append("      S.DICT_VALUE CNLB,                                          ");
		sb.append("      TO_CHAR(A.CREATE_TIME, 'YYYY-MM-DD') CREATE_TIME,           ");
		sb.append("      TO_CHAR(B.GSJZQ, 'YYYY-MM-DD') GSJZQ,                       ");
		sb.append("      NVL2(B.ID,'1','0') AS STATUS                                ");
		sb.append("  FROM (                                                          ");
		sb.append("      SELECT                                                      ");
		sb.append("          *                                                       ");
		sb.append("      FROM                                                        ");
		sb.append("          SSJC_CREDIT_COMMITMENT_QY                                 ");
		sb.append("      WHERE 1=1                                                   ");
		
		if (StringUtils.isNotBlank(cnlb)) {
			sb.append("   AND  CNLB = :I_CNLB                                        ");
			parameters.put("I_CNLB", cnlb);
		}
		
		if (StringUtils.isNotBlank(deptId)) {
			sb.append("          AND DEPT_ID = :I_DEPT_ID                            ");
			parameters.put("I_DEPT_ID", deptId);
		}

		if (StringUtils.isNotBlank(searchQymc)) {
			sb.append(" AND QYMC LIKE :I_QYMC ");
			searchQymc = "%" + EscapeChar.escape(searchQymc) + "%";
			parameters.put("I_QYMC", searchQymc);
		}
		if (StringUtils.isNotBlank(searchGszch)) {
			sb.append(" AND GSZCH LIKE :I_GSZCH ");
			searchGszch = "%" + EscapeChar.escape(searchGszch) + "%";
			parameters.put("I_GSZCH", searchGszch);
		}
		if (StringUtils.isNotBlank(searchZzjgdm)) {
			sb.append(" AND ZZJGDM LIKE :I_ZZJGDM ");
			searchZzjgdm = "%" + EscapeChar.escape(searchZzjgdm) + "%";
			parameters.put("I_ZZJGDM", searchZzjgdm);
		}
		if (StringUtils.isNotBlank(searchTyshxydm)) {
			sb.append(" AND TYSHXYDM LIKE :I_TYSHXYDM ");
			searchTyshxydm = "%" + EscapeChar.escape(searchTyshxydm) + "%";
			parameters.put("I_TYSHXYDM", searchTyshxydm);
		}
		if (StringUtils.isNotBlank(startDate)) {
			sb.append(" AND TO_CHAR(CREATE_TIME, 'YYYY-MM-DD') >= :startDate ");
			parameters.put("startDate", startDate);
		}
		if (StringUtils.isNotBlank(endDate)) {
			sb.append(" AND TO_CHAR(CREATE_TIME, 'YYYY-MM-DD') <= :endDate ");
			parameters.put("endDate", endDate);
		}
		sb.append(" ORDER BY CREATE_TIME DESC NULLS LAST");
		sb.append("  ) A                                                             ");
		sb.append("  LEFT JOIN YW_L_HEIMINGDAN B                                     ");
		sb.append("  ON A.QYMC = B.JGQC                                              ");
		sb.append("  OR A.GSZCH = B.GSZCH                                            ");
		sb.append("  OR A.ZZJGDM = B.ZZJGDM                                          ");
		sb.append("  OR A.TYSHXYDM = B.TYSHXYDM                                      ");
		sb.append("  LEFT JOIN SYS_DEPARTMENT D                                      ");
		sb.append("  ON A.DEPT_ID = D.SYS_DEPARTMENT_ID                              ");
		sb.append("  LEFT JOIN (SELECT DIC.DICT_KEY, DIC.DICT_VALUE                  ");
		sb.append("  FROM SYS_DICTIONARY DIC                                         ");
		sb.append("  LEFT JOIN SYS_DICTIONARY_GROUP G                                ");
		sb.append("  ON DIC.GROUP_ID = G.ID                                      	 ");
		sb.append("  WHERE G.GROUP_KEY = 'cnlb') S                                   ");
		sb.append("  ON S.DICT_KEY = A.CNLB                            			 	 ");
		sb.append("  WHERE D.STATUS <> 1                             			 	 ");
		 
		sb.append(sqlFoot);

		sb.append("  ORDER BY DEPT_CODE,ID                            			 	 ");
		
		String countSql = "SELECT COUNT(1) FROM ( " + sb.toString() + " ) A ";

		return findBySqlWithPage(sb.toString(), countSql, page, parameters);
	}

	/**
	 * @category 更新时间
	 * @param cnlb
	 * @param deptId
	 */
	@Override
	public void updateTime(String cnlb, String deptId) {
		StringBuilder sb = new StringBuilder();
		sb.append(" UPDATE SSZJ_CREDIT_COMMITMENT SET UPDATE_TIME = SYSDATE ");
		sb.append(" WHERE CNLB = :cnlb AND DEPT_ID = :deptId ");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cnlb", cnlb);
		map.put("deptId", deptId);

		this.executeUpdateSql(sb.toString(), map);
	}

	/**
	 * @category 获取承诺根据ID
	 * @param id
	 * @return
	 */
	@Override
	public Promise getPromiseById(String id) {
		String sql = "SELECT * FROM SSZJ_CREDIT_COMMITMENT WHERE ID = :id";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);

		List<Map<String, Object>> list = this.findBySql(sql, map);

		if (list == null || list.isEmpty()) {
			sql = "SELECT * FROM SSZJ_CREDIT_COMMITMENT_QY WHERE ID = :id";
			list = this.findBySql(sql, map);
		}

		if (list != null && !list.isEmpty()) {
			map = list.get(0);
			if (map != null) {
				String cnlb = (String) map.get("CNLB");
				String deptId = (String) map.get("DEPT_ID");
				Promise p = new Promise();
				p.setCnlbKey(cnlb);
				p.setDeptId(deptId);
				return p;
			}
		}

		return null;
	}

	/**
	 * @category 移除承诺企业
	 * @param qyId
	 */
	@Override
	public void reomveEnter(String qyId) {
		String sql = "DELETE FROM SSZJ_CREDIT_COMMITMENT_QY WHERE ID = :id";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", qyId);

		this.executeUpdateSql(sql, map);
	}

	/**
	 * @category 查询企业信息
	 * @param id
	 * @return
	 */
	@Override
	public Promise getQyInfo(String id) {
		Promise p = new Promise();

		String sql = "SELECT * FROM SSZJ_CREDIT_COMMITMENT_QY WHERE ID = :id";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);

		List<Map<String, Object>> list = this.findBySql(sql, map);

		if (list != null && !list.isEmpty()) {
			map = list.get(0);
			if (map != null) {
				p.setId((String) map.get("ID"));
				p.setCnlbKey((String) map.get("CNLB"));
				p.setDeptId((String) map.get("DEPT_ID"));
				p.setQymc((String) map.get("QYMC"));
				p.setGszch((String) map.get("GSZCH"));
				p.setZzjgdm((String) map.get("ZZJGDM"));
				p.setTyshxydm((String) map.get("TYSHXYDM"));
				p.setClyj((String) map.get("CLYJ"));
				p.setYxq((String) map.get("YXQ"));
			}
		}

		return p;
	}

	/**
	 * @category 是否在黑名单中
	 * @param promise
	 * @return
	 */
	@Override
	public boolean isInBlacklist(Promise promise) {
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT COUNT(*) FROM SSZJ_CREDIT_COMMITMENT_QY A ");
		sb.append(" JOIN YW_L_HEIMINGDAN B ON  A.ID = :id ");
		sb.append(" AND ( A.QYMC = B.JGQC OR A.GSZCH = B.GSZCH OR A.ZZJGDM = B.ZZJGDM OR A.TYSHXYDM = B.TYSHXYDM ) ");

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", promise.getId());

		long count = this.countBySql(sb.toString(), params);

		return count > 0;
	}

	/**
	 * @category 保存处理
	 * @param promise
	 */
	@Override
	public void savePromiseQyHandle(Promise promise, SysDepartment dept) {
		StringBuilder sb = new StringBuilder();
		sb.append(" UPDATE SSZJ_CREDIT_COMMITMENT_QY SET CLYJ = :clyj, YXQ = :yxq ");
		sb.append(" WHERE ID = :id ");

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", promise.getId());
		params.put("clyj", promise.getClyj());
		params.put("yxq", promise.getYxq());

		this.executeUpdateSql(sb.toString(), params);

		promise = getQyInfo(promise.getId());

		sb = new StringBuilder();
		sb.append(" INSERT INTO YW_L_HEIMINGDAN (ID, STATUS, CREATE_TIME, TGRQ, JGQC, GSZCH, ZZJGDM, TYSHXYDM, ZYSXSS, GSJZQ, BMBM, BMMC, JGDJ_ID, QRYZSXRQ) ");
		sb.append(" VALUES ( SYS_GUID(), '1', SYSDATE, SYSDATE, :qymc, :gszch, :zzjgdm, :tyshxydm, :zysxss, :gsjzq, :bmbm, :bmmc, :jgdjId, :rq) ");

		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);

		if ("1".equals(promise.getYxq())) {
			calendar.set(Calendar.YEAR, year + 1);
		} else if ("2".equals(promise.getYxq())) {
			calendar.set(Calendar.YEAR, year + 2);
		} else if ("3".equals(promise.getYxq())) {
			calendar.set(Calendar.YEAR, year + 3);
		}

		params = new HashMap<String, Object>();
		params.put("qymc", promise.getQymc());

		String gszch = promise.getGszch();
		if (StringUtils.isBlank(gszch)) {
			gszch = "";
		}
		params.put("gszch", gszch);

		String zzjgdm = promise.getZzjgdm();
		if (StringUtils.isBlank(zzjgdm)) {
			zzjgdm = "";
		}
		params.put("zzjgdm", zzjgdm);

		String tyshxydm = promise.getTyshxydm();
		if (StringUtils.isBlank(tyshxydm)) {
			tyshxydm = "";
		}
		params.put("tyshxydm", tyshxydm);

		String jgdjId = creditCommonDao.getEnterpriseId(gszch, zzjgdm, tyshxydm);
		if (StringUtils.isBlank(jgdjId)) {
			jgdjId = "";
		}
		
		params.put("jgdjId", jgdjId);
		
		params.put("rq", DateUtils.parseDate(DateUtils.format(new Date(), DateUtils.YYYYMMDD_10), DateUtils.YYYYMMDD_10));
		
		params.put("zysxss", promise.getClyj());
		params.put("gsjzq", calendar.getTime());
		params.put("bmbm", dept.getCode());
		params.put("bmmc", dept.getDepartmentName());

		this.executeUpdateSql(sb.toString(), params);
	}

    @Override
    public boolean isExistInDB(CreditCommitmentQy creditCommitmentQy) {
		// 是否存在于数据库
		String qymc = creditCommitmentQy.getQymc();
		String zzjgdm = creditCommitmentQy.getZzjgdm();
		String gszch = creditCommitmentQy.getGszch();
		String tyshxydm = creditCommitmentQy.getTyshxydm();
		String sql = "SELECT * FROM SSZJ_CREDIT_COMMITMENT_QY WHERE CNLB = :I_CNLB AND DEPT_ID = :I_DEPT_ID ";
		Map<String, Object> parameters = new HashMap<>();
		parameters.put("I_CNLB", creditCommitmentQy.getCnlb());
		parameters.put("I_DEPT_ID", creditCommitmentQy.getDeptId());

		String whereSql = "";
		if (StringUtils.isNotBlank(gszch)) {
			whereSql += " or GSZCH = :I_GSZCH ";
			parameters.put("I_GSZCH", gszch);
		}
		if (StringUtils.isNotBlank(zzjgdm)) {
			whereSql += " or ZZJGDM = :I_ZZJGDM ";
			parameters.put("I_ZZJGDM", zzjgdm);
		}
		if (StringUtils.isNotBlank(tyshxydm)) {
			whereSql += " or TYSHXYDM = :I_TYSHXYDM ";
			parameters.put("I_TYSHXYDM", tyshxydm);
		}
		whereSql = StringUtils.replace(whereSql, "or", "", 1);

		sql += " AND (" + whereSql + " ) ";

		List<Map<String, Object>> resList = this.findBySql(sql, parameters);
		return resList != null && resList.size() > 0;
	}

}
