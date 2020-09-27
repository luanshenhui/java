<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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
// 			path=path.substring(path.indexOf('/')+1,path.length);
			url = "/ciqs/showVideo?imgPath="+path;
			$("#imgd1").attr("src",url);
			$("#imgd1").click();
		}
		
		function showVideo(path){
// 		    path=path.substring(path.indexOf('/')+1,path.length);
			$("#CuPlayerMiniV").show();
			CuPlayerMiniV(path);
		}
		
		function hideVideo(){
			$("#CuPlayerMiniV").hide();
		}
		
		function fileSubmit(){
			$("#uploadForm").attr("action","addVideoEventModel");
			$("#uploadForm").submit();
		
		/* 	var id=$("#id").val();
			$.ajax({
			url:'/ciqs/common/insertVideoEventModel',
			type:'POST',
			cache:false,
			data:new FormData($('#uploadForm')[0]),
			processData:false,
			contentType:false,
			success:function(data){
				if(data=="success"){
					window.location.href="/ciqs/origplace/showOrig?id="+id;
				}
			}
			}).done(function(res){}).fail(function(res){}); */
		}
	</script>
<title>原产地证书签发行政确认全过程执法记录</title>
<style>
.table-flow tr td {
    height: 60px;
    line-height: 30px;
    padding-left: 30px;
    padding-right: 30px;
}
</style>
</head>
<body  class="bg-gary">
<%@ include file="myOrig.jsp"%>
<div class="blank_div_dtl" ></div>
<div class="margin-auto width-1200  data-box">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
    <tr>
      <td width="8%" height="35" align="center" valign="bottom">申请单位</td>
	      <td width="8%" height="35" align="center" valign="bottom">申请日期</td>
	      <td width="8%" height="35" align="center" valign="bottom">企业备案号</td>
	      <td width="8%" height="35" align="center" valign="bottom">证书号</td>
	      <td width="8%" height="35" align="center" valign="bottom">证书种类</td>
	      <td width="8%" height="35" align="center" valign="bottom">直属局</td>
	      <td width="8%" height="35" align="center" valign="bottom">分支机构</td>
	      <td width="8%" height="35" align="center" valign="bottom">发票号</td>
	      <td width="8%" height="35" align="center" valign="bottom">收货人</td>
	      <td width="8%" height="35" align="center" valign="bottom">目的国家</td>
	      <td width="8%" height="35" align="center" valign="bottom">出运日期</td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
  </table>
  
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data">
			<tr>
				<td width="8%" height="90" align="center" class="font-18px">${obj.dec_org_name}</td>
				<td width="8%" height="90" align="center"><fmt:formatDate
						value="${obj.apply_date}" type="both" pattern="yyyy-MM-dd" /></td>
				<td width="8%" height="90" align="center">${obj.org_reg_no}</td>
				<td width="8%" height="90" align="center">${obj.cert_no}</td>
				<td width="8%" height="90" align="center" class=" green">${obj.cert_type}</td>
				<td width="8%" height="90" align="center">${obj.org_code}</td>
				<td width="8%" height="90" align="center">${obj.dept_code}</td>
				<td width="8%" height="90" align="center">${obj.receipt_no}</td>
				<td width="8%" height="90" align="center">${obj.consignee_cname}</td>
				<td width="8%" height="90" align="center">${obj.dest_country}</td>
				<td width="8%" height="90" align="center"><fmt:formatDate
						value="${obj.shipping_date}" type="both" pattern="yyyy-MM-dd" />
						</td>
				<td></td>
			</tr>
		</table>
</div>
<div class="margin-auto width-1200 tips" style="font: initial;color: green;">申请书信息</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
  <tr>
  	<td>申请单位 : ${obj.dec_org_name}</td>
  	<td>证书号 :${obj.cert_no}</td>
  	<td>证书种类 :${obj.cert_type}</td>
  </tr>
  <tr>
  	<td>发票号码 :${obj.receipt_no}</td>
  	<td>商品FOB总值（美元）:${obj.apply_fob_val}</td>
  	<td>企业备案 :${obj.org_reg_no}</td>
  </tr>
  <tr>
  	<td>最终目的国/地区 :${obj.dest_country}</td>
  	<td>中转国/地区  :${obj.transfer_country}</td>
  	<td>贸易方式 :${obj.trade_mode}</td>
  </tr>
  <tr>	
  	<td>出运日期 :<fmt:formatDate value="${obj.shipping_date}" type="both" pattern="yyyy-MM-dd"/></td>
  	<td>产品序号（商品列表，一份证书可对应多个商品） :${obj.cag_seq}</td>
  	<td>HS编码 :${obj.hs_code}</td>
  </tr> 
  <tr>	
  	<td>商品名称:${obj.cag_name}</td>
  	<td>产品进口成份 :${obj.cag_imp_comp}</td>
  	<td>数/重量及单位 :${obj.num_weight}</td>
  </tr> 
  <tr>	
  	<td>FOB值(USD) :${obj.fob_val}</td>
  	<td>生产企业/联系人/联系电话 :${obj.prod_comp}</td>
  	<td></td>
  </tr> 
