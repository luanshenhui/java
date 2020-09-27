<%@ page import="chinsoft.core.Utility"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>RCMTM</title>
<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
<meta http-equiv='pragma' content='no-cache' />
<meta http-equiv='cache-control' content='no-store' />
<meta http-equiv='expires' content='0' />
<link rel="stylesheet" href="<%=path %>/themes/default/style_quick.css" type="text/css"></link>
<script type="text/javascript" src="<%=path %>/scripts/jsp3.js"></script>
<script type="text/javascript" src="<%=path %>/pages/orden/dorden_Page.js"></script> 
<script type="text/javascript" src="<%=path %>/scripts/jquery/datepicker/WdatePicker.js"></script>
<style>
.dytopmenu{color: #c69b6e;}
.dytopmenu a{color: #000000;}
a{text-decoration: underline;}
a:HOVER{text-decoration: underline;color:#000000}
.dybody{width:1200px;margin: 0px auto;}
.dybody select{background: #fff;border: 1px solid #c69b6e;}
.dybody input{background: #fff;border: 1px solid #fff;}
.dytable{text-align: center;width: 100%;}
.dytable table tr{height:28px;line-height: 28px;}
.dytable table th{border-right: 1px solid #e5d0bd;padding-left: 3px;padding-right: 3px;}
.dytable table td{padding-left: 3px;padding-right: 3px;border-right: 1px solid #c69b6e;border-bottom: 1px solid #c69b6e;color: #000000;}
</style>
</head>
  <body id="bodyid" style="background-color: #fff;">
  <div class="dybody noprint">
	<div class="dytopmenu" style="float:right;margin-top:10px;margin-bottom:10px; ">
		<table>
			<tr>
			   <td>
			   		<a id="professional_edition" href="../pages/common/orden.jsp"><s:text name="professional_edition"></s:text></a> | 
					<a id="myorden" href="/hongling/orden/dordenPage.do"><s:text name="myorden"></s:text></a> |
					<a id="myfabric" onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/fabric_list.jsp',function(){$.cookie('ordenSearchUrl',null);$.csFabricList.init();});"><s:text name="myfabric"></s:text></a> |  
					<a id="blDelivery" onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/bldelivery_BlDeliveryF.jsp',function(){$.cookie('ordenSearchUrl',null);$.csBlDeliveryFList.init();});"><s:text name="blDelivery"></s:text></a> |  
					<%	//是否显示现金管理 1:不显示
						int cashShow = Utility.toSafeInt(request.getAttribute("cashShow"));
						if(cashShow != 1){
					%>
					<a id="blCash" onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/blcash_BlDealList.jsp',function(){$.cookie('ordenSearchUrl',null);$.csBlDealList.init('front',null,null);});"><s:text name="blCash"></s:text></a> | 
					<%
						}
					%>
					<a id="myuser"  onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/member_list.jsp',function(){$.cookie('ordenSearchUrl',null);$.csMemberList.init();});"><s:text name="myuser"></s:text></a> |  
					<a id="mymessage" onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/message_list.jsp',function(){$.cookie('ordenSearchUrl',null);$.csMessageList.init();});"><s:text name="mymessage"></s:text></a> |  
					<a id="myinformation" onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/information_list.jsp',function(){$.cookie('ordenSearchUrl',null);$.csInformationList.init();});"><s:text name="myinformation"></s:text></a>  |  
					<a id="receivingmanagement" onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/receiving_list.jsp',function(){$.cookie('ordenSearchUrl',null);$.csReceivingList.init();});"><s:text name="receivingmanagement"></s:text></a> |   
					<a id="coder" onclick="$.dorden_page.loadPage('<%=path %>/pages/quick/coder_list.jsp',function(){$.cookie('ordenSearchUrl',null);$.csCoderList.init();});"><s:text name="coder"></s:text></a> |  
					<a id="signOut"><s:text name="signOut"></s:text></a>
					<select id="versions" style="background-color: #ffffff;color: #000000;"></select>
				</td>
			</tr>
		</table>
	</div>
	<div id="page_url" style="float: left;width: 100%;">
		<div id="OrdenSearch">
		<h1 style="line-height: 60px;color: #c69b6e;"><s:text name="view_orden"></s:text></h1>
		<form id="fromsubmit" method="post">
		<div style="background-color: #c69b6e;height:24px;line-height: 24px;padding-left: 8px;padding-right: 8px;color: #fff;">
			<s:label value="%{getText('lblClothingCategory')}"></s:label>:
			<s:select list="%{#request.clothingmap}" id="searchClothingID"  name="searchClothingID"></s:select> &nbsp;
			<s:label value="%{getText('lblStatus')}"></s:label>:
			<s:select list="%{#request.datsamap}" id="searchStatusID"  name="searchStatusID"></s:select> &nbsp; 
			<s:label value="%{getText('lblMemberName')}"></s:label>:
			<s:select list="%{#request.clientmap}" id="searchClientID"  name="searchClientID"></s:select> &nbsp; 
			<s:label value="%{getText('lblKeyword')}"></s:label>:
			<input style="width: 80px;" type="text" id="keyword" name="keyword"/>&nbsp;
			<s:label value="%{getText('lblPubDate')}"></s:label>:
			<input type="text" id="fromDate" name="fromDate"/>
			<input type="text" id="toDate" name="toDate"/>&nbsp;
			<s:label value="%{getText('lblDealDate')}"></s:label>:
			<input type="text" id="dealDate" name="dealDate"/>
			<input type="text" id="dealToDate" name="dealToDate"/>&nbsp;
			<a id="btnsearch" style="float: right;"><s:text name="btnSearch"></s:text></a>
			<s:property value="#session.cashShow" />
		</div>
		<div style="line-height: 60px;color: #c69b6e;float: right;font-weight: bold;">
			<a id="btnCreateOrden"><s:text name="btnCreateOrden"></s:text></a>　　
			<a id="btnExportOrdens"><s:text name="btnExportOrdens"></s:text></a>　　
			<%	//是否显示现金管理 1:不显示
				int Statistic = Utility.toSafeInt(request.getAttribute("cashShow"));
				if(Statistic != 1){
			%>
			<a id="btnOrdenStatistic"><s:text name="btnOrdenStatistic"></s:text></a>　　
			<%
				}
			%>
			<a id="btnPayMoreOrden"><s:text name="btnMorePay"></s:text></a>
			<a id="btnSubmitMoreOrden"><s:text name="btnMoreSubmit"></s:text></a>　　
			<a id="btnExportOrdenContent"><s:text name="btnExportOrdenContent"></s:text></a>　　
			<a id="btnPrintOrden"><s:text name="btnPrintOrden"></s:text></a>　
		</div>
		</form>
	</div>
	<div class="dytable" style="float: left;width: 100%;">
		<table style="width: 100%;">
			<tr style="background-color: #c69b6e;color: #fff;">
				<th width="20px"><input type="checkbox" id="moreSelect" onclick="$.dorden_page.selectOrQuick();" title="<s:text name="lblMoreSelect"/>"/></th>
				<th width="30px"><s:text name="lblNumber"></s:text></th>
				<th width="100px"><s:text name="lblCode"></s:text></th>
				<th width="120px"><s:text name="lblCustomerNo"></s:text></th>
				<th width="100px"><s:text name="lblClothingCategory"></s:text></th>
				<th width="120px"><s:text name="lblCustomerName"></s:text></th>
				<th width="70px"><s:text name="lblFabric"></s:text></th>
				<th width="80px"><s:text name="lblPubDate"></s:text></th>
				<th width="80px"><s:text name="lblDeliveryDate"></s:text></th>
				<th width="80px"><s:text name="lblDealDate"></s:text></th>
				<th><s:text name="lblDeliveryStatus"></s:text></th>
				<th width="40px;"><s:text name="lblStatus"></s:text></th>
				<th><s:text name="lblDo"></s:text></th>
				<th><s:text name="lblStopCause"></s:text></th>
			</tr>
		<%
			List list=(List)request.getAttribute("ordens");
			String currentOrdenPre = (String)request.getAttribute("currentOrdenPre");
			for(int i=0;i<list.size();i++){
			Map map=(Map)list.get(i);
		%>
		<tr id="tr<%=i %>">
			<td style="border-left: 1px solid #c69b6e;"><input name="chkRow" name="chkRow" onclick="$.dorden_page.checkOnce(this);" value="<%=map.get("ORDENID") %>" type="checkbox"/></td>
			<td><%=(i+1) %></td>
			<td style="cursor: pointer;" onclick="$.dorden_page.openView('<%=map.get("ORDENID") %>');"><a><%=map.get("ORDENID") %></a></td>
			<td><%=map.get("USERORDENO")==null?"":map.get("USERORDENO")%></td>
			<td>
				
				<%
					if(map.get("DNAME")==null){
					%>
						<span>&nbsp;</span>
					<%
					}
					else
					{
					 	if("马夹".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="lblvest"></s:text>	
					 		<%
					 	}
					 	if("大衣".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="lblovercoat"></s:text>	
					 		<%
					 	}
					 	if("上衣".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="lbljacket"></s:text>	
					 		<%
					 	}
					 	if("衬衣".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="lblshirt"></s:text>
					 		<%
					 	}
					 	if("西裤".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10050")){
					 		%>
					 			<s:text name="lblpant"></s:text>+<s:text name="lblpant"></s:text>	
					 		<%
					 	}else if("西裤".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10051")){
					 		%>
					 			1&nbsp;<s:text name="lblpant"></s:text>
					 		<%
					 	}else if("西裤".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="lblpant"></s:text>
					 		<%
					 	}
					 	if("套装(2pcs)".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10050")){
					 		%>
					 			<s:text name="2pcsuit"></s:text>+<s:text name="lblpant"></s:text>	
					 		<%
					 	}else if("套装(2pcs)".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10051")){
					 		%>
					 			1&nbsp;<s:text name="2pcsuit"></s:text>	
					 		<%
					 	}else if("套装(2pcs)".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="2pcsuit"></s:text>	
					 		<%
					 	}
					 	if("套装(3pcs)".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10050")){
					 		%>
					 			<s:text name="3pcsuit"></s:text>+<s:text name="lblpant"></s:text>
					 		<%
					 	}else if("套装(3pcs)".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10051")){
					 		%>
					 			1&nbsp;<s:text name="3pcsuit"></s:text>	
					 		<%
					 	}else if("套装(3pcs)".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="3pcsuit"></s:text>	
					 		<%
					 	}

						if("套装(C+B)".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10050")){
					 		%>
					 			<s:text name="2pcsuit_CB"></s:text>+<s:text name="lblpant"></s:text>
					 		<%
					 	}else if("套装(C+B)".equals(Utility.toSafeString(map.get("DNAME"))) && Utility.toSafeString(map.get("MOREPANTS")).equals("10051")){
					 		%>
					 			1&nbsp;<s:text name="2pcsuit_CB"></s:text>	
					 		<%
					 	}else if("套装(C+B)".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="2pcsuit_CB"></s:text>	
					 		<%
					 	}
					 	
					 	if("套装(A+C)".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="2pcsuit_AC"></s:text>	
					 		<%
					 	}
					 	
					 	if("配件".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="accessories"></s:text>	
					 		<%
					 	}
					 	if("礼服".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="tuxedo"></s:text>	
					 		<%
					 	}
					 	if("女西服".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="jacketN"></s:text>	
					 		<%
					 	}
					 	if("女西裤".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="pantN"></s:text>	
					 		<%
					 	}
					 	if("礼服(2pcs)".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="2tuxedo"></s:text>	
					 		<%
					 	}
					 	if("女套装(2pcs)".equals(Utility.toSafeString(map.get("DNAME")))){
					 		%>
					 			<%=Utility.toSafeString(map.get("MOREPANTS"))%>&nbsp;<s:text name="w2pcsuit"></s:text>	
					 		<%
					 	}
					}
				 %>
			</td>
			<td><%=map.get("CNAME")==null?"":map.get("CNAME") %></td>
			<td><%=map.get("FABRICCODE")==null?"":map.get("FABRICCODE") %></td>
			<td><%=map.get("PUBDATE")==null?"":map.get("PUBDATE") %></td>
			<td><%=map.get("DELIVERYDATE")==null?"":map.get("DELIVERYDATE") %></td>
			<td  style="cursor: pointer;" onclick="$.dorden_page.editJhrq('<%=map.get("ORDENID") %>','<%=map.get("JHRQ")==null?"":map.get("JHRQ") %>')"><a><%=map.get("JHRQ")==null?"":map.get("JHRQ") %></a></td>
			<td>
				<%
					if(map.get("DELIVERYID")==null){
						%>
							<s:text name="lblNo"></s:text>
						<%
					}
					else
					{
						%>
							<s:text name="lblOK"></s:text>
						<%
					}
				 %>
			</td>
			<td class="center">
				<%
					if(Utility.toSafeInt(map.get("STATUSID"))==10035 && Utility.toSafeInt(map.get("ISSTOP")) != 10050){
						if(Utility.toSafeString(map.get("MEMOS"))==""){
							%>
								<s:text name="btnSaveOrden"></s:text>
							<%
						}else{
							%>
								<label style="color: red;" title="<%=Utility.toSafeString(map.get("MEMOS"))%>"><s:text name="btnSaveOrden"></s:text></label>
							<%
						}
					}
					else if(Utility.toSafeInt(map.get("STATUSID"))==10030){
					%>
						<s:text name="lblplatemaking"></s:text>
					<%
					}
					else if(Utility.toSafeInt(map.get("STATUSID"))==10039){
					%>
						<s:text name="lbltobepaid"></s:text>
					<%
					}
					else if(Utility.toSafeInt(map.get("STATUSID"))==10031){
					%>
						<s:text name="lblproduce"></s:text>
					<%	
					}
					else if(Utility.toSafeInt(map.get("STATUSID"))==10032){
					%>
						<s:text name="lblputinstorage"></s:text>
					<%
					}
					else if(Utility.toSafeInt(map.get("STATUSID"))==10033){
					%>
						<s:text name="lblshipped"></s:text>
					<%	
					}
					else if(Utility.toSafeInt(map.get("STATUSID"))==10034){
					%>
						<s:text name="lblreceived"></s:text>
					<%	
					}
					else if(Utility.toSafeInt(map.get("STATUSID"))==10035 && Utility.toSafeInt(map.get("ISSTOP"))== 10050){
					
					%>
						<s:text name="lblstagnate"></s:text>
					<%		
					}else if(Utility.toSafeInt(map.get("STATUSID"))==10370){
					%>
						<s:text name="lblBackout"></s:text>
					<%	
					}
				 %>
			</td>
			<td>
				<%
				if(currentOrdenPre.equals(map.get("ORDENPRE"))){
					
					if(Utility.toSafeInt(map.get("STATUSID"))==10035){
					%>
					<a onclick="$.dorden_page.openEdit('<%=map.get("ORDENID") %>')" ><s:text name="lbEdit"></s:text></a>
					<%
						if(!"配件".equals(Utility.toSafeString(map.get("DNAME")))){
					%>
					<a onclick="$.dorden_page.preSubmitOrden('<%=map.get("ORDENID") %>')"><s:text name="lblPreSubmit"></s:text></a>
					<%
						}
					%>
					<a onclick="$.dorden_page.remove('<%=map.get("ORDENID") %>','<%=map.get("STATUSID")%>','<%=map.get("COMPANYID")%>');"><s:text name="btnRemoveFabric"></s:text></a>
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10030){
					%>
						
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10039){
					%>
					<s:if test="#session.company != null" >
					<a onclick="$.dorden_page.ordenToPay('<%=map.get("ORDENID") %>','<%=map.get("SYSCODE") %>','<s:property value="#session.SessionCurrentMember.userStatus"/>','<%=map.get("COMPANYID") %>','<%=map.get("MPAYTYPEID") %>')"><s:text name="lblpay_zf"></s:text></a>
					<a onclick="$.dorden_page.remove('<%=map.get("ORDENID") %>','<%=map.get("STATUSID")%>','<%=map.get("COMPANYID")%>');"><s:text name="btnRemoveFabric"></s:text></a>
					
					</s:if>
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10028){
					%>
					
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10036){
					%>
					
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10037){
					%>
					
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10031){
					%>
					
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10032){
					%>
					
					<%
				}
				%>
				<%
				if(Utility.toSafeInt(map.get("STATUSID"))==10369){
					%>
					
					<%
				}
				%>
			</td>
			<td class="center" style="color: #F7CA8D;cursor: pointer;">
				<% if(Utility.toSafeInt(map.get("ISSTOP"))==10050){
					%>
						<span onclick="$.dorden_page.viewStopCause('{<%=map.get("CAUSENAME") %>}','{<%=map.get("MEMO") %>}');"><s:text name="lbView"></s:text></span>
					<%
				} 
			}
				%>
			</td>
		</tr>
		 <%
		   }
		 %>
		</table>
	</div>
	<div style="float: right;color: #000000;line-height: 30px;">
		<s:text name="lblrespect"></s:text>&nbsp;${count}&nbsp;<s:text name="lbltake"></s:text>&nbsp;&nbsp;
		<s:text name="lblthisis"></s:text>&nbsp;${pageindex+1}/${pagecount}&nbsp;&nbsp;
		<s:if test="%{pageindex==0&&pageindex==(pagecount-1)}" >
			<a><s:text name="lblhome"></s:text></a>&nbsp;&nbsp;
			<a><s:text name="lblprev"></s:text></a>&nbsp;&nbsp;
			<a><s:text name="lblnext"></s:text></a>&nbsp;&nbsp;
			<a><s:text name="lblend"></s:text></a>&nbsp;&nbsp;
		</s:if>
		<s:if test="%{pageindex==0&&(pagecount-1)>pageindex}" >
			<a><s:text name="lblhome"></s:text></a>&nbsp;&nbsp;
			<a><s:text name="lblprev"></s:text></a>&nbsp;&nbsp;
			<a href="/hongling/orden/dordenPage.do?pageindex=${pageindex+1}&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblnext"></s:text></a>&nbsp;&nbsp;
			<a href="/hongling/orden/dordenPage.do?pageindex=${pagecount-1}&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblend"></s:text></a>&nbsp;&nbsp;
		</s:if>
		<s:if test="%{pageindex>0&&(pagecount-1)>pageindex}">
		<a href="/hongling/orden/dordenPage.do?pageindex=0&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblhome"></s:text></a>&nbsp;&nbsp;
		<a href="/hongling/orden/dordenPage.do?pageindex=${pageindex-1}&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblprev"></s:text></a>&nbsp;&nbsp;
		<a href="/hongling/orden/dordenPage.do?pageindex=${pageindex+1}&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblnext"></s:text></a>&nbsp;&nbsp;
		<a href="/hongling/orden/dordenPage.do?pageindex=${pagecount-1}&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblend"></s:text></a>&nbsp;&nbsp;
		</s:if>
		<s:if test="%{pageindex>0&&(pagecount-1)==pageindex}">
			<a href="/hongling/orden/dordenPage.do?pageindex=0&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblhome"></s:text></a>&nbsp;&nbsp;
			<a href="/hongling/orden/dordenPage.do?pageindex=${pageindex-1}&searchClothingID=${searchClothingID}&searchClientID=${searchClientID}&searchStatusID=${searchStatusID}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&dealDate=${dealDate}&dealToDate=${dealToDate}" style="color:#000000;"><s:text name="lblprev"></s:text></a>&nbsp;&nbsp;
			<a><s:text name="lblnext"></s:text></a>&nbsp;&nbsp;
			<a><s:text name="lblend"></s:text></a>&nbsp;&nbsp;
		</s:if>
		<input type="text" id="changePage" style="width:30px;border: 1px solid #c69b6e;" onkeypress="$.dorden_page.enterPress(event);" onkeydown="$.dorden_page.enterPress();"/>
	</div>
	<div>
		
		</div>
</div>
<div style="clear:both;"></div>
</div>
	<form id="toAddOrdenJsp" method="post">
		<s:hidden id="ordenID2" name="orden.OrdenID"></s:hidden>
		<s:hidden id="copyFlag" name="copyFlag"></s:hidden>
	</form>
	<s:if test="#session.SessionKey_srUserID!=null">
		<iframe id="ccbMall" src="http://mall.ccb.com/alliance/getH.htm" height="0" width="0" frameborder="0" style="display:none" ></iframe>
		<script type="text/javascript">
		  var my_width  = Math.max(document.documentElement.clientWidth,document.body.clientWidth);
		  var my_height = Math.max(document.documentElement.clientHeight,document.body.clientHeight);
		  var ccbMall_iframe = document.getElementById("ccbMall");
		  ccbMall_iframe.src = ccbMall_iframe.src+"#"+my_height+"|"+my_width;
		</script>
	</s:if>
	<div id="payToCCB"></div>
  </body>
</html>
