<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約パターン検索ガイド (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objContract		'契約情報アクセス用
Dim objOrganization	'団体情報アクセス用

'引数値
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCsCd				'コースコード
Dim strShowAllPattern	'全パターンを表示するか

Dim dtmStrDate		'契約開始日
Dim dtmEndDate		'契約終了日

'契約管理情報
Dim strWebColor		'webカラー
Dim strArrCsCd		'コースコード
Dim strCsName		'コース名
Dim strCtrPtCd		'契約パターンコード
Dim strStrDate		'契約開始日
Dim strEndDate		'契約終了日
Dim lngCount		'レコード数

Dim strOrgName		'団体漢字名称
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objContract     = Server.CreateObject("HainsContract.Contract")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strCsCd           = Request("csCd")
strShowAllPattern = Request("showAllPattern")

If strShowAllPattern = "" Then

	'システム日付より契約終了日の最大値までを検索条件とするための設定
	dtmStrDate = Date()

Else

	'全パターンを検索条件とするための設定
	dtmStrDate = CDate("1970/1/1")

End If

dtmEndDate = CDate("2200/12/31")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>契約情報の検索</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName', null, null, null, null, null, '0' );

}

// 契約パターン選択時の処理
function selectPattern( index ) {

	var selCtrPtCd;	// 契約パターンコード
	var selCsName;	// コース名
	var selStrDate;	// 契約開始日
	var selEndDate;	// 契約終了日

	// 呼び元ウィンドウが存在しない場合は画面を閉じる
	if ( !opener ) {
		close();
		return;
	}

	// 選択された契約パターンの取得
	with ( document.patternList ) {

		if ( ctrPtCd.length ) {
			selCtrPtCd = ctrPtCd[ index ].value;
			selCsName  = csName[ index ].value;
			selStrDate = strDate[ index ].value;
			selEndDate = endDate[ index ].value;
		} else {
			selCtrPtCd = ctrPtCd.value;
			selCsName  = csName.value;
			selStrDate = strDate.value;
			selEndDate = endDate.value;
		}

		// 親画面の契約パターン編集関数呼び出し
		opener.ptnGuide_setPatternInfo( selCtrPtCd, selCsName, selStrDate, selEndDate, orgCd1.value, orgCd2.value, orgName.value );

	}

	// 画面を閉じる
	opener.ptnGuide_closeGuidePattern();

}

// submit時の処理
function submitForm() {

	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:orgGuide_closeGuideOrg()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="orgCd1"         VALUE="<%= strOrgCd1         %>">
	<INPUT TYPE="hidden" NAME="orgCd2"         VALUE="<%= strOrgCd2         %>">
	<INPUT TYPE="hidden" NAME="showAllPattern" VALUE="<%= strShowAllPattern %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">契約情報の検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>団体</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
<%
						'団体名の読み込み
						If strOrgCd1 <> "" And strOrgCd2 <> "" Then
							objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName
						End If
%>
						<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>受診コース</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
						<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<FORM NAME="patternList" action="#">

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="orgName" VALUE="<%= strOrgName %>">
<%
	Do

		'検索条件が指定されていない場合は何もしない
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			Exit Do
		End If

		'契約管理情報読み込み
		lngCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, strCsCd, dtmStrdate, dtmEndDate, strWebColor, strArrCsCd, strCsName, , , , , strCtrPtCd, strStrDate, strEndDate)
		If lngCount <= 0 Then
%>
			検索条件を満たす契約情報は存在しません。
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>受診コース</TD>
				<TD WIDTH="10"></TD>
				<TD COLSPAN="7" NOWRAP>契約期間</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="10"></TD>
			</TR>
			<TR>
				<TD HEIGHT="2"></TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD>
						<INPUT TYPE="hidden" NAME="csCd"    VALUE="<%= strArrCsCd(i) %>">
						<INPUT TYPE="hidden" NAME="csName"  VALUE="<%= strCsName(i)  %>">
						<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd(i) %>">
						<INPUT TYPE="hidden" NAME="strDate" VALUE="<%= objCommon.FormatString(strStrDate(i), "yyyy年m月d日") %>">
						<INPUT TYPE="hidden" NAME="endDate" VALUE="<%= objCommon.FormatString(strEndDate(i), "yyyy年m月d日") %>">
					</TD>
					<TD NOWRAP><FONT COLOR="#<%= strWebColor(i) %>">■</FONT><A HREF="javascript:selectPattern(<%= i %>)"><%= strCsName(i) %></A></TD>
					<TD></TD>
					<TD NOWRAP><%= Year(strStrDate(i)) %>年</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strStrDate(i)) %>月</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strStrDate(i))   %>日</TD>
					<TD>～</TD>
					<TD NOWRAP><%= Year(strEndDate(i)) %>年</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strEndDate(i)) %>月</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strEndDate(i))   %>日</TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
