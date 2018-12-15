package com.udatech.sszj.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.udatech.common.constant.Constants;
import com.udatech.common.controller.SuperController;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.util.ExcelUtils;
import com.udatech.sszj.constant.SszjConstants;
import com.udatech.sszj.constant.SszjZyryConstants;
import com.udatech.sszj.constant.SszjZyzzConstants;
import com.udatech.sszj.model.*;
import com.udatech.sszj.service.SszjService;
import com.wa.framework.Pageable;
import com.wa.framework.QueryCondition;
import com.wa.framework.QueryConditions;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.log.SysLogUtil;
import com.wa.framework.security.user.LoginedUser;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.Writer;
import java.util.*;

import static org.springframework.orm.hibernate3.SessionFactoryUtils.getSession;

/**
 * @author dwc
 * @Title: SszjController
 * @ProjectName creditservice
 * @Description: 涉审中介
 * @date 2018/12/10  18:12
 */
@Controller
@RequestMapping("/sszj")
public class SszjController extends SuperController {

    private Logger logger = Logger.getLogger(SszjController.class);

    @Autowired
    private SszjService sszjService;

    @Autowired
    private BaseService baseService;

    /**
     * 跳转中介信息档案页面
     * @param model
     * @return
     */
    @RequestMapping("/zjxxda")
    @MethodDescription(desc = "跳转中介信息档案页面")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    public String toZjxxDaPage(Model model) {
//        List<Rule> ruleList = schemaService.getAllRuleList();
//        model.addAttribute(ruleList);
        return "sszj/zjxxda";
    }

    /**
     * 跳转中介信息档案新增页面
     * @param model
     * @return
     */
    @RequestMapping("/zjxxdaAdd")
    @MethodDescription(desc = "跳转中介信息档案新增页面")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    public String toZjxxDaAddPage(Model model,String type,String id) {
        SszjJbxx sszjJbxx=new SszjJbxx();
        LoginedUser sysUser=CommonUtil.getCurrentUser();
        String czlcFj="";
        String fwxmFj="";
        //type 1--修改
        if(StringUtils.equals(type,"1")){
            sszjJbxx=baseService.findById(SszjJbxx.class,id);
            QueryConditions queryConditionsCzlc = new QueryConditions();
            queryConditionsCzlc.add(QueryCondition.eq("fileType","czlc"));
            queryConditionsCzlc.add(QueryCondition.eq("businessId",sszjJbxx.getId()));
            List<UploadFile> uploadFileCzlc=baseService.find(UploadFile.class, queryConditionsCzlc);
            if(!uploadFileCzlc.isEmpty()){
                czlcFj=uploadFileCzlc.get(0).getBusinessId();
            }
            QueryConditions queryConditionsFwxm = new QueryConditions();
            queryConditionsFwxm.add(QueryCondition.eq("fileType","fwxm"));
            queryConditionsFwxm.add(QueryCondition.eq("businessId",sszjJbxx.getId()));
            List<UploadFile> uploadFileFwxm=baseService.find(UploadFile.class, queryConditionsFwxm);
            if(!uploadFileFwxm.isEmpty()){
                fwxmFj=uploadFileFwxm.get(0).getBusinessId();
            }
            SysDepartment sysDepartment=baseService.findById(SysDepartment.class,sszjJbxx.getDeptId());
            sysUser.getSysDepartment().setDepartmentName(sysDepartment.getId());
            sysUser.getSysDepartment().setDepartmentName(sysDepartment.getDepartmentName());
        }
        sszjJbxx.setType(type);

        model.addAttribute("sysUser",sysUser);
        model.addAttribute("sszjJbxx",sszjJbxx);
        model.addAttribute("czlcFj",czlcFj);
        model.addAttribute("fwxmFj",fwxmFj);
        return "sszj/zjxxdaAdd";
    }

