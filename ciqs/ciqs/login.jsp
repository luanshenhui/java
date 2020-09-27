<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>行政执法全过程监管平台</title>
<link href="static/login/style.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body,td,th {
    font-family: "Microsoft YaHei", "helvetica neue", tahoma, arial, "hiragino sans gb", Simsun, sans-serif;
}

body {
    background-image: url(static/login/images/LOGIN-BG-2.png);
    background-repeat: no-repeat;
    background-color: #e9e9e9;
    background-position: center top;
}

.nav-link {
    color: #393939;
    font-size: 18px;
    font-weight: bold;
}

.nav-link:hover {
    color: #393939;
    font-size: 18px;
    font-weight: bold;
}
</style>

<script type="text/javascript">
	function loginForm() {
		if(document.getElementById('CheckboxGroup1_0').checked == true){
			window.localStorage.setItem("username",document.getElementsByName("username")[0].value);
			window.localStorage.setItem("password",document.getElementsByName("password")[0].value);
		}
		document.getElementById("loginForm").submit();
	}
</script>
</head>
<body>
    <div style="height:310px; padding-top:190px; background-image:url(static/login/images/shadow.png); background-position:center bottom; background-repeat:no-repeat;">
        <div style="width:650px; margin-left:auto; margin-right:auto; background-image: url(static/login/images/login-bg2.png); height:290px; padding:10px;">
            <div style="width:650px; height:290px;background-color:#FFF">
                <div style="width:316px; float:left;">
                    <img src="static/login/images/login-photo.png" width="316" height="290" />
                </div>
                <div style="width:270px; height:226px; float:right; padding:32px; text-align:left;">
                    <dl style="font-size:18px; background-image:url(static/login/images/login-title-bg.png); background-repeat:no-repeat; padding-left:25px;">
                        <blockquote>
                            <p>帐号登录</p>
                        </blockquote>
                    </dl>
                    <form id="loginForm" action="loginServlet" method="post">
                        <table width="270" border="0" cellpadding="0" cellspacing="0" style="margin-top:25px;">
                            <tr>
                                <td width="38" height="50" align="left" valign="top">
                                    <img src="static/login/images/login-name-icon.png" width="38" height="30"/>
                                </td>
                                <td colspan="3" align="left" valign="top">
                                    <input name="username" type="text" class="login-input user-input" id="username" onkeydown="if(event.keyCode==13){loginForm();}" />
                                </td>
                            </tr>
                            <tr>
                                <td width="38" height="50" align="left" valign="top">
                                    <img src="static/login/images/login-pw-icon.png" width="38" height="30" />
                                </td>
                                <td colspan="3" align="left" valign="top">
                                    <input name="password" type="password" class="login-input pwd-input" id="password" onkeydown="if(event.keyCode==13){loginForm();}" />
                                </td>
                            </tr>
                            <c:if test="${not empty message}">
                            <tr>
                                <td colspan="4" align="center">
                                    <span style="color:red;">${message}</span>
                                </td>
                            </tr>
                            </c:if>
                            <tr style="font-size:12px;">
                                <td height="25" align="left" valign="top">&nbsp;</td>
                                <td width="21" height="25" align="left" valign="middle">
                                    <p>
                                        <input name="CheckboxGroup1" type="checkbox" id="CheckboxGroup1_0" value="复选框" checked="checked" />
                                    </p>
                                </td>
                                <td width="149" height="25" align="left" valign="middle">记住密码</td>
                                <td width="70" height="25" align="left" valign="middle">
                                    <a href="#" class="login-link">忘记密码?</a>
                                </td>
                            </tr>
                            <tr>
                                <td height="20" align="left" valign="top">&nbsp;</td>
                                <td height="20" colspan="3" align="left" valign="top">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" valign="top">&nbsp;</td>
                                <td colspan="3" align="left" valign="top">
                                    <span style="display:block; background-color:#228fe2; height:30px; font-size:18px; color:#FFF; text-align:center; line-height:30px;">
                                        <a href="javascript: loginForm()" class="login-btn-link">立即登录</a>
                                    </span>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
	if(window.localStorage.getItem("username")!=null){
		document.getElementsByName("username")[0].value = window.localStorage.getItem("username")
		document.getElementsByName("password")[0].value = window.localStorage.getItem("password")
	}
</script>
</html>