<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%'-----------------------------------------------------------------
'		Programmed by e-Corp
'		Date : 2003.11.30
'		ﾆﾄﾀﾏｸ・: Hagaki.asp 
'-------------------------------------------------------------------%>

<!-- #include virtual = "/webHains/includes/checkSession.inc" -->

<%
    'セッション・権限チェック
    Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)    

	Dim l_rsvNo 
	Dim l_clsDateFrom
	Dim l_clsDateTo 
	Dim l_orgCD
	Dim l_csCD 
	Dim l_perID
	Dim l_act
	Dim l_addrdiv
	Dim l_engdiv

	Dim strWhere
	Dim strUrl

	l_rsvNo = Request("p_rsvNo")
	l_clsDateFrom = Request("p_clsDateFrom")
	l_clsDateTo = Request("p_clsDateTo")
	l_orgCD = Request("p_orgCD")
	l_csCD = Request("p_csCD")
	l_perID = Request("p_perID")
	l_act = Request("p_act")
	l_addrdiv = Request("p_addrdiv")
	l_engdiv = Request("p_engdiv")
	
	
	if l_act = "save" then
		
		if l_rsvNo = "" then
			msg "保存の時rsvNoは必須項目です。"
		end if

		l_clsDateFrom = ""
		l_clsDateTo = ""
		l_orgCD = ""
		l_csCD = ""
		l_perID = ""
		strWhere = "/rop "
		l_addrdiv = ""
		
	
	elseif l_act = "print" then

		if l_addrdiv = "house" then
			l_addrdiv = "1"
		end if

		if l_addrdiv = "company" then
			l_addrdiv = "2"
		end if

		if l_addrdiv = "etc" then
			l_addrdiv = "3"
		end if
		
		l_clsDateFrom = ""
		l_clsDateTo = ""
		l_orgCD = ""
		l_csCD = ""
		l_perID = ""
		l_act = ""
		strWhere = ""

	elseif l_act = "print_param" then

		l_rsvNo = ""
		strWhere = ""
		l_addrdiv = ""
		l_act = ""		
	
	end if
	
	
	if l_engdiv = "eng" then
		strUrl = "02_prtReservePostcard_eng.mrd"
	elseif l_engdiv = "jap" then
		strUrl = "02_prtReservePostcard_jpn.mrd"
    else
        strUrl = "02_prtReservePostcard_tot.mrd"  
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
      Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= strUrl %>", "/rp [<%= l_rsvNo %>] [<%= l_clsDateFrom %>] [<%= l_clsDateTo %>] [<%= l_orgCD %>]  [<%= l_csCD %>] [<%= l_perID %>] [<%= l_act %>] [<%= l_addrdiv %>] <%= strWhere %> /rpdrv [RICOH IPSiO NX720N RPCS-127] /rpsrc [3] /rpaper [43]");

	   //self.close();
	  //window.close();
   }

//-->
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">


</BODY>
</HTML>
