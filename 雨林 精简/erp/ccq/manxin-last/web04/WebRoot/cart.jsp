<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv=Content-Type content="text/html; charset=utf-8" />
		<link href="css/main/style.css"
			type="text/css" rel="stylesheet" />
	</head>

	<body topMargin="10">
		<div id="append_parent"></div>
		<table cellSpacing="6" cellPadding="2" width="100%" border="0">
			<tbody>
				<tr>
					<td>
						<table class="guide" cellSpacing="0" cellPadding="0" width="100%"
							border="0">
							<tbody>
								<tr>
									<td>
										<a href='#'>主页</a>&nbsp;/&nbsp;
										<a href='computer_list.html'>笔记本订购(WEB007)</a>&nbsp;/&nbsp;购物车信息
									</td>
								</tr>
							</tbody>
						</table>
						<br />



						<table class="tableborder" cellSpacing="0" cellPadding="0"
							width="100%" border="0">
							<tbody>
								<tr class="header">
									<td class="altbg2" colspan="6">
										购物车信息
									</td>
								</tr>
							<tbody>
								<tr>
									<td class="altbg1" width="20%">
										<b>型号</b>
									</td>
									<td class="altbg1" width="20%">
										<b>价格</b>
									</td>
									<td class="altbg1" width="10%">
										<b>数量</b>
									</td>
									<td class="altbg1" width="30">
										&nbsp;
									</td>
									<td class="altbg1" width="10%">
										&nbsp;
									</td>
									<td class="altbg1">
										&nbsp;
									</td>
								</tr>
							</tbody>
							
							<tbody>
								<tr>
									<td class="altbg2">
										x200
									</td>
									<td class="altbg2">
										20000
									</td>
									<td class="altbg2">
										1
									</td>
										<form action="updateNum.do?name=<%= %>" id="f<%=%>">
									<td class="altbg2">
										<input type="text" size="3" value=""
											id="" />
									</td>
									<td class="altbg2">
										<a href="javascript:;" onclick="document.getElementById('f<%=%>').submit()">更改数量</a>
									</td>
										</form>
									<td class="altbg2">
										<a href="">删除</a>
									</td>
								</tr>
								<tr>
									<td class="altbg1" colspan="6">
										<b>总价格：￥20000</b>
									</td>
								</tr>
							</tbody>
						
							<tr>
								<td class="altbg2" colspan="6">
									<b>还没有选购商品</b>
								</td>
							</tr>
						
						</table>

						<br />
						<center>
							<input class="button" type="button" value="返回商品列表"
								name="settingsubmit" onclick="location = 'computer_list.html';">
							<input class="button" type="button" value="清空购物车"
								name="settingsubmit"
								onclick="location = '#';">
						</center>
					</td>
				</tr>
			</tbody>
		</table>

	</body>
</html>



