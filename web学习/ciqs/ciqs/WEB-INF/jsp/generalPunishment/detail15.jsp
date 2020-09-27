<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>一般处罚</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>	
<style type="text/css">
 #title_a{color:#ccc}
 #title_a:hover{
 	color:white;
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
/**
 * 页面初始化加载
 * wangzhy
 */
$(function(){
	$("#imgd1").hide();
	$("#CuPlayerMiniV").hide();
	
	var totalSss = 0;
	var addHour = 0;
	$(".writeHour").each(function(){
		var id = this.id;
		var index = id.substring(4);
		if($("#date"+index).text().trim() != ""){
			//$("#psn"+index).text(procArray[index-1].create_user);
			//$("#date"+index).text(procArray[index-1].create_date_str);
			$("#icon"+index).addClass("icongreen");
		}else{
			//$("#psn"+index).text("暂无");
			//$("#date"+index).text('');
			$("#icon"+index).addClass("iconyellow");
		}
		
		if(index > 1){
			var dateText = $("#date"+index).text();
			var dateText0 = $("#date"+(index-1)).text();
			if(dateText.trim() != '' && dateText0 != ''.trim()){
				console.log("begin:"+dateText0+"end:"+dateText.trim())
				addHour = getHour(dateText0.trim(), dateText.trim());
				$("#hour"+(index-1)).text("+"+addHour);
				totalSss += getSss(dateText0.trim(), dateText.trim());
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
debugger
    var day1 = parseInt(sss / (1000 * 60 * 60 * 24));
	var hours = parseInt((sss % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	var minutes = parseInt((sss % (1000 * 60 * 60)) / (1000 * 60));
	var seconds = (sss % (1000 * 60)) / 1000;
    return (day1 + " 天 " + hours + " 小时 " + minutes + " 分钟 "); //+ seconds + " 秒 ";
	/* return day +"天"+(hours < 10 ? "0"+hours : hours) + ":" + (minutes < 10 ? "0"+minutes : minutes);// + "分钟";// + (seconds < 10 ? "0"+seconds : seconds); */
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
/**
 * 图片和视频文件上传
 * formId form表单Id
 * uploadFileId input file标签Id
 * procType 环节类型
 * fileType 文件类型 1图片 2视频 3音频
 * wangzhy
 */
function fileSubmit(formId,uploadFileId,procType,fileType){
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
	var url ='fileVideoOrImg?id='+$("#mailId").val()+'&procType='+procType+'&fileType='+fileType+'&package_no='+$("#package_no").val();
	$("#"+formId).attr("action",url);
	$("#"+formId).submit();
}
</script>
<input type="hidden" id="package_no" value="${mail.package_no}"/>
<input type="hidden" id="mailId" value="${mail.id}"/>
<div class="freeze_div_dtl">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><span class="font-24px" style="color:white;">行政处罚 /</span><a id="title_a" href="/ciqs/generalPunishment/listNew?step=15">一般处罚</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg"  style=" height:235px;" >
<div class="flow-position2 margin-auto"  style=" height:235px;" >

<ul class="white font-18px flow-height font-weight">
<!-- <li>立案申报</li>
<li>稽查受理</li>
<li>法制受理</li>
<li>立案审批</li>
<li>调查报告填写</li>
<li>调查报告提交</li>
<li>调查报告审批</li>
<li>调查报告局审批</li> -->
<li>线索移送</li>
<li>立案申报</li>
<li>调查取证</li>
<li>审理决定</li>
<li>送达执行</li>
<li>结案归档</li>
<li></li>
<li></li>
<li></li>
</ul>
<ul class="flow-icon">
  <li id="icon1"><div class="hour white font-12px"><span id="hour1" class="writeHour"></span></div><a href="#tab1"><img src="${ctx}/static/show/images/generalPunishment/generalPunishment1.png" width="80" height="80" /></a></li>
  <li id="icon2"><div class="hour white font-12px"><span id="hour2" class="writeHour"></span></div><a href="#tab3"><img src="${ctx}/static/show/images/generalPunishment/generalPunishment2.png" width="80" height="80" /></a></li>
  <li id="icon3"><div class="hour white font-12px"><span id="hour3" class="writeHour"></span></div><a href="#tab5"><img src="${ctx}/static/show/images/generalPunishment/generalPunishment3.png" width="80" height="80" /></a></li>
  <li id="icon4"><div class="hour white font-12px"><span id="hour4" class="writeHour"></span></div><a href="#tab7"><img src="${ctx}/static/show/images/generalPunishment/generalPunishment4.png" width="80" height="80" /></a></li>
  <li id="icon5"><div class="hour white font-12px"><span id="hour5" class="writeHour"></span></div><a href="#tab9"><img src="${ctx}/static/show/images/generalPunishment/generalPunishment5.png" width="80" height="80" /></a></li>
  <li id="icon6"><div class="hour white font-12px"><span id="hour6" class="writeHour"></span></div><a href="#tab11"><img src="${ctx}/static/show/images/generalPunishment/generalPunishment6.png" width="80" height="80" /></a></li>
  <li></li>
  <li style="width:230px;" class="white font-18px font-weight" > <br />历时：<span id="totalHour">0</span></li>
</ul>
<ul class="flow-info" >
	<li>
		<c:if test="${not empty model.step_1_psn }">
			<c:set value="${model.step_1_date }" var="date1"></c:set>
			<c:set value="${model.step_1_psn }" var="psn1"></c:set>
		</c:if>
		<c:if test="${not empty model.step_2_psn }">
			<c:set value="${model.step_2_date }" var="date1"></c:set>
			<c:set value="${model.step_2_psn }" var="psn1"></c:set>
		</c:if>
		<span id="psn1" >${psn1 }</span><br />
    	<span class="font-10px" ><span id="date1" ><fmt:formatDate value="${date1}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></span></span>
	</li>
	<li>
		<c:if test="${not empty model.step_3_psn }">
			<c:set value="${model.step_3_date }" var="date3"></c:set>
			<c:set value="${model.step_3_psn }" var="psn3"></c:set>
		</c:if>
		<c:if test="${not empty model.step_16_psn }">
			<c:set value="${model.step_16_date }" var="date3"></c:set>
			<c:set value="${model.step_16_psn }" var="psn3"></c:set>
		</c:if>
		<c:if test="${not empty model.step_4_psn }">
			<c:set value="${model.step_4_date }" var="date3"></c:set>
			<c:set value="${model.step_4_psn }" var="psn3"></c:set>
		</c:if>
		<c:if test="${not empty model.step_5_psn }">
			<c:set value="${model.step_5_date }" var="date3"></c:set>
			<c:set value="${model.step_5_psn }" var="psn3"></c:set>
		</c:if>
		<c:if test="${not empty model.step_17_psn }">
			<c:set value="${model.step_17_date }" var="date3"></c:set>
			<c:set value="${model.step_17_psn }" var="psn3"></c:set>
		</c:if>
		<c:if test="${not empty model.step_6_psn }">
			<c:set value="${model.step_6_date }" var="date3"></c:set>
			<c:set value="${model.step_6_psn }" var="psn3"></c:set>
		</c:if>
		<c:if test="${not empty model.step_7_psn }">
			<c:set value="${model.step_7_date }" var="date3"></c:set>
			<c:set value="${model.step_7_psn }" var="psn3"></c:set>
		</c:if>
	  <span id="psn3" >${psn3 }</span><br />
	  <span class="font-10px" ><span id="date2" ><fmt:formatDate value="${date3}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></span></span>
	</li>
	<li>
		<c:if test="${not empty model.step_9_psn }">
			<c:set value="${model.step_9_date }" var="date9"></c:set>
			<c:set value="${model.step_9_psn }" var="psn9"></c:set>
		</c:if>
		<c:if test="${not empty model.step_18_psn }">
			<c:set value="${model.step_18_date }" var="date9"></c:set>
			<c:set value="${model.step_18_psn }" var="psn9"></c:set>
		</c:if>
		<c:if test="${not empty model.step_19_psn }">
			<c:set value="${model.step_19_date }" var="date9"></c:set>
			<c:set value="${model.step_19_psn }" var="psn9"></c:set>
		</c:if>
	  <span id="psn5" >${psn9 }</span><br />
	  <span class="font-10px" ><span id="date3" ><fmt:formatDate value="${date9}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></span></span>
	</li>
	<li>
		<c:if test="${not empty model.step_10_psn }">
			<c:set value="${model.step_10_date }" var="date10"></c:set>
			<c:set value="${model.step_10_psn }" var="psn10"></c:set>
		</c:if>
		<c:if test="${not empty model.step_20_psn }">
			<c:set value="${model.step_20_date }" var="date10"></c:set>
			<c:set value="${model.step_20_psn }" var="psn10"></c:set>
		</c:if>
		<c:if test="${not empty model.step_11_psn }">
			<c:set value="${model.step_11_date }" var="date10"></c:set>
			<c:set value="${model.step_11_psn }" var="psn10"></c:set>
		</c:if>
		<c:if test="${not empty model.step_12_psn }">
			<c:set value="${model.step_12_date }" var="date10"></c:set>
			<c:set value="${model.step_12_psn }" var="psn10"></c:set>
		</c:if>
	  <span id="psn7" >${psn10 }</span><br />
	  <span class="font-10px" ><span id="date4" ><fmt:formatDate value="${date10}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></span></span>
	</li>
	<li><span id="psn9" >${model.step_13_psn }</span><br />
	  <span class="font-10px" ><span id="date5" >
	  <c:if test="${not empty model.step_13_psn }"><fmt:formatDate value="${model.step_13_date}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></c:if></span></span>
	</li>
	<li><span id="psn11" >${model.step_14_psn }</span><br />
	  <span class="font-10px" ><span id="date6" ><c:if test="${not empty model.step_13_psn }"><fmt:formatDate value="${model.step_14_date}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></c:if></span></span>
	</li>
<%-- 	<li><span id="psn12" >${model.step_12_psn }</span><br />
	  <span class="font-10px" ><span id="date7" ><fmt:formatDate value="${model.step_12_date}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></span></span>
	</li>
	<li><span id="psn13" >${model.step_13_psn }</span><br />
	  <span class="font-10px" ><span id="date8" ><fmt:formatDate value="${model.step_13_date}" type="both" pattern="yyyy-MM-dd HH:MM:ss"/></span></span>
	</li> --%>
	<li></li>
</ul>
</div>
</div>

</div>
<div class="blank_div_dtl">
</div>

<div class="margin-chx">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
    <tr class="table_xqlbbj">
      <td width="220" height="35" align="center" valign="bottom">立案号</td>
      <td width="220" height="35" align="center" valign="bottom">单位名称</td>
      <td width="220" height="35" align="center" valign="bottom">姓名</td>
      <td width="220" height="35" align="center" valign="bottom">性别</td>
      <td width="220" height="35" align="center" valign="bottom">出生年月</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="220" height="35" align="center" class="font-18px">${model.case_no}</td>
      <td width="220" height="35" align="center">${model.comp_name}</td>
      <td width="220" height="35" align="center">${model.psn_name}</td>
      <td width="220" height="35" align="center">
		<c:if test="${empty model.gender or '0' == model.gender}">不详</c:if>
		<c:if test="${'1' == model.gender}">男</c:if>
		<c:if test="${'2' == model.gender}">女</c:if>
	  </td>
      <td width="220" height="35" align="center">${model.birth}</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="220" height="35" align="center" valign="bottom">国籍</td>
      <td width="220" height="35" align="center" valign="bottom">法定代表人</td>
      <td width="220" height="35" align="center" valign="bottom">住址或地址</td>
      <td width="220" height="35" align="center" valign="bottom">电话</td>
      <td width="220" height="35" align="center" valign="bottom">业务处/办事处</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="220" height="35" align="center">${model.nation}</td>
      <td width="220" height="35" align="center">${model.corporate_psn}</td>
      <td width="220" height="35" align="center">${model.addr}</td>
      <td width="220" height="35" align="center">${model.tel}</td>
      <td width="220" height="35" align="center">${model.declare_org_name }</td>
    </tr>
  </table>
</div>

<c:if test="${not empty model.step_1_status  && model.step_1_status != '0'}">

	<div class="title-cxjg">线索移送</div>
	<div class="margin-chx">
	<table id="tab1" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">线索申报时间</td>
	    <td width="220" height="35" align="center" valign="bottom">线索申报人员</td>
	    <td width="220" height="35" align="center" valign="bottom">《检验检疫涉嫌案件申报单》</td>
	    <td width="220" height="35" align="center" valign="bottom">附件</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_1_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_1_psn}</td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty GP_AJ_SBD }">
				<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=1&page=gp_shexiananjian_sbd_input&subStep=0");'>
					<span class="data-btn margin-auto">点击查看</span>
				</a>
	    	</c:if>
		</td>
		<td width="220" height="35" align="center">
			<c:if test="${not empty gp_file_fj }">
				<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_fj.file_location }">
					<span  class="data-btn margin-auto">附件查看</span>
				</a>
			</c:if>
		</td>
	  </tr>
	</table>
	<table id="tab2" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">线索预审核时间</td>
	    <td width="220" height="35" align="center" valign="bottom">线索预审核人员</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_2_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_2_psn}</td>
	  </tr>
	</table>
	</div>
</c:if>

<c:if test="${not empty model.step_2_status  && model.step_2_status != '0'}">
	<div class="title-cxjg">立案申报</div>
	<div class="margin-chx">
	<table id="tab5" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">稽查受理时间</td>
	    <td width="220" height="35" align="center" valign="bottom">稽查受理人</td>
	    <td width="220" height="35" align="center" valign="bottom">稽查受理结果</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_3_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_3_psn}</td>
	    <td width="220" height="35" align="center">
			<c:if test="${empty model.step_3_status}"></c:if>
			<c:if test="${'0' == model.step_3_status}">未审核</c:if>
			<c:if test="${'1' == model.step_3_status}">建议立案</c:if>
			<c:if test="${'2' == model.step_3_status}">建议不立案</c:if>
			<c:if test="${'15' == model.step_3_status}">移送</c:if>
		</td>
	  </tr>
	  <tr>
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_16_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_16_psn}</td>
	    <td width="220" height="35" align="center">
			<c:if test="${empty model.step_16_status}"></c:if>
			<c:if test="${'0' == model.step_16_status}">未审核</c:if>
			<c:if test="${'1' == model.step_16_status}">建议立案</c:if>
			<c:if test="${'2' == model.step_16_status}">建议不立案</c:if>
			<c:if test="${'15' == model.step_16_status}">移送</c:if>
		</td>
	  </tr>
	  <tr>
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_4_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_4_psn}</td>
	    <td width="220" height="35" align="center">
			<c:if test="${empty model.step_4_status}"></c:if>
			<c:if test="${'0' == model.step_4_status}">未审核</c:if>
			<c:if test="${'1' == model.step_4_status}">建议立案</c:if>
			<c:if test="${'2' == model.step_4_status}">建议不立案</c:if>
			<c:if test="${'15' == model.step_4_status}">移送</c:if>
		</td>
	  </tr>
	</table>
	<table id="tab5" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">法制受理时间</td>
	    <td width="220" height="35" align="center" valign="bottom">法制受理人</td>
	    <td width="220" height="35" align="center" valign="bottom">法制受理结果</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_5_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_5_psn}</td>
	    <td width="220" height="35" align="center">
			<c:if test="${empty model.step_5_status}"></c:if>
			<c:if test="${'0' == model.step_5_status}">未审核</c:if>
			<c:if test="${'1' == model.step_5_status}">建议立案</c:if>
			<c:if test="${'2' == model.step_5_status}">建议不立案</c:if>
			<c:if test="${'15' == model.step_5_status}">移送</c:if>
		</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_17_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_17_psn}</td>
	    <td width="220" height="35" align="center">
			<c:if test="${empty model.step_17_status}"></c:if>
			<c:if test="${'0' == model.step_17_status}">未审核</c:if>
			<c:if test="${'1' == model.step_17_status}">建议立案</c:if>
			<c:if test="${'2' == model.step_17_status}">建议不立案</c:if>
			<c:if test="${'15' == model.step_17_status}">移送</c:if>
		</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_6_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_6_psn}</td>
	    <td width="220" height="35" align="center">
			<c:if test="${empty model.step_6_status}"></c:if>
			<c:if test="${'0' == model.step_6_status}">未审核</c:if>
			<c:if test="${'1' == model.step_6_status}">建议立案</c:if>
			<c:if test="${'2' == model.step_6_status}">建议不立案</c:if>
			<c:if test="${'15' == model.step_6_status}">移送</c:if>
		</td>
	  </tr>
	</table>
	<table id="tab7" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">立案审批时间</td>
	    <td width="220" height="35" align="center" valign="bottom">立案审批人员</td>
	    <td width="220" height="35" align="center" valign="bottom">立案审批结果</td>
	    <td width="220" height="35" align="center" valign="bottom">行政处罚案件立案审批表</td>
	    <td width="220" height="35" align="center" valign="bottom">案件移送函</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center"><fmt:formatDate value="${model.step_7_date}" type="both" pattern="yyyy-MM-dd"/></td>
	    <td width="220" height="35" align="center">${model.step_7_psn}</td>
	    <td width="220" height="35" align="center">
			<c:if test="${empty model.step_7_status}"></c:if>
			<c:if test="${'0' == model.step_7_status}">未审核</c:if>
			<c:if test="${'1' == model.step_7_status}">立案</c:if>
			<c:if test="${'2' == model.step_7_status}">不立案</c:if>
			<c:if test="${'15' == model.step_7_status}">移送</c:if>
		</td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_L_S_1}">
		    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=15&page=gp_lian_spb_input&subStep=0");'>
		      		<span class="data-btn margin-auto">点击查看</span>
		      	</a>
	    	</c:if>
		</td>
		<td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_A_Y_1 && empty model.step_10_status}">
	    		<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=7&page=gp_anjian_ysh_input&subStep=0");'>
	      			<span class="data-btn margin-auto">点击查看</span>
	      		</a>
	      	</c:if>
		</td>
	  </tr>
	</table>
	</div>
