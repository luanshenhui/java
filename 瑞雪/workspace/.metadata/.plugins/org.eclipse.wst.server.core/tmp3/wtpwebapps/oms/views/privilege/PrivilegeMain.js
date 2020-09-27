//初始化addList和delList里的数据。
addList = new ArrayList();
delList = new ArrayList();
originalList = new ArrayList();
submintList = new ArrayList();
var sh;
var url = location.href;
var isAdminRole =url.split("isAdminRole=")[1];

$(function () {
    $('#t_project tbody').on('click','td',function () {
        var len=$(this).children().length
        if(len==0){//选择行
            $("#t_project tbody input[type='checkbox']").prop("checked",false)
            var first=$(this).parent().children()[0];
            var ck = $(first).children()[0];
            $(ck).prop("checked",true)
        }else{//选择checkbox
            
        }
    }),
    
    $('#shopTable tbody').on('click','td',function () {
        var len=$(this).children().length
        if(len==0){//选择行
            $("#shopTable tbody input[type='checkbox']").prop("checked",false)
            var first=$(this).parent().children()[0];
            var ck = $(first).children()[0];
            $(ck).prop("checked",true)
        }else{//选择checkbox
            
        }
    }),
    
    $("#chkAllProject").click(function () {
        $("#t_project tbody input[type='checkbox']").prop("checked",this.checked);
    })
    $("#chkAllShop").click(function () {
        $("#shopTable tbody input[type='checkbox']").prop("checked",this.checked);
    })
});


