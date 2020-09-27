<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<style>
		.form{
		width:800px;
		margin-top:-100px;
		margin-left:-20px;
			border:2px solid;color: #CCCCFF;
			font-size:15pt;
			color:#E6CCFF;
		}
		#div_head{
			font-size:15pt;
			text-decoration:underline;
			color:#CFFEF4;
			margin-left:150pt;
			margin-top: -10pt;
		}
	</style>
	<script type="text/javascript">
	function changeimg(){
	var img = document.getElementById("num");
	img.src = "image"+new Date().getTime();
	}
	</script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>writelog</title>
		<link rel="stylesheet" type="text/css" href="css/writelog.css" />
	</head>
	<body>
		<div id="wholepage">
			<div>
				<%@include file="plugin/head.jsp"%><br/>
			</div>
			<div id=div_head><br/><br/>在这里，留下你的心情和感受，留下一个真实的你.....</div>
			<div class="item_tmp">
				<form action="writelog" method="post" class="form">
				<div style="margin-left:500px;">
							</div>
					<table border=0 cellSpacing=5 cellPadding=5 width="100%">
						<tr id="Ttitle">
							<td>
								题 目：
							</td>
							<td>
								<input type="text" name="title" value="${diary.diaryTitle}"></input>
							</td>
						</tr>
						<tr>
							<td>
								正 文：
							</td>
							<td id="content">
								<textarea name="content">${diary.diaryContent}</textarea>
							</td>
							
						</tr>
						<tr>
							<td>
								验证码：
							</td>
							<td>
								<img id="num" src="image" />
									<a href = "javascript:;" onclick="changeimg();">看不清？</a>
								<input type="text" name="number" />
								</td>
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