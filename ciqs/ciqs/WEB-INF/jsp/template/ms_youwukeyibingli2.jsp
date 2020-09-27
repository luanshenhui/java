<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>有无可疑病例</title>
<%@ include file="/common/resource_show.jsp"%>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<link rel="stylesheet"
	href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
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
		//图片预览
		function showPic(path) {
			console.log(path)
			url = "/ciqs/showVideo?imgPath=" + path;
			$("#imgd1").attr("src", url);
			$("#imgd1").click();
		}
	</script>
	<div>
		<div class="chatTitle">有无可疑病例</div>
		<table width="980" border="0" align="left"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					1.传染病患者名称(1.名字；2.护照)
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<span id="V_JC_N_A_M_1"> 
						<c:forEach items="${V_JC_N_A_M_1 }" var="v">
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
					2.流行病学调查（表）结果
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<span id="V_JC_T_Y_D_3"> 
						<c:forEach items="${V_JC_T_Y_D_3 }" var="v">
						<c:if test="${v.file_type == '1' }">
							<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
						</c:if>
						<c:if test="${v.file_type != '1' }">
							<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
						</c:if>
						</c:forEach>
					</span>
					<c:if test="${not empty D_JC_T_Y_2.doc_id }">
						<span>
							<a href="/ciqs/quartn/doc?id=${D_JC_T_Y_2.doc_id }&flag=dddtl1">查看</a>
						</span>
					</c:if>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					3.医学检查结果
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<span id="V_D_OC_PAGE_2_1"> 
						<c:forEach items="${V_D_OC_PAGE_2_1 }" var="v">
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
					4.采样
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<c:if test="${not empty doc_groupid }">
						<a href="toCaiYang?proc_main_id=${proc_main_id}&doc_type=PAGE2-V_D_OC_PAGE_2_2-${doc_groupid}">查看</a>
					</c:if>
					<c:if test="${empty doc_groupid }">
						<a href="toCaiYang?proc_main_id=${proc_main_id}&doc_type=PAGE2-V_D_OC_PAGE_2_2">查看</a>
					</c:if>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					5.实验室结果
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<span>${doc.option_1 }</span>
					<span id="V_JC_Q_U_K_1"> 
						<c:forEach items="${V_JC_Q_U_K_1 }" var="v">
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
					6.结论判定
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<span>初步判定：${doc.option_2 }</span>
					</br>
					<span>确诊：${doc.option_3 }</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					7.处置
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
					<span>送医院，口岸传染病疑似病例转诊单:</span>
					<span id="V_D_OC_PAGE_2_3"> 
						<c:forEach items="${V_D_OC_PAGE_2_3 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
					</br>
					<span>其他处置方法:</span>
					<span>${doc.option_4 }</span>
					<span id="V_JC_F_U_C_1"> 
						<c:forEach items="${V_JC_F_U_C_1 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
					</br>
					<span>后续追踪：</span>
					<span>${doc.option_5 }</span>
					<span id="V_JC_S_U_B_1"> 
						<c:forEach items="${V_JC_S_U_B_1 }" var="v">
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
					8.检疫处理
				</td>
				<td height="44" align="left" class="tableLine" colspan="4">
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
								<c:when test="${mscdm2.check_deal_method == '1' }">
									消毒
								</c:when>
								<c:when test="${mscdm2.check_deal_method == '2' }">
									杀虫
								</c:when>
								<c:when test="${mscdm2.check_deal_method == '3' }">
									除鼠
								</c:when>
								<c:when test="${mscdm2.check_deal_method == '4' }">
									除污
								</c:when>
								<c:when test="${mscdm2.check_deal_method == '5' }">
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
</body>
<script type="text/javascript">
	$("#imgd1").hide();
</script>
<%@ include file="/common/player.jsp"%>
</html>