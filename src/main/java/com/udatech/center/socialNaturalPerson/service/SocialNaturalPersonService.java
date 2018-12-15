package com.udatech.center.socialNaturalPerson.service;

import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.List;
import java.util.Map;

/**
 * <描述>： 社会自然人Service<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2017年2月4日下午4:23:47
 */
public interface SocialNaturalPersonService {

    /**
     * @Title: queryList
     * @Description: 分页查询企业
     * @param page
     * @return
     * @return: Pageable<Map<String,Object>>
     */
    Pageable<Map<String, Object>> queryList(Page page, String xm, String sfzh, String zymc);

    /**
     * @Title: findLegalPersonInfo
     * @Description: 获取自然人基本信息
     * @param sfzh
     * @return
     * @return: Map<String,Object>
     */
    Map<String, Object> findNaturalPersonInfo(String sfzh);

    /**
     * <描述>: 获取指定自然人档案信息
     * @author 作者：lijj
     * @version 创建时间：2017年2月6日上午9:57:56
     * @param sfzh
     * @param tableName
     * @param page
     * @return
     */
    Pageable<Map<String, Object>> getCreditInfo(String oderColName, String orderType, String sfzh, String tableName, Page page);


    /**
     * 从ES里查询社保数据
     * @param sfzh
     * @param page
     * @return
     */
    List<Map<String, Object>> getSheBaoBInfoFromES(String sfzh);
}
