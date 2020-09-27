var storTable;
var btnAdvSearchflg= false;
jQuery(document).ready(function(){
    storTable = $('#storTable').DataTable({
        "processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/stor/storList.action",
            "data": function ( d ) {
                 if ($("#advSearchPanel").is(":hidden")) {
                     d.quickSearch = encodeURI($('#quickSearch').val());
                 }
                 else {
                     // 高级查询条件
                     var gstorname = encodeURI($('#gstorname').val());
                     var gstorcode =encodeURI($('#gstorcode').val());
                     var gprjName =encodeURI($('#gprjName').val());
                     var advData = {
                         "gstorname": gstorname,
                         "gstorcode": gstorcode,
                         "gprjName": gprjName
                     };
                     d.formJson = JSON.stringify(advData);
                 }
                }
        },
        "tableTools": {
            "sRowSelect": "bootstrap"
        },
        "columns": [{
                "data": "chk"
            }, {
                "data": "storId"
            }, {
                "data": "storName"
            }, {
                "data": "storCode"
            }, {
                "data": "prjId"
            }, {
                "data": "prjName"
            }
        ],
        "columnDefs": [{
                "orderable":false,
                "targets":[0]
            },{
                "orderable":false,
                "targets":[1]
            },{
                "orderable":false,
                "targets":[4]
            }
        ],
        "order": [[ 2, "desc" ],[ 3, "desc" ],[ 5, "desc" ]]
    });
});


//重置按钮
$("#advSearchReset").click(function(){
    $('#gstorname').val('');
    $('#gstorcode').val('');
    $('#gprjName').val('');
});
//低级查询按钮
$("#btnQuickSearch").click(function () {
    storTable.draw();
});
//高级查询按钮
$("#advSearchSubmit").click(function () {
    setHidValue("frmAdvSearch");
    storTable.draw();
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

$("#advSearchPanel").click(function () {
    btnAdvSearchflg = true;
})

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