VERSION 5.00
Begin VB.Form frmFree 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�ėp�e�[�u�������e�i���X"
   ClientHeight    =   6045
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6405
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmFree.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6045
   ScaleWidth      =   6405
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtFreeField7 
      Height          =   480
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   26
      Text            =   "frmFree.frx":000C
      Top             =   4980
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField6 
      Height          =   480
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   24
      Text            =   "frmFree.frx":003F
      Top             =   4440
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField5 
      Height          =   480
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   22
      Text            =   "frmFree.frx":0072
      Top             =   3900
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField4 
      Height          =   480
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   20
      Text            =   "frmFree.frx":00A5
      Top             =   3360
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField3 
      Height          =   480
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   18
      Text            =   "frmFree.frx":00D8
      Top             =   2820
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField2 
      Height          =   480
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   16
      Text            =   "frmFree.frx":010B
      Top             =   2280
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField1 
      Height          =   480
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   14
      Text            =   "frmFree.frx":013E
      Top             =   1740
      Width           =   4635
   End
   Begin VB.TextBox txtFreeClassCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "@@@"
      Top             =   480
      Width           =   555
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmFree.frx":0171
      Left            =   1680
      List            =   "frmFree.frx":0178
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   7
      Top             =   1260
      Width           =   735
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmFree.frx":0182
      Left            =   2700
      List            =   "frmFree.frx":0189
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   9
      Top             =   1260
      Width           =   555
   End
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmFree.frx":0191
      Left            =   3600
      List            =   "frmFree.frx":0198
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   11
      Top             =   1260
      Width           =   555
   End
   Begin VB.TextBox txtFreeName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   25
      TabIndex        =   5
      Text            =   "��������������������������������������������������"
      Top             =   900
      Width           =   4635
   End
   Begin VB.TextBox txtFreeCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   12
      TabIndex        =   1
      Text            =   "@@@@@@@@@@@@"
      Top             =   120
      Width           =   1635
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3540
      TabIndex        =   27
      Top             =   5640
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4980
      TabIndex        =   28
      Top             =   5640
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�t�B�[���h�V(&7):"
      Height          =   240
      Index           =   10
      Left            =   120
      TabIndex        =   25
      Top             =   5040
      Width           =   1470
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�t�B�[���h�U(&6):"
      Height          =   240
      Index           =   9
      Left            =   120
      TabIndex        =   23
      Top             =   4500
      Width           =   1470
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�t�B�[���h�T(&5):"
      Height          =   240
      Index           =   8
      Left            =   120
      TabIndex        =   21
      Top             =   3960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�t�B�[���h�S(&4):"
      Height          =   240
      Index           =   7
      Left            =   120
      TabIndex        =   19
      Top             =   3420
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�t�B�[���h�R(&3):"
      Height          =   240
      Index           =   6
      Left            =   120
      TabIndex        =   17
      Top             =   2880
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�t�B�[���h�Q(&2):"
      Height          =   240
      Index           =   5
      Left            =   120
      TabIndex        =   15
      Top             =   2340
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp���ރR�[�h(&B):"
      Height          =   180
      Index           =   4
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�t�B�[���h�P(&1):"
      Height          =   240
      Index           =   3
      Left            =   120
      TabIndex        =   13
      Top             =   1800
      Width           =   1410
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   2460
      TabIndex        =   8
      Top             =   1320
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   3300
      TabIndex        =   10
      Top             =   1320
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   3
      Left            =   4200
      TabIndex        =   12
      Top             =   1320
      Width           =   555
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp���t(&D):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   6
      Top             =   1320
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp��(&N):"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�ėp�R�[�h(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmFree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrFreeCd              As String       '�ėp�R�[�h
Private mblnInitialize          As Boolean      'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean      'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrFreeDate            As String       '�ėp���t

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Public Property Let FreeCd(ByVal vntNewValue As Variant)

    mstrFreeCd = vntNewValue

End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Get Initialize() As Boolean

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

    Dim Ret         As Boolean      '�֐��߂�l
    Dim strDate     As String       '���t�`�F�b�N�p������
    
    Ret = False
    
    Do
        '�R�[�h�̓��̓`�F�b�N
        If Trim(txtFreeCd.Text) = "" Then
            MsgBox "�ėp�R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtFreeCd.SetFocus
            Exit Do
        End If

        '�ėp���ރR�[�h�̓��̓`�F�b�N
        If Trim(txtFreeClassCd.Text) = "" Then
            MsgBox "�ėp���ރR�[�h�����͂���Ă��܂���B(�s���ȏꍇ��""XXX""���Z�b�g���Ă�������)", vbCritical, App.Title
            txtFreeClassCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtFreeName.Text) = "" Then
            MsgBox "�ėp�������͂���Ă��܂���B", vbCritical, App.Title
            txtFreeName.SetFocus
            Exit Do
        End If

        '���t�R���{���ǂꂩ�ЂƂł��I������Ă���ꍇ
        If (cboYear.ListIndex > 0) Or _
           (cboMonth.ListIndex > 0) Or _
           (cboDay.ListIndex > 0) Then
        
            strDate = cboYear.List(cboYear.ListIndex) & "/" & _
                      Format(cboMonth.List(cboMonth.ListIndex), "00") & "/" & _
                      Format(cboDay.List(cboDay.ListIndex), "00")
    
            '���t�������̃`�F�b�N
            If IsDate(strDate) = False Then
                MsgBox "���������t����͂��Ă�������", vbExclamation, App.Title
                cboMonth.SetFocus
                Exit Do
            End If
        
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
Private Function EditFree() As Boolean

    Dim objFree         As Object           '�ėp�e�[�u���A�N�Z�X�p

    Dim vntFreeCd       As Variant
    Dim vntFreeClassCd  As Variant
    Dim vntFreeName     As Variant
    Dim vntFreeDate     As Variant
    Dim vntFreeField1   As Variant
    Dim vntFreeField2   As Variant
    Dim vntFreeField3   As Variant
    Dim vntFreeField4   As Variant
    Dim vntFreeField5   As Variant
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
    Dim vntFreeField6   As Variant
    Dim vntFreeField7   As Variant
'### 2003.02.15 Added End
    
    Dim Ret         As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrFreeCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�ėp�e�[�u�����R�[�h�ǂݍ���
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
'        If objFree.SelectFree(0, _
                              mstrFreeCd, _
                              vntFreeCd, _
                              vntFreeName, _
                              vntFreeDate, _
                              vntFreeField1, _
                              vntFreeField2, _
                              vntFreeField3, _
                              vntFreeField4, _
                              vntFreeField5, _
                              , _
                              vntFreeClassCd) = False Then
        If objFree.SelectFree(0, _
                              mstrFreeCd, _
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
                              vntFreeField7) = False Then
'### 2003.02.15 Added End
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtFreeCd.Text = mstrFreeCd
        txtFreeClassCd.Text = vntFreeClassCd
        txtFreeName.Text = vntFreeName
        mstrFreeDate = vntFreeDate
        txtFreeField1.Text = vntFreeField1
        txtFreeField2.Text = vntFreeField2
        txtFreeField3.Text = vntFreeField3
        txtFreeField4.Text = vntFreeField4
        txtFreeField5.Text = vntFreeField5
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
        txtFreeField6.Text = vntFreeField6
        txtFreeField7.Text = vntFreeField7
'### 2003.02.15 Added End
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditFree = Ret
    
    Exit Function

ErrorHandle:

    EditFree = False
    
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
Private Function RegistFree() As Boolean

    Dim objFree As Object       '�ėp�e�[�u���A�N�Z�X�p
    Dim Ret     As Long
    
    On Error GoTo ErrorHandle
    
    If cboYear.ListIndex > 0 Then
        mstrFreeDate = CDate((cboYear.List(cboYear.ListIndex) & "/" & cboMonth.List(cboMonth.ListIndex) & "/" & cboDay.List(cboDay.ListIndex)))
    Else
        mstrFreeDate = ""
    End If
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")

    '�ėp�e�[�u�����R�[�h�̓o�^
    If txtFreeCd.Enabled = True Then
    
        '�V�K�o�^
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
'        Ret = objFree.InsertFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text)
        Ret = objFree.InsertFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text, _
                                 txtFreeField6.Text, _
                                 txtFreeField7.Text)
'### 2003.02.15 Added End
    Else
    
        '�X�V
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
'        Ret = objFree.UpdateFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text)
        Ret = objFree.UpdateFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text, _
                                 txtFreeField6.Text, _
                                 txtFreeField7.Text)
'### 2003.02.15 Added End
    
        If Ret = True Then Ret = INSERT_NORMAL
        
    End If

    If Ret <> INSERT_NORMAL Then
        MsgBox "�f�[�^�X�V���ɃG���[���������܂����B", vbCritical
        RegistFree = False
        Exit Function
    End If

    '�X�V�������߁A�R�[�h���͗��͎g�p�s�\
    txtFreeCd.Enabled = False
    
    RegistFree = True
    
    Exit Function
    
ErrorHandle:

    RegistFree = False
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
        
        '�ėp�e�[�u���̓o�^
        If RegistFree() = False Then
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

    Do
        '�ėp���̕ҏW
        If EditFree() = False Then
            Exit Do
        End If
    
        '���t�R���{�ݒ�
        Call SetDayCombo
    
        '�C�l�[�u���ݒ�
        txtFreeCd.Enabled = (txtFreeCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub SetDayCombo()

    Dim i       As Integer

    '�R���{�{�b�N�X�ɒl���Z�b�g
    With cboYear
        .Clear
        .AddItem ""
        For i = YEARRANGE_MIN To YEARRANGE_MAX
            .AddItem i
            
            If mstrFreeDate <> "" Then
                If (i = Year(mstrFreeDate)) And _
                   (YEARRANGE_MIN <= Year(mstrFreeDate)) And _
                   (YEARRANGE_MAX >= Year(mstrFreeDate)) Then
                    .ListIndex = i - YEARRANGE_MIN + 1
                End If
            End If
        
        Next i
    End With
    
    With cboMonth
        .Clear
        .AddItem ""
        For i = 1 To 12
            .AddItem i
            If mstrFreeDate <> "" Then
                If i = Month(mstrFreeDate) Then
                    .ListIndex = i - 1 + 1
                End If
            End If
        Next i
    End With
    
    With cboDay
        .Clear
        .AddItem ""
        For i = 1 To 31
            .AddItem i
            If mstrFreeDate <> "" Then
                If i = Day(mstrFreeDate) Then
                    .ListIndex = i - 1 + 1
                End If
            End If
        Next i
    End With

End Sub
