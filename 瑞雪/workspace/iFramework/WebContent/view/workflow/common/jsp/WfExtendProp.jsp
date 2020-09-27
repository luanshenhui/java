<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ page import="com.dhc.workflow.model.define.RelateData"%>
<%@ taglib uri="/WEB-INF/tlds/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tlds/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String extendPropStr = java.net.URLDecoder.decode(request.getParameter("extendProp"), "utf-8");
	String setComId = request.getParameter("setComId");
%>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
<html>
<head>
<title>扩展属性设置</title>
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

<script type="text/javascript">
	var setComId = "<%=setComId%>";

	/*
     *主要思想：
	 *1>将原有的TABLE中的THEAD元素复制一份放在一个新的DIV(fixedheadwrap)中
	 *2>设置这个fixedheadwrap为绝对位于原来的TABLE的THEAD位置
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
		jQuery("#tbExtendProp").FixedHead({
			tableLayout : "fixed"
		});
	});
</script>
</head>
<body class="popUp-body">
	<div class="main_label_outline mt15" style="align: center;">
		<table class="main_button" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left">
				<input class="popUp-button" id="btnAddExtendProp" type="button"
					value="添加" onClick="WfExtendProp.addRow()" /> 
				<input class="popUp-button" id="btnDeleteExtendProp" type="button"
					value="删除" onClick="WfExtendProp.deleteRow()" /></td>
			</tr>
		</table>

		<div
			style="height: 252px; width: 100%; overflow: auto; align: center;">
			<table id="tbExtendProp" border="1" cellspacing="1" cellpadding="1"
				style="width: 500px; border:1px;border-color:ffffff;">
				<thead>
					<tr>
						<th style="width: 5%;"></th>
						<th style="width: 30%;">名称</th>
						<th style="width: 65%;">取值</th>
					</tr>
				</thead>
				<tbody id="tbody">

					<%
						if (extendPropStr != null && !"".equals(extendPropStr)) {
							String[] ExtendProps = extendPropStr.split(";");
							String[] tempString;
							String propKey = "";
							String propValue = "";
							for (String string : ExtendProps) {
								tempString = string.split(",");
								propKey = tempString[0];
								if(tempString.length>1){
									propValue = tempString[1];
								}else{
									propValue="";
								}
					%>
					<tr>
						<td align="center"><input type="checkbox"></td>
						<td ondblclick="WfExtendProp.editTd_key(this)"><%=propKey%></td>
						<td ondblclick="WfExtendProp.editTd_val(this)"><%=propValue%></td>
					</tr>
					<%
						}
						} else {
					%>
					<tr>
						<td align="center"><input type="checkbox"></td>
						<td ondblclick="WfExtendProp.editTd_key(this)">name</td>
						<td ondblclick="WfExtendProp.editTd_val(this)">value</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<div id="editTxtHolder" style="display: none;">
				<input type="text" id="editTxt_key" name="editTxt_key" class="popUp-edit"
					onblur="WfExtendProp.blurTxt_key(this)" style="width:100%;height:20px;"/> <input
					type="text" id="editTxt_val" name="editTxt_val" class="popUp-edit"
					onblur="WfExtendProp.blurTxt_val(this)" style="width:100%;height:20px;"/>
			</div>
		</div>
		<table width="100%" class="popUp-buttonBox" cellpadding="0"
			cellspacing="0">
			<tr>
				<td><input class="popUp-button" type="button" value="取消"
					class="button_normal" onclick="javascript:window.close()" /> <input
					class="popUp-button" type="button" value="提交" class="button_normal"
					onclick="WfExtendProp.submitData()" /></td>
			</tr>
		</table>
	</div>
</body>
</html>

<script type="text/javascript"
	src="<%=webpath%>/view/workflow/common/script/js/WfExtendProp.js"></script>