package com.dhc.organization.facade;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.dhc.organization.role.domain.WF_ORG_ROLE;

/**
 * brief description
 * <p>
 * Date : 2010/05/13
 * </p>
 * <p>
 * Module : 组织机构权限管理接口
 * </p>
 * <p>
 * Description: 用户信息JavaBean
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 * 			------------------------------------------------------------
 *          </p>
 *          <p>
 *          修改历史
 *          </p>
 *          <p>
 *          序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 *          1
 *          </p>
 */
public class UserBean implements Serializable {

	/**
	 * 主键
	 */
	private String id;

	/**
	 * 登录帐户名
	 */
	private String account;

	/**
	 * 全名
	 */
	private String fullName;

	/**
	 * 密码
	 */
	private String password;

	/**
	 * 描述
	 */
	private String description;

	/**
	 * 是否有效
	 */
	private boolean enabled;

	/**
	 * 是否锁定
	 */
	private boolean locked;

	/**
	 * 帐号创建日期
	 */
	private Date createdDate;

	/**
	 * 密码修改日期
	 */
	private Date pwdChangeDate;

	/**
	 * 扩展信息Map
	 */
	private Map extendedInfo;

	/**
	 * 角色列表WF_ORG_ROLE
	 */
	private List roleList;

	/**
	 * 组织单元列表WF_ORG_UNIT
	 */
	private List unitList;

	/**
	 * 岗位列表WF_ORG_STATION
	 */
	private List stationList;

	/**
	 * 构造函数
	 */
	public UserBean() {

	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public boolean isLocked() {
		return locked;
	}

	public void setLocked(boolean locked) {
		this.locked = locked;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public Date getPwdChangeDate() {
		return pwdChangeDate;
	}

	public void setPwdChangeDate(Date pwdChangeDate) {
		this.pwdChangeDate = pwdChangeDate;
	}

	public Map getExtendedInfo() {
		return extendedInfo;
	}

	public void setExtendedInfo(Map extendedInfo) {
		this.extendedInfo = extendedInfo;
	}

	public List getRoleList() {
		return roleList;
	}

	public void setRoleList(List roleList) {
		this.roleList = roleList;
	}

	public List getUnitList() {
		return unitList;
	}

	public void setUnitList(List unitList) {
		this.unitList = unitList;
	}

	public List getStationList() {
		return stationList;
	}

	public void setStationList(List stationList) {
		this.stationList = stationList;
	}

	public boolean hasAdminRole() {
		boolean returnValue = false;
		if (this.roleList != null) {
			for (int i = 0; i < this.roleList.size(); i++) {
				WF_ORG_ROLE role = (WF_ORG_ROLE) roleList.get(i);
				if (role.getIsAdminrole() != null && role.getIsAdminrole().equals("是")) {
					returnValue = true;
					break;
				}
			}
		}
		return returnValue;
	}

	/**
	 * 获取user的adminRole(每个用户应该只能有1个adminRole)
	 * 
	 * @return user的管理角色
	 */
	public WF_ORG_ROLE getAdminRole() {
		WF_ORG_ROLE returnValue = null;
		if (this.roleList != null) {
			for (int i = 0; i < this.roleList.size(); i++) {
				WF_ORG_ROLE role = (WF_ORG_ROLE) roleList.get(i);
				if (role.getIsAdminrole() != null && role.getIsAdminrole().equals("是")) {
					returnValue = role;
					break;
				}
			}
		}
		return returnValue;
	}
}
