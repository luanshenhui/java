<%--
/** Title:			TRS身份服务器
 *  Description:	TRSIDS Agent的异常信息页。
 *		
 *  Copyright: 		Copyright (c) 2004-2005 TRS信息技术有限公司
 *  Company: 		TRS Info. Ltd.（www.trs.com.cn）
 *  Author:			
 *  Created:		2005-03-29
 *  Vesion:			1.0
 *	Update Logs:
 *		[ls@2005-10-11] 配合SSOFilter, 增加Agent端Exception信息和堆栈输出
 *		
 *  Parameters:
 *		
 */
--%>

<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	//阻止缓存
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", -1);
	response.setDateHeader("max-age", 0);
	//取应用的URL根目录
    String contextPath = request.getContextPath();

	Exception ex = (Exception) request.getAttribute("com.trs.ids.agent.exception");
	if (ex == null) {
		ex = new Exception("none exception!make sure your ids version greater than v1.0.2019b!");
	}
	
	 IAgent agent = AgentFactory.getInstance();
		String userNameFile = agent.getCoAppSelfLoginUserNameField();
		String passwordFile = agent.getCoAppSelfLoginPagePasswordField();
	
		
	//if(ex.getMessage().equals("Can't Get Response...") || ex.getMessage().equals("Received Packet is not a IDS ResponsePacket!")) {
		//request.getRequestDispatcher(agent.getLoginActionUri()).forward(request, response);
	//	response.sendRedirect(request.getContextPath() + agent.getLoginActionUri() +"?" + userNameFile +"=ids" + "&" + passwordFile + "=12345678");
	//	return;
		
	//}
	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<%@page import="com.trs.idm.interact.agent.IAgent"%>
<%@page import="com.trs.idm.interact.agent.AgentFactory"%><HTML>
<HEAD><TITLE>TRSIDS Agent错误信息</TITLE>
<style type="text/css">
<!--
TD {
	FONT-SIZE: 12px
}
-->
</style>
</HEAD>

<SCRIPT LANGUAGE="JavaScript" >
<!--
// 复制详细异常堆栈信息到剪贴板
function copyToClipboard(){
	if (window.clipboardData) {
		var sDetailMsg = document.getElementById("tdSysInfo").innerText;
		sDetailMsg += "\n\n";
		sDetailMsg += document.getElementById("tdErrDetail").innerText;
		var bSucess = window.clipboardData.setData("Text", sDetailMsg);
		alert(bSucess ? "已成功复制到剪贴板中." : "复制到剪贴板失败!");
		return;
	}

	alert("该浏览器不支持剪贴板功能!");
}

// 切换指定id的html元素对象的显示状态
function switchDisplay(eleId) {
	if (eleId == null) {
		return;
	}
	if (eleId.style.display == "none") {
		eleId.style.display = "inline";
	} else {
		eleId.style.display = "none";
	}
}
//-->
</SCRIPT>

<body  bgcolor="#F7F7F7">

<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><table width="600"  border="0" align="center" cellpadding="20" cellspacing="0" style="border:4px solid #D4E2EE">
      <tr>
        <td align="left">
         	 <p >&nbsp;</p>
         
        	<p><br>
            <font  style="font-size:18px; font-weight:bold; color:#FF0000; " ><b>应用暂时无法与认证中心连接，正在进行重试，请稍后访问。</b></font></p>         
           <p >&nbsp;</p>
          <div align="center">
            <table border="0" width="100%" cellspacing="0" cellpadding="0" height="20">
              <tr>
                <td height="20" align="right">
                <b></b>
                </td>
                </tr>
            </table>
          </div></td>
      </tr>
    </table></td>
  </tr>
</table>

<table style="display: none;">
  <tr>
              <td width="80" valign=top><A HREF="javascript:switchDisplay(tdStackTrace);">异常堆栈信息: </A></td>
              <td id=tdStackTrace style="display: none">
<%
    ex.printStackTrace(new java.io.PrintWriter(out));
%>
			  </td>
            </tr>
            <tr>
              <td width="80" valign=top><A HREF="javascript:switchDisplay(tdErrCause);">Caused by: </A></td>
              <td id=tdErrCause style="display: none">
<%
		try {
			Throwable tCause = ex.getCause();
			Throwable tRootCause = null;
			while (tCause != null) {
				tRootCause = tCause;
				tCause = tCause.getCause();
			}
			if (tRootCause != null) {
				tRootCause.printStackTrace(new java.io.PrintWriter(out));
			} else {
				out.println("引发该异常的cause不存在或未知.");
			}
		} catch (Throwable t) {
			out.println("Java运行环境版本低于1.4, 没有getCause()方法, 无法获取RootCause信息.");
		}
%>
			  </td>
            </tr>
            </table>
</body>
</html>