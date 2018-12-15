package com.udatech.hall.creditReport.dao;

import java.util.List;
import java.util.Map;

import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.model.EnterpriseReportApply;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDao;
import com.wa.framework.dictionary.vo.SysDictionaryVo;

/**
 * <描述>： 信用报告申请（业务大厅端）<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月1日上午9:52:44
 */
public interface HallReportDao extends BaseDao {

    /**
     * @category 根据ID获取信用报告
     * @param id
     * @return
     */
    EnterpriseReportApply getReportById(String id);

    /**
     * @category 获取信用报告列表
     * @param ei
     * @param params
     * @param page
     * @return
     */
    Pageable<EnterpriseReportApply> getReportList(EnterpriseInfo ei, Map<String, Object> params, Page page);

    /**
     * <描述>:获取报告用途字典项，且按字典名称排序
     * @author 作者：Ljj
     * @version 创建时间：2017年8月12日下午5:07:27
     * @param groupKey
     * @return
     */
    List<SysDictionaryVo> queryByGroupKey(String groupKey);

    /**
     * <描述>: 获取信用报告打印列表
     * @author 作者：Ljj
     * @version 创建时间：2017年8月12日下午6:02:05
     * @param ei
     * @param params
     * @param page
     * @return
     */
    Pageable<EnterpriseReportApply> getReportIssueList(EnterpriseInfo ei, Map<String, Object> params, Page page);

    void finishPrintTaskByIsIssue(EnterpriseReportApply enterpriseReportApply);
}
