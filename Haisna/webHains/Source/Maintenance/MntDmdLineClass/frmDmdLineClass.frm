VERSION 5.00
Begin VB.Form frmDmdLineClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�������ו��ރe�[�u�������e�i���X"
   ClientHeight    =   3600
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6690
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmDmdLineClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3600
   ScaleWidth      =   6690
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.Frame Frame1 
      Caption         =   "��{���"
      Height          =   2775
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   180
      Width           =   6315
      Begin VB.ComboBox cboMakeBillLine 
         Height          =   300
         ItemData        =   "frmDmdLineClass.frx":000C
         Left            =   2040
         List            =   "frmDmdLineClass.frx":002E
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   11
         Top             =   1800
         Width           =   4110
      End
      Begin VB.ComboBox cboIsrFlg 
         Height          =   300
         ItemData        =   "frmDmdLineClass.frx":0050
         Left            =   2040
         List            =   "frmDmdLineClass.frx":0072
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   9
         Top             =   1380
         Width           =   4110
      End
      Begin VB.CheckBox chkSumDetails 
         Caption         =   "���f��{���Ƃ��Ă܂Ƃ߂�(&R)"
         Height          =   255
         Left            =   2040
         TabIndex        =   8
         Top             =   960
         Width           =   2655
      End
      Begin VB.TextBox txtDmdLineClassName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   2040
         MaxLength       =   15
         TabIndex        =   3
         Text            =   "������������������������������"
         Top             =   600
         Width           =   3075
      End
      Begin VB.TextBox txtDmdLineClassCd 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2040
         MaxLength       =   3
         TabIndex        =   1
         Text            =   "@@"
         Top             =   240
         Width           =   495
      End
      Begin VB.Label Label1 
         Caption         =   "���������׍쐬(&S):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   10
         Top             =   1860
         Width           =   1710
      End
      Begin VB.Label Label1 
         Caption         =   "���ێg�p����(&W):"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   4
         Top             =   1440
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "�������ו��ޖ�(&N):"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   2
         Top             =   660
         Width           =   1590
      End
      Begin VB.Label Label1 
         Caption         =   "�������ו��ރR�[�h(&C):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   300
         Width           =   1830
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3780
      TabIndex        =   5
      Top             =   3120
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5220
      TabIndex        =   6
      Top             =   3120
      Width           =   1335
   End
End
Attribute VB_Name = "frmDmdLineClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrDmdLineClassCd      As String   '�������ו��ރR�[�h
Private mblnInitialize          As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let DmdLineClassCd(ByVal vntNewValue As Variant)

    mstrDmdLineClassCd = vntNewValue
    
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
        If Trim(txtDmdLineClassCd.Text) = "" Then
            MsgBox "�������ו��ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtDmdLineClassCd.SetFocus
            Exit Do
        End If

        '�񍐏��p�������ו��ޖ��̓��̓`�F�b�N
        If Trim(txtDmdLineClassName.Text) = "" Then
            MsgBox "�񍐏��p�������ו��ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtDmdLineClassName.SetFocus
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
Private Function EditDmdLineClass() As Boolean

    Dim objDmdLineClass         As Object   '�������ו��ރA�N�Z�X�p
    Dim vntDmdLineClassName     As Variant  '�񍐏��p�������ו��ޖ�
    Dim vntSumDetails           As Variant  '�������ו��ޗp���f��{���W�v�t���O
    Dim vntIsrFlg               As Variant  '���ێg�p�t���O
    Dim vntMakeBillLine         As Variant  '���������׍쐬�t���O
    Dim Ret                     As Boolean  '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrDmdLineClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�������ו��ރe�[�u�����R�[�h�ǂݍ���
        If objDmdLineClass.SelectDmdLineClass(mstrDmdLineClassCd, vntDmdLineClassName, vntSumDetails, vntIsrFlg, vntMakeBillLine) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtDmdLineClassCd.Text = mstrDmdLineClassCd
        txtDmdLineClassName.Text = vntDmdLineClassName
        If vntSumDetails = "1" Then
            chkSumDetails.Value = vbChecked
        End If
        
        Select Case Trim(vntIsrFlg)
            Case ""
                cboIsrFlg.ListIndex = 0
            Case "0"
                cboIsrFlg.ListIndex = 1
            Case "1"
                cboIsrFlg.ListIndex = 2
        End Select
        
        cboMakeBillLine.ListIndex = CInt(vntMakeBillLine)
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditDmdLineClass = Ret
    
    Exit Function

ErrorHandle:

    EditDmdLineClass = False
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
Private Function RegistDmdLineClass() As Boolean

On Error GoTo ErrorHandle

    Dim objDmdLineClass     As Object       '�������ו��ރA�N�Z�X�p
    Dim Ret                 As Long
    Dim strWkIsrFlg         As String
    
    If cboIsrFlg.ListIndex = 0 Then
        strWkIsrFlg = ""
    Else
        strWkIsrFlg = cboIsrFlg.ListIndex - 1
    End If
    

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    
    '�������ו��ރe�[�u�����R�[�h�̓o�^
    Ret = objDmdLineClass.RegistDmdLineClass(IIf(txtDmdLineClassCd.Enabled, "INS", "UPD"), _
                                             Trim(txtDmdLineClassCd.Text), _
                                             Trim(txtDmdLineClassName.Text), _
                                             IIf(chkSumDetails.Value = vbChecked, "1", ""), _
                                             strWkIsrFlg, _
                                             cboMakeBillLine.ListIndex)

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�������ו��ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistDmdLineClass = False
        Exit Function
    End If
    
    RegistDmdLineClass = True
    
    Exit Function
    
ErrorHandle:

    RegistDmdLineClass = False
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
        
        '�������ו��ރe�[�u���̓o�^
        If RegistDmdLineClass() = False Then
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

    Dim Ret     As Boolean  '�߂�l
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    cboIsrFlg.Clear
    cboIsrFlg.AddItem "�����ނ́A���ۂł���ʒc�̂ł��g�p����"
    cboIsrFlg.AddItem "�����ނ́A��ʒc�̂̂ݎg�p����"
    cboIsrFlg.AddItem "�����ނ́A���ۂ̂ݎg�p����"
    cboIsrFlg.ListIndex = 0
    
    cboMakeBillLine.Clear
    cboMakeBillLine.AddItem "�����ނŐ��������ׂ��쐬����"
    cboMakeBillLine.AddItem "�����ނŐ��������ׂ��쐬���Ȃ�"
    cboMakeBillLine.ListIndex = 0

    Do
        '�������ו��ޏ��̕ҏW
        If EditDmdLineClass() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtDmdLineClassCd.Enabled = (txtDmdLineClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
