<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>隔离、留验与就地诊验</title>
<%@ include file="/common/resource_show.jsp"%>

  	<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
  	<style>
/*   	.title a:link, a:visited { */
/* 	    color:white; */
/* 	    text-decoration: none; */
/* 	} */
  	.muy{
/*   		border-bottom: 1px solid #dcdcdc;padding-right: 20px;height:60px */
  	}
  	.st{
/*   		line-height:50px; */
  	}
  	 #title_a{color:#ccc}
	 #title_a:hover{
	 	color:white;
	 }
	 
	 img{
	     margin-right: 15px;
	 }
  	</style>
  	
</head>
<body  class="bg-gary">

<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<script type="text/javascript">

$.fn.getHour=function(startDate,endDate,flg,b){
		if(!endDate || !startDate){
			return $(this).html("-");
		}	
		var date1 = new Date(startDate.replace(/-/g,"/")); 
		var date2;
		if(b){
			date2=new Date();
		}else{
			date2 = new Date(endDate.replace(/-/g,"/"));
		}
		if(!flg){
			flg="";
		}
		var hour = null;
		hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
		hour = hour.toFixed(2);
		if(hour){
			$(this).html(flg+hour);
		}else{
			$(this).html("-");
		}
	};
/**
 * 页面初始化加载
 * wangzhy
 */
