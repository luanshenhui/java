<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<meta http-equiv=Content-Type content="text/html; charset=utf-8" />
		<link href="css/main/style.css"
			type="text/css" rel="stylesheet" />
		<script type="text/javascript">
			function imgLook(){
				var file = document.getElementById("imgPath");
				var img = document.getElementById("img");
				img.src=file.value; //
				alert(img.src);
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
										<a href='#'>笔记本订购</a>&nbsp;/&nbsp;商品添加 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
										<a href='#'>|管理商品|</a>
									</td>
								</tr>
							</tbody>
						</table>
						<br />
						<form action="add.do" method="post" enctype="multipart/form-data">
							<center>
							<table>
								<tr>
									<td>商品名称</td>
									<td><input name="name"/></td>
								</tr>
								<tr>
									<td>商品说明</td>
									<td><input name="descript"/></td>
								</tr>
								<tr>
									<td>商品价格</td>
									<td><input name="price" /></td>
								</tr>
								<tr>
									<td>商品图片</td>
									<td>
										<input type="file" name="imgPath" 
											id="imgPath" onchange="imgLook();"
										/>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<img alt="图片" id="img">
									</td>
								</tr>
							</table>
							<br />
								<input type="submit" value="提交" class="button"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="button" value="返回" class="button">
							</center>
						</form>
					</td>
				</tr>
			</tbody>
		</table>

	</body>
</html>