<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="goods!queryGoods.action" method="post">
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
				编号：
			</td>
			<td width="20%">



				<input type="text" name="goods.goodNo" value="${goods.goodNo}"
					class="box1" />

			</td>
			<td width="10%" align="right">
				商品名称：
			</td>
			<td width="20%">



				<input type="text" name="goods.goodName" value="${goods.goodName}"
					class="box1" />

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
							<img src="<%=path%>/images/chakan.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="viewGoods();">查看</a>
						</td>
					</tr>


				</table>
			</td>
		</tr>
		<tr>
			<td>
				<fmt:bundle basename="global_resources">
					<display:table style="width:100%; text-align:center;"
						name="goods_list" class="simple" excludedParams="method"
						id="goods" pagesize="10" partialList="true" defaultsort="1"
						defaultorder="descending" size="resultSize"
						requestURI="goods!queryGoods.action">
						<display:column style="width:5%; text-align:center;" title="选择">
							<input type="checkbox" name="id" value="${goods.id}"
								headerClass="sortable" />
						</display:column>
						<display:column title="商品编号" sortable="false"
							style="width:5%; text-align:center;">
                           ${goods.goodNo}
                        </display:column>
						<display:column property="goodName" title="商品名称"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="goodType" title="类型"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="brand" title="品牌"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="goodStyle" title="规格"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="goodUnit" title="单位"
							sortable="false" style="width:10%; text-align:center;" />
					
						<display:column property="goodNum" title="库存数量"
							sortable="false" style="width:10%; text-align:center; color:red" />

					</display:table>
				</fmt:bundle>
			</td>
		</tr>
	</table>

	</form>
	</body>
	</html>
	<script>
  var title = "仓库管理 > 库存查询";
  $("#titleLabel").html(title);
  
  function query(){
      var action = "<%=path%>/goods!queryGoods.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function addGoods(){
      var action = "<%=path%>/goods!toAddGoods.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function delGoods(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要删除的记录！','warning');
    }else{
    	$.messager.confirm('提示','是否确认删除所选记录！',function(r){
			if (r){

			     var action = "<%=path%>/goods!delGoods.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();
			}
	    });
    }
  }
  
  function editGoods(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要编辑的记录！','warning');
    }else{
    	if(num > 1){
    	    $.messager.alert('警告','一次只能编辑一条记录！','warning');
    	}else{

				     var action = "<%=path%>/goods!toEditGoods.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();

    	}
    }
  }
  
  function viewGoods(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要查看的记录！','warning');
    }else{
    	if(num > 1){
    	   $.messager.alert('警告','一次只能查看一条记录！','warning');
    	}else{


						     var action = "<%=path%>/goods!viewGoods.action";
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