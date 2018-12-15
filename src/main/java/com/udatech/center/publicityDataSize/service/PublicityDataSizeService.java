package com.udatech.center.publicityDataSize.service;

import com.udatech.center.publicityDataSize.model.PublicityDataSize;

import java.util.List;
import java.util.Map;

/**
 * 双公示数据量统计
 */
public interface PublicityDataSizeService {

    /**
     * 查询双公示数据量统计数据
     *
     * @param pds
     * @return
     */
    List<Map<String, Object>> getDataSize(PublicityDataSize pds);

}
