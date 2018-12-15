package com.udatech.objectionComplaint.service.impl;

import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.objectionComplaint.dao.ObjectionComplaintDao;
import com.udatech.objectionComplaint.model.*;
import com.udatech.objectionComplaint.service.ObjectionComplaintService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.log.ExpLog;
import com.wa.framework.utils.RandomString;
import com.wa.framework.utils.UploadFtpTool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 信用申诉申请
 * @author beijh
 * @date 2018-11-29 14:27
 */
@Service
@ExpLog(type = "信用申诉申请")
@Transactional(rollbackFor = {Exception.class})
public class ObjectionComplaintServiceImpl implements ObjectionComplaintService {


    @Autowired
    private ObjectionComplaintDao objectionComplaintDao;

    @Autowired
    private CreditCommonDao commonDao;

    /**
     * @category 获取异议记录
     * @param businessId
     * @return
     */
    @Override
    public List<String> getBjbhList(String businessId) {
        return null;
    }

    /**
     * @category 通过身份证或者名字找到申请人信息
     * @return
     */
    public List<Map<String,Object>> getComplainPerson(String str){
        return objectionComplaintDao.getComplainPerson(str);
    }

    /**
     * @param info
     * @param page
     * @return
     * @category 获取信用信息
     */
    @Override
    public Pageable<Map<String, Object>> getCreditInfo(ObjectionInfo info,
                                                       Page page) {
        return objectionComplaintDao.getCreditInfo(info, page);
    }

    /**
     * @category 获取办件编号
     * @return
     */
    public String getBjbh() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String bjbh = "SS" + sdf.format(new Date())
                + new RandomString().getRandomString(3, "i");
        return bjbh;
    }

    /**
     * @category 保存信用异议申请
     * @param
     * @return
     */
    @Override
    public String addObjection(ObjectionAddVo vo) {
        ObjectionComplaint oc = new ObjectionComplaint();
        oc.setName(vo.getName());
        oc.setComplaintType(vo.getComplaintType());
        oc.setJsz(vo.getJsz());
        oc.setPhoneNumber(vo.getSjhm());
        oc.setCreateDate(new Date());
        oc.setCreateId(CommonUtil.getCurrentUserId());
        oc.setSsbz(vo.getSsbz());
        oc.setState("0");
        oc.setLinkId(vo.getThirdId());
        oc.setBjbh(vo.getBjbh());
        oc.setDataTable(vo.getDataTable());
        oc.setSource("1");
        if (vo.getDataTable().indexOf("WFXW") > -1) {
            oc.setType("2");
        } else {
            oc.setType("1");
        }
        objectionComplaintDao.save(oc);
        //修改一下申诉数据表里的这条申诉数据的状态：（改为修复中的状态）
        objectionComplaintDao.updateByLinkId(oc.getDataTable(),oc.getLinkId());
        if (vo.getZmclName() != null && vo.getZmclPath() != null) {
            this.commonDao.saveUploadFiles(vo.getZmclName(), vo.getZmclPath(), UploadFileEnmu.企业异议申诉申请证明材料, oc.getName(), oc.getId());
        }
        try {
            UploadFtpTool.putJson( (Object)oc,"hall_"+oc.getId(),vo.getZmclPath());
            List<DtUploadFile> files = uploadFiles(oc.getId());
            if(files != null && files.size() > 0){
                for (int i=0;i<files.size();i++) {
                    UploadFtpTool.putJson((Object)files.get(i),"file_"+oc.getId()+"_"+i,null);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return oc.getId();
    }

    /**
     * @category 通过Id找到异议申请记录
     * @param
     * @return
     */
    @Override
    public ObjectionComplaint findObjectionByid(String id) {
        return objectionComplaintDao.findObjectionByid(id);
    }

    /**
     * @category 获取异议申诉列表
     * @return
     */
    @Override
    public Pageable<Map<String, Object>> getObjectionList(QueryConditionVo vo, Page page) {
        return objectionComplaintDao.getObjectionList(vo,page);
    }

    /**
     * @category 通过申诉id获取证明材料
     * @return
     */
    @Override
    public List<Map<String, Object>> findZmclById(String id) {
        return objectionComplaintDao.findZmclById(id);
    }

    /**
     * @category 获取具体申诉的信用信息
     * @param dataTable
     * @param thirdId
     * @return
     */
    @Override
    public List<Map<String, Object>> getCreditDetail(String dataTable, String thirdId, String type, List<Map<String, Object>> fieldList) {
        return objectionComplaintDao.getCreditDetail( dataTable, thirdId, type, fieldList);
    }


    /**
     * @category 通过申诉Id找到申诉的证明材料
     * @return
     */
    @Override
    public List<DtUploadFile> uploadFiles(String id) {
        return objectionComplaintDao.uploadFiles(id);
    }

}
