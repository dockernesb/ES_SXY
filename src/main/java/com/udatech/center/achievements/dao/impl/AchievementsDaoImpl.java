package com.udatech.center.achievements.dao.impl;

import com.udatech.center.achievements.dao.AchievementsDao;
import com.udatech.center.achievements.enmu.AchievementsStatus;
import com.udatech.center.achievements.enmu.AchievementsUploadFileEnmu;
import com.udatech.center.achievements.exception.AchievementsException;
import com.udatech.center.achievements.model.Achievements;
import com.udatech.center.achievements.model.AchievementsKpi;
import com.udatech.common.util.PropUtil;
import com.wa.framework.OrderProperty;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.QueryCondition;
import com.wa.framework.QueryConditions;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDaoImpl;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 描述：绩效考核     AchievementsDaoImpl 
 * 创建人： xulj
 * 创建时间：2017年12月9日上午9:23:52
 */
@Repository
public class AchievementsDaoImpl extends BaseDaoImpl implements AchievementsDao {

	/**
	 * 绩效考核列表
	 */
	@Override
	public Pageable<Achievements> getAchievementsList(
			Achievements achievements, Page page, SysUser user) {
		QueryConditions conditions = new QueryConditions();
        SysDepartment dept = achievements.getDept();
        if (dept != null) {
            String deptId = dept.getId();
            if (StringUtils.isNotBlank(deptId)) {
                conditions.add(QueryCondition.eq("dept.id", deptId));
            }
        }
        if ( "1".equals(user.getType()) || "0".equals(user.getType()) ) {
        	 conditions.add(QueryCondition.ne("status", AchievementsStatus.部门自评.getKey()));
        }
        if (StringUtils.isNotBlank(achievements.getYear())) {
            conditions.add(QueryCondition.eq("year", achievements.getYear()));
        }
        if (StringUtils.isNotBlank(achievements.getStatus())) {
            conditions.add(QueryCondition.eq("status", achievements.getStatus()));
        }
        List<OrderProperty> opList = new LinkedList<>();
        opList.add(OrderProperty.desc("year"));
        opList.add(OrderProperty.asc("status"));
        return this.findWithPage(Achievements.class, page, opList, conditions);

	}

    /**
     * 清除session中对象
     *
     * @param object
     */
    public void evict(Object object) {
        getSession().evict(object);
    }

