<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �l�ԋ���� (Ver0.0.1)
'      AUTHER  : keiko fujii@ffcs.co.jp
'             2004.01.19 �������Ɠ����悤�ɓ������@��I�ׂ�K�v������̂�
'                        ��������ʂ��R�s�[���čč쐬
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- '### 2004/11/30 Add by gouda@FSIT �v�����ǉ����� -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/GetCalcDate.inc" -->
<!-- '### 2004/11/30 End -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objFree             '�ėp���A�N�Z�X�p
Dim objPerBill          '��v���A�N�Z�X�p
Dim objHainsUser        '���[�U���A�N�Z�X�p
Dim objConsult          '��f���A�N�Z�X�p
Dim objPerson           '�l���A�N�Z�X�p
'### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
Dim objSchedule         '�X�P�W���[���A�N�Z�X�pCOM�I�u�W�F�N�g
'### 2004/11/30 Add End

Dim strMode             '�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction           '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget           '�^�[�Q�b�g���URL

Dim strPerID            '�l�h�c
Dim strLastName         '��
Dim strFirstName        '��
Dim strLastKName        '�J�i��
Dim strFirstKName       '�J�i��
Dim strCslDate          '��M��
Dim lngRsvNo            '�\��ԍ�
Dim strCtrPtCd          '�_��p�^�[���R�[�h�i��f�R�[�X�j
Dim strCsName           '��M�R�[�X��
Dim strBirth            '���N����
Dim strBirthYear        '���N����(�N)
Dim strBirthMonth       '���N����(��)
Dim strBirthDay         '���N����(��)
Dim strGender           '����

Dim lngDayId            '�����h�c�i��t�ς݃`�F�b�N�p�j
Dim strComeDate         '���@�����i��t�ς݃`�F�b�N�p�j
Dim strWrtOkFlg         '�������݂n�j�t���O

'��f���p�ϐ�
Dim strCsCd             '�R�[�X�R�[�h
Dim strAge              '�N��
Dim strGenderName       '���ʖ���
Dim strKeyDayId         '����ID

Dim strKeyDate          '���̕ԋ���
Dim lngKeySeq           '���̕ԋ��r����

Dim strOriginalDate     '������
Dim strOriginalYear     '�������i�N�j
Dim strOriginalMonth    '�������i���j
Dim strOriginalDay      '�������i���j
Dim lngOriginalSeq      '�����r����

Dim strMaxDmdDate       '��ԐV����������

Dim strPaymentDate      '�ԋ���
Dim strPaymentYear      '�ԋ����i�N�j
Dim strPaymentMonth     '�ԋ����i���j
Dim strPaymentDay       '�ԋ����i���j
Dim lngPaymentSeq       '�ԋ��r����
Dim strBillNo           '�������m��
Dim strDmdDate          '������
Dim lngBillSeq          '�������r����
Dim lngDelflg           '����`�[�t���O
Dim lngBranchNo         '�������}��
Dim lngPriceTotal       '�������z���v
Dim lngRegisterno       '���W�ԍ�
Dim lngCredit           '�����a�����
Dim lngHappy_ticket     '�n�b�s�[������
Dim lngCard             '�J�[�h
Dim strCardKind         '�J�[�h���
Dim strCardName         '�J�[�h��
Dim lngCreditslipno     '�`�[No
Dim lngJdebit           '�i�f�r�b�g
Dim strBankCode         '���Z�@�փR�[�h
Dim strBankName         '���Z�@�֖���
Dim lngCheque           '���؎�
Dim lngTransfer         '�U����     2003.12.25 add
Dim strUpdDate          '�X�V���t
Dim strUpdUser          '�X�V��
Dim strPrintDate        '�̎��������
'### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
Dim strCalcDate         '�v���
Dim strCalcDateYear     '�v����i�N�j
Dim strCalcDateMonth    '�v����i���j
Dim strCalcDateDay      '�v����i���j
Dim strCloseDate        '���ߓ�
Const strKey = "DAILYCLS"   '�ėp�e�[�u���̃L�[
'### 2004/11/30 Add End

Dim lngChangePrice      '����

Dim strUserName         '���[�U��

Dim lngBillNoCnt        '��������

Dim vntDmdDate          '������ �z��
Dim vntBillSeq          '�������r���� �z��
Dim vntBranchNo         '�������}�� �z��

Dim vntNullLastName     '��
Dim vntNullFirstName    '��
Dim vntWkLastName       '��
Dim vntWkFirstName      '��
Dim vntLastName         '���@�z��
Dim vntFirstName        '���@�z��

Dim lngPriceWork        '�������z
Dim strReqDmdDate       '������ Request
Dim strReqBillSeq       '�������r���� Request
Dim strReqBranchNo      '�������}�� Request

Dim i                   '�J�E���^

Dim strCheckCredit      '�����`�F�b�N�{�b�N�X
Dim strCheckHappy       '�n�b�s�[�������`�F�b�N�{�b�N�X
Dim strCheckCard        '�J�[�h�`�F�b�N�{�b�N�X
Dim strCheckJdebit      '�i�f�r�b�g�`�F�b�N�{�b�N�X
Dim strCheckCheque      '���؎�`�F�b�N�{�b�N�X
Dim strCheckTransfer    '�U���݃`�F�b�N�{�b�N�X      2003.12.25

Dim strArrMessage       '�G���[���b�Z�[�W
Dim Ret                 '�֐��߂�l

Dim strArrRegisterno()      '���W�ԍ�
Dim strArrRegisternoName()  '���W�ԍ�����

Dim strArrCardKind      '�J�[�h���
Dim strArrCardName      '�J�[�h����

Dim strArrBankCode      '��s�R�[�h
Dim strArrBankName      '��s����

Dim strHTML             '�Ăяo�����g�s�l�k
'## 2003.12.20 Add By T.Takagi@FSIT �̎�������Ή�
Dim strURL              'URL������
'## 2003.12.20 Add End
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strMode             = Request("mode")
strAction           = Request("act")
strTarget           = Request("target")
lngRsvNo            = Request("rsvno")
strDmdDate          = Request("dmddate")
lngBillSeq          = Request("billseq")
lngBranchNo         = Request("branchno")

strReqDmdDate       = Request("reqdmddate")
strReqBillSeq       = Request("reqbillseq")
strReqBranchNo      = Request("reqbranchno")

lngBillNoCnt        = Request("billNoCnt")
vntDmdDate          = ConvIStringToArray(Request("arrdmddate"))
vntBillSeq          = ConvIStringToArray(Request("arrbillseq"))
vntBranchNo         = ConvIStringToArray(Request("arrbranchno"))
vntLastName         = ConvIStringToArray(Request("arrlastname"))
vntFirstName        = ConvIStringToArray(Request("arrfirstname"))

strKeyDate          = Request("keyDate")
lngKeySeq           = Request("keySeq")
strOriginalDate     = Request("originalDate")
lngOriginalSeq      = Request("originalSeq")

strMaxDmdDate       = Request("maxDmdDate")

