package com.udatech.common.creditCheck.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.creditCheck.dao.PCreditCheckDao;
import com.udatech.common.creditCheck.service.PCreditCheckService;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.enmu.StatusEnmu;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.PCreditExamine;
import com.udatech.common.model.PCreditExamineHis;
import com.udatech.common.model.PeopleExamine;
import com.udatech.common.resourceManage.model.CreditTemplate;
import com.udatech.common.resourceManage.model.Theme;
import com.udatech.common.resourceManage.service.CreditTemplateService;
import com.udatech.common.resourceManage.vo.TemplateThemeColumn;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.udatech.common.util.CreditCheckUtils;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.PropUtil;
import com.udatech.common.util.wordUtilsByPoi.CreateWordByTempUtils;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.log.ExpLog;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @Description: 信用审查ServiceImpl(中心端)
 * @author: 何斐
 * @date: 2016年11月21日 下午3:54:02
 */
@Service
@ExpLog(type = "信用审查")
public class PCreditCheckServiceImpl implements PCreditCheckService {

    /* 上传自然人最大数量 */
    public static final int UPLOAD_SIZE_MAX = 1000;

    /* 批量上传自然人最大数量*/
    public static final int BATCH_UPLOAD_SIZE_MAX = 500;

    @Autowired
    private PCreditCheckDao pCreditCheckDao;

    @Autowired
    private CreditCommonDao creditCommonDao;

    @Autowired
    @Qualifier("creditTemplateService")
    private CreditTemplateService creditTemplateService;        // 信用报告模板service

    @Override
    public SysUser findUserById(String sysuserid) {
        return pCreditCheckDao.findUserById(sysuserid);
    }

