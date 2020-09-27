
<%@page import="com.trs.idm.system.SSOConst"%>
<%@page import="com.trs.idm.util.CookieHelper"%>
<%@page import="com.trs.idm.util.HttpConst"%><%@ page language="java" pageEncoding="utf-8"%>
<%@page import="com.trs.idm.saml.sp.core.ServiceProviderFactory"%>
<%@page import="com.trs.idm.saml.sp.core.IServiceProvider"%>
<%
	IServiceProvider sp = ServiceProviderFactory.getInstance();
	sp.doSSOLogout(request, response);
	
	if(sp.checkSSOLogin(request, response) == null) {
		// 请在此输入应用执行退出的逻辑
	}
	
	session.invalidate();
	String idsCmd = request.getHeader(HttpConst.HEADER_IDS_CMD);
	out.print(sp.getCoAppName() + idsCmd + session.getId());
%>