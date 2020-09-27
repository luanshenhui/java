<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="entity.User"%>
<%request.setCharacterEncoding("utf-8");
response.setCharacterEncoding("utf-8");
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<style  type="text/css">
#word_body{
	background:  #000000;
}
#word_head{
	margin: 5px 0 0  0;
}
#word_tbody1 {
	font-size:15pt;
	font: red;
	border:solid #7BC5EA 1px;
}
.word_form{
border:solid #CCCCFF 1px;
}
.word_item_tmp {
	font-size:15pt;
	color:#FFFFFF;
	width:600pt;
	font-weight:bold;
	margin:100px auto 100px auto;
	font:#FFFFFF;
}

#word_leave_content textarea{
	font-size:15pt;
	WIDTH: 620px;
	HEIGHT: 50px;
	border:solid #7BC5EA 1px;
	font:#FFFFFF;
	
}
#word_vercode input{
	font-size:15pt;
	border:solid #7BC5EA 1px;
	color:#FFFFFF;
	font:#F6F4F2;
			
}
#word_tr4 .word_input3{
	border:solid #7BC5EA 1px;
	font-size: 13pt;
	background-color:#D4EAE7;
	color:#BC1FFF;
}
#word_tr3 .word_input2{
	border:solid #7BC5EA 1px;
}
#word_tr3 .word_td1 a{
	color:#BC1FFF;
	width: 90px;
	font-weight: bold;
	text-decoration:none;
}
#word_tr3 .word_td1 a:HOVER{
	color:#BE2519;
}
</style>
	</head>

	
	<body id="word_body">
		<div id="word_head">
		</div>
		<DIV class="word_item_tmp">
				<div>日志评论</div>
				<form action="writeLogReview?id=${dia.diaryID}" method="post" class="word_form">
					<input type="hidden" name="toid" value="">
					<table cellSpacing=5 cellPadding=0 width="100%">

						<tbody id="word_tbody1">
							<tr id="word_tr2">
								<td id=reTitle class=f14>
									内 容：
								</td>
								<td id="word_leave_content">
									<textarea name="content" class="word_input1" >${r}</textarea>
								</td>
							</tr>

							<tr id="word_tr3">
								<td class=f14 vAlign=top>
									验证码：
								</td>
	
								<td class="word_td1">
									<img id="num" src="image" />
									<a href="javascript:;"
										onclick="document.getElementById('num').src ='image?'+(new Date()).getTime()">换一张</a>
									<input type="text" name="number" class="word_input2"/>
									<span style="color: red; font-size: 10pt;"></span>
									<br />
								</td>
									

							</tr>
							<tr id="word_tr4">
								<td>
									&nbsp;
								</td>
								<td>
									<input class="word_input3" value="提交评论" type="submit">
								</td>
							</tr>
						</tbody>

					</table>
				</form>
			
		</DIV>
		

	</body>

</html>