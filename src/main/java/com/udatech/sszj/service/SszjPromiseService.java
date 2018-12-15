package com.udatech.sszj.service;

import com.udatech.common.model.CreditCommitmentQy;
import com.udatech.common.model.Promise;
import com.udatech.common.model.PromiseEnter;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.user.model.SysDepartment;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * @category 信用承诺
 * @author ccl
 */
public interface SszjPromiseService {

	/**
	 * @category 获取信用承诺列表
	 * @param page
	 * @param promise
	 * @return
	 */
	Pageable<Map<String, Object>> getPromiseList(Page page, Promise promise);

	/**
	 * @Title: findEnterByPage
	 * @Description: 获取企业列表
	 * @param page
	 * @param promiseEnter
	 * @return Pageable<SuperviseEnter>
	 */
	Pageable<Map<String, Object>> findEnterByPage(Page page,
                                                  PromiseEnter promiseEnter);

	/**
	 * @Title: templateDownload
	 * @Description: 下载模板
	 * @param response
	 * @param request
	 *            void
	 */
	void templateDownload(HttpServletResponse response,
                          HttpServletRequest request) throws Exception;

	/**
	 * @category 保存文件信息
	 * @param file
	 */
	void saveFileInfo(UploadFile file);

	/**
	 * @category 删除文件信息
	 * @param file
	 */
	void deleteFileInfo(UploadFile file);

	/**
	 * @Title: addEnter
	 * @Description: 手动录入企业
	 * @param creditCommitmentQy
	 *            void
	 */
	boolean addEnter(CreditCommitmentQy creditCommitmentQy);

	/**
	 * @Title: batchAdd
	 * @Description: 批量导入
	 * @param wb
	 * @param cnlb
	 * @param deptId
	 * @param message
	 * @return int
	 */
	int batchAdd(Workbook wb, String cnlb, String deptId, StringBuffer message);

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
	 * @category 保存处理
	 * @param promise
	 */
	void savePromiseQyHandle(Promise promise, SysDepartment dept);

}
