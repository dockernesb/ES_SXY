package com.udatech.center.operationAnalysis.controller;

import com.udatech.center.operationAnalysis.service.BusinessApplicationService;
import com.udatech.center.operationAnalysis.service.OpeCommonService;
import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.udatech.common.controller.SuperController;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.ExcelUtils2;
import com.udatech.common.util.ExcelUtils3;
import com.udatech.common.util.ExcelUtils4;
import com.udatech.common.vo.ExcelExportVo;
import com.udatech.common.vo.ExcelExportVo2;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 描述：业务应用分析控制器（中心端）
 * 创建人：guoyt
 * 创建时间：2016年12月28日下午5:34:51
 * 修改人：guoyt
 * 修改时间：2016年12月28日下午5:34:51
 */
@Controller
@RequestMapping("/center/businessApplication")
public class BusinessApplicationController extends SuperController {

    @Autowired
    private BusinessApplicationService businessApplicationService;

    @Autowired
    private OpeCommonService opeCommonService;

    /**
     * @throws
     * @category: 业务应用分析页面跳转
     * @param: @return
     * @return: ModelAndView
     * @since JDK 1.6
     */
    @RequestMapping("/toBusinessApplication")
    @MethodDescription(desc = "查询业务应用分析")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public ModelAndView toBusinessApplication(HttpServletResponse response, HttpServletRequest request) {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/operationAnalysis/business_application");
        return view;
    }

    /**
     * @throws
     * @Description: 根据各种统计主题和统计时间阶段统计数量
     * @param: @param request
     * @param: @param response
     * @param: @return
     * @param: @throws Exception
     * @return: String
     * @since JDK 1.6
     */
    @RequestMapping("/getTotalByCategory")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String getTotalByCategory(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 封装查询条件，包括（统计主题、统计开始日期、结束日期）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 根据各种统计主题和统计时间阶段统计数量
        Map<String, Object> map = businessApplicationService.getTotalByCategory(operationCriteria);
        return ResponseUtils.toJSONString(map);
    }

    /**
     * @throws
     * @Description: 根据各种统计主题统计信用报告、异议处理、信用修复、信用核查等情况
     * @param: @param request
     * @param: @param response
     * @param: @return
     * @param: @throws Exception
     * @return: String
     * @since JDK 1.6
     */
    @RequestMapping("/queryBusinessApplication")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryBusinessApplication(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、维度分析、趋势类别等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 根据各种统计主题统计信用报告、异议处理、信用修复、信用核查等情况
        Map<String, Object> map = businessApplicationService.queryBusinessApplication(operationCriteria,page);
        return ResponseUtils.toJSONString(map);
    }

