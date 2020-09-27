<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>updateLog</title>
		<link rel="stylesheet" type="text/css" href="css/writelog.css" />
			<style>
		.form{
		width:800px;
		margin-top:-100px;
		margin-left:-20px;
			border:2px solid;color: #CCCCFF;
			font-size:15pt;
			color:#E6CCFF;
		}
	</style>
	<script type="text/javascript">
	function changeimg(){
	var img = document.getElementById("num");
	img.src = "image"+new Date().getTime();
	}
	</script>
	</head>
	<body>
		<div id="wholepage">
			<div>
				<%@include file="plugin/head.jsp"%><br/>
			</div>
			<div class="item_tmp">
				<form action="updateLog?id=${dia.diaryID}" method="post" class="form">
					<table border=0 cellSpacing=7 cellPadding=10 width="100%">
						<tr id="Ttitle">
							<td>
								题 目：
							</td>
							<td>
								<input type="text" name="title" value="${dia.diaryTitle}"/>
							</td>
						</tr>
						<tr>
							<td>
								正 文：
							</td>
							<td id="content">
								<textarea name="content">${dia.diaryContent}</textarea>
							</td>
						</tr>
						<tr>
							<td>
								验证码：
							</td>
							<td>
								<img id="num" src="image" />
									<a href="javascript:;"onclick="changeimg();">看不清？</a>
								<input type="text" name="number" />
						</tr>
						<tr>
							<td>
								<input class="button" type="submit" value="提交">
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div>
				<%@include file="plugin/foot.jsp"%>
			</div>
		</div>
	</body>
</html>