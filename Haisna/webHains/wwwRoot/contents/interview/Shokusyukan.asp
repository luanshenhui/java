<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   栄養指導～食習慣問診  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GRPCD_SHOKUSYUKAN = "X022"	'食習慣問診グループコード

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

'検査結果情報
Dim vntPerId			'予約番号
Dim vntCslDate			'検査項目コード
Dim vntHisNo			'履歴No.
Dim vntRsvNo			'予約番号
Dim vntItemCd			'検査項目コード
Dim vntSuffix			'サフィックス
Dim vntResultType		'結果タイプ
Dim vntItemType			'項目タイプ
Dim vntItemName			'検査項目名称
Dim vntResult			'検査結果
Dim vntUnit				'単位
Dim vntItemQName		'問診文章
Dim vntGrpSeq			'表示順番
Dim vntRslFlg			'検査結果存在フラグ
Dim lngRslCnt			'検査結果数

Dim strLimit(1)			'カロリー制限
Dim strShokusyukan()	'食習慣
Dim strFavorite()		'嗜好品
Dim strDairy()			'乳製品
Dim strMeal()			'食事について
Dim strMorning()		'朝食
Dim strLunch()			'昼食
Dim strDinner()			'夕食
Dim lngShokusyukanCnt	'食習慣データ数
Dim lngFavoriteCnt		'嗜好品データ数
Dim lngDairyCnt			'乳製品データ数
Dim lngMealCnt			'食事についてデータ数
Dim lngMorningCnt(2)	'朝食データ数
Dim lngLunchCnt(2)		'昼食データ数
Dim lngDinnerCnt(2)		'夕食データ数

Dim strAlcohol()		'アルコール
Dim lngAlcoholCnt		'アルコールデータ数

'### 2004/01/23 Start K.Kagawa 飲酒習慣の追加
Dim strDrinking()		'飲酒について
Dim lngDrinkingCnt		'飲酒についてデータ数
'### 2004/01/23 End

Dim strURL				'ジャンプ先のURL
Dim i, j				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
'切替日以降の受診日であれば2012年版用の画面へ
If IsVer201210(lngRsvNo) Then
	Response.Redirect "Shokusyukan201210.asp?grpno=" & strGrpNo & "&rsvno=" & lngRsvNo & "&cscd=" & strCsCd & "&winmode=" & strWinMode
End If
'## 2012.09.11 Add End

Do
	'指定対象受診者の検査結果を取得する
''## 2006.05.10 Mod by 李  *****************************
''前回歴表示モード設定