</c:if>


<c:if test="${not empty model.step_9_status  && model.step_9_status != '0'}">

	<div class="title-cxjg">调查取证</div>
	<div class="margin-chx">
	<table id="tab8" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">调查询问</td>
	    <td width="220" height="35" align="center" valign="bottom">现场勘验</td>
	    <td width="220" height="35" align="center" valign="bottom">查封扣押</td>
	    <td width="220" height="35" align="center" valign="bottom">其他</td>
	    <td width="220" height="35" align="center" valign="bottom">调查报告</td>
	    <td width="220" height="35" align="center" valign="bottom">行政处罚案件立案审批表</td>
	    <td width="220" height="35" align="center" valign="bottom">延期办理审批表</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center">
			<c:if test="${not empty gp_file_dcxw }">
				<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_dcxw.file_location }">
					<span  class="data-btn margin-auto">附件查看</span>
				</a>
			</c:if>
	    </td>
	    <td width="220" height="35" align="center">
			<c:if test="${not empty gp_file_xcky }">
				<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_xcky.file_location }">
					<span  class="data-btn margin-auto">附件查看</span>
				</a>
			</c:if>
	    </td>
	    <td width="220" height="35" align="center">
			<c:if test="${not empty gp_file_cfky }">
				<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_cfky.file_location }">
					<span  class="data-btn margin-auto">附件查看</span>
				</a>
			</c:if>
	    </td>
	    <td width="220" height="35" align="center">
			<c:if test="${not empty gp_file_qt }">
				<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_qt.file_location }">
					<span  class="data-btn margin-auto">附件查看</span>
				</a>
			</c:if>
		</td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_DCBG }">
				<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_diaochabaogao&subStep=0");'>
		      		<span  class="data-btn margin-auto">点击查看</span>
		      	</a>
	    	</c:if>
		</td>
		<td width="220" height="35" align="center">
			<c:if test="${not empty D_GP_DCBG_XZCFAJ_SPB }">
		    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=15&page=gp_anjian_spb_input&docType=dcbg&subStep=0&doc_id=${model.step_9_doc_id }");'>
		      		<span class="data-btn margin-auto">点击查看</span>
		      	</a>
		     </c:if>
		</td>
		<td width="220" height="35" align="center">
			<c:if test="${not empty D_GP_DCBG_Y_S_1 }">
		    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=15&page=gp_anjian_spb_input&docType=dcbg_yq&subStep=0&doc_id=${model.step_9_doc_id }");'>
		      		<span class="data-btn margin-auto">点击查看</span>
		      	</a>
		     </c:if>
		</td>
	  </tr>
	</table>
	</div>