$(document).ready(function(){
    if(isAdminRole=='true'){
//        $("#generalTab").remove();
//        $("#project-tab").remove();
//        $("#shop-tab").remove();
        $("a[href='#project-tab']").remove();
        $("a[href='#shop-tab']").remove();
    }else{
        // 加载项目列表
      projectTab= $('#t_project').DataTable({ 
            "processing": true,
            "serverSide": true,
            "lengthMenu": [[-1], ["All"]],
            "dom": '<"bottom">',
            "searching": false,
            "pagingType": "full_numbers",
            "deferRender": true,
            "ajax": {
                "url": "/projectManager/getProjectList.action",
                "data": function ( d ) {
//                    d.quickSearch = encodeURI($('#quickSearch').val());
                    d.quickSearch = "";
                    d.enable = "y";
                }
            },
            "fnDrawCallback": function (oSettings) {
                $("#thpro").removeClass("sorting_asc");
            },
            "tableTools": {
                "sRowSelect": "bootstrap"
            },
            "columns": [
                {"data": "chk","searchable": false},
                {"data": "prjName","searchable": false},
                {"data": "prjType", "searchable": false},
                {"data": "cons", "searchable": false},
                {"data": "tel", "searchable": false},
                {"data": "createTime", "searchable": false},
                {"data": "expireTime", "searchable": false}
            ],
            "columnDefs": [
                {"orderable":false,
                    "targets":[0]},
                {"orderable":false,
                    "targets":[1]},
                {"orderable":false,
                    "targets":[2]},
                {"orderable":false,
                    "targets":[3]},
                {"orderable":false,
                    "targets":[4]},
                {"orderable":false,
                    "targets":[5]},
                {"orderable":false,
                    "targets":[6]}
        ]
        });
        
        shopTable = $('#shopTable').DataTable({
            "processing": true,
            "serverSide": true,
            "lengthMenu": [[-1], ["All"]],
            "dom": '<"bottom">',
            "searching": false,
            "pagingType": "full_numbers",
            "deferRender": true,
            "ajax": {
                "url": "/shop/shopList.action",
                "data": function ( d ) {
                    d.quickSearch = "";
                    d.enable = "y";
                }
            },
            "fnDrawCallback": function (oSettings) {
                $("#thshop").removeClass("sorting_asc");
            },
            "tableTools": {
                "sRowSelect": "bootstrap"
            },
            "columns": [{
                    "data": "chk","searchable": false
                },{
                    "data": "shopName"
                }, {
                    "data": "shopAccount"
                }, {
                    "data": "prjName"
                }, {
                    "data": "parentshopname"
                }, {
                    "data": "expireTime"
                }
            ],
            "columnDefs": [
                {"orderable":false,
                    "targets":[0]},
                {"orderable":false,
                    "targets":[1]},
                {"orderable":false,
                    "targets":[2]},
                {"orderable":false,
                    "targets":[3]},
                {"orderable":false,
                    "targets":[4]},
                {"orderable":false,
                    "targets":[5]}
              
        ]
        });
    }
	//初始化分割条控件
	$("#splitter").jsplit({ MaxW:"350px"//设置最大宽度
        ,MinW:"200px"//设置最小宽度
        ,FloatD:"left"//设置块浮动方向
        ,IsClose:false//设置初始状态
        ,BgUrl:"url(/sp_bg.gif)"//设置分隔条背景图片地址
        ,Bg:"right 0 repeat-y"//设置分隔条背景图片position,颜色等
        ,Btn:{btn:false//是否显示上下按钮 false为不显示
             ,oBg:{Out:"0 0",Hover:"-6px 0"}//设置打开状态时候按钮背景：鼠标离开(默认)，经过
             ,cBg:{Out:"-12px 0",Hover:"-18px 0"}}//设置打开状态时候按钮背景：鼠标离开(默认)，经过
        ,Fn:function(){}//拖动，点击分隔条时候触发的方法
	});

	//初始化Tab框
	$('#tabs').tabs();

	//初始化tree
	tree =new dhtmlXTreeObject("menuTree","96%","96%",0);
    tree.setImagePath("/csh_books/");
    //tree.attachEvent("onClick",showDetail);
    tree.enableCheckBoxes(1);
	tree.setOnMouseInHandler(beforeOpenNode);
	tree.setOnOpenEndHandler(checkSubNodes);
	tree.setOnCheckHandler(nodeCheckHandler);
	tree.enableThreeStateCheckboxes(true);
	tree.setXMLAutoLoading("/menu/getElementsByMenuItemID.action?showAllMenu=assignable");
	tree.loadXML("/menu/getMenuTree.action?showAllMenu=assignable");
	//tree.openAllItems(null);
	tree.openItem("RootMenu");
	
//	$("#btnClean").attr('disabled',true);
	//画列表框
	//获取所有角色
	var sURL1 = "/role/getAllRolesJSON.action";
	$.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		data : {
			isAdminRole : isAdminRole
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				//循环所有role画下拉列表框
				//下面的方法ie、firefox可用
				for(var i=0; i<data.roleList.length;i++){
					var role=data.roleList[i];
					if (i == 0) {
						$("#listbox").append("<a id=" + role.roleId +" href='#' onclick='roleSelect(this)' class='list-group-item active'>" + role.roleName + "</a>");
						currSelID = role.roleId;
						currSelType ="role";
						requestPrivilegeAndDrawTree(role.roleId,"role","false");
					} else {
						$("#listbox").append("<a id=" + role.roleId +" href='#' onclick='roleSelect(this)' class='list-group-item'>" + role.roleName + "</a>");
					}
				}
//				myOption.style.display="";
//				$("#listbox").msDropDown();
//				$("#listbox").hide();
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
	
	
	//非管理角色，才可以画组织岗位树
	if (isAdminRole == "" || isAdminRole == 'false') {
		sh = setInterval(drawOrgStatTree,2000);
	}
	
	if(isAdminRole=='true'){
		$("#mypost").remove();
		$("#note-tab").remove();
	}
	//dropdown控件设置宽度listbox_child
	
	//初始化addList和delList里的数据。
	addList = new ArrayList();
	delList = new ArrayList();
});

//画组织岗位树
function drawOrgStatTree(){
	//初始化组织岗位树
	orgTree1 =new dhtmlXTreeObject("orgTree","96%","96%",0);
	orgTree1.setImagePath("/csh_books/");
	orgTree1.attachEvent("onClick",onClickCheck); //点击节点事件
	orgTree1.setOnOpenEndHandler(checkSubNodes2);  //解决节点请求回来无法展开
	orgTree1.setOnMouseInHandler(beforeOpenNode2);
	orgTree1.setXMLAutoLoading("/unit/getSubUnitTree.action?needStation=true"); 
	orgTree1.loadXML("/unit/getUnitTree.action?needStation=true");
	orgTree1.openItem("RootUnit@UNIT");
	orgTree1.attachEvent("onClick",orgSelect);
	clearInterval(sh);
	
	getUnitTreeManageable();
}

function getUnitTreeManageable(){	
	jQuery.ajax({
		url:"/unit/getUnitTreeManageable.action",
		type:"post",
		async:false,
		dataType:"json",
		success:function(data){
			if(data.errorMessage==null || data.errorMessage==undefined){
				for(var i=0;i<data.length;i++){
					if(data[i].MANAGEABLE != 1){
						orgTree1.showItemCheckbox(data[i].UNIT_ID,false); //闅愯棌澶嶉�夋
						orgTree1.setItemColor(data[i].UNIT_ID,"#aaaaaa","#aaaaaa");//鑺傜偣瀛椾綋棰滆壊缃伆
					}
				}
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = "/login.jsp";
				else
					alert(data.errorMessage);
			}
		}
	});
	
}

/**
 * 树结点点击事件处理
 * @return
 */
function nodeCheckHandler(id,state){
	//state：1是选中，0是未选中
	if (state || state == "1" || state == 1){
		if(delList.contains(id))
			delList.remove(id);
		else if(!addList.contains(id))
			addList.add(id);
	} else {
		if(addList.contains(id))
			addList.remove(id);
		else if(!delList.contains(id))
			delList.add(id);
	}
}

/**
 * 选择一个组织/岗位时触发
 * @return
 */
function orgSelect(){
	var itemId = orgTree1.getSelectedItemId();
	var itemColor = orgTree1.getItemColor(itemId);	
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
//		$("#btnClean").attr('disabled',true);
		$("#btnExpand").attr('disabled',true);
		$("#btnClose").attr('disabled',true);
		$("#btnSave").attr('disabled',true);
	}else{
		$("#btnClean").attr('disabled',false);
		$("#btnExpand").attr('disabled',false);
		$("#btnClose").attr('disabled',false);
		$("#btnSave").attr('disabled',false);
	}
	
	//alert(itemId);
	var idList = itemId.split("@");
	var id = idList[0];
	var type= idList[1];
	
	//设置当前选中的id和type(角色、组织、岗位)
	currSelType = type;
	currSelID = id;
	
	tree.enableThreeStateCheckboxes(false);
	//根据当前选择的（角色、组织、岗位）来获取它对于资源 的访问性
	requestPrivilegeAndDrawTree(id, type, "false");
	tree.enableThreeStateCheckboxes(true);
	checkButton();
}

