<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>修改密码</title>
<%@ include file="/common/resource_new.jsp"%>

<!-- **** javascript *************************************************** -->
    <script type="text/javascript">
        jQuery(document).ready(function(){
    		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>修改密码</span><div>");
    		$(".user-info").css("color","white");
    	});
    
        jQuery(function(){
          //表单验证
            var inputDemoFormValidator = jQuery("#userForm").validate({
                rules : {
					
                },
                messages : {
                	op : {
	                    required : "必须填写"
                    },
                    np : {
	                    required : "必须填写"
                    },
                    nnp : {
	                    required : "必须填写"
                    }
                },
                errorPlacement : function(error, element) {
                    error.appendTo(element.next());
                },
                submitHandler : function (form) {
                    form.submit();
                }
            });
        });
        function checkPwd(){
        	if($("#np").val()!="" && $("#nnp").val()!="" && $("#np").val()!=$("#nnp").val()){
        		alert("两次新密码输入不一致");
        		$("#nnp").val("");
        	}
        }
	</script>

</head>
<body>
<div class="dpn-frame-head">
    <table>
        <tr>
            <td><span class="logo" style="width:630px;"> </span></td>
            <td style="font-size: 14px;color: black;margin-top: 30px;a:active{color: black}">
                <%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
            </td>
        </tr>
    </table>
</div>
	<div class="dpn-content">
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">修改密码</div>
		<div class="form">
			<div class="main">
				<form action="/ciqs/login/resetPwdByUser" method="post" id="userForm">
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="50%">
									<span class="need">*</span>原密码：
								</th>
								<td width="50%">
									<input type="hidden" id="uid" name="uid" value="${user.id }"/>
									<input type="password" id="op" name="op" size="14"  class="required text"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="50%">
									<span class="need">*</span>新密码：
								</th>
								<td width="50%">
									<input type="password" id="np" name="np" size="14"  class="required text" onblur="checkPwd();"/>
									<p></p>
								</td>
							</tr>
							<tr>
				      			<th width="50%">
									<span class="need">*</span>确认新密码：
								</th>
								<td width="50%">
									<input type="password" id="nnp" name="nnp" size="14"  class="required text" onblur="checkPwd();"/>
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
