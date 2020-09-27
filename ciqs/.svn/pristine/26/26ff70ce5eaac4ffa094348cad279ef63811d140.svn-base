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
          	<span style="text-align:center;font-size:30px"><strong > 国境口岸公共场所卫生许可现场审查表</strong></span>
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
  <td rowspan="3" height="117" style="text-align: center" valign="middle" class="tableLine">选址、设计与装修</td>
  <td align="center" class="tableLine">1.选址应符合《公共场所卫生管理条例》的有关要求。场所及周围环境整洁、卫生，无明显污染源。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_1}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="3" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_108'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_108'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">2.建筑、装饰材料应无毒、无害、无异味、坚固耐用。采光照明符合卫生要求。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_2}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">3.设计符合国家标准和规范的要求。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_3}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">给排风系统</p></td>
  <td height="103" align="center" class="tableLine">4.各类场所内应有排风系统，凡有空调装置的场所应有新风供给，且组织通风合理，排风系统过滤网定期清洗、消毒。新风入口应设在室外，远离污染源。各卫生间或吸烟区设独立排风系统。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_4}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_109'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_109'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">集中空调通风系统</p></td>
  <td height="103" align="center" class="tableLine">5.使用集中空调通风系统的，设计、卫生质量和卫生管理符合《公共场所集中空调通风系统卫生规范》（WS394-2012）的要求。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_5}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_110'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_110'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td rowspan="2" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">室内环境和空气质量</p></td>
  <td height="103" align="center" class="tableLine">6.室内微小气候、空气质量、噪声、光照等应当符合国家卫生标准和要求。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_6}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="2" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_111'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_111'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">7.室内环境卫生整洁，无积尘。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_7}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">生活饮用水</p></td>
  <td height="103" align="center" class="tableLine">8.应符合国家生活饮用水卫生标准，二次供水蓄水池应有卫生防护措施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_8}</td>
  <td align="center" class="tableLine">&nbsp;</td>
   <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_112'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_112'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">公共用品用具</p></td>
  <td height="103" align="center" class="tableLine">9.提供公用用具用品（如茶具、餐饮具等）的，应设立洗消区域，贴有明显标志，间内设与最大客容量相适应的洗消池和消毒、保洁设施。杯具配置与最大客容量比应大于3:1。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_9}</td>
  <td align="center" class="tableLine">&nbsp;</td>
   <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_113'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_113'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">病媒生物控制</p></td>
  <td height="103" align="center" class="tableLine">10.室内外无病媒生物孳生场所。根据公共场所经营规模、项目设置必要的防虫、防鼠设施，并保持完好有效。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_10}</td>
  <td align="center" class="tableLine">&nbsp;</td>
   <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_113'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_113'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">垃圾废弃物</p></td>
  <td height="103" align="center" class="tableLine">11.设置有盖的垃圾存放容器。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_11}</td>
  <td align="center" class="tableLine">&nbsp;</td>
   <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_114'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_114'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">禁烟要求</p></td>
  <td height="103" align="center" class="tableLine">12.室内公共场所禁止吸烟。应当设置醒目的禁止吸烟警语和标志。室外吸烟区不得位于行人必经的通道上。不得设置自动售烟机。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_12}</td>
  <td align="center" class="tableLine">&nbsp;</td>
     <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_115'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_115'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td rowspan="6" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">住宿业（25分）</p></td>
  <td height="103" align="center" class="tableLine">13.应设立专用布草间，或密闭储存布草设施。应有明显标识。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_13}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="6" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_116'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_116'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">14.应配备茶具、面盆、脚盆、拖鞋等公共用具的消毒间，配备专用的清洗、消毒及保洁设备。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_14}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">15.清洁物品与污染物品分开存放，标识明显、无交叉污染。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_15}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">16.备用物品分类分架存放，隔地离墙，保洁符合要求。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_16}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">17.各类布草数量与床位数之比不得低于3:1。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_17}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">18.所使用的清洁工具应按所清洁的部位区分，并明显标识。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_18}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">候车（机、船）室
