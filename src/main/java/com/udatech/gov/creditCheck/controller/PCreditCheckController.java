package com.udatech.gov.creditCheck.controller;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.controller.SuperController;
import com.udatech.common.creditCheck.service.PCreditCheckService;
import com.udatech.common.creditCheck.service.impl.PCreditCheckServiceImpl;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.PCreditExamine;
import com.udatech.common.model.PCreditExamineHis;
import com.udatech.common.model.PeopleExamine;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.FileUtils;
import com.wa.framework.Pageable;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
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

/**
 * @Description: 信用审查C
 * @author: 何斐
 * @date: 2016年11月21日 下午3:57:00
 */
@Controller
@RequestMapping("/gov/pCreditCheck")
public class PCreditCheckController extends SuperController {

    @Autowired
    private PCreditCheckService pCreditCheckService;

    @Autowired
    private BaseService baseService;

    public final static String TITLE_XM = "姓名";

    public final static String TITLE_SFZH = "身份证号";

    /**
     * @param request
     * @param response
     * @return
     * @throws Exception
     * @Title: toApply
     * @Description: 打开信用审查申请页面
     * @return: ModelAndView
     */
    @RequestMapping("/toApply")
    @MethodDescription(desc = "进入自然人信用审查申请（部门）")
    @RequiresPermissions("gov.pCreditCheck.apply")
    public ModelAndView toApply(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sessionListId = super.session.getId() + "_peopleList";
        super.session.removeAttribute("sessionListId");

        List<PeopleExamine> peopleList = new ArrayList<PeopleExamine>();
        super.session.setAttribute(sessionListId, peopleList);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String bjbh = "SC" + sdf.format(new Date()) + new RandomString().getRandomString(5, "i");
        SysUser user = this.getSysUser();
        SysDepartment department = user.getSysDepartment();

        ModelAndView view = new ModelAndView("/gov/pCreditCheck/pCreditCheckApply");
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
     * @Description: 查询已添加自然人
     * @return: String
     */
    @RequestMapping("/queryList")
    @RequiresPermissions("gov.pCreditCheck.apply")
    @ResponseBody
    public String queryList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sessionListId = super.session.getId() + "_peopleList";
        @SuppressWarnings("unchecked")
        List<PeopleExamine> peopleList = (List<PeopleExamine>) super.session.getAttribute(sessionListId);
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<PeopleExamine> page = pCreditCheckService.findPeopleByPage(dtParams.getPage(), peopleList);
        return PageUtils.buildDTData(page, request);
    }

