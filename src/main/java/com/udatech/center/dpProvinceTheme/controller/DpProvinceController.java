package com.udatech.center.dpProvinceTheme.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.udatech.center.dpProvinceTheme.service.DpProvinceService;
import com.udatech.common.controller.SuperController;
import com.wa.framework.Pageable;
import com.wa.framework.common.DTBean.DTRequestParamsBean;
import com.wa.framework.log.MethodDescription;
import com.wa.framework.util.easyui.ResponseUtils;
import com.wa.framework.utils.PageUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dpTheme")
public class DpProvinceController extends SuperController {

    @Autowired
    private DpProvinceService dpProvinceService;

    /**
     * @Title:
     * @Description: 进入上报数据主页面
     * @param response
     * @param request
     * @return
     * @return: ModelAndView
     */
    @RequestMapping("/toProvinceView")
    @MethodDescription(desc = "上报省平台")
    @RequiresPermissions("dpTheme.toProvinceView")
    public ModelAndView toDpHomePageList(HttpServletRequest request) {
        ModelAndView view = new ModelAndView();
        view.setViewName("/center/dpProvinceTheme/dpProvince");

        return view;
    }

    @RequestMapping("/themePage/tableList")
    @MethodDescription(desc = "表格数据内容")
    @RequiresPermissions("dpTheme.toProvinceView")
    @ResponseBody
    public String dataMassageList(String msgType, String tableCoulmn, String coulmnValue, String beginDate,
                    String endDate, String status) {
        DTRequestParamsBean dtParams = PageUtils.getDTParams(request);

        Pageable<Map<String, Object>> page = dpProvinceService.getQueryList(msgType, tableCoulmn, coulmnValue,
                        beginDate, endDate, status, dtParams.getPage());
        return PageUtils.buildDTData(page, request);
    }

    /**
     * @Description: 获取表字段
     * @param: @param msgType
     * @param: @param writer
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/getMsgColumns")
    @RequiresPermissions("dpTheme.toProvinceView")
    @ResponseBody
    public void getMsgColumns(String msgType, Writer writer) {

        List<Map<String, Object>> params = dpProvinceService.getTableColumn(msgType);
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
    @RequiresPermissions("dpTheme.toProvinceView")
    @MethodDescription(desc = "单选提交数据到省平台")
    @ResponseBody
    public void insertCommitData(HttpServletRequest request, HttpServletResponse response, String id, String msgType,
                    Writer writer) {
        String json = null;
        try {
            Map<String, Object> map = dpProvinceService.insertQzkData(id, msgType);
            String reslutType = (String) map.get("reslutType");
            if ("1".equals(reslutType)) {
                json = ResponseUtils.buildResultJson(true);
            } else if ("2".equals(reslutType)) {
                json = ResponseUtils.buildResultJson(false);
            }

        } catch (Exception e) {
            json = ResponseUtils.buildResultJson(false);
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
    @RequiresPermissions("dpTheme.toProvinceView")
    @MethodDescription(desc = "批量提交数据到省平台")
    @ResponseBody
    public void batchInsertCommitData(HttpServletRequest request, HttpServletResponse response, String ids,
                    String msgType, Writer writer) throws IOException {

        String message = null;
        try {
            ids = HtmlUtils.htmlUnescape(ids);
            JSONArray dataIdJson = JSON.parseArray(ids);
            List<String> dataIdList = new ArrayList<String>();
            for (int i = 0; i < dataIdJson.size(); i++) {
                dataIdList.add((String) dataIdJson.get(i));
            }
            int total = dataIdJson.size();

            int succ = 0;
            int fail = 0;
            for (String id : dataIdList) {
                Map<String, Object> map = dpProvinceService.insertQzkData(id, msgType);
                int succ1 = (int) map.get("succ");
                int fail1 = (int) map.get("fail");
                succ += succ1;
                fail += fail1;
            }
            message = "共上传" + total + "条,成功" + succ + "条,失败" + fail + "条,请在数据报送记录中查看详情";
            writer.write(ResponseUtils.buildResultJson(true, message));
        } catch (Exception e) {
            writer.write(ResponseUtils.buildResultJson(false, message));
            e.printStackTrace();
        }

    }

    /**
     * @Description: 动态拿到处罚与许可的字段
     * @param: @param msgType
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    @RequestMapping("/getCoulmnName")
    @RequiresPermissions("dpTheme.toProvinceView")
    @ResponseBody
    public String getCoulmnName(String msgType) {

        List<Map<String, Object>> params = dpProvinceService.getTableColumn(msgType);
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        for (Map<String, Object> paramMap : params) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("id", MapUtils.getString(paramMap, "COLUMN_NAME", ""));
            item.put("text", MapUtils.getString(paramMap, "COMMENTS", ""));
            list.add(item);
        }

        return JSON.toJSONString(list);
    }
}
