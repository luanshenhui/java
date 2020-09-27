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
<!-- 			&gt; <a href="${cxt}/ciqs/expFoodProd/peson?apply_no=${apply_no}">随机人员</a> -->
		</div>
		<jsp:include page="/common/message.jsp" flush="true" />
<!-- 		<div class="title">查询条件</div> -->
		<div class="search">
			<div class="main">
				<form action="/ciqs/expFoodPOF/addpeson?apply_no=${apply_no}&type=1" id="submitPerson" method="post">
<!-- 				<input type="hidden" name="apply_no" value="${apply_no}"/> -->
					<table class="table_search" id="aa">
						<tr>
							<td></td>
							<td>申请单号:</td>
							<td >人数:</td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						
						<tr>
							<td align="left"></td>
							<td align="left"><input type="text" id="applyNumber" value="${apply_no}"
								size="8" readonly="readonly"/></td>
							<td align="left">
							<select id="peson" name="personNum" onchange="selchange(this)">
									<option value="2" <c:if test="${personNum == 2}">  selected="selected" </c:if>>2</option>
									<option value="3" <c:if test="${personNum == 3}">  selected="selected" </c:if>>3</option>
									<option value="4" <c:if test="${personNum == 4}">  selected="selected" </c:if>>4</option>
							</select></td>
							<td ></td>
							<td></td>
							<td></td>
						</tr>
					
					
						<tr>
							<td align="left"></td>
<!-- 							<td>分类:</td> -->
							<td>专长:</td>
							<td>其他专长:</td>
							<td>级别:</td>
							<td>是否在岗:</td>
						</tr>
						<tr>
							<td style="color:#1b5ea8">组长:</td>
<!-- 							<td align="left"><select name="psnType"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnTypeCode}"> -->
<!-- 										<c:forEach items="${psnTypeCode}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${psnType == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 							</select></td> -->
							<td align="left">
								<input type="text" name="psnExpertise" id="psnExpertise" size="8" 
								value="<c:if test='${ not empty psnExpertise}'>${psnExpertise}</c:if>" onclick="expertise(this,1)" />
							</td>
							<td align="left">
								<input type="text" name="psnExpertise_order" id="psnExpertise_order" size="8" 
								value="<c:if test='${ not empty psnExpertise_order}'>${psnExpertise_order}</c:if>" onclick="expertise2(this,1)" />
							</td>
							<td align="left"><select name="psnLevel">
									<option></option>
									<c:if test="${not empty psnLevelCode}">
										<c:forEach items="${psnLevelCode}" var="row">
											<option value="${row.code}" <c:if test="${psnLevel == row.code}"> selected="selected" </c:if>>${row.name}</option>
										</c:forEach>
									</c:if>
							</select></td>
							<td align="left"><select name="in_post">
									<option value="1"  <c:if test="${in_post == 1}">  selected="selected" </c:if>>是</option>
									<option value="0"  <c:if test="${in_post == 0}">  selected="selected" </c:if>>否</option>
							</select></td>
							<td ></td>
						</tr>
						<tr>
							<td></td>
							<td>一级部门:</td>
							<td>二级部门:</td>
							<td>三级部门:</td>
						</tr>
						<tr>
							<td></td>
							<td align="left">
