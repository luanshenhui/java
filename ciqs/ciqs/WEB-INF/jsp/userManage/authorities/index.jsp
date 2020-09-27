<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>权限管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
    $(function(){
    	if(typeof(parent.$("#parameter_first").val()) != "undefined"){
			$("#userid").val(parent.$("#parameter_first").val());
		}
		if(typeof(parent.$("#parameter_second").val()) != "undefined"){
			$("#rolesid").val(parent.$("#parameter_second").val());
		}
    });
	function pageUtil(page) {
	    if(typeof(parent.$("#parameter_first").val()) != "undefined"){
			$("#userid").val(parent.$("#parameter_first").val());
		}
		if(typeof(parent.$("#parameter_second").val()) != "undefined"){
			$("#rolesid").val(parent.$("#parameter_second").val());
		}
		$("#authForm").attr("action", "/ciqs/users/findAuth?page="+page);
		$("#authForm").submit();
	}
	function setParameter(){
		parent.$("#parameter_first").val($("#userid").val());
		parent.$("#parameter_second").val($("#rolesid").val());
		pageUtil(1);
	}	
	function dele(){
		if(confirm('确认要删除选中项么!!')){
			if($("input:checkbox[@name=isBuy]:checked").length <= 0){
				alert('请选中要删除的数据项！');
				return false;
			}else{
				$("#authForm1").submit();
			}
		}
	}
	
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /权限管理</span><div>");
		$(".user-info").css("color","white");
	});
</script>
</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a
				href="${cxt}/ciqs/users/findAuth">权限管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">权限查询</div>
		<div class="search">
			<div class="main">
				<form action="/ciqs/users/findAuth"  method="post" id="authForm">
					<table class="table_search" id="aa">
						<tr>
							<td>用户代码:</td>
							<td >角色代码:</td>
							<td></td>
						</tr>
					
						<tr>
							<td align="left"><input type="text" name="userid" id="userid"
								size="14" value="${userid}"/></td>
							<td align="left"><input type="text" name="rolesid" id="rolesid" 
								size="14" value="${roleid}"/></td>
							<td ><input name="searchF" type="submit" onclick="setParameter();"
								class="mbutton" value="查 询" />
								<input value="删 除" class="mbutton"  onclick="dele();" type="button" id="newBut" />
								</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data">	<span style="float: left;">
				共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
				分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</span>
			</div>
			<div class="main">
			   <form action = "/ciqs/users/delAuth"  id = "authForm1">
					<table>
						<thead>
							<tr>
								<td style="width: 50px" >
									<input type="checkbox"  name="checkbox" value="checkbox" onclick="handleCheckAll(this,'isBuy')" />
								</td>
								<td >用户代码</td>
								<td>角色代码</td>
								<td>创建时间</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>
										<input type="checkbox" name="isBuy" id="isBuy" value="${row.user_id }-${row.role_id}" />
									</td>
									<td>${row.user_id}</td>
									<td>${row.role_id}</td>
									<td><fmt:formatDate value="${row.create_date}"   pattern="yyyy-MM-dd HH:mm"/></td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>
									<input type="checkbox" name="checkbox" value="checkbox" onclick="handleCheckAll(this,'isBusy')" />
								</td>
								<td>用户代码</td>
								<td>角色代码</td>
								<td>创建时间</td>
							</tr>
						</thead>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
					</form>
			</div>
		</div>
	</div>
</body>
</html>