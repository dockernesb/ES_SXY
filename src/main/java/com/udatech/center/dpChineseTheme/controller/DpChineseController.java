package com.udatech.center.dpChineseTheme.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.udatech.center.dpChineseTheme.service.DpChineseService;
import com.udatech.common.controller.SuperController;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;

@Controller
@RequestMapping("/dpChineseTheme")
public class DpChineseController extends SuperController {

    @Autowired
    private DpChineseService dpChineseService;

    /**
     * @Title:
     * @Description: 进入上报数据主页面
     * @param response
     * @param request
     * @return
     * @return: ModelAndView
     */
    @RequestMapping("/toChineseView")
    @MethodDescription(desc = "上报信用中国")
    @RequiresPermissions("dpChineseTheme.toChineseView")
    public ModelAndView toDpHomePageList(HttpServletRequest request) {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/dpChineseTheme/dpChinese");
        return view;
    }

    @RequestMapping("/themePage/tableList")
    @MethodDescription(desc = "表格数据内容")
    @RequiresPermissions("dpChineseTheme.toChineseView")
    @ResponseBody
    public String dataMassageList(String msgType, String tableCoulmn, String coulmnValue, String beginDate,
                                  String endDate, String status) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);

        Pageable<Map<String, Object>> page = dpChineseService.getQueryList(msgType, tableCoulmn, coulmnValue,
                beginDate, endDate, status, dtParams.getPage());
        return PageUtils.buildDTData(page, request);
    }

    @RequestMapping("/getMsgColumns")
    @RequiresPermissions("dpChineseTheme.toChineseView")
    @ResponseBody
    public void getMsgColumns(String msgType, Writer writer) {

        List<Map<String, Object>> params = dpChineseService.getTableColumn(msgType);
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        for (Map<String, Object> paramMap : params) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("columnName", MapUtils.getString(paramMap, "COLUMN_NAME", ""));
            item.put("comments", MapUtils.getString(paramMap, "COMMENTS", ""));
            list.add(item);
        }

        String json = ResponseUtils.toJSONString(list);
        try {
            writer.write(json);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/commitDataList")
    @RequiresPermissions("dpChineseTheme.toChineseView")
    @MethodDescription(desc = "单选提交数据")
    @ResponseBody
    public void insertCommitData(HttpServletRequest request, HttpServletResponse response, String id, String msgType,
                                 Writer writer) {
        String resultType = dpChineseService.changeProvinceStatus(id, msgType);
        String json = null;
        try {
            if ("3".equals(resultType)) {
                json = ResponseUtils.buildResultJson(true, "操作成功");
            } else {
                json = ResponseUtils.buildResultJson(false, "报送失败，失败原因请在数据报送记录中查看详情");
            }
            dpChineseService.insertData(id, msgType);
        } catch (Exception e) {
            json = ResponseUtils.buildResultJson(false, "操作失败，未知错误");
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        try {
            writer.write(json);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/batchCommitDataList")
    @RequiresPermissions("dpChineseTheme.toChineseView")
    @MethodDescription(desc = "多选提交数据")
    @ResponseBody
    public void batchInsertCommitData(HttpServletRequest request, HttpServletResponse response, String ids,
                                      String msgType, Writer writer) throws IOException {

        ids = HtmlUtils.htmlUnescape(ids);
        JSONArray dataIdJson = JSON.parseArray(ids);
        List<String> dataIdList = new ArrayList<String>();
        for (int i = 0; i < dataIdJson.size(); i++) {
            dataIdList.add((String) dataIdJson.get(i));
        }
        int succ = 0;
        int fail = 0;
        int total = dataIdJson.size();
        String msg = null;
        for (String id : dataIdList) {
            String resultType = dpChineseService.changeProvinceStatus(id, msgType);
            try {
                if ("3".equals(resultType)) {
                    succ++;
                } else {
                    fail++;
                }
                dpChineseService.insertData(id, msgType);
            } catch (Exception e) {
                fail++;
                e.printStackTrace();
            }
        }
        response.setContentType("text/html;charset=UTF-8");
        msg = "共上传" + total + "条,成功" + succ + "条,失败" + fail + "条,请在数据报送记录中查看详情";

        try {

            writer.write(ResponseUtils.buildResultJson(true, msg));
        } catch (IOException e) {
            writer.write(ResponseUtils.buildResultJson(false, msg));
            e.printStackTrace();
        }
    }

}
