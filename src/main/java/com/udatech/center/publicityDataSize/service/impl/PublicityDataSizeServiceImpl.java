package com.udatech.center.publicityDataSize.service.impl;

import com.udatech.center.publicityDataSize.dao.PublicityDataSizeDao;
import com.udatech.center.publicityDataSize.model.PublicityDataSize;
import com.udatech.center.publicityDataSize.service.PublicityDataSizeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 双公示数据量统计
 */
@Service
public class PublicityDataSizeServiceImpl implements PublicityDataSizeService {

    @Autowired
    private PublicityDataSizeDao publicityDataSizeDao;

    /**
     * 查询双公示数据量统计数据
     *
     * @param pds
     * @return
     */
    public List<Map<String, Object>> getDataSize(PublicityDataSize pds) {
        return publicityDataSizeDao.getDataSize(pds);
    }

}
