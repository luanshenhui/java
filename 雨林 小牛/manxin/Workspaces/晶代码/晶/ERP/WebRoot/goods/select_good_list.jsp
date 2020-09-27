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

<form name="form1" action="goods!selectGoods.action"
	method="post">
	<input type="hidden" id="totalPage" value="${totalPage}" />
	<input type="hidden" id="index" value="${index}" />
	
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
			<td>
			
				
				
				
				<fmt:bundle basename="global_resources">
					<display:table style="width:100%; text-align:center;"
						name="goods_list" class="simple" excludedParams="method"
						id="goods" pagesize="10" partialList="true" defaultsort="1"
						defaultorder="descending" size="resultSize"
						requestURI="goods!queryGoods.action">
						<display:column title="商品编号" sortable="true"
							style="width:5%; text-align:center;">
                          
                             <a href="#" onclick="selectGood('${goods.id}','${goods.goodName}','${goods.outCome}')">   ${goods.goodNo} </a>
                        </display:column>
						<display:column property="goodName" title="商品名称"
							sortable="true" style="width:5%; text-align:center;" />
						<display:column property="goodType" title="类型"
							sortable="true" style="width:5%; text-align:center;" />
						<display:column property="brand" title="品牌"
							sortable="true" style="width:5%; text-align:center;" />
						<display:column property="goodStyle" title="规格"
							sortable="true" style="width:5%; text-align:center;" />
						<display:column property="goodUnit" title="单位"
							sortable="true" style="width:5%; text-align:center;" />
						<display:column property="inCome" title="进货价"
							sortable="true" style="width:5%; text-align:center;" />
						<display:column property="outCome" title="售价"
							sortable="true" style="width:5%; text-align:center;" />
						<display:column property="goodNum" title="库存数量"
							sortable="true" style="width:5%; text-align:center;" />

					</display:table>
				</fmt:bundle>
			</td>
		</tr>
	</table>

	</form>
	</body>
	</html>
	<script>
  var title = "商品列表";
  $("#titleLabel").html(title);
  
  function query(){
      var action = "<%=path%>/goods!selectGoods.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function addMarketperson(){
      var action = "<%=path%>/marketperson!toAddMarketperson.action";
      document.forms[0].action= action;
      document.forms[0].submit();
  }
  
  function delMarketperson(){
    var num = isChecked();
    if(num==0){
    	$.messager.alert('警告','请选择要删除的记录！','warning');
    }else{
    	$.messager.confirm('提示','是否确认删除所选记录！',function(r){
			if (r){

			     var action = "<%=path%>/marketperson!delMarketperson.action";
			      document.forms[0].action= action;
			      document.forms[0].submit();
			}
	    });
    }
  }
  
this.returnValue = new Array();
this.returnValue["id"] = "";
this.returnValue["goodName"] = "";
this.returnValue["outCome"] = "0";
this.returnValue["index"] = "0"; 
  
  function selectGood(id,goodName,outCome){
    var index = $("#index").val();
	this.returnValue["id"] = id;
	this.returnValue["goodName"] = goodName;
	this.returnValue["outCome"] = outCome;
	this.returnValue["index"] = index;
	window.close();
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