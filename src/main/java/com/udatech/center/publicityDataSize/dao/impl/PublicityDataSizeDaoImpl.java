package com.udatech.center.publicityDataSize.dao.impl;

import com.udatech.center.publicityDataSize.dao.PublicityDataSizeDao;
import com.udatech.center.publicityDataSize.model.PublicityDataSize;
import com.wa.framework.dao.BaseDaoImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 双公示数据量统计
 */
@Repository
public class PublicityDataSizeDaoImpl extends BaseDaoImpl implements PublicityDataSizeDao {

    /**
     * 查询双公示数据量统计数据
     *
     * @param pds
     * @return
     */
    public List<Map<String, Object>> getDataSize(PublicityDataSize pds) {
        Map<String, Object> params = new HashMap<>();
        StringBuilder sb = new StringBuilder();
        sb.append(" SELECT B.DEPARTMENT_NAME DEPT_NAME,                                                   ");
        sb.append("        NVL(A.XZXK_SIZE, 0) + NVL(A.XZCF_SIZE, 0) ALL_SIZE,                            ");
        sb.append("        NVL(A.XZXK_SIZE, 0) XZXK_SIZE,                                                 ");
        sb.append("        NVL(A.XZCF_SIZE, 0) XZCF_SIZE,                                                 ");
        sb.append("        A.LAST_TIME                                                                    ");
        sb.append(" FROM (                                                                                ");
        sb.append("     SELECT A.DEPT_ID, TO_CHAR(MAX(A.CREATE_TIME), 'YYYY-MM-DD') LAST_TIME,            ");
        sb.append("            SUM(CASE WHEN B.DATA_CATEGORY = '7' THEN A.ALL_SIZE ELSE 0 END) XZXK_SIZE, ");
        sb.append("            SUM(CASE WHEN B.DATA_CATEGORY = '6' THEN A.ALL_SIZE ELSE 0 END) XZCF_SIZE  ");
        sb.append("       FROM DP_DATA_SIZE A                                                             ");
        sb.append("       JOIN DP_LOGIC_TABLE B                                                           ");
        sb.append("         ON A.LOGIC_TABLE_ID = B.ID                                                    ");
        sb.append("      WHERE (B.DATA_CATEGORY = '6' OR B.DATA_CATEGORY = '7')                           ");

        String startDate = pds.getStartDate();
        if (StringUtils.isNotBlank(startDate)) {
            sb.append(" AND TO_CHAR(A.CREATE_TIME, 'YYYY-MM-DD') >= :startDate                            ");
            params.put("startDate", startDate);
        }

        String endDate = pds.getEndDate();
        if (StringUtils.isNotBlank(endDate)) {
            sb.append(" AND TO_CHAR(A.CREATE_TIME, 'YYYY-MM-DD') <= :endDate                              ");
            params.put("endDate", endDate);
        }

        sb.append("      GROUP BY A.DEPT_ID                                                               ");
        sb.append(" ) A RIGHT JOIN SYS_DEPARTMENT B ON A.DEPT_ID = B.SYS_DEPARTMENT_ID WHERE 1 = 1        ");

        if ("A".equals(pds.getZt())) {
            sb.append(" AND B.CODE LIKE 'A%'                                                              ");
        } else {
            sb.append(" AND B.CODE LIKE 'B%'                                                              ");
        }

        if (StringUtils.isNotBlank(pds.getDeptId())) {
            sb.append(" AND B.SYS_DEPARTMENT_ID = :deptId                                                 ");
            params.put("deptId", pds.getDeptId());
        }

        sb.append(" ORDER BY ALL_SIZE DESC ,B.DEPARTMENT_NAME                                             ");

        return this.findBySql(sb.toString(), params);
    }

}
