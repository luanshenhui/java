var messageTable;
var shopTable;
var checkedShop;
var messageID;
var enableValue;
var btnAdvSearchflg= false;
var hasAdmin=false;
$(function(){
//	$.extend($.validator.defaults, {ignore : ""}); // 隐藏控件也校验，去掉此行不验证隐藏控件
	// 初始化表格控件

        $("#searchForm").validate({
            debug : true,
            errorPlacement : function(error, element) {
                error.insertAfter(element);
            },
	        rules : {
	            msgCode : {  
	                required : true  
	            },  
	            msgName : {  
	                required : true  
	            },  
	            sendWay : {  
                    required : true  
                },  
                title : {  
                    required : true  
                },  
                retries : {  
                    required : true  
                },  
                retryInterval : {  
                    required : true  
                },  
                template : {  
                    required : true  
                }
	        },
	        messages : {
	            msgCode : "消息编码不能为空，1-32位字符!",
	            msgName : "消息名称不能为空，1-50位字符!",
	            sendWay : "发送方式不能为空!",
	            title : "标题不能为空，1-128位字符!",
	            retries : "重复次数不能为空，数字0~99999999999!",
	            retryInterval : "重试间隔不能为空，1-50位字符!",
	            template : "消息模板不能为空，1-2000位字符!"
	        }
	    });
	
	
	messageTable = $('#messageTable').DataTable({
        "processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/messageDefine/messageDefineList.action",
            "data": function ( d ) {
                     if ($("#advSearchPanel").is(":hidden")) {
                         d.quickSearch = encodeURI($('#quickSearch').val());
                         
                     }
                     else {
                         // 高级查询条件
                         var gEnable = encodeURI($('#gEnable').val());
                         var gTitle =encodeURI($('#gTitle').val());
                         var gSendWay =encodeURI($('#gSendWay').val());
                         var advData = {
                             "enabled": gEnable,
                             "title": gTitle,
                             "sendWay": gSendWay
                         };
                         d.formJson = JSON.stringify(advData);
                     }
                    
            }
        },"fnDrawCallback": function (oSettings) {
            console.log(oSettings.json.hasAdmin);
            hasAdmin = oSettings.json.hasAdmin;
            if(hasAdmin){
                $("#addMessagePage").show();
            }else{
                $("#addMessagePage").hide();
            }
        },
        "tableTools": {
            "sRowSelect": "bootstrap"
        },
        "columns": [ {
                "data": "msgCode"
            }, {
                "data": "msgName"
            }, {
                "data": "enabled"
            }, {
                "data": "title"
            }, {
                "data": "sendWay"
            }, {
                "data": "operation"
            }
        ],
        "columnDefs": [{
                "orderable":false,
                "targets":[2]
            },{
                "orderable":false,
                "targets":[3]
            },{
                "orderable":false,
                "targets":[4]
            },{
                "orderable":false,
                "targets":[5]
            }
        ],
        "order": [[ 0, "desc" ],[ 1, "desc" ],[ 3, "desc" ]]
    });
})
	//低级查询按钮
	$("#btnQuickSearch").click(function () {
	    messageTable.draw();
	});

	  // 搜索框的回车事件
	$('#quickSearch').keydown(function(e){
	    if(e.keyCode==13){
	        $("#btnQuickSearch").click();
	    }
	});
	
	$("#advSearchPanel").click(function () {
	    btnAdvSearchflg = true;
	});
	
	//高级查询按钮
	$("#advSearchSubmit").click(function () {
	    setHidValue("frmAdvSearch");
	    messageTable.draw();
	    $("#advSearchPanel").hide();
	    $("#btnAdvSearch").children("i:eq(0)").removeClass("fa-angle-double-up");
	    $("#btnAdvSearch").children("i:eq(0)").addClass("fa-angle-double-down");
	});

	//高级查询隐藏
	$("#advSearchPanel").hide();
	$("#btnAdvSearch").click(function () {
		btnAdvSearchflg = true;
		if ($("#advSearchPanel").is(":hidden")) {
			$("#advSearchPanel").show();
			$(this).children("i:eq(0)").removeClass("fa-angle-double-down");
			$(this).children("i:eq(0)").addClass("fa-angle-double-up");
		} else {
			$("#advSearchPanel").hide();
			$(this).children("i:eq(0)").removeClass("fa-angle-double-up");
			$(this).children("i:eq(0)").addClass("fa-angle-double-down");
		}
	});

	$("#enterpriseId").change(function(){
		loadProject(this.value);
	});
	
	$("body").click(function(e){ 
	    if(btnAdvSearchflg==true){
	        btnAdvSearchflg = false;
	    } else {
	        $("#advSearchPanel").hide();
	        $("#btnAdvSearch").children("i:eq(0)").removeClass("fa-angle-double-up");
	        $("#btnAdvSearch").children("i:eq(0)").addClass("fa-angle-double-down");    
	    }
	});
	
	$("#FrameMessage").on('hide.bs.modal',function(){
		window.top.window.returnCustomModalDialog();
		ClearInput();
        $("#msgCode").val("");
        $("#msgName").val("");
        $("#sendWay").val("");
        $("#title").val("");
        $("#retries").val("");
        $("#retryInterval").val("");
        $("#template").val("");
        $("#enabled").val("");
    });
	
	$("#FrameShop").on('hide.bs.modal', function() {
	    window.top.window.returnCustomModalDialog();
	    window.top.window.borrowCustomModalDialog($("#FrameMessage"));
	});
	$("#FrameTempe").on('hide.bs.modal', function() {
	    window.top.window.returnCustomModalDialog();
	    window.top.window.borrowCustomModalDialog($("#FrameMessage"));
	});
	
	$("#chkAllinli").click(function(){
		window.top.window.$("#checkedShop tbody input[type='checkbox']").prop("checked",this.checked);
	});
	$(".greenBtn").click(function(){
		greenBtn(this);
	});
	$(".addGreen").click(function(){
		addGreen(this);
	});
	$("#addMessagePage").click(function(){
		addMessagePage();
	});
	$("#saveFormFree").click(function(){
		saveFormFree();
	});
	$("#TakeSave").click(function(){
		TakeSave();
	});
	$("#btnMessageAdd").click(function(){
		btnMessageAdd();
	});
	$("#liSearch").click(function(){
		liSearch();
	});
	$("#btnTempeAdd").click(function(){
		btnTempeAdd();
	});
	$("#saveFormMessage").click(function(){
		saveFormMessage();
	});
	$("#open").click(function(){
		$(this).css("background-color","#e74c3c")
		window.top.window.$("#stop").css("background-color","white")
		window.top.window.$("#openOrStop").val('y')
	});
	$("#stop").click(function(){
		$(this).css("background-color","#e74c3c")
		window.top.window.$("#open").css("background-color","white")
		window.top.window.$("#openOrStop").val('n')
	});
	
	// 快速搜索，点击时提交表格刷新内容
    $("#btnQuickSearch").click(function () {
    	
    });
	
	
	$('#quickSearch').keydown(function(e){
		if(e.keyCode==13){
			$("#btnQuickSearch").click();
		}
	});	
	


