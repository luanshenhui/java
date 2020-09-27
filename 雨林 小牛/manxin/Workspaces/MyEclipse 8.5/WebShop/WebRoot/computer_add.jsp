<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   <meta http-equiv=Content-Type content="text/html; charset=utf-8" />
		<link href="css/main/style.css"
			type="text/css" rel="stylesheet" />
		<script type="text/javascript">
		function imgLook(){
			var file = document.getElementById("imgPath");
			var img = document.getElementById("img");
			img.src = file.value;//图片的路径 等于 文件的路径
		}
		</script>

  </head>
  
  <body topMargin="10">
		<div id="append_parent"></div>
		<table cellSpacing=6 cellPadding=2 width="100%" border="0">
			<tbody>
				<tr>
					<td>
						<table class="guide" cellSpacing="0" cellPadding="0" width="100%"
							border="0">
							<tbody>
								<tr>
									<td>
										<a href='#'>主页</a>&nbsp;/&nbsp;
										<a href='#'>笔记本订购</a>&nbsp;/&nbsp;商品添加
										<a href='#'>|管理商品|</a>
									</td>
								</tr>
							</tbody>
						</table>
						<br />
						<form action="add.do" method="post" enctype="multipart/form-data">
						<center>
							<table>
							<tr>
							<td>商品名称：</td>
							<td><input name="name"/></td>
							</tr>
							<tr>
							<td>商品说明：</td>
							<td><input name="descript"/></td>
							</tr>
							<tr>
							<td>商品价格：</td>
							<td><input name="price"/></td>
							</tr>
							<tr>
							<td>商品图片：</td>
							<td><input type="file" id="imgPath" name="imgPath" onchange="imgLook();"/></td>
							</tr>
							<tr>
							<td colspan="2">
							<img alt="商品图片" id="img"/>
							</td>
							
							</tr>
							</table>
						<br />
						
						<input type="submit" value="确认添加" class="button"/> &nbsp; &nbsp; &nbsp; &nbsp; 
						<input type="button" value="返回" class="button" onclick="computer_list.jsp"/>
						</center>
						</form>
						
					</td>
				</tr>
			</tbody>
		</table>

	</body>
</html>
