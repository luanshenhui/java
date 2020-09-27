Attribute VB_Name = "Cooperation"
Option Explicit

Public Const MODE_INSERT        As String = "I" '�������[�h(�}��)
Public Const MODE_UPDATE        As String = "U" '�������[�h(�X�V)

Public Const RELATIONCD_SELF    As String = "0" '�{�l�p�����R�[�h
Public Const BRANCHNO_SELF      As Long = 0     '�{�l�p�}��

'�l��񃌃R�[�h
Public Type PERSON_INF
    DelFlg      As Long     '�폜�t���O
    TransferDiv As Long     '�o���敪
    LastName    As String   '��
    FirstName   As String   '��
    LastKName   As String   '�J�i��
    FirstKName  As String   '�J�i��
    Birth       As Date     '���N����
    Gender      As Long     '����
    OrgBsdCd    As String   '���ƕ��R�[�h
    OrgBsdName  As String   '���ƕ�����
    OrgRoomCd   As String   '�����R�[�h
    OrgRoomName As String   '��������
    OrgPostCd   As String   '�����R�[�h
    OrgPostName As String   '��������
    JobCd       As String   '�E���R�[�h
    JobName     As String   '�E��
    DutyCd      As String   '�E�ӃR�[�h
    DutyName    As String   '�E�Ӗ���
    QualifyCd   As String   '���i�R�[�h
    QualifyName As String   '���i����
    IsrSign     As String   '���ۋL��
    IsrNo       As String   '���۔ԍ�
    RelationCd  As String   '�����R�[�h
    BranchNo    As Long     '�}��
    EmpNo       As String   '�]�ƈ��ԍ�
    HireDate    As Date     '���ДN����
    EmpDiv      As String   '�]�ƈ��敪
'## 2003.01.29 Add 1Line By T.Takagi@FSIT �]�ƈ��敪���̑Ή�
    EmpName     As String   '�]�ƈ��敪����
'## 2003.01.29 Add End
    HongenDiv   As String   '�{���敪
    Tel1        As String   '�d�b�ԍ��P
    Tel2        As String   '�d�b�ԍ��Q
    Tel3        As String   '�d�b�ԍ��R
    ZipCd1      As String   '�X�֔ԍ��P
    ZipCd2      As String   '�X�֔ԍ��Q
    Address1    As String   '�Z���P
    Address2    As String   '�Z���Q
'## 2003.02.07 Add 1Line By T.Takagi@FSIT ��f��]���Ή�
    CslDate     As Date     '��f��]��
'## 2003.02.07 Add End
End Type

'�L�[���
Public Type KEY_REC
    CslDate     As String * 8   '��f��
    Seq         As String * 5   '���f�ʔ�
    Space1      As String * 7   '��
End Type

'�팯�҃��R�[�h
Public Type REQUEST_REC
    RecDiv      As String * 2   '���R�[�h�敪
    CenterDiv   As String * 6   '�Z���^�[�敪
    ReqKey      As KEY_REC      '�˗��҃L�[���
    ReqCd       As String * 4   '�˗����R�[�h
    Space1      As String * 11  '��
    CsDiv       As String * 1   '���f���
    Space2      As String * 14  '��
    EnterDiv    As String * 1   '���@�E�O���敪
    DoctorCd    As String * 4   '�h�N�^�[�R�[�h
    Space3      As String * 6   '��
    Id          As String * 15  '�팟�҂h�c
    PatientNo   As String * 10  '���Ҕԍ�
    Space4      As String * 5   '��
    KanaName    As String * 20  '�팟�Җ�
    Gender      As String * 1   '����
    AgeDiv      As String * 1   '�N��敪
    Age         As String * 3   '�N��
    BirthDiv    As String * 1   '���N�����敪
    Birth       As String * 6   '���N����
    TakeDate    As String * 6   '�̎��
    TakeTime    As String * 4   '�̎掞��
    ItemCount   As String * 3   '���ڐ�
    Height      As String * 4   '�g��
    Weight      As String * 4   '�̏d
    Urine       As String * 4   '�A��
    UrineUnit   As String * 2   '�A�ʒP��
    Conception  As String * 2   '�D�P�T��
    Dislysis    As String * 1   '���͑O��
    Rapid       As String * 1   '���}��
    Comment     As String * 20  '�˗��R�����g���e
    Name        As String * 8   '��������
    TestTubeNo  As String * 4   '���̔ԍ�
    Space5      As String * 54  '��
End Type

'�������ڃ��R�[�h(�w�b�_��)
Public Type ITEM_HEADER
    RecDiv      As String * 2   '���R�[�h�敪
    CenterDiv   As String * 6   '�Z���^�[�敪
    CslDate     As String * 8   '��f��
    Seq         As String * 6   '���f�ʔ�
    Space1      As String * 6   '��
End Type

'�������ڃ��R�[�h(�������ڕ�)
Public Type ITEM_REC
    ItemCd      As String * 5   '�������ڃR�[�h(���͕��R�[�h)
    DisCd       As String * 4   '���ʃR�[�h
    MtrCd       As String * 3   '�ޗ��R�[�h
    MesCd       As String * 3   '����@�R�[�h
    LoadTime    As String * 10  '���׎���
End Type

'�������ʃ��R�[�h(�������ʕ�)
Public Type RESULT_REC
    ItemCd      As String * 5   '�������ڃR�[�h(���͕��R�[�h)
    DisCd       As String * 4   '���ʃR�[�h
    MtrCd       As String * 3   '�ޗ��R�[�h
    MesCd       As String * 3   '����@�R�[�h
    Suffix      As String * 2   '���ڃR�[�h�}��
    Result      As String * 8   '��������
    State       As String * 1   '�����l���
    RslCmtCd1   As String * 3   '���ʃR�����g�R�[�h�P
    RslCmtCd2   As String * 3   '���ʃR�����g�R�[�h�Q
End Type

'�������ʃ��R�[�h
Public Type RESPONSE_REC
    RecDiv      As String * 2   '���R�[�h�敪
    CenterDiv   As String * 6   '�Z���^�[�敪
    ReqKey      As KEY_REC      '�˗��҃L�[���
    CslKey      As KEY_REC      '��f�҃L�[���
    KanaName    As String * 20  '�팯�Җ�
    RepCd       As String * 1   '�񍐏󋵃R�[�h
    Nyubi       As String * 3   '����
    Yoketsu     As String * 3   '�n��
    Bil         As String * 3   '�r�����r��
    Results(4)  As RESULT_REC   '��������
    PatientNo   As String * 10  '���Ҕԍ�
    CsDiv       As String * 1   '���f���
    Space1      As String * 7   '��
End Type

'�\���́���������ϊ��̂��߂̍\����
Public Type BUFFER_REC
    Buffer      As String * 256
End Type

