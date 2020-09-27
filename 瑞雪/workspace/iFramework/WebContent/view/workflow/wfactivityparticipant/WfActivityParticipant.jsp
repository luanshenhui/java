<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ taglib uri="/WEB-INF/tlds/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参与人</title>
<link rel="stylesheet" href="<%=webpath%>/view/common/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="<%=webpath %>/view/workflow/wfactivityparticipant/WfActivityParticipant.js"></script>


	<script type="text/javascript">
	var processId = "${param.processId}";
	var processVersion = "${param.processVersion}";
	</script>
</head>
<body class="popUp-body" onload="AddValueToProcSelect()">
	<input type="hidden" value=<%=request.getParameter("flag") %> id=cType></input>
	<br>
<div class="main_label_outline fl" style="width:660px;">
	<div id ="container" >
		
	  <div class="zTreeDemoBackground left" width="50%" style="float:left">
	  	 
	  	<div class="popUp-treeTitle">
	  	 组织机构
	  	</div>
		<ul id="treeDemo" class="ztree popUp-treeBox popUp-edit"></ul>
	 </div>
  	<div id="content" class="x-layout-inactive-content"></div>
  	<div id="inner2" class="x-layout-inactive-content" style="padding-top:0px;padding-bottom:0px" >
		<table border="0"  cellspacing="0" cellpadding="0">
			<tr>
				<td class="popUp-treeTitle" align="left">待选列表</td>
				<td style="width:100px"></td>
				<td class="popUp-treeTitle" align="left">已选列表</td>
			</tr>
			<tr rowspan="9">
				<td>
					<SELECT  multiple="true" id="select1" class="fl h360 w150 popUp-edit selectFont">

					</SELECT>
				</td>
				<td align="center" style="vertical-align: middle;">
					<table>
					<tr><td ></td></tr>
					<tr>
					<td	style="padding-bottom:5px">
						<input type="button" class="popUp-button2"  value="添加" onclick="addSelect2Text('select1')" />
					</td>
					</tr>
					<tr><td></td></tr>
					<tr><td style="padding-bottom:5px">
						<input type="button" class="popUp-button2"  value="删除" onclick="removeSelect2Value('select2')"/>
					</td>
					</tr>
					<tr><td></td></tr>
					<tr><td style="padding-bottom:5px">
						<input type="button" class="popUp-button2" value="全部添加" onclick="addAll('select1')"/>
					</td>
					</tr>
					<tr><td></td></tr>
					<tr><td style="padding-bottom:5px">
						<input type="button" class="popUp-button2" value="全部删除" onclick="deleteAll('select2')"/>
					</td>
					</tr>
					<tr><td></td></tr>
					</table>
				</td>
				<td  rowspan="9" >
					<SELECT multiple="true" id="select2" class="fl h360 w150 popUp-edit selectFont" />
				</td>
			</tr>
			
		</table>
  	</div>
  </div>
</div>
<table class="w680  popUp-buttonBox" cellpadding="0" cellspacing="0">
	<tr>
		<td  style="height:30px" align="left">
		</td>
		<td colspan="2" style="height:30px;padding-top:5px" align="right">
			<input class="popUp-button" type="button" value="取消" onclick = "window.close()">
			<input class="popUp-button" type="button" value="提交" onclick = "commitProcessValue();window.close()"/>
			
		</td>
	</tr>
</table>
</body>
</html>