<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>行政处罚案件调查报告</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 
	$(function(){
	    var bizError = "${bizError}";
		if($("#operation").val() == "close"){
			if(bizError){
				alert(bizError);
				window.close();
			}else{
				alert("保存成功！请点击确定关闭页面");
				window.close();
			}
			
		}
		$("#option_10_ta").val($("#option_10").val());
		$("#option_11_ta").val($("#option_11").val());
		
		//根据二级步骤（角色）限制编辑区域
		var subStep = $("#subStep").val();
		if(subStep){
			$("input, textarea").each(function(e){
				$(this).attr("readonly", "readonly");
			});
		}
	});
	
	function submitForm(){
		$("#option_10").val($("#option_10_ta").val());
		$("#option_11").val($("#option_11_ta").val());
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
	<input type="hidden" id="subStep" value="${subStep }"/>
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
      			<td colspan="9" class="table_1_1"><h1>中华人民共和国    出入境检验检疫局</h1></td>
    		</tr>
    		<tr>
     			<td colspan="9" class="table_1_1"><span>行政处罚案件调查报告</span></td>
    		</tr>
		    <tr>
		      	<td colspan="9" class="table_2_1">（<input name="option_1" value="${doc.option_1 }" style="width:100px;"/></span>）检法【<span><input name="option_2" value="${doc.option_2 }" style="width:100px;"/></span>】号</td>
		    </tr>	
		    <tr>
		      	<td rowspan="3" style="width:90px;"><span>当事人</span></td>
		      	<td style="width:90px;">姓名</td>
		      	<td style="width:90px;"><input name="option_3" value="${doc.option_3 }" style="width:80px;"/></td>
		      	<td style="width:90px;">性别</td>
		      	<td style="width:90px;"><input name="option_4" value="${doc.option_4 }" style="width:80px;"/></td>
		      	<td style="width:90px;">出生年月</td>
		      	<td style="width:90px;"><input name="option_5" value="${doc.option_5 }" style="width:80px;"/></td>
		      	<td style="width:90px;">国籍</td>
		      	<td style="width:90px;"><input name="option_6" value="${doc.option_6 }" style="width:80px;"/></td>
		    </tr>
		    <tr>
		      	<td>单位名称</td>
		      	<td colspan="3"><input name="option_7" value="${doc.option_7 }" style="width:260px;"/></td>
		      	<td>法定代表人</td>
		      	<td colspan="3"><input name="option_8" value="${doc.option_8 }" style="width:260px;"/></td>
		    </tr>
		    <tr>
		      	<td>住址或地址</td>
		      	<td colspan="7"><input name="option_9" value="${doc.option_9 }" style="width:620px;"/></td>
		    </tr>
		    <tr style="height: 200px;">
		      	<td style="width:90px;"><span>案件调查情况</span></td>
		      	<td colspan="8" style="text-align:left;">
		      		<textarea id="option_10_ta" style="width:700px;height:170px;"></textarea>
		      		<input type="hidden" id="option_10" name="option_10" value="${doc.option_10 }"/>
		      		<br/>
		      		（证据材料清单附后）
		      	</td>
		    </tr>
		    <tr>
		    	<td style="width:90px;" rowspan="3"><span>处理意见</span></td>
		    	<td colspan="8">
		      		<textarea id="option_11_ta" style="width:700px;height:170px;"></textarea>
		      		<input type="hidden" id="option_11" name="option_11" value="${doc.option_11 }"/>
		      	</td>
		    </tr>
		    <tr style="border-top:hidden;">
		    	<td colspan="2" style="border-right: hidden;text-align:right;">承办人：</td>
		    	<td colspan="2" style="border-right: hidden;text-align:left"><input name="option_12" value="${doc.option_12 }" style="width:120px;"/></td>
		    	<td colspan="2" style="border-right: hidden;text-align:right;">负责人：</td>
		    	<td colspan="2" style="text-align:left"><input name="option_13" value="${doc.option_13 }" style="width:120px;"/></td>
		    </tr>
		    <tr style="border-top:hidden;">
		    	<td colspan="4" style="border-right: hidden;text-align:center;">
		    		<input name="option_14" value="${doc.option_14 }" style="width:60px;"/>
		    		年
		    		<input name="option_15" value="${doc.option_15 }" style="width:60px;"/>
		    		月
		    		<input name="option_16" value="${doc.option_16 }" style="width:60px;"/>
		    		日
		    	</td>
		    	<td colspan="4" style="text-align:center;">
		    		<input name="option_17" value="${doc.option_17 }" style="width:60px;"/>
		    		年
		    		<input name="option_18" value="${doc.option_18 }" style="width:60px;"/>
		    		月
		    		<input name="option_19" value="${doc.option_19 }" style="width:60px;"/>
		    		日
		    	</td>
		    </tr>
  		</table>
  		<br/>
  		<br/>
  		<table>
  			<tr colspan="9" style="text-align:center;">（续页）</tr>
  			<tr>
  				<td rowspan="20" style="width:90px;">所附证据材料</td>
  				<td style="width:90px;">种类</td>
  				<td colspan="3" style="width:270px;">证据名称</td>
  				<td style="width:90px;">规格</td>
  				<td colspan="3">数量</td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_20" value="${doc.option_20}" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
	  				<select name="option_20" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_20 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_20 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_20 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_20 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_20 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_20 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_20 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_20 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_20}" type="hidden" style="width:85px;"/>
  					${doc.option_20}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_21" value="${doc.option_21 }" style="width:250px;"/></td>
  				<td><input name="option_22" value="${doc.option_22 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_23" value="${doc.option_23 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_24" value="${doc.option_24 }" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
	  				<select name="option_24" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_24 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_24 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_24 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_24 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_24 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_24 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_24 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_24 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_24}" type="hidden" style="width:85px;"/>
  					${doc.option_24}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_25" value="${doc.option_25 }" style="width:250px;"/></td>
  				<td><input name="option_26" value="${doc.option_26 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_27" value="${doc.option_27 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_28" value="${doc.option_28 }" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
					 <select name="option_28" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_28 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_28== '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_28== '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_28== '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_28== '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_28== '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_28== '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_28== '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_28}" type="hidden" style="width:85px;"/>
  					${doc.option_28}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_29" value="${doc.option_29 }" style="width:250px;"/></td>
  				<td><input name="option_30" value="${doc.option_30 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_31" value="${doc.option_31 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  					<%-- <input name="option_32" value="${doc.option_32 }" style="width:85px;"/> --%>
  					<c:if test="${subStep != '0' }">
	  				<select name="option_32" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_32 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_32 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_32 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_32 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_32 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_32 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_32 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_32 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_32}" type="hidden" style="width:85px;"/>
  					${doc.option_32}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_33" value="${doc.option_33 }" style="width:250px;"/></td>
  				<td><input name="option_34" value="${doc.option_34 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_35" value="${doc.option_35 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_36" value="${doc.option_36 }" style="width:85px;"/> --%>
  					<c:if test="${subStep != '0' }">
	  				<select name="option_36" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_36 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_36 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_36 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_36 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_36 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_36 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_36 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_36 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_36}" type="hidden" style="width:85px;"/>
  					${doc.option_36}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_37" value="${doc.option_37 }" style="width:250px;"/></td>
  				<td><input name="option_38" value="${doc.option_38 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_39" value="${doc.option_39 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
