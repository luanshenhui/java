VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmMailConf 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "��{�ݒ�"
   ClientHeight    =   5880
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8715
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMailConf.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5880
   ScaleWidth      =   8715
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(&A)"
      Height          =   315
      Left            =   7320
      TabIndex        =   18
      Top             =   5460
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4560
      TabIndex        =   16
      Top             =   5460
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5940
      TabIndex        =   17
      Top             =   5460
      Width           =   1275
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5220
      Left            =   120
      TabIndex        =   19
      Top             =   120
      Width           =   8505
      _ExtentX        =   15002
      _ExtentY        =   9208
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabsPerRow      =   2
      TabHeight       =   520
      TabCaption(0)   =   "��{"
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label1(4)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Label1(1)"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Label1(0)"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Label1(3)"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "txtSignature"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "txtBCC"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).Control(6)=   "txtCC"
      Tab(0).Control(6).Enabled=   0   'False
      Tab(0).Control(7)=   "txtMailFrom"
      Tab(0).Control(7).Enabled=   0   'False
      Tab(0).ControlCount=   8
      TabCaption(1)   =   "�T�[�o�ݒ�"
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "txtServerName"
      Tab(1).Control(1)=   "txtUserId"
      Tab(1).Control(2)=   "txtPassword"
      Tab(1).Control(3)=   "txtPortNo"
      Tab(1).Control(4)=   "Label1(11)"
      Tab(1).Control(5)=   "Label1(10)"
      Tab(1).Control(6)=   "Label1(9)"
      Tab(1).Control(7)=   "Label1(2)"
      Tab(1).ControlCount=   8
      Begin VB.TextBox txtMailFrom 
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
         Left            =   1140
         MaxLength       =   40
         TabIndex        =   1
         Text            =   "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
         Top             =   480
         Width           =   4215
      End
      Begin VB.TextBox txtCC 
         BeginProperty Font 
            Name            =   "�l�r �S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   840
         IMEMode         =   3  '�̌Œ�
         Left            =   1140
         MultiLine       =   -1  'True
         ScrollBars      =   2  '����
         TabIndex        =   3
         Top             =   840
         Width           =   4215
      End
      Begin VB.TextBox txtBCC 
         BeginProperty Font 
            Name            =   "�l�r �S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   840
         IMEMode         =   3  '�̌Œ�
         Left            =   1140
         MultiLine       =   -1  'True
         ScrollBars      =   2  '����
         TabIndex        =   5
         Top             =   1740
         Width           =   4215
      End
      Begin VB.TextBox txtSignature 
         BeginProperty Font 
            Name            =   "�l�r �S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2400
         Left            =   1140
         MultiLine       =   -1  'True
         ScrollBars      =   2  '����
         TabIndex        =   7
         Top             =   2640
         Width           =   7095
      End
      Begin VB.TextBox txtServerName 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   -73320
         MaxLength       =   100
         TabIndex        =   9
         Text            =   "smtp.test.com"
         Top             =   480
         Width           =   4215
      End
      Begin VB.TextBox txtUserId 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   -73320
         MaxLength       =   100
         TabIndex        =   11
         Text            =   "test"
         Top             =   840
         Width           =   4215
      End
      Begin VB.TextBox txtPassword 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   -73320
         MaxLength       =   100
         PasswordChar    =   "*"
         TabIndex        =   13
         Text            =   "smtp.test.com"
         Top             =   1200
         Width           =   4215
      End
      Begin VB.TextBox txtPortNo 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   -73320
         MaxLength       =   5
         TabIndex        =   15
         Text            =   "99999"
         Top             =   1560
         Width           =   615
      End
      Begin VB.Label Label1 
         Caption         =   "SMTP�T�[�o�[(&M):"
         Height          =   180
         Index           =   11
         Left            =   -74760
         TabIndex        =   8
         Top             =   540
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "���[�U�[��(&U):"
         Height          =   180
         Index           =   10
         Left            =   -74760
         TabIndex        =   10
         Top             =   900
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "�p�X���[�h(&P):"
         Height          =   180
         Index           =   9
         Left            =   -74760
         TabIndex        =   12
         Top             =   1260
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "�|�[�g�ԍ�(&N):"
         Height          =   180
         Index           =   2
         Left            =   -74760
         TabIndex        =   14
         Top             =   1620
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "from(&F):"
         Height          =   180
         Index           =   3
         Left            =   240
         TabIndex        =   0
         Top             =   540
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "cc(&C):"
         Height          =   180
         Index           =   0
         Left            =   240
         TabIndex        =   2
         Top             =   900
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "bcc(&B):"
         Height          =   180
         Index           =   1
         Left            =   240
         TabIndex        =   4
         Top             =   1800
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "����(&S):"
         Height          =   180
         Index           =   4
         Left            =   240
         TabIndex        =   6
         Top             =   2760
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "SMTP�T�[�o�[(&M):"
         Height          =   180
         Index           =   5
         Left            =   -74760
         TabIndex        =   23
         Top             =   540
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "���[�U�[��(&U):"
         Height          =   180
         Index           =   6
         Left            =   -74760
         TabIndex        =   22
         Top             =   900
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "�p�X���[�h(&P):"
         Height          =   180
         Index           =   7
         Left            =   -74760
         TabIndex        =   21
         Top             =   1260
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "�|�[�g�ԍ�(&N):"
         Height          =   180
         Index           =   8
         Left            =   -74760
         TabIndex        =   20
         Top             =   1620
         Width           =   1530
      End
   End
