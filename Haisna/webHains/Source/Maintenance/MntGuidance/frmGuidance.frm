VERSION 5.00
Begin VB.Form frmGuidance 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�w�����e�e�[�u�������e�i���X"
   ClientHeight    =   2895
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7500
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmGuidance.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2895
   ScaleWidth      =   7500
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmGuidance.frx":000C
      Left            =   1680
      List            =   "frmGuidance.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   5
      Top             =   1980
      Width           =   4050
   End
   Begin VB.TextBox txtGuidanceStc 
      Height          =   1440
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   250
      MultiLine       =   -1  'True
      TabIndex        =   3
      Text            =   "frmGuidance.frx":0050
      Top             =   480
      Width           =   5715
   End
   Begin VB.TextBox txtGuidanceCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   8
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   1455
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4620
      TabIndex        =   6
      Top             =   2460
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6060
      TabIndex        =   7
      Top             =   2460
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "���蕪��(&J):"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   4
      Top             =   2040
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "�w�����e(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�w�����e�R�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmGuidance"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrJudClassCd      As String  '���蕪�ރR�[�h
Private mstrGuidanceCd      As String   '�w�����e�R�[�h

Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrArrJudClassCd() As String  '���蕪�ރR���{�ɑΉ����锻�蕪�ރR�[�h

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let JudClassCd(ByVal vntNewValue As Integer)

    mstrJudClassCd = vntNewValue
    
End Property

Friend Property Let GuidanceCd(ByVal vntNewValue As String)

    mstrGuidanceCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

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
    
    Ret = False
    
    Do
        '�R�[�h�̓��̓`�F�b�N
        If Trim(txtGuidanceCd.Text) = "" Then
            MsgBox "�w�����e�R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtGuidanceCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtGuidanceStc.Text) = "" Then
            MsgBox "�w�����e�������͂���Ă��܂���B", vbCritical, App.Title
            txtGuidanceStc.SetFocus
            Exit Do
        End If

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
Private Function EditGuidance() As Boolean

    Dim objGuidance         As Object           '�w�����e�A�N�Z�X�p
    Dim vntGuidanceStc      As Variant          '�w�����e��
    Dim vntJudClassCd       As Variant          '�w�����e��
    Dim vntEntryOk          As Variant          '���͊����t���O
    Dim Ret                 As Boolean          '�߂�l
    Dim i                   As Integer
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGuidance = CreateObject("HainsGuidance.Guidance")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If Trim(mstrGuidanceCd) = "" Then
            Ret = True
            Exit Do
        End If
        
        '�w�����e�e�[�u�����R�[�h�ǂݍ���
'### 2003.01.17 Updated by Ishihara@FSIT ���蕪�ނ�NULL����
'        If objGuidance.SelectGuidance(mstrGuidanceCd, vntGuidanceStc, CInt(vntJudClassCd)) = False Then
        If objGuidance.SelectGuidance(mstrGuidanceCd, vntGuidanceStc, vntJudClassCd) = False Then
'### 2003.01.17 Updated End
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtGuidanceCd.Text = mstrGuidanceCd
        txtGuidanceStc.Text = vntGuidanceStc
'### 2003.01.17 Updated by Ishihara@FSIT ���蕪�ނ�NULL����
'        mstrJudClassCd = CInt(vntJudClassCd)
        mstrJudClassCd = vntJudClassCd
'### 2003.01.17 Updated End
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditGuidance = Ret
    
    Exit Function

ErrorHandle:

    EditGuidance = False
    MsgBox Err.Description, vbCritical
    
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
Private Function RegistGuidance() As Boolean

On Error GoTo ErrorHandle

    Dim objGuidance   As Object       '�w�����e�A�N�Z�X�p
    Dim Ret         As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGuidance = CreateObject("HainsGuidance.Guidance")
    
    '�w�����e�e�[�u�����R�[�h�̓o�^
    Ret = objGuidance.RegistGuidance(IIf(txtGuidanceCd.Enabled, "INS", "UPD"), _
                                 Trim(txtGuidanceCd.Text), _
                                 Trim(txtGuidanceStc.Text), _
                                 mstrArrJudClassCd(cboJudClass.ListIndex))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�w�����e�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistGuidance = False
        Exit Function
    End If
    
    RegistGuidance = True
    
    Exit Function
    
ErrorHandle:

    RegistGuidance = False
    MsgBox Err.Description, vbCritical
    
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
        
        '�w�����e�e�[�u���̓o�^
        If RegistGuidance() = False Then
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
        
        '�w�����e���̕ҏW
        If EditGuidance() = False Then
            Exit Do
        End If
    
        '���蕪�ޏ��̉�ʃZ�b�g
        If SetJudClass() < 1 Then
            MsgBox "���蕪�ނ�����o�^����Ă��܂���B���蕪�ނ�o�^���Ă���ēx���̏������s���Ă��������B", vbExclamation
            cmdOk.Enabled = False
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtGuidanceCd.Enabled = (txtGuidanceCd.Text = "")
'        cboJudClass.Enabled = (txtGuidanceCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

'
' �@�\�@�@ : ���蕪�ރR���{�Z�b�g
'
' �����@�@ :
'
' �߂�l�@ : ���蕪�ޓo�^��
'
' ���l�@�@ :
'
Private Function SetJudClass() As Long

On Error GoTo ErrorHandle

    Dim objJudClass     As Object           '���ʃR�����g�A�N�Z�X�p
    Dim vntJudClassCd   As Variant          '���ʃR�����g�R�[�h
    Dim vntJudClassName As Variant          '���ʃR�����g��
    Dim lngCount        As Long             '���R�[�h��
    Dim i               As Long             '�C���f�b�N�X
    Dim intTargetIndex  As Integer
    
    SetJudClass = 0
    intTargetIndex = 0
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)
    
    cboJudClass.Clear
    
'### 2003.01.17 Updated by Ishihara@FSIT ���蕪�ނ�NULL����
    '���蕪�ނ�Null����
    i = 0
    ReDim Preserve mstrArrJudClassCd(i)
    mstrArrJudClassCd(i) = ""
    cboJudClass.AddItem ""
'### 2003.01.17 Updated End
    
    '���X�g�̕ҏW
    For i = 1 To lngCount - 1
        ReDim Preserve mstrArrJudClassCd(i)
        mstrArrJudClassCd(i) = vntJudClassCd(i)
        cboJudClass.AddItem vntJudClassName(i)
        If vntJudClassCd(i) = mstrJudClassCd Then
            intTargetIndex = i
        End If
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objJudClass = Nothing
    
    If lngCount > 1 Then
        cboJudClass.ListIndex = intTargetIndex
    End If
    
    SetJudClass = lngCount
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

