package com.udatech.common.creditCheck.dao.impl;

import com.udatech.common.constant.Constants;
import com.udatech.common.creditCheck.dao.PCreditCheckDao;
import com.udatech.common.enmu.CreditDataStatusEnum;
import com.udatech.common.model.PCreditExamine;
import com.udatech.common.model.PCreditExamineHis;
import com.udatech.common.model.PeopleExamine;
import com.udatech.common.resourceManage.model.Theme;
import com.udatech.common.resourceManage.vo.TemplateThemeColumn;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description: 信用审查DaoImpl(中心端)
 * @author: 何斐
 * @date: 2016年11月21日 下午3:52:13
 */
@Repository
public class PCreditCheckDaoImpl extends BaseDaoImpl implements PCreditCheckDao {

    @Override
    public SysUser findUserById(String sysuserid) {
        Criteria criteria = getSession().createCriteria(SysUser.class);
        criteria.add(Restrictions.eq("id", sysuserid));
        @SuppressWarnings("unchecked")
        List<SysUser> list = criteria.list();
        for (SysUser user : list) {
            Hibernate.initialize(user.getSysDepartment());
        }
        return list.get(0);
    }

    @Override
    public Pageable<PCreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
                                                               String sqsjs, String sqsjz, String userId, String status, String type, String bjbm) {
        DetachedCriteria criteria = DetachedCriteria.forClass(PCreditExamine.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");
        if (StringUtils.isNotBlank(scmc)) {
            criteria.add(EscapeChar.fuzzyCriterion("scmc", scmc));
        }
        if (StringUtils.isNotBlank(bjbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("bjbh", bjbh));
        }
        if (StringUtils.isNotBlank(sqsjs)) {
            try {
                Date date = DateUtils.parseDate(sqsjs, DateUtils.YYYYMMDD_10);
                criteria.add(Restrictions.ge("applyDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (StringUtils.isNotBlank(sqsjz)) {
            try {
                Date date = DateUtils.parseDate(sqsjz, DateUtils.YYYYMMDD_10);
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                cal.add(Calendar.DATE, 1);
                date = cal.getTime();
                criteria.add(Restrictions.le("applyDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        SysUser user = findUserById(userId);
        String deptCode = user.getSysDepartment().getCode();
        String deptId = user.getSysDepartment().getId();
        if (StringUtils.equals(Constants.CENTER_DEPT_CODE, deptCode)) {
            if (StringUtils.isNotBlank(xqbm)) {
                criteria.add(Restrictions.eq("scxqbm.id", xqbm));
            }
        } else {
            if (StringUtils.isNotBlank(xqbm)) {
                criteria.add(Restrictions.eq("scxqbm.id", xqbm));
            } else {
                criteria.add(Restrictions.eq("scxqbm.id", deptId));
            }
        }
        if ("1".equals(type)) { //  审查审核（查询待审核的）
            criteria.add(Restrictions.eq("status", "0"));
        } else if ("2".equals(type)) {  //  审查查看（查询已通过的未通过的）
            if (StringUtils.isNotBlank(status)) {
                criteria.add(Restrictions.eq("status", status));
            } /*else {
                criteria.add(Restrictions.or(Restrictions.eq("status", "1"), Restrictions.eq("status", "2")));
            }*/
        }
        if (StringUtils.isNotBlank(bjbm)) {
            if (bjbm.equals("8aa0bef8446c1a5e01446c1b29a20000")) {
                deptCriteria.add(Restrictions.like("code", "A%"));
            } else {
                deptCriteria.add(Restrictions.eq("id", bjbm));
            }
        }

        criteria.addOrder(Order.asc("status"));
        criteria.addOrder(Order.desc("applyDate"));
        Pageable<PCreditExamine> pageable = findByDetachedCriteriaWithPage(criteria, page);
        for (PCreditExamine PCreditExamine : pageable.getList()) {
            Hibernate.initialize(PCreditExamine.getCreateUser());
            Hibernate.initialize(PCreditExamine.getScxqbm());

            String[] scxxlIdStrArr = StringUtils.split(PCreditExamine.getScxxl(), ",");
            if (scxxlIdStrArr == null || scxxlIdStrArr.length == 0)
                continue;
            String scxxl = "";
            for (String scxxlId : scxxlIdStrArr) {
                Theme theme = this.get(Theme.class, scxxlId); // 获取资源名称
                if (theme == null)
                    continue;
                scxxl += theme.getTypeName() + ",";
            }
            PCreditExamine.setScxxlStr(StringUtils.substringBeforeLast(scxxl, ","));
        }
        return pageable;
    }

    @Override
    public Pageable<PCreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
                                                               String sqsjs, String sqsjz, String userId, String status) {
        DetachedCriteria criteria = DetachedCriteria.forClass(PCreditExamine.class);
        if (StringUtils.isNotBlank(scmc)) {
            criteria.add(EscapeChar.fuzzyCriterion("scmc", scmc));
        }
        if (StringUtils.isNotBlank(bjbh)) {
            criteria.add(EscapeChar.fuzzyCriterion("bjbh", bjbh));
        }
        if (StringUtils.isNotBlank(sqsjs)) {
            try {
                Date date = DateUtils.parseDate(sqsjs, DateUtils.YYYYMMDD_10);
                criteria.add(Restrictions.ge("applyDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (StringUtils.isNotBlank(sqsjz)) {
            try {
                Date date = DateUtils.parseDate(sqsjz, DateUtils.YYYYMMDD_10);
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                cal.add(Calendar.DATE, 1);
                date = cal.getTime();
                criteria.add(Restrictions.le("applyDate", date));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        SysUser user = findUserById(userId);
        String deptCode = user.getSysDepartment().getCode();
        String deptId = user.getSysDepartment().getId();
        if (StringUtils.equals(Constants.CENTER_DEPT_CODE, deptCode)) {
            if (StringUtils.isNotBlank(xqbm)) {
                criteria.add(Restrictions.eq("scxqbm.id", xqbm));
            }
        } else {
            if (StringUtils.isNotBlank(xqbm)) {
                criteria.add(Restrictions.eq("scxqbm.id", xqbm));
            } else {
                criteria.add(Restrictions.eq("scxqbm.id", deptId));
            }
        }
        if (StringUtils.isNotBlank(status)) {
            criteria.add(Restrictions.eq("status", status));
        }
        criteria.addOrder(Order.asc("status"));
        criteria.addOrder(Order.desc("applyDate"));
        Pageable<PCreditExamine> pageable = findByDetachedCriteriaWithPage(criteria, page);
        for (PCreditExamine PCreditExamine : pageable.getList()) {
            Hibernate.initialize(PCreditExamine.getCreateUser());
            Hibernate.initialize(PCreditExamine.getScxqbm());

            String[] scxxlIdStrArr = StringUtils.split(PCreditExamine.getScxxl(), ",");
            if (scxxlIdStrArr == null || scxxlIdStrArr.length == 0)
                continue;
            String scxxl = "";
            for (String scxxlId : scxxlIdStrArr) {
                Theme theme = this.get(Theme.class, scxxlId); // 获取资源名称
                if (theme == null)
                    continue;
                scxxl += theme.getTypeName() + ",";
            }
            PCreditExamine.setScxxlStr(StringUtils.substringBeforeLast(scxxl, ","));
        }
        return pageable;
    }

    @Override
    public PCreditExamineHis findCreditExamineHisByCreditExamineId(String id) {
        Criteria criteria = getSession().createCriteria(PCreditExamineHis.class);
        criteria.add(Restrictions.eq("pCreditExamine.id", id));
        criteria.addOrder(Order.desc("auditDate"));
        @SuppressWarnings("unchecked")
        List<PCreditExamineHis> list = criteria.list();
        PCreditExamineHis his = new PCreditExamineHis();
        if (list != null && list.size() != 0) {
            his = list.get(0);
        }
        return his;
    }

    @Override
    public UploadFile findUploadFile(String id, String type) {
        DetachedCriteria criteria = DetachedCriteria.forClass(UploadFile.class);
        criteria.add(Restrictions.eq("businessId", id)).add(Restrictions.eq("fileType", type));
        return uniqueByDetachedCriteria(criteria);
    }

    @Override
    public Pageable<PeopleExamine> getPeopleList(Page page, String id) {
        DetachedCriteria criteria = DetachedCriteria.forClass(PeopleExamine.class);
        criteria.add(Restrictions.eq("pCreditExamine.id", id));
        Pageable<PeopleExamine> pageable = findByDetachedCriteriaWithPage(criteria, page);
        return pageable;
    }

    @Override
    public boolean isPeopleExisted(String sfzh) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        boolean res = false;
        String sql = "SELECT count(1) FROM YW_P_GRJBXX WHERE SFZH = :I_SFZH ";

        param.put("I_SFZH", sfzh);
        int cnt = (int) countBySql(sql, param);

        if (cnt > 0) {
            res = true;
        }

        return res;
    }

    @Override
    public Pageable<PeopleExamine> findEnterpriseExamineWithPage(DetachedCriteria criteria, Page page) {
        return findByDetachedCriteriaWithPage(criteria, page);
    }

    @Override
    public long getCount(String sfzh, String tableName, Date scsjs, Date scsjz) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "select count(1) from " + tableName;
        sql += " where STATUS not in ("
                + CreditDataStatusEnum.已删除.getKey() + ","
                + CreditDataStatusEnum.已修复.getKey() + ") AND SFZH= :I_SFZH ";

        // 查询数据的时间段
        if (scsjs != null) {
            sql += "  AND CREATE_TIME >= :beginDate ";
            param.put("beginDate", scsjs);
        }
        if (scsjz != null) {
            sql += "  AND CREATE_TIME <= :endDate ";
            param.put("endDate", scsjz);
        }
        param.put("I_SFZH", sfzh);
        return countBySql(sql, param);
    }

//    @Override
//    public List<Map<String, Object>> findList(String sfzh, String type, Date scsjs, Date scsjz) {
//        HashMap<String, Object> param = new HashMap<>();
//        String querySql = "";
//        String tableName = "";
//        if ("sywy".equals(type)) {// 个人商业违约信息
//            tableName = "YW_P_GRSYWY";
//        } else if ("grcf".equals(type)) {// 个人行政处罚
//            tableName = "YW_P_GRXZCF";
//        } else if ("grzx".equals(type)) {// 个人法院执行信息（强制执行，比如罚款）
//            tableName = "YW_P_GRFYQZZX";
//        }
//        querySql += "SELECT * FROM " + tableName + " WHERE STATUS NOT IN ("
//                        + CreditDataStatusEnum.已删除.getKey() + ","
//                        + CreditDataStatusEnum.已修复.getKey() + ") AND "
//                        + " SFZH = :I_SFZH ";
//
//        // 查询数据的时间段
//        if (scsjs != null) {
//            querySql += "  AND CREATE_TIME >= :beginDate ";
//            param.put("beginDate", scsjs);
//        }
//        if (scsjz != null) {
//            querySql += "  AND CREATE_TIME <= :endDate ";
//            param.put("endDate", scsjz);
//        }
//
//        param.put("I_SFZH", sfzh);
//        querySql += " order by CREATE_TIME desc";
//        List<Map<String, Object>> resList = this.findBySql(querySql, param);
//        return resList;
//    }

    @Override
    public List<PeopleExamine> getPeopleList(String id) {
        DetachedCriteria criteria = DetachedCriteria.forClass(PeopleExamine.class);
        criteria.add(Restrictions.eq("pCreditExamine.id", id));
        return findByDetachedCriteria(criteria);
    }

    @Override
    public List<Map<String, Object>> findScxxMsg(Map<String, Object> existPeople, TemplateThemeNode two, Date beginDate, Date endDate) {

        String tableCode = two.getDataTable();
//        String xm = (String)existPeople.get("姓名");
        String sfzh = (String) existPeople.get("身份证号");
        String csfzh = "SFZH";
        HashMap<String, Object> param = new HashMap<>();
        if(StringUtils.endsWithIgnoreCase(tableCode, "YW_L_SGSXZXK")||StringUtils.endsWithIgnoreCase(tableCode, "YW_L_SGSXZCF")){
        	csfzh = "FDDBRSFZH";
        }
        String querySql = "SELECT * FROM " + tableCode + " WHERE STATUS NOT IN ("
                + CreditDataStatusEnum.已删除.getKey() + ","
                + CreditDataStatusEnum.已修复.getKey() + ") AND "
                + " "+csfzh+" = :I_SFZH ";

        // 查询数据的时间段
        if (beginDate != null) {
            querySql += "  AND TGRQ >= :beginDate ";
            param.put("beginDate", beginDate);
        }
        if (endDate != null) {
            querySql += "  AND TGRQ <= :endDate ";
            param.put("endDate", endDate);
        }

        TemplateThemeColumn column = getOrderColumn(two.getColumns());
        if (column != null) {
            querySql += " ORDER BY " + column.getColumnName() + " " + column.getDataOrder();
        }

        param.put("I_SFZH", sfzh);
        return this.findBySql(querySql, param);
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

}
