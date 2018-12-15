package com.wa.framework.common.controller;

import com.alibaba.fastjson.JSONArray;
import com.udatech.common.constant.Constants;
import com.udatech.common.controller.SuperController;
import com.wa.framework.UserIdThreadLocal;
import com.wa.framework.UsernameThreadLocal;
import com.wa.framework.common.ComConstants;
import com.wa.framework.common.IPUtil;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.common.service.CommonService;
import com.wa.framework.common.service.MemCacheService;
import com.wa.framework.common.vo.UserPrivilegeVo;
import com.wa.framework.exception.CaException;
import com.wa.framework.exception.LoginException;
import com.wa.framework.log.service.LogService;
import com.wa.framework.security.SessionListener;
import com.wa.framework.security.exception.NoPrivilegeAccountException;
import com.wa.framework.security.shiro.CaptchaUtil;
import com.wa.framework.security.user.LoginedUser;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.SecurityUtil;
import com.wa.framework.utils.CaUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 描述：登录管理 创建人：guoyt 创建时间：2016年10月12日下午4:45:42 修改人：guoyt
 * 修改时间：2016年10月12日下午4:45:42
 */
@Controller
@RequestMapping("/")
public class IndexController extends SuperController {

	@Resource
	private MemCacheService memCacheService;

	@Autowired
	private LogService logService;

	@Autowired
	private CommonService baseCommonService;

	/**
	 * @Description: 登录
	 * @param: @param request
	 * @param: @return
	 * @return: ModelAndView
	 * @throws
	 * @since JDK 1.6
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public ModelAndView showLoginForm(HttpServletRequest request) {
		ModelAndView modelAndView = new ModelAndView("login");
		String error = (String) request.getAttribute("shiroLoginFailure");
		modelAndView.addObject("message", error);
		return modelAndView;
	}

	/**
	 * @Description: 登录
	 * @param: @param request
	 * @param: @return
	 * @return: ModelAndView
	 * @throws
	 * @since JDK 1.6
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public ModelAndView login(String username, String password, String captcha) {
		ModelAndView modelAndView = new ModelAndView("redirect:/index.action");

		try {

			if (StringUtils.isBlank(username)) {
				throw new LoginException("用户名不能为空");
			}

			if (StringUtils.isBlank(password)) {
				throw new LoginException("密码不能为空");
			}

			if (!CaptchaUtil.validateCaptcha(session.getId(), captcha)) {
				throw new LoginException("验证码为空或错误");
			}

			String md5Code = PropertyConfigurer.getValue("md5.code");
			String md5 = SecurityUtil.MD5String(password + md5Code + username);

			Subject subject = SecurityUtils.getSubject();
			UsernamePasswordToken token = new UsernamePasswordToken(username,
					md5);
			subject.login(token);

			LoginedUser lu = (LoginedUser) subject.getPrincipal();

			SysUser user = baseCommonService.findUserById(lu.getUserId());

			prepare(user);
		} catch (LoginException e) {
			e.printStackTrace();
			modelAndView = new ModelAndView("login");
			modelAndView.addObject("message", e.getMessage());
		} catch (DisabledAccountException e) {
			e.printStackTrace();
			modelAndView = new ModelAndView("login");
			modelAndView.addObject("message", "账号被禁用");
		} catch (NoPrivilegeAccountException e) {
			e.printStackTrace();
			modelAndView = new ModelAndView("login");
			modelAndView.addObject("message", "账号无权限");
		} catch (UnknownAccountException | IncorrectCredentialsException e) {
			e.printStackTrace();
			modelAndView = new ModelAndView("login");
			modelAndView.addObject("message", "账号或密码错误");
		} catch (Exception e) {
			e.printStackTrace();
			modelAndView = new ModelAndView("login");
			modelAndView.addObject("message", "未知错误");
		}

		return modelAndView;
	}

	/**
	 * @category 跳转CA登录页面
	 * @return
	 */
	@RequestMapping(value = "/loginCa", method = RequestMethod.GET)
	public ModelAndView showLoginCaForm() {
		ModelAndView modelAndView = new ModelAndView("login_ca");
		String error = (String) request.getAttribute("shiroLoginFailure");
		modelAndView.addObject("message", error);
		String strServerRan = CaUtil.getRandomString();
		session.setAttribute("strServerRan", strServerRan);
		modelAndView.addObject("strServerRan", strServerRan);
		String strServerSignedData = CaUtil.getServerSignedData(strServerRan);
		modelAndView.addObject("strServerSignedData", strServerSignedData);
		modelAndView.addObject("strServerCert", CaUtil.getServerCert());
		return modelAndView;
	}

