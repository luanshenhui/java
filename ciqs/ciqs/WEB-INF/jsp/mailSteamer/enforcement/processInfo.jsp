<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>进出境邮轮检疫</title>
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
<script type="text/javascript">
	$(function() {
		$("#imgd1").hide();
		var totalSss = 0;
		var addHour = 0;
		var procArray = eval('(' + $("#procArray").val() + ')');
		console.log("procArray：：：",procArray)
		$(".writeHour").each(
				function() {
					var id = this.id;
					var index = id.substring(4);
					if (null != procArray[index - 1]
							&& null != procArray[index - 1].create_date_str
							&& '' != procArray[index - 1].create_date_str) {
						$("#psn" + index)
								.text(procArray[index - 1].create_user);
						$("#date" + index).text(
								procArray[index - 1].create_date_str);
						$("#icon" + index).addClass("icongreen");
					} else {
						$("#psn" + index).text("");
						$("#date" + index).text('');
						$("#icon" + index).addClass("iconyellow");
					}
					if (index > 1) {
						var dateText = $("#date" + index).text();
						var dateText0 = $("#date" + (index - 1)).text();
						if (dateText != '' && dateText0 != '') {
							addHour = getHour(dateText0, dateText);
							$("#hour" + (index - 1)).text("+" + addHour);
							totalSss += getSss(dateText0, dateText);
						} else {
							$("#hour" + (index - 1)).text("-");
						}
					}
				});
		
		
		$("#totalHour").text(ciqFormatTime(2,6,"date"));
	});

	function formatTimes(times){
		var day = Math.floor(times / 86400000);
		times = times - 86400000 * day;
		var hour = Math.floor(times / 3600000);
		times = times - 3600000 * hour;
		var min = Math.floor(times / 60000);
		if(day > 0 && day < 10){
			day = '0'+day;
		}
		if(hour > 0 && hour < 10){
			hour = '0'+hour;
		}
		if(min > 0 && min < 10){
			min = '0'+min;
		}
		return day + '天' + hour + '小时' + min + '分钟';
	}
	
	/**
	 * 计算2个日期的天数
	 */
	function getDay(startDate) {
		var date1 = new Date(startDate);
		var date2 = new Date();
		var day = "";
		day = (date2.getTime() - date1.getTime()) / (1000 * 60 * 60 * 24);
		return day;
	}

	/**
	 * 计算2个日期小时差
	 */
	function getHour(startDate, endDate) {
		var date1 = new Date(startDate);
		var date2 = new Date(endDate);
		var hour = "";
		hour = (date2.getTime() - date1.getTime()) / (1000 * 60 * 60);
		hour = hour.toFixed(2);
		return hour;
	}

	/**
	 * 计算2个日期毫秒差
	 */
	function getSss(startDate, endDate) {
		var date1 = new Date(startDate);
		var date2 = new Date(endDate);
		var sss = 0;
		sss = date2.getTime() - date1.getTime();
		return sss;
	}

	function formatSss(sss) {
		var hours = parseInt(sss / (1000 * 60 * 60));
		var minutes = parseInt(sss % (1000 * 60 * 60) / (1000 * 60));
		var seconds = parseInt(sss % (1000 * 60) / 1000);
		return (hours < 10 ? "0" + hours : hours) + ":"
				+ (minutes < 10 ? "0" + minutes : minutes);// + "分钟";// + (seconds < 10 ? "0"+seconds : seconds);
	}

	//图片预览
	function showPic(path) {
		url = "/ciqs/showVideo?imgPath=" + path;
		$("#imgd1").attr("src", url);
		$("#imgd1").click();
	}

	//打开模板表格
	function showTemplate(doc_id) {
		window.open("processtemplate?doc_id=" + doc_id);
	}

	//显示卫生监督表
	function showHlthTable(dec_master_id, type) {
		window.open("showhlthchecklist?dec_master_id=" + dec_master_id
				+ "&hlth_check_type=" + type);
	}

// 	//视频观看
// 	function showVideo(path) {
// 		path = path.substring(path.indexOf('/') + 1, path.length);
// 		$("#CuPlayerMiniV").show();
// 		CuPlayerMiniV(path);
// 	}

