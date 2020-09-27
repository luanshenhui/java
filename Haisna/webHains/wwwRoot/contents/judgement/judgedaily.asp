<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		判定入力(受診者一覧) (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"   -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/EditRslDailyList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用

'前画面から送信されるパラメータ値
Dim lngCslYear			'受診日(年)
Dim lngCslMonth			'受診日(月)
Dim lngCslDay			'受診日(日)
Dim strCsCd				'コースコード
Dim strSortKey			'表示順
Dim strCntlNo			'管理番号
Dim strBadJud			'「判定が悪い人」
Dim strUnFinished		'「判定未完了者」
Dim lngStartPos			'表示開始位置
Dim strGetCount			'取得件数

'受診情報一覧取得時に使用する変数
Dim dtmCslDate			'受診日
Dim lngCntlNo			'管理番号
Dim lngGetCount			'取得件数

'受診情報
Dim strArrRsvNo			'予約番号の配列
Dim strArrDayId			'当日IDの配列
Dim strArrWebColor		'webカラーの配列
Dim strArrCsName		'コース名の配列
Dim strArrPerId			'個人IDの配列
Dim strArrLastName		'姓の配列
Dim strArrFirstName		'名の配列
Dim strArrLastKName		'カナ姓の配列
Dim strArrFirstKName	'カナ名の配列
Dim strArrGender		'性別の配列
Dim strArrBirth			'生年月日の配列
Dim strArrAge			'年齢の配列
Dim strArrOrgSName		'団体略称の配列
Dim strArrCsSName		'コース略称の配列
Dim strArrFilmNo		'フィルム番号の配列
Dim strArrFilmDate		'撮影日の配列
Dim lngCount			'レコード件数

Dim lngCntlNoFlg		'管理番号制御フラグ
Dim strURL				'URL文字列
Dim i					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCsCd       = Request("csCd")
strSortKey    = Request("sortKey")
strCntlNo     = Request("cntlNo")
strBadJud     = Request("badJud")
strUnFinished = Request("unfinished")
lngStartPos   = CLng("0" & Request("startPos"))
strGetCount   = Request("getCount")

'検索開始位置未指定時は先頭から検索する
lngStartPos = IIf(lngStartPos = 0, 1, lngStartPos)

'取得件数未指定時はデフォルト値を取得
strGetCount = IIf(strGetCount = "", EditRslPageMaxLine(), strGetCount)

'管理番号の制御方法を取得
lngCntlNoFlg = CLng("0" & objCommon.SelectCntlFlg)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>判定入力（受診者一覧）</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
// 入力チェック
function checkData() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var ret    = false;					// 関数戻り値

	// 受診日入力チェック
	for ( ; ; ) {

		if ( !isDate( myForm.cslYear.value, myForm.cslMonth.value, myForm.cslDay.value ) ) {
			alert('受診日の形式に誤りがあります。');
			break;
		}

		// 管理番号入力チェック
		if ( myForm.cntlNo.value != '' ) {
			if ( !myForm.cntlNo.value.match('^[0-9]+$') ) {
				alert('管理番号には1～9999の値を入力して下さい。');
				break;
			}
		}

		ret = true;
		break;
	}

	return ret;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.judtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return checkData()">
<BLOCKQUOTE>

<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="judgement">■</SPAN><FONT COLOR="#000000">受診者一覧</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD>受診日：</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
					<TD>日</TD>
					<TD>&nbsp;コース：</TD>
					<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
<%
					'管理番号を使用する場合は入力テキストを表示
					If lngCntlNoFlg = CNTLNO_ENABLED Then
%>
						<TD>管理番号：</TD>
						<TD><INPUT TYPE="text" NAME="cntlNo" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" VALUE="<%= strCntlNo %>"></TD>
<%
					Else
%>
						<INPUT TYPE="hidden" NAME="cntlNo" VALUE="">
<%
					End If
%>
					<TD>表示順：</TD>
					<TD><%= EditSortKeyList("sortKey", strSortKey) %></TD>
					<TD><%= EditRslPageMaxLineList("getCount", strGetCount) %></TD>
					<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="checkbox" NAME="badJud" VALUE="1" <%= IIf(strBadJud <> "","CHECKED", "") %>></TD>
					<TD>判定が悪い人のみ</TD>
					<TD WIDTH="10"></TD>
					<TD><INPUT TYPE="checkbox" NAME="unFinished" VALUE="1" <%= IIf(strUnFinished <> "", "CHECKED", "") %>></TD>
					<TD>判定未完了者のみ</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<%
	'受診者一覧編集
	Do

		'受診日・管理番号の設定
		dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)
		lngCntlNo  = CLng("0" & strCntlNo)

		'取得件数の設定
		lngGetCount = 0
		If IsNumeric(strGetCount) Then
			lngGetCount = CLng(strGetCount)
		End If

		'検索条件を満たすレコード及びレコード件数を取得
		lngCount = objConsult.SelectConsultList(dtmCslDate,              _
												lngCntlNo,               _
												strCsCd, , , ,           _
												lngStartPos,             _
												lngGetCount,             _
												strSortKey, ,            _
												(strBadJud     <> ""),   _
												(strUnFinished <> ""), , _
												strArrRsvNo,             _
												strArrDayId,             _
												strArrWebColor,          _
												strArrCsName,            _
												strArrPerId,             _
												strArrLastName,          _
												strArrFirstName,         _
												strArrLastKName,         _
												strArrFirstKName,        _
												strArrGender,            _
												strArrBirth, ,           _
												strArrAge,               _
												strArrOrgSName, ,        _
												strArrCsSName,           _
												strArrFilmNo,            _
												strArrFilmDate)
