<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="com.dhc.base.common.MessageUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<% 
	String path = request.getContextPath();
	String errorMessage = (String)request.getAttribute(MessageUtil.errorMessage);
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>Error</title>
<link href="<%=path %>/view/base/theme/css/skin.css" rel="stylesheet" type="text/css" />
</head>

<body class="error_body">
<div class="error_info_bg">
  <div class="error_info_title"><bean:message key="common.exception.error.info1"/></div>
  <div class="error_info_con">
<span class="info2"><bean:message key="common.exception.error.info2"/>:</span><br> 
 
<span class="info3"> ● &nbsp;<bean:message key="common.exception.error.info3"/></span><br> 
	  
<span class="info3"> ● &nbsp;<bean:message key="common.exception.error.info4"/></span><br>  	 
	 	 
<span class="info3"> ● &nbsp;<bean:message key="common.exception.error.info5"/></span><br> 
<% if(errorMessage!=null){
	out.println("<span class=\"info2\">Error");
	out.println(":</span><br>");
	out.println("<span class=\"info3\"> ● &nbsp;");
	out.println(errorMessage);
	out.println("</span><br> ");
}%>
  </div>
</div>
</body>
</html>