package com.udatech.hall.creditReport.dao;

import java.util.Map;

import com.udatech.common.model.PersonReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDao;

/**
 * <描述>： 自然人-信用报告申请（业务大厅端）<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:52:44
 */
public interface HallPReportDao extends BaseDao {

    /**
     * @category 根据ID获取信用报告
     * @param id
     * @return
     */
    PersonReportApply getReportById(String id);

    /**
     * @category 获取信用报告列表
     * @param pi
     * @param params
     * @param page
     * @return
     */
    Pageable<PersonReportApply> getReportList(PersonReportApply pi, Map<String, Object> params, Page page);

     /**
     * <描述>: 获取信用报告打印列表
     * @author 作者：Ljj
     * @version 创建时间：2017年10月9日下午3:24:56
     * @param pi
     * @param params
     * @param page
     * @return
     */
    Pageable<PersonReportApply> getReportIssueList(PersonReportApply pi, Map<String, Object> params, Page page);

}
