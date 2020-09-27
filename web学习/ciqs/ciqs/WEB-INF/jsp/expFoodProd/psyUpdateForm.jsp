<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>评审员管理</title>
<style  type="text/css">
div.dpn-content div.form div.main table td {
    height: 30px;
    text-align: left;
    line-height: 22px;
    padding: 4px 5px 4px 5px;
}
</style>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript">
jQuery(document).ready(function(){
	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>出口食品生产企业备案核准</span><div>");
	$(".user-info").css("color","white");
});
function deptTop1(e,param){
	$.blockUI({ message: $('#deptTop_1'),
       css:{top:100,left:500}
	});
}
function deptTop2(e,param){
	var levelDept_1 = $("#levelDept_1").val();
	if(levelDept_1 == ""){
		alert("请选择一个一级部门!");
		return;
	}
	$("#tab2").html("");
	$.ajax({	
		url : "/ciqs/expFoodPOF/psnLevelDeptList?code=" + $("#levelDept_1").val()+"&type=QLC_PSN_LEVEL_DEPT_2",
		method : "post",
		success: function(result){
			
			if(result.psnLevelDeptList.length>0){
		        $.each(result.psnLevelDeptList,function(i,data){
		        	
		        	var str = "<tr>";
			    	str+="<td align='left' style='border:1px'>"	
			    		+"<input type='radio' style='width: 20px;'  name='expertise_code' value="+data.code+" />"
			    		+"<span id='psnLevelDept_2_"+data.code+"'>"+data.name+"</span>"
			    		+"</td>"
			    		+"</tr>";
					$("#tab2").append(str);
					
		        });
			}
		}
	});
	$.blockUI({ message: $('#deptTop_2'),
       css:{top:100,left:500}
	});
}
function deptTop3(e,param){
	var levelDept_2 = $("#levelDept_2").val();
	if(levelDept_2 == ""){
		alert("请选择一个二级部门!");
		return;
	}
	$("#tab3").html("");
	$.ajax({	
		url : "/ciqs/expFoodPOF/psnLevelDeptList?code=" + levelDept_2+"&type=QLC_PSN_LEVEL_DEPT_3",
		method : "post",
		success: function(result){
			
			if(result.psnLevelDeptList.length>0){
		        $.each(result.psnLevelDeptList,function(i,data){
		        	
		        	var str = "<tr>";
			    	str+="<td align='left' style='border:1px'>"	
			    		+"<input type='radio' style='width: 20px;'  name='expertise_code' value="+data.code+" />"
			    		+"<span id='psnLevelDept_3_"+data.code+"'>"+data.name+"</span>"
			    		+"</td>"
			    		+"</tr>";
					$("#tab3").append(str);
					
		        });
			}
		}
	});
	$.blockUI({ message: $('#deptTop_3'),
       css:{top:100,left:500}
	});
}
function deptTop4(e,param){
	$.blockUI({ message: $('#deptTop_4'),
       css:{top:100,left:500}
	});
}
function closeUI(){
	$.unblockUI();
}
function getExperCom1(e){
	var chk_value = $("input[name='expertise_code']:checked").val();
	var chk_name = $("#psnLevelDept_1_"+chk_value).text();
	$("#levelDept_1_name").val(chk_name);
	$("#levelDept_1").val(chk_value);
	$.unblockUI();	
}
function getExperCom2(e){
	var chk_value = $("input[name='expertise_code']:checked").val();
	var chk_name = $("#psnLevelDept_2_"+chk_value).text();
	$("#levelDept_2_name").val(chk_name);
	$("#levelDept_2").val(chk_value);
	$.unblockUI();	
}
function getExperCom3(e){
	var chk_value = $("input[name='expertise_code']:checked").val();
	var chk_name = $("#psnLevelDept_3_"+chk_value).text();
	$("#levelDept_3_name").val(chk_name);
	$("#levelDept_3").val(chk_value);
	$.unblockUI();	
}
function getExperCom4(e){
	var chk_value = $("input[name='expertise_code']:checked").val();
	var chk_name = $("#psnLevelDept_4_"+chk_value).text();
	$("#levelDept_4_name").val(chk_name);
	$("#levelDept_4").val(chk_value);
	$.unblockUI();	
}

