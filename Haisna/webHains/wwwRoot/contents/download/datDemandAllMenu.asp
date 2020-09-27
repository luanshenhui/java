<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       請求情報関連ダウンロードの選択 (Ver0.0.1)
'       AUTHER  : Hiroki Ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

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
<TITLE>請求情報関連ダウンロードの選択</TITLE>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">■</SPAN><FONT COLOR="#000000">請求情報CSVの選択</FONT></B></TD>
    </TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
    <TR>
        <TD ROWSPAN="2"><A HREF="datCslMoneyList.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datCslMoneyList.asp">個人明細別請求情報抽出</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">受診期間もしくは締め日などから、対象となる個人毎項目毎の金額明細を抽出します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datBillConsult.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datBillConsult.asp">未請求受診情報抽出</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">請求書を作成されていない受診者の情報を取得します。請求済みデータも抽出可能です。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datBillDetail.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datBillDetail.asp">請求書明細情報抽出</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">作成済み請求書情報の詳細情報を抽出します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datBill.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datBill.asp">請求書情報抽出（ＣＯＭＰＡＮＹ連携用）</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">経理システム（ＣＯＭＰＡＮＹ）連携用請求書情報を抽出します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datOrgBill.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datOrgBill.asp">請求明細情報抽出（三井物産健保フォーマット）</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">三井物産健保フォーマットの請求明細情報を抽出します。</TD>
    </TR>
</TABLE>

</BLOCKQUOTE>
</BODY>
</HTML>