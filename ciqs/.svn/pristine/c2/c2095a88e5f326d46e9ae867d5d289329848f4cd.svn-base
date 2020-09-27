<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>隔离、就地诊验或留验</title>
<%@ include file="/common/resource_show.jsp"%>

  	<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
  	
</head>
<body  class="bg-gary">

<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript">
/**
 * 页面初始化加载
 * wangzhy
 */
$(function(){
	$("#imgd1").hide();
	$("#CuPlayerMiniV").hide();
});
/**
 * 显示图片浏览
 * path 数据库保存的图片地址 E:/201708/20170823/1B083FEA24D6E00004df8.jpg
 * wangzhy
 */
function toImgDetail(path){
	//path=path.substring(path.indexOf('/')+1,path.length);
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
    //path=path.substring(path.indexOf('/')+1,path.length);
	$("#CuPlayerMiniV").show();
	CuPlayerMiniV(path);
}
/**
 * 关闭视频
 * wangzhy
 */
function hideVideo(){
	$("#CuPlayerMiniV").hide();
}
</script>
<div class="freeze_div_dtl">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">行政处罚  / </span></a> <a href="search.html" class="white">一般处罚</a></div>
<div class="user-info">你好sunxu，欢迎登录系统     |      退出</div>
</div>
</div>
<div class="flow-bg"  style=" height:235px;" >
<div class="flow-position2 margin-auto"  style=" height:235px;" >

<ul class="white font-18px flow-height font-weight">
<li>体温检测</li>
<li>医学排查</li>
<li>现场隔离</li>
<li>病例转诊</li>
<li></li>
<li></li>
<li></li>
<li></li>
<li></li>
</ul>
<ul class="flow-icon">
  <li class="icongreen"><div class="hour white font-12px">+5</div><img src="${ctx}/static/show/images/quartn/quartn1.png" width="80" height="80" /></li>
  <li class="iconyellow"><div class="hour white font-12px">+5</div><img src="${ctx}/static/show/images/quartn/quartn2.png" width="80" height="80" /></li>
  <li class="iconred"><div class="hour white font-12px">+5</div><img src="${ctx}/static/show/images/quartn/quartn3.png" width="80" height="80" /></li>
  <li class="icongreen"><div class="hour white font-12px">+5</div><img src="${ctx}/static/show/images/quartn/quartn4.png" width="80" height="80" /></li>
  <li class="icon5"></li>
  <li class="icon6"></li>
  <li class="icon7"></li>
  <li class="icon8"></li>
  <li class="white font-18px font-weight" > <br />
    历时：8小时</li>
</ul>
<ul class="flow-info" >
<li>张一山<br />
  <span class="font-10px" >2017-07-26  15:34</span>
</li><li>张一山<br />
  <span class="font-10px" >2017-07-26  15:34</span></li>
<li>张一山<br />
  <span class="font-10px" >2017-07-26  15:34</span></li>
<li>张一山<br />
  <span class="font-10px" >2017-07-26  15:34</span></li>
