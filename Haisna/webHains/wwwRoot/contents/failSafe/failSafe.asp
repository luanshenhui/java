<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   FAILSAFE (Ver0.0.1)
'	   AUTHER  : t.yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"     -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon					'共通クラス
Dim objFailSafe					'FailSafeアクセス用

'パラメータ値
Dim lngStrYear			'受診日(自)(年)
Dim lngStrMonth			'受診日(自)(月)
Dim lngStrDay			'受診日(自)(日)
Dim lngEndYear			'受診日(至)(年)
Dim lngEndMonth			'受診日(至)(月)
Dim lngEndDay			'受診日(至)(日)
Dim strMode			'モード

'受診情報の配列
Dim strArrRsvNo			'予約番号の配列
Dim strArrCslDate		'受診日の配列
Dim strArrPerId			'個人IDの配列
Dim strArrCsCd			'コースコードの配列
Dim strArrOrgCd1		'団体コード１の配列
Dim strArrOrgCd2		'団体コード２の配列
Dim strArrAge			'受診時年齢の配列
Dim strArrLastName		'姓の配列
Dim strArrFirstName		'名の配列
Dim strArrCsName		'コース名の配列
Dim strArrMOrgCd1		'団体コード１の配列
Dim strArrMOrgCd2		'団体コード２の配列
Dim strArrMPrice		'金額の配列
Dim strArrMTax			'税額の配列
Dim strArrCPrice		'負担金額の配列
Dim strArrCTax			'消費税の配列
Dim strArrCtrPtCd		'契約パターンコードの配列
Dim strArrOptCd			'オプションコードの配列
Dim strArrOptBranchNo		'オプション枝番の配列
Dim strArrOptName		'オプション名の配列
Dim strArrOrgSName		'団体略称名の配列
Dim strArrOptMsg		'オプションメッセージ(年:年齢,性:性別,受:受診区分)の配列
Dim strArrP_Age			'現在の契約からの受診時年齢の配列
Dim strArrLimitFlg		'限度額フラグ(0:限度額と一致,1:限度額と違う)
Dim lngCount			'レコード件数(受診情報)

Dim blnTargetFlg		'対象フラグ
Dim blnTargetFlg2		'対象フラグ
Dim dtmStrDate			'受診日(自)
Dim dtmEndDate			'受診日(至)
Dim dtmDate			'日付
Dim strDispDate			'表示用の受診日付
Dim strMessage			'エラーメッセージ
Dim i, j, k			'インデックス
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFailSafe = Server.CreateObject("HainsFailSafe.FailSafe")
Set objCommon = Server.CreateObject("HainsCommon.Common")

'引数値の取得
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngStrDay   = CLng("0" & Request("strDay"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))
lngEndDay   = CLng("0" & Request("endDay"))
strMode     = Request("mode")

Do

	If strMode <> "RUN"Then
		Exit Do
	End If

	'受診日(自)の日付チェック
	If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
		If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
			strMessage = "受診日の指定に誤りがあります。"
			Exit Do
		End If
	End If

	'受診日(至)の日付チェック
	If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
		If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
			strMessage = "受診日の指定に誤りがあります。"
			Exit Do
		End If
	End If

	'受診日の編集
	If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
		dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
	End If

	If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
		dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
	End If

	Do

		'終了日未設定時は何もしない
		If dtmEndDate = 0 Then
			Exit Do
		End If

		'開始日未設定、または開始日より終了日が過去であれば
		If dtmStrDate = 0 Or dtmStrDate > dtmEndDate Then

			'値を交換
			dtmDate    = dtmStrDate
			dtmStrDate = dtmEndDate
			dtmEndDate = dtmDate

		End If

		'更に同値の場合、終了日はクリア
		If dtmStrDate = dtmEndDate Then
			dtmEndDate = 0
		End If

		Exit Do
	Loop

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

	'検索キー、受診日のいずれかが指定されていない場合は検索を行わない
	If dtmEndDate = 0 And dtmStrDate = 0 Then
		strMessage = "検索条件を満たす受診情報は存在しません。"
		Exit Do
	End If

	If dtmStrDate < Date Then
		strMessage = "受診日は今日以降を指定して下さい。"
		Exit Do
	End If


	'日付の範囲チェック３１日まで
	If dtmEndDate - dtmStrDate > 30 Then
		strMessage = "日付は１ヶ月以内を指定して下さい！！"
		Exit Do
	End If

