<%@LANGUAGE = VBSCRIPT%>
<%
'-------------------------------------------------------------------------------
'	内視鏡チェックリスト (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-218
'       修正日  ：2010.05.28
'       担当者  ：ASC)宍戸
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit%>
<%
'#### 2010.06.28 SL-UI-Y0101-218 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'#### 2010.06.28 SL-UI-Y0101-218 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
    '#### 2007/09/06 張 内視鏡チェックシート新規作成により新規作成(CoReport ⇒ ReportDesigner) ####
    '####               内視鏡受付で受診者確認（フェリカー）の後、内視鏡チェックシート自動印刷   ####



    Dim l_Uid                   'ログインユーザーID
    Dim l_DayId                 '当日ID
    Dim l_ScslDate              '受診日
'#### 2010.06.28 SL-UI-Y0101-218 ADD START ####'
	Dim vntMessage		'通知メッセージ
    Dim l_Printmode             '0:直接印刷  1:プレビュー印刷
	Dim l_IPAddress
'#### 2010.06.28 SL-UI-Y0101-218 ADD END ####'
    
    l_Uid       = Request("p_Uid")
    l_DayId     = Request("p_DayId")
    l_ScslDate  = Request("p_ScslDate")
    l_Printmode = "0"
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '実行端末のIPアドレスを取得

'#### 2010.06.28 SL-UI-Y0101-218 ADD START ####'
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
	Call putPrivacyInfoLogWithUserID("PH051", "(受付から)内視鏡チェックリストの印刷を行った", l_Uid)

	'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		Set objPrintCls = Server.CreateObject("HainsprtEndoscopeCheck2.prtEndoscpChk2")
	'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
		Ret = objPrintCls.PrintOut(l_Uid, _
                                   l_ScslDate, _
                                   l_DayId, _
                                   l_Printmode, _
                                   l_IPAddress)

	Print = Ret
End Function
'#### 2010.06.28 SL-UI-Y0101-218 ADD END ####'
%>
<!--
'#### 2010.06.28 SL-UI-Y0101-218 DEL START ####'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<OBJECT
    id=Rdviewer
    classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
    codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398" 
    name=Rdviewer 
    width="100%" height="100%">
</OBJECT>


<HEAD>
</HEAD>
<BODY>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
'#### 2010.06.28 SL-UI-Y0101-218 DEL END ####'
//-->
<!--
   sub window_onload()
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/30_prtEndoscopeCheckList.mrd", "/rop /rwait /rp [<%= l_DayId %>] [<%= l_ScslDate %>]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
<!--
'#### 2010.06.28 SL-UI-Y0101-218 DEL START ####'
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>印刷中です．．．</b></td>
    </tr>
</table>

</BODY>
</HTML>
'#### 2010.06.28 SL-UI-Y0101-218 DEL END ####'
//-->

<!-- '#### 2010.06.28 SL-UI-Y0101-218 ADD START ####' -->
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
<!-- '#### 2010.06.28 SL-UI-Y0101-218 ADD END ####' -->
