package com.udatech.center.dpChineseTheme.dao.impl;

import com.udatech.center.dpChineseTheme.dao.DpChineseDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class DpChineseDaoImpl extends BaseDaoImpl implements DpChineseDao {

    /**
     * @Description: 获取表格中的数据信息.
     * @see： @see com.udatech.center.dpChineseTheme.dao.DpChineseDao#getQueryList(java.lang.String, java.lang.String,
     *       java.lang.String, java.lang.String, java.lang.String, java.lang.String, com.wa.framework.Page)
     * @since JDK 1.7
     */
    @Override
    public Pageable<Map<String, Object>> getQueryList(String msgType, String tableCoulmn, String coulmnValue,
                                                      String beginDate, String endDate, String status, Page page) {
        StringBuffer sql = new StringBuffer();
        Map<String, Object> params = new HashMap<String, Object>();
        if ("1".equals(msgType)) {
            sql.append(" select * from YW_L_SGSXZXK ");
            sql.append(" where 1=1 ");

        } else if ("2".equals(msgType)) {
            sql.append(" select * from YW_L_SGSXZCF ");
            sql.append(" where 1=1 ");

        }

        if (StringUtils.isNotBlank(tableCoulmn)) {
            if(StringUtils.equalsIgnoreCase(tableCoulmn, "XKSXQ")){
                sql.append(" and " + tableCoulmn + " = to_date(:coulmnValue, 'yyyy-mm-dd hh24:mi:ss')  ");
                params.put("coulmnValue", coulmnValue);
            }else if(StringUtils.equalsIgnoreCase(tableCoulmn, "XKJZQ")){
                sql.append(" and " + tableCoulmn + " = to_date(:coulmnValue, 'yyyy-mm-dd hh24:mi:ss')  ");
                params.put("coulmnValue", coulmnValue);
            }else if(StringUtils.equalsIgnoreCase(tableCoulmn, "GXSJC")){
                //sql.append(" and to_char(" + tableCoulmn + ", 'yyyy-mm-dd hh24:mi:ss') = :coulmnValue ");
                sql.append(" and " + tableCoulmn + " = to_date(:coulmnValue, 'yyyy-mm-dd hh24:mi:ss')  ");
                params.put("coulmnValue", coulmnValue);
            }else if(StringUtils.equalsIgnoreCase(tableCoulmn, "GSJZQ")){
                sql.append(" and " + tableCoulmn + " = to_date(:coulmnValue, 'yyyy-mm-dd hh24:mi:ss')  ");
                params.put("coulmnValue", coulmnValue);
            }else if(StringUtils.equalsIgnoreCase(tableCoulmn, "CFSXQ")){
                sql.append(" and " + tableCoulmn + " = to_date(:coulmnValue, 'yyyy-mm-dd hh24:mi:ss')  ");
                params.put("coulmnValue", coulmnValue);
            }else if(StringUtils.equalsIgnoreCase(tableCoulmn, "CFJZQ")){
                sql.append(" and " + tableCoulmn + " = to_date(:coulmnValue, 'yyyy-mm-dd hh24:mi:ss')  ");
                params.put("coulmnValue", coulmnValue);
            }else {
                sql.append(" and " + tableCoulmn + " like :coulmnValue ESCAPE '\\' ");
                coulmnValue = "%" + EscapeChar.escape(coulmnValue) + "%";
                params.put("coulmnValue", coulmnValue);
            }
        }

        if (StringUtils.isNotBlank(beginDate)) {
            sql.append(" AND TO_CHAR(CREATE_TIME, 'yyyy-MM-dd hh24:mi:ss') >= :beginDate ");
            beginDate += " 00:00:00";
            params.put("beginDate", beginDate);
        }
        if (StringUtils.isNotBlank(endDate)) {
            sql.append(" AND TO_CHAR(CREATE_TIME, 'yyyy-MM-dd hh24:mi:ss') <= :endDate ");
            endDate += " 23:59:59";
            params.put("endDate", endDate);
        }

        if (StringUtils.isNotBlank(status)) {
            sql.append(" and CHINESE_STATUS = :status ");
            params.put("status", status);
        }
        sql.append(" ORDER BY CHINESE_TJRQ DESC ");
        String listSql = sql.toString();
        String countSql = "SELECT COUNT(1) FROM ( " + listSql + " ) A";

        Pageable<Map<String, Object>> pageable = this.findBySqlWithPage(listSql, countSql, page, params);

        return pageable;
    }

    /**
     * @Description: 获取双公示信息表的字段信息.
     * @see： @see com.udatech.center.dpChineseTheme.dao.DpChineseDao#getTableColumn(java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public List<Map<String, Object>> getTableColumn(String msgType) {
        String sql = "";
        if ("1".equals(msgType)) {
            sql = " SELECT t.table_name, t.colUMN_NAME, t1.COMMENTS FROM User_Tab_Cols t, User_Col_Comments t1 "
                    + " WHERE t.table_name = t1.table_name  AND t.column_name = t1.column_name  AND T.table_name = 'YW_L_SGSXZXK' "
                    + " AND t1.column_name NOT IN ('ID', 'STATUS', 'CREATE_USER','BMBM','BMMC','TGRQ','RWBH','SOURCE','CREATE_TIME','JGDJ_ID', "
                    + " 'PROVINCE_STATUS','CHINESE_STATUS','PROVINCE_TJRQ','PROVINCE_ERROR' ) "
                    + " order by t.colUMN_NAME desc ";
        } else if ("2".equals(msgType)) {
            sql = " SELECT t.table_name, t.colUMN_NAME, t1.COMMENTS FROM User_Tab_Cols t, User_Col_Comments t1 "
                    + " WHERE t.table_name = t1.table_name  AND t.column_name = t1.column_name  AND T.table_name = 'YW_L_SGSXZCF' "
                    + " AND t1.column_name NOT IN ('ID', 'STATUS', 'CREATE_USER','BMBM','BMMC','TGRQ','RWBH','SOURCE','CREATE_TIME','JGDJ_ID', "
                    + " 'CFLB2','PROVINCE_STATUS','CHINESE_STATUS','PROVINCE_TJRQ','PROVINCE_ERROR' ) "
                    + " order by t.colUMN_NAME desc ";

        }
        return this.findBySql(sql);
    }

    @Override
    public Map<String, Object> getFindBySql(String sql, Map<String, Object> map) {

        return this.uniqueBySql(sql, map);
    }

    /**
     * @Description: 单选提交数据（保存当前的状态和时间）.
     * @see： @see com.udatech.center.dpChineseTheme.dao.DpChineseDao#changeProvinceStatus(java.lang.String,
     *       java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public void changeProvinceStatus(String id, String msgType, String resultType, String error) {
        String sql = "";
        Map<String, Object> params = new HashMap<String, Object>();
        Date date = new Date(System.currentTimeMillis());
        if ("1".equals(msgType)) {
            if ("3".equals(resultType)) {
                sql = "UPDATE YW_L_SGSXZXK SET CHINESE_STATUS = 1 , CHINESE_TJRQ = :date WHERE ID = :id";
            } else if ("4".equals(resultType)) {
                params.put("error", error);
                sql = "UPDATE YW_L_SGSXZXK SET CHINESE_STATUS = 2 , CHINESE_TJRQ = :date,CHINA_ERROR= :error WHERE ID = :id";
            }
        } else if ("2".equals(msgType)) {
            if ("3".equals(resultType)) {
                sql = "UPDATE YW_L_SGSXZCF SET CHINESE_STATUS = 1 , CHINESE_TJRQ = :date WHERE ID = :id";
            } else if ("4".equals(resultType)) {
                params.put("error", error);
                sql = "UPDATE YW_L_SGSXZCF SET CHINESE_STATUS = 2 , CHINESE_TJRQ = :date,CHINA_ERROR= :error WHERE ID = :id";
            }
        }

        params.put("id", id);
        params.put("date", date);

        this.executeUpdateSql(sql, params);

    }

    /**
     * @Description: 单选提交数据（将单选的数据添加到dr表中）.
     * @see： @see com.udatech.center.dpChineseTheme.dao.DpChineseDao#insertData(java.lang.String, java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public void insertData(String id, String msgType) {
        StringBuffer sql = new StringBuffer();
        if ("1".equals(msgType)) {
            sql.append("INSERT INTO DR_SGSXZXK SELECT * FROM ( ");
            sql.append(" select id, status, source, create_time, create_user, bmbm, bmmc, tgrq, rwbh, zzjgdm, jgqcyw, ");
            sql.append(" jgqc, gszch, tyshxydm,bz, xkjdswh, xmmc, xzxkbm, splb, xknr, xzxdrmc, swdjh, fddbrmc, fddbrsfzh, ");
            sql.append(" xksxq, xkjzq, xkjg, dqzt, dfbm, gxsjc,syfw, gsjzq, xzxdrswdjh, jgdj_id, ");
            sql.append(" t.chinese_status as SBZT,t.chinese_tjrq AS TJRQ,'1' AS SBLX,CHINA_ERROR,'' AS PROVINCE_ERROR ");
            sql.append(" from yw_l_sgsxzxk t ) p");
            sql.append(" WHERE ID = :id ");
        } else if ("2".equals(msgType)) {
            sql.append("INSERT INTO DR_SGSXZCF SELECT * FROM ( ");
            sql.append(" select id, status, source, create_time, create_user, bmbm, bmmc, tgrq, rwbh, zzjgdm, jgqcyw, jgqc, gszch, tyshxydm, ");
            sql.append(" bz, cfjdswh, ajmc, cfbm, cfsy, cfyj, cfzl, cfjg, cfdj, cfsxq, cfjzq, xzxdrmc, fddbrmc, fddbrsfzh, cfjgmc, dqzt, dfbm,"
                    + " gxsjc, syfw, gsjzq, xzxdrswdjh, jgdj_id, cflb2,");
            sql.append(" t.chinese_status as SBZT,t.chinese_tjrq AS TJRQ,'1' AS SBLX,CHINA_ERROR,'' AS PROVINCE_ERROR ");
            sql.append(" from yw_l_sgsxzcf t ) p");
            sql.append(" WHERE ID = :id ");
        }
        String querySql = sql.toString();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("id", id);
        this.executeUpdateSql(querySql, params);

    }

}
