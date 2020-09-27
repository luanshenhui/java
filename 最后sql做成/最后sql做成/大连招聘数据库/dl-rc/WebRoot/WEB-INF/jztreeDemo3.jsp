<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/common/resource_show.jsp"%>
 	<script type="text/javascript" src="${ctx}/static/layer/layer.js"></script>
	<script type="text/javascript" src="${ctx}/static/jsTree/jquery.ztree.all-3.5.js"></script>  
	<script type="text/javascript" src="${ctx}/static/jsTree/jquery.ztree.all-3.5.min.js"></script>
	
	<script src="${ctx}/static/dhtmlxtree/dhtmlxcommon.js"></script>
	<script src="${ctx}/static/dhtmlxtree/dhtmlxmenu.js"></script>
	<script src="${ctx}/static/dhtmlxtree/dhtmlxtree.js"></script>
	<script src="${ctx}/static/dhtmlxtree/dhtmlXTreeExtend.js"></script>
	<script src="${ctx}/static/dhtmlxtree/DivDialogUtil.js"></script>
	<script src="${ctx}/static/bootstrap-select/bootstrap-select.min.js"></script>
	
 	<link rel="stylesheet" href="${ctx}/static/bootstrap-select/bootstrap-select.min.css" type="text/css"></link>
 	<link rel="stylesheet" href="${ctx}/static/cssTree/zTreeStyle/zTreeStyle.css" type="text/css"></link>
 	<link type="text/css" rel="stylesheet" href="${ctx}/static/dhtmlxtree/dhtmlxtree.css" />
<style type="text/css">  
    div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px;}  
    div#rMenu a{  
        cursor: pointer;  
        list-style: none outside none;  
    }  
    
    .list-group-item{
		  overflow:hidden;  
		  position: relative;
		  display: block;
		  padding: 10px 15px;
		  margin-bottom: -1px;
		  background-color: #fff;
		  border: 1px solid #ddd;
	}
</style>  

<script type="text/javascript">
	$(window).on('load', function () {
	 $('#usertype').selectpicker({
	 'selectedText': 'cat'
	 });
	});

	var setting = {
		check : {
			enable : true,
			chkStyle : "checkbox",
			chkboxType : {
				"Y" : "p",
				"N" : "s"
			}
		},
		view : {
			selectedMulti : false
		},
		async : {
			enable : true,
			url : "${ctx}/web/jztreeAjax",
			autoParam : [],
			contentType : "application/json",
			otherParam : {},
			dataFilter : filter
		//异步获取的数据filter 里面可以进行处理  filter 在下面
		},
		data : {
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "pId",
				rootPId : ""
			}
		},//个人理解加上这个就能按级别显示，其中的id pid 对应你的实体类
		callback : {
			onRightClick: OnRightClick,
			onClick : function(treeId, treeNode) {
				alert("click");
				debugger;
				var treeObj = $.fn.zTree.getZTreeObj(treeNode);
				var selectedNode = treeObj.getSelectedNodes()[0];
				$("#txtId").val(selectedNode.id);
				$("#txtAddress").val(selectedNode.name);
			}
		}
	//这里是节点点击事件
	};
	function filter(treeId, parentNode, childNodes) {
// 		alert(childNodes.length);
		if (!childNodes)
			return null;
		for (var i = 0, l = childNodes.length; i < l; i++) {
			childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
		}
		return childNodes;
	}

	$(document).ready(function() {
		debugger
		$.fn.zTree.init($("#treeDemo"), setting);
	});
	
	
	// 在ztree上的右击事件  
	function OnRightClick(event, treeId, treeNode) {  
	    if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {  
	        showRMenu("root", event.clientX, event.clientY);  
	    } else if (treeNode && !treeNode.noR) {  
	        showRMenu("node", event.clientX, event.clientY);  
	    }  
	}  
	//显示右键菜单  
	function showRMenu(type, x, y) {  
	    $("#rMenu ul").show();  
	    $("#rMenu").css({"top":y+"px", "left":x+"px", "visibility":"visible"}); //设置右键菜单的位置、可见  
	    $("body").bind("mousedown", onBodyMouseDown);  
	}  
	//隐藏右键菜单  
	function hideRMenu() {  
	    if (rMenu) rMenu.css({"visibility": "hidden"}); //设置右键菜单不可见  
	    $("body").unbind("mousedown", onBodyMouseDown);  
	}  
	//鼠标按下事件  
	function onBodyMouseDown(event){  
	    if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {  
	         $("#rMenu").css({"visibility" : "hidden"});  
	    }  
	}  
</script>
</head>
<body class="bg-gary">
	<div class="zTreeDemoBackground left" align="right" style="overflow-y:auto;height:400px;">  
   		 <ul id="treeDemo" class="ztree"></ul>
	</div>  
	<div id="rMenu">  
	    <a href="#" class="list-group-item">展开下一级</a>  
	    <a href="#" class="list-group-item" >展开所有子节点</a>  
	    <a href="#" class="list-group-item" >折叠子节点</a>  
	    <a href="#" class="list-group-item" >全部展开</a>  
	    <a href="#" class="list-group-item" >全部折叠</a>  
	</div>  

<select id="example" name="example" multiple="multiple">
  <option value="1">Option 1</option>
  <option value="2">Option 2</option>
  <option value="3">Option 3</option>
  <option value="4">Option 4</option>
  <option value="5">Option 5</option>
</select>  

 <select id="example-multiple" size="6" multiple="multiple">  
        <option value="cheese">Cheese</option>  
        <option value="tomatoes">Tomatoes</option>  
        <option value="mozarella">Mozzarella</option>  
        <option value="mushrooms">Mushrooms</option>  
        <option value="pepperoni">Pepperoni</option>  
        <option value="onions">Onions</option>  
    </select>  
    
    <div class="form-group">
    <label class="col-sm-3 control-label">客资类型：</label>
    <div class="col-sm-4">
    <select id="usertype" name="usertype" class="selectpicker show-tick form-control" multiple data-live-search="false">
     <option value="0">苹果</option>
     <option value="1">菠萝</option>
     <option value="2">香蕉</option>
     <option value="3">火龙果</option>
     <option value="4">梨子</option>
     <option value="5">草莓</option>
     <option value="6">哈密瓜</option>
     <option value="7">椰子</option>
     <option value="8">猕猴桃</option>
     <option value="9">桃子</option>
    </select>
    </div>
    </div>

<select id="myselect" multiple="true">
    <option value="1">java</option>
    <option value="2">javaSE</option>
    <option value="3">javaEE</option>
</select>
</body>
</html>
