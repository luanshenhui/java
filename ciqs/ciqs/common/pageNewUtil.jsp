<%@ page contentType="text/html; charset=utf-8"%>
<style type="text/css">
tfoot tr td{text-align:center;padding-top:10px;padding-bottom:10px;border-width:0}
tfoot tr td{border-width:0}
tfoot tr td ul{margin-top:20px;margin-right:auto;margin-bottom:0;margin-left:auto;padding-left:0;text-align:center;margin-bottom:20px;position:relative;left:50%;float:left}
tfoot tr td ul li{float:left;border:1px solid #dadada;height:20px;line-height:20px;margin:0 2px;position:relative;right:50%;float:left;list-style-type: none;}
tfoot tr td ul li a{display:block;padding:0 6px}
tfoot tr td ul li.selected{background:#a9d2ff;display:block;padding:0 6px;font-weight:bold}
</style>
<%
	String counts = request.getAttribute("counts").toString();
	String itemInPage = request.getAttribute("itemInPage").toString();
	String currentPages = request.getAttribute("pages").toString();//当前页码

	int i=0;
	
	int itemCounts = (new Integer(counts)).intValue();//共计记录数

	int itmInpage = (new Integer(itemInPage)).intValue();//每页显示记录数

	int pageCount = (new Integer(itemCounts%itmInpage==0?(itemCounts/itmInpage):(itemCounts/itmInpage+1))).intValue();//总页数

%>
	<tr>
         <td colspan="100" id="page">
             <ul>
                 <li>
                 	<%if(Integer.parseInt(currentPages)!=1) { %>
					 <a href="javascript:pageUtilNew('1')">首页</a>
					<%}
			          else { %>
					     首页
				    <%} %>
                 </li>
                 <li>
                 	<%if(Integer.parseInt(currentPages)<=pageCount && Integer.parseInt(currentPages)>1) {%>
				       <a href="javascript:pageUtilNew('<%=Integer.parseInt(currentPages)-1 %>')">上页</a>
				    <%}
			          else { %>
				           上页
				    <%} %>
                 </li>
                 <li><a>...</a></li>
                 <%
			    	   int p = 0;
			    	   if(Integer.parseInt(currentPages)<10) {
			    	       p=1;
			    	   }
			           else if(Integer.parseInt(currentPages)==pageCount || pageCount-Integer.parseInt(currentPages)<=5) {
			    	       p=pageCount-9;
			    	   }
			           else if(Integer.parseInt(currentPages)%5==0 || (Integer.parseInt(currentPages)>10 && pageCount-Integer.parseInt(currentPages)>5)) {
			    	       p=Integer.parseInt(currentPages)-4;
			    	   }
			           
			    	   for(int pg=p;pg<= (p+9>pageCount?pageCount:p+9);pg++) {
			    	       if(Integer.parseInt(currentPages)==pg) {
			               %>
			        	       <li style="background-color: #EEE"><a href="javascript:void(0);"><%=pg %></a></li>
			        	   <%
			               }
			               else {
			               %>
					           <li><a href="javascript:pageUtilNew('<%=pg %>')"><%=pg %></a></li>
				       <%
			               }
			           }
			     %>
                 <li><a>...</a></li>
                 <li>
                 	<%if(Integer.parseInt(currentPages)<pageCount) {%>
			           <a href="javascript:pageUtilNew('<%=Integer.parseInt(currentPages)+1 %>')">下页</a>
			       <%}
		           else { %>
			             下页
			       <%}%>
                 </li>
                 <li>
                 	<%if(Integer.parseInt(currentPages)!=pageCount && pageCount!=0) { %>
				       <a href="javascript:pageUtilNew('<%=pageCount %>')">尾页</a>
				   <%
		            }
		            else {
		           %>
				         尾页
				   <%}%>
                 </li>
             </ul>
         </td>
     </tr>
