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
	<div class="chatTitle">医疗设施Medical facilities</div>
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
			<td height="44" align="center" class="tableheadLine" >
				通风照明Ventilation and lighting
			</td>
			<td height="44" align="center" class="tableLine" >
				通风照明情况良好
			</td>
			<td height="44" align="center" class="tableLine" >
				Is the air-condition system internal recycle?
			</td>
			<td height="44" align="center" class="tableLine">
				动作：按开关、拉窗帘
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result1 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result1 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec1}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_1}" var="file">
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
			<td height="44" align="center" class="tableheadLine" >
				清洁Cleaning
			</td>
			<td height="44" align="center" class="tableLine" >
				卫生状况良好，定期清洁
			</td>
			<td height="44" align="center" class="tableLine" >
				Who is in charge of the cleaning of the hospital? How often?
			</td>
			<td height="44" align="center" class="tableLine">
				进门手摸桌面、床沿；观察墙角有无媒介
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result2 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result2 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec2}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_2}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="5">
				医务室的管理Management
			</td>
			<td height="44" align="center" class="tableLine" >
				钥匙专人保管
			</td>
			<td height="44" align="center" class="tableLine" >
				Second officer，who has the key to the door?
			</td>
			<td height="44" align="center" class="tableLine">
				看有没有和医疗无关的东西
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result3 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result3 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec3}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_3}" var="file">
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
				医疗记录完备Medical log
			</td>
			<td height="44" align="center" class="tableLine" >
				Dose medical logs indicate that crew affected by communicable <br/>
				diseases returned to work in the galley before being 
				symptom free for a minimum of 48 hours
			</td>
			<td height="44" align="center" class="tableLine">
				医学日志排除存在水源性疾病（例如腹泻）的可能；船员、旅客健康状况良好，无传染病染疫人或染疫嫌疑人，无食物中毒事故
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result4 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result4 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec4}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_4}" var="file">
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
				有清洁、卫生、针头处理和废物管理程序和政策 
			</td>
			<td height="44" align="center" class="tableLine" >
				Are there procedures and policies on cleaning, <br/>
				sanitation, sharps disposal or waste management? <br/>
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result5 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result5 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec5}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_5}" var="file">
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
				有最新的医疗指南
			</td>
			<td height="44" align="center" class="tableLine" >
				Up-to-date
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result6 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result6 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec6}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_6}" var="file">
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
				有实时更新的远程医疗救助无线电台清单
			</td>
			<td height="44" align="center" class="tableLine" >
				Is there the list of radio stations for telemetrically assistance here?
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result7 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result7 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec7}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_7}" var="file">
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
			<td height="44" align="center" class="tableheadLine" >
				人员Personal
			</td>
			<td height="44" align="center" class="tableLine" >
				医疗人员具备资质
			</td>
			<td height="44" align="center" class="tableLine" >
				Did you have the first aid certificate? In your hand now?
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result8 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result8 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec8}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_8}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="2" >
				废物容器Waste container
			</td>
			<td height="44" align="center" class="tableLine" >
				垃圾桶配备规范
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine">
				看角落的垃圾桶，是否加盖，何种材质，有无黄色、上有“国际传染性物资标志”的垃圾袋
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result9 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result9 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec9}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_9}" var="file">
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
				有存放防刺穿针头的容器
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine">
				在桌上看是否有白色或者黄色的容器，上面有检查“国际传染性物资标志”以及“sharp”的字样
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result10 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result10 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec10}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_10}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="3" >
				医药箱Medical chest
			</td>
			<td height="44" align="center" class="tableLine" >
				药品存放整齐，无过期药品
			</td>
			<td height="44" align="center" class="tableLine" >
				Where do you store the medicine and medication?<br/>
				Is there a medicine list here? <br/>
				 Could you please tell me how you find and treat the expired medicine?<br/>
				 (按照规定，过期药品应放在一个棕色塑料袋里) <br/>                          
			</td>
			<td height="44" align="center" class="tableLine">
				1、看药箱是否上锁，药品摆放是否整齐，是否有标签 <br/>
				2、随机抽两瓶药，查有效期（找不到可请二副帮忙） <br/>
				3、注意有无冰箱且是否上锁，且看温度计显示（有些船舶在冰箱内部放一个便携式温度计也可以）<br/>
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result11 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result11 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec11}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_11}" var="file">
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
				有药品清单medicine list
			</td>
			<td height="44" align="center" class="tableLine" rowspan="2">
				Size, type and storage of medical chest adequate to diagnose,<br/>
				 treat and control public health risks on board<br/>
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result12 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result12 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec12}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_12}" var="file">
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
				有药品证书medical chest certificate
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result13 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result13 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec13}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_13}" var="file">
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
			<td height="44" align="center" class="tableheadLine"  >
				医疗设备Equipment
			</td>
			<td height="44" align="center" class="tableLine" >
				医疗设备定期校正
			</td>
			<td height="44" align="center" class="tableLine" >
				Where is the oxygen bottle? How often do you calibrate the bottle?<br/> 
				Could you show us how to use the stretcher?<br/>  
				Where is the instruction book of the oxygen bottle and stretcher?  <br/>                      
			</td>
			<td height="44" align="center" class="tableLine">
				看氧气瓶的有效日期（找不到，让二副帮忙），看担架是否开封过
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result14 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result14 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec14}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_14}" var="file">
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
			<td height="44" align="center" class="tableheadLine"  rowspan="3">
				清洁Cleaning
			</td>
			<td height="44" align="center" class="tableLine" >
				冲水设备状况良好
			</td>
			<td height="44" align="center" class="tableLine" >
			</td>
			<td height="44" align="center" class="tableLine">
				试试马桶冲水，看地面清洁；倒一杯水看地漏是否通畅
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result15 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result15 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec15}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_15}" var="file">
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
				洗手设施状况良好
			</td>
			<td height="44" align="center" class="tableLine" >
				Is this the potable water? <br/> 
				Both cool and hot?
			</td>
			<td height="44" align="center" class="tableLine">
				左右开水龙头、试水温
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result16 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result16 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec16}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_16}" var="file">
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
				有纸巾或干手设备、液体肥皂、污物桶、马桶刷或厕纸等
			</td>
			<td height="44" align="center" class="tableLine" >
				A边做边向B说。
			</td>
			<td height="44" align="center" class="tableLine">
				检查是否配有纸巾或干手设备、液体肥皂、污物桶、马桶刷或厕纸等。
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result17 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result17 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec17}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_17}" var="file">
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
			<td height="44" align="center" class="tableheadLine"  >
				医疗废水Medical liquid waste
			</td>
			<td height="44" align="center" class="tableLine" >
				液体废物和废水管道连至污水（黑水）系统
			</td>
			<td height="44" align="center" class="tableLine" >
				Is medical liquid waste discharged into the sea directly?                     
			</td>
			<td height="44" align="center" class="tableLine">
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result18 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result18 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec18}</span>
				<c:forEach items="${V_MS_SP_YL_ZJ_18}" var="file">
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