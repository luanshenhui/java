/**
 * Created by liming on 2017-1-20.
 */
$(document).ready(function () {
    // 输入有效性验证
    $("#newForm").validate({
        debug:true,
        rules : {
            expire_time:{
                compareDate:true
            }
        },
        errorPlacement: function(error, element)
        {
            error.insertAfter(element);
        }
    });

    $("#editForm").validate({
        debug:true,
        rules : {
            expire_time_m:{
                compareDate2:true
            }
        },
        errorPlacement: function(error, element)
        {
            error.insertAfter(element);
        }
    });

    $.validator.addMethod("compareDate",function(value,element){
        var assigntime = $("#expire_time").val();
        //var myDate = new Date();
        var deadlinetime = getNowFormatDate();
        var reg = new RegExp('-','g');
        assigntime = assigntime.replace(reg,'/');//正则替换
        deadlinetime = deadlinetime.replace(reg,'/');
        assigntime = new Date(parseInt(Date.parse(assigntime),19));
        deadlinetime = new Date(parseInt(Date.parse(deadlinetime),19));
        if(assigntime>deadlinetime){
            return true;
        }else{
            return false;
        }
    },"<font color='#E47068'>到期时间必须大于当前时间</font>");

    $.validator.addMethod("compareDate2",function(value,element){
        //alert(1);
        //debugger;
        var assigntime = $("#expire_time_m").val();
        //var myDate = new Date();
        var deadlinetime = getNowFormatDate();
        var reg = new RegExp('-','g');
        assigntime = assigntime.replace(reg,'/');//正则替换
        deadlinetime = deadlinetime.replace(reg,'/');
        assigntime = new Date(parseInt(Date.parse(assigntime),19));
        deadlinetime = new Date(parseInt(Date.parse(deadlinetime),19));
        if(assigntime>deadlinetime){
            return true;
        }else{
            return false;
        }
    },"<font color='#E47068'>到期时间必须大于当前时间</font>");


    // 加载项目列表
    $('#t_project').DataTable({
        "processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>', //自定义表尾工具条
        //"dom": '<"toolbar">frtip', //自定义表头工具条
        //"ordering": false, //禁止列排序
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/projectManager/getProjectList.action",
            "data": function ( d ) {
                d.quickSearch = encodeURI($('#quickSearch').val());
            }
        },
        "tableTools": {
            //"sSwfPath": "/js/datatables/tabletools/swf/copy_csv_xls_pdf.swf",
            //"aButtons": [],
            "sRowSelect": "bootstrap"
        },
        "columns": [
            {"data": "prjId", "searchable": false},
            {"data": "prjName"},
            {"data": "entName"},
            {"data": "prjType", "searchable": false},
            {"data": "cons", "searchable": false},
            {"data": "tel", "searchable": false},
            {"data": "createTime", "searchable": false},
            {"data": "expireTime", "searchable": false},
            {"data": "enableStatus", "searchable": false},
            {"data": "operation", "searchable": false}
        ],
        "columnDefs": [
            {
                "targets": [0],
                "visible": false,
                "searchable": false
            },{
                "orderable":false,
                "targets":[9]
            }
        ],
        "order": [[ 0, "asc" ]]
    });

    // 快速搜索
    $("#btnQuickSearch").click(function () {
        $('#t_project').DataTable().ajax.reload(null, false);
    });

    // 搜索框的回车事件
    $('#quickSearch').keydown(function(e){
        if(e.keyCode==13){
            $("#btnQuickSearch").click();
        }
    });

    // 编辑对话框关闭事件发生
    $('#frmNewProject').on('hide.bs.modal', function () {
        // 父窗体归还本页的编辑对话框
        window.top.window.returnCustomModalDialog();
    })

    // 新增弹出
    $("#newProjectHref").click(function () {
        // 父窗体借用本页的编辑对话框
        var editDialog = window.top.window.borrowCustomModalDialog($("#frmNewProject"));
        editDialog.modal({show:true, backdrop:'static'});
    });

    // 新增保存
    $("#btnSave").click(function () {
        //debugger;
        // 父窗体归还本页的编辑对话框
        window.top.window.returnCustomModalDialog();

        // 输入有效性验证
        if(!$("#newForm").valid()) {
            // 父窗体借用本页的编辑对话框
            window.top.window.borrowCustomModalDialog($("#frmNewProject"));
            return false;
        }


        var prj_name = $('#prj_name').val();
        var prj_type = $('#prj_type').val();
        var cons = $('#cons').val();
        var tel = $('#tel').val();
        var expire_time = $('#expire_time').val();
        var remark = $('#remark').val();
        var data = {
            "prjName": prj_name,
            "prjType": prj_type,
            "cons": cons,
            "tel": tel,
            "expireTime": expire_time,
            "remark": remark
        }
        // 父窗体归还本页的编辑对话框
        var newForm=window.top.window.borrowCustomModalDialog($("#frmNewProject"));

        $.ajaxSettings['contentType'] = "application/x-www-form-urlencoded; charset=utf-8";
        $.ajax({
            type: "POST",
            url: "/projectManager/insertProject.action",
            data: JSON.stringify(data),
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (json) {
                if (json.result=="success") {
                    newForm.modal('hide');
                    $('#prj_name').val('');
                    $('#prj_type').val('代销');
                    $('#cons').val('');
                    $('#tel').val('');
                    $('#expire_time').val('');
                    $('#remark').val('');
                    $('#t_project').DataTable().ajax.reload(null, false);

                    // 创建成功后启用项目
                    $('#prj_id_enable').val(json.prjId);
                    window.top.window.showModalConfirm( "创建项目成功，是否启用该项目？", doEnable);
                } else {
                    window.top.window.showModalAlert(json.msg);
                }
            }
        });
    });

    // 修改保存
    $("#btnSave_m").click(function () {
        // 父窗体归还本页的编辑对话框
        window.top.window.returnCustomModalDialog();

        // 输入有效性验证
        if(!$("#editForm").valid()) {
            // 父窗体借用本页的编辑对话框
            window.top.window.borrowCustomModalDialog($("#frmModifyProject"));
            return false;
        }

        var prj_id = $('#prj_id_m').val();
        var prj_name = $('#prj_name_m').val();
        var prj_type = $('#prj_type_m').val();
        var cons = $('#cons_m').val();
        var tel = $('#tel_m').val();
        var expire_time = $('#expire_time_m').val();
        //var expire_time1= "2016-03-03 00:00:00";
        var remark = $('#remark_m').val();
        var data = {
            "prjId": prj_id,
            "prjName": prj_name,
            "prjType": prj_type,
            "cons": cons,
            "tel": tel,
            "expireTime": expire_time,
            "remark": remark
        }

        // 父窗体归还本页的编辑对话框
        var edit=window.top.window.borrowCustomModalDialog($("#frmModifyProject"));

        $.ajaxSettings['contentType'] = "application/x-www-form-urlencoded; charset=utf-8";

        // 验证项目名称
        $.ajax({
            type: "POST",
            url: "/projectManager/updateProject.action",
            data: JSON.stringify(data),
            contentType: "application/json;charset=utf-8",
            dataType: "json",
            success: function (json) {
                if (json.result == "true") {
                    edit.modal('hide');
                    $('#prj_name_m').val('');
                    $('#prj_type_m').val('代销');
                    $('#cons_m').val('');
                    $('#tel_m').val('');
                    $('#expire_time_m').val('');
                    $('#remark_m').val('');
                    $('#t_project').DataTable().ajax.reload(null, false);
                    window.top.window.showScoMessage('ok', '保存成功');
                } else {
                    window.top.window.showModalAlert(json.msg);
                }
            }
        });
    });

    $('#frmNewProject').on('hidden.bs.modal', function () {
        //$("#frmNewProject").data('bootstrapValidator').resetForm();
        $("#newForm")[0].reset();
    });
    $('#frmModifyProject').on('hidden.bs.modal', function () {
        //$("#frmModifyProject").data('bootstrapValidator').resetForm();
        $("#editForm")[0].reset();
    });

    // 编辑对话框关闭事件发生
    $('#frmModifyProject').on('hide.bs.modal', function () {
        // 父窗体归还本页的编辑对话框
        window.top.window.returnCustomModalDialog();
    })

});

