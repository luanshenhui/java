<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �c�̏��(���ѕ\�I�v�V��������Ǘ�) (Ver0.0.1)
'       AUTHER  : ��
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFree             '�ėp���A�N�Z�X�p
Dim objOrganization     '�c�̏��A�N�Z�X�p

Dim objConsult          '��f���A�N�Z�X�p
Dim objContract         '�_����A�N�Z�X�p

'�����l
Dim strOrgCd1           '�c�̃R�[�h�P
Dim strOrgCd2           '�c�̃R�[�h�Q
Dim strRptOptCd         '�I�v�V�����R�[�h
Dim strValues           '�I�����("1":�I���A"0":���I��)

'�������ڏ��
Dim strArrRptOptCd      '�I�v�V�����R�[�h(����I���j
Dim strArrRptOptName    '�I�v�V�������i����I���j
Dim strArrValues        '�I�����("1":�I���A"0":���I��)�i����I���j
Dim lngCount            '���R�[�h���i����I���j
Dim strStmts

Dim strArrRptOptCd2     '�I�v�V�����R�[�h�i�폜�I���j
Dim strArrRptOptName2   '�I�v�V�������i�폜�I���j
Dim strArrValues2       '�I�����("1":�I���A"0":���I��)�i�폜�I���j
Dim lngCount2           '���R�[�h���i�폜�I���j


Dim strOrgName          '�c�̖�
Dim strHTML             'HTML������
Dim i, j, k             '�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strRptOptCd    = ConvIStringToArray(Request("rptOptCd"))
strValues      = ConvIStringToArray(Request("values"))

'�ۑ��{�^��������
If Not IsEmpty(Request("save.x")) Then

    'For i = 0 To UBound(strRptOptCd)
    '    response.Write "strRptOptCd : " & strRptOptCd(i) & vbLf
    'Next


    '���я��I�v�V�����Ǘ��e�[�u���X�V
    '####### ���W�b�N�ǉ����K�v
    objOrganization.UpdateRptOpt strOrgCd1, strOrgCd2, Session("USERID"), strRptOptCd, strValues

    '�G���[���Ȃ���Ύ��g�����
    strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
    strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
    strHTML = strHTML & "</BODY>"
    strHTML = strHTML & "</HTML>"
    Response.Write strHTML
    Response.End

End If


'�w��c�̂ɑ΂��A���я��I�v�V�����Ǘ��󋵂��擾(����I�v�V�������ځj
lngCount = objOrganization.SelectRptOpt(strOrgCd1, strOrgCd2, "RPTV%", strArrRptOptCd, strArrRptOptName, strArrValues)

'�w��c�̂ɑ΂��A���я��I�v�V�����Ǘ��󋵂��擾(�폜�I�v�V�������ځj
lngCount2 = objOrganization.SelectRptOpt(strOrgCd1, strOrgCd2, "RPTD%", strArrRptOptCd2, strArrRptOptName2, strArrValues2)

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>���я��I�v�V�����Ǘ�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �`�F�b�N���̐���
function checkRptOptCd( index, checkBox ) {

    var objValues;    // ��f��ԗp�G�������g

    // �I�v�V�������P���A�����̏ꍇ�ɂ�鐧��
    if ( document.entryForm.rptOptCd.length == null ) {
        objValues = document.entryForm.values;
    } else {
        objValues = document.entryForm.values[ index ];
    }

    // �I����Ԃ̕ҏW
    objValues.value = checkBox.checked ? '1' : '0';

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2 %>">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN>���я��I�v�V�����Ǘ�</B></TD>
        </TR>
    </TABLE>
<%
    '�c�̖����擾
    objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
        <TR>
            <TD HEIGHT="35" WIDTH="100%" NOWRAP>�c�̖��F<FONT COLOR="#FF6600"><B><%= strOrgName %></B></FONT></TD>
<%
            '�I�v�V�����R�[�h�����݂���ꍇ�̂ݕۑ��{�^����p�ӂ���i�K�v���͂Ȃ������j
            If lngCount > 0 Then
%>
                <TD>
                <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
    			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                    <INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
                <%  else    %>
                     &nbsp;
                <%  end if  %>
                <% '2005.08.22 �����Ǘ� Add by ��  ---- END %>
                </TD>
<%
            End If
%>
            <TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A></TD>
        </TR>
    </TABLE>
    <FONT COLOR="#cc9999">��</FONT>���я��I�v�V��������ꗗ��\�����Ă��܂��B<BR>
    <BR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR HEIGHT="2">
                <TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
            </TR>
        </TABLE>
    <BR>
    <FONT COLOR="#cc9999">��</FONT>�������I�v�V�������ڂ�<INPUT TYPE="checkbox" CHECKED>�`�F�b�N���ĉ������B<BR><BR>
