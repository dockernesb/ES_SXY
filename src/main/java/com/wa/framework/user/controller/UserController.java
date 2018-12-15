package com.wa.framework.user.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.udatech.common.util.FileUtils;
import com.wa.framework.Pageable;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.controller.BaseController;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.user.model.SysThemeSkin;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.user.service.UserService;
import com.wa.framework.user.vo.SysUserVo;
import com.wa.framework.user.vo.UserConstants;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 用户管理.
 * @author Administrator
 */
@Controller
@RequestMapping("/system/user/")
public class UserController extends BaseController<Object, Object> {

    @Autowired
    @Qualifier("userService")
    private UserService userService;
    
    /**
     * 修改密码
     */
    @RequestMapping("/editPwd")
    @MethodDescription(desc="修改用户密码")
    public void updatePwd(HttpServletRequest request,
            HttpServletResponse response, Writer writer) throws Exception {
        String id = request.getParameter("managerId");
        String oldPwd = request.getParameter("oldPwd");
        String password = request.getParameter("newPwd");
        Map<String, Object> result = userService.updatePassword(id, oldPwd, password);
        String json = ResponseUtils.buildResultJson(result);
        writer.write(json);
    }

    /**
     * <描述>: 进入用户管理页面
     * @author 作者：何斐
     * @version 创建时间：2016年11月8日下午2:10:38
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/user")
    @MethodDescription(desc="查询用户")
    @RequiresPermissions("system.user.user.query")
    public ModelAndView user(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
    	String userId = CommonUtil.getCurrentUserId();
        SysUser sysUser = userService.findById(SysUser.class, userId);
    	ModelAndView view = new ModelAndView();
        view.setViewName("/sys/user/user_list");
        view.addObject("sysUser", sysUser);
        return view;
    }

    /**
     * <描述>: 加载用户列表
     * @author 作者：何斐
     * @version 创建时间：2016年11月8日下午2:10:56
     * @param request
     * @param response
     * @param writer
     * @throws Exception
     * @Version 信用2.0
     */
    @RequestMapping("/list")
    @RequiresPermissions("system.user.user.query")
    @ResponseBody
    public String userList(HttpServletRequest request) throws Exception {
    	DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
    	String username = request.getParameter("username");
    	String realName = request.getParameter("realName");
    	String depart = request.getParameter("depart");
    	String status = request.getParameter("status");
    	String type = request.getParameter("type");
        Pageable<SysUser> page = userService.findUserWithName(dtParams.getPage(),username, realName, depart, status, type);
        return PageUtils.buildDTData(page, request);
    }

    @RequestMapping("/listByDepartmentId")
    public void listByDepartmentId(HttpServletRequest request,
            HttpServletResponse response, @RequestParam String departmentId,
            Writer writer) throws Exception {
        List<SysUser> list = userService.findUserByDepartmentId(departmentId);
        for (SysUser user : list) {
            user.setSysDepartment(null);// 断开user与department的循环关联关系
        }
        String json = ResponseUtils.toJSONString(list);
        writer.write(json);
    }

    @RequestMapping("/add")
    @MethodDescription(desc="增加用户")
    @RequiresPermissions("system.user.user.add")
    public void userAdd(HttpServletRequest request,
            HttpServletResponse response, Writer writer, SysUser user,
            @RequestParam String departmentId) throws Exception {
        int result = userService.addUser(user, departmentId);
        String json = ResponseUtils.buildResultJson((result == 0), String.valueOf(result));
        writer.write(json);
    }

