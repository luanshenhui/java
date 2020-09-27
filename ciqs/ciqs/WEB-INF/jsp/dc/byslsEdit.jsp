<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生许可证</title>
<%@ include file="/common/resource_new.jsp"%>
<script language="javascript" type="text/javascript">

	function winShow(no,type){
	 	window.open("<%=request.getContextPath()%>/dc/toPrintXzSljds?proc_main_id="
	 	+no+"&doc_type="+type);
    }

</script>
</head>
<body>
<form action="/ciqs/dc/submitDoc"  method="post">
<input type ="hidden" id="declare_date" value="${declare_date}" />
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_BY_GZ" />
<input type ="hidden" name="DocId" value="${doc.doc_id}" />
		<div id="content">
	    <table width="740" align="center">
	        <tr>
	            <td width="721" align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">行政许可不予受理决定书 </p></td>
	        </tr>
	        <tr>
	          <td align="right" style="font-size:18px; font-family:'楷体_GB2312';"><p align="center">（${doc.option_1}）<span style="text-decoration:line-through;">质</span>检（${doc.option_2}）许不受字〔${doc.option_3}〕 ${doc.option_60}   号</p></td>
	      </tr>
	        <tr>
	          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';padding-left:20px">${doc.option_4}</td>
	      </tr>
	      <tr>
	          <td style="font-size:18px;padding:20px">
	          	<span style="margin-left:30px">你（单位）于<!-- <span id="yer"></span> -->
	          	${doc.option_11}年
	          	${doc.option_12}月
	          	${doc.option_13}日
	          	向本局提出${doc.option_5}行政许可申请。</span><br>
	            <span style="margin-left:30px">申请事项依法不需要取得行政许可，依照《中华人民共和国行政许可法》第三十二条第一款第一项的规定，本局决定不予受理。</span><br>
	            <span style="margin-left:30px">申请事项依法不属于本行政机关职权范围，依照《中华人民共和国行政许可法》第三十二条第一款第二项的规定，本局决定不予受理，请您向有关行政机关申请。 </span><br>
	            <span style="margin-left:30px">如对本决定不服，可以自收到本决定之日起六十日内向${doc.option_6}局或${doc.option_7}人民政府申请行政复议，或自收到本决定之日起六个月内向${doc.option_8}人民法院提起行政诉讼。 </span><br>
	            <span>特此通知。</span>
	          </td>
	      </tr>
	        <tr>
	          <td align="center" style="font-size:18px; font-family:'楷体_GB2312';"><p>&nbsp;</p>
	<p>&nbsp;</p>
	          <p>&nbsp;</p>
	          <blockquote>
	            <p style="padding-left:310px">（行政许可专用印章） </p>
	          </blockquote>
	          <p style="padding-left:310px">${doc.option_9}年${doc.option_14}月${doc.option_15}日</p>
	          <p style="padding-left:310px">&nbsp;</p>
	          <p></p>
	          <p>本文书一式两份。一份送达申请人，一份质检部门存档。 </p></td>
	      </tr>
	    </table>
	    
	    <div style="text-align: center;" class="noprint">
	        <span> 
		        <input type="submit" class="btn" value="打印" onclick="javascript:window.print()" />
	        </span>
	    </div>
</div>
</form>
</body>
</html>
