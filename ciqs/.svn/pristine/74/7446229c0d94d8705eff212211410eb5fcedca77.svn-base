<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>访问配置管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
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
	
	function sub(){
		var vIds = [];
	    /* var uidAlls = []; */
		$("[name='check']:checkbox").each(function(i, e) {
	        /* uidAlls.push($(this).attr("userId")); */
			if ($(this).is(":checked")) {
				vIds.push($(this).attr("visitId"));
			}
		});
		debugger	
		if(confirm("确定提交吗？")){
			var  data = /* JSON.stringify( */{
				"vIds":vIds,
				"userId":$("#userId").val(),
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
<style type="">
#wrap {
  width:800px;
  position:fixed; 
  bottom:15px;
  left:0px;
  margin:0 auto;
  text-align: center; 
}
</style>
</head>
<body>
	<div class="dpn-content" style="width: 580px;">
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="table">
			<div class="main" style="width:580px;">
				<table style="width:580px;">
					<thead>
						<tr>
							<td><input type="checkbox" id="checkAll"style="width: 50px;" onchange="checkAllChange()" /></td>
							<td>资源名称</td>
							<td>资源代码</td>
							<td>资源URL</td>
							<td>排序</td>
						</tr>
					</thead>
					<c:forEach items="${list }" var = "row">
						<tr>
							<td><input type="checkbox" class="checkbox" name="check" visitId="${row.id }" <c:if test="${not empty row.userId }">checked="checked"</c:if>/></td>
							<td>${row.name }</td>
							<td>${row.code }</td>
							<td>${row.path }</td>
							<td>${row.orderBy }</td>
						</tr>
					</c:forEach>
				</table>
				<div id="wrap">
					<input type="hidden" value="${userId }" name="userId" id="userId"/>
				    <input type="button" style="height: 24px;" onclick="sub()" value="&nbsp;&nbsp;提&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;交&nbsp;&nbsp;">
				</div>
			</div>
		</div>
	</div>
</body>
</html>