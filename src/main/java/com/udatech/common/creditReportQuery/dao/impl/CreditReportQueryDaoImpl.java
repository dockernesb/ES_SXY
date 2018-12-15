package com.udatech.common.creditReportQuery.dao.impl;

import com.udatech.common.creditReportQuery.dao.CreditReportQueryDao;
import com.udatech.common.enmu.CreditDataStatusEnum;
import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.common.model.PersonReportApply;
import com.udatech.common.resourceManage.vo.TemplateThemeColumn;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.DataSourceUtil;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <描述>：公共信用报告内容查询 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月6日下午3:26:45
 */
@Repository
public class CreditReportQueryDaoImpl extends BaseDaoImpl implements CreditReportQueryDao {
    /**
     * <描述>: 查询指定序列的下一个值
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日上午11:03:00
     * @param SquenceName 序列名
     * @return
     */
    public String findSquence(String SquenceName) {
        String sql = "select sq_" + SquenceName + ".nextval from dual";
        return this.findBySql(sql).get(0).get("NEXTVAL").toString();
    }

    /**
     * @category 根据ID获取信用报告申请单信息
     * @param id
     * @return
     */
    public EnterpriseReportApply getReportApplyById(String id) {
        return this.get(EnterpriseReportApply.class, id);
    }

    /**
     * <描述>: 获取企业信息, 模糊查询(xx like '%xx%')
     * @author 作者：lijj
     * @version 创建时间：2016年5月12日下午5:46:57
     * @param zzjgdm
     * @param qymc
     * @param gszch
     * @param shxydm
     * @return
     */
    public Map<String, Object> findEnterpriseInfoLike(String zzjgdm, String jgqc, String gszch, String tyshxydm) {
        String sql = " select * from YW_L_JGSLBGDJ where jgqc like :jgqc ";
        // 查询参数
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("jgqc", "%" + jgqc + "%");
        List<Map<String, Object>> list = this.findBySql(sql, parameterMap);
        if (list != null && list.size() > 0) {
            return list.get(0);
        } else {
            return null;
        }
    }

    /**
     * <描述>: 获取企业信息, 严格查询（xx=xx）
     * @author 作者：lijj
     * @version 创建时间：2016年5月12日下午5:46:57
     * @param zzjgdm
     * @param qymc
     * @param gszch
     * @param shxydm
     * @return
     */
    public Map<String, Object> findEnterpriseInfoStrict(Map<String, Object> params) {
        String sql = " select * from YW_L_JGSLBGDJ where jgqc = :jgqc  ";

        // 查询参数
        String jgqc = MapUtils.getString(params, "jgqc", "");
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("jgqc", jgqc);

        List<Map<String, Object>> list = this.findBySql(sql, parameterMap);
        if (list != null && list.size() > 0) {
            return list.get(0);
        } else {
            return null;
        }
    }

    /**
     * 
     * @Description: 获取自然人信息, 姓名加身份证. 
     * @see： @see com.udatech.common.creditReportQuery.dao.CreditReportQueryDao#findEnterpriseInfoStrictZrr(java.util.Map)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> findEnterpriseInfoStrictZrr(Map<String, Object> params) {
        String sql = " select * from YW_P_GRJBXX where xm = :name and sfzh = :idCard  ";
        
        String name = MapUtils.getString(params, "name", "");
        String idCard = MapUtils.getString(params, "idCard", "");
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("name", name);
        parameterMap.put("idCard", idCard);
        
        List<Map<String, Object>> list = this.findBySql(sql, parameterMap);
        if (list != null && list.size() > 0) {
            return list.get(0);
        } else {
            return null;
        }
        
    }
    /**
     * <描述>: 获取资源数据
     * @author 作者：lijj
     * @version 创建时间：2016年5月13日下午5:42:19
     * @param themeTwo
     * @param params
     * @return
     */
    public List<Map<String, Object>> getCreditData(TemplateThemeNode themeTwo, Map<String, Object> params) {
        NamedParameterJdbcTemplate jdbcTemplate = DataSourceUtil.getDataSource(themeTwo.getDataSource());
        String table = themeTwo.getDataTable();

        // 动态拼接查询字段
        String columnStr = "";
        for (TemplateThemeColumn column : themeTwo.getColumns()) {
            columnStr += column.getColumnName() + ",";
        }
        columnStr = columnStr.substring(0, columnStr.length() - 1);

        String querySql = " select ID as UUID, STATUS, " + columnStr + " from " + table + " where 1=1 ";

        // 开始结束时间
        String kssj = MapUtils.getString(params, "kssj", "");
        String jssj = MapUtils.getString(params, "jssj", "");
        Date beginDate = null;
        Date endDate = null;
        if (StringUtils.isNotBlank(kssj)) {
            beginDate = DateUtils.parseDate(kssj + " 00:00:00", DateUtils.YYYYMMDDHHMMSS_19);
        }
        if (StringUtils.isNotBlank(jssj)) {
            endDate = DateUtils.parseDate(jssj + " 23:59:59", DateUtils.YYYYMMDDHHMMSS_19);
        }

        // 查询参数
        String jgqc = MapUtils.getString(params, "jgqc", "");
        String zzjgdm = MapUtils.getString(params, "zzjgdm", "");
        String gszch = MapUtils.getString(params, "gszch", "");
        String tyshxydm = MapUtils.getString(params, "tyshxydm", "");

        Map<String, Object> parameterMap = new HashMap<>();
        // 动态拼接查询条件
        String where_sql = "";
        // 查询参数
        if (StringUtils.isNotBlank(jgqc)) {
            where_sql += " or jgqc = :jgqc ";
            parameterMap.put("jgqc", jgqc);
        }

        if (StringUtils.isNotBlank(zzjgdm)) {
            where_sql += " or zzjgdm = :zzjgdm ";
            parameterMap.put("zzjgdm", zzjgdm);
        }
        if (StringUtils.isNotBlank(gszch)) {
            where_sql += " or gszch = :gszch ";
            parameterMap.put("gszch", gszch);
        }
        if (StringUtils.isNotBlank(tyshxydm)) {
            where_sql += " or tyshxydm = :tyshxydm ";
            parameterMap.put("tyshxydm", tyshxydm);
        }

        // 拼接条件
        if (where_sql.length() > 0) {
            where_sql = where_sql.trim();
            where_sql = where_sql.substring(where_sql.indexOf("or") + 2);
            where_sql = " and (" + where_sql + ")";
        }

        // STATUS状态（0 未整合,1 已整合,2已修复,3已删除）
        where_sql += " and STATUS != :status ";// 过滤掉异议申诉处理时，已删除的数据
        parameterMap.put("status", CreditDataStatusEnum.已删除.getKey());

        // 查询数据的时间段
        if (beginDate != null) {
            where_sql += " and TGRQ >= :beginDate ";
            parameterMap.put("beginDate", beginDate);
        }
        if (endDate != null) {
            where_sql += " and TGRQ <= :endDate ";
            parameterMap.put("endDate", endDate);
        }

        String sql = querySql + where_sql;

        TemplateThemeColumn column = getOrderColumn(themeTwo.getColumns());
        if (column != null) {
            sql += " ORDER BY " + column.getColumnName() + " " + column.getDataOrder();
        }

        return jdbcTemplate.queryForList(sql, parameterMap);
    }

