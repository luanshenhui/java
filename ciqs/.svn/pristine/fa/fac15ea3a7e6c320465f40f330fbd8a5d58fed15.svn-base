<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>要求船方预先准备清单</title>
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
		<div class="chatTitle">要求船方预先准备清单</div>
		<h3>Documents required further</h3>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					International Sewage Pollution Prevention Certificate
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_1=='0' }">有</c:if>
						<c:if test="${doc.option_1=='1' }">无</c:if>
					</span>
					<span>${doc.option_2 }</span>
					<span id="V_JC_T_Y_D_48" class="vList">
						<c:forEach items="${V_JC_T_Y_D_48 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" width="660" colspan="4">
					Garbage management Plan
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_3=='0' }">有</c:if>
						<c:if test="${doc.option_3=='1' }">无</c:if>
					</span>
					<span>${doc.option_4 }</span>
					<span id="V_JC_T_Y_D_49" class="vList">
						<c:forEach items="${V_JC_T_Y_D_49 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Garbage record book
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_5=='0' }">有</c:if>
						<c:if test="${doc.option_5=='1' }">无</c:if>
					</span>
					<span>${doc.option_6 }</span>
					<span id="V_JC_T_Y_D_50" class="vList">
						<c:forEach items="${V_JC_T_Y_D_50 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Water safety plan (or water management plan)
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_7=='0' }">有</c:if>
						<c:if test="${doc.option_7=='1' }">无</c:if>
					</span>
					<span>${doc.option_8 }</span>
					<span id="V_JC_T_Y_D_51" class="vList">
						<c:forEach items="${V_JC_T_Y_D_51 }" var="v">
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
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Potable water analysis report
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_9=='0' }">有</c:if>
						<c:if test="${doc.option_9=='1' }">无</c:if>
					</span>
					<span>${doc.option_10 }</span>
					<span id="V_JC_T_Y_D_52" class="vList">
						<c:forEach items="${V_JC_T_Y_D_52 }" var="v">
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
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Waste management plan
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_11=='0' }">有</c:if>
						<c:if test="${doc.option_11=='1' }">无</c:if>
					</span>
					<span>${doc.option_12 }</span>
					<span id="V_JC_T_Y_D_53" class="vList">
						<c:forEach items="${V_JC_T_Y_D_53 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Management plan for food safety (including food temperature record)
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_13=='0' }">有</c:if>
						<c:if test="${doc.option_13=='1' }">无</c:if>
					</span>
					<span>${doc.option_14 }</span>
					<span id="V_JC_T_Y_D_54" class="vList">
						<c:forEach items="${V_JC_T_Y_D_54 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Management plan for vector control
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_15=='0' }">有</c:if>
						<c:if test="${doc.option_15=='1' }">无</c:if>
					</span>
					<span>${doc.option_16 }</span>
					<span id="V_JC_T_Y_D_55" class="vList">
						<c:forEach items="${V_JC_T_Y_D_55 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Medical log
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_17=='0' }">有</c:if>
						<c:if test="${doc.option_17=='1' }">无</c:if>
					</span>
					<span>${doc.option_18 }</span>
					<span id="V_JC_T_Y_D_56" class="vList">
						<c:forEach items="${V_JC_T_Y_D_56 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					IMO ballast water reporting form
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_19=='0' }">有</c:if>
						<c:if test="${doc.option_19=='1' }">无</c:if>
					</span>
					<span>${doc.option_20 }</span>
					<span id="V_JC_T_Y_D_57" class="vList">
						<c:forEach items="${V_JC_T_Y_D_57 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Ballast-water record book
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_21=='0' }">有</c:if>
						<c:if test="${doc.option_21=='1' }">无</c:if>
					</span>
					<span>${doc.option_22 }</span>
					<span id="V_JC_T_Y_D_58" class="vList">
						<c:forEach items="${V_JC_T_Y_D_58 }" var="v">
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
		<h3>whole areas</h3>
		<div>Area 1 Quarters</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Construction drawings of sanitary facilities and ventilation.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_23=='0' }">有</c:if>
						<c:if test="${doc.option_23=='1' }">无</c:if>
					</span>
					<span>${doc.option_24 }</span>
					<span id="V_JC_T_Y_D_59" class="vList">
						<c:forEach items="${V_JC_T_Y_D_59 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Cleaning procedures and logs.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_25=='0' }">有</c:if>
						<c:if test="${doc.option_25=='1' }">无</c:if>
					</span>
					<span>${doc.option_26 }</span>
					<span id="V_JC_T_Y_D_60" class="vList">
						<c:forEach items="${V_JC_T_Y_D_60 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Construction plans demonstrating how cross-contamination is avoided in specified clean and dirty areas.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_27=='0' }">有</c:if>
						<c:if test="${doc.option_27=='1' }">无</c:if>
					</span>
					<span>${doc.option_28 }</span>
					<span id="V_JC_T_Y_D_61" class="vList">
						<c:forEach items="${V_JC_T_Y_D_61 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Smoke tests at exhaust and at air intakes close to exhaust.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_29=='0' }">有</c:if>
						<c:if test="${doc.option_29=='1' }">无</c:if>
					</span>
					<span>${doc.option_30 }</span>
					<span id="V_JC_T_Y_D_62" class="vList">
						<c:forEach items="${V_JC_T_Y_D_62 }" var="v">
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
		<div>Area 2 Galley, pantry and service areas</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Cleaning schedule and logs.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_31=='0' }">有</c:if>
						<c:if test="${doc.option_31=='1' }">无</c:if>
					</span>
					<span>${doc.option_32 }</span>
					<span id="V_JC_T_Y_D_63" class="vList">
						<c:forEach items="${V_JC_T_Y_D_63 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Purchase records and shipboard documentation of food sources (wrapping or other
						identification on the packaging, or a written product identification sheet).
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_33=='0' }">有</c:if>
						<c:if test="${doc.option_33=='1' }">无</c:if>
					</span>
					<span>${doc.option_34 }</span>
					<span id="V_JC_T_Y_D_64" class="vList">
						<c:forEach items="${V_JC_T_Y_D_64 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Food storage in–out record.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_35=='0' }">有</c:if>
						<c:if test="${doc.option_35=='1' }">无</c:if>
					</span>
					<span>${doc.option_36 }</span>
					<span id="V_JC_T_Y_D_65" class="vList">
						<c:forEach items="${V_JC_T_Y_D_65 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Drainage construction drawings.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_37=='0' }">有</c:if>
						<c:if test="${doc.option_37=='1' }">无</c:if>
					</span>
					<span>${doc.option_38 }</span>
					<span id="V_JC_T_Y_D_66" class="vList">
						<c:forEach items="${V_JC_T_Y_D_66 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Previous inspection reports.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_39=='0' }">有</c:if>
						<c:if test="${doc.option_39=='1' }">无</c:if>
					</span>
					<span>${doc.option_40 }</span>
					<span id="V_JC_T_Y_D_67" class="vList">
						<c:forEach items="${V_JC_T_Y_D_67 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Pest logbook with information on sightings.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_41=='0' }">有</c:if>
						<c:if test="${doc.option_41=='1' }">无</c:if>
					</span>
					<span>${doc.option_42 }</span>
					<span id="V_JC_T_Y_D_68" class="vList">
						<c:forEach items="${V_JC_T_Y_D_68 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Temperature records for food storage, cooling logs and thermometer readings.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_43=='0' }">有</c:if>
						<c:if test="${doc.option_43=='1' }">无</c:if>
					</span>
					<span>${doc.option_44 }</span>
					<span id="V_JC_T_Y_D_69" class="vList">
						<c:forEach items="${V_JC_T_Y_D_69 }" var="v">
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
		<div>Area 3 stores</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Cleaning and maintenance schedule and logs
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_45=='0' }">有</c:if>
						<c:if test="${doc.option_45=='1' }">无</c:if>
					</span>
					<span>${doc.option_46 }</span>
					<span id="V_JC_T_Y_D_70" class="vList">
						<c:forEach items="${V_JC_T_Y_D_70 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Purchase records and shipboard documentation of food source (e.g. wrapping or other identification on packaging, or written product identification sheets).
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_47=='0' }">有</c:if>
						<c:if test="${doc.option_47=='1' }">无</c:if>
					</span>
					<span>${doc.option_48 }</span>
					<span id="V_JC_T_Y_D_71" class="vList">
						<c:forEach items="${V_JC_T_Y_D_71 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 Food storage in–out records.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_49=='0' }">有</c:if>
						<c:if test="${doc.option_49=='1' }">无</c:if>
					</span>
					<span>${doc.option_50 }</span>
					<span id="V_JC_T_Y_D_72" class="vList">
						<c:forEach items="${V_JC_T_Y_D_72 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Construction drawings
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_51=='0' }">有</c:if>
						<c:if test="${doc.option_51=='1' }">无</c:if>
					</span>
					<span>${doc.option_52 }</span>
					<span id="V_JC_T_Y_D_73" class="vList">
						<c:forEach items="${V_JC_T_Y_D_73 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Previous inspection reports.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_53=='0' }">有</c:if>
						<c:if test="${doc.option_53=='1' }">无</c:if>
					</span>
					<span>${doc.option_54 }</span>
					<span id="V_JC_T_Y_D_74" class="vList">
						<c:forEach items="${V_JC_T_Y_D_74 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Pest logbook with information on sightings.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_55=='0' }">有</c:if>
						<c:if test="${doc.option_55=='1' }">无</c:if>
					</span>
					<span>${doc.option_56 }</span>
					<span id="V_JC_T_Y_D_75" class="vList">
						<c:forEach items="${V_JC_T_Y_D_75 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Records of food storage temperatures, cooling logs and thermometer readings
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_57=='0' }">有</c:if>
						<c:if test="${doc.option_57=='1' }">无</c:if>
					</span>
					<span>${doc.option_58 }</span>
					<span id="V_JC_T_Y_D_76" class="vList">
						<c:forEach items="${V_JC_T_Y_D_76 }" var="v">
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
		<div>Area 4 Child-care facilities</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					written procedures and policies on cleaning, maintenance and waste management;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_59=='0' }">有</c:if>
						<c:if test="${doc.option_59=='1' }">无</c:if>
					</span>
					<span>${doc.option_60 }</span>
					<span id="V_JC_T_Y_D_77" class="vList">
						<c:forEach items="${V_JC_T_Y_D_77 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					written guidance on control measures if symptoms of infection occur in children; guidelines
					will include handling of body fluids, record keeping, notification of disease, communication,
					outbreak management and exclusion policies in case of illness;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_61=='0' }">有</c:if>
						<c:if test="${doc.option_61=='1' }">无</c:if>
					</span>
					<span>${doc.option_62 }</span>
					<span id="V_JC_T_Y_D_78" class="vList">
						<c:forEach items="${V_JC_T_Y_D_78 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					vaccination list of child-care staff.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_63=='0' }">有</c:if>
						<c:if test="${doc.option_63=='1' }">无</c:if>
					</span>
					<span>${doc.option_64 }</span>
					<span id="V_JC_T_Y_D_79" class="vList">
						<c:forEach items="${V_JC_T_Y_D_79 }" var="v">
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
		<div>Area 5 Medical facilities</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					up-to-date ship’s log and/or medical logbook, including treatment list;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_65=='0' }">有</c:if>
						<c:if test="${doc.option_65=='1' }">无</c:if>
					</span>
					<span>${doc.option_66 }</span>
					<span id="V_JC_T_Y_D_80" class="vList">
						<c:forEach items="${V_JC_T_Y_D_80 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					crew member interviews if the medical log is not available during inspection or entries are inadequate; if written information is required, request Maritime Declaration of Health from the State Party;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_67=='0' }">有</c:if>
						<c:if test="${doc.option_67=='1' }">无</c:if>
					</span>
					<span>${doc.option_68 }</span>
					<span id="V_JC_T_Y_D_81" class="vList">
						<c:forEach items="${V_JC_T_Y_D_81 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					training and certification of staff assigned to medical care;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_69=='0' }">有</c:if>
						<c:if test="${doc.option_69=='1' }">无</c:if>
					</span>
					<span>${doc.option_70 }</span>
					<span id="V_JC_T_Y_D_82" class="vList">
						<c:forEach items="${V_JC_T_Y_D_82 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					lists of medicines, vaccines, disinfectants and insecticides;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_71=='0' }">有</c:if>
						<c:if test="${doc.option_71=='1' }">无</c:if>
					</span>
					<span>${doc.option_72 }</span>
					<span id="V_JC_T_Y_D_83" class="vList">
						<c:forEach items="${V_JC_T_Y_D_83 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					number of passengers, mix of patients (passenger  ships only), medical equipment in place and procedures performed, depending on ship’s voyage pattern and size;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_73=='0' }">有</c:if>
						<c:if test="${doc.option_73=='1' }">无</c:if>
					</span>
					<span>${doc.option_74 }</span>
					<span id="V_JC_T_Y_D_84" class="vList">
						<c:forEach items="${V_JC_T_Y_D_84 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					cleaning, sanitation, maintenance and waste policies and procedures;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_75=='0' }">有</c:if>
						<c:if test="${doc.option_75=='1' }">无</c:if>
					</span>
					<span>${doc.option_76 }</span>
					<span id="V_JC_T_Y_D_85" class="vList">
						<c:forEach items="${V_JC_T_Y_D_85 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					specific disease surveillance logs (e.g. gastrointestinal disease), where applicable;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_77=='0' }">有</c:if>
						<c:if test="${doc.option_77=='1' }">无</c:if>
					</span>
					<span>${doc.option_78 }</span>
					<span id="V_JC_T_Y_D_86" class="vList">
						<c:forEach items="${V_JC_T_Y_D_86 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					operational manuals for high-risk facilities and devices such as an intensive-care unit, blood transfusion facility, operating theatre or haemodialysis facility;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_79=='0' }">有</c:if>
						<c:if test="${doc.option_79=='1' }">无</c:if>
					</span>
					<span>${doc.option_80 }</span>
					<span id="V_JC_T_Y_D_87" class="vList">
						<c:forEach items="${V_JC_T_Y_D_87 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					specimens collected and results if disease occurs on board; if possible, international certificates of vaccination or prophylaxis.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_81=='0' }">有</c:if>
						<c:if test="${doc.option_81=='1' }">无</c:if>
					</span>
					<span>${doc.option_82 }</span>
					<span id="V_JC_T_Y_D_88" class="vList">
						<c:forEach items="${V_JC_T_Y_D_88 }" var="v">
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
		<div>Area 6 swimming pools and spas</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine" >
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					schematic plan for recreational water facilities, plant and systems;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_83=='0' }">有</c:if>
						<c:if test="${doc.option_83=='1' }">无</c:if>
					</span>
					<span>${doc.option_84 }</span>
					<span id="V_JC_T_Y_D_89" class="vList">
						<c:forEach items="${V_JC_T_Y_D_89 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					written scheme for controlling the risk from exposure to disease-causing microorganisms;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_85=='0' }">有</c:if>
						<c:if test="${doc.option_85=='1' }">无</c:if>
					</span>
					<span>${doc.option_86 }</span>
					<span id="V_JC_T_Y_D_90" class="vList">
						<c:forEach items="${V_JC_T_Y_D_90 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					pool installation, design and construction, maintenance and operation specif_ications;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_87=='0' }">有</c:if>
						<c:if test="${doc.option_87=='1' }">无</c:if>
					</span>
					<span>${doc.option_88 }</span>
					<span id="V_JC_T_Y_D_91" class="vList">
						<c:forEach items="${V_JC_T_Y_D_91 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 training records for crew responsible for control methods;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_89=='0' }">有</c:if>
						<c:if test="${doc.option_89=='1' }">无</c:if>
					</span>
					<span>${doc.option_90 }</span>
					<span id="V_JC_T_Y_D_92" class="vList">
						<c:forEach items="${V_JC_T_Y_D_92 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					monitoring records;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_91=='0' }">有</c:if>
						<c:if test="${doc.option_91=='1' }">无</c:if>
					</span>
					<span>${doc.option_92 }</span>
					<span id="V_JC_T_Y_D_93" class="vList">
						<c:forEach items="${V_JC_T_Y_D_93 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					test results (e.g. pH, residual chlorine and bromine levels, temperature, microbiological
						levels);
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_93=='0' }">有</c:if>
						<c:if test="${doc.option_93=='1' }">无</c:if>
					</span>
					<span>${doc.option_94 }</span>
					<span id="V_JC_T_Y_D_94" class="vList">
						<c:forEach items="${V_JC_T_Y_D_94 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 regular cleaning procedures;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_95=='0' }">有</c:if>
						<c:if test="${doc.option_95=='1' }">无</c:if>
					</span>
					<span>${doc.option_96 }</span>
					<span id="V_JC_T_Y_D_95" class="vList">
						<c:forEach items="${V_JC_T_Y_D_95 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					emergency cleaning and disinfection procedures.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_97=='0' }">有</c:if>
						<c:if test="${doc.option_97=='1' }">无</c:if>
					</span>
					<span>${doc.option_98 }</span>
					<span id="V_JC_T_Y_D_96" class="vList">
						<c:forEach items="${V_JC_T_Y_D_96 }" var="v">
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
		<div>Area 7 solid and medical waste</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine" >
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					a garbage management plan for every ship of 400 tons gross tonnage and above, and every
					ship certified to carry 15 persons or more; this document should contain all information requested
					in the Marine Environment Protection Committee Guidelines for the development of
					garbage management plans;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_99=='0' }">有</c:if>
						<c:if test="${doc.option_99=='1' }">无</c:if>
					</span>
					<span>${doc.option_100 }</span>
					<span id="V_JC_T_Y_D_97" class="vList">
						<c:forEach items="${V_JC_T_Y_D_97 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					a garbage record book for every ship of 400 tons gross tonnage and above, and every ship
					certified to carry 15 persons or more; this document should contain information on amounts
					of different waste types produced on board, plus information including discharge and incineration
					processes;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_101=='0' }">有</c:if>
						<c:if test="${doc.option_101=='1' }">无</c:if>
					</span>
					<span>${doc.option_102 }</span>
					<span id="V_JC_T_Y_D_98" class="vList">
						<c:forEach items="${V_JC_T_Y_D_98 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					International safety management manual;
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_103=='0' }">有</c:if>
						<c:if test="${doc.option_103=='1' }">无</c:if>
					</span>
					<span>${doc.option_104}</span>
					<span id="V_JC_T_Y_D_99" class="vList">
						<c:forEach items="${V_JC_T_Y_D_99 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					maintenance instructions for waste processing units (e.g. incinerator);
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_105=='0' }">有</c:if>
						<c:if test="${doc.option_105=='1' }">无</c:if>
					</span>
					<span>${doc.option_106}</span>
					<span id="V_JC_T_Y_D_100" class="vList">
						<c:forEach items="${V_JC_T_Y_D_100 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 construction plans of sewage system to check drains in waste areas.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_107=='0' }">有</c:if>
						<c:if test="${doc.option_107=='1' }">无</c:if>
					</span>
					<span>${doc.option_108 }</span>
					<span id="V_JC_T_Y_D_101" class="vList">
						<c:forEach items="${V_JC_T_Y_D_101 }" var="v">
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
		<div>Area 8 engine room</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine" >
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					None applicable.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_109=='0' }">有</c:if>
						<c:if test="${doc.option_109=='1' }">无</c:if>
					</span>
					<span>${doc.option_110 }</span>
					<span id="V_JC_T_Y_D_102" class="vList">
						<c:forEach items="${V_JC_T_Y_D_102 }" var="v">
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
		<div>Area 9 Potable water</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Constructional drawings of potable water system.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_111=='0' }">有</c:if>
						<c:if test="${doc.option_111=='1' }">无</c:if>
					</span>
					<span>${doc.option_112 }</span>
					<span id="V_JC_T_Y_D_103" class="vList">
						<c:forEach items="${V_JC_T_Y_D_103 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 Drinking-water analysis reports.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_113=='0' }">有</c:if>
						<c:if test="${doc.option_113=='1' }">无</c:if>
					</span>
					<span>${doc.option_114 }</span>
					<span id="V_JC_T_Y_D_104" class="vList">
						<c:forEach items="${V_JC_T_Y_D_104 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Medical logbook or gastrointestinal record book (or both).
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_115=='0' }">有</c:if>
						<c:if test="${doc.option_115=='1' }">无</c:if>
					</span>
					<span>${doc.option_116 }</span>
					<span id="V_JC_T_Y_D_105" class="vList">
						<c:forEach items="${V_JC_T_Y_D_105 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 Water safety plan.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_117=='0' }">有</c:if>
						<c:if test="${doc.option_117=='1' }">无</c:if>
					</span>
					<span>${doc.option_118 }</span>
					<span id="V_JC_T_Y_D_106" class="vList">
						<c:forEach items="${V_JC_T_Y_D_106 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Maintenance instructions of treatment devices.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_119=='0' }">有</c:if>
						<c:if test="${doc.option_119=='1' }">无</c:if>
					</span>
					<span>${doc.option_120 }</span>
					<span id="V_JC_T_Y_D_107" class="vList">
						<c:forEach items="${V_JC_T_Y_D_107 }" var="v">
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
		<div>Area 10 sewage</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Technical drawings of sewage system.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_121=='0' }">有</c:if>
						<c:if test="${doc.option_121=='1' }">无</c:if>
					</span>
					<span>${doc.option_122 }</span>
					<span id="V_JC_T_Y_D_108" class="vList">
						<c:forEach items="${V_JC_T_Y_D_108 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 IMO International Sewage Pollution Prevention (ISPP) certificate.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_123=='0' }">有</c:if>
						<c:if test="${doc.option_123=='1' }">无</c:if>
					</span>
					<span>${doc.option_124 }</span>
					<span id="V_JC_T_Y_D_109" class="vList">
						<c:forEach items="${V_JC_T_Y_D_109 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					International Safety Management (ISM) manual.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_125=='0' }">有</c:if>
						<c:if test="${doc.option_125=='1' }">无</c:if>
					</span>
					<span>${doc.option_126 }</span>
					<span id="V_JC_T_Y_D_110" class="vList">
						<c:forEach items="${V_JC_T_Y_D_110}" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Sewage management plan (if available).
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_127=='0' }">有</c:if>
						<c:if test="${doc.option_127=='1' }">无</c:if>
					</span>
					<span>${doc.option_128 }</span>
					<span id="V_JC_T_Y_D_111" class="vList">
						<c:forEach items="${V_JC_T_Y_D_111 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Maintenance instructions of sewage treatment plant (if installed).
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_129=='0' }">有</c:if>
						<c:if test="${doc.option_129=='1' }">无</c:if>
					</span>
					<span>${doc.option_130 }</span>
					<span id="V_JC_T_Y_D_112" class="vList">
						<c:forEach items="${V_JC_T_Y_D_112 }" var="v">
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
		<div>Area 11 Ballast water</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Constructional drawings of ballast-water reporting system.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_131=='0' }">有</c:if>
						<c:if test="${doc.option_131=='1' }">无</c:if>
					</span>
					<span>${doc.option_132 }</span>
					<span id="V_JC_T_Y_D_113" class="vList">
						<c:forEach items="${V_JC_T_Y_D_113 }" var="v">
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
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 IMO’s ballast water reporting form.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_133=='0' }">有</c:if>
						<c:if test="${doc.option_133=='1' }">无</c:if>
					</span>
					<span>${doc.option_134 }</span>
					<span id="V_JC_T_Y_D_114" class="vList">
						<c:forEach items="${V_JC_T_Y_D_114 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					 International safety management manual.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_135=='0' }">有</c:if>
						<c:if test="${doc.option_135=='1' }">无</c:if>
					</span>
					<span>${doc.option_136 }</span>
					<span id="V_JC_T_Y_D_115" class="vList">
						<c:forEach items="${V_JC_T_Y_D_115 }" var="v">
							<c:if test="${v.file_type == '1' }">
								<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic("${v.file_name}")'/>									
							</c:if>
							<c:if test="${v.file_type != '1' }">
								<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo("${v.file_name}")'/>									 
							</c:if>
						</c:forEach>
					</span>
				</td>
			</tr><tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Maintenance instructions for ballast-water treatment plant.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_137=='0' }">有</c:if>
						<c:if test="${doc.option_137=='1' }">无</c:if>
					</span>
					<span>${doc.option_138 }</span>
					<span id="V_JC_T_Y_D_116" class="vList">
						<c:forEach items="${V_JC_T_Y_D_116 }" var="v">
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
		<div>Area 13 other systems and areas</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					Integrated vector management plan.
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${doc.option_139=='0' }">有</c:if>
						<c:if test="${doc.option_139=='1' }">无</c:if>
					</span>
					<span>${doc.option_140 }</span>
					<span id="V_JC_T_Y_D_117" class="vList">
						<c:forEach items="${V_JC_T_Y_D_117 }" var="v">
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
		<div>手动新增</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<c:forEach items="${cfResult }" var="res">
				<tr>
				<td height="44" align="left" class="tableLine" width="660" colspan="4">
					${res.name }
				</td>
				<td height="44" align="center" class="tableLine baba">
					<span>
						<c:if test="${res.status=='0' }">有</c:if>
						<c:if test="${res.status=='1' }">无</c:if>
					</span>
					<span>${res.code }</span>
					<span class="vList">
						<c:forEach items="${V_JC_T_Y_D_118 }" var="v">
							<c:if test="${v.name==res.name }">
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
			</c:forEach>
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
		
		$(".baba").each(function(){
			var tr = $(this).parent();
			var span = $(this).find("span").eq(0);
			console.log(span.text().trim())
			if(span.text().trim() == ''){
				tr.remove()
			}
			if(document.referrer.indexOf("showtoprocessInfo_jsp")!=-1){
				$(this).remove()
			}
		});
		
	</script>
	<%@ include file="/common/player.jsp"%>
</html>