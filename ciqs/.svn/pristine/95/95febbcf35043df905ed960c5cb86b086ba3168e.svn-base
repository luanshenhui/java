<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>资源管理</title>
<%@ include file="/common/resource_new.jsp"%>

<script>
    jQuery(document).ready(function(){
    	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /资源管理</span><div>");
    	$(".user-info").css("color","white");
    });
    
	$(document).ready(function(){
		$("#subb").click(function(){
			if ($("input:checkbox[@name=rolesbox]:checked").length <= 0){
				alert('请勾选相应的角色');
				return false;
			}else{
				$("#resForm").submit();
			}
	});
	});
</script>
</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a
				href="${cxt}/ciqs/users/findRes">资源管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">资源描述</div>
		<div class="form">
			<div class="main">
				<table id="form_table">
					<tbody>
						<tr>
							<th width="10%" id="left_noline">
								资源名称：
							</th>
							<td width="35%">
								${resDto.name }
							</td>
							<th width="10%">
								资源URL：
							</th>
							<td width="45%">
								${resDto.res_string }
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="title">分配角色</div>
		
		<div class="table">
			<div class="main">
					<form action="/ciqs/users/setRole" method="post" id="resForm">
					<table>
						<thead>
							<tr>
								<td>
									<input type="checkbox" name="checkAll" id="check_all" onclick="handleCheckAll(this,'rolesbox');"/>
									<input type="hidden" name="resid" id="resid" value="${resDto.id }"/>
								</td>
								<td>
									角色代码
							  	</td>
							   	<td >
							   		角色名称
							  	</td>
							   	<td >
							   		创建时间
							  	</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>
											<input type="checkbox" name="rolesbox" id="rolesbox"  value="${row.id}"/>
									</td>
									<td>${row.id}</td>
									<td>${row.name}</td>
									<td>
										<fmt:formatDate value="${row.create_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test = "${not empty resRoleList }">
							<c:forEach items="${resRoleList}" var="resRole">
								<tr>
									<td>
											<input type="checkbox" name="rolesbox" id="rolesbox"  checked="checked"  value="${resRole.id}"/>
									</td>
									<td>${resRole.id}</td>
									<td>${resRole.name }</td>
									<td>
										<fmt:formatDate value="${resRole.create_date}" type="both"/>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>
									<input type="checkbox" name="checkAll" id="check_all" onclick="handleCheckAll(this,'rolesbox');"/>
								</td>
								<td>
									角色代码
							  	</td>
							   	<td >
							   		角色名称
							  	</td>
							   	<td >
							   		创建时间
							  	</td>
							</tr>
						</thead>
						<tfoot>	
                        	<tr height="50px;">
								<td colspan="100">
									<input class="btn" value="提交" id="subb" style="text-align: center;width: 50px;"
									type="button" /> 
									<input onclick="javascript:history.go(-1);" style="text-align: center;width: 50px;"
									class="button" value="返回" type="button" />
								</td>
							</tr>
                    	</tfoot>
					</table>
					</form>
			</div>
		</div>
	</div>
</body>
</html>