function addMessagePage(){
	var editDialog = window.top.window.borrowCustomModalDialog($("#FrameMessage"));
	editDialog.modal({show:true, backdrop:'static'});
	window.top.window.$("#messageID").val("");
	window.top.window.$("#kaiguan").hide();
} 

function btnMessageAdd(){
	window.top.window.returnCustomModalDialog();
	var editDialog = window.top.window.borrowCustomModalDialog($("#FrameShop"));
	editDialog.modal({show:true, backdrop:'static'});
	window.top.window.$("#enterpriseId").val("")
	window.top.window.$("#prjId").val("")
	loadEnterprise(null,null);
	liSearch();
}

function liSearch(){
//	window.top.window.returnCustomModalDialog();
	var prjId;
	var entId;
	if(window.top.window.$("#prjId").val()){
		prjId=window.top.window.$("#prjId").val();
		entId="";
	}else if(!window.top.window.$("#prjId").val() && window.top.window.$("#enterpriseId").val()){
		prjId="";
		entId=window.top.window.$("#enterpriseId").val();
	}
	window.top.window.$("#kbdy").children().remove();
	var html ="<table id='shopTable' style='border-bottom: 1px solid #ddd' class='table table-striped table-bordered table-hover'>"+
				"<thead>"+
					"<tr>"+
						"<th style='width: 1%; padding: 10px;'><input type='checkbox' colValue='chk' class='checkall' /></th>"+
						"<th width='19%' colValue='shopName'>店铺名称</th>"+
						"<th width='20%' colValue='shopAccount'>平台账号</th>"+
						"<th width='20%' colValue='prjName'>所属项目</th>"+
						"<th width='20%' colValue='parentshopname'>父店铺</th>"+
						"<th width='20%' colValue='expireTime'>到期时间</th>"+
					"</tr>"+
				"</thead>"+
				"<tbody>"+
				"</tbody>"+
			"</table>"
	  window.top.window.$("#kbdy").html(html)
	  shopTable = window.top.window.$('#shopTable').DataTable({
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
                   d.prjId = prjId;
                   d.entId = entId;
                   d.quickSearch = "";
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

function btnTempeAdd(){
	window.top.window.returnCustomModalDialog();
	var editDialog = window.top.window.borrowCustomModalDialog($("#FrameTempe"));
	editDialog.modal({show:true, backdrop:'static'});
}

/**
 * 删除提示
 * @param btnDelete
 * @returns
 */
function operationDelete(btnDelete){
    messageID = $(btnDelete).attr("messageid");
    window.top.window.showModalConfirm("确定要删除该消息吗？", doDelete);
}
function doDelete() {
    if (messageID == "") {
        return;
    }
    $.ajax({
        type:"POST",
        url:"/messageDefine/deleteMgs.action",
        dataType: "json",
        async: false,//同步
        data : {
            msgId : messageID
        },
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
                window.top.window.showModalAlert(result.errorObject.errorText);
            }
        }
    });
    messageID = "";
    messageTable.draw();
}
function operationEnable(valueEnable,btnEnable){
    enableValue = valueEnable;
    messageID = $(btnEnable).attr("messageid");
    window.top.window.showModalConfirm("确定要请用该消息吗？", doEnable);
}
function doEnable() {
    if (messageID == "") {
        return;
    }
    $.ajax({
        type:"POST",
        url:"/messageDefine/doEnable.action",
        dataType: "json",
        async: false,//同步
        data : {
            msgId : messageID,
            enableValue : enableValue
        },
        success:function(data) {
            if (data.result == "success") {
                window.top.window.showScoMessage('ok', '启用成功');
            } else{
                window.top.window.showModalAlert(data.msg);
            }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                window.top.window.showModalAlert(result.errorObject.errorText);
            }
        }
    });
    messageID = "";
    messageTable.draw();
}

