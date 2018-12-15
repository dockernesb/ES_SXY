package com.udatech.center.publicityDataSize.controller;

import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.udatech.center.publicityDataSize.model.PublicityDataSize;
import com.udatech.center.publicityDataSize.service.PublicityDataSizeService;
import com.udatech.common.statisAnalyze.model.DataSize;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.vo.ExcelExportVo;
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
import java.util.List;
import java.util.Map;

/**
 * 双公示数据量统计
 */
@Controller
@RequestMapping("/publicityDataSize")
public class PublicityDataSizeController {

    @Autowired
    private PublicityDataSizeService publicityDataSizeService;

    /**
     * 双公示数据量统计
     *
     * @return
     */
    @RequiresPermissions("center.publicityDataSize.query")
    @MethodDescription(desc = "双公示数据量统计")
    @RequestMapping("/toPublicityDataSize")
    public String toPublicityDataSize() {
        return "/center/publicityDataSize/publicityDataSize";
    }

    /**
     * 查询双公示数据量统计数据
     *
     * @param pds
     * @return
     */
    @RequestMapping({"/getDataSize"})
    @RequiresPermissions("center.publicityDataSize.query")
    @ResponseBody
    public String getDataSize(PublicityDataSize pds) {
        List<Map<String, Object>> list = publicityDataSizeService.getDataSize(pds);
        return PageUtils.toJSONString(list);
    }

    /**
     * 导出
     *
     * @param response
     * @param pds
     */
    @RequestMapping("/exportData")
    @RequiresPermissions("center.publicityDataSize.query")
    @ResponseBody
    public void exportData(HttpServletResponse response, PublicityDataSize pds) {
        try {
            List<Map<String, Object>> list = publicityDataSizeService.getDataSize(pds);
            ExcelExportVo vo = new ExcelExportVo();
            vo.setExcelName("双公示上报量统计");
            vo.setSheetName("双公示上报量统计");
            vo.setTitles("信息提供部门名称,双公示上报量,行政许可上报量,行政处罚上报量,最后一次上报时间");
            vo.setColumns("DEPT_NAME,ALL_SIZE,XZXK_SIZE,XZCF_SIZE,LAST_TIME");
            ExcelUtils.excelExport(response, vo, list);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
