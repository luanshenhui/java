
<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="sales!editSales.action" method="post">
	<input type="hidden" name="sales.id" value="${sales.id}" />
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
				商品销售
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				会员卡号：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${sales.memberNo}" readonly="true" name="sales.memberNo"
					maxlength="30" class="box1" />


			</td>
			<td width="20%" align="right" class="zi13">
				姓名：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${sales.memberName}" readonly="true"
					name="sales.memberName" maxlength="30" class="box1" />


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				销售时间：
			</td>
			<td width="30%" class="pad2 zi13">

				<input class="Wdate" id="salesDate"
					value="<s:date name="sales.salesDate" format="yyyy-MM-dd" />"
					type="text" value="" name="sales.salesDate"
					onfocus="WdatePicker({readOnly:true})" />&nbsp;<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				销售员：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${sales.employee}" name="sales.employee" id="employee"
					maxlength="30" class="box1" />&nbsp;<font color="red">*</font>


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				总金额：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${sales.totalMoney}" readonly="true"
					name="sales.totalMoney" maxlength="22" class="box1" />


			</td>
			<td width="20%" align="right" class="zi13">
				备注：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" value="${sales.remark}" name="sales.remark"
					maxlength="300" class="box1" />


			</td>
		</tr>

	</table>

		<p>
	<p>
	<p>
	<table cellspacing="0" cellpadding="0" width="98%" align="center"
		border="0" class="margb5">
		<tr>
			<td colspan="8" class="bgcolor2 padlr5">
				<table border="0" cellspacing="0" cellpadding="0" class="lan13b">
					<tr>
						<td width="80">
							商品信息
						</td>

					</tr>


				</table>
			</td>
		</tr>
		<tr>
			<td>


				<table id="stock" style="width: 100%; text-align: center;"
					class="simple">
					<thead>
						<tr>

							<th>
								商品名称
							</th>
							<th>
								单价（元）
							</th>
							<th>
								数量
							</th>
							<th>
								金额（元）
							</th>
						</tr>
					</thead>
					<tbody>
						<s:iterator value="#request.listDetail" id="detail1"
							status="status">
							<tr class="odd">

								<td style="width: 15%; text-align: center;">
									${detail1.goodsName}
								</td>
								<td style="width: 10%; text-align: center;">
									${detail1.price}
								</td>
								<td style="width: 10%; text-align: center;">
									${detail1.num}
								</td>
								<td style="width: 10%; text-align: center;">
									${detail1.money}
								</td>
							</tr>
							</s:iterator>
					</tbody>
				</table>

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
  var title = "销售管理 > 商品销售 > 编辑";
  $("#titleLabel").html(title);
  $("input:text:first").focus();

  function save(){
       if($("#salesDate").val() == ""){
          $.messager.alert('警告','销售日期不能为空！','warning');
          return;
     }
            if($("#employee").val() == ""){
          $.messager.alert('警告','销售员不能为空！','warning');
          return;
     }

		   	 document.forms[0].action= "<%=path%>/sales!editSales.action";
	 document.forms[0].submit();
 } 
</script>
