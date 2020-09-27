<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%'-----------------------------------------------------------------
'		Programmed by e-Corp
'		Date : 2003.12.12
'		ÆÄÀÏ¸E: rd_10_prtReserveList.asp 
'-------------------------------------------------------------------%>

<%

	Dim l_ScslDate
	Dim l_EcslDate 
	Dim l_Uid 

	l_ScslDate = Request("p_ScslDate")
	l_EcslDate = Request("p_EcslDate")
	l_ScslDate = Mid(l_ScslDate, 1, 4) & Mid(l_ScslDate, 6, 2) & Mid(l_ScslDate, 9, 2)
	l_EcslDate = Mid(l_EcslDate, 1, 4) & Mid(l_EcslDate, 6, 2) & Mid(l_EcslDate, 9, 2)
	l_Uid = Request("p_Uid")

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
          Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/10_prtReserveList.mrd", "/rp [<%=l_ScslDate %>] [<%=l_EcslDate %>]");
	   //self.close();
	  //window.close();
   }

//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">


</BODY>
</HTML>