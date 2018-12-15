package com.udatech.common.creditCheck.service;

import com.alibaba.fastjson.JSONObject;
import com.udatech.common.model.PCreditExamine;
import com.udatech.common.model.PCreditExamineHis;
import com.udatech.common.model.PeopleExamine;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysUser;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

/**
 * @Description: 信用审查Service(中心端)
 * @author: 何斐
 * @date: 2016年11月21日 下午3:53:40
 */
public interface PCreditCheckService {

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
    Pageable<PCreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs,
                                            String sqsjz, String userId, String status, String type, String bjbm);

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
    Pageable<PCreditExamine> queryApplyList(Page page, String scmc, String xqbm, String bjbh, String sqsjs,
                                            String sqsjz, String userId, String status);

    /**
     * @param id
     * @return
     * @Title: findCreditExamineHisByCreditExamineId
     * @Description: 根据Id查询审核记录
     * @return: CreditExamineHis
     */
    PCreditExamineHis findCreditExamineHisByCreditExamineId(String id);

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
     * @Title: getPeopleList
     * @Description: 获取自然人列表
     * @return: Pageable<EnterpriseExamine>
     */
    Pageable<PeopleExamine> getPeopleList(Page page, String id);

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
     * POI创建信用审查报告
     *
     * @param request
     * @return
     */
    String createCreditReport(HttpServletRequest request, String id);

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
     * @Description: 将自然人List分页
     * @return: Pageable<EnterpriseExamine>
     */
    Pageable<PeopleExamine> findPeopleByPage(Page page, List<PeopleExamine> enterpriseList);

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
    boolean addPeople(String bjbh, String xm, String sfzh,
                      List<PeopleExamine> enterpriseList, JSONObject msg);

    /**
     * @param enterpriseList
     * @param id
     * @Title: reomveEnters
     * @Description: 删除自然人
     * @return: void
     */
    void removePeoples(List<PeopleExamine> enterpriseList, String id);

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
    Integer batchAdd(Workbook wb, String bjbh, StringBuffer message, List<PeopleExamine> enterpriseList);

    /**
     * @param bjbh
     * @param departentId
     * @param userId
     * @param scxxl
     * @param scmc
     * @param scsjs
     * @param scsjz
     * @param enterpriseList @return id
     * @Title: addApplication
     * @Description: 保存申请(中心端审查上传)
     */
    String addApplication(String bjbh, String departentId, String userId, String scxxl, String scmc,
                          Date scsjs, Date scsjz, List<PeopleExamine> enterpriseList, String[] uploadFileName, String[] uploadFilePath);

    /**
     * 保存申请
     *
     * @param bjbh
     * @param departentId
     * @param userId
     * @param scxxl
     * @param scmc
     * @param scsm
     * @param uploadImgName
     * @param uploadImgPath
     * @param peopleList
     * @return
     */
    PCreditExamine addApplication(String bjbh, String departentId, String userId, String scxxl, String scmc, String scsm,
                                  Date scsjs, Date scsjz, String[] uploadImgName, String[] uploadImgPath, List<PeopleExamine> peopleList);

    String getScxxl(String scxxlIdArr);

    void submitCheckReport(String id, String bz, String uploadFileName, String uploadFilePath, String userId);
}
