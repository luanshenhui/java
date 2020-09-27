<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.trs.idm.interact.agent.IAgent"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.trs.idm.interact.agent.AgentFactory"%>
<%@page import="com.trs.idm.util.StringHelper"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Agent监控</title>
</head>
<body>
<%
PrintWriter writerOut = response.getWriter();
String coAppName = request.getParameter("coAppName");
if(StringHelper.isEmpty(coAppName)){
	writerOut.append("Agent:00001");// 错误信息（00001）：协作应用名为空
	writerOut.close();
	return ;
}
IAgent agent = AgentFactory.getInstance(); // 身份服务器IDS提供给客户端(协作应用)的Agent.
if(agent == null){
	writerOut.append("Agent:00002");//  错误信息（00002）：获取Agent信息出现异常情况
	writerOut.close();
	return ;
}
//协作应用不匹配
if(!coAppName.equals(agent.getAgentName())){
	writerOut.append("Agent:00003");//  错误信息（00003）：协作应用名不匹配
	writerOut.close();
	return ;
}
String httpType = agent.getProperty("protocol.http");
boolean isHttpType = Boolean.parseBoolean(httpType);//true为http通讯连接方式，false为socket通讯连接方式
//若Agent活着，说明连接正常
if(agent.isSocketAlive()&& agent.useSSO()){
	writerOut.append("Agent:00000;HttpType:"+isHttpType);// 信息（00000）：协作应用与IDS连接正常;通讯连接方式
	writerOut.close();
	return;
}else{
//否则连接失败
	writerOut.append("Agent:00004;HttpType:"+isHttpType);// 错误信息（00004）：协作应用与IDS连接出现异常;通讯连接方式
	writerOut.close();
}
%>
</body>
</html>