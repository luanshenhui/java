<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>申报无异常事项</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
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
.tableLine {
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
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script type="text/javascript">
	/*
	$(function(){
		$(".vList").each(function(e){});
	});
	*/
</script>
<div>
<div class="chatTitle">申报无异常事项</div>
	 <div class="chatTitle" style="font-size:16px">归档用</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td width="700" height="44" align="left" class="tableLine"  colspan="4">
				航海健康申报书Maritime Declaration of Health
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_1=='0'}"><span>有</span></c:if><c:if test="${results.option_1=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_2=='0'}"><span>没问题</span></c:if><c:if test="${results.option_2=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_3 }</span>
				<span id="V_JC_T_T_26" class="vList">
					<c:forEach items="${V_JC_T_T_26 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				总申报单General declaration
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_4=='0'}"><span>有</span></c:if><c:if test="${results.option_4=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_5=='0'}"><span>没问题</span></c:if><c:if test="${results.option_5=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_6 }</span>
				<span id="V_JC_T_T_27" class="vList">
					<c:forEach items="${V_JC_T_T_27 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				货物申报单Cargo declaration
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_7=='0'}"><span>有</span></c:if><c:if test="${results.option_7=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_8=='0'}"><span>没问题</span></c:if><c:if test="${results.option_8=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_9 }</span>
				<span id="V_JC_T_T_28">
					<c:forEach items="${V_JC_T_T_28 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				船用物品清单Ships Stores Declaration
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_10=='0'}"><span>有</span></c:if><c:if test="${results.option_10=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_11=='0'}"><span>没问题</span></c:if><c:if test="${results.option_11=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_12 }</span>
				<span id="V_JC_T_T_29">
					<c:forEach items="${V_JC_T_T_29 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				船员名单Crew list
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_13=='0'}"><span>有</span></c:if><c:if test="${results.option_13=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_14=='0'}"><span>没问题</span></c:if><c:if test="${results.option_14=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_15 }</span>
				<span id="V_JC_T_T_30">
					<c:forEach items="${V_JC_T_T_30 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				旅客名单Passenger list
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_16=='0'}"><span>有</span></c:if><c:if test="${results.option_16=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_17=='0'}"><span>没问题</span></c:if><c:if test="${results.option_17=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_18 }</span>
				<span id="V_JC_T_T_31">
					<c:forEach items="${V_JC_T_T_31 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				航次表Ports of call
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_19=='0'}"><span>有</span></c:if><c:if test="${results.option_19=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_20=='0'}"><span>没问题</span></c:if><c:if test="${results.option_20=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_21 }</span>
				<span id="V_JC_T_T_32">
					<c:forEach items="${V_JC_T_T_32 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				食品饮用水清单(注明供应港口及产地)food drinking water list (note the supplied port and produced region)
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_22=='0'}"><span>有</span></c:if><c:if test="${results.option_22=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_23=='0'}"><span>没问题</span></c:if><c:if test="${results.option_23=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_24 }</span>
				<span id="V_JC_T_T_33">
					<c:forEach items="${V_JC_T_T_33 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				压舱水申报单IMO ballast water reporting form
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_25=='0'}"><span>有</span></c:if><c:if test="${results.option_25=='1'}"><span>无</span></c:if>
				<c:if test="${results.option_26=='0'}"><span>没问题</span></c:if><c:if test="${results.option_26=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_27 }</span>
				<span id="V_JC_T_T_34">
					<c:forEach items="${V_JC_T_T_34 }" var="v">
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
	 
	 <div class="chatTitle" style="font-size:16px">查阅用</div>
	<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
		<tr>
			<td width="660" height="44" align="left" class="tableLine"  colspan="4">
				卫生控制/免予卫生控制证书Ship sanitation control (exemption) certificate
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_28=='0'}"><span>没问题</span></c:if><c:if test="${results.option_28=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_29 }</span>
				<span id="V_JC_T_T_39" class="vList">
					<c:forEach items="${V_JC_T_T_39 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				预防接种证书International Certificate of Vaccination or Prophylaxi
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_30=='0'}"><span>没问题</span></c:if><c:if test="${results.option_30=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_31 }</span>
				<span id="V_JC_T_T_40" class="vList">
					<c:forEach items="${V_JC_T_T_40 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				健康证 Health card
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_32=='0'}"><span>没问题</span></c:if><c:if test="${results.option_32=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_33 }</span>
				<span id="V_JC_T_T_41" class="vList">
					<c:forEach items="${V_JC_T_T_41 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				健康申明卡（重大疫情情况下）Health declaretion
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_34=='0'}"><span>没问题</span></c:if><c:if test="${results.option_34=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_35 }</span>
				<span id="V_JC_T_T_42" class="vList">
					<c:forEach items="${V_JC_T_T_42 }" var="v">
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
			<td height="44" align="left" class="tableLine"  colspan="4">
				其他：航海日志、轮机日志等
			</td>
			<td height="44" align="left" class="tableLine"  colspan="4">
				<c:if test="${results.option_36=='0'}"><span>没问题</span></c:if><c:if test="${results.option_36=='1'}"><span>有问题</span></c:if>
				<span>文字描述：${results.option_37 }</span>
				<span id="V_JC_T_T_43" class="vList">
					<c:forEach items="${V_JC_T_T_43 }" var="v">
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
	 <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();"/>
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
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<script type="text/javascript">
$("#imgd1").hide();
//图片预览
function showPic(path) {
	url = "/ciqs/showVideo?imgPath=" + path;
	$("#imgd1").attr("src", url);
	$("#imgd1").click();
}
</script>
<%@ include file="/common/player.jsp"%>
</html>