<%--
/* 系统主页面
**************************************************************
* 程序名	: favorite.jsp
* 建立日期: 2010-07-21
* 模块 : 收藏夹维护页面
* 描述 : 收藏夹维护页面
* 备注 : 
* ------------------------------------------------------------
* 修改历史
* 序号		日期		修改人			修改原因
* 
**************************************************************
*/
--%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%
	// 获得应用上下文
	String webpath = request.getContextPath();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Pragma" content="no-cache">
<!--	<title><bean:message key="customer.title.listpage"/></title>-->
	<title>收藏夹维护页面</title>
	<%-- 引入样式文件 --%>
	<link rel="stylesheet" type="text/css" href="<%=webpath%>/view/base/theme/css/main.css" />
	<link rel="stylesheet" type="text/css" href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css"/>
	<%-- 引入jQuery核心文件 --%>
 	<script type="text/javascript" src="<%=webpath%>/view/base/scripts/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.core.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.widget.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.mouse.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.sortable.min.js"></script>
	<%-- 引入主页面js文件 --%>	
	<!--<script type="text/javascript" src="<%=webpath%>/view/mainframe/scripts/favorite.js"></script>-->
	<style type="text/css">
	#sortable { list-style-type: none; margin: 0; padding: 0; width: 60%; }
	#sortable li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; height: 18px; }
	#sortable li span { position: absolute; margin-left: -1.3em; }
	</style>
	<script type="text/javascript">
	$(function() {
		$("#sortable").sortable();
		$("#sortable").disableSelection();
	});
	</script>
</head>

<body>


<ul id="sortable">
	<li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
		<div><input value="Item1"></input><span class="ui-icon ui-icon-closethick"></span></div>
	</li>
	<li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
		<div><input value="用户维护" title="用户维护"></input><span class="ui-icon ui-icon-closethick"></span></div>
	</li>
	<li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
		<div><input value="新建订单" title="新建订单"></input><span class="ui-icon ui-icon-closethick"></span></div>
	</li>
	<li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
		<div><input value="看了看"title="山东分舵发"></input><span class="ui-icon ui-icon-closethick"></span></div>
	</li>
	<li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
		<div><input value="体育台语言" title="而涂鸦同居"></input><span class="ui-icon ui-icon-closethick"></span></div>
	</li>
	<li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
		<div><input value="尔特人" title="尔特人"></input><span class="ui-icon ui-icon-closethick"></span></div>
	</li>
</ul>

<input type="submit" value="A submit button"/>

</body>
</html>
