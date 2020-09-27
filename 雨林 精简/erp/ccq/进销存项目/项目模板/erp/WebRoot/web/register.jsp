<%@ page contentType="text/html; charset=UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
	<head>
	    <base href="<%=basePath%>">
		<!-- 标题在这里设定 -->
		<title>注册界面</title>
		<link rel="stylesheet" rev="stylesheet"
			href="web/css/style.css" type="text/css" />


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
	<img src="/erp/web/img/start.gif"/>&nbsp;注册一个系统用户
	<% if (request.getAttribute("username_phone_email_error") != null) { %>
		<font color="red"><%=request.getAttribute("username_phone_email_error")%></font>
	<% } %>
</div>

<div class="conceptBlockConcept">


		<table border="0" width=100% height=100%>
			<tr>
				<td valign="middle"><!-- 调用通用验证函数checkForm --> <form
					action="/erp/register" onsubmit="return check();" method="post">
					<table class="block" cellspacing="1" cellpadding="0"
						bgcolor="#f7f7f7" align="center">
						<tr height="30">
							<td colspan="4" bgcolor="#d6e0ef">&nbsp;<font face=webdings
								color=#ff8c00>8</font><b>&nbsp;您很快将成为本系统的一员</b></td>
						</tr>
						<tr height="20">
							<td bgcolor="#f7f7f7" width="200" align="right"></td>
							<td bgcolor="#f7f7f7" align="left">
							<div id="msg">

							</div>
							</td>
						</tr>

									<tr height="40">
										<td width="200" align="right">
											用户名：
										</td>
										<td align="left">
											<input id="username" name="username" type="text" size="16"
												maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" />
											<font color=red>&nbsp;(必填)</font>
										</td>
									</tr>

									<tr height="40">
										<td width="200" align="right">
											密码：
										</td>
										<td align="left">
											<input id="password" name="password" type="password"
												size="16" maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" />
											<font color=red>&nbsp;(必填)</font>
											<span id="pswdMsg" class="feedbackHide">请填入一到十位的密码</span>
										</td>
									</tr>

									<tr height="40">
										<td width="200" align="right">
											再次输入密码：
										</td>
										<td align="left">
											<input id="repassword" name="repassword" type="password"
												size="16" maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" />
											<font color=red>&nbsp;(必填)</font>
										</td>
									</tr>

									<tr height="40">
										<td width="200" align="right">
											性别：
										</td>
										<td align="left">
											<input id="sex" type="radio" name="sex" size="16"
												maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" checked value="男"/>
											男
											<input type="radio" name="sex" size="16" maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" value="女"/>
											女
											<font color=red>&nbsp;(必填)</font>
										</td>
									</tr>


									<tr height="40">
										<td width="200" align="right">
											年龄：
										</td>
										<td align="left">
											<input id="age" name="age" type="text" size="16"
												maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" /><font color=red>&nbsp;(必填)</font>
											<span id="ageerr"></span>
										</td>
									</tr>


									<tr height="40">
										<td width="200" align="right">
											电子邮件：
										</td>
										<td align="left">
											<input id="email" name="email" type="text" size="32"
												maxlength="32"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" />
											<font color=red>&nbsp;(必填)</font>
											<span id="emailerr"></span>
										</td>
									</tr>

									<tr height="40">
										<td width="200" align="right">
											移动电话：
										</td>
										<td align="left">
											<input id="phone" name="phone" type="text" size="16"
												maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" /><font color=red>&nbsp;(必填)</font>
												<span id="phoneerr"></span>
										</td>
										
									</tr>

									<tr height="40">
										<td width="200" align="right">
											工资金额：
										</td>
										<td align="left">
											<input id="salary" name="salary" type="text" size="16"
												maxlength="16"
												onfocus="this.style.backgroundColor='#e6e6e6'"
												onblur="this.style.backgroundColor='#ffffff'" />
											<font color=red>&nbsp;(必填)</font>
										</td>
									</tr>

									<tr height="40">
										<td width="200" align="right"></td>
										<td align="left">
											<input type="submit" value="注册" />
										</td>
									</tr>

									<tr height="40">
										<td width="200" align="right"></td>
										<td align="left">
											点击
											<a href='web/login.jsp'>这里</a>返回登录页面
										</td>
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