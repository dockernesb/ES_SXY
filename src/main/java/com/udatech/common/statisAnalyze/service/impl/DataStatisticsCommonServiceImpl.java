package com.udatech.common.statisAnalyze.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.udatech.common.statisAnalyze.dao.DataStatisCommonDao;
import com.udatech.common.statisAnalyze.service.DataStatisticsCommonService;
import com.udatech.common.statisAnalyze.vo.StatisticsCriteria;
import com.wa.framework.QueryCondition;
import com.wa.framework.log.ExpLog;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.model.SysDepartment;

/**
 * 描述：统计分析公用service实现类
 * 创建人：caohy
 * 创建时间：2017年7月20日上午11:31:13
 * 修改人：caohy
 * 修改时间：2017年7月20日上午11:31:13
 */
@Service
@ExpLog(type="统计分析公用类")
public class DataStatisticsCommonServiceImpl implements DataStatisticsCommonService {
    
    @Autowired
    private BaseService baseService;
    
	@Autowired
	private DataStatisCommonDao dataStatisCommonDao;
    
    /** 
     * @Description:封装查询条件 
     * @see： @see com.udatech.center.dataAnalysis.service.DataAnalysisCommonService#packageAnalysisCriteria(javax.servlet.http.HttpServletRequest)
     * @since JDK 1.7.0_79
     */
    @Override
    public StatisticsCriteria packageStatisticsCriteria(HttpServletRequest request) {
        StatisticsCriteria statisticsCriteria = new StatisticsCriteria();
        
        //主题 0:手动上传 2：文件上传 3：数据库 9：ftp上传
        String category = request.getParameter("category");
        if (StringUtils.isNotEmpty(category)) {
            statisticsCriteria.setCategory(category);
        }
        
        
        //部门
        String deptId = request.getParameter("deptId");
        if(StringUtils.isNotBlank(deptId)){
            statisticsCriteria.setDeptId(deptId);
        }
        
        
        //目录名称
        String tableName = request.getParameter("tableName");
        if(StringUtils.isNotEmpty(tableName)){
            statisticsCriteria.setTableName(tableName);
        }
        
        // 图表类别：1：饼图 2：趋势图 3：柱状图
        String chartsType= request.getParameter("chartsType");
        if (StringUtils.isNotEmpty(chartsType)) {
            statisticsCriteria.setChartsType(chartsType);
        }
        
        //部门名称
        String deptName = request.getParameter("deptName");
        if(StringUtils.isNotEmpty(deptName)&&StatisticsCriteria.TREND_DEPT.equals(statisticsCriteria.getChartsType())){
            SysDepartment dept = baseService.unique(SysDepartment.class, QueryCondition.eq("departmentName", deptName));
            if(dept != null){
                statisticsCriteria.setDeptId(dept.getId()); 
            }
        }
        
        // 统计开始期
        String startDate = request.getParameter("startDate");
        if (StringUtils.isNotEmpty(startDate)) {
            statisticsCriteria.setStartDate(startDate);
        }
        
        // 统计截止期
        String endDate = request.getParameter("endDate");
        String lastEndDate = null;
        if (StringUtils.isNotEmpty(endDate)) {
            lastEndDate = endDate;
            statisticsCriteria.setEndDate(lastEndDate);
        }
        
        //省市县类型
        String deptQueryType = request.getParameter("deptQueryType");
        if (StringUtils.isNotEmpty(deptQueryType)) {
            statisticsCriteria.setDeptQueryType(deptQueryType);
        }		
        return statisticsCriteria;
    }
    
    
    /**
     * @Description: 分别查询省市区的部门           
     * @param: @param queryType 1：市 2：区 3：省
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.7.0_79
     */
	public List<Map<String, Object>> getDeptListByType(String queryType) {
		List<SysDepartment> list = dataStatisCommonDao
				.getDeptListByType(queryType);
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("id", "   ");
		resultMap.put("text", "全部部门");
		resultList.add(resultMap);

		for (SysDepartment sys : list) {
			Map<String, Object> newResultMap = new HashMap<String, Object>();
			newResultMap.put("id", sys.getId());
			newResultMap.put("text", sys.getDepartmentName());
			resultList.add(newResultMap);
		}
		return resultList;
	}
    
}
