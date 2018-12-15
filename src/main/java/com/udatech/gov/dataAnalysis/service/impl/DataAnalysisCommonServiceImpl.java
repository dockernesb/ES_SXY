package com.udatech.gov.dataAnalysis.service.impl;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.udatech.gov.dataAnalysis.service.DataAnalysisCommonService;
import com.udatech.gov.dataAnalysis.vo.AnalysisCriteria;
import com.wa.framework.log.ExpLog;

/**
 * 描述：统计分析公用service实现类
 * 创建人：caohy
 * 创建时间：2017年7月20日上午11:31:13
 * 修改人：caohy
 * 修改时间：2017年7月20日上午11:31:13
 */
@Service
@ExpLog(type="统计分析公用类")
public class DataAnalysisCommonServiceImpl implements DataAnalysisCommonService {
    
    /** 
     * @Description:封装查询条件 
     * @see： @see com.udatech.center.dataAnalysis.service.DataAnalysisCommonService#packageAnalysisCriteria(javax.servlet.http.HttpServletRequest)
     * @since JDK 1.7.0_79
     */
    @Override
    public AnalysisCriteria packageAnalysisCriteria(HttpServletRequest request) {
        AnalysisCriteria analysisCriteria = new AnalysisCriteria();
        
        //主题 0:手动上传 2：文件上传 3：数据库 9：ftp上传
        String category = request.getParameter("category");
        if (StringUtils.isNotEmpty(category)) {
            analysisCriteria.setCategory(category);
        }
        
        //目录名称
        String tableName = request.getParameter("tableName");
        if(StringUtils.isNotEmpty(tableName)){
        	analysisCriteria.setTableName(tableName);
        }
        
        // 图表类别：1：饼图 2：趋势图 3：柱状图
        String chartsType= request.getParameter("chartsType");
        if (StringUtils.isNotEmpty(chartsType)) {
            analysisCriteria.setChartsType(chartsType);
        }
        
        // 统计开始期
        String startDate = request.getParameter("startDate");
        if (StringUtils.isNotEmpty(startDate)) {
            analysisCriteria.setStartDate(startDate);
        }

        // 统计截止期
        String endDate = request.getParameter("endDate");
        String lastEndDate = null;
        if (StringUtils.isNotEmpty(endDate)) {
            lastEndDate = endDate;
            analysisCriteria.setEndDate(lastEndDate);
        }
        
        //省市县类型
        String deptQueryType = request.getParameter("deptQueryType");
        if (StringUtils.isNotEmpty(deptQueryType)) {
        	analysisCriteria.setDeptQueryType(deptQueryType);
        }		
        return analysisCriteria;
    }
    
    
}
