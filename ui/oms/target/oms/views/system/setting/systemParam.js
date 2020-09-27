// 店铺Datatable
var shopTable;
// 正在操作的“店铺ID”
var opShopId="";

/**
 * 页面初始化
 */
$(function () {
	// 输入有效性验证
	$("#formShopTypeSelect,#validateForm,#shopDetailForm").validate({
		debug:true,
        errorPlacement: function(error, element)
        {
            error.insertAfter(element);
        }
    });
	// 开始时间大于当前时间校验
	$.validator.addMethod("greaterThenNow", function(value, element) {
        var beginTime = $("#expireTime").val();
        var endTime = new Date(); //现在
        var reg = new RegExp('-','g');
        beginTime = beginTime.replace(reg,'/');//正则替换
        beginTime = new Date(parseInt(Date.parse(beginTime),10));
        if(beginTime < endTime) {
            return false;
        } else {
            return true;
        }
    }, "“到期时间”必须大于当前时间");
	// 结束时间大于开始时间日期校验
	$.validator.addMethod("compareDate",function(value,element) {
        var beginTime = $("#startTime").val();
        var endTime = $("#expireTime").val();
        var reg = new RegExp('-','g');
        beginTime = beginTime.replace(reg,'/');//正则替换
        endTime = endTime.replace(reg,'/');
        beginTime = new Date(parseInt(Date.parse(beginTime),10));
        endTime = new Date(parseInt(Date.parse(endTime),10));
        if(beginTime>endTime) {
            return false;
        } else {
            return true;
        }
    }, "“作业到期时间”必须大于“作业开始时间”");
	$.extend($.validator.defaults,{ignore:""}); //隐藏控件也校验，去掉此行不验证隐藏控件
	
	// 初始化表格控件
    shopTable = $('#shopTable').DataTable({
    	"processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/shop/shopList.action",
            "data": function ( d ) {
                d.quickSearch = encodeURI($('#quickSearch').val());
            }
        },
        "tableTools": {
            //"sSwfPath": "/js/datatables/tabletools/swf/copy_csv_xls_pdf.swf", // 表格导出，需要flash支持
            "sRowSelect": "bootstrap"
        },
        "columns": [{
                "data": "shopName"
            }
        ],
        
        "order": [[ 5, "desc" ],[ 0, "asc" ]]
    });
    
    // 快速搜索，点击时提交表格刷新内容
    $("#btnQuickSearch").click(function () {
        shopTable.draw();
    });
    
    // 店铺修改，保存按钮点击事件绑定
    $("#btnShopDetailSave").click(function(){
    	updateShop();
    });
    
	// 编辑对话框关闭事件发生
    $('#modalEdit').on('hide.bs.modal', function () {
    	// 父窗体归还本页的编辑对话框
    	window.top.window.returnCustomModalDialog();
    })
    
    // 搜索框的回车事件
    $('#quickSearch').keydown(function(e){
		if(e.keyCode==13){
			$("#btnQuickSearch").click();
		}
	});
    
    /************ 创建店铺向导窗口 ***********/
    $('#rootwizard-custom-circle').bootstrapWizard({
        onTabShow: function(tab, navigation, index) {
        	if (index == 3) {
        		$("#btnShopWizardOK").removeClass("hidden");
        		//$(".button-previous").removeClass("hidden");
        		$(".button-next").addClass("hidden");
        	} else {
        		$("#btnShopWizardOK").addClass("hidden");
        		//$(".button-previous").removeClass("hidden");
        		$(".button-next").removeClass("hidden");
        	}
            var $total = navigation.find('li').length;
            var $current = index+1;
            var $percent = ($current/$total) * 100;
            $('#rootwizard-custom-circle').find('.bar').css({width:$percent+'%'});
        },
        'onNext': function(tab, navigation, index) {
            // 输入有效性验证
        	if(!$("#formShopTypeSelect").valid()) {
        		 return false;
        	}
        	if(!$("#validateForm").valid()) {
        		$('#rootwizard-custom-circle').bootstrapWizard('show',1);
        		return false;
        	}
        	
        	// 检测店铺名称+店铺类型是否唯一
    		if (!isShopUnique(index)) {
            	window.top.window.showModalAlert("店铺名称 + 店铺类型不唯一");
        		return false;
    		}
        },
        'onTabClick': function(tab, navigation, index) {
            // 输入有效性验证
        	if(!$("#formShopTypeSelect").valid()) {
	       		return false;
	       	}
	       	if(!$("#validateForm").valid()) {
	       		$('#rootwizard-custom-circle').bootstrapWizard('show',1);
	       		return false;
	       	}
	       	
        	// 检测店铺名称+店铺类型是否唯一
//    		if (!isShopUnique(index)) {
//            	window.top.window.showModalAlert("店铺名称 + 店铺类型不唯一");
//        		return false;
//    		}
            // Add class visited to style css
            if (tab.attr("class")=="visited"){
                tab.removeClass("visited");
            } else {
                tab.addClass("visited");
            }
        },
        'tabClass': 'bwizard-steps-o','nextSelector': '.button-next', 'previousSelector': '.button-previous'
    });
    
    // 初始化项目列表
    $.ajax({
        type:"GET",
        url:"/projectManager/getAllAvailableProjects.action",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success:function(data) {
            if (data.result == "success") {
            	$("#prjId option").remove();
            	$("#prjId1 option").remove();
            	$("#prjId").append("<option value=''>请选择</option>");
            	$("#prjId1").append("<option value=''>请选择</option>");
                $.each(data.data, function (n, value) {
                    $("#prjId").append("<option value='" + value.prjId + "'>" + value.prjName + "</option>");
                    $("#prjId1").append("<option value='" + value.prjId + "'>" + value.prjName + "</option>");
                });
            } else {
            	window.top.window.showModalAlert(data.msg);
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
});

/**
 * 检测店铺名称+店铺类型唯一性
 * @param index
 * @returns true唯一，false不唯一
 */
function isShopUnique(index){
	var returnResult = false;
	if (index != 2) {
		return true;
	}
	var shopName = encodeURI(encodeURI($('#shopName').val()));
	var shopType = encodeURI(encodeURI($('#shopType').val()));
    $.ajax({
        type:"GET",
        url:"/shop/isShopUnique.action?shopName=" + shopName + "&shopType=" + shopType,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success:function(data) {
            if (data) {
            	returnResult = true;
            } else {
            	returnResult = false;
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
            	window.top.window.showModalAlert(result.errorObject.errorText);
            }
            returnResult = false;
        }
    });
    return returnResult;
}

/**
 * 保存新店铺
 * @returns
 */
function shopWizardFinish() {
    var prjId = $('#prjId').val();
    var shopName = $('#shopName').val();
    var shopAccount = $('#shopAccount').val();
    var shopPassword = $('#shopPassword').val();
    var shopType = $('#shopType').val();
    var enable = $('#enable').val();
    var data = {
        "prjId":prjId,
        "shopType": shopType,
        "shopName": shopName,
        "shopAccount": shopAccount,
        "shopPassword": shopPassword,
        "enable": enable
    };
    
    $.ajax({
        type:"POST",
        url:"/shop/addShop.action",
        data:JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success:function(data) {
            if (data.result == "success") {
            	$('#newShopWizard').modal('hide');
            	window.top.window.showScoMessage('ok', '保存成功');
            } else{
            	window.top.window.showModalAlert(data.msg);
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
	shopTable.draw();
}

/**
 * 弹出创建店铺向导
 * @returns
 */
function newShopWizard() {
	$('#rootwizard-custom-circle').bootstrapWizard('show',0);
	$("#prjId").val("");
	$("#shopType").val("");
	$("#shopName").val("");
	$("#shopAccount").val("");
	$("#shopPassword").val("");
}

/**
 * 删除提示
 * @param btnDelete
 * @returns
 */
function operationDelete(btnDelete){
	opShopId = $(btnDelete).attr("shopid");
	window.top.window.showModalConfirm("确定要删除店铺吗？", doDelete);
}

/**
 * 执行删除店铺操作
 * @returns
 */
function doDelete() {
	if (opShopId == "") {
		return;
	}
    $.ajax({
        type:"POST",
        url:"/shop/deleteShop.action?shopId=" + opShopId,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success:function(data) {
            if (data.result == "success") {
            	window.top.window.showScoMessage('ok', '删除成功');
            } else{
            	window.top.window.showModalAlert(data.msg);
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
    opShopId = "";
    shopTable.draw();
}

// 确认操作提示
var strOperation = "";
/**
 * 启用、停用操作点击
 * @param btnEnable
 * @returns
 */
function operationEnable(btnEnable) {
	opShopId = $(btnEnable).attr("shopid");
	var content = "";
	if ($(btnEnable).text().indexOf("启用") > 0) {
		content = "是否确认启用该店铺？";
		strOperation = "setEnable";
	} else {
		content = "停用店铺将停止该店铺所有系统作业，是否确认停用？";
		strOperation = "setDisable";
	}
	window.top.window.showModalConfirm(content, doEnable);
}

/**
 * 具体执行启用、停用操作
 * @returns
 */
function doEnable() {
	if (opShopId == "") {
		return;
	}
	
    $.ajax({
        type:"POST",
        url:"/shop/" + strOperation + ".action?shopId=" + opShopId,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success:function(data) {
            if (data.result == "success") {
            	window.top.window.showScoMessage('ok', '成功');
            } else{
            	window.top.window.showModalAlert(data.msg);
            }
            shopTable.draw();
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
}

/**
 * 编辑按钮点击
 * @param btnEdit
 * @returns
 */
function operationEdit(btnEdit) {
	$("#shopDetailForm")[0].reset();
	opShopId = $(btnEdit).attr("shopid");

    // 初始化项目列表
    $.ajax({
        type:"GET",
        url:"/shop/shopDetail.action?shopId=" + opShopId,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success:function(data) {
            if (data.result == "success") {
            	$("#modalEdit").attr("shopid", opShopId);
            	$("#prjId1").val(data.data.prjId);
            	$("#shopName1").val(data.data.shopName);
            	$("#shopType1").val(data.data.shopType);
            	$("#shopTypeDetail").val(data.data.shopTypeDetail);
            	$("#startTime").val(data.data.startTime);
            	$("#expireTime").val(data.data.expireTime);
            	$("#remark").val(data.data.remark);
            	
            	// 父窗体借用本页的编辑对话框
            	var editDialog = window.top.window.borrowCustomModalDialog($("#modalEdit"));
            	editDialog.modal({show:true, backdrop:'static'});
            } else{
            	window.top.window.showScoMessage('ok', data.msg);
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
}

/**
 * 保存新店铺
 * @returns
 */
function shopWizardFinish() {
    var prjId = $('#prjId').val();
    var shopName = $('#shopName').val();
    var shopAccount = $('#shopAccount').val();
    var shopPassword = $('#shopPassword').val();
    var shopType = $('#shopType').val();
    var enable = $('#enable').val();
    var data = {
        "prjId":prjId,
        "shopType": shopType,
        "shopName": shopName,
        "shopAccount": shopAccount,
        "shopPassword": shopPassword,
        "enable": enable
    };
    
    $.ajax({
        type:"POST",
        url:"/shop/addShop.action",
        data:JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success:function(data) {
            if (data.result == "success") {
            	$('#newShopWizard').modal('hide');
            	window.top.window.showScoMessage('ok', '创建店铺成功');
            } else{
            	window.top.window.showModalAlert(data.msg);
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
	shopTable.draw();
}

/**
 * 保存店铺
 * @returns
 */
function updateShop() {
	// 父窗体归还本页的编辑对话框
	window.top.window.returnCustomModalDialog();
	
	var shopId = $("#modalEdit").attr("shopid");
	if (shopId == undefined || shopId == null || shopId == "") {
		window.top.window.borrowCustomModalDialog($("#modalEdit"));
		window.top.window.showModalAlert("未指定店铺");
		return false;
	}
	
    // 输入有效性验证
	if(!$("#shopDetailForm").valid()) {
    	// 父窗体借用本页的编辑对话框
    	window.top.window.borrowCustomModalDialog($("#modalEdit"));
		return false;
	}
	
	var prjId = $("#prjId1").val();
    var shopName = $("#shopName1").val();
    var shopType = $("#shopType1").val();
    var shopTypeDetail = $("#shopTypeDetail").val();
    var startTime = $("#startTime").val();
    var expireTime = $("#expireTime").val();
    var remark = $("#remark").val();
    
    var data = {
    	"shopId":shopId,
    	"prjId":prjId,
        "shopType": shopType,
        "shopTypeDetail": shopTypeDetail,
        "shopName": shopName,
        "startTime": startTime,
        "expireTime": expireTime,
        "remark": remark
    };
    
    $.ajax({
        type:"POST",
        url:"/shop/updateShop.action",
        data:JSON.stringify(data),
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false, // 同步
        success:function(data) {
            if (data.result == "success") {
            	$('#modalEdit').modal('hide');
            	window.top.window.showScoMessage('ok', '修改成功');
            } else{
            	window.top.window.showModalAlert(data.msg);
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
	shopTable.draw();
}
