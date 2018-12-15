package com.udatech.common.creditReportQuery.service;

import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.common.model.PersonReportApply;
import com.udatech.common.model.StReportFontSizeConfig;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;

import java.util.List;
import java.util.Map;

/**
 * <描述>：公共信用报告内容查询 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月6日下午3:26:26
 */
public interface CreditReportQueryService {
    /**
     * <描述>:根据ID获取信用报告申请单信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:00:54
     * @param id
     * @return
     */
    public EnterpriseReportApply getReportApplyById(String id);

    /**
     * <描述>: 查询报告申请zrr的详细信息，严格查询
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:23:38
     * @param params
     * @return
     */
    public Map<String, Object> findEnterpriseInfoStrictZrr(Map<String, Object> params);
    
    /**
     * <描述>: 查询报告申请企业的详细信息
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:23:38
     * @param params
     * @return
     */
    public Map<String, Object> findEnterpriseInfoStrict(Map<String, Object> params);

    /**
     * <描述>:获取法人信用报告数据
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午4:27:44
     * @param themeInfo
     * @param params
     */
    public void getCreditData(List<TemplateThemeNode> themeInfo, Map<String, Object> params);

    /**
     * <描述>: 查询指定序列的下一个值
     * @author 作者：lijj
     * @version 创建时间：2016年12月8日上午11:29:02
     * @param string
     * @return
     */
    public String findBgbh(String string);

    /**
     * <描述>: 绑定报告编号和法人报告申请单的关系
     * @author 作者：lijj
     * @version 创建时间：2016年12月8日上午11:33:45
     * @param xybgbh
     * @param businessId
     */
    public void updateXybgbh(String xybgbh, String businessId);

    /**
     * <描述>: 根据ID获取信用报告申请单信息 - 自然人
     * @author 作者：lijj
     * @version 创建时间：2017年1月18日下午1:31:23
     * @param id
     * @return
     */
    public PersonReportApply getPReportApplyById(String id);

    /**
     * <描述>: 获取自然人信用报告数据
     * @author 作者：lijj
     * @version 创建时间：2017年1月18日下午1:48:08
     * @param themeInfo
     * @param params
     */
    public void getPCreditData(List<TemplateThemeNode> themeInfo, Map<String, Object> params);

    /**
     * <描述>: 绑定报告编号和自然人报告申请单的关系
     * @author 作者：lijj
     * @version 创建时间：2017年1月18日下午2:07:46
     * @param xybgbh
     * @param businessId
     */
    public void updatePXybgbh(String xybgbh, String businessId);

    /**
     * 保存操作日志
     * @param LogMap 业务类型名称
     */
    public void saveReportOperationLog(Map<String, Object> LogMap);

    /**
     * <描述>: 获取信用报告生成所需的字体大小配置
     * @author 作者：Ljj
     * @version 创建时间：2017年9月4日上午11:13:08
     * @return
     */
    public StReportFontSizeConfig getReportFontSizeConfig();

}
