<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>组织管理</title>
<%@ include file="/common/resource_new.jsp"%>

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
                },
                messages : {
                	resname : {
	                    required : "必须填写"
                    },
                    resstring : {
	                    required : "必须填写"
                    }
                },
                errorPlacement : function(error, element) {
                    error.appendTo(element.next());
                },
                submitHandler : function (form) {
                    form.submit();
                    $("#subb").attr("disabled","disabled");
                }
            });
        });
	</script>



</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a
				href="${cxt}/ciqs/users/findRes">资源管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">新建资源</div>
		<div class="form">
			<div class="main">
				<form action="/ciqs/users/addRes" method="post" id="resForm">
					<table id="form_table">
						<tbody>
							<tr>
								<th width="25%" id="left_noline">
									<span class="need">*</span>资源名称：
								</th>
								<td width="25%">
									<input type="text" id="resname"
									name="resname" size="14" class="required text"/>
									<p></p>
								</td>
								<th width="25%">
									资源描述：
								</th>
								<td width="25%">
									<input type="text" id="resdesc" name="resdesc" size="30"  class="text"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">
									<span class="need">*</span>资源URL：
								</th>
								<td colspan="3" >
									<input type="text"
									id="resstring" name="resstring" 
									 size="100" class="required text" />
									 <p></p>
								</td>
							</tr>
						</tbody>

						<tfoot>
							<tr>
								<td colspan="100">
									<input class="button" value="提交" id="subb" style="text-align: center;width: 50px;"
									type="submit" /> 
									<input onclick="javascript:history.go(-1);" style="text-align: center;width: 50px;"
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
