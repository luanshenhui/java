<%@page contentType="text/html;charset=utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h2>
	<span class="more"><a href="new.do?returnId=101" target="_blank">更多&gt;&gt;</a> </span>最新上架图书
</h2>
<div class="book_c_04">

	<!--新书A开始 根据d_book中的publish_time从d_product和d_book中取出最大的5条数据-->
		<c:forEach items="${listNew}" var="list">
	<div class="second_d_wai">
		<div class="img">
			<a href="#" target='_blank'><img
					src="../productImages/8.jpg" border=0 /> </a>
		</div>
		<div class="shuming">
			<a href="#" target="_blank">书籍标题:${list.product_name}</a><a href="#" target="_blank"></a>
		</div>
		<div class="price">
			${list.fixed_price}
		</div>
		<div class="price">
			${list.dang_price}
		</div>
	</div>
		</c:forEach>
	<div class="book_c_xy_long"></div>
	<!--热销图书A结束-->

</div>
<div class="clear"></div>