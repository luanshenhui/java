package com.market.action;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.market.service.LoginuserService;
import com.market.util.Constants;
import com.market.util.DataSource;
import com.market.util.PageBean;
import com.market.vo.Loginuser;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LoginuserWebAction extends ActionSupport {

	/**
	 * Service层实例
	 */
	private LoginuserService loginuserService;

	/**
	 * 日志
	 */
	private Logger log = Logger.getLogger(this.getClass());

	private Loginuser loginuser = new Loginuser();

	private Long id;

	/**
	 * 登录
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String logon() {
		log.debug("logon" + "开始");
		List list = loginuserService.findPageInfoLoginuser(loginuser, null);
		if (list == null) {
			HttpServletRequest request = ServletActionContext.getRequest();
			request.setAttribute("messageInfo", "用户名或密码错误！");
			return "fail";
		}
		Loginuser loginuser = (Loginuser) list.get(0);
		HttpServletRequest request = ServletActionContext.getRequest();

		request.getSession().setAttribute("currentUser", loginuser);

		log.debug("logon" + "结束");
		return "success";
	}

	/**
	 * 退出
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String logonOut() {
		log.debug("logonOut" + "开始");
		ActionContext actionContext = ActionContext.getContext();
		Map session = actionContext.getSession();
		session.put("currentUser", null);
		return "fail";
	}

	@SuppressWarnings("unchecked")
	public String queryLoginuser() {
		log.debug("queryLoginuser" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);

		int resultSize = 0;
		PageBean pageBean = null;
		resultSize = loginuserService.getCount(loginuser);
		pageBean = PageBean.getPageBean(Constants.DISPLAYID_LOGINUSER,
				resultSize, request);
		List list = loginuserService
				.findPageInfoLoginuser1(loginuser, pageBean);
		request.setAttribute(Constants.LOGINUSER_LIST, list);
		log.debug("queryLoginuser" + "结束");
		return Constants.LIST;
	}

	/**
	 * 
	 * 进入增加界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toAddLoginuser() {
		log.debug("toAddLoginuser" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		initSelect(request);
		log.debug("toAddLoginuser" + "结束");
		return Constants.ADD;
	}

	/**
	 * 
	 * 增加
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String addLoginuser() {
		log.debug("addLoginuser" + "开始");
		try {
			loginuserService.save(loginuser);
			loginuser = new Loginuser();
		} catch (Exception e) {
			log.error("addLoginuser failed" + loginuser.toString());
		}
		log.debug("addLoginuser" + "结束");
		return queryLoginuser();
	}

	/**
	 * 
	 * 删除
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String delLoginuser() {
		log.debug("delLoginuser" + "开始");
		try {
			loginuser.setId(id);
			loginuserService.delete(loginuser);
		} catch (Exception e) {
			log.error("delLoginuser failed" + loginuser.toString());
		}
		log.debug("delLoginuser" + "结束");
		return queryLoginuser();
	}

	/**
	 * 
	 * 进入编辑界面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String toEditLoginuser() {
		log.debug("toEditLoginuser" + "开始");
		HttpServletRequest request = ServletActionContext.getRequest();
		loginuser = loginuserService.getLoginuser(id);
		initSelect(request);
		log.debug("toEditLoginuser" + "结束");
		return Constants.EDIT;
	}

	/**
	 * 
	 * 查看信息
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String viewLoginuser() {
		log.debug("viewLoginuser" + "开始");
		loginuser = loginuserService.getLoginuser(id);
		log.debug("viewLoginuser" + "结束");
		return Constants.VIEW;
	}

	/**
	 * 
	 * 编辑
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String editLoginuser() {
		log.debug("editLoginuser" + "开始");
		try {
			loginuserService.update(loginuser);
			loginuser = new Loginuser();
		} catch (Exception e) {
			log.error("editLoginuser failed" + loginuser.toString());
		}
		log.debug("editLoginuser" + "结束");
		return queryLoginuser();
	}

	/**
	 * @param LoginuserService
	 *            the LoginuserService to set
	 */
	public void setLoginuserService(LoginuserService loginuserService) {
		this.loginuserService = loginuserService;
	}

	public Loginuser getLoginuser() {
		return loginuser;
	}

	public void setLoginuser(Loginuser loginuser) {
		this.loginuser = loginuser;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void initSelect(HttpServletRequest request) {
		request.setAttribute("yhlx", DataSource.YHLX);

	}

}
