<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/common/resource_show.jsp"%>

 	<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<!--   	<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link> -->
<!--   	<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script> -->
	<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
	<script src="${ctx}/static/viewer/dist/viewer.js"></script>
	<script src="${ctx}/static/viewer/demo/js/main.js"></script>
  	
 	<script type="text/javascript" src="${ctx}/static/layer/layer.js"></script>
	<script type="text/javascript" src="${ctx}/static/jsTree/jquery.ztree.all-3.5.js"></script>  
	<script type="text/javascript" src="${ctx}/static/jsTree/jquery.ztree.all-3.5.min.js"></script>
	
<!-- 	<script src="${ctx}/static/dhtmlxtree/dhtmlxcommon.js"></script> -->
<!-- 	<script src="${ctx}/static/dhtmlxtree/dhtmlxmenu.js"></script> -->
<!-- 	<script src="${ctx}/static/dhtmlxtree/dhtmlxtree.js"></script> -->
<!-- 	<script src="${ctx}/static/dhtmlxtree/dhtmlXTreeExtend.js"></script> -->
<!-- 	<script src="${ctx}/static/dhtmlxtree/DivDialogUtil.js"></script> -->
<!-- 	<script type="text/javascript" src="${ctx}/static/bootstrap-select/jquery-2.1.3.min.js"></script> -->
<!-- 	<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script> -->
<!-- 	<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script> -->
<!-- 	<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link> -->
	
 	<link rel="stylesheet" href="${ctx}/static/cssTree/zTreeStyle/zTreeStyle.css" type="text/css"></link>
 	<link type="text/css" rel="stylesheet" href="${ctx}/static/dhtmlxtree/dhtmlxtree.css" />
<style type="text/css">
.title{
	 text-align: center;
     width: 100%;
}

img{    
/*       cursor: pointer;     */
/*       transition: all 0.6s;     */
}    
img:hover{    
/*        transform: scale(10.5);     */
}   
</style>
<script type="text/javascript">
    var setting = {  
        check: {  
            enable: true  
        },  
        data: {  
            simpleData: {  
                enable: true  
            }  
        },  
        callback: {  
            onCheck: zTreeOnCheck  
        },  
        view: {  
            selectedMulti: false  
        }  
    };  
    setting.check.chkboxType = { "Y" : "s", "N" : "s" };  
    //Y 属性定义 checkbox 被勾选后的情况；   
    //N 属性定义 checkbox 取消勾选后的情况；   
    //"p" 表示操作会影响父级节点；   
    //"s" 表示操作会影响子级节点。  
     
     var zNodes=${list}; 
      
//     var zNodes =[  
//         { id:1, pId:0, name:"水资源分区", open:true},  
//         { id:10, pId:1, name:"河流", checked:true, open:true},  
//         { id:11, pId:1, name:"湖泊", checked:true},  
//         { id:2, pId:1, name:"水库", checked:true, open:true},  
//         { id:21, pId:2, name:"大一型水库", checked:true, open:true},  
//         { id:22, pId:2, name:"大二型水库", checked:true},  
//         { id:23, pId:2, name:"中型水库", checked:true, icon:"./images/car1.png"},  
//         { id:24, pId:2, name:"小一型水库", checked:true, icon:"./images/car2.png"},  
//         { id:25, pId:2, name:"小二型水库", checked:true},  
//         { id:3, pId:1, name:"大坝", checked:true, open:true},  
//         { id:31, pId:3, name:"一级堤防", checked:true},  
//         { id:32, pId:3, name:"二级堤防", checked:true},  
//         { id:320, pId:32, name:"二级堤防32", checked:true},  
//         { id:33, pId:3, name:"三级堤防", checked:true},  
//         { id:34, pId:3, name:"四级堤防", checked:true},  
//         { id:35, pId:3, name:"未分级堤防", checked:true},  
//         { id:4, pId:0, name:"世界地图", checked:true},  
//         { id:5, pId:0, name:"世界地图_Night", checked:true},  
//     ];  
      
    function zTreeOnCheck(event, treeId, treeNode) {  
    debugger;
        //var checked = treeNode.checked;  
        //console.log((treeNode?treeNode.name:"root") + "checked " +(checked?"true":"false"));  
        refreshLayers();  
        clearCheckedOldNodes();  
    };  
    //刷新图层的显示情况  
    var layers;  
    function refreshLayers() {  
        var zTree = $.fn.zTree.getZTreeObj("treeWaterLayer");  
        var changedNodes = zTree.getChangeCheckedNodes();  
        for ( var i=0 ; i < changedNodes.length ; i++ ){  
            var treeNode = changedNodes[i];  
//             layers = map.getLayersByName(treeNode.name);  
//             if(layers!=null && layers[0]!=null){  
//                 layers[0].setVisibility(treeNode.checked);  
//             }  
                  
            console.log((treeNode?treeNode.name:"root") + "checked " +(treeNode.checked?"true":"false"));                 
        }  
    }  
    //清理善后工作  
    function clearCheckedOldNodes() {  
        var zTree = $.fn.zTree.getZTreeObj("treeWaterLayer"),  
        nodes = zTree.getChangeCheckedNodes();  
        for (var i=0, l=nodes.length; i<l; i++) {  
            nodes[i].checkedOld = nodes[i].checked;  
        }  
    };        
    $(document).ready(function(){  
        $.fn.zTree.init($("#treeWaterLayer"), setting, zNodes);  
    });  
</script>
<script type="text/javascript">
// var zTree = $.fn.zTree.getZTreeObj("treeWaterLayer");//换成实际的图层的id  
// var changedNodes = zTree.getChangeCheckedNodes(); //获取改变的全部结点  
// for ( var i=0 ; i < changedNodes.length ; i++ ){  
//     var treeNode = changedNodes[i];  
//     console.log((treeNode?treeNode.name:"root") + "checked " +(treeNode.checked?"true":"false"));  
//     }  
</script>
</head>
<body class="bg-gary">
	<div class="zTreeDemoBackground left" align="right" style="overflow-y:auto;height:400px;">  
    	<ul id="treeWaterLayer" class="ztree"></ul>  
	</div>
<!-- 	<table> -->
<!-- 		<tr> -->
<!-- 			<c:forEach items="${listphone}" var="row" varStatus="status"> -->
<!-- 			<td> -->
<!-- 				<div align="center">${row.id}</div> -->
<!-- 				    <div class="row"> -->
<!-- 				    	<div class="col-sm-8 col-md-6"> -->
<!-- 					        <div class="docs-galley"> -->
<!-- 					          	<ul class="docs-pictures clearfix"> -->
<!-- 					            	<li><img width="120px" height="60px" data-original="${ctx}/web/getImage?id=${row.id}" src="${ctx}/web/getImage?id=${row.id}" alt="Cuo Na Lake"></li> -->
<!-- 					          	</ul> -->
<!-- 					        </div> -->
<!-- 				      	</div> -->
<!-- 				    </div> -->
<!-- 			</td> -->
<!-- 			<c:if test="${status.count%10==0}"> -->
<!-- 		</tr>  -->
<!-- 		<tr> -->
<!-- 			</c:if> -->
<!-- 			</c:forEach> -->
<!-- 		</tr> -->
<!-- 	</table> -->
	
</body>
</html>
