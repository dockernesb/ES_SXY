package com.udatech.center.dpThemeViewLog.dao.impl;

import com.udatech.center.dpThemeViewLog.dao.DpThemeLogDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class DpThemeLogDaoImpl extends BaseDaoImpl implements DpThemeLogDao {

    /**
     * 
     * @Description: 查询表格相关数据. 
     * @see： @see com.udatech.center.dpThemeViewLog.dao.DpThemeLogDao#getDataList(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, com.wa.framework.Page)
     * @since JDK 1.7
     */
    @Override
    public Pageable<Map<String, Object>> getDataList(String msgType, String status, String beginDate, String endDate,
                    String sblx,Page page) {
        StringBuffer sql = new StringBuffer(); 
        Map<String, Object> params = new HashMap<String, Object>();
        if("1".equals(msgType)){
            sql.append(" select * from DR_SGSXZXK ");
            
            
        }else if ("2".equals(msgType)){
            sql.append(" select * from DR_SGSXZCF ");
            
        }
        sql.append(" where 1=1 ");
        if(StringUtils.isNotBlank(status)){
            sql.append(" and SBZT = :T_STATUS ");
            params.put("T_STATUS", status);
        }
        if(StringUtils.isNotBlank(sblx)){
            sql.append(" and SBLX = :sblx ");
            params.put("sblx", sblx);
        }
        if (StringUtils.isNotBlank(beginDate)) {
            sql.append(" AND TO_CHAR(TJRQ, 'yyyy-MM-dd hh24:mi:ss') >= :beginDate ");
            beginDate += " 00:00:00 ";
            params.put("beginDate", beginDate);
        }
        if (StringUtils.isNotBlank(endDate)) {
            sql.append(" AND TO_CHAR(TJRQ, 'yyyy-MM-dd hh24:mi:ss') <= :endDate ");
            endDate += " 23:59:59 ";
            params.put("endDate", endDate);
        }
        sql.append(" ORDER BY TJRQ DESC");
        String listSql = sql.toString();      
        String countSql = "SELECT COUNT(1) FROM ( " + listSql + " ) A";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(listSql, countSql, page, params);

        return pageable;
    }

    /**
     * 
     * @Description: 动态获取表格中的表字段名称. 
     * @see： @see com.udatech.center.dpThemeViewLog.dao.DpThemeLogDao#getTableColumn(java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public List<Map<String, Object>> getTableColumn(String msgType) {
        String sql ="";
        if("1".equals(msgType)){
           sql=" SELECT t.table_name, t.colUMN_NAME, t1.COMMENTS FROM User_Tab_Cols t, User_Col_Comments t1 "
                            + " WHERE t.table_name = t1.table_name  AND t.column_name = t1.column_name  AND T.table_name = 'DR_SGSXZXK' "
                            + " AND t1.column_name NOT IN ('ID', 'STATUS', 'CREATE_USER','BMBM','BMMC','TGRQ','RWBH','SOURCE','CREATE_TIME','JGDJ_ID','SBZT','TJRQ','SBLX' )";
        }else if("2".equals(msgType)){
            sql=" SELECT t.table_name, t.colUMN_NAME, t1.COMMENTS FROM User_Tab_Cols t, User_Col_Comments t1 "
                            + " WHERE t.table_name = t1.table_name  AND t.column_name = t1.column_name  AND T.table_name = 'DR_SGSXZCF' "
                            + " AND t1.column_name NOT IN ('ID', 'STATUS', 'CREATE_USER','BMBM','BMMC','TGRQ','RWBH','SOURCE','CREATE_TIME','JGDJ_ID', "
                            + " 'CFLB2','SBZT','TJRQ','SBLX') ";
        
        }
        return this.findBySql(sql);
        
    }

    /**
     * 
     * @Description: 导出表格时获取到的所有字段信息. 
     * @see： @see com.udatech.center.dpThemeViewLog.dao.DpThemeLogDao#queryColumnData(java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public List<Map<String, Object>> queryColumnData(String msgType) {
        String sql ="";
        if("1".equals(msgType)){
           sql=" SELECT t.table_name, t.colUMN_NAME, t1.COMMENTS FROM User_Tab_Cols t, User_Col_Comments t1 "
                            + " WHERE t.table_name = t1.table_name  AND t.column_name = t1.column_name  AND T.table_name = 'DR_SGSXZXK' "
                            + " AND t1.column_name NOT IN ('ID', 'STATUS', 'CREATE_USER','BMBM','BMMC','TGRQ','RWBH','SOURCE','CREATE_TIME','JGDJ_ID' )";
        }else if("2".equals(msgType)){
            sql=" SELECT t.table_name, t.colUMN_NAME, t1.COMMENTS FROM User_Tab_Cols t, User_Col_Comments t1 "
                            + " WHERE t.table_name = t1.table_name  AND t.column_name = t1.column_name  AND T.table_name = 'DR_SGSXZCF' "
                            + " AND t1.column_name NOT IN ('ID', 'STATUS', 'CREATE_USER','BMBM','BMMC','TGRQ','RWBH','SOURCE','CREATE_TIME','JGDJ_ID', "
                            + " 'CFLB2') ";
        
        }
        return this.findBySql(sql);
    }

    
}
