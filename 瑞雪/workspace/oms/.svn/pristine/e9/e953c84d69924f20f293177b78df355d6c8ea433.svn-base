var selectOrgTable="";
var selectOrgTable2="";
$(function () {
//	selectOrgTable = $('#selectOrgTable').DataTable({
//		"processing": true,
//        "serverSide": true,
//        "destroy":true,
//        "autoWidth": false,
//        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
//        "dom": '<"bottom"rtflp>',
//        "searching": false,
//        "pagingType": "full_numbers",
//        "deferRender": true,
//        "ajax": {
//            "url": "/role/getRole.action?isAdminRole=false",
//            "data": function ( d ) {
//            	var quickItemSearch = "";
//            	if (typeof($('#quickItemSearch').val())!='undefined'){
//            		quickItemSearch = encodeURI($('#quickItemSearch').val());
//            	} else {
//            		quickItemSearch = encodeURI(window.top.window.$('#quickItemSearch').val());
//            	}
//                d.quickSearch = quickItemSearch;
//            }
//        },
//        "tableTools": {
//            "sRowSelect": "bootstrap"
//        },
//        "columns": [
//        	{"data": "chk"}, 
//        	{"data": "roleName"}, 
//        	{"data": "roleDescription"}, 
//        	{"data": "isAdminrole"}
//        ],
//        "order": [[ 1, "asc" ]]
//    });
	
//	selectOrgTable2 = $('#selectOrgTable2').DataTable({
//		"processing": true,
//        "serverSide": true,
//        "destroy":true,
//        "autoWidth": false,
//        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
//        "dom": '<"bottom"rtflp>',
//        "searching": false,
//        "pagingType": "full_numbers",
//        "deferRender": true,
//        "ajax": {
//            "url": "/role/getRole.action?isAdminRole=false",
//            "data": function ( d ) {
//            	var quickItemSearch = "";
//            	if (typeof($('#quickItemSearch').val())!='undefined'){
//            		quickItemSearch = encodeURI($('#quickItemSearch').val());
//            	} else {
//            		quickItemSearch = encodeURI(window.top.window.$('#quickItemSearch').val());
//            	}
//                d.quickSearch = quickItemSearch;
//            }
//        },
//        "tableTools": {
//            "sRowSelect": "bootstrap"
//        },
//        "columns": [
//        	{"data": "chk"}, 
//        	{"data": "roleName"}, 
//        	{"data": "roleDescription"}, 
//        	{"data": "isAdminrole"}
//        ],
//        "order": [[ 1, "asc" ]]
//    });
	
	 $('#selectUnit').click(function () {
		 selectUnit();
	 })
	
});

/*
 * 获取组织类型
 * */
function getUnitType(){
    jQuery.ajax({
        url:"/unit/getUnitType.action",
        type:"post",
        dataType:"json",
        data:{type:"unittype"}, //unittype在数据库wf_org_dictionary表中写死的字段值
        success:function(data)
                {
                 window.top.window.returnCustomModalDialog();
                   for(i=0;i<=data.eleType.length;i++){
                        if (i==0){
                            document.getElementById("orgTypeSelect").options[i] = new Option("","");
                        }else{
                            document.getElementById("orgTypeSelect").options[i] = new Option(data.eleType[i-1].DICT_NAME,data.eleType[i-1].DICT_CODE);
                        }       
                   }
                   var editDialog = window.top.window.borrowCustomModalDialog($("#FrameUnitOrg"));
                   editDialog.modal({show:true, backdrop:'static'});
                }
    });
}

/*
 * 保存数据
 * */
function save(){
	//有效性检验
	var returnValue;
	if (checkValidate()&& checkExtendDetail() ){
		returnValue = saveFormElement();
		return returnValue;
	}else{
		returnValue = "false";
	}
	return returnValue;
}

/*
 * 检验数据
 * */
function checkValidate(){
	if(!jQuery("#unitDetail").valid())return false;
	
//	var detailForm;
//	eval('detailForm = document.unitDetail');
//	if(!g_check.checkForm(detailForm)){
//		//alert(g_check.message);
//		return false;
//	}
	
//	if (jQuery("#orgName").val()==null || jQuery("#orgName").val()==""){
//		jQuery("#tabs").tabs('select', 0); //tab切换，0 是tab的索引，索引从0开始
//		alert(UNIT_FILL_ORGUNITNAME);
//		jQuery("#orgName").focus();
//		return false;
//	}else {
//		var leng = jQuery("#orgName").val().replace(/[^\x00-\xff]/g,"**").length;
//		if(leng>32){
//			jQuery("#tabs").tabs('select', 0); 
//			alert(UNIT_TEXT_TOO_LONG);
//			jQuery("#orgName").focus();
//			return false ;
//	}
//	if(jQuery("#orgDes").val().replace(/[^\x00-\xff]/g,"**").length>255){
//		jQuery("#tabs").tabs('select', 0); 
//		alert(UNIT_TEXT_TOO_LONG);
//		jQuery("#orgDes").focus();
//		return false ;
//	}
////	if (jQuery("#orgType").val()==null || jQuery("#orgType").val()==""){
////		alert("组织类型");
////		return false;
////	}	
//    }
	return true;
}

