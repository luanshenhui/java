<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ＭＣＨ連携用ファイル作成  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'オブジェクト
Dim objHainsMchCooperation		'ＭＣＨ連携用ファイル作成用

'パラメータ
Dim lngRsvNo			'予約番号（今回分）
Dim Ret					'復帰値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lngRsvNo			= Request("rsvno")

Do
	Ret = -1

	If lngRsvNo <> "" Then
		'オブジェクトのインスタンス作成
		Set objHainsMchCooperation	= Server.CreateObject("HainsMchCooperation.MchCooperation")

		'ＭＣＨ連携用ファイル作成
		Ret = objHainsMchCooperation.EditCSVDatMonshin( lngRsvNo )

		'オブジェクトのインスタンス削除
		Set objHainsMchCooperation = Nothing
	End If

Exit Do
Loop
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ＭＣＨ連携用ファイル作成</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">■ＭＣＨ連携用ファイル作成</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>
	<BR>
<%
	If Ret > 0 Then
		'正常終了
		Call EditMessage("ＭＣＨ連携用ファイルが作成されました。", MESSAGETYPE_NORMAL)
	Else
		'エラーメッセージを編集
		Call EditMessage("ＭＣＨ連携用ファイルの作成に失敗しました。", MESSAGETYPE_WARNING)
	End If
%>
	<BR>
	<BR>
	<BR>
<TABLE BORDER="0" WIDTH="90%">
	<TR>
		<TD WIDTH="100%" ALIGN="right"><A HREF="JavaScript:close();"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る" BORDER="0"></A></TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
