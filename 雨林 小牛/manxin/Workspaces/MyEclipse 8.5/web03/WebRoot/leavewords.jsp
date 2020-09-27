<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%request.setCharacterEncoding("utf-8"); %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
		<script type="text/javascript">
		$(function(){
				$("#pageNum").focus(function(){
				
					$("#pageNum").css("background-color","#ffffff");
					$("#pageNum").css("color","#000000");
					
				});
				$("#pageNum").focusout(function(){
				
					$("#pageNum").css("background-color","#000000");
					$("#pageNum").css("color","#ffffff");
					
				});
		
			});
			
			function a(m){
				var p = "#"+m;
				$(p).focus();
			}
			function tfocusout(m){
				var mm = "#"+m;
				$(mm).css("background-color","#000000");
				$(mm).css("color","#ffffff");
			}
				
			function tfocus(m){
				var mm = "#"+m;
				$(mm).css("background-color","#ffffff");
				$(mm).css("color","#000000");
			}
		
			function look(m){
				$("div[name="+m+"]").toggle(800);
			}
			
			function showReview(event){
				var id=event.target.id;
				var dd=document.getElementsByName(id);
				dd[0].focus();
			}
</script>
<title>Insert title here</title>
<style type="text/css">
body{
	background:#000000;
}
.STYLE1 {
	font-size: 17px;
	font-weight: bold;
	color:#E1FCFA;
}
.STYLE7 {
	font-size: 16px;
	font-weight: bold;
	color:#E1FCFA;
}

.STYLE6{
	font-size: 16px;
	font-weight: bold;
	color:#ffffff;
	border:solid #7BC5EA 1px;
	background-color:#000000;
}
#words {
	margin: 100px 100px 100px 100px;
}
.words_user_name {
	font-size:16pt;
	font-weight: bold;
	color:#FAD8CC;
	text-decoration:none;
}
.words_user_name:HOVER{
	font-size:16pt;
	font-weight: bold;
	color:#A768FF;
	text-decoration:none;
}
.words_time{
	color:#E4FFFD;
	font-size:10pt;
}
.words_table1 #words_tr1 {
	width: 930px;
	color: #C6DDDA;
	
}
.words_table1 #words_tr2 {
	font-size: 12pt;
	width: 930px;
	color: #7BC5EA;
	font-weight: bold;
}
.words_table1 .words_td1 {
	position: top;
	width: 50px;
	font-weight: bold;
}
.words_table1 .words_content{
	color:#AACCDD;
	font-size:12pt;
}
.words_table2 .words_content{
	color:#AACCDD;
	font-size:12pt;
	font-weight: bold;
}
.words_table1 #words_td2 {
	width: 810px;
	font-size: 12pt;
}
.words_table1 #words_td3 {
	width: 40px;
	font-size: 10pt;
}
.words_table1 #words_td3 a{
	width: 80px;
	font-size: 12pt;
	font-weight: bold;
	color:#9FAF8B;
	text-decoration:none;
}
.words_table1 #words_td3 a:HOVER{
	color:#FFE6CC;
}
.words_table1 #words_td4{
	width: 90px;	
}
.words_table1 #words_td4 a{
	width: 80px;
	font-size: 11pt;
	font-weight: bold;
	color:#9FAF8B;
	text-decoration:none;
}
.words_table1 #words_td4 a:HOVER{
	color:#FFE6CC;
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
.words_table2 #words_td3 a{
	width: 90px;
	font-size: 11pt;
	font-weight: bold;
	color:#9FAF8B;
	text-decoration:none;
}
.words_table2 #words_td3 a:HOVER{
	color:#FFE6CC;
}
.words_table3 #words_td1 {
	width: 900px;
	font: red;
	border: red;
	font-size: 10pt;	
}
.words_table3 .words_input1 {
	font-size: 14pt;
	WIDTH: 850px;
	HEIGHT: 28px;
	border: solid #7BC5EA 1px;
	color:#ffffff;
	background-color:#000000;
}
.words_table3 .words_input2 {
	font-size: 12pt;
	border: solid #7BC5EA 1px;
	background-color:#000000;
	color:#FFE6CC;
	font-weight: bold;
	
}
.hr{ height:3px;border:none;border-top:3px double white;}
.leave{border:solid red 1}
a:link {
		font-size: 16px;
		text-decoration: none;
		font-weight: bold;
		color:#E1FCFA;
		}

a:hover {
	font-size: 15px;
	color:#FFCCCC;
	text-decoration: none;
}

