<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
		<script type="text/javascript" src="js/jquery.validate.js"></script>
		<script type="text/javascript" src="js/ajax.js"></script>
		<script type="text/javascript" src="js/jquery.validate.messages_cn.js"></script>
		<script type="text/javascript">					
</script>
		<style>
.grayText {
	color: #FF30E0;
	font-size: 15px;
}

</style>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" type="text/css" href="css/regist.css" />
	<!--script type="text/javascript" src = "js/jquery-1.4.min.js"></script>
	<script type="text/javascript">
	$(function(){
	$("#hh").toggle(function(){
	$("img:first").attr("src","image?"+new Date().getTime()+1);
	},function(){
	$("img:first").attr("src","image?"+new Date().getTime());
	});
	});
	function sendRequest(){
	var username = $(":text[id='username']").val();
	Ajax.sendRequest("POST","CheckNameServlet","username="+username,fun);
	}
	function fun(ob){
	var ss = ob.text;
	var span = document.getElementById("msg");
	span.removeChild(span.firstChild);
	var text = document.createTextNode(ss);
	span.appendChild(text);
	}
	function checkPsw(){
	var password = document.getElementById("password").value;
	var password2 = document.getElementById("password2").value;
	var span = document.getElementById("psw2");
	span.removeChild(span.firstChild);
	if(password2==""){
		var text = document.createTextNode("密码不能为空");
		span.appendChild(text);
	}else if(password==password2){
		var text = document.createTextNode("密码可用");
		span.appendChild(text);
	}else{
		var text = document.createTextNode("两次密码不同，请再次输入");
		span.appendChild(text);
	}
	}

	function checkPsword(){
	var password = document.getElementById("password").value;
	var span = document.getElementById("psw");
	span.removeChild(span.firstChild);
	if(password==""){
		var text = document.createTextNode("密码不能为空");
		span.appendChild(text);
	}else{
	var text = document.createTextNode("密码可用");
		span.appendChild(text);
	}
	}
	function checkEmail(){
	var email = document.getElementById("email");
		if(email.value!=email.value.match(/^\w +[@]\w +[.][\w])){ 																								
			alert("您的电子邮件格式错误！"); 
			return false; 
		}
		return true;
	}
	</script>-->
	</head>
	<body>
		<div id="div3">
			<span style="font-size: 22px; color: #D2FFEF; font-weight: bold;">为保证会员质量，请填写以下各项资料(必填：用户名，密码，性别，年龄，email)</span>
		</div>
		<div id="wrapper">
      
			<div id="div1">

				<br />
				<form id="regist" action="UserRegistServlet" method="post">		
				<div id="div6">
						<input type="checkbox" name="shiyan" value="shiyan" />
						<span>诚意宣言：我承诺抱着严肃的态度，真诚寻找另一半。</span>
						<span style="color: #FFFFCC; font-size: 20px;"></span>
					</div>
					<table class="table1">
						<tr>
							<td class="dd1">
								用户名：
							</td>
							<td>
								<input type="text" name="username" onblur="sendRequest();" class="input2"
									id="username"/>
								<span style="color: color : #BC1FFF;"></span>
							</td>
							<td>
								<span style="color: #FFFFCC; font-size: 20px;" id="msg">*</span>
							</td>
						</tr>
						<tr>
							<td class="dd1">
								密码：
							</td>
							<td>
								<input type="password" name="password"class="input2" id="password" onblur="checkPsword();" />
							</td>
							<td>
								<span style="color: #FFFFCC; font-size: 20px;" id="psw">*</span>
							</td>
						</tr>
						<tr>
							<td class="dd1">
								确认密码：
							</td>
							<td>
								<input type="password" name="password2" class="input2" id="password2" onblur="checkPsw();" />
							</td>
							<td>
								<span style="color: #FFFFCC; font-size: 20px;" id="psw2">*</span>
							</td>
						</tr>
						<tr>
							<td class="dd1">
								真实姓名：
							</td>
							<td>
								<input type="text" name="realname" class="input2"
									value="" />
							</td>
						</tr>
						<tr>
							<td class="dd1">
								性别：
							</td>
							<td class="dd1">
								男
								<input type="radio" name="sex" value="男" checked="checked"/>
								女
								<input type="radio" name="sex" value="女"style="background-color: #577374"
									<c:if test="">checked="checked"</c:if> />

							</td>
							<td>
								<span style="color: #FFFFCC; font-size: 20px;">*</span>
							</td>
						</tr>
						<tr>
							<td class="dd1">
								年龄：
							</td>
							<td>
								<input type="text" name="age"class="input2" value=""/>
							</td>
							<td>
								<span style="color: #FFFFCC; font-size: 20px;">*</span>
							</td>
						</tr>
						<tr>
							<td class="dd1">
								email：
							</td>
							<td>
								<input type="text" id="email" name="email" class="input2"value="" onblur="checkEmail()"/>
							</td>
							<td>
								<span style="color: #FFFFCC; font-size: 20px;">*</span>
							</td>
						</tr>
						<tr>
							<td class="dd1">
								电话：
							</td>
							<td>
								<input type="text" name="phone"class="input2" value="" />

							</td>
							<td>
								<span style="color: #FFFFCC; font-size: 20px;">*</span>
							</td>
						</tr>
						<tr>

							<td class="dd1">
								选择城市:
							</td>
							<td >
							<%@include file="select_city.jsp" %>
							</td>
						</tr>
						<tr>
							<td class="dd1">
							</td>
							<td>
								<input type="hidden" name="address" class="input2"value="document.getElementByName()" />
							</td>
						</tr>
						<tr>
							<td class="dd1">
								验证码:
							</td>
							<td valign="middle" align="left">
								<input type="text" name="number" class="input2" />
								<span style="color: #FFFFCC; font-size: 20px;"></span>
							</td>

							<td class="dd_next">
								<img id="num" src="image" />
								<a href="javascript:;"
								 id="hh">换一张</a>
							</td>	
							</tr>
							<tr>
						<td/>
						
							<td class="button">
								<input type="submit" value="注册" class="dd2">
							</td>
							<td class="button">
								<a href="login.jsp" class="dd2" style=""> 登录</a>
							</td>
					</table>
				

						
				</form>
				
				
			</div>
		<div id="div2">
			<span style="font-size: 30px; color: #FEFAFA;">不以结婚为目的的恋爱都是耍流氓</span>
		</div>

		</div>

	</body>
</html>