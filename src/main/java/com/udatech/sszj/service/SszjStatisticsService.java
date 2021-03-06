package com.udatech.sszj.service;

import com.wa.framework.Page;
import com.wa.framework.Pageable;

import java.util.List;
import java.util.Map;

/**
 * @author 作者:zhanglei
 * @version 创建时间:2018/12/13 0013 10:40
 * @Description 描述:
 */
public interface SszjStatisticsService {

	Map<String, Object> getTotalData(String startDate, String endDate);

	Map<String, Object> getJgdjBarData(String startDate, String endDate);

	List<Map<String, Object>> getZjxxBarData(String startDate, String endDate);

	Pageable<Map<String, Object>> getDataTable(String startDate, String endDate, Page page);

	List<Map<String, Object>> getDataTable(String startDate, String endDate);
}
