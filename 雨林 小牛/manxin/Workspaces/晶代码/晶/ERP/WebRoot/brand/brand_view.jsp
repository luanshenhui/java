


<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="brand!viewBrand.action" method="post">
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
				品牌信息管理
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				编号：
			</td>
			<td width="30%" class="pad2 zi13">
				${brand.num}

			</td>
			<td width="20%" align="right" class="zi13">
				品牌名称：
			</td>
			<td width="30%" class="pad2 zi13">
				${brand.name}

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				厂商：
			</td>
			<td width="30%" class="pad2 zi13">
				${brand.factory}

			</td>
			<td width="20%" align="right" class="zi13">
				联系方式：
			</td>
			<td width="30%" class="pad2 zi13">
				${brand.phone}

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				地址：
			</td>
			<td width="30%" class="pad2 zi13">
				${brand.address}

			</td>
			<td width="20%" align="right" class="zi13">
				备注：
			</td>
			<td width="30%" class="pad2 zi13">
				${brand.remark}

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
  var title = "仓库管理 > 品牌信息管理 > 查看";
  $("#titleLabel").html(title);

</script>
