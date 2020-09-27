<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style type="text/css">
body {
	color: #CCFFFF;
}

#readlog {
	margin: 110px 180pt 5pt 180pt;
	font-size: 17pt;
	font-weight: bold;
}

#wholepage {
	background: url(img/logread.jpg) no-repeat;
}

.STYLE1 {
	font-size: 10px;
}

.STYLE7 {
	font-size: 10px
}

#words {
	margin: 50px 100px 100px 100px;
}

.words_user_name {
	font-size: 15pt;
	font-weight: bold;
	color: #FAD8CC;
	text-decoration: none;
}

.words_user_name:HOVER {
	font-size: 15pt;
	font-weight: bold;
	color: #BE2519;
	text-decoration: none;
}

.words_time {
	color: #AACCDD;
	font-size: 11pt;
}

.words_table1 #words_tr1 {
	width: 930px;
	color: #C6DDDA;
}

.words_table1 #words_tr2 {
	font-size: 12pt;
	width: 930px;
	color: #7BC5EA;
}

.words_table1 .words_td1 {
	position: top;
	width: 50px;
}

.words_table1 .words_content {
	color: #AACCDD;
	font-size: 14pt;
}

.words_table2 .words_content {
	color: #AACCDD;
	font-size: 13pt;
}

.words_table1 #words_td2 {
	width: 810px;
	font-size: 12pt;
}

.words_table1 #words_td3 {
	width: 40px;
	font-size: 12pt;
}

.words_table1 #words_td4 {
	width: 90px;
}

.words_table1 #words_td4 a {
	width: 80px;
	font-size: 11pt;
	font-weight: bold;
	color: #9FAF8B;
	text-decoration: none;
}

.words_table1 #words_td4 a:HOVER {
	color: #BE2519;
}

.words_table2 #words_tr1 {
	width: 900px;
	color: #C6DDDA;
}

.words_table2 #words_tr2 {
	font-size: 10pt;
	width: 900px;
	color: #7BC5EA;
}

.words_table2 #words_td1 {
	width: 30px;
	font-size: 10pt;
}

.words_table2 #words_td2 {
	width: 820px;
	font-size: 10pt;
}

.words_table2 #words_td3 {
	width: 90px;
	font-size: 10pt;
}

.words_table2 #words_td3 a {
	width: 90px;
	font-size: 11pt;
	font-weight: bold;
	color: #9FAF8B;
	text-decoration: none;
}

.words_table2 #words_td3 a:HOVER {
	color: #BE2519;
}

.words_table3 #words_td1 {
	width: 800px;
	font: red;
	border: red;
	font-size: 10pt;
}

.words_table3 .words_input1 {
	font-size: 15pt;
	WIDTH: 720px;
	HEIGHT: 45px;
	border: solid #7BC5EA 1px;
	font: #FFFFFF;
}

.words_table3 .words_input2 {
	font-size: 13pt;
	border: solid #7BC5EA 1px;
	background-color: #D4EAE7;
	color: #BC1FFF;
}

a:link {
	font-size: 17px;
	color: #98B9FF;
	text-decoration: none;
	font-weight: bold;
}

a:visited {
	font-size: 17px;
	color: #CCCCFF;
	text-decoration: none;
}

a:hover {
	font-size: 20px;
	color: #FA4588;
	text-decoration: none;
}

a:active {
	font-size: 17px;
	color: #FF0000;
	text-decoration: none;
}

#div_head {
	font-size: 12pt;
	text-decoration: underline;
	color: #CCE6FF;
	margin-left: 10pt;
	margin-top: -50pt;
}

#div_title {
	font-size: 14pt;
	color: #CCE6FF;
	margin-left: 10pt;
	margin-top: 5pt;
}

