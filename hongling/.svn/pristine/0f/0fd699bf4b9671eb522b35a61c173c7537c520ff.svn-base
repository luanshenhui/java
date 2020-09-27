<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script type='text/javascript' src='<%=request.getContextPath() %>/scripts/jquery/chart/highcharts.js'></script>
<script type='text/javascript' src='<%=request.getContextPath() %>/scripts/jquery/chart/exporting.js'></script>
<script language="javascript" src="<%=request.getContextPath() %>/pages/orden/statisticjsp.js"></script>
<div id="orden_statistic_form" class="list_search">
	<h1><s:text name="orden_statistic_form"></s:text></h1>
	<s:text name="blLblMoneyKind"></s:text><select id="moneySignID" style="width:60px;"></select>
	<s:text name="lblAccount"></s:text><select id="memberID" name="memberID"></select>
	<s:text name="lblStatus"></s:text><select id="ordenStatusID" name="ordenStatusID"></select>
	<input type="text" id="fromStatisticDate" onFocus="var toStatisticDate=$dp.$('toStatisticDate');WdatePicker({onpicked:function(){toStatisticDate.focus();},maxDate:'#F{$dp.$D(\'toStatisticDate\')}'})"/>
	<input type="text" id="toStatisticDate"  onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'fromStatisticDate\',{M:1});}'})"/>
	<a id="btnStatistic"><s:text name="btnStatistic"></s:text></a>
	<a id="btnExportStatistic"><s:text name="btnExportOrdens"></s:text></a>
	<div id="statistic_grid"></div>
	<div id="statistic_chart"></div>
</div>