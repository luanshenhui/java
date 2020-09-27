<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
</head>
<script language="javascript" type="text/javascript">
$(function(){
	$("#imgd1").hide();
})
function dayin() {
	window.print();
}

/**
 * 显示图片浏览
 * path 数据库保存的图片地址 E:/201708/20170823/1B083FEA24D6E00004df8.jpg
 * wangzhy
 */
function toImgDetail(path){
	url = "/ciqs/showVideo?imgPath="+path;
	$("#imgd1").attr("src",url);
	$("#imgd1").click();		
}
</script>

<style type="text/css">
td{padding:5px}
<!--
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
@media print {
.noprint{display:none}
}
#content table tr td {
	text-align: left;
}
#content table {
	text-align: left;
}
#content table tr td strong {
	text-align: center;
}
#content table tr td strong {
	text-align: center;
}
#content table tr td strong {
	text-align: center;
}
#content table {
	text-align: center;
}
#content table tr td strong {
	text-align: center;
}
#content .tableLine tr .tableLine {
	text-align: left;
}
#content .tableLine {
	text-align: center;
}
-->
</style>
<body>
	<div id="content">
    <table width="700px" align="center">
        <tr>
          <td style="text-align:center;">
          	<span style="text-align:center;font-size:30px"><strong > 国境口岸餐饮服务单位卫生许可现场审查表（六）</strong></span>
          </td>
        </tr>
        <tr>
          <td style="text-align:center;">
          	<span>（ 适用于中央厨房）</span><br>
		  </td>
        </tr>
        <tr>
          <td >
          	<span style="text-align:left;"><strong>被检查单位：</strong>${cpDto.comp_name}</span>
            <span style="margin-left:400px;text-align:right;">
            	结论：<input type="checkbox" disabled="disabled" <c:if test="${dto.option_80==0}">checked="checked"</c:if>/>合格  
            		<input type="checkbox" disabled="disabled" <c:if test="${dto.option_80==1}">checked="checked"</c:if>/>不合格 
            </span> 
          </td>
        </tr>
    </table>
    <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
        <td width="114" height="43" style="text-align: center" valign="middle" class="tableLine"><p><strong>审查环节</strong></p></td>
        <td width="508" style="text-align:center" class="tableLine"><p><strong>审查内容</strong></p></td>
        <td width="23" style="text-align: center" class="tableLine"><strong>分值</strong></td>
        <td width="24" style="text-align: center" class="tableLine"><strong>得分</strong></td>
        <td width="29" style="text-align:center" class="tableLine"><strong>小计</strong></td>
        <td width="24" style="text-align: center" class="tableLine"><strong>查看</strong></td>
      </tr>
<tr>
  <td height="117" style="text-align: center" valign="middle" class="tableLine">选址</td>
  <td align="center" class="tableLine">1.选择地势干燥、有给排水条件和电力供应的地区，不得设在易受到污染的区域。距离粪坑、污水池、暴露垃圾场（站）、旱厕等污染源25m以上，并设置在粉尘、有害气体、放射性物质和其他扩散性污染源的影响范围之外。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_1}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_68'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_68'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td rowspan="10" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">场所设置、布局、分隔和面积 </p>