<li class="font-18px">待检查</li>
<li class="font-18px">待检查</li>
<li class="font-18px">待检查</li>
<li class="font-18px">待检查</li>
</ul>
</div>
</div>
</div>
<div class="blank_div_dtl">
</div>
<div class="margin-auto width-1200 tips" >基础信息</div>
<div class="margin-auto width-1200  data-box">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
    <tr>
      <td width="200" height="35" align="center" valign="bottom">证件类型</td>
      <td width="120" height="35" align="center" valign="bottom">证件号码</td>
      <td width="120" height="35" align="center" valign="bottom">姓名</td>
      <td width="120" height="35" align="center" valign="bottom">性别</td>
      <td width="120" height="35" align="center" valign="bottom">出生年月日</td>
      <td width="120" height="35" align="center" valign="bottom">国籍/地区</td>
      <td width="120" height="35" align="center" valign="bottom">现居住地</td>
      <td width="120" height="35" align="center" valign="bottom">国内联系方式</td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data">
    <tr>
      <td width="200" height="90" align="center" class="font-18px">${result.cardType}</td>
      <td width="120" height="90" align="center">${result.cardNo}</td>
      <td width="120" height="90" align="center">${result.name}</td>
      <td width="120" height="90" align="center">${result.sex}</td>
      <td width="120" height="90" align="center"><fmt:formatDate value="${result.birth}" type="both" pattern="yyyy-MM-dd"/></td>
      <td width="120" height="90" align="center">${result.nation}</td>
      <td width="120" height="90" align="center">${result.livePlc}</td>
      <td width="120" height="90" align="center">${result.telCn}</td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
      <!-- <td height="90" align="center" valign="middle"><span class="data-btn margin-auto">详细+</span></td> -->
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
    <tr>
      <td width="200" height="35" align="center" valign="bottom">个人职业</td>
      <td width="120" height="35" align="center" valign="bottom">直属局</td>
      <td width="120" height="35" align="center" valign="bottom">分支机构</td>
      <td width="120" height="35" align="center" valign="bottom">出入境口岸</td>
      <td width="120" height="35" align="center" valign="bottom">出入境目的地</td>
      <td width="120" height="35" align="center" valign="bottom">出入境</td>
      <td width="120" height="35" align="center" valign="bottom">出入境时间</td>
      <td width="120" height="35" align="center" valign="bottom">出入境方式</td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data">
    <tr>
      <td width="200" height="90" align="center" class="font-18px">${result.occupation}</td>
      <td width="120" height="90" align="center">${result.portOrg}</td>
      <td width="120" height="90" align="center">${result.portOrgUnder}</td>
      <td width="120" height="90" align="center">${result.enterExpPort}</td>
      <td width="120" height="90" align="center">${result.entereExpPlc}</td>
      <td width="120" height="90" align="center">${result.enterExpType}</td>
      <td width="120" height="90" align="center">${result.enterExpDate}</td>
      <td width="120" height="90" align="center">${result.enterExpMod}</td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
      <!-- <td height="90" align="center" valign="middle"><span class="data-btn margin-auto">详细+</span></td> -->
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
    <tr>
      <td width="200" height="35" align="center" valign="bottom">航班号</td>
      <td width="120" height="35" align="center" valign="bottom">出入境事由</td>
      <td width="120" height="35" align="center" valign="bottom">发现方式</td>
      <td width="120" height="35" align="center" valign="bottom">单位或联系地址</td>
      <td width="120" height="35" align="center" valign="bottom">初筛处置</td>
      <td width="120" height="35" align="center" valign="bottom">初步筛查状态</td>
      <td width="120" height="35" align="center" valign="bottom">医学排查状态</td>
      <td width="120" height="35" align="center" valign="bottom">后续监管状态</td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data">
    <tr>
      <td width="200" height="90" align="center" class="font-18px">${result.flightNo}</td>
      <td width="120" height="90" align="center">${result.enterExpCous}</td>
      <td width="120" height="90" align="center">${result.discoverWay}</td>
      <td width="120" height="90" align="center">${result.compPlc}</td>
      <td width="120" height="90" align="center">${result.firDeal}</td>
      <td width="120" height="90" align="center">${result.firDelStu}</td>
      <td width="120" height="90" align="center">${result.medDelStu}</td>
      <td width="120" height="90" align="center">${result.finChkStu}</td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
      <!-- <td height="90" align="center" valign="middle"><span class="data-btn margin-auto">详细+</span></td> -->
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
    <tr>
      <td width="200" height="35" align="center" valign="bottom">合法证件附件</td>
      <td width="120" height="35" align="center" valign="bottom">检测报警图片</td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data">
    <tr>
      <td width="200" height="90" align="center" class="font-18px">${result.certAcce}</td>
      <td width="120" height="90" align="center">${result.chkWanPic}</td>
    </tr>
  </table>
</div>
<div class="margin-auto width-1200 tips" >体温检测</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
   <c:if test="${not empty vddtl1 }">
	<c:forEach items="${vddtl1}" var="row">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">体温检测结果</td>
	    <td>排查时间</td>
	    <td colspan="2" align="left"><fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	    <td>记录人员</td>
	    <td align="left" colspan="2">${row.createUser}</td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">
	    	<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${row.fileName}')"/>
	    </td>
	  </tr>
    </c:forEach>
  </c:if>
  <c:if test="${empty vddtl1 }">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">体温检测结果</td>
	    <td>排查时间</td>
	    <td colspan="2" align="left"></td>
	    <td>记录人员</td>
	    <td align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">无图片记录</td>
	  </tr>
  </c:if>
</table>
<div class="margin-auto width-1200 tips" >医学排查</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
  <c:if test="${not empty dddtl1 }">
	  <tr>
	    <td width="300"  class="bg-gary flow-td-bord">医学排查结果</td>
	    <td>排查时间</td>
	    <td colspan="2" align="left"><fmt:formatDate value="${dddtl1.decDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	    <td>记录人员</td>
	    <td align="left" colspan="2">${dddtl1.decUser}</td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord" colspan="3">
	    	<a href='javascript:jumpPage("/ciqs/quartn/doc?id=${dddtl2.docId}&flag=dddtl1");'>口岸传染病可疑病例流行病学调查表</a>
	    </td>
	  </tr>
   </c:if>
   <c:if test="${empty dddtl1 }">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">医学排查结果</td>
	    <td>排查时间</td>
	    <td colspan="2" align="left"></td>
	    <td >记录人员</td>
	    <td align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord" colspan="3">无调查表</td>
	  </tr>
   </c:if>
   <c:if test="${not empty dddtl2 }">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">医学排查结果</td>
	    <td>排查时间</td>
	    <td colspan="2" align="left"><fmt:formatDate value="${dddtl2.decDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	    <td>记录人员</td>
	    <td align="left" colspan="2">${dddtl2.decUser}</td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord" colspan="3">
	    	<a href='javascript:jumpPage("/ciqs/quartn/doc?id=${dddtl2.docId}");'>口岸传染病可疑病例医学排查记录表</a>
	    </td>
	  </tr>
   </c:if>
    <c:if test="${empty dddtl2 }">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">医学排查结果</td>
	    <td>排查时间</td>
	    <td colspan="2" align="left"></td>
	    <td>记录人员</td>
	    <td align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord" colspan="3">无调查表</td>
	  </tr>
   </c:if>