'
' �@�\�@�@ : �z��ւ̗v�f�ǉ�
'
' �����@�@ : (In/Out) vntArray1    �z��P
' �@�@�@�@   (In/Out) vntArray2    �z��Q
' �@�@�@�@   (In)     strMessage1  ���b�Z�[�W�P
' �@�@�@�@   (In)     strMessage2  ���b�Z�[�W�Q
'
' ���l�@�@ : �o���A���g�z��̍Ō㕔�ɗv�f��ǉ�����
'
Public Sub AppendMessage(ByRef vntArray1 As Variant, ByRef vntArray2 As Variant, ByVal strMessage1 As String, Optional ByVal strMessage2 As String = "")

    Dim i   As Long '�C���f�b�N�X
    
    '�v�f���Ȃ���Ή������Ȃ�
    If Trim(strMessage1) = "" Then
        Exit Sub
    End If
    
    '�z��łȂ��ꍇ�͐V�K�z����쐬
    If Not IsArray(vntArray1) Then
        vntArray1 = Array(Trim(strMessage1))
        vntArray2 = Array(Trim(strMessage2))
        Exit Sub
    End If
    
    '�z��̍Ō㕔�ɗv�f��ǉ�
    i = UBound(vntArray1) + 1
    ReDim Preserve vntArray1(i)
    ReDim Preserve vntArray2(i)
    vntArray1(i) = Trim(strMessage1)
    vntArray2(i) = Trim(strMessage2)
    
End Sub

'
' �@�\�@�@ : ���t�`�F�b�N
'
' �����@�@ : (In)     strExpression  ������
' �@�@�@�@   (In)     lngMode        �`�F�b�N���[�h(0:�N�����A1:�N��)
'
' �߂�l�@ : True   ���t�Ƃ��ĔF���\
' �@�@�@�@   False  ���t�Ƃ��ĔF���s�\
'
' ���l�@�@ :
'
Public Function CheckDate(ByVal strExpression As String, Optional ByVal lngMode As Long = 0) As Boolean

    Dim vntToken    As Variant  '�g�[�N��
    Dim strYear     As String   '�N
    Dim strMonth    As String   '��
    Dim strDay      As String   '��
    
    Dim Ret As Boolean  '�֐��߂�l
    Dim i   As Long     '�C���f�b�N�X
    
    strExpression = Trim(strExpression)
    If strExpression = "" Then
        Exit Function
    End If
    
    '�X���b�V���ɂ���؂肪���݂���ꍇ
    If InStr(strExpression, "/") > 0 Then
    
        '�X���b�V���ŕ�����𕪊�
        vntToken = Split(strExpression, "/")
        
        '�N�����̏ꍇ�͗v�f���R�ȊO�Ȃ�A�N���̏ꍇ�͂Q�ȊO�Ȃ�΂��ꂼ��G���[
        If UBound(vntToken) <> IIf(lngMode = 0, 2, 1) Then
            Exit Function
        End If
        
        '�N�E���E����ҏW
        strYear = vntToken(0)
        strMonth = vntToken(1)
        If lngMode = 0 Then
            strDay = vntToken(2)
        Else
            strDay = "1"    '�N���̏ꍇ�ɂ������̃`�F�b�N�̂��߂̎b��I���u
        End If
    
        '���p�����`�F�b�N
        If Not CheckNumber(strYear) Then
            Exit Function
        End If
    
        '���p�����`�F�b�N
        If Not CheckNumber(strMonth) Then
            Exit Function
        End If
    
        '���p�����`�F�b�N
        If Not CheckNumber(strDay) Then
            Exit Function
        End If
    
    '��؂肪���݂��Ȃ��ꍇ
    Else
    
        '�N�����̏ꍇ�͂W���ȊO�Ȃ�A�N���̏ꍇ�U���ȊO�Ȃ�΂��ꂼ��̓G���[
        If Len(strExpression) <> IIf(lngMode = 0, 8, 6) Then
            Exit Function
        End If
        
        '���p�����`�F�b�N
        If Not CheckNumber(strExpression) Then
            Exit Function
        End If
        
        '�N�E���E����ҏW
        strYear = Left(strExpression, 4)
        strMonth = Mid(strExpression, 5, 2)
        If lngMode = 0 Then
            strDay = Right(strExpression, 2)
        Else
            strDay = "1"    '�N���̏ꍇ�ɂ������̃`�F�b�N�̂��߂̎b��I���u
        End If
    
    End If
    
    '���t�`�F�b�N���s���A����Ȃ���t�Ƃ݂Ȃ�
    CheckDate = IsDate(strYear & "/" & strMonth & "/" & strDay)
    
End Function

'
' �@�\�@�@ : �J�i�����`�F�b�N
'
' �����@�@ : (In)     strExpression  ������
'
' �߂�l�@ : True   �J�i�����݂̂ō\��
' �@�@�@�@   False  �J�i�����ȊO�̕���������
'
' ���l�@�@ : Common�N���X�̂���Ɠ���Ȃ̂ł����ŏ�������͍̂D�܂����Ȃ���(������System.bas�ŏ������A�o������Ă�)�A
' �@�@�@�@   �C���X�^���X�쐬���̃I�[�o�w�b�h���l�������̂ƁA�S�R���p�C���̉�����l���������ŕ������܂����B
'
Public Function CheckKana(ByVal strExpression As String) As Boolean

    Const KANA_STRING   As String = "�J�K�T�U�@�A�B�C�D�E�F�G�H�I�J�K�L�M�N�O�P�Q�R�S�T�U�V�W�X�Y�Z�[�\�]�^�_�`�a�b�c�d�e�f�g�h�i�j�k�l�m�n�o�p�q�r�s�t�u�v�w�x�y�z�{�|�}�~�����������������������������������������������E�[�R�S�����������������������������������������������������������"

    Dim strToken        As String   '��������

    Dim i               As Long     '�C���f�b�N�X
    Dim strNarrow       As String   '���p�ϊ���̕�����
    
    '���p�ϊ�(�����͔��p�ϊ��ł��Ȃ������𗘗p)
    strNarrow = StrConv(strExpression, vbNarrow)
    
    '�����񎮂̕������P����������
    For i = 1 To Len(strNarrow)
    
        '���������̎擾
        strToken = Mid(strNarrow, i, 1)
    
        '�P�������`�F�b�N
        Do
        
            '�����������󔒂ł���Ή������Ȃ�
            If Trim(strToken) = "" Then
                Exit Do
            End If
            
            '�A�X�L�[�R�[�h���O�`�Q�T�T�Ȃ�ΐ���
            Select Case Asc(strToken)
                Case 0 To 255
                    Exit Do
            End Select
                            
            '�������A��ɒ�`�����J�i������̒��ɑ��݂���ΐ���
            If InStr(KANA_STRING, strToken) > 0 Then
                Exit Do
            End If
    
            '��L�ǂ̏��������������Ȃ��ꍇ�̓G���[
            Exit Function
    
            Exit Do
        Loop
        
    Next i
    
    '�S�Đ���Ɍ����ł����ꍇ�̖߂�l�ݒ�
    CheckKana = True
    
End Function

