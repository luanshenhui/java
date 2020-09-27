<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       web�\����o�^(�\�����ݏ��) (Ver1.0.0)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.2.27
'�S����  �FT.Takagi@RD
'�C�����e�F���З���ǉ�
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.11
'�S����  �FT.Takagi@RD
'�C�����e�Fweb�\���f�I�v�V�����̎擾���@�ύX

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
<!-- #include virtual = "/webHains/includes/convertWebOption.inc" -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const RSVDIV_NORMAL = "1"        '�\�����݋敪(���)
Const RSVDIV_ORG    = "2"        '�\�����݋敪(�_��c��(���N�ی��g���܂��͉�Г�))
Const RSVDIV_BURDEN = "3"        '�\�����݋敪(���N�ی��g���A����)

Const SUPPORTDIV_INSURANT = "1"    '�{�l�Ƒ��敪(���(��ی���))
Const SUPPORTDIV_FAMILY   = "2"    '�{�l�Ƒ��敪(�Ƒ�(��}�{��))

'#### 2011/01/20 ADD STA TCS)Y.T ####
Const VOLUNTEER_NOT   = "0"     '�{�����e�B�A�敪(���p�Ȃ�)
Const VOLUNTEER_ITPT  = "1"     '�{�����e�B�A�敪(�ʖ�v)
Const VOLUNTEER_CARE  = "2"     '�{�����e�B�A�敪(���v)
Const VOLUNTEER_BOTH  = "3"     '�{�����e�B�A�敪(�ʖ󁕉��v)
Const VOLUNTEER_CHAIR = "4"     '�{�����e�B�A�敪(�Ԉ֎q�v)
'#### 2011/01/20 ADD END TCS)Y.T ####

Const STOMAC_XRAY   = "1"        '�݌����I�v�V����(��X��)
Const STOMAC_CAMERA = "2"        '�݌����I�v�V����(�ݓ�����)

'#### 2011/01/20 ADD STA TCS)Y.T ####
Const CHEST_XRAY   = "1"        '��������(����X��)
Const CHEST_CT     = "2"        '��������(����CT)
'#### 2011/01/20 ADD END TCS)Y.T ####

Const BREAST_XRAY      = "1"    '���[�����I�v�V����(���[X��)
Const BREAST_ECHO      = "2"    '���[�����I�v�V����(���[�����g)
Const BREAST_XRAY_ECHO = "3"    '���[�����I�v�V����(���[X���{���[�����g)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
Dim objWebRsv               'web�\����A�N�Z�X�p

'�����l
Dim dtmCslDate              '��f�N����
Dim lngWebNo                'webNo.

Dim strPerId                '�lID
Dim strFullName             '����
Dim strKanaName             '�J�i����
Dim strLastName             '(�l����)��
Dim strFirstName            '(�l����)��
Dim strLastKName            '(�l����)�J�i��
Dim strFirstKName           '(�l����)�J�i��
Dim strGender               '����
Dim strBirth                '���N����
Dim strZipNo                '�X�֔ԍ�
Dim strAddress1             '�Z��1
Dim strAddress2             '�Z��2
Dim strAddress3             '�Z��3
Dim strTel                  '�d�b�ԍ�
Dim strEMail                'e-mail
Dim strOfficeName           '�Ζ��於��
Dim strOfficeTel            '�Ζ���d�b�ԍ�
Dim strOrgName              '�_��c�̖�
Dim strRsvDiv               '�\�����݋敪(1:��ʁA2:�_��c��(���N�ی��g���܂��͉�Г�)�A3:���N�ی��g���A����)
Dim strSupportDiv           '�{�l�Ƒ��敪(1:�{�l(��ی���)�A2:�Ƒ�(��}�{��))
Dim strOptionStomac         '�݌���(0:�݂Ȃ��A1:��X���A2:�ݓ�����)
Dim strOptionBreast         '���[����(0:���[�Ȃ��A1:���[X���A2:���[�����g�A3:���[X���{���[�����g)
'#### 2011/01/20 ADD STA TCS)Y.T ####
Dim strOptionCT             '��������(1:����X���A2:����CT)
'#### 2011/01/20 ADD END TCS)Y.T ####
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
Dim strCslOptions           '��f�I�v�V����
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'#### 2017.03.20 �� WEB�\�����ݔԍ��ǉ� STR ###
Dim strWebReqNo             '�\�����ݔԍ�
'#### 2017.03.20 �� WEB�\�����ݔԍ��ǉ� END ###

