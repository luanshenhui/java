<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		結果時系列表示 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditGrpList.inc"      -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"   -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const CODEALL      = "all"	'全検査項目
Const CODETYPE_JUD = "1"	'判定分類
Const CODETYPE_GRP = "2"	'グループ

'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用COMオブジェクト
Dim objResult		'検査結果アクセス用COMオブジェクト
Dim objJudClass		'判定分類アクセス用COMオブジェクト
Dim objGrp			'グループアクセス用COMオブジェクト
'## 2002.6.5 Add 2Lines by T.Takagi 個人情報見出し表示
Dim objPerson		'個人情報アクセス用COMオブジェクト
Dim objCommon		'共通クラス
'## 2002.6.5 Add End

Dim strRsvNo		'予約番号
Dim strPerId		'個人ＩＤ
Dim lngYear			'表示開始日(年)
Dim lngMonth		'表示開始日(月)
Dim lngDay			'表示開始日(日)
Dim strCode			'対象コード
Dim strGrpCd		'グループコード
Dim strJudClassCd	'判定分類コード
Dim strAllResult	'全検査項目表示
Dim strCodeType		'対象コードタイプ (1:判定分類, 2:グループコード)
Dim strSecondFlg	'２次検査対象フラグ
Dim strGender		'性別

Dim lngSecondFlg	'２次検査対象フラグ(COM用)

Dim strCslDate		'受診日
Dim strDayId		'当日ＩＤ

'## 2002.6.5 Add 8Lines by T.Takagi 個人情報見出し表示
'個人情報
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓	
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strPerGender	'性別
Dim strGenderName	'性別名称
'## 2002.6.5 Add End

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strRsvNo      = Request("rsvNo")
strPerId      = Request("perID")
strCode       = Request("code")
strGrpCd      = Request("grpCd")
strJudClassCd = Request("judClassCd")
strAllResult  = Request("allResult")
lngYear       = Request("year")
lngMonth      = Request("month")
lngDay        = Request("day")
strSecondFlg  = Request("secondFlg")
strGender     = Request("gender")

'２次検査対象フラグの省略時設定
lngSecondFlg  = IIf(IsEmpty(strSecondFlg) <> "", CLng("0" & strSecondFlg), RSLSECOND_ALL)

'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")
'## 2002.6.5 Add 2Lines by T.Takagi 個人情報見出し表示
Set objPerson  = Server.CreateObject("HainsPerson.Person")
Set objCommon  = Server.CreateObject("HainsCommon.Common")
'## 2002.6.5 Add End

Do
	'表示開始日初期値設定
	If lngYear = "" And lngMonth = "" And lngDay ="" Then

		lngYear  = CLng(Year(Now))
		lngMonth = CLng(Month(Now))
		lngDay   = CLng(Day(Now))

		'予約番号渡しのときは個人ID、受診日、受診日前日情報取得
		If strRsvNo <> "" Then
			Call objConsult.SelectHistoryRsvNo(strRsvNo, strPerId, strCslDate, lngYear, lngMonth, lngDay)
		End If

		'でも当日から見せるので編集しなおし
		lngYear  = CLng(Year(Now))
		lngMonth = CLng(Month(Now))
		lngDay   = CLng(Day(Now))

	Else

		lngYear  = CLng("0" & lngYear)
		lngMonth = CLng("0" & lngMonth)
		lngDay   = CLng("0" & lngDay)

	End If

	'対象コード判断
	If strJudClassCd <>"" Then
		strCodeType = CODETYPE_JUD
	Else
		strCodeType = CODETYPE_GRP
	End If

	If Not IsEmpty(strCode) Then
		Exit Do
	End If

	'判定分類コード
	If strJudClassCd <>"" Then
		strCode = strJudClassCd
		Exit Do
	End If

	'グループコード
	If strGrpCd <> "" Then
		strCode = strGrpCd
		Exit Do
	End If

	'全検査項目
	If strAllResult = "1" Then
		strCode = CODEALL
		Exit Do
	End If

	strCode = ""

	Exit Do
