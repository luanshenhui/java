<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  <title>缘来交友网</title>   
	<meta http-equiv="cache-control" content="no-cache">  
	<meta http-equiv="keywords" content="交友">
	<meta http-equiv="description" content="恋爱自由">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<script type="text/javascript"  src="js/jquery-1.4.min.js"></script>
	<script type="text/javascript" src="js/ajax.js"></script>
	<script type="text/javascript" src="js/province.js"></script>
	<script src="js/jcarousellite_1.0.1.js" type="text/javascript"></script>

<script type="text/javascript">
$(function(){
		//$("#xc").load("flash.jsp");
		/*滚动图片*/
		$(".div1").jCarouselLite({
        auto:800,//等待ms数
        speed:900//拉过一张图片的时间
    });  
    /*点击上传按钮，隐藏或出现表单*/
			$("#form1").hide();
				$("#up").click(function(){
					$("#form1").toggle(500);
				});
				$("#jia").click(function(){
					$.get("servlet/AddToFriendServlet",function(jsondata){
									alert(jsondata);
					});
				});
			/*鼠标移到滚动图片上，显示大图*/
				$("a.t").mouseover(function(e){
						this.myTitle=this.title;
						this.title="";
						var imgTitle=this.myTitle?"<br/>"+this.myTitle:"";
						var toolTip="<img src='"+this.href+"' height='360'width='580px' alt='照片预览'/>"+imgTitle;
						//alert(toolTip);
						$("#div3").html(toolTip);
				}).click(function(){
				return false;
				});
		});	
		function makeFriends(){
			location.href = "MakeFriendsServlet";
		}
</script>

  </head>
  <body onload="showLogs();">
    <div id="wholepage">
				<%@ include file="plugin/head.jsp"%>
					<div id="soso">
								<%@include file="plugin/find.jsp"%>

						</div>
				<div id="by">
						<div id="b_left">
								<div id="bl_top" style="color:white;font-size:20px">
								<c:if test="${empty friend}"><img width="100x" height="110px" src="image/${uPicture.pictureName}"/><br/></c:if>
								<c:if test="${!empty friend}"><img width="100x" height="110px" src="image/${fPicture.pictureName}"/><br/></c:if>
										<c:if test ="${empty friend}"><input type="button" id="up" value="上传"  class="confirm"/></c:if>
										<span style="color:red;font-size:10px;"></span>
										<form id="form1" action="pictureLoad" method="post" enctype="multipart/form-data">
												<input type="file" width="10%" name="file1" /><br/>
												<input type="submit" value="确定"  class="confirm"/>
												<br/>
										</form>		
							
								</div>
								
								<div id="bl_mid">
								<table id="table1" border=0 cellSpacing="1px" cellPadding="1px" style="color:#acd;">

								<tr><td colspan="2"><SPAN style="font-size: 20px;">个人简介</SPAN></td></tr>
								<c:if test="${empty friend}"><tr><td width="50px">用户名：</td><td width="50px"><span>${user.name}</span></td></tr></c:if>
								<c:if test="${!empty friend}"><tr><td width="50px">用户名：</td><td width="50px"><span>${friend.name}</span></td></tr></c:if>
								<c:if test="${empty friend}"><tr><td>性	别：</td><td>${user.sex}</td></tr></c:if>
								<c:if test="${!empty friend}"><tr><td>性	别：</td><td>${friend.sex}</td></tr></c:if>
								<c:if test="${empty friend}"><tr><td>年	龄：</td><td>${user.age}</td></tr></c:if>
								<c:if test="${!empty friend}"><tr><td>年	龄：</td><td>${friend.age}</td></tr></c:if>
								<c:if test="${empty friend}"><tr><td align="left" valign="top">个性签名：</td><td><span>${user.personal.signature}</span></td></tr></c:if>
								<c:if test="${!empty friend}"><tr><td align="left" valign="top">个性签名：</td><td><span>${friend.personal.signature}</span></td></tr></c:if>
								
								<tr><td colspan="2" style="color:#fac;" width="120px"></td></tr>
								</table>
								</div>
								
								<c:if test="${user.userID==friend.userID}">		
								</c:if>
								<c:if test="${friend.userID!=null&&user.userID!=friend.userID}">
								<input type="button" value="加为好友" id="jia" onclick="makeFriends();"/>
								</c:if>
								<div id="bl_bottom">
								<c:if test="${user.userID==friend.userID}">		
								</c:if>
								<c:if test="${friend.userID!=null&&user.userID!=friend.userID}">
								<a href="appointment.jsp">我要约他</a>
								</c:if>
										<br/>	<br/>	<br/>		<br/>	<br/>	<br/>	<br/>	
								</div>
						</div>
						<div id="b_center">
						<div id="xq">
						<form action="SendMoodServlet" method="post">
						<span style="font-size:18px;color:#db3cff;font-weight:bold;">心情：</span>
						<span style="color:white;">${mood_err}</span> <br/>
						<textarea id="text1" rows="1" cols="40" name="mood"></textarea><br/>
						<input type="submit" value="提交"  class="confirm"/>
						</form>
							</div>
							<div id="wz">
								<table  cellSpacing=5px cellPadding=5px width="80%">
								<tbody id="tb">
									<tr><td colspan="2" align="left"><SPAN style="font-size:18px;color:#db3cff;font-weight: bold;">文章列表</SPAN></td></tr>
									<tr><td>日志标题</td><td>日期</td></tr>
									<c:if test="${empty friend}">
									<c:forEach var="dia" items="${uDiary}">
									<tr>
									<td><a href = "readLog?id=${dia.diaryID}">${dia.diaryTitle}</a></td><td>${dia.diaryDate}</td>
									</tr>
									</c:forEach>	
									</c:if>	
									<c:if test="${!empty friend}">
									<c:forEach var="dia" items="${fDiary}">
									<tr>
									<td><a href = "readLog?id=${dia.diaryID}">${dia.diaryTitle}</a></td><td>${dia.diaryDate}</td>
									</tr>
									</c:forEach>	
									</c:if>	
								</tbody>
								
						
								</table>
							</div>	
								<div id="xc" class="div1">
								<div id="div3"></div>
									<div class="div2">
									<ul>
											<li>
											<a href="upload/pic_" class="t">
											<img title="photo" src="upload/pic_/" alt="" width="180" height="138"/>
											</a>
											</li>
											<li>
											<a href="img/sky1.jpg" class="t"><img title="sky1" src="img/sky1.jpg" alt="" width="180" height="138"/></a>
											</li>
											<li>
											<a href="img/sky2.jpg" class="t"><img title="sky2" src="img/sky2.jpg" alt="" width="180" height="138"/></a>
											</li>
											<li>
											<a href="img/sky3.jpg" class="t"><img title="sky3" src="img/sky3.jpg" alt="" width="180" height="138"/></a>
											</li>
										</ul>
								
									</div>
							</div>
						</div>
						<div id="b_right">
						</div>
				</div>
				<%@include file="plugin/foot.jsp" %>
		</div>
  </body>
</html>
