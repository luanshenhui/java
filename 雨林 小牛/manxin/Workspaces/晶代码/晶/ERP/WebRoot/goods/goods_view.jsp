


<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="goods!viewGoods.action" method="post">
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
				库存查询
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				编号：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.goodNo}

			</td>
			<td width="20%" align="right" class="zi13">
				商品名称：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.goodName}

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				类型：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.goodType}

			</td>
			<td width="20%" align="right" class="zi13">
				所属品牌：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.brand}

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				型号：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.goodStyle}

			</td>
			<td width="20%" align="right" class="zi13">
				单位：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.goodUnit}

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				进货价：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.inCome}

			</td>
			<td width="20%" align="right" class="zi13">
				销售价：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.outCome}

			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				厂商：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.factory}

			</td>
			<td width="20%" align="right" class="zi13">
				数量：
			</td>
			<td width="30%" class="pad2 zi13">
				${goods.goodNum}

			</td>
		
		</tr>
		<tr class="bgcolor">
				<td width="20%" align="right" class="zi13">
				备注：
			</td>
			<td width="30%"  colspan="3" class="pad2 zi13">
				${goods.remark}

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
  var title = "仓库管理 > 库存查询 > 查看";
  $("#titleLabel").html(title);

</script>
