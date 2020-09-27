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
          	<span style="text-align:center;font-size:30px"><strong > 国境口岸食品销售单位卫生许可现场审查表(一)</strong></span>
          </td>
        </tr>
        <tr>
          <td style="text-align:center;">
          	<span>（ 适用于一般食品销售单位）</span><br>
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
  <td rowspan="6" height="117" style="text-align: center" valign="middle" class="tableLine">建筑与布局<br/>（22分）
</td>
  <td align="center" class="tableLine">1.必须远离污染源，距离暴露垃圾堆（场）、坑式厕所、粪池25米以上，环境整洁</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_1}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="6" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_91'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_91'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>
</tr>
<tr>
  <td align="center" class="tableLine">2.与经营的食品品种、数量相适应的场所</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_2}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">3.地面以耐磨防滑、不渗水、易清洗材料铺设</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_3}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">4.墙壁采用浅色、无毒、不渗水材料覆涂</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_4}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">5.天花板用防霉涂料覆涂</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_5}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">6.具有合理的设备布局和工艺流程，避免交叉污染</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_6}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="7" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">食品贮存</p>
（14分）</td>
  <td height="103" align="center" class="tableLine">7.食品存放设专门区域</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_7}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="7" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_92'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_92'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td> 
</tr>
<tr>
  <td align="center" class="tableLine">8.不得与有毒有害物品同库存放</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_8}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">9.设隔离地面的平台和层架</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_9}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">10.除冷库外，应有良好通风、排气设施</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_10}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">11.有足够数量的冰箱（柜）</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_11}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">12.满足生熟分开存放的要求</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_12}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">13.冷藏库（冰箱）有温度显示装置</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_13}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td rowspan="7" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">卫生设施</p>
（47分）</td>
  <td align="center" class="tableLine">14.未使用空调的场所，应配备纱门、纱窗或者塑料门帘</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_14}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="7" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_93'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_93'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td>  
</tr>
<tr>
  <td align="center" class="tableLine">15.木门下端装有金属防鼠板</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_15}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">16.下水道出口处有金属隔栅</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_16}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">17.设从业人员更衣室（场所）、更衣柜</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_17}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">18.设有洗手消毒设施</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_18}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">19.卫生间不能设置于经营场所内</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_19}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">20.各场所设置密闭的废弃物盛放容器</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_20}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">用水</p></td>
  <td align="center" class="tableLine">21.水源充足，水质符合国家《生活饮用水卫生标准》、二次供水有完善的水源卫生防护设施</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_21}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_94'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_94'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td> 
</tr>

<tr>
  <td rowspan="6" align="center" valign="middle" class="tableLine" style="text-align: center"><p align="center">熟食制品销售<br/>（有现场加工操作）
（12分）
</p></td>
  <td align="center" class="tableLine">22.为独立隔间，入口处设预进间或入口处设更衣、洗手消毒设施</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_22}</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td style="text-align:center" class="tableLine" rowspan="6" width="80px">
    <c:forEach items="${volist}" var="items" varStatus="aa">
    	<c:if test="${items.file_type == 1 && items.proc_type == 'V_PT_H_L_95'}">
    		<a href="#" onclick="toImgDetail('${items.file_name}')">查看图片</a><br/>
    	</c:if>
    	<c:if test="${items.file_type == 2 && items.proc_type == 'V_PT_H_L_95'}">
    		<a href="#" onclick="showVideo('${items.file_name}')" >查看视频</a><br/>
    	</c:if>
    </c:forEach>
  </td> 
</tr>
<tr>
  <td align="center" class="tableLine">23.配备充足有效的空气消毒装置</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_23}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">24.配备食品冷藏设施</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_24}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">25.配备专用工具</td>
  <td align="center" class="tableLine" style="text-align: center">※</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_25}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">26.采用非手动式的水龙头</td>
  <td align="center" class="tableLine" style="text-align: center">2</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_26}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td align="center" class="tableLine">27.设有能够开合的食品输送窗</td>
  <td align="center" class="tableLine" style="text-align: center">5</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_27}</td>
  <td align="center" class="tableLine">&nbsp;</td>
</tr>
<tr>
  <td height="51" align="center" valign="middle" class="tableLine" style="text-align: center">合计</td>
  <td align="center" class="tableLine">&nbsp;</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_79}</td>
  <td align="center" class="tableLine" style="text-align: center">${dto.option_28}</td>
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
         
            <p><span style="margin-right:200px">得分：${dto.option_29}</span><span>检查时间：${dto.option_31}</span><p/>
            <p>标化分：${dto.option_30}<p/>
            <p> 
            	<span style="margin-right:148px">陪同检查人：
	            <c:if test="${not empty dto.option_34}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_34}" width="50px" height="50px" />
	      		</c:if> 
	      		</span>
	      		<span>
	      		监督员：
	      		<c:if test="${not empty dto.option_35}">
	      			<img src="/ciqs/showVideo?imgPath=${dto.option_35}" width="50px" height="50px" />
	      		</c:if>  
	      		</span>           
      		<p/>
       
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