$(function(){
	$("#imgd1").hide();
	$("#CuPlayerMiniV").hide();
	
	   $.ajax({
    			url:"detailView"+location.search+"&math="+Math.random(),
    			type:"get",
    			dataType:"json",
    			success:function(data){
    				var result=data.result;
    				$("#t1").html(result.cardType+(result.cardTypeRmk?"("+result.cardTypeRmk+")":""));
    				$("#t2").html(result.cardNo);
    				$("#t3").html(result.name);
    				$("#t4").html(result.sex==1?"男":"女");
    				$("#t5").html(result.birthDay);
    				$("#t6").html(result.nation);
    				$("#t7").html(result.livePlc);
    				$("#t8").html(result.telCn);
    				
    				$("#t2_1").html(result.occupation);
    				$("#t2_2").html(result.portOrg);
    				$("#t2_3").html(result.portOrgUnder);
    				$("#t2_4").html(result.enterExpPort);
    				$("#t2_5").html(result.entereExpPlc);
    				$("#t2_6").html(result.enterExpMod);
    				$("#t2_7").html(result.enterExpDate);
    				$("#t2_8").html(getKeyName(result.enterExpType));
    				
    				$("#t3_1").html(result.flightNo);
    				$("#t3_2").html(result.enterExpCous);
    				$("#t3_3").html(result.discoverWay);
    				$("#t3_4").html(result.compPlc);
    				$("#t3_5").html(result.firDeal);
    				$("#t3_6").html(result.firDelStu);
    				$("#t3_7").html(result.medDelStu);
    				$("#t3_8").html(result.finChkStu);
    				
    				$("#t4_1").html(result.certAcce);
    				$("#t4_2").html(result.chkWanPic);
    				var video=data.videoEventModels;
    				if(video){
						  for(var i=0;i<video.length;i++){
						  	 if(video[i].procType=="V_DD_T_L_1"){
						  	 	var t= "<div class='muy st'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	  	$("#l1_1").find("td").eq(1).append("<div class='muy'>排查时间<div>");
						  	  	$("#l1_1").find("td").eq(2).append("<div class='muy'>"+new Date(video[i].createDate).toLocaleDateString()+"</div>");
						  	  	$("#l1_1").find("td").eq(3).append("<div class='muy'>记录人员<div>");
						  	  	$("#l1_1").find("td").eq(4).append("<div class='muy'>"+video[i].createUser+"</div>");
						  	  	$("#l1_1").find("td").eq(5).append(t);
						  	  	if(!$("#qt_1").html()){
						  	 		$("#qtw_1").html(video[i].createUser);
						  	 		$("#qt_1").html(video[i].createStrDate);
						  	 	}else if(new Date(video[i].createStrDate) > new Date($("#qt_1").html())){
						  	 		$("#qtw_1").html(video[i].createUser);
						  	 		$("#qt_1").html(video[i].createStrDate);
						  	 	}
						  	 }
						  	 if(video[i].procType=="V_DD_T_L_2"){
						  	 	var t= "<div class='muy st'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	  	$("#l2_2_1").find("td").eq(1).append("<div class='muy'>排查时间<div>");
						  	  	$("#l2_2_1").find("td").eq(2).append("<div class='muy'>"+new Date(video[i].createDate).toLocaleDateString()+"</div>");
						  	  	$("#l2_2_1").find("td").eq(3).append("<div class='muy'>记录人员<div>");
						  	  	$("#l2_2_1").find("td").eq(4).append("<div class='muy'>"+video[i].createUser+"</div>");
						  	  	$("#l2_2_1").find("td").eq(5).append(t);
						  	  	priSelf(3,video[i]);
						  	 }
						  	 if(video[i].procType=="V_DD_T_L_3"){
						  	  	var t= "<div><img src='/ciqs/static/show/images/video-btn.png' onclick='showVideo(\""+video[i].fileName+"\")'/></div>";
						  	  	$("#l2_2_2").find("td").eq(1).append("<div>排查时间</div>");
						  	  	$("#l2_2_2").find("td").eq(2).append("<div>"+new Date(video[i].createDate).toLocaleDateString()+"</div>");
						  	  	$("#l2_2_2").find("td").eq(3).append("<div>记录人员</div>");
						  	  	$("#l2_2_2").find("td").eq(4).append("<div>"+video[i].createUser+"</div>");
						  	  	$("#l2_2_2").find("td").eq(5).append(t);
						  	  	priSelf(3,video[i]);
						  	 }
						  	 if(video[i].procType=="V_DD_T_L_4"){
						  	  	var t= "<div class='muy st'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	  	$("#l2_3_1").find("td").eq(1).append("<div>排查时间</div>");
						  	  	$("#l2_3_1").find("td").eq(2).append("<div>"+new Date(video[i].createDate).toLocaleDateString()+"</div>");
						  	  	$("#l2_3_1").find("td").eq(3).append("<div>记录人员</div>");
						  	  	$("#l2_3_1").find("td").eq(4).append("<div>"+video[i].createUser+"</div>");
						  	  	$("#l2_3_1").find("td").eq(5).append(t);
						  	  	priSelf(4,video[i]);
						  	 }
						  	 if(video[i].procType=="V_DD_T_L_5"){
						  	  	var t= "<div><img src='/ciqs/static/show/images/video-btn.png' onclick='showVideo(\""+video[i].fileName+"\")'/></div>";
						  	  	$("#l2_3_2").find("td").eq(1).append("<div>排查时间</div>");
						  	  	$("#l2_3_2").find("td").eq(2).append("<div>"+new Date(video[i].createDate).toLocaleDateString()+"</div>");
						  	  	$("#l2_3_2").find("td").eq(3).append("<div>记录人员</div>");
						  	  	$("#l2_3_2").find("td").eq(4).append("<div>"+video[i].createUser+"</div>");
						  	  	$("#l2_3_2").find("td").eq(5).append(t);
						  	  	priSelf(4,video[i]);
						  	 };
						  	 
					      };
    				}
					var dddtl3=data.dddtl3;  
					if(dddtl3){
					var h2= "<div><a href='javascript:jumpPage(\""+"/ciqs/quartn/findtext?t=1&id=${id}"+"\");'>口岸传染病疑似病例转诊单</a></div>";
						$("#l2_3_3").find("td").eq(1).append("排查时间");
						$("#l2_3_3").find("td").eq(2).append(new Date(dddtl3.decDate).toLocaleDateString());
						$("#l2_3_3").find("td").eq(3).append("记录人员");
						$("#l2_3_3").find("td").eq(4).append(dddtl3.decUser);
						$("#l2_3_3").find("td").eq(5).append(h2);
						if(!$("#qt_4").text() || new Date(dddtl3.modelDecDate) > new Date($("#qt_4").text())){
							$("#qtw_4").html(dddtl3.decUser);
							$("#qt_4").html(dddtl3.modelDecDate);
						}
					}else{
						$("#l2_3_3").remove();
					}     				
    				
					var dddtl1=data.dddtl1;  
					if(dddtl1){
						var h= "<div><a href='javascript:jumpPage(\""+"/ciqs/quartn/doc?id="+dddtl1.docId+"&flag=dddtl1"+"\");'>口岸传染病可疑病例流行病学调查表</a></div>";
					 	$("#pc_1").find("td").eq(1).append("排查时间");
					 	$("#pc_1").find("td").eq(2).append(new Date(dddtl1.decDate).toLocaleDateString());
						$("#pc_1").find("td").eq(3).append("记录人员");
						$("#pc_1").find("td").eq(4).append(dddtl1.decUser);
						$("#pc_1").find("td").eq(5).append(h);
						$("#qtw_2").html(dddtl1.decUser);
						$("#qt_2").html(dddtl1.modelDecDate); 
					}else{
						$("#pc_1").remove();
					}   
					var dddtl2=data.dddtl2;  
					if(dddtl2){
						var h2= "<div><a href='javascript:jumpPage(\""+"/ciqs/quartn/doc?id="+dddtl2.docId+"&flag=dddtl2"+"\");'>口岸传染病可疑病例医学排查记录表</a></div>";
					 	$("#pc_2").find("td").eq(1).append("排查时间");
					 	$("#pc_2").find("td").eq(2).append(new Date(dddtl2.decDate).toLocaleDateString());
						$("#pc_2").find("td").eq(3).append("记录人员");
						$("#pc_2").find("td").eq(4).append(dddtl2.decUser);
						$("#pc_2").find("td").eq(5).append(h2);
						if(!$("#qt_2").text() || new Date(dddtl2.modelDecDate) > new Date($("#qt_2").text())){
							$("#qtw_2").html(dddtl2.decUser);
							$("#qt_2").html(dddtl2.modelDecDate);
						}
					}else{
						$("#pc_2").remove();
					}  
					var dddtl4=data.dddtl4;  
					if(dddtl4){
						var h2= "<div><a href='javascript:jumpPage(\""+"/ciqs/quartn/findtext?t=2&id=${id}"+"\");'>采样知情同意书</a></div>";
					 	$("#pc_3").find("td").eq(1).append("排查时间");
					 	$("#pc_3").find("td").eq(2).append(new Date(dddtl4.decDate).toLocaleDateString());
						$("#pc_3").find("td").eq(3).append("记录人员");
						$("#pc_3").find("td").eq(4).append(dddtl4.decUser);
						$("#pc_3").find("td").eq(5).append(h2);
						if(!$("#qt_2").text() || new Date(dddtl4.modelDecDate) > new Date($("#qt_2").text())){
							$("#qtw_2").html(dddtl4.decUser);
							$("#qt_2").html(dddtl4.modelDecDate);
						}
					}else{
						$("#pc_3").remove();
					}  
					
					
					$("#flow_quartn").children().eq(0).find("div").getHour($("#qt_1").text(),$("#qt_2").text(),"+");
					$("#flow_quartn").children().eq(1).find("div").getHour($("#qt_2").text(),$("#qt_3").text(),"+");
					$("#flow_quartn").children().eq(2).find("div").getHour($("#qt_3").text(),$("#qt_4").text(),"+");
// 					var b=false;
// 					if(!$("#qt_4").text()){b=true;}
// 					$("#quartn_all").getHour($("#qt_1").text(),$("#qt_4").text()==""?new Date().toLocaleDateString()+" "+new Date().toLocaleTimeString().substring(2,7):$("#qt_4").text(),null,b);
					  $("#quartn_all").html(ciqFormatTime(1,4,"qt_"));
					  if($("#qt_1").text().toString().length==0){
 			       		 $(".del-1").remove();
 			          }
 			          if($("#qt_2").text().toString().length==0){
 			       		 $(".del-2").remove();
 			          }
 			          if($("#qt_3").text().toString().length==0){
 			       		 $(".del-3").remove();
 			          }
 			          if($("#qt_4").text().toString().length==0){
 			       		 $(".del-4").remove();
 			          }
 			          if($("#psp_1").children()){
 			          	 $("#psp_1").parent().remove();
 			          }
 			          if($("#psp_2").children()){
 			          	 $("#psp_2").parent().remove();
 			          }
 			          
					
// 						var totelHour=$("#quartn_all").text(); 
// 	 			        if(totelHour && totelHour.toString().split(".").length>1){
// 		 			        totelHour= totelHour.toString().split(".");
//// 	 		 			        totelHour=totelHour[0]+":"+(parseInt(totelHour[1])/60).toFixed(2)*100;
// 		 			        totelHour=totelHour[0]+":"+(parseInt(totelHour[1])*0.6).toFixed(0);
// 		 			        $("#quartn_all").text(totelHour);
// 	 			        }
	 			        
	 			        $("td,span").each(function(k,v){
						if($(v).text()=='undefined' || $(v).text()=='null'){
							$(v).text("");
						}
	    				});	
	    				
	    				$("span[id^='qt_']").each(function(){	
	    					if($(this).text()){
	    					var dataid=$(this)[0].getAttribute('id');
	    					dataid=dataid.split("_")[1];
	    						$("li[id='qut_"+dataid+"']").attr("class","icongreen");
	    					}else{
	    						var dataid=$(this)[0].getAttribute('id');
	    						$("li[id='qut_"+dataid+"']").attr("class","iconyellow");
	    					}
	    				});
    				}
    			});
});

	function priSelf(i,o){
		if (!$("#qt_"+i).html()) {
			$("#qtw_"+i).html(o.createUser);
			$("#qt_"+i).html(o.createStrDate);
		} else if (new Date(o.createStrDate) > new Date($("#qt_"+i).html())) {
			$("#qtw_"+i).html(o.createUser);
			$("#qt_"+i).html(o.createStrDate);
		}
	}


	function getKeyName(type){
		if(type=="HC"){
			return "火车";
		}
		if(type=="FJ"){
			return "飞机";
		}
		if(type=="CB"){
			return "船舶";
		}
		if(type=="SCRY"){
			return "司乘人员";
		}
		if(type=="QC"){
			return "汽车";
		}
	}
	
	/**
	 * 显示图片浏览
	 * path 数据库保存的图片地址 E:/201708/20170823/1B083FEA24D6E00004df8.jpg
	 * wangzhy
	 */
	function toImgDetail(path) {
		//path=path.substring(path.indexOf('/')+1,path.length);
		url = "/ciqs/showVideo?imgPath=" + path;
		$("#imgd1").attr("src", url);
		$("#imgd1").click();
	}
	/**
	 * 查看视频
	 * path 数据库保存的视频地址 E:/201708/20170823/22.3gp
	 * wangzhy
	 */
