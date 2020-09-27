<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>组织管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#user_form").attr("action", "/ciqs/users/findOrganizes?page="+page);
			$("#user_form").submit();
		}
		
		jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /组织管理</span><div>");
			$(".user-info").css("color","white");
		});
</script>
</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a
				href="${cxt}/ciqs/users/findOrganizes">组织管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">组织查询</div>
		<div class="search">
			<div class="main">
				<form action="/ciqs/users/findOrganizes"  method="post" id="user_form">
					<table class="table_search" id="aa">
						<tr>
							<td >组织代码:</td>
							<td >组织名称:</td>
							<td></td>
						</tr>
						<tr>
							<td align="left"><input type="text" name="orgcode" id="orgcode"
								size="14" value="${orgcode}"/></td>
							<td align="left"><input type="text" name="orgname" id="orgname"
								size="14" value="${orgname}"/></td>
							<td ><input name="searchF" type="submit"
								class="abutton" value="查 询" /></td>
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
			<div class="menu">
				<ul>
					<li><a href="javascript:jumpPage('/ciqs/users/organizesforward');">
					<img src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
				</ul>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<td>组织代码</td>
								<td>组织名称</td>
								<td>所在省份</td>
								<td>创建时间</td>
								<td>修改时间</td>
								<td>操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>${row.org_code}</td>
									<td>${row.name}</td>
									<td>
										辽宁
									</td>
									<td>
										<fmt:formatDate value="${row.create_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										<fmt:formatDate value="${row.modify_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										<a href='javascript:jumpPage("/ciqs/users/toUpdateOrganizes?orgcode=${row.org_code}");'>
											编辑
										</a>
										| 
										<a href='javascript:jumpPage("/ciqs/users/delOrganizes?orgcode=${row.org_code}");' onclick="javascript:return confirm('是否确定执行此操作？');">删除</a>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>组织代码</td>
								<td>组织名称</td>
								<td>所在省份</td>
								<td>创建时间</td>
								<td>修改时间</td>
								<td>操作</td>
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