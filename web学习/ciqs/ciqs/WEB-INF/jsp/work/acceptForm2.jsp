<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<script type="text/javascript" src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
</head>
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
<body>
	<div id="content">
	<form action="${ctx}/work/submitDoc" method="post">
	<input type ="hidden" name="ProcMainId" value="${license_dno}" />
	<input type ="hidden" name="docId" value="${doc.docId}" />
	<input type ="hidden" name="option92" id="option92" value="${doc.option92}" />
	<input type ="hidden" name="DocType" value="D_ACC_FORM" />
	<input type ="hidden" id="doc" value='${jsonStr}'/>
	
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">质量监督检验检疫 <br>
            行政许可申请材料接收清单 </p></td>
        </tr>
    </table>
    <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
        <td width="20%" height="42" align="center" class="tableLine"><p >受理单号</p></td>
        <td width="80%" colspan="3" class="tableLine" align="center">
        	（<input type="text" style="width:50px;border: none;outline: none" name="option1" value="${doc.option1}" />）质检
        	（<input type="text" style="width:50px;border: none;outline: none" name="option2" value="${doc.option2}" />）许受字
        	〔<input type="text" style="width:50px;border: none;outline: none" name="option3" value="${doc.option3}" />〕<input type="text" style="width:50px;border: none;outline: none" name="option60" value="${doc.option60}" />号</td>
      </tr>
      
      <tr>
        <td height="38" width="20%" align="center" class="tableLine">申请人</td>
        <td width="30%" height="38" align="center" class="tableLine">
<!--         <input type="hidden" name="option4" value="${doc.option4}" /> -->
        <input type="hidden" name="option4" value="${obj.comp_name}" />${obj.comp_name}
        </td>
        <td width="20%" height="38" align="center" class="tableLine">申请事项</td>
        <td width="30%" height="38" align="center" class="tableLine"><input type="text" style="width:150px;border: none;outline: none" name="option5" value="国境口岸卫生许可证核发" /></td>
      </tr>
      <tr>
        <td height="50%" colspan="2" align="center" class="tableLine"><p >（境内申请人）身份证号或者统一社会信用代码/营业执照编号</p></td>
        <td height="50%" colspan="2" align="center" class="tableLine">
        <input type="text" style="width:400px;border: none;outline: none" name="option6" value="${doc.option6}" />
        </td>
      </tr>
      <tr>
        <td width="20%" align="center" class="tableLine"><p >联系人</p></td>
        <td width="30%" height="38" align="center" class="tableLine">
        <input type="hidden" name="option7" value="${obj.contacts_name}" />${obj.contacts_name}
        
        </td>
        <td width="20%" height="38" align="center" class="tableLine">联系电话</td>
        <td width="30%" height="38" align="center" class="tableLine"><input type="hidden" name="option8" value="${obj.contacts_phone}" />${obj.contacts_phone}</td>
      </tr>
      </table>
      <table width="700" id="table_li" border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"  class="tableLine">
      <tr>
        <td height="38" colspan="4" align="center" class="tableLine"><p >申    请    材    料</p></td>
      </tr>
      <tr>
        <td width="10%" align="center" class="tableLine"><p >序号</p></td>
        <td width="60%" align="center" class="tableLine"><p >材    料    名    称</p></td>
        <td width="15%" align="center" class="tableLine"><p >页数</p></td>
        <td width="15%" align="center" class="tableLine"><p >份数</p></td>
      </tr>
      <tr>
        <td width="10%"  align="center" class="tableLine">1</td>
        <td width="60%" align="center" class="tableLine"><input type="text" style="width:400px;border: none;outline: none" name="option14" value="${doc.option14}" /></td>
        <td width="15%" align="center" class="tableLine"><input type="text" style="width:40px;border: none;outline: none" name="option15" value="${doc.option15}" /></td>
        <td width="15%" align="center" class="tableLine"><input type="text" style="width:40px;border: none;outline: none" name="option16" value="${doc.option16}" /></td>
      </tr>
      <tr>
        <td width="10%" align="center" class="tableLine">2</td>
        <td width="60%" align="center" class="tableLine"><input type="text" style="width:400px;border: none;outline: none;display: none;" name="option17" value="${doc.option17}" /><input type="button" id='remo' onclick="btn(this);" value="添加" /></td>
        <td width="15%" align="center" class="tableLine"><input type="text" style="width:40px;border: none;outline: none;display: none;" name="option18" value="${doc.option18}" /></td>
        <td width="15%" align="center" class="tableLine"><input type="text" style="width:40px;border: none;outline: none;display: none;" name="option19" value="${doc.option19}" /></td>
      </tr>
      
      </table>
      <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
        <td height="60%" style="border-bottom: 1" width="25%" align="center" class="tableLine">申请经办人签字</td>
        <td height="60%" style="border-bottom: 1" width="25%" align="center" class="tableLine"><input type="text" style="width:40px;border: none;outline: none" name="option9" value="${obj.contacts_name}"  <c:if test="${doc.docId != null}"> value="${doc.option9}"</c:if><c:if test="${doc.docId == null}"> value="${obj.contacts_name}"</c:if> /></td>
        <td height="60%" style="border-bottom: 1" width="25%" align="center" class="tableLine">收件人员签名</td>
        <td height="60%" style="border-bottom: 1" width="25%" align="center" class="tableLine"><input type="text" style="width:40px;border: none;outline: none" name="option10" value="${obj.approval_user}" /></td>
      </tr>
      <tr height="50px">
        <td colspan="2" style="border: 0" align="right" class="tableLine"></td>
        <td colspan="2" style="border: 0;text-align: right;"  class="tableLine"><p > </p>
	        <input type="text" style="width:40px;border: none;outline: none" name="option11" value="${doc.option11}" />年
	      	<input type="text" style="width:40px;border: none;outline: none" name="option12" value="${doc.option12}" />月
	        <input type="text" style="width:40px;border: none;outline: none" name="option13" value="${doc.option13}" />日
        </td>
      </tr>
      </table>
    
    

    <div style="text-align: center;margin-top:20px;" class="noprint">
        <span> 
        	<input type="submit" value="提交" class="btn"  />
