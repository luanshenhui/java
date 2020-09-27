<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.dhc.base.common.consts.CommonConsts"%>
<%@ page import="com.dhc.organization.role.domain.WF_ORG_ROLE"%>
<%@ page import="com.dhc.organization.config.OrgI18nConsts"%>
<%@ page import="com.dhc.base.common.util.SecurityUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/ecside.tld" prefix="ec"%>
<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    String language = CommonConsts.LANGUAGE;
    String needAllUser = request.getParameter("needAllUser");
    
    //页面打开时，选中已有的用户(把checkbox控件选中)
    String selectedUsers = request.getParameter("stationUserIDs");
    if (selectedUsers == null || selectedUsers.equals("")) {
    	selectedUsers = "";
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><bean:message key="stat.title.user_select"/></title>
<%@ include file="/view/base/common/i18nConsts.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/main.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=webpath%>/view/base/theme/css/redmond/ui.form.css" />
<link rel="stylesheet" type="text/css" 
    href="<%=webpath%>/view/base/theme/css/redmond/ecside/css/ecside_style.css" />
<script type="text/javascript"
	src="<%=webpath %>/view/base/common/DivDialogUtil.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/scripts/jquery-1.4.2.min.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/minified/jquery.ui.core.min.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.ui.draggable.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.ui.resizable.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.ui.dialog.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.effects.core.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/jquery.effects.highlight.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/plugin/jqueryui/minified/jquery.ui.widget.min.js"></script>
<script type="text/javascript">
	var jQuery = $;
	jQuery().ready(function(){    
		jQuery('body').bind('keydown',shieldCommon);
	});
</script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside_msg_utf8_<%=language%>.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/prototype_mini.js"></script>
<script type="text/javascript"
	src="<%=webpath%>/view/base/ecside/ecside.js"></script>
<script type="text/javascript" 
    src="<%=webpath %>/view/base/plugin/utils/MessageBox_Dollar.js"></script>
<script type="text/javascript">
	var webpath = "<%=webpath%>";
	<% if (!selectedUsers.equals("")){%>
		//把页面初始化数据放到hashTable中，用于给已选的项打挑
		hashTable.put(999999,'<%=selectedUsers%>'.split(","));
	<% }%>
	//保存选择的结果
	function confirmUserSelect(){
		var returnObj = new Object();
		var returnValue;
		//用于存放当前页的id，历史页的id不在这里存放
		var currentPageIDs ="";
		var allcheckarray =ECSideUtil.getPageCheckValue("checkBoxID");
		if(allcheckarray)
			currentPageIDs = allcheckarray.join(",");
		//表示hashtable中没有数据
		if (hashTable.hashtable.length == 0){
			returnObj.itemIds = currentPageIDs;
		} else {
			var idString = "";
			//把每一页中选定的那些id都拼成一个串
			for(i=0; i<hashTable.hashtable.length; i++){
				if (hashTable.hashtable[i]){
					idString += hashTable.hashtable[i];
					//alert(idString);
					if (i<hashTable.hashtable.length-1){
						idString += ",";
					}
				}
			}
			if (ECSideUtil.trimString(currentPageIDs) != "")
				idString += ("," + currentPageIDs);
			idString = idString.split(",").uniq().join(",");
			//有的时候，一次uniq不行，还要再uniq一次
			idString = idString.split(",").uniq().join(",");
			//alert(idString);
			returnObj.itemIds = idString;
		}
		//alert(returnObj.itemIds);
		var sURL1 = webpath + "/UserAction.do?method=getUsersInUserIds";
		jQuery.ajax( {
			url : sURL1,
			type : "post",
			async : false,
			dataType : "json",
			data : {
				userIds : returnObj.itemIds
			},
			success : function(data) {
				if(data.errorMessage == undefined){
					//alert(data.userNames);
					returnObj.itemTexts = data.userNames;
					//alert(returnObj.itemIds);
					//alert(returnObj.itemTexts);
					//window.returnValue = returnObj;
					returnValue = returnObj;					
					//window.close();
				} else {
					alert(data.errorMessage);
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert(NET_FAILD);
				// 通常 textStatus 和 errorThrown 之中 
			    // 只有一个会包含信息 
			    //this;  调用本次AJAX请求时传递的options参数
			}
		});
		return returnValue;
	}

	function closeWin(){
		window.returnValue=null;
		window.close();
	}

</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<div style="width:97%">
	<ec:table
		items="userList" var="record" retrieveRowsCallback="limit" toolbarContent="navigation|pagejump|pagesize|status"
		useAjax="true" action="${pageContext.request.contextPath}/UserAction.do?method=getUser&needAllUser=<%=needAllUser %>"
		xlsFileName="UserList.xls" csvFileName="UserList.csv" listWidth="100%" sortable="true"
		pageSizeList="5,10,20,50,100,200,500" rowsDisplayed="10" minHeight="230" height="230">
		<ec:row>
		    <ec:column width="5%" style="text-align:center;" cell="checkbox"  headerCell="checkbox" alias="checkBoxID" 
		        value="${record.userId}"  viewsAllowed="html" /> 
			<ec:column width="20%" style="text-align:center;" property="userAccount" title="<%=OrgI18nConsts.USER_ACCOUNT %>" />
			<ec:column width="30%" style="text-align:center;" property="userFullname" title="<%=OrgI18nConsts.USER_USERNAME %>" />
			<ec:column width="45%"  style="text-align:center;"property="userUnits" title="<%=OrgI18nConsts.USER_UNIT %>" />
		</ec:row>
	</ec:table>
</div>
<table border=0  width="98%">
<!-- 
<tr><td align="right">
<input id="btnSave" class="jt_button" type="button" value="保存 "
	onclick="confirmUserSelect()" /> 
<input id="btnClose" class="jt_button"
	type="button" value="关闭" onClick="closeWin()" />
</td></tr>
 -->
</table>
</body>
</html>