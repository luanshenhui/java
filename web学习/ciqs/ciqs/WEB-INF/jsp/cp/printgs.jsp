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
          	<span style="text-align:center;font-size:30px"><strong > 国境口岸饮用水供应单位卫生许可现场审查表</strong></span>
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
  <td rowspan="2" height="117" style="text-align: center" valign="middle" class="tableLine">建筑布局</td>
  <td align="center" class="tableLine">1.供水设施必须远离污染源，周围 10m以内没有渗水坑和污染源，周围 2m内没有污水管线及污染物，环境整洁</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_1}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="2" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_103'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_103'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">2.二次供水设施与城镇公共供水管网不直接连通,在特殊情况下需连通时设置不承压水箱</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_2}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="7" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">卫生要求 </p>
（20分）</td>
  <td height="103" align="center" class="tableLine">2.设置与食品供应方式和品种相适应的粗加工、切配、烹饪、面点制作、餐用具清洗消毒、备餐等加工操作场所，以及食品库房、更衣室、清洁工具存放场所等。各场所均设在室内。</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_2}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="7" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_104'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_104'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">3.集中式供水必须有水质消毒设备</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_3}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">4.具备感官指标和余氯、PH值等常用理化指标检测能力</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_4}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">5.水质符合国家生活饮用水卫生标准</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_5}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">6.供水设备运转正常</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_6}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">7.供水设备按照规定的期限清洗、消毒</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_7}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">8.与生活饮用水直接接触的供水设备及用品，应符合国家相关产品标准，具有卫生许可批件，无毒无害，不得污染水源</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_8}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="4" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">生活饮用水水箱</p>
（25分）</td>
  <td align="center" class="tableLine">9.生活饮用水水箱专用，与非饮用水不相通</td>
  <td align="center" class="tableLine" style="text-align: center">10</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_9}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="4" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_105'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_105'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">10.生活饮用水水箱安全密闭</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_10}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">11.生活饮用水水箱有必要的卫生防护设施</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_11}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">12.符合《二次供水设施卫生规范》要求</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_12}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="3" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">加水车、船（15分） </p></td>
  <td align="center" class="tableLine">13.数量满足经营需求</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_13}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="3" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_106'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_106'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">14.未用作其他用途</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_14}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">15.材质和内壁涂料无毒无害，不影响水的感观性状</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_15}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="2" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">自备水源</p>
（10分）</td>
  <td align="center" class="tableLine">16.自备水源供水设施与城镇公共供水管网无连接</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_16}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td rowspan="2" style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_107'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_107'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">17.符合《生活饮用水集中式供水单位卫生规范》卫生要求</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_17}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>

<tr>
  <td height="51" align="center" valign="middle" class="tableLine" style="text-align: center">合计</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_79}</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_18}</td>
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
         
            <p><span style="margin-right:200px">得分：${dto.option_19}</span><span>检查时间：${dto.option_21}</span><p/>
            <p>标化分：${dto.option_20}<p/>
            <p> 
            	<span style="margin-right:148px">陪同检查人：
	            <c:if test="${not empty dto.option_24}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_24}" width="50px" height="50px" />
	      		</c:if> 
	      		</span>
	      		<span>
	      		监督员：
	      		<c:if test="${not empty dto.option_25}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_25}" width="50px" height="50px" />
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