<%--   				<input name="option_40" value="${doc.option_40 }" style="width:85px;"/> --%>
					<c:if test="${subStep != '0' }">
	  				<select name="option_40" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_40 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_40 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_40 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_40 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_40 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_40 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_40 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_40 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_40}" type="hidden" style="width:85px;"/>
  					${doc.option_40}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_41" value="${doc.option_41 }" style="width:250px;"/></td>
  				<td><input name="option_42" value="${doc.option_42 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_43" value="${doc.option_43 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_44" value="${doc.option_44 }" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
	  				<select name="option_44" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_44 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_44 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_44 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_44 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_44 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_44 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_44 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_44 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_44}" type="hidden" style="width:85px;"/>
  					${doc.option_44}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_45" value="${doc.option_45 }" style="width:250px;"/></td>
  				<td><input name="option_46" value="${doc.option_46 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_47" value="${doc.option_47 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_48" value="${doc.option_48 }" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
  					<select name="option_48" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_48 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_48 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_48 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_48 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_48 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_48 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_48 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_48 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_48}" type="hidden" style="width:85px;"/>
  					${doc.option_48}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_49" value="${doc.option_49 }" style="width:250px;"/></td>
  				<td><input name="option_50" value="${doc.option_50 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_51" value="${doc.option_51 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_52" value="${doc.option_52 }" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
	  				<select name="option_52" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_52 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_52 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_52 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_52 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_52 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_52 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_52 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_52 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_52}" type="hidden" style="width:85px;"/>
  					${doc.option_52}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_53" value="${doc.option_53 }" style="width:250px;"/></td>
  				<td><input name="option_54" value="${doc.option_54 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_55" value="${doc.option_55 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_56" value="${doc.option_56 }" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
  					 <select name="option_56" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_56 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_56 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_56 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_56 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_56 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_56 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_56 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_56 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
  				</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_56}" type="hidden" style="width:85px;"/>
  					${doc.option_56}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_57" value="${doc.option_57 }" style="width:250px;"/></td>
  				<td><input name="option_58" value="${doc.option_58 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_59" value="${doc.option_59 }" style="width:250px;"/></td>
  			</tr>
  			<tr>
  				<td>
  				<%-- <input name="option_60" value="${doc.option_60 }" style="width:85px;"/> --%>
  				<c:if test="${subStep != '0' }">
  					 <select name="option_60" style="width:90px; height:34px;">
	  					<option <c:if test="${empty doc.option_60 }"> selected="selected"</c:if>>请选择</option>
	  					<option <c:if test="${doc.option_60 == '书证' }"> selected="selected"</c:if> value="书证">书证</option>
	  					<option <c:if test="${doc.option_60 == '物证' }"> selected="selected"</c:if> value="物证">物证</option>
	  					<option <c:if test="${doc.option_60 == '当事人陈述' }"> selected="selected"</c:if> value="当事人陈述">当事人陈述</option>
	  					<option <c:if test="${doc.option_60 == '视听资料' }"> selected="selected"</c:if> value="视听资料">视听资料</option>
	  					<option <c:if test="${doc.option_60 == '现场勘验记录' }"> selected="selected"</c:if> value="现场勘验记录">现场勘验记录</option>
	  					<option <c:if test="${doc.option_60 == '证人证言' }"> selected="selected"</c:if> value="证人证言">证人证言</option>
	  					<option <c:if test="${doc.option_60 == '鉴定结论' }"> selected="selected"</c:if> value="鉴定结论">鉴定结论</option>
	  				</select>
	  			</c:if>
  				<c:if test="${subStep == '0' }">
  					<input name="option_20" value="${doc.option_60}" type="hidden" style="width:85px;"/>
  					${doc.option_60}
  				</c:if>
  				</td>
  				<td colspan="3"><input name="option_61" value="${doc.option_61 }" style="width:250px;"/></td>
  				<td><input name="option_62" value="${doc.option_62 }" style="width:85px;"/></td>
  				<td colspan="3"><input name="option_63" value="${doc.option_63 }" style="width:250px;"/></td>
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