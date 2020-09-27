<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%

'---------------------------------------------------------------------
'
'	File Name : rd_22_prtPayment.asp 
'
'	Created Date : 2003.12.16 
'
'	Modified Date : 2003.12.28 
'
'	Copyright (C) e-Corporation Corporation. All rights reserved. 
' 
'---------------------------------------------------------------------

	Dim l_useID 
	Dim l_PayDate
	Dim l_Option1
	Dim l_Option2 
	Dim l_strUrl

	l_useID = Request("p_Uid")
	l_PayDate = Request("p_PayDate") 
	l_Option1 = Request("p_Option1") 
	l_Option2 = Request("p_Option2") 

	IF l_Option1 = "0" THEN
		l_Option1 = "%"
	END IF

	IF l_Option2 = "0" THEN
		l_strUrl = "20_PaymentJa.mrd"
	ELSE
		l_strUrl = "22_PaymentDai.mrd"
	END IF
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
		Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= l_strUrl %>", "/rp [<%= l_PayDate %>] [<%= l_Option1 %>]");
	}
//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">
</BODY>
</HTML>