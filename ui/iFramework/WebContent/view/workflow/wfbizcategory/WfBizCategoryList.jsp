<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务分类管理</title>
<link rel="stylesheet" href="<%=webpath%>/view/common/css/demo.css" type="text/css">
<link rel="stylesheet" href="<%=webpath%>/view/common/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.ztree.core-3.5.js"></script>

<script type="text/javascript"	src="<%=webpath%>/view/workflow/wfbizcategory/WfBizCategoryList.js"></script>
</head>
<body>
<table style="margin:0 0 0 10px" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		<form>
			<input id="btnAdd" name="btnAdd" type="button" class="jt_botton_table2" value="增加分类" onclick="addWfBizCategory()" /> 
			<input id="btnUpdate" type="button" value="编辑分类"	onclick="updateWfBizCategory()" class="jt_botton_table2"/>
			<input id="btnDel" type="button" value="删除分类"  class="jt_botton_table2" onclick="deleteWfBizCategory()" />
		</form>
		</td>
	</tr>
</table>
<div style="float:left;margin:0 0 0 10px">
	<ul id="treeDemo" class="ztree"></ul>
</div>
<div style="float:hidden;margin:0 0 0 10px">
	<iframe id="processFrame" width="800px" height="400px" src="" frameborder="0" scrolling="no" onload="setWinHeight(this)"></iframe>
</div>
<input type="hidden" id="bizCateId">
<input type="hidden" id="bizCateParentId">
<input type="hidden" id="bizCateName">
</body>
</html>