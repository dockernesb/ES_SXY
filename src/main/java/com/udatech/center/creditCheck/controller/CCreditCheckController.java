package com.udatech.center.creditCheck.controller;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.constant.Constants;
import com.udatech.common.controller.SuperController;
import com.udatech.common.creditCheck.service.CreditCheckService;
import com.udatech.common.creditCheck.service.impl.CreditCheckServiceImpl;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.CreditExamine;
import com.udatech.common.model.CreditExamineHis;
import com.udatech.common.model.EnterpriseExamine;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.FileUtils;
import com.udatech.common.util.IdentityUtil;
import com.wa.framework.Pageable;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.user.service.MessageService;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import com.wa.framework.utils.RandomString;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Description: 信用审查C(中心端)
 * @author: 何斐
 * @date: 2016年11月21日 下午3:57:00
 */
@Controller
@RequestMapping("/center/creditCheck")
public class CCreditCheckController extends SuperController {

    @Autowired
    private CreditCheckService cCreditCheckService;

    @Autowired
    private BaseService baseService;

    @Autowired
    private MessageService messageService;

    /**
     * @param response
     * @param request
     * @return
     * @Title: toCreditCheckList
     * @Description: 进入审核列表页面
     * @return: ModelAndView
     */
    @MethodDescription(desc = "信用审查审核（中心）")
    @RequiresPermissions("center.creditCheck.examineList")
    @RequestMapping("/toCreditExamineAuditList")
    public String toCreditExamineAuditList(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        model.addAttribute("type", 1);
        return "/center/creditCheck/cCreditCheckList";
    }

