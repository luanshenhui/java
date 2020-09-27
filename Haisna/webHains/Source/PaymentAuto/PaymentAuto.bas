Attribute VB_Name = "PaymentAuto"
Option Explicit

Public Const MODE_INSERT        As String = "I" '�������[�h(�}��)
Public Const MODE_UPDATE        As String = "U" '�������[�h(�X�V)

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
    WriteErrorLog "PaymentAuto.PutHainsLog"
    
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


'
' �@�\�@�@ : �c�̃R�[�h�̕���
'
' �����@�@ : (In)    strOrgcd      �c�̃R�[�h�iXXXXX-XXXXX�j
' �@�@�@�@   (Out)   strOrgcd1     �c�̃R�[�h�P
' �@�@�@�@   (Out)   strOrgcd2     �c�̃R�[�h�Q
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Public Sub SplitOrgcd(ByVal strOrgCd As String, ByRef strOrgCd1 As String, ByRef strOrgCd2 As String)

    Dim lngPtr  As Long '�ŏ���"-"�����������ʒu
    
    '��������
    strOrgCd1 = ""
    strOrgCd2 = ""

    strOrgCd = Trim(strOrgCd)
    If strOrgCd = "" Then
        Exit Sub
    End If

    '�S�p�ϊ�
    strOrgCd = StrConv(strOrgCd, vbNarrow)

    '���p"-"������
    lngPtr = InStr(strOrgCd, "-")

    '���p"-"�����݂��Ȃ��ꍇ
    If lngPtr <= 0 Then
        strOrgCd1 = strOrgCd
        Exit Sub
    End If

    '���p"-"�����݂���ꍇ
    strOrgCd1 = Trim(Left(strOrgCd, lngPtr - 1))
    strOrgCd2 = Trim(Right(strOrgCd, Len(strOrgCd) - lngPtr))

End Sub

