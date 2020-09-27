package com.dhc.base.security.service.impl;

import java.util.List;

import com.dhc.authorization.resource.facade.IPrivilegeFacade;
import com.dhc.authorization.resource.facade.ResourceBean;
import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.security.service.iFrameworkMainService;

public class iFrameworkMainServiceImpl implements iFrameworkMainService {
	private IPrivilegeFacade privilegeFacade;

	public IPrivilegeFacade getPrivilegeFacade() {
		return privilegeFacade;
	}

	public void setPrivilegeFacade(IPrivilegeFacade privilegeFacade) {
		this.privilegeFacade = privilegeFacade;
	}

	public List<ResourceBean> getUserAvailableMenus(String account, String appName)
			throws ServiceException, PrivilegeFacadeException {
		try {
			List<ResourceBean> avaliableMenus = privilegeFacade.getUserAvailableMenus(account, appName);
			return avaliableMenus;
		} catch (PrivilegeFacadeException e) {
			throw new ServiceException(e);
		}

	}

}