</c:if>


<c:if test="${not empty model.step_10_status  && model.step_10_status != '0'}">

	<div class="title-cxjg">审理决定</div>
	<div class="margin-chx">
	<table id="tab8" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">案件集中审理</td>
	    <td width="220" height="35" align="center" valign="bottom">行政处罚告知书</td>
	    <td width="220" height="35" align="center" valign="bottom">送达回证</td>
	    <td width="220" height="35" align="center" valign="bottom">听证程序</td>
	    <td width="220" height="35" align="center" valign="bottom">行政处罚案件办理审批表</td>
	    <td width="220" height="35" align="center" valign="bottom">案件移送函</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty gp_file_ajjzsl }">
				<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_ajjzsl.file_name }">
					<span  class="data-btn margin-auto">附件查看</span>
				</a>
	    	</c:if>
	    </td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_XZCF_GZS }">
				<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_anjian_spb_input&subStep=0");'>
		      		<span  class="data-btn margin-auto">点击查看</span>
		      	</a>
	    	</c:if>
	    </td>
	    <td width="220" height="35" align="center">
	    <c:if test="${not empty gp_file_sdhz }">
			<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_sdhz.file_name }">
				<span  class="data-btn margin-auto">附件查看</span>
			</a>
			</c:if>
	    </td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty gp_file_tzcx }">
				<a href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_tzcx.file_name }">
					<span  class="data-btn margin-auto">附件查看</span>
				</a>
			</c:if>
	    </td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_XZCFAJ_SPB }">
				<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_anjian_spb_input&subStep=0");'>
		      		<span  class="data-btn margin-auto">点击查看</span>
		      	</a>
	    	</c:if>
		</td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_A_Y_1 && model.step_7_status != '0' }">
	    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=10&page=gp_anjian_ysh_input&subStep=0");'>
	      		<span class="data-btn margin-auto">点击查看</span>
	      	</a>
	      	</c:if>
		</td>
	  </tr>
	</table>
	</div>
