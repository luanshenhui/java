<%@ page language="java" import="com.yulin.web.entity.*" pageEncoding="utf-8" %>
<%@ page language="java" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>emplist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="css/style.css" />
	</head>
	<body>
		<div id="wrap">
			<div id="top_content"> 
				<div id="header">
					<div id="rightheader">
						<p>&nbsp; 
							2009/11/20 
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
						Welcome! ${user.name}
						<% 
							ArrayList<User> list = (ArrayList<User>)request.getAttribute("list"); 
						%>
					</h1>
					<table class="table">
						<tr class="table_header">
							<td>
								ID
							</td>
							<td>
								Name
							</td>
							<td>
								Salary
							</td>
							<td>
								Age
							</td>
							<td>
								Operation
							</td>
						</tr>
						<%for(int i = 0; i < list.size(); i++){ 
							User u = list.get(i);
						%>
						<tr class="row<%=(i%2+1) %>">
							<td>
								<%=u.getLoginId() %>
							</td>
							<td>
								<%=u.getName() %>
							</td>
							<td>
								<%=u.getSalary() %>
							</td>
							<td>
								<%=u.getAge() %>
							</td>
							<td>
								<a href="emplist.html">delete emp</a>&nbsp;<a href="toUpdate.do?loginId=<%=u.getLoginId() %>">update emp</a>
							</td>
						</tr>
						<%} %>
					</table>
					<p>
						<input type="button" class="button" value="Add Employee" onclick="location='addEmp.html'"/>
					</p>
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
