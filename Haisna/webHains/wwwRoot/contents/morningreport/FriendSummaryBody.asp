<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会（同伴者（お連れ様）受診者情報）  (Ver0.0.1)
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

'同伴者（お連れ様）受診者情報
Dim vntRsvNo			'予約番号
Dim vntDayId			'当日ＩＤ
Dim vntPerId			'個人ＩＤ
Dim vntLastName			'姓
Dim vntFirstName		'名
Dim vntCompFlag			'同伴者フラグ
Dim vntCompRsvNo		'予約番号（同伴者またはお連れ様）
Dim vntCompDayId		'当日ＩＤ（同伴者またはお連れ様）
Dim vntCompPerId		'個人ＩＤ（同伴者またはお連れ様）
Dim vntCompLastName		'姓（同伴者またはお連れ様）
Dim vntCompFirstName	'名（同伴者またはお連れ様）

Dim lngCount			'レコード件数
Dim strBgColor			'背景色
Dim i,j					'インデックス
Dim strRsvNo			'前行の予約番号

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

	'同伴者（お連れ様）受診者情報を取得
	lngCount = objMorningReport.SelectFriendsDaily(	lngCslYear, lngCslMonth, lngCslDay, _
													strCsCd, _
													blnNeedUnReceipt, _
													vntRsvNo, _
													vntDayId, _
													vntPerId, _
													vntLastName, _
													vntFirstName, _
													vntCompFlag, _
													vntCompRsvNo, _
													vntCompDayId, _
													vntCompPerId, _
													vntCompLastName, _
													vntCompFirstName _
													)
	If lngCount < 0 Then
		Err.Raise 1000, , "同伴者（お連れ様）受診者情報が取得できません。（受診日=" & dtmCslDate & ",コースコード=" & strCsCd & ",当日ＩＤ未発番=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>同伴者（お連れ様）受診者情報</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE  BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
strRsvNo = ""
For i = 0 To lngCount-1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#e0ffff"""
	End If
%>
		<TR HEIGHT="16">
<%
	'同じ受診者の場合は省略
	If strRsvNo <> vntRsvNo(i) Then
		strRsvNo = vntRsvNo(i)
%>
			<TD NOWRAP<%= strBgColor %> WIDTH="70"><%= IIf(vntDayID(i)<>"", objCommon.FormatString(vntDayID(i), "0000"), "&nbsp;") %></TD>
			<TD NOWRAP<%= strBgColor %> WIDTH="135"><%= vntLastName(i) %>　<%= vntFirstName(i) %></TD>
<%
	Else
%>
			<TD NOWRAP<%= strBgColor %> WIDTH="70">&nbsp;</TD>
			<TD NOWRAP<%= strBgColor %> WIDTH="135">&nbsp;</TD>
<%
	End If
%>
			<TD NOWRAP<%= strBgColor %> ALIGN="center" WIDTH="40"><%= IIf(vntCompFlag(i)="1", "☆", "&nbsp;") %></td>
			<TD NOWRAP<%= strBgColor %> WIDTH="100"><%= IIf(vntCompDayID(i)<>"", objCommon.FormatString(vntCompDayID(i), "0000"), "&nbsp;") %></td>
			<TD NOWRAP<%= strBgColor %> WIDTH="135"><%= vntCompLastName(i) %>　<%= vntCompFirstName(i) %></TD>
		</TR>
<%
Next
%>
	</TABLE>
</BODY>
</HTML>
