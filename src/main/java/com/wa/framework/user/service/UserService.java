package com.wa.framework.user.service;

import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.QueryConditions;
import com.wa.framework.UserIdThreadLocal;
import com.wa.framework.common.CacheConstants;
import com.wa.framework.common.cache.CacheFactory;
import com.wa.framework.common.dao.CommonDao;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.common.vo.UserPrivilegeVo;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.dao.SysMenuDao;
import com.wa.framework.user.dao.SysUserDao;
import com.wa.framework.user.model.*;
import com.wa.framework.util.PropertyUtils;
import com.wa.framework.util.SecurityUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.util.*;

@Service("userService")
public class UserService extends BaseService {
	


    private static final Log logger = LogFactory.getLog(UserService.class);
    
    @Autowired
    @Qualifier("userDao")
    private SysUserDao userDao;
    
    @Autowired
    @Qualifier("menuDao")
    private SysMenuDao menuDao;
    
    @Autowired
    private CommonDao commonDao;

    private String md5Code;

    /**
     * @Description: 按照用户名分页查询
     * @param: @param page
     * @param: @param name
     * @param: @return
     * @return: Pageable<SysUser>
     * @throws
     * @since JDK 1.6
     */
    public Pageable<SysUser> findUserWithName(Page page, String name,String realName, String depart, String status,String type) {
        Pageable<SysUser> list = userDao.findUserWithName(page, name,realName, depart, status, type);
        return list;
    }
    public Pageable<SysUser> findUserWithName(Page page, String name, String depart, String status) {
        Pageable<SysUser> list = userDao.findUserWithName(page, name, depart, status);
        return list;
    }

    /**
     * @Description: 根据部门id查询部门下的用户列表
     * @param: @param departmentId
     * @param: @return
     * @return: List<SysUser>
     * @throws
     * @since JDK 1.6
     */
    public List<SysUser> findUserByDepartmentId(String departmentId) {
        SysDepartment department = baseDao.get(SysDepartment.class,
                departmentId);
        if (department != null) {
            List<SysUser> list = new LinkedList<SysUser>();
            for (SysUser sysUser : department.getSysUsers()) {
                if (sysUser.getState().equals("1")) {
                    list.add(sysUser);
                }
            }
            return list;
        }
        return null;
    }

    /**
     * 增加新用户
     * 
     * @param user
     * @param departmentId
     * @return 0=success, 1=department not exist, 2=username exist
     */
    public int addUser(SysUser user, String departmentId) {
        SysDepartment department = baseDao.get(SysDepartment.class,
                departmentId);
        if (department != null) {
            SysUser existUser = commonDao.findUserWithName(user.getUsername());
            if (existUser == null) {
                user.setState("1");
                user.setPrivilegesCount(0);
                user.setRolesCount(0);
                user.setPassword(SecurityUtil.MD5String(user.getPassword() + md5Code + user.getUsername()));
                user.setSysDepartment(department);

                baseDao.save(user);
                
                return 0;
            } else {
                return 2;
            }
        } else {
            return 1;
        }
    }

