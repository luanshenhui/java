<%@LANGUAGE = VBSCRIPT%>

<%
'-------------------------------------------------------------------------------
'	面接案内・お食事引換券 (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-236
'       修正日  ：2010.05.28
'       担当者  ：ASC)宍戸
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit%>
<%
'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
%>
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'---------------------------------
'	Programmed by ECO)金雄俊
'	Date : 2003.12.15
'	File : prtSchedule.asp
'---------------------------------
%>

<%
	Dim l_cslDate
	Dim l_PerID
	Dim l_rsvNo
	Dim l_dayID
'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
	Dim l_useID
	Dim l_IPAddress
	Dim vntMessage		'通知メッセージ
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'

	l_cslDate = Request("p_cslDate")
	l_PerID = Request("p_PerID")
	l_rsvNo = Request("p_rsvNo")
	l_dayID = Request("p_dayID")
'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
	l_useID = Request("p_Uid")
	l_IPAddress = Request.ServerVariables("REMOTE_ADDR")  '実行端末のIPアドレスを取得
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'

'#### 2010.06.28 SL-UI-Y0101-236 ADD START ####'
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
	Call putPrivacyInfoLogWithUserID("PH052", "お食事券の印刷を行った", l_useID)

	'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
	Set objPrintCls = Server.CreateObject("HainsprtMealCoupon.prtMealCoupon")

	'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
	Ret = objPrintCls.PrintOut(l_useID, _
							   l_PerID, _
							   l_rsvNo, _
						       l_cslDate, _
							   l_IPAddress)

	Print = Ret
End Function
'#### 2010.06.28 SL-UI-Y0101-236 ADD END ####'

%>

<!--
'#### 2010.06.28 SL-UI-Y0101-236 DEL START ####'
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">

<HEAD>
</HEAD>

<BODY>

<OBJECT
	id=Rdviewer
	classid="clsid:309A42C6-4114-11D4-AF7B-30A024C32DBA" 
	codebase="http://157.104.16.194:8090/RDServer/rdviewer30.cab#version=3,0,0,398"
	name=Rdviewer 
	width=0% height=0%>
</OBJECT>

<SCRIPT ID=clientEventHandlersVBS TYPE="text/vbscript" LANGUAGE=vbscript>
'#### 2010.06.28 SL-UI-Y0101-236 DEL END ####'
//-->
<!--
   sub window_onload()
      'Rdviewer.IsShowDlg = false
      Rdviewer.FileOpen "http://157.104.16.194:8090/RDServer/form/32_prtMealCoupon.mrd", "/rop /rwait /rp [<%= l_PerID %>] [<%= l_rsvNo %>] [<%= l_cslDate %>] /rpdrv [受付(ミシン目）]"
   end sub
   
   sub Rdviewer_FileOpenFinished()
      window.close()
   end sub
-->
<!--
'#### 2010.06.28 SL-UI-Y0101-236 DEL START ####'
</SCRIPT>

<table height='100%' width='100%'>
    <tr align='center' valign='center'>
        <td align='right'><img src='../../images/zzz.gif'></td><td align='left'><b>印刷中です．．．</b></td>
    </tr>
</table>

</BODY>
</HTML>
'#### 2010.06.28 SL-UI-Y0101-236 DEL END ####'
//-->

<!-- '#### 2010.06.28 SL-UI-Y0101-236 ADD START ####' -->
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
<!-- '#### 2010.06.28 SL-UI-Y0101-236 ADD END ####' -->
