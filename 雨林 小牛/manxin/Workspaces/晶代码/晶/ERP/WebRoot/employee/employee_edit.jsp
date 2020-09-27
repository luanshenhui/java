
<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="employee!editEmployee.action" method="post">
	<input type="hidden" name="employee.id" value="${employee.id}" />
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
				员工管理
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				员工姓名：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${employee.name}" id="name"
					name="employee.name" maxlength="30" class="box1" />
				&nbsp;
				<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				性别：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.sex" theme="simple" name="employee.sex"
					cssClass="box1" listKey="key" listValue="value"></s:select>

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				身份证号：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${employee.idno}" id="idno"
					name="employee.idno" maxlength="30" class="box1" />
				&nbsp;
				<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				出生日期：
			</td>
			<td width="30%" class="pad2 zi13">

				<input class="Wdate"
					value="<s:date name="employee.birthday" format="yyyy-MM-dd" />"
					type="text" value="" name="employee.birthday"
					onfocus="WdatePicker({readOnly:true})" />


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				联系方式：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${employee.telphone}"
					name="employee.telphone" maxlength="30" class="box1" />


			</td>
			<td width="20%" align="right" class="zi13">
				职位类型：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.yglx" theme="simple"
					name="employee.employType" cssClass="box1" listKey="key"
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
  var title = "系统管理 > 员工管理 > 编辑";
  $("#titleLabel").html(title);
  $("input:text:first").focus();

  function save(){

 if($("#name").val() == ""){
          $.messager.alert('警告','姓名不能为空！','warning');
          return;
     }
     if($("#idno").val() == ""){
          $.messager.alert('警告','身份证号不能为空！','warning');
          return;
     }
		   	 document.forms[0].action= "<%=path%>/employee!editEmployee.action";
	 document.forms[0].submit();
 } 
</script>
