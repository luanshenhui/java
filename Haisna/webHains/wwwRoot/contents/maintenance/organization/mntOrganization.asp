<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �c�̏�񃁃��e�i���X(���C�����) (Ver0.0.1)
'       AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditEraYearList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc"   -->
<!-- #include virtual = "/webHains/includes/EditIsrDivList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFree         '�ėp���A�N�Z�X�p
Dim objOrganization '�c�̏��A�N�Z�X�p

Dim strMode         '�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction       '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget       '�^�[�Q�b�g���URL
Dim strOrgCd1       '�c�̃R�[�h1
Dim strOrgCd2       '�c�̃R�[�h2
Dim strDelFlg       '�g�p�����
Dim strOrgKName     '�c�̃J�i��
Dim strOrgName      '�c�̖�
Dim strOrgEName     '�c�̖��p��
Dim strOrgSName     '�c�̗���

CONST strKeyOrgDivCd = "ORGDIV"
Dim strOrgDivCd     '�c�̎�ʃR�[�h
Dim strArrOrgDivCd  '�c�̎�ʃR�[�h�i�z��j
Dim strArrOrgDivCdName '�c�̎�ʖ��i�z��j

Dim strAddrDiv      '�Z���敪
Dim strZipCd        '�X�֔ԍ�
Dim strZipCd1       '�X�֔ԍ�1
Dim strZipCd2       '�X�֔ԍ�2
Dim strPrefCd       '�s���{���R�[�h
Dim strPrefName     '�s���{����
Dim strCityName     '�s�撬����
Dim strAddress1     '�Z��1
Dim strAddress2     '�Z��2
Dim strTel          '�d�b�ԍ���\
Dim strDirectTel    '�d�b�ԍ�����
Dim strExtension    '����
Dim strFax          '�e�`�w
Dim strEMail        'E-Mail�A�h���X
Dim strUrl          '�t�q�k
Dim strChargeName   '�S���Ҏ���
Dim strChargeKName  '�S���҃J�i��
Dim strChargeEmail  '�S����E-Mail�A�h���X
Dim strChargePost   '�S���ҕ�����
Dim strChargeOrgName '�c�̖�
Dim strBank         '��s��
Dim strBranch       '�x�X��
Dim strAccountKind  '�������
Dim strAccountNo    '�����ԍ�
Dim strNumEmp       '�Ј���
Dim strAvgAge       '���ϔN��
Dim strVisitDate    '����K��\���
Dim strPresents     '�N�n�E�����E�Ε�
Dim strDM           '�c�l
Dim strSendMethod   '���M���@

Dim strPostCard         '�m�F�͂����L��
Dim strArrPostCard()    '�m�F�͂����L���i�z��j
Dim strArrPostCardName()'�m�F�͂����L�����i�z��j
Const postCardCount = 2 '�m�F�͂����L����

Dim strSendGuid         '�ꊇ���t�ē�
Dim strArrSendGuid()    '�ꊇ���t�ē��i�z��j
Dim strArrSendGuidName()'�ꊇ���t�ē����i�z��j
Const sendGuidCount = 2 '�ꊇ���t�ē���

Dim strTicket           '���p��
Dim strArrTicket()      '���p���i�z��j
Dim strArrTicketName()  '���p�����i�z��j
Const ticketCount = 2   '���p����
Dim strNoPrintLetter    '1�N�ڂ͂����o��
Dim strInsCheck     '�ی��ؗ\�񎞊m�F
Dim strInsBring     '�ی��ؓ������Q
Dim strInsReport    '�ی��ؐ��я��o��
Dim strBillAddress  '�������K�p�Z��
Dim strBillCslDiv   '�������{�l�Ƒ��敪�o��
Dim strBillIns      '�������ی��؏��o��
Dim strBillEmpNo    '�������Ј��ԍ��o��
Dim strBillReport   '���������я��Y�t
Dim strBillFD       '������FD����
'## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ� Start ##
Dim strBillSpecial  '���������茒�f���|�[�g
'## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ� End   ##

'## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� Start ##
Dim strBillAge       '�������N��
'## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� End   ##

Dim strSendComment  '���t�ē��R�����g
Dim strSendEComment '�p�ꑗ�t�ē��R�����g
Dim strSpare(2)     '�\��
Dim strNotes        '���L����
Dim strDmdComment   '�����֘A�R�����g
Dim strUpdDate      '�X�V����
Dim strUpdUser      '�X�V��
Dim strSelectedDate '�N����
Dim strDateStart    '�J�n�N

Dim strTicketDiv    '���p���敪
Dim strTicketAddBill    '���p���������Y�t
Dim strTicketCenterCall '���p���Z���^�[���A��
Dim strTicketperCall    '���p���{�l���A��
Dim strCtrptDate        '�_����t
Dim strCtrptYear        '�_����t�i�N�j
Dim strCtrptMonth       '�_����t�i���j
Dim strCtrptDay         '�_����t�i���j

Dim strUserName     '�X�V�Җ�
Dim strRoundNoTaxFlg    '�܂�ߋ�����Ŕ�v�Z�t���O
Dim strIsrGetName   '���ۖ��̍����Ώ�
Dim blnOpAnchor     '����p�A���J�[����
Dim strSpareName(2) '�\���̕\������
Dim strFreeName     '�ėp��
Dim strArrMessage   '�G���[���b�Z�[�W
Dim Ret             '�֐��߂�l
Dim i               '�C���f�b�N�X
Dim objOrgBillClass     '�c�̐��������ރA�N�Z�X�p
Dim strOrgBillName      '�������p����
Dim strArrBillClassCd   '���������ށi�\���p�j
Dim strArrBillClassName '���������i�\���p�j
Dim strArrOrgCd         '�c�̃R�[�h�i�\���p�j

Dim strWkNum            '�ԍ��S�p�ҏW�p���[�N

'## 2004.01.29 Add By T.Takagi@FSIT ���ڒǉ�
Dim strReptCslDiv   '���я��{�l�Ƒ��敪�o��
'## 2004.01.29 Add End
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBillClass = Server.CreateObject("HainsOrgBillClass.OrgBillClass")

'�����l�̎擾
strMode        = Request("mode")
strAction      = Request("act")
strTarget      = Request("target")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strDelFlg      = Request("delFlg")
strOrgKName    = Request("orgKName")
strOrgEName    = Request("orgEName")
strOrgName     = Request("orgName")
strOrgSName    = Request("orgSName")
strZipCd       = ConvIStringToArray(Request("zipCd"))
strZipCd1      = Request("zipCd1")
strZipCd2      = Request("zipCd2")
strPrefCd      = ConvIStringToArray(Request("prefCd"))
strCityName    = ConvIStringToArray(Request("cityName"))
strAddress1    = ConvIStringToArray(Request("address1"))
strAddress2    = ConvIStringToArray(Request("address2"))
strTel         = ConvIStringToArray(Request("tel"))
strDirectTel   = ConvIStringToArray(Request("directTel"))
strExtension   = ConvIStringToArray(Request("extension"))
strFax         = ConvIStringToArray(Request("fax"))
strEMail       = ConvIStringToArray(Request("eMail"))
strUrl	       = ConvIStringToArray(Request("url"))
strChargeName  = ConvIStringToArray(Request("chargeName"))
strChargeKName = ConvIStringToArray(Request("chargeKName"))
strChargeEmail = ConvIStringToArray(Request("chargeEmail"))
strChargePost  = ConvIStringToArray(Request("chargePost"))
strChargeOrgName = ConvIStringToArray(Request("chargeOrgName"))
strBank        = Request("bank")
strBranch      = Request("branch")
strAccountKind = Request("accountKind")
strAccountNo   = Request("accountNo")
strNumEmp      = Request("numEmp")
strAvgAge      = Request("avgAge")
strVisitDate   = Request("visitDate")
strPresents    = Request("presents")
strDM          = Request("dm")
strSendMethod  = Request("sendMethod")
strPostCard    = Request("postcard")
strSendGuid    = Request("sendguid")
strTicket      = Request("ticket")
strNoPrintLetter = Request("noPrintLetter")
'## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ� Start ##
strBillSpecial = Request("billSpecial")
'## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ� End   ##
strInsCheck    = Request("insCheck")
strInsBring    = Request("insBring")
strInsReport   = Request("insReport")
strBillAddress = Request("billAddress")
strBillCslDiv  = Request("billCslDiv")
strBillIns     = Request("billIns")
strBillEmpNo   = Request("billEmpNo")
strBillReport  = Request("billReport")
strBillFD      = Request("billFD")
'## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� Start ##
strBillAge     = Request("billAge")
'## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� End   ##
strSendComment = Request("sendComment")
strSendEComment= Request("sendEComment")
strSpare(0)    = Request("spare1")
strSpare(1)    = Request("spare2")
strSpare(2)    = Request("spare3")
strNotes       = Request("notes")
strDmdComment  = Request("dmdComment")
strUpdDate     = Request("updDate")
strUpdUser     = Request("updUser")
strTicketDiv        = Request("ticketDiv")
strTicketAddBill    = Request("ticketAddBill")
strTicketCenterCall = Request("ticketCenterCall")
strTicketperCall    = Request("ticketperCall")
strCtrptYear   = Request("ctrptYear")
strCtrptMonth  = Request("ctrptMonth")
strCtrptDay    = Request("ctrptDay")



