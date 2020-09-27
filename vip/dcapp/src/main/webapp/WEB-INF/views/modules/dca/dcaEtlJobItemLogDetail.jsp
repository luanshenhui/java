<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>物理表更新履历</title>
	<dca:resources />
	<link type="text/css" rel="stylesheet" href="/assets/dca/css/dcaEtlJobItemLog.css" />
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>
<body>
	<sys:message content="${message}"/>
	<h6 class="span8 font-normal">物理表更新履历</h6><br/>
	
	<div class="container">
		<ul class="unstyled inline list span12">
			<c:forEach items="${detailList}" var="item">
				<li><fmt:formatDate value="${item.logDate}" pattern="yyyy-MM-dd HH:mm:ss"/></li>
				<li class="pd-left-30">
					<c:choose>
						<c:when test="${item.result == 1}">
							<c:out value="执行成功"></c:out>
						</c:when>
						<c:otherwise>
							<c:out value="执行失败"></c:out>
						</c:otherwise>
					</c:choose>
				</li>
				<br />
			</c:forEach>
			<c:if test="${empty detailList}">
				<li class="remind-info font-normal">没有符合条件的详细信息。</li>
			</c:if>
		</ul>
		<button id="btnCancel" class="btn pull-right btn-s btn-opear" type="button" value="返 回" onclick="history.go(-1)">返 回</button>
	</div>
</body>
</html>