<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%   
   String declare_date = request.getParameter("declare_date"); 
%>
<link rel="stylesheet" type="text/css" media="all" href="<c:url value='/scripts/autocomplete/autocomplete.css'/>" />
<script type="text/javascript" src="<c:url value='/scripts/validate/jquery.validate.js'/>"></script>
<script type="text/javascript" src="<c:url value='/scripts/validate/jquery.validate.mypack.js'/>"></script>
<script type="text/javascript" src="<c:url value='/scripts/validate/additional-methods.js'/>"></script>
<script type="text/javascript" src="<c:url value='/scripts/validate/messages_cn.js'/>"></script>
<script type="text/javascript" src="<c:url value='/scripts/autocomplete/autocomplete.js'/>"></script>
<script type="text/javascript" src = "<c:url value = '/scripts/mc/mcdecrecord.js'/>"></script>
<script type="text/javascript">
  var declare_date = "<%=declare_date%>"
document.body.onload=function onloads(){
   setDiv(11);
   var date = new Date(declare_date);
   var datetext = date.getFullYear() +"年"+ date.getMonth() +"月"+ date.getDate() +"日";
   $("#yer").text(datetext);

};
</script>



		<div id="content">
	    <table width="729" align="center">
	        <tr>
	            <td width="721" align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">行政许可不予受理决定书 </p></td>
	        </tr>
	        <tr>
	          <td align="right" style="font-size:18px; font-family:'楷体_GB2312';"><p align="center">（ &nbsp; &nbsp;&nbsp; ）<span style="text-decoration:line-through;">质</span>检（ &nbsp;&nbsp; &nbsp;    ）许不受字〔       〕    号</p></td>
	      </tr>
	        <tr>
	          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';padding-left:20px">___________________:</td>
	      </tr>
	        <tr>
	          <td style="font-size:18px;padding:20px">
	          	<span style="margin-left:30px">你（单位）于<span id="yer"></span>向本局提出_____________________行政许可申请。</span><br>
	            <span style="margin-left:30px">申请事项依法不需要取得行政许可，依照《中华人民共和国行政许可法》第三十二条第一款第一项的规定，本局决定不予受理。</span><br>
	            <span style="margin-left:30px">申请事项依法不属于本行政机关职权范围，依照《中华人民共和国行政许可法》第三十二条第一款第二项的规定，本局决定不予受理，请您向有关行政机关申请。 </span><br>
	            <span style="margin-left:30px">如对本决定不服，可以自收到本决定之日起六十日内向_________________局或_________________人民政府申请行政复议，或自收到本决定之日起六个月内向_________________人民法院提起行政诉讼。 </span><br>
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
	          <p style="padding-left:310px">年    月   日</p>
	          <p style="padding-left:310px">&nbsp;</p>
	          <p>__________________________________________________________________________</p>
	          <p>本文书一式两份。一份送达申请人，一份质检部门存档。 </p></td>
	      </tr>
	    </table>
	    
	    
	
	    <div style="text-align: center;" class="noprint">
	        <span> 
	        <input onClick="javascript:history.back();" type="button" class="btn" value="返回" />
	            <input type="button" value="打印" id="print" class="btn" onClick="javascript:window.print()" />
	      </span>
	    </div>
</div>