</c:if>


<c:if test="${not empty model.step_13_status && model.step_13_status != '0'}">
	<div class="title-cxjg">送达执行</div>
	<div class="margin-chx">
	<table id="tab8" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">行政处罚决定书</td>
	    <td width="220" height="35" align="center" valign="bottom">送达回证</td>
	    <td width="220" height="35" align="center" valign="bottom">缴费收据</td>
	    <td width="220" height="35" align="center" valign="bottom">其他</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_XZCF_JDS }">
				<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_xzcf_jds&subStep=0");'>
		      		<span  class="data-btn margin-auto">点击查看</span>
		      	</a>
	    	</c:if>
		</td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty gp_file_sdhz}">
				<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_sdhz.file_location }">
				<span  class="data-btn margin-auto">附件查看</span></a>    	
	    	</c:if>
		</td>
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty gp_file_jfsj_sdzx}">
					<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_jfsj_sdzx.file_location }">
					<span  class="data-btn margin-auto">附件查看</span></a>
	    	</c:if>
		</td>
		<td width="220" height="35" align="center">
	    	<c:if test="${not empty gp_file_qt}">
					<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_qt.file_location }">
					<span  class="data-btn margin-auto">附件查看</span></a>
	    	</c:if>
		</td>
	  </tr>
	</table>
	</div>

