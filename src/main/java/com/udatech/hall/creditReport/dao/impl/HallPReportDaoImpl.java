package com.udatech.hall.creditReport.dao.impl;

import com.udatech.common.model.PersonReportApply;
import com.udatech.hall.creditReport.dao.HallPReportDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.Map;

/**
 * <描述>：自然人-信用报告申请信息（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:52:33
 */
@Repository
public class HallPReportDaoImpl extends BaseDaoImpl implements HallPReportDao {

    /**
     * @category 根据ID获取信用报告申请信息
     * @param id
     * @return
     */
    public PersonReportApply getReportById(String id) {
        Session session = getSession();
        Criteria criteria = session.createCriteria(PersonReportApply.class);
        criteria.add(Restrictions.eq("id", id));
        PersonReportApply po = (PersonReportApply) criteria.uniqueResult();
        return po;
    }

    /**
     * @category 获取信用报告申请信息列表
     * @param pi
     * @param page
     * @return
     */
    public Pageable<PersonReportApply> getReportList(PersonReportApply pi, Map<String, Object> params, Page page) {
        DetachedCriteria criteria = DetachedCriteria.forClass(PersonReportApply.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");

        String xybgbh = MapUtils.getString(params, "xybgbh");
        String isHasBasic = MapUtils.getString(params, "isHasBasic");
        String isHasReport = MapUtils.getString(params, "isHasReport");
        String isIssue = MapUtils.getString(params, "isIssue");

        String cxrxm = pi.getCxrxm();
        if (StringUtils.isNotBlank(cxrxm)) {
            criteria.add(EscapeChar.fuzzyCriterion("cxrxm", cxrxm));
        }

        String cxrsfzh = pi.getCxrsfzh();
        if (StringUtils.isNotBlank(cxrsfzh)) {
            criteria.add(EscapeChar.fuzzyCriterion("cxrsfzh", cxrsfzh));
        }

        String bjbh = pi.getBjbh();
        if (StringUtils.isNotBlank(bjbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("bjbh", bjbh));
        }

        if (StringUtils.isNotBlank(xybgbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("xybgbh", xybgbh));
        }

        String status = pi.getStatus();
        if (StringUtils.isNotBlank(status)) {
            criteria.add(Restrictions.eq("status", status));
        }

        if (StringUtils.isNotBlank(isHasBasic)) {
            criteria.add(Restrictions.eq("isHasBasic", isHasBasic));
        }

        if (StringUtils.isNotBlank(isHasReport)) {
            criteria.add(Restrictions.eq("isHasReport", isHasReport));
        }

        if (StringUtils.isNotBlank(isIssue)) {
            criteria.add(Restrictions.eq("isIssue", isIssue));
        }

        String beginDate = pi.getBeginDate();
        if (StringUtils.isNotBlank(beginDate)) {
            try {
                beginDate += " 00:00:00";
                Date date = DateUtils.parseDate(beginDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.ge("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String endDate = pi.getEndDate();
        if (StringUtils.isNotBlank(endDate)) {
            try {
                endDate += " 23:59:59";
                Date date = DateUtils.parseDate(endDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.le("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String bjbm = pi.getBjbm();
        if (StringUtils.isNotBlank(bjbm)) {
            deptCriteria.add(Restrictions.eq("id", bjbm));
        }

        criteria.addOrder(Order.desc("createDate"));

        Pageable<PersonReportApply> pageable = findByDetachedCriteriaWithPage(criteria, page);
        return pageable;
    }

    /**
     * @category 获取信用报告申请信息列表
     * @param pi
     * @param page
     * @return
     */
    public Pageable<PersonReportApply> getReportIssueList(PersonReportApply pi, Map<String, Object> params, Page page) {
        DetachedCriteria criteria = DetachedCriteria.forClass(PersonReportApply.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");

        String xybgbh = MapUtils.getString(params, "xybgbh");
        String isHasBasic = MapUtils.getString(params, "isHasBasic");
        String isHasReport = MapUtils.getString(params, "isHasReport");
        criteria.add(Restrictions.isNotNull("xybgbh"));

        String cxrxm = pi.getCxrxm();
        if (StringUtils.isNotBlank(cxrxm)) {
            criteria.add(EscapeChar.fuzzyCriterion("cxrxm", cxrxm));
        }

        String cxrsfzh = pi.getCxrsfzh();
        if (StringUtils.isNotBlank(cxrsfzh)) {
            criteria.add(EscapeChar.fuzzyCriterion("cxrsfzh", cxrsfzh));
        }

        String bjbh = pi.getBjbh();
        if (StringUtils.isNotBlank(bjbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("bjbh", bjbh));
        }

        if (StringUtils.isNotBlank(xybgbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("xybgbh", xybgbh));
        }

        String status = pi.getStatus();
        if (StringUtils.isNotBlank(status)) {
            criteria.add(Restrictions.eq("status", status));
        }

        if (StringUtils.isNotBlank(isHasBasic)) {
            criteria.add(Restrictions.eq("isHasBasic", isHasBasic));
        }

        if (StringUtils.isNotBlank(isHasReport)) {
            criteria.add(Restrictions.eq("isHasReport", isHasReport));
        }

        String beginDate = pi.getBeginDate();
        if (StringUtils.isNotBlank(beginDate)) {
            try {
                beginDate += " 00:00:00";
                Date date = DateUtils.parseDate(beginDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.ge("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String endDate = pi.getEndDate();
        if (StringUtils.isNotBlank(endDate)) {
            try {
                endDate += " 23:59:59";
                Date date = DateUtils.parseDate(endDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.le("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String bjbm = pi.getBjbm();
        if (StringUtils.isNotBlank(bjbm)) {
            deptCriteria.add(Restrictions.eq("id", bjbm));
        }

        criteria.addOrder(Order.desc("createDate"));

        Pageable<PersonReportApply> pageable = findByDetachedCriteriaWithPage(criteria, page);
        return pageable;
    }

}
