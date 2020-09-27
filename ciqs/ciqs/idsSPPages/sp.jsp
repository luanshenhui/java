<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.trs.idm.saml.common.SamlConst"%>
<%@page import="com.trs.idm.util.Base64Util"%>
<%@page import="com.trs.idm.util.StringHelper"%>
<%@page import="com.trs.idm.util.RequestUtil"%>
<%@page import="com.trs.idm.system.SSOConst"%>
<%@page import="com.trs.idm.saml.sp.core.IServiceProvider"%>
<%@page import="com.trs.idm.saml.sp.core.ServiceProviderFactory"%>
<%
	IServiceProvider sp = ServiceProviderFactory.getInstance();

	String requestType = (String)request.getAttribute(SamlConst.REQUEST_TYPE_FLAG);
	String base64RequestBody = (String)request.getAttribute(SamlConst.REQUEST_BODY_FLAG);
	String requestBody = Base64Util.decode(base64RequestBody);
	String base64relayState = (String)request.getAttribute(SamlConst.RELAYSTATE_FLAG);
	String base64TargetURL = (String)request.getAttribute(SSOConst.TARGETURL_FLAG);
	String targetURL = Base64Util.decode(base64TargetURL);
	String coAppName = (String)request.getAttribute(SSOConst.COAPPNAME_FLAG);
	String coSessionId = (String)request.getAttribute(SSOConst.COSESSIONID_FLAG);
	String base64QueryString = (String)request.getAttribute(SamlConst.QUREYSTRING_FLAG);
	String base64PostParams = (String)request.getAttribute(SSOConst.POST_PARAMS_FLAG);
	
	String userNameField = sp.getConfig().getConfig(SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_USERNAME_FIELD, "userName");
	String passwordField = sp.getConfig().getConfig(SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_PASSWORD_FIELD, "password");
	String selfLoginPageUserName = (String)request.getAttribute(SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_USERNAME_VALUE);
	String selfLoginPagePassword = (String)request.getAttribute(SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_PASSWORD_VALUE);
	String selfLoginPageAfterLoginOKUrl = (String)request.getAttribute(SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_LOGIN_OK_URL);
	String selfLoginPageAfterLoginFailUrl = (String)request.getAttribute(SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_LOGIN_FAIL_URL);
	
	boolean isDebug = RequestUtil.getParameterAsBool(request, SSOConst.DEBUG_FLAG, false);
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.trs.idm.saml.common.SPConfig"%><html>
	<head>

		<title>自动提交页面</title>
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/JavaScript">
	<!--
		function autoSubmit() {
			document.forms[0].submit();
		}
	//-->
	</script>
	</head>