<!-- 								<select name="levelDept_1"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_1Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_1Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${levelDept_1 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->
								
								<input type="text" name="levelDept_1" id="levelDept_1" size="8" 
								value="<c:if test='${ not empty psnLevelDept_1Code}'>${levelDept_1}</c:if>" onclick="deptTop(this,1)" />
							</td>
							<td align="left">
<!-- 								<select name="levelDept_2"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_2Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_2Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${levelDept_2 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->
								<input type="text" name="levelDept_2" id="levelDept_2" size="8" 
								value="<c:if test='${ not empty psnLevelDept_2Code}'>${levelDept_2}</c:if>" onclick="deptTop_2(this,1)" />
							</td>
							<td align="left">
<!-- 								<select name="levelDept_3"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_3Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_3Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${levelDept_3 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->

									<input type="text" name="levelDept_3" id="levelDept_3" size="8" 
								value="<c:if test='${ not empty psnLevelDept_3Code}'>${levelDept_3}</c:if>" onclick="deptTop_3(this,1)" />
							</td>
						</tr>
						<tr>
							<td align="left"></td>
<!-- 							<td>分类:</td> -->
							<td>专长:</td>
							<td>其他专长:</td>
							<td>级别:</td>
							<td>是否在岗:</td>
						</tr>
						
						<tr>
							<td style="color:#1b5ea8">组员:</td>
<!-- 							<td align="left"><select name="z_psnType"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnTypeCode}"> -->
<!-- 										<c:forEach items="${psnTypeCode}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_psnType == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 							</select></td> -->
							<td align="left"><input type="text" name="z_psnExpertise" id="z_psnExpertise" size="8" 
							value="<c:if test='${ not empty z_psnExpertise}'>${z_psnExpertise}</c:if>" onclick="expertise(this,2);" /></td>
							<td align="left"><input type="text" name="z_psnExpertise_order" id="z_psnExpertise_order" size="8" 
							value="<c:if test='${ not empty z_psnExpertise_order}'>${z_psnExpertise_order}</c:if>" onclick="expertise2(this,2);" /></td>
							<td align="left"><select name="z_psnLevel">
									<option></option>
									<c:if test="${not empty psnLevelCode}">
										<c:forEach items="${psnLevelCode}" var="row">
											<option value="${row.code}" <c:if test="${z_psnLevel == row.code}"> selected="selected" </c:if>>${row.name}</option>
										</c:forEach>
									</c:if>
							</select></td>
							<td align="left"><select name="z_in_post">
									<option value="1"  <c:if test="${z_in_post == 1}">  selected="selected" </c:if>>是</option>
									<option value="0"  <c:if test="${z_in_post == 0}">  selected="selected" </c:if>>否</option>
							</select></td>
							<td ></td>
						</tr>
						<tr>
							<td></td>
							<td>一级部门:</td>
							<td>二级部门:</td>
							<td>三级部门:</td>
						</tr>
						<tr>
							<td></td>
							<td align="left">
<!-- 								<select name="z_levelDept_1"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_1Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_1Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_1 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->
								
								<input type="text" name="z_levelDept_1" id="z_levelDept_1" size="8" 
								value="<c:if test='${ not empty psnLevelDept_1Code}'>${z_levelDept_1}</c:if>" onclick="deptTop(this,2)" />
							</td>
							<td align="left">
<!-- 								<select name="z_levelDept_2"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_2Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_2Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_2 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->
								
								<input type="text" name="z_levelDept_2" id="z_levelDept_2" size="8" 
								value="<c:if test='${ not empty psnLevelDept_2Code}'>${z_levelDept_2}</c:if>" onclick="deptTop_2(this,2)" />
							</td>
							<td align="left">
<!-- 								<select name="z_levelDept_3"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_3Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_3Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_3 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->

								<input type="text" name="z_levelDept_3" id="z_levelDept_3" size="8" 
								value="<c:if test='${ not empty psnLevelDept_3Code}'>${z_levelDept_3}</c:if>" onclick="deptTop_3(this,2)" />
							</td>
						</tr>
<!-- 						<tr> -->
<!-- 							<td></td> -->
<!-- 							<td>申请单号:</td> -->
<!-- 							<td >人数:</td> -->
<!-- 							<td></td> -->
<!-- 							<td></td> -->
<!-- 							<td></td> -->
<!-- 						</tr> -->
						
<!-- 						<tr> -->
<!-- 							<td align="left"></td> -->
<!-- 							<td align="left"><input type="text" id="applyNumber" value="${apply_no}" -->
<!-- 								size="8" readonly="readonly"/></td> -->
<!-- 							<td align="left"><select id="peson" name="personNum"> -->
<!-- 									<option value="2" <c:if test="${personNum == 2}">  selected="selected" </c:if>>2</option> -->
<!-- 									<option value="3" <c:if test="${personNum == 3}">  selected="selected" </c:if>>3</option> -->
<!-- 									<option value="4" <c:if test="${personNum == 4}">  selected="selected" </c:if>>4</option> -->
<!-- 							</select></td> -->
<!-- 							<td ></td> -->
<!-- 							<td></td> -->
<!-- 							<td></td> -->
<!-- 						</tr> -->
						<tr class="tr_3">
							<td align="left"></td>
<!-- 							<td>分类:</td> -->
							<td>专长:</td>
							<td>其他专长:</td>
							<td>级别:</td>
							<td>是否在岗:</td>
						</tr>
						
						<tr class="tr_3">
							<td style="color:#1b5ea8">组员:</td>
<!-- 							<td align="left"><select name="z_psnType_3"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnTypeCode}"> -->
<!-- 										<c:forEach items="${psnTypeCode}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_psnType_3 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 							</select></td> -->
							<td align="left"><input type="text" name="z_psnExpertise_3" id="z_psnExpertise_3" size="8" 
							value="<c:if test='${ not empty z_psnExpertise_3}'>${z_psnExpertise_3}</c:if>" onclick="expertise(this,2);" /></td>
							<td align="left"><input type="text" name="z_psnExpertise_order_3" id="z_psnExpertise_order_3" size="8" 
							value="<c:if test='${ not empty z_psnExpertise_order_3}'>${z_psnExpertise_order_3}</c:if>" onclick="expertise2(this,2);" /></td>
							<td align="left"><select name="z_psnLevel_3">
									<option></option>
									<c:if test="${not empty psnLevelCode}">
										<c:forEach items="${psnLevelCode}" var="row">
											<option value="${row.code}" <c:if test="${z_psnLevel_3 == row.code}"> selected="selected" </c:if>>${row.name}</option>
										</c:forEach>
									</c:if>
							</select></td>
							<td align="left"><select name="z_in_post_3">
									<option value="1"  <c:if test="${z_in_post_3 == 1}">  selected="selected" </c:if>>是</option>
									<option value="0"  <c:if test="${z_in_post_3 == 0}">  selected="selected" </c:if>>否</option>
							</select></td>
							<td ></td>
						</tr>
						<tr class="tr_3">
							<td></td>
							<td>一级部门:</td>
							<td>二级部门:</td>
							<td>三级部门:</td>
						</tr>
						<tr class="tr_3">
							<td></td>
							<td align="left">
<!-- 								<select name="z_levelDept_1_3"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_1Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_1Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_1_3 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->

								<input type="text" name="z_levelDept_1_3" id="z_levelDept_1_3" size="8" 
								value="<c:if test='${ not empty psnLevelDept_1Code}'>${z_levelDept_1_3}</c:if>" onclick="deptTop(this,2)" />
							</td>
							<td align="left">
<!-- 								<select name="z_levelDept_2_3"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_2Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_2Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_2_3 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->

								<input type="text" name="z_levelDept_2_3" id="z_levelDept_2_3" size="8" 
								value="<c:if test='${ not empty psnLevelDept_2Code}'>${z_levelDept_2_3}</c:if>" onclick="deptTop_2(this,2)" />
							</td>
							<td align="left">
<!-- 								<select name="z_levelDept_3_3"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_3Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_3Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_3_3 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->

								<input type="text" name="z_levelDept_3_3" id="z_levelDept_3_3" size="8" 
								value="<c:if test='${ not empty psnLevelDept_2Code}'>${z_levelDept_3_3}</c:if>" onclick="deptTop_3(this,2)" />
							</td>
						</tr>
						
						<tr class="tr_4">
							<td align="left"></td>
<!-- 							<td>分类:</td> -->
							<td>专长:</td>
							<td>其他专长:</td>
							<td>级别:</td>
							<td>是否在岗:</td>
						</tr>
						
						<tr class="tr_4">
							<td style="color:#1b5ea8">组员:</td>
<!-- 							<td align="left"><select name="z_psnType_4"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnTypeCode}"> -->
<!-- 										<c:forEach items="${psnTypeCode}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_psnType_4 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 							</select></td> -->
							<td align="left"><input type="text" name="z_psnExpertise_4" id="z_psnExpertise_4" size="8" 
							value="<c:if test='${ not empty z_psnExpertise_4}'>${z_psnExpertise_4}</c:if>" onclick="expertise(this,2);" /></td>
							<td align="left"><input type="text" name="z_psnExpertise_order_4" id="z_psnExpertise_order_4" size="8" 
							value="<c:if test='${ not empty z_psnExpertise_order_4}'>${z_psnExpertise_order_4}</c:if>" onclick="expertise2(this,2);" /></td>
							<td align="left"><select name="z_psnLevel_4">
									<option></option>
									<c:if test="${not empty psnLevelCode}">
										<c:forEach items="${psnLevelCode}" var="row">
											<option value="${row.code}" <c:if test="${z_psnLevel_4 == row.code}"> selected="selected" </c:if>>${row.name}</option>
										</c:forEach>
									</c:if>
							</select></td>
							<td align="left"><select name="z_in_post_4">
									<option value="1"  <c:if test="${z_in_post_4 == 1}">  selected="selected" </c:if>>是</option>
									<option value="0"  <c:if test="${z_in_post_4 == 0}">  selected="selected" </c:if>>否</option>
							</select></td>
							<td ></td>
						</tr>
						<tr class="tr_4">
							<td></td>
							<td>一级部门:</td>
							<td>二级部门:</td>
							<td>三级部门:</td>
						</tr>
						<tr class="tr_4">
							<td></td>
							<td align="left">
