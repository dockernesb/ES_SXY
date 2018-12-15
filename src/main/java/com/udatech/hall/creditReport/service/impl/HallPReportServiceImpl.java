package com.udatech.hall.creditReport.service.impl;

import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.PersonReportApply;
import com.udatech.hall.creditReport.dao.HallPReportDao;
import com.udatech.hall.creditReport.service.HallPReportService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.log.ExpLog;
import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * <描述>：自然人-信用报告申请（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:53:09
 */
@Service
@ExpLog(type="自然人信用报告申请Service")
public class HallPReportServiceImpl implements HallPReportService {

    @Autowired
    private HallPReportDao hallPReportDao;

    @Autowired
    private CreditCommonDao creditCommonDao;

    /**
     * @category 保存信用报告申请
     * @param po
     */
    @Transactional
    public void addReport(PersonReportApply po) {
        hallPReportDao.save(po);

        String userId = po.getCreateUser().getId();
        String id = po.getId();

        // 保存附件信息
        creditCommonDao.saveUploadFiles(po.getCxrsfzName(), po.getCxrsfzPath(), UploadFileEnmu.自然人信用报告申请_本人身份证, userId, id);
        creditCommonDao.saveUploadFiles(po.getWtrsfzName(), po.getWtrsfzPath(), UploadFileEnmu.自然人信用报告申请_委托人身份证, userId, id);
        creditCommonDao.saveUploadFiles(po.getWtsqsName(), po.getWtsqsPath(), UploadFileEnmu.自然人信用报告申请_委托授权书, userId, id);
    }

    /**
     * @category 根据ID获取信用报告申请信息
     * @param id
     * @return
     */
    public PersonReportApply getReportById(String id) {
        PersonReportApply po = hallPReportDao.getReportById(id);
        if (po != null) {
            po.setCxrsfz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.自然人信用报告申请_本人身份证));
            po.setWtrsfz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.自然人信用报告申请_委托人身份证));
            po.setWtsqs(creditCommonDao.getUploadFiles(id, UploadFileEnmu.自然人信用报告申请_委托授权书));
        }
        return po;
    }

    /**
     * @category 获取信用报告列表
     * @param pi
     * @param page
     * @return
     */
    public Pageable<PersonReportApply> getReportList(PersonReportApply pi, Map<String, Object> params, Page page) {
        String skipType = MapUtils.getString(params, "skipType");
        if ("1".equals(skipType)) {// 业务端报告查询
            return hallPReportDao.getReportList(pi, params, page);
        }
        if ("2".equals(skipType)) {// 业务端报告打印
            return hallPReportDao.getReportIssueList(pi, params, page);
        }
        return null;
    }

}
