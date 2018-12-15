package com.udatech.common.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.Writer;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.udatech.common.model.EnterpriseBaseInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.UploadResult;
import com.udatech.common.service.CreditCommonService;
import com.udatech.common.util.FileUtils;
import com.udatech.common.util.PropUtil;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.util.DateUtils;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;

/**
 * @category 公共接口
 * @author ccl
 */
@Controller
@RequestMapping("/creditCommon")
public class CreditCommonController extends SuperController {
    private Logger logger = Logger.getLogger(CreditCommonController.class);

    private final static String PDF_TYPE = "application/pdf";
    
    private final static String[] PIC_TYPE = {".jpg",".png",".gif"};
    
    @Autowired
    private CreditCommonService commonService;

    /**
     * @category 部门列表
     * @param type
     * @return
     */
    @RequestMapping("/getDept")
    @ResponseBody
    public List<SysDepartment> getDept(String type) {
        List<SysDepartment> deptList = new ArrayList<SysDepartment>();
        List<SysDepartment> list = commonService.findAllDept();

        if ("1".equals(type)) {
            SysDepartment dept = new SysDepartment();
            dept.setId("");
            dept.setDepartmentName("全部");
            deptList.add(dept);
            deptList.addAll(list);
        } else {
            deptList.addAll(list);
        }

        return deptList;
    }

    /**
     * @Title: getIndustry
     * @Description: 获取行业所有类别（下拉框用）
     * @return List<Map<String, Object>>
     */
    @RequestMapping("/getIndustry")
    @ResponseBody
    public String getIndustry() {
        List<Map<String, Object>> industryList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> industryCodeList = commonService.getAllIndustryCode();
        Map<String, Object> item = new HashMap<String, Object>();
        item.put("id", " ");
        item.put("text", "全部");
        industryList.add(item);
        for (Map<String, Object> map : industryCodeList) {
            Map<String, Object> industryCodeMap = new HashMap<String, Object>();
            industryCodeMap.put("id", MapUtils.getString(map, "GB_CODE", ""));
            industryCodeMap.put("text", MapUtils.getString(map, "GB_NAME", ""));
            industryList.add(industryCodeMap);
        }
        return JSON.toJSONString(industryList);
    }

    /**
     * @category 获取企业信息
     * @param info
     * @return
     */
    @RequestMapping("/getEnterpriseInfo")
    @ResponseBody
    public EnterpriseInfo getEnterpriseInfo(EnterpriseInfo info) {
        return commonService.getEnterpriseInfo(info);
    }

    /**
     * @category 获取企业信息列表
     * @param info
     * @return
     */
    @RequestMapping("/getEnterpriseList")
    @ResponseBody
    public List<Map<String, Object>> getEnterpriseList(String keyword) {
        if (StringUtils.isNotBlank(keyword)) {
            return commonService.getEnterpriseList(keyword);
        }
        return null;
    }

    /**
     * <描述>:查询自然人基本信息
     * @author 作者：lijj
     * @version 创建时间：2017年1月13日下午3:33:56
     * @param sfzh
     * @return
     */
    @RequestMapping("/getPersonInfo")
    @ResponseBody
    public List<Map<String, Object>> getPersonInfo(String sfzh) {
        Map<String, Object> personInfo = commonService.getPersonInfo(sfzh);
        if (personInfo == null) {
            return null;
        } else {
            ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(personInfo);
            return list;
        }
    }

