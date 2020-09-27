<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.dhc.base.license.data.LicenseStatusVO"%>
<%
String webpath = request.getContextPath();
LicenseStatusVO licenseStatus = (LicenseStatusVO)request.getSession().getServletContext().getAttribute("licenseStatusVO");
String licenseInfo ="版权保护信息";
String message = licenseStatus.getMessage();
String validFlag = licenseStatus.getStatus();
boolean needWarn = licenseStatus.isNeedWarn();

String daysToExpires = "";
if(needWarn&&licenseStatus.getDaysToExpires()>0){
	daysToExpires = "还有"+licenseStatus.getDaysToExpires()+"天过期";
}else if(licenseStatus.getDaysToExpires()<0){
	daysToExpires = "已过期"+licenseStatus.getDaysToExpires()+"天";
}else if(licenseStatus.getDaysToExpires()==0){
	daysToExpires = "明天过期";
}
String info4 = "继续登录";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="theme/css/main.css" rel="stylesheet" type="text/css" />
</head>
<style>
html{color:#000;font-family:Arial, Helvetica, sans-serif;font-size:12px}body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,button,textarea,p,blockquote,th,td{margin:0;padding:0;font-size:12px;}table{border-spacing:0;}img{border:0;}address,caption,cite,code,dfn,em,strong,th,var,optgroup{font-style:inherit;font-weight:inherit;}del,ins{text-decoration:none;}li{list-style:none;}caption,th{text-align:left;}h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal;}q:before,q:after{content:'';}abbr,acronym{border:0;font-variant:normal;}sup{vertical-align:baseline;}sub{vertical-align:baseline;}legend{color:#000;}input,button,textarea,select,optgroup,option{font-family:inherit;font-size:inherit;font-style:inherit;font-weight:inherit;}input,button,textarea,select{*font-size:100%;}
.error_body{ background:url(<%=webpath%>/view/base/theme/css/redmond/images1009/frame/error_bg.png) #FFFFFF repeat-x; padding:0; margin:0; font-family:Arial, Helvetica, sans-serif}
.error_info_bg{background:url(<%=webpath%>/view/base/theme/css/redmond/images1009/frame/error_main_bg.png) no-repeat; margin:0 auto 0 auto\9; width:800px; height:450px; text-align:center}
.error_info_title{ margin-left:220px; width:400px; height:28px; line-height:28px; background-color:#999999; margin-top:140px; color:#FFFFFF; font-size:14px; text-align:left; padding-left:18px; font-weight:bold}
.error_info_con{ margin-left:220px; width:400px; height:300px; line-height:28px; margin-top:18px;text-align:left; font-size:12px;}
.error_info_con .info1{ margin-right:0px; color:#990000; margin-left:38px}
.error_info_con .info2{ margin-right:30px; color:#000000; margin-left:0px; font-size:14px}
.error_info_con .info3{ margin-right:30px; color:#000000; margin-left:24px}

</style>
<body class="error_body">
<div class="error_info_bg">
  <div class="error_info_title"><%=licenseInfo%></div>
  <div class="error_info_con">
<span class="info3"> ● &nbsp;<%=message%></span><br>   
<%if(licenseStatus.getDaysToExpires()<0){%>
<span class="info3"> ● &nbsp;<%=daysToExpires%></span><br>
<%} %>  
<span class="info3"> ● &nbsp;<a href="<%=webpath%>/login.jsp"><%=info4%></a></span>

<br>  	 
	 	 
<br> 

  </div>
</div>
</body>
</html>

