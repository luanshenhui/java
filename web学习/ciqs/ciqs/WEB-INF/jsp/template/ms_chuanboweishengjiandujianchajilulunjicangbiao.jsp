<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>船舶卫生监督检查记录表
</title>
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
body div{
   width:1000px;
   margin: 5px auto;
}
/* div{
   overflow:auto;
   font-size: 22px;
} */
.chatTitle{
    text-align: center;
    font-size: 30px;
    font-weight: 600;
}
.tableheadLine {
	border: 1px solid #000;
	font-weight:bold;
}
.tableLine{
	border: 1px solid #000;
}
.fangxingLine {
	font-size:10;
	margin-left:5px;
	margin-right:5px;
	border: 2px solid #000;
	font-weight:900;
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
<div>
<div class="chatTitle">船舶卫生监督检查记录表轮机舱Engine room</div>
<div style="font-weight:bold" align="center">名称：${hun_name}
<c:forEach items="${V_MS_SQ_NM_1}" var="file">
	<c:if test="${file.file_type eq '1' }">
		<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
	</c:if>
	<c:if test="${file.file_type eq '2' }">
		<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
	</c:if>
</c:forEach>
</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td  height="44" align="center" class="tableheadLine">
				检查项目
			</td>
			<td  height="44" align="center" class="tableheadLine">
				检查要点
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine">
				检查结果			
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine">
				所见证据
			</td>
			<td  height="44" width="120"  align="center" class="tableheadLine">
				采样
			</td>
			<td  height="44" width="120"  align="center" class="tableheadLine">
				检疫处理
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" rowspan="5">
				饮用水的消毒Disinfection of potable water
			</td>
			<td height="44" align="center" class="tableLine">
				是否有消毒设施
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result1 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result1 == 1}"> checked="checked" </c:if>/> <br/>    
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec1}</span>
				<c:forEach items="${V_MS_JC_ZJ_1}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_JC_CY_1}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result1.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result1.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result1.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result1.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine">
				饮用水定期消毒
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result2 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result2 == 1}"> checked="checked" </c:if>/> <br/>   
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec2}</span>
				<c:forEach items="${V_MS_JC_ZJ_2}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_JC_CY_2}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result2.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result2.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result2.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result2.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine">
				消毒药品有专用储存地点
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result3 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result3 == 1}"> checked="checked" </c:if>/> <br/>      
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec3}</span>
				<c:forEach items="${V_MS_JC_ZJ_3}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_JC_CY_3}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result3.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result3.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result3.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result3.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine">
				有防回流装置
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result4 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result4 == 1}"> checked="checked" </c:if>/> <br/>        
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec4}</span>
				<c:forEach items="${V_MS_JC_ZJ_4}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_JC_CY_4}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result4.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result4.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result4.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result4.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine">
				有水质检测设备
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result5 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result5 == 1}"> checked="checked" </c:if>/> <br/>           
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec5}</span>
				<c:forEach items="${V_MS_JC_ZJ_5}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_JC_CY_5}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result5.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result5.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result5.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result5.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
	</table>
	<input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
 	<input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>
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
<script type="text/javascript">
$("#imgd1").hide();
//图片预览
function showPic(path) {
	console.log('123')
	url = "/ciqs/showVideo?imgPath=" + path;
	$("#imgd1").attr("src", url);
	$("#imgd1").click();
}
</script>
</html>