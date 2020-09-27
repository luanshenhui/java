<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>用户管理</title>
<%@ include file="/common/resource_new.jsp"%>

<!-- **** javascript *************************************************** -->
    <script type="text/javascript">
        jQuery(document).ready(function(){
    		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>系统管理 /用户管理</span><div>");
    		$(".user-info").css("color","white");
    	});
    
        jQuery(function(){
        	$(document).ready(function() {
				isSelected('orgcode','${userDto.org_code }');
				isSelected('deptcode','${userDto.dept_code }');
				
			});
          //表单验证
            var inputDemoFormValidator = jQuery("#userForm").validate({
                // debug : false,          // 调试模式取消submit的默认提交功能
                // validClass : "check",   // 验证成功后的样式，默认字符串valid
                // focusInvalid : true,    // 表单提交时,焦点会指向第一个没有通过验证的域
                // focusCleanup : true;    // 焦点指向错误域时，隐藏错误信息，不可与focusInvalid一起使用
                // errorElement : "label", // 默认添加错误的节点名称：label
                // errorClass : "error",   // 默认为错误的样式类为：error
                rules : {
					mobilephone:{
						number:true
                    	}
                },
                messages : {
                    username : {
	                    required : "必须填写"
                    },
                    orgcode : {
	                    required : "必须填写"
                    },
                    deptcode : {
	                    required : "必须填写"
                    },
                    card_no: {
	                    required : "必须填写"
                    },
                    mobilephone:{
                    	number:"只能输入数字"
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
          
          $("#orgcode").change(function(){
        	  if($("#orgcode").val().indexOf('CIQGV')!=-1){
        		  $("#deptCodeSpan").show();
        		  $("#deptcode").addClass("required");
        	  }else{
        		  $("#deptCodeSpan").hide();
        		  $("#deptcode").removeClass("required");
        	  }
          });
        });
	</script>
</head>
<body>
<%@ include file="/common/headMenu_Sys.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">系统管理</a> &gt; <a href="${cxt}/ciqs/users/findUsers">用户管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">编辑用户</div>
		<div class="form">
			<div class="main">
				<form action="/ciqs/users/updateUsers" method="post" id="userForm">
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="25%">
									<span class="need">*</span>用户代码：
								</th>
								<td width="25%">
                                    ${userDto.id}
									<input type="hidden" id="id" name="id" value="${userDto.id}"/>
									<p></p>
								</td>
								<th width="25%">
									<span class="need">*</span>用户姓名：
							  	</th>
								<td width="25%">
									<input type="text" id="username" name="username" size="14" class="required text" value="${userDto.name}"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">
									<span class="need">*</span>所属组织：
							  	</th>
								<td class="right" width="25%">
									<select id="orgcode" name="orgcode" class="required select">
										<option value=""></option>
										<c:forEach items="${list}" var="row"> 
											<option value="${row.org_code }">${row.name}</option>
										</c:forEach>
									</select>
									<p></p>
				       			</td>
								<th width="25%">身份证号：</th>
								<td class="right" width="25%">
									<input type="text" class="required text" name="card_no" id="card_no" size="14" value="${userDto.card_no}" maxlength="20"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">
									<span class="need" id="deptCodeSpan" style="display: none;">*</span>所属处室：
							  	</th>
								<td class="right" width="25%">
									<select id="levelcode" name="levelcode" class="select">
										<option value=""></option>
										<c:forEach items="${depyList}" var="row"> 
											<option value="${row.code}">${row.name}</option>
										</c:forEach>
									</select>
									<p></p>
								</td>
								<th width="25%">
									<span class="need" id="deptCodeSpan" style="display: none;">*</span>所属科室：
							  	</th>
								<td class="right" width="25%">
									<select id="deptcode" name="deptcode" class="select">
										<option value=""></option>
										<c:forEach items="${depyList}" var="row"> 
											<option value="${row.code}">${row.name}</option>
										</c:forEach>
									</select>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">职务：</th>
								<td class="right" width="25%">
									<select id="duties" name="duties" class="required select">
										<option value=""></option>
										<c:forEach items="${dutyList}" var="row"> 
											<c:if test="${row.code==userDto.duties}">
												<option value="${row.code }" selected="selected">${row.name }</option>
											</c:if>
											<c:if test="${row.code!=userDto.duties }">
												<option value="${row.code }">${row.name }</option>
											</c:if>
										</c:forEach>
									</select>
									<p></p>
								</td>
								<th width="25%">移动电话：</th>
								<td class="right" width="25%">
									<input type="text" class="text" name="mobilephone" id="mobilephone" size="14" value="${userDto.mobile_phone_no}"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">固话/传真：</th>
								<td class="right" width="25%">
									<input type="text" class="text" name="fixedphone" id="fixedphone" size="14" value="${userDto.fixed_phone}"/>
									<p></p>
								</td>
								<th width="25%"></th>
								<td class="right" width="25%">
								</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="100">
									<input class="button" value="修改" id="subb" type="submit"/> 
									<input onclick="javascript:location='/ciqs/users/findUsers'" class="button" value="返回" type="button" />
                                    <c:if test="${userDto.flag_op=='A'}">
                                        <input class="button" value="停用" id="stop" type="button" onclick="location.href='/ciqs/users/updateUsersFlagOp?user_id=${userDto.id}&flag_op=D';"/>
                                    </c:if>
                                    <c:if test="${userDto.flag_op!='A'}">
                                        <input class="button" value="启用" id="start" type="button" onclick="location.href='/ciqs/users/updateUsersFlagOp?user_id=${userDto.id}&flag_op=A';"/>
                                    </c:if>
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