package com.udatech.center.socialNaturalPerson.service.impl;

import com.udatech.center.socialNaturalPerson.dao.SocialNaturalPersonDao;
import com.udatech.center.socialNaturalPerson.service.SocialNaturalPersonService;
import com.udatech.common.constant.Constants;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.elastic.ESUtils_sub;
import com.wa.framework.log.ExpLog;
import com.wa.framework.service.BaseService;
import com.wa.framework.util.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <描述>： 社会自然人ServiceImpl<br>
 * @author 创建人：lijj<br>
 * @version 创建时间：2017年2月4日下午4:24:27
 */
@Service
@ExpLog(type="社会自然人管理")
public class SocialNaturalPersonServiceImpl extends BaseService implements SocialNaturalPersonService {
    @Autowired
    private SocialNaturalPersonDao socialNaturalPersonDao;

    @Override
    public Pageable<Map<String, Object>> queryList(Page page, String xm, String sfzh, String zymc) {
        return socialNaturalPersonDao.getQueryList(page, xm, sfzh, zymc);
    }

    @Override
    public Map<String, Object> findNaturalPersonInfo(String sfzh) {
        Map<String, Object> resMap = socialNaturalPersonDao.findNaturalPersonInfo(sfzh);
        if (resMap.get("CSRQ") != null) {
            resMap.put("CSRQ", DateUtils.format((Date) resMap.get("CSRQ"), DateUtils.YYYYMMDD_10));
        }
        return resMap;
    }

    @Override
    public Pageable<Map<String, Object>> getCreditInfo(String oderColName, String orderType, String sfzh, String tableName, Page page) {
        return socialNaturalPersonDao.getCreditInfo(oderColName, orderType, sfzh, tableName, page);
    }

    @Override
    public List<Map<String, Object>> getSheBaoBInfoFromES(String sfzh){
        ESUtils_sub client = new ESUtils_sub();
        Map<String, String> map = new HashMap<String, String>();
        map.put("SFZJHM", sfzh);
        return client.getAllListOrder(map,"JNRQ", Constants.ORDER_DESC);
    }

}
