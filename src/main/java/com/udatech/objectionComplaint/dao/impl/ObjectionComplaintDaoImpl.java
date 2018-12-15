package com.udatech.objectionComplaint.dao.impl;

import com.udatech.objectionComplaint.dao.ObjectionComplaintDao;
import com.udatech.objectionComplaint.model.DtUploadFile;
import com.udatech.objectionComplaint.model.ObjectionComplaint;
import com.udatech.objectionComplaint.model.ObjectionInfo;
import com.udatech.objectionComplaint.model.QueryConditionVo;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.dao.BaseDaoImpl;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author beijh
 * @date 2018-11-29 14:29
 */
@Repository
public class ObjectionComplaintDaoImpl extends BaseDaoImpl implements
        ObjectionComplaintDao {

    /**
     * @category  获取异议申诉列表
     * @param page
     * @return
     */
    public Pageable<Map<String, Object>> getObjectionList(QueryConditionVo vo, Page page) {
        String userId = CommonUtil.getCurrentUserId();
        StringBuilder sb = new StringBuilder();
        Map<String, Object> params = new HashMap<String, Object>();
        sb.append(" SELECT ID,COMPLAINT_TYPE,NAME,JSZ,PHONE_NUMBER,SSBZ,to_char(CREATE_DATE,'yyyy-MM-dd') CREATE_DATE,CREATE_ID,STATE,LINK_ID,BJBH,TYPE ");
        sb.append(" FROM DT_OBJECTION_COMPLAINT ");
        sb.append(" WHERE CREATE_ID=:userId ");

        params.put("userId", userId);

        if (StringUtils.isNotBlank(vo.getBjbh())) {
            sb.append(" AND BJBH LIKE :bjbh ");
            params.put("bjbh", "%"+vo.getBjbh()+"%");
        }

        if (StringUtils.isNotBlank(vo.getName())) {
            sb.append(" AND NAME LIKE :name ");
            params.put("name", "%"+vo.getName()+"%");
        }

        if (StringUtils.isNotBlank(vo.getJsz())) {
            sb.append(" AND JSZ LIKE :jsz ");
            params.put("jsz", "%"+vo.getJsz()+"%");
        }

        if (StringUtils.isNotBlank(vo.getBeginDate())) {
            sb.append(" AND TO_CHAR(CREATE_DATE, 'YYYY-MM-DD') >= :beginDate ");
            params.put("beginDate", vo.getBeginDate());
        }

        if (StringUtils.isNotBlank(vo.getEndDate())) {
            sb.append(" AND TO_CHAR(CREATE_DATE, 'YYYY-MM-DD') <= :endDate ");
            params.put("endDate", vo.getEndDate());
        }

        String countSql = "SELECT COUNT(*) FROM ( " + sb.toString() + " ) ";

        sb.append(" ORDER BY STATE ASC, CREATE_DATE DESC ");

        Pageable<Map<String, Object>> pageable = findBySqlWithPage(
                sb.toString(), countSql, page, params);

        return pageable;
    }

    @Override
    public List<Map<String,Object>> getComplainPerson(String str) {
        Map<String, Object> parameters = new HashMap<String, Object>();
        StringBuffer sql = new StringBuffer("select distinct name,jsz from ODS_JTSX_PEOPLE");
        if (org.apache.commons.lang.StringUtils.isNotBlank(str)) {
            sql.append(" where (name LIKE :str or jsz like :str ) ");
            parameters.put("str","%"+str+"%");
        }
        return this.findBySql(sql.toString(), parameters);
    }

    @Override
    public Pageable<Map<String, Object>> getCreditInfo(ObjectionInfo ei,
            Page page) {

        String jsz = ei.getJsz();
        String dataTable = ei.getDataTable();
        String businessId = ei.getBusinessId();
        String columns = ei.getFieldColumns();
        String type = ei.getType();
        String orderColName = ei.getOderColName();
        String orderType = ei.getOrderType();

        if (org.apache.commons.lang.StringUtils.isBlank(columns)) {
            return new SimplePageable<Map<String, Object>>();
        }
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuilder sb = new StringBuilder();
        sb.append(" SELECT ").append(columns);
        if (columns.indexOf("SXDJ") > -1) {
            sb.append(" FROM ( select ID,JTSXYY,case sxdj when '1' then '一般失信' when '2' then '较重失信' when '3' then '严重失信' else '' end SXDJ,SXRDDW,SXRDRQ,YXSJ ");
            sb.append(" FROM ").append(dataTable);
        } else {
            sb.append(" FROM ( select A.ID,A.FKJE,A.FXJGMC,A.HPHM,A.WFDZ,A.WFJFS,A.WFSJ,B.MC WFXW ");
            sb.append(" FROM ").append(dataTable);
            sb.append(" A LEFT JOIN ODS_T_CCM_WFXWDM B ON A.WFXW=B.DM ");
        }

        if ("1".equals(type)) { // 申请时过滤 1：已删除, 2：已修复的记录
            sb.append(" WHERE STATE != '1' AND STATE != '2'  ");
        }

        if (columns.indexOf("SXDJ") > -1) {
            if (org.apache.commons.lang.StringUtils.isNotBlank(jsz)) {
                sb.append(" AND JSZ = :jsz AND YXSJ > sysDate ");
                params.put("jsz", jsz);
            }
        } else {
            if (org.apache.commons.lang.StringUtils.isNotBlank(jsz)) {
                sb.append(" AND JSZH = :jsz ");
                params.put("jsz", jsz);
            }
        }

        if (org.apache.commons.lang.StringUtils.isNotBlank(orderColName) && org.apache.commons.lang.StringUtils.isNotBlank(orderType)) {
            sb.append(" ORDER BY ").append(orderColName).append(" ").append(orderType);
        }
        sb.append(" ) ");
        String querySql = sb.toString();
        String countSql = "SELECT COUNT(1) FROM (" + querySql + ") A";

        return this.findBySqlWithPage(querySql, countSql, page, params);
    }

    /**
     * @category 通过Id找到异议申请记录
     * @param
     * @return
     */
    @Override
    public ObjectionComplaint findObjectionByid(String id) {
        Session session = getSession();
        Criteria criteria = session.createCriteria(ObjectionComplaint.class);
        criteria.add(Restrictions.eq("id", id));
        ObjectionComplaint eo = (ObjectionComplaint) criteria.uniqueResult();
        return eo;
    }

    /**
     * @category 通过申诉id获取证明材料
     * @return
     */
    @Override
    public List<Map<String, Object>> findZmclById(String id) {
        StringBuffer sql = new StringBuffer();
        Map<String, Object> params = new HashMap<String, Object>();
        sql.append(" select FILE_NAME,FILE_PATH from DT_UPLOAD_FILE where BUSINESS_ID=:id ");
        params.put("id",id);
        return findBySql(sql.toString(),params);
    }

    /**
     * @category 获取具体申诉的信用信息
     * @param dataTable
     * @param thirdId
     * @return
     */
    @Override
    public List<Map<String, Object>> getCreditDetail(String dataTable, String thirdId, String type, List<Map<String, Object>> fieldList) {
        if (StringUtils.isNotBlank(dataTable)
                && StringUtils.isNotBlank(thirdId) && fieldList != null
                && !fieldList.isEmpty()) {

            StringBuilder sb = new StringBuilder();
            sb.append(" SELECT ID ");

            for (Map<String, Object> map : fieldList) {
                String col = (String) map.get("COLUMN_NAME");
                if (StringUtils.isNotBlank(col)) {
                    sb.append(", ").append(col);
                }
            }
            if (type.equals("1")) {
                sb.append(" FROM ( select ID,JTSXYY,case sxdj when '1' then '一般失信' when '2' then '较重失信' when '3' then '严重失信' else '' end SXDJ,SXRDDW,SXRDRQ,YXSJ ");
                sb.append(" FROM ").append(dataTable);
                sb.append(" WHERE ID = :id )");
            } else {
                sb.append(" FROM ( select A.ID,A.FKJE,A.FXJGMC,A.HPHM,A.WFDZ,A.WFJFS,A.WFSJ,B.MC WFXW ");
                sb.append(" FROM ").append(dataTable);
                sb.append(" A LEFT JOIN ODS_T_CCM_WFXWDM B ON A.WFXW=B.DM ");
                sb.append(" WHERE A.ID = :id )");
            }

            SQLQuery query = getSession().createSQLQuery(sb.toString());
            query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
            query.setString("id", thirdId);

            Map<String, Object> result = (Map<String, Object>) query
                    .uniqueResult();

            if (result != null && !result.isEmpty()) {
                for (Map<String, Object> map : fieldList) {
                    String col = (String) map.get("COLUMN_NAME");
                    if (StringUtils.isNotBlank(col)) {
                        Object obj = result.get(col);
                        map.put("DATA", obj);
                    }
                }
                return fieldList;
            }

        }
        return null;
    }

    /**
     * @category 通过申诉Id找到申诉的证明材料
     * @return
     */
    @Override
    public List<DtUploadFile> uploadFiles(String id) {
        Session session = getSession();
        Criteria criteria = session.createCriteria(DtUploadFile.class);
        criteria.add(Restrictions.eq("businessId", id));
        List<DtUploadFile> files = criteria.list();
        return files;
    }

    @Override
    public void updateByLinkId(String dataTable, String linkId) {
        StringBuffer sql = new StringBuffer();
        sql.append(" update ");
        sql.append(dataTable);
        sql.append(" set STATE = '2' where ID = :id ");
        Map<String,Object> params = new HashMap<>();
        params.put("id",linkId);
        this.executeUpdateSql(sql.toString(), params) ;
    }

}
