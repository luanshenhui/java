VERSION 5.00
Begin VB.Form frmEditCalcItem 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�v�Z�s�̕ҏW"
   ClientHeight    =   5385
   ClientLeft      =   225
   ClientTop       =   330
   ClientWidth     =   11265
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditCalcItem.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5385
   ScaleWidth      =   11265
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame2 
      Caption         =   "�v�Z�C���[�W"
      Height          =   735
      Left            =   180
      TabIndex        =   27
      Top             =   4020
      Width           =   10875
      Begin VB.Label lblCalcImage 
         Caption         =   "�i�@�̎��b�@�~�@3.2�@�j�@���@�i�@4.2�@�j�@���@�v�Z����"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   240
         TabIndex        =   28
         Top             =   360
         Width           =   10335
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "����"
      Height          =   2655
      Index           =   1
      Left            =   6060
      TabIndex        =   23
      Top             =   780
      Width           =   4995
      Begin VB.TextBox txtSuffix 
         Height          =   315
         Index           =   1
         Left            =   1440
         TabIndex        =   15
         Text            =   "88"
         Top             =   1860
         Width           =   315
      End
      Begin VB.TextBox txtItemCd 
         Height          =   315
         Index           =   1
         Left            =   600
         TabIndex        =   14
         Text            =   "888888"
         Top             =   1860
         Width           =   675
      End
      Begin VB.CommandButton cmdItemGuide 
         Caption         =   "�Q��(&R)..."
         Height          =   315
         Index           =   1
         Left            =   600
         TabIndex        =   16
         Top             =   2220
         Width           =   1155
      End
      Begin VB.TextBox txtConstant 
         Alignment       =   1  '�E����
         Height          =   330
         Index           =   1
         Left            =   3480
         MaxLength       =   8
         TabIndex        =   18
         Text            =   "@@@@@@@@"
         Top             =   1140
         Width           =   1095
      End
      Begin VB.ComboBox cboBeforeResult 
         Height          =   300
         Index           =   1
         ItemData        =   "frmEditCalcItem.frx":000C
         Left            =   660
         List            =   "frmEditCalcItem.frx":002E
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   12
         Top             =   1140
         Width           =   2370
      End
      Begin VB.OptionButton optRightSelect 
         Caption         =   "�萔�̂�(&4)"
         Height          =   315
         Index           =   0
         Left            =   360
         TabIndex        =   10
         Top             =   420
         Value           =   -1  'True
         Width           =   1695
      End
      Begin VB.OptionButton optRightSelect 
         Caption         =   "�O�s�̌������ʂ��w�肷��(&5)"
         Height          =   315
         Index           =   1
         Left            =   360
         TabIndex        =   11
         Top             =   780
         Width           =   2595
      End
      Begin VB.OptionButton optRightSelect 
         Caption         =   "�������ڂ��w�肷��(&6)"
         Height          =   315
         Index           =   2
         Left            =   360
         TabIndex        =   13
         Top             =   1560
         Width           =   2835
      End
      Begin VB.Label Label6 
         Caption         =   "-"
         Height          =   255
         Index           =   1
         Left            =   1320
         TabIndex        =   31
         Top             =   1920
         Width           =   135
      End
      Begin VB.Label lblItemName 
         Caption         =   "�̎��b"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   1
         Left            =   1860
         TabIndex        =   30
         Top             =   1920
         Width           =   2835
      End
      Begin VB.Label Label4 
         Caption         =   "�~"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   18
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   3060
         TabIndex        =   24
         Top             =   1080
         Width           =   375
      End
      Begin VB.Label Label3 
         Caption         =   "�萔(&U)"
         Height          =   255
         Left            =   3480
         TabIndex        =   17
         Top             =   840
         Width           =   855
      End
   End
   Begin VB.ComboBox cboOperator 
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   21.75
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   555
      ItemData        =   "frmEditCalcItem.frx":0050
      Left            =   5220
      List            =   "frmEditCalcItem.frx":005A
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   9
      Top             =   1740
      Width           =   810
   End
   Begin VB.Frame Frame1 
      Caption         =   "����"
      Height          =   2715
      Index           =   0
      Left            =   180
      TabIndex        =   21
      Top             =   720
      Width           =   4995
      Begin VB.TextBox txtSuffix 
         Height          =   315
         Index           =   0
         Left            =   1440
         TabIndex        =   5
         Text            =   "88"
         Top             =   1860
         Width           =   315
      End
      Begin VB.TextBox txtItemCd 
         Height          =   315
         Index           =   0
         Left            =   600
         TabIndex        =   4
         Text            =   "888888"
         Top             =   1860
         Width           =   675
      End
      Begin VB.TextBox txtConstant 
         Alignment       =   1  '�E����
         Height          =   330
         Index           =   0
         Left            =   3480
         MaxLength       =   8
         TabIndex        =   8
         Text            =   "@@@@@@@@"
         Top             =   1140
         Width           =   1095
      End
      Begin VB.CommandButton cmdItemGuide 
         Caption         =   "�Q��(&L)..."
         Height          =   315
         Index           =   0
         Left            =   600
         TabIndex        =   6
         Top             =   2220
         Width           =   1155
      End
      Begin VB.ComboBox cboBeforeResult 
         Height          =   300
         Index           =   0
         ItemData        =   "frmEditCalcItem.frx":0066
         Left            =   600
         List            =   "frmEditCalcItem.frx":0088
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   2
         Top             =   1140
         Width           =   2370
      End
      Begin VB.OptionButton optLeftSelect 
         Caption         =   "�������ڂ��w�肷��(&3)"
         Height          =   315
         Index           =   2
         Left            =   360
         TabIndex        =   3
         Top             =   1560
         Width           =   2835
      End
      Begin VB.OptionButton optLeftSelect 
         Caption         =   "�O�s�̌������ʂ��w�肷��(&2)"
         Height          =   315
         Index           =   1
         Left            =   360
         TabIndex        =   1
         Top             =   780
         Width           =   2595
      End
      Begin VB.OptionButton optLeftSelect 
         Caption         =   "�萔�̂�(&1)"
         Height          =   315
         Index           =   0
         Left            =   360
         TabIndex        =   0
         Top             =   420
         Value           =   -1  'True
         Width           =   1695
      End
      Begin VB.Label Label6 
         Caption         =   "-"
         Height          =   255
         Index           =   0
         Left            =   1320
         TabIndex        =   29
         Top             =   1920
         Width           =   135
      End
      Begin VB.Label lblItemName 
         Caption         =   "�̎��b"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   0
         Left            =   1860
         TabIndex        =   25
         Top             =   1920
         Width           =   2835
      End
      Begin VB.Label Label2 
         Caption         =   "�萔(&T)"
         Height          =   255
         Left            =   3480
         TabIndex        =   7
         Top             =   840
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "�~"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   18
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   3060
         TabIndex        =   22
         Top             =   1140
         Width           =   375
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   9720
      TabIndex        =   20
      Top             =   4920
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   8280
      TabIndex        =   19
      Top             =   4920
      Width           =   1335
   End
   Begin VB.Label Label7 
      Caption         =   "�v�Z����ݒ肵�Ă�������"
      Height          =   255
      Left            =   780
      TabIndex        =   32
      Top             =   240
      Width           =   6375
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   4
      Left            =   180
      Picture         =   "frmEditCalcItem.frx":00AA
      Top             =   120
      Width           =   480
   End
   Begin VB.Label Label5 
      Caption         =   "���萔�́A�萔�̂݁A�O�s�̌������ʁA�������ځA�������I�����Ă��L���ł��B�i�v�Z���܂��j"
      Height          =   255
      Left            =   240
      TabIndex        =   26
      Top             =   3600
      Width           =   7095
   End
