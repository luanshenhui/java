<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.lsh.action.*"  %>
<%@ page import="com.lsh.domain.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.lsh.service.*" %>
<%@ page import="javax.servlet.http.HttpServlet"  %>
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

        
        <title>查看所有类别</title>
        
        <script type="text/javascript">
     	function m(){
	//	alert("确定返回true,取消返回false",confirm返回的是boolean值);
		if(window.confirm("是否确认删除")){
		//window.close();	//加else不好用(return+else最多只能出现2次)	
		return true;
		}
		return false;
	}
    </script>
<!-- onsubmit="return m();"       </script>-->

	</head>


			
	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
	
<!--<pg:pager maxPageItems="5" url="cation" maxIndexPages="2">-->
			<table width="98%" border="0" cellpadding="2" cellspacing="1" bgcolor="#D1DDAA" align="center" style="margin-top:8px">
				<tr bgcolor="#E7E7E7">
					<td height="14" colspan="7" background="web/img/tbg.gif">&nbsp; 查看全部类别&nbsp;</td>
				</tr>
				<tr bgcolor="#FAFAF1">
					<td height="14" colspan="7" background="web/img/tbg.gif">&nbsp;

				<form action="" method="post">

				商品类别&nbsp;&nbsp;
				
				<select id="lei" name="search" style="width:100px" onchange="m()">
				
					<option value="all">全部</option>
					
				</select>
				&nbsp;&nbsp;
				
				商品编号<input type="text" name="searchCode" />&nbsp;&nbsp;
				商品名称<input type="text" name="searchName" />&nbsp;&nbsp;
				
				<input type="submit" value="查询" />
				
				</form>

					&nbsp;</td>
				</tr>
				<tr align="center" bgcolor="#FAFAF1" height="22">
					<td width="14%">序号</td>
					<td width="14%">商品编号</td>
					<td width="14%">商品名称</td>
					<td width="14%">商品价钱</td>
					<td width="14%">商品描述</td>
					<td width="14%">商品分类</td>
					<td width="16%">操作</td>
		        </tr>	

			<%List<Product> list=new ArrayList<Product>();
			list=(List<Product>)request.getAttribute("Product"); %>
			<%int i=1; %>
			<%for(Product c:list){ %>
<!--			 <pg:item>-->
			
				<tr align='center' bgcolor="#FFFFFF" onmouseover="this.style.backgroundColor='#f5f5f5'" onmouseout="this.style.backgroundColor='#FFFFFF'" height="22">
						
					<td align="center">
					<%=i++ %>					
					</td>
					<td align="center">
						<%=c.getCode() %>
					</td>
					<td align="center">
					  <%=c.getName() %>
					</td>
			
					<td align="center">
						<%=c.getPrice() %>
					</td>
					<td align="center">
						<%=c.getInfo() %>
					</td>
					<td align="center">
						<%=c.getCategory().getName()%>
					</td>
					
					<td align="center">
						<a href="categoryview?id=<%=c.getId()%>" class="pn-loperator">查看</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="categoryedit?id=<%=c.getId()%>" class="pn-loperator">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="categorydel?id=<%=c.getId()%>" class="pn-loperator" onclick="return m();" >删除</a>
					</td>
				</tr>
<!--</pg:item>-->
					<%} %>


<!--   <tr>-->
<!--   <td align="center" colspan="3">-->
<!--   <pg:index>-->
<!--       <pg:first><a href="${pageUrl}">First</a></pg:first>-->
<!--       <pg:prev><a href="${pageUrl}">Previous</a></pg:prev>-->
<!--       -->
<!--       <pg:pages>-->
<!--           <a href="${pageUrl}">[${pageNumber}]</a>-->
<!--       </pg:pages>-->
<!--       -->
<!--       <pg:next><a href="${pageUrl}">Next</a></pg:next>-->
<!--     <pg:last><a href="${pageUrl}">Last</a></pg:last>      -->
<!--   </pg:index>-->
<!--   </td>-->
<!--   </tr>-->


			</table> 
<!--</pg:pager>-->
			
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="button" value="添加" style="width: 80px;" onclick="window.location.href='web/page/productadd.jsp'"/>
			    </td>
			  </tr>
		    </table>
   </body>
</html>