    /**
     * @Description 删除用户
     * @param request
     * @param response
     * @param id
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/delete")
    @MethodDescription(desc="删除用户")
    @RequiresPermissions("system.user.user.delete")
    public void userDelete(HttpServletRequest request,
            HttpServletResponse response, @RequestParam("id") String id,
            Writer writer) throws Exception {
        userService.deleteUserInlogic(id);
        String json = ResponseUtils.buildResultJson(true);
        writer.write(json);
    }

    /**
     * @Description 启用/禁用 用户
     * @param request
     * @param response
     * @param id
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/enable")
    @MethodDescription(desc="启用/禁用用户")
    @RequiresPermissions("system.user.user.enable")
    public void userEnable(HttpServletRequest request,
            HttpServletResponse response, @RequestParam String id, Writer writer)
            throws Exception {
        userService.enable(id);
        String json = ResponseUtils.buildResultJson(true);
        writer.write(json);
    }

    /**
     * <描述>: 打开修改页面
     * @author 作者：何斐
     * @version 创建时间：2016年11月15日上午9:37:31
     * @param request
     * @param response
     * @param user
     * @param userId
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/onEdit")
    @ResponseBody
    public void onEdit(HttpServletRequest request, HttpServletResponse response, String userId, Writer writer)
            throws Exception {
        Map<String, Object> user = userService.getUserById(userId);
        String json = ResponseUtils.toJSONString(user);
        writer.write(json);
    }
    
    /**
     * @Description 修改用户资料
     * @param request
     * @param response
     * @param user
     * @param userId
     * @param departmentId
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/edit")
    @MethodDescription(desc="修改用户信息")
    @RequiresPermissions("system.user.user.edit")
    public void userEdit(HttpServletRequest request,
            HttpServletResponse response, SysUser user,
            @RequestParam String userId, @RequestParam String departmentId,
            Writer writer) throws Exception {
        userService.updateUser(user, userId, departmentId);
        String json = ResponseUtils.buildResultJson(true);
        writer.write(json);
    }

    /**
     * @Description 重置密码
     * @param request
     * @param response
     * @param id
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/resetPassword")
    @MethodDescription(desc="重置用户密码")
    @RequiresPermissions("system.user.user.resetPassword")
    public void resetPassword(HttpServletRequest request, HttpServletResponse response, @RequestParam String id,
            Writer writer) throws Exception {
        String password = PropertyConfigurer.getValue("reset.password");
        userService.resetPassword(id, password);
        String json = ResponseUtils.buildResultJson(true);
        writer.write(json);
    }

    @RequestMapping("/roleIdsAndPrivilegeIds")
    @RequiresPermissions("system.user.user.grant")
    public void roleIdsAndPrivilegeIds(HttpServletRequest request,
            HttpServletResponse response, @RequestParam String id, Writer writer)
            throws Exception {
        Map<String, List<Object>> map = userService.getRoleIdsAndPrivilegeIdsByUserId(id);
        String json = JSON.toJSONString(map);
        writer.write(json);
    }

    /**
     * @Description 授权
     * @param request
     * @param response
     * @param userId
     * @param writer
     * @throws Exception
     */
    @RequestMapping("/grant")
    @MethodDescription(desc="用户授权")
    @RequiresPermissions("system.user.user.grant")
    public void grant(HttpServletRequest request, HttpServletResponse response,
            @RequestParam String userId, Writer writer) throws Exception {
        String roleIds = request.getParameter("roleIds");
        String privilegeIds = request.getParameter("privilegeIds");
        String[] rids = null;
        String[] pids = null;
        if (roleIds != null && roleIds.length() > 0) {
            rids = roleIds.split(";");
        }
        if (privilegeIds != null && privilegeIds.length() > 0) {
            pids = privilegeIds.split(";");
        }
        userService.grantUser(userId, rids, pids);
        String json = ResponseUtils.buildResultJson(true);
        writer.write(json);
    }

    /**
     * @Description: 获取所有激活用户列表，供表单下拉框使用
     * @param: @param request
     * @param: @param response
     * @param: @param writer
     * @param: @throws Exception
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/alluser")
    public void alluser(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        List<SysUser> users = userService.findUserOrderByName();
        List<SysUserVo> uservos = new ArrayList<SysUserVo>();
        for(SysUser user : users) {
            SysUserVo uservo = new SysUserVo();
            uservo.setId(user.getId());
            if (StringUtils.isNotEmpty(user.getRealName())){
                uservo.setName(user.getRealName());
            } else {
                uservo.setName(user.getUsername());
            }
            uservos.add(uservo);
        }
        String json = ResponseUtils.toJSONString(uservos);
        writer.write(json);
    }
    
    /**
     * @Description: 获取所有激活用户列表，供表单下拉框使用
     * @param: @param request
     * @param: @param response
     * @param: @param writer
     * @param: @throws Exception
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/allUserNotInSelf")
    public void allUserNotInSelf(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
        List<SysUser> users = userService.findUserOrderByName();
        List<SysUserVo> uservos = new ArrayList<SysUserVo>();
        
        String userId = CommonUtil.getCurrentUserId();
        for(SysUser user : users) {
            if (!user.getId().equals(userId)){
                SysUserVo uservo = new SysUserVo();
                uservo.setId(user.getId());
                if (StringUtils.isNotEmpty(user.getRealName())){
                    uservo.setName(user.getRealName());
                } else {
                    uservo.setName(user.getUsername());
                }
                uservos.add(uservo);
            }
        }
        String json = ResponseUtils.toJSONString(uservos);
        writer.write(json);
    }
    
    /**
     * @Title: saveThemeSkin
     * @Description: 保存主题皮肤
     * @param request
     * @param response
     * @param sysThemeSkin
     * @param writer
     * @return
     * @throws Exception
     */
    @RequestMapping("/saveThemeSkin")
    public void saveThemeSkin(HttpServletRequest request, HttpServletResponse response, SysThemeSkin sysThemeSkin,
                    Writer writer) throws Exception {
        String userId = CommonUtil.getCurrentUserId();
        boolean res = userService.saveThemeSkin(userId, sysThemeSkin);
        String json = ResponseUtils.buildResultJson(res);
        writer.write(json);
    }