</table>
<div class="margin-auto width-1200 tips" style="font: initial;color: green;">发票信息</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
  <tr>
  	<td>收货人:${obj.consignee_cname}</td>
	<td>证书号:${obj.cert_no}</td>
	<td>发票号:${obj.receipt_no}</td>
 </tr> 
 <tr>		
	<td>发票日期:<fmt:formatDate value="${obj.receipt_date}" type="both" pattern="yyyy-MM-dd"/></td>
	<td>唛头及包装号:${obj.mat_no}</td>
	<td>数量及货物描述:${obj.num_cag_disc}</td>
 </tr> 
 <tr>	
	<td>价格条款:${obj.pric_item}</td>
	<td>货物单价及总值:${obj.cag_pric}</td>
	<td>特殊条款:${obj.spec_item}</td>
  </tr>
</table>
<div class="margin-auto width-1200 tips" style="font: initial;color: green;">证书信息</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
  <tr>
	 <td> 出口商:${obj.exp_comp}</td>
	<td>收货人:${obj.consignee_cname}</td>
	<td>生产商:${obj.prod_comp}</td>
</tr> 
 <tr>	
	<td>运输方式和路线:${obj.trans_type}</td>
	<td>目的国家:${obj.purpose_country}</td>
	<td>唛头及包装号:${obj.mat_no}</td>
 </tr> 
 <tr>	
	<td>商品名称:${obj.cag_name}</td>
	<td>包装数量及种类:${obj.pack_num}</td>
	<td>HS编码（列表显示）:${obj.hs_code}</td>
</tr> 
 <tr>	
	<td>原产地标准:${obj.orig_place_std}</td>
	<td>毛重或其他数量:${obj.m_weight}</td>
	<td>发票号码及日期:${obj.receipt_no}/<fmt:formatDate value="${obj.receipt_date}" type="both" pattern="yyyy-MM-dd"/></td>
</tr> 
 <tr>	
	<td>出口商申明:${obj.exp_stat}</td>
	<td>签证当局证明:${obj.visa_stat}</td>
	<td>备注:${obj.rmk}</td>
  </tr>
