<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<form name="form1" action="loginuser!queryLoginuser.action"
	method="post">
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
				姓名：
			</td>
			<td width="20%">



				<input type="text" name="loginuser.name" value="${loginuser.name}"
					class="box1" />

			</td>
			<td width="10%" align="right">
				用户类型：
			</td>
			<td width="20%">


				<s:select list="#request.yhlx" theme="simple"
					name="loginuser.userType" headerKey=" " headerValue="全部"
					cssClass="box1" listKey="key" listValue="value"></s:select>

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
							<a href="#" onclick="addLoginuser();">新增</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/bianji.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="editLoginuser();">编辑</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/shanchu.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="delLoginuser();">删除</a>
						</td>
						<td width="20">
							<img src="<%=path%>/images/chakan.gif" width="14" height="14">
						</td>
						<td width="35">
							<a href="#" onclick="viewLoginuser();">查看</a>
						</td>
					</tr>


				</table>
			</td>
		</tr>
		<tr>
			<td>
				<fmt:bundle basename="global_resources">
					<display:table style="width:100%; text-align:center;"
						name="loginuser_list" class="simple" excludedParams="method"
						id="loginuser" pagesize="10" partialList="true" defaultsort="1"
						defaultorder="descending" size="resultSize"
						requestURI="loginuser!queryLoginuser.action">
						<display:column style="width:10%; text-align:center;" title="选择">
							<input type="checkbox" name="id" value="${loginuser.id}"
								headerClass="sortable" />
						</display:column>
						<display:column title="用户名" sortable="true"
							style="width:15%; text-align:center;">
                           ${loginuser.name}
                        </display:column>
						<display:column property="phone" title="电话"
							sortable="true" style="width:15%; text-align:center;" />
						<display:column property="userType" title="用户类型"
							sortable="true" style="width:15%; text-align:center;" />

					</display:table>
				</fmt:bundle>
			</td>
		</tr>
	</table>

	</form>
	</body>
	</html>
	<script>
  var title = "用户管理";
  $("#titleLabel").html(title);
  
  function query(){
      var action = "<%=path%>/loginuser!queryLoginuser.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function addLoginuser(){
      var action = "<%=path%>/loginuser!toAddLoginuser.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function delLoginuser(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要删除的记录！','warning');
    }else{
    	$.messager.confirm('提示','是否确认删除所选记录！',function(r){
			if (r){

			     var action = "<%=path%>/loginuser!delLoginuser.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();
			}
	    });
    }
  }
  
  function editLoginuser(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要编辑的记录！','warning');
    }else{
    	if(num > 1){
    	    $.messager.alert('警告','一次只能编辑一条记录！','warning');
    	}else{

				     var action = "<%=path%>/loginuser!toEditLoginuser.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();

    	}
    }
  }
  
  function viewLoginuser(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要查看的记录！','warning');
    }else{
    	if(num > 1){
    	   $.messager.alert('警告','一次只能查看一条记录！','warning');
    	}else{


						     var action = "<%=path%>/loginuser!viewLoginuser.action";
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