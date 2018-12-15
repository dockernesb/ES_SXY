package com.udatech.center.publishedMonthlyReport.controller;

import com.udatech.center.publishedMonthlyReport.model.PublishedMonthlyReport;
import com.udatech.center.publishedMonthlyReport.service.PublishedMonthlyReportService;
import com.udatech.common.controller.SuperController;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.Map;

/**
 * @author IT-20170331ROM3
 * @category 双公示月报表
 * @time 2017-12-05 15:12:27
 */
@Controller
@RequestMapping("/publishedMonthlyReport")
public class PublishedMonthlyReportController extends SuperController {

    private Logger log = Logger.getLogger(PublishedMonthlyReportController.class);

    @Autowired
    private PublishedMonthlyReportService publishedMonthlyReportService;

    /**
     * 信用办跳转双公示月报表
     *
     * @return
     */
    @RequestMapping("/toCenterList")
    @MethodDescription(desc = "双公示月报查询（中心）")
    @RequiresPermissions("center.published.monthly.report")
    public String toCenterList() {
        return "/center/publishedMonthlyReport/center_list";
    }

    /**
     * 信用办查询双公示月报表
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/getCenterList")
    @RequiresPermissions("center.published.monthly.report")
    public String getCenterList(PublishedMonthlyReport report) {
        DTRequestParamsBean params = PageUtils.getDTParams(request);
        Page page = params.getPage();
        Pageable pageable = publishedMonthlyReportService.getList(report, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 信用办查询双公示月报表汇总
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/getCenterSumList")
    @RequiresPermissions("center.published.monthly.report")
    public String getCenterSumList(PublishedMonthlyReport report) {
        DTRequestParamsBean params = PageUtils.getDTParams(request);
        Page page = params.getPage();
        Pageable<Map<String, Object>> pageable = publishedMonthlyReportService.getSumList(report, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 部门跳转双公示月报表
     *
     * @return
     */
    @RequestMapping("/toGovList")
    @MethodDescription(desc = "双公示月报查询（中心）")
    @RequiresPermissions("gov.published.monthly.report")
    public String toGovList() {
        return "/gov/publishedMonthlyReport/gov_list";
    }

    /**
     * 部门查询双公示月报表
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/getGovList")
    @RequiresPermissions("gov.published.monthly.report")
    public String getGovList(PublishedMonthlyReport report) {
        DTRequestParamsBean params = PageUtils.getDTParams(request);
        Page page = params.getPage();
        report.setDept(getUserDept());
        Pageable pageable = publishedMonthlyReportService.getList(report, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 部门跳转双公示月报表
     *
     * @return
     */
    @RequestMapping("/toMonthlyReportHandle")
    @MethodDescription(desc = "双公示月报查询（中心）")
    @RequiresPermissions("gov.published.monthly.report")
    public String toMonthlyReportHandle(Model model, String id) {
        PublishedMonthlyReport report = new PublishedMonthlyReport();
        if (StringUtils.isNotBlank(id)) {
            report = publishedMonthlyReportService.getPublishedMonthlyReport(id);
        }
        model.addAttribute("report", report);
        return "/gov/publishedMonthlyReport/gov_monthly_report_handle";
    }

    /**
     * 保存双公示月报
     *
     * @param report
     * @return
     */
    @ResponseBody
    @RequestMapping("/saveMonthlyReport")
    @RequiresPermissions("gov.published.monthly.report")
    public String saveMonthlyReport(PublishedMonthlyReport report) {
        try {
            if (StringUtils.isNotBlank(report.getId())) {
                report.setUpdateUser(getSysUser());
                report.setUpdateTime(new Date());
            } else {
                report.setCreateUser(getSysUser());
                report.setCreateTime(new Date());
            }
            report.setDept(getUserDept());
            publishedMonthlyReportService.saveMonthlyReport(report);
        } catch (Exception e) {
            e.printStackTrace();
            log.error(e);
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
        return ResponseUtils.buildResultJson(true, "操作成功！");
    }

    /**
     * 删除双公示月报
     *
     * @param report
     * @return
     */
    @ResponseBody
    @RequestMapping("/deleteMonthlyReport")
    @RequiresPermissions("gov.published.monthly.report")
    public String deleteMonthlyReport(PublishedMonthlyReport report) {
        try {
            report.setUpdateUser(getSysUser());
            publishedMonthlyReportService.deleteMonthlyReport(report);
        } catch (Exception e) {
            e.printStackTrace();
            log.error(e);
            return ResponseUtils.buildResultJson(false, "删除失败！");
        }
        return ResponseUtils.buildResultJson(true, "删除成功！");
    }

    /**
     * 部门查询双公示月报表汇总
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/getGovSumList")
    @RequiresPermissions("gov.published.monthly.report")
    public String getGovSumList(PublishedMonthlyReport report) {
        DTRequestParamsBean params = PageUtils.getDTParams(request);
        Page page = params.getPage();
        report.setDept(getUserDept());
        Pageable<Map<String, Object>> pageable = publishedMonthlyReportService.getSumList(report, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 导出双公示月报表
     *
     * @param report
     * @return
     */
    @ResponseBody
    @RequestMapping("/exportList")
    @RequiresPermissions("center.published.monthly.report")
    public String exportList(PublishedMonthlyReport report) {
        try {
            String templatePath = "/template/双公示月报表统计模板.xls";
            String realPath = request.getSession().getServletContext().getRealPath(templatePath);
            String path = publishedMonthlyReportService.exportList(report, realPath);
            if (StringUtils.isNotBlank(path)) {
                return ResponseUtils.buildResultJson(true, path);
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error(e);
        }
        return ResponseUtils.buildResultJson(false, "导出失败！");
    }

}