    @Override
    public Pageable<PCreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs, String sqsjz,
                                                   String userId, String status, String type, String bjbm) {
        return pCreditCheckDao.findCreditExamineCondition(page, scmc, xqbm, bjbh, sqsjs, sqsjz, userId, status, type, bjbm);
    }

    @Override
    public Pageable<PCreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs, String sqsjz,
                                                   String userId, String status) {
        return pCreditCheckDao.findCreditExamineCondition(page, scmc, xqbm, bjbh, sqsjs, sqsjz, userId, status);
    }

    @Override
    public PCreditExamineHis findCreditExamineHisByCreditExamineId(String id) {
        return pCreditCheckDao.findCreditExamineHisByCreditExamineId(id);
    }

    @Override
    public UploadFile findUploadFile(String id, String type) {
        return pCreditCheckDao.findUploadFile(id, type);
    }

    @Override
    public Pageable<PeopleExamine> getPeopleList(Page page, String id) {
        return pCreditCheckDao.getPeopleList(page, id);
    }

    @Override
    public boolean aduitExamine(String id, String type, String shyj, String sysuserid, String uploadFileName, String uploadFilePath, String userId) {
        try {
            PCreditExamine PCreditExamine = pCreditCheckDao.get(PCreditExamine.class, id);
            String status;
            if (BooleanUtils.toBoolean(type)) {
                status = StatusEnmu.审核通过.getKey();
            } else {
                status = StatusEnmu.审核不通过.getKey();
            }
            // 更新主表信息
            PCreditExamine.setStatus(status);
            pCreditCheckDao.update(PCreditExamine);

            //  保存审核附件
            if (StringUtils.isNotBlank(uploadFileName) && StringUtils.isNotBlank(uploadFilePath)) {
                String[] names = new String[]{uploadFileName};
                String[] paths = new String[]{uploadFilePath};
                creditCommonDao.saveUploadFiles(names, paths, UploadFileEnmu.企业信用审查审核上传附件, userId, PCreditExamine.getId());
            }
            // 添加历史表记录
            PCreditExamineHis PCreditExamineHis = new PCreditExamineHis();
            PCreditExamineHis.setId(UUID.randomUUID().toString());
            PCreditExamineHis.setOpinion(shyj);
            PCreditExamineHis.setStatus(status);
            PCreditExamineHis.setAuditDate(new Date());
            PCreditExamineHis.setAuditUser(new SysUser(sysuserid));
            PCreditExamineHis.setpCreditExamine(new PCreditExamine(PCreditExamine.getId()));
            pCreditCheckDao.save(PCreditExamineHis);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public UploadFile saveFilePath(String businessId, String fileName, String filePath, String createUser) {
        // 保存上传文件
        UploadFile uploadFile = new UploadFile();
        uploadFile.setUploadFileId(UUID.randomUUID().toString());
        uploadFile.setFileName(fileName);
        uploadFile.setFilePath(filePath);
        uploadFile.setFileType(UploadFileEnmu.企业信用审查审核附件.getKey());
        uploadFile.setCreateDate(new Date());
        uploadFile.setCreateUser(new SysUser(createUser));
        uploadFile.setBusinessId(businessId);

        String icon = "";
        if (StringUtils.isNotBlank(fileName)) {
            int index = fileName.lastIndexOf(".");
            if (index >= 0) {
                String suffix = fileName.substring(index);
                icon = com.udatech.common.util.FileUtils
                        .getIcon(suffix);
                icon = "/app/images/icon/" + icon;
            }
        }

        uploadFile.setIcon(icon);
        pCreditCheckDao.save(uploadFile);
        return uploadFile;
    }

    @Override
    public Pageable<PeopleExamine> findPeopleByPage(Page page, List<PeopleExamine> peopleList) {
        int pageSize = 10; // 每页显示数目
        int totalRecords; // 总条数
        int totalPages; // 总页数
        int currentPage; // 当前页数
        List<PeopleExamine> peopleExamineList = new ArrayList<>(); // 当前页显示的数据

        if (page.getPageSize() != null) {
            pageSize = page.getPageSize();
        }

        if (page.getCurrentPage() == null || page.getCurrentPage() <= 0) {
            currentPage = 1;
        } else {
            currentPage = page.getCurrentPage();
        }

        Pageable<PeopleExamine> result = new SimplePageable<>();
        if (peopleList == null || peopleList.size() <= 0) {
            result.setPageSize(pageSize);
            result.setCurrentPage(0);
            result.setTotalRecords(0);
            result.setTotalPages(0);
        } else {
            totalRecords = peopleList.size();
            totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
            if (currentPage != totalPages) {
                peopleExamineList.addAll(peopleList.subList((currentPage - 1) * pageSize, pageSize * currentPage));
            } else {
                peopleExamineList.addAll(peopleList.subList((currentPage - 1) * pageSize, totalRecords));
            }

            result.addData(peopleExamineList);
            result.setCurrentPage(currentPage);
            result.setTotalRecords(totalRecords);
            result.setTotalPages(totalPages);
            result.setPageSize(pageSize);
        }
        return result;
    }

    @Override
    public boolean addPeople(String bjbh, String xm, String sfzh, List<PeopleExamine> peopleList, JSONObject msg) {
        if (peopleList.size() >= UPLOAD_SIZE_MAX) {
            msg.put("result", false);
            msg.put("message", "一次只能审查1000条数据！");
            return false;
        }
        PeopleExamine peopleExamine = new PeopleExamine();
        peopleExamine.setId(UUID.randomUUID().toString());
        peopleExamine.setBjbh(bjbh);
        peopleExamine.setXm(xm);
        peopleExamine.setSfzh(sfzh);

        boolean isExistInPeopleList = CreditCheckUtils.isExistInPeopleList(peopleExamine, peopleList);
        if (isExistInPeopleList) {
            msg.put("result", false);
            msg.put("message", "该自然人已存在！");
            return false;
        }
        peopleList.add(peopleExamine);
        return true;
    }

    @Override
    public void removePeoples(List<PeopleExamine> peopleList, String id) {
        Iterator<PeopleExamine> iterator = peopleList.iterator();
        while (iterator.hasNext()) {
            PeopleExamine peopleExamine = iterator.next();
            if (StringUtils.equals(peopleExamine.getId(), id)) {
                iterator.remove(); // 注意这个地方
            }
        }
    }

    @Override
    public Integer batchAdd(Workbook wb, String bjbh, StringBuffer message, List<PeopleExamine> peopleList) {
        Row row;
        String xm;
        String sfzh;
        Sheet sheet = wb.getSheetAt(0);
        int size = 0;
        for (int i = 1; i < sheet.getLastRowNum() + 1; i++) {
            PeopleExamine peopleExamine = new PeopleExamine();
            row = sheet.getRow(i);
            if (row == null) {
                continue;
            }
            xm = ExcelUtils.getCell(row.getCell(0));
            sfzh = ExcelUtils.getCell(row.getCell(1));
            int nowRowNum = i + 1;
            if (StringUtils.isBlank(xm) && StringUtils.isBlank(sfzh)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " : 没有数据 , 跳过解析。<br>");
                continue;
            }

            if (StringUtils.isBlank(xm)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " :「姓名」不能为空。 <br>");
                continue;
            } else {
                peopleExamine.setXm(xm);
            }

            if (StringUtils.isBlank(sfzh)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " :「身份证号」不能为空。<br>");
                continue;
            } else if (!checkIdCardNo(sfzh)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " :「身份证号」格式错误。<br>");
                continue;
            } else {
                peopleExamine.setId(UUID.randomUUID().toString());
                peopleExamine.setSfzh(StringUtils.trim(sfzh));
                peopleExamine.setBjbh(StringUtils.trim(bjbh));
            }

            boolean isExistInPeopleList = CreditCheckUtils.isExistInPeopleList(peopleExamine, peopleList);
            if (isExistInPeopleList) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " ：该自然人已存在。<br>");
                continue;
            }
            peopleList.add(peopleExamine);
            size++;
        }
        return size;
    }

    /**
     * 检查身份证号码合法性
     *
     * @param idCardNo
     * @return
     * @throws Exception
     */
    private static boolean checkIdCardNo(String idCardNo) {
        try {
            if (StringUtils.isBlank(idCardNo)) {
                return false;
            }
            Pattern p = Pattern.compile("(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)|(^[a-zA-Z]{5,17}$)|(^[a-zA-Z0-9]{5,17}$)|(^[HMhm]{1}([0-9]{10}|[0-9]{8})$)|(^[0-9]{8}$)|(^[0-9]{10}$)");
            Matcher m = p.matcher(idCardNo);
            return m.matches();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public String addApplication(String bjbh, String departentId, String userId, String scxxl, String scmc, Date scsjs, Date scsjz,
                                 List<PeopleExamine> peopleList,
                                 String[] uploadFileName, String[] uploadFilePath) {
        Date date = new Date();
        PCreditExamine PCreditExamine = new PCreditExamine();
        PCreditExamine.setScxqbm(new SysDepartment(departentId));
        PCreditExamine.setCreateUser(new SysUser(userId));
        PCreditExamine.setScxxl(scxxl);
        PCreditExamine.setScmc(scmc);
        PCreditExamine.setScsm("信用中心申请");
        PCreditExamine.setStatus(StatusEnmu.待审核.getKey());
        PCreditExamine.setBjbh(bjbh);
        PCreditExamine.setApplyDate(date);
        PCreditExamine.setScsjs(scsjs);
        PCreditExamine.setScsjz(scsjz);
        pCreditCheckDao.save(PCreditExamine);

        //  保存审核附件
        if (uploadFileName != null && uploadFilePath != null) {
            creditCommonDao.saveUploadFiles(uploadFileName, uploadFilePath, UploadFileEnmu.企业信用审查申请附件, userId, PCreditExamine.getId());
        }

        // 添加历史表记录
        PCreditExamineHis PCreditExamineHis = new PCreditExamineHis();
        PCreditExamineHis.setOpinion("信用中心申请");
        PCreditExamineHis.setStatus(StatusEnmu.审核通过.getKey());
        PCreditExamineHis.setAuditDate(date);
        PCreditExamineHis.setAuditUser(new SysUser(userId));
        PCreditExamineHis.setpCreditExamine(new PCreditExamine(PCreditExamine.getId()));
        pCreditCheckDao.save(PCreditExamineHis);

        for (PeopleExamine peopleExamine : peopleList) {
            peopleExamine.setpCreditExamine(new PCreditExamine(PCreditExamine.getId()));
            pCreditCheckDao.save(peopleExamine);
        }

        return PCreditExamine.getId();
    }

    @Override
    public PCreditExamine addApplication(String bjbh, String departentId, String userId, String scxxl, String scmc,
                                         String scsm, Date scsjs, Date scsjz, String[] file_name, String[] file_path, List<PeopleExamine> peopleList) {

        PCreditExamine PCreditExamine = new PCreditExamine();
        PCreditExamine.setScxqbm(new SysDepartment(departentId));
        PCreditExamine.setCreateUser(new SysUser(userId));
        PCreditExamine.setScxxl(scxxl);
        PCreditExamine.setScmc(scmc);
        PCreditExamine.setScsm(scsm);
        PCreditExamine.setStatus(StatusEnmu.待审核.getKey());
        PCreditExamine.setBjbh(bjbh);
        PCreditExamine.setScsjs(scsjs);
        PCreditExamine.setScsjz(scsjz);
        PCreditExamine.setApplyDate(new Date());
        pCreditCheckDao.save(PCreditExamine);

        for (PeopleExamine enter : peopleList) {
            enter.setpCreditExamine(new PCreditExamine(PCreditExamine.getId()));
            pCreditCheckDao.save(enter);
        }

        creditCommonDao.saveUploadFiles(file_name, file_path, UploadFileEnmu.企业信用审查申请附件, userId, PCreditExamine.getId());
        return PCreditExamine;

    }

    @Override
    public String getScxxl(String scxxlIdArr) {
        String[] scxxlIdStrArr = StringUtils.split(scxxlIdArr, ",");
        StringBuilder scxxl = new StringBuilder();
        for (String scxxlId : scxxlIdStrArr) {
            Theme theme = pCreditCheckDao.get(Theme.class, scxxlId); // 获取资源名称
            if (theme == null)
                continue;
            scxxl.append(theme.getTypeName()).append(",");
        }
        return StringUtils.substringBeforeLast(scxxl.toString(), ",");
    }

    @Override
    public String createCreditReport(HttpServletRequest request, String id) {
        Map<String, Object> params = new LinkedHashMap<>();
        Map<String, Object> listParams = new LinkedHashMap<>();
        List<Map<String, Object>> enterMsgList = new ArrayList<>();
        //String id = request.getParameter("id");
        PCreditExamine pCreditExamine = pCreditCheckDao.get(PCreditExamine.class, id); // 获取信用审查详情

        SimpleDateFormat sf = new SimpleDateFormat("yyyy年MM月dd日");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String date = sf.format(new Date());

        String[] scxxlIdStrArr = StringUtils.split(pCreditExamine.getScxxl(), ",");
        StringBuilder scxxl = new StringBuilder();
        for (String scxxlId : scxxlIdStrArr) {
            Theme theme = pCreditCheckDao.get(Theme.class, scxxlId); // 获取资源名称
            if (theme == null)
                continue;
            scxxl.append(theme.getTypeName()).append(",");
        }
        scxxl = new StringBuilder(StringUtils.substringBeforeLast(scxxl.toString(), ","));

        String scsjs = sf.format(pCreditExamine.getScsjs());
        String scsjz = sf.format(pCreditExamine.getScsjz());

        CreditTemplate creditTemplate =
                creditTemplateService.getDefaultByCategoryAndUseType(DZThemeEnum.自然人.getKey(), DZThemeEnum.模板用途_信用审查.getKey());

        // 获取默认模板的详细信息
        List<TemplateThemeNode> themeInfo;
        if (creditTemplate != null) {
            themeInfo = creditTemplateService.getTemplateInfo(creditTemplate.getId(), DZThemeEnum.资源用途_自然人信用审查.getKey());

            // 添加模板配置信息
            params.put("bgbt", creditTemplate.getTitle()); // 报告标题
            params.put("bgcc", creditTemplate.getReportSource()); // 报告出处
            params.put("sjly", creditTemplate.getDataFrom()); // 数据来源
            params.put("lxdz", creditTemplate.getAddress()); // 联系地址
            params.put("lxdh", creditTemplate.getContactPhone()); // 联系电话

            // 开始结束时间
            String kssj = sdf.format(pCreditExamine.getScsjs());
            String jssj = sdf.format(pCreditExamine.getScsjz());
            Date beginDate = null;
            Date endDate = null;
            if (StringUtils.isNotBlank(kssj)) {
                beginDate = DateUtils.parseDate(kssj + " 00:00:00", DateUtils.YYYYMMDDHHMMSS_19);
            }
            if (StringUtils.isNotBlank(jssj)) {
                endDate = DateUtils.parseDate(jssj + " 23:59:59", DateUtils.YYYYMMDDHHMMSS_19);
            }

            List<PeopleExamine> peopleExamineList = pCreditCheckDao.getPeopleList(id);
            List<Map<String, Object>> existList = new ArrayList<>();
            List<Map<String, Object>> unExistList = new ArrayList<>();
            List<Map<String, Object>> allList = new ArrayList<>();
            int existIndex = 0;
            int unExistIndex = 0;
            int allIndex = 0;
            for (PeopleExamine peopleExamine : peopleExamineList) {
                boolean res = pCreditCheckDao.isPeopleExisted(peopleExamine.getSfzh());
                Map<String, Object> peopleMap = new LinkedHashMap<>();
                peopleMap.put("姓名", peopleExamine.getXm());
                peopleMap.put("身份证号", peopleExamine.getSfzh());

                if (res) {
                    peopleMap.put("编号", ++existIndex);
                    existList.add(peopleMap);
                } else {
                    peopleMap.put("编号", ++unExistIndex);
                    unExistList.add(peopleMap);
                }

                peopleMap.put("编号", ++allIndex);
                allList.add(peopleMap);
            }

            listParams.put("2", existList);
            listParams.put("3", unExistList);
            listParams.put("4", allList);

            params.put("allCnt", allList.size()); // 全部审查法人数量
            params.put("existCnt", existList.size()); // 审查到相关基本信息的法人数量
            params.put("unExistCnt", unExistList.size()); // 审查不到相关基本信息的法人数量
            int noMsgCnt = 0; // 审查到审查信息的企业
            for (Map<String, Object> existPeople : existList) {
                Map<String, Object> enterMsgMap = new LinkedHashMap<>();
                List<Map<String, Object>> checkDetailList = new ArrayList<>();
                StringBuilder scxxlRes = new StringBuilder();
                for (TemplateThemeNode templateThemeNode : themeInfo) {
                    // 判断是否需要审查该类别
                    boolean res = Arrays.asList(scxxlIdStrArr).contains(templateThemeNode.getId());
                    if (!res) {
                        continue;
                    }

                    Map<String, Object> checkDetailMap = new LinkedHashMap<>();
                    int cnt_oneTitle = 0; // 每个信息审查类的数量
                    List<Map<String, Object>> checkDetail_oneList = new ArrayList<>();
                    for (TemplateThemeNode two : templateThemeNode.getChildren()) {
                        Map<String, Object> checkDetail_oneMap = new LinkedHashMap<>();

                        List<Map<String, Object>> checkDetail_twoList = new ArrayList<>();

                        List<TemplateThemeColumn> tableCol = two.getColumns();
                        Map<String, Object> checkDetail_twoMap = new LinkedHashMap<>();

                        Map<String, Object> headMap = new LinkedHashMap<>();// 获取表头
                        for (TemplateThemeColumn column : tableCol) {
                            headMap.put(column.getColumnName(), column.getColumnAlias());
                        }

                        List<Map<String, Object>> valueList = pCreditCheckDao.findScxxMsg(existPeople, two, beginDate, endDate);
                        cnt_oneTitle += valueList.size();
                        if (valueList.size() == 0) {
                            continue;
                        }
                        checkDetail_twoMap.put("headMap", headMap);
                        checkDetail_twoMap.put("valueList", valueList);
                        checkDetail_twoList.add(checkDetail_twoMap);
                        checkDetail_oneMap.put("checkDetail_twoList", checkDetail_twoList);
                        checkDetail_oneMap.put("title_two", two.getText());
                        checkDetail_oneList.add(checkDetail_oneMap);
                    }
                    if (cnt_oneTitle > 0)
                        scxxlRes.append(templateThemeNode.getText()).append(cnt_oneTitle).append("条\n");
                    if (checkDetail_oneList.size() == 0) {
                        continue;
                    }

                    checkDetailMap.put("title_one", templateThemeNode.getText());
                    checkDetailMap.put("checkDetail_oneList", checkDetail_oneList);
                    checkDetailList.add(checkDetailMap);
                }
                scxxlRes = new StringBuilder(StringUtils.substringBeforeLast(scxxlRes.toString(), "\n"));
                if (StringUtils.isBlank(scxxlRes.toString())) {
                    existPeople.put("审查信息结果", "无结果");
                    noMsgCnt++;
                } else {
                    existPeople.put("审查信息结果", scxxlRes.toString());
                }
                if (checkDetailList.size() == 0) {
                    continue;
                }

                enterMsgMap.put("name", MapUtils.getString(existPeople, "姓名", ""));
                enterMsgMap.put("checkDetailList", checkDetailList);
                enterMsgList.add(enterMsgMap);
            }
            params.put("noMsgCnt", noMsgCnt); // 未找到审核信息记录的自然人
        }

        params.put("bgbh", pCreditExamine.getBjbh()); // 报告编号
        params.put("scmc", pCreditExamine.getScmc()); // 审查名称
        params.put("scbm", pCreditExamine.getScxqbm().getDepartmentName()); // 审查部门
        params.put("sclb", scxxl.toString()); // 审查类别
        params.put("date", date); // 报告日期
        params.put("scsjs", scsjs); // 审查时间始
        params.put("scsjz", scsjz); // 审查时间止

        SimpleDateFormat sdfa = new SimpleDateFormat("yyyyMMddHHmmss");
        String time = sdfa.format(new Date());

        String folderPath = PropUtil.get("credit.report.path");
        File file = new File(folderPath);
        if (!file.exists()) {
            file.mkdirs();
        }
        String preFilePath = folderPath + pCreditExamine.getBjbh() + "_" + time + ".docx";
        String templatePath = "/template/自然人审查报告模板.docx";
        try {
            CreateWordByTempUtils.createWordByTemplate(request.getSession().getServletContext().getRealPath(templatePath),
                    preFilePath, params, listParams, enterMsgList, null);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return preFilePath;
    }

    @Override
    public void submitCheckReport(String id, String bz, String uploadFileName, String uploadFilePath, String userId) {
        PCreditExamine pCreditExamine = pCreditCheckDao.get(PCreditExamine.class, id);
        PCreditExamineHis pCreditExamineHis = pCreditCheckDao.findCreditExamineHisByCreditExamineId(id);
        // 更新主表信息
        pCreditExamine.setStatus(StatusEnmu.审核通过.getKey());
        pCreditCheckDao.update(pCreditExamine);

        //更新历史表记录
        pCreditExamineHis.setOpinion(bz);
        pCreditCheckDao.update(pCreditExamineHis);

        //  保存红头文件
        if (StringUtils.isNotBlank(uploadFileName) && StringUtils.isNotBlank(uploadFilePath)) {
            String[] names = new String[]{uploadFileName};
            String[] paths = new String[]{uploadFilePath};
            creditCommonDao.saveUploadFiles(names, paths, UploadFileEnmu.企业信用审查审核上传附件, userId, id);
        }

    }
}
