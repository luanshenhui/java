<%@include file="/common/sub_header.jsp"%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="stock!addStock.action" method="post">
	 <input name='lastIndex' type='hidden' id='lastIndex' value="1" />
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
				商品采购
			</td>
		</tr>


		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				采购编号：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" name="stock.stockNo" id="stockNo" maxlength="30" class="box1" />&nbsp;<font color="red">*</font>


			</td>
			<td width="20%" align="right" class="zi13">
				采购日期：
			</td>
			<td width="30%" class="pad2 zi13">
				<input class="Wdate" type="text" name="stock.stockDate" id="stockDate" 
					onfocus="WdatePicker({readOnly:true})" />&nbsp;<font color="red">*</font>




			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				采购员：
			</td>
			<td width="30%" class="pad2 zi13">
				<s:select list="#request.employeeList" theme="simple" id="member"
					name="stock.member" cssClass="box1" headerKey="" headerValue="请选择"
					listKey="name" listValue="name"></s:select>&nbsp;<font color="red">*</font>

			</td>
			<td width="20%" align="right" class="zi13">
				总金额：
			</td>
			<td width="30%" class="pad2 zi13">

				<input type="text" id="totalMoney" readonly="true" name="stock.totalMoney" maxlength="22"
					class="box1" />


			</td>
		</tr>
		<tr class="bgcolor">
			<td width="20%" align="right" class="zi13">
				备注：
			</td>
			<td width="30%" colspan="3" class="pad2 zi13">
				<textarea rows="5" cols="60" name="stock.remark" maxlength="300"></textarea>



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
						<td width="20">
							<img src="<%=path%>/images/tianjia.gif" width="15" height="15">
						</td>
						<td width="70">
							<a href="#" onclick="addRow();">新增一行</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/tianjia.gif" width="15" height="15">
						</td>
						<td width="70">
							<a href="#" onclick="addGoods();">新增商品</a>
						</td>
					</tr>


				</table>
			</td>
		</tr>
		<tr>
			<td>


				<table id="plan" style="width: 100%; text-align: center;"
					class="simple">
					<thead>
						<tr>
							<th>
								名称
							</th>
						<th>
								单价
							</th>
							<th >
								数量
							</th>
							<th>
								金额
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<table width="100%" border="0" cellpadding="0" cellspacing="1"
								class="bgcolor2 margb5" id="planTable">
		
								<tr class="bgcolor" id="tr0">
									<td style="text-align: center;">
									    <input type="hidden" id="id0" name="stockDeatil[0].goodsId" />
										<input type="text" id="goodsName0" name="stockDeatil[0].goodsName" />
										&nbsp;
							            <a href="#" onclick="selectGood('0');">选择</a>
									</td>
									<td style="text-align: center;">
										<input type="text" id="price0" readonly="true" name="stockDeatil[0].price" />
										&nbsp;
										


									</td>
									<td style="text-align: center;">
										<input type="text" id="num0" name="stockDeatil[0].num" />
										&nbsp;
										


									</td>
									<td style="text-align: center;">
										<input type="text" id="money0" readonly="true" style="color:red" name="stockDeatil[0].money" />
										&nbsp;
										
									</td>
								</tr>



							</table>

						</tr>

					</tbody>
				</table>


				<p>
				<p>
				<p>
				<p>
				<p>
				<p>
				<p>
				<p>
				<p>
				<table width="98%" align="center" border="0" cellspacing="0"
					cellpadding="0">
					<tr>
						<td align="center">
							<input type="button" class="buttonbg" onclick="save();"
								value="保存" />

							&nbsp;&nbsp;&nbsp;
							<input type="button" class="buttonbg" onclick="back();"
								value="返回" />
					</tr>
				</table>
</form>
</body>
</html>


<script>
  var title = "仓库管理 > 商品采购 > 新增";
  $("#titleLabel").html(title);
  $("input:text:first").focus();


