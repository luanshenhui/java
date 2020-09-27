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
			<td height="44" align="center" class="tableheadLine" >
				卫生设施Sanitary faculties
			</td>
			<td height="44" align="center" class="tableLine" >
				有清洗室和更衣间
			</td>
			<td height="44" align="center" class="tableLine" >
				Is there a room for you to take a shower and change clothes?
			</td>
			<td height="44" align="center" class="tableLine">
				确定在轮机舱的检查路线
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result1 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result1 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec1}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_1}" var="file">
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
				焚烧炉Incinerator
			</td>
			<td height="44" align="center" class="tableLine" >
				焚烧炉没有焚烧不应该焚烧的东西
			</td>
			<td height="44" align="center" class="tableLine" >
				I want to look at incinerator? How do you treat incinerator ashes?  What kinds of garbage can are treated in the incinerator?
			</td>
			<td height="44" align="center" class="tableLine">
				看是否工作；如果没工作，打开，看入料口和出料口；看周围垃圾桶及垃圾桶标识；看桶内有没有禁止焚烧的东西
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result2 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result2 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec2}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_2}" var="file">
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
			<td height="44" align="center" class="tableheadLine">
				污水管道Sewage pipe
			</td>
			<td height="44" align="center" class="tableLine" >
				污水管道有颜色标识
			</td>
			<td height="44" align="center" class="tableLine" >
				Where are the marks of identification of pipe color?
			</td>
			<td height="44" align="center" class="tableLine">
				看轮机舱内的管道颜色标示图；看污水管道，有没有颜色标示
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result3 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result3 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec3}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_3}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="2">
				污水储存舱Sewage holding tank
			</td>
			<td height="44" align="center" class="tableLine" >
				有液面指示器、高位报警器、溢出系统
			</td>
			<td height="44" align="center" class="tableLine" rowspan="4">
				Where is the sewage-holding tank and sewage treatment plant?                   Where is the lable and the capacity of the tank, level indicator, high level alert?  Do you know the sampling point where sb can take samples of treated sewage water?                  Where did you put the disinfectant into the sewage treatment plant?  Is it in an satisfactory condition?
			</td>
			<td height="44" align="center" class="tableLine" rowspan="4">
				检查储存舱容量与国际防止污水污染证书是否相符；现场检查污水舱液面指示器、高位报警器
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result4 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result4 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec4}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_4}" var="file">
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
				有储存舱标识、容量
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result5 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result5 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec5}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_5}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="3">
				污水储存舱Sewage holding tank
			</td>
			<td height="44" align="center" class="tableLine" >
				设备认证，运转良好
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result6 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result6 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec6}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_6}" var="file">
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
				处理水出水口处有金属采样点
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result7 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result7 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec7}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_7}" var="file">
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
				排放阀处于关闭状态
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine">
				看污水管道排放阀是否处于关闭状态,是否漏水
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result8 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result8 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec8}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_8}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="4" >
				饮用水水舱Potable water tank
			</td>
			<td height="44" align="center" class="tableLine" >
				饮用水舱位置合理、有标识和容积
			</td>
			<td height="44" align="center" class="tableLine" >
				Where is the potable water tank?         .Where is the sewege holding tank?       Where is the lable of portable water tank?
			</td>
			<td height="44" align="center" class="tableLine">
				现场检查标识和容积，是否与船体或者其他非饮用水舱共用一面墙体
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result9 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result9 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec9}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_9}" var="file">
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
				有用于检查用的维护开口，无载有生活污水或其他重污染液体的管道等横跨饮用水舱的人孔之上
			</td>
			<td height="44" align="center" class="tableLine" >
				Are there maintenance openings at the top of a tank?  What are kinds of pipes above the tank? 
			</td>
			<td height="44" align="center" class="tableLine">
				现场看人孔是否关闭.如在饮用水舱上方看到管道
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result10 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result10 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec10}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_10}" var="file">
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
				有饮用水舱通风口/溢流口
			</td>
			<td height="44" align="center" class="tableLine" >
				Where is tank ventilation or overflow?
			</td>
			<td height="44" align="center" class="tableLine">
				现场看
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result11 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result11 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec11}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_11}" var="file">
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
				水舱外安装耐热采样龙头
			</td>
			<td height="44" align="center" class="tableLine">
				Where is the sample outlet of the tank?
			</td>
			<td height="44" align="center" class="tableLine">
				现场看看是否向下且有标示和编号
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result12 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result12 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec12}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_12}" var="file">
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
				饮用水的消毒Disinfection of potable water
			</td>
			<td height="44" align="center" class="tableLine" >
				是否有消毒设施
			</td>
			<td height="44" align="center" class="tableLine">
				Are there automatic disinfection devices for portable water? Are there automatic disinfection devices for portable water?            In the bunker line or in the tank?                        How often do you clean and disinfect UV lamps?
			</td>
			<td height="44" align="center" class="tableLine">
				如果有消毒设施，检查是加氯装置还是紫外线消毒系统。如果是紫外线消毒系统，询问问题3,看设备上是否有生产厂家和技术规范相关信息
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result13 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result13 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec13}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_13}" var="file">
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
				饮用水定期消毒
			</td>
			<td height="44" align="center" class="tableLine">
				How do you put the disinfectant into the portable water tank?
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result14 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result14 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec14}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_14}" var="file">
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
				消毒药品有专用储存地点
			</td>
			<td height="44" align="center" class="tableLine">
				Where do you store the disinfection chemicals?
			</td>
			<td height="44" align="center" class="tableLine">
				有可能去看看储藏地点
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result15 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result15 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec15}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_15}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="2">
				饮用水管道Water piping
			</td>
			<td height="44" align="center" class="tableLine" >
				饮用水管道颜色标识符合要求
			</td>
			<td height="44" align="center" class="tableLine" >
				According to ISO 14726, potable water piping should be with color code. Please show us the water piping colors code.                     
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result16 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result16 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec16}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_16}" var="file">
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
				有防回流装置
			</td>
			<td height="44" align="center" class="tableLine" >
				Where is the backflow prevention?                How much on board?                 
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result17 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result17 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec17}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_17}" var="file">
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
			<td height="44" align="center" class="tableheadLine"  rowspan="2">
				淡水制备Water production
			</td>
			<td height="44" align="center" class="tableLine" >
				取水管与用于卫生用水排放口位于船舶异侧
			</td>
			<td height="44" align="center" class="tableLine" >
				Are the sea chest for fresh water intake and outlet of discharging sewage on the same side or different side?
			</td>
			<td height="44" align="center" class="tableLine">
				
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result18 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result18 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec18}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_18}" var="file">
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
				再矿化装置的清洗、维护或再灌注措施规范
			</td>
			<td height="44" align="center" class="tableLine" >
				Do you add mineral into the potable water tank?
			</td>
			<td height="44" align="center" class="tableLine">
				检查再矿化装置是否标明生产厂商、技术规范等相关信息
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result19 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result19 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec19}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_19}" var="file">
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
			<td height="44" align="center" class="tableheadLine" rowspan="2">
				加水程序Bunkering procedure
			</td>
			<td height="44" align="center" class="tableLine" >
				饮水管线存放合理
			</td>
			<td height="44" align="center" class="tableLine" >
				Where is the potable water filling hose?        
			</td>
			<td height="44" align="center" class="tableLine">
				现场看，饮用水管线储存箱是否关闭，箱内是否有无关的设备和器具
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result20 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result20 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec20}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_20}" var="file">
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
				有水质检测设备
			</td>
			<td height="44" align="center" class="tableLine" >
				Is there testing equipment on board?
			</td>
			<td height="44" align="center" class="tableLine">
				现
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result21 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result21 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec21}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_21}" var="file">
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
			<td height="44" align="center" class="tableheadLine">
				水龙头Water taps
			</td>
			<td height="44" align="center" class="tableLine" >
				水的出口标识规范完整
			</td>
			<td height="44" align="center" class="tableLine" >
				
			</td>
			<td height="44" align="center" class="tableLine">
				现场看，饮用水、非饮用水的出口是否有‘饮用水’‘不适合饮用’的标识
			</td>
			<td height="44" align="center" class="tableLine">
				是Yes<input type="checkbox"  <c:if test="${check_result22 == 0}"> checked="checked" </c:if> /><br/>   
				否No<input type="checkbox" <c:if test="${check_result22 == 1}"> checked="checked" </c:if>/> <br/>
			</td>
			<td height="44" align="center" class="tableLine">
			<span>${dec22}</span>
				<c:forEach items="${V_MS_SP_JC_ZJ_22}" var="file">
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