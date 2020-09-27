<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>用户管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
	function pageUtil(page) {
		$("#user_form").attr("action", "/ciqs/users/findUsers?page="+page);
		$("#user_form").submit();
	}
	
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /用户管理</span><div>");
		$(".user-info").css("color","white");
	});
	function checkAllChange() {
		if ($("#checkAll").attr("checked")) {
			$("input[name='check']").each(function(i, e) {
				if ($(e).attr("disabled") == undefined) {
					$(e).attr("checked", true);
				}
			});
		} else {
			if(confirm("是否将全部撤销？")){
				$("input[name='check']").each(function(i, e) {
					$(e).removeAttr("checked");
				});
			}else{
				$("#checkAll").attr("checked","checked");
			}
		}
	}
	
	function sub(){
		var uids = [];
	    var uidAlls = [];
		$("[name='check']:checkbox").each(function(i, e) {
	        uidAlls.push($(this).attr("userId"));
			if ($(this).is(":checked")) {
				uids.push($(this).attr("userId"));
			}
		});
		debugger	
		if(confirm("确定提交吗？")){
			var  data = /* JSON.stringify( */{
				"uids":uids,
				"visitId":$("#visitId").val(),
				"uidAlls":uidAlls
			}/* ) */;
			console.log(data);
	        $.ajax({
	           	url:'${ctx}/users/addVisitUser',
	           	data:JSON.stringify(data),
	           	dataType:"json",  
    			contentType:"application/json", 
	           	/* dataType:"json", */
	           	type:'post',
	           	success:function(result){
			        if(result.success){
			        	parent.location.reload();
			        }else{
			        	alert(result.message);
			        	$("#subb").removeAttr("disabled");
			        }
		    	}
		    });
		}
	}
</script>
<style>
#wrap {
  width:800px;
  position:fixed; 
  bottom:15px;
  left:0px;
  margin:0 auto;
  text-align: center; 
}
input {
/*   position: relative;
  top: 10px;
  left: 20px; */
}
</style>
</head>
<body>
	<div class="dpn-content" style="width: 800px;">
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="search" style="width: 800px;">
			<div class="main" style="width:764px;">
				<form action="/ciqs/users/findVisitUsers"  method="post" id="user_form">
					<input type="hidden"  id="visitId" name="visitId" value="${visitId}"/>
					<table class="table_search" id="aa" style="width: 800px;">
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
			<div class="data" style="width:800px;"><span style="float: left;">
				共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
				分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</span>
			</div>
			<div class="main" style="width:800px;">
					<table style="width:800px;">
						<thead>
							<tr>
								<td><input type="checkbox" id="checkAll"style="width: 50px;" onchange="checkAllChange()" /></td>
								<td>用户代码</td>
								<td>用户名称</td>
								<td>所属组织</td>
								<td>所属处室</td>
								<td>所属科室</td>
								<td>职务</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>
										<input type="checkbox" class="checkbox" name="check" userId="${row.id }"<c:if test="${not empty row.ucId }">checked="checked"</c:if>/>
									</td>
									<td>${row.id}</td>
									<td>${row.name}</td>
									<td>${row.org_name}</td>
									<td>${row.level_code}</td>
									<td>${row.depot_name}</td>
									<td>
										<c:forEach items="${dutyList}" var="dutyrow"> 
											<c:if test="${dutyrow.code==row.duties }">${dutyrow.name }</c:if>
										</c:forEach>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td><input type="checkbox" id="checkAll"style="width: 50px;" onchange="checkAllChange()" /></td>
								<td>用户代码</td>
								<td>用户名称</td>
								<td>所属组织</td>
								<td>所属处室</td>
								<td>所属科室</td>
								<td>职务</td>
							</tr>
						</thead>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
					<div id="wrap">
					  <input type="button" style="height: 24px;" onclick="sub()" value="&nbsp;&nbsp;提&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交&nbsp;&nbsp;">
					</div>
			</div>
		</div>
	</div>
</body>
</html>