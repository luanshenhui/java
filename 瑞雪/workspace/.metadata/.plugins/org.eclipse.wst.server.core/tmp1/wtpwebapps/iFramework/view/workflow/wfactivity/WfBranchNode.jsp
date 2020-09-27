<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>
<html>
<head>
    <title>分支活动</title>	
	<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
	<script type="text/javascript">
	
    function trim(str){ 
 		return str.replace(/\s/g, "");    
	} 
    function editExtendProp(){
    	var compId = "extendProp";
    	WFCommon.editExtendProperty(compId,compId);
    }
  	function submit_onclick(){
		 if(trim(document.branchForm.actName.value)==""){
				document.branchForm.actName.focus();
			 	alert("名称不可以为空");
			 	document.branchForm.actName.value="";
				return false;
			}
		 	var processId  = "${param.processId}";
			var processVersion = "${param.processVersion}";
			 var actId = jQuery("#actId").val();
		  	var actName = jQuery("#actName").val();
		  	var actDesc = jQuery("#actDesc").val();
		  	var extendProp = jQuery("#extendProp").val();
			//保存对自动活动的修改
			var sURL1 = webpath + "/WfSplitActivity.do?method=update";
			jQuery.ajax( {
				url : sURL1,
				async : false,
				type : "post",
				dataType : "text",
				data : {
					procId:processId,
					procVersion:processVersion,
					actId : actId,
					actName : actName,
					actDesc : actDesc,
					extendProp : extendProp
				},
				success : function(data) {
					window.opener.updateActivity(actId,actName);
					window.close();
				},
				error : function(){
				}
			});
			window.close();
			}
  	</script>
</head>

<body class="popUp-body"><br>
  <form action="" name="branchForm">
     <div class="main_label_outline" style="width:570px">
	  	<table style="width:550px" class="main_label_table" cellpadding="0" cellspacing="0">
	  		<tr style="display:none;">
				<td class="popUp-name">
					ID:
				</td>
				<td>
					<input class="w400 popUp-edit" type="text" id="actId" name="actId" readonly="true" 
						styleClass="input_underline"  value='${splitAct.actId }'>
				</td>
			</tr>
			<tr>
				<td class="popUp-name">
				<font color="#ff0000">*</font>名称：
				</td>
				<td>
					<input class="w359 popUp-edit" type="text" id="actName" name="actName" styleClass="input_underline" value="${splitAct.actName }" />
				</td>
				<td valign="bottom">
					<a class="popUp-select" href="#" onclick="WFCommon.CopyContent2Clipboard('actId')">复制ID</a>
				</td>
			</tr>
			<tr>
				<td valign="top" class="popUp-name">
				描述：
				</td>
				<td>
					<textarea  class="w400 popUp-describe" id="actDesc"  name="actDesc" rows="5" styleClass="input_text" >${splitAct.actDesc }</textarea>	
				</td>
			</tr>
		</table>
		<table style="width: 550px" class="main_label_table " cellpadding="0" cellspacing="0">
			<tr>
				<td class="popUp-name">
				扩展属性：
				</td>
				<td >
					<input class="w359 popUp-edit fl" type="text" readonly="true" id="extendProp" name="extendProp" 
							value='${splitAct.extendProp }'/>
						<a class="popUp-select" href="#" onclick="editExtendProp()">设置</a>
				</td>
			</tr>
		</table>
	</div>	
	<table class="w590 popUp-buttonBox" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width:570px" align="right">
			<input class="popUp-button" type="button" value='取消'  onclick="window.close()"/>
			<input class="popUp-button" type="button" id="sub" value='提交' onclick="submit_onclick()"/>
			</td>
		</tr>
	</table>
  </form>
  </body>
</html>