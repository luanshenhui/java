<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/common/resource_show.jsp"%>

<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<!--   	<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link> -->
<!--   	<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script> -->
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
</head>
<body class="bg-gary">
	<table>
		<tr>
			<c:forEach items="${listphone}" var="row" varStatus="status">
				<td>
					<div align="center">${row.id}</div>
					<div class="row">
						<div class="col-sm-8 col-md-6">
							<div class="docs-galley">
								<ul class="docs-pictures clearfix">
									<li><img width="120px" height="60px"
										data-original="${ctx}/web/getImage?id=${row.id}"
										src="${ctx}/web/getImage?id=${row.id}" alt="Cuo Na Lake"></li>
								</ul>
							</div>
						</div>
					</div>
				</td>
				<c:if test="${status.count%10==0}">
		</tr>
		<tr>
			</c:if>
			</c:forEach>
		</tr>
	</table>

</body>
</html>