%>
		「<FONT COLOR="#ff6600"><B><%= lngCslYear %>年<%= lngCslMonth %>月<%= lngCslDay %>日</B></FONT>」の受診者一覧を表示しています。<BR>
		対象者数は <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>人です。<BR><BR>
<%
		'対象データが存在しない場合は編集を抜ける
		If IsEmpty(strArrRsvNo) Then
			Exit Do
		End If
%>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
	<TR BGCOLOR="#cccccc">
		<TD NOWRAP>当日ＩＤ</TD>
		<TD NOWRAP>受診コース</TD>
		<TD NOWRAP>予約番号</TD>
		<TD NOWRAP>個人ＩＤ</TD>
		<TD NOWRAP>個人氏名</TD>
		<TD NOWRAP>性別</TD>
		<TD NOWRAP>生年月日</TD>
		<TD NOWRAP>年齢</TD>
		<TD NOWRAP>受診団体</TD>
<%
		If Left(strSortKey, 4) = "FILM" Then
%>
			<TD NOWRAP>フィルム番号</TD>
			<TD NOWRAP>撮影日</TD>
<%
		End If
%>
	</TR>
<%
		For i = 0 To UBound(strArrRsvNo)
%>
			<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
				<TD NOWRAP><%= objCommon.FormatString(strArrDayId(i), "0000") %></TD>
				<TD NOWRAP><FONT COLOR="#<%= strArrWebColor(i) %>">■</FONT><%= strArrCsSName(i) %></TD>
				<TD><%= strArrRsvNo(i) %></TD>
				<TD><%= strArrPerId(i) %></TD>
<%
				'判定入力画面のURL編集
				strURL = "judMain.asp"
				strURL = strURL & "?cslYear="    & lngCslYear
				strURL = strURL & "&cslMonth="   & lngCslMonth
				strURL = strURL & "&cslDay="     & lngCslDay
				strURL = strURL & "&cntlNo="     & strCntlNo
				strURL = strURL & "&dayId="      & strArrDayId(i)
				strURL = strURL & "&csCd="       & strCsCd
				strURL = strURL & "&sortKey="    & strSortKey
				strURL = strURL & "&badJud="     & strBadJud
				strURL = strURL & "&unFinished=" & strUnFinished
%>
				<TD NOWRAP><A HREF="<%= strURL %>"><%= Trim(strArrLastName(i) & "　" & strArrFirstName(i)) %><FONT SIZE="-1" COLOR="#666666">（<%= Trim(strArrLastKName(i) & "　" & strArrFirstKName(i)) %>）</FONT></A></TD>
				<TD NOWRAP><%= IIf(strArrGender(i) ="1", "男性", "女性") %></TD>
				<TD NOWRAP><%= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD>
				<TD ALIGN="right" NOWRAP><%= strArrAge(i) %>歳</TD>
				<TD NOWRAP><%= strArrOrgSName(i) %></TD>
<%
				If Left(strSortKey, 4) = "FILM" Then
%>
					<TD NOWRAP><%= strArrFilmNo(i)   %></TD>
					<TD NOWRAP><%= strArrFilmDate(i) %></TD>
<%
				End If
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'取得件数未指定時はページングナビゲータ不用
	If lngGetCount = 0 Then
		Exit Do
	End If

	'URL文字列の編集
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?cslYear="    & lngCslYear
	strURL = strURL & "&cslMonth="   & lngCslMonth
	strURL = strURL & "&cslDay="     & lngCslDay
	strURL = strURL & "&csCd="       & strCsCd
	strURL = strURL & "&sortKey="    & strSortKey
	strURL = strURL & "&cntlNo="     & strCntlNo
	strURL = strURL & "&badJud="     & strBadJud
	strURL = strURL & "&unfinished=" & strUnFinished

	'ページングナビゲータの編集
	Response.Write EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount)

	Exit Do
Loop
%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>