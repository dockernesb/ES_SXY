package com.udatech.center.creditObjection.controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.udatech.center.creditObjection.service.CenterObjectionService;
import com.udatech.common.controller.SuperController;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseObjection;
import com.udatech.common.model.FieldInfo;
import com.udatech.common.resourceManage.service.ThemeService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;

import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

/**
 * @category 信用异议（中心端）
 * @author ccl
 */
@Controller
@RequestMapping("/centerObjection")
public class CenterObjectionController extends SuperController {

	private Logger log = Logger.getLogger(CenterObjectionController.class);

	@Autowired
	private CenterObjectionService centerObjectionService;

	@Autowired
	private ThemeService themeService;

	/**
	 * @category 跳转信用异议申诉列表页面
	 * @return
	 */
	@RequestMapping("/toObjectionList")
	@MethodDescription(desc = "查询异议申诉（中心）")
	@RequiresPermissions(value = { "centerObjection.list",
			"centerObjection.amend" }, logical = Logical.OR)
	public String toObjectionList(Model model) {
		SysDepartment dept = getUserDept();
		model.addAttribute("bmlx", 0);  //  中心用户
		if (dept != null) {
			String code = dept.getCode();
			if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
				model.addAttribute("bmlx", 1);  //  区县用户
			}
		}
		return "/center/creditObjection/center_objection_list";
	}

	/**
	 * @category 获取异议申诉列表
	 * @param ei
	 * @return
	 */
	@RequestMapping("/getObjectionList")
	@ResponseBody
	@RequiresPermissions(value = { "centerObjection.list",
			"centerObjection.amend" }, logical = Logical.OR)
	public String getObjectionList(EnterpriseInfo ei, String statusType) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                ei.setBjbm(dept.getId());
            }
        }
		DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
		Page page = dtParams.getPage();
		Pageable<Map<String, Object>> pageable = centerObjectionService
				.getObjectionList(ei,statusType, page);
		return PageUtils.buildDTData(pageable, request);
	}

	/**
	 * @category 跳转信用异议申诉查看页面
	 * @return
	 */
	@RequestMapping("/toObjection")
	@MethodDescription(desc = "查看异议申诉（中心）")
	@RequiresPermissions(value = { "centerObjection.list","centerObjection.amendView",
			"centerObjection.amend" }, logical = Logical.OR)
	public String toObjection(Model model, String id, String detailId,
			String dataTable, String thirdId) {
		EnterpriseObjection eo = centerObjectionService.getObjectionById(id);
		model.addAttribute("eo", eo);
		CreditInfo ci = centerObjectionService.getCreditInfoById(detailId);
		model.addAttribute("ci", ci);
		String dataStatus = centerObjectionService.getDataStatus(dataTable,
				thirdId);
		model.addAttribute("dataStatus", dataStatus);
		return "/center/creditObjection/center_objection";
	}

	/**
	 * @category 跳转信用异议申诉审核页面
	 * @return
	 */
	@RequestMapping("/toObjectionAudit")
	@MethodDescription(desc = "审核异议申诉（中心）")
	@RequiresPermissions(value = { "centerObjection.list",
			"centerObjection.amend" }, logical = Logical.OR)
	public String toObjectionAudit(Model model, String id, String detailId) {
		EnterpriseObjection eo = centerObjectionService.getObjectionById(id);
		model.addAttribute("eo", eo);
		CreditInfo ci = centerObjectionService.getCreditInfoById(detailId);
		model.addAttribute("ci", ci);
		return "/center/creditObjection/center_objection_audit";
	}

	/**
	 * @category 保存异议申诉审核
	 * @param ei
	 * @return
	 */
	@RequestMapping("/saveObjectionAudit")
	@ResponseBody
	@RequiresPermissions(value = { "centerObjection.list",
			"centerObjection.amend" }, logical = Logical.OR)
	public String saveObjectionAudit(CreditInfo ci) {
		try {
			ci.setZxshr(new SysUser(getUserId()));
			centerObjectionService.saveObjectionAudit(ci);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}
		return ResponseUtils.buildResultJson(true, "操作成功！");
	}

	/**
	 * @category 查看历史修正数据
	 * @param ci
	 * @return
	 */
	@RequestMapping("/viewHistory")
	@ResponseBody
	@MethodDescription(desc = "查看修正数据（中心）")
	@RequiresPermissions(value = { "centerObjection.list","centerObjection.amendView",
			"centerObjection.amend" }, logical = Logical.OR)
	public List<FieldInfo> viewHistory(CreditInfo ci) {
		List<FieldInfo> fiList = centerObjectionService.viewHistory(ci);
		return fiList;
	}

	/**
	 * @category 获取具体的信用信息（行政处罚、表彰荣誉等）
	 * @param dataTable
	 * @param thirdId
	 * @return
	 */
	@RequestMapping("/getCreditDetail")
	@ResponseBody
	@MethodDescription(desc = "查询信用信息（中心）")
	@RequiresPermissions(value = { "centerObjection.list","centerObjection.amendView",
			"centerObjection.amend" }, logical = Logical.OR)
	public String getCreditDetail(String dataTable, String thirdId) {
		List<Map<String, Object>> fieldList = themeService
				.getColumnInfoByZyytAndTableName(
						DZThemeEnum.资源用途_异议申诉.getKey(), dataTable);

		fieldList = centerObjectionService.getCreditDetail(dataTable, thirdId,
				fieldList);

		return PageUtils.toJSONString(fieldList, DateUtils.YYYYMMDD_10);
	}

	/**
	 * @category 删除异议
	 * @param ci
	 * @return
	 */
	@RequestMapping("/deleteObjection")
	@ResponseBody
	@MethodDescription(desc = "删除异议申诉（中心）")
	@RequiresPermissions(value = { "centerObjection.amendView",
			"centerObjection.amend" }, logical = Logical.OR)
	public String deleteObjection(CreditInfo ci) {
		try {
			centerObjectionService.deleteObjection(ci);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}
		return ResponseUtils.buildResultJson(true, "操作成功！");
	}

	/**
	 * @category 修正异议
	 * @param ci
	 * @return
	 */
	@RequestMapping("/amendObjection")
	@ResponseBody
	@MethodDescription(desc = "修正异议申诉（中心）")
	@RequiresPermissions(value = { "centerObjection.amendView",
			"centerObjection.amend" }, logical = Logical.OR)
	public String amendObjection(CreditInfo ci, String fields) {
		try {
			if (StringUtils.isNotBlank(fields)) {
				fields = HtmlUtils.htmlUnescape(fields);
				Gson gson = new Gson();
				Type type = new TypeToken<List<FieldInfo>>() {
				}.getType();
				List<FieldInfo> list = gson.fromJson(fields, type);
				ci.setFieldList(list);
			}
			centerObjectionService.amendObjection(ci);
			centerObjectionService.saveAmendDataTrace(ci);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}
		return ResponseUtils.buildResultJson(true, "操作成功！");
	}
	
	/**
     * @category 跳转信用异议申诉列表页面
     * @return
     */
    @RequestMapping("/toObjectionView")
    @MethodDescription(desc = "查询异议申诉修正页面")
    @RequiresPermissions("centerObjection.amendView")
    public String toObjectionView(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        return "/center/creditObjection/center_objection_amend";
    }

    /**
     * @category 获取异议申诉列表
     * @param ei
     * @return
     */
    @RequestMapping("/getObjectionView")
    @ResponseBody
    @RequiresPermissions(value = { "centerObjection.amendView",
            "centerObjection.amend" }, logical = Logical.OR)
    public String getObjectionView(EnterpriseInfo ei, String statusType) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                ei.setBjbm(dept.getId());
            }
        }
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = centerObjectionService
                .getObjectionList(ei,statusType, page);
        return PageUtils.buildDTData(pageable, request);
    }

}
