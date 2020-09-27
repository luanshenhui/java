<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       ����ی��w���ΏۗL���o�^ (Ver0.0.1)
'       AUTHER  : �����l�i2009/03/30�j
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const GUIDANCE_ITEMCD = "64074"     '����ی��w���@�������ڃR�[�h
Const GUIDANCE_SUFFIX = "00"        '����ی��w���@�T�t�B�b�N�X

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objResult           '�������ʏ��A�N�Z�X�p
Dim RetResult           '���ʌ������A�l
Dim strMessage          '���ʓo�^���A�l

Dim strHTML             'HTML �i�[�̈�

'�p�����[�^
Dim strAct              '�������
Dim strRsvNo            '�\��ԍ�

'UpdateResult_tk �p�����[�^
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntResult           '��������
Dim vntRslCmtCd1        '���ʃR�����g�P
Dim vntRslCmtCd2        '���ʃR�����g�Q
Dim strIPAddress        'IP�A�h���X

Dim strResult           '����ی��w���敪�i���ʃe�[�u���Q�ƒl�FRSL�j
Dim strSentenceCd       '���̓R�[�h
Dim lngFlgChk           '�t���O�`�F�b�N����

Dim strUserId           '���[�U�h�c
Dim strUserName         '���[�U��

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objResult = Server.CreateObject("HainsResult.Result")

'�p�����[�^�l�̎擾
strAct          = Request("action")
strRsvNo        = Request("rsvno")
strSentenceCd   = Request("guideKind")
strSentenceCd   = IIf( strSentenceCd="", "1", strSentenceCd )

strUserId       = Session.Contents("userId")
strIPAddress    = Request.ServerVariables("REMOTE_ADDR")

Do

    '�m��
    If strAct = "save" Then
        
        vntItemCd = Array()
        Redim Preserve vntItemCd(0)
        vntItemCd(0) = GUIDANCE_ITEMCD

        vntSuffix  = Array()
        Redim Preserve vntSuffix(0)
        vntSuffix(0) = GUIDANCE_SUFFIX

        vntResult  = Array()
        Redim Preserve vntResult(0)
        vntResult(0) = strSentenceCd

        vntRslCmtCd1  = Array()
        Redim Preserve vntRslCmtCd1(0)
        vntRslCmtCd2  = Array()
        Redim Preserve vntRslCmtCd2(0)

        objResult.UpdateResult strRsvNo, strIPAddress, strUserId, vntItemCd, vntSuffix, vntResult, vntRslCmtCd1, vntRslCmtCd2, strMessage

        If Not IsEmpty(strMessage) Then
            Err.Raise 1000, , strMessage(0) & " " & vntResult(0)
            Err.Raise 1000, , "����ی��w���Ώۋ敪�̓o�^���ł��܂���ł����B"
            Exit Do
        Else
            '�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End
            Exit Do
        End If
    
    End If

    Exit Do

Loop

lngFlgChk = 0

'����ی��w���敪���ʃf�[�^�擾
RetResult = objResult.SelectRsl( strRsvNo, GUIDANCE_ITEMCD, GUIDANCE_SUFFIX, strResult )
If RetResult = True Then

    If strResult <> "" Then
        strSentenceCd   = strResult
        lngFlgChk = lngFlgChk + 1
    End If

End If


Set objResult   = Nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���茒�f�Ώۋ敪�o�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    function saveAuther(){

/** ����ی��w���敪�`�F�b�N�L���̊m�F Start   **/
/** �`�F�b�N����Ă��Ȃ��ƃG���[���b�Z�[�W�\�� **/
        var objRadio = document.entryForm;
        var j = 0;

        for(i=0 ; i < objRadio.elements.length ; i++)
        {
            if(objRadio.elements[i].type == "radio" || objRadio.elements[i].type == "RADIO" )
            {
                if(objRadio.elements[i].checked == true) {
                    j = j + 1;
                }
            }
        }
        if(j == 0){
            alert("����ی��w���Ώۋ敪��I�����Ă��������B");
            return;
        }
/** ����ی��w���敪�`�F�b�N�L���̊m�F End   **/
        
        document.entryForm.action.value = "save";
        document.entryForm.submit();

    }

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="action"  VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= strRsvNo %>">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">����ی��w���敪�o�^</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
    '### ����ی��w���敪���o�^����Ă��Ȃ������ꍇ�A���o�^���b�Z�[�W�\��
    If lngFlgChk = 0 Then
%>
        <TR>
            <TD COLSPAN="3"><FONT COLOR="#ff6600"><B>���݁A����ی��w���敪���o�^����Ă��܂���B</B></FONT></TD>
        <TR>
<% 
    End If
%>
        <TR>
            <TD>����ی��w��</TD>
            <TD>&nbsp;�F&nbsp;</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="guideKind" VALUE="1"<%= IIf(strSentenceCd = "1", " CHECKED", "") %>></TD>
                        <TD>�ΏۊO</TD>
                        <TD><INPUT TYPE="radio" NAME="guideKind" VALUE="2"<%= IIf(strSentenceCd = "2", " CHECKED", "") %>></TD>
                        <TD>�Ώ�</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    
    <BR>
    <TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD>
                    <A HREF="javascript:saveAuther()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�" border="0"></A>
                </TD>
            <%  end if  %>
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��" border="0"></A></TD>
        </TR>
    </TABLE>
    <BR>
</FORM>
</BODY>
</HTML>