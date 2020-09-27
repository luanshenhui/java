<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>权限管理</title>
<%@ include file="/common/resource_new.jsp"%>

<script>
jQuery(document).ready(function(){
	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /权限管理</span><div>");
	$(".user-info").css("color","white");
});

$(document).ready(function(){
	
	$("#subb").click(function(){
		if ($("input:checkbox[@name=rolesbox]:checked").length <=0){
			alert('请勾选相应的角色');
			return false;
		}else{
			$("#user").submit();
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
				href="${cxt}/ciqs/users/findAuth">权限管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<form action="/ciqs/users/addUserAuth" method="post" id="user">
			<div class = "form">
				<div class = "main">
					<table >
						<tr>
							<th>用户代码：</th>
							<td>
								${userCode}
								<input type = "hidden"  value = "${userCode}"   id = "usercode"  name = "usercode"/>
							</td>
						</tr>
						<tr>
							<th>角色代码：</th>
							<td>
								<c:forEach var = "role"  items = "${list }">
									<input type = "checkbox"  id = "rolesbox"  name = "rolesbox"  value = "${role.id }"/>
									${role.name }<br/>
								</c:forEach>
							</td>
						</tr>
					</table>
				</div>
			</div>
				<input  class = "button"   value="确定" id="subb"  type="button" style="text-align: center;"/>
				<input onclick="javascript:history.go(-1);" class = "button"  value="返回" type="button" style="text-align: center;width: 50px;" />
			<br/>
		</form>
		<br/>
	</div>
</body>
</html>
