package com.udatech.center.socialNaturalPerson.dao.impl;

import com.udatech.center.socialNaturalPerson.dao.SocialNaturalPersonDao;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

/**
 * <描述>： 社会自然人DaoImpl<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2017年2月4日下午4:22:55
 */
@Repository
public class SocialNaturalPersonDaoImpl extends BaseDaoImpl implements SocialNaturalPersonDao {

    @Override
    public Pageable<Map<String, Object>> getQueryList(Page page, String xm, String sfzh, String zymc) {
        StringBuffer countSqlBuffer = new StringBuffer();
        countSqlBuffer.append(" SELECT COUNT(1) from ( ");

        StringBuffer querySqlBuffer = new StringBuffer();
        querySqlBuffer.append(" select * from (SELECT                           ");
        querySqlBuffer.append("   A.XM ,                                        ");
        querySqlBuffer.append("   A.SFZH ,                                      ");
        querySqlBuffer.append("   A.XB ,                                        ");
        querySqlBuffer.append("   A.CSRQ ,                                      ");
        querySqlBuffer.append("   A.MZ ,                                        ");
        querySqlBuffer.append("   A.HJDZ ,                                      ");
        querySqlBuffer.append("   A.SSHY ,                                      ");
        querySqlBuffer.append("   (select REPLACE(WM_CONCAT(ZYMC), ',', '、')   ");
        querySqlBuffer.append("   from YW_P_GRZYHZXX B                          ");
        querySqlBuffer.append("   where b.sfzh = a.sfzh                         ");
        querySqlBuffer.append("   group by sfzh) AS ZYMC                        ");
        querySqlBuffer.append("   from YW_P_GRJBXX A) bb                        ");
        
        if (StringUtils.isNotBlank(zymc)) {
            querySqlBuffer.append(" left join YW_P_GRZYHZXX c on c.sfzh = bb.sfzh ");
        }

        querySqlBuffer.append(" WHERE 1=1                                       ");

        // 拼接查询条件
        Map<String, Object> parameters = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(zymc)) {
            querySqlBuffer.append("  AND (c.ZYMC = :I_ZYMC OR bb.SSHY = :I_ZYMC ) ");
            parameters.put("I_ZYMC", EscapeChar.escape(zymc));
        }
        if (StringUtils.isNotBlank(xm)) {
            querySqlBuffer.append("  AND bb.XM = :I_XM ");
            parameters.put("I_XM", EscapeChar.escape(xm));
        }
        if (StringUtils.isNotBlank(sfzh)) {
            querySqlBuffer.append("  AND LOWER(bb.SFZH) = LOWER(:I_SFZH) ");
            parameters.put("I_SFZH", EscapeChar.escape(sfzh));
        }

        countSqlBuffer.append(querySqlBuffer).append(")");

        return this.findBySqlWithPage(querySqlBuffer.toString(), countSqlBuffer.toString(), page, parameters);
    }

    @Override
    public Map<String, Object> findNaturalPersonInfo(String sfzh) {
        String sql = "SELECT * FROM YW_P_GRJBXX WHERE SFZH = :sfzh ";
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("sfzh", sfzh);
        return findBySql(sql, parameters).get(0);
    }

    @Override
    public Pageable<Map<String, Object>> getCreditInfo(String oderColName, String orderType, String sfzh, String tableName, Page page) {
        Map<String, Object> params = new HashMap<>();

        StringBuilder sb = new StringBuilder();
        sb.append(" SELECT * FROM ").append(tableName);
        sb.append(" WHERE SFZH = :sfzh AND STATUS != 3 ");// 过滤已删除的记录

        if (StringUtils.isNotBlank(oderColName) && StringUtils.isNotBlank(orderType)) {
            sb.append(" ORDER BY ").append(oderColName).append(" ").append(orderType);
        }
        String querySql = sb.toString();
        String countSql = "SELECT COUNT(1) FROM (" + querySql + ") A";

        if (StringUtils.isBlank(sfzh)) {
            sfzh = "";
        }
        params.put("sfzh", sfzh);

        return this.findBySqlWithPage(querySql, countSql, page, params);
    }

}