'	'受診情報の読み込み
'	Set objFailSafe = Server.CreateObject("HainsFailSafe.FailSafe")
	lngCount = objFailSafe.SelectConsult( _
						dtmStrDate, dtmEndDate, _
						strArrRsvNo, strArrCslDate, _
						strArrPerId, strArrCsCd, _
						strArrOrgCd1, strArrOrgCd2, _
						strArrAge, strArrLastName, _
						strArrFirstName, strArrCsName, _
						strArrMOrgCd1, strArrMOrgCd2, _
						strArrMPrice, strArrMTax, _
						strArrCPrice, strArrCTax, _
						strArrCtrPtCd, strArrOptCd, _
						strArrOptBranchNo, strArrOptName, _
						strArrOrgSName, strArrOptMsg, _
						strArrP_Age, strArrLimitFlg _
			   		)

	If lngCount = 0 Then
		strMessage = "検索条件を満たす受診情報は存在しません。"
	End If

'	Set objFailSafe = Nothing

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : タイトル行の編集
'
' 引数　　 : (In)     strAddDiv   追加検査区分
' 　　　　   (In)     strAddName  追加検査名
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditTitle()

	Dim strTitle	'タイトル

	'タイトル名の配列を作成
	strTitle = Array( _
				   "予約番号",       "受診日",           "個人ID",         "氏名",             "コース", _
				   "コース名",       "予歳",             "契歳",           "限",               "区", _
				   "負担元",         "負担元名",           "オプション",     "オプション名",     "予約時金額", _
				   "予約時消費税",   "契約金額",       "契約消費税"							 _
			   )
%>
	<TR BGCOLOR="#cccccc">
<%
		For i = 0 To UBound(strTitle)
%>
			<TD NOWRAP><%= strTitle(i) %></TD>
<%
		Next
%>
	</TR>
<%
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 金額情報の編集
'
' 引数　　 : (In)     strMOrgCd1	負担元コード１
' 　　　　   (In)     strMOrgCd2	負担元コード２
' 　　　　   (In)     strMPrice		金額(CONSULT_M)
' 　　　　   (In)     strMTax		消費税(CONSULT_M)
' 　　　　   (In)     strCPrice		金額(CTRPT_PRICE)
' 　　　　   (In)     strCTax		消費税(CTRPT_PRICE)
' 　　　　   (In)     strCtrPtCd	契約パターンコード
' 　　　　   (In)     strOptCd		オプションコード
' 　　　　   (In)     strOptBranchNo	オプション枝番
' 　　　　   (In)     strOptName	オプション名
' 　　　　   (In)     strOrgSName	団体略称名
' 　　　　   (In)     strOptMsg		オプションメッセージ(年:年齢,性:性別,受:受診区分)
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditPriceItem(strMOrgCd1, strMOrgCd2, strMPrice, _
		  strMTax, strCPrice, strCTax, _
		  strCtrPtCd, strOptCd, strOptBranchNo, _
		  strOptName, strOrgSName, strOptMsg _
		 )

	Const COLS_PER_ROW = 3	'１行辺りの列数

	Dim strWrkMOrgCd1		'負担元コード１
	Dim strWrkMOrgCd2		'負担元コード２
	Dim strWrkMPrice		'金額(CONSULT_M)
	Dim strWrkMTax			'消費税(CONSULT_M)
	Dim strWrkCPrice		'金額(CTRPT_PRICE)
	Dim strWrkCTax			'消費税(CTRPT_PRICE)
	Dim strWrkCtrPtCd		'契約パターンコード
	Dim strWrkOptCd			'オプションコード
	Dim strWrkOptBranchNo		'オプション枝番
	Dim strWrkOptName		'オプション名
	Dim strWrkOrgSName		'団体略称名
	Dim strWrkOptMsg		'オプションメッセージ(年:年齢,性:性別,受:受診区分)
	Dim lngCount			'追加検査数

	Dim strWOrgCd1			'団体コード１の退避
	Dim strWOrgCd2			'団体コード２の退避
	Dim strMark				'追加検査区分を示すマーク
	Dim i, j				'インデックス

	'金額情報が存在しない場合は処理終了
	If strMOrgCd1 = "" Then
