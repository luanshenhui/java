<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>行政执法全过程监管平台</title>
<link href="static/login/style.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body,td,th {
	font-family: "Microsoft YaHei", "helvetica neue", tahoma, arial, "hiragino sans gb", Simsun, sans-serif;
}
body {
	background-image: url(static/login/images/nav1-bg.png);
	background-repeat: repeat-x;
	background-color: #e6e6e6;
}

.nav-link{
	color:#393939;
	font-size:18px;
	font-weight: bold;
}
.nav-link:hover{
	color:#393939;
	font-size:18px;
	font-weight: bold;
}
</style>
<script type="text/javascript">
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
</head>


<body onload="MM_preloadImages('static/login/images/qgczf1-2.png','static/login/images/zjbq1-2.png','static/login/images/lcyj1-2.png','static/login/images/tjfx1-2.png')">

<div style="background-image:url(static/login/images/nav1-bg-sysname.png); width:100%; height:425px; background-repeat:no-repeat; background-position:center top; margin-left:auto; margin-right:auto;">
</div >
	<c:forEach items="${login_visits }" var ="row">
		<a href="${ctx }${row.visitPath }">${row.visitName}</a><br />
	</c:forEach>
	<a id="login_a" href="/ciqs/login/logout">退出</a>
</body>
</html>