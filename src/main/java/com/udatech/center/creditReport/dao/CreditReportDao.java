package com.udatech.center.creditReport.dao;

import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
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
 * <描述>：企业信用查询dao层 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月12日下午4:56:15
 */
@Repository("creditReportDao")
public class CreditReportDao extends BaseDaoImpl {

    /**
     * @category 根据ID获取信用报告申请信息
     * @param id
     * @return
     */
    public EnterpriseReportApply getReportById(String id) {
        Session session = getSession();
        Criteria criteria = session.createCriteria(EnterpriseReportApply.class);
        criteria.add(Restrictions.eq("id", id));
        EnterpriseReportApply eo = (EnterpriseReportApply) criteria.uniqueResult();
        return eo;
    }

    /**
     * <描述>: 获取信用报告申请信息列表
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:21:54
     * @param ei
     * @param xybgbh
     * @param page
     * @param isIssue
     * @return
     */
    public Pageable<EnterpriseReportApply> getReportApplyList(EnterpriseInfo ei, Map<String, Object> params, Page page) {
        DetachedCriteria criteria = DetachedCriteria.forClass(EnterpriseReportApply.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");

        String xybgbh = MapUtils.getString(params, "xybgbh");
        String isHasBasic = MapUtils.getString(params, "isHasBasic");
        String isHasReport = MapUtils.getString(params, "isHasReport");
        String isIssue = MapUtils.getString(params, "isIssue");

        criteria.add(Restrictions.eq("status", "0"));
        String qymc = ei.getJgqc();
        if (StringUtils.isNotBlank(qymc)) {
            criteria.add(EscapeChar.fuzzyCriterion("qymc", qymc));
        }

        String zzjgdm = ei.getZzjgdm();
        if (StringUtils.isNotBlank(zzjgdm)) {
            criteria.add(EscapeChar.fuzzyCriterion("zzjgdm", zzjgdm));
        }

        String gszch = ei.getGszch();
        if (StringUtils.isNotBlank(gszch)) {
            criteria.add(EscapeChar.fuzzyCriterion("gszch", gszch));
        }

        String bjbh = ei.getBjbh();
        if (StringUtils.isNotBlank(bjbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("bjbh", bjbh));
        }

        String tyshxydm = ei.getTyshxydm();
        if (StringUtils.isNotBlank(tyshxydm)) {
            criteria.add(EscapeChar.fuzzyCriterion("tyshxydm", tyshxydm));
        }

        String status = ei.getStatus();
        if (StringUtils.isNotBlank(status)) {
            criteria.add(Restrictions.eq("status", status));
        }

        if (StringUtils.isNotBlank(xybgbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("xybgbh", xybgbh));
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

        String beginDate = ei.getBeginDate();
        if (StringUtils.isNotBlank(beginDate)) {
            try {
                beginDate += " 00:00:00";
                Date date = DateUtils.parseDate(beginDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.ge("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String endDate = ei.getEndDate();
        if (StringUtils.isNotBlank(endDate)) {
            try {
                endDate += " 23:59:59";
                Date date = DateUtils.parseDate(endDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.le("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String bjbm = ei.getBjbm();
        if (StringUtils.isNotBlank(bjbm)) {
            deptCriteria.add(Restrictions.eq("id", bjbm));
        }

        criteria.addOrder(Order.desc("createDate"));

        Pageable<EnterpriseReportApply> pageable = findByDetachedCriteriaWithPage(criteria, page);

        return pageable;
    }

    /**
     * <描述>: 获取报告下发列表
     * @author 作者：Ljj
     * @version 创建时间：2017年8月12日下午5:56:38
     * @param ei
     * @param params
     * @param page
     * @return
     */
    public Pageable<EnterpriseReportApply> getReportIssueList(EnterpriseInfo ei, Map<String, Object> params, Page page) {
        DetachedCriteria criteria = DetachedCriteria.forClass(EnterpriseReportApply.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");

        String xybgbh = MapUtils.getString(params, "xybgbh");
        String isHasBasic = MapUtils.getString(params, "isHasBasic");
        String isHasReport = MapUtils.getString(params, "isHasReport");
        String isIssue = MapUtils.getString(params, "isIssue");

        criteria.add(Restrictions.eq("status", "1"));
        criteria.add(Restrictions.eq("isIssue", "0"));
        criteria.add(Restrictions.isNotNull("xybgbh"));

        String qymc = ei.getJgqc();
        if (StringUtils.isNotBlank(qymc)) {
            criteria.add(EscapeChar.fuzzyCriterion("qymc", qymc));
        }

        String zzjgdm = ei.getZzjgdm();
        if (StringUtils.isNotBlank(zzjgdm)) {
            criteria.add(EscapeChar.fuzzyCriterion("zzjgdm", zzjgdm));
        }

        String gszch = ei.getGszch();
        if (StringUtils.isNotBlank(gszch)) {
            criteria.add(EscapeChar.fuzzyCriterion("gszch", gszch));
        }

        String bjbh = ei.getBjbh();
        if (StringUtils.isNotBlank(bjbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("bjbh", bjbh));
        }

        String tyshxydm = ei.getTyshxydm();
        if (StringUtils.isNotBlank(tyshxydm)) {
            criteria.add(EscapeChar.fuzzyCriterion("tyshxydm", tyshxydm));
        }

        if (StringUtils.isNotBlank(xybgbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("xybgbh", xybgbh));
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

        String beginDate = ei.getBeginDate();
        if (StringUtils.isNotBlank(beginDate)) {
            try {
                beginDate += " 00:00:00";
                Date date = DateUtils.parseDate(beginDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.ge("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String endDate = ei.getEndDate();
        if (StringUtils.isNotBlank(endDate)) {
            try {
                endDate += " 23:59:59";
                Date date = DateUtils.parseDate(endDate, DateUtils.YYYYMMDDHHMMSS_19);
                criteria.add(Restrictions.le("createDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String bjbm = ei.getBjbm();
        if (StringUtils.isNotBlank(bjbm)) {
            deptCriteria.add(Restrictions.eq("id", bjbm));
        }

        criteria.addOrder(Order.desc("createDate"));

        Pageable<EnterpriseReportApply> pageable = findByDetachedCriteriaWithPage(criteria, page);

        return pageable;
    }

    /**
     * <描述>: 保存审核信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日上午9:58:44
     * @param er
     */
    public void saveReprotAudit(EnterpriseReportApply er) {
        String id = er.getId();
        EnterpriseReportApply old = this.get(EnterpriseReportApply.class, id);
        if (old != null) {
            old.setXybgbh(er.getXybgbh());
            old.setStatus(er.getStatus());
            old.setZxshyj(er.getZxshyj());
            old.setZxshr(er.getZxshr());
            old.setZxshsj(new Date());
            this.update(old);
        }
    }
}
