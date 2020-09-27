<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		受診団体の設定 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objOrganization	'団体情報アクセス用
Dim objOrgBsd		'事業部情報アクセス用
Dim objOrgPost		'所属情報アクセス用
Dim objOrgRoom		'室部情報アクセス用
Dim objPerson		'個人情報アクセス用

'引数値
Dim strMode			'処理モード
Dim strPerId		'個人ＩＤ
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strOrgBsdCd		'事業部コード
Dim strOrgRoomCd	'室部コード
Dim strOrgPostCd	'所属コード
Dim strIsrSign		'健保記号
Dim strIsrNo		'健保番号

'所属情報
Dim strOrgName		'団体名称
Dim strOrgSName		'団体略称
Dim strOrgBsdName	'事業部名称
Dim strOrgRoomName	'室部名称
Dim strOrgPostName	'所属名称

Dim strMessage		'メッセージ
Dim strURL			'URL文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strMode      = Request("mode")
strPerId     = Request("perId")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strOrgBsdCd  = Request("orgBsdCd")
strOrgRoomCd = Request("orgRoomCd")
strOrgPostCd = Request("orgPostCd")
strIsrSign   = Request("isrSign")
strIsrNo     = Request("isrNo")

'チェック・更新・読み込み処理の制御
Select Case strMode

	Case "person"	'個人情報からの適用時

		'個人情報読み込み
		objPerson.SelectPerson strPerId, , , , , , , _
							   strOrgCd1, strOrgCd2, , , , _
							   strOrgBsdCd, , , _
							   strOrgRoomCd, , , _
							   strOrgPostCd, , , , , , , , , , _
							   strIsrSign, strIsrNo

	Case "select"	'確定時

		'入力チェック
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'親画面への設定用ASP呼び出し
			strURL = "rsvSelectOrg.asp"
			strURL = strURL & "?orgCd1="    & strOrgCd1
			strURL = strURL & "&orgCd2="    & strOrgCd2
			strURL = strURL & "&orgBsdCd="  & strOrgBsdCd
			strURL = strURL & "&orgRoomCd=" & strOrgRoomCd
			strURL = strURL & "&orgPostCd=" & strOrgPostCd
			strURL = strURL & "&isrSign="   & strIsrSign
			strURL = strURL & "&isrNo="     & strIsrNo
			Response.Redirect strURL
			Response.End

		End If

End Select

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon	'共通クラス
	Dim strMessage	'エラーメッセージの集合

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'団体コードのチェック
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.AppendArray strMessage, "団体を指定して下さい。"
	End If

	'事業部・室部・所属のデフォルト設定
	strOrgBsdCd  = IIf(strOrgBsdCd  = "", "0000000000", strOrgBsdCd )
	strOrgRoomCd = IIf(strOrgRoomCd = "", "0000000000", strOrgRoomCd)
	strOrgPostCd = IIf(strOrgPostCd = "", "0000000000", strOrgPostCd)

	'健保記号・健保番号のチェック
	objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("健保記号", strIsrSign, 4)
	objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("健保番号", strIsrNo,   8)

	'戻り値の編集
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診団体の設定</TITLE>
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd, 'orgPostName' );
	}

}

// submit処理
function submitForm( mode ) {

	// 処理モードを指定してsubmit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setElement()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="javascript:return false">
	<INPUT TYPE="hidden" NAME="mode"      VALUE="">
	<INPUT TYPE="hidden" NAME="perId"     VALUE="<%= strPerId     %>">
	<INPUT TYPE="hidden" NAME="orgCd1"    VALUE="<%= strOrgCd1    %>">
	<INPUT TYPE="hidden" NAME="orgCd2"    VALUE="<%= strOrgCd2    %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"  VALUE="<%= strOrgBsdCd  %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd" VALUE="<%= strOrgRoomCd %>">
	<INPUT TYPE="hidden" NAME="orgPostCd" VALUE="<%= strOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="400">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受診団体の設定</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの表示
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'各種名称の取得
	Do

		'団体コード未指定時は何もしない
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			Exit Do
		End If

		'団体名称の読み込み
		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "団体情報が存在しません。"
		End If

		'事業部コード未指定時は何もしない
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'事業部名称の読み込み
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "事業部情報が存在しません。"
		End If

		'室部コード未指定時は何もしない
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'室部名称の読み込み
		If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName) = False Then
			Err.Raise 1000, , "室部情報が存在しません。"
		End If

		'所属名称の読み込み
		If strOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName) = False Then
				Err.Raise 1000, , "所属情報が存在しません。"
			End If
		End If

		Exit Do
	Loop
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
		<TR>
			<TD NOWRAP>事業部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
		</TR>
		<TR>
			<TD>室部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
		<TR>
			<TD>所属</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgPostName"><%= strOrgPostName %></SPAN></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP>健保記号</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="isrSign" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" VALUE="<%= strIsrSign %>"></TD>
		<TR>
			<TD NOWRAP>健保番号</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="isrNo" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strIsrNo %>"></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'個人決定時はアンカーを用意する
	If strPerId <> "" Then
%>
		&nbsp;<A HREF="javascript:submitForm('person')">現在の個人情報から適用</A><BR><BR>
<%
	End If
%>
	<BR>

	<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
	<A HREF="javascript:submitForm('select')"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この内容で確定する"></A>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
