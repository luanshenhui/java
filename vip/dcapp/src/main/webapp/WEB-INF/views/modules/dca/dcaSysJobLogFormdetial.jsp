<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>数据加载执行详细</title>
	<dca:resources />
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/sysJobLogFormdetial.css" />
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
		
		<li class="active"><a href="${ctx}/dca/dcaSysJobLog/showdetial?id=${dcaSysJobLog.channelid}"><shiro:hasPermission name="dca:dcaSysJobLog:view">查看详细</shiro:hasPermission></a></li>
	</ul><br/> --%>
	<sys:message content="${message}"/>
	<h6 class="span8 font-normal">数据加载执行详细</h6><br/>

	<div class="container">
	<ul class="unstyled inline list span12">
	<c:forEach items="${page}" var="dcaSysJobLog">
		<li><fmt:formatDate value="${dcaSysJobLog.date}" pattern="yyyy-MM-dd HH:mm:ss"/></li>
		<li><c:out value="${dcaSysJobLog.stepname}"></c:out></li>
		<li>
		<c:choose>
				<c:when test="${dcaSysJobLog.itemerror == 0}">
					<c:out value="执行成功"></c:out>
				</c:when>
				<c:otherwise>
					<c:out value="执行失败"></c:out>
				</c:otherwise>
				</c:choose>
		</li>
		<br />
	</c:forEach>
	<c:if test="${empty page}">
	<li class="remind-info font-normal">没有符合条件的详细信息。</li>
	</c:if>
	</ul>
	
		<button id="btnCancel" class="btn pull-right btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)">返 回</button>
	</div>
</body>
</html>