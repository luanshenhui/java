<%--
/* 系统主页面
**************************************************************
* 程序名	: index.jsp
* 建立日期: 2010-07-21
* 模块 : 系统主页面
* 描述 : 系统主页面
* 备注 : 
* ------------------------------------------------------------
* 修改历史
* 序号		日期		修改人			修改原因
* 
**************************************************************
*/
--%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.dhc.base.common.consts.CommonConsts" %>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.security.SecurityUserHoder" %>
<%@ page import="com.dhc.base.security.SecurityUser"%>
<%@ page import="org.springframework.security.context.SecurityContextHolder"%>
<%@ page import="com.dhc.base.common.util.SystemConfig" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%
	// 获得应用上下文
	String webpath = request.getContextPath();
	String user = SecurityUserHoder.getCurrentUser().getUsername();
	String system_title = SystemConfig.getSystemTitle();
	String system_short_title = SystemConfig.getSystemShortTitle();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />

	<METAHTTP-EQUIV="Pragma"CONTENT="no-cache">
	<METAHTTP-EQUIV="Cache-Control"CONTENT="no-cache">
	<METAHTTP-EQUIV="Expires"CONTENT="0">
	<title><%=system_title %></title>
	<!-- <title>TSD系统主页面</title>-->
	<%-- 引入样式文件 --%>	
	<link href="<%=webpath%>/view/base/theme/css/main.css" rel="stylesheet" type="text/css" />
	<link href="<%=webpath%>/view/base/theme/css/skin.css" rel="stylesheet" type="text/css" />
	<!--[if IE 6]>
	<script src="<%=webpath%>/view/mainframe/scripts/DD_belatedPNG.js" type="text/javascript"></script>    
		<script>
			DD_belatedPNG.fix('.png,img');
		</script>
    <![endif]-->
	<%-- 引入jQuery核心文件 --%>
 	<script type="text/javascript" src="<%=webpath%>/view/base/scripts/jquery-1.4.2.min.js"></script>
 	<%-- 引入tree js及样式文件 --%>
	<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquery.tree.js"></script>
	<link href="<%=webpath%>/view/base/theme/css/redmond/tree/jquery.tree.css" rel="stylesheet" type="text/css" />
	<%-- 引入主页面js文件 --%>	
	<script type="text/javascript" src="<%=webpath%>/view/mainframe/scripts/indexSize.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/mainframe/scripts/consts_<%=CommonConsts.LANGUAGE%>.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/mainframe/scripts/menu.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/mainframe/scripts/updatePassword.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/mainframe/scripts/index.js"></script>
	
	<script type="text/javascript" src="<%=webpath%>/view/base/plugin/jquery.bgiframe-2.1.1.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.core.min.js"></script>
	<script type="text/javascript"
		src="<%=webpath%>/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.js"></script>
	<script type="text/javascript"
		src="<%=webpath%>/view/base/plugin/jqueryui/jquery.ui.dialog.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.widget.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.mouse.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.draggable.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.position.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.resizable.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.dialog.min.js"></script>
	<script type="text/javascript" src="<%=webpath%>/view/base/ui/minified/jquery.ui.sortable.min.js"></script>
	<script type="text/javascript">
		var BUTTON_SAVE = "<%=CommonConsts.BUTTON_SAVE%>";
		var BUTTON_CLOSE = "<%=CommonConsts.BUTTON_CLOSE%>";
		var MESSAGE_BOX = "<%=OrgI18nConsts.MESSAGE_BOX%>";
		var BUTTON_OK = "<%=CommonConsts.BUTTON_OK%>";
		var CONFIRM_BOX = "<%=OrgI18nConsts.CONFIRM_BOX%>";
		var BUTTON_CANCEL = "<%=CommonConsts.BUTTON_CANCEL%>";
	</script>
	<script src="<%=webpath%>/view/base/plugin/page.set.js"></script>
<style>
html,body{height:100%}
.addFavMenu{position:absolute;right:22px;top:124px; height:18px; width:90px;text-align:center;}
</style>
<style type="text/css">
	#sortableFav { list-style-type: none; margin: 0; padding: 0; width: 80%; }
	#sortableFav li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; font-size: 1.4em; height: 18px; }
	#sortableFav li span { position: absolute; margin-left: -1.3em; }
	</style>
