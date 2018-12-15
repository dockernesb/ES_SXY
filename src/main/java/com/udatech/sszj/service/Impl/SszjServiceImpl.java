package com.udatech.sszj.service.Impl;

import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.Promise;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.FileUtils;
import com.udatech.common.util.PropUtil;
import com.udatech.sszj.constant.SszjConstants;
import com.udatech.sszj.constant.SszjZyryConstants;
import com.udatech.sszj.constant.SszjZyzzConstants;
import com.udatech.sszj.dao.SszjDao;
import com.udatech.sszj.model.*;
import com.udatech.sszj.service.SszjService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.QueryCondition;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author dwc
 * @Title: SszjServiceImpl
 * @ProjectName creditservice
 * @Description: TODO
 * @date 2018/12/10  18:16
 */
@Service
public class SszjServiceImpl implements SszjService {

    @Autowired
    private SszjDao sszjDao;

    @Autowired
    private BaseService baseService;

    @Override
    public void saveSjzjJbxx(SszjJbxx sszjJbxx) {
        sszjDao.save(sszjJbxx);
    }

    @Override
    public List<SszjJbxx> getSszjJbxxList() {
        List<SszjJbxx> sszjJbxxList = baseService.findAll(SszjJbxx.class);
        return sszjJbxxList;
    }

    @Override
    public Pageable<Map<String, Object>> getSszjJbxxList(Page page, SszjJbxx sszjJbxx) {
        return sszjDao.getSszjJbxxList(page, sszjJbxx);
    }

