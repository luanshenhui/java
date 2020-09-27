<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="loginuser!addLoginuser.action" method="post">
	<table cellspacing="0" cellpadding="0" width="98%" align="center"
		border="0" class="margtb5">
		<tr>
			<td align="left" class="padl5 lan12">
				<img src="<%=path%>/images/img-11.gif" width="12" height="12">
				<span id="titleLabel"></span>
			</td>
		</tr>
	</table>

	<table cellspacing="1" cellpadding="0" width="98%" align="center"
		border="0" class="bgcolor2 margb5">
		<tr>
			<td colspan="4" align="left" class="bkuang zi13b bgcolor2 padl5">
				用户管理
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				用户名：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" id="name" name="loginuser.name" maxlength="30" class="box1" />
&nbsp;<font color="red">*</font>

			</td>
			<td width="20%" align="right" class="zi13">
				密码：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="password" id="password" name="loginuser.password" maxlength="50"
					class="box1" />
&nbsp;<font color="red">*</font>

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				电话：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="loginuser.phone" maxlength="50"
					class="box1" />


			</td>
			<td width="20%" align="right" class="zi13">
				用户类型：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.yhlx" theme="simple"
					name="loginuser.userType" cssClass="box1" listKey="key"
					listValue="value"></s:select>

			</td>
		</tr>

	</table>

	<p>
	<p>
	<p>
	<table width="98%" align="center" border="0" cellspacing="0"
		cellpadding="0">
		<tr>
			<td align="center">
				<input type="button" class="buttonbg" onclick="save();" value="保存" />

				&nbsp;&nbsp;&nbsp;
				<input type="button" class="buttonbg" onclick="back();" value="返回" />
		</tr>
	</table>

</form>
</body>
</html>


<script>
  var title = "用户管理 > 新增";
  $("#titleLabel").html(title);
  $("input:text:first").focus();

 function save(){
 if($("#name").val() == ""){
          $.messager.alert('警告','用户名不能为空！','warning');
          return;
     }
          if($("#password").val() == ""){
          $.messager.alert('警告','密码不能为空！','warning');
          return;
     }
		   	 document.forms[0].action= "<%=path%>/loginuser!addLoginuser.action";
	 document.forms[0].submit();
	
 }
</script>