（4分）</td>
  <td height="103" align="center" class="tableLine">2.设置具有与供应品种、数量相适应的粗加工、切配、烹调、面点制作、食品冷却、食品包装、待配送食品贮存、工用具清洗消毒等加工操作场所，以及食品库房、更衣室、清洁工具存放场所等。食品处理区分为一般操作区、准清洁区、清洁区，各食品处理区均应设置在室内，且独立分隔。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_2}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="10" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_69'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_69'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">3.配制凉菜以及待配送食品贮存的，应分别设置食品加工专间；食品冷却、包装应设置食品加工专间或专用设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_3}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">4.各加工操作场所按照原料进入、原料处理、半成品加工、食品分装及待配送食品贮存的顺序合理布局，并能防止食品在存放、操作中产生交叉污染。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_4}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">5.接触原料、半成品、成品的工具、用具和容器，有明显的区分标识，且分区域存放；接触动物性和植物性食品的工具、用具和容器也有明显的区分标识，且分区域存放。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_5}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">6.食品加工操作和贮存场所面积原则上≥300㎡，应当与加工食品的品种和数量相适应。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_6}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">7.切配烹饪场所面积≥食品处理区面积15%。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_7}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">8.清洗消毒区面积≥食品处理区面积10%。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_8}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">9.凉菜专间面积≥10 ㎡。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_9}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">10.厂区道路采用混凝土、沥青等便于清洗的硬质材料铺设，有良好的排水系统。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_10}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">11.加工经营场所内无圈养、宰杀活的禽畜类动物的区域（或距离25m以上）。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_11}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">食品处理区地面、排水</p>
（10分）</td>
  <td height="103" align="center" class="tableLine">12.地面用无毒、无异味、不透水、不易积垢的材料铺设，且平整、无裂缝。粗加工、切配、加工用具清洗消毒和烹调等需经常冲洗场所、易潮湿场所的地面易于清洗、防滑，并有排水系统。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_12}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_70'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_70'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">13.地面和排水沟有排水坡度（不小于1.5%），排水的流向由高清洁操作区流向低清洁操作区。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_13}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">14.排水沟出口有网眼孔径小于6mm的金属隔栅或网罩。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_14}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="5" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">墙壁与门窗</p>
（22分）</td>
  <td height="103" align="center" class="tableLine">15.墙壁采用无毒、无异味、不透水、平滑、不易积垢的浅色材料，粗加工、切配、烹调和工用具清洗消毒等场所应有1.5 m以上的光滑、不吸水、浅色、耐用和易清洗的材料制成的墙裙，食品加工专间内应铺设到顶。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_15}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="5" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_71'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_71'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">16.墙角、柱脚、侧面、底面的结合处有一定的弧度。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_16}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">17.门、窗装配严密，与外界直接相通的门和可开启的窗设有易于拆下清洗不生锈的纱网或空气幕，与外界直接相通的门和各类专间的门能自动关闭。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_17}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">18.内窗台下斜45度以上或采用无窗台结构。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_18}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">19.粗加工、切配、烹调、工用具清洗消毒等场所、食品包装间的门采用易清洗、不吸水的坚固材料制作。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_19}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">天花板</p>
（12分）</td>
  <td height="103" align="center" class="tableLine">20.天花板用无毒、无异味、不吸水、表面光洁、耐腐蚀、耐温、浅色材料涂覆或装修。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_20}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_72'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_72'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">21.半成品、即食食品暴露场所屋顶若为不平整的结构或有管道通过，加设平整易于清洁的吊顶（吊顶间缝隙应严密封闭）。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_21}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">22.水蒸气较多的场所的天花板有适当的坡度（斜坡或拱形均可）。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_22}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">洗手消毒设施</p>
（9分）</td>
  <td height="103" align="center" class="tableLine">23.食品处理区内设置足够数量的洗手设施，其位置设置在方便员工的区域。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_23}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_73'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_73'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">24.洗手池的材质为不透水材料，结构不易积垢并易于清洗。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_24}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">25.洗手消毒设施旁设有相应的清洗、消毒用品和干手设施，员工专用洗手消毒设施附近有洗手消毒方法标识。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_25}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="7" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">工用具清洗消毒保洁设施</p>
