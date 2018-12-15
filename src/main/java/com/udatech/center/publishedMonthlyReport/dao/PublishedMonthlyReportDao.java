package com.udatech.center.publishedMonthlyReport.dao;

import com.udatech.center.publishedMonthlyReport.model.PublishedMonthlyReport;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDao;

import java.util.List;
import java.util.Map;

/**
 * @author IT-20170331ROM3
 * @category 双公示月报表
 * @time 2017-12-05 15:12:27
 */
public interface PublishedMonthlyReportDao extends BaseDao {

    /**
     * 查询双公示月报表
     *
     * @param report
     * @param page
     * @return
     */
    Pageable getList(PublishedMonthlyReport report, Page page);

    /**
     * 查询双公示汇总
     *
     * @param report
     * @param page
     * @return
     */
    Pageable<Map<String, Object>> getSumList(PublishedMonthlyReport report, Page page);

    /**
     * 清除session中对象
     *
     * @param object
     */
    void evict(Object object);

    /**
     * 获取最小日期和最大日期
     *
     * @return
     */
    PublishedMonthlyReport getMinDateAndMaxDate();


    /**
     * 获取导出列表
     *
     * @param report
     * @return
     */
    Map<String, Object> getExportList(PublishedMonthlyReport report);

}
