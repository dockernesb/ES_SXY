package com.udatech.common.creditCheck.dao.impl;

import com.udatech.common.constant.Constants;
import com.udatech.common.creditCheck.dao.CreditCheckDao;
import com.udatech.common.dataTrace.dao.DataTraceDao;
import com.udatech.common.dataTrace.vo.DataTraceVo;
import com.udatech.common.enmu.CreditDataStatusEnum;
import com.udatech.common.enmu.DataTraceItemEnum;
import com.udatech.common.enmu.DataTraceItemTypeEnum;
import com.udatech.common.model.CreditExamine;
import com.udatech.common.model.CreditExamineHis;
import com.udatech.common.model.EnterpriseExamine;
import com.udatech.common.resourceManage.model.Theme;
import com.udatech.common.resourceManage.vo.TemplateThemeColumn;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.DataSourceUtil;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
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
public class CreditCheckDaoImpl extends BaseDaoImpl implements CreditCheckDao {

    @Autowired
    private DataTraceDao dataTraceDao;

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
    public Pageable<CreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
                                                              String sqsjs, String sqsjz, String userId, String status, String type, String bjbm) {
        DetachedCriteria criteria = DetachedCriteria.forClass(CreditExamine.class);
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

        if (StringUtils.isNotBlank(xqbm)) {
            criteria.add(Restrictions.eq("scxqbm.id", xqbm));
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
        criteria.addOrder(Order.desc("id"));
        Pageable<CreditExamine> pageable = findByDetachedCriteriaWithPage(criteria, page);
        for (CreditExamine creditExamine : pageable.getList()) {
            Hibernate.initialize(creditExamine.getCreateUser());
            Hibernate.initialize(creditExamine.getScxqbm());

            String[] scxxlIdStrArr = StringUtils.split(creditExamine.getScxxl(), ",");
            if (scxxlIdStrArr == null || scxxlIdStrArr.length == 0)
                continue;
            String scxxl = "";
            for (String scxxlId : scxxlIdStrArr) {
                Theme theme = this.get(Theme.class, scxxlId); // 获取资源名称
                if (theme == null)
                    continue;
                scxxl += theme.getTypeName() + ",";
            }
            creditExamine.setScxxlStr(StringUtils.substringBeforeLast(scxxl, ","));
        }
        return pageable;
    }

    @Override
    public Pageable<CreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
                                                              String sqsjs, String sqsjz, String userId, String status) {
        DetachedCriteria criteria = DetachedCriteria.forClass(CreditExamine.class);
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
        Pageable<CreditExamine> pageable = findByDetachedCriteriaWithPage(criteria, page);
        for (CreditExamine creditExamine : pageable.getList()) {
            Hibernate.initialize(creditExamine.getCreateUser());
            Hibernate.initialize(creditExamine.getScxqbm());

            String[] scxxlIdStrArr = StringUtils.split(creditExamine.getScxxl(), ",");
            if (scxxlIdStrArr == null || scxxlIdStrArr.length == 0)
                continue;
            String scxxl = "";
            for (String scxxlId : scxxlIdStrArr) {
                Theme theme = this.get(Theme.class, scxxlId); // 获取资源名称
                if (theme == null)
                    continue;
                scxxl += theme.getTypeName() + ",";
            }
            creditExamine.setScxxlStr(StringUtils.substringBeforeLast(scxxl, ","));
        }
        return pageable;
    }

    @Override
    public String findCountByMonth4Bar(String month, String deptId) {
        String sql = "SELECT COUNT(1) CNT FROM DT_CREDIT_EXAMINE WHERE TO_CHAR(APPLY_DATE,'YYYY-MM') = :I_MONTH AND SYS_DEPARTMENT_ID = :I_DEPT ";
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("I_MONTH", month);
        param.put("I_DEPT", deptId);
        Map<String, Object> resMap = this.findBySql(sql, param).get(0);
        return resMap.get("CNT").toString();
    }

    @Override
    public List<Map<String, Object>> findCountByMonth4Pie(String deptId) {
        String sql = "SELECT STATUS,COUNT(STATUS) CNT FROM DT_CREDIT_EXAMINE "
                + "WHERE TO_CHAR(APPLY_DATE,'YYYY-MM') = TO_CHAR(SYSDATE,'YYYY-MM') AND SYS_DEPARTMENT_ID = :I_DEPT GROUP BY STATUS";
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("I_DEPT", deptId);
        return this.findBySql(sql, param);
    }

    @Override
    public CreditExamineHis findCreditExamineHisByCreditExamineId(String id) {
        Criteria criteria = getSession().createCriteria(CreditExamineHis.class);
        criteria.add(Restrictions.eq("creditExamine.id", id));
        criteria.addOrder(Order.desc("auditDate"));
        @SuppressWarnings("unchecked")
        List<CreditExamineHis> list = criteria.list();
        CreditExamineHis his = new CreditExamineHis();
        if (list != null && list.size() != 0) {
            his = list.get(0);
        }
        return his;
    }

    @Override
    public UploadFile findUploadFile(String id, String type) {
        DetachedCriteria criteria = DetachedCriteria.forClass(UploadFile.class);
        criteria.add(Restrictions.eq("businessId", id)).add(Restrictions.eq("fileType", type));
        List<UploadFile> list = findByDetachedCriteria(criteria);
        if (list != null && !list.isEmpty()) {
            return list.get(0);
        }
        return null;
    }

    @Override
    public Pageable<EnterpriseExamine> getEnterList(Page page, String id) {
        DetachedCriteria criteria = DetachedCriteria.forClass(EnterpriseExamine.class);
        criteria.add(Restrictions.eq("creditExamine.id", id));
        Pageable<EnterpriseExamine> pageable = findByDetachedCriteriaWithPage(criteria, page);
        return pageable;
    }

    @Override
    public boolean isEnterpriseExisted(String qymc, String zzjgdm, String gszch, String shxydm) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        boolean res = false;
        String sql = "SELECT count(1) FROM YW_L_JGSLBGDJ WHERE JGQC = :I_QYMC ";
        if (StringUtils.isNotBlank(shxydm)) {
            sql += "or TYSHXYDM = :I_SHXYDM ";
            param.put("I_SHXYDM", shxydm);
        }
        if (StringUtils.isNotBlank(zzjgdm)) {
            sql += " or ZZJGDM = :I_ZZJGDM";
            param.put("I_ZZJGDM", zzjgdm);
        }
        if (StringUtils.isNotBlank(gszch)) {
            sql += " or GSZCH = :I_GSZCH ";
            param.put("I_GSZCH", gszch);
        }
        param.put("I_QYMC", qymc);
        int cnt = (int) countBySql(sql, param);

        if (cnt > 0) {
            res = true;
        }

        return res;
    }

    @Override
    public Pageable<EnterpriseExamine> findEnterpriseExamineWithPage(DetachedCriteria criteria, Page page) {
        return findByDetachedCriteriaWithPage(criteria, page);
    }

    @Override
    public long getCount(String qymc, String gszch, String zzjgdm, String shxydm, String tableName,
                         Date scsjs, Date scsjz) {
        HashMap<String, Object> param = new HashMap<>();

        String sql = "select count(1) from " + tableName;
        sql += " where STATUS not in ("
                + CreditDataStatusEnum.已删除.getKey() + ","
                + CreditDataStatusEnum.已修复.getKey() + ") AND (JGQC= :I_JGQC ";
        if (StringUtils.isNotBlank(zzjgdm)) {
            sql += " or ZZJGDM = :I_ZZJGDM";
            param.put("I_ZZJGDM", zzjgdm);
        }
        if (StringUtils.isNotBlank(gszch)) {
            sql += " or GSZCH = :I_GSZCH ";
            param.put("I_GSZCH", gszch);
        }
        if (StringUtils.isNotBlank(shxydm)) {
            sql += " or TYSHXYDM = :I_SHXYDM ";
            param.put("I_SHXYDM", shxydm);
        }

        sql += ") ";
        // 查询数据的时间段
        if (scsjs != null) {
            sql += "  AND CREATE_TIME >= :beginDate ";
            param.put("beginDate", scsjs);
        }
        if (scsjz != null) {
            sql += "  AND CREATE_TIME <= :endDate ";
            param.put("endDate", scsjz);
        }

        sql += " order by CREATE_TIME desc";

        param.put("I_JGQC", qymc);
        return countBySql(sql, param);
    }

    @Override
    public List<EnterpriseExamine> getEnterList(String id) {
        DetachedCriteria criteria = DetachedCriteria.forClass(EnterpriseExamine.class);
        criteria.add(Restrictions.eq("creditExamine.id", id));
        return findByDetachedCriteria(criteria);
    }

    @Override
    public List<Map<String, Object>> findScxxMsg(String bjbh, Map<String, Object> enterMap, TemplateThemeNode two, String scsjs, String scsjz) {
        String tableName = two.getDataTable();
        String qymc = (String) enterMap.get("企业名称");
        String gszch = (String) enterMap.get("工商注册号");
        String zzjgdm = (String) enterMap.get("组织机构代码");
        String shxydm = (String) enterMap.get("统一社会信用代码");

        HashMap<String, Object> param = new HashMap<>();
        String querySql = "SELECT * FROM " + tableName + " WHERE STATUS NOT IN ("
                + CreditDataStatusEnum.已删除.getKey() + ","
                + CreditDataStatusEnum.已修复.getKey() + ") AND "
                + "(JGQC= :I_JGQC ";
        if (StringUtils.isNotBlank(shxydm)) {
            param.put("I_SHXYDM", shxydm);
            querySql += "or TYSHXYDM = :I_SHXYDM";
        }
        if (StringUtils.isNotBlank(zzjgdm)) {
            querySql += " or ZZJGDM = :I_ZZJGDM";
            param.put("I_ZZJGDM", zzjgdm);
        }
        if (StringUtils.isNotBlank(gszch)) {
            querySql += " or GSZCH = :I_GSZCH ";
            param.put("I_GSZCH", gszch);
        }

        querySql += ") ";
        // 查询数据的时间段
        if (scsjs != null) {
            querySql += "  AND TO_CHAR(TGRQ, 'YYYY-MM') >= :beginDate ";
            param.put("beginDate", scsjs);
        }
        if (scsjz != null) {
            querySql += "  AND TO_CHAR(TGRQ, 'YYYY-MM') <= :endDate ";
            param.put("endDate", scsjz);
        }

        param.put("I_JGQC", qymc);

        TemplateThemeColumn column = getOrderColumn(two.getColumns());
        if (column != null) {
            querySql += " ORDER BY " + column.getColumnName() + " " + column.getDataOrder();
        }

        List<Map<String, Object>> resList = DataSourceUtil.getDataSource(two.getDataSource()).queryForList(querySql, param);

        // 记录数据追溯
        for (Map<String, Object> resMap : resList) {
            DataTraceVo vo = new DataTraceVo();
            vo.setServiceNo(bjbh);
            vo.setTableName(tableName); // 被使用数据表
            vo.setId((String) resMap.get("ID")); // 被使用数据ID
            vo.setItem(DataTraceItemEnum.信用核查报告.getKey());
            vo.setItemType(DataTraceItemTypeEnum.信用核查.getKey());
            dataTraceDao.saveDataTrace(vo);
        }
        return resList;
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

    /**
     * 补全企业基本信息
     *
     * @param enterprise
     */
    public void fillEnterprise(EnterpriseExamine enterprise) {
        String gszch = enterprise.getGszch();
        String zzjgdm = enterprise.getZzjgdm();
        String tyshxydm = enterprise.getShxydm();

        if (StringUtils.isNotBlank(gszch) || StringUtils.isNotBlank(zzjgdm) || StringUtils.isNotBlank(tyshxydm)) {
            StringBuilder sb = new StringBuilder();
            sb.append(" SELECT * FROM YW_L_JGSLBGDJ ");
            sb.append(" WHERE GSZCH = :gszch OR ZZJGDM = :zzjgdm OR TYSHXYDM = :tyshxydm ");

            Map<String, Object> params = new HashMap<>();
            params.put("gszch", gszch);
            params.put("zzjgdm", zzjgdm);
            params.put("tyshxydm", tyshxydm);

            List<Map<String, Object>> list = this.findBySql(sb.toString(), params);

            if (list != null && !list.isEmpty()) {
                Map<String, Object> map = list.get(0);
                String g = (String) map.get("GSZCH");
                String z = (String) map.get("ZZJGDM");
                String t = (String) map.get("TYSHXYDM");

                if (StringUtils.isNotBlank(g) && StringUtils.isBlank(gszch)) {
                    enterprise.setGszch(g);
                }

                if (StringUtils.isNotBlank(z) && StringUtils.isBlank(zzjgdm)) {
                    enterprise.setZzjgdm(z);
                }

                if (StringUtils.isNotBlank(t) && StringUtils.isBlank(tyshxydm)) {
                    enterprise.setShxydm(t);
                }
            }
        }
    }

}
