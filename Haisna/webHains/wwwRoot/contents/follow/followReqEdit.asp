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
Const PRT_DIV       = 1         '�l�����ށF�˗���

'### 2016.01.23 �� �q�{�򕔍זE�f�x�Z�X�_���ނƂg�o�u���ʎ擾�̈גǉ� STR ###
Const ITEM_BETHESDA     = "27050"   '�x�Z�X�_����
Const ITEM_HPV          = "59510"   '�g�o�u
'### 2016.01.23 �� �q�{�򕔍זE�f�x�Z�X�_���ނƂg�o�u���ʎ擾�̈גǉ� END ###

'### 2016.11.10 �� ���[�������ʎ擾�̈גǉ� STR ###
Const ITEM_MMG_CATE     = "27770"   '���[�w���J�e�S���[
Const ITEM_BECHO_CATE   = "28700"   '���[�����g�J�e�S���[
Const ITEM_BECHO_OBS    = "28820"   '���[�����g����
Const ITEM_BREAST_PAL   = "27520"   '���[�G�f
'### 2016.11.10 �� ���[�������ʎ擾�̈גǉ� END ###

Dim strMode             '������[�h
Dim strAction           '�������(�ۑ��{�^��������:"save")
Dim strMessage          '�ʒm���b�Z�[�W
Dim vntMessage          '�ʒm���b�Z�[�W

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objFollow           '�t�H���[�A�b�v�A�N�Z�X�p
Dim objConsult          '��f�N���X
Dim objFree             '�ėp�}�X�^�[�A�N�Z�X�p
Dim objHainsUser        '���[�U�[�A�N�Z�X�p
'�p�����[�^
Dim lngRsvNo            '�\��ԍ�
Dim lngJudClassCd       '���蕪�ރR�[�h
Dim strJudClassName     '���f���ޖ�
Dim strJudCd            '����R�[�h
Dim strRslJudCd         '�ŏI����R�[�h

Dim strSecEquipName     '�a��@��
Dim strSecEquipCourse   '�f�ÉȖ�
Dim strSecDoctor        '�S����t
Dim strSecEquipAddr     '�Z��
Dim strSecEquipTel      '�d�b�ԍ�

'��f���p�ϐ�
Dim Ret                 '���A�l
Dim strCslDate          '��f��
Dim strPerId            '�lID
Dim strAge              '��f�N��
Dim strRealAge          '���N��
Dim strDayId            '����ID
Dim strLastName         '��
Dim strFirstName        '��
Dim strLastKName        '�J�i��
Dim strFirstKName       '�J�i��
Dim strBirth            '���N����
Dim strGender           '����

Dim strName             '����
Dim strKname            '�J�i����
Dim strUserId           '���[�UID
Dim strUserName         '���[�U��

'�˗����e
Dim strFolItem          '�f�f�E�˗�����
Dim strFolNote          '����

