package com.udatech.objectionComplaint.dao;

import com.udatech.objectionComplaint.model.DtUploadFile;
import com.udatech.objectionComplaint.model.ObjectionComplaint;
import com.udatech.objectionComplaint.model.ObjectionInfo;
import com.udatech.objectionComplaint.model.QueryConditionVo;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDao;

import java.util.List;
import java.util.Map;

/**
 * 信用申诉申请
 * @author beijh
 * @date 2018-11-29 14:28
 */
public interface ObjectionComplaintDao extends BaseDao {

    /**
     * @category 获取异议申诉列表
     * @param page
     * @return
     */
    Pageable<Map<String,Object>> getObjectionList(QueryConditionVo vo, Page page);

    /**
     * @category 通过身份证或者名字找到申请人信息
     * @return
     */
    List<Map<String,Object>> getComplainPerson(String str);

    /**
     * 获取信用信息
     * @param page
     * @return
     */
    Pageable<Map<String, Object>> getCreditInfo(ObjectionInfo info, Page page);

    /**
     * @category 通过Id找到异议申请记录
     * @param
     * @return
     */
    ObjectionComplaint findObjectionByid(String id);

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

    /**
     * @category 通过申诉类型和linkId找到申诉的那条记录，把状态改为修复中
     * @return
     */
    void updateByLinkId(String dataTable, String linkId);
}
