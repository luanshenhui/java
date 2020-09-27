<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>人员分配</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript">
jQuery(document).ready(function(){
	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>口岸卫生许可证核发</span><div>");
	$(".user-info").css("color","white");
});
function tijiao(){
	var laderNames = $("input[name='laderpeson']:checked").val();
	var zzname= laderNames;
	var names = $("input[name='peson']:checked");
/* 	$.each(names,function(i,n){
		if(n.value == laderNames){
		    alert("组长与组员不能是同一人！");
			return;
		}
	});
	 */
	$.each(names,function(i,n){
		if(n.value != zzname){
			laderNames+=","+n.value;
		}
	});
	var laderNames2 = "组长:"+zzname+" 组员:";
	$.each(names,function(i,n){
		if(n.value != zzname){
			laderNames2+=n.value;
		}		
		if(n.value != zzname && names.length-1 != i){
			laderNames2+=",";
		}
	});
	if (typeof(laderNames) == "undefined") { 
		 alert("请输入人数！"); 
		 return;
	}  
	fWindowText1 = window.opener.document.getElementById("peson_name_"+$("#pid").val()); 
	fWindowText1.value = laderNames; 
	fWindowText2 = window.opener.document.getElementById("peson_name_2"+$("#pid").val()); 
	fWindowText2.value = laderNames2; 
	window.close();
}
</script>