//兼容ie和ff的取事件函数
function getEvent(){
	if(document.all)
		return window.event;//如果是ie
	func=getEvent.caller;
    while(func!=null){
        var arg0=func.arguments[0];
        if(arg0){
        	if((arg0.constructor==Event || arg0.constructor ==MouseEvent) || 
        		(typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)){
        	return arg0;
        }            }
        func=func.caller;
    }
    return null;
}

/**
 * 选择一个角色，选中该角色所具有的所有权限
 * @return
 */
function roleSelect(targetCombo){
//    projectTab.draw();
//    shopTable.draw();
    var roleID=targetCombo.getAttribute("id")
	$("#listbox").children().attr("class","list-group-item")
	$(targetCombo).attr("class","list-group-item active")
	//设置当前选中的id和type(角色、组织、岗位)
	currSelType ="role";
	currSelID = roleID;
	tree.enableThreeStateCheckboxes(false);
	//取所选角色的id：alert(myOption.options[selectIndex[0].index].value);
	//获取角色可用的资源
	requestPrivilegeAndDrawTree(roleID,"role","false");
	tree.enableThreeStateCheckboxes(true);
	
	//以下代码初始化控制变量
	//整理originalList
	originalList = tree.getAllCheckedBranches().split(",");
	//初始化addList和delList里的数据。
	addList = new ArrayList();
	delList = new ArrayList();
}

/**
 * 根据类型获取权限，并且给权限树打挑
 * @return
 */