（12分）</td>
  <td height="103" align="center" class="tableLine">26.根据加工食品的品种，配备能正常运转的清洗、消毒、保洁设备设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_26}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="7" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_74'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_74'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">27.采用有效的物理消毒或化学消毒方法。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_27}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">28.各类清洗消毒方式设专用水池的最低数量：采用化学消毒的，至少设有3个专用水池或容器。采用热力消毒的，可设置２个专用水池或容器。各类水池或容器以明显标识标明其用途。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_28}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">29.接触直接入口食品的工具、容器清洗消毒水池专用，与食品原料、清洁用具及接触非直接入口食品的工具、容器清洗水池分开。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_29}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">30.工用具清洗消毒水池使用不锈钢或陶瓷等不透水材料、不易积垢并易于清洗。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_30}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">31.设专供存放消毒后工用具的保洁设施，标记明显，易于清洁。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_31}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">32.清洗、消毒、保洁设备设施的大小和数量能满足需要。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_32}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="2" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">食品原料、清洁工具清洗水池</p>
（5分）</td>
  <td height="103" align="center" class="tableLine">33.粗加工操作场所分别设动物性食品、植物性食品、水产品3类食品原料的清洗水池，水池数量或容量与加工食品的数量相适应。各类水池以明显标识标明其用途。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_33}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="2" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_75'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_75'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">34.加工场所内设专用于拖把等清洁工具、用具的清洗水池，其位置不会污染食品及其加工操作过程。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_34}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="6" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">加工食品设备、工具和容器</p>
（14分）</td>
  <td height="103" align="center" class="tableLine">35.食品烹调后以冷冻（藏）方式保存的，应根据加工食品的品种和数量，配备相应数量的食品快速冷却设备。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_35}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="6" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_76'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_76'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">36.应根据待配送食品的品种、数量、配送方式，配备相应的食品包装设备。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_36}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">37.接触食品的设备、工具、容器、包装材料等符合食品安全标准或要求。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_37}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">38.接触食品的设备、工具和容器易于清洗消毒。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_38}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">39.所有食品设备、工具和容器不使用木质材料，因工艺要求必须使用除外。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_39}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">40.食品容器、工具和设备与食品的接触面平滑、无凹陷或裂缝（因工艺要求除外）。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_40}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="2" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">通风排烟设施</p>
（10分）</td>
  <td height="103" align="center" class="tableLine">41.食品烹调场所采用机械排风。产生油烟或大量蒸汽的设备上部，加设附有机械排风及油烟过滤的排气装置，过滤器便于清洗和更换。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_41}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="2" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_77'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_77'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">42.排气口装有网眼孔径小于6mm的金属隔栅或网罩。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_42}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="2" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">采光照明设施</p>
（4分）</td>
  <td height="103" align="center" class="tableLine">43.加工经营场所光源不改变所观察食品的天然颜色。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_43}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="2" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_78'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_78'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">44.安装在食品暴露正上方的照明设施使用防护罩。冷冻（藏）库房使用防爆灯。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_44}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="2" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">废弃物暂存设施</p>
（4分）</td>
  <td height="103" align="center" class="tableLine">45.食品处理区设存放废弃物或垃圾的容器。废弃物容器与加工用容器有明显区分的标识。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_45}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="2" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_79'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_79'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">46.废弃物容器配有盖子，以坚固及不透水的材料制造，内壁光滑便于清洗。专间内的废弃物容器盖子为非手动开启式。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_46}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="5" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center"></p>
（11分）</td>
  <td height="103" align="center" class="tableLine">47.食品和非食品（不会导致食品污染的食品容器、包装材料、工用具等物品除外）库房分开设置。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_47}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="5" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_80'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_80'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">48.冷藏、冷冻柜（库）数量和结构能使原料、半成品和成品分开存放，有明显区分标识。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_48}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">49.除冷库外的库房有良好的通风、防潮、防鼠（如设防鼠板或木质门下方以金属包覆）设施。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_49}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">50.冷藏、冷冻库设可正确指示库内温度的温度计。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_50}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">51.库房及冷藏、冷冻库内应设置数量足够的物品存放架，能使贮存的食品离地离墙存放。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_51}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="5" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">专间要求</p>