</table>
<div class="margin-auto width-1200 tips" style="font: initial;color: green;">签证调查环节</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
<!--   <tr> -->
<!--     <td width="300" class=" bg-gary flow-td-bord">调查时间</td> -->
<!--     <td class="flow-td-bord"></td> -->
<!--     <td width="300" align="right" valign="middle"  class="flow-td-bord"></td> -->
<!--   </tr> -->
<!--   <tr> -->
<!--     <td width="300" class="bg-gary flow-td-bord">调查人员</td> -->
<!--     <td class="flow-td-bord"></td> -->
<!--     <td width="300" align="right" valign="middle"  class="flow-td-bord"></td> -->
<!--   </tr> -->
   <c:if test="${not empty obj.qvCheckCertList}">
    	<c:forEach items="${obj.qvCheckCertList}" var="row">
		   <tr>
		    <td width="300" class="bg-gary flow-td-bord">书面调查</td>
		   	<td class="flow-td-bord">调查人员${row.createUser}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 调查时间
		     <fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd"/>
		    </td>
		    <td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" onclick="toImgDetail('${row.fileName}')" width="42" height="42" title="书面调查"/></td>
		  </tr>
    	</c:forEach>
   </c:if>
   <c:if test="${empty obj.qvCheckCertList}">
	   <tr>
	    <td width="300" class="bg-gary flow-td-bord">书面调查</td>
	    <td class="flow-td-bord"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord">无书面调查</td>
	  </tr>
    </c:if>
    <tr>
    <td width="300" class="bg-gary flow-td-bord">实地调查</td>
    <td class="flow-td-bord">${obj.check_cert}</td>
    <td width="300" align="right" valign="middle"  class="flow-td-bord"></td>
  </tr>
    <c:if test="${not empty obj.qvAllList}">
    	<c:forEach items="${obj.qvAllList}" var="row">
    	  <tr>
	    	<td width="300" class="bg-gary flow-td-bord">原材料和零配件的存放情况、外包装上品名及生产企业名称、进口报关单及采购发票</td>
		    <td class="flow-td-bord">调查人员${row.createUser}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 调查时间
		     <fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd"/>
		    </td>
    		<td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" onclick="toImgDetail('${row.fileName}')"  width="42" height="42" /></td>
		  </tr>
    	</c:forEach>
    </c:if>
    <c:if test="${empty obj.qvAllList}">
	   <tr>
	    <td width="300" class="bg-gary flow-td-bord">原材料和零配件的存放情况、外包装上品名及生产企业名称、进口报关单及采购发票</td>
	    <td class="flow-td-bord"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord">无图片</td>
	  </tr>
    </c:if>
     <c:if test="${not empty obj.qvMainList}">
    	<c:forEach items="${obj.qvMainList}" var="row">
    	  <tr>
	    	<td width="300" class="bg-gary flow-td-bord">主要加工工序</td>
		    <td class="flow-td-bord">调查人员${row.createUser}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 调查时间
		     <fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd"/></td>
    		<td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" onclick="toImgDetail('${row.fileName}')" width="42" height="42" /></td>
		  </tr>
    	</c:forEach>
    </c:if>
    <c:if test="${empty obj.qvMainList}">
	  <tr>
	     <td width="300" class="bg-gary flow-td-bord">主要加工工序</td>
	     <td class="flow-td-bord"></td>
	     <td width="300" align="right" valign="middle"  class="flow-td-bord">无图片</td>
	  </tr>
   </c:if>
   <c:if test="${not empty obj.qvGoodList}">
    	<c:forEach items="${obj.qvGoodList}" var="row">
    	  <tr>
	    	<td width="300" class="bg-gary flow-td-bord">成品</td>
		    <td class="flow-td-bord">调查人员${row.createUser}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 调查时间
		     <fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd"/></td>
    		<td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" onclick="toImgDetail('${row.fileName}')" width="42" height="42" /></td>
		  </tr>
    	</c:forEach>
   </c:if>
   <c:if test="${empty obj.qvGoodList}">
	   <tr>
	    <td width="300" class="bg-gary flow-td-bord">成品</td>
	    <td class="flow-td-bord"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord">无图片</td>
	  </tr>
   </c:if>
   <c:if test="${not empty obj.qvMatList}">
    	<c:forEach items="${obj.qvMatList}" var="row">
    	  <tr>
	    	<td width="300" class="bg-gary flow-td-bord">包装及唛头</td>
		    <td class="flow-td-bord">包装及唛头:${obj.mat_no}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查人员${row.createUser}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 调查时间:
		     <fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd"/></td>
    		<td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" title="包装及唛头"  onclick="toImgDetail('${row.fileName}')" width="42" height="42" /></td>
		  </tr>
    	</c:forEach>
   </c:if>
    <c:if test="${empty obj.qvMatList}">
	   <tr>
	    <td width="300" class="bg-gary flow-td-bord">包装及唛头</td>
	    <td class="flow-td-bord">${obj.mat_no}</td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord">无图片</td>
	  </tr>
    </c:if>
   <tr>
    <td width="300" class="bg-gary flow-td-bord">原产地业务实地调查记录单</td>
	<td class="flow-td-bord"><a href="/ciqs/origplace/jumpText?id=${obj.id}&main_id=${obj.main_id}">原产地业务实地调查记录单</a></td>
    <td width="300" align="right" valign="middle"  class="flow-td-bord"></td>
  </tr>
   <tr>
    <td width="300" class="bg-gary flow-td-bord">异常或争议视频上传</td>
   <td class="flow-td-bord"></td>
    <td width="300" align="right" valign="middle"  class="flow-td-bord">
  		<form id="uploadForm" method="post" enctype="multipart/form-data">
    		<input id="file" type="file" name="file" style="margin-left: -26px;"/>
    		<input id="procMainId" type="hidden" name="procMainId" value="${obj.main_id}"/>
    		<input id="id" type="hidden" name="id" value="${obj.id}"/>
    		<input id="procType" type="hidden" name="procType" value="V_OC_C_M_10"/>
    		<input id="fileType" type="hidden" name="fileType" value="2"/>
    		<button id="upload" style="margin-top: -25px" onclick="fileSubmit()">上传</button>
    	</form>
    </td>
  </tr>
   <c:if test="${not empty obj.qvVideoList}">
    	<c:forEach items="${obj.qvVideoList}" var="row">
    	 <tr>
		    <td width="300" class="bg-gary flow-td-bord">视频查看</td>
		    <td class="flow-td-bord">调查人员${row.createUser}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 调查时间
		    <fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd"/>
		    </td>
		    <td width="300" align="right" valign="middle"  class="flow-td-bord">
		    <img onclick="showVideo('${row.fileName}')" src="../static/show/images/video-btn.png" title="查看视频" width="42" height="42" />
		    </td>
		  </tr>
    	</c:forEach>
   </c:if>
    <c:if test="${empty obj.qvVideoList}">
		<tr>
		   <td width="300" class="bg-gary flow-td-bord">视频查看</td>
		   <td class="flow-td-bord"></td>
		   <td width="300" align="right" valign="middle"  class="flow-td-bord">无视频</td>
		</tr>
   </c:if>
