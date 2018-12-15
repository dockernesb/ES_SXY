package com.udatech.hall.creditReport.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.hall.creditReport.dao.HallReportDao;
import com.udatech.hall.creditReport.service.HallReportService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dictionary.vo.SysDictionaryVo;
import com.wa.framework.log.ExpLog;

/**
 * <描述>：信用报告申请（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:53:09
 */
@Service
@ExpLog(type = "法人信用报告申请Service")
public class HallReportServiceImpl implements HallReportService {

    @Autowired
    private HallReportDao hallReportDao;

    @Autowired
    private CreditCommonDao creditCommonDao;

    /**
     * @category 保存信用报告申请
     * @param eo
     */
    @Transactional
    public void addReport(EnterpriseReportApply eo) {
        hallReportDao.save(eo);

        String userId = eo.getCreateUser().getId();
        String id = eo.getId();

        creditCommonDao.saveUploadFiles(eo.getYyzzName(), eo.getYyzzPath(), UploadFileEnmu.企业信用报告申请_工商营业执照, userId, id);
        creditCommonDao.saveUploadFiles(eo.getZzjgdmzName(), eo.getZzjgdmzPath(), UploadFileEnmu.企业信用报告申请_组织机构代码证, userId, id);
        creditCommonDao.saveUploadFiles(eo.getQysqsName(), eo.getQysqsPath(), UploadFileEnmu.企业信用报告申请_自查企业授权书, userId, id);
        creditCommonDao.saveUploadFiles(eo.getSfzName(), eo.getSfzPath(), UploadFileEnmu.企业信用报告申请_自查身份证图片, userId, id);
        creditCommonDao.saveUploadFiles(eo.getSqsfzName(), eo.getSqsfzPath(), UploadFileEnmu.企业信用报告申请_委托身份证图片, userId, id);
        creditCommonDao.saveUploadFiles(eo.getSqqysqsName(), eo.getSqqysqsPath(), UploadFileEnmu.企业信用报告申请_委托企业授权书, userId, id);
        creditCommonDao.saveUploadFiles(eo.getSqfrzmwjName(), eo.getSqfrzmwjPath(), UploadFileEnmu.企业信用报告申请_委托授权法人证明文件, userId, id);
    }

    /**
     * @category 根据ID获取信用报告申请信息
     * @param id
     * @return
     */
    public EnterpriseReportApply getReportById(String id) {
        EnterpriseReportApply eo = hallReportDao.getReportById(id);
        if (eo != null) {
            eo.setYyzz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_工商营业执照));
            eo.setZzjgdmz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_组织机构代码证));
            eo.setQysqs(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_自查企业授权书));
            eo.setSfz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_自查身份证图片));
            eo.setSqqysqs(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_委托企业授权书));
            eo.setSqsfz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_委托身份证图片));
            eo.setSqfrzmwj(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_委托授权法人证明文件));
            eo.setSbg(creditCommonDao.getUploadFiles(id, UploadFileEnmu.企业信用报告申请_省报告PDF文件));
        }
        return eo;
    }

    /**
     * @category 获取信用报告列表
     * @param ei
     * @param page
     * @return
     */
    public Pageable<EnterpriseReportApply> getReportList(EnterpriseInfo ei, Map<String, Object> params, Page page) {
        String skipType = MapUtils.getString(params, "skipType");
        if ("1".equals(skipType)) {
            return hallReportDao.getReportList(ei, params, page);
        }
        if ("2".equals(skipType)) {
            return hallReportDao.getReportIssueList(ei, params, page);
        }
        return null;
    }

    @Override
    public List<SysDictionaryVo> queryByGroupKey(String groupKey) {
        return hallReportDao.queryByGroupKey(groupKey);
    }

    @Override
    public void finishPrintTaskByIsIssue(EnterpriseReportApply enterpriseReportApply) {
        hallReportDao.finishPrintTaskByIsIssue(enterpriseReportApply); 
        
    }

}
