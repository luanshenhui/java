
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://displaytag.sf.net/el" prefix="display"%>
<%@ taglib uri="/tags/fmt" prefix="fmt"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
   String path = request.getContextPath();
   String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>xua选择商品</title>
 <base target=_self />
<LINK href="<%=path%>/theme/sophia_style.css" type="text/css" rel="stylesheet">
<LINK href="<%=path%>/js/jquery/plugin/jquery-easyui/themes/default/easyui.css" type="text/css" rel="stylesheet">
<LINK href="<%=path%>/js/jquery/plugin/jquery-easyui/themes/icon.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<%=path%>/js/jquery/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/xiehui.js"></script>
<script type="text/javascript" src="<%=path%>/js/jquery/plugin/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/jquery/plugin/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=path%>/js/calendar/WdatePicker.js"></script>


<style>
   html { overflow-x: hidden; overflow-y: auto; }
</style>
</head>
<body>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<form name="form1" action="member!queryMember.action" method="post">
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



				<input type="text" name="member.name" value="${member.name}"
					class="box1" />

			</td>
			<td width="10%" align="right">
				身份证号：
			</td>
			<td width="20%">



				<input type="text" name="member.idno" value="${member.idno}"
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
			<td>
				<fmt:bundle basename="global_resources">
					<display:table style="width:100%; text-align:center;"
						name="member_list" class="simple" excludedParams="method"
						id="member" pagesize="10" partialList="true" defaultsort="1"
						defaultorder="descending" size="resultSize"
						requestURI="member!queryMember.action">
						<display:column title="会员卡号" sortable="false"
							style="width:15%; text-align:center;">
                          <a href="#" onclick="selectMember('${member.cardNo}','${member.name}');"> ${member.cardNo}</a>
                        </display:column>
                        <display:column property="name" title="姓名"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="sex" title="性别"
							sortable="false" style="width:10%; text-align:center;" />
						<display:column property="idno" title="身份证号"
							sortable="false" style="width:15%; text-align:center;" />
						<display:column property="telphone" title="联系方式"
							sortable="false" style="width:15%; text-align:center;" />

					</display:table>
				</fmt:bundle>
			</td>
		</tr>
	</table>

	</form>
	</body>
	</html>
	<script>
  var title = "选择会员";
  $("#titleLabel").html(title);
  
  function query(){
      var action = "<%=path%>/member!selectMember.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function addMember(){
      var action = "<%=path%>/member!toAddMember.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function delMember(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要删除的记录！','warning');
    }else{
    	$.messager.confirm('提示','是否确认删除所选记录！',function(r){
			if (r){

			     var action = "<%=path%>/member!delMember.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();
			}
	    });
    }
  }
  
  function editMember(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要编辑的记录！','warning');
    }else{
    	if(num > 1){
    	    $.messager.alert('警告','一次只能编辑一条记录！','warning');
    	}else{

				     var action = "<%=path%>/member!toEditMember.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();

    	}
    }
  }
  
  function viewMember(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要查看的记录！','warning');
    }else{
    	if(num > 1){
    	   $.messager.alert('警告','一次只能查看一条记录！','warning');
    	}else{


						     var action = "<%=path%>/member!viewMember.action";
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
  
    
this.returnValue = new Array();
this.returnValue["no"] = "";
this.returnValue["name"] = "";

  
  function selectMember(no,name){
	this.returnValue["no"] = no;
	this.returnValue["name"] = name;
	window.close();
}
  
  
</script>