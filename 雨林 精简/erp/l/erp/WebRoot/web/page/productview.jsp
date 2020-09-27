<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.dongxianglong.domain.Category"%>
<%@ page import="com.dongxianglong.domain.Product"%>
<%@ page import="com.dongxianglong.service.CategoryService"%>
<%@ page import="com.dongxianglong.service.CategoryServiceImpl"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
        <title>查看单个商品</title>
        <link rel="stylesheet" type="text/css" href="web/css/base.css" />
	</head>

<%Product product=(Product)request.getAttribute("productview");%>	

	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
			<form action="productview" name="formAdd" method="post">
			
				     <table width="98%" align="center" border="0" cellpadding="4" cellspacing="1" bgcolor="#CBD8AC" style="margin-bottom:8px">
						<tr bgcolor="#EEF4EA">
					        <td colspan="3" background="web/img/wbg.gif" class='title'><span>查看单个商品</span>
					        </td>
					    </tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        所属分类：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
									<%=product.getCategory().getName()%>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的编号：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
						        <%=product.getCode()%>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的名称：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">
						        <%=product.getName()%>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的价钱：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						         <%=product.getPrice()%>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的描述：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						      <%=product.getInfo()%>
						    </td>
						</tr>

					 </table>
			</form>
			
			
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="button" value="返回" style="width: 80px;" onclick="history.back(-1);"/>
			    </td>
			  </tr>
		    </table>
			
			
   </body>
</html>
