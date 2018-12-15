package com.udatech.common.creditReportQuery.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.udatech.common.controller.SuperController;
import com.udatech.common.creditReportQuery.service.CreditReportQueryService;
import com.udatech.common.enmu.CreditDataStatusEnum;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.enmu.ReportApplyEnmu;
import com.udatech.common.model.DtCreditReportOperationLog;
import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.common.model.PersonReportApply;
import com.udatech.common.model.StReportFontSizeConfig;
import com.udatech.common.resourceManage.model.CreditTemplate;
import com.udatech.common.resourceManage.service.CreditTemplateService;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.udatech.common.service.CreditCommonService;
import com.udatech.common.util.CreditReportPdfMaker;
import com.wa.framework.OrderProperty;
import com.wa.framework.QueryCondition;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.security.XssAndSqlHttpServletRequestWrapper;
import com.wa.framework.service.BaseService;
import com.wa.framework.util.DateUtils;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <描述>： 公共信用报告内容查询<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月6日下午3:26:56
 */
@Controller
@RequestMapping("/reportQuery")
public class CreditReportQueryController extends SuperController {
    Logger logger = Logger.getLogger(CreditReportQueryController.class);
    private final SerializerFeature[] features = {SerializerFeature.WriteNullStringAsEmpty, SerializerFeature.WriteMapNullValue,
            SerializerFeature.WriteMapNullValue, SerializerFeature.WriteNullBooleanAsFalse, SerializerFeature.WriteNullNumberAsZero,
            SerializerFeature.WriteDateUseDateFormat, SerializerFeature.DisableCircularReferenceDetect};

    @Autowired
    private CreditReportQueryService creditReportQueryService;

    @Autowired
    private CreditCommonService creditCommonService;

    @Autowired
    private BaseService baseService;

    @Autowired
    @Qualifier("creditTemplateService")
    private CreditTemplateService creditTemplateService;        // 信用报告模板service

