<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       �b�r�u�t�@�C������̈ꊇ�������� (Ver0.0.1)
'       AUTHER  : 
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const TEMPFILE_PATH  = "/webHains/Temp/"    '�������ʕtCSV�t�@�C���̏����o���p�X
Const APPEND_KEYWORD = "(����)"             'CSV�t�@�C���������Ƃɏ������ʕtCSV�t�@�C�������쐬����ۂɒǉ����镶����

'COM�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objCreateCsv        '�b�r�u�t�@�C���쐬�p
Dim objImport           '�l����荞�ݗp
Dim objParse            'POST�f�[�^��͗p

'POST���ꂽ���
Dim strName             '�G�������g��
Dim strFileName         '�t�@�C����
Dim strContentType      'content-type�l
Dim strContent          '�G�������g�l

'�����l
Dim strCsvFileName      'CSV�t�@�C����
Dim strStartPos         '�ǂݍ��݊J�n�ʒu
Dim strRslFileName      '���ʕtCSV�t�@�C����
Dim strReadCount        '�ǂݍ��݃��R�[�h��
Dim strWriteCount       '�쐬��f���

'�_����
Dim strUpdUser          '�X�V��
Dim vntPostedData       'POST�f�[�^
Dim lngCnt              'POST�f�[�^�̃T�C�Y
Dim strTempFileName     '�ꎞ�t�@�C����
Dim strOutFileName      '�o�̓t�@�C����
Dim strMessage          '�G���[���b�Z�[�W
Dim strURL              '�W�����v���URL

Dim objExec             '��荞�ݏ������s�p
Dim strCommand          '�R�}���h���C��������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
strStartPos     = Request.QueryString("startPos")
strRslFileName  = Request.QueryString("rslFileName")
strReadCount    = Request.QueryString("readCount")
strWriteCount   = Request.QueryString("writeCount")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '������QueryString�ɂēn����Ă���ꍇ
    If strReadCount <> "" Then
        strMessage = "�ǂݍ��݃��R�[�h����" & strReadCount & "�A�쐬������񐔁�" & strWriteCount
        Exit Do
    End If

    '�f�[�^��POST����Ă��Ȃ���Ή������Ȃ�
    lngCnt = Request.TotalBytes
    If lngCnt <= 0 Then
        Exit Do
    End If

    'POST�f�[�^�̎擾
    vntPostedData = Request.BinaryRead(lngCnt)

    Set objParse = Server.CreateObject("HainsPaymentAuto.Parse")

    '���
    objParse.ParseMulti Request.ServerVariables("CONTENT_TYPE"), vntPostedData, strName, strFileName, strContentType, strContent

    Set objParse = Nothing

    '�����l�̎擾
    strCsvFileName = strFileName(0)
    strStartPos    = strContent(1)

    '���̓`�F�b�N
    strMessage = CheckValue()
    If Not IsEmpty(strMessage) Then
        Exit Do
    End If

    Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

    'POST�f�[�^����ꎞ�t�@�C�����쐬
    strFileName = objCreateCsv.ConvertStreamToFile(strContent(0))

    Set objCreateCsv = Nothing

    '�쐬���ׂ��o�̓t�@�C�����̒�`

    '�p�X��������
    If InStrRev(strCsvFileName, "\") > 0 Then
        strOutFileName = Right(strCsvFileName, Len(strCsvFileName) - InStrRev(strCsvFileName, "\"))
    Else
        strOutFileName = strCsvFileName
    End If

    '�g���q�̒��O�ɕ������ǉ�
    If InStr(strOutFileName, ".") > 0 Then
        strOutFileName = Replace(strOutFileName, ".", APPEND_KEYWORD & ".", 1, 1)
    Else
        strOutFileName = strOutFileName & APPEND_KEYWORD
    End If

    Set objImport = Server.CreateObject("HainsPaymentAuto.PaymentImportCsv")

    '�������̍쐬
    objImport.ImportCsv strFileName, strUpdUser, CLng("0" & strStartPos), Server.MapPath(TEMPFILE_PATH), strOutFileName, strReadCount, strWriteCount

    Set objImport = Nothing

    Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

    '�ꎞ�t�@�C�����폜
    objCreateCsv.DeleteFile strFileName

    Set objCreateCsv = Nothing

    '����ʂ����_�C���N�g
    strURL = Request.ServerVariables("SCRIPT_NAME")
    strURL = strURL & "?startPos="    & strStartPos
    strURL = strURL & "&rslFileName=" & strOutFileName
    strURL = strURL & "&readCount="   & strReadCount
    strURL = strURL & "&writeCount="  & strWriteCount
    Response.Redirect strURL
    Response.End

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim strMessage  '�G���[���b�Z�[�W�̏W��
    Dim i           '�C���f�b�N�X

    Set objCommon = Server.CreateObject("HainsCommon.Common")

    'CSV�t�@�C���̃`�F�b�N
    If strCsvFileName = "" Then
        objCommon.appendArray strMessage, "�b�r�u�t�@�C�����w�肵�ĉ������B"
    End If

    '�ǂݍ��݊J�n�ʒu�̃`�F�b�N
    If strStartPos <> "" Then
        For i = 1 To Len(strStartPos)
            If InStr("0123456789", Mid(strStartPos, i, 1)) <= 0 Then
                objCommon.appendArray strMessage, "�ǂݍ��݊J�n�ʒu�͂O�ȏ�̐����Ŏw�肵�ĉ������B"
                Exit For
            End If
        Next
    End If

    '�߂�l�̕ҏW
    If IsArray(strMessage) Then
        CheckValue = strMessage
    End If

    Set objCommon = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�b�r�u�t�@�C������̈ꊇ����</TITLE>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ENCTYPE="multipart/form-data" ONSUBMIT="javascript:return confirm('���̓��e�ňꊇ�����������s���܂��B��낵���ł����H')">
    <BLOCKQUOTE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�b�r�u�t�@�C������̈ꊇ����</FONT></B></TD>
        </TR>
    </TABLE>
<%
    '���b�Z�[�W�̕ҏW
    Do

        '�������w�莞�͒ʏ�̃��b�Z�[�W�ҏW
        If strWriteCount = "" then
            EditMessage strMessage, MESSAGETYPE_WARNING
            Exit Do
        End If

        '��f���̍X�V���b�Z�[�W
        If strWriteCount = "0" Then
            strMessage = strMessage & "<BR>�������͍쐬����܂���ł����B"
        Else
            strMessage = strMessage & "<BR>" & strWriteCount & "���̓�����񂪍쐬����܂����B"
        End If

        EditMessage strMessage & "<BR>�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL

        Exit Do
    Loop
%>
    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="130" NOWRAP>�b�r�u�t�@�C��</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="file" NAME="csvFileName" SIZE="50"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="130" NOWRAP>�ǂݍ��݊J�n�ʒu</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="startPos" SIZE="3" VALUE="<%= strStartPos %>" STYLE="ime-mode:disabled"></TD>
        </TR>
    </TABLE>

<%
    If strRslFileName <> "" Then
%>
        <BR><A HREF="/webHains/contents/print/prtPreview.asp?documentFileName=<%= strRslFileName %>">��荞�݌��ʕt���b�r�u�f�[�^���_�E�����[�h����</A><BR>
<%
    End If
%>
    <BR><BR>

    <A HREF="dmdMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̏����œ�����������">
    <%  end if  %>
    <BR><BR>

    <A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGPAYCSV"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A>

    </BLOCKQUOTE>
</FORM>
</BODY>
</HTML>