<%
    Do
        '�\���ΏۃI�v�V�������ڂ����݂��Ȃ��ꍇ
        If lngCount <= 0 Then
%>
            ���̒c�̂̈���I�v�V�������ڂ͑��݂��܂���B
<%
            Exit Do
        End If
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR>
                <TD></TD>
                <TD WIDTH="50%"></TD>
                <TD></TD>
                <TD WIDTH="50%"></TD>
            </TR>
<%
            '�I�v�V�������ڂ̕ҏW
            i = 0
            Do
%>
            <TR>
<%
                '�P�s�ӂ�Q�I�v�V�����ڂ�ҏW
                For j = 1 To 2
%>
                    <TD><INPUT TYPE="hidden" NAME="rptOptCd" VALUE="<%= strArrRptOptCd(i) %>"><INPUT TYPE="hidden" NAME="values" VALUE="<%= strArrValues(i) %>"><INPUT TYPE="checkbox" ONCLICK="checkRptOptCd(<%= i %>,this)"<%= IIf(strArrValues(i) = "1", " CHECKED", "") %>></TD>
                    <TD NOWRAP><%= strArrRptOptName(i) %></TD>
<%
                    i = i + 1
                    If i >= lngCount Then
                    Exit For
                    End If

                Next

                If i >= lngCount Then
%>
                    </TR>
<%
                    Exit Do
                End If

            Loop
%>
        </TABLE>
<%
        Exit Do
    Loop
%>
    <BR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR HEIGHT="2">
                <TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
            </TR>
        </TABLE>
    <BR>
    <FONT COLOR="#cc9999">��</FONT>������Ȃ��I�v�V�������ڂ�<INPUT TYPE="checkbox" CHECKED>�`�F�b�N���ĉ������B<BR><BR>
<%
    Do
        '�폜�ΏۃI�v�V�������ڂ����݂��Ȃ��ꍇ
        If lngCount2 <= 0 Then
%>
            ���̒c�̂̈���I�v�V�������ڂ͑��݂��܂���B
<%
            Exit Do
        End If
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR>
                <TD></TD>
                <TD WIDTH="50%"></TD>
                <TD></TD>
                <TD WIDTH="50%"></TD>
            </TR>
<%
            '�I�v�V�������ڂ̕ҏW
            k = i
            Do
%>
            <TR>
<%
                '�P�s�ӂ�Q�I�v�V�����ڂ�ҏW
                For j = 1 To 2
%>
                    <TD><INPUT TYPE="hidden" NAME="rptOptCd" VALUE="<%= strArrRptOptCd2(i-k) %>"><INPUT TYPE="hidden" NAME="values" VALUE="<%= strArrValues2(i-k) %>"><INPUT TYPE="checkbox" ONCLICK="checkRptOptCd(<%= i %>,this)"<%= IIf(strArrValues2(i-k) = "1", " CHECKED", "") %>></TD>
                    <TD NOWRAP><%= strArrRptOptName2(i-k) %></TD>
<%
                    i = i + 1
                    If i-k >= lngCount2 Then
                    Exit For
                    End If

                Next

                If i-k >= lngCount2 Then
%>
                    </TR>
<%
                    Exit Do
                End If

            Loop
%>
        </TABLE>
<%
        Exit Do
    Loop
%>

</FORM>
</BODY>
</HTML>
