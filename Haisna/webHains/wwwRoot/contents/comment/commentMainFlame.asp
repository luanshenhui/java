<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   情報コメント  (Ver0.0.1)
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
Dim objHainsUser		'ユーザ情報アクセス用
Dim objConsult			'受診クラス
Dim objFree				'汎用情報アクセス用

'パラメータ
Dim lngRsvNo			'予約番号
Dim strPerId			'個人ID
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCtrPtCd			'契約パターンコード
Dim lngStrYear			'表示開始年
Dim lngStrMonth			'表示開始月
Dim lngStrDay			'表示開始日
Dim lngEndYear			'表示終了年
Dim lngEndMonth			'表示終了月
Dim lngEndDay			'表示終了日
Dim strPubNoteDivCd		'ノート分類
Dim strPubNoteDivCdCtr	'ノート分類(契約用)
Dim strPubNoteDivCdOrg	'ノート分類(団体用)
Dim lngDispKbn			'表示対象区分
Dim lngDispMode			'表示モード(0:個人＋今回受診＋過去受診, 1:個人・受診＋団体＋契約,
						'           2:個人・受診, 3:個人, 4:団体, 5:契約)
Dim strCmtMode			'コメントモード
Dim strAct				'処理状態
Dim	strWinMode			'ウィンドウモード
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
Dim lngIncDelNote		'1:削除データも表示
'### 2004/3/24 Added End

'ユーザ情報
Dim strUpdUser			'更新者
Dim lngAuthNote      	'参照登録権限
Dim lngDefNoteDispKbn	'ノート初期表示状態

'汎用情報
Dim strFreeField1		'フィールド１
Dim strFreeField2		'フィールド２

Dim strStrDate			'表示期間(開始)
Dim strEndDate			'表示期間(終了)

Dim vntCslDate			'受診日
Dim dtmStrDate			'表示期間(開始)
Dim dtmEndDate			'表示期間(終了)
Dim dtmDate				'日付

Dim strUrlPara			'フレームへのパラメータ
Dim Ret
Dim strHtml				'Html文字列

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
Set objHainsUser	= Server.CreateObject("HainsHainsUser.HainsUser")

'引数値の取得
lngRsvNo		= CLng("0" & Request("rsvno"))
strPerId		= Request("perid")
strOrgCd1		= Request("orgcd1")
strOrgCd2		= Request("orgcd2")
strCtrPtCd		= Request("ctrptcd")
lngStrYear		= CLng("0" & Request("StrYear"))
lngStrMonth		= CLng("0" & Request("StrMonth"))
lngStrDay		= CLng("0" & Request("StrDay"))
lngEndYear		= CLng("0" & Request("EndYear"))
lngEndMonth		= CLng("0" & Request("EndMonth"))
lngEndDay		= CLng("0" & Request("EndDay"))
strPubNoteDivCd	= Request("PubNoteDivCd")
strPubNoteDivCdCtr	= Request("PubNoteDivCdOrg")
strPubNoteDivCdOrg	= Request("PubNoteDivCdCtr")
lngDispKbn		= CLng("0" & Request("DispKbn"))
lngDispMode		= CLng("0" & Request("DispMode"))
strCmtMode		= Request("cmtMode")
strAct			= Request("act")
strWinMode		= Request("winmode")
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
lngIncDelNote   = Request("IncDelNote")
'### 2004/3/24 Added End

strUpdUser		= Session("USERID")

