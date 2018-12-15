package com.udatech.sszj.controller;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.constant.Constants;
import com.udatech.common.controller.SuperController;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.CreditCommitmentQy;
import com.udatech.common.model.Promise;
import com.udatech.common.model.PromiseEnter;
import com.udatech.common.service.CreditCommonService;
import com.udatech.common.util.ExcelUtils;
import com.udatech.sszj.service.SszjPromiseService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dictionary.service.DictionaryService;
import com.wa.framework.dictionary.vo.SysDictionaryVo;
import com.wa.framework.log.SysLogUtil;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.Writer;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @category 信用承诺
 * @author ccl
 */
@Controller
@RequestMapping("/sszj_promise")
public class SszjPromiseController extends SuperController {

	@Autowired
	private SszjPromiseService promiseService;

	@Autowired
	private CreditCommonService creditCommonService;

	@Autowired
	private DictionaryService dictionaryService;

	/**
	 * @category 跳转信用承诺列表页面
	 * @return
	 */
	@RequestMapping("/toPromiseList")
	@RequiresPermissions(value = { "center.promise.list", "gov.promise.list" }, logical = Logical.OR)
	public String toPromiseList(Model model) {
		String deptId = getUserDeptId();
		SysDepartment dept = creditCommonService.findDeptById(deptId);
		model.addAttribute("deptId", dept.getId());

		SysUser user = creditCommonService.findUserById(getUserId());

		if (Constants.ADMIN.equals(user.getType())
				|| Constants.CENTER.equals(user.getType())) {
			SysLogUtil.addLog("查询信用承诺（中心）", request);
			return "center/sszjpromise/center_sszj_promise_list";
		}

		SysLogUtil.addLog("查询信用承诺（部门）", request);
		return "gov/sszjpromise/gov_sszj_promise_list";
	}

	/**
	 * @category 跳转信用承诺查询列表页面
	 * @return
	 */
	@RequestMapping("/toPromiseQueryList")
	@RequiresPermissions(value = { "center.promise.list.query"}, logical = Logical.OR)
	public String toPromiseQueryList(Model model) {
		String deptId = getUserDeptId();
		SysDepartment dept = creditCommonService.findDeptById(deptId);
		model.addAttribute("deptId", dept.getId());
		SysLogUtil.addLog("查询信用承诺查询", request);
		return "center/promise/center_promise_query_list";
	}

	/**
	 * @category 获取信用承诺管理列表
	 * @param Promise
	 * @return
	 */
	@RequestMapping("/getPromiseList")
	@RequiresPermissions(value = { "center.promise.list", "gov.promise.list" }, logical = Logical.OR)
	@ResponseBody
	public String getPromiseList(Promise promise) {
		DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
		Page page = dtParams.getPage();

		promise.setDeptId(getUserDeptId());

		Pageable<Map<String, Object>> pageable = promiseService.getPromiseList(
				page, promise);

		return PageUtils.buildDTData(pageable, request);
	}