Loop
'-----------------------------------------------------------------------------
' 受診歴情報の編集
'-----------------------------------------------------------------------------
Function EditResultList(strPerId, lngSelYear, lngSelMonth, lngSelDay, strGrpCd)

	Dim objCommon			'共通クラス

	Dim strSelCslDate		'検索受診日

	Dim strArrCslDate		'受診日
	Dim strArrCsCd			'コースコード
	Dim strArrCsName		'コース名
	Dim strArrRsvNo			'予約番号
	Dim strArrAge			'受診時年齢

	Dim strArrItemCd()		'検査項目コード
	Dim strArrSuffix()		'サフィックス
	Dim strArrItemName()	'検査項目名
	Dim strArrResult()		'検査結果
	Dim strArrColor()		'基準値コード
	Dim strResult()			'
	Dim strColor()			'

	Dim lngHistoryCount		'表示歴数
	Dim lngConsultCount		'受診歴数
	Dim lngCount			'レコード数

	Dim strHTML				'HTML文字列

	Dim i					'インデックス
	Dim j					'インデックス

	strSelCslDate = lngSelYear & "/" & lngSelMonth & "/" & lngSelDay
	
	'妥当な日付でない場合、何もしない
	If Not IsDate(strSelCslDate) Then
		EditResultList = "<BR>・日付に誤りがあります。<BR><BR>"
		Exit Function
	End If

	Do

		'オブジェクトのインスタンス作成
		Set objCommon  = Server.CreateObject("HainsCommon.Common")

		'表示歴数取得
		lngHistoryCount = objCommon.SelectHistoryCount

		lngConsultCount = objConsult.SelectConsultHistory(strPerId, _
														  strSelCslDate, _
														  True, _
														  (lngSecondFlg = RSLSECOND_NONE), _
														  lngHistoryCount, _
														  strArrRsvNo, _
														  strArrCslDate, _
														  strArrCsCd, _
														  strArrCsName, _
														  strArrAge)

		If lngConsultCount = 0 Then
			EditResultList = "<BR>・" & strSelCslDate & "以前の受診歴は存在しません。<BR><BR>"
			Exit Do
		End If
%>
		<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="2">
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP ROWSPAN="2">&nbsp;</TD>
<%
				For i = 0 To lngConsultCount - 1
%>
					<TD ALIGN="right">
						<A HREF="/webHains/contents/inquiry/inqReport.asp?rsvNo=<%= strArrRsvNo(i) %>" TARGET="_top"><%= strArrCslDate(i) %></A>
					</TD>
<%
				Next
%>
			</TR>
			<TR>
<%
				For i = 0 To lngConsultCount - 1
%>
					<TD ALIGN="right" BGCOLOR="#eeeeee"><%= strArrCsName(i) %></TD>
<%
				Next
%>
			</TR>
<%
			'検査項目取得
			If strCodeType = CODETYPE_JUD Then

				'オブジェクトのインスタンス作成
				Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")

				'判定分類別検査項目コード取得
				lngCount = objJudClass.SelectJudClassItemList(strCode, strArrItemCd, strArrSuffix, strArrItemName)

				'オブジェクトのインスタンス削除
				Set objJudClass = Nothing

			Else

				If strCode = CODEALL Then

					'オブジェクトのインスタンス作成
					Set objResult = Server.CreateObject("HainsResult.Result")

					'全検査項目取得
					lngCount = objResult.SelectHistoryAllItemList(strPerId, strSelCslDate, strArrItemCd, strArrSuffix, strArrItemName)

					'オブジェクトのインスタンス削除
					Set objResult = Nothing

				Else

					'オブジェクトのインスタンス作成
					Set objGrp = Server.CreateObject("HainsGrp.Grp")

					'検査グループ内全検査項目取得
					lngCount = objGrp.SelectGrp_I_ItemList(strCode, strArrItemCd, strArrSuffix, strArrItemName)

					'オブジェクトのインスタンス作成
					Set objGrp = Nothing

				End If

			End If

			'オブジェクトのインスタンス作成
			Set objResult = Server.CreateObject("HainsResult.Result")

			'検査結果情報取得
			If lngCount > 0 Then
				ReDim strArrResult(UBound(strArrRsvNo), UBound(strArrItemCd))
				ReDim strArrColor(UBound(strArrRsvNo), UBound(strArrItemCd))
				For i = 0 To UBound(strArrRsvNo)
					objResult.SelectHistoryItemResultList strArrRsvNo(i), strArrItemCd, strArrSuffix, strResult, strColor
					For j = 0 To UBound(strResult)
						strArrResult(i, j) = strResult(j)
						strArrColor(i, j) = strColor(j)
					Next
				Next
			End If

			'オブジェクトのインスタンス削除
			Set objResult = Nothing

			For i = 0 To lngCount - 1
%>
				<TR>
					<TD BGCOLOR="#eeeeee" NOWRAP><%= strArrItemName(i) %></TD>
