package com.udatech.center.creditReport.service;

import com.udatech.center.creditReport.dao.CreditPReportDao;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.PersonReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.log.ExpLog;
import com.wa.framework.service.BaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * <描述>： 自然人 - 信用查询service层<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月12日下午4:56:34
 */
@Service("creditPReportService")
@ExpLog(type="自然人信用报告查询Service")
public class CreditPReportService extends BaseService {
    @Resource(name = "creditPReportDao")
    private CreditPReportDao creditPReportDao;

    @Autowired
    private CreditCommonDao creditCommonDao;

    /**
     * <描述>: 获取信用报告申请单列表
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午2:20:10
     * @param pi
     * @param xybgbh
     * @param page
     * @return
     */
    public Pageable<PersonReportApply> getReportApplyList(PersonReportApply pi, String xybgbh, Page page) {
        return creditPReportDao.getReportApplyList(pi, xybgbh, page);
    }

    /**
     * <描述>: 根据ID获取信用报告申请信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午4:27:46
     * @param id
     * @return
     */
    public PersonReportApply getReportById(String id) {
        PersonReportApply po = creditPReportDao.getReportById(id);
        if (po != null) {
            po.setCxrsfz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.自然人信用报告申请_本人身份证));
            po.setWtrsfz(creditCommonDao.getUploadFiles(id, UploadFileEnmu.自然人信用报告申请_委托人身份证));
            po.setWtsqs(creditCommonDao.getUploadFiles(id, UploadFileEnmu.自然人信用报告申请_委托授权书));
        }
        return po;
    }

    /**
     * <描述>: 保存审核信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日上午9:58:44
     * @param er
     */
    public void saveReprotAudit(PersonReportApply er) {
        creditPReportDao.saveReprotAudit(er);
    }
}
