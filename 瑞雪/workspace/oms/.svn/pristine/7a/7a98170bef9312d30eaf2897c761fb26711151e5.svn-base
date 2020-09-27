/**
 * Created by jinshen on 2017-3-8.
 */
var tecTradenoPay ;	//未付款
var tecTradenoDeal ;	//待处理
var tecTradewaiteSend ;	//待发货
var tecTradesend ;	//已发货
var tecTradeover ;	//已完成
var tecTradecanceled ;//已废弃
var searchCondition = { //高级检索
		"prjId":"",
		"shopId":"",
		"shopType":"",
		"ecTradeCode":"",
		"ecCustCode":"",
		"ecTradeId":"",
		"childEcTradeId":"",
		"ecTradeStatus":""
};
var quickSearch = "";		//快速查询
var btnAdvSearchflg= false;	//高级查询是否点击标识
var mapOrderTable = {};
var orderId = "";
var ecTradeId = "";
var updateTime = "";

/**
 * 页面初期化
 */
$(document).ready(function () {

	//项目的下拉列表
    $.ajax({
        type:"GET",
        url:"/projectManager/getAllAvailableProjects.action",
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: true,//同步
        success:function(data) {
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
        error:function(XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.status == 500) {
                var result = eval("(" + XMLHttpRequest.responseText + ")");
                alert(result.errorObject.errorText);
            }
        }
    });
	//高级检索初期化的时候隐藏
	$("#advSearchPanel").hide();
	
	//默认待处理显示
	getEcTradenoDeal();
	
	//未付款数字,待处理数字,待发货,全部发货,已完成数字,已废弃数字
	getCounts();
	
	//绑定事件
	/**
	 * tab切换事件
	 */
	$('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
		
		switch ($(this).attr("id")) {
		case "portlettabcanceledid": 	//已废弃
			getEcTradeCanceled();
			break;
	    case "portlettaboverid":		//已完成
	    	getEcTradeOver();
	        break;
	    case "portlettabsendid":		//已发货
	    	getEcTradeSend();
	        break;
	    case "portlettabwaiteSendid":	//等待发货
	    	getEcTradeWaiteSend();
	        break;
	    case "portlettabnoDealid":	//待处理
	    	getEcTradenoDeal();
	        break;
	    case "portlettabnoPayid":		//未付款
	    	getEcTradenoPay();
	        break;
		default:
	    	break;
		}
		getCounts();
		
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
     * body点击的时候高级检索收回
     */
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
        searchCondition = { //高级检索
        		"prjId":$('#hidprjId').val(),
        		"shopId":$('#hidshopId').val(),
        		"shopType":$('#hidshopType').val(),
        		"ecTradeCode":$('#hidecTradeCode').val(),
        		"ecCustCode":$('#hidecCustCode').val(),
        		"ecTradeId":$('#hidecTradeId').val(),
        		"childEcTradeId":$('#hidchildEcTradeId').val(),
        		"ecTradeStatus":$('#hidecTradeStatus').val(),
        };
        quickSearch = "";
        $("div .active").each(function(){
    		switch ($(this).attr("id")) {
    		case "portlettabcanceled": 	//已废弃
    			tecTradecanceled.draw();
    			break;
    	    case "portlettabover":		//已完成
    	    	tecTradeover.draw();
    	        break;
    	    case "portlettabsend":		//已发货
    	    	tecTradesend.draw();
    	        break;
    	    case "portlettabwaiteSend":		//待发货
    	    	tecTradewaiteSend.draw();
    	        break;
    	    case "portlettabnoDeal":		//待处理
    	    	tecTradenoDeal.draw();
    	        break;
    	    case "portlettabnoPay":		//未付款
    	    	tecTradenoPay.draw();
    	        break;
    		default:
    	    	break;
    		}
    	});
        getCounts();
        $("#advSearchPanel").hide();
        $("#btnAdvSearch").children("i:eq(0)").removeClass("fa-angle-double-up");
        $("#btnAdvSearch").children("i:eq(0)").addClass("fa-angle-double-down");
        
    });
    
    /**
     * 快速搜索，点击时提交表格刷新内容
     */
    $("#btnQuickSearch").click(function () {
    	quickSearch = encodeURI($('#quickSearch').val());
    	searchCondition = { //高级检索
    			"prjId":"",
    			"shopId":"",
    			"shopType":"",
    			"ecTradeCode":"",
    			"ecCustCode":"",
    			"ecTradeId":"",
    			"childEcTradeId":"",
    			"ecTradeStatus":""
    	};
    	$("div .active").each(function(){
    		switch ($(this).attr("id")) {
    		case "portlettabcanceledid": 	//已废弃
    			tecTradecanceled.draw();
    			break;
    	    case "portlettaboverid":		//已完成
    	    	tecTradeover.draw();
    	        break;
    	    case "portlettabsendid":		//已发货
    	    	tecTradesend.draw();
    	        break;
    	    case "portlettabwaiteSendid":		//待发货
    	    	tecTradewaiteSend.draw();
    	        break;
    	    case "portlettabnoDealid":		//待处理
    	    	tecTradenoDeal.draw();
    	        break;
    	    case "portlettabnoPayid":		//未付款
    	    	tecTradenoPay.draw();
    	        break;
    		default:
    	    	break;
    		}
    	});
    	getCounts();
    });

    /**
     * 搜索框的回车事件
     */ 
    $('#quickSearch').keydown(function(e){
        if(e.keyCode==13){
            $("#btnQuickSearch").click();
        }
    });
    
    //子表格显示隐藏
    $('.tablefirst tbody').on('click', 'td .fa', function () {
        //取得主键
        var ecTradeId = $(this).attr('ecTradeId');
        //取得行
        var tr = $(this).closest('tr');
        var row;
        var table;
        var tablename =  "";
        var tabIndex = "";
        $("div .active").each(function(){
    		switch ($(this).attr("id")) {
    		case "portlettabcanceled": 	//已废弃
    			table = tecTradecanceled;
    			row = tecTradecanceled.row(tr);
    			tablename = "tecTradecanceled";
    			tabIndex = "canceled";
    			break;
    	    case "portlettabover":		//已完成
    	    	table = tecTradeover;
    	    	row = tecTradeover.row(tr);
    	    	tablename = "tecTradeover";
    	    	tabIndex = "over";
    	        break;
    	    case "portlettabsend":		//已发货
    	    	table = tecTradesend;
    	    	row = tecTradesend.row(tr);
    	    	tablename = "tecTradesend";
    	    	tabIndex = "send";
    	        break;
    	    case "portlettabwaiteSend":		//已处理
    	    	table = tecTradewaiteSend;
    	    	row = tecTradewaiteSend.row(tr);
    	    	tablename = "tecTradewaiteSend";
    	    	tabIndex = "waiteSend";
    	        break;
    	    case "portlettabnoDeal":		//待处理
    	    	table = tecTradenoDeal;
    	    	row = tecTradenoDeal.row(tr);
    	    	tablename = "tecTradenoDeal";
    	    	tabIndex = "noDeal";
    	    	break;
    	    case "portlettabnoPay":		//未付款
    	    	table = tecTradenoPay;
    	    	row = tecTradenoPay.row(tr);
    	    	tablename = "tecTradenoPay";
    	    	tabIndex = "noPay";
    	        break;
    		default:
    	    	break;
    		}
    	});
        //加载过，而且是显示的状态
        if ( row.child.isShown() ) {
            // This row is already open - close it
        	row.child.hide();
            tr.removeClass('shown');
            $(this).removeClass('fa-chevron-up');
            $(this).addClass('fa-chevron-down');
        }
        else {
            //关闭其他
        	$('#'+tablename+' tbody tr').each(function(){
        		if ($(this).attr("role")=="row"){
        			table.row($(this)).child.hide();
        		}
        	});
            $('.fa-chevron-up').addClass('fa-chevron-down');
            $('.fa-chevron-down').removeClass('fa-chevron-up');
            //生成datatable的HTML代码
            //判断相应的id的datatable是否存在
            if ($('#' + tablename + ecTradeId + tabIndex).length <= 0) {
                var temp = '';
                temp += '<table id="' + tablename + ecTradeId + tabIndex +'"';
                temp += 'class="table table-hover table-striped table-bordered table-advanced tb-sticky-header"';
                temp += 'width="100%">';
                temp += '<thead>';
                temp += '<tr>';
                temp += '<th width="5%">异常描述</th>';
                temp += '<th width="5%">平台商品编码</th>';
                temp += '<th width="5%">平台商品名称</th>';
                temp += '<th width="5%">平台规格编码</th>';
                temp += '<th width="5%">平台规格名称</th>';
                temp += '<th width="5%">平台状态</th>';
                temp += '<th width="5%">分单店铺</th>';
                temp += '<th width="5%">系统状态</th>';
//                temp += '<th width="5%">删除原因</th>';
                temp += '<th width="5%">发货时间</th>';
                temp += '<th width="5%">物流公司</th>';
                temp += '<th width="5%">物流单号</th>';
                if (tablename == "tecTradenoDeal"){
                	temp += '<th width="5%">操作</th>';	
                }
                temp += '</tr>';
                temp += '</thead>';
                temp += '<tbody>';
                temp += '</tbody>';
                temp += '</table>';
                // Open this row
                row.child(temp).show();
                tr.addClass('shown');
                if (tablename == "tecTradenoDeal"){
                	mapOrderTable[tablename + ecTradeId + tabIndex] = $('#' + tablename + ecTradeId + tabIndex).DataTable({
                        "bPaginate": false,
                        "processing": true,
                        "serverSide": true,
                        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        "dom": '<"bottom"rtfli>',
                        "searching": false,
                        "pagingType": "full_numbers",
                        "deferRender": true,
                        "ajax": {
                            "url": "/ecTradeManager/ecTradeOrderList.action",
                            "data": function (d) {
                                d.ecTradeId = encodeURI(ecTradeId);
                            }
                        },
                        "tableTools": {
                            "sRowSelect": "bootstrap"
                        },
                        "columns": [
                        	{"data": "deleteReason"}, 
                        	{"data": "ecItemCode"},
                        	{"data": "ecItemName"}, 
                        	{"data": "ecSkuCode"},
                        	{"data": "ecSkuName"},
                        	{"data": "platformStatus"},
                        	{"data": "splitShopName"},
                        	{"data": "erpStatus"},
                        	{"data": "shipTime"},
                        	{"data": "lgstName"},
                        	{"data": "lgstNo"},
                        	{"data": "operation"}
                        ],
                        "order": [[0, "asc"],[3, "asc"],[6, "asc"],[9, "desc"]]
                    });
                } else {
                	mapOrderTable[tablename + ecTradeId + tabIndex] = $('#' + tablename + ecTradeId + tabIndex).DataTable({
                        "bPaginate": false,
                        "processing": true,
                        "serverSide": true,
                        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        "dom": '<"bottom"rtfli>',
                        "searching": false,
                        "pagingType": "full_numbers",
                        "deferRender": true,
                        "ajax": {
                            "url": "/ecTradeManager/ecTradeOrderList.action",
                            "data": function (d) {
                                d.ecTradeId = encodeURI(ecTradeId);
                            }
                        },
                        "tableTools": {
                            "sRowSelect": "bootstrap"
                        },
                        "columns": [
                        	{"data": "deleteReason"}, 
                        	{"data": "ecItemCode"},
                        	{"data": "ecItemName"}, 
                        	{"data": "ecSkuCode"},
                        	{"data": "ecSkuName"},
                        	{"data": "platformStatus"},
                        	{"data": "splitShopName"},
                        	{"data": "erpStatus"},
                        	{"data": "shipTime"},
                        	{"data": "lgstName"},
                        	{"data": "lgstNo"}
                        ],
                        "order": [[0, "asc"],[3, "asc"],[6, "asc"],[9, "desc"]]
                    });
                }
                
            } else {
            	tr.addClass('shown');
            }
            $(this).addClass('fa-chevron-up');
            $(this).removeClass('fa-chevron-down');
        }
    });
    
    /**
     * 项目列表选择事件
     */
    $("#prjId").change(function (e) {
        //项目ID
        var prjId = encodeURI(encodeURI($(this).val()));

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
                    	$('#shopId').append("<option value='" + value.shopId + "' shopType = '"+value.shopType+"'>" + value.shopName + "</option>");
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
});

/**
 * 未付款 列表
 * @returns
 */
function getEcTradenoPay(){
	//如果已经初期化过，不用重新定义，直接重画表格
	if (tecTradenoPay!=null && tecTradenoPay != undefined && ""!=tecTradenoPay){
		tecTradenoPay.draw();
		return ;
	}
	tecTradenoPay = $('#tecTradenoPay').DataTable({
	        "processing": true,
	        "serverSide": true,
	        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "dom": '<"bottom"rtflp>',
	        "searching": false,
	        "pagingType": "full_numbers",
	        "deferRender": true,
	        "ajax": {
	            "url": "/ecTradeManager/ecTradeNoPayList.action",
	            "data": function (d) {
	                    d.quickSearch = quickSearch;
	                    d.formJson = JSON.stringify(searchCondition);
	                }
	            },
	        "tableTools": {
	            "sRowSelect": "bootstrap"
	        },
	        "columns": [
	         {"data": "ecOrderShow"}
	        ,{"data": "prjName"}
	        ,{"data": "shopName"}
	        ,{"data": "ecTradeCode"}
	        ,{"data": "status"}
	        ,{"data": "ecCustCode"}
	        ,{"data": "orderTime"}
	        ],
	        "columnDefs": [{
	            "orderable": false,
	            "targets": [0]
	        }
	        ],
	        "order": [[1, "asc"], [2, "asc"], [6, "desc"], [3, "asc"]]
	    });
}

/**
 * 待处理 列表
 * @returns
 */
function getEcTradenoDeal(){
	//如果已经初期化过，不用重新定义，直接重画表格
	if (tecTradenoDeal!=null && tecTradenoDeal != undefined && ""!=tecTradenoDeal){
		tecTradenoDeal.draw();
		return ;
	}
	tecTradenoDeal = $('#tecTradenoDeal').DataTable({
	        "processing": true,
	        "serverSide": true,
	        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "dom": '<"bottom"rtflp>',
	        "searching": false,
	        "pagingType": "full_numbers",
	        "deferRender": true,
	        "ajax": {
	            "url": "/ecTradeManager/ecTradeNoDealList.action",
	            "data": function (d) {
	                    d.quickSearch = quickSearch;
	                    d.formJson = JSON.stringify(searchCondition);
	                }
	            },
	        "tableTools": {
	            "sRowSelect": "bootstrap"
	        },
	        "columns": [
		         {"data": "ecOrderShow"}
		        ,{"data": "exceptionType"}
		        ,{"data": "prjName"}
		        ,{"data": "shopName"}
		        ,{"data": "ecTradeCode"}
		        ,{"data": "status"}
		        ,{"data": "ecCustCode"}
		        ,{"data": "orderTime"}
		        ,{"data": "paidTime"}
		        ],
	        "columnDefs": [{
	            "orderable": false,
	            "targets": [0]
	        }
	        ],
	        "order": [[1, "asc"],[2, "asc"], [3, "asc"], [7, "desc"], [4, "asc"]]
	    });
}

/**
 * 待发货 列表
 * @returns
 */
function getEcTradeWaiteSend(){
	//如果已经初期化过，不用重新定义，直接重画表格
	if (tecTradewaiteSend!=null && tecTradewaiteSend != undefined && ""!=tecTradewaiteSend){
		tecTradewaiteSend.draw();
		return ;
	}
	tecTradewaiteSend = $('#tecTradewaiteSend').DataTable({
	        "processing": true,
	        "serverSide": true,
	        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "dom": '<"bottom"rtflp>',
	        "searching": false,
	        "pagingType": "full_numbers",
	        "deferRender": true,
	        "ajax": {
	            "url": "/ecTradeManager/ecTradeWaiteSend.action",
	            "data": function (d) {
	                    d.quickSearch = quickSearch;
	                    d.formJson = JSON.stringify(searchCondition);
	                }
	            },
	        "tableTools": {
	            "sRowSelect": "bootstrap"
	        },
	        "columns": [
		         {"data": "ecOrderShow"}
		        ,{"data": "exceptionType"}
		        ,{"data": "splitFlg"}
		        ,{"data": "prjName"}
		        ,{"data": "shopName"}
		        ,{"data": "ecTradeCode"}
		        ,{"data": "status"}
		        ,{"data": "ecCustCode"}
		        ,{"data": "orderTime"}
		        ,{"data": "paidTime"}
		        ],
	        "columnDefs": [{
	            "orderable": false,
	            "targets": [0]
	        }
	        ],
	        "order": [[1, "asc"],[3, "asc"], [4, "asc"], [8, "desc"], [5, "asc"]]
	    });
}

/**
 * 已发货 列表
 * @returns
 */
function getEcTradeSend(){
	//如果已经初期化过，不用重新定义，直接重画表格
	if (tecTradesend!=null && tecTradesend != undefined && ""!=tecTradesend){
		tecTradesend.draw();
		return ;
	}
	tecTradesend = $('#tecTradesend').DataTable({
	        "processing": true,
	        "serverSide": true,
	        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "dom": '<"bottom"rtflp>',
	        "searching": false,
	        "pagingType": "full_numbers",
	        "deferRender": true,
	        "ajax": {
	            "url": "/ecTradeManager/ecTradeSend.action",
	            "data": function (d) {
	                    d.quickSearch = quickSearch;//encodeURI($('#quickSearch').val());
	                    d.formJson = JSON.stringify(searchCondition);
	                }
	            },
	        "tableTools": {
	            "sRowSelect": "bootstrap"
	        },
	        "columns": [
		         {"data": "ecOrderShow"}
		        ,{"data": "exceptionType"}
		        ,{"data": "partiallySend"}
		        ,{"data": "prjName"}
		        ,{"data": "shopName"}
		        ,{"data": "ecTradeCode"}
		        ,{"data": "status"}
		        ,{"data": "ecCustCode"}
		        ,{"data": "orderTime"}
		        ,{"data": "paidTime"}
		        ,{"data": "sendTime"}
		        ],
	        "columnDefs": [{
	            "orderable": false,
	            "targets": [0]
	        }
	        ],
	        "order": [[1, "asc"],[4, "asc"], [5, "asc"], [9, "desc"], [6, "asc"]]
	    });
}

/**
 * 已完成 列表
 * @returns
 */
function getEcTradeOver(){
	//如果已经初期化过，不用重新定义，直接重画表格
	if (tecTradeover!=null && tecTradeover != undefined && ""!=tecTradeover){
		tecTradeover.draw();
		return ;
	}
	tecTradeover = $('#tecTradeover').DataTable({
	        "processing": true,
	        "serverSide": true,
	        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "dom": '<"bottom"rtflp>',
	        "searching": false,
	        "pagingType": "full_numbers",
	        "deferRender": true,
	        "ajax": {
	            "url": "/ecTradeManager/ecTradeOver.action",
	            "data": function (d) {
	                    d.quickSearch = quickSearch;//encodeURI($('#quickSearch').val());
	                    d.formJson = JSON.stringify(searchCondition);
	                }
	            },
	        "tableTools": {
	            "sRowSelect": "bootstrap"
	        },
	        "columns": [
		         {"data": "ecOrderShow"}
		        ,{"data": "exceptionType"}
		        ,{"data": "splitFlg"}
		        ,{"data": "prjName"}
		        ,{"data": "shopName"}
		        ,{"data": "status"}
		        ,{"data": "ecCustCode"}
		        ,{"data": "orderTime"}
		        ,{"data": "paidTime"}
		        ,{"data": "sendTime"}
		        ,{"data": "endTime"}
		        ],
	        "columnDefs": [{
	            "orderable": false,
	            "targets": [0]
	        }
	        ],
	        "order": [[1, "asc"],[3, "asc"], [4, "asc"], [7, "desc"]]
	    });
}

/**
 * 已废弃 列表
 * @returns
 */
function getEcTradeCanceled(){
	//如果已经初期化过，不用重新定义，直接重画表格
	if (tecTradecanceled!=null && tecTradecanceled != undefined && ""!=tecTradecanceled){
		tecTradecanceled.draw();
		return ;
	}
	tecTradecanceled = $('#tecTradecanceled').DataTable({
	        "processing": true,
	        "serverSide": true,
	        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "dom": '<"bottom"rtflp>',
	        "searching": false,
	        "pagingType": "full_numbers",
	        "deferRender": true,
	        "ajax": {
	            "url": "/ecTradeManager/ecTradeCanceled.action",
	            "data": function (d) {
	                    d.quickSearch = quickSearch;//encodeURI($('#quickSearch').val());
	                    d.formJson = JSON.stringify(searchCondition);
	                }
	            },
	        "tableTools": {
	            "sRowSelect": "bootstrap"
	        },
	        "columns": [
		         {"data": "ecOrderShow"}
		        ,{"data": "prjName"}
		        ,{"data": "shopName"}
		        ,{"data": "ecTradeCode"}
		        ,{"data": "status"}
		        ,{"data": "ecCustCode"}
		        ,{"data": "orderTime"}
		        ,{"data": "paidTime"}
		        ],
	        "columnDefs": [{
	            "orderable": false,
	            "targets": [0]
	        }
	        ],
	        "order": [[2, "asc"], [3, "asc"], [7, "desc"], [4, "asc"]]
	    });
}

function refresh(){
	$("div .active").each(function(){
		switch ($(this).attr("id")) {
		case "portlettabcanceled": 	//已废弃
			tecTradecanceled.draw();
			break;
	    case "portlettabover":		//已完成
	    	tecTradeover.draw();
	        break;
	    case "portlettabsend":		//已发货
	    	tecTradesend.draw();
	        break;
	    case "portlettabwaiteSend":		//已处理
	    	tecTradewaiteSend.draw();
	        break;
	    case "portlettabnoDeal":		//待处理
	    	tecTradenoDeal.draw();
	        break;
	    case "portlettabnoPay":		//未付款
	    	tecTradenoPay.draw();
	        break;
		default:
	    	break;
		}
	});
	getCounts();
}

/**
 * 
 * @returns
 */
function exportEcTrade(){
	var fileName = "";
	var sql = "";
	$("div .active").each(function(){
		switch ($(this).attr("id")) {
		case "portlettabcanceled": 	//已废弃
			fileName = "已废弃";
			sql = 'exportSelectEcTradeCanceled';
			break;
	    case "portlettabover":		//已完成
	    	fileName = "已完成";
	    	sql = 'exportSelectEcTradeOver';
	        break;
	    case "portlettabsend":		//已发货
	    	fileName = "已发货";
	    	sql = 'exportSelectEcTradeSend';
	        break;
	    case "portlettabwaiteSend":		//待发货
	    	fileName = "已处理";
	    	sql = 'exportSelectEcTradeWaiteSend';
	        break;
	    case "portlettabnoDeal":		//待处理
	    	fileName = "待处理";
	    	sql = 'exportSelectEcTradeNoDeal';
	        break;
	    case "portlettabnoPay":		//未付款
	    	fileName = "未付款";
	    	sql = 'exportSelectEcTradeNoPay';
	        break;
		default:
	    	break;
		}
	});
	
	//特殊情况（附加导出字段）
	var obj = new Object();	
	obj.name = "项目名称";
	obj.value = "prjName";
	var obj1 = new Object();	
	obj1.name = "店铺名称";
	obj1.value = "shopName";
	var obj2 = new Object();	
	obj2.name = "平台交易号";
	obj2.value = "ecTradeCode";
	var obj3 = new Object();	
	obj3.name = "状态";
	obj3.value = "status";
	var obj4 = new Object();	
	obj4.name = "来源";
	obj4.value = "shopType";
	var obj5 = new Object();	
	obj5.name = "顾客ID";
	obj5.value = "ecCustCode";
	var obj6 = new Object();	
	obj6.name = "拍单时间";
	obj6.value = "orderTime";
	var obj7 = new Object();	
	obj7.name = "付款时间";
	obj7.value = "paidTime";
	var obj8 = new Object();	
	obj8.name = "完成时间";
	obj8.value = "endTime";
	var obj9 = new Object();	
	obj9.name = "异常描述";
	obj9.value = "exceptionType";
	var obj10 = new Object();	
	obj10.name = "平台商品编码";
	obj10.value = "ecItemCode";
	var obj11 = new Object();	
	obj11.name = "平台商品名称";
	obj11.value = "ecItemName";
	var obj12 = new Object();	
	obj12.name = "平台规格编码";
	obj12.value = "ecSkuCode";
	var obj13 = new Object();	
	obj13.name = "平台规格名称";
	obj13.value = "ecSkuName";
	var obj14 = new Object();	
	obj14.name = "平台状态";
	obj14.value = "ecOrderStatus";
	var obj15 = new Object();	
	obj15.name = "分单店铺";
	obj15.value = "splitShopName";
	var obj16 = new Object();	
	obj16.name = "系统状态";
	obj16.value = "erpStatus";
	var obj17 = new Object();	
	obj17.name = "删除原因";
	obj17.value = "deleteReason";
	var obj18 = new Object();	
	obj18.name = "发货时间";
	obj18.value = "shipTime";
	var obj19 = new Object();	
	obj19.name = "物流公司";
	obj19.value = "lgstName";
	var obj20 = new Object();	
	obj20.name = "物流单号";
	obj20.value = "lgstNo";
	
	var ob = [obj,obj1,obj2,obj3,obj4,obj5,obj6,obj7,obj8,obj9,obj10,obj11,obj12,obj13,obj14,obj15,obj16,obj17,obj18,obj19,obj20];
	extraFieldJson = JSON.stringify(ob);
	
	exportList('','/ecTradeManager/exportCheck.action','/ecTradeManager/export.action',sql,fileName,'frmAdvSearch',extraFieldJson)
}

/**
 * 删除提示
 * @param btnDelete
 * @returns
 */
function operationCanceled(btnDelete){
	orderId = $(btnDelete).attr("orderid");
	ecTradeId = $(btnDelete).attr("ecTradeId");
	updateTime = $(btnDelete).attr("updateTime");
	window.top.window.showModalConfirm("确定要废弃这个平台商品吗？", doDelete);
}

/**
 * 执行废弃平台商品操作
 * @returns
 */
function doDelete() {
	if (orderId == "") {
		return;
	}
    $.ajax({
        type:"POST",
        url:"/ecTradeManager/canceledEcItem.action?orderId=" + orderId+"&updateTime="+updateTime,
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
    
    var tablename =  "";
    var tabIndex = "";
    $("div .active").each(function(){
		switch ($(this).attr("id")) {
		case "portlettabcanceled": 	//已废弃
			tablename = "tecTradecanceled";
			tabIndex = "canceled";
			break;
	    case "portlettabover":		//已完成
	    	tablename = "tecTradeover";
	    	tabIndex = "over";
	        break;
	    case "portlettabsend":		//已发货
	    	tablename = "tecTradesend";
	    	tabIndex = "send";
	        break;
	    case "portlettabwaiteSend":		//已处理
	    	tablename = "tecTradewaiteSend";
	    	tabIndex = "waiteSend";
	        break;
	    case "portlettabnoDeal":		//待处理
	    	tablename = "tecTradenoDeal";
	    	tabIndex = "noDeal";
	    	break;
	    case "portlettabnoPay":		//未付款
	    	tablename = "tecTradenoPay";
	    	tabIndex = "noPay";
	        break;
		default:
	    	break;
		}
	});
    mapOrderTable[tablename + ecTradeId + tabIndex].draw();
    orderId = "";
    ecTradeId = "";
}

/**
 * 取得tab上面的数字
 * @returns
 */
function getCounts(){
	//未付款数字,待处理数字,待发货,全部发货,已完成数字,已废弃数字
	$.ajax({
        type:"GET",
        url:"/ecTradeManager/getTabCounts.action?quickSearch=" + encodeURI(encodeURI(quickSearch)) + "&formJson=" + JSON.stringify(searchCondition) ,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: true,//同步
        success:function(data) {
            if (data.result == "success") {
            	$("#portlettabcanceledid").html("已废弃(" + data.countCancel +")");
            	$("#portlettaboverid").html("已完成(" + data.countOver +")");
            	$("#portlettabsendid").html("全部发货(" + data.countSend +")");
            	$("#portlettabwaiteSendid").html("待发货(" + data.countWaitSend +")");
            	$("#portlettabnoDealid").html("待处理(" + data.countWait +")");
            	$("#portlettabnoPayid").html("未付款(" + data.countNoPay +")");
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
}