    @Override
    public void templateDownload(HttpServletResponse response, HttpServletRequest request) throws Exception {
        String fileName = PropUtil.get("sszjJbxx.file.name");
        String filePath = PropUtil.get("sszjJbxx.file.path");
        // 读到流中
        InputStream inStream = new FileInputStream(request.getSession()
                .getServletContext().getRealPath(filePath)); // 文件的存放路径
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

    @Override
    public void templateDownloadZyzz(HttpServletResponse response, HttpServletRequest request) throws Exception {
        String fileName = PropUtil.get("sszjZyzz.file.name");
        String filePath = PropUtil.get("sszjZyzz.file.path");
        // 读到流中
        InputStream inStream = new FileInputStream(request.getSession()
                .getServletContext().getRealPath(filePath)); // 文件的存放路径
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

    @Override
    public void templateDownloadZyry(HttpServletResponse response, HttpServletRequest request) throws Exception {
        String fileName = PropUtil.get("sszjZyry.file.name");
        String filePath = PropUtil.get("sszjZyry.file.path");
        // 读到流中
        InputStream inStream = new FileInputStream(request.getSession()
                .getServletContext().getRealPath(filePath)); // 文件的存放路径
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
    @Override
    public int batchAdd(Workbook wb, StringBuffer message) {
        String userId=CommonUtil.getCurrentUserId();
        List<SszjJbxx> list = new ArrayList<SszjJbxx>();
        List<SszjJbxx> epList = new ArrayList<SszjJbxx>();
        Row row;
        String jgqc     = "";//机构名称
        String tyshxydm = "";//统一社会信用代码
        String zzjgdm   = "";//组织机构代码
        String sw_jgdm  = "";//税务机构代码
        String frdb_fzr = "";//法人代表（负责人）
        String jydz     = "";//经营地址
        String wz       = "";//网址
        String lxdh     = "";//联系电话
        String dept_id  = "";//部门选择
        String fwsx     = "";//服务时限
        String sfyj     = "";//收费依据
        String sfbz     = "";//收费标准
        String fwxm     = "";//服务项目
        String czlc     = "";//操作流程
        String dysp     = "";//对应审批
        Sheet sheet = wb.getSheetAt(0);
        for (int i = 1; i < sheet.getLastRowNum() + 1; i++) {
            row = sheet.getRow(i);
            if (row == null) {
                continue;
            }

             jgqc     = ExcelUtils.getCell(row.getCell(0));//机构名称
             tyshxydm = ExcelUtils.getCell(row.getCell(1));//统一社会信用代码
             zzjgdm   = ExcelUtils.getCell(row.getCell(2));//组织机构代码
             sw_jgdm  = ExcelUtils.getCell(row.getCell(3));//税务机构代码
             frdb_fzr = ExcelUtils.getCell(row.getCell(4));//法人代表（负责人）
             jydz     = ExcelUtils.getCell(row.getCell(5));//经营地址
             wz       = ExcelUtils.getCell(row.getCell(6));//网址
             lxdh     = ExcelUtils.getCell(row.getCell(7));//联系电话
             dept_id  = ExcelUtils.getCell(row.getCell(8));//部门选择
             fwsx     = ExcelUtils.getCell(row.getCell(9));//服务时限
             sfyj     = ExcelUtils.getCell(row.getCell(10));//收费依据
             sfbz     = ExcelUtils.getCell(row.getCell(11));//收费标准
             fwxm     = ExcelUtils.getCell(row.getCell(12));//服务项目
             czlc     = ExcelUtils.getCell(row.getCell(13));//操作流程
             dysp     = ExcelUtils.getCell(row.getCell(14));//对应审批

            if (   StringUtils.isBlank(jgqc) && StringUtils.isBlank(tyshxydm)
                && StringUtils.isBlank(zzjgdm) && StringUtils.isBlank(sw_jgdm)
                && StringUtils.isBlank(frdb_fzr) && StringUtils.isBlank(jydz)
                && StringUtils.isBlank(wz) && StringUtils.isBlank(lxdh)
                && StringUtils.isBlank(dept_id) && StringUtils.isBlank(fwsx)
                && StringUtils.isBlank(sfyj) && StringUtils.isBlank(sfbz)
                && StringUtils.isBlank(fwxm) && StringUtils.isBlank(czlc) && StringUtils.isBlank(dysp)
            ) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1)
                        + " : 没有数据 , 跳过解析<br>");
                continue;
            }

            SszjJbxx sszjJbxx = new SszjJbxx();
            sszjJbxx.setCreateTime(new Date());
            sszjJbxx.setCreateId(userId);

            if (StringUtils.isBlank(jgqc)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.JGQC + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setJgqc(jgqc);
            }

            if (StringUtils.isBlank(tyshxydm)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.TYSHXYDM + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setTyshxydm(tyshxydm);
            }

            if (StringUtils.isBlank(zzjgdm)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.ZZJGDM + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setZzjgdm(zzjgdm);
            }

            if (StringUtils.isBlank(sw_jgdm)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.SW_JGDM + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setSwJgdm(sw_jgdm);
            }

            if (StringUtils.isBlank(frdb_fzr)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.FRDB_FZR + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setFrdbFzr(frdb_fzr);
            }

            if (StringUtils.isBlank(jydz)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.JYDZ + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setJydz(jydz);
            }

            if (StringUtils.isBlank(wz)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.WZ + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setWz(wz);
            }

            if (StringUtils.isBlank(lxdh)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.LXDH + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setLxdh(lxdh);
            }

            if (StringUtils.isBlank(dept_id)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.DEPT_ID + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setDeptId(dept_id);
            }

            if (StringUtils.isBlank(fwsx)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.FWSX + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setFwsx(fwsx);
            }

            if (StringUtils.isBlank(sfyj)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.SFYJ + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setSfyj(sfyj);
            }

            if (StringUtils.isBlank(sfbz)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.SFBZ + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setSfbz(sfbz);
            }

            if (StringUtils.isBlank(fwxm)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.FWXM + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setFwxm(fwxm);
            }

            if (StringUtils.isBlank(czlc)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.CZLC + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setCzlc(czlc);
            }

            if (StringUtils.isBlank(dysp)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.DYSP + "」不能为空 <br>");
                continue;
            } else {
                sszjJbxx.setDysp(dysp);
            }

            // 检验该条数据数据库是否已存在
            boolean isRepeat = checkIsExist(jgqc);
            if (isRepeat) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjConstants.JGQC + " : "+ jgqc + "」已存在 <br>");
                continue;
            }

