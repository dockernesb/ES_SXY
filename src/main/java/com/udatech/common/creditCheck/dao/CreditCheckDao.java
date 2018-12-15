package com.udatech.common.creditCheck.dao;

import com.udatech.common.model.CreditExamine;
import com.udatech.common.model.CreditExamineHis;
import com.udatech.common.model.EnterpriseExamine;
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
public interface CreditCheckDao extends BaseDao {

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
    Pageable<CreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
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
    Pageable<CreditExamine> findCreditExamineCondition(Page page, String scmc, String xqbm, String bjbh,
                                                       String sqsjs, String sqsjz, String userId, String status);

    /**
     * @param month
     * @return
     * @Title: findCountByMonth
     * @Description: 根据月份查询申请数量
     * @return: int
     */
    String findCountByMonth4Bar(String month, String deptId);

    /**
     * @return
     * @Title: findCountByMonth4Pie
     * @Description: 根据查询当前月状态
     * @return: String
     */
    List<Map<String, Object>> findCountByMonth4Pie(String deptId);

    /**
     * @param id
     * @return
     * @Title: findCreditExamineHisByCreditExamineId
     * @Description: 根据信用审查申请ID查询历史记录
     * @return: CreditExamineHis
     */
    CreditExamineHis findCreditExamineHisByCreditExamineId(String id);

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
    Pageable<EnterpriseExamine> getEnterList(Page page, String id);

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
    boolean isEnterpriseExisted(String qymc, String zzjgdm, String gszch, String shxydm);

    /**
     * @param criteria
     * @param page
     * @return
     * @Title: findEnterpriseExamineWithPage
     * @Description: 查找企业审核表
     * @return: Pageable<EnterpriseExamine>
     */
    Pageable<EnterpriseExamine> findEnterpriseExamineWithPage(DetachedCriteria criteria, Page page);

    /**
     * 统计条数
     *
     * @param qymc
     * @param gszch
     * @param zzjgdm
     * @param shxydm
     * @param tableName
     * @param scsjs
     * @param scsjz
     * @return
     */
    long getCount(String qymc, String gszch, String zzjgdm, String shxydm, String tableName, Date scsjs, Date scsjz);

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
//    List<Map<String, Object>> findList(String bjbh, String zzjgdm, String qymc, String gszch, String shxydm, String type, Date scsjs, Date scsjz);

    /**
     * 获取该审查下的企业
     *
     * @param id
     * @return
     */
    List<EnterpriseExamine> getEnterList(String id);

    List<Map<String, Object>> findScxxMsg(String bjbh, Map<String, Object> enterMap, TemplateThemeNode two, String scsjs, String scsjz);

    /**
     * 补全企业基本信息
     *
     * @param enterprise
     */
    void fillEnterprise(EnterpriseExamine enterprise);

}
