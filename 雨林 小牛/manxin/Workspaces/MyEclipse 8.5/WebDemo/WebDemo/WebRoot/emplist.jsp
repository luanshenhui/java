 <%@ page language="java" import="com.yulin.web.entity.*"
	pageEncoding="utf-8"%>
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
						<p>
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
						Welcome!
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

									<tr class="row">
										<td>

											

										</td>
										<td>
										

										</td>
										<td>
											

										</td>
										<td>
											

										</td>
										<td>
											<a href="delete.do?loginId=${u.loginId }">delete emp</a>&nbsp;
											<a href="toUpdate.do?loginId=${u.loginId}">update emp</a>
										</td>
										</tr>
										
							

								
										<tr class="row">
											<td>

										

											</td>
											<td>
												

											</td>
											<td>
											

											</td>
											<td>
												

											</td>
											<td>
												<a href="delete.do?loginId=${l.loginId }">delete
													emp</a>&nbsp;
												<a href="toUpdate.do?loginId=${l.loginId}">update
													emp</a>
											</td>
										</tr>
							






					</table>
					<p>
						<input type="button" class="button" value="Add Employee"
							onclick="location='addEmp.html'" />
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
