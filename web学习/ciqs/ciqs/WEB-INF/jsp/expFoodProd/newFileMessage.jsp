<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>食品备案</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript">
	function fileSubmit(){
		if(!$("#file_name").val()){
			return alert("请输入文件名称");
		}
			$("#uploadForm").attr("action","/ciqs/expFoodProd/uploadFile");
			$("#uploadForm").submit();
		}
		
		jQuery(document).ready(function(){
			$(".user-info").css("color","white");
		});
</script>

</head>
<body>
<%@ include file="/common/headMenu2.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">上传附件</a>
		</div>
		<div class="search">
			<div class="main" style="background-image:none">
				<form action="" method="post" enctype="multipart/form-data" id="uploadForm">
					<table>
						<tr>
							<th style="width:200px;font-size: 15px">输入附件名称:</th>
							<td><input style="height: 22px;margin-left: 36px;"type="text" name="file_name" id="file_name"/></td>
						</tr>
						<tr>	
							<th style="width:200px;font-size: 15px;"><div style="margin-top: 15px;">选择文件:</div></th>
							<td style="height:52px;">
							<input id="file" type="file" name="file" style="margin-left: 43px;margin-top: 15px;margin-bottom: 10px"/>
							</td>
						</tr>
						<tr>
							<th align="right"></th>		
							<td>
			    			<button id="upload" style="margin-top:-25px;margin-left: 550px;" onclick="fileSubmit()">上传</button>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
