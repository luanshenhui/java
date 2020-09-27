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
<body id="signup-page">
    <div class="page-form">
        <form id="signup-form"  class="form">
<!--             <div class="header-content"> -->
<!--                 <h1>输入新密码</h1> -->
<!--             </div> -->
            <div class="body-content">
                <div class="form-group">
                    <div class="input-icon right"><i class="fa fa-key"></i>
                        <input id="password" type="password" placeholder="新密码" minlength="6" maxlength="12" name="password" class="form-control required">
                         <input id="hidden" type="hidden" >
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-icon right"><i class="fa fa-key"></i>
                        <input type="password" placeholder="确认密码" name="passwordConfirm" minlength="6" maxlength="12" class="form-control required">
                    </div>
                </div>
                <div class="form-group mbn"><a href="javascript:;" id="save" class="btn btn-warning">
                	<i class="fa fa-chevron-circle-left"></i>&nbsp;
						保存</a>
                </div>
            </div>
        </form>
    </div>
 	<script src="/Apollo/madmin/js/jquery-1.10.2.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-ui.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-validate/jquery.validate.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-validate/message_zh.js"></script>
    <script type="text/javascript">
    $("#save").click(function () {
    	if(!$("#signup-form").valid()) {
      		 return false;
      	}
    	jQuery.ajax( {
    		url : "updatePassword.action",
    		type : "post",
    		data: $("#signup-form").serialize(),
    		success : function(data) {
    			if(data.result=="success"){
    				alert("密码修改成功")
    			}
    		}
    	});
	});
    </script>
</body>
</html>