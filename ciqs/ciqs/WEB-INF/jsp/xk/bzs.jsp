<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>组织管理</title>
<%@ include file="/common/resource.jsp"%>
<script language="javascript" type="text/javascript">
	function dayin() {
		window.print();
	}

	$(function(){
	   var date = new Date();
       var datetext = date.getFullYear() +"年"+ (date.getMonth()+1) +"月"+ date.getDate() +"日";
       
       if($("#option_1").val() ==""){
	   	 $("#option_1").val($("#comp_name").val());
	   }
       if($("#option_6").val() ==""){
	   	 $("#option_6").val("电子送达");
	   }
	   if($("#option_7").val() ==""){
	   	 $("#option_7").val(datetext);
	   }
	   if($("#option_9").val() ==""){
	   	$("#option_9").val($("#username").val());
	   }
	});

</script>

<style type="text/css">
<!--
.tableLine {
	border: 1px solid #000;
}
.fangxingLine {
	font-size:10;
	margin-left:5px;
	margin-right:5px;
	border: 2px solid #000;
	font-weight:900;
	padding-left: 3px;
	padding-right: 3px;
}
.tableLine2 {
	border: 1px solid #000;
	padding-left: 10px; 
}
.tableLine_noright {
	padding-left: 10px;
	border-top-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
}
.tableLine_noleft {
	padding-left: 10px;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-top-color: #000;
	border-right-color: #000;
	border-bottom-color: #000;
}
@media print {
.noprint{display:none}
}
-->
</style>
</head>
<body>
<form action="/ciqs/dc/submitDoc"  method="post">
<input type ="hidden" id="mailbox_text" value="${mailbox}" />
<input type ="hidden" id="declare_date_text" value="${declare_date}" />
<input type ="hidden" id="approval_users_name_text" value="${approval_users_name}" />
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_SDHZ" />
<input type ="hidden" id="username" value="${username}" />
<input type ="hidden" id="comp_name" value="${comp_name}" />
<input type ="hidden" name="DocId" value="${doc.doc_id}" />

	<div id="content">
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center"><strong>质量监督检验检疫 </strong></p>
            <strong>行政许可文书送达回证</strong></td>
        </tr>
    </table>
    <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr >
        <td height="42" align="center" class="tableLine">受送达人</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_1}</td>
      </tr>
      <tr>
        <td height="38" align="center" class="tableLine">送达文书名称</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_2}</td>
      </tr>
      <tr>
        <td height="38" align="center" class="tableLine">1</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_3}</td>
      </tr>
      <tr>
        <td height="39" align="center" class="tableLine">2</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_4}</td>
      </tr>
      <tr>
        <td height="38" align="center" class="tableLine">3</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_5}</td>
      </tr>
      <tr>
        <td height="42" align="center" class="tableLine">送达方式</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_6}</td>
      </tr>
      <tr>
        <td height="38" align="center" class="tableLine">送达日期</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_7}</td>
      </tr>
      <tr>
        <td height="41" align="center" class="tableLine">送达人员</td>
        <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_8}</td>
      </tr>
      <tr>
        <td width="122" height="119" align="center" class="tableLine">收件人签名 <br>或盖章 </td>
        <td width="576" class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_9}</td>
      </tr>
        <tr>
          <td height="104" align="center" class="tableLine"><p>备    注</p></td>
          <td class="tableLine" style="text-align:left;padding-left:15px;">${doc.option_10}</td>
        </tr>
    </table>
    
    <div style="text-align: center;margin-top:20px;" class="noprint">
        <span> 
            <input type="button" value="打印" id="print" class="btn" onclick="dayin()" />
      	</span>
    </div>
</div>
</form>
</body>
</html>
