<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="entity.*,java.lang.*"%>
<%@ page import="entity.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>emplist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="css/style.css" />
	</head>
	<body>
	<c:if test="${emp == null}">
		<c:redirect url="login.jsp"></c:redirect>
	</c:if>
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
								Age
							</td>
							<td>
								Salary
							</td>
							<td>
								Operation
							</td>
						</tr>
					<c:forEach items="${list}" var="list">
						<tr class="row">
							<td>
							${list.d_id }
							</td>
							<td>
							${list.d_name }

							</td>
							<td>
								${list.d_age }

							</td>
							<td>
								${list.d_salary }

							</td>
							<td>
								<a href="delete.do?loginId=${list.d_id }">delete emp</a>&nbsp;
								<a href="toUpdate.do?loginId=${list.d_id }">update emp</a>
							</td>
							</tr>
						</c:forEach>	
					</table>
					<h2>
						<c:choose>
							<c:when test="${pages > 1}">
								<a href="list.do?pages=${pages - 1}">上一页</a>
							</c:when>
							<c:otherwise>
								上一页
							</c:otherwise>
						</c:choose>
						第${pages}页
						<c:choose>
							<c:when test="${pages < totalPages}">
								<a href="list.do?pages=${pages + 1}">下一页</a>
							</c:when>
							<c:otherwise>
								下一页
							</c:otherwise>
						</c:choose>
						总共${totalPages}页
					</h2>
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