strPerId            = Request("perId")
strBirth            = Request("Birth")
strGender           = Request("gender")
strPaymentDate      = Request("paymentDate")
strPaymentYear      = Request("pYear")
strPaymentMonth     = Request("pMonth")
strPaymentDay       = Request("pDay")
lngPaymentSeq       = Request("paymentSeq")
lngPriceTotal       = Request("priceTotal")
lngRegisterno       = Request("registernoval")
lngCredit           = Request("credit")
lngHappy_ticket     = Request("happy_ticket")
lngCard             = Request("card")
strCardKind         = Request("cardKind")
lngCreditslipno     = Request("creditslipno")
lngJdebit           = Request("jdebit")
strBankCode         = Request("bankCode")
lngCheque           = Request("cheque")
'## �U���݁@�ǉ� 2003.12.25
lngTransfer         = Request("transfer")
strUpdDate          = Request("updDate")
strUpdUser          = Session.Contents("userId")
lngChangePrice      = Request("changeprice")
'### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
strCalcDate         = Request("calcDate")
strCalcDateYear     = Request("cYear")
strCalcDateMonth    = Request("cMonth")
strCalcDateDay      = Request("cDay")
'### 2004/11/30 Add End

strCheckCredit      = Request("checkCredit")
strCheckHappy       = Request("checkHappy")
strCheckCard        = Request("checkCard")
strCheckJdebit      = Request("checkJdebit")
strCheckCheque      = Request("checkCheque")
strCheckTransfer    = Request("checkTransfer")

'���W�ԍ��E���̂̔z��쐬
Call CreateRegisternoInfo()

'�p�����^�̃f�t�H���g�l�ݒ�
lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )

'���ԋ��̏ꍇ�A�V�X�e���N������K�p����
If strPaymentYear = "" Then
    strPaymentYear  = CStr(Year(Now))
    strPaymentMonth = CStr(Month(Now))
    strPaymentDay   = CStr(Day(Now))
End If

'### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
'���ߓ��̎擾
objFree.SelectFree 0, strKey, , , strCloseDate

'�v����̎擾
Call GetCalcDate(strPaymentYear, strPaymentMonth,  strPaymentDay,  _
                strCalcDateYear, strCalcDateMonth, strCalcDateDay, _
                strCloseDate)
'### 2004/11/30 Update End

'2004.01.10 add
lngRegisterno = IIF( IsNumeric(lngRegisterno)=False, 1, lngRegisterno )


