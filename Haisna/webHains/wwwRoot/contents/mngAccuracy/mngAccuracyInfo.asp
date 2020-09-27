<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   精度管理 (Ver1.0.0)
'	   AUTHER  : Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon				'共通クラス
Dim objMngAccuracy			'精度管理クラス

'--- Post or Get Data
Dim strStartCslDate     	'検索条件受診年月日（開始）
Dim strStartYear     		'検索条件受診年（開始）
Dim strStartMonth     		'検索条件受診月（開始）
Dim strStartDay     		'検索条件受診日（開始）
Dim lngGenderMode			'
Dim lngBorder				'

'--- From COM+ Data
Dim vntSeq
Dim vntItemCd
Dim vntSuffix
Dim vntItemName
Dim vntGender
Dim vntResultCount
Dim vntVal_L
Dim vntVal_S
Dim vntVal_H
Dim vntPercent_L
Dim vntPercent_H

'--- Control Variables
Dim strAction				'search:検索処理
Dim lngGetCount				'件数
Dim i						'カウンタ
Dim strMessage

'--- For Brouser Control
Dim lngArrGenderMode()		'性別モードコンボ用配列（コード）
Dim strArrGenderModeName()	'性別モードコンボ用配列（名称）
Dim strDispItemCd			'
Dim strDispItemName			'
Dim strDispGenderName		'
Dim lngPrevSeq				'
Dim strDispPercent_L		'
Dim strDispPercent_H		'
Dim blnBoldMode				'

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")

strStartDay       = Request("startDay")

'デフォルトはシステム年月日を適用する
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If

'-- コンボボックス編集用変数設定
Call CreateGenderModeInfo()

Do

	If strAction <> "" Then

		'入力チェック
		strMessage = CheckValue()
		If Not IsEmpty(strMessage) Then
			strAction = ""
			Exit Do
		End If

		'検索条件に従い成績書情報一覧を抽出する
		Set objMngAccuracy = Server.CreateObject("HainsMngAccuracy.MngAccuracy")

		lngGetCount = objMngAccuracy.SelectMngAccuracy(cDate(strStartCslDate), _
		                                               lngGenderMode, _
													   vntSeq, _
													   vntItemCd, _
													   vntSuffix, _
													   vntItemName, _
													   vntGender, _
													   vntResultCount, _
													   vntVal_L, _
													   vntVal_S, _
													   vntVal_H, _
													   vntPercent_L, _
													   vntPercent_H)
	

	End If

	Exit Do

Loop
'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス
	Dim strArrMessage	'エラーメッセージの配列

	'検索開始終了受診日の編集
	strStartCslDate = strStartYear & "/" & strStartMonth & "/" & strStartDay

	lngGenderMode = Request("genderMode")
	lngBorder     = Request("border")

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	If Not IsDate(strStartCslDate) Then
		objCommon.AppendArray strArrMessage, "指定された受診日が正しい日付ではありません。"
	End If

	If Trim(lngBorder) <> "" Then
		If Not IsNumeric(lngBorder) Then
			objCommon.AppendArray strArrMessage, "基準外境界比率には正しい数字を入力してください。"
		End If
	End If

	'チェック結果を返す
	CheckValue = strArrMessage

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 性別指定の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateGenderModeInfo()

	Redim Preserve lngArrGenderMode(3)
	Redim Preserve strArrGenderModeName(3)

	lngArrGenderMode(0) = 1 :strArrGenderModeName(0) = "男性のみ"
	lngArrGenderMode(1) = 2 :strArrGenderModeName(1) = "女性のみ"
	lngArrGenderMode(2) = 3 :strArrGenderModeName(2) = "男女個別で全て"
	lngArrGenderMode(3) = 4 :strArrGenderModeName(3) = "性別区別なし"

End Sub
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>精度管理</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 検索ボタンクリック
function searchClick() {

	with ( document.mngAccuracy ) {
		action.value = 'search';
		submit();
	}

	return false;

}

