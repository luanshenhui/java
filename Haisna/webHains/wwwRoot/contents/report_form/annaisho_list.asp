<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%'-----------------------------------------------------------------
'		Programmed by e-Corp
'		Date : 2003.12.12
'		ﾆﾄﾀﾏｸ・: annaisho.asp 
'-------------------------------------------------------------------%>

<%
	
	Dim l_rsvNo 
	Dim l_clsDateFrom
	Dim l_clsDateTo 

	Dim l_orgCD
	Dim l_orgCD1
	Dim l_orgCD2

	Dim l_csCD 
	Dim l_perID
	Dim l_act
	Dim l_addrdiv
	Dim l_engdiv
	Dim l_check_box
	Dim l_act1
	Dim l_act2

	Dim strWhere
	Dim strUrl



	l_rsvNo = Request("p_rsvNo")


	l_clsDateFrom = Request("p_ScslDate")
	l_clsDateTo = Request("p_EcslDate")



	l_clsDateFrom = Mid(l_clsDateFrom, 1, 4) & Mid(l_clsDateFrom, 6, 2) & Mid(l_clsDateFrom, 9, 2)
      	l_clsDateTo = Mid(l_clsDateTo, 1, 4) & Mid(l_clsDateTo, 6, 2) & Mid(l_clsDateTo, 9, 2)



	l_orgCD1 = Request("p_strOrgCd1")
	l_orgCD2 = Request("p_strOrgCd2")


	l_csCD = Request("p_Cscd")
	l_perID = Request("p_perID")
	l_act = Request("p_act")
	l_addrdiv = Request("p_addrdiv")
	l_engdiv = Request("p_engdiv")
	l_check_box = Request("p_check_box")


	
	
	if l_act = "save" then
		
		if l_rsvNo = "" then
			msg "保存の時rsvNoは必須項目です。"
		end if

		l_clsDateFrom = ""
		l_clsDateTo = ""
		l_orgCD = ""
		l_csCD = ""
		l_perID = ""
		l_act1 = "SAVE_BTN"
		l_act2 = ""
		strWhere = "/rop"
		l_addrdiv = ""
		l_check_box = ""
		
	
	elseif l_act = "print" then

		if l_rsvNo = "" then
			msg "保存の時rsvNoは必須項目です。"
		end if

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
		l_act1 = ""
		l_act2 = "PRINT_BTN"
		strWhere = ""
		l_check_box = ""

	elseif l_act = "param_print" then

		l_rsvNo = ""
		strWhere = "/rop"
		l_addrdiv = ""
		l_act = ""
		if l_check_box = "1" then
			l_check_box = "ON"
		end if
		
	elseif l_act = "param_preview" then
		
		l_rsvNo = ""
		strWhere = ""
		l_addrdiv = ""
		l_act = ""
		if l_check_box = "1" then
			l_check_box = "ON"
		end if
	
	end if

	
	
	if l_engdiv = "eng" then
		strUrl = "06_prtinstructionlist.mrd"
	elseif l_engdiv = "jap" then
		strUrl = "06_prtinstructionlist.mrd"
	else
		strUrl = "06_prtinstructionlist.mrd"
	end if
	l_engdiv = ""
	
	strWhere = ""

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">


<OBJECT id=barCode
   classid="clsid:36C69B75-B8F5-4E53-B06D-1DBE860BA88B" 
   codebase="http://157.104.16.194:8090/RDServer/rdbarcode.cab#version=1,0,0,1"
   name=barCode >
</OBJECT>

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
      Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= strUrl %>", "/rp [<%= l_clsDateFrom %>] [<%= l_clsDateTo %>] [<%= l_csCD %>] [<%= l_check_box %>] <%= strWhere %> ");

	  //self.close();
	  //window.close();
   }
   
//-->
</SCRIPT>
</HEAD>


<BODY onLoad="LoadForm();">

</BODY>
</HTML>
