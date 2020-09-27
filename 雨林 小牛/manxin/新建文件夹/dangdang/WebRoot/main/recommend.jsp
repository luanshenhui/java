<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.sun.xml.internal.bind.v2.schemagen.xmlschema.Import"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.*"%>
<%@page import="com.yulin.dangdang.bean.*"%>
<%@page import="com.yulin.dangdang.controller.*"%>

<h2>
	编辑推荐
	<!-- 从d_book和d_product中随机取出5条数据 -->
</h2>
<div id=__bianjituijian/danpin>
	<div class=second_c_02>
		<c:forEach items="${listRecommend}" var="list">
		<div class=second_c_02_b1>
			<div class=second_c_02_b1_1>
				<a href='#' target='_blank'><img src="../productImages/6.jpg" width=70 border=0 /> </a>
			</div>
			<div class=second_c_02_b1_2>
				<h3>
				
					<a href='#' target='_blank' title='输赢'>${list.product_name}</a>
				</h3>
				<h4>
					作者：${list.book.author}
					<br />
					出版社：${list.book.publishing}&nbsp;&nbsp;&nbsp;&nbsp;出版时间：${list.book.publish_time}
				</h4>
				<h5>
					简介${list.description}
				</h5>
				<h6>
					定价：￥${list.fixed_price }&nbsp;&nbsp;当当价：￥${list.dang_price}
				</h6>
				<div class=line_xx></div>
			</div>
		</div>
		</c:forEach>
		
		
	</div>
</div>
