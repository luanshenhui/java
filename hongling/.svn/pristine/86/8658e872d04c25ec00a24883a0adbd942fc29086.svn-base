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
<script type="text/javascript" src="orden_page.js"></script>
</head>
<body>
<div style="width:1400px;">
	<div style="height:50px; margin-top: 20px;margin-bottom: 30px;padding-left:550px;">
		<table>
			<tr>
			   <td>
			   		<a id="professional_edition" style="color: #FFAB00;" href="../common/orden.jsp"><s:text name="professional_edition"></s:text> |</a> 
					<a id="myorden" onclick="$.csOrden_Page.loadPage('../orden/list.jsp',function(){$.csOrdenList.init();});"><s:text name="myorden"></s:text> |</a> 
					<a id="myfabric" onclick="$.csOrden_Page.loadPage('../fabric/list.jsp',function(){$.csFabricList.init();});"><s:text name="myfabric"></s:text> | </a> 
					<a id="blDelivery" onclick="$.csOrden_Page.loadPage('../bldelivery/BlDeliveryF.jsp',function(){$.csBlDeliveryFList.init();});"><s:text name="blDelivery"></s:text> | </a> 
					<a id="blCash" onclick="$.csOrden_Page.loadPage('../blcash/BlDealList.jsp',function(){$.csBlDealList.init('front',null,null);});"><s:text name="blCash"></s:text> | </a>
					<a id="myuser"  onclick="$.csOrden_Page.loadPage('../member/list.jsp',function(){$.csMemberList.init();});"><s:text name="myuser"></s:text> | </a> 
					<a id="mymessage" onclick="$.csOrden_Page.loadPage('../message/list.jsp',function(){$.csMessageList.init();});"><s:text name="mymessage"></s:text> | </a> 
					<a id="myinformation" onclick="$.csOrden_Page.loadPage('../information/list.jsp',function(){$.csInformationList.init();});"><s:text name="myinformation"></s:text>  | </a> 
					<a id="coder" onclick="$.csOrden_Page.loadPage('../coder/list.jsp',function(){$.csCoderList.init();});"><s:text name="coder"></s:text> | </a> 
					<a id="signOut"><s:text name="signOut"></s:text></a>  
					<select id="versions"></select> 
				</td>
			</tr>
		</table>
	</div>
	<div id="page_url" style="width:1010px;padding-left:200px;"></div>
	
	<%-- <div style="width:1010px;padding-left:200px;display: none;">
	 	<%@include file="../orden/list.jsp" %>
	</div> --%>
	
</div>
</body>
</html>