//            if (powerCode.length() > 25) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_CODE + "」长度不能超过25 <br>");
//                continue;
//            }
//
//            if (powerName.length() > 50) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_NAME + "」长度不能超过50 <br>");
//                continue;
//            }
//
//            if (according.length() > 2000) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_ACCORDING + "」长度不能超过2000 <br>");
//                continue;
//            }

            // 设置行号
            sszjJbxx.setRowIndex(i + 1);
            list.add(sszjJbxx);
        }

        for (int i = 0;i < list.size();i++) {
            boolean isRepeat = false;
            StringBuffer sb = new StringBuffer("&nbsp;&nbsp;&nbsp;&nbsp;行 " + list.get(i).getRowIndex());
            for (int j = 0;j < list.size();j++) {
                if (i != j) {
                    if (StringUtils.equals(list.get(i).getJgqc(), list.get(j).getJgqc())) {
                        isRepeat = true;
                        sb.append("、行"+list.get(j).getRowIndex());
                        continue;
                    }
                }
            }

            sb.append(" :「"+ SszjConstants.JGQC + "」重复 <br>");

            if (!isRepeat) {
                epList.add(list.get(i));
            } else {
                message.append(sb);
            }

        }

        sszjDao.saveAll(epList);
        return epList.size();
    }

    @Override
    public void zyryAddData(SszjZyry sszjZyry) {
        sszjDao.save(sszjZyry);
    }

    @Override
    public void pjdjAddData(SszjPjdj sszjPjdj) {
        sszjDao.save(sszjPjdj);
    }

    @Override
    @Transactional
    public void xycnAddData(SszjCreditCommitmentQy sszjCreditCommitmentQy,UploadFile uploadFile) {
        String id=UUID.randomUUID().toString();
        sszjCreditCommitmentQy.setId(id);
        sszjDao.save(sszjCreditCommitmentQy);
        uploadFile.setBusinessId(id);
        if(uploadFile.getFilePath()!=null && StringUtils.isNotBlank(uploadFile.getFilePath())){
            sszjDao.save(uploadFile);
        }

    }

    @Override
    public void zyzzAddData(SszjZyzz sszjZyzz) {
        sszjDao.save(sszjZyzz);
    }

    @Override
    public Pageable<Map<String, Object>> getSszjZyzzList(Page page, SszjZyzz sszjZyzz) {
        return sszjDao.getSszjZyzzList(page, sszjZyzz);
    }

    @Override
    public Pageable<Map<String, Object>> getSszjZyryList(Page page, SszjZyry sszjZyry) {
        return sszjDao.getSszjZyryList(page, sszjZyry);
    }

    @Override
    public Pageable<Map<String, Object>> getSszjPjdjList(Page page, SszjPjdj sszjPjdj) {
        return sszjDao.getSszjPjdjList(page, sszjPjdj);
    }

    @Override
    public Pageable<Map<String, Object>> getSszjXycnList(Page page, SszjCreditCommitmentQy sszjCreditCommitmentQy) {
        Pageable<Map<String, Object>> pageable= sszjDao.getSszjXycnList(page, sszjCreditCommitmentQy);
        this.getFileInfo(pageable.getList());
        return pageable;
    }

    private void getFileInfo(List<Map<String, Object>> list) {
        if (list != null && !list.isEmpty()) {
            Iterator i$ = list.iterator();

            while(i$.hasNext()) {
                Map<String, Object> map = (Map)i$.next();
                String id = (String)map.get("ID");
                if (StringUtils.isNotBlank(id)) {
                    List<UploadFile> files = this.sszjDao.getUploadFiles(id, UploadFileEnmu.信用承诺附件);
                    if (files != null && !files.isEmpty()) {
                        map.put("CN_FILE", files.get(0));
                    }
                }

                String time = (String)map.get("GSJZQ");
                if (StringUtils.isNotBlank(time)) {
                    String current = DateUtils.format(new Date(), "yyyy-MM-dd");
                    if (current.compareTo(time) >= 0) {
                        map.put("STATUS", 2);
                    }
                }
            }
        }
    }

    private boolean checkIsExist(String jgqc) {
        List<SszjJbxx> sszjJbxxList=sszjDao.find(SszjJbxx.class,QueryCondition.eq("jgqc",jgqc));
        if(sszjJbxxList.isEmpty()){
            return false;
        }else{
            return true;
        }
    }

    private boolean checkIsExistZyzz(String zz_zsbh) {
        List<SszjZyzz> sszjZyzzList=sszjDao.find(SszjZyzz.class,QueryCondition.eq("zzZsbh",zz_zsbh));
        if(sszjZyzzList.isEmpty()){
            return false;
        }else{
            return true;
        }
    }

    private boolean checkIsExistZyry(String zz_zsbh) {
        List<SszjZyry> sszjZyryList=sszjDao.find(SszjZyry.class,QueryCondition.eq("zzZsbh",zz_zsbh));
        if(sszjZyryList.isEmpty()){
            return false;
        }else{
            return true;
        }
    }

    @Override
    public int batchAddZyzz(Workbook wb, StringBuffer message,String tyshxydm) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String userId=CommonUtil.getCurrentUserId();
        List<SszjZyzz> list = new ArrayList<SszjZyzz>();
        List<SszjZyzz> epList = new ArrayList<SszjZyzz>();
        Row row;
        String zz_zsmc      = "";//资质证书名称
        String zz_zsbh      = "";//资质证书编号
        String zz_dj        = "";//资质等级
        String xknr         = "";//资质许可内容
        String zzsxq_time   = "";//资质生效期
        String zzjzq_time   = "";//资质截止期
        Sheet sheet = wb.getSheetAt(0);
        for (int i = 1; i < sheet.getLastRowNum() + 1; i++) {
            row = sheet.getRow(i);
            if (row == null) {
                continue;
            }

            zz_zsmc     = ExcelUtils.getCell(row.getCell(0));//资质证书名称
            zz_zsbh = ExcelUtils.getCell(row.getCell(1));//资质证书编号
            zz_dj   = ExcelUtils.getCell(row.getCell(2));//资质等级
            xknr  = ExcelUtils.getCell(row.getCell(3));//资质许可内容
            zzsxq_time = ExcelUtils.getCell(row.getCell(4));//资质生效期
            zzjzq_time     = ExcelUtils.getCell(row.getCell(5));//资质截止期

            if (   StringUtils.isBlank(zz_zsmc) && StringUtils.isBlank(zz_zsbh)
                    && StringUtils.isBlank(zz_dj) && StringUtils.isBlank(xknr)
                    && StringUtils.isBlank(zzsxq_time) && StringUtils.isBlank(zzjzq_time)
            ) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1)
                        + " : 没有数据 , 跳过解析<br>");
                continue;
            }

            SszjZyzz sszjZyzz = new SszjZyzz();
            sszjZyzz.setCreateTime(new Date());
            sszjZyzz.setCreateId(userId);

            if (StringUtils.isBlank(zz_zsmc)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyzzConstants.ZZ_ZSMC + "」不能为空 <br>");
                continue;
            } else {
                sszjZyzz.setZzZsmc(zz_zsmc);
            }

            if (StringUtils.isBlank(zz_zsbh)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyzzConstants.ZZ_ZSBH + "」不能为空 <br>");
                continue;
            } else {
                sszjZyzz.setZzZsbh(zz_zsbh);
            }

            if (StringUtils.isBlank(zz_dj)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyzzConstants.ZZ_DJ + "」不能为空 <br>");
                continue;
            } else {
                sszjZyzz.setZzDj(zz_dj);
            }

            if (StringUtils.isBlank(xknr)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyzzConstants.XKNR + "」不能为空 <br>");
                continue;
            } else {
                sszjZyzz.setXknr(xknr);
            }

            if (StringUtils.isBlank(zzsxq_time)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyzzConstants.ZZSXQ_TIME + "」不能为空 <br>");
                continue;
            } else {
                sszjZyzz.setZzsxqTime(sdf.parse(zzsxq_time));
            }

            if (StringUtils.isBlank(zzjzq_time)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyzzConstants.ZZJZQ_TIME + "」不能为空 <br>");
                continue;
            } else {
                sszjZyzz.setZzjzqTime(sdf.parse(zzjzq_time));
            }


            // 根据资质证书编号 检验该条数据数据库是否已存在
            boolean isRepeat = checkIsExistZyzz(zz_zsbh);
            if (isRepeat) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyzzConstants.ZZ_ZSBH + " : "+ zz_zsbh + "」已存在 <br>");
                continue;
            }

