package com.udatech.common.service.impl;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.udatech.common.constant.Constants;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.model.EnterpriseBaseInfo;
import com.udatech.common.model.EnterpriseInfo;
import com.udatech.common.service.CreditCommonService;
import com.udatech.common.util.SingletonMap;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.CommonUtil;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.dao.SysUserDao;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.util.DateUtils;
import com.wa.framework.util.ObjectUtils;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.*;
import java.util.Map.Entry;

@Service
public class CreditCommonServiceImpl implements CreditCommonService {

	private static final Log log = LogFactory.getLog(CreditCommonServiceImpl.class);

	@Autowired
	private CreditCommonDao creditCommonDao;
    @Autowired
    @Qualifier("userDao")
    private SysUserDao userDao;
	/**
	 * <描述>: 查询指定序列的下一个值
	 *
	 * @author 作者：lijj
	 * @version 创建时间：2016年7月12日上午10:35:03
	 * @param SquenceName
	 * @return
	 */
	@Override
	public String getSequenceNextValue(String sequenceName) {
		return creditCommonDao.getSequenceNextValue(sequenceName);
	}

	/**
	 * @category 根据id查询用户
	 * @param userId
	 * @return
	 */
	@Override
	public SysUser findUserById(String userId) {
		SysUser user = creditCommonDao.get(SysUser.class, userId);
		return user;
	}

	/**
	 * @category 信用中心查询所有部门
	 * @return
	 */
	@Override
	public List<SysDepartment> findAllDept() {
		return creditCommonDao.find(SysDepartment.class, "departmentName");
	}

	/**
	 * @category 根据部门id查询部门信息
	 * @param deptId
	 * @return
	 */
	@Override
	public SysDepartment findDeptById(String deptId) {
		return creditCommonDao.get(SysDepartment.class, deptId);
	}

	/**
	 * @category 获取企业信息
	 * @param info
	 * @return
	 */
	@Override
	public EnterpriseInfo getEnterpriseInfo(EnterpriseInfo info) {
		return creditCommonDao.getEnterpriseInfo(info);
	}

	/**
	 * @category 获取企业列表
	 * @param keyword
	 * @return
	 */
	@Override
    public List<Map<String, Object>> getEnterpriseList(String keyword) {
		return creditCommonDao.getEnterpriseList(keyword);
	}

	/**
	 * @category 获取信用信息
	 * @param info
	 * @param page
	 * @return
	 */
	@Override
	public Pageable<Map<String, Object>> getCreditInfo(EnterpriseInfo info,
			Page page) {
		return creditCommonDao.getCreditInfo(info, page);
	}

	/**
	 * @category 根据ID查询上传文件(单个)
	 * @param businessId
	 * @param type
	 * @return
	 */
	@Override
	public UploadFile getUploadFile(String id) {
		return creditCommonDao.get(UploadFile.class, id);
	}

    @Override
    public UploadFile getUploadFileByFilePath(String filePath) {
        return creditCommonDao.getUploadFileByFilePath(filePath);
    }

    /**
	 * @category 获取异议中的数据
	 * @return
	 */
	@Override
	public Map<String, List<String>> getObjectionData(String qymc,
			String zzjgdm, String gszch, String tyshxydm) {
		return creditCommonDao.getObjectionData(qymc, zzjgdm, gszch, tyshxydm);
	}

	/**
	 * @param string4
	 * @param string3
	 * @param string2
	 * @param string
	 * @category 获取修复中的数据（信用修复中需要修复但尚未修复的数据）
	 * @return
	 */
	public Map<String, List<String>> getRepairData(String qymc, String zzjgdm, String gszch, String tyshxydm) {
        return creditCommonDao.getRepairData(qymc, zzjgdm, gszch, tyshxydm);
	}

	/**
	 * @Description: 初始化license是否过期或者正常
	 * @see： @see com.udatech.common.service.CommonService#initLicense()
	 * @since JDK 1.6
	 */
	@Override
	@PostConstruct
	public void initLicense() {
		Properties properties = new Properties();
		try {
			properties.load(Thread.currentThread().getContextClassLoader()
					.getResourceAsStream(Constants.LICENSE_CONFIG_PATH));
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}

		boolean isValidLicense = ObjectUtils.isValidLicense(properties);
		Map<String, Object> map = SingletonMap.getInstance();
		map.put(Constants.IS_VALID_LICENSE, isValidLicense);
	}

	@Override
	public Map<String, Object> getPersonInfo(String sfzh) {
		return creditCommonDao.getPersonInfo(sfzh);
	}

	/** 
     * @Description: 获取所有行业代码INDUSTRY_CODE_RELATION
     * @see： @see com.udatech.center.creditMap.service.CreditMapService#getAllIndustryCode()
     * @since JDK 1.6
     */
	@Override
	public List<Map<String, Object>> getAllIndustryCode() {
		return creditCommonDao.getAllIndustryCode();
	}
	
