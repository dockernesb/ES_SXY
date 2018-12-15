package com.udatech.hall.creditReport.controller;

import com.alibaba.fastjson.JSONObject;
import com.itextpdf.text.DocumentException;
import com.udatech.common.controller.SuperController;
import com.udatech.common.creditReportQuery.service.CreditReportQueryService;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.enmu.ReportApplyEnmu;
import com.udatech.common.model.PersonReportApply;
import com.udatech.common.model.StReportFontSizeConfig;
import com.udatech.common.resourceManage.model.CreditTemplate;
import com.udatech.common.resourceManage.service.CreditTemplateService;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.udatech.common.service.CreditCommonService;
import com.udatech.common.util.CreditReportPdfMaker;
import com.udatech.hall.creditReport.service.HallPReportService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.dictionary.service.DictionaryService;
import com.wa.framework.dictionary.vo.SysDictionaryVo;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.PageUtils;
import com.wa.framework.utils.RandomString;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <描述>：自然人-信用报告申请（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:52:15
 */
@Controller
@RequestMapping("/hallPReport")
public class HallPReportController extends SuperController {
    Logger log = Logger.getLogger(HallPReportController.class);

    @Autowired
    private CreditReportQueryService creditReportQueryService;

    @Autowired
    @Qualifier("creditTemplateService")
    private CreditTemplateService creditTemplateService;        // 信用报告模板service

    @Autowired
    private HallPReportService hallPReportService;

    @Autowired
    @Qualifier("dictionaryService")
    private DictionaryService dictionaryService;

    @Autowired
    private CreditCommonService creditCommonService;

