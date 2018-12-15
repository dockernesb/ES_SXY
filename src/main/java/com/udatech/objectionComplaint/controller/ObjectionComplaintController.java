package com.udatech.objectionComplaint.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.resourceManage.service.ThemeService;
import com.udatech.objectionComplaint.model.ObjectionAddVo;
import com.udatech.objectionComplaint.model.ObjectionComplaint;
import com.udatech.objectionComplaint.model.ObjectionInfo;
import com.udatech.objectionComplaint.model.QueryConditionVo;
import com.udatech.objectionComplaint.service.ObjectionComplaintService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
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
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 信用申诉申请
 * @author beijh
 * @date 2018-11-28 16:53
 */
@Controller
@RequestMapping("/objectionComplaint")
public class ObjectionComplaintController {

    private Logger log = Logger.getLogger(com.udatech.hall.creditObjection.controller.HallObjectionController.class);

    @Autowired
    ObjectionComplaintService objectionComplaintService;

    @Autowired
    protected HttpServletRequest request;

    @Autowired
    private ThemeService themeService;

    /**
     * @category 跳转异议申诉页面
     * @return
     */
    @RequestMapping("/toObjectionComplaint")
    @MethodDescription(desc = "跳转异议申诉页面")
    @RequiresPermissions(value = {"objectionComplaint.apply"})
    public ModelAndView toObjectionApply() {
        ModelAndView view = new ModelAndView();
        view.setViewName("/objectionComplaint/objection_complaint_apply");
        return view;
    }

    /**
     * @category 打印异议申诉反馈单
     * @param id
     * @return
     */
    @RequestMapping("/printObjection")
    @MethodDescription(desc = "打印异议申诉（大厅）")
    @RequiresPermissions(value = { "objectionComplaint.apply", "objectionComplaint.list"}, logical = Logical.OR)
    public String printObjection(String id, String detailId, Model model) {
        ObjectionComplaint oc = objectionComplaintService.findObjectionByid(id);
        SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日");
        model.addAttribute("sqr", oc.getName());
        model.addAttribute("sqrq",  format.format(oc.getCreateDate()));
        model.addAttribute("bjbh", oc.getBjbh());
        model.addAttribute("jszh", oc.getJsz());
        model.addAttribute("date", format.format(new Date()));
        return "/objectionComplaint/objection_complaint_print";
    }

    /**
     * @category 保存信用异议申请
     * @param eo
     * @return
     */
    @RequestMapping("/addObjection")
    @ResponseBody
    @RequiresPermissions(value = { "objectionComplaint.apply"})
    public String addObjection(ObjectionAddVo vo) {
        JSONObject msg = new JSONObject();
        try {
            String id = objectionComplaintService.addObjection(vo);
            msg.put("result", true);
            msg.put("id", id);
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
     *
     * @category 通过身份证或者名字找到申请人信息
     * @return
     */
    @RequestMapping("/complaintPerson")
    @MethodDescription(desc = "通过身份证或者名字找到申请人信息")
    @RequiresPermissions(value = {"objectionComplaint.apply"})
    @ResponseBody
    public String findComplaintPerson(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("searchStr");
        List<Map<String, Object>> list = objectionComplaintService.getComplainPerson(name);
        for(Map<String, Object> map:list){
            String NAME = map.get("NAME").toString();
            String JSZ = map.get("JSZ").toString();
            map.put("NAME", NAME);
            map.put("JSZ",JSZ);
            map.put("VIEW",NAME+" | "+JSZ);
        }
        return JSON.toJSONString(list);
    }

    /**
     * @category 获取信用信息
     * @return
     */
    @RequestMapping("/getCreditInfo")
    @ResponseBody
    public String getCreditInfo(ObjectionInfo ei, String op) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = new SimplePageable<Map<String, Object>>();
        if (StringUtils.isNotBlank(op)) {
            try {
                pageable = objectionComplaintService.getCreditInfo(ei, page);
            } catch (Exception e) {
                pageable = new SimplePageable<Map<String, Object>>();
                e.printStackTrace();
            }
        }
        return PageUtils.buildDTData(pageable, request, DateUtils.YYYYMMDD_10);
    }

    /**
     * @category 获取办件编号
     * @return
     */
    @RequestMapping("/getBjbh")
    @MethodDescription(desc = "获取办件编号")
    @RequiresPermissions(value = {"objectionComplaint.apply"})
    @ResponseBody
    public String getBjbh(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> bjbh = new HashMap<String, Object>();
        bjbh.put("bjbh",objectionComplaintService.getBjbh());
        return JSON.toJSONString(bjbh);
    }

    /**
     * @category 查询异议申诉（大厅）
     * @return
     */
    @RequestMapping("/toObjectionList")
    @MethodDescription(desc = "查询异议申诉（大厅）")
    @RequiresPermissions(value = { "objectionComplaint.list"})
    public String toObjectionList(Model model) {
        return "/objectionComplaint/objection_complaint_list";
    }

    /**
     * @category 获取异议申诉列表
     * @param ei
     * @return
     */
    @RequestMapping("/getObjectionList")
    @ResponseBody
    @RequiresPermissions(value = { "objectionComplaint.list"})
    public String getObjectionList(QueryConditionVo vo) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = objectionComplaintService
                .getObjectionList(vo, page);
        return PageUtils.buildDTData(pageable, request);
    }
    /**
     * @category 跳转信用异议申诉查看页面
     * @return
     */
    @RequestMapping("/toObjection")
    @MethodDescription(desc = "查看异议申诉（大厅）")
    @RequiresPermissions(value = { "objectionComplaint.list"})
    public String toObjection(Model model, String id) {
        ObjectionComplaint oc = objectionComplaintService.findObjectionByid(id);
        model.addAttribute("oc", oc);
        List<Map<String,Object>> zmcl = objectionComplaintService.findZmclById(id);
        model.addAttribute("zmcl", zmcl);
        return "/objectionComplaint/objection_complaint";
    }

    @RequestMapping("/getCreditDetail")
    @ResponseBody
    @MethodDescription(desc = "查询信用信息（大厅）")
    @RequiresPermissions(value = { "objectionComplaint.list"})
    public String getCreditDetail(String dataTable, String thirdId, String type) {
        List<Map<String, Object>> fieldList = themeService
                .getColumnInfoByZyytAndTableName(
                        DZThemeEnum.资源用途_自然人异议申诉.getKey(), dataTable);
        fieldList = objectionComplaintService.getCreditDetail(dataTable, thirdId, type, fieldList);

        return PageUtils.toJSONString(fieldList, DateUtils.YYYYMMDD_10);
    }
}
