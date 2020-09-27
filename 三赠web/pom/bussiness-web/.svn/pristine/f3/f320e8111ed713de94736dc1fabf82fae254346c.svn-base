// INIT DATATABLES
$(function () {
	// 汉化 start
	var oLanguage={
        "oAria": {
            "sSortAscending": ": 升序排列",
            "sSortDescending": ": 降序排列"
        },
        "oPaginate": {
            "sFirst": "首页",
            "sLast": "末页",
            "sNext": "下页",
            "sPrevious": "上页"
        },
        "sEmptyTable": "没有相关记录",
        "sInfo": "第 _START_ 到 _END_ 条记录，共 _TOTAL_ 条",
        "sInfoEmpty": "第 0 到 0 条记录，共 0 条",
        "sInfoFiltered": "(从 _MAX_ 条记录中检索)",
        "sInfoPostFix": "",
        "sDecimal": "",
        "sThousands": ",",
        "sLengthMenu": "每页显示条数: _MENU_",
        "sLoadingRecords": "正在载入...",
        "sProcessing": "正在载入...",
        "sSearch": "搜索：",
        "sSearchPlaceholder": "",
        "sUrl": "",
        "sZeroRecords": "没有相关记录"
    }
    $.fn.dataTable.defaults.oLanguage=oLanguage;
	// 汉化 over
	
	// Init
    var spinner = $( ".spinner" ).spinner();
    var table = $('#table_id').dataTable( {
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "searching":false,
        "dom": '<"bottom"rtflp>',
        "pagingType":"full_numbers",
        "tableTools": {
            "sSwfPath": "/js/datatables/tabletools/swf/copy_csv_xls_pdf.swf",
            "aButtons": [],
            "sRowSelect": "bootstrap"
        }
    } );

//    var tableTools = new $.fn.dataTable.TableTools( table, {
//    	"sSwfPath": "/Apollo/madmin/vendors/DataTables/extensions/TableTools/swf/copy_csv_xls_pdf.swf",
//        "buttons": []
//    } );
    $(".DTTT_container").css("float","right");
});


