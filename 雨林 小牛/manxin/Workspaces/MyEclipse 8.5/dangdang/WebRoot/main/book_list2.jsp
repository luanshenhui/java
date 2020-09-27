<%@page contentType="text/html;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="com.yulin.dangdang.bean.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>当当图书 – 全球最大的中文网上书店</title>
		<script type="text/javascript" src="../js/prototype-1.6.0.3.js">
		</script>
		<link href="../css/book.css" rel="stylesheet" type="text/css" />
		<link href="../css/second.css" rel="stylesheet" type="text/css" />
		<link href="../css/secBook_Show.css" rel="stylesheet" type="text/css" />
		<link href="../css/list.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
		&nbsp;

		<!-- 头部开始 -->
		<%@include file="../common/head.jsp"%>
		<!-- 头部结束 -->

		<div style="width: 962px; margin: auto;">
			<a href="#"><img src="../images/default/book_banner_081203.jpg" border="0" /> </a>
		</div>
		<div class='your_position'>
			您现在的位置:&nbsp;
			<a href='#'>当当图书</a> &gt;&gt;
			<font style='color: #cc3300'><strong>小说</strong> </font>
		</div>

		<div class="book">

			<!--左栏开始-->
			<div id="left" class="book_left">
				<div id="__fenleiliulan">
					<div class=second_l_border2>
						<h2>
							分类浏览
						</h2>
						<ul>
							<li>
								<div>
									<div class=second_fenlei>
										&middot;全部&nbsp;(23)
									</div>
								</div>
							</li>
							<div class="clear"></div>
							
							<!--2级分类开始-->
							<c:forEach var="cate" items="${cateList}">
							<li>
								<div>
									<div class=second_fenlei>
										&middot;
									</div>
									<div class=second_fenlei>
										<a href="#">${cate.name }&nbsp;(10)</a>
									</div>
								</div>
							</li>
						   
							<div class="clear"></div>
							</c:forEach>
							<!--2级分类结束-->
							
							<li>&nbsp;
								<div></div>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<!--左栏结束-->

			<!--中栏开始-->
			<div class="book_center">

				<!--图书列表开始-->
				<div id="divRight" class="list_right">

					<div id="book_list" class="list_r_title">
						<div class="list_r_title_text">
							排序方式
						</div>
						<select onchange='' name='select_order' size='1'
							class='list_r_title_ml'>
							<option value="">
								按上架时间 降序
							</option>
						</select>
						<div id="divTopPageNavi" class="list_r_title_text3">

							<!--分页导航开始-->
							
							<div class='list_r_title_text3a'>
								<a name=link_page_next
									href="#">
								<img src='../images/page_up.gif' /> </a>
							</div>
	
							<div class='list_r_title_text3a'>
								<img src='../images/page_up_gray.gif' />
							</div>
				
							<div class='list_r_title_text3b'>
								第1页/共5页
							</div>
							
							<div class='list_r_title_text3a'>
								<a name=link_page_next
									href="#">
									<img src='../images/page_down.gif' /> </a>
							</div>
			
							<div class='list_r_title_text3a'>
								<img src='../images/page_down_gray.gif' />
							</div>

							<!--分页导航结束-->
						</div>
					</div>
					
					<!--商品条目开始-->
						<c:forEach items="${productList}" var="product" varStatus="index">
						<c:set value="${index.count - 1}" var="in"></c:set>
						<%long in1 = (Long)pageContext.getAttribute("in"); 
							int in = (int)in1;
							List<Book> list = (List<Book>)session.getAttribute("bookList");
						%>
						<c:set value="<%=list.get(in)%>" var="book"></c:set>
						<div class="list_r_line"></div>
						<div class="clear"></div>

						<div class="list_r_list">
							<span class="list_r_list_book"><a name="link_prd_img" href='#'>
								<img src="../productImages/1.jpg" /> </a> </span>
							<h2>
								<a name="link_prd_name" href='#'>${product.product_name} ${book.id }</a>
							</h2>
							<h3>
								顾客评分：100
							</h3>
							<h4 class="list_r_list_h4">
								作 者:
								<a href='#' name='作者'>菜鸟</a>
							</h4>
							<h4>
								出版社：
								<a href='#' name='出版社'>人民邮电出版社</a>
							</h4>
							<h4>
								出版时间：2009-01-01
							</h4>
							<h5>
								这是一本好书，描述了Struts、Hibernate和Spring等框架的整合应用！
							</h5>
							<div class="clear"></div>
							<h6>
								<span class="del">￥79</span>
								<span class="red">￥60</span>
								节省：￥19
							</h6>
							<span class="list_r_list_button"> 
							<a href="#"> 
							<img src='../images/buttom_goumai.gif' /> </a>
							<span id="cartinfo"></span>
						</div>
						</c:forEach>
						<div class="clear"></div>
				</div>
				<!--图书列表结束-->

			</div>
			<!--中栏结束-->
			<div class="clear"></div>
		</div>

		<!--页尾开始 -->
		<%@include file="../common/foot.jsp"%>
		<!--页尾结束 -->
	</body>
</html>
