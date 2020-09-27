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
	         <div class="portlet box portlet-blue" style="margin-bottom: 15px;">
	          <div class="portlet-header"></div>
	            <div class="row">
							<div class="form-group">
								<label for="txtUserName" class="col-lg-1 col-xs-1 col-sm-1 col-md-1 control-label">
									<input type="radio" name="color" value="c_a">颜色1
								</label>
								<div class="col-lg-2 col-xs-2 col-sm-2 col-md-2">
                                   <img src="/image/c_a.jpg" alt="" class="img-responsive" style="width: 150px;height: 150px;">
                                  <label>${c_a}</label> 
								</div>
								<label for="txtUserPassword" class="col-lg-1 col-xs-1 col-sm-1 col-md-1 control-label">
									<input type="radio" name="color" value="c_b">颜色2
								</label>
								<div class="col-lg-2 col-xs-2 col-sm-2 col-md-2">
                                    <img src="/image/c_b.jpg" alt="" class="img-responsive" style="width: 150px;height: 150px;">
                                     <label>${c_b}</label> 
								</div>
								<label for="txtUserAccount" class="col-lg-1 col-xs-1 col-sm-1 col-md-1 control-label">
									<input type="radio" name="color" value="c_c">颜色3
								</label>
								<div class="col-lg-2 col-xs-2 col-sm-2 col-md-2">
                                   <img src="/image/c_c.jpg" alt="" class="img-responsive"  style="width: 150px;height: 150px;">
                                    <label>${c_c}</label> 
								</div>
								<label for="txtUserName" class="col-lg-1 col-xs-1 col-sm-1 col-md-1 control-label">
									<input type="radio" name="color" value="c_d">颜色4
								</label>
								<div class="col-lg-2 col-xs-2 col-sm-2 col-md-2">
                                   <img src="/image/c_d.jpg" alt="" class="img-responsive"  style="width: 150px;height: 150px;">
                                   <label>${c_d}</label> 
								</div>
							</div>
						</div>	
						<div class="portlet-header"></div>
						 <div class="row">
							<div class="form-group">
								<label for="txtUserPassword" class="col-lg-1 col-xs-1 col-sm-1 col-md-1 control-label">
									<input type="radio" name="color" value="c_e">颜色5
								</label>
								<div class="col-lg-2 col-xs-2 col-sm-2 col-md-2">
                                  <img src="/image/c_e.jpg" alt="" class="img-responsive"  style="width: 150px;height: 150px;">
                                  <label>${c_e}</label> 
								</div>
								<div class="col-lg-5"></div>
								<div class="col-lg-4">
                                    <form id="from" action="/login/uploadimge.action" style="float: right;padding-top: 50px;" method="post" enctype="multipart/form-data">
										<div>图片名称</div>
										<input type="text" name="colorName" id="colorName" maxlength="12" style="margin-bottom: 10px;">
										<input type="file" name="file">
										<input type="hidden" name="colorType" id="colorType">
										<input type="button" id="sub" style="color: white;background-color: green;width:70px;margin-top:10px" value="上传"> 
										<input type="reset" id="clear" value="清空"  style="color: white;background-color: blue;width:70px;">
									</form>
								</div>
							</div>
						</div>	
					</div>	
	         </div>
         </div>
		

 	<script src="/Apollo/madmin/js/jquery-1.10.2.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-migrate-1.2.1.min.js"></script>
    <script src="/Apollo/madmin/js/jquery-ui.js"></script>
    <script type="text/javascript">
	    $("#clear").click(function () {
	    	$('input:radio:checked').attr('checked',false);
	    });
	    
	    $("input[type='radio']").click(function () {
	    	var t=$(this).parent().next().find("label").html();
	    	$("#colorType").val($(this).val());	
			$("#colorName").val(t);	  
	    });
	    
		$("#sub").click(function () {
			var v=$('input:radio:checked').val()
			if(v){
				$("#from").submit();	
			}else{
				alert("请选择一个图片");
			}
		});
    </script>
</body>
</html>