<!-- 								<select name="z_levelDept_1_4"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_1Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_1Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_1_4 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->
								<input type="text" name="z_levelDept_1_4" id="z_levelDept_1_4" size="8" 
								value="<c:if test='${ not empty psnLevelDept_1Code}'>${z_levelDept_1_4}</c:if>" onclick="deptTop(this,2)" />
							</td>
							<td align="left">
<!-- 								<select name="z_levelDept_2_4"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_2Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_2Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_2_4 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->

								<input type="text" name="z_levelDept_2_4" id="z_levelDept_2_4" size="8" 
								value="<c:if test='${ not empty psnLevelDept_2Code}'>${z_levelDept_2_4}</c:if>" onclick="deptTop_2(this,2)" />
							</td>
							<td align="left">
<!-- 								<select name="z_levelDept_3_4"> -->
<!-- 									<option></option> -->
<!-- 									<c:if test="${not empty psnLevelDept_3Code}"> -->
<!-- 										<c:forEach items="${psnLevelDept_3Code}" var="row"> -->
<!-- 											<option value="${row.code}" <c:if test="${z_levelDept_3_4 == row.code}"> selected="selected" </c:if>>${row.name}</option> -->
<!-- 										</c:forEach> -->
<!-- 									</c:if> -->
<!-- 								</select> -->

								<input type="text" name="z_levelDept_3_4" id="z_levelDept_3_4" size="8" 
								value="<c:if test='${ not empty psnLevelDept_3Code}'>${z_levelDept_3_4}</c:if>" onclick="deptTop_3(this,2)" />
							</td>
						</tr>
						
						
						<tr>
							<td colspan="6" style="text-align: center;">
								<input type="submit" class="abutton" style="margin: 0px;"
								value="随机"  />
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="reset" class="abutton" style="margin: 0px;"
								value="清空"  />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<c:if test="${member !=null && lader !=null }">
		<form action="" id="tijiao" method="post">
			<div class="table" >
				<div class="menu">
					<ul>
						<li>随机组长</li>
					</ul>
				</div>
				<div class="main">
					<table width="100%">
						<thead>
							<tr>
								<td width="10%">操作</td>
								<td width="15%">姓名</td>
