<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.f.domain.Category" %>
<%@ page import="com.f.domain.Product" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	    <base href="<%=basePath%>">
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
        <title>修改商品</title>
        <link rel="stylesheet" type="text/css" href="web/css/base.css" />
        
        <script language="javascript">
        </script>
	</head>
	<%
	List<Category> list =(List<Category>)request.getAttribute("categorylist");
	Product product=(Product)request.getAttribute("product");
	%>
	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
			<form action="ProductOperate" name="formAdd" method="post">&nbsp; 
			 		<input type="hidden" name="pid" value=<%=product.getId()%>>	
				    <input type="hidden" name="aname" value=<%=request.getAttribute("aname") %> /> 
				     <table width="98%" align="center" border="0" cellpadding="4" cellspacing="1" bgcolor="#CBD8AC" style="margin-bottom:8px">
						<tr bgcolor="#EEF4EA">
					        <td colspan="3" background="web/img/wbg.gif" class='title'><span>修改商品</span>
					        </td>
					    </tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        选择分类：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
						        <select name="cid">
								 <%for(int i=0;i<list.size();i++){ %>
						        	<option value=<%=list.get(i).getId()%>><%=list.get(i).getName()%> ></option>
						        	<%} %>
						        </select>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的编号：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
						         <input type="text" name="code" value=<%=product.getCode()%> />
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的名称：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">
						         <input type="text" name="name"value=<%=product.getName()%> />
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的价钱：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						         <input type="text" name="price" value=<%=product.getPrice()%> />
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的描述：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						         <input type="text" name="info" value=<%=product.getInfo()%> />
						    </td>
						</tr>
						
						
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        &nbsp;
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">
						       <input type="submit" value="修改"/>&nbsp; 
						       <input type="reset" value="重置"/>&nbsp;
						    </td>
						</tr>

					 </table>
			</form>
			
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="button" value="返回" style="width: 80px;" onclick="history.back(-1)"/>
			    </td>
			  </tr>
		    </table>
			
   </body>
</html>