End
Attribute VB_Name = "frmMailConf"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.3
'�S����  �FT.Takagi@RD
'�C�����e�F�V�K�쐬

Option Explicit

'�v���p�e�B�p�̈�
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

    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������
    
End Sub

' @(e)
'
' �@�\�@�@ : ��{�ݒ��ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �\�񃁁[�����M��{������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditMailConf() As Boolean

    Dim objMailConf     As Object   '���[�����M�ݒ�A�N�Z�X�p
    
    Dim vntMailFrom     As Variant  'FROM
    Dim vntCC           As Variant  'CC
    Dim vntBCC          As Variant  'BCC
    Dim vntSignature    As Variant  '����
    Dim vntServerName   As Variant  'SMTP�T�[�o��
    Dim vntUserId       As Variant  '���[�UID
    Dim vntPassword     As Variant  '�p�X���[�h
    Dim vntPortNo       As Variant  '�|�[�g�ԍ�

    EditMailConf = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objMailConf = CreateObject("HainsMail.Config")
    
    '���[�����M�ݒ�e�[�u���ǂݍ���
    objMailConf.SelectMailConf vntMailFrom, vntCC, vntBCC, vntSignature, vntServerName, vntUserId, vntPassword, vntPortNo

    '�ǂݍ��ݓ��e�̕ҏW
    txtMailFrom.Text = vntMailFrom
    txtCC.Text = vntCC
    txtBCC.Text = vntBCC
    txtSignature.Text = vntSignature
    txtServerName.Text = vntServerName
    txtUserId.Text = vntUserId
    txtPassword.Text = vntPassword
    txtPortNo.Text = vntPortNo
    
    '�߂�l�̐ݒ�
    EditMailConf = True
    
    Exit Function

ErrorHandle:

    EditMailConf = False
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
        
        '���[�����M�ݒ�e�[�u���̓o�^
        If RegistMailConf() = False Then Exit Do
        
        '�X�V�ς݂ɂ���
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    

End Function

'
' �@�\�@�@ : E-Mail�`���`�F�b�N
'
' �����@�@ : (In)     strItemName ���ږ�
' �@�@�@�@   (In)     strEmails   ���[���A�h���X
'
' �߂�l�@ : �G���[���b�Z�[�W(�G���[�������ꍇ�͒���0�̕�����)
'
' ���l�@�@ :
'
Private Function CheckEmail(ByVal strItemName As String, ByVal strEmails As String) As String

    Dim objCommon   As Object   '���ʃN���X
    Dim vntEmails   As Variant  '���[���A�h���X�̔z��
    Dim strEmail    As String   '���[���A�h���X
    Dim strMessage  As String   '���b�Z�[�W
    Dim i           As Long     '�C���f�b�N�X
    
    If Trim(strEmails) = "" Then
        Exit Function
    End If
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommon = CreateObject("HainsCommon.Common")

    '���s�A�J���}�ŕ���
    vntEmails = Split(Replace(strEmails, ",", vbCrLf), vbCrLf)

    '�����ɂč쐬���ꂽ�z��v�f���`�F�b�N
    For i = 0 To UBound(vntEmails)
        strEmail = Trim(vntEmails(i))
        If strEmail <> "" Then
            strMessage = objCommon.CheckEmail(strItemName, strEmail)
            If strMessage <> "" Then
                CheckEmail = strMessage
                Exit Function
            End If
        End If
    Next i

End Function

'
' �@�\�@�@ : E-Mail������ϊ�
'
' �����@�@ : (In)     strEmails   ���[���A�h���X
'
' �߂�l�@ : �ϊ���̒l
'
' ���l�@�@ :
'
Private Function ConvertEmail(ByVal strEmails As String) As String

    Dim vntEmails       As Variant  '���[���A�h���X�̔z��
    Dim strArrEmails()  As String   '���[���A�h���X�̔z��
    Dim strEmail        As String   '���[���A�h���X
    Dim lngCount        As Long     '�z��̗v�f��
    Dim i               As Long     '�C���f�b�N�X
    
    '���s�A�J���}�ŕ���
    vntEmails = Split(Replace(strEmails, ",", vbCrLf), vbCrLf)

    '�����ɂč쐬���ꂽ�z��v�f���������A�v�f������Δz��ɒǉ�
    For i = 0 To UBound(vntEmails)
        strEmail = Trim(vntEmails(i))
        If strEmail <> "" Then
            ReDim Preserve strArrEmails(lngCount)
            strArrEmails(lngCount) = strEmail
            lngCount = lngCount + 1
        End If
    Next i
    
    '�v�f������Ή��s�ŘA�����ĕԂ�
    If lngCount > 0 Then
        ConvertEmail = Join(strArrEmails, vbCrLf)
    End If
    
