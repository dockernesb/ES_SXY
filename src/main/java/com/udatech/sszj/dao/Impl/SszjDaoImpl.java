package com.udatech.sszj.dao.Impl;

import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.Promise;
import com.udatech.sszj.dao.SszjDao;
import com.udatech.sszj.model.*;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.QueryConditions;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author dwc
 * @Title: SszjDaoImpl
 * @ProjectName creditservice
 * @Description: TODO
 * @date 2018/12/10  18:16
 */
@Repository
public class SszjDaoImpl extends BaseDaoImpl implements SszjDao {
    @Override
    public Pageable<Map<String, Object>> getSszjJbxxList(Page page, SszjJbxx sszjJbxx) {
        StringBuilder sb = new StringBuilder();
        sb.append("select t.id,                                             ");
        sb.append("       t.tyshxydm,                                       ");
        sb.append("       t.zzjgdm,                                         ");
        sb.append("       t.jgqc,                                           ");
        sb.append("       t.gszch,                                          ");
        sb.append("       t.sw_jgdm,                                        ");
        sb.append("       t.frdb_fzr,                                       ");
        sb.append("       t.wz,                                             ");
        sb.append("       t.jydz,                                           ");
        sb.append("       t.lxdh,                                           ");
        sb.append("       t.dept_id,                                        ");
        sb.append("       (select a.department_name from SYS_DEPARTMENT a where a.sys_department_id=t.dept_id) dept_name,");
        sb.append("       t.fwsx,                                           ");
        sb.append("       t.sfyj,                                           ");
        sb.append("       t.sfbz,                                           ");
        sb.append("       t.fwxm,                                           ");
        sb.append("       t.czlc,                                           ");
        sb.append("       t.dysp,                                           ");
        sb.append("       TO_CHAR(t.create_time, 'YYYY-MM-DD') create_time, ");
        sb.append("       t.create_id,");
        sb.append("       TO_CHAR(t.update_time, 'YYYY-MM-DD') update_time, ");
        sb.append("       t.update_id");
        sb.append("  from sszj_jbxx t                                       ");
        sb.append("	  where 1=1				                                ");
        if(sszjJbxx.getJgqc()!=null && StringUtils.isNotBlank(sszjJbxx.getJgqc())){
            sb.append(" and  t.jgqc like '%"+sszjJbxx.getJgqc().trim()+"%'                                         ");
        }
        if(sszjJbxx.getDeptId()!=null && StringUtils.isNotBlank(sszjJbxx.getDeptId())){
            sb.append(" and  t.dept_id in (select c.sys_department_id from SYS_DEPARTMENT c where c.department_name like '%"+sszjJbxx.getDeptId().trim()+"%' )");
        }
        Map<String, Object> params = new HashMap<String, Object>();
//        params.put("jgqc",sszjJbxx.getJgqc());
        String listSql = sb.toString();
        String countSql = "SELECT COUNT(1) FROM ( " + listSql + " ) A";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(listSql, countSql, page, params);

        return pageable;
    }

    @Override
    public Pageable<Map<String, Object>> getSszjZyzzList(Page page, SszjZyzz sszjZyzz) {
        StringBuilder sb = new StringBuilder();
        sb.append("select t.*,decode(t.state,'0','获取系统','1','手动录入','') statemc ");
        sb.append("  from SSZJ_ZYZZ t                                       ");
        sb.append("	  where 1=1				                                ");
        if(sszjZyzz.getTyshxydm()!=null && StringUtils.isNotBlank(sszjZyzz.getTyshxydm())){
            sb.append("	  and t.tyshxydm='"+sszjZyzz.getTyshxydm()+"'          ");
        }else{
            sb.append("	  and 1=2            ");
        }
        Map<String, Object> params = new HashMap<String, Object>();
//        params.put("tyshxydm",sszjZyzz.getTyshxydm());
        String listSql = sb.toString();
        String countSql = "SELECT COUNT(1) FROM ( " + listSql + " ) A";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(listSql, countSql, page, params);

        return pageable;
    }