'	lngRslCnt = objInterView.SelectHistoryRslList( _
'						lngRsvNo, _
'						1, _
'						GRPCD_SHOKUSYUKAN, _
'						0, _
'						"", _
'						0, _
'						0, _
'						1, _
'						vntPerId, _
'						vntCslDate, _
'						vntHisNo, _
'						vntRsvNo, _
'						vntItemCd, _
'						vntSuffix, _
'						vntResultType, _
'						vntItemType, _
'						vntItemName, _
'						vntResult, _
'						, , , , , , _
'						vntUnit, _
'						, , , , , _
'						vntItemQName, _
'						vntGrpSeq, _
'						vntRslFlg _
'						)

	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_SHOKUSYUKAN, _
						1, _
						strCsCd, _
						0, _
						0, _
						1, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult, _
						, , , , , , _
						vntUnit, _
						, , , , , _
						vntItemQName, _
						vntGrpSeq, _
						vntRslFlg _
						)

	If lngRslCnt < 0 Then
		Err.Raise 1000, , "検査結果が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

	Redim strMorning(1,2,-1)
	Redim strLunch(1,2,-1)
	Redim strDinner(1,2,-1)

	For i=0 To lngRslCnt-1
		'カロリー制限
		If CLng(vntGrpSeq(i)) = 1 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				strLimit(0) = vntItemQName(i)
				strLimit(1) = vntResult(i)
			End IF
		End If
		'カロリー制限量
		If CLng(vntGrpSeq(i)) = 2 Then
			'「はい」のとき
			If strLimit(1) = "はい" Then
				strLimit(1) = strLimit(1) & "　（" & IIf(vntRslFlg(i)="1", vntResult(i), "　") & "ｋｃａｌ）"
			End If
		End If
		'食習慣
		If 3 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 13 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				Do
					If vntItemQName(i) = "１週間の欠食回数" Then
						'「それほどでもない」のときだけ欠食回数を表示
						If strShokusyukan(1, lngShokusyukanCnt) = "それほどでもない" Then
							strShokusyukan(1, lngShokusyukanCnt) = strShokusyukan(1, lngShokusyukanCnt) & "　（" & vntItemQName(i) & "　" & vntResult(i) & "回）"
						End If
						Exit Do
					End If
					If vntItemQName(i) = "１週間の間食回数" Then
						'「食べる」のときだけ欠食回数を表示
						If strShokusyukan(1, lngShokusyukanCnt) = "食べる" Then
							strShokusyukan(1, lngShokusyukanCnt) = strShokusyukan(1, lngShokusyukanCnt) & "　（" & vntItemQName(i) & "　" & vntResult(i) & "回）"
						End If
						Exit Do
					End If
					lngShokusyukanCnt = lngShokuSYukanCnt + 1
					Redim Preserve strShokusyukan(1, lngShokusyukanCnt)
					strShokusyukan(0, lngShokusyukanCnt) = vntItemQName(i)
					strShokusyukan(1, lngShokusyukanCnt) = vntResult(i)

					Exit Do
				Loop
			End If
		End If
		'嗜好品
		If 14 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 31 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngFavoriteCnt = lngFavoriteCnt + 1
				Redim Preserve strFavorite(1, lngFavoriteCnt)
				strFavorite(0, lngFavoriteCnt) = vntItemQName(i)
				strFavorite(1, lngFavoriteCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
		'乳製品
		If 32 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 35 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDairyCnt = lngDairyCnt + 1
				Redim Preserve strDairy(1, lngDairyCnt)
				strDairy(0, lngDairyCnt) = vntItemQName(i)
				strDairy(1, lngDairyCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
		'食事について
		If 36 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 38 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMealCnt = lngMealCnt + 1
				Redim Preserve strMeal(1, lngMealCnt)
				strMeal(0, lngMealCnt) = vntItemQName(i)
				strMeal(1, lngMealCnt) = vntResult(i)
			End If
		End If
		'主食（朝食）
		If 39 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 69 Then
			j = 0
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMorningCnt(j) = lngMorningCnt(j) + 1
				If lngMorningCnt(j) > UBound(strMorning, 3) Then
					Redim Preserve strMorning(1, 2, lngMorningCnt(j))
				End If
				strMorning(0, j, lngMorningCnt(j)) = vntItemQName(i)
				strMorning(1, j, lngMorningCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'主菜（朝食）
		If 70 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 100 Then
			j = 1
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMorningCnt(j) = lngMorningCnt(j) + 1
				If lngMorningCnt(j) > UBound(strMorning, 3) Then
					Redim Preserve strMorning(1, 2, lngMorningCnt(j))
				End If
				strMorning(0, j, lngMorningCnt(j)) = vntItemQName(i)
				strMorning(1, j, lngMorningCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'副菜（朝食）
		If 101 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 120 Then
			j = 2
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMorningCnt(j) = lngMorningCnt(j) + 1
				If lngMorningCnt(j) > UBound(strMorning, 3) Then
					Redim Preserve strMorning(1, 2, lngMorningCnt(j))
				End If
				strMorning(0, j, lngMorningCnt(j)) = vntItemQName(i)
				strMorning(1, j, lngMorningCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'主食（昼食）
		If 121 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 151 Then
			j = 0
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngLunchCnt(j) = lngLunchCnt(j) + 1
				If lngLunchCnt(j) > UBound(strLunch, 3) Then
					Redim Preserve strLunch(1, 2, lngLunchCnt(j))
				End If
				strLunch(0, j, lngLunchCnt(j)) = vntItemQName(i)
				strLunch(1, j, lngLunchCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'主菜（昼食）
		If 152 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 182 Then
			j = 1
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngLunchCnt(j) = lngLunchCnt(j) + 1
				If lngLunchCnt(j) > UBound(strLunch, 3) Then
					Redim Preserve strLunch(1, 2, lngLunchCnt(j))
				End If
				strLunch(0, j, lngLunchCnt(j)) = vntItemQName(i)
				strLunch(1, j, lngLunchCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'副菜（昼食）
		If 183 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 202 Then
			j = 2
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngLunchCnt(j) = lngLunchCnt(j) + 1
				If lngLunchCnt(j) > UBound(strLunch, 3) Then
					Redim Preserve strLunch(1, 2, lngLunchCnt(j))
				End If
				strLunch(0, j, lngLunchCnt(j)) = vntItemQName(i)
				strLunch(1, j, lngLunchCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'主食（夕食）
		If 203 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 233 Then
			j = 0
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDinnerCnt(j) = lngDinnerCnt(j) + 1
				If lngDinnerCnt(j) > UBound(strDinner, 3) Then
					Redim Preserve strDinner(1, 2, lngDinnerCnt(j))
				End If
				strDinner(0, j, lngDinnerCnt(j)) = vntItemQName(i)
				strDinner(1, j, lngDinnerCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'主菜（夕食）
		If 234 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 264 Then
			j = 1
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDinnerCnt(j) = lngDinnerCnt(j) + 1
				If lngDinnerCnt(j) > UBound(strDinner, 3) Then
					Redim Preserve strDinner(1, 2, lngDinnerCnt(j))
				End If
				strDinner(0, j, lngDinnerCnt(j)) = vntItemQName(i)
				strDinner(1, j, lngDinnerCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'副菜（夕食）
		If 265 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 284 Then
			j = 2
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDinnerCnt(j) = lngDinnerCnt(j) + 1
				If lngDinnerCnt(j) > UBound(strDinner, 3) Then
					Redim Preserve strDinner(1, 2, lngDinnerCnt(j))
				End If
				strDinner(0, j, lngDinnerCnt(j)) = vntItemQName(i)
				strDinner(1, j, lngDinnerCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'アルコール類
		If 285 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 292 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngAlcoholCnt = lngAlcoholCnt + 1
				Redim Preserve strAlcohol(1, lngAlcoholCnt)
				strAlcohol(0, lngAlcoholCnt) = vntItemQName(i)
				strAlcohol(1, lngAlcoholCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
'### 2004/01/23 Start K.Kagawa 飲酒習慣の追加
		'飲酒について
		If 293 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 294 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDrinkingCnt = lngDrinkingCnt + 1
				Redim Preserve strDrinking(1, lngDrinkingCnt)
				strDrinking(0, lngDrinkingCnt) = vntItemQName(i)
				strDrinking(1, lngDrinkingCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
'### 2004/01/23 End
	Next

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>栄養指導～食習慣問診</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//栄養指導画面呼び出し
function callMenEiyoShido() {
	var url;							// URL文字列

	url = '/WebHains/contents/interview/MenEiyoShido.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	location.href(url);

}

//OCR入力結果確認画面呼び出し
function callOcrNyuryoku() {
	var url;							// URL文字列

	url = '/WebHains/contents/Monshin/ocrNyuryoku.asp';
	url = url + '?rsvno=' + '<%= lngRsvNo %>';
	url = url + '&anchor=5';

	location.href(url);

}

// ジャンプ
function JumpAnchor() {
	var PosY;

	PosY = document.getElementById('Anchor-FoodMenu').offsetTop;
	scrollTo(0, PosY);
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post"  STYLE="margin: 0px;">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="RslCnt"  VALUE="<%= lngRslCnt %>">

	<!-- タイトルの表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">栄養指導～食習慣問診</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="900">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
<%
'			<TD NOWRAP WIDTH="100%"><A HREF="JavaScript:callOcrNyuryoku()">OCR入力結果確認</A></TD>
			strURL = "/WebHains/contents/Monshin/ocrNyuryoku.asp"
			strURL = strURL & "?rsvno=" & lngRsvNo
			strURL = strURL & "&anchor=5"
%>
			<TD NOWRAP WIDTH="100%"><A HREF="<%= strURL %>" TARGET="_blank">OCR入力結果確認</A></TD>
			<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:JumpAnchor()">献立</A></TD>
			<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callMenEiyoShido()">栄養指導</A></TD>
		</TR>
	</TABLE>

	<!-- 食習慣問診の表示 -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">１．摂取エネルギーについて</TD>
					</TR>
<%
	If strLimit(0) <> "" Then
%>
					<TR>
						<TD NOWRAP WIDTH="281"><%= strLimit(0) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="143"><%= strLimit(1) %></TD>
					</TR>
<%
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">２．食習慣に当てはまるもの</TD>
					</TR>
<%
	If lngShokusyukanCnt > 0 Then
		For i = 1 To lngShokusyukanCnt
			If strShokusyukan(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strShokusyukan(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strShokusyukan(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">３．１日の嗜好品摂取量</TD>
					</TR>
<%
	If lngFavoriteCnt > 0 Then
		For i = 1 To lngFavoriteCnt
			If strFavorite(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strFavorite(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strFavorite(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
'### 2004/01/23 Start K.Kagawa 飲酒習慣の追加
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">４．飲酒について</TD>
					</TR>
<%
	If lngDrinkingCnt > 0 Then
		For i = 1 To lngDrinkingCnt
			If strDrinking(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strDrinking(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strDrinking(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
'### 2004/01/23 End
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">５．１日の飲酒量</TD>
					</TR>
<%
	If lngAlcoholCnt > 0 Then
		For i = 1 To lngAlcoholCnt
			If strAlcohol(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strAlcohol(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strAlcohol(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR HEIGHT="20">
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">６．乳製品の１日摂取量</TD>
					</TR>
<%
	If lngDairyCnt > 0 Then
		For i = 1 To lngDairyCnt
			If strDairy(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP WIDTH="281"><%= strDairy(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strDairy(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">７．食事について</TD>
					</TR>
<%
	If lngMealCnt > 0 Then
		For i = 1 To lngMealCnt
			If strMeal(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strMeal(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strMeal(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<SPAN ID="Anchor-FoodMenu" STYLE="position:relative"></SPAN>
	<TABLE WIDTH="21" BORDER="1" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
			<TD NOWRAP WIDTH="200">主食</TD>
			<TD NOWRAP WIDTH="200">主菜</TD>
			<TD NOWRAP WIDTH="200">副菜</TD>
		</TR>
		<TR>
			<TD BGCOLOR="#ffe4b5" ALIGN="center">朝食</TD>
<%
	For j=0 To 2
%>
			<TD NOWRAP VALIGN="top" BGCOLOR="#ffe4b5">
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
<%
		For i = 1 To lngMorningCnt(j)
			If strMorning(0, j, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strMorning(0, j, i) %></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP ALIGN="right" WIDTH="100%"><%= strMorning(1, j, i) %></TD>
					</TR>
<%
			End If
		Next
%>
				</TABLE>
			</TD>
<%
	Next
%>
		</TR>
		<TR>
			<TD BGCOLOR="#f0e68c" ALIGN="center">昼食</TD>
<%
	For j=0 To 2
%>
			<TD NOWRAP VALIGN="top" BGCOLOR="#f0e68c">
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
<%
		For i = 1 To lngLunchCnt(j)
			If strLunch(0, j, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strLunch(0, j, i) %></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP ALIGN="right" WIDTH="100%"><%= strLunch(1, j, i) %></TD>
					</TR>
<%
			End If
		Next
%>
				</TABLE>
			</TD>
<%
	Next
%>
		</TR>
		<TR>
			<TD BGCOLOR="#add8e6" ALIGN="center">夕食</TD>
<%
	For j=0 To 2
%>
			<TD NOWRAP VALIGN="top" BGCOLOR="#add8e6">
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
<%
		For i = 1 To lngDinnerCnt(j)
			If strDinner(0, j, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strDinner(0, j, i) %></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP ALIGN="right" WIDTH="100%"><%= strDinner(1, j, i) %></TD>
					</TR>
<%
			End If
		Next
%>
				</TABLE>
			</TD>
<%
	Next
%>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
