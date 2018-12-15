package com.wa.framework.user.model;

import com.wa.framework.user.model.base.BaseSysUser;



public class SysUser extends BaseSysUser {
	private static final long serialVersionUID = 1L;

/*[CONSTRUCTOR MARKER BEGIN]*/
	public SysUser () {
		super();
	}

	/**
	 * Constructor for primary key
	 */
	public SysUser (String id) {
		super(id);
	}

	/**
	 * Constructor for required fields
	 */
	public SysUser (
		String id,
		SysDepartment sysDepartment,
		String username,
		String password,
		String state,
		boolean enabled,
		Integer rolesCount,
		Integer privilegesCount,
		String createBy,
		java.util.Date createDate,
		String realName,
		String idCard,
		String address,
		String email,
		String phoneNumber,
        String type,
		String isDepatmentAdmin) {

		super (
			id,
			sysDepartment,
			username,
			password,
			state,
			enabled,
			rolesCount,
			privilegesCount,
			createBy,
			createDate,
			realName,
			idCard,
			address,
			email,
			phoneNumber,
            type,
			isDepatmentAdmin);
	}

/*[CONSTRUCTOR MARKER END]*/


}