function requestPrivilegeAndDrawTree(id,type,expandAll){
	var originalId;
	var sURL1 = "/privilege/getPageElementPrivilege.action";
	$.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		async : false,
		data : {
			type : type,
			id : id,
			isAdminRole : isAdminRole
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				//重画右侧的菜单树
				$("#menuTree").empty();  // jquery 清空原来div下的tree
				tree =new dhtmlXTreeObject("menuTree","96%","75%",0);
			    tree.setImagePath("/csh_books/");
			    //tree.attachEvent("onClick",showDetail);
			    tree.enableCheckBoxes(1);
				tree.setOnMouseInHandler(beforeOpenNode);
				tree.setOnOpenEndHandler(checkSubNodes);
				tree.setOnCheckHandler(nodeCheckHandler);
				tree.setOnClickHandler(checkButton);
			    if (expandAll == "true"){
			    	//tree.setXMLAutoLoading(webpath+"/MenuAction.do?method=getElementsByMenuItemID");
			    	tree.loadXML("/menu/getMenuTree.action?expandAll=true&showAllMenu=assignable");
			    	//把树全展开
					tree.openAllItems(null);
			    }else {
			    	tree.setXMLAutoLoading("/menu/getElementsByMenuItemID.action?showAllMenu=assignable");
			    	tree.loadXML("/menu/getMenuTree.action?showAllMenu=assignable");
			    }
			    tree.openItem("RootMenu");
			    //把树全展开
				//tree.openAllItems(null);
				
				//初始化addList和delList里的数据。
				addList = new ArrayList();
				delList = new ArrayList();

				//根据资源授权情况，在树上选中结点
				tree.enableThreeStateCheckboxes(false);
				for(var k in data.authMap) {
				  tree.setCheck(k,1);
				}
				tree.enableThreeStateCheckboxes(true);
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = "/login.jsp";
				else
					alert(data.errorMessage);
			}
			 $("#t_project tbody input[type='checkbox']").prop("checked",false);
			 $("#shopTable tbody input[type='checkbox']").prop("checked",false);
			 var arr=data.priv;
	            if(arr){
	                for(var i =0 ; i<arr.length;i++){
	                    if(arr[i].rolePrivType==0){
	                        var pchk= "input[name='chkItem'][proid='"+arr[i].privId+"']";
	                        $(pchk).attr("checked",true);
	                    }else{
	                        var schk= "input[name='chkItem'][shopid='"+arr[i].privId+"']";
	                        $(schk).attr("checked",true);
	                    }
	                }
	            }
			originalId = tree.getAllChecked(); //获取所有被选中节点的id
			checkButton();
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert(NET_FAILD);
			// 通常 textStatus 和 errorThrown 之中 
		    // 只有一个会包含信息 
		    //this;  调用本次AJAX请求时传递的options参数
		}
	});
	if(originalId == "" || originalId== null || originalId == undefined){
		originalList = "";
	}else{
		originalList = originalId.split(",");  //将初始化选中的
	}
}

/**
 * 打开一个结点以前，先检查一下结点下面是否有子结点，用于动态加载子结点后，设置check状态
 * @return
 */
function beforeOpenNode(id){
	//alert(id);
	//alert(state);
	beforeOpenSubNodes = tree.hasChildren(id);
	//alert(beforeOpenSubNodesCount);
	return true;
}
/**
 * 当用ajax打开子结点后，取这些子结点的check状态
 * @return
 */
