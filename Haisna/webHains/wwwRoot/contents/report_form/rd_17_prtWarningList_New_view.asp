<%@LANGUAGE = VBSCRIPT%>

<%
'-------------------------------------------------------------------------------
'	個人異常値リスト (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-219
'       修正日  ：2010.06.28
'       担当者  ：ASC)宍戸
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit%>
<%
'#### 2010.06.28 SL-UI-Y0101-219 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'#### 2010.06.28 SL-UI-Y0101-219 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'---------------------------------------------------------------------
'
'	File Name : rd_17_prtWarningList.asp
'
'	Created Date : 2003.12.16
'
'	Modified Date : 2003.12.29
'
'	Copyright (C) e-Corporation Corporation. All rights reserved.
' 
'---------------------------------------------------------------------

	Dim l_ScslDate
	Dim l_EcslDate
	Dim l_perID
	Dim l_useID
	Dim l_dayID
'#### 2010.06.28 SL-UI-Y0101-219 ADD START ####'
	Dim vntMessage		'通知メッセージ
    Dim l_Printmode     '0:直接印刷  1:プレビュー印刷
	Dim l_IPAddress
'#### 2010.06.28 SL-UI-Y0101-219 ADD END ####'

	l_ScslDate = Request("p_ScslDate")
	l_EcslDate = Request("p_EcslDate")
	l_useID = Request("p_Uid")
	l_dayID = Request("p_dayID")
    l_Printmode = "0"
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '実行端末のIPアドレスを取得

	l_ScslDate = Mid(l_ScslDate, 1, 4) & Mid(l_ScslDate, 6, 2) & Mid(l_ScslDate, 9, 2)
	l_EcslDate = Mid(l_EcslDate, 1, 4) & Mid(l_EcslDate, 6, 2) & Mid(l_EcslDate, 9, 2)

'#### 2010.06.28 SL-UI-Y0101-219 ADD START ####'
'帳票出力処理制御
vntMessage = PrintControl(0)	'モード("0":はがき、"1":一式書式)

Sub GetQueryString()
End Sub

Function CheckValue()
End Function

Function Print()
	Dim objPrintCls	'団体一覧出力用COMコンポーネント
	Dim Ret			'関数戻り値

	'情報漏えい対策用ログ書き出し
	Call putPrivacyInfoLogWithUserID("PH049", "異常値リストの印刷を行った", l_useID)

	'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
	Set objPrintCls = Server.CreateObject("HainsprtWarningList_New.prtWarnList_New")
	'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
	Ret = objPrintCls.PrintOut(l_useID, l_ScslDate, l_EcslDate, l_dayID, l_Printmode, l_IPAddress)

	Print = Ret
End Function
'#### 2010.06.28 SL-UI-Y0101-219 ADD END ####'

%>
<!--
'#### 2010.06.28 SL-UI-Y0101-219 DEL START ####'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
	id=Rdviewer
	classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
	name=Rdviewer 
	width=0% height=0%>
</OBJECT>


<HEAD>
</HEAD>

<BODY>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
'#### 2010.06.28 SL-UI-Y0101-219 DEL END ####'
//-->
<!--
   sub window_onload()
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/17_prtWarningList-kojin.mrd", "/rop /rwait /rp [<%= l_ScslDate %>] [<%= l_EcslDate %>] [<%= l_dayID %>]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
<!--
'#### 2010.06.28 SL-UI-Y0101-219 DEL START ####'
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>印刷中です．．．</b></td>
    </tr>
</table>

</BODY>
</HTML>
'#### 2010.06.28 SL-UI-Y0101-219 DEL END ####'
//-->

<!-- '#### 2010.06.28 SL-UI-Y0101-219 ADD START ####' -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<HEAD>
<SCRIPT TYPE="text/javascript" Language='JavaScript'>
<!--
    function LoadForm() 
    {
      window.opener = window.self.name;
      window.close();
    }
-->
</SCRIPT>
</HEAD>
<BODY onLoad="LoadForm();">

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>印刷中です．．．</b></td>
    </tr>
</table>

</BODY>
</HTML>
<!-- '#### 2010.06.28 SL-UI-Y0101-219 ADD END ####' -->
