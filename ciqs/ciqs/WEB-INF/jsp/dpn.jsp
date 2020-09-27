<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>首页</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政执法全过程监管平台</span><div>");
			$(".user-info").css("color","white");
	});
</script>
</head>
<body>
<%@ include file="/common/headMenu.jsp"%>
<div style="background-image:url(/ciqs/static/login/images/nav1-bg-sysname.png); width:100%; height:425px; background-repeat:no-repeat; background-position:center top; margin-left:auto; margin-right:auto;">
</div >
</body>
</html>
