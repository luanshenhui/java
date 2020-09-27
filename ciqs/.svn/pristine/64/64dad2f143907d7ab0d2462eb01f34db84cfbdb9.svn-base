<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>人员分配</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#person_form").attr("action", "/ciqs/xk/peson?page="+page+"&apply_no="+${obj.apply_no});
			$("#person_form").submit();
		}
		jQuery(function(){
	    	jQuery("div.dpn-content input.datepick").attr("readonly", "readonly");
	        jQuery("div.dpn-content input.datepick").datePicker({
	            clickInput : true,
	            createButton : false,
	            startDate : "2000-01-01"
	        });
	    });
	   
		function downExcel(apply_no) {
			var psn_name = $("#psn_name").val();
			location="/ciqs/xk/downExcel?apply_no="+apply_no+"&psn_name="+psn_name;
		}
		
		jQuery(document).ready(function(){
			$("#uteclear").click(function() {
				$("#psn_name").val("");
			});
		});
		
		function myback(){
			location = "${cxt}/ciqs/xk/findAddpesons;";
		}
		jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
			$(".user-info").css("color","white");
		});
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
<form id="form1" method="get"></form>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：口岸卫生许可证受理 &gt; <a href="${cxt}/ciqs/xk/peson?apply_no=${obj.apply_no}">随机人员</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">查询条件</div>
		<div class="search">
			<div class="main">
				<form action="/ciqs/xk/peson?apply_no=${obj.apply_no}"  method="post" id="person_form">
					<table class="table_search" id="aa">
						<tr>
							<th align="right">随机人员:</th>
							<td align="left"><input type="text" name="psn_name"  style="height: 24px;width:100px" id="psn_name"
								size="14" value="${obj.psn_name}" /></td>
							<td align="right"><input  type="submit"
								class="button" value="查 询"/><input  type="button" class="button" id="uteclear" value="清空"/></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="menu">
				<ul>
					<li><a href="javascript:jumpPage('/ciqs/xk/pesoninit?no=${obj.apply_no}');"><img 
							src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
					<li><a href="#" id="downExcel" onclick="downExcel('${obj.apply_no}')"/><img 
							src="/ciqs/static/dec/images/dpn.oper.export.gif" />&nbsp;下载</a></li>
				</ul>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<td width="25%">随机人员</td>
								<td width="30%">专业</td>
								<td width="30%">特长</td>
								<td width="15%">随机操作时间</td>
							</tr>
						</thead>
						 <c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>${row.psn_name}</td>
									<td>${row.psn_prof}</td>
									<td>${row.psn_goodat}</td>
									<td><fmt:formatDate value="${row.rdm_date}" type="both" pattern="yyyy-MM-dd"/></td>
								</tr>
							 </c:forEach>
						</c:if> 
						<tfoot>
						    <tr>
								<td colspan="4">
									<jsp:include page="/common/pageUtil.jsp" flush="true"/>
								</td>
							</tr>
							<tr>
								<td style="text-align:center" colspan="4">
									<input onclick="myback()"
									class="button" value="返回" type="button" />
								</td>
							</tr>
                    	</tfoot>
					</table>
			</div>
		</div>
	</div>
</body>
</html>