// 	function showVideo(path) {
// 		$("#CuPlayerMiniV").show();
// 		CuPlayerMiniV(path);
// 	}
	/**
	 * 关闭视频
	 * wangzhy
	 */
// 	function hideVideo() {
// 		$("#CuPlayerMiniV").hide();
// 	}
	
	function getPlace(place_number){
		window.scroll(0, document.getElementById(place_number).offsetTop-306);
	}
</script>
<div class="freeze_div_dtl" style="position: fixed;width: 100%;background-color:#f0f2f5;top:0px;height:306px;">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title">
<span class="font-24px" style="color:white;">行政确认 /</span><a id="title_a" href="/ciqs/quartn/list">隔离、留验与就地诊验</a>
<!-- <span class="font-24px" style="color:white;">行政确认 /</span><a id="title_a" href="/ciqs/quartn/list">隔离、就地诊验或留验</a></div> -->
</div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg"  style="height:235px;background-color: #f0f2f5;" >
<div class="flow-position2 margin-auto"  style=" height:235px;" >

<ul class="white font-18px flow-height font-weight">
<li>体温检测</li>
<li>医学排查</li>
<li>现场隔离</li>
<li>病例转诊</li>
</ul>
<ul class="flow-icon" id="flow_quartn">
  <li id="qut_1" class="iconyellow"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/quartn/quartn1.png" width="80" height="80" onclick="getPlace('module_1')"/></li>
  <li id="qut_2" class="iconyellow"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/quartn/quartn2.png" width="80" height="80" onclick="getPlace('module_2')"/></li>
  <li id="qut_3" class="iconyellow"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/quartn/quartn3.png" width="80" height="80" onclick="getPlace('module_3')"/></li>
  <li id="qut_4" class="iconyellow"><div class="hour white font-12px"></div><img src="${ctx}/static/show/images/quartn/quartn4.png" width="80" height="80" onclick="getPlace('module_4')"/></li>
  <li></li>