（10分）</td>
  <td height="103" align="center" class="tableLine">52.专间内无明沟，地漏带水封，专间墙裙铺设到顶。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_52}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="5" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_81'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_81'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">53.专间只设一扇门，采用易清洗、不吸水的坚固材质，能够自动关闭。窗户封闭。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_53}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">54.需要直接接触成品的用水，应加装水净化设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_54}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">55.专间内设符合餐饮服务食品安全管理规范要求的空调设施、空气消毒设施、流动水源、工具清洗消毒设施；凉菜间、食品冷却间、食品包装间设专用冷冻（藏）设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_55}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">56.专间入口处设置有非手动式洗手、消毒、更衣设施的通过式预进间。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_56}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">更衣室</p>
（2分）</td>
  <td height="103" align="center" class="tableLine">57.更衣场所应与加工经营场所处于同一建筑物内，有足够大小的空间、足够数量的更衣设施和适当的照明。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_57}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_82'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_82'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">厕所</p>
（7分）</td>
  <td height="103" align="center" class="tableLine">58.厕所不设在食品处理区。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_58}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_83'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_83'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">59.厕所采用水冲式，在出口附近设置洗手设施。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_59}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">60.厕所排污管道与食品加工操作场所的排水管道分设，并有可靠的防臭气水封。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_60}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">运输设备</p></td>
  <td height="103" align="center" class="tableLine">61.配备与加工食品品种、数量以及贮存要求相适应的封闭式专用运输冷藏车辆，车辆内部结构平整，易清洗。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_61}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_84'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_84'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">食品检验和留样</p>
（10分）</td>
  <td height="103" align="center" class="tableLine">62.设置与加工制作的食品品种相适应的检验室。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_62}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_85'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_85'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">63.配备与检验项目相适应的检验设施和检验人员。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_63}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine"></td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_64}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>

<tr>
  <td height="51" align="center" valign="middle" class="tableLine" style="text-align: center">合计</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_79}</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_65}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
</table>
<table width="700"  border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>          
          <p>注： 1. ※是关键监督项目，如果有一项不符合要求，则现场审查不合格。 <br>
            2. 每项如符合要求，则该项得满分；如不符合要求，则该项不得分。 <br>
            3. 可以有合理缺项（合理缺项项目用“－”标示），但需标化。标化分=所得的分数除以该单位应得的最高分数×100。 <br>
          4. 根据得分，做出审查结论，标化分90分以上者，现场审查合格。 </p>
     
            <p><span style="margin-right:200px">得分：${dto.option_66}</span><span>检查时间：${dto.option_68}</span><p/>
            <p>标化分：${dto.option_67}<p/>
            <p> 
            	<span style="margin-right:148px">陪同检查人：
	            <c:if test="${not empty dto.option_71}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_71}" width="50px" height="50px" />
	      		</c:if> 
	      		</span>
	      		<span>
	      		监督员：
	      		<c:if test="${not empty dto.option_72}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_72}" width="50px" height="50px" />
	      		</c:if>  
	      		</span>           
      		<p/>
         </td>
      </tr>
</table>
<c:if test="${clistSize>3 }">
    <logic:notEmpty name="clist">
      <logic:iterate indexId="rowIdx" id="paperlessDeclGoodsDTO" name="clist" type="com.dpn.ciq.model.PaperlessDeclGoodsDTO">
        <bean:write name="paperlessDeclGoodsDTO" property="container_code"/>
      </logic:iterate>
    </logic:notEmpty>
    </c:if>
    
    <div style="text-align: center;" class="noprint"><span>
      <input onClick="javascript:window.close();" type="button" class="btn" value="返回" />
            <input type="button" value="打印" id="print" class="btn" onClick="dayin()" />
      </span>
    </div>
</div>
<div class="title-cxjg" style="height:400px;"></div>
<!-- 图片查看 -->
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
<%@ include file="/common/player.jsp"%>
</body>
