<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		
		<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
		<script type="text/javascript">
			$(function(){
				$("#words_input1001").click(function(){
					$("#words_input1001").css("background-color","#000000");
				});
				$("#words_input1001").focusout(function(){
					$("#words_input1001").css("background-color","#000000");
						$("#words_input1001").css("background","url()");
				});
				
				$("#words_input1002").click(function(){
					$("#words_input1002").css("background-color","#ffffff");
				});
				$("#words_input1002").focusout(function(){
					$("#words_input1002").css("background-color","#cdcdcd");
				});
			});
		</script>
		<style  type="text/css">
			.foot{
				margin:50px 100px 150px 100px;
			}
			#word_body{
				background:  #000000;
			}
			#word_head{
				margin: 20px 0 0  0;
			}
			#word_tbody1 {
				font-size:15pt;
				font: red;
				border:solid #7BC5EA 1px;
			}
			.word_form{
			border:solid #7BC5EA 1px;
			}
			.word_item_tmp {
				font-size:15pt;
				color:#FFFFFF;
				width:600pt;
				font-weight:bold;
				margin:50px auto 100px auto;
				font:#FFFFFF;
				background:url(images/a1.jpg);
			}
			#word_leave_content textarea{
				font-size:15pt;
				WIDTH: 620px;
				HEIGHT: 155px;
				font-weight: bold;
				border:solid #7BC5EA 1px;
				font:#FFFFFF;
				background-color:#DCDCDC;
				color:#ffffff;
			}
			#word_vercode input{
				font-size:15pt;
				border:solid #7BC5EA 1px;
				color:#FFFFFF;
				font:#F6F4F2;
			}
			#word_tr4 .word_input3{
				border:solid #7BC5EA 1px;
				font-size: 17pt;
				background-color:#000000;
				color:#FFE6CC;
				font-weight: bold;
			}
			#word_tr3 .word_input2{
				border:solid #7BC5EA 1px;
				background-color:#DCDCDC;
				color:#000000;
				font-size:15pt;
				width:100px;
				font-weight: bold;
			}
			#word_tr3 .word_td1 a{
				color:#E1FCFA;
				width: 90px;
				font-weight: bold;
				text-decoration:none;
				font-size: 15pt;
			}
			#word_tr3 .word_td1 a:HOVER{
				color:#BC1FFF;
				font-size: 15pt;
			}
		</style>
	</head>
	
	<body id="word_body">
		<div id="word_head">
		<jsp:include page="plugin/head.jsp"/>
			</div>
			<DIV class="word_item_tmp">
				<div>留言板</div>
				<form action="sendLeaveWordServlet" method="post" class="word_form">
					<input type="hidden" name="toid" value="${toid}">
					<table cellSpacing=5 cellPadding=0 width="100%">
						<tbody id="word_tbody1">
							<tr id="word_tr1">
								<td>&nbsp;</td>
							</tr>
							<tr id="word_tr2">
								<td id=reTitle class=f14>内 容：</td>
								<td id="word_leave_content">
									<textarea name="content" id="words_input1001" class="word_input1" >${sendLeavewordForm.content}</textarea>
								</td>
							</tr>
							<tr id="word_tr3">
								<td class=f14 vAlign=top>验证码：</td>
								<td class="word_td1">
									
									<input type="text" id="words_input1002"name="checkcode" class="word_input2"/>
									<img id="num" src="image" />
									<a href="javascript:;"
										onclick="document.getElementById('num').src ='image?'+(new Date()).getTime()">
										<span style="font-size: 12pt;"> 换一张</span>
									</a>
									<span style="color: #FFFFCC; font-size: 10pt;"> 字母不区分大小写 </span>
									<br />
								</td>
							</tr>
							<tr id="word_tr4">
								<td>&nbsp;</td>
								<td><input class="word_input3" value="添加留言" type="submit"></td>
							</tr>
						</tbody>
					</table>
				</form>
		</DIV>
		<div  class="foot">
			<jsp:include page="plugin/foot.jsp"/>
		</div>
	</body>

</html>