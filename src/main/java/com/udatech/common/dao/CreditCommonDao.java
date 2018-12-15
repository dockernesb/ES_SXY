package com.udatech.common.dao;

import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.EnterpriseBaseInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDao;
import com.wa.framework.user.model.SysUser;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CreditCommonDao extends BaseDao {

	/**
	 * @category 获取企业信息（异议专用）
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
	 * @Description: 保存上传文件
	 * @param names文件名称
	 * @param paths文件全路径
	 * @param type文件类型
	 * @param userId操作人id
	 * @param businessId业务id
	 * @return: void
	 */
	void saveUploadFiles(String[] names, String[] paths, UploadFileEnmu type,
						 String userId, String businessId);

	/**
	 * @category 获取上传文件列表
	 * @param id业务id
	 * @param type文件类型
	 * @return
	 */
	List<UploadFile> getUploadFiles(String id, UploadFileEnmu type);

	/**
	 * @category 获取信用信息
	 * @param info
	 * @param page
	 * @return
	 */
	Pageable<Map<String, Object>> getCreditInfo(EnterpriseInfo info, Page page);

	/**
	 * <描述>: 查询指定序列的下一个值
	 *
	 * @author 作者：lijj
	 * @version 创建时间：2016年12月9日下午2:59:21
	 * @param sequenceName
	 * @return
	 */
	String getSequenceNextValue(String sequenceName);

	/**
	 * @category 获取异议中的数据
	 * @return
	 */
	Map<String, List<String>> getObjectionData(String qymc, String zzjgdm,
											   String gszch, String tyshxydm);

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
	 * <描述>: 查询自然人基本信息
	 *
	 * @author 作者：lijj
	 * @version 创建时间：2017年1月13日下午3:36:08
	 * @param sfzh
	 *            身份证号
	 * @return
	 */
	Map<String, Object> getPersonInfo(String sfzh);

	/**
	 * @Title: getAllIndustryCode
	 * @Description: 查询所有行业类别
	 * @return List<Map<String,Object>>
	 */
	List<Map<String, Object>> getAllIndustryCode();

	/**
	 * @Title: getEnterDetail
	 * @Description: 获取企业基本信息
	 * @param tyshxydm
	 * @param gszch
	 * @param zzjgdm
	 * @param qymc
	 * @return Map<String,Object>
	 */
	Map<String, Object> getEnterDetail(String tyshxydm, String gszch,
									   String zzjgdm, String qymc);

	/**
	 * @Title: getEnterpriseBaseInfo
	 * @Description: 获取企业相关信息（股东，董事会等）
	 * @param info
	 * @param page
	 * @return Pageable<Map<String,Object>>
	 */
	Pageable<Map<String, Object>> getEnterpriseBaseInfo(
			EnterpriseBaseInfo info, Page page);

	/**
	 * @Title: findLegalPersonInfo
	 * @Description: 查询法人信息
	 * @param id
	 * @return Map<String,Object>
	 */
	Map<String, Object> findLegalPersonInfo(String id);

    /**
     * <描述>: 获取法人基本信息ID
     * @author 作者：lijj
     * @version 创建时间：2017年3月14日下午4:04:50
     * @param jgqc
     * @param gszch
     * @param zzjgdm
     * @param tyshxydm
     * @return
     */
    public String getEnterpriseId(String gszch, String zzjgdm, String tyshxydm);

    /**
     * <描述>: 获取自然人基本信息ID
     * @author 作者：lijj
     * @version 创建时间：2017年3月14日下午4:04:50
     * @param jgqc
     * @param gszch
     * @param zzjgdm
     * @param tyshxydm
     * @return
     */
    public String getPersonId(String sfzh);

	/**
	 * 获取自然人基本信息
	 * @param sfzh
	 * @return
	 */
	Map<String,Object> findPeopleInfo(String sfzh);

	/**
	 * 获取信用信息(失信表彰等信息...)
	 * @param sfzh
	 * @param tableName
	 * @param page
	 * @return
	 */
	Pageable<Map<String,Object>> getCreditInfo(String sfzh, String tableName, Page page);

	/**
	 * 根据身份证号获取职业名称
	 * @param sfzh
	 * @return
	 */
    String findPeopleZymc(String sfzh);

    UploadFile getUploadFileByFilePath(String filePath);
    
    /**
     * @return List<Map   <   String   ,   Object>>
     * @Title: getErrorCode
     * @Description: 查询疑问数据分类
     */
    List<Map<String, Object>> getErrorCode();

	/**
	 * @category 根据key查询用户
	 * @param caKey
	 * @return
	 */
	SysUser getUserByKey(String caKey);

	/**
	 * 获取异议申诉、信用修复中的数据
	 * @param dataId
	 * @param s
	 * @return
	 */
    List<Map<String,Object>> getEnterCreditData(String dataId, String type);

	/**
	 * 添加数据处理过程日志
	 *
	 * @param dealType 处理类别 1-数据上报 2-规则校验 3-关联入库
	 * @param taskCode  上报批次编号
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public int addDpProcessProcedureLog(String dealType, String taskCode, Date startTime, Date endTime);

	/**
	 * @Description: 更新数据处理日志
	 * @param: @param dealType 处理类别 1-数据上报 2-规则校验 3-关联入库
	 * @param: @param taskCode
	 * @param: @param endTime
	 * @param: @return
	 * @return: int
	 * @throws
	 * @since JDK 1.7.0_79
	 */
	public int updateDpProcessProcedureLog(String dealType, String taskCode, Date endTime);
}
