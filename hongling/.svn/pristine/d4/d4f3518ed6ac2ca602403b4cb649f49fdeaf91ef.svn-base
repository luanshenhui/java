<%@page import="centling.business.BlMemberManager"%>
<%@page import="chinsoft.business.CurrentInfo"%>
<%@page import="chinsoft.business.MemberManager"%>
<%@page import="chinsoft.entity.Member"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>RCMTM</title>
<link rel="shortcut icon" href="rcmtm.ico" /> 
<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
<meta http-equiv='pragma' content='no-cache' />
<meta http-equiv='cache-control' content='no-store' />
<meta http-equiv='expires' content='0' />
<script language= "javascript" src="../../scripts/jsp.js"></script>
<script language= "javascript">
 var member = $.csCore.getCurrentMember();
	if(member.username == undefined){
		var realm = window.location.href.split("hongling");
		window.location.href=realm[0]+"hongling";
	}
</script>
<script language= "javascript" src="ordenjsp.js"></script>
</head>
<% response.setHeader("P3P","CP=CAO PSA OUR"); %> 
<body class="orden" >
<div id="desktop" class="noprint">
	<div id="nav">
		<div id="hello" style="display:none;"></div><div id="newmessage" style="display:none;"></div>
		<s:if test="#session.company.logo==10051">
			<div style="width:165px;height:58px;"></div>
		</s:if>
		<s:else>
		    <div id="logo"></div>
		</s:else> 
		<div id="orden_clothing_category"></div>
		<%-- ${sessionScope.company.companycode} --%>
		<s:if test="#session.company.companycode == 'RC000001'">
			<div class="accordion" id="Common_Size" onclick="$.csOrden.sizeClick('RC000001')"><s:text name="Common_Size"></s:text></div>
		</s:if>
		<s:else>
		    <div class="accordion" id="Common_Size" onclick="$.csOrden.sizeClick('')"><s:text name="Common_Size"></s:text></div>
			<div class="accordion" id="Common_SubmitOrder"><s:text name="Common_SubmitOrder"></s:text></div>
		</s:else>
		<!-- <div id="classes_logo"><div id="classes_logo_div"><s:label value="%{getText('classes_logo_text')}"></s:label></div></div> -->
		<div id="payOrden">
			<!-- <div id="paypal"><img src="../../themes/default/images/Paypal.png"></img></div> -->
			<!-- <div id="alipay"><img src="../../themes/default/images/zfb.png"></img></div> -->
		</div>
	</div>
	<div id="main">
		<table id="function">
			<s:if test="#session.company.companycode == 'RC000001' || #session.company.companycode == 'RC000002'">
			</s:if>
			<s:elseif test="#session.company == null && #session.SessionCurrentMember.username =='Client'">
				<tr>
				   <td id="toolbar">
						<a id="createOrden" href="/hongling/orden/dordenPage.do"><s:text name="btnCreateOrden"></s:text> | </a> 
						<a id="signOut"><s:text name="signOut"></s:text></a> 
					</td>
				</tr>
			</s:elseif>
			<s:else>
			    <tr>
				   <td id="toolbar">
						<a id="style_UI"><s:text name="styleLibrary"></s:text> | </a><a id="createOrden" href="/hongling/orden/dordenPage.do"><s:text name="btnCreateOrden"></s:text> | </a> <a id="createOrden1" style="display:none;"><s:text name="btnCreateOrden"></s:text> | </a> 
						<a id="fashion_edition" href="../fix/fix.jsp"><s:text name="fashion_edition"></s:text> |</a> <a id="myorden"><s:text name="myorden"></s:text> |</a> <a id="myfabric"><s:text name="myfabric"></s:text> | </a> <a id="blDelivery"><s:text name="blDelivery"></s:text> | </a> 
						<%	
							Member member=CurrentInfo.getCurrentMember();
							if(member != null){
								Member parentMember = new MemberManager().getMemberByID(member.getParentID());
								Integer isDaBUser = BlMemberManager.isDaBUser(member.getGroupID(), parentMember.getGroupID());
								if(isDaBUser!=1){
									%> <a id="blCash"><s:text name="blCash"></s:text> | </a><%
								}
							}
						%>
						<a id="myuser"><s:text name="myuser"></s:text> | </a> <a id="mymessage"><s:text name="mymessage"></s:text> | </a> <a id="myinformation"><s:text name="myinformation"></s:text>  | </a> <a id="coder"><s:text name="coder"></s:text> | </a> 
						<s:if test="#session.SessionKey_srUserID ==null && #session.company == null" >
						<a id="signOut"><s:text name="signOut"></s:text></a>  
						</s:if>
						<s:elseif test="#session.company != null && #session.company.companycode == 'RC000002' && #session.company.editaddress != null ">
						<a id="outReturn" href="<s:property value="#session.company.editaddress"/>"><s:text name="signOut"></s:text></a>
						</s:elseif>
						<s:else>
						<a id="signOut"><s:text name="signOut"></s:text></a> 
						</s:else>
						<select id="versions"></select> 
					</td>
				</tr>
			</s:else>
			<tr>
				<td id="orden_clothing"></td>
			</tr>
		</table>
		<div id="system_name"></div>
		<div id="orden_content">
			<div id="show_medium1">
				<div id="show_medium"></div>
				<div id="button_up"></div><div id="button_down"></div>
			</div>
			<div id="show_large"></div><div id="fb_view"></div>
			<div id="find_content" class="find_content">
				<font id="find_title" class="find_title"><s:text name="btnSearch"></s:text></font>
			    <img src="../../themes/default/images/find.png"></img>
			    <div id="find_text"></div>
			</div>
			<div id="show_small"></div>
		</div>
	</div>
	<div id="footer">
		<s:if test="#session.company.copyright==10051">
		
		</s:if>
		<s:else>
		   <s:text name="footer"></s:text>
		</s:else> 
	</div>
</div>
  
<s:if test="#session.SessionKey_srUserID!=null">
	<iframe id="ccbMall" src="http://mall.ccb.com/alliance/getH.htm" height="0" width="0" frameborder="0" style="display:none" ></iframe>
	<script type="text/javascript">
	  var my_width  = Math.max(document.documentElement.clientWidth,document.body.clientWidth);
	  var my_height = Math.max(document.documentElement.clientHeight,document.body.clientHeight);
	  var ccbMall_iframe = document.getElementById("ccbMall");
	  ccbMall_iframe.src = ccbMall_iframe.src+"#"+my_height+"|"+my_width;
	</script>
</s:if>
<div id="backorder"></div>
</body>
</html>