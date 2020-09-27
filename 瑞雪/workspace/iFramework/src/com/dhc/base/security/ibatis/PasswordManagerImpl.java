package com.dhc.base.security.ibatis;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.encoding.PasswordEncoder;
import org.springframework.security.userdetails.UserDetails;

import com.dhc.base.common.JTConsts;
import com.dhc.base.security.PasswordManager;
import com.dhc.base.security.SecurityUser;

public class PasswordManagerImpl extends SqlMapClientDaoSupport implements PasswordManager {
	/**
	 * let current user change password.
	 */
	public String updatePassword(String oldPassword, String newPassword) {

		Object obj = (Object) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String username = "";
		if (obj instanceof UserDetails) {
			username = ((UserDetails) obj).getUsername();
		} else {
			username = obj.toString();
		}

		String saltkey = com.dhc.base.security.SecurityUserHoder.getCurrentUser().getSaltkey();

		String encodedOldPassword = passwordEncoder.encodePassword(oldPassword, saltkey);
		String encodedNewPassword = passwordEncoder.encodePassword(newPassword, saltkey);

		/*
		 * FrameWorkLogger.info("更新密码：" + "输入的旧密码(" + oldPassword+ "), " +
		 * "输入的新密码(" + newPassword + ")");
		 */

		SecurityUser oldInfo = (SecurityUser) getSqlMapClientTemplate()
				.queryForObject("SecurityUser.sercurity_getUserByUsername", username);

		if (oldInfo == null || !oldInfo.getPassword().equalsIgnoreCase(encodedOldPassword)) {
			return JTConsts.MESSAGE_WRONG_OLD_PASSWORD;
		} else {
			SecurityUser newInfo = new SecurityUser();
			newInfo.setUsername(oldInfo.getUsername());
			newInfo.setPassword(encodedNewPassword);
			int result = getSqlMapClientTemplate().update("SecurityUser.sercurity_changePassword", newInfo);
			if (result == 1) {
				// return JTConsts.MESSAGE_CHANGE_PASSWORD_SUCCESS;
				return "success";
			} else {
				return JTConsts.MESSAGE_CHANGE_PASSWORD_FAIL;
			}
		}
	}

	/**
	 * 获得加密类 配置见 dataAccessContext-local.xml 的配置
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
