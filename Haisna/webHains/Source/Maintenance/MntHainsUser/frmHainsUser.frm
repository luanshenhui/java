VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmHainsUser 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���[�U�e�[�u�������e�i���X"
   ClientHeight    =   8625
   ClientLeft      =   3825
   ClientTop       =   1230
   ClientWidth     =   7740
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmHainsUser.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8625
   ScaleWidth      =   7740
   ShowInTaskbar   =   0   'False
   Begin TabDlg.SSTab SSTab1 
      Height          =   4950
      Left            =   120
      TabIndex        =   14
      Top             =   2910
      Width           =   7275
      _ExtentX        =   12832
      _ExtentY        =   8731
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "�W������"
      TabPicture(0)   =   "frmHainsUser.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame2"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "���̑�����"
      TabPicture(1)   =   "frmHainsUser.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "txtSentenceCd"
      Tab(1).Control(1)=   "cmdSentenceCd"
      Tab(1).Control(2)=   "Frame5"
      Tab(1).Control(3)=   "Frame4"
      Tab(1).Control(4)=   "Frame3"
      Tab(1).Control(5)=   "lblShortStc"
      Tab(1).ControlCount=   6
      Begin VB.TextBox txtSentenceCd 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   -72780
         MaxLength       =   8
         TabIndex        =   49
         Text            =   "@@@@@@@@"
         Top             =   3120
         Width           =   1095
      End
      Begin VB.CommandButton cmdSentenceCd 
         Caption         =   "�Ή����̓R�[�h(&B)..."
         Height          =   375
         Left            =   -74700
         TabIndex        =   48
         Top             =   3060
         Width           =   1755
      End
      Begin VB.Frame Frame5 
         Caption         =   "�R�����g�֘A"
         Height          =   1515
         Left            =   -72360
         TabIndex        =   43
         Top             =   1320
         Width           =   4455
         Begin VB.ComboBox cboDefNoteDispKbn 
            Height          =   300
            Left            =   1560
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   46
            Top             =   660
            Width           =   2475
         End
         Begin VB.ComboBox cboAuthNote 
            Height          =   300
            Left            =   1560
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   45
            Top             =   300
            Width           =   2475
         End
         Begin VB.Label Label2 
            Caption         =   "������ԁF"
            Height          =   195
            Index           =   1
            Left            =   240
            TabIndex        =   47
            Top             =   720
            Width           =   1275
         End
         Begin VB.Label Label2 
            Caption         =   "�Q�Ɠo�^�����F"
            Height          =   195
            Index           =   0
            Left            =   240
            TabIndex        =   44
            Top             =   360
            Width           =   1275
         End
      End
      Begin VB.Frame Frame4 
         Caption         =   "�����֘A"
         Height          =   795
         Left            =   -72360
         TabIndex        =   41
         Top             =   480
         Width           =   4455
         Begin VB.CheckBox chkIgnoreFlg 
            Caption         =   "�\��g�𖳎����ė\����Ƃ邱�Ƃ��\"
            Height          =   255
            Left            =   240
            TabIndex        =   42
            Top             =   360
            Width           =   4035
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "�ʐڎx����ʌ����ݒ�"
         Height          =   2355
         Left            =   -74760
         TabIndex        =   34
         Top             =   480
         Width           =   2295
         Begin VB.CheckBox chkDoctorFlg 
            Caption         =   "��������"
            Height          =   255
            Index           =   5
            Left            =   180
            TabIndex        =   40
            Top             =   1860
            Width           =   1335
         End
         Begin VB.CheckBox chkDoctorFlg 
            Caption         =   "�f�@��"
            Height          =   255
            Index           =   4
            Left            =   180
            TabIndex        =   39
            Top             =   1560
            Width           =   1335
         End
         Begin VB.CheckBox chkDoctorFlg 
            Caption         =   "�h�{�m"
            Height          =   255
            Index           =   3
            Left            =   180
            TabIndex        =   38
            Top             =   1260
            Width           =   1335
         End
         Begin VB.CheckBox chkDoctorFlg 
            Caption         =   "�Ō�m"
            Height          =   255
            Index           =   2
            Left            =   180
            TabIndex        =   37
            Top             =   960
            Width           =   1335
         End
         Begin VB.CheckBox chkDoctorFlg 
            Caption         =   "�����"
            Height          =   255
            Index           =   1
            Left            =   180
            TabIndex        =   36
            Top             =   660
            Width           =   1335
         End
         Begin VB.CheckBox chkDoctorFlg 
            Caption         =   "�ʐڈ�"
            Height          =   255
            Index           =   0
            Left            =   180
            TabIndex        =   35
            Top             =   360
            Width           =   1335
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   "�����ݒ�"
         Height          =   4095
         Left            =   156
         TabIndex        =   15
         Top             =   494
         Width           =   6795
         Begin VB.ComboBox cboUsrGrp 
            Height          =   273
            Index           =   1
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   52
            Top             =   3640
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   0
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   24
            Top             =   360
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   1
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   23
            Top             =   720
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   2
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   22
            Top             =   1080
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   3
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   21
            Top             =   1440
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   4
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   20
            Top             =   1800
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   5
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   19
            Top             =   2160
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   6
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   18
            Top             =   2520
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   300
            Index           =   7
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   17
            Top             =   2880
            Width           =   1935
         End
         Begin VB.ComboBox cboAuth 
            Height          =   273
            Index           =   8
            Left            =   2280
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   16
            Top             =   3240
            Width           =   1935
         End
         Begin VB.Label Label1 
            Caption         =   "�����O���[�v"
            Height          =   182
            Index           =   14
            Left            =   240
            TabIndex        =   51
            Top             =   3692
            Width           =   1833
         End
         Begin VB.Label Label1 
            Caption         =   "�e�[�u�������e�i���X(&1):"
            Height          =   180
            Index           =   5
            Left            =   240
            TabIndex        =   33
            Top             =   420
            Width           =   1830
         End
         Begin VB.Label Label1 
            Caption         =   "�\��Ɩ�����(&2):"
            Height          =   180
            Index           =   6
            Left            =   240
            TabIndex        =   32
            Top             =   780
            Width           =   1830
         End
         Begin VB.Label Label1 
            Caption         =   "���ʓ��͌���(&3):"
            Height          =   180
            Index           =   7
            Left            =   240
            TabIndex        =   31
            Top             =   1140
            Width           =   1830
         End
         Begin VB.Label Label1 
            Caption         =   "������͌���(&4):"
            Height          =   180
            Index           =   8
            Left            =   240
            TabIndex        =   30
            Top             =   1500
            Width           =   1830
         End
         Begin VB.Label Label1 
            Caption         =   "����A�f�[�^���o����(&5):"
            Height          =   180
            Index           =   9
            Left            =   240
            TabIndex        =   29
            Top             =   1860
            Width           =   1950
         End
         Begin VB.Label Label1 
            Caption         =   "�����Ɩ�����(&6):"
            Height          =   180
            Index           =   10
            Left            =   240
            TabIndex        =   28
            Top             =   2220
            Width           =   1830
         End
         Begin VB.Label Label1 
            Caption         =   "���ъ��ݒ�(&7):"
            Height          =   180
            Index           =   11
            Left            =   240
            TabIndex        =   27
            Top             =   2580
            Width           =   1830
         End
         Begin VB.Label Label1 
            Caption         =   "���̑������Q(&8):"
            ForeColor       =   &H80000011&
            Height          =   180
            Index           =   12
            Left            =   240
            TabIndex        =   26
            Top             =   2940
            Width           =   1830
         End
         Begin VB.Label Label1 
            Caption         =   "���̑������R(&9):"
            ForeColor       =   &H80000011&
            Height          =   180
            Index           =   13
            Left            =   240
            TabIndex        =   25
            Top             =   3300
            Width           =   1830
         End
      End
      Begin VB.Label lblShortStc 
         Caption         =   "Label3"
         Height          =   255
         Left            =   -71580
         TabIndex        =   50
         Top             =   3180
         Width           =   3555
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "��{���"
      Height          =   2715
      Left            =   120
      TabIndex        =   12
      Top             =   120
      Width           =   7275
      Begin VB.ComboBox cboUsrGrp 
         Height          =   273
         Index           =   0
         Left            =   4940
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   54
         Top             =   2314
         Width           =   1677
      End
      Begin VB.CheckBox chkDelFlg 
         Caption         =   "���̃��[�U�𖳌��ɂ���(&D)"
         Height          =   255
         Left            =   1196
         TabIndex        =   13
         Top             =   2340
         Width           =   2355
      End
      Begin VB.TextBox txtEName 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   1200
         MaxLength       =   40
         TabIndex        =   9
         Text            =   "��������"
         Top             =   1872
         Width           =   5415
      End
      Begin VB.TextBox txtKName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   1200
         MaxLength       =   80
         TabIndex        =   7
         Text            =   "��������"
         Top             =   1508
         Width           =   5415
      End
      Begin VB.TextBox txtPassword 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   1200
         MaxLength       =   64
         PasswordChar    =   "*"
         TabIndex        =   3
         Text            =   "@@"
         Top             =   660
         Width           =   4815
      End
      Begin VB.TextBox txtUserID 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   1200
         MaxLength       =   20
         TabIndex        =   1
         Text            =   "@@"
         Top             =   300
         Width           =   2715
      End
      Begin VB.TextBox txtUserName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   1200
         MaxLength       =   20
         TabIndex        =   5
         Text            =   "��������"
         Top             =   1144
         Width           =   5415
      End
      Begin VB.Label Label1 
         Caption         =   "���[�U�[�O���[�v"
         Height          =   182
         Index           =   15
         Left            =   3718
         TabIndex        =   53
         Top             =   2366
         Width           =   1404
      End
      Begin VB.Label Label1 
         Caption         =   "�p����(&E):"
         Height          =   182
         Index           =   4
         Left            =   182
         TabIndex        =   8
         Top             =   1924
         Width           =   1404
      End
      Begin VB.Label Label1 
         Caption         =   "�J�i��(&K):"
         Height          =   182
         Index           =   3
         Left            =   182
         TabIndex        =   6
         Top             =   1573
         Width           =   1404
      End
      Begin VB.Label Label1 
         Caption         =   "�p�X���[�h(&P):"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   2
         Top             =   720
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "���[�U�h�c(&U):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   360
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "������(&N):"
         Height          =   182
         Index           =   1
         Left            =   182
         TabIndex        =   4
         Top             =   1209
         Width           =   1404
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4620
      TabIndex        =   10
      Top             =   8010
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6060
      TabIndex        =   11
      Top             =   8010
      Width           =   1335
   End
End
Attribute VB_Name = "frmHainsUser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrUserID          As String  '���[�U�R�[�h

Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private Const gTargetItemcd = "30910"
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

''## 2005.04.04 Add by ��
Private aryUserGrpCd()          As String       'User Group�i�z��́A�R���{�{�b�N�X�ƑΉ��j
Private arySecurityGrpCd()      As String       '���� Group�i�z��́A�R���{�{�b�N�X�ƑΉ��j
''## 2005.04.04 Add End ..



Friend Property Let UserID(ByVal vntNewValue As String)

    mstrUserID = vntNewValue
    
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
        
        '�h�c�̓��̓`�F�b�N
        If Trim(txtUserID.Text) = "" Then
            MsgBox "���[�U�h�c�����͂���Ă��܂���B", vbCritical, App.Title
            txtUserID.SetFocus
            Exit Do
        End If

        '�p�X���[�h�̓��̓`�F�b�N
        If Trim(txtPassword.Text) = "" Then
            MsgBox "�p�X���[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtPassword.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtUserName.Text) = "" Then
            MsgBox "���[�U�������͂���Ă��܂���B", vbCritical, App.Title
            txtUserName.SetFocus
            Exit Do
        End If
        
        
        If Trim(cboUsrGrp(0).Text) = "" Then
            MsgBox "���[�U�[�O���[�v���ݒ肳��Ă��܂���B", vbCritical, App.Title
            cboUsrGrp(0).SetFocus
            Exit Do
        End If
        
        If Trim(cboUsrGrp(1).Text) = "" Then
            MsgBox "�����O���[�v���ݒ肳��Ă��܂���B", vbCritical, App.Title
            cboUsrGrp(1).SetFocus
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
Private Function EditHainsUser() As Boolean

    Dim objHainsUser        As Object           '���[�U�A�N�Z�X�p
    Dim vntUserName         As Variant          '���[�U��
    Dim vntTntKa            As Variant
    Dim vntTntBt            As Variant
    Dim vntTntRm            As Variant
    Dim vntTntSy            As Variant
    Dim vntTntSt            As Variant
    Dim vntTntEd            As Variant
    Dim vntPassWord         As Variant
    Dim vntAuthTblMnt       As Variant
    Dim vntAuthRsv          As Variant
    Dim vntAuthRsl          As Variant
    Dim vntAuthJud          As Variant
    Dim vntAuthPrn          As Variant
    Dim vntAuthDmd          As Variant
    Dim vntDoctorFlg        As Variant
    Dim vntKname            As Variant
    Dim vntEname            As Variant
    
    Dim vntMenFlg           As Variant
    Dim vntHanFlg           As Variant
    Dim vntKanFlg           As Variant
    Dim vntEiFlg            As Variant
    Dim vntShinFlg          As Variant
    Dim vntIgnoreFlg        As Variant
    Dim vntAuthNote         As Variant
    Dim vntDefNoteDispKbn   As Variant
    Dim vntNaiFlg           As Variant
    Dim vntSentenceCd       As Variant
    Dim vntDelFlg           As Variant
    Dim vntShortStc         As Variant
    
    Dim vntAuthExt1         As Variant          '�\������1
    Dim vntAuthExt2         As Variant          '�\������2
    Dim vntAuthExt3         As Variant          '�\������3
    
'## 2005.04.04 Add by ���B���[�U�[�O���[�v , �����O���[�v �ǉ�
    Dim vntDeptCd           As Variant
    Dim vntUsrGrpCd         As Variant
'## 2005.04.04 Add End ...
    
    Dim Ret                 As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objHainsUser = CreateObject("HainsHainsUser.HainsUser")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrUserID = "" Then
            Ret = True
            Exit Do
        End If
        
        '���[�U�e�[�u�����R�[�h�ǂݍ���
'### 2002.03.31 Updated By H.Ishihara@FSIT
'        If objHainsUser.SelectHainsUser(mstrUserID, _
                                        vntUserName, _
                                        vntTntKa, _
                                        vntTntBt, _
                                        vntTntRm, _
                                        vntTntSy, _
                                        vntTntSt, _
                                        vntTntEd, _
                                        vntPassWord, _
                                        vntAuthTblMnt, _
                                        vntAuthRsv, _
                                        vntAuthRsl, _
                                        vntAuthJud, _
                                        vntAuthPrn, _
                                        vntAuthDmd, _
                                        vntDoctorFlg, _
                                        vntKname, _
                                        vntEname) = False Then
                          
                          
'## 2005.04.04 Updated by ���B���[�U�[�O���[�v , �����O���[�v �ǉ�
        If objHainsUser.SelectHainsUser(mstrUserID, vntUserName, _
                                        vntTntKa, vntTntBt, _
                                        vntTntRm, vntTntSy, _
                                        vntTntSt, vntTntEd, _
                                        vntPassWord, vntAuthTblMnt, _
                                        vntAuthRsv, vntAuthRsl, _
                                        vntAuthJud, vntAuthPrn, _
                                        vntAuthDmd, vntDoctorFlg, _
                                        vntKname, vntEname, _
                                        True, vntMenFlg, vntHanFlg, vntKanFlg, vntEiFlg, vntShinFlg, vntIgnoreFlg, _
                                        vntAuthNote, vntDefNoteDispKbn, vntNaiFlg, vntSentenceCd, vntDelFlg, vntShortStc, _
                                        vntAuthExt1, vntAuthExt2, vntAuthExt3, _
                                        vntDeptCd, vntUsrGrpCd) = False Then
'## 2005.04.04 Updated End ....
            
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtUserID.Text = mstrUserID
        txtUserName.Text = vntUserName
        txtPassword.Text = vntPassWord
        txtKName.Text = vntKname
        txtEName.Text = vntEname

        If vntDelFlg = "1" Then chkDelFlg.Value = vbChecked

        '���C������
        If vntAuthTblMnt = AUTHORITY_FULL Then cboAuth(0).ListIndex = 1
        If vntAuthRsv = AUTHORITY_FULL Then cboAuth(1).ListIndex = 1
        If vntAuthRsl = AUTHORITY_FULL Then cboAuth(2).ListIndex = 1
        If vntAuthJud = AUTHORITY_FULL Then cboAuth(3).ListIndex = 1
        If vntAuthPrn = AUTHORITY_FULL Then cboAuth(4).ListIndex = 1
        If vntAuthDmd = AUTHORITY_FULL Then cboAuth(5).ListIndex = 1
        If vntAuthExt1 = AUTHORITY_FULL Then cboAuth(6).ListIndex = 1
        If vntAuthExt2 = AUTHORITY_FULL Then cboAuth(7).ListIndex = 1
        If vntAuthExt3 = AUTHORITY_FULL Then cboAuth(8).ListIndex = 1
    
        '�h�N�^�[�t���O
        If vntMenFlg = 1 Then chkDoctorFlg(0).Value = vbChecked
        If vntHanFlg = 1 Then chkDoctorFlg(1).Value = vbChecked
        If vntKanFlg = 1 Then chkDoctorFlg(2).Value = vbChecked
        If vntEiFlg = 1 Then chkDoctorFlg(3).Value = vbChecked
        If vntShinFlg = 1 Then chkDoctorFlg(4).Value = vbChecked
        If vntNaiFlg = 1 Then chkDoctorFlg(5).Value = vbChecked
        
        '���̑�
        If vntIgnoreFlg = 1 Then chkIgnoreFlg.Value = vbChecked
        If IsNumeric(vntAuthNote) Then
            cboAuthNote.ListIndex = CInt(vntAuthNote)
        End If
        
        If IsNumeric(vntDefNoteDispKbn) And Trim(vntDefNoteDispKbn) <> "" Then
            cboDefNoteDispKbn.ListIndex = CInt(vntDefNoteDispKbn)
        End If

        txtSentenceCd.Text = vntSentenceCd
        lblShortStc.Caption = vntShortStc

''' ### 2005.04.04 Add by ��
        If Trim(vntDeptCd) <> "" Then cboUsrGrp(0).ListIndex = SetUsrGrpIndex(CStr(vntDeptCd), 0)
        If Trim(vntUsrGrpCd) <> "" Then cboUsrGrp(1).ListIndex = SetUsrGrpIndex(CStr(vntUsrGrpCd), 1)
''' ### 2005.04.04 Add End ...

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditHainsUser = Ret
    
    Exit Function

ErrorHandle:

    EditHainsUser = False
    MsgBox Err.Description, vbCritical
    
End Function

' ### 2005.04.04 Add by ��
'
' �@�\�@�@ : ComboBox ListIndex Setting ..
' �����@�@ : �L�[�R�[�h�A�C���f�b�N�X
' �߂�l�@ : Listindex Value
' ���l�@�@ :
'
Private Function SetUsrGrpIndex(GrpCd As String, Optional idx As Integer) As Integer
    Dim i       As Integer
    
    If idx = 0 Then
        For i = 0 To UBound(aryUserGrpCd())
            If Trim(aryUserGrpCd(i)) = Trim(GrpCd) Then
                SetUsrGrpIndex = i
                Exit For
            End If
        Next i
    
    ElseIf idx = 1 Then
        For i = 0 To UBound(arySecurityGrpCd())
            If Trim(arySecurityGrpCd(i)) = Trim(GrpCd) Then
                SetUsrGrpIndex = i
                Exit For
            End If
        Next i
    End If

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
Private Function RegistHainsUser() As Boolean

On Error GoTo ErrorHandle

    Dim objHainsUser   As Object       '���[�U�A�N�Z�X�p
    Dim Ret         As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objHainsUser = CreateObject("HainsHainsUser.HainsUser")
    
    
'' ### 2005.04.04  Edit by ��
    '���[�U�e�[�u�����R�[�h�̓o�^
'    Ret = objHainsUser.RegistHainsUser(IIf(txtUserID.Enabled, "INS", "UPD"), _
'                                       UCase(Trim(txtUserID.Text)), _
'                                       Trim(txtUserName.Text), _
'                                       UCase(Trim(txtPassword.Text)), _
'                                       IIf(chkDelFlg.Value = vbChecked, "1", ""), _
'                                       IIf(cboAuth(0).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(1).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(2).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(3).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(4).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(5).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(6).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(7).ListIndex = 1, 2, 0), _
'                                       IIf(cboAuth(8).ListIndex = 1, 2, 0), _
'                                       IIf(chkDoctorFlg(0).Value = vbChecked, 1, 0), _
'                                       IIf(chkDoctorFlg(1).Value = vbChecked, 1, 0), _
'                                       IIf(chkDoctorFlg(2).Value = vbChecked, 1, 0), _
'                                       IIf(chkDoctorFlg(3).Value = vbChecked, 1, 0), _
'                                       IIf(chkDoctorFlg(4).Value = vbChecked, 1, 0), _
'                                       IIf(chkDoctorFlg(5).Value = vbChecked, 1, 0), _
'                                       IIf(chkIgnoreFlg.Value = vbChecked, 1, 0), _
'                                       cboAuthNote.ListIndex, _
'                                       Trim(txtKName.Text), Trim(txtEName.Text), _
'                                       Trim(txtSentenceCd.Text), _
'                                       IIf(cboDefNoteDispKbn.ListIndex = 0, "", cboDefNoteDispKbn.ListIndex))


' #### ���[�U�[�O���[�v , �����O���[�v �ǉ�
    Ret = objHainsUser.RegistHainsUser(IIf(txtUserID.Enabled, "INS", "UPD"), _
                                       UCase(Trim(txtUserID.Text)), _
                                       Trim(txtUserName.Text), _
                                       UCase(Trim(txtPassword.Text)), _
                                       IIf(chkDelFlg.Value = vbChecked, "1", ""), _
                                       IIf(cboAuth(0).ListIndex = 1, 2, 0), IIf(cboAuth(1).ListIndex = 1, 2, 0), _
                                       IIf(cboAuth(2).ListIndex = 1, 2, 0), IIf(cboAuth(3).ListIndex = 1, 2, 0), _
                                       IIf(cboAuth(4).ListIndex = 1, 2, 0), IIf(cboAuth(5).ListIndex = 1, 2, 0), _
                                       IIf(cboAuth(6).ListIndex = 1, 2, 0), IIf(cboAuth(7).ListIndex = 1, 2, 0), _
                                       IIf(cboAuth(8).ListIndex = 1, 2, 0), _
                                       IIf(chkDoctorFlg(0).Value = vbChecked, 1, 0), _
                                       IIf(chkDoctorFlg(1).Value = vbChecked, 1, 0), _
                                       IIf(chkDoctorFlg(2).Value = vbChecked, 1, 0), _
                                       IIf(chkDoctorFlg(3).Value = vbChecked, 1, 0), _
                                       IIf(chkDoctorFlg(4).Value = vbChecked, 1, 0), _
                                       IIf(chkDoctorFlg(5).Value = vbChecked, 1, 0), _
                                       IIf(chkIgnoreFlg.Value = vbChecked, 1, 0), _
                                       cboAuthNote.ListIndex, _
                                       Trim(txtKName.Text), Trim(txtEName.Text), _
                                       Trim(txtSentenceCd.Text), _
                                       IIf(cboDefNoteDispKbn.ListIndex = 0, "", cboDefNoteDispKbn.ListIndex), _
                                       aryUserGrpCd(cboUsrGrp(0).ListIndex), _
                                       arySecurityGrpCd(cboUsrGrp(1).ListIndex))

'' ### 2005.04.04  Edit�@End ...


    If Ret = 0 Then
        MsgBox "���͂��ꂽ���[�U�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistHainsUser = False
        Exit Function
    End If
    
    RegistHainsUser = True
    
    Exit Function
    
ErrorHandle:

    RegistHainsUser = False
    MsgBox Err.Description, vbCritical
    
End Function


Private Sub cboUsrGrp_Click(Index As Integer)
    
    If Index = 0 Then           '���[�U�[�O���[�v
        '' �����O���[�v���X�g��ǂ�ŗ���
        If EditUserGrp(1) = False Then Exit Sub
    End If

End Sub

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
        
        '���[�U�e�[�u���̓o�^
        If RegistHainsUser() = False Then
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

Private Sub Command1_Click()

End Sub

Private Sub cmdSentenceCd_Click()

    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '���ڃK�C�h�\���p
    Dim vntCode         As Variant
    Dim vntName         As Variant

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = False  '�����I���̓��[�h�ɂ���
        .TargetTable = getSentence
        .ItemType = 0
        .ItemCd = gTargetItemcd
    
        '���̓K�C�h��ʂ��J��
        .Show vbModal
    
        '�I������Ă���Ȃ�R�[�h�Z�b�g
        If .RecordCount > 0 Then
            txtSentenceCd.Text = .RecordCode(0)
            lblShortStc.Caption = .RecordName(0)
        End If
    
    End With

    Set objCommonGuide = Nothing

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
    Dim i   As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    SSTab1.Tab = 0
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    For i = 0 To 8
        With cboAuth(i)
            .Clear
            .AddItem "�g�p�ł��܂���"
            .AddItem "�g�p�\"
            .ListIndex = 0
        End With
    Next i

    With cboAuthNote
        .AddItem "�R�����g�����Ȃ�"
        .AddItem "���"
        .AddItem "����"
        .AddItem "��Á{����"
        .ListIndex = 0
    End With

    With cboDefNoteDispKbn
        .AddItem ""
        .AddItem "��×D��"
        .AddItem "�����D��"
        .ListIndex = 0
    End With

    Do
        
''' #### 2005.04.04   Add by ��
        '���[�U�[�O���[�v���
        If EditUserGrp(0) = False Then
            Exit Do
        End If
''' #### 2005.04.04   Add�@End ..
        
        
        '���[�U���̕ҏW
        If EditHainsUser() = False Then
            Exit Do
        End If
        
    
        '�C�l�[�u���ݒ�
        txtUserID.Enabled = (txtUserID.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

'
' �@�\�@�@ :
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
' �@�\���� :
' ���l�@�@ :
'
Private Function EditUserGrp(idx As Integer) As Boolean
    Dim objItem                 As Object           '�R�[�X�A�N�Z�X�p
    Dim vntUserGrpCd            As Variant
    Dim vntUserGrpName          As Variant
    Dim lngCount                As Long             '���R�[�h��
    Dim i                       As Long             '�C���f�b�N�X
    Dim iMode                   As Integer
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
    
    EditUserGrp = False
    cboUsrGrp(idx).Clear
    
    Select Case idx
        Case 0                   '���[�U�[�O���[�v
            iMode = 0
            strKey = "UGR"
            Erase aryUserGrpCd
            
        Case 1                  '�Z�L�����e�B�[�O���[�v
            iMode = 1
            strKey = aryUserGrpCd(cboUsrGrp(0).ListIndex)
            Erase arySecurityGrpCd
        
    End Select
        
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsFree.Free")
    lngCount = objItem.SelectFreeByClassCd(iMode, _
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
        MsgBox "���[�U�[�O���[�v�����݂��Ȃ��ł��B", vbExclamation
        Exit Function
    End If
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        If idx = 0 Then
            ReDim Preserve aryUserGrpCd(i)
            aryUserGrpCd(i) = vntFreeCd(i)
        ElseIf idx = 1 Then
            ReDim Preserve arySecurityGrpCd(i)
            arySecurityGrpCd(i) = vntFreeCd(i)
        End If
        cboUsrGrp(idx).AddItem vntFreeField1(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    
    EditUserGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function


