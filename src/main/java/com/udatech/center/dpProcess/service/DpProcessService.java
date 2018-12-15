package com.udatech.center.dpProcess.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.udatech.center.centerIndex.dao.CenterIndexDao;
import com.udatech.center.dpProcess.dao.DpProcessDao;
import com.udatech.common.service.CreditCommonService;
import com.wa.framework.service.BaseService;
/**
 * 描述：入库数据统计、双公示入库统计
 * 创建人： luqb
 * 创建时间：2018年6月25日上午9:23:52
 */
@Service
public class DpProcessService extends BaseService{

    @Autowired
    CenterIndexDao centerIndexDao;
    @Autowired
    DpProcessDao dpProcessDao;
    @Autowired
    private CreditCommonService creditCommonService;
    
    /* 数据处理结果 */
    private static String DP_PROCESS_RESULT = "DP_PROCESS_RESULT";
	public Map<String, Object> getCount(){
		int creditCount = 0;//信用数据总量
		int sxbmCount = 0;//市瞎部门总量
		int qxCount = 0;//区县总量
		int lCount = 0;//法人总量
		int pCount = 0;//自然人人总量
		creditCount = centerIndexDao.getCollectCount("1", DP_PROCESS_RESULT);
		List<Map<String, Object>> list = dpProcessDao.getAllProcessCount();
		for(Map<String, Object> m : list ){
			String type = m.get("TYPE") != null ? m.get("TYPE").toString() : "" ;
			int c = NumberUtils.toInt((m.get("CTN") == null ? 0 : m.get("CTN")).toString());
			switch(type){
			case "0" :
				lCount = c;
				break;
			case "1" :
				pCount = c;
				break;
			case "A" :
				sxbmCount = c;
				break;
			case "B" :
				qxCount = c;
				break;	
			case "C" :
				//lCount = c;
				break;	
			}
		}
		
		Map<String, Object> cntMap = new HashMap<>();
        cntMap.put("creditCount", creditCount);
        cntMap.put("sxbmCount", sxbmCount);
        cntMap.put("qxCount", qxCount);
        cntMap.put("lCount", lCount);
        cntMap.put("pCount", pCount);
        return cntMap;
	}
	
	public List<Map<String, Object>> queryStorageQuantity(String type,String startDate,String endDate){
		return dpProcessDao.queryStorageQuantity(type, startDate, endDate);
	}
	
	public List<Map<String, Object>> queryDataCategoryQuantity(String type,String personType,String startDate,String endDate){
		return dpProcessDao.queryDataCategoryQuantity(type,personType, startDate, endDate);
	}
	public List<Map<String, Object>> queryDeptQuantity(String type,String startDate,String endDate){
		return dpProcessDao.queryDeptQuantity(type, startDate, endDate);
	}
	
	public List<Map<String, Object>> queryTableQuantityByDeptId(String startDate,String endDate,String deptId){
		return dpProcessDao.queryTableQuantityByDeptId(startDate, endDate, deptId);
	}
	
	public Map<String, Object> getSgsCount(){
		long count1 = dpProcessDao.countBySql("select count(1) from yw_l_sgsxzxk");
		long count2 = dpProcessDao.countBySql("select count(1) from yw_l_sgsxzcf");
		long count3 = dpProcessDao.countBySql("select count(1) from yw_l_sgsxzxk where substr(bmbm,0,1)='A' ");
		long count4 = dpProcessDao.countBySql("select count(1) from yw_l_sgsxzcf where substr(bmbm,0,1)='A' ");
		long count5 = dpProcessDao.countBySql("select count(1) from yw_l_sgsxzxk where substr(bmbm,0,1)='B' ");
		long count6 = dpProcessDao.countBySql("select count(1) from yw_l_sgsxzcf where substr(bmbm,0,1)='B' ");
		long allCount = count1 + count2;
		long sxbmCount = count3 + count4;;//市瞎部门总量
		long qxCount = count5 + count6;;//区县总量
		long xzxkCount = count1;;//行政许可总量
		long xzcfCount = count2;;//行政处罚总量
		Map<String, Object> cntMap = new HashMap<>();
        cntMap.put("allCount", allCount);
        cntMap.put("sxbmCount", sxbmCount);
        cntMap.put("qxCount", qxCount);
        cntMap.put("xzxkCount", xzxkCount);
        cntMap.put("xzcfCount", xzcfCount);
        return cntMap;
	}
	
