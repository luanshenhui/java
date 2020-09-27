<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">

<title>RCMTM</title>
<script type="text/javascript" src="../../scripts/jsp.js"></script>
<script type="text/javascript" src="../size/sizejsp.js"></script>
<script type="text/javascript" src="js/iscroll.js"></script>
<script type="text/javascript" src="croll.js"></script>
<script type="text/javascript" src="ipad.js"></script>
<script type="text/javascript">
var myScroll;
function loaded(){
	myScroll = new iScroll('wrapper', {
	snap: 'li',
	momentum: false,
	hScrollbar: false,
	vScrollbar: false,
	onBeforeScrollStart: function (e) {
		var target = e.target;
		while (target.nodeType != 1) target = target.parentNode;
		if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA')
			e.preventDefault();
	},
	onScrollEnd: function () {
    document.querySelector('#indicator > li.active').className = '';
    document.querySelector('#indicator > li:nth-child(' + (this.currPageX+1) + ')').className = 'active';
    }});
};
document.addEventListener('DOMContentLoaded', loaded, false);
</script>

<style type="text/css" media="all">
body,ul,li {
	padding:10px;
	margin:0;
}
#wrapper {
	width:98%;
	height:620px;
	margin-left:15px;

	float:left;
	position:relative;	/* On older OS versions "position" and "z-index" must be defined, */
	z-index:1;			/* it seems that recent webkit is less picky and works anyway. */
	overflow:hidden;

	background:#aaa;
	-webkit-border-radius:10px;
	-moz-border-radius:10px;
	-o-border-radius:10px;
	border-radius:10px;
	background:#e3e3e3;
}

#scroller {
	width:700%;
	height:100%;
	float:left;
	padding:0;
}

#scroller ul {
	list-style:none;
	display:block;
	float:left;
	width:100%;
	height:100%;
	padding:0;
	margin:0;
	text-align:left;
}

#scroller li {
	-webkit-box-sizing:border-box;
	-moz-box-sizing:border-box;
	-o-box-sizing:border-box;
	box-sizing:border-box;
	float:left;
	width:14.2%; height:100%;
	font-size:14px;
	font-weight:bold;
	color:black;
	line-height:140%;
}

#nav {
	width:100%;
}

#prev, #next {
	float:left;
	font-weight:bold;
	font-size:14px;
	padding:5px 0;
	width:80px;
}

#next {
	float:right;
	text-align:right;
}

#indicator, #indicator > li {
	display:block; float:left;
	list-style:none;
	padding:0; margin:0;
}

#indicator {
	width:110px;
	padding:12px 0 0 30px;
}

#indicator > li {
	text-indent:-9999em;
	width:8px; height:8px;
	-webkit-border-radius:4px;
	-moz-border-radius:4px;
	-o-border-radius:4px;
	border-radius:4px;
	background:#ddd;
	overflow:hidden;
}

#indicator > li.active {
	background:#888;
}
#container_size2 li{
	width:140px;
	display:block; float:left;
	list-style:none;
	padding:0; margin:0;
	margin-bottom: 4px;
}, 
#indicator > li:last-child {
	margin:0;
}
#container_components{
    border: 1px solid #626061;
    clear: both;
    height:500px;
    margin-bottom: 8px;
    min-height: 348px;
    padding: 5px 10px 25px;
    width: 550px;
    overflow: scroll;
}

</style>
</head>
<body>
<!-- 遮罩层--正在提交... -->
<style type="text/css">
    #bg{position: absolute;  top: 0%;  left: 0%;  width: 100%;  height: 100%;  background-color: black;  z-index:1001;  -moz-opacity: 0.7;  opacity:.70;  filter: alpha(opacity=70);}
    #show{position: absolute;  top: 25%;  left: 32%;  width: 30%;  height: 5%;  padding: 8px;  border: 8px solid #E8E9F7;  background-color: white;  z-index:1002;  overflow: auto;font-weight: bold;color: black;text-align: center;}
