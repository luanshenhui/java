<%@ page language="java"  import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.f.domain.Category" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg" %>
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
	<%
	List<Category> list =(List<Category>)request.getAttribute("categorylist");
	%>
	<script type="text/javascript">
		function shanchu(){
			if(window.confirm("是否删除?")){
				return true;
			}
			return false;
		}
		
	
	</script>
        <title>查看全部类别</title>

	</head>
	<body leftmargin="2" topmargin="9" background='web/img/allbg.gif'>
			
			<pg:pager maxPageItems="2" url="CategoryList">
			<table width="98%" border="0" cellpadding="2" cellspacing="1" bgcolor="#D1DDAA" align="center" style="margin-top:8px">
				<tr bgcolor="#E7E7E7">
					<td height="14" colspan="7" background="web/img/tbg.gif">&nbsp; 查看全部类别&nbsp;</td>
				</tr>
				<tr align="center" bgcolor="#FAFAF1" height="22">
					<td width="14%">序号</td>
					<td width="14%">类别编号</td>
					<td width="14%">类别名称</td>
					<td width="14%">类别描述</td>
					<td width="16%">操作</td>
		        </tr>	
				
				<%for(int i=0;i<list.size();i++){ %>
				 <pg:item>
				<tr  align='center' bgcolor="#FFFFFF" onmouseover="this.style.backgroundColor='#f5f5f5'" onmouseout="this.style.backgroundColor='#FFFFFF'" height="22">
					<td align="center">
						<%=i+1 %>
					</td>
					<td align="center">
						<%=list.get(i).getCode() %>

					</td>
					<td align="center">
						<%=list.get(i).getName() %>
					</td>
					<td align="center">
						<%=list.get(i).getInfo() %>	
					</td>
					
					<td align="center">
						<a href="CategoryOperate?aname=View&cid=<%=list.get(i).getId()%>" class="pn-loperator">查看</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="CategoryToEdit?aname=Edit&cid=<%=list.get(i).getId()%>" class="pn-loperator">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="CategoryOperate?aname=Delete&cid=<%=list.get(i).getId()%>" onclick=" return shanchu()" class="pn-loperator" >删除</a>
					
					</td>
					
				</tr>
				
 				  </pg:item>
				<%} %>
				 <tr>
				   <td align="center" colspan="3">
				   <pg:index>
				       <pg:first><a href="${pageUrl}">首页</a></pg:first>
				       <pg:prev><a href="${pageUrl}">上一页</a></pg:prev>
				       
				       <pg:pages>
				           <a href="${pageUrl}">[${pageNumber}]</a>
				       </pg:pages>
				       
				       <pg:next><a href="${pageUrl}">下一页</a></pg:next>
				     <pg:last><a href="${pageUrl}">最后一页</a></pg:last>      
				   </pg:index>
				   </td>
				  </tr>
			</table>
			</pg:pager>
			<table width='98%'  border='0'style="margin-top:8px;margin-left: 5px;">
			  <tr>
			    <td>
			      <input type="button" value="添加" style="width: 80px;" onclick="window.location.href='web/page/categoryadd.jsp'"/> 
							   		  	
			    </td>
			  </tr>
		    </table>
   </body>
</html>
