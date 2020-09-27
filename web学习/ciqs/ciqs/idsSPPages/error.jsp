<%--
/** Title:			TRS身份服务器
 *  Description:	TRS身份服务器的异常信息处理页。
 *		
 *  Copyright: 		Copyright (c) 2004-2005 TRS信息技术有限公司
 *  Company: 		TRS Info. Ltd.（www.trs.com.cn）
 *  Created:		2005-01-09
 *	Update Logs:
 *		[ls@2008-01-30] 关闭session!
 *		[liushen@2005-07-18] 增加复制相关信息到剪贴板的功能(限于IE)
 *		[liushen@2005-04-13] 增加相关系统信息
 *		[liushen@2005-03-24] 增加异常的RootCause的堆栈信息
 *		[liushen@2005-02-16] 增加异常堆栈等信息
 */
--%>

<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" isErrorPage="true" %>
<%@ page session="false" %>
<%@page import="com.trs.idm.exception.ServiceProviderException"%>
<%
	//阻止缓存
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", -1);
	response.setDateHeader("max-age", 0);
	//取应用的URL根目录
    String contextPath = request.getContextPath();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD><TITLE>TRS Service Provider错误信息处理页</TITLE>
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
//-->
</SCRIPT>

<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="30" background="<%= contextPath %>/admin/images/blue1.gif" style="border-bottom: 1px solid #1F4880;border-top: 1px solid #92B2E1;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td style="border-right: 1px solid #1F4880"><table border="0" align="left" cellpadding="0" cellspacing="0">
            <tr>
              <td></td>
              <td class="windowname">TRS Service Provider错误提示信息</td>
            </tr>
          </table></td>
          <td ></td>
        </tr>
    </table></td>
  </tr>
  <tr>
    <td background="<%= contextPath %>/admin/images/blue1-1.gif" style="border-bottom: 1px solid #1F4880; height:12px">&nbsp;</td>
  </tr>
<!-- 主体部分 -->
  <tr>
    <td class="nomalwindow_td"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td bgcolor="#719AD5" style="border-top: 1px solid #A5BEE0;border-left: 1px solid #A5BEE0;border-bottom: 1px solid #5D7EAD;border-right: 1px solid #5D7EAD">		<table width="0%"  border="0" cellspacing="3" cellpadding="0">
          <tr>
            <td class="font_white">您进行了错误的操作, 或是系统有异常发生</td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td bgcolor="#F3F3F1" style="border: 1px solid #cccccc">
		<table width="100%"  border="0" cellpadding="3" cellspacing="0"style="border-top: 1px solid #ffffff;border-left: 1px solid #ffffff">
            <tr>
              <td>系统提示信息: <%= (exception == null) ? "未知错误!" : exception.getMessage() %></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>
				请尝试以下操作：
				<li>点击&nbsp;<a href="javascript:history.back();">后退</a>&nbsp;, 返回刚才的页面, 尝试其他操作.</li>
				<li>点击&nbsp;<a href="javascript:copyToClipboard();">复制到剪贴板</a>&nbsp;, 将详细错误信息复制到剪贴板.</li>
				<li>点击&nbsp;<a href="javascript:window.close();">关闭</a>&nbsp;, 关闭当前窗口.</li>
			  </td>
            </tr>
		</table></td>
      </tr>
    </table></td>
  </tr>
<!-- 系统版本信息 Begin-->
  <tr>
    <td class="nomalwindow_td"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td bgcolor="#719AD5" style="border-top: 1px solid #A5BEE0;border-left: 1px solid #A5BEE0;border-bottom: 1px solid #5D7EAD;border-right: 1px solid #5D7EAD"><table width="0%" border="0" cellspacing="3" cellpadding="0">
          <tr>
            <td class="font_white">系统版本和运行环境信息</td>
   		  </tr>
        </table></td>
      </tr>
      <tr>
        <td id=tdSysInfo bgcolor="#F3F3F1" style="border: 1px solid #cccccc; display: block">
		<table width="100%"  border="0" cellpadding="3" cellspacing="0"style="border-top: 1px solid #ffffff;border-left: 1px solid #ffffff">
            <tr>
              <td width="80">主机名</td>
              <td><%= java.net.InetAddress.getLocalHost() %></td>
            </tr>

            <tr>
              <td width="80">应用服务器</td>
              <td><%= application.getServerInfo() %></td>
            </tr>
            <tr>
              <td width="80">Java环境信息</td>
              <td><%= System.getProperty("java.vendor") %>&nbsp;<b><%= System.getProperty("java.version") %></b>
            &nbsp;(<%= System.getProperty("java.vm.name") %>, <%= System.getProperty("java.vm.info") %>)</td>
            </tr>
		  <tr>
			<td width=80>操作系统</td>
			<td>&nbsp;<%= System.getProperty("os.name") %>&nbsp;(<%= System.getProperty("os.version") %>;&nbsp;<%= System.getProperty("os.arch") %>)</td>
		  </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
<!-- 系统版本信息 End -->

<!-- 详细异常信息和相关信息 Begin-->
  <tr>
    <td class="nomalwindow_td"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td bgcolor="#719AD5" style="border-top: 1px solid #A5BEE0;border-left: 1px solid #A5BEE0;border-bottom: 1px solid #5D7EAD;border-right: 1px solid #5D7EAD"><table width="0%" border="0" cellspacing="3" cellpadding="0">
          <tr>
            <td class="font_white">详细异常信息和相关信息 </td>
   		  </tr>
        </table></td>
      </tr>
      <tr>
        <td id=tdErrDetail bgcolor="#F3F3F1" style="border: 1px solid #cccccc;display: block">
		<table width="100%"  border="0" cellpadding="3" cellspacing="0"style="border-top: 1px solid #ffffff;border-left: 1px solid #ffffff">
            <tr>
              <td width="80">应用的URL: </td>
              <td><%= contextPath %></td>
            </tr>
            <tr>
              <td width="80">请求的URL: </td>
              <td><%= request.getRequestURL() %></td>
            </tr>
            <tr>
              <td width="80">出错的URI: </td>
              <td><%= request.getAttribute("javax.servlet.error.request_uri") %></td>
            </tr>
<%
    if (exception instanceof ServiceProviderException) {
    	ServiceProviderException e = (ServiceProviderException) exception;
%>
            <tr>
              <td width="80">异常编号: </td>
              <td>&nbsp;<%= e.getErrCode() %></td>
            </tr>
<%
	}
%>
            <tr>
              <td width="80" valign=top>异常堆栈信息: </td>
              <td id=tdStackTrace style="display: block">
<%
    if(exception != null) {
 		exception.printStackTrace(new java.io.PrintWriter(out));   
    }    
%>
			  </td>
            </tr>
<%--//显示异常的rootCause begin   --%>
            <tr>
              <td width="80" valign=top>Caused by: </td>
              <td id=tdErrCause style="display: block">
<%
		try {
			Throwable tCause = exception.getCause();
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
<%--//显示异常的rootCause End   --%>
        </table></td>
      </tr>
    </table></td>
  </tr>
<!-- 详细异常信息和相关信息 End -->

<%-- 底部按钮 Begin --%>
  <tr>
	<td><table border="0" align="right" cellpadding="2" cellspacing="0">
		<tr>
		  <td><input type="button" name="bClose" value="关闭" onclick="window.close();"></td>
		</tr>
	</table></td>
  </tr>
<%-- 底部按钮 End --%>
</table>
</body>
</html>