<%if(isDebug) { %>
	<body>
<%}else { %>
	<body onload="autoSubmit();">
<%} %>
	<form name="frm" id="frm" method="post" action="<%=targetURL %>" >

	<%if(!StringHelper.isEmpty(requestType)) { %>
		 	<input type="hidden"  name="<%=SamlConst.REQUEST_TYPE_FLAG %>" value="<%=requestType %>" ><br><br><br>
	 <%} %>
		
	<%if(!StringHelper.isEmpty(base64RequestBody)) { %> 
		 <input type="hidden"  name="<%=SamlConst.REQUEST_BODY_FLAG %>" value="<%=base64RequestBody %>" ><br><br><br>
	 <%} %>
	
	<!-- 由于现在没有encodeRequestBody，暂时先注释掉 -->
		
	<%if(!StringHelper.isEmpty(base64relayState)) { %> 	 
		 <input type="hidden" name="<%=SamlConst.RELAYSTATE_FLAG %>" value="<%=base64relayState %>" ><br><br><br>
	 <%} %>
		 
	<%if(!StringHelper.isEmpty(base64QueryString)) { %>
		 <input type="hidden" name="<%=SamlConst.QUREYSTRING_FLAG %>" value="<%=base64QueryString %>" ><br><br><br>
	 <%} %>
		 
	<%if(!StringHelper.isEmpty(coAppName)) { %>
		 <input type="hidden" name="<%=SSOConst.COAPPNAME_FLAG %>" value="<%=coAppName %>" ><br><br><br>
	 <%} %>
		 
		
	<%if(!StringHelper.isEmpty(coSessionId)) { %>
		 <input type="hidden" name="<%=SSOConst.COSESSIONID_FLAG %>" value="<%=coSessionId %>" ><br><br><br>
	 <%} %>
	 
	<%if(!StringHelper.isEmpty(base64PostParams)) { %>
		 <input type="hidden" name="<%=SSOConst.POST_PARAMS_FLAG %>" value="<%=base64PostParams %>" ><br><br><br>
	 <%} %>
	 
	<%if(!StringHelper.isEmpty(userNameField)) { %>
		 <input type="hidden" name="<%=SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_USERNAME_FIELD %>" value="<%=userNameField %>" ><br><br><br>
	 <%} %>
	 
	 <%if(!StringHelper.isEmpty(passwordField)) { %>
		 <input type="hidden" name="<%=SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_PASSWORD_FIELD %>" value="<%=passwordField %>" ><br><br><br>
	 <%} %>
	 
	<%if(!StringHelper.isEmpty(selfLoginPageUserName)) { %>
		 <input type="hidden" name="<%=userNameField %>" value="<%=selfLoginPageUserName %>" ><br><br><br>
	 <%} %>
	 
	 
	<%if(!StringHelper.isEmpty(selfLoginPagePassword)) { %>
		 <input type="hidden" name="<%=passwordField %>" value="<%=selfLoginPagePassword %>" ><br><br><br>
	 <%} %>
	 
	 	 
	<%if(!StringHelper.isEmpty(selfLoginPageAfterLoginOKUrl)) { %>
		 <input type="hidden" name="<%=SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_LOGIN_OK_URL %>" value="<%=selfLoginPageAfterLoginOKUrl %>" ><br><br><br>
	 <%} %>

	<%if(!StringHelper.isEmpty(selfLoginPageAfterLoginFailUrl)) { %>
		 <input type="hidden" name="<%=SPConfig.SSO_SIMPLETOKEN_SELFLOGINPAGE_LOGIN_FAIL_URL %>" value="<%=selfLoginPageAfterLoginFailUrl %>" ><br><br><br>
	 <%} %>
	 
	 
	<%if(isDebug) { %>
		原有HttpServletRequest中的参数：<br>
	<%} %>
	 

<br><br><br>	 
	 
	 <%if(isDebug) { %>
	    IDS SP中使用的参数:<br>
	 	targetURL:<%=targetURL %><br>
		<%=SamlConst.REQUEST_TYPE_FLAG %>:<%=requestType %><br>
		 base64RequestBody: <%=base64RequestBody %><br>
		 base64relayState: <%=base64relayState %><br>
		originalrelayState: <%=Base64Util.decode(base64relayState) %><br>
		 base64QueryString: <%=base64QueryString %><br>
		 originalQueryString: <%=Base64Util.decode(base64QueryString) %><br>
		 base64PostParams: <%=base64PostParams %><br>
		 originalPostParams: <%=Base64Util.decode(base64PostParams) %><br>
		 coAppName: <%=coAppName %><br>
		 coSessionId: <%=coSessionId %><br>
		 userNameField: <%=userNameField %><br>
		 passwordField: <%=passwordField %><br>
		 selfLoginPageUserName: <%=selfLoginPageUserName %><br>
		 selfLoginPagePassword: <%=selfLoginPagePassword %><br>
		 selfLoginPageAfterLoginOKUrl: <%=selfLoginPageAfterLoginOKUrl %><br>
		 selfLoginPageAfterLoginFailUrl: <%=selfLoginPageAfterLoginFailUrl %><br>
		<input type="hidden" name="<%=SSOConst.DEBUG_FLAG %>" value="<%=isDebug %>" ><br><br><br>
		<input type="submit"   value="提交" />
	 <%} %>
	 

	 
	 
	 
		</form>
		
		</body>

</html>