</c:if>


<c:if test="${not empty model.step_14_status && model.step_14_status != '0'}">
	<div class="title-cxjg">结案归档</div>
	<div class="margin-chx">
	<table id="tab8" width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
	  <tr class="table_xqlbbj">
	    <td width="220" height="35" align="center" valign="bottom">行政处罚结案报告</td>
	    <td width="220" height="35" align="center" valign="bottom">行政处罚案件反馈表</td>
	  </tr>
	  <tr class="table_xqlbnr">
	    <td width="220" height="35" align="center">
	    	<c:if test="${not empty D_GP_XZCF_JABG  }">
				<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_xzcf_jabg&subStep=0");'>
		      		<span  class="data-btn margin-auto">点击查看</span>
		      	</a>
	    	</c:if>
		</td>
	    <td width="220" height="35" align="center">
			<c:if test="${not empty D_GP_XZCF_AJFKB }">
		    	<a href='javascript:openNewPage("/ciqs/generalPunishment/toPage?id=${model.id}&step=14&page=gp_xzcf_ajfkb&subStep=0");'>
		      		<span  class="data-btn margin-auto">点击查看</span>
		      	</a>
	    	</c:if>
		</td>
	  </tr>
	</table>
	</div>
</c:if>




<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
	<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
</div>




<div class="title-cxjg"  ></div>
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
