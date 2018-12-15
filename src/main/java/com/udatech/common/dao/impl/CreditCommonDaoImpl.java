package com.udatech.common.dao.impl;

import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.ObjectionEnmu;
import com.udatech.common.enmu.RepairEnmu;
import com.udatech.common.enmu.TableEnmu;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.EnterpriseBaseInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.util.PropUtil;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.QueryConditions;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.utils.EscapeChar;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.SQLQuery;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.io.File;
import java.io.IOException;
import java.util.*;

@Repository
public class CreditCommonDaoImpl extends BaseDaoImpl implements CreditCommonDao {

	/**
	 * <描述>: 查询指定序列的下一个值
	 *
	 * @author 作者：lijj
	 * @version 创建时间：2016年7月12日上午10:35:33
	 * @param sequenceName
	 *            序列名
	 * @return
	 */
	@Override
	public String getSequenceNextValue(String sequenceName) {
		String sql = "select " + sequenceName + ".nextval from dual";
		return this.findBySql(sql).get(0).get("NEXTVAL").toString();
	}

	/**
	 * @category 获取企业信息
	 * @param info
	 * @return
	 */
	@Override
	@SuppressWarnings("unchecked")
	public EnterpriseInfo getEnterpriseInfo(EnterpriseInfo info) {
		String sql = "SELECT * FROM YW_L_JGSLBGDJ A WHERE A.JGQC = :jgqc ";
		sql += "OR A.GSZCH = :gszch OR A.ZZJGDM = :zzjgdm OR A.TYSHXYDM = :tyshxydm ";

		SQLQuery query = this.getSession().createSQLQuery(sql);

		query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setString("jgqc", info.getJgqc());
		query.setString("gszch", info.getGszch());
		query.setString("zzjgdm", info.getZzjgdm());
		query.setString("tyshxydm", info.getTyshxydm());

		List<Map<String, Object>> list = query.list();
		if (list != null && !list.isEmpty()) {
			Map<String, Object> map = list.get(0);
			if (map != null && !map.isEmpty()) {
				info.setJgqc((String) map.get("JGQC"));
				info.setGszch((String) map.get("GSZCH"));
				info.setZzjgdm((String) map.get("ZZJGDM"));
				info.setTyshxydm((String) map.get("TYSHXYDM"));
				return info;
			}
		}

		return null;
	}

	/**
	 * @category 获取企业列表
	 * @param keyword
	 * @return
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEnterpriseList(String keyword) {
		String sql = "SELECT ID, JGQC, GSZCH, ZZJGDM, TYSHXYDM, ";
		sql += " JGQC || ' | ' || GSZCH || ' | ' || ZZJGDM || ' | ' || TYSHXYDM NAME ";
		sql += " FROM YW_L_JGSLBGDJ A WHERE A.JGQC LIKE '%' || :jgqc || '%' escape '\\' ";
		sql += " OR A.GSZCH = :gszch OR A.ZZJGDM = :zzjgdm OR A.TYSHXYDM = :tyshxydm ";

		System.out.println(sql);

		SQLQuery query = this.getSession().createSQLQuery(sql);

		query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setString("jgqc", EscapeChar.escape(keyword));
		query.setString("gszch", keyword);
		query.setString("zzjgdm", keyword);
		query.setString("tyshxydm", keyword);
		query.setFirstResult(0);
		query.setFetchSize(6);
		query.setMaxResults(6);

		List<Map<String, Object>> list = query.list();

		return list;
	}

	/**
	 * @Description: 保存上传文件
	 * @param names
	 * @param paths
	 * @param type
	 * @param createUser
	 * @param businessId
	 * @return: void
	 */
	@Override
	public void saveUploadFiles(String[] names, String[] paths,
								UploadFileEnmu type, String userId, String businessId) {
		if (names != null && paths != null && names.length == paths.length) {
			for (int i = 0, len = names.length; i < len; i++) {
				String name = names[i], path = paths[i];
				path = copyFileFromTemp(path);

				String icon = "";
				if (StringUtils.isNotBlank(name)) {
					int index = name.lastIndexOf(".");
					if (index >= 0) {
						String suffix = name.substring(index);
						icon = com.udatech.common.util.FileUtils
								.getIcon(suffix);
						icon = "/app/images/icon/" + icon;
					}
				}

				UploadFile uploadFile = new UploadFile();
				uploadFile.setUploadFileId(UUID.randomUUID().toString());
				uploadFile.setFileName(name);
				uploadFile.setFilePath(path);
				uploadFile.setFileType(type.getKey());
				uploadFile.setCreateDate(new Date());
				uploadFile.setCreateUser(new SysUser(userId));
				uploadFile.setBusinessId(businessId);
				uploadFile.setIcon(icon);
				this.save(uploadFile);
			}
		}
	}

