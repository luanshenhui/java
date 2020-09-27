<%@page import="com.trs.idm.util.StringHelper"%>
<%@page import="com.trs.idm.util.RequestUtil"%>
<%@page import="com.trs.idm.util.UrlUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", -1);
	response.setDateHeader("max-age", 0);
	
	String failInfo = (String) request.getAttribute("ids.ssoLogin.failInfo");
	String returnUrl = (String)request.getAttribute("ids.ssoLogin.referURL");
	if(null == returnUrl || "".equals(returnUrl)){
		returnUrl = RequestUtil.getContextRoot(request);
	}
	
	com.trs.idm.interact.agent.IAgent agent = com.trs.idm.interact.agent.AgentFactory.getInstance().initAndStart();
	String gotoUrl = returnUrl;
	if(null != agent){
		String code = (String) request.getAttribute("ids.ssoLogin.failInfoCode");
		// 如果是密码不符合策略的错误，则按照配置情况跳转
		if("1052".equals(code)||"1056".equals(code)){
			gotoUrl = agent.getProperty("agent.password.reset.url", agent.getIdsContextPath()+"/account/errorInfoForPwdCheck.jsp");
			String concat = "?";
			if(gotoUrl.contains("?")){
				concat = "&";
			}
			String userName =request.getParameter(agent.getCoAppSelfLoginUserNameField());
			if(StringHelper.isEmpty(userName)){
				userName = (String)request.getAttribute(agent.getCoAppSelfLoginUserNameField());
			}
			gotoUrl = gotoUrl+concat+"errCode=" + code+"&userName="+userName+"&returnUrl="+UrlUtil.encode(returnUrl) ;
		}
	}
%>
<html>
<head>
<title>TRS IDS Agent:::<%= request.getRequestURL() %></title>
<script>
// ids.ssoLogin.referURL: <%= request.getAttribute("ids.ssoLogin.referURL") %>
alert("登录失败! 请重试.\n失败原因: <%= failInfo %>");
location.href = "<%=gotoUrl%>";
</script>
</head>

<body>
</body>
</html>