package com.udatech.center.operationAnalysis.service.impl;

import com.udatech.center.operationAnalysis.service.OpeCommonService;
import com.udatech.center.operationAnalysis.vo.OperationCriteria;
import com.udatech.common.constant.Constants;
import com.udatech.common.util.ReportDateUtil;
import com.wa.framework.log.ExpLog;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.util.DateUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 描述：运行分析公用service实现类（中心端）
 * 创建人：guoyt
 * 创建时间：2017年2月3日上午10:58:12
 * 修改人：guoyt
 * 修改时间：2017年2月3日上午10:58:12
 */
@Service
@ExpLog(type="运行分析管理")
public class OpeCommonServiceImpl  extends BaseService implements OpeCommonService {
    
    /** 
     * @Description: 封装request里面的搜索条件
     * @see： @see com.udatech.center.operationAnalysis.service.OpeCommonService#packageOperationCriteria(javax.servlet.http.HttpServletRequest)
     * @since JDK 1.6
     */
    @Override
    public OperationCriteria packageOperationCriteria(HttpServletRequest request) {
        OperationCriteria operationCriteria = new OperationCriteria();
        
        // 统计主题：1-信用报告统计；2-异议处理统计；3-信用修复统计；4-信用核查统计；5-双公示统计
        String category = request.getParameter("category");
        if (StringUtils.isNotEmpty(category)) {
            operationCriteria.setCategory(category);
        }
        
        String department = request.getParameter("department");
        if (StringUtils.isNotEmpty(department)) {
            String bmbm = findById(SysDepartment.class, department).getCode();
            operationCriteria.setDepartment(bmbm);
        }
        
        // 维度分析：1-申诉内容分析； 2-数据提供部门分析； 3-修复内容分析；4-审查类别分析；5-申请部门分析
        String dimension = request.getParameter("dimension");
        if (StringUtils.isNotEmpty(dimension)) {
            operationCriteria.setDimension(dimension);
        }
        
        // 图表主题：1-内容分析； 2-内容趋势
        String chartTheme= request.getParameter("chartTheme");
        if (StringUtils.isNotEmpty(chartTheme)) {
        	operationCriteria.setChartTheme(chartTheme);
        }
        
        // 趋势类别：1-累计；2-新增
        String trendType = request.getParameter("trendType");
        if (StringUtils.isNotEmpty(trendType)) {
            operationCriteria.setTrendType(trendType);
        }
        
        // 根据主表联动查询
        String parentCondition = request.getParameter("parentCondition");
        if (StringUtils.isNotEmpty(parentCondition)) {
            operationCriteria.setParentCondtion(parentCondition);
        }
        
        // 1-行政许可；2-行政处罚
        String publicityType = request.getParameter("publicityType");
        if (StringUtils.isNotEmpty(publicityType)) {
            operationCriteria.setPublicityType(publicityType);
        }

        //自然人与法人
        String personType = request.getParameter("personType");
        if (StringUtils.isNotEmpty(personType)) {
            operationCriteria.setPersonType(personType);
        }

        //市辖部门和区县板块
        String dataSource = request.getParameter("dataSource");
        if (StringUtils.isNotEmpty(dataSource)) {
            operationCriteria.setDataSource(dataSource);
        }

        //办件部门
        String department_bj = request.getParameter("department_bj");
        if (StringUtils.isNotEmpty(department_bj)) {
            operationCriteria.setDepartment_bj(department_bj);
        }

        String data = request.getParameter("data");
        if (StringUtils.isNotEmpty(data)) {
            operationCriteria.setData(data);
        }
        
        // 统计开始期
        String startDate = request.getParameter("startDate");
        if (StringUtils.isNotEmpty(startDate)) {
            operationCriteria.setStartDate(startDate + Constants.START_SUFFIX);
        }
        
        // 统计截止期
        String endDate = request.getParameter("endDate");
        String lastEndDate = null;
        if (StringUtils.isNotEmpty(endDate)) {
            lastEndDate = endDate + Constants.END_SUFFIX;
        } else {
            // 设置统计结束时间为选择时间此月的最后一天，双公示统计除外
            if ((StringUtils.isNotEmpty(category) && !Constants.CATEGORY_DOUBLE_PUBLICITY.equals(category)
            		&&!Constants.MONTH_HANDLE.equals(chartTheme))) {
                lastEndDate = DateUtils.format(new Date(), DateUtils.YYYYMMDDHHMMSS_19);
                lastEndDate = ReportDateUtil.getEndDayOfMonth(lastEndDate, DateUtils.YYYYMMDDHHMMSS_19);
            }
        }
        if (StringUtils.isNotEmpty(lastEndDate)){
            operationCriteria.setEndDate(lastEndDate);
        }
        
        return operationCriteria;
    }
    
    /**
     * @Description: 封装X轴category信息
     * @param: @param allDataMap sql查询出来的所有数据
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getChartCategory(Map<String, Object> allDataMap) {
        Map<String, Object> categoryMap = new HashMap<String, Object>();
        for (Entry<String, Object> main : allDataMap.entrySet()) {
            String key = main.getKey();
            Object value = main.getValue();
            
            if (Constants.CATEGORY.equals(key)){
                categoryMap.put(key, value);
            }
        }
        
        return categoryMap;
    }
    
    /**
     * @Description: 封装柱状图、饼图、折线图、条形图数据信息
     * @param: @param allDataMap sql查询出来的所有数据
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getChartDatas(Map<String, Object> allDataMap) {
        Map<String, Object> dataMap = new HashMap<String, Object>();
        for (Entry<String, Object> main : allDataMap.entrySet()) {
            String key = main.getKey();
            Object value = main.getValue();
            
            if (!Constants.CATEGORY.equals(key)){
                dataMap.put(key, value);
            }
        }
        
        return dataMap;
    }
    
}
