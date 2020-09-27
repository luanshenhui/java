<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>风险矩阵</title>
	<meta name="decorator" content="default"/>
	<dca:resources/> 
	<script src="/assets/dca/js/jquery.risktypedetailList.js" type="text/javascript"></script>
</head>
<body>	
<div id="RisktypedetailList">
	<form:form id="inputForm" modelAttribute="dictList" action="" method="post" class="form-horizontal">
		<table id="contentTable2" class="table table-striped table-bordered table-condensed" >
		<thead>
			<tr>
				<td>风险类型\风险登记</td>
				<c:forEach items="${titleList}" var="titleList" >
				<td>${titleList.label}</td>
				</c:forEach>
            </tr>
        </thead>
		<tbody id="tvalue">
			<c:forEach items="${dictList}" var="dictList">
				<tr>
					<c:forEach items="${dictList}" var="info" varStatus="status">
						<c:if test="${status.index == '0'}">
							<td>${info}</td>
						</c:if>
						<c:if test="${status.index != '0'}">
							<td><input type="text" id="${info}" maxlength="7" value=""><font color="red" title="输入正数，小数点前最多4位，小数点后最多2位">*</font></td>
						</c:if>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
		</table>	
		<div class="form-actions form-padding">
		<shiro:hasPermission name="dca:risktypedetail:save">
			<input id="btnSubmit" class="btn-s btn-opear" type="button" value="保 存"/>&nbsp;
		</shiro:hasPermission>
			<input id="btnCancel" class="btn-s btn-opear" type="button" onclick="window.location.reload()" value="取消"/>&nbsp;
		</div>
	</form:form>
</div>	
</body>
</html>