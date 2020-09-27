<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<%@ include file="/common/resource.jsp"%>

<script type="text/javascript">

function btnSearch(){
		pageUtil(str);
}

function pageUtil(str){
	$("#page").val(str);
	var url = '${ctx}/log/search/list';
	$("#delete").attr("action",url);
	$("#delete").submit();
}
	
</script>
</head>

<body>
<!--<SCRIPT src="menu1.js"></SCRIPT>-->

<div id="content">
  <div class="crumb">当前位置：业务日志 &gt; 业务日志查询  </div>
  <%@ include file="/common/message.jsp"%>
 <!--  <div class="menu"> -->
  <form action="${ctx}/log/search/list" id="delete">
  	 <div class="search">
			<table class="table_search">
				<tr>
					<th>操作人代码:</th>
					<td><input name="actionUser" id="actionUser" type="text" class="text" size="14"   />
					</td>
					<th>操作人组织:</th>
					<td><input name="actionOrgCode" id="actionOrgCode" type="text" class="textinput" size="14"  />
					</td>
			
					<th>操作功能主键编号:</th>
					<td><input name="indexValue" id="indexValue" type="text" class="text" size="14"  />
					</td>
				</tr>
				<tr>
					<th>操作类型:</th>
					<td>
					<select name="actionType" id="actionType">
						<option value=""></option>
						<option value="info">info</option>
						<option value="error">error</option>
					</select>
					</td>
					<th>动作名称:</th>
					<td><input name="actionName" id="actionName" type="text" class="textinput" size="14"  />
					</td>
					<td><input onclick="btnSearch" type="submit" class="btn" value="查 询" />
					</td>
				</tr>
			</table>
		</div> 
		
    <div class="data_info_right">共找到 <span class="orange">${size}</span> 条记录，每页显示<span class="orange">${itemInPage}</span> 条记录</div>
  <!-- </div> -->
  <table id="personList" class="table_base  table_body">
			<tr class="thead">
				<td id="left_noline">操作人代码</td>
				<td>操作人组织</td>
				<td>操作日期</td>
				<td>操作功能主键编号</td>
				<td>操作类型</td>
				<td>动作名称</td>
				<td>备注1</td>
				<td>备注2</td>
				<td>备注3</td>
				<td>备注4</td>
				<td>备注5</td>
			</tr>
			<c:if test="${not empty list }">
				<c:forEach items="${list}" var="row">
				<tr>
					<td id="left_noline">${row.action_user}</td>
					<td>${row.action_org_code}</td>
					<td>${row.action_date}</td>
					<td>${row.index_value}</td>
					<td>${row.action_type}</td>
					<td>${row.action_name}</td>
					<td>${row.details_1}</td>
					<td>${row.details_2}</td>
					<td>${row.details_3}</td>
					<td>${row.details_4}</td>
					<td>${row.details_5}</td>
				</tr>
				</c:forEach>
			</c:if>
		</table>
	
	
	<input type="hidden" id="page" name="page" />
  <div class="spacing"></div>
<div class="action"><jsp:include  page="/common/pageUtil.jsp" flush="true"/></div>
</form>
</div>

</body>
</html>