<%
					For j = 0 To UBound(strArrRsvNo)

						'関数の編集
						strHTML = "callDtlGuide("
						strHTML = strHTML & "'" & strArrItemCd(i)         & "',"
						strHTML = strHTML & "'" & strArrSuffix(i)         & "',"
						strHTML = strHTML & "'" & strArrCsCd(j)           & "',"
						strHTML = strHTML & "'" & Year(strArrCslDate(j))  & "',"
						strHTML = strHTML & "'" & Month(strArrCslDate(j)) & "',"
						strHTML = strHTML & "'" & Day(strArrCslDate(j))   & "',"
						strHTML = strHTML & "'" & strArrAge(j)            & "',"
						strHTML = strHTML & "'" & strGender               & "')"

						If strArrResult(j, i) = "" Then
							strArrResult(j, i) = "&nbsp;"
						End If
%>
						<TD ALIGN="right"><A HREF="javascript:<%= strHTML %>"><FONT COLOR="<%= IIf(strArrColor(j, i) <> "", strArrColor(j, i), "#000000") %>"><%= strArrResult(j, i) %></FONT></A></TD>
<%
					Next
%>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do

	Loop
	
	'オブジェクトのインスタンス削除
	Set objConsult  = Nothing
	Set objResult   = Nothing
	Set objGrp	  = Nothing
	Set objJudClass = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>前回値表示</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/dtlGuide.inc" -->
<!--
// 検査項目説明呼び出し
function callDtlGuide(itemCd, suffix, csCd, cslYear, cslMonth, cslDay, age, gender) {

	// 説明画面の連絡域に画面入力値を設定する
	dtlGuide_ItemCd       = itemCd;
	dtlGuide_Suffix       = suffix;
	dtlGuide_CsCd         = csCd;
	dtlGuide_CslDateYear  = cslYear;
	dtlGuide_CslDateMonth = cslMonth;
	dtlGuide_CslDateDay   = cslDay;
	dtlGuide_Age          = age;
	dtlGuide_Gender       = gender;

	// 検査項目説明表示
	showGuideDtl();
}

// 時系列画面を表示
function showHistory() {

	var myForm = document.rethistory;	// 自画面のフォームエレメント
	var url;							// URL文字列

	// 時系列表示のURL編集
	url = '<%= Request.ServerVariables("SCRIPT_NAME") %>';
	url = url + '?rsvNo='      + myForm.rsvno.value;
	url = url + '&perid='      + myForm.perid.value;
	url = url + '&judClassCd=' + myForm.judClassCd.value;
	url = url + '&grpCd='      + myForm.grpCd.value;
	url = url + '&allResult='  + myForm.allResult.value;
	url = url + '&secondFlg='  + myForm.secondFlg.value;
	url = url + '&year='       + myForm.year.value;
	url = url + '&month='      + myForm.month.value;
	url = url + '&day='        + myForm.day.value;
	url = url + '&code='       + myForm.code.value;

	// 時系列画面を表示
	location.replace(url);
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff" ONUNLOAD="javascript:closeGuideDtl()">

<FORM NAME="rethistory" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<INPUT TYPE="hidden" NAME="rsvno"      VALUE="<%= strRsvNo      %>">
	<INPUT TYPE="hidden" NAME="perid"      VALUE="<%= strPerId      %>">
	<INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= strJudClassCd %>">
	<INPUT TYPE="hidden" NAME="grpCd"      VALUE="<%= strGrpCd      %>">
	<INPUT TYPE="hidden" NAME="allResult"  VALUE="<%= strAllResult  %>">
	<INPUT TYPE="hidden" NAME="secondFlg"  VALUE="<%= lngSecondFlg  %>">
	<INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender     %>">

	<!-- ウインドウ説明見出し -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#000000">検査結果（時系列）</FONT></B></TD>
		</TR>
	</TABLE>
<%
'## 2002.6.5 Add 19Lines by T.Takagi 個人情報見出し表示
	'個人情報読み込み
	objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strPerGender, strGenderName
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><%= strPerID %></TD>
			<TD NOWRAP><B><%= strLastName %>　<%= strFirstName %></B><FONT SIZE="-1">（<%= strLastKName %>　<%= strFirstKName %>）</FONT></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>生　<%= strGenderName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>
<%
'## 2002.6.5 Add End
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		<TR>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("month", 1, 12, lngMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("day", 1, 31, lngDay, False) %></TD>
			<TD>日以前の</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
<%
			If strCodeType = CODETYPE_JUD Then
%>
				<TD><%= EditJudClassList("code", strCode, NON_SELECTED_ADD) %></TD>
<%
			Else
%>
				<TD><%= EditGrpIList_GrpDiv("code", strCode, CODEALL, "全ての検査項目", ADD_FIRST) %></TD>
<%
			End If
%>
			<TD>を</TD>
			<TD><A HREF="javascript:showHistory()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></A></TD>
		</TR>
	</TABLE>
<%
	If strCode <> "" Then
%>
		<%= EditResultList(strPerId, lngYear, lngMonth, lngDay, strCode) %>
<%
	End If
%>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