<!-- 								<td width="15%">分类</td> -->
								<td width="15%">专长</td>
								<td width="15%">级别</td>
								<td width="10%">是否在岗</td>
								<td width="20%">所在范围</td>
							</tr>
						</thead>
						<c:if test="${not empty laderList}" >
						<c:forEach items="${laderList}" var="row">
							<tr>
								<td><input type="radio" value="${row.psnId}" name="lader"
									onclick="checkNum()" checked="checked" /></td>
								<td>${row.psnName}</td>
<!-- 								<td>${row.psnType}</td> -->
								<td title="${row.expName}">${row.psnExpertise}</td>
								<td>${row.psnLevel}</td>
								<td>
								 <c:if test="${row.in_post==1}">是</c:if>
								 <c:if test="${row.in_post!=1}">否</c:if>
								</td>
								<td><c:if test="${not empty row.levelDept_1}">${row.levelDept_1}</c:if>
									<c:if test="${not empty row.levelDept_2}">-${row.levelDept_2}</c:if>
									<c:if test="${not empty row.levelDept_3}">-${row.levelDept_3}</c:if>
								</td>
							</tr>
						</c:forEach>
						</c:if>
					</table>
				</div>
				<div class="menu">
					<ul>
						<li>随机组员</li>
					</ul>
				</div>
				<div class="main">
					<table>
						<thead>
							<tr>
								<td width="10%">操作</td>
								<td width="15%">姓名</td>
