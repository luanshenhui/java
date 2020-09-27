var appTable;

$(function() {
	$("#appForm").validate({
		debug : true,
		errorPlacement : function(error, element) {
			error.insertAfter(element);
		},
		rules : {
			appKey : {
				onlyIntValidate : true
			},
			appSecret : {
				onlyIntValidate : true
			}
		},
		messages : {
			appKey : "key必填,长度100位字母或数字",
			appSecret : "secret必填,长度100位字母或数字"
		}
	});

	$.validator.addMethod("onlyIntValidate", function(value, element) {
		var regx = /^[a-zA-Z0-9]/;
		return regx.test(value);
	});
	$.extend($.validator.defaults, {ignore : ""}); // 隐藏控件也校验，去掉此行不验证隐藏控件
	// 初始化表格控件
	appTable = $('#appTable').DataTable({
		"processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/appClient/appClientList.action",
            "data": function ( d ) {
                d.quickSearch = encodeURI($('#quickSearch').val());
            }
        },
        "fnDrawCallback": function (o) {
            for(var a=0;a<o.aoData.length;a++){
            	var tdlist=o.aoData[a]
            	for(b=0;b<tdlist.anCells.length-1;b++){
            		$(tdlist.anCells[b]).attr("title",$(tdlist.anCells[b]).text())
            	}
            }
        },
        "tableTools": {
            "sRowSelect": "bootstrap"
        },
        "columns": [{
        		"data": "shopName"
        	},{
                "data": "appType"
            }, {
                "data": "appKey"
            }, {
                "data": "appSecret"
            }, {
                "data": "token"
            }, {
                "data": "createTime"
            },{
                "data": "updateTime"
            },{
            	"data": "operation"
            }
        ],
        "columnDefs": [
        	{"orderable":true,
        		"targets":[0]},
        	{"orderable":true,
        		"targets":[1]},
        	{"orderable":true,
        		"targets":[2]},
        	{"orderable":true,
        		"targets":[3]},
        	{"orderable":true,
        		"targets":[4]},
        	{"orderable":true,
        		"targets":[5]},
        	{"orderable":true,
        		"targets":[6]},
        	{"orderable":false,
            	"targets":[7]}	
    ],
        "order": [[ 0, "asc" ],[ 1, "asc" ],[ 2, "asc" ],[ 3, "asc" ],[ 4, "asc" ],[ 5, "asc" ],[ 6, "asc" ]]
    });
	
	$("#addNewAppPage").on('hide.bs.modal',function(){
		window.top.window.returnCustomModalDialog();
    });
	
	// 快速搜索，点击时提交表格刷新内容
    $("#btnQuickSearch").click(function () {
    	appTable.draw();
    });
	
	$("#addAppPage").click(function(){
		addAppPage(null,null,null);
	});
	$("#btnSaveApp").click(function(){
		btnSaveApp();
	});
	$("#enterpriseId").change(function(){
		loadProject(this.value);
	});
	$("#prjId").change(function(){
		loadShop(this.value);
	});
	
	$('#quickSearch').keydown(function(e){
		if(e.keyCode==13){
			$("#btnQuickSearch").click();
		}
	});	
	
	//初始化客户端类型
	$.ajax({
	       type: "GET",
	       url: "/dictionary/getParamDictByCode.action?code=appClientType",
	       contentType: "application/json;charset=utf-8",
	       dataType: "json",
	       success: function (data) {
	           if (data.result=="success") {
	        	   $("#appType option").remove();
	        	   $("#appType").append("<option value=''>请选择</option>");
	               $.each(data.data, function (n, value) {
	            	   $('#appType').append("<option value='" + value + "'>" + value + "</option>");
	               });
	            } else {
	                window.top.window.showModalAlert(data.msg);
	            }
	        },
	        error: function (XMLHttpRequest, textStatus) {
	            if (XMLHttpRequest.status == 500) {
	                var result = eval("(" + XMLHttpRequest.responseText + ")");
	                window.top.window.showModalAlert(result.errorObject.errorText);
	            }
	        }
	   });
});

