<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="../size/size_bzhjsp.js"></script>
<form id="sizeform" class="form_template show">
<div style="padding-bottom: 30px;">
	<div style=" font-size: 15px;margin-bottom: 5px;text-align: center;width: 100%;">
		<label id="sizeInfo"></label>
	</div>
	<div id="size" style="clear:both;padding-top: 15px;">
			<div style="float: left;padding-left: 15px;">
				<div id="size_img" style="text-align: center;width:282px; ">
					<img src="../../themes/default/images/10054.jpg"></img>
					<div id="size_img_title" style="padding-top:10px;"></div>
				</div>
				
			</div>
			<div id="size_info_bzh" style="float: left;width:570px;padding-left: 30px;">
				<div id="size_title" style="font-size: 14px;padding-bottom: 15px;"></div>
				<div id="size_category"  style="float:left; "></div>
				<div id="size_unit"  style="float:right;"><span class="sizeUnit"></span><span id="unitContainer"></span></div>
				<div id="size_area" class="horizontal"></div>
				<div id="size_message"></div>
				<div id="size_spec_part" class="horizontal"></div>
				<div id="style_title" class="horizontal" style="float:left;"><span class="styleTitle"></span><span id="styleContainer"></span></div>
				<label id="more_pants"><input type="checkbox" id="morePants" /><p style="display:inline;"><s:text name="more_pants"></s:text></p></label>
			</div>
	</div>
</div>
<div class="operation" style=" margin: 320px auto auto;">
	<a id="btnSaveSize" class="morewidth"/>
</div>
</form>