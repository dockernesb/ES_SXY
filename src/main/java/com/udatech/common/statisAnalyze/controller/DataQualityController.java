package com.udatech.common.statisAnalyze.controller;

import com.udatech.common.controller.SuperController;
import com.udatech.common.service.CreditCommonService;
import com.udatech.common.statisAnalyze.service.DataQualityService;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.vo.ExcelExportVo;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;

import org.apache.commons.collections.MapUtils;
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
 * @category 数据质量统计
 * @author Administrator
 */
@Controller
@RequestMapping("/dataQuality")
public class DataQualityController  extends SuperController {

	@Autowired
	private DataQualityService dataQualityService;

	@Autowired
	private CreditCommonService creditCommonService;

	@MethodDescription(desc="查询数据质量统计")
    @RequiresPermissions("statisAnalyze.dataQuality")
	@RequestMapping("/dataQuality")
	public String dataSize(HttpServletRequest request) {
		creditCommonService.checkDept(request);
		boolean isCenterDept = (boolean) request.getAttribute("isCenterDept");

		// 中心端部门
		if (isCenterDept) {
			return "/center/statisAnalyze/data_quality";
		} else {
			return "/gov/statisAnalyze/data_quality";
		}
	}

	/**
	 * @category 获取疑问数据统计数据
	 * @param request
	 * @param response
	 * @param writer
	 * @throws IOException
	 */
	@RequiresPermissions("statisAnalyze.dataQuality")
	@RequestMapping("/getStatusStatistics")
	public void getErrorStatistics(HttpServletRequest request, Writer writer) throws IOException {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		Map<String, Object>  returnMap = dataQualityService.getErrorStatistics(criteriaMap);
		writer.write(ResponseUtils.buildResultJson(returnMap));
	}

	/**
	 * @category 获取疑问数据处理情况数据量
	 * @param request
	 * @param response
	 * @param writer
	 * @throws IOException
	 */
	@RequiresPermissions("statisAnalyze.dataQuality")
	@RequestMapping("/getErrorHandleSituation")
	public void getErrorHandleSituation(HttpServletRequest request, Writer writer) throws IOException {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);

		boolean isDept = false;
		// 按部门分组查询
		if ("1".equals(MapUtils.getString(criteriaMap, "isDeptGroup", ""))) {
			isDept = true;
		}
		Map<String, Object>  returnMap = dataQualityService.getErrorHandleSituation(criteriaMap, isDept);