<!-- 								<td width="15%">分类</td> -->
								<td width="15%">专长</td>
								<td width="15%">级别</td>
								<td width="10%">是否在岗</td>
								<td width="20%">所在范围</td>
							</tr>
						</thead>
						<c:if test="${not empty memberList}" >
						<c:forEach items="${memberList}" var="row">
							<tr>
								<td><input type="checkbox" value="${row.psnId}" name="member"
									onclick="checkNum()" checked="checked" /></td>
								<td>${row.psnName}</td>
<!-- 								<td>${row.psnType}</td> -->
								<td title="${row.expName}">${row.psnExpertise}</td>
								<td>${row.psnLevel}</td>
								<td>
									<c:if test="${row.in_post==1}">是</c:if>
								 	<c:if test="${row.in_post!=1}">否</c:if>
								</td>
								<td><c:if test="${not empty row.levelDept_1}">${row.levelDept_1}</c:if>
									<c:if test="${not empty row.levelDept_2}">-${row.levelDept_2}</c:if>
									<c:if test="${not empty row.levelDept_3}">-${row.levelDept_3}</c:if>
								</td>
							</tr>
						</c:forEach>
						</c:if>
					</table>
				</div>
				<div style="text-align: center;margin: auto;margin-top: 10px;padding-bottom: 10px;">
					<input class="mbutton" value="确认" type="button" id="confirm" /> 
					<input type="button" class="abutton" value="返回"  onclick="JavaScript:history.go(-1);"/>
				</div>
				
				<!-- 查询列表 -->
				<div class="menu">
					<ul>
						<li>组长</li>
					</ul>
				</div>
				<div class="main">
					<table>
						<thead>
							<tr>
								<td width="10%">操作</td>
								<td width="15%">姓名</td>
<!-- 								<td width="15%">分类</td> -->
								<td width="15%">专长</td>
								<td width="15%">级别</td>
								<td width="10%">是否在岗</td>
								<td width="20%">所在范围</td>

							</tr>
						</thead>
						<!-- 组长 -->
						<c:forEach items="${lader}" var="row">
							<tr>
								<td><input type="radio" value="${row.psnId}" name='lader'
									onclick="checkNum()" /></td>
								<td>${row.psnName}</td>
<!-- 								<td>${row.psnType}</td> -->
								<td title="${row.expName}">${row.psnExpertise}</td>
								<td>${row.psnLevel}</td>
								<td>
									<c:if test="${row.in_post=='1'}">是</c:if>
									<c:if test="${row.in_post!='1'}">否</c:if>
								</td>
								<td><c:if test="${not empty row.levelDept_1}">${row.levelDept_1}</c:if>
									<c:if test="${not empty row.levelDept_2}">-${row.levelDept_2}</c:if>
									<c:if test="${not empty row.levelDept_3}">-${row.levelDept_3}</c:if>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div class="menu">
					<ul>
						<li>组员</li>
					</ul>
				</div>
				<div class="main">
					<table>
						<thead>
							<tr>
								<td width="10%">操作</td>
								<td width="15%">姓名</td>
<!-- 								<td width="15%">分类</td> -->
								<td width="15%">专长</td>
								<td width="15%">级别</td>
								<td width="10%">是否在岗</td>
								<td width="20%">所在范围</td>
							</tr>
						</thead>
						<!-- 组员 -->
						<c:forEach items="${member}" var="row">
							<tr>
								<td><input type="checkbox" value="${row.psnId}" name="member"
									onclick="checkNum()" /></td>
								<td>${row.psnName}</td>
<!-- 								<td>${row.psnType}</td> -->
								<td title="${row.expName}">${row.psnExpertise}</td>
								<td>${row.psnLevel}</td>
								<td>
								 	<c:if test='${row.in_post=="1"}'>是</c:if>
								 	<c:if test='${row.in_post!="1"}'>否</c:if>
								</td>
								<td><c:if test="${not empty row.levelDept_1}">${row.levelDept_1}</c:if>
									<c:if test="${not empty row.levelDept_2}">-${row.levelDept_2}</c:if>
									<c:if test="${not empty row.levelDept_3}">-${row.levelDept_3}</c:if>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</div>
<!-- 			<input class="mbutton" value="确认" type="button" id="confirm" /> -->
			</form>
		</c:if>
	</div>
