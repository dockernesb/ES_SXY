package com.udatech.center.dpThemeViewLog.service.impl;

import com.udatech.center.dpThemeViewLog.dao.DpThemeLogDao;
import com.udatech.center.dpThemeViewLog.service.DpThemeLogService;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DpThemeLogServiceImpl implements DpThemeLogService {

    @Autowired
    private DpThemeLogDao dpThemeLogDao;
    @Override
    public Pageable<Map<String, Object>> getDataList(String msgType, String status, String beginDate, String endDate,
                    String sblx, Page page) {
        return dpThemeLogDao.getDataList(msgType, status, beginDate, endDate, sblx, page);
    }

    @Override
    public List<Map<String, Object>> getTableColumn(String msgType) {
        return dpThemeLogDao.getTableColumn(msgType);
    }

    @Override
    public List<Map<String, Object>> queryColumnData(String msgType) {
        return dpThemeLogDao.queryColumnData(msgType);
    }

}
