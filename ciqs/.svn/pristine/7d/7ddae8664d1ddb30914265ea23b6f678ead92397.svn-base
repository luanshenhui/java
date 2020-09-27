
<%@page import="com.trs.idm.system.SSOConst"%>
<%@page import="com.trs.idm.util.HttpConst"%><%@ page language="java" pageEncoding="utf-8"%>
<%@page import="com.trs.idm.saml.common.IDSUser"%>
<%@page import="com.trs.idm.saml.sp.core.ServiceProviderFactory"%>
<%@page import="com.trs.idm.saml.sp.core.IServiceProvider"%>
<%@page import="com.trs.idm.util.RequestUtil"%>
<%@page import="com.trs.idm.saml.common.SamlConst"%>
<%@page import="com.trs.idm.util.DateUtil"%>
<%@page import="com.trs.idm.util.CookieHelper"%>
<%
	IServiceProvider sp = ServiceProviderFactory.getInstance();
	IDSUser idsUser = sp.doSSOLogin(request, response);
	if(idsUser != null) {
		// 请在此输入应用执行登录的逻辑
	}
	
	CookieHelper cookiehelper = new CookieHelper(request, response);
	cookiehelper.removeCookie(SSOConst.CK_SSOID);
	cookiehelper.removeCookie(SSOConst.CK_COSESSIONID);
	
	String idsCmd = request.getHeader(HttpConst.HEADER_IDS_CMD);
	out.print(sp.getCoAppName() + idsCmd + session.getId());
%>