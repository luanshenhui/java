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
				会员卡号：
			</td>
			<td width="20%">



				<input type="text" name="sales.memberNo" value="${sales.memberNo}"
					class="box1" />

			</td>
			<td width="10%" align="right">
				姓名：
			</td>
			<td width="20%">



				<input type="text" name="sales.memberName"
					value="${sales.memberName}" class="box1" />

			</td>
			<td width="10%" align="right">
				销售员：
			</td>
			<td width="20%">

				<s:select list="#request.employeeList" theme="simple"
					name="sales.employee" cssClass="box1" headerKey=""
					headerValue="请选择" listKey="name" listValue="name"></s:select>


			</td>
			<td width="65%" align="left">
				<input type="button" id="but_query" class="buttonbg"
					style="cursor: hand;" onclick="query();" value="查询" />
			</td>
		</tr>
	</table>


	<table cellspacing="0" cellpadding="0" width="98%" align="center"
		border="0" class="margb5">
		<tr>
			<td colspan="8" class="bgcolor2 padlr5">
				<table border="0" cellspacing="0" cellpadding="0" class="lan13b">
					<tr>
						<td width="20">
							<img src="<%=path%>/images/tianjia.gif" width="15" height="15">
						</td>
						<td width="35">
							<a href="#" onclick="addSales();">新增</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/bianji.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="editSales();">编辑</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/shanchu.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="delSales();">删除</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/chakan.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="viewSales();">查看</a>
						</td>
					</tr>


				</table>
			</td>
		</tr>
		<tr>
			<td>
				<fmt:bundle basename="global_resources">
					<display:table style="width:100%; text-align:center;"
						name="sales_list" class="simple" excludedParams="method"
						id="sales" pagesize="10" partialList="true" defaultsort="1"
						defaultorder="descending" size="resultSize"
						requestURI="sales!querySales.action">
						<display:column style="width:5%; text-align:center;" title="选择">
							<input type="checkbox" name="id" value="${sales.id}"
								headerClass="sortable" />
						</display:column>
						<display:column title="会员卡号" sortable="false"
							style="width:10%; text-align:center;">
                           ${sales.memberNo}
                        </display:column>
						<display:column property="memberName" title="会员姓名"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="salesDate" format="{0,date,yyyy-MM-dd}"
							title="销售日期" sortable="false"
							style="width:10%; text-align:center;" />
						<display:column property="employee" title="销售员"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="totalMoney" title="金额(元)"
							sortable="false" style="width:10%; text-align:center;" />

					</display:table>
				</fmt:bundle>
			</td>
		</tr>
	</table>

	</form>
	</body>
	</html>
	<script>
  var title = "销售管理 > 商品销售";
  $("#titleLabel").html(title);
  
  function query(){
      var action = "<%=path%>/sales!querySales.action";
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