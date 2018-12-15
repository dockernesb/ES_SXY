package com.wa.framework.user.service;

import com.wa.framework.*;
import com.wa.framework.log.ExpLog;
import com.wa.framework.service.BaseService;
import com.wa.framework.user.dao.SysMenuDao;
import com.wa.framework.user.model.SysMenu;
import com.wa.framework.user.model.SysModuleDefinition;
import com.wa.framework.user.model.SysPrivilege;
import com.wa.framework.user.model.base.BaseSysMenu;
import com.wa.framework.util.easyui.ResponseUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 描述：菜单管理service
 * 创建人：guoyt
 * 创建时间：2016年10月21日上午11:20:29
 * 修改人：guoyt
 * 修改时间：2016年10月21日上午11:20:29
 */
@Service("sysMenuService")
@ExpLog(type="菜单管理")
public class SysMenuService extends BaseService {

    @Autowired
    @Qualifier("menuDao")
    private SysMenuDao menuDao;

   

    /**
     * @Description: 根据父菜单查找所有的子菜单，分页查询
     * @param: @param page
     * @param: @param parentId
     * @param: @return
     * @return: Pageable<SysMenu>
     * @throws
     * @since JDK 1.6
     */
    public Pageable<SysMenu> findMenusByParentId(Page page, String parentId) {
        Pageable<SysMenu> pageable = menuDao.findWithPage(page, new OrderProperty(SysMenu.PROP_DISPLAY_ORDER, true));
        if (!StringUtils.isBlank(parentId)) {
            List<SysMenu> allList = menuDao.getAll();
            List<String> listIds = getChildIds(allList, parentId);
            listIds.add(0, parentId);
            pageable = menuDao.findWithPage(page, OrderProperty.asc(SysMenu.PROP_DISPLAY_ORDER),
                    QueryCondition.in(SysMenu.PROP_ID, listIds.toArray()));
        }
        return pageable;
    }

    /**
     * @Description: 根据菜单查找所有的子菜单
     * @param: @param sysMenus
     * @param: @param parentValue
     * @param: @return
     * @return: List<String>
     * @throws
     * @since JDK 1.6
     */
    private List<String> getChildIds(List<SysMenu> sysMenus, String parentValue) {
        List<String> childList = new ArrayList<String>();
        for (SysMenu sysMenu : sysMenus) {
            String parentId = sysMenu.getParentId();
            if (parentId == parentValue || (parentValue != null && parentId.equals(parentValue))) {
                String id = sysMenu.getId();
                List<String> subList = getChildIds(sysMenus, id);
                if (subList.size() > 0) {
                    childList.addAll(subList);
                }
                childList.add(id);
            }
        }
        return childList;
    }
    
    /**
     * @Description: 根据菜单查找所有的父菜单
     * @param: @param sysMenus
     * @param: @param childValue
     * @param: @return
     * @return: List<SysMenu>
     * @throws
     * @since JDK 1.6
     */
    public List<SysMenu> getParentMenus(List<SysMenu> sysMenus, String childValue){
    	List<SysMenu> parentList = new ArrayList<SysMenu>();
		for (SysMenu sysMenu : sysMenus) {
			String id = sysMenu.getId();
			if (!id.equals("ROOT")){
				if (id == childValue || (childValue != null && id.equals(childValue))) {
					String parentId = sysMenu.getParentId();
					List<SysMenu> subList = getParentMenus(sysMenus, parentId);
					if (subList.size() > 0) {
						parentList.addAll(subList);
					}
					parentList.add(sysMenu);
				}
			}
		}
        return parentList;
    }

