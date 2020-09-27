<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%request.setCharacterEncoding("utf-8"); %>
<html>
	<head>
		<title>用户信息管理</title>
		<style type="text/css">
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}

.STYLE1 {
	font-size: 12px
}

.STYLE4 {
	font-size: 12px;
	color: #1F4A65;
	font-weight: bold;
}

a:link {
	font-size: 12px;
	color: #06482a;
	text-decoration: none;
}

a:visited {
	font-size: 12px;
	color: #06482a;
	text-decoration: none;
}

a:hover {
	font-size: 12px;
	color: #2BC1E3;
	text-decoration: underline;
}

a:active {
	font-size: 15px;
	color: #FF0000;
	text-decoration: none;
}

.aee {
	width: 19%;
	height: 18%;
	background: url(images/tab_14.gif);
	font-size: 18px;
	font-family: serif;
}

.aoo {
	height: 18px; align ="center";
	font-size: 15px;
	font-family: sans-serif;
	background-color: #FFFFFF;
}

.STYLE7 {
	font-size: 12
}
</style>

		<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
		<script type="text/javascript">
		function confirm(r){
		alert(r);
		}
		</script>
	</head>

	<body>
	<h1 style="color: green;">${admin.adminName},欢迎你的到来。</h1>
		<table width="100%" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td height="30">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="15" height="30">
								<img src="images/tab_03.gif" width="15" height="30" />
							</td>
							<td width="1101" background="images/tab_05.gif">
								<img src="images/311.gif" width="16" height="16" />
								<span class="STYLE4">所有用户信息 </span>
							</td>

							<td width="14">
								<img src="images/tab_07.gif" width="14" height="30" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>

							<td width="9" background="images/tab_12.gif">
								&nbsp;
							</td>
							<td bgcolor="#f3ffe3">
								<table width="99%" border="0" align="center" cellpadding="0"
									cellspacing="1" bgcolor="#c0de98" onmouseover="changeto()"
									onmouseout="changeback()">
									<tr class="aee">
										<td>
											ID
										</td>
										<td>
											UserName
										</td>
										<td>
											RealName
										</td>
										<td>
											Sex
										</td>
										<td>
											Age
										</td>
										<td>
											City
										</td>
										<td>
											Email
										</td>
										<td>
											用户状态
										</td>
										<td>
											管理
										</td>
										<td>
											删除
										</td>
									</tr>
									<c:forEach var="u" items="${us}">
									<tr class="aoo">
										<td>${u.userID}</td>
										<td>${u.name}</td>
										<td>${u.trueName}</td>
										<td>${u.sex}</td>
										<td>${u.age}</td>
										<td>${u.address}</td>
										<td>${u.email}</td>
										<c:if test="${u.istrue==false}">
										<td>
											未登入
										</td></c:if>
										<c:if test="${u.istrue==true}">
										<td>
											已登入
										</td></c:if>
				
										<td>&nbsp;<!--  <a href="forstUser.do?id="
												onclick="confirm('是否冻结');">冻结用户</a>/
											<a href="deforstUser.do?id="
												onclick="confirm('是否真的解冻');">解冻</a>-->
										</td>
										<td>
											<img src="images/010.gif" width="9" height="9" />
											<span class="STYLE1">[</span><a
												href="deleteUser?id=${u.userID}"
												onclick=" return confirm('是否确认删除'); ">删除</a><span
												class="STYLE1">]</span>
										</td>
									</tr>
									</c:forEach>
								</table>
							</td>
							<td width="9" background="images/tab_16.gif">
								&nbsp;
							</td>

						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td height="29">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="15" height="29">
								<img src="images/tab_20.gif" width="15" height="29" />
							</td>
							<td background="images/tab_21.gif">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="25%" height="29" nowrap="nowrap">
											<span class="STYLE1">共${all} 条纪录，当前第${page+1}/${s}页，每页10条纪录</span>
										</td>
										<td width="75%" valign="top" class="STYLE1">
											<div align="right">
												<table width="352" height="20" border="0" cellpadding="0"
													cellspacing="0">
													<tr>
														<td width="62" height="22" valign="middle">
															<div align="right">
																<a href="showAllUser?pageIndex=0&pageSize=10"><img
																		src="images/first.gif" width="37" height="15" /> </a>
															</div>
														</td>
														<c:if test="${page==0}">
														<td width="50" height="22" valign="middle">
															<div align="right">
																<img
																		src="images/back.gif" width="43" height="15" />
															</div>
														</td></c:if>
														<c:if test="${page!=0}">
														<td width="50" height="22" valign="middle">
															<div align="right">
																<a href="showAllUser?pageIndex=${page-1}&pageSize=10"><img
																		src="images/back.gif" width="43" height="15" /> </a>
															</div>
														</td></c:if>
														<c:if test="${page==(s-1)}">
														<td width="54" height="22" valign="middle">
															<div align="right">
																<img
																		src="images/next.gif" width="43" height="15" /> 
															</div>
														</td></c:if>
														<c:if test="${page!=(s-1)}">
														<td width="54" height="22" valign="middle">
															<div align="right">
																<a href="showAllUser?pageIndex=${page+1}&pageSize=10"><img
																		src="images/next.gif" width="43" height="15" /> </a>
															</div>
														</td></c:if>
														<td width="49" height="22" valign="middle">
															<div align="right">
																<a href="showAllUser?pageIndex=${s-1}&pageSize=10"><img
																		src="images/last.gif" width="37" height="15" /> </a>
															</div>
														</td>

														<td width="59" height="22" valign="middle">
															<div align="right" class="STYLE1">
																转到第
															</div>
														</td>
														<td width="25" height="22" valign="middle">
															<span class="STYLE7"> <span> <input
																		name="page" type="text" id="Num" class="STYLE1"
																		style="height: 20px; width: 25px;" size="5" /> </span>
														</td>
														<td width="23" height="22" valign="middle" class="STYLE1">
															页
														</td>
														<td width="30" height="22" valign="middle">
															<a href="javascript:;"
																onclick="location='showAllUser?pageIndex='+document.getElementById('Num').value&pageSize=10"><img
																	src="images/go.gif" width="37" height="15" /> </a>
														</td>
													</tr>
												</table>

											</div>
										</td>
									</tr>
								</table>
							</td>
							<td width="14">
								<img src="images/tab_22.gif" width="14" height="29" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="right">
					<!--  <form action="findStatusUser.do" method="post">
						<span style="font-size: 12px;color:#B0A5B8 ">用户状态：</span>
						<select id="statu" name="statu">
							<option value="在线">
								在线
							</option>
							<option value="未登入">
								未登入
							</option>
							<option value="已冻结">
								已冻结
							</option>
						</select>
						<input type="submit" value="查询">
					</form>-->
				</td>
			</tr>
		</table>
	</body>
</html>

