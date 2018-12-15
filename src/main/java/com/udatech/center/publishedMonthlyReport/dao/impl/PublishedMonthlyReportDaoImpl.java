package com.udatech.center.publishedMonthlyReport.dao.impl;

import com.udatech.center.publishedMonthlyReport.dao.PublishedMonthlyReportDao;
import com.udatech.center.publishedMonthlyReport.model.PublishedMonthlyReport;
import com.wa.framework.OrderProperty;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.QueryCondition;
import com.wa.framework.QueryConditions;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.user.model.SysDepartment;
import org.apache.commons.collections.ListUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * @author IT-20170331ROM3
 * @category 双公示月报表
 * @time 2017-12-05 15:12:27
 */
@Repository
public class PublishedMonthlyReportDaoImpl extends BaseDaoImpl implements PublishedMonthlyReportDao {

    private String[] boardList = new String[]{"张家港市", "常熟市", "太仓市", "昆山市", "吴江区", "吴中区", "相城区", "姑苏区", "工业园区", "苏州市太仓港口", "高新区"};

    /**
     * 查询双公示月报表
     *
     * @param report
     * @param page
     * @return
     */
    public Pageable getList(PublishedMonthlyReport report, Page page) {
        QueryConditions conditions = new QueryConditions();
        conditions.add(QueryCondition.eq("status", "1"));

        SysDepartment dept = report.getDept();
        if (dept != null) {
            String deptId = dept.getId();
            if (StringUtils.isNotBlank(deptId)) {
                conditions.add(QueryCondition.eq("dept.id", deptId));
            }
        }

        String beginDate = report.getBeginDate();
        if (StringUtils.isNotBlank(beginDate)) {
            conditions.add(QueryCondition.ge("month", beginDate));
        }

        String endDate = report.getEndDate();
        if (StringUtils.isNotBlank(endDate)) {
            conditions.add(QueryCondition.le("month", endDate));
        }

        return this.findWithPage(PublishedMonthlyReport.class, page, OrderProperty.desc("month"), conditions);
    }

    /**
     * 查询双公示汇总
     *
     * @param report
     * @param page
     * @return
     */
    public Pageable<Map<String, Object>> getSumList(PublishedMonthlyReport report, Page page) {
        StringBuilder sb = new StringBuilder();
        sb.append(" SELECT SUM(XZXK_CSSL) XZXK_CSSL,       ");
        sb.append("        SUM(XZXK_BDWGSSL) XZXK_BDWGSSL, ");
        sb.append("        SUM(XZXK_BSSL) XZXK_BSSL,       ");
        sb.append("        SUM(XZXK_WBSSL) XZXK_WBSSL,     ");
        sb.append("        SUM(XZCF_CSSL) XZCF_CSSL,       ");
        sb.append("        SUM(XZCF_BDWGSSL) XZCF_BDWGSSL, ");
        sb.append("        SUM(XZCF_BSSL) XZCF_BSSL,       ");
        sb.append("        SUM(XZCF_WBSSL) XZCF_WBSSL      ");
        sb.append("   FROM DT_PUBLISHED_MONTHLY_REPORT     ");
        sb.append("  WHERE STATUS = '1'                    ");

        Map<String, Object> params = new HashMap<>();

        SysDepartment dept = report.getDept();
        if (dept != null) {
            String deptId = dept.getId();
            if (StringUtils.isNotBlank(deptId)) {
                sb.append(" AND DEPT_ID = :deptId ");
                params.put("deptId", deptId);
            }
        }

        String beginDate = report.getBeginDate();
        if (StringUtils.isNotBlank(beginDate)) {
            sb.append(" AND MONTH >= :beginDate ");
            params.put("beginDate", beginDate);
        }

        String endDate = report.getEndDate();
        if (StringUtils.isNotBlank(endDate)) {
            sb.append(" AND MONTH <= :endDate ");
            params.put("endDate", endDate);
        }

        String countSql = " SELECT COUNT(*) FROM ( " + sb.toString() + " ) ";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(sb.toString(), countSql, page, params);

        return pageable;
    }

    /**
     * 清除session中对象
     *
     * @param object
     */
    public void evict(Object object) {
        getSession().evict(object);
    }

    /**
     * 获取最小日期和最大日期
     *
     * @return
     */
    public PublishedMonthlyReport getMinDateAndMaxDate() {
        String sql = "SELECT MIN(MONTH) MIN_MONTH, MAX(MONTH) MAX_MONTH FROM DT_PUBLISHED_MONTHLY_REPORT";
        List<Map<String, Object>> list = this.findBySql(sql);
        if (list != null && !list.isEmpty()) {
            Map<String, Object> map = list.get(0);
            String beginDate = (String) map.get("MIN_MONTH");
            String endDate = (String) map.get("MAX_MONTH");
            PublishedMonthlyReport report = new PublishedMonthlyReport();
            report.setBeginDate(beginDate);
            report.setEndDate(endDate);
            return report;
        }
        return null;
    }