</table>
<div class="margin-auto width-1200 tips" >现场隔离</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
 <c:if test="${not empty vddtl2 }">
	<c:forEach items="${vddtl2}" var="row">
	  <tr>
	  	<td width="300" class="bg-gary flow-td-bord">照片查看</td>
	  	<td>操作时间</td>
	    <td colspan="2" align="left"><fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	    <td>操作人员</td>
	    <td align="left" colspan="2">${row.createUser}</td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">
	    	<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${row.fileName}')"/>
	    </td>
	  </tr>
	</c:forEach>
  </c:if>
   <c:if test="${empty vddtl2 }">
	  <tr>
	  	<td width="300" class="bg-gary flow-td-bord">照片查看</td>
	  	<td>操作时间</td>
	    <td colspan="2" align="left"></td>
	    <td>操作人员</td>
	    <td align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">无图片</td>
	  </tr>
  </c:if>
  <c:if test="${not empty vddtl3 }">
	<c:forEach items="${vddtl3}" var="row">
	  <tr>
	   <td width="300" class="bg-gary flow-td-bord">录像查看</td>
	  	<td>操作时间</td>
	    <td colspan="2" align="left"><fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	    <td>操作人员</td>
	    <td align="left" colspan="2">${row.createUser}</td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">
	    	<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="录像查看" onclick="showVideo('${row.fileName}')" />
	    </td>
	  </tr>
	</c:forEach>
  </c:if>
   <c:if test="${empty vddtl3 }">
	  <tr>
	   <td width="300" class="bg-gary flow-td-bord">录像查看</td>
	  	<td>操作时间</td>
	    <td colspan="2" align="left"></td>
	    <td>操作人员</td>
	    <td align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">
	    </td>
	  </tr>
  </c:if>
</table>
<div class="margin-auto width-1200 tips" >病例转诊</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
  <c:if test="${not empty vddtl4 }">
	<c:forEach items="${vddtl4}" var="row">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">病例转诊情况</td>
	    <td>记录时间</td>
	    <td colspan="2" align="left"><fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	    <td>记录人员</td>
	    <td align="left" colspan="2">${row.createUser}</td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">
		    <img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="查看转诊单" onclick="toImgDetail('${row.fileName}')"/>
	    </td>
	  </tr>
	</c:forEach>
  </c:if>
  <c:if test="${empty vddtl4 }">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">病例转诊情况</td>
	    <td>记录时间</td>
	    <td colspan="2" align="left"></td>
	    <td>记录人员</td>
	    <td align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord">无图片记录</td>
	  </tr>
  </c:if>
  
  
  <c:if test="${not empty vddtl5 }">
	<c:forEach items="${vddtl5}" var="row">
	  <tr>
	    <td width="120" class="bg-gary flow-td-bord">病例转诊情况</td>
	    <td width="120" >记录时间</td>
	    <td width="120" colspan="2" align="left"><fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	    <td width="120" >记录人员</td>
	    <td width="120" align="left" colspan="2">${row.createUser}</td>
	    <td width="310" align="right" valign="middle" colspan="3" class="flow-td-bord">
		    <img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" title="查看录像" onclick="showVideo('${row.fileName}')"/>
	    </td>
	  </tr>
	</c:forEach>
  </c:if>
   <c:if test="${empty vddtl5 }">
	  <tr>
	    <td width="120" class="bg-gary flow-td-bord">病例转诊情况</td>
	    <td width="120"  >记录时间</td>
	    <td width="120"  colspan="2" align="left"></td>
	    <td width="120"  >记录人员</td>
	    <td width="120"  align="left" colspan="2"></td>
	    <td width="310" align="right" valign="middle" colspan="3" class="flow-td-bord">无视频记录</td>
	  </tr>
  </c:if>
</table>


<div class="margin-auto width-1200 tips" ></div>
<!-- 图片查看 -->
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

<!--酷播迷你 CuPlayerMiniV3.0 代码开始-->
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

</body>
</html>
