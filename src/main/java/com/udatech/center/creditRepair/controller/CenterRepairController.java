package com.udatech.center.creditRepair.controller;

import com.udatech.center.creditRepair.service.CenterRepairService;
import com.udatech.common.controller.SuperController;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseRepair;
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
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * @category 信用修复（中心端）
 * @author ccl
 */
@Controller
@RequestMapping("/centerRepair")
public class CenterRepairController extends SuperController {

	private Logger log = Logger.getLogger(CenterRepairController.class);

	@Autowired
	private CenterRepairService centerRepairService;

	@Autowired
	private ThemeService themeService;

	/**
	 * @category 跳转信用修复列表页面
	 * @return
	 */
	@RequestMapping("/toRepairList")
	@MethodDescription(desc = "查询信用修复（中心）")
	@RequiresPermissions("centerRepair.list")
	public String toRepairList(Model model) {
		SysDepartment dept = getUserDept();
		model.addAttribute("bmlx", 0);  //  中心用户
		if (dept != null) {
			String code = dept.getCode();
			if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
				model.addAttribute("bmlx", 1);  //  区县用户
			}
		}
		return "/center/creditRepair/center_repair_list";
	}

	/**
	 * @category 获取信用修复列表
	 * @param ei
	 * @return
	 */
	@RequestMapping("/getRepairList")
	@ResponseBody
	@RequiresPermissions("centerRepair.list")
	public String getRepairList(EnterpriseInfo ei, String statusType) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                ei.setBjbm(dept.getId());
            }
        }
		DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
		Page page = dtParams.getPage();
		Pageable<Map<String, Object>> pageable = centerRepairService
				.getRepairList(ei,statusType, page);
		return PageUtils.buildDTData(pageable, request);
	}

	/**
	 * @category 跳转信用修复查看页面
	 * @return
	 */
	@RequestMapping("/toRepair")
	@MethodDescription(desc = "查看信用修复（中心）")
	@RequiresPermissions("centerRepair.list")
	public String toRepair(Model model, String id, String detailId,
			String dataTable, String thirdId) {
		EnterpriseRepair er = centerRepairService.getRepairById(id);
		model.addAttribute("er", er);
		CreditInfo ci = centerRepairService.getCreditInfoById(detailId);
		model.addAttribute("ci", ci);
		String dataStatus = centerRepairService.getDataStatus(dataTable,
				thirdId);
		model.addAttribute("dataStatus", dataStatus);
		return "/center/creditRepair/center_repair";
	}

	/**
	 * @category 跳转信用修复审核页面
	 * @return
	 */
	@RequestMapping("/toRepairAudit")
	@MethodDescription(desc = "审核信用修复（中心）")
	@RequiresPermissions("centerRepair.list")
	public String toRepairAudit(Model model, String id, String detailId) {
		EnterpriseRepair er = centerRepairService.getRepairById(id);
		model.addAttribute("er", er);
		CreditInfo ci = centerRepairService.getCreditInfoById(detailId);
		model.addAttribute("ci", ci);
		return "/center/creditRepair/center_repair_audit";
	}

	/**
	 * @category 保存信用修复审核
	 * @param ei
	 * @return
	 */
	@RequestMapping("/saveRepairAudit")
	@ResponseBody
	@RequiresPermissions("centerRepair.list")
	public String saveRepairAudit(CreditInfo ci) {
		try {
			ci.setZxshr(new SysUser(getUserId()));
			centerRepairService.saveRepairAudit(ci);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}
		return ResponseUtils.buildResultJson(true, "操作成功！");
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
	@RequiresPermissions("centerRepair.list")
	public String getCreditDetail(String dataTable, String thirdId) {
		List<Map<String, Object>> fieldList = themeService
				.getColumnInfoByZyytAndTableName(
						DZThemeEnum.资源用途_信用修复.getKey(), dataTable);

		fieldList = centerRepairService.getCreditDetail(dataTable, thirdId,
				fieldList);

		return PageUtils.toJSONString(fieldList, DateUtils.YYYYMMDD_10);
	}

	/**
	 * @category 信用修复
	 * @param er
	 * @return
	 */
	@RequestMapping("/amendRepair")
	@ResponseBody
	@MethodDescription(desc = "修复信用修复（中心）")
	@RequiresPermissions("centerRepair.list")
	public String amendRepair(CreditInfo ci) {
		try {
			centerRepairService.amendRepair(ci);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return ResponseUtils.buildResultJson(false, "操作失败！");
		}
		return ResponseUtils.buildResultJson(true, "操作成功！");
	}

	/**
     * @category 跳转信用修复列表页面
     * @return
     */
    @RequestMapping("/toRepairView")
    @MethodDescription(desc = "查询信用修复（中心）")
    @RequiresPermissions("center.Repair.view")
    public String toRepairView(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        return "/center/creditRepair/center_repair_view";
    }
	
    /**
     * @category 获取信用修复列表
     * @param ei
     * @return
     */
    @RequestMapping("/getRepairView")
    @ResponseBody
    @RequiresPermissions({"center.Repair.view","centerRepair.list"})
    public String getRepairView(EnterpriseInfo ei, String statusType) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                ei.setBjbm(dept.getId());
            }
        }
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = centerRepairService
                .getRepairList(ei,statusType, page);
        return PageUtils.buildDTData(pageable, request);
    }
}
