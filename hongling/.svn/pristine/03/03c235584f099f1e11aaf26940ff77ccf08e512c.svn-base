<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link rel="shortcut icon" href="rcmtm.ico" />
<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
<meta http-equiv='pragma' content='no-cache' />
<meta http-equiv='cache-control' content='no-store' />
<meta http-equiv='expires' content='0' />
<title>RCMTM</title>
<link href='../../themes/default/style.css' type='text/css' rel='stylesheet' />
<script type="text/javascript" src="login.js"></script>
<script type="text/javascript" src="checkBrowser.js"></script>
<script type="text/javascript">
	var right=false;
	if ($.ua().is360ee) {
		right=true;
	}else if($.ua().is360se){
		right=true;
	}else if($.ua().isLiebao){
		right=true;
	}else if($.ua().isSougou){
		right=true;
	}else if($.ua().isIe){
		var version=$.ua().ie;
		if (version<8) {
			right=true;
		}
	}
	if (right) {
       	 var url=window.location.href;
       	 if (url.toLowerCase().indexOf("rcmtm.cn")>=0) {
       		alert("系统不兼容当前浏览器， 如继续使用造成的问题，由使用者自行承担，由此给您造成不便，敬请谅解！\n\n(兼容浏览器：谷歌、火狐、苹果、IE8以上版本)");
       		window.location.href="http://www.rcmtm.cn";
		 }else{
			 alert("This system is incompatible with your current browser. If continue, any lose caused by the browser should be undertaken by the customer. Sorry for any inconvenience. \n\n(compatible browsers: Google, Firefox, Apple, IE8 or above version)");
		     window.location.href="http://www.rcmtm.com";
		 }
	}
</script>
</head>
<body style="">
	<div style="position: absolute;right: 4px;top:4px;">
		<select id="versions">
			<option value="1" selected="selected">中文</option>
			<option value="2">English</option>
			<option value="3">Deutsch</option>
			<option value="4">Français</option>
			<option value="5">日本語</option>
		</select>
	</div>

	<div style="width:673px; height:446px; margin:auto; background:url(../../themes/default/images/realm/login.jpg) no-repeat; margin-top:80px; position:relative">
		<div id="logo_login" style="left: 182px;position: absolute;bottom:310px;">
			<img src='../../themes/default/images/realm/rcmtm.gif'></img>
		</div>
		<div class="lblLogoTitle">
			<s:text name="lblLogoTitle"></s:text>
		</div>
		<form class="form" id="form">
			<div id="signin">
				<s:label value="%{getText('lblName')}" cssClass="label_username"></s:label>
				<input class="form_input" type="text" id="username" />
				<s:label value="%{getText('lblPassword')}" cssClass="label_password"></s:label>
				<input class="password" type="password" id="password" />
				<s:label value="%{getText('lblCaptcha')}" cssClass="label_img"></s:label>
				<input type="text" id="captcha" class="form_verify" /> <img
					id="imgCaptcha" class="form_img" src="Kaptcha.jpg"></img>
				<s:label value="%{getText('btnSubmit')}" cssClass="form_submit"
					id="btnSubmit"></s:label>
			</div>
		</form>
	</div>
</body>
</html>