<div id="expertise" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">核心团队</div>
				<table style="height: auto;"  id="hxtd">
				<c:if test="${not empty expertiseCode1 }">
				<c:forEach items="${expertiseCode1}" var="row">
					<c:if test="${classic_type==核心团队}" >
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
					</c:if>
				</c:forEach>
				</c:if>
				</table>
				<div style="background-color: #999999;">专业团队</div>
				<table style="height: auto;" id="zytd">
				<c:if test="${not empty expertiseCode2 }">
				<c:forEach items="${expertiseCode2}" var="row">
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				<div style="background-color: #999999;">准专业团队</div>
				<table style="height: auto;" id="zzytd">
				<c:if test="${not empty expertiseCode3 }">
				<c:forEach items="${expertiseCode3}" var="row">
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				<div style="background-color: #999999;">执法监管团队</div>
				<table style="height: auto;" id="zfjdtd">
				<c:if test="${not empty expertiseCode4 }">
				<c:forEach items="${expertiseCode4}" var="row">
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
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
			<td id="btnTd">
				<input type="button" id="btn" value="确定" onclick="getExpertise()" />
			</td>
		</tr>
	</table>
</div>	

<div id="expertise_order" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">其他专长</div>
				<table style="height: auto;">
				<c:if test="${not empty expertiseCode5 }">
				<c:forEach items="${expertiseCode5}" var="row">
					<tr>
						<td id="exp_order" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
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
			<td id="btnTd_order">
				<input type="button" id="btn_order" value="确定" onclick="getExpertise()" />
			</td>
		</tr>
	</table>
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
							<span id="${row.code}">
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

<div id="deptTop_2" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">二级部门</div>
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_2Code }">
				<c:forEach items="${psnLevelDept_2Code}" var="row">
					<tr orgId="${row.port_org_code}">
						<c:if test="${not empty row.flag_op }">
							<td  align="left" >
								<c:if test='${row.code!=null}'>
									<input type="checkbox" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
								</c:if>
								<span id="${row.code}">
									<c:if test='${not empty row.name}'>{ ${row.name} }</c:if>
								</span>
							</td>
						</c:if>
						<c:if test="${empty row.flag_op }">
							<td  align="left" >
								<span id="${row.code}">
									<c:if test='${not empty row.name}'>${row.name}</c:if>
								</span>
							</td>
						</c:if>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom_2">
				<input type="button" id="combtn_2" value="确定" onclick="getExperCom(this)" />
			</td>
		</tr>
	</table>
</div>	

<div id="deptTop_3" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">三级部门</div>
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_3Code }">
				<c:forEach items="${psnLevelDept_3Code}" var="row">
					<tr orgId="${row.port_org_code}">
						<c:if test="${not empty row.flag_op }">
						<td  align="left" >
							<c:if test='${row.code!=null}'>
								<input type="checkbox" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.name}'>{ ${row.name} }</c:if>
							</span>
						</td>
						</c:if>
						<c:if test="${empty row.flag_op }">
						<td  align="left" >
							<span>
								<c:if test='${not empty row.name}'>${row.name}</c:if>
							</span>
						</td>
						</c:if>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom_3">
				<input type="button" id="combtn_3" value="确定" onclick="getExperCom(this)" />
			</td>
		</tr>
	</table>
