package com.dhc.base.core;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;

/**
*/
public class BaseServiceImpl implements BaseService {

	public ApplicationContext wacs;
	protected static final Log log = LogFactory.getLog(BaseServiceImpl.class.getName());

	public void setApplicationContext(ApplicationContext wac) {
		this.wacs = wac;
	}

	private Object getBean(String beans) {
		Object service = (Object) wacs.getBean(beans);
		return service;
	}

	public Service getServiceFacade(String serviceFacadeName) {
		return (Service) getBean(serviceFacadeName);
	}

}
