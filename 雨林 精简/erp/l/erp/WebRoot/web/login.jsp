<%@ page contentType="text/html; charset=UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
<base href="<%=basePath%>">
<!-- 标题在这里设定 -->
<title>
登陆界面
</title>
<link rel="stylesheet" rev="stylesheet" href="web/css/style.css" type="text/css" />

<script type="text/javascript" src="web/js/jquery-1.9.1.js"></script>

<script type="text/javascript">

$(function(){

$("#ajax").click(function(){
//使用jQuery框架来实现异步通信
   $.ajax({
      type:'post',
      url:'/erp/ajax',
      data:encodeURI(encodeURI("username="+$("#username").val(),"UTF-8"),"UTF-8"),
      dataType:'text',
      success:function(msg){$("#info").html(msg);}
   });
});
});

</script>

</head>

<body bgcolor="#cccccc">

	<div id="bodyDiv">
		<div id="headerLink">
			<!-- 页眉的上部链接部分 -->
			<jsp:include page="/web/page/branch/headerLink.jsp" /> 
		</div>
		<div id="header">
			<!-- 页眉 -->
			<jsp:include page="/web/page/branch/header.jsp" /> 
		</div>
		<div id="menubarBlank">
			<!-- 横向菜单栏下部的粉红留空区域 -->
			<jsp:include page="/web/page/branch/menubarBlank.jsp" /> 
		</div>
		<div id="content">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" style="table-layout:fixed;word-wrap:break-word;word-break;break-all;">
				<tr>	
					<td valign="top">
						<!-- 内容区域 -->	
						<div id="conceptDiv">		
							

<div class="conceptBlockTitle">
	<img src="/erp/web/img/start.gif"/>&nbsp;登陆系统
	
	<% if (request.getAttribute("login_error") != null) { %>
		<font color="red"><%=request.getAttribute("login_error")%></font>
	<% } %>
	
	<% if (request.getAttribute("success") != null) { %>
		<b><%=request.getAttribute("success")%></b>
	<% } %>
	
</div>

<div class="conceptBlockConcept">

		<table border="0" width=100% height=100%>
			<tr>
				<td valign="middle">
				<form action="/erp/login" method="post" onsubmit="return check()">
					<table class="block" cellspacing="1" cellpadding="0"
						bgcolor="#f7f7f7" align="center">
						<tr height="30">
							<td colspan="4" bgcolor="#d6e0ef">&nbsp;<font face=webdings
								color=#ff8c00>8</font><b>&nbsp;欢迎登录本系统</b></td>
						</tr>
						<tr height="20">
							<td bgcolor="#f7f7f7" width="200" align="right"></td>
							<td bgcolor="#f7f7f7" align="left">
							<div id="msg">

							</div>
							</td>
						</tr>
						<% if((request.getAttribute("false")!=null)){ %>
<%=request.getAttribute("false")%>
<%} %>
        <% if((request.getAttribute("ok")!=null)){ %>
<%=request.getAttribute("ok")%>
<%} %>
						<tr height="40">
							<td bgcolor="#f7f7f7" width="200" align="right">用户名</td>
							<td bgcolor="#f7f7f7" align="left"><input id="username" type="text"
								name="username" size="16" maxlength="16"
								onfocus="this.style.backgroundColor='#e6e6e6'"
								onblur="this.style.backgroundColor='#ffffff'" /> <font color=red>&nbsp;(必填)</font>
								
								<input  type="button" value="检查有无此用户" id="ajax"/>
								
								<span id="info"></span>
								
							<span id="nameMsg" class="feedbackHide">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>
						</tr>

						<tr height="40">
							<td bgcolor="#f7f7f7" width="200" align="right">密码</td>
							<td bgcolor="#f7f7f7" align="left"><input id="password" type="password"
								name="password" size="16" maxlength="16"
								onfocus="this.style.backgroundColor='#e6e6e6'"
								onblur="this.style.backgroundColor='#ffffff'" /> <font color=red>&nbsp;(必填)</font>
							<span id="pswdMsg" class="feedbackHide">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</span></td>
						</tr>

						<tr height="40">
							<td bgcolor="#f7f7f7" width="200" align="right"></td>
							<td bgcolor="#f7f7f7" align="left"><input type="submit" value="登录系统" /></td>
						</tr>

						<tr height="40">
							<td bgcolor="#f7f7f7" width="200" align="right"></td>
							<td bgcolor="#f7f7f7" align="left">如无用户点击<a
								href='web/register.jsp'>这里</a>注册</td>
						</tr>
					</table>
					<br />
				</form></td>
			</tr>
		</table>


</div>


						</div>		
					</td>
				</tr>
			</table>
		</div>
		<div id="footer">
			<!-- 页脚 -->
			<jsp:include page="/web/page/branch/footer.jsp" /> 
		</div>		
	</div>
	
</body>
</html>