<!-- 			<input onClick="javascript:history.back();" type="button" class="btn" value="返回" /> -->
            <input type="button" value="打印" id="print" class="btn" onClick="dayin()" />
      </span>
    </div>
    </form>
</div>
</body>
<script language="javascript" type="text/javascript">

	var i=1;
 	var length=$("#option92").val();
 	if(length){
	 	for(var a=0;a<length;a++){
	 		$("#remo").click();
	 	}
 	}
 	
	function dayin() {
		window.print();
	}
	function btn(e){
		var index=$(e).prev()[0].getAttribute('name').replace("option","");
		$(e).parent().parent().children().find('input').css("display","block");
		if(index>=87){
		return alert("超过最多添加");
		}
		document.getElementById("remo").remove();
		var s = 2+ i++;
		$("#option92").val(s-2);
		index = 3+index++;
		var input = "<input type='text' style='width:400px; border: none; outline: none;display: none;'   name='option"+index+"' />";
		var td = "<tr>";
			td += "<td class='tableLine' align='center'>"+s+"</td>";
			td += "<td class='tableLine' align='center' >"+input+"<input type='button' id='remo' onclick='btn(this)' value='添加' /></td>";
			index+=1;
			input = "<input type='text' style='width:40px; border: none; outline: none;display: none;' name='option"+index+"' />";
			td += "<td class='tableLine' align='center'>"+input+"</td>";
			index+=1;
			input = "<input type='text' style='width:40px; border: none; outline: none;display: none;' name='option"+index+"' />";
			td += "<td class='tableLine' align='center'>"+input+"</td>";
	        td += "</tr>";
	    $("#table_li").append(td);
	}
	
	jQuery(document).ready(function(){
			var doc=$("#doc").val();
			doc=eval("("+doc+")");
			for(var item in doc){
				$("input[name='"+item+"']").val(doc[item]);
			}
		});
	
</script>
