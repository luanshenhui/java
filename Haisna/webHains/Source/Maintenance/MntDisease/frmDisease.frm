VERSION 5.00
Begin VB.Form frmDisease 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�a���e�[�u�������e�i���X"
   ClientHeight    =   2340
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6885
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmDisease.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2340
   ScaleWidth      =   6885
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboDisDiv 
      Height          =   300
      ItemData        =   "frmDisease.frx":000C
      Left            =   1680
      List            =   "frmDisease.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   7
      Top             =   1200
      Width           =   4665
   End
   Begin VB.ComboBox cboSearchChar 
      Height          =   300
      ItemData        =   "frmDisease.frx":0050
      Left            =   1680
      List            =   "frmDisease.frx":0072
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   5
      Top             =   840
      Width           =   810
   End
   Begin VB.TextBox txtDisName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   25
      TabIndex        =   3
      Text            =   "��������������������������������������������������"
      Top             =   480
      Width           =   4875
   End
   Begin VB.TextBox txtDisCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   9
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   1035
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3840
      TabIndex        =   8
      Top             =   1860
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5280
      TabIndex        =   9
      Top             =   1860
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�a��(&R):"
      Height          =   180
      Index           =   4
      Left            =   120
      TabIndex        =   6
      Top             =   1260
      Width           =   1350
   End
   Begin VB.Label Label3 
      Caption         =   "�����p������(&S):"
      Height          =   195
      Index           =   2
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   1395
   End
   Begin VB.Label Label1 
      Caption         =   "�a��(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�a���R�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmDisease"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrDisCd           As String   '�a���R�[�h
Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mstrDisDivCd()      As String   '�R���{�{�b�N�X�ɑΉ�����a�ރR�[�h�̊i�[

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let DisCd(ByVal vntNewValue As Variant)

    mstrDisCd = vntNewValue
    
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
        If Trim(txtDisCd.Text) = "" Then
            MsgBox "�a���R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtDisCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtDisName.Text) = "" Then
            MsgBox "�a���������͂���Ă��܂���B", vbCritical, App.Title
            txtDisName.SetFocus
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
Private Function EditDisDiv() As Boolean

    Dim objDisease      As Object           '�a���A�N�Z�X�p
    Dim vntDisName      As Variant          '�a��
    Dim vntSearchChar   As Variant          '�K�C�h�����p������
    Dim vntDisDivCd     As Variant          '�a�ރR�[�h
    Dim Ret             As Boolean          '�߂�l
    Dim i               As Integer
    
    Dim lngCount        As Long
    Dim vntDisDivCdList As Variant          '�a�ރR�[�h
    Dim vntDisDivName   As Variant          '�a�ޖ�
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDisease = CreateObject("HainsDisease.Disease")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrDisCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�a���e�[�u�����R�[�h�ǂݍ���
        If objDisease.SelectDisease(mstrDisCd, vntDisName, vntSearchChar, vntDisDivCd) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtDisCd.Text = mstrDisCd
        txtDisName.Text = vntDisName
    
        '����������R���{�̐ݒ�
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    cboDisDiv.Clear
    Erase mstrDisDivCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    lngCount = objDisease.SelectDisDivList(vntDisDivCdList, vntDisDivName)
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrDisDivCd(i)
        mstrDisDivCd(i) = vntDisDivCdList(i)
        cboDisDiv.AddItem vntDisDivName(i)
        If vntDisDivCd = vntDisDivCdList(i) Then
            cboDisDiv.ListIndex = i
        End If
    Next i
    
    '�f�[�^�����݂��Ȃ��Ȃ�A�G���[
    If lngCount <= 0 Then
        MsgBox "�a�ނ����݂��܂���B�a�ރf�[�^��o�^���Ȃ��ƕa���ݒ���s�����Ƃ͂ł��܂���B", vbExclamation
        Exit Function
    End If
    
    '�߂�l�̐ݒ�
    EditDisDiv = Ret
    
    Exit Function

ErrorHandle:

    EditDisDiv = False
    
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
Private Function RegistDisDiv() As Boolean

    Dim objDisease       As Object       '�a���A�N�Z�X�p
    Dim Ret             As Long
    Dim strSearchChar   As String
    
    On Error GoTo ErrorHandle
    
    '�K�C�h����������̍ĕҏW
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "���̑�" Then
        strSearchChar = "*"
    End If
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDisease = CreateObject("HainsDisease.Disease")
    
    '�a���e�[�u�����R�[�h�̓o�^
    Ret = objDisease.RegistDisease(IIf(txtDisCd.Enabled, "INS", "UPD"), _
                                   Trim(txtDisCd.Text), _
                                   Trim(txtDisName.Text), _
                                   strSearchChar, _
                                   mstrDisDivCd(cboDisDiv.ListIndex))
    
    If Ret = 0 Then
        MsgBox "���͂��ꂽ�a���R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistDisDiv = False
        Exit Function
    End If
    
    RegistDisDiv = True
    
    Exit Function
    
ErrorHandle:

    RegistDisDiv = False
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
        
        '�a���e�[�u���̓o�^
        If RegistDisDiv() = False Then
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

    '����������R���{������
    Call InitSearchCharCombo(cboSearchChar)

    Do
        '�a�����̕ҏW
        If EditDisDiv() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtDisCd.Enabled = (txtDisCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
