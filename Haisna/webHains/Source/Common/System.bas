Attribute VB_Name = "System"
Option Explicit

'
' �@�\�@�@ : �G���[��񏑂�����
'
' �����@�@ : (In)     strMethodName  �Ăяo�����̃��\�b�h��
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub WriteErrorLog(ByVal strMethodName As String)

    Dim strErrorMsg         As String   '�ҏW�p�G���[���b�Z�[�W

    strErrorMsg = Err.Description

    '�C�x���g���O�������݁i���b�Z�[�W�͔C�ӕҏW�ǉ��j
    App.LogEvent vbCrLf & _
                 "webHains Application Error: " & Err.Source & vbCrLf & _
                 strMethodName & " ���s���װ:'" & Err.Number & "' " & EditAdditionalMessage(strErrorMsg), vbLogEventTypeError

End Sub

' @(e)
'
' �@�\�@�@ : �G���[���b�Z�[�W�ĕҏW
'
' �����@�@ : (In)      strMsg  �G���[���b�Z�[�W�i��{�I�ɂ�Err.Description)
'
' �@�\���� : �G���[���b�Z�[�W�̓��e���琮�����G���[�������o�����ꍇ�A�ēx���b�Z�[�W�ҏW
'
' ���l�@�@ : �}�X�^�����e��MsgBox�p�ɂ��̊֐���Public��
'
Public Function EditAdditionalMessage(ByVal strMsg As String) As String

    Dim strLastMessage  As String
    Dim strTargetTable  As String

    EditAdditionalMessage = strMsg

    '�������G���[�i�q�e�[�u������j�̌��o
    If InStr(strMsg, "ORA-02292") > 0 Then
        strTargetTable = GetErrorTableName(strMsg)
        If strTargetTable = "" Then

            strLastMessage = "���̃f�[�^���g�p���Ă���f�[�^�����݂��܂��B�폜�ł��܂���B" & vbLf & vbLf

        Else

            strLastMessage = GetErrorTableName(strMsg) & "�ł��̃f�[�^���g�p���Ă��邽�ߍ폜�ł��܂���B" & vbLf & vbLf

        End If

        strLastMessage = strLastMessage & strMsg
        strMsg = strLastMessage
    End If

    EditAdditionalMessage = strMsg

End Function


' @(e)
'
' �@�\�@�@ : �G���[�e�[�u�����擾
'
' �����@�@ : (In)      strMsg  �G���[���b�Z�[�W
'
' �@�\���� : �G���[���b�Z�[�W���̃e�[�u����������{��e�[�u�������������Ė߂�
'
' ���l�@�@ : �e�[�u�����̍����͂P������
'
Private Function GetErrorTableName(strMsg As String) As String

    Dim strLastMessage  As String

    GetErrorTableName = ""

'### 2002.03.21 Modified by H.Ishihara@FSIT ������̌������Ԃ���������
    '�e�e�[�u�������猟���i�e�L�X�g�G�f�B�^�̃}�N���@�\���g�����̂ł���Ȋ����j
