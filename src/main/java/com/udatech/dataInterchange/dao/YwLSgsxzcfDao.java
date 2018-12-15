package com.udatech.dataInterchange.dao;

import com.udatech.dataInterchange.model.DpFtpUploadLogEntity;
import com.udatech.dataInterchange.model.YwLSgsxzcfEntity;
import com.wa.framework.Pageable;
import com.wa.framework.QueryCondition;
import com.wa.framework.QueryConditions;
import com.wa.framework.SimplePage;
import com.wa.framework.dao.BaseDaoImpl;
import org.springframework.stereotype.Repository;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Repository
public class YwLSgsxzcfDao extends BaseDaoImpl {
    private static int pageSize = 5000;

    public List<YwLSgsxzcfEntity> getData(int currentPage, boolean firstFtpUpload, DpFtpUploadLogEntity recentlyData) {
        SimplePage simplePage = new SimplePage(currentPage, pageSize);

        // 如果有ftp上传记录，则不是首次上传，那么进行增量上传
        if (firstFtpUpload) { // 首次全量上传数据
            Pageable<YwLSgsxzcfEntity> page = this.findWithPage(YwLSgsxzcfEntity.class, simplePage);
            return page.getList();
        } else {
            Calendar cal = Calendar.getInstance();
            if (recentlyData != null && recentlyData.getCreateTime() != null) {
                cal.setTime(recentlyData.getCreateTime());
            }
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            Date startDate = cal.getTime();

            Calendar now = Calendar.getInstance();
            now.add(Calendar.DAY_OF_MONTH, -1);// 取前一天结尾时间，因为定时任务是第二天凌晨1执行党的
            now.set(Calendar.HOUR_OF_DAY, 23);
            now.set(Calendar.MINUTE, 59);
            now.set(Calendar.SECOND, 59);
            now.set(Calendar.MILLISECOND, 999);
            Date endDate = now.getTime();

            // 非首次上传数据，则增量上传每天的数据
            QueryConditions queryConditions = new QueryConditions();
            queryConditions.addGe("createTime", startDate);
            queryConditions.addLe("createTime", endDate);

            Pageable<YwLSgsxzcfEntity> page = this.findWithPage(YwLSgsxzcfEntity.class, simplePage, queryConditions);
            return page.getList();
        }
    }

    /**
     * 获取总页数
     *
     * @return
     */
    public int getPageCount(boolean firstFtpUpload, DpFtpUploadLogEntity recentlyData) {
        long totalRecord;
        if (firstFtpUpload) { // 首次全量上传数据
            totalRecord = this.count(YwLSgsxzcfEntity.class, (QueryCondition) null);
        } else {
            Calendar cal = Calendar.getInstance();
            if (recentlyData != null && recentlyData.getCreateTime() != null) {
                cal.setTime(recentlyData.getCreateTime());
            }
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            Date startDate = cal.getTime();

            Calendar now = Calendar.getInstance();
            now.add(Calendar.DAY_OF_MONTH, -1);// 取前一天结尾时间，因为定时任务是第二天凌晨1执行党的
            now.set(Calendar.HOUR_OF_DAY, 23);
            now.set(Calendar.MINUTE, 59);
            now.set(Calendar.SECOND, 59);
            now.set(Calendar.MILLISECOND, 999);
            Date endDate = now.getTime();

            // 非首次上传数据，则增量上传每天的数据
            QueryConditions queryConditions = new QueryConditions();
            queryConditions.addGe("createTime", startDate);
            queryConditions.addLe("createTime", endDate);

            totalRecord = this.count(YwLSgsxzcfEntity.class, queryConditions);
        }
        long totalPageNum = (totalRecord + pageSize - 1) / pageSize;
        return new Long(totalPageNum).intValue();
    }

}