</div>	
	<script type="text/javascript">
	var applyNo = $("#applyNumber").val();
		function checkLader() {
			var ldId = "";
			ldId = $("input[name='lader']:checked").val();
			return ldId;
		};
		function checkMerId() {
			var meId = "";
			$("input[name='member']:checked").each(function() {
				meId = meId + this.value + ",";
			});
			
			return meId;
		};
		var a = 0;
		function checkNum(){
			a++;
		}
		var type;	
		$("#confirm").click(function() {
			if(a>0){
				type = 2;
			}else{
				type = 1;
			}
			var peson = $("#peson").val();
			var learId = checkLader();
			var merId = checkMerId();
			var mid = merId.split(",");
			var nary=mid.sort();
			for(var i = 1;i<=mid.length;i++){
				if(mid[i] == learId){
					alert("组长和组员不能是同一个人");
					return;
				}
				if (nary[i]==nary[i+1]&&nary[i]!=undefined){
					alert("不能选择相同的组员");
					return;
				}
			}
			if(mid.length-1 > peson-1){
				alert("请选择正确的人数");
				return;
			}else{
				ajaxSubmit(learId,merId,peson,type);
			}
			
		});
		$("#confirm2").click(function() {
			if(a>0){
				type = 2;
			}else{
				type = 1;
			}
			var peson = $("#peson").val();
			var learId = checkLader();
			var merId = checkMerId();
			var mid = merId.split(",");
			var nary=mid.sort();
			for(var i = 1;i<=mid.length;i++){
				if(mid[i] == learId){
					alert("组长和组员不能是同一个人");
					return;
				}
				if (nary[i]==nary[i+1]&&nary[i]!=undefined){
					alert("不能选择相同的组员");
					return;
				}
			}
			if(mid.length-1 > peson-1){
				alert("请选择正确的人数");
				return;
			}else{
				ajaxSubmit(learId,merId,peson,type);
			}
			
		});
		//提交
		function ajaxSubmit(learId,merId,peson,type){
		$("#confirm").attr('disabled',true);
			//alert(learId);
			if(!applyNo){
// 				return window.location.href="/ciqs/expFoodPOF/expFoodList";
				return alert("缺少申请单号无法新建");
			}
			if(learId !="" && merId !="" && peson !=""){
				var params = {
						learId : learId,
						merId : merId,
						num : peson,
						applyNo : applyNo,
						//applySystem : applySystem,
						submitType : type,
					};
					$.ajax({
						url : "/ciqs/expFoodPOF/insert",
						type : "POST",
						data : params,
						dataType : "json",
						success : function(data) {
							if (data.status == "OK") {
								alert("保存成功");
								window.location.href="/ciqs/expFoodPOF/expFoodList";
							} else {
								$("#confirm").removeAttr('disabled');
								return alert("保存失败");
							}
						}
					});
			}
			
		}
		
		//弹窗
		function expertise(e,param){
// 		if(!$(e).parent().prev().find("select").val()){
// 			return alert("请优先选择分类");
// 		}
		$('input[name="expertise_code"]:checked').attr("checked",false);
		var bj=e.getAttribute("id");
			$("#hxtd").prev().show();
			$("#zytd").prev().show();
			$("#zzytd").prev().show();
			$("#zfjdtd").prev().show();
			$("#hxtd").show();
			$("#zytd").show();
			$("#zzytd").show();
			$("#zfjdtd").show();
		
			var parent=$(e).parent().prev().children().val();
			if(parent=="hxtd"){//核心团队
			$("#zytd").prev().hide();
			$("#zzytd").prev().hide();
			$("#zfjdtd").prev().hide();
			$("#zytd").hide();
			$("#zzytd").hide();
			$("#zfjdtd").hide();
			}
			if(parent=="zytd"){//专业团队
			$("#hxtd").prev().hide();
			$("#zzytd").prev().hide();
			$("#zfjdtd").prev().hide();
			$("#hxtd").hide();
			$("#zzytd").hide();
			$("#zfjdtd").hide();
			}
			if(parent=="zzytd"){//准专业团队
			$("#hxtd").prev().hide();
			$("#zytd").prev().hide();
			$("#zfjdtd").prev().hide();
			$("#hxtd").hide();
			$("#zytd").hide();
			$("#zfjdtd").hide();
			}
			if(parent=="zfjgtd"){//执法监管团队
			$("#hxtd").prev().hide();
			$("#zytd").prev().hide();
			$("#zzytd").prev().hide();
			$("#hxtd").hide();
			$("#zytd").hide();
			$("#zzytd").hide();
			}
			if(parent=="qtzc"){//其他专长
			
			}
			//1为组长，2为组员
			if(param==1){
				$("#btn").remove();
				//$("#psnExpertise").val();
				var input = "<input type='button' id='btn' value='确定' onclick='getExpertise1()' />";
				$("#btnTd").append(input);
			}
			if(param==2){
				$("#btn").remove();
				//$("#z_psnExpertise").val("");
				var input = "<input type='button' id='btn' value='确定' onclick='getExpertise2(\""+bj+"\")' />";
				$("#btnTd").append(input);
			}
			$.blockUI({ message: $('#expertise'),
			                css:{top:100,left:500}
			});
		}
		
		function closeUI(){
			$.unblockUI();
		}
	  	//组长专长
	  	function getExpertise1(){
	  		var chk_value =[]; 
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value.push($(this).val()); 
	  		}); 
	  		$("#psnExpertise").val(chk_value);
	  		$.unblockUI();
	  	}
	  	//组员专长
	  	function getExpertise2(e){
	  		var chk_value1 =[];
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value1.push($(this).val()); 
	  		}); 