    /**
     * 中介基础信息保存
     * @param sszjJbxx
     * @return
     */
    @RequestMapping("/zjxxdaAddData")
    @MethodDescription(desc = "中介基础信息保存")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String zjxxdaAddData(SszjJbxx sszjJbxx) {
        try {
            if(StringUtils.equals(sszjJbxx.getType(),"0")){
                //新增涉审中介基本信息
                String id=UUID.randomUUID().toString();
                sszjJbxx.setId(id);
                sszjJbxx.setCreateId(CommonUtil.getCurrentUserId());
                sszjJbxx.setCreateTime(new Date());
                sszjService.saveSjzjJbxx(sszjJbxx);
                return ResponseUtils.buildResultJson(true,id);
            }else{
                //修改涉审中介基本信息
                sszjService.updateSjzjJbxx(sszjJbxx);
                sszjJbxx.setUpdateTime(new Date());
                sszjJbxx.setUpdateId(CommonUtil.getCurrentUserId());
                return ResponseUtils.buildResultJson(true,sszjJbxx.getId());
            }

        }catch (Exception e){
            e.printStackTrace();
            logger.error(e);
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
    }

    @RequestMapping("/getSszjJbxxList")
    @MethodDescription(desc = "获取涉审中介列表数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getSszjJbxxList(HttpServletRequest request,SszjJbxx sszjJbxx) {

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<Map<String, Object>> pageable = sszjService.getSszjJbxxList(dtParams.getPage(),
                sszjJbxx);
        return PageUtils.buildDTData(pageable, request);
    }

    @RequestMapping("/templateDownload")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    public void templateDownload(HttpServletResponse response,
                                 HttpServletRequest request) throws Exception {

        SysLogUtil.addLog("下载中介基本信息模板", request);

        sszjService.templateDownload(response, request);
    }

    @RequestMapping("/templateDownloadZyzz")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    public void templateDownloadZyzz(HttpServletResponse response,
                                 HttpServletRequest request) throws Exception {

        SysLogUtil.addLog("下载执业资质模板", request);

        sszjService.templateDownloadZyzz(response, request);
    }

    @RequestMapping("/templateDownloadZyry")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    public void templateDownloadZyry(HttpServletResponse response,
                                 HttpServletRequest request) throws Exception {

        SysLogUtil.addLog("下载执业人员模板", request);

        sszjService.templateDownloadZyry(response, request);
    }
    /**
     * 跳转中介信息档案详情页面
     * @param model
     * @return
     */
    @RequestMapping("/zjxxdaDetail")
    @MethodDescription(desc = "跳转中介信息档案详情页面")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    public String toZjxxDaDetailPage(Model model,String id) {
        SszjJbxx sszjJbxx=baseService.findById(SszjJbxx.class,id);
        String czlcFj="";
        String fwxmFj="";
        sszjJbxx=baseService.findById(SszjJbxx.class,id);
        QueryConditions queryConditionsCzlc = new QueryConditions();
        queryConditionsCzlc.add(QueryCondition.eq("fileType","czlc"));
        queryConditionsCzlc.add(QueryCondition.eq("businessId",sszjJbxx.getId()));
        List<UploadFile> uploadFileCzlc=baseService.find(UploadFile.class, queryConditionsCzlc);
        if(!uploadFileCzlc.isEmpty()){
            czlcFj=uploadFileCzlc.get(0).getUploadFileId();
        }
        QueryConditions queryConditionsFwxm = new QueryConditions();
        queryConditionsFwxm.add(QueryCondition.eq("fileType","fwxm"));
        queryConditionsFwxm.add(QueryCondition.eq("businessId",sszjJbxx.getId()));
        List<UploadFile> uploadFileFwxm=baseService.find(UploadFile.class, queryConditionsFwxm);
        if(!uploadFileFwxm.isEmpty()){
            fwxmFj=uploadFileFwxm.get(0).getUploadFileId();
        }

        model.addAttribute("czlcFj",czlcFj);
        model.addAttribute("fwxmFj",fwxmFj);
        model.addAttribute("sszjJbxx",sszjJbxx);
        return "sszj/zjxxdaDetail";
    }

    /**
     * 批量导入上传涉审中介信息
     * @param request
     * @param response
     * @param writer
     * @param filePathStr
     * @param fileNameStr
     * @throws Exception
     */
    @RequestMapping("/batchAdd")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public void batchAdd(HttpServletRequest request,
                         HttpServletResponse response, Writer writer, String filePathStr,
                         String fileNameStr) throws Exception {

        SysLogUtil.addLog("批量导入上传涉审中介信息", request);

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
            if (rowNum < 2) {
                message.append("<b>&nbsp;&nbsp;「" + fileName
                        + "」批量导入上传涉审中介信息目录数量为0，无法导入...</b><br>");
            } else {
                Row row = sheet.getRow(0); // 获得标题
                if (row == null) {
                    message.append("<b>&nbsp;&nbsp;「" + fileName
                            + "」不是标准的Excel模板...</b><br>");
                } else {
                    String jgqc     = ExcelUtils.getCell(row.getCell(0));//机构名称
                    String tyshxydm = ExcelUtils.getCell(row.getCell(1));//统一社会信用代码
                    String zzjgdm   = ExcelUtils.getCell(row.getCell(2));//组织机构代码
                    String sw_jgdm  = ExcelUtils.getCell(row.getCell(3));//税务机构代码
                    String frdb_fzr = ExcelUtils.getCell(row.getCell(4));//法人代表（负责人）
                    String jydz     = ExcelUtils.getCell(row.getCell(5));//经营地址
                    String wz       = ExcelUtils.getCell(row.getCell(6));//网址
                    String lxdh     = ExcelUtils.getCell(row.getCell(7));//联系电话
                    String dept_id  = ExcelUtils.getCell(row.getCell(8));//部门选择
                    String fwsx     = ExcelUtils.getCell(row.getCell(9));//服务时限
                    String sfyj     = ExcelUtils.getCell(row.getCell(10));//收费依据
                    String sfbz     = ExcelUtils.getCell(row.getCell(11));//收费标准
                    String fwxm     = ExcelUtils.getCell(row.getCell(12));//服务项目
                    String czlc     = ExcelUtils.getCell(row.getCell(13));//操作流程
                    String dysp     = ExcelUtils.getCell(row.getCell(14));//对应审批

                    if (   !StringUtils.equals(jgqc, SszjConstants.JGQC)
                        || !StringUtils.equals(tyshxydm, SszjConstants.TYSHXYDM)
                        || !StringUtils.equals(zzjgdm, SszjConstants.ZZJGDM)
                        || !StringUtils.equals(sw_jgdm, SszjConstants.SW_JGDM)
                        || !StringUtils.equals(frdb_fzr, SszjConstants.FRDB_FZR)
                        || !StringUtils.equals(jydz, SszjConstants.JYDZ)
                        || !StringUtils.equals(wz, SszjConstants.WZ)
                        || !StringUtils.equals(lxdh, SszjConstants.LXDH)
                        || !StringUtils.equals(dept_id, SszjConstants.DEPT_ID)
                        || !StringUtils.equals(fwsx, SszjConstants.FWSX)
                        || !StringUtils.equals(sfyj, SszjConstants.SFYJ)
                        || !StringUtils.equals(sfbz, SszjConstants.SFBZ)
                        || !StringUtils.equals(fwxm, SszjConstants.FWXM)
                        || !StringUtils.equals(czlc, SszjConstants.CZLC)
                        || !StringUtils.equals(dysp, SszjConstants.DYSP)
                    ) {
                        message.append("<b>&nbsp;&nbsp;「" + fileName
                                + "」不是标准的Excel模板...</b><br>");
                    } else {
                        int cnt = sszjService.batchAdd(wb,
                                message);
                        message.append("<b>&nbsp;&nbsp;「" + fileName + "」导入 "
                                + cnt + " 条记录</b><br>");
                    }
                }
            }
        }
        msg.put("message", message.toString());
        String json = ResponseUtils.buildResultJson(msg);
        writer.write(json);
    }

