<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>用户管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript" src="${ctx}/static/layer/layer.js"></script>
<script type="text/javascript"> 
	function pageUtil(page) {
		$("#user_form").attr("action", "/ciqs/users/findUsers?page="+page);
		$("#user_form").submit();
	}
	
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /用户管理</span><div>");
		$(".user-info").css("color","white");
	});
	function addVisit(id){
		layerIndex = layer.open({
		  title:'新建访问资源',
		  type: 2, 
		  area: ['600px', '400px'],
		  content: '${ctx}/users/toAddUserVisit.html?userId='+id //这里content是一个普通的String
		});
	}
</script>

</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a href="${cxt}/ciqs/users/findUsers">用户管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">用户查询</div>
		<div class="search">
			<div class="main">
				<form action="/ciqs/users/findUsers"  method="post" id="user_form">
					<table class="table_search" id="aa">
						<tr>
							<td align="right">用户代码:</td>
							<td align="right">用户名称:</td>
							<td></td>						
						</tr>
						<tr>
							<td align="left">
                                <input type="text" name="id" id="id" size="14" value="${id}"/>
                            </td>
							<td align="left">
                                <input type="text" name="username" id="username" size="14" value="${username}"/>
                            </td>
							<td align="right">
                                <input name="searchF" type="submit" style="margin: 0px;" class="abutton" value="查 询" />
                            </td>
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
					<li>
                        <a href="javascript:jumpPage('/ciqs/users/usersforward');">
                        <img src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a>
                    </li>
				</ul>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<td>用户代码</td>
								<td>用户名称</td>
								<td>所属组织</td>
								<td>所属处室</td>
								<td>所属科室</td>
								<td>职务</td>
								<td>创建时间</td>
								<td>操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td><a href='javascript:jumpPage("/ciqs/users/showUser?uid=${row.id}");'>${row.id}</a></td>
									<td><a href='javascript:jumpPage("/ciqs/users/showUser?uid=${row.id}");'>${row.name}</a></td>
									<td>${row.org_name}</td>
									<td>${row.level_code}</td>
									<td>${row.depot_name}</td>
									<td>
										<c:forEach items="${dutyList}" var="dutyrow"> 
											<c:if test="${dutyrow.code==row.duties }">${dutyrow.name }</c:if>
										</c:forEach>
									</td>
									<td>
										<fmt:formatDate value="${row.create_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										<a href='javascript:jumpPage("/ciqs/users/toUpdateUsers?uid=${row.id}");'>编辑</a>
										| 
										<a href='javascript:jumpPage("/ciqs/users/delUsers?uid=${row.id}");' onclick="javascript:return confirm('是否确定执行此操作？');">删除</a>
										|
										<a href='javascript:jumpPage("/ciqs/users/toAddUserAuth?uid=${row.id}");'>添加角色</a>
										|
										<a href='javascript:addVisit("${row.id}");'>添加快捷访问</a>
										|
										<a href='javascript:jumpPage("/ciqs/users/resetPwd?uid=${row.id}");' onclick="javascript:return confirm('是否确定将此用户密码重置为”111111“？');">密码重置</a>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>用户代码</td>
								<td>用户名称</td>
								<td>所属组织</td>
								<td>所属处室</td>
								<td>所属科室</td>
								<td>职务</td>
								<td>创建时间</td>
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