End
Attribute VB_Name = "frmEditCalcItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String           '�������ڃR�[�h
Private mstrSuffix              As String           '�T�t�B�b�N�X

Private mstrVariable1           As String
Private mstrCalcItemCd1         As String
Private mstrCalcSuffix1         As String
Private mstrCalcItemName1       As String
Private mstrConstant1           As String
Private mstrOperator            As String
Private mstrVariable2           As String
Private mstrCalcItemCd2         As String
Private mstrCalcSuffix2         As String
Private mstrCalcItemName2       As String
Private mstrConstant2           As String
Private mintCalcLine            As Integer

Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����
Private mblnModeNew             As Boolean          'TRUE:�V�K�AFALSE:�X�V

Private Sub cboBeforeResult_Click(Index As Integer)
    
    '�v�Z�C���[�W�̕\��
    Call EditCalcString

End Sub

Private Sub cboOperator_Click()
    
    Call EditCalcString
    
End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdItemGuide_Click(Index As Integer)
    
    Dim objItemGuide        As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    Dim objItem             As ListItem                 '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim i                   As Long     '�C���f�b�N�X
    Dim strKey              As String   '�d���`�F�b�N�p�̃L�[
    Dim strItemString       As String
    Dim strItemKey          As String   '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCdString     As String   '�\���p�L�[�ҏW�̈�
    
    Dim lngItemCount        As Long     '�I�����ڐ�
    Dim vntItemCd           As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntSuffix           As Variant  '�I�����ꂽ�T�t�B�b�N�X
    Dim vntItemName         As Variant  '�I�����ꂽ���ږ�
    Dim vntClassName        As Variant  '�I�����ꂽ�������ޖ�
    Dim vntResultType(2)    As Variant  '���ʃ^�C�v
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        vntResultType(0) = RESULTTYPE_NUMERIC
        vntResultType(1) = RESULTTYPE_CALC
        '���͍��ڂ��v�Z�ΏۂɊ܂߂�
        vntResultType(2) = RESULTTYPE_SENTENCE
        .ResultType = vntResultType
        .MultiSelect = False
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
        
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
        vntItemName = .ItemName
    
    End With
        
    Screen.MousePointer = vbHourglass
    Me.Refresh
        
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then
        
        If (vntItemCd(i) = mstrItemCd) And (vntSuffix(i) = mstrSuffix) Then
            '�I���������ڂ��������g�Ɠ����ꍇ�A���J�[�V�u���ɂȂ�̂łƂ߂�
            MsgBox "�������g���v�Z���ڂɊ܂߂邱�Ƃ͂ł��܂���", vbExclamation, Me.Caption
        Else
            txtItemCd(Index).Text = vntItemCd(i)
            txtSuffix(Index).Text = vntSuffix(i)
            lblItemName(Index).Caption = vntItemName(i)
        End If
        
    End If

    '�v�Z�C���[�W�̕\��
    Call EditCalcString

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub cmdOk_Click()

    '���̓`�F�b�N
    If CheckValue() = False Then Exit Sub
    
    '�v���p�e�B�l�̉�ʃZ�b�g
    Call SetProperty

    mblnUpdated = True
    Unload Me
    
End Sub

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

    Dim Ret             As Boolean  '�֐��߂�l
    Dim strWorkResult   As String
    Dim strItemName     As String
        
    '����R���g���[����SetFocus�ł͕�����I�����L���ɂȂ�Ȃ��̂Ń_�~�[�łƂ΂�
    cmdOk.SetFocus
    
    Ret = False
    
    Do

        '���� -------------------------------------------------------------------------------
        '�萔�i���Ӂj�������͂Ȃ�P�Z�b�g
        If Trim(txtConstant(0).Text) = "" Then
            txtConstant(0).Text = 1
        End If

        '�萔�i���Ӂj�̐��l�`�F�b�N
        If IsNumeric(txtConstant(0).Text) = False Then
            MsgBox "�萔�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtConstant(0).SetFocus
            Exit Do
        End If

        '�O�s���ʎw�莞�̃`�F�b�N
        If optLeftSelect(1).Value = True Then
            If cboBeforeResult(0).ListIndex < 0 Then
                MsgBox "�v�Z�ΏۂƂȂ錟�����ʍs���w�肳��Ă��܂���B", vbExclamation, App.Title
                cboBeforeResult(0).SetFocus
                Exit Do
            End If
        End If

        '�������ڎw�莞�̃`�F�b�N
        If optLeftSelect(2).Value = True Then
            If Trim(lblItemName(0).Caption) = "" Then
                If GetItemInfo(txtItemCd(0).Text, txtSuffix(0).Text, strItemName) = False Then
                    txtItemCd(0).SetFocus
                    Exit Do
                Else
                lblItemName(0).Caption = strItemName
                End If
            End If
        End If

        '�E�� -------------------------------------------------------------------------------
        '�萔�i�E�Ӂj�������͂Ȃ�P�Z�b�g
        If Trim(txtConstant(1).Text) = "" Then
            txtConstant(1).Text = 1
        End If

        '�萔�i�E�Ӂj�̐��l�`�F�b�N
        If IsNumeric(txtConstant(1).Text) = False Then
            MsgBox "�萔�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtConstant(1).SetFocus
            Exit Do
        End If

        '�O�s���ʎw�莞�̃`�F�b�N
        If optRightSelect(1).Value = True Then
            If cboBeforeResult(1).ListIndex < 0 Then
                MsgBox "�v�Z�ΏۂƂȂ錟�����ʍs���w�肳��Ă��܂���B", vbExclamation, App.Title
                cboBeforeResult(1).SetFocus
                Exit Do
            End If
        End If

        '�������ڎw�莞�̃`�F�b�N
        If optRightSelect(2).Value = True Then
            If Trim(lblItemName(1).Caption) = "" Then
                If GetItemInfo(txtItemCd(1).Text, txtSuffix(1).Text, strItemName) = False Then
                    txtItemCd(1).SetFocus
                    Exit Do
                Else
                lblItemName(1).Caption = strItemName
                End If
            End If
        End If
        
        '0�f�B�o�C�h�̃`�F�b�N
        If (cboOperator.ListIndex = 3) And _
           (optRightSelect(0).Value = True) And _
           (CDbl(txtConstant(1).Text) = 0) Then
            MsgBox "�O�ŏ��Z���邱�Ƃ͋�����܂���B", vbExclamation, App.Title
            txtConstant(1).SetFocus
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
' �@�\�@�@ : �������ڏ��擾
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ڂ̊�{�����擾����
'
' ���l�@�@ :
'
Private Function GetItemInfo(strItemCd As String, _
                             strSuffix As String, _
                             strItemName As String) As Boolean

On Error GoTo ErrorHandle

    Dim objItem             As Object               '�������ڏ��A�N�Z�X�p
    Dim i                   As Integer
    Dim vntItemName         As Variant              '
    Dim vntitemEName        As Variant              '
    Dim vntClassName        As Variant              '
    Dim vntRslQue           As Variant              '
    Dim vntRslqueName       As Variant              '
    Dim vntItemType         As Variant              '
    Dim vntItemTypeName     As Variant              '
    Dim vntResultType       As Variant              '
    Dim vntResultTypeName   As Variant              '
    Dim vntStcItemCd        As Variant              '
    Dim Ret                 As Boolean              '�߂�l
    
    GetItemInfo = False
    
    Ret = False
    
    Do
        
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (strItemCd = "") Or (strSuffix = "") Then
            MsgBox "�������������ڃR�[�h����͂��Ă��������B", vbExclamation, App.Title
            Exit Do
        End If
        
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objItem = CreateObject("HainsItem.Item")
        
        '�������ڃe�[�u�����R�[�h�ǂݍ���
        If objItem.SelectItemHeader(strItemCd, _
                                    strSuffix, _
                                    vntItemName, _
                                    vntitemEName, _
                                    vntClassName, _
                                    vntRslQue, _
                                    vntRslqueName, _
                                    vntItemType, _
                                    vntItemTypeName, _
                                    vntResultType, _
                                    vntResultTypeName) = False Then
            
            MsgBox "���͂��ꂽ�������ڃR�[�h�͑��݂��܂���B", vbExclamation, App.Title
            Exit Do
        
        End If

        '���ʃ^�C�v���`�F�b�N�i���l�A�v�Z�A���́j
'        If CInt(vntResultType) <> RESULTTYPE_NUMERIC Then
        If (CInt(vntResultType) <> RESULTTYPE_NUMERIC) And _
           (CInt(vntResultType) <> RESULTTYPE_CALC) And _
           (CInt(vntResultType) <> RESULTTYPE_SENTENCE) Then

            MsgBox "�w�肳�ꂽ���ځu" & vntItemName & "�v�͌v�Z�ΏۂƂ��ėL���Ȍ��ʃ^�C�v�ł͂���܂���B", vbExclamation, App.Title
            Exit Do
        End If
        
        strItemName = vntItemName
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    GetItemInfo = Ret
    Set objItem = Nothing
    
    Exit Function

ErrorHandle:

    GetItemInfo = False
    MsgBox Err.Description, vbCritical
    Set objItem = Nothing
    
End Function

Private Sub Form_Load()

    Dim i       As Integer

    mblnUpdated = False

    '��ʏ�����
    Call InitializeForm

    '�v�Z��Ԃ̃Z�b�g
    Call SetCalcListItem

End Sub

Private Sub InitializeForm()

    Dim i   As Integer

    '���ʃ��W���[���ł̃R���g���[��������
    Call InitFormControls(Me, mcolGotFocusCollection)

    '���Z�L���̃R���{�Z�b�g
    With cboOperator
        .Clear
        .AddItem "�{"
        .AddItem "�|"
        .AddItem "�~"
        .AddItem "��"
        .AddItem "�O"
        .ListIndex = 0
    End With

    '�R���{�N���b�N���珉�����������s��
    Call optLeftSelect_Click(0)
    Call optRightSelect_Click(0)

    '�萔������
    txtConstant(0).Text = 1
    txtConstant(1).Text = 1

    For i = 0 To mintCalcLine - 1
        cboBeforeResult(0).AddItem i + 1 & "�s�ڂ̌v�Z����"
        cboBeforeResult(1).AddItem i + 1 & "�s�ڂ̌v�Z����"
    Next i

End Sub

Private Sub SetCalcListItem()

    '���Z�q�̃Z�b�g
    Select Case mstrOperator
        Case "+"
            cboOperator.ListIndex = 0
        Case "-"
            cboOperator.ListIndex = 1
        Case "*"
            cboOperator.ListIndex = 2
        Case "/"
            cboOperator.ListIndex = 3
        Case "^"
            cboOperator.ListIndex = 4
    End Select

    '�萔�̃Z�b�g
    txtConstant(0).Text = mstrConstant1
    txtConstant(1).Text = mstrConstant2

    '�O�s�̌������ʐݒ�̏ꍇ
    If IsNumeric(mstrVariable1) Then
        If CInt(mstrVariable1) < (cboBeforeResult(0).ListCount + 1) Then
            optLeftSelect(1).Value = True
            cboBeforeResult(0).ListIndex = CInt(mstrVariable1) - 1
        End If
    End If
    
    '�������ڎw��̏ꍇ
    If (mstrCalcItemCd1 <> "") And (mstrCalcSuffix1 <> "") Then
        optLeftSelect(2).Value = True
        txtItemCd(0).Text = mstrCalcItemCd1
        txtSuffix(0).Text = mstrCalcSuffix1
        lblItemName(0).Caption = mstrCalcItemName1
    End If

    '�O�s�̌������ʐݒ�̏ꍇ
    If IsNumeric(mstrVariable2) Then
        If CInt(mstrVariable2) < (cboBeforeResult(1).ListCount + 1) Then
            optRightSelect(1).Value = True
            cboBeforeResult(1).ListIndex = CInt(mstrVariable2) - 1
        End If
    End If
    
    '�������ڎw��̏ꍇ
    If (mstrCalcItemCd2 <> "") And (mstrCalcSuffix2 <> "") Then
        optRightSelect(2).Value = True
        txtItemCd(1).Text = mstrCalcItemCd2
        txtSuffix(1).Text = mstrCalcSuffix2
        lblItemName(1).Caption = mstrCalcItemName2
    End If

    '�v�Z�C���[�W�̕\��
    Call EditCalcString
    
End Sub
Private Sub optLeftSelect_Click(Index As Integer)

    Call CntlCalcOption(Index, 0)
    
End Sub

Private Sub optRightSelect_Click(Index As Integer)
    
    Call CntlCalcOption(Index, 1)

End Sub

Public Sub CntlCalcOption(Index As Integer, intSide As Integer)

    '�v�Z�s���P�s�ڂȂ�A�O�s�I���R���{�͎g�p�s��
    If mintCalcLine < 1 Then
        optLeftSelect(1).Enabled = False
        optRightSelect(1).Enabled = False
    End If

    '�Z���N�g���ꂽ�I�v�V�����{�^���ɉ����A����������s��
    Select Case Index
        
        Case 0      '�萔�̂�
            cboBeforeResult(intSide).Enabled = False
            
            cmdItemGuide(intSide).Enabled = False
            txtItemCd(intSide).Enabled = False
            txtSuffix(intSide).Enabled = False
            
            txtItemCd(intSide).BackColor = vbButtonFace
            txtSuffix(intSide).BackColor = vbButtonFace
            lblItemName(intSide).ForeColor = vbGrayText
            
        Case 1      '�O�s�̌������ʂ��w�肷��
            cboBeforeResult(intSide).Enabled = True
            
            cmdItemGuide(intSide).Enabled = False
            txtItemCd(intSide).Enabled = False
            txtSuffix(intSide).Enabled = False
            txtItemCd(intSide).BackColor = vbButtonFace
            txtSuffix(intSide).BackColor = vbButtonFace
            lblItemName(intSide).ForeColor = vbGrayText
        
        Case 2      '�������ڂ��w�肷��
            cboBeforeResult(intSide).Enabled = False
            
            cmdItemGuide(intSide).Enabled = True
            txtItemCd(intSide).Enabled = True
            txtSuffix(intSide).Enabled = True
            txtItemCd(intSide).BackColor = vbWindowBackground
            txtSuffix(intSide).BackColor = vbWindowBackground
            lblItemName(intSide).ForeColor = vbButtonText
    
    End Select
    
    '�v�Z�C���[�W�̕\��
    Call EditCalcString
    
End Sub

Private Sub txtConstant_GotFocus(Index As Integer)

    With txtConstant(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Friend Property Get Variable1() As String

    Variable1 = mstrVariable1
    
End Property

Friend Property Let Variable1(ByVal vNewValue As String)

    mstrVariable1 = vNewValue

End Property

Friend Property Get CalcItemCd1() As String

    CalcItemCd1 = mstrCalcItemCd1
    
End Property

Friend Property Let CalcItemCd1(ByVal vNewValue As String)

    mstrCalcItemCd1 = vNewValue

End Property

Friend Property Get CalcItemName1() As String

    CalcItemName1 = mstrCalcItemName1
    
End Property

Friend Property Let CalcItemName1(ByVal vNewValue As String)

    mstrCalcItemName1 = vNewValue

End Property

Friend Property Get CalcSuffix1() As String

    CalcSuffix1 = mstrCalcSuffix1
    
End Property

Friend Property Let CalcSuffix1(ByVal vNewValue As String)

    mstrCalcSuffix1 = vNewValue

End Property

Friend Property Get Constant1() As String

    Constant1 = mstrConstant1
    
End Property

Friend Property Let Constant1(ByVal vNewValue As String)

    mstrConstant1 = vNewValue

End Property

Friend Property Get Operator() As String

    Operator = mstrOperator
    
End Property

Friend Property Let Operator(ByVal vNewValue As String)

    mstrOperator = vNewValue

End Property

Friend Property Get Variable2() As String

    Variable2 = mstrVariable2
    
End Property

Friend Property Let Variable2(ByVal vNewValue As String)

    mstrVariable2 = vNewValue

End Property

Friend Property Get CalcItemCd2() As String

    CalcItemCd2 = mstrCalcItemCd2
    
End Property

Friend Property Let CalcItemCd2(ByVal vNewValue As String)

    mstrCalcItemCd2 = vNewValue

End Property

Friend Property Get CalcSuffix2() As String

    CalcSuffix2 = mstrCalcSuffix2
    
End Property

Friend Property Let CalcSuffix2(ByVal vNewValue As String)

    mstrCalcSuffix2 = vNewValue

End Property

Friend Property Get CalcItemName2() As String

    CalcItemName2 = mstrCalcItemName2
    
End Property

Friend Property Let CalcItemName2(ByVal vNewValue As String)

    mstrCalcItemName2 = vNewValue

End Property

Friend Property Get Constant2() As String

    Constant2 = mstrConstant2
    
End Property

Friend Property Let Constant2(ByVal vNewValue As String)

    mstrConstant2 = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Private Sub txtConstant_LostFocus(Index As Integer)

    '�v�Z�C���[�W�̕\��
    Call EditCalcString

End Sub

Private Sub txtItemCd_Change(Index As Integer)
        
    lblItemName(Index).Caption = ""

End Sub

Private Sub txtItemCd_GotFocus(Index As Integer)

    With txtItemCd(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Private Sub txtItemCd_LostFocus(Index As Integer)

    '�R�[�h���Z�b�g����Ă��Ȃ��Ȃ�A���̂��N���A
    If Trim(txtItemCd(Index).Text) = "" Then
        lblItemName(Index).Caption = ""
    End If

    '�v�Z�C���[�W�̕\��
    Call EditCalcString

End Sub

Private Sub txtSuffix_Change(Index As Integer)
    
    lblItemName(Index).Caption = ""

End Sub

Private Sub txtSuffix_GotFocus(Index As Integer)

    With txtSuffix(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Private Sub txtSuffix_LostFocus(Index As Integer)

    '�R�[�h���Z�b�g����Ă��Ȃ��Ȃ�A���̃N���A
    If Trim(txtSuffix(Index).Text) = "" Then
        lblItemName(Index).Caption = ""
    End If

    '�v�Z�C���[�W�̕\��
    Call EditCalcString

End Sub

Public Property Let CalcLine(ByVal vNewValue As Integer)

    mintCalcLine = vNewValue

End Property

Private Sub SetProperty()

    mstrVariable1 = ""
    mstrCalcItemCd1 = ""
    mstrCalcSuffix1 = ""
    mstrCalcItemName1 = ""
    mstrConstant1 = ""
    mstrOperator = ""
    mstrVariable2 = ""
    mstrCalcItemCd2 = ""
    mstrCalcSuffix2 = ""
    mstrCalcItemName2 = ""
    mstrConstant2 = ""

    '���ӂ̕ҏW
    mstrConstant1 = txtConstant(0).Text
    Select Case True
        '�O�s�̌������ʂ��w�肷��
        Case optLeftSelect(1).Value
            mstrVariable1 = cboBeforeResult(0).ListIndex + 1
        '�������ڂ��w�肷��
        Case optLeftSelect(2).Value
            mstrCalcItemCd1 = txtItemCd(0).Text
            mstrCalcSuffix1 = txtSuffix(0).Text
            mstrCalcItemName1 = lblItemName(0)
    End Select
        
    Select Case cboOperator.ListIndex
        Case 0
            mstrOperator = "+"
        Case 1
            mstrOperator = "-"
        Case 2
            mstrOperator = "*"
        Case 3
            mstrOperator = "/"
        Case 4
            mstrOperator = "^"
    End Select
        
    '�E�ӂ̕ҏW
    mstrConstant2 = txtConstant(1).Text
    Select Case True
        '�O�s�̌������ʂ��w�肷��
        Case optRightSelect(1).Value
            mstrVariable2 = cboBeforeResult(1).ListIndex + 1
        '�������ڂ��w�肷��
        Case optRightSelect(2).Value
            mstrCalcItemCd2 = txtItemCd(1).Text
            mstrCalcSuffix2 = txtSuffix(1).Text
            mstrCalcItemName2 = lblItemName(1)
    End Select

End Sub

' @(e)
'
' �@�\�@�@ : �v�Z���̕ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : �\���p�Ɍv�Z�f�[�^���ĕҏW����
'
' ���l�@�@ :
'
Private Sub EditCalcString()

    Dim strCalcString       As String
    Dim strWorkString       As String
        
    strCalcString = ""
    
    '���� ---------------------------------------------------------------------
    strWorkString = ""
    
    '�ϐ����Z�b�g����Ă���ꍇ�̏���
    If optLeftSelect(1).Value = True Then
        strWorkString = cboBeforeResult(0).Text
    End If
    
    '�������ڃR�[�h���Z�b�g����Ă���ꍇ�̏���
    If optLeftSelect(2).Value = True Then
        
        If Trim(lblItemName(0).Caption) = "" Then
            strWorkString = "�H�H�H"
        Else
            strWorkString = lblItemName(0).Caption
        End If
    
    End If

    '�ϐ��A�������͌������ڃR�[�h���Z�b�g����Ă���ꍇ�̒萔�\��
    If (optLeftSelect(1).Value = True) Or (optLeftSelect(2).Value = True) Then
        
        If IsNumeric(Trim(txtConstant(0).Text)) Then
            '�萔���P�ł͂Ȃ��ꍇ�ɁA����ҏW
            If CDbl(Trim(txtConstant(0).Text)) <> 1 Then
                strWorkString = "( " & strWorkString & "�~ " & Trim(txtConstant(0).Text) & " )"
            End If
        End If
    Else
        '�萔�݂̂̏ꍇ�́A���̂܂܃Z�b�g
        strWorkString = Trim(txtConstant(0).Text)
    End If
    
    '���Z�q -------------------------------------------------------------------
    strCalcString = strWorkString & "�@" & cboOperator.Text & "�@"
    
    '�E�� ---------------------------------------------------------------------
    strWorkString = ""
    
    '�ϐ����Z�b�g����Ă���ꍇ�̏���
    If optRightSelect(1).Value = True Then
        strWorkString = cboBeforeResult(1).Text
    End If
    
    '�������ڃR�[�h���Z�b�g����Ă���ꍇ�̏���
    If optRightSelect(2).Value = True Then
        If Trim(lblItemName(1).Caption) = "" Then
            strWorkString = "�H�H�H"
        Else
            strWorkString = lblItemName(1).Caption
        End If
    End If

    '�ϐ��A�������͌������ڃR�[�h���Z�b�g����Ă���ꍇ�̒萔�\��
    If (optRightSelect(1).Value = True) Or (optRightSelect(2).Value = True) Then
        
        If IsNumeric(Trim(txtConstant(1).Text)) Then
            '�萔���P�ł͂Ȃ��ꍇ�ɁA����ҏW
            If CDbl(Trim(txtConstant(1).Text)) <> 1 Then
                strWorkString = "( " & strWorkString & "�~ " & Trim(txtConstant(1).Text) & " )"
            End If
        End If
    Else
        '�萔�݂̂̏ꍇ�́A���̂܂܃Z�b�g
        strWorkString = Trim(txtConstant(1).Text)
    End If
    
    lblCalcImage.Caption = strCalcString & strWorkString
    
End Sub

Friend Property Let ItemCd(ByVal vNewValue As String)

    mstrItemCd = vNewValue
    
End Property

Friend Property Let Suffix(ByVal vNewValue As String)

    mstrSuffix = vNewValue
    
End Property
