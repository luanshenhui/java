<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>查看日志</title>
	<dca:resources />
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/sysJobLogForm.css" />
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
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
		});
		
	</script>
</head>
<body>

	<%-- <ul class="nav nav-tabs">
		
		<li class="active"><a href="${ctx}/dca/dcaSysJobLog/show?id=${dcaSysJobLog.idJob}"><shiro:hasPermission name="dca:dcaSysJobLog:view">查看日志</shiro:hasPermission></a></li>
	</ul><br/> --%>
	<sys:message content="${message}"/>
	<h6 class="span8 font-normal">执行结果</h6><br/>
	
	<div class="container">
	<p class="text-style span12"><c:out value="${dcaSysJobLog.logField}"></c:out></p>
	
		<button id="btnCancel" class="btn pull-right btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)">返 回</button>
	</div>
</body>
</html>