package com.udatech.common.creditCheck.service;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.model.CreditExamine;
import com.udatech.common.model.CreditExamineHis;
import com.udatech.common.model.EnterpriseExamine;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysUser;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Description: 信用审查Service(中心端)
 * @author: 何斐
 * @date: 2016年11月21日 下午3:53:40
 */
public interface CreditCheckService {

    /**
     * @param sysuserid
     * @return
     * @Title: findUserById
     * @Description: 根据用户id查询该用户信息
     * @return: SysUser
     */
    SysUser findUserById(String sysuserid);

    /**
     * @param page
     * @param scmc
     * @param xqbm
     * @param bjbh
     * @param sqsjs
     * @param sqsjz
     * @param sysuserid
     * @param status
     * @return
     * @Title: queryApplyList
     * @Description: 查询申请列表
     * @return: Pageable<CreditExamine>
     */
    Pageable<CreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs,
                                           String sqsjz, String userId, String status, String type, String bjbm);

    /**
     * @param id
     * @return
     * @Title: findCreditExamineHisByCreditExamineId
     * @Description: 根据Id查询审核记录
     * @return: CreditExamineHis
     */
    CreditExamineHis findCreditExamineHisByCreditExamineId(String id);

    /**
     * @param id
     * @param type
     * @return
     * @Title: findUploadFile
     * @Description: 获取上传文件信息
     * @return: UploadFile
     */
    UploadFile findUploadFile(String id, String type);

    /**
     * @param page
     * @param id
     * @return
     * @Title: getEnterList
     * @Description: 获取企业列表
     * @return: Pageable<EnterpriseExamine>
     */
    Pageable<EnterpriseExamine> getEnterList(Page page, String id);

    String getScxxl(String scxxlIdArr);

    /**
     * @param id
     * @param type
     * @param shyj
     * @param sysuserid
     * @return
     * @Title: aduitExamine
     * @Description: 审核申请
     * @return: boolean
     */
    boolean aduitExamine(String id, String type, String shyj, String sysuserid, String uploadFileName, String uploadFilePath, String userId);

    /**
     * @param businessId
     * @param fileName
     * @param filePath
     * @param createUser
     * @Title: saveFilePath
     * @Description: 保存文件信息
     * @return: void
     */
    UploadFile saveFilePath(String businessId, String fileName, String filePath, String createUser);

    /**
     * @param page
     * @param enterpriseList
     * @return
     * @Title: findEnterByPage
     * @Description: 将企业List分页
     * @return: Pageable<EnterpriseExamine>
     */
    Pageable<EnterpriseExamine> findEnterByPage(Page page, List<EnterpriseExamine> enterpriseList);

    /**
     * @param bjbh
     * @param zzjgdm
     * @param qymc
     * @param gszch
     * @param shxydm
     * @param enterpriseList
     * @param msg
     * @return
     * @Title: addEnter
     * @Description: 手动录入
     * @return: boolean
     */
    boolean addEnter(String bjbh, String zzjgdm, String qymc, String gszch, String shxydm,
                     List<EnterpriseExamine> enterpriseList, JSONObject msg);

    /**
     * @param enterpriseList
     * @param id
     * @Title: reomveEnters
     * @Description: 删除企业
     * @return: void
     */
    void reomveEnters(List<EnterpriseExamine> enterpriseList, String id);

    /**
     * @param wb
     * @param bjbh
     * @param msg
     * @param enterpriseList
     * @return
     * @Title: batchAdd
     * @Description: 批量导入
     * @return: Integer
     */
    Integer batchAdd(Workbook wb, String bjbh, StringBuffer message, List<EnterpriseExamine> enterpriseList);

    /**
     * @param request
     * @param bjbh
     * @param departentId
     * @param userId
     * @param scxxl
     * @param scmc
     * @param enterpriseList
     * @return id
     * @Title: addApplication
     * @Description: 保存申请
     */
    String addApplication(HttpServletRequest request, String bjbh, String departentId, String userId, String scxxl, String scmc,
                          Date scsjs, Date scsjz, List<EnterpriseExamine> enterpriseList, String[] uploadFileName, String[] uploadFilePath);


    /**
     * 保存申请
     *
     * @param request
     * @param bjbh
     * @param departentId
     * @param userId
     * @param scxxl
     * @param scmc
     * @param scsm
     * @param scsjs
     * @param scsjz
     * @param uploadImgName
     * @param uploadImgPath
     * @param enterpriseList
     * @return
     */
    CreditExamine addApplication(HttpServletRequest request, String bjbh, String departentId, String userId, String scxxl, String scmc, String scsm,
                                 Date scsjs, Date scsjz, String[] uploadImgName, String[] uploadImgPath, List<EnterpriseExamine> enterpriseList);


    /**
     * 创建信用审查报告
     *
     * @param request
     * @param id
     * @return
     */
    String createCreditReport(HttpServletRequest request, String id);

    /**
     * 信用中心法人信用审查上传后保存红头文件
     *
     * @param id
     * @param bz
     * @param uploadFileName
     * @param uploadFilePath
     * @param userId
     */
    void submitCheckReport(String id, String bz, String uploadFileName, String uploadFilePath, String userId);

    /**
     * @param page
     * @param scmc
     * @param xqbm
     * @param bjbh
     * @param sqsjs
     * @param sqsjz
     * @param sysuserid
     * @param status
     * @return
     * @Title: queryApplyList
     * @Description: 查询申请列表
     * @return: Pageable<CreditExamine>
     */
    Pageable<CreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs,
                                           String sqsjz, String userId, String status);

    /**
     * @return
     * @Title: getBarPieData
     * @Description: 获取柱图饼图数据
     * @return: Map<String       ,       Object>
     */
    Map<String, Object> getBarPieData(String deptId);



}