    /**
     * @category 获取信用信息(行政处罚信息，欠税信息，欠缴费信息...)【异议修复用】
     * @param ei
     * @return
     */
    @RequestMapping("/getCreditInfo")
    @ResponseBody
    public String getCreditInfo(EnterpriseInfo ei, String op) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = new SimplePageable<Map<String, Object>>();
        if (StringUtils.isNotBlank(op)) {
            try {
                pageable = commonService.getCreditInfo(ei, page);
            } catch (Exception e) {
                pageable = new SimplePageable<Map<String, Object>>();
                e.printStackTrace();
            }
        }
        return PageUtils.buildDTData(pageable, request, DateUtils.YYYYMMDD_10);
    }

    /**
     * @category 获取信用信息(失信表彰等信息...)
     * @param ei
     * @return
     */
    @RequestMapping("/getCreditInfoByTabName")
    @ResponseBody
    public String getCreditInfoByTabName(String sfzh, String tableName) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = new SimplePageable<>();
        if (StringUtils.isNotBlank(tableName)) {
            try {
                pageable = commonService.getCreditInfo(sfzh, tableName, page);
            } catch (Exception e) {
                pageable = new SimplePageable<>();
                logger.error(e.getMessage(), e);
            }
        }
        return PageUtils.buildDTData(pageable, request, DateUtils.YYYYMMDD_10);
    }

    /**
     * @Title: toViewEnterDetail
     * @Description: 查看企业详细信息（包括股东信息、董事会信息）
     * @param request
     * @param response
     * @param supvId
     * @return ModelAndView
     */
    @RequestMapping("/toViewEnterDetail")
    @ResponseBody
    public ModelAndView toViewEnterDetail(HttpServletRequest request, HttpServletResponse response, String enterId) {
        // 法人基本信息
        Map<String, Object> qyxx = commonService.findLegalPersonInfo(enterId);
        ModelAndView view = new ModelAndView("/common/subject/enterDetail");
        view.addObject("qyxx", qyxx);
        return view;
    }

    /**
     * 查看自然人详细信息
     * @param request
     * @param response
     * @param sfzh
     * @return
     */
    @RequestMapping("/toViewPeopleDetail")
    @ResponseBody
    public ModelAndView toViewPeopleDetail(HttpServletRequest request, HttpServletResponse response, String sfzh) {
        // 法人基本信息
        Map<String, Object> grxx = commonService.findPeopleInfo(sfzh);
        ModelAndView view = new ModelAndView("/common/subject/personDetail");
        view.addObject("sfzh", sfzh);
        view.addObject("grxx", grxx);
        return view;
    }


    /**
     * @Title: getEnterpriseBaseInfo
     * @Description: 根据 表名 获取企业各项相关信息（股东，董事会等）
     * @param ei
     * @return String
     */
    @RequestMapping("/getEnterpriseBaseInfo")
    @ResponseBody
    public String getEnterpriseBaseInfo(EnterpriseBaseInfo ei) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = new SimplePageable<Map<String, Object>>();
        if (StringUtils.isNotBlank(ei.getTableKey())) {
            try {
                pageable = commonService.getEnterpriseBaseInfo(ei, page);
            } catch (Exception e) {
                pageable = new SimplePageable<Map<String, Object>>();
                logger.error(e.getMessage(), e);
            }
        }
        return PageUtils.buildDTData(pageable, request, DateUtils.YYYYMMDD_10);
    }

    /**
     * @category 异步上传
     * @param files
     * @return
     */
    @RequestMapping(value = "/ajaxFileUpload")
    public void ajaxFileUpload(HttpServletResponse response, Writer writer,
                    @RequestParam(required = true, value = "files") MultipartFile[] files) {
        response.setContentType("text/html;charset=UTF-8");
        UploadResult result = new UploadResult();

        try {
            String tempPath = PropUtil.get("upload.temp.path");
            File file = new File(tempPath);
            if (!file.exists()) {
                file.mkdirs();
            }

            if (files != null && files.length > 0) {
                for (int i = 0, len = files.length; i < len; i++) {
                    MultipartFile mFile = files[i];
                    long size = mFile.getSize();
                    String name = mFile.getOriginalFilename();
                    String suffix = "";
                    String icon = "";
                    int index = name.lastIndexOf(".");
                    if (index >= 0) {
                        suffix = name.substring(index);
                        icon = FileUtils.getIcon(suffix);
                    }
                    String path = tempPath + UUID.randomUUID().toString() + suffix;
                    String type = mFile.getContentType(); // 获取文件类型

                    String typeStr = "文件";
                    if (StringUtils.equals(type, PDF_TYPE)) {
                        if (size > 20 * 1024 * 1024) {// 大于20M
                            result.addFailFile(name, "上传pdf文件不能大于20M，请调整pdf大小后重新上传！");
                        } else {
                            file = new File(path);
                            mFile.transferTo(file);
                            result.addSuccessFile(icon, name, path);
                        }
                    } else {
                    	if(ArrayUtils.contains(PIC_TYPE, suffix.toLowerCase())){
                    		typeStr = "图片";
                    	}
                        if (size > 10 * 1024 * 1024) { // 大于10M
                            result.addFailFile(name, "上传" + typeStr + "不能大于10M，请调整" + typeStr + "大小后重新上传！");
                        } else {
                            file = new File(path);
                            mFile.transferTo(file);
                            result.addSuccessFile(icon, name, path);
                        }
                    }
                }
            }
            writer.write(ResponseUtils.toJSONString(result));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * @category 信用审核异步上传
     * @param files
     * @return
     */
    @RequestMapping(value = "/examineAjaxFileUpload")
    public void examineAjaxFileUpload(HttpServletResponse response, Writer writer,
                    @RequestParam(required = true, value = "files") MultipartFile[] files) {
    	response.setContentType("text/html;charset=UTF-8");
        UploadResult result = new UploadResult();

        try {
            String tempPath = PropUtil.get("upload.temp.path");
            File file = new File(tempPath);
            if (!file.exists()) {
                file.mkdirs();
            }

            if (files != null && files.length > 0) {
                for (int i = 0, len = files.length; i < len; i++) {
                    MultipartFile mFile = files[i];
                    long size = mFile.getSize();
                    String name = mFile.getOriginalFilename();
                    String suffix = "";
                    String icon = "";
                    int index = name.lastIndexOf(".");
                    if (index >= 0) {
                        suffix = name.substring(index);
                        icon = FileUtils.getIcon(suffix);
                    }
                    String path = tempPath + UUID.randomUUID().toString() + suffix;
                    String type = mFile.getContentType(); // 获取文件类型

                    String typeStr = "文件";
                    if (StringUtils.equals(type, PDF_TYPE)) {
                        if (size > 50 * 1024 * 1024) {// 大于20M
                            result.addFailFile(name, "上传pdf文件不能大于50M，请调整pdf大小后重新上传！");
                        } else {
                            file = new File(path);
                            mFile.transferTo(file);
                            result.addSuccessFile(icon, name, path);
                        }
                    } else {
                    	if(ArrayUtils.contains(PIC_TYPE, suffix.toLowerCase())){
                    		typeStr = "图片";
                    	}
                        if (size > 50 * 1024 * 1024) { // 大于10M
                            result.addFailFile(name, "上传" + typeStr + "不能大于50M，请调整" + typeStr + "大小后重新上传！");
                        } else {
                            file = new File(path);
                            mFile.transferTo(file);
                            result.addSuccessFile(icon, name, path);
                        }
                    }
                }
            }
            writer.write(ResponseUtils.toJSONString(result));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * @category 图片预览
     * @param response
     * @param path
     * @throws Exception
     */
    @RequestMapping("/viewImg")
    public void viewImg(HttpServletResponse response, String path) throws Exception {
        File file = new File(path);
        if (file.exists()) {
            response.reset();
            response.setContentType("application/pdf");
            FileInputStream fis = new FileInputStream(file);
            BufferedInputStream buff = new BufferedInputStream(fis);
            byte[] b = new byte[1024];
            long k = 0;
            OutputStream os = response.getOutputStream();
            while (k < file.length()) {
                int j = buff.read(b, 0, 1024);
                k += j;
                os.write(b, 0, j);
            }
            os.flush();
            buff.close();
            os.close();
        }
    }

    /**
     * @category PDF预览
     * @param model
     * @param uploadFileId
     * @return
     */
    @RequestMapping("/viewPdf")
    public String viewPdf(Model model, String uploadFileId) {
        UploadFile pdf = commonService.getUploadFile(uploadFileId);
        File file = new File(pdf.getFilePath());
      if(file.exists()){
          model.addAttribute("fileName", pdf.getFileName());
          model.addAttribute("exists", true);
          model.addAttribute("fact", "/$_virtual_path_$/" + pdf.getFilePath());
      }else {
          model.addAttribute("exists", false);
      }

        return "/common/view/view_pdf";
    }

    @RequestMapping("/ajaxDownload")
    public void downLoadFile(HttpServletRequest request, HttpServletResponse response, String uploadFileId, String fileName, String filePath)
                    throws Exception {
        // 创建file对象
        UploadFile uploadFile = null;
        if (StringUtils.isNotBlank(uploadFileId)) {
            uploadFile = commonService.getUploadFile(uploadFileId);
            if (uploadFile != null) {
                filePath = uploadFile.getFilePath();
            }
        } else if (StringUtils.isNotBlank(filePath)) {
            uploadFile = commonService.getUploadFileByFilePath(filePath);
        } else {
            return;
        }

        if (uploadFile != null) {
            File file = new File(filePath);
            if (file.exists()) {
                if (StringUtils.isBlank(fileName)) {
                    fileName = uploadFile.getFileName();
                } else {
                    fileName = URLDecoder.decode(fileName, "utf-8");
                }
                fileName = StringEscapeUtils.unescapeHtml(fileName);
                // 设置response的编码方式
                response.setContentType("application/octet-stream");
                // 写明要下载的文件的大小
                response.setContentLength((int) file.length());
                // 设置输出的格式
                FileUtils.setDownFileName(response, request, fileName);
                // 读出文件到i/o流
                FileInputStream fis = new FileInputStream(file);
                BufferedInputStream buff = new BufferedInputStream(fis);
                byte[] b = new byte[1024];// 相当于我们的缓存
                long k = 0;// 该值用于计算当前实际下载了多少字节
                // 从response对象中得到输出流,准备下载
                OutputStream os = response.getOutputStream();
                // 开始循环下载
                while (k < file.length()) {
                    int j = buff.read(b, 0, 1024);
                    k += j;
                    // 将b中的数据写到客户端的内存
                    os.write(b, 0, j);
                }
                // 将写入到客户端的内存的数据,刷新到磁盘
                os.flush();
                buff.close();
                os.close();
            }

        }

    }

    /**
     * @Description: 构造国标行业树
     * @param: @param request
     * @param: @param response
     * @param: @return
     * @param: @throws Exception
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/getIndustryTree")
    @ResponseBody
    public String getIndustryTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Map<String, Object>> industryCodeList = commonService.getAllIndustryCode();
        JSONArray array = commonService.buildIndustryTree(industryCodeList);
        return array.toString();
    }

    /**
     * @Title: getErrorCode
     * @Description: 获取疑问数据分类（下拉框用）
     * @return List<Map<String, Object>>
     */
    @RequestMapping("/getErrorCode")
    @ResponseBody
    public String getErrorCode() {
        List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> errorCodeList = commonService.getErrorCode();
        Map<String, Object> item = new HashMap<String, Object>();
        item.put("id", " ");
        item.put("text", "全部");
        newList.add(item);
        for (Map<String, Object> map : errorCodeList) {
            Map<String, Object> mewmap = new HashMap<String, Object>();
            mewmap.put("id", MapUtils.getString(map, "ERROR_CODE", ""));
            mewmap.put("text", MapUtils.getString(map, "ERROR_DESC", ""));
            newList.add(mewmap);
        }
        return JSON.toJSONString(newList);
    }

}