// 	  		$("#z_psnExpertise").val(chk_value1);
	  		$("#"+e).val(chk_value1);
	  		$.unblockUI();
	  	}
	  	
	  	function expertise2(e,param){
		$('input[name="expertise_code"]:checked').attr("checked",false);
		var bj=e.getAttribute("id");
			//1为组长，2为组员
			if(param==1){
				$("#btn").remove();
				$("#btn_order").remove();
				//$("#psnExpertise").val();
				var input = "<input type='button' id='btn_order' value='确定' onclick='getExpertise1_order()' />";
				$("#btnTd_order").append(input);
			}
			if(param==2){
				$("#btn").remove();
				$("#btn_order").remove();
				//$("#z_psnExpertise").val("");
				var input = "<input type='button' id='btn' value='确定' onclick='getExpertise2_order(\""+bj+"\")' />";
				$("#btnTd_order").append(input);
			}
			$.blockUI({ message: $('#expertise_order'),
			                css:{top:100,left:500}
			});
		}
		
		//组长专长
	  	function getExpertise1_order(){
	  		var chk_value =[]; 
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value.push($(this).val()); 
	  		}); 
	  		$("#psnExpertise_order").val(chk_value);
	  		$.unblockUI();
	  	}
	  	//组员专长
	  	function getExpertise2_order(e){
	  		var chk_value1 =[];
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value1.push($(this).val()); 
	  		}); 
	  		$("#"+e).val(chk_value1);
// 	  		$("#z_psnExpertise_order").val(chk_value1);
	  		$.unblockUI();
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
	  	
	  	 function deptTop_2(e,param){
	  		$('input[name="expertise_code"]:checked').attr("checked",false);
			var bj=e.getAttribute("id");
				$("#combtn_2").remove();
				var input = "<input type='button' id='combtn_2' value='确定' onclick='getExperCom(\""+bj+"\")' />";
				$("#btnTdcom_2").append(input);
				/*****************************************/
				if($(e).parent().prev().find('input').val()){
					var level=$(e).parent().prev().find('input').val().split(',');
					for(var i=0;i<level.length;i++){
						$('#deptTop_2').children().find('table').find('tr').each(function(k,v){
							if($.inArray($(this)[0].getAttribute("orgid"),level)>-1){
// 							console.log($("#"+$(this)[0].getAttribute("orgid")).html());
// 							  	$(this)[0].before($("#"+$(this)[0].getAttribute("orgid")).html());
								$(this).css("display","block");
							}else{
								$(this).css("display","none");
							}
						});
					}
				}else{
					$('#deptTop_2').children().find('table').find('tr').css("display","block");
				}
				/*****************************************/
				$.blockUI({ message: $('#deptTop_2'),
			          css:{top:100,left:500}
				});
	  	}
	  	
	  	 function deptTop_3(e,param){
	  		$('input[name="expertise_code"]:checked').attr("checked",false);
			var bj=e.getAttribute("id");
				$("#combtn_3").remove();
				var input = "<input type='button' id='combtn_3' value='确定' onclick='getExperCom(\""+bj+"\")' />";
				$("#btnTdcom_3").append(input);
				/*****************************************/
				if($(e).parent().prev().find('input').val()){
					var level=$(e).parent().prev().find('input').val().split(',');
					for(var i=0;i<level.length;i++){
						$('#deptTop_3').children().find('table').find('tr').each(function(k,v){
							if($.inArray($(this)[0].getAttribute("orgid"),level)>-1){
								$(this).css("display","block");
							}else{
								$(this).css("display","none");
							}
						});
					}
				}else{
					$('#deptTop_3').children().find('table').find('tr').css("display","block");
				}
				/*****************************************/
				$.blockUI({ message: $('#deptTop_3'),
			          css:{top:100,left:500}
				});
	  	}
	  	
	  	function getExperCom(e){
	  		var chk_value1 =[];
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value1.push($(this).val()); 
	  		}); 
	  		$("#"+e).val(chk_value1);
	  		$.unblockUI();
	  	}
	  	
	  	function selchange(e){
		  	if($(e).val()==3){
		  		$(".tr_3").show();
		  		$(".tr_4").hide();
		  	}else if($(e).val()==4){
		  		$(".tr_3").show();
		  		$(".tr_4").show();
		  	}else{
		  		$(".tr_3").hide();
		  		$(".tr_4").hide();
		  	}
	  	}
	</script>
</body>
</html>