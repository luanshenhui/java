<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>出口食品生产企业备案核准</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#file_form").attr("action", "/ciqs/expFoodPOF/showFileMessage?page="+page);
			$("#file_form").submit();
		}
		jQuery(function(){
	    	jQuery("div.dpn-content input.datepick").attr("readonly", "readonly");
	        jQuery("div.dpn-content input.datepick").datePicker({
	            clickInput : true,
	            createButton : false,
	            startDate : "2000-01-01"
	        });
	    });
	   
		jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政许可 /知识库</span><div>");
			$(".user-info").css("color","white");
			$("#uteclear").click(function() {
				$("#apply_time_begin").val('');
				$("#create_date_end").val('');
				$("#file_name").val('');
			});
		});
		jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>出口食品生产企业备案核准</span><div>");
			$(".user-info").css("color","white");
		});
</script>
</head>
<body>
<%@ include file="/common/headMenuBa.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：出口食品生产企业备案核准 &gt;<a href="#">知识库</a> 
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
<!-- 		<div class="title">查询条件</div> -->
		<div class="search">
			<div class="main">
				<form action="/ciqs/expFoodPOF/showFileMessage"  method="post" id="file_form">
					<table class="table_search" id="aa">
						<tr>
							<td >创建时间:</td>
							<td></td>
							<td >文件名称:</td>
						</tr>
					
						<tr>
							<td align="left">
								<input type="text" name="create_date_begin"  class="search-input input-175px datepick " id="apply_time_begin"
								 size="14"  value="${obj.create_date_begin}"/>
							</td>
							<td align="left">	
								<input type="text" name="create_date_end"  class="search-input input-175px datepick " id="create_date_end"
								 size="14"  value="${obj.create_date_end}"/>
							</td>
							<td align="left"><input type="text" name="file_name"   id="file_name"
								size="14"  value="${obj.file_name}"/></td>
							<td ><input  type="submit"
								class="abutton" value="查 询" style="margin:0px"/>
								<input  type="button" class="abutton" id="uteclear" style="margin: 0px;" value="清空"/></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="menu">
				<ul>
					<li><a href="javascript:jumpPage('/ciqs/expFoodPOF/newFileMessage');"><img 
							src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
				</ul>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<td>
									文件名称
								</td>
								<td>
									上传时间
								</td>
								<td>
									上传人
								</td>
								<td>
									操作
								</td>
							</tr>
						</thead>
						 <c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>${row.file_name}</td>
									<td><fmt:formatDate value="${row.create_date}" type="both" pattern="yyyy-MM-dd"/></td>
									<td>${row.user_name}</td>
									<td>
										<a href="#" onclick='window.location.href="/ciqs/expFoodPOF/download?fileName=${row.file_location}"'>下载</a>
									</td>
								</tr>
							 </c:forEach>
						</c:if> 
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
			</div>
		</div>
	</div>
</body>
</html>
