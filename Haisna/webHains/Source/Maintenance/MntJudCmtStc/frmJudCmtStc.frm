VERSION 5.00
Begin VB.Form frmJudCmtStc 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "����R�����g�e�[�u�������e�i���X"
   ClientHeight    =   5685
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8160
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmJudCmtStc.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5685
   ScaleWidth      =   8160
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboOutPriority 
      Height          =   300
      ItemData        =   "frmJudCmtStc.frx":000C
      Left            =   2040
      List            =   "frmJudCmtStc.frx":000E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   15
      Top             =   4680
      Width           =   5850
   End
   Begin VB.CheckBox chkHihyouji 
      Caption         =   "���̃R�����g�̓K�C�h�ɕ\�����Ȃ�(&S)"
      Height          =   225
      Left            =   3360
      TabIndex        =   2
      Top             =   150
      Width           =   2835
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "���x���T(&5)"
      Height          =   255
      Index           =   4
      Left            =   6840
      TabIndex        =   14
      Top             =   4080
      Width           =   1095
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "���x���S(&4)"
      Height          =   255
      Index           =   3
      Left            =   5640
      TabIndex        =   13
      Top             =   4080
      Width           =   1155
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "���x���R(&3)"
      Height          =   255
      Index           =   2
      Left            =   4440
      TabIndex        =   12
      Top             =   4080
      Width           =   1185
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "���x���Q(&2)"
      Height          =   255
      Index           =   1
      Left            =   3240
      TabIndex        =   11
      Top             =   4080
      Width           =   1155
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "���x���P(&1)"
      Height          =   315
      Index           =   0
      Left            =   2040
      TabIndex        =   10
      Top             =   4050
      Width           =   1155
   End
   Begin VB.TextBox txtJudCmtStc1 
      Height          =   1380
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   2040
      MaxLength       =   500
      MultiLine       =   -1  'True
      TabIndex        =   6
      Top             =   2100
      Width           =   5835
   End
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmJudCmtStc.frx":0010
      Left            =   2040
      List            =   "frmJudCmtStc.frx":0012
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   8
      Top             =   3570
      Width           =   5850
   End
   Begin VB.TextBox txtJudCmtStc 
      Height          =   1380
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   2040
      MaxLength       =   250
      MultiLine       =   -1  'True
      TabIndex        =   4
      Top             =   540
      Width           =   5835
   End
   Begin VB.TextBox txtJudCmtCd 
      Height          =   300
      Left            =   2040
      MaxLength       =   8
      TabIndex        =   1
      Text            =   "@@@@@@@@"
      Top             =   120
      Width           =   1095
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   5130
      TabIndex        =   16
      Top             =   5280
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6540
      TabIndex        =   17
      Top             =   5280
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "�o�͏��敪(&S):"
      Height          =   195
      Index           =   1
      Left            =   120
      TabIndex        =   19
      Top             =   4740
      Width           =   1335
   End
   Begin VB.Label Label5 
      Caption         =   "���F�����x���͐����w���R�����g�ɂ̂ݗL���ł�"
      Height          =   195
      Left            =   2040
      TabIndex        =   18
      Top             =   4440
      Width           =   3855
   End
   Begin VB.Label Label2 
      Caption         =   "�F�����x��:"
      Height          =   195
      Left            =   120
      TabIndex        =   9
      Top             =   4140
      Width           =   1125
   End
   Begin VB.Label Label1 
      Caption         =   "����R�����g �`�p��(&E):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   5
      Top             =   2100
      Width           =   1770
   End
   Begin VB.Label Label8 
      Caption         =   "���蕪��(&B):"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   3630
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "����R�����g �`���{��(&J):"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Width           =   1890
   End
   Begin VB.Label Label1 
      Caption         =   "����R�����g�R�[�h(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1590
   End
End
Attribute VB_Name = "frmJudCmtStc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ�: SL-UI-Y0101-105
'�C����  �F2010.06.15
'�S����  �FTCS)�c��
'�C�����e: �o�͏��敪��ǉ�

Option Explicit

Private mstrJudCmtCd        As String   '����R�����g�R�[�h
Private mstrJudCmtStc       As String   '���蕪�ޖ�
Private mstrJudClassCd      As String   '���蕪�ރR�[�h

Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrArrJudClassCd()    As String
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####
Private mstrOutPriority        As String
Private mstrArrOutPriority()   As String   '�o�͏��敪

Private Const CONST_FREE_OUTPRIORITY As String = "JUDCMTPOT"
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let JudClassCd(ByVal vntNewValue As String)

    mstrJudClassCd = vntNewValue
    
End Property
Friend Property Let JudCmtStc(ByVal vntNewValue As String)

    mstrJudCmtStc = vntNewValue
    
End Property