'    If InStr(strMsg, "PERSON") > 0 Then GetErrorTableName = "�l�e�[�u��": Exit Function
'    If InStr(strMsg, "PERSONDETAIL") > 0 Then GetErrorTableName = "�l�����e�[�u��": Exit Function
'    If InStr(strMsg, "WEB_USERID") > 0 Then GetErrorTableName = "web���[�UID�e�[�u��": Exit Function
'    If InStr(strMsg, "PERRESULT") > 0 Then GetErrorTableName = "�l�������ʃe�[�u��": Exit Function
'    If InStr(strMsg, "DISHISTORY") > 0 Then GetErrorTableName = "�������Ƒ����e�[�u��": Exit Function
'    If InStr(strMsg, "ORG") > 0 Then GetErrorTableName = "�c�̃e�[�u��": Exit Function
'    If InStr(strMsg, "ORGPOST") > 0 Then GetErrorTableName = "�����e�[�u��": Exit Function
'    If InStr(strMsg, "ITEMCLASS") > 0 Then GetErrorTableName = "�������ރe�[�u��": Exit Function
'    If InStr(strMsg, "PROGRESS") > 0 Then GetErrorTableName = "�i���Ǘ��p���ރe�[�u��": Exit Function
'    If InStr(strMsg, "OPECLASS") > 0 Then GetErrorTableName = "�������{�����ރe�[�u��": Exit Function
'    If InStr(strMsg, "ITEM_P") > 0 Then GetErrorTableName = "�˗����ڃe�[�u��": Exit Function
'    If InStr(strMsg, "ITEM_JUD") > 0 Then GetErrorTableName = "�˗����ڔ��蕪�ރe�[�u��": Exit Function
'    If InStr(strMsg, "ITEM_C") > 0 Then GetErrorTableName = "�������ڃe�[�u��": Exit Function
'    If InStr(strMsg, "ITEM_H") > 0 Then GetErrorTableName = "�������ڗ����Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "KARTEITEM") > 0 Then GetErrorTableName = "�������ڕϊ��e�[�u��": Exit Function
'    If InStr(strMsg, "STDVALUE") > 0 Then GetErrorTableName = "��l�e�[�u��": Exit Function
'    If InStr(strMsg, "STDVALUE_C") > 0 Then GetErrorTableName = "��l�ڍ׃e�[�u��": Exit Function
'    If InStr(strMsg, "CALC") > 0 Then GetErrorTableName = "�v�Z�e�[�u��": Exit Function
'    If InStr(strMsg, "CALC_C") > 0 Then GetErrorTableName = "�v�Z���@�e�[�u��": Exit Function
'    If InStr(strMsg, "SENTENCE") > 0 Then GetErrorTableName = "���̓e�[�u��": Exit Function
'    If InStr(strMsg, "RECENT_SENTENCE") > 0 Then GetErrorTableName = "�ŋߎg�������̓e�[�u��": Exit Function
'    If InStr(strMsg, "GRP_P") > 0 Then GetErrorTableName = "�O���[�v�e�[�u��": Exit Function
'    If InStr(strMsg, "GRP_R") > 0 Then GetErrorTableName = "�O���[�v���˗����ڃe�[�u��": Exit Function
'    If InStr(strMsg, "GRP_I") > 0 Then GetErrorTableName = "�O���[�v���������ڃe�[�u��": Exit Function
'    If InStr(strMsg, "COURSE_P") > 0 Then GetErrorTableName = "�R�[�X�e�[�u��": Exit Function
'    If InStr(strMsg, "COURSE_JUD") > 0 Then GetErrorTableName = "�R�[�X���蕪�ރe�[�u��": Exit Function
'    If InStr(strMsg, "COURSE_OPE") > 0 Then GetErrorTableName = "�R�[�X���ڎ��{���e�[�u��": Exit Function
'    If InStr(strMsg, "COURSE_H") > 0 Then GetErrorTableName = "�R�[�X�����Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "COURSE_G") > 0 Then GetErrorTableName = "�R�[�X���O���[�v�e�[�u��": Exit Function
'    If InStr(strMsg, "COURSE_I") > 0 Then GetErrorTableName = "�R�[�X���������ڃe�[�u��": Exit Function
'    If InStr(strMsg, "RSVFRA_P") > 0 Then GetErrorTableName = "�\��g�e�[�u��": Exit Function
'    If InStr(strMsg, "RSVFRA_C") > 0 Then GetErrorTableName = "�\��g���R�[�X�e�[�u��": Exit Function
'    If InStr(strMsg, "RSVFRA_I") > 0 Then GetErrorTableName = "�\��g���������ڃe�[�u��": Exit Function
'    If InStr(strMsg, "SCHEDULE") > 0 Then GetErrorTableName = "�\��X�P�W���[�����O�e�[�u��": Exit Function
'    If InStr(strMsg, "SCHEDULE_H") > 0 Then GetErrorTableName = "�a�@�X�P�W���[�����O�e�[�u��": Exit Function
'    If InStr(strMsg, "ORGRSV") > 0 Then GetErrorTableName = "�c�̗\��l���e�[�u��": Exit Function
'    If InStr(strMsg, "ORGRSV_IFRA") > 0 Then GetErrorTableName = "�c�̗\�񌟍����ژg�e�[�u��": Exit Function
'    If InStr(strMsg, "ORGRSV_M") > 0 Then GetErrorTableName = "�c�̖���e�[�u��": Exit Function
'    If InStr(strMsg, "ORGRSV_D") > 0 Then GetErrorTableName = "�c�̖��떾�׃e�[�u��": Exit Function
'    If InStr(strMsg, "DISEASE") > 0 Then GetErrorTableName = "�a���e�[�u��": Exit Function
'    If InStr(strMsg, "JUDCLASS") > 0 Then GetErrorTableName = "���蕪�ރe�[�u��": Exit Function
'    If InStr(strMsg, "JUD") > 0 Then GetErrorTableName = "����e�[�u��": Exit Function
'    If InStr(strMsg, "STDJUD") > 0 Then GetErrorTableName = "��^�����e�[�u��": Exit Function
'    If InStr(strMsg, "JUDCMTSTC") > 0 Then GetErrorTableName = "����R�����g�e�[�u��": Exit Function
'    If InStr(strMsg, "CONSULT") > 0 Then GetErrorTableName = "��f���e�[�u��": Exit Function
'    If InStr(strMsg, "CONSULT_OPE") > 0 Then GetErrorTableName = "�������{���Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "CONSULT_O") > 0 Then GetErrorTableName = "��f�I�v�V�����Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "CONSULT_G") > 0 Then GetErrorTableName = "��f���ǉ��O���[�v�e�[�u��": Exit Function
'    If InStr(strMsg, "CONSULT_I") > 0 Then GetErrorTableName = "��f���ǉ��������ڃe�[�u��": Exit Function
'    If InStr(strMsg, "RECEIPT") > 0 Then GetErrorTableName = "��t���e�[�u��": Exit Function
'    If InStr(strMsg, "RSL") > 0 Then GetErrorTableName = "�������ʃe�[�u��": Exit Function
'    If InStr(strMsg, "RSLCMT") > 0 Then GetErrorTableName = "���ʃR�����g�e�[�u��": Exit Function
'    If InStr(strMsg, "JUDRSL") > 0 Then GetErrorTableName = "���茋�ʃe�[�u��": Exit Function
'    If InStr(strMsg, "JUDRSL_C") > 0 Then GetErrorTableName = "���菊���e�[�u��": Exit Function
'    If InStr(strMsg, "OPTPRICE") > 0 Then GetErrorTableName = "�ǉ��I�v�V�������S���e�[�u��": Exit Function
'    If InStr(strMsg, "GRPPRICE") > 0 Then GetErrorTableName = "�ǉ��O���[�v���S���e�[�u��": Exit Function
'    If InStr(strMsg, "ITEMPRICE") > 0 Then GetErrorTableName = "�ǉ��������ڕ��S���e�[�u��": Exit Function
'    If InStr(strMsg, "CLOSEMNG") > 0 Then GetErrorTableName = "���ߊǗ��e�[�u��": Exit Function
'    If InStr(strMsg, "CTRMNG") > 0 Then GetErrorTableName = "�_��Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "CTRPT") > 0 Then GetErrorTableName = "�_��p�^�[���e�[�u��": Exit Function
'    If InStr(strMsg, "CTRPT_ORG") > 0 Then GetErrorTableName = "�_��p�^�[�����S���Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "CTRPT_OPT") > 0 Then GetErrorTableName = "�_��p�^�[���I�v�V�����Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "CTRPT_GRP") > 0 Then GetErrorTableName = "�_��p�^�[�����O���[�v�e�[�u��": Exit Function
'    If InStr(strMsg, "CTRPT_ITEM") > 0 Then GetErrorTableName = "�_��p�^�[�����������ڃe�[�u��": Exit Function
'    If InStr(strMsg, "CTRPT_PRICE") > 0 Then GetErrorTableName = "�_��p�^�[�����S���z�Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "BILL") > 0 Then GetErrorTableName = "�������e�[�u��": Exit Function
'    If InStr(strMsg, "BILL_ORG") > 0 Then GetErrorTableName = "�������c�̊Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "BILLDETAIL") > 0 Then GetErrorTableName = "�������׃e�[�u��": Exit Function
'    If InStr(strMsg, "PAYMENT") > 0 Then GetErrorTableName = "�����e�[�u��": Exit Function
'    If InStr(strMsg, "BBS") > 0 Then GetErrorTableName = "�f���e�[�u��": Exit Function
'    If InStr(strMsg, "HAINSUSER") > 0 Then GetErrorTableName = "���[�U�e�[�u��": Exit Function
'    If InStr(strMsg, "ZIP") > 0 Then GetErrorTableName = "�X�֔ԍ��e�[�u��": Exit Function
'    If InStr(strMsg, "PREF") > 0 Then GetErrorTableName = "�s���{���e�[�u��": Exit Function
'    If InStr(strMsg, "WEB_CS") > 0 Then GetErrorTableName = "web�R�[�X�e�[�u��": Exit Function
'    If InStr(strMsg, "WEB_CSDETAIL") > 0 Then GetErrorTableName = "web�R�[�X�ڍ׃e�[�u��": Exit Function
'    If InStr(strMsg, "WEB_OPT") > 0 Then GetErrorTableName = "web�I�v�V���������e�[�u��": Exit Function
'    If InStr(strMsg, "HPTINFO") > 0 Then GetErrorTableName = "�w���X�|�C���g���e�[�u��": Exit Function
'    If InStr(strMsg, "HPTJUD") > 0 Then GetErrorTableName = "�w���X�|�C���g����e�[�u���e�[�u��": Exit Function
'    If InStr(strMsg, "FREE") > 0 Then GetErrorTableName = "�ėp�e�[�u��": Exit Function
'    If InStr(strMsg, "REPORT") > 0 Then GetErrorTableName = "���[�Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "REPORTLOG") > 0 Then GetErrorTableName = "������O�e�[�u��": Exit Function
'    If InStr(strMsg, "WORKSTATION") > 0 Then GetErrorTableName = "�[���Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "ORDEREDDOC") > 0 Then GetErrorTableName = "���M�I�[�_�������e�[�u��": Exit Function
'    If InStr(strMsg, "ORDEREDITEM") > 0 Then GetErrorTableName = "���M�I�[�_���ڏ��e�[�u��": Exit Function
'    If InStr(strMsg, "ORDERJNL") > 0 Then GetErrorTableName = "�I�[�_���M�W���[�i���e�[�u��": Exit Function
'    If InStr(strMsg, "ORDERREPORT") > 0 Then GetErrorTableName = "���|�[�g���e�[�u��": Exit Function
'
''### 2002.04.12 Added by H.Ishihara@FSIT �����^���w���X�n�e�[�u���ǉ�
'    If InStr(strMsg, "MENTALHEALTH") > 0 Then GetErrorTableName = "�����^���w���X���Ǘ��e�[�u��": Exit Function
'    If InStr(strMsg, "MHCOMMNET") > 0 Then GetErrorTableName = "�����^���w���X�R�����g���Ǘ��e�[�u��": Exit Function
''### 2002.04.12 Added End
    If InStr(strMsg, "ZIP") > 0 Then GetErrorTableName = "�X�֔ԍ��e�[�u��": Exit Function
    If InStr(strMsg, "ZAIMU_JNL") > 0 Then GetErrorTableName = "�����A�g�W���[�i���e�[�u��": Exit Function
    If InStr(strMsg, "ZAIMU") > 0 Then GetErrorTableName = "�����K�p�e�[�u��": Exit Function
    If InStr(strMsg, "WORKSTATION") > 0 Then GetErrorTableName = "�[���Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "WEB_USERID") > 0 Then GetErrorTableName = "web���[�UID�e�[�u��": Exit Function
    If InStr(strMsg, "WEB_OPT") > 0 Then GetErrorTableName = "web�I�v�V���������e�[�u��": Exit Function
    If InStr(strMsg, "WEB_CSDETAIL") > 0 Then GetErrorTableName = "web�R�[�X�ڍ׃e�[�u��": Exit Function
    If InStr(strMsg, "WEB_CS") > 0 Then GetErrorTableName = "web�R�[�X�e�[�u��": Exit Function
    If InStr(strMsg, "TESTTUBEMNG") > 0 Then GetErrorTableName = "���̔ԍ��Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "STDVALUE_C") > 0 Then GetErrorTableName = "��l�ڍ׃e�[�u��": Exit Function
    If InStr(strMsg, "STDVALUE") > 0 Then GetErrorTableName = "��l�e�[�u��": Exit Function
    If InStr(strMsg, "STDJUD") > 0 Then GetErrorTableName = "��^�����e�[�u��": Exit Function
    If InStr(strMsg, "STDCONTACTSTC") > 0 Then GetErrorTableName = "��^�ʐڕ��̓e�[�u��": Exit Function
    If InStr(strMsg, "STCCLASS") > 0 Then GetErrorTableName = "���͕��ރe�[�u��": Exit Function
    If InStr(strMsg, "SENTENCE") > 0 Then GetErrorTableName = "���̓e�[�u��": Exit Function
    If InStr(strMsg, "SCHEDULE_H") > 0 Then GetErrorTableName = "�a�@�X�P�W���[�����O�e�[�u��": Exit Function
    If InStr(strMsg, "SCHEDULE") > 0 Then GetErrorTableName = "�\��X�P�W���[�����O�e�[�u��": Exit Function
    If InStr(strMsg, "RSVFRA_P") > 0 Then GetErrorTableName = "�\��g�e�[�u��": Exit Function
    If InStr(strMsg, "RSVFRA_I") > 0 Then GetErrorTableName = "�\��g���������ڃe�[�u��": Exit Function
    If InStr(strMsg, "RSVFRA_C") > 0 Then GetErrorTableName = "�\��g���R�[�X�e�[�u��": Exit Function
    If InStr(strMsg, "RSLENTRYLOG") > 0 Then GetErrorTableName = "�������ʓ��̓��O�e�[�u��": Exit Function
    If InStr(strMsg, "RSLCMT") > 0 Then GetErrorTableName = "���ʃR�����g�e�[�u��": Exit Function
    If InStr(strMsg, "RSL") > 0 Then GetErrorTableName = "�������ʃe�[�u��": Exit Function
    If InStr(strMsg, "ROUNDCLASSPRICE") > 0 Then GetErrorTableName = "�܂�ߕ��ދ��z�Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "ROUNDCLASS") > 0 Then GetErrorTableName = "�܂�ߕ��ރe�[�u��": Exit Function
    If InStr(strMsg, "REPORTLOG") > 0 Then GetErrorTableName = "������O�e�[�u��": Exit Function
    If InStr(strMsg, "REPORT") > 0 Then GetErrorTableName = "���[�Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "RELATION") > 0 Then GetErrorTableName = "�����e�[�u��": Exit Function
    If InStr(strMsg, "RECENT_SENTENCE") > 0 Then GetErrorTableName = "�ŋߎg�������̓e�[�u��": Exit Function
    If InStr(strMsg, "RECEIPT") > 0 Then GetErrorTableName = "��t���e�[�u��": Exit Function
    If InStr(strMsg, "PROGRESS") > 0 Then GetErrorTableName = "�i���Ǘ��p���ރe�[�u��": Exit Function
    If InStr(strMsg, "PREF") > 0 Then GetErrorTableName = "�s���{���e�[�u��": Exit Function
    If InStr(strMsg, "PERWORKINFO") > 0 Then GetErrorTableName = "�l�A�J���e�[�u��": Exit Function
    If InStr(strMsg, "PERSONDETAIL") > 0 Then GetErrorTableName = "�l�����e�[�u��": Exit Function
    If InStr(strMsg, "PERSON") > 0 Then GetErrorTableName = "�l�e�[�u��": Exit Function
    If InStr(strMsg, "PERRESULT") > 0 Then GetErrorTableName = "�l�������ʃe�[�u��": Exit Function
    If InStr(strMsg, "PERDISEASE") > 0 Then GetErrorTableName = "���a�x�Ə��e�[�u��": Exit Function
    If InStr(strMsg, "PAYMENT") > 0 Then GetErrorTableName = "�����e�[�u��": Exit Function
    If InStr(strMsg, "PASSEDINFO") > 0 Then GetErrorTableName = "�[���ʉߏ��e�[�u��": Exit Function
    If InStr(strMsg, "ORGWKPOST") > 0 Then GetErrorTableName = "�J������e�[�u��": Exit Function
    If InStr(strMsg, "ORGRSV_M") > 0 Then GetErrorTableName = "�c�̖���e�[�u��": Exit Function
    If InStr(strMsg, "ORGRSV_IFRA") > 0 Then GetErrorTableName = "�c�̗\�񌟍����ژg�e�[�u��": Exit Function
    If InStr(strMsg, "ORGRSV_D") > 0 Then GetErrorTableName = "�c�̖��떾�׃e�[�u��": Exit Function
    If InStr(strMsg, "ORGRSV") > 0 Then GetErrorTableName = "�c�̗\��l���e�[�u��": Exit Function
    If InStr(strMsg, "ORGROOM") > 0 Then GetErrorTableName = "�����e�[�u��": Exit Function
    If InStr(strMsg, "ORGPOST") > 0 Then GetErrorTableName = "�����e�[�u��": Exit Function
    If InStr(strMsg, "ORGBSD") > 0 Then GetErrorTableName = "���ƕ��e�[�u��": Exit Function
    If InStr(strMsg, "ORGBILLCLASS") > 0 Then GetErrorTableName = "�c�̊Ǘ����������ރe�[�u��": Exit Function
    If InStr(strMsg, "ORG") > 0 Then GetErrorTableName = "�c�̃e�[�u��": Exit Function
    If InStr(strMsg, "ORDERREPORT") > 0 Then GetErrorTableName = "���|�[�g���e�[�u��": Exit Function
    If InStr(strMsg, "ORDERJNL") > 0 Then GetErrorTableName = "�I�[�_���M�W���[�i���e�[�u��": Exit Function
    If InStr(strMsg, "ORDEREDITEM") > 0 Then GetErrorTableName = "���M�I�[�_���ڏ��e�[�u��": Exit Function
    If InStr(strMsg, "ORDEREDDOC") > 0 Then GetErrorTableName = "���M�I�[�_�������e�[�u��": Exit Function
    If InStr(strMsg, "OPTPRICE") > 0 Then GetErrorTableName = "�ǉ��I�v�V�������S���e�[�u��": Exit Function
    If InStr(strMsg, "OPECLASS") > 0 Then GetErrorTableName = "�������{�����ރe�[�u��": Exit Function
    If InStr(strMsg, "NOCTR_ITEMS_TEMP") > 0 Then GetErrorTableName = "�_��O���ڗ����o�͗p�ꎞ�e�[�u��": Exit Function
    If InStr(strMsg, "MONEY_DETAILS_TEMP") > 0 Then GetErrorTableName = "�l�����v�Z�p�ꎞ�e�[�u��": Exit Function
    If InStr(strMsg, "MONEY_CLOSE_TEMP") > 0 Then GetErrorTableName = "���ߏ�����ƈꎞ�e�[�u��": Exit Function
    If InStr(strMsg, "KARTEITEM") > 0 Then GetErrorTableName = "�������ڕϊ��e�[�u��": Exit Function
    If InStr(strMsg, "JUDRSL_C") > 0 Then GetErrorTableName = "���菊���e�[�u��": Exit Function
    If InStr(strMsg, "JUDRSL") > 0 Then GetErrorTableName = "���茋�ʃe�[�u��": Exit Function
    If InStr(strMsg, "JUDCMTSTC") > 0 Then GetErrorTableName = "����R�����g�e�[�u��": Exit Function
    If InStr(strMsg, "JUDCLASS") > 0 Then GetErrorTableName = "���蕪�ރe�[�u��": Exit Function
    If InStr(strMsg, "JUD") > 0 Then GetErrorTableName = "����e�[�u��": Exit Function
    If InStr(strMsg, "ITEMPRICE") > 0 Then GetErrorTableName = "�ǉ��������ڕ��S���e�[�u��": Exit Function
    If InStr(strMsg, "ITEMCLASS") > 0 Then GetErrorTableName = "�������ރe�[�u��": Exit Function
    If InStr(strMsg, "ITEM_P_PRICE") > 0 Then GetErrorTableName = "�˗����ڒP���e�[�u��": Exit Function
    If InStr(strMsg, "ITEM_P") > 0 Then GetErrorTableName = "�˗����ڃe�[�u��": Exit Function
    If InStr(strMsg, "ITEM_JUD") > 0 Then GetErrorTableName = "�˗����ڔ��蕪�ރe�[�u��": Exit Function
    If InStr(strMsg, "ITEM_H") > 0 Then GetErrorTableName = "�������ڗ����Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "ITEM_C") > 0 Then GetErrorTableName = "�������ڃe�[�u��": Exit Function
    If InStr(strMsg, "HPTJUD") > 0 Then GetErrorTableName = "�w���X�|�C���g����e�[�u��": Exit Function
    If InStr(strMsg, "HPTINFO") > 0 Then GetErrorTableName = "�w���X�|�C���g���e�[�u��": Exit Function
    If InStr(strMsg, "HAINSUSER") > 0 Then GetErrorTableName = "���[�U�e�[�u��": Exit Function
    If InStr(strMsg, "HAINSLOG") > 0 Then GetErrorTableName = "���O�e�[�u��": Exit Function
    If InStr(strMsg, "GUIDANCE") > 0 Then GetErrorTableName = "�w�����e�e�[�u��": Exit Function
    If InStr(strMsg, "GRPPRICE") > 0 Then GetErrorTableName = "�ǉ��O���[�v���S���e�[�u��": Exit Function
    If InStr(strMsg, "GRP_R") > 0 Then GetErrorTableName = "�O���[�v���˗����ڃe�[�u��": Exit Function
    If InStr(strMsg, "GRP_P") > 0 Then GetErrorTableName = "�O���[�v�e�[�u��": Exit Function
    If InStr(strMsg, "GRP_I") > 0 Then GetErrorTableName = "�O���[�v���������ڃe�[�u��": Exit Function
    If InStr(strMsg, "FREE") > 0 Then GetErrorTableName = "�ėp�e�[�u��": Exit Function
    If InStr(strMsg, "FILMMNG") > 0 Then GetErrorTableName = "�t�B�����ԍ��Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "FILMMNG") > 0 Then GetErrorTableName = "�t�B�����ԍ��Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "DMDLINECLASS") > 0 Then GetErrorTableName = "�������ו��ރe�[�u��": Exit Function
    If InStr(strMsg, "DISHISTORY") > 0 Then GetErrorTableName = "�������Ƒ����e�[�u��": Exit Function
    If InStr(strMsg, "DISEASE") > 0 Then GetErrorTableName = "�a���e�[�u��": Exit Function
    If InStr(strMsg, "DISDIV") > 0 Then GetErrorTableName = "�a�ރe�[�u��": Exit Function
    If InStr(strMsg, "CTRPT_PRICE") > 0 Then GetErrorTableName = "�_��p�^�[�����S���z�Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "CTRPT_ORG") > 0 Then GetErrorTableName = "�_��p�^�[�����S���Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "CTRPT_OPTAGE") > 0 Then GetErrorTableName = "�_��p�^�[���I�v�V�����N������e�[�u��": Exit Function
    If InStr(strMsg, "CTRPT_OPT") > 0 Then GetErrorTableName = "�_��p�^�[���I�v�V�����Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "CTRPT_ITEM") > 0 Then GetErrorTableName = "�_��p�^�[�����������ڃe�[�u��": Exit Function
    If InStr(strMsg, "CTRPT_GRP") > 0 Then GetErrorTableName = "�_��p�^�[�����O���[�v�e�[�u��": Exit Function
    If InStr(strMsg, "CTRPT_AGE") > 0 Then GetErrorTableName = "�_��p�^�[���N��敪�e�[�u��": Exit Function
    If InStr(strMsg, "CTRPT") > 0 Then GetErrorTableName = "�_��p�^�[���e�[�u��": Exit Function
    If InStr(strMsg, "CTRMNG") > 0 Then GetErrorTableName = "�_��Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "COURSE_P") > 0 Then GetErrorTableName = "�R�[�X�e�[�u��": Exit Function
    If InStr(strMsg, "COURSE_OPE") > 0 Then GetErrorTableName = "�R�[�X���ڎ��{���e�[�u��": Exit Function
    If InStr(strMsg, "COURSE_JUD") > 0 Then GetErrorTableName = "�R�[�X���蕪�ރe�[�u��": Exit Function
    If InStr(strMsg, "COURSE_I") > 0 Then GetErrorTableName = "�R�[�X���������ڃe�[�u��": Exit Function
    If InStr(strMsg, "COURSE_H") > 0 Then GetErrorTableName = "�R�[�X�����Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "COURSE_G") > 0 Then GetErrorTableName = "�R�[�X���O���[�v�e�[�u��": Exit Function
    If InStr(strMsg, "CONSULT_ZAIMU") > 0 Then GetErrorTableName = "�����A�g�e�[�u��": Exit Function
    If InStr(strMsg, "CONSULT_OPE") > 0 Then GetErrorTableName = "�������{���Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "CONSULT_O") > 0 Then GetErrorTableName = "��f�I�v�V�����Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "CONSULT_M") > 0 Then GetErrorTableName = "��f���z�m��e�[�u��": Exit Function
    If InStr(strMsg, "CONSULT_I") > 0 Then GetErrorTableName = "��f���ǉ��������ڃe�[�u��": Exit Function
    If InStr(strMsg, "CONSULT_G") > 0 Then GetErrorTableName = "��f���ǉ��O���[�v�e�[�u��": Exit Function
    If InStr(strMsg, "CONSULT") > 0 Then GetErrorTableName = "��f���e�[�u��": Exit Function
    If InStr(strMsg, "CLOSEMNG") > 0 Then GetErrorTableName = "���ߊǗ��e�[�u��": Exit Function
    If InStr(strMsg, "CALC_C") > 0 Then GetErrorTableName = "�v�Z���@�e�[�u��": Exit Function
    If InStr(strMsg, "CALC") > 0 Then GetErrorTableName = "�v�Z�e�[�u��": Exit Function
    If InStr(strMsg, "BILLDETAIL") > 0 Then GetErrorTableName = "�������׃e�[�u��": Exit Function
    If InStr(strMsg, "BILLCLASS_C") > 0 Then GetErrorTableName = "���������ފǗ��R�[�X�e�[�u��": Exit Function
    If InStr(strMsg, "BILLCLASS") > 0 Then GetErrorTableName = "���������ރe�[�u��": Exit Function
    If InStr(strMsg, "BILL_ORG") > 0 Then GetErrorTableName = "�������c�̊Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "BILL_COURSE") > 0 Then GetErrorTableName = "�������c�̕ʃR�[�X�Ǘ��e�[�u��": Exit Function
    If InStr(strMsg, "BILL") > 0 Then GetErrorTableName = "�������e�[�u��": Exit Function
    If InStr(strMsg, "BBS") > 0 Then GetErrorTableName = "�f���e�[�u��": Exit Function
    If InStr(strMsg, "AFTERCARE_M") > 0 Then GetErrorTableName = "�A�t�^�[�P�A�Ǘ����ڃe�[�u��": Exit Function
    If InStr(strMsg, "AFTERCARE_CLOSE") > 0 Then GetErrorTableName = "�A�t�^�[�P�A���ߊǗ��e�[�u��": Exit Function
    If InStr(strMsg, "AFTERCARE_C") > 0 Then GetErrorTableName = "�A�t�^�[�P�A�ʐڕ��̓e�[�u��": Exit Function
    If InStr(strMsg, "AFTERCARE") > 0 Then GetErrorTableName = "�A�t�^�[�P�A�e�[�u��": Exit Function
'### 2002.03.21 Modified End

End Function

'## 2003.02.06 Add Function By T.Takagi@FSIT SGA�Q��΍�
'
' �@�\�@�@ : �����̕����񂩂���s�A�Q���ȏ�̋󔒂���������
'
' �����@�@ : (In)     Base  ���ɂȂ镶����
'
' �߂�l�@ : ������  ����OK
'            ""      ����NG
'
' ���l�@�@ : �{�֐���SQL������ Chr(13)�A�󔒂��ꊇ���Ď�菜���ꍇ���Ɏg�p
'
Public Function OmitCharSpc(Base As String) As String

'### 2003/05/23 Updated by Ishihara@FSIT �������OSQL������ƃI�[�o�[�t���[
'    Dim i       As Integer  '�����񑀍쎞�̌��݂��߼޼��ݸ�
'    Dim j       As Integer  '����������̔����ʒu
    Dim i       As Long     '�����񑀍쎞�̌��݂��߼޼��ݸ�
    Dim j       As Long     '����������̔����ʒu
'### 2003/05/23 Updated End

    Dim Ret     As Variant
    Dim Answer  As String

    Dim work As String

    work = vbLf
    OmitCharSpc = ""

'    '' chr(13) ���s����
'    i = 1
'    Answer = ""
'    Do
'        Ret = InStr(i, Base, work)
'        '' �߂�l��Null�̏ꍇ
'        If Ret = Null Then
'            MsgBox "����������������܂���"
'
'            Exit Function
'        Else
'            j = CInt(Ret)
'            If j = 0 Then
'                '' ���������񂪂Ȃ��ꍇ
'                Answer = Answer & Mid(Base, i, Len(Base) - i + 1)
'                i = Len(Base) + 1
'            Else
'                '' ����������𔭌������ꍇ
'                Answer = Answer & Mid(Base, i, j - i)
'                i = j + 1
'            End If
'        End If
'
'        '' �߼޼��ݸނ��ϊ������������傫���Ȃ�� Exit Do
'        If i > Len(Base) Then Exit Do
'    Loop
    Answer = Replace(Base, vbLf, " ")

    '' 2���ȏ�̋󔒏���
    i = 1
    Base = Trim(Answer)
    Answer = ""
    Do
        Ret = InStr(i, Base, Space(1))
        '' �߂�l��Null�̏ꍇ
        If Ret = Null Then
'### 2003/05/23 Updated by Ishihara@FSIT ����͂����܂���
'            MsgBox "����������������܂���"
            App.LogEvent vbCrLf & _
                         "webHains Application Error: " & "OmitCharSpc" & vbCrLf & _
                         "SQL�����Z�b�g����Ă��܂���B", vbLogEventTypeError
'### 2003/05/23 Updated End

            Exit Function
        Else
'### 2003/05/23 Updated by Ishihara@FSIT �������OSQL������ƃI�[�o�[�t���[
'            j = CInt(Ret)
            j = CLng(Ret)
'### 2003/05/23 Updated End
            If j = 0 Then
                '' ���������񂪂Ȃ��ꍇ
                Answer = Answer & Mid(Base, i, Len(Base) - i + 1)
                i = Len(Base) + 1
            Else
                '' ����������𔭌������ꍇ
                Answer = Answer & Mid(Base, i, j - i) & Space(1)
                i = j + 1
                '' �����󔒕����̏ꍇ�A�󔒈ȊO�܂ŃV�t�g
                Do
                    If Mid(Base, i, 1) = Space(1) Then
                        i = i + 1
                    Else
                        Exit Do
                    End If
                Loop
            End If
        End If

        '' �߼޼��ݸނ��ϊ������������傫���Ȃ�� Exit Do
        If i > Len(Base) Then Exit Do
    Loop

    OmitCharSpc = Answer

End Function
