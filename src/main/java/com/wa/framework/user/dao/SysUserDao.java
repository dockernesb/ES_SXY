package com.wa.framework.user.dao;

import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseEntityDao;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;

import java.util.List;
import java.util.Map;

/**
 * 描述：用户dao
 * 创建人：guoyt
 * 创建时间：2017年2月27日下午4:50:05
 * 修改人：guoyt
 * 修改时间：2017年2月27日下午4:50:05
 */
public interface SysUserDao extends BaseEntityDao<SysUser> {

	/**
	 * @Description: 按照用户名分页查询
	 * @param: @param page
	 * @param: @param name
	 * @param: @param depart
	 * @param: @param status
	 * @param: @return
	 * @return: Pageable<SysUser>
	 * @throws
	 * @since JDK 1.6
	 */
	public Pageable<SysUser> findUserWithName(Page page, String name, String realName, String depart, String status, String type);
	
	/**
	 * @Description: 查找所有未删除的启用状态的用户，并按照姓名排序（支持中文）
	 * @param: @return
	 * @return: List<SysUser>
	 * @throws
	 * @since JDK 1.6
	 */
	public List<SysUser> findUserOrderByName();
	
	/**
	 * @Description: 根据用户id查找部门
	 * @param: @param userId
	 * @param: @return
	 * @return: SysDepartment
	 * @throws
	 * @since JDK 1.6
	 */
	public SysDepartment findDepWithUserId(String userId);
	
	/**
	 * @Description: 根据用户Id获取用户信息
	 * @param: @param userId
	 * @param: @return
	 * @return: Map<String,Object>
	 * @throws
	 * @since JDK 1.6
	 */
	public Map<String, Object> findUserById(String userId);
	
	 /**
     * @Title: findUserPhoto
     * @Description: 查询用户头像路径
     * @param user
     * @return boolean
     */
	public String findUserPhoto(String userId);
	
	 /**
     * @Title: findExsitUserById
     * @Description: 根据用户id查找用户信息
     * @param sysuserid
     * @return
     * @return: SysUser
     */
    public SysUser findExsitUserById(String userId);
    
	 /**
     * @Title: userEdit
     * @Description: 修改资料
     * @param user
     * @return boolean
     */
    public boolean userEdit(SysUser user);
    
    /**
     * @Title: findUserPhotoFile
     * @Description: 查找用户头像
     * @param user
     * @return boolean
     */
    public UploadFile findUserPhotoFile(String userId);

	public Pageable<SysUser> findUserWithName(Page page, String name, String depart, String status);
	
}
