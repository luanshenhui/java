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
</head>
<body>

	 <div class="page-content">
                    <div id="change-transitions" class="row">
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="bounce" class="btn btn-success btn-block">bounce</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="flash" class="btn btn-success btn-block">flash</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="pulse" class="btn btn-success btn-block">pulse</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="rubberBand" class="btn btn-success btn-block">rubberBand</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="shake" class="btn btn-success btn-block">shake</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="swing" class="btn btn-success btn-block">swing</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="tada" class="btn btn-success btn-block">tada</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="wobble" class="btn btn-success btn-block">wobble</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="bounceIn" class="btn btn-success btn-block">bounceIn</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="bounceInDown" class="btn btn-success btn-block">bounceInDown</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="bounceInLeft" class="btn btn-success btn-block">bounceInLeft</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="bounceInRight" class="btn btn-success btn-block">bounceInRight</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="bounceInUp" class="btn btn-success btn-block">bounceInUp</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeIn" class="btn btn-success btn-block">fadeIn</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInDown" class="btn btn-success btn-block">fadeInDown</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInDownBig" class="btn btn-success btn-block">fadeInDownBig</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInLeft" class="btn btn-success btn-block">fadeInLeft</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInLeftBig" class="btn btn-success btn-block">fadeInLeftBig</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInRight" class="btn btn-success btn-block">fadeInRight</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInRightBig" class="btn btn-success btn-block">fadeInRightBig</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInUp" class="btn btn-success btn-block">fadeInUp</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="fadeInUpBig" class="btn btn-success btn-block">fadeInUpBig</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="flip" class="btn btn-success btn-block">flip</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="flipInX" class="btn btn-success btn-block">flipInX</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="flipInY" class="btn btn-success btn-block">flipInY</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="lightSpeedIn" class="btn btn-success btn-block">lightSpeedIn</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="rotateIn" class="btn btn-success btn-block">rotateIn</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="rotateInDownLeft" class="btn btn-success btn-block">rotateInDownLeft</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="rotateInDownRight" class="btn btn-success btn-block">rotateInDownRight</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="rotateInUpLeft" class="btn btn-success btn-block">rotateInUpLeft</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="rotateInUpRight" class="btn btn-success btn-block">rotateInUpRight</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="slideInDown" class="btn btn-success btn-block">slideInDown</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="slideInLeft" class="btn btn-success btn-block">slideInLeft</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="slideInRight" class="btn btn-success btn-block">slideInRight</button>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="box-placeholder">
                                <button data-toggle="dropdown" data-value="rollIn" class="btn btn-success btn-block">rollIn</button>
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
    
    <script src="/Apollo/madmin/vendors/jquery-highcharts/highcharts.js"></script>
<%--     <script src="/Apollo/madmin/vendors/jquery-highcharts/highcharts-more.js"></script> --%>
<%--     <script src="/Apollo/madmin/vendors/jquery-highcharts/data.js"></script> --%>
<%--     <script src="/Apollo/madmin/vendors/jquery-highcharts/drilldown.js"></script> --%>
<%--     <script src="/Apollo/madmin/vendors/jquery-highcharts/exporting.js"></script> --%>
    <script src="/Apollo/madmin/js/charts-highchart-column-bar.js"></script>
    <script type="text/javascript">
    jQuery(document).ready(function(){

    });
    </script>
</body>
</html>