	/**
	 * @category 保存文件信息
	 * @param promise
	 * @return
	 */
	@RequestMapping("/saveFileInfo")
	@RequiresPermissions(value = { "center.promise.list", "gov.promise.list" }, logical = Logical.OR)
	@ResponseBody
	public String saveFileInfo(UploadFile file) {
		try {
			file.setCreateUser(new SysUser(getUserId()));
			file.setCreateDate(new Date());
			file.setFileType(UploadFileEnmu.信用承诺附件.getKey());
			promiseService.saveFileInfo(file);

			SysUser user = creditCommonService.findUserById(getUserId());
			if (Constants.ADMIN.equals(user.getType())
					|| Constants.CENTER.equals(user.getType())) {
				SysLogUtil.addLog("上传信用承诺附件（中心）", request);
			} else {
				SysLogUtil.addLog("上传信用承诺附件（部门）", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}
		return ResponseUtils.buildResultJson(true);
	}

	/**
	 * @category 删除文件信息
	 * @param promise
	 * @return
	 */
	@RequestMapping("/deleteFileInfo")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page" }, logical = Logical.OR)
	@ResponseBody
	public String deleteFileInfo(UploadFile file) {
		try {
			promiseService.deleteFileInfo(file);

			SysUser user = creditCommonService.findUserById(getUserId());
			if (Constants.ADMIN.equals(user.getType())
					|| Constants.CENTER.equals(user.getType())) {
				SysLogUtil.addLog("删除信用承诺附件（中心）", request);
			} else {
				SysLogUtil.addLog("删除信用承诺附件（部门）", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}
		return ResponseUtils.buildResultJson(true);
	}

	/**
	 * @category 跳转管理承诺企业页面
	 * @return
	 */
	@RequestMapping("/toPromiseQyList")
	@RequiresPermissions(value = {"sszj_xycngl_gld.page", "sszj_xycngl_bmd.page"  }, logical = Logical.OR)
	public String toPromiseQyList(Model model, String cnlb, String deptId) {
		model.addAttribute("deptId", deptId);
		model.addAttribute("cnlb", cnlb);

		String cnlbName = "";
		List<SysDictionaryVo> dicts = dictionaryService.queryByGroupKey("cnlb");
		if (dicts != null && !dicts.isEmpty()) {
			for (SysDictionaryVo dict : dicts) {
				if (dict.getDictKey().equals(cnlb)) {
					cnlbName = dict.getDictValue();
				}
			}
		}
		model.addAttribute("cnlbName", cnlbName);

		SysUser user = creditCommonService.findUserById(getUserId());
		if (Constants.ADMIN.equals(user.getType())
				|| Constants.CENTER.equals(user.getType())) {
			SysLogUtil.addLog("查询信用承诺企业（中心）", request);
		} else {
			SysLogUtil.addLog("查询信用承诺企业（部门）", request);
		}

		return "common/promise/promise_qy_list";
	}

	/**
	 * @Title: queryList
	 * @Description: 查询企业信息列表
	 * @param request
	 * @param promiseEnter
	 * @return
	 * @throws Exception
	 *             String
	 */
	@RequestMapping("/queryList")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page" }, logical = Logical.OR)
	@ResponseBody
	public String queryList(HttpServletRequest request,
			PromiseEnter promiseEnter) throws Exception {
		DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
		Pageable<Map<String, Object>> page = promiseService.findEnterByPage(
				dtParams.getPage(), promiseEnter);
		return PageUtils.buildDTData(page, request);
	}

	/**
	 * @Title: manualAdd
	 * @Description: 手动录入
	 * @param request
	 * @param response
	 * @param writer
	 * @throws Exception
	 * @return: void
	 */
	@RequestMapping("/manualAdd")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page"  }, logical = Logical.OR)
	@ResponseBody
	public void manualAdd(HttpServletRequest request,
                          HttpServletResponse response,
                          CreditCommitmentQy creditCommitmentQy, Writer writer)
			throws Exception {

		SysUser user = creditCommonService.findUserById(getUserId());
		if (Constants.ADMIN.equals(user.getType())
				|| Constants.CENTER.equals(user.getType())) {
			SysLogUtil.addLog("手动录入信用承诺企业（中心）", request);
		} else {
			SysLogUtil.addLog("手动录入信用承诺企业（部门）", request);
		}

		JSONObject msg = new JSONObject();
		try {
			boolean res = promiseService.addEnter(creditCommitmentQy);
			if (res) {
				msg.put("result", true);
				msg.put("message", "手动录入企业成功！");
			} else {
				msg.put("result", false);
				msg.put("message", "该企业已存在！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("result", false);
			msg.put("message", "手动录入企业失败！");
		}

		String json = ResponseUtils.buildResultJson(msg);
		writer.write(json);
	}

	/**
	 * @Title: batchAdd
	 * @Description: 批量导入
	 * @param request
	 * @param response
	 * @param writer
	 * @throws Exception
	 * @return: void
	 */
	@RequestMapping("/batchAdd")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page"  }, logical = Logical.OR)
	@ResponseBody
	public void batchAdd(HttpServletRequest request,
			HttpServletResponse response, Writer writer, String filePathStr,
			String fileNameStr, String cnlb, String deptId) throws Exception {

		SysUser user = creditCommonService.findUserById(getUserId());
		if (Constants.ADMIN.equals(user.getType())
				|| Constants.CENTER.equals(user.getType())) {
			SysLogUtil.addLog("批量导入信用承诺企业（中心）", request);
		} else {
			SysLogUtil.addLog("批量导入信用承诺企业（部门）", request);
		}

		filePathStr = StringUtils.substringBeforeLast(filePathStr, ",");
		fileNameStr = StringUtils.substringBeforeLast(fileNameStr, ",");
		String[] filePathArr = filePathStr.split(",");
		String[] fileNameArr = fileNameStr.split(",");

		JSONObject msg = new JSONObject();
		Workbook wb = null;
		int i = 0;
		StringBuffer message = new StringBuffer();
		message.append("解析结果:<br>");
		for (String filePath : filePathArr) {
			String fileName = fileNameArr[i];
			i++;
			if (ExcelUtils.isExcel2007(filePath)) {
				wb = new XSSFWorkbook(new FileInputStream(new File(filePath)));
			} else {
				wb = new HSSFWorkbook(new FileInputStream(new File(filePath)));
			}
			Sheet sheet = wb.getSheetAt(0); // 获得第一个sheet
			int rowNum = sheet.getPhysicalNumberOfRows(); // 获取总行数
			if (rowNum < 2) {
				message.append("<b>&nbsp;&nbsp;「" + fileName
						+ "」批量导入企业信息数量为0，无法导入...</b><br>");
			} else {
				Row row = sheet.getRow(0); // 获得标题
				if (row == null) {
					message.append("<b>&nbsp;&nbsp;「" + fileName
							+ "」不是标准的Excel模板...</b><br>");
				} else {
					String cell_qymc = ExcelUtils.getCell(row.getCell(0));
					String cell_gszch = ExcelUtils.getCell(row.getCell(1));
					String cell_zzjgdm = ExcelUtils.getCell(row.getCell(2));
					String cell_shxydm = ExcelUtils.getCell(row.getCell(3));
					if (!StringUtils
							.equals(cell_zzjgdm, Constants.TITLE_ZZJGDM)
							|| !StringUtils.equals(cell_qymc,
									Constants.TITLE_QYMC)
							|| !StringUtils.equals(cell_gszch,
									Constants.TITLE_GSZCH)
							|| !StringUtils.equals(cell_shxydm,
									Constants.TITLE_SHXYDM)) {
						message.append("<b>&nbsp;&nbsp;「" + fileName
								+ "」不是标准的Excel模板...</b><br>");
					} else {
						int cnt = promiseService.batchAdd(wb, cnlb, deptId,
								message);
						message.append("<b>&nbsp;&nbsp;「" + fileName + "」导入 "
								+ cnt + " 家企业</b><br>");
					}
				}
			}
		}
		msg.put("message", message.toString());
		String json = ResponseUtils.buildResultJson(msg);
		writer.write(json);
	}

	/**
	 * @Title: reomveEnter
	 * @Description: 删除企业
	 * @param request
	 * @param response
	 * @param id
	 * @param writer
	 * @throws Exception
	 * @return void
	 */
	@RequestMapping("/reomveEnter")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page" }, logical = Logical.OR)
	@ResponseBody
	public String reomveEnter(String id) {
		try {

			SysUser user = creditCommonService.findUserById(getUserId());
			if (Constants.ADMIN.equals(user.getType())
					|| Constants.CENTER.equals(user.getType())) {
				SysLogUtil.addLog("删除信用承诺企业（中心）", request);
			} else {
				SysLogUtil.addLog("删除信用承诺企业（部门）", request);
			}

			promiseService.reomveEnter(id);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseUtils.buildResultJson(false, "操作失败");
		}

		return ResponseUtils.buildResultJson(true);
	}

	/**
	 * @Title: templateDownload
	 * @Description: 下载模板
	 * @param response
	 * @param request
	 * @throws IOException
	 * @return: void
	 */
	@RequestMapping("/templateDownload")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page"  }, logical = Logical.OR)
	public void templateDownload(HttpServletResponse response,
			HttpServletRequest request) throws Exception {

		SysUser user = creditCommonService.findUserById(getUserId());
		if (Constants.ADMIN.equals(user.getType())
				|| Constants.CENTER.equals(user.getType())) {
			SysLogUtil.addLog("下载信用承诺企业模板（中心）", request);
		} else {
			SysLogUtil.addLog("下载信用承诺企业模板（部门）", request);
		}

		promiseService.templateDownload(response, request);
	}

	/**
	 * @category 跳转信用承诺处理页面
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/toPromiseQyHandle")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page"  }, logical = Logical.OR)
	public String toPromiseQyHandle(Model model, String id, String type) {

		SysUser user = creditCommonService.findUserById(getUserId());
		if (Constants.ADMIN.equals(user.getType())
				|| Constants.CENTER.equals(user.getType())) {
			SysLogUtil.addLog("处理信用承诺企业（中心）", request);
		} else {
			SysLogUtil.addLog("处理信用承诺企业（部门）", request);
		}

		// 获取企业信息
		Promise promise = promiseService.getQyInfo(id);
		model.addAttribute("promise", promise);
		model.addAttribute("type", type);
		return "common/promise/promise_qy_handle";
	}

	/**
	 * @category 保存处理
	 * @param promise
	 * @return
	 */
	@RequestMapping("/savePromiseQyHandle")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page"  }, logical = Logical.OR)
	@ResponseBody
	public String savePromiseQyHandle(Promise promise) {
		try {
			SysDepartment dept = creditCommonService
					.findDeptById(getUserDeptId());
			promiseService.savePromiseQyHandle(promise, dept);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}

		return ResponseUtils.buildResultJson(true, "操作成功！");
	}

	/**
	 * @category 跳转查看承诺企业页面
	 * @return
	 */
	@RequestMapping("/toPromiseQyViewList")
	@RequiresPermissions("center.promise.list.query")
	public String toPromiseQyViewList(Model model) {
		SysLogUtil.addLog("查询信用承诺企业（中心）", request);
		return "common/promise/promise_qy_view_list";
	}

	/**
	 * @category 跳转信用承诺查看页面
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/toPromiseQyView")
	@RequiresPermissions(value = { "sszj_xycngl_gld.page", "sszj_xycngl_bmd.page" }, logical = Logical.OR)
	public String toPromiseQyView(Model model, String id, int from) {

		SysUser user = creditCommonService.findUserById(getUserId());
		if (Constants.ADMIN.equals(user.getType())
				|| Constants.CENTER.equals(user.getType())) {
			SysLogUtil.addLog("查看信用承诺企业（中心）", request);
		} else {
			SysLogUtil.addLog("查看信用承诺企业（部门）", request);
		}

		// 获取企业信息
		Promise promise = promiseService.getQyInfo(id);
		model.addAttribute("promise", promise);
		model.addAttribute("from", from);

		return "common/promise/promise_qy_view";
	}

}
