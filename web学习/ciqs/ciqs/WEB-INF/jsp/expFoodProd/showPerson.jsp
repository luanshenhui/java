<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>出口食品生产企业备案核准</title>
<%@ include file="/common/resource_new.jsp"%>
<style  type="text/css">
select,input{
    width:140px;
}
</style>
<script type="text/javascript">
	jQuery(document).ready(function(){
			$(".user-info").css("color","white");
			if($("#peson").val()==3){
		  		$(".tr_3").show();
		  		$(".tr_4").hide();
		  	}else if($("#peson").val()==4){
		  		$(".tr_3").show();
		  		$(".tr_4").show();
		  	}else{
		  		$(".tr_3").hide();
		  		$(".tr_4").hide();
		  	}
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
			当前位置：出口食品生产企业备案核准 
		</div>
		<jsp:include page="/common/message.jsp" flush="true" />
		<form action="" id="tijiao" method="post">
			<div class="table" >
				<div class="main">
					<table>
						<thead>
							<tr>
								<td width="15%">姓名</td>
								<td width="15%">级别</td>
								<td width="10%">专长</td>
								<td width="10%">是否在岗</td>
								<td width="15%">所在范围</td>
								<td width="10%">状态</td>
								<td width="15%">不接受原因</td>
								<td width="10%">操作</td>
							</tr>
						</thead>
						<c:forEach items="${list}" var="row">
							<tr>
								<td>${row.psn_name}</td>
								<td>
									<c:if test="${row.psn_type=='0'}">组长</c:if>
									<c:if test="${row.psn_type=='1'}">组员</c:if>
								</td>
								<td title="${row.psn_prof}">${row.psn_goodat}</td>
								<td>
									<c:if test="${row.in_post=='1'}">是</c:if>
									<c:if test="${row.in_post!='1'}">否</c:if>
								</td>
								<td>
									<c:if test="${not empty row.levelDept_1}">${row.levelDept_1}</c:if>
									<c:if test="${not empty row.levelDept_2}">-${row.levelDept_2}</c:if>
									<c:if test="${not empty row.levelDept_3}">-${row.levelDept_3}</c:if>
								</td>
								<td >
								<c:if test="${row.status eq '0'}">不接受</c:if>
								<c:if test="${row.status eq '1'}">接受</c:if>
								<c:if test="${row.status ne '1' and row.status ne '0'}">待接受</c:if>
								</td>
								<td >${row.des}</td>
								<td>
									<c:if test="${row.status eq '0'}">
									<a href='javascript:jumpPage("/ciqs/expFoodPOF/newJump?id=${row.id}&psn_id=${row.psn_id}&apply_no=${row.apply_no}");'>
							      	  <span class="data-btn margin-auto">修改</span>
<!-- 							      	  不受理 -->
							        </a>
									</c:if>
									<c:if test="${row.status ne '0'}">
									<a href='javascript:jumpPage("/ciqs/expFoodPOF/newJump?id=${row.id}&psn_id=${row.psn_id}&apply_no=${row.apply_no}");'>
							      	  <span class="data-btn margin-auto">修改</span>
							        </a>
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</div>
		</form>
	</div>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
		<input type="button" class="mbutton" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
</body>
</html>