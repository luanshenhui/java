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
<div class="chatTitle">船舶卫生监督检查记录表医疗设施Medical facilities</div>
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
			<td  height="44" align="center" class="tableheadLine"  >
				检查项目
			</td>
			<td  height="44" align="center" class="tableheadLine" >
				检查要点
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine" >
				检查结果			
			</td>
			<td  height="44" width="120" align="center" class="tableheadLine" >
				所见证据
			</td>
			<td  height="44" width="120"  align="center" class="tableheadLine" >
				采样
			</td>
			<td  height="44" width="120"  align="center" class="tableheadLine"  >
				检疫处理
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" >
				清洁Cleaning
			</td>
			<td height="44" align="center" class="tableLine">
				卫生状况良好，定期清洁
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result1 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result1 == 1}"> checked="checked" </c:if>/> <br/>   
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec1}</span>
				<c:forEach items="${V_MS_YL_ZJ_1}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_1}" var="file">
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
			<td height="44" align="center" class="tableLine" rowspan="3">
				
			</td>
			<td height="44" align="center" class="tableLine" >
				医疗记录完备Medical log
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox" <c:if test="${check_result2 == 0}"> checked="checked" </c:if>/> <br/>   
				否No<input type="checkbox" <c:if test="${check_result2 == 1}"> checked="checked" </c:if>/> <br/>    
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_ZJ_2}" var="file">
				<span>${dec2}</span>
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_2}" var="file">
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
				有清洁、卫生、针头处理和废物管理程序和政策 
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result3 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result3 == 1}"> checked="checked" </c:if> /> <br/>      
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec3}</span>
				<c:forEach items="${V_MS_YL_ZJ_3}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_3}" var="file">
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
				有最新的医疗指南
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result4 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result4 == 1}"> checked="checked" </c:if> /> <br/>    
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec4}</span>
				<c:forEach items="${V_MS_YL_ZJ_4}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_4}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="2" >
				废物容器Waste container
			</td>
			<td height="44" align="center" class="tableLine">
				垃圾桶配备规范
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result5 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result5 == 1}"> checked="checked" </c:if> /> <br/>      
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec5}</span>
				<c:forEach items="${V_MS_YL_ZJ_5}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_5}" var="file">
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
		<tr>
			<td height="44" align="center" class="tableLine">
				有存放防刺穿针头的容器	
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result6 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result6 == 1}"> checked="checked" </c:if> /> <br/>      
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec6}</span>
				<c:forEach items="${V_MS_YL_ZJ_6}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_6}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result6.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result6.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result6.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result6.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" rowspan="4">
				医药箱Medical chest
			</td>
			<td height="44" align="center" class="tableLine">
				药品存放整齐，无过期药品
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result7 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result7 == 1}"> checked="checked" </c:if> /> <br/>        
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec7}</span>
				<c:forEach items="${V_MS_YL_ZJ_7}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_7}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result7.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result7.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result7.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result7.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine">
				有药品清单medicine list
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result8 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result8 == 1}"> checked="checked" </c:if> /> <br/>         
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec8}</span>
				<c:forEach items="${V_MS_YL_ZJ_8}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_8}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result8.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result8.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result8.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result8.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine">
				洗手设施状况良好
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result9 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result9 == 1}"> checked="checked" </c:if> /> <br/>          
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec9}</span>
				<c:forEach items="${V_MS_YL_ZJ_9}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_9}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result9.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result9.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result9.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result9.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableLine">
				有纸巾或干手设备、液体肥皂、污物桶、马桶刷或厕纸等
			</td>
			<td height="44" align="center" class="tableLine" >
				是Yes<input type="checkbox"  <c:if test="${check_result10 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result10 == 1}"> checked="checked" </c:if> /> <br/>            
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec10}</span>
				<c:forEach items="${V_MS_YL_ZJ_10}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_10}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result10.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result10.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result10.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result10.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td height="44" align="center" class="tableheadLine" >
				医疗废水Medical liquid waste
			</td>
			<td height="44" align="center" class="tableLine">
				液体废物和废水管道连至污水（黑水）系统
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result11 == 0}"> checked="checked" </c:if> /> <br/>   
				否No<input type="checkbox" <c:if test="${check_result11 == 1}"> checked="checked" </c:if> /> <br/>               
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec11}</span>
				<c:forEach items="${V_MS_YL_ZJ_11}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:forEach items="${V_MS_YL_CY_11}" var="file">
					<c:if test="${file.file_type eq '1' }">
						<img src="/ciqs/static/show/images/photo-btn.png" width="42" height="42" onclick="showPic('${file.file_name}')"/>
					</c:if>
					<c:if test="${file.file_type eq '2' }">
						<img src="/ciqs/static/show/images/video-btn.png" width="42" height="42" onclick="showVideo('${file.file_name}')"/>
					</c:if>
				</c:forEach>
			</td>
			<td height="44" align="center" class="tableLine">
				<c:if test="${jy_result11.IS_COMMIT == '1'}">
					<span>已完成</span>
				</c:if> 
				<c:if test="${jy_result11.IS_COMMIT == '0'}">
					<span>未完成</span>
				</c:if>
				<c:if test="${jy_result11.QUALIFIED_FLAG == '1'}">
					<span>不合格</span>
				</c:if> 
				<c:if test="${jy_result11.QUALIFIED_FLAG == '0'}">
					<span>合格</span>
				</c:if>
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
         		<li>
         			<img id="imgd1" style="z-index:200000;" <%-- data-original="${ctx}/static/viewer/assets/img/tibet-1.jpg" --%> 
         			src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
         		</li>
	       	</ul>
      	</div>
   	</div>
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