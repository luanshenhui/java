<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/common/resource_show.jsp"%>
 	<script type="text/javascript" src="${ctx}/static/layer/layer.js"></script>
	<script type="text/javascript" src="${ctx}/static/jsTree/jquery.ztree.all-3.5.js"></script>  
	<script type="text/javascript" src="${ctx}/static/jsTree/jquery.ztree.all-3.5.min.js"></script>
 	<link rel="stylesheet" href="${ctx}/static/cssTree/zTreeStyle/zTreeStyle.css" type="text/css"></link>
<style type="text/css">
.title{
	 text-align: center;
     width: 100%;
}
</style>
<script type="text/javascript">
  
	var zTreeObj;
	// zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
	function test(event, treeId, treeNode) {
		alert(treeNode.tId + ", " + treeNode.name + "," + treeNode.checked);
	}
	
	var setting = {
		check : {
			enable : true,
			autoCheckTrigger : true,
			chkStyle : "checkbox"
		},
		callback : {
			onCheck : test
		}
	};
	// zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
	var zNodes = [ {
		name : "test1",
		open : true,
		children : [ {
			name : "test1_1"
		}, {
			name : "test1_2"
		} ]
	}, {
		name : "test2",
		open : true,
		children : [ {
			name : "test2_1"
		}, {
			name : "test2_2"
		} ]
	} ];
	$(document).ready(function() {
		zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
	});
</script>
</head>
<body class="bg-gary">
	<div>  
	   <ul id="treeDemo" class="ztree"></ul>  
	</div>  
	
	<div class="margin-auto width-1200  data-box">
		<div class="margin-cxjg">
			<table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
			
			</table>
		</div>
	</div>
</body>
</html>