function operationEdit(btnEdit) {
    var prjId = $(btnEdit).attr("prjId");
    $.ajax({
        type: "POST",
        url: "/projectManager/getProject/" + prjId + ".action",
        data: null,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (json) {
            if (json.success) {

                // 记录prjId
                $('#prj_id_m').val(prjId);
                $('#prj_name_m').val(json.data[0].prj_name);
                $('#prj_type_m').val(json.data[0].prj_type);
                $('#cons_m').val(json.data[0].cons);
                $('#tel_m').val(json.data[0].tel);
                $('#expire_time_m').val(json.data[0].expire_time);
                //$('#expire_time_m').val("2017-02-07T07:07");
                $('#remark_m').val(json.data[0].remark);
                $('#ent_name_m').val(json.data[0].ent_name);
                //debugger;
                if (json.data[0].enable == 'y')
                {
                    $('#prj_name_m').attr("disabled",true);
                    $('#prj_type_m').attr("disabled",true);
                }
                else
                {
                    $('#prj_name_m').attr("disabled",false);
                    $('#prj_type_m').attr("disabled",false);
                }

                // 父窗体借用本页的编辑对话框
                var editDialog = window.top.window.borrowCustomModalDialog($("#frmModifyProject"));
                editDialog.modal({show:true, backdrop:'static'});

            } else {

            }
        }
    });

    $('#frmModifyProject').modal('show');

}

