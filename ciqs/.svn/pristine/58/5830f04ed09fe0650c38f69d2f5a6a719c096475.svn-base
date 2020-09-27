<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>食品备案</title>
<style  type="text/css">
.abutton{
/*     display: block; */
    height: 35px;
    width: 140px;
    background-color: #ff9f07;
    color: #FFF;
    line-height: 40px;
    text-align: center;
    font-weight: bold;
    line-height: 35px;
}
</style>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
		var apply_no=$("#apply_no").val();
		function pageUtil(page) {
		if(!page){
			page=1;
		}
		var url="/ciqs/extxz/peson?page="+page;
			if(apply_no){
				url=url+"&apply_no="+apply_no;
			}
			$("#person_form").attr("action", url);
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
	   
		function downExcel() {
			var apply_time_begin = $("#apply_time_begin").val();
			var apply_time_over = $("#apply_time_over").val();
			var comp_name = $("#comp_name").val();
			var psn_name = $("#psn_name").val();
			var bel_scope = $("#bel_scope").val();
			var param="?apply_time_begin="+apply_time_begin+"&apply_time_over="+
			apply_time_over+"&comp_name="+comp_name+"&psn_name="+psn_name+"&bel_scope="+bel_scope;
			window.location.href = "/ciqs/extxz/downExcel"+param;
		}
		jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政许可 /出口食品生产企业备案</span><div>");
			$(".user-info").css("color","white");
			$("#uteclear").click(function() {
				$("#apply_time_begin").val("");
				$("#apply_time_over").val("");
				$("#comp_name").val("");
				$("#psn_name").val("");
				$("#bel_scope").val("");
			});
		});
</script>
</head>
<body>
<%@ include file="/common/headMenu2.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="dpn.frame.html">食品备案系统</a> &gt; <a href="${cxt}/ciqs/expFoodProd/peson?apply_no=${apply_no}">随机人员</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
<!-- 		<div class="title">查询条件</div> -->
		<div class="search">
			<div class="main">
				<form action="/ciqs/expFoodProd/peson?apply_no=${obj.apply_no}"  method="post" id="person_form">
					<table class="table_search" id="aa">
						<tr>
							<td style="width: 250px;" align="left">企业名称:</td>
							<td style="width: 250px;" align="left">随机人员:</td>
							<td style="width: 250px;" align="left">地区范围:</td>
						</tr>
						<tr>
							<td align="left"><input type="text" name="comp_name"  style="height: 24px;width:180px" id="comp_name"
								size="14"  value="${obj.comp_name}"/></td>
							<td align="left"><input type="text" name="psn_name"  style="height: 24px;width:180px" id="psn_name"
								size="14" value="${obj.psn_name}" /></td>
							<td align="left">
							 	<select id="bel_scope" class="search-input input-175px" style="height: 30px;width:180px" name="bel_scope">
										<option value="1" <c:if test="${obj.bel_scope == 1}"> selected="selected" </c:if>>1级部门</option>
										<option value="2" <c:if test="${obj.bel_scope == 2}"> selected="selected" </c:if>>2级部门</option>
										<option value="3" <c:if test="${obj.bel_scope == 3}"> selected="selected" </c:if>>3级部门</option>
								</select>
							</td>
						</tr>
						<tr>
							<td style="width: 250px;" align="left">申请时间:</td>
							<td style="width: 250px;" align="left"></td>
							<td style="width: 250px;" align="left"></td>
						</tr>
						<tr>
							<td align="left">
								<input type="text" name="apply_time_begin"  class="search-input input-175px datepick " id="apply_time_begin"
								style="height: 24px;width:180px" size="14"  value="${apply_time_begin}"/>
								<input type="hidden" value="${obj.apply_no}"  id="apply_no"/>
							</td>
							<td align="left">	
								<input type="text" name="apply_time_over"  class="search-input input-175px datepick " id="apply_time_over"
								style="height: 24px;width:180px" size="14"  value="${apply_time_over}"/>
							</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td align="right" colspan="3" style="padding-top: 15px;"><input  type="submit" class="abutton" value="查 询" style="margin-left: 320px;"/>
							<input  type="button" class="abutton" id="uteclear" value="清空" style="margin-left: 80px;"/></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div style="height:30px">
		<span style="float: left;">
		共找到<span style="color: #fe8300;font-size: 18px;"> ${counts}  </span>条记录      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;          共<span style="color: #fe8300;font-size: 18px;"> ${page} </span>页
		</span>
		</div>
		<div class="table">
			<div class="menu">
				<ul>
					<li><a href="javascript:jumpPage('/ciqs/extxz/pesoninit?no=${obj.apply_no}&apply_no=${obj.apply_no}');"><img 
							src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
					<li><a href="#" id="downExcel" onclick="downExcel()"/><img 
							src="/ciqs/static/dec/images/dpn.oper.export.gif" />&nbsp;下载</a></li>
				</ul>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<td style="height:50px">
									申请时间
								</td>
								<td>
									企业名称
								</td>
								<td>
									随机人员
								</td>
<!-- 								<td> -->
<!-- 									地区范围 -->
<!-- 								</td> -->
								<td>
									申请形式
								</td>
								<td>
									流程环节
								</td>
<!-- 								<td> -->
<!-- 									操作 -->
<!-- 								</td> -->
							</tr>
						</thead>
						 <c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td style="height:50px"><fmt:formatDate value="${row.apply_time}" type="both" pattern="yyyy-MM-dd"/></td>
									<td>${row.comp_name}</td>
									<td>${row.psn_name}</td>
<!-- 									<td>${row.bel_scope}级部门</td> -->
									<td>
										${row.apply_type}
									</td>
									<td>
										${row.proc_type}
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