function saveFormMessage(){
	window.top.window.returnCustomModalDialog();
	    
	 if(!$("#searchForm").valid()) {
	        // 父窗体借用本页的编辑对话框
	        window.top.window.borrowCustomModalDialog($("#FrameMessage"));
	        return false;
	 }
            var data = {
            		"msgId": $("#messageID").val(),
                    "msgCode": $("#msgCode").val(),
                    "msgName": $("#msgName").val(),
                    "sendWay": $("#sendWay").val(),
                    "title": $("#title").val(),
                    "retries": $("#retries").val(),
                    "retryInterval": $("#retryInterval").val(),
                    "template":  $("#template").val(),
                    "enabled": $("#enabled").val()
                 };
            $.ajax({
                type:"POST",
                url:"/messageDefine/inseryMessage.action",
                data:JSON.stringify(data),
                contentType: "application/json;charset=utf-8",
                dataType: "json",
//                async: false, // 同步
                success:function(data) {
                    debugger
                    if (data.result == "success") {
                     $('#FrameMessage').modal('hide');
                     window.top.window.showScoMessage('ok', '添加成功');
                     $('#messageTable').DataTable().ajax.reload(null, false);
                    } else{
                     window.top.window.showModalAlert(data.msg);
                     var editDialog = window.top.window.borrowCustomModalDialog($("#FrameMessage"));
                     editDialog.modal({show:true, backdrop:'static'});
                    }
                },
                error:function(XMLHttpRequest, textStatus) {
                    if (XMLHttpRequest.status == 500) {
                        var result = eval("(" + XMLHttpRequest.responseText + ")");
                        window.top.window.showModalAlert(result.errorObject.errorText);
                    }
                }
            });
	messageTable.draw();
}

