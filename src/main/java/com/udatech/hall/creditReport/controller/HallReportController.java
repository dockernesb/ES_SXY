package com.udatech.hall.creditReport.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.itextpdf.text.DocumentException;
import com.udatech.common.controller.SuperController;
import com.udatech.common.creditReportQuery.service.CreditReportQueryService;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.enmu.ReportApplyEnmu;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.common.model.StReportFontSizeConfig;
import com.udatech.common.resourceManage.model.CreditTemplate;
import com.udatech.common.resourceManage.service.CreditTemplateService;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.udatech.common.util.CreditReportPdfMaker;
import com.udatech.hall.creditReport.service.HallReportService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dictionary.service.DictionaryService;
import com.wa.framework.dictionary.vo.SysDictionaryVo;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import com.wa.framework.utils.RandomString;
import org.apache.commons.collections.MapUtils;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <描述>：信用报告申请（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:52:15
 */
@Controller
@RequestMapping("/hallReport")
public class HallReportController extends SuperController {
    Logger log = Logger.getLogger(HallReportController.class);

    @Autowired
    private CreditReportQueryService creditReportQueryService;

    @Autowired
    @Qualifier("creditTemplateService")
    private CreditTemplateService creditTemplateService;        // 信用报告模板service

    @Autowired
    private HallReportService hallReportService;

    @Autowired
    @Qualifier("dictionaryService")
    private DictionaryService dictionaryService;

