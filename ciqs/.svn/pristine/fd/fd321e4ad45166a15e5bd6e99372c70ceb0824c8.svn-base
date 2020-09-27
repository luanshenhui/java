<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生监督表查询</title>
<%@ include file="/common/resource_show.jsp"%>
<style type="text/css">
input.datepick {
	background: #FFF url(/ciqs/static/dec/images/dpn.date.pick.gif)
		no-repeat right
}

.title a:link, .title a:visited, .user-info a:link, .user-info a:visited
	{
	color: white;
	text-decoration: none;
}

.title a:active, .title a:hover, .user-info a:active, .user-info a:hover
	{
	color: #014ccc;
	text-decoration: underline;
}
</style>
<script type="text/javascript">
	function pageUtil(page) {
		$("#process_form")
				.attr("action", "/ciqs/mailSteamer/showhlthchecklist");
		$("#process_form").append(
				"<input type='hidden' name='page' value='"+page+"'/>");
		console.log($("#dec_master_id").val());
		if(document.getElementById("dec_master_id").value != null){
			$("#process_form").submit();
		}
	}
</script>
</head>

<body class="bg-gary">
	<div class="freeze_div_list">
		<div class="title-bg">
			<div class=" title-position margin-auto white">
				<div class="title">
					<a href="nav.html" class="white"><span class="font-24px">卫生监督查询</span></a>
				</div>
				<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
			</div>
		</div>
	</div>
	<div class="blank_div_list"></div>
	<div class="margin-auto width-1200 search-box">
		<form action="/ciqs/mailSteamer/showhlthchecklist" method="post"
			id="process_form">
			<table width="100%" border="0" class="table-search margin-auto">
				<tr>
					<th align="right">名称:</th>
					<td align="left"><input type="text" name="hun_name"
						class="search-input input-175px" value="${map.hun_name }" /></td>
					<th align="right">卫生监督类型:</th>
					<td align="left"><select id="tableType" name="hlth_check_type"
						class="search-input input-175px" class="required select">
							<option
								<c:if test="${map.hlth_check_type == ''}">selected="selected"</c:if>
								value="">全部</option>
							<c:if test="${not empty checkTypeList }">
								<c:forEach items="${checkTypeList}" var="row">
									<c:if test="${map.hlth_check_type == row.code}">
										<option selected="selected" value="${row.code}">${row.name}</option>
									</c:if>
									<c:if test="${map.hlth_check_type != row.code}">
										<option value="${row.code}">${row.name}</option>
									</c:if>
								</c:forEach>
							</c:if>
					</select></td>
					<th align="right">表格类型:</th>
					<td align="left"><select id="tableType" name="table_type"
						class="search-input input-175px" class="required select">
							<option
								<c:if test="${map.table_type == ''}">selected="selected"</c:if>
								value="">全部</option>
							<c:if test="${not empty tableTypeList }">
								<c:forEach items="${tableTypeList}" var="row">
									<c:if test="${map.table_type== row.code}">
										<option selected="selected" value="${row.code}">${row.name}</option>
									</c:if>
									<c:if test="${map.table_type != row.code}">
										<option value="${row.code}">${row.name}</option>
									</c:if>
								</c:forEach>
							</c:if>
					</select></td>
					<td align="left"><input type="hidden"
						class="search-input input-175px" name="dec_master_id" id="dec_master_id"
						size="14" value="${map.dec_master_id}" /></td>
					<td align="left" height="50"><span style="cursor: pointer;" class="search-btn fo"
						onclick="pageUtil('1')">搜索</span></td>
				</tr>
			</table>
		</form>
	</div>

	<div class="margin-auto width-1200 tips">
		共找到<span class="yellow font-18px">${counts}</span>条记录 分为&nbsp;<span
			class="number">${allPage }</span>&nbsp;页， 每页显示&nbsp;<span
			class="number">${itemInPage }</span>&nbsp;条记录
	</div>
	<div class="margin-auto width-1200  data-box">
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="gary">
			<tr>
				<td width="250" height="35" align="center" valign="bottom">名称</td>
				<td width="150" height="35" align="center" valign="bottom">卫生监督类型</td>
				<td width="450" height="35" align="center" valign="bottom">表格类型</td>
				<td height="35" align="center" valign="bottom">操作</td>
			</tr>
		</table>
		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="table-data" id="data_list">
			<tbody>
				<c:if test="${not empty list }">
					<c:forEach items="${list}" var="row">
						<tr>
							<td width="250" height="90" align="center" class="font-18px">${row.hun_name}</td>
							<td width="150" height="90" align="center">${row.hlth_check_type_name}</td>
							<td width="450" height="90" align="center">${row.table_type_name}</td>
							<td height="90" align="center" valign="middle"><a
								href='hlthcheckdetail?dec_master_id=${row.dec_master_id}&hun_name=${row.hun_name}&hlth_check_type=${row.hlth_check_type}&tableType=${row.table_type}'><span
									class="data-btn margin-auto">详细+</span></a></td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
			<tfoot>
				<jsp:include page="/common/pageUtil.jsp" flush="true" />
			</tfoot>
		</table>
		<input type="button" style="margin: 40px 40px 0px 540px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();">
	</div>
	<div class="margin-auto width-1200 tips"></div>
</body>
</html>
