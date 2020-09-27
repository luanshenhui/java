<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>立案审批表</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 
	$(function(){
		if($("#operation").val() == "close"){
			alert("保存成功！请点击确定关闭页面");
			window.close();
		}
		$("#option_11_ta").val($("#option_11").val());
		$("#option_14_ta").val($("#option_14").val());
		$("#option_24_ta").val($("#option_24").val());
		$("#option_34_ta").val($("#option_34").val());
		
		//根据二级步骤（角色）限制编辑区域
		var subStep = $("#subStep").val();
		
		if(subStep == '0'){
			$("input, textarea").each(function(e){
				$(this).attr("readonly", "readonly");
			});
			/*
			if(subStep == '3' || subStep == '4'){//稽查部门
				$("#option_11_ta").removeAttr("readonly");//立案事由
				$("#option_14_ta").removeAttr("readonly");//立案意见
				if(subStep == '3'){
					$("#option_16").removeAttr("readonly");//经办人
					$("#option_17").removeAttr("readonly");//年
					$("#option_18").removeAttr("readonly");//月
					$("#option_19").removeAttr("readonly");//日
				}else if(subStep == '4'){
					$("#option_20").removeAttr("readonly");//审批人
					$("#option_21").removeAttr("readonly");//年
					$("#option_22").removeAttr("readonly");//月
					$("#option_23").removeAttr("readonly");//日
				}
			}else if(subStep == '5' || subStep == '6'){
				$("#option_24_ta").removeAttr("readonly");//审核意见
				if(subStep == '5'){
					$("#option_26").removeAttr("readonly");//经办人
					$("#option_27").removeAttr("readonly");//年
					$("#option_28").removeAttr("readonly");//月
					$("#option_29").removeAttr("readonly");//日
				}else if(subStep == '6'){
					$("#option_30").removeAttr("readonly");//审批人
					$("#option_31").removeAttr("readonly");//年
					$("#option_22").removeAttr("readonly");//月
					$("#option_23").removeAttr("readonly");//日
				}
			}else if(subStep == '7'){
				$("#option_34_ta").removeAttr("readonly");//审核意见
					$("#option_26").removeAttr("readonly");//经办人
					$("#option_27").removeAttr("readonly");//年
					$("#option_28").removeAttr("readonly");//月
					$("#option_29").removeAttr("readonly");//日
			}
			*/
		}
		
	});
	
	function submitForm(){
		$("#option_11").val($("#option_11_ta").val());
		$("#option_14").val($("#option_14_ta").val());
		$("#option_24").val($("#option_24_ta").val());
		$("#option_34").val($("#option_34_ta").val());
		$("#form").submit();
	}
