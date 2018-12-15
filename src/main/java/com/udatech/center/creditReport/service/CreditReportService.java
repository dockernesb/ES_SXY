package com.udatech.center.creditReport.service;

import com.udatech.center.creditReport.dao.CreditReportDao;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.ReportApplyEnmu;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.log.ExpLog;
import com.wa.framework.service.BaseService;
import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.Map;

/**
 * <描述>： 企业信用查询service层<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年5月12日下午4:56:34
 */
@Service("creditReportService")
@ExpLog(type = "法人信用报告查询Service")
public class CreditReportService extends BaseService {
    @Resource(name = "creditReportDao")
    private CreditReportDao creditReportDao;

    @Autowired
    private CreditCommonDao creditCommonDao;

    /**
     * <描述>: 获取信用报告申请单列表
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午2:20:10
     * @param ei
     * @param params
     * @param page
     * @return
     */
    public Pageable<EnterpriseReportApply> getReportApplyList(EnterpriseInfo ei, Map<String, Object> params, Page page) {
        String skipType = MapUtils.getString(params, "skipType");
        if ("1".equals(skipType)) {
            return creditReportDao.getReportApplyList(ei, params, page);
        }
        if ("2".equals(skipType)) {
            return creditReportDao.getReportIssueList(ei, params, page);
        }
        return null;
    }

    /**
     * <描述>: 根据ID获取信用报告申请信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月5日下午4:27:46
     * @param id
     * @return
     */
    public EnterpriseReportApply getReportById(String id) {
        EnterpriseReportApply eo = creditReportDao.getReportById(id);
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
     * <描述>: 保存审核信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日上午9:58:44
     * @param er
     */
    public void saveReprotAudit(EnterpriseReportApply er) {
        creditReportDao.saveReprotAudit(er);
    }

    /**
     * <描述>:保存下发意见、省报告等信息
     * @author 作者：Ljj
     * @version 创建时间：2017年8月12日下午12:43:00
     * @param er
     */
    public void saveReportIssue(EnterpriseReportApply er) {
        // 更新下发意见等信息
        EnterpriseReportApply old = creditReportDao.get(EnterpriseReportApply.class, er.getId());
        if (old != null) {
            old.setIsIssue("1");
            old.setIsHasReport(er.getIsHasReport());
            old.setIssueDate(new Date());
            old.setIssueOpition(er.getIssueOpition());
            creditReportDao.update(old);
        }

        // 有省报告时，保存省报告文件关联信息
        if ("1".equals(er.getIsHasReport())) {
            creditCommonDao.saveUploadFiles(er.getSbgName(), er.getSbgPath(), UploadFileEnmu.企业信用报告申请_省报告PDF文件, er.getZxshr().getId(),
                            er.getId());
        }
    }

    /**
     * <描述>: 重新审核
     * @author 作者：Ljj
     * @version 创建时间：2017年8月12日下午1:17:14
     * @param er
     */
    public void reAudit(EnterpriseReportApply er) {
        String id = er.getId();
        EnterpriseReportApply old = creditCommonDao.get(EnterpriseReportApply.class, id);
        if (old != null) {
            old.setIsAuditBack("1");
            old.setAuditBackDate(new Date());
            old.setAuditBackUser(er.getAuditBackUser());
            old.setStatus(ReportApplyEnmu.待审核.getKey());
            old.setXybgbh("");
            this.update(old);
        }
    }
}
