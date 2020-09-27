<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求メニュー (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'<!--- 2003.10.15 追加 start -->
Dim lngRsvNo
'<!--- 2003.09.30 追加 end -->
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
<TITLE>請求メニュー</TITLE>
<STYLE TYPE="text/css">
<!--
td.dmdtab  { background-color:#FFFFFF }
-->
</STYLE>

<!--- 2003.10.15 追加 start -->
<SCRIPT TYPE="text/javascript">
<!--
function movePage() {

    var	url

    if ( document.searchdaily.rsvno.value == '' ) {
        return;
    }

    url = '/webHains/contents/interview/interviewTop.asp';
//	url = '/webHains/contents/interview/totalJudView.asp';
    url = url + '?rsvno=' + document.searchdaily.rsvno.value;
    open( url, '', '' );

}
//-->
</SCRIPT>
<!--- 2003.09.30 追加 end -->


</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="searchdaily" ACTION="">
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
    <TR VALIGN="bottom">
        <TD><FONT SIZE="+2"><B>請求処理</B></FONT></TD>
    </TR>
    <TR BGCOLOR="#cccccc">
        <TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
    </TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/perbill/perBillSearch.asp"><IMG SRC="/webHains/images/wallet.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/perbill/perBillSearch.asp">個人請求書の検索</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">個人請求書を検索します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/perbill/createPerBill.asp"><IMG SRC="/webHains/images/wallet.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/perbill/createPerBill.asp">個人請求書新規作成処理</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">個人請求情報を作成します。</TD>
    </TR>
<!--- 2003.09.30 追加 end -->
<!--- 2003.10.01 追加 start -->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdDecideAllPrice.asp"><IMG SRC="/webHains/images/wallet.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdDecideAllPrice.asp">個人受診金額再作成</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">個人受診情報毎に作成された金額情報を最新設定情報を元に再作成します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdAddUp.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdAddUp.asp">締め処理</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">指定範囲内の受診情報から請求締め処理を行います。</TD>
    </TR>
<!--'### 2004/10/26 Added by FSIT)Gouda 日次締め処理画面作成-->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/perbill/perAddUp.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/perbill/perAddUp.asp">日次締め処理</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">当日の請求締め処理を行います。</TD>
    </TR>
<!--'### 2004/10/26 Added End-->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdBurdenList.asp"><IMG SRC="/webHains/images/bill.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdBurdenList.asp">請求書照会、修正</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">団体様への請求書を参照、修正します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdDeleteAllBill.asp"><IMG SRC="/webHains/images/trash.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdDeleteAllBill.asp">請求書削除</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">指定された締め日の請求書を一括して削除します。</TD>
    </TR>
<!-- 2004/01/16 Shiramizu Modified Start-->
<!--
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdPaymentSearch.asp"><IMG SRC="/webHains/images/bank.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdPaymentSearch.asp">団体入金処理</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">団体様からの入金情報を参照、登録します。</TD>
    </TR>
-->
<!-- 2004/01/16 Shiramizu Modified Start-->

    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdPaymentFromCsv.asp"><IMG SRC="/webHains/images/bank.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdPaymentFromCsv.asp">団体一括入金処理</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">団体様からの入金情報を一括登録します。</TD>
    </TR>

    
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdSendCheckDay.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdSendCheckDay.asp">請求書発送処理</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">団体様への請求書を、発送します。</TD>
    </TR>
<!-- 2004/01/16 Shiramizu Modified End-->
<!--- 2003.09.30 追加 start -->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
<!--- 2003.10.01 追加 end -->
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