    /**
     * @Title: getThemeSkin
     * @Description: 获取用户主题皮肤设置
     * @param request
     * @param response
     * @param writer
     * @throws Exception void
     */
    @RequestMapping("/getThemeSkin")
    public void getThemeSkin(HttpServletRequest request, HttpServletResponse response, Writer writer) throws Exception {
    	String userId = CommonUtil.getCurrentUserId();
        SysThemeSkin sysThemeSkin = userService.getThemeSkin(userId);
        String json = PageUtils.toJSONString(sysThemeSkin);
        writer.write(json);
    }

    /**
     * @Title: toCenter
     * @Description: 打开个人中心页面
     * @param response
     * @param httpServletRequest
     * @return
     * @return: ModelAndView
     */
    @RequestMapping("/toCenter")
    public ModelAndView toCenter(HttpServletResponse response, HttpServletRequest httpServletRequest) {
    	String userPhotoPath = userService.findUserPhoto(CommonUtil.getCurrentUserId()); // 用户头像路径
        SysUser user = baseService.findById(SysUser.class, CommonUtil.getCurrentUserId());
        ModelAndView view = new ModelAndView();
        view.addObject("user", user);
        view.addObject("userPhotoPath", userPhotoPath);
        view.setViewName("/sys/user/personalCenter");
        return view;
    }

    /**
     * @Title: userEdit
     * @Description: 修改资料
     * @param request
     * @param response
     * @param user
     * @param writer
     * @throws Exception void
     */
    @RequestMapping("/userEdit")
    public void userEdit(HttpServletRequest request, HttpServletResponse response, SysUser user, Writer writer)
                    throws Exception {
        boolean res = userService.userEdit(user);
        String json = ResponseUtils.buildResultJson(res);
        writer.write(json);
    }
    
    /**
     * @Title: getUserPhoto
     * @Description: 获取用户头像路径
     * @param request
     * @param response
     * @param user
     * @param writer
     * @throws Exception void
     */
    @RequestMapping("/getUserPhoto")
    public void getUserPhoto(HttpServletRequest request, HttpServletResponse response, Writer writer)
                    throws Exception {
    	String userId = CommonUtil.getCurrentUserId();
        String userPhotoPath = userService.findUserPhoto(userId); // 用户头像路径
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("userPhotoPath", userPhotoPath);
        String json = jsonObj.toJSONString();
        writer.write(json);
    }
    
    /**
     * @Title: saveUserPhoto
     * @Description: 保存用户头像路径与用户ID关联
     * @param request
     * @param response
     * @param userId
     * @param userPhotoPath
     * @param writer
     * @throws Exception void
     */
    @RequestMapping("/saveUserPhoto")
    public void saveUserPhoto(HttpServletRequest request, HttpServletResponse response,
                    String userPhotoPath, Writer writer) throws Exception {
        String userId = CommonUtil.getCurrentUserId();
        SysUser sysUser = userService.findById(SysUser.class, userId);
        String filePath = FileUtils.copyTempFileToUploadDir(userPhotoPath, PropertyConfigurer.getValue(UserConstants.FILE_UPLOAD_USER_PATH));
        boolean res = userService.saveUserPhoto(sysUser, filePath);
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("result", res);
        jsonObj.put("filePath", filePath);
        String json = jsonObj.toJSONString();
        writer.write(json);
    }

}
