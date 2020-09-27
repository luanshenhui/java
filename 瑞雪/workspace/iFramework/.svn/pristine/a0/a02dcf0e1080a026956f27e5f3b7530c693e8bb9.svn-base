<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>


<html>
<head>
    <title>汇聚活动</title>	
	<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
	<script type="text/javascript"
		src="<%=webpath%>/view/workflow/wfactivity/WfMergeNode.js">
	</script>
	<script>
	var webpath = "<%=webpath%>";
	var processId  = "${param.processId}";
	var processVersion = "${param.processVersion}";
	</script>
	
</script>
</head>
<body class="popUp-body">
	<br>
	<form action="" name="mergeForm">
		<div class="main_label_outline" style="width: 570px">
			<table style="width: 550px" class="main_label_table" cellpadding="0" cellspacing="0">
				<tr style="display:none;">
					<td class="popUp-name">
						ID:
					</td>
					<td>
						<input class="w410 popUp-edit"  type="text" id="actId" name="actId" readonly="true" 
							styleClass="input_underline" value='${mergeAct.actId }'>
					</td>
				</tr>
				<tr>
					<td class="popUp-name">
						<font color="#ff0000">*</font>
						名称:
					</td>
					
					
					<td>
						<input class="w370 popUp-edit" type="text" id="actName" name="actName" styleClass="input_underline" value="${mergeAct.actName }"  />
					</td>
				<td valign="bottom">
					<a class="popUp-select" href="#" onclick="WFCommon.CopyContent2Clipboard('actId')">复制ID</a>
				</td>
				</tr>
				<tr>
					<td valign="top" class="popUp-name">
						描述:
					</td>
					<td>
						<textarea class="w410 popUp-describe" id="actDesc"  name="actDesc"   rows="5" styleClass="input_text" >${mergeAct.actDesc }</textarea>
					</td>
				</tr>
			</table>
			
			<table style="width: 550px" class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">
					汇聚类型:
					</td>
					<td> 
						<c:if test="${mergeAct.mergeType==0 || mergeAct.mergeType==null}">
							<input class="mt6 fl mr6" type="radio" id="mergeType" name="mergeType"  value="0"  checked="checked" /> 
							<span class="popUp-SName fl">与汇聚</span>
							<input class="mt6 fl mr6" type="radio" id="mergeType" name="mergeType"  value="1" /> 
							<span class="popUp-SName fl">条件汇聚</span>
						</c:if>
						<c:if test="${mergeAct.mergeType==1}">
							<input class="mt6 fl mr6" type="radio" id="mergeType" name="mergeType"  value="0" /> <span class="popUp-SName fl">与汇聚</span>
							<input class="mt6 fl mr6" type="radio" id="mergeType" name="mergeType"  value="1"   checked="checked" />
							<span class="popUp-SName fl">条件汇聚</span>
						</c:if>
								
						
					</td>
				</tr>
			</table>
			<table style="width: 550px" class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">后置条件:</td>
					<td>
						<input class="w370 popUp-edit fl" type="text" readonly="true" id="postCondition" name="postCondition" 
							 value="${mergeAct.postCondition}"/>
						<a class="popUp-select" href="#" onclick="displayConditions('postCondition');">设置</a>
					</td>
				</tr>
			</table>
			<table style="width: 550px" class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">
						扩展属性:
					</td>
					<td>
						<input class="w370 popUp-edit fl" type="text" readonly="true" id="extendProp" name="extendProp" 
							value='${mergeAct.extendProp }'/>
						<a class="popUp-select" href="#" onclick="editExtendProp()">设置</a>
					</td>
				</tr>
			</table>

		</div>
		<table class="w590 popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td style="width: 570px" align="right">
					<input class="popUp-button" type="button" value='取消'  onclick="window.close()" />
					<input class="popUp-button" type="button" id="sub" value='提交'   onclick="submit_onclick()" />					
				</td>
			</tr>
		</table>
	</form>
</body>
</html>