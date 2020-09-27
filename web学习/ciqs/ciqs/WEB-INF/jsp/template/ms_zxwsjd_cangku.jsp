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
	<div class="chatTitle">仓库  Stores</div>
	<div style="font-weight:bold" align="center">名称：${hun_name }
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
			<td height="44" align="center" class="tableheadLine" rowspan="4">
				位置与布局Construction
			</td>
			<td height="44" align="center" class="tableLine" >
				远离污染源，温度适宜 分类存放，离地上架
			</td>
			<td height="44" align="center" class="tableLine" >
			
			</td>
			<td height="44" align="center" class="tableLine">
				现场看仓库位置和温度计现场看食品与非食品、未加工与已加工产品分类存放，离地上架，避免与甲板、死水和其他污染物直接接触
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result1 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result1 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec1}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_1}" var="file">
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
				分类存放，离地上架
			</td>
			<td height="44" align="center" class="tableLine" >
			
			</td>
			<td height="44" align="center" class="tableLine">
				现场看食品与非食品、未加工与已加工产品分类存放，离地上架，避免与甲板、死水和其他污染物直接接触
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result2 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result2 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec2}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_2}" var="file">
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
				仓库墙角便于清洁
			</td>
			<td height="44" align="center" class="tableLine" >
			
			</td>
			<td height="44" align="center" class="tableLine">
				现场看,可手摸一下墙角
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result3 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result3 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec3}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_3}" var="file">
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
				无裂隙或损坏
			</td>
			<td height="44" align="center" class="tableLine" >
			
			</td>
			<td height="44" align="center" class="tableLine">
				现场查看
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result4 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result4 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec4}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_4}" var="file">
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
			<td height="44" align="center" class="tableheadLine"   rowspan="3">
				食品品质、包装、储存Food sources and storage
			</td>
			<td height="44" align="center" class="tableLine" >
				食品卫生、品质良好
			</td>
			<td height="44" align="center" class="tableLine" >
			
			</td>
			<td height="44" align="center" class="tableLine">
				现场看食品有无腐败、有无包装，容器或包装上标识来源
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result5 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result5 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec5}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_5}" var="file">
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
				无过期食品
			</td>
			<td height="44" align="center" class="tableLine" >
				How often do you check the expiry date of the foods?
			</td>
			<td height="44" align="center" class="tableLine">
				抽查2到3种，检查有效期
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result6 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result6 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec6}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_6}" var="file">
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
				食品储存温度适宜
			</td>
			<td height="44" align="center" class="tableLine" >
				If you find something wrong about the temperatures of the store room,<br/>
				what should you do？ <br/>
				Is there a record？<br/>
			</td>
			<td height="44" align="center" class="tableLine">
				检查仓库温度计和仓库内储存的食品是否储存在相应的温度下。注意鱼、肉的解冻
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result7 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result7 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec7}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_7}" var="file">
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
			<td height="44" align="center" class="tableheadLine"   rowspan="4">
				清洁卫生Cleaning
			</td>
			<td height="44" align="center" class="tableLine" >
				化学品单独存放
			</td>
			<td height="44" align="center" class="tableLine" >
				Where the chemicals for cleaning the galley are kept?
			</td>
			<td height="44" align="center" class="tableLine">
				注意仓库内有无化学品或者包装；如有洗手槽，注意化学品的位置
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result8 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result8 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec8}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_8}" var="file">
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
				仓库卫生状况良好
			</td>
			<td height="44" align="center" class="tableLine" >
				Is there a cleaning plan for store?
			</td>
			<td height="44" align="center" class="tableLine">
				检查仓库清洁状况
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result9 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result9 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec9}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_9}" var="file">
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
				无死水 No standing water
			</td>
			<td height="44" align="center" class="tableLine" >
			</td>
			<td height="44" align="center" class="tableLine">
				现场看
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result10 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result10 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec10}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_10}" var="file">
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
				无媒介生物或其宿主evidence of vectors or reservoirs
			</td>
			<td height="44" align="center" class="tableLine" >
			</td>
			<td height="44" align="center" class="tableLine">
				现场看,使用手电和黑光灯
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result11 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result11 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec11}</span>
				<c:forEach items="${V_MS_SP_CK_ZJ_11}" var="file">
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