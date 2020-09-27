<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%

'---------------------------------------------------------------------
'
'	File Name : rd_04_prtFaxPaper.asp
'
'	Created Date : 2003.12.16
'
'	Modified Date : 2003.12.29
'
'	Copyright (C) e-Corporation Corporation. All rights reserved.
'
'---------------------------------------------------------------------

	Dim l_useID 
	Dim l_clsDateFrom 
	
	l_useID = Request("p_Uid") 
	l_clsDateFrom = Request("p_ScslDate") 
	
	l_clsDateFrom = Mid(l_clsDateFrom, 1, 4) & Mid(l_clsDateFrom, 6, 2) & Mid(l_clsDateFrom, 9, 2)
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT 
	id=Rdviewer
	classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398"
	name=Rdviewer width=100% height=100%>
</OBJECT>

<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
	function LoadForm() 
	{
		Rdviewer.DisplayNoDataMsg(false); 
		Rdviewer.SetBackgroundColor(255, 255, 255); 
		Rdviewer.AutoAdjust = false; 
		Rdviewer.ZoomRatio = 100; 
		Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/04_prtFaxPaper.mrd", "/rp [<%= l_useID %>] [<%= l_clsDateFrom %>]"); 
	}
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">
</BODY>
</HTML>