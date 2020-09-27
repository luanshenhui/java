<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript">
$(function(){
		if($("#ok").val()=="ok"){
	        alert("提交成功!");
	    	window.close();
	    }
  	   var date = new Date();
	   var year = date.getFullYear();
	   var month = date.getMonth()+1;
	   if(month<10){
	   	month = "0"+month;
	   }
	   var day = date.getDate();
	   if(day<10){
	   	day = "0"+day;
	   }
	   if($("#o9").val()==""){
	   		$("#o9").val(year);
	   }
	   if($("#o14").val()==""){
	   		$("#o14").val(month);
	   }
	   if($("#o15").val()==""){
	   		$("#o15").val(day);
	   }
	   
});
</script>
<style type="text/css">
input[type="text"]{
    border: 0px; 
    outline: none;
    text-align: center;
    border-bottom: 1px solid #000;
}
</style>
</head>

<body>
<form action="/ciqs/xk/submitslDoc"  method="post">
<input type ="hidden" id="ok" value="${ok}" />
<input type ="hidden" id="declare_date" value="${declare_date}" />
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_BY_GZ" />
<input type ="hidden" id="docId" name="DocId" value="${doc.docId}" />
		<div id="content">
	    <table width="860" align="center">
	        <tr>
	            <td width="721" align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">行政许可不予受理决定书 </p></td>
	        </tr>
	        <tr>
	          <td align="right" style="font-size:18px; font-family:'楷体_GB2312';"><p align="center">（<input type="text" value="${doc.option1}" name="Option1" style="width:50px;border-bottom:0px"/>）<span style="text-decoration:line-through;">质</span>检（<input type="text" value="${doc.option2}" name="Option2" style="width:30px;border-bottom:0px"/>）许不受字〔<input type="text" value="${doc.option3}" name="Option3" style="width:70px;border-bottom:0px"/>〕  <input type="text" value="${doc.option60}" style="width:120px;border-bottom:0px" name="Option60"/>  号</p></td>
	      </tr>
	        <tr>
	          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';padding-left:20px"><input type="text" value="${doc.option4}" name="Option4"/>:</td>
	      </tr>
	      <tr>
	          <td style="font-size:18px;padding:20px">
	          	<p style="margin-left:30px">你（单位）于<!-- <span id="yer"></span> -->
	          	<input type="text" value="${doc.option11}" style="width:60px" name="Option11"/>年
	          	<input type="text" value="${doc.option12}" style="width:30px" name="Option12"/>月
	          	<input type="text" value="${doc.option13}" style="width:30px" name="Option13"/>日
	          	向本局提出<input type="text" value="${doc.option5}" name="Option5"/>行政许可申请。经审查，</p>
	            <p>申请事项依法不需要取得行政许可，依照《中华人民共和国行政许可法》第三十二条第一款第一项的</p> <p style="text-align:left;margin-left:15px">规定，本局决定不予受理。</p>
	            <p style="margin-left:33px">申请事项依法不属于本行政机关职权范围，依照《中华人民共和国行政许可法》第三十二条第一款</p><p style="text-align:left;margin-left:15px">第二项的规定，本局决定不予受理，请您向有关行政机关申请。 </p>
	            <p style="text-align:left;margin-left:39px">如对本决定不服，可以自收到本决定之日起六十日内向<input type="text" value="${doc.option6}" name="Option6"/>局或<input type="text" value="${doc.option7}" name="Option7"/>人民政府申请行政复议，或自收到本决定之日起六个月内向<input type="text" value="${doc.option8}" name="Option8"/>人民法院提起行政诉讼。 </p>
	            <p style="text-align:left;margin-left:60px">特此通知。</p>
	            <p style="text-align:left;padding-left:40px">（行政许可专用印章） </p>
	          </td>
	      </tr>
	        <tr>
	          <td align="center" style="font-size:18px; font-family:'楷体_GB2312';"><p>&nbsp;</p>
	
	          <p style="padding-left:310px">
	          	<input id="o9" type="text" style="width:50px" value="${doc.option9}" name="Option9"/>年<input id="o14" style="width:50px" type="text" value="${doc.option14}" name="Option14"/>月 <input id="o15" type="text" style="width:50px" value="${doc.option15}" name="Option15"/>日
	          </p>
	          <p style="padding-left:310px">&nbsp;</p>
	          <p></p>
	          <p>本文书一式两份。一份送达申请人，一份质检部门存档。 </p></td>
	      </tr>
	    </table>
	    
	    
	
	    <div style="text-align: center;" class="noprint">
	        <span> 
	        <!-- <input onclick="javascript:history.back();" type="button" class="btn" value="返回" /> -->
	             <input type="submit" id="submit" value="提交"  />
	      </span>
	    </div>
</div>
</form>
</body>
</html>