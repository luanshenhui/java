package com.dhc.base.security;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.Authentication;
import org.springframework.security.ConfigAttribute;
import org.springframework.security.ConfigAttributeDefinition;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.intercept.web.FilterInvocation;
import org.springframework.security.vote.AccessDecisionVoter;

import com.dhc.authorization.resource.facade.IPrivilegeFacade;
import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;
import com.dhc.base.log.FrameWorkLogger;
import com.dhc.ilead.license.data.LicenseStatusVO;

public class SecurityAuthenticatedCheck implements AccessDecisionVoter {
	private IPrivilegeFacade privilegeFacade;

	public IPrivilegeFacade getPrivilegeFacade() {
		return privilegeFacade;
	}

	public void setPrivilegeFacade(IPrivilegeFacade privilegeFacade) {
		this.privilegeFacade = privilegeFacade;
	}
	// ~ Instance fields
	// ================================================================================================

	private String rolePrefix = "ROLE_";

	// ~ Methods
	// ========================================================================================================

	public String getRolePrefix() {
		return rolePrefix;
	}

	/**
	 * Allows the default role prefix of <code>ROLE_</code> to be overridden.
	 * May be set to an empty value, although this is usually not desirable.
	 * 
	 * @param rolePrefix
	 *            the new prefix
	 */
	public void setRolePrefix(String rolePrefix) {
		this.rolePrefix = rolePrefix;
	}

	public boolean supports(ConfigAttribute attribute) {
		if ((attribute.getAttribute() != null) && attribute.getAttribute().startsWith(getRolePrefix())) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * This implementation supports any type of class, because it does not query
	 * the presented secure object.
	 * 
	 * @param clazz
	 *            the secure object
	 * 
	 * @return always <code>true</code>
	 */
	public boolean supports(Class clazz) {
		return true;
	}

	public int vote(Authentication authentication, Object object, ConfigAttributeDefinition config) {
		int result = ACCESS_ABSTAIN;
		try {
			boolean actionFlag = isAction();
			if (!securityCheck(object) && actionFlag) {
				result = ACCESS_DENIED;
			}
			result = checkAuthenticate(object);
			return result;
		} catch (Exception e) {
			return result;
		}
	}

	private boolean securityCheck(Object object) {
		FilterInvocation filterInvocation = (FilterInvocation) object;
		HttpServletRequest request = filterInvocation.getHttpRequest();
		LicenseStatusVO licenseStatus = (LicenseStatusVO) request.getSession().getServletContext()
				.getAttribute("licenseStatusVO");
		String status = licenseStatus.getStatus();
		// if (!status.equals(licenseStatus.LICENSE_VALID)) {
		// return false;
		// }
		return true;
	}

	private int checkAuthenticate(Object object) {
		FilterInvocation filterInvocation = (FilterInvocation) object;
		String requestURI = filterInvocation.getRequestUrl();
		String username = "";
		HttpServletRequest request = filterInvocation.getHttpRequest();
		String appName = (String) request.getSession().getServletContext().getAttribute("APP_NAME");
		SecurityUser securityUser = null;

		Object userDetail = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		if (!userDetail.equals("roleAnonymous")) {
			securityUser = (SecurityUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			username = securityUser.getUsername();

			try {
				FrameWorkLogger.info("check" + username + "-" + requestURI + "-"
						+ privilegeFacade.isURLAvailable(username, requestURI, appName));
				if (privilegeFacade.isURLAvailable(username, requestURI, appName)) {
					return ACCESS_GRANTED;
				} else {
					return ACCESS_DENIED;
				}
			} catch (PrivilegeFacadeException e) {
				FrameWorkLogger.info("checkAuthenticate error" + username + requestURI);
				FrameWorkLogger.info(e.getMessage());
				return ACCESS_DENIED;
			}
		} else {
			return ACCESS_DENIED;
		}
	}

	private boolean action;

	public void setAction(boolean actoin) {
		this.action = actoin;
	}

	public boolean isAction() {
		return action;
	}

	GrantedAuthority[] extractAuthorities(Authentication authentication) {
		return authentication.getAuthorities();
	}

}
