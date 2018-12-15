package com.udatech.center.dpProcess.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.udatech.center.dpProcess.service.DpProcessService;
import com.udatech.common.controller.SuperController;
import com.udatech.common.statisAnalyze.model.DataSize;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.ExcelUtils5;
import com.udatech.common.vo.ExcelExportVo;
import com.udatech.common.vo.ExcelExportVo2;
import com.wa.framework.common.PageUtils;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.easyui.ResponseUtils;
/**
 * 描述：入库数据统计、双公示入库统计
 * 创建人： luqb
 * 创建时间：2018年6月25日上午9:23:52
 */
@Controller
@RequestMapping("/dpProcess")
public class DpProcessController extends SuperController{

	@Autowired
	private DpProcessService dpProcessService;
    /**
     * @Title:
     * @Description: 入库数据统计页面
     * @param response
     * @param request
     * @return
     * @return: ModelAndView
     */
    @RequestMapping("/toProcessSize")
    @MethodDescription(desc = "入库数据统计页面")
    @RequiresPermissions("dpProcess.processSize")
    public ModelAndView toProcessSize(HttpServletRequest request) {
        ModelAndView view = new ModelAndView();
        Map<String, Object> countmap = dpProcessService.getCount();
        view.addObject("data", countmap);
        view.setViewName("/center/dpProcess/processSize");
        return view;
    }