<li></li>
<li></li>
<li></li>
  <li class="white font-17px font-weight" style="white-space: nowrap; display:inline-block"> <br />
    历时：<span id="quartn_all">0</span></li>
</ul>
<ul class="flow-info" >
<li><div id="qtw_1"></div><br /><span id="qt_1" class="font-10px" ></span></li>
<li><div id="qtw_2"></div><br /><span id="qt_2" class="font-10px" ></span></li>
<li><div id="qtw_3"></div><br /><span id="qt_3" class="font-10px" ></span></li>
<li><div id="qtw_4"></div><br /><span id="qt_4" class="font-10px" ></span></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_dtl" style="margin-top:320px;">
</div>
<div class="title-cxjg">基础信息</div>
<div class="margin-chx">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
    <tr class="table_xqlbbj">
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
    <tr class="table_xqlbnr">
      <td width="200" height="90" align="center" id="t1"></td>
      <td width="120" height="90" align="center" id="t2"></td>
      <td width="120" height="90" align="center" id="t3"></td>
      <td width="120" height="90" align="center" id="t4"></td>
      <td width="120" height="90" align="center" id="t5"></td>
      <td width="120" height="90" align="center" id="t6"></td>
      <td width="120" height="90" align="center" id="t7"></td>
      <td width="120" height="90" align="center" id="t8"></td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
    <tr class="table_xqlbbj">
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
    <tr class="table_xqlbnr">
      <td width="120" height="90" align="center" id="t2_1"></td>
      <td width="120" height="90" align="center" id="t2_2"></td>
      <td width="120" height="90" align="center" id="t2_3"></td>
      <td width="120" height="90" align="center" id="t2_4"></td>
      <td width="120" height="90" align="center" id="t2_5"></td>
      <td width="120" height="90" align="center" id="t2_6"></td>
      <td width="120" height="90" align="center" id="t2_7"></td>
      <td width="120" height="90" align="center" id="t2_8"></td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
    <tr class="table_xqlbbj">
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
    <tr class="table_xqlbnr">
      <td width="120" height="90" align="center" id="t3_1"></td>
      <td width="120" height="90" align="center" id="t3_2"></td>
      <td width="120" height="90" align="center" id="t3_3"></td>
      <td width="120" height="90" align="center" id="t3_4"></td>
      <td width="120" height="90" align="center" id="t3_5"></td>
      <td width="120" height="90" align="center" id="t3_6"></td>
      <td width="120" height="90" align="center" id="t3_7"></td>
      <td width="120" height="90" align="center" id="t3_8"></td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
    <tr class="table_xqlbbj">
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
    <tr class="table_xqlbnr">
      <td width="200" height="90" align="center" class="font-18px" id="t4_1"></td>
      <td width="120" height="90" align="center" id="t4_2"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td width="120" height="35" align="center" valign="bottom"></td>
      <td height="35" align="center" valign="bottom">&nbsp;</td>
    </tr>
  </table>
