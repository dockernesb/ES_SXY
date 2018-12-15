package com.udatech.common.statisAnalyze.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.udatech.common.statisAnalyze.dao.DataStatisCommonDao;
import com.udatech.common.statisAnalyze.model.DataSize;
import com.wa.framework.dao.BaseDaoSupport;
import com.wa.framework.user.model.SysDepartment;

/**
 * @category 数据量统计
 * @author Administrator
 */
@Repository
public class DataStatisCommonDaoImpl extends BaseDaoSupport implements DataStatisCommonDao {
    
    /**
     * @Description: 分别查询省市区的部门           
     * @param: @param queryType 1：市 2：区 3：省
     * @param: @return
     * @return: List<SysDepartment>
     * @throws
     * @since JDK 1.7.0_79
     */
    public List<SysDepartment> getDeptListByType(String queryType) {
		StringBuffer str = new StringBuffer();
		str.append(" select * from sys_department ");
		if(DataSize.CITY.equals(queryType)){
			str.append(" where code like 'A%' " );
		}else if(DataSize.AREA.equals(queryType)){
			str.append(" where code like 'B%' " );
		}else if(DataSize.PROVINCE.equals(queryType)){
			str.append(" where code like 'C%' " );
		}
		return this.findBySql(str.toString(),SysDepartment.class);
	}



}
