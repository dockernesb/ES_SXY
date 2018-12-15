package com.udatech.center.socialNaturalPerson.controller;

import com.alibaba.fastjson.JSON;
import com.udatech.center.socialNaturalPerson.service.SocialNaturalPersonService;
import com.udatech.common.controller.SuperController;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.DateUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * <描述>： 社会自然人Controller<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2017年2月4日下午4:18:31
 */
@Controller
@RequestMapping("/center/socialNaturalPerson")
public class SocialNaturalPersonController extends SuperController {
    Logger logger = Logger.getLogger(SocialNaturalPersonController.class);

    @Autowired
    private SocialNaturalPersonService socialNaturalPersonService;

    /**
     * @Title: toList
     * @Description: 跳转到社会自然人管理页面
     * @param request
     * @param response
     * @return
     * @return: ModelAndView
     */
    @RequestMapping("/toList")
    @MethodDescription(desc="查询自然人管理")
    @RequiresPermissions("natural.person.list.detail")
    public ModelAndView toList(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView view = new ModelAndView("/center/socialNaturalPerson/socialNaturalPersonList");
        return view;
    }

    /**
     * @Title: queryList
     * @Description: 查询自然人信息列表
     * @param request
     * @param response
     * @return
     * @return: String
     */
    @RequestMapping("/queryList")
    @RequiresPermissions("natural.person.list.detail")
    @ResponseBody
    public String queryList(HttpServletRequest request, HttpServletResponse response, String xm, String sfzh,
            String zymc) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Pageable<Map<String, Object>> page = socialNaturalPersonService.queryList(dtParams.getPage(), xm, sfzh, zymc);
        return PageUtils.buildDTData(page, request, DateUtils.YYYYMMDD_10);
    }

    /**
     * @Title: toView
     * @Description: 跳转到详细界面
     * @param request
     * @param response
     * @param id
     * @return
     * @return: ModelAndView
     */
    @RequestMapping("/toView")
    @MethodDescription(desc="查看社会自然人详细")
    @RequiresPermissions("natural.person.list.detail")
    @ResponseBody
    public ModelAndView toView(HttpServletRequest request, HttpServletResponse response, String sfzh, String zymc,
            String isOpen) {
        // 自然人基本信息
        Map<String, Object> grxx = socialNaturalPersonService.findNaturalPersonInfo(sfzh);
        ModelAndView view = new ModelAndView("/center/socialNaturalPerson/socialNaturalPersonDetail");
        grxx.put("ZYMC", zymc);
        view.addObject("grxx", grxx);
        view.addObject("isOpen", isOpen);// 是否是信用地图上的点击事件，跳转过来的页面，是的话，需要在新窗口打开，增加整体样式，页面上处理
        return view;
    }

    /**
     * @category 获取信用信息(失信表彰等信息...)
     * @param ei
     * @return
     */
    @RequestMapping("/getCreditInfo")
    @RequiresPermissions("natural.person.list.detail")
    @ResponseBody
    public String getCreditInfo(String oderColName, String orderType, String sfzh, String tableName) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);
        Page page = dtParams.getPage();
        Pageable<Map<String, Object>> pageable = new SimplePageable<>();
        if (StringUtils.isNotBlank(tableName)) {
            try {
                pageable = socialNaturalPersonService.getCreditInfo(oderColName, orderType, sfzh, tableName, page);
            } catch (Exception e) {
                pageable = new SimplePageable<>();
                logger.error(e.getMessage(), e);
            }
        }
        return PageUtils.buildDTData(pageable, request, DateUtils.YYYYMMDD_10);
    }


    /**
     * 查询社保信息
     * @param sfzh
     * @return
     */
    @RequestMapping("/getshebaoData")
    @RequiresPermissions("natural.person.list.detail")
    @ResponseBody
    public String getshebaoData(String sfzh){
        List<Map<String, Object>> shebaolist =null;
        if (StringUtils.isNotBlank(sfzh)) {
            shebaolist = socialNaturalPersonService.getSheBaoBInfoFromES(sfzh);
        }
        return JSON.toJSONString(shebaolist);
    }
}
