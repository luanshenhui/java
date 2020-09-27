<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>行政处罚结案报告</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 
	$(function(){
		if($("#operation").val() == "close"){
			alert("保存成功！请点击确定关闭页面");
			window.close();
		}
		$("#option_12_ta").val($("#option_12").val());
		$("#option_13_ta").val($("#option_13").val());
		$("#option_14_ta").val($("#option_14").val());
		$("#option_15_ta").val($("#option_15").val());
	});
	
	function submitForm(){
		$("#option_12").val($("#option_12_ta").val());
		$("#option_13").val($("#option_13_ta").val());
		$("#option_14").val($("#option_14_ta").val());
		$("#option_15").val($("#option_15_ta").val());
		$("#form").submit();
	}
</script>
<style type="text/css">
table{
    font-size: 15px;
    width:810px;
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
      	<input type="hidden" name="page" value="gp_xzcf_jabg"/>
        <input type="hidden" name="pre_report_no" value="${pre_report_no }"/>
   	  	<input type="hidden" name="doc_id" value="${doc.doc_id }"/>
   	  	<input type="hidden" name="doc_type" value="${doc.doc_type }"/>
   	  	<input type="hidden" name="proc_main_id" value="${doc.proc_main_id }"/>
  		<table>
  			<tr>
      			<td colspan="9" class="table_1_1"><h1>中华人民共和国    出入境检验检疫局</h1></td>
    		</tr>
    		<tr>
     			<td colspan="9" class="table_1_1" style="border-bottom-color: black;"><span>行政处罚结案报告</span></td>
    		</tr>
		    <tr>
		      	<td rowspan="3" style="width:90px;"><span>当事人</span></td>
		      	<td style="width:90px;">姓名</td>
		      	<td style="width:90px;"><input name="option_3" value="${gpDTO.psn_name }" style="width:80px;"/></td>
		      	<td style="width:90px;">性别</td>
		      	<td style="width:90px;"><input name="option_4" value="${gpDTO.gender }" style="width:80px;"/></td>
		      	<td style="width:90px;">出生年月</td>
		      	<td style="width:90px;"><input name="option_5" value="${gpDTO.birth }" style="width:80px;"/></td>
		      	<td style="width:90px;">国籍</td>
		      	<td style="width:90px;"><input name="option_6" value="${gpDTO.nation }" style="width:80px;"/></td>
		    </tr>
		    <tr>
		      	<td>单位名称</td>
		      	<td colspan="3"><input name="option_7" value="${gpDTO.comp_name }" style="width:260px;"/></td>
		      	<td>法定代表人</td>
		      	<td colspan="3"><input name="option_8" value="${gpDTO.corporate_psn }" style="width:260px;"/></td>
		    </tr>
		    <tr>
		      	<td>住址或地址</td>
		      	<td colspan="7"><input name="option_9" value="${gpDTO.addr }" style="width:620px;"/></td>
		    </tr>
		    <tr>
		      	<td style="width:90px;" rowspan="2"><span>处罚决定书</span></td>
		      	<td>编号</td>
		      	<td colspan="3"><input name="option_10" value="${doc.option_10 }" style="width:260px;"/></td>
		      	<td>送达日期</td>
		      	<td colspan="3"><input name="option_11" value="${doc.option_11 }" style="width:260px;"/></td>
		    </tr>
		    <tr style="height: 140px;">
				<td>内容</td>
				<td colspan="7">
					<textarea id="option_12_ta" style="width:620px;height:130px;"></textarea>
		      		<input type="hidden" id="option_12" name="option_12" value="${doc.option_12 }"/>
				</td>
			</tr>
		    <tr style="height: 120px;">
		    	<td>自动执行情况</td>
		    	<td colspan="8">
		      		<textarea id="option_13_ta" style="width:700px;height:110px;"></textarea>
		      		<input type="hidden" id="option_13" name="option_13" value="${doc.option_13 }"/>
		      	</td>
		    </tr>
		    <tr style="height: 120px;">
		    	<td>强制执行情况</td>
		    	<td colspan="8">
		      		<textarea id="option_14_ta" style="width:700px;height:110px;"></textarea>
		      		<input type="hidden" id="option_14" name="option_14" value="${doc.option_14 }"/>
		      	</td>
		    </tr>
		    <tr style="height: 100px;">
		    	<td>备注</td>
		    	<td colspan="8">
		      		<textarea id="option_15_ta" style="width:700px;height:90px;"></textarea>
		      		<input type="hidden" id="option_15" name="option_15" value="${doc.option_15 }"/>
		      	</td>
		    </tr>
		    <tr>
		    	<td>填表人</td>
		    	<td colspan="3" style="text-align:center;"><input name="option_16" value="${doc.option_16 }" style="width:250px;"/></td>
		    	<td>审核人</td>
		    	<td colspan="4" style="text-align:center;"><input name="option_17" value="${doc.option_17 }" style="width:320px;"/></td>
		    </tr>
  		</table>
  		<input type="button" style="margin: 40px 40px 0px 560px; width: 80px;height: 30px;" value="提交" onclick="submitForm();"/>
  		<input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="关闭" onclick=" window.close()"/>
  		<input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="打印" onclick="window.print();"/>
  	</form>
</div>  
</body>
</html>