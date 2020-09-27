<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>检疫处理查询</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet"
	href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<style type="text/css">
input.datepick{background:#FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right}
.title a:link,.title a:visited,.user-info a:link,.user-info a:visited{
     color:white;
     text-decoration:none;
}
.title a:active,.title a:hover,.user-info a:active,.user-info a:hover{
     color:#014ccc;
     text-decoration:underline;
}

</style>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#process_form").attr("action", "/ciqs/mailSteamer/showhlthchecklist");
			$("#process_form").append("<input type='hidden' name='page' value='"+page+"'/>");
			$("#process_form").submit();
		}
		
		//图片预览
		function showPic(path) {
			url = "/ciqs/showVideo?imgPath=" + path;
			$("#imgd1").attr("src", url);
			$("#imgd1").click();
		}
</script>
</head>

<body  class="bg-gary">

<!-- 图片 -->
<div class="row" style="z-index:200000;">
	<div class="col-sm-8 col-md-6" style="z-index:200000;">
		<div class="docs-galley" style="z-index:200000;">
			<ul class="docs-pictures clearfix" style="z-index:200000;">
				<li><img id="imgd1" style="z-index:200000;" src=""
					alt="Cuo Na Lake" /></li>
			</ul>
		</div>
	</div>
</div>

<div class="freeze_div_list">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">检疫处理查询</span></a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
</div>
<div class="margin-auto width-1200 search-box">
	<form action="/ciqs/mailSteamer/showChkDealList" method="post" id="process_form">
	</form>
</div>

<div class="margin-auto width-1200 tips" >共找到<span class="yellow font-18px" >${counts}</span>条记录
分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</div>
<div class="margin-auto width-1200  data-box">
  	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
	    <tr>
	      <td width="200" height="35" align="center" valign="bottom">处理对象</td>
	      <td width="200" height="35" align="center" valign="bottom">处理方法</td>
	      <td width="200" height="35" align="center" valign="bottom">相关证单</td>
	      <td width="200" height="35" align="center" valign="bottom">处理过程</td>
	      <td width="450" height="35" align="center" valign="bottom">处理依据</td>
	      <td width="200" height="35" align="center" valign="bottom">处理公司</td>
	      <td width="200" height="35" align="center" valign="bottom">完成状态</td>
	      <td width="200" height="35" align="center" valign="bottom">是否合格</td>
	    </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data" id="data_list">
     	<tbody>
	 	 	<c:if test="${not empty list }">
				<c:forEach items="${list}" var="row">
				    <tr>
				      	<td width="200" height="90" align="center">${row.check_deal_proj }</td>
				      	<td width="200" height="90" align="center">
							<c:choose>
								<c:when test="${row.check_deal_method == '1' }">
									消毒
								</c:when>
								<c:when test="${row.check_deal_method == '2' }">
									杀虫
								</c:when>
								<c:when test="${row.check_deal_method == '3' }">
									除鼠
								</c:when>
								<c:when test="${row.check_deal_method == '4' }">
									除污
								</c:when>
								<c:otherwise>
									其他
								</c:otherwise>
							</c:choose>
						</td>
				      	<td width="200" height="90" align="center">
				      		<c:if test="${not empty row.check_deal_notice }">
				      			<c:set var="noticeArray" value="${fn:split(row.check_deal_notice, ',') }"/>
				      			<c:forEach items="${noticeArray }" var="notice">
				      				<c:if  test="${not fn:contains(notice, 'mp4')}">
										<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${notice}")'/>									
									</c:if>
									<c:if test="${fn:contains(notice, 'mp4')}">
										<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${notice}")'/>									
									</c:if>
				      			</c:forEach>
				      		</c:if>
				      		<c:if test="${not empty row.check_deal_notice_video }">
				      			<c:set var="noticeArray" value="${fn:split(row.check_deal_notice_video, ',') }"/>
				      			<c:forEach items="${noticeArray }" var="notice">
									<c:if test="${fn:contains(notice, 'mp4')}">
										<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${notice}")'/>									
									</c:if>
				      			</c:forEach>
				      		</c:if>
				      	</td>
				      	<td width="200" height="90" align="center">
				      		<c:if test="${not empty row.check_deal_pic }">
				      			<c:set var="noticeArray" value="${fn:split(row.check_deal_notice, ',') }"/>
				      			<c:forEach items="${noticeArray }" var="notice">
				      				<c:if  test="${not fn:contains(notice, 'mp4')}">
										<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${notice}")'/>									
									</c:if>
									<c:if test="${fn:contains(notice, 'mp4')}">
										<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${notice}")'/>									
									</c:if>
				      			</c:forEach>
				      		</c:if>
				      		<c:if test="${not empty row.check_deal_video }">
				      			<c:set var="noticeArray" value="${fn:split(row.check_deal_video, ',') }"/>
				      			<c:forEach items="${noticeArray }" var="notice">
									<c:if test="${fn:contains(notice, 'mp4')}">
										<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${notice}")'/>									
									</c:if>
				      			</c:forEach>
				      		</c:if>
				      	</td>
				      	<td width="450" height="90" align="center">${row.check_deal_couse}</td>
				      	<td width="200" height="90" align="center">${row.check_deal_company}</td>
				      	<td width="200" height="90" align="center">
				      		<c:if test="${row.check_deal_finish_st == '1'}">
				      			已完成
				      		</c:if>
				      		<c:if test="${row.check_deal_finish_st == '2'}">
				      			未完成
				      		</c:if>
				      	</td>
				      	<td width="200" height="90" align="center">
				      		<c:if test="${row.qualified_flag == '1'}">
				      			不合格
				      		</c:if>
				      		<c:if test="${row.qualified_flag == '0'}">
				      			合格
				      		</c:if>
				      	</td>
				    </tr>
	    		</c:forEach>
			</c:if>
	  	</tbody> 
	  	<tfoot >
       		<jsp:include page="/common/pageUtil.jsp" flush="true"/>
      	</tfoot>      
  	</table>
</div>
<div class="margin-auto width-1200 tips" ></div>
</body>
<script type="text/javascript">
$("#imgd1").hide();
$("#CuPlayerMiniV").hide();
</script>
<%@ include file="/common/player.jsp"%>
</html>
