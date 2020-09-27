package com.dhc.base.security.service.impl;

import com.dhc.base.security.PasswordManager;
import com.dhc.base.security.service.PasswordService;

public class PasswordServiceImpl implements PasswordService {

	private PasswordManager passwordManager;

	public void setPasswordManager(PasswordManager passwordManager) {
		this.passwordManager = passwordManager;
	}

	public PasswordManager getPasswordManager() {
		return passwordManager;
	}

	public String updatePassword(String oldPassword, String newPassword) {

		return passwordManager.updatePassword(oldPassword, newPassword);
	}

}
