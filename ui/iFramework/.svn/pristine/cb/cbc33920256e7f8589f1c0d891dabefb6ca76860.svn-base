package com.dhc.base.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.userdetails.UserDetails;

import com.dhc.organization.facade.UserBean;

public class SecurityUser implements UserDetails {

	/**
	 * 
	 */
	// private static final long serialVersionUID = 1L;
	private static final long serialVersionUID = 8026813053768023527L;
	/**
	 * 账户权限
	 */
	private SecurityUserAuth securityUserAuth;
	/**
	 * 账户名
	 */
	private String userName;
	/**
	 * 密码
	 */
	private String passWord;
	/**
	 * 账户是否可用 0 可用 否则不可用
	 */
	private String enabled;
	/**
	 * 帐户是否终止 0isAccountNonExpired=true 1isAccountNonExpired=false
	 */
	private String expiredFlag = "1";

	private boolean locked = false;

	/**
	 * 账户对应的角色See RoleType
	 */
	private List<SecurityRole> roles;

	private UserBean userBean;

	/**
	 * @param userBean
	 *            the userBean to set
	 */
	public void setUserBean(UserBean userBean) {
		this.userBean = userBean;
	}

	/**
	 * @return the userBean
	 */
	public UserBean getUserBean() {
		return userBean;
	}

	/**
	 * Returns the authorities granted to the user. Cannot return
	 * <code>null</code>.
	 *
	 * @return the authorities, sorted by natural key (never <code>null</code>)
	 */
	public GrantedAuthority[] getAuthorities() {
		List<GrantedAuthority> grantedAuthorities = new ArrayList<GrantedAuthority>(roles.size());
		for (SecurityRole role : roles) {
			// FrameWorkLogger.debug("getAuthorities role
			// ---------"+role.getRoleType());
			grantedAuthorities.add(new GrantedAuthorityImpl(role.getRoleType()));
			// grantedAuthorities.add(new
			// GrantedAuthorityImpl("ROLE_"+role.getRoleId()));
		}
		return grantedAuthorities.toArray(new GrantedAuthority[roles.size()]);
	}

	/**
	 * Returns the password used to authenticate the user. Cannot return
	 * <code>null</code>.
	 *
	 * @return the password (never <code>null</code>)
	 */
	public String getPassword() {
		return passWord;
	}

	public void setPassword(String passWord) {
		this.passWord = passWord;
	}

	/**
	 * Returns the username used to authenticate the user. Cannot return
	 * <code>null</code>.
	 *
	 * @return the username (never <code>null</code>)
	 */
	public String getUsername() {
		return userName;
	}

	public void setUsername(String userName) {
		this.userName = userName;
	}

	/**
	 * 
	 * */
	public void setRole(List<SecurityRole> _roles) {
		this.roles = _roles;
	}

	/**
	 * Indicates whether the user's account has expired. An expired account
	 * cannot be authenticated.
	 *
	 * @return <code>true</code> if the user's account is valid (ie
	 *         non-expired), <code>false</code> if no longer valid (ie expired)
	 *         账户没有终止
	 */
	/*
	 * public boolean isAccountNonExpired(){ if(this.expiredFlag!=null &&
	 * this.expiredFlag.equals("0")){ return false; } return true; }
	 */
	public boolean isAccountNonExpired() {
		return true;
	}

	public void setExpiredFlag(String expiredflag) {
		this.expiredFlag = expiredflag;

	}

	/**
	 * Indicates whether the user is locked or unlocked. A locked user cannot be
	 * authenticated.
	 *
	 * @return <code>true</code> if the user is not locked, <code>false</code>
	 *         otherwise 没有被锁
	 */
	/*
	 * public boolean isAccountNonLocked(){
	 * if(this.locked!=null&&this.locked.equals("0")){ return false; }else{
	 * return true; } }
	 */
	public boolean isAccountNonLocked() {
		return !locked;
	}

	public void setLocked(boolean _locked) {
		this.locked = _locked;
	}

	/**
	 * Indicates whether the user's credentials (password) has expired. Expired
	 * credentials prevent authentication.
	 *
	 * @return <code>true</code> if the user's credentials are valid (ie
	 *         non-expired), <code>false</code> if no longer valid (ie expired)
	 *         许可
	 */
	public boolean isCredentialsNonExpired() {
		return true;
	}

	/**
	 * Indicates whether the user is enabled or disabled. A disabled user cannot
	 * be authenticated.
	 *
	 * @return <code>true</code> if the user is enabled, <code>false</code>
	 *         otherwise
	 */
	/*
	 * public boolean isEnabled(){ if(enabled!=null && enabled.equals("0"))
	 * return true; else return false; }
	 */

	public String getEnabled() {
		return this.enabled;
	}

	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}

	public boolean isEnabled() {
		return true;
	}

	/**
	 * 
	 * */
	public void setSecurityUserAuth(SecurityUserAuth _securityUserAuth) {
		this.securityUserAuth = _securityUserAuth;
	}

	public SecurityUserAuth gerSecurityUserAuth() {
		return this.securityUserAuth;
	}

	private String saltkey;

	public String getSaltkey() {
		return null;
	}

}
