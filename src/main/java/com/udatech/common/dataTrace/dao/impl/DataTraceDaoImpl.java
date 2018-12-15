package com.udatech.common.dataTrace.dao.impl;

import com.udatech.common.dao.CreditCommonDao;
import com.udatech.common.dataTrace.dao.DataTraceDao;
import com.udatech.common.dataTrace.util.DataTraceUtil;
import com.udatech.common.dataTrace.vo.DataTraceVo;
import com.wa.framework.dao.BaseDaoSupport;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述：数据追溯dao实现类
 * 创建人：guoyt
 * 创建时间：2017年3月6日下午5:14:20
 * 修改人：guoyt
 * 修改时间：2017年3月6日下午5:14:20
 */
@Repository
public class DataTraceDaoImpl extends BaseDaoSupport implements DataTraceDao {

    @Autowired
    private CreditCommonDao creditCommonDao;
	 
    /** 
     * @Description: 根据首次上报的记录主键查找后面多次上报的记录主键id
     * @see： @see com.udatech.common.dataTrace.dao.DataTraceDao#getMultiReportRelation(java.lang.String)
     * @since JDK 1.6
     */
    @Override
    public List<Map<String, Object>> getMultiReportRelation(String id, String filedName) {
        String sql = "select * from DP_MULTI_REPORT_RELATION where " + filedName + " = :ID order by insert_time desc ";
        
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("ID", id);
        
        List<Map<String, Object>> resMap = this.findBySql(sql.toString(), params);
        return resMap;
    }

    /**
     * @category 保存单条需要数据追溯的数据信息
     * @param vo
     * @return
     */
    @Override
    public void saveDataTrace(DataTraceVo vo) {
        this.getDataTrace(vo);
        if (vo.getContent() != null) {
            DataTraceUtil.dataTrace(vo);
        }
    }
    
	/**
	 * @category 获取需要追溯的数据信息
	 * @param vo
	 * @return
	 */
	public void getDataTrace(DataTraceVo vo) {
		StringBuilder sb = new StringBuilder();
		sb.append(" SELECT * FROM ").append(vo.getTableName());
		sb.append(" WHERE ID = '").append(vo.getId()).append("'");

		Map<String, Object> map = this.uniqueBySql(sb.toString());
		if (map != null) {
			String taskCode = (String) map.get("RWBH");
			vo.setTaskCode(taskCode);
			vo.setContent(map);
			if (StringUtils.isBlank(vo.getCreditSubjectId())) {
				String gszch = (String) map.get("GSZCH");
				String zzjgdm = (String) map.get("ZZJGDM");
				String tyshxydm = (String) map.get("TYSHXYDM");
				String enterpriseId = creditCommonDao.getEnterpriseId(gszch, zzjgdm,
						tyshxydm);
				vo.setCreditSubjectId(enterpriseId);
			}
		}
	}

    @Override
    public void getPDataTrace(DataTraceVo vo) {
        StringBuilder sb = new StringBuilder();
        sb.append(" SELECT * FROM ").append(vo.getTableName());
        sb.append(" WHERE ID = '").append(vo.getId()).append("'");

        Map<String, Object> map = this.uniqueBySql(sb.toString());
        if (map != null) {
            String taskCode = (String) map.get("TASK_CODE");
            vo.setTaskCode(taskCode);
            vo.setContent(map);
        }
    }
}