function checkSubNodes(id,state){
	//alert(beforeOpenSubNodes);
	//alert(tree.hasChildren(id));
	//alert(state);
	//beforeOpenSubNodes = 0;
	//当点击的结点是子结点时才取
	if (beforeOpenSubNodes == 0 && state <= 0){
		var subItem;
		var sURL1 = "/privilege/getPageElementPrivilege.action";
		$.ajax( {
			url : sURL1,
			type : "post",
			dataType : "json",
			async : false,
			data : {
				type : currSelType,
				id : currSelID,
				isAdminRole : isAdminRole,
				menuID : id
			},
			success : function(data) {
				if(data.errorMessage == undefined){
					cleanSubnode(id);
					tree.enableThreeStateCheckboxes(false);
					//根据资源授权情况，在树上选中结点
					for(var k in data.authMap) {
					  tree.setCheck(k,1);
					  originalList.push(k);
					}
					tree.enableThreeStateCheckboxes(true);
				} else {
					if (data.errorMessage == "session timeout")
						window.location.href = "/login.jsp";
					else
						alert(data.errorMessage);
				}
//				var itemId = tree.getSubItems(id);
//				var itemIdList = itemId.split(",");
//				for(var i=0;i<itemIdList.length;i++){
//					if(tree.isItemChecked(itemIdList[i]) == 1)
//					{
//						originalList.push(itemIdList[i]);
//					}
//				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert(NET_FAILD);
				// 通常 textStatus 和 errorThrown 之中 
			    // 只有一个会包含信息 
			    //this;  调用本次AJAX请求时传递的options参数
			}
		});
	}
	if(beforeOpenSubNodes>0)
		return true;
	if(beforeOpenSubNodes==0 && state == -1){
		tree.openItem(id);	
	}
    beforeOpenSubNodes = 1;
	return true;
}
var nodeClickArray = new ArrayList(); //节点点击数组
var beforeOpenSubNodes2;
function checkSubNodes2(id,state){
	//记录点击过的节点，第一次单击则请求数据，然后记录；当再次点击后则不再请求数据。
	if(nodeClickArray.contains(id))
		return true;
	else{
		nodeClickArray.add(id);
		var itemColor = orgTree1.getItemColor(id);
		//通过节点颜色判断是否有操作权限
		if(itemColor.acolor == "#aaaaaa"){
			getSubUnitTreeManageable(id);
		}
	}
	if(beforeOpenSubNodes2>0)
		return true;
	if(beforeOpenSubNodes2==0 && state == -1){
		orgTree1.openItem(id);	
	}
    beforeOpenSubNodes2 = 1;
	return true;
}
function beforeOpenNode2(id){
	beforeOpenSubNodes2 = orgTree1.hasChildren(id);
	return true;
}
function getSubUnitTreeManageable(id){
	$.ajax({
		url:"/unit/getSubUnitTreeManageable.action?needStation=true",
		type:"post",
		async:false,
		dataType:"json",
		data:{id:id},
		success:function(data){
			if(data.obj.errorMessage==null || data.obj.errorMessage==undefined){
				for(var i=0;i<data.obj.length;i++){
					if(data.obj[i].MANAGEABLE != 1){
						orgTree1.showItemCheckbox(data.obj[i].UNIT_ID,false); //隐藏复选框
						orgTree1.setItemColor(data.obj[i].UNIT_ID,"#aaaaaa","#aaaaaa");//节点字体颜色置灰
					}
				}
			} else {
			    window.top.window.showModalAlert("操作失败");
//					alert(data.errorMessage);
			}
		}
	});
	
}
/**
 * 保存所选的权限
 * @return
 */
function savePrivileges(){
	//alert(currSelType + ":" + currSelID);
//	var selectedNodes = tree.getAllCheckedBranches();
//	//alert(selectedNodes);
//	if (selectedNodes == undefined || selectedNodes == "") {
//		alert("请选择要保存的结点");
//	}
	var selectedAllItem = tree.getAllCheckedBranches(); //获取所有选中节点
	//去掉最后的逗号
	//if(selectedAllItem != ""){
	//	if(selectedAllItem.substring(selectedAllItem.length -1,selectedAllItem.length) == ",")
	//		selectedAllItem = selectedAllItem.substring(0,selectedAllItem.length -1);
	//}
	var selectedAllItemList = selectedAllItem.split(",");
	
	//循环找到被选掉的节点
	var loopFlag = false;
	var node4Del;
	for(var i=0;i<originalList.length;i++){
		for(var j=0;j<selectedAllItemList.length;j++){
			if(selectedAllItemList[j] != "" && originalList[i]==selectedAllItemList[j]){
				loopFlag = true;
				break;
			}
		}
		if (!loopFlag){
			node4Del = originalList[i];
			if (node4Del != "" && !delList.contains(node4Del))
				delList.add(node4Del);
		}
		loopFlag = false;
	}
	//循环找到新选中的节点
	var node4Insert;
	loopFlag = false;
	for(var i=0;i<selectedAllItemList.length;i++){
		for(var j=0;j<originalList.length;j++){
			if(selectedAllItemList[i] != "" && selectedAllItemList[i]==originalList[j]){
				loopFlag = true;
				break;
			}
		}
		if (!loopFlag){
			node4Insert = selectedAllItemList[i];
			if (node4Insert != "" && !addList.contains(node4Insert))
				addList.add(node4Insert);
		}
		loopFlag = false;
	}
	if(isAdminRole=="true"){
	    if (currSelType == null || currSelID == null) {
	        window.top.window.showModalAlert("请选择一个保存");
	        alert(BG_PLZ_SELECT_ROLE_OR_STAT);
	        return;
	    }
	    if(addList.length <= 0 && delList.length <= 0) {
	        window.top.window.showModalAlert("没有任何修改");
	        alert(BG_DATA_NO_CHANGE);
	        return;
	    }
	}
	
	var proidString = "";
    $("#t_project input[type='checkbox']:checked").each(function(k,v){
        if(proidString==""){
            proidString=this.getAttribute('proid')+"/"+$(this).parent().next().html();
        }else if(proidString!=""){
            proidString+=","+this.getAttribute('proid')+"/"+$(this).parent().next().html();
        }
    });
    var shopString = "";
    $("#shopTable input[type='checkbox']:checked").each(function(k,v){
        if(shopString==""){
            shopString=this.getAttribute('shopid')+"/"+$(this).parent().next().html();
        }else if(shopString!=""){
            shopString+=","+this.getAttribute('shopid')+"/"+$(this).parent().next().html();
        }
    });
	
//    var arr=['55b78bfdc9ae4534bcd36354ac7f4325','ad8fba99218a44b1a67d1c8ff9247bc3','7282c57b535b4d619af5253f49ebdb72'];
//    var list=new Array();
//    for(var i =0 ; i<arr.length;i++){
//        var o=new Object();
//        o.privId=arr[i];
//        o.privName="胜多负少";
//        list.put(o)
//    }
	var sURL1 = "/privilege/savePrivileges.action";
	$.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		data : {
			type : currSelType,
			id : currSelID,
			resIDs4Add: addList.toArray().toString(),
			resIDs4Del: delList.toArray().toString(),
			isAdminRole : isAdminRole,
			proidString : proidString,
			shopString : shopString
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				window.top.window.showScoMessage('ok', '保存成功');
//				window.top.window.showModalAlert('保存成功');
			} else {
			    window.top.window.showModalAlert("保存失败");
			}
			//整理originalList
			originalList = tree.getAllCheckedBranches().split(",");
			//初始化addList和delList里的数据。
			addList = new ArrayList();
			delList = new ArrayList();
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert(NET_FAILD);
			// 通常 textStatus 和 errorThrown 之中 
		    // 只有一个会包含信息 
		    //this;  调用本次AJAX请求时传递的options参数
		}
	});
}