//弹出添加修改弹出框
function addAppPage(entId,prjId,shopId){
	$("#modal-header-primary-label").html("创建客户端");
	ClearInput();
	var editDialog = window.top.window.borrowCustomModalDialog($("#addNewAppPage"));
	editDialog.modal({show:true, backdrop:'static'});
	loadEnterprise(entId,prjId,shopId);
}
//下拉企业
function loadEnterprise(entId,prjId,shopId){
    $.ajax({
        type: "GET",
        url: "/enterprise/getEnterpriseList.action",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (data) {
            if (data.entName) {
            	window.top.window.$("#enterpriseId option").remove();
            	window.top.window.$("#enterpriseId").append("<option value=''>请选择</option>");
                $.each(data.entName, function (n, value) {
                	window.top.window.$('#enterpriseId').append("<option value='" + value.entId + "' shopType = '"+value.entName+"'>" + value.entName + "</option>");
                });
                if(entId){
                	window.top.window.$("#enterpriseId").val(entId);
                	loadProject(entId,prjId,shopId);
                }else{
                	loadProject(entId,null,null);
                }
            } else {
                window.top.window.showModalAlert(data.msg);
            }
        },
        error: function (XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                window.top.window.showModalAlert(result.errorObject.errorText);
            }
        }
    });
}
//加载项目
function loadProject(entId,prjId,shopId) {
	$.ajax({
		type : "GET",
		url : "/projectManager/getSelectProjectsList.action?entId="+entId,
		contentType : "application/json;charset=utf-8",
		dataType : "json",
		success : function(data) {
			if (data.result == "success") {
				window.top.window.$("#prjId option").remove();
				window.top.window.$("#prjId").append("<option value=''>请选择</option>");
				$.each(data.data, function(n, value) {
					window.top.window.$("#prjId").append("<option value='" + value.prjId + "'>"+ value.prjName + "</option>");
				});
				if(prjId){
					window.top.window.$("#prjId").val(prjId);
					loadShop(prjId,shopId);
				}else{
					loadShop(prjId,null);
				}
			} else {
				window.top.window.showModalAlert(data.msg);
			}
		},
		error : function(XMLHttpRequest, textStatus) {
			if (XMLHttpRequest.status == 500) {
				var result = eval("(" + XMLHttpRequest.responseText + ")");
				window.top.window.showModalAlert(result.errorObject.errorText);
			}
		}
	});
}

/**
 * 项目列表选择事件
 */
function loadShop(prjId,shopId){
    $.ajax({
        type: "GET",
        url: "/shop/getShopListByPrjId.action?prjId=" + prjId,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (data) {
            if (data.result == "success") {
            	window.top.window.$("#shopId option").remove();
            	window.top.window.$("#shopId").append("<option value=''>请选择</option>");
                $.each(data.data, function (n, value) {
                	window.top.window.$('#shopId').append("<option value='" + value.shopId + "' shopType = '"+value.shopType+"'>" + value.shopName + "</option>");
                });
                if(shopId){
					window.top.window.$("#shopId").val(shopId);
				}
            } else {
                window.top.window.showModalAlert(data.msg);
            }
        },
        error: function (XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                window.top.window.showModalAlert(result.errorObject.errorText);
            }
        }
    });
}
/**
 * 保存和修改app按钮事件
 * @returns
 */
function btnSaveApp(){
	window.top.window.returnCustomModalDialog();
	 // 输入有效性验证
	if(!$("#appForm").valid()) {
    	// 父窗体借用本页的编辑对话框
    	window.top.window.borrowCustomModalDialog($("#addNewAppPage"));
		return false;
	}
	$.ajax( {
		url : "/appClient/saveApp.action",
		type : "post",
		data : {
			appId : $("#appId").val(),
			shopId : $("#shopId").val(),
			appKey : $("#appKey").val(),
			appSecret : $("#appSecret").val(),
			token : $("#token").val(),
			shopName : $("#shopId").find("option:selected").text(),
			appType : $("#appType").val(),
		},
		success : function(data) {
			if(data == "success"){
				var div=window.top.window.borrowCustomModalDialog($("#addNewAppPage"));
				div.modal('hide');
				window.top.window.showScoMessage('ok', '操作成功');
            	$('#appTable').DataTable().ajax.reload(null, false);
			} else {
			    window.top.window.showModalAlert("操作失败");
			}
		}
	});
}

//页面修改事件
function update(id,e){
	ClearInput();
	$.ajax( {
		url : "/appClient/getAppDetail.action?id="+id,
		type : "get",
		dataType: "json",
		success : function(data) {
			if(data.result=="success"){
				addAppPage(data.data.entId,data.data.prjId,data.data.shopId);
				window.top.window.$("#appId").val(data.data.appId);
				window.top.window.$("#appKey").val(data.data.appKey);
				window.top.window.$("#appSecret").val(data.data.appSecret);
				window.top.window.$("#token").val(data.data.token);
				window.top.window.$("#appType").val(data.data.appType);
				window.top.window.$("#modal-header-primary-label").html("修改客户端");
			}else{
				window.top.window.showModalAlert(data.msg);
			}
		}
	});
}

//页面删除事件
var appid;
function deleteApp(id,e){
	appid=id;
	window.top.window.showModalConfirm( "确定要删除？", delconfirm);
}

function delconfirm(){
	$.ajax( {
		url : "/appClient/deleteApp.action?id="+appid,
		type : "get",
		success : function(data) {
			if(data == "success"){
				window.top.window.showScoMessage('ok', '删除成功');
            	$('#appTable').DataTable().ajax.reload(null, false);
			} else {
			    window.top.window.showModalAlert("删除失败");
			}
		}
	});
}

//清除验证记录
function ClearInput() {  
	$("#appId").val("");
	$("#enterpriseId").val("");
	$("#prjId").val("");
	$("#shopId").val("");
	$("#appType").val("");
	$("#appKey").val("");
	$("#appSecret").val("");
	$("#token").val("");
    //清空输入域  
   var validator = $("#appForm").validate({  
        submitHandler: function (form) {  
            form.submit();  
        }  
    });  
    validator.resetForm();  
    $('#appForm .state-error').removeClass('state-error');
    $('#appForm .state-success').removeClass('state-success');
}