    /**
     * @throws
     * @Description: 根据各种统计主题（信用报告、异议处理、信用修复、信用核查）统计表格
     * @param: @param measure
     * @param: @return
     * @return: String
     * @since JDK 1.6
     */
    @RequestMapping("/queryBusinessApplicationTable")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryBusinessApplicationTable() {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、维度分析、趋势类别等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 根据各种统计主题（信用报告、异议处理、信用修复、信用核查）统计表格
        Pageable<Map<String, Object>> pageable = businessApplicationService.queryTableDetails(operationCriteria, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * @throws
     * @Description: 统计双公示的情况
     * @param: @param request
     * @param: @param response
     * @param: @return
     * @param: @throws Exception
     * @return: String
     * @since JDK 1.6
     */
    @RequestMapping("/queryPublicity")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryPublicity(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 封装查询条件，包括（统计开始日期、结束日期等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 统计双公示的情况
        Map<String, Object> map = businessApplicationService.queryPublicity(operationCriteria);
        return ResponseUtils.toJSONString(map);
    }

    /**
     * @throws
     * @Description: 查询行政许可、行政处罚排行榜
     * @param: @param request
     * @param: @param response
     * @param: @return
     * @param: @throws Exception
     * @return: String
     * @since JDK 1.6
     */
    @RequestMapping("/queryPublicityRanking")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryPublicityRanking(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 封装查询条件，包括双公示类型、统计开始日期、结束日期
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 查询行政许可、行政处罚排行榜
        Map<String, Object> map = businessApplicationService.queryPublicityRanking(operationCriteria);
        return ResponseUtils.toJSONString(map);
    }

    /**
     * @throws
     * @Description: 统计双公示的表格情况
     * @param: @param measure
     * @param: @return
     * @return: String
     * @since JDK 1.6
     */
    @RequestMapping("/queryPublicityTable")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryPublicityTable() {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计开始日期、结束日期等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 统计双公示的表格情况
        Pageable<Map<String, Object>> pageable = businessApplicationService.queryPublicityTable(operationCriteria, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 导出
     *
     * @param response
     * @param pds
     */
    @RequestMapping("/exportData")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public void exportData(HttpServletResponse response, String selectedIndex) {
        try {
            DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
            Page page = dtParams.getPage();
            page.setPageSize(1000);
            // 封装查询条件，包括（统计开始日期、结束日期等）
            OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);
            if ("5".equals(selectedIndex)) {
                // 统计双公示的表格情况
                Pageable<Map<String, Object>> pageable = businessApplicationService.queryPublicityTable(operationCriteria, page);

                ExcelExportVo vo = new ExcelExportVo();
                vo.setExcelName("业务应用分析（双公示）");
                vo.setSheetName("业务应用分析（双公示）");
                vo.setTitles("信息提供部门名称,双公示合计,行政许可数据量,行政处罚数据量,最后一次上报时间");
                vo.setColumns("CATEGORY,TOTAL,XK_TOTAL,CF_TOTAL,CREATE_TIME");
                ExcelUtils.excelExport(response, vo, pageable.getList());
            } else {
                // 根据各种统计主题（信用报告、异议处理、信用修复、信用核查）统计表格
                Pageable<Map<String, Object>> pageable = businessApplicationService.queryTableDetails(operationCriteria, page);

                List<Map<String, Object>> list = pageable.getList();

                if (list != null && !list.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
                    String date = sdf.format(new Date());
                    for (Map<String, Object> map : list) {
                        map.put("DATE", date);
                        fmtPercentage(map, "XZZHANBI", "XZHUANBI", "XZTONGBI", "LJZHANBI", "LJHUANBI");
                    }
                }

                ExcelExportVo2 vo = new ExcelExportVo2();
                vo.setList(list);

                switch (selectedIndex) {
                    case "1":
                        vo.setExcelName("业务应用分析（信用报告）");
                        vo.setSheetName("业务应用分析（信用报告）");
                        vo.setTitles1(",,新增情况,,,,累计情况,,");
                        vo.setTitles1spans(",,4,,,,3,,");
                        vo.setTitles2("时间,报告用途,新增数,报告用途本期占比,环比,同比,累计数,报告用途本期占比,环比");
                        vo.setColumns("DATE,SHIJIAN,XINZENG,XZZHANBI,XZHUANBI,XZTONGBI,LEIJI,LJZHANBI,LJHUANBI");
                        break;
                    case "2":
                        vo.setExcelName("业务应用分析（异议处理）");
                        vo.setSheetName("业务应用分析（异议处理）");
                        vo.setTitles1(",,新增情况,,,,累计情况,,");
                        vo.setTitles1spans(",,4,,,,3,,");
                        vo.setTitles2("时间,数据提供部门,新增数,提供部门本期占比,环比,同比,累计数,提供部门本期占比,环比");
                        vo.setColumns("DATE,SHIJIAN,XINZENG,XZZHANBI,XZHUANBI,XZTONGBI,LEIJI,LJZHANBI,LJHUANBI");
                        break;
                    case "3":
                        vo.setExcelName("业务应用分析（信用修复）");
                        vo.setSheetName("业务应用分析（信用修复）");
                        vo.setTitles1(",,新增情况,,,,累计情况,,");
                        vo.setTitles1spans(",,4,,,,3,,");
                        vo.setTitles2("时间,数据提供部门,新增数,提供部门本期占比,环比,同比,累计数,提供部门本期占比,环比");
                        vo.setColumns("DATE,SHIJIAN,XINZENG,XZZHANBI,XZHUANBI,XZTONGBI,LEIJI,LJZHANBI,LJHUANBI");
                        break;
                    case "4":
                        vo.setExcelName("业务应用分析（信用审查）");
                        vo.setSheetName("业务应用分析（信用审查）");
                        vo.setTitles1(",,新增情况,,,,累计情况,,");
                        vo.setTitles1spans(",,4,,,,3,,");
                        vo.setTitles2("时间,申请部门,新增数,申请部门本期占比,环比,同比,累计数,申请部门本期占比,环比");
                        vo.setColumns("DATE,SHIJIAN,XINZENG,XZZHANBI,XZHUANBI,XZTONGBI,LEIJI,LJZHANBI,LJHUANBI");
                        break;
                }

                ExcelUtils2.excelExport2(response, vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 格式化百分比
     *
     * @param map
     * @param fields
     */
    private void fmtPercentage(Map<String, Object> map, String... fields) {
        if (fields != null && fields.length > 0) {
            for (String field : fields) {
                Object obj = map.get(field);
                if (obj == null) {
                    map.put(field, "0%");
                } else {
                    if (obj instanceof BigDecimal) {
                        BigDecimal bd = (BigDecimal) obj;
                        if (bd == null) {
                            map.put(field, "0%");
                        } else {
                            map.put(field, bd.intValue() + "%");
                        }
                    }
                }
            }
        }
    }

    /**
     * 
     * @Description: 统计信用审查的独立表格
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */   
    @RequestMapping("/queryCheckTable")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryCheckTable() {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、维度分析、趋势类别等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 根据各种统计主题 信用核查 统计表格
        Pageable<Map<String, Object>> pageable = businessApplicationService.queryCheckTable(operationCriteria, page);
        return PageUtils.buildDTData(pageable, request);
    }
    
    /**
     * 
     * @Description: 信用核查导出
     * @param: @param response
     * @param: @param selectedIndex
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/exportDataCheck")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public void exportDataCheck(HttpServletResponse response,String selectedIndex,String dimension) {
        try {
            DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
            Page page = dtParams.getPage();
            page.setPageSize(1000);
            // 封装查询条件，包括（统计开始日期、结束日期等）
            OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);
            if ("4".equals(selectedIndex)) {
                // 统计双公示的表格情况
                Pageable<Map<String, Object>> pageable = businessApplicationService.queryCheckTable(operationCriteria, page);

                List<Map<String, Object>> list = pageable.getList();
           
                ExcelExportVo2 vo = new ExcelExportVo2();
                vo.setList(list);
                
                
                vo.setExcelName("业务应用分析（信用审查）");
                vo.setSheetName("业务应用分析（信用审查）");
                vo.setTitles1(",审查申请,,审核通过,,审核驳回,");
                vo.setTitles1spans(",2,,2,,2,");
                if("5".equals(dimension)){
                vo.setTitles2("申请部门,份数,企业数,份数,企业数,份数,企业数");
                }else if("4".equals(dimension)){
                vo.setTitles2("审查类别,份数,企业数,份数,企业数,份数,企业数");
                }
                vo.setColumns("DEPT,FSHU,QYSHU,TG_FSHU,TG_QYSHU,BTG_FSHU,BTG_QYSHU");
                ExcelUtils4.excelExport2(response, vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    /**
     * 
     * @Description: 统计信用报告的表格
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/queryReportTable")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryReportTable() {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、维度分析、趋势类别等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 信用报告 统计表格
        Pageable<Map<String, Object>> pageable = businessApplicationService.queryCreditReportTable(operationCriteria, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     *
     * @Description: 统计信用报告的表格(原表)
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/queryReportTable_5")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryReportTable_5() {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、维度分析、趋势类别等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 信用报告 统计表格
        Pageable<Map<String, Object>> pageable = businessApplicationService.queryCreditReportTable_5(operationCriteria, page);
        return PageUtils.buildDTData(pageable, request);
    }
    
    /**
     * 
     * @Description: 信用报告导出
     * @param: @param response
     * @param: @param selectedIndex
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/exportDataReport")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public void exportDataReport(HttpServletResponse response,String selectedIndex) {
        try {
            DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
            Page page = dtParams.getPage();
            page.setPageSize(1000);
            // 封装查询条件，包括（统计开始日期、结束日期等）
            OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);
            if ("1".equals(selectedIndex)) {
                // 统计双公示的表格情况
                Pageable<Map<String, Object>> pageable = businessApplicationService.queryCreditReportTable(operationCriteria, page);

                List<Map<String, Object>> list = pageable.getList();
           
                ExcelExportVo2 vo = new ExcelExportVo2();
                vo.setList(list);
                
                vo.setExcelName("业务应用分析（信用报告）");
                vo.setSheetName("业务应用分析（信用报告）");
                vo.setTitles1("报告用途,,,,,审核量,,,");
                vo.setTitles1spans("4,,,,,2,,,");
                vo.setTitles2("申请用途,区域部门,项目名称,项目细类,申请量,通过量,驳回量,下发量,办结量");
                vo.setColumns("CATEGORY,AREA_DEPTS,PROJECT_NAME,PROJECT_XL,APPLYCOUNT,TG_COUNT,BTG_COUNT,ISSUE_COUNT,END_COUNT");
                ExcelUtils3.excelExport2(response, vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }

    /**
     *
     * @Description: 信用报告导出
     * @param: @param response
     * @param: @param selectedIndex
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/exportDataReport_5")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public void exportDataReport_5(HttpServletResponse response,String selectedIndex) {
        try {
            DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
            Page page = dtParams.getPage();
            page.setPageSize(1000);
            // 封装查询条件，包括（统计开始日期、结束日期等）
            OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);
            if ("1".equals(selectedIndex)) {
                // 统计双公示的表格情况
                Pageable<Map<String, Object>> pageable = businessApplicationService.queryCreditReportTable_5(operationCriteria, page);

                List<Map<String, Object>> list = pageable.getList();

                ExcelExportVo2 vo = new ExcelExportVo2();
                vo.setList(list);

                vo.setExcelName("业务应用分析（信用报告）");
                vo.setSheetName("业务应用分析（信用报告）");
                vo.setTitles1("报告用途,,,,,审核量,,,");
                vo.setTitles1spans("4,,,,,2,,,");
                vo.setTitles2("申请用途,申请量,通过量,驳回量,下发量,办结量");
                vo.setColumns("CATEGORY,APPLYCOUNT,TG_COUNT,BTG_COUNT,ISSUE_COUNT,END_COUNT");
                ExcelUtils3.excelExport2(response, vo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    
    /**
     * @throws
     * @Description: 统计月办理量的情况
     * @param: @param request
     * @param: @param response
     * @param: @return
     * @param: @throws Exception
     * @return: String
     * @since JDK 1.6
     */
    @RequestMapping("/queryMonthlyHandle")
    @RequiresPermissions("businessApplication.query")
    @ResponseBody
    public String queryMonthlyHandle(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 封装查询条件，包括（统计开始日期、结束日期等）
        OperationCriteria operationCriteria = opeCommonService.packageOperationCriteria(request);

        // 统计双公示的情况
        Map<String, Object> map = businessApplicationService.queryMonthlyHandle(operationCriteria);
        return ResponseUtils.toJSONString(map);
    }
}
