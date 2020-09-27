<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ page import="com.dhc.workflow.model.define.RelateData"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	String webpath = request.getContextPath();
	List<RelateData> relDataList = (List<RelateData>) request
			.getAttribute("relateData");
	if(relDataList == null)
		relDataList = new ArrayList();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编辑相关数据</title>
<style type="text/css">
table th {
	background-color: #EFF3F4;
	height:30px;
	font-size: 14px;
	color: #656867;
}

table tbody td {
	white-space: nowrap;
	word-break: break-all;
	word-wrap: break-word;
	overflow: hidden;
	text-overflow: ellipsis;
	height: 26px;
	color:#FFFFFF;
	font-size: 14px;
	padding-left:5px;
}

table {
	width: 100%;
	border-color: #d2f1ac;
	border-collapse: collapse;
	border-top: 0px solid #ffffff;
}
</style>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />

<script type="text/javascript">
	var webpath = "<%=webpath%>";
	
	//保存编辑的结果
	function confirmWfRelateDataValue(){
		var returnString= $jQuery("input[type='text']").map(function(){
			return $jQuery(this).attr("id")+","+$jQuery(this).val();
		}).get().join(";");
		if(returnString){
			window.returnValue = returnString;
		}else{
			window.returnValue = "empty";
		}
		window.close();
	}

	function closeWin(){
		window.returnValue=null;
		window.close();
	}
</script>

<script type="text/javascript">
	/*
	主要思想：
	1>将原有的TABLE中的THEAD元素复制一份放在一个新的DIV(fixedheadwrap)中
	2>设置这个fixedheadwrap为绝对位于原来的TABLE的THEAD位置
	 */
	(function(jQuery) {
		jQuery.fn
				.extend({
					FixedHead : function(options) {
						var op = jQuery.extend({
							tableLayout : "auto"
						}, options);
						return this
								.each(function() {
									var jQuerythis = jQuery(this); //指向当前的table
									var jQuerythisParentDiv = jQuery(this)
											.parent(); //指向当前table的父级DIV，这个DIV要自己手动加上去
									jQuerythisParentDiv
											.wrap(
													"<div class='fixedtablewrap'></div>")
											.parent().css({
												"position" : "relative"
											}); //在当前table的父级DIV上，再加一个DIV
									var x = jQuerythisParentDiv.position();

									var fixedDiv = jQuery(
											"<div class='fixedheadwrap' style='clear:both;overflow:hidden;z-index:2;position:absolute;' ></div>")
											.insertBefore(jQuerythisParentDiv)
											//在当前table的父级DIV的前面加一个DIV，此DIV用来包装tabelr的表头
											.css(
													{
														"width" : jQuerythisParentDiv[0].clientWidth,
														"left" : x.left,
														"top" : x.top
													});

									var jQuerythisClone = jQuerythis
											.clone(true);
									jQuerythisClone.find("tbody").remove(); //复制一份table，并将tbody中的内容删除，这样就仅余thead，所以要求表格的表头要放在thead中
									jQuerythisClone.appendTo(fixedDiv); //将表头添加到fixedDiv中

									jQuerythis.css({
										"marginTop" : 0,
										"table-layout" : op.tableLayout
									});
									//当前TABLE的父级DIV有水平滚动条，并水平滚动时，同时滚动包装thead的DIV
									jQuerythisParentDiv
											.scroll(function() {
												fixedDiv[0].scrollLeft = jQuery(this)[0].scrollLeft;
											});

									//因为固定后的表头与原来的表格分离开了，难免会有一些宽度问题
									//下面的代码是将原来表格中每一个TD的宽度赋给新的固定表头
									var jQueryfixHeadTrs = jQuerythisClone
											.find("thead tr");
									var jQueryorginalHeadTrs = jQuerythis
											.find("thead");
									jQueryfixHeadTrs
											.each(function(indexTr) {
												var jQuerycurFixTds = jQuery(
														this).find("td");
												var jQuerycurOrgTr = jQueryorginalHeadTrs
														.find("tr:eq("
																+ indexTr + ")");
												jQuerycurFixTds
														.each(function(indexTd) {
															jQuery(this)
																	.css(
																			"width",
																			jQuerycurOrgTr
																					.find(
																							"td:eq("
																									+ indexTd
																									+ ")")
																					.width());
														});
											});
								});
					}
				});
	})(jQuery);
	jQuery(document).ready(function() {
		jQuery("#relDataTable").FixedHead({
			tableLayout : "fixed"
		});
	});
</script>
</head>

<body class="popUp-body">
	<div style="margin: 5px auto auto 5px;" class="main_label_outline">
	<div
			style="height: 240px; width: 100%; overflow: auto; align: center;">
		<table id="relDataTable" border="1" cellspacing="1" cellpadding="1"
			style="width: 500px; border: 1px; border-color: ffffff;">
			<thead>
				<tr>
					<th style="width: 35%;">相关数据名称</th>
					<th style="width: 65%;">相关数据取值</th>
				</tr>
			</thead>
			<tbody id="tbody">
			<%
			if(relDataList.size()>0){
			for (RelateData reldata : relDataList) {
			%>
			<tr>
				<td width="30%"><%=reldata.getRdataName()%></td>
				<td width="70%"><input type="text" id="<%=reldata.getRdataName()%>" name="<%=reldata.getRdataName()%>" value="<%=reldata.getDefaultValue()%>" width="80px"/></td>
			</tr>
			<%
			}}else{
				%>
			<tr>
				<td width="100%" colspan="2">未找到需要输入的相关数据，点击"确定"按钮继续创建实例！</td>
			</tr>
			<%
			}
			%>
			</tbody>
		</table>
	</div>
	<input style="text-align: left;"type="button" id="confirm" name="confirm" value="确定" onclick="confirmWfRelateDataValue()"/> 
	</div>
</body>
</html>