Do
	'ユーザの参照登録権限を取得
	objHainsUser.SelectHainsUser strUpdUser, _
								,,,,,,,,,,,,,,,,,,,,,,,, _
								lngAuthNote, lngDefNoteDispKbn

	Select Case lngAuthNote
	Case 1		'医療のみ
		lngDispKbn = lngAuthNote
	Case 2		'事務のみ
		lngDispKbn = lngAuthNote
	Case 3		'両方
		'パラメータのまま
	Case Else
		strHtml = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHtml = strHtml & vbCrLf & "<HTML lang=""ja"">"
		strHtml = strHtml & "<BODY>"
		strHtml = strHtml & "<TABLE HEIGHT=""100%"" WIDTH=""100%"">"
		strHtml = strHtml & "<TR ALIGN=""center"" VALIGN=""center""><TD><B>参照登録権限がありません</B></TD></TR>"
		strHtml = strHtml & "</TABLE>"
		strHtml = strHtml & "</BODY>"
		strHtml = strHtml & "</HTML>"
		Response.Write strHtml
		Response.End
	End Select

	'予約番号、個人ID、団体コード、契約パターンコードのどれも指定されていない
	If lngRsvNo = "0" & strPerId = "" And strOrgCd1 = "" And strOrgCd2 = "" And strCtrPtCd = "" Then
		Err.Raise 1000, , "予約番号、個人ID、団体コード、契約パターンコードのいずれか一つを必ず指定してください"
	End If

	'予約番号が指定されている場合、受診情報か個人ID、団体コード、契約パターンコードを取得
	If  lngRsvNo <> "0" Then
		Set objConsult	= Server.CreateObject("HainsConsult.Consult")

		'受診情報の取得
		Ret = objConsult.SelectConsult( lngRsvNo, _
										, _
										vntCslDate, _
										strPerId, _
										, , _
										strOrgCd1, _
										strOrgCd2, _
										, , , , , , , , , , , , , , , , , , , _
										0, _
										, , , , , , , , , , , , _
										strCtrPtCd )
		If Ret = False Then
			Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
		End If
	End If


	If strAct = "" Then
		'初回表示時に表示期間が指定されていないときは、デフォルトとして汎用テーブルに設定されている日付とする

		'汎用テーブルから表示期間を読み込む
		Set objFree = Server.CreateObject("HainsFree.Free")
		If objFree.SelectFree(0, "CMTPERIOD", , , , strFreeField1, strFreeField2) = 1 Then
			If strFreeField2 <> "" Then
				If CLng(strFreeField2) < 0 Then
					'過去
					If lngStrYear = 0 And lngStrMonth = 0 And lngStrDay = 0 Then
                        '### 2004/9/22 修正（張）
                        '### 団体と契約関係のコメントの場合デフォルト表示日付を当日に統一して表示するように修正
'                        lngStrYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
'                        lngStrMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
'                        lngStrDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        If lngDispMode = 4 Or lngDispMode = 5 Then
                            lngStrYear  = Year(Date)
                            lngStrMonth = Month(Date)
                            lngStrDay   = Day(Date)
                        Else
                            lngStrYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
                            lngStrMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
                            lngStrDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        End If
                    End If
					If lngEndYear = 0 Or lngEndMonth = 0 Or lngEndDay = 0 Then
						lngEndYear  = Year(Date)
						lngEndMonth = Month(Date)
						lngEndDay   = Day(Date)
					End If
				Else
					'未来
					If lngStrYear = 0 And lngStrMonth = 0 And lngStrDay = 0 Then
						lngStrYear  = Year(Date)
						lngStrMonth = Month(Date)
						lngStrDay   = Day(Date)
					End If
					If lngEndYear = 0 Or lngEndMonth = 0 Or lngEndDay = 0 Then
                        '### 2004/9/22 修正（張）
                        '### 団体と契約関係のコメントの場合デフォルト表示日付を当日に統一して表示するように修正
						'lngEndYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
						'lngEndMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
						'lngEndDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        If lngDispMode = 4  Or lngDispMode = 5 Then
                            lngEndYear  = Year(Date)
                            lngEndMonth = Month(Date)
                            lngEndDay   = Day(Date)
                        Else
						    lngEndYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
						    lngEndMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
						    lngEndDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        End If
					End If
				End If
			End If
		End If

		strAct = "search"

	Else
		If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
			If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
				Err.Raise 1000, , "表示期間の指定に誤りがあります。"
			End If

			strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
			dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
		Else
			strStrDate = ""
			dtmStrDate = 0
		End If

		If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
			If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
				Err.Raise 1000, , "表示期間の指定に誤りがあります。"
			End If

			strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay
			dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
		Else
			strEndDate = ""
			dtmEndDate = 0
		End If

		'終了日未設定時は何もしない
		If dtmEndDate <> 0 Then
			'開始日未設定、または開始日より終了日が過去であれば
			If dtmStrDate = 0 Or dtmStrDate > dtmEndDate Then

				'値を交換
				dtmDate    = dtmStrDate
				dtmStrDate = dtmEndDate
				dtmEndDate = dtmDate

			End If

			'更に同値の場合、終了日はクリア