'
' �@�\�@�@ : �l���݃`�F�b�N
'
' �����@�@ : (In)     strExpression  ������
' �@�@�@�@   (In)     vntValue       ��蓾��l�̏W��
'
' �߂�l�@ : True   �l������
' �@�@�@�@   False  �l�����݂��Ȃ�
'
' ���l�@�@ :
'
Public Function CheckIntoValue(ByVal strExpression As String, ByRef vntValue As Variant) As Boolean

    Dim Ret As Boolean  '�֐��߂�l
    Dim i   As Long     '�C���f�b�N�X

    '�z��̊e�v�f�Ƃ̔�r
    For i = LBound(vntValue) To UBound(vntValue)
        If Trim(strExpression) = Trim(vntValue(i)) Then
            Ret = True
            Exit For
        End If
    Next i
    
    '�߂�l�̐ݒ�
    CheckIntoValue = Ret
    
End Function

'## 2004.10.04 Add By T.Takagi@FSIT ���[�}�������J�i���Ɛ��N�����̊Ԃɒǉ�
'
' �@�\�@�@ : ���p�p�����`�F�b�N
'
' �����@�@ : (In)     strExpression  ������
'
' �߂�l�@ : True   ���p�p�����Ƃ��ĔF���\
' �@�@�@�@   False  ���p�p�����Ƃ��ĔF���s�\
'
' ���l�@�@ :
'
Public Function CheckNarrowValue(ByVal strExpression As String) As Boolean

    Dim i   As Long '�C���f�b�N�X

    strExpression = Trim(strExpression)

    '���p�p�����`�F�b�N
    For i = 1 To Len(strExpression)
        Select Case Asc(Mid(strExpression, i, 1))
            Case Is < 0, Asc("�") To Asc("�"), Is > 255
                Exit Function
        End Select
    Next i

    '�߂�l�̐ݒ�
    CheckNarrowValue = True

End Function

'
' �@�\�@�@ : �����`�F�b�N
'
' �����@�@ : (In)     strExpression  ������
'
' �߂�l�@ : True   �����Ƃ��ĔF���\
' �@�@�@�@   False  �����Ƃ��ĔF���s�\
'
' ���l�@�@ :
'
Public Function CheckNumber(ByVal strExpression As String) As Boolean

    Dim i   As Long '�C���f�b�N�X
    
    strExpression = Trim(strExpression)
    
    '���p�����`�F�b�N
    For i = 1 To Len(strExpression)
        If InStr("0123456789", Mid(strExpression, i, 1)) <= 0 Then
            Exit Function
        End If
    Next i

    '�߂�l�̐ݒ�
    CheckNumber = True
    
End Function

'
' �@�\�@�@ : ���l�`�F�b�N
'
' �����@�@ : (In)     strExpression  ������
' �@�@�@�@   (In)     lngIntLen      ��������
' �@�@�@�@   (In)     lngDecLen      ��������
'
' �߂�l�@ : True   ���l�Ƃ��ĔF���\
' �@�@�@�@   False  ���l�Ƃ��ĔF���s�\
'
' ���l�@�@ :
'
Public Function CheckNumber2(ByVal strExpression As String, Optional ByVal lngIntLen As Long = 0, Optional ByVal lngDecLen As Long = 0) As Boolean

    Dim strToken        As String   '�g�[�N��
    Dim lngAnalyzeMode  As Long     '���݂̉�̓��[�h
    Dim strInteger      As String   '�����l
    Dim strDecimal      As String   '�����l
    Dim lngSize         As Long     '������
    Dim i               As Long     '�C���f�b�N�X
    
    strExpression = Trim(strExpression)
    If strExpression = "" Then
        Exit Function
    End If

    '(�t�F�C�Y�P)�\�����
    i = 1
    
    Do

        '���ׂđ��������ꍇ�͏I��
        If i > Len(strExpression) Then
            Exit Do
        End If

        '�P�����擾
        strToken = Mid(strExpression, i, 1)

        Do
        
            '����̓��[�h���Ƃ̏���
            Select Case lngAnalyzeMode
    
                Case 0  '���[�h�w��Ȃ�
                    
                    '�����ł���ΐ������[�h��
                    If InStr("+-", strToken) > 0 Then
                        lngAnalyzeMode = 1
                        i = i + 1
                        Exit Do
                    End If

                    '�����ł���ΐ������[�h��
                    If InStr("0123456789", strToken) > 0 Then
                        lngAnalyzeMode = 1
                        Exit Do
                    End If
                    
                    '�����_�ł���Ώ������[�h��
                    If strToken = "." Then
                        lngAnalyzeMode = 2
                        i = i + 1
                        Exit Do
                    End If

                    '��L�ȊO�̏ꍇ�̓G���[
                    Exit Function

                Case 1  '�������[�h
            
                    '�����ł���ΐ����l���X�^�b�N
                    If InStr("0123456789", strToken) > 0 Then
                        strInteger = strInteger & strToken
                        i = i + 1
                        Exit Do
                    End If
            
                    '�����_�ł���Ώ������[�h��
                    If strToken = "." Then
                        lngAnalyzeMode = 2
                        i = i + 1
                        Exit Do
                    End If

                    '��L�ȊO�̏ꍇ�̓G���[
                    Exit Function
            
                Case 2  '�������[�h
            
                    '�����ł���Ώ����l���X�^�b�N
                    If InStr("0123456789", strToken) > 0 Then
                        strDecimal = strDecimal & strToken
                        i = i + 1
                        Exit Do
                    End If
            
                    '��L�ȊO�̏ꍇ�̓G���[
                    Exit Function
            
            End Select
            
            Exit Do
        Loop
        
    Loop
            
    '(�t�F�C�Y�Q)���������`�F�b�N
    If lngIntLen > 0 And strInteger <> "" Then
            
        '��������������A�ŏ��ɂO�ȊO�̒l�����������������邱�ƂŌ��������߂�
        lngSize = Len(strInteger)
        For i = 1 To Len(strInteger)
            If Mid(strInteger, i, 1) <> "0" Then
                Exit For
            End If
            lngSize = lngSize - 1
        Next i
            
        '���̌����������w�肳�ꂽ�����𒴂���΃G���[
        If lngSize > lngIntLen Then
            Exit Function
        End If

    End If
    
    '(�t�F�C�Y�R)���������`�F�b�N
    If strDecimal <> "" Then
            
        '��������Ōォ�猟�����A�ŏ��ɂO�ȊO�̒l�����������������邱�ƂŌ��������߂�
        lngSize = Len(strDecimal)
        For i = Len(strDecimal) To 1 Step -1
            If Mid(strDecimal, i, 1) <> "0" Then
                Exit For
            End If
            lngSize = lngSize - 1
        Next i
            
        '���̌����������w�肳�ꂽ�����𒴂���΃G���[
        If lngSize > lngDecLen Then
            Exit Function
        End If

    End If

    CheckNumber2 = True
    
End Function