Dim strMessage              '���b�Z�[�W
Dim strInsDate              '�\�����ݔN����
Dim strUpdDate              '�\�񏈗��N����
'#### 2011/01/20 ADD STA TCS)Y.T ####
Dim strIsrSign              '�ی����L��
Dim strIsrNo                '�ی����ԍ�
Dim strVolunteer            '�{�����e�B�A�敪(0:���p�Ȃ��A1:�ʖ�v�A2:���v�A3:�ʖ󁕉��v�A4:�Ԉ֎q�v)
Dim strCardOutEng           '�m�F�͂����p���o��(0:�Ȃ��A1:����)
Dim strFormOutEng           '�ꎮ�p���o��(0:�Ȃ��A1:����)
Dim strReportOutEng         '���я��p���o��(0:�Ȃ��A1:����)
'#### 2011/01/20 ADD END TCS)Y.T ####

'#### 2013.2.27 SL-SN-Y0101-612 ADD START ####
Dim strNation               '����
'#### 2013.2.27 SL-SN-Y0101-612 ADD END   ####

Dim strEditPerId            '�ҏW�p�̌lID
Dim strEditFullName         '�ҏW�p�̐���
Dim strEditKanaName         '�ҏW�p�̃J�i����
Dim strZipNo1               '�X�֔ԍ�1
Dim strZipNo2               '�X�֔ԍ�2
Dim strEditZipNo            '�ҏW�p�̗X�֔ԍ�
Dim strEditRsvDiv           '�ҏW�p�̐\�����݋敪
Dim strEditSupportDiv       '�ҏW�p�̖{�l�Ƒ��敪
Dim strEditStomac           '�ҏW�p�̈݌����I�v�V����
Dim strEditBreast           '�ҏW�p�̓��[�����I�v�V����
'#### 2011/01/20 MOD STA TCS)Y.T ####
Dim strEditChest            '�ҏW�p�̋�������
'#### 2011/01/20 MOD END TCS)Y.T ####

'#### 2011/01/20 MOD STA TCS)Y.T ####
Dim strEditVolunteer        '�ҏW�p�̃{�����e�B�A�敪
Dim strEditCardOutEng       '�ҏW�p�̊m�F�͂����p���o�͋敪
Dim strEditFormOutEng       '�ҏW�p�̈ꎮ�����p���o�͋敪
Dim strEditReportOutEng     '�ҏW�p�̐��я��p���o�͋敪
'#### 2011/01/20 MOD END TCS)Y.T ####

Dim Ret                     '�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
dtmCslDate = CDate(Request("cslDate"))
lngWebNo   = CLng("0" & Request("webNo"))

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

