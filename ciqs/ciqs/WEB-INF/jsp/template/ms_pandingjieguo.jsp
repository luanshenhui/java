<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
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
		<div class="chatTitle">判定结果</div>
		<table width="980" border="0" align="center"
			style="font-size: 14px; line-height: 30px;" cellpadding="0"
			cellspacing="0" class="tableLine">
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					中文船名
				</td>
				<td height="44" align="center" class="tableLine" colspan="4">
					${resultCheck.CN_VSL_M }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					英文船名
				</td>
				<td height="44" align="center" class="tableLine" colspan="4">
					${resultCheck.FULL_VSL_M }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					检疫查验结果
				</td>
				<td height="44" align="center" class="tableLine" colspan="4">
					${resultCheck.CHK_RESULT }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					卫生监督结果
				</td>
				<td height="44" align="center" class="tableLine" colspan="4">
					${resultCheck.HLTH_RESULT }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					样品实验室结果
				</td>
				<td height="44" align="center" class="tableLine" colspan="4">
					${resultCheck.SAMP_RESULT }
				</td>
			</tr>
			<tr>
				<td height="44" align="left" class="tableLine" colspan="4">
					检疫处理
				</td>
				<td height="44" align="center" class="tableLine" colspan="4">
					${resultCheck.CHK_DEAL }
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