    private TemplateThemeColumn getOrderColumn(List<TemplateThemeColumn> list) {
        if (list != null && !list.isEmpty()) {
            for (TemplateThemeColumn column : list) {
                String order = column.getDataOrder();
                if (StringUtils.isNotBlank(order)) {
                    return column;
                }
            }
        }
        return null;
    }

    @Override
    public void updateXybgbh(String xybgbh, String businessId) {
        String sql = "UPDATE DT_ENTERPRISE_REPORT_APPLY A SET A.XYBGBH= :xybgbh WHERE A.ID= :businessId ";
        Map<String, String> parameterMap = new HashMap<String, String>();
        parameterMap.put("xybgbh", xybgbh);
        parameterMap.put("businessId", businessId);
        this.executeUpdateSql(sql, parameterMap);
    }

    @Override
    public PersonReportApply getPReportApplyById(String id) {
        return this.get(PersonReportApply.class, id);
    }

    @Override
    public List<Map<String, Object>> getPCreditData(TemplateThemeNode themeTwo, Map<String, Object> params) {
        NamedParameterJdbcTemplate jdbcTemplate = DataSourceUtil.getDataSource(themeTwo.getDataSource());
        String table = themeTwo.getDataTable();

        // 动态拼接查询字段
        String columnStr = "";
        for (TemplateThemeColumn column : themeTwo.getColumns()) {
            columnStr += column.getColumnName() + ",";
        }
        columnStr = columnStr.substring(0, columnStr.length() - 1);

        String querySql = " select ID as UUID, STATUS, " + columnStr + " from " + table + " where 1=1 ";

        // 动态拼接查询条件
        String where_sql = "";
        String idCard = MapUtils.getString(params, "idCard", "");

        // 开始结束时间
        String kssj = MapUtils.getString(params, "kssj", "");
        String jssj = MapUtils.getString(params, "jssj", "");
        Date beginDate = null;
        Date endDate = null;
        if (StringUtils.isNotBlank(kssj)) {
            beginDate = DateUtils.parseDate(kssj + " 00:00:00", DateUtils.YYYYMMDDHHMMSS_19);
        }
        if (StringUtils.isNotBlank(jssj)) {
            endDate = DateUtils.parseDate(jssj + " 23:59:59", DateUtils.YYYYMMDDHHMMSS_19);
        }

        // 查询参数
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        if ("YW_P_GRHYDJ".equals(table.toUpperCase())) {
            // 如果是个人婚姻登记信息表，则字段做特殊处理，
            if (StringUtils.isNotBlank(idCard)) {
                where_sql += " and (NANFSFZH = :idCard or NVFSFZH = :idCard) ";
                parameterMap.put("idCard", idCard);
            }
        } else {
            if (StringUtils.isNotBlank(idCard)) {
                where_sql += " and SFZH = :idCard ";
                parameterMap.put("idCard", idCard);
            }
        }

        // STATUS状态（0 未整合,1 已整合,2已修复,3已删除）
        where_sql += " and STATUS != :status ";// 过滤掉异议申诉处理时，已删除的数据（自然人的暂时不会有该项数据，但是留着以后用）
        parameterMap.put("status", CreditDataStatusEnum.已删除.getKey());

        // 查询数据的时间段
        if (beginDate != null) {
            where_sql += " and TGRQ >= :beginDate ";
            parameterMap.put("beginDate", beginDate);
        }
        if (endDate != null) {
            where_sql += " and TGRQ <= :endDate ";
            parameterMap.put("endDate", endDate);
        }

        String sql = querySql + where_sql;

        return jdbcTemplate.queryForList(sql, parameterMap);
    }

    @Override
    public void updatePXybgbh(String xybgbh, String businessId) {
        String sql = "UPDATE DT_PERSON_REPORT_APPLY A SET A.XYBGBH= :xybgbh WHERE A.ID= :businessId ";
        Map<String, String> parameterMap = new HashMap<String, String>();
        parameterMap.put("xybgbh", xybgbh);
        parameterMap.put("businessId", businessId);
        this.executeUpdateSql(sql, parameterMap);
    }

   

}
