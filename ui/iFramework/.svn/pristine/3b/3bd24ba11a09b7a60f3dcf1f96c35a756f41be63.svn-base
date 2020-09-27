<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
%>


<html locale="true">
<head>
    <title>开始活动</title>	
	<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
	<jsp:include page="/view/workflow/common/jsp/WFCommon.jsp" flush="true" />
	<script type="text/javascript">
    function trim(str){ 
 		return str.replace(/\s/g, "");    
	} 
 	function submit_onclick(){
	 	if(trim(document.startNodeForm.actName.value)==""){
			document.startNodeForm.actName.focus();
		 	alert("名称不可以为空");
		 	document.startNodeForm.actName.value="";
			return false;
		}
	 	var processId  = "${param.processId}";
		var processVersion = "${param.processVersion}";
		var actId = jQuery("#actId").val();
	  	var actName = jQuery("#actName").val();
	  	var actDesc = jQuery("#actDesc").val();
	  	var extendProp = jQuery("#extendProp").val();
		//保存对自动活动的修改
		var sURL1 = webpath + "/WfStartActivity.do?method=update";
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
			success : function() {
				window.close();
			},
			error : function(){
			}
		});
		window.close();
	}   
	function editExtendProp(){
		var compId = "extendProp";
		WFCommon.editExtendProperty(compId,compId);
	}
	</script>
</head>
<body class="popUp-body"><br>
  <form action=""  name="startNodeForm">
   <div class="w550 main_label_outline">
		  	<table class="main_label_table" cellpadding="0" cellspacing="0">
		  		<tr style="display:none;">
					<td class="popUp-name">
						ID:
					</td>
					<td>
						<input class="w400 popUp-notEdit" type="text" id="actId" name="actId" readonly style="width:400px;"
							styleClass="input_underline"  value='${startAct.actId }'>
					</td>
				</tr>
				<tr>
					<td class="popUp-name">
					<font style="color:red"> * </font>名称：
					</td>
					
					<td>
					<input class="w359 popUp-edit" type="text" id="actName" name="actName" styleClass="input_underline" value="${startAct.actName }" />
					
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
						<textarea class="w400 popUp-describe"  id="actDesc" name="actDesc" rows="5" styleClass="input_text"  >${startAct.actDesc }</textarea>	
					</td>
				</tr>
			</table>
			<table class="main_label_table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="popUp-name">
						扩展属性：
					</td>
					<td >
						<input class="w359 popUp-edit fl" type="text" readonly="true" id="extendProp" name="extendProp" 
							value='${startAct.extendProp }'/>
						<a class="popUp-select" href="#" onclick="editExtendProp()">设置</a>
					</td>
				</tr>
			</table>
	</div>	
		<table class="w570 popUp-buttonBox" cellpadding="0" cellspacing="0">
			<tr>
				<td>				
				<input type="button"  class="popUp-button button_normal" onclick="window.close()"  value='取消'/>
				<input type="button" id="sub"  class="popUp-button button_normal" onclick="submit_onclick()" value='提交'/>
				</td>
			</tr>
		</table>
  <input type="hidden" id="id" value=''/>
  <input type="hidden" id="xmlStr"  value=''/>
  </form>
  </body>
</html>