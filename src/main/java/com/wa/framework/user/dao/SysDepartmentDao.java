package com.wa.framework.user.dao;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;

import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseEntityDao;
import com.wa.framework.user.model.SysDepartment;

public interface SysDepartmentDao extends BaseEntityDao<SysDepartment> {

	public Integer getSubCountByParentId(String parentId);

	public Integer getCountByDptName(String dptName);

	public Integer getCountByDptName(String dptName, String parentId);

	public List<SysDepartment> getCountByDptList(String dptName);

	/**
	 * @category 校验是否存在此code
	 * @param code
	 * @param id
	 * @return
	 */
	boolean checkSameCode(String code, String id);

	public Pageable<SysDepartment> getDeptList(DetachedCriteria criteria, Page page);

    public List<SysDepartment> getDeptListByUserTpye(String userType);
	public List<SysDepartment> getDeptListByDataSource(String dataSource);
}
