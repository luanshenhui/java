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
	
 	<link rel="stylesheet" href="${ctx}/static/cssTree/zTreeStyle/zTreeStyle.css" type="text/css"></link>
 	<link type="text/css" rel="stylesheet" href="${ctx}/static/dhtmlxtree/dhtmlxtree.css" />
<style type="text/css">
.title{
	 text-align: center;
     width: 100%;
}
</style>

<script type="text/javascript">

	$(function() {  
        reloadTree();  
  
        $("#treeWaterLayer").bind(//鼠标点击事件不在节点上时隐藏右键菜单  
                "mousedown",  
                function(event) {  
                    if (!(event.target.id == "rMenu" || $(event.target)  
                            .parents("#rMenu").length > 0)) {  
                        $("#rMenu").hide();  
                    }  
                });  
    });  
    
    var url = "${ctx}/web/jztreeAjax";  
    //zTree基本设置  
    var setting = {  
        async : true, //需要采用异步方式获取子节点数据,默认false  
        asyncUrl : url, //当 async = true 时，设置异步获取节点的 URL 地址 ,允许接收 function 的引用  
        asyncParam : ["id"], //提交的与节点数据相关的必需参数  
        isSimpleData : true, //数据是否采用简单 Array 格式，默认false  
        treeNodeKey : "id", //在isSimpleData格式下，当前节点id属性  
        treeNodeParentKey : "parentId", //在isSimpleData格式下，当前节点的父节点id属性  
        nameCol : "privName",            //在isSimpleData格式下，当前节点名称  
        expandSpeed : "fast", //设置 zTree节点展开、折叠时的动画速度或取消动画(三种默认定义："slow", "normal", "fast")或 表示动画时长的毫秒数值(如：1000)   
        showLine : true, //是否显示节点间的连线  
        callback : { //回调函数  
            rightClick : zTreeOnRightClick   //右键事件  
        }  
    };  

	function reloadTree() {  
        hideRMenu();  
        zTree = $("#treeWaterLayer").zTree(setting, treeNodes);  
    }     
      
    var zTree;  
    var treeNodes = [];  
      
  

 //显示右键菜单  
    function showRMenu(type, x, y) {  
        $("#rMenu ul").show();  
        if (type=="root") {  
            $("#m_del").hide();  
            $("#m_check").hide();  
            $("#m_unCheck").hide();  
        }  
        $("#rMenu").css({"top":y+"px", "left":x+"px", "display":"block"});  
    }  
    
     //隐藏右键菜单  
    function hideRMenu() {  
        $("#rMenu").hide();  
    }  
    
     //鼠标右键事件-创建右键菜单  
    function zTreeOnRightClick(event, treeId, treeNode) {  
    alert("右键");
        if (!treeNode) {  
            zTree.cancelSelectedNode();  
            showRMenu("root", event.clientX, event.clientY);  
        } else if (treeNode && !treeNode.noR) { //noR属性为true表示禁止右键菜单  
            if (treeNode.newrole && event.target.tagName != "a" && $(event.target).parents("a").length == 0) {  
                zTree.cancelSelectedNode();  
                showRMenu("root", event.clientX, event.clientY);  
            } else {  
                zTree.selectNode(treeNode);  
                showRMenu("node", event.clientX, event.clientY);  
            }  
        }  
    }   
</script>
</head>
<div class="zTreeDemoBackground left" align="right" style="overflow-y:auto;height:400px;">  
    <ul id="treeWaterLayer" class="ztree"></ul>  
</div>   
	<p>
		<span style="background-color: #fafafa;">
			<!-- 右键菜单div -->
			<div id="rMenu">
				<li>
					<ul id="m_add" onclick="addPrivilege();">
						<li>增加</li>
					</ul>
					<ul id="m_del" onclick="delPrivilege();">
						<li>删除</li>
					</ul>
					<ul id="m_del" onclick="editPrivilege();">
						<li>编辑</li>
					</ul>
					<ul id="m_del" onclick="queryPrivilege();">
						<li>查看</li>
					</ul>
				</li>
			</div>
		</span>
	</p>
</html>
