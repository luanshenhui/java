<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@taglib prefix="s" uri="/struts-tags" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" /> 
    </head>
    <body class="index">
        <!--导航区域开始-->
        <div id="index_navi">
            <ul id="menu">
                <li><a href="login" class="index_on"></a></li>
                <li><a href="role/role_list.html" class="role_off"></a></li>
                <li><a href="admin/admin_list.html" class="admin_off"></a></li>
                <li><a href="../cost/costFee" class="fee_off"></a></li>
                <li><a href="../account/findAccount" class="account_off"></a></li>
                <li><a href="../service/findService" class="service_off"></a></li>
                <li><a href="bill/bill_list.html" class="bill_off"></a></li>
                <li><a href="report/report_list.html" class="report_off"></a></li>
                <li><a href="user/user_info.html" class="information_off"></a></li>
                <li><a href="toUpPwd?password=<s:property value="password"/>" class="password_off"></a></li>
            </ul>
        </div>
    </body>
</html>

