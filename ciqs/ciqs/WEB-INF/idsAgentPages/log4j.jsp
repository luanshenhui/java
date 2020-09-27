<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.ArrayList,java.util.Collections,java.util.Enumeration" %>
<%@ page import="org.apache.log4j.Level,org.apache.log4j.Logger,org.apache.log4j.LogManager,org.apache.log4j.Appender,org.apache.log4j.FileAppender,org.apache.log4j.WriterAppender" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Log4J</title>
	<style type="text/css">
		body, td { font-size: 12px; }
		#list_title{ border:1px #97CBF1 solid; width:100%; height:27px; line-height:27px; text-align:center;}
		.sp_bg1{ background-color:#FAFAFA; border-bottom:1px #D9EDF8 solid; border-top:1px #D9EDF8 solid;}
		.sp_bg2{ background-color:#EFFBFF; border-bottom:1px #FAFAFA solid; border-top:1px #FAFAFA solid;}
		.xinxi{
			width:99%;
			height:30px;
			border:0px;
			border-bottom:1px #D9EDF8 solid;
			margin:auto;
			text-align:center;
		}
	</style>	
</head>
<%
if ( "POST".equals(request.getMethod()) ){
	String loggerName = request.getParameter("loggerName");
	if ( loggerName != null ){
		Logger logger = Logger.getLogger(loggerName);
		if ( logger != null ){
			String level = request.getParameter("loggerLevel");
			logger.setLevel(Level.toLevel(level));
		}
	}
}
String defaultLoggerName = "com.trs";
String defaultLevel = "OFF";
if ( request.getParameter("loggerName") != null ){
	defaultLoggerName = request.getParameter("loggerName");
}
Logger logger = Logger.getLogger(defaultLoggerName);
if ( logger != null && logger.getLevel() != null ){
	defaultLevel = logger.getLevel().toString();
}
%>
<script>
function changedLoggerName(){
	location.href ="./log4j.jsp?loggerName="+document.getElementById("loggerName").value;
}

function changedLevel(){
	loggerForm.submit();	
}
function onLoad(){
	document.getElementById("loggerName").value="<%=defaultLoggerName %>";
	document.getElementById("loggerLevel").value="<%=defaultLevel %>";
}
</script>

<body onload="onLoad();">
<div>

    <h3>动态设置选定Logger的日志记录级别</h3>
    <p>This page allows you to change the level when logs messages.  It is useful if you are debugging.</p>
    <p>注意: Note that any changes you make here are <i>not persisted</i> across server restarts. You will need to edit 'WEB-INF/classes/log4j.properties' to change levels permanently.</p>

	<form id="loggerForm" method="POST">
		<select id="loggerName" name="loggerName" onchange="javascript:changedLoggerName();">
		<%
		Enumeration enu = LogManager.getCurrentLoggers();
		for ( ; enu.hasMoreElements() ; ){
			logger = (Logger) enu.nextElement();
			String name = logger.getName();
			if ( name.startsWith("com.trs") ){
		%>
			<option id="<%=name %>" value="<%=name %>"><%=name %></option>
		<%		
			}
		}
		%>
		</select>
		<select id="loggerLevel" name="loggerLevel">
			<option id="OFF" value="OFF">未专门设置</option>
			<option id="FATAL" value="FATAL">FATAL</option>
			<option id="ERROR" value="ERROR">ERROR</option>
			<option id="WARN" value="WARN">WARN</option>
			<option id="INFO" value="INFO">INFO</option>
			<option id="DEBUG" value="DEBUG">DEBUG</option>
		</select>
		<input type="submit" value="确定">
	</form>

    <h3>各Logger当前记录级别列表</h3>
    <p>(当前所在节点：<%= java.net.InetAddress.getLocalHost() %>; 应用位置：<%= application.getRealPath("/") %>)</p>
    <p>启动位置：<%= System.getProperty("user.dir") %> (在log4j配置中，如果未标明完整的绝对路径，则日志文件就在此路径下)</p>
	<table width="100%" border="1" cellpadding="0" cellspacing="0">
		<tr id="list_title">
			<td>Logger Name(package or class)</td>
			<td title="通过计算得出的实际级别">当前级别</td>
			<td title="如果有多个输出器, 是否重复输出?">重复记录?</td>
			<td>输出器</td>
		</tr>
		<% Logger rootLogger = LogManager.getRootLogger(); %>
		<tr class="xinxi; sp_bg1">
			<td>rootLogger</td>
			<td><%=rootLogger.getEffectiveLevel() %></td>
			<td><%=rootLogger.getAdditivity() %></td>
			<td>
				<ul>
<%
		for (Enumeration enuApd = rootLogger.getAllAppenders(); enuApd.hasMoreElements(); ) {
%>
				<li><%= getAppenderDetail((Appender) enuApd.nextElement()) %></li>
<%			
		}
%>
				</ul>
			</td>
		</tr>
<%
	enu = LogManager.getCurrentLoggers();
	int i = 0;
	Appender[] appenders = null;
	for ( ; enu.hasMoreElements() ; ){
		logger = (Logger) enu.nextElement();
%>
		<tr class="xinxi; <%=  (i % 2) == 0 ? "sp_bg1" : "sp_bg2" %>">
			<td><%=logger.getName() %></td>
			<td><%=logger.getEffectiveLevel() %></td>
			<td><%=logger.getAdditivity() %></td>
			<td>
				<ul>
<%
		for (Enumeration enuApd = logger.getAllAppenders(); enuApd.hasMoreElements(); ) {
%>
				<li><%= getAppenderDetail((Appender) enuApd.nextElement()) %></li>
<%			
		}
%>
				</ul>
			</td>
		</tr>
<%
	}
%>
	</table>
	
</div>
</body>
<%!
private static String getAppenderDetail(Appender appender) {
	if (appender == null) {
		return "";
	}
	
    StringBuffer sb = new StringBuffer(256);
   	sb.append(appender.getClass().getName());
    if (appender instanceof FileAppender) {
        FileAppender fileAppender = (FileAppender) appender;
        sb.append(": ").append(fileAppender.getFile());
    }
    if (appender instanceof WriterAppender) {
    	WriterAppender writerAppender = (WriterAppender) appender;
        sb.append(" (编码:").append(writerAppender.getEncoding()).append(")");
    }
    return sb.toString();
}
%>
</html>