</div>

<div class="title-cxjg del-1" id="module_1">体温检测</div>
<div class="margin-chx del-1">
<table width="100%" border="0" class="table-xqlb">
	  <tr id="l1_1">
	    <td width="300" class="table_xqlbbj2">体温检测结果</td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" colspan="2" align="left"></td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" align="left" colspan="2"></td>
	    <td style="padding: 0px" width="300" align="right" valign="middle" colspan="3" class="flow-td-bord"></td>
	  </tr>
</table>
</div>

<div class="title-cxjg del-2" id="module_2">医学排查</div>
<div class="margin-chx del-2">
<table width="100%" border="0" class="table-xqlb del-2">
	  <tr id="pc_1">
	    <td width="300"  class="table_xqlbbj2">医学排查结果（调查表）</td>
	    <td width="120"></td>
	    <td width="120" colspan="2" align="left"></td>
	    <td width="120"></td>
	    <td width="120" align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord" colspan="3"></td>
	  </tr>
	  <tr id="pc_2">
	    <td width="300"  class="table_xqlbbj2">医学排查结果（记录表）</td>
	    <td width="120"></td>
	    <td width="120" colspan="2" align="left"></td>
	    <td width="120"></td>
	    <td width="120" align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord" colspan="3"></td>
	  </tr>
	   <tr id="pc_3">
	    <td width="300"  class="table_xqlbbj2">采样知情同意书</td>
	    <td width="120"></td>
	    <td width="120" colspan="2" align="left"></td>
	    <td width="120"></td>
	    <td width="120" align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle"  class="flow-td-bord" colspan="3"></td>
	  </tr>
