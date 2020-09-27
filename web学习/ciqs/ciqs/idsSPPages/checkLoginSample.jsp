<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="com.trs.idm.saml.common.IDSUser"%>
<%@page import="com.trs.idm.saml.sp.core.ServiceProviderFactory"%>
<%@page import="com.trs.idm.saml.sp.core.IServiceProvider"%>
<%
	IServiceProvider sp = ServiceProviderFactory.getInstance();
	
	IDSUser idsUser = sp.checkSSOLogin(request, response);
	if(idsUser == null) {
		System.out.println("NOT SSO Login!");
	}
	

%>