strUserName    = Request("userName")
strRoundNoTaxFlg = Request("RoundNoTaxFlg")
strIsrGetName  = Request("isrGetName")

strOrgBillName = Request("orgBillName")
strOrgDivCd      = Request("orgDivCd")

'## 2004.01.29 Add By T.Takagi@FSIT ���ڒǉ�
strReptCslDiv = Request("reptCslDiv")
'## 2004.01.29 Add End

'�\���̕\�����̎擾
For i = 0 To UBound(strSpare)

    '�ėp���ǂݍ���
    objFree.SelectFree 0, "ORGSPARE" & (i + 1), , strFreeName

    '���̂��ݒ肳��Ă���ꍇ�͂��̓��e��ێ�
    strSpareName(i) = IIf(strFreeName <> "", strFreeName, "�ėp�L�[(" & (i + 1) & ")")

Next

'�m�F�͂����L���ɉ����ݒ肳��Ȃ��ꍇ�́u0�i��)�v���f�t�H���g�Ƃ���B
If( strPostCard = "" ) Then
    strPostCard = "0"
End If

'�m�F�͂����L���̔z��쐬
Call CreatePostCardInfo()

'�ꊇ���t�ē��ɉ����ݒ肳��Ȃ��ꍇ�́u0�i��)�v���f�t�H���g�Ƃ���B
If( strSendGuid = "" ) Then
    strSendGuid = "0"
End If

'�ꊇ���t�ē��̔z��쐬
Call CreateSendGuidInfo()

'���p���ɉ����ݒ肳��Ȃ��ꍇ�́u0�i���p���Ȃ�)�v���f�t�H���g�Ƃ���B
If( strTicket = "" ) Then
    strTicket = "0"
End If

'���p���̔z��쐬
Call CreateTicketInfo()


'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

'err.raise 1000,,strAction
    '�폜�{�^��������
    If strAction = "delete" Then

        Ret = objOrganization.DeleteOrg(strOrgCd1, strOrgCd2)
        Select Case Ret
            Case  1
            Case  0
                strArrMessage = ("�Q�Ɛ���������ׂ̈ɍ폜�ł��܂���B")
            Case Else
                strArrMessage = ("���̑��̃G���[���������܂����i�G���[�R�[�h��" & Ret & "�j�B")
        End Select

        If Ret <> 1 Then
            Exit Do
        End If

        Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=insert&act=deleteend"

    End If

    '�ۑ��{�^��������
    If strAction = "save" Then

        '���̓`�F�b�N
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '�ۑ�����
        If strMode = "update" Then

            ''' �S���ҏ��́u�c�̏Z�����e�[�u���v�ց@2003.11.14
            '�c�̃e�[�u�����R�[�h�X�V
'## 2004.01.29 Mod By T.Takagi@FSIT ���ڒǉ�
'           objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                     strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                     strOrgDivCd,    strOrgBillName, _
'                                     strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                     strNumEmp,      strAvgAge,  _
'                                     strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                     strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                     strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                     strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                     strNotes,       strDmdComment,   Session("userid"), _
'                                     Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                     strVisitDate,   strPresents, _
'                                     strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                     strTicketperCall, strCtrptDate
    '## FD�������ڒǉ� Start 2005.05.05 �� 
'           objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                     strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                     strOrgDivCd,    strOrgBillName, _
'                                     strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                     strNumEmp,      strAvgAge,  _
'                                     strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                     strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                     strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                     strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                     strNotes,       strDmdComment,   Session("userid"), _
'                                     Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                     strVisitDate,   strPresents, _
'                                     strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                     strTicketperCall, strCtrptDate, strReptCslDiv

        '## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ�
'            objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                      strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                      strOrgDivCd,    strOrgBillName, _
'                                      strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                      strNumEmp,      strAvgAge,  _
'                                      strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                      strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                      strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                      strBillFD, strSendComment, strSendEComment, strSpare(0),    strSpare(1), _
'                                      strSpare(2), strNotes,       strDmdComment,   Session("userid"), _
'                                      Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                      strVisitDate,   strPresents, _
'                                      strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                      strTicketperCall, strCtrptDate, strReptCslDiv

'            objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                      strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                      strOrgDivCd,    strOrgBillName, _
'                                      strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                      strNumEmp,      strAvgAge,  _
'                                      strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                      strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                      strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                      strBillFD, strSendComment, strSendEComment, strSpare(0),    strSpare(1), _
'                                      strSpare(2), strNotes,       strDmdComment,   Session("userid"), _
'                                      Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                      strVisitDate,   strPresents, _
'                                      strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                      strTicketperCall, strCtrptDate, strReptCslDiv, strBillSpecial

            '## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� Start ##
            objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
                                      strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
                                      strOrgDivCd,    strOrgBillName, _
                                      strBank,        strBranch,       strAccountKind, strAccountNo, _
                                      strNumEmp,      strAvgAge,  _
                                      strDM,           strSendMethod,  strPostCard,    strSendGuid, _
                                      strTicket,      strInsCheck,     strInsBring,    strInsReport, _
                                      strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
                                      strBillFD, strSendComment, strSendEComment, strSpare(0),    strSpare(1), _
                                      strSpare(2), strNotes,       strDmdComment,   Session("userid"), _
                                      Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
                                      strVisitDate,   strPresents, _
                                      strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
                                      strTicketperCall, strCtrptDate, strReptCslDiv, strBillSpecial, strBillAge
            '## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� End   ##

        '## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ�

    '## FD�������ڒǉ� End   2005.05.05 �� 
'## 2004.01.29 Mod End

            '�c�̏Z�����e�[�u�����R�[�h�X�V
            objOrganization.UpdateOrgAddr strOrgCd1,    strOrgCd2, _
                                          strZipCd,     strPrefCd,     strCityName, _
                                          strAddress1,  strAddress2, _
                                          strDirectTel, strTel,        strExtension, _
                                          strFax,       strEMail,      strUrl, _
                                          strChargeName,strChargeKName,strChargeEmail, _
                                          strChargePost,strChargeOrgName 

        Else

            ''' �S���ҏ��́u�c�̏Z�����e�[�u���v�ց@2003.11.14
            '�c�̃e�[�u�����R�[�h�}��
'## 2004.01.29 Mod By T.Takagi@FSIT ���ڒǉ�
'           Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                           strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                           strOrgDivCd,    strOrgBillName, _
'                                           strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                           strNumEmp,      strAvgAge, _
'                                           strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                           strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                           strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                           strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                           strNotes,       strDmdComment,   Session("userid"), _
'                                           strNoPrintLetter, strVisitDate,  strPresents, _
'                                           strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                           strTicketperCall, strCtrptDate _
'                                          )
    '## FD�������ڒǉ� Start 2005.05.05 �� 
'           Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                           strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                           strOrgDivCd,    strOrgBillName, _
'                                           strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                           strNumEmp,      strAvgAge, _
'                                           strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                           strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                           strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                           strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                           strNotes,       strDmdComment,   Session("userid"), _
'                                           strNoPrintLetter, strVisitDate,  strPresents, _
'                                           strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                           strTicketperCall, strCtrptDate,  strReptCslDiv _
'                                          )
        '## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ�
'            Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                            strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                            strOrgDivCd,    strOrgBillName, _
'                                            strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                            strNumEmp,      strAvgAge, _
'                                            strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                            strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                            strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                            strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                            strNotes,       strDmdComment,   Session("userid"), _
'                                            strNoPrintLetter, strVisitDate,  strPresents, _
'                                            strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                            strTicketperCall, strCtrptDate,  strReptCslDiv, _
'                                           )

            '## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� Start ##
'            Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                            strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                            strOrgDivCd,    strOrgBillName, _
'                                            strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                            strNumEmp,      strAvgAge, _
'                                            strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                            strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                            strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                            strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                            strNotes,       strDmdComment,   Session("userid"), _
'                                            strNoPrintLetter, strVisitDate,  strPresents, _
'                                            strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                            strTicketperCall, strCtrptDate,  strReptCslDiv,  strBillSpecial _
'                                           )
            Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
                                            strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
                                            strOrgDivCd,    strOrgBillName, _
                                            strBank,        strBranch,       strAccountKind, strAccountNo, _
                                            strNumEmp,      strAvgAge, _
                                            strDM,           strSendMethod,  strPostCard,    strSendGuid, _
                                            strTicket,      strInsCheck,     strInsBring,    strInsReport, _
                                            strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
                                            strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
                                            strNotes,       strDmdComment,   Session("userid"), _
                                            strNoPrintLetter, strVisitDate,  strPresents, _
                                            strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
                                            strTicketperCall, strCtrptDate,  strReptCslDiv,  strBillSpecial,  strBillAge _
                                           )
            '## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� End   ##

        '## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ�

    '## FD�������ڒǉ� End   2005.05.05 �� 
