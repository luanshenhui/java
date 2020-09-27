<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   変更履歴（ヘッダ） (Ver0.0.1)
'	   AUTHER  : T.Yaguchi@ORB
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objFollowUp			'フォローアップアクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strAct				'処理状態
Dim lngRsvNo			'予約番号
Dim strFromDate			'更新日（開始）
Dim strFromYear			'更新日　年（開始）
Dim strFromMonth		'更新日　月（開始）
Dim strFromDay			'更新日　日（開始）
Dim strToDate			'更新日（開始）
Dim strToYear			'更新日　年（開始）
Dim strToMonth			'更新日　月（開始）
Dim strToDay			'更新日　日（開始）
Dim strUpdUser			'更新者
Dim strClass			'更新分類
Dim lngOrderbyItem		'並べ替え項目(0:更新日,1:更新者,2:分類・項目）
Dim lngOrderbyMode      '並べ替え方法(0:昇順,1:降順)
Dim lngStartPos				'表示開始位置
Dim lngPageMaxLine			'１ページ表示ＭＡＸ行
Dim strFollowNoteFlg		'フォロー状況管理ログ表示フラグ

Dim vntUpdDate            '更新日時
Dim vntUpdUser            '更新者
Dim vntUpdUserName        '更新者氏名
Dim vntUpdClass           '更新分類
Dim vntUpdDiv             '処理区分
Dim vntRsvNo              '予約番号
Dim vntJudClassCd         '判定分類コード
Dim vntJudClassName       '判定分類名称
Dim vntBefore       '更新前値
Dim vntAfter        '更新後値

Dim strUpdClassName			'更新分類名称
Dim strItemName				'項目名称
Dim strUpdDivName			'処理区分名称

Dim lngCount				'全件数

Dim strURL					'ジャンプ先のURL

Dim i						'ループカウンタ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objFollowUp         = Server.CreateObject("HainsFollowUp.FollowUp")

'引数値の取得
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo            = Request("rsvno")
strFromDate         = Request("fromDate")
strFromYear         = Request("fromyear")
strFromMonth        = Request("frommonth")
strFromDay          = Request("fromday")
strToDate           = Request("toDate")
strToYear           = Request("toyear")
strToMonth          = Request("tomonth")
strToDay            = Request("today")
strUpdUser          = Request("upduser")
strClass            = Request("updclass")
lngOrderbyItem      = Request("orderbyItem")
lngOrderbyMode      = Request("orderbyMode")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")
strFollowNoteFlg    = Request("followNoteFlg")

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Do	

	If strAct <> "" Then
'If lngStartPos <> "1" Then
'Err.Raise 1000, , strFromDate & " " &  strToDate & " " & strUpdUser & " " & strClass & " " & lngOrderby'Item & " " & lngOrderbyMode & " " & lngStartPos & " " & lngPageMaxLine
'End If

		' ## 検索条件に予約番号(lngRsvNo)追加 2004.01.07
		lngCount = objFollowUp.SelectFollowLogList( _
		        				strFromDate,       strToDate, _
		        				strUpdUser & "", _
		        				strClass, _
		        				lngOrderbyItem,    lngOrderbyMode, _
		        				lngStartPos,       lngPageMaxLine, _
								lngRsvNo, _
		        				vntUpdDate, _
		        				vntUpdUser,        vntUpdUserName, _
		        				vntUpdClass,       vntUpdDiv, _
		        				vntRsvNo, _
		        				vntJudClassCd,     vntJudClassName, _
		        				vntBefore,   vntAfter 	)

	End If

	Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>変更履歴</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="fromDate" VALUE="<%= strFromDate %>">
	<INPUT TYPE="hidden" NAME="fromyear" VALUE="<%= strFromYear %>">
	<INPUT TYPE="hidden" NAME="frommonth" VALUE="<%= strFromMonth %>">
	<INPUT TYPE="hidden" NAME="fromday" VALUE="<%= strFromDay %>">
	<INPUT TYPE="hidden" NAME="toDate" VALUE="<%= strToDate %>">
	<INPUT TYPE="hidden" NAME="toyear" VALUE="<%= strToYear %>">
	<INPUT TYPE="hidden" NAME="tomonth" VALUE="<%= strToMonth %>">
	<INPUT TYPE="hidden" NAME="today" VALUE="<%= strToDay %>">
	<INPUT TYPE="hidden" NAME="upduser" VALUE="<%= strUpdUser %>">
	<INPUT TYPE="hidden" NAME="updclass" VALUE="<%= strClass %>">
	<INPUT TYPE="hidden" NAME="orderbyItem" VALUE="<%= lngOrderbyItem %>">
	<INPUT TYPE="hidden" NAME="orderbyMode" VALUE="<%= lngOrderbyMode %>">
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= lngStartPos %>">
	<INPUT TYPE="hidden" NAME="pageMaxLine" VALUE="<%= lngPageMaxLine %>">
	<INPUT TYPE="hidden" NAME="followNoteFlg" VALUE="<%= strFollowNoteFlg %>">

