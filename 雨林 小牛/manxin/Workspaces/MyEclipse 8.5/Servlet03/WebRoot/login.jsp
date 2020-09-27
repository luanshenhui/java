<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>login</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css"
			href="css/style.css" />
	
  </head>
  
  <body>
   <div id="wrap">
			<div id="top_content">
					<div id="header">
						<div id="rightheader">
							<p> 
								me2009/11/20 
								<br />
							</p>
						</div>
						<div id="topheader">
							<h1 id="title">
								<a href="#">main</a>
							</h1>
						</div>
						<div id="navigation">
						</div>
					</div>
				<div id="content">
					<p id="whereami">
					</p>
					<h1>
						login
					</h1>
					<form action="login.do" method="post">
						<table cellpadding="0" cellspacing="0" border="0"
							class="form_table">
							<tr>
								<td valign="middle" align="right">
									username:
								</td>
								<td valign="middle" align="left">
									<input type="text" class="inputgri" name="name" id="name"
									 onblur=""/>
								</td>
							</tr>
							<tr>
								<td valign="middle" align="right">
									password:
								</td>
								<td valign="middle" align="left">
									<input type="password" class="inputgri" name="pwd" id="pwd"/>
									<%String msg = (String)request.getAttribute("login_error"); %>
									<span style="color: red;"><%=(msg == null ? "" : msg) %></span>
								</td>
							</tr>
							<tr>
							
							<%
								String msg2 = (String)request.getAttribute("number_error");
							 %>
							
							<td valign="middle" align="right">
								<a href="javascript:;" onclick="document.getElementById('num').src = 'image?' + Math.random();">
								<img id="num" src="image"/>
								</a>
							</td>
							<td valign="middle" align="left">
								<input type="text" name="code" class="inputgri"/>
							 	<br/>
							<span style="color: red;">
									<%=(msg2 == null ? "" : msg2) %>
							</span>
							</td>
							</tr>
						</table>
						<p>
							<input type="submit" class="button" value="Submit" />
							<input type="button" class="button" value="注   册" onclick="javascript:;location.href='regist.jsp'"/>
						</p>
						</form>
				</div>
			</div>
			<div id="footer">
				<div id="footer_bg">
					ABC@126.com
				</div>
			</div>
		</div>
						
  </body>
</html>
