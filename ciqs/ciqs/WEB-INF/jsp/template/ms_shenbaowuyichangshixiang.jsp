<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>归档用文件</title>
<%@ include file="/common/resource_show.jsp"%>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<style type="text/css">
body div {
	width: 1000px;
	margin: 5px auto;
}
/* div{
   overflow:auto;
   font-size: 22px;
} */
.chatTitle {
	text-align: left;
	font-size: 30px;
	font-weight: 600;
}

.tableLine {
	border: 1px solid #000;
}

.fangxingLine {
	font-size: 10;
	margin-left: 5px;
	margin-right: 5px;
	border: 2px solid #000;
	font-weight: 900;
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
</style>
</head>
<body>
	<script type="text/javascript">
		$("#imgd1").hide();
		//图片预览
		function showPic(path) {
			console.log(path)
			url = "/ciqs/showVideo?imgPath=" + path;
			$("#imgd1").attr("src", url);
			$("#imgd1").click();
		}
	</script>
	<div>
		<div class="chatTitle">归档用文件</div>
		<table width="980" border="0" align="left"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					航海健康申报书Maritime Declaration of Health</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_1=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_1=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_2=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_2=='1'}">
						<span>有问题</span>
					</c:if>
					<a href="toDocPage?proc_main_id=${proc_main_id}&page=ms_hanghaijiankangshengbao">查看</a>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					总申报单General declaration</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_3=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_3=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_4=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_4=='1'}">
						<span>有问题</span>
					</c:if>
					文字描述：${doc.option_54} <span id="V_D_OC_PAGE_1_2" class="vList">
						<c:forEach items="${V_D_OC_PAGE_1_2 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					货物申报单Cargo declaration</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_5=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_5=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_6=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_6=='1'}">
						<span>有问题</span>
					</c:if>
					文字描述：${doc.option_57 } <span id="V_D_OC_PAGE_1_3"> <c:forEach
							items="${V_D_OC_PAGE_1_3 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					船用物品清单Ships Stores Declaration</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_7=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_7=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_8=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_8=='1'}">
						<span>有问题</span>
					</c:if>
							文字描述：${doc.option_60 } <span id="V_D_OC_PAGE_1_4"> <c:forEach
							items="${V_D_OC_PAGE_1_4 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					船员名单Crew list</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_9=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_9=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_10=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_10=='1'}">
						<span>有问题</span>
					</c:if>文字描述：${doc.option_63 } <span id="V_D_OC_PAGE_1_5"> <c:forEach
							items="${V_D_OC_PAGE_1_5 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					旅客名单Passenger list</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_11=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_11=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_12=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_12=='1'}">
						<span>有问题</span>
					</c:if>文字描述：${doc.option_66 } <span id="V_D_OC_PAGE_1_6"> <c:forEach
							items="${V_D_OC_PAGE_1_6 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					航次表Ports of call</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_13=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_13=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_14=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_14=='1'}">
						<span>有问题</span>
					</c:if>文字描述：${doc.option_69} <span id="V_D_OC_PAGE_1_7"> <c:forEach
							items="${V_D_OC_PAGE_1_7 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					食品饮用水清单(注明供应港口及产地)food drinking water list (note the supplied port
					and produced region)</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_15=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_15=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_16=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_16=='1'}">
						<span>有问题</span>
					</c:if>文字描述：${doc.option_72} <span id="V_D_OC_PAGE_1_8"> <c:forEach
							items="${V_D_OC_PAGE_1_8 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					压舱水申报单IMO ballast water reporting form</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_17=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_17=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_18=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_18=='1'}">
						<span>有问题</span>
					</c:if><span id="V_JC_T_Y_D_45"> <c:forEach
							items="${V_JC_T_Y_D_45 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span> </br> 采样文字：${doc.option_19 } <span id="V_JC_T_Y_D_11"> <c:forEach
							items="${V_JC_T_Y_D_11 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span> <c:forEach items="${caiyang }" var="cy">
						</br>
					采样文字：${cy.name }
					<span id="V_JC_T_Y_D_46"> <c:forEach
								items="${V_JC_T_Y_D_46 }" var="v">
								<c:if test="${v.name == cy.name}">
									<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
								</c:if>
							</c:forEach>
						</span>
					</c:forEach>
					</br> 存封文字：${doc.option_21 } <span id="V_JC_T_Y_D_12"> <c:forEach
							items="${V_JC_T_Y_D_12 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
					</span>
					<c:forEach items="${cunfeng }" var="cf">
						</br>
					存封文字：${cf.name }
					<span id="V_JC_T_Y_D_47"> <c:forEach
								items="${V_JC_T_Y_D_47 }" var="v">
								<c:if test="${v.name == cf.name}">
									<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
								</c:if>
							</c:forEach>
						</span>
					</c:forEach>
					</br>
					<span>处理对象：${mscdm1.check_deal_proj }</span>
					</br>
					<span>处理依据：${mscdm1.check_deal_couse }</span>
					</br>
					<span>相关证单：
						<c:forEach items="${xdNotice }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
						<c:forEach items="${xdNoticeVideo }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
					</span>
					</br>
					<span>处理方法：
					<c:choose>
						<c:when test="${mscdm2.check_deal_method == '1' }">
							消毒
						</c:when>
						<c:when test="${mscdm1.check_deal_method == '2' }">
							杀虫
						</c:when>
						<c:when test="${mscdm1.check_deal_method == '3' }">
							除鼠
						</c:when>
						<c:when test="${mscdm1.check_deal_method == '4' }">
							除污
						</c:when>
						<c:when test="${mscdm1.check_deal_method == '5' }">
							其他
						</c:when>
					</c:choose>
					</br>
					<span>处理过程：
						<c:forEach items="${xdPic }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
						<c:forEach items="${xdPicVideo }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
					</span>
					</br>
					<span>处理公司：${mscdm1.check_deal_company }</span>
					</br>
					<span>完成状态：
					<c:if test="${mscdm1.is_commit=='true' }">完成</c:if><c:if test="${mscdm1.is_commit=='false' }">未完成</c:if></span>
					</span>
					</br>
					<span>是否合格：
					<c:if test="${mscdm1.qualified_flag=='1' }">合格</c:if>
					<c:if test="${mscdm1.qualified_flag=='0' }">不合格</c:if>
					</span>
					</br>
					<span>其他：${doc.option_23 }</span>
						<span id="V_D_OC_PAGE_1_9"> <c:forEach
								items="${V_D_OC_PAGE_1_9 }" var="v">
								<c:if test="${v.name == cf.name}">
									<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
								</c:if>
							</c:forEach>
						</span>
				</td>
			</tr>
		</table>

		<div class="chatTitle">查阅用文件</div>
		<table width="980" border="0" align="left"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">旅客诊疗记录</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_24=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_24=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_25=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_25=='1'}">
						<span>有问题</span>
					</c:if> <span id="V_JC_T_Y_D_13"> <c:forEach
							items="${V_JC_T_Y_D_13 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span> </br> 1.可疑病例已处置文字：${doc.option_27} <span id="V_JC_T_Y_D_14"> <c:forEach
							items="${V_JC_T_Y_D_14 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span> 
				</br>
				<span>2.可疑病例未处置</span>
				</br>
				<span>
					<a target="_blank" href="toDocPage?proc_main_id=${proc_main_id }&page=ms_youwukeyibingli&doc_groupid=A">可疑病例排查模块</a>
				</span>
				</br>
				<span>船方病例相关资料文字：${doc.option_29}</span>
				</td>
			</tr>

			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">船员诊疗记录</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_29=='0'}">
						<span>有</span>
					</c:if> 
					<c:if test="${doc.option_29=='1'}">
						<span>无</span>
					</c:if>
					<c:if test="${doc.option_30=='0'}">
						<span>没问题</span>
					</c:if> 
					<c:if test="${doc.option_30=='1'}">
						<span>有问题</span>
					</c:if> <span id="V_JC_T_Y_D_15"> <c:forEach
							items="${V_JC_T_Y_D_15 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span> </br> 可疑病例已处置文字：${doc.option_31} <span id="V_JC_T_Y_D_16"> <c:forEach
							items="${V_JC_T_Y_D_16 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span> 
				</br>
				<span>2.可疑病例未处置</span>
				</br>
				<span>
					<a target="_blank" href="toDocPage?proc_main_id=${proc_main_id }&page=ms_youwukeyibingli&doc_groupid=B">可疑病例排查模块</a>
				</span>
				</br>
				<span> 船方病例相关资料文字：${doc.option_32}</span>
				</td>
			</tr>

			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					卫生控制</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${doc.option_20=='0'}">
						<span>没问题</span>
					</c:if> <c:if test="${doc.option_20=='1'}">
						<span>有问题</span>
					</c:if> 文字描述：${doc.option_78} <span id="V_JC_T_Y_D_17"> <c:forEach
							items="${V_JC_T_Y_D_17 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>

			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					预防接种证书</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					 <c:if test="${doc.option_22=='0'}">
						<span>没问题</span>
					</c:if> <c:if test="${doc.option_22=='1'}">
						<span>有问题</span>
					</c:if> 文字描述：${doc.option_81} <span id="V_JC_T_Y_D_18"> <c:forEach
							items="${V_JC_T_Y_D_18 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>

			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">健康证</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					 <c:if test="${doc.option_24=='0'}">
						<span>没问题</span>
					</c:if> <c:if test="${doc.option_24=='1'}">
						<span>有问题</span>
					</c:if> 文字描述：${doc.option_84} <span id="V_JC_T_Y_D_19"> <c:forEach
							items="${V_JC_T_Y_D_19 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>

			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					健康申明卡</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					 <c:if test="${doc.option_26=='0'}">
						<span>没问题</span>
					</c:if> <c:if test="${doc.option_26=='1'}">
						<span>有问题</span>
					</c:if> 文字描述：${doc.option_87} <span id="V_JC_T_Y_D_20"> <c:forEach
							items="${V_JC_T_Y_D_20 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>

			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">其他</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					 <c:if test="${doc.option_28=='0'}">
						<span>没问题</span>
					</c:if> <c:if test="${doc.option_28=='1'}">
						<span>有问题</span>
					</c:if> 文字描述：${doc.option_90} <span id="V_JC_T_Y_D_21"> <c:forEach
							items="${V_JC_T_Y_D_21 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									
							</c:if>
						</c:forEach>
				</span>
				</td>
			</tr>
		</table>
		<div class="chatTitle">船方要求预先准备的文件清单</div>
		<table width="980" border="0" align="left"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">船方要求预先准备清单</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<a href="javascript:openNewPage('/ciqs/mailSteamer/toDocPage?proc_main_id=${proc_main_id }&page=ms_yuxianzhunbeiqingdan');">查看</a>
				</td>
			</tr>
		</table>
		
		<input type="button"
			style="margin: 40px 40px 0px 260px; width: 80px; height: 30px;"
			value="打印" onclick="window.print()" /> <input type="button"
			style="margin: 40px 40px 0px 80px; width: 80px; height: 30px;"
			value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();" />
	</div>

	<!-- 图片 -->
	<div class="row" style="z-index: 200000;">
		<div class="col-sm-8 col-md-6" style="z-index: 200000;">
			<div class="docs-galley" style="z-index: 200000;">
				<ul class="docs-pictures clearfix" style="z-index: 200000;">
					<li><img id="imgd1" style="z-index: 200000;" src=""
						alt="Cuo Na Lake" /></li>
				</ul>
			</div>
		</div>
	</div>
	<%@ include file="/common/player.jsp"%>
</body>
	<script type="text/javascript">
		$("#imgd1").hide();
	</script>
</html>