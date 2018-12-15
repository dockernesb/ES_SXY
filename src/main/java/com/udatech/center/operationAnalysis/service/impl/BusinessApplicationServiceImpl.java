package com.udatech.center.operationAnalysis.service.impl;

import com.udatech.center.operationAnalysis.dao.BusinessApplicationDao;
import com.udatech.center.operationAnalysis.service.BusinessApplicationService;
import com.udatech.center.operationAnalysis.service.OpeCommonService;
import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.udatech.common.constant.Constants;
import com.udatech.common.service.CreditCommonService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.log.ExpLog;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 描述：业务应用分析service实现类（中心端）
 * 创建人：guoyt
 * 创建时间：2016年12月28日下午5:54:38
 * 修改人：guoyt
 * 修改时间：2016年12月28日下午5:54:38
 */
@Service
@ExpLog(type="业务应用分析管理")
public class BusinessApplicationServiceImpl implements BusinessApplicationService  {
    
    @Autowired
    private BusinessApplicationDao businessApplicationDao;
    
    @Autowired
    private OpeCommonService opeCommonService;

    @Autowired
    private CreditCommonService creditCommonService;
    
    /** 
     * @Description: 根据各种统计主题和统计时间阶段统计数量
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#getTotalByCategory(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> getTotalByCategory(OperationCriteria operationCriteria) {
        // 根据统计主题（信用报告、异议处理、信用修复、信用核查）和统计时间阶段计算数量
        long total = businessApplicationDao.getTotalByCategory(operationCriteria);

        Map<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("total", total);
        return resMap;
    }
    
    /** 
     * @Description: 根据各种统计主题统计信用报告、异议处理、信用修复、信用核查等情况
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#queryBusinessApplication(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> queryBusinessApplication(OperationCriteria operationCriteria,Page page) {
        Map<String, Object> resMap = new HashMap<String, Object>();
        Map<String, Object> allDataMap = new HashMap<String, Object>();

        // 封装分布情况数据，包括x轴和y轴
        if (Constants.CHART_THEME_DISTRIBUTION.equals(operationCriteria.getChartTheme())) {
        	if (!Constants.CATEGORY_CREDIT_CHECK.equals(operationCriteria.getCategory())) {
        		allDataMap = businessApplicationDao.queryBusinessDistribution(operationCriteria);
        	}else{
        		allDataMap = businessApplicationDao.queryCheckBar(operationCriteria);
        	}
        	
        }

        // 封装趋势分析数据，包括x轴和y轴
        if (Constants.CHART_THEME_TRENDS.equals(operationCriteria.getChartTheme())) {
            allDataMap = businessApplicationDao.queryBusinessTrends(operationCriteria);
        }

        Map<String, Object> industryDistributionX = opeCommonService.getChartCategory(allDataMap);
        Map<String, Object> industryDistributionY = opeCommonService.getChartDatas(allDataMap);
        resMap.put("IDX", industryDistributionX);
        resMap.put("IDY", industryDistributionY);
        return resMap;
    }

    /** 
     * @Description: 根据各种统计主题（信用报告、异议处理、信用修复、信用核查）统计表格
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#queryTableDetails(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
     * @since JDK 1.6
     */
    @Override
    public Pageable<Map<String, Object>> queryTableDetails(OperationCriteria operationCriteria, Page page) {
        Pageable<Map<String, Object>> pageable = businessApplicationDao.queryTableDetails(operationCriteria, page);
        return pageable;
    }

    /** 
     * @Description: 统计双公示的情况
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#queryPublicity(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> queryPublicity(OperationCriteria operationCriteria) {
        Map<String, Object> resMap = new HashMap<String, Object>();

        Map<String, Object> allDataMap = businessApplicationDao.queryPublicity(operationCriteria);

        Map<String, Object> industryDistributionX = opeCommonService.getChartCategory(allDataMap);
        Map<String, Object> industryDistributionY = opeCommonService.getChartDatas(allDataMap);
        resMap.put("IDX", industryDistributionX);
        resMap.put("IDY", industryDistributionY);

        return resMap;
    }
    
    /** 
     * @Description: 查询行政许可、行政处罚排行榜
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#queryPublicityRanking(com.udatech.center.operationAnalysis.vo.OperationCriteria)
     * @since JDK 1.6
     */
    @Override
    public Map<String, Object> queryPublicityRanking(OperationCriteria operationCriteria) {
        List<Map<String, Object>> ranking = businessApplicationDao.queryPublicityRanking(operationCriteria);
        Map<String, Object> resMap = new HashMap<String, Object>();
        resMap.put("ranking", ranking); 
        return resMap;
    }

    /** 
     * @Description: 统计双公示的表格情况
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#queryPublicityTable(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
     * @since JDK 1.6
     */
    @Override
    public Pageable<Map<String, Object>> queryPublicityTable(OperationCriteria operationCriteria, Page page) {
        Pageable<Map<String, Object>> pageable = businessApplicationDao.queryPublicityTable(operationCriteria, page);
        return pageable;
    }

    /**
     * 
     * @Description: 统计信用核查的表格情况. 
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#queryCheckTable(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
     * @since JDK 1.6
     */
    @Override
    public Pageable<Map<String, Object>> queryCheckTable(OperationCriteria operationCriteria, Page page) {
        Pageable<Map<String, Object>> pageable = businessApplicationDao.queryCheckTable(operationCriteria, page);
        return pageable;
    }

    /**
     * 
     * @Description: 统计信用报告表格详情. 
     * @see： @see com.udatech.center.operationAnalysis.service.BusinessApplicationService#queryCreditReportTable(com.udatech.center.operationAnalysis.vo.OperationCriteria, com.wa.framework.Page)
     * @since JDK 1.6
     */
    @Override
    public Pageable<Map<String, Object>> queryCreditReportTable(OperationCriteria operationCriteria, Page page) {
        Pageable<Map<String, Object>> pageable = businessApplicationDao.queryCreditReportTable(operationCriteria, page);  
        return pageable;
    }

    @Override
    public Pageable<Map<String, Object>> queryCreditReportTable_5(OperationCriteria operationCriteria, Page page) {
        Pageable<Map<String, Object>> pageable = businessApplicationDao.queryCreditReportTable_5(operationCriteria, page);
        return pageable;
    }
    
    /**
     * @Description:  统计月办理量          
     * @param: @param operationCriteria
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.7.0_79
     */
    @Override
    public Map<String, Object> queryMonthlyHandle(OperationCriteria operationCriteria) {
        Map<String, Object> resMap = new HashMap<String, Object>();

        Map<String, Object> allDataMap = businessApplicationDao.queryMonthlyHandle(operationCriteria);

        Map<String, Object> industryDistributionX = opeCommonService.getChartCategory(allDataMap);
        Map<String, Object> industryDistributionY = opeCommonService.getChartDatas(allDataMap);
        resMap.put("IDX", industryDistributionX);
        resMap.put("IDY", industryDistributionY);

        return resMap;
    }
    
}
