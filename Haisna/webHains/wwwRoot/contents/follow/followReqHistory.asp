<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[(�˗���) (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/follow_print.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'Const PRT_DIV  = 1      '�l�����ށF�˗���
Dim strMessage           '�G���[���b�Z�[�W
Dim strArrMessage        '�G���[���b�Z�[�W

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objFollow           '�t�H���[�A�b�v�A�N�Z�X�p
Dim objReqHistory       '�˗��󗚗��A�N�Z�X�p

'�p�����[�^
Dim strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ�
Dim lngJudClassCd       '���蕪�ރR�[�h

Dim strItemCd           '����������������
Dim vntItemCd           '�t�H���[�Ώی������ڃR�[�h
Dim vntItemName         '�t�H���[�Ώی������ږ���

Dim lngItemCount        '�t�H���[�Ώی������ڐ�
Dim lngHisCount         '�߂�l

Dim vntRsvNo            '���蕪�ރR�[�h�z��
Dim vntJudClassCd       '���蕪�ރR�[�h�z��
Dim vntJudClassName     '�������ޖ��z��
Dim vntJudCd            '����R�[�h�z��
Dim vntFileName         '�˗��󖼔z��
Dim vntSeq              '�˗���ԍ��z��
Dim vntAddDate          '������z��
Dim vntAddUserName      '����Ҕz��
Dim vntReqSendDate      '�˗��󔭑����z��
Dim vntReqSendUser      '�˗��󔭑��Ҕz��
Dim vntPrtDiv           '�l�����ޔz��

Dim i                   '�J�E���^
Dim Ret                 '�߂�l

Dim lngPrtDiv           '����l������
Dim lngArrPrtDiv()      '����l������
Dim strArrPrtDivName()  '����l�����ޖ�

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon         = Server.CreateObject("HainsCommon.Common")
Set objFollow         = Server.CreateObject("HainsFollow.Follow")
Set objReqHistory     = Server.CreateObject("HainsRequestCard.RequestCard")

'�p�����[�^�l�̎擾
lngRsvNo        = Request("rsvno")
lngPrtDiv       = Request("prtDiv")
strItemCd       = request("itemCd")

lngPrtDiv = IIf(lngPrtDiv = "", 0, lngPrtDiv)
'strItemCd = IIf(strItemCd = "", 999, strItemCd)

Call CreateOrderByInfo()

Do

    '�t�H���[�Ώی������ځi���蕪�ށj���擾
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName )

        '�˗��󗚗��擾
        lngHisCount = objReqHistory.folReqHistory(lngRsvNo, _
                                                  lngPrtDiv, _
                                                  strItemCd, _
                                                  vntRsvNo, _
                                                  vntJudClassCd, _
                                                  vntJudClassName, _
                                                  vntJudCd, _
                                                  vntFileName, _
                                                  vntSeq, _
                                                  vntAddDate, _
                                                  vntAddUserName, _
                                                  vntReqSendDate, _
                                                  vntReqSendUser, _
                                                  vntPrtDiv _
                                                 )

    Exit Do

Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ёւ����̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateOrderByInfo()


    Redim Preserve lngArrPrtDiv(1)
    Redim Preserve strArrPrtDivName(1)

    lngArrPrtDiv(0) = 1:strArrPrtDivName(0) = "�˗�"
    lngArrPrtDiv(1) = 2:strArrPrtDivName(1) = "����"

End Sub


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�˗���������</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

    function searchForm() {

        with ( document.entryPrt ) {
            submit();
        }
        return false;
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�˗���������</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
    '## ��f�Ҍl���\��
    Call followupHeader(lngRsvNo)
%>
    <!--BR-->
<FORM NAME="entryPrt" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="rsvno"            VALUE="<%= lngRsvNo %>">

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR>
            <TD align="left">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD WIDTH="60" HEIGHT="22">�������ځF</TD>
                        <TD WIDTH="120"><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD WIDTH="60">�l���敪�F</TD>
                        <TD WIDTH="120"><%= EditDropDownListFromArray("prtDiv", lngArrPrtDiv, strArrPrtDivName, lngPrtDiv, NON_SELECTED_ADD) %></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD WIDTH="200">&nbsp;<A HREF="javascript:searchForm()"><IMG SRC="/webHains/images/b_prev.gif" ALT="�\��" HEIGHT="28" WIDTH="53" BORDER="0"></A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <BR>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE WIDTH="600" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
        <TR>
            <TD>
                <SPAN STYLE="font-size:9pt;">
                <FONT COLOR="#ff6600">&nbsp;���������&nbsp;<B><%= lngHisCount %></B>&nbsp;���ł��B</FONT>
                </SPAN>
            </TD>
        </TR>
    </TABLE>

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="silver">
                        <TD NOWRAP WIDTH="90">�������ږ�</TD>
                        <TD NOWRAP WIDTH="60">����</TD>
                        <TD NOWRAP WIDTH="90">�Ő�</TD>
                        <TD NOWRAP WIDTH="140">�쐬��</TD>
                        <TD NOWRAP WIDTH="120">�쐬��</TD>
                        <TD NOWRAP WIDTH="100">����t�@�C����</TD>
                        <TD NOWRAP WIDTH="140">������</TD>
                        <TD NOWRAP WIDTH="120">������</TD>
                        <TD NOWRAP WIDTH="140">���l</TD>
                    </TR>
<%

        If lngHisCount > 0 Then

                For i = 0 To UBound(vntRsvNo)

%>
                    <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                        <TD NOWRAP><%= vntJudClassName(i)  %></TD>
                        <TD NOWRAP><%= vntJudCd(i)  %></TD>
                    <%
                        If vntPrtDiv(i) <> 0 Then
                            Select Case vntPrtDiv(i)
                                Case 1
                    %>
                                    <TD NOWRAP>�˗���&nbsp;_&nbsp;<%= vntSeq(i) %>��  </TD>
                    <%
                                Case 2
                    %>
                                    <TD NOWRAP>����&nbsp;_&nbsp;<%= vntSeq(i) %>��  </TD>
                    <%
                            End Select
                        Else 
                    %>
                                    <TD NOWRAP>&nbsp;</TD>
                    <%
                        End If
                    %>
                        <TD NOWRAP><%= vntAddDate(i)       %></TD>
                        <TD NOWRAP><%= vntAddUserName(i)   %></TD>
                        <TD NOWRAP><A HREF="/webHains/contents/follow/prtPreview.asp?documentFileName=<%= vntFileName(i) %>" TARGET="_blank"><%= vntFileName(i) %></A></TD>
                        <TD NOWRAP><%= vntReqSendDate(i)   %></TD>
                        <TD NOWRAP><%= vntReqSendUser(i)   %></TD>
                    <%
                        If vntJudCd(i) = "" Then
                    %>
                            <TD NOWRAP>�t�H���[�A�b�v���폜</TD>
                    <%
                        Else
                    %>
                            <TD NOWRAP>&nbsp;</TD>
                    <%
                        End If
                    %>

                    </TR>
<%
                Next
        End If
%>
                </TABLE>�@�@
            </TD>
        </TR>
    </TABLE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