	/**
	 * @Title: copyFileFromTemp
	 * @Description: 从临时目录拷贝文件到文件目录
	 * @param path
	 * @return
	 * @return: String
	 */
	private String copyFileFromTemp(String path) {
		if (StringUtils.isNotBlank(path)) {
			File srcFile = new File(path);

			String filePath = PropUtil.get("upload.file.path");
			File file = new File(filePath);
			if (!file.exists()) {
				file.mkdirs();
			}

			path = path.replaceAll("\\\\", "/");
			int index = path.lastIndexOf("/");
			String fileName = path.substring(index + 1);
			path = filePath + "/" + fileName;
			File destFile = new File(path);

			try {
				FileUtils.copyFile(srcFile, destFile);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return path;
	}

	/**
	 * @category 获取上传文件列表
	 * @param id
	 * @param type
	 * @return
	 */
	@Override
	public List<UploadFile> getUploadFiles(String id, UploadFileEnmu type) {
	    QueryConditions query = new QueryConditions();
        query.addEq("businessId",id);
        query.addEq("fileType", type.getKey());
        List<UploadFile> list = this.find(UploadFile.class, query);
        return list;
	}

	/**
	 * @category 获取信用信息
	 * @param info
	 * @param page
	 * @return
	 */
	@Override
	public Pageable<Map<String, Object>> getCreditInfo(EnterpriseInfo ei,
			Page page) {

		String jgqc = ei.getJgqc();
		String zzjgdm = ei.getZzjgdm();
		String gszch = ei.getGszch();
		String tyshxydm = ei.getTyshxydm();
		String dataTable = ei.getDataTable();
		String businessId = ei.getBusinessId();
		String columns = ei.getFieldColumns();
		String type = ei.getType();

		if (StringUtils.isBlank(columns)) {
			return new SimplePageable<Map<String, Object>>();
		}

		Map<String, Object> params = new HashMap<String, Object>();

		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT ").append(columns);
		sb.append(" FROM ").append(dataTable);
		sb.append(" WHERE ( JGQC = :jgqc OR ZZJGDM = :zzjgdm ");
		sb.append(" OR GSZCH = :gszch ");
		sb.append(" OR TYSHXYDM = :tyshxydm ) ");

		if ("1".equals(type)) { // 申请时过滤已修复已删除的记录
			sb.append(" AND STATUS != 2 AND STATUS != 3  ");
		}

		if (StringUtils.isNotBlank(businessId)) {
			sb.append(" AND ID IN ( ");
			sb.append(" 	SELECT THIRD_ID FROM DT_ENTERPRISE_CREDIT ");
			sb.append(" 	WHERE DATA_TABLE = :dataTable AND BUSINESS_ID = :businessId ");
			sb.append(" ) ");
			params.put("dataTable", dataTable);
			params.put("businessId", businessId);
		}

		String querySql = sb.toString();
		String countSql = "SELECT COUNT(1) FROM (" + querySql + ") A";

		if (StringUtils.isBlank(jgqc)) {
			jgqc = "";
		}
		if (StringUtils.isBlank(zzjgdm)) {
			zzjgdm = "";
		}
		if (StringUtils.isBlank(gszch)) {
			gszch = "";
		}
		if (StringUtils.isBlank(tyshxydm)) {
			tyshxydm = "";
		}
		params.put("jgqc", jgqc);
		params.put("zzjgdm", zzjgdm);
		params.put("gszch", gszch);
		params.put("tyshxydm", tyshxydm);

		return this.findBySqlWithPage(querySql, countSql, page, params);
	}

	/**
	 * @category 获取异议中的数据
	 * @return
	 */
	@Override
	public Map<String, List<String>> getObjectionData(String qymc,
			String zzjgdm, String gszch, String tyshxydm) {
		Map<String, List<String>> resMap = new HashMap<String, List<String>>();

		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT A.DATA_TABLE, A.THIRD_ID FROM DT_ENTERPRISE_CREDIT A ");
		sb.append(" JOIN DT_ENTERPRISE_OBJECTION B ON A.BUSINESS_ID = B.ID ");
		sb.append(" WHERE A.STATUS != :status AND  A.STATUS != :status2");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("status", ObjectionEnmu.已完成.getKey());
		params.put("status2", ObjectionEnmu.未通过.getKey());

		String sql = sb.toString();
		String where_sql = "";
		// 查询参数
		if (StringUtils.isNotBlank(zzjgdm)) {
			where_sql += " or B.ZZJGDM = :zzjgdm ";
			params.put("zzjgdm", zzjgdm);
		}
		if (StringUtils.isNotBlank(qymc)) {
			where_sql += " or B.QYMC = :qymc ";
			params.put("qymc", qymc);
		}
		if (StringUtils.isNotBlank(gszch)) {
			where_sql += " or B.GSZCH = :gszch ";
			params.put("gszch", gszch);
		}
		if (StringUtils.isNotBlank(tyshxydm)) {
			where_sql += " or B.TYSHXYDM = :shxydm ";
			params.put("shxydm", tyshxydm);
		}
		// 拼接条件
		if (where_sql.length() > 0) {
			where_sql = where_sql.trim();
			where_sql = where_sql.substring(where_sql.indexOf("or") + 2);
			where_sql = " and (" + where_sql + ")";
		}
		sql += where_sql;
		List<Map<String, Object>> result = findBySql(sql, params);

		if (result != null && !result.isEmpty()) {
			for (Map<String, Object> map : result) {
				String tableName = (String) map.get("DATA_TABLE");
				String thirdId = (String) map.get("THIRD_ID");
				if (StringUtils.isNotBlank(thirdId)
						&& StringUtils.isNotBlank(tableName)) {
					List<String> ls = resMap.get(tableName);
					if (ls == null) {
						ls = new LinkedList<String>();
					}
					ls.add(thirdId);
					resMap.put(tableName, ls);
				}
			}
		}
		return resMap;
	}

	/**
	 * @param string4
	 * @param string3
	 * @param string2
	 * @param string
	 * @category 获取修复中的数据（信用修复中需要修复但尚未修复的数据）
	 * @return
	 */
	public Map<String, List<String>> getRepairData(String qymc, String zzjgdm, String gszch, String tyshxydm) {
        Map<String, List<String>> resMap = new HashMap<String, List<String>>();

        StringBuilder sb = new StringBuilder();
        sb.append(" SELECT A.DATA_TABLE, A.THIRD_ID FROM DT_ENTERPRISE_CREDIT A ");
        sb.append(" JOIN DT_ENTERPRISE_REPAIR B ON A.BUSINESS_ID = B.ID ");
        sb.append(" WHERE A.STATUS != :status AND  A.STATUS != :status2");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("status", RepairEnmu.已完成.getKey());
        params.put("status2", RepairEnmu.未通过.getKey());

        String sql = sb.toString();
        String where_sql = "";
        // 查询参数
        if (StringUtils.isNotBlank(zzjgdm)) {
            where_sql += " or B.ZZJGDM = :zzjgdm ";
            params.put("zzjgdm", zzjgdm);
        }
        if (StringUtils.isNotBlank(qymc)) {
            where_sql += " or B.QYMC = :qymc ";
            params.put("qymc", qymc);
        }
        if (StringUtils.isNotBlank(gszch)) {
            where_sql += " or B.GSZCH = :gszch ";
            params.put("gszch", gszch);
        }
        if (StringUtils.isNotBlank(tyshxydm)) {
            where_sql += " or B.TYSHXYDM = :shxydm ";
            params.put("shxydm", tyshxydm);
        }
        // 拼接条件
        if (where_sql.length() > 0) {
            where_sql = where_sql.trim();
            where_sql = where_sql.substring(where_sql.indexOf("or") + 2);
            where_sql = " and (" + where_sql + ")";
        }
        sql += where_sql;
        List<Map<String, Object>> result = findBySql(sql, params);

        if (result != null && !result.isEmpty()) {
            for (Map<String, Object> map : result) {
                String tableName = (String) map.get("DATA_TABLE");
                String thirdId = (String) map.get("THIRD_ID");
                if (StringUtils.isNotBlank(thirdId)
                        && StringUtils.isNotBlank(tableName)) {
                    List<String> ls = resMap.get(tableName);
                    if (ls == null) {
                        ls = new LinkedList<String>();
                    }
                    ls.add(thirdId);
                    resMap.put(tableName, ls);
                }
            }
        }
        return resMap;
	}

	@Override
	public Map<String, Object> getPersonInfo(String sfzh) {
		String sql = " SELECT XM,SFZH,LXDH, XM || ' | ' || SFZH NAME FROM YW_P_GRJBXX WHERE SFZH = :sfzh";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sfzh", sfzh);
		return this.uniqueBySql(sql, params);
	}

	@Override
	public List<Map<String, Object>> getAllIndustryCode() {
		String sql = "SELECT DISTINCT GB_NAME, GB_CODE FROM INDUSTRY_CODE_RELATION ORDER BY GB_CODE ASC ";
		List<Map<String, Object>> resMap = this.findBySql(sql.toString());
		return resMap;
	}

	@Override
	public Map<String, Object> getEnterDetail(String tyshxydm, String gszch,
			String zzjgdm, String qymc) {
		Map<String, Object> resMap = new HashMap<>();
		String sql = "SELECT * FROM YW_L_JGSLBGDJ WHERE 1=1 ";
		StringBuffer sqlWhere = new StringBuffer();
		Map<String, Object> parameters = new HashMap<>();
		if (StringUtils.isNotBlank(tyshxydm)) {
			sqlWhere.append("AND TYSHXYDM = :I_SHXYDM ");
			parameters.put("I_SHXYDM", tyshxydm);
		}
		if (StringUtils.isNotBlank(gszch)) {
			sqlWhere.append("AND GSZCH = :I_GSZCH ");
			parameters.put("I_GSZCH", gszch);
		}
		if (StringUtils.isNotBlank(zzjgdm)) {
			sqlWhere.append("AND ZZJGDM = :I_ZZJGDM ");
			parameters.put("I_ZZJGDM", zzjgdm);
		}
		if (StringUtils.isNotBlank(qymc)) {
			sqlWhere.append("AND JGQC = :I_QYMC ");
			parameters.put("I_QYMC", qymc);
		}
//		String sql_where = StringUtils.trim(sqlWhere.toString());
//		if (sql_where.length() > 0) {
//			sql_where = sql_where.substring(sql_where.indexOf("OR") + 2);
//			sql_where = " AND (" + sql_where + ")";
//		}
//		sql += sql_where;
		List<Map<String, Object>> list = this.findBySql(sql + sqlWhere.toString(), parameters);
		if (null != list && list.size() > 0) {
			resMap = list.get(0);
		}
		return resMap;
	}

	@Override
	public Map<String, Object> findLegalPersonInfo(String id) {
		String sql = "SELECT * FROM YW_L_JGSLBGDJ WHERE ID = :I_ID ";
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("I_ID", id);
		return findBySql(sql, parameters).get(0);
	}

	@Override
	public Pageable<Map<String, Object>> getEnterpriseBaseInfo(
			EnterpriseBaseInfo info, Page page) {
		String qymc = info.getJgqc();
		String zzjgdm = info.getZzjgdm();
		String gszch = info.getGszch();
		String tyshxydm = info.getTyshxydm();
		String tableKey = info.getTableKey();

		String tableName = TableEnmu.getValue(tableKey);
		if (StringUtils.isBlank(tableName)) {
			return new SimplePageable<Map<String, Object>>();
		}

		Map<String, Object> params = new HashMap<String, Object>();

		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT * FROM ").append(tableName);
		sb.append(" WHERE ( ZZJGDM = :zzjgdm ");
		sb.append(" OR GSZCH = :gszch ");
		sb.append(" OR JGQC = :qymc ");
		sb.append(" OR TYSHXYDM = :tyshxydm ) ");
		// 过滤已删除的记录
		sb.append(" AND STATUS != 3  ");
		String querySql = sb.toString();
		String countSql = "SELECT COUNT(1) FROM (" + querySql + ") A";

		if (StringUtils.isBlank(qymc)) {
			qymc = "";
		}
		if (StringUtils.isBlank(zzjgdm)) {
			zzjgdm = "";
		}
		if (StringUtils.isBlank(gszch)) {
			gszch = "";
		}
		if (StringUtils.isBlank(tyshxydm)) {
			tyshxydm = "";
		}
		params.put("qymc", qymc);
		params.put("zzjgdm", zzjgdm);
		params.put("gszch", gszch);
		params.put("tyshxydm", tyshxydm);

		return this.findBySqlWithPage(querySql, countSql, page, params);
	}

	/**
	 * @category 获取法人基本信息ID
	 * @param jgqc
	 * @param gszch
	 * @param zzjgdm
	 * @param tyshxydm
	 * @return
	 */
	public String getEnterpriseId(String gszch, String zzjgdm,
			String tyshxydm) {
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT ID FROM YW_L_JGSLBGDJ WHERE ( 1=2 ");

		Map<String, Object> params = new HashMap<String, Object>();

		if (StringUtils.isNotBlank(gszch)) {
			sb.append(" OR GSZCH = :gszch ");
			params.put("gszch", gszch);
		}

		if (StringUtils.isNotBlank(zzjgdm)) {
			sb.append(" OR ZZJGDM = :zzjgdm ");
			params.put("zzjgdm", zzjgdm);
		}

		if (StringUtils.isNotBlank(tyshxydm)) {
			sb.append(" OR TYSHXYDM = :tyshxydm ");
			params.put("tyshxydm", tyshxydm);
		}

		sb.append(" ) ");
		
		Map<String, Object> map = this.uniqueBySql(sb.toString(), params);

		if (map != null) {
			return (String) map.get("ID");
		}

		return null;
	}

    @Override
    public String getPersonId(String sfzh) {
        StringBuilder sb = new StringBuilder();
        sb.append(" SELECT ID FROM YW_P_GRJBXX WHERE SFZH = :sfzh ");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("sfzh", sfzh);
        Map<String, Object> map = this.uniqueBySql(sb.toString(), params);
        if (map != null) {
            return (String) map.get("ID");
        }
        return null;
    }

    @Override
    public Map<String, Object> findPeopleInfo(String sfzh) {
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT * FROM YW_P_GRJBXX WHERE SFZH = :I_SFZH ");
		Map<String, Object> params = new HashMap<>();
		params.put("I_SFZH", sfzh);
		Map<String, Object> map = this.uniqueBySql(sb.toString(), params);
		return map;
    }

	@Override
	public Pageable<Map<String, Object>> getCreditInfo(String sfzh, String tableName, Page page) {
		Map<String, Object> params = new HashMap<>();

		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT * FROM ").append(tableName);
		sb.append(" WHERE SFZH = :sfzh AND STATUS != 3 ");// 过滤已删除的记录
		String querySql = sb.toString();
		String countSql = "SELECT COUNT(1) FROM (" + querySql + ") A";

		if (org.apache.commons.lang3.StringUtils.isBlank(sfzh)) {
			sfzh = "";
		}
		params.put("sfzh", sfzh);
		querySql += " ORDER BY TGRQ , ID ";
		return this.findBySqlWithPage(querySql, countSql, page, params);
	}

	@Override
	public String findPeopleZymc(String sfzh) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("   SELECT                                              ");
		sqlBuilder.append("     REPLACE(WM_CONCAT(ZYMC), ',', '、') AS ZYMC       ");
		sqlBuilder.append("   FROM                                                ");
		sqlBuilder.append("     YW_P_GRZYHZXX                                     ");
		sqlBuilder.append("   WHERE                                               ");
		sqlBuilder.append("     SFZH = :I_SFZH                                    ");
		sqlBuilder.append("   GROUP BY                                            ");
		sqlBuilder.append("     SFZH                                              ");
		Map<String, Object> params = new HashMap<>();
		params.put("I_SFZH", sfzh);
		Map<String, Object> resMap = this.uniqueBySql(sqlBuilder.toString(), params);
		return MapUtils.getString(resMap, "ZYMC", "");
	}

    @Override
    public UploadFile getUploadFileByFilePath(String filePath) {
		StringBuilder sql = new StringBuilder();
		sql.append("  SELECT * FROM DT_UPLOAD_FILE T WHERE T.FILE_PATH = :I_FILE_PATH ");
		Map<String, Object> param = new HashMap<>();
		param.put("I_FILE_PATH", filePath);
		List<UploadFile> resList = this.findBySql(sql.toString(), param, UploadFile.class);
        return resList.size() > 0 ? resList.get(0) : null;
	}

	/**
	 * @category 根据key查询用户
	 * @param caKey
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public SysUser getUserByKey(String caKey) {
		Criteria criteria = getSession().createCriteria(SysUser.class);
		criteria.add(Restrictions.eq("caKey", caKey));
		List<SysUser> list = criteria.list();
		if (list != null && !list.isEmpty()) {
			return list.get(0);
		}
		return null;
	}

    @Override
    public List<Map<String, Object>> getEnterCreditData(String dataId, String type) {
		String sql =
				" SELECT * FROM DT_ENTERPRISE_CREDIT T WHERE T.TYPE = :I_TYPE AND T.STATUS IN ('0', '1') AND T.THIRD_ID = :I_DATAID";
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("I_TYPE", type);
		paramMap.put("I_DATAID", dataId);
        return this.findBySql(sql, paramMap);
    }
    
    @Override
    public List<Map<String, Object>> getErrorCode() {
        String sql = "SELECT DISTINCT ERROR_CODE, ERROR_DESC FROM ETL_ERROR_CODE ORDER BY ERROR_DESC ASC ";
        List<Map<String, Object>> resMap = this.findBySql(sql.toString());
        return resMap;
    }

	@Override
	public int addDpProcessProcedureLog(String dealType, String taskCode, Date startTime, Date endTime) {
		StringBuilder sql = new StringBuilder();
		sql.append(" insert into dp_process_procedure_log(id,deal_type,task_code,start_time");
		if (endTime != null) {
			sql.append(",end_time");
		}
		sql.append(")values(SYS_GUID(), :dealType, :taskCode, :startTime");
		if (endTime != null) {
			sql.append(", :endTime");
		}
		sql.append(") ");
		Map<String, Object> params = new HashMap<>();
		params.put("dealType", dealType);
		params.put("taskCode", taskCode);
		params.put("startTime", startTime);
		params.put("endTime", endTime);
		return this.executeUpdateSql(sql.toString(), params);
	}

	/**
	 * @Description: 更新数据处理日志
	 * @param: @param dealType 处理类别 1-数据上报 2-规则校验 3-关联入库
	 * @param: @param taskCode
	 * @param: @param endTime
	 * @param: @return
	 * @return: int
	 * @throws
	 * @since JDK 1.7.0_79
	 */
	@Override
	public int updateDpProcessProcedureLog(String dealType, String taskCode,  Date endTime) {
		StringBuilder sql = new StringBuilder();
		sql.append(" update dp_process_procedure_log set end_time=:endTime ");
		sql.append("  where deal_Type=:dealType and task_code=:taskCode");
		Map<String, Object> params = new HashMap<>();
		params.put("dealType", dealType);
		params.put("taskCode", taskCode);
		params.put("endTime", endTime);
		return this.executeUpdateSql(sql.toString(), params);
	}

}