</table>
</div>

<div class="title-cxjg del-3" id="module_3">现场隔离</div>
<div class="margin-chx del-3">
<table width="100%" border="0" class="table-xqlb del-3">
	  <tr id="l2_2_1">
	  	<td width="300" class="table_xqlbbj2">照片查看</td>
	  	<td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" colspan="2" align="left"></td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord" style="padding: 0px">
	    </td>
	  </tr>
	  <tr id="l2_2_2">
	   <td width="300" class="table_xqlbbj2">录像查看</td>
	  	<td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" colspan="2" align="left"></td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" align="left" colspan="2"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord" style="padding: 0px">
	    </td>
	  </tr>
</table>
</div>

<div class="title-cxjg del-4" id="module_4">病例转诊</div>
<div class="margin-chx del-4">
<table width="100%" border="0" class="table-xqlb del-4">
	  <tr id="l2_3_1" class="del-4">
	    <td width="300" class="table_xqlbbj2">病例转诊情况（图片）</td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" colspan="2" align="left"></td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px" align="left" colspan="2"></td>
	    <td style="padding: 0px" width="300" align="right" valign="middle" colspan="3" id="psp_1" class="flow-td-bord">
	    </td>
	  </tr>
	  <tr id="l2_3_2" class="del-4">
	    <td width="300" class="table_xqlbbj2">病例转诊情况（视频）</td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" colspan="2" align="left" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" align="left" colspan="2" style="padding: 0px"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord"  id="psp_2" style="padding: 0px">
	    </td>
	  </tr>
	  
	  <tr id="l2_3_3" class="del-4">
	    <td width="300" class="table_xqlbbj2">口岸传染病疑似病例转诊单</td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" colspan="2" align="left" style="padding: 0px"></td>
	    <td width="120" style="padding: 0px"></td>
	    <td width="120" align="left" colspan="2" style="padding: 0px"></td>
	    <td width="300" align="right" valign="middle" colspan="3" class="flow-td-bord" style="padding: 0px">
	    </td>
	  </tr>
<!-- 	   <tr class="text2"> -->
<!-- 	    <td width="300" class="table_xqlbbj2">采样知情同意书</td> -->
<!-- 	    <td width="300" align="center" valign="middle"  class="flow-td-bord" colspan="7"> -->
<!-- 	    <a href="/ciqs/quartn/findtext?t=2&id=${id}">采样知情同意书</a> -->
<!-- 	    </td> -->
<!-- 	  </tr> -->
</table>
</div>

<div class="title-cxjg" ></div>
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
<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
	<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
</div>
<%@ include file="/common/player.jsp"%>
</body>
</html>
