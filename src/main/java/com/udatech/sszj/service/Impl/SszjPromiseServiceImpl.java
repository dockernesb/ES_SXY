package com.udatech.sszj.service.Impl;

import com.udatech.common.constant.Constants;
import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.CreditCommitmentQy;
import com.udatech.common.model.Promise;
import com.udatech.common.model.PromiseEnter;
import com.udatech.common.util.CreditPromiseUtils;
import com.udatech.common.util.ExcelUtils;
import com.udatech.common.util.FileUtils;
import com.udatech.common.util.PropUtil;
import com.udatech.sszj.dao.SszjPromiseDao;
import com.udatech.sszj.service.SszjPromiseService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.UserIdThreadLocal;
import com.wa.framework.UsernameThreadLocal;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.log.ExpLog;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.util.DateUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @category 信用承诺
 * @author ccl
 */
@Service
@ExpLog(type="信用承诺管理")
public class SszjPromiseServiceImpl implements SszjPromiseService {

	@Autowired
	private SszjPromiseDao promiseDao;

	@Autowired
	private CreditCommonDao creditCommonDao;

	/**
	 * @category 获取信用承诺列表
	 * @param page
	 * @param promise
	 * @return
	 */
	@Override
	public Pageable<Map<String, Object>> getPromiseList(Page page,
			Promise promise) {
		Pageable<Map<String, Object>> pageable = promiseDao.getPromiseList(
				page, promise);

		List<Map<String, Object>> list = pageable.getList();

		if (list != null && !list.isEmpty()) {
			for (Map<String, Object> map : list) {
				String id = (String) map.get("ID");
				if (StringUtils.isNotBlank(id)) {
					List<UploadFile> files = creditCommonDao.getUploadFiles(id,
							UploadFileEnmu.信用承诺附件);
					if (files != null && !files.isEmpty()) {
						map.put("CN_FILE", files.get(0));
					}
				}
			}
		}

		return pageable;
	}

	/**
	 * @category 保存文件信息
	 * @param file
	 */
	@Override
	@Transactional
	public void saveFileInfo(UploadFile file) {
		promiseDao.save(file);
		Promise p = promiseDao.getPromiseById(file.getBusinessId());
		promiseDao.updateTime(p.getCnlbKey(), p.getDeptId());
	}

	/**
	 * @category 删除文件信息
	 * @param file
	 */
	@Override
	@Transactional
	public void deleteFileInfo(UploadFile file) {
		promiseDao.delete(file);
		Promise p = promiseDao.getPromiseById(file.getBusinessId());
		promiseDao.updateTime(p.getCnlbKey(), p.getDeptId());
	}

	@Override
	public Pageable<Map<String, Object>> findEnterByPage(Page page,
			PromiseEnter promiseEnter) {
		Pageable<Map<String, Object>> pageable = promiseDao.getSupvEnterList(
				promiseEnter, page);
		getFileInfo(pageable.getList());
		return pageable;
	}

	private void getFileInfo(List<Map<String, Object>> list) {
		if (list != null && !list.isEmpty()) {
			for (Map<String, Object> map : list) {
				String id = (String) map.get("ID");
				if (StringUtils.isNotBlank(id)) {
					List<UploadFile> files = creditCommonDao.getUploadFiles(id,
							UploadFileEnmu.信用承诺附件);
					if (files != null && !files.isEmpty()) {
						map.put("CN_FILE", files.get(0));
					}
				}

				String time = (String) map.get("GSJZQ");
				if (StringUtils.isNotBlank(time)) {
					String current = DateUtils.format(new Date(),
							DateUtils.YYYYMMDD_10);
					if (current.compareTo(time) >= 0) {
						map.put("STATUS", 2);
					}
				}
			}
		}
	}

