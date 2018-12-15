package com.udatech.center.operationAnalysis.service;

import com.udatech.center.operationAnalysis.vo.OperationCriteria;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 描述：运行分析公用service（中心端）
 * 创建人：guoyt
 * 创建时间：2017年2月3日上午10:57:52
 * 修改人：guoyt
 * 修改时间：2017年2月3日上午10:57:52
 */
public interface OpeCommonService {
    
    /**
     * @Description: 封装request里面的搜索条件
     * @param: @param request
     * @param: @return
     * @return: OperationCriteria
     * @throws
     * @since JDK 1.6
     */
    public OperationCriteria packageOperationCriteria(HttpServletRequest request);
    
    /**
     * @Description: 封装X轴category信息
     * @param: @param allDataMap sql查询出来的所有数据
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getChartCategory(Map<String, Object> allDataMap);
    
    /**
     * @Description: 封装柱状图、饼图、折线图、条形图数据信息
     * @param: @param allDataMap sql查询出来的所有数据
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getChartDatas(Map<String, Object> allDataMap);
    
}
