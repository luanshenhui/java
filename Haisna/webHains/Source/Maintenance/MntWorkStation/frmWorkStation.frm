VERSION 5.00
Begin VB.Form frmWorkStation 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�[���Ǘ��e�[�u�������e�i���X"
   ClientHeight    =   2730
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6255
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmWorkStation.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2730
   ScaleWidth      =   6255
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboIsPrintButton 
      Height          =   300
      ItemData        =   "frmWorkStation.frx":000C
      Left            =   1860
      List            =   "frmWorkStation.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   18
      Top             =   1440
      Width           =   4110
   End
   Begin VB.ComboBox cboProgress 
      Height          =   300
      ItemData        =   "frmWorkStation.frx":0050
      Left            =   1860
      List            =   "frmWorkStation.frx":0072
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   15
      Top             =   1800
      Visible         =   0   'False
      Width           =   4110
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   3
      Left            =   3660
      MaxLength       =   3
      TabIndex        =   4
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   2
      Left            =   3060
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   1
      Left            =   2460
      MaxLength       =   3
      TabIndex        =   2
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   0
      Left            =   1860
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.CommandButton cmdGrp 
      Caption         =   "�O���[�v�R�[�h(&G)..."
      Height          =   315
      Left            =   120
      TabIndex        =   8
      Top             =   1020
      Width           =   1635
   End
   Begin VB.TextBox txtGrpCd 
      Height          =   300
      Left            =   1860
      MaxLength       =   5
      TabIndex        =   7
      Text            =   "@@@@@"
      Top             =   1020
      Width           =   795
   End
   Begin VB.TextBox txtWkStnName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1860
      MaxLength       =   15
      TabIndex        =   6
      Text            =   "������������������������������"
      Top             =   600
      Width           =   2895
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3240
      TabIndex        =   9
      Top             =   2220
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4680
      TabIndex        =   10
      Top             =   2220
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�i������(&P):"
      Height          =   180
      Index           =   2
      Left            =   240
      TabIndex        =   17
      Top             =   1860
      Visible         =   0   'False
      Width           =   1350
   End
   Begin VB.Label Label1 
      Caption         =   "����{�^���\��(&P):"
      Height          =   180
      Index           =   5
      Left            =   240
      TabIndex        =   16
      Top             =   1500
      Width           =   1530
   End
   Begin VB.Label Label2 
      Caption         =   "�D"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   2
      Left            =   3540
      TabIndex        =   14
      Top             =   240
      Width           =   195
   End
   Begin VB.Label Label2 
      Caption         =   "�D"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   1
      Left            =   2940
      TabIndex        =   13
      Top             =   240
      Width           =   195
   End
   Begin VB.Label Label2 
      Caption         =   "�D"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   2340
      TabIndex        =   12
      Top             =   240
      Width           =   195
   End
   Begin VB.Label lblGrpName 
      Caption         =   "Label2"
      Height          =   195
      Left            =   2760
      TabIndex        =   11
      Top             =   1080
      Width           =   3135
   End
   Begin VB.Label Label1 
      Caption         =   "�[����(&N):"
      Height          =   180
      Index           =   1
      Left            =   240
      TabIndex        =   5
      Top             =   660
      Width           =   990
   End
   Begin VB.Label Label1 
      Caption         =   "IP�A�h���X(&I):"
      Height          =   180
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1050
   End
End
Attribute VB_Name = "frmWorkStation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrIpAddress           As String   'IP�A�h���X

Private mblnInitialize          As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrRootProgressCd()    As String   '�R���{�{�b�N�X�ɑΉ�����i�����ރR�[�h�̊i�[

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let IpAddress(ByVal vntNewValue As String)

    mstrIpAddress = vntNewValue
    
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
    Dim i   As Integer
    
    Ret = False
    
    Do
        
        For i = 0 To 3
        
            'IP�A�h���X�̓��̓`�F�b�N
            If Trim(txtIP(i).Text) = "" Then
                MsgBox "IP�A�h���X�����͂���Ă��܂���B", vbCritical, App.Title
                txtIP(i).SetFocus
                Exit Do
            End If
        
            'IP�A�h���X�̐��l�`�F�b�N
            If IsNumeric(txtIP(i).Text) = False Then
                MsgBox "IP�A�h���X�͐��l����͂��Ă��������B", vbCritical, App.Title
                txtIP(i).SetFocus
                Exit Do
            End If
        
            'IP�A�h���X�̐��l�`�F�b�N
            If (CLng(txtIP(i).Text) > 255) Or (CLng(txtIP(i).Text) < 0) Then
                MsgBox "�L����IP�A�h���X����͂��Ă��������B", vbCritical, App.Title
                txtIP(i).SetFocus
                Exit Do
            End If
        
        Next i
        

        mstrIpAddress = ""
        For i = 0 To 2
            mstrIpAddress = mstrIpAddress & txtIP(i).Text & "."
        Next i
        
        mstrIpAddress = mstrIpAddress & txtIP(3).Text
        
        '���̂̓��̓`�F�b�N
        If Trim(txtWkStnName.Text) = "" Then
            MsgBox "�[���������͂���Ă��܂���B", vbCritical, App.Title
            txtWkStnName.SetFocus
            Exit Do
        End If

        '�O���[�v�R�[�h�̓��̓`�F�b�N
        If CheckGrpExists() = False Then
            txtGrpCd.SetFocus
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
' �@�\�@�@ : �O���[�v���݃`�F�b�N
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͂��ꂽ�O���[�v�R�[�h�̑��݃`�F�b�N���s��
'
' ���l�@�@ :
'
Private Function CheckGrpExists() As Boolean

    Dim objGrp          As Object     '�O���[�v���A�N�Z�X�p
    Dim vntGrpName      As Variant

    Dim Ret             As Boolean              '�߂�l
    Dim i               As Integer
    
    CheckGrpExists = False
    
    On Error GoTo ErrorHandle
    
    txtGrpCd.Text = Trim(txtGrpCd.Text)
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    Do
        '���ݒ�Ȃ珈���I��
        If txtGrpCd.Text = "" Then
            Ret = True
            Exit Do
        End If
        
        '�R�[�X�e�[�u�����R�[�h�ǂݍ���
        If objGrp.SelectGrp_P(txtGrpCd.Text, vntGrpName) = False Then
            MsgBox "���͂��ꂽ�O���[�v�R�[�h�͑��݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        lblGrpName.Caption = vntGrpName
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckGrpExists = Ret
    
    Exit Function

ErrorHandle:

    CheckGrpExists = False
    MsgBox Err.Description, vbCritical
    
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
Private Function EditWorkStation() As Boolean

    Dim objWorkStation      As Object           '�[�����A�N�Z�X�p
    
    Dim vntWkStnName        As Variant          '�[����
    Dim vntGrpCd            As Variant          '�O���[�v�R�[�h
    Dim vntGrpName          As Variant          '�O���[�v��
    Dim vntProgressCd       As Variant          '�i�����ރR�[�h
    Dim vntIsPrintButton    As Variant          '����{�^���\��
    Dim Ret                 As Boolean          '�߂�l
    Dim i                   As Integer
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWorkStation = CreateObject("HainsWorkStation.WorkStation")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If Trim(mstrIpAddress) = "" Then
            Ret = True
            Exit Do
        End If
        
        '�[�����e�[�u�����R�[�h�ǂݍ���
        If objWorkStation.SelectWorkStation(mstrIpAddress, _
                                            vntWkStnName, _
                                            vntGrpCd, _
                                            vntGrpName, _
                                            vntProgressCd, _
                                            vntIsPrintButton) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        Call SeparateIPAddress(mstrIpAddress)
        txtWkStnName.Text = vntWkStnName
        txtGrpCd.Text = vntGrpCd
        lblGrpName.Caption = vntGrpName
    
        '�i�����ސݒ�
        If Trim(vntProgressCd) <> "" Then
            For i = 0 To UBound(mstrRootProgressCd)
                If mstrRootProgressCd(i) = vntProgressCd Then
                    cboProgress.ListIndex = i
                    Exit For
                End If
            Next i
        End If
    
        '���ʓ��͈���{�^���\���ǉ�
        If Trim(vntIsPrintButton) <> "" And IsNumeric(vntIsPrintButton) = True Then
            cboIsPrintButton.ListIndex = CInt(vntIsPrintButton)
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditWorkStation = Ret
    
    Exit Function

ErrorHandle:

    EditWorkStation = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub SeparateIPAddress(strIPAddress As String)

    Dim intPointer      As Integer
    Dim intNowPointer   As Integer
    Dim strWorkString   As String
    Dim i               As Integer
    
    strWorkString = strIPAddress
    
    intNowPointer = 1
        
    For i = 0 To 3
        intPointer = InStr(1, strWorkString, ".")
        If intPointer > 0 Then
            txtIP(i).Text = Mid(strWorkString, 1, intPointer - 1)
        Else
            txtIP(i).Text = strWorkString
            Exit For
        End If
        
        strWorkString = Mid(strWorkString, intPointer + 1, Len(strWorkString))
    Next i

End Sub

'
' �@�\�@�@ : �f�[�^�o�^
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function RegistWorkStation() As Boolean

On Error GoTo ErrorHandle

    Dim objWorkStation      As Object       '�[�����A�N�Z�X�p
    Dim Ret                 As Long
    Dim strIsPrintButton    As String
    
    '����{�^����Ԃ��Z�b�g
    strIsPrintButton = ""
    If cboIsPrintButton.ListIndex > 0 Then
        strIsPrintButton = cboIsPrintButton.ListIndex
    End If
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWorkStation = CreateObject("HainsWorkStation.WorkStation")
    
    '�[�����e�[�u�����R�[�h�̓o�^
    Ret = objWorkStation.RegistWorkStation(IIf(txtIP(0).Enabled, "INS", "UPD"), _
                                           mstrIpAddress, _
                                           Trim(txtWkStnName.Text), _
                                           Trim(txtGrpCd.Text), _
                                           mstrRootProgressCd(cboProgress.ListIndex), _
                                           strIsPrintButton)

    If Ret = 0 Then
        MsgBox "���͂��ꂽIP�A�h���X�͊��ɑ��݂��܂��B", vbExclamation
        RegistWorkStation = False
        Exit Function
    End If
    
    RegistWorkStation = True
    
    Exit Function
    
ErrorHandle:

    RegistWorkStation = False
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

Private Sub cmdGrp_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    
    Dim lngItemCount    As Long     '�I�����ڐ�
    Dim vntItemCd       As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntItemName     As Variant  '�I�����ꂽ���ږ�

    lngItemCount = 0

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_SHOW
        .Item = ITEM_OFF
        .Question = QUESTION_OFF
        .MultiSelect = False
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
            
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntItemName = .ItemName
    
    End With

    If lngItemCount > 0 Then
        txtGrpCd.Text = vntItemCd(0)
        lblGrpName.Caption = vntItemName(0)
    End If
    
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
        
        '�[�����e�[�u���̓o�^
        If RegistWorkStation() = False Then
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
    Dim i As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        
        '�i�����ރR���{�̕ҏW
        If EditProgressConbo() = False Then
            Exit Do
        End If
        
        '���ʓ��͏�̈���{�^���\���ǉ�
        cboIsPrintButton.Clear
        cboIsPrintButton.AddItem ""
        cboIsPrintButton.AddItem "�����g�����\����{�^���\��"
        cboIsPrintButton.AddItem "���o�����������ʕ\����{�^���\��"
        
        '�[�����̕ҏW
        If EditWorkStation() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        For i = 0 To 3
            txtIP(i).Enabled = (mstrIpAddress = "")
        Next i
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' �@�\�@�@ : �i�����ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �i�����ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditProgressConbo() As Boolean

    Dim objProgress     As Object   '�i�����ރA�N�Z�X�p
    Dim vntProgressCd   As Variant
    Dim vntProgressName As Variant
    Dim lngCount        As Long     '���R�[�h��
    Dim i               As Long     '�C���f�b�N�X
    
    EditProgressConbo = False
    
    cboProgress.Clear
    Erase mstrRootProgressCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objProgress = CreateObject("HainsProgress.Progress")
    lngCount = objProgress.SelectProgressList(vntProgressCd, vntProgressName)
    
    '�i�����ނ͋�ݒ肠��
    ReDim Preserve mstrRootProgressCd(0)
    mstrRootProgressCd(0) = ""
    cboProgress.AddItem ""
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootProgressCd(i + 1)
        mstrRootProgressCd(i + 1) = vntProgressCd(i)
        cboProgress.AddItem vntProgressName(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    cboProgress.ListIndex = 0
    EditProgressConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub txtGrpCd_Change()

    lblGrpName.Caption = ""
    
End Sub

Private Sub txtIP_GotFocus(Index As Integer)

    With txtIP(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub
