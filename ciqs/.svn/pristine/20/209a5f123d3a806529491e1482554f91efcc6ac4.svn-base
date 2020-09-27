<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>组织管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
    jQuery(document).ready(function(){
    	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /角色管理</span><div>");
    	$(".user-info").css("color","white");
    });
		
    function pageUtil(page) {
		$("#user_form").attr("action", "/ciqs/users/findRoles?page="+page);
		$("#user_form").submit();
	}
</script>
</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a
				href="${cxt}/ciqs/users/findRoles">角色管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">角色查询</div>
		<div class="search">
			<div class="main">
				<form action="/ciqs/users/findRoles"  method="post" id="user_form">
					<table class="table_search" id="aa">
						<tr>
							<td align="right">角色代码:</td>
							<td align="right">角色名称:</td>
							<td></td>
						</tr>
					
						<tr>
							<td align="left"><input type="text" name="rolesid" id="rolesid"
								size="14" value="${rolesid}"/></td>
							<td align="left"><input type="text" name="rolesname" id="rolesname"
								size="14" value="${rolesname}"/></td>
							<td align="right"><input name="searchF" type="submit" style="margin: 0px;"
								class="abutton" value="查 询" /></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data"><span style="float: left;">
				共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
				分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</span>
			</div>
			<div class="menu">
				<ul>
					<li><a href="javascript:jumpPage('/ciqs/users/rolesforward');"><img
							src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
				</ul>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<td>
									角色代码
							  	</td>
							   	<td >
							   		角色名称
							  	</td>
							   	<td >
							   		创建时间
							  	</td>
								<td>
									操作
								</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>${row.id}</td>
									<td>${row.name}</td>
									<td>
										<fmt:formatDate value="${row.create_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										<a href='javascript:jumpPage("/ciqs/users/toAddAuth?code=${row.id}");'>
											添加用户
										</a>
										|
										<a href='javascript:jumpPage("/ciqs/users/showRes?code=${row.id}");'>查看资源</a>
										| 
										<a href='javascript:jumpPage("/ciqs/users/delRoles?code=${row.id}");' 
											onclick="javascript:return confirm('是否确定执行此操作？');">
											删除
										</a>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>
									角色代码
							  	</td>
							   	<td >
							   		角色名称
							  	</td>
							   	<td >
							   		创建时间
							  	</td>
								<td>
									操作
								</td>
							</tr>
						</thead>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
			</div>
		</div>
	</div>
</body>
</html>
