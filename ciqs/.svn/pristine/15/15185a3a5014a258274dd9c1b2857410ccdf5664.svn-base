<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>出口食品生产企业监督检查</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css">
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css">	
</head>
<body  class="bg-gary">
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<script type="text/javascript">
/**
 * 页面初始化加载
 * wangzhy
 */
$(function(){
	$("#imgd1").hide();
	$("#CuPlayerMiniV").hide();
	
	var totalSss = 0;
	var addHour = 0;
	var procArray = eval('('+$("#procArray").val()+')');
	$(".writeHour").each(function(){
		var id = this.id;
		var index = id.substring(4);
		
		if(null != procArray[index-1] && null != procArray[index-1].create_date_str){
			$("#psn"+index).text(procArray[index-1].create_user);
			$("#date"+index).text(procArray[index-1].create_date_str);
			$("#icon"+index).addClass("icongreen");
		}else{
			$("#psn"+index).text("暂无");
			$("#date"+index).text('');
			$("#icon"+index).addClass("iconyellow");
		}
				
		if(index > 1){
			var dateText = $("#date"+index).text();
			var dateText0 = $("#date"+(index-1)).text();
			if(dateText != '' && dateText0 != ''){
				addHour = getHour(dateText0, dateText);
				$("#hour"+(index-1)).text("+"+addHour);
				totalSss += getSss(dateText0, dateText);
			}else{
				$("#hour"+(index-1)).text("-");
			}
		}
	});
	$("#totalHour").text(formatSss(totalSss));
});

/**
 * 计算2个日期的天数
 */
function getDay(startDate){
	var date1 = new Date(startDate); 
	var date2 = new Date();
	var day = "";
	day = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 *24);
    return day;
}

/**
 * 计算2个日期小时差
 */
function getHour(startDate,endDate){
	var date1 = new Date(startDate); 
	var date2 = new Date(endDate);
	var hour = "";
	hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
	hour = hour.toFixed(2);
    return hour;
}

/**
 * 计算2个日期毫秒差
 */
function getSss(startDate,endDate){
	var date1 = new Date(startDate); 
	var date2 = new Date(endDate);
	var sss = 0;
	sss = date2.getTime() - date1.getTime();
    return sss;
}

function formatSss(sss){
	var hours = parseInt(sss / (1000*60*60));
	var minutes = parseInt(sss % (1000*60*60) / (1000*60));
	var seconds = parseInt(sss % (1000*60) / 1000);
	return (hours < 10 ? "0"+hours : hours) + ":" + (minutes < 10 ? "0"+minutes : minutes);// + "分钟";// + (seconds < 10 ? "0"+seconds : seconds);
}

/**
 * 显示图片浏览
 * path 数据库保存的图片地址 E:/201708/20170823/1B083FEA24D6E00004df8.jpg
 * wangzhy
 */
