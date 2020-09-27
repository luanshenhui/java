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
	          <div  style="margin-bottom: 15px;">
	          <div class="portlet-header">
	          	 <div class="actions" style="float: right;margin-bottom: 15px;">
                                	<a href="#" class="btn btn-xs btn-danger" data-toggle="" data-target="" id="saveRole">
                                		&nbsp;保存
                                	</a>&nbsp;
                                	<a href="#" class="btn btn-xs btn-danger" data-toggle="" data-target="" id="return">
                                		&nbsp;返回上层
                                	</a>&nbsp;
                                </div>
              				</div>
	          			</div>
	          </div>
	         <div class="portlet box portlet-blue" style="margin-bottom: 15px;">
	          	<div class="portlet-header"></div>
	            	<div class="row">
		                    <div class="modal-header modal-header-primary">
		                        <h5>新建角色</h5>
		                    </div>
			                    <div class="modal-body">
									<form id="form"  action="/login/saveRoleVo.action" class="form-horizontal" method="post" enctype="multipart/form-data">
									<div class="form-group">
											<label class="col-lg-3 col-xs-3 col-sm-3 col-md-3 control-label">角色类型<span class='require'>*</span>
											</label>
											<div class="col-sm-9">
			                                    <select id="roleType"  name="roleType" required class="form-control "></select>
											</div>
										</div>
										<div class="form-group">
											<label  class="col-lg-3 col-xs-3 col-sm-3 col-md-3 control-label">颜色1名称
											</label>
											<div class="col-sm-6">
			                                    <input id="c_a"  name="c_a" required type="text"  maxlength="12" class="form-control " />
											</div>
											<div class="col-sm-3">
			                                    <input type="file" name="file1" required/>
											</div>
										</div>
										<div class="form-group">
											<label class="col-lg-3 col-xs-3 col-sm-3 col-md-3 control-label">颜色2名称
											</label>
											<div class="col-sm-6">
			                                    <input id="c_b"  name="c_b" required type="text"  maxlength="12" class="form-control " />
											</div>
											<div class="col-sm-3">
			                                    <input type="file" name="file2" required/>
											</div>
										</div>
										<div class="form-group">
											<label  class="col-lg-3 col-xs-3 col-sm-3 col-md-3 control-label">颜色3名称
											</label>
											<div class="col-sm-6">
			                                    <input id="c_c"  name="c_c" required type="text"  maxlength="12" class="form-control " />
											</div>
											<div class="col-sm-3">
			                                    <input type="file" name="file3" required/>
											</div>
										</div>
										<div class="form-group">
											<label class="col-lg-3 col-xs-3 col-sm-3 col-md-3 control-label">颜色4名称
											</label>
											<div class="col-sm-6">
			                                    <input id="c_d"  name="c_d" required type="text"  maxlength="12" class="form-control " />
											</div>
											<div class="col-sm-3">
			                                    <input type="file" name="file4" required/>
											</div>
										</div>
										<div class="form-group">
											<label class="col-lg-3 col-xs-3 col-sm-3 col-md-3 control-label">颜色5名称
											</label>
											<div class="col-sm-6">
			                                    <input id="c_e"  name="c_e" required type="text"  maxlength="12" class="form-control " />
											</div>
											<div class="col-sm-3">
			                                    <input type="file" name="file5" required/>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>	
					</div>	
		

 	<script src="/Apollo/madmin/js/jquery-1.10.2.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-ui.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-validate/jquery.validate.min.js"></script>
    <script src="/Apollo/madmin/vendors/jquery-validate/message_zh.js"></script>
    <script type="text/javascript">
    $.ajax({
	       type: "GET",
	       url: "getAllList.action",
	       success: function (data) {
	           if (data.result=="success") {
	               $.each(data.data, function (n, value) {
	            	   $('#roleType').append("<option value='" + value.type+"-"+value.name+ "'>" + value.name + "</option>");
	               });
	            } 
	        }
	   });
    
    $("#saveRole").click(function () {
    	if(!$("#form").valid()) {
      		 return false;
      	}
    	$("#form").submit();	
    });
    $("#return").click(function () {
    	history.back(-1);
    });
    </script>
</body>
</html>