<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts" %>
<%@ page import="com.dhc.base.common.JTConsts" %>
<%@ page import="com.dhc.base.common.util.SystemConfig" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% 
session.setAttribute("org.apache.struts.action.LOCALE",new java.util.Locale(CommonConsts.LANGUAGE));
//org.springframework.security.AuthenticationException  ex = (org.springframework.security.AuthenticationException)request.getSession().getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
//out.println(ex.getMessage());

org.springframework.security.AuthenticationException ex =(org.springframework.security.AuthenticationException) request.getSession().getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
String errorMessage = "";
if(ex!=null){	
	//out.println(ex.getMessage());
	request.getSession().removeAttribute("SPRING_SECURITY_LAST_EXCEPTION");
}
String webpath = request.getContextPath();

response.setHeader("Pragma","No-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires",1);
String system_title = SystemConfig.getSystemTitle();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="<%=webpath%>/view/base/theme/css/main.css" rel="stylesheet" type="text/css" />
<link href="<%=webpath%>/view/base/theme/css/skin.css" rel="stylesheet" type="text/css" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%=system_title %></title>
<script type="text/javascript" src="<%=webpath%>/view/base/scripts/jquery-1.4.2.min.js"></script>
<script src="<%=webpath%>/view/base/plugin/validate/jquery.validate.min.js" type="text/javascript"></script>
<script src="<%=webpath%>/view/mainframe/scripts/login.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/mainframe/scripts/consts_<%=CommonConsts.LANGUAGE%>.js"></script>
<script src="<%=webpath%>/view/base/plugin/page.set.js"></script>
<!--[if lte IE 6]>
<script src="<%=webpath%>/view/mainframe/scripts/DD_belatedPNG.js" type="text/javascript"></script>
<script>	
  DD_belatedPNG.fix('.png,img');
</script>
<![endif]-->

<style>
body,html { height:100%; text-align:center;}


</style>

</head>
<input  id="webpath" value="<%=webpath%>" type="hidden"/>
<body class="login_body"  onload="checkParent();belatedPNG();" sroll="auto">

<form action="${pageContext.request.contextPath}/j_spring_security_check" onsubmit="javascript:return requiredCheck();" id="loginForm">
<div id="website_logo"><img src="<%=webpath%>/view/base/theme/css/redmond/images1009/login/website_logo.jpg" /></div>

<div id="login" class="png">
<dl>
<dt><bean:message key="iframework.label.username"/>：</dt><dd><input name="j_username" title="<bean:message key="iframework.message.missing_username"/>" type="text" class="input_out" id="inp_name" value="" />
</dd>
<dt><bean:message key="iframework.label.password"/>：</dt><dd><input name="j_password" title="<bean:message key="iframework.message.missing_password"/>" type="password" class="input_out" id="inp_pw" value="" /></dd>
</dl>
<div class="err png" id="errContainer" style="display: none;">	
	<ol>
		<label for="j_username" class="error"></label>
		<label for="j_password" class="error"></label>
	</ol>
</div>
<div class="button png"><input type="image"  name="imgBtn" src="<%=webpath%>/view/base/theme/css/redmond/images1009/login/login_button.png" /></div>
<div class="title png"><img src="<%=webpath%>/view/base/theme/css/redmond/images1009/login/login_title.png" /></div>
<div class="login_copyright">Copyright © 2001-2011 DHC Corporation</div>
</div>
<input   type= "submit "   id= "submit "   style= "display:none; " > 
<div id="login_hide"></div>
<!--[if lte IE 6]>
<script src="<%=webpath%>/view/mainframe/scripts/DD_belatedPNG.js" type="text/javascript"></script>
<![endif]-->

</form>
</body>
</html>
