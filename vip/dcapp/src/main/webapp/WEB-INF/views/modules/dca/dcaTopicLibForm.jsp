<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>主题库管理管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				rules: {
					topicName: {remote: "${ctx}/dca/dcaTopicLib/checkTopicName?oldTopicName=" + encodeURIComponent('${dcaTopicLib.topicName}')}
				},
				messages: {
					topicName: {remote: "主题库名称已存在"}
				},
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			// 字符验证
			
			jQuery.validator.addMethod("topicName", function(value, element) {
				return this.optional(element) || /^[\u0391-\uFFE5\w]+$/.test(value);
			   
			}, "主题库名称只能包括中文字、英文字母、数字和下划线");
		});
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/dca/dcaTopicLib/">主题库管理列表</a></li>
		<li class="active"><a href="${ctx}/dca/dcaTopicLib/form?id=${dcaTopicLib.id}">主题库管理<shiro:hasPermission name="dca:dcaTopicLib:edit">${not empty dcaTopicLib.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="dca:dcaTopicLib:edit">查看</shiro:lacksPermission></a></li>
	</ul> --%>
	<br/>
	<form:form id="inputForm" modelAttribute="dcaTopicLib" action="${ctx}/dca/dcaTopicLib/save" method="post" class="form-horizontal span12">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label font-normal">主题库名称：</label>
			<div class="controls">
			
				<input id="oldTopicName" name="oldTopicName" type="hidden"  value="${dcaTopicLib.topicName}" htmlEscape="true">
				<%-- 编辑--%>
				<c:if test='${not empty dcaTopicLib.id}'>
				<form:input path="topicName" htmlEscape="true" maxlength="30" class="input-xlarge required topicName" disabled="true"/>
				<form:hidden path="topicName"/>
				</c:if>
				<%-- 新建--%>
				<c:if test='${empty dcaTopicLib.id}'>
				<form:input path="topicName" htmlEscape="true" maxlength="30" class="input-xlarge required topicName" disabled="false"/>
				</c:if>
				<%-- <form:input path="topicNamedisplay" htmlEscape="true" maxlength="30" class="input-xlarge required topicName" readonly="${not empty dcaTopicLib.id?'true':'false'}" disabled="${not empty dcaTopicLib.id?'true':'false'}"/>
				<form:hidden path="topicName"/> --%>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">是否启用：</label>
			<div class="controls">
				<form:radiobuttons path="isShow" items="${fns:getDictList('yes_no')}"  itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label font-normal">说明：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="true" rows="4" maxlength="60" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="dca:dcaTopicLib:edit"><button id="btnSubmit" class="btn-s btn-opear" type="submit" value="">保 存</button>&nbsp;</shiro:hasPermission>
			<button id="btnCancel" class="btn btn-s btn-opear" type="button" value="" onclick="history.go(-1)">返 回</button>
		</div>
	</form:form>
</body>
</html>