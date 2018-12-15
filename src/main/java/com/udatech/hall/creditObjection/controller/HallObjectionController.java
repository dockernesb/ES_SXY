package com.udatech.hall.creditObjection.controller;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.controller.SuperController;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.model.CreditInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseObjection;
import com.udatech.common.resourceManage.service.ThemeService;
import com.udatech.hall.creditObjection.service.HallObjectionService;
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
 * @author ccl
 * @category 信用异议（业务大厅端）
 */
@Controller
@RequestMapping("/hallObjection")
public class HallObjectionController extends SuperController {

    private Logger log = Logger.getLogger(HallObjectionController.class);

    @Autowired
    private HallObjectionService hallObjectionService;

    @Autowired
    private ThemeService themeService;

    /**
     * @return
     * @category 跳转信用异议申请页面
     */
    @RequestMapping("/toObjectionApply")
    @MethodDescription(desc = "申请异议申诉（大厅）")
    @RequiresPermissions(value = {"hallObjection.list", "hallObjection.apply",
            "hallObjection.print"}, logical = Logical.OR)
    public String toObjectionApply() {
        return "/hall/creditObjection/hall_objection_apply";
    }

    /**
     * @param eo
     * @return
     * @category 保存信用异议申请
     */
    @RequestMapping("/addObjection")
    @ResponseBody
    @RequiresPermissions(value = {"hallObjection.list", "hallObjection.apply",
            "hallObjection.print"}, logical = Logical.OR)
    public String addObjection(EnterpriseObjection eo) {
        JSONObject msg = new JSONObject();
        try {
            eo.setCreateUser(new SysUser(getUserId()));
            eo.setCreateDate(new Date());
            List<String> bjbhs = hallObjectionService.addObjection(eo);
            msg.put("result", true);
            msg.put("id", eo.getId());
            msg.put("bjbhs", bjbhs);
            msg.put("message", "异议申诉申请成功！");
        } catch (Exception e) {
            e.printStackTrace();
            log.error(e.getMessage());
            msg.put("result", false);
            msg.put("message", "异议申诉申请失败！");
        }
        return msg.toJSONString();
    }

    /**
     * @param id
     * @return
     * @category 打印异议申诉反馈单
     */
    @RequestMapping("/printObjection")
    @MethodDescription(desc = "打印异议申诉（大厅）")
    @RequiresPermissions(value = {"hallObjection.list", "hallObjection.apply",
            "hallObjection.print"}, logical = Logical.OR)
    public String printObjection(String id, String detailId, Model model) {
        EnterpriseObjection eo = hallObjectionService.getObjectionById(id);
        List<String> bjbhList = new ArrayList<String>();

        if (StringUtils.isNotBlank(detailId)) {
            CreditInfo ci = hallObjectionService.getCreditInfoById(detailId);
            bjbhList.add(ci.getBjbh());
        } else {
            bjbhList = hallObjectionService.getBjbhList(id);
        }

        SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日");
        model.addAttribute("sqr", eo.getQymc());
        model.addAttribute("sqrq", format.format(eo.getCreateDate()));
        model.addAttribute("bjbhList", bjbhList);
        model.addAttribute("jbr", eo.getJbrxm());
        String slr = eo.getCreateUser().getRealName();
        if (StringUtils.isBlank(slr)) {
            slr = eo.getCreateUser().getUsername();
        }
        model.addAttribute("slr", slr);
        model.addAttribute("date", format.format(new Date()));
        return "/hall/creditObjection/hall_objection_print";
    }

    /**
     * @return
     * @category 跳转信用异议申诉列表页面
     */
    @RequestMapping("/toObjectionList")
    @MethodDescription(desc = "查询异议申诉（大厅）")
    @RequiresPermissions(value = {"hallObjection.list", "hallObjection.apply",
            "hallObjection.print"}, logical = Logical.OR)
    public String toObjectionList(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        return "/hall/creditObjection/hall_objection_list";
    }

    /**
     * @param ei
     * @return
     * @category 获取异议申诉列表
     */
    @RequestMapping("/getObjectionList")
    @ResponseBody
    @RequiresPermissions(value = {"hallObjection.list", "hallObjection.apply",
            "hallObjection.print"}, logical = Logical.OR)
    public String getObjectionList(EnterpriseInfo ei) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                ei.setBjbm(dept.getId());
            }
        }
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = hallObjectionService
                .getObjectionList(ei, page);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * @return
     * @category 跳转信用异议申诉查看页面
     */
    @RequestMapping("/toObjection")
    @MethodDescription(desc = "查看异议申诉（大厅）")
    @RequiresPermissions(value = {"hallObjection.list", "hallObjection.apply",
            "hallObjection.print"}, logical = Logical.OR)
    public String toObjection(Model model, String id, String detailId) {
        EnterpriseObjection eo = hallObjectionService.getObjectionById(id);
        model.addAttribute("eo", eo);
        CreditInfo ci = hallObjectionService.getCreditInfoById(detailId);
        model.addAttribute("ci", ci);
        return "/hall/creditObjection/hall_objection";
    }

    /**
     * @param dataTable
     * @param thirdId
     * @return
     * @category 获取具体的信用信息（行政处罚、表彰荣誉等）
     */
    @RequestMapping("/getCreditDetail")
    @ResponseBody
    @MethodDescription(desc = "查询信用信息（大厅）")
    @RequiresPermissions(value = {"hallObjection.list", "hallObjection.apply",
            "hallObjection.print"}, logical = Logical.OR)
    public String getCreditDetail(String dataTable, String thirdId) {
        List<Map<String, Object>> fieldList = themeService
                .getColumnInfoByZyytAndTableName(
                        DZThemeEnum.资源用途_异议申诉.getKey(), dataTable);

        fieldList = hallObjectionService.getCreditDetail(dataTable, thirdId,
                fieldList);

        return PageUtils.toJSONString(fieldList, DateUtils.YYYYMMDD_10);
    }

}