'## 2004.01.29 Mod End

            '�L�[�d�����̓G���[���b�Z�[�W��ҏW����
            If Ret = INSERT_DUPLICATE Then
                strArrMessage = Array("����c�̃R�[�h�̒c�̏�񂪂��łɑ��݂��܂��B")
                Exit Do
            End If


            '�c�̏Z�����e�[�u�����R�[�h�}��
            Ret = objOrganization.InsertOrgAddr( strOrgCd1,    strOrgCd2, _
                                                 strZipCd,     strPrefCd,     strCityName, _
                                                 strAddress1,  strAddress2, _
                                                 strDirectTel, strTel,        strExtension, _
                                                 strFax,       strEMail,      strUrl, _
                                                 strChargeName,strChargeKName,strChargeEmail, _
                                                 strChargePost,strChargeOrgName _
                                               )

            '�L�[�d�����̓G���[���b�Z�[�W��ҏW����
            If Ret = INSERT_DUPLICATE Then
                strArrMessage = Array("����c�̃R�[�h�̒c�̏Z����񂪂��łɑ��݂��܂��B")
                Exit Do
            End If

'## 2003.11.18 Del by T.Takagi@FSIT �s�v���ڍ폜
'           '�c�̊Ǘ��������ރe�[�u�����R�[�h�}��
'           Ret = objOrgBillClass.NewInsrtOrgBillClass( strOrgCd1, strOrgCd2 )
'           If( Ret <> 1 )Then
'               strArrMessage = Array("�c�̊Ǘ��������ރe�[�u���̒ǉ��Ɏ��s���܂����B")
'               Exit Do
'           End If
'## 2003.11.18 Del End

        End If

        '�ۑ��ɐ��������ꍇ�A�^�[�Q�b�g�w�莞�͎w����URL�փW�����v���A���w�莞�͍X�V���[�h�Ń��_�C���N�g
        If strTarget <> "" Then
            Response.Redirect strTarget & "?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2
        Else
            Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&act=saveend&orgcd1=" & strOrgCd1 & "&orgcd2=" & strOrgCd2
        End If
        Response.End

    End If



    '�V�K���[�h�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
    If strMode = "insert" Then

        '�z��錾���s���B
        strAddrDiv   = Array()
        strCityName  = Array()
        strZipCd     = Array()
        strPrefCd    = Array()
        strAddress1  = Array()
        strAddress2  = Array()
        strDirectTel = Array()
        strTel       = Array()
        strExtension = Array()
        strFax       = Array()
        strEMail     = Array()
        strUrl       = Array()
        strChargeName   = Array()
        strChargeKName  = Array()
        strChargeEmail  = Array()
        strChargePost   = Array()
        strChargeOrgName= Array()

        ReDim Preserve strAddrDiv(2)
        ReDim Preserve strCityName(2)
        ReDim Preserve strZipCd(2)
        ReDim Preserve strPrefCd(2)
        ReDim Preserve strAddress1(2)
        ReDim Preserve strAddress2(2)
        ReDim Preserve strDirectTel(2)
        ReDim Preserve strTel(2)
        ReDim Preserve strExtension(2)
        ReDim Preserve strFax(2)
        ReDim Preserve strEMail(2)
        ReDim Preserve strUrl(2)
        ReDim Preserve strChargeName(2)
        ReDim Preserve strChargeKName(2)
        ReDim Preserve strChargeEmail(2)
        ReDim Preserve strChargePost(2)
        ReDim Preserve strChargeOrgName(2)

        Exit Do
    End If

    ''' �S���ҏ��́u�c�̏Z�����e�[�u���v����擾�@2003.11.14
    '�c�̃e�[�u�����R�[�h�ǂݍ���
'## 2004.01.29 Mod By T.Takagi@FSIT ���ڒǉ�
'   objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                   strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                   strOrgDivCd,    strOrgBillName, _
'                                    ,   ,   ,   , _
'                                   strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                   strNumEmp,      strAvgAge, _
'                                   strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                   strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                   strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                   strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                   strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                   strNoPrintLetter, strVisitDate,  strPresents, _
'                                   strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                   strTicketperCall, strCtrptDate

    '## FD�������ڒǉ� Start 2005.05.05 �� 
'   objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                   strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                   strOrgDivCd,    strOrgBillName, _
'                                    ,   ,   ,   , _
'                                   strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                   strNumEmp,      strAvgAge, _
'                                   strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                   strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                   strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                   strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                   strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                   strNoPrintLetter, strVisitDate,  strPresents, _
'                                   strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                   strTicketperCall, strCtrptDate, strReptCslDiv

        '## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ�
'    objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                    strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                    strOrgDivCd,    strOrgBillName, _
'                                     ,   ,   ,   , _
'                                    strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                    strNumEmp,      strAvgAge, _
'                                    strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                    strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                    strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                    strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                    strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                    strNoPrintLetter, strVisitDate,  strPresents, _
'                                    strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                    strTicketperCall, strCtrptDate, strReptCslDiv

'    objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                    strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                    strOrgDivCd,    strOrgBillName, _
'                                     ,   ,   ,   , _
'                                    strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                    strNumEmp,      strAvgAge, _
'                                    strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                    strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                    strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                    strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                    strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                    strNoPrintLetter, strVisitDate,  strPresents, _
'                                    strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                    strTicketperCall, strCtrptDate, strReptCslDiv,  strBillSpecial

            '## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� Start ##
    objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
                                    strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
                                    strOrgDivCd,    strOrgBillName, _
                                     ,   ,   ,   , _
                                    strBank,        strBranch,       strAccountKind, strAccountNo, _
                                    strNumEmp,      strAvgAge, _
                                    strDM,          strSendMethod,   strPostCard,    strSendGuid, _
                                    strTicket,      strInsCheck,     strInsBring,    strInsReport, _
                                    strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
                                    strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
                                    strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
                                    strNoPrintLetter, strVisitDate,  strPresents, _
                                    strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
                                    strTicketperCall, strCtrptDate, strReptCslDiv,  strBillSpecial,  strBillAge

            '## 2009.05.20 �� ���������l���ɔN��\�L�̈גǉ� End   ##

        '## 2008.03.19 �� ���������茒�f���|�[�g���ڒǉ�

    '## FD�������ڒǉ� End   2005.05.05 �� 
'## 2004.01.29 Mod End

    If strCtrptDate <> "" Then
        strCtrptYear = Year(strCtrptDate)
        strCtrptMonth = Month(strCtrptDate)
        strCtrptDay = Day(strCtrptDate)
    End If

    '�c�̏Z�����e�[�u�����R�[�h�ǂݍ���
    objOrganization.SelectOrgAddrList strOrgCd1,    strOrgCd2,      strAddrDiv, _
                                      strZipCd,     strPrefCd,      strCityName, _
                                      strAddress1,  strAddress2, _
                                      strDirectTel, strTel,         strExtension, _
                                      strFax,       strEMail,       strUrl, _
                                      strChargeName,strChargeKName, strChargeEmail, _
                                      strChargePost,strChargeOrgName 

    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �߂��URL�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : �߂���URL
'
' ���l�@�@ : �e�Ɩ����Ƃɖ߂��(�������)��URL���قȂ邽�߁A����𐧌�
'
'-------------------------------------------------------------------------------
Function EditURLForReturning()

    Dim strURL	'�߂��URL

    Do
        '�^�[�Q�b�g��URL�����݂��Ȃ��ꍇ
        If strTarget = "" Then

            '�ʏ�̃����e�i���X�Ɩ��Ƃ݂Ȃ��A���ꉼ�z�t�H���_�̌�����ʂ�
            strURL = "mntSearchOrg.asp"
            Exit Do

        End If

        '�^�[�Q�b�g�悪�_����̏ꍇ
        If InStr(1, strTarget, "contract") > 0 Then

            '�^�[�Q�b�g��URL�Ɠ��ꉼ�z�t�H���_�̌�����ʂ�
            strURL = Left(strTarget, InStrRev(strTarget, "/")) & "ctrSearchOrg.asp"
            Exit Do

        End If

        Exit Do
    Loop

    EditURLForReturning = strURL

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �c�̏��e�l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '���ʃN���X

    Dim strIsrOrgCd1    '�c�̃R�[�h�P
    Dim strIsrOrgCd2    '�c�̃R�[�h�Q
    Dim strIsrOrgSName  '�c�̗���

    Dim vntArrMessage   '�G���[���b�Z�[�W�̏W��
    Dim strMessage      '�G���[���b�Z�[�W
    Dim i               '�C���f�b�N�X

    '���ʃN���X�̃C���X�^���X�쐬
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '�e�l�`�F�b�N����
    With objCommon

        '�c�̃R�[�h
        .AppendArray vntArrMessage, .CheckAlphabetAndNumeric("�c�̃R�[�h�P", strOrgCd1, LENGTH_ORG_ORGCD1, CHECK_NECESSARY)
        .AppendArray vntArrMessage, .CheckAlphabetAndNumeric("�c�̃R�[�h�Q", strOrgCd2, LENGTH_ORG_ORGCD2, CHECK_NECESSARY)

'       '�c�̎��
'       .AppendArray vntArrMessage, .CheckWideValue("�c�̎��", strOrgDivCd, 12, CHECK_NECESSARY)

        '�e�햼��
'## 2003.12.17 Mod By T.Takagi@FSIT �`�F�b�N���@�ύX
'       .AppendArray vntArrMessage, .CheckWideValue("�c�̃J�i����", strOrgKName, LENGTH_ORG_ORGKNAME, CHECK_NECESSARY)
'       .AppendArray vntArrMessage, .CheckWideValue("�c�̖���",     strOrgName,  LENGTH_ORG_ORGNAME,  CHECK_NECESSARY)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�c�̖��́i�p��j",     strOrgEName,  50)
'       .AppendArray vntArrMessage, .CheckWideValue("�c�̗���",     strOrgSName, LENGTH_ORG_ORGSNAME, CHECK_NECESSARY)
        If strOrgKName = "" Then
            .AppendArray vntArrMessage, "�c�̃J�i���̂���͂��Ă��������B"
        End If
        If strOrgName = "" Then
            .AppendArray vntArrMessage, "�c�̖��̂���͂��Ă��������B"
        End If
        If strOrgSName = "" Then
            .AppendArray vntArrMessage, "�c�̗��̂���͂��Ă��������B"
        End If
'## 2003.12.17 Mod End

'## 2003.12.17 Del By T.Takagi@FSIT �`�F�b�N���@�ύX
'       '�Z���P
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�s�撬��", strCityName(0), LENGTH_CITYNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�Z���i�P�j",   strAddress1(0), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�Z���i�Q�j",   strAddress2(0), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���P�F�d�b�ԍ�����", strDirectTel(0), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���P�F�d�b�ԍ���\", strTel(0), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���P�F����", strExtension(0), LENGTH_ORG_EXTENSION)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���P�F�e�`�w�ԍ�", strFax(0), 12)
'       strMessage = .CheckNarrowValue("�Z���P�FE-Mail�A�h���X", strEMail(0), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("�Z���P�FE-Mail�A�h���X", strEMail(0))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       strMessage = .CheckNarrowValue("�Z���P�F�t�q�k�A�h���X", strUrl(0), 50)
'       .AppendArray vntArrMessage, strMessage
'
'       '�S����
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S���҃J�i��", strChargeKName(0), LENGTH_ORG_CHARGEKNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S���Җ�",     strChargeName(0),  LENGTH_ORG_CHARGENAME)
'
'       '�S����E-Mail
'       strMessage = .CheckNarrowValue("�Z���P�F�S����E-Mail�A�h���X", strChargeEmail(0), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("�Z���P�F�S����E-Mail�A�h���X", strChargeEmail(0))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       '�S������
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S��������", strChargePost(0), LENGTH_ORG_CHARGEPOST)
'       '�����Ж�
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�����Ж�", strChargeOrgName(0), LENGTH_ORG_ORGNAME)
'
'
'       '�Z���Q
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���Q�F�s�撬��", strCityName(1), LENGTH_CITYNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���Q�F�Z���i�P�j",   strAddress1(1), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���Q�F�Z���i�Q�j",   strAddress2(1), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���Q�F�d�b�ԍ�����", strDirectTel(1), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���Q�F�d�b�ԍ���\", strTel(1), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���Q�F����", strExtension(1), LENGTH_ORG_EXTENSION)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���Q�F�e�`�w�ԍ�", strFax(1), 12)
'       strMessage = .CheckNarrowValue("�Z���Q�FE-Mail�A�h���X", strEMail(1), LENGTH_EMAIL)
'       If strMessage = "" Then
'       strMessage = .CheckEMail("�Z���Q�FE-Mail�A�h���X", strEMail(1))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       strMessage = .CheckNarrowValue("�Z���Q�F�t�q�k�A�h���X", strUrl(1), 50)
'       .AppendArray vntArrMessage, strMessage
'
'       '�S����
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S���҃J�i��", strChargeKName(1), LENGTH_ORG_CHARGEKNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S���Җ�",     strChargeName(1),  LENGTH_ORG_CHARGENAME)
'
'       '�S����E-Mail
'       strMessage = .CheckNarrowValue("�Z���P�F�S����E-Mail�A�h���X", strChargeEmail(1), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("�Z���P�F�S����E-Mail�A�h���X", strChargeEmail(1))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       '�S������
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S��������", strChargePost(1), LENGTH_ORG_CHARGEPOST)
'       '�����Ж�
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�����Ж�", strChargeOrgName(1), LENGTH_ORG_ORGNAME)
'
'
'       '�Z���R
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���R�F�s�撬��", strCityName(2), LENGTH_CITYNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���R�F�i�Z���P�j",   strAddress1(2), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���R�F�i�Z���Q�j",   strAddress2(2), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���R�F�d�b�ԍ�����", strDirectTel(2), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���R�F�d�b�ԍ���\", strTel(2), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���R�F����", strExtension(2), LENGTH_ORG_EXTENSION)
'       .AppendArray vntArrMessage, .CheckNarrowValue("�Z���R�F�e�`�w�ԍ�", strFax(2), 12)
'       strMessage = .CheckNarrowValue("�Z���R�FE-Mail�A�h���X", strEMail(2), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("�Z���R�FE-Mail�A�h���X", strEMail(2))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       strMessage = .CheckNarrowValue("�Z���R�F�t�q�k�A�h���X", strUrl(2), 50)
'       .AppendArray vntArrMessage, strMessage
'       '�S����
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S���҃J�i��", strChargeKName(2), LENGTH_ORG_CHARGEKNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S���Җ�",     strChargeName(2),  LENGTH_ORG_CHARGENAME)
'
'       '�S����E-Mail
'       strMessage = .CheckNarrowValue("�Z���P�F�S����E-Mail�A�h���X", strChargeEmail(2), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("�Z���P�F�S����E-Mail�A�h���X", strChargeEmail(2))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       '�S������
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�S��������", strChargePost(2), LENGTH_ORG_CHARGEPOST)
'       '�����Ж�
'       .AppendArray vntArrMessage, .CheckWideValue("�Z���P�F�����Ж�", strChargeOrgName(2), LENGTH_ORG_ORGNAME)
'## 2003.12.17 Del End

        '�����ԍ�
        .AppendArray vntArrMessage, .CheckNumeric("�����ԍ�", strAccountNo, 10)

        '�Ј���
        .AppendArray vntArrMessage, .CheckNumeric("�Ј���", strNumEmp, 6)

        '���ϔN��
        .AppendArray vntArrMessage, .CheckNumeric("���ϔN��", strAvgAge, 3)

        '����K��\���
        .AppendArray vntArrMessage, .CheckNumeric("����K��\���", strVisitDate, 2)
'       .AppendArray vntArrMessage, .CheckDate("����K��\���", strVisitYear, strVisitMonth, strVisitDay, strVisitDate)

        '�_����t
        .AppendArray vntArrMessage, .CheckDate("�_����t", strCtrptYear, strCtrptMonth, strCtrptDay, strCtrptDate)

        '���t�ē��R�����g(���s������1���Ƃ��Ċ܂ގ|��ʒB)
        strMessage = .CheckWideValue("���t�ē��R�����g�i���{���j", strSendComment, LENGTH_ORG_NOTES)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '���t�ē��R�����g�p��(���s������1���Ƃ��Ċ܂ގ|��ʒB)
        strMessage = .CheckNarrowValue("���t�ē��R�����g�i�p���j", strSendEComment, 400)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�ėp�L�[
        For i = 0 To UBound(strSpare)

            '�����񒷃`�F�b�N
            .AppendArray vntArrMessage, .CheckLength(strSpareName(i), strSpare(i), LENGTH_ORG_SPARE)

        Next

        '���L����(���s������1���Ƃ��Ċ܂ގ|��ʒB)
        strMessage = .CheckWideValue("���L����", strNotes, LENGTH_ORG_NOTES)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�����֘A�R�����g(���s������1���Ƃ��Ċ܂ގ|��ʒB)
        strMessage = .CheckWideValue("���t�ē��R�����g", strDmdComment, LENGTH_ORG_NOTES)
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
' �@�\�@�@ : �g�p����Ԃ̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function DelFlgList()

    Dim strArrDelFlgID(3)       '�g�p�����
    Dim strArrDelFlgName(3)     '�g�p����Ԗ�

    '### �g�p��ԋ敪�̕ύX�ɂ��C�� 2005.04.02 ��
    '�Œ�l�̕ҏW
    strArrDelFlgID(0) = "0":    strArrDelFlgName(0) = "�g�p���@"
    strArrDelFlgID(1) = "2":    strArrDelFlgName(1) = "�g�p���A"
    strArrDelFlgID(2) = "3":    strArrDelFlgName(2) = "�������g�p"
    strArrDelFlgID(3) = "1":    strArrDelFlgName(3) = "���g�p"

    'strArrDelFlgID(0) = "0":    strArrDelFlgName(0) = "�g�p��"
    'strArrDelFlgID(1) = "2":    strArrDelFlgName(1) = "�_��葱��"
    'strArrDelFlgID(2) = "3":    strArrDelFlgName(2) = "�������g�p"
    'strArrDelFlgID(3) = "1":    strArrDelFlgName(3) = "���g�p"

    DelFlgList = EditDropDownListFromArray("delFlg", strArrDelFlgID, strArrDelFlgName, IIf(strDelFlg = "" , "2", strDelFlg), NON_SELECTED_DEL)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ������ʁE���̂̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function AccountList()

    Dim strArrAccountKind(1)    '�������
    Dim strArrAccountName(1)    '������ʖ�

    '�Œ�l�̕ҏW
    strArrAccountKind(0) = "1" : strArrAccountName(0) = "����"
    strArrAccountKind(1) = "2" : strArrAccountName(1) = "����"

    AccountList = EditDropDownListFromArray("accountkind", strArrAccountKind, strArrAccountName, strAccountKind, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �N�n�E�����E�Ε�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function PresentsList()

    Dim strArrPresentsID(1)         '�o�͎��
    Dim strArrPresentsName(1)       '�o�͖�

    '�Œ�l�̕ҏW
    strArrPresentsID(0) = "1" : strArrPresentsName(0) = "�o�͂���"
    strArrPresentsID(1) = "0" : strArrPresentsName(1) = "�o�͂��Ȃ�"

    PresentsList = EditDropDownListFromArray("presents", strArrPresentsID, strArrPresentsName, strPresents, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �c�l�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function DmList()

    Dim strArrDmID(3)       '�o�͎��
    Dim strArrDmName(3)     '�o�͖�

    ''##�@�c�Ƃ���̈˗��ɂ���ďC���@2005.02.17�@�� ##
    ''##�@�Z����ނɍ��킹�Ăc�l�敪�Z�b�e�B���O     ##
    ''�Œ�l�̕ҏW
    'strArrDmID(0) = "1" : strArrDmName(0) = "�o�͂���"
    'strArrDmID(1) = "0" : strArrDmName(1) = "�o�͂��Ȃ�"
    strArrDmID(0) = "1" : strArrDmName(0) = "�Z���P"
    strArrDmID(1) = "2" : strArrDmName(1) = "�Z���Q"
    strArrDmID(2) = "3" : strArrDmName(2) = "�Z���R"
    strArrDmID(3) = "0" : strArrDmName(3) = "�o�͂��Ȃ�"

    DmList = EditDropDownListFromArray("dm", strArrDmID, strArrDmName, strDm, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���t���@�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function SendMethodList()

    Dim strArrSendID(1)     '���M���@
    Dim strArrSendName(1)   '���M��

    '�Œ�l�̕ҏW
'## 2003.11.18 Mod by T.Takagi@FSIT �`�F�b�N���񂪈قȂ�
'	strArrSendID(0) = "1" : strArrSendName(0) = "��"
'	strArrSendID(1) = "2" : strArrSendName(1) = "�ꊇ"
    strArrSendID(0) = "0" : strArrSendName(0) = "��"
    strArrSendID(1) = "1" : strArrSendName(1) = "�ꊇ"
'## 2003.11.18 Mod End

    SendMethodList = EditDropDownListFromArray("sendMethod", strArrSendID, strArrSendName, strSendMethod, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������K�p�Z���̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function BillAddressList()

    Dim strArrBillAddID(2)      '�Z���ԍ�
    Dim strArrBillAddName(2)    '�Z����

    '�Œ�l�̕ҏW
    strArrBillAddID(0) = "1" : strArrBillAddName(0) = "�Z���P"
    strArrBillAddID(1) = "2" : strArrBillAddName(1) = "�Z���Q"
    strArrBillAddID(2) = "3" : strArrBillAddName(2) = "�Z���R"

    BillAddressList = EditDropDownListFromArray("billAddress", strArrBillAddID, strArrBillAddName, strBillAddress, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���p���敪�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function TicketDivList()

    Dim strArrTicketDivID(3)        '���p���敪
    Dim strArrTicketDivName(3)      '���p���敪��

    '�Œ�l�̕ҏW
    strArrTicketDivID(0) = "1" : strArrTicketDivName(0) = "�M�А�p�t�H�[��"
    strArrTicketDivID(1) = "2" : strArrTicketDivName(1) = "���ۑg���t�H�[��"
    strArrTicketDivID(2) = "3" : strArrTicketDivName(2) = "���ۘA�t�H�[��"
    strArrTicketDivID(3) = "4" : strArrTicketDivName(3) = "���H���t�H�[��"

    TicketDivList = EditDropDownListFromArray("ticketDiv", strArrTicketDivID, strArrTicketDivName, strTicketDiv, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ :�m�F�͂����L���̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePostCardInfo()

    Redim Preserve strArrPostCard( postCardCount - 1 )
    Redim Preserve strArrPostCardName( postCardCount - 1)

    strArrPostCard(0) = "1":strArrPostCardName(0) = "�L"
    strArrPostCard(1) = "0":strArrPostCardName(1) = "��"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ :�ꊇ���t�ē��L���̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateSendGuidInfo()

    Redim Preserve strArrSendGuid( sendGuidCount - 1 )
    Redim Preserve strArrSendGuidName( sendGuidCount - 1)

    strArrSendGuid(0) = "1":strArrSendGuidName(0) = "�L"
    strArrSendGuid(1) = "0":strArrSendGuidName(1) = "��"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ :���p���̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateTicketInfo()

    Redim Preserve strArrTicket( ticketCount - 1 )
    Redim Preserve strArrTicketName( ticketCount - 1)

    strArrTicket(0) = "1":strArrTicketName(0) = "���p����"
    strArrTicket(1) = "0":strArrTicketName(1) = "���p���Ȃ�"

End Sub



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�c�̏�񃁃��e�i���X</TITLE>
<!-- #include virtual = "/webHains/includes/zipGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

var winRptOpt;

// �X�֔ԍ��K�C�h�Ăяo��
function callZipGuide(keyPrefCd, zipCd, prefCd, cityName, address1) {

    var objForm = document.entryForm;   // ����ʂ̃t�H�[���G�������g

    zipGuide_showGuideZip( keyPrefCd, zipCd, prefCd, cityName, address1 );

}

// �X�֔ԍ��̃N���A
function clearZipInfo(zipCd) {

    var objForm = document.entryForm;    // ����ʂ̃t�H�[���G�������g

    zipGuide_clearZipInfo( zipCd, zipCd );

}

var winGuideCal;
// ���t�K�C�h�Ăяo��
function callCalGuide(year, month, day) {


    // ���t�K�C�h�\��
    calGuide_showGuideCalendar( year, month, day, '' );

}

// �ۑ�
function saveData() {

    /** �c�̏��̕ۑ��������s�������[�j���O���b�Z�[�W��\�����čĊm�F����悤�ɏC�� Start 2005.06.18 �� **/
    if ( !confirm( '�c�̏���ύX���܂��B��낵���ł����H' ) ) {
        return;
    }
    /** �c�̏��̕ۑ��������s�������[�j���O���b�Z�[�W��\�����čĊm�F����悤�ɏC�� End   2005.06.18 �� **/

    document.entryForm.submit();

}

function deleteData() {

    if ( !confirm( '���̒c�̏����폜���܂��B��낵���ł����H' ) ) {
        return;
    }

    // ���[�h���w�肵��submit
    document.entryForm.act.value = 'delete';
    document.entryForm.submit();

}

function windowClose() {
    zipGuide_closeGuideZip();
    
    // ���t�K�C�h�����
    calGuide_closeGuideCalendar();
}

/** �������ɓY�t���鐬�я��Ɋւ���`�F�b�N�{�b�N�X�R���g���[��  **/
/** 2005.5.06 �ǉ� ��                                       **/
function changeBillReport(cnt,cnt2)
{
    with(document.entryForm){
        //eval('billReport'+cnt).checked = true;
        eval('billReport'+cnt2).checked = false;
        if(eval('billReport'+cnt).checked == true){
            billReport.value = eval('billReport'+cnt).value;
        } else {
            billReport.value = "";
        }
    }
}

/** �R�A���я��̃I�v�V�����������ʈ���Ǘ���ʕ\�� **/
/** 2005.5.06 �ǉ� ��                                       **/
function callReportOption(orgCd1, orgCd2)
{
    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // ���я��I�v�V�����Ǘ���ʂ�URL

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winRptOpt != null ) {
        if ( !winRptOpt.closed ) {
            opened = true;
        }
    }

    // ���я��I�v�V�����Ǘ���ʂ�URL�ҏW
    url = 'rptSetOption.asp?orgCd1=' + orgCd1 + '&orgCd2=' + orgCd2;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winRptOpt.focus();
        winRptOpt.location.replace( url );
    } else {
        winRptOpt = window.open( url, '', 'width=550,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:zipGuide_closeGuideZip()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= strMode %>">
<INPUT TYPE="hidden"    NAME="act"          VALUE="save">
<INPUT TYPE="hidden"    NAME="target"       VALUE="<%= strTarget %>">
<INPUT TYPE="hidden"    NAME="billReport"   VALUE="<%=strBillReport%>">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
    <TR><TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�c�̏�񃁃��e�i���X</FONT></B></TD></TR>
</TABLE>
<!-- ����{�^�� -->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
    <TR>
        <TD HEIGHT="5"></TD>
    </TR>
    <TR>
        <TD>
<%
            '����p�A���J�[����ݒ�
            blnOpAnchor = ( strMode = "update" ) And Not ( strOrgCd1 ="XXXXX" AND strOrgCd2 ="XXXXX" ) And Not ( strOrgCd1 ="WWWWW" AND strOrgCd2 ="WWWWW" )
%>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
                <TR>
                    <TD WIDTH="100%"></TD>
                    <TD><A HREF="<%= EditURLForReturning() %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="������ʂɖ߂�܂�"></A></TD>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<%
                    If blnOpAnchor Then
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="12" HEIGHT="5"></TD>

                        <TD>
                        <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
                        <%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
                            <A HREF="javascript:deleteData()"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̒c�̏����폜���܂�"></A>
                        <%  else    %>
                             &nbsp;
                        <%  end if  %>
                        <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
                        </TD>

                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="25" HEIGHT="5"></TD>
<%
                    End If
%>
<%
                    If strMode = "update" Then
%>
                        <TD NOWRAP><A HREF="/webHains/contents/contract/ctrCourseList.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/prevcont_b.gif" HEIGHT="24" WIDTH="77" ALT="�_����Q�Ƃ��܂�"></A></TD>
                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
                        <TD><A HREF="javascript:noteGuide_showGuideNote('5', '0,0,1,0', '', '', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>')"><IMG SRC="/webHains/images/comment.gif" HEIGHT="24" WIDTH="77" ALT="�R�����g��o�^���܂�"></A></TD>
<%
                    End If
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="12" HEIGHT="5"></TD>

                    <TD>
                    <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
                        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <A HREF="javascript:saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A>
                    <%  else    %>
                         &nbsp;
                    <%  end if  %>
                    <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
                    </TD>


                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
    </TR>
</TABLE>
<%
'���b�Z�[�W�̕ҏW
    '���b�Z�[�W�̕ҏW
    If strAction <> "" Then

        Select Case strAction

            '�ۑ��������́u�ۑ������v�̒ʒm
            Case "saveend"
                Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

            '�폜�������́u�폜�����v�̒ʒm
            Case "deleteend"
                Call EditMessage("�폜���������܂����B", MESSAGETYPE_NORMAL)

            '�����Ȃ��΃G���[���b�Z�[�W��ҏW
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

End If
%>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̃R�[�h</TD>
        <TD WIDTH="5"></TD>
        <TD>
<%
            '�}�����[�h�̏ꍇ�̓e�L�X�g�\�����s���A�X�V���[�h�̏ꍇ��hidden�ŃR�[�h��ێ�
            If strMode = "insert" Then
%>
                <INPUT TYPE="text" NAME="orgCd1" SIZE="5" MAXLENGTH="5" VALUE="<%= strOrgCd1 %>" STYLE="ime-mode:disabled;">-<INPUT TYPE="text" NAME="orgCd2" SIZE="5" MAXLENGTH="5" VALUE="<%= strOrgCd2 %>" STYLE="ime-mode:disabled;">
<%
            Else
%>
                <INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>"><INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>"><%= strOrgCd1 %>-<%= strOrgCd2 %>
<%
            End If
%>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR HEIGHT="26">
        <TD HEIGHT="26" BGCOLOR="#eeeeee" ALIGN="right">�g�p���</TD>
        <TD HEIGHT="26"></TD>
        <TD HEIGHT="26"><%= DelFlgList() %></TD>
    </TR>
    <TR height="26">
        <TD HEIGHT="26" BGCOLOR="#eeeeee" ALIGN="right">�c�̃J�i����</TD>
        <TD height="26"></TD>
        <TD height="26"><INPUT TYPE="text" NAME="orgKName" SIZE="100" MAXLENGTH="40" VALUE="<%= strOrgKName %>" STYLE="ime-mode:active;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̖���</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgName" SIZE="70" MAXLENGTH="50" VALUE="<%= strOrgName %>" STYLE="ime-mode:activate;"></TD>
    </TR>
    <TR>
        <TD height="25" bgcolor="#eeeeee" align="right">�c�̖��́i�p��j</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgEName" SIZE="70" MAXLENGTH="50" VALUE="<%= strOrgEName %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̗���</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgSName" SIZE="27" MAXLENGTH="20" VALUE="<%= strOrgSName %>" STYLE="ime-mode:activate;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̎��</TD>
        <TD></TD>
<%
            '�c�̎��
            objFree.SelectFree 1, strKeyOrgDivCd, strArrOrgDivCd, , , strArrOrgDivCdName
%>
        <TD><%= EditDropDownListFromArray("orgDivCd", strArrOrgDivCd, strArrOrgDivCdName, strOrgDivCd, NON_SELECTED_ADD) %></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�������p����</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgBillName" SIZE="83" MAXLENGTH="60" VALUE="<%= strOrgBillName %>" STYLE="ime-mode:activate;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="8" ALIGN="left"></TD>
        <TD HEIGHT="8"></TD>
        <TD HEIGHT="8"></TD>
    </TR>
<%
    For i = 0 To 2
        Select Case i
            Case 0
                strWkNum = "�P"
            Case 1
                strWkNum = "�Q"
            Case 2
                strWkNum = "�R"
        End Select
%>      
        <TR>
            <TD HEIGHT="25" ALIGN="left">�Z��<%= strWkNum %></TD>
            <TD></TD>
            <TD></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�����Ж�</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeOrgName" SIZE="70" MAXLENGTH="50" VALUE="<%= strChargeOrgName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�X�֔ԍ�</TD>
            <TD></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:callZipGuide(document.entryForm.prefCd[<%= i %>].value, document.entryForm.zipCd[<%= i %>], document.entryForm.prefCd[<%= i %>], document.entryForm.cityName[<%= i %>], document.entryForm.address1[<%= i %>] )"><IMG SRC="../../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�X�֔ԍ��K�C�h�\��" border="0"  ></A>
                        <TD>&nbsp;</TD>
                        <TD><A HREF="javascript:clearZipInfo(document.entryForm.zipCd[<%= i %>])"><IMG SRC="../../../images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�X�֔ԍ����폜���܂�" border="0"></A></TD>
                        <TD>&nbsp;</TD>
                        <TD><INPUT TYPE="text" NAME="zipCd" VALUE="<%= strZipCd(i) %>" SIZE="8" MAXLENGTH="7" STYLE="ime-mode:disabled;"></TD>
                        <TD>�@�s���{���F</TD>
                        <TD><%= EditPrefList("prefCd", strPrefcd(i)) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�s�撬��</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="cityName" SIZE="70" MAXLENGTH="50" VALUE="<%= strCityName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�Z��(1)</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="address1" SIZE="83" MAXLENGTH="60" VALUE="<%= strAddress1(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�Z��(2)</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="address2" SIZE="83" MAXLENGTH="60" VALUE="<%= strAddress2(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ�����</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="directTel" SIZE="15" MAXLENGTH="12" VALUE="<%= strDirectTel(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ���\</TD>
            <TD></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><INPUT TYPE="text" NAME="tel" SIZE="15" MAXLENGTH="12" VALUE="<%= strTel(i) %>" STYLE="ime-mode:disabled;"></TD>
                    <TD>����</TD>
                    <TD>�F&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="extension" SIZE="15" MAXLENGTH="10" VALUE="<%= strExtension(i) %>" STYLE="ime-mode:disabled;"></TD>
                </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">FAX�ԍ�</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="fax" SIZE="15" MAXLENGTH="12" VALUE="<%= strFax(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD height="25" bgcolor="#eeeeee" ALIGN="right">E-mail</TD>
           <TD height="25"></TD>
            <TD height="25"><INPUT TYPE="text" NAME="eMail" SIZE="52" MAXLENGTH="40" VALUE="<%= strEMail(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD height="25" bgcolor="#eeeeee" ALIGN="right">URL</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="url" SIZE="52" MAXLENGTH="40" VALUE="<%= strUrl(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�S���҃J�i��</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeKName" SIZE="40" MAXLENGTH="30" VALUE="<%= strChargeKName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�S���Җ�</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeName" SIZE="27" MAXLENGTH="20" VALUE="<%= strChargeName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�S����E-Mail�A�h���X</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeEmail" SIZE="52" MAXLENGTH="40" VALUE="<%= strChargeEmail(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�S��������</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargePost" SIZE="70" MAXLENGTH="50" VALUE="<%= strChargePost(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
<%
    Next
%>

    <TR HEIGHT="6">
        <TD HEIGHT="6" ALIGN="right"></TD>
        <TD HEIGHT="6"></TD>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">��s��</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="bank" SIZE="26" MAXLENGTH="10" VALUE="<%= strBank %>" STYLE="ime-mode:active;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�x�X��</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="branch" SIZE="26" MAXLENGTH="10" VALUE="<%= strBranch %>" STYLE="ime-mode:active;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">����</TD>
        <TD></TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TD>��ʁF</TD>
                <TD><%= AccountList() %></TD>
                <TD>�ԍ��F</TD>
                <TD><INPUT TYPE="text" NAME="accountNo" SIZE="13" MAXLENGTH="10" VALUE="<%= strAccountNo %>" STYLE="ime-mode:disabled;"></TD>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">�Ј���</TD>
        <TD height="25"></TD>
        <TD height="25"><INPUT TYPE="text" NAME="numEmp" SIZE="6" MAXLENGTH="6" VALUE="<%= strNumEmp %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">���ϔN��</TD>
        <TD height="25"></TD>
        <TD height="25"><INPUT TYPE="text" NAME="avgAge" SIZE="6" MAXLENGTH="3" VALUE="<%= strAvgAge %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">����K��\���</TD>
        <TD></TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD>����&nbsp;<%= EditSelectNumberList("visitDate",   1, 31, CLng("0" & strVisitDate )) %></TD>
                    <TD>&nbsp;��</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">�N�n�E�����E�Ε�</TD>
        <TD height="25"></TD>
        <TD><%= PresentsList() %></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">�c�l</TD>
        <TD height="25"></TD>
        <TD><%= DmList() %></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">���t���@</TD>
        <TD height="25"></TD>
        <TD><%= SendMethodList() %></TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TD bgcolor="#eeeeee" align="right" height="25">�m�F�͂���</TD>
    <TD></TD>
    <TD>
<%
        For i = 0 To postCardCount - 1
%>
            <INPUT TYPE="radio" NAME="postcard" VALUE="<%= strArrPostCard(i) %>" <%= IIf( strArrPostCard(i) = strPostCard , "CHECKED", "") %>><%= strArrPostCardName(i) %>
<%
        Next
%>
    </TD>
    <TD valign="top"></TD>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">�ꊇ���t�ē�</TD>
        <TD></TD>
        <TD>
<%
        For i = 0 To sendGuidCount - 1
%>
            <INPUT TYPE="radio" NAME="sendguid" VALUE="<%= strArrSendGuid(i) %>" <%= IIf( strArrSendGuid(i) = strSendGuid , "CHECKED", "") %>><%= strArrSendGuidName(i) %>
<%
        Next
%>
        </TD>
        <TD VALIGN="top"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">���p��</TD>
        <TD></TD>
        <TD NOWRAP>
<%
        For i = 0 To ticketCount - 1
%>
            <INPUT TYPE="radio" NAME="ticket" VALUE="<%= strArrTicket(i) %>" <%= IIf( strArrTicket(i) = strTicket , "CHECKED", "") %>><%= strArrTicketName(i) %>
<%
        Next
%>
        </TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">���p���敪</TD>
        <TD></TD>
        <TD><%= TicketDivList() %></TD>

    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">���p���������Y�t</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="ticketAddBill" VALUE="1" <%= IIf( strTicketAddBill = "1", "CHECKED", "") %>>�v�Y�t�@</TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">���p�����O���</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="ticketCenterCall" VALUE="1" <%= IIf( strTicketCenterCall = "1", "CHECKED", "") %>>�L</TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">���p���{�l�������</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="ticketperCall" VALUE="1" <%= IIf( strTicketperCall = "1", "CHECKED", "") %>>�L</TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">�_����t</TD>
        <TD></TD>
<%
        '�N�����̌`�����쐬����
        strSelectedDate = strCtrptYear & "/" & strCtrptMonth & "/" & strCtrptDay

        '���t�F���s�\���͌��������̂܂܊֐��ɓn��
        If Not IsDate(strSelectedDate) Then
            strSelectedDate = strCtrptYear
        End If
%>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:callCalGuide('ctrptYear', 'ctrptMonth', 'ctrptDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('ctrptYear', 'ctrptMonth', 'ctrptDay')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="���t���폜���܂�" border="0"></A></TD>					<TD><%= EditSelectNumberList("ctrptYear", YEARRANGE_MIN, YEARRANGE_MAX, CLng("0" & strCtrptYear)) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("ctrptMonth", 1, 12, CLng("0" & strCtrptMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("ctrptDay",   1, 31, CLng("0" & strCtrptDay  )) %></TD>
                    <TD>&nbsp;��</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">�P�N�ڂ͂���</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="noPrintLetter" VALUE="1" <%= IIf( strNoPrintLetter = "1", "CHECKED", "") %>>�o�͂��Ȃ��@
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">�ی���</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="insCheck" VALUE="1" <%= IIf( strInsCheck = "1", "CHECKED", "") %>>�\�񎞂Ɋm�F����@
            <INPUT TYPE="checkbox" NAME="insBring" VALUE="1" <%= IIf( strInsBring = "1", "CHECKED", "") %>>�������Q���Ē����@
            <INPUT TYPE="checkbox" NAME="insReport" VALUE="1" <%= IIf( strInsReport = "1", "CHECKED", "") %>>���ѕ\�ɕی��؋L���A�ԍ����o�́@</TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">������</TD>
        <TD></TD>
        <!-- ## 2008.03.19 Add By �� ���������茒�f���|�[�g���ڒǉ� Start -->
        <TD>�K�p�Z���F<%= BillAddressList() %>&nbsp;&nbsp;<br>
            <INPUT TYPE="checkbox" NAME="billCslDiv"    VALUE="1" <%= IIf( strBillCslDiv = "1", "CHECKED", "") %>>�{�l�A�Ƒ��敪���o��
            <INPUT TYPE="checkbox" NAME="billIns"       VALUE="1" <%= IIf( strBillIns = "1", "CHECKED", "") %>>�ی��؋L���A�ԍ����o��
            <INPUT TYPE="checkbox" NAME="billEmpNo"     VALUE="1" <%= IIf( strBillEmpNo = "1", "CHECKED", "") %>>�Ј��ԍ����o��
            <INPUT TYPE="checkbox" NAME="billAge"       VALUE="1" <%= IIf( strBillAge = "1", "CHECKED", "") %>>�N����o��<br>
            <INPUT TYPE="checkbox" NAME="billReport1"   VALUE="1" <%= IIf( strBillReport = "1", "CHECKED", "") %> onclick="javascript:changeBillReport(1,2);">�R�A���я���Y�t
            <INPUT TYPE="checkbox" NAME="billReport2"   VALUE="2" <%= IIf( strBillReport = "2", "CHECKED", "") %> onclick="javascript:changeBillReport(2,1);">�@�荀�ڐ��я���Y�t
            <INPUT TYPE="checkbox" NAME="billSpecial"   VALUE="1" <%= IIf( strBillSpecial = "1", "CHECKED", "") %>>���茒�f���я���Y�t
            <INPUT TYPE="checkbox" NAME="billFD"        VALUE="1" <%= IIf( strBillFD = "1", "CHECKED", "") %>>FD����
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
<!-- ## 2004.01.29 Add By T.Takagi@FSIT ���ڒǉ� -->
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">���я�</TD>
        <TD></TD>
        <TD><INPUT TYPE="checkbox" NAME="reptCslDiv" VALUE="1" <%= IIf(strReptCslDiv = "1", "CHECKED", "") %>>�{�l�A�Ƒ��敪���o��&nbsp;&nbsp;&nbsp;&nbsp;
        <!-- ## 2005.05.09 Add By �� �V�K�ǉ� Start -->
        <%
            '�I�v�V�����R�[�h�����݂���ꍇ�̂ݕۑ��{�^����p�ӂ���
            If strOrgCd1 <> "" Then
        %>
            <A HREF="javascript:callReportOption('<%=strOrgCd1%>','<%=strOrgCd2%>')">���я��I�v�V�����Ǘ�</A>
        <%
            End If
        %>
        <!-- ## 2005.05.09 Add By �� �V�K�ǉ� End   -->
        </TD>
    </TR>
<!-- ## 2004.01.29 Add End -->
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">���t�ē��R�����g�i���{���j</TD>
        <TD height="25"></TD>
        <TD height="25"><TEXTAREA NAME="sendComment" COLS="46" ROWS="4" STYLE="ime-mode:active;"><%= strSendComment %></TEXTAREA></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">���t�ē��R�����g�i�p���j</TD>
        <TD height="25"></TD>
        <TD height="25"><TEXTAREA NAME="sendEComment" COLS="46" ROWS="4" STYLE="ime-mode:disabled;"><%= strSendEComment %></TEXTAREA></TD>
    </TR>
    <TR height="6">
        <TD ALIGN="right" height="6"></TD>
        <TD height="6"></TD>
        <TD height="6"></TD>
    </TR>
    <TR>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR>
        <TD height="25" bgcolor="#eeeeee" ALIGN="right">�ėp���ڂ��̂P</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="spare1" SIZE="15" MAXLENGTH="12" VALUE="<%= strSpare(0) %>">&nbsp;���ی��Ҕԍ�</TD>
    </TR>
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" ALIGN="right">�ėp���ڂ��̂Q</TD>
        <TD height="24"></TD>
        <TD height="24"><INPUT TYPE="text" NAME="spare2" SIZE="15" MAXLENGTH="12" VALUE="<%= strSpare(1) %>">&nbsp;���g���ԍ�</TD>
    </TR>
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" ALIGN="right">�ėp���ڂ��̂R</TD>
        <TD height="24"></TD>
        <TD height="24"><INPUT TYPE="text" NAME="spare3" SIZE="15" MAXLENGTH="12" VALUE="<%= strSpare(2) %>"></TD>
    </TR>
<!-- 2004/01/22 Updated by Ishihara@FSIT �R�����g�̓R�����g�ɓ���
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" ALIGN="right">�c�̂Ɋւ���ʏ�R�����g</TD>
        <TD height="24"></TD>
        <TD height="24"><TEXTAREA NAME="notes" COLS="60" ROWS="4" STYLE="ime-mode:active;"><%= strNotes %></TEXTAREA></TD>
    </TR>
-->
    <TR height="24">
        <TD></TD>
        <TD></TD>
        <TD><FONT COLOR="RED"><B>2004/1/22�X�V:<BR>�R�����g�̓R�����g���Ƃ��ēo�^�ꏊ���܂Ƃ߂܂����B<BR>���̃y�[�W�̍ŏ㕔�R�����g�{�^������o�^���Ă��������B<BR>
        �i�����֘A�R�����g���ŏ㕔�R�����g�{�^���ɂ܂Ƃ߂�\��ł��j
        <INPUT TYPE="HIDDEN" NAME="notes"><%= strNotes %></INPUT>
        </B></FONT>
        </TD>
    </TR>
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" align="right">�����֘A�R�����g</TD>
        <TD height="24"></TD>
        <TD height="24"><TEXTAREA NAME="dmdComment" COLS="60" ROWS="4" STYLE="ime-mode:active;"><%= strDmdComment %></TEXTAREA></TD>
        <TD></TD>
    </TR>
    <TR height="7">
        <TD height="7" ALIGN="right"></TD>
        <TD height="7"></TD>
        <TD height="7"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�X�V����</TD>
        <TD></TD>
        <TD><INPUT TYPE="hidden" NAME="updDate" VALUE="<%= strUpdDate %>"><%= strUpdDate %></TD>
    </TR>
    <INPUT TYPE="hidden" NAME="updUser"  VALUE="<%= strUpdUser  %>">
    <INPUT TYPE="hidden" NAME="userName" VALUE="<%= strUserName %>">
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�I�y���[�^�h�c</TD>
        <TD></TD>
        <TD><%= strUserName %></TD>
    </TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