/**
 * 全展开
 * @return
 */
function expandAll() {
	if (currSelID == undefined || currSelID == null || currSelID == "" || currSelType == "") {
		alert("BG_PLZ_SELECT_ROLE_OR_STAT");
		return;
	}
	//获取角色可用的资源
	requestPrivilegeAndDrawTree(currSelID,currSelType,"true");
}

/**
 * 全折叠
 * @return
 */
function closeAll() {
	tree.closeAllItems(null);
}

/**
 * 全选（此方法不能提供，因为如果不让用户自己去点的话，
 * 不会记录add和delete信息，影响保存）
 * @return
 */
function checkAll() {
//	tree.enableThreeStateCheckboxes(true);
//	var temp = tree.getFirstNodeId();
//	if (temp == null || temp == undefined || temp == "")
//		return;
//	if (!checkAllState){
//		tree.setCheck(temp,1);
//		checkAllState = true;
//	}else{
//		tree.setCheck(temp,0);
//		checkAllState = false;
//	}
//	tree.enableThreeStateCheckboxes(false);
}
//点击节点时，判断是否可用
function onClickCheck(){
	var unitId = orgTree1.getSelectedItemId();
	var itemColor = orgTree1.getItemColor(unitId);
	//通过节点颜色判断是否有操作权限
	if(itemColor.acolor == "#aaaaaa"){
		$("#btnExpand").attr('disabled',true);
		$("#btnClose").attr('disabled',true);
		$("#btnSave").attr('disabled',true);
	}else{
		$("#btnExpand").attr('disabled',false);
		$("#btnClose").attr('disabled',false);
		$("#btnSave").attr('disabled',false);
	}
	checkButton();
}

/*
 * 清空子节点
 */
function cleanSubnode(nodeID){
	var itemId;
	if(nodeID)
		itemId = nodeID;
	else{
	    itemId = tree.getSelectedItemId();	
	}
	//if(itemId.indexOf("@PAGE")>0){
	if(itemId != undefined && itemId != null && itemId != ""){
		tree.enableThreeStateCheckboxes(false);
		var subItem = tree.getSubItems(itemId);
		var  sub = subItem.split(",");
		for(var i=0;i<sub.length;i++){	
	       tree.setCheck(sub[i],0);		
		}
		tree.enableThreeStateCheckboxes(true);
	}
	//}
}
function checkButton(){
	var itemId = tree.getSelectedItemId();
	if(itemId != undefined && itemId != null && itemId.indexOf("@PAGE")>0){
		$("#btnClean").attr('disabled',false);
	}else{
//		$("#btnClean").attr('disabled',true);
	}
}