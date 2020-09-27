<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.dongxianglong.domain.Product"%>
<%@ page import="com.dongxianglong.domain.Category"%>
<%@taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
        
        <link rel="stylesheet" type="text/css" href="web/css/base.css" />

        
        <title>查看全部进货</title>

	</head>
	
	
	


	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>

  <pg:pager maxPageItems="4" url="productlist" maxIndexPages="2">

			<table width="98%" border="0" cellpadding="2" cellspacing="1" bgcolor="#D1DDAA" align="center" style="margin-top:8px">
				<tr bgcolor="#E7E7E7">
					<td height="14" colspan="7" background="web/img/tbg.gif">&nbsp; 查看全部进货&nbsp;</td>
				</tr>

				<tr align="center" bgcolor="#FAFAF1" height="22">
					<td width="14%">序号</td>
					<td width="14%">商品编号</td>
					<td width="14%">商品名称</td>
					<td width="14%">进货日期</td>
					<td width="14%">进货数量</td>
					<td width="14%">进货金额</td>
					<td width="14%">操作员</td>
					
		        </tr>	
				  
                   <%int i=1; %>
			      
			       <pg:item>    
				<tr align='center' bgcolor="#FFFFFF" onmouseover="this.style.backgroundColor='#f5f5f5'" onmouseout="this.style.backgroundColor='#FFFFFF'" height="22">
					<td align="center">
						<%=i++%>
					</td>
					<td align="center">
						
					</td>
					<td align="center">
					   
					</td>
					<td align="center">
						
					</td>
					<td align="center">
						
					</td>
					<td align="center">
						
					</td>
					<td align="center">
						
					</td>

				</tr>
				</pg:item>
			

    <tr>
   <td align="center" colspan="3">
   <pg:index>
       <pg:first><a href="${pageUrl}">首页</a></pg:first>
       <pg:prev><a href="${pageUrl}">上一页</a></pg:prev>
       
       <pg:pages>
           <a href="${pageUrl}">[${pageNumber}]</a>
       </pg:pages>
       
       <pg:next><a href="${pageUrl}">下一页</a></pg:next>
     <pg:last><a href="${pageUrl}">尾页</a></pg:last>      
   </pg:index>
   </td>
   </tr>




			</table>
			</pg:pager>

			
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="button" value="添加" style="width: 80px;" onclick="window.location.href='/erp/stockadd'"/>
			    </td>
			  </tr>
		    </table>
   </body>
</html>
