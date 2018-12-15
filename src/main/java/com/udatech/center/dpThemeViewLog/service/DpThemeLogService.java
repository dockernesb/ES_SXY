package com.udatech.center.dpThemeViewLog.service;

import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.List;
import java.util.Map;

public interface DpThemeLogService {

    /**
     * 
     * @Description: 查询表格相关数据
     * @param: @param msgType
     * @param: @param status
     * @param: @param beginDate
     * @param: @param endDate
     * @param: @param sblx
     * @param: @param page
     * @param: @return
     * @return: Pageable<Map<String,Object>>
     * @throws
     * @since JDK 1.7
     */
    Pageable<Map<String, Object>> getDataList(String msgType, String status, String beginDate, String endDate, String sblx, Page page);
    
    /**
     * 
     * @Description: 动态获取表格中的表字段名称
     * @param: @param msgType
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.7
     */
    List<Map<String, Object>> getTableColumn(String msgType);
    /**
     * 
     * @Description: 导出表格时获取到的所有字段信息
     * @param: @param msgType
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.7
     */
    List<Map<String, Object>> queryColumnData(String msgType);
}
