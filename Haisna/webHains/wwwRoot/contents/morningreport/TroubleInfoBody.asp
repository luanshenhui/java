<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会（トラブル情報）  (Ver0.0.1)
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
Dim vntSortNo			'表示順（1:個人、2:受診情報）
Dim vntSeq				'seq
Dim vntPubNoteDivCd		'受診情報ノート分類コード
Dim vntPubNoteDivName	'受診情報ノート分類名称
Dim vntDefaultDispKbn	'表示対象区分初期値
Dim vntOnlyDispKbn		'表示対象区分しばり
Dim vntDispKbn			'表示対象区分
Dim vntUpdDate			'登録日時
Dim vntUpdUser			'登録者
Dim vntUserName			'登録者名
Dim vntBoldFlg			'太字区分
Dim vntPubNote			'ノート
Dim vntDispColor		'表示色
Dim vntCslDate			'受診日
Dim vntDayId			'当日ＩＤ
Dim vntCsName           'コース名
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

	'トラブル情報を取得
	lngCount = objMorningReport.SelectPubNoteDaily(	lngCslYear, lngCslMonth, lngCslDay, _
													strCsCd, _
													blnNeedUnReceipt, _
													"100", _
													"0", _
													Session("USERID"), _
													vntRsvNo, _
													vntSortNo, _
													vntSeq, _
													vntPubNoteDivCd, _
													vntPubNoteDivName, _
													vntDefaultDispKbn, _
													vntOnlyDispKbn, _
													vntDispKbn, _
													vntUpdDate, _
													vntUpdUser, _
													vntUserName, _
													vntBoldFlg, _
													vntPubNote, _
													vntDispColor, _
													vntCslDate, _
													vntCsName, _
													vntDayID, _
													vntLastName, _
													vntFirstName _
													)
	If lngCount < 0 Then
		Err.Raise 1000, , "トラブル情報が取得できません。（受診日=" & dtmCslDate & ",コースコード=" & strCsCd & ",当日ＩＤ未発番=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>トラブル情報</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
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
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="80"><%= IIf(vntDayID(i)<>"", objCommon.FormatString(vntDayID(i), "0000"), "&nbsp;") %></TD>
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="150"><%= vntLastName(i) %>　<%= vntFirstName(i) %></TD>
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="360"><%= vntPubNote(i) %></TD>
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="140"><%= vntUpdDate(i)  %></TD>
		</TR>
<%
Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