//var flagType ; // 区分新增保存和修改保存，新增保存为0，修改保存为1
//var unitId; //新增页面：所选节点的父节点id；修改页面：选择修改节点的id
var stationId;//上级领导岗位id
/*
 * 新增保存和修改保存
 * */

function leftList(){
	selectOrgTable = $('#selectOrgTable').DataTable({
	"processing": true,
    "serverSide": true,
    "destroy":true,
    "autoWidth": false,
    "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
    "dom": '<"bottom"rtflp>',
    "searching": false,
    "pagingType": "full_numbers",
    "deferRender": true,
    "ajax": {
        "url": "/role/getRole.action?isAdminRole=false",
        "data": function ( d ) {
        	var quickItemSearch = "";
        	if (typeof($('#quickItemSearch').val())!='undefined'){
        		quickItemSearch = encodeURI($('#quickItemSearch').val());
        	} else {
        		quickItemSearch = encodeURI(window.top.window.$('#quickItemSearch').val());
        	}
            d.quickSearch = quickItemSearch;
        }
    },
    "tableTools": {
        "sRowSelect": "bootstrap"
    },
    "columns": [
    	{"data": "chk"}, 
    	{"data": "roleName"}, 
    	{"data": "roleDescription"}, 
    	{"data": "isAdminrole"}
    ],
    "order": [[ 1, "asc" ]]
});
}

function saveFormElement(){
    window.top.window.returnCustomModalDialog();
    if(!$("#userOrgDetailForm").valid()) {
        // 父窗体借用本页的编辑对话框
        window.top.window.borrowCustomModalDialog($("#FrameUnitOrg"));
        return false;
    }
    if(!$("#orgName").val() || $("#orgName").val()==""){
        return false;
    }
    var userIds=getUserID();
    var flagType =$("#sendflag").val();
    var returnValue;
    if (flagType == 0||flagType == "0"){
         var name = jQuery("#orgName").val();
         var des = jQuery("#orgDes").val();
         var sta = jQuery("#stationIdHidden").val();
         var id = $("#sendunitId").val();
         var maxPerson = $("#maxPerson").val();
         var entId = $("#ent").val();
         if(!id || id==""){
             return ("id为空")
         }
         var type = jQuery("#orgTypeSelect").find("option:selected").text();
         var entName = jQuery("#ent").find("option:selected").text();
         var userID=userIds;
         //序列化扩展信息
         var extInfo="";
//       var extInfo = jQuery("form").serialize();
//       extInfo = decodeURIComponent(extInfo,true);//对序列后信息进行解码，以解决乱码问题。但是时间中的空格问题无法解决
         var sURL = "/unit/saveUnit.action";
         //调用AJAX请求函数   
         jQuery.ajax({
                url:sURL,
                type:"post",
//              async: false,
                dataType:"text",
                data:{orgName:name,orgDes:des,orgSta:sta,orgType:type,id:id,userId:userID,flag:"0",maxPerson:maxPerson,entId:entId,entName:entName,extInfo:extInfo
                        },
                success:function(data){
                    tree.refreshItem(id);
                    var div=window.top.window.borrowCustomModalDialog($("#FrameUnitOrg"));
                    div.modal('hide');
                }   
            });
    }
    if(flagType == 1||flagType == "1"){
        var name = jQuery("#orgName").val();
        var des = jQuery("#orgDes").val();
        var sta = jQuery("#stationIdHidden").val();
        var unitId = $("#sendunitId").val();
        var maxPerson = $("#maxPerson").val();
        var entId = $("#ent").val();
        //var sta = stationId;
        var type = jQuery("#orgTypeSelect").find("option:selected").text();
        var entName = jQuery("#ent").find("option:selected").text();
        var userID=userIds;
//       var extInfo = jQuery("form").serialize();
//       extInfo = decodeURIComponent(extInfo,true);//对序列后信息进行解码，以解决乱码问题。但是时间中的空格问题无法解决
        var sURL = "/unit/saveUnit.action";
         //调用AJAX请求函数   
         jQuery.ajax({
                url:sURL,
                type:"post",
//              async: false,
                dataType:"text",
                data:{orgName:name,orgDes:des,orgSta:sta,orgType:type,id:unitId,userId:userID,flag:"1",maxPerson:maxPerson,entId:entId,entName:entName,extInfo:extInfo},
                success:function(data){
                        var newLabel = name;
                        var newTooltip = name;
                        tree.setItemText(unitId, newLabel, newTooltip);
                        var div = window.top.window.borrowCustomModalDialog($("#FrameUnitOrg"));
                        div.modal('hide');
                }   
            });
    }
}
/*
 * 获取组织树
 * */