    /**
     * @param response
     * @param request
     * @return
     * @Title: toCreditCheckList
     * @Description: 进入审核列表页面
     * @return: ModelAndView
     */
    @MethodDescription(desc = "信用审查查看（中心）")
    @RequiresPermissions("center.creditCheck.examineList")
    @RequestMapping("/toCreditExamineList")
    public String toCreditExamineList(Model model) {
        SysDepartment dept = getUserDept();
        model.addAttribute("bmlx", 0);  //  中心用户
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                model.addAttribute("bmlx", 1);  //  区县用户
            }
        }
        model.addAttribute("type", 2);
        return "/center/creditCheck/cCreditCheckList";
    }

    /**
     * @param request
     * @param response
     * @return
     * @throws Exception
     * @Title: queryApplyList
     * @Description: 查询申请列表
     * @return: String
     */
    @ResponseBody
    @RequestMapping("/queryApplyList")
    @RequiresPermissions("center.creditCheck.examineList")
    public String queryApplyList(String type, String bjbm) {
        SysDepartment dept = getUserDept();
        if (dept != null) {
            String code = dept.getCode();
            if (org.apache.commons.lang.StringUtils.isNotBlank(code) && code.indexOf("B") == 0) {
                bjbm = dept.getId();
            }
        }
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        String sysuserid = CommonUtil.getCurrentUserId();
        String scmc = request.getParameter("scmc");
        String xqbm = request.getParameter("xqbm");
        String bjbh = request.getParameter("bjbh");
        String sqsjs = request.getParameter("sqsjs");
        String sqsjz = request.getParameter("sqsjz");
        String status = request.getParameter("status");
        Pageable<CreditExamine> page = cCreditCheckService.queryApplyList(dtParams.getPage(), scmc, xqbm, bjbh, sqsjs,
                sqsjz, sysuserid, status, type, bjbm);
        return PageUtils.buildDTData(page, request);
    }

    /**
     * @param request
     * @param response
     * @return
     * @throws Exception
     * @Title: toView
     * @Description: 查看详细
     * @return: ModelAndView
     */
    @ResponseBody
    @RequestMapping("/toView")
    @MethodDescription(desc = "查看信用审查详细（中心）")
    @RequiresPermissions("center.creditCheck.examine")
    public ModelAndView toView(HttpServletRequest request, HttpServletResponse response, String id) throws Exception {
        CreditExamine creditExamine = baseService.findById(CreditExamine.class, id);
        String scsjs = DateFormatUtils.format(creditExamine.getScsjs(), "yyyy-MM");
        String scsjz = DateFormatUtils.format(creditExamine.getScsjz(), "yyyy-MM");
        String deptName = creditExamine.getScxqbm().getDepartmentName();
        String userName = creditExamine.getCreateUser().getUsername();
        String status = creditExamine.getStatus();
        CreditExamineHis creditExamineHis = cCreditCheckService.findCreditExamineHisByCreditExamineId(id);

        // 获取附件信息
        String file_sqfj = UploadFileEnmu.企业信用审查申请附件.getKey();
        String file_hcfj = UploadFileEnmu.企业信用审查审核附件.getKey();
        String file_shfj = UploadFileEnmu.企业信用审查审核上传附件.getKey();
        UploadFile uploadFile_sqfj = cCreditCheckService.findUploadFile(id, file_sqfj); // 申请附件
        UploadFile uploadFile_hcfj = cCreditCheckService.findUploadFile(id, file_hcfj); // 审核附件
        UploadFile uploadFile_shfj = cCreditCheckService.findUploadFile(id, file_shfj); // 审核上传附件
        String path_sqfj = "";
        String path_sqfjName = "";
        if (uploadFile_sqfj != null) {
            path_sqfj = uploadFile_sqfj.getFilePath();
            path_sqfjName = uploadFile_sqfj.getFileName();
        }
        String path_hcfj = "";
        if (uploadFile_hcfj != null) {
            path_hcfj = uploadFile_hcfj.getFilePath();
        }

        String scxxl = cCreditCheckService.getScxxl(creditExamine.getScxxl());

        ModelAndView view = new ModelAndView();
        view.addObject("id", id);
        view.addObject("deptName", deptName);
        view.addObject("userName", userName);
        view.addObject("status", status);
        view.addObject("path_sqfj", path_sqfj);
        view.addObject("path_sqfjName", path_sqfjName);
        view.addObject("path_hcfj", path_hcfj);
        view.addObject("path_hcfjName", creditExamine.getBjbh() + ".docx");
        view.addObject("creditExamine", creditExamine);
        view.addObject("scxxl", scxxl);
        view.addObject("scsjs", scsjs);
        view.addObject("scsjz", scsjz);
        view.addObject("creditExamineHis", creditExamineHis);
        view.addObject("uploadFile_shfj", uploadFile_shfj);
        view.setViewName("/center/creditCheck/cCreditCheckDetail");
        return view;
    }

    /**
     * @param request
     * @param response
     * @param id
     * @return
     * @throws Exception
     * @Title: getEnterList
     * @Description: 获取申请企业列表
     * @return: String
     */
    @ResponseBody
    @RequestMapping("/getEnterList")
    @RequiresPermissions("center.creditCheck.examine")
    public String getEnterList(HttpServletRequest request, HttpServletResponse response, String id) throws Exception {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<EnterpriseExamine> page = cCreditCheckService.getEnterList(dtParams.getPage(), id);
        return PageUtils.buildDTData(page, request);
    }

    @RequestMapping("/toExamine")
    @MethodDescription(desc = "进入信用审查审核页面（中心）")
    @RequiresPermissions("center.creditCheck.examine")
    @ResponseBody
    public ModelAndView toExamine(HttpServletRequest request, HttpServletResponse response, String id) throws Exception {
        CreditExamine creditExamine = baseService.findById(CreditExamine.class, id);
        String scsjs = "";
        String scsjz = "";
        if (creditExamine.getScsjs() != null) {
            scsjs = DateFormatUtils.format(creditExamine.getScsjs(), "yyyy-MM");
        }
        if (creditExamine.getScsjz() != null) {
            scsjz = DateFormatUtils.format(creditExamine.getScsjz(), "yyyy-MM");
        }
        String deptName = creditExamine.getScxqbm().getDepartmentName();
        String userName = creditExamine.getCreateUser().getUsername();
        String status = creditExamine.getStatus();

        // 获取申请附件信息
        String file_sqfj = UploadFileEnmu.企业信用审查申请附件.getKey();
        UploadFile uploadFile_sqfj = cCreditCheckService.findUploadFile(id, file_sqfj); // 申请附件
        String path_sqfj = "";
        String path_sqfjName = "";
        if (uploadFile_sqfj != null) {
            path_sqfj = uploadFile_sqfj.getFilePath();
            path_sqfjName = uploadFile_sqfj.getFileName();
        }
        String scxxl = cCreditCheckService.getScxxl(creditExamine.getScxxl());

        // 获取核查报告附件信息
        String hcbgKey = UploadFileEnmu.企业信用审查审核附件.getKey();
        UploadFile hcbg = cCreditCheckService.findUploadFile(id, hcbgKey); // 申请附件

        ModelAndView view = new ModelAndView();
        view.addObject("id", id);
        view.addObject("deptName", deptName);
        view.addObject("userName", userName);
        view.addObject("status", status);
        view.addObject("path_sqfj", path_sqfj);
        view.addObject("path_sqfjName", path_sqfjName);
        view.addObject("creditExamine", creditExamine);
        view.addObject("scxxl", scxxl);
        view.addObject("scsjs", scsjs);
        view.addObject("scsjz", scsjz);
        view.addObject("hcbg", hcbg);
        view.setViewName("/center/creditCheck/cCreditCheckExamine");
        return view;
    }

    /**
     * @param request
     * @param response
     * @param type
     * @return
     * @throws Exception
     * @Title: examine
     * @Description: 审核申请
     * @return: String
     */
    @RequestMapping("/examine")
    @MethodDescription(desc = "信用审查审核（中心）")
    @RequiresPermissions("center.creditCheck.examine")
    @ResponseBody
    public String examine(String id, String shyj, String type, String uploadFileName, String uploadFilePath) {
        String sysuserid = CommonUtil.getCurrentUserId();
        boolean res = cCreditCheckService.aduitExamine(id, type, shyj, sysuserid, uploadFileName, uploadFilePath, sysuserid);
        return ResponseUtils.buildResultJson(res);
    }

    /**
     * @param request
     * @param response
     * @throws Exception
     * @Title: createExamineReport
     * @Description: 生成审查报告
     * @return: String
     */
    @RequestMapping("/createExamineReport")
    @MethodDescription(desc = "生成审查报告（中心）")
    @RequiresPermissions("center.creditCheckUpload.report")
    @ResponseBody
    public String createExamineReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sysuserid = CommonUtil.getCurrentUserId();
        String id = request.getParameter("id");
        String scxxl = request.getParameter("scxxl"); // 需审核的内容
        String bjbh = request.getParameter("bjbh");
        String filePath = cCreditCheckService.createCreditReport(request, id); // 生成审查报告,获得报告存放路径
        try {
            cCreditCheckService.saveFilePath(id, "法人信用审查报告.doc", filePath, sysuserid);
            return ResponseUtils.buildResultJson(true, filePath);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false);
        }
    }

    /**
     * @param request
     * @param response
     * @return ModelAndView
     * @Title: toCreditCheckUpload
     * @Description: 进入信用审查上传页面
     */
    @RequestMapping("/creditCheckUpload")
    @MethodDescription(desc = "信用审查上传（中心）")
    @RequiresPermissions("center.creditCheck.upload")
    @ResponseBody
    public ModelAndView toCreditCheckUpload(HttpServletRequest request, HttpServletResponse response) {
        String sessionListId = super.session.getId() + "_enterpriseList";
        super.session.removeAttribute("sessionListId");

        List<EnterpriseExamine> enterpriseList = new ArrayList<EnterpriseExamine>();
        super.session.setAttribute(sessionListId, enterpriseList);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String bjbh = "SC" + sdf.format(new Date()) + new RandomString().getRandomString(5, "i");
        SysUser user = super.getSysUser();
        SysDepartment department = user.getSysDepartment();

        ModelAndView view = new ModelAndView("/center/creditCheck/cCreditCheckUpload");
        view.addObject("bjbh", bjbh); // 办件编号
        view.addObject("sysuserId", user.getId()); // 操作用户
        view.addObject("userName", user.getUsername()); // 操作用户ID
        view.addObject("departmentId", department.getId()); // 审查需求部门ID
        view.addObject("departmentName", department.getDepartmentName()); // 审查需求部门
        return view;
    }

    /**
     * @param request
     * @param response
     * @param writer
     * @return
     * @throws Exception
     * @Title: queryList
     * @Description: 查询已添加企业
     * @return: String
     */
    @RequestMapping("/queryList")
    @RequiresPermissions("center.creditCheck.upload")
    @ResponseBody
    public String queryList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sessionListId = super.session.getId() + "_enterpriseList";
        @SuppressWarnings("unchecked")
        List<EnterpriseExamine> enterpriseList = (List<EnterpriseExamine>) super.session.getAttribute(sessionListId);
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<EnterpriseExamine> page = cCreditCheckService.findEnterByPage(dtParams.getPage(), enterpriseList);
        return PageUtils.buildDTData(page, request);
    }

    /**
     * @param request
     * @param response
     * @throws Exception
     * @Title: clearList
     * @Description: 重置 清空上传企业
     * @return: void
     */
    @RequestMapping("/clearList")
    @RequiresPermissions("center.creditCheck.upload")
    @ResponseBody
    public void clearList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sessionListId = super.session.getId() + "_enterpriseList";
        @SuppressWarnings("unchecked")
        List<EnterpriseExamine> enterpriseList = (List<EnterpriseExamine>) super.session.getAttribute(sessionListId);
        enterpriseList.clear();
    }

    /**
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     * @Title: manualAdd
     * @Description: 手动录入
     * @return: void
     */
    @RequestMapping("/manualAdd")
    @RequiresPermissions("center.creditCheck.upload")
    @ResponseBody
    public void manualAdd(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        String sessionListId = super.session.getId() + "_enterpriseList";
        @SuppressWarnings("unchecked")
        List<EnterpriseExamine> enterpriseList = (List<EnterpriseExamine>) super.session.getAttribute(sessionListId);
        JSONObject msg = new JSONObject();
        String bjbh = request.getParameter("bjbh");
        String zzjgdm = request.getParameter("zzjgdm");
        String qymc = request.getParameter("qymc");
        String gszch = request.getParameter("gszch");
        String shxydm = request.getParameter("shxydm");

        qymc = IdentityUtil.processJgqc(qymc);
        zzjgdm = IdentityUtil.processZzjgdm(zzjgdm);
        Map<String, Object> checkResultMap = IdentityUtil.checkEnter(qymc, shxydm, zzjgdm, gszch, null);
        boolean checkResult = (Boolean) checkResultMap.get("result");
        if (checkResult) {
            if (enterpriseList.size() >= CreditCheckServiceImpl.UPLOAD_SIZE_MAX) {
                msg.put("result", false);
                msg.put("message", "录入企业信息总数量不得大于" + CreditCheckServiceImpl.UPLOAD_SIZE_MAX + "！");
            } else if (cCreditCheckService.addEnter(bjbh, zzjgdm, qymc, gszch, shxydm, enterpriseList, msg)) {
                msg.put("result", true);
                msg.put("message", "手动录入企业成功！");
            }
        } else {
            msg.put("result", false);
            msg.put("message", (String) checkResultMap.get("errorMsg"));
        }

        String json = ResponseUtils.buildResultJson(msg);
        writer.write(json);
    }

    /**
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     * @Title: batchAdd
     * @Description: 批量导入
     * @return: void
     */
    @RequestMapping("/batchAdd")
    @RequiresPermissions("center.creditCheck.upload")
    @ResponseBody
    public void batchAdd(HttpServletRequest request, HttpServletResponse response, Writer writer, String filePathStr,
                         String fileNameStr, String bjbh) throws Exception {
        String sessionListId = super.session.getId() + "_enterpriseList";
        @SuppressWarnings("unchecked")
        List<EnterpriseExamine> enterpriseList = (List<EnterpriseExamine>) super.session.getAttribute(sessionListId);
        filePathStr = StringUtils.substringBeforeLast(filePathStr, ",");
        fileNameStr = StringUtils.substringBeforeLast(fileNameStr, ",");
        String[] filePathArr = filePathStr.split(",");
        String[] fileNameArr = fileNameStr.split(",");
        JSONObject msg = new JSONObject();
        Workbook wb = null;
        int i = 0;
        StringBuffer message = new StringBuffer();
        message.append("解析结果:<br>");
        for (String filePath : filePathArr) {
            String fileName = fileNameArr[i];
            i++;
            if (ExcelUtils.isExcel2007(filePath)) {
                wb = new XSSFWorkbook(new FileInputStream(new File(filePath)));
            } else {
                wb = new HSSFWorkbook(new FileInputStream(new File(filePath)));
            }
            Sheet sheet = wb.getSheetAt(0); // 获得第一个sheet
            int rowNum = sheet.getPhysicalNumberOfRows(); // 获取总行数
            int enterSize = enterpriseList.size();

            if (rowNum < 2) {
                message.append("<b>&nbsp;&nbsp;「" + fileName + "」批量导入企业信息数量为0，无法导入。</b><br>");
            } else if (rowNum > CreditCheckServiceImpl.BATCH_UPLOAD_SIZE_MAX + 1) {
                message.append("<b>&nbsp;&nbsp;「" + fileName + "」批量导入企业信息数量大于" + CreditCheckServiceImpl.BATCH_UPLOAD_SIZE_MAX + "，无法导入。</b><br>");
            } else if (rowNum + enterSize > CreditCheckServiceImpl.UPLOAD_SIZE_MAX + 1) {
                message.append("<b>&nbsp;&nbsp;导入企业信息总数量大于" + CreditCheckServiceImpl.UPLOAD_SIZE_MAX + "，无法导入。</b><br>");
            } else {
                Row row = sheet.getRow(0); // 获得标题
                if (row == null) {
                    message.append("<b>&nbsp;&nbsp;「" + fileName + "」不是标准的Excel模板。</b><br>");
                } else {
                    String cell_qymc = ExcelUtils.getCell(row.getCell(0));
                    String cell_gszch = ExcelUtils.getCell(row.getCell(1));
                    String cell_zzjgdm = ExcelUtils.getCell(row.getCell(2));
                    String cell_shxydm = ExcelUtils.getCell(row.getCell(3));
                    if (!StringUtils.equals(cell_zzjgdm, Constants.TITLE_ZZJGDM)
                            || !StringUtils.equals(cell_qymc, Constants.TITLE_QYMC)
                            || !StringUtils.equals(cell_gszch, Constants.TITLE_GSZCH)
                            || !StringUtils.equals(cell_shxydm, Constants.TITLE_SHXYDM)) {
                        message.append("<b>&nbsp;&nbsp;「" + fileName + "」不是标准的Excel模板。</b><br>");
                    } else {
                        int cnt = cCreditCheckService.batchAdd(wb, bjbh, message, enterpriseList);
                        message.append("<b>&nbsp;&nbsp;「" + fileName + "」导入 " + cnt + " 家企业</b><br>");
                    }
                }
            }
        }
        msg.put("message", message.toString());
        String json = ResponseUtils.buildResultJson(msg);
        writer.write(json);
    }

    /**
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     * @Title: reomveEnters
     * @Description: 删除企业
     * @return: void
     */
    @RequestMapping("/reomveEnter")
    @RequiresPermissions("center.creditCheck.upload")
    public void reomveEnters(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        String sessionListId = super.session.getId() + "_enterpriseList";
        @SuppressWarnings("unchecked")
        List<EnterpriseExamine> enterpriseList = (List<EnterpriseExamine>) super.session.getAttribute(sessionListId);
        boolean res = false;
        String id = request.getParameter("id");
        try {
            cCreditCheckService.reomveEnters(enterpriseList, id);
            res = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            String json = ResponseUtils.buildResultJson(res);
            response.setContentType("text/html;charset=UTF-8");
            writer.write(json);
        }
    }

    /**
     * @param response
     * @param request
     * @throws IOException
     * @Title: templateDownload
     * @Description: 下载模板
     * @return: void
     */
    @RequestMapping("/templateDownload")
    @RequiresPermissions("center.creditCheck.upload")
    @MethodDescription(desc = "信用审查下载模板（中心）")
    public void templateDownload(HttpServletResponse response, HttpServletRequest request) throws Exception {
        String fileName = "法人信用审查名单.xlsx";
        // 读到流中
        InputStream inStream = new FileInputStream(request.getSession().getServletContext()
                .getRealPath("/template/法人信用审查名单.xlsx"));// 文件的存放路径
        // 设置输出的格式
        FileUtils.setDownFileName(response, request, fileName);
        // 循环取出流中的数据
        byte[] b = new byte[100];
        int len;
        try {
            while ((len = inStream.read(b)) > 0) {
                response.getOutputStream().write(b, 0, len);
            }
            inStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     * @Title: addApplication
     * @Description: 保存申请
     * @return: void
     */
    @RequestMapping("/addApplication")
    @MethodDescription(desc = "保存信用审查申请（中心）")
    @RequiresPermissions("center.creditCheck.upload")
    @ResponseBody
    public void addApplication(HttpServletRequest request, HttpServletResponse response, Writer writer,
                               String[] uploadImgName, String[] uploadImgPath) throws Exception {
        JSONObject msg = new JSONObject();
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
            String sessionListId = super.session.getId() + "_enterpriseList";
            @SuppressWarnings("unchecked")
            List<EnterpriseExamine> enterpriseList = (List<EnterpriseExamine>) super.session.getAttribute(sessionListId);
            String bjbh = request.getParameter("bjbh");
            String departentId = request.getParameter("departentId");
            String userId = super.getUserId();
            Date scsjs = sdf.parse(request.getParameter("scsjs"));
            Date scsjz = sdf.parse(request.getParameter("scsjz"));
            String[] scxxls = request.getParameterValues("scxxl");
            StringBuffer buf = new StringBuffer("");
            if (scxxls.length > 0) {
                buf.append(scxxls[0]);
            }
            for (int i = 1; i < scxxls.length; i++) {
                buf.append(',');
                buf.append(scxxls[i]);
            }

            String scmc = request.getParameter("scmc");
            if (enterpriseList != null && enterpriseList.size() > 0) {
                String applyId = cCreditCheckService.addApplication(request, bjbh, departentId, userId, buf.toString(), scmc,
                        scsjs, scsjz, enterpriseList, uploadImgName, uploadImgPath);

                msg.put("result", true);
                msg.put("applyId", applyId);

            } else {
                msg.put("result", false);
                msg.put("message", "请添加企业信息!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            msg.put("result", false);
            msg.put("message", "申请失败！");
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(msg.toJSONString());
    }

    /**
     * 信用中心法人信用审查上传后跳转红头文件上传页面
     *
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("/toSubmitCheckReport")
    @RequiresPermissions("center.creditCheck.examine")
    public String toSubmitCheckReport(Model model, String id) {
        CreditExamine creditExamine = baseService.findById(CreditExamine.class, id);

        // 获取生成的信用审查报告
        String hcfjKey = UploadFileEnmu.企业信用审查审核附件.getKey();
        UploadFile hcfj = cCreditCheckService.findUploadFile(id, hcfjKey);

        model.addAttribute("id", id);
        model.addAttribute("creditExamine", creditExamine);
        model.addAttribute("hcfj", hcfj);

        return "/center/creditCheck/submit_check_report";
    }

    /**
     * 信用中心法人信用审查上传后保存红头文件
     *
     * @param id
     * @param bz
     * @param uploadFileName
     * @param uploadFilePath
     * @return
     */
    @RequestMapping("/submitCheckReport")
    @RequiresPermissions("center.creditCheck.examine")
    @ResponseBody
    public String submitCheckReport(String id, String bz, String uploadFileName, String uploadFilePath) {
        try {
            cCreditCheckService.submitCheckReport(id, bz, uploadFileName, uploadFilePath, getUserId());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false);
        }
        return ResponseUtils.buildResultJson(true);
    }

}