function delRow(index){
	var table = document.getElementById("planTable");
	var row = document.getElementById("tr" + index);
	var rowIndex = row.rowIndex;
	
	
	table.deleteRow(rowIndex); 
   
	
    document.getElementById("lastIndex").value = table.rows.length;
  
}



/**
  增加一行
**/
function addRow(){
	var lastIndex = $("#lastIndex").val();
    var addrow = $("#planTable")[0].insertRow();
	addrow.setAttribute("id","tr"+lastIndex);  
  	addrow.className="bgcolor";

    var addcellone = addrow.insertCell();
    addcellone.className="zi13";
    addcellone.setAttribute("align","center");

	addcellone.innerHTML = "<input type='hidden' id='id" + lastIndex + "' name='stockDeatil[" + lastIndex + "].goodsId' /><input name='stockDeatil["+lastIndex+"].goodsName'  id='goodsName" + lastIndex + "' type='text' >   <a href='#' onclick='selectGood(" + lastIndex + ");'>选择</a>" ;

    var addcellone = addrow.insertCell();
    addcellone.className="zi13";
    addcellone.setAttribute("align","center");
	addcellone.innerHTML = "<input name='stockDeatil["+lastIndex+"].price' readonly='true' id='price" + lastIndex + "' type='text'   >" ;
	
	var addcellone = addrow.insertCell();
    addcellone.className="zi13";
    addcellone.setAttribute("align","center");
	addcellone.innerHTML = "<input name='stockDeatil["+lastIndex+"].num' id='num" + lastIndex + "' type='text'  >" ;
	
	

    var addcellone = addrow.insertCell();
    addcellone.className="zi13";
    addcellone.setAttribute("align","center");
	addcellone.innerHTML = "<input name='stockDeatil["+lastIndex+"].money'  id='money" + lastIndex + "'  style= 'color:red' type='text'  readonly='true'  >&nbsp;<a href='#' onclick='delRow("+lastIndex+");'>&nbsp;&nbsp;删除</a>" ;
	
	document.getElementById("lastIndex").value = parseInt(lastIndex) + 1;
	
	
	
}

function addGoods(){
    document.forms[0].action= "<%=path%>/goods!toAddGoods.action";
	 document.forms[0].submit();
   
}
var totalMoney = "0";
function selectGood(index){
	 var url = "<%=path%>/goods!selectGoods.action?index=" + index + "&random=" + new Date();
	 var searchWin = showDialog(url);
     
      if(searchWin){
      	 if(searchWin["id"] != ""){		
				$("#id"+index).val(searchWin["id"]);
				$("#goodsName"+index).val(searchWin["goodName"]);
				$("#price"+index).val(searchWin["outCome"]);
				$("#num"+index).val("1");
				var total = searchWin["outCome"] * 1;
			    $("#money"+index).val(total);
				//$("#goodsName"+index).val(searchWin["goodName"]);
				//totalMoney =  parseInt(totalMoney) + parseInt(total);
				$("#totalMoney").val(totalMoney);   
				$("#num"+index).keyup(function(){   
                    var value = $(this).val();   
                    var total = $("#price"+index).val() * value;
                    //totalMoney = parseInt(totalMoney) + parseInt(total);
                     $("#money"+index).val(total);   
                      //$("#totalMoney").val(totalMoney);   
            
                });
				
				 
		 }
      }
}

 function save(){
       if($("#stockNo").val() == ""){
          $.messager.alert('警告','采购编号不能为空！','warning');
          return;
     }
       if($("#member").val() == ""){
          $.messager.alert('警告','采购员不能为空！','warning');
          return;
     }
            if($("#stockDate").val() == ""){
          $.messager.alert('警告','采购日期不能为空！','warning');
          return;
     }
     document.forms[0].action= "<%=path%>/stock!addStock.action";
	 document.forms[0].submit();
	
 }
</script>