//            if (powerCode.length() > 25) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_CODE + "」长度不能超过25 <br>");
//                continue;
//            }
//
//            if (powerName.length() > 50) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_NAME + "」长度不能超过50 <br>");
//                continue;
//            }
//
//            if (according.length() > 2000) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_ACCORDING + "」长度不能超过2000 <br>");
//                continue;
//            }

            // 设置行号
            sszjZyzz.setRowIndex(i + 1);
            sszjZyzz.setTyshxydm(tyshxydm);
            sszjZyzz.setState("1");
            list.add(sszjZyzz);
        }

        for (int i = 0;i < list.size();i++) {
            boolean isRepeat = false;
            StringBuffer sb = new StringBuffer("&nbsp;&nbsp;&nbsp;&nbsp;行 " + list.get(i).getRowIndex());
            for (int j = 0;j < list.size();j++) {
                if (i != j) {
                    if (StringUtils.equals(list.get(i).getZzZsbh(), list.get(j).getZzZsbh())) {
                        isRepeat = true;
                        sb.append("、行"+list.get(j).getRowIndex());
                        continue;
                    }
                }
            }
            sb.append(" :「"+ SszjZyzzConstants.ZZ_ZSBH + "」重复 <br>");
            if (!isRepeat) {
                epList.add(list.get(i));
            } else {
                message.append(sb);
            }
        }
        sszjDao.saveAll(epList);
        return epList.size();
    }

    @Override
    public List<YwLZzDjbg> findYwLZzDjbgByJgmc(String jgmc) {
        List<YwLZzDjbg> sszjZyzzList=sszjDao.find(YwLZzDjbg.class,QueryCondition.eq("jgqc",jgmc));
        return sszjZyzzList;
    }

    @Override
    public void copyToZyzz(List<YwLZzDjbg> ywLZzDjbgList,String tyshxydm) {
        List<SszjZyzz> list=new ArrayList<SszjZyzz>();

        for(YwLZzDjbg ywLZzDjbg:ywLZzDjbgList){
            SszjZyzz sszjZyzz= new SszjZyzz();
            sszjZyzz.setState("0");
            sszjZyzz.setTyshxydm(tyshxydm);
            sszjZyzz.setCreateId(CommonUtil.getCurrentUserId());
            sszjZyzz.setCreateTime(new Date());
            sszjZyzz.setZzZsmc(ywLZzDjbg.getZzmc());
            sszjZyzz.setZzZsbh(ywLZzDjbg.getZsbh());
            sszjZyzz.setZzDj(ywLZzDjbg.getZzdj());
            list.add(sszjZyzz);
        }
        sszjDao.copyToZyzz(list);
    }

    @Override
    public int batchAddZyry(Workbook wb, StringBuffer message,String tyshxydm) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String userId=CommonUtil.getCurrentUserId();
        List<SszjZyry> list = new ArrayList<SszjZyry>();
        List<SszjZyry> epList = new ArrayList<SszjZyry>();
        Row row;
        String xm        = "";//姓名
        String sfzh      = "";//身份证号
        String zz_zsmc   = "";//资质证书名称
        String zz_zsbh   = "";//资质证书编号
        String zz_dj     = "";//资质等级

        Sheet sheet = wb.getSheetAt(0);
        for (int i = 1; i < sheet.getLastRowNum() + 1; i++) {
            row = sheet.getRow(i);
            if (row == null) {
                continue;
            }

            xm        = ExcelUtils.getCell(row.getCell(0));//姓名
            sfzh      = ExcelUtils.getCell(row.getCell(1));//身份证号
            zz_zsmc   = ExcelUtils.getCell(row.getCell(2));//资质证书名称
            zz_zsbh   = ExcelUtils.getCell(row.getCell(3));//资质证书编号
            zz_dj = ExcelUtils.getCell(row.getCell(4));//资质等级

            if (   StringUtils.isBlank(xm) && StringUtils.isBlank(sfzh)
                    && StringUtils.isBlank(zz_zsmc) && StringUtils.isBlank(zz_zsbh)
                    && StringUtils.isBlank(zz_dj)
            ) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1)
                        + " : 没有数据 , 跳过解析<br>");
                continue;
            }

            SszjZyry sszjZyry = new SszjZyry();
            sszjZyry.setCreateTime(new Date());
            sszjZyry.setCreateId(userId);
            if (StringUtils.isBlank(xm)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyryConstants.XM + "」不能为空 <br>");
                continue;
            } else {
                sszjZyry.setXm(xm);
            }

            if (StringUtils.isBlank(sfzh)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyryConstants.SFZH + "」不能为空 <br>");
                continue;
            } else {
                sszjZyry.setSfzh(sfzh);
            }
            if (StringUtils.isBlank(zz_zsmc)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyryConstants.ZZ_ZSMC + "」不能为空 <br>");
                continue;
            } else {
                sszjZyry.setZzZsmc(zz_zsmc);
            }

            if (StringUtils.isBlank(zz_zsbh)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyryConstants.ZZ_ZSBH + "」不能为空 <br>");
                continue;
            } else {
                sszjZyry.setZzZsbh(zz_zsbh);
            }

            if (StringUtils.isBlank(zz_dj)) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyryConstants.ZZ_DJ + "」不能为空 <br>");
                continue;
            } else {
                sszjZyry.setZzDj(zz_dj);
            }




            // 根据资质证书编号 检验该条数据数据库是否已存在
            boolean isRepeat = checkIsExistZyry(zz_zsbh);
            if (isRepeat) {
                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
                        + SszjZyryConstants.ZZ_ZSBH + " : "+ zz_zsbh + "」已存在 <br>");
                continue;
            }