%>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
<%
		Exit Sub
	End If

	'カンマをセパレータとして配列に変換
	strWrkMOrgCd1     = Split(strMOrgCd1,  ",")
	strWrkMOrgCd2     = Split(strMOrgCd2,  ",")
	strWrkMPrice      = Split(strMPrice,  ",")
	strWrkMTax        = Split(strMTax,  ",")
	strWrkCPrice      = Split(strCPrice,  ",")
	strWrkCTax        = Split(strCTax,  ",")
	strWrkCtrPtCd     = Split(strCtrPtCd,  ",")
	strWrkOptCd       = Split(strOptCd,  ",")
	strWrkOptBranchNo = Split(strOptBranchNo,  ",")
	strWrkOptName     = Split(strOptName,  ",")
	strWrkOrgSName    = Split(strOrgSName,  ",")
	strWrkOptMsg      = Split(strOptMsg,  ",")
	lngCount = UBound(strWrkMOrgCd1)
	'配列ではない時は１番目に格納する
	If lngCount = 0 Then
		Redim strWrkMOrgCd1(0)
		Redim strWrkMOrgCd2(0)
		Redim strWrkMPrice(0)
		Redim strWrkMTax(0)
		Redim strWrkCPrice(0)
		Redim strWrkCTax(0)
		Redim strWrkCtrPtCd(0)
		Redim strWrkOptCd(0)
		Redim strWrkOptBranchNo(0)
		Redim strWrkOptName(0)
		Redim strWrkOrgSName(0)
		Redim strWrkOptMsg(0)
		strWrkMOrgCd1(0)     = strMOrgCd1
		strWrkMOrgCd2(0)     = strMOrgCd2
		strWrkMPrice(0)      = strMPrice
		strWrkMTax(0)        = strMTax
		strWrkCPrice(0)      = strCPrice
		strWrkCTax(0)        = strCTax
		strWrkCtrPtCd(0)     = strCtrPtCd
		strWrkOptCd(0)       = strOptCd
		strWrkOptBranchNo(0) = strOptBranchNo
		strWrkOptName(0)     = strOptName
		strWrkOrgSName(0)    = strOrgSName
		strWrkOptMsg(0)      = strOptMsg
	End If

%>

	<% '区分 %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
%>
			<TR>
				<TD NOWRAP><%= IIf(strWrkOptMsg(i) = "","　",strWrkOptMsg(i)) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</TD>

	<% '団体コード %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		strWOrgCd1 = ""
		strWOrgCd2 = ""
		For i = 0 To lngCount

			'負担元が変わったら出力
			If strWrkMOrgCd1(i) <> strWOrgCd1 And _
			   strWrkMOrgCd2(i) <> strWOrgCd2 Then
%>
				<TR VALIGN="top"><TD NOWRAP><%= strWrkMOrgCd1(i) & "-" & strWrkMOrgCd2(i) %></TD></TR>
<%
				strWOrgCd1 = strWrkMOrgCd1(i)
			   	strWOrgCd2 = strWrkMOrgCd2(i)
			Else
%>
				<TR><TD NOWRAP>　</TD></TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '団体名 %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		strWOrgCd1 = ""
		strWOrgCd2 = ""
		For i = 0 To lngCount

			'負担元が変わったら出力
			If strWrkMOrgCd1(i) <> strWOrgCd1 And _
			   strWrkMOrgCd2(i) <> strWOrgCd2 Then
%>
				<TR><TD NOWRAP><%= strWrkOrgSName(i) %></TD></TR>
<%
				strWOrgCd1 = strWrkMOrgCd1(i)
			   	strWOrgCd2 = strWrkMOrgCd2(i)
			Else
%>
				<TR><TD NOWRAP>　</TD></TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% 'オプション %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
