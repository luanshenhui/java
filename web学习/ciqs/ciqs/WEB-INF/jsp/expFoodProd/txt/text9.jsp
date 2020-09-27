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
		function hideVideo(){
			$("#CuPlayerMiniV").hide();
		}
		function showVideo(path){
			$("#CuPlayerMiniV").show();
			CuPlayerMiniV(path);
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
<%@ include file="../myOrg.jsp"%>
<div class="blank_div_dtl" style="height: 70px">
</div>
<div class="margin-auto width-1200  data-box">
<div><h2>${title}</h2>
	  <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;margin-left: 190px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
              <td width="167" height="44" align="center" class="tableLine">《出口食品生产企业安全卫生要求》内容</td>
              <td width="167" height="44" align="center" class="tableLine">企业落实要求</td>
              <td width="167" height="44" align="center" class="tableLine">现场查验</td>
              <td width="167" height="44" align="center" class="tableLine">结果判定</td>
              <td width="167" height="44" align="center" class="tableLine">说明（非必填）</td>
      </tr>
      <c:if test="${not empty list}">
    	<c:forEach items="${list}" var="row" begin="0" varStatus="st">
    	  <tr>
    	  	<c:if test="${st.index == 6}">
    	   	  <td width="167" height="44" align="center" class="tableLine" rowspan="3">${row.check_contents}</td>
    	   	  <td width="167" height="44" align="center" class="tableLine">${row.check_req}</td>
              <td width="167" height="44" align="center" class="tableLine">
               <c:if test="${not empty row.eventList}">
	              <c:forEach items="${row.eventList}" var="row2">
		              <c:if test="${row2.fileType == 1}">
		             	  <div><a href="javascript:void(0);" onclick="toImgDetail('${row2.fileName}')">查看图片文件</a></div>
		              </c:if>
	              </c:forEach>
	              <c:forEach items="${row.eventList}" var="row2">
		              <c:if test="${row2.fileType == 2}">
		             	 <div><a href="javascript:void(0);" onclick="showVideo('${row2.fileName}')">查看视频文件</a></div>
		              </c:if>
	              </c:forEach>
              </c:if>
              <c:if test="${empty row.eventList}">
		        	  无文件
              </c:if>
              </td>
              <td width="167" height="44" align="center" class="tableLine">
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 1}"> checked="checked" </c:if>/> 符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 2}"> checked="checked" </c:if>/> 不符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 3}"> checked="checked" </c:if>/> 不适用</div></td>
              <td width="167" height="44" align="center" class="tableLine">${row.check_disc}</td>
    	   	</c:if>
    	   	<c:if test="${st.index == 7 or st.index == 8}">
    	   	  <td width="167" height="44" align="center" class="tableLine">${row.check_req}</td>
              <td width="167" height="44" align="center" class="tableLine">
               <c:if test="${not empty row.eventList}">
	              <c:forEach items="${row.eventList}" var="row2">
		              <c:if test="${row2.fileType == 1}">
		             	  <div><a href="javascript:void(0);" onclick="toImgDetail('${row2.fileName}')">查看图片文件</a></div>
		              </c:if>
	              </c:forEach>
	              <c:forEach items="${row.eventList}" var="row2">
		              <c:if test="${row2.fileType == 2}">
		             	 <div><a href="javascript:void(0);" onclick="showVideo('${row2.fileName}')">查看视频文件</a></div>
		              </c:if>
	              </c:forEach>
              </c:if>
              <c:if test="${empty row.eventList}">
		        	  无文件
              </c:if>
              </td>
              <td width="167" height="44" align="center" class="tableLine">
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 1}"> checked="checked" </c:if>/> 符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 2}"> checked="checked" </c:if>/> 不符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 3}"> checked="checked" </c:if>/> 不适用</div></td>
              <td width="167" height="44" align="center" class="tableLine">${row.check_disc}</td>
    	   	</c:if>
    	   	<c:if test="${st.index != 8 and st.index != 6 and st.index != 7}">
    	   	<td width="167" height="44" align="center" class="tableLine" >${row.check_contents}</td>
    	   	  <td width="167" height="44" align="center" class="tableLine">${row.check_req}</td>
              <td width="167" height="44" align="center" class="tableLine">
               <c:if test="${not empty row.eventList}">
	              <c:forEach items="${row.eventList}" var="row2">
		              <c:if test="${row2.fileType == 1}">
		             	  <div><a href="javascript:void(0);" onclick="toImgDetail('${row2.fileName}')">查看图片文件</a></div>
		              </c:if>
	              </c:forEach>
	              <c:forEach items="${row.eventList}" var="row2">
		              <c:if test="${row2.fileType == 2}">
		             	 <div><a href="javascript:void(0);" onclick="showVideo('${row2.fileName}')">查看视频文件</a></div>
		              </c:if>
	              </c:forEach>
              </c:if>
              <c:if test="${empty row.eventList}">
		        	  无文件
              </c:if>
              </td>
              <td width="167" height="44" align="center" class="tableLine">
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 1}"> checked="checked" </c:if>/> 符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 2}"> checked="checked" </c:if>/> 不符合</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${row.check_result == 3}"> checked="checked" </c:if>/> 不适用</div></td>
              <td width="167" height="44" align="center" class="tableLine">${row.check_disc}</td>
		  	</c:if>
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
	<div id="CuPlayerMiniV" style="width:620px;height:500px;position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;">
	<div style="width:30px;margin:0px 500px 0px 602px;background:white;cursor: pointer;" onclick="hideVideo()">关闭</div>
	<div id="CuPlayer" style="position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;"> 
	<strong>提示：您的Flash Player版本过低！</strong> 
	<script type=text/javascript>
	function CuPlayerMiniV(path){
		var so = new SWFObject("/ciqs/cuplayer/CuPlayerMiniV3_Black_S.swf","CuPlayer","600","400","9","#000000");
		so.addParam("allowfullscreen","true");
		so.addParam("allowscriptaccess","always");
		so.addParam("wmode","opaque");
		so.addParam("quality","high");
		so.addParam("salign","lt");
		so.addVariable("CuPlayerFile","http://localhost:7001/ciqs/showVideo?imgPath="+path);
		so.addVariable("CuPlayerImage","/ciqs/cuplayer/Images/flashChangfa2.jpg");
		so.addVariable("CuPlayerLogo","/ciqs/cuplayer/Images/Logo.png");
		so.addVariable("CuPlayerShowImage","true");
		so.addVariable("CuPlayerWidth","600");
		so.addVariable("CuPlayerHeight","400");
		so.addVariable("CuPlayerAutoPlay","false");
		so.addVariable("CuPlayerAutoRepeat","false");
		so.addVariable("CuPlayerShowControl","true");
		so.addVariable("CuPlayerAutoHideControl","false");
		so.addVariable("CuPlayerAutoHideTime","6");
		so.addVariable("CuPlayerVolume","80");
		so.addVariable("CuPlayerGetNext","false");
		so.write("CuPlayer");
	}
	</script>
	</div>
	</div>
    </div> 
</div>
</body>
</html>
