<%@page import="com.dpn.ciqqlc.common.util.DateUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>检验检疫涉嫌案件申报单</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 
var referrer = "";
	$(function(){
		if($("#operation").val() == "close"){
			alert("保存成功！请点击确定关闭页面");
			window.location.href = $("#referrerPage").val();
			/* window.close(); */
		}
		$("#option_9_ta").val($("#option_9").val());
		$("#option_10_ta").val($("#option_10").val());
		$("#option_11_ta").val($("#option_11").val());
		$("#option_16_ta").val($("#option_16").val());
		$("#option_23_ta").val($("#option_23").val());
		
		//根据二级步骤（角色）限制编辑区域
		var subStep = $("#subStep").val();
		if(subStep == '0'){
			$("input, textarea").each(function(e){
				$(this).attr("readonly", "readonly");
			});
		}
		
		$("#option_2").val(decodeURI($("#option_2").val()));
		$("#option_3").val(decodeURI($("#option_3").val()));
		$("#option_5").val(decodeURI($("#option_5").val()));
		$("#option_6").val(decodeURI($("#option_6").val()));
		$("#option_7").val(decodeURI($("#option_7").val()));
		$("#option_8").val(decodeURI($("#option_8").val()));
		$("#option_21").val(decodeURI($("#option_21").val()));
		/* history.back(-1); */
	});
	
	function submitForm(){
		$("#option_9").val($("#option_9_ta").val());
		$("#option_10").val($("#option_10_ta").val());
		$("#option_11").val($("#option_11_ta").val());
		$("#option_16").val($("#option_16_ta").val());
		$("#option_23").val($("#option_23_ta").val());
		$("#referrerPage").val(document.referrer);
		$("#form").submit();
	}