    /**
     * @Description: 逻辑删除用户
     * @param: @param id
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public void deleteUserInlogic(String id) {
        SysUser sysUser = userDao.get(id);
        if (sysUser != null) {
        	sysUser.setState("0");
            sysUser.setSysDepartment(null);
            sysUser.setIsDepatmentAdmin("0");
            userDao.update(sysUser);
            
            QueryConditions queryConditions = new QueryConditions();
        	queryConditions.addEq(SysDepartment.PROP_ADMIN_USERID, sysUser.getId());
        	List<SysDepartment> depList = find(SysDepartment.class, queryConditions);
            
            if (depList != null && depList.size() > 0){
            	for (SysDepartment department : depList){
            		department.setAdminUserId(null);
                	baseDao.update(department);
            	}
        	}
            
            // 移除缓存中的用户权限关系
            CacheFactory.getInstance().removeCacheByKey(CacheConstants.USER_PRIVILEGE_MAP, sysUser.getId());
            
            // 移除缓存中的用户角色关系
            CacheFactory.getInstance().removeCacheByKey(CacheConstants.USER_ROLE_MAP, sysUser.getId());
        }
    }

    /**
     * @Description: 启用/禁用用户
     * @param: @param id
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public void enable(String id) {
        SysUser existUser = userDao.get(id);
        if (existUser != null) {
            existUser.setEnabled(!existUser.isEnabled());
            userDao.update(existUser);
        }
    }

   
    /**
     * @Description: 根据用户Id获取用户信息
     * @param: @param id
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getUserById(String id) {
        Map<String, Object> sysUser = userDao.findUserById(id);

        return sysUser;
    }
    
    /**
     * @Description: 修改用户所属部门
     * @param: @param user
     * @param: @param userId
     * @param: @param departmentId
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public void updateUser(SysUser user, String userId, String departmentId) {
        SysUser existUser = userDao.get(userId);
        if (existUser != null) {
            SysDepartment departmentOld = existUser.getSysDepartment();
            SysDepartment department = baseDao.get(SysDepartment.class, departmentId);
            if (department != null) {
                existUser.setSysDepartment(department);
                existUser.setAddress(user.getAddress());
                existUser.setGender(user.isGender());
                existUser.setEmail(user.getEmail());
                existUser.setIdCard(user.getIdCard());
                existUser.setRealName(user.getRealName());
                existUser.setPhoneNumber(user.getPhoneNumber());
                existUser.setType(user.getType());
                // 检查用户所属部门是否修改, 如果修改并且用户是以前部门的管理员，是的话则删除管理员身份
                if (!departmentOld.getId().equals(department.getId())) {
                    if (null == departmentOld.getAdminUserId() || "".equals(departmentOld.getAdminUserId())) {
                        departmentOld.setAdminUserId("");
                        baseDao.update(departmentOld);
                    } else if (departmentOld.getAdminUserId().equals(existUser.getId())) {
                        departmentOld.setAdminUserId("");
                        baseDao.update(departmentOld);
                    }
                }
                userDao.update(existUser);
            }
        }
    }

    /**
     * @Description: 重置用户密码
     * @param: @param userId
     * @param: @param password
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public void resetPassword(String userId, String password) {
        SysUser existUser = userDao.get(userId);
        if (existUser != null) {
            existUser.setPassword(SecurityUtil.MD5String(password + md5Code + existUser.getUsername()));
            userDao.update(existUser);
        }
    }

    /**
     * @Description: 根据用户id获取这个用户所拥有的权限的id集合和角色的id集合
     * @param: @param userId
     * @param: @return
     * @return: Map<String,List<Object>>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, List<Object>> getRoleIdsAndPrivilegeIdsByUserId(
            String userId) {
        SysUser user = userDao.get(userId);
        if (user != null) {
            try {
                Map<String, List<Object>> result = new HashMap<String, List<Object>>();
                List<Object> privilegeIds = PropertyUtils.getProperties(
                        user.getSysPrivileges(), SysPrivilege.PROP_ID);
                List<Object> roleIds = PropertyUtils.getProperties(user.getSysRoles(), SysRole.PROP_ID);
                result.put("privilegeIds", privilegeIds);
                result.put("roleIds", roleIds);
                return result;
            } catch (IllegalAccessException e) {
                logger.error(e.getMessage(), e);
            } catch (InvocationTargetException e) {
                logger.error(e.getMessage(), e);
            } catch (NoSuchMethodException e) {
                logger.error(e.getMessage(), e);
            }
        }
        return null;
    }

    /**
     * 用户授权
     * 
     * @param userId
     *            被授权的用户id
     * @param rids
     *            授予的角色的id的集合
     * @param pids
     *            授予的权限的id的集合
     */
    public void grantUser(String userId, String[] rids, String[] pids) {
        SysUser user = userDao.get(userId);
        if (user != null) {
            List<SysPrivilege> privileges = null;
            List<SysRole> roles = null;
            if (pids != null && pids.length > 0) {
                privileges = baseDao.getByIds(SysPrivilege.class, pids);
                user.setSysPrivileges(new HashSet<SysPrivilege>(privileges));
            } else {
                user.setSysPrivileges(null);
            }
            if (rids != null && rids.length > 0) {
                roles = baseDao.getByIds(SysRole.class, rids);
                user.setSysRoles(new HashSet<SysRole>(roles));
            } else {
                user.setSysRoles(null);
            }
            userDao.save(user);
            
            if (pids != null && pids.length > 0) {
                // 刷新缓存中的用户权限关系
                if (privileges != null){
                    refreshUserPrivilegeVo(new HashSet<SysPrivilege>(privileges), user);
                }
            } else {
                // 移除缓存中的用户权限关系
                CacheFactory.getInstance().removeCacheByKey(CacheConstants.USER_PRIVILEGE_MAP, user.getId());
            }
            
            if (rids != null && rids.length > 0) {
                // 刷新缓存中的用户角色关系
                if (roles != null){
                    refreshUserRoleVo(rids, user);
                }
            } else {
                // 移除缓存中的用户角色关系
                CacheFactory.getInstance().removeCacheByKey(CacheConstants.USER_ROLE_MAP, user.getId());
            }
        }
    }
    
