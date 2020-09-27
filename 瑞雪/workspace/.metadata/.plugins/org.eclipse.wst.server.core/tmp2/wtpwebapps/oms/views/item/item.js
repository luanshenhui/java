// 平台商品Datatable
var itemTable;
// 正在操作的“平台商品ID”
var opEcItemId = "";
var btnAdvSearchflg= false;
/**
 * 页面初始化
 */
$(function () {
    $("#advSearchPanel").hide();

    // 初始化表格控件
    itemTable = $('#itemTable').DataTable({
        "processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/item/itemList.action",
            "data": function (d) {
                if ($("#advSearchPanel").is(":hidden")) {
                    d.quickSearch = encodeURI($('#quickSearch').val());
                }
                else {
                    // 高级查询条件
                    var prjId = $('#prjId').val();
                    var shopId = $('#shopId').val();
                    var shopType = encodeURI($('#shopType').val());
                    var approveStatus = encodeURI($('#status').val());
                    var ecItemCode = encodeURI($('#ecItemCode').val());
                    var ecItemName = encodeURI($('#ecItemName').val());
                    var ecSkuCode = encodeURI($('#ecSkuCode').val());
                    var ecSkuName = encodeURI($('#ecSkuName').val());
                    var advData = {
                        "prjId": prjId,
                        "shopId": shopId,
                        "shopType": shopType,
                        "approveStatus": approveStatus,
                        "ecItemCode": ecItemCode,
                        "ecItemName": ecItemName,
                        "ecSkuCode": ecSkuCode,
                        "ecSkuName": ecSkuName
                    };

                    d.formJson = JSON.stringify(advData);
                }

                /*var a = $("#frmAdvSearch").serializeArray();
                 $.each(a, function (i, field) {
                 debugger;
                 d[field.name] = field.value;
                 });*/
            }
        },
        "tableTools": {
            //"sSwfPath": "/js/datatables/tabletools/swf/copy_csv_xls_pdf.swf", // 表格导出，需要flash支持
            "sRowSelect": "bootstrap"
        },
        "columns": [{
            "data": "skuShow"
        },{
            "data": "chk"
        }, {
            "data": "ecItemCode"
        }, {
            "data": "ecItemName"
        }, {
            "data": "outerCode"
        }, {
            "data": "status"
        }, {
            "data": "prjName"
        }, {
            "data": "shopName"
        }, {
            "data": "shopType"
        }, {
            "data": "ecItemId"
        }
        ],
        "columnDefs": [{
            "orderable": false,
            "targets": [0]
        },{
            "orderable": false,
            "targets": [1]
        }, {
            "targets": [9],
            "visible": false,
            "searchable": false
        }
        ],
        "order": [[6, "asc"], [8, "asc"], [7, "asc"], [2, "asc"]]
    });

    // 快速搜索，点击时提交表格刷新内容
    $("#btnQuickSearch").click(function () {
        itemTable.draw();
    });

    // 搜索框的回车事件
    $('#quickSearch').keydown(function (e) {
        if (e.keyCode == 13) {
            $("#btnQuickSearch").click();
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
    // 高级搜索“提交”按钮点击
    $("#advSearchSubmit").click(function (e) {
    	//记录高级查询的检索条件
        setHidValue("frmAdvSearch");
        
        itemTable.draw();
        $("#advSearchPanel").hide();
        $("#btnAdvSearch").children("i:eq(0)").removeClass("fa-angle-double-up");
        $("#btnAdvSearch").children("i:eq(0)").addClass("fa-angle-double-down");
        
    });

    // 高级搜索
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
    $("#advSearchPanel").click(function () {
    	btnAdvSearchflg = true;
    })
    


    /**
     * 初始化项目列表
     */
    $.ajax({
        type: "GET",
        url: "/projectManager/getAllValidProjects.action",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success: function (data) {
            if (data.result == "success") {
                $("#prjId option").remove();
                $("#prjId").append("<option value=''>请选择</option>");
                $.each(data.data, function (n, value) {
                    $("#prjId").append("<option value='" + value.prjId + "'>" + value.prjName + "</option>");
                });
            } else {
                window.top.window.showModalAlert(data.msg);
            }
        },
        error: function (XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });

    /**
     * 项目列表选择事件
     */
    $("#prjId").change(function (e) {
        //项目ID
        var prjId = encodeURI(encodeURI($('#prjId').val()));

        // 初始化店铺列表
        $.ajax({
            type: "GET",
            url: "/shop/getShopListByPrjId.action?prjId=" + prjId,
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            async: false,//同步
            success: function (data) {
                if (data.result == "success") {
                    $("#shopId option").remove();
                    $("#shopId").append("<option value=''>请选择</option>");
                    $.each(data.data, function (n, value) {
                        $("#shopId").append("<option value='" + value.shopId + "'>" + value.shopName + "</option>");
                    });
                } else {
                    window.top.window.showModalAlert(data.msg);
                }
            },
            error: function (XMLHttpRequest, textStatus) {
                if (XMLHttpRequest.status == 500) {
                    var result = eval("(" + XMLHttpRequest.responseText + ")");
                    alert(result.errorObject.errorText);
                }
            }
        });

    });

    //子表格显示隐藏
    var tableId = "itemTable";
    var childTables = new Array();
    var tableHtml = "";
    $('#' + tableId + ' tbody').on('click', 'td .fa', function () {
        //取得主键
        var ecitemid = $(this).attr('ecitemid');
        var tr = $(this).closest('tr');
        var row = itemTable.row(tr);
        if ( row.child.isShown() ) {
            // This row is already open - close it
        	row.child.hide();
            tr.removeClass('shown');
            $(this).removeClass('fa-chevron-up');
            $(this).addClass('fa-chevron-down');
        }
        else {
            //关闭其他
        	$('#itemTable tbody tr').each(function(){
        		if ($(this).attr("role")=="row"){
        			itemTable.row($(this)).child.hide();
        		}
        	});
        	$('.fa-chevron-up').addClass('fa-chevron-down');
            $('.fa-chevron-down').removeClass('fa-chevron-up');
            //生成datatable的HTML代码
            //判断相应的id的datatable是否存在
            if ($('#itemTable' + ecitemid).length <= 0) {
                var temp = '';
                temp += '<table id="itemTable' + ecitemid + '"';
                temp += 'class="table table-hover table-striped table-bordered table-advanced tb-sticky-header"';
                temp += 'width="100%">';
                temp += '<thead>';
                temp += '<tr>';
                temp += '<th width="15%" colValue="ecSkuCode">平台规格编码</th>';
                temp += '<th width="25%" colValue="ecSkuName">平台规格名称</th>';
                temp += '<th width="10%" colValue="salePrice">价格</th>';
                temp += '<th width="10%" colValue="qty">平台库存数量</th>';
                temp += '</tr>';
                temp += '</thead>';
                temp += '<tbody>';
                temp += '</tbody>';
                temp += '</table>';
                // Open this row
                row.child(temp).show();
                tr.addClass('shown');
                var childTable = new Object();
                childTable.id = "itemTable" + ecitemid;
                childTable.table = $('#itemTable' + ecitemid).DataTable({
                    "bPaginate": false,
                    "processing": true,
                    "serverSide": true,
                    "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    "dom": '<"bottom"rtfli>',
                    "searching": false,
                    "pagingType": "full_numbers",
                    "deferRender": true,
                    "ajax": {
                        "url": "/item/skuList.action",
                        "data": function (d) {
                            d.ecItemId = encodeURI(ecitemid);
                        }
                    },
                    "tableTools": {
                        "sRowSelect": "bootstrap"
                    },
                    "columns": [{
                        "data": "ecSkuCode"
                    }, {
                        "data": "ecSkuName"
                    }, {
                        "data": "salePrice"
                    }, {
                        "data": "qty"
                    }
                    ],
                    "order": [[0, "asc"]]
                });
            } else {
                tr.addClass('shown');
            }
            $(this).addClass('fa-chevron-up');
            $(this).removeClass('fa-chevron-down');
        }
    });
});


/**
 * 平台商品导出
 */
function exportItemList() {
    // 平台规格列名称
    var objEcSkuCode = new Object();
    objEcSkuCode.name = "平台规格编码";
    objEcSkuCode.value = "ecSkuCode";
    var objEcSkuName = new Object();
    objEcSkuName.name = "平台规格名称";
    objEcSkuName.value = "ecSkuName";
    var objSalePrice = new Object();
    objSalePrice.name = "价格";
    objSalePrice.value = "salePrice";
    var objQty = new Object();
    objQty.name = "平台库存数量";
    objQty.value = "qty";

    var obList = [objEcSkuCode, objEcSkuName, objSalePrice, objQty];
    extraFieldJson = JSON.stringify(obList);

    exportList('itemTable', '/item/exportCheck.action', '/item/export.action', 'exportSelectItem', '平台商品导出', 'frmAdvSearch', extraFieldJson);
}

// $('.checkall').on('ifChecked ifUnchecked', function(event) {
//     debugger;
//     if (event.type == 'ifChecked') {
//         $(this).closest('table').find('input[type=checkbox]').iCheck('check');
//     } else {
//         $(this).closest('table').find('input[type=checkbox]').iCheck('uncheck');
//     }
// });

//全选，全不选
var checkboxes = document.getElementsByName('chkItem');
$("#chkAll").click(function() {
    for (var i = 0; i < checkboxes.length; i++) {
        var checkbox = checkboxes[i];
        if (!$(this).get(0).checked) {
            checkbox.checked = false;
        } else {
            checkbox.checked = true;
        }
    }
});