</script>
<style type="text/css">
table{
    font-size: 15px;
    width:900px;
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
.tableLine_1,.tableLine_2{
    font-size:25px;
    font-family:'楷体_GB2312';
    font-weight: bold;
    width:700px;
    text-align:certer;
    border-color: white;
}
.tableLine_3{
    font-size:15px;
    font-family:'楷体_GB2312';
    text-align:right;
    border-color: white  white  #000 white;
}
.tableLine_title{
    height:180px;
    width:40px;
}
.tableCol_2{
    height:30px;
    width:55px;
}
.tableCol_3{
    width:112px;
}
.tableCol_4{
    width:55px;
}
.tableCol_5{
    width:55px;
}
.tableCol_6{
    width:55px;
}
.tableCol_7{
    width:55px;
}
.tableCol_8{
    width:55px;
}
.tableCol_9{
    width:55px;
}
.tableLine_8,.tableLine_11{    
    height:110px;
}
.tableLine_9_2,.tableLine_12_2{
   border-style:hidden;
}
.tableLine_9_3,.tableLine_12_3{
   border-top-style:hidden;
   border-bottom-style:hidden;
}
.tableLine_10_2,.tableLine_13_2{
   border-right-style:hidden;
}
.tableLine_14{
   height:145px;
   border-bottom-style:hidden;
}
.tableLeft{
    display: block;
    margin-left: 0px;
    float: left;
}
.tableRight{
    display: block;
    float: right;
    margin-right: 20px;
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
  <input type="hidden" name="page" value="gp_lian_spb_input"/>
  <input type="hidden" name ="pre_report_no" value="${gpDTO.pre_report_no}"/>
  <input type="hidden" name="doc_id" value="${doc.doc_id }"/>
  <input type="hidden" name="doc_type" value="${doc.doc_type }"/>
  <input type="hidden" name="proc_main_id" value="${doc.proc_main_id }"/>
  <table>
    <tr>
      <td colspan="9" class="tableLine_1"><h1>中华人民共和国出入境检验检疫局</h1></td>
    </tr>
    <tr>
      <td colspan="9" class="tableLine_2"><h1>行政处罚案件立案审批表</h1></td>
    </tr>
    <tr>
      <td colspan="9" class="tableLine_3">案号：（<span><input name="option_1" value="${doc.option_1 }" style="width:100px;"/></span>）检立[<span><input name="option_2" value="${doc.option_2 }" style="width:100px;"/></span>]号</td>
    </tr>
    <tr>
      <td rowspan="3" style="width:100px;"><span>当事人</span></td>
      <td style="width:100px;"><span>姓名</span></td>
      <td style="width:100px;"><span></span><input name="option_3" value="${doc.option_3 }" style="width:90px;"/></td>
      <td style="width:100px;"><span>性别</span></td>
      <td style="width:100px;"><span></span><input name="option_4" value="${doc.option_4 }" style="width:90px;"/></td>
      <td style="width:100px;"><span>出生年月</span></td>
      <td style="width:100px;"><span></span><input name="option_5" value="${doc.option_5 }" style="width:90px;"/></td>
      <td style="width:100px;"><span>国籍</span></td>
      <td style="width:100px;"><span></span><input name="option_6" value="${doc.option_6 }" style="width:90px;"/></td>
    </tr>
    <tr>
      <td><span>单位名称</span></td>
      <td colspan="4"><span  ></span><input name="option_7" value="${doc.option_7 }" style="width:360px;"/></td>
      <td><span>法定代表人</span></td>
      <td colspan="2"><span></span><input name="option_8" value="${doc.option_8 }" style="width:180px;"/></td>
    </tr>
    <tr>
      <td><span>住址或地址</span></td>
      <td colspan="4"><span></span><input name="option_9" value="${doc.option_9 }" style="width:360px;"/></td>
      <td><span>电话</span></td>
      <td colspan="2"><span></span><input name="option_10" value="${doc.option_10 }" style="width:180px;"/></td>
    </tr>
    
    <tr style="height:120px;">
      <td><span>立案事由</span></td>
      <td colspan="8">
      	<textarea id="option_11_ta" style="width:780px;height:110px;"></textarea>
		<input type="hidden" id="option_11" name="option_11" value="${doc.option_11 }"/>
	  </td>
    </tr>
    
    <tr style="width:120px;">
      <td rowspan="3"><span>立案意见</span></td>
      <td colspan="8" style="padding-top:10px;">
      	<textarea id="option_14_ta" style="width:780px;height:110px;"></textarea>
		<input type="hidden" id="option_14" name="option_14" value="${doc.option_14 }"/>
      </td>
    </tr>
    <tr>
      <td colspan="4" style="padding-left:10px;text-align:left; border-top: hidden;border-bottom:hidden;">
      	经办人：<input id="option_16" name="option_16" value="${doc.option_16 }" style="width:100px;"/>
      </td>
      <td colspan="4" style="text-align:left; border-top: hidden;border-bottom:hidden;border-left:hidden;">
      	审批人：<input id="option_20" name="option_20" value="${doc.option_20 }" style="width:100px;"/>
	  </td>
    </tr>
    <tr>
      <td colspan="4" class="tableLine_10_2"><span class="tableLeft"><input id="option_17" name="option_17" value="${doc.option_17 }" style="width:80px;"/> 年     <input id="option_18" name="option_18" value="${doc.option_18 }" style="width:40px;"/>   月    <input id="option_19" name="option_19" value="${doc.option_19 }" style="width:40px;"/>  日</span></td>
      <td colspan="4"><span class="tableLeft"><input id="option_21" name="option_21" value="${doc.option_21 }" style="width:80px;"/> 年    <input id="option_22" name="option_22" value="${doc.option_22 }" style="width:40px;"/>    月   <input id="option_23" name="option_23" value="${doc.option_23 }" style="width:40px;"/>   日</span></td>
    </tr>
    
    <tr style="width:120px;">
      <td rowspan="3"><span>审核意见</span></td>
      <td colspan="8" style="padding-top:10px;">
      	<textarea id="option_24_ta" style="width:780px;height:110px;"></textarea>
		<input type="hidden" id="option_24" name="option_24" value="${doc.option_24 }"/>
      </td>
    </tr>
    <tr>
      <td colspan="4" style="padding-left:10px;text-align:left; border-top: hidden;border-bottom:hidden;">
      	经办人：<input id="option_26" name="option_26" value="${doc.option_26 }" style="width:100px;"/>
	  </td>
      <td colspan="4" style="text-align:left; border-top: hidden;border-bottom:hidden;border-left:hidden;">
      	审批人：<input id="option_80" name="option_30" value="${doc.option_30 }" style="width:100px;"/>
	  </td>
    </tr>
    <tr>
      <td colspan="4" class="tableLine_13_2"><span class="tableLeft"><input id="option_27" name="option_27" value="${doc.option_27 }" style="width:80px;"/> 年     <input id="option_28" name="option_28" value="${doc.option_28 }" style="width:40px;"/>   月   <input id="option_29" name="option_29" value="${doc.option_29 }" style="width:40px;"/>   日</span></td>
      <td colspan="4"><span class="tableLeft"><input id="option_31" name="option_31" value="${doc.option_31 }" style="width:80px;"/> 年    <input id="option_32" name="option_32" value="${doc.option_32 }" style="width:40px;"/>    月   <input id="option_33" name="option_33" value="${doc.option_33 }" style="width:40px;"/>   日</span></td>
    </tr>
    
    <tr style="width:120px;">
      <td rowspan="2"><span>立案审批</span></td>
      <td colspan="8" style="padding-top:10px;">
      	<textarea id="option_34_ta" style="width:780px;height:110px;"></textarea>
		<input type="hidden" id="option_34" name="option_34" value="${doc.option_34 }"/>
      </td>
    </tr>
    <tr style="width:120px;border-top:hidden;;border-left: hidden;">
    	<td colspan="4" style="padding-left:10px;text-align:left; border-top: hidden;;border-left: hidden;border-bottom:hidden;">
    	</td>
          <td colspan="4" style="padding-left:10px;text-align:left; border-top: hidden;;border-left: hidden;border-bottom:hidden;">
      	局领导：<input id="option_38" name="option_38" value="${doc.option_38 }" style="width:100px;"/>
    </td>
    </tr>
<%--     <tr>
      <td colspan="8" style="padding-left:10px;text-align:left; border-top: hidden;border-bottom:hidden;">
      	局领导：<input id="option_38" name="option_38" value="${doc.option_38 }" style="width:100px;"/>
	  </td>
    </tr> --%>
    <tr>
    <td style="border-top:hidden;"></td>
    <td colspan="4" style="border-top:hidden;text-align: left ;"></td>
      <td colspan="4" style="border-top:hidden;;border-left: hidden; text-align: left ;">
      	<input id="option_35" name="option_35" value="${doc.option_35 }" style="width:80px;"/> 年     <input id="option_36" name="option_36" value="${doc.option_36 }" style="width:40px;"/>   月   <input id="option_37" name="option_37" value="${doc.option_37 }" style="width:40px;"/>   日
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
<script type="text/javascript">
	if(location.href.indexOf('isSee=true')!=-1){
		document.getElementById('hideButton').style.display='none'
	}
</script>
</html>