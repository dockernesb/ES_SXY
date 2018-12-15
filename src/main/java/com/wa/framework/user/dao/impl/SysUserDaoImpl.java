package com.wa.framework.user.dao.impl;

import com.wa.framework.Page;
import com.wa.framework.Pageable;
import com.wa.framework.SimplePageable;
import com.wa.framework.common.model.UploadFile;
import com.wa.framework.dao.BaseEntityDaoImpl;
import com.wa.framework.user.dao.SysUserDao;
import com.wa.framework.user.model.SysDepartment;
import com.wa.framework.user.model.SysUser;
import com.wa.framework.utils.EscapeChar;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述：用户dao实现类
 * 创建人：guoyt
 * 创建时间：2016年10月21日上午11:18:18
 * 修改人：guoyt
 * 修改时间：2016年10月21日上午11:18:18
 */
@Repository("userDao")
public class SysUserDaoImpl extends BaseEntityDaoImpl<SysUser> implements SysUserDao {
	
    /** 
     * @Description: 按照用户名分页查询
     * @see： @see com.wa.framework.user.dao.SysUserDao#findUserWithName(com.wa.framework.Page, java.lang.String, java.lang.String, java.lang.String)
     * @since JDK 1.6
     */
    public Pageable<SysUser> findUserWithName(Page page, String name, String realName, String depart, String status, String type) {
    	List<String> lst=new ArrayList<String>();
    	Pageable<SysUser> pageable=new  SimplePageable<SysUser>();

    	StringBuffer createSqlQuery=new  StringBuffer("from SysUser where 1=1 and state='1' ");
        StringBuffer countSqlQuery=new  StringBuffer("select count(*) from SysUser where 1=1 and state='1' ");

        if (StringUtils.isNotEmpty(name)){
            if(name.contains("%")||name.contains("_")){
                name=name.replace("%","\\%").replace("_", "\\_");
                lst.add("%"+ name+ "%");
                createSqlQuery.append(" and username like ?  escape '\\' ");
                countSqlQuery.append(" and username like ?  escape '\\' ");
            }else{
                lst.add("%"+ name+ "%");
                createSqlQuery.append(" and username like ? ");
                countSqlQuery.append(" and username like ? ");
            }
        }

        if (StringUtils.isNotEmpty(realName)){
            if(realName.contains("%")||realName.contains("_")){
                realName=realName.replace("%","\\%").replace("_", "\\_");
                lst.add(realName);
                createSqlQuery.append(" and realName = ?  escape '\\' ");
                countSqlQuery.append(" and realName = ?  escape '\\' ");
            }else{
                lst.add(realName);
                createSqlQuery.append(" and realName = ? ");
                countSqlQuery.append(" and realName = ? ");
            }
        }

        if (StringUtils.isNotEmpty(depart)){
            if(depart.contains("%")||depart.contains("_")){
                depart=depart.replace("%","\\%").replace("_", "\\_");
                lst.add("%"+ depart+ "%");
                createSqlQuery.append(" and sysDepartment.departmentName like ?  escape '\\' ");
                countSqlQuery.append(" and sysDepartment.departmentName like ?  escape '\\' ");
            }else{
                lst.add("%"+ depart+ "%");
                createSqlQuery.append(" and sysDepartment.departmentName like ? ");
                countSqlQuery.append(" and sysDepartment.departmentName like ? ");
            }
        }

        if (StringUtils.isNotEmpty(status)){
            if ("1".equals(status)){
                createSqlQuery.append(" and enabled = 1 ");
                countSqlQuery.append(" and enabled = 1 ");
            } else {
                createSqlQuery.append(" and enabled = 0 ");
                countSqlQuery.append(" and enabled = 0 ");
            }
        }
        if (StringUtils.isNotEmpty(type)){
            if ("0".equals(type)){
                createSqlQuery.append(" and type = 0 ");
                countSqlQuery.append(" and type = 0 ");
            } else if("1".equals(type)){
                createSqlQuery.append(" and type = 1 ");
                countSqlQuery.append(" and type = 1 ");
            } else if("2".equals(type)){
                createSqlQuery.append(" and type = 2 ");
                countSqlQuery.append(" and type = 2 ");
            }else if("3".equals(type)){
                createSqlQuery.append(" and type = 3 ");
                countSqlQuery.append(" and type = 3 ");
            }else {
                createSqlQuery.append(" and 2 = 2 ");
                countSqlQuery.append(" and 2 = 2 ");
            }
        }

        createSqlQuery.append(" order by createDate desc, id ");
        pageable=findByHqlWithPage(createSqlQuery.toString(),countSqlQuery.toString(),page,lst);

//        DetachedCriteria criteria = DetachedCriteria.forClass(SysUser.class);
//        if (StringUtils.isNotBlank(name)) {
//            criteria.add(EscapeChar.fuzzyCriterion("username", name));
//        }
//        if (StringUtils.isNotBlank(realName)) {
//            criteria.add(EscapeChar.fuzzyCriterion("realName", realName));
//        }
//        if (StringUtils.isNotBlank(depart)) {
//
//            criteria.add(EscapeChar.fuzzyCriterion("sysDepartment.departmentName", depart));
//        }
//        if (StringUtils.isNotBlank(status)) {
//            criteria.add(Restrictions.eq("enabled", status));
//        }
//        if (StringUtils.isNotBlank(type)) {
//            criteria.add(Restrictions.eq("type", type));
//        }
//
//        criteria.addOrder(Order.desc("createDate"));
//        criteria.addOrder(Order.desc("id"));
//        Pageable<SysUser> pageable = findByDetachedCriteriaWithPage(criteria, page);

        for (SysUser user : pageable.getList()) {
            Hibernate.initialize(user.getSysDepartment());
        }
        return pageable;
    }

