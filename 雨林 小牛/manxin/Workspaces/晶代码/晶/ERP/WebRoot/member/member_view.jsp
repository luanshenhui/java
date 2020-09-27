


<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="member!viewMember.action" method="post">
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
				${member.name}

			</td>
			<td width="20%" align="right" class="zi13">
				性别：
			</td>
			<td width="30%" class="pad2 zi13">
				${member.sex}

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				身份证号：
			</td>
			<td width="30%" class="pad2 zi13">
				${member.idno}

			</td>
			<td width="20%" align="right" class="zi13">
				出生日期：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:date name="member.birthday" format="yyyy-MM-dd" />



			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				电话：
			</td>
			<td width="30%" class="pad2 zi13">
				${member.telphone}

			</td>
			<td width="20%" align="right" class="zi13">
				地址：
			</td>
			<td width="30%" class="pad2 zi13">
				${member.address}

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

				<input type="button" class="buttonbg" onclick="back();" value="返回" />
		</tr>
	</table>

</form>
</body>
</html>


<script>
  var title = "会员管理 > 会员信息管理 > 查看";
  $("#titleLabel").html(title);

</script>
