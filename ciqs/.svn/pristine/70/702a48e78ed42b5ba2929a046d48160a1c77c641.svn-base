<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>材料补正告知书</title>
<%@ include file="/common/resource.jsp"%>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<style type="text/css">
input[type="text"]{
    border: 0px;
    outline: none;
    text-align: center; 
    border-bottom: 1px solid #000;
}

</style>
</head>
<script language="javascript" type="text/javascript">
	function dayin() {
		window.print();
	}
	
	$(function(){
	   if($("#ok").val()=="ok"){
	      alert("提交成功!");
	      window.close();
	   }
	    /* if($("#docId").val()!=""){
	    	$("#submit").hide();
	    } */
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
	   if($("#o17").val()==""){
	   		$("#o17").val(year);
	   }
	   if($("#o18").val()==""){
	   		$("#o18").val(month);
	   }
	   if($("#o19").val()==""){
	   		$("#o19").val(day);
	   }
       if($("#sq_status").val() =="new"){ 
    	   $("input[type='text']").val("");
       }

	});
	
</script>

<body>
<form id="docform" action="/ciqs/xk/submitslDoc"  method="post">
<input type ="hidden" id="ok" value="${ok}" />
<input type ="hidden" id="declare_date" value="${declare_date}" />
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_SQ_BZ" />
<input type ="hidden" id="docId" name="DocId" value="${doc.docId}" />
<input type ="hidden" id="sq_status" value="${sq_status}" />
	<div id="content">
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">行政许可申请材料补正告知书 </p></td>
        </tr>
        <tr>
          <td align="right" style="font-size:18px; font-family:'楷体_GB2312';"><p align="center">（<input type="text" value="${doc.option1}" style="width:80px;border-bottom:0px" name="Option1"/>）<span style="text-decoration:line-through;">质</span>检（<input type="text" style="width:80px;border-bottom:0px" value="${doc.option2}" name="Option2"/>）许补字〔<input type="text" style="width:80px;border-bottom:0px" value="${doc.option3}" name="Option3"/>〕  <input type="text" value="${doc.option60}" style="width:120px;border-bottom:0px" name="Option60"/>  号 </p></td>
      </tr>
        <tr>
          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';"><input type="text" name="Option4" value="${doc.option4}" value="${comp_name}" style="text-align:left"/>:</td>
      </tr>
        <tr>
          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';">
          <span style="margin-left:30px">你（单位）于
          <input type="text" style="width:50px" value="${doc.option5}" name="Option5"/>年<input type="text" style="width:50px" value="${doc.option20}" name="Option20"/>月<input type="text" style="width:50px" value="${doc.option21}" name="Option21"/>日
          提交的<input type="text" value="${doc.option6}" name="Option6" style="text-align:left"/>行政许<br />可申请材料收悉。</span>
          依照《中华人民共和国行政许可法》第三十二条第一款第四项和<input type="text" style="text-align:left" value="${doc.option7}" name="Option7"/>规定，经审查，需补正以下材料： </td>
      </tr>
        <tr>
          <td align="center" style="font-size:18px; font-family:'楷体_GB2312';">
            <p>1、 <input type="text" value="${doc.option8}" name="Option8" style="width:666px;text-align:left"/></p>
            <p>2、 <input type="text" value="${doc.option9}" name="Option9" style="width:666px;text-align:left"/></p>
            <p>3、 <input type="text" value="${doc.option10}" name="Option10" style="width:666px;text-align:left"/></p>
            <p>4、 <input type="text" value="${doc.option11}" name="Option11" style="width:666px;text-align:left"/></p>
            <p>5、 <input type="text" value="${doc.option12}" name="Option12" style="width:666px;text-align:left"/></p>
            <p>6、 <input type="text" value="${doc.option13}" name="Option13" style="width:666px;text-align:left"/></p>
            <p>7、 <input type="text" value="${doc.option14}" name="Option14" style="width:666px;text-align:left"/></p>
            <p>8、 <input type="text" value="${doc.option15}" name="Option15" style="width:666px;text-align:left"/></p>
          	<p>9、 <input type="text" value="${doc.option16}" name="Option16" style="width:666px;text-align:left"/></p>
          	</td>
        </tr>
        <tr>
          <td align="center" style="font-size:18px; font-family:'楷体_GB2312';">
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <blockquote>
            <p style="padding-left:310px">（行政许可专用印章） </p>
          </blockquote>
          <p style="padding-left:310px">
          	<input type="text" id="o17" style="width:50px" value="${doc.option17}" name="Option17"/>年<input type="text" id="o18" style="width:50px" value="${doc.option18}" name="Option18"/>月<input type="text" style="width:50px" id="o19" value="${doc.option19}" name="Option19"/>日
          </p>
          <p style="padding-left:310px">&nbsp;</p>
          <p></p>
          <p>本文书一式两份。一份送达申请人，一份质检部门存档。 </p></td>
      </tr>
    </table>
    
    

    <div style="text-align: center;" class="noprint">
      <span> 
        <!-- <input onclick="javascript:history.back();" type="button" class="btn" value="返回" /> -->
        <input type="submit" id="submit" value="提交"  class="btn"/>
      </span>
    </div>
</div>
</form>
</body>
</html>