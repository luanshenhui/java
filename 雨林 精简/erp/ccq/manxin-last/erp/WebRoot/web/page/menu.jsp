<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
     <base href="<%=basePath%>">
    <title>系统导航</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" href="web/css/base.css" type="text/css" />
	<link rel="stylesheet" href="web/css/menu.css" type="text/css" />
	<style type="text/css">
	    div {
			padding:0px;
			margin:0px;
		}
		
		body {
		 scrollbar-base-color:#bae87c;
		 scrollbar-arrow-color:#FFFFFF;
		 scrollbar-shadow-color:#c1ea8b;
		 padding:0px;
		 margin:auto;
		 text-align:center;
		 background:#1a6892 url(../img/background.bmp) repeat-x;
		}
		
		dl.bitem {
			width:148px;
			margin:0px 0px 5px 4px;
		}
		
		dl.bitem dt {
		  background:url(/erp/web/img/main_47.gif);
		  height:26px;
		  line-height:26px;
		  text-align:center;
		  cursor:pointer;
		}
		
		dl.bitem dd {
		  padding:3px 3px 3px 3px;
		  background-color:#fff;
		}
		
		.fllct
		{
			float:left;
			
			width:90px;
		}
		
		.flrct
		{
			padding-top:3px;
			float:left;
		}
		
		div.items
		{
			line-height:22px;
			background:url(/erp/web/img/arr4.gif) no-repeat 10px 9px;
		}
		
		span.items
		{
			padding:10px 0px 10px 22px;
			background:url(/erp/web/img/arr4.gif) no-repeat 10px 12px;
		}
		
		ul {
		  padding-top:3px;
		}
		
		li {
		  height:22px;
		}
		
		.sitemu li {
			padding:0px 0px 0px 22px;
			line-height:24px;
			background:url(/erp/web/img/arr4.gif) no-repeat 10px 9px;
		}
	</style>
	<script language='javascript'>var curopenItem = '1';</script>
	<script language="javascript" type="text/javascript" src="/erp/web/js/menu.js"></script>
	<base target="main" />
	
	<script type="text/javascript">
	
	function showHide(ulId) {
	
	// 取得无序列表
	var ul=document.getElementById(ulId);
	
	// 原隐藏即显示，原显示即隐藏
	if(ul.style.display=="block" || ul.style.display=="" ){
		ul.style.display="none";
	}
	else{
		ul.style.display="block";
	}
	
	}
	
	</script>
	
  </head>
  
  <body target="main">
  
	<table width='99%' height="100%" border='0' cellspacing='0' cellpadding='0'>
	  <tr>
	    <td style='padding-left:3px;padding-top:8px' valign="top">
	      <dl class='bitem'>
	        <dt onClick='showHide("items1_1")'><b>个人资料管理</b></dt>
	        <dd style='display:block' class='sitem' id='items1_1'>
	          <ul class='sitemu'>
	              <li><a target='main' href="web/page/persontview.jsp">查看信息</a> </li>
	              <li><a target='main' href="web/page/personidet.jsp">修改信息</a> </li>
	              <li><a target='main'>修改密码</a> </li>
	              <li><a target="_parent">注销退出</a> </li>
	          </ul>
	        </dd>
	      </dl>
	      

	      <dl class='bitem'>
	        <dt onClick='showHide("items1_2")'><b>基本信息管理</b></dt>
	        <dd style='display:block' class='sitem' id='items1_2'>
	          <ul class='sitemu'>
	              <li><a target='main'>类别管理</a> </li>
	              <li><a target='main'>商品管理</a> </li>
	              <li><a target='main'>供应商管理</a> </li>
	              <li><a target='main'>客户管理</a> </li>
	          </ul>
	        </dd>
	      </dl>	  
	      
	          
	      <dl class='bitem'>
	        <dt onClick='showHide("items1_3")'><b>进销存管理</b></dt>
	        <dd style='display:block' class='sitem' id='items1_3'>
	          <ul class='sitemu'>
	              <li><a target='main'>进货管理</a> </li>
	              <li><a target='main'>销售管理</a> </li>
	              <li><a target='main'>仓库管理</a> </li>
	          </ul>
	        </dd>
	      </dl>	 
	      
	           
	      <dl class='bitem'>
	        <dt onClick='showHide("items1_3")'><b>用户管理</b></dt>
	        <dd style='display:block' class='sitem' id='items1_3'>
	          <ul class='sitemu'>
	              <li><a target='main'>用户管理</a> </li>
	          </ul>
	        </dd>
	      </dl>	 
	           
		  </td>
	  </tr>
	</table>
  </body>
</html>
