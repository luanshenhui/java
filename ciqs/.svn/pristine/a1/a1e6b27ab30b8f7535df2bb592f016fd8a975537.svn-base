<%@page import="com.trs.idm.util.UrlUtil"%>
<%@page import="com.trs.idm.util.Base64Util"%>
<%@page import="com.trs.idm.util.StringHelper"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", -1);
	response.setDateHeader("max-age", 0);
	
	String actualRedirectURL = (String) request.getAttribute("actualRedirectURL");
	String loginResultMsg = (String)request.getAttribute("loginResultMsg");
	if(StringHelper.isEmpty(actualRedirectURL)){
		actualRedirectURL = request.getContextPath();
	}
%>
<html>
<head>
<title>TRS IDS Agent:::<%= request.getRequestURL() %></title>

</head>

<body>
<%
if(!StringHelper.isEmpty(loginResultMsg)){
	loginResultMsg = Base64Util.decode(UrlUtil.decode(loginResultMsg),"utf-8");
	%>
	<SCRIPT LANGUAGE="JavaScript">
	alert("<%= loginResultMsg %>");
	</SCRIPT>	
	<%
}
	%>
<SCRIPT LANGUAGE="JavaScript">
document.location.href="<%=actualRedirectURL%>";
</SCRIPT>	
</body>
</html>