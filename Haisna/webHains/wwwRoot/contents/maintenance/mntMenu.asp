<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		メンテナンスメニュー (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

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
<STYLE TYPE="text/css">
<!--
td.mnttab  { background-color:#FFFFFF }
-->
</STYLE>
<TITLE>メンテナンス</TITLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
	<TR VALIGN="bottom">
		<TD><FONT SIZE="+2"><B>メンテナンス</B></FONT></TD>
	</TR>
	<TR BGCOLOR="#cccccc">
		<TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/personal/mntSearchPerson.asp"><IMG SRC="/webHains/images/person.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/personal/mntSearchPerson.asp">個人情報</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">個人情報として設定している内容確認。及びその内容の変更はこちらから。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
<!--
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/disease/perDiseaseList.asp"><IMG SRC="/webHains/images/person.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/disease/perDiseaseList.asp">傷病休業情報</A></B>/</SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">従業員の方の傷病休業情報を登録します</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
-->
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/organization/mntSearchOrg.asp"><IMG SRC="/webHains/images/office.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/organization/mntSearchOrg.asp">団体情報</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">団体情報として設定している内容確認。及びその内容の変更はこちらから。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/contract/ctrSearchOrg.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/contract/ctrSearchOrg.asp">契約情報の参照、登録</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">団体毎に指定されたそれぞれの契約内容確認、及び新規契約情報の登録はこちらから。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/rsvFra/rsvFraSearch.asp"><IMG SRC="/webHains/images/telephone.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/rsvFra/rsvFraSearch.asp">予約枠登録、確認</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">各コース、設備毎の予約可能人数の設定を行います。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/capacity/mntCapacity.asp"><IMG SRC="/webHains/images/telephone.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/capacity/mntCapacity.asp">休診日設定</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">祝日、休診日の設定を行います。</TD>
	</TR>
<!--
	<TR>
		<TD></TD><TD></TD><TD><A HREF="/webHains/contents/maintenance/capacity/mntCapacity.asp">旧予約枠登録</A></TD>
	</TR>
-->
<!-- ## 2004.03.10 Add By T.Takgi@FSIT 予約枠コピー機能 -->
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/rsvFra/rsvFraCopy1.asp"><IMG SRC="/webHains/images/telephone.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/rsvFra/rsvFraCopy1.asp">予約枠のコピー</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">すでに登録されている予約枠情報をコピーし、新しい予約枠を作成します。</TD>
	</TR>
<!-- ## 2004.03.10 Add End -->
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>

		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/reportSendCheck.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/reportSendCheck.asp">成績書発送確認</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">成績書の発送確認を行います。</TD>
		</TR>
		<TR>
			<TD HEIGHT="15"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/inqReportsInfo.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/inqReportsInfo.asp">成績書発送進捗確認</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">成績書作成の進捗確認を行います。</TD>
		</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp"><IMG SRC="/webHains/images/machine.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp">ログ参照</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">一括予約、請求締め処理などの実行ログを参照します。</TD>
	</TR>

<!--
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/import/mntImportPersonStep1.asp"><IMG SRC="/webHains/images/mo.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/import/mntImportPersonStep1.asp">健保データの取り込み</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">健保から受け取ったＣＳＶデータを取り込み、個人情報として登録します。</TD>
	</TR>
-->
	<TR>
		<TD HEIGHT="50"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/mntDownLoad.asp"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/mntDownLoad.asp">ダウンロード</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webHainsシステム管理アプリケーション等のダウンロード</TD>
	</TR>
</TABLE>

<BR><BR><BR><BR>
<BR><BR><BR><BR>

<!--
<A HREF="/webHains/contents/mngAccuracy/mngAccuracyInfo.asp"><IMG SRC="/webHains/images/moa.jpg" WIDTH="10" HEIGHT="10" ALT="精度管理"></A>
-->
<BR><BR>
<!--
<A HREF="/webHains/contents/rsvFra/rsvFraCopy1.asp"><IMG SRC="/webHains/images/moa.jpg" WIDTH="10" HEIGHT="10" ALT="予約枠コピー"></A>
-->
<BR>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>