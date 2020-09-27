<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2016/6/7
  Time: 14:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
<title>集成管控平台</title>
<jsp:include page="../../import.jsp" flush="true" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="/Apollo//zTree_v3/css/demo.css" type="text/css">
		<link rel="stylesheet" href="/Apollo/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
			<script type="text/javascript" src="/Apollo/zTree_v3/js/jquery.ztree.core-3.5.js"></script>
			<script type="text/javascript" src="/Apollo/portal/layout.js">
				
			</script>
			<script type="text/javascript" src="/Apollo/portal/menuData.js">
				
			</script>
</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no">
	<noscript>
		<div
			style="position: absolute; z-index: 100000; height: 2046px; top: 0px; left: 0px; width: 100%; background: white; text-align: center;">
			<img src="images/noscript.gif" alt='抱歉，请开启脚本支持！' />
		</div>
	</noscript>
	<div region="north" split="true" border="false"
		style="overflow: hidden; height: 30px; background: #7f99be repeat-x center 50%; line-height: 20px; color: #fff; font-family: Verdana, 微软雅黑, 黑体">
		<span style="float: right; padding-right: 20px;" class="head">欢迎 <span id="userNameSpan"></span> <%-- <a href="#" id="editpass">修改密码</a> --%>
			<a href="javascript:logOut();">安全退出</a> <select id="THEME_CHANGE">
				<option value="default">切换主题</option>
				<option value="black">black</option>
				<option value="bootstrap">bootstrap</option>
				<option value="cupertino">cupertino</option>
				<option value="darkhive">darkhive</option>
				<option value="metro">metro</option>
				<option value="peppergrinder">peppergrinder</option>
				<option value="sunny">sunny</option>
				<option value="default">default</option>
		</select>
		</span> <span style="padding-left: 10px; font-size: 16px;"><img src="" width="20" height="20" align="absmiddle" />集成管控平台</span>
	</div>
	<div region="south" split="true" style="height: 30px; background: #D2E0F2;">
		<div class="footer">瑞金麟 -- 技术中心</div>
	</div>
	<div region="west" hide="true" split="true" title="导航菜单" style="width: 275px;" id="west">
		<ul id="treeDemo" class="ztree"></ul>
		<div id="rMenu" style="position: absolute;">
			<%--visibility:absolute;--%>
		</div>
	</div>
	<div id="mainPanle" region="center" style="background: #eee; overflow-y: hidden">
		<div id="index_centerTabs" class="easyui-tabs" fit="true" border="false">
			<div title="欢迎使用" style="padding: 20px; overflow: hidden; color: red;">
				<h1 style="font-size: 24px;">欢迎使用集成管控平台</h1>
			</div>
		</div>
	</div>

	<%--<div id="editPasswordWin" class="easyui-window" title="修改密码" collapsible="false" minimizable="false"
     maximizable="false" icon="icon-save" closed = "true"  style="width: 300px; height: 180px; padding: 5px;
        background: #fafafa;">
    <div class="easyui-layout" fit="true">
        <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
            <table cellpadding=3>
                <tr>
                    <td>旧密码：</td>
                    <td><input id="password" type="password" class="txt01" /></td>
                </tr>
                <tr>
                    <td>新密码：</td>
                    <td><input id="txtNewPass" type="password" class="txt01" /></td>
                </tr>
                <tr>
                    <td>确认密码：</td>
                    <td><input id="txtRePass" type="password" class="txt01" /></td>
                </tr>
            </table>
        </div>
        <div region="south" border="false" style="text-align: right; height: 30px; line-height: 30px;"> <a id="btnEp" class="easyui-linkbutton" icon="icon-ok" href="javascript:void(0)" > 确定</a> <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:void(0)">取消</a> </div>
    </div>
</div>--%>



	<%--<div id="loginWin" class="easyui-window" title="修改密码" collapsible="false" minimizable="false"
     maximizable="false" icon="icon-save" closed = "true"  style="width: 300px; height: 180px; padding: 5px;
        background: #fafafa;">
    <div class="easyui-layout" fit="true">
        <div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
            <table cellpadding=3>
                <tr>
                    <td>用户名：</td>
                    <td><input id="username" type="text" class="txt01" /></td>
                </tr>
                <tr>
                    <td>密码：</td>
                    <td><input id="password" type="password" class="txt01" /></td>
                </tr>
            </table>
        </div>
        <div region="south" border="false" style="text-align: right; height: 30px; line-height: 30px;"> <a id="btnEp" class="easyui-linkbutton" icon="icon-ok" href="javascript:void(0)" > 确定</a> <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:void(0)">取消</a> </div>
    </div>
</div>--%>

	<script>
		var userNameStr = miniCookie.getCookie("cookie_user_name");
		$("#userNameSpan").html(userNameStr);
	</script>
</body>
</html>