package com.udatech.dataInterchange.dao;

import com.udatech.dataInterchange.model.DpFtpUploadLogEntity;
import com.wa.framework.dao.BaseDaoImpl;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class FtpDao extends BaseDaoImpl {

    /**
     * 获取指定序列值
     *
     * @param sequenceName
     * @return
     */
    public String getSequenceNextValue(String sequenceName) {
        String sql = "select " + sequenceName + ".nextval from dual";
        return ((Map) this.findBySql(sql).get(0)).get("NEXTVAL").toString();
    }

    /**
     * 判断是否是第一次全量生成xml时断开的
     *
     * @return
     */
    public boolean isFirstBroken(String tableCode) {
        StringBuffer sb = new StringBuffer();
        sb.append("select a.* from dp_ftp_upload_log a where a.table_code=:tableCode and a.current_page = a.all_page");
        Map<String, Object> params = new HashMap<>();
        params.put("tableCode", tableCode);
        List<DpFtpUploadLogEntity> list = this.findBySql(sb.toString(), params, DpFtpUploadLogEntity.class);
        if (list != null && list.size() > 0) {
            return false;
        }
        return true;
    }

    /**
     * 获取指定表code的最新xml文件生成记录
     *
     * @param tableCode
     * @return
     */
    public DpFtpUploadLogEntity getRecentlyData(String tableCode) {
        StringBuffer sb = new StringBuffer();
        sb.append(" select *                                                                                   ");
        sb.append("   from (select t.*,                                                                        ");
        sb.append("                row_number() over(partition by t.table_code order by t.create_time desc) rn ");
        sb.append("           from dp_ftp_upload_log t)                                                        ");
        sb.append("  where rn = 1 and table_code = :tableCode                                                ");
        Map<String, Object> params = new HashMap<>();
        params.put("tableCode", tableCode);
        List<DpFtpUploadLogEntity> list = this.findBySql(sb.toString(), params, DpFtpUploadLogEntity.class);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    /**
     * 本日无数据，记录上传日志信息
     *
     * @param tableCode
     */
    public void addNoDataLog(String tableCode) {
        DpFtpUploadLogEntity dpFtpUploadLogEntity = new DpFtpUploadLogEntity();
        dpFtpUploadLogEntity.setTableCode(tableCode);
        dpFtpUploadLogEntity.setCreateTime(new Date());
        dpFtpUploadLogEntity.setXmlFileLocalPath("本日无数据");
        dpFtpUploadLogEntity.setCurrentPage(0);
        dpFtpUploadLogEntity.setAllPage(0);
        this.save(dpFtpUploadLogEntity);
    }
}
