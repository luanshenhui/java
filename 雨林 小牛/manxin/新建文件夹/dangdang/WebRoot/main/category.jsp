<%@page contentType="text/html;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="com.yulin.dangdang.bean.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="book_l_border1" id="__FenLeiLiuLan">
	<div class="book_sort_tushu">
		<h2>
			分类浏览
		</h2>
		<!--1级分类开始-->
		<c:forEach var="cate" items="${cateList}">
		 <c:set var="pid" value="cateList${cate.id}"></c:set>
		 <%
		 	String pid = (String)pageContext.getAttribute("pid");
		 	List<Category> list = (ArrayList<Category>)session.getAttribute(pid);
		 	session.setAttribute("list", list);
		 %>
			<div class="bg_old" onmouseover="this.className = 'bg_white';"
				onmouseout="this.className = 'bg_old';">
				<h3>
					[<a href='book.do?id=${cate.id}'>${cate.name}</a>]
					
				</h3>
				<ul class="ul_left_list">

						<!--2级分类开始-->
						<c:forEach var="cate2" items="${list}">
						<li>
							<a href='book.do?id=${cate2.id}'>${cate2.name}</a>
						</li>
						
						</c:forEach>
						<!--2级分类结束-->

				</ul>
				<div class="empty_left">
				</div>
			</div>

			<div class="more2">
			</div>
			<!--1级分类结束-->
		</c:forEach>


		<div class="bg_old">
			<h3>
				&nbsp;
			</h3>
		</div>
	</div>
</div>
