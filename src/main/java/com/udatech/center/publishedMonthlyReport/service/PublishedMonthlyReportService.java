package com.udatech.center.publishedMonthlyReport.service;

import com.udatech.center.publishedMonthlyReport.model.PublishedMonthlyReport;
import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.Map;


/**
 * @author IT-20170331ROM3
 * @category 双公示月报表
 * @time 2017-12-05 15:12:27
 */
public interface PublishedMonthlyReportService {

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
     * 保存双公示月报
     *
     * @param report
     */
    void saveMonthlyReport(PublishedMonthlyReport report);

    /**
     * 删除双公示月报
     *
     * @param report
     */
    void deleteMonthlyReport(PublishedMonthlyReport report);

    /**
     * 根据id查询双公示月报表
     *
     * @param id
     * @return
     */
    PublishedMonthlyReport getPublishedMonthlyReport(String id);

    /**
     * 导出双公示月报表
     *
     * @param report
     * @return
     */
    String exportList(PublishedMonthlyReport report, String realPath);

}
