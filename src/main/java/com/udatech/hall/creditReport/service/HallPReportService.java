package com.udatech.hall.creditReport.service;

import java.util.Map;

import com.udatech.common.model.PersonReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;

/**
 * <描述>：自然人-信用报告申请（业务大厅端） <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:53:26
 */
public interface HallPReportService {

    /**
     * @category 保存信用报告申请
     * @param eo
     */
    void addReport(PersonReportApply eo);

    /**
     * @category 根据ID获取信用报告申请单信息
     * @param id
     * @return
     */
    PersonReportApply getReportById(String id);

    /**
     * @category 获取信用报告申请单列表
     * @param pi
     * @param params
     * @param page
     * @return
     */
    Pageable<PersonReportApply> getReportList(PersonReportApply pi, Map<String, Object> params, Page page);

}