    /**
     * @Description: 刷新缓存中的用户权限关系
     * @param: @param filterdPrivileges
     * @param: @param user
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    private void refreshUserPrivilegeVo(Set<SysPrivilege> privileges, SysUser user) {
        Set<Object> voSet = new HashSet<Object>();
        for (SysPrivilege sysPrivilege : privileges) {
            UserPrivilegeVo vo = new UserPrivilegeVo();
            vo.setPrivilegeId(sysPrivilege.getId());
            vo.setPrivilegeCode(sysPrivilege.getPrivilegeCode());
            vo.setMenuId(sysPrivilege.getSysMenu().getId());
            voSet.add(vo);
        }
        CacheFactory.getInstance().refreshCacheSet(CacheConstants.USER_PRIVILEGE_MAP, user.getId(), voSet);
    }
    
    /**
     * @Description: 刷新缓存中的用户角色关系
     * @param: @param filterdPrivileges
     * @param: @param user
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    private void refreshUserRoleVo(String[] rids, SysUser user) {
        Set<Object> roleIdSet = new HashSet<Object>();
        CollectionUtils.addAll(roleIdSet, rids);  
        CacheFactory.getInstance().refreshCacheSet(CacheConstants.USER_ROLE_MAP, user.getId(), roleIdSet);
    }

    /**
     * currentUserId对应的用户必须是部门的管理员, 根据currentUserId查找用户所属的部门, 返回这个部门下的其他用户,
     * 不包括currentUserId自己
     * 
     * @param userId
     * @return
     */
    public List<SysUser> findUserListByCurrentUser() {
        String currentUserId = UserIdThreadLocal.getInstance().getUserId();
        SysUser user = userDao.get(currentUserId);
        if (user != null) {
            SysDepartment department = user.getSysDepartment();
            // 检查用户是否是部门的管理员
            if (department.getAdminUserId().equals(user.getId())) {
                List<SysUser> list = new LinkedList<SysUser>();
                for (SysUser sysUser : department.getSysUsers()) {
                    if (sysUser.getState().equals("1")) {
                        list.add(sysUser);
                    }
                }
                for (int i = 0; i < list.size(); i++) {
                    if (list.get(i).getId().equals(currentUserId)) {// 将用户自己从列表中删除
                        list.remove(i);
                        i--;
                    }
                }
                return list;
            }
        }
        return null;
    }