var nodeId; //组织树 id
function unitSelectCallback(orgValue){
	if (orgValue != null){	    				    			
	    jQuery("#org").val(orgValue.itemText);
	    nodeId = orgValue.itemId;
		var queryPara={"itemId" : nodeId};
		ECSideUtil.queryECForm("table1",queryPara,true);
	}
}
//清空父岗位
function emptyUnitSelect(){
	jQuery("#org").val("");
	//什么也查不到
	var queryPara={"itemId" : "doraymefarsolaxi"};
	ECSideUtil.queryECForm("table1",queryPara,true);
}
//清空父岗位
function emptyStation(){
	jQuery("#orgSta").val("");
	jQuery("#stationIdHidden").val("");
}
/*
 * 获取上级领导岗位
 * */
function showSta(){
//	window.parent.showSta();
	var sURL = webpath + "/view/organization/unit/StationSelect.jsp";
	window.parent.dialogPopup_L3(sURL,UNIT_LEADER_STATION,300,520,true,"save",null,stationSelectCallback,emptyStation);
//	document.getElementById("staFrame").src=sURL;				
//	jQuery("#staDialog").dialog('open');
//	var orgValue = window.showModalDialog('./StationSelect.jsp',null,'dialogWidth=510px;status:no;scroll:no;dialogHeight=380px');
//	if (orgValue != null){
//		jQuery("#orgSta").val(orgValue.itemText); 
//		stationId = orgValue.itemId;
//	}	
}
function stationSelectCallback(returnObj){
	if (returnObj != null){	
	    jQuery("#orgSta").val(returnObj.itemText);
	    jQuery("#stationIdHidden").val(returnObj.itemId);
	}
	
	
}
/*
 * 修改  显示详细信息 
 * */
function showDetail(unitId){
    getUnitType();
    jQuery.ajax({
        url:"/unit/getUnitDetail.action",
        type:"post",
        dataType:"json",
        contentType:'application/x-www-form-urlencoded',
        encoding:'UTF-8',
        data:{itemId:unitId,flag:"1"},
        success:function(data){
                    if(data){
                        window.top.window.returnCustomModalDialog();
                        jQuery("#orgName").val(data.unitDetail.unitName);
                        jQuery("#orgDes").val(data.unitDetail.unitDescription);
                        jQuery("#orgSta").val(data.unitDetail.stationName);
                        jQuery("#maxPerson").val(data.unitDetail.maxPerson);
                        jQuery("#maxPersonValue").val(data.unitDetail.maxPerson);
                        jQuery("#ent").val(data.unitDetail.entId);
                        stationId = data.unitDetail.stationId;
                        jQuery("#stationIdHidden").val(stationId);
                        unitId = data.unitDetail.unitId;
                        for(var k=0;k<$("#orgTypeSelect")[0].options.length;k++){
                            if($("#orgTypeSelect")[0].options[k].text == data.unitDetail.unitType){
                                $("#orgTypeSelect")[0].options[k].selected=true;            
                            }
                        }   
                        for(var k=0;k<data.userDetail.length;k++){
                            var tr="<tr role='row' class='odd'><td><input id='chkItem' name='chkItem' type='checkbox' userid="+
                            data.userDetail[k].userId+"></td><td class='sorting_1'>"+data.userDetail[k].userAccount+"</td><td>"+data.userDetail[k].userFullname+"</td></tr>"                        
                            $("#newtbody").append(tr);
                        }       
                        var editDialog = window.top.window.borrowCustomModalDialog($("#FrameUnitOrg"));
                        editDialog.modal({show:true, backdrop:'static'});
                    }
                }               
    }); 
}

/*
 * 选择用户移入
 * */
function input(){
	var cheVal = ECSideUtil.getPageCheckValue("checkId");
	if(cheVal.length==0){
		alert(UNIT_SELECT_DATA);
		return;
	}	
	var obj = document.getElementById("table2").getElementsByTagName("input");
	var num = 0;
	var array = new Array();
	for(var m=0;m<obj.length;m++){
		if(obj[m].type == "checkbox"){
			for(var z=0;;z++){
			    array[z]=obj[m].value;
			}
		}	
	}	
	if(array.length==0){
		moveLiftToRight();
	}
	for(var w=0;w<cheVal.length;w++){
		for(var x=0;x<array.length;x++)
		if(cheVal[w].value == array[x]){
			moveLiftToRight();
		}
	}		

	ECSideUtil.refresh("table2");
     
}