Friend Property Let JudCmtCd(ByVal vntNewValue As String)

    mstrJudCmtCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

' @(e)
'
' �@�\�@�@ : ���蕪�ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���蕪�ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditJudClass() As Boolean

    Dim objJudClass         As Object       '���蕪�ރA�N�Z�X�p
    Dim vntJudClassCd       As Variant
    Dim vntJudClassName     As Variant

    Dim lngCount    As Long             '���R�[�h��
    Dim i           As Long             '�C���f�b�N�X
    
    EditJudClass = False
    
    cboJudClass.Clear
    Erase mstrArrJudClassCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)
    
    '���蕪�ނ͕K�{�ɂȂ�܂����B
    If lngCount < 1 Then
        MsgBox "���蕪�ރR�[�h���o�^����Ă��܂���B����R�����g�͔��蕪�ނ�o�^���Ă���ēx�o�^���Ă��������B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    '���蕪�ރR�[�h�͖��I�����聨�Ȃ��ɕύX
    ReDim Preserve mstrArrJudClassCd(0)
    mstrArrJudClassCd(0) = ""
    cboJudClass.AddItem ""
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrJudClassCd(i + 1)
        mstrArrJudClassCd(i + 1) = vntJudClassCd(i)
        cboJudClass.AddItem vntJudClassName(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���i���蕪�ނ͖��I������j
    cboJudClass.ListIndex = 0
    
    '�f�t�H���g�Z�b�g���ꂽ���蕪�ނ��Z�b�g
    If mstrJudClassCd <> "" Then
        For i = 0 To UBound(mstrArrJudClassCd)
            If mstrArrJudClassCd(i) = mstrJudClassCd Then
                cboJudClass.ListIndex = i
            End If
        Next i
    End If
    
    EditJudClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
' @(e)
'
' �@�\�@�@ : �o�͏��敪�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �o�͏��敪���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditOutPriority() As Boolean

    Dim objFree             As Object   '�ėp���A�N�Z�X�p
    
    Dim vntOutPriority          As Variant  '�o�͏��敪�R�[�h(�ėp�t�B�[���h�P)
    Dim vntOutPriorityName      As Variant  '�o�͏��敪����(�ėp�t�B�[���h�Q)
    Dim vntOutPriorityDef       As Variant  '�o�͏��敪�f�t�H���g�`�F�b�N(�ėp�t�B�[���h�R)
    Dim lngCount            As Long     '���R�[�h��
    Dim i                   As Long     '�C���f�b�N�X
    
    EditOutPriority = False
    
    cboOutPriority.Clear
    Erase mstrArrOutPriority

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")
    lngCount = objFree.SelectFree(1, CONST_FREE_OUTPRIORITY, , , , vntOutPriority, vntOutPriorityName, vntOutPriorityDef)
    
    If lngCount < 0 Then
        MsgBox "�o�͏��敪�ǂݍ��ݒ��ɃV�X�e���I�ȃG���[���������܂����B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    '���I�����聨�Ȃ��ɕύX
    ReDim Preserve mstrArrOutPriority(0)
    mstrArrOutPriority(0) = ""
    cboOutPriority.AddItem ""
    
    '�擪�R���{��I����Ԃɂ���
    cboOutPriority.ListIndex = 0
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrOutPriority(i + 1)
        mstrArrOutPriority(i + 1) = vntOutPriority(i)
        cboOutPriority.AddItem vntOutPriority(i) & ":" & vntOutPriorityName(i)
    
        '�f�t�H���g�l�̐ݒ肪����΁A�f�t�H���g���Ƃ��Đݒ肷��
        '       �i�����f�t�H���g���ݒ肳��Ă����ꍇ�͌�Ɏw�肳�ꂽ�l���D�悳���j
        If vntOutPriorityDef(i) <> "" Then
            cboOutPriority.ListIndex = cboOutPriority.ListCount - 1
        End If
    
    Next i
    
    EditOutPriority = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'


'
' �@�\�@�@ : ���̓f�[�^�`�F�b�N
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����f�[�^�AFALSE:�ُ�f�[�^����
'
' ���l�@�@ :
'
Private Function CheckValue() As Boolean

    Dim Ret As Boolean  '�֐��߂�l
'### 2004/11/15 Add by Gouda@FSIT �����w���R�����g�̕\������
    Dim i               As Long     '�J�E���g
    Dim blnCheckFlg     As Boolean  '�`�F�b�N�t���O
    Const JUDCLASS_RECOGLEVEL = 50  '���蕪�ރR�[�h
'### 2004/11/15 Add End
    
    Ret = False
    
    Do
        '�R�[�h�̓��̓`�F�b�N
        If Trim(txtJudCmtCd.Text) = "" Then
            MsgBox "����R�����g�R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            txtJudCmtCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtJudCmtStc.Text) = "" Then
            MsgBox "����R�����g�����͂���Ă��܂���B", vbExclamation, App.Title
            txtJudCmtStc.SetFocus
            Exit Do
        End If

'        '���蕪�ޑI���`�F�b�N
'        If cboJudClass.ListIndex < 1 Then
'            MsgBox "���蕪�ނ��I������Ă��܂���B", vbExclamation, App.Title
'            cboJudClass.SetFocus
'            Exit Do
'        End If

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

'
' �@�\�@�@ : �f�[�^�\���p�ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditJudCmtStc() As Boolean

    Dim objJudCmtStc    As Object           '����R�����g�A�N�Z�X�p
    
    Dim vntJudCmtStc    As Variant          '����R�����g��

' ****************2004/08/24 FJTH)M<E �p��R�����g�p�@�ǉ�  - S ****************************
    Dim vntJudCmtStc_e    As Variant          '����R�����g��
' ****************2004/08/24 FJTH)M<E �p��R�����g�p�@�ǉ�  - E ****************************
    
    Dim vntJudClassCd   As Variant          '���蕪�ރR�[�h
    
'### 2004/11/15 Add by Gouda@FSIT �����w���R�����g�̕\������
    Dim vntHihyouji         As Variant      '��\��
    Dim vntRecogLevel1      As Variant      '�F�����x���P
    Dim vntRecogLevel2      As Variant      '�F�����x���Q
    Dim vntRecogLevel3      As Variant      '�F�����x���R
    Dim vntRecogLevel4      As Variant      '�F�����x���S
    Dim vntRecogLevel5      As Variant      '�F�����x���T
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    Dim vntOutPriority          As Variant      '�o�͏��敪
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'

    Dim Ret             As Boolean          '�߂�l
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If Trim(mstrJudCmtCd) = "" Then
            Ret = True
            Exit Do
        End If
        
        '����R�����g�e�[�u�����R�[�h�ǂݍ���
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'
''''### 2004/11/15 Add by Gouda@FSIT �����w���R�����g�̕\������
''''' ****************2004/08/24 FJTH)M<E �p��R�����g�p�@�ǉ�  - S ****************************
''''        If objJudCmtStc.SelectJudCmtStcnew(mstrJudCmtCd, _
''''                                        vntJudCmtStc, _
''''                                        vntJudCmtStc_e, _
''''                                        vntJudClassCd) = False Then
'''''        If objJudCmtStc.SelectJudCmtStc(mstrJudCmtCd, _
'''''                                        vntJudCmtStc, _
'''''                                        vntJudClassCd) = False Then
''''' ****************2004/08/24 FJTH)M<E �p��R�����g�p�@�ǉ�  - E ****************************
'''        If objJudCmtStc.SelectJudCmtStcnew(mstrJudCmtCd, _
'''                                        vntJudCmtStc, _
'''                                        vntJudCmtStc_e, _
'''                                        vntJudClassCd, _
'''                                        , , , , _
'''                                        vntHihyouji, _
'''                                        vntRecogLevel1, _
'''                                        vntRecogLevel2, _
'''                                        vntRecogLevel3, _
'''                                        vntRecogLevel4, _
'''                                        vntRecogLevel5 _
'''                                        ) = False Then
''''### 2004/11/15 Add End
        If objJudCmtStc.SelectJudCmtStcnew(mstrJudCmtCd _
                                      , vntJudCmtStc _
                                      , vntJudCmtStc_e _
                                      , vntJudClassCd _
                                      , , , , _
                                      , vntHihyouji _
                                      , vntRecogLevel1 _
                                      , vntRecogLevel2 _
                                      , vntRecogLevel3 _
                                      , vntRecogLevel4 _
                                      , vntRecogLevel5 _
                                      , vntOutPriority _
                                        ) = False Then
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtJudCmtCd.Text = mstrJudCmtCd
        txtJudCmtStc.Text = vntJudCmtStc
' ****************2004/08/24 FJTH)M<E �p��R�����g�p�@�ǉ�  - S ****************************
        txtJudCmtStc1.Text = vntJudCmtStc_e
' ****************2004/08/24 FJTH)M<E �p��R�����g�p�@�ǉ�  - E ****************************

'### 2004/11/15 Add by Gouda@FSIT �����w���R�����g�̕\������
        If vntHihyouji = 1 Then
            chkHihyouji.Value = vbChecked
        End If
        If vntRecogLevel1 = 1 Then
            chkRecogLevel(0).Value = vbChecked
        End If
        If vntRecogLevel2 = 1 Then
            chkRecogLevel(1).Value = vbChecked
        End If
        If vntRecogLevel3 = 1 Then
            chkRecogLevel(2).Value = vbChecked
        End If
        If vntRecogLevel4 = 1 Then
            chkRecogLevel(3).Value = vbChecked
        End If
        If vntRecogLevel5 = 1 Then
            chkRecogLevel(4).Value = vbChecked
        End If
'### 2004/11/15 Add End
        
        '���蕪�ނ̃Z�b�g
        If vntJudClassCd <> "" Then
            '�ޔ�z�񂩂�L�[������
            For i = 0 To UBound(mstrArrJudClassCd)
                If mstrArrJudClassCd(i) = vntJudClassCd Then
                    cboJudClass.ListIndex = i
                End If
            Next i
        End If
    
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
        '�o�͏��̃Z�b�g
        If vntOutPriority <> "" Then
            '�ޔ�z�񂩂�L�[������
            For i = 0 To UBound(mstrArrOutPriority)
                If mstrArrOutPriority(i) = vntOutPriority Then
                    cboOutPriority.ListIndex = i
                End If
            Next i
        End If
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditJudCmtStc = Ret
    
    Exit Function

ErrorHandle:

    EditJudCmtStc = False
    MsgBox Err.Description, vbCritical

    Exit Function
    
    Resume
    
End Function

'
' �@�\�@�@ : �f�[�^�o�^
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function RegistJudCmtStc() As Boolean

'On Error GoTo ErrorHandle

    Dim objJudCmtStc    As Object       '����R�����g�A�N�Z�X�p
    Dim Ret             As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    '����R�����g�e�[�u�����R�[�h�̓o�^
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'
''''### 2004/11/15 Add by Gouda@FSIT �����w���R�����g�̕\������
'''    '����R�����g�e�[�u�����R�[�h�̓o�^
''''    Ret = objJudCmtStc.RegistJudCmtStc1(IIf(txtJudCmtCd.Enabled, "INS", "UPD"), _
''''                                       Trim(txtJudCmtCd.Text), _
''''                                       Trim(txtJudCmtStc.Text), _
''''                                       Trim(txtJudCmtStc1.Text), _
''''                                       mstrArrJudClassCd(cboJudClass.ListIndex))
'''
'''    Ret = objJudCmtStc.RegistJudCmtStc1(IIf(txtJudCmtCd.Enabled, "INS", "UPD"), _
'''                                       Trim(txtJudCmtCd.Text), _
'''                                       Trim(txtJudCmtStc.Text), _
'''                                       Trim(txtJudCmtStc1.Text), _
'''                                       mstrArrJudClassCd(cboJudClass.ListIndex), _
'''                                       IIf(chkHihyouji.Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(0).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(1).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(2).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(3).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(4).Value = vbChecked, 1, ""))
''''### 2004/11/15 Add End
    Ret = objJudCmtStc.RegistJudCmtStc1(IIf(txtJudCmtCd.Enabled, "INS", "UPD") _
                                     , Trim(txtJudCmtCd.Text) _
                                     , Trim(txtJudCmtStc.Text) _
                                     , Trim(txtJudCmtStc1.Text) _
                                     , mstrArrJudClassCd(cboJudClass.ListIndex) _
                                     , IIf(chkHihyouji.Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(0).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(1).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(2).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(3).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(4).Value = vbChecked, 1, "") _
                                     , mstrArrOutPriority(cboOutPriority.ListIndex) _
                                     )
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

    If Ret = 0 Then
        MsgBox "���͂��ꂽ����R�����g�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistJudCmtStc = False
        Exit Function
    End If
    
    RegistJudCmtStc = True
    
    Exit Function
    
'ErrorHandle:
'
'    RegistJudCmtStc = False
'    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �u�L�����Z���vClick
'
' �@�\���� : �t�H�[�������
'
' ���l�@�@ :
'
Private Sub CMDcancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�n�j�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p���A��ʂ����
'
' ���l�@�@ :
'
Private Sub CMDok_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    Do
        '���̓`�F�b�N
        If CheckValue() = False Then
            Exit Do
        End If
        
        '����R�����g�e�[�u���̓o�^
        If RegistJudCmtStc() = False Then
            Exit Do
        End If
            
        '�X�V�ς݃t���O��TRUE��
        mblnUpdated = True
    
        '��ʂ����
        Unload Me
        
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�t�H�[���vLoad
'
' �@�\���� : �t�H�[���̏����\�����s��
'
' ���l�@�@ :
'
Private Sub Form_Load()

    Dim Ret As Boolean  '�߂�l
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        '���蕪�ރR���{�̕ҏW
        If EditJudClass() = False Then
            Exit Do
        End If
        
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
        '�o�͏��敪���̕ҏW
        If EditOutPriority() = False Then
            Exit Do
        End If
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
        
        '����R�����g���̕ҏW
        If EditJudCmtStc() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtJudCmtCd.Enabled = (txtJudCmtCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

