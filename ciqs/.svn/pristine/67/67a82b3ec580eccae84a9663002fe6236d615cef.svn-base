<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>原产地证书签发行政确认全过程执法记录</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
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
		
		function toImgDetail(path){
			url = "/ciqs/showVideo?imgPath="+path;
			$("#imgd1").attr("src",url);
			$("#imgd1").click();
		}
// 		function hideVideo(){
// 			$("#CuPlayerMiniV").hide();
// 		}
// 		function showVideo(path){
// 			$("#CuPlayerMiniV").show();
// 			CuPlayerMiniV(path);
// 		}
		
		function loading(){
			location.href="downPdfQt"+location.search;
		}
	</script>
<style type="text/css">
<!--
.tableLine {
	border: 1px solid #000;
}
.fangxingLine {
	font-size:10;
	margin-left:5px;
	margin-right:5px;
	border: 2px solid #000;
	font-weight:900;
	padding-left: 3px;
	padding-right: 3px;
}
.tableLine2 {
	border: 1px solid #000;
	padding-left: 10px; 
}
.tableLine_noright {
	padding-left: 10px;
	border-top-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
}
.tableLine_noleft {
	padding-left: 10px;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-top-color: #000;
	border-right-color: #000;
	border-bottom-color: #000;
}
/* @media print { */
/* .noprint{display:none} */
/* } */
-->
</style>
</head>
<body  class="bg-gary">
<div class="freeze_div_list">
		<div class="title-bg">
			<div class=" title-position margin-auto white">
				<div class="title">
				<span class="font-24px" style="color:white;">行政许可 /</span><a id="title_a" style="color: white;" href="/ciqs/expFoodPOF/expFoodList">出口食品生产企业备案</a>
				</div>
				<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
			</div>
		</div>
	</div>
<%-- <%@ include file="../myOrg.jsp"%> --%>
<div class="blank_div_dtl" style="height: 70px">
</div>
<div class="margin-auto width-1200  data-box">
<div><h2>其他</h2>
	  <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;margin-left: 190px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
              <td width="167" height="44" align="center" class="tableLine">录入内容</td>
              <td width="167" height="44" align="center" class="tableLine">现场查验</td>
              <td width="167" height="44" align="center" class="tableLine">结果判定</td>
              <td width="167" height="44" align="center" class="tableLine">说明</td>
      </tr>
      <c:if test="${not empty list}">
    	<c:forEach items="${list}" var="row">
    	  <tr>
    	   	  <td width="167" height="44" align="center" class="tableLine" >${row.option5}</td>
              <td width="167" height="44" align="center" class="tableLine">
		              <c:if test="${not empty row.option1}">
		             	  <div><a href="javascript:void(0);" onclick="toImgDetail('${row.option91}')">查看图片文件</a></div>
		              </c:if>
		              <c:if test="${not empty row.option2}">
		             	 <div><a href="javascript:void(0);" onclick="showVideo('${row.option92}')">查看视频文件</a></div>
		              </c:if>
              <c:if test="${empty row.option1 and empty row.option2}">
		        	  无文件
              </c:if>
              </td>
              <td width="167" height="44" align="center" class="tableLine">
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.option3 == 0}"> checked="checked" </c:if>/> 符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.option3 == 1}"> checked="checked" </c:if>/> 不符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.option3 == 2}"> checked="checked" </c:if>/> 不适用</div></td>
		  	  <td width="167" height="44" align="center" class="tableLine">${row.option4}</td>
		  </tr>
    	</c:forEach>
       </c:if>
      </table>
           <!-- 图片查看 -->
		<div class="row" style="z-index:200000;">
	 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
	      <div class="docs-galley" style="z-index:200000;">
	        	<ul class="docs-pictures clearfix" style="z-index:200000;">
	          	<li>
	          	<img id="imgd1" style="z-index:200000;"
	          	src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg"  />
	          	</li>
	        	</ul>
	      </div>
	   	</div>
	</div>  
    </div> 
</div>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:400px;padding-bottom: 10px;">
			<input type="button" class="search-btn" style="display: inline;" value="下载"  onclick="loading()"/>
			<input type="button" class="search-btn" style="display: inline;" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
	<%@ include file="/common/player.jsp"%>
</body>
</html>
