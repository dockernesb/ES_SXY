package com.udatech.common.statisAnalyze.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.udatech.common.statisAnalyze.vo.StatisticsCriteria;
import com.wa.framework.user.model.SysDepartment;


/**
 * 描述：统计分析公用service接口类,中心端
 * 创建人：caohy
 * 创建时间：2017年7月20日上午11:28:03
 * 修改人：caohy
 * 修改时间：2017年7月20日上午11:28:03
 */
public interface DataStatisticsCommonService {
    
    /**
     * @Description: 封装查询条件           
     * @param: @param request
     * @param: @return
     * @return: StatisticsCriteria
     * @throws
     * @since JDK 1.7.0_79
     */
    public StatisticsCriteria packageStatisticsCriteria(HttpServletRequest request) ;
    
    /**
     * @Description: 分别查询省市区的部门           
     * @param: @param queryType 1：市 2：区 3：省
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.7.0_79
     */
	public List<Map<String, Object>> getDeptListByType(String queryType);
}
