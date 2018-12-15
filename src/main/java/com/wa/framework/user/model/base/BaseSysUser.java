package com.wa.framework.user.model.base;

import java.io.Serializable;

/**
 * This is an object that contains data related to the SYS_USER table. Do not modify this class because it will be
 * overwritten if the configuration file related to this class is modified.
 * @hibernate.class table="SYS_USER"
 */

public abstract class BaseSysUser implements Serializable {

    private static final long serialVersionUID = -6971874556972693528L;

    public static String REF = "SysUser";
    public static String PROP_STATE = "state";
    public static String PROP_ENABLED = "enabled";
    public static String PROP_PASSWORD = "password";
    public static String PROP_PHONE_NUMBER = "phoneNumber";
    public static String PROP_TYPE = "type";
    public static String PROP_ID_CARD = "idCard";
    public static String PROP_REAL_NAME = "realName";
    public static String PROP_CREATE_DATE = "createDate";
    public static String PROP_UPDATE_BY = "updateBy";
    public static String PROP_EMAIL = "email";
    public static String PROP_ROLES_COUNT = "rolesCount";
    public static String PROP_PRIVILEGES_COUNT = "privilegesCount";
    public static String PROP_USERNAME = "username";
    public static String PROP_CREATE_BY = "createBy";
    public static String PROP_GENDER = "gender";
    public static String PROP_ADDRESS = "address";
    public static String PROP_ID = "id";
    public static String PROP_UPDATE_DATE = "updateDate";
    public static String PROP_SYS_DEPARTMENT = "sysDepartment";

    // constructors
    public BaseSysUser() {
        initialize();
    }

    /**
     * Constructor for primary key
     */
    public BaseSysUser(String id) {
        this.setId(id);
        initialize();
    }

    /**
     * Constructor for required fields
     */
    public BaseSysUser(String id, com.wa.framework.user.model.SysDepartment sysDepartment,
                    String username, String password, String state, boolean enabled,
                    Integer rolesCount, Integer privilegesCount, String createBy,
                    java.util.Date createDate, String realName, String idCard,
                    String address, String email, String phoneNumber,
                    String type, String isDepatmentAdmin) {

        this.setId(id);
        this.setSysDepartment(sysDepartment);
        this.setUsername(username);
        this.setPassword(password);
        this.setState(state);
        this.setEnabled(enabled);
        this.setRolesCount(rolesCount);
        this.setPrivilegesCount(privilegesCount);
        this.setCreateBy(createBy);
        this.setCreateDate(createDate);
        this.setRealName(realName);
        this.setIdCard(idCard);
        this.setAddress(address);
        this.setEmail(email);
        this.setPhoneNumber(phoneNumber);
        this.setType(type);
        this.setIsDepatmentAdmin(isDepatmentAdmin);

        initialize();
    }

    protected void initialize() {
    }

    private int hashCode = Integer.MIN_VALUE;

    // primary key
    private String id;

    // fields
    private String username;
    private String password;
    private String state;
    private boolean enabled;
    private Integer rolesCount;
    private Integer privilegesCount;
    private String createBy;
    private java.util.Date createDate;
    private String updateBy;
    private java.util.Date updateDate;
    private boolean gender;
    private String realName;
    private String idCard;
    private String address;
    private String email;
    private String phoneNumber;
    private String type;
    private String isDepatmentAdmin;

    // many to one
    private com.wa.framework.user.model.SysDepartment sysDepartment;

    // collections
    private java.util.Set<com.wa.framework.user.model.SysRole> sysRoles;
    private java.util.Set<com.wa.framework.user.model.SysPrivilege> sysPrivileges;

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * Return the unique identifier of this class
     * @hibernate.id generator-class="uuid" column="SYS_USER_ID"
     */
    public String getId() {
        return id;
    }

    /**
     * Set the unique identifier of this class
     * @param id the new ID
     */
    public void setId(String id) {
        this.id = id;
        this.hashCode = Integer.MIN_VALUE;
    }

    /**
     * Return the value associated with the column: USERNAME
     */
    public String getUsername() {
        return username;
    }

    /**
     * Set the value related to the column: USERNAME
     * @param username the USERNAME value
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * Return the value associated with the column: PASSWORD
     */
    public String getPassword() {
        return password;
    }

    /**
     * Set the value related to the column: PASSWORD
     * @param password the PASSWORD value
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * Return the value associated with the column: STATE
     */
    public String getState() {
        return state;
    }

    /**
     * Set the value related to the column: STATE
     * @param state the STATE value
     */
    public void setState(String state) {
        this.state = state;
    }

    /**
     * Return the value associated with the column: ENABLED
     */
    public boolean isEnabled() {
        return enabled;
    }

    /**
     * Set the value related to the column: ENABLED
     * @param enabled the ENABLED value
     */
    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    /**
     * Return the value associated with the column: ROLES_COUNT
     */
    public Integer getRolesCount() {
        return rolesCount;
    }

    /**
     * Set the value related to the column: ROLES_COUNT
     * @param rolesCount the ROLES_COUNT value
     */
    public void setRolesCount(Integer rolesCount) {
        this.rolesCount = rolesCount;
    }

    /**
     * Return the value associated with the column: PRIVILEGES_COUNT
     */
    public Integer getPrivilegesCount() {
        return privilegesCount;
    }

    /**
     * Set the value related to the column: PRIVILEGES_COUNT
     * @param privilegesCount the PRIVILEGES_COUNT value
     */
    public void setPrivilegesCount(Integer privilegesCount) {
        this.privilegesCount = privilegesCount;
    }

    /**
     * Return the value associated with the column: CREATE_BY
     */
    public String getCreateBy() {
        return createBy;
    }

