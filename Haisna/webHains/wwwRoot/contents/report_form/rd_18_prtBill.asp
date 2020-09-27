<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%'-----------------------------------------------------------------
'		Programmed by e-Corp
'		Date : 2003.11.30
'		ÆÄÀÏ¸E: prtBill.asp 
'-------------------------------------------------------------------%>

<%
	
	Dim l_ScslDate
	Dim l_BilSeq
	Dim l_BilBan 
	Dim l_Option
	
	Dim strWhere
	Dim strUrl

	l_ScslDate = Request("p_ScslDate")
	l_BilSeq = Request("p_BilSeq")
	l_BilBan = Request("p_BilBan")
	l_Option = Request("p_Option")
	
	l_ScslDate = Mid(l_ScslDate, 1, 4) & Mid(l_ScslDate, 6, 2) & Mid(l_ScslDate, 9, 2)

	
'	l_ScslDate = "20040105"
'	l_BilSeq = "432"
'	l_BilBan = "0"
'	l_Option = "0"

	if l_Option = "0" then
		strUrl = "18_prtBill.mrd"
	else 
		strUrl = "19_prtReceipt.mrd"
	end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
	name=Rdviewer width=100% height=100%>
</OBJECT>


<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
   function LoadForm() {
      
	  Rdviewer.DisplayNoDataMsg(false);
	  Rdviewer.SetBackgroundColor(255, 255, 255);
	  Rdviewer.AutoAdjust = false;
	  Rdviewer.ZoomRatio  = 100;
      Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= strUrl %>", "/rp [<%= l_ScslDate %>] [<%= l_BilSeq %>] [<%= l_BilBan %>]");

	  //self.close();
	  //window.close();
   }

//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">


</BODY>
</HTML>
