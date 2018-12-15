package com.udatech.objectionComplaint.service;

import com.udatech.objectionComplaint.model.*;
import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.List;
import java.util.Map;

/**
 * 信用申诉申请
 * @author beijh
 * @date 2018-11-29 14:25
 */
public interface ObjectionComplaintService {

    /**
     * @category 获取异议记录
     * @param businessId
     * @return
     */
    List<String> getBjbhList(String businessId);

    /**
     * @category 通过身份证或者名字找到申请人信息
     * @return
     */
    List<Map<String,Object>> getComplainPerson(String str);

    /**
     * 获取信用信息
     *
     * @param info
     * @param page
     * @return
     */
    Pageable<Map<String, Object>> getCreditInfo(ObjectionInfo info, Page page);

    /**
     * @category 获取办件编号
     * @return
     */
    String getBjbh();

    /**
     * @category 保存信用异议申请
     * @param
     * @return
     */
    String addObjection(ObjectionAddVo vo);

    /**
     * @category 通过Id找到异议申请记录
     * @param
     * @return
     */
    ObjectionComplaint findObjectionByid(String id);

    /**
     * @category 获取异议申诉列表
     * @param page
     * @return
     */
    Pageable<Map<String,Object>> getObjectionList(QueryConditionVo vo, Page page);

    /**
     * @category 通过申诉id获取证明材料
     * @return
     */
    List<Map<String,Object>> findZmclById(String id);

    /**
     * @category 获取具体申诉的信用信息
     * @param dataTable
     * @param thirdId
     * @return
     */
    List<Map<String,Object>> getCreditDetail(String dataTable, String thirdId, String type, List<Map<String, Object>> fieldList);

    /**
     * @category 通过申诉Id找到申诉的证明材料
     * @return
     */
    List<DtUploadFile> uploadFiles(String id);
}