%>
			<TR>
				<TD NOWRAP><%= strWrkOptCd(i) & "-" & strWrkOptBranchNo(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</TD>

	<% 'オプション名 %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
%>
			<TR>
				<TD NOWRAP><%= strWrkOptName(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</TD>

	<% '予約時金額 %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'金額が違っていたら色を変える
			If strWrkMPrice(i) <> strWrkCPrice(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkMPrice(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkMPrice(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '予約時消費税 %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'消費税が違っていたら色を変える
			If strWrkMTax(i) <> strWrkCTax(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkMTax(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkMTax(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '契約金額 %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'金額が違っていたら色を変える
			If strWrkMPrice(i) <> strWrkCPrice(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkCPrice(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkCPrice(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '契約消費税 %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'消費税が違っていたら色を変える
			If strWrkMTax(i) <> strWrkCTax(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkCTax(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkCTax(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

<%
End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>FailSafe</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 子ウィンドウを閉じる
function closeWindow() {

	// 日付ガイドを閉じる
	calGuide_closeGuideCalendar();
}
//-->
</SCRIPT>

<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY ONLOAD="JavaScript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<FORM NAME="failsafelist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">FailSafe</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<INPUT TYPE="hidden" NAME="mode" VALUE="RUN">
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD COLSPAN="3">検索条件を入力して下さい。</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD NOWRAP>受診日：</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, True) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, True) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, True) %></TD>
						<TD>日</TD>
						<TD>～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, True) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, True) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, True) %></TD>
						<TD>日</TD>
						<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.failsafelist.submit();return false"><IMG SRC="/webHains/images/findrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
						<!--<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></TD>-->
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

<%
	Do
		'実行しない場合は終了
		If strMode <> "RUN"Then
			Exit Do
		End If

		'メッセージが発生している場合は編集して処理終了
		If strMessage <> "" Then
			Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
			<!--<BR>&nbsp;<%= strMessage %>-->
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="10" BORDER="0"></TD>
				<TD></TD>
				<TD></TD>
			</TR>
			<TR>
				<TD>
				</TD>
				<TD WIDTH="300"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD>
					区：契約のｵﾌﾟｼｮﾝと矛盾が生じた場合に年[年齢]、受[受診区分]、性[性別]が表示されます。
				</TD>
			</TR>
			<TR>
				<TD>
					該当者は
					<%=lngCount%>
					名です。
				</TD>
				<TD WIDTH="300"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD>
					限：予約作成後に契約の限度額が変更され矛盾が発生した場合に○が表示されます。
				</TD>
			</TR>
		</TABLE>
		<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
<%
		'タイトル行の編集
		Call EditTitle()

		For i = 0 to lngCount - 1
			Response.Write "<TR VALIGN=""""top"""">"
			Response.Write "<TD NOWRAP>" & strArrRsvNo(i) & "</TD>"
			strDispDate = objCommon.FormatString(strArrCslDate(i), "yyyy/m/d")
			Response.Write "<TD NOWRAP>" & strDispDate & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrPerId(i) & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrLastName(i) & "　" & strArrFirstName(i) & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrCsCd(i) & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrCsName(i) & "</TD>"
%>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
				If strArrAge(i) <> strArrP_Age(i) Then
					Response.Write "<TR BGCOLOR=""#eeeeee"">"
					Response.Write "<TD NOWRAP>" & strArrAge(i) & "</TD>"
					Response.Write "</TR>"
				Else
					Response.Write "<TR>"
					Response.Write "<TD NOWRAP>" & strArrAge(i) & "</TD>"
					Response.Write "</TR>"
				End If
%>
				</TABLE>
			</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
				If strArrAge(i) <> strArrP_Age(i) Then
					Response.Write "<TR BGCOLOR=""#cccccc"">"
					Response.Write "<TD NOWRAP>" & strArrP_Age(i) & "</TD>"
					Response.Write "</TR>"
				Else
					Response.Write "<TR>"
					Response.Write "<TD NOWRAP>" & strArrP_Age(i) & "</TD>"
					Response.Write "</TR>"
				End If
%>
				</TABLE>
			</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
				If strArrLimitFlg(i) = 1 Then
					Response.Write "<TR BGCOLOR=""#cccccc"">"
					Response.Write "<TD NOWRAP>" & "○" & "</TD>"
					Response.Write "</TR>"
				Else
					Response.Write "<TR>"
					Response.Write "<TD NOWRAP></TD>"
					Response.Write "</TR>"
				End If
%>
				</TABLE>
			</TD>
<%

			'金額編集
			Call EditPriceItem(strArrMOrgCd1(i), strArrMOrgCd2(i), strArrMPrice(i), _
					   strArrMTax(i), strArrCPrice(i), strArrCTax(i), _
					   strArrCtrPtCd(i), strArrOptCd(i), strArrOptBranchNo(i), _
					   strArrOptName(i), strArrOrgSName(i), strArrOptMsg(i) _
					  )

%>
			</TR>
<%
		Next
%>
		</TABLE>
<%
		Exit Do
	Loop
	Set objFailSafe = Nothing
%>
	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
