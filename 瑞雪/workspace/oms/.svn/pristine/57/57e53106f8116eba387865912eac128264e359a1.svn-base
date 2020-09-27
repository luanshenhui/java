var logTable;
var btnAdvSearchflg= false;
jQuery(document).ready(function(){
	logTable = $('#logTable').DataTable({
	    "processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/log/logList.action",
            "data": function ( d ) {
            	 if ($("#advSearchPanel").is(":hidden")) {
                     d.quickSearch = encodeURI($('#quickSearch').val());
                 }
                 else {
                     // 高级查询条件
                     var bizId = encodeURI($('#bizId').val());
                     var tag =encodeURI($('#tag').val());
                     var user =encodeURI($('#user').val());
                     var operation =encodeURI($('#operation').val());
                     var sourceType =encodeURI($('#sourceType').val());
                     var logType =encodeURI($('#logType').val());
                     var advData = {
                         "bizId": bizId,
                         "tag": tag,
                         "user": user,
                         "operation": operation,
                         "sourceType": sourceType,
                         "logType": logType
                     };
                     d.formJson = JSON.stringify(advData);
                 }
            	}
        },
        "tableTools": {
            "sRowSelect": "bootstrap"
        },
        "columns": [{
            	"data": "chkBox"
        	}, {
                "data": "bizId"
            }, {
                "data": "tag"
            }, {
                "data": "user"
            }, {
                "data": "operTime"
			}, {
				"data": "operation"
			}, {
				"data": "sourceType"
			}, {
				"data": "detail"
			}, {
				"data": "logType"
			}, {
				"data": "operationButton"
			}
        ],
        "columnDefs": [
        	{"orderable":false,
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
        	{"orderable":true,
            	"targets":[7]},	
        	{"orderable":true,
        		"targets":[8]},	
        	{"orderable":false,
        		"targets":[9]}	
        ],
        "order": [[ 4, "desc" ]]
    });
});

$("#viewPage").on('hide.bs.modal',function(){
	window.top.window.returnCustomModalDialog();
});

$("#advSearchPanel").click(function () {
    btnAdvSearchflg = true;
})
//低级查询按钮
$("#btnQuickSearch").click(function () {
	logTable.draw();
});
//高级查询按钮
$("#advSearchSubmit").click(function () {
    setHidValue("frmAdvSearch");
    logTable.draw();
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


$("body").click(function(e){ 
    if(btnAdvSearchflg==true){
        btnAdvSearchflg = false;
    } else {
        $("#advSearchPanel").hide();
        $("#btnAdvSearch").children("i:eq(0)").removeClass("fa-angle-double-up");
        $("#btnAdvSearch").children("i:eq(0)").addClass("fa-angle-double-down");    
    }
});

  // 搜索框的回车事件
$('#quickSearch').keydown(function(e){
	if(e.keyCode==13){
		$("#btnQuickSearch").click();
	}
});

//删除
function deleteLog(){
	window.top.window.showModalConfirm("确定要删除吗？", delConfrim);
}
//全选
$("#chkAll").click(function(){
    if($(this).attr("checked")){
        $("input[name='chkItem']").attr("checked",$(this).attr("checked"));
    }else{
        $("input[name='chkItem']").removeAttr("checked");
    }
});

function delConfrim(){
	var arr = new Array();
	$("#logTable tbody input[type='checkbox']:checked").each(function(k,v){
		if (this.getAttribute('bizid')) {
			arr.push(this.getAttribute('bizid'))
		}
	});
	if(arr.length==0){
		return window.top.window.showModalAlert("请选中一条数据");
	}
	var sURL = "/log/deleteLog.action";
	 $.ajax({
		url : sURL,
		type : "post",
		traditional:true,
		data : {
			arr : arr
		},
		success : function(data) {
			 if (data=="success") {
	            	window.top.window.showScoMessage('ok', '删除成功');
	            	logTable.draw();
	            } else{
	            	window.top.window.showModalAlert("删除失败");
	            }
		},
		error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                window.top.window.showModalAlert(result.errorObject.errorText);
            }
        }
	});
}

function view(id,e){
	$.ajax( {
		url : "/log/getLogDetail.action?id="+id,
		type : "get",
		dataType: "json",
		success : function(data) {
			if(data.result=="success"){
				var editDialog = window.top.window.borrowCustomModalDialog($("#viewPage"));
				editDialog.modal({show:true, backdrop:'static'});
				window.top.window.$("#bizId").val(data.data.bizId);
				window.top.window.$("#tag").val(data.data.tag);
				window.top.window.$("#user").val(data.data.user);
				window.top.window.$("#operation").val(data.data.operation);
				window.top.window.$("#detail").val(data.data.detail);
				window.top.window.$("#logType").val(data.data.logType);
				window.top.window.$("#operTime").val(data.data.operTime);
				window.top.window.$("#sourceType").val(data.data.sourceType);
			}
		}
	});
}


//选择行
$('#logTable tbody').on('click','td',function () {
	var len=$(this).children().length;
	if(len==0){//选择行
		$("#logTable tbody input[type='checkbox']").prop("checked",false)
		var first=$(this).parent().children()[0];
		var ck = $(first).children()[0];
		$(ck).prop("checked",true)
	}
})


