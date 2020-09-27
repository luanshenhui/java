package com.dhc.base.security;

import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.web.context.support.WebApplicationContextUtils;

import com.dhc.base.log.FrameWorkLogger;
import com.dhc.ilead.license.LicenseService;
import com.dhc.ilead.license.LicenseServiceImpl;
import com.dhc.ilead.license.data.LicenseStatusVO;
import com.dhc.organization.config.OrgnizationConfig;

/**
 * @author
 */
public class ServletContextLoaderListener implements ServletContextListener {
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.ServletContextListener#contextInitialized(javax.servlet.
	 * ServletContextEvent)
	 */
	public void contextInitialized(ServletContextEvent servletContextEvent) {
		ServletContext servletContext = servletContextEvent.getServletContext();
		// Sun Sep 19 15:20:16 2010 wangxy 初始化web根目录
		if (OrgnizationConfig.APP_WEB_ROOT_PATH == null) {
			OrgnizationConfig.APP_WEB_ROOT_PATH = servletContext.getRealPath("");
		}
		setWebAppName(servletContext);
		// over
		// get license status
		LicenseStatusVO licenseStatusVO = getLicenseStatusVO();
		// if(licenseStatusVO!=null&&!licenseStatusVO.isValid()){
		// setIneffectieUrlAuthorities(servletContext,licenseStatusVO);
		// setLicenseVO(servletContext,licenseStatusVO);
		// }else{
		setUrlAuthorities(servletContext);
		setLicenseVO(servletContext, licenseStatusVO);
		// }
	}

	/**
	 * set web application name,configed with the taglib <web-app><display-name>
	 * at web.xml
	 */
	private void setWebAppName(ServletContext servletContext) {
		String appName = servletContext.getServletContextName();
		servletContext.setAttribute("APP_NAME", appName);
	}

	/**
	 * license effectie UrlAuthorities
	 */
	private void setIneffectieUrlAuthorities(ServletContext servletContext, LicenseStatusVO licenseStatusVO) {
		SecurityManager securityManager = this.getSecurityManager(servletContext);
		Map<String, String> ineffectieUrlAuthorities = securityManager.loadIneffectieUrlAuthorities();
		servletContext.setAttribute("urlAuthorities", ineffectieUrlAuthorities);
	}

	private void setLicenseVO(ServletContext servletContext, LicenseStatusVO licenseStatusVO) {
		servletContext.setAttribute("isAvaliableLicense", licenseStatusVO.isValid());
		servletContext.setAttribute("licenseStatusVO", licenseStatusVO);
		FrameWorkLogger.debug("licenseStatusVO.isValid() ===========" + licenseStatusVO.isValid());
	}

	private void setUrlAuthorities(ServletContext servletContext) {
		SecurityManager securityManager = this.getSecurityManager(servletContext);
		Map<String, String> urlAuthorities = securityManager.loadUrlAuthorities();
		servletContext.setAttribute("urlAuthorities", urlAuthorities);
	}

	private LicenseStatusVO getLicenseStatusVO() {
		try {
			LicenseService svc = new LicenseServiceImpl();
			return svc.getLicenseStatus();
		} catch (Exception e) {
			return null;
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.ServletContextListener#contextDestroyed(javax.servlet.
	 * ServletContextEvent)
	 */
	public void contextDestroyed(ServletContextEvent servletContextEvent) {
		servletContextEvent.getServletContext().removeAttribute("urlAuthorities");
	}

	/**
	 * Get SecurityManager from ApplicationContext
	 * 
	 * @param servletContext
	 * @return
	 */
	protected SecurityManager getSecurityManager(ServletContext servletContext) {
		return (SecurityManager) WebApplicationContextUtils.getWebApplicationContext(servletContext)
				.getBean("securityManager");
	}
}
