<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		２次健診の選択(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objAfterCare		'アフターケア情報
Dim objPerson			'個人情報用
Dim objFree				'汎用情報用

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim strPerId			'個人ＩＤ

'受診日取得（アフターケア）
Dim strSecondCslDate	'受診日
Dim strRsvNo			'予約番号

'個人情報
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

Dim strDispPerName		'個人名称（漢字）
Dim strDispPerKName		'個人名称（カナ）
Dim strDispAge			'年齢（表示用）
Dim strDispBirth		'生年月日（表示用）

Dim lngSecondCslDate	'受診日レコードカウント
Dim i					'ループカウント

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objPerson    = Server.CreateObject("HainsPerson.Person")

strPerId = Request("perId")

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
Set objFree = Server.CreateObject("HainsFree.Free")
strDispAge = objFree.CalcAge(strBirth, Date, "")
Set objFree = Nothing

'和暦編集
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'性別
strGender = IIf(strGender = CStr(GENDER_MALE), "男性", "女性")

'表示内容の編集
strDispBirth = strDispBirth & "生　" & strDispAge & "歳　" & strGender

'オブジェクトのインスタンスの解放
Set objPerson = Nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>２次健診の選択</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function goNextPage() {

	var objForm = document.entryForm;	// 自画面のフォームエレメント
	var contactDate, secRsvNo;			// ２次健診受診日とその予約番号
	var url;							// URL文字列

	if ( objForm.cslDate.length != null ) {
		for ( var i = 0; i < objForm.cslDate.length; i++ ) {
			if ( objForm.cslDate[ i ].checked ) {
				contactDate = objForm.cslDate[ i ].value;
				secRsvNo    = objForm.rsvNo[ i ].value;
				break;
			}
		}
	} else {
		contactDate = objForm.cslDate.value;
		secRsvNo    = objForm.rsvNo.value;
	}

	url = '/webHains/contents/aftercare/AfterCareInterview.asp';
	url = url + '?disp='        + '0';
	url = url + '&perId='       + '<%= strPerId %>';
	url = url + '&contactDate=' + contactDate;
	url = url + '&rsvNo='       + secRsvNo;
	location.href = url;

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">２次健診の選択</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>0010005</TD>
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
<%
	Do

		'２次受診日の取得
		Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")
		lngSecondCslDate = objAfterCare.SelectSecondCslDate(strPerId, strSecondCslDate, strRsvNo)
		If lngSecondCslDate <= 0 Then
%>
			<SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:12px;">事後措置入力対象となる２次健診が存在しません。</SPAN><BR><BR>
<%
			Exit Do
		End If
%>
		<FONT COLOR="#cc9999">●</FONT>事後管理指導を行う２次健診の受診日を選択して下さい。<BR><BR>

		<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
<%
			For i = 0 to lngSecondCslDate - 1
%>
				<TR>
					<TD><INPUT TYPE="radio" NAME="cslDate" VALUE="<%= strSecondCslDate(i) %>"<%= IIf(i = 0, " CHECKED", "") %>><INPUT TYPE="hidden" NAME="rsvNo" VALUE="<%= strRsvNo(i) %>"></TD>
					<TD NOWRAP><%= objCommon.FormatString(strSecondCslDate(i), "yyyy年mm月dd日") %></TD>
				</TR>
<%
			Next
%>
		</TABLE>

		<BR>
<%
		Exit Do
	Loop
%>
	<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
<%
	If lngSecondCslDate > 0 Then
%>
		<A HREF="JavaScript:goNextPage()"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ"></A>
<%
	End If
%>
	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>