    @Override
    public Pageable<Map<String, Object>> getSszjZyryList(Page page, SszjZyry sszjZyry) {
        StringBuilder sb = new StringBuilder();
        sb.append("select *                                             ");
        sb.append("  from SSZJ_ZYRY t                                       ");
        sb.append("	  where 1=1				                                ");
        if(sszjZyry.getTyshxydm()!=null && StringUtils.isNotBlank(sszjZyry.getTyshxydm())){
            sb.append("	  and t.tyshxydm='"+sszjZyry.getTyshxydm()+"'          ");
        }else{
            sb.append("	  and 1=2            ");
        }
        Map<String, Object> params = new HashMap<String, Object>();
//        params.put("tyshxydm",sszjZyry.getTyshxydm());
        String listSql = sb.toString();
        String countSql = "SELECT COUNT(1) FROM ( " + listSql + " ) A";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(listSql, countSql, page, params);

        return pageable;
    }

    @Override
    public void copyToZyzz(List<SszjZyzz> list) {
        this.saveAll(list);
    }

    @Override
    public Pageable<Map<String, Object>> getSszjPjdjList(Page page, SszjPjdj sszjPjdj) {
        StringBuilder sb = new StringBuilder();
        sb.append("select *                                             ");
        sb.append("  from sszj_pjdj t                                       ");
        sb.append("	  where 1=1				                                ");
        if(sszjPjdj.getTyshxydm()!=null && StringUtils.isNotBlank(sszjPjdj.getTyshxydm())){
            sb.append("	  and t.tyshxydm='"+sszjPjdj.getTyshxydm()+"'          ");
        }else{
            sb.append("	  and 1=2            ");
        }
        Map<String, Object> params = new HashMap<String, Object>();
//        params.put("tyshxydm",sszjPjdj.getTyshxydm());
        String listSql = sb.toString();
        String countSql = "SELECT COUNT(1) FROM ( " + listSql + " ) A";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(listSql, countSql, page, params);

        return pageable;
    }