</table>
<div class="margin-auto width-1200 tips" style="font: initial;color: green;">签证环节</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
   <c:if test="${not empty obj.qvQianfaList}">
    	<c:forEach items="${obj.qvQianfaList}" var="row">
    	  <tr>
		    <td width="300" class=" bg-gary flow-td-bord">签发时间</td>
		    <td class="flow-td-bord"><fmt:formatDate value="${row.createDate}" type="both" pattern="yyyy-MM-dd"/></td>
		    <td width="300" align="right" valign="middle"  class="flow-td-bord"></td>
		  </tr>
		  <tr>
		    <td width="300" class="bg-gary flow-td-bord">签发人员</td>
		    <td class="flow-td-bord">${row.createUser}</td>
		    <td width="300" align="right" valign="middle"  class="flow-td-bord"></td>
		  </tr>
    	  <tr>
	    	<td width="300" class="bg-gary flow-td-bord">签发证书</td>
		    <td class="flow-td-bord"></td>
    		<td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" title="签发证书" onclick="toImgDetail('${row.fileName}')" width="42" height="42" /></td>
		  </tr>
      </c:forEach>
   </c:if>
   <c:if test="${empty obj.qvQianfaList}">
<!--    	   <tr> -->
<!-- 		  <td width="300" class=" bg-gary flow-td-bord">签发时间</td> -->
<!-- 		  <td class="flow-td-bord"></td> -->
<!-- 		  <td width="300" align="right" valign="middle"  class="flow-td-bord"></td> -->
<!-- 		</tr> -->
<!-- 		<tr> -->
<!-- 		 <td width="300" class="bg-gary flow-td-bord">签发人员</td> -->
<!-- 		 <td class="flow-td-bord"></td> -->
<!-- 		 <td width="300" align="right" valign="middle"  class="flow-td-bord"></td> -->
<!-- 	   </tr> -->
	   <tr>
	     <td width="300" class="bg-gary flow-td-bord">签发证书</td>
	     <td class="flow-td-bord"></td>
	     <td width="300" align="right" valign="middle"  class="flow-td-bord">无图片</td>
	  </tr>
   </c:if>
</table>
<div class="margin-auto width-1200 tips" style="font: initial;color: green;">归档环节</div>
<table width="100%" border="0" class="width-1200 margin-auto table-flow">
  <tr>
    <td width="300" class=" bg-gary flow-td-bord">归档时间</td>
    <td class="flow-td-bord"><fmt:formatDate value="${obj.file_date}" type="both" pattern="yyyy-MM-dd"/></td>
    <td width="300" align="right" valign="middle"  class="flow-td-bord"></td>
  </tr>
  <tr>
    <td width="300" class="bg-gary flow-td-bord">归档人员</td>
    <td class="flow-td-bord">${obj.fiel_psn}</td>
    <td width="300" align="right" valign="middle"  class="flow-td-bord"></td>
  </tr>
   <tr>
    <td width="300" class="bg-gary flow-td-bord">证书查看</td>
    <td class="flow-td-bord"></td>
    <td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" onclick="toImgDetail('${obj.cert_file}')" width="42" height="42" /></td>
  </tr>
   <c:if test="${not empty obj.qvOrderList}">
    	<c:forEach items="${obj.qvOrderList}" var="row">
    	  <tr>
	    	<td width="300" class="bg-gary flow-td-bord">其它材料</td>
		    <td class="flow-td-bord"></td>
    		<td width="300" align="right" valign="middle"  class="flow-td-bord"><img src="../static/show/images/photo-btn.png" onclick="toImgDetail('${row.fileName}')" title="其它材料" width="42" height="42" /></td>
		  </tr>
      </c:forEach>
   </c:if>
   <c:if test="${empty obj.qvOrderList}">
	  <tr>
	    <td width="300" class="bg-gary flow-td-bord">其它材料</td>
	    <td class="flow-td-bord"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord">无图片</td>
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
	          	<img id="imgd1" style="z-index:200000;"
	          	src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg"  />
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
	<script type="text/javascript">
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