    /**
     * @param request
     * @param response
     * @throws Exception
     * @Title: clearList
     * @Description: 重置 清空上传自然人
     * @return: void
     */
    @RequestMapping("/clearList")
    @RequiresPermissions("gov.pCreditCheck.apply")
    @ResponseBody
    public void clearList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sessionListId = super.session.getId() + "_peopleList";
        @SuppressWarnings("unchecked")
        List<PeopleExamine> peopleList = (List<PeopleExamine>) super.session.getAttribute(sessionListId);
        peopleList.clear();
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
    @RequiresPermissions("gov.pCreditCheck.apply")
    @ResponseBody
    public void manualAdd(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        String sessionListId = super.session.getId() + "_peopleList";
        @SuppressWarnings("unchecked")
        List<PeopleExamine> peopleList = (List<PeopleExamine>) super.session.getAttribute(sessionListId);
        JSONObject msg = new JSONObject();
        String bjbh = request.getParameter("bjbh");
        String xm = request.getParameter("xm");
        String sfzh = request.getParameter("sfzh");
        if (peopleList.size() >= PCreditCheckServiceImpl.UPLOAD_SIZE_MAX) {
            msg.put("result", false);
            msg.put("message", "录入自然人信息总数量不得大于" + PCreditCheckServiceImpl.UPLOAD_SIZE_MAX + "！");
        } else if (pCreditCheckService.addPeople(bjbh, xm, sfzh, peopleList, msg)) {
            msg.put("result", true);
            msg.put("message", "手动录入自然人成功！");
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
    @RequiresPermissions("gov.pCreditCheck.apply")
    @ResponseBody
    public void batchAdd(HttpServletRequest request, HttpServletResponse response, Writer writer, String filePathStr,
                         String fileNameStr, String bjbh) throws Exception {
        String sessionListId = super.session.getId() + "_peopleList";
        @SuppressWarnings("unchecked")
        List<PeopleExamine> peopleList = (List<PeopleExamine>) super.session.getAttribute(sessionListId);
        filePathStr = StringUtils.substringBeforeLast(filePathStr, ",");
        fileNameStr = StringUtils.substringBeforeLast(fileNameStr, ",");
        String[] filePathArr = filePathStr.split(",");
        String[] fileNameArr = fileNameStr.split(",");
        JSONObject msg = new JSONObject();
        Workbook wb;
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
            int enterSize = peopleList.size();
            if (rowNum < 2) {
                message.append("<b>&nbsp;&nbsp;「" + fileName + "」批量导入自然人信息数量为0，无法导入。</b><br>");
            } else if (rowNum > PCreditCheckServiceImpl.BATCH_UPLOAD_SIZE_MAX + 1) {
                message.append("<b>&nbsp;&nbsp;「" + fileName + "」批量导入自然人信息数量大于" + PCreditCheckServiceImpl.BATCH_UPLOAD_SIZE_MAX
                        + "，无法导入。</b><br>");
            } else if (rowNum + enterSize > PCreditCheckServiceImpl.UPLOAD_SIZE_MAX + 1) {
                message.append("<b>&nbsp;&nbsp;导入自然人信息总数量大于" + PCreditCheckServiceImpl.UPLOAD_SIZE_MAX + "，无法导入。</b><br>");
            } else {
                Row row = sheet.getRow(0); // 获得标题
                if (row == null) {
                    message.append("<b>&nbsp;&nbsp;「" + fileName + "」不是标准的Excel模板。</b><br>");
                } else {
                    String cell_xm = ExcelUtils.getCell(row.getCell(0));
                    String cell_sfzh = ExcelUtils.getCell(row.getCell(1));
                    if (!StringUtils.equals(cell_xm, TITLE_XM)
                            || !StringUtils.equals(cell_sfzh, TITLE_SFZH)) {
                        message.append("<b>&nbsp;&nbsp;「" + fileName + "」不是标准的Excel模板。</b><br>");
                    } else {
                        int cnt = pCreditCheckService.batchAdd(wb, bjbh, message, peopleList);
                        message.append("<b>&nbsp;&nbsp;「" + fileName + "」导入 " + cnt + " 个自然人</b><br>");
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
     * @Description: 删除自然人
     * @return: void
     */
    @RequestMapping("/reomveEnter")
    @RequiresPermissions("gov.pCreditCheck.apply")
    public void reomveEnters(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        String sessionListId = super.session.getId() + "_peopleList";
        @SuppressWarnings("unchecked")
        List<PeopleExamine> peopleList = (List<PeopleExamine>) super.session.getAttribute(sessionListId);
        boolean res = false;
        String id = request.getParameter("id");
        try {
            pCreditCheckService.removePeoples(peopleList, id);
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
    @RequiresPermissions("gov.pCreditCheck.apply")
    public void templateDownload(HttpServletResponse response, HttpServletRequest request) throws Exception {
        String fileName = "自然人信用审查名单.xlsx";
        // 读到流中
        InputStream inStream = new FileInputStream(request.getSession().getServletContext()
                .getRealPath("/template/自然人信用审查名单.xlsx"));// 文件的存放路径
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
    @MethodDescription(desc = "信用审查提交申请（部门）")
    @RequiresPermissions("gov.pCreditCheck.apply")
    @ResponseBody
    public void addApplication(HttpServletRequest request, HttpServletResponse response, String[] uploadImgName,
                               String[] uploadImgPath, Writer writer) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String sessionListId = super.session.getId() + "_peopleList";
        @SuppressWarnings("unchecked")
        List<PeopleExamine> peopleList = (List<PeopleExamine>) super.session.getAttribute(sessionListId);
        JSONObject msg = new JSONObject();
        String bjbh = request.getParameter("bjbh");
        String departentId = request.getParameter("departentId");
        String userId = request.getParameter("userId");
        String[] scxxls = request.getParameterValues("scxxl");
        Date scsjs = sdf.parse(request.getParameter("scsjs"));
        Date scsjz = sdf.parse(request.getParameter("scsjz"));
        StringBuffer buf = new StringBuffer("");
        if (scxxls.length > 0) {
            buf.append(scxxls[0]);
        }
        for (int i = 1; i < scxxls.length; i++) {
            buf.append(',');
            buf.append(scxxls[i]);
        }

        String scmc = request.getParameter("scmc");
        String scsm = request.getParameter("scsm");
        if (peopleList != null && peopleList.size() > 0) {
            try {
                PCreditExamine ce = pCreditCheckService.addApplication(bjbh, departentId, userId, buf.toString(), scmc, scsm, scsjs, scsjz,
                        uploadImgName, uploadImgPath, peopleList);
                msg.put("result", true);
                msg.put("message", "申请成功！");
                String filePath = pCreditCheckService.createCreditReport(request, ce.getId()); // 生成审查报告,获得报告存放路径
                pCreditCheckService.saveFilePath(ce.getId(), "自然人信用审查报告.doc", filePath, getUserId());
            } catch (Exception e) {
                e.printStackTrace();
                msg.put("result", false);
                msg.put("message", "申请失败！");
            }

        } else {
            msg.put("result", false);
            msg.put("message", "请添加自然人信息!");
        }
        response.setContentType("text/html;charset=UTF-8");
        writer.write(msg.toJSONString());
    }

    /**
     * @param response
     * @param request
     * @return
     * @Title: toHisQuery
     * @Description: 进入历史查询页面
     * @return: ModelAndView
     */
    @RequestMapping("/toHisQuery")
    @MethodDescription(desc = "查询信用审查列表（部门）")
    @RequiresPermissions("gov.pCreditCheck.HisQuery")
    @ResponseBody
    public ModelAndView toHisQuery(HttpServletResponse response, HttpServletRequest request) {
        ModelAndView view = new ModelAndView();
        view.setViewName("/gov/pCreditCheck/pCreditCheckHisQuery");
        return view;
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
    @RequestMapping("/queryApplyList")
    @RequiresPermissions("gov.pCreditCheck.HisQuery")
    @ResponseBody
    public String queryApplyList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        String sysuserid = CommonUtil.getCurrentUserId();
        String scmc = request.getParameter("scmc");
        String xqbm = request.getParameter("xqbm");
        String bjbh = request.getParameter("bjbh");
        String sqsjs = request.getParameter("sqsjs");
        String sqsjz = request.getParameter("sqsjz");
        String status = request.getParameter("status");
        Pageable<PCreditExamine> page = pCreditCheckService.queryApplyList(dtParams.getPage(), scmc, xqbm, bjbh, sqsjs,
                sqsjz, sysuserid, status);
        return PageUtils.buildDTData(page, request);
    }

    /**
     * @param request
     * @param response
     * @param come     判断画面来源
     * @return
     * @throws Exception
     * @Title: toView
     * @Description: 查看详细
     * @return: ModelAndView
     */
    @RequestMapping("/toView")
    @MethodDescription(desc = "查看信用审查详细（部门）")
    @RequiresPermissions("gov.pCreditCheck.HisQuery")
    @ResponseBody
    public ModelAndView toView(HttpServletRequest request, HttpServletResponse response, String id) throws Exception {
        PCreditExamine pCreditExamine = baseService.findById(PCreditExamine.class, id);
        String scsjs = DateFormatUtils.format(pCreditExamine.getScsjs(), DateUtils.YYYYMMDD_10);
        String scsjz = DateFormatUtils.format(pCreditExamine.getScsjz(), DateUtils.YYYYMMDD_10);
        String deptName = pCreditExamine.getScxqbm().getDepartmentName();
        String userName = pCreditExamine.getCreateUser().getUsername();
        String status = pCreditExamine.getStatus();
        PCreditExamineHis pCreditExamineHis = pCreditCheckService.findCreditExamineHisByCreditExamineId(id);

        String scxxl = pCreditCheckService.getScxxl(pCreditExamine.getScxxl());

        // 获取附件信息
        String file_sqfj = UploadFileEnmu.企业信用审查申请附件.getKey();
        String file_hcfj = UploadFileEnmu.企业信用审查审核附件.getKey();
        String file_shfj = UploadFileEnmu.企业信用审查审核上传附件.getKey();
        UploadFile uploadFile_sqfj = pCreditCheckService.findUploadFile(id, file_sqfj); // 申请附件
        UploadFile uploadFile_hcfj = pCreditCheckService.findUploadFile(id, file_hcfj); // 审核附件
        UploadFile uploadFile_shfj = pCreditCheckService.findUploadFile(id, file_shfj);
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

        ModelAndView view = new ModelAndView();
        view.addObject("id", id);
        view.addObject("deptName", deptName);
        view.addObject("userName", userName);
        view.addObject("status", status);
        view.addObject("path_sqfj", path_sqfj);
        view.addObject("path_sqfjName", path_sqfjName);
        view.addObject("path_hcfj", path_hcfj);
        view.addObject("path_hcfjName", pCreditExamine.getBjbh() + ".docx");
        view.addObject("creditExamine", pCreditExamine);
        view.addObject("creditExamineHis", pCreditExamineHis);
        view.addObject("scxxl", scxxl);
        view.addObject("scsjs", scsjs);
        view.addObject("scsjz", scsjz);
        view.addObject("uploadFile_shfj", uploadFile_shfj);
        view.setViewName("/gov/pCreditCheck/pCreditCheckDetail");
        return view;
    }

    /**
     * @param request
     * @param response
     * @param id
     * @return
     * @throws Exception
     * @Title: getEnterList
     * @Description: 获取申请自然人列表
     * @return: String
     */
    @RequestMapping("/getEnterList")
    @RequiresPermissions("gov.pCreditCheck.HisQuery")
    @ResponseBody
    public String getEnterList(HttpServletRequest request, HttpServletResponse response, String id) throws Exception {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<PeopleExamine> page = pCreditCheckService.getPeopleList(dtParams.getPage(), id);
        return PageUtils.buildDTData(page, request);
    }
}