// 	//关闭视频
// 	function hideVideo() {
// 		$("#CuPlayerMiniV").hide();
// 	}

	function getPlace(place_number) {
		console.log(place_number)
		window.scroll(0, document.getElementById(place_number).offsetTop - 306);
	}
</script>
</head>
<body  class="bg-gary">
<div class="freeze_div_dtl" style="position: fixed;width: 100%;background-color:#f0f2f5;top:0px;height:306px;">
	<div class="title-bg" >
      	<div class="title-position margin-auto white">
              <div class="title"><span class="font-24px" style="color:white;">行政确认 /</span><a style="color:white;" href="showenforcementprocess">进出境邮轮检疫</a></div>
              <%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
         </div>
     </div>
     <div class="flow-bg"  style=" height:235px;" >
		<div class="flow-position2 margin-auto"  style=" height:235px;" >
		<ul class="white font-18px flow-height font-weight">
			<li>申报</li>
			<li>准备</li>
			<li>登轮检疫</li>
			<li>上报通报</li>
			<li>行政处罚</li>
			<li>归档</li>
			<li></li>
			<li></li>
			<li></li>
		</ul>
		<ul class="flow-icon">
		  <li id="icon1"><div class="hour white font-12px"><span id="hour1" class="writeHour"></span></div><a href="#tab1"><img src="${ctx}/static/show/images/mailSteamer/mailSteamer1.png" width="80" height="80" onclick="getPlace('module_1')"/></a></li>
		  <li id="icon2"><div class="hour white font-12px"><span id="hour2" class="writeHour"></span></div><a href="#tab2"><img src="${ctx}/static/show/images/mailSteamer/mailSteamer2.png" width="80" height="80" onclick="getPlace('module_2')"/></a></li>
		  <li id="icon3"><div class="hour white font-12px"><span id="hour3" class="writeHour"></span></div><a href="#tab3"><img src="${ctx}/static/show/images/mailSteamer/mailSteamer3.png" width="80" height="80" onclick="getPlace('module_3')"/></a></li>
		  <li id="icon4"><div class="hour white font-12px"><span id="hour4" class="writeHour"></span></div><a href="#tab4"><img src="${ctx}/static/show/images/mailSteamer/mailSteamer4.png" width="80" height="80" onclick="getPlace('module_4')"/></a></li>
		  <li id="icon5" class="iconyellow"><div class="hour white font-12px"><span id="hour5" class="writeHour"></span></div><a href="#tab5"><img src="${ctx}/static/show/images/mailSteamer/mailSteamer5.png" width="80" height="80" onclick="getPlace('module_5')"/></a></li>
		  <li id="icon6"><div class="hour white font-12px"><span id="hour6" class="writeHour"></span></div><a href="#tab6"><img src="${ctx}/static/show/images/mailSteamer/mailSteamer6.png" width="80" height="80" onclick="getPlace('module_6')"/></a></li>
		  <li></li>
		  <li></li>
		  <li style="white-space: nowrap;" class="white font-18px font-weight" > <br /><span id="totalHour">0</span></li>
		</ul>
		<ul class="flow-info" >
			<li><span id="psn1" ></span><br />
			  <span class="font-10px" ><span id="date1" ></span></span>
			</li>
			<li><span id="psn2" ></span><br />
			  <span class="font-10px" ><span id="date2" ></span></span>
			</li>
			<li><span id="psn3" ></span><br />
			  <span class="font-10px" ><span id="date3" ></span></span>
			</li>
			<li><span id="psn4" ></span><br />
			  <span class="font-10px" ><span id="date4" ></span></span>
			</li>
			<li><span id="psn5" ></span><br />
			  <span class="font-10px" ><span id="date5" ></span></span>
			</li>
			<li><span id="psn6" ></span><br />
			  <span class="font-10px" ><span id="date6" ></span></span>
			</li>
			<li></li>
			<li></li>
			<li class="font-10px"></li>
		</ul>
		</div>
		</div>
</div>