	/**
	 * @category ca登录
	 * @param UserCert
	 * @param UserSignedData
	 * @return
	 */
	@RequestMapping(value = "/loginCa", method = RequestMethod.POST)
	public ModelAndView loginCa(String UserCert, String UserSignedData) {
		ModelAndView modelAndView = new ModelAndView("redirect:/index.action");

		try {
			String strServerRan = (String) session.getAttribute("strServerRan");
			String caKey = CaUtil.getUserKey(UserCert, strServerRan,
					UserSignedData);

			if (StringUtils.isBlank(caKey)) {
				throw new CaException("证书验证失败");
			}

			SysUser user = commonService.getUserByKey(caKey);

			if (user == null) {
				throw new CaException("用户不存在");
			}

			Subject subject = SecurityUtils.getSubject();
			UsernamePasswordToken token = new UsernamePasswordToken(
					user.getUsername(), user.getPassword());
			subject.login(token);

			prepare(user);
		} catch (CaException e) {
			e.printStackTrace();
			modelAndView = new ModelAndView("redirect:/loginCa.action");
			modelAndView.addObject("message", e.getMessage());
		}

		return modelAndView;
	}

	/**
	 * @category 登录成功，用户信息存入session，并记录日志
	 * @param user
	 */
	private void prepare(SysUser user) {

		UsernameThreadLocal.getInstance().setUsername(user.getUsername());
		UserIdThreadLocal.getInstance().setUserId(user.getId());

		HttpServletRequest req = (HttpServletRequest) request;
		String basePath = req.getScheme() + "://" + req.getServerName() + ":"
				+ req.getServerPort() + req.getContextPath() + "/";

		// 获取用户权限集合
		List<UserPrivilegeVo> privilegeVos = baseCommonService
				.getUserPrivilege(user);

		// 获取用户授权的菜单
		JSONArray menus = baseCommonService.getCurrentUserMenu(privilegeVos,
				basePath, user);

		session.setAttribute(ComConstants.SESSION_USERNAME, user.getUsername());
		session.setAttribute(ComConstants.SESSION_USERID, user.getId());
		session.setAttribute(ComConstants.SESSION_MENUS, menus);
		session.setAttribute(ComConstants.SUPPORT_POP,
				PropertyConfigurer.getValue(ComConstants.IS_SUPPORT_POP_REMIND));
		session.setAttribute(ComConstants.SUPPORT_MESSAGE,
				PropertyConfigurer.getValue(ComConstants.IS_SUPPORT_MESSAGE));
		session.setAttribute(ComConstants.SESSION_BATHPATH, basePath);

		String url = req.getRequestURL().toString();
		String ip = IPUtil.getIpAddress(req);
		session.setAttribute(ComConstants.SESSION_IP, ip);

		SessionListener sessionListerner = new SessionListener();
		req.getSession().setAttribute("sessionListener", sessionListerner);

		logService.addReqLog(user.getUsername(), ip, url,
				ComConstants.LOG_LOGIN_NAME, (byte) 0);

	}

	/**
	 * @Description: 跳转首页
	 * @param: @return
	 * @return: ModelAndView
	 * @throws
	 * @since JDK 1.6
	 */
	@RequestMapping("index")
	public ModelAndView index() {
		if (StringUtils.isBlank(getUserId()) || getSysUser() == null) {
			ModelAndView modelAndView = new ModelAndView("login");
			return modelAndView;
		} else {
			SysUser sysUser = getSysUser();
			ModelAndView modelAndView = new ModelAndView("index");
			modelAndView.addObject("version", Constants.VERSION_NO);
			modelAndView.addObject("userType", sysUser.getType());
			return modelAndView;
		}
	}

	/**
	 * @Description: 刷新缓存
	 * @param: @param session
	 * @param: @param request
	 * @param: @throws Exception
	 * @return: void
	 * @throws
	 * @since JDK 1.6
	 */
	@RequestMapping("/refreshCache")
	public void refreshCache(HttpSession session, HttpServletRequest request)
			throws Exception {
		memCacheService.refreshCache();
	}

}
