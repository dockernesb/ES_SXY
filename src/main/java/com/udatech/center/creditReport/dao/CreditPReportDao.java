package com.udatech.center.creditReport.dao;

import com.udatech.common.model.PersonReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.Date;

/**
 * <描述>：自然人 - 信用查询dao层 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月12日下午4:56:15package com.udatech.center.creditReport.dao; import java.util.Date; import
 *          org.apache.commons.lang3.StringUtils; import org.hibernate.Criteria; import org.hibernate.Session; import
 *          org.hibernate.criterion.DetachedCriteria; import org.hibernate.criterion.Order; import
 *          org.hibernate.criterion.Restrictions; import org.springframework.stereotype.Repository; import
 *          com.udatech.common.model.PersonReportApply; import com.wa.framework.Page; import com.wa.framework.Pageable;
 *          import com.wa.framework.dao.BaseDaoImpl; import com.wa.framework.util.DateUtils; import
 *          com.wa.framework.utils.EscapeChar; /** <描述>：企业信用查询dao层 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月12日下午4:56:15
 */
@Repository("creditPReportDao")
public class CreditPReportDao extends BaseDaoImpl {

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
     * <描述>: 获取信用报告申请信息列表
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:21:54
     * @param pi
     * @param xybgbh
     * @param page
     * @return
     */
    public Pageable<PersonReportApply> getReportApplyList(PersonReportApply pi, String xybgbh, Page page) {
        DetachedCriteria criteria = DetachedCriteria.forClass(PersonReportApply.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");

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
     * <描述>: 保存审核信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日上午9:58:44
     * @param er
     */
    public void saveReprotAudit(PersonReportApply er) {
        String id = er.getId();
        PersonReportApply old = this.get(PersonReportApply.class, id);
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
