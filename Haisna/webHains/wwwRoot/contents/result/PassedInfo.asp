<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		結果入力(端末通過情報) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<!-- #include virtual = "/webHains/includes/editGrpList.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const DISPMODE_DELETE  = "delete"	'表示モード(端末通過情報削除)
Const ACTMODE_DELETE   = "delete"	'動作モード(端末通過情報削除)

'データベースアクセス用オブジェクト
Dim objWorkStation		'端末通過情報アクセス用

'前画面から送信されるパラメータ値
Dim strDispMode			'表示モード
Dim strActMode			'動作モード
Dim strKeyDayId			'当日ID
Dim dtmCslDate			'受診日
Dim strIPAddress		'IPAddress
Dim strMessage			'処理完了後のメッセージ
Dim lngRet				'オブジェクトの戻り値
Dim blnAutoClose		'ウインドウ自動クローズ制御

Dim dtmPassedDate		'通過日時

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objWorkStation        = Server.CreateObject("HainsWorkStation.WorkStation")

'前画面から送信されるパラメータ値の取得
strDispMode    = Request("mode")
strActMode     = Request("actmode")
dtmCslDate     = Request("cslDate")
strKeyDayId    = Request("dayId")
strIPAddress   = Request.ServerVariables("REMOTE_ADDR")
blnAutoClose   = False
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>端末通過情報</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF" MARGINHEIGHT="0" ONLOAD="javascript:CloseMySelf();">

<FORM NAME="PassedInfoForm" action="#">
<INPUT TYPE="hidden" NAME="dayId"       VALUE="<%= strKeyDayId    %>">
<INPUT TYPE="hidden" NAME="receiptDate" VALUE="<%= dtmCslDate     %>">

<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">端末通過情報</FONT></B></TD>
	</TR>
</TABLE>
<%
Do
	'削除実行モードの場合
	If strActMode = ACTMODE_DELETE Then
		If objWorkStation.DeletePassedInfo(dtmCslDate, 0, cLng(strKeyDayId), strIPAddress) = True Then
			strMessage = "通過情報を削除しました"
			blnAutoClose = True
		Else
			strMessage = "通過情報の削除に失敗しました。"
		End If
		Exit Do
	End If

	'削除表示モードの場合
	If strDispMode = DISPMODE_DELETE Then
		strMessage = "端末通過情報を削除しますか？"
		Exit Do
	End If

	'受診日が設定されていない場合
	If dtmCslDate = "" Then
		strMessage = "受診日がセットされていません。"
		Exit Do
	End If

	'当日IDが設定されていない場合
	If strKeyDayId = "" Then
		strMessage = "当日IDが発番されていません。<BR>受付処理を行ってからこの処理を行ってください。"
		Exit Do
	End If

	'端末通過情報の更新
	lngRet = INSERT_ERROR
	lngRet = objWorkStation.UpdatePassedInfo(dtmCslDate, 0, cLng(strKeyDayId), strIPAddress)

	Select Case lngRet
		Case INSERT_NORMAL
			strMessage = "端末通過情報を更新しました。"
			blnAutoClose = True
		Case INSERT_NOPARENT
			strMessage = "指定された受診者は受付されていません。"
		Case INSERT_ERROR
			strMessage = "エラーが発生しました"
	End Select

	Exit Do

Loop

// 削除モード以外でかつ自動クローズ時は通過日時を取得する
If strActMode <> ACTMODE_DELETE And blnAutoClose = True Then
	objWorkStation.SelectPassedInfo dtmCslDate, 0, CInt(strKeyDayId), strIPAddress, , dtmPassedDate
End If
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 正常に更新された場合のみ3秒後にウインドウを閉じます
function CloseMySelf() {
<%
If blnAutoClose = True Then
%>
	if ( opener != null ) {
		opener.updatePassedInfo('<%= dtmPassedDate %>');
	}

	setInterval('window.close()', 3000);
<%
End If
%>
	return false;
}
//-->
</SCRIPT>
<BR>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
	<TR>
		<TD ROWSPAN="5" WIDTH="30"><IMG SRC="/webHains/images/spacer.gif" WIDTH="30"></TD>
		<TD NOWRAP><B><FONT COLOR=<%= IIf(blnAutoClose  = False, "RED", "000000" ) %>><%= strMessage %></FONT></B></TD>
	</TR>
	<TR>
		<TD HEIGHT="15"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD NOWRAP>
<%= IIf(blnAutoClose  = True, "（このページは３秒後に自動的に閉じます）", "" ) %>
<%
	If strDispMode  = DISPMODE_DELETE Then
%>
		<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") & "?actmode=" & ACTMODE_DELETE & "&csldate=" & dtmCslDate & "&dayId=" & strKeyDayId%>"><IMG SRC="/webHains/images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="通過情報を削除する"></A>
<%
	End If
%>

</TD>
	</TR>
	<TR>
		<TD HEIGHT="30"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ALIGN="RIGHT">
<%
	If blnAutoClose  = False Then
%>
		<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
<% 
	End IF
%>
		</TD>
	</TR>
</TABLE>
</BODY>
