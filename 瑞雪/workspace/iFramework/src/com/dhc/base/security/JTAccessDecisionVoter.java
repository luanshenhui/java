package com.dhc.base.security;

import java.util.Iterator;

import org.springframework.security.Authentication;
import org.springframework.security.ConfigAttribute;
import org.springframework.security.ConfigAttributeDefinition;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.vote.AccessDecisionVoter;

public class JTAccessDecisionVoter implements AccessDecisionVoter {

	public boolean supports(ConfigAttribute attribute) {
		return true;
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
		Iterator iter = config.getConfigAttributes().iterator();
		GrantedAuthority[] authorities = extractAuthorities(authentication);

		while (iter.hasNext()) {
			ConfigAttribute attribute = (ConfigAttribute) iter.next();

			if (this.supports(attribute)) {
				result = ACCESS_DENIED;

				// Attempt to find a matching granted authority
				for (int i = 0; i < authorities.length; i++) {
					if (attribute.getAttribute().equals(authorities[i].getAuthority())) {
						return ACCESS_GRANTED;
					}
				}
			}
		}

		return result;
	}

	GrantedAuthority[] extractAuthorities(Authentication authentication) {
		return authentication.getAuthorities();
	}
}
