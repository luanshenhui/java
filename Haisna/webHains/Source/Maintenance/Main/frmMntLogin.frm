VERSION 5.00
Begin VB.Form frmMntLogin 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���O�C�����"
   ClientHeight    =   2310
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6015
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMntLogin.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2310
   ScaleWidth      =   6015
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtPassword 
      Height          =   315
      IMEMode         =   3  '�̌Œ�
      Left            =   1980
      MaxLength       =   64
      PasswordChar    =   "*"
      TabIndex        =   3
      Text            =   "Text1"
      Top             =   1140
      Width           =   3615
   End
   Begin VB.TextBox txtUserName 
      Height          =   315
      IMEMode         =   3  '�̌Œ�
      Left            =   1980
      MaxLength       =   20
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   720
      Width           =   3615
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4320
      TabIndex        =   5
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2880
      TabIndex        =   4
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label3 
      Caption         =   "���[�U���ƃp�X���[�h����͂��Ă��������B"
      Height          =   195
      Left            =   960
      TabIndex        =   6
      Top             =   240
      Width           =   3735
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   240
      Picture         =   "frmMntLogin.frx":000C
      Top             =   180
      Width           =   480
   End
   Begin VB.Label Label2 
      Caption         =   "�p�X���[�h(&P):"
      Height          =   195
      Left            =   960
      TabIndex        =   2
      Top             =   1200
      Width           =   1035
   End
   Begin VB.Label Label1 
      Caption         =   "���[�U��(&U):"
      Height          =   195
      Left            =   960
      TabIndex        =   0
      Top             =   780
      Width           =   1035
   End
End
Attribute VB_Name = "frmMntLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private blnCertification    As Boolean

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private Sub cmdCancel_Click()

    Unload Me

End Sub

Private Sub cmdOk_Click()

    Dim strMessage As String
    Dim Ret             As Boolean

    Screen.MousePointer = vbHourglass
    Ret = False
    
    Do
        '�_�~�[�Z�b�g�t�H�[�J�X
        cmdOk.SetFocus
        
        '�����̓`�F�b�N
        If (Trim(txtUserName.Text) = "") Or (Trim(txtPassword.Text) = "") Then
            strMessage = "���O�C���ł��܂���B���[�U���ƃp�X���[�h���m�F���āA������x�p�X���[�h����͂��Ă��������B"
            txtUserName.SetFocus
            Exit Do
        End If
            
        '���[�U�h�c�A�p�X���[�h�̃`�F�b�N
        If CheckCertification(strMessage) = False Then
            Exit Do
        End If
        
        Ret = True
        
        Exit Do
    Loop
    
    Screen.MousePointer = vbDefault
    
    If Ret = False Then
        MsgBox strMessage, vbExclamation, App.Title
        Exit Sub
    End If
    
    blnCertification = True
    Unload Me

End Sub

'
' �@�\�@�@ : ���[�U�h�c�A�p�X���[�h�̃`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Function CheckCertification(strMessage As String) As Boolean

On Error GoTo ErrorHandle

    Dim objLogin    As Object           'HainsUser�A�N�Z�X�p
    
    Dim lngErrNo        As Long
    Dim vntUserName     As Variant
    Dim vntAuthTblMnt   As Variant
    Dim vntAuthRsv      As Variant
    Dim vntAuthRsl      As Variant
    Dim vntAuthJud      As Variant
    Dim vntAuthPrn      As Variant
    Dim vntAuthDmd      As Variant
'## 2004.12.22 ADD ST FJTH)C.M �}�X�^�����e�i���X����
    Dim vntAuthExt1     As Variant
'## 2004.12.22 ADD ED

    CheckCertification = False
    lngErrNo = -1
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objLogin = CreateObject("HainsHainsUser.HainsUser")
    
    '���[�U�h�c�A�p�X���[�h�`�F�b�N
'## 2004.12.22 UPD ST FJTH)C.M �}�X�^�����e�i���X����
'    lngErrNo = objLogin.CheckIDandPassword(Trim(txtUserName.Text), _
'                                           Trim(txtPassword.Text), _
'                                           vntUserName, _
'                                           vntAuthTblMnt, _
'                                           vntAuthRsv, _
'                                           vntAuthRsl, _
'                                           vntAuthJud, _
'                                           vntAuthPrn, _
'                                           vntAuthDmd)
    lngErrNo = objLogin.CheckIDandPassword(Trim(txtUserName.Text), _
                                           Trim(txtPassword.Text), _
                                           vntUserName, _
                                           vntAuthTblMnt, _
                                           vntAuthRsv, _
                                           vntAuthRsl, _
                                           vntAuthJud, _
                                           vntAuthPrn, _
                                           vntAuthDmd, , , _
                                           vntAuthExt1)
'## 2004.12.22 UPD ED
    
    '�f�t�H���g�Z�b�g�t�H�[�J�X
    txtUserName.SetFocus
    
    Select Case lngErrNo
        Case 0
'## 2004.12.22 UPD ST FJTH)C.M
'            If IsNumeric(vntAuthTblMnt) = True Then
'                If vntAuthTblMnt = AUTHORITY_FULL Then
            If IsNumeric(vntAuthExt1) = True Then
                If vntAuthExt1 = AUTHORITY_FULL Then
'## 2004.12.22 UPD ED
                    CheckCertification = True
                Else
                    strMessage = "���͂��ꂽ���[�U�h�c�ł͊��ݒ���s���ׂ̌������s�����Ă��܂��B"
                End If
            Else
                strMessage = "���͂��ꂽ���[�U�h�c�ł͊��ݒ���s���ׂ̌������s�����Ă��܂��B"
            End If
        Case 1
            strMessage = "���͂��ꂽ���[�U�h�c�͑��݂��܂���B"
        Case 2
            strMessage = "�p�X���[�h������������܂���B"
            txtPassword.Text = ""
            txtPassword.SetFocus
        Case 3
            strMessage = "webHains���g�p���錠��������܂���B"
        Case 9
            strMessage = "���[�U�h�c�ƃp�X���[�h����͂��ĉ������B"
        Case Else
            strMessage = "�F�ؒ��ɃG���[���������܂����B�߂�l=" & lngErrNo
    End Select
    
    '�I�u�W�F�N�g�p��
    Set objLogin = Nothing
    
    Exit Function
    
ErrorHandle:

'    MsgBox Err.Description, vbCritical
    strMessage = Err.Description & vbLf & "(ErrNo:" & Err.Number & ")"
    Set objLogin = Nothing
    CheckCertification = False
    
End Function

Private Sub Form_Load()

    blnCertification = False
    
    Call InitFormControls(Me, mcolGotFocusCollection)

End Sub

Friend Property Get Certification() As Variant
    
    Certification = blnCertification

End Property