（25分）
</p></td>
  <td height="103" align="center" class="tableLine">19.室内外设置足够数量的废弃物容器等卫生设施。 </td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_19}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_117'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_117'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">20.提供公共饮水处的，供水设施及饮水水质符合卫生要求和GB5749的规定。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_20}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">21.按旅客流量设置相应数量的卫生间。卫生间应保持蝇、蚊、蜚蠊、鼠不足为害及无异味。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_21}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">文化娱乐场所
（25分）
</p></td>
  <td height="103" align="center" class="tableLine">22.影剧院、音乐厅、录像室等设置消音装置，装饰材料采用吸音材料。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_22}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3"  style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_118'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_118'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">23.场所内应设置消毒间。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_23}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">24.室内应具备机械通风设施。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_24}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="5" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">美容美发场所
（17分）
</p></td>
  <td height="103" align="center" class="tableLine">25.理发室营业面积应在10 m2 以上，毛巾与座位比不少于3：1。美容场所理发室营业面积应在30 m2 以上，毛巾与座位比不少于10：1。洗头池与座位比不少于1:5。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_25}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="5"  style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_119'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_119'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">26.理发毛巾、浴巾、床单、枕巾、枕套等用品应设专柜存放，有相应的消毒间或洗涤消毒设施（水池、消毒柜、洗涤剂等）或委托有资质的消毒单位。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_26}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">27.应配备针对直接接触顾客的美容美发用具的消毒设施，或使用一次性产品。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_27}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">28.应备有供患头癣等皮肤传染病顾客专用的理发工具，并有明显标志，单独存放。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_28}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">29.应有足够的工作服和口罩。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_29}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="5" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">沐浴场所
（17分）
</p></td>
  <td height="103" align="center" class="tableLine">30.应设有专用洁净布草间，贴有明显标识。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_30}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="5"  style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_120'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_120'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">31.清洁物品与污染物品分开存放，标识明显、无交叉污染。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_31}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">32.设立专用清洗消毒间，茶具、毛巾、拖鞋有固定的专用清洗消毒设施，贴有明显标识，毛巾等布草可委托有资质的消毒单位。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_32}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">33.浴室应设气窗，保持良好通风，气窗面积为地面面积的5%，进风口设置合理；浴室地面坡度不少于2%；浴室喷头按更衣室床位数的五分之一设置，间距大于0.9m；浴室、厕所地面要防渗、防滑；桑拿室设透气口。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_33}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">34.总台应设有禁止患性病和各种传染性皮肤病的顾客就浴的明显标识。</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_34}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="4" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">游泳场所
（25分）
</p></td>
  <td height="103" align="center" class="tableLine">35.各功能区的位置要按更衣、强制淋浴和浸脚、游泳池的顺序合理布局，相互间的比例适当，符合安全、卫生、使用要求。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_35}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="4"  style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_121'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_121'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">36.游泳池必须具有循环净水和消毒设备,氯化消毒设备须有防护措施。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_36}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">37.淋浴室通往游泳池直道应设强制通过式浸脚消毒池，淋浴室与浸脚消毒池之间应当设置强制通过式淋浴装置。</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_37}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="103" align="center" class="tableLine">38.应配备必要的游离性余氯、PH值、温度等水质检测设施设备，能够满足水质处理的要求。</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_38}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="51" align="center" valign="middle" class="tableLine" style="text-align: center">合计</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_79}</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_39}</td>
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
          
            <p><span style="margin-right:200px">得分：${dto.option_40}</span><span>检查时间：${dto.option_42}</span><p/>
            <p>标化分：${dto.option_41}<p/>
            <p> 
            	<span style="margin-right:148px">陪同检查人：
	            <c:if test="${not empty dto.option_45}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_45}" width="50px" height="50px" />
	      		</c:if> 
	      		</span>
	      		<span>
	      		监督员：
	      		<c:if test="${not empty dto.option_46}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_46}" width="50px" height="50px" />
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
