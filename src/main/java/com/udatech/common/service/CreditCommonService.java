package com.udatech.common.service;

import com.alibaba.fastjson.JSONArray;
import com.udatech.common.model.EnterpriseBaseInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface CreditCommonService {

    /**
     * @category 根据id查询用户
     * @param userId
     * @return
     */
    SysUser findUserById(String userId);

    /**
     * @category 信用中心查询所有部门
     * @return
     */
    List<SysDepartment> findAllDept();

    /**
     * @category 根据部门id查询部门信息
     * @param deptId
     * @return
     */
    SysDepartment findDeptById(String deptId);

    /**
     * @category 获取企业信息
     * @param info
     * @return
     */
    EnterpriseInfo getEnterpriseInfo(EnterpriseInfo info);

    /**
     * @category 获取企业列表
     * @param keyword
     * @return
     */
    List<Map<String, Object>> getEnterpriseList(String keyword);

    /**
     * @category 获取信用信息
     * @param info
     * @param page
     * @return
     */
    Pageable<Map<String, Object>> getCreditInfo(EnterpriseInfo info, Page page);

    /**
     * <描述>: 查询指定序列的下一个值
     * @author 作者：lijj
     * @version 创建时间：2016年12月9日下午2:58:02
     * @param string
     * @return
     */
    String getSequenceNextValue(String string);

    /**
     * @category 根据ID查询上传文件
     * @param businessId
     * @param type
     * @return
     */
    UploadFile getUploadFile(String id);

    /**
     * @category 根据文件路劲查询上传文件
     * @param businessId
     * @param type
     * @return
     */
    UploadFile getUploadFileByFilePath(String filePath);

    /**
     * @param string4
     * @param string3
     * @param string2
     * @param string
     * @category 获取异议中的数据（异议申诉申请中需要修正但尚未修正的数据）
     * @return
     */
    Map<String, List<String>> getObjectionData(String qymc, String zzjgdm, String gszch, String tyshxydm);

    /**
     * @param string4
     * @param string3
     * @param string2
     * @param string
     * @category 获取修复中的数据（信用修复中需要修复但尚未修复的数据）
     * @return
     */
    Map<String, List<String>> getRepairData(String qymc, String zzjgdm, String gszch, String tyshxydm);

    /**
     * @Description: 初始化license是否过期或者正常
     * @param:
     * @return: void
     * @throws
     * @since JDK 1.6
     */
    public void initLicense();

    /**
     * <描述>: 查询自然人基本信息
     * @author 作者：lijj
     * @version 创建时间：2017年1月13日下午3:34:56
     * @param sfzh 身份证号
     * @return
     */
    Map<String, Object> getPersonInfo(String sfzh);

    /**
     * @Title: findLegalPersonInfo
     * @Description: 查询企业信息
     * @param enterId
     * @return Map<String,Object>
     */
    Map<String, Object> findLegalPersonInfo(String id);

    /**
     * 根据自然人身份证号查询基本信息
     * @param sfzh
     * @return
     */
    Map<String, Object> findPeopleInfo(String sfzh);

    /**
     * @Title: getEnterpriseBaseInfo
     * @Description: 获取企业相关信息（股东，董事会等）
     * @param info
     * @param page
     * @return Pageable<Map<String,Object>>
     */
    Pageable<Map<String, Object>> getEnterpriseBaseInfo(EnterpriseBaseInfo info, Page page);

    /**
     * @Title: getEnterDetail
     * @Description: 获取企业基本信息
     * @param tyshxydm
     * @param gszch
     * @param zzjgdm
     * @param qymc
     * @return Map<String,Object>
     */
    Map<String, Object> getEnterDetail(String tyshxydm, String gszch, String zzjgdm, String qymc);
    
    /**
     * @Description: 获取所有行业代码INDUSTRY_CODE_RELATION
     * @param: @return
     * @return: List<Map<String,Object>>
     * @throws
     * @since JDK 1.6
     */
    public List<Map<String, Object>> getAllIndustryCode();
    
    /**
     * @Description: 构造国标行业树
     * @param: @param industryCodeList INDUSTRY_CODE_RELATION表中的行业数据
     * @param: @return
     * @return: JSONArray
     * @throws
     * @since JDK 1.6
     */
    public JSONArray buildIndustryTree(List<Map<String, Object>> industryCodeList);

    /**
     * 获取信用信息(失信表彰等信息...)
     * @param sfzh
     * @param tableName
     * @param page
     * @return
     */
    Pageable<Map<String,Object>> getCreditInfo(String sfzh, String tableName, Page page);
    
    /**
     * @Description: 根据sql封装图表查询结果
     * @param: @param dataSourceSql
     * @param: @param param
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    public Map<String, Object> getAllChartDatas(List<Map<String, Object>> dataList);

    /**
     * @throws
     * @Description: 获取ErrorCode
     * @param: @return
     * @return: List<Map   <   String   ,   Object>>
     * @since JDK 1.6
     */
    public List<Map<String, Object>> getErrorCode();
    
    /**
     * @category 根据key查询用户
     * @param caKey
     * @return
     */
    SysUser getUserByKey(String caKey);
    public void checkDept(HttpServletRequest request);
}
