<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.workflow.model.define.Process"%>
<%@ page import="com.dhc.workflow.model.define.RelateData"%>
<%@ taglib uri="/WEB-INF/tlds/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tlds/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	List<RelateData> relatedataList = new ArrayList<RelateData>();
	try {
		//防跨站脚本编制
		//返回选择结果时，确定哪一列是要返回显示的。此参数必填！
		String displayColumnName = (String)request.getParameter("displayColumnName");
		String processId = (String)request.getParameter("processId");
		String processVersion =(String)request.getParameter("processVersion");
		//System.out.println(processId);
		//System.out.println(processVersion);
		Process process = (Process)request.getSession().getAttribute(processId + "," + processVersion);
		relatedataList = process.getRdataList();
		if (relatedataList == null)
			relatedataList = new ArrayList<RelateData>();
		//System.out.println(relatedataList.size());
	} catch (Exception ex) {
		ex.printStackTrace();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参与人</title>
<link rel="stylesheet" href="<%=webpath%>/view/common/css/demo.css" type="text/css">
<link rel="stylesheet" href="<%=webpath%>/view/common/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="<%=webpath %>/view/workflow/wfactivityparticipant/WfUnitOrgTree.js"></script>

	<script type="text/javascript">
		var processId = "${param.processId}";
		var processVersion = "${param.processVersion}";
		var actId = "${param.actId}";
	</script>
</head>
<body class="popUp-body" onload="AddValueToProcSelect()">
	<input type="hidden" value=<%=request.getParameter("flag") %> id="cType"></input>
	<br>
<div class="main_label_outline" style="width:660px;">
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td class="popUp-treeTitle"> 组织机构</td>
		<td class="popUp-treeTitle">待选列表</td>
		<td style="width:100px"></td>
		<td class="popUp-treeTitle">已选列表</td>
	</tr>
	<tr> 
		<td style="vertical-align: top">
			<ul id="treeDemo" class="h200 ztree popUp-treeBox popUp-edit"></ul>
		</td>
		<td>
			<SELECT  multiple="true" id="select1"  class="fl h212 w150 popUp-edit selectFont" >

			</SELECT>
		</td>
		<td  style="vertical-align: middle;">
			<table cellpadding="0" cellspacing="0">
					<tr>
						<td	style="padding-bottom:5px">
							<input type="button" class="popUp-button2"  value="添加" onclick="addSelect2Text('select1')" />
						</td>
					</tr>
					<tr>
						<td	style="padding-bottom:5px">
							<input type="button" class="popUp-button2"  value="删除" onclick="removeSelect2Value('select2')"/>
						</td>
					</tr>
					<tr>
						<td	style="padding-bottom:5px">
							<input type="button" class="popUp-button2" value="全部添加" onclick="addAll('select1')"/>
						</td>
					</tr>
					<tr>
						<td>
							<input type="button" class="popUp-button2" value="全部删除" onclick="deleteAll('select2')"/>
						</td>
					</tr>
			</table>
		</td>
		<td >
			<SELECT multiple="true" class="fl w150 h212 popUp-edit selectFont" id="select2" />
		</td>
	</tr>
	 <tr>  
		 <td colspan="4" height="30px">
		 </td>
	</tr>
	 <tr>  
		 <td>
		 	<input class="fl mt6" type="checkbox" id="define" name="define" style="checkbox" value="实例创建者"></input>
		 	<span class="popUp-treeTitle">&nbsp;实例创建者</span>
		 </td>
		 <td class="popUp-treeTitle" style="align:right;">相关数据：</td>
		 <td colspan="2" >
       		<input type="hidden" id="variable" name="variable"/>
			<select class="fl w231 popUp-edit selectFont" id="selectVariable">
				<option value=""></option>
			<% for (RelateData rData : relatedataList) { %>
				<option value="<%=rData.getRdataId()%>"><%=rData.getRdataName()%></option>
			<% } %>
			</select>
		 
		 </td>
	</tr>
 </table>

   <table class="w670  popUp-buttonBox" cellpadding="0" cellspacing="0">
    <tr>
		<td align="right">
			<input class="popUp-button" type="button" value="取消" onclick = "window.close()">
			<input class="popUp-button" type="button" value="提交" onclick = "commitValue();"/>
		</td>
    </tr>			
   </table>
   </div>
</body>
</html>