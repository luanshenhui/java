VERSION 5.00
Begin VB.Form frmPubNoteDiv 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�R�����g���ރe�[�u�������e�i���X"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6480
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmPubNoteDiv.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   6480
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboOnlyDispKbn 
      Height          =   300
      Left            =   2100
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   9
      Top             =   1260
      Width           =   3315
   End
   Begin VB.ComboBox cboDefaultDispKbn 
      Height          =   300
      Left            =   2100
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   8
      Top             =   900
      Width           =   3315
   End
   Begin VB.TextBox txtPubNoteDivName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   2100
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "��������������������"
      Top             =   540
      Width           =   3315
   End
   Begin VB.TextBox txtPubNoteDivCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   2100
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   180
      Width           =   555
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3540
      TabIndex        =   6
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4980
      TabIndex        =   7
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "����(&O)"
      Height          =   180
      Index           =   3
      Left            =   300
      TabIndex        =   5
      Top             =   1320
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�����l(&R)"
      Height          =   180
      Index           =   2
      Left            =   300
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�R�����g���ޖ�(&N)"
      Height          =   180
      Index           =   1
      Left            =   300
      TabIndex        =   2
      Top             =   600
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�R�����g���ރR�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   300
      TabIndex        =   0
      Top             =   240
      Width           =   1650
   End
End
Attribute VB_Name = "frmPubNoteDiv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================
'�Ǘ��ԍ��FSL-HS-Y0101-001
'���۔ԍ��FCOMP-LUKES-0025�i��݊����؁j
'�C����  �F2010.07.16
'�S����  �FFJTH)KOMURO
'�C�����e�F�R�����g���ޖ��̌��������ύX
'========================================
Option Explicit

Private mstrPubNoteDivCd  As String   '�R�����g���ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let PubNoteDivCd(ByVal vntNewValue As Variant)

    mstrPubNoteDivCd = vntNewValue
    
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
        If Trim(txtPubNoteDivCd.Text) = "" Then
            MsgBox "�R�����g���ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtPubNoteDivCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtPubNoteDivName.Text) = "" Then
            MsgBox "�R�����g���ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtPubNoteDivName.SetFocus
            Exit Do
        End If

        '�������`�F�b�N�P
        If (cboOnlyDispKbn.ListIndex = 1) And (cboDefaultDispKbn.ListIndex = 1) Then
            MsgBox "��Ð�p�R�����g�ɂ��ւ�炸�A�f�t�H���g���u�����v�ɂȂ��Ă��܂��B", vbCritical, App.Title
            cboOnlyDispKbn.SetFocus
            Exit Do
        End If
        
        '�������`�F�b�N�Q
        If (cboOnlyDispKbn.ListIndex = 2) And (cboDefaultDispKbn.ListIndex = 0) Then
            MsgBox "������p�R�����g�ɂ��ւ�炸�A�f�t�H���g���u��Áv�ɂȂ��Ă��܂��B", vbCritical, App.Title
            cboOnlyDispKbn.SetFocus
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
Private Function EditPubNoteDiv() As Boolean

    Dim objPubNoteDiv         As Object         '�R�����g���ރA�N�Z�X�p
    Dim vntPubNoteDivName     As Variant        '�R�����g���ޖ�
    Dim vntDefaultDispKbn    As Variant        '�R�����g���ޗ���
    Dim vntOnlyDispKbn              As Variant        '�\������
    Dim Ret                 As Boolean        '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPubNoteDiv = CreateObject("HainsPubNote.PubNote")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrPubNoteDivCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�R�����g���ރe�[�u�����R�[�h�ǂݍ���
        If objPubNoteDiv.SelectPubNoteDiv(mstrPubNoteDivCd, vntPubNoteDivName, vntDefaultDispKbn, vntOnlyDispKbn) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtPubNoteDivCd.Text = mstrPubNoteDivCd
        txtPubNoteDivName.Text = vntPubNoteDivName
        cboDefaultDispKbn.ListIndex = CInt(vntDefaultDispKbn) - 1
        
        cboOnlyDispKbn.ListIndex = 0
        
        If IsNumeric(vntOnlyDispKbn) Then
            cboOnlyDispKbn.ListIndex = CInt(vntOnlyDispKbn)
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditPubNoteDiv = Ret
    
    Exit Function

ErrorHandle:

    EditPubNoteDiv = False
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
Private Function RegistPubNoteDiv() As Boolean

On Error GoTo ErrorHandle

    Dim objPubNoteDiv     As Object       '�R�����g���ރA�N�Z�X�p
    Dim Ret             As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPubNoteDiv = CreateObject("HainsPubNote.PubNote")
    
    '�R�����g���ރe�[�u�����R�[�h�̓o�^
    Ret = objPubNoteDiv.RegistPubNoteDiv(IIf(txtPubNoteDivCd.Enabled, "INS", "UPD"), _
                                     Trim(txtPubNoteDivCd.Text), _
                                     Trim(txtPubNoteDivName.Text), _
                                     cboDefaultDispKbn.ListIndex + 1, _
                                     IIf(cboOnlyDispKbn.ListIndex = 0, "", cboOnlyDispKbn.ListIndex))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�R�����g���ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistPubNoteDiv = False
        Exit Function
    End If
    
    RegistPubNoteDiv = True
    
    Set objPubNoteDiv = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPubNoteDiv = Nothing
    
    RegistPubNoteDiv = False
    
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
        
        '�R�����g���ރe�[�u���̓o�^
        If RegistPubNoteDiv() = False Then
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

    With cboDefaultDispKbn
        .Clear
        .AddItem "��Ï���I����Ԃɂ��܂��B"
        .AddItem "��������I����Ԃɂ��܂��B"
        .AddItem "���ʂ�I����Ԃɂ��܂��B"
        .ListIndex = 2
    End With

    With cboOnlyDispKbn
        .Clear
        .AddItem ""
        .AddItem "���̕��ނ͈�Ï���p�ł��B"
        .AddItem "���̕��ނ͎�������p�ł��B"
        .ListIndex = 0
    End With

    Do
        '�R�����g���ޏ��̕ҏW
        If EditPubNoteDiv() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtPubNoteDivCd.Enabled = (txtPubNoteDivCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

