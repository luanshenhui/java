<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="com.trs.idm.saml.common.IDSUser"%>
<%@page import="com.trs.idm.saml.common.SamlConst"%>
<%@page import="com.trs.idm.saml.sp.core.ServiceProviderFactory"%>
<%@page import="com.trs.idm.saml.sp.core.IServiceProvider"%>
<%
	IServiceProvider sp = ServiceProviderFactory.getInstance();
	

	request.setAttribute("userName", "yao");
	request.setAttribute("password", "111111");
	IDSUser	idsUser = sp.doSSOLogin(request, response);
%>