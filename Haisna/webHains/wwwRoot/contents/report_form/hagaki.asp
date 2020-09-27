<%@LANGUAGE = VBSCRIPT%>

<%Option Explicit%>

<%'-----------------------------------------------------------------
'		Programmed by e-Corp
'		Date : 2003.11.30
'		ﾆﾄﾀﾏｸ・: Hagaki.asp 
'-------------------------------------------------------------------%>
<%'     管理番号：SL-UI-Y0101-238
'       修正日  ：2010.06.10
'       担当者  ：ASC)齋藤
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------%>
<%'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-238
'       修正日  ：2011.01.05
'       担当者  ：ASC)清野
'       修正内容：プリンター振分機能追加
'-------------------------------------------------------------------------------%>


<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'#### 2010.06.10 SL-UI-Y0101-238 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc"                 -->
<%
'#### 2010.06.10 SL-UI-Y0101-238 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
    'セッション・権限チェック
    Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)    

'#### 2011.01.05 SL-UI-Y0101-238 ADD START ####'
	Dim l_IPAddress
'#### 2011.01.05 SL-UI-Y0101-238 ADD END ####'
'#### 2010.06.10 SL-UI-Y0101-238 ADD START ####'
	Dim vntMessage		'通知メッセージ
	Dim UID
'#### 2010.06.10 SL-UI-Y0101-238 ADD END ####'
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
	
'#### 2011.01.05 SL-UI-Y0101-238 ADD START ####'
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '実行端末のIPアドレスを取得
'#### 2011.01.05 SL-UI-Y0101-238 ADD END ####'

	
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
	
	
'#### 2010.06.10 SL-UI-Y0101-238 MOD START ####'
'	if l_engdiv = "eng" then
'		strUrl = "02_prtReservePostcard_eng.mrd"
'	elseif l_engdiv = "jap" then
'		strUrl = "02_prtReservePostcard_jpn.mrd"
'   else
'       strUrl = "02_prtReservePostcard_tot.mrd"  
'	end if	

	if l_act = "save" then
		l_act = "0"
    else
        l_act = "1" 
	end if	

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
			Call putPrivacyInfoLog("PH038", "受診情報詳細画面 はがきの印刷を行った")

			Set objPrintCls = Server.CreateObject("HainsprtReservePcardj.prtReservePcard_j")
			'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'#### 2011.01.05 SL-UI-Y0101-238 MOD START ####'
'##			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "0") '直接印刷
'##			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "1") 'プレビュー
			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "0", l_IPAddress) '直接印刷
			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "1", l_IPAddress) 'プレビュー
'#### 2011.01.05 SL-UI-Y0101-238 MOD END ####'
		Case "eng"

			'情報漏えい対策用ログ書き出し
			Call putPrivacyInfoLog("PH040", "受診情報詳細画面 はがき（英語）の印刷を行った")

			Set objPrintCls = Server.CreateObject("HainsprtReservePcarde.prtReservePcard_e")
			'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'#### 2011.01.05 SL-UI-Y0101-238 MOD START ####'
'##			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "0") '直接印刷
'##			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "1") 'プレビュー
			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "0", l_IPAddress) '直接印刷
			Ret = objPrintCls.PrintOut(UID, l_rsvNo, l_act, "1", l_IPAddress) 'プレビュー
'#### 2011.01.05 SL-UI-Y0101-238 MOD END ####'
		Case Else
	End Select
	Print = Ret
End Function
'#### 2010.06.10 SL-UI-Y0101-238 MOD END ####'
%>

<!--
'#### 2010.06.10 SL-UI-Y0101-238 DEL START ####'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
	name=Rdviewer width=100% height=100%>
</OBJECT>


<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
'#### 2010.06.10 SL-UI-Y0101-238 DEL END ####'
-->
<!--
   function LoadForm() {
      
	  Rdviewer.DisplayNoDataMsg(false);
	  Rdviewer.SetBackgroundColor(255, 255, 255);
	  Rdviewer.AutoAdjust = false;
	  Rdviewer.ZoomRatio  = 100;
      Rdviewer.FileOpen("http://157.104.16.194:8090/RDServer/form/<%= strUrl %>", "/rp [<%= l_rsvNo %>] [<%= l_clsDateFrom %>] [<%= l_clsDateTo %>] [<%= l_orgCD %>]  [<%= l_csCD %>] [<%= l_perID %>] [<%= l_act %>] [<%= l_addrdiv %>] <%= strWhere %>  /rpdrv [RICOH IPSiO NX720N RPCS-127] /rpsrc [3] /rpapersize [43]");

	   //self.close();
	  //window.close();
   }

//-->
<!--
'#### 2010.06.10 SL-UI-Y0101-238 DEL START ####'
</SCRIPT>
</HEAD>

<BODY onLoad="LoadForm();">


</BODY>
</HTML>
'#### 2010.06.10 SL-UI-Y0101-238 DEL END ####'
-->
