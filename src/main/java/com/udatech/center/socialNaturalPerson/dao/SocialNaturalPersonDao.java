package com.udatech.center.socialNaturalPerson.dao;

import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.Map;

/**
 * <描述>： 社会自然人Dao<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2017年2月4日下午4:23:27
 */
public interface SocialNaturalPersonDao {

    /**
     * <描述>: 分页查询自然人信息
     * @author 作者：lijj
     * @version 创建时间：2017年2月5日下午3:48:32
     * @param page
     * @param xm
     * @param sfzh
     * @return
     */
    Pageable<Map<String, Object>> getQueryList(Page page, String xm, String sfzh, String zymc);

    /**
     * @Title: findLegalPersonInfo
     * @Description: 获取自然人基本信息
     * @param sfzh
     * @return: void
     */
    public Map<String, Object> findNaturalPersonInfo(String sfzh);

    /**
     * <描述>: 获取指定自然人档案信息
     * @author 作者：lijj
     * @version 创建时间：2017年2月6日上午9:58:39
     * @param sfzh
     * @param tableName
     * @param page
     * @return
     */
    Pageable<Map<String, Object>> getCreditInfo(String oderColName, String orderType, String sfzh, String tableName, Page page);

}