    /**
     * @category 跳转信用报告申请页面
     * @return
     */
    @RequestMapping("/toReportApply")
    @MethodDescription(desc = "申请法人信用报告")
    @RequiresPermissions("credit.report.apply")
    public String toReportApply(Model model) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String bjbh = "XYBGSQ" + sdf.format(new Date()) + new RandomString().getRandomString(5, "i");
        model.addAttribute("bjbh", bjbh);
        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        model.addAttribute("audit", audit);
        return "/hall/creditReport/hall_report_apply";
    }

    /**
     * @category 保存信用报告申请
     * @param eo
     * @return
     */
    @RequestMapping("/addReport")
    @MethodDescription(desc = "生成法人信用报告")
    @RequiresPermissions("credit.report.apply")
    @ResponseBody
    public String addReport(EnterpriseReportApply eo) {
        JSONObject msg = new JSONObject();
        try {
            // 信用报告申请是否审核开关：0不需要审核，1需要审核
            String audit = PropertyConfigurer.getValue("credit.report.audit");

            // 要立即生成信用报告，先校验默认模板是否存在
            CreditTemplate creditTemplate = creditTemplateService.getDefaultByCategory(DZThemeEnum.法人.getKey());
            if ("0".equals(audit)) {
                if (creditTemplate == null || creditTemplate.getStatus().equals(DZThemeEnum.未定义.getKey())) {
                    log.error("无有效的法人默认模板，请先配置默认模板！");
                    msg.put("result", false);
                    msg.put("message", "无有效的法人默认模板，请先配置默认模板！");
                    return msg.toJSONString();
                }
                eo.setStatus(ReportApplyEnmu.已通过.getKey());
            }

            // 校验申请报告的企业基本信息是否存在
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("jgqc", eo.getQymc());
            params.put("zzjgdm", eo.getZzjgdm());
            params.put("gszch", eo.getGszch());
            params.put("tyshxydm", eo.getTyshxydm());
            Map<String, Object> basicInfo = creditReportQueryService.findEnterpriseInfoStrict(params);
            if (basicInfo == null) {
                eo.setIsHasBasic("0");// 无基本信息
                eo.setStatus(ReportApplyEnmu.未通过.getKey());
            } else {
                eo.setIsHasBasic("1");// 有基本信息
            }

            eo.setIsAuditBack("0");
            eo.setIsHasReport("0");
            eo.setIsIssue("0");
            // 保存信用报告申请
            eo.setCreateUser(new SysUser(getUserId()));
            eo.setCreateDate(new Date());
            hallReportService.addReport(eo);

            // 保存信用报告操作记录
            Map<String, Object> logMap = new HashMap<String, Object>();
            logMap.put("appId", eo.getId());
            logMap.put("businessName", ReportApplyEnmu.信用报告申请.getKey());
            logMap.put("userId", getUserId());
            logMap.put("remark", "");
            creditReportQueryService.saveReportOperationLog(logMap);

            String message = "信用报告申请成功！";
            if ("0".equals(audit)) {
                // 当不需要审核流程时，申请过后，就直接生成信用报告
                String xybgbh = generateCreditReport(eo, creditTemplate);
                msg.put("xybgbh", xybgbh);
                message = "信用报告生成成功！";
            }

            msg.put("result", true);
            msg.put("id", eo.getId());
            msg.put("bjbh", eo.getBjbh());
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
     * @param eo
     * @param creditTemplate
     * @return
     * @throws IOException
     * @throws DocumentException
     */
    private String generateCreditReport(EnterpriseReportApply eo, CreditTemplate creditTemplate) throws DocumentException, IOException {
        // 查询时间段，kssj:开始时间，jssj:结束时间
        String kssj = DateUtils.format(eo.getSqbgqssj(), DateUtils.YYYYMMDD_10);
        String jssj = DateUtils.format(eo.getSqbgjzsj(), DateUtils.YYYYMMDD_10);
        // 申请企业名称等基本信息
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("zzjgdm", eo.getZzjgdm());
        params.put("jgqc", eo.getQymc());
        params.put("gszch", eo.getGszch());
        params.put("tyshxydm", eo.getTyshxydm());
        params.put("kssj", kssj);
        params.put("jssj", jssj);
        params.put("bjbh", eo.getBjbh());// 信用报告申请单办件编号

        // 获取默认模板的详细信息
        List<TemplateThemeNode> themeInfo = creditTemplateService.getTemplateInfo(creditTemplate.getId(), DZThemeEnum.资源用途_报告查询.getKey());
        // 添加信用报告数据
        creditReportQueryService.getCreditData(themeInfo, params);

        // 标记有争议的数据，页面上特殊显示
        // 有争议的数据是指：异议申诉中的尚未完成修正的数据
        Map<String, List<String>> objectionData = commonService.getObjectionData(eo.getQymc(), eo.getZzjgdm(), eo.getGszch(),
                        eo.getTyshxydm());
        for (TemplateThemeNode theme : themeInfo) {// 一级资源
            for (TemplateThemeNode themeTwo : theme.getChildren()) {// 二级资源
                String tableName = themeTwo.getDataTable();
                List<Map<String, Object>> data = themeTwo.getData();
                List<String> objectionDataIds = objectionData.get(tableName);// 指定表tableName的异议数据id集合
                // 标记数据
                if (data != null) {
                    for (Map<String, Object> map : data) {
                        String id = MapUtils.getString(map, "UUID");
                        if (objectionDataIds != null && objectionDataIds.contains(id)) {
                            map.put("checked", true);// 有争议的数据，无审核流程时默认选中
                            map.put("isObjection", true);// 是否是争议数据
                        } else {
                            map.put("isObjection", false);
                        }
                    }
                }
            }
        }

        // 企业基本信息
        Map<String, Object> qyxx = creditReportQueryService.findEnterpriseInfoStrict(params);
        qyxx.put("KSSJ", params.get("kssj"));
        qyxx.put("JSSJ", params.get("jssj"));
        Date zcrq = (Date) qyxx.get("ZCRQ");
        if (zcrq != null) {
            qyxx.put("ZCRQ", DateUtils.format(zcrq, DateUtils.YYYYMMDD_10));
        } else {
            qyxx.put("ZCRQ", "");
        }
        // 查询日期
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日");
        String queryDate = fmt.format(new Date());

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
        parameterMap.put("themeInfo", themeInfo);
        parameterMap.put("template", creditTemplate);
        parameterMap.put("genPath", genPath);
        parameterMap.put("xybgbh", xybgbh);
        parameterMap.put("realPath", realPath);
        parameterMap.put("reportType", 1);// 生成信用报告类型：1 法人，2 自然人
        parameterMap.put("fontSize", fontSize);
        // 生成pdf
        CreditReportPdfMaker.createPdf(parameterMap);
        // 绑定报告编号和报告申请单的关系
        creditReportQueryService.updateXybgbh(xybgbh, eo.getId());
        return xybgbh;
    }

    /**
     * @category 打印信用报告反馈单
     * @param id
     * @return
     */
    @RequestMapping("/printReportApply")
    @MethodDescription(desc = "打印法人信用报告申请反馈单")
    @RequiresPermissions(value = {"credit.report.apply.print", "report.apply.read"}, logical = Logical.OR)
    public String printReport(String id, Model model) {
        EnterpriseReportApply eo = hallReportService.getReportById(id);

        SimpleDateFormat format = new SimpleDateFormat("yyyy年MM月dd日");
        model.addAttribute("sqr", eo.getQymc());
        model.addAttribute("sqrq", format.format(eo.getCreateDate()));
        model.addAttribute("slbh", eo.getBjbh());
        model.addAttribute("ywlx", "法人信用报告申请");
        if (ReportApplyEnmu.企业自查.getKey().equals(eo.getType())) {
            model.addAttribute("jbr", eo.getJbrxm());
        } else if (ReportApplyEnmu.委托查询.getKey().equals(eo.getType())) {
            model.addAttribute("jbr", eo.getSqqymc());
        }
        model.addAttribute("slr", StringUtils.isNotBlank(eo.getCreateUser().getRealName()) ? eo.getCreateUser().getRealName() : eo
                        .getCreateUser().getUsername());
        model.addAttribute("date", format.format(new Date()));
        model.addAttribute("isHasBasic", eo.getIsHasBasic());
        return "/hall/creditReport/hall_report_print";
    }

    /**
     * @category 跳转信用报告查询列表页面
     * @return
     */
    @RequestMapping("/toReportList")
    @MethodDescription(desc = "查询法人信用报告（大厅）")
    @RequiresPermissions("report.apply.read")
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
        return "/hall/creditReport/hall_report_list";
    }

    /**
     * @category 获取信用报告申请单列表
     * @param ei
     * @return
     */
    @RequestMapping("/getReportList")
    @RequiresPermissions(value = {"report.print", "report.apply.read"}, logical = Logical.OR)
    @ResponseBody
    public String getReportList(EnterpriseInfo ei, String xybgbh, String isIssue, String isHasBasic, String isHasReport, String skipType,String jbr) {
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
        params.put("skipType", skipType); // 页面跳转类型：1业务端报告查询，2业务端报告打印，
        params.put("jbr",jbr);

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<EnterpriseReportApply> pageable = hallReportService.getReportList(ei, params, page);
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
     * @category 跳转法人信用报告申请单查看页面
     * @return
     */
    @RequestMapping("/toReport")
    @MethodDescription(desc = "查看法人信用报告申请单（大厅）")
    @RequiresPermissions(value = {"report.print", "report.apply.read"}, logical = Logical.OR)
    public String toReport(Model model, String id, String type) {
        EnterpriseReportApply eo = hallReportService.getReportById(id);
        List<SysDictionaryVo> list = dictionaryService.queryByGroupKey("applyReportPurpose");
        for (SysDictionaryVo dict : list) {
            if (eo.getPurpose().equals(dict.getDictKey())) {
                eo.setPurpose(dict.getDictValue());
            }
        }
        model.addAttribute("eo", eo);
        // type:0报告查询页面跳转过来的，1报告打印页面跳转过来的，页面上根据type值返回跳转前的页面
        model.addAttribute("type", type);

        // 信用报告申请是否审核开关：0不需要审核，1需要审核
        String audit = PropertyConfigurer.getValue("credit.report.audit");
        model.addAttribute("audit", audit);
        return "/hall/creditReport/hall_report";
    }

    /**
     * @category 跳转信用报告打印列表页面
     * @return
     */
    @RequestMapping("/toReportPrintList")
    @MethodDescription(desc = "查询法人信用报告打印列表")
    @RequiresPermissions("report.print")
    public String toReportPrintList(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        return "/hall/creditReport/hall_report_print_list";
    }

    @RequestMapping("/printProvinceReport")
    @MethodDescription(desc = "打印省报告")
    @RequiresPermissions(value = {"report.print", "report.apply.read"}, logical = Logical.OR)
    @ResponseBody
    public String printProvinceReport(Model model, String id) {
        JSONObject jsonObject = new JSONObject();

        EnterpriseReportApply eo = hallReportService.getReportById(id);
        List<UploadFile> sbg = eo.getSbg();
        if (sbg != null && sbg.size() > 0) {
            String uploadFileId = sbg.get(0).getUploadFileId();
            jsonObject.put("result", true);
            jsonObject.put("message", uploadFileId);
        } else {
            jsonObject.put("result", false);
            jsonObject.put("message", "无省报告或省报告文件不存在！");
        }

        return jsonObject.toJSONString();
    }

    /**
     * <描述>: 获取报告用途字典项，且按字典名称排序
     * @author 作者：Ljj
     * @version 创建时间：2017年8月12日下午5:05:41
     * @param groupKey
     * @return
     * @throws Exception
     */
    @RequestMapping("/listValues")
    @ResponseBody
    @RequiresPermissions("credit.report.apply")
    public String listValues(String groupKey) throws Exception {
        List<SysDictionaryVo> list = hallReportService.queryByGroupKey(groupKey);
        int size = list.size();

        Map<String, Object> resMap = new HashMap<String, Object>();
        List<Map<String, Object>> items = new ArrayList<Map<String, Object>>();
        resMap.put("total", size);
        resMap.put("items", items);
        for (int i = 0; i < size; i++) {
            SysDictionaryVo dict = list.get(i);
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("id", dict.getDictKey());
            item.put("text", dict.getDictValue());
            items.add(item);
        }
        return JSON.toJSONString(resMap);
    }

    /**
     * 
     * @Description: 打印页面中，新增的已办结按钮
     * @param: @param request
     * @param: @param response
     * @param: @param writer
     * @param: @param enterpriseReportApply
     * @param: @throws IOException
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    @MethodDescription(desc="已办结")
    @RequestMapping("/finishPrintTask")
    @RequiresPermissions("report.print")
    public void finishPrintTaskByIssue(HttpServletRequest request, HttpServletResponse response, Writer writer,
                    EnterpriseReportApply enterpriseReportApply)throws IOException{
        String json = ResponseUtils.buildResultJson(true);        
        try {
            hallReportService.finishPrintTaskByIsIssue(enterpriseReportApply);
        } catch (Exception e) {            
            json = ResponseUtils.buildResultJson(false);
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(json);
        
    }
}
