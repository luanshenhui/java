
<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="member!editMember.action" method="post">
	<input type="hidden" name="member.id" value="${member.id}" />
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
				会员信息管理
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				姓名：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${member.name}" name="member.name"
					maxlength="30" id="name" class="box1" />&nbsp;<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				性别：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.sex" theme="simple" name="member.sex"
					cssClass="box1" listKey="key" listValue="value"></s:select>

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				身份证号：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${member.idno}" name="member.idno"
					maxlength="30" class="box1" />


			</td>
			<td width="20%" align="right" class="zi13">
				出生日期：
			</td>
			<td width="30%" class="pad2 zi13">

				<input class="Wdate"
					value="<s:date name="member.birthday" format="yyyy-MM-dd" />"
					type="text" value="" name="member.birthday"
					onfocus="WdatePicker({readOnly:true})" />


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				电话：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${member.telphone}" id="telphone" name="member.telphone"
					maxlength="30" class="box1" />&nbsp;<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				地址：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${member.address}" name="member.address"
					maxlength="100" class="box1" />


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
  var title = "会员管理 > 会员信息管理 > 编辑";
  $("#titleLabel").html(title);
  $("input:text:first").focus();

  function save(){
if($("#name").val() == ""){
          $.messager.alert('警告','姓名不能为空！','warning');
          return;
     }
     if($("#telphone").val() == ""){
          $.messager.alert('警告','电话不能为空！','warning');
          return;
     }

		   	 document.forms[0].action= "<%=path%>/member!editMember.action";
	 document.forms[0].submit();
 } 
</script>
