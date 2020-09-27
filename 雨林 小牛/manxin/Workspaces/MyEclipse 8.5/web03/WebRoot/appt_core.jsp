<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript" src="js/jquery-1.4.3.js"></script>
<script type="text/javascript">
	$(function(){
		$("#msg").hide();	//页面初始时隐藏
		$("#sp").hide();
		$(":input").change(function(){
			var date = new Date();
			if($("#year").val() < date.getFullYear()){
				$("#msg").text($("#year").val()+"年小于当前年份, 请重新选择.");
				$("#msg").fadeIn(1000);
				$("#msg").fadeOut(1000);
				//$("#submit").fadeOut(1000);
			}else if($("#year").val() == date.getFullYear() && $("#month").val() < (date.getMonth()+1)){
				$("#msg").text($("#month").val()+"月小于当前月份, 请重新选择.");
				$("#msg").fadeIn(1000);
				$("#msg").fadeOut(1000);
				//$("#submit").fadeOut(1000);
			}else if($("#year").val() == date.getFullYear() && $("#month").val() == (date.getMonth()+1) && $("#day").val() <= date.getDate()){
				$("#msg").text("日期应大于当前日期, 请重新选择.");
				$("#msg").fadeIn(1000);
				$("#msg").fadeOut(1000);
				//$("#submit").fadeOut(1000);
			}else{
				//$("#submit").fadeIn(500);
			}
		});
		/* $("#submit").click(function(){
			if($("#toProvince").val()=="" ||  $("#toCity").val()=="" || $("#toCity").val()==null ||  $("#toArea").val()==""){
				 $("#sp").fadeIn(1000);
				 return false;
			}
		}); */
		$("#toArea").mousedown(function(){
				$("#sp").fadeOut(1000);
		});
	});
</script>
</head>
<body>
	<div id="appt_core">
	<div id="msg" style="position: absolute;top: 320px;left:570px;background:#FFFFFF;color:#FF0000;font-size:20px;"></div>
	<form action="addAppointment" method="post">
		<input type="hidden" name="fromid" value="${user.userID}">
		<input type="hidden" name="fromname" value="${user.name}">
		<input type="hidden" name="toid" value="${friend.userID}">
		<input type="hidden" name="toname" value="${friend.name}">
		
			<table  cellspacing="25" cellpadding="10" id="appt_table">
				<tr>
					<td><img src="img/him.png"></img>约会对象：</td>
					<td>
					${friend.name}
					</td>
				</tr>
				<tr>
					<td><img src="img/time.png"></img>约会时间:</td>
					<td>
						<%@include file="plugin/select_time.jsp" %>不好意思，请手动输入<br/>
						<input type="text" name="time"/>
					</td>
				</tr>
				<tr>
					<td><img src="img/place.png"></img>约会地点:</td>
					 <td>
					 	<%@include file="select_city.jsp" %>
					 	<br/>
							<span style="font-size:12px;color:#ffff00;">详细地址：</span><br/>
							<textarea id="toArea" name="toArea" cols="26" rows="2"></textarea><br/>
							<span id='sp' style='color:#f99;font-size:13px;'>请填写详细约会地点...</span>
					 </td>
				</tr>
				<tr>
					<td><img src="img/say.png"></img>想对他(她)说:</td>
					<td>
					<input type="text" name="content"/>
					</td>
				</tr>
			</table>
		<br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="submit" value="提交请求"  id="submit" class="appt_button">
			<input type="button" onclick="location='main.jsp'" value="下次再说" class="appt_button">
	</form>
	</div>
</body>
</html>