'
' �@�\�@�@ : ���t�ϊ�
'
' �����@�@ : (In)     strExpression  ������
'
' �߂�l�@ : �ϊ���̓��t�i�A���ϊ��s�\���Ƃ̋�ʂ��s�����ߕ�����^�Ƃ��ĕԂ��j
'
' ���l�@�@ :
'
Public Function CnvDate(ByVal strExpression As String) As String

    Dim strEra      As String   '����
    Dim strYear     As String   '�N
    Dim strMonth    As String   '��
    Dim strDay      As String   '��
    
    Dim strDate     As String   '�ϊ��\�ȓ��t
    Dim strWkDate   As String   '���t�ҏW��ƈ�
    
    Do
    
        '��������
        strDate = ""
        
        '���w��̏ꍇ
        strExpression = Trim(strExpression)
        If strExpression = "" Then
            Exit Do
        End If
    
        '�s���I�h�ɂ���؂肪���݂���ꍇ�A�s���I�h���X���b�V���ɒu�����ă`�F�b�N
        If InStr(strExpression, ".") > 0 Then
            strExpression = Replace(strExpression, ".", "/")
        End If
        
        '�f�̂܂܂œ��t�Ƃ��ĔF���\�ȏꍇ
        If IsDate(strExpression) Then
            strDate = strExpression
            Exit Do
        End If
    
        '����ȊO
        
        Select Case Len(strExpression)
        
            '�U���A�܂��͂W���̏ꍇ�A����w�肩���`�F�b�N
            Case 6, 8
        
                '���p�����`�F�b�N
                If Not CheckNumber(strExpression) Then
                    Exit Do
                End If
            
                '�N�E���E����ҏW
                If Len(strExpression) = 6 Then
                    strYear = Left(strExpression, 2)
                    strMonth = Mid(strExpression, 3, 2)
                    strDay = Right(strExpression, 2)
                Else
                    strYear = Left(strExpression, 4)
                    strMonth = Mid(strExpression, 5, 2)
                    strDay = Right(strExpression, 2)
                End If
                
                '�X���b�V���ŘA�����A���t�F���\�����`�F�b�N
                strWkDate = strYear & "/" & strMonth & "/" & strDay
                If Not IsDate(strWkDate) Then
                    Exit Do
                End If
                
                strDate = strWkDate
                Exit Do
        
            '�V���̏ꍇ�A�a��w�肩���`�F�b�N
            Case 7
    
                '�擪�P�����͌����Ƃ��A����ȍ~�����p���������`�F�b�N
                If Not CheckNumber(Mid(strExpression, 2, 6)) Then
                    Exit Do
                End If
    
                '�����E�N�E���E����ҏW
                strEra = Left(strExpression, 1)
                strYear = Mid(strExpression, 2, 2)
                strMonth = Mid(strExpression, 4, 2)
                strDay = Right(strExpression, 2)
    
                '�X���b�V���ŘA�����A���t�F���\�����`�F�b�N
                strWkDate = strEra & strYear & "/" & strMonth & "/" & strDay
                If Not IsDate(strWkDate) Then
                    Exit Do
                End If
                
                strDate = strWkDate
                Exit Do
    
            '����ȊO�̓G���[
            Case Else
            
        End Select
    
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CnvDate = strDate
    
End Function

'
' �@�\�@�@ : ���ۋL���A���۔ԍ��̔�r
'
' �����@�@ : (In)     udtPerson     �l��񃌃R�[�h
' �@�@�@�@   (In)     strIsrSign    ���ۋL��
' �@�@�@�@   (In)     strIsrNo      ���۔ԍ�
' �@�@�@�@   (In)     strPerId      �l�h�c
' �@�@�@�@   (In)     strLastName   ��
' �@�@�@�@   (In)     strFirstName  ��
' �@�@�@�@   (Out)    vntMessage1   ���b�Z�[�W�P
' �@�@�@�@   (Out)    vntMessage2   ���b�Z�[�W�Q
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub CompareIsr( _
    ByRef udtPerson As PERSON_INF, _
    ByVal strIsrSign As String, _
    ByVal strIsrNo As String, _
    ByVal strPerId As String, _
    ByVal strLastName As String, _
    ByVal strFirstName As String, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
)

    Dim strBuffer   As String   '������o�b�t�@
    Dim strMessage  As String   '���b�Z�[�W
    
    '��������
    vntMessage1 = Empty
    vntMessage2 = Empty
    
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ���O�C��
'    strBuffer = "�A����=" & Trim(strLastName & "�@" & strFirstName) & "�i" & strPerId & "�j"
    strBuffer = "�]�ƈ��ԍ�=" & udtPerson.EmpNo & "�A����=" & Trim(strLastName & "�@" & strFirstName) & "�i" & strPerId & "�j"
'## 2003.04.22 Mod End
    
    '���ۋL���̔�r
    If strIsrSign <> "" And strIsrSign <> udtPerson.IsrSign Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ���O�C��
'        strMessage = "���ۋL��=" & IIf(udtPerson.IsrSign <> "", udtPerson.IsrSign, "�Ȃ�") & "�A���݂̌��ۋL��=" & IIf(strIsrSign <> "", strIsrSign, "�Ȃ�") & strBuffer
        strMessage = strBuffer & "�A���ۋL��=" & IIf(udtPerson.IsrSign <> "", udtPerson.IsrSign, "�Ȃ�") & "�A���݂̌��ۋL��=" & IIf(strIsrSign <> "", strIsrSign, "�Ȃ�")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "���݂̌l���ƌ��ۋL�����قȂ�܂��B", strMessage
    End If

    '���۔ԍ��̔�r
    If strIsrNo <> "" And strIsrNo <> udtPerson.IsrNo Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ���O�C��
'        strMessage = "���۔ԍ�=" & IIf(udtPerson.IsrNo <> "", udtPerson.IsrNo, "�Ȃ�") & "�A���݂̌��۔ԍ�=" & IIf(strIsrNo <> "", strIsrNo, "�Ȃ�") & strBuffer
        strMessage = strBuffer & "�A���۔ԍ�=" & IIf(udtPerson.IsrNo <> "", udtPerson.IsrNo, "�Ȃ�") & "�A���݂̌��۔ԍ�=" & IIf(strIsrNo <> "", strIsrNo, "�Ȃ�")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "���݂̌l���ƌ��۔ԍ����قȂ�܂��B", strMessage
    End If
    
End Sub

'
' �@�\�@�@ : �����̔�r
'
' �����@�@ : (In)     udtPerson      �l��񃌃R�[�h
' �@�@�@�@   (In)     strLastName    ��
' �@�@�@�@   (In)     strFirstName   ��
' �@�@�@�@   (In)     strLastKName   �J�i��
' �@�@�@�@   (In)     strFirstKName  �J�i��
' �@�@�@�@   (Out)    vntMessage1    ���b�Z�[�W�P
' �@�@�@�@   (Out)    vntMessage2    ���b�Z�[�W�Q
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub CompareName(ByRef udtPerson As PERSON_INF, ByVal strLastName As String, ByVal strFirstName As String, ByVal strLastKName As String, ByVal strFirstKName As String, ByRef vntMessage1 As Variant, ByRef vntMessage2 As Variant)

    Dim strCheckLastKName   As String   '�J�i��
    Dim strCheckFirstKName  As String   '�J�i��
