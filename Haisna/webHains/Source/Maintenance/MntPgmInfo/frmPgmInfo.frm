VERSION 5.00
Begin VB.Form frmPgmInfo 
   Caption         =   "�v���O�������Ǘ�"
   ClientHeight    =   6285
   ClientLeft      =   4785
   ClientTop       =   1440
   ClientWidth     =   7695
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6285
   ScaleWidth      =   7695
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      BeginProperty Font 
         Name            =   "�l�r �o�S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   364
      Left            =   5967
      TabIndex        =   20
      Top             =   5790
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      BeginProperty Font 
         Name            =   "�l�r �o�S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   364
      Left            =   4472
      TabIndex        =   13
      Top             =   5790
      Width           =   1335
   End
   Begin VB.Frame Frame1 
      Height          =   429
      Left            =   600
      TabIndex        =   15
      Top             =   5760
      Visible         =   0   'False
      Width           =   1963
      Begin VB.OptionButton Option1 
         Caption         =   "Hains"
         Height          =   195
         Index           =   1
         Left            =   156
         TabIndex        =   17
         Top             =   156
         Value           =   -1  'True
         Width           =   949
      End
      Begin VB.OptionButton Option1 
         Caption         =   "�U��"
         Height          =   195
         Index           =   0
         Left            =   1066
         TabIndex        =   16
         Top             =   156
         Width           =   845
      End
   End
   Begin VB.Frame Frame2 
      Height          =   5145
      Left            =   78
      TabIndex        =   0
      Top             =   520
      Width           =   7530
      Begin VB.TextBox txtYobi2 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   28
         Top             =   4125
         Width           =   5070
      End
      Begin VB.TextBox txtYudo 
         Height          =   325
         Left            =   2220
         MaxLength       =   6
         TabIndex        =   25
         Top             =   3360
         Width           =   2795
      End
      Begin VB.TextBox txtYobi1 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   24
         Top             =   3750
         Width           =   5070
      End
      Begin VB.TextBox txtFilePath 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   21
         Top             =   1378
         Width           =   5031
      End
      Begin VB.TextBox txtMenuGrp 
         Appearance      =   0  '�ׯ�
         Height          =   273
         Left            =   4966
         TabIndex        =   19
         Top             =   2262
         Visible         =   0   'False
         Width           =   2301
      End
      Begin VB.CheckBox chkDelFlg 
         Caption         =   "���̃v���O�����𖳌��ɂ���(&D)"
         Height          =   255
         Left            =   156
         TabIndex        =   14
         Top             =   4695
         Width           =   2760
      End
      Begin VB.TextBox txtPgmDesc 
         Height          =   689
         Left            =   2220
         MultiLine       =   -1  'True
         TabIndex        =   12
         Top             =   2600
         Width           =   5031
      End
      Begin VB.ComboBox cboMenu 
         Height          =   300
         Left            =   2220
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   11
         Top             =   2236
         Width           =   2301
      End
      Begin VB.TextBox txtLinkImage 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   10
         Top             =   1794
         Width           =   5031
      End
      Begin VB.TextBox txtStartPgm 
         Height          =   325
         Left            =   2220
         MaxLength       =   50
         TabIndex        =   9
         Top             =   988
         Width           =   2795
      End
      Begin VB.TextBox txtPgmName 
         Height          =   325
         Left            =   2220
         MaxLength       =   50
         TabIndex        =   8
         Top             =   598
         Width           =   2795
      End
      Begin VB.TextBox txtPgmCd 
         Height          =   325
         Left            =   2220
         MaxLength       =   12
         TabIndex        =   7
         Top             =   208
         Width           =   2795
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�\���Q"
         Height          =   180
         Index           =   10
         Left            =   135
         TabIndex        =   29
         Top             =   4215
         Width           =   480
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�U����������"
         Height          =   180
         Index           =   9
         Left            =   135
         TabIndex        =   27
         Top             =   3435
         Width           =   1080
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�\���P"
         Height          =   180
         Index           =   8
         Left            =   135
         TabIndex        =   26
         Top             =   3840
         Width           =   480
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�v���O�����t�@�C���o�H"
         Height          =   169
         Index           =   7
         Left            =   182
         TabIndex        =   22
         Top             =   1456
         Width           =   1625
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�v���O��������"
         Height          =   169
         Index           =   6
         Left            =   130
         TabIndex        =   6
         Top             =   2730
         Width           =   1079
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "���j���[ �敪"
         Height          =   169
         Index           =   4
         Left            =   130
         TabIndex        =   5
         Top             =   2314
         Width           =   949
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�����N�C���[�W�i�o�H��܁j"
         Height          =   169
         Index           =   3
         Left            =   182
         TabIndex        =   4
         Top             =   1872
         Width           =   1820
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�N���v���O�����t�@�C����"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   3
         Top             =   1065
         Width           =   1965
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�v���O�����@���j���[��"
         Height          =   169
         Index           =   1
         Left            =   182
         TabIndex        =   2
         Top             =   676
         Width           =   1586
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�v���O�����R�[�h"
         Height          =   169
         Index           =   0
         Left            =   182
         TabIndex        =   1
         Top             =   286
         Width           =   1144
      End
   End
   Begin VB.Label lblMenu 
      AutoSize        =   -1  'True
      BeginProperty Font 
         Name            =   "�l�r �o�S�V�b�N"
         Size            =   12
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   3780
      TabIndex        =   23
      Top             =   165
      Width           =   90
   End
   Begin VB.Label LabelTitle 
      Caption         =   "�v���O��������o�^���Ă�������"
      Height          =   375
      Left            =   855
      TabIndex        =   18
      Top             =   165
      Width           =   2655
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   75
      Picture         =   "frmPgmInfo.frx":0000
      Top             =   -30
      Width           =   720
   End
End
Attribute VB_Name = "frmPgmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public mstrMenuGrpCd        As String
Public mstrPgmCd        As String   '�Z�b�g���ރR�[�h
Public imode                As Integer

Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private aryMenuGrpCd()       As String
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����


Friend Property Let SetPgmInfoCd(ByVal vntNewValue As Variant)

    mstrPgmCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

Private Sub cmdCancel_Click()
    Unload Me
End Sub

'
' �@�\�@�@ : �u�n�j�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p���A��ʂ����
'
' ���l�@�@ :
'
Private Sub cmdOk_Click()

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
        
        '�v���O�������e�[�u���̓o�^
        If RegistPgmInfo() = False Then
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

Private Function RegistPgmInfo() As Boolean
    On Error GoTo ErrorHandle

    Dim objPgmInfo     As Object       '�Z�b�g���ރA�N�Z�X�p
    Dim Ret             As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPgmInfo = CreateObject("HainsPgmInfo.PgmInfo")
    
    '�v���O�������e�[�u���̓o�^
    Ret = objPgmInfo.RegistPgmInfo(IIf(txtPgmCd.Enabled, "INS", "UPD"), _
                                     Trim(txtPgmCd.Text), _
                                     Trim(txtPgmName.Text), _
                                     Trim(txtStartPgm.Text), _
                                     Trim(txtFilePath.Text), _
                                     Trim(txtLinkImage.Text), _
                                     Trim(aryMenuGrpCd(cboMenu.ListIndex)), _
                                     Trim(txtPgmDesc.Text), _
                                     chkDelFlg.Value, _
                                     Trim(txtYudo.Text), _
                                     Trim(txtYobi1.Text), _
                                     Trim(txtYobi2.Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�v���O�������͊��ɑ��݂��܂��B", vbExclamation
        RegistPgmInfo = False
        Exit Function
    End If
    
    RegistPgmInfo = True
    
    Set objPgmInfo = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPgmInfo = Nothing
    
    RegistPgmInfo = False
    
End Function


Private Function CheckValue() As Boolean
    Dim Ret             As Boolean  '�֐��߂�l
    
    '��������
    Ret = False
    
    Do
        If Trim(txtPgmCd.Text) = "" Then
            MsgBox "�v���O�����R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtPgmCd.SetFocus
            Exit Do
        End If

        If Trim(txtPgmName.Text) = "" Then
            MsgBox "�v���O�������̂����͂���Ă��܂���B", vbCritical, App.Title
            txtPgmName.SetFocus
            Exit Do
        End If
        
        If Trim(txtStartPgm.Text) = "" Then
'            MsgBox "�N���v���O���������͂���Ă��܂���B", vbCritical, App.Title
            MsgBox "�N���v���O�����̃t�@�C��������͂��Ă��������B", vbCritical, App.Title
            txtStartPgm.SetFocus
            Exit Do
        End If
        
        If Trim(txtFilePath.Text) = "" Then
'            MsgBox "�N���v���O���������͂���Ă��܂���B", vbCritical, App.Title
            MsgBox "�N���v���O�����̃t�@�C���o�H����͂��Ă��������B", vbCritical, App.Title
            txtStartPgm.SetFocus
            Exit Do
        End If
        
        
        If Trim(cboMenu.Text) = "" Then
            MsgBox "���j���[�O���[�v�����͂���Ă��܂���B", vbCritical, App.Title
            txtStartPgm.SetFocus
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

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
        '�Z�b�g���ޏ��̕ҏW
        If EditMenuGrp() = False Then
            Exit Do
        End If
    
        If EditPgmInfo() = False Then
            Exit Do
        End If
        
        '�C�l�[�u���ݒ�
        txtPgmCd.Enabled = (txtPgmCd.Text = "")
        
        Ret = True
        
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Sub

'
' �@�\�@�@ : �f�[�^�\���p�ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditPgmInfo() As Boolean
    On Error GoTo ErrorHandle

    Dim objPgmInfo          As Object               '�O���[�v�A�N�Z�X�p
    
    Dim vntPgmCd            As Variant              '�v���O�����R�[�h
    Dim vntPgmName          As Variant              '�v���O��������
    Dim vntStartPgm         As Variant              '�N���v���O���� (File���j
    '##2005.07.25�@�ǉ��@Add�@By�@���@--->�@ST
    Dim vntFilePath         As Variant              '�v���O�����t�@�C���o�H
    '##2005.07.25�@�ǉ��@Add�@By�@���@--->�@ED
    Dim vntLinkImage        As Variant              '�����N�C���[�W(�o�H��܁j
    Dim vntMenuGrpCd        As Variant              '���j���[�O���[�v�R�[�h
    Dim vntPgmDesc          As Variant              '�v���O��������
    Dim vntDelFlag          As Variant              '�g�p�ۃt���b�O
    '##2005.08.12�@�ǉ��@Add�@By�@���@--->�@ST
    Dim vntMenuName         As Variant
    Dim vntYudoBunrui       As Variant              '�U����������
    Dim vntYobi1            As Variant              '�\��1
    Dim vntYobi2            As Variant              '�\��2
    '##2005.08.12�@�ǉ��@Add�@By�@���@--->�@ED
    
    Dim lngCount            As Long                 '���R�[�h��
    Dim i                   As Long                 '�C���f�b�N�X
    Dim Ret                 As Boolean
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPgmInfo = CreateObject("HainsPgmInfo.PgmInfo")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrPgmCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�v���O���������R�[�h�œǂݍ���
        lngCount = objPgmInfo.SelectPgmInfo(mstrPgmCd, _
                                                0, _
                                                vntPgmCd, _
                                                vntPgmName, _
                                                vntStartPgm, _
                                                vntFilePath, _
                                                vntLinkImage, _
                                                vntMenuGrpCd, _
                                                vntPgmDesc, _
                                                vntDelFlag, _
                                                vntMenuName, _
                                                vntYudoBunrui, _
                                                vntYobi1, _
                                                vntYobi2)
    
        '�ǂݍ��ݓ��e�̕ҏW
        If lngCount > 0 Then
            txtPgmCd.Text = vntPgmCd(0)
            txtPgmName.Text = vntPgmName(0)
            txtStartPgm.Text = vntStartPgm(0)
            txtFilePath.Text = vntFilePath(0)
            txtLinkImage.Text = vntLinkImage(0)
            cboMenu.ListIndex = SetMenuGrpIndex(CStr(vntMenuGrpCd(0)))
            txtPgmDesc.Text = vntPgmDesc(0)
            chkDelFlg.Value = CInt(vntDelFlag(0))
            txtYudo.Text = vntYudoBunrui(0)
            txtYobi1 = vntYobi1(0)
            txtYobi2 = vntYobi2(0)
        
        Else
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditPgmInfo = Ret
    
    Exit Function

ErrorHandle:

    EditPgmInfo = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Function SetMenuGrpIndex(GrpCd As String) As Integer
    Dim i       As Integer
    
    For i = 0 To UBound(aryMenuGrpCd())
        If Trim(aryMenuGrpCd(i)) = Trim(GrpCd) Then
            SetMenuGrpIndex = i
            Exit For
        End If
    Next i

End Function



Private Sub InitializeForm()
    cboMenu.Visible = True
    txtMenuGrp.Visible = False

    txtMenuGrp.Left = cboMenu.Left
    txtMenuGrp.Top = cboMenu.Top
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������
    
End Sub


'
' �@�\�@�@ :
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
' �@�\���� :
' ���l�@�@ :
'
Private Function EditMenuGrp() As Boolean
    Dim objItem                 As Object           '�R�[�X�A�N�Z�X�p
    Dim lngCount                As Long             '���R�[�h��
    Dim i                       As Long             '�C���f�b�N�X
    Dim imode                   As Integer
    Dim strKey                  As String
    
    Dim vntFreeCd               As Variant          '�R�[�h
    Dim vntFreeName             As Variant          '�R�[�h��
    Dim vntFreeDate             As Variant
    Dim vntFreeField1           As Variant
    Dim vntFreeField2           As Variant
    Dim vntFreeField3           As Variant
    Dim vntFreeField4           As Variant
    Dim vntFreeField5           As Variant
    Dim vntFreeField6           As Variant
    Dim vntFreeField7           As Variant
    Dim vntFreeClassCd          As Variant
    
    EditMenuGrp = False
    cboMenu.Clear
    
    imode = 0
    strKey = "PGM"
    Erase aryMenuGrpCd
        
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsFree.Free")
    lngCount = objItem.SelectFreeByClassCd(imode, _
                                          strKey, _
                                          vntFreeCd, _
                                          vntFreeName, _
                                          vntFreeDate, _
                                          vntFreeField1, _
                                          vntFreeField2, _
                                          vntFreeField3, _
                                          vntFreeField4, _
                                          vntFreeField5, _
                                          , _
                                          vntFreeClassCd, _
                                          vntFreeField6, _
                                          vntFreeField7)
    
    '�����f�[�^�����݂��Ȃ��Ȃ�A�G���[
    If lngCount <= 0 Then
        MsgBox "���[�j���[�O���[�v�����݂��Ȃ��ł��B", vbExclamation
        Exit Function
    End If
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve aryMenuGrpCd(i)
        aryMenuGrpCd(i) = vntFreeCd(i)
        cboMenu.AddItem vntFreeField1(i)
    Next i
    
'    cboMenu.ListIndex = 0
    
    '�擪�R���{��I����Ԃɂ���
    EditMenuGrp = True
    
    Exit Function
    
ErrorHandle:
    MsgBox Err.Description, vbCritical

End Function

Private Sub txtLinkImage_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub

Private Sub txtPgmCd_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub


Private Sub txtPgmDesc_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub

Private Sub txtPgmName_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub

Private Sub txtStartPgm_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub
