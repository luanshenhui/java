VERSION 5.00
Begin VB.Form frmMailTemplate 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���[���e���v���[�g�e�[�u�������e�i���X"
   ClientHeight    =   9225
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10350
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMailTemplate.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   9225
   ScaleWidth      =   10350
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtTemplateCd 
      BeginProperty Font 
         Name            =   "�l�r �S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1020
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.TextBox txtSubject 
      BeginProperty Font 
         Name            =   "�l�r �S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1020
      MaxLength       =   50
      TabIndex        =   5
      Text            =   "����������������������������������������������������������������������������������������������������"
      Top             =   840
      Width           =   9195
   End
   Begin VB.TextBox txtBody 
      BeginProperty Font 
         Name            =   "�l�r �S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7500
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1020
      MultiLine       =   -1  'True
      ScrollBars      =   2  '����
      TabIndex        =   7
      Top             =   1200
      Width           =   9195
   End
   Begin VB.TextBox txtTemplateName 
      BeginProperty Font 
         Name            =   "�l�r �S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1020
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "��������������������"
      Top             =   480
      Width           =   1995
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   7530
      TabIndex        =   9
      Top             =   8790
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   6150
      TabIndex        =   8
      Top             =   8790
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(&A)"
      Height          =   315
      Left            =   8910
      TabIndex        =   10
      Top             =   8790
      Width           =   1275
   End
   Begin VB.Label Label1 
      Caption         =   "�R�[�h(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   750
   End
   Begin VB.Label Label1 
      Caption         =   "�\��(&S):"
      Height          =   180
      Index           =   3
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   750
   End
   Begin VB.Label Label1 
      Caption         =   "�{��(&B):"
      Height          =   180
      Index           =   4
      Left            =   120
      TabIndex        =   6
      Top             =   1260
      Width           =   750
   End
   Begin VB.Label Label1 
      Caption         =   "����(&N):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   750
   End
End
Attribute VB_Name = "frmMailTemplate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.4
'�S����  �FT.Takagi@RD
'�C�����e�F�V�K�쐬

Option Explicit

'�v���p�e�B�p�̈�
Private mstrTemplateCd  As String   '�e���v���[�g�R�[�h
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnShowOnly    As Boolean  'TRUE:�f�[�^�̍X�V�����Ȃ��i�Q�Ƃ̂݁j
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s

'���W���[���ŗL�̈�̈�
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

' @(e)
'
' �@�\�@�@ : �u�K�p�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p����B��ʂ͕��Ȃ�
'
' ���l�@�@ :
'
Private Sub cmdApply_Click()
    
    '�f�[�^�K�p�������s��
    Call ApplyData

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �t�H�[���R���g���[���̏�����
'
' �@�\���� : �R���g���[����������ԂɕύX����B
'
' ���l�@�@ :
'
Private Sub InitializeForm()

    Dim objTxtGotFocus  As TextGotFocus
    Dim i               As Long
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������
    
    '���[���{���ւ̃t�H�[�J�X���ɑI����ԂɂȂ�̂�������邽�߁A�C���X�^���X�����
    Set mcolGotFocusCollection = Nothing
    
    Set mcolGotFocusCollection = New Collection
    
    Set objTxtGotFocus = New TextGotFocus
    objTxtGotFocus.TargetTextBox = txtTemplateCd
    mcolGotFocusCollection.Add objTxtGotFocus
    
    Set objTxtGotFocus = New TextGotFocus
    objTxtGotFocus.TargetTextBox = txtTemplateName
    mcolGotFocusCollection.Add objTxtGotFocus
    
    Set objTxtGotFocus = New TextGotFocus
    objTxtGotFocus.TargetTextBox = txtSubject
    mcolGotFocusCollection.Add objTxtGotFocus
    
End Sub

' @(e)
'
' �@�\�@�@ : ���[���e���v���[�g����ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���[���e���v���[�g������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditMailTemplate() As Boolean

    Dim objMailTemplate As Object   '���[���e���v���[�g���A�N�Z�X�p
    
    Dim vntTemplateName As Variant  '�e���v���[�g��
    Dim vntSubject      As Variant  '�\��
    Dim vntBody         As Variant  '�{��

    Dim Ret             As Boolean  '�߂�l
    
    EditMailTemplate = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objMailTemplate = CreateObject("HainsMail.Template")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrTemplateCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '���[���e���v���[�g�e�[�u���ǂݍ���
        If objMailTemplate.SelectMailTemplate(mstrTemplateCd, vntTemplateName, vntSubject, vntBody) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW
        txtTemplateCd.Text = mstrTemplateCd
        txtTemplateName.Text = vntTemplateName
        txtSubject.Text = vntSubject
        txtBody.Text = vntBody

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditMailTemplate = Ret
    
    Exit Function

ErrorHandle:

    EditMailTemplate = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �f�[�^�̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �ύX���ꂽ�f�[�^���e�[�u���ɕۑ�����
'
' ���l�@�@ :
'
Private Function ApplyData() As Boolean

    ApplyData = False
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Function
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    Do
        '���̓`�F�b�N
        If CheckValue() = False Then Exit Do
        
        '���[���e���v���[�g�e�[�u���̓o�^
        If RegistMailTemplate() = False Then Exit Do
        
        '�X�V�ς݂ɂ���
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    

End Function

' @(e)
'
' �@�\�@�@ : �o�^�f�[�^�̃`�F�b�N
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e�̑Ó������`�F�b�N����
'
' ���l�@�@ :
'
Private Function CheckValue() As Boolean

    Dim Ret As Boolean  '�֐��߂�l
    
    '��������
    Ret = False
    
    Do
        
        If Trim(txtTemplateCd.Text) = "" Then
            MsgBox "�R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            txtTemplateCd.SetFocus
            Exit Do
        End If

        If Trim(txtTemplateName.Text) = "" Then
            MsgBox "���̂����͂���Ă��܂���B", vbExclamation, App.Title
            txtTemplateName.SetFocus
            Exit Do
        End If
        
        If Trim(txtSubject.Text) = "" Then
            MsgBox "�\�肪���͂���Ă��܂���B", vbExclamation, App.Title
            txtSubject.SetFocus
            Exit Do
        End If
        
        If txtBody.Text = "" Then
            MsgBox "�{�������͂���Ă��܂���B", vbExclamation, App.Title
            txtBody.SetFocus
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

' @(e)
'
' �@�\�@�@ : ���[���e���v���[�g���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e�����[���e���v���[�g�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistMailTemplate() As Boolean

    Dim objMailTemplate As Object   '���[���e���v���[�g���A�N�Z�X�p
    Dim lngRet          As Long     '�֐��߂�l
    
    On Error GoTo ErrorHandle

    RegistMailTemplate = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objMailTemplate = CreateObject("HainsMail.Template")

    '���[���e���v���[�g�e�[�u�����R�[�h�̓o�^
    lngRet = objMailTemplate.RegistMailTemplate(IIf(txtTemplateCd.Enabled, "INS", "UPD"), Trim(txtTemplateCd.Text), Trim(txtTemplateName.Text), Trim(txtSubject.Text), txtBody.Text)

    If lngRet = INSERT_DUPLICATE Then
        MsgBox "���͂��ꂽ�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistMailTemplate = False
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
        RegistMailTemplate = False
        Exit Function
    End If
    
    mstrTemplateCd = Trim(txtTemplateCd.Text)
    txtTemplateCd.Enabled = (txtTemplateCd.Text = "")
    
    RegistMailTemplate = True
    
    Exit Function
    
ErrorHandle:

    RegistMailTemplate = False
    
    MsgBox Err.Description, vbCritical
    
End Function

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
    
    '�f�[�^�K�p�������s���i�G���[���͉�ʂ���Ȃ��j
    If ApplyData() = False Then
        Exit Sub
    End If

    '��ʂ����
    Unload Me
    
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
    Call InitializeForm

    Do
        
        '���[���e���v���[�g���̕\���ҏW
        If EditMailTemplate() = False Then
            Exit Do
        End If
        
        '�C�l�[�u���ݒ�
        txtTemplateCd.Enabled = (txtTemplateCd.Text = "")
        
        Ret = True
        Exit Do
    
    Loop
    
    '�Q�Ɛ�p�̏ꍇ�A�o�^�n�R���g���[�����~�߂�
    If mblnShowOnly = True Then
        
        txtTemplateCd.Enabled = False
        txtTemplateName.Enabled = False
        txtSubject.Enabled = False
        txtBody.Enabled = False
    
        cmdOk.Enabled = False
        cmdApply.Enabled = False
    
    End If
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Friend Property Get TemplateCd() As Variant

    TemplateCd = mstrTemplateCd
    
End Property

Friend Property Let TemplateCd(ByVal vNewValue As Variant)
    
    mstrTemplateCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

Private Sub txtBody_GotFocus()

    cmdOk.Default = False
    
End Sub

Private Sub txtBody_LostFocus()

    cmdOk.Default = True

End Sub