'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    strWrtOkFlg = ""
    '�\��ԍ�������ꍇ
    If lngRsvNo <> 0 Then

        ''' ��t�󋵁A���@�󋵂��K�v�Ȃ��߁A���@���擾�����ɕύX
        '��f��񌟍�
'		Ret = objConsult.SelectRslConsult(lngRsvNo,      _
'						  strPerId,      _
'						  strCslDate,    _
'						  strCsCd,       _
'						  strCsName,     _
'						  strLastName,   _
'						  strFirstName,  _
'						  strLastKName,  _
'						  strFirstKName, _
'						  strBirth,      _
'						  strAge,        _
'						  strGender,     _
'						  strGenderName, _
'						  strKeyDayId)

        '���@��񌟍�
        Ret = objConsult.SelectWelComeInfo(lngRsvNo,        _
                                        ,                   _
                                        strCslDate,         _
                                        strPerId,           _
                                        strCsCd,            _
                                        ,   ,   ,   ,       _
                                        strAge,             _
                                        ,   ,   ,   ,   ,   _
                                        ,   ,   ,   ,   ,   _
                                        lngDayId,           _
                                        strComeDate,        _
                                        ,   ,   ,           _
                                        strBirth,           _
                                        strGender,          _
                                        strLastName,        _
                                        strFirstName,       _
                                        strLastKName,       _
                                        strFirstKName,      _
                                        ,   ,   ,   ,   ,   _
                                        strCsName           _
                                    )

        '��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
        If Ret = False Then
            Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
        End If

        '��t�ς݁@���@���@�ς�
        If lngDayId <> "" And strComeDate <> "" Then
            strWrtOkFlg = "1"
        End If

    Else
        '�l�h�c������ꍇ
        If strPerId <> "" Then
            '�l�h�c�����擾����
            Ret = objPerson.SelectPerson_lukes(strPerId, _
                            strLastName, _
                            strFirstName, _
                            strLastKName, _
                            strFirstKName, _
                            ,  _
                            strBirth, _
                            strGender )
            '�l��񂪑��݂��Ȃ��ꍇ
            If Ret = False Then
                Err.Raise 1000, , "�l��񂪎擾�ł��܂���B�i�l�h�c�@= " & strPerId &" �j"
            End If
            strGenderName = IIf( strGender="1", "�j��", "����" )

            strAge = objFree.CalcAge(strBirth)
            
            '�������Ɏ�t�Ϗ��
            strWrtOkFlg = "1"
        End If
    End If


    '�폜�{�^��������
    If strAction = "delete" Then

        Ret = objPerBill.DeletePerPayment ( _
                        strKeyDate, _
                        lngKeySeq ) 
        
'		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=insert&act=deleteend&rsvno=" & lngRsvNo & "&dmddate=" & strDmdDate  & "&billseq=" & lngBillSeq & "&branchno=" & lngBranchNo
        '�G���[���Ȃ���ΌĂь���ʂ��ĕ\�����Ď��g�����
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
        strHTML = strHTML & "</BODY>"
        strHTML = strHTML & "</HTML>"
        Response.Write strHTML
        Response.End
        Exit Do

    End If

    '�ۑ��{�^��������
    If strAction = "save" Then
        IF lngPriceTotal >= 0 Then
            lngChangePrice = - CLng(lngPriceTotal)
        End if

        '���z:���l���̓`�F�b�N
        lngCredit = IIf( lngCredit = "", 0, lngCredit )

        '### 2005/09/30 �� (-)�ԋ������ׁ̈A�C�� Start ###
        'strArrMessage = objCommon.CheckNumeric("����", lngCredit, 8)
        'If strArrMessage <> "" Then
        '        Err.Raise 1000, , "�����G���[�B " 
        '    Exit Do
        'End If

        strArrMessage = objCommon.CheckNumericSign("����", lngCredit, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "�����G���[�B " 
            Exit Do
        End If
        '### 2005/09/30 �� (-)�ԋ������ׁ̈A�C�� End   ###

        
        lngHappy_ticket = IIf( lngHappy_ticket = "", 0, lngHappy_ticket )
        strArrMessage = objPerBill.CheckNumeric("�n�b�s�[������", lngHappy_ticket, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "�n�b�s�[�������G���[�B " 
            Exit Do
        End If
        lngCard = IIf( lngCard = "", 0, lngCard )
        strArrMessage = objPerBill.CheckNumeric("�J�[�h", lngCard, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "�J�[�h�G���[�B " 
            Exit Do
        End If
        lngJdebit = IIf( lngJdebit = "", 0, lngJdebit )
        strArrMessage = objPerBill.CheckNumeric("�i�f�r�b�g", lngJdebit, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "�i�f�r�b�g�G���[�B " 
            Exit Do
        End If
        lngCheque = IIf( lngCheque = "", 0, lngCheque )
        strArrMessage = objPerBill.CheckNumeric("���؎�", lngCheque, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "���؎�G���[�B " 
            Exit Do
        End If
        lngTransfer = IIf( lngTransfer = "", 0, lngTransfer )
        strArrMessage = objPerBill.CheckNumeric("�U����", lngTransfer, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "�U���݃G���[�B " 
            Exit Do
        End If

        lngChangePrice = (CLng(lngCredit) + CLng(lngHappy_Ticket) + CLng(lngCard) + CLng(lngJdebit) + CLng(lngCheque) + CLng(lngTransfer)) - CLng(lngPriceTotal)

        '�`�[No.:���l���̓`�F�b�N
        lngCreditslipno = IIf( lngCreditslipno = "", 0, lngCreditslipno )
        strArrMessage = objPerBill.CheckNumeric("�`�[No.", lngCreditslipno, 5)
        If strArrMessage <> "" Then
            Exit Do
        End If

        '�ԋ����̕ҏW
' ### 2004/11/30 Update by gouda@FSIT �ԋ����̃`�F�b�N��ǉ�����
'       strPaymentDate = CDate(strPaymentYear & "/" & strPaymentMonth & "/" & strPaymentDay)
        strPaymentDate = strPaymentYear & "/" & strPaymentMonth & "/" & strPaymentDay
' ### 2004/11/30 Update

' ### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
        '�v����̕ҏW
        strCalcDate = strCalcDateYear & "/" & strCalcDateMonth & "/" & strCalcDateDay
' ### 2004/11/30 Add End

        '���̓`�F�b�N
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

' ### 2004/11/30 Update by gouda@FSIT �ԋ����̃`�F�b�N��ǉ�����
        strPaymentDate = CDate(strPaymentYear & "/" & strPaymentMonth & "/" & strPaymentDay)
' ### 2004/11/30 Update End

' ### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
        strCalcDate = CDate(strCalcDateYear & "/" & strCalcDateMonth & "/" & strCalcDateDay)
' ### 2004/11/30 Add End


''###2005/10/17 by ���@####################################
'		If lngPriceTotal > 0 Then
'			lngPriceTotal = -1 * lngPriceTotal
'		End If
'		If lngCredit > 0 Then
'			lngCredit = -1 * lngCredit
'		End If
'		If lngHappy_ticket > 0 Then
'			lngHappy_ticket = -1 * lngHappy_ticket
'		End If
'		If lngCard > 0 Then
'			lngCard = -1 * lngCard
'		End If
'		If lngJdebit > 0 Then
'			lngJdebit = -1 * lngJdebit
'		End If
'		If lngCheque > 0 Then
'			lngCheque = -1 * lngCheque
'		End If
'		If lngTransfer > 0 Then
'			lngTransfer = -1 * lngTransfer
'		End If

        lngPriceTotal = -1 * lngPriceTotal
        lngCredit = -1 * lngCredit
        lngHappy_ticket = -1 * lngHappy_ticket
        lngCard = -1 * lngCard
        lngJdebit = -1 * lngJdebit
        lngCheque = -1 * lngCheque
        lngTransfer = -1 * lngTransfer


        '### 2004.01.19�ȑO�͕ۑ����Ɉ����P�Ԗځ��Q�Ƃ��A�b�n�l�{�ŕԋ������Ƃ���
        '�@�@���̓������z�Ɂ|�P�������ēo�^���Ă������ԋ������C�ӂɕԋ����@��I�ׂ�悤��
        '    �Ȃ����̂ŁA���������Ɠ����ۑ����@�ƂȂ���
        '�ۑ�����
        If strMode = "insert" Then
'### 2004/11/25 Updated by Ishihara@FSIT �Ƃ肠�������}�[�u
'			strArrMessage = objPerBill.InsertPerPayment( _
'                                                        1, _
'							strPaymentDate, lngPaymentSeq, _
'                                                        "", "", _
'    							vntDmdDate, vntBillSeq, _
'							vntBranchNo, _
'							lngRegisterno, _
'							strUpdUser, lngPriceTotal, _
'							lngCredit, lngHappy_ticket, lngCard, _
'							strCardKind, lngCreditslipno, _
'							lngJdebit,     strBankCode, _
'							lngCheque,     lngTransfer _
'						)
' ### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
'			strArrMessage = objPerBill.InsertPerPayment( _
'                                                        1, _
'							strPaymentDate, lngPaymentSeq, _
'                                                        "", "", _
'    							vntDmdDate, vntBillSeq, _
'							vntBranchNo, _
'							lngRegisterno, _
'							strUpdUser, lngPriceTotal, _
'							lngCredit, lngHappy_ticket, lngCard, _
'							strCardKind, lngCreditslipno, _
'							lngJdebit,     strBankCode, _
'							lngCheque,     lngTransfer, cDate(Now) _
'						)
'### 2004/11/25 Updated End
'		Else
'			strArrMessage = objPerBill.UpdatePerPayment( _
'							1, strKeyDate, lngKeySeq, _
'							strPaymentDate, lngPaymentSeq, _
'    							vntDmdDate, vntBillSeq, _
'							vntBranchNo, _
'							lngPriceTotal, lngRegisterno, _
'							strUpdUser, _
'							lngCredit, lngHappy_ticket, lngCard, _
'							strCardKind, lngCreditslipno, _
'							lngJdebit, strBankCode, _
'							lngCheque,     lngTransfer _
'						)
'		End IF

            strArrMessage = objPerBill.InsertPerPayment( _
                                                        1, _
                            strPaymentDate, lngPaymentSeq, _
                                                        "", "", _
                                vntDmdDate, vntBillSeq, _
                            vntBranchNo, _
                            lngRegisterno, _
                            strUpdUser, lngPriceTotal, _
                            lngCredit, lngHappy_ticket, lngCard, _
                            strCardKind, lngCreditslipno, _
                            lngJdebit,     strBankCode, _
                            lngCheque,     lngTransfer, strCalcDate _
                        )
        
        Else

            
            strArrMessage = objPerBill.UpdatePerPayment( _
                            1, strKeyDate, lngKeySeq, _
                            strPaymentDate, lngPaymentSeq, _
                                vntDmdDate, vntBillSeq, _
                            vntBranchNo, _
                            lngPriceTotal, lngRegisterno, _
                            strUpdUser, _
                            lngCredit, lngHappy_ticket, lngCard, _
                            strCardKind, lngCreditslipno, _
                            lngJdebit, strBankCode, _
                            lngCheque,     lngTransfer, strCalcDate _
                        )
        End IF
' ### 2004/11/30 Add End

        '�X�V�G���[���͏����𔲂���
        If Not IsEmpty(strArrMessage) Then
'               Err.Raise 1000, , "�ۑ��G���[�B " 
            Exit Do
        End If

        '�G���[���Ȃ���ΌĂь���ʂ��ĕ\�����Ď��g�����
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
        strHTML = strHTML & "</BODY>"
        strHTML = strHTML & "</HTML>"
        Response.Write strHTML
        Response.End
        Exit Do

    End If


    '�������m������l�������Ǘ������擾����
    objPerbill.SelectPerBill_BillNo strDmdDate, _
                           lngBillSeq, _
                           lngBranchNo, _
                           lngDelflg, _
                           , _
                           , _
                           , _
                           , _
                           strPaymentDate, _
                           lngPaymentSeq, _
                           , _
                           , _
                           , _
                           , _
                           lngPriceTotal, _
                           , _
                           strPrintDate


    '���ԋ��H
    If IsNull(strPaymentDate) = True Then
        strMode = "insert"
        '���̐��������擾
        objPerbill.SelectPerBill_BillNo strDmdDate, _
                           lngBillSeq, _
                           "0", _
                           lngDelflg, _
                           , _
                           , _
                           , _
                           , _
                           strOriginalDate, _
                           lngOriginalSeq, _
                           , _
                           , _
                           , _
                           , _
                           lngPriceTotal


        '�ԋ��N�����̕ҏW
        strOriginalDate = CDate(strOriginalDate)
        strOriginalYear  = CStr(Year(strOriginalDate))
        strOriginalMonth = CStr(Month(strOriginalDate))
        strOriginalDay   = CStr(Day(strOriginalDate))

        strPaymentDate = strOriginalDate
        lngPaymentSeq  = lngOriginalSeq

        '����ԋ��̐������m���擾
''' ���O���擾����@2003.12.19 
'		lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
'						strOriginalDate, _
'						lngOriginalSeq, _
'						vntDmdDate, _
'						vntBillSeq, _
'						vntBranchNo )
        lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
                        strOriginalDate, _
                        lngOriginalSeq, _
                        vntDmdDate, _
                        vntBillSeq, _
                        vntBranchNo, _
                        vntLastName, vntFirstName )

        If lngBillNoCnt <= 0 Then
            Exit Do
        End If

    Else
        strMode = "update"
        '�ԋ��N�����̕ҏW
        strPaymentDate = CDate(strPaymentDate)
        strPaymentYear  = CStr(Year(strPaymentDate))
        strPaymentMonth = CStr(Month(strPaymentDate))
        strPaymentDay   = CStr(Day(strPaymentDate))

        strKeyDate = strPaymentDate
        lngKeySeq  = lngPaymentSeq

