<%@page import="com.dpn.ciqqlc.common.util.DateUtil"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>行政处罚案件反馈表</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 
	$(function(){
		if($("#operation").val() == "close"){
			alert("保存成功！请点击确定关闭页面");
			window.close();
		}	
		$("#option_7_ta").val($("#option_7").val());
	});
	
	function submitForm(){
		$("#option_7").val($("#option_7_ta").val());
		$("#form").submit();
	}
</script>
<style type="text/css">
table{
    font-size: 15px;
    width:600px;
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
	<input type="hidden" id="message" value="${message }"/>
	<form id="form" action="/ciqs/generalPunishment/updateDoc" method="post">
  		<input type="hidden" name="id" value="${id }"/>
      	<input type="hidden" name="step" value="${step }"/>
      	<input type="hidden" name="page" value="gp_diaochabaogao"/>
      	<input type="hidden" name ="pre_report_no" value="${gpDTO.pre_report_no}"/>
   	  	<input type="hidden" name="doc_id" value="${doc.doc_id }"/>
   	  	<input type="hidden" name="doc_type" value="${doc.doc_type }"/>
   	  	<input type="hidden" name="proc_main_id" value="${doc.proc_main_id }"/>
  		<table>
  			<tr>
      			<td colspan="4" class="table_1_1"><h1>中华人民共和国    出入境检验检疫局</h1></td>
    		</tr>
    		<tr>
     			<td colspan="4" class="table_1_1" style="border-bottom-color: black;"><span>行政处罚案件反馈表</span></td>
    		</tr>
		    <tr>
		      	<td><span>案由</span></td>
		      	<td colspan="3"><input name="option_1" value="${doc.option_1 }" style="width:430px;"/></td>
		    </tr>
		    <tr>
		      	<td>案件编号</td>
		      	<td colspan="3"><input name="option_2" value="${doc.option_2 }" style="width:430px;"/></td>
		    </tr>
		    <tr>
		      	<td>业务部门</td>
		      	<td>反馈时间</td>
		      	<td>法综部门签字</td>
		      	<td>接收人签字</td>
		    </tr>
		    <tr>
		      	<td><input name="option_3" value="${doc.option_3 }" style="width:140px;"/></td>
		      	<td><input name="option_4" value="${doc.option_4 }" style="width:140px;"/></td>
		      	<td><input name="option_5" value="${doc.option_5 }" style="width:140px;"/></td>
		      	<td><input name="option_6" value="${doc.option_6 }" style="width:140px;"/></td>
		    </tr>
		    <tr style="heigth:300px;">
		    	<td colspan="4">
		    		案件处理结果<br/>
		    		<%-- <textarea id="option_7_ta" style="width:430px;height:260px;"></textarea>
		      		<input type="hidden" id="option_7" name="option_7" value="${doc.option_7}"/> --%>
		      		<span style="font-weight:600;font-size: 16px;line-height:30px;padding-left: 32px;text-align:left;">
		      		依据《<input name="option_11" value="${doc.option_11 }" style="width:180px;"/> 》第 <input name="option_12" value="${doc.option_12 }" style="width:100px;"/>  条第 <input name="option_13" value="${doc.option_13 }" style="width:100px;"/>  款的规定，对 <input name="option_14" value="${doc.option_14 }" style="width:100px;"/>  公司处以没收违法所得 <input name="option_15" value="${doc.option_15 }" style="width:100px;"/>  元，并处商品货值 <input name="option_16" value="${doc.option_16 }" style="width:100px;"/>  罚款，罚款金额人民币 <input name="option_17" value="${doc.option_17 }" style="width:100px;"/>  元，共计 <input name="option_18" value="${doc.option_18 }" style="width:100px;"/>  元整。请贵处按照《出入境检验检疫企业信用采集条目及信用等级评定规则》规定在“出入境检验检疫企业信用管理系统” 对该公司进行扣分处理。附：行政处罚决定书（影印件）</span>
		    	</td>
		    </tr>
		    <tr style="border-top:hidden;">
		    	<% 
		    		request.setAttribute("yy", DateUtil.getNowYYYY());
		    		request.setAttribute("mm", DateUtil.getNowMM());
		    		request.setAttribute("day", DateUtil.getNowDD());
		    	%>
		    	<td colspan="4" style="text-align:right;">
		    		<input name="option_8" value="${empty doc.option_8 ? yy:doc.option_8 } " style="width:100px;"/>&nbsp;年&nbsp;<input name="option_9" value="${empty doc.option_9 ? mm :doc.option_9 }" style="width:60px;"/>&nbsp;月&nbsp;<input name="option_10" value="${empty doc.option_10 ? day : doc.option_10}" style="width:60px;"/>&nbsp;日
		    	</td>
		    </tr>
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
</html>