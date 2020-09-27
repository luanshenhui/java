package com.dhc.base.security.ibatis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.encoding.PasswordEncoder;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UserDetailsService;
import org.springframework.security.userdetails.UsernameNotFoundException;

import com.dhc.base.exception.BaseDataAccessException;
import com.dhc.base.log.FrameWorkLogger;
import com.dhc.base.security.SecurityManager;
import com.dhc.base.security.SecurityResource;
import com.dhc.base.security.SecurityRole;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUtil;
import com.dhc.organization.facade.IOrganizationFacade;
import com.dhc.organization.facade.UserBean;
import com.dhc.organization.facade.exception.OrgFacadeException;

public class UserDetailManagerImpl extends SqlMapClientDaoSupport implements UserDetailsService, SecurityManager {

	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {
		SecurityUser securityUser;
		try {
			UserBean userBean = orgFacade.getUserBean(username);
			if (userBean == null) {
				securityUser = null;
			} else {
				securityUser = new SecurityUser();
				securityUser.setUserBean(userBean);
				securityUser.setUsername(userBean.getId());
				securityUser.setPassword(userBean.getPassword());
				securityUser.setLocked(userBean.isLocked());
				if (userBean.isEnabled()) {
					securityUser.setEnabled("Y");
				} else {
					securityUser.setEnabled(null);
				}
			}

			List<SecurityRole> securityRoles;
			securityRoles = new ArrayList<SecurityRole>(1);
			if (securityUser != null) {
				SecurityRole securityRole = new SecurityRole();
				securityRole.setRoldDescription("正常用户");
				securityRole.setRoleId("1");
				securityRole.setRoleType("0");
				securityRole.setRoleName("ROLE_USER");
				securityRoles.add(securityRole);
				securityUser.setRole(securityRoles);

			}
			// check(userBean.getAccount(),"/view/mainframe/index.jsp");
		} catch (UsernameNotFoundException e) {
			throw new UsernameNotFoundException("User " + username + " has no GrantedAuthority");
		} catch (DataAccessException e) {
			throw new BaseDataAccessException("DB error when authenticate User " + username);
		} catch (OrgFacadeException e) {
			FrameWorkLogger.error("UserDetailManagerImpl loadUserByUsername==" + e.getMessage());
			throw new BaseDataAccessException("DB error when authenticate User " + username);
		}
		return securityUser;
	}

	// 加载系统所有资源URL的列表
	public Map<String, String> loadUrlAuthorities() {
		Map<String, String> urlAuthorities = new HashMap<String, String>();
		try {
			FrameWorkLogger.debug("loadUrlAuthorities begin");
			List<SecurityResource> urlResources = getSqlMapClientTemplate()
					.queryForList("SecurityResource.sercurity_getURLResources");

			String theUrlResourceId;
			String theUrl;
			String theUrlMapRoles;
			if (urlResources != null) {
				for (SecurityResource resource : urlResources) {
					// FrameWorkLogger.info(resource.getResourceName()+"--"+resource.getResourceId()+"--"+resource.getResourceValue());
					theUrl = resource.getResourceValue();
					theUrlResourceId = resource.getResourceId();
					theUrlMapRoles = "ROLE_USER";// all user will login ,all
													// user has the same role
					urlAuthorities.put(theUrl, theUrlMapRoles);
				}
			}
		} catch (DataAccessException e) {
			FrameWorkLogger.error("error at loadUrlAuthorities==" + e.getMessage());
			throw new BaseDataAccessException("DB error when authenticate URL Resource !Please check DB connect state");
		}
		return urlAuthorities;
	}

	public Map<String, String> loadIneffectieUrlAuthorities() {
		Map<String, String> urlAuthorities = new HashMap<String, String>();
		try {
			FrameWorkLogger.debug("loadIneffectieEUrlAuthorities begin");
			String theUrlMapRoles = SecurityUtil.generateString(10);
			urlAuthorities.put("/**", theUrlMapRoles);// all resource will be
														// access denied
		} catch (DataAccessException e) {
			FrameWorkLogger.error("error at loadIneffectieEUrlAuthorities==" + e.getMessage());
			throw new BaseDataAccessException("DB error when authenticate URL Resource !Please check DB connect state");
		}
		return urlAuthorities;
	}

	private IOrganizationFacade orgFacade; // = new OrganizationFacadeImpl();

	public IOrganizationFacade getOrgFacade() {
		return orgFacade;
	}

	public void setOrgFacade(IOrganizationFacade orgFacade) {
		this.orgFacade = orgFacade;
	}
	/*
	 * private IPrivilegeFacade privilegeFacade; public IPrivilegeFacade
	 * getPrivilegeFacade() { return privilegeFacade; }
	 * 
	 * public void setPrivilegeFacade(IPrivilegeFacade privilegeFacade) {
	 * this.privilegeFacade = privilegeFacade; } public void check(String
	 * username,String requestURI){ try {
	 * System.out.println("check"+username+" "+requestURI);
	 * System.out.println(privilegeFacade.isURLAvailable(username,requestURI)+
	 * "chenk"); if (privilegeFacade.isURLAvailable(username,requestURI)) {
	 * 
	 * } else {
	 * 
	 * } } catch (PrivilegeFacadeException e) {
	 * FrameWorkLogger.info("checkAuthenticate error"+username+requestURI);
	 * FrameWorkLogger.info(e.getMessage());
	 * 
	 * } }
	 */

	/**
	 * let current user change password.
	 */
	public boolean updatePassword(String oldPassword, String newPassword) {
		Object obj = (Object) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String username = "";
		if (obj instanceof UserDetails) {
			username = ((UserDetails) obj).getUsername();
		} else {
			username = obj.toString();
		}

		String encodedOldPassword = passwordEncoder.encodePassword(oldPassword, username);
		String encodedNewPassword = passwordEncoder.encodePassword(newPassword, username);

		SecurityUser oldInfo = (SecurityUser) getSqlMapClientTemplate()
				.queryForObject("SecurityUser.sercurity_getUserByUsername", username);

		if (oldInfo != null && encodedOldPassword != null
				&& encodedOldPassword.equalsIgnoreCase(oldInfo.getPassword())) {
			SecurityUser newInfo = new SecurityUser();
			newInfo.setUsername(oldInfo.getUsername());
			newInfo.setPassword(encodedNewPassword);
			int result = getSqlMapClientTemplate().update("SecurityUser.sercurity_changePassword", newInfo);
			if (result == 1) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 获得加密类 配置见 dataAccessContext-local.xml 的securityManager配置
	 */
	private PasswordEncoder passwordEncoder;

	public void setPasswordEncoder(PasswordEncoder _passwordEncoder) {
		this.passwordEncoder = _passwordEncoder;
	}

	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
	}

	public String encodePassword(String _password, String _username) {
		return passwordEncoder.encodePassword(_password, _username);
	}

}