End Function

' @(e)
'
' �@�\�@�@ : �����̃`�F�b�N
'
' �߂�l�@ : TRUE:����AFALSE:�ُ�
'
' �@�\���� :
'
' ���l�@�@ :
'
Private Function CheckInteger(ByRef strExpression As String) As Boolean

    Dim i   As Long
    Dim Ret As Boolean
    
    Ret = True
    
    For i = 1 To Len(strExpression)
        If InStr("0123456789", Mid(strExpression, i, 1)) <= 0 Then
            Ret = False
            Exit For
        End If
    Next i
    
    CheckInteger = Ret
    
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

    Dim strMessage  As String   '���b�Z�[�W
    Dim Ret         As Boolean  '�֐��߂�l
    
    '��������
    Ret = False
    
    Do
        
        'FROM���[���A�h���X�̃`�F�b�N
        strMessage = CheckEmail("from", txtMailFrom.Text)
        If strMessage <> "" Then
            MsgBox strMessage, vbExclamation, App.Title
            txtMailFrom.SetFocus
            Exit Do
        End If
        
        'CC�̃`�F�b�N
        strMessage = CheckEmail("cc", txtCC.Text)
        If strMessage <> "" Then
            MsgBox strMessage, vbExclamation, App.Title
            txtCC.SetFocus
            Exit Do
        End If
        
        'BCC�̃`�F�b�N
        strMessage = CheckEmail("bcc", txtBCC.Text)
        If strMessage <> "" Then
            MsgBox strMessage, vbExclamation, App.Title
            txtBCC.SetFocus
            Exit Do
        End If
        
        '�|�[�g�ԍ��̃`�F�b�N
        If Trim(txtPortNo.Text) <> "" Then
            If CheckInteger(Trim(txtPortNo.Text)) = False Then
                MsgBox "�|�[�g�ԍ��ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
                txtPortNo.SetFocus
                Exit Do
            End If
        End If

        Ret = True
        
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

' @(e)
'
' �@�\�@�@ : ���[�����M�ݒ�̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e�����[�����M�ݒ�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistMailConf() As Boolean

    Dim objMailConf     As Object   '���[�����M�ݒ�A�N�Z�X�p
    
    Dim lngRet          As Long     '�֐��߂�l
    
    On Error GoTo ErrorHandle

    RegistMailConf = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objMailConf = CreateObject("HainsMail.Config")

    '���[�����M�ݒ�e�[�u�����R�[�h�̓o�^
    lngRet = objMailConf.RegistMailConf( _
        Trim(txtMailFrom.Text), _
        ConvertEmail(txtCC.Text), _
        ConvertEmail(txtBCC.Text), _
        txtSignature.Text, _
        Trim(txtServerName.Text), _
        Trim(txtUserId.Text), _
        Trim(txtPassword.Text), _
        Trim(txtPortNo.Text) _
    )

    If lngRet = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
        RegistMailConf = False
        Exit Function
    End If
    
    RegistMailConf = True
    
    Exit Function
    
ErrorHandle:

    RegistMailConf = False
    
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
        
        '���[�����M�ݒ�̕\���ҏW
        If EditMailConf() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    
    Loop
    
    '�Q�Ɛ�p�̏ꍇ�A�o�^�n�R���g���[�����~�߂�
    If mblnShowOnly = True Then
        
        txtMailFrom.Enabled = False
        txtCC.Enabled = False
        txtBCC.Enabled = False
        txtSignature.Enabled = False
        txtServerName.Enabled = False
        txtUserId.Enabled = False
        txtPassword.Enabled = False
        txtPortNo.Enabled = False
    
        cmdOk.Enabled = False
        cmdApply.Enabled = False
    
    End If
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

Private Sub txtBCC_GotFocus()

    cmdOk.Default = False

End Sub

Private Sub txtBCC_LostFocus()

    cmdOk.Default = True

End Sub

Private Sub txtCC_GotFocus()

    cmdOk.Default = False
    
End Sub

Private Sub txtCC_LostFocus()

    cmdOk.Default = True

End Sub

Private Sub txtSignature_GotFocus()

    cmdOk.Default = False

End Sub

Private Sub txtSignature_LostFocus()

    cmdOk.Default = True

End Sub

