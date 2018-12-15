package com.udatech.common.creditReportQuery.service.impl;

import com.udatech.common.creditReportQuery.dao.CreditReportQueryDao;
import com.udatech.common.creditReportQuery.service.CreditReportQueryService;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.dataTrace.dao.DataTraceDao;
import com.udatech.common.dataTrace.util.DataTraceUtil;
import com.udatech.common.dataTrace.vo.DataTraceVo;
import com.udatech.common.enmu.DataTraceItemEnum;
import com.udatech.common.enmu.DataTraceItemTypeEnum;
import com.udatech.common.model.DtCreditReportOperationLog;
import com.udatech.common.model.EnterpriseReportApply;
import com.udatech.common.model.PersonReportApply;
import com.udatech.common.model.StReportFontSizeConfig;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.wa.framework.log.ExpLog;
import com.wa.framework.user.model.SysUser;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * <描述>：公共信用报告内容查询 <br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2016年12月6日下午3:26:03
 */
@Service
@ExpLog(type = "公共信用报告内容查询")
public class CreditReportQueryServiceImpl implements CreditReportQueryService {
    @Autowired
    private CreditReportQueryDao creditReportQueryDao;

    @Autowired
    private CreditCommonDao creditCommonDao;

    @Autowired
    private DataTraceDao dataTraceDao;

    /**
     * <描述>:查询指定序列的下一个值
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日上午11:03:43
     * @param SquenceName 序列名
     * @return
     */
    public String findBgbh(String SquenceName) {
        return creditReportQueryDao.findSquence(SquenceName);
    }

    @Override
    public EnterpriseReportApply getReportApplyById(String id) {
        return creditReportQueryDao.getReportApplyById(id);
    }

    /**
     * <描述>:获取企业信息, 模糊查询(xx like '%xx%')
     * @author 作者：lijj
     * @version 创建时间：2016年5月13日下午2:00:40
     * @param zzjgdm
     * @param qymc
     * @param gszch
     * @param shxydm
     * @return
     */
    public Map<String, Object> findEnterpriseInfoLike(String zzjgdm, String qymc, String gszch, String shxydm) {
        return creditReportQueryDao.findEnterpriseInfoLike(zzjgdm, qymc, gszch, shxydm);
    }

    /**
     * <描述>: 获取企业信息, 严格查询（xx=xx）
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日上午10:44:59
     * @param params
     * @return
     */
    public Map<String, Object> findEnterpriseInfoStrict(Map<String, Object> params) {
        return creditReportQueryDao.findEnterpriseInfoStrict(params);
    }

    /**
     * <描述>: 获取自然人信息，姓名加身份证
     * @author 作者：lijj
     * @version 创建时间：2016年5月17日上午10:44:59
     * @param params
     * @return
     */
    @Override
    public Map<String, Object> findEnterpriseInfoStrictZrr(Map<String, Object> params) {
        return creditReportQueryDao.findEnterpriseInfoStrictZrr(params);
    }
    
    /**
     * <描述>: 获取模板资源对应的数据
     * @author 作者：lijj
     * @version 创建时间：2016年5月13日下午5:23:56
     * @param themeInfo
     * @param params
     * @return
     */
    public void getCreditData(List<TemplateThemeNode> themeInfo, Map<String, Object> params) {
        // 批量记录数据使用日志
        List<DataTraceVo> dataTraceList = new ArrayList<DataTraceVo>();
        String zzjgdm = MapUtils.getString(params, "zzjgdm", "");
        String gszch = MapUtils.getString(params, "gszch", "");
        String tyshxydm = MapUtils.getString(params, "tyshxydm", "");
        String bjbh = MapUtils.getString(params, "bjbh", "");
        String creditSubjectId = creditCommonDao.getEnterpriseId(gszch, zzjgdm, tyshxydm);

        for (TemplateThemeNode theme : themeInfo) {// 一级资源
            for (TemplateThemeNode themeTwo : theme.getChildren()) {
                List<Map<String, Object>> data = creditReportQueryDao.getCreditData(themeTwo, params);
                if (data != null) {
                    for (Map<String, Object> map : data) {
                        // 列表加载的数据，默认都选中，生成打印页面时提供数据源
                        map.put("themeId", themeTwo.getId());
                        map.put("checked", true);

                        if ("jdbcTemplate".equals(themeTwo.getDataSource())) {// 只有业务库的数据才做记录
                            // 批量记录数据使用日志
                            DataTraceVo dataTrace = new DataTraceVo();
                            dataTrace.setId(MapUtils.getString(map, "UUID"));
                            dataTrace.setItem(DataTraceItemEnum.信用报告生成.getKey());
                            dataTrace.setTableName(themeTwo.getDataTable());
                            dataTrace.setItemType(DataTraceItemTypeEnum.信用报告.getKey());
                            dataTrace.setCreditSubjectId(creditSubjectId);
                            dataTrace.setServiceNo(bjbh);
                            dataTraceDao.getDataTrace(dataTrace);// 补充数据
                            dataTraceList.add(dataTrace);
                        }
                    }
                    themeTwo.setData(data);
                }
            }
        }

        // 批量记录数据使用日志(记入索引库)
        DataTraceUtil.batchDataTrace(dataTraceList);
    }

    @Override
    public void updateXybgbh(String xybgbh, String businessId) {
        creditReportQueryDao.updateXybgbh(xybgbh, businessId);
    }

    @Override
    public PersonReportApply getPReportApplyById(String id) {
        return creditReportQueryDao.getPReportApplyById(id);
    }

    @Override
    public void getPCreditData(List<TemplateThemeNode> themeInfo, Map<String, Object> params) {
        for (TemplateThemeNode theme : themeInfo) {// 一级资源
            for (TemplateThemeNode themeTwo : theme.getChildren()) {
                List<Map<String, Object>> data = creditReportQueryDao.getPCreditData(themeTwo, params);
                if (data != null) {
                    for (Map<String, Object> map : data) {
                        // 列表加载的数据，默认都选中，生成打印页面时提供数据源
                        map.put("themeId", themeTwo.getId());
                        map.put("checked", true);
                    }
                    themeTwo.setData(data);
                }
            }
        }
    }

    @Override
    public void updatePXybgbh(String xybgbh, String businessId) {
        creditReportQueryDao.updatePXybgbh(xybgbh, businessId);
    }

    /**
     * 保存操作日志
     * @param LogMap
     */
    @Override
    public void saveReportOperationLog(Map<String, Object> LogMap) {
        DtCreditReportOperationLog log = new DtCreditReportOperationLog();
        log.setApplyId((String) LogMap.get("appId"));
        log.setBusinessName((String) LogMap.get("businessName"));
        log.setOperationDate(new Date());

        if (StringUtils.isNotEmpty((String) LogMap.get("userId"))) {
            log.setOperationUser(new SysUser((String) LogMap.get("userId")));
        }

        log.setRemark((String) LogMap.get("remark"));
        creditReportQueryDao.save(log);
    }

    @Override
    public StReportFontSizeConfig getReportFontSizeConfig() {
        List<StReportFontSizeConfig> list = creditReportQueryDao.getAll(StReportFontSizeConfig.class);
        return list != null && list.size() > 0 ? list.get(0) : null;
    }

    

}