    /**
     * <描述>: 跳转查看信用报告页面
     * @author 作者：lijj
     * @version 创建时间：2016年5月12日下午10:42:39
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/toReportView")
    @MethodDescription(desc = "查询信用报告")
    @RequiresPermissions(value = {"report.apply.read", "credit.report.data.query"}, logical = Logical.OR)
    public ModelAndView queryCreditReport(HttpServletRequest request, EnterpriseReportApply er) throws Exception {
        ModelAndView view = new ModelAndView();
        view.setViewName("/common/creditReportQuery/credit_report");

        // 获取信用报告申请单信息
        er = creditReportQueryService.getReportApplyById(er.getId());

        // 查询时间段，kssj:开始时间，jssj:结束时间
        String kssj = DateUtils.format(er.getSqbgqssj(), DateUtils.YYYYMMDD_10);
        String jssj = DateUtils.format(er.getSqbgjzsj(), DateUtils.YYYYMMDD_10);

        // 申请企业名称等基本信息
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("zzjgdm", er.getZzjgdm());
        params.put("jgqc", er.getQymc());
        params.put("gszch", er.getGszch());
        params.put("tyshxydm", er.getTyshxydm());
        params.put("kssj", kssj);
        params.put("jssj", jssj);
        params.put("bjbh", er.getBjbh());// 信用报告申请单办件编号

        // 申请企业详细信息
        Map<String, Object> qyxx = creditReportQueryService.findEnterpriseInfoStrict(params);
        Date zcrq = (Date) qyxx.get("FZRQ");
        if (zcrq != null) {
            qyxx.put("FZRQ", DateUtils.format(zcrq, DateUtils.YYYYMMDD_10));
        } else {
            qyxx.put("FZRQ", "");
        }
        view.addObject("qyxx", qyxx);
        //
        CreditTemplate creditTemplate = creditTemplateService.getDefaultByCategory(DZThemeEnum.法人.getKey());
        if (creditTemplate == null || creditTemplate.getStatus().equals(DZThemeEnum.未定义.getKey())) {
            view.addObject("message", "无有效的法人默认模板，请先配置默认模板！");

            return view;
        }
        // 获取默认模板的详细信息
        List<TemplateThemeNode> themeInfo = creditTemplateService.getTemplateInfo(creditTemplate.getId(), DZThemeEnum.资源用途_报告查询.getKey());

        // 添加信用报告数据
        creditReportQueryService.getCreditData(themeInfo, params);

        // 标记有争议的数据，页面上特殊显示
        // 有争议的数据是指：异议申诉中的尚未完成修正的数据
        Map<String, List<String>> objectionData = commonService.getObjectionData(er.getQymc(), er.getZzjgdm(), er.getGszch(),
                        er.getTyshxydm());
        //  标记修复中的数据，页面上特殊显示
        Map<String, List<String>> repairData = commonService.getRepairData(er.getQymc(), er.getZzjgdm(), er.getGszch(),
                er.getTyshxydm());
        for (TemplateThemeNode theme : themeInfo) {// 一级资源
            for (TemplateThemeNode themeTwo : theme.getChildren()) {// 二级资源
                String tableName = themeTwo.getDataTable();
                List<Map<String, Object>> data = themeTwo.getData();
                List<String> objectionDataIds = objectionData.get(tableName);// 指定表tableName的异议数据id集合
                List<String> repairDataIds = repairData.get(tableName);// 指定表tableName的异议数据id集合
                // 标记数据
                if (data != null) {
                    for (Map<String, Object> map : data) {
                        String id = MapUtils.getString(map, "UUID");
                        if (objectionDataIds != null && objectionDataIds.contains(id)) {
                            map.put("checked", false);// 有争议的数据，页面列表中默认不选中
                            map.put("isObjection", true);// 是否是争议数据
                        } else {
                            map.put("isObjection", false);
                        }
                        if (repairDataIds != null && repairDataIds.contains(id)) {
                            map.put("isRepair", true);// 是否是修复中数据
                        } else {
                            map.put("isRepair", false);
                        }
                        String status = (String) map.get("STATUS");
                        if (StringUtils.isNotBlank(status)) {
                            if (CreditDataStatusEnum.已修复.getKey().equals(status)) {
                                map.put("checked", false);// 已修复的数据，页面列表中默认不选中
                            }
                        }
                    }
                }
            }
        }

        // 资源及数据信息，转json格式，页面js中处理后续数据传递
        String themeInfoJson = JSON.toJSONStringWithDateFormat(themeInfo, DateUtils.YYYYMMDD_10, features);
        themeInfoJson = themeInfoJson.replaceAll("\\\\n", "<br>").replaceAll("\\\\r", "<br>");
        view.addObject("themeInfoJson", themeInfoJson);
        logger.info("=====" + themeInfoJson);
        view.addObject("params", JSON.toJSONStringWithDateFormat(params, DateUtils.YYYYMMDD_10, features));

        view.addObject("themeInfo", themeInfo);
        view.addObject("businessId", er.getId());// 信用报告申请单的id
        view.addObject("templateId", creditTemplate.getId());
        view.addObject("zxshyj", request.getParameter("zxshyj"));// 中心审核意见
        return view;
    }

    /**
     * <描述>: 生成信用报告打印静态页面
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日上午11:07:02
     * @param request
     * @param response
     * @param writer
     * @return
     * @throws Exception
     */
    @RequestMapping("/generateReportHtml")
    public ModelAndView generateReportHtml(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView view = new ModelAndView();
        view.setViewName("/common/creditReportQuery/report_print_template");

        String templateId = request.getParameter("templateId");// 信用报告模板id
        String bgbh = request.getParameter("bgbh");
        String params = request.getParameter("params");
        String themeInfo = XssAndSqlHttpServletRequestWrapper.getOrgRequest(request).getParameter("themeInfo");
        params = HtmlUtils.htmlUnescape(params);

        // 企业信息
        Map<String, Object> paramsMap = JSON.parseObject(params, new TypeReference<Map<String, Object>>() {
        });
        Map<String, Object> qyxx = creditReportQueryService.findEnterpriseInfoStrict(paramsMap);
        qyxx.put("KSSJ", paramsMap.get("kssj"));
        qyxx.put("JSSJ", paramsMap.get("jssj"));
        Date zcrq = (Date) qyxx.get("FZRQ");
        if (zcrq != null) {
            qyxx.put("FZRQ", DateUtils.format(zcrq, DateUtils.YYYYMMDD_10));
        } else {
            qyxx.put("FZRQ", "");
        }

        // 查询日期
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日");
        String queryDate = fmt.format(new Date());

        // 获取默认模板的详细信息
        CreditTemplate template = creditTemplateService.findById(CreditTemplate.class, templateId);
        String templateJson = PageUtils.toJSONString(template, DateUtils.YYYYMMDD_10);

        view.addObject("qyxx", qyxx);
        view.addObject("bgbh", bgbh);
        view.addObject("queryDate", queryDate);
        view.addObject("themeInfo", themeInfo);
        view.addObject("template", template);
        view.addObject("templateJson", templateJson);
        view.addObject("businessId", request.getParameter("businessId"));
        return view;
    }

