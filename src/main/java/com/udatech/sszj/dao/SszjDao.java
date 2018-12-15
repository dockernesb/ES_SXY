package com.udatech.sszj.dao;

import com.udatech.common.enmu.UploadFileEnmu;
import com.udatech.common.model.Promise;
import com.udatech.sszj.model.*;
import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseDao;

import java.util.List;
import java.util.Map;

/**
 * @author dwc
 * @Title: SszjDao
 * @ProjectName creditservice
 * @Description: TODO
 * @date 2018/12/10  18:15
 */
public interface SszjDao extends BaseDao {
    Pageable<Map<String, Object>> getSszjJbxxList(Page page, SszjJbxx sszjJbxx);
    Pageable<Map<String, Object>> getSszjZyzzList(Page page, SszjZyzz sszjZyzz);
    Pageable<Map<String, Object>> getSszjZyryList(Page page, SszjZyry sszjZyry);

    void copyToZyzz(List<SszjZyzz> list);

    Pageable<Map<String, Object>> getSszjPjdjList(Page page, SszjPjdj sszjPjdj);

    Pageable<Map<String, Object>> getSszjXycnList(Page page, SszjCreditCommitmentQy sszjCreditCommitmentQy);

    List<UploadFile> getUploadFiles(String id, UploadFileEnmu 信用承诺附件);

    Promise getPromiseById(String businessId);

    void updateTime(String cnlbKey, String deptId);

    void deleteJbxxFileInfo(UploadFile file);
}
