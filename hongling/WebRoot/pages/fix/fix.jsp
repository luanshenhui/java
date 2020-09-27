<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" src="../../scripts/import.js"></script>
<!-- <script type="text/javascript" src="fixjsp.js"></script> -->
</head>

<body style="background: url('spongebob/bj.jpg');">
<div align=center>
<!-- 	<div>
		<input type=button class="buttons" value=prev onclick="clipmeR();">
		<input type=button class="buttons" value=next onclick="clipmeL();">
		Speed: <input id=speedButton style="width:30px;" value="15" onchange="pSpeed=parseInt(this.value);">
		 <select id="flipSelect" style="display:none;"></select>
		<br><br>
	</div> -->
	<div id="bookflip" style="background: url('spongebob/book.png');"></div>
</div>
	<div id="pages" style="width:1px;height:1px;overflow:hidden;"></div>
 <div style="text-align:center;margin-top: 10px;">
	<a href="../fix/select.jsp">
		<img src="spongebob/enter.png"></img>
	</a>
</div>
<script type="text/javascript">
var htmlImage="";
var member = $.csCore.getCurrentMember();
//if(member.businessUnit == 20138 || member.businessUnit == 20144 || member.businessUnit == 20140){//凯妙、瑞璞
if(member.logo == 20138){//凯妙
htmlImage="<div name='Home' style='background: url(spongebob/first.jpg);'></div>"+
					"<div name='Home' style='background: url(spongebob/page0.jpg);'></div>"+
					"<div style='border:1px solid #000000;background:url(spongebob/page1.jpg);'></div>"+
					"<div style='background:url(spongebob/page2.jpg);'></div>"+
					"<div style='background:url(spongebob/page3.jpg);'></div>"+
					"<div style='background:url(spongebob/page4.jpg);'></div>"+
					"<div style='background:url(spongebob/page5.jpg);'></div>"+
					"<div style='background:url(spongebob/page6.jpg);'></div>"+
					"<div style='background:url(spongebob/page7.jpg);'></div>"+
					"<div style='background:url(spongebob/page8.jpg);'></div>"+
					"<div style='background:url(spongebob/page9.jpg);'></div>"+
					"<div style='background:url(spongebob/page10.jpg);'></div>"+
					"<div style='background:url(spongebob/page11.jpg);'></div>"+
					"<div style='background:url(spongebob/page12.jpg);'></div>"+
					"<div style='background:url(spongebob/page13.jpg);'></div>"+
					"<div style='background:url(spongebob/page14.jpg);'></div>"+
					"<div style='background:url(spongebob/page15.jpg);'></div>"+
					"<div style='background:url(spongebob/page16.jpg);'></div>"+
					"<div style='background:url(spongebob/page17.jpg);'></div>"+
					"<div style='background:url(spongebob/page18.jpg);'></div>"+
					"<div style='background:url(spongebob/page19.jpg);'></div>"+
					"<div style='background:url(spongebob/page20.jpg);'></div>"+
					"<div style='background:url(spongebob/page21.jpg);'></div>"+
					"<div style='background:url(spongebob/page22.jpg);'></div>"+
					"<div style='background:url(spongebob/page23.jpg);'></div>"+
					"<div style='background:url(spongebob/page24.jpg);'></div>"+
					"<div style='background:url(spongebob/page25.jpg);'></div>"+
					"<div style='background:url(spongebob/page26.jpg);'></div>"+
					"<div style='background:url(spongebob/page27.jpg);'></div>"+
					"<div style='background:url(spongebob/page28.jpg);'></div>"+
					"<div style='background:url(spongebob/page29.jpg);'></div>"+
					"<div style='background:url(spongebob/page30.jpg);'></div>"+
					"<div style='background:url(spongebob/page31.jpg);'></div>"+
					"<div style='background:url(spongebob/page32.jpg);'></div>"+
					"<div style='background:url(spongebob/page33.jpg);'></div>"+
					"<div style='background:url(spongebob/page34.jpg);'></div>"+
					"<div style='background:url(spongebob/page35.jpg);'></div>"+
					"<div style='background:url(spongebob/page36.jpg);'></div>"+
					"<div style='background:url(spongebob/page37.jpg);'></div>"+
					"<div style='background:url(spongebob/page38.jpg);'></div>";
}else{//红领
	htmlImage="<div name='Home' style='background: url(spongebob/hlImage/first.jpg);'></div>"+
					"<div name='Home' style='background: url(spongebob/hlImage/page0.jpg);'></div>"+
					"<div style='border:1px solid #000000;background:url(spongebob/hlImage/page1.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page2.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page3.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page4.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page5.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page6.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page7.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page8.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page9.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page10.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page11.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page12.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page13.jpg);'></div>"+
					"<div style='background:url(spongebob/hlImage/page14.jpg);'></div>";
}
$("#pages").html(htmlImage);
</script>
<script type="text/javascript" src="bookflip.js"></script>
<script type="text/javascript">

pWidth=400; //翻页的宽度
pHeight=600; //翻页的高度

numPixels=20;  //size of block in pixels to move each pass
pSpeed=15; //翻页的速度，值越大越慢

startingPage="0";//select page to start from, for last page use "e", eg. startingPage="e"
allowAutoflipFromUrl = true; //true allows querystring in url eg bookflip.html?autoflip=5

pageBackgroundColor="#CCCCCC";//页面背景颜色
pageFontColor="#ffffff";//页面字体颜色

pageBorderWidth="1";//边框宽度
pageBorderColor="#3D4D5D";
pageBorderStyle="solid";  //页面边框状态 ：dotted, dashed, solid, double, groove, ridge, inset, outset, dotted solid double dashed, dotted solid

pageShadowLeftImgUrl ="spongebob/black_gradient.png";//翻页中间阴影
pageShadowWidth = 80; //阴影宽度
pageShadowOpacity = 60; //阴影透明度
pageShadow=1; //是否加阴影0=shadow off, 1= shadow on left page

allowPageClick=true; //是否点击页面直接翻页
allowNavigation=true; //是否显示下拉列表，点击页数，直接翻页
pageNumberPrefix="page "; //显示在下拉列表中的文字 “page 1”

ini();
</script>	
</body> 
</html>
