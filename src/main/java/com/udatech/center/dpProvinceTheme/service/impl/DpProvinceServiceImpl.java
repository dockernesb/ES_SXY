package com.udatech.center.dpProvinceTheme.service.impl;

import com.udatech.center.dpProvinceTheme.dao.DpProvinceDao;
import com.udatech.center.dpProvinceTheme.service.DpProvinceService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.util.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DpProvinceServiceImpl implements DpProvinceService {

    // private Logger log = Logger.getLogger(DpProvinceServiceImpl.class);
    @Autowired
    private DpProvinceDao dpProvincedao;

    @Autowired
    private NamedParameterJdbcTemplate jdbcTemplateQzj;

    /**
     * @Description: 获取到表格字段信息7.
     * @see： @see com.udatech.center.dpProvinceTheme.service.DpProvinceService#getTableColumn(java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public List<Map<String, Object>> getTableColumn(String msgType) {

        return dpProvincedao.getTableColumn(msgType);
    }

    /**
     * @Description: 获取表格中的数据.
     * @see： @see com.udatech.center.dpProvinceTheme.service.DpProvinceService#getQueryList(java.lang.String,
     *       java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String,
     *       com.wa.framework.Page)
     * @since JDK 1.7
     */
    @Override
    public Pageable<Map<String, Object>> getQueryList(String msgType, String tableCoulmn, String coulmnValue,
                    String beginDate, String endDate, String status, Page page) {

        return dpProvincedao.getQueryList(msgType, tableCoulmn, coulmnValue, beginDate, endDate, status, page);
    }

    /**
     * @Description: 单选提交数据（保存当前的状态和时间）.
     * @see： @see com.udatech.center.dpProvinceTheme.service.DpProvinceService#changeProvinceStatus(java.lang.String,
     *       java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public void changeProvinceStatus(String id, String msgType) {
        dpProvincedao.changeProvinceStatus(id, msgType);
    }

    /**
     * @Description: 通过id值查询到省平台前置库中对应的数据，（字段名要起别名，为了和前置库的字段匹配）
     * @param: @param id
     * @param: @param msgType
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.7
     */
    private Map<String, Object> queryDataProvince(String id, String msgType) {
        String sql = "";
        Map<String, Object> map = new HashMap<String, Object>();
        if ("1".equals(msgType)) {
            sql = "select id as RECID, zzjgdm as XK_XDR_ZDM, gszch as XK_XDR_GSDJ,tyshxydm as XK_XDR_SHXYM, bz,xkjdswh as XK_WSH, "
                            + "xmmc as XK_XMMC, xzxkbm AS XK_BM, splb as XK_SPLB, xknr as XK_NR,xzxdrmc as XK_XDR,fddbrmc as XK_FR,"
                            + " fddbrsfzh as XK_XDR_SFZ,  TO_CHAR(xksxq, 'YYYY/MM/DD') as XK_JDRQ, TO_CHAR(xkjzq, 'YYYY/MM/DD') as XK_JZQ, xkjg as XK_XZJG,case when DQZT not in ('0', '1', '2', '3') then '0' else nvl(DQZT,0) end XK_ZT, dfbm as DFBM, "
                            + " TO_CHAR(gxsjc, 'YYYY/MM/DD') as SJC, case when SYFW not in ('0', '1', '2', '3') then '0' else nvl(SYFW,0) end XK_SYFW, xzxdrswdjh as XK_XDR_SWDJ "
                            + " from YW_L_SGSXZXK where id = :id ";
            map.put("id", id);
        } else if ("2".equals(msgType)) {
            sql = " select id as RECID,zzjgdm as CF_XDR_ZDM,gszch as CF_XDR_GSDJ,tyshxydm as CF_XDR_SHXYM,bz,cfjdswh as CF_WSH,ajmc as CF_CFMC,cfbm AS CF_BM,"
                            + "cfsy as CF_SY,cfyj as CF_YJ,cfzl as CF_CFLB1,cfjg as CF_JG,cfdj AS CF_SXYZCD,TO_CHAR(cfsxq, 'YYYY/MM/DD') as CF_JDRQ,TO_CHAR(cfjzq, 'YYYY/MM/DD') AS CF_JZQ,"
                            + "xzxdrmc as CF_XDR_MC,fddbrmc AS CF_FR,fddbrsfzh as CF_XDR_SFZ,cfjgmc as CF_XZJG, case when DQZT not in ('0', '1', '2', '3') then '0' else nvl(DQZT,0) end CF_ZT,dfbm as DFBM,TO_CHAR(gxsjc, 'YYYY/MM/DD') as SJC,"
                            + "case when SYFW not in ('0', '1', '2', '3') then '0' else nvl(SYFW,0) end CF_SYFW,TO_CHAR(gsjzq,'YYYY/MM/DD') AS CF_GSJZQ,xzxdrswdjh as CF_XDR_SWDJ,cflb2 as CF_CFLB2 "
                            + " from YW_L_SGSXZCF where id = :id ";
            map.put("id", id);
        }
        return dpProvincedao.getFindBySql(sql, map);
    }

    /**
     * @Description: 单选提交数据（将单选的数据添加到dr表中）.
     * @see： @see com.udatech.center.dpProvinceTheme.service.DpProvinceService#insertData(java.lang.String,
     *       java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public void insertData(String id, String msgType) {
        dpProvincedao.insertData(id, msgType);

    }

    /**
     * @Description: 将单选或多选的数据提交到省平台的前置库
     * @see： @see com.udatech.center.dpProvinceTheme.service.DpProvinceService#insertQzkData(java.lang.String,
     *       java.lang.String)
     * @since JDK 1.7
     */

    @Override
    public Map<String, Object> insertQzkData(String id, String msgType) {
        StringBuffer sql = new StringBuffer();
        StringBuffer sql1 = new StringBuffer();
        Map<String, Object> Hashmap = new HashMap<String, Object>();
        Map<String, Object> map = queryDataProvince(id, msgType);
        if ("1".equals(msgType)) {
            sql.append("INSERT INTO L_SUZHOU_XZXK ( ");
        } else if ("2".equals(msgType)) {
            sql.append("INSERT INTO L_SUZHOU_XZCF ( ");
        }
        sql1.append("( ");
        for (Map.Entry<String, Object> s : map.entrySet()) {
            sql.append(s.getKey()).append(",");
            sql1.append(":").append(s.getKey()).append(",");
        }
        sql.deleteCharAt(sql.length() - 1).append(") values ")
                        .append(sql1.deleteCharAt(sql1.length() - 1).append(")").toString());
        String querySql = sql.toString();
        map.put("SJC", map.get("SJC") != null ? new Date(DateUtils.parseDate((String) map.get("SJC"), "yyyy/MM/dd")
                        .getTime()) : new Date(System.currentTimeMillis()));
        // System.out.println(querySql);

        int succ = 0;
        int fail = 0;
        String reslutType = null;
        try {
            reslutType = "1";
            jdbcTemplateQzj.update(querySql, map);
            dpProvincedao.changeProvinceStatus(id, msgType);
            succ++;
        } catch (org.springframework.jdbc.UncategorizedSQLException e) {
            reslutType = "2";
            String error = "存在字段长度不匹配";
            dpProvincedao.changeProvinceFailsStatus(id, msgType, error);
            fail++;
        }
        dpProvincedao.insertData(id, msgType);
        Hashmap.put("succ", succ);
        Hashmap.put("fail", fail);
        Hashmap.put("reslutType", reslutType);

        return Hashmap;
    }

}
