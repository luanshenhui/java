package com.dhc.base.security;

import org.springframework.security.context.SecurityContextHolder;

public class SecurityUserHoder {
	/**
	 * Returns the current SecurityUser
	 * 
	 * @return SecurityUser
	 */
	public static SecurityUser getCurrentUser() {
		SecurityUser securityUser = new SecurityUser();
		Object obj = (Object) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		if (obj instanceof SecurityUser) {
			return (SecurityUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		} else {
			return securityUser;
		}
	}
}
