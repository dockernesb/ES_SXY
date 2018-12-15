package com.udatech.common.statisAnalyze.controller;

import com.udatech.common.controller.SuperController;
import com.udatech.common.statisAnalyze.model.DataSize;
import com.udatech.common.statisAnalyze.service.DataSizeService;
import com.udatech.common.statisAnalyze.service.DataStatisticsCommonService;
import com.udatech.common.statisAnalyze.vo.StatisticsCriteria;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.vo.ExcelExportVo;
import com.udatech.gov.dataAnalysis.service.DataAnalysisCommonService;
import com.udatech.gov.dataAnalysis.service.DataAnalysisService;
import com.udatech.gov.dataAnalysis.vo.AnalysisCriteria;
import com.wa.framework.Page;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.PageUtils;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.util.easyui.ResponseUtils;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.Writer;
import java.util.List;
import java.util.Map;

/**
 * @category 数据量统计
 * @author Administrator
 */
@Controller
@RequestMapping("/dataSize")
public class DataSizeController extends SuperController {

	@Autowired
	private DataSizeService dataSizeService;
	
	@Autowired
    private DataStatisticsCommonService dataStatisticsCommonService;

    @Autowired
    private DataAnalysisService dataAnalysisService;

    @Autowired
    private DataAnalysisCommonService dataAnalysisCommonService;
	

	@MethodDescription(desc="查询数据量统计")
    @RequiresPermissions("statisAnalyze.dataSize")
	@RequestMapping("/dataSize")
	public String dataSize() {
		return "/center/statisAnalyze/data_size";
	}

	 /**
     * @Description: 分别统计各种上传方式的入库总量
     * @param: @param request
     * @param: @param response
     * @param: @return
     * @param: @throws Exception
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/getTotalByCategory")
    @RequiresPermissions("statisAnalyze.dataSize")
    @ResponseBody
    public String getTotalByCategory(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String json = "";
        
        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        StatisticsCriteria statisticsCriteria = dataStatisticsCommonService.packageStatisticsCriteria(request);
        
        Map<String, Object> map = dataSizeService.getTotalByCategory(statisticsCriteria);
        
        if(map.size() > 0){
            
            json = ResponseUtils.toJSONString(map);
        }
        return json;
    }
    
    /**
     * @category 统计有效量、疑问量、上报量（饼图、趋势图、柱状图）
     * @param dataSize
     * @param request
     * @param response
     * @param writer
     * @throws IOException
     */
    @RequiresPermissions("statisAnalyze.dataSize")
    @RequestMapping("/queryStorageQuantity")
    public void queryStorageQuantity(DataSize dataSize, HttpServletRequest request,
            HttpServletResponse response, Writer writer) throws IOException {
        String json = "";
        
        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        StatisticsCriteria statisticsCriteria = dataStatisticsCommonService.packageStatisticsCriteria(request);
        
        
        Map<String, Object> map = dataSizeService.queryStorageQuantity(statisticsCriteria);

        if(map.size() > 0){
            
            json = ResponseUtils.toJSONString(map);
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(json);
    }
    
    
    /**
     * @Description:统计有效量、疑问量、上报量（表格）            
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    @RequiresPermissions("statisAnalyze.dataSize")
    @RequestMapping("/queryTableDetails")
    @ResponseBody
    public String queryTableDetails(){
        
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        
        
        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        StatisticsCriteria statisticsCriteria = dataStatisticsCommonService.packageStatisticsCriteria(request);
       
        
        List<Map<String,Object>> list = dataSizeService.queryTableDetails(statisticsCriteria,page);
        
        return PageUtils.toJSONString(list);
    }

    @RequiresPermissions("statisAnalyze.dataSize")
    @RequestMapping("/queryTableDetailsByDeptId")
    @ResponseBody
    public String queryTableDetailsByDeptId(String deptId) {

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        AnalysisCriteria analysisCriteria = dataAnalysisCommonService.packageAnalysisCriteria(request);
        analysisCriteria.setDeptId(deptId); // 部门ID

        List<Map<String, Object>> list = dataAnalysisService.queryTableDetails(analysisCriteria, page);

        return PageUtils.toJSONString(list);
    }

    /**
     *
     * @param response
     * @param deptId
     * @param excelExportVo
     */
    @RequiresPermissions("statisAnalyze.dataSize")
    @RequestMapping("/exportDeptDetailData")
    @ResponseBody
    public void exportDeptDetailData(HttpServletResponse response, String deptId, ExcelExportVo excelExportVo) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        AnalysisCriteria analysisCriteria = dataAnalysisCommonService.packageAnalysisCriteria(request);
        analysisCriteria.setDeptId(deptId); // 部门ID

        SysDepartment dept = commonService.findDeptById(deptId);
        excelExportVo.setExcelName(dept.getDepartmentName() + "-数据量统计");

        List<Map<String, Object>> list = dataAnalysisService.queryTableDetails(analysisCriteria, page);
        try {
            ExcelUtils.excelExport(response, excelExportVo, list);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     *
     * @param response
     * @param deptId
     * @param excelExportVo
     */
    @RequiresPermissions("statisAnalyze.dataSize")
    @RequestMapping("/exportSchemaDetailData")
    @ResponseBody
    public void exportSchemaDetailData(HttpServletResponse response, ExcelExportVo excelExportVo) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();

        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        StatisticsCriteria statisticsCriteria = dataStatisticsCommonService.packageStatisticsCriteria(request);

        List<Map<String,Object>> list = dataSizeService.queryTableDetails(statisticsCriteria,page);

        excelExportVo.setExcelName(statisticsCriteria.getTableName() + "-数据量统计");
        try {
            ExcelUtils.excelExport(response, excelExportVo, list);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * @Description:统计有效量、疑问量、上报量（表格）            
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    @RequiresPermissions("statisAnalyze.dataSize")
    @RequestMapping("/exportData")
    @ResponseBody
    public void exportData(HttpServletResponse response, ExcelExportVo excelExportVo){
        
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        
        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        StatisticsCriteria statisticsCriteria = dataStatisticsCommonService.packageStatisticsCriteria(request);
        

        List<Map<String,Object>> list = dataSizeService.queryTableDetails(statisticsCriteria,page);
        try {
            ExcelUtils.excelExport(response, excelExportVo, list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    
    /**
     * @Description: 根据类型查询部门           
     * @param: @param writer
     * @param: @param request
     * @param: @throws IOException
     * @return: void
     * @throws
     * @since JDK 1.7.0_79
     */
    @RequestMapping("/getDeptListByType")
    @ResponseBody
    public void getDeptListByType(Writer writer,HttpServletRequest request) throws IOException{
		List<Map<String, Object>> list = dataStatisticsCommonService
				.getDeptListByType(request.getParameter("queryType"));
		  writer.write(ResponseUtils.toJSONString(list));
    }

    /**
     * @category 根据数据类别统计有效量
     * @param dataSize
     * @param request
     * @param response
     * @param writer
     * @throws IOException
     */
    @RequestMapping("/getReceiptsByCategory")
    public void getReceiptsByCategory( HttpServletRequest request, HttpServletResponse response,
                                       Writer writer) throws IOException {
        // 封装查询条件，包括（统计主题、统计开始日期、结束日期、图表类别等）
        StatisticsCriteria statisticsCriteria = dataStatisticsCommonService.packageStatisticsCriteria(request);
        List<DataSize> list = dataSizeService.getReceiptsByCategory(statisticsCriteria);

        String json = ResponseUtils.toJSONString(list);
        response.setContentType("text/html;charset=UTF-8");
        writer.write(json);
    }
}
