<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%request.setCharacterEncoding("utf-8"); %>
<html>
  <head>
  <title>缘来交友网</title>
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="keywords" content="交友">
	<meta http-equiv="description" content="恋爱自由">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<link rel="stylesheet" type="text/css" href="css/style_appt.css">
	<script src="js/jquery-1.4.min.js" type="text/javascript"></script>
	
	<script type="text/javascript">
	$(function(){
		$(".info").mouseover(function(){
			$(this).css("color","#f1aaff");
			$(this).animate({"fontSize":"16px"},300);
		});
		$(".info").mouseout(function(){
			$(this).css("color","#709dff");
			$(this).animate({"fontSize":"14px"},150);
			});
			
	});
	</script>
	<style type="text/css">
	#detail_table{
		color:#709dff;
	}
	.info{
		font-size:14px;
		color:#709dff;
	}
	</style>
  </head>
  <body>
    <div id="wholepage">
    			<div>
						<%@include file="plugin/head.jsp" %><br/>
					</div>
						<div id="appt_detail_unknow1"></div>
						<div id="appt_detail_unknow2"></div> 
							<div id="appt_detail_yes"></div>
							<div id="appt_detail_no">
						    <table cellspacing="10" cellpadding="8" id="detail_table">
							<tr>
								<td>发起人</td><td id="from" class="info">${my.name}</td><td>接收人</td><td class="info">${other.name}</td>
							</tr>
							<tr>
								<td colspan="1">约会时间</td><td colspan="3" class="info">${app.appointmentDate}</td>
							</tr>
							<tr>
								<td colspan="1">约会地点</td><td colspan="3" class="info">${app.appointmentAddress}</td>
							</tr>
							<tr>
								<td colspan="1">约会宣言</td><td colspan="3" class="info">${app.appointmentMessage}</td>
							</tr>
							<tr>
							<c:if test="${app.ok=='未答复'}">
								<td colspan="1">答复状态</td><td colspan="3" class="info">未答复</td></c:if>
							<c:if test="${app.ok=='同意'}">
								<td colspan="1">答复状态</td><td colspan="3" class="info">同意哦</td></c:if>
							<c:if test="${app.ok=='拒绝'}">
								<td colspan="1">答复状态</td><td colspan="3" class="info">不好意思你 拒绝了哦</td></c:if>
							</tr>
							<tr>
							<td> <a href="selectAppointment"><img src="img/return.png" border="0"></img></a></td>
							<td></td>
							<c:if test="${user.userID==app.otherId && app.ok == '未答复'}">
										<td align="right"><a href="responseAppointment?id=${app.id}&name=true"><img src="img/yes.png" border="0"></img></a></td>
										<td><a href="responseAppointment?id=${app.id}&name=false"><img src="img/no.png" border="0"></img></a></td>
							</c:if>
							<c:if test="${user.userID==app.myId}">
								<td><a href="deleteAppointment?id=${appt.id}&name='one'" onclick="return confirm('是否撤销约会请求?');"><img src="img/no.png" border="0"></img></a></td>
							</c:if>
								</tr>
						</table>
				</div>
				<div>
				<%@include file="plugin/foot.jsp" %>
				</div>
		</div>
  </body>
</html>