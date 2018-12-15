package com.udatech.center.dpProvinceTheme.dao;

import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.List;
import java.util.Map;

public interface DpProvinceDao {
    /**
     * @Description: 查询表格中的数据
     * @param: @param msgType
     * @param: @param tableCoulmn
     * @param: @param coulmnValue
     * @param: @param beginDate
     * @param: @param endDate
     * @param: @param status
     * @param: @param page
     * @param: @return
     * @return: Pageable<Map<String,Object>>
     * @throws
     * @since JDK 1.7
     */
    Pageable<Map<String, Object>> getQueryList(String msgType, String tableCoulmn, String coulmnValue,
                                               String beginDate, String endDate, String status, Page page);

    /**
     * @Description: 获取到表格字段信息
     * @param: @param msgType
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.7
     */
    List<Map<String, Object>> getTableColumn(String msgType);

    /**
     * @Description: 单选提交数据（保存当前的状态和时间）
     * @param: @param id
     * @return: void
     * @throws
     * @since JDK 1.7
     */
    void changeProvinceStatus(String id, String msgType);

    /**
     * @Description: 单选提交数据（将单选的数据添加到dr表中）
     * @param: @param id
     * @param: @param msgType
     * @return: void
     * @throws
     * @since JDK 1.7
     */
    void insertData(String id, String msgType);

    Map<String, Object> getFindBySql(String sql, Map<String, Object> map);

    /**
     * @Description: 保存失败的状态以及插入失败的原因
     * @param: @param id
     * @return: void
     * @throws
     * @since JDK 1.7
     */
    void changeProvinceFailsStatus(String id, String msgType, String error);

}
