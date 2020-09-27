<%@include file="/common/sub_header.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="stockDetail!queryStockDetail.action" method="post">
     <input type="hidden" id="totalPage" value="${totalPage}"/>
     <table cellspacing="0" cellpadding="0" width="98%" align="center"  border="0" class="margtb5">
       <tr>
          <td align="left" class="padl5 lan12"><img src="<%=path%>/images/img-11.gif" width="12" height="12"><span id="titleLabel"></span></td>
       </tr>
     </table>

     <table cellspacing="3" cellpadding="0" width="98%" align="center"  border="0" class="kuang2 margtb5 hei12">

	     <tr>
	                     <td width="10%" align="right">stock id：</td>
	       <td width="20%">
	                

		   		   
		      			  <input type="text" name="stockDetail.stockId" value="${stockDetail.stockId}" class="box1" />
		                         		   
	       </td>
	                      <td width="10%" align="right">goods id：</td>
	       <td width="20%">
	                

		   		   
		      			  <input type="text" name="stockDetail.goodsId" value="${stockDetail.goodsId}" class="box1" />
		                         		   
	       </td>
	                      <td width="10%" align="right">num：</td>
	       <td width="20%">
	                

		   		   
		      			  <input type="text" name="stockDetail.num" value="${stockDetail.num}" class="box1" />
		                         		   
	       </td>
	                      <td width="10%" align="right">money：</td>
	       <td width="20%">
	                

		   		   
		      			  <input type="text" name="stockDetail.money" value="${stockDetail.money}" class="box1" />
		                         		   
	       </td>
	                      <td width="65%" align="left">
	      <input type="button" id="but_query" class="buttonbg" style="cursor: hand;" onclick="query();" value="查询" />
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
							<a href="#" onclick="addStockDetail();">新增</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/bianji.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="editStockDetail();">编辑</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/shanchu.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="delStockDetail();">删除</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/chakan.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="viewStockDetail();">查看</a>
						</td>
					</tr>


				</table>
			</td>
		</tr>
		<tr>
			<td>
	<fmt:bundle basename="global_resources">
		<display:table style="width:100%; text-align:center;" name="stockdetail_list" class="simple" excludedParams="method" id="stockdetail" pagesize="10" partialList="true" defaultsort="1" defaultorder="descending" size="resultSize" requestURI="stockDetail!queryStockDetail.action"  > 			       
		        						<display:column style="width:5%; text-align:center;" title="选择" >
			    <input type="checkbox" name="id" value="${stockdetail.id}" headerClass="sortable"/>
			</display:column>
																																        							                <display:column  title="${field.label}" sortable="true" style="width:5%; text-align:center;">
                           ${stockdetail.stockId}
                        </display:column>
								        															                                                                            <display:column property="goodsId" title="${field.label}"  sortable="true" style="width:5%; text-align:center;"/>
			                          					        															                                                                            <display:column property="num" title="${field.label}"  sortable="true" style="width:5%; text-align:center;"/>
			                          					        															                                                                            <display:column property="money" title="${field.label}"  sortable="true" style="width:5%; text-align:center;"/>
			                          					        			                   
	       </display:table>
         </fmt:bundle>
           </td>
	</tr>
   </table>

     </form>
	</body>
</html>
<script>
  var title = "系统管理 > 权限管理 > 角色管理";
  $("#titleLabel").html(title);
  
  function query(){
      var action = "<%=path%>/stockDetail!queryStockDetail.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function addStockDetail(){
      var action = "<%=path%>/stockDetail!toAddStockDetail.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function delStockDetail(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要删除的记录！','warning');
    }else{
    	$.messager.confirm('提示','是否确认删除所选记录！',function(r){
			if (r){

			     var action = "<%=path%>/stockDetail!delStockDetail.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();
			}
	    });
    }
  }
  
  function editStockDetail(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要编辑的记录！','warning');
    }else{
    	if(num > 1){
    	    $.messager.alert('警告','一次只能编辑一条记录！','warning');
    	}else{

				     var action = "<%=path%>/stockDetail!toEditStockDetail.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();

    	}
    }
  }
  
  function viewStockDetail(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要查看的记录！','warning');
    }else{
    	if(num > 1){
    	   $.messager.alert('警告','一次只能查看一条记录！','warning');
    	}else{


						     var action = "<%=path%>/stockDetail!viewStockDetail.action";
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