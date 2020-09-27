<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>组织管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript" src="${ctx}/static/layer/layer.js"></script>
<script type="text/javascript"> 
	
	var layerIndex= 0;
	function pageUtil(page) {
		$("#user_form").attr("action", "/ciqs/users/findRes?page="+page);
		$("#user_form").submit();
	}
	
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /资源管理</span><div>");
		$(".user-info").css("color","white");
	});
	
   /**
	*
	*/
	function add(id){
		layerIndex = layer.open({
		  title:'新建访问资源',
		  type: 2, 
		  area: ['600px', '400px'],
		  content: '${ctx}/users/toAddVisit.html?id='+id //这里content是一个普通的String
		});
	}
	function fenpai(id){
		layerIndex = layer.open({
		  title:'分配访问资源',
		  type: 2, 
		  area: ['920px', '700px'],
		  content: '${ctx}/users/findVisitUsers.html?visitId='+id //这里content是一个普通的String
		});
	}
	function del(id){
		var vids = new Array();
	 	if(id != ''){
	 		vids.push(id);
	 	}else{
	 	
	 	}
	 	if(vids.length == 0){
	 		alert('请选择');
	 	}else{
	 	layer.confirm("确定删除此条访问路径？会将连带的删除", {icon: 3, title:'提示'}, function(index){
	            $.ajax({
		            	url:'${ctx}/users/delVisit',
		            	data:{"vIds": JSON.stringify(vids)},
		            	type:'post',
		            	success:function(result){
			        if(result.success){
			        	parent.location.reload();
			        }else{
			        	alert(result.message);
			        	$("#subb").removeAttr("disabled");
			        }
			    }});
			});
	 	}	
	}
</script>
</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a
				href="${cxt}/ciqs/users/findVisit">访问列表</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
<!-- 		<div class="title">资源查询</div> -->
		<div class="search">
			<div class="main">
				<form action="/ciqs/users/findVisit"  method="post" id="user_form">
					<table class="table_search" id="aa">
						<tr>
							<td>资源URL:</td>
					        <td>资源名称:</td>
					        <td>资源代码:</td>
					        <td></td>
						</tr>
					
						<tr>
					        <td>
					        	<input type="text" name="path" id="resstring" size="14" class="text" value = "${bean.path }"/>
					        </td>
					        <td>
					        	<input type="text" name="name" id="resname" size="14" class="text" value = "${bean.name }"/>
					        </td>
					        <td>
					        	<input type="text" name="code" id="roleId" size="14" class="text"  value = "${bean.code }"/>
					        </td>
							
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
					<li>
						<a href="javascript:add('');"><img
							src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
				</ul>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<td>资源URL</td>
							   	<td>资源名称</td>
							  	<td>资源代码</td>
							   	<td>创建时间</td>
								<td>操作</td>
								<td>排序</td>
							</tr>
						</thead>
						<c:if test="${not empty visitList }">
							<c:forEach items="${visitList}" var="row">
								<tr>
									<td>${row.path}</td>
									<td>${row.name}</td>
									<td>${row.code }</td>
									<td>
										<fmt:formatDate value="${row.createTime}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										<a href='javascript:add("${row.id}");'>
											编辑
										</a>
										|
										<a href='javascript:fenpai("${row.id}");'>分配角色</a>
										| 
										<a href='javascript:del("${row.id}");'>
											删除
										</a>
									</td>
									<td>${row.orderBy }</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>资源URL</td>
							   	<td>资源名称</td>
							  	<td>资源代码</td>
							   	<td>创建时间</td>
								<td>操作</td>
								<td>排序</td>
							</tr>
						</thead>
						<tfoot>
                        	<%-- <jsp:include page="/common/pageUtil.jsp" flush="true"/> --%>
                    	</tfoot>
						
					</table>
			</div>
		</div>
	</div>
</body>
</html>	