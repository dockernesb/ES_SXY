package com.udatech.hall.creditRepair.controller;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.controller.SuperController;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseRepair;
import com.udatech.common.resourceManage.service.ThemeService;
import com.udatech.hall.creditRepair.service.HallRepairService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @category 信用修复（业务大厅端）
 * @author ccl
 */
@Controller
@RequestMapping("/hallRepair")
public class HallRepairController extends SuperController {

	private Logger log = Logger.getLogger(HallRepairController.class);

	@Autowired
	private HallRepairService hallRepairService;

	@Autowired
	private ThemeService themeService;

	/**
	 * @category 跳转信用修复申请页面
	 * @return
	 */
	@RequestMapping("/toRepairApply")
	@MethodDescription(desc = "申请信用修复（大厅）")
	@RequiresPermissions(value = { "hallRepair.list", "hallRepair.apply",
			"hallRepair.print" }, logical = Logical.OR)
	public String toRepairApply() {
		return "/hall/creditRepair/hall_repair_apply";
	}

	/**
	 * @category 保存信用修复申请
	 * @param er
	 * @return
	 */
	@RequestMapping("/addRepair")
	@ResponseBody
	@RequiresPermissions(value = { "hallRepair.list", "hallRepair.apply",
			"hallRepair.print" }, logical = Logical.OR)
	public String addRepair(EnterpriseRepair er) {
		JSONObject msg = new JSONObject();
		try {
			er.setCreateUser(new SysUser(getUserId()));
			er.setCreateDate(new Date());
			List<String> bjbhs = hallRepairService.addRepair(er);
			msg.put("result", true);
			msg.put("id", er.getId());
			msg.put("bjbhs", bjbhs);
			msg.put("message", "信用修复申请成功！");
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			msg.put("result", false);
			msg.put("message", "信用修复申请失败！");
		}
		return msg.toJSONString();
	}

	/**
	 * @category 打印信用修复反馈单
	 * @param id
	 * @return
	 */
	@RequestMapping("/printRepair")
	@MethodDescription(desc = "打印信用修复（大厅）")
	@RequiresPermissions(value = { "hallRepair.list", "hallRepair.apply",
			"hallRepair.print" }, logical = Logical.OR)
	public String printRepair(String id, String detailId, Model model) {
		EnterpriseRepair er = hallRepairService.getRepairById(id);

		List<String> bjbhList = new ArrayList<String>();

		if (StringUtils.isNotBlank(detailId)) {
			CreditInfo ci = hallRepairService.getCreditInfoById(detailId);
			bjbhList.add(ci.getBjbh());
		} else {
			bjbhList = hallRepairService.getBjbhList(id);
		}

		SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日");
		model.addAttribute("sqr", er.getQymc());
		model.addAttribute("sqrq", format.format(er.getCreateDate()));
		model.addAttribute("bjbhList", bjbhList);
		model.addAttribute("ywlx", "查询");
		model.addAttribute("jbr", er.getJbrxm());
		String slr = er.getCreateUser().getRealName();
		if (StringUtils.isBlank(slr)) {
			slr = er.getCreateUser().getUsername();
		}
		model.addAttribute("slr", slr);
		model.addAttribute("date", format.format(new Date()));
		return "/hall/creditRepair/hall_repair_print";
	}

	/**
	 * @category 跳转信用信用修复列表页面
	 * @return
	 */
	@RequestMapping("/toRepairList")
	@MethodDescription(desc = "查询信用修复（大厅）")
	@RequiresPermissions(value = { "hallRepair.list", "hallRepair.apply",
			"hallRepair.print" }, logical = Logical.OR)
	public String toRepairList(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
		return "/hall/creditRepair/hall_repair_list";
	}

	/**
	 * @category 获取信用修复列表
	 * @param ei
	 * @return
	 */
	@RequestMapping("/getRepairList")
	@ResponseBody
	@RequiresPermissions(value = { "hallRepair.list", "hallRepair.apply",
			"hallRepair.print" }, logical = Logical.OR)
	public String getRepairList(EnterpriseInfo ei) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                ei.setBjbm(dept.getId());
            }
        }
		DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
		Page page = dtParams.getPage();
		Pageable<Map<String, Object>> pageable = hallRepairService
				.getRepairList(ei, page);
		return PageUtils.buildDTData(pageable, request);
	}

	/**
	 * @category 跳转信用信用修复查看页面
	 * @return
	 */
	@RequestMapping("/toRepair")
	@MethodDescription(desc = "查看信用修复（大厅）")
	@RequiresPermissions(value = { "hallRepair.list", "hallRepair.apply",
			"hallRepair.print" }, logical = Logical.OR)
	public String toRepair(Model model, String id, String detailId) {
		EnterpriseRepair er = hallRepairService.getRepairById(id);
		model.addAttribute("er", er);
		CreditInfo ci = hallRepairService.getCreditInfoById(detailId);
		model.addAttribute("ci", ci);
		return "/hall/creditRepair/hall_repair";
	}

	/**
	 * @category 获取具体的信用信息（行政处罚、表彰荣誉等）
	 * @param dataTable
	 * @param thirdId
	 * @return
	 */
	@RequestMapping("/getCreditDetail")
	@ResponseBody
	@MethodDescription(desc = "查询信用信息（大厅）")
	@RequiresPermissions(value = { "hallRepair.list", "hallRepair.apply",
			"hallRepair.print" }, logical = Logical.OR)
	public String getCreditDetail(String dataTable, String thirdId) {
		List<Map<String, Object>> fieldList = themeService
				.getColumnInfoByZyytAndTableName(
						DZThemeEnum.资源用途_信用修复.getKey(), dataTable);

		fieldList = hallRepairService.getCreditDetail(dataTable, thirdId,
				fieldList);

		return PageUtils.toJSONString(fieldList, DateUtils.YYYYMMDD_10);
	}

}
