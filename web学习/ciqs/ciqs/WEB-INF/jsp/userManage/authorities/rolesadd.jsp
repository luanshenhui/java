<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>角色管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script>
    jQuery(document).ready(function(){
    	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /权限管理</span><div>");
    	$(".user-info").css("color","white");
    });

	$(document).ready(function(){
		$("#subb").click(function(){
			if ($("input:checkbox[@name=isBuy]:checked").length <= 0){
				alert('请勾选相应的用户');
				return false;
			}else{
				$("#userForm").submit();
			}
	});
	});
	
	function pageUtil(page) {
		$("#page").val(page);
		$("#userForm").attr("action", "/ciqs/users/selectUserInfo?rolesCode="+$("#rolescode").val());
		$("#userForm").submit();
	}
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
		<form action="/ciqs/users/selectUserInfo" method="post" id="user">
		<div class = "form">
			<div class="main">
				<table>
					 <tr>
			      			<th >
								角色代码：
							</th>
							<td colspan="2">
								${rolesCode }
							<input type="hidden" name="rolescode" id="rolescode" size="14" value="${rolesCode}" class="required" />
							
							</td>
					</tr>
				</table>
			</div>
		</div>
			<br/>
			<div class="search">
			<div class="main">
				<table class="table_search">
					<tr>
						 	<th align="right">用户代码:</th>
					        <td align="left"><input type = "text"  name ="usercode" id ="usercode" size="14"  value="${usercode}"/></td>
					        <th align="right">组织代码:</th>
					        <td align="left"><input type = "text" name ="orgcode"  id ="orgcode" size="14" value="${orgcode}"/></td>
					        <td align="right"><input id="submit" type="submit" class="button"  value="查 询" /></td>
					</tr>
				</table>
			</div>
			</div>
		</form>
		<br/>
		<div class="table">
		<div class="main">
			<form action = "/ciqs/users/addAuth"  id = "userForm">
			<input type="hidden" name="page" id="page" size="14" value="${page}" class="required" />
			<c:if test = "${not empty list}">
						<table>
							<thead>
						      	<tr>
							      <td>
							      	<input type="checkbox" name="checkbox" value="checkbox" onclick="handleCheckAll(this,'isBuy');" />
							      	<input type="hidden" name="rolescode" id="rolescode" size="14" value="${rolesCode }" class="required" />
							      </td>
								 <td >用户代码
								  </td>
								   <td >组织代码
								  </td>
								</tr>
							</thead>
							<c:forEach var = "row"  varStatus="rowIdx"  items="${list}">
	<!-- 							<tr evenrow":"" %>"> -->
								<tr>
								 	<td>
								 		<input type="checkbox" name="isBuy" id="isBuy" value="${row.id}" />
								 	</td>
								  	<td >${row.id } </td>
								   	<td >${row.org_code }</td>
								</tr>
							</c:forEach>
						<thead>
							<tr>
							 	<td>
						      		<input type="checkbox" name="checkbox" value="checkbox"  onclick ="handleCheckAll(this,'isBuy');" />
							     </td>
								 <td >用户代码
								  </td>
								   <td >组织代码
								  </td>						
							</tr>
						</thead>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
				</table>		
				<input  class = "button"  value="确定" id="subb"  type="button" style="text-align: center;width: 50px;"/>
   				<input onclick="javascript:location='/ciqs/users/findRoles'" class = "button" style="text-align: center;width: 50px;"  value="返回" type="button" />
			</c:if>
			</form>
		</div>
		</div>
		<br/>
	</div>
</body>
</html>