    /** 
     * @Description: 构造国标行业树
     * @see： @see com.udatech.center.creditMap.service.CreditMapService#buildIndustryTree(java.util.List)
     * @since JDK 1.6
     */
    public JSONArray buildIndustryTree(List<Map<String, Object>> industryCodeList) {
        JSONArray array = new JSONArray();
        
        // 构造根节点
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("id", "");
        jsonObj.put("text", "全部");
        
        // 构造行业子节点
        JSONArray subChildarray = new JSONArray();
        if (industryCodeList != null && industryCodeList.size() > 0){
            for (Map<String, Object> map : industryCodeList) {
                JSONObject subObj = new JSONObject();
                subObj.put("id", MapUtils.getString(map, "GB_CODE", ""));
                subObj.put("text", MapUtils.getString(map, "GB_NAME", ""));
                subChildarray.add(subObj);
            }
        }
        
        if (subChildarray.size() > 0) {
            jsonObj.put("children", subChildarray);
        } 
        array.add(jsonObj);
        
        return array;
    }

	@Override
	public Pageable<Map<String, Object>> getCreditInfo(String sfzh, String tableName, Page page) {
		return creditCommonDao.getCreditInfo(sfzh, tableName, page);
	}

	@Override
    public Map<String, Object> findLegalPersonInfo(String id) {
        Map<String, Object> resMap = creditCommonDao.findLegalPersonInfo(id);
        if (resMap.get("FZRQ") != null) {
            resMap.put("FZRQ", DateUtils.format((Date) resMap.get("FZRQ"), DateUtils.YYYYMMDD_10));
        }
        return resMap;
    }

	@Override
	public Map<String, Object> findPeopleInfo(String sfzh) {
		Map<String, Object> peopleInfoMap = creditCommonDao.findPeopleInfo(sfzh);
		if (peopleInfoMap != null && peopleInfoMap.size() > 0) {
			String zymc = creditCommonDao.findPeopleZymc(sfzh);
			peopleInfoMap.put("ZYMC" , zymc);
		} else {
			peopleInfoMap = new HashMap<>();
		}
		return peopleInfoMap;
	}

	@Override
    public Pageable<Map<String, Object>> getEnterpriseBaseInfo(EnterpriseBaseInfo info, Page page) {
        return creditCommonDao.getEnterpriseBaseInfo(info, page);
    }

    @Override
    public Map<String, Object> getEnterDetail(String tyshxydm, String gszch, String zzjgdm, String qymc) {
        return creditCommonDao.getEnterDetail(tyshxydm, gszch, zzjgdm, qymc);
    }
    
    /**
     * @Description: 根据sql封装图表查询结果
     * @param: @param dataSourceSql
     * @param: @param param
     * @param: @return
     * @return: Map<String,Object>
     * @throws
     * @since JDK 1.6
     */
    @Override
    @SuppressWarnings("unchecked")
    public Map<String, Object> getAllChartDatas(List<Map<String, Object>> dataList) {
        List<String> keyList = new ArrayList<String>();
        if (dataList != null && dataList.size() > 0){
            Map<String, Object> data = dataList.get(0);
            for (Entry<String, Object> main : data.entrySet()) {
                keyList.add(main.getKey());
            }
        }
        
        Map<String,Object> dataMap = new HashMap<String, Object>();
        for (String key : keyList) {
            List<Object> list = new ArrayList<Object>();
            dataMap.put(key, list);
        }
        
        Map<String, Object> chartsMap = new HashMap<String, Object>();
        for(Map<String, Object> data : dataList ){
            for (Entry<String, Object> main : data.entrySet()) {
                String key = main.getKey();
                Object value = main.getValue();
                
                List<Object> dataKeyList = (List<Object>) dataMap.get(key);
                dataKeyList.add(value);
            }
        }
        
        for (Entry<String, Object> main : dataMap.entrySet()) {
            String key = main.getKey();
            Object value = main.getValue();
            
            chartsMap.put(key, value);
        }
        
        return chartsMap;
    }

	/**
	 * @category 根据key查询用户
	 * @param caKey
	 * @return
	 */
	public SysUser getUserByKey(String caKey) {
		return creditCommonDao.getUserByKey(caKey);
	}
	
	@Override
    public List<Map<String, Object>> getErrorCode() {
        return creditCommonDao.getErrorCode();
    }
	
    /**
     * <描述>: 判断登录用户是不是信用中心用户
     * @author 作者：lijj
     * @version 创建时间：2016年7月20日上午9:47:45
     * @param request
     */
    public void checkDept(HttpServletRequest request) {
        SysUser sysUser = userDao.get(CommonUtil.getCurrentUserId());
        String type = sysUser.getType();
        // 判断登录用户是不是信用中心用户
        if (Constants.CENTER.equals(type) || Constants.ADMIN.equals(type)) {// 中心用户或管理员
            request.setAttribute("isCenterDept", true);
            request.setAttribute("deptId", "");
        } else {
            request.setAttribute("isCenterDept", false);
            request.setAttribute("deptId", sysUser.getSysDepartment().getId());

        }
        request.setAttribute("deptName", sysUser.getSysDepartment().getDepartmentName());

    }

}
