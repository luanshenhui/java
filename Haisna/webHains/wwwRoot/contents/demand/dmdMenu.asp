<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������j���[ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'<!--- 2003.10.15 �ǉ� start -->
Dim lngRsvNo
'<!--- 2003.09.30 �ǉ� end -->
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������j���[</TITLE>
<STYLE TYPE="text/css">
<!--
td.dmdtab  { background-color:#FFFFFF }
-->
</STYLE>

<!--- 2003.10.15 �ǉ� start -->
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
<!--- 2003.09.30 �ǉ� end -->


</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="searchdaily" ACTION="">
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
    <TR VALIGN="bottom">
        <TD><FONT SIZE="+2"><B>��������</B></FONT></TD>
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
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/perbill/perBillSearch.asp">�l�������̌���</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�l���������������܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/perbill/createPerBill.asp"><IMG SRC="/webHains/images/wallet.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/perbill/createPerBill.asp">�l�������V�K�쐬����</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�l���������쐬���܂��B</TD>
    </TR>
<!--- 2003.09.30 �ǉ� end -->
<!--- 2003.10.01 �ǉ� start -->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdDecideAllPrice.asp"><IMG SRC="/webHains/images/wallet.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdDecideAllPrice.asp">�l��f���z�č쐬</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�l��f��񖈂ɍ쐬���ꂽ���z�����ŐV�ݒ�������ɍč쐬���܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdAddUp.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdAddUp.asp">���ߏ���</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�w��͈͓��̎�f��񂩂琿�����ߏ������s���܂��B</TD>
    </TR>
<!--'### 2004/10/26 Added by FSIT)Gouda �������ߏ�����ʍ쐬-->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/perbill/perAddUp.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/perbill/perAddUp.asp">�������ߏ���</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�����̐������ߏ������s���܂��B</TD>
    </TR>
<!--'### 2004/10/26 Added End-->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdBurdenList.asp"><IMG SRC="/webHains/images/bill.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdBurdenList.asp">�������Ɖ�A�C��</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�c�̗l�ւ̐��������Q�ƁA�C�����܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdDeleteAllBill.asp"><IMG SRC="/webHains/images/trash.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdDeleteAllBill.asp">�������폜</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�w�肳�ꂽ���ߓ��̐��������ꊇ���č폜���܂��B</TD>
    </TR>
<!-- 2004/01/16 Shiramizu Modified Start-->
<!--
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdPaymentSearch.asp"><IMG SRC="/webHains/images/bank.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdPaymentSearch.asp">�c�̓�������</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�c�̗l����̓��������Q�ƁA�o�^���܂��B</TD>
    </TR>
-->
<!-- 2004/01/16 Shiramizu Modified Start-->

    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdPaymentFromCsv.asp"><IMG SRC="/webHains/images/bank.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdPaymentFromCsv.asp">�c�̈ꊇ��������</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�c�̗l����̓��������ꊇ�o�^���܂��B</TD>
    </TR>

    
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="dmdSendCheckDay.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="dmdSendCheckDay.asp">��������������</A></B></SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�c�̗l�ւ̐��������A�������܂��B</TD>
    </TR>
<!-- 2004/01/16 Shiramizu Modified End-->
<!--- 2003.09.30 �ǉ� start -->
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
<!--- 2003.10.01 �ǉ� end -->
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
