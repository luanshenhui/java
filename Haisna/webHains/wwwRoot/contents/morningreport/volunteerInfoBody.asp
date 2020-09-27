<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会（ボランティア情報）  (Ver0.0.1)
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
Dim objConsult			'受診情報アクセス用

'パラメータ
Dim lngCslYear			'受診日(年)
Dim lngCslMonth			'受診日(月)
Dim lngCslDay			'受診日(日)
Dim strCsCd				'コースコード
Dim blnNeedUnReceipt	'未受付者取得フラグ(True:当日ＩＤ未発番状態も取得)

'受診情報
Dim dtmCslDate			'受診日
Dim lngCntlNo			'管理番号
Dim strArrRsvNo			'予約番号の配列
Dim strArrDayId			'当日IDの配列
Dim strArrWebColor		'webカラーの配列
Dim strArrCsName		'コース名の配列
Dim strArrPerId			'個人IDの配列
Dim strArrLastName		'姓の配列
Dim strArrFirstName		'名の配列
Dim vntArrVolunteer		'ボランティアの配列
Dim vntArrVolunteerName	'ボランティア名の配列

Dim lngCount			'レコード件数
Dim lngDispCount		'表示件数
Dim strBgColor			'背景色
Dim strVolunteer		'ボランティア区分
Dim i,j					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon	= Server.CreateObject("HainsCommon.Common")
Set objConsult	= Server.CreateObject("HainsConsult.Consult")

'引数値の取得
lngCslYear		= CLng("0" & Request("cslYear") )
lngCslMonth		= CLng("0" & Request("cslMonth"))
lngCslDay		= CLng("0" & Request("cslDay")  )
strCsCd			= Request("csCd")
blnNeedUnReceipt	= IIf(Request("NeedUnReceipt")="True", True, False)

Do

	'受診日・管理番号の設定
	dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)
	lngCntlNo  = 0

	'検索条件を満たす受診者の一覧を取得する
	lngCount = objConsult.SelectConsultList(dtmCslDate, _
											lngCntlNo, _
											strCsCd, , , , , , , _
											blnNeedUnReceipt, , , , _
											strArrRsvNo, _
											strArrDayId, _
											, _
											strArrCsName, _
											strArrPerId, _
											strArrLastName, _
											strArrFirstName _
											, , , , , , , , , , , , , _
											vntArrVolunteer, _
											vntArrVolunteerName _
											)
	If lngCount < 0 Then
		Err.Raise 1000, , "受診者の一覧が取得できません。（受診日=" & dtmCslDate & ",コースコード=" & strCsCd & ",当日ＩＤ未発番=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>ボランティア情報</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
lngDispCount = 0
For i = 0 To lngCount-1
	If (vntArrVolunteer(i) <> "0" And vntArrVolunteer(i) <> "" ) Or vntArrVolunteerName(i) <> "" Then
		If (lngDispCount Mod 2) = 0 Then
			strBgColor = ""
		Else
			strBgColor = " BGCOLOR=""#e0ffff"""
		End If
		Select Case vntArrVolunteer(i)
		Case "0"
			strVolunteer = "利用なし"
		Case "1"
			strVolunteer = "通訳要"
		Case "2"
			strVolunteer = "介護要"
		Case "3"
			strVolunteer = "通訳＆介護要"
		Case "4"
			strVolunteer = "車椅子要"
		Case Else
			strVolunteer = ""
		End Select
%>
		<TR HEIGHT="17">
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="80"><%= IIf(strArrDayId(i)<>"", objCommon.FormatString(strArrDayId(i), "0000"), "&nbsp;") %></TD>
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="150"><%= strArrLastName(i) %>　<%= strArrFirstName(i) %></TD>
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="150"><%= strVolunteer %></TD>
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="350"><%= vntArrVolunteerName(i) %></TD>
		</TR>
<%
		lngDispCount = lngDispCount + 1
	End If
Next
%>
	</TABLE>
</BODY>
</HTML>
