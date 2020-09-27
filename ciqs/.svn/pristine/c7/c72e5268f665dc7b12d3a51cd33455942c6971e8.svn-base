<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>评审员管理</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 

		function pageUtil(page) {
			$("#xk_form").attr("action", "${ctx}/expFoodPOF/psyList?page="+page);
			$("#xk_form").submit();
		}
		
		function deptTop(e,param){
	  		$('input[name="expertise_code"]:checked').attr("checked",false);
			var bj=e.getAttribute("id");
				$("#combtn").remove();
				var input = "<input type='button' id='combtn' value='确定' onclick='getExperCom(\""+bj+"\")' />";
				$("#btnTdcom").append(input);
				$.blockUI({ message: $('#deptTop_1'),
			          css:{top:100,left:500}
				});
	  	}
		
		function closeUI(){
			$.unblockUI();
		}
		
		function myreset(){
			$("#psnName").val("");
			$("#psnCode").val("");
			$("#levelDept_1").val("");
			$("#in_post").val("1");
		}
		
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
			当前位置：<a href="#">出口食品生产企业备案核准</a> &gt; <a
				href="<%=request.getContextPath()%>/expFoodPOF/psyList">评审员管理</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="search">
			<div class="main">
				<form action="<%=request.getContextPath()%>/expFoodPOF/psyList"  method="post" id="xk_form">
					<table class="table_search" id="aa">
						<tr>
							<td style="width: 250px;" align="left">姓名:</td>
							<td style="width: 250px;" align="left">评审员编号:</td>
							<td style="width: 250px;" align="left">一级部门:</td>
							<td style="width: 250px;" align="left">是否在岗:</td>
						</tr>
						<tr>
							<td align="left">
								<input type="text" style="height: 24px;width:180px" name="psnName" id="psnName" size="14" value="${psnName}"/>
							</td>
							<td align="left">
								<input type="text" style="height: 24px;width:180px" name="psnCode" id="psnCode" size="14" value="${psnCode}"/>
							</td>
							<td align="left">
								<input type="text" name="levelDept_1" id="levelDept_1" size="8" 
								value="${levelDept_1}" onclick="deptTop(this,1)" />
							</td>
							<td align="left">
								<select id="in_post" name="in_post">
									<option value="1"  <c:if test="${in_post == 1}">  selected="selected" </c:if>>是</option>
									<option value="0"  <c:if test="${in_post == 0}">  selected="selected" </c:if>>否</option>
								</select>
							</td>
						</tr>
						<tr>
							<td style="padding-top: 15px;" colspan="4" >
								<input name="searchF" type="submit" class="abutton" value="查 询" />
								<input type="button" style="margin-left: 5px;" class="abutton" value="清空" onclick="myreset()"/>
						    </td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data">
			<span style="float: left;">
				共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
				分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录
				<input type="hidden" id="msg" value="${msg}"/>
			</span>	
			</div>
			
			<div class="main">
					<div class="menu">
						<ul>
							<li><a href="javascript:jumpPage('<%=request.getContextPath()%>/expFoodPOF/createPsyForm');"><img 
									src="/ciqs/static/dec/images/dpn.oper.create.gif" />&nbsp;新建</a></li>
						</ul>
					</div>
					<table>
						<thead>
							<tr>
								<td style="width:150px">姓名</td>								
								<td style="width:150px">评审员编号</td>
								<td style="width:250px">一级部门</td>
								<td style="width:100px">是否在岗</td>
								<td style="width:80px">操作</td>
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
									<td>${row.psnName}</td>
									<td>${row.psnCode}</td>
									<td>${row.levelDept_1}</td>
									<td>
										<c:if test="${row.in_post==1}">
										是
										</c:if>
										<c:if test="${row.in_post==0}">
										否
										</c:if>
									</td>
									<td>
									<a href='#' onclick="javascript:location='<%=request.getContextPath()%>/expFoodPOF/toDetailForm?psnId=${row.psnId}&type=1'">详情</a>
									|
									<a href='#' onclick="javascript:location='<%=request.getContextPath()%>/expFoodPOF/toPsyUpdateForm?psnId=${row.psnId}&type=1'">修改</a>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<thead>
							<tr>
								<td>姓名</td>								
								<td>评审员编号</td>
								<td>一级部门</td>
								<td>是否在岗</td>
								<td>操作</td>
							</tr>
						</thead>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
			</div>
		</div>
	</div>
	
    <div id="deptTop_1" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">一级部门</div>
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_1Code }">
				<c:forEach items="${psnLevelDept_1Code}" var="row">
					<tr>
						<td  align="left" >
							<c:if test='${row.code!=null}'>
								<input type="checkbox" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.name}'>{ ${row.name} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom">
				<input type="button" id="combtn" value="确定" onclick="getExperCom(this)" />
			</td>
		</tr>
	</table>
</div>	
    
    
	<script type="text/javascript"> 
		jQuery(document).ready(function(){
			if($("#msg").val()=="success"){
				$("#msg").val('');
				alert("操作成功");
			};
		});
		
		function getExperCom(e){
	  		var chk_value1 =[];
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value1.push($(this).val()); 
	  		}); 
	  		$("#"+e).val(chk_value1);
	  		$.unblockUI();
	  	}
	</script>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
		<input type="button" class="mbutton" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
</body>
</html>
