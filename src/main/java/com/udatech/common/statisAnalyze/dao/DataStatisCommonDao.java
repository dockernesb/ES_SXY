package com.udatech.common.statisAnalyze.dao;

import java.util.List;

import com.wa.framework.user.model.SysDepartment;

/**
 * @author caohy
 * 数据量统计公共Dao
 */
public interface DataStatisCommonDao {
	
	/**
     * @Description: 分别查询省市区的部门           
     * @param: @param queryType 1：市 2：区 3：省
     * @param: @return
     * @return: List<SysDepartment>
     * @throws
     * @since JDK 1.7.0_79
     */
	public List<SysDepartment> getDeptListByType(String queryType) ;
}
