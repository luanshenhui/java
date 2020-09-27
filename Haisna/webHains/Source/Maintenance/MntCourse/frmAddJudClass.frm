VERSION 5.00
Begin VB.Form frmAddJudClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���蕪�ނ̒ǉ�"
   ClientHeight    =   1680
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6195
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmAddJudClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1680
   ScaleWidth      =   6195
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.CheckBox chkNoReason 
      Caption         =   "���̔��蕪�ނ͎�f�������ڂ̓��e�Ɋւ�炸�W�J����(&C)"
      Height          =   375
      Left            =   1260
      TabIndex        =   4
      Top             =   540
      Width           =   4695
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4740
      TabIndex        =   3
      Top             =   1200
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3360
      TabIndex        =   2
      Top             =   1200
      Width           =   1275
   End
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmAddJudClass.frx":000C
      Left            =   1260
      List            =   "frmAddJudClass.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   0
      Top             =   180
      Width           =   4770
   End
   Begin VB.Label Label8 
      Caption         =   "���蕪��(&J):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   1
      Top             =   240
      Width           =   1095
   End
End
Attribute VB_Name = "frmAddJudClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mblnUpdate          As Boolean  'TRUE:�X�V���܂����AFALSE:���X�V
Private mintJudClassCd      As Integer  '���蕪�ރR�[�h
Private mstrJudClassName    As String   '���蕪�ޖ�
Private mintNoReason        As Integer  '�������W�J�t���O�i0:�W�J���Ȃ��A1:�W�J����j

'���蕪�ރR���{�Ή��f�[�^�ޔ�p
Private mintArrJudClassCd() As Integer  '���蕪�ރR���{�ɑΉ����锻�蕪�ރR�[�h

Friend Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property


Private Sub cmdCancel_Click()

    Unload Me

End Sub


Private Sub cmdOk_Click()

    '���݂̒l��Ԃ��Z�b�g
    mintJudClassCd = mintArrJudClassCd(cboJudClass.ListIndex)
    mstrJudClassName = cboJudClass.List(cboJudClass.ListIndex)
    mintNoReason = IIf(chkNoReason.Value = vbChecked, 1, 0)
    
    '�X�V��ԂƂ���
    mblnUpdate = True
    
    Unload Me

End Sub

Private Sub Form_Load()

    '�ϐ�������
    cboJudClass.Clear
    chkNoReason.Value = vbUnchecked
    mblnUpdate = False
    

    '���蕪�ޏ��̉�ʃZ�b�g
    If SetJudClass() < 1 Then
        MsgBox "���蕪�ނ�����o�^����Ă��܂���B���蕪�ނ�o�^���Ă���ēx���̏������s���Ă��������B", vbExclamation
        cmdOk.Enabled = False
    End If
    
    '�������W�J�t���O�̃Z�b�g
    If mintNoReason = 1 Then
        chkNoReason.Value = vbChecked
    End If
    
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

Friend Property Get NoReason() As Integer

    NoReason = mintNoReason

End Property
Friend Property Let NoReason(ByVal vNewValue As Integer)

    mintNoReason = vNewValue
    
End Property

Friend Property Get JudClassCd() As Integer

    JudClassCd = mintJudClassCd
    
End Property

Friend Property Let JudClassCd(ByVal vNewValue As Integer)

    mintJudClassCd = vNewValue
    
End Property

Friend Property Get JudClassName() As Variant

    JudClassName = mstrJudClassName

End Property