    /**
     * 增加新用户, 新用户所属部门是curreserId所属部门
     * 
     * @param user
     * @param departmentId
     * @return 0=success, 1=username exist, 2=current user is not administrator,
     *         3=current user not exist
     */
    public int addUserWithCurrentUser(SysUser user) {
        String currentUserId = UserIdThreadLocal.getInstance().getUserId();
        SysUser currentUser = userDao.get(currentUserId);
        if (currentUser != null) {
            SysDepartment department = currentUser.getSysDepartment();
            // 检查当前用户是否是部门的管理员
            if (department.getAdminUserId().equals(currentUser.getId())) {
                // 检查用户名是否重复
                SysUser existUser = commonDao.findUserWithName(user.getUsername());
                if (existUser == null) {
                    user.setState("1");
                    user.setPrivilegesCount(0);
                    user.setRolesCount(0);
                    user.setPassword(SecurityUtil.MD5String(user.getPassword()));
                    user.setSysDepartment(department);
                    baseDao.save(user);
                    return 0;
                } else {
                    return 1;
                }
            } else
                return 2;
        } else
            return 3;
    }

    /**
     * 部门管理员删除部门下的人员
     * 
     * @param userId
     * @param currentUserId
     * @return
     */
    public boolean deleteUserByCurrentUser(String userId) {
        String currentUserId = UserIdThreadLocal.getInstance().getUserId();
        if (!userId.equals(currentUserId)) {// 不能删除当前用户自己
            SysUser currentUser = userDao.get(currentUserId);
            if (currentUser != null) {
                SysDepartment department = currentUser.getSysDepartment();
                // 检查当前用户是否是部门的管理员
                if (department.getAdminUserId().equals(currentUser.getId())) {
                    SysUser deleteUser = userDao.get(userId);
                    // 检查被删除用户是否存在
                    if (deleteUser != null) {
                        // 检查被删除用户是否和当前用户在同一部门
                        if (deleteUser.getSysDepartment().getId().equals(department.getId())) {
                            deleteUser.setState("0");
                            userDao.update(deleteUser);
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    /**
     * @Description: 部门中启用、禁用用户
     * @param: @param userId
     * @param: @return
     * @return: boolean
     * @throws
     * @since JDK 1.6
     */
    public boolean enableUserByCurrentUser(String userId) {
        String currentUserId = UserIdThreadLocal.getInstance().getUserId();
        if (!userId.equals(currentUserId)) {// 不能修改当前用户自己
            SysUser currentUser = userDao.get(currentUserId);
            if (currentUser != null) {
                SysDepartment department = currentUser.getSysDepartment();
                // 检查当前用户是否是部门的管理员
                if (department.getAdminUserId().equals(
                        currentUser.getId())) {
                    SysUser enableUser = userDao.get(userId);
                    // 检查被修改用户是否存在
                    if (enableUser != null) {
                        // 检查被修改用户是否和当前用户在同一部门
                        if (enableUser.getSysDepartment().getId().equals(department.getId())) {
                            enableUser.setEnabled(!enableUser.isEnabled());
                            userDao.update(enableUser);
                        }
                    }
                }
            }
        }
        return false;
    }

    /**
     * 用户授权, 授权范围是currentUserId所拥有的权限内
     * 
     * @param userId
     *            被授权的用户id
     * @param rids
     *            授予的角色的id的集合
     * @param pids
     *            授予的权限的id的集合
     */
    public void grantUserByCurrentId(String userId, String[] rids,
            String[] pids, String currentUserId) {
        SysUser currentUser = userDao.get(currentUserId);
        if (currentUser != null) {
            // 在当前用户范围内过滤id
            Set<SysRole> currentRoles = currentUser.getSysRoles();
            Set<SysPrivilege> currentPrivileges = currentUser.getSysPrivileges();
            Set<SysRole> filterdRoles = new HashSet<SysRole>();
            Set<SysPrivilege> filterdPrivileges = new HashSet<SysPrivilege>();
            if (rids != null && rids.length > 0) {
                for (SysRole role : currentRoles) {
                    for (String rid : rids) {
                        if (rid.equals(role.getId()))
                            filterdRoles.add(role);
                    }
                }
            }
            if (pids != null && pids.length > 0) {
                for (SysPrivilege privilege : currentPrivileges) {
                    for (String pid : pids) {
                        if (pid.equals(privilege.getId()))
                            filterdPrivileges.add(privilege);
                    }
                }
            }
            SysUser user = userDao.get(userId);
            if (user != null) {
                user.setSysPrivileges(filterdPrivileges);
                user.setSysRoles(filterdRoles);
                userDao.save(user);
                
                // 刷新缓存中的用户权限关系
                refreshUserPrivilegeVo(filterdPrivileges, user);
                
                // 刷新缓存中的用户角色关系
                refreshUserRoleVo(rids, user);
            }
        }
    }

    /**
     * @Description: 重置当前用户本部门的用户密码，用户必须是本部门的管理员
     * @param: @param userId
     * @param: @param password
     * @param: @return
     * @return: boolean
     * @throws
     * @since JDK 1.6
     */
    public boolean resetPasswordByCurrentUser(String userId, String password) {
        String currentUserId = UserIdThreadLocal.getInstance().getUserId();
        if (!userId.equals(currentUserId)) {// 不能修改当前用户自己
            SysUser currentUser = userDao.get(currentUserId);
            if (currentUser != null) {
                SysDepartment department = currentUser.getSysDepartment();
                // 检查当前用户是否是部门的管理员
                if (department.getAdminUserId().equals(currentUser.getId())) {
                    SysUser resetUser = userDao.get(userId);
                    // 检查被修改用户是否存在
                    if (resetUser != null) {
                        // 检查被修改用户是否和当前用户在同一部门
                        if (resetUser.getSysDepartment().getId().equals(department.getId())) {
                            resetUser.setPassword(SecurityUtil.MD5String(password));
                            userDao.update(resetUser);
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    /**
     * 检验用户密码
     * 
     * @param username
     * @param password
     * @return 如果用户名不存在或密码错误则返回null
     */
    public SysUser checkLogin(String username, String password) {
        SysUser user = commonDao.findUserWithName(username);
        if (user != null
                && user.getPassword().equals(SecurityUtil.MD5String(password + md5Code + username))) {
            return user;
        } else {
            return null;
        }
    }
    
    /**
     * @Description: 当前用户重置自己的密码
     * @param: @param password
     * @param: @return
     * @return: boolean
     * @throws
     * @since JDK 1.6
     */
    public boolean resetCurrentUserPassword(String password) {
        String currentUserId = UserIdThreadLocal.getInstance().getUserId();
        SysUser currentUser = userDao.get(currentUserId);
        if (currentUser != null) {
            currentUser.setPassword(SecurityUtil.MD5String(password));
            userDao.update(currentUser);
            return true;
        }
        return false;
    }
    
    /**
     * @Description: 修改密码
     * @param: @param id
     * @param: @param oldPwd
     * @param: @param password
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> updatePassword(String id, String oldPwd, String password) {
        SysUser user = userDao.get(id);
        Map<String, Object> map = new HashMap<String, Object>();
        if (user == null) {
            map.put("result", false);
            map.put("message", "修改失败!");
            return map;
        }
        if (!StringUtils.equals(user.getPassword(), SecurityUtil.MD5String(oldPwd + md5Code + user.getUsername()))) {
            map.put("result", false);
            map.put("message", "原密码错误");
            return map;
        }
        // 新密码和旧密码相同时提示
        if (StringUtils.equals(user.getPassword(), SecurityUtil.MD5String(password + md5Code + user.getUsername()))) {
            map.put("result", false);
            map.put("message", "新密码不能和原密码相同！");
            return map;
        }
        user.setPassword(SecurityUtil.MD5String(password + md5Code + user.getUsername()));
        userDao.save(user);
        map.put("result", true);

        return map;
    }

    public String getMd5Code() {
        return md5Code;
    }

    public void setMd5Code(String md5Code) {
        this.md5Code = md5Code;
    }
    
    /**
     * @Description: 查找所有未删除的启用状态的用户，并按照姓名排序（支持中文）
     * @param: @return
     * @return: List<SysUser>
     * @throws
     * @since JDK 1.6
     */
    public List<SysUser> findUserOrderByName() {
        return userDao.findUserOrderByName();
    }
    
    /**
     * @Title: userEdit
     * @Description: 修改资料
     * @param userId
     * @return String
     */
    public boolean userEdit(SysUser user) {
       return userDao.userEdit(user);
    }

    /**
     * @Title: getThemeSkin
     * @Description: 获取用户主题皮肤设置
     * @param userId
     * @return SysThemeSkin
     */
    public SysThemeSkin getThemeSkin(String userId) {
        SysThemeSkin sysThemeSkin = baseDao.get(SysThemeSkin.class, userId);
        return sysThemeSkin;
    }
    
    /**
     * @Title: saveThemeSkin
     * @Description: 保存用户主题皮肤设置
     * @param userId
     * @param sysThemeSkin
     * @return boolean
     */
    public boolean saveThemeSkin(String userId, SysThemeSkin sysThemeSkin) {
        try {
            sysThemeSkin.setUserId(userId);
            sysThemeSkin.setCreateTime(new Date());

            SysThemeSkin sysThemeSkinOld = baseDao.get(SysThemeSkin.class, userId);
            if (sysThemeSkinOld != null) {
                sysThemeSkinOld.setHeader(sysThemeSkin.getHeader());
                sysThemeSkinOld.setFooter(sysThemeSkin.getFooter());
                sysThemeSkinOld.setLayout(sysThemeSkin.getLayout());
                sysThemeSkinOld.setSidebarMenu(sysThemeSkin.getSidebarMenu());
                sysThemeSkinOld.setSidebarMode(sysThemeSkin.getSidebarMode());
                sysThemeSkinOld.setSidebarPosition(sysThemeSkin.getSidebarPosition());
                sysThemeSkinOld.setSidebarStyle(sysThemeSkin.getSidebarStyle());
                sysThemeSkinOld.setThemeColors(sysThemeSkin.getThemeColors());
                sysThemeSkinOld.setThemeStyle(sysThemeSkin.getThemeStyle());
                sysThemeSkinOld.setTopMenuDropdown(sysThemeSkin.getTopMenuDropdown());
                sysThemeSkinOld.setCreateTime(sysThemeSkin.getCreateTime());
                baseDao.update(sysThemeSkinOld);
            } else {
                baseDao.save(sysThemeSkin);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * @Title: findUserPhoto
     * @Description: 获取用户头像路径
     * @param userId
     * @return String
     */
    public String findUserPhoto(String userId) {
        return userDao.findUserPhoto(userId);
    }
    
    /**
     * @Title: saveUserPhoto
     * @Description: 保存用户头像相关信息
     * @param userId
     * @param userPhotoPath
     * @return boolean
     */
    public boolean saveUserPhoto(SysUser sysUser, String userPhotoPath) {
        try {
        	UploadFile userPhoto = userDao.findUserPhotoFile(sysUser.getId());
            if (userPhoto != null) {
                String photoPath_o = userPhoto.getFilePath();
                File photoFile_o = new File(photoPath_o);
                if (photoFile_o.exists()) {
                    photoFile_o.delete();
                }

                userPhoto.setFilePath(userPhotoPath);
                userPhoto.setCreateDate(new Date());
                baseDao.update(userPhoto);
            } else {
                UploadFile file = new UploadFile();
                file.setBusinessId(sysUser.getId());
                file.setFilePath(userPhotoPath);
                file.setFileName("用户头像-" + sysUser.getUsername());
                file.setCreateDate(new Date());
                file.setCreateUser(sysUser);
                baseDao.save(file);
            }
            return true;

        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return false;
        }
    }

}
