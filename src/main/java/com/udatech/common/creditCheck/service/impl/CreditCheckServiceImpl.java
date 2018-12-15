package com.udatech.common.creditCheck.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.creditCheck.dao.CreditCheckDao;
import com.udatech.common.creditCheck.service.CreditCheckService;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.DZThemeEnum;
import com.udatech.common.enmu.StatusEnmu;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.CreditExamine;
import com.udatech.common.model.CreditExamineHis;
import com.udatech.common.model.EnterpriseExamine;
import com.udatech.common.resourceManage.model.CreditTemplate;
import com.udatech.common.resourceManage.model.Theme;
import com.udatech.common.resourceManage.service.CreditTemplateService;
import com.udatech.common.resourceManage.vo.TemplateThemeColumn;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.udatech.common.util.CreditCheckUtils;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.IdentityUtil;
import com.udatech.common.util.PropUtil;
import com.udatech.common.util.wordUtilsByPoi.CreateWordByTempUtils;
import com.udatech.common.util.wordUtilsByPoi.StyleText;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.log.ExpLog;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
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
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @Description: 信用审查ServiceImpl(中心端)
 * @author: 何斐
 * @date: 2016年11月21日 下午3:54:02
 */
@Service
@ExpLog(type = "信用审查")
public class CreditCheckServiceImpl implements CreditCheckService {
    private final static String DATEFORMAT_YYYYMM = "MM月";
    private final static String DATEFORMAT_YYYY_MM = "yyyy-MM";

    /* 上传企业最大数量*/
    public static final int UPLOAD_SIZE_MAX = 1000;

    /* 批量上传企业最大数量*/
    public static final int BATCH_UPLOAD_SIZE_MAX = 500;

    @Autowired
    private CreditCheckDao creditCheckDao;

    @Autowired
    private CreditCommonDao creditCommonDao;

    @Autowired
    @Qualifier("creditTemplateService")
    private CreditTemplateService creditTemplateService;        // 信用报告模板service

    @Override
    public SysUser findUserById(String sysuserid) {
        return creditCheckDao.findUserById(sysuserid);
    }

