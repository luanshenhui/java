


<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="loginuser!viewLoginuser.action" method="post">
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
				姓名：
			</td>
			<td width="30%" class="pad2 zi13">
				${loginuser.name}

			</td>
			<td width="20%" align="right" class="zi13">
				密码：
			</td>
			<td width="30%" class="pad2 zi13">
				****

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				电话：
			</td>
			<td width="30%" class="pad2 zi13">
				${loginuser.phone}

			</td>
			<td width="20%" align="right" class="zi13">
				用户类型：
			</td>
			<td width="30%" class="pad2 zi13">
				${loginuser.userType}

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
  var title = "用户管理 > 查看";
  $("#titleLabel").html(title);

</script>
