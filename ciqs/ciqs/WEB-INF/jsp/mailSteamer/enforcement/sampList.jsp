<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>采样</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css">
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css">
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
			$("#samp_form").attr("action", "/ciqs/mailSteamer/showSampList");
			$("#samp_form").append("<input type='hidden' name='page' value='"+page+"'/>");
			$("#samp_form").submit();
		}
</script>
</head>

<body  class="bg-gary">
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>	 	
<script type="text/javascript">
	$(function(){
		$("#imgd1").hide();
		$("#CuPlayerMiniV").hide();
	});
	
	//图片预览
	function showPic(path){
	    url = "/ciqs/showVideo?imgPath="+path;
		$("#imgd1").attr("src",url);
		$("#imgd1").click();	
	}
	
	/**
	 * 查看视频
	 * path 数据库保存的视频地址 E:/201708/20170823/22.3gp
	 * wangzhy
	 */
	function showVideo(path){
	    path=path.substring(path.indexOf('/')+1,path.length);
		$("#CuPlayerMiniV").show();
		CuPlayerMiniV(path);
	}
</script>
<div class="freeze_div_list">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">采样</span></a></div>
<div class="user-info">你好sunxu，欢迎登录系统     |      退出</div>
</div>
</div>
</div>
<div class="blank_div_list">
</div>
<div class="margin-auto width-1200 search-box">
	<form action="/ciqs/mailSteamer/showhlthchecklist" method="post" id="samp_form">
		<input type="hidden" class="search-input input-175px" name="dec_master_id" id=""size="14" value="${map.dec_master_id}"/>
	</form>
</div>

<div class="margin-auto width-1200 tips" >共找到<span class="yellow font-18px" >${counts}</span>条记录
分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</div>
<div class="margin-auto width-1200  data-box">
  	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
	    <tr>
	      <td width="250" height="35" align="center" valign="bottom">采样项目</td>
	      <td width="250" height="35" align="center" valign="bottom">采样知情同意书/采样凭证</td>
	      <td width="250" height="35" align="center" valign="bottom">采样过程</td>
	      <td width="150" height="35" align="center" valign="bottom">采集人</td>
	      <td width="150" height="35" align="center" valign="bottom">送检时间</td>
	      <td width="150" height="35" align="center" valign="bottom">送检单位</td>
	      <td width="150" height="35" align="center" valign="bottom">结果报告</td>
	      <td width="150" height="35" align="center" valign="bottom">结果报告单</td>
	    </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data" id="data_list">
     	<tbody>
	 	 	<c:if test="${not empty list }">
				<c:forEach items="${list}" var="row">
				    <tr>
				      	<td width="200" height="90" align="center">${row.samp_proj}</td>
				      	<td width="250" height="90" align="center">
				      	<c:if test="${not empty row.samp_notice }">
				      		<c:set var="noticeArray" value="${fn:split(row.samp_notice, ',') }"/>
			      			<c:forEach items="${noticeArray }" var="notice">
		      				<c:if  test="${not fn:contains(notice, 'mp4')}">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${notice}")'/>									
							</c:if>
							</c:forEach>
				      	</c:if>
				      	
						<c:if test="${not empty row.samp_notice }">
							<c:set var="noticeVideoArray" value="${fn:split(row.samp_notice_video, ',') }"/>
			      			<c:forEach items="${noticeVideoArray }" var="noticeVideo">
		      				<c:if  test="${fn:contains(noticeVideo, 'mp4')}">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${noticeVideo}")'/>										
							</c:if>
							</c:forEach>
						</c:if>
				      	</td>
				      	<td width="250" height="90" align="center">
				      	<c:set var="noticeArray" value="${fn:split(row.samp_file, ',') }"/>
		      			<c:forEach items="${noticeArray }" var="notice">
	      				<c:if  test="${not fn:contains(notice, 'mp4')}">
							<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${notice}")'/>									
						</c:if>
						</c:forEach>
						
						<c:set var="noticeVideoArray" value="${fn:split(row.samp_video, ',') }"/>
		      			<c:forEach items="${noticeVideoArray }" var="noticeVideo">
	      				<c:if  test="${fn:contains(noticeVideo, 'mp4')}">
							<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${noticeVideo}")'/>										
						</c:if>
						</c:forEach>
				      	</td>
				      	<td width="150" height="90" align="center">${row.samp_psn_cn}</td>
				      	<td width="150" height="90" align="center">
				      		<fmt:formatDate value="${row.samp_date }" type="both"
										pattern="yyyy-MM-dd HH:mm:ss" />
						</td>
				      	<td width="150" height="90" align="center">${row.send_samp_comp}</td>
				      	<td width="150" height="90" align="center">${row.result_cmd}</td>
				      	<td width="150" height="90" align="center">
				      	<c:if test="${not empty row.result_cmd_paper }">
				      		<c:set var="noticeArray" value="${fn:split(row.result_cmd_paper, ',') }"/>
			      			<c:forEach items="${noticeArray }" var="notice">
		      				<c:if  test="${not fn:contains(notice, 'mp4')}">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${notice}")'/>									
							</c:if>
							</c:forEach>
				      	</c:if>
						
						<c:if test="${not empty row.result_cmd_paper_video }">
							<c:set var="noticeArray" value="${fn:split(row.result_cmd_paper_video, ',') }"/>
			      			<c:forEach items="${noticeArray }" var="notice">
		      				<c:if  test="${fn:contains(notice, 'mp4')}">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${notice}")'/>																		
							</c:if>
							</c:forEach>
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
  	<input type="button" style="margin: 40px 40px 0px 540px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();">
</div>
<div class="margin-auto width-1200 tips" ></div>
<!-- 图片 -->
<div class="row" style="z-index:200000;">
 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
      	<div class="docs-galley" style="z-index:200000;">
	       	<ul class="docs-pictures clearfix" style="z-index:200000;">
         		<li>
         			<img id="imgd1" style="z-index:200000;" <%-- data-original="${ctx}/static/viewer/assets/img/tibet-1.jpg" --%> 
         			src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
         		</li>
	       	</ul>
      	</div>
   	</div>
</div>
</body>
<%@ include file="/common/player.jsp"%>
</html>
