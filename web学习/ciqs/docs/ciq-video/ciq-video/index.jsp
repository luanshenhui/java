<%@ page language="java" pageEncoding="utf-8"%>
<html>
  <head>
    <title>查看视频</title>
</head>

<body>
		<%
			String fileMonth = request.getParameter("fileMonth"); 
			String fileDate = request.getParameter("fileDate"); 
			String fileName = request.getParameter("fileName"); 
		%>
		 
		<!-- 
		<div id="video" style="position:relative;z-index: 100;width:600px;height:400px;float: left;"><div id="a1"></div></div>
		
		<script type="text/javascript" src="<%=request.getContextPath()%>/ckplayer/ckplayer.js" charset="utf-8"></script>
		<script type="text/javascript">
			var fileName = 'http://10.10.40.12:7001/ciq-video/showVideo?filePath=<%=fileMonth+","+fileDate+","+fileName%>';
			var flashvars={
				f:fileName,
				c:0,
				b:1
				};
			var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always'};
			CKobject.embedSWF('ckplayer/ckplayer.swf','a1','ckplayer_a1','640','480',flashvars,params);
			/*
			CKobject.embedSWF(播放器路径,容器id,播放器id/name,播放器宽,播放器高,flashvars的值,其它定义也可省略);
			下面三行是调用html5播放器用到的
			*/
		
		  </script>
		 -->
		
		
		<!--酷播迷你 CuPlayerMiniV3.0 代码开始-->

		<script type="text/javascript" src="<%=request.getContextPath()%>/cuplayer/Images/swfobject.js"></script>
		<div id="CuPlayer" > <strong>提示：您的Flash Player版本过低！</strong> </div>
		<script type=text/javascript>
		var so = new SWFObject("cuplayer/CuPlayerMiniV3_Black_S.swf","CuPlayer","600","400","9","#000000");
		so.addParam("allowfullscreen","true");
		so.addParam("allowscriptaccess","always");
		so.addParam("wmode","opaque");
		so.addParam("quality","high");
		so.addParam("salign","lt");
		so.addVariable("CuPlayerFile","http://10.10.40.12:7001/ciq-video/showVideo?filePath=201408,20140819,22.3gp");
		so.addVariable("CuPlayerImage","Images/flashChangfa2.jpg");
		so.addVariable("CuPlayerLogo","Images/logo.png");
		so.addVariable("CuPlayerShowImage","true");
		so.addVariable("CuPlayerWidth","600");
		so.addVariable("CuPlayerHeight","400");
		so.addVariable("CuPlayerAutoPlay","false");
		so.addVariable("CuPlayerAutoRepeat","false");
		so.addVariable("CuPlayerShowControl","true");
		so.addVariable("CuPlayerAutoHideControl","false");
		so.addVariable("CuPlayerAutoHideTime","6");
		so.addVariable("CuPlayerVolume","80");
		so.addVariable("CuPlayerGetNext","false");
		so.write("CuPlayer");
		</script>
		<!--酷播迷你 CuPlayerMiniV3.0 代码结束-->
		
  		<!--
  		<OBJECT ID="video2" CLASSID="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA" HEIGHT="480" WIDTH="640">
		<param name="_ExtentX" value="9313">
		<param name="_ExtentY" value="7620">
		<param name="AUTOSTART" value="0">
		<param name="SHUFFLE" value="0">
		<param name="PREFETCH" value="0">
		<param name="NOLABELS" value="0">
		<param name="CONTROLS" value="ImageWindow">
		<param name="CONSOLE" value="Clip1">
		<param name="LOOP" value="0">
		<param name="NUMLOOP" value="0">
		<param name="CENTER" value="0">
		<param name="MAINTAINASPECT" value="0">
		<param name="defaultFrame" value="0">
		<param name="BACKGROUNDCOLOR" value="#000000">
			<embed SRC="<%=request.getContextPath()%>/showVideo?filePath=<%=fileMonth+","+fileDate+","+fileName%>" type="application/x-mplayer2" HEIGHT="480" WIDTH="640" AUTOSTART="true">
			</embed>
		</OBJECT>
		-->
  </body>
</html>