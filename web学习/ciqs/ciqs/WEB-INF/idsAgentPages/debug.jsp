<%--
 View IDS Agent Settings And Information.
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.trs.idm.interact.agent.AgentFactory"%>
<%@ page import="com.trs.idm.interact.agent.IAgent"%>
<%@ page import="com.trs.idm.interact.agent.AgentVersion" %>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.addHeader("Cache-Control","no-store"); //Firefox
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", -1);
	response.setDateHeader("max-age", 0);

	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@page import="com.trs.idm.interact.agent.AgentV2"%>
<%@page import="com.trs.idm.util.StringHelper"%>
<html>
<head>
<title>TRS IDS Agent Properties</title>
<style type=text/css>
body {
	FONT-SIZE: 10px;
}
td {
	FONT-SIZE: 12px;
}
</style>
</head>
<body>
<b><font size="5" color="blue">协作应用服务器信息</font></b>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
	<td width=150><b>协作应用目录</b></td>
	<td><%= application.getRealPath("/") %></td>
  </tr>
  <tr>
	<td><b>协作应用主机名/IP</b></td>
	<td><%= java.net.InetAddress.getLocalHost() %></td>
  </tr>
  <tr>
	<td><b>当前SessionID</b></td>
	<td><%= session.getId() %></td>
  </tr>
  <tr>
	<td><b>当前时间</b></td>
	<td><%= new java.sql.Timestamp(System.currentTimeMillis()) %></td>
  </tr>
  <tr>
	<td><b>Agent版本</b></td>
	<td><%= AgentVersion.getReleaseInfo() %></td>
  </tr>
  <tr>
	<td><b>Agent类文件位置</b></td>
	<td><%= AgentVersion.getSourceLocation() %></td>
  </tr>
  <tr>
	<td><b>ClassLoader加载位置诊断</b></td>
	<td>com.trs.idm.client.filter.GeneralSSOFilter.class.getResource("/")：<br><%= 	com.trs.idm.client.filter.GeneralSSOFilter.class.getResource("/") %></td>
  </tr>
  
</table>
<br/>

<%
	IAgent agent = AgentFactory.getInstance();
	
%>
<b><font size="5" color="blue"><%=(agent == null)?"Agent为null，无法获取配置文件信息":"Agent配置" %></font></b>

<%
// Agent不等于null开始
if(agent != null) {
%>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
<%
	Properties props = agent.getPropsCopy();
	String key = null;
	for (Iterator iter = props.keySet().iterator(); iter.hasNext(); ) {
	    key = (String) iter.next();
%>  
  <tr>
	<td width="180"><b><%= key %></b></td>
	<td><%= props.getProperty(key) %></td>
  </tr>
<%
	}
%>
</table>
<br/>
<b><font size="5" color="blue">Agent运行状态信息（动态）</font></b>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
	<td width=150><b>是否与IDS进行协同</b></td>
	<td>	<%= agent.useSSO() ? "已启用" : "已停用" %></td>
  </tr>
  <tr>
	<td width=150><b>SSO URL</b></td>
	<td><%= agent.getGlobalLoginUrl() %></td>
  </tr>
<%
	if (agent instanceof AgentV2) {
		AgentV2 agentV2 = (AgentV2) agent;
%>  
  <tr>
	<td><b>空闲队列Size</b></td>
	<td><%= agentV2.currentIdleQueueSize() %></td>
  </tr>
  <tr>
	<td><b>工作队列Size</b></td>
	<td><%= agentV2.currentBusyQueueSize() %></td>
  </tr>
  <tr>
	<td><b>错误队列Size</b></td>
	<td><%= agentV2.currentErrorQueueSize() %></td>
  </tr>
  <tr>
	<td><b>所连接的IDS节点标识</b></td>
	<td><%= StringHelper.toString(agentV2.getAllKnownNodeKeys()) %></td>
  </tr>
<%
	}
%>
</table>

<!-- DEBUG -->
<b><font size="5" color="blue">Agent功能检测</font></b>
<form action="do_debug.jsp">
	<table width="100%" border="1" cellpadding="0" cellspacing="0">	
		<tr>
			<td width=150><b>检测请求的地址是否为必须匹配,请输入检测地址</b></td>
			<td><input name="mustProcessUri" value="" /></td>
			<td>检测请求的地址是否为必须匹配，其中必须匹配的请求有：debug页面、Agent配置文件已配置的选项(如：processUrl.prefix、loginAction.uri、logout.uri、regUser.uri、verifyButNotLogin.uri)</td>

			<td align="right"><input type="submit" name="valid" value="检测"/></td>
		</tr>
	</table>
	<input type="hidden" name="action" value="checkIsMustProcessUri" />
</form>
<form action="do_debug.jsp">
	<table width="100%" border="1" cellpadding="0" cellspacing="0">	
	<tr>
		<td width=150><b>退出URI配置是否正确检测，请输入系统的退出URI</b></td>
		<td><input name="logout.uri" value="" /></td>
		<td>退出URL的配置根据request.getServletPath()获取到的，比如访问http://localhost:8000/wcm/user/logout.jsp,则配置/user/logout.jsp才起作用，不要包含上下文wcm</td>
		<td align="right"><input type="submit" name="valid" value="检测"/></td>
	</tr>
	</table>
	<input type="hidden" name="action" value="checkLogoutUri" />
</form>
<form action="do_debug.jsp">
	<table width="100%" border="1" cellpadding="0" cellspacing="0">	
		<tr>
			<td width=150><b>登录Action URI配置是否正确检测,请输入登录Action URI</b></td>
			<td><input name="loginAction.uri" value="" /></td>
			<td>登录URL的配置根据request.getServletPath()获取到的，比如访问登录表单的form action=do_login.jsp,则配置/do_login.jsp才起作用，不要包含上下文wcm</td>
			<td align="right"><input type="submit" name="valid" value="检测"/></td>
		</tr>
	</table>
	<input type="hidden" name="action" value="checkLoginActionUri" />
<%
// Agent不等于null结束
}
%>	
	
</form>
</body>
</html>