'## 2003.04.17 Add 2Lines By T.Takagi@FSIT ���݂̃J�i�����ɂ��Ă��ꉞ�ϊ���������i�c���ڍs�f�[�^�̑Ή��j
    Dim strOriginLastKName  As String   '���݂̃J�i��
    Dim strOriginFirstKName As String   '���݂̃J�i��
'## 2003.04.17 Add End
    Dim strMessage          As String   '���b�Z�[�W
    
    '��������
    vntMessage1 = Empty
    vntMessage2 = Empty
    
'## 2003.04.17 Add 43Lines By T.Takagi@FSIT ���݂̐����ɂ��Ă��ϊ���������
    strCheckLastKName = udtPerson.LastName
    strCheckLastKName = Replace(strCheckLastKName, "�@", "�A")
    strCheckLastKName = Replace(strCheckLastKName, "�B", "�C")
    strCheckLastKName = Replace(strCheckLastKName, "�D", "�E")
    strCheckLastKName = Replace(strCheckLastKName, "�F", "�G")
    strCheckLastKName = Replace(strCheckLastKName, "�H", "�I")
    strCheckLastKName = Replace(strCheckLastKName, "�b", "�c")
    strCheckLastKName = Replace(strCheckLastKName, "��", "��")
    strCheckLastKName = Replace(strCheckLastKName, "��", "��")
    strCheckLastKName = Replace(strCheckLastKName, "��", "��")
        
    strCheckFirstKName = udtPerson.FirstName
    strCheckFirstKName = Replace(strCheckFirstKName, "�@", "�A")
    strCheckFirstKName = Replace(strCheckFirstKName, "�B", "�C")
    strCheckFirstKName = Replace(strCheckFirstKName, "�D", "�E")
    strCheckFirstKName = Replace(strCheckFirstKName, "�F", "�G")
    strCheckFirstKName = Replace(strCheckFirstKName, "�H", "�I")
    strCheckFirstKName = Replace(strCheckFirstKName, "�b", "�c")
    strCheckFirstKName = Replace(strCheckFirstKName, "��", "��")
    strCheckFirstKName = Replace(strCheckFirstKName, "��", "��")
    strCheckFirstKName = Replace(strCheckFirstKName, "��", "��")
    
    strOriginLastKName = strLastName
    strOriginLastKName = Replace(strOriginLastKName, "�@", "�A")
    strOriginLastKName = Replace(strOriginLastKName, "�B", "�C")
    strOriginLastKName = Replace(strOriginLastKName, "�D", "�E")
    strOriginLastKName = Replace(strOriginLastKName, "�F", "�G")
    strOriginLastKName = Replace(strOriginLastKName, "�H", "�I")
    strOriginLastKName = Replace(strOriginLastKName, "�b", "�c")
    strOriginLastKName = Replace(strOriginLastKName, "��", "��")
    strOriginLastKName = Replace(strOriginLastKName, "��", "��")
    strOriginLastKName = Replace(strOriginLastKName, "��", "��")
        
    strOriginFirstKName = strFirstName
    strOriginFirstKName = Replace(strOriginFirstKName, "�@", "�A")
    strOriginFirstKName = Replace(strOriginFirstKName, "�B", "�C")
    strOriginFirstKName = Replace(strOriginFirstKName, "�D", "�E")
    strOriginFirstKName = Replace(strOriginFirstKName, "�F", "�G")
    strOriginFirstKName = Replace(strOriginFirstKName, "�H", "�I")
    strOriginFirstKName = Replace(strOriginFirstKName, "�b", "�c")
    strOriginFirstKName = Replace(strOriginFirstKName, "��", "��")
    strOriginFirstKName = Replace(strOriginFirstKName, "��", "��")
    strOriginFirstKName = Replace(strOriginFirstKName, "��", "��")
'## 2003.04.17 Add End
    
    '�����̔�r
'## 2003.04.17 Mod 2Lines By T.Takagi@FSIT ���݂̃J�i�����ɂ��Ă��ꉞ�ϊ���������i�c���ڍs�f�[�^�̑Ή��j
'    If strLastName <> udtPerson.LastName Or strFirstName <> udtPerson.FirstName Then
    If strOriginLastKName <> strCheckLastKName Or strOriginFirstKName <> strCheckFirstKName Then
'## 2003.04.17 Mod End
        strMessage = "����=" & Trim(udtPerson.LastName & "�@" & udtPerson.FirstName)
        strMessage = strMessage & "�A���݂̎���=" & Trim(strLastName & "�@" & strFirstName)
        AppendMessage vntMessage1, vntMessage2, "���݂̌l���Ǝ������قȂ�܂��B�����͍X�V����܂��B", strMessage
    End If
        
    strCheckLastKName = udtPerson.LastKName
    strCheckLastKName = Replace(strCheckLastKName, "�@", "�A")
    strCheckLastKName = Replace(strCheckLastKName, "�B", "�C")
    strCheckLastKName = Replace(strCheckLastKName, "�D", "�E")
    strCheckLastKName = Replace(strCheckLastKName, "�F", "�G")
    strCheckLastKName = Replace(strCheckLastKName, "�H", "�I")
    strCheckLastKName = Replace(strCheckLastKName, "�b", "�c")
    strCheckLastKName = Replace(strCheckLastKName, "��", "��")
    strCheckLastKName = Replace(strCheckLastKName, "��", "��")
    strCheckLastKName = Replace(strCheckLastKName, "��", "��")
        
    strCheckFirstKName = udtPerson.FirstKName
    strCheckFirstKName = Replace(strCheckFirstKName, "�@", "�A")
    strCheckFirstKName = Replace(strCheckFirstKName, "�B", "�C")
    strCheckFirstKName = Replace(strCheckFirstKName, "�D", "�E")
    strCheckFirstKName = Replace(strCheckFirstKName, "�F", "�G")
    strCheckFirstKName = Replace(strCheckFirstKName, "�H", "�I")
    strCheckFirstKName = Replace(strCheckFirstKName, "�b", "�c")
    strCheckFirstKName = Replace(strCheckFirstKName, "��", "��")
    strCheckFirstKName = Replace(strCheckFirstKName, "��", "��")
    strCheckFirstKName = Replace(strCheckFirstKName, "��", "��")
        
'## 2003.04.17 Add 21Lines By T.Takagi@FSIT ���݂̃J�i�����ɂ��Ă��ꉞ�ϊ���������i�c���ڍs�f�[�^�̑Ή��j
    strOriginLastKName = strLastKName
    strOriginLastKName = Replace(strOriginLastKName, "�@", "�A")
    strOriginLastKName = Replace(strOriginLastKName, "�B", "�C")
    strOriginLastKName = Replace(strOriginLastKName, "�D", "�E")
    strOriginLastKName = Replace(strOriginLastKName, "�F", "�G")
    strOriginLastKName = Replace(strOriginLastKName, "�H", "�I")
    strOriginLastKName = Replace(strOriginLastKName, "�b", "�c")
    strOriginLastKName = Replace(strOriginLastKName, "��", "��")
    strOriginLastKName = Replace(strOriginLastKName, "��", "��")
    strOriginLastKName = Replace(strOriginLastKName, "��", "��")
        
    strOriginFirstKName = strFirstKName
    strOriginFirstKName = Replace(strOriginFirstKName, "�@", "�A")
    strOriginFirstKName = Replace(strOriginFirstKName, "�B", "�C")
    strOriginFirstKName = Replace(strOriginFirstKName, "�D", "�E")
    strOriginFirstKName = Replace(strOriginFirstKName, "�F", "�G")
    strOriginFirstKName = Replace(strOriginFirstKName, "�H", "�I")
    strOriginFirstKName = Replace(strOriginFirstKName, "�b", "�c")
    strOriginFirstKName = Replace(strOriginFirstKName, "��", "��")
    strOriginFirstKName = Replace(strOriginFirstKName, "��", "��")
    strOriginFirstKName = Replace(strOriginFirstKName, "��", "��")
