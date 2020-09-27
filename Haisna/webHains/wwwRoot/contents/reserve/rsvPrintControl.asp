<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        ������� (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checksession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objConsult          '��f���A�N�Z�X�p

Dim strMode             '���[�h("0":�͂����A"1":�ꎮ����)
Dim strActMode          '���샂�[�h("0":�ۑ��A"1":���)
Dim strRsvNo            '�\��ԍ�
Dim strAddrDiv          '�Z���敪
Dim strOutEng           '�p���o�̗͂L��

Dim strCardPrintDate    '�m�F�͂����o�͓���
Dim strFormPrintDate    '�ꎮ�����o����
Dim strURL              'URL

Dim Ret                 '�֐��߂�l
Dim strCsCd             '�R�[�X�R�[�h

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strMode    = Request("mode")
strActMode = Request("actMode")
strRsvNo   = Request("rsvNo")
strAddrDiv = Request("addrDiv")
strOutEng  = Request("outEng")

'## 2015.05.08 �� ���f�B���[�J�X�̗\�񎞈������͂����₲�ē����͕ʓr�Ǘ��̈׏C�� START ##############
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'������[�h�̏ꍇ�͏o�͓��X�V������s��
'(�ۑ����[�h�����ƕۑ���̗\���ʍĕ\���Ƃ̃^�C�����O���C�ɂȂ�̂ŃX�g�A�h�ɔC����)
If strActMode = "1" And strMode = "1" Then

    '�I�u�W�F�N�g�̃C���X�^���X�쐬

    '## 2015.05.08 �� ���f�B���[�J�X�̗\�񎞈������͂����₲�ē����͕ʓr�Ǘ��̈׏C��  ##
    'Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '��f���e�[�u�����R�[�h�Ǎ��ݏ���
    objConsult.SelectConsultPrintStatus strRsvNo, strCardPrintDate, strFormPrintDate
    
    '���[�h���Ƃ̏����B�ΏۂƂȂ钠�[�̈�����������݂��Ȃ��ꍇ�ɃV�X�e���������X�V����B
    Select Case strMode
        Case "0"
            strCardPrintDate = IIf(strCardPrintDate = "", Now(), strCardPrintDate)
        Case "1"
            strFormPrintDate = IIf(strFormPrintDate = "", Now(), strFormPrintDate)
    End Select

    '��������̍X�V
    objConsult.UpdateConsultPrintStatus strRsvNo, strCardPrintDate, strFormPrintDate

    '## 2015.05.08 �� ���f�B���[�J�X�̗\�񎞈������͂����₲�ē����͕ʓr�Ǘ��̈׏C��  ##
    'Set objConsult = Nothing

End If

'��f����ǂ݁A���݂̃R�[�X�R�[�h���擾
Ret = objConsult.SelectConsult(strRsvNo, , , ,strCsCd)
Set objConsult = Nothing

'## 2015.05.08 �� ���f�B���[�J�X�̗\�񎞈������͂����₲�ē����͕ʓr�Ǘ��̈׏C�� END   ##############



'����pASP�ɐ�����ڂ�
Do

    '���[�h���Ƃ̌Ăѐ�URL��`

'## 2015.05.08 �� ���f�B���[�J�X�̗\�񎞈������͂����₲�ē����͕ʓr�Ǘ� START ##
'    Select Case strMode
'        Case "0"
'            strURL = "/webHains/contents/report_form/hagaki.asp"
'        Case "1"
'            strURL = "/webHains/contents/report_form/annaisho.asp"
'        Case Else
'            Exit Do
'    End Select

    If Left(strCsCd, 1) = "M" Then
        '���f�B���[�J�X�֘A�R�[�X�̏ꍇ�A�ʓr�l���ň��
        Select Case strMode
            Case "0"
                strURL = "/webHains/contents/report_form/mHagaki.asp"
            Case "1"
                strURL = "/webHains/contents/report_form/mAnnaisho.asp"
            Case Else
                Exit Do
        End Select
    Else
        Select Case strMode
            Case "0"
                strURL = "/webHains/contents/report_form/hagaki.asp"
            Case "1"
                strURL = "/webHains/contents/report_form/annaisho.asp"
            Case Else
                Exit Do
        End Select
    End If

'## 2015.05.08 �� ���f�B���[�J�X�̗\�񎞈������͂����₲�ē����͕ʓr�Ǘ� END   ##


    '�\��ԍ�
    strURL = strURL & "?p_rsvNo=" & strRsvNo

    '���샂�[�h
    If strActMode = "1" Then
        strURL = strURL & "&p_act=print"
    Else
        strURL = strURL & "&p_act=save"
    End If

    '�Z���敪
    Select Case strAddrDiv
        Case "1"
            strURL = strURL & "&p_addrdiv=house"
        Case "2"
            strURL = strURL & "&p_addrdiv=company"
        Case "3"
            strURL = strURL & "&p_addrdiv=etc"
    End Select

    '�p���L��
    Select Case strOutEng
        Case "1"
            strURL = strURL & "&p_engdiv=eng"
        Case "0"
            strURL = strURL & "&p_engdiv=jap"
    End Select

    Response.Redirect strURL
    Response.End

    Exit Do
Loop
%>
