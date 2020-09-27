var treeDivId="treeDiv";
$(function(){
	InitTableId();
	//LoadTheTree();	
	
	$(".color").colorpicker({
	    fillcolor:true
	});
});
function LoadTheTree(){
	$().apolloAjax({"index":"getGeo","nopage":"1"},function(data){
		$("#"+treeDivId).tree({
			animate:true,
			onlyLeafCheck:false,
			checkbox:true,
			cascadeCheck:true,
			data:getTreeData(data,{idKey:"GEO_ID",textKey:"GEO_NAME",iconCls:"icon-178",children:[]}),
			onContextMenu:function(e, row){
				ContextMenuControl.dispatch(e,row);								
			},
			onDblClick:function(node){
				
			},
			onClick:function(node){
				var parentNode = $('#'+treeDivId).tree('getParent', node.target);
				if(!parentNode){			
					$('#'+treeDivId).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);  
					node.state = node.state === 'closed' ? 'open' : 'closed';  
				}
			},
			onSelect:function(row){
				var selected = $('#'+treeDivId).tree('getSelected');
				if(selected.children && selected.children.length==0){
					$().apolloAjax({"index":"getAreaByTable","TABLE_ID":$('#tableId').combobox('getValue'),"PROV_ID":row.id,"nopage":"1"},function(data){
				    	$('#'+treeDivId).tree('append', {
							parent: selected.target,
							data:getTreeData(data,{idKey:"AREA_ID",textKey:"AREA_NAME",iconCls:"icon-002"})
						}).tree('check',selected.target);
				    });					
				}
			},
			onExpand:function(row){
				if(!row.children || row.children.length==0){
					$().apolloAjax({"index":"storeGroupReList","groupId":row.id,"nopage":"1"},function(data){
				    	$('#'+treeDivId).tree('append', {
							parent: row.target,
							data:getTreeData(data,{idKey:"STORE_ID",textKey:"STORE_NAME",iconCls:"icon-modify"})
						});
				    });	
				}
			}
			
		}) 
	},{modal:true,async:false});
}

var MenuActionControl={
		appendArea:function(){
			var node = $('#'+treeDivId).tree('getSelected');
			//--------下面执行添加操作
			map.clearMap();
			//关闭鼠标绘制工具
			if(mouseTool) mouseTool.close();
			var d = new Object();
			d.tableId = $('#tableId').combobox('getValue');
			d.provId = node.id;
			d.provName = node.text;
			InitAreaForm();
			$("#color").css("background-color","#fff3f3");
			AREAFROM.easyForm('openData',d);
			$(".point_tr").show();
		},
		
		
		modifyArea:function(){
			var node = $('#'+treeDivId).tree('getSelected');
			var params = new Object();
			params.index = "getAreaById";
			params.AREA_ID = node.id;
			apolloAjax(params,function(r){
				clearObj();
				$("#color").css("color",r.rows[0].COLOR);
				InitModifyAreaForm();				 
				AREAFROM.easyForm('openData',r.rows[0]);   
				darwStores(r.rows,true); 
            },{modal:true}); 
			$(".point_tr").hide();
		},
		removeArea:function(){
			$.messager.confirm('确认','是否删除区域?',function(r){if (r){
				AREAFROM.easyForm("close");
				var node = $('#'+treeDivId).tree('getSelected');			
				var params = new Object();
				params.url = "/area/delete.action";
				params.AREA_ID = node.id;
				params.bizException = CommonException;
				apolloAjax(params,function(data){
					LoadTheTree();
					clearObj();
				    alert(data.resultDescription); 
				    //location.reload();
				},{modal:true});
			}})
		},
		mutiRemoveSecend:function(param){
			
		},
		getCheckedNodes:function(level){
			var nodes = $('#'+treeDivId).tree('getChecked');
			var optNodes = []; //==真正需要操作的节点
			if(nodes){
				$.each(nodes,function(key,node){								
					if(node){
						var parentNode = $('#'+treeDivId).tree('getParent', node.target);
						if(level =="2"){
							if(parentNode){
								optNodes.push(node);
							}
						}
						if(level =="1"){
							if(!parentNode){
								optNodes.push(node);
							}
						}					
					}
				});
			}
			return optNodes;
		}
}

/**
 * 一级惨淡新增控制
 */
var LevelOneControl = {
		toggle:function(){
			$("#levelOneInput").toggle(500);
		},
		slideup:function(){
			$("#levelOneInput").slideUp(500);
		}
}

/**
 * 右键菜单控制
 */
