VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmCourseRsvGrp 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�R�[�X��f�\��Q�e�[�u�������e�i���X"
   ClientHeight    =   5715
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5340
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCourseRsvGrp.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5715
   ScaleWidth      =   5340
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1200
      TabIndex        =   22
      Top             =   5340
      Width           =   1275
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   5115
      Left            =   120
      TabIndex        =   21
      Top             =   120
      Width           =   5115
      _ExtentX        =   9022
      _ExtentY        =   9022
      _Version        =   393216
      Style           =   1
      Tabs            =   1
      TabHeight       =   520
      TabCaption(0)   =   "��{���"
      TabPicture(0)   =   "frmCourseRsvGrp.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Image1"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Label1"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Frame1"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Frame2"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "Frame3"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).ControlCount=   5
      Begin VB.Frame Frame3 
         Caption         =   "�g�ݒ莞�̃f�t�H���g�l��(&D)"
         Height          =   1635
         Left            =   120
         TabIndex        =   8
         Top             =   3360
         Width           =   4875
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   10
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_m 
            Height          =   285
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   14
            Text            =   "@@@"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_f 
            Height          =   285
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   18
            Text            =   "@@@"
            Top             =   1080
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_sat 
            Height          =   285
            Left            =   3960
            MaxLength       =   3
            TabIndex        =   12
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_sat_m 
            Height          =   285
            IMEMode         =   2  '��
            Left            =   3960
            MaxLength       =   3
            TabIndex        =   16
            Text            =   "@@@"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_sat_f 
            Height          =   285
            IMEMode         =   2  '��
            Left            =   3960
            MaxLength       =   3
            TabIndex        =   20
            Text            =   "@@@"
            Top             =   1080
            Width           =   555
         End
         Begin VB.Label Label4 
            AutoSize        =   -1  'True
            Caption         =   "����(&C):"
            Height          =   180
            Left            =   300
            TabIndex        =   9
            Top             =   420
            Width           =   630
         End
         Begin VB.Label Label5 
            AutoSize        =   -1  'True
            Caption         =   "�j��(&M):"
            Height          =   180
            Left            =   300
            TabIndex        =   13
            Top             =   780
            Width           =   645
         End
         Begin VB.Label Label6 
            AutoSize        =   -1  'True
            Caption         =   "����(&F):"
            Height          =   180
            Left            =   300
            TabIndex        =   17
            Top             =   1140
            Width           =   615
         End
         Begin VB.Label Label7 
            AutoSize        =   -1  'True
            Caption         =   "�y�j������(&S):"
            Height          =   180
            Left            =   2520
            TabIndex        =   11
            Top             =   420
            Width           =   1155
         End
         Begin VB.Label Label8 
            AutoSize        =   -1  'True
            Caption         =   "�y�j���i�j���j(&O):"
            Height          =   180
            Left            =   2520
            TabIndex        =   15
            Top             =   780
            Width           =   1350
         End
         Begin VB.Label Label9 
            AutoSize        =   -1  'True
            Caption         =   "�y�j���i�����j(&N):"
            Height          =   180
            Left            =   2520
            TabIndex        =   19
            Top             =   1140
            Width           =   1350
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   "�j���ʘg�Ǘ�(&G)"
         Height          =   855
         Left            =   120
         TabIndex        =   5
         Top             =   2400
         Width           =   4875
         Begin VB.OptionButton optMngGender 
            Caption         =   "����(&Y)"
            Height          =   255
            Index           =   1
            Left            =   1440
            TabIndex        =   7
            Top             =   360
            Width           =   915
         End
         Begin VB.OptionButton optMngGender 
            Caption         =   "���Ȃ�(&N)"
            Height          =   255
            Index           =   0
            Left            =   300
            TabIndex        =   6
            Top             =   360
            Value           =   -1  'True
            Width           =   1095
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   "��{���(&B)"
         Height          =   1215
         Left            =   120
         TabIndex        =   0
         Top             =   1110
         Width           =   4875
         Begin VB.ComboBox cboRsvGrp 
            Height          =   300
            Left            =   1200
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   4
            Top             =   690
            Width           =   2955
         End
         Begin VB.ComboBox cboCourse 
            Height          =   300
            Left            =   1200
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   2
            Top             =   330
            Width           =   2955
         End
         Begin VB.Label Label2 
            AutoSize        =   -1  'True
            Caption         =   "�\��Q(&R):"
            Height          =   180
            Left            =   240
            TabIndex        =   3
            Top             =   720
            Width           =   810
         End
         Begin VB.Label Label3 
            Caption         =   "�R�[�X(&C):"
            Height          =   195
            Left            =   240
            TabIndex        =   1
            Top             =   360
            Width           =   1275
         End
      End
      Begin VB.Label Label1 
         Caption         =   "�R�[�X���ƂɊǗ��ΏۂƂȂ�\��Q���`���܂��B"
         Height          =   180
         Left            =   960
         TabIndex        =   25
         Top             =   600
         Width           =   3495
      End
      Begin VB.Image Image1 
         Height          =   480
         Left            =   300
         Picture         =   "frmCourseRsvGrp.frx":0028
         Top             =   480
         Width           =   480
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   2580
      TabIndex        =   23
      Top             =   5340
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   3960
      TabIndex        =   24
      Top             =   5340
      Width           =   1275
   End
End
Attribute VB_Name = "frmCourseRsvGrp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p�̈�
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnShowOnly        As Boolean  'TRUE:�f�[�^�̍X�V�����Ȃ��i�Q�Ƃ̂݁j
Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s

Private mstrCsCd            As String   '�R�[�X�R�[�h�i�z��́A�R���{�{�b�N�X�ƑΉ��j
Private mstrRsvGrpCd        As String   '�\��Q�R�[�h�i�z��́A�R���{�{�b�N�X�ƑΉ��j

Private mstrArrCsCd()       As String   '�R�[�X�R�[�h�R���{�Ή��L�[�i�[�̈�
Private mstrArrRsvGrpCd()   As String   '�\��Q�R�[�h�R���{�Ή��L�[�i�[�̈�

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
' �@�\�@�@ : ��{�\��g����ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �\��g�̊�{������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditCourseRsvGrp() As Boolean

    Dim objSchedule         As Object   '�X�P�W���[�����A�N�Z�X�p
    
    Dim vntMngGender        As Variant  '�j���ʘg�Ǘ�
    Dim vntDefCnt           As Variant  '���ʐl��
    Dim vntDefCnt_M         As Variant  '�j�l��
    Dim vntDefCnt_F         As Variant  '���l��
    Dim vntDefCnt_Sat       As Variant  '�y�j���ʐl��
    Dim vntDefCnt_Sat_M     As Variant  '�y�j�j�l��
    Dim vntDefCnt_Sat_F     As Variant  '�y�j���l��
    
    Dim Ret                 As Boolean  '�֐��߂�l
    Dim i                   As Long     '�C���f�b�N�X
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSchedule = CreateObject("HainsSchedule.Schedule")
    
    Do
        '�R�[�X��f�\��Q���R�[�h�ǂݍ���
        If objSchedule.SelectCourseRsvGrp(mstrCsCd, mstrRsvGrpCd, vntMngGender, vntDefCnt, vntDefCnt_M, vntDefCnt_F, vntDefCnt_Sat, vntDefCnt_Sat_M, vntDefCnt_Sat_F) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
        
        '�ǂݍ��ݓ��e�̕ҏW
        optMngGender(CLng(vntMngGender)).Value = True
        txtDefCnt.Text = vntDefCnt
        txtDefCnt_m.Text = vntDefCnt_M
        txtDefCnt_f.Text = vntDefCnt_F
        txtDefCnt_sat.Text = vntDefCnt_Sat
        txtDefCnt_sat_m.Text = vntDefCnt_Sat_M
        txtDefCnt_sat_f.Text = vntDefCnt_Sat_F
        
        '�R���{�{�b�N�X�̕ҏW
        For i = 0 To UBound(mstrArrCsCd)
            If mstrArrCsCd(i) = mstrCsCd Then
                cboCourse.ListIndex = i + 1
            End If
        Next i
        
        For i = 0 To UBound(mstrArrRsvGrpCd)
            If mstrArrRsvGrpCd(i) = mstrRsvGrpCd Then
                cboRsvGrp.ListIndex = i + 1
            End If
        Next i
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditCourseRsvGrp = Ret
    
    Exit Function

ErrorHandle:

    EditCourseRsvGrp = False
    MsgBox Err.Description, vbCritical
    
End Function

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
        
        '�R�[�X��f�\��Q�e�[�u���̓o�^
        If RegistCourseRsvGrp() = False Then Exit Do
        
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
' �@�\�@�@ : �\��g��{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e��\��g�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistCourseRsvGrp() As Boolean

    Dim objSchedule     As Object   '�X�P�W���[�����A�N�Z�X�p
    Dim lngMngGender    As Long     '�j���ʘg�Ǘ�
    Dim lngRet          As Long     '�֐��߂�l
    
    On Error GoTo ErrorHandle
    
    RegistCourseRsvGrp = False

    '�j���ʘg�Ǘ��̐ݒ�
    Select Case True
        Case optMngGender(0).Value
            lngMngGender = 0
        Case optMngGender(1).Value
            lngMngGender = 1
    End Select

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSchedule = CreateObject("HainsSchedule.Schedule")

    '�R�[�X��f�\��Q�e�[�u�����R�[�h�̓o�^
    lngRet = objSchedule.RegistCourseRsvGrp( _
                 IIf(cboCourse.Enabled, "INS", "UPD"), _
                 mstrArrCsCd(cboCourse.ListIndex - 1), _
                 mstrArrRsvGrpCd(cboRsvGrp.ListIndex - 1), _
                 lngMngGender, _
                 IIf(txtDefCnt.Enabled, Trim(txtDefCnt.Text), 0), _
                 IIf(txtDefCnt_m.Enabled, Trim(txtDefCnt_m.Text), 0), _
                 IIf(txtDefCnt_f.Enabled, Trim(txtDefCnt_f.Text), 0), _
                 IIf(txtDefCnt_sat.Enabled, Trim(txtDefCnt_sat.Text), 0), _
                 IIf(txtDefCnt_sat_m.Enabled, Trim(txtDefCnt_sat_m.Text), 0), _
                 IIf(txtDefCnt_sat_f.Enabled, Trim(txtDefCnt_sat_f.Text), 0) _
             )
    
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "���͂��ꂽ�R�[�X��f�\��Q�͊��ɑ��݂��܂��B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical, Me.Caption
        Exit Function
    End If
        
    mstrCsCd = mstrArrCsCd(cboCourse.ListIndex - 1)
    mstrRsvGrpCd = mstrArrRsvGrpCd(cboRsvGrp.ListIndex - 1)
    cboCourse.Enabled = False
    cboRsvGrp.Enabled = False
    
    RegistCourseRsvGrp = True
    
    Exit Function
    
ErrorHandle:

    RegistCourseRsvGrp = False
    
    MsgBox Err.Description, vbCritical
    
End Function

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
                
        '�R�[�X�R���{�̕\���ҏW
        If EditCourse() = False Then
            Exit Do
        End If
                
        '�\��Q�R���{�̕\���ҏW
        If EditRsvGrp() = False Then
            Exit Do
        End If
                
        '�\��g���̕\���ҏW
        If mstrCsCd <> "" And mstrRsvGrpCd <> "" Then
            If EditCourseRsvGrp() = False Then
                Exit Do
            End If
        End If
        
        '�C�l�[�u���ݒ�
        cboCourse.Enabled = (mstrCsCd = "")
        cboRsvGrp.Enabled = (mstrRsvGrpCd = "")
        
        Select Case True
            Case optMngGender(0).Value
                Call EnableControl(0)
            Case optMngGender(1).Value
                Call EnableControl(1)
        End Select
        
        Ret = True
        Exit Do
    
    Loop
    
    '�Q�Ɛ�p�̏ꍇ�A�o�^�n�R���g���[�����~�߂�
    If mblnShowOnly = True Then
        
        cboCourse.Enabled = False
        cboRsvGrp.Enabled = False
        
        optMngGender(0).Enabled = False
        optMngGender(1).Enabled = False
        
        txtDefCnt.Enabled = False
        txtDefCnt_m.Enabled = False
        txtDefCnt_f.Enabled = False
        txtDefCnt_sat.Enabled = False
        txtDefCnt_sat_m.Enabled = False
        txtDefCnt_sat_f.Enabled = False
        
        cmdOk.Enabled = False
        cmdApply.Enabled = False
    
    End If
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Friend Property Get RsvGrpCd() As Variant

    RsvGrpCd = mstrRsvGrpCd
    
End Property

Friend Property Let RsvGrpCd(ByVal vNewValue As Variant)
    
    mstrRsvGrpCd = vNewValue

End Property

Friend Property Get CsCd() As Variant

    CsCd = mstrCsCd
    
End Property

Friend Property Let CsCd(ByVal vNewValue As Variant)
    
    mstrCsCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

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

    Dim Ret             As Boolean  '�֐��߂�l
    Dim i               As Integer
    
    '��������
    Ret = False
    
    Do
    
        '�R�[�X���I����
        If cboCourse.ListIndex <= 0 Then
            MsgBox "�R�[�X��I�����Ă��������B", vbExclamation, App.Title
            cboCourse.SetFocus
            Exit Do
        End If
        
        '�\��Q���I����
        If cboRsvGrp.ListIndex <= 0 Then
            MsgBox "�\��Q��I�����Ă��������B", vbExclamation, App.Title
            cboRsvGrp.SetFocus
            Exit Do
        End If
        
        '�f�t�H���g�l���󔒂Ȃ�O�Z�b�g
        If Trim(txtDefCnt.Text) = "" Then
            txtDefCnt.Text = 0
        End If
        
        If Trim(txtDefCnt_m.Text) = "" Then
            txtDefCnt_m.Text = 0
        End If
        
        If Trim(txtDefCnt_f.Text) = "" Then
            txtDefCnt_f.Text = 0
        End If
        
        If Trim(txtDefCnt_sat.Text) = "" Then
            txtDefCnt_sat.Text = 0
        End If
        
        If Trim(txtDefCnt_sat_m.Text) = "" Then
            txtDefCnt_sat_m.Text = 0
        End If
        
        If Trim(txtDefCnt_sat_f.Text) = "" Then
            txtDefCnt_sat_f.Text = 0
        End If
        
        '���l�`�F�b�N
        If txtDefCnt.Enabled Then
            If CheckInteger(txtDefCnt.Text) = False Then
                MsgBox "�f�t�H���g�l���ɂ͐��l���Z�b�g���Ă�������", vbExclamation, App.Title
                txtDefCnt.SetFocus
                Exit Do
            End If
        End If
        
        '���l�`�F�b�N
        If txtDefCnt_m.Enabled Then
            If CheckInteger(txtDefCnt_m.Text) = False Then
                MsgBox "�f�t�H���g�l���ɂ͐��l���Z�b�g���Ă�������", vbExclamation, App.Title
                txtDefCnt_m.SetFocus
                Exit Do
            End If
        End If
        
        '���l�`�F�b�N
        If txtDefCnt_f.Enabled Then
            If CheckInteger(txtDefCnt_f.Text) = False Then
                MsgBox "�f�t�H���g�l���ɂ͐��l���Z�b�g���Ă�������", vbExclamation, App.Title
                txtDefCnt_f.SetFocus
                Exit Do
            End If
        End If
        
        '���l�`�F�b�N
        If txtDefCnt_sat.Enabled Then
            If CheckInteger(txtDefCnt_sat.Text) = False Then
                MsgBox "�f�t�H���g�l���ɂ͐��l���Z�b�g���Ă�������", vbExclamation, App.Title
                txtDefCnt_sat.SetFocus
                Exit Do
            End If
        End If
            
        '���l�`�F�b�N
        If txtDefCnt_sat_m.Enabled Then
            If CheckInteger(txtDefCnt_sat_m.Text) = False Then
                MsgBox "�f�t�H���g�l���ɂ͐��l���Z�b�g���Ă�������", vbExclamation, App.Title
                txtDefCnt_sat_m.SetFocus
                Exit Do
            End If
        End If
            
        '���l�`�F�b�N
        If txtDefCnt_sat_f.Enabled Then
            If CheckInteger(txtDefCnt_sat_f.Text) = False Then
                MsgBox "�f�t�H���g�l���ɂ͐��l���Z�b�g���Ă�������", vbExclamation, App.Title
                txtDefCnt_sat_f.SetFocus
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
' �@�\�@�@ : �R�[�X���̃f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �R�[�X���̃f�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditCourse() As Boolean

    Dim objCourse       As Object   '�R�[�X���A�N�Z�X�p
    
    Dim vntCsCd         As Variant  '�R�[�X�R�[�h
    Dim vntCsName       As Variant  '�R�[�X��
    Dim lngCount        As Long     '���R�[�h��
    
    Dim i               As Long     '�C���f�b�N�X
    
    On Error GoTo ErrorHandle
    
    EditCourse = False
    
    cboCourse.Clear
    Erase mstrArrCsCd

    '��̃R���{���쐬
    cboCourse.AddItem ""

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName)
    Set objCourse = Nothing
    
    If lngCount < 0 Then
        MsgBox "�R�[�X�e�[�u���ǂݍ��ݒ��ɃV�X�e���I�ȃG���[���������܂����B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    If lngCount = 0 Then
        MsgBox "�R�[�X���o�^����Ă��܂���B�R�[�X��o�^���Ă���R�[�X��f�\��Q��o�^���Ă��������B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrCsCd(i)
        mstrArrCsCd(i) = vntCsCd(i)
        cboCourse.AddItem vntCsName(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    cboCourse.ListIndex = 0
    
    EditCourse = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �\��Q�f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �\��Q�f�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditRsvGrp() As Boolean

    Dim objSchedule     As Object   '�X�P�W���[�����A�N�Z�X�p
    
    Dim vntRsvGrpCd     As Variant  '�\��Q�R�[�h
    Dim vntRsvGrpName   As Variant  '�\��Q����
    Dim lngCount        As Long     '���R�[�h��
    Dim i               As Long     '�C���f�b�N�X
    
    EditRsvGrp = False
    
    cboRsvGrp.Clear
    Erase mstrArrRsvGrpCd

    '��̃R���{���쐬
    cboRsvGrp.AddItem ""
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSchedule = CreateObject("HainsSchedule.Schedule")
    lngCount = objSchedule.SelectRsvGrpList(, vntRsvGrpCd, vntRsvGrpName)
    
    If lngCount < 0 Then
        MsgBox "�\��Q�e�[�u���ǂݍ��ݒ��ɃV�X�e���I�ȃG���[���������܂����B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    If lngCount = 0 Then
        MsgBox "�\��Q���o�^����Ă��܂���B�\��Q��o�^���Ă���R�[�X��f�\��Q��o�^���Ă��������B", vbExclamation, Me.Caption
        Exit Function
    End If

    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrRsvGrpCd(i)
        mstrArrRsvGrpCd(i) = vntRsvGrpCd(i)
        cboRsvGrp.AddItem vntRsvGrpName(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    cboRsvGrp.ListIndex = 0
    
    EditRsvGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub EnableControl(ByRef Index As Integer)

    '�C�l�[�u������
    txtDefCnt.Enabled = (Index = 0)
    txtDefCnt_m.Enabled = (Index = 1)
    txtDefCnt_f.Enabled = (Index = 1)
    txtDefCnt_sat.Enabled = (Index = 0)
    txtDefCnt_sat_m.Enabled = (Index = 1)
    txtDefCnt_sat_f.Enabled = (Index = 1)

    txtDefCnt.BackColor = IIf(Index = 0, vbWindowBackground, vbButtonFace)
    txtDefCnt_m.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)
    txtDefCnt_f.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)
    txtDefCnt_sat.BackColor = IIf(Index = 0, vbWindowBackground, vbButtonFace)
    txtDefCnt_sat_m.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)
    txtDefCnt_sat_f.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)

End Sub

Private Sub optMngGender_Click(Index As Integer)

    Call EnableControl(Index)

End Sub
