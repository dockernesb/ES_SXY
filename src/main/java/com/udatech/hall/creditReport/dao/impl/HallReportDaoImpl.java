package com.udatech.hall.creditReport.dao.impl;

import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.hall.creditReport.dao.HallReportDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.dictionary.vo.SysDictionaryVo;
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

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <描述>：信用报告申请信息（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:52:33
 */
@Repository
public class HallReportDaoImpl extends BaseDaoImpl implements HallReportDao {

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
     * @category 获取信用报告申请信息列表
     * @param ei
     * @param page
     * @return
     */
    public Pageable<EnterpriseReportApply> getReportList(EnterpriseInfo ei, Map<String, Object> params, Page page) {
        DetachedCriteria criteria = DetachedCriteria.forClass(EnterpriseReportApply.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");

        String xybgbh = MapUtils.getString(params, "xybgbh");
        String isHasBasic = MapUtils.getString(params, "isHasBasic");
        String isHasReport = MapUtils.getString(params, "isHasReport");
        String isIssue = MapUtils.getString(params, "isIssue");
        String jbr = MapUtils.getString(params,"jbr");

        if(StringUtils.isNotBlank(jbr)){
			criteria.add(EscapeChar.fuzzyCriterion("jbrxm",jbr));
		}
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
            if(status.equals("0")){ // 待审核
            criteria.add(Restrictions.eq("status", "0"));
            } else if (status.equals("1")){ //待下发
                criteria.add(Restrictions.eq("status", "1"));
                criteria.add(Restrictions.eq("isIssue", "0"));
            }else if (status.equals("2")){ //已驳回
                criteria.add(Restrictions.eq("status", "2"));
            }else if (status.equals("3")){ // 待打印
                criteria.add(Restrictions.eq("status", "1"));
                criteria.add(Restrictions.eq("isIssue", "1"));
            }else if (status.equals("4")){ // 已办结
                criteria.add(Restrictions.eq("status", "1"));
                criteria.add(Restrictions.eq("isIssue", "2"));
            }
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

      /*  if (StringUtils.isNotBlank(isIssue)) {
            criteria.add(Restrictions.eq("isIssue", isIssue));
        }*/


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

    public Pageable<EnterpriseReportApply> getReportIssueList(EnterpriseInfo ei, Map<String, Object> params, Page page) {

        DetachedCriteria criteria = DetachedCriteria.forClass(EnterpriseReportApply.class);
        DetachedCriteria userCriteria = criteria.createCriteria("createUser", "user");
        DetachedCriteria deptCriteria = userCriteria.createCriteria("sysDepartment", "dept");

        String xybgbh = MapUtils.getString(params, "xybgbh");
        String isHasBasic = MapUtils.getString(params, "isHasBasic");
        String isHasReport = MapUtils.getString(params, "isHasReport");
        criteria.add(Restrictions.isNotNull("xybgbh"));
        criteria.add(Restrictions.eq("isIssue","1"));//默认页面查到都是已下发的数据

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

    @Override
    public List<SysDictionaryVo> queryByGroupKey(String groupKey) {
        String querySql = "SELECT A.ID,A.DICT_KEY,A.DICT_VALUE FROM SYS_DICTIONARY A LEFT JOIN SYS_DICTIONARY_GROUP G ON A.GROUP_ID=G.ID WHERE G.GROUP_KEY= :groupKey order BY A.DICT_VALUE ASC ";
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("groupKey", groupKey);
        List<Map<String, Object>> list = this.findBySql(querySql, parameterMap);

        List<SysDictionaryVo> resList = new ArrayList<SysDictionaryVo>();
        for (Map<String, Object> map : list) {
            SysDictionaryVo vo = new SysDictionaryVo();
            vo.setId(MapUtils.getString(map, "ID"));
            vo.setDictKey(MapUtils.getString(map, "DICT_KEY"));
            vo.setDictValue(MapUtils.getString(map, "DICT_VALUE"));
            resList.add(vo);
        }
        return resList;
    }

    /**
     *
     * @Description: 打印页面中，新增的已办结按钮，在下发状态IS_ISSUE中，新增一个数值为2就是已办结值
     * @see： @see com.udatech.hall.creditReport.dao.HallReportDao#finishPrintTaskByIsIssue(com.udatech.common.model.EnterpriseReportApply)
     * @since JDK 1.6
     */
    @Override
    public void finishPrintTaskByIsIssue(EnterpriseReportApply enterpriseReportApply) {
        String sql =" UPDATE DT_ENTERPRISE_REPORT_APPLY  SET IS_ISSUE=2 where ID=:id";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("id",enterpriseReportApply.getId());
        this.executeUpdateSql(sql, params);

    }


}