<style type="text/css">
		body { font-size: 62.5%; }
		label, input { display:block; }
		input.text { margin-bottom:12px; width:95%; padding: .4em; }
		fieldset { padding:0; border:0; margin-top:25px; }
		h1 { font-size: 1.2em; margin: .6em 0; }
		div#users-contain { width: 350px; margin: 20px 0; }
		div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
		div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
		.ui-dialog .ui-state-error { padding: .3em; }
		.validateTips { border: 1px solid transparent; padding: 0.3em; }
		
	</style>
</head>
<body oncontextmenu="self.event.returnValue=false" >
<input  id="webpath" value="<%=webpath%>" type="hidden"/>
<div id="container" >
<header>
  <div id="header" class="png" >
	<div class="logo"><img src="<%=webpath%>/view/base/theme/css/redmond/images1009/frame/logo.png" /></div>
	<div class="info link_01 png">
	  <ul>
	    <li id="userShowInfo"></li>
		<li><a href="#" id="toLogonPage"></a></li>
		<li><a href="#" id="toChangePassword"></a></li>
		<!--<li><a href="#" id="toOtherSystem"></a></li>-->
		<li><a href="#" id="toHelpPage"></a></li>
	  </ul>
	</div>
  </div>
<div id="header_hide" class="png"></div>
</header>

<nav>
  <div id="nav">
    <ul class="menu_tab" id="menuDiv"></ul>
	<div class="q_menu png" id="qButtonDiv">
	  <img src="<%=webpath%>/view/base/theme/css/redmond/images1009/frame/q_menu.png" />
	</div>
	<div class="q_menu_list Shadow png" id="qMenuListDiv">
	  <ul id="qMenuDiv">
	    </ul>
	</div>
  </div>
  <div id="nav2">
    <ul class="menu">
       <li><a href="#"></a></li>
    </ul>
  </div>  
  <div id="nav_bottom"></div>
</nav>
  <div id="mainContent">
    <div id="sidebar">    
	<div class="menu" id="left">
	<input id="activeMenuNum" value="0" type="hidden"/>
	 </div>
	</div>
	<div class="sidebar_hide png" id="left-ar">
       <div class="arrow2 png" id="leftArrow"></div>
	</div>
    <div id="siteinfo">
	  <div class="location" id="navId"><%=system_short_title %>＞<span>Home</span></div>
	  <div class="favorite"><div class="back"  id="favMenu">
	  <!--<div class="content link_01"><a href="#" id="addFavMenu">加入收藏</a></div>
	  --></div></div>
	  <!-- <div class="time">现在时间：2010年9月18日 18:00</div>-->
	</div>
	<div id="content">
	  <iframe id="centreFrameId" height="100%" width="100%" frameborder="0" src="black.html"></iframe>
	</div>
  </div>
</div>
<div id="passwordDiv" style="display:none">
	<p id="error" class="validateTips" style="border:0"></p>
	<form>
	<fieldset>
		<label for="oldPassword">旧密码</label>
		<input type="password" name="oldPassword" id="oldPassword" class="text ui-widget-content ui-corner-all" />
		<label for="newPassword">新密码</label>
		<input type="password" name="newPassword" id="newPassword" value="" class="text ui-widget-content ui-corner-all" />
		<label for="password">新密码确认</label>
		<input type="password" name="confirm_password" id="confirm_password" value="" class="text ui-widget-content ui-corner-all" />
	</fieldset>
	</form>
	</div>
<div id="editFavDiv" style="display:none;">
	<ul id="sortableFav"></ul>
</div>
<div id="logOut" style="display:none"></div>
<div style="display:none">
	<div id="PopupBox_L2" title="hello" style="padding:0px 0px 0px 0px;margin:0;border:0;">
		<iframe id="PopupBoxIframe_L2" src="" ></iframe>
	</div>
	<div id="PopupBox_L3" title="hello" style="padding:0px 0px 0px 0px;margin:0;border:0;">
		<iframe id="PopupBoxIframe_L3" src="" ></iframe>
	</div>
	<div id="MessageBox" title="hello" style="padding:0px 0px 0px 0px;margin:0;border:0;">
		<iframe id="MessageBoxIframe" src="" ></iframe>
	</div>
</div>
<input id="menuCount" type="hidden"/>
<input id="targetMenu" type="hidden"/>
<input id="favEditFlag" value="0" type="hidden"/>
<input id="topHiddenFlag" value="0" type="hidden"/>
</body>
</html>
