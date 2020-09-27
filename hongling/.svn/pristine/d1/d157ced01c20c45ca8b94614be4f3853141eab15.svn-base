<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="../repair/orderOne.js">
</script>
<div>
	<div id="search" class="list_search">
		<h1>返修报表查询</h1>
		<s:label>品类名称</s:label>
		<select id="searchKeyword" name="searchKeyword" ></select>
		<%-- <s:textfield id="searchKeyword" name="searchKeyword"></s:textfield> --%>
		<s:label>查询时间点</s:label>
		<input type="text" id="dealDate" class="date"/>
		<%-- <s:label value="%{getText('lblDealDate')}"></s:label>
		<input type="text" id="dealDate" class="date"/>
		<input type="text" id="dealToDate" class="date"/> --%>
		<a href="javascript:void(0);" id="btnQuery">查询</a>
		<a href="javascript:void(0);" id="exportOn">导出</a>
	</div>
	<div id="OrderOneResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="OrderOneStatistic" class="pagingleft"></div>
	<div id="OrderOnePagination" class="paging"></div>
	<textarea id="OrderOneTemplate" class="list_template" >
		<div style=" overflow:scroll; width:1000px; height:600px;">
			
				<table width="2400" align="center" border="1" cellpadding="0" cellspacing="0" class="list_result">
			      <tr align="center">
			        <td width="72" rowspan="2">品类名称</td>
			        <td width="216" colspan="3">下单数量</td>
			        <td width="1728" colspan="24">返修数量</td>
			        <td width="216" colspan="3">返修率</td>
			      </tr>
			      <tr align="center">
			        <td width="72" rowspan="2">年下单量</td>
			        <td width="72" rowspan="2">月下单量</td>
			        <td width="72" rowspan="2">日下单量</td>
			        <td width="576" colspan="8">年返修量</td>
			        <td width="576" colspan="8">月返修量</td>
			        <td width="576" colspan="8">日返修量</td>
			        <td width="72">年返修率</td>
			        <td width="72">月返修率</td>
			        <td width="72">日返修率</td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        <td ></td>
			        
			        
			      </tr>
			      <tr align="center">
			        <td width="72">　</td>
			        <td width="72">尺寸原因</td>
			        <td width="72">做工原因</td>
			        <td width="72">版型原因</td>
			        <td width="72">面辅料原因</td>
			        <td width="72">更改款式</td>
			        <td width="72">更改工艺</td>
			        <td width="72">顾客原因</td>
			        <td width="72">更改附件及配色料</td>
			        <td width="72">尺寸原因</td>
			        <td width="72">做工原因</td>
			        <td width="72">版型原因</td>
			        <td width="72">面辅料原因</td>
			        <td width="72">更改款式</td>
			        <td width="72">更改工艺</td>
			        <td width="72">顾客原因</td>
			        <td width="72">更改附件及配色料</td>
			        <td width="72">尺寸原因</td>
			        <td width="72">做工原因</td>
			        <td width="72">版型原因</td>
			        <td width="72">面辅料原因</td>
			        <td width="72">更改款式</td>
			        <td width="72">更改工艺</td>
			        <td width="72">顾客原因</td>
			        <td width="72">更改附件及配色料</td>
			        <td width="72">　</td>
			        <td width="72">　</td>
			        <td width="72">　</td>
			      </tr>
			      {#foreach $T.data as row}
			      <tr>
			      	<td width="72" class="center">{$T.row.userName}</td>
			      	<td width="72" class="center">{$T.row.nianXiadan}</td>
			      	<td width="72" class="center">{$T.row.yueXiadan}</td>
			      	<td width="72" class="center">{$T.row.riXiadan}</td>
			      	<td width="72" class="center">{$T.row.nianRepairchicun}</td>
			      	<td width="72" class="center">{$T.row.nianRepairzuogong}</td>
			      	<td width="72" class="center">{$T.row.nianRepairbanxing}</td>
			      	<td width="72" class="center">{$T.row.nianRepairmianfuliao}</td>
			      	<td width="72" class="center">{$T.row.nianRepairgenggaiks}</td>
			      	<td width="72" class="center">{$T.row.nianRepairgenggaigy}</td>
			      	<td width="72" class="center">{$T.row.nianRepairgukeyy}</td>
			      	<td width="72" class="center">{$T.row.nianRepairgenggaifjjpsl}</td>
			      	<td width="72" class="center">{$T.row.yueRepairchicun}</td>
			      	<td width="72" class="center">{$T.row.yueRepairzuogong}</td>
			      	<td width="72" class="center">{$T.row.yueRepairbanxing}</td>
			      	<td width="72" class="center">{$T.row.yueRepairmianfuliao}</td>
			      	<td width="72" class="center">{$T.row.yueRepairgenggaiks}</td>
			      	<td width="72" class="center">{$T.row.yueRepairgenggaigy}</td>
			      	<td width="72" class="center">{$T.row.yueRepairgukeyy}</td>
			      	<td width="72" class="center">{$T.row.yueRepairgenggaifjjpsl}</td>
			      	<td width="72" class="center">{$T.row.riRepairchicun}</td>
			      	<td width="72" class="center">{$T.row.riRepairzuogong}</td>
			      	<td width="72" class="center">{$T.row.riRepairbanxing}</td>
			      	<td width="72" class="center">{$T.row.riRepairmianfuliao}</td>
			      	<td width="72" class="center">{$T.row.riRepairgenggaiks}</td>
			      	<td width="72" class="center">{$T.row.riRepairgenggaigy}</td>
			      	<td width="72" class="center">{$T.row.riRepairgukeyy}</td>
			      	<td width="72" class="center">{$T.row.riRepairgenggaifjjpsl}</td>
			      	<td width="72" class="center">{$T.row.nianRepairlv}%</td>
			      	<td width="72" class="center">{$T.row.yueRepairlv}%</td>
			      	<td width="72" class="center">{$T.row.riRepairlv}%</td>
			      </tr>
			      {#/for}
			    </table>  
	    </div>
    </textarea> 
</div>