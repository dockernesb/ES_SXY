package com.wa.framework.user.dao.impl;

import com.udatech.common.constant.Constants;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.ComConstants;
import com.wa.framework.dao.BaseEntityDaoImpl;
import com.wa.framework.user.dao.SysDepartmentDao;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.base.BaseSysDepartment;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("departmentDao")
public class SysDepartmentDaoImpl extends BaseEntityDaoImpl<SysDepartment>
		implements SysDepartmentDao {

	@Override
	public Integer getSubCountByParentId(String parentId) {
		Criteria criteria = this.getSession().createCriteria(
				SysDepartment.class);
		criteria.add(Restrictions.eq("parentId", parentId));
		criteria.setProjection(Projections.rowCount());
		int totalRecords = ((Long) criteria.uniqueResult()).intValue();
		return totalRecords;
	}

	@Override
	public Integer getCountByDptName(String departmentName) {
		Criteria criteria = this.getSession().createCriteria(
				SysDepartment.class);
		criteria.add(Restrictions.eq("departmentName", departmentName));
		criteria.add(Restrictions.ne(SysDepartment.PROP_STATUS, ComConstants.DEPARTMENT_STATUS_DELETED));// 不等于删除状态
		criteria.setProjection(Projections.rowCount());
		int totalRecords = ((Long) criteria.uniqueResult()).intValue();
		return totalRecords;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<SysDepartment> getCountByDptList(String departmentName) {
		Criteria criteria = this.getSession().createCriteria(
				SysDepartment.class);
		criteria.add(Restrictions.eq("departmentName", departmentName));
		criteria.add(Restrictions.ne(SysDepartment.PROP_STATUS, ComConstants.DEPARTMENT_STATUS_DELETED));// 不等于删除状态
		List<SysDepartment> lst = criteria.list();
		return lst;
	}

	/**
	 * @category 校验是否存在此code
	 * @param code
	 * @param id
	 * @return
	 */
	@Override
	public boolean checkSameCode(String code, String id) {
		Criteria criteria = this.getSession().createCriteria(
				SysDepartment.class);
		criteria.add(Restrictions.eq("code", code));
		if (StringUtils.isNotBlank(id)) {
			criteria.add(Restrictions.not(Restrictions.eq("id", id)));
		}
		criteria.setProjection(Projections.rowCount());
		criteria.add(Restrictions.ne(SysDepartment.PROP_STATUS, ComConstants.DEPARTMENT_STATUS_DELETED));// 不等于删除状态
		int totalRecords = ((Long) criteria.uniqueResult()).intValue();
		return totalRecords > 0;
	}

	@Override
	public Integer getCountByDptName(String dptName, String parentId) {

		Criteria criteria = this.getSession().createCriteria(
				SysDepartment.class);
		criteria.add(Restrictions.eq("departmentName", dptName));
		criteria.add(Restrictions
				.eq(BaseSysDepartment.PROP_PARENT_ID, parentId));
		criteria.setProjection(Projections.rowCount());
		int totalRecords = ((Long) criteria.uniqueResult()).intValue();
		return totalRecords;
	}

	@Override
	public Pageable<SysDepartment> getDeptList(DetachedCriteria criteria, Page page) {
		return findByDetachedCriteriaWithPage(criteria, page);
	}

    @SuppressWarnings("unchecked")
    @Override
    public List<SysDepartment> getDeptListByUserTpye(String userType) {
        Criteria criteria = this.getSession().createCriteria(SysDepartment.class);
		if (StringUtils.equals(userType, "2")) {    //  业务端
			Criterion zx = Restrictions.eq("code", Constants.CENTER_DEPT_CODE);
			Criterion qx = Restrictions.like("code", "B%");
			criteria.add(Restrictions.or(zx, qx));
		} else if (StringUtils.equals(userType, "3")) { //  政务端
			criteria.add(Restrictions.ne("code", Constants.CENTER_DEPT_CODE));
		} else {    //  管理员, 中心端
			criteria.add(Restrictions.eq("code", Constants.CENTER_DEPT_CODE));
		}
        criteria.add(Restrictions.ne(SysDepartment.PROP_STATUS, ComConstants.DEPARTMENT_STATUS_DELETED));// 不等于删除状态
        criteria.addOrder(Order.asc(SysDepartment.PROP_DEPARTMENT_NAME));
        criteria.addOrder(Order.asc(SysDepartment.PROP_ID));
        return criteria.list();
    }

	@Override
	public List<SysDepartment> getDeptListByDataSource(String dataSource) {
		Criteria criteria = this.getSession().createCriteria(SysDepartment.class);
		if ("A".equals(dataSource)) {
			criteria.add(Restrictions.eq("code", Constants.CENTER_DEPT_CODE));
		} else if ("B".equals(dataSource)) {
			criteria.add(Restrictions.like("code", "B%"));
		} else {
			Criterion zx = Restrictions.eq("code", Constants.CENTER_DEPT_CODE);
			Criterion qx = Restrictions.like("code", "B%");
			criteria.add(Restrictions.or(zx, qx));
		}
		criteria.add(Restrictions.ne(SysDepartment.PROP_STATUS, ComConstants.DEPARTMENT_STATUS_DELETED));
		criteria.addOrder(Order.asc(SysDepartment.PROP_DEPARTMENT_NAME));
		criteria.addOrder(Order.asc(SysDepartment.PROP_ID));
		return criteria.list();
	}

}
