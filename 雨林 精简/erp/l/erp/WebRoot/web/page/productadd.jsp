<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.dongxianglong.domain.Category"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	    <base href="<%=basePath%>">
        <title>添加商品</title>
        <link rel="stylesheet" type="text/css" href="web/css/base.css" />
	</head>
<%
//CategoryService service=new CategoryServiceImpl();
List<Category>list=(List)request.getAttribute("catelist");
%>
	

	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
			<form action="productadd" name="formAdd" method="post">
			
				     <table width="98%" align="center" border="0" cellpadding="4" cellspacing="1" bgcolor="#CBD8AC" style="margin-bottom:8px">
						<tr bgcolor="#EEF4EA">
					        <td colspan="3" background="web/img/wbg.gif" class='title'><span> 添加商品</span>
					        </td>
					    </tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        选择分类：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
						        <select name="cid">
						               <%for(Category c:list){ %>
						           <option value="<%=c.getId()%>"><%=c.getName()%></option>
                                        <%}%>
						        	
						        </select>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的编号：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">	         
						         <input type="text" name="code"/>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的名称：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">
						         <input type="text" name="name" />
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的价钱：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						         <input type="text" name="price"/>
						    </td>
						</tr>
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        商品的描述：
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">       
						         <input type="text" name="info"/>
						    </td>
						</tr>
						
						<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='red';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22">
						    <td width="25%" bgcolor="#FFFFFF" align="right">
						        &nbsp;
						    </td>
						    <td width="75%" bgcolor="#FFFFFF" align="left">
						       <input type="submit" value="添加"/>&nbsp; 
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