</style>
<div id="shade" style="display: none;"><div id="bg"></div><div id="show"><s:text name="lblSubmit"></s:text></div></div>
<!-- 遮罩层 -->										
<input type="hidden" id="addText" value="<s:text name="btnCreateFabric"></s:text>"/>
<input type="hidden" id="pleaseSelect" value="<s:text name="lblPleaseSelect"></s:text>"/>
<form id="form" class="form_template">	
<div id="wrapper">
	<div id="scroller" >
		<ul id="thelist">
			<li>
				<table class="">
					<tr>
						<td>
							<div><s:text name="lblClothingInfo"></s:text></div>
							<div id="container_clothings" class="label" style="height: 100px;"></div>
							<div><s:text name="lblCustomer"></s:text></div>
							<div id="container_customer" class="label"></div>
							<div><s:text name="lblFabricInfo"></s:text></div> 
							<div class="label">
							<table>
								<tr>
									<td class="label" style="width:80px;" ><div><s:text name="lblFabric"></s:text></div></td>
									<td>
										<input type="text" id="fabricCode" name="fabricCode" style="width:150px;" class="textbox"/><span></span>
										<div id="fabric_result"></div>
										<div id="autoContainer"></div>
									</td>
								</tr>
							</table>
							</div>
						</td>
						<td class="padding_left20">
							<div><s:text name="lblDetail"></s:text></div>
							<div id="container_components" class="label">
								<article id="contentWrapper"></article>
							</div>
						</td>
					</tr>
				</table>
			</li>
			<li>
				<div><s:text name="lblEmbroid"></s:text></div>
				<div id="container_embroid"></div><br>
				<input type="radio" name="size_category" value="10052" checked="checked" style="display:none;">
				<div ><span id="lblSizeInfo"><s:text name="lblSizeInfo"></s:text></span><span class="lb">&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="lbd"></span><span class="lbl" id='size_message'></span></div>
				<div id="container_size2"></div>
			</li>
			<li>
				<div><s:text name="lblBodyType"></s:text></div>
				<div id="container_size_pad">
					<input type="text" id ="3PCS" style="display: none;"/>
					<table id="size" style="clear:both;">
						<tr>
							<td id="size_info">
								<div id="size_category"  style="float:left; "></div>
								<div id="size_unit"  style="float:right;"><span class="sizeUnit"></span><span id="unitContainer"></span></div>
								<div id="size_area" class="horizontal"></div>
								<div id="size_message"></div>
								<div id="size_bodytype" class="horizontal"></div>
								<div id="style_title" class="horizontal" style="float:left;"><span id="styleContainer"></span></div>
								<label id="more_pants" style="width:100%"><input type="checkbox" id="morePants" onclick="$.csSize.changeAmount();"/><p style="display:inline;"><s:text name="more_pants"></s:text></p></label>
								<label id="more_shirt" style="color: #F54343;display: none;">
									<s:text name="more_shirt"></s:text>&nbsp;&nbsp;
									<input id="shirtAmount" type="text" value="1" style="width:30px;" onkeypress="if((event.which <48||event.which> 57) && event.which!=46 && event.which!=8){return false;} "/>
								</label>
							</td>
						</tr>
					</table>
				</div>
			</li>
			<li>
				<div class="operation">
					<a id="btnSaveOrden" ><s:text name="btnSaveOrden"></s:text></a>
	    			<a id="btnSubmitOrden"><s:text name="btnSubmitOrden"></s:text></a> 
				</div>
			</li>
		</ul>
	</div>
</div>
<div id="nav" align="center">
	<div id="prev" onclick="myScroll.scrollToPage('prev', 0);">&larr;<a href="#">上一步</a></div>
	<ul id="indicator">
		<li class="active">1</li>
		<li>2</li>
		<li>3</li>
		<li>4</li>
	</ul>
	<div id="next" onclick="myScroll.scrollToPage('next', 0);"><a href="#">下一步</a>&rarr;</div>
</div>
</form>
</body>
</html>