    /**
     * @category 跳转信用报告申请页面
     * @return
     */
    @RequestMapping("/toReportApply")
    @RequiresPermissions("p.report.apply")
    @MethodDescription(desc = "申请自然人信用报告")
    public String toReportApply(Model model) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String bjbh = "XYBGSQ" + sdf.format(new Date()) + new RandomString().getRandomString(5, "i");
        model.addAttribute("bjbh", bjbh);

        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        model.addAttribute("audit", audit);
        return "/hall/creditReport/hall_p_report_apply";
    }

    /**
     * @category 保存信用报告申请
     * @param po
     * @return
     */
    @RequestMapping("/addReport")
    @RequiresPermissions("p.report.apply")
    @MethodDescription(desc = "生成自然人信用报告")
    @ResponseBody
    public String addReport(PersonReportApply po) {
        JSONObject msg = new JSONObject();
        try {
            // 信用报告申请是否审核开关：0不需要审核，1需要审核
            String audit = PropertyConfigurer.getValue("credit.report.audit");

            // 要立即生成信用报告，先校验默认模板是否存在
            CreditTemplate creditTemplate = creditTemplateService.getDefaultByCategory(DZThemeEnum.自然人.getKey());
            if ("0".equals(audit)) {
                if (creditTemplate == null || creditTemplate.getStatus().equals(DZThemeEnum.未定义.getKey())) {
                    log.error("无有效的自然人默认模板，请先配置默认模板！");
                    msg.put("result", false);
                    msg.put("message", "无有效的自然人默认模板，请先配置默认模板！");
                    return msg.toJSONString();
                }
                po.setStatus(ReportApplyEnmu.已通过.getKey());
            }

            // 校验申请报告的自然人基本信息是否存在
            Map<String, Object> basicInfo = creditCommonService.getPersonInfo(po.getCxrsfzh());
            if (basicInfo == null) {
                po.setIsHasBasic("0");// 无基本信息
                po.setStatus(ReportApplyEnmu.未通过.getKey());
            } else {
                po.setIsHasBasic("1");// 有基本信息
            }
            po.setIsAuditBack("0");
            po.setIsHasReport("0");
            po.setIsIssue("0");

            // 保存信用报告申请
            po.setCreateUser(new SysUser(getUserId()));
            po.setCreateDate(new Date());
            hallPReportService.addReport(po);

            // 保存信用报告操作记录
            Map<String, Object> logMap = new HashMap<String, Object>();
            logMap.put("appId", po.getId());
            logMap.put("businessName", ReportApplyEnmu.信用报告申请.getKey());
            logMap.put("userId", getUserId());
            logMap.put("remark", "");
            creditReportQueryService.saveReportOperationLog(logMap);

            String message = "信用报告申请成功！";
            if ("0".equals(audit)) {
                // 当不需要审核流程时，申请过后，就直接生成信用报告
                String xybgbh = generateCreditReport(po, creditTemplate);
                msg.put("xybgbh", xybgbh);
                message = "信用报告生成成功！";
            }

            msg.put("result", true);
            msg.put("id", po.getId());
            msg.put("bjbh", po.getBjbh());
            msg.put("message", message);
        } catch (Exception e) {
            log.error(e.getMessage(), e);

            msg.put("result", false);
            msg.put("message", "信用报告申请失败！");
        }
        return msg.toJSONString();
    }

    /**
     * <描述>: 生成信用报告
     * @author 作者：lijj
     * @version 创建时间：2017年3月4日上午11:36:09
     * @param po
     * @param creditTemplate
     * @return
     * @throws IOException
     * @throws DocumentException
     */
    private String generateCreditReport(PersonReportApply po, CreditTemplate creditTemplate) throws DocumentException, IOException {
        // 查询时间段，kssj:开始时间，jssj:结束时间
        String kssj = DateUtils.format(po.getSqbgqssj(), DateUtils.YYYYMMDD_10);
        String jssj = DateUtils.format(po.getSqbgjzsj(), DateUtils.YYYYMMDD_10);
        // 申请企业名称等基本信息
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("idCard", po.getCxrsfzh());
        params.put("name", po.getCxrxm());
        params.put("kssj", kssj);
        params.put("jssj", jssj);
        params.put("bjbh", po.getBjbh());// 信用报告申请单办件编号

        // 获取默认模板的详细信息
        List<TemplateThemeNode> themeInfo = creditTemplateService.getTemplateInfo(creditTemplate.getId(), DZThemeEnum.资源用途_报告查询.getKey());
        // 添加信用报告数据-自然人
        creditReportQueryService.getPCreditData(themeInfo, params);

        // 查询日期
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日");
        String queryDate = fmt.format(new Date());

        // 生成报告编码
        String bgbhSeq = creditReportQueryService.findBgbh("bgbh");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String xybgbh = "XYBGP" + sdf.format(new Date()) + String.format("%04d", Integer.parseInt(bgbhSeq));

        // 获取生成pdf路径
        String tmpHtmlPath = (String) PropertyConfigurer.getContextProperty("credit.report.html.path");
        File file = new File(tmpHtmlPath);
        if (!file.exists()) {
            file.mkdirs();
        }
        String genPath = tmpHtmlPath.replace("\\", "/");

        String realPath = this.getClass().getClassLoader().getResource("/").getPath();
        realPath = realPath.replace("WEB-INF/classes/", "");
        realPath = realPath.replaceAll("\\\\", "/");

        // 信用报告字体大小配置项
        StReportFontSizeConfig fontSize = creditReportQueryService.getReportFontSizeConfig();

        Map<String, Object> parameterMap = new HashMap<String, Object>();
        parameterMap.put("grxx", params);
        parameterMap.put("bgbh", xybgbh);
        parameterMap.put("queryDate", queryDate);
        parameterMap.put("themeInfo", themeInfo);
        parameterMap.put("template", creditTemplate);
        parameterMap.put("genPath", genPath);
        parameterMap.put("xybgbh", xybgbh);
        parameterMap.put("realPath", realPath);
        parameterMap.put("reportType", 2);// 生成信用报告类型：1 法人，2 自然人
        parameterMap.put("fontSize", fontSize);
        // 生成pdf
        CreditReportPdfMaker.createPdf(parameterMap);
        // 绑定报告编号和报告申请单的关系
        creditReportQueryService.updatePXybgbh(xybgbh, po.getId());
        return xybgbh;
    }

    /**
     * @category 打印信用报告反馈单
     * @param id
     * @return
     */
    @RequestMapping("/printReportApply")
    @RequiresPermissions("p.report.apply.print")
    @MethodDescription(desc = "打印自然人信用报告申请反馈单")
    public String printReport(String id, Model model) {
        PersonReportApply po = hallPReportService.getReportById(id);

        SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日");
        model.addAttribute("sqr", po.getCxrxm());
        model.addAttribute("sqrq", format.format(po.getCreateDate()));
        model.addAttribute("slbh", po.getBjbh());
        model.addAttribute("ywlx", "自然人信用报告申请");
        if (ReportApplyEnmu.本人查询.getKey().equals(po.getType())) {
            model.addAttribute("jbr", po.getCxrxm());
        } else if (ReportApplyEnmu.委托查询.getKey().equals(po.getType())) {
            model.addAttribute("jbr", po.getWtrxm());
        }
        model.addAttribute("slr", StringUtils.isNotBlank(po.getCreateUser().getRealName()) ? po.getCreateUser().getRealName() : po
                        .getCreateUser().getUsername());
        model.addAttribute("date", format.format(new Date()));
        model.addAttribute("isHasBasic", po.getIsHasBasic());
        return "/hall/creditReport/hall_p_report_print";
    }

    /**
     * @category 跳转信用报告查询列表页面
     * @return
     */
    @RequestMapping("/toReportList")
    @MethodDescription(desc = "查询自然人信用报告（大厅）")
    @RequiresPermissions("p.report.apply.read")
    public String toReportList(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        model.addAttribute("audit", audit);
        return "/hall/creditReport/hall_p_report_list";
    }

    /**
     * @category 获取信用报告申请单列表
     * @param pi
     * @return
     */
    @RequestMapping("/getReportList")
    @RequiresPermissions(value = {"p.report.print", "p.report.apply.read"}, logical = Logical.OR)
    @ResponseBody
    public String getReportList(PersonReportApply pi, String xybgbh, String isIssue, String isHasBasic, String isHasReport, String skipType) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                pi.setBjbm(dept.getId());
            }
        }
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("xybgbh", xybgbh);
        params.put("isIssue", isIssue);
        params.put("isHasBasic", isHasBasic);
        params.put("isHasReport", isHasReport);
        params.put("skipType", skipType); // 页面跳转类型：1业务端报告查询，2业务端报告打印

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<PersonReportApply> pageable = hallPReportService.getReportList(pi, params, page);
        for (PersonReportApply apply : pageable.getList()) {
            if (ReportApplyEnmu.企业自查.getKey().equals(apply.getType())) {
                apply.setSqr(apply.getCxrxm());
            }
            if (ReportApplyEnmu.委托查询.getKey().equals(apply.getType())) {
                apply.setSqr(apply.getWtrxm());
            }
        }
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * @category 跳转信用信用报告申请单查看页面
     * @return
     */
    @RequestMapping("/toReport")
    @MethodDescription(desc = "查看自然人信用报告申请单（大厅）")
    @RequiresPermissions(value = {"p.report.print", "p.report.apply.read"}, logical = Logical.OR)
    public String toReport(Model model, String id, String type) {
        PersonReportApply po = hallPReportService.getReportById(id);
        List<SysDictionaryVo> list = dictionaryService.queryByGroupKey("applyPReportPurpose");
        for (SysDictionaryVo dict : list) {
            if (po.getPurpose().equals(dict.getDictKey())) {
                po.setPurpose(dict.getDictValue());
            }
        }
        model.addAttribute("po", po);
        // type:0报告查询页面跳转过来的，1报告打印页面跳转过来的，页面上根据type值返回跳转前的页面
        model.addAttribute("type", type);

        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        model.addAttribute("audit", audit);
        return "/hall/creditReport/hall_p_report";
    }

    /**
     * @category 跳转信用报告打印列表页面
     * @return
     */
    @RequestMapping("/toReportPrintList")
    @MethodDescription(desc = "查询自然人信用报告打印列表")
    @RequiresPermissions("p.report.print")
    public String toReportPrintList(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        return "/hall/creditReport/hall_p_report_print_list";
    }

}
