<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会（同姓受診者情報）  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objMorningReport	'朝レポート情報アクセス用

'パラメータ
Dim lngCslYear			'受診日(年)
Dim lngCslMonth			'受診日(月)
Dim lngCslDay			'受診日(日)
Dim strCsCd				'コースコード
Dim blnNeedUnReceipt	'未受付者取得フラグ(True:当日ＩＤ未発番状態も取得)

'同姓受診者情報
Dim vntPerId			'個人ＩＤ
Dim vntDayId			'当日ＩＤ
Dim vntLastName			'姓
Dim vntFirstName		'名

Dim lngCount			'レコード件数
Dim strBgColor			'背景色
Dim i,j					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon			= Server.CreateObject("HainsCommon.Common")
Set objMorningReport	= Server.CreateObject("HainsMorningReport.MorningReport")

'引数値の取得
lngCslYear		= CLng("0" & Request("cslYear") )
lngCslMonth		= CLng("0" & Request("cslMonth"))
lngCslDay		= CLng("0" & Request("cslDay")  )
strCsCd			= Request("csCd")
blnNeedUnReceipt	= IIf(Request("NeedUnReceipt")="True", True, False)

Do

	'同姓受診者情報を取得
	lngCount = objMorningReport.SelectSameNameDaily(	lngCslYear, lngCslMonth, lngCslDay, _
														strCsCd, _
														blnNeedUnReceipt, _
														vntPerId, _
														vntDayId, _
														vntLastName, _
														vntFirstName _
														)
	If lngCount < 0 Then
		Err.Raise 1000, , "同姓受診者情報が取得できません。（受診日=" & dtmCslDate & ",コースコード=" & strCsCd & ",当日ＩＤ未発番=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>同姓受診者情報</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
For i = 0 To lngCount-1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#e0ffff"""
	End If
%>
		<TR HEIGHT="17">
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="70"><%= IIf(vntDayID(i)<>"", objCommon.FormatString(vntDayID(i), "0000"), "&nbsp;") %></TD>
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="135"><%= vntLastName(i) %>　<%= vntFirstName(i) %></TD>
		</TR>
<%
Next
%>
	</TABLE>
</BODY>
</HTML>
