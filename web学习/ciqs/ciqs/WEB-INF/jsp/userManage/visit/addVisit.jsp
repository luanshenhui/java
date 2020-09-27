<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>组织管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript" src="${ctx}/static/layer/layer.js"></script>

<!-- **** javascript *************************************************** -->
    <script type="text/javascript">
        jQuery(document).ready(function(){
    		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /资源管理</span><div>");
    		$(".user-info").css("color","white");
    	});
    
        jQuery(function(){
        	
        	//表单验证
            var inputDemoFormValidator = jQuery("#resForm").validate({
                // debug : false,          // 调试模式取消submit的默认提交功能
                // validClass : "check",   // 验证成功后的样式，默认字符串valid
                // focusInvalid : true,    // 表单提交时,焦点会指向第一个没有通过验证的域
                // focusCleanup : true;    // 焦点指向错误域时，隐藏错误信息，不可与focusInvalid一起使用
                // errorElement : "label", // 默认添加错误的节点名称：label
                // errorClass : "error",   // 默认为错误的样式类为：error
                rules : {
                    orderBy : {
                    	required : true,
                    	digits : true,
                    	min : 0
                    }
                },
                messages : {
                	name : {
	                    required : "必须填写"
                    },
                    code : {
	                    required : "必须填写"
                    },
                    path : {
                    	required : "必须填写"
                    },
                    orderBy : {
                    	required : "必须填写",
                    	digits : "请输入整数",
                    	min : "值不能小于0"
                    }
                },
                errorPlacement : function(error, element) {
                    error.appendTo(element.next());
                },
                submitHandler : function (form) {
                    /* form.submit(); */
                       $.ajax({
                       	url:'${ctx}/users/addVisit',
                       	data:$("#resForm").serialize(),
                       	type:'post',
                       	success:function(result){
					        if(result.success){
					        	parent.location.reload();
					        }else{
					        	alert(result.message);
					        	$("#subb").removeAttr("disabled");
					        }
					    }});
                    $("#subb").attr("disabled","disabled");
                }
            });
        });
	</script>



</head>
<body>
	<div class="dpn-content" style="width: 600px;">
		<div class="form">
			<div class="main">
				<form action="/ciqs/users/addVisit" method="post" id="resForm">
					<input type="hidden" name="id" value="${not empty bean ? bean.id:''}"/>
					<table id="form_table"  style="width: 500px;">
						<tbody>
							<tr>
								<th width="50%" id="left_noline">
									<span class="need">*</span>资源名称：
								</th>
								<td width="50%">
									<input type="text" id="name" name="name" size="14" class="required text" value="${not empty bean ? bean.name:''}"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="50%">
									<span class="need">*</span>资源URL：
								</th>
								<td >
									<input type="text" id="path" name="path" size="100" class="required text" value="${not empty bean ? bean.path:''}"/>
									 <p></p>
								</td>
							</tr>
							<tr>
								<th width="50%">
									资源代码：
								</th>
								<td width="50%">
									<input type="text" id="code" name="code" size="30"  class="text" value="${not empty bean ? bean.code:''}"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="50%">
									<span class="need">*</span>排序：
								</th>
								<td>
									<input name="orderBy" id="orderBy" type="text" class="text" value="${not empty bean ? bean.orderBy:''}"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="50%">
									<span class="need">*</span>路径类型：
								</th>
								<td>
									<select name="localWebType">
										<option value="0">内部系统</option>
										<option value="1">非内部系统</option>
									</select>
									<p></p>
								</td>
							</tr>
						</tbody>

						<tfoot>
							<tr>
								<td colspan="100">
									<input class="button" value="提交" id="subb" style="text-align: center;width: 50px;"
									type="submit" /> 
									<input onclick="javascript:parent.location.reload();" style="text-align: center;width: 50px;"
									class="button" value="返回" type="button" />
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