function operationEnable(btnEnable) {
    var prjId = $(btnEnable).attr("prjId");
    $('#prj_id_enable').val(prjId);
    window.top.window.showModalConfirm( "是否确认启用该项目？", doEnable);
}

function doEnable() {
    var prjId = $('#prj_id_enable').val();

    $.ajax({
        type: "POST",
        url: "/projectManager/updatePrjEnable/" + prjId + ".action",
        data: null,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (json) {
            if (json.success) {
                $('#t_project').DataTable().ajax.reload(null, false);
                window.top.window.showScoMessage('ok', '启用成功');
                // setTimeout(function(){
                //     window.top.window.showModalConfirm( "启用成功，是否创建店铺？", doCreateShop);
                // },100);
            } else {
                window.top.window.showModalAlert(json.msg);
            }
        }
    });
}

// 链接创建店铺
function doCreateShop() {
    alert("链接");
}

function operationDisable(btnDisable) {
    var prjId = $(btnDisable).attr("prjId");
    $('#prj_id_unenable').val(prjId);
    window.top.window.showModalConfirm( "停用项目将一并停用项目所有店铺，是否确认停用？", doDisable);
}

// 停用
function doDisable() {
    var prjId = $('#prj_id_unenable').val();

    $.ajax({
        type: "POST",
        url: "/projectManager/updatePrjDisable/" + prjId + ".action",
        data: null,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (json) {
            if (json.success) {
                //debugger;
                window.top.window.showScoMessage('ok', '停用成功');
                $('#t_project').DataTable().ajax.reload(null, false);
            } else {
                window.top.window.showModalAlert(json.msg);
            }
        }
    });

    $('#t_project').DataTable().ajax.reload(null, false);

}

function operationDelete(btnDelete) {
    var prjId = $(btnDelete).attr("prjId");
    $('#prj_id_delete').val(prjId);
    window.top.window.showModalConfirm( "删除项目将一并删除项目所有店铺，是否确认删除？", doDelete);
}

// 删除
function doDelete() {
    var prjId = $('#prj_id_delete').val();

    $.ajax({
        type: "POST",
        url: "/projectManager/deleteProject/" + prjId + ".action",
        data: null,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        success: function (json) {
            if (json.success) {
                //debugger;
                window.top.window.showScoMessage('ok', '删除成功');
                $('#t_project').DataTable().ajax.reload(null, false);
            } else {
                window.top.window.showModalAlert(json.msg);
            }
        }
    });
}

function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = year + seperator1 + month + seperator1 + strDate
        + " " + date.getHours() + seperator2 + date.getMinutes()
        + seperator2 + date.getSeconds();
    return currentdate;
}

function exportPrjList(){

}