<%
	IF strAct <> "" Then
	If lngCount <= 0 Then
%>
		検索条件を満たす履歴は存在しませんでした。<BR>
<%
	Else
%>
		検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。
		<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
			<TR BGCOLOR="#cccccc">
				<TD NOWRAP>更新日時</TD>
				<TD NOWRAP>更新者</TD>
				<TD NOWRAP>分類</TD>
				<TD NOWRAP>判定名称</TD>
				<TD NOWRAP>処理</TD>
				<TD WIDTH="228" NOWRAP>更新前</TD>
				<TD NOWRAP WIDTH="244">更新後</TD>
			</TR>
<%
			For i = 0 To UBound(vntUpdDate)
				'更新分類名称セット
				Select Case vntUpdClass(i)
					Case 1
						strUpdClassName = "二次検査受診日"
					Case 2
						strUpdClassName = "来院"
					Case 3
						strUpdClassName = "検査項目"
					Case 4
						strUpdClassName = "予約情報"
					Case 5
						strUpdClassName = "検査結果"
					Case 6
						strUpdClassName = "アンケート"
					Case 7
						strUpdClassName = "フォローアップはがき"
					Case 8
						strUpdClassName = "フォロアップ対象者"
					Case 9
						strUpdClassName = "健診項目削除"
					Case 0
						strUpdClassName = "健診項目追加"
					Case Else
						strUpdClassName = "その他"
				End Select

				'項目名称セット
				strItemName = vntJudClassName(i)
			
				'処理区分名称セット
				Select Case vntUpdDiv(i)
					Case "I"
						strUpdDivName = "挿入"
					Case "U"
						strUpdDivName = "更新"
					Case "D"
						strUpdDivName = "削除"
				End Select

%>
				<TR VALIGN="top">
					<TD NOWRAP BGCOLOR="#eeeeee"><%= vntUpdDate(i) %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= vntUpdUserNAME(i) %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= strUpdClassName %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= strItemName %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee"><%= strUpdDivName %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="228"><%= vntBefore(i) %></TD>
					<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="244"><%= vntAfter(i) %></TD>
				</TR>
<%
			Next
%>
<%
			'全件検索時はページングナビゲータ不要
   	     	If lngPageMaxLine <= 0 Then
			Else
				'URLの編集
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?winmode="     & strWinMode
				strURL = strURL & "&action="      & strAct
				strURL = strURL & "&rsvno="       & lngRsvNo
				strURL = strURL & "&fromDate="    & strFromDate
				strURL = strURL & "&fromyear="    & strFromYear
				strURL = strURL & "&frommonth="   & strFromMonth
				strURL = strURL & "&fromday="     & strFromDay
				strURL = strURL & "&toDate="      & strToDate
				strURL = strURL & "&toyear="      & strToYear
				strURL = strURL & "&tomonth="     & strToMonth
				strURL = strURL & "&today="       & strToDay
				strURL = strURL & "&upduser="     & strUpdUser
				strURL = strURL & "&updclass="    & strClass
				strURL = strURL & "&orderbyItem=" & lngOrderbyItem
				strURL = strURL & "&orderbyMode=" & lngOrderbyMode
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
				strURL = strURL & "&followNoteFlg=" & strFollowNoteFlg

				'ページングナビゲータの編集
'Err.Raise 1000, , lngCount & " " &  lngStartPos & " " & lngPageMaxLine 
%>
				<%= EditPageNavi(strURL, CLng(lngCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
		<BR>
<%
	End If
	End If
%>
</FORM>
</BODY>
</HTML>