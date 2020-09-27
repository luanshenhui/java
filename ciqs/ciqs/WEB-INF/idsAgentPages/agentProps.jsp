<%--
 View IDS Agent Settings And Information.
--%>
<%@page import="com.trs.idm.interact.agent.socket.SocketHostManager"%>
<%@page import="com.trs.idm.interact.agent.SocketAddr"%>
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

	IAgent agent = AgentFactory.getInstance();
	String nodeKey = request.getParameter("nodeKey");
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
</table>
<br/>

<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
	<td colspan="2"><b>Agent配置信息</b></td>
  </tr>
<%
	Properties props = agent.getProperties();
	String key = null;
	for (Iterator iter = props.keySet().iterator(); iter.hasNext(); ) {
	    key = (String) iter.next();
%>  
  <tr>
	<td width="180"><%= key %></td>
	<td><%= props.getProperty(key) %></td>
  </tr>
<%
	}
%>
</table>
<br/>

<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
	<td width=150><b>SSO URL</b></td>
	<td><%= agent.getGlobalLoginUrl() %></td>
  </tr>
<%
	if (agent instanceof AgentV2) {
		AgentV2 agentV2 = (AgentV2) agent;
		SocketAddr[] idsAddrs = agentV2.getIDSConnectAddrs();
%>  
  <tr>
	<td>所连接的IDS节点</td>
	<td><%= StringHelper.toString(agentV2.getHosts()) %></td>
  </tr>
  <tr>
	<td>Server端返回的节点标识</td>
	<td><%= StringHelper.toString(agentV2.getAllKnownNodeKeys()) %></td>
  </tr>
  <tr>
	<td>空闲队列Size</td>
	<td><%= agentV2.currentIdleQueueSize() %></td>
  </tr>
  <tr>
	<td>工作队列Size</td>
	<td><%= agentV2.currentBusyQueueSize() %></td>
  </tr>
  <tr>
	<td>错误队列Size</td>
	<td><%= agentV2.currentErrorQueueSize() %></td>
  </tr>
  <tr>
	<td>通讯详情</td>
	<td><%= agentV2.currentSocketStatus() %></td>
  </tr>
  <tr>
	<td>重试次数</td>
	<td><%= agentV2.getClientTransferManager().getMaxRetry() %></td>
  </tr>
  <tr>
	<td>重试时等待间隔(ms)</td>
	<td><%= agentV2.getClientTransferManager().getWaitTime() %></td>
  </tr>
  <%
	  	for (int i = 0; i < idsAddrs.length; i++) {
	  		SocketHostManager socketHostMgr = agentV2.getClientTransferManager().getSocketHostManager(idsAddrs[i].getHost());
  %>
  <tr>
	<td><%= socketHostMgr.getHostIP() %>实际分配时最高的等待次数</td>
	<td><%= socketHostMgr.getActualMaxWaitTimes() %></td>
  </tr>
  <%
	  	}
  %>
  <%
  		if (nodeKey != null) {
  %>
  <tr>
	<td>所测的nodeKey对应</td>
		<%
		SocketHostManager socketHost = null;
		try {
			socketHost = agentV2.getClientTransferManager().selectHostByNodeKey(nodeKey);
		} catch (Exception e) {
		}
		%>	
	<td><%= nodeKey %> -- <%= socketHost %></td>
  </tr>
  <%
	  	}
	}
%>
</table>

</body>
</html>