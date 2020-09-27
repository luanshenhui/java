<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%-- <script language= "javascript" src="<%=request.getContextPath() %>/pages/size/sizejsp.js"></script> --%>
<input type="text" id ="3PCS" style="display: none;"/>
<table id="size" style="clear:both;">
	<tr>
		<td id="size_info">
			<div id="size_category"  style="float:left; "></div>
			<div id="size_unit"  style="float:right;"><span class="sizeUnit"></span><span id="unitContainer"></span></div>
			<div id="size_area" class="horizontal"></div>
			<div id="size_message"></div>
			<div id="size_spec_part" class="horizontal"></div>
			<div id="size_bodytype" class="horizontal"></div>
			<div id="style_title" class="horizontal" style="float:left;"><span id="styleContainer"></span></div>
			<label id="more_pants"><input type="checkbox" id="morePants" onclick="$.csSize.changeAmount();"/><p style="display:inline;"><s:text name="more_pants"></s:text></p></label>
			<label id="more_shirt" style="clear:both;display:block;font-weight:bold;width:100px;color:#f54343;">
				<s:text name="more_shirt"></s:text>&nbsp;&nbsp;
				<input id="shirtAmount" type="text" value="1" style="width:30px;" onkeypress="if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return false;} "/>
			</label>
		</td>
		<td><div id="size_video"></div></td>
		<td><div id="size_video_ipad"></div></td>
	</tr>
</table>