// アンロード時の処理
function closeGuideWindow() {

	//日付ガイドを閉じる
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="mngAccuracy" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>"> 
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">精度管理</FONT></B></TD>
	</TR>
</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>受診日</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;日
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>表示対象</TD>
		<TD>：</TD>
		<TD><%= EditDropDownListFromArray("genderMode", lngArrGenderMode, strArrGenderModeName, lngGenderMode, NON_SELECTED_DEL) %>　</TD>
	</TR>
	<TR>
		<TD>基準外</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="TEXTBOX" NAME="Border" MAXLENGTH="4" SIZE="6" VALUE="<%= lngBorder %>">&nbsp;%以上の基準値外比率は強調して表示</TD>
		<TD WIDTH="45"></TD>
		<TD ROWSPAN="2" VALIGN="BOTTOM"><A HREF="javascript:searchClick()"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
	</TR>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD><SPAN STYLE="color:#999999">※空白で実行した場合、強調表示はされません。</SPAN></TD>
	</TR>
</TABLE>
<BR>
<!--ここは検索件数結果-->
<%
	If strAction <> "" Then
%>

<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD>「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日</B></FONT>」の検査結果情報を表示しています。
			検索結果は<FONT COLOR="#ff6600"><B><%= lngGetCount %></B></FONT>件です。 
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
	<TR BGCOLOR="silver">
		<TD ALIGN="left" NOWRAP ROWSPAN="2">検査項目コード</TD>
		<TD ALIGN="left" NOWRAP ROWSPAN="2">検査項目名</TD>
		<TD ALIGN="left" NOWRAP ROWSPAN="2">性別</TD>
		<TD ALIGN="left" ROWSPAN="2" WRAP>有効検査結果数</TD>
		<TD BGCOLOR="#FFFFFF" WIDTH="4" ROWSPAN="2"></TD>
		<TD ALIGN="CENTER" COLSPAN="3" NOWRAP>検査結果数</TD>
		<TD BGCOLOR="#FFFFFF" WIDTH="4"></TD>
		<TD ALIGN="CENTER" COLSPAN="2" NOWRAP>比率</TD>
	</TR>
	<TR BGCOLOR="silver">
		<TD ALIGN="left" NOWRAP>基準外（低）</TD>
		<TD ALIGN="left" NOWRAP>基準内</TD>
		<TD ALIGN="left" NOWRAP>基準外（高）</TD>
		<TD BGCOLOR="#FFFFFF"></TD>
		<TD ALIGN="left" NOWRAP>基準外（低）</TD>
		<TD ALIGN="left" NOWRAP>基準外（高）</TD>
	</TR>
<%
	End If

	If lngGetCount > 0 Then

		For i = 0 To UBound(vntItemCd)

			blnBoldMode = False
			strDispItemCd = ""
			strDispItemName = ""
			strDispGenderName = ""
			strDispPercent_L = FormatNumber(vntPercent_L(i), 1) & "%"
			strDispPercent_H = FormatNumber(vntPercent_H(i), 1) & "%"

			'前回と同じ検索項目の場合、インディケイトする
			If vntSeq(i) <> lngPrevSeq Then
				strDispItemCd = vntItemCd(i) & "-" & vntSuffix(i)
				strDispItemName = vntItemName(i)
			Else
				strDispItemCd = ""
				strDispItemName = ""
			End If

			'性別名称設定
			Select Case vntGender(i)
				Case 1
					strDispGenderName = "男性"
				Case 2
					strDispGenderName = "女性"
				Case 3
					strDispGenderName = "共通"
				Case Else
					strDispGenderName = "？？"
			End Select

			If IsNumeric(lngBorder) Then

				If cDbl(vntPercent_L(i)) >= cDbl(lngBorder) Then
					strDispPercent_L = "<B>" & strDispPercent_L & "</B>"
					blnBoldMode = True
				End If 

				If cDbl(vntPercent_H(i)) >= cDbl(lngBorder) Then
					strDispPercent_H = "<B>" & strDispPercent_H & "</B>"
					blnBoldMode = True
				End If 

				If blnBoldMode = True Then
					strDispItemCd      = "<B>" & strDispItemCd & "</B>"
					strDispItemName    = "<B>" & strDispItemName & "</B>"
					strDispGenderName  = "<B>" & strDispGenderName & "</B>"
				Else
					strDispItemCd      = "<FONT COLOR=""#999999"">" & strDispItemCd & "</FONT>"
					strDispItemName    = "<FONT COLOR=""#999999"">" & strDispItemName & "</FONT>"
					strDispGenderName  = "<FONT COLOR=""#999999"">" & strDispGenderName & "</FONT>"
				End If

			End If

%>
			<TR HEIGHT="18" BGCOLOR="#eeeeee">
				<TD NOWRAP><%= strDispItemCd %></TD>
				<TD NOWRAP><%= strDispItemName %></TD>
				<TD NOWRAP><%= strDispGenderName %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= vntResultCount(i) %></TD>
				<TD BGCOLOR="#FFFFFF"></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#E6E6FA"><%= vntVal_L(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= vntVal_S(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#FFC0CB"><%= vntVal_H(i) %></TD>
				<TD BGCOLOR="#FFFFFF"></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#E6E6FA"><%= strDispPercent_L %></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#FFC0CB"><%= strDispPercent_H %></TD>
			</TR>
<%

			lngPrevSeq = vntSeq(i)

		Next

	End If
%>
</TABLE>
		<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>