<div class="blank_div_dtl" style="margin-top:306px;">
</div>

	<div class="margin-chx">
		<input type="hidden" id="procArray" value="${procArray }" />
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
			<tr class="table_xqlbbj">
				<td width="150" height="35" align="center" >中文船名</td>
				<td width="100" height="35" align="center" >英文船名</td>
				<td width="150" height="35" align="center" >呼号</td>
				<td width="100" height="35" align="center" >近四周寄港及日期</td>
				<td width="100" height="35" align="center" >船舶免予卫生控制措施证书/船舶卫生控制措施证书签发港及日期</td>
				<td width="100" height="35" align="center" >交通工具卫生证书签发港及日期</td>
				<td width="150" height="35" align="center" >检疫方式</td>
				<td width="150" height="35" align="center" >直属局</td>
				<td width="150" height="35" align="center" >分支机构</td>
			</tr>
			<tr class="table_xqlbnr">
				<td width="150" height="35" align="center">${results.CN_VSL_M }</td>
				<td width="100" height="35" align="center">${results.FULL_VSL_M }</td>
				<td width="150" height="35" align="center">${results.VSL_CALLSIGN }</td>
				<td width="100" height="35" align="center">${results.LAST_FOUR_PORT }</td>
				<td width="100" height="35" align="center">${results.SHIP_SANIT_CERT }</td>
				<td width="100" height="35" align="center">${results.TRAF_CERT }</td>
				<td width="150" height="35" align="center">${results.CHK_NOTIFY }</td>
				<td width="150" height="35" align="center">${results.ORG_CODE }</td>
				<td width="150" height="35" align="center">${results.DEPT_CODE }</td>
			</tr>
		</table>
	</div>

	<div class="title-cxjg" id="module_1">申报</div>
	<div class="margin-chx">
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
			<tr class="table_xqlbbj">
				<td width="150" height="35" align="center" >申报时间</td>
				<td width="100" height="35" align="center" >申报单位</td>
				<td width="150" height="35" align="center" >申请检疫方式</td>
			</tr>
			<tr class="table_xqlbnr">
				<td width="150" height="35" align="center">${results.DEC_DATE }</td>
				<td width="100" height="35" align="center">${results.DEC_ORG }</td>
				<td width="150" height="35" align="center">${results.CHK_DEC }</td>
			</tr>
		</table>
	</div>

	<c:if test="${not empty V_JC_T_Y_D_8 || not empty D_JC_T_Y_8.doc_id}">
		<div class="title-cxjg" id="module_2">准备</div>
		<div class="margin-chx">
			<table width="100%" border="0" class="table-xqlb">
			<c:forEach items="${V_JC_T_Y_D_8 }" var="v" varStatus="status">
				<tr>
					<c:if test="${status.index==0 }">
						<td rowspan="${fn:length(V_JC_T_Y_D_8)}" width="250" class="table_xqlbbj2">仪器领用表</td>
					</c:if>
					<td align="left" style="padding-left:100px">
					操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>${v.create_date_str }
					</span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue"> ${v.create_user } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</div>
					</td>
				</tr>
			</c:forEach>
			</table>
			<c:if test="${not empty D_JC_T_Y_8.doc_id }">
			<table width="100%" border="0" class="table-xqlb">
				<tr>
					<td width="250" class="table_xqlbbj2">要求船方预先准备清单</td>
					<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
								value="${D_JC_T_Y_8.dec_date }" type="both"
								pattern="yyyy-MM-dd HH:mm:ss" />
					</span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue"> ${D_JC_T_Y_8.dec_user_cn } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<a
								href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${results.DEC_MASTER_ID}&page=ms_2yuxianzhunbeiqingdan');">查看</a>
						</div>
					</td>
				</tr>
			</table>
			</c:if>
		</div>
	</c:if>

	<c:if test="${not empty DENG_LUN_JIAN_YI || not empty D_OC_PAGE_1 || not empty D_OC_PAGE_2 || not empty D_JC_T_Y_4.proc_main_id || not empty D_OC_REGISTER.dec_date || not empty V_JC_T_Y_D_5 || not empty V_JC_T_Y_D_9}">
	<div class="title-cxjg" id="module_3">登轮检疫</div>
	</c:if>
	<div class="margin-chx">
		<c:if test="${not empty V_JC_T_Y_D_9}">
			<div style="float:left; padding-left:40px;">登轮前事项</div>
		</c:if>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
			<c:forEach items="${V_JC_T_Y_D_9 }" var="v" varStatus="status">
			<tr>
				<c:if test="${status.index==0 }">
					<td rowspan="${fn:length(V_JC_T_Y_D_9)}" width="250" class="table_xqlbbj2">违规事项</td>
				</c:if>
				<td align="left" style="padding-left:100px">
				操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
						value="${v.create_date }" type="both"
						pattern="yyyy-MM-dd HH:mm:ss" />
				</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="blue"> ${v.create_user } </span>
				</td>
				<td width='300' align='right' valign='middle' style='padding:0px'>
					<div style='float:right;margin-right:60px'>
						<span>${v.name }</span>
						<c:if test="${v.file_type == '1' }">
							<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
						</c:if>
						<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
						</c:if>
					</div>
				</td>
			</tr>
			</c:forEach>
		</table>
		
		<c:if test="${not empty D_OC_PAGE_1 || not empty D_OC_PAGE_2 || not empty D_JC_T_Y_4.proc_main_id || not empty D_OC_REGISTER.dec_date || not empty V_JC_T_Y_D_5}">
		<div style="float:left; padding-left:40px;">文件审核流行病调查医学</div>
		</c:if>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
			<c:if test="${not empty D_OC_PAGE_1 }">
				<tr>
					<td width='250' class="table_xqlbbj2">申报无异常事项时</td>
					<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
								value="${D_OC_PAGE_1.dec_date }" type="both"
								pattern="yyyy-MM-dd HH:mm:ss" />
					</span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue"> ${D_OC_PAGE_1.dec_user_cn } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<a
								href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${results.DEC_MASTER_ID}&page=ms_shenbaowuyichangshixiang');">查看</a>
						</div>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty D_OC_PAGE_2}">
				<tr>
					<td width='250' class="table_xqlbbj2">有可疑病例时</td>
					<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
								value="${D_OC_PAGE_2.dec_date }" type="both"
								pattern="yyyy-MM-dd HH:mm:ss" />
					</span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue"> ${D_OC_PAGE_2.dec_user_cn } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<a
								href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${results.DEC_MASTER_ID}&page=ms_youwukeyibingli');">查看</a>
						</div>
					</td>
				</tr>
			</c:if>
		</table>
		<c:if test="${not empty V_JC_T_Y_D_10 }">	
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
				<c:forEach items="${V_JC_T_Y_D_10 }" var="v" varStatus="status">
					<tr>
						<c:if test="${status.index==0 }">
							<td rowspan="${fn:length(V_JC_T_Y_D_10)}" width="250" class="table_xqlbbj2">有突发公共卫生事件时</td>
						</c:if>
						<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>
						<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
						</span>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="blue"> ${v.create_user } </span>
						</td>
						<td width='300' align='right' valign='middle' style='padding:0px'>
							<div style='float:right;margin-right:60px'>
								<span>${v.name}</span>
								<c:if test="${v.file_type == '1' }">
									<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
								</c:if>
								<c:if test="${v.file_type != '1' }">
										<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
								</c:if>
							</div>
						</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
		<c:if test="${not empty D_JC_T_Y_4.proc_main_id }">
			<tr>
				<td width='250' class="table_xqlbbj2">其他事项</td>
				<td align="left" style="padding-left:100px">
					操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
							value="${D_JC_T_Y_4.dec_date }" type="both"
							pattern="yyyy-MM-dd HH:mm:ss" />
				</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="blue"> ${D_JC_T_Y_4.dec_user_cn } </span>
				</td>
				<td width='300' align='right' valign='middle' style='padding:0px'>
					<div style='float:right;margin-right:60px'>
						${D_JC_T_Y_4.option_1 }
					</div>
				</td>
			</tr>
		</c:if>
			
		<c:if test="${not empty D_OC_REGISTER }">
			<tr>
				<td width='250' class="table_xqlbbj2" rowspan="${fn:length(V_JC_T_Y_D_5) + 1}">结果登记</td>
				<td align="left" style="padding-left:100px">
					操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
							value="${D_OC_REGISTER.dec_date }" type="both"
							pattern="yyyy-MM-dd HH:mm:ss" />
				</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="blue"> ${D_OC_REGISTER.dec_user_cn } </span>
				</td>
				<td width='300' align='right' valign='middle' style='padding:0px'>
					<div style='float:right;margin-right:60px'>
						<a
							href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${results.DEC_MASTER_ID}&page=ms_rujingchuanbojianyichayanjilubiao');">查看</a>
					</div>
				</td>
			</tr>
			<c:forEach items="${V_JC_T_Y_D_5 }" var="v" varStatus="status">
				<tr>
					<td align="left" style="padding-left:100px">
					操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>
					<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
					</span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue"> ${v.create_user } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</div>
					</td>
				</tr>
			</c:forEach>
			</c:if>
		</table>
		
		<c:if test="${not empty hlthChk.check_date || not empty V_MS_E_R || not empty V_JC_T_Y_D_1 || not empty V_JC_T_Y_D_2 || not empty D_MS_SP_GD }">
		<div style="float:left; padding-left:40px;">卫生监督</div>
		</c:if>
		<c:if test="${not empty hlthChk.check_date }">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
			<tr>
				<td width="250" class="bg-gary flow-td-bord">监督结果</td>
				<td align="left" style="padding-left:100px">
					操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'><fmt:formatDate
								value="${hlthChk.check_date }" type="both"
								pattern="yyyy-MM-dd HH:mm:ss" /> </span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="blue">${hlthChk.check_psn } </span>
				</td>
				<td width="300" align="right" valign="middle" style="padding:0px">
					<div style="float:right;margin-right:60px">
						<a
							href="javascript:openNewPage('/ciqs/mailSteamer/showhlthchecklist?dec_master_id=${results.DEC_MASTER_ID}');">查看</a>
					</div>
				</td>
			</tr>
		</table>
		</c:if>
		<c:if test="${not empty V_MS_E_R }">
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
				<c:forEach items="${V_MS_E_R }" var="v" varStatus="status">
					<tr>
						<c:if test="${status.index==0 }">
							<td rowspan="${fn:length(V_MS_E_R)}" width="250" class="table_xqlbbj2">专项卫生监督 - 证据报告表</td>
						</c:if>
						<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>
						<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
						</span>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="blue"> ${v.create_user } </span>
						</td>
						<td width='300' align='right' valign='middle' style='padding:0px'>
							<div style='float:right;margin-right:60px'>
								<c:if test="${v.file_type == '1' }">
									<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
								</c:if>
								<c:if test="${v.file_type != '1' }">
										<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
								</c:if>
							</div>
						</td>
					</tr>
				</c:forEach>
		</table>
		</c:if>
		
		<c:if test="${not empty V_JC_T_Y_D_1 }">
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
		class="table-xqlb">
			<c:forEach items="${V_JC_T_Y_D_1 }" var="v" varStatus="status">
				<tr>
					<c:if test="${status.index==0 }">
						<td rowspan="${fn:length(V_JC_T_Y_D_1)}" width="250" class="table_xqlbbj2">船舶卫生监督评分表照片/视频 </td>
					</c:if>
					<td align="left" style="padding-left:100px">
					操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>
					<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
					</span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue"> ${v.create_user } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</div>
					</td>
				</tr>
			</c:forEach>
		</table>
		</c:if>
		<c:if test="${not empty V_JC_T_Y_D_2_DOC }">
			<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
					<tr>
						<td width="250" class="bg-gary flow-td-bord">船舶检查文件清单</td>
						<td align="left" style="padding-left:100px">
							操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
									value="${V_JC_T_Y_D_2_DOC.dec_date }" type="both"
									pattern="yyyy-MM-dd HH:mm:ss" />
						</span>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="blue"> ${V_JC_T_Y_D_2_DOC.dec_user_cn } </span>
						</td>
						<td width="300" align="right" valign="middle" style="padding:0px">
								<div style="float:right;margin-right:60px">
										<a href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${V_JC_T_Y_D_2_DOC.proc_main_id}&page=ms_zxwsjd_wenjianqingdan');">查看</a>
								</div>
						</td>
					</tr>
			</table>
		</c:if>				
		<c:if test="${not empty V_JC_T_Y_D_2 }">
			<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
				<c:forEach items="${V_JC_T_Y_D_2 }" var="v" varStatus="status">
					<tr>
						<c:if test="${status.index==0 }">
							<td width="250" class="bg-gary flow-td-bord" rowspan="${fn:length(V_JC_T_Y_D_2) }">船舶检查文件清单照片/视频</td>
						</c:if>
						<td align="left" style="padding-left:100px">
							操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'> <fmt:formatDate
									value="${v.create_date }" type="both"
									pattern="yyyy-MM-dd HH:mm:ss" />
						</span>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
							<span class="blue"> ${v.create_user } </span>
						</td>
						<td width="300" align="right" valign="middle" style="padding:0px">
							<c:if test="${v.file_type == '1' }">
								<div style="float:right;margin-right:60px">
									<img style="cursor: pointer;" src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" title="照片查看" onclick="showPic('${v.file_name}')" />
								</div>
							</c:if>
							<c:if test="${v.file_type == '2' }">
								<div style="float:right;margin-right:60px">
									<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
								</div>
							</c:if>
							
						</td>
					</tr>
				</c:forEach>
			</table>
		</c:if>
			
		<c:if test="${not empty D_MS_SP_GD }">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
				<tr>
					<td width="250" class="bg-gary flow-td-bord">船舶卫生监督评分表</td>
					<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'><fmt:formatDate
									value="${D_MS_SP_GD.dec_date }" type="both"
									pattern="yyyy-MM-dd HH:mm:ss" /> </span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue">${D_MS_SP_GD.dec_user_cn } </span>
					</td>
					<td width="300" align="right" valign="middle" style="padding:0px">
						<div style="float:right;margin-right:60px">
							<a href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${results.DEC_MASTER_ID}&page=ms_chuanboweishengjiandupengfenbiao');">查看</a>
						</div>
					</td>
				</tr>
			</table>
		</c:if>
	
		<c:if test="${not empty samp.samp_date }">
			<div style="float:left; padding-left:40px;">采样</div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0"
				class="table-xqlb">
				<tr>
					<td width='250' class="table_xqlbbj2">采样记录</td>
					<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'><fmt:formatDate
										value="${samp.samp_date }" type="both"
										pattern="yyyy-MM-dd HH:mm:ss" />  </span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue">${samp.samp_psn } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<a
								href="javascript:openNewPage('/ciqs/mailSteamer/showSampList?dec_master_id=${results.DEC_MASTER_ID}');">查看</a>
						</div>
					</td>
				</tr>
			</table>
		</c:if>
		
		<c:if test="${not empty chkDeal.check_deal_date }">
			<div style="float:left; padding-left:40px;">检疫处理</div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0"
				class="table-xqlb">
				<tr>
					<td width='250' class="table_xqlbbj2">检疫处理记录</td>
					<td align="left" style="padding-left:100px">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'><fmt:formatDate
										value="${chkDeal.check_deal_date }" type="both"
										pattern="yyyy-MM-dd HH:mm:ss" /> </span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue">${chkDeal.check_deal_psn } </span>
					</td>
					<td width='300' align='right' valign='middle' style='padding:0px'>
						<div style='float:right;margin-right:60px'>
							<a
								href="javascript:openNewPage('/ciqs/mailSteamer/showChkDealList?dec_master_id=${results.DEC_MASTER_ID}');">查看</a>
						</div>
					</td>
				</tr>
			</table>
		</c:if>
		 <c:if test="${not empty resultCheck.CREATE_DATE }"> 
		<div style="float:left; padding-left:40px;">结果判定</div>
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
			<tr>
				<td width='250' class="table_xqlbbj2">判定结果</td>
				<td align="left" style="padding-left:100px">
					操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>${resultCheck.CREATE_DATE }</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="blue"> ${resultCheck.CHECK_DEAL_PSN }</span>
				</td>
				<td width='300' align='right' valign='middle' style='padding:0px'>
					<div style='float:right;margin-right:60px'>
							<a
								href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${results.DEC_MASTER_ID}&page=ms_pandingjieguo');">查看</a>
						</div>
				</td>
			</tr>
		</table>
	   </c:if> 
		
		<c:if test="${not empty V_MS_OP_ZS_QF || not empty V_JC_T_Y_D_6 }">
		<div style="float:left; padding-left:40px;">证书签发</div>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
		<c:forEach items="${V_MS_OP_ZS_QF }" var="v" varStatus="status">
			<tr>
				<c:if test="${status.index==0 }">
					<td rowspan="${fn:length(V_MS_OP_ZS_QF)}" width="250" class="table_xqlbbj2">Free Pratique</td>
				</c:if>
				<td align="left" style="padding-left:100px">
				操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>
				<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
				</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="blue"> ${v.create_user } </span>
				</td>
				<td width='300' align='right' valign='middle' style='padding:0px'>
					<div style='float:right;margin-right:60px'>
						<c:if test="${v.file_type == '1' }">
							<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
						</c:if>
						<c:if test="${v.file_type != '1' }">
							<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
						</c:if>
					</div>
				</td>
			</tr>
		</c:forEach>
		<c:forEach items="${V_JC_T_Y_D_6 }" var="v" varStatus="status">
			<tr>
				<c:if test="${status.index==0 }">
					<td rowspan="${fn:length(V_JC_T_Y_D_6)}" width="250" class="table_xqlbbj2">Pratique</td>
				</c:if>
				<td align="left" style="padding-left:100px">
				操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'>
				<fmt:formatDate value="${v.create_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
				</span>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="blue"> ${v.create_user } </span>
				</td>
				<td width='300' align='right' valign='middle' style='padding:0px'>
					<div style='float:right;margin-right:60px'>
						<c:if test="${v.file_type == '1' }">
							<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
						</c:if>
						<c:if test="${v.file_type != '1' }">
							<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
						</c:if>
					</div>
				</td>
			</tr>
		</c:forEach>
		</table>
		</c:if>
	</div>
	
	<div class="title-cxjg" id="module_4">上报通报</div>
	<div class="margin-chx" id="isSpacal1">
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
			<tr class="table_xqlbbj">
				<td width="50%" height="35" align="center" >上报通报</td>
				<td height="35" align="center" ><a target="_blank" href="http://10.239.31.5/mainwan.asp">疫情上报系统</a></td>
			</tr>
		</table>
	</div>
	
	<div class="title-cxjg" id="module_5">行政处罚</div>
	<div class="margin-chx" id="isSpacal2">
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
			<tr class="table_xqlbbj">
				<td width="50%" height="35" align="center" >行政处罚</td>
				<td height="35" align="center" ><a target="_blank" href="/ciqs/generalPunishment/pnIndex">行政处罚系统</a></td>
			</tr>
		</table>
	</div>

	<!-- 
	<div class="title-cxjg" id="module_6">归档</div>
	<div class="margin-chx">
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-xqlb">
			<tr>
				<td width='250' class="table_xqlbbj2">归档内容</td>
				<td align="left" style="padding-left:100px">
					<c:if test="${not empty D_JC_T_Y_5.dec_date }">
						操作时间:&nbsp;&nbsp;&nbsp;&nbsp; <span class='blue'><fmt:formatDate
									value="${D_JC_T_Y_5.dec_date }" type="both"
									pattern="yyyy-MM-dd HH:mm:ss" /></span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="blue">${D_JC_T_Y_5.dec_user }</span>
					</c:if>
				</td>
				<td width='300' align='right' valign='middle' style='padding:0px'>
					<div style='float:right;margin-right:60px'>
						<a
							href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${results.DEC_MASTER_ID}&page=ms_guidangxiangxiliebiao');">归档</a>
					</div>
				</td>
			</tr>
		</table>

	</div>
 -->
 		<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
			<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>
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
</body>
<%@ include file="/common/player.jsp"%>
</html>
