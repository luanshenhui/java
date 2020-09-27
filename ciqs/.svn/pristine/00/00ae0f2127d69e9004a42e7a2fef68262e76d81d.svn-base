<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>访问配置管理</title>
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
		$("#authForm").attr("action", "/ciqs/users/findUserConf?page="+page);
		$("#authForm").submit();
	}
	function setParameter(){
		parent.$("#parameter_first").val($("#userid").val());
		parent.$("#parameter_second").val($("#rolesid").val());
		pageUtil(1);
	}	
	function dele(){
		if(confirm('确认要删除选中项么!!')){
			if($("input:checkbox[@name=ucids]:checked").length <= 0){
				alert('请选中要删除的数据项！');
				return false;
			}else{
				var ucids = new Array();
				$("[name='ucids']:checkbox").each(function(i, e) {
					if ($(this).is(":checked")) {
						ucids.push($(this).attr("ucId"));
					}
				});
				var data = {"ucids":ucids };
				console.log(data)
		        $.ajax({
		           	url:$("#authForm1").attr("action"),
		           	data:JSON.stringify(data),
		           	dataType:"json",  
	    			contentType:"application/json", 
		           	type:'post',
		           	success:function(result){
				        if(result.success){
				        	location.reload();
				        }else{
				        	alert(result.message);
				        	$("#subb").removeAttr("disabled");
				        }
			    	}
			    });
			}
		}
	}
	
	function updateOrderBy(){
		if(confirm('确认要提交修改选中的数据么!!')){
			if($("input:checkbox[@name=ucids]:checked").length <= 0){
				alert('请选中要提交修改的数据！');
				return false;
			}else{
				var dtos = new Array();
				$("[name='ucids']:checkbox").each(function(i, e) {
					if ($(this).is(":checked")) {
						var obj = {
							"id":$(this).attr("ucId"),
							"orderBy":$("#"+$(this).attr("ucId")).val()
						}
						dtos.push(obj);
					}
				});
		        $.ajax({
		           	url:"${ctx}/users/updateUcOrderBy",
		           	data:JSON.stringify(dtos),
		           	dataType:"json",  
	    			contentType:"application/json", 
		           	type:'post',
		           	success:function(result){
				        if(result.success){
				        	location.reload();
				        }else{
				        	alert(result.message);
				        	$("#subb").removeAttr("disabled");
				        }
			    	}
			    });
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
				href="${cxt}/ciqs/users/findUserConf">权限管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">权限查询</div>
		<div class="search">
			<div class="main">
				<form action="/ciqs/users/findUserConf"  method="post" id="authForm">
					<table class="table_search" id="aa">
						<tr>
							<td>用户代码:</td>
							<td >角色代码:</td>
							<td></td>
						</tr>
					
						<tr>
							<td align="left"><input type="text" name="userId" id="userid"
								size="14" value="${um.userId}"/></td>
							<td align="left"><input type="text" name="visitCode" id="visitCode" 
								size="14" value="${um.visitCode}"/></td>
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
			   <form action = "/ciqs/users/delUserVisit"  id = "authForm1">
					<table>
						<thead>
							<tr>
								<td style="width: 50px" >
									<input type="checkbox" style="width:15px;height: 15px;" name="checkbox" ucId="${row.ucId  }" onclick="handleCheckAll(this,'isBuy')" />
								</td>
								<td >用户代码</td>
								<td>配置名称</td>
								<td>配置代码</td>
								<td>排序</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>
										<input type="checkbox" style="width:15px;height: 15px;" name="ucids" ucId="${row.ucId }" id="isBuy" />
									</td>
									<td>${row.userId}</td>
									<td>${row.visitName}</td>
									<td>${row.visitCode}</td>
									<td><input style="width: 30px;height: 30px;"
										 name="orderBy" value="${row.orderBy}" id="${row.ucId}" ucId="${row.ucId}" maxlength="999"
										 onkeyup="if (!(/(^[1-9]\d*$)/.test(this.value))){this.value=''}"/></td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>
									<input type="checkbox" style="width:15px;height: 15px;" name="checkbox" value="checkbox" onclick="handleCheckAll(this,'isBusy')" />
								</td>
								<td>用户代码</td>
								<td>角色代码</td>
								<td>创建时间</td>
								<td>排序</td>
							</tr>
						</thead>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
					<div style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
						<input type="button" class="search-btn" value="提交" onclick="javascript:updateOrderBy();" />
					</div>					
					</form>
			</div>
		</div>
	</div>
</body>
</html>