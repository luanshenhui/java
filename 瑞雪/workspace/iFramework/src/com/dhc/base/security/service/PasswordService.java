package com.dhc.base.security.service;

import com.dhc.base.core.Service;

public interface PasswordService extends Service {
	public String updatePassword(String oldPassword, String newPassword);

}
