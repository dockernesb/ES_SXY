package com.udatech.sszj.service.Impl;

import com.udatech.sszj.dao.SszjStatisticsDao;
import com.udatech.sszj.service.SszjStatisticsService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.service.BaseService;
import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @author 作者:zhanglei
 * @version 创建时间:2018/12/13 0013 10:40
 * @Description 描述:
 */
@Service
public class SszjStatisticsServiceImpl extends BaseService implements SszjStatisticsService {

	@Autowired
	private SszjStatisticsDao sszjStatisticsDao;

	/**
	 * @Description: 获得统计页面标签数据
	 * @author zhanglei
	 * @date 15:33 2018/12/13 0013
	 */
	@Override
	public Map<String, Object> getTotalData(String startDate, String endDate) {
		return sszjStatisticsDao.getTotalData(startDate, endDate);
	}

	/**
	 * @author zhanglei
	 * @date 15:35 2018/12/13 0013
	 * @Description: 获得机构等级柱状图数据
	 */
	@Override
	public Map<String, Object> getJgdjBarData(String startDate, String endDate) {
		Map<String, Object> mapForReturn = new LinkedHashMap<>();
		mapForReturn.put("A", 0);
		mapForReturn.put("B", 0);
		mapForReturn.put("C", 0);
		mapForReturn.put("D", 0);
		mapForReturn.put("无", 0);
		List<Map<String, Object>> list = sszjStatisticsDao.getJgdjBarData(startDate, endDate);
		for (Map<String, Object> map : list) {
			String pjdj = MapUtils.getString(map, "PJDJ", "");
			String sszjSize = MapUtils.getString(map, "SSZJSIZE", "");
			mapForReturn.put(pjdj, sszjSize);
		}
		return mapForReturn;
	}

	/**
	 * @author zhanglei
	 * @date 15:35 2018/12/13 0013
	 * @Description: 获得涉审中介监管信息柱状图数据
	 */
	@Override
	public List<Map<String, Object>> getZjxxBarData(String startDate, String endDate) {
		return sszjStatisticsDao.getZjxxBarData(startDate, endDate);
	}

	/**
	 * @author zhanglei
	 * @date 15:35 2018/12/13 0013
	 * @Description: 获得统计页面表格数据
	 */
	@Override
	public Pageable<Map<String, Object>> getDataTable(String startDate, String endDate, Page page) {
		return sszjStatisticsDao.getDataTable(startDate, endDate, page);
	}

	@Override
	public List<Map<String, Object>> getDataTable(String startDate, String endDate) {
		return sszjStatisticsDao.getDataTable(startDate, endDate);
	}
}
