package com.dhc.base.security.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.dhc.authorization.resource.facade.ResourceBean;
import com.dhc.base.common.JTConsts;
import com.dhc.base.common.util.SystemConfig;
import com.dhc.base.exception.ActionException;
import com.dhc.base.log.FrameWorkLogger;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.base.security.service.iFrameworkMainService;
import com.dhc.base.security.service.PasswordService;
import com.dhc.base.web.struts.BaseDispatchAction;
import com.dhc.organization.facade.UserBean;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;

public class iFrameworkMainAction extends BaseDispatchAction {
	private iFrameworkMainService frameworkMainService;
	private PasswordService passwordService;

	public ActionForward init(ActionMapping actionMapping, ActionForm actionForm, HttpServletRequest request,
			HttpServletResponse response) throws ActionException {
		try {
			frameworkMainService = (iFrameworkMainService) getBaseService().getServiceFacade("frameworkMainService");
			SecurityUser sercurityUser = SecurityUserHoder.getCurrentUser();
			if (sercurityUser != null) {
				List<ResourceBean> avaliableMenus = frameworkMainService
						.getUserAvailableMenus(sercurityUser.getUsername(), getAppName(request));
				if (avaliableMenus != null)
					FrameWorkLogger.info("list size is " + avaliableMenus.size());
				request.setAttribute("avaliableMenus", avaliableMenus);
				return actionMapping.findForward("success");
			} else {
				FrameWorkLogger.info("取权限信息异常");
				return actionMapping.findForward("failure");
			}
		} catch (Exception e) {
			return actionMapping.findForward("failure");
		}
	}

	public String getAppName(HttpServletRequest request) {
		return (String) request.getSession().getServletContext().getAttribute("APP_NAME");
	}

	public ActionForward changePassword(ActionMapping actionMapping, ActionForm actionForm, HttpServletRequest request,
			HttpServletResponse response) throws ActionException {
		PrintWriter writer = null;
		String returnValue = "";
		response.setCharacterEncoding("UTF-8");

		try {
			passwordService = (PasswordService) getBaseService().getServiceFacade("TP_passwordManager");

			// securityManager =
			// (SecurityManager)getBaseService().getServiceFacade("TP_securityManager");
			// securityManager = new
			String oldPassword = request.getParameter("oldPassword");
			String newPassword = request.getParameter("newPassword");

			returnValue = passwordService.updatePassword(oldPassword, newPassword);

		} catch (Exception e) {
			returnValue = JTConsts.MESSAGE_CHANGE_PASSWORD_EXCEPTION;
			FrameWorkLogger.info("更新密码异常");
			e.printStackTrace();
		}

		try {
			writer = response.getWriter();
		} catch (IOException e) {
			returnValue = JTConsts.MESSAGE_CHANGE_PASSWORD_EXCEPTION;
			FrameWorkLogger.info("更新密码获取writer异常");
			e.printStackTrace();
		} finally {
			writer.println(returnValue);
			writer.flush();
			writer.close();
		}
		return null;
	}

	public ActionForward getUserShowInfo(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		StringBuffer userShowInfo = new StringBuffer();
		String system_config_top_username = SystemConfig.getTopUserName();
		if (system_config_top_username.equals("0")) {
			userShowInfo.append("");
		}
		PrintWriter writer = null;

		try {
			UserBean userBean = SecurityUserHoder.getCurrentUser().getUserBean();
			String userShowName = "";
			if (userBean != null) {
				userShowName = userBean.getFullName();
			}
			if (system_config_top_username.equals("1")) {
				userShowInfo.append(userShowName);
			}
			if (system_config_top_username.equals("2")) {
				userShowInfo.append(userShowName);
				List userUnit = null;
				if (userBean != null) {
					userUnit = userBean.getUnitList();
				}
				String unit = "";
				String role = "";
				String station = "";

				if (userUnit != null) {
					for (int i = 0; i < userUnit.size(); i++) {
						if (i > 0) {
							unit = unit + "、" + ((WF_ORG_UNIT) userUnit.get(i)).getUnitName();
						} else {
							unit = unit + ((WF_ORG_UNIT) userUnit.get(i)).getUnitName();
						}
					}
				}

				if (userUnit != null && userUnit.size() > 0) {
					userShowInfo.append("(");
					userShowInfo.append(unit);
					userShowInfo.append(")");
				}
			}
		} catch (Exception e) {
			FrameWorkLogger.error("error at get user info", e);
			userShowInfo.toString();
		}

		try {
			writer = response.getWriter();
			writer.println(userShowInfo.toString());
		} catch (IOException e) {
			FrameWorkLogger.error("error at write user info", e);
		} finally {
			writer.flush();
			writer.close();
		}
		return null;
	}

	public ActionForward getHelpLink(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		String system_config_help_link = SystemConfig.getHelpLink();
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			writer.println(system_config_help_link.trim());
		} catch (IOException e) {
			FrameWorkLogger.error("error at write help link", e);
		} finally {
			writer.flush();
			writer.close();
		}
		return null;
	}
}