</head>
<body>
<%@ include file="/common/headMenu_Xk.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">口岸卫生许可证核发</a> &gt; <a href="${cxt}/ciqs/xk/peson?apply_no=${apply_no}">随机人员</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true" />
		
		<div class="search">
			<div class="main">
				<form action="/ciqs/xk/addpeson?apply_no=${apply_no}&pid=${pid}" method="post">
					
					<input type="hidden" id="pid" value="${pid}"/>
					<input type="hidden" name="sl_org_code" value="${org_code}"/>
					<table class="table_search" id="aa">
						<tr>
							<th style="text-align:left">姓名（组长）:</th>
							<th style="text-align:left">专业（组长）:</th>
							<th style="text-align:left">所在范围（组长）:</th>
						</tr>
						<tr>
							<td style="text-align:left"><input style="width:150px" type="text" name="psn_name" size="5" value="${obj.psn_name}"/></td>
						
							
							<td style="text-align:left">
								<input style="width:150px" type="text" name="psn_prof" size="5" value="${obj.psn_prof}"/>
							</td>
							<td style="text-align:left">
								<select name="bel_scope" style="width:150px">
									<option value="" ></option>
									<c:forEach items="${orglist}" var="row" >
										<option value="${row.org_code}" >${row.name}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th style="text-align:left">姓名（组员）:</th>
							<th style="text-align:left">专业（组员）:</th>
							<th style="text-align:left">所在范围（组员）:</th>
						</tr>
						<tr>
							<td style="text-align:left"><input style="width:150px" type="text" name="z_psn_name" size="5" value="${z_psn_name}"/></td>
							
							<td style="text-align:left">
								<input style="width:150px" type="text" name="z_psn_prof" size="5" value="${z_psn_prof}"/>
							</td>
							<td style="text-align:left">
								<select style="width:150px" name="z_bel_scope">
								    <option value="" ></option>
									<c:forEach items="${orglist}" var="row" >
										<option value="${row.org_code}" >${row.name}</option>
									</c:forEach>
								</select>
							</td>						
						</tr>
						<tr>
							<th style="text-align:left">人数:</th>
						</tr>
						<tr>
							<td>
								<input id="peson_num" type="text" style="width:60px" name="peson_num" value="${personNum}"/>
							</td>
						</tr>
						<tr>
							<td style="text-align:center" colspan="5">
								<input type="submit" class="button"	value="随机" />
								<input class="button" value="确定" style="margin-top:10px" type="button" onclick="tijiao()" />
							</td>
						</tr>
					</table>
				</form>
							
					
			</div>
		</div>
		
			<div class="table">
			    <div class="menu">
					<ul>
						<li>选中组长</li>
					</ul>
				</div>
				<div class="main">
					<table>
						<thead>
							<tr>
								<td style="width:100px">姓名</td>
								<td style="width:100px">专业</td>
								<td style="width:100px">特长</td>
								<td style="width:100px">所在范围</td>
							</tr>
						</thead>
						<c:if test="${not empty checkedLaderList}">
						<c:forEach items="${checkedLaderList}" var="row" varStatus="bb">
							<input type="checkbox" value="${row.psn_name}" name='laderpeson'
										style="display: none" checked="checked" disabled="disabled"/>
							<tr>
								<td id="name_${row.id}">${row.psn_name}</td>
								<td>${row.psn_prof}</td>
								<td>${row.psn_goodat}</td>
								<td>								
									${row.bel_scope}
								</td>
							</tr>
						</c:forEach>
						</c:if>
					</table>
				</div>
				<div class="menu">
					<ul>
						<li>选中组员</li>
					</ul>
				</div>
				<div class="main">
					<table>
						<thead>
							<tr>
								<td style="width:100px">姓名</td>
								<td style="width:100px">专业</td>
								<td style="width:100px">特长</td>
								<td style="width:100px">所在范围</td>
							</tr>
						</thead>
						<c:if test="${not empty checkedMemberList}">
						<c:forEach items="${checkedMemberList}" var="row" varStatus="bb">
							<tr>
								<td id="name_${row.id}">${row.psn_name}</td>
								<td>${row.psn_prof}</td>
								<td>${row.psn_goodat}</td>
								<td>								
									${row.bel_scope}
								</td>
							</tr>
						</c:forEach>
						</c:if>
					</table>
				</div>
				<%-- <div class="menu">
					<ul>
						<li>组长</li>
					</ul>
				</div>
				<div class="main">
					<table>
						<thead>
							<tr>
								<td style="width:30px">操作</td>
								<td style="width:100px">姓名</td>
								<td style="width:100px">专业</td>
								<td style="width:100px">特长</td>
								<td style="width:100px">是否在岗</td>
								<td style="width:100px">所在范围</td>

							</tr>
						</thead>
						<!-- 组长 -->
						<c:if test="${not empty lader}">
						<c:forEach items="${lader}" var="row" varStatus="aa">
							<tr>
								<td>
									<c:if test="${row.checked == 1}" >
										<input type="checkbox" value="${row.psn_name}" name='laderpeson'
											onclick="checkbox()" checked="checked" disabled="disabled"/>
									</c:if>
									<c:if test="${row.checked != 1}" >
										<input type="checkbox" value="${row.psn_name}" name='laderpeson'
											onclick="checkbox()" disabled="disabled"/>
									</c:if>
								</td>
								<td id="name_${row.id}">组长:${row.psn_name}</td>
								<td>${row.psn_prof}</td>
								<td>${row.psn_goodat}</td>
								<td>
								 <c:if test="${row.in_post==1}">是</c:if>
								 <c:if test="${row.in_post!=1}">否</c:if>
								</td>
								<td>								
									${row.bel_scope}
								</td>
							</tr>
						</c:forEach>
						</c:if>
					</table>
				</div> --%>
				<div class="menu">
					<ul>
						<li>人员</li>
					</ul>
				</div>
				<div class="main">
					<table>
						<thead>
							<tr>
								<td style="width:30px">操作</td>
								<td style="width:100px">姓名</td>
								<td style="width:100px">专业</td>
								<td style="width:100px">特长</td>
								<td style="width:100px">所在范围</td>

							</tr>
						</thead>
						<c:if test="${not empty checkedMemberList2}">
						<c:forEach items="${checkedMemberList2}" var="row" varStatus="bb">
							<tr>
								<td>
								<c:if test="${row.checked == 1}" >
									<input id="zy_${row.id}" type="checkbox" value="${row.psn_name}" name="peson"
										onclick="checkMerId()" checked="checked" disabled="disabled"/>
								</c:if>
								<c:if test="${row.checked != 1}" >
									<input id="zy_${row.id}" type="checkbox" value="${row.psn_name}" name="peson"
										onclick="checkMerId()" disabled="disabled"/>
								</c:if>
								</td>
								<td id="name_${row.id}">${row.psn_name}</td>
								<td>${row.psn_prof}</td>
								<td>${row.psn_goodat}</td>
								<td>								
									${row.bel_scope}
								</td>
							</tr>
						</c:forEach>
						</c:if>
						<%-- <tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot> --%>
					</table>
				</div>
			</div>
			<form action="" id="tijiao" method="post">
				<!-- <input class="button" value="确认" style="margin-top:10px" type="button" onclick="tijiao()" /> -->
			</form>
	</div>
	<script type="text/javascript">
	var flag = "2";