//页面修改事件
var msgId;
var template;
function operationEdit(e){
	var id=e.getAttribute("messageid")
    $("#kaiguan").show();
	$("#fristPage").children().remove();
	var html ="<table id='checkedShop' class='table table-hover table-striped table-bordered table-advanced tb-sticky-header' width='100%' style='table-layout: fixed;'>"+
	"<thead>"+
		"<tr>"+
			"<th id='thshop' style='width: 2%; padding: 10px;'><input id='chkAllinli' type='checkbox' colValue='chk' class='checkall' /></th>"+
			"<th width='16%' colValue='shopName'>店铺名称</th>"+
			"<th width='16%' colValue='shopType'>店铺类型</th>"+
			"<th width='16%' colValue='validate'>验证</th>"+
			"<th width='16%' colValue='enable'>启用</th>"+
			"<th width='16%' colValue='prjName'>所属项目</th>"+
			"<th width='20%' colValue='operationShop'>自定义模版</th>"+
		"</tr>"+
	"</thead>"+
	"<tbody>"+
	"</tbody>"+
	"</table>"
	$("#fristPage").html(html);
	$("#chkAllinli").click(function(){
		window.top.window.$("#checkedShop tbody input[type='checkbox']").prop("checked",this.checked);
	});
//	ClearInput();
	$.ajax( {
		url : "/messageDefine/getMessageInfo.action?id="+id,
		type : "get",
		dataType: "json",
		success : function(data) {
			if(data.result=="success"){
				msgId=data.data.msgId;
				template=data.data.template;
				var editDialog = window.top.window.borrowCustomModalDialog($("#FrameMessage"));
				editDialog.modal({show:true, backdrop:'static'});
				window.top.window.$("#messageID").val(data.data.msgId);
				window.top.window.$("#msgCode").val(data.data.msgCode);
				window.top.window.$("#msgName").val(data.data.msgName);
				window.top.window.$("#sendWay").val(data.data.sendWay);
				window.top.window.$("#title").val(data.data.title);
				window.top.window.$("#retries").val(data.data.retries);
				window.top.window.$("#retryInterval").val(data.data.retryInterval);
				window.top.window.$("#template").val(data.data.template);
				window.top.window.$("#enabled").val(data.data.enabled);
				shopList();
			}else{
				window.top.window.showModalAlert(data.msg);
			}
		}
	});
}


function ClearInput() {  
    //清空输入域  
   var validator = $("#searchForm").validate({  
        submitHandler: function (form) {  
            form.submit();  
        }  
    });  
    validator.resetForm();  
    $('#searchForm .state-error').removeClass('state-error');
    $('#searchForm .state-success').removeClass('state-success');
}

function shopList(){
	checkedShop = window.top.window.$('#checkedShop').DataTable({
          "processing": true,
          "serverSide": true,
          "lengthMenu": [[5, 25, 50, -1], [5, 25, 50, "All"]],
          "dom": '<"bottom"rtflp>',
          "searching": false,
          "pagingType": "full_numbers",
          "deferRender": true,
          "ajax": {
              "url": "/messageDefine/messageShopList.action",
              "data": function ( d ) {
                  d.quickSearch = msgId;
              }
          },
          "fnDrawCallback": function (oSettings) {
        	  window.top.window.$("#thshop").removeClass("sorting_asc");
        	  window.top.window.$(".operationShopFree").click(function () {
        		  operationShopFree(this)
        	  });
          },
          "tableTools": {
              "sRowSelect": "bootstrap"
          },
          "columns": [{
                  "data": "chk","searchable": false
              },{
                  "data": "shopName"
              }, {
                  "data": "shopType"
              }, {
                  "data": "validate"
              }, {
                  "data": "enable"
              }, {
                  "data": "prjName"
			  }, {
				  "data": "operationShop"
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
                  "targets":[5]},
              {"orderable":false,
                  "targets":[6]}
      ]
      });
}

function saveFormFree(){
	window.top.window.returnCustomModalDialog();
	 $.ajax({
			url : "/messageDefine/updateFormFree.action",
			type : "post",
			data : {
				template : $("#templateFree").val(),
				msId : $("#templateFreeHide").val()
			},
			success : function(data) {
				var editDialog = window.top.window.borrowCustomModalDialog($("#FrameTempe"));
				editDialog.modal('hide');
			},
			error:function(XMLHttpRequest, textStatus) {
	            if (XMLHttpRequest.status == 500) {
	                var result = eval("(" + XMLHttpRequest.responseText + ")");
	                window.top.window.showModalAlert(result.errorObject.errorText);
	            }
	        }
		});
}