    /**
     * @category 
     * @param dataSize
     * @param request
     * @param response
     * @param writer
     * @throws IOException
     */
    @RequiresPermissions("dpProcess.processSize")
    @RequestMapping("/queryStorageQuantity")
    public void queryStorageQuantity(DataSize dataSize, HttpServletRequest request,
            HttpServletResponse response, Writer writer) throws IOException {
        String json = "";
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String type = request.getParameter("type");
        List<Map<String, Object>> map = dpProcessService.queryStorageQuantity(type, startDate, endDate);
        if(map!=null && map.size() > 0){
            json = ResponseUtils.toJSONString(map);
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(json);
    }
    
    /**
     * @Description:按部门统计，法人入库量，自然人入库量         
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    @RequiresPermissions("dpProcess.processSize")
    @RequestMapping("/queryDeptQuantity")
    @ResponseBody
    public String queryDeptQuantity(){
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String type = request.getParameter("type");
        List<Map<String,Object>> list = dpProcessService.queryDeptQuantity(type, startDate, endDate);
        Map<String, Object> map = new HashMap<String, Object>();
        Long allSize = 0L;
        Long frSize = 0L;
        Long zrrSize = 0L;
        for(Map<String,Object> m : list){
        	allSize += Long.valueOf(String.valueOf(m.get("ALLSIZE"))).longValue();
        	frSize += Long.valueOf(String.valueOf(m.get("FRSIZE"))).longValue(); 
        	zrrSize += Long.valueOf(String.valueOf(m.get("ZRRSIZE"))).longValue(); 
        }
        map.put("DEPT_NAME", "合计");
        map.put("ALLSIZE", allSize);
        map.put("FRSIZE", frSize);
        map.put("ZRRSIZE", zrrSize);
        list.add(0, map);
        return PageUtils.toJSONString(list);
    }
    
    @RequiresPermissions("dpProcess.processSize")
    @RequestMapping("/queryTableQuantityByDeptId")
    @ResponseBody
    public String queryTableQuantityByDeptId(String deptId) {
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        List<Map<String, Object>> list = dpProcessService.queryTableQuantityByDeptId(startDate, endDate, deptId);
        Map<String, Object> map = new HashMap<String, Object>();
        Long allSize = 0L;
        for(Map<String,Object> m : list){
        	allSize += Long.valueOf(String.valueOf(m.get("ALLSIZE"))).longValue();
        }
        map.put("TABLE_NAME", "合计");
        map.put("ALLSIZE", allSize);
        list.add(0, map);
        return PageUtils.toJSONString(list);
    } 
    
    
    /**
     * @Description:统计有效量、疑问量、上报量（表格）            
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    @RequiresPermissions("dpProcess.processSize")
    @RequestMapping("/exportDeptData")
    @ResponseBody
    public void exportDeptData(HttpServletResponse response, ExcelExportVo excelExportVo){
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String type = request.getParameter("type");
        List<Map<String,Object>> list = dpProcessService.queryDeptQuantity(type, startDate, endDate);
        Map<String, Object> map = new HashMap<String, Object>();
        Long allSize = 0L;
        Long frSize = 0L;
        Long zrrSize = 0L;
        for(Map<String,Object> m : list){
        	allSize += Long.valueOf(String.valueOf(m.get("ALLSIZE"))).longValue();
        	frSize += Long.valueOf(String.valueOf(m.get("FRSIZE"))).longValue(); 
        	zrrSize += Long.valueOf(String.valueOf(m.get("ZRRSIZE"))).longValue(); 
        }
        map.put("DEPT_NAME", "合计");
        map.put("ALLSIZE", allSize);
        map.put("FRSIZE", frSize);
        map.put("ZRRSIZE", zrrSize);
        list.add(0, map);
        try {
            ExcelUtils.excelExport(response, excelExportVo, list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    /**
     * @Description:      
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    @RequiresPermissions("dpProcess.processSize")
    @RequestMapping("/exportDeptDetailData")
    @ResponseBody
    public void exportDeptDetailData(HttpServletResponse response, ExcelExportVo excelExportVo){
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String deptId = request.getParameter("deptId");
        List<Map<String,Object>> list = dpProcessService.queryTableQuantityByDeptId(startDate, endDate, deptId);
        Map<String, Object> map = new HashMap<String, Object>();
        Long allSize = 0L;
        for(Map<String,Object> m : list){
        	allSize += Long.valueOf(String.valueOf(m.get("ALLSIZE"))).longValue();
        }
        map.put("TABLE_NAME", "合计");
        map.put("ALLSIZE", allSize);
        list.add(0, map);
        try {
            ExcelUtils.excelExport(response, excelExportVo, list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    @RequiresPermissions("dpProcess.processSize")
    @RequestMapping("/queryDataCategoryQuantity")
    public void queryDataCategoryQuantity(HttpServletRequest request,
            HttpServletResponse response, Writer writer) throws IOException {
        String json = "";
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String personType = request.getParameter("personType");
        String type = request.getParameter("type");
        List<Map<String, Object>> map = dpProcessService.queryDataCategoryQuantity(type,personType, startDate, endDate);
        if(map!=null && map.size() > 0){
            json = ResponseUtils.toJSONString(map);
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(json);
    }
    
    
    /**
     * @Title:
     * @Description: 进入双公示入库统计页面
     * @param response
     * @param request
     * @return
     * @return: ModelAndView
     */
    @RequestMapping("/toSgsProcessSize")
    @MethodDescription(desc = "双公示入库统计页面")
    @RequiresPermissions("dpProcess.sgsProcessSize")
    public ModelAndView toSgsProcessSize(HttpServletRequest request) {
        ModelAndView view = new ModelAndView();
        Map<String, Object> countmap = dpProcessService.getSgsCount();
        view.addObject("data", countmap);
        view.setViewName("/center/dpProcess/sgsProcessSize");
        return view;
    }
    
    
    /**
     * @category 获取部门列表
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/getDeptList")
    @RequiresPermissions("dpProcess.sgsProcessSize")
    public void getDeptList(HttpServletRequest request, String code, HttpServletResponse response, Writer writer)
                    throws Exception {
        List<Map<String, Object>> resultList = dpProcessService.getDeptByFirstCode(code);
        for (Map<String, Object> sys : resultList) {
        	sys.put("id", sys.get("SYS_DEPARTMENT_ID"));
        	sys.put("text", sys.get("DEPARTMENT_NAME"));
        	sys.remove("SYS_DEPARTMENT_ID");
        	sys.remove("DEPARTMENT_NAME");
        }
        String json = ResponseUtils.toJSONString(resultList);
        writer.write(json);
    }
    
    
    @RequiresPermissions("dpProcess.sgsProcessSize")
    @RequestMapping("/querySgsDataQuality")
    public void querySgsDataQuality(DataSize dataSize, HttpServletRequest request,
            HttpServletResponse response, Writer writer) throws IOException {
        String json = "";
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String type = request.getParameter("type");
        String dimension = request.getParameter("dimension");
        Map<String, Object> map = dpProcessService.querySgsDataQuality(type,dimension, startDate, endDate);
        if(map!=null && map.size() > 0){
            json = ResponseUtils.toJSONString(map);
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(json);
    }
    
    
    @RequiresPermissions("dpProcess.sgsProcessSize")
    @RequestMapping("/querySgsDataRanking")
    public void querySgsDataRanking(HttpServletRequest request,
            HttpServletResponse response, Writer writer) throws IOException {
        String json = "";
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String type = request.getParameter("type");
        String dimension = request.getParameter("dimension");
        Map<String, Object> map = dpProcessService.querySgsDataRanking(type,dimension, startDate, endDate);
        if(map!=null && map.size() > 0){
            json = ResponseUtils.toJSONString(map);
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(json);
    }
    
    @RequiresPermissions("dpProcess.sgsProcessSize")
    @RequestMapping("/queryDataTable")
    @ResponseBody
    public String queryDataTable() throws IOException {
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String type = request.getParameter("type");
        String dimension = request.getParameter("dimension");
        String deptId = request.getParameter("deptId");
        List<Map<String, Object>> list = dpProcessService.queryDataTable(type, dimension, startDate, endDate, deptId);
        return PageUtils.toJSONString(list);
    }
    
    
    @RequiresPermissions("dpProcess.sgsProcessSize")
    @RequestMapping("/querySgsMonthBar")
    public void querySgsDateBar(HttpServletRequest request,
            HttpServletResponse response, Writer writer) throws IOException {
    	String json = "";
    	String startDate = request.getParameter("startDate");
    	String endDate = request.getParameter("endDate");
    	String type = request.getParameter("type");
    	String dimension = request.getParameter("dimension");
    	String deptId = request.getParameter("deptId");
    	Map<String, Object> map = dpProcessService.querySgsMonthBar(type,dimension, startDate, endDate,deptId);
    	if(map!=null && map.size() > 0){
    		json = ResponseUtils.toJSONString(map);
    		response.setContentType("text/html;charset=UTF-8");
    		writer.write(json);
    	}
    }
    
    
    /**
     * @Description:      
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.7.0_79
     */
    @RequiresPermissions("dpProcess.sgsProcessSize")
    @RequestMapping("/exportSgsData")
    @ResponseBody
    public void exportSgsData(HttpServletResponse response,ExcelExportVo2 excelExportVo2){
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String deptId = request.getParameter("deptId");
        String type = request.getParameter("type");
        String dimension = request.getParameter("dimension");
        List<Map<String,Object>> list = dpProcessService.queryDataTable(type, dimension, startDate, endDate, deptId);
        try {
        	excelExportVo2.setExcelName("双公示统计");
        	excelExportVo2.setSheetName("双公示统计");
        	excelExportVo2.setList(list);
        	excelExportVo2.setTitles1(",,行政许可,,行政处罚");
        	excelExportVo2.setTitles1spans(",,1,,1");
        	excelExportVo2.setTitles2("单位,双公示合计,法人,自然人,法人,自然人");
        	String columns = "DEPTNAME,ALLSIZE,XKSIZE_L,XKSIZE_P,CFSIZE_L,CFSIZE_P";
        	excelExportVo2.setColumns(columns);
        	ExcelUtils5.excelExport2(response, excelExportVo2);
        	
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
}
