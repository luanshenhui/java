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
<title>走势图</title>
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

	<div class="portlet box">
	   <div class="portlet-header">
                        <div class="caption"></div>
                        ${personName} 
                                <div class="actions">
                                	<a href="#" class="btn btn-xs btn-warning" data-toggle="modal" data-target="" id="returnUp">
                                		&nbsp;返回上层
                                	</a>&nbsp;
                                	<a href="#" class="btn btn-xs btn-danger" data-toggle="" data-target="" id="returnBack">
                                		&nbsp;返回首页
                                	</a>&nbsp;
                                </div>
                        </div>
		<div class="portlet-body">
			<div id="basic-bar"></div>
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
    
    <script src="/Apollo/madmin/vendors/jquery-highcharts/highcharts.js"></script>
    
    <script src="/Apollo/madmin/vendors/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
    <script src="/Apollo/madmin/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
    <script src="/Apollo/madmin/js/form-components.js"></script>
    <script type="text/javascript">
	$("#findTime").click(function () {
		findTime();
	});
    
    $(function () {
    	var personId='${personId}';
    	jQuery.ajax( {
    		url : "getOracleDrew.action",
    		type : "post",
    		data : {
    			person_id : personId
    		},
    		success : function(data) {
    			oracleDraw(data)
    		}
    	});
    });
    
    jQuery(document).ready(function(){
    	$("#returnBack").click(function () {
    		window.location.href='../../dashboard.html';
    	});
    	
    	$("#returnUp").click(function () {
    		history.back(-1);
    	});
    });
    
	function findTime(){
		var personId='${personId}';
		var month=$(".datepicker table tr td span[class='month active']").text();
		if(!month){
			return false;
		}
		var year = $(".datepicker table tr td span[class='month active']").parent().parent().parent().prev().children().eq(0).children().eq(1).text();
		var time=year+"-"+month;
		jQuery.ajax( {
			url : "getOracleDrew.action",
			type : "post",
			data : {
				person_id :personId,
				month : time
			},
			success : function(data) {
				oracleDraw(data)
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
// 				$("#tm").text(year+"年"+month+"月")
			}
		});
	}
    
    function oracleDraw(data){
    	 $('#basic-bar').highcharts({
 	        chart: {
 	            type: 'bar'
 	        },
 	        title: {
 	            text: '用户统计柱状图'
 	        },
 	        xAxis: {
 	            categories: data.listday,
 	            title: {
 	                text: null
 	            }
 	        },
 	        yAxis: {
 	            min: 0,
 	            title: {
 	                text: '统计',
 	                align: 'high'
 	            },
 	        },
 	        tooltip: {
 	            valueSuffix: ' 次'
 	        },
 	        plotOptions: {
 	            bar: {
 	                dataLabels: {
 	                    enabled: true
 	                }
 	            }
 	        },
 	        series: data.data
 	    });
    }
    </script>
</body>
</html>