<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="sales!querySales.action" method="post">
	<input type="hidden" id="totalPage" value="${totalPage}" />
	<table cellspacing="0" cellpadding="0" width="98%" align="center"
		border="0" class="margtb5">
		<tr>
			<td align="left" class="padl5 lan12">
				<img src="<%=path%>/images/img-11.gif" width="12" height="12">
				<span id="titleLabel"></span>
			</td>
		</tr>
	</table>

	<table cellspacing="3" cellpadding="0" width="98%" align="center"
		border="0" class="kuang2 margtb5 hei12">

		<tr>
			<td width="10%" align="right">
				采购日期：
			</td>
			<td width="40%">



				<input class="Wdate" type="text" name="detail.startDate" id="startDate" value="<s:date name="detail.startDate" format="yyyy-MM-dd" />" 
					onfocus="WdatePicker({readOnly:true})" />至
					<input class="Wdate" type="text" name="detail.endDate" id="endDate" value="<s:date name="detail.endDate" format="yyyy-MM-dd" />" 
					onfocus="WdatePicker({readOnly:true})" />

			</td>
			
		
			<td width="60%" align="left">
				<input type="button" id="but_query" class="buttonbg"
					style="cursor: hand;" onclick="query();" value="查询" />
			</td>
		</tr>
	</table>


	<p>
	<p>
	<p>
	<table cellspacing="0" cellpadding="0" width="98%" align="center"
		border="0" class="margb5">
		
		<tr>
			<td>


				<table id="stock" style="width: 100%; text-align: center;"
					class="simple">
					<thead>
						<tr>
							<th>
								采购单号
							</th>
						     <th>
								采购日期
							</th>
							<th>
								商品编号
							</th>
							<th>
								商品名称
							</th>
							<th>
								采购单价(元)
							</th>
							<th>
								采购数量
							</th>
							<th>
								总金额(元)
							</th>
					        
							 <th>
								采购员
							</th>
						</tr>
					</thead>
					<tbody>
						<s:iterator value="#request.staticList" id="detailTemp"
							status="status">
							<tr class="odd">
                            <td style="width: 10%; text-align: center;">
									${detailTemp.stockNo}
								</td>
								<td style="width: 15%; text-align: center;">
								
								    <fmt:formatDate value="${detailTemp.stockDate}"/>
									
								</td>
								<td style="width: 10%; text-align: center;">
									${detailTemp.goodNo}
								</td>
								<td style="width: 10%; text-align: center;">
									${detailTemp.goodsName}
								</td>
								
								<td style="width: 10%; text-align: center;">
									${detailTemp.price}
								</td>
								<td style="width: 10%; text-align: center;">
									${detailTemp.num}
								</td>
								<td style="width: 10%; text-align: center;">
									${detailTemp.money}
								</td>
								
								<td style="width: 10%; text-align: center;">
									${detailTemp.memberName}
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
	</form>
	</body>
	</html>
	<script>
  var title = "财务管理 > 采购金额统计";
  $("#titleLabel").html(title);
  
  function query(){
      var action = "<%=path%>/stock!staticStock.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function addSales(){
      var action = "<%=path%>/sales!toAddSales.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function delSales(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要删除的记录！','warning');
    }else{
    	$.messager.confirm('提示','是否确认删除所选记录！',function(r){
			if (r){

			     var action = "<%=path%>/sales!delSales.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();
			}
	    });
    }
  }
  
  function editSales(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要编辑的记录！','warning');
    }else{
    	if(num > 1){
    	    $.messager.alert('警告','一次只能编辑一条记录！','warning');
    	}else{

				     var action = "<%=path%>/sales!toEditSales.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();

    	}
    }
  }
  
  function viewSales(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要查看的记录！','warning');
    }else{
    	if(num > 1){
    	   $.messager.alert('警告','一次只能查看一条记录！','warning');
    	}else{


						     var action = "<%=path%>/sales!viewSales.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();
    	}
    }
  }
  
  $(document).ready(function(){
	 var $messageInfo = $("#messageInfo").val();
	 if($messageInfo != null && $messageInfo != ""){
		 $.messager.show({
			title:'提示',
			msg:$messageInfo,
			timeout:2000,
			showType:'slide'
		 });
		 $("#messageInfo").val("");
	 }
  });
  
  
</script>