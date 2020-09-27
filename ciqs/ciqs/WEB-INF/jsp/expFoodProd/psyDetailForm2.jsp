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
function deptTop1(e,param){
	$.blockUI({ message: $('#deptTop_1'),
       css:{top:100,left:500}
	});
}
function deptTop2(e,param){
	$.blockUI({ message: $('#deptTop_2'),
       css:{top:100,left:500}
	});
}
function deptTop3(e,param){
	$.blockUI({ message: $('#deptTop_3'),
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
jQuery(document).ready(function(){
	$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>出口食品生产企业监督检查</span><div>");
	$(".user-info").css("color","white");
});
</script>
</head>
<body>
	<div class="dpn-frame-head">
        <table>
        	<tr>
        		<td>
        		<span class="logo" style="width:630px;">
        		</span>
        		</td>
        		<td style="font-size: 14px;color: black;margin-top: 30px;a:active{color: black}">
        			<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
        		</td>
        	</tr>
        </table>
   </div>
	<div class="dpn-frame-menu">
        <div class="loca">
            <ul class="nav">
                <li>
                    <a href="<%=request.getContextPath()%>/extxz/pesoninit?type=1">人员随机</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/expFoodPOF/psyList2">评审员管理</a>
                </li>
            </ul>
        </div>
    </div>
    <div class="dpn-content">
		<div class="crumb">
			 当前位置：<a href="#">出口食品生产企业监督检查</a>
			&gt;<a href="<%=request.getContextPath()%>/expFoodPOF/psyList">评审员管理</a>&gt;<span class="tpinfo">详情</span>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="form">
			<div class="main">
			<form id="form1" action="" method="post" enctype="multipart/form-data"></form>
		        <%-- <input type = "hidden" name="license_dno" value="${dto.license_dno}"> --%>
		     
		<table class="table_base table_form">
		    <tr>
				<th style="width:25%;" id="left_noline">姓名：</th>
				<td style="width:25%;">
					${dto.psnName}
				</td>
				<th style = "width:20%;">评审员编号：</th>
				<td id="right_noline" style="width:25%;">
					${dto.psnCode}
				</td>
			</tr>
			<tr>
				<th style="width:25%;" id="left_noline">评审员级别：</th>
				<td style="width:25%;">
					${dto.psnLevelName}
				</td>
				<th style = "width:20%;">一级部门：</th>
				<td id="right_noline" style="width:25%;">
					${dto.levelDept_1_name}
				</td>
			</tr>
		    <tr>
				<th style="width:25%;" id="left_noline">二级部门：</th>
				<td style="width:25%;">
					${dto.levelDept_2_name}
				</td>
				<th style = "width:20%;">三级部门：</th>
				<td id="right_noline" style="width:25%;">
					${dto.levelDept_3_name}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">评审员状态：</th>
				<td id="left_noline" style="width:25%;">
					<c:if test="${dto.psn_status == 1}">
						有效
					</c:if>
					<c:if test="${dto.psn_status == 0}">
						暂停
					</c:if>
				</td>
				<th style="width:25%;" id="right_noline">评审专长：</th>
				<td style="width:25%;" title="${zcname}">
					${dto.psnGoodat}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">其他专长：</th>
				<td id="left_noline" style="width:25%;" title="${psnother_goodat_str}">
					${dto.psnOther_goodat}
				</td>
				<th style="width:25%;" id="right_noline">性别：</th>
				<td style="width:25%;">
					<c:if test="${dto.six == '男'}">男</c:if>
					<c:if test="${dto.six == '女'}">女</c:if>
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">出生日期：</th>
				<td id="left_noline" style="width:25%;">
					${dto.psnBirth}
				</td>
				<th style="width:25%;" id="right_noline">毕业院校：</th>
				<td style="width:25%;">
					${dto.psnGraduate}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">所学专业：</th>
				<td id="left_noline" style="width:25%;">
					${dto.psnMajor}
				</td>
				<th style="width:25%;" id="right_noline">学历：</th>
				<td style="width:25%;">
					${dto.psnEducation}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">外语语种及水平：</th>
				<td id="left_noline" style="width:25%;">
					${dto.engLevel}
				</td>
				<th style="width:25%;" id="right_noline">办公电话：</th>
				<td style="width:25%;">
					${dto.bsTel}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">手机：</th>
				<td id="left_noline" style="width:25%;">
					${dto.mobilePhone}
				</td>
				<th style="width:25%;" id="right_noline">现任职务：</th>
				<td style="width:25%;">
					${dto.curPost}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">现从事主要工作：</th>
				<td id="left_noline" style="width:25%;" >
					${dto.curWork}
				</td>
				<th style="width:25%;" id="right_noline">评审专长：</th>
				<td style="width:25%;">
					${dto.workExpertise}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">是否在岗：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					<c:if test="${dto.in_post == 1}">
						是
					</c:if>
					<c:if test="${dto.in_post == 0}">
						否
					</c:if>
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">工作简历：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					${dto.psnResume}
				</td>
			</tr>
			<tr>
				<th style = "width:20%;">培训经历：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					${dto.psnTrain}
				</td>				
			</tr>
			<tr>
				<th style = "width:20%;">备注：</th>
				<td id="left_noline" style="width:25%;" colspan="3">
					${dto.rmk}
				</td>
			</tr>
		</table>

		<div class = "table_spacing"></div>
		<div class = "action" style="margin-top:20px">
			<input onclick="javascript:history.go(-1);" style="width:50px;text-align: center" value="返回" type="button"/>
		</div>		
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
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_2Code }">
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
				</c:if>
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
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_3Code }">
				<c:forEach items="${psnLevelDept_3Code}" var="row">
					<tr>
						<td  align="left" >
							<c:if test='${row.code!=null}'>
								<input type="radio" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
							</c:if>
							<span id="psnLevelDept_3_${row.code}">${row.name}</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
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