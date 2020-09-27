<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%
	// 获得应用上下文
	String webpath = request.getContextPath();
	String info1 = "您无权访问该页面";
	String info2 = "您可以尝试以下操作";
	String info3 = "联系管理员解决问题";
	String info4 = "重新登录";
	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>AccessDenied</title>
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
  <div class="error_info_title"><%=info1%></div>
  <div class="error_info_con">
<span class="info2"><%=info2%>:</span><br> 
 
<span class="info3"> ● &nbsp;<%=info3%></span><br> 
	  
<span class="info3"> ● &nbsp;<a href="<%=webpath%>/login.jsp"><%=info4%></a></span><br>  	 
	 	 
<br> 

  </div>
</div>
</body>
</html>