    @Override
    public Pageable<Map<String, Object>> getSszjXycnList(Page page, SszjCreditCommitmentQy sszjCreditCommitmentQy) {
        StringBuilder sb = new StringBuilder();
//        sb.append("select *                                             ");
//        sb.append("  from sszj_credit_commitment_qy t                   ");
//        sb.append("	  where 1=1				                            ");
        sb.append("  SELECT                                                          ");
        sb.append("      A.ID,                                                       ");
        sb.append("      A.QYMC,                                                     ");
        sb.append("      A.GSZCH,                                                    ");
        sb.append("      A.ZZJGDM,                                                   ");
        sb.append("      A.TYSHXYDM,                                                 ");
        sb.append("      D.CODE DEPT_CODE,                                           ");
        sb.append("      D.DEPARTMENT_NAME DEPT_NAME,                                ");
        sb.append("      S.DICT_VALUE CNLB,                                          ");
        sb.append("      TO_CHAR(A.CREATE_TIME, 'YYYY-MM-DD') CREATE_TIME,           ");
        sb.append("      TO_CHAR(B.GSJZQ, 'YYYY-MM-DD') GSJZQ,                       ");
        sb.append("      NVL2(B.ID,'1','0') AS STATUS                                ");
        sb.append("  FROM (                                                          ");
        sb.append("      SELECT                                                      ");
        sb.append("          *                                                       ");
        sb.append("      FROM                                                        ");
        sb.append("          SSZJ_CREDIT_COMMITMENT_QY                                 ");
        sb.append("      WHERE 1=1                                                   ");

        if(sszjCreditCommitmentQy.getTyshxydm()!=null && StringUtils.isNotBlank(sszjCreditCommitmentQy.getTyshxydm())){
            sb.append("	  and TYSHXYDM='"+sszjCreditCommitmentQy.getTyshxydm()+"'          ");
        }else{
            sb.append("	  and 1=2            ");
        }

        sb.append(" ORDER BY CREATE_TIME DESC NULLS LAST");
        sb.append("  ) A                                                             ");
        sb.append("  LEFT JOIN YW_L_HEIMINGDAN B                                     ");
        sb.append("  ON A.QYMC = B.JGQC                                              ");
        sb.append("  OR A.GSZCH = B.GSZCH                                            ");
        sb.append("  OR A.ZZJGDM = B.ZZJGDM                                          ");
        sb.append("  OR A.TYSHXYDM = B.TYSHXYDM                                      ");
        sb.append("  LEFT JOIN SYS_DEPARTMENT D                                      ");
        sb.append("  ON A.DEPT_ID = D.SYS_DEPARTMENT_ID                              ");
        sb.append("  LEFT JOIN (SELECT DIC.DICT_KEY, DIC.DICT_VALUE                  ");
        sb.append("  FROM SYS_DICTIONARY DIC                                         ");
        sb.append("  LEFT JOIN SYS_DICTIONARY_GROUP G                                ");
        sb.append("  ON DIC.GROUP_ID = G.ID                                          ");
        sb.append("  WHERE G.GROUP_KEY = 'cnlb') S                                   ");
        sb.append("  ON S.DICT_KEY = A.CNLB                                          ");
        sb.append("  WHERE D.STATUS <> 1                                             ");
        sb.append("  ORDER BY DEPT_CODE,ID                                           ");

        Map<String, Object> params = new HashMap<String, Object>();
//        params.put("tyshxydm",sszjCreditCommitmentQy.getTyshxydm());
        String listSql = sb.toString();
        String countSql = "SELECT COUNT(1) FROM ( " + listSql + " ) A";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(listSql, countSql, page, params);

        return pageable;
    }

    @Override
    public List<UploadFile> getUploadFiles(String id, UploadFileEnmu type) {
        QueryConditions query = new QueryConditions();
        query.addEq("businessId",id);
        query.addEq("fileType", type.getKey());
        List<UploadFile> list = this.find(UploadFile.class, query);
        return list;
    }

    public Promise getPromiseById(String id) {
        String sql = "SELECT * FROM SSZJ_CREDIT_COMMITMENT WHERE ID = :id";
        Map<String, Object> map = new HashMap();
        map.put("id", id);
        List<Map<String, Object>> list = this.findBySql(sql, map);
        if (list == null || list.isEmpty()) {
            sql = "SELECT * FROM SSZJ_CREDIT_COMMITMENT_QY WHERE ID = :id";
            list = this.findBySql(sql, map);
        }

        if (list != null && !list.isEmpty()) {
            Map<String, Object> map1 = (Map)list.get(0);
            if (map1 != null) {
                String cnlb = (String)map1.get("CNLB");
                String deptId = (String)map1.get("DEPT_ID");
                Promise p = new Promise();
                p.setCnlbKey(cnlb);
                p.setDeptId(deptId);
                return p;
            }
        }

        return null;
    }

    public void updateTime(String cnlb, String deptId) {
        StringBuilder sb = new StringBuilder();
        sb.append(" UPDATE SSZJ_CREDIT_COMMITMENT SET UPDATE_TIME = SYSDATE ");
        sb.append(" WHERE CNLB = :cnlb AND DEPT_ID = :deptId ");
        Map<String, Object> map = new HashMap();
        map.put("cnlb", cnlb);
        map.put("deptId", deptId);
        this.executeUpdateSql(sb.toString(), map);
    }

    @Override
    public void deleteJbxxFileInfo(UploadFile file) {
        String sql = "DELETE FROM DT_UPLOAD_FILE WHERE business_id = :business_id and file_type = :file_type";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("business_id", file.getBusinessId());
        map.put("file_type", file.getFileType());
        this.executeUpdateSql(sql, map);
    }
}
