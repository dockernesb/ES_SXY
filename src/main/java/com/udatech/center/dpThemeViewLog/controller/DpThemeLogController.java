package com.udatech.center.dpThemeViewLog.controller;

import com.udatech.center.dpThemeViewLog.service.DpThemeLogService;
import com.udatech.common.controller.SuperController;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.vo.ExcelExportVo;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.DateUtils;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dpThemeLog")
public class DpThemeLogController extends SuperController {

    @Autowired
    private DpThemeLogService dpThemeLogService;
    
    @RequestMapping("/dpThemeViewLog")
    @RequiresPermissions("dpThemeLog.toDrView")
    @MethodDescription(desc="上报数据查看日志")
    public ModelAndView dpThemLogView(){
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/dpThemeViewLog/dpThemeLog");
        return view;
    }
    
    @RequestMapping("/themePage/tableList")
    @MethodDescription(desc="表格数据内容")
    @RequiresPermissions("dpThemeLog.toDrView")
    @ResponseBody
    public String dataMassageList(String msgType,String status,String beginDate,String endDate,String sblx){
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        
        Pageable<Map<String, Object>> page =dpThemeLogService.getDataList(msgType, status, beginDate, endDate, sblx, dtParams.getPage());                     
        return PageUtils.buildDTData(page, request);
    }
    
    @RequestMapping("/getMsgColumns")
    @RequiresPermissions("dpThemeLog.toDrView") 
    @ResponseBody
    public void getMsgColumns(String msgType,Writer writer){
      
        List<Map<String, Object>> params = dpThemeLogService.getTableColumn( msgType);
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        
        for(Map<String, Object> paramMap : params){
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("columnName", MapUtils.getString(paramMap, "COLUMN_NAME", ""));
            item.put("comments", MapUtils.getString(paramMap, "COMMENTS", ""));
            list.add(item);
        }
        
        
        String json = ResponseUtils.toJSONString(list);
        try {
            writer.write(json);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    @RequestMapping("/exportData")
    @MethodDescription(desc="表格数据内容")
    @RequiresPermissions("dpThemeLog.toDrView")
    @ResponseBody
    public void exportData(HttpServletRequest request, HttpServletResponse response) {
      try { 
        String msgType = request.getParameter("msgType");
        String beginDate = request.getParameter("beginDate");
        String endDate = request.getParameter("endDate");
        String sblx = request.getParameter("sblx");
        String status = request.getParameter("status");
        
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        page.setPageSize(1000);
        Pageable<Map<String, Object>> pageable =dpThemeLogService.getDataList(msgType, status, beginDate, endDate, sblx, page);
        List<Map<String, Object>> list = pageable.getList();
        for(Map<String, Object> mapList :list){
            Date xksxq = (Date)mapList.get("XKSXQ");
            Date XKJZQ = (Date)mapList.get("XKJZQ");
            Date GXSJC = (Date)mapList.get("GXSJC");
            Date GSJZQ = (Date)mapList.get("GSJZQ");
            Date CFSXQ = (Date)mapList.get("CFSXQ");
            Date CFJZQ = (Date)mapList.get("CFJZQ");
            Date TJRQ = (Date)mapList.get("TJRQ");
            if(xksxq!=null){
                mapList.put("XKSXQ", DateUtils.format(xksxq, DateUtils.YYYYMMDD_10));
            }
            if(XKJZQ!=null){
                mapList.put("XKJZQ", DateUtils.format(XKJZQ, DateUtils.YYYYMMDD_10));
            }
            if(GXSJC!=null){
                mapList.put("GXSJC", DateUtils.format(GXSJC, DateUtils.YYYYMMDDHHMMSS_19));
            }
            if(GSJZQ!=null){
                mapList.put("GSJZQ", DateUtils.format(GSJZQ, DateUtils.YYYYMMDD_10));
            }
            if(CFSXQ!=null){
                mapList.put("CFSXQ", DateUtils.format(CFSXQ, DateUtils.YYYYMMDD_10));
            }
            if(CFJZQ!=null){
                mapList.put("CFJZQ", DateUtils.format(CFJZQ, DateUtils.YYYYMMDD_10));
            }
            if(TJRQ!=null){
                mapList.put("TJRQ", DateUtils.format(TJRQ, DateUtils.YYYYMMDDHHMMSS_19));
            }
        }
        ExcelExportVo vo = new ExcelExportVo();
        vo.setExcelName("数据上报记录");
        vo.setSheetName("数据上报记录");                 
       
        List<Map<String, Object>> params = dpThemeLogService.queryColumnData( msgType);
        StringBuilder titles = new StringBuilder();
        StringBuilder columns = new StringBuilder();
      
        for(Map<String, Object> paramMap : params){  
            titles.append(MapUtils.getString(paramMap, "COMMENTS")).append(",");
            columns.append(MapUtils.getString(paramMap, "COLUMN_NAME")).append(",");
        } 
            vo.setTitles(titles.deleteCharAt(titles.length()-1).toString());           
            vo.setColumns(columns.deleteCharAt(columns.length()-1).toString());
               
            ExcelUtils.excelExport(response, vo, list);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
