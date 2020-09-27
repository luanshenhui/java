<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<html>

<head>
<title>行政执法全过程监控平台</title>
<style type="text/css">
<!--
.loginFormBg{
	background-image:url(../static/dec/images/login-bg.jpg);
	background-repeat:repeat-x;
}
#loginForm{
	width:521px;
	height:285px;
	margin:auto;
	margin-top:200px;
}
.loginDiv{
	width:260px;
	height:130px;
	margin-top:130px;
	margin-left:130px;
	position:absolute;}
.loginTable{
	font-size:14px;
	line-height:30px;
	font-weight:bolder;
	color:#069}
.inputText{
	font-size:14px;
	color:#069;
	width:170px;
}
.inputText_yzm{
	font-size:14px;
	color:#069;
	width:80px;
}
.errorMsg{
	font-size:14px;
	color:red;
}
-->
</style>

<script type="text/javascript">
function changeCode() { 
	var imgNode = document.getElementById("vimg");
	imgNode.src = "/getRandom?t=" + Math.random();
}
</script>
</head>

<body class="loginFormBg">
<form id="ssoLoginForm" name="ssoLoginForm" action="loginServlet" method="post">
<div id="loginForm">
    <div class="loginDiv">
    	<table width="260" border="0" cellspacing="0" cellpadding="0" class="loginTable">
          <tr>
            <td width="76">用户名：</td>
            <td colspan="2"><input type="text" name="username" id="username" maxlength="20" value="" class="inputText"/></td>
          </tr>
          <tr>
            <td>密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
            <td colspan="2"><input type="password" name="password" id="password"  maxlength="20"  value="" class="inputText"/></td>
          </tr>
          <tr>
            <td>验证码：</td>
            <td width="104"><input type="text" name="randomCode" id="randomCode" class="inputText_yzm" value="" /></td>
            <td align="left"><img id="vimg"  title="点击更换" onclick="changeCode();" src="getRandom"/></td>
          </tr>
          <tr>
            <td colspan="3" align="center">
            	<input name="ssoLoginFormSubmit" value="登 录" type="submit" class="btn"/>
				&nbsp;&nbsp;&nbsp;
				<input name="ssoLoginFormReset" value="重 置" type="reset" class="btn"/>
            </td>
            </tr>
            <tr valign="middle">
				<td colspan="3" class="errorMsg">${changePwd }</td>
			</tr>
			<tr valign="middle">
				<td colspan="3" class="errorMsg">${message }</td>
			</tr>
        </table>

    </div>
</div>

</form>

</body>

</html>
