<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>

<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	String opFlag = request.getParameter("opFlag");
	String bizCateId = request.getParameter("bizCateId");
	String bizCateName =request.getParameter("bizCateName");
	//String bizCateName =new String(request.getParameter("bizCateName").getBytes("ISO-8859-1"),"utf8");
%>
<html>
<head>
<base target='_self'/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务分类详细信息</title>
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript"
	src="<%=webpath%>/view/common/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/workflow/wfbizcategory/WfBizCategoryDetail.js"></script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
	var opFlag = "<%=opFlag%>";
	var bizCateId = "<%=bizCateId%>";
	var bizCateName = "<%=bizCateName%>";
</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<form id="detailForm" name="detailForm">
<div style="padding:0px 0px 0px 0px">
<table class="" cellpadding="0" cellspacing="0">
	<tr>
		<td style="width: 40%">父分类名称:
		</td>
		<td style="width: 60%">
			<input type="hidden" id="txtBizCateId" name="txtBizCateId" >
			<input type="hidden"  id="txtBizCateParentId" name="txtBizCateParentId" value="<%=bizCateId %>">
			<input type="text" name="txtBizCateParentName" id="txtBizCateParentName" readonly="readonly" value="<%=bizCateName %>">
	</tr>
	<tr>
		<td style="width: 40%">分类名称:
			&nbsp;<font color="#ff0000">*</font>
		</td>
		<td style="width: 60%">
			<input type="text" name="txtBizCateName" id="txtBizCateName">
		</td>
	</tr>
	<tr>
		<td style="width: 40%">分类描述:
		</td>
		<td style="width: 60%">
			<input type="text" name="txtBizCateDesc" id="txtBizCateDesc">
		</td>
	</tr>
</table>
</div>
<input type="hidden" id="hidBizCateId" />
</form><br/>
<table class="" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right">
			<input id="btnSave" class="popUp-buttonBox" type="button" value="保存 " onclick="saveWfBizCategory()" /> 
			<input id="btnClose" class="popUp-buttonBox"  type="button" value="关闭" onClick="closeWin()" />
		</td>
	</tr>
</table>

</body>
</html>