// 	var applyNo = "${sessionScope.no}";
	var applyNo = "${apply_no}";
		function checkbox() {
			var ldId = "";
			$("input[name='lader']:checked").each(function() {
				ldId = ldId + this.value + ",";
			});
			flag = 1;
			return ldId;
		};

		function checkMerId() {
			var meId = "";
			$("input[name='member']:checked").each(function() {
				meId = meId + this.value + ",";
			});
			flag = 1;
			return meId;
		};

		$("#confirm").click(function() {
			var peson = $("#peson").val();
			var learId = checkbox();
// 			learId=learId.substring(0,learId.length-1);
			var merId = checkMerId();
// 			merId=merId.substring(0,merId.length-1);
			var lid = learId.split(",");
			var mid = merId.split(",");
			var count = "";
			var ldcount ="";
			var mercount ="";
			

			if(lid.length ==1 && mid.length !=1){
				alert("未选中组长");
				return;
			}else if(lid.length !=1 && mid.length ==1){
				alert("未选中组员");
				return;
			}else if(lid.length ==1 && mid.length ==1){
				var ldId = "";
				$("input[name='lader']").each(function() {
					ldId = ldId + this.value + ",";
				});
				var meId = "";
				$("input[name='member']").each(function() {
					meId = meId + this.value + ",";
				});
				if(confirm("默认提交")){
					ajaxSubmit(ldId,meId,peson,flag);
				}
				return;
			}
			
			for (var i = 0; i < lid.length - 1; i++) {
				ldcount =i;
				for (var j = 0; j < mid.length - 1; j++) {
					if (lid[i] == mid[j]) {
// 						alert("组员跟组长不能同时选择一个人" + "i=" + i + ";j=" + j);
						alert("组员跟组长不能同时选择一个人");
						return;
					}
					mercount =j;
					count = i + j;
				}
			}
			//此处是为了下标从0开始 手动统计2次的循环
			count += 2;
			if (peson != count) {
				alert("选择的人数不符合");
			} else if(ldcount>mercount){
				alert("选择组长人数不能大于队员人数");
			} else {
				ajaxSubmit(learId,merId,peson,flag);				
			}
		});
		
		function ajaxSubmit(learId,merId,peson,type){
			if(!applyNo){
				//window.location.href="/ciqs/expFoodPOF/expFoodList";
			}
			if(learId !="" && merId !="" && peson !=""){
				var params = {
						learId : learId,
						merId : merId,
						num : peson,
						applyNo : applyNo,
						submitType : type,
					};
					$.ajax({
						url : "/ciqs/xk/insert",
						type : "POST",
						data : params,
						dataType : "json",
						success : function(data) {
							if (data.status == "OK") {
								alert("保存成功");
								window.location.href="/ciqs/xk/peson?apply_no="+applyNo;
							} else {
								alert("保存失败");
							}
						}
					});
			}
			
		}
		
		function sd(){
		alert(11);
			flag = 1;
		}
	</script>
</body>
</html>
