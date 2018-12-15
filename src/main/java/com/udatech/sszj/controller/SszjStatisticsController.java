package com.udatech.sszj.controller;

import com.udatech.common.controller.SuperController;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.vo.ExcelExportVo;
import com.udatech.sszj.service.SszjStatisticsService;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.PageUtils;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.easyui.ResponseUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * @author 作者:zhanglei
 * @version 创建时间:2018/12/13 0013 10:39
 * @Description 描述: 涉审中介统计
 */
@Controller
@RequestMapping("/sszj/tjfx")
public class SszjStatisticsController extends SuperController {

	@Autowired
	private SszjStatisticsService sszjStatisticsService;

	/**
	 * @Description: 跳转涉审中介统计页面
	 * @author zhanglei
	 * @date 2018/12/13 0013 10:44
	 */
	@RequestMapping("/toTjfx")
	@MethodDescription(desc = "跳转涉审中介统计页面")
	@RequiresPermissions("sszj_tjfx_bmd.page")
	public String toSszjTjfx(Model model) {
		return "sszj/sszjStatistics";
	}

	/**
	 * @Description: 获得统计页面标签数据
	 * @author zhanglei
	 * @date 2018/12/13 0013 15:23
	 */
	@RequestMapping("/getTotalData")
	@MethodDescription(desc = "获得统计页面标签数据")
	@RequiresPermissions("sszj_tjfx_bmd.page")
	@ResponseBody
	public String getTotalData(HttpServletRequest request) {
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		String json = "";
		Map<String, Object> map = sszjStatisticsService.getTotalData(startDate, endDate);
		if (map != null && map.size() > 0) {
			json = ResponseUtils.toJSONString(map);
		}
		return json;
	}

	/**
	 * @Description: 获得机构等级柱状图数据
	 * @author zhanglei
	 * @date 2018/12/13 0013 15:23
	 */
	@RequestMapping("/getJgdjBarData")
	@MethodDescription(desc = "获得机构等级柱状图数据")
	@RequiresPermissions("sszj_tjfx_bmd.page")
	@ResponseBody
	public String getJgdjBarData(HttpServletRequest request) {
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		Map<String, Object> map = sszjStatisticsService.getJgdjBarData(startDate, endDate);
		return ResponseUtils.toJSONString(map);

	}

	/**
	 * @Description: 获得涉审中介监管信息柱状图数据
	 * @author zhanglei
	 * @date 2018/12/13 0013 15:23
	 */
	@RequestMapping("/getZjxxBarData")
	@MethodDescription(desc = "获得涉审中介监管信息柱状图数据")
	@RequiresPermissions("sszj_tjfx_bmd.page")
	@ResponseBody
	public String getZjxxBarData(HttpServletRequest request) {
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		List<Map<String, Object>> list = sszjStatisticsService.getZjxxBarData(startDate, endDate);
		return ResponseUtils.toJSONString(list);
	}

	/**
	 * @Description: 获得统计页面表格数据
	 * @author zhanglei
	 * @date 2018/12/13 0013 15:23
	 */
	@RequestMapping("/getDataTable")
	@MethodDescription(desc = "获得统计页面表格数据")
	@RequiresPermissions("sszj_tjfx_bmd.page")
	@ResponseBody
	public String getDataTable(HttpServletRequest request) {
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		DTRequestParamsBean dtRequestParamsBean = PageUtils.getDTParams(request);

		Pageable<Map<String, Object>> pageable = sszjStatisticsService.getDataTable(startDate, endDate, dtRequestParamsBean.getPage());
		return PageUtils.buildDTData(pageable, request);
	}

	@RequestMapping("/exportData")
	@MethodDescription(desc = "导出统计页面表格数据")
	@RequiresPermissions("sszj_tjfx_bmd.page")
	@ResponseBody
	public void exportData(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		List<Map<String, Object>> list = sszjStatisticsService.getDataTable(startDate, endDate);

		ExcelExportVo excelExportVo = new ExcelExportVo();
		excelExportVo.setExcelName("苏州市涉审中介监管信息统计表");
		excelExportVo.setTitles("部门,中介基本信息,机构从业人员,中介详细信息,合计数");
		excelExportVo.setColumns("DEPT_NAME,SSZJSIZE,PJDJSIZE,CYRYSIZE,HEJISIZE");

		ExcelUtils.excelExport(response, excelExportVo, list);
	}
}
