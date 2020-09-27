<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		受診予定表(仮称) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objSchedule		'スケジュール情報取得用

Dim dtmCslDate		'受診日
Dim lngMode			'表示モード

Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim strWebColor		'webカラー
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strOrgName		'団体名
Dim strCslCount		'受診者数
Dim lngCount		'レコード数

Dim strPrevCsCd		'直前レコードのコースコード
Dim strPrevOrgCd1	'直前レコードの団体コード1
Dim strPrevOrgCd2	'直前レコードの団体コード2
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'引数値の取得
dtmCslDate = CDate(Request("cslDate"))
lngMode    = CLng("0" & Request("mode"))

lngMode = IIf(lngMode = 0, 2, lngMode)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受診予定</TITLE>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受診予定</FONT></B></TD>
	</TR>
</TABLE>

<BR>

受診日：<B><%= dtmCslDate %></B><BR>
<BR>
<%
If lngMode = 2 Then
%>
	<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?cslDate=<%= dtmCslDate%>&mode=3">団体別に表示</A><BR>
<%
Else
%>
	<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?cslDate=<%= dtmCslDate%>&mode=2">コース別に表示</A><BR>
<%
End If
%>
<BR>
<%
Do
	'受診予定を読み込む
	lngCount = objSchedule.SelectConsultSchedule(lngMode, dtmCslDate, strCsCd, strCsName, strWebColor, strOrgCd1, strOrgCd2, strOrgName, strCslCount)
	If lngCount = 0 Then
		Exit Do
	End If

	If lngMode = 2 Then
%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR BGCOLOR="#cccccc">
				<TD WIDTH="150">コース名</TD>
				<TD WIDTH="250">受診団体</TD>
				<TD>受診人数</TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
<%
					If strCsCd(i) <> strPrevCsCd Then
%>
						<TD><FONT COLOR="<%= strWebColor(i) %>">■</FONT><%= strCsName(i) %></TD>
<%
					Else
%>
						<TD></TD>
<%
					End If
%>
					<TD><%= strOrgName(i) %></TD>
					<TD ALIGN="right"><%= strCslCount(i) %></TD>
				</TR>
<%
				strPrevCsCd = strCsCd(i)

			Next
%>
		</TABLE>
<%
		Exit Do
	End If

	If lngMode = 3 Then
%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR BGCOLOR="#cccccc">
				<TD WIDTH="250">受診団体</TD>
				<TD WIDTH="150">コース名</TD>
				<TD>受診人数</TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
<%
					If strOrgCd1(i) <> strPrevOrgCd1 Or strOrgCd2(i) <> strPrevOrgCd2 Then
%>
						<TD><%= strOrgName(i) %></TD>
<%
					Else
%>
						<TD></TD>
<%
					End If
%>
					<TD><FONT COLOR="<%= strWebColor(i) %>">■</FONT><%= strCsName(i) %></TD>
					<TD ALIGN="right"><%= strCslCount(i) %></TD>
				</TR>
<%
				strPrevOrgCd1 = strOrgCd1(i)
				strPrevOrgCd2 = strOrgCd2(i)

			Next
%>
		</TABLE>
<%
		Exit Do
	End If

	Exit Do
Loop
%>
</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
