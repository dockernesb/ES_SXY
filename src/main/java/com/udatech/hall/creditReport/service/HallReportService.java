package com.udatech.hall.creditReport.service;

import java.util.List;
import java.util.Map;

import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dictionary.vo.SysDictionaryVo;

/**
 * <描述>：信用报告申请（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:53:26
 */
public interface HallReportService {

    /**
     * @category 保存信用报告申请
     * @param eo
     */
    void addReport(EnterpriseReportApply eo);

    /**
     * @category 根据ID获取信用报告申请单信息
     * @param id
     * @return
     */
    EnterpriseReportApply getReportById(String id);

    /**
     * @category 获取信用报告申请单列表
     * @param ei
     * @param params
     * @param page
     * @return
     */
    Pageable<EnterpriseReportApply> getReportList(EnterpriseInfo ei, Map<String, Object> params, Page page);

    /**
     * <描述>: 获取报告用途字典项，且按字典名称排序
     * @author 作者：Ljj
     * @version 创建时间：2017年8月12日下午5:06:17
     * @param groupKey
     * @return
     */
    List<SysDictionaryVo> queryByGroupKey(String groupKey);
    
    void finishPrintTaskByIsIssue(EnterpriseReportApply enterpriseReportApply);

}
