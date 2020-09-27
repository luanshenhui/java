package com.dhc.base.web.struts;

import javax.servlet.ServletContext;

import org.apache.struts.action.ActionServlet;
import org.apache.struts.actions.DispatchAction;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.dhc.base.core.BaseService;
import com.dhc.base.log.FrameWorkLogger;

public abstract class BaseDispatchAction extends DispatchAction {
	private BaseService baseService;

	protected BaseService getBaseService() {
		return this.baseService;
	}

	/**
	 * get BaseService by spring WebApplicationContextUnit the Ioc was configed
	 * at applicationContext.xml
	 */
	public void setServlet(ActionServlet actionServlet) {
		try {
			super.setServlet(actionServlet);
			ServletContext servletContext = actionServlet.getServletContext();
			ApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);
			this.baseService = (BaseService) wac.getBean("baseService");
			baseService.setApplicationContext(wac);
		} catch (Exception e) {
			FrameWorkLogger.error("error at set application context", e);
		}

	}

}