    /**
     * <描述>: 生成法人信用报告pdf
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日下午5:27:23
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/generateReportView")
    @RequiresPermissions(value = {"report.apply.read", "credit.report.data.query"}, logical = Logical.OR)
    public void generateReportView(HttpServletRequest request, Writer writer, String businessId) throws Exception {
        String templateId = request.getParameter("templateId");
        String params = request.getParameter("params");
        String themeInfo = request.getParameter("themeInfo");
        params = HtmlUtils.htmlUnescape(params);
        themeInfo = HtmlUtils.htmlUnescape(themeInfo);
        try {
            themeInfo = themeInfo.replaceAll("<br>", "\\\\n");
            // 企业信用数据信息
            List<TemplateThemeNode> themeInfoObj = JSON.parseObject(themeInfo, new TypeReference<List<TemplateThemeNode>>() {
            });

            Map<String, Object> paramsMap = JSON.parseObject(params, new TypeReference<Map<String, Object>>() {
            });
            // 企业基本信息
            Map<String, Object> qyxx = creditReportQueryService.findEnterpriseInfoStrict(paramsMap);
            qyxx.put("KSSJ", paramsMap.get("kssj"));
            qyxx.put("JSSJ", paramsMap.get("jssj"));
            Date zcrq = (Date) qyxx.get("ZCRQ");
            if (zcrq != null) {
                qyxx.put("ZCRQ", DateUtils.format(zcrq, DateUtils.YYYYMMDD_10));
            } else {
                qyxx.put("ZCRQ", "");
            }
            // 查询日期
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日");
            String queryDate = fmt.format(new Date());

            // 获取默认模板的详细信息
            CreditTemplate template = creditTemplateService.findById(CreditTemplate.class, templateId);

            // 生成报告编码
            String bgbhSeq = creditReportQueryService.findBgbh("bgbh");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String xybgbh = "XYBGP" + sdf.format(new Date()) + String.format("%04d", Integer.parseInt(bgbhSeq));

            // 生成pdf的路径
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
            parameterMap.put("qyxx", qyxx);
            parameterMap.put("bgbh", xybgbh);
            parameterMap.put("queryDate", queryDate);
            parameterMap.put("themeInfo", themeInfoObj);
            parameterMap.put("template", template);
            parameterMap.put("genPath", genPath);
            parameterMap.put("xybgbh", xybgbh);
            parameterMap.put("realPath", realPath);
            parameterMap.put("reportType", 1);// 生成信用报告类型：1 法人，2 自然人
            parameterMap.put("fontSize", fontSize);
            // 生成pdf
            CreditReportPdfMaker.createPdf(parameterMap);

            // 绑定报告编号和报告申请单的关系
            creditReportQueryService.updateXybgbh(xybgbh, businessId);

            writer.write(ResponseUtils.buildResultJson(true, xybgbh));
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            writer.write(ResponseUtils.buildResultJson(false));
        }
    }

    /** =================================自然人信用报告数据查询============================================== */
    /**
     * <描述>: 跳转查看信用报告页面
     * @author 作者：lijj
     * @version 创建时间：2016年5月12日下午10:42:39
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/toPReportView")
    @MethodDescription(desc = "查询自然人信用报告")
    @RequiresPermissions("credit.p.report.data")
    public ModelAndView queryCreditPReport(HttpServletRequest request, PersonReportApply pr) throws Exception {
        ModelAndView view = new ModelAndView();
        view.setViewName("/common/creditReportQuery/p_credit_report");

        // 获取信用报告申请单信息
        pr = creditReportQueryService.getPReportApplyById(pr.getId());

        // 查询时间段，kssj:开始时间，jssj:结束时间
        String kssj = DateUtils.format(pr.getSqbgqssj(), DateUtils.YYYYMMDD_10);
        String jssj = DateUtils.format(pr.getSqbgjzsj(), DateUtils.YYYYMMDD_10);

        // 申请企业名称等基本信息
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("idCard", pr.getCxrsfzh());
        params.put("name", pr.getCxrxm());
        params.put("kssj", kssj);
        params.put("jssj", jssj);
        params.put("bjbh", pr.getBjbh());// 信用报告申请单办件编号

        Map<String, Object> zrrxx = creditReportQueryService.findEnterpriseInfoStrictZrr(params);
        Date csrq = (Date) zrrxx.get("CSRQ");
        if (csrq != null) {
            zrrxx.put("CSRQ", DateUtils.format(csrq, DateUtils.YYYYMMDD_10));
        } else {
            zrrxx.put("CSRQ", "");
        }
        
        view.addObject("idCard", pr.getCxrsfzh());
        view.addObject("name", pr.getCxrxm());
        view.addObject("zrrxx", zrrxx);

        CreditTemplate creditTemplate = creditTemplateService.getDefaultByCategory(DZThemeEnum.自然人.getKey());
        if (creditTemplate == null || creditTemplate.getStatus().equals(DZThemeEnum.未定义.getKey())) {
            view.addObject("message", "无有效的自然人默认模板，请先配置默认模板！");
            return view;
        }
        // 获取默认模板的详细信息
        List<TemplateThemeNode> themeInfo = creditTemplateService.getTemplateInfo(creditTemplate.getId(), DZThemeEnum.资源用途_报告查询.getKey());

        // 添加信用报告数据-自然人
        creditReportQueryService.getPCreditData(themeInfo, params);

        // 资源及数据信息，转json格式，页面js中处理后续数据传递
        String themeInfoJson = JSON.toJSONStringWithDateFormat(themeInfo, DateUtils.YYYYMMDD_10, features);
        themeInfoJson = themeInfoJson.replaceAll("\\\\n", "<br>");
        view.addObject("themeInfoJson", themeInfoJson);
        view.addObject("params", JSON.toJSONStringWithDateFormat(params, DateUtils.YYYYMMDD_10, features));

        view.addObject("themeInfo", themeInfo);
        view.addObject("businessId", pr.getId());// 信用报告申请单的id
        view.addObject("templateId", creditTemplate.getId());
        view.addObject("zxshyj", request.getParameter("zxshyj"));// 中心审核意见
        return view;
    }

    /**
     * <描述>: 生成信用报告打印静态页面
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日上午11:07:02
     * @param request
     * @param response
     * @param writer
     * @return
     * @throws Exception
     */
    @RequestMapping("/generatePReportHtml")
    public ModelAndView generatePReportHtml(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        ModelAndView view = new ModelAndView();
        view.setViewName("/common/creditReportQuery/p_report_print_template");

        String templateId = request.getParameter("templateId");// 信用报告模板id
        String bgbh = request.getParameter("bgbh");
        String params = request.getParameter("params");
        String themeInfo = XssAndSqlHttpServletRequestWrapper.getOrgRequest(request).getParameter("themeInfo");
        params = HtmlUtils.htmlUnescape(params);

        // 个人基本信息
        Map<String, Object> grxx = JSON.parseObject(params, new TypeReference<Map<String, Object>>() {
        });
        //基本表中拿到个人信息
        Map<String, Object> zrrxx = creditReportQueryService.findEnterpriseInfoStrictZrr(grxx);
        
        Date csrq = (Date) zrrxx.get("CSRQ");
        if (csrq != null) {
            zrrxx.put("CSRQ", DateUtils.format(csrq, DateUtils.YYYYMMDD_10));
        } else {
            zrrxx.put("CSRQ", "");
        }
        
        // 查询日期
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日");
        String queryDate = fmt.format(new Date());

        // 获取默认模板的详细信息
        CreditTemplate template = creditTemplateService.findById(CreditTemplate.class, templateId);
        String templateJson = PageUtils.toJSONString(template, DateUtils.YYYYMMDD_10);

        view.addObject("grxx", grxx);
        view.addObject("zrrxx", zrrxx);
        view.addObject("bgbh", bgbh);
        view.addObject("queryDate", queryDate);
        view.addObject("themeInfo", themeInfo);
        view.addObject("template", template);
        view.addObject("templateJson", templateJson);
        return view;
    }

