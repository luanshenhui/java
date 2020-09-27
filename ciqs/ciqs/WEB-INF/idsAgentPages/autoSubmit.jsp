<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.trs.idm.util.StringHelper"%>
<%@page import="com.trs.idm.util.RequestUtil"%>
<%@page import="com.trs.idm.system.ClientConst"%>
<%
	String message = RequestUtil.getAttributeAsTrimStr(request, ClientConst.AUTOSUBMIT_PRAMA_MESSAGE);
	String targetUrl = RequestUtil.getAttributeAsTrimStr(request, ClientConst.AUTOSUBMIT_PRAMA_TARGET_URL);
	
	String userNameField = RequestUtil.getAttributeAsTrimStr(request, ClientConst.AUTOSUBMIT_FIElD_USERNAME);
	String passwordField = RequestUtil.getAttributeAsTrimStr(request, ClientConst.AUTOSUBMIT_FIElD_PASSWORD);
	String userName = RequestUtil.getParameterAndTrim(request, userNameField);
	String password = RequestUtil.getParameterAndTrim(request, passwordField);
	
	// 应用原有的POST参数
	String appOriginalPostParameters = RequestUtil.getAttributeAsTrimStr(request, ClientConst.AUTOSUBMIT_PRAMA_POSTPARAMS);
	Map postParameters = null;
	if(!StringHelper.isEmpty(appOriginalPostParameters)) {
		postParameters = StringHelper.String2Map(appOriginalPostParameters, "&", "=");
	}
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<html>
	<head>

		<title>自动提交页面</title>
		<style type="text/css">
		<!--
		TD {
			FONT-SIZE: 12px
		}
		-->
		</style>
		
		<script type="text/JavaScript">
		<!--
			function autoSubmit() {
				document.forms[0].submit();
			}
		//-->
		</script>
	</head>

<%
	if(StringHelper.isEmpty(message)) {
%>
	<body onload="autoSubmit();">
<%
	}else {
%>
	<body>
<%} %>
	
<form name="frm" id="frm" method="post" action="<%=targetUrl %>" >
<%-- 隐藏提交部分开始 --%>
<input type="hidden" name="isFromIDSAutoSubmitPage" value="true">
	<%if(!StringHelper.isEmpty(userName)) { %>
		<input type="hidden" name="<%=userNameField %>" value="<%=userName %>">
	<%} %>
	
	<%if(!StringHelper.isEmpty(password)) { %>
	<input type="hidden" name="<%=passwordField %>" value="<%=password %>">
	<%} %>
	
	<%
		if(postParameters != null && postParameters.size() != 0) {  
			Iterator it = postParameters.entrySet().iterator();  
			while (it.hasNext()) {  
				Map.Entry   entry   = (Map.Entry)it.next();  
				String key = (String)entry.getKey();  
				String value = (String)entry.getValue();  
	%>
		<input type="hidden" name="<%=key %>" value="<%=value %>">
	<%
		  	}
		}
	
	%>
<%-- 隐藏提交部分结束 --%>
	
	
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<%-- 主体页面部分开始 --%>
  <tr>
    <td class="nomalwindow_td"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td bgcolor="#719AD5" style="border-top: 1px solid #A5BEE0;border-left: 1px solid #A5BEE0;border-bottom: 1px solid #5D7EAD;border-right: 1px solid #5D7EAD">		<table width="0%"  border="0" cellspacing="3" cellpadding="0">
          <tr>
            <td class="font_white">身份服务器提示信息</td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td bgcolor="#F3F3F1" style="border: 1px solid #cccccc">
		<table width="100%"  border="0" cellpadding="3" cellspacing="0"style="border-top: 1px solid #ffffff;border-left: 1px solid #ffffff">
            <tr>
              <td><%=message %></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td>
				<input type="submit" value="确定" />
				<input type="button" name="bClose" value="关闭" onclick="window.close();">
			  </td>
            </tr>
		</table></td>
      </tr>
    </table></td>
  </tr>
</table>
<%-- 主体部分结束 --%>
	
	</form>
</body>
</html>