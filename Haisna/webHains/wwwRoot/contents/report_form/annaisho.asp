<%@LANGUAGE = VBSCRIPT%>
<%
'-------------------------------------------------------------------------------
'	案内書 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-204
'       修正日  ：2010.06.15
'       担当者  ：ASC)宍戸
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-204
'       修正日  ：2011.01.05
'       担当者  ：ASC)清野
'       修正内容：プリンター振分機能追加
'-------------------------------------------------------------------------------

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'#### 2010.06.15 SL-UI-Y0101-204 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc"        -->
<%
'#### 2010.06.15 SL-UI-Y0101-204 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
    'セッション・権限チェック
    Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP) 

'#### 2011.01.05 SL-UI-Y0101-204 ADD START ####'
	Dim l_IPAddress
'#### 2011.01.05 SL-UI-Y0101-204 ADD END ####'
'#### 2010.06.15 SL-UI-Y0101-204 ADD START ####'
	Dim vntMessage		'通知メッセージ
	Dim UID
'#### 2010.06.15 SL-UI-Y0101-204 ADD END ####'
	Dim l_rsvNo
	Dim l_clsDateFrom
	Dim l_clsDateTo
	Dim l_orgCD
	Dim l_csCD 
	Dim l_perID
	Dim l_act
	Dim l_addrdiv
	Dim l_engdiv
	Dim l_check_box
	Dim l_act1
	Dim l_act2
	Dim l_act3
	Dim l_Object 
	Dim l_prinmode 

	Dim strWhere
	Dim strUrl

	l_rsvNo = Request("p_rsvNo")
	l_csCD = Request("p_Cscd")
	l_check_box = Request("p_Object")

	l_clsDateFrom = Request("p_ScslDate")
	l_clsDateTo = Request("p_EcslDate")

	l_clsDateFrom = Mid(l_clsDateFrom, 1, 4) & Mid(l_clsDateFrom, 6, 2) & Mid(l_clsDateFrom, 9, 2)
	l_clsDateTo = Mid(l_clsDateTo, 1, 4) & Mid(l_clsDateTo, 6, 2) & Mid(l_clsDateTo, 9, 2)

	l_orgCD = Request("p_orgCD")
	l_perID = Request("p_perID")
	l_act = Request("p_act")
	l_Object = Request("p_Object")
	l_prinmode = Request("p_prinmode")
	l_addrdiv = Request("p_addrdiv")
	l_engdiv = Request("p_engdiv")
	
	l_act1 = ""
	l_act2 = ""
	l_act3 = ""
'#### 2011.01.05 SL-UI-Y0101-204 ADD START ####'
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '実行端末のIPアドレスを取得
'#### 2011.01.05 SL-UI-Y0101-204 ADD END ####'


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
		l_act3 = "RREVIEW"
		strWhere = ""
		l_check_box = ""

	elseif l_prinmode = "0" then
		
		l_rsvNo = ""
		l_addrdiv = ""
		l_act = ""
		if l_Object = "1" then
			l_check_box = "ON"
                else
                        l_check_box = ""
		end if
		
	elseif l_prinmode = "1" then
		
		l_rsvNo = ""
		strWhere = ""
		l_addrdiv = ""
		l_act = ""
        l_act3 = "PREVIEW"
		
		if l_Object = "1" then
			l_check_box = "ON"
                else
                        l_check_box = ""
		end if
        else	        
		if l_check_box = "1" then
			l_check_box = "ON"
                else
                        l_check_box = ""
		end if
	end if

'#### 2010.06.15 SL-UI-Y0101-204 MOD START ####'
'	if l_engdiv = "eng" then
'		strUrl = "05_prtInvitation_eng.mrd" 
'	elseif l_engdiv = "jap" then
'		strUrl = "05_prtInvitation_jpn.mrd" 
'	else
'		strUrl = "05_prtInvitation_tot.mrd" 
'	end if
'        l_engdiv = ""