    /**
     * <描述>: 生成自然人信用报告pdf
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日下午5:27:23
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/generatePReportView")
    @RequiresPermissions("credit.p.report.data")
    public void generatePReportView(HttpServletRequest request, Writer writer, String businessId) throws Exception {
        String templateId = request.getParameter("templateId");
        String params = request.getParameter("params");
        String themeInfo = request.getParameter("themeInfo");
        params = HtmlUtils.htmlUnescape(params);
        themeInfo = HtmlUtils.htmlUnescape(themeInfo);
        try {
            themeInfo = themeInfo.replaceAll("<br>", "\\\\n");

            // 个人信用数据信息
            List<TemplateThemeNode> themeInfoObj = JSON.parseObject(themeInfo, new TypeReference<List<TemplateThemeNode>>() {
            });

            // 个人基本信息
            Map<String, Object> grxx = JSON.parseObject(params, new TypeReference<Map<String, Object>>() {
            });
            //基本表中拿到个人信息
            Map<String, Object> zrrxx = creditReportQueryService.findEnterpriseInfoStrictZrr(grxx);           
            Date csrq = (Date) zrrxx.get("CSRQ");
            if (csrq != null) {
                zrrxx.put("CSRQ", DateUtils.format(csrq, DateUtils.YYYYMMDD_10));
            } else {
                zrrxx.put("CSRQ", "");
            }
            
            // 查询日期
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日");
            String queryDate = fmt.format(new Date());

            // 获取默认模板的详细信息
            CreditTemplate template = creditTemplateService.findById(CreditTemplate.class, templateId);

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
            parameterMap.put("grxx", grxx);
            parameterMap.put("zrrxx", zrrxx);
            parameterMap.put("bgbh", xybgbh);
            parameterMap.put("queryDate", queryDate);
            parameterMap.put("themeInfo", themeInfoObj);
            parameterMap.put("template", template);
            parameterMap.put("genPath", genPath);
            parameterMap.put("xybgbh", xybgbh);
            parameterMap.put("realPath", realPath);
            parameterMap.put("reportType", 2);// 生成信用报告类型：1 法人，2 自然人
            parameterMap.put("fontSize", fontSize);
            // 生成pdf
            CreditReportPdfMaker.createPdf(parameterMap);

            // 绑定报告编号和报告申请单的关系
            creditReportQueryService.updatePXybgbh(xybgbh, businessId);

            writer.write(ResponseUtils.buildResultJson(true, xybgbh));
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            writer.write(ResponseUtils.buildResultJson(false));
        }
    }

    /**
     * <描述>: 预览信用报告pdf
     * @author 作者：Ljj
     * @version 创建时间：2017年8月30日上午11:06:18
     * @param model
     * @return
     */
    @RequestMapping("/viewReport")
    public String viewPdf(Model model, String xybgbh, String jgqc) {
        String tmpHtmlPath = (String) PropertyConfigurer.getContextProperty("credit.report.html.path");
        String genPath = tmpHtmlPath.replace("\\", "/");
        String path = genPath + "/" + xybgbh + ".pdf";
        File file = new File(path);
        if (file.exists()) {
            model.addAttribute("exists", true);
            Calendar cal = Calendar.getInstance();
            long time = file.lastModified();
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
            cal.setTimeInMillis(time);
            String date = formatter.format(cal.getTime());
            String fact = genPath + "/temp/" + jgqc + "信用报告" + date + ".pdf";
            fact = fact.replaceAll("/+", "/");
            File factFile = new File(fact);
            if (factFile.exists()) {
                factFile.delete();
            }
            try {
                FileUtils.copyFile(file, factFile);
                model.addAttribute("fact", "/$_virtual_path_$/" + fact);
            } catch (IOException e) {
                e.printStackTrace();
                model.addAttribute("fact", null);
            }
        } else {
            model.addAttribute("exists", false);
        }
        return "/common/view/view_pdf";
    }

