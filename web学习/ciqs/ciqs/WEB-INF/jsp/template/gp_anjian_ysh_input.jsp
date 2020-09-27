<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>案件移送函</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 
$(function(){
		if($("#operation").val() == "close"){
			alert("保存成功！请点击确定关闭页面");
			window.close();
		}else{
			$("#option_11_ta").val($("#option_11").val());
		}
		
		//根据二级步骤（角色）限制编辑区域
		var subStep = $("#subStep").val();
		if(subStep == '0'){
			$("input, textarea").each(function(e){
				$(this).attr("readonly", "readonly");
			});
		}
	});
	
	function submitForm(){
		$("#option_11").val($("#option_11_ta").val());
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
    border: 0px solid #000;
}
input{
	border: 0px;
	height:30px;
	text-align: center;
}
textarea{
	border:0px;
}

</style>
</head>
<body>
   <div id="content">
   	 <input type="hidden" id="subStep" value="${subStep }"/>
   	 <input type="hidden" id="operation" value="${operation }"/>
   	 <form id="form" action="/ciqs/generalPunishment/updateDoc" method="post">
   	  <input type="hidden" name="id" value="${id }"/>
      <input type="hidden" name="step" value="${step }"/>
      <input type="hidden" name="page" value="gp_anjian_ysh_input"/>
        <input type="hidden" name ="pre_report_no" value="${gpDTO.pre_report_no}"/>
   	  <input type="hidden" name="doc_id" value="${doc.doc_id }"/>
   	  <input type="hidden" name="doc_type" value="${doc.doc_type }"/>
   	  <input type="hidden" name="proc_main_id" value="${doc.proc_main_id }"/>
      <table>
        <tr >
            <td style="font-size:25px;font-weight: bold;width:700px;text-align:certer;"><h1>案件移送函</h1></td>
        </tr>
        <tr></tr>
        <tr>
            <td style="text-align:right;">（<input name="option_1" value="${doc.option_1 }" style="width:100px;"/>）检移【<input name="option_2" value="${doc.option_2 }" style="width:100px;"/><span>】号</span></td>
        </tr>
        <tr>
            <td style="text-align:left;"><div style="border-bottom:1px solid #000;display:inline;zoom:1;float:left;min-width:200px; text-align: center;"><input name="option_3" value="${doc.option_3 }" style="width:180px;"/><span style="float:right;">:</span></div></td>
        </tr>
        <tr>
            <td style="width:700px;text-align:left;">
                <span  style="line-height: 33px;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;关于我局查办的一案，因（不属于我局管辖），根据《出入境检验检疫行政处罚程序规定》第九条（第十二条）的规定，现移送你们处理。移送材料共 <input name="option_4" value="${doc.option_4 }" style="width:60px;"/>  份<input name="option_5" value="${doc.option_5 }" style="width:60px;"/>页及目录如下，请查收。
                </span>
            </td>
        </tr>
        <tr>
            <td style="width:700px;text-align:center;">
            	<textarea id="option_11_ta" style="width:650px;height:250px;"></textarea>
		      	<input type="hidden" id="option_11" name="option_11" value="${doc.option_11 }"/>
            </td>
        </tr>
        <tr>
            <td style="width:700px;text-align:left;"><span>联系人：</span><input name="option_6" value="${doc.option_6 }" style="width:100px;"/></td>
        </tr>
        <tr>
            <td style="width:700px;text-align:left;"><span>电&nbsp;&nbsp;&nbsp; 话：</span><input name="option_7" value="${doc.option_7 }" style="width:100px;"/></td>
        </tr>
         <tr>
            <td style="width:700px;text-align:left;"><span>&nbsp;&nbsp;&nbsp;</span></td>
        </tr>
         <tr>
            <td style="width:700px;text-align:left;"><span>&nbsp;&nbsp;&nbsp;</span></td>
        </tr>
         <tr>
            <td style="width:700px;text-align:left;"><span>&nbsp;&nbsp;&nbsp;</span></td>
        </tr>
        <tr>
            <td style="width:700px;text-align:right;"><span><input name="option_8" value="${doc.option_8 }" style="width:100px;"/>&nbsp;年&nbsp;<input name="option_9" value="${doc.option_9 }" style="width:100px;"/>&nbsp;月&nbsp;<input name="option_10" value="${doc.option_10 }" style="width:100px;"/>&nbsp;日</span></td>
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