package com.udatech.center.creditReport.controller;

import com.udatech.center.creditReport.service.CreditPReportService;
import com.udatech.common.controller.SuperController;
import com.udatech.common.creditReportQuery.service.CreditReportQueryService;
import com.udatech.common.enmu.ReportApplyEnmu;
import com.udatech.common.model.PersonReportApply;
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
 * <描述>： 自然人 - 信用查询服务Controller<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月12日下午3:20:08
 */
@Controller
@RequestMapping("/creditPReport")
public class CreditPReportController extends SuperController {
    private final Logger logger = Logger.getLogger(CreditPReportController.class);

    @Autowired
    @Qualifier("creditPReportService")
    private CreditPReportService creditPReportService;  // 自然人信用报告查询service

    @Autowired
    @Qualifier("dictionaryService")
    private DictionaryService dictionaryService;

    @Autowired
    private CreditReportQueryService creditReportQueryService;

    /**
     * <描述>: 自然人信用申请单审核列表页面
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午2:06:30
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/toReportList")
    @MethodDescription(desc = "查询自然人信用报告（中心）")
    @RequiresPermissions("credit.p.reportList")
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
        view.setViewName("/center/creditReport/center_p_report_list");
        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        view.addObject("audit", audit);
        return view;
    }

    /**
     * @category 获取信用报告申请单列表
     * @param pi
     * @return
     */
    @RequestMapping("/getReportList")
    @RequiresPermissions("credit.p.reportList")
    @ResponseBody
    public String getReportApplyList(HttpServletRequest request, PersonReportApply pi, String xybgbh) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                pi.setBjbm(dept.getId());
            }
        }
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<PersonReportApply> pageable = creditPReportService.getReportApplyList(pi, xybgbh, page);
        for (PersonReportApply apply : pageable.getList()) {
            if (ReportApplyEnmu.本人查询.getKey().equals(apply.getType())) {
                apply.setSqr(apply.getCxrxm());
            }
            if (ReportApplyEnmu.委托查询.getKey().equals(apply.getType())) {
                apply.setSqr(apply.getWtrxm());
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
    @MethodDescription(desc = "审核自然人信用报告申请")
    @RequiresPermissions("credit.p.reportList")
    public ModelAndView toEnterpriseHis(HttpServletRequest request, String id) throws Exception {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/creditReport/center_p_report_audit");

        PersonReportApply pi = creditPReportService.getReportById(id);
        List<SysDictionaryVo> list = dictionaryService.queryByGroupKey("applyPReportPurpose");
        for (SysDictionaryVo dict : list) {
            if (pi.getPurpose().equals(dict.getDictKey())) {
                pi.setPurpose(dict.getDictValue());
            }
        }
        pi.setZxshyj(request.getParameter("zxshyj"));
        view.addObject("pi", pi);
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
    @MethodDescription(desc = "查看自然人信用报告申请单（中心）")
    @RequiresPermissions("credit.p.reportList")
    public ModelAndView toReportApplyView(HttpServletRequest request, String id) throws Exception {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/creditReport/center_p_report_view");

        PersonReportApply pi = creditPReportService.getReportById(id);
        List<SysDictionaryVo> list = dictionaryService.queryByGroupKey("applyPReportPurpose");
        for (SysDictionaryVo dict : list) {
            if (pi.getPurpose().equals(dict.getDictKey())) {
                pi.setPurpose(dict.getDictValue());
            }
        }
        view.addObject("pi", pi);

        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        view.addObject("audit", audit);
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
    @MethodDescription(desc = "保存自然人信用报告申请审核信息")
    @ResponseBody
    public String saveReprotAudit(PersonReportApply er) {
        try {
            er.setZxshr(new SysUser(getUserId()));
            creditPReportService.saveReprotAudit(er);

            // 保存信用报告操作记录
            Map<String, Object> logMap = new HashMap<String, Object>();
            logMap.put("appId", er.getId());
            logMap.put("businessName", ReportApplyEnmu.信用报告审核.getKey());
            logMap.put("userId", getUserId());
            logMap.put("remark", er.getZxshyj());
            creditReportQueryService.saveReportOperationLog(logMap);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.getMessage());
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
        return ResponseUtils.buildResultJson(true, "操作成功！");
    }
}
