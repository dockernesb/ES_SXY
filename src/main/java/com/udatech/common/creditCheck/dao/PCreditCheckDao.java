package com.udatech.common.creditCheck.dao;

import com.udatech.common.model.PCreditExamine;
import com.udatech.common.model.PCreditExamineHis;
import com.udatech.common.model.PeopleExamine;
import com.udatech.common.resourceManage.vo.TemplateThemeNode;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDao;
import com.wa.framework.user.model.SysUser;
import org.hibernate.criterion.DetachedCriteria;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @Description: 信用审查Dao(中心端)
 * @author: 何斐
 * @date: 2016年11月21日 下午3:52:29
 */
public interface PCreditCheckDao extends BaseDao {

    /**
     * @param sysuserid
     * @return
     * @Title: findUserById
     * @Description: 根据用户id查询该用户信息
     * @return: SysUser
     */
    SysUser findUserById(String sysuserid);

    /**
     * @param page
     * @param scmc
     * @param xqbm
     * @param bjbh
     * @param sqsjs
     * @param sqsjz
     * @param userId
     * @param status
     * @return
     * @Title: findCreditExamineCondition
     * @Description: 根据条件查询审核列表
     * @return: Pageable<CreditExamine>
     */
    Pageable<PCreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
                                                        String sqsjs, String sqsjz, String userId, String status, String type, String bjbm);

    /**
     * @param page
     * @param scmc
     * @param xqbm
     * @param bjbh
     * @param sqsjs
     * @param sqsjz
     * @param userId
     * @param status
     * @return
     * @Title: findCreditExamineCondition
     * @Description: 根据条件查询审核列表
     * @return: Pageable<CreditExamine>
     */
    Pageable<PCreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
                                                        String sqsjs, String sqsjz, String userId, String status);

    /**
     * @param id
     * @return
     * @Title: findCreditExamineHisByCreditExamineId
     * @Description: 根据信用审查申请ID查询历史记录
     * @return: CreditExamineHis
     */
    PCreditExamineHis findCreditExamineHisByCreditExamineId(String id);

    /**
     * @param id
     * @param type
     * @return
     * @Title: findUploadFile
     * @Description: 获取上传文件信息
     * @return: UploadFile
     */
    UploadFile findUploadFile(String id, String type);

    /**
     * @param page
     * @param id
     * @return
     * @Title: getEnterList
     * @Description: 获取审核企业列表
     * @return: Pageable<EnterpriseExamine>
     */
    Pageable<PeopleExamine> getPeopleList(Page page, String id);

    /**
     * @param qymc
     * @param zzjgdm
     * @param gszch
     * @param shxydm
     * @return
     * @Title: isEnterpriseExisted
     * @Description: 判断企业是否存在
     * @return: boolean
     */
    boolean isPeopleExisted(String sfzh);

    /**
     * @param criteria
     * @param page
     * @return
     * @Title: findEnterpriseExamineWithPage
     * @Description: 查找企业审核表
     * @return: Pageable<EnterpriseExamine>
     */
    Pageable<PeopleExamine> findEnterpriseExamineWithPage(DetachedCriteria criteria, Page page);

    /**
     * @param qymc
     * @param gszch
     * @param zzjgdm
     * @param shxydm
     * @param tableName
     * @return
     * @Title: getCount
     * @Description: 统计条数
     * @return: long
     */
    long getCount(String sfzh, String tableName, Date scsjs, Date scsjz);

//    /**
//     * @Title: findList
//     * @Description: 根据企业名称、组织机构代码、工商注册号查询库中各个合表数据
//     * @param bjbh
//     * @param zzjgdm
//     * @param qymc
//     * @param gszch
//     * @param shxydm
//     * @param type
//     * @return
//     * @return: List<Map<String,Object>>
//     */
//     List<Map<String, Object>> findList(String sfzh, String type, Date scsjs, Date scsjz);

    List<PeopleExamine> getPeopleList(String id);

    List<Map<String, Object>> findScxxMsg(Map<String, Object> existPeople, TemplateThemeNode two, Date beginDate, Date endDate);
}
