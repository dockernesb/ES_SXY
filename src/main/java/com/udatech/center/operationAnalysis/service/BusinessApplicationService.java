package com.udatech.center.operationAnalysis.service;

import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.Map;


/**
 * 描述：业务应用分析service（中心端）
 * 创建人：guoyt
 * 创建时间：2016年12月28日下午5:53:06
 * 修改人：guoyt
 * 修改时间：2016年12月28日下午5:53:06
 */
public interface BusinessApplicationService {
    
    /**
     * @Description: 根据各种统计主题和统计时间阶段统计数量
     * @param: @param operationCriteria
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getTotalByCategory(OperationCriteria operationCriteria);
    
    /**
     * @Description: 根据各种统计主题统计信用报告、异议处理、信用修复、信用核查等情况
     * @param: @param 根据统计主题、统计开始日期、结束日期、维度分析、趋势类别进行统计
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> queryBusinessApplication(OperationCriteria operationCriteria,Page page);
    
    /**
     * @Description: 根据各种统计主题（信用报告、异议处理、信用修复、信用核查）统计表格
     * @param: @param operationCriteria 页面中的查询条件
     * @param: @param page 分页
     * @param: @return
     * @return: Pageable<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public Pageable<Map<String, Object>> queryTableDetails(OperationCriteria operationCriteria, Page page);
    
    /**
     * @Description: 统计双公示的情况
     * @param: @param 封装查询条件，包括（统计开始日期、结束日期等）
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> queryPublicity(OperationCriteria operationCriteria);
    
    /**
     * @Description: 查询行政许可、行政处罚排行榜
     * @param: @param operationCriteria
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> queryPublicityRanking(OperationCriteria operationCriteria);
    
    /**
     * @Description: 统计双公示的表格情况
     * @param: @param operationCriteria 页面中的查询条件
     * @param: @param page 分页
     * @param: @return
     * @return: Pageable<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public Pageable<Map<String, Object>> queryPublicityTable(OperationCriteria operationCriteria, Page page);
    /**
     * 
     * @Description: 信用审查新改的功能重新添加的表格查询方法
     * @param: @param operationCriteria
     * @param: @param page
     * @param: @return
     * @return: Pageable<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public Pageable<Map<String, Object>> queryCheckTable(OperationCriteria operationCriteria, Page page);
    /**
     * 
     * @Description: 查询信用报告的表格数据
     * @param: @param operationCriteria
     * @param: @param page
     * @param: @return
     * @return: Pageable<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public Pageable<Map<String, Object>> queryCreditReportTable(OperationCriteria operationCriteria, Page page);

    /**
     *
     * @Description: 查询信用报告的表格数据(原表)
     * @param: @param operationCriteria
     * @param: @param page
     * @param: @return
     * @return: Pageable<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public Pageable<Map<String, Object>> queryCreditReportTable_5(OperationCriteria operationCriteria, Page page);
    
    /**
     * @Description:统计月办理量            
     * @param: @param operationCriteria
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.7.0_79
     */
    public Map<String, Object> queryMonthlyHandle(OperationCriteria operationCriteria);
}