    /**
     * 获取导出列表
     *
     * @param report
     * @return
     */
    public Map<String, Object> getExportList(PublishedMonthlyReport report) {
        Map<String, Object> params = new HashMap<>();
        params.put("beginDate", report.getBeginDate());
        params.put("endDate", report.getEndDate());

        String sumSql = "SELECT SUM(XZXK_CSSL) XZXK_CSSL, SUM(XZXK_BDWGSSL) XZXK_BDWGSSL, SUM(XZXK_BSSL) XZXK_BSSL, SUM(XZXK_WBSSL) XZXK_WBSSL, SUM(XZXK_SIZE) XZXK_SIZE, SUM(XZCF_CSSL) XZCF_CSSL, SUM(XZCF_BDWGSSL) XZCF_BDWGSSL, SUM(XZCF_BSSL) XZCF_BSSL, SUM(XZCF_WBSSL) XZCF_WBSSL, SUM(XZCF_SIZE) XZCF_SIZE FROM (SELECT F.DEPT_NAME, E.XZXK_CSSL, E.XZXK_BDWGSSL, E.XZXK_BSSL, E.XZXK_WBSSL, F.XZXK_SIZE, E.XZCF_CSSL, E.XZCF_BDWGSSL, E.XZCF_BSSL, E.XZCF_WBSSL, F.XZCF_SIZE FROM (SELECT DEPT_ID, SUM(XZXK_CSSL) XZXK_CSSL, SUM(XZXK_BDWGSSL) XZXK_BDWGSSL, SUM(XZXK_BSSL) XZXK_BSSL, SUM(XZXK_WBSSL) XZXK_WBSSL, SUM(XZCF_CSSL) XZCF_CSSL, SUM(XZCF_BDWGSSL) XZCF_BDWGSSL, SUM(XZCF_BSSL) XZCF_BSSL, SUM(XZCF_WBSSL) XZCF_WBSSL FROM DT_PUBLISHED_MONTHLY_REPORT WHERE STATUS = '1' AND MONTH >= :beginDate AND MONTH <= :endDate GROUP BY DEPT_ID) E LEFT JOIN (SELECT D.SYS_DEPARTMENT_ID DEPT_ID, D.CODE, D.DEPARTMENT_NAME DEPT_NAME, C.XZXK_SIZE, C.XZCF_SIZE FROM (SELECT CASE WHEN A.BMBM IS NULL THEN B.BMBM ELSE A.BMBM END BMBM, A.XZXK_SIZE, B.XZCF_SIZE FROM (SELECT BMBM, COUNT(*) XZXK_SIZE FROM YW_L_SGSXZXK WHERE TO_CHAR(CREATE_TIME, 'YYYY-MM') >= :beginDate AND TO_CHAR(CREATE_TIME, 'YYYY-MM') <= :endDate GROUP BY BMBM) A FULL JOIN (SELECT BMBM, COUNT(*) XZCF_SIZE FROM YW_L_SGSXZCF WHERE TO_CHAR(CREATE_TIME, 'YYYY-MM') >= :beginDate AND TO_CHAR(CREATE_TIME, 'YYYY-MM') <= :endDate GROUP BY BMBM) B ON A.BMBM = B.BMBM) C RIGHT JOIN SYS_DEPARTMENT D ON C.BMBM = D.CODE) F ON E.DEPT_ID = F.DEPT_ID)";
        Map<String, Object> sum = this.uniqueBySql(sumSql, params);

        String descSql = "SELECT F.DEPT_NAME, E.WEB_URL, E.XZXK_CSSL, E.XZXK_BDWGSSL, E.XZXK_BSSL, E.XZXK_WBSSL, E.XZXK_WBSYJ, F.XZXK_SIZE, E.XZCF_CSSL, E.XZCF_BDWGSSL, E.XZCF_BSSL, E.XZCF_WBSSL, E.XZCF_WBSYJ, F.XZCF_SIZE FROM (SELECT DEPT_ID, MAX(WEB_URL) WEB_URL, SUM(XZXK_CSSL) XZXK_CSSL, SUM(XZXK_BDWGSSL) XZXK_BDWGSSL, SUM(XZXK_BSSL) XZXK_BSSL, SUM(XZXK_WBSSL) XZXK_WBSSL, LISTAGG(XZXK_WBSYJ, ';') WITHIN GROUP(ORDER BY XZXK_WBSYJ) XZXK_WBSYJ, SUM(XZCF_CSSL) XZCF_CSSL, SUM(XZCF_BDWGSSL) XZCF_BDWGSSL, SUM(XZCF_BSSL) XZCF_BSSL, SUM(XZCF_WBSSL) XZCF_WBSSL, LISTAGG(XZCF_WBSYJ, ';') WITHIN GROUP(ORDER BY XZCF_WBSYJ) XZCF_WBSYJ FROM DT_PUBLISHED_MONTHLY_REPORT WHERE STATUS = '1' AND MONTH >= :beginDate AND MONTH <= :endDate GROUP BY DEPT_ID) E LEFT JOIN (SELECT D.SYS_DEPARTMENT_ID DEPT_ID, D.CODE, D.DEPARTMENT_NAME DEPT_NAME, C.XZXK_SIZE, C.XZCF_SIZE FROM (SELECT CASE WHEN A.BMBM IS NULL THEN B.BMBM ELSE A.BMBM END BMBM, A.XZXK_SIZE, B.XZCF_SIZE FROM (SELECT BMBM, COUNT(*) XZXK_SIZE FROM YW_L_SGSXZXK WHERE TO_CHAR(CREATE_TIME, 'YYYY-MM') >= :beginDate AND TO_CHAR(CREATE_TIME, 'YYYY-MM') <= :endDate GROUP BY BMBM) A FULL JOIN (SELECT BMBM, COUNT(*) XZCF_SIZE FROM YW_L_SGSXZCF WHERE TO_CHAR(CREATE_TIME, 'YYYY-MM') >= :beginDate AND TO_CHAR(CREATE_TIME, 'YYYY-MM') <= :endDate GROUP BY BMBM) B ON A.BMBM = B.BMBM) C RIGHT JOIN SYS_DEPARTMENT D ON C.BMBM = D.CODE) F ON E.DEPT_ID = F.DEPT_ID WHERE F.DEPT_NAME NOT IN (:deptNames) ORDER BY F.CODE ASC";
        List<Map<String, Object>> descList = getListBySql(descSql, report);

        String boardSql = "SELECT F.DEPT_NAME, E.WEB_URL, E.XZXK_CSSL, E.XZXK_BDWGSSL, E.XZXK_BSSL, E.XZXK_WBSSL, E.XZXK_WBSYJ, F.XZXK_SIZE, E.XZCF_CSSL, E.XZCF_BDWGSSL, E.XZCF_BSSL, E.XZCF_WBSSL, E.XZCF_WBSYJ, F.XZCF_SIZE FROM (SELECT DEPT_ID, MAX(WEB_URL) WEB_URL, SUM(XZXK_CSSL) XZXK_CSSL, SUM(XZXK_BDWGSSL) XZXK_BDWGSSL, SUM(XZXK_BSSL) XZXK_BSSL, SUM(XZXK_WBSSL) XZXK_WBSSL, LISTAGG(XZXK_WBSYJ, ';') WITHIN GROUP(ORDER BY XZXK_WBSYJ) XZXK_WBSYJ, SUM(XZCF_CSSL) XZCF_CSSL, SUM(XZCF_BDWGSSL) XZCF_BDWGSSL, SUM(XZCF_BSSL) XZCF_BSSL, SUM(XZCF_WBSSL) XZCF_WBSSL, LISTAGG(XZCF_WBSYJ, ';') WITHIN GROUP(ORDER BY XZCF_WBSYJ) XZCF_WBSYJ FROM DT_PUBLISHED_MONTHLY_REPORT WHERE STATUS = '1' AND MONTH >= :beginDate AND MONTH <= :endDate GROUP BY DEPT_ID) E LEFT JOIN (SELECT D.SYS_DEPARTMENT_ID DEPT_ID, D.CODE, D.DEPARTMENT_NAME DEPT_NAME, C.XZXK_SIZE, C.XZCF_SIZE FROM (SELECT CASE WHEN A.BMBM IS NULL THEN B.BMBM ELSE A.BMBM END BMBM, A.XZXK_SIZE, B.XZCF_SIZE FROM (SELECT BMBM, COUNT(*) XZXK_SIZE FROM YW_L_SGSXZXK WHERE TO_CHAR(CREATE_TIME, 'YYYY-MM') >= :beginDate AND TO_CHAR(CREATE_TIME, 'YYYY-MM') <= :endDate GROUP BY BMBM) A FULL JOIN (SELECT BMBM, COUNT(*) XZCF_SIZE FROM YW_L_SGSXZCF WHERE TO_CHAR(CREATE_TIME, 'YYYY-MM') >= :beginDate AND TO_CHAR(CREATE_TIME, 'YYYY-MM') <= :endDate GROUP BY BMBM) B ON A.BMBM = B.BMBM) C RIGHT JOIN SYS_DEPARTMENT D ON C.BMBM = D.CODE) F ON E.DEPT_ID = F.DEPT_ID WHERE F.DEPT_NAME IN (:deptNames) ORDER BY F.CODE ASC";
        List<Map<String, Object>> boardList = getListBySql(boardSql, report);

        if (sum != null && descList != null && boardSql != null) {
            Map<String, Object> map = new HashMap<>();
            map.put("sum", sum);
            map.put("descList", descList);
            map.put("boardList", boardList);
            return map;
        }

        return null;
    }

    /**
     * 根据sql查询列表
     *
     * @param sql
     * @param report
     * @return
     */
    private List<Map<String, Object>> getListBySql(String sql, PublishedMonthlyReport report) {
        SQLQuery query = getSession().createSQLQuery(sql);
        query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
        query.setString("beginDate", report.getBeginDate());
        query.setString("endDate", report.getEndDate());
        query.setParameterList("deptNames", boardList);
        return query.list();
    }

}
