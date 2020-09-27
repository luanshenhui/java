<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
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
		function toImgDetail(path) {
			console.log(path)
			url = "/ciqs/showVideo?imgPath=" + path;
			$("#imgd1").attr("src", url);
			$("#imgd1").click();
		}
	</script>
	<div>
		<div class="chatTitle">采样</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					采样对象：${sampDtos.samp_proj }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					采样通知书/采样凭证：
					<span id="V_JC_T_Y_D_39" class="vList">
					<c:forEach items="${sampNoticeList }" var="i">
							<img style="cursor: pointer;"
								src="/ciqs/static/show/images/photo-btn.png" width="42"
								height="42" title="照片查看" onclick="toImgDetail('${i}')" />
					</c:forEach>
					<span id="V_JC_T_Y_D_39" class="vList">
					<c:forEach items="${sampNoticeVideoList }" var="i">
							<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${i}')" />
					</c:forEach>
					</span>
					</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					采样过程：
					<span id="V_JC_T_Y_D_39" class="vList">
					<c:forEach items="${sampFileList }" var="i">
							<img style="cursor: pointer;"
								src="/ciqs/static/show/images/photo-btn.png" width="42"
								height="42" title="照片查看" onclick="toImgDetail('${i}')" />
					</c:forEach>
					</span>
					<span id="V_JC_T_Y_D_39" class="vList">
					<c:forEach items="${sampVideoList }" var="i">
							<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${i}')" />
					</c:forEach>
					</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					送检时间：<fmt:formatDate value="${sampDtos.samp_date}" pattern="yyyy/MM/dd  HH:mm:ss" />
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					送检单位：${sampDtos.send_samp_comp }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					结果报告：${sampDtos.result_cmd }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					结果报告单：
					<span id="V_JC_T_Y_D_39" class="vList">
					<c:forEach items="${resultPaperList }" var="i">
							<img style="cursor: pointer;"
								src="/ciqs/static/show/images/photo-btn.png" width="42"
								height="42" title="照片查看" onclick="toImgDetail('${i}')" />
					</c:forEach>
					</span>
					<span id="V_JC_T_Y_D_39" class="vList">
					<c:forEach items="${resultPaperVideoList }" var="i">
							<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${i}')" />
					</c:forEach>
					</span>
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" width="600">
					完成状态： <c:if test="${sampDtos.samp_stat=='1' }">完成</c:if><c:if test="${sampDtos.samp_stat=='0' }">未完成</c:if>
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