		writer.write(ResponseUtils.buildResultJson(returnMap));
	}

	/**
	 * @category 疑问数据处理情况月度统计
	 * @param request
	 * @param response
	 * @param writer
	 * @throws IOException
	 */
	@RequiresPermissions("statisAnalyze.dataQuality")
	@RequestMapping("/getErrorHandleMonthStatistics")
	public void getErrorHandleMonthStatistics(HttpServletRequest request, Writer writer) throws IOException {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);

		Map<String, Object>  returnMap = dataQualityService.getErrorHandleMonthStatistics(criteriaMap);

		writer.write(ResponseUtils.buildResultJson(returnMap));
	}


	/**
	 * <描述>: 获取疑问数据各个状态数量
	 * @param request
	 * @param writer
	 * @throws IOException
	 * @author 作者：chenhq
	 * @version 创建时间：2017年12月5日上午9:13:17
	 */
	@RequestMapping("/getErrorCount")
	@RequiresPermissions("statisAnalyze.dataQuality")
	public void getErrorCount(HttpServletRequest request, Writer writer) throws IOException {
		// 判断登录用户是不是信用中心用户
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		Map<String, Object> res = dataQualityService.getErrorCount(criteriaMap);
		writer.write(ResponseUtils.toJSONString(res));
	}

	/**
	 * @Description: 疑问数据量统计-表格
	 * @param: @param request
	 * @param: @param response
	 * @param: @return
	 * @param: @throws Exception
	 * @return: String
	 * @throws
	 */
	@RequestMapping("/getErrorDataTable")
	@RequiresPermissions("statisAnalyze.dataQuality")
	public void getErrorDataTable(HttpServletRequest request, Writer writer) throws Exception {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		List<Map<String, Object>> list = dataQualityService.getErrorDataTable(criteriaMap);
		writer.write(PageUtils.toJSONString(list));
	}

	/**
	 * 获取该部门下所有目录的统计信息
	 * @param request
	 * @param writer
	 * @throws Exception
	 */
	@RequestMapping("/getDeptTableDetailData")
	@RequiresPermissions("statisAnalyze.dataQuality")
	public void getDeptTableDetailData(HttpServletRequest request, String deptId, Writer writer) throws Exception {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		criteriaMap.put("deptId", deptId);

		List<Map<String, Object>> list = dataQualityService.getErrorDataTable(criteriaMap);
		writer.write(PageUtils.toJSONString(list));
	}

	/**
	 * @Description: 导出疑问数据
	 * @param: @param request
	 * @param: @param response
	 * @param: @return
	 * @param: @throws Exception
	 * @return: String
	 * @throws
	 */
	@RequestMapping("/exportData")
	@RequiresPermissions("statisAnalyze.dataQuality")
	@ResponseBody
	public void exportData(HttpServletRequest request, HttpServletResponse response, ExcelExportVo excelExportVo) throws Exception {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		List<Map<String, Object>> list = dataQualityService.getErrorDataTable(criteriaMap);
		ExcelUtils.excelExport(response, excelExportVo, list);
	}

	/**
	 * 导出该部门下所有目录的统计信息
	 * @param request
	 * @param response
	 * @param deptId
	 * @param excelExportVo
	 * @throws Exception
	 */
	@RequestMapping("/exportDeptTableDetailData")
	@RequiresPermissions("statisAnalyze.dataQuality")
	@ResponseBody
	public void exportDeptTableDetailData(HttpServletRequest request, HttpServletResponse response, String deptId, ExcelExportVo excelExportVo) throws Exception {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		criteriaMap.put("deptId", deptId);
		SysDepartment dept = creditCommonService.findDeptById(deptId);
		excelExportVo.setExcelName(dept.getDepartmentName() + "-数据质量统计");

		List<Map<String, Object>> list = dataQualityService.getErrorDataTable(criteriaMap);
		ExcelUtils.excelExport(response, excelExportVo, list);
	}

	/**
	 * 导出该部门下所有目录的统计信息
	 * @param request
	 * @param response
	 * @param deptId
	 * @param excelExportVo
	 * @throws Exception
	 */
	@RequestMapping("/exportSchemaTableDetailData")
	@RequiresPermissions("statisAnalyze.dataQuality")
	@ResponseBody
	public void exportSchemaTableDetailData(HttpServletRequest request, HttpServletResponse response,ExcelExportVo excelExportVo) throws Exception {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		excelExportVo.setExcelName(criteriaMap.get("schemaName") + "-数据质量统计");

		List<Map<String, Object>> list = dataQualityService.getErrorDataTable(criteriaMap);
		ExcelUtils.excelExport(response, excelExportVo, list);
	}

	/**
	 *  获取该目录下疑问数据统计信息
	 * @param request
	 * @param writer
	 * @throws Exception
	 */
	@RequestMapping("/queryDetailsBySchema")
	@RequiresPermissions("statisAnalyze.dataQuality")
	public void queryDetailsBySchema(HttpServletRequest request, Writer writer) throws Exception {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		criteriaMap.put("deptId", getUserDeptId());
		List<Map<String, Object>> list = dataQualityService.queryDetailsBySchema(criteriaMap);
		writer.write(PageUtils.toJSONString(list));
	}

	/**
	 * 导出 该目录下疑问数据统计信息
	 * @param request
	 * @param response
	 * @param excelExportVo
	 * @throws Exception
	 */
	@RequestMapping("/exportDetailsBySchemaData")
	@RequiresPermissions("statisAnalyze.dataQuality")
	@ResponseBody
	public void exportDetailsBySchemaData(HttpServletRequest request, HttpServletResponse response, ExcelExportVo excelExportVo) throws Exception {
		SysUser user = baseService.findById(SysUser.class, getUserId());
		request.setAttribute("user", user);
		Map<String, Object> criteriaMap = dataQualityService.packageCriteria(request);
		excelExportVo.setExcelName(criteriaMap.get("schemaName") + "-数据质量统计");
		criteriaMap.put("deptId", getUserDeptId());
		List<Map<String, Object>> list = dataQualityService.queryDetailsBySchema(criteriaMap);

		ExcelUtils.excelExport(response, excelExportVo, list);
	}

}
