<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%
'---------------------------------
'	Programmed by ECO)‹à—Yr
'	Date : 2003.12.15
'	File : prtSchedule.asp
'---------------------------------
%>

<%
	Dim l_cslDate
	Dim l_PerID 
	Dim l_rsvNo 
	Dim l_dayID 

	l_cslDate = Request("p_cslDate")
	l_PerID = Request("p_PerID")
	l_rsvNo = Request("p_rsvNo")
	l_dayID = Request("p_dayID")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
	id=Rdviewer
	classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398"
	name=Rdviewer 
	width=100% height=100%>
</OBJECT>


<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
	function LoadForm() 
	{
		Rdviewer.DisplayNoDataMsg(false);
		Rdviewer.SetBackgroundColor(255, 255, 255);
		Rdviewer.AutoAdjust = false;
		Rdviewer.ZoomRatio  = 100;
		Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/32_prtMealCoupon.mrd", "/rp [<%= l_PerID %>] [<%= l_rsvNo %>] [<%= l_cslDate %>] ");
	}
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">
</BODY>
</HTML>