package com.udatech.common.util;

import com.udatech.common.model.EnterpriseExamine;
import com.udatech.common.model.PeopleExamine;
import org.apache.commons.lang3.StringUtils;

import java.util.List;

/**
 * @Description: 信用审查工具类
 * @author: 何斐
 * @date: 2017年11月14日 下午4:12:52
 */
public class CreditCheckUtils {
    /**
     * 判断企业法人是否存在于 list 中
     * @param enterpriseExamine
     * @param enterpriseList
     * @return true :已存在 false：不存在
     */
    public static boolean isExistInEnterList(EnterpriseExamine enterpriseExamine, List<EnterpriseExamine> enterpriseList) {
        // 是否存在于集合中
        boolean isInList = false;
        if (enterpriseList != null && enterpriseList.size() > 0) {
            boolean isSameTyshxydm = false;
            boolean isSameGszch = false;
            boolean isSameZzjgdm = false;
            for (EnterpriseExamine existEnter : enterpriseList) {
                // 判断统一社会信用代码是否一致
                if (StringUtils.isNotBlank(existEnter.getShxydm())) {
                    if (StringUtils.equals(existEnter.getShxydm(), enterpriseExamine.getShxydm())) {
                        isSameTyshxydm = true;
                    }
                }
                if (StringUtils.isNotBlank(existEnter.getZzjgdm())) { // 判断组织机构代码是否一致
                    if (StringUtils.equals(existEnter.getZzjgdm(), enterpriseExamine.getZzjgdm())) {
                        isSameZzjgdm = true;
                    }
                }
                if (StringUtils.isNotBlank(existEnter.getGszch())) { // 判断工商注册号是否一致
                    if (StringUtils.equals(existEnter.getGszch(), enterpriseExamine.getGszch())) {
                        isSameGszch = true;
                    }
                }
                if (isSameTyshxydm || isSameZzjgdm || isSameGszch) {
                    isInList = true;
                    break;
                }
            }
        }
        return isInList;
    }

    /**
     * 判断自然人是否存在于 list 中
     * @param peopleExamine
     * @param peopleList
     * @return true :已存在 false：不存在
     */
    public static boolean isExistInPeopleList(PeopleExamine peopleExamine, List<PeopleExamine> peopleList) {
        // 是否存在于集合中
        boolean isInList = false;
        if (peopleList != null && peopleList.size() > 0) {
            for (PeopleExamine existPeople : peopleList) {
                // 判断身份证号是否一致
                if (StringUtils.equals(peopleExamine.getSfzh(), existPeople.getSfzh())) {
                    isInList = true;
                    break;
                }
            }
        }
        return isInList;
    }

}
