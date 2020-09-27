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
          	<span style="text-align:center;font-size:30px"><strong > 国境口岸航空配餐企业卫生许可现场审查表</strong></span>
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
  <td rowspan="4" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">选址</p>
（15分）</td>
  <td align="center" class="tableLine">1.不应选择对食品有显著污染的区域，以及有害废弃物、粉尘、有害气体、放射性物质和其他扩散性污染源不能有效清除的地址。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_1}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="4" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_86'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_86'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">2.周围不宜有虫害大量孳生的潜在场所，难以避开时应设计必要的防范措施。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_2}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">3.水源供应充足，水质符合《生活饮用水卫生标准》等要求。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_3}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">4.地势平坦，干燥，易于排水。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_4}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="14" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">厂房和车间</p>
（52分）</td>
  <td height="103" align="center" class="tableLine">5.厂区布局合理，环境整洁，厂区道路硬化，划分生产区和生活区，生产区应在生活区的上风向。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_5}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="14" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_87'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_87'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">6.厂房的面积和空间应与生产能力相适应，便于设备安置、清洁消毒、物料储存及人员操作。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_6}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">7.食品生产区应设置专用的初加工、冷加工、热加工、分装、装配、储存及餐用具清洗消毒场所。冷食加工及分装、热食加工及分装应分别设置相应专间，洁净餐具存放应设置相应专区。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_7}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">8.厂房和车间的设计与布局应能满足生产工艺流程和卫生操作需要， 按原料验收-储存-初加工-冷、热加工-分装-装配-成品储存-配送装机的生产流程合理布局，避免食品交叉污染。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_8}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">9.厂房和车间应合理划分作业区，并采取有效分离或分隔。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_9}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">10.厂房内设置的检验室应与生产区域分隔。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_10}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">11.食品原料入口及通道、餐食配送通道及出口、垃圾通道及出口.飞机餐食/餐具回收入口通道、人员入口应当分开设置。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_11}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">12.建筑内部结构应易于维护、清洁或消毒。应采用适当的耐用材料建造。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_12}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">13.车间地面应使用无毒、无味、不渗透、耐腐蚀的材料建造，结构应有利于排污和清洗的需要。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_13}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">14.地面应平坦防滑、无裂缝、并易于清洁、消毒，并有适当的措施防止积水。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_14}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">15.墙壁、隔断应使用无毒、无味、的防渗透材料建造，在操作高度范围内的墙面应光滑、不易积累污垢且易于清洁。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_15}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">16.墙壁、隔断和地面交界处应结构合理、易于清洁，能有效避免污垢积存。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_16}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">17.顶棚应使用无毒、无味、与生产需求相适应、易于观察清洁状况的材料建造，表面涂层不易脱落，在结构上不利于冷凝水垂直滴下。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_17}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">18.门、窗严密，有防蝇、防尘、防鼠设施，防护门能自动闭合，位置合理，窗户如设置窗台，其结构应能避免灰尘积存且易于清洁。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_18}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="33" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">设施与设备卫生要求</p>
