<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		事後措置区分の選択(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editButtonCol.inc"  -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objPerson			'個人情報用
Dim objFree				'汎用情報用

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------

'個人情報
Dim strPerId			'個人ＩＤ
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strGender			'性別
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード2
Dim strOrgKName			'団体カナ名称
Dim strOrgName			'団体漢字名称
Dim strOrgSName			'団体略称
Dim strOrgBsdCd			'事業所コード
Dim strOrgBsdKName		'事業部カナ名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomCd		'室部コード
Dim strOrgRoomName		'室部名称
Dim strOrgRoomKName		'室部カナ名称
Dim strOrgPostCd		'所属部署コード
Dim strOrgPostName		'所属名称
Dim strOrgPostKName		'所属カナ名称
Dim strJobName			'職名
Dim strEmpNo			'従業員番号

Dim strToday			'本日日付（システム日付）
Dim strDispPerName		'個人名称（漢字）
Dim strDispPerKName		'個人名称（カナ）
Dim strDispAge			'年齢（表示用）
Dim strDispBirth		'生年月日（表示用）

Dim strArrSochiDiv
strArrSochiDiv = Array("事後管理指導 （２次検査指導）","保健指導 （訪問指導）")

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")

strPerId			= Request("perId")

'個人情報の検索
If( strPerId <> "" ) Then
	'オブジェクトのインスタンス作成
	Set objPerson 	= Server.CreateObject("HainsPerson.Person")
	Set objFree		= Server.CreateObject("HainsFree.Free")

	'個人情報読み込み
	objPerson.SelectPerson strPerId,     strLastName,    strFirstName,    _
						   strLastKName, strFirstKName,  strBirth,        _
						   strGender,    strOrgCd1,      strOrgCd2,       _
						   strOrgKName,  strOrgName,     strOrgSName,     _
						   strOrgBsdCd,  strOrgBsdKName, strOrgBsdName,   _
						   strOrgRoomCd, strOrgRoomName, strOrgRoomKName, _
						   strOrgPostCd, strOrgPostName, strOrgPostKName, _
						   , strJobName, , , , , _
						   strEmpNo, Empty, Empty

	'表示用名称の編集
	strDispPerName 	= Trim(strLastName & "　" & strFirstName)
	strDispPerKName = Trim(strLastKName & "　" & strFirstKName)

	'年齢の算出
	strToday = Year(now) & "/" & Month(now) & "/" & Day(now)
	strDispAge = objFree.CalcAge( strBirth , strToday , "" )

	'和暦編集
	strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

	'性別
	strGender = IIf(strGender = CStr(GENDER_MALE), "男性", "女性")

	'表示内容の編集
	strDispBirth = strDispBirth & "生　" & strDispAge & "歳　" & strGender

	'オブジェクトのインスタンスの開放
	Set objPerson = Nothing

End If


%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>事後措置区分の選択</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function goNextPage() {

	if ( document.entryForm.sochiDiv[0].checked ) {
		location.href = 'SecondCslList.asp?perId=' + '<%= strPerId %>' ;
	}

	if ( document.entryForm.sochiDiv[1].checked ) {
		location.href = 'AfterCareEntryDate.asp?perId=' + '<%= strPerId %>' ;
	}

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">事後措置区分の選択</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP><%= strEmpNo %></TD>
			<TD NOWRAP><B><%= strDispPerName %></B> (<FONT SIZE="-1"><%= strDispPerKName %></FONT>)</TD>
		<TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= strDispBirth %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" NOWRAP>団体：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP><%= strOrgName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;所属：</TD>
						<TD NOWRAP><%= strOrgPostName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;職種：</TD>
						<TD NOWRAP><%= strJobName %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">●</FONT>事後措置区分を選択して下さい。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD NOWRAP>事後措置区分：</TD>
			<TD><INPUT TYPE="radio" NAME="sochiDiv" VALUE="0" CHECKED></TD>
			<TD NOWRAP><%= strArrSochiDiv(0) %></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD><INPUT TYPE="radio" NAME="sochiDiv" VALUE="1"></TD>
			<TD NOWRAP><%= strArrSochiDiv(1) %></TD>
		</TR>
	</TABLE>

	<BR>

	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
	<A HREF="javascript:goNextPage()"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ"></A>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>

