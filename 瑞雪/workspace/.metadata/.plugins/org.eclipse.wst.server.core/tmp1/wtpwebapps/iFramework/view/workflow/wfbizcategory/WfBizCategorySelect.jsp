<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" errorPage="/ErrorNormal.jsp"%>
<%@ page import="java.util.ArrayList"%>

<%
	//防跨站脚本编制
	String webpath = request.getContextPath();
	//返回选择结果时，确定哪一列是要返回显示的。此参数必填！
	String displayColumnName = (String) request
			.getParameter("displayColumnName");
	String selectType = (String) request
			.getParameter("selectType");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务分类选择</title>
<link rel="stylesheet" href="<%=webpath%>/view/common/css/demo.css" type="text/css">
<link rel="stylesheet" href="<%=webpath%>/view/common/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<link rel="stylesheet" href="<%=webpath%>/view/common/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include page="/view/common/jsp/Common.jsp" flush="true" />
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript">
	var $jQuery = $;
	//返回选择结果时，确定哪一列是要返回显示的。
	var displayColumnName = "<%=displayColumnName%>";
	var selectType = "<%=selectType%>";
</script>
<script type="text/javascript">
	$jQuery().ready(function(){
		var setting = {
				data : {
					key : {
						title : "name"
					},
					simpleData : {
						enable : true,
						idKey : "bizCateId",
						pIdKey : "bizCateParentId",
						rootPId : '-1'
					}
				},
				callback : {
					beforeClick : beforeClick,
					onClick : onClick
				}
			};
		var className = "dark";
		function beforeClick(treeId, treeNode, clickFlag) {
			className = (className === "dark" ? "" : "dark");
			return (treeNode.click != false);
		}
		function onClick(event, treeId, treeNode, clickFlag) {
			var parentWin = window.opener;
			if (selectType == "copyProcess") {
				parentWin.copyProcess(treeNode.bizCateId);
			} else {
				parentWin.updateProcessCategory(treeNode.bizCateId);
			}
			window.close();
		}
		var zNodes = "";
		var sURL = webpath
				+ "/WfBizCategoryAction.do?method=getWfBizCategory";
		jQuery.ajax({
			url : sURL,
			async : false,
			type : "post",
			contentType : 'application/json; charset=UTF-8',
			data : {
				bizCateIds : 0
			},
			success : function(returnValue) {
				zNodes = returnValue;
				jQuery.fn.zTree.init($("#treeDemo"), setting,
						zNodes);
			},
			error : function(XMLHttpRequest, textStatus,
					errorThrown) {
				alert("网络错误");
			}
		});
	});

	var webpath = "<%=webpath%>";

	//保存选择的结果
	function confirmWfBizCategorySelect() {

		var returnValue = new Object();
		var ecsideObj = ECSideUtil.getGridObj("ec");
		var crow = ecsideObj.selectedRow;
		if (crow == null || crow.cells[0] == undefined) {
			returnValue.itemIds = "";
			returnValue.itemTexts = "";

		} else {
			var selectedWfBizCategoryID = ECSideUtil.getPropertyValue(crow,
					"bizCateId", "ec");
			var selectedWfBizCategoryName = ECSideUtil.getPropertyValue(crow,
					"bizCateName", "ec");
			returnValue.itemIds = selectedWfBizCategoryID;
			returnValue.itemTexts = selectedWfBizCategoryName;
		}
		return returnValue;
	}

	function closeWin() {
		window.returnValue = null;
		window.close();
	}
</script>
</head>
<body style="padding:0px 0px 0px 5px;margin:0; border:0;">
<div style="float:left;margin:0 0 0 10px">
	<ul id="treeDemo" class="ztree" style="width:400px"></ul>
</div>
</body>
</html>