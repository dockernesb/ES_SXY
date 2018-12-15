package com.wa.framework.user.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.QueryConditions;
import com.wa.framework.common.ComConstants;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.dao.SysDepartmentDao;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;

@Service("departmentService")
public class DepartmentService extends BaseService {

	@Autowired
	@Qualifier("departmentDao")
	private SysDepartmentDao departmentDao;

	public void addDepartment(String name, String parentId, String description,
			String adminUserId, String code) {
		SysDepartment department = new SysDepartment();
		department.setDepartmentName(name);
		department.setDescription(description);
		department.setAdminUserId(adminUserId);
		department.setParentId(parentId);
		department.setCode(code);
		department.setStatus(ComConstants.DEPARTMENT_STATUS_ADD);
		if (StringUtils.isNotBlank(adminUserId)) {
			SysUser user = baseDao.get(SysUser.class, adminUserId);
			user.setIsDepatmentAdmin("1");
			baseDao.update(user);
		}
		departmentDao.save(department);
	}

	public void editDepartment(String id, String name, String description,
			String adminUserId, String code) {
		SysDepartment department = departmentDao.get(id);
		String oldAdminUserId = department.getAdminUserId();
		department.setDepartmentName(name);
		department.setAdminUserId(adminUserId);
		department.setDescription(description);
		department.setCode(code);
		if (StringUtils.isNotBlank(adminUserId)) {
			SysUser user = baseDao.get(SysUser.class, adminUserId);
			user.setIsDepatmentAdmin("1");
			baseDao.update(user);
		}
		if (StringUtils.isNotBlank(oldAdminUserId)) {
			// 如果修改负责人为空，需要设置原来旧的用户是否负责人为0，设置之前需要查看还有没有其他人设置此用户为负责人
			QueryConditions queryConditions = new QueryConditions();
			queryConditions.addEq(SysDepartment.PROP_ADMIN_USERID,
					oldAdminUserId);
			List<SysDepartment> depList = find(SysDepartment.class,
					queryConditions);
			if (depList != null && depList.size() < 1) {
				SysUser user = baseDao.get(SysUser.class, oldAdminUserId);
				user.setIsDepatmentAdmin("0");
				baseDao.update(user);
			}
		}
		departmentDao.update(department);
	}

	public boolean deleteDepartment(String id) {
		int subCount = departmentDao.getSubCountByParentId(id);
		if (subCount == 0) {
			SysDepartment department = departmentDao.get(id);
			if (department.getSysUsers() != null
					&& department.getSysUsers().size() > 0) {
				return false;
			}

			String oldAdminUserId = department.getAdminUserId();
			if (StringUtils.isNotBlank(oldAdminUserId)) {
				// 如果删除部门，需要设置原来旧的用户是否负责人为0，设置之前需要查看还有没有其他人设置此用户为负责人
				QueryConditions queryConditions = new QueryConditions();
				queryConditions.addEq(SysDepartment.PROP_ADMIN_USERID,
						oldAdminUserId);
				List<SysDepartment> depList = find(SysDepartment.class,
						queryConditions);
				if (depList != null && depList.size() <= 1) {
					SysUser user = baseDao.get(SysUser.class, oldAdminUserId);
					user.setIsDepatmentAdmin("0");
					baseDao.update(user);
				}
			}

			department.setStatus(ComConstants.DEPARTMENT_STATUS_DELETED);
            departmentDao.update(department);
			return true;
		} else {
			return false;
		}
	}

	public Integer getCountByDptName(String dptName) {
		int count = departmentDao.getCountByDptName(dptName);
		return count;

	}

	public Integer getCountByDptName(String dptName, String parentId) {
		int count = departmentDao.getCountByDptName(dptName, parentId);
		return count;

	}

	// 根据部门名称查询对象
	public SysDepartment getCountByDpt(String dptName) {
		SysDepartment sysDpt = null;
		List<SysDepartment> lst = departmentDao.getCountByDptList(dptName);
		if (lst.size() != 0) {
			sysDpt = lst.get(0);
		}
		return sysDpt;

	}

	/**
	 * @category 校验是否存在此code
	 * @param code
	 * @param id
	 * @return
	 */
	public boolean checkSameCode(String code, String id) {
		return departmentDao.checkSameCode(code, id);
	}

	// 根据所有父级部门
	public List<SysDepartment> getParentMenus(
			List<SysDepartment> sysDepartments, String childValue) {
		List<SysDepartment> parentList = new ArrayList<SysDepartment>();
		for (SysDepartment sysDepartment : sysDepartments) {
			String id = sysDepartment.getId();
			if (!id.equals("ROOT")) {
				if (id == childValue
						|| (childValue != null && id.equals(childValue))) {
					String parentId = sysDepartment.getParentId();
					List<SysDepartment> subList = getParentMenus(
							sysDepartments, parentId);
					if (subList.size() > 0) {
						parentList.addAll(subList);
					}
					parentList.add(sysDepartment);
				}
			}
		}
		return parentList;
	}

	public Pageable<SysDepartment> getDeptList(DetachedCriteria criteria, Page page) {
		return departmentDao.getDeptList(criteria, page);
	}

	/**
	 * @Description 根据用户类型获取部门列表
	 * @param userType
	 * @return
	 */
    public List<SysDepartment> getDeptListByUserTpye(String userType) {
        return departmentDao.getDeptListByUserTpye(userType);
    }
	/**
	 * @Description 根据用户类型获取部门列表
	 * @param userType
	 * @return
	 */
	public List<SysDepartment> getDeptListByDataSource(String dataSource) {
		return departmentDao.getDeptListByDataSource(dataSource);
	}
}
