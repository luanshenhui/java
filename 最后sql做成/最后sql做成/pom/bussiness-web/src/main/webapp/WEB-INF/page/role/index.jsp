<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" errorPage="" %>
<%@page isELIgnored="false" %>
<%@taglib uri="taglib" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/bootstrap-colorpicker/css/colorpicker.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/bootstrap-datepicker/css/datepicker.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/bootstrap-daterangepicker/daterangepicker-bs3.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">
<link type="text/css" rel="stylesheet" href="/Apollo/madmin/vendors/bootstrap-timepicker/css/bootstrap-timepicker.min.css">
</head>
<body>
<div class="page-content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <div class="portlet box portlet-blue" style="margin-bottom: 15px;">
                        <div class="portlet-header" >
                        <div class="caption">用户列表</div>
                                <div class="actions">
                                	<a href="#" class="btn btn-xs btn-danger" data-toggle="" data-target="" id="download">
                                		&nbsp;下载
                                	</a>&nbsp;
                                	<a href="#" class="btn btn-xs btn-warning" data-toggle="modal" data-target="" id="returnUp">
                                		&nbsp;返回群组
                                	</a>&nbsp;
                                	<a href="#" class="btn btn-xs btn-danger" data-toggle="" data-target="" id="returnBack">
                                		&nbsp;返回首页
                                	</a>&nbsp;
                                </div>
                        </div>
                        <div class="portlet-body">
                            <table id="logTable" class="table table-hover table-striped table-bordered table-advanced tb-sticky-header"
                                width="100%">
                                <thead>
                                    <tr>
                                        <th id="ths" width="10%" colValue="userRole">角色</th>
                                        <th width="8%" colValue="ghA">光环颜色1</th>
                                        <th width="8%" colValue="ghB">光环颜色2</th>
                                        <th width="12%" colValue="ghC">光环颜色3</th>
                                        <th width="15%" colValue="ghD">光环颜色4</th>
                                        <th width="10%" colValue="ghE">光环颜色5</th>
                                        <th width="10%" colValue="leve">等级</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="portlet box">
				<div class="portlet-header">
					<div class="caption"><span id="tm">${time}</span> 组编号  ${groupId} </div>
				</div>
				<div class="portlet-body">
					<div id="line-chart" style="width: 100%; height: 300px"></div>
				</div>
				<div class="portlet-body pan">
					<form role="form" class="form-horizontal form-separated">
                         <div class="col-md-3">
                           	<div class="datepicker-inline"></div>
                         </div>
                    </form>
                 </div>
                 <div class="portlet-header" >
                    <div class="actions">
                        <a href="#" class="btn btn-xs btn-danger" id="findTime">
                           &nbsp;查询
                        </a>&nbsp;
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
    
    <script src="/Apollo/madmin/vendors/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
    <script src="/Apollo/madmin/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
    <script src="/Apollo/madmin/js/form-components.js"></script>
    <script type="text/javascript">
    var logTable;
    jQuery(document).ready(function(){
    	var groupId='${groupId}';
    	logTable = $('#logTable').DataTable({
    	    "processing": true,
            "serverSide": true,
            "lengthMenu": [[10], [10]],
            "dom": '<"bottom"rtflp>',
            "searching": false,
            "pagingType": "full_numbers",
            "deferRender": true,
            "ajax": {
                "url": "/login/userListView.action?groupId="+groupId,
            },
            "fnDrawCallback": function (o) {
                $("#ths").removeClass("sorting_asc");
                for(var a=0;a<o.aoData.length;a++){
                	var tdlist=o.aoData[a]
                	$(tdlist.nTr).attr("person_id",tdlist.anCells[7].innerText);
                }
            },
            "tableTools": {
                "sRowSelect": "bootstrap"
            },
            "columns": [{
                	"data": "userRole"
            	}, {
                    "data": "ghA"
    			}, {
    				"data": "ghB"
    			}, {
    				"data": "ghC"
    			}, {
    				"data": "ghD"
    			}, {
    				"data": "ghE"
    			}, {
    				"data": "leve"
    			}, {
    				"data": "person_id"
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
                       	{"orderable":false,
                       	  "visible": false,
                           	"targets":[7]},
                   ]
        });
    	
    	$("#returnBack").click(function () {
//     	    window.location.href='province.action';
    		window.location.href='../../dashboard.html';
    	});
    	
    	$("#returnUp").click(function () {
    		history.back(-1);
    	});
    	
    	$("#download").click(function () {
    		var groupId=${groupId};
    		window.location.href='userDownload.action?groupId='+groupId;
    	});
    	
    	 $('#logTable tbody').on('click','td',function () {
    		 var personId=$(this).parent().attr('person_id');
    		 var personName=$(this).parent().children().eq(0).text();
    		 window.location.href='oracleDraw.action?personId='+personId+"&personName="+encodeURI(encodeURI(personName));
    	 })
    	
    });
    </script>
    <script src="/Apollo/madmin/vendors/flot-chart/jquery.flot.js"></script>
    <script src="/Apollo/madmin/vendors/flot-chart/jquery.flot.categories.js"></script>
    
    <script src="/Apollo/madmin/vendors/flot-chart/jquery.flot.tooltip.js"></script>
	<script type="text/javascript">
	$("#findTime").click(function () {
		findTime();
	});
	
	var groupId='${groupId}';
	jQuery.ajax( {
		url : "getStreetDrew.action",
		type : "post",
		data : {
			person_id : groupId
		},
		success : function(data) {
			street(data.data);
		}
	});
	
	function findTime(){
		var month=$(".datepicker table tr td span[class='month active']").text();
		var year = $(".datepicker table tr td span[class='month active']").parent().parent().parent().prev().children().eq(0).children().eq(1).text();
		if(!month){
			return false;
		}
		var time=year+"-"+month;
		jQuery.ajax( {
			url : "getStreetDrew.action",
			type : "post",
			data : {
				person_id : groupId,
				month : time
			},
			success : function(data) {
				street(data.data);
				if(month=="Jan"){
					month="01";
				}else if(month=="Feb"){
					month="02";
				}else if(month=="Mar"){
					month="03";
				}else if(month=="Apr"){
					month="04";
				}else if(month=="May"){
					month="05";
				}else if(month=="Jun"){
					month="06";
				}else if(month=="Jul"){
					month="07";
				}else if(month=="Aug"){
					month="08";
				}else if(month=="Sep"){
					month="09";
				}else if(month=="Oct"){
					month="10";
				}else if(month=="Nov"){
					month="11";
				}else if(month=="Dec"){
					month="12";
				}
				$("#tm").text(year+"年"+month+"月")
			}
		});
	}
	
	function street(data){
		$.plot("#line-chart", data ,{
	        series: {
	            lines: {
	                show: !0,
	                fill: .01
	            },
	            points: {
	                show: !0,
	                radius: 4
	            }
	        },
	        grid: {
	            borderColor: "#fafafa",
	            borderWidth: 1,
	            hoverable: !0
	        },
	        tooltip: !0,
	        tooltipOpts: {
	            content: "%y",
	            defaultTheme: false
	        },
	        xaxis: {
	            tickColor: "#fafafa",
	            mode: "categories"
	        },
	        yaxis: {
	            tickColor: "#fafafa"
	        },
	        shadowSize: 0
	    });
	} 
	</script>
</body>
</html>