#div_foot {
	font-size: 14pt;
	color: #CCE6FF;
}
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
<script type="text/javascript">
	function input1001() {
		var $msg = $("<span>不能为空</span>");
		$("#words_input1001").after($msg);//将span加入到文本框之后
		$msg.hide();//先将span隐藏
		//添加按钮的处理
		$("#zxp2").click(function() {
			var v = $("#words_input1001").val();
			//判断是否为空，如果为空显示提示信息
			if (v == "") {
				$msg.show();//将span显示
				return false;
			}
			//将文本框的值拼成li元素,并添加到ul中
			var $v = $("<div>" + v + "</div>");
			$("#words_input1001").append($v);
			return true;
		});
		//当用户开始输入时，清空msg消息
		$("#words_input1001").keyup(function() {
			$msg.hide();//将span隐藏
		});
	}
	function lookAll() {
		var table = document.getElementById("table");
		table.setAttribute("style", "display: block");
	}
	function look() {
		var table = document.getElementById("table1");
		table.setAttribute("style", "display: block");
	}
</script>
<title>Insert title here</title>
</head>
<body>
	<div>
		<%@include file="plugin/head.jsp"%>

	</div>
	<div id="wholepage">

		<div id="readlog">
			<div id="div_head">日志</div>
			<table cellSpacing=5px cellPadding=5px width="80%" class="all">
				<tbody>
					<tr>
						<td>
							<div id="div_title">
								<c:if test="${empty friend}"></c:if>
								<c:if test="${!empty friend}">
									<!-- <a href="">评论</a> -->
								</c:if>
								<a href="">下一篇</a> <a href="">下一篇</a><a href="log.jsp">返回日志列表</a>
							</div></td>
					</tr>
				</tbody>
				<tbody>
					<tr>
						<td style="font-size:20pt;font-weight:bold;color:#98B9FF">${dia.diaryTitle}</td>
						<!-- 题目 -->
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5"><hr />
						</td>
					</tr>
					<tr>
						<td colspan="5"><span
							style="font-size:15pt;font-weight:bold;">${dia.diaryContent}</span>
						</td>
						<!-- 正文 -->
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</tbody>
			</table>
			<div id=div_foot>
				<a href="">上一篇|</a> <a href="">下一篇|</a> <a href="log.jsp">返回日志列表</a>
				<c:if test="${empty friend}"><a href="sendToUpdate?id=${dia.diaryID}">编辑</a></c:if>
				<c:if test="${!empty friend}">
					 <!--  <a href="">评论</a>-->
				</c:if>
			</div>
		</div>
		<div><c:if test="${empty friend}"></c:if>
		<c:if test="${!empty friend}"><jsp:include page="diarycomment.jsp" /></c:if>
			<!-- 评论 -->
			<div id="words" class="">
				<div class="list">
					<table class="words_table1">
						<tr id="words_tr1">
							<td colspan="4">评论条数：<br />
								-------------------------------------------------------------------------------------------------------------------
							</td>
						</tr>
						<c:forEach var="re" items="${rev}">
						<c:forEach var="r" items="${re}">
							<tr id="words_tr2">
								<td id="words_td1"><img src="image/${r.value.pictureName}"
									width="50pt" height="50pt"></td>
								<td id="words_td2"><A href="" class="words_user_name"></A>
									: <span class="words_content">${r.key.reviewContent}</span>
									<DIV id="words_time">
										<SPAN class="words_time">${r.key.date}</SPAN>
									</DIV></td>
								<td id="words_td3"><a href="javascript:;" id="zxp" onclick="look();">回复</a></td>
								<td id="words_td4"><a href="deleteReview?id=${r.key.reviewID}&dId=${dia.diaryID}">删除此评论</a></td>
							</tr>
							</c:forEach>
						</c:forEach>
					</table>
					<form action="" method="post">
					<table id="table1" class="words_table3" style="display: none;">
									<tr id="words_tr1">
										<td><input type="hidden" name="diaryCommentId" /></td>
										<td class="words_td1" id="words_input1001"><textarea
												class="words_input1" name="content" cols="90"></textarea></td>
										<td class="words_td2"><input id="zxp2"
											class="words_input2" type="submit" onclick="input1001()"
											name="" value="提交评论" /></td>
									</tr>
								</table>
					</form>

					<div>
						<a href="javascript;:" onclick="lookAll();">查看剩余条评论</a>
						<table class="words_table2" style="display: none;" id="table">
							<tr id="words_tr1">
								<td colspan="3">
									--------------------------------------------------------------------------------------------------------------
								</td>
							</tr>
							<c:forEach var="r" items="${rev}">
								<tr id="words_tr2">
									<td id="words_td1"><IMG src="image/${r.value.pictureName}"
										width="30pt" height="30pt" /></td>
									<td id="words_td2"><a href="" class="words_user_name"></a>
										<span class="words_content">${r.key.reviewContent}</span>
										<div id="words_time">
											<span class="words_time">${r.key.date}</span>
										</div></td>
									<td id="words_td3"><a href="">删除此评论</a></td>
								</tr>
							</c:forEach>
						</table>
						<!--<c:if test="${!empty friend}">
							<form action="" method="post">
								<table class="words_table3">
									<tr id="words_tr1">
										<td><input type="hidden" name="diaryCommentId" /></td>
										<td class="words_td1" id="words_input1001"><textarea
												class="words_input1" name="content" cols="90"></textarea></td>
										<td class="words_td2"><input id="zxp2"
											class="words_input2" type="submit" onclick="input1001()"
											name="" value="提交评论" /></td>
									</tr>
								</table>
							</form>
						</c:if>-->
					</div>
					<hr color="#C6DDDA" />
				</div>
			</div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="25%" height="29" nowrap="nowrap" style="font-size:15pt;"><span
						style="color:#98B9FF;font-weight:bold;">共<span
							style="color:#98B9FF;font-weight:bold;"></span>${review.size}条纪录，当前第${page+1}<span
							style="color:#98B9FF;font-weight:bold;"></span>/<span
							style="color:#98B9FF;font-weight:bold;"></span>${s}页，每页<span
							style="color:#98B9FF;font-weight:bold;"></span>条纪录</span>
					</td>
					<td width="75%" valign="top" class="STYLE1"><div align="right">
							<table width="452" height="20" border="0" cellpadding="0"
								cellspacing="0">
								<tr class="tiao">
									<td width="70" height="22" valign="middle"><div
											align="right">
											<a href="pagingReview?page=0">首页</a>
										</div>
									</td>
									<c:if test="${page==0}">
									<td width="70" height="22" valign="middle"><div
											align="right">
											上一页
										</div>
									</td></c:if>
									<c:if test="${page==0}">
									<td width="70" height="22" valign="middle"><div
											align="right">
											<a href="pagingReview?page=${page-1}">上一页</a>
										</div>
									</td></c:if>
									<c:if test="${page==(s-1)}">
									<td width="70" height="22" valign="middle"><div
											align="right">
											下一页
										</div>
									</td></c:if>
									<c:if test="${page!=(s-1)}">
									<td width="70" height="22" valign="middle"><div
											align="right">
											<a href="pagingReview?page=${page+1}">下一页</a>
										</div>
									</td></c:if>
									<td width="70" height="22" valign="middle"><div
											align="right">
											<a href="javascript:;" onclick="pagingReview?page=${s-1}">尾页</a>
										</div>
									</td>
									<td width="70" height="22" valign="middle"><div
											align="right" class="STYLE1">
											<span style="font-size:15pt;color:#98B9FF;font-weight: bold;"></span>
										</div>
									</td>
									<td width="70" height="22" valign="middle">
									<!--  <input
										name="page" type="text" id="pageNum" class="STYLE1"
										style="height:15px; width:25px;" size="5" />--></td>
									<td width="23" height="22" valign="middle" class="STYLE1"><span
										style="font-size:15pt;color:#98B9FF;font-weight: bold;"></span>
									</td>
									<td width="30" height="22" valign="middle">
									</td>
								</tr>
							</table>

						</div>
					</td>
				</tr>
			</table>
			<div>
				<%@include file="plugin/foot.jsp"%>
			</div>
		</div>
	</div>
</body>
</html>