（124分）</td>
  <td height="103" align="center" class="tableLine">19.食品加工用水的水质应符合GB5749的规定。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_19}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="33" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_88'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_88'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">20.食品加工用水与其他不与食品接触的用水（如间接冷却水、污水或废水等）应以完全分离的管路输送，避免交叉污染。各管路系统应明确标识以便区分。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_20}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">21.排水系统地设计和建造应保证排水通畅、便于清洁维护；应适应食品生产的需要，保证食品及生产、清洁用水不受污染。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_21}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">22.排水系统入口应安装带水封的地漏等装置，以防止固体废弃物进入及浊气溢出，出口处应有适当措施以降低虫害风险。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_22}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">23.室内排水的流向应由清洁程度要求高的区域流向清洁程度要求低的区域，且有防止逆流的设计。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_23}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">24.污水在排放前应经适当的方式处理，以符合国家污水排放的相关规定。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_24}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">25.应配备足够的食品、工器具和设备的专用清洁设施和消毒设施，并单独存放，其位置不会污染食品及其加工操作过程。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_25}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">26.各场所设置密闭的废弃物盛放容器（堆放加工边角料容器除外），容器应标识清洗，专间内的废弃物容器盖子为非手动开启式。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_26}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">27.生产场所入口处应设置更衣室；必要时特定的作业区（比如专间）入口处可按需要设置更衣室。更衣室应保证工作服与私人物品个人服装及其他物品分开放置。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_27}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">28.生产场所入口处应设置换鞋（穿戴鞋套）设施或工作鞋靴消毒设施。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_28}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">29.根据需要设置冲水式卫生间，卫生间内的适当位置设置洗手设施，卫生间不得与食品生产、包装或贮存等区域直接连通。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_29}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">30.卫生间设置防蝇、排臭装置。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_30}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">31.生产场所入口处应设置洗手、干手和消毒设施，与消毒设施配套的水龙头其开关应为非手动式。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_31}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">32.在临近洗手设施的显著位置标示简单易懂的洗手方法。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_32}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">33.生产场所内应有通风、排气装置，并能及时换气和排除水蒸气。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_33}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">34.空气流动方向应从清洁度要求高的作业区域向清洁度要求低的区域流动。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_34}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">35.通风口应安装滤网或其他保护性网罩，并便于装卸和清洗。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_35}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">36.冷食制作、烘焙食品冷加工、食品分装、装配车间及冷藏、冻藏库应有温控和温度监测设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_36}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">37.生产场所内应有充足的自然采光或人工照明，光泽和亮度应能满足生产操作和食品安全质量监控的要求；光源应使食品呈现真实的颜色。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_37}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">38.冻藏库照明应使用防爆灯，裸露食品和原料正上方的照明设施应采取防护措施。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_38}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">39.应具有与所生产产品的数量、贮存要求相适应的仓储设施，原料、半成品、成品、包装材料等应根据性质的不同分设贮存场所或分区域码放，并有明确标识，防止交叉污染。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_39}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">40.贮存物品应与墙壁、地面保持适当距离，以利于空气流通及物品搬运；常温库房应有机械通风设施。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_40}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">41.清洁剂、消毒剂与杀虫剂等有毒物质应分别存放，明确标识，与原料、半成品、成品、包装材料等分库存放。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_41}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">42.仓库、生产车间应有防止鼠类、蚊蝇、昆虫等设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_42}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">43.使用木门的，下端具有金属防鼠板(60cm以上)。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_43}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">44.非全部使用空调的单位，应配备纱门、纱窗或者塑料门帘。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_44}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">45.排气口装有网眼孔径小于2mm的金属隔栅或网罩。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_45}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">46.排水沟出口有眼孔径小于6mm的金属隔栅或网罩。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_46}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">47.生产冷链食品的航空配餐企业应配备足量食品速冷设备。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_47}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">48.生产冷链食品的航空配餐企业应配备具有温度控制和监测功能的成品冷库，面积和空间满足航空食品周转需要。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_48}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">49.航空配餐企业应配置专用的航空食品运输工具，冷链、热链食品的运输工具应具备温度控制设备和温度监测装置。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_49}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">50.运输工具的箱体应密闭，并采用无毒、无害、无异味、无渗漏等符合食品安全的材料制成。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_50}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">51.配备足够数量专用的飞机餐车（箱）。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_51}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="12" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">操作间及专间卫生要求</p>
（40分）</td>
  <td height="103" align="center" class="tableLine">52.粗加工间（区域）分设肉类、水产品和果蔬原料洗消间或池，水池数量应满足食品加工需要并有明显标志。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_52}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="12" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_89'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_89'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">53.粗加工间（区域）加工肉类（包括水产品）的操作台、用具和容器与加工果蔬类的分开使用，并有明显标志。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_53}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">54.专间或清洁作业区应设置洗手、干手和消毒设施，采用非手动式的水龙头。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_54}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">55.专间或清洁作业区入口处设预进间（可设置为风淋或二次更衣室）。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_55}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">56.专间或清洁作业区应配备充足有效的空气消毒装置。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_56}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">57.专间配备有温度控制和监测装置、食品冷藏设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_57}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">58.专间配备专用工具，并有专用的清洗消毒设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_58}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">59.冷食加工间设有食品专用输送通道。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_59}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">60.餐具洗消间(区域)配备足够数量专用洗涮水池或能正常运转的清洗设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_60}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">61.餐具洗消间(区域)设有独立的餐车洗消区域。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_61}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">62.餐具洗消间(区域)有充足、有效的消毒设施.</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_62}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">63.餐具洗消间(区域)有充足、完善的餐、饮具保洁设施设备，有明显标记。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_63}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="4" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">检验、留样要求</p>
（10分）</td>
  <td height="103" align="center" class="tableLine">64.设立与生产能力相适应的检验室（有特别说明除外）。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_64}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="4" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_90'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_90'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">65.具备能开展出厂检验项目所需的仪器、设备、试剂，并有检验方法。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_65}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">66.设置相应的留样设施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_66}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">67.配备经专业培训，有相应资质的检验人员。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_67}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>

<tr>
  <td height="51" align="center" valign="middle" class="tableLine" style="text-align: center">合计</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_79}</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_68}</td>
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
          
            <p><span style="margin-right:200px">得分：${dto.option_69}</span><span>检查时间：${dto.option_71}</span><p/>
            <p>标化分：${dto.option_70}<p/>
            <p> 
            	<span style="margin-right:148px">陪同检查人：
	            <c:if test="${not empty dto.option_74}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_74}" width="50px" height="50px" />
	      		</c:if> 
	      		</span>
	      		<span>
	      		监督员：
	      		<c:if test="${not empty dto.option_75}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_75}" width="50px" height="50px" />
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