'帳票出力処理制御
vntMessage = PrintControl(0)	'モード("0":はがき、"1":一式書式)

Sub GetQueryString()
    UID = Session("USERID")
End Sub

Function CheckValue()
End Function

Function Print()
	Dim objCommon	'共通クラス

	Dim objPrintCls	'団体一覧出力用COMコンポーネント
	Dim Ret			'関数戻り値

	If Not IsArray(CheckValue()) Then
		Set objCommon = Server.CreateObject("HainsCommon.Common")
	End If

	'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
	'英文出力の有無ごとの呼び先定義
	Select Case l_engdiv
		Case "jap"

			'情報漏えい対策用ログ書き出し
			Call putPrivacyInfoLog("PH039", "受診情報詳細画面 案内書の印刷を行った")

			Set objPrintCls =  Server.CreateObject("HainsprtInvitation_jpn.prtInvitation_j")
			'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'#### 2011.01.05 SL-UI-Y0101-204 MOD START ####'
'##			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act1, l_act2, l_addrdiv, l_engdiv)
			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act1, l_act2, l_addrdiv, l_engdiv, l_IPAddress)
'#### 2011.01.05 SL-UI-Y0101-204 MOD END ####'
		Case "eng"

			'情報漏えい対策用ログ書き出し
			Call putPrivacyInfoLog("PH041", "受診情報詳細画面 案内書（英語）の印刷を行った")

			Set objPrintCls = Server.CreateObject("HainsprtInvitation_eng.prtInvitation_e")
			'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'#### 2011.01.05 SL-UI-Y0101-204 MOD START ####'
'##			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act1, l_act2, l_addrdiv, l_engdiv)
			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act1, l_act2, l_addrdiv, l_engdiv, l_IPAddress)
'#### 2011.01.05 SL-UI-Y0101-204 MOD END ####'

		Case Else
	End Select
	Print = Ret
End Function
'#### 2010.06.15 SL-UI-Y0101-204 MOD END ####'

%>
<!--
'#### 2010.06.15 SL-UI-Y0101-204 DEL START ####'
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
'#### 2010.06.15 SL-UI-Y0101-204 DEL END ####'
//-->
<!--
   function LoadForm() {
      
	  Rdviewer.DisplayNoDataMsg(false);
	  Rdviewer.SetBackgroundColor(255, 255, 255);
	  Rdviewer.AutoAdjust = false;
	  Rdviewer.ZoomRatio  = 100;
      Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= strUrl %>", "/rp [<%= l_rsvNo %>] [<%= l_act1 %>] [<%= l_act2 %>] [<%= l_addrdiv %>] [<%= l_engdiv %>] [<%= l_clsDateFrom %>] [<%= l_clsDateTo %>] [<%= l_csCD %>] [<%= l_check_box %>] [<%= l_act3 %>] [000050] [NAKAMURA001] [1] [temp] <%= strWhere %> /rpdrv [RICOH IPSiO NX720N RPCS-127] /rpsrc [1] /rpdup [2]");
 //    Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= strUrl %>", "/rp [<%= l_rsvNo %>] [<%= l_act1 %>] [<%= l_act2 %>] [<%= l_addrdiv %>] [<%= l_engdiv %>] [<%= l_clsDateFrom %>] [<%= l_clsDateTo %>] [<%= l_csCD %>] [<%= l_check_box %>] [<%= l_act3 %>] [000050] [NAKAMURA001] [1] [temp] /rpdrv [RICOH IPSiO NX720N RPCS-128] /rpsrc [1] /rpdup [2]");

	  //self.close();
	  //window.close();
   }
   
//-->
<!--
'#### 2010.06.15 SL-UI-Y0101-204 DEL START ####'
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">

p_check_box : <%= l_check_box %><br>

</BODY>
</HTML>
'#### 2010.06.15 SL-UI-Y0101-204 DEL END ####'
-->
