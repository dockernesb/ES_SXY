package com.udatech.sszj.service;

import com.udatech.sszj.model.*;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysUser;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

/**
 * @author dwc
 * @Title: SszjService
 * @ProjectName creditservice
 * @Description: TODO
 * @date 2018/12/10  18:16
 */
public interface SszjService {
    /**
     *涉审中介基本信息保存
     * @param sszjJbxx
     */
    void saveSjzjJbxx(SszjJbxx sszjJbxx);

    /**
     * 获取涉审中介基本信息列表数据
     * @return
     */
    List<SszjJbxx> getSszjJbxxList();

    Pageable<Map<String, Object>> getSszjJbxxList(Page page, SszjJbxx sszjJbxx);

    void templateDownload(HttpServletResponse response, HttpServletRequest request) throws Exception;

    void templateDownloadZyzz(HttpServletResponse response, HttpServletRequest request) throws Exception;

    void templateDownloadZyry(HttpServletResponse response, HttpServletRequest request) throws Exception;

    int batchAdd(Workbook wb, StringBuffer message);

    void zyryAddData(SszjZyry sszjZyry);

    void pjdjAddData(SszjPjdj sszjPjdj);

    void xycnAddData(SszjCreditCommitmentQy sszjCreditCommitmentQy,UploadFile uploadFile);

    void zyzzAddData(SszjZyzz sszjZyzz);

    Pageable<Map<String, Object>> getSszjZyzzList(Page page, SszjZyzz sszjZyzz);
    Pageable<Map<String, Object>> getSszjZyryList(Page page, SszjZyry sszjZyry);
    Pageable<Map<String, Object>> getSszjPjdjList(Page page, SszjPjdj sszjPjdj);
    Pageable<Map<String, Object>> getSszjXycnList(Page page, SszjCreditCommitmentQy sszjCreditCommitmentQy);

    int batchAddZyzz(Workbook wb, StringBuffer message,String tyshxydm) throws ParseException;

    List<YwLZzDjbg> findYwLZzDjbgByJgmc(String jgmc);

    void copyToZyzz(List<YwLZzDjbg> ywLZzDjbgList,String tyshxydm);

    int batchAddZyry(Workbook wb, StringBuffer message,String tyshxydm) throws ParseException;

    void saveXycnFileInfo(UploadFile file);

    SysUser findUserById(String userId);

    void deleteFileInfo(UploadFile file);

    void saveJbxxFileInfo(UploadFile file);

    void deleteJbxxFileInfo(UploadFile file);

    void updateSjzjJbxx(SszjJbxx sszjJbxx);
}