</script>
<style type="text/css">
table{
    font-size: 15px;
    width:700px;
}
tr{
    height: 35px;
}
td{
    border: 1px solid #000;
}
input{
	border: 0px;
	height:30px;
	text-align: center;
}
textarea{
	border:0px;
}
.table_1_1{
    font-size:25px;
    font-family:'楷体_GB2312';
    font-weight: bold;
    width:700px;
    text-align:certer;
    border-color: white;
}
.table_2_1{
    font-size:15px;
    font-family:'楷体_GB2312';
    text-align:right;
    border-color: white  white  #000 white;
}
.table_3_1{
    height:90px;
    width:40px;
}
.table_4_1,.table_5_1,.table_8_1{
    height:180px; 
}
.table_11_1{
    height:90px;
}
.table_5_2,.table_8_2{
    height:110px;
}
.table_6_2,.table_6_3,.table_7_2,.table_7_3,.table_9_2,.table_10_2{
    border-top-style: hidden;
}
.table_6_3,.table_7_3{
    border-left-style: hidden;
}
.wordsRight{
    display: block;
    text-align: right;
}
.tableWords{
    display: block;
    white-space: normal;
    width: 651px;
}
</style>
</head>
<body>
<div id="content">
	<input type="hidden" id="operation" value="${operation }"/>
	<form id="form" action="/ciqs/generalPunishment/updateDoc" method="post">
		<input type="hidden" id="referrerPage" name="referrerPage" value="${referrerPage }"/>
		<input type="hidden" id="subStep" name="subStep" value="${subStep }"/>
  		<input type="hidden" name="id" value="${id }"/>
      	<input type="hidden" name="step" value="${step }"/>
      	<input type="hidden" name="page" value="gp_shexiananjian_sbd_input"/>
      	<input type="hidden" name ="pre_report_no" value="${gpDTO.pre_report_no}"/>
   	  	<input type="hidden" name="doc_id" value="${doc.doc_id }"/>
   	  	<input type="hidden" name="doc_type" value="${doc.doc_type }"/>
   	  	<input type="hidden" name="proc_main_id" value="${doc.proc_main_id }"/>
  		<table>
  			<tr>
      			<td colspan="9" class="table_1_1"><h1>中华人民共和国大连出入境检验检疫</h1></td>
    		</tr>
    		<tr>
     			<td colspan="7" class="table_1_1"><span>检验检疫涉嫌案件申报单</span></td>
    		</tr>
		    <tr>
		      	<td colspan="7" class="table_2_1">
		      	（<input name="option_24" id="" <c:if test="${not empty doc }"> value="${doc.option_24 }" </c:if> style="width: 80px;"/>）
		      	检申【
		      		<span>
		      			<input name="option_1" value="${doc.option_1 }" style="width:100px;"/>
		      		</span>
		      	】号</td>
		    </tr>	
		    <tr>
		      	<td rowspan="5" style="width:90px;"><span>违法当事人基本情况</span></td>
		      	<td style="width:90px;"><p>姓名</p><p>(自然人)</p></td>
		      	<td style="width:90px;"><input id="option_2" name="option_2" value="<c:choose><c:when test="${empty doc.doc_id}">${gpDTO.psn_name }</c:when><c:otherwise>${doc.option_2 }</c:otherwise></c:choose>" style="width:80px;"/></td>
		      	<td style="width:90px;">性别</td>
		      	<td style="width:90px;">
		      		<input id="option_3" name="option_3" 
		      		<c:if test="${empty doc.doc_id }">
		      			<c:if test="${gpDTO.gender == '0' }">value="不详"</c:if>
		      			<c:if test="${gpDTO.gender == '1' }">value="男"</c:if>
		      			<c:if test="${gpDTO.gender == '2' }">value="女"</c:if> 
		      		</c:if> 
		      		<c:if test="${not empty doc.doc_id }">value="${ doc.option_3}"</c:if>
		      		style="width:80px;"/>
		      	</td>
		      	<td style="width:90px;">年龄</td>
		      	<td style="width:90px;"><input name="option_4" value="<c:choose><c:when test="${ empty doc.doc_id}">${gpDTO.age }</c:when><c:otherwise>${doc.option_4 }</c:otherwise></c:choose>" style="width:80px;"/></td>
		    </tr>
		    <tr>
		      	<td>住址</td>
		      	<td colspan="5"><input id="option_5" name="option_5" value="<c:choose><c:when test="${ empty doc.doc_id}">${gpDTO.per_addr }</c:when><c:otherwise>${doc.option_5 }</c:otherwise></c:choose>" style="width:400px;"/></td>
		    </tr>
		    <tr>
		      	<td>违法单位</td>
		      	<td colspan="5"><input id="option_6" name="option_6" value="<c:choose><c:when test="${ empty doc.doc_id}">${gpDTO.comp_name }</c:when><c:otherwise>${doc.option_6 }</c:otherwise></c:choose>" style="width:400px;"/></td>
		    </tr>
		    <tr>
		      	<td style="width:90px;">法定代表人</td>
		      	<td style="width:90px;"><input id="option_7" name="option_7" value="<c:choose><c:when test="${ empty doc.doc_id}">${gpDTO.corporate_psn }</c:when><c:otherwise>${doc.option_7 }</c:otherwise></c:choose>" style="width:80px;"/></td>
		      	<td style="width:90px;">单位地址</td>
		      	<td style="width:90px;" colspan="3"><input id="option_8" name="option_8" value="${empty doc.doc_id?gpDTO.addr:doc.option_8 }" style="width:250px;"/></td>
		    </tr>
		    <tr>
		      	<td style="width:90px;">联系人</td>
		      	<td style="width:90px;"><input id="option_21" name="option_21" value="${empty doc.doc_id?gpDTO.contacts_name:doc.option_21 }" style="width:80px;"/></td>
		      	<td style="width:90px;">联系电话</td>
		      	<td style="width:90px;" colspan="3"><input name="option_22" value="<c:choose><c:when test="${ empty doc.doc_id}">${gpDTO.tel }</c:when><c:otherwise>${doc.option_22 }</c:otherwise></c:choose>" style="width:250px;"/></td>
		    </tr>
		    <tr style="height: 140px;">
		      	<td style="width:90px;"><span>涉嫌违法案件案情摘要</span></td>
		      	<td colspan="6">
		      		<textarea id="option_9_ta" style="width:530px;height:110px;"></textarea>
		      		<input type="hidden" id="option_9" name="option_9" value="${doc.option_9 }"/>
		      	</td>
		    </tr>
		    <tr style="height: 70px;">
		      	<td style="width:90px;"><span>涉案金额</span></td>
		      	<td colspan="6">
		      		<textarea id="option_23_ta" style="width:530px;height:110px;"></textarea>
		      		<input type="hidden" id="option_23" name="option_23" value="${doc.option_23 }"/>
		      	</td>
		    </tr>
		    <tr style="height: 140px;">
		      	<td style="width:90px;"><span>提供的案件材料</span></td>
		      	<td colspan="6">
		      		<textarea id="option_10_ta" style="width:530px;height:110px;"></textarea>
		      		<input type="hidden" id="option_10" name="option_10" value="${doc.option_10 }"/>
		      	</td>
		    </tr>
		    <tr style="height: 140px;">
		      	<td style="width:90px;" rowspan="2"><span>申报部门意见</span></td>
		      	<td colspan="6">
		      		<textarea id="option_11_ta" style="width:530px;height:110px;"></textarea>
		      		<input type="hidden" id="option_11" name="option_11" value="${doc.option_11 }"/>
		      	</td>
		    </tr>
		    <tr style="border-top: hidden;">
		    	<td style="width:90px;border-right: hidden;">负责人签字：</td>
		    	<td colspan="2" style="width:90px;border-right: hidden;"><input name="option_12" value="${doc.option_12 }" style="width:168px;margin-left: -40px;"/></td>
		    	<td colspan="3">
		    	<% 
		    		request.setAttribute("y", DateUtil.getNowYYYY());
		    		request.setAttribute("m", DateUtil.getNowMM());
		    		request.setAttribute("d", DateUtil.getNowDD());
		    	  %>
		    		<input name="option_13" value="${empty doc.option_13 ? y:doc.option_13 }" style="width:50px;"/>年
		    		<input name="option_14" value="${empty doc.option_14  ? m:doc.option_14 }" style="width:40px;"/>月
		    		<input name="option_15" value="${empty doc.option_15 ? d:doc.option_15  }" style="width:40px;"/>日
		    	</td>
		    </tr>
		    <tr style="height: 140px;">
		      	<td style="width:90px;" rowspan="2"><span>备注</span></td>
		      	<td colspan="6">
		      		<textarea id="option_16_ta" style="width:530px;height:110px;"></textarea>
		      		<input type="hidden" id="option_16" name="option_16" value="${doc.option_16 }"/>
		      	</td>
		    </tr>
		    <!-- 
		    <tr style="border-top: hidden;">
		    	<td style="width:90px;border-right: hidden;">负责人签字：</td>
		    	<td colspan="2" style="width:90px;border-right: hidden;"><input name="option_17" value="${doc.option_17 }" style="width:80px;"/></td>
		    	<td colspan="3">
		    		<input name="option_18" value="${doc.option_18 }" style="width:50px;"/>年
		    		<input name="option_19" value="${doc.option_19 }" style="width:40px;"/>月
		    		<input name="option_20" value="${doc.option_20 }" style="width:40px;"/>日
		    	</td>
		    </tr>
		     -->
  		</table>
      <div style="text-align: center;">
	      <c:if test="${subStep != '0' }">
		      <input type="button" style="width: 80px;height: 30px;" value="提交" onclick="submitForm();"/>
	      </c:if>
	  	  <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="关闭" onclick=" window.close()"/>
	  	  <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="打印" onclick="window.print();"/>
      </div>
  	</form>
</div>  
</body>
<script type="text/javascript"> 
	if(location.href.indexOf('isSee=true') != -1){
		document.getElementById("hideButton").style.display = "none"
	}
</script>
</html>