'web�\����ǂݍ���
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
''#### 2011/01/20 MOD STA TCS)Y.T ####
'
''Ret = objWebRsv.SelectWebRsv( _
''          dtmCslDate,         _
''          lngWebNo, , , ,     _
''          strPerId,           _
''          strFullName,        _
''          strKanaName,        _
''          strLastName,        _
''          strFirstName,       _
''          strLastKName,       _
''          strFirstKName,      _
''          strGender,          _
''          strBirth,           _
''          strZipNo,           _
''          strAddress1,        _
''          strAddress2,        _
''          strAddress3,        _
''          strTel,             _
''          strEMail,           _
''          strOfficeName,      _
''          strOfficeTel,       _
''          strOrgName,         _
''          strRsvDiv,          _
''          strSupportDiv,      _
''          strOptionStomac,    _
''          strOptionBreast,    _
''          strMessage,         _
''          strInsDate          _
''      )
'
'Ret = objWebRsv.SelectWebRsv( _
'          dtmCslDate,         _
'          lngWebNo,           _
'          ,                   _
'          ,                   _
'          ,                   _
'          strPerId,           _
'          strFullName,        _
'          strKanaName,        _
'          strLastName,        _
'          strFirstName,       _
'          strLastKName,       _
'          strFirstKName,      _
'          strGender,          _
'          strBirth,           _
'          strZipNo,           _
'          strAddress1,        _
'          strAddress2,        _
'          strAddress3,        _
'          strTel,             _
'          strEMail,           _
'          strOfficeName,      _
'          strOfficeTel,       _
'          strOrgName,         _
'          strRsvDiv,          _
'          strSupportDiv,      _
'          strOptionStomac,    _
'          strOptionBreast,    _
'          strMessage,         _
'          strInsDate,         _
'          ,                   _
'          ,                   _
'          strIsrSign,         _
'          strIsrNo,           _
'          strVolunteer,       _
'          strCardOutEng,      _
'          strFormOutEng,      _
'          strReportOutEng,    _
'          strOptionCT         _
'      )
''#### 2011/01/20 MOD END TCS)Y.T ####
'#### 2017.03.20 �� WEB�\�����ݔԍ��ǉ��擾�̈׏C�� STR ###
'Ret = objWebRsv.SelectWebRsv( _
'          dtmCslDate,         _
'          lngWebNo,           _
'          ,                   _
'          ,                   _
'          ,                   _
'          strPerId,           _
'          strFullName,        _
'          strKanaName,        _
'          strLastName,        _
'          strFirstName,       _
'          strLastKName,       _
'          strFirstKName,      _
'          strGender,          _
'          strBirth,           _
'          strZipNo,           _
'          strAddress1,        _
'          strAddress2,        _
'          strAddress3,        _
'          strTel,             _
'          strEMail,           _
'          strOfficeName,      _
'          strOfficeTel,       _
'          strOrgName,         _
'          strRsvDiv,          _
'          strSupportDiv,      _
'          strOptionStomac,    _
'          strOptionBreast,    _
'          strMessage,         _
'          strInsDate,         _
'          ,                   _
'          ,                   _
'          strIsrSign,         _
'          strIsrNo,           _
'          strVolunteer,       _
'          strCardOutEng,      _
'          strFormOutEng,      _
'          strReportOutEng,    _
'          strOptionCT, ,      _
'          strNation,          _
'          strCslOptions       _
'      )

Ret = objWebRsv.SelectWebRsv( _
          dtmCslDate,         _
          lngWebNo,           _
          ,                   _
          ,                   _
          ,                   _
          strPerId,           _
          strFullName,        _
          strKanaName,        _
          strLastName,        _
          strFirstName,       _
          strLastKName,       _
          strFirstKName,      _
          strGender,          _
          strBirth,           _
          strZipNo,           _
          strAddress1,        _
          strAddress2,        _
          strAddress3,        _
          strTel,             _
          strEMail,           _
          strOfficeName,      _
          strOfficeTel,       _
          strOrgName,         _
          strRsvDiv,          _
          strSupportDiv,      _
          strOptionStomac,    _
          strOptionBreast,    _
          strMessage,         _
          strInsDate,         _
          ,                   _
          ,                   _
          strIsrSign,         _
          strIsrNo,           _
          strVolunteer,       _
          strCardOutEng,      _
          strFormOutEng,      _
          strReportOutEng,    _
          strOptionCT, ,      _
          strNation,          _
          strCslOptions,      _
          strWebReqNo         _
      )
'#### 2017.03.20 �� WEB�\�����ݔԍ��ǉ��擾�̈׏C�� END ###

'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####

'�I�u�W�F�N�g�̉��
Set objWebRsv = Nothing

'���R�[�h�����݂��Ȃ��ꍇ�͏����I��
If Ret = False Then
    Response.End
