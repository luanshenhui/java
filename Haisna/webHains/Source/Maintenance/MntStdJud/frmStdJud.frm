VERSION 5.00
Begin VB.Form frmStdJud 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "��^�����e�[�u�������e�i���X"
   ClientHeight    =   1800
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5970
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmStdJud.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1800
   ScaleWidth      =   5970
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmStdJud.frx":000C
      Left            =   1680
      List            =   "frmStdJud.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   1
      Top             =   120
      Width           =   4050
   End
   Begin VB.TextBox txtStdJudNote 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   25
      TabIndex        =   5
      Text            =   "��������"
      Top             =   840
      Width           =   4035
   End
   Begin VB.TextBox txtStdJudCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "@@"
      Top             =   480
      Width           =   435
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2940
      TabIndex        =   6
      Top             =   1260
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4380
      TabIndex        =   7
      Top             =   1260
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "���蕪��(&J):"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "��^�������e(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "��^�����R�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
End
Attribute VB_Name = "frmStdJud"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mintJudClassCd      As Integer  '���蕪�ރR�[�h
Private mintStdJudCd        As Integer  '��^�����R�[�h

Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mintArrJudClassCd() As Integer  '���蕪�ރR���{�ɑΉ����锻�蕪�ރR�[�h

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let JudClassCd(ByVal vntNewValue As Integer)

    mintJudClassCd = vntNewValue
    
End Property

Friend Property Let StdJudCd(ByVal vntNewValue As Integer)

    mintStdJudCd = vntNewValue
    
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
        If Trim(txtStdJudCd.Text) = "" Then
            MsgBox "��^�����R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtStdJudCd.SetFocus
            Exit Do
        End If

        '�R�[�h�̐��l�`�F�b�N
        If IsNumeric(txtStdJudCd.Text) = False Then
            MsgBox "��^�����R�[�h�ɂ͐��l����͂��Ă��������B", vbCritical, App.Title
            txtStdJudCd.SetFocus
            Exit Do
        End If

        '�R�[�h�̐��l�`�F�b�N�Q
        If CInt(txtStdJudCd.Text) < 1 Then
            MsgBox "��^�����R�[�h�ɂ͕����A�[�����w�肷�邱�Ƃ͂ł��܂���B", vbCritical, App.Title
            txtStdJudCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtStdJudNote.Text) = "" Then
            MsgBox "��^�����������͂���Ă��܂���B", vbCritical, App.Title
            txtStdJudNote.SetFocus
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
Private Function EditStdJud() As Boolean

    Dim objStdJud       As Object           '��^�����A�N�Z�X�p
    Dim vntStdJudNote   As Variant          '��^������
    Dim vntEntryOk      As Variant          '���͊����t���O
    Dim Ret             As Boolean          '�߂�l
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdJud = CreateObject("HainsStdJud.StdJud")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mintStdJudCd = 0 Then
            Ret = True
            Exit Do
        End If
        
        '��^�����e�[�u�����R�[�h�ǂݍ���
        If objStdJud.SelectStdJud(mintJudClassCd, mintStdJudCd, vntStdJudNote) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtStdJudCd.Text = mintStdJudCd
        txtStdJudNote.Text = vntStdJudNote
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditStdJud = Ret
    
    Exit Function

ErrorHandle:

    EditStdJud = False
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
Private Function RegistStdJud() As Boolean

On Error GoTo ErrorHandle

    Dim objStdJud   As Object       '��^�����A�N�Z�X�p
    Dim Ret         As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdJud = CreateObject("HainsStdJud.StdJud")
    
    '��^�����e�[�u�����R�[�h�̓o�^
    Ret = objStdJud.RegistStdJud(IIf(txtStdJudCd.Enabled, "INS", "UPD"), _
                                 mintArrJudClassCd(cboJudClass.ListIndex), _
                                 Trim(txtStdJudCd.Text), _
                                 Trim(txtStdJudNote.Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ��^�����R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistStdJud = False
        Exit Function
    End If
    
    RegistStdJud = True
    
    Exit Function
    
ErrorHandle:

    RegistStdJud = False
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
        
        '��^�����e�[�u���̓o�^
        If RegistStdJud() = False Then
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
        '���蕪�ޏ��̉�ʃZ�b�g
        If SetJudClass() < 1 Then
            MsgBox "���蕪�ނ�����o�^����Ă��܂���B���蕪�ނ�o�^���Ă���ēx���̏������s���Ă��������B", vbExclamation
            cmdOk.Enabled = False
            Exit Do
        End If
        
        '��^�������̕ҏW
        If EditStdJud() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtStdJudCd.Enabled = (txtStdJudCd.Text = "")
        cboJudClass.Enabled = (txtStdJudCd.Text = "")
        
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
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mintArrJudClassCd(i)
        mintArrJudClassCd(i) = vntJudClassCd(i)
        cboJudClass.AddItem vntJudClassName(i)
        If vntJudClassCd(i) = mintJudClassCd Then
            intTargetIndex = i
        End If
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objJudClass = Nothing
    
    If lngCount > 0 Then
        cboJudClass.ListIndex = intTargetIndex
    End If
    
    SetJudClass = lngCount
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

