package com.udatech.center.dpChineseTheme.dao;

import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDao;

import java.util.List;
import java.util.Map;

public interface DpChineseDao extends BaseDao {

    /**
     * @Description: 获取表格中的数据信息
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
    Pageable<Map<String, Object>> getQueryList(String msgType,String tableCoulmn,String coulmnValue,String beginDate,
                                               String endDate,String status ,Page page);
    /**
     * @Description: 获取双公示信息表的字段信息
     * @param: @param msgType
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.7
     */
    List<Map<String, Object>> getTableColumn(String msgType);
    /**
     *
     * @Description: 单选提交数据（保存当前的状态和时间）
     * @param: @param id
     * @return: void
     * @throws
     * @since JDK 1.7
     */
    void changeProvinceStatus(String id,String msgType,String resultType,String error);

    /**
     *
     * @Description: 单选提交数据（将单选的数据添加到dr表中）
     * @param: @param id
     * @param: @param msgType
     * @return: void
     * @throws
     * @since JDK 1.7
     */
    void insertData(String id,String msgType);


    Map<String, Object> getFindBySql(String sql, Map<String,Object> map);
}