End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>web�\����o�^(�\�����ݏ��)</TITLE>
<style type="text/css">
    body { margin: 0 0 0 8px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">�\�����ݏ��</FONT></B></TD>
    </TR>
</TABLE>
<%
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
<%'#### 2017.03.20 �� WEB�\�����ݔԍ��ǉ� STR ####%>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>�\���ԍ�</TD>
        <TD>�F</TD>
        <TD WIDTH="100%" NOWRAP><%= strWebReqNo %></TD>
    </TR>
<%'#### 2017.03.20 �� WEB�\�����ݔԍ��ǉ� END ####%>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>�\����</TD>
        <TD>�F</TD>
        <TD WIDTH="100%" NOWRAP><%= objCommon.FormatString(CDate(strInsDate), "yyyy�Nm��d�� hh:nn:ss") %></TD>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR VALIGN="bottom">
        <TD>����</TD>
        <TD>�F</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
<%
                    '�����ɂ��ẮA�lID���ݎ��͌l��񂩂�A�����Ȃ���web�\���񂩂�擾
                    If strPerId <> "" Then
                        strEditPerId    = strPerId
                        strEditFullName = Trim(strLastName  & "�@" & strFirstName)
                        strEditKanaName = Trim(strLastKName & "�@" & strFirstKName)
                        If strEditFullName = "" Then
                            strEditFullName = strFullName
                        End If
                        If strEditKanaName = "" Then
                            strEditKanaName = strKanaName
                        End If
                    Else
                        strEditPerId    = PERID_FOR_NEW_PERSON
                        strEditFullName = strFullName
                        strEditKanaName = strKanaName
                    End If
%>
                    <TD VALIGN="bottom" NOWRAP><%= strEditPerId %></TD>
                    <TD>&nbsp;</TD>
                    <TD><FONT SIZE="1"><%= strEditKanaName %><BR></FONT><%= strEditFullName %></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
        <TD></TD>
        <TD></TD>
        <TD><%= objCommon.FormatString(CDate(strBirth), "ge�iyyyy�j.m.d") %>��&nbsp;&nbsp;<%= IIf(CLng(strGender) = GENDER_MALE, "�j��", "����") %></TD>
    </TR>
<%
    '�I�u�W�F�N�g�̉��
    Set objCommon = Nothing
%>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR VALIGN="top">
        <TD NOWRAP>����Z��</TD>
        <TD>�F</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR VALIGN="top">
<%
                    '�X�֔ԍ��w�莞�̂ݗ��\��
                    If strZipNo <> "" Then

                        strZipNo1 = Left(strZipNo, 3)
                        strZipNo2 = Mid(strZipNo, 4, 4)
                        strEditZipNo = strZipNo1 & IIf(strZipNo2 <> "", "-", "") & strZipNo2
%>
                        <TD NOWRAP><%= strEditZipNo %></TD>
                        <TD>&nbsp;</TD>
<%
                    End If
%>
                    <TD><%= strAddress1 & strAddress2 & strAddress3 %></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
        <TD>TEL</TD>
        <TD>�F</TD>
        <TD><%= strTel %></TD>
    </TR>
    <TR>
        <TD>e-mail</TD>
        <TD>�F</TD>
        <TD><%= strEMail %></TD>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>�Ζ���</TD>
        <TD>�F</TD>
        <TD><%= strOfficeName %></TD>
    </TR>
    <TR>
        <TD>TEL</TD>
        <TD>�F</TD>
        <TD><%= strOfficeTel %></TD>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
<% '#### 2013.2.27 SL-SN-Y0101-612 ADD START #### %>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    </TR>
        <TD>����</TD>
        <TD>�F</TD>
        <TD><%= strNation %></TD>
    </TR>
<% '#### 2013.2.27 SL-SN-Y0101-612 ADD END   #### %>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD NOWRAP>�\���c��</TD>
        <TD>�F</TD>
        <TD><%= strOrgName %></TD>
    </TR>
    <TR>
        <TD>�敪</TD>
        <TD>�F</TD>
<%
        '�\�����݋敪�̖��̕ϊ�
        Select Case strRsvDiv
            Case RSVDIV_NORMAL
                strEditRsvDiv = "���"
            Case RSVDIV_ORG
                strEditRsvDiv = "�_��c��"
            Case RSVDIV_BURDEN
                strEditRsvDiv = "���N�ی��g���A����"
        End Select

        '�{�l�Ƒ��敪�̖��̕ϊ�
        Select Case strSupportDiv
            Case SUPPORTDIV_INSURANT
                strEditSupportDiv = "�{�l�i��ی��ҁj"
            Case SUPPORTDIV_FAMILY
                strEditSupportDiv = "�Ƒ��i��}�{�ҁj"
        End Select
%>
        <TD NOWRAP><%= strEditRsvDiv & IIf(strEditRsvDiv <> "" And  strEditSupportDiv <> "", "&nbsp;&nbsp;", "") & strEditSupportDiv %></TD>
    </TR>
<% '#### 2011/01/20 ADD STA TCS)Y.T #### %>

    <TR>
        <TD NOWRAP>�ی��؋L��</TD>
        <TD>�F</TD>
        <TD><%= strIsrSign %></TD>
    </TR>
    <TR>
        <TD NOWRAP>�ی��ؔԍ�</TD>
        <TD>�F</TD>
        <TD><%= strIsrNo %></TD>
    </TR>

<%
        '�{�����e�B�A�敪�ϊ�
        Select Case strVolunteer
            Case VOLUNTEER_NOT
                strEditVolunteer = "���p�Ȃ�"
            Case VOLUNTEER_ITPT
                strEditVolunteer = "�ʖ�v"
            Case VOLUNTEER_CARE
                strEditVolunteer = "���v"
            Case VOLUNTEER_BOTH
                strEditVolunteer = "�ʖ󁕉��v"
            Case VOLUNTEER_CHAIR
                strEditVolunteer = "�Ԉ֎q�v"
        End Select
%>
    <TR>
        <TD NOWRAP>�{�����e�B�A</TD>
        <TD>�F</TD>
        <TD><%= strEditVolunteer %></TD>
    </TR>

<%
        '�m�F�͂����p���o�͋敪�̖��̕ϊ�
        Select Case strCardOutEng
            Case "0"
                strEditCardOutEng = "��"
            Case "1"
                strEditCardOutEng = "�L"
        End Select

        '�ꎮ�����p���o�͋敪�̖��̕ϊ�
        Select Case strFormOutEng
            Case "0"
                strEditFormOutEng = "��"
            Case "1"
                strEditFormOutEng = "�L"
        End Select

        '���я��p���o�͋敪�̖��̕ϊ�
        Select Case strReportOutEng
            Case "0"
                strEditReportOutEng = "��"
            Case "1"
                strEditReportOutEng = "�L"
        End Select
%>
    <TR>
        <TD NOWRAP>�m�F�͂����p���o��</TD>
        <TD>�F</TD>
        <TD><%= strEditCardOutEng %></TD>
    </TR>
    <TR>
        <TD NOWRAP>�ꎮ�����p���o��</TD>
        <TD>�F</TD>
        <TD><%= strEditFormOutEng %></TD>
    </TR>
    <TR>
        <TD NOWRAP>���ѕ\�p���o��</TD>
        <TD>�F</TD>
        <TD><%= strEditReportOutEng %></TD>
    </TR>
<% '#### 2011/01/20 ADD END TCS)Y.T #### %>

    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR><TD COLSPAN="3" BGCOLOR="#999999"></TD></TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR VALIGN="top">
        <TD>�Z�b�g</TD>
        <TD>�F</TD>
<%
        '�݌����̖��̕ϊ�
        Select Case strOptionStomac
            Case STOMAC_XRAY
                strEditStomac = "�݂w��"
            Case STOMAC_CAMERA
                strEditStomac = "�ݓ�����"
        End Select

'#### 2011/01/20 ADD STA TCS)Y.T ####
        '���������̖��̕ϊ�
        Select Case strOptionCT
'����CT�̂ݕ\��
'            Case CHEST_XRAY
'                strEditChest = "�����w��"
            Case CHEST_CT
                strEditChest = "�����b�s"
        End Select
'#### 2011/01/20 ADD END TCS)Y.T ####

        '���[�����̖��̕ϊ�
        Select Case strOptionBreast
            Case BREAST_XRAY
                strEditBreast = "���[�w��"
            Case BREAST_ECHO
                strEditBreast = "���[�����g"
            Case BREAST_XRAY_ECHO
                strEditBreast = "���[�w���E���[�����g"
        End Select
%>
<% '#### 2011/01/20 MOD STA TCS)Y.T #### %>
<%
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
        '��f�I�v�V�����R�[�h�̃J���}���������񂪑��݂���ꍇ�͂��̓��e�����ƂɃI�v�V��������\��
        If strCslOptions <> "" Then
%>
            <TD NOWRAP><%= Join(ToMapWebOptName(strCslOptions), "<BR>") %></TD>
<%
        Else
'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####
%>
        <!--TD NOWRAP><%= strEditStomac & IIf(strEditStomac <> "" And strEditBreast <> "", "�A", "") & strEditBreast %></TD-->
        <TD NOWRAP><%= strEditStomac & IIf(strEditStomac <> "" And strEditBreast <> "", "�A", "") & strEditBreast & IIf((strEditStomac <> "" or strEditBreast <> "") And strEditChest <> "", "�A", "") & strEditChest %></TD>
<%
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
        End If
'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####
%>
<% '#### 2011/01/20 MOD END TCS)Y.T #### %>
    </TR>
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
    <TR><TD BGCOLOR="#999999"></TD></TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TD>�\�񎞃��b�Z�[�W�F</TD>
    </TR>
    <TR>
        <TD><%= strMessage %></TD>
    </TR>
</TABLE>
</BODY>
</HTML>