function checksubmit(){
	var psnName = $("#psnName").val();
	if(psnName == ""){
		alert("姓名不能为空!");
		return false;
	}
	return true;
}
</script>
</head>
<body>
	<%@ include file="/common/headMenuBa.jsp"%>
    <div class="dpn-content">
		<div class="crumb">
			 当前位置：<a href="#">出口食品生产企业备案核准</a>
			&gt;<a href="<%=request.getContextPath()%>/expFoodPOF/psyList">评审员管理</a>&gt;<span class="tpinfo">修改</span>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="form">
			<div class="main">
			<form id="form1" action="<%=request.getContextPath()%>/expFoodPOF/updateQlcefpepsn?psnCode=${dto.psnCode}" method="post" enctype="multipart/form-data" onsubmit="return checksubmit()">
		     <input type = "hidden" name="psnId" value="${dto.psnId}">
		     <input type="hidden" name="type" value="${dto.type}" />
		<table class="table_base table_form">
		    <tr>
				<th style="width:25%;" id="left_noline"><span style="color:red">*</span>姓名：</th>
				<td style="width:25%;">
					<input type="text" id="psnName" name="psnName" style="width:180px" value="${dto.psnName}"/>
				</td>
				<th style = "width:20%;">评审员编号：</th>
				<td id="right_noline" style="width:25%;">
					<input type="text" style="width:180px" name="psnCode" value="${dto.psnCode}" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<th style="width:25%;" id="left_noline">评审员级别：</th>
				<td style="width:25%;">
					<input type="text" id="levelDept_4_name" style="width:180px" value="${dto.psnLevelName}" onclick="deptTop4(this,1)" readonly="readonly"/>
					<input type="hidden" id="levelDept_4" name="psnLevel" value="${dto.psnLevel}"/>
				</td>
				<th style = "width:20%;">一级部门：</th>
				<td id="right_noline" style="width:25%;">
					<input type="text" id="levelDept_1_name" style="width:180px" value="${dto.levelDept_1_name}" onclick="deptTop1(this,1)" readonly="readonly"/>
					<input type="hidden" id="levelDept_1" name="levelDept_1" value="${dto.levelDept_1}"/>
				</td>
			</tr>
		    <tr>
				<th style="width:25%;" id="left_noline">二级部门：</th>
				<td style="width:25%;">
					<input type="text" id="levelDept_2_name" style="width:180px" value="${dto.levelDept_2_name}" onclick="deptTop2(this,1)" readonly="readonly"/>
					<input type="hidden" id="levelDept_2" name="levelDept_2" value="${dto.levelDept_2}"/>
				</td>
				<th style = "width:20%;">三级部门：</th>
				<td id="right_noline" style="width:25%;">
					<input type="text" id="levelDept_3_name" style="width:180px" value="${dto.levelDept_3_name}" onclick="deptTop3(this,1)" readonly="readonly"/>
					<input type="hidden" id="levelDept_3" name="levelDept_3" value="${dto.levelDept_3}"/>
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">评审员状态：</th>
				<td id="left_noline" style="width:25%;">
					<select name="psn_status" style="width:185px">
						<option value="1"  <c:if test="${dto.psn_status == '1'}">  selected="selected" </c:if>>有效</option>
						<option value="0"  <c:if test="${dto.psn_status == '0'}">  selected="selected" </c:if>>暂停</option>
					</select>
				</td>
				<th style="width:25%;" id="right_noline">评审专长：</th>
				<td style="width:25%;" title="${zcname}">
					<input type="text" style="width:180px" name="psnGoodat" value="${dto.psnGoodat}" />
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">其他专长：</th>
				<td id="left_noline" style="width:25%;" title="${psnother_goodat_str}">
					<input type="text" name="psnOther_goodat" style="width:180px" value="${dto.psnOther_goodat}" />
				</td>
				<th style="width:25%;" id="right_noline">性别：</th>
				<td style="width:25%;">
					<select name="six" style="width:185px">
						<option value="男"  <c:if test="${dto.six == '男'}">  selected="selected" </c:if>>男</option>
						<option value="女"  <c:if test="${dto.six == '女'}">  selected="selected" </c:if>>女</option>
					</select>
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">出生日期：</th>
				<td id="left_noline" style="width:25%;">
					<input type="text" name="psnBirth" style="width:180px" value="${dto.psnBirth}" />
				</td>
				<th style="width:25%;" id="right_noline">毕业院校：</th>
				<td style="width:25%;">
					<input type="text" name="psnGraduate" style="width:180px" value="${dto.psnGraduate}" />
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">所学专业：</th>
				<td id="left_noline" style="width:25%;">
					<input type="text" name="psnMajor" style="width:180px" value="${dto.psnMajor}" />
				</td>
				<th style="width:25%;" id="right_noline">学历：</th>
				<td style="width:25%;">
					<input type="text" name="psnEducation" style="width:180px" value="${dto.psnEducation}" />
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">外语语种及水平：</th>
				<td id="left_noline" style="width:25%;">
					<input type="text" name="engLevel" style="width:180px" value="${dto.engLevel}" />
				</td>
				<th style="width:25%;" id="right_noline">办公电话：</th>
				<td style="width:25%;">
					<input type="text" name="bsTel" style="width:180px" value="${dto.bsTel}" />
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">手机：</th>
				<td id="left_noline" style="width:25%;">
					<input type="text" name="mobilePhone" style="width:180px" value="${dto.mobilePhone}" />
				</td>
				<th style="width:25%;" id="right_noline">现任职务：</th>
				<td style="width:25%;">
					<input type="text" name="curPost" style="width:180px" value="${dto.curPost}" />
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">现从事主要工作：</th>
				<td id="left_noline" style="width:25%;" >
					<input type="text" name="curWork" style="width:180px" value="${dto.curWork}" />
				</td>
				<th style="width:25%;" id="right_noline">评审专长：</th>
				<td style="width:25%;">
					<input type="text" name="workExpertise" style="width:180px" value="${dto.workExpertise}" />
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">是否在岗：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					<select id="in_post" name="in_post" style="width:185px">
						<option value="1"  <c:if test="${dto.in_post == 1}">  selected="selected" </c:if>>是</option>
						<option value="0"  <c:if test="${dto.in_post == 0}">  selected="selected" </c:if>>否</option>
					</select>
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">工作简历：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					<textarea rows="6" cols="95" name="psnResume">${dto.psnResume}</textarea>
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">培训经历：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					<textarea rows="6" cols="95" name="psnTrain">${dto.psnTrain}</textarea>
				</td>				
			</tr>
			<tr>
				<th style = "width:20%;">备注：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					<textarea rows="6" cols="95" name="rmk">${dto.rmk}</textarea>
				</td>
			</tr>
		</table>

		<div class = "table_spacing"></div>
		<div class = "action" style="margin-top:20px">
			<input value="提交" type="submit" style="width:50px;text-align: center"/>
			<input onclick="javascript:history.go(-1);" style="width:50px;text-align: center" value="返回" type="button"/>
		</div>
		</form>		
	</div>
	</div>

	</div>
	
	<div id="deptTop_4" class="lightbox" style="width: 420px;height:400px;display: none;">
		<table width="100%">
			<tr>
				<th class="lightbox_th" height="15px">
					<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
				</th>
			</tr>
			<tr>
				<td>
					<div style="position:relative; height:340px; overflow:auto">
					<div style="background-color: #999999;">评审员级别</div>
					<table style="height: auto;">
					<c:if test="${not empty psnLevelList }">
					<c:forEach items="${psnLevelList}" var="row">
						<tr>
							<td  align="left" >
								<c:if test='${row.code!=null}'>
									<input type="radio" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />						
								</c:if>
								<span id="psnLevelDept_4_${row.code}">${row.name}</span>
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
					<input type="button" id="combtn" value="确定" onclick="getExperCom4(this)" />
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
								<input type="radio" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />						
							</c:if>
							<span id="psnLevelDept_1_${row.code}">${row.name}</span>
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
				<input type="button" id="combtn" value="确定" onclick="getExperCom1(this)" />
			</td>
		</tr>
	</table>
	
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
				<table style="height: auto;" id="tab2">
				<%-- <c:if test="${not empty psnLevelDept_2Code }">
				<c:forEach items="${psnLevelDept_2Code}" var="row">
					<tr>
						<td  align="left" >
							<c:if test='${row.code!=null}'>
								<input type="radio" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
							</c:if>
							<span id="psnLevelDept_2_${row.code}">${row.name}</span>
						</td>
					</tr>
				</c:forEach>
				</c:if> --%>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom_2">
				<input type="button" id="combtn_2" value="确定" onclick="getExperCom2(this)" />
			</td>
		</tr>
	</table>
	
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
				<table style="height: auto;" id="tab3">
				
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom_3">
				<input type="button" id="combtn_3" value="确定" onclick="getExperCom3(this)" />
			</td>
		</tr>
	</table>
</div>	
</div>	
</div>	
</body>
</html>