/*
 * 选择用户移入
 * */
function moveLeftToRight(){
	var checkebox = ECSideUtil.getCheckedBox("checkId"); 
	var ecsideObj =ECSideUtil.getGridObj("table2");
	for(var i = 0;i<checkebox.length;i++){
		if(!isRecordExist("table2",checkebox[i].value)){
		    var selROW = checkebox[i].parentNode.parentNode;
			var rowsNum=0;
			if (ecsideObj.ECListBody.rows){
				rowsNum=ecsideObj.ECListBody.rows.length;
			}
			var newTr=ecsideObj.ECListBody.insertRow(rowsNum);
			ECSideUtil_addEvent( newTr,"click", ECSideUtil.selectRow.bind(this,newTr,ecsideObj.id) );
			//newTr.rows = selROW.rows;
			newTr.className="add";
			var cells=[];
			for (var j=0;j<ecsideObj.columnNum;j++ ){
				cells[j]=newTr.insertCell(j);
				//表格宽度目前是写死的
				if(j == 0)
					cells[j].width="53";
				if(j == 1)
					cells[j].width="165";
				if(j == 2)
					cells[j].width="96";
				cells[j].style.textAlign = "center";
				cells[j].innerHTML=selROW.cells[j].innerHTML;
				if(j==0){
					cells[0].children[0].checked = false;
					cells[0].children[0].id="checkId2";
					cells[0].children[0].name="checkId2";
				}
			}
			var topTr=ECSideUtil.getPosTop(newTr);
			if (ecsideObj.ECListBodyZone){
				ecsideObj.ECListBodyZone.scrollTop=topTr;
			}	
		}
	}
}

/*
 * 判断右侧表格中，是否已经存在一个同样的记录
 * */
function isRecordExist(tableId,rowID){
	var flag = false;
	var returnValue;
	var ecsideObj=ECSideUtil.getGridObj(tableId);
	var listBody = ecsideObj.ECListBody.rows;
	for(j=0; j<listBody.length; j++){
		if(listBody[j].cells[0].children[0]){
			var tempID = listBody[j].cells[0].children[0].value;
			// alert(rowID + ":" + tempID);
			if (tempID == rowID){
				flag = true;
				break;
			}
		}
	}
	return flag;
}

/*
 * 获取右侧列表中的用户ID
 * */
var userIdStr="";
function getUserId(){
	//循环TABLE2中的所有元素，找checkbox
	var str = "";
	var f=0;
	var obj = document.getElementById("table2").getElementsByTagName("input");
	for(i=0; i<obj.length;i++){
		if(document.getElementById("table2").getElementsByTagName("input")[i].type=="checkbox"){			
			//var s = document.getElementById("table2").getElementsByTagName("input")[i].value;
			f=f+1;
			if(f==1){
				str = document.getElementById("table2").getElementsByTagName("input")[i].value;
				continue;
			}else{
				str += ",";
			}
			str += document.getElementById("table2").getElementsByTagName("input")[i].value;
		}
	}
	userIdStr = str;
}

/*
 * 移出选择用户 
 * */
function outPut(){	
	var object = document.getElementById("table2").getElementsByTagName("input");
	//倒着删除，以避免删除内容后引起object.length变化倒着有些数据无法删除
	for(i=object.length-1; i>=0;i--){
		if(object[i].type=="checkbox" && object[i].checked){  //根据checked属性true或false判断是否选中
		  object[i].parentNode.parentNode.parentNode.removeChild(object[i].parentNode.parentNode);//删除选中节点
		//obj[i].parentNode.parentNode.innerHTML=obj[i].parentNode.parentNode.removeChildren();
		}
	}
	//是否应该把table2上的checkbox不选中
	var ecsideObj =ECSideUtil.getGridObj("table2");
	var rowsNum=0;
	if (ecsideObj.ECListBody.rows){
		rowsNum=ecsideObj.ECListBody.rows.length
	}
	if (rowsNum <= 1){
		//表头上的checkbox图片。
		if(ecsideObj.ECListHead.rows[0].cells[0].children[1].children[0].className){
			if(ecsideObj.ECListHead.rows[0].cells[0].children[1].children[0].className == "checkedboxHeader")
				ecsideObj.ECListHead.rows[0].cells[0].children[1].children[0].className = "checkboxHeader";
		}
	}
	//over
}

function reFreshTable(orgValue){
	jQuery("#org").val(orgValue.itemText); 
	nodeId = orgValue.itemId;
    var queryPara={"itemId" : nodeId};
    ECSideUtil.queryECForm("table1",queryPara,true);
}