<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.trs.idm.util.StringHelper"%>
<%@page import="com.trs.idm.util.RequestUtil"%>
<%@page import="com.trs.idm.interact.agent.IAgent"%>
<%@page import="com.trs.idm.interact.agent.AgentFactory"%>
<%@page import="com.trs.idm.client.filter.IdsAgentAccessHelper"%>
<%
	IAgent agent = AgentFactory.getInstance();

		IdsAgentAccessHelper ssoFilterProcessor = new IdsAgentAccessHelper(agent);
		String method = request.getMethod();
	
	String action = RequestUtil.getParameterSafe(request, "action");
	if("checkIsMustProcessUri".equals(action)) {
		//1.检测是否属于必须匹配的请求地址
		String mustProcessUri = RequestUtil.getParameterSafe(request, "mustProcessUri");
		
		out.println("是否属于必须匹配的请求地址：" + 
				ssoFilterProcessor.isMustProcessUrls(mustProcessUri, method) + "，请求的URL:" + mustProcessUri + "<br>");
	}
	if("checkLogoutUri".equals(action)) {
		//2.检测退出地址配置是否正确
		String logoutUri = RequestUtil.getParameterSafe(request, "logout.uri");
		
		out.println("是否是指定的退出地址：" + 
				ssoFilterProcessor.isLogoutRequest(logoutUri) + "，请求的URL:" + logoutUri+"<br>");
	}
	if("checkLoginActionUri".equals(action)) {
		//3.判断是否是指定的自有登录Action地址
		String loginActionUri= RequestUtil.getParameterSafe(request, "loginAction.uri");
		
		out.println("是否是指定的自有登录Action:" + 
				ssoFilterProcessor.isSSOLoginReqByLocalPage(loginActionUri, method) + "，请求的URL:" + loginActionUri);
		
	}
	
%>