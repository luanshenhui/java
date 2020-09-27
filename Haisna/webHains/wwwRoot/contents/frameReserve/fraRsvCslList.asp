<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約枠検索(予約完了) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用
Dim objPerson		'個人情報アクセス用

'引数値
Dim dtmCslDate		'受診日
Dim lngStrRsvNo		'開始予約番号
Dim lngEndRsvNo		'終了予約番号
Dim strMode			'処理モード
Dim strPerId		'個人ＩＤ
Dim strCompPerId	'同伴者個人ＩＤ

'受診情報
Dim strRsvNo		'予約番号
Dim strWebColor		'webカラー
Dim strCsName		'コース名
Dim strArrPerId		'個人ＩＤ
Dim strLastName		'姓
Dim strFirstName	'名
Dim strOrgSName		'団体略称
Dim strOptName		'オプション名
Dim strRsvGrpName	'予約群名称
Dim strArrCompPerId	'同伴者個人ＩＤ
Dim strHasFriends	'お連れ様情報の有無
Dim lngCount		'レコード数

Dim strSameGrp1		'面接同時受診１
Dim strSameGrp2		'面接同時受診２
Dim strSameGrp3		'面接同時受診３
Dim strName			'姓名
Dim strMessage		'メッセージ
Dim strURL			'URL文字列
Dim blnComp			'同伴者フラグ
Dim blnHasFriends	'お連れ様フラグ
Dim Ret				'関数戻り値
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
dtmCslDate   = CDate(Request("cslDate"))
lngStrRsvNo  = CLng(Request("strRsvNo"))
lngEndRsvNo  = CLng(Request("endRsvNo"))
strMode      = Request("mode")
strPerId     = Request("perId")
strCompPerId = Request("compPerId")

Select Case strMode

	Case "delete"	'削除時

		Set objConsult = Server.CreateObject("HainsConsult.Consult")

		'受診情報を削除
'## 2004.01.03 Mod By T.Takagi@FSIT ログ対応
'		objConsult.TruncateConsult lngStrRsvNo, lngEndRsvNo
		objConsult.TruncateConsult lngStrRsvNo, lngEndRsvNo, Session("USERID")
'## 2004.01.03 Mod End

		Set objConsult = Nothing

		'正常時は完了通知画面へ
		Response.Redirect "fraRsvDeleted.asp"
		Response.End

	Case "comp"	'同伴者登録時

		Set objPerson = Server.CreateObject("HainsPerson.Person")

		'同伴者個人ＩＤ更新
		Ret = objPerson.UpdateCompPerId(strPerId, strCompPerId)

		Set objPerson = Nothing

		'戻り値ごとの処理分岐
		Select Case Ret

			Case 0	'個人情報が存在しない(万一発生した場合、受診情報すら存在しないことになる)

				strMessage = "同伴者情報の更新でエラーが発生しました。"

			Case -1	'すでに別の同伴者が登録されていた場合

				strMessage = "すでに他の同伴者個人ＩＤにて更新されています。"

			Case Else	'正常時

'### 2004.02.17 Added by Ishihara@FSIT 同伴者登録時は問答無用でお連れ様登録

				Do
					Set objConsult = Server.CreateObject("HainsConsult.Consult")
		
					'指定予約番号範囲の受診者一覧(予約番号)を取得
					lngCount = objConsult.SelectConsultListForFraRsv(lngStrRsvNo, lngEndRsvNo, strRsvNo)
					If lngCount <= 0 Then
						strMessage = "受診情報が存在しません。"
						Exit Do
					End If
		
					strSameGrp1 = Array()
					strSameGrp2 = Array()
					strSameGrp3 = Array()
					ReDim Preserve strSameGrp1(lngCount - 1)
					ReDim Preserve strSameGrp2(lngCount - 1)
					ReDim Preserve strSameGrp3(lngCount - 1)
					For i = 0 To UBound(strSameGrp1)
						strSameGrp1(i) = "1"
						strSameGrp2(i) = ""
						strSameGrp3(i) = ""
					Next
		
					'お連れ様登録
					objConsult.UpdateFriends dtmCslDate, 0, strRsvNo, strSameGrp1, strSameGrp2, strSameGrp3, strMessage
					If Not IsEmpty(strMessage) Then
						strMessage = "すでにお連れ様が登録されています。"
						Exit Do
					End If
		
					Set objConsult = Nothing
					Exit Do
				Loop