''' ���O���擾����@2003.12.18 
'		lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
'						strPaymentDate, _
'						lngPaymentSeq, _
'						vntDmdDate, _
'						vntBillSeq, _
'						vntBranchNo )
        lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
                        strPaymentDate, _
                        lngPaymentSeq, _
                        vntDmdDate, _
                        vntBillSeq, _
                        vntBranchNo, _
                        vntLastName, vntFirstName )
        If lngBillNoCnt <= 0 Then
            Exit Do
        End If

    End If

    For i = 0 To UBound(vntBranchNo)
        vntBranchNo(i) = 1
    Next 
    For i = 0 To UBound(vntDmdDate)
        If strMaxDmdDate < vntDmdDate(i) Then
            strMaxDmdDate = vntDmdDate(i)
        End If
    Next

    '�V�K���[�h�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
'	If strMode = "insert" Then
'		lngChangePrice = -1
'
'		Exit Do
'	End If

    '### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
    '### �U����(TRANSFER)��ǉ� 2003.12.25
'	objPerBill.SelectPerPayment _
'    						strPaymentDate, lngPaymentSeq, _
'    						lngPriceTotal, lngCredit, _
'    						lngHappy_ticket, lngCard, _
'						strCardKind, strCardName, _
'    						lngCreditslipno, _
'						lngJdebit, strBankCode, _
'						strBankName, lngCheque, _
'						lngRegisterno, strUpdDate, _
'    						strUpdUser, strUserName, _
'							lngTransfer 
    objPerBill.SelectPerPayment _
                            strPaymentDate, lngPaymentSeq, _
                            lngPriceTotal, lngCredit, _
                            lngHappy_ticket, lngCard, _
                        strCardKind, strCardName, _
                            lngCreditslipno, _
                        lngJdebit, strBankCode, _
                        strBankName, lngCheque, _
                        lngRegisterno, strUpdDate, _
                            strUpdUser, strUserName, _
                            lngTransfer, strCalcDate 
    '### 2004/11/30 Add End

    '�V�K���[�h�̏ꍇ�͍X�V���t�N���A
    If strMode = "insert" Then
        strUpdDate = ""
'### 2004/02/12 Added by Ishihara@FSIT �I�y���[�^���N���A���Ă��������B
        strUpdUser = ""
        strUserName = ""
'### 2004/02/12 Added End
    
    Else
'' 2005/10/17 Edit by ���@###################################
'    	If lngPriceTotal < 0 Then
'	    	lngPriceTotal = -1 * lngPriceTotal
'      	End If
'        If lngCredit < 0 Then
'		    lngCredit = -1 * lngCredit
'    	End If
'	    If lngHappy_ticket < 0 Then
'		    lngHappy_ticket = -1 * lngHappy_ticket
 '   	End If
'	    If lngCard < 0 Then
'		    lngCard = -1 * lngCard
 '   	End If
'	    If lngJdebit < 0 Then
'		    lngJdebit = -1 * lngJdebit
 '   	End If
'	    If lngCheque < 0 Then
'		    lngCheque = -1 * lngCheque
 '   	End If
'	    If lngTransfer < 0 Then
'		    lngTransfer = -1 * lngTransfer
 '   	End If

    lngPriceTotal = -1 * lngPriceTotal
    lngCredit = -1 * lngCredit
    lngHappy_ticket = -1 * lngHappy_ticket
    lngCard = -1 * lngCard
    lngJdebit = -1 * lngJdebit
    lngCheque = -1 * lngCheque
    lngTransfer = -1 * lngTransfer

'' 2005/10/17 Edit by ���@###################################    
    End If


'' 2005/10/17 Edit by ���@###################################
'	strCheckCredit   = IIf(CLng(lngCredit) > 0, "1",  "" )
    strCheckCredit   = IIf(CLng(lngCredit) > 0, "1",  "1" )
'' 2005/10/17 Edit by ���@###################################

    strCheckHappy    = IIf(CLng(lngHappy_ticket) > 0, "2",  "" )
    strCheckCard     = IIf(CLng(lngCard) > 0, "3",  "" )
    strCheckJdebit   = IIf(CLng(lngJdebit) > 0, "4",  "" )
    strCheckCheque   = IIf(CLng(lngCheque) > 0, "5",  "" )
    '### �U����(TRANSFER)��ǉ� 2003.12.25
    strCheckTransfer   = IIf(CLng(lngTransfer) > 0, "6",  "" )

    '### �U����(TRANSFER)��ǉ� 2003.12.25
'	lngChangePrice = (CLng(lngCredit) + CLng(lngHappy_Ticket) + CLng(lngCard) + CLng(lngJdebit) + CLng(lngCheque)) - CLng(lngPriceTotal)
    lngChangePrice = (CLng(lngCredit) + CLng(lngHappy_Ticket) + CLng(lngCard) + CLng(lngJdebit) + CLng(lngCheque) + CLng(lngTransfer)) - CLng(lngPriceTotal)

    '### 2004/11/30 Update by gouda@FSIT �v�����ǉ�����
    '�V�K���[�h�̏ꍇ�͕\�����Ȃ�
    If Not strMode = "insert" Then
        strCalcDateYear  = CStr(Year(strCalcDate))
        strCalcDateMonth = CStr(Month(strCalcDate))
        strCalcDateDay   = CStr(Day(strCalcDate))
    End If
    '### 2004/11/30 Update End

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���W�ԍ��E���̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateRegisternoInfo()

    Redim Preserve strArrRegisterno(2)
    Redim Preserve strArrRegisternoName(2)

    strArrRegisterno(0) = "1":strArrRegisternoName(0) = "1"
    strArrRegisterno(1) = "2":strArrRegisternoName(1) = "2"
    strArrRegisterno(2) = "3":strArrRegisternoName(2) = "3"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �ԋ����̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()
    Dim vntArrMessage   '�G���[���b�Z�[�W�̏W��
    Dim strMessage      '�G���[���b�Z�[�W

    '�e�l�`�F�b�N����
    With objCommon
        ' ### 2004/11/30 Update by gouda@FSIT �ԋ����̃`�F�b�N��ǉ�����
'		If Trim(strMaxDmdDate) > Trim(strPaymentDate) Then
'			.AppendArray vntArrMessage, "�ԋ��������������ߋ��ł��B"
'		End If

        If Not IsDate(Trim(strPaymentDate)) Then
            .AppendArray vntArrMessage, "�ԋ����̓��͌`��������������܂���B"
        Else
            If CDate(strMaxDmdDate) > CDate(strPaymentDate) Then
                .AppendArray vntArrMessage, "�ԋ����͐����������ߋ��̓��t�ɐݒ肷�邱�Ƃ͂ł��܂���B"
            End If
        End If
        ' ### 2004/11/30 Update End
        
        ' ### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
        If Not IsDate(Trim(strCalcDate)) Then
            .AppendArray vntArrMessage, "�v����̓��͌`��������������܂���B"
        Else
            If IsDate(Trim(strPaymentDate)) Then
                If CDate(strPaymentDate) > CDate(strCalcDate) Then
                    .AppendArray vntArrMessage, "�v����͕ԋ��������ߋ��̓��t�ɐݒ肷�邱�Ƃ͂ł��܂���B"
                End If
            End If
        End If
        ' ### 2004/11/30 Add End

        If lngCard <> 0 And _
                (strCardKind = "" Or lngCreditslipno = 0) Then
            .AppendArray vntArrMessage, "�J�[�h��񂪓��͂���Ă��܂���B"
        End If
        
        If lngJdebit <> 0 And strBankCode = "" Then
            .AppendArray vntArrMessage, "�i�f�r�b�g�̋��Z�@�ւ��w�肳��Ă��܂���B"
        End If

'		if lngChangePrice < 0 Then
'			.AppendArray vntArrMessage, "�ԋ����z���������z�ɒB���Ă��Ȃ����ߕۑ��ł��܂���B"
'		End If

    End With

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�ԋ����</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!-- #include virtual = "/webHains/includes/price.inc" -->
<!--
var winAllocate, winGuideOrg, winGuideCal;
var curYear, curMonth, curDay;	// ���t�K�C�h�Ăяo�����O�̓��t�ޔ�p�ϐ�

var varChangePrice, varCredit, varlngHappy_Ticket,varCard, varJdebit, varCheque, varPriceTotal;
// 2003.12.25 �U���݁@�ǉ�
var varTransfer;

// ### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
var curYear_Calc, curMonth_Calc, curDay_Calc;	// �v����̓��t�K�C�h�Ăяo�����O�̓��t�ޔ�p�ϐ�
// ### 2004/11/30 Add End

// ���t�K�C�h�Ăяo��
function callCalGuide() {

    // �K�C�h�Ăяo�����O�̓��t��ޔ�
    curYear  = document.entryForm.pyear.value;
    curMonth = document.entryForm.pmonth.value;
    curDay   = document.entryForm.pday.value;

    // ���t�K�C�h�\��
    calGuide_showGuideCalendar( 'pyear', 'pmonth', 'pday', checkDateChanged );

}

// �ԋ����ύX�`�F�b�N
function checkDateChanged() {

    // �ޔ����Ă������t�ƈقȂ�ꍇ�A��f���ύX���̏������Ăяo��
    with ( document.entryForm ) {
        if ( pyear.value != curYear || pmonth.value != curMonth || pday.value != curDay ) {
//			replaceOptionFrame();
        }
    }

}

// ### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
// �v����̓��t�K�C�h�Ăяo��
function callCalGuide_Calc() {

    // �K�C�h�Ăяo�����O�̓��t��ޔ�
    curYear_Calc  = document.entryForm.cyear.value;
    curMonth_Calc = document.entryForm.cmonth.value;
    curDay_Calc   = document.entryForm.cday.value;

    // ���t�K�C�h�\��
    calGuide_showGuideCalendar( 'cyear', 'cmonth', 'cday', checkDateChanged_Calc );

}

// �v����ύX�`�F�b�N
function checkDateChanged_Calc() {

    // �ޔ����Ă������t�ƈقȂ�ꍇ�A��f���ύX���̏������Ăяo��
    with ( document.entryForm ) {
        if ( cyear.value != curYear_Calc || cmonth.value != curMonth_Calc || cday.value != curDay_Calc ) {
        }
    }

}
// ### 2004/11/30 Add End

function checkCreditAct() {

    with ( document.entryForm ) {
        checkCredit.value = (checkCredit.checked ? '1' : '');
        credit.value = (checkCredit.checked ? credit.value : '');
    }

    CalcChange();
}

function checkHappyAct() {

    with ( document.entryForm ) {
        checkHappy.value = (checkHappy.checked ? '2' : '');
        happy_ticket.value = (checkHappy.checked ? happy_ticket.value : '');
    }

    CalcChange();
}

function checkCardAct() {

    with ( document.entryForm ) {
        checkCard.value = (checkCard.checked ? '3' : '');
        card.value = (checkCard.checked ? card.value : '');
        creditslipno.value = (checkCard.checked ? creditslipno.value : '');
    }

    CalcChange();
}

function checkJdebitAct() {

    with ( document.entryForm ) {
        checkJdebit.value = (checkJdebit.checked ? '4' : '');
        jdebit.value = (checkJdebit.checked ? jdebit.value : '');
    }

    CalcChange();
}

function checkChequeAct() {

    with ( document.entryForm ) {
        checkCheque.value = (checkCheque.checked ? '5' : '');
        cheque.value = (checkCheque.checked ? cheque.value : '');
    }

    CalcChange();
}

// 2003.12.25 �U���݁@�ǉ�
function checkTransferAct() {

    with ( document.entryForm ) {
        checkTransfer.value = (checkTransfer.checked ? '6' : '');
        transfer.value = (checkTransfer.checked ? transfer.value : '');
    }

    CalcChange();
}

// �G���^�[�L�[�������̏��� 2004.01.04
function keyPressFunc() {

    if ("13" == window.event.keyCode) {
        CalcChange();
    }

}

function CalcChange() {

    var dayid;
    var comedate;

    with ( document.entryForm ) {
        varCredit = credit.value - 0 ;
                varHappy_Ticket = happy_ticket.value - 0 ;
                varCard = card.value - 0 ;
                varJdebit = jdebit.value - 0 ;
                varCheque = cheque.value - 0 ;
                // 2003.12.25 �U���݁@�ǉ�
                varTransfer = transfer.value - 0 ;
                varPriceTotal = pricetotal.value - 0;

    }

    // 2003.12.25 �U���݁@�ǉ�
//	varChangePrice = (varCredit + varHappy_Ticket + varCard + varJdebit + varCheque) - varPriceTotal;
    varChangePrice = (varCredit + varHappy_Ticket + varCard + varJdebit + varCheque + varTransfer) - varPriceTotal;

    dayid = '<%= lngDayId %>';
    comedate = '<%= strComeDate %>';
    if( varChangePrice == 0 ){
        document.getElementById('changeprice').innerHTML = '�ԋ��z�ɒB���܂���';
    } else if( varChangePrice > 0 ){
        document.getElementById('changeprice').innerHTML = formatCurrency(varChangePrice) + '�@���߂��Ă��܂�';
    } else {
        //����t�̏ꍇ
        if ( dayid == '' ){
            document.getElementById('changeprice').innerHTML = '�܂��󂯕t���Ă��܂���';
        } else {
            //�����@�̏ꍇ
            if ( comedate == '' ){
                document.getElementById('changeprice').innerHTML = '�܂����@���Ă��܂���';
            } else {
                document.getElementById('changeprice').innerHTML = '�ԋ��z�ɒB���Ă��܂���';
            }
        }
    }

}


//-->


<!--
// �폜�m�F���b�Z�[�W
function deleteData() {

    if ( !confirm( '���̕ԋ������폜���܂��B��낵���ł����H' ) ) {
        return;
    }


    // ���[�h���w�肵��submit
    document.entryForm.act.value = 'delete';
    document.entryForm.mode.value = 'delete';
    document.entryForm.submit();

}


// ����ʏ���
function goNextPage() {

    with ( document.entryForm ) {
        varCredit = credit.value - 0 ;
                varHappy_Ticket = happy_ticket.value - 0 ;
                varCard = card.value - 0 ;
                varJdebit = jdebit.value - 0 ;
                varCheque = cheque.value - 0 ;
                // 2003.12.25 �U���݁@�ǉ�
                varTransfer = transfer.value - 0 ;
                varPriceTotal = pricetotal.value - 0;
        // ���t�ϊ�
        varPaymenDate = formatDate( pyear.value, pmonth.value, pday.value );
        // ### 2004/11/30 Add by gouda@FSIT �v�����ǉ�����
        varCalcDate = formatDate( cyear.value, cmonth.value, cday.value );
        // ### 2004/11/30 Add End

    }
    // ����
//	varChangePrice = (varCredit + varHappy_Ticket + varCard + varJdebit + varCheque) - varPriceTotal;

    if (varCard == 0){
        document.entryForm.cardkind.value = '';
        document.entryForm.creditslipno.value = '';
    }
    if (varJdebit == 0){
        document.entryForm.bankcode.value = '';
    }

    // ����ʂ𑗐M
    document.entryForm.submit();

//	return false;
}

// ���WNo���I�����ꂽ�Ƃ��̏��� 2004.01.04 add
function selectRegiNo( val ) {

    var curDate = new Date();
    var previsit = curDate.toGMTString();

    curDate.setTime( curDate.getTime() + 30*365*24*60*60*1000 ); // 30�N��

    var expire = curDate.toGMTString();

    document.cookie = 'regino=' + val + ';expires=' + expire;

    document.entryForm.registernoval.value = val;

}

// �e�E�C���h�E�֖߂�
function goBackPage() {

    // �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
    if ( opener.dmdPayment_CalledFunction != null ) {
        opener.dmdPayment_CalledFunction();
    }

    close();

    return false;
}
function windowClose() {

    //���t�K�C�h�����
    calGuide_closeGuideCalendar();

}

// '### 2004/11/30 Add by gouda@FSIT �v�����ǉ����� -->
// �m��{�^���������̏���
// ���ߓ��ƌv������������t�ɂȂ��Ă��Ȃ����`�F�b�N
function PreserveCheck() {

    var closedate;
    var calcdate;
    var calcdateyear;
    var calcdatemonth;
    var calcdateday;
    var msg;

    closedate = '<%= strCloseDate %>';

    calcdateyear = document.entryForm.cyear.value;
    calcdatemonth = document.entryForm.cmonth.value;
    calcdateday = document.entryForm.cday.value;

    if ( calcdatemonth.length == 1 ) {
        calcdatemonth = '0' + calcdatemonth
    }

    if ( calcdateday.length == 1 ) {
        calcdateday = '0' + calcdateday
    }

    calcdate = '';
    calcdate = calcdateyear + '/' + calcdatemonth + '/' + calcdateday;

    if ( calcdate == closedate ) {

        msg = '';
        msg = '�������ߏ������������Ă�����ɂ��ɑ΂��Ă̏��������s���悤�Ƃ��Ă��܂��B��낵���ł����H';
    
        if ( confirm(msg) ) {
            return true;
        } else {
            return false;
        }
    } else {
        return true;
    }
}
// '### 2004/11/30 Add

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.credit.focus()" ONUNLOAD="javascript:windowClose()">
    <FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><SPAN CLASS="demand">��</SPAN><B>�ԋ����</B></TD>
        </TR>
    </TABLE>
    <!-- ������� -->
    <INPUT TYPE="hidden" NAME="act"         VALUE="save">
    <INPUT TYPE="hidden" NAME="mode"        VALUE="<%= strMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="dmddate"     VALUE="<%= strDmdDate %>">
    <INPUT TYPE="hidden" NAME="billseq"     VALUE="<%= lngBillSeq %>">
    <INPUT TYPE="hidden" NAME="branchno"    VALUE="<%= lngBranchNo %>">
    <INPUT TYPE="hidden" NAME="pricetotal"  VALUE="<%= lngPriceTotal %>"> 
    <INPUT TYPE="hidden" NAME="delflg"      VALUE="<%= lngDelflg %>"> 
    <INPUT TYPE="hidden" NAME="keyDate"     VALUE="<%= strKeyDate %>"> 
    <INPUT TYPE="hidden" NAME="keySeq"      VALUE="<%= lngKeySeq %>"> 
    <INPUT TYPE="hidden" NAME="paymentDate" VALUE="<%= strPaymentDate %>"> 
    <INPUT TYPE="hidden" NAME="maxDmdDate"  VALUE="<%= strMaxDmdDate %>"> 
    <INPUT TYPE="hidden" NAME="billNoCnt"   VALUE="<%= lngBillNoCnt %>"> 
    <INPUT TYPE="hidden" NAME="perid"       VALUE="<%= strPerId %>"> 
    <!--'### 2004/11/30 Add by gouda@FSIT �v�����ǉ����� -->
    <INPUT TYPE="hidden" NAME="calcDate"    VALUE="<%= strCalcDate %>"> 
    <!--'### 2004/11/30 Add End -->

    <INPUT TYPE="hidden" NAME="reqdmddate"  VALUE="<%= strReqDmdDate %>">
    <INPUT TYPE="hidden" NAME="reqbillseq"  VALUE="<%= strReqBillSeq %>">
    <INPUT TYPE="hidden" NAME="reqbranchno" VALUE="<%= strReqBranchNo %>">
<%
    For i = 0 To lngBillNoCnt - 1
%>
    <INPUT TYPE="hidden" NAME="arrdmddate"      VALUE="<%= vntDmdDate(i) %>">
    <INPUT TYPE="hidden" NAME="arrbillseq"      VALUE="<%= vntBillSeq(i) %>">
    <INPUT TYPE="hidden" NAME="arrbranchno"     VALUE="<%= vntBranchNo(i) %>">
    <INPUT TYPE="hidden" NAME="arrlastname"     VALUE="<%= vntLastName(i) %>">
    <INPUT TYPE="hidden" NAME="arrfirstname"    VALUE="<%= vntFirstName(i) %>">
<%
    Next
%>
<%
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
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD>��f��</TD>
            <TD>�F</TD>
            <TD><FONT COLOR="#ff6600"><B><%= strCslDate %>

            <TD>�\��ԍ�</TD>
            <TD>�F</TD>
<%
            If lngRsvNo = 0 Then
%>
                <TD><FONT COLOR="#ff6600"><B></B></FONT></TD>
<%
            Else
%>
                <TD><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
<%
            End If
%>
        </TR>
        <TR>
            <TD>��f�R�[�X</TD>
            <TD>�F</TD>
            <TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD></TD>
            <TD></TD>
            <TD></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
        <TR>
            <TD HEIGHT="10"></TD>
        </TR>
        <TR>
            <TD NOWRAP ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
            <TD WIDTH="16" ROWSPAN="2"></TD>
            <TD NOWRAP><B><%= strLastName & " " & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>)</TD>
        </TR>
        <TR>
            <TD NOWRAP><%= FormatDateTime(strBirth, 1) %>���@<%= Int(strAge) %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD COLSPAN="3" NOWRAP HEIGHT="25"><SPAN STYLE="color:#cc9999">��</SPAN>�ԋ��z���m�F���Ă��������B</TD>
        </TR>
        <TR>
            <TD NOWRAP>�Ώې������ԍ�</td>
            <TD>�F</TD>
            <TD>
<%
            For i = 0 To lngBillNoCnt - 1
%>
            <%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %>�i<%= vntLastName(i) %> <%= vntFirstName(i) %>�j
<%
            Next
%>
            </TD>
        </TR>
        <TR>
            <TD>���W�ԍ�</TD>
            <TD>�F</TD>
<!---
            <td nowrap width="479"><select name="selectName" size="1">
                <option value="one">1</option>
                <option value="two">2</option>
                <option value="three">3</option>
            </select></td>
-->
            <INPUT TYPE="hidden" NAME="registernoval" VALUE="<%= lngRegisterno %>">
            <TD><SPAN ID="registerDrop"></SPAN></TD>
<!--
            <TD><%= EditDropDownListFromArray2("registerno", strArrRegisterno, strArrRegisternoName, lngRegisterno, NON_SELECTED_DEL, "javascript:selectRegiNo( document.entryForm.registerno.value )") %></TD>
-->
        </TR>
        <TR>
            <TD>�ԋ���</TD>
            <TD>�F</TD>
            <TD>
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td><a href="javascript:callCalGuide()"><img src="/webHains/images/question.gif" alt="���t�K�C�h��\��" height="21" width="21" border="0"></a></td>
                        <TD><%= EditSelectNumberList("pyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strPaymentYear)) %></TD>
                        <TD>&nbsp;�N&nbsp;</TD>
                        <TD><%= EditSelectNumberList("pmonth", 1, 12, CLng("0" & strPaymentMonth)) %></TD>
                        <TD>&nbsp;��&nbsp;</TD>
                        <TD><%= EditSelectNumberList("pday",   1, 31, CLng("0" & strPaymentDay  )) %></TD>
                        <TD>&nbsp;��</TD>
                        <td></td>
                    </tr>
                </table>
            </td>
        </tr>
<!-- '### 2004/11/30 Add by gouda@FSIT �v�����ǉ����� -->
        <TR>
            <TD>�v���</TD>
            <TD>�F</TD>
            <TD>
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td><a href="javascript:callCalGuide_Calc()"><img src="/webHains/images/question.gif" alt="���t�K�C�h��\��" height="21" width="21" border="0"></a></td>
                        <TD><%= EditNumberList("cyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strCalcDateYear), False) %></TD>
                        <TD>&nbsp;�N&nbsp;</TD>
                        <TD><%= EditNumberList("cmonth", 1, 12, CLng("0" & strCalcDateMonth), False) %></TD>
                        <TD>&nbsp;��&nbsp;</TD>
                        <TD><%= EditNumberList("cday", 1, 31, CLng("0" & strCalcDateDay  ), False) %></TD>
                        <TD>&nbsp;��</TD>
                        <td></td>
                    </tr>
                </table>
            </td>
        </tr>
<!-- '### 2004/11/30 Add End -->
        <tr>
            <td width="114">�ԋ��z</td>
            <td>�F</td>
            <td width="479"><font size="+3"><b><%= FormatCurrency(lngPriceTotal) %></b> </font></td>
        </tr>
        <tr height="15">
            <td width="114" height="15"></td>
            <td height="15"></td>
            <td width="479" height="15"></td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkCredit" value="1" <%= IIf(strCheckCredit <> "", " CHECKED", "") %>  ONCLICK="javascript:checkCreditAct()" border="0">����</td>
            <td>�F</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>�ԋ�</td>
<!--
                        <td><input type="text" name="credit" size="10" maxlength="8" value="<%= IIf(strCheckCredit <> "",lngCredit, "") %>" ONBLUR="javascript:CalcChange()" ></td>
-->
                        <td><input type="text" name="credit" size="10" maxlength="8" value="<%= IIf(lngCredit <> "0",lngCredit, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()" ></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td nowrap width="130"><input type="checkbox" name="checkHappy" value="2" <%= IIf(strCheckHappy <> "", " CHECKED", "") %>  ONCLICK="javascript:checkHappyAct()" border="0">�n�b�s�[������</td>
            <td>�F</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>�ԋ�</td>
<!--
                        <td><input type="text" name="happy_ticket" size="10" maxlength="8" value="<%= IIf(strCheckHappy <> "",lngHappy_Ticket, "") %>" ONBLUR="javascript:CalcChange()" ></td>
-->
                        <td><input type="text" name="happy_ticket" size="10" maxlength="8" value="<%= IIf(lngHappy_Ticket <> "0",lngHappy_Ticket, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()" ></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkCard" value="3" <%= IIf(strCheckCard <> "", " CHECKED", "") %>  ONCLICK="javascript:checkCardAct()" border="0">�J�[�h</td>
            <td>�F</td>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>�ԋ�</TD>
<!--
                        <td><input type="text" name="card" size="10" maxlength="8" value="<%= IIf(strCheckCard <> "", lngCard, "") %>" ONBLUR="javascript:CalcChange()" ></td>
-->
                        <td><input type="text" name="card" size="10" maxlength="8" value="<%= IIf(lngCard <> "0", lngCard, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()" ></td>
                        <TD NOWRAP>�J�[�h���</TD>
<%
                        '�J�[�h���̓ǂݍ���
                        '#### 2008/08/13 �� ����ݒ�ɂ���Ċ���ʂ̃��X�g�擾���o����悤�ɕύX ####
                        'If objFree.SelectFree( 1, "CARD" , strArrCardKind, , , strArrCardName) > 0 Then
                        If objFree.SelectFreeDate( 3, "CARD" ,iif(strCslDate<>"",strCslDate,strDmdDate) , strArrCardKind, , , strArrCardName) > 0 Then
%>
                        <TD>
                        <%= EditDropDownListFromArray("cardkind", strArrCardKind, strArrCardName, strCardKind, NON_SELECTED_ADD) %>
                        </TD>
<%
                        End If
%>
                        <td width="10"></td>
                        <TD NOWRAP>�`�[NO.</TD>
<!--
                        <td><input type="text" name="creditslipno" value="<%= IIf(strCheckCard <> "", lngCreditslipno, "") %>" size="7" maxlength="5" ></td>
-->
                        <td><input type="text" name="creditslipno" value="<%= IIf(lngCreditslipno <> "0", lngCreditslipno, "") %>" size="7" maxlength="5" ></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkJdebit" value="4" <%= IIf(strCheckJdebit <> "", " CHECKED", "") %>  ONCLICK="javascript:checkJdebitAct()" border="0">�i�f�r�b�g</td>
            <td>�F</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>�ԋ�</td>
<!--
                        <td><input type="text" name="jdebit" size="10" maxlength="8" value="<%= IIf(strCheckJdebit <> "", lngJdebit, "") %>" ONBLUR="javascript:CalcChange()"></td>
-->
                        <td><input type="text" name="jdebit" size="10" maxlength="8" value="<%= IIf(lngJdebit <> "0", lngJdebit, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()"></td>
<%
                        '��s���̓ǂݍ���
                        If objFree.SelectFree( 1, "BANK" , strArrBankCode, , , strArrBankName) > 0 Then
%>
                        <TD>
                        <%= EditDropDownListFromArray("bankcode", strArrBankCode, strArrBankName, strBankCode, NON_SELECTED_ADD) %>
                        </TD>
<%
                        End If
%>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkCheque" value="5" <%= IIf(strCheckCheque <> "", " CHECKED", "") %>  ONCLICK="javascript:checkChequeAct()" border="0">���؎�</td>
            <td>�F</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>�ԋ�</td>
                        <td><input type="text" name="cheque" size="10" maxlength="8" value="<%= IIf(lngCheque <> "0", lngCheque, "" ) %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()"></td>
                    </tr>
                </table>
            </td>
        </tr>
<!-- �U���݁@�ǉ� 2003.12.25 -->
        <tr>
            <td width="114"><input type="checkbox" name="checkTransfer" value="6" <%= IIf(strCheckTransfer <> "", " CHECKED", "") %>  ONCLICK="javascript:checkTransferAct()" border="0">�U����</td>
            <td>�F</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>�ԋ�</td>
                        <td><input type="text" name="transfer" size="10" maxlength="8" value="<%= IIf(lngTransfer <> "0", lngTransfer, "" ) %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()"></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
<%
            If lngChangePrice >= 0 Then
                If lngChangePrice = 0 Then
%>
                    <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice" >�ԋ��z�ɒB���܂���</SPAN></FONT></B></TD>
<%
                Else
%>
                    <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice" ><%= FormatCurrency(lngChangePrice) %>�@���߂��Ă��܂�</SPAN></FONT></B></TD>
<%
                End If
            Else
                '����t�̏ꍇ
                If strWrtOkFlg = "" AND lngDayId = "" Then
%>
                    <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice">�܂��󂯕t���Ă��܂���</SPAN></FONT></B></TD>
<%
                Else
                    '�����@�̏ꍇ
                    If strWrtOkFlg = "" AND strComeDate = "" Then
%>
                        <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice">�܂����@���Ă��܂���</SPAN></FONT></B></TD>
<%
                    Else
%>
                        <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice">�ԋ��z�ɒB���Ă��܂���</SPAN></FONT></B></TD>
<%
                    End If
                End If
            End If
%>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD WIDTH="114">�I�y���[�^</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD></TD>
<%
                        '���[�U���ǂݍ���
                        If strUpdUser <> "" Then
                            objHainsUser.SelectHainsUser strUpdUser, strUserName
                        End If
%>
                        <TD><%= strUserName %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD WIDTH="114">�X�V����</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="hidden" NAME="upddate" VALUE="<%= strUpdDate %>"><%= strUpdDate %></TD>	
        </TR>
<!-- '### 2004/11/30 Add by gouda@FSIT �v�����ǉ����� -->
        <TR>
            <TD WIDTH="114">�������ߓ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="hidden" NAME="closedate" VALUE="<%= strCloseDate %>"><%= strCloseDate %></TD>	
        </TR>
<!-- '### 2004/11/30 End -->
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
        <!-- �C���� -->
<%
            '���ԋ��̂Ƃ��폜�{�^���s�v
            '�̎�������ς̂Ƃ����s�v
            If strKeyDate = "" Or lngKeySeq = "" Or strPrintDate <> "" Then
%>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="77" HEIGHT="24" border="0"></TD>
<%
            Else
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then 
%>
                <TD><A HREF="javascript:deleteData()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̕ԋ������폜���܂�" border="0"></A></TD>
<%
                End If
            End If
%>
            <TD WIDTH="252"></TD>

            <TD WIDTH="5"></TD>
<%
            '�̎�������ς̂Ƃ��͕ۑ��{�^���s�v
            '����t�A�����@�̏ꍇ���s�v�@2003.12.19
            If strPrintDate <> "" Or strWrtOkFlg = "" Then
%>
                <TD WIDTH="77"></TD>
<%
            Else
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
                <TD><A HREF="javascript:goNextPage()" ONCLICK="return PreserveCheck()"><IMG SRC="/webHains/images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�ŕۑ�"></A></TD>

<%
                End If
            End If
%>
            <TD WIDTH="5"></TD>
            <TD><A HREF="javascript:goBackPage()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
        </TR>
    </TABLE>
    </FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var i;

    // cookie�l�̎擾
    var searchStr = 'regino=';
    var strCookie = document.cookie;
    if ( strCookie.length > 0 ){
        var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
        var regino = strCookie.substring(startPos, startPos + 1);
        if (regino != '' ){
            document.entryForm.registernoval.value = regino;
            var html = '';
            html = html + '<TD>';
            html = html + '<SELECT NAME="registerno" ONCHANGE="javascript:selectRegiNo( document.entryForm.registerno.value )">';

<%
            '�z��Y�������̃��X�g��ǉ�
            If Not IsEmpty(strArrRegisterno) Then
                For i = 0 To UBound(strArrRegisterno)
%>
                    html = html + '<OPTION VALUE="<%= strArrRegisterno(i) %>"'
                    if ( '<%= strArrRegisterno(i) %>' == regino ){
                        html = html + '  SELECTED';
                    }
                    html = html + '> <%= strArrRegisternoName(i) %>';
<%
                Next
            End If
%>

            html = html + '</SELECT>';
            html = html + '</TD>';
            document.getElementById('registerDrop').innerHTML = html;
        }
    }
//-->
</SCRIPT>
</BODY>
</HTML>