'## 2003.04.17 Add End
        
    '�J�i�����̔�r
'## 2003.04.17 Mod 2Lines By T.Takagi@FSIT ���݂̃J�i�����ɂ��Ă��ꉞ�ϊ���������i�c���ڍs�f�[�^�̑Ή��j
'    If strLastKName <> strCheckLastKName Or strFirstKName <> strCheckFirstKName Then
    If strOriginLastKName <> strCheckLastKName Or strOriginFirstKName <> strCheckFirstKName Then
'## 2003.04.17 Mod End
        strMessage = "�J�i����=" & Trim(udtPerson.LastKName & "�@" & udtPerson.FirstKName)
        strMessage = strMessage & "�A���݂̃J�i����=" & Trim(strLastKName & "�@" & strFirstKName)
        AppendMessage vntMessage1, vntMessage2, "���݂̌l���ƃJ�i�������قȂ�܂��B�J�i�����͍X�V����܂��B", strMessage
    End If
    
End Sub

'
' �@�\�@�@ : ���N�����A���ʂ̔�r
'
' �����@�@ : (In)     udtPerson     �l��񃌃R�[�h
' �@�@�@�@   (In)     dtmBirth      ���N����
' �@�@�@�@   (In)     lngGender     ����
' �@�@�@�@   (In)     strPerId      �l�h�c
' �@�@�@�@   (In)     strLastName   ��
' �@�@�@�@   (In)     strFirstName  ��
' �@�@�@�@   (Out)    vntMessage1   ���b�Z�[�W�P
' �@�@�@�@   (Out)    vntMessage2   ���b�Z�[�W�Q
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub ComparePerson( _
    ByRef udtPerson As PERSON_INF, _
    ByVal dtmBirth As Date, _
    ByVal lngGender As Long, _
    ByVal strPerId As String, _
    ByVal strLastName As String, _
    ByVal strFirstName As String, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
)

    Dim strBuffer   As String   '������o�b�t�@
    Dim strMessage  As String   '���b�Z�[�W
    
    '��������
    vntMessage1 = Empty
    vntMessage2 = Empty
    
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ���O�C��
'    strBuffer = "�A����=" & Trim(strLastName & "�@" & strFirstName) & "�i" & strPerId & "�j"
    strBuffer = "����=" & Trim(strLastName & "�@" & strFirstName) & "�i" & strPerId & "�j"
'## 2003.04.22 Mod End
    
    '���N�����̔�r
    If dtmBirth <> udtPerson.Birth Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ���O�C��
'        strMessage = "���N����=" & Format(udtPerson.Birth, "ge.m.d") & "�A���݂̐��N����=" & Format(dtmBirth, "ge.m.d") & strBuffer
        strMessage = strBuffer & "�A���N����=" & Format(udtPerson.Birth, "ge.m.d") & "�A���݂̐��N����=" & Format(dtmBirth, "ge.m.d")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "���݂̌l���Ɛ��N�������قȂ�܂��B", strMessage
    End If

    '���ʂ̔�r
    If lngGender <> udtPerson.Gender Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ���O�C��
'        strMessage = "����=" & IIf(udtPerson.Gender = 1, "�j��", "����") & "�A���݂̐���=" & IIf(lngGender = 1, "�j��", "����") & strBuffer
        strMessage = strBuffer & "�A����=" & IIf(udtPerson.Gender = 1, "�j��", "����") & "�A���݂̐���=" & IIf(lngGender = 1, "�j��", "����")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "���݂̌l���Ɛ��ʂ��قȂ�܂��B", strMessage
    End If
    
End Sub

