<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		所属の割り当て (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objOrganization		'団体情報アクセス用
Dim objOrgBsd			'事業部情報アクセス用
Dim objOrgPost			'所属情報アクセス用
Dim objOrgRoom			'室部情報アクセス用

'引数値
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgWkPostCd		'労基署所属コード
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strStrOrgPostCd		'開始所属コード
Dim strEndOrgPostCd		'終了所属コード
Dim strOrgWkPostSeq		'労基署所属ＳＥＱ

'所属情報
Dim strOrgName			'団体名称
Dim strOrgWkPostName	'労基署所属名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomName		'室部名称
Dim strStrOrgPostName	'開始所属名称
Dim strEndOrgPostName	'終了所属名称

Dim strMessage			'メッセージ
Dim strHTML				'HTML文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'引数値の取得
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgWkPostCd  = Request("orgWkPostCd")
strOrgBsdCd     = Request("orgBsdCd")
strOrgRoomCd    = Request("orgRoomCd")
strStrOrgPostCd = Request("strOrgPostCd")
strEndOrgPostCd = Request("endOrgPostCd")
strOrgWkPostSeq = Request("orgWkPostSeq")

'チェック・更新・読み込み処理の制御
Do

	'確定ボタン押下時以外は何もしない
	If Request("save.x") = "" Then
		Exit Do
	End If

	'入力チェック
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'所属テーブルレコードの更新
	objOrgPost.UpdateOrgPost_OrgWkPostSeq strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strOrgWkPostSeq

	'エラーがなければ呼び元画面をリロードして自身を閉じる
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

	Exit Do
Loop

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

	'事業部コードのチェック
	If strOrgBsdCd = "" Then
		objCommon.AppendArray strMessage, "事業部を指定して下さい。"
	End If

	'室部コードのチェック
	If strOrgRoomCd = "" Then
		objCommon.AppendArray strMessage, "室部を指定して下さい。"
	End If

	'戻り値の編集
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受診団体の設定</TITLE>
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setElement()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="javascript:return confirm('この内容で所属の割り当てを行いますか？')">

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgWkPostCd"  VALUE="<%= strOrgWkPostCd  %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="95%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">所属の割り当て</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの表示
	EditMessage strMessage, MESSAGETYPE_WARNING
%>
	<BR>
<%
	'団体名称の読み込み
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName

	'労基署所属名称の読み込み
	objOrgPost.SelectOrgWkPost strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName, strOrgWkPostSeq
%>
	<INPUT TYPE="hidden" NAME="orgWkPostSeq" VALUE="<%= strOrgWkPostSeq %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>団体</TD>
			<TD>：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strOrgName %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP>労基署所属</TD>
			<TD>：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strOrgWkPostName %></B></FONT></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'各種名称の取得
	Do

		'事業部コード未指定時は何もしない
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'事業部名称の読み込み
		Set objOrgBsd = Server.CreateObject("HainsOrgBsd.OrgBsd")
		objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName

		'室部コード未指定時は何もしない
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'室部名称の読み込み
		Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
		objOrgRoom.SelectOrgRoom strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName

		'開始所属名称の読み込み
		If strStrOrgPostCd <> "" Then
			objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strStrOrgPostName
		End If

		'終了所属名称の読み込み
		If strEndOrgPostCd <> "" Then
			objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strEndOrgPostCd, strEndOrgPostName
		End If

		Exit Do
	Loop
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="60" NOWRAP>事業部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD>室部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="60" NOWRAP>所属</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="strOrgPostName"><%= strStrOrgPostName %></SPAN></TD>
			<TD>～</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="endOrgPostName"><%= strEndOrgPostName %></SPAN></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
	<INPUT TYPE="image" NAME="save" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この内容で確定する">

</FORM>
</BODY>
</HTML>