'### 2004.02.17 Added End

				'自身をリダイレクト
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?cslDate="  & dtmCslDate
				strURL = strURL & "&strRsvNo=" & lngStrRsvNo
				strURL = strURL & "&endRsvNo=" & lngEndRsvNo
				strURL = strURL & "&mode="     & "compEnd"
				Response.Redirect strURL
				Response.End

		End Select

	Case "friends"	'お連れ様登録時

		Do

			Set objConsult = Server.CreateObject("HainsConsult.Consult")

			'指定予約番号範囲の受診者一覧(予約番号)を取得
			lngCount = objConsult.SelectConsultListForFraRsv(lngStrRsvNo, lngEndRsvNo, strRsvNo)
			If lngCount <= 0 Then
				strMessage = "受診情報が存在しません。"
				Exit Do
			End If

			strSameGrp1 = Array()
			strSameGrp2 = Array()
			strSameGrp3 = Array()
			ReDim Preserve strSameGrp1(lngCount - 1)
			ReDim Preserve strSameGrp2(lngCount - 1)
			ReDim Preserve strSameGrp3(lngCount - 1)
			For i = 0 To UBound(strSameGrp1)
				strSameGrp1(i) = ""
				strSameGrp2(i) = ""
				strSameGrp3(i) = ""
			Next

			'お連れ様登録
			objConsult.UpdateFriends dtmCslDate, 0, strRsvNo, strSameGrp1, strSameGrp2, strSameGrp3, strMessage
			If Not IsEmpty(strMessage) Then
				strMessage = "すでにお連れ様が登録されています。"
				Exit Do
			End If

			Set objConsult = Nothing

			'自身をリダイレクト
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?cslDate="  & dtmCslDate
			strURL = strURL & "&strRsvNo=" & lngStrRsvNo
			strURL = strURL & "&endRsvNo=" & lngEndRsvNo
			strURL = strURL & "&mode="     & "friendsEnd"
			Response.Redirect strURL
			Response.End

			Exit Do
		Loop

		Set objConsult = Nothing

End Select
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>予約完了</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var url = '<%= Request.ServerVariables("SCRIPT_NAME") %>?cslDate=<%= dtmCslDate %>&strRsvNo=<%= lngStrRsvNo %>&endRsvNo=<%= lngEndRsvNo %>';

// 同伴者登録
function updateCompPerId( perId, compPerId ) {

	if ( !confirm('この２人を同伴者として登録しますか？') ) return;

	document.location.href = url + '&mode=comp&perId=' + perId + '&compPerId=' + compPerId;

}

// お連れ様登録
function registFriends() {

	if ( !confirm('これらの受診情報をお連れ様として登録しますか？') ) return;

	document.location.href = url + '&mode=friends';

}