	@Override
	public void templateDownload(HttpServletResponse response,
			HttpServletRequest request) throws Exception {
		String fileName = PropUtil.get("enterTemplate.file.name");
		String filePath = PropUtil.get("enterTemplate.file.path");
		// 读到流中
		InputStream inStream = new FileInputStream(request.getSession()
				.getServletContext().getRealPath(filePath)); // 文件的存放路径
		FileUtils.setDownFileName(response, request, fileName);

		// 循环取出流中的数据
		byte[] b = new byte[100];
		int len;
		try {
			while ((len = inStream.read(b)) > 0) {
				response.getOutputStream().write(b, 0, len);
			}
			inStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	@Transactional
	public boolean addEnter(CreditCommitmentQy creditCommitmentQy) {
		creditCommitmentQy.setCreateUser(UserIdThreadLocal.getInstance().getUserId());
		creditCommitmentQy.setCreateTime(new Date());
		boolean isExistInDB = promiseDao.isExistInDB(creditCommitmentQy);
		if (isExistInDB) {
			return false;
		}

		promiseDao.save(creditCommitmentQy);

		String cnlb = creditCommitmentQy.getCnlb();
		String deptId = creditCommitmentQy.getDeptId();
		promiseDao.updateTime(cnlb, deptId);
		return true;
	}

	@Override
	@Transactional
	public int batchAdd(Workbook wb, String cnlb, String deptId,
			StringBuffer message) {
		List<CreditCommitmentQy> enterpriseList = new ArrayList<CreditCommitmentQy>();
		Row row;
		String zzjgdm = "";
		String qymc = "";
		String gszch = "";
		String shxydm = "";
		Sheet sheet = wb.getSheetAt(0);
		for (int i = 1; i < sheet.getLastRowNum() + 1; i++) {
			CreditCommitmentQy creditCommitmentQy = new CreditCommitmentQy();
			creditCommitmentQy.setId(UUID.randomUUID().toString());
			creditCommitmentQy.setCreateUser(UsernameThreadLocal.getInstance()
					.getUsername());
			creditCommitmentQy.setCreateTime(new Date());
			creditCommitmentQy.setCnlb(cnlb);
			creditCommitmentQy.setDeptId(deptId);

			row = sheet.getRow(i);
			if (row == null) {
				continue;
			}
			qymc = StringUtils.trim(ExcelUtils.getCell(row.getCell(0)));
			gszch = StringUtils.trim(ExcelUtils.getCell(row.getCell(1)));
			zzjgdm = StringUtils.trim(ExcelUtils.getCell(row.getCell(2)));
			shxydm = StringUtils.trim(ExcelUtils.getCell(row.getCell(3)));
			if (StringUtils.isBlank(zzjgdm) && StringUtils.isBlank(qymc)
					&& StringUtils.isBlank(gszch)) {
				message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1)
						+ " : 没有数据 , 跳过解析<br>");
				continue;
			}

			if (StringUtils.isBlank(qymc)) {
				message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " :「"
						+ Constants.TITLE_QYMC + "」不能为空 <br>");
				continue;
			} else {
				creditCommitmentQy.setQymc(qymc);
			}

			if ((StringUtils.isBlank(zzjgdm) || StringUtils.isBlank(gszch))
					&& StringUtils.isBlank(shxydm)) {
				message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " : 若没有「"
						+ Constants.TITLE_SHXYDM + "」 ,「"
						+ Constants.TITLE_ZZJGDM + "」「" + Constants.TITLE_GSZCH
						+ "」不能为空<br>");
				continue;
			} else {
				creditCommitmentQy.setGszch(gszch);
				creditCommitmentQy.setZzjgdm(zzjgdm);
				creditCommitmentQy.setTyshxydm(shxydm);
			}

			boolean isExistInDB = promiseDao.isExistInDB(creditCommitmentQy);
			boolean isExistInEnterList = CreditPromiseUtils.isExistInEnterList(creditCommitmentQy, enterpriseList);
			if (isExistInDB || isExistInEnterList) {
				message.append("&nbsp;&nbsp;&nbsp;&nbsp;行 " + (i + 1) + " ：该企业已存在。<br>");
				continue;
			}
			enterpriseList.add(creditCommitmentQy);
		}
		promiseDao.saveAll(enterpriseList);
		promiseDao.updateTime(cnlb, deptId);

		return enterpriseList.size();
	}

	/**
	 * @category 移除承诺企业
	 * @param qyId
	 */
	@Transactional
	public void reomveEnter(String qyId) {
		Promise p = promiseDao.getPromiseById(qyId);
		promiseDao.updateTime(p.getCnlbKey(), p.getDeptId());
		promiseDao.reomveEnter(qyId);
	}

	/**
	 * @category 查询企业信息
	 * @param id
	 * @return
	 */
	public Promise getQyInfo(String id) {
		return promiseDao.getQyInfo(id);
	}

	/**
	 * @category 保存处理
	 * @param promise
	 */
	@Transactional
	public void savePromiseQyHandle(Promise promise, SysDepartment dept) {
		boolean inBlacklist = promiseDao.isInBlacklist(promise);
		if (!inBlacklist) {
			promiseDao.savePromiseQyHandle(promise, dept);
			Promise p = promiseDao.getPromiseById(promise.getId());
			promiseDao.updateTime(p.getCnlbKey(), p.getDeptId());
		}
	}

}