	/** 
	 * @Description: 查找所有未删除的启用状态的用户，并按照姓名排序（支持中文）
	 * @see： @see com.wa.framework.user.dao.SysUserDao#findUserOrderByName()
	 * @since JDK 1.6
	 */
	@Override
	public List<SysUser> findUserOrderByName() {
		StringBuffer createSqlQuery=new  StringBuffer();
		createSqlQuery.append("from SysUser where enabled = 1 and state = 1 order by nlssort(username,'NLS_SORT=SCHINESE_PINYIN_M')");
		return findByHql(createSqlQuery.toString());
	}
	
    /** 
     * @Description: 根据用户id查找部门
     * @see： @see com.wa.framework.user.dao.SysUserDao#findDepWithUserId(java.lang.String)
     * @since JDK 1.6
     */
    @SuppressWarnings("rawtypes")
    @Override
    public SysDepartment findDepWithUserId(String userId) {
        Map<String, String> parameters = new HashMap<String, String>();
        String hql = "select u.sysDepartment from SysUser u where u.id =:userId";
        parameters.put("userId", userId);
        List list = findByHql(hql, parameters);
        if (list.size() > 0) {
            return (SysDepartment) list.get(0);
        } else {
            return null;
        }
    }

    /** 
     * @Description: 根据用户Id获取用户信息
     * @see： @see com.wa.framework.user.dao.SysUserDao#findUserById(java.lang.String)
     * @since JDK 1.6
     */
    @Override
    public Map<String,Object> findUserById(String userId) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("I_USERID", userId);
        String sql = "select * from SYS_USER where SYS_USER_ID = :I_USERID";
        Map<String,Object> res = this.findBySql(sql, param).get(0);
        return res;
    }
    
    @Override
    public String findUserPhoto(String userId) {
        String querySql = " SELECT T.FILE_PATH FROM DT_UPLOAD_FILE T WHERE T.BUSINESS_ID = :I_USERID ";
        querySql += " ORDER BY T.CREATE_DATE DESC ";
        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("I_USERID", userId);

        Map<String, Object> resMap = new HashMap<String, Object>();
        List<Map<String, Object>> resList = this.findBySql(querySql, parameters);
        if (resList != null && resList.size() > 0) {
            resMap = resList.get(0);
            return MapUtils.getString(resMap, "FILE_PATH", StringUtils.EMPTY);
        } else {
            return StringUtils.EMPTY;
        }
    }
    
    @Override
    public SysUser findExsitUserById(String sysuserid) {
        Criteria criteria = getSession().createCriteria(SysUser.class);
        criteria.add(Restrictions.eq("id", sysuserid));
        @SuppressWarnings("unchecked")
        List<SysUser> list = criteria.list();
        for (SysUser user : list) {
            Hibernate.initialize(user.getSysDepartment());
        }
        return list.get(0);
    }
    
    @Override
    public boolean userEdit(SysUser user) {
        try {
            SysUser existUser = this.findExsitUserById(user.getId());
            if (existUser == null) {
                return false;
            }
            existUser.setAddress(user.getAddress());
            existUser.setEmail(user.getEmail());
            existUser.setIdCard(user.getIdCard());
            existUser.setGender(user.isGender());
            existUser.setRealName(user.getRealName());
            existUser.setPhoneNumber(user.getPhoneNumber());

            this.update(existUser);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }
    
    @Override
    public UploadFile findUserPhotoFile(String userId) {
        String querySql = " SELECT * FROM DT_UPLOAD_FILE T WHERE T.BUSINESS_ID = :I_USERID ";
        Map<String, Object> parameters = new HashMap<String, Object>();
        parameters.put("I_USERID", userId);
        List<UploadFile> resList = this.findBySql(querySql, parameters, UploadFile.class);
        if (resList == null || resList.size() == 0) {
            return null;
        } else {
            return resList.get(0);
        }
    }

    public Pageable<SysUser> findUserWithName(Page page, String name, String depart, String status) {
        List<String> lst=new ArrayList<String>();
        Pageable<SysUser> pageable=new  SimplePageable<SysUser>();

        StringBuffer createSqlQuery=new  StringBuffer("from SysUser where 1=1 and state='1' ");
        StringBuffer countSqlQuery=new  StringBuffer("select count(*) from SysUser where 1=1 and state='1' ");

        if (StringUtils.isNotEmpty(name)){
            if(name.contains("%")||name.contains("_")){
                name=name.replace("%","\\%").replace("_", "\\_");
                lst.add("%"+ name+ "%");
                createSqlQuery.append(" and username like ?  escape '\\' ");
                countSqlQuery.append(" and username like ?  escape '\\' ");
            }else{
                lst.add("%"+ name+ "%");
                createSqlQuery.append(" and username like ? ");
                countSqlQuery.append(" and username like ? ");
            }
        }

        if (StringUtils.isNotEmpty(depart)){
            if(depart.contains("%")||depart.contains("_")){
                depart=depart.replace("%","\\%").replace("_", "\\_");
                lst.add("%"+ depart+ "%");
                createSqlQuery.append(" and sysDepartment.departmentName like ?  escape '\\' ");
                countSqlQuery.append(" and sysDepartment.departmentName like ?  escape '\\' ");
            }else{
                lst.add("%"+ depart+ "%");
                createSqlQuery.append(" and sysDepartment.departmentName like ? ");
                countSqlQuery.append(" and sysDepartment.departmentName like ? ");
            }
        }

        if (StringUtils.isNotEmpty(status)){
            if ("1".equals(status)){
                createSqlQuery.append(" and enabled = 1 ");
                countSqlQuery.append(" and enabled = 1 ");
            } else {
                createSqlQuery.append(" and enabled = 0 ");
                countSqlQuery.append(" and enabled = 0 ");
            }
        }

        createSqlQuery.append(" order by createDate desc, id ");
        pageable=findByHqlWithPage(createSqlQuery.toString(),countSqlQuery.toString(),page,lst);

        for (SysUser user : pageable.getList()) {
            Hibernate.initialize(user.getSysDepartment());
        }
        return pageable;
    }
}