    @Override
    public Pageable<CreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs,
                                                  String sqsjz, String userId, String status, String type, String bjbm) {
        return creditCheckDao.findCreditExamineCondition(page, scmc, xqbm, bjbh, sqsjs, sqsjz, userId, status, type, bjbm);
    }

    @Override
    public CreditExamineHis findCreditExamineHisByCreditExamineId(String id) {
        return creditCheckDao.findCreditExamineHisByCreditExamineId(id);
    }

    @Override
    public UploadFile findUploadFile(String id, String type) {
        return creditCheckDao.findUploadFile(id, type);
    }

    @Override
    public Pageable<EnterpriseExamine> getEnterList(Page page, String id) {
        return creditCheckDao.getEnterList(page, id);
    }

    @Override
    public String getScxxl(String scxxlIdArr) {
        String[] scxxlIdStrArr = StringUtils.split(scxxlIdArr, ",");
        StringBuilder scxxl = new StringBuilder();
        for (String scxxlId : scxxlIdStrArr) {
            Theme theme = creditCheckDao.get(Theme.class, scxxlId); // 获取资源名称
            if (theme == null)
                continue;
            scxxl.append(theme.getTypeName()).append(",");
        }
        return StringUtils.substringBeforeLast(scxxl.toString(), ",");
    }

    @Override
    public boolean aduitExamine(String id, String type, String shyj, String sysuserid, String uploadFileName, String uploadFilePath, String userId) {
        try {
            CreditExamine creditExamine = creditCheckDao.get(CreditExamine.class, id);
            String status;
            if (BooleanUtils.toBoolean(type)) {
                status = StatusEnmu.审核通过.getKey();
            } else {
                status = StatusEnmu.审核不通过.getKey();
            }
            // 更新主表信息
            creditExamine.setStatus(status);
            creditCheckDao.update(creditExamine);

            //  保存审核附件
            if (StringUtils.isNotBlank(uploadFileName) && StringUtils.isNotBlank(uploadFilePath)) {
                String[] names = new String[]{uploadFileName};
                String[] paths = new String[]{uploadFilePath};
                creditCommonDao.saveUploadFiles(names, paths, UploadFileEnmu.企业信用审查审核上传附件, userId, creditExamine.getId());
            }

            // 添加历史表记录
            CreditExamineHis creditExamineHis = new CreditExamineHis();
            creditExamineHis.setId(UUID.randomUUID().toString());
            creditExamineHis.setOpinion(shyj);
            creditExamineHis.setStatus(status);
            creditExamineHis.setAuditDate(new Date());
            creditExamineHis.setAuditUser(new SysUser(sysuserid));
            creditExamineHis.setCreditExamine(new CreditExamine(creditExamine.getId()));
            creditCheckDao.save(creditExamineHis);
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
        creditCheckDao.save(uploadFile);
        return uploadFile;
    }

    @Override
    public Pageable<EnterpriseExamine> findEnterByPage(Page page, List<EnterpriseExamine> enterpriseList) {
        int pageSize = 10; // 每页显示数目
        int totalRecords; // 总条数
        int totalPages; // 总页数
        int currentPage; // 当前页数
        List<EnterpriseExamine> enterList = new ArrayList<>(); // 当前页显示的数据

        if (page.getPageSize() != null) {
            pageSize = page.getPageSize().intValue();
        }

        if (page.getCurrentPage() == null || page.getCurrentPage().intValue() <= 0) {
            currentPage = 1;
        } else {
            currentPage = page.getCurrentPage();
        }

        Pageable<EnterpriseExamine> result = new SimplePageable<>();
        if (enterpriseList == null || enterpriseList.size() <= 0) {
            result.setPageSize(pageSize);
            result.setCurrentPage(0);
            result.setTotalRecords(0);
            result.setTotalPages(0);
        } else {
            totalRecords = enterpriseList.size();
            totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
            if (currentPage != totalPages) {
                enterList.addAll(enterpriseList.subList((currentPage - 1) * pageSize, pageSize * currentPage));
            } else {
                enterList.addAll(enterpriseList.subList((currentPage - 1) * pageSize, totalRecords));
            }

            result.addData(enterList);
            result.setCurrentPage(currentPage);
            result.setTotalRecords(totalRecords);
            result.setTotalPages(totalPages);
            result.setPageSize(pageSize);
        }
        return result;
    }

    @Override
    public boolean addEnter(String bjbh, String zzjgdm, String qymc, String gszch, String shxydm,
                            List<EnterpriseExamine> enterpriseList, JSONObject msg) {
        if (enterpriseList.size() >= UPLOAD_SIZE_MAX) {
            msg.put("result", false);
            msg.put("message", "一次只能审查" + UPLOAD_SIZE_MAX + "条数据！");
            return false;
        }
        EnterpriseExamine enter = new EnterpriseExamine();
        enter.setId(UUID.randomUUID().toString());
        enter.setBjbh(bjbh);
        enter.setZzjgdm(zzjgdm);
        enter.setQymc(qymc);
        enter.setGszch(gszch);
        enter.setShxydm(shxydm);

        boolean isExistInEnterList = CreditCheckUtils.isExistInEnterList(enter, enterpriseList);
        if (isExistInEnterList) {
            msg.put("result", false);
            msg.put("message", "该企业已存在！");
            return false;
        }

        creditCheckDao.fillEnterprise(enter);

        enterpriseList.add(enter);
        return true;
    }

    @Override
    public void reomveEnters(List<EnterpriseExamine> enterpriseList, String id) {
        Iterator<EnterpriseExamine> iterator = enterpriseList.iterator();
        while (iterator.hasNext()) {
            EnterpriseExamine enter = iterator.next();
            if (StringUtils.equals(enter.getId(), id)) {
                iterator.remove(); // 注意这个地方
            }
        }
    }

    @Override
    public Integer batchAdd(Workbook wb, String bjbh, StringBuffer message, List<EnterpriseExamine> enterpriseList) {
        Row row;
        String zzjgdm;
        String qymc;
        String gszch;
        String shxydm;
        Sheet sheet = wb.getSheetAt(0);
        int size = 0;
        for (int i = 1; i < sheet.getLastRowNum() + 1; i++) {
            EnterpriseExamine enter = new EnterpriseExamine();
            row = sheet.getRow(i);
            if (row == null) {
                continue;
            }
            qymc = ExcelUtils.getCell(row.getCell(0));
            gszch = ExcelUtils.getCell(row.getCell(1));
            zzjgdm = ExcelUtils.getCell(row.getCell(2));
            shxydm = ExcelUtils.getCell(row.getCell(3));
            // 处理企业名称
            qymc = IdentityUtil.processJgqc(qymc);
            // 处理组织机构代码
            zzjgdm = IdentityUtil.processZzjgdm(zzjgdm);

            int nowRowNum = i + 1;
            if (StringUtils.isBlank(zzjgdm) && StringUtils.isBlank(qymc) && StringUtils.isBlank(gszch)
                    && StringUtils.isBlank(shxydm)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " ：没有数据 ， 跳过解析。<br>");
                continue;
            }

            Map<String, Object> checkResultMap = IdentityUtil.checkEnter(qymc, shxydm, zzjgdm, gszch, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            boolean checkResult = (Boolean) checkResultMap.get("result");
            if (!checkResult) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " ： <br>");
                message.append((String) checkResultMap.get("errorMsg"));
                continue;
            } else {
                enter.setId(UUID.randomUUID().toString());
                enter.setQymc(qymc);
                enter.setZzjgdm(StringUtils.trim(zzjgdm));
                enter.setGszch(StringUtils.trim(gszch));
                enter.setBjbh(StringUtils.trim(bjbh));
                enter.setShxydm(StringUtils.trim(shxydm));
            }

            boolean isExistInEnterList = CreditCheckUtils.isExistInEnterList(enter, enterpriseList);
            if (isExistInEnterList) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + nowRowNum + " ：该企业已存在。<br>");
                continue;
            }

            creditCheckDao.fillEnterprise(enter);

            enterpriseList.add(enter);
            size++;
        }
        return size;
    }

    @Override
    public String addApplication(HttpServletRequest request, String bjbh, String departentId, String userId, String scxxl, String scmc,
                                 Date scsjs, Date scsjz, List<EnterpriseExamine> enterpriseList,
                                 String[] uploadFileName, String[] uploadFilePath) {
        Date date = new Date();
        CreditExamine creditExamine = new CreditExamine();
        creditExamine.setScxqbm(new SysDepartment(departentId));
        creditExamine.setCreateUser(new SysUser(userId));
        creditExamine.setScxxl(scxxl);
        creditExamine.setScmc(scmc);
        creditExamine.setScsm("信用中心申请");
        creditExamine.setStatus(StatusEnmu.待审核.getKey());
        creditExamine.setBjbh(bjbh);
        creditExamine.setApplyDate(date);
        creditExamine.setScsjs(scsjs);
        creditExamine.setScsjz(scsjz);
        creditCheckDao.save(creditExamine);

        //  保存审核附件
        if (uploadFileName != null && uploadFilePath != null) {
            creditCommonDao.saveUploadFiles(uploadFileName, uploadFilePath, UploadFileEnmu.企业信用审查申请附件, userId, creditExamine.getId());
        }

        // 添加历史表记录
        CreditExamineHis creditExamineHis = new CreditExamineHis();
        creditExamineHis.setOpinion("信用中心申请");
        creditExamineHis.setStatus(StatusEnmu.审核通过.getKey());
        creditExamineHis.setAuditDate(date);
        creditExamineHis.setAuditUser(new SysUser(userId));
        creditExamineHis.setCreditExamine(new CreditExamine(creditExamine.getId()));
        creditCheckDao.save(creditExamineHis);

        for (EnterpriseExamine enter : enterpriseList) {
            enter.setCreditExamine(new CreditExamine(creditExamine.getId()));
            creditCheckDao.save(enter);
        }

        // 生成审查报告
        String filePath = this.createCreditReport(request, creditExamine.getId()); // 生成审查报告,获得报告存放路径
        this.saveFilePath(creditExamine.getId(), "法人信用审查报告.doc", filePath, userId);

        return creditExamine.getId();
    }

    @Override
    public String createCreditReport(HttpServletRequest request, String id) {
        // 已发起信用修复申请但尚未处理完成  (黑色斜体加删除线)
        StyleText styleText_xyxf = new StyleText();
        styleText_xyxf.setColor("000000");
        styleText_xyxf.setItalic(true);
        styleText_xyxf.setDeleteLine(true);

        // 已发起异议申诉申请但尚未处理完成  (黑色粗斜体)
        StyleText styleText_yyss = new StyleText();
        styleText_yyss.setColor("000000");
        styleText_yyss.setItalic(true);
        styleText_yyss.setBold(true);

        Map<String, Object> params = new HashMap<>();
        Map<String, Object> listParams = new HashMap<>();
        List<Map<String, Object>> enterMsgList = new ArrayList<>();
        CreditExamine credtitExamine = creditCheckDao.get(CreditExamine.class, id); // 获取信用审查详情
        String bjbh = credtitExamine.getBjbh();

        SimpleDateFormat sf = new SimpleDateFormat("yyyy年MM月");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
        String date = new SimpleDateFormat("yyyy年MM月dd日").format(new Date());

        String[] scxxlIdStrArr = StringUtils.split(credtitExamine.getScxxl(), ",");
        String scxxl = "";
        for (String scxxlId : scxxlIdStrArr) {
            Theme theme = creditCheckDao.get(Theme.class, scxxlId); // 获取资源名称
            if (theme == null)
                continue;
            scxxl += theme.getTypeName() + ",";
        }
        scxxl = StringUtils.substringBeforeLast(scxxl, ",");

        String scsjs = sf.format(credtitExamine.getScsjs());
        String scsjz = sf.format(credtitExamine.getScsjz());

        CreditTemplate creditTemplate = creditTemplateService.getDefaultByCategoryAndUseType(DZThemeEnum.法人.getKey(), DZThemeEnum.模板用途_信用审查.getKey());

        // 获取默认模板的详细信息
        List<TemplateThemeNode> themeInfo;
        if (creditTemplate != null) {
            themeInfo = creditTemplateService.getTemplateInfo(creditTemplate.getId(), DZThemeEnum.资源用途_法人信用审查.getKey());

            // 添加模板配置信息
            params.put("bgbt", creditTemplate.getTitle()); // 报告标题
            params.put("bgcc", creditTemplate.getReportSource()); // 报告出处
            params.put("sjly", creditTemplate.getDataFrom()); // 数据来源
            params.put("lxdz", creditTemplate.getAddress()); // 联系地址
            params.put("lxdh", creditTemplate.getContactPhone()); // 联系电话

            // 开始结束时间
            String beginDate = sdf.format(credtitExamine.getScsjs());
            String endDate = sdf.format(credtitExamine.getScsjz());

            List<EnterpriseExamine> enterpriseExamineList = creditCheckDao.getEnterList(id);
            List<Map<String, Object>> existList = new ArrayList<>();
            List<Map<String, Object>> unExistList = new ArrayList<>();
            List<Map<String, Object>> allList = new ArrayList<>();
            int existIndex = 0;
            int unExistIndex = 0;
            int allIndex = 0;
            for (EnterpriseExamine enterExamine : enterpriseExamineList) {
                boolean res = creditCheckDao.isEnterpriseExisted(enterExamine.getQymc(), enterExamine.getZzjgdm(),
                        enterExamine.getGszch(), enterExamine.getShxydm());
                if (res) {
                    Map<String, Object> existMap = new HashMap<>();
                    existMap.put("编号", ++existIndex);
                    existMap.put("企业名称", enterExamine.getQymc());
                    existMap.put("工商注册号", enterExamine.getGszch());
                    existMap.put("组织机构代码", enterExamine.getZzjgdm());
                    existMap.put("统一社会信用代码", enterExamine.getShxydm());
                    existList.add(existMap);
                } else {
                    Map<String, Object> unExistMap = new HashMap<>();
                    unExistMap.put("编号", ++unExistIndex);
                    unExistMap.put("企业名称", enterExamine.getQymc());
                    unExistMap.put("工商注册号", enterExamine.getGszch());
                    unExistMap.put("组织机构代码", enterExamine.getZzjgdm());
                    unExistMap.put("统一社会信用代码", enterExamine.getShxydm());
                    unExistList.add(unExistMap);
                }

                Map<String, Object> enterMap = new HashMap<>();
                enterMap.put("编号", ++allIndex);
                enterMap.put("企业名称", enterExamine.getQymc());
                enterMap.put("工商注册号", enterExamine.getGszch());
                enterMap.put("组织机构代码", enterExamine.getZzjgdm());
                enterMap.put("统一社会信用代码", enterExamine.getShxydm());
                allList.add(enterMap);
            }

            listParams.put("2", existList);
            listParams.put("3", unExistList);
            listParams.put("4", allList);

            params.put("allCnt", allList.size()); // 全部审查法人数量
            params.put("existCnt", existList.size()); // 审查到信息的法人数量
            params.put("unExistCnt", unExistList.size()); // 未审查到信息的法人数量
            int noMsgCnt = 0;
            for (Map<String, Object> existEnter : existList) {
                Map<String, Object> enterMsgMap = new HashMap<>();
                List<Map<String, Object>> checkDetailList = new ArrayList<>();
                StringBuilder scxxlRes = new StringBuilder();
                for (TemplateThemeNode templateThemeNode : themeInfo) {
                    Map<String, Object> checkDetailMap = new HashMap<>();

                    int cnt_oneTitle = 0; // 每个信息审查类的数量

                    List<Map<String, Object>> checkDetail_oneList = new ArrayList<>();

                    for (TemplateThemeNode two : templateThemeNode.getChildren()) {
                        Map<String, Object> checkDetail_oneMap = new HashMap<>();

                        List<Map<String, Object>> checkDetail_twoList = new ArrayList<>();

                        List<TemplateThemeColumn> tableCol = two.getColumns();
                        Map<String, Object> checkDetail_twoMap = new HashMap<>();

                        Map<String, Object> headMap = new LinkedHashMap<>();// 获取表头
                        headMap.put("No", "编号");
                        for (TemplateThemeColumn column : tableCol) {
                            headMap.put(column.getColumnName(), column.getColumnAlias());
                        }

                        List<Map<String, Object>> valueList = creditCheckDao.findScxxMsg(bjbh, existEnter, two, beginDate, endDate);
                        cnt_oneTitle += valueList.size();

                        if (valueList.size() == 0) {
                            continue;
                        }
                        // 信用修复、异议处理的数据在审查报告特殊标记
                        int i = 1;
                        for (Map<String, Object> valueMap : valueList) {
                            valueMap.put("No", i++);
                            String dataId = MapUtils.getString(valueMap, "ID", "");
                            // 获取异议申诉已提交申请尚未处理完成的数据
                            List<Map<String, Object>> dataList_yyss = creditCommonDao.getEnterCreditData(dataId, "1");
                            if (dataList_yyss != null && dataList_yyss.size() > 0) {
                                valueMap.put("styleText", styleText_yyss);
                            }

                            // 获取信用修复已提交申请尚未处理完成的数据
                            List<Map<String, Object>> dataList_xyxf = creditCommonDao.getEnterCreditData(dataId, "2");
                            if (dataList_xyxf != null && dataList_xyxf.size() > 0) {
                                valueMap.put("styleText", styleText_xyxf);
                            }
                        }

                        checkDetail_twoMap.put("headMap", headMap);
                        checkDetail_twoMap.put("valueList", valueList);
                        checkDetail_twoList.add(checkDetail_twoMap);
                        checkDetail_oneMap.put("title_two", two.getText());
                        checkDetail_oneMap.put("checkDetail_twoList", checkDetail_twoList);
                        checkDetail_oneList.add(checkDetail_oneMap);
                    }
                    if (cnt_oneTitle > 0) {
                        scxxlRes.append(templateThemeNode.getText()).append(cnt_oneTitle).append("条\n");
                    }

                    if (checkDetail_oneList.size() == 0) {
                        continue;
                    }
                    checkDetailMap.put("title_one", templateThemeNode.getText());
                    checkDetailMap.put("checkDetail_oneList", checkDetail_oneList);
                    checkDetailList.add(checkDetailMap);
                }
                scxxlRes = new StringBuilder(StringUtils.substringBeforeLast(scxxlRes.toString(), "\n"));
                if (StringUtils.isBlank(scxxlRes.toString())) {
                    existEnter.put("审查信息结果", "");
                } else {
                    existEnter.put("审查信息结果", scxxlRes.toString());
                    noMsgCnt++;
                }

                if (checkDetailList.size() == 0) {
                    continue;
                }
                enterMsgMap.put("name", MapUtils.getString(existEnter, "企业名称", ""));
                enterMsgMap.put("checkDetailList", checkDetailList);
                enterMsgList.add(enterMsgMap);
            }
            params.put("noMsgCnt", noMsgCnt); // 未找到审核信息记录的企业
        }

        params.put("bgbh", credtitExamine.getBjbh()); // 报告编号
        params.put("scmc", credtitExamine.getScmc()); // 审查名称
        String deptId = credtitExamine.getScxqbm().getId();
        SysDepartment dept = creditCheckDao.get(SysDepartment.class, deptId);
        params.put("scbm", dept.getDepartmentName()); // 审查部门
        params.put("sclb", scxxl); // 审查类别
        params.put("date", date); // 报告日期
        params.put("scsjs", scsjs); // 审查时间始
        params.put("scsjz", scsjz); // 审查时间止

        // 文末添加备注
        StyleText styleText_lastText = new StyleText();
        styleText_lastText.setBold(true);
        styleText_lastText.setFontSize(11);
        styleText_lastText.setFontFamily("宋体");

        List<Map<String, Object>> styleTextList = new ArrayList<>();
        Map<String, Object> styleTextMap = new HashMap<>();
        styleTextMap.put("text", "注：");
        styleTextMap.put("styleText", styleText_lastText);

        Map<String, Object> styleTextMap2 = new HashMap<>();
        styleTextMap2.put("text", " 1、黑色斜体加删除线的数据，表示该信用数据已发起信用修复申请但尚未处理完成。");
        styleTextMap2.put("styleText", styleText_lastText);

        Map<String, Object> styleTextMap3 = new HashMap<>();
        styleTextMap3.put("text", " 2、黑色粗斜体的数据，表示该信用数据已发起异议申诉申请但尚未处理完成。");
        styleTextMap3.put("styleText", styleText_lastText);
        styleTextList.add(styleTextMap);
        styleTextList.add(styleTextMap2);
        styleTextList.add(styleTextMap3);

        SimpleDateFormat sdfa = new SimpleDateFormat("yyyyMMddHHmmss");
        String time = sdfa.format(new Date());

        String folderPath = PropUtil.get("credit.report.path");
        File file = new File(folderPath);
        if (!file.exists()) {
            file.mkdirs();
        }
        String preFilePath = folderPath + credtitExamine.getBjbh() + "_" + time + ".docx";
        String templatePath = "/template/法人审查报告模板.docx";
        try {
            CreateWordByTempUtils.createWordByTemplate(request.getSession().getServletContext().getRealPath(templatePath),
                    preFilePath, params, listParams, enterMsgList, styleTextList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return preFilePath;
    }

    /**
     * 信用中心法人信用审查上传后保存红头文件
     *
     * @param id
     * @param bz
     * @param uploadFileName
     * @param uploadFilePath
     * @param userId
     */
    public void submitCheckReport(String id, String bz, String uploadFileName, String uploadFilePath, String userId) {
        CreditExamine creditExamine = creditCheckDao.get(CreditExamine.class, id);
        CreditExamineHis creditExamineHis = creditCheckDao.findCreditExamineHisByCreditExamineId(id);
        // 更新主表信息
        creditExamine.setStatus(StatusEnmu.审核通过.getKey());
        creditCheckDao.update(creditExamine);
        // 更新历史表记录
        creditExamineHis.setOpinion(bz);
        creditCheckDao.update(creditExamineHis);

        //  保存红头文件
        if (StringUtils.isNotBlank(uploadFileName) && StringUtils.isNotBlank(uploadFilePath)) {
            String[] names = new String[]{uploadFileName};
            String[] paths = new String[]{uploadFilePath};
            creditCommonDao.saveUploadFiles(names, paths, UploadFileEnmu.企业信用审查审核上传附件, userId, id);
        }
    }

    @Override
    public CreditExamine addApplication(HttpServletRequest request, String bjbh, String departentId, String userId, String scxxl, String scmc,
                                        String scsm, Date scsjs, Date scsjz, String[] file_name, String[] file_path, List<EnterpriseExamine> enterpriseList) {
        CreditExamine creditExamine = new CreditExamine();
        creditExamine.setScxqbm(new SysDepartment(departentId));
        creditExamine.setCreateUser(new SysUser(userId));
        creditExamine.setScxxl(scxxl);
        creditExamine.setScmc(scmc);
        creditExamine.setScsm(scsm);
        creditExamine.setStatus(StatusEnmu.待审核.getKey());
        creditExamine.setBjbh(bjbh);
        creditExamine.setApplyDate(new Date());
        creditExamine.setScsjs(scsjs);
        creditExamine.setScsjz(scsjz);
        creditCheckDao.save(creditExamine);

        for (EnterpriseExamine enter : enterpriseList) {
            enter.setCreditExamine(new CreditExamine(creditExamine.getId()));
            creditCheckDao.save(enter);
        }

        creditCommonDao.saveUploadFiles(file_name, file_path, UploadFileEnmu.企业信用审查申请附件, userId, creditExamine.getId());
        // 生成审查报告
        String filePath = this.createCreditReport(request, creditExamine.getId()); // 生成审查报告,获得报告存放路径
        this.saveFilePath(creditExamine.getId(), "法人信用审查报告.doc", filePath, userId);

        return creditExamine;
    }

    @Override
    public Pageable<CreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs,
                                                  String sqsjz, String userId, String status) {
        return creditCheckDao.findCreditExamineCondition(page, scmc, xqbm, bjbh, sqsjs, sqsjz, userId, status);
    }

    @Override
    public Map<String, Object> getBarPieData(String deptId) {
        Map<String, Object> resMap = new HashMap<String, Object>(); // bar和pie的数据集合
        SimpleDateFormat fmtZH = new SimpleDateFormat(DATEFORMAT_YYYYMM);
        SimpleDateFormat fmt = new SimpleDateFormat(DATEFORMAT_YYYY_MM);
        String[] monthArr4X = new String[6]; // 最近6个月的月份for X轴
        String[] cnt4Bar = new String[6]; // 最近6个月的月份的申请量
        String[] cnt4Pie = new String[] {"0", "0", "0"}; // 饼图 数据 (0待审核,1已通过,2未通过)
        Date nowDate = DateUtils.addMonths(new Date(), -5); // 6个月前
        for (int i = 0; i < 6; i++) {
            Date date = DateUtils.addMonths(nowDate, i);
            String month = fmt.format(date);
            cnt4Bar[i] = creditCheckDao.findCountByMonth4Bar(month, deptId);
            monthArr4X[i] = fmtZH.format(date);
        }

        List<Map<String, Object>> statusMapList = creditCheckDao.findCountByMonth4Pie(deptId);
        for (Map<String, Object> statusMap : statusMapList) {
            String status = statusMap.get("STATUS").toString();
            String cnt = statusMap.get("CNT").toString();
            if (StringUtils.equals(status, "0")) {
                cnt4Pie[0] = cnt;
            } else if (StringUtils.equals(status, "1")) {
                cnt4Pie[1] = cnt;
            } else {
                cnt4Pie[2] = cnt;
            }
        }

        resMap.put("barDataX", monthArr4X); // 柱图横轴类别
        resMap.put("barDataY", cnt4Bar); // 柱图类别数据
        resMap.put("pieData", cnt4Pie); // 饼图 数据 (idx: 0 待审核,1已通过,2未通过)
        return resMap;
    }

}
