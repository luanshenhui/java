<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>申报无异常事项</title>
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
	text-align: center;
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
	//图片预览
	function showPic(path) {
		console.log(path)
		url = "/ciqs/showVideo?imgPath=" + path;
		$("#imgd1").attr("src", url);
		$("#imgd1").click();
	}
	</script>
	<div>
		<div class="chatTitle">航海健康申报书</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					1.Any radioactive cargo on board?
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						1.有合法手续
						<span id="V_JC_T_Y_D_22" class="vList">
							<c:forEach items="${V_JC_T_Y_D_22 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
						</br>
						<span>现场检测</span>
						<span id="V_JC_T_Y_D_23" class="vList">
							<c:forEach items="${V_JC_T_Y_D_23 }" var="v">
								<c:if test="${v.file_type == '1' }">
									<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
								</c:if>
								<c:if test="${v.file_type != '1' }">
									<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
								</c:if>
							</c:forEach>
						</span>
						</br>
						<span>采样对象：<a href="toCaiYang?proc_main_id=${proc_main_id}&doc_type=V_JC_T_Y_D_39">查看</a></span>
						</br>
						<span>采样文字：${doc.option_1 }</span>
					</span>
					
					</br>
					<span>
						2.无合法手续
						</br>
						<span>现场检测</span>
						<span id="V_JC_T_Y_D_24" class="vList">
							<c:forEach items="${V_JC_T_Y_D_24 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
						</br>
						<span>采样对象：<a href="toCaiYang?proc_main_id=${proc_main_id}&doc_type=V_JC_T_Y_D_40">查看</a></span>
						</br>
						<span>采样文字：${doc.option_2 }</span>
						</br>
						<span>突发公共卫生事件：</span>
						<span id="V_JC_T_Y_D_10_A" class="vList">
							<c:forEach items="${V_JC_T_Y_D_10_A }" var="v">
								<span>${v.name }</span>
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					2.Food and drinking water loading ports?
				</td>
				<td height="44" align="left" class="tableLine">
					<span>采样：<a href="toCaiYang?proc_main_id=${proc_main_id}&doc_type=V_JC_T_Y_D_41">查看</a></span>
					</br>
					<span>
						<span>封存</span>
						<span id="V_JC_T_Y_D_25" class="vList">
							<c:forEach items="${V_JC_T_Y_D_25 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
					</br>
					<span>消毒：</span>
					</br>
					<span>处理对象：${mscdm1.check_deal_proj }</span>
					</br>
					<span>处理依据：${mscdm1.check_deal_couse }
					</br>
					<span>相关证单：</span>
					<span id="V_JC_T_Y_D_42" class="vList">
					<c:forEach items="${xdNotice }" var="i">
						<img style="cursor: pointer;"
							src="/ciqs/static/show/images/photo-btn.png" width="42"
							height="42" title="照片查看" onclick="showPic('${i}')" />								
					</c:forEach>
					<c:forEach items="${xdNoticeVideo }" var="i">
						<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${i}")'/>								
					</c:forEach>
					</span>
					</br>
					<span>处理方法：<c:choose>
						<c:when test="${mscdm1.check_deal_method=='1' }">
							消毒
						</c:when>
						<c:when test="${mscdm1.check_deal_method=='2' }">
							杀虫
						</c:when>
						<c:when test="${mscdm1.check_deal_method=='3' }">
							除鼠
						</c:when>
						<c:when test="${mscdm1.check_deal_method=='4' }">
							除污
						</c:when>
						<c:when test="${mscdm1.check_deal_method=='5' }">
							其他
						</c:when>
					</c:choose></span>
					</br>
					<span>处理过程：</span>
					<span id="V_JC_T_Y_D_42" class="vList">
					<c:forEach items="${xdPic }" var="i">
						<img style="cursor: pointer;"
							src="/ciqs/static/show/images/photo-btn.png" width="42"
							height="42" title="照片查看" onclick="showPic('${i}')" />								
					</c:forEach>
					<c:forEach items="${xdPicVideo }" var="i">
						<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${i}")'/>							
					</c:forEach>
					</span>
					</br>
					<span>处理公司：${mscdm1.check_deal_company }</span>
					</br>
					<span>完成状态：<c:if test="${mscdm1.is_commit=='true' }">完成</c:if><c:if test="${mscdm1.is_commit=='false' }">未完成</c:if></span>
					</br>
					<span>是否合格：<c:if test="${mscdm1.qualified_flag=='0' }">合格</c:if><c:if test="${mscdm1.qualified_flag=='1' }">不合格</c:if></span>
					</br>
					<span>
						<span>其他：${doc.option_3 }</span>
						<span id="V_JC_T_Y_D_26" class="vList">
							<c:forEach items="${V_JC_T_Y_D_26 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					3.Valid Sanitation Control Exemption/Control Certificate carried on board?
				</td>
				<td height="44" align="left" class="tableLine">
					<span>1.换证</span>
					</br>
					<span>2.延期</span>
					</br>
					<span>
						<span>3.标注检疫措施</span>
						<span id="V_JC_T_Y_D_27" class="vList">
							<c:forEach items="${V_JC_T_Y_D_27 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
					</br>
					<span>
						<span>4.考察上一港口的措施落实情况<span>${doc.option_4 }</span></span>
						<span id="V_JC_T_Y_D_28" class="vList">
							<c:forEach items="${V_JC_T_Y_D_28 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
					</br>
					<span>
						<span>5.其他<span>${doc.option_5 }</span></span>
						<span id="V_JC_T_Y_D_29" class="vList">
							<c:forEach items="${V_JC_T_Y_D_29 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					4.Has ship/vessel visited an affected area identified by the World Health Organization?List ports of call from commencenment of voyage with dates of departure, or within past four weeks,whichever is shorter:
				</td>
				<td height="44" align="left" class="tableLine">
					<span>1.卫生监督证据<span>${doc.option_6 }</span></span>
					<span id="V_JC_T_Y_D_30" class="vList">
						<c:forEach items="${V_JC_T_Y_D_30 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
					</br>
					<span>采样：<a href="toCaiYang?proc_main_id=${proc_main_id}&doc_type=V_JC_T_Y_D_43">查看</a></span>
					</br>
					<span>检疫处理：</span>
					</br>
					<span>处理对象：${mscdm2.check_deal_proj }</span>
					</br>
					<span>处理依据：${mscdm2.check_deal_couse }</span>
					</br>
					<span>相关证单：</span>
					<c:forEach items="${jyNotice }" var="i">
						<img style="cursor: pointer;"
							src="/ciqs/static/show/images/photo-btn.png" width="42"
							height="42" title="照片查看" onclick="showPic('${i}')" />								
					</c:forEach>
					<c:forEach items="${jyNoticeVideo }" var="i">
						<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${i}")'/>								
					</c:forEach>
					</br>
					<span>处理方法：
					<c:choose>
						<c:when test="${mscdm2.check_deal_method=='1' }">
							消毒
						</c:when>
						<c:when test="${mscdm2.check_deal_method=='2' }">
							杀虫
						</c:when>
						<c:when test="${mscdm2.check_deal_method=='3' }">
							除鼠
						</c:when>
						<c:when test="${mscdm2.check_deal_method=='4' }">
							除污
						</c:when>
						<c:when test="${mscdm2.check_deal_method=='5' }">
							其他
						</c:when>
					</c:choose>
					</span>
					</br>
					<span>处理过程：</span>
					<c:forEach items="${jyPic }" var="i">
						<img style="cursor: pointer;"
							src="/ciqs/static/show/images/photo-btn.png" width="42"
							height="42" title="照片查看" onclick="showPic('${i}')" />								
					</c:forEach>
					<c:forEach items="${jyPicVideo }" var="i">
						<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${i}")'/>							
					</c:forEach>
					</br>
					<span>处理公司：${mscdm2.check_deal_company }</span>
					</br>
					<span>完成状态：<c:if test="${mscdm2.is_commit=='true' }">完成</c:if><c:if test="${mscdm2.is_commit=='false' }">未完成</c:if></span>
					</br>
					<span>是否合格：<c:if test="${mscdm2.qualified_flag=='0' }">合格</c:if><c:if test="${mscdm2.qualified_flag=='1' }">不合格</c:if></span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					(1).Has any person died on board otherwise than as a result of accidents?If yes,state particulars in attahed schedule. Total No. of Deaths ____________
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_7 == '0'}">YES</c:if>
						<c:if test="${doc.option_7 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						<a href="toDocPage?proc_main_id=${proc_main_id }&page=ms_youwukeyibingli&doc_groupid=C">可疑病例排查模块</a>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					(2).Is there on board or has there been during the international voyage any case of disease
					       which you suspect to be of an infectious nature?
					       If yes, state particulars in attached schedule.
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_8 == '0'}">YES</c:if>
						<c:if test="${doc.option_8 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						<a href="toDocPage?proc_main_id=${proc_main_id }&page=ms_youwukeyibingli&doc_groupid=D">可疑病例排查模块</a>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					(3).Has the total number of ill passengers during the voyage been greater than nomal expected?
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_9 == '0'}">YES</c:if>
						<c:if test="${doc.option_9 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						<a href="toDocPage?proc_main_id=${proc_main_id }&page=ms_youwukeyibingli&doc_groupid=E">可疑病例排查模块</a>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					(4).Is there any ill person on board now?If yes, state particulars in attached schedule.
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_10 == '0'}">YES</c:if>
						<c:if test="${doc.option_10 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						<a href="toDocPage?proc_main_id=${proc_main_id }&page=ms_youwukeyibingli&doc_groupid=F">可疑病例排查模块</a>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					(5).Was a medical practitioner consulted?If yes, state particulars of medical treatment or advice provided in attached schedule.
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_11 == '0'}">YES</c:if>
						<c:if test="${doc.option_11 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						${doc.option_12 }
					</span>
					<span id="V_JC_T_Y_D_31" class="vList">
						<c:forEach items="${V_JC_T_Y_D_31 }" var="v">
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
				<td height="44" align="left" class="tableLine">
					(6).Are you aware of any condition on board which may lead to infection or spread of disease? If yes, state particulars in attached schedule.
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_13 == '0'}">YES</c:if>
						<c:if test="${doc.option_13 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						${doc.option_14 }
					</span>
					<span id="V_JC_T_Y_D_32" class="vList">
						<c:forEach items="${V_JC_T_Y_D_32 }" var="v">
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
				<td height="44" align="left" class="tableLine">
					(7).Has any sanitary measure(e.g. quarantine,isolation,disinfection or decontamination) been applied on board? If yes, specify type,place 
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_15 == '0'}">YES</c:if>
						<c:if test="${doc.option_15 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						${doc.option_16 }
					</span>
					<span id="V_JC_T_Y_D_33" class="vList">
						<c:forEach items="${V_JC_T_Y_D_33 }" var="v">
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
				<td height="44" align="left" class="tableLine">
					(8).Has any stowaways been found on board? If yes, where did they join the ship(if known)? 
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_17 == '0'}">YES</c:if>
						<c:if test="${doc.option_17 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						${doc.option_18 }
					</span>
					<span id="V_JC_T_Y_D_34" class="vList">
						<c:forEach items="${V_JC_T_Y_D_34 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
					</br>
					<span>
						<a href="toDocPage?proc_main_id=${proc_main_id }&page=ms_youwukeyibingli&doc_groupid=G">可疑病例排查模块</a>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					(9).Is there a sick animal or pet on board? 
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_19 == '0'}">YES</c:if>
						<c:if test="${doc.option_19 == '1'}">NO</c:if>
					</span>
					</br>
					<span>1.动物、检疫证和接种证</span>
					<span id="V_JC_T_Y_D_35" class="vList">
						<c:forEach items="${V_JC_T_Y_D_35 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
					</br>
					<span>进一步处置<span>${doc.option_20 }</span></span>
					<span id="V_JC_T_Y_D_36" class="vList">
						<c:forEach items="${V_JC_T_Y_D_36 }" var="v">
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
				<td height="44" align="left" class="tableLine">
					(10).Have the crew and passengers had any the certificate of vaccination? If have,how many? 
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_21 == '0'}">YES</c:if>
						<c:if test="${doc.option_21 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						<span>处置办法：<span>${doc.option_22 }</span></span>
						<span id="V_JC_T_Y_D_37" class="vList">
							<c:forEach items="${V_JC_T_Y_D_37 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
				</td>
			</tr>
			
			<tr>
				<td height="44" align="left" class="tableLine">
					(11).Have the crew and passengers had any the certificate of health examination for international traveler ?If have,how many? 
				</td>
				<td height="44" align="left" class="tableLine">
					<span>
						<c:if test="${doc.option_23 == '0'}">YES</c:if>
						<c:if test="${doc.option_23 == '1'}">NO</c:if>
					</span>
					</br>
					<span>
						<span>处置办法：<span>${doc.option_24 }</span></span>
						<span id="V_JC_T_Y_D_38" class="vList">
							<c:forEach items="${V_JC_T_Y_D_38 }" var="v">
								<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
							</c:forEach>
						</span>
					</span>
				</td>
			</tr>
			
		</table>
		<input type="button"
			style="margin: 40px 40px 0px 260px; width: 80px; height: 30px;"
			value="打印" onclick="window.print()" /> <input type="button"
			style="margin: 40px 40px 0px 80px; width: 80px; height: 30px;"
			value="返回" onclick=" window.history.back(-1)" />
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
</body>
	<script type="text/javascript">
		$("#imgd1").hide();
	</script>
	<%@ include file="/common/player.jsp"%>
</html>