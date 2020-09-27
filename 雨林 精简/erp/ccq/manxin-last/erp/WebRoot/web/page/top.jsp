<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link href="web/css/base.css" rel="stylesheet" type="text/css">
  </head>
  
  <body bgColor='#ffffff' style="margin: 0;padding: 0">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:#1a6892 url(../img/headerBg.gif) repeat-x">
	  <tr>
	    <td width='50%' height="60" style="font-size:26px; font-weight: bold;">&nbsp;&nbsp;JavaEE企业级平台项目实战</td>
	    <td width='50%' align="right">
	    	<table width="550" border="0" cellspacing="0" cellpadding="0">
		      <tr>
			      <td align="right" height="26" style="padding-right:10px;line-height:26px;font-size:17px">
			        	<font style="font-size:16px; font-weight: bold;">
			        	    当前用户：&nbsp;&nbsp;&nbsp;&nbsp;
			        	</font>
			      </td>
	          </tr>
	        </table>
	    </td>
	  </tr>
	</table>
  </body>
</html>