function toImgDetail(path){
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

//打开模板表格
function showTemplate(applyid){
	window.open("/ciqs/expFoodProd/toPage?applyid="+applyid+"&page=expFoodProd_qiye_jiandu_jcb");
}

/**
 * 关闭视频
 * wangzhy
 */
function hideVideo(){
	$("#CuPlayerMiniV").hide();
}
/**
 * 图片和视频文件上传
 * formId form表单Id
 * uploadFileId input file标签Id
 * procMainId 业务主键Id
 * procType 环节类型
 * fileType 文件类型 1图片 2视频 3音频
 * package_no 业务单号
 * wangzhy
 */
function fileSubmit(formId,uploadFileId,procMainId,procType,fileType,package_no){
	if(typeof $("#"+uploadFileId).val() == 'undefined' || $("#"+uploadFileId).val() == ''){
		alert("请选择一个文件!");
		return;
	}
	var path = $("#"+uploadFileId).val();
	var type = path.substring(path.lastIndexOf('.')+1,path.length);
	if((procType == 'V_KB_C_M_2' || procType == 'V_JL_C_M_2') 
		&& (type == 'jpg' || type == 'jpeg' || type == 'png' || type == 'gif' || type == 'bmp')){
		alert("请选择一个视频文件!");
		return;
	}
	if((procType == 'V_JL_C_M_3' || procType == 'V_CYSJ_C_M_3') 
		&& (type != 'jpg' && type != 'jpeg' && type != 'png' && type != 'gif' && type != 'bmp')){
		alert("请选择一个图片文件!");
		return;
	}
	var url ='fileVideoOrImg?id='+procMainId+'&procType='+procType+'&fileType='+fileType+'&package_no='+package_no;
	$("#"+formId).attr("action",url);
	$("#"+formId).submit();
}

function getPlace(place_number){
	window.scroll(0, document.getElementById(place_number).offsetTop-306);
}
</script>
<div class="freeze_div_dtl" style="position: fixed;width: 100%;background-color:#f0f2f5;top:0px;height:306px;">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><span class="font-24px" style="color:white;">行政检查/</span><a href="list" style="color:white;">出口食品生产企业监督检查</div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg"  style=" height:235px;" >
<div class="flow-position2 margin-auto"  style=" height:235px;" >

<ul class="white font-18px flow-height font-weight">
<li>计划制定</li>
<li>实施检查</li>
<li>后续处理</li>
<li></li>
<li></li>
<li></li>
<li></li>
<li></li>
<li></li>
</ul>
<ul class="flow-icon">
  <li id="icon1"><div class="hour white font-12px"><span id="hour1" class="writeHour"></span></div><a href="#tab1"><img src="/ciqs/static/show/images/user-photo.png" width="80" height="80" onclick="getPlace('module_1')"/></a></li>
  <li id="icon2"><div class="hour white font-12px"><span id="hour2" class="writeHour"></span></div><a href="#tab2"><img src="/ciqs/static/show/images/user-photo.png" width="80" height="80" onclick="getPlace('module_2')"/></a></li>
  <li id="icon3"><div class="hour white font-12px"><span id="hour3" class="writeHour"></span></div><a href="#tab3"><img src="/ciqs/static/show/images/user-photo.png" width="80" height="80" onclick="getPlace('module_3')"/></a></li>
  <li></li>
  <li></li>
  <li></li>
  <li></li>
  <li></li>
  <li class="white font-18px font-weight"> <br />历时：<span id="totalHour">0</span></li>
</ul>
<input type="hidden" id="procArray" value="${procArray }" />
<ul class="flow-info" >
	<li>
		<span id="psn1" >
			
		</span><br />
	  	<span class="font-10px" >
	  		<span id="date1" >
	  		
	  		</span>
	  	</span>
	</li>
	<li><span id="psn2" ></span><br />
	  <span class="font-10px" ><span id="date2" ></span></span>
	</li>
	<li><span id="psn3" ></span><br />
	  <span class="font-10px" ><span id="date3" ></span></span>
	</li>
	<li></li>
	<li></li>
	<li></li>
	<li></li>
	<li class="font-10px"></li>
	<li class="font-10px"></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_dtl" style="margin-top:290px;">
</div>

<div class="margin-chx">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
    <tr class="table_xqlbbj">
      <td width="300" height="35" align="center" valign="bottom">企业名称</td>
      <td width="300" height="35" align="center" valign="bottom">监管类型</td>
      <td width="300" height="35" align="center" valign="bottom">地址</td>
      <td width="300" height="35" align="center" valign="bottom">计划监管时间</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="300" height="90" align="center">${model.orgname}</td>
      <td width="300" height="90" align="center">${model.plantype}</td>
      <td width="300" height="90" align="center">${model.fullname}</td>
      <td width="300" height="90" align="center">${model.plansupdate}</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="300" height="35" align="center" valign="bottom">监管负责人</td>
      <td width="300" height="35" align="center" valign="bottom">监管人员</td>
      <td width="300" height="35" align="center" valign="bottom">实际监管时间</td>
      <td width="300" height="35" align="center" valign="bottom">实际监管人</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="300" height="90" align="center">${model.pesponsible}</td>
      <td width="300" height="90" align="center">${model.subname}</td>
      <td width="300" height="90" align="center"><fmt:formatDate value="${model.actualdate}" type="both" pattern="yyyy-MM-dd"/></td>
      <td width="300" height="90" align="center">${model.practicename}</td>
    </tr>
  	<tr class="table_xqlbbj">
  		<td width="300" height="35" align="center" valign="bottom">是否有违规操作</td>
  		<td width="300" height="35" align="center" valign="bottom"></td>
      	<td width="300" height="35" align="center" valign="bottom"></td>
      	<td width="300" height="35" align="center" valign="bottom"></td>
  	</tr>
    <tr class="table_xqlbnr">
      	<td width="300" height="90" align="center">${model.is_break_law}</td>
      	<td width="300" height="90" align="center"></td>
      	<td width="300" height="90" align="center"></td>
      	<td width="300" height="90" align="center"></td>
    </tr>
  </table>
</div>
<div class="margin-auto width-1200 tips" id="module_1">计划制定</div>
<!-- <div class="title-cxjg">1.报告审查</div> -->
<div class="margin-chx">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	<tr class="table_xqlbbj">
      <td height="35" align="center" valign="bottom" colspan="5">报告审查</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="220" height="35" align="center" valign="bottom">检查结果</td>
      <td width="220" height="35" align="center" valign="bottom">年度报告</td>
      <td width="220" height="35" align="center" valign="bottom">审批人</td>
      <td width="220" height="35" align="center" valign="bottom">审批时间</td>
      <td width="220" height="35" align="center" valign="bottom">审批机构</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="220" height="90" align="center">${model.monitor_type }</td>
      <td width="220" height="90" align="center">${model.addr }</td>
      <td width="220" height="90" align="center">${model.moni_man_por }</td>
      <td width="220" height="90" align="center">${model.moni_psn }</td>
      <td width="220" height="90" align="center">${model.act_monit_por }</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="220" height="35" align="center" valign="bottom">审批决定</td>
      <td width="220" height="35" align="center" valign="bottom">审批意见</td>
      <td width="220" height="35" align="center" valign="bottom"></td>
      <td width="220" height="35" align="center" valign="bottom"></td>
      <td width="220" height="35" align="center" valign="bottom"></td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="220" height="90" align="center">${model.attach_file }</td>
      <td width="220" height="90" align="center">${model.prod_comp }</td>
      <td width="220" height="90" align="center"></td>
      <td width="220" height="90" align="center"></td>
      <td width="220" height="90" align="center"></td>
    </tr>
    
    
    <tr class="table_xqlbbj">
      <td height="35" align="center" valign="bottom" colspan="5">现场检查</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="220" height="35" align="center" valign="bottom">检查计划下达时间</td>
      <td width="220" height="35" align="center" valign="bottom">下达人员</td>
      <td width="220" height="35" align="center" valign="bottom">检查计划</td>
      <td width="220" height="35" align="center" valign="bottom"></td>
      <td width="220" height="35" align="center" valign="bottom"></td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="220" height="90" align="center">${model.reg_comp_plc }</td>
      <td width="220" height="90" align="center">${model.comp_plc }</td>
      <td width="220" height="90" align="center"${model.enter_accp }></td>
      <td width="220" height="90" align="center"></td>
      <td width="220" height="90" align="center"></td>
    </tr>
    
    
    
    <tr class="table_xqlbbj">
      <td height="35" align="center" valign="bottom" colspan="5">专项检查</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="220" height="35" align="center" valign="bottom">监管检查通知书下发时间</td>
      <td width="220" height="35" align="center" valign="bottom">下发人员</td>
      <td width="220" height="35" align="center" valign="bottom">监管检查通知书</td>
      <td width="220" height="35" align="center" valign="bottom">送达回证</td>
      <td width="220" height="35" align="center" valign="bottom"></td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="220" height="90" align="center">${model.legal_psn }</td>
      <td width="220" height="90" align="center">${model.e_mail }</td>
      <td width="220" height="90" align="center">${model.post_no }</td>
      <td width="220" height="90" align="center">${model.con_name }</td>
      <td width="220" height="90" align="center"></td>
    </tr>
  </table>
</div>



<div class="title-cxjg">实施检查</div>
<div class="margin-chx">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
    	<tr class="table_xqlbbj">
      		<td width="220" height="35" align="center" valign="bottom">现场检查结果</td>
	      	<td width="220" height="35" align="center" valign="bottom">专项检查结果</td>
	      	<td width="220" height="35" align="center" valign="bottom"></td>
	      	<td width="220" height="35" align="center" valign="bottom"></td>
	      	<td width="220" height="35" align="center" valign="bottom"></td>
    	</tr>
    	<tr class="table_xqlbnr">
      		<td width="220" height="90" align="center">${model.con_tel }</td>
      		<td width="220" height="90" align="center">${model.buness_licen }</td>
      		<td width="220" height="90" align="center"></td>
      		<td width="220" height="90" align="center"></td>
      		<td width="220" height="90" align="center"></td>
    	</tr>
  	</table>
  	
  	<!-- 实施检查 - 报告审查 -->
  	<c:if test="${not empty V_XZJC_SJ_BS_1 or not empty V_XZJC_SJ_BS_2 }">
	  	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  		<tr class="table_xqlbbj">
	      		<td height="35" align="center" valign="bottom">报告审查</td>
	      	</tr>
	    </table>
	    
	    <table id="V_XZJC_SJ_BS_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
			<c:forEach items="${V_XZJC_SJ_BS_1 }" var="v" varStatus="status">
			    <tr>
				    <c:if test="${status.count == 1}"><td width="250" class="table_xqlbbj2" rowspan="${fn:length(V_XZJC_SJ_BS_1) }">整改报告照片</td></c:if>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
			<c:if test="${not empty V_XZJC_SJ_BS_2 }">
				<c:forEach items="${V_XZJC_SJ_BS_2 }" var="v" varStatus="status">
				    <tr>
					    <c:if test="${status.count == 1}"><td width="250" class="table_xqlbbj2" rowspan="${fn:length(V_XZJC_SJ_BS_2) }">其他</td></c:if>
					    <td align="center">
					    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class='blue'>
					    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					    	</span>
					    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class="blue">
					    		${v.create_user }
					    	</span>
					    </td>
					    <td width="300" align="center" valign="middle">
					    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
					    </td>
					</tr>
				</c:forEach>
			</c:if>
		</table>
	</c:if>
	
	
	<!-- 实施检查 - 现场检查-->
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
  		<tr class="table_xqlbbj">
      		<td height="35" align="center" valign="bottom">现场检查</td>
      	</tr>
    </table>
    
    <table id="V_XZJC_SJ_BS_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
    	<c:if test="${not empty V_XZJC_SJ_XJ_1 }">
			<c:forEach items="${V_XZJC_SJ_XJ_1 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">首次会议照片、签到表照片&nbsp;<c:if test="${fn:length(V_XZJC_SJ_XJ_1) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		
		<c:if test="${not empty V_XZJC_SJ_XJ_2 }">
			<c:forEach items="${V_XZJC_SJ_XJ_2 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">现场检查照片&nbsp;<c:if test="${fn:length(V_XZJC_SJ_XJ_2) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		
		<tr>
		    <td width="250" class="table_xqlbbj2">企业监督检查表</td>
		    <td align="center">
		    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
		    	<span class='blue'>
		    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
		    	</span>
		    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
		    	<span class="blue">
		    		${v.create_user }
		    	</span>
		    </td>
		    <td width="300" align="right" valign="middle">
		    	<a href='javascript:showTemplate("${model.applyid}");'>
		      		<span class="margin-auto">企业监督检查表</span>
		      	</a>
		    </td>
		</tr>
		
		
		<c:if test="${not empty V_XZJC_SJ_XJ_3 }">
			<c:forEach items="${V_XZJC_SJ_XJ_3 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">末次会议照片、签到表照片&nbsp;<c:if test="${fn:length(V_XZJC_SJ_XJ_3) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		
		<c:if test="${not empty V_XZJC_SJ_XJ_4 }">
			<c:forEach items="${V_XZJC_SJ_XJ_4 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">不符合项及跟踪报告照片&nbsp;<c:if test="${fn:length(V_XZJC_SJ_XJ_4) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		
		
		<c:if test="${not empty V_XZJC_SJ_XJ_5 }">
			<c:forEach items="${V_XZJC_SJ_XJ_5 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">其他&nbsp;<c:if test="${fn:length(V_XZJC_SJ_XJ_5) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
    </table>
    
    
    <!-- 实施检查 - 专项检查-->
    <c:if test="${not empty V_XZJC_SJ_ZJ_1 or not empty V_XZJC_SJ_ZJ_2 or not empty V_XZJC_SJ_ZJ_3 or not empty V_XZJC_SJ_ZJ_4 or not empty V_XZJC_SJ_ZJ_5 }">
	    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  		<tr class="table_xqlbbj">
	      		<td height="35" align="center" valign="bottom">专项检查</td>
	      	</tr>
	    </table>
	    
	    <table width="100%" border="0" cellpadding="0" class="table-xqlb">
	    	<c:if test="${not empty V_XZJC_SJ_ZJ_1 }">
				<c:forEach items="${V_XZJC_SJ_ZJ_1 }" var="v" varStatus="status">
				    <tr>
					    <c:if test="${status.count == 1}"><td width="200" class="table_xqlbbj2" rowspan="${fn:length(V_XZJC_SJ_ZJ_1)}">首次会议照片、签到表照片</td></c:if>
					    <td align="center">
					    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class='blue'>
					    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					    	</span>
					    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class="blue">
					    		${v.create_user }
					    	</span>
					    </td>
					    <td width="60" align="center" valign="middle">
					    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
					    </td>
					</tr>
				</c:forEach>
			</c:if>
			
			<c:if test="${not empty V_XZJC_SJ_ZJ_2 }">
				<c:forEach items="${V_XZJC_SJ_ZJ_2 }" var="v" varStatus="status">
				    <tr>
				    	<c:if test="${status.count == 1}"><td width="200" class="table_xqlbbj2" rowspan="${fn:length(V_XZJC_SJ_ZJ_2)}">现场检查照片</td></c:if>
					    <td align="center">
					    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class='blue'>
					    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					    	</span>
					    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class="blue">
					    		${v.create_user }
					    	</span>
					    </td>
					    <td width="60" align="center" valign="middle">
					    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
					    </td>
					</tr>
				</c:forEach>
			</c:if>
			
			
			<c:if test="${not empty V_XZJC_SJ_ZJ_3 }">
				<c:forEach items="${V_XZJC_SJ_ZJ_3 }" var="v" varStatus="status">
				    <tr>
				    	<c:if test="${status.count == 1}"><td width="200" class="table_xqlbbj2" rowspan="${fn:length(V_XZJC_SJ_ZJ_3)}">末次会议照片、签到表照片</td></c:if>
					    <td align="center">
					    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class='blue'>
					    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					    	</span>
					    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class="blue">
					    		${v.create_user }
					    	</span>
					    </td>
					    <td width="60" align="center" valign="middle">
					    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
					    </td>
					</tr>
				</c:forEach>
			</c:if>
			
			
			<c:if test="${not empty V_XZJC_SJ_ZJ_4 }">
				<c:forEach items="${V_XZJC_SJ_ZJ_4 }" var="v" varStatus="status">
				    <tr>
				    	<c:if test="${status.count == 1}"><td width="200" class="table_xqlbbj2" rowspan="${fn:length(V_XZJC_SJ_ZJ_4)}">不符合项及跟踪报告照片</td></c:if>
					    <td align="center">
					    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class='blue'>
					    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					    	</span>
					    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class="blue">
					    		${v.create_user }
					    	</span>
					    </td>
					    <td width="60" align="center" valign="middle">
					    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
					    </td>
					</tr>
				</c:forEach>
			</c:if>
			
			
			<c:if test="${not empty V_XZJC_SJ_ZJ_5 }">
				<c:forEach items="${V_XZJC_SJ_ZJ_5 }" var="v" varStatus="status">
				    <tr>
				    	<c:if test="${status.count == 1}"><td width="200" class="table_xqlbbj2" rowspan="${fn:length(V_XZJC_SJ_ZJ_5)}">其他</td></c:if>
					    <td align="center">
					    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class='blue'>
					    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					    	</span>
					    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					    	<span class="blue">
					    		${v.create_user }
					    	</span>
					    </td>
					    <td width="60" align="center" valign="middle">
					    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
					    </td>
					</tr>
				</c:forEach>
			</c:if>
	    </table>
    </c:if>
</div>





<div class="title-cxjg"  id="module_3">后续处理</div>
<div class="margin-chx">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
  		<tr class="table_xqlbbj">
      		<td height="35" align="center" valign="bottom">报告审查</td>
      	</tr>
    </table>
    
	<table id="V_XZJC_HC_BS_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
		<c:if test="${not empty V_XZJC_HC_BS_1 }">
			<c:forEach items="${V_XZJC_HC_BS_1 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">约谈&nbsp;<c:if test="${fn:length(V_XZJC_HC_BS_1) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
	</table>
	
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
  		<tr class="table_xqlbbj">
      		<td height="35" align="center" valign="bottom">现场审查</td>
      	</tr>
    </table>
    
    <table id="V_XZJC_HC_BS_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
	    <c:if test="${not empty V_XZJC_HC_XS_1 }">
			<c:forEach items="${V_XZJC_HC_XS_1 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">整改报告照片&nbsp;<c:if test="${fn:length(V_XZJC_HC_XS_1) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		<c:if test="${not empty V_XZJC_HC_XS_2 }">
			<c:forEach items="${V_XZJC_HC_XS_2 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">不符合项及跟踪报告照片&nbsp;<c:if test="${fn:length(V_XZJC_HC_XS_2) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		<c:if test="${not empty V_XZJC_HC_XS_3 }">
			<c:forEach items="${V_XZJC_HC_XS_3 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">其他&nbsp;<c:if test="${fn:length(V_XZJC_HC_XS_3) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
	</table>
	
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
  		<tr class="table_xqlbbj">
      		<td height="35" align="center" valign="bottom">专项审查</td>
      	</tr>
    </table>
    
    
    <table id="V_XZJC_HC_BS_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
    	<c:if test="${not empty V_XZJC_HC_ZS_1 }">
			<c:forEach items="${V_XZJC_HC_ZS_1 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">整改报告照片&nbsp;<c:if test="${fn:length(V_XZJC_HC_ZS_1) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		<c:if test="${not empty V_XZJC_HC_ZS_2 }">
			<c:forEach items="${V_XZJC_HC_ZS_2 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">不符合项及跟踪报告照片&nbsp;<c:if test="${fn:length(V_XZJC_HC_ZS_2) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
		
		<c:if test="${not empty V_XZJC_HC_ZS_3 }">
			<c:forEach items="${V_XZJC_HC_ZS_3 }" var="v" varStatus="status">
			    <tr>
				    <td width="250" class="table_xqlbbj2">其他&nbsp;<c:if test="${fn:length(V_XZJC_HC_ZS_3) gt 1 }">${status.count }</c:if></td>
				    <td align="center">
				    	操作时间:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class='blue'>
				    		<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				    	</span>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
				    	<span class="blue">
				    		${v.create_user }
				    	</span>
				    </td>
				    <td width="300" align="center" valign="middle">
				    	<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="toImgDetail('${v.file_name}')"/>
				    </td>
				</tr>
			</c:forEach>
		</c:if>
    </table>
    
    <div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
			<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>
</div>






<!-- <table width="100%" border="0" class="table-xqlb">
  <tr>
    <td class="table_xqlbbj2" align="center" colspan="5">报告审查</td>
  </tr>
</table> -->


<!-- 
<div class="margin-chx">
<table id="V_XZJC_SJ_BS_2" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>
 -->

<!-- <table width="100%" border="0" class="table-xqlb">
  <tr>
    <td class="table_xqlbbj2" align="center" colspan="5">现场检查</td>
  </tr>
</table> -->

<!--
<div class="title-cxjg">现场检查</div>
<div class="margin-chx">
<table id="V_XZJC_SJ_XJ_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>
-->

<!--
<div class="margin-chx">
<table id="V_XZJC_SJ_XJ_2" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>
-->

<!--
<div class="margin-chx">
<table width="100%" border="0" cellpadding="0" class="table-xqlb">
	<tr>
	    <td width="200" class="table_xqlbbj2">企业监督检查表</td>
	    <td width="300" align="right" valign="middle" colspan="2">
	    	<a href='javascript:showTemplate("${model.applyid}");'>
	      		<span class="margin-auto">企业监督检查表</span>
	      	</a>
	    </td>
	</tr>
</table>
</div>
-->

<!--
<div class="margin-chx">
<table id="V_XZJC_SJ_XJ_3" width="100%" border="0" cellpadding="0" class="table-xqlb">

</table>
</div>
-->

<!--
<div class="margin-chx">
<table id="V_XZJC_SJ_XJ_4" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>
-->

<!--
<div class="margin-chx">
<table id="V_XZJC_SJ_XJ_5" width="100%" border="0" cellpadding="0" class="table-xqlb">
</table>
</div>
-->

<!-- <table width="100%" border="0" class="table-xqlb">
  <tr>
    <td class="table_xqlbbj2" align="center" colspan="5">专项检查</td>
  </tr>
</table> -->

<!--
<div class="title-cxjg">专项检查</div>
<div class="margin-chx">
<table id="V_XZJC_SJ_ZJ_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_SJ_ZJ_2" width="100%" border="0" cellpadding="0" class="table-xqlb">
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_SJ_ZJ_3" width="100%" border="0" cellpadding="0" class="table-xqlb">
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_SJ_ZJ_4" width="100%" border="0" cellpadding="0" class="table-xqlb">
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_SJ_ZJ_5" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>
-->




<!-- <table width="100%" border="0" class="table-xqlb">
  <tr>
    <td class="table_xqlbbj2" align="center" colspan="5">报告审查</td>
  </tr>
</table> 
<div class="title-cxjg">报告审查</div>
-->
  
<!-- <table width="100%" border="0" class="table-xqlb">
  <tr>
    <td class="table_xqlbbj2" align="center" colspan="5">现场审查</td>
  </tr>
</table> 
<div class="title-cxjg">现场审查</div>
<div class="margin-chx">
<table id="V_XZJC_HC_XS_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_HC_XS_2" width="100%" border="0" cellpadding="0" class="table-xqlb">
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_HC_XS_3" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>
<!-- <table width="100%" border="0" class="table-xqlb">
  <tr>
    <td class="table_xqlbbj2" align="center" colspan="5">专项审查</td>
  </tr>
</table> 
<div class="title-cxjg">专项审查</div>
<div class="margin-chx">
<table id="V_XZJC_HC_ZS_1" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_HC_ZS_2" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>

<div class="margin-chx">
<table id="V_XZJC_HC_ZS_3" width="100%" border="0" cellpadding="0" class="table-xqlb">
	
</table>
</div>
-->

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
