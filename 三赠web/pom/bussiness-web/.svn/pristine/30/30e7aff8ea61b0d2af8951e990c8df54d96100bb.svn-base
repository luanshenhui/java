<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" errorPage="" %>
<%@page isELIgnored="false" %>
<%@taglib uri="taglib" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- <jsp:include page="/WEB-INF/page/include/base.jsp" /> --%>
<script type="text/javascript">

</script>
<title>角色</title>
<!-- 加载 bootstrap 样式-->
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/jquery-ui-1.10.4.custom/css/ui-lightness/jquery-ui-1.10.4.custom.min.css" />
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/font-awesome/css/font-awesome.min.css" />
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/bootstrap/css/bootstrap.min.css" />

<!-- 加载本页需要的三方插件样式 -->
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/DataTables/media/css/jquery.dataTables.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/DataTables/extensions/TableTools/css/dataTables.tableTools.min.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/DataTables/media/css/dataTables.bootstrap.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/jquery-tablesorter/themes/blue/style-custom.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/jquery-bootstrap-wizard/custom.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/jquery-steps/css/jquery.steps.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/animate.css/animate.css" />
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/iCheck/skins/all.css" />
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">

<!-- 加载主题风格样式 -->
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/css/themes/style1/orange-blue.css" class="default-style" />
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/css/themes/style1/orange-blue.css" id="theme-change"
    class="style-change color-change" />
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/css/style-responsive.css" />
</head>
<body>
<div class="page-content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <div class="portlet box portlet-blue" style="margin-bottom: 15px;">
                        <div class="portlet-header">
                        <div class="caption">角色列表</div>
                        <div class="actions">
                                	<a href="#" class="btn btn-xs btn-warning" data-toggle="" data-target="" id="addRole">
                                		&nbsp;添加角色
                                	</a>&nbsp;
                                </div>
                        </div>
<!--                         <div><input type="text"></input><div> -->
                        <div class="portlet-body">
                            <table id="logTable" class="table table-hover table-striped table-bordered table-advanced tb-sticky-header"
                                width="100%">
                                <thead>
                                    <tr>
                                        <th id="ths" width="10%" colValue="role_type">角色类型</th>
                                        <th width="8%" colValue="role_name">角色</th>
                                        <th width="8%" colValue="c_a">光环颜色1</th>
                                        <th width="12%" colValue="c_b">光环颜色2</th>
                                        <th width="15%" colValue="c_c">光环颜色3</th>
                                        <th width="10%" colValue="c_d">光环颜色4</th>
                                        <th width="10%" colValue="c_e">光环颜色5</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    

 	<script src="/Apollo/madmin/js/jquery-1.10.2.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-ui.js"></script>

    <!-- 加载 bootstrap 和三方插件 js -->
    <script src="/Apollo/madmin/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="/Apollo/madmin/vendors/bootstrap-hover-dropdown/bootstrap-hover-dropdown.js"></script>
    <script src="/Apollo/madmin/js/html5shiv.js"></script>
    <script src="/Apollo/madmin/js/respond.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-cookie/jquery.cookie.js"></script>
    <script src="/Apollo/madmin/vendors/iCheck/icheck.min.js"></script>
    <script src="/Apollo/madmin/vendors/iCheck/custom.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-notific8/jquery.notific8.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-pace/pace.min.js"></script>
    <script src="/Apollo/madmin/vendors/holder/holder.js"></script>
    <script src="/Apollo/madmin/vendors/responsive-tabs/responsive-tabs.js"></script>
    <script src="/Apollo/madmin/vendors/moment/moment.js"></script>
    <script src="/Apollo/madmin/vendors/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>
    <script src="/Apollo/madmin/vendors/DataTables/media/js/jquery.dataTables.js"></script>
    <script src="/Apollo/madmin/vendors/DataTables/media/js/dataTables.bootstrap.js"></script>
    <script src="/Apollo/madmin/vendors/DataTables/extensions/TableTools/js/dataTables.tableTools.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-tablesorter/jquery.tablesorter.js"></script>
    <script src="/Apollo/madmin/js/table-advanced.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-validate/jquery.validate.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-validate/message_zh.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-steps/js/jquery.steps.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-bootstrap-wizard/jquery.bootstrap.wizard.min.js"></script>
    
    <script type="text/javascript">
    var logTable;
    jQuery(document).ready(function(){
    	logTable = $('#logTable').DataTable({
    	    "processing": true,
            "serverSide": true,
            "lengthMenu": [[10], [10]],
            "dom": '<"bottom"rtflp>',
            "searching": false,
            "pagingType": "full_numbers",
            "deferRender": true,
            "ajax": {
                "url": "/login/roleListView.action",
            },
            "fnDrawCallback": function (o) {
                $("#ths").removeClass("sorting_asc");
            },
            "tableTools": {
                "sRowSelect": "bootstrap"
            },
            "columns": [{
                	"data": "role_type"
            	}, {
                    "data": "role_name"
    			}, {
    				"data": "c_a"
    			}, {
    				"data": "c_b"
    			}, {
    				"data": "c_c"
    			}, {
    				"data": "c_d"
    			}, {
    				"data": "c_e"
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
                       		"targets":[6]},
                   ]
        });
    	
    	 $('#logTable tbody').on('click','td',function () {
    		 var roleType=$(this).parent().children().eq(0).text();
    		 var roleName=$(this).parent().children().eq(1).text();
    		 window.location.href='oneRolePage.action?roleType='+roleType+"&roleName="+roleName;
    	 })
    	
    });
    
 	$("#addRole").click(function () {
 		window.location.href='addRolePage.action?';
	});
    </script>
</body>
</html>