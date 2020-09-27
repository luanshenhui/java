<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="../repair/orderTwo.js"></script>
<div>
	<div id="search" class="list_search">
    <h1>利润中心数据报表—品类、客户</h1>
 	<s:label>服装分类</s:label>
    <select id="searchClothingID" name="searchClothingID" ></select>
  	<s:label>客户名称：</s:label>
  	<input id="memberName" name="memberName" type="text" />
 	<s:label>查询时间点</s:label>
	<input type="text" id="dealDate" class="date"/>
  	<a href="javascript:void(0);" id="btnQuery">查询</a>
  	<a href="javascript:void(0);" id="exportOntwo" >导出</a>
  	</div>
   	<div id="OrderTwoResult"></div>
	<div id="overdue" style="display:none;"></div>
	<div id="OrderTwoStatistic" class="pagingleft"></div>
	<div id="OrderTwoPagination" class="paging"></div>
	<div style="overflow:scroll; width:1000px; height:600px;"> 
	<textarea id="OrderTwoTemplate" class="list_template">
		<div style="overflow:scroll; width:1000px; height:600px;"> 
	    <table class="list_result">
	      <tr align="center">
	        <td width="72" rowspan="3">品类</td>
	        <td width="72" rowspan="3">客户简称</td>
	        <td width="72" rowspan="3">客户名称</td>
	        <td width="216" colspan="3">下单数量</td>
	        <td width="250" colspan="3">返修扣款</td>
	        <td width="1728" colspan="24">返修数量</td>
	      </tr>
	      <tr align="center">
	        <td rowspan="2" width="72">日累计量</td>
	        <td rowspan="2" width="72">月累计量</td>
	        <td rowspan="2" width="72">年下单量</td>
	        <td rowspan="2" width="77">年累计扣款</td>
	        <td rowspan="2" width="91">月累计量扣款</td>
	        <td rowspan="2" width="77">日累计扣款</td>
	        <td width="576" colspan="8">年返修量</td>
			<td width="576" colspan="8">月返修量</td>
			<td width="576" colspan="8">日返修量</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
	      </tr>
	      <tr align="center">
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
	      </tr>
	       {#foreach $T.data as row} 
	      <tr>
	     	<td class="center">{$T.row[2]}</td><!-- 品类 -->
	     	<td class="center">{$T.row[0]}</td><!-- 客户简称 -->
	     	<td class="center">{$T.row[1]}</td><!-- 客户名称 -->
	     	<td class="center">{$T.row[3]}</td><!-- 年累计量 -->
	     	<td class="center">{$T.row[4]}</td><!-- 月累计量 -->
	     	<td class="center">{$T.row[5]}</td><!-- 日下单量 -->
	     	<td class="center">{$T.row[6]}</td><!-- 年累计扣款 -->
	     	<td class="center">{$T.row[7]}</td><!-- 月累计扣款 -->
	     	<td class="center">{$T.row[8]}</td><!-- 年累计扣款 -->
	     	
	     	<!-- 年返修 -->
	     	<td class="center">{$T.row[9]}</td><!-- 尺寸 -->
	     	<td class="center">{$T.row[10]}</td><!-- 做工 -->
	     	<td class="center">{$T.row[11]}</td><!-- 版型 -->
	     	<td class="center">{$T.row[12]}</td><!-- 面辅料 -->
	     	<td class="center">{$T.row[13]}</td><!-- 更改款式 -->
	     	<td class="center">{$T.row[14]}</td><!-- 更改工艺 -->
	     	<td class="center">{$T.row[15]}</td><!-- 顾客原因 -->
	     	<td class="center">{$T.row[16]}</td><!-- 更改附件及配色料 -->	
	     	
	     	<!-- 月返修 -->
	     	<td class="center">{$T.row[17]}</td><!-- 尺寸 -->
	     	<td class="center">{$T.row[18]}</td><!-- 做工 -->
	     	<td class="center">{$T.row[19]}</td><!-- 版型 -->
	     	<td class="center">{$T.row[20]}</td><!-- 面辅料 -->
	     	<td class="center">{$T.row[21]}</td><!-- 更改款式 -->
	     	<td class="center">{$T.row[22]}</td><!-- 更改工艺 -->
	     	<td class="center">{$T.row[23]}</td><!-- 顾客原因 -->
	     	<td class="center">{$T.row[24]}</td><!-- 更改附件及配色料 -->
	     
	     	<!-- 日返修 -->
	     	<td class="center">{$T.row[25]}</td><!-- 尺寸 -->
	     	<td class="center">{$T.row[26]}</td><!-- 做工 -->
	     	<td class="center">{$T.row[27]}</td><!-- 版型 -->
	     	<td class="center">{$T.row[28]}</td><!-- 面辅料 -->
	     	<td class="center">{$T.row[29]}</td><!-- 更改款式 -->
	     	<td class="center">{$T.row[30]}</td><!-- 更改工艺 -->
	     	<td class="center">{$T.row[31]}</td><!-- 顾客原因 -->
	     	<td class="center">{$T.row[32]}</td><!-- 更改附件及配色料 -->	     		     	     		     			
	      </tr>
	      {#/for}
	    </table>
	    </textarea>
    </div>
</div>