// 削除処理
function deleteConsult() {

	if ( !confirm('この受診情報を削除しますか？') ) return;

	document.location.href = url + '&mode=delete';

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">予約完了</FONT></B></TD>
	</TR>
</TABLE>
<%
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'指定予約番号範囲の受診者一覧を取得
lngCount = objConsult.SelectConsultListForFraRsv(lngStrRsvNo, lngEndRsvNo, strRsvNo, , strWebColor, strCsName, strArrPerId, strLastName, strFirstName, , , , , , , , strOrgSName, strOptName, strRsvGrpName, strArrCompPerId, strHasFriends)

Set objConsult = Nothing
%>
<BR>「<B><FONT COLOR="#ffa500"><%= Year(dtmCslDate) %>年<%= Month(dtmCslDate) %>月<%= Day(dtmCslDate) %>日</FONT></B>」 に <B><FONT COLOR="#ffa500"><%= lngCount %></FONT></B>名の予約をしました。<BR>
<%
'メッセージの編集
Select Case strMode
	Case "compEnd"
		Call EditMessage("同伴者として登録されました。", MESSAGETYPE_NORMAL)
	Case "friendsEnd"
		Call EditMessage("お連れ様として登録されました。", MESSAGETYPE_NORMAL)
	Case Else
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
End Select
%>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR BGCOLOR="#dcdcdc">
		<TD NOWRAP WIDTH="120">受診コース</TD>
		<TD NOWRAP WIDTH="120">個人名称</TD>
		<TD NOWRAP WIDTH="150">団体名</TD>
		<TD NOWRAP WIDTH="200">検査オプション</TD>
		<TD NOWRAP>時間枠</TD>
	</TR>
<%
	'受診者一覧の編集
	For i = 0 To lngCount - 1

		strName = Trim(strLastName(i) & "　" & strFirstName(i))
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "e0ffff") %>">
			<TD NOWRAP><FONT COLOR="<%= strWebColor(i) %>">■</FONT><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= strRsvNo(i) %>" TARGET="_blank"><%= strCsName(i) %></A></TD>
<% '## 2003.12.12 Mod By T.Takagi@FSIT ここから個人へはとばさない %>
<!--
			<TD NOWRAP><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= strArrPerId(i) %>" TARGET="_blank"><%= strName %></A></TD>
-->
			<TD NOWRAP><%= strName %></TD>
<% '## 2003.12.12 Mod End %>
			<TD NOWRAP><%= strOrgSName(i) %></TD>
			<TD NOWRAP><%= Replace(strOptName(i), ",", "、") %></TD>
			<TD NOWRAP><%= strRsvGrpName(i) %></TD>
		</TR>
<%
		'お連れ様情報の有無を判定
		If strHasFriends(i) <> "" Then
			blnHasFriends = True
		End If

	Next
%>
</TABLE>
<BR>
<%
'同伴者２人連れであるかを判断
Do
	blnComp = False

	'２名でなければ終了
	If lngCount <> 2 Then
		Exit Do
	End If

	'それぞれの個人ＩＤ、同伴者個人ＩＤをクロス比較し、同伴者どうしであるかを判定。真ならメッセージ。
	If strArrPerId(0) = strArrCompPerId(1) And strArrPerId(0) = strArrCompPerId(1) Then
%>
		<FONT COLOR="#ff9900"><B>この2名は同伴者です。</B></FONT><BR><BR>
<%
		blnComp = True
		Exit Do
	End If

	'相手とは異なる同伴者を持つ場合はこれ以上何もしない
	If (strArrCompPerId(0) <> "" And strArrCompPerId(0) <> strArrPerId(1)) Or (strArrCompPerId(1) <> "" And strArrCompPerId(1) <> strArrPerId(0)) Then
		Exit Do
	End If

	'上記以外であれば同伴者として登録可能な機能を用意する
%>
	<A HREF="javascript:updateCompPerId('<%= strArrPerId(0) %>','<%= strArrPerId(1) %>')">この2名を同伴者として登録する</A><BR><BR>
<%
	Exit Do
Loop

'お連れ様登録要否の判断
Do

	'すでにお連れ様として登録されている情報があれば終了
	If blnHasFriends Then
%>
		<FONT COLOR="#ff9900"><B>お連れ様として登録されています。</B></FONT><BR><BR>
<%
		Exit Do
	End If

	'複数名でなれれば終了
	If lngCount <= 1 Then
		Exit Do
	End If

	'お連れ様として登録可能な機能を用意する
%>
	<A HREF="javascript:registFriends()">これらの受診情報をお連れ様として登録する</A><BR>
<%
	Exit Do
Loop
%>
<BR>
<A HREF="javascript:deleteConsult()"><IMG SRC="/webHains/images/delete.gif" ALT="この受診情報を削除する" HEIGHT="24" WIDTH="73"></A>
</BODY>
</HTML>