'Dim strArrMessage       '�G���[���b�Z�[�W
Dim vntArrMessage       '�G���[���b�Z�[�W
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon     = Server.CreateObject("HainsCommon.Common")
Set objFollow     = Server.CreateObject("HainsFollow.Follow")
Set objConsult    = Server.CreateObject("HainsConsult.Consult")
Set objHainsUser  = Server.CreateObject("HainsHainsUser.HainsUser")

'�p�����[�^�l�̎擾
strMode           = Request("mode")
strAction         = Request("act")

lngRsvNo          = Request("rsvno")
lngJudClassCd     = Request("judClassCd")
strJudClassName   = Request("judClassName")
strJudCd          = Request("judCd")
strRslJudCd       = Request("rslJudCd")

strSecEquipName   = Request("secEquipName")
strSecEquipCourse = Request("secEquipCourse")
strSecDoctor      = Request("secDoctor")
strSecEquipAddr   = Request("secEquipAddr")
strSecEquipTel    = Request("secEquipTel")

strUserId         = Session("USERID")

strFolItem        = Request("folItem")
strFolNote        = Request("folNote")

strCslDate        = Request("cslDate")
strPerId          = Request("perId")
strAge            = Request("age")
strRealAge        = Request("realAge")
strDayId          = Request("dayId")
strName           = Request("name")
strKname          = Request("kName")
strBirth          = Request("birth")
strGender         = Request("gender")

Do
    If strAction <> "save" Then
        '### �t�H���[�A�b�v���擾
        objFollow.SelectFollow_Info lngRsvNo,         lngJudClassCd, _
                                    strJudClassName,  strJudCd, _
                                    strRslJudCd, , , , , , strSecEquipName, _
                                    strSecEquipCourse, strSecDoctor, _
                                    strSecEquipAddr, strSecEquipTel

        '��f��񌟍�
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        strCslDate,    _
                                        strPerId,      _
                                        , , , , , , , _
                                        strAge, _
                                        , , , , , , , , , , , , _
                                        strDayId,   _
                                        , , 0, , , , , , , , , , , , , , , _
                                        strLastName,   _
                                        strFirstName,  _
                                        strLastKName,  _
                                        strFirstKName, _
                                        strBirth,      _
                                        strGender _
                                       )

        '��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
        If Ret = False Then
            Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
        End If

        '���N��̌v�Z
        If strBirth <> "" Then
            Set objFree = Server.CreateObject("HainsFree.Free")
            strRealAge = objFree.CalcAge(strBirth, strCslDate)
            Set objFree = Nothing
        Else
            strRealAge = ""
        End If

        '�����_�ȉ��̐؂�̂�
        If IsNumeric(strRealAge) Then
            strRealAge = CStr(Int(strRealAge))
        End If

        If strLastName <> "" and strFirstName <> "" Then
            strName = strLastName & "�@" & strFirstName
        End If

        If strLastKName <> "" and strFirstKName <> "" Then
            strKname = strLastKName & "�@" & strFirstKName
        End If

    Else
        '���̓`�F�b�N
        'strArrMessage = CheckValue()
        vntArrMessage = CheckValue()

        'If Not IsEmpty(strArrMessage) Then
        If Not IsEmpty(vntArrMessage) Then
            Exit Do
        End If

    End If

    '���[�U���擾
    objHainsUser.SelectHainsUser strUserId, strUserName

    Exit Do
Loop


'### 2016.01.23 �� �q�{�򕔍זE�f�̏ꍇ�A�q�{�򕔍זE�f�x�Z�X�_���ނƂg�o�u���ʂ��f�t�H���g�ŕ\���i�L�ځjSTR ###
If lngJudClassCd = 31 and Trim(strFolNote) = "" Then

    strFolNote = ""
    strFolNote = strFolNote & "�� �q�{�򕔍זE�f �x�Z�X�_���ށ@�F�@" & objFollow.GetResult(lngRsvNo, ITEM_BETHESDA) & vbLf
    strFolNote = strFolNote & "�� �g�o�u�@�F�@" & objFollow.GetResult(lngRsvNo, ITEM_HPV) & vbLf

'### 2016.11.10 �� ���[�̏ꍇ���ʂ��f�t�H���g�ŕ\���i�L�ځjSTR ###
ElseIf lngJudClassCd = 24 and Trim(strFolNote) = "" Then

    strFolNote = ""
    strFolNote = strFolNote & "�� ���[�w���@�F�@" & objFollow.GetResult(lngRsvNo, ITEM_MMG_CATE) & vbLf
    strFolNote = strFolNote & "�� ���[�����g�F�@" & objFollow.GetResult(lngRsvNo, ITEM_BECHO_CATE) & objFollow.GetResult(lngRsvNo, ITEM_BECHO_OBS) & vbLf
    '### 2017.12.12 �� ���[�G�f�����p�~�ɔ����ē��[�G�f���ڍ폜 STR ##########################################
    'strFolNote = strFolNote & "�� ���[�G�f�@�F�@" & objFollow.GetResult(lngRsvNo, ITEM_BREAST_PAL) & vbLf
    '### 2017.12.12 �� ���[�G�f�����p�~�ɔ����ē��[�G�f���ڍ폜 END ##########################################

    '### �f�t�H���g�f�ÉȐݒ� ###
    If Trim(strSecEquipCourse) = "" Then
        strSecEquipCourse = "���B�O��"
    End If
'### 2016.11.10 �� ���[�̏ꍇ���ʂ��f�t�H���g�ŕ\���i�L�ځjEND ###

End If
'### 2016.01.23 �� �q�{�򕔍זE�f�̏ꍇ�A�q�{�򕔍זE�f�x�Z�X�_���ނƂg�o�u���ʂ��f�t�H���g�ŕ\���i�L�ځjEND ###


'���[�o�͏�������
vntMessage = PrintControl(strMode, lngRsvNo, lngJudClassCd, PRT_DIV)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

End Sub

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

    Dim vntArrMessage  '�G���[���b�Z�[�W�̏W��
        
        With objCommon

        '���l(���s������1���Ƃ��Ċ܂ގ|��ʒB)
        strMessage = .CheckWideValue("�f�f�E�˗�����", strFolItem, 120, CHECK_NECESSARY)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '���l(���s������1���Ƃ��Ċ܂ގ|��ʒB)
        strMessage = .CheckWideValue("����", strFolNote, 400)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�a��@��
        strMessage = .CheckWideValue("�a��@��", strSecEquipName, 50)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�f�É�
        strMessage = .CheckWideValue("�f�É�", strSecEquipCourse, 50, CHECK_NECESSARY)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�S����t
        strMessage = .CheckWideValue("�S����t", strSecDoctor, 40)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If
        
        '�Z��
        strMessage = .CheckLength("�Z��", strSecEquipAddr, 120)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�d�b�ԍ�
        strMessage = .CheckLength("�d�b�ԍ�", strSecEquipTel, 15)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

    End With

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �˗���h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ : ���[�h�L�������g�t�@�C���쐬���\�b�h���Ăяo���B���\�b�h���ł͎��̏������s����B
' �@�@�@�@   ?@������O���̍쐬
' �@�@�@�@   ?A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   ?B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
    Function Print()

'    Dim objCommon
    Dim objPrintCls '�˗���o�͗pCOM�R���|�[�l���g
    Dim Ret         '�֐��߂�l
    Dim strURL

    If Not IsArray(CheckValue()) Then

        '���R�����΍��p���O�����o��
        Call putPrivacyInfoLog("PH042", "�t�H���[�A�b�v �˗���̈�����s����")

    Set objPrintCls    = Server.CreateObject("HainsRequestCard.RequestCard")

        Ret = objPrintCls.PrintOut(strUserId, strUserName, lngRsvNo, lngJudClassCd, strJudClassName, PRT_DIV, strSecEquipName, strSecEquipCourse, strSecDoctor, _
              strSecEquipAddr, strSecEquipTel, strCslDate, strPerId, strRealAge, strDayId, strName, strKname, strBirth, strGender, strFolItem, strFolNote)

        print = Ret

    End If

    End Function
'---------------------------------------------------------------------------------------------------------------------------------------------------------------------
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�˗���쐬</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

    function submitForm() {
        with ( document.requestForm ) {
            act.value = 'save';
            submit();
        }
    }

    function clear() {
        with(document.requestForm) {

            folItem.value = "";
            folNote.value = "";
        }
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�˗���쐬</FONT></B></TD>
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
<FORM NAME="requestForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

    <INPUT TYPE="hidden" NAME="act"             VALUE="">
    <INPUT TYPE="hidden" NAME="rsvno"           VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden" NAME="judClassName"    VALUE="<%= strJudClassName %>">
    <INPUT TYPE="hidden" NAME="judCd"           VALUE="<%= strJudCd %>">
    <INPUT TYPE="hidden" NAME="rslJudCd"        VALUE="<%= strRslJudCd %>">
    <INPUT TYPE="hidden" NAME="cslDate"         VALUE="<%= strCslDate %>">
    <INPUT TYPE="hidden" NAME="perId"           VALUE="<%= strPerId %>">
    <INPUT TYPE="hidden" NAME="dayId"           VALUE="<%= strDayId %>">
    <INPUT TYPE="hidden" NAME="name"            VALUE="<%= strName %>">
    <INPUT TYPE="hidden" NAME="kName"           VALUE="<%= strKname %>">
    <INPUT TYPE="hidden" NAME="gender"          VALUE="<%= strGender %>">
    <INPUT TYPE="hidden" NAME="realAge"         VALUE="<%= strRealAge %>">
    <INPUT TYPE="hidden" NAME="age"             VALUE="<%= strAge %>">
    <INPUT TYPE="hidden" NAME="birth"           VALUE="<%= strBirth %>">
<%
    If strAction <> "" Then
        'Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
        Call EditMessage(vntArrMessage, MESSAGETYPE_WARNING)
    End If
%>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR align="center">
                        <TD BGCOLOR="#cccccc" width="120" HEIGHT="22">���f����</TD>
                        <TD BGCOLOR="#eeeeee" width="120"><B><%= strJudClassName %></B></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD BGCOLOR="#cccccc" width="120">����</TD>
                        <TD BGCOLOR="#eeeeee" width="160"><%= strJudCd %>&nbsp;&nbsp;(&nbsp;�ŏI����&nbsp;�F&nbsp;<%= strRslJudCd %>&nbsp;)</TD>
                    </TR>
                </TABLE>
            </TD>
            <TD width="300" align="right">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">

            <!--- ������[�h -->
            <%
                '������[�h�̏����ݒ�
                strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
            %>
                <INPUT TYPE="hidden" NAME="mode" VALUE="<%=strMode%>">

                    <TR align="right">
                        <%  If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then   %>

                        <TD ALIGN="right">&nbsp;<A HREF="javascript:submitForm();"><IMG SRC="/webHains/images/prtSave.gif" WIDTH="77" HEIGHT="24" ALT="�˗���쐬"></A>
                        <A HREF="javascript:clear();"><IMG SRC="/webHains/images/clear.gif" WIDTH="77" HEIGHT="24" ALT="�N���A"></A></TD>
                        <TD>&nbsp;</TD>
                        <% End If %>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�˗����e</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;�f�f�E�˗�����</TD>
                        <%'### 2016.11.09 �� ���[�̏ꍇ���蕪�ޖ��̂̃f�t�H���g�\�����u���[�ُ폊���v�ɕύX STR ### %>
                        <!--TD><TEXTAREA NAME="folItem" style="ime-mode:active"  COLS="80" ROWS="2"><%= IIf(strFolItem = "",strJudClassName, strFolItem) %></TEXTAREA></TD-->
                        <TD><TEXTAREA NAME="folItem" style="ime-mode:active"  COLS="80" ROWS="2"><%= IIf(strFolItem = "",IIF(lngJudClassCd = 24, "���[�ُ폊��", strJudClassName), strFolItem) %></TEXTAREA></TD>
                        <%'### 2016.11.09 �� ���[�̏ꍇ���蕪�ޖ��̂̃f�t�H���g�\�����u���[�ُ폊���v�ɕύX END ### %>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;����</TD>
                        <TD>
                            <TEXTAREA NAME="folNote" style="ime-mode:active"  COLS="80" ROWS="12"><%= strFolNote %></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��Ë@��</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�a��@��</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipName" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipName %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�f�É�</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipCourse" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipCourse %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;�S����t</TD>
                        <TD><INPUT TYPE="text" NAME="secDoctor" SIZE="50" MAXLENGTH="40" VALUE="<%= strSecDoctor %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;�Z��</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipAddr" SIZE="100" MAXLENGTH="120" VALUE="<%= strSecEquipAddr %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;�d�b�ԍ�</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipTel" SIZE="50" MAXLENGTH="15" VALUE="<%= strSecEquipTel %>" STYLE="ime-mode:inactive;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
