package com.udatech.common.creditReportQuery.dao;

import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.common.model.PersonReportApply;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.wa.framework.dao.BaseDao;

import java.util.List;
import java.util.Map;

/**
 * <描述>： 公共信用报告内容查询<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月6日下午3:26:36
 */
public interface CreditReportQueryDao extends BaseDao {
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
     * <描述>: 查询报告申请企业的详细信息，严格查询
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:23:38
     * @param params
     * @return
     */
    public Map<String, Object> findEnterpriseInfoStrict(Map<String, Object> params);

    /**
     * <描述>: 查询报告申请企业的详细信息，模糊查询
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:28:58
     * @param zzjgdm
     * @param qymc
     * @param gszch
     * @param shxydm
     * @return
     */
    public Map<String, Object> findEnterpriseInfoLike(String zzjgdm, String qymc, String gszch, String shxydm);

    /**
     * <描述>: 根据报告模板查询报告数据 - 法人
     * @author 作者：lijj
     * @version 创建时间：2016年12月6日下午3:29:31
     * @param themeTwo
     * @param params
     * @return
     */
    public List<Map<String, Object>> getCreditData(TemplateThemeNode themeTwo, Map<String, Object> params);

    /**
     * <描述>: 查询指定序列的下一个值
     * @author 作者：lijj
     * @version 创建时间：2016年12月8日上午11:30:31
     * @param squenceName
     * @return
     */
    public String findSquence(String squenceName);

    /**
     * <描述>: 绑定报告编号和法人报告申请单的关系
     * @author 作者：lijj
     * @version 创建时间：2016年12月8日上午11:36:18
     * @param xybgbh
     * @param businessId
     */
    public void updateXybgbh(String xybgbh, String businessId);

    /**
     * <描述>: 根据ID获取信用报告申请单信息 - 自然人
     * @author 作者：lijj
     * @version 创建时间：2017年1月18日下午1:32:51
     * @param id
     * @return
     */
    public PersonReportApply getPReportApplyById(String id);

    /**
     * <描述>: 根据报告模板查询报告数据 - 自然人
     * @author 作者：lijj
     * @version 创建时间：2017年1月18日下午1:49:54
     * @param themeTwo
     * @param params
     * @return
     */
    public List<Map<String, Object>> getPCreditData(TemplateThemeNode themeTwo, Map<String, Object> params);

    /**
     * <描述>: 绑定报告编号和自然人报告申请单的关系
     * @author 作者：lijj
     * @version 创建时间：2017年1月18日下午2:08:41
     * @param xybgbh
     * @param businessId
     */
    public void updatePXybgbh(String xybgbh, String businessId);
}
