var delegateTable;
$(function () {
	// 初始化表格控件
	delegateTable = $('#delegateTable').DataTable({
    	"processing": true,
        "serverSide": true,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "ajax": {
            "url": "/user/userList.action",
            "data": function ( d ) {
            	if ($("#advSearchPanel").is(":hidden")) {
            		d.quickSearch = encodeURI($('#userFullname').val());
            	}else{
                    // 高级查询条件
                    var unitID = $('#unitID').val();//组织机构
                    var userAccount = $('#userAccount').val();
                    var userAccountLocked = $('#userAccountLocked').val();
                    var userFullname = encodeURI($('#userName').val());
                    var advData = {
                        "unitID": unitID,
                        "userAccount": userAccount,
                        "userAccountLocked": userAccountLocked,
                        "userFullname": userFullname
                    };

                    d.formJson = JSON.stringify(advData);
                
            	}
            }
        },
        "tableTools": {
            "sRowSelect": "bootstrap"
        },
        "columns": [
        	{"data": "chk"},
        	{"data": "userFullname"},
        	{"data": "userAccount"},
        	{"data": "userDescription"},
        	{"data": "userUnits"},
        	{"data": "userRoles"},
        	{"data": "userAccountLocked"}
        ],
        "columnDefs": [{
        	"orderable":true,
        	"targets":[1]
    	}
    ],
        "order": [[ 1, "asc" ]]
    });
});