'			If dtmStrDate = dtmEndDate Then
'				dtmEndDate = 0
'			End If
		End If

		'後の処理のために年月日を再編集
		If dtmStrDate <> 0 Then
			lngStrYear  = Year(dtmStrDate)
			lngStrMonth = Month(dtmStrDate)
			lngStrDay   = Day(dtmStrDate)
		Else
			lngStrYear  = 0
			lngStrMonth = 0
			lngStrDay   = 0
		End If

		If dtmEndDate <> 0 Then
			lngEndYear  = Year(dtmEndDate)
			lngEndMonth = Month(dtmEndDate)
			lngEndDay   = Day(dtmEndDate)
		Else
			lngEndYear  = 0
			lngEndMonth = 0
			lngEndDay   = 0
		End If
	End If

	'フレームへのパラメータ設定
	strUrlPara = "?rsvno=" & lngRsvNo
	strUrlPara = strUrlPara & "&perid=" & strPerId 
	strUrlPara = strUrlPara & "&orgcd1=" & strOrgCd1
	strUrlPara = strUrlPara & "&orgcd2=" & strOrgCd2
	strUrlPara = strUrlPara & "&ctrptcd=" & strCtrPtCd
	strUrlPara = strUrlPara & "&StrYear=" & lngStrYear
	strUrlPara = strUrlPara & "&StrMonth=" & lngStrMonth
	strUrlPara = strUrlPara & "&StrDay=" & lngStrDay
	strUrlPara = strUrlPara & "&EndYear=" & lngEndYear
	strUrlPara = strUrlPara & "&EndMonth=" & lngEndMonth
	strUrlPara = strUrlPara & "&EndDay=" & lngEndDay
	strUrlPara = strUrlPara & "&PubNoteDivCd=" & strPubNoteDivCd
	strUrlPara = strUrlPara & "&PubNoteDivCdCtr=" & strPubNoteDivCdCtr
	strUrlPara = strUrlPara & "&PubNoteDivCdOrg=" & strPubNoteDivCdOrg
	strUrlPara = strUrlPara & "&DispKbn=" & lngDispKbn
'### 2004/3/24 Added by Ishihara@FSIT 削除データ表示対応
	strUrlPara = strUrlPara & "&IncDelNote=" & lngIncDelNote
'### 2004/3/24 Added End
	strUrlPara = strUrlPara & "&dispmode=" & lngDispMode
	strUrlPara = strUrlPara & "&cmtMode=" & strCmtMode
	strUrlPara = strUrlPara & "&winmode=" & strWinMode

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>情報コメント</TITLE>
<script type="text/javascript">
var params = {
    rsvno:           "<%= lngRsvNo %>",
    perid:           "<%= strPerId %>",
    orgcd1:          "<%= strOrgCd1 %>",
    orgcd2:          "<%= strOrgCd2 %>",
    ctrptcd:         "<%= strCtrPtCd %>",
    StrYear:         "<%= lngStrYear %>",
    StrMonth:        "<%= lngStrMonth %>",
    StrDay:          "<%= lngStrDay %>",
    EndYear:         "<%= lngEndYear %>",
    EndMonth:        "<%= lngEndMonth %>",
    EndDay:          "<%= lngEndDay %>",
    PubNoteDivCd:    "<%= strPubNoteDivCd %>",
    PubNoteDivCdCtr: "<%= strPubNoteDivCdCtr %>",
    PubNoteDivCdOrg: "<%= strPubNoteDivCdOrg %>",
    DispKbn:         "<%= lngDispKbn %>",
    dispmode:        "<%= lngDispMode %>",
    IncDelNote:      "<%= lngIncDelNote %>",
    cmtMode:         "<%= strCmtMode %>",
    winmode:         "<%= strWinMode %>",
    act:             "<%= strAct %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<%
	Select Case lngDispMode
	Case 0		'個人＋今回受診＋過去受診
%>
	<FRAMESET ROWS="175,*,*,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=1">
		<FRAME NAME="List2"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=2">
		<FRAME NAME="List3"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=3">
<%
	Case 1		'個人・受診＋団体＋契約
%>
	<FRAMESET ROWS="175,*,*,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=4">
		<FRAME NAME="List2"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=5">
		<FRAME NAME="List3"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=6">
<%
	Case 2		'個人・受診（面接支援のチャート情報、注意事項専用）
%>
	<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode="1",190,115) %>,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=4">
<%
	Case 3		'個人
%>
	<FRAMESET ROWS="175,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=1">
<%
	Case 4		'団体
%>
	<FRAMESET ROWS="175,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=5">
<%
	Case 5		'請求
%>
	<FRAMESET ROWS="175,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=6">

<%
	End Select
%>
		<NOFRAMES>
			<BODY BGCOLOR="#ffffff">
				<P></P>
			</BODY>
		</NOFRAMES>
	</FRAMESET>
</HTML>
