package com.udatech.center.creditReport.controller;

import com.udatech.center.creditReport.service.CreditReportService;
import com.udatech.common.controller.SuperController;
import com.udatech.common.creditReportQuery.service.CreditReportQueryService;
import com.udatech.common.enmu.ReportApplyEnmu;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.dictionary.service.DictionaryService;
import com.wa.framework.dictionary.vo.SysDictionaryVo;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <描述>： 信用查询服务Controller<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月12日下午3:20:08
 */
@Controller
@RequestMapping("/creditReport")
public class CreditReportController extends SuperController {
    private final Logger logger = Logger.getLogger(CreditReportController.class);

    @Autowired
    @Qualifier("creditReportService")
    private CreditReportService creditReportService;  // 法人信用报告查询service

    @Autowired
    @Qualifier("dictionaryService")
    private DictionaryService dictionaryService;

    @Autowired
    private CreditReportQueryService creditReportQueryService;

    /**
     * <描述>: 法人信用申请单审核列表页面
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午2:06:30
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/toReportList")
    @MethodDescription(desc = "打开法人信用报告审核列表页面")
    @RequiresPermissions("credit.reportList.audit")
    public ModelAndView toReportList(HttpServletRequest request, Model model) throws Exception {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/creditReport/center_report_list");
        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        view.addObject("audit", audit);
        return view;
    }

    /**
     * @category 获取信用报告申请单列表
     * @param ei
     * @return
     */
    @RequestMapping("/getReportList")
    @RequiresPermissions("credit.reportList.audit")
    @ResponseBody
    public String getReportApplyList(HttpServletRequest request, EnterpriseInfo ei, String xybgbh, String isIssue, String isHasBasic,
                                     String isHasReport, String skipType) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                ei.setBjbm(dept.getId());
            }
        }
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("xybgbh", xybgbh);
        params.put("isIssue", isIssue);
        params.put("isHasBasic", isHasBasic);
        params.put("isHasReport", isHasReport);
        params.put("skipType", skipType); // 页面跳转类型：1中心端报告审核，2中心端报告下发

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<EnterpriseReportApply> pageable = creditReportService.getReportApplyList(ei, params, page);
        for (EnterpriseReportApply apply : pageable.getList()) {
            if (ReportApplyEnmu.企业自查.getKey().equals(apply.getType())) {
                apply.setSqr(apply.getJbrxm());
            }
            if (ReportApplyEnmu.委托查询.getKey().equals(apply.getType())) {
                apply.setSqr(apply.getSqqymc());
            }
        }
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * <描述>: 跳转到信用报告申请审核页面
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午4:09:58
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/toReportApplyAudit")
    @MethodDescription(desc = "审核法人信用报告申请")
    @RequiresPermissions("credit.reportList.audit")
    public ModelAndView toEnterpriseHis(HttpServletRequest request, String id) throws Exception {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/creditReport/center_report_audit");

        EnterpriseReportApply eo = creditReportService.getReportById(id);
        List<SysDictionaryVo> list = dictionaryService.queryByGroupKey("applyReportPurpose");
        for (SysDictionaryVo dict : list) {
            if (eo.getPurpose().equals(dict.getDictKey())) {
                eo.setPurpose(dict.getDictValue());
            }
        }
        eo.setZxshyj(request.getParameter("zxshyj"));
        view.addObject("eo", eo);
        return view;
    }

    /**
     * <描述>: 跳转到信用报告申请单查看页面
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午4:09:58
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/toReportApplyView")
    @MethodDescription(desc = "查看法人信用报告申请单（中心）")
    @RequiresPermissions("credit.reportList.audit")
    public ModelAndView toReportApplyView(HttpServletRequest request, String id) throws Exception {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/creditReport/center_report_view");

        EnterpriseReportApply eo = creditReportService.getReportById(id);
        List<SysDictionaryVo> list = dictionaryService.queryByGroupKey("applyReportPurpose");
        for (SysDictionaryVo dict : list) {
            if (eo.getPurpose().equals(dict.getDictKey())) {
                eo.setPurpose(dict.getDictValue());
            }
        }
        view.addObject("eo", eo);

        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        view.addObject("audit", audit);
        view.addObject("skipType", request.getParameter("skipType"));
        return view;
    }

    /**
     * <描述>: 保存审核信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日上午9:48:29
     * @param er
     * @return
     */
    @RequestMapping("/reportApplyAudit")
    @MethodDescription(desc = "保存法人信用报告申请审核信息")
    @ResponseBody
    public String saveReprotAudit(EnterpriseReportApply er) {
        try {
            er.setZxshr(new SysUser(getUserId()));
            creditReportService.saveReprotAudit(er);

            // 保存信用报告操作记录
            Map<String, Object> logMap = new HashMap<String, Object>();
            logMap.put("appId", er.getId());
            logMap.put("businessName", ReportApplyEnmu.信用报告审核.getKey());
            logMap.put("userId", getUserId());
            logMap.put("remark", er.getZxshyj());
            creditReportQueryService.saveReportOperationLog(logMap);

        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return ResponseUtils.buildResultJson(false, "审核失败！");
        }
        return ResponseUtils.buildResultJson(true, "审核成功！");
    }

    /**
     * <描述>: 法人信用报告下发列表页面
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午2:06:30
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/toReportIssueList")
    @MethodDescription(desc = "打开法人信用报告下发列表页面")
    @RequiresPermissions("report.issue")
    public ModelAndView toReportIssueList(HttpServletRequest request, Model model) throws Exception {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/creditReport/center_report_issue_list");
        return view;
    }

    @RequestMapping("/toReportIssue")
    @MethodDescription(desc = "打开法人信用报告下发页面")
    @RequiresPermissions("report.issue")
    public ModelAndView toReportIssue(HttpServletRequest request, String id) throws Exception {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/creditReport/center_report_issue");

        EnterpriseReportApply eo = creditReportService.getReportById(id);
        List<SysDictionaryVo> list = dictionaryService.queryByGroupKey("applyReportPurpose");
        for (SysDictionaryVo dict : list) {
            if (eo.getPurpose().equals(dict.getDictKey())) {
                eo.setPurpose(dict.getDictValue());
            }
        }
        view.addObject("eo", eo);
        return view;
    }

    /**
     * <描述>: 保存法人信用报告下发信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日上午9:48:29
     * @param er
     * @return
     */
    @RequestMapping("/reportIssue")
    @MethodDescription(desc = "保存法人信用报告下发信息")
    @RequiresPermissions("report.issue")
    @ResponseBody
    public String saveReportIssue(EnterpriseReportApply er) {
        try {
            er.setZxshr(new SysUser(getUserId()));
            creditReportService.saveReportIssue(er);

            // 保存信用报告操作记录
            Map<String, Object> logMap = new HashMap<String, Object>();
            logMap.put("appId", er.getId());
            logMap.put("businessName", ReportApplyEnmu.信用报告下发.getKey());
            logMap.put("userId", getUserId());
            logMap.put("remark", er.getIssueOpition());
            creditReportQueryService.saveReportOperationLog(logMap);

        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return ResponseUtils.buildResultJson(false, "下发失败！");
        }
        return ResponseUtils.buildResultJson(true, "下发成功！");
    }

    /**
     * <描述>: 重新审核
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日上午9:48:29
     * @param er
     * @return
     */
    @RequestMapping("/reAudit")
    @MethodDescription(desc = "信用报告重新审核")
    @RequiresPermissions("report.issue")
    @ResponseBody
    public String reAudit(EnterpriseReportApply er) {
        try {
            er.setAuditBackUser(getUserId());
            creditReportService.reAudit(er);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
        return ResponseUtils.buildResultJson(true, "操作成功！");
    }
}