'
' �@�\�@�@ : �l���X�V���̃��b�Z�[�W��ҏW����
'
' �����@�@ : (In)     lngCalled    �Ăь�(0:�l����񂩂�A1:���ۖ{�l����)
' �@�@�@�@   (In)     strMode      �������[�h
' �@�@�@�@   (In)     lngStatus    ���
' �@�@�@�@   (In)     strPerId     �l�h�c
' �@�@�@�@   (In)     udtPerson    �l��񃌃R�[�h
' �@�@�@�@   (In)     strUserId    ���[�U�h�c
' �@�@�@�@   (Out)    strMessage1  ���b�Z�[�W�P
' �@�@�@�@   (Out)    strMessage2  ���b�Z�[�W�Q
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub EditMessage(ByVal lngCalled As Long, ByVal strMode As String, ByVal lngStatus As Long, ByVal strPerId As String, ByRef udtPerson As PERSON_INF, ByVal strUserId As String, ByRef strMessage1 As String, ByRef strMessage2 As String)

    Dim strMessage  As String   '���b�Z�[�W
    
    '��������
    strMessage1 = ""
    strMessage2 = ""
    
    '���b�Z�[�W��{�����̕ҏW
    Select Case lngCalled
        Case 0
            strMessage = "�]�ƈ��ԍ�=" & udtPerson.EmpNo
        Case 1
            strMessage = "���ۋL��=" & udtPerson.IsrSign & "�A���۔ԍ�=" & udtPerson.IsrNo
    End Select
    
    strMessage = strMessage & "�A����=" & Trim(udtPerson.LastName & "�@" & udtPerson.FirstName)
    
    '��Ԃ��Ƃ̃��b�Z�[�W�ҏW
    Select Case lngStatus
        
        Case Is > 0 '���펞
            
            strMessage1 = "�l���" & IIf(strMode = MODE_INSERT, "�쐬", "�X�V") & "����܂����B"
            strMessage2 = strMessage & "�i" & strPerId & "�j"
            
        Case 0      '�l�h�c�d����
            
            '�}�����͕K���l�h�c�𔭔Ԃ���̂Ŗ{�����͐�Δ������Ȃ��B����čX�V���̃��b�Z�[�W�̂݋L���B
            If strMode = MODE_UPDATE Then
                strMessage1 = "���̌l���͂��łɍ폜����Ă��܂��B�X�V�ł��܂���B"
                strMessage2 = strMessage
            End If
            
        Case -1     '�c�̏��d����
            
            strMessage1 = "����c�́A�]�ƈ��ԍ��̌l��񂪂��łɑ��݂��܂��B"
            strMessage2 = strMessage
        
        Case -2     '���ۏ��d����
            
            strMessage1 = "���ꌒ�ہA�����A�}�Ԃ̌l��񂪂��łɑ��݂��܂��B"
            strMessage2 = strMessage
            
            If lngCalled = 0 Then
                strMessage2 = strMessage2 & "�A���ۋL��=" & udtPerson.IsrSign
                strMessage2 = strMessage2 & "�A���۔ԍ�=" & udtPerson.IsrNo
            End If
            
            strMessage2 = strMessage2 & "�A����=" & udtPerson.RelationCd
            strMessage2 = strMessage2 & "�A�}��=" & udtPerson.BranchNo
        
        Case -3     '���[�U���񑶍ݎ�
            
            strMessage1 = "���[�U�h�c�����݂��܂���B"
            strMessage2 = "���[�U�h�c=" & strUserId
            
        Case -4     '�������񑶍ݎ�
            
            strMessage1 = "������񂪑��݂��܂���B"
            strMessage2 = strMessage
            strMessage2 = strMessage2 & "�A���ƕ��R�[�h=" & IIf(udtPerson.OrgBsdCd <> "", udtPerson.OrgBsdCd, "�Ȃ�")
            strMessage2 = strMessage2 & "�A�����R�[�h=" & IIf(udtPerson.OrgRoomCd <> "", udtPerson.OrgRoomCd, "�Ȃ�")
            strMessage2 = strMessage2 & "�A�����R�[�h=" & IIf(udtPerson.OrgPostCd <> "", udtPerson.OrgPostCd, "�Ȃ�")
        
        Case -5     '�����񑶍ݎ�
        
            strMessage1 = "���������݂��܂���B"
            strMessage2 = strMessage & "�A����=" & udtPerson.RelationCd
        
        Case -6     '�����Őe�l�h�c�͍X�V���Ȃ��̂Ŗ{�����͔������Ȃ�
            
        Case -7     '�E���񑶍ݎ�
            
            strMessage1 = "�E����񂪑��݂��܂���B"
            strMessage2 = strMessage & "�A�E���R�[�h=" & udtPerson.JobCd
        
        Case -8     '�E�Ӕ񑶍ݎ�
            
            strMessage1 = "�E�ӏ�񂪑��݂��܂���B"
            strMessage2 = strMessage & "�A�E�ӃR�[�h=" & udtPerson.DutyCd
        
        Case -9     '���i�񑶍ݎ�
        
            strMessage1 = "���i��񂪑��݂��܂���B"
            strMessage2 = strMessage & "�A���i�R�[�h=" & udtPerson.QualifyCd
        
        Case -10    '�����ł͏A�Ƒ[�u�敪�͍X�V���Ȃ��̂Ŗ{�����͔������Ȃ�
        
        Case Else
            
            strMessage1 = "�l���̍X�V�����ł��̑��G���[���������܂����B"
            strMessage2 = strMessage & "�A�G���[�R�[�h=" & lngStatus
    
    End Select

End Sub

'
' �@�\�@�@ : �l��񃌃R�[�h�\���̂̏�����
'
' �����@�@ : (In)     udtPerson  �l��񃌃R�[�h�\����
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub Initialize(ByRef udtPerson As PERSON_INF)

    With udtPerson
        .DelFlg = 0
        .TransferDiv = 0
        .LastName = ""
        .FirstName = ""
        .LastKName = ""
        .FirstKName = ""
        .Birth = 0
        .Gender = 0
        .OrgBsdCd = ""
        .OrgBsdName = ""
        .OrgRoomCd = ""
        .OrgRoomName = ""
        .OrgPostCd = ""
        .OrgPostName = ""
        .JobCd = ""
        .JobName = ""
        .DutyCd = ""
        .DutyName = ""
        .QualifyCd = ""
        .QualifyName = ""
        .IsrSign = ""
        .IsrNo = ""
        .RelationCd = ""
        .BranchNo = 0
        .EmpNo = ""
        .HireDate = 0
        .EmpDiv = ""
'## 2003.01.29 Add 1Line By T.Takagi@FSIT �]�ƈ��敪���̑Ή�
        .EmpName = ""
'## 2003.01.29 Add End
        .HongenDiv = ""
        .Tel1 = ""
        .Tel2 = ""
        .Tel3 = ""
        .ZipCd1 = ""
        .ZipCd2 = ""
        .Address1 = ""
        .Address2 = ""
'## 2003.02.07 Add 1Line By T.Takagi@FSIT ��f��]���Ή�
        .CslDate = 0
'## 2003.02.07 Add End
    End With

End Sub

'
' �@�\�@�@ : �w�肳�ꂽ�t�@�C�����g�p���ł��邩�𔻒�
'
' �����@�@ : (In)     strFileName  �t�@�C����
'
' �߂�l�@ : True   �g�p���ł���
' �@�@�@�@   False  �g�p����Ă��Ȃ�
'
' ���l�@�@ :
'
Public Function Locked(ByVal strFileName As String) As Boolean
    
    Dim Fn  As Integer  '�t�@�C���ԍ�
    Dim Ret As Boolean  '�֐��߂�l
    
    '�G���[�n���h���̐ݒ�
    On Error GoTo ErrorHandle
    
    '�r���t���ǂݍ��݃��[�h�Ńt�@�C�����I�[�v�����A�r�����𔻒f
    Fn = FreeFile()
    Open strFileName For Input Lock Read Write As #Fn
    
    Close #Fn
    
    '�߂�l�̐ݒ�
    Locked = Ret
    
    Exit Function

ErrorHandle:

    '�u�������݂ł��܂���v�̃G���[�����������ꍇ�ɔr���Ɣ��f
    If Err.Number = 70 Then
        Ret = True
        Resume Next
    End If

    '����ȊO�̓G���[�𔭐������ďI������
    Err.Raise Err.Number

End Function

