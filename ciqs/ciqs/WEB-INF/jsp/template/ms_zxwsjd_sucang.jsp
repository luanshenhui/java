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
	<div class="chatTitle">宿舱Quarters</div>
	<div style="font-weight:bold" align="center">
		<span>名称：${hun_name }</span>
		<c:forEach items="${V_MS_SP_SQ_NM_1}" var="file">
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
			<td  height="44" align="center" class="tableheadLine"  >
				检查项目
			</td>
			 <td  height="44" align="center" class="tableheadLine"  >
				检查要点
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine" >
				询问	
			</td>
			 <td  height="44" width="120" align="center" class="tableheadLine" >
				动作
			</td>
			 <td  height="44" width="120" align="center" class="tableheadLine" >
				检查结果
			</td>
			 <td  height="44" width="120" align="center" class="tableheadLine" >
				所见证据
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine"  rowspan="2" >
				通风采光Ventilation and lighting
			</td>
			<td height="44" align="center" class="tableLine" >
				采光良好
			</td>
			<td height="44" align="center" class="tableLine" >
				If possible, can you open the window to increase the ventilation?
			</td>
			<td height="44" align="center" class="tableLine">
				看有无可开关的窗户；试开窗户和电源开关
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result1 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result1 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec1}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_1}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" >
				厕所的排气口与送风系统相连接，通风良好
			</td>
			<td height="44" align="center" class="tableheadLine" >
				
			</td>
			<td height="44" align="center" class="tableLine">
				观察厕所的排气口与送风系统距离
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result2 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result2 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec2}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_2}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine"  rowspan="3" >
				清洁卫生Cleaning
			</td>
			<td height="44" align="center" class="tableLine" >
				宿舱密封性良好
			</td>
			<td height="44" align="center" class="tableLine" >
				内部交流(It's easy to clean)
			</td>
			<td height="44" align="center" class="tableLine">
				手摸墙，看表面是否光滑；开关门看密封性如何;看有无纱窗，有，注意孔径
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result3 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result3 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec3}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_3}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" >
				无灰尘、废弃物、媒介生物、孳生地和化学物质污染等
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine">
				检查卫生状况好，是否有灰尘、废弃物、媒介生物、孳生地和化学物质污染等
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result4 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result4 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec4}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_4}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine" >
				有清洁和维护计划
			</td>
			<td height="44" align="center" class="tableLine" >
				Who is responsible for cleaning and how often?
			</td>
			<td height="44" align="center" class="tableLine">
				检查卫生状况好，是否有灰尘、废弃物、媒介生物、孳生地和化学物质污染等
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result5 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result5 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec5}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_5}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine"  rowspan="5" >
				盥洗室Toilet facilities
			</td>
			<td height="44" align="center" class="tableLine" >
				有盥洗室
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result6 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result6 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec6}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_6}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine"   >
				有供热系统
			</td>
			<td height="44" align="center" class="tableLine" >
				Is hot water available?
			</td>
			<td height="44" align="center" class="tableLine" >
				打开水龙头试试
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result7 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result7 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec7}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_7}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine"   >
				配备干手装置（最好使用一次性纸巾）、卫生纸以及肥皂或液体肥皂等
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine" >
				检查盥洗设施是否配备干手装置（最好使用一次性纸巾）、卫生纸以及肥皂或液体肥皂等
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result8 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result8 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec8}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_8}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine"   >
				淋浴喷头/通风装置清洁状况良好
			</td>
			<td height="44" align="center" class="tableLine" >
				Can we unscrew the shower? 
			</td>
			<td height="44" align="center" class="tableLine" >
				测冷热水温度，如果介于25至50之间;或者放低花洒，有水流出来，采样检测军团菌；检查通风装置是否清洁干净
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result9 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result9 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec9}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_9}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine"   >
				无渗漏和堵塞
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine" >
				看屋顶有无渗漏，看排水管有无渗漏（手摸S排水管下湾部）；弄一杯水，倒在地漏上，看排水是否畅通
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result10 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result10 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec10}</span>
				<c:forEach items="${V_MS_SP_SQ_ZJ_10}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
	</table>
	<input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
    <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
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