function TakeSave(){
	var arr = new Array();
	window.top.window.$("#shopTable tbody input[type='checkbox']:checked").each(function(k,v){
		if (this.getAttribute('shopid')) {
			arr.push(this.getAttribute('shopid'))
		}
	});
	if(arr.length==0){
		return window.top.window.showModalAlert("请选中一条数据");
	}
	 $.ajax({
			url : "/messageDefine/takeSaveShop.action",
			type : "post",
			traditional:true,
			data : {
				arr : arr,
				msgId : msgId
			},
			success : function(data) {
				window.top.window.returnCustomModalDialog();
				var div=window.top.window.borrowCustomModalDialog($("#FrameShop"));
				div.modal('hide');
				window.top.window.$('#checkedShop').DataTable().ajax.reload(null, false);
			},
			error:function(XMLHttpRequest, textStatus) {
	            if (XMLHttpRequest.status == 500) {
	                var result = eval("(" + XMLHttpRequest.responseText + ")");
	                window.top.window.showModalAlert(result.errorObject.errorText);
	            }
	        }
		});
}

function addGreen(e){
	var str=$(e).html();
	window.top.window.returnCustomModalDialog();
	var tc = document.getElementById("template");  
	var tclen = tc.value.length;  
	tc.focus();  
	if(typeof document.selection != "undefined"){  
		document.selection.createRange().text = str;    
	}else{  
		tc.value = tc.value.substr(0,tc.selectionStart)+str+tc.value.substring(tc.selectionStart,tclen);  
	}  
}

function operationShopFree(e){
    window.top.window.returnCustomModalDialog();
    var editDialog = window.top.window.borrowCustomModalDialog($("#FrameTempe"));
    editDialog.modal({show:true, backdrop:'static'});
    $.ajax({
        type: "GET",
        url: "/messageDefine/getMessageShop.action?id="+e.getAttribute('messageid'),
        success: function (data) {
        	window.top.window.$("#templateFree").val(data.data.template);
        	window.top.window.$("#templateFreeHide").val(e.getAttribute('messageid'));
        }
    });
}

//下拉企业
function loadEnterprise(entId,prjId){
    $.ajax({
        type: "GET",
        url: "/enterprise/getOneEnterpriseList.action",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (data) {
            if (data.entName) {
            	window.top.window.$("#enterpriseId option").remove();
            	window.top.window.$("#enterpriseId").append("<option value=''>请选择</option>");
                $.each(data.entName, function (n, value) {
                	window.top.window.$('#enterpriseId').append("<option value='" + value.entId + "' shopType = '"+value.entName+"'>" + value.entName + "</option>");
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
}

//加载项目
function loadProject(entId) {
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



//删除
var mesIdssum1 ="";
$("#btnMessageDel").click(function () {
    window.top.window.returnCustomModalDialog();
    mesIdssum1 = "";
    $("#checkedShop tbody input[type='checkbox']:checked").each(function(k,v){
        if(mesIdssum1==""){
            mesIdssum1=this.getAttribute('mid');
        }else if(mesIdssum1!=""){
            mesIdssum1+=","+this.getAttribute('mid');
        }
    });
    if (mesIdssum1 == null || mesIdssum1==undefined || mesIdssum1=="" || mesIdssum1 == ","){
        window.top.window.showModalAlert("请选择一个目标！");
        return;
    }
    window.top.window.showModalConfirm("确定要删除该店铺吗？", delMes);
});

function delMes(){
    var sURL = "/messageDefine/deleteShopMes.action";
     $.ajax({
        url : sURL,
        type : "post",
        dataType : "json",
        async: false,
        data : {
            msId : mesIdssum1
        },
        success : function(data) {
             if (data.result == "success") {
                    window.top.window.showScoMessage('ok', '删除成功');
                } else{
                    window.top.window.showModalAlert(data.msg);
                }
        },
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                window.top.window.showModalAlert(result.errorObject.errorText);
            }
        }
    });
     checkedShop.draw();
     var editDialog = window.top.window.borrowCustomModalDialog($("#FrameMessage"));
     editDialog.modal({show:true, backdrop:'static'});
}

function greenBtn(e){ 
	var str=$(e).html();
	window.top.window.returnCustomModalDialog();
    var tc = document.getElementById("templateFree");  
    var tclen = tc.value.length;  
    tc.focus();  
    if(typeof document.selection != "undefined"){  
        document.selection.createRange().text = str;    
    }else{  
        tc.value = tc.value.substr(0,tc.selectionStart)+str+tc.value.substring(tc.selectionStart,tclen);  
    }  
}  