    /**
     * @Description: 新增菜单
     * @param: @param sysMenu
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String addMenu(SysMenu sysMenu) {
		QueryConditions queryConditions=new QueryConditions();
		queryConditions.addEq(BaseSysMenu.PROP_MENU_NAME, sysMenu.getMenuName());
		queryConditions.addEq(BaseSysMenu.PROP_PARENT_ID,sysMenu.getParentId());
		List<SysMenu> existMenu=baseDao.find(SysMenu.class,queryConditions);
        //SysMenu existMenu = menuDao.unique(QueryCondition.eq(BaseSysMenu.PROP_MENU_NAME, sysMenu.getMenuName()));
        SysMenu parentMenu = menuDao.unique(QueryCondition.eq(BaseSysMenu.PROP_ID, sysMenu.getParentId()));
        List<SysPrivilege> existList = baseDao.find(SysPrivilege.class,
                        QueryCondition.eq(SysPrivilege.PROP_SYS_MENU, parentMenu));
        if (existList.size() != 0) {
            return ResponseUtils.buildResultJson(false, "这个菜单下已存在功能权限, 如要作为父级菜单请先删除其所有功能权限并修改菜单URL为空!");
        }
        if (existMenu.size() != 0) {
            return ResponseUtils.buildResultJson(false, "已经存在相同名称的菜单!");
        } else {
            menuDao.save(sysMenu);
            return ResponseUtils.buildResultJson(true, "添加子菜单成功!");
        }
    }

    /**
     * @Description: 修改菜单
     * @param: @param sysMenu
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    public String editMenu(SysMenu sysMenu) {
        SysMenu existMenu = menuDao.get(sysMenu.getId());
        if (existMenu != null) {
            if (sysMenu.getMenuName() != null && !sysMenu.getMenuName().equals(existMenu.getMenuName())) {
                SysMenu existEditMenu = menuDao.unique(QueryCondition.eq(BaseSysMenu.PROP_MENU_NAME,
                                sysMenu.getMenuName()));
                if (existEditMenu != null) {
                    return ResponseUtils.buildResultJson(false, "已经存在相同名称的菜单!");
                }
            }
            existMenu.setMenuName(sysMenu.getMenuName());
            existMenu.setMenuUrl(sysMenu.getMenuUrl());
            existMenu.setMenuIcon(sysMenu.getMenuIcon());
            existMenu.setDisplayOrder(sysMenu.getDisplayOrder());
            menuDao.update(existMenu);
            return ResponseUtils.buildResultJson(true, "修改菜单成功!");
        }
        return ResponseUtils.buildResultJson(false, "修改菜单失败!");

    }

	/**
	 * @Description: 删除菜单
	 * @param: @param id
	 * @param: @return
	 * @return: String
	 * @throws
	 * @since JDK 1.6
	 */
    public String deleteMenu(String id) {
        if (!StringUtils.isBlank(id)) {
            List<SysMenu> allList = menuDao.getAll();
            List<String> listIds = getChildIds(allList, id);
            listIds.add(id);
            for (String menuId : listIds) {
                SysMenu sysMenu = menuDao.get(menuId);
                List<SysPrivilege> existList = baseDao.find(SysPrivilege.class,
                                QueryCondition.eq(SysPrivilege.PROP_SYS_MENU, sysMenu));
                if (existList != null && existList.size() > 0) {
                    return ResponseUtils.buildResultJson(false, "请先删除菜单下的功能权限!");
                }

                List<SysModuleDefinition> moduleList = baseDao.find(SysModuleDefinition.class,
                                QueryCondition.eq(SysModuleDefinition.PROP_MENU, sysMenu));
                if (moduleList != null && moduleList.size() > 0) {
                    return ResponseUtils.buildResultJson(false, "请先删除菜单下的表单模块!");
                }
            }
            menuDao.deleteByIds(listIds);
            return ResponseUtils.buildResultJson(true, "删除菜单成功!");
        } else {
            return ResponseUtils.buildResultJson(false, "删除菜单失败!");
        }
    }
    
    /**
     * @Description: 查询有无相同排序对象
     * @param: @param order
     * @param: @return
     * @return: SysMenu
     * @throws
     * @since JDK 1.6
     */
    public SysMenu getCountByOrder(int order){
    	SysMenu sysMenu=null;
    	List<SysMenu> lst=menuDao.getCountByOrderList(order);
    	if(lst.size()!=0){
    		  sysMenu=lst.get(0);
    	}
    	return sysMenu;
    }

}
