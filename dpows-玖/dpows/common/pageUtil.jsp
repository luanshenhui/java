<%@page contentType="text/html; charset=UTF-8"%>
<%
	int itemCounts = Integer.parseInt(request.getAttribute("size").toString());//共计记录数
	int itmInpage = Integer.parseInt(request.getAttribute("itemInPage").toString());//每页显示记录数
	String currentPages =(String)(request.getAttribute("page")==null?"1":request.getAttribute("page"));//当前页码
	int pageCount = itemCounts%itmInpage==0?(itemCounts/itmInpage):(itemCounts/itmInpage)+1;//总页数
	int i=0;
%>
	<span class="black_12px">
		<%if(Integer.parseInt(currentPages)!=1) { %>
		 <a href="javascript:pageUtil('1')">第一页</a>
		 <%}else{ %>
		 第一页
	<%} %>
		 | 
		<%if(Integer.parseInt(currentPages)<=pageCount && Integer.parseInt(currentPages)>1) {%>
	<a href="javascript:pageUtil('<%=Integer.parseInt(currentPages)-1 %>')">上一页</a>
	<%}else{ %>
	上一页
	<%} %>
	| 
	<%
	int p = 0;
	if(Integer.parseInt(currentPages)<10){
		p=1;
	}else if(Integer.parseInt(currentPages)==pageCount || pageCount-Integer.parseInt(currentPages)<=5){
		p=pageCount-9;
	}else if(Integer.parseInt(currentPages)%5==0 || (Integer.parseInt(currentPages)>10 && pageCount-Integer.parseInt(currentPages)>5)){
		p=Integer.parseInt(currentPages)-4;
	}
	for(int pg=p;pg<= (p+9>pageCount?pageCount:p+9);pg++){
		if(Integer.parseInt(currentPages)==pg){
	%>
		&nbsp;<span class="hot">[<%=pg %>]</span>&nbsp;
		<%}else{%>
		&nbsp;<a href="javascript:pageUtil('<%=pg %>')">
		<%=pg %>
		</a>&nbsp;
		
	<%}}%>
	| 
	<%if(Integer.parseInt(currentPages)<pageCount) {%>
	<a href="javascript:pageUtil('<%=Integer.parseInt(currentPages)+1 %>')">下一页</a>
	<%}else{ %>
	下一页
	<%} %>
		 | 
		 <%if(Integer.parseInt(currentPages)!=pageCount && pageCount!=0) { %>
		 <a href="javascript:pageUtil('<%=pageCount %>')">最后一页</a>
		 <%}else{ %>
		 最后一页
		 <%} %>
		 &nbsp;&nbsp;
	</span>