    /**
     * Set the value related to the column: CREATE_BY
     * @param createBy the CREATE_BY value
     */
    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    /**
     * Return the value associated with the column: CREATE_DATE
     */
    public java.util.Date getCreateDate() {
        return createDate;
    }

    /**
     * Set the value related to the column: CREATE_DATE
     * @param createDate the CREATE_DATE value
     */
    public void setCreateDate(java.util.Date createDate) {
        this.createDate = createDate;
    }

    /**
     * Return the value associated with the column: UPDATE_BY
     */
    public String getUpdateBy() {
        return updateBy;
    }

    /**
     * Set the value related to the column: UPDATE_BY
     * @param updateBy the UPDATE_BY value
     */
    public void setUpdateBy(String updateBy) {
        this.updateBy = updateBy;
    }

    /**
     * Return the value associated with the column: UPDATE_DATE
     */
    public java.util.Date getUpdateDate() {
        return updateDate;
    }

    /**
     * Set the value related to the column: UPDATE_DATE
     * @param updateDate the UPDATE_DATE value
     */
    public void setUpdateDate(java.util.Date updateDate) {
        this.updateDate = updateDate;
    }

    public boolean isGender() {
		return gender;
	}

	public void setGender(boolean gender) {
		this.gender = gender;
	}

	/**
     * Return the value associated with the column: REAL_NAME
     */
    public String getRealName() {
        return realName;
    }

    /**
     * Set the value related to the column: REAL_NAME
     * @param realName the REAL_NAME value
     */
    public void setRealName(String realName) {
        this.realName = realName;
    }

    /**
     * Return the value associated with the column: ID_CARD
     */
    public String getIdCard() {
        return idCard;
    }

    /**
     * Set the value related to the column: ID_CARD
     * @param idCard the ID_CARD value
     */
    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    /**
     * Return the value associated with the column: ADDRESS
     */
    public String getAddress() {
        return address;
    }

    /**
     * Set the value related to the column: ADDRESS
     * @param address the ADDRESS value
     */
    public void setAddress(String address) {
        this.address = address;
    }

    /**
     * Return the value associated with the column: EMAIL
     */
    public String getEmail() {
        return email;
    }

    /**
     * Set the value related to the column: EMAIL
     * @param email the EMAIL value
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Return the value associated with the column: PHONE_NUMBER
     */
    public String getPhoneNumber() {
        return phoneNumber;
    }

    /**
     * Set the value related to the column: PHONE_NUMBER
     * @param phoneNumber the PHONE_NUMBER value
     */
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getIsDepatmentAdmin() {
        return isDepatmentAdmin;
    }

    public void setIsDepatmentAdmin(String isDepatmentAdmin) {
        this.isDepatmentAdmin = isDepatmentAdmin;
    }

    /**
     * Return the value associated with the column: SYS_DEPARTMENT_ID
     */
    public com.wa.framework.user.model.SysDepartment getSysDepartment() {
        return sysDepartment;
    }

    /**
     * Set the value related to the column: SYS_DEPARTMENT_ID
     * @param sysDepartment the SYS_DEPARTMENT_ID value
     */
    public void setSysDepartment(com.wa.framework.user.model.SysDepartment sysDepartment) {
        this.sysDepartment = sysDepartment;
    }

    /**
     * Return the value associated with the column: sysRoles
     */
    public java.util.Set<com.wa.framework.user.model.SysRole> getSysRoles() {
        return sysRoles;
    }

    /**
     * Set the value related to the column: sysRoles
     * @param sysRoles the sysRoles value
     */
    public void setSysRoles(java.util.Set<com.wa.framework.user.model.SysRole> sysRoles) {
        this.sysRoles = sysRoles;
    }

    public void addTosysRoles(com.wa.framework.user.model.SysRole sysRole) {
        if (null == getSysRoles())
            setSysRoles(new java.util.TreeSet<com.wa.framework.user.model.SysRole>());
        getSysRoles().add(sysRole);
    }

    /**
     * Return the value associated with the column: sysPrivileges
     */
    public java.util.Set<com.wa.framework.user.model.SysPrivilege> getSysPrivileges() {
        return sysPrivileges;
    }

    /**
     * Set the value related to the column: sysPrivileges
     * @param sysPrivileges the sysPrivileges value
     */
    public void setSysPrivileges(java.util.Set<com.wa.framework.user.model.SysPrivilege> sysPrivileges) {
        this.sysPrivileges = sysPrivileges;
    }

    public void addTosysPrivileges(com.wa.framework.user.model.SysPrivilege sysPrivilege) {
        if (null == getSysPrivileges())
            setSysPrivileges(new java.util.TreeSet<com.wa.framework.user.model.SysPrivilege>());
        getSysPrivileges().add(sysPrivilege);
    }

    @Override
    public boolean equals(Object obj) {
        if (null == obj)
            return false;
        if (!(obj instanceof com.wa.framework.user.model.SysUser))
            return false;
        else {
            com.wa.framework.user.model.SysUser sysUser = (com.wa.framework.user.model.SysUser) obj;
            if (null == this.getId() || null == sysUser.getId())
                return false;
            else
                return (this.getId().equals(sysUser.getId()));
        }
    }

    @Override
    public int hashCode() {
        if (Integer.MIN_VALUE == this.hashCode) {
            if (null == this.getId())
                return super.hashCode();
            else {
                String hashStr = this.getClass().getName() + ":" + this.getId().hashCode();
                this.hashCode = hashStr.hashCode();
            }
        }
        return this.hashCode;
    }

    @Override
    public String toString() {
        return super.toString();
    }

}