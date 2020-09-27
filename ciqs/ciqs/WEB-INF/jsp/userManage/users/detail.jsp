<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>用户管理</title>
<%@ include file="/common/resource_new.jsp"%>

<!-- **** javascript *************************************************** -->
    <script type="text/javascript">
        jQuery(document).ready(function(){
    		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /用户管理</span><div>");
    		$(".user-info").css("color","white");
    	});
	</script>

</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a href="${cxt}/ciqs/users/findUsers">用户管理</a>
		</div>
		<div class="title">用户详情</div>
		<div class="form">
			<div class="main">
				<form action="/ciqs/users/updateUsers" method="post" id="userForm">
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="25%">
									<span class="need">*</span>用户代码：
								</th>
								<td width="25%">
									${userDto.id }
								</td>
								<th width="25%">
									<span class="need">*</span>用户姓名：
							  	</th>
								<td width="25%">
									${userDto.name}
								</td>
							</tr>
							<tr>
								<th width="25%">
									<span class="need">*</span>所属组织：
							  	</th>
								<td class="right" width="25%">
									<select id="orgcode" name="orgcode"  class="required select" disabled="disabled">
										<option value=""></option>
										<c:forEach items="${list}" var="row"> 
											<option value="${row.org_code}" ${userDto.org_code==row.org_code?'selected':''}>${row.name}</option>
										</c:forEach>
									</select>
									<p></p>
				       			</td>
								<th width="25%">
									身份证号：
							  	</th>
								<td class="right" width="25%">
									${userDto.card_no }
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">
									所属科室：
							  	</th>
								<td class="right" width="25%">
									<select id="deptcode" name="deptcode"  class="select" disabled="disabled">
										<option value=""></option>
										<c:forEach items="${depyList}" var="row"> 
											<option value="${row.code}" ${userDto.dept_code==row.code?'selected':''}>${row.name}</option>
										</c:forEach>
									</select>
									<p></p>
								</td>
								<th width="25%">
									所属处室：
							  	</th>
								<td class="right" width="25%">
									<select id="levelcode" name="levelcode"  class="select" disabled="disabled">
										<option value=""></option>
										<c:forEach items="${depyList}" var="row"> 
											<option value="${row.code}" ${userDto.level_code==row.code?'selected':''}>${row.name}</option>
										</c:forEach>
									</select>
									<p></p>
								</td>
							    
							</tr>
							<tr>
								<th width="25%">职务：</th>
								<td class="right" width="25%">
									<c:forEach items="${dutyList}" var="dutyrow"> 
										<c:if test="${dutyrow.code==userDto.duties }">${dutyrow.name }</c:if>
									</c:forEach>
								</td>
								<th width="25%">移动电话：</th>
								<td class="right" width="25%">
									${userDto.mobile_phone_no }
								</td>
							</tr>
							<tr>
								<th width="25%">固话/传真：</th>
								<td class="right" width="25%">
									${userDto.fixed_phone }
								</td>
								<th width="25%"></th>
								<td class="right" width="25%">
								</td>
							</tr>
						</tbody>

						<tfoot>
							<tr>
								<td colspan="100">
									<input onclick="javascript:location='/ciqs/users/findUsers'" class="button" value="返回" type="button" />
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