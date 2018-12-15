package com.udatech.center.dpChineseTheme.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.wa.framework.common.PropertyConfigurer;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.jaxws.endpoint.dynamic.JaxWsDynamicClientFactory;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.udatech.center.dpChineseTheme.dao.DpChineseDao;
import com.udatech.center.dpChineseTheme.service.DpChineseService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;

@Service
public class DpChineseServiceImpl implements DpChineseService {

    public final static String TOKEN = "55d9550f-1b42-41ef-b9ae-cd0428d94c18";

    static {
        System.setProperty("javax.net.ssl.trustStore", PropertyConfigurer.getValue("javax.net.ssl.trustStore"));
        System.setProperty("javax.net.ssl.trustStorePassword", PropertyConfigurer.getValue("javax.net.ssl.trustStorePassword"));
        System.setProperty("javax.net.ssl.trustStoreType", PropertyConfigurer.getValue("javax.net.ssl.trustStoreType"));
    }

    @Autowired
    private DpChineseDao dpChineseDao;

    /**
     * @Description:得到表格中的数据信息.
     * @see： @see com.udatech.center.dpChineseTheme.service.DpChineseService#getQueryList(java.lang.String,
     *       java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String,
     *       com.wa.framework.Page)
     * @since JDK 1.7
     */
    @Override
    public Pageable<Map<String, Object>> getQueryList(String msgType, String tableCoulmn, String coulmnValue,
                                                      String beginDate, String endDate, String status, Page page) {
        return dpChineseDao.getQueryList(msgType, tableCoulmn, coulmnValue, beginDate, endDate, status, page);
    }

    /**
     * @Description: 获取双公示表的字段信息.
     * @see： @see com.udatech.center.dpChineseTheme.service.DpChineseService#getTableColumn(java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public List<Map<String, Object>> getTableColumn(String msgType) {
        return dpChineseDao.getTableColumn(msgType);
    }

    /**
     * @Description: 单选提交数据（保存当前的状态和时间）.
     * @see： @see com.udatech.center.dpChineseTheme.service.DpChineseService#changeProvinceStatus(java.lang.String,
     *       java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public String changeProvinceStatus(String id, String msgType) {

        Map<String, Object> listMap = queryDataChina(id, msgType);
        StringBuilder builder = new StringBuilder();

        builder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<ROWDATA>\n<ROW>");
        for (Map.Entry<String, Object> s : listMap.entrySet()) {
            builder.append("<" + s.getKey() + ">").append(s.getValue() != null ? s.getValue() : "")
                    .append("</" + s.getKey() + ">");
        }

        builder.append("</ROW>");
        builder.append("</ROWDATA>");

        String msg = builder.toString();
        // System.out.println(msg);
        JaxWsDynamicClientFactory clientFactory = JaxWsDynamicClientFactory.newInstance();
        Client client = null;
        Object[] result = null;
        if ("1".equals(msgType)) {
            client = clientFactory.createClient("https://sgs.creditchina.gov.cn/service/PermissionWebService?wsdl");
            try {
                result = client.invoke("importPermissionXml", new Object[] {TOKEN, msg});
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("2".equals(msgType)) {
            client = clientFactory.createClient("https://sgs.creditchina.gov.cn/service/PenaltyWebService?wsdl");
            try {
                result = client.invoke("importPenalyXml", new Object[] {TOKEN, msg});
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        Document doc = Jsoup.parse((String) result[0]);
        Elements eles1 = doc.select("code");
        Elements eles2 = doc.select("line");

        String resultType = "";
        if ("00".equals(eles1.get(0).text())) {
            resultType = "3";
            dpChineseDao.changeProvinceStatus(id, msgType, resultType, eles1.get(0).text());
        } else {
            resultType = "4";
            dpChineseDao.changeProvinceStatus(id, msgType, resultType, eles1.get(0).text());
        }

        System.out.println(eles1.get(0).text());
        return resultType;
    }

    /**
     * @Description: 通过id值查询到库中对应的数据，（字段名要起别名，为了和信用中国平台的字段匹配）
     * @param: @param id
     * @param: @param msgType
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.7
     */
    private Map<String, Object> queryDataChina(String id, String msgType) {
        String sql = "";
        Map<String, Object> map = new HashMap<String, Object>();
        if ("1".equals(msgType)) {
            sql = "select id, status, source, create_time, create_user, bmbm, bmmc, tgrq, rwbh, zzjgdm as XK_XDR_ZDM,  "
                    + " jgqcyw, jgqc, gszch as XK_XDR_GSDJ,tyshxydm as XK_XDR_SHXYM, bz,xkjdswh as XK_WSH, "
                    + "xmmc as XK_XMMC, xzxkbm, splb as XK_SPLB, xknr as XK_NR,xzxdrmc as XK_XDR, swdjh,fddbrmc as XK_FR,"
                    + " fddbrsfzh as XK_XDR_SFZ,  TO_CHAR(xksxq, 'YYYY/MM/DD') as XK_JDRQ, TO_CHAR(xkjzq, 'YYYY/MM/DD') as XK_JZQ, xkjg as XK_XZJG,"
                    + "case when DQZT not in ('0', '1', '2', '3') then '0' else DQZT end XK_ZT, dfbm as DFBM, "
                    + " TO_CHAR(gxsjc, 'YYYY/MM/DD') as SJC, syfw,gsjzq, xzxdrswdjh as XK_XDR_SWDJ, jgdj_id "
                    + " from YW_L_SGSXZXK where id = :id ";
            map.put("id", id);
        } else if ("2".equals(msgType)) {
            sql = " select id,status,source,create_time,create_user,bmbm,bmmc,tgrq,rwbh,zzjgdm as CF_XDR_ZDM,jgqcyw,jgqc,"
                    + "gszch as CF_XDR_GSDJ,tyshxydm as CF_XDR_SHXYM,bz,cfjdswh as CF_WSH,ajmc as CF_CFMC,cfbm,"
                    + "cfsy as CF_SY,cfyj as CF_YJ,cfzl as CF_CFLB1,cfjg as CF_JG,cfdj,TO_CHAR(cfsxq, 'YYYY/MM/DD') as CF_JDRQ,cfjzq,xzxdrmc as CF_XDR_MC,fddbrmc CF_FR,fddbrsfzh as CF_XDR_SFZ,"
                    + "cfjgmc as CF_XZJG,cfjgmc as CF_XZBM, case when DQZT not in ('0', '1', '2', '3') then '0' else nvl(DQZT,0) end CF_ZT,dfbm,TO_CHAR(gxsjc, 'YYYY/MM/DD') as SJC,syfw,gsjzq,xzxdrswdjh as CF_XDR_SWDJ,jgdj_id,cflb2 as CF_CFLB2 "
                    + " from YW_L_SGSXZCF where id = :id ";
            map.put("id", id);
        }
        return dpChineseDao.getFindBySql(sql, map);
    }

    /**
     * @Description: 单选提交数据（将单选的数据添加到dr表中）.
     * @see： @see com.udatech.center.dpChineseTheme.service.DpChineseService#insertData(java.lang.String,
     *       java.lang.String)
     * @since JDK 1.7
     */
    @Override
    public void insertData(String id, String msgType) {
        dpChineseDao.insertData(id, msgType);
    }

}
