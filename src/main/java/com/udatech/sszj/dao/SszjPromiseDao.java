package com.udatech.sszj.dao;

import com.udatech.common.model.CreditCommitmentQy;
import com.udatech.common.model.Promise;
import com.udatech.common.model.PromiseEnter;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.dao.BaseDao;
import com.wa.framework.user.model.SysDepartment;

import java.util.Map;

/**
 * @category 信用承诺
 * @author ccl
 */
public interface SszjPromiseDao extends BaseDao {

	/**
	 * @category 获取信用承诺列表
	 * @param page
	 * @param promise
	 * @return
	 */
	Pageable<Map<String, Object>> getPromiseList(Page page, Promise promise);

	/**
	 * @Title: getSupvEnterList
	 * @Description: 获取企业信息列表
	 * @param promiseEnter
	 * @return List<SuperviseEnter>
	 */
	Pageable<Map<String, Object>> getSupvEnterList(PromiseEnter promiseEnter,
                                                   Page page);

	/**
	 * @category 更新时间
	 * @param cnlb
	 * @param deptId
	 */
	void updateTime(String cnlb, String deptId);

	/**
	 * @category 获取承诺根据ID
	 * @param id
	 * @return
	 */
	Promise getPromiseById(String id);

	/**
	 * @category 移除承诺企业
	 * @param qyId
	 */
	void reomveEnter(String qyId);

	/**
	 * @category 查询企业信息
	 * @param id
	 * @return
	 */
	Promise getQyInfo(String id);

	/**
	 * @category 是否在黑名单中
	 * @param promise
	 * @return
	 */
	boolean isInBlacklist(Promise promise);

	/**
	 * @category 保存处理
	 * @param promise
	 */
	void savePromiseQyHandle(Promise promise, SysDepartment dept);

	/**
	 * 判断企业法人是否存在于数据库 中
	 * @param creditCommitmentQy
	 * @param enterpriseList
	 * @return true :已存在 false：不存在
	 */
	boolean isExistInDB(CreditCommitmentQy creditCommitmentQy);

}
