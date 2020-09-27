<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		予約メニュー (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.5
'担当者  ：T.Takagi@RD
'修正内容：予約確認メール送信機能追加

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>予約メニュー</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab  { background-color:#FFFFFF }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
	<TR VALIGN="bottom">
		<TD><FONT SIZE="+2"><B>予約</B></FONT></TD>
	</TR>
	<TR BGCOLOR="#cccccc">
		<TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvMain.asp"><IMG SRC="/webHains/images/yoyaku.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvMain.asp">新規予約</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">新しく健康診断の予約を登録します。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="../frameReserve/fraRsvMain.asp"><IMG SRC="/webHains/images/schedule.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="../frameReserve/fraRsvMain.asp">予約枠の検索</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">指定された条件から、予約可能な日にちを検索します。</TD>
	</TR>
<!--
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/reserveOrg/default.asp"><IMG SRC="/webHains/images/office.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/reserveOrg/default.asp">団体様の予約を登録する</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">団体様からのまとまったお申し込みを登録します。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/reserveOrg/rsvOrgSchedule.asp"><IMG SRC="/webHains/images/calendar.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/reserveOrg/rsvOrgSchedule.asp">団体予約スケジュールの確認</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">団体様からの予約状況を一覧で表示します。</TD>
	</TR>
-->
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvAllFromCsv.asp"><IMG SRC="/webHains/images/csvplus.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvAllFromCsv.asp">ＣＳＶファイルからの一括予約</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">ＣＳＶファイルのデータをもとに一括で予約処理を行います。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvAllDelete.asp"><IMG SRC="/webHains/images/csvminus.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvAllDelete.asp">ＣＳＶファイルからの予約一括削除</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">一括予約処理結果のＣＳＶデータをもとに予約の一括削除を行います。</TD>
	</TR>
<% '## 2005.03.04 Add By T.Takagi web予約取り込み %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/webReserve/webRsvSearch.asp"><IMG SRC="/webHains/images/web1.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/webReserve/webRsvSearch.asp">web予約取り込み</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webから申し込まれた予約情報をwebHainsに取り込みます。</TD>
	</TR>
<% '## 2005.03.04 Add End %>
<% '## 2007.03.03 Add By 張 web団体予約取り込み %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/webOrgReserve/webOrgRsvSearch.asp"><IMG SRC="/webHains/images/web2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/webOrgReserve/webOrgRsvSearch.asp">web団体予約取り込み</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webから申し込まれた団体予約情報をwebHainsに取り込みます。</TD>
	</TR>
<% '## 2007.03.03 Add End %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
<!--
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/receipt/rptBarcode.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/receipt/rptBarcode.asp">バーコード受付</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">バーコードによる受付画面を表示します。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/receipt/rptRequest.asp"><IMG SRC="/webHains/images/testtube.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/receipt/rptRequest.asp">検査依頼</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">検査システムに送信する依頼ファイルを作成します。</TD>
	</TR>
-->
<% '## 2004.01.16 Add By T.Takagi 更新履歴表示 %>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvLog.asp"><IMG SRC="/webHains/images/koushinrireki.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvLog.asp">更新履歴</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">受診情報の変更履歴を表示します。</TD>
	</TR>
<% '## 2004.01.16 Add End %>
<% '#### 2013.3.5 SL-SN-Y0101-612 ADD START #### %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvSendMail.asp"><IMG SRC="/webHains/images/mail.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvSendMail.asp">予約確認メール送信</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">予約情報に対し、確認メールを送信します。</TD>
	</TR>
<% '#### 2013.3.5 SL-SN-Y0101-612 ADD END   #### %>
<% '## 2004.09.23 Add By T.Ito Failsafe追加 %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/failSafe/failSafe.asp?strYear=<%= Year(Date) %>&amp;strMonth=<%= Month(Date) %>&amp;strDay=<%= Day(Date) %>"><IMG SRC="/webHains/images/machine.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/failSafe/failSafe.asp?strYear=<%= Year(Date) %>&amp;strMonth=<%= Month(Date) %>&amp;strDay=<%= Day(Date) %>">FailSafe</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">契約情報との整合性チェックを行います。</TD>
	</TR>
<% '## 2004.09.23 Add End %>
</TABLE>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