var ContextMenuControl ={
		/**
		 * 菜单控制入口
		 * @param e
		 * @param row
		 */
		dispatch:function(e, row){
			$('#'+treeDivId).tree('select', row.target);
			var parentNode = $('#'+treeDivId).tree('getParent', row.target);
			e.preventDefault();
			if(!parentNode){
				ContextMenuControl.levelOneMenu(e, row);
			}else{
				ContextMenuControl.otherMenu(e, row);
			}
		},
		/**
		 * 一级菜单控制
		 * @param e
		 * @param row
		 */
		levelOneMenu:function(e, row){
			$('#levelOneMenuDiv').menu('show', {
				left: e.pageX,
				top: e.pageY
			});	
		},
		/**
		 * 二级菜单控制
		 * @param e
		 * @param row
		 */
		otherMenu:function(e, row){
			$('#otherMenuDiv').menu('show', {
				left: e.pageX,
				top: e.pageY
			});	
		}
}


/**
 * 组装tree数据
 * @param data
 * @param params
 * @returns {Array}
 */
function getTreeData(data,params){
	var retInfo = [];
	if(data){
		$.each(data,function(key,item){
			if(item){
				var temp={};
				temp["id"]=item[params.idKey];
				temp["text"]=item[params.textKey];
				if(params.iconCls){
					temp["iconCls"]=params.iconCls;
				}
				if(params.children){
					temp["children"]=params.children;
				}
				temp["state"]=params.state || "open";
				retInfo.push(temp);
			}
		})
	}
	return retInfo;
}

function CommonException(context,data,params){	
    alert(context.errorMessage);
}
function AddTable(){
	InitTableForm();
    $('#TableForm').easyForm('openData',{});
}
function InitTableForm(){
    $('#TableForm').easyForm({
		title:'新增地图',
		iconCls:'icon-save',
		width:300,
		height:120,
		submit:function(data){
			data.url="/table/add.action";
			data.bizException = CommonException;
			apolloAjax(data,function(r){
				$('#TableForm').dialog('close');
				alert(r.resultDescription);
				location.reload();
			},{modal:true,async:false})		
		}
	});
}
function InitAreaForm(){	 
	$('#AreaFrom').easyForm({
		title:'区域信息',
		iconCls:'icon-030',
		width:370,
		height:270,
		modal:false,
		closed:true,
		clear:true,
		top:0,
		left:$(window).width()-370,
		submit:function(data){
			if("" == data.color){
				alert("区域颜色必选");
				return;
			}
			var arr = area.getPath();
			var areaJson = "";
			for(var i=0;i<arr.length;i++){
				areaJson+=",{\"lng\":"+arr[i].getLng()+",\"lat\":"+arr[i].getLat()+"}";
			}
			data.area = "["+areaJson.substring(1)+"]";
			data.url="/area/addArea.json";
			data.bizException = CommonException;
 			$().apolloAjax(data,function(r){
				if(r){
					//LoadTheTree();
					clearObj();
					AREAFROM.dialog('close');
					alert("添加成功");
					LoadTheTree();
				}
			},{modal:true,dataType:'text'});
		},				
		onClose:function(){
			map.clearMap();
			//关闭鼠标绘制工具
			if(mouseTool) mouseTool.close();
		}
	});	
}

function InitModifyAreaForm(){
	$('#AreaFrom').easyForm({
		title:'编辑区域',
		iconCls:'icon-030',
		width:370,
		height:270,
		modal:false,
		closed:false,
		clear:true,
		top:0,
		left:$(window).width()-370,
		submit:function(data){		
			if("" == data.color){
				alert("区域颜色必选");
				return;
			}
			var arr = editArea.Wd.getPath();
			var areaJson = "";
			for(var i=0;i<arr.length;i++){
				areaJson+=",{\"lng\":"+arr[i].getLng()+",\"lat\":"+arr[i].getLat()+"}";
			}
			data.area = "["+areaJson.substring(1)+"]";
			data.url="/area/update.action";
			data.bizException = CommonException;
			apolloAjax(data,function(r){
			    LoadTheTree();	
			    AREAFROM.dialog('close');
				alert(r.resultDescription);
		    },{modal:true})	
		},
		onClose:function(){
			map.clearMap();
		}
	});	
}

function CommonException(context,data,params){	
    alert(context.errorMessage);
}

function InitTableId(){
	var data = new Object();
	data.index = "tableList";
	data.nopage = 1;
	apolloAjax(data,function(r){
		$("#tableId").combobox({editable:false,panelHeight: 130,valueField:'TABLE_ID',textField:'TABLE_NAME',data:jsonToArray(r),
			onSelect:function(e){
				clearObj();
				LoadTheTree();	
			}
		});
		if(r&&r.length>0) {
			$('#tableId').combobox('select', r[0].TABLE_ID);
		}
	},{"async":false});
}
function getSelectedStoreIds(){
	var ids = "";
	var nodes = MenuActionControl.getCheckedNodes("2");	 
	for(var i=0;i<nodes.length;i++){
	    var node = nodes[i];
	    if(i != 0) ids+=",";
	    ids+=node.id;
	}	
	return ids;
}
