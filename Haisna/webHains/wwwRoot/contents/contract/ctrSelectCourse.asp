<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(契約コースの選択) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const ACTMODE_BROWSE = "browse"	'動作モード(参照)
Const OPMODE_BROWSE  = "browse"	'処理モード(複写)
Const OPMODE_COPY    = "copy"	'処理モード(コピー)

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objOrganization	'団体情報アクセス用

'前画面から送信されるパラメータ値
Dim strActMode		'動作モード(参照:"browse")
Dim strOrgCd1		'団体コード1
Dim strOrgCd2		'団体コード2

'固定団体コード
Dim strPerOrgCd1	'個人受診用団体コード1
Dim strPerOrgCd2	'個人受診用団体コード2
Dim strWebOrgCd1	'Web用団体コード1
Dim strWebOrgCd2	'Web用団体コード2

Dim strOrgName		'団体名
Dim strTitle		'表題
Dim lngMargin		'マージン値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'セッション・権限チェック
If Request("actMode") = ACTMODE_BROWSE Then
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)
End If

'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strActMode = Request("actMode")
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")

'表題・マージン値の設定
strTitle  = IIf(strActMode = ACTMODE_BROWSE, "契約情報の参照・コピー", "契約コースの選択")
lngMargin = IIf(strActMode = ACTMODE_BROWSE, 0, 20)

'個人受診、web用団体コードの取得
objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strTitle %></TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function goNextPage(myForm) {

	var url;

	// コース未選択時は何もしない
	if ( myForm.csCd.value == '' ) {
		return false;
	}

	// 処理方法が編集されていない、即ち新規契約情報作成時はここで処理終了
	if ( myForm.opMode == null ) {
		return;
	}

	// 処理方法が参照の場合、契約期間設定は不要のため、遷移先を変更
	if ( myForm.opMode[0].checked ) {
<%
		'web予約の場合は直接契約情報の選択画面に遷移
		If strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2 Then
%>
			url = 'ctrBrowseContract.asp';
			url = url + '?opMode=<%= OPMODE_BROWSE %>';
			url = url + '&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>';
			url = url + '&csCd=' + myForm.csCd.value;
			url = url + '&refOrgCd1=<%= strPerOrgCd1 %>&refOrgCd2=<%= strPerOrgCd1 %>';
			location.href = url;
			return false;
<%
		Else
%>
			myForm.action = 'ctrBrowseOrg.asp';
<%
		End If
%>
	}

	return true;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: <%= lngMargin %>px 0 0 0; }
	td.mnttab { background-color:#ffffff }
</style>
</HEAD>
<BODY>
<%
'契約情報の参照・コピーを行う場合はナビを編集
If strActMode = ACTMODE_BROWSE Then
%>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<%
End If
%>
<FORM NAME="entryForm" ACTION="ctrPeriod.asp" METHOD="get" ONSUBMIT="JavaScript:return goNextPage(this)">
	<BLOCKQUOTE>
<%
	'契約情報の参照・コピーを行う場合は動作モードの値を保持
	If strActMode = ACTMODE_BROWSE Then
%>
		<INPUT TYPE="hidden" NAME="actMode" VALUE="<%= strActMode %>">
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2 %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000"><%= strTitle %></FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'団体名の読み込み
	If objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If
%>
	契約団体：<B><%= strOrgName %></B><BR><BR>
<%
	'契約情報の参照・コピーを行う場合は選択肢を編集する
	If strActMode = ACTMODE_BROWSE Then
%>
		<FONT COLOR="#cc9999">●</FONT>参照、またはコピーのいずれかの処理方法を選択して下さい。

		<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR VALIGN="top">
				<TD><INPUT TYPE="radio" NAME="opMode" VALUE="<%= OPMODE_BROWSE %>" CHECKED></TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>契約情報を参照する</TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>・・・・・</TD>
				<TD>
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>
					<FONT COLOR="#666666">参照する契約情報を所有する契約団体と、契約期間・受診項目・負担情報の全ての契約内容を共有します。<BR>
					参照先の契約内容が修正されると、その内容が自契約情報に反映されます。</FONT>
				</TD>
			</TR>
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
			<TR VALIGN="top">
				<TD><INPUT TYPE="radio" NAME="opMode" VALUE="<%= OPMODE_COPY %>"></TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>契約情報をコピーする</TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>・・・・・</TD>
				<TD>
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>
					<FONT COLOR="#666666">コピー対象となる契約情報から受診項目・負担情報の内容をコピーし、そのまま自団体の新しい契約情報として保存します。<BR>
					コピーした契約内容を適用する契約期間についてはここで指定します。</FONT>
				</TD>
			</TR>
		</TABLE>

		<BR><BR>

		<FONT COLOR="#cc9999">●</FONT>契約情報の参照、またはコピーを行うコースを選択して下さい。
<%
	'新規契約情報を作成する場合はメッセージのみを編集する
	Else
%>
		<FONT COLOR="#cc9999">●</FONT>新しい契約情報を作成するコースを選択して下さい。
<%
	End If
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>対象コース</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", Empty, NON_SELECTED_ADD, False) %></TD>
	</TABLE>

	<BR>
<%
	'契約情報の参照・コピーを行う場合は「戻る」ボタンを配置
	If strActMode = ACTMODE_BROWSE Then
%>
		<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
<%
	'新規契約情報を作成する場合は「キャンセル」ボタンを配置
	Else
%>
		<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
<%
	End If
%>
	<INPUT TYPE="image" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
