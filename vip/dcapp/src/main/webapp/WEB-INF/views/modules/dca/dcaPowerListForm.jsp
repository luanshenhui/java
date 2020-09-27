<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>权责清单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({				
				submitHandler: function(form){
					// 判断风险名称是否重复
					$.get(ctx+'/dca/dcaPowerList/check', {bizRoleName : $("#bizRoleName").val().trim(), powerId:$('#powerId').val().trim(),uuid:$('#uuid').val()}, function (res) {					
						// 名称已存在
						if (res=="false"){
							alertx("业务角色名称和权力名称同时存在，请重新输入！");
							return false;
						}else{
							loading('正在提交，请稍等...');
							form.submit();
						}
					});
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
		});
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/dca/dcaPowerList/">权责清单列表</a></li>
		<li class="active"><a href="${ctx}/dca/dcaPowerList/form?id=${dcaPowerList.id}">权责清单<shiro:hasPermission name="dca:dcaPowerList:edit">${not empty dcaPowerList.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="dca:dcaPowerList:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/> --%>
	<form:form id="inputForm" modelAttribute="dcaPowerList" action="${ctx}/dca/dcaPowerList/save" method="post" class="form-horizontal span12">
		<form:hidden path="id"/>
		<input type="hidden" id="uuid" value="${dcaPowerList.uuid}">
		<sys:message content="${message}"/>		
		
		<div class="control-group">
			<label class="control-label">业务角色名称：</label>
			<div class="controls">
				<c:if test="${not empty dcaPowerList.id}">
					<form:input path="bizRoleName" htmlEscape="true" maxlength="30" cssClass="required" disabled="true" />
					<form:hidden path="bizRoleName" />
				</c:if>
				<c:if test="${empty dcaPowerList.id}">
					<form:input path="bizRoleName" htmlEscape="true" maxlength="30" cssClass="required" />
				</c:if>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group ">
			<label class="control-label">权力：</label>
			<div class="controls">
				<c:if test="${not empty dcaPowerList.id}">
					<form:input path="" htmlEscape="false" class="input-xlarge required" disabled="true" value="${fns:getDictLabel(dcaPowerList.powerId,'power_id','') }"/>
					<form:hidden path="powerId"/>
				</c:if>
				<c:if test="${empty dcaPowerList.id}">
					<form:select path="powerId" class="input-xlarge required" disabled="disabled">
						<form:option value="" label="请选择"/>
						<form:options items="${fns:getDictList('power_id')}" itemLabel="label" itemValue="value" htmlEscape="true"/>
					</form:select>
				</c:if>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联岗位：</label>
			<div class="controls">
				<c:if test="${empty dcaPowerList.uuid}">
					<!-- 新建-->
					<sys:treeselect id="remarks" name="remarks" value="${dcaPowerList.remarks}" labelName="name" labelValue="${dcaPowerList.name}"
					title="岗位" url="/sys/dcaTraceUserRole/treeData" cssClass="required" allowClear="true"  dataMsgRequired="必填信息"
					notAllowSelectParent="false" checked="true" />
				</c:if>
				<!-- 修改-->
				<c:if test="${not empty dcaPowerList.uuid}">
					<c:if test="${not empty dcaPowerList.flag}">
						<sys:treeselect id="remarks" name="remarks" value="${dcaPowerList.remarks}" labelName="name" labelValue="${dcaPowerList.name}"
							title="岗位" url="/sys/dcaTraceUserRole/treeData" cssClass="required" allowClear="true" dataMsgRequired="必填信息"
							notAllowSelectParent="false" checked="true" treeNodeIsDisabled="true"/>
					</c:if>
					<c:if test="${empty dcaPowerList.flag}">
						<sys:treeselect id="remarks" name="remarks" value="${dcaPowerList.remarks}" labelName="name" labelValue="${dcaPowerList.name}"
							title="岗位" url="/sys/dcaTraceUserRole/treeData" cssClass="required" allowClear="true" dataMsgRequired="必填信息"
							notAllowSelectParent="false" checked="true"/>
					</c:if>
				</c:if>
				<span class="help-inline" ><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">设定依据：</label>
			<div class="controls">
				<form:textarea path="accord" htmlEscape="true" maxlength="500" cssClass="required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">责任事项：</label>
			<div class="controls">
				<form:textarea path="duty" htmlEscape="true" maxlength="100" cssClass="required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="dca:dcaPowerList:edit"><input id="btnSubmit" class="btn-s btn-opear" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>