    /**
     * 获取考核列表，导出用
     */
	@Override
	public List<Map<String, Object>> getAchievementsList(
			Achievements achievements) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		StringBuffer sb = new StringBuffer(" SELECT A.YEAR, C.DEPARTMENT_NAME, A.DEPT_SCORE, "
				+ " (SELECT REPLACE(WM_CONCAT(B.DEPT_DESC),',',';') FROM DT_ACHIEVEMENTS_KPI B "
				+ " WHERE B.ACHIEVEMENTS_ID = A.ID GROUP BY B.ACHIEVEMENTS_ID) DEPT_DESC, CENTER_SCORE, "
				+ " (SELECT REPLACE(WM_CONCAT(D.CENTER_DESC),',',';') FROM DT_ACHIEVEMENTS_KPI D "
				+ " WHERE D.ACHIEVEMENTS_ID = A.ID GROUP BY D.ACHIEVEMENTS_ID) CENTER_DESC, "
                + " CASE WHEN A.STATUS = '2' THEN '待评分' ELSE '已评分' END STATUS "
                + " FROM DT_ACHIEVEMENTS A "
				+ " JOIN SYS_DEPARTMENT C ON A.DEPT_ID = C.SYS_DEPARTMENT_ID WHERE A.STATUS <> '1' ");
		if ( StringUtils.isNotBlank(achievements.getYear()) ) {
			sb.append(" AND A.YEAR =:year");
			paramMap.put("year", achievements.getYear());
		}
		if ( achievements.getDept() != null &&  StringUtils.isNotBlank(achievements.getDept().getId())) {
			sb.append(" AND A.DEPT_ID =:deptId");
			paramMap.put("deptId", achievements.getDept().getId());
		}
		if ( StringUtils.isNotBlank(achievements.getStatus()) ) {
			sb.append(" AND A.STATUS =:status");
			paramMap.put("status", achievements.getStatus());
		}
		sb.append(" ORDER BY A.YEAR DESC, A.STATUS ASC ");
		return findBySql(sb.toString(), paramMap);
	}

	/**
	 * 获取kpi列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<AchievementsKpi> getAchievementsKpiList(String achievementsId) {
		Criteria criteria = getSession().createCriteria(AchievementsKpi.class);
		criteria.add(Restrictions.eq("achievementsId", achievementsId));
		criteria.addOrder(Order.asc("kpiItemCode"));
		return criteria.list();
	}

    /**
     * 检测今年是否已经添加过绩效考核
     * @param achievements
     */
    public void checkExist(Achievements achievements) {
        Criteria criteria = getSession().createCriteria(Achievements.class);
        criteria.add(Restrictions.eq("dept.id", achievements.getDept().getId()));
        criteria.add(Restrictions.eq("year", achievements.getYear()));
        @SuppressWarnings("unchecked")
		List<Achievements> list = criteria.list();
        if (list != null && !list.isEmpty()) {
            throw new AchievementsException("今年已添加过绩效考核，不能重复添加绩效考核！");
        }
    }

    /**
	 * @Description: 保存上传文件
	 * @param names
	 * @param paths
	 * @param type
	 * @param createUser
	 * @param businessId
	 * @return: void
	 */
	@Override
	public void saveUploadFiles(String[] names, String[] paths,
			AchievementsUploadFileEnmu type, String userId, String businessId) {
		if (names != null && paths != null && names.length == paths.length) {
			for (int i = 0, len = names.length; i < len; i++) {
				String name = names[i], path = paths[i];
				path = copyFileFromTemp(path);

				String icon = "";
				if (StringUtils.isNotBlank(name)) {
					int index = name.lastIndexOf(".");
					if (index >= 0) {
						String suffix = name.substring(index);
						icon = com.udatech.common.util.FileUtils
								.getIcon(suffix);
						icon = "/app/images/icon/" + icon;
					}
				}

				UploadFile uploadFile = new UploadFile();
				uploadFile.setUploadFileId(UUID.randomUUID().toString());
				uploadFile.setFileName(name);
				uploadFile.setFilePath(path);
				uploadFile.setFileType(type.getKey());
				uploadFile.setCreateDate(new Date());
				uploadFile.setCreateUser(new SysUser(userId));
				uploadFile.setBusinessId(businessId);
				uploadFile.setIcon(icon);
				this.save(uploadFile);
			}
		}
	}
	
	/**
	 * @Title: copyFileFromTemp
	 * @Description: 从临时目录拷贝文件到文件目录
	 * @param path
	 * @return
	 * @return: String
	 */
	private String copyFileFromTemp(String path) {
		if (StringUtils.isNotBlank(path)) {
			File srcFile = new File(path);

			String filePath = PropUtil.get("upload.file.path");
			File file = new File(filePath);
			if (!file.exists()) {
				file.mkdirs();
			}

			path = path.replaceAll("\\\\", "/");
			int index = path.lastIndexOf("/");
			String fileName = path.substring(index + 1);
			path = filePath + "/" + fileName;
			File destFile = new File(path);

			try {
				FileUtils.copyFile(srcFile, destFile);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return path;
	}

	/**
	 * @category 获取上传文件列表
	 * @param id
	 * @param type
	 * @return
	 */
	@Override
	public List<UploadFile> getUploadFiles(String id, AchievementsUploadFileEnmu type) {
	    QueryConditions query = new QueryConditions();
        query.addEq("businessId",id);
        query.addEq("fileType", type.getKey());
        List<UploadFile> list = this.find(UploadFile.class, query);
        return list;
	}

}