</style>
</head>
<body >
	<div id="words" class="">
		<div class="list">
			<c:forEach var="leaveword" items="${requestScope.leavewords}">
			<div class="leave">
				<table class="words_table1" >
					<!-- <hr color="#C6DDDA" /> -->
						<tr id="words_tr2">
							<!-- 头像 -->
							<td id="words_td1">
								<a href=""><img src="img/${requestScope.pictureNames[leaveword.personID]}" width="50pt" height="50pt" /></a>
							</td>
							<td id="words_td2">
								<a href="" class="words_user_name">${requestScope.userNames[leaveword.personID]}</a> : &nbsp;
								<span class="words_content">${leaveword.leaveContent}</span>
								<div id="words_time"><span class="words_time">${leaveword.date} 留言</span></div>
							</td>
							<c:if test="${leaveword.userID==sessionScope.user.personal.personID}">
								<td id="words_td3"><a href="javascript:;" id="words_btn2_${leaveword.leaveID}" onclick="showReview(event);"></a></td>
								<td id="words_td4"><a href="deleteLeaveword?id=leaveword.leaveID">删除此留言</a></td>
							</c:if>
						</tr>
				</table>
				<input type="button" style="background-color: black; color: #CCFFFF;font-weight: bold;"
					   onclick="look('review_list_${leaveword.leaveID}');"
				  	   value="查看/收缩<c:out value="${fn:length(requestScope.reviews[leaveword.leaveID])}"></c:out>条评论" />
			
				
				<c:forEach var="review" items="${requestScope.reviews[leaveword.leaveID]}">
					<div id="words_input1003_${review.reviewID }_2" name="review_list_${leaveword.leaveID}">
						<table class="words_table2">
							<tr id="words_tr1">
								<td colspan="2">&nbsp;</td>
								<td colspan="3">
									--------------------------------------------------------------------------------------------------------------
								</td>
							</tr>
							<tr id="words_tr2">
								<td colspan="2">&nbsp;</td>
								<td id="words_td1">
									<a href=""> <IMG src="img/${requestScope.pictureNames[review.personID]}" width="30pt" height="30pt" /></a>
								</td>
								<td id="words_td2">
									<a href="" class="words_user_name">${requestScope.userNames[review.personID]}</a>
									: &nbsp;
									<span class="words_content">${review.reviewContent}</span>
									<div id="words_time"><SPAN class="words_time">${review.date}</SPAN></div>
								</td>
								<td id="words_td3"><a href="deleteReview?id=${review.reviewID}"></a></td>
							</tr>
						</table>
					</div>
				</c:forEach>
				<c:if test="${sessionScope.personId==sessionScope.userId}">
					<form action="${pageContext.request.contextPath}/commitReviewActionServlet" method="post" >
						<table class="words_table3">
							<tr id="words_tr1">
								<td><input type="hidden" name="leavewordId" value=$(leaveword.getId())></td>
								<td class="words_td1" " id="words_input1001" colspan="7">
									<input type="hidden" name="textId" value="words_btn2_${leaveword.leaveID}"/>
									<textarea id="words_input1003${leaveword.leaveID}" class="words_input1" cols="90" name="words_btn2_${leaveword.leaveID}"></textarea>
								</td>
								<td class="words_td2">&nbsp;
									<input id="words_input1003${leaveword.leaveID }_1"
										class="words_input2" type="submit" onclick="input1001();"
										 value="提交"  />
								</td>
							</tr>
						</table>
					</form>
				</c:if>
				<c:if test="${sessionScope.personId!=sessionScope.userId}">
					<!-- 发送提交评论 -->
					<form action="" method="post">
						<table class="words_table3">
							<tr id="words_tr1">
								<td><input type="hidden" name="leavewordId" value=$(leaveword.getId())></td>
								<td class="words_td1" " id="words_input1001" colspan="7">
									<textarea id="words_input1003${leaveword.leaveID}" class="words_input1" name="content" cols="90" onfocus=""></textarea>
								</td>
								<td class="words_td2">&nbsp;
									<input id="words_input1003${leaveword.leaveID }_1"
										class="words_input2" type="submit" onclick="input1001();"
										name="" value="提交评论" />
								</td>
							</tr>
						</table>
					</form>
				</c:if>
				
				</div>
				<br/>
			</c:forEach>
		</div>	
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="15" height="29">&nbsp;</td>
				<td >
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td>
							<input type="text" id="page" name="page" value="${requestScope.pageNum}"/></td>
							<td width="25%" height="29" nowrap="nowrap">
								<span class="STYLE1">共${fn:length(leavewords)}条纪录，当前第${requestScope.pageNum}页</span>
							</td>
							<td width="75%" valign="top" class="STYLE1">
								<div align="right">
									<table width="400" height="20" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="62" height="22" valign="middle">
												<div align="right"><a href="" onclick="location='leavewordSkipPage.do?pageNum=1'">首页</a></div>
											</td>
											<c:if test="${pageNum==1}">
												<td width="50" height="22" valign="middle">
													<span class="STYLE1"> 上一页</span>
												</td>
											</c:if>
											<c:if test="${pageNum!=1}">
												<td width="50" height="22" valign="middle">
													<div align="right">
														<a href="${pageContext.request.contextPath}/getLeaveWordActionServlet?pageNum=${requestScope.pageNum-1}">上一页
														</a>
													</div>
												</td>
											</c:if>
											<td width="54" height="22" >
												<div align="right">
													<a href="${pageContext.request.contextPath}/getLeaveWordActionServlet?pageNum=${requestScope.pageNum+1}">下一页
													</a>
												</div>
											</td>
											<td width="49" height="22" valign="middle">
												<div align="right">
													<a href="javascript:;"
														onclick="location='leavewordSkipPage.do?pageNum='">尾页
													</a>
												</div>
											</td>

											<td width="59" height="22" valign="middle">
												<div align="right" class="STYLE1">转到第</div>
											</td>
											<td width="25" height="22" valign="middle">
												<span class="STYLE7"> <span> <input
															name="page" type="text" id="pageNum" class="STYLE6" id=""
															style="height: 20px; width: 25px;" size="5" /> </span>
											</td>
											<td width="23" height="22" valign="middle" class="STYLE1">页</td>
											<td width="30" height="22" valign="middle">
												<a href="javascript:;"
													onclick="location='leavewordSkipPage.do?pageNum='+document.getElementById('pageNum').value">转
												</a>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>	
</body>

</html>