    /**
     * 删除选中的涉审中介信息
     * @param checkedList
     * @return
     */
    @RequestMapping("/deleteSszj")
    @MethodDescription(desc = "删除选中的涉审中介信息")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String deleteSszj(String checkedList){
        try{
            if (StringUtils.isNotBlank(checkedList)) {
                checkedList = HtmlUtils.htmlUnescape(checkedList);
//                checkedList.replaceAll("","\"");
//                Gson gson = new Gson();
//                Type type = new TypeToken<List<String>>() {}.getType();
//                List<String> addListTemp = gson.fromJson(checkedList, type);

                List<SszjJbxx> list = JSON.parseArray(checkedList, SszjJbxx.class);
                List<String> ids=new ArrayList<String>();
                if(!list.isEmpty()){
                    for(SszjJbxx sszjJbxx:list){
                        ids.add(sszjJbxx.getId());
                    }
                }
                if(!ids.isEmpty()){
                    baseService.deleteByIds(SszjJbxx.class,ids);
                }
            }
            return ResponseUtils.buildResultJson(true,"删除成功！");
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"删除失败！");
        }
    }

    /**
     * 执业资质信息保存
     * @param sszjZyzz
     * @return
     */
    @RequestMapping("/zyzzAddData")
    @MethodDescription(desc = "执业资质信息保存")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String zyzzAddData(SszjZyzz sszjZyzz) {
        try {
            sszjZyzz.setCreateId(CommonUtil.getCurrentUserId());
            sszjZyzz.setCreateTime(new Date());
            sszjZyzz.setState("1");
            sszjService.zyzzAddData(sszjZyzz);
            return ResponseUtils.buildResultJson(true,"保存成功");
        }catch (Exception e){
            e.printStackTrace();
            logger.error(e);
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
    }

    /**
     * 执业人员信息保存
     * @param sszjZyry
     * @return
     */
    @RequestMapping("/zyryAddData")
    @MethodDescription(desc = "执业人员信息保存")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String zyryAddData(SszjZyry sszjZyry) {
        try {
            sszjZyry.setCreateId(CommonUtil.getCurrentUserId());
            sszjZyry.setCreateTime(new Date());
            sszjService.zyryAddData(sszjZyry);
            return ResponseUtils.buildResultJson(true,"保存成功");
        }catch (Exception e){
            e.printStackTrace();
            logger.error(e);
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
    }

    /**
     * 评价等级信息保存
     * @param sszjPjdj
     * @return
     */
    @RequestMapping("/pjdjAddData")
    @MethodDescription(desc = "评价等级信息保存")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String pjdjAddData(SszjPjdj sszjPjdj) {
        try {
            LoginedUser loginedUser=CommonUtil.getCurrentUser();
            sszjPjdj.setCreateId(loginedUser.getUserId());
            sszjPjdj.setCreateTime(new Date());
            sszjService.pjdjAddData(sszjPjdj);
            return ResponseUtils.buildResultJson(true,"保存成功");
        }catch (Exception e){
            e.printStackTrace();
            logger.error(e);
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
    }

    /**
     * 信用承诺信息保存
     * @param sszjCreditCommitmentQy
     * @return
     */
    @RequestMapping("/xycnAddData")
    @MethodDescription(desc = "信用承诺信息保存")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String xycnAddData(SszjCreditCommitmentQy sszjCreditCommitmentQy,String uploadImgCnlbName, String uploadImgCnlbPath) {
        try {
            LoginedUser loginedUser=CommonUtil.getCurrentUser();
            sszjCreditCommitmentQy.setCreate_user(loginedUser.getUserId());
            sszjCreditCommitmentQy.setCreate_time(new Date());
            sszjCreditCommitmentQy.setDept_id(loginedUser.getSysDepartment().getId());

            UploadFile uploadFile=new UploadFile();
            uploadFile.setCreateUser(new SysUser(this.getUserId()));
            uploadFile.setCreateDate(new Date());
            uploadFile.setFileType(UploadFileEnmu.信用承诺附件.getKey());
            uploadFile.setFilePath(uploadImgCnlbPath);
            uploadFile.setFileName(uploadImgCnlbName);
            sszjService.xycnAddData(sszjCreditCommitmentQy,uploadFile);
            return ResponseUtils.buildResultJson(true,"保存成功");
        }catch (Exception e){
            e.printStackTrace();
            logger.error(e);
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
    }

    /**
     * 获取执业资质列表数据--用于新增机构或者修改时展示数据
     * @param request
     * @param sszjZyzz
     * @return
     */
    @RequestMapping("/getSszjZyzzList")
    @MethodDescription(desc = "获取执业资质列表数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getSszjZyzzList(HttpServletRequest request,SszjZyzz sszjZyzz) {

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<Map<String, Object>> pageable = sszjService.getSszjZyzzList(dtParams.getPage(),
                sszjZyzz);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 获取执业人员列表数据--用于新增机构或者修改时展示数据
     * @param request
     * @param sszjZyry
     * @return
     */
    @RequestMapping("/getSszjZyryList")
    @MethodDescription(desc = "获取执业人员列表数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getSszjZyryList(HttpServletRequest request,SszjZyry sszjZyry) {

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<Map<String, Object>> pageable = sszjService.getSszjZyryList(dtParams.getPage(),
                sszjZyry);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 获取评价等级列表数据--用于新增机构或者修改时展示数据
     * @param request
     * @param sszjPjdj
     * @return
     */
    @RequestMapping("/getSszjPjdjList")
    @MethodDescription(desc = "获取评价等级列表数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getSszjPjdjList(HttpServletRequest request,SszjPjdj sszjPjdj) {

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<Map<String, Object>> pageable = sszjService.getSszjPjdjList(dtParams.getPage(),
                sszjPjdj);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 获取信用承诺列表数据--用于新增机构或者修改时展示数据
     * @param request
     * @param sszjCreditCommitmentQy
     * @return
     */
    @RequestMapping("/getSszjXycnList")
    @MethodDescription(desc = "获取信用承诺列表数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getSszjXycnList(HttpServletRequest request,SszjCreditCommitmentQy sszjCreditCommitmentQy) {

        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<Map<String, Object>> pageable = sszjService.getSszjXycnList(dtParams.getPage(),
                sszjCreditCommitmentQy);
        return PageUtils.buildDTData(pageable, request);
    }

    /**
     * 删除执业资质对应数据
     * @param id
     * @return
     */
    @RequestMapping("/deleteZyzz")
    @MethodDescription(desc = "删除执业资质对应数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String deleteZyzz(String id){
        try{
            if (StringUtils.isNotBlank(id)) {
                baseService.deleteById(SszjZyzz.class,id);
            }
            return ResponseUtils.buildResultJson(true,"删除成功！");
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"删除失败！");
        }
    }

    /**
     * 修改执业资质对应数据
     * @param sszjZyzz
     * @return
     */
    @RequestMapping("/updateZyzz")
    @MethodDescription(desc = "修改执业资质对应数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String updateZyzz(SszjZyzz sszjZyzz){
        try{
//            SszjZyzz serviceById=new SszjZyzz();
//            if(sszjZyzz!=null && StringUtils.isNotBlank(sszjZyzz.getId())){
//                serviceById=baseService.findById(SszjZyzz.class,sszjZyzz.getId());
//            }
//            Date date1=serviceById.getCreateTime();
//            String createId=serviceById.getCreateId();
//            sszjZyzz.setCreateTime(date1);
//            sszjZyzz.setCreateId(createId);
            sszjZyzz.setUpdateTime(new Date());
            sszjZyzz.setUpdateId(CommonUtil.getCurrentUserId());
            baseService.update(sszjZyzz);
            return ResponseUtils.buildResultJson(true,"修改成功！");
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"修改失败！");
        }
    }

    /**
     * 删除执业人员对应数据
     * @param id
     * @return
     */
    @RequestMapping("/deleteZyry")
    @MethodDescription(desc = "删除执业人员对应数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String deleteZyry(String id){
        try{
            if (StringUtils.isNotBlank(id)) {
                baseService.deleteById(SszjZyry.class,id);
            }
            return ResponseUtils.buildResultJson(true,"删除成功！");
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"删除失败！");
        }
    }

    /**
     * 修改执业人员对应数据
     * @param sszjZyry
     * @return
     */
    @RequestMapping("/updateZyry")
    @MethodDescription(desc = "修改执业人员对应数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String updateZyry(SszjZyry sszjZyry){
        try{
            baseService.update(sszjZyry);
            return ResponseUtils.buildResultJson(true,"修改成功！");
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"修改失败！");
        }
    }

    /**
     * 删除评价等级对应数据
     * @param id
     * @return
     */
    @RequestMapping("/deletePjdj")
    @MethodDescription(desc = "删除评价等级对应数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String deletePjdj(String id){
        try{
            if (StringUtils.isNotBlank(id)) {
                baseService.deleteById(SszjPjdj.class,id);
            }
            return ResponseUtils.buildResultJson(true,"删除成功！");
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"删除失败！");
        }
    }

    /**
     * 修改评价等级对应数据
     * @param sszjPjdj
     * @return
     */
    @RequestMapping("/updatePjdj")
    @MethodDescription(desc = "修改评价等级对应数据")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String updatePjdj(SszjPjdj sszjPjdj){
        try{
            baseService.update(sszjPjdj);
            return ResponseUtils.buildResultJson(true,"修改成功！");
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"修改失败！");
        }
    }

    /**
     * 根据id获取对应的执业资质数据-用于执业资质的修改
     * @param id
     * @return
     */
    @RequestMapping("/getOneZyzzById")
    @MethodDescription(desc = "根据id获取对应执业资质")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getOneZyzzById(String id){
        try{
            SszjZyzz sszjZyzz=baseService.findById(SszjZyzz.class,id);
            return ResponseUtils.toJSONString(sszjZyzz);
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"修改失败！");
        }
    }

    /**
     * 根据id获取对应的执业人员数据-用于执业人员的修改
     * @param id
     * @return
     */
    @RequestMapping("/getOneZyryById")
    @MethodDescription(desc = "根据id获取对应执业人员")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getOneZyryById(String id){
        try{
            SszjZyry sszjZyry=baseService.findById(SszjZyry.class,id);
            return ResponseUtils.toJSONString(sszjZyry);
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"修改失败！");
        }
    }

    /**
     * 根据id获取对应的评价等级数据-用于评价等级的修改
     * @param id
     * @return
     */
    @RequestMapping("/getOnePjdjById")
    @MethodDescription(desc = "根据id获取对应评价等级")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getOnePjdjById(String id){
        try{
            SszjPjdj sszjPjdj=baseService.findById(SszjPjdj.class,id);
            return ResponseUtils.toJSONString(sszjPjdj);
        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"修改失败！");
        }
    }

    /**
     * 涉审中介-执业资质批量上传
     * @param request
     * @param response
     * @param writer
     * @param filePathStr
     * @param fileNameStr
     * @param tyshxydm
     * @throws Exception
     */
    @RequestMapping("/batchAddZyzz")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public void batchAddZyzz(HttpServletRequest request,
                         HttpServletResponse response, Writer writer, String filePathStr,
                         String fileNameStr,String tyshxydm) throws Exception {

        SysLogUtil.addLog("批量导入执业资质信息", request);

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
            if (rowNum < 2) {
                message.append("<b>&nbsp;&nbsp;「" + fileName
                        + "」批量导入执业资质信息目录数量为0，无法导入...</b><br>");
            } else {
                Row row = sheet.getRow(0); // 获得标题
                if (row == null) {
                    message.append("<b>&nbsp;&nbsp;「" + fileName
                            + "」不是标准的Excel模板...</b><br>");
                } else {
                    String zz_zsmc      = ExcelUtils.getCell(row.getCell(0));//资质证书名称
                    String zz_zsbh      = ExcelUtils.getCell(row.getCell(1));//资质证书编号
                    String zz_dj        = ExcelUtils.getCell(row.getCell(2));//资质等级
                    String xknr         = ExcelUtils.getCell(row.getCell(3));//资质许可内容
                    String zzsxq_time   = ExcelUtils.getCell(row.getCell(4));//资质生效期
                    String zzjzq_time   = ExcelUtils.getCell(row.getCell(5));//资质截止期

                    if (   !StringUtils.equals(zz_zsmc, SszjZyzzConstants.ZZ_ZSMC)
                            || !StringUtils.equals(zz_zsbh, SszjZyzzConstants.ZZ_ZSBH)
                            || !StringUtils.equals(zz_dj, SszjZyzzConstants.ZZ_DJ)
                            || !StringUtils.equals(xknr, SszjZyzzConstants.XKNR)
                            || !StringUtils.equals(zzsxq_time, SszjZyzzConstants.ZZSXQ_TIME)
                            || !StringUtils.equals(zzjzq_time, SszjZyzzConstants.ZZJZQ_TIME)
                    ) {
                        message.append("<b>&nbsp;&nbsp;「" + fileName
                                + "」不是标准的Excel模板...</b><br>");
                    } else {
                        int cnt = sszjService.batchAddZyzz(wb,
                                message,tyshxydm);
                        message.append("<b>&nbsp;&nbsp;「" + fileName + "」导入 "
                                + cnt + " 条记录</b><br>");
                    }
                }
            }
        }
        msg.put("message", message.toString());
        String json = ResponseUtils.buildResultJson(msg);
        writer.write(json);
    }

    /**
     * 根据机构名称获取YW_L_ZZDJBG资质登记信息
     * @param jgmc
     * @return
     */
    @RequestMapping("/getZyzzHqxt")
    @MethodDescription(desc = "根据机构名称获取YW_L_ZZDJBG资质登记")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public String getZyzzHqxt(String jgmc,String tyshxydm){
        try{
            List<YwLZzDjbg> ywLZzDjbgList=sszjService.findYwLZzDjbgByJgmc(jgmc);
            if(!ywLZzDjbgList.isEmpty()){
                sszjService.copyToZyzz(ywLZzDjbgList,tyshxydm);
                return ResponseUtils.buildResultJson(true,"获取数据成功！");
            }else{
                return ResponseUtils.buildResultJson(true,"未获取到数据！");
            }

        }catch (Exception e){
            e.printStackTrace();
            return ResponseUtils.buildResultJson(false,"修改失败！");
        }
    }

    @RequestMapping("/batchAddZyry")
    @RequiresPermissions("sszj_zjxxda_gld.page")
    @ResponseBody
    public void batchAddZyry(HttpServletRequest request,
                             HttpServletResponse response, Writer writer, String filePathStr,
                             String fileNameStr,String tyshxydm) throws Exception {

        SysLogUtil.addLog("批量导入执业资质信息", request);

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
            if (rowNum < 2) {
                message.append("<b>&nbsp;&nbsp;「" + fileName
                        + "」批量导入执业人员信息目录数量为0，无法导入...</b><br>");
            } else {
                Row row = sheet.getRow(0); // 获得标题
                if (row == null) {
                    message.append("<b>&nbsp;&nbsp;「" + fileName
                            + "」不是标准的Excel模板...</b><br>");
                } else {
                    String xm      = ExcelUtils.getCell(row.getCell(0));//姓名
                    String sfzh      = ExcelUtils.getCell(row.getCell(1));//身份证号
                    String zz_zsmc        = ExcelUtils.getCell(row.getCell(2));//资质证书名称
                    String zz_zsbh         = ExcelUtils.getCell(row.getCell(3));//资质证书编号
                    String zz_dj   = ExcelUtils.getCell(row.getCell(4));//资质等级

                    if (   !StringUtils.equals(xm, SszjZyryConstants.XM)
                            || !StringUtils.equals(sfzh, SszjZyryConstants.SFZH)
                            || !StringUtils.equals(zz_zsmc, SszjZyryConstants.ZZ_ZSMC)
                            || !StringUtils.equals(zz_zsbh, SszjZyryConstants.ZZ_ZSBH)
                            || !StringUtils.equals(zz_dj, SszjZyryConstants.ZZ_DJ)
                    ) {
                        message.append("<b>&nbsp;&nbsp;「" + fileName
                                + "」不是标准的Excel模板...</b><br>");
                    } else {
                        int cnt = sszjService.batchAddZyry(wb,
                                message,tyshxydm);
                        message.append("<b>&nbsp;&nbsp;「" + fileName + "」导入 "
                                + cnt + " 条记录</b><br>");
                    }
                }
            }
        }
        msg.put("message", message.toString());
        String json = ResponseUtils.buildResultJson(msg);
        writer.write(json);
    }

    @RequestMapping({"/saveXycnFileInfo"})
    @ResponseBody
    public String saveXycnFileInfo(UploadFile file) {
        try {
            file.setCreateUser(new SysUser(this.getUserId()));
            file.setCreateDate(new Date());
            file.setFileType(UploadFileEnmu.信用承诺附件.getKey());
            this.sszjService.saveXycnFileInfo(file);
            SysUser user = this.sszjService.findUserById(this.getUserId());
            if (!Constants.ADMIN.equals(user.getType()) && !Constants.CENTER.equals(user.getType())) {
                SysLogUtil.addLog("上传信用承诺附件（部门）", this.request);
            } else {
                SysLogUtil.addLog("上传信用承诺附件（中心）", this.request);
            }
        } catch (Exception var3) {
            var3.printStackTrace();
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }

        return ResponseUtils.buildResultJson(true);
    }

    @RequestMapping({"/deleteXycnFileInfo"})
    @ResponseBody
    public String deleteFileInfo(UploadFile file) {
        try {
            this.sszjService.deleteFileInfo(file);
            SysUser user = this.sszjService.findUserById(this.getUserId());
            if (!Constants.ADMIN.equals(user.getType()) && !Constants.CENTER.equals(user.getType())) {
                SysLogUtil.addLog("删除信用承诺附件（部门）", this.request);
            } else {
                SysLogUtil.addLog("删除信用承诺附件（中心）", this.request);
            }
        } catch (Exception var3) {
            var3.printStackTrace();
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }

        return ResponseUtils.buildResultJson(true);
    }

    @RequestMapping({"/saveJbxxFileInfo"})
    @ResponseBody
    public String saveJbxxFileInfo(UploadFile file) {
        try {
            file.setCreateUser(new SysUser(this.getUserId()));
            file.setCreateDate(new Date());
            this.sszjService.saveJbxxFileInfo(file);
//            SysUser user = this.sszjService.findUserById(this.getUserId());
//            if (!Constants.ADMIN.equals(user.getType()) && !Constants.CENTER.equals(user.getType())) {
//                SysLogUtil.addLog("上传操作流程附件（部门）", this.request);
//            } else {
//                SysLogUtil.addLog("上传操作流程附件（中心）", this.request);
//            }
            return ResponseUtils.buildResultJson(true, file.getBusinessId());
        } catch (Exception var3) {
            var3.printStackTrace();
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
    }

    @RequestMapping({"/deleteJbxxFileInfo"})
    @ResponseBody
    public String deleteJbxxFileInfo(UploadFile file) {
        try {
            this.sszjService.deleteJbxxFileInfo(file);
//            SysUser user = this.sszjService.findUserById(this.getUserId());
//            if (!Constants.ADMIN.equals(user.getType()) && !Constants.CENTER.equals(user.getType())) {
//                SysLogUtil.addLog("删除信用承诺附件（部门）", this.request);
//            } else {
//                SysLogUtil.addLog("删除信用承诺附件（中心）", this.request);
//            }
            return ResponseUtils.buildResultJson(true,"操作成功！");
        } catch (Exception var3) {
            var3.printStackTrace();
            return ResponseUtils.buildResultJson(false, "操作失败！");
        }
    }
}