	public List<Map<String, Object>> getDeptByFirstCode(String code){
		return dpProcessDao.getDeptByFirstCode(code);
	}

	public Map<String, Object> querySgsDataQuality(String type,
			String dimension, String startDate, String endDate) {
		List<Map<String, Object>> list = dpProcessDao.querySgsDataQuality(type,dimension, startDate, endDate);
		Map<String, Object> allDataMap = creditCommonService.getAllChartDatas(list);
		//Map<String, Object> allDataMap = new HashMap<String, Object>();
		//allDataMap.put("data", list);
		return allDataMap;
	}

	public Map<String, Object> querySgsDataRanking(String type,
			String dimension, String startDate, String endDate) {
		List<Map<String, Object>> list  = dpProcessDao.querySgsDataQuality(type,dimension, startDate, endDate);
		String tab ;
		String bmmc ;
        Long xksize = 0L;
        Long cfsize = 0L;
        List<Map<String, Object>> xklist = new ArrayList<Map<String,Object>>();
        List<Map<String, Object>> cflist = new ArrayList<Map<String,Object>>();
        Map<String, Object> tempxk = null;
        Map<String, Object> tempcf = null;
		for(Map<String, Object> map : list){
			tempxk = new HashMap<String, Object>();
			tempcf = new HashMap<String, Object>();
			bmmc = (String) map.get("BMMC");
			xksize = Long.valueOf(String.valueOf(map.get("XKSIZE"))).longValue();
			cfsize = Long.valueOf(String.valueOf(map.get("CFSIZE"))).longValue();
			tempxk.put("BMMC", bmmc);
			tempxk.put("XKSIZE", xksize);
			xklist.add(0, tempxk);
			tempcf.put("BMMC", bmmc);
			tempcf.put("CFSIZE", cfsize);
			cflist.add(0, tempcf);
		}
        Collections.sort(xklist, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                Integer name1 = Integer.valueOf(o1.get("XKSIZE").toString()) ;//name1是从你list里面拿出来的一个 
                Integer name2 = Integer.valueOf(o2.get("XKSIZE").toString()) ; //name1是从你list里面拿出来的第二个name
                return name1.compareTo(name2);
            }
        });
        Collections.sort(cflist, new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                Integer name1 = Integer.valueOf(o1.get("CFSIZE").toString()) ;//name1是从你list里面拿出来的一个 
                Integer name2 = Integer.valueOf(o2.get("CFSIZE").toString()) ; //name1是从你list里面拿出来的第二个name
                return name1.compareTo(name2);
            }
        });
        if(xklist.size()<5){
        	xklist = xklist.subList(0, xklist.size());
        }else{
        	xklist = xklist.subList(xklist.size()-5, xklist.size());
        }
        if(cflist.size()<5){
        	cflist = cflist.subList(0, cflist.size());
        }else{
        	cflist = cflist.subList(cflist.size()-5, cflist.size());
        }
		Map<String, Object> remap = new HashMap<String, Object>();
		Map<String, Object> xkDataMap = creditCommonService.getAllChartDatas(xklist);
		Map<String, Object> cfDataMap = creditCommonService.getAllChartDatas(cflist);
		remap.put("xk", xkDataMap);
		remap.put("cf", cfDataMap);
		return remap;
	}
	
	public List<Map<String, Object>> queryDataTable(String type,
			String dimension, String startDate, String endDate, String deptId) {
		return dpProcessDao.queryDataTable(type, dimension, startDate, endDate, deptId);
	}

	public Map<String, Object> querySgsMonthBar(String type, String dimension,
			String startDate, String endDate,String deptId) {
		List<Map<String, Object>> list = dpProcessDao.querySgsMonthData(type, dimension, startDate, endDate, deptId);
		Map<String, Object> remap = creditCommonService.getAllChartDatas(list);
		
		return remap;
	}
	
}