//            if (powerCode.length() > 25) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_CODE + "」长度不能超过25 <br>");
//                continue;
//            }
//
//            if (powerName.length() > 50) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_NAME + "」长度不能超过50 <br>");
//                continue;
//            }
//
//            if (according.length() > 2000) {
//                message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
//                        + SszjConstants.TITLE_POWER_ACCORDING + "」长度不能超过2000 <br>");
//                continue;
//            }

            // 设置行号
            sszjZyry.setRowIndex(i + 1);
            sszjZyry.setTyshxydm(tyshxydm);
            list.add(sszjZyry);
        }

        for (int i = 0;i < list.size();i++) {
            boolean isRepeat = false;
            StringBuffer sb = new StringBuffer("&nbsp;&nbsp;&nbsp;&nbsp;行 " + list.get(i).getRowIndex());
            for (int j = 0;j < list.size();j++) {
                if (i != j) {
                    if (StringUtils.equals(list.get(i).getZzZsbh(), list.get(j).getZzZsbh())) {
                        isRepeat = true;
                        sb.append("、行"+list.get(j).getRowIndex());
                        continue;
                    }
                }
            }
            sb.append(" :「"+ SszjZyryConstants.ZZ_ZSBH + "」重复 <br>");
            if (!isRepeat) {
                epList.add(list.get(i));
            } else {
                message.append(sb);
            }
        }
        sszjDao.saveAll(epList);
        return epList.size();
    }

    @Transactional
    public void saveXycnFileInfo(UploadFile file) {
        this.sszjDao.save(file);
        Promise p = this.sszjDao.getPromiseById(file.getBusinessId());
//        this.sszjDao.updateTime(p.getCnlbKey(), p.getDeptId());
    }

    /**
     * @category 根据id查询用户
     * @param userId
     * @return
     */
    @Override
    public SysUser findUserById(String userId) {
        SysUser user = sszjDao.get(SysUser.class, userId);
        return user;
    }

    @Transactional
    public void deleteFileInfo(UploadFile file) {
        this.sszjDao.delete(file);
        Promise p = this.sszjDao.getPromiseById(file.getBusinessId());
//        this.sszjDao.updateTime(p.getCnlbKey(), p.getDeptId());
    }

    public void saveJbxxFileInfo(UploadFile file) {
        this.sszjDao.save(file);
    }

    @Override
    public void deleteJbxxFileInfo(UploadFile file) {
        sszjDao.deleteJbxxFileInfo(file);
    }

    @Override
    public void updateSjzjJbxx(SszjJbxx sszjJbxx) {
        sszjDao.update(sszjJbxx);
    }
}
