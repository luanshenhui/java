package com.dhc.base.security.service;

import java.util.List;

import com.dhc.authorization.resource.facade.ResourceBean;
import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;
import com.dhc.base.core.Service;
import com.dhc.base.exception.ServiceException;

public interface iFrameworkMainService extends Service {
	public List<ResourceBean> getUserAvailableMenus(String account, String appName)
			throws ServiceException, PrivilegeFacadeException;

}