    /**
     * 保存信用报告打印操作日志表
     * @param request
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/saveReportPrintLog")
    @MethodDescription(desc = "保存信用报告打印操作日志")
    public void saveReportPrintLog(HttpServletRequest request, Writer writer) throws Exception {

        try {
            Map<String, Object> logMap = new HashMap<String, Object>();
            logMap.put("userId", getUserId());
            logMap.put("appId", request.getParameter("appId"));
            logMap.put("businessName", ReportApplyEnmu.信用报告预览.getKey());
            logMap.put("remark", request.getParameter("remark"));
            creditReportQueryService.saveReportOperationLog(logMap);
        } catch (Exception e) {
            logger.error(e.getMessage());
            writer.write(ResponseUtils.buildResultJson(false));
        }
        writer.write(ResponseUtils.buildResultJson(true));

    }

    /**
     * 查询信用报告操作日志
     * @param request
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/toReportPrintLog")
    @MethodDescription(desc = "查询信用报告操作日志")
    public ModelAndView toReportPrintLog(HttpServletRequest request, Writer writer) throws Exception {
        ModelAndView view = new ModelAndView();
        String applyId = request.getParameter("applyId");
        String skipType = request.getParameter("skipType"); // 跳转到本页面的来源页面：1法人报告查询，2自然人报告查询 
        view.setViewName("common/creditReportQuery/report_operation_log");
        view.addObject("applyId", applyId);
        view.addObject("skipType", skipType);
        return view;
    }

    /**
     * 查询信用报告操作日志
     * @param request
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/queryReportOperationLog")
    public void queryReportOperationLog(HttpServletRequest request, Writer writer) throws Exception {

        String applyId = request.getParameter("applyId");

        List<DtCreditReportOperationLog> list = baseService.find(DtCreditReportOperationLog.class,
                        OrderProperty.desc(DtCreditReportOperationLog.OPERATION_DATE),
                        QueryCondition.eq(DtCreditReportOperationLog.APPLY_ID, applyId));
        writer.write(ResponseUtils.toJSONString(list));

    }
}