'
' �@�\�@�@ : ���O�e�[�u�����R�[�h��}������
'
' �����@�@ : (In)    objOraDb           OraDatabase�I�u�W�F�N�g
' �@�@�@�@   (In)    strTransactionId   �g�����U�N�V����ID
' �@�@�@�@   (In)    strTransactionDiv  �����敪
' �@�@�@�@   (In)    strInformationDiv  ���敪
' �@�@�@�@   (In)    strLineNo          �Ώۏ����s
' �@�@�@�@   (In)    vntMessage1        ���b�Z�[�W�P
' �@�@�@�@   (In)    vntMessage2        ���b�Z�[�W�Q
' �@�@�@�@   (In)    blnNewTransaction  �Ɨ������g�����U�N�V�����Ƃ��Ď��s���邩
'
' �߂�l�@ : INSERT_NORMAL  ����I��
' �@�@�@�@   INSERT_ERROR   �ُ�I��
'
' ���l�@�@ :
'
Public Function PutHainsLog( _
    ByRef objOraDb As OraDatabase, _
    ByVal lngTransactionId As Long, _
    ByVal strTransactionDiv As String, _
    ByVal strInformationDiv As String, _
    ByVal strLineNo As String, _
    ByVal vntMessage1 As Variant, _
    ByVal vntMessage2 As Variant, _
    Optional ByVal blnNewTransaction As Boolean = True _
) As Long

    Dim objOraParam     As OraParameters    'OraParameters�I�u�W�F�N�g
    Dim objOraSqlStmt   As OraSqlStmt       'OraSQLStmt�I�u�W�F�N�g
    Dim strStmt         As String           'SQL�X�e�[�g�����g
    
    Dim objMessage1     As OraParameter     '���b�Z�[�W�P
    Dim objMessage2     As OraParameter     '���b�Z�[�W�Q
    
    Dim vntArrMessage1  As Variant          '���b�Z�[�W�P
    Dim vntArrMessage2  As Variant          '���b�Z�[�W�Q
    
    Dim Ret             As Long             '�֐��߂�l
    Dim i               As Long             '�C���f�b�N�X
    
    '�G���[�n���h���̐ݒ�
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    '�}�������ɍۂ��A�����l��z��`���ɕϊ�
    If Not IsArray(vntMessage1) Then
        vntArrMessage1 = Array(vntMessage1)
        vntArrMessage2 = Array(vntMessage2)
    Else
        vntArrMessage1 = vntMessage1
        vntArrMessage2 = vntMessage2
    End If
    
    '�L�[�y�эX�V�l�̐ݒ�
    Set objOraParam = objOraDb.Parameters
    objOraParam.Add "TRANSACTIONID", lngTransactionId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TRANSACTIONDIV", strTransactionDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INFORMATIONDIV", strInformationDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LINENO", strLineNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RET", "", ORAPARM_OUTPUT, ORATYPE_NUMBER

    '�p�����[�^�̎Q�Ɛݒ�
    Set objMessage1 = objOraParam("MESSAGE1")
    Set objMessage2 = objOraParam("MESSAGE2")
    objMessage1.MinimumSize = 150
    objMessage2.MinimumSize = 150

    '���O���R�[�h�}���p��SQL�X�e�[�g�����g�쐬
    If blnNewTransaction Then
        strStmt = "BEGIN :RET := PutHainsLog(:TRANSACTIONID, :TRANSACTIONDIV, :INFORMATIONDIV, :LINENO, :MESSAGE1, :MESSAGE2); END;"
    Else
        strStmt = "INSERT INTO HAINSLOG (                            " & vbLf & _
                  "                TRANSACTIONID,                    " & vbLf & _
                  "                INSDATE,                          " & vbLf & _
                  "                TRANSACTIONDIV,                   " & vbLf & _
                  "                INFORMATIONDIV,                   " & vbLf & _
                  "                STATEMENTNO,                      " & vbLf & _
                  "                LINENO,                           " & vbLf & _
                  "                MESSAGE1,                         " & vbLf & _
                  "                MESSAGE2                          " & vbLf & _
                  "            ) VALUES (                            " & vbLf & _
                  "                :TRANSACTIONID,                   " & vbLf & _
                  "                SYSDATE,                          " & vbLf & _
                  "                :TRANSACTIONDIV,                  " & vbLf & _
                  "                :INFORMATIONDIV,                  " & vbLf & _
                  "                HAINSLOG_STATEMENTNO_SEQ.NEXTVAL, " & vbLf & _
                  "                :LINENO,                          " & vbLf & _
                  "                :MESSAGE1,                        " & vbLf & _
                  "                :MESSAGE2                         " & vbLf & _
                  "            )                                     "
    End If
    
    '�e�z��l�̑}������
    For i = 0 To UBound(vntArrMessage1)

        '�z��l�̕ҏW
        objMessage1.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage1(i), vbFromUnicode), 150), vbUnicode))
        objMessage2.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage2(i), vbFromUnicode), 150), vbUnicode))

        '�}��SQL���̎��s
        If objOraSqlStmt Is Nothing Then
            Set objOraSqlStmt = objOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSqlStmt.Refresh
        End If
    Next i

    '�o�C���h�ϐ��̍폜
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '�߂�l�̐ݒ�
    PutHainsLog = INSERT_NORMAL

    Exit Function
    
ErrorHandle:

    '���̑��̖߂�l�ݒ�
    PutHainsLog = INSERT_ERROR

    '�C�x���g���O��������
    WriteErrorLog "Cooperation.PutHainsLog"
    
    '�G���[�������������N����
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' �@�\�@�@ : �b�r�u�f�[�^��z�񉻂��A�����ږ�����э��ڒ���`�̔z���Ԃ�
'
' �����@�@ : (In)     strCsvStream     �b�r�u�f�[�^
' �@�@�@�@   (In)     lngMaxArraySize  �z��̍ő�T�C�Y
' �@�@�@�@   (Out)    vntColumns       �J�����l
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub SetColumnsArrayFromCsvString(ByRef strCsvStream As String, ByRef lngMaxArraySize As Long, ByRef vntColumns As Variant)

    Dim vntArrColumns   As Variant  '�e�J�����̏W��

    Dim i               As Long     '�C���f�b�N�X
    
    '��������
    vntColumns = Empty
    
    '�J���}����
    vntArrColumns = Split(strCsvStream, ",")

    '�z��̃T�C�Y����
    ReDim Preserve vntArrColumns(lngMaxArraySize)
    
    '�J�����l�̌���
    For i = LBound(vntArrColumns) To UBound(vntArrColumns)
    
        '��[�̃_�u���N�H�[�e�[�V���������O
        If Left(vntArrColumns(i), 1) = """" Then
            vntArrColumns(i) = Right(vntArrColumns(i), Len(vntArrColumns(i)) - 1)
        End If
        
        '�I�[�̃_�u���N�H�[�e�[�V���������O
        If Right(vntArrColumns(i), 1) = """" Then
            vntArrColumns(i) = Left(vntArrColumns(i), Len(vntArrColumns(i)) - 1)
        End If
        
        '�l�̃g���~���O
        vntArrColumns(i) = Trim(vntArrColumns(i))
    
    Next i
    
    '�߂�l�̐ݒ�
    vntColumns = vntArrColumns
    
End Sub

'
' �@�\�@�@ : �����̕���
'
' �����@�@ : (In)    strName       ����
' �@�@�@�@   (Out)   strLastName   ��
' �@�@�@�@   (Out)   strFirstName  ��
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub SplitName(ByVal strName As String, ByRef strLastName As String, ByRef strFirstName As String)

    Dim lngPtr  As Long '�ŏ��ɋ󔒂����������ʒu
    
    '��������
    strLastName = ""
    strFirstName = ""

    strName = Trim(strName)
    If strName = "" Then
        Exit Sub
    End If

    '�S�p�ϊ�
    strName = StrConv(strName, vbWide)

    '�S�p�󔒂�����
    lngPtr = InStr(strName, "�@")

    '�S�p�󔒂����݂��Ȃ��ꍇ
    If lngPtr <= 0 Then
        strLastName = strName
        Exit Sub
    End If

    '�S�p�󔒂����݂���ꍇ
    strLastName = Trim(Left(strName, lngPtr - 1))
    strFirstName = Trim(Right(strName, Len(strName) - lngPtr))

End Sub
