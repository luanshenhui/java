VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmEditStdValueItem 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "��l�ݒ�l�̕ύX"
   ClientHeight    =   6495
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7275
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditStdValueItem.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6495
   ScaleWidth      =   7275
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame3 
      Caption         =   "�P�ʏ��"
      Height          =   1335
      Left            =   120
      TabIndex        =   25
      Top             =   1800
      Width           =   6975
      Begin MSComctlLib.ListView lsvUnit 
         Height          =   855
         Left            =   180
         TabIndex        =   26
         Top             =   300
         Width           =   6615
         _ExtentX        =   11668
         _ExtentY        =   1508
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         FullRowSelect   =   -1  'True
         _Version        =   393217
         Icons           =   "imlToolbarIcons"
         SmallIcons      =   "imlToolbarIcons"
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "�K�p����ݒ�l"
      Height          =   2595
      Left            =   120
      TabIndex        =   20
      Top             =   3240
      Width           =   6975
      Begin VB.TextBox txtJudCmtCd 
         Height          =   270
         IMEMode         =   3  '�̌Œ�
         Left            =   2220
         MaxLength       =   8
         TabIndex        =   11
         Text            =   "99999999"
         Top             =   1200
         Width           =   975
      End
      Begin VB.ComboBox cboStdFlg 
         BeginProperty Font 
            Name            =   "�l�r �o�S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmEditStdValueItem.frx":000C
         Left            =   2220
         List            =   "frmEditStdValueItem.frx":002E
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   7
         Top             =   360
         Width           =   2550
      End
      Begin VB.TextBox txtHealthPoint 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2220
         MaxLength       =   6
         TabIndex        =   14
         Text            =   "@@@@.@"
         Top             =   1980
         Width           =   795
      End
      Begin VB.ComboBox cboJud 
         BeginProperty Font 
            Name            =   "�l�r �o�S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmEditStdValueItem.frx":0050
         Left            =   2220
         List            =   "frmEditStdValueItem.frx":0072
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   9
         Top             =   780
         Width           =   2550
      End
      Begin VB.CommandButton cmdGuide 
         Caption         =   "�Q��(&C)..."
         Height          =   315
         Left            =   2220
         TabIndex        =   12
         Top             =   1560
         Width           =   1335
      End
      Begin VB.Label Label1 
         Caption         =   "�K�p�����l(&S):"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   6
         Top             =   420
         Width           =   1650
      End
      Begin VB.Label Label1 
         Caption         =   "�K�p���锻��R�[�h(&J):"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   8
         Top             =   840
         Width           =   1710
      End
      Begin VB.Label Label1 
         Caption         =   "�K�p���锻��R�����g(&C):"
         Height          =   180
         Index           =   4
         Left            =   180
         TabIndex        =   10
         Top             =   1260
         Width           =   1830
      End
      Begin VB.Label Label1 
         Caption         =   "�w���X�|�C���g(&H):"
         Height          =   180
         Index           =   5
         Left            =   180
         TabIndex        =   13
         Top             =   2040
         Width           =   1470
      End
      Begin VB.Label lblJudCmtStc 
         Caption         =   "12345678"
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
         Left            =   3300
         TabIndex        =   21
         Top             =   1260
         Width           =   3255
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "�ΏۂƂȂ�f�[�^"
      Height          =   1575
      Left            =   120
      TabIndex        =   17
      Top             =   120
      Width           =   6975
      Begin VB.CommandButton cmdSentence 
         Caption         =   "�Q��(&B)..."
         Height          =   315
         Left            =   2220
         TabIndex        =   23
         Top             =   1140
         Width           =   1275
      End
      Begin VB.TextBox txtStrAge 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2220
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtEndAge 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   3180
         MaxLength       =   6
         TabIndex        =   2
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtLowerValue 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2220
         MaxLength       =   8
         TabIndex        =   4
         Text            =   "@@@@@@@@"
         Top             =   780
         Width           =   1095
      End
      Begin VB.TextBox txtUpperValue 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   3600
         MaxLength       =   8
         TabIndex        =   5
         Text            =   "@@@@@@@@"
         Top             =   780
         Width           =   1095
      End
      Begin VB.ComboBox cboTeisei 
         BeginProperty Font 
            Name            =   "�l�r �o�S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmEditStdValueItem.frx":0094
         Left            =   2220
         List            =   "frmEditStdValueItem.frx":00B6
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   22
         Top             =   780
         Width           =   1470
      End
      Begin VB.Label lblSentence 
         Caption         =   "��������������������"
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
         Left            =   3420
         TabIndex        =   24
         Top             =   840
         Width           =   3375
      End
      Begin VB.Label Label1 
         Caption         =   "�N��K�p�͈�(&A):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   420
         Width           =   1470
      End
      Begin VB.Label Label2 
         Caption         =   "�`"
         Height          =   255
         Index           =   0
         Left            =   2940
         TabIndex        =   19
         Top             =   420
         Width           =   255
      End
      Begin VB.Label Label1 
         Caption         =   "���ʒl�K�p�͈�(&R):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   3
         Top             =   840
         Width           =   1650
      End
      Begin VB.Label LabelValue 
         Caption         =   "�`"
         Height          =   255
         Left            =   3360
         TabIndex        =   18
         Top             =   840
         Width           =   255
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5760
      TabIndex        =   16
      Top             =   6000
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4320
      TabIndex        =   15
      Top             =   6000
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   120
      Top             =   5880
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   4
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":00D8
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":052A
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":097C
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":0AD6
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmEditStdValueItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrResultType          As String           '���ʃ^�C�v
Private mstrStrAge              As String           '�J�n�N��
Private mstrEndAge              As String           '�I���N��
Private mstrLowerValue          As String           '��l�i�ȏ�j
Private mstrUpperValue          As String           '��l�i�ȉ��j
Private mstrStdFlg              As String           '��l�t���O
Private mstrJudCd               As String           '����R�[�h
Private mstrJudCmtCd            As String           '����R�����g�R�[�h
Private mstrHealthPoint         As String           '�w���X�|�C���g
Private mblnMultiSelect         As Boolean          '��l���ׂ̕����I��

Private mvntStcCode()           As Variant          '��l�p���̓R�[�h�z��
Private mvntSentence()          As Variant          '���͔z��
Private mintSentenceCount       As Integer          '�I�����ꂽ���͂̐�

'���̓^�C�v�̂ݎg�p
Private mintItemType            As String           '���ڃ^�C�v
Private mstrStcItemCd           As String           '���͎Q�Ɨp���ڃR�[�h

Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����
Private mblnModeNew             As Boolean          'TRUE:�V�K�AFALSE:�X�V

Private mstrArrStdFlg()         As String           '�R���{�Ή��p��l�t���O�z��
Private mstrArrJudCd()          As String           '�R���{�Ή��p����R�[�h�z��

Private mstrArrTeisei(10)       As String           '�R���{�Ή��p�萫�P�C�Q�z��

Private mcolItemHistory         As Collection       '�������ڗ������R�[�h�̃R���N�V����

Private Const DefaultStrAge As String = "0"
Private Const DefaultEndAge As String = "999.99"

Private Sub cboTeisei_Click()

    txtLowerValue.Text = mstrArrTeisei(cboTeisei.ListIndex)

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : ����f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ����f�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditJud() As Boolean

    Dim objJud          As Object       '���蕪�ރA�N�Z�X�p
    Dim vntJudCd        As Variant
    Dim vntJudName      As Variant

    Dim lngCount        As Long         '���R�[�h��
    Dim i               As Long         '�C���f�b�N�X
    
    EditJud = False
    
    cboJud.Clear
    Erase mstrArrJudCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJud = CreateObject("HainsJud.Jud")
    lngCount = objJud.SelectJudList(vntJudCd, vntJudName)
    
    '����R�[�h�͖��I������
    ReDim Preserve mstrArrJudCd(0)
    mstrArrJudCd(0) = ""
    cboJud.AddItem ""
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrJudCd(i + 1)
        mstrArrJudCd(i + 1) = vntJudCd(i)
        cboJud.AddItem vntJudCd(i) & ":" & vntJudName(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���i���蕪�ނ͖��I������j
    cboJud.ListIndex = 0
    
    EditJud = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub cmdGuide_Click()
    
    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '���ڃK�C�h�\���p
    
    Dim lngCount        As Long     '���R�[�h��
    Dim i               As Long     '�C���f�b�N�X
    Dim strKey          As String   '�d���`�F�b�N�p�̃L�[
    Dim strWorkString   As String
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = False
        .TargetTable = getJudCmtStc
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
    
        '�I��������0���ȏ�Ȃ�
        If .RecordCount > 0 Then
            
            txtJudCmtCd.Text = .RecordCode(0)
            '�v��ׁ̈A���s�R�[�h���������ăZ�b�g
            lblJudCmtStc.Caption = OmitCrLf(CStr(.RecordName(0)))
        
        End If
    
    End With

    Set objCommonGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Function OmitCrLf(strTargetString As String) As String

    Dim strWorkString   As String

    OmitCrLf = strTargetString

    '�v��ׁ̈A���s�R�[�h����
    strWorkString = Replace(Trim(strTargetString), vbCrLf, "")
    strWorkString = Replace(strWorkString, vbLf, "")
    
    If Len(strWorkString) > 17 Then
        OmitCrLf = Mid(strWorkString, 1, 17) & "..."
    Else
        OmitCrLf = strWorkString
    End If

End Function

Private Sub cmdOk_Click()

    '���̓`�F�b�N
    If CheckValue() = False Then Exit Sub
    
    '�v���p�e�B�l�̉�ʃZ�b�g
    mstrStrAge = txtStrAge.Text
    mstrEndAge = txtEndAge.Text
    mstrLowerValue = txtLowerValue.Text
    mstrUpperValue = txtUpperValue.Text
    mstrHealthPoint = txtHealthPoint.Text
    mstrStdFlg = mstrArrStdFlg(cboStdFlg.ListIndex)
    mstrJudCd = mstrArrJudCd(cboJud.ListIndex)
    mstrJudCmtCd = txtJudCmtCd.Text

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
' ���l�@�@ : �u���������͂���Ă��܂���v��MSG�ɖO�������Ȃ��̂��߂ɏ���ɂ����މ��l���W�b�N
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '�֐��߂�l
    Dim strWorkResult   As String
        
    '����R���g���[����SetFocus�ł͕�����I�����L���ɂȂ�Ȃ��̂Ń_�~�[�łƂ΂�
    cmdOk.SetFocus
    
    Ret = False
    
    Do
        '�N��i���j�̖����̓`�F�b�N�i����ɂ����ށj
        If Trim(txtStrAge.Text) = "" Then
            txtStrAge.Text = DefaultStrAge
        End If
        
        '�N��i��j�̓��̓`�F�b�N�i����ɂ����ށj
        If Trim(txtEndAge.Text) = "" Then
            txtEndAge.Text = DefaultEndAge
        End If

        '�N��i���j�̐��l�`�F�b�N
        If IsNumeric(txtStrAge.Text) = False Then
            MsgBox "�N��K�p�͈͂ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtStrAge.SetFocus
            Exit Do
        End If
        
        '�N��i��j�̐��l�`�F�b�N
        If IsNumeric(txtEndAge.Text) = False Then
            MsgBox "�N��K�p�͈͂ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtEndAge.SetFocus
            Exit Do
        End If
        
        txtStrAge.Text = Trim(txtStrAge.Text)
        txtEndAge.Text = Trim(txtEndAge.Text)

        '�N��i�㉺�j���t�̃`�F�b�N
        If CDbl(txtStrAge.Text) > CDbl(txtEndAge.Text) Then
            '����ɋt���ɂ��܂��B
            strWorkResult = txtEndAge.Text
            txtEndAge.Text = txtStrAge.Text
            txtStrAge.Text = strWorkResult
        End If

'## 2002.05.02 Added by Ishihara@FSIT �N��i��j�ɏ����_���w�肳��Ă��Ȃ��ꍇ�A�����_��ǉ�����
        '�N��i����j�ɍő�l�Ƃ��Ă�.99��ǉ�
        If (CDbl(txtEndAge.Text) - Int(CDbl(txtEndAge.Text))) = 0 Then
            If Mid(Trim(txtEndAge.Text), Len(Trim(txtEndAge.Text)), 1) = "." Then
                txtEndAge.Text = txtEndAge.Text & "99"
            Else
                txtEndAge.Text = txtEndAge.Text & ".99"
            End If
        End If
'## 2002.05.02 Added End
        
        '��l�̃`�F�b�N
        If (Trim(txtLowerValue.Text) = "") And (Trim(txtUpperValue.Text) = "") Then
            MsgBox "��l�����͂���Ă��܂���B", vbExclamation, App.Title
            
            If (mstrResultType = RESULTTYPE_TEISEI1) Or _
               (mstrResultType = RESULTTYPE_TEISEI2) Then
                cboTeisei.SetFocus
            Else
                If txtLowerValue.Visible = True Then txtLowerValue.SetFocus
            End If
            
            Exit Do
        End If
        
        '���ʃ^�C�v�����͂̏ꍇ�̊�l
        If mstrResultType = RESULTTYPE_SENTENCE Then
            
            If Trim(txtLowerValue.Text) = "" Then
                MsgBox "��l�����͂���Ă��܂���B", vbExclamation, App.Title
                If txtLowerValue.Visible = True Then txtLowerValue.SetFocus
            End If
            
            txtLowerValue.Text = Trim(txtLowerValue.Text)
            txtUpperValue.Text = txtLowerValue.Text
        
            '���̓J�E���g�����C���N�������g����Ă��Ȃ��Ȃ�A���ړ��́i����Ă���Ȃ�K�C�h����̑I���B�m�[�`�F�b�N�j
            If mintSentenceCount < 1 Then
                            
                '���̓R�[�h�̃`�F�b�N
                If EditSentence() = False Then
                    If txtLowerValue.Visible = True Then txtLowerValue.SetFocus
                    lblSentence.Caption = ""
                    Exit Do
                End If
            
                '���͂Ŕz��쐬
                Erase mvntStcCode
                Erase mvntSentence
                ReDim Preserve mvntStcCode(0)
                ReDim Preserve mvntSentence(0)
                mvntStcCode(0) = txtLowerValue.Text
                mvntSentence(0) = lblSentence.Caption
                mintSentenceCount = 1
            
            End If
                        
        End If

        '��l�̐��l�`�F�b�N�i���l�^�C�v�A�v�Z�^�C�v�̏ꍇ�̂݁j
        If (mstrResultType = RESULTTYPE_NUMERIC) Or _
           (mstrResultType = RESULTTYPE_CALC) Then
            
            '��l�i���j�̓��̓`�F�b�N�i����ɂ����ށj
            If Trim(txtLowerValue.Text) = "" Then
                txtLowerValue.Text = -9999999
            End If
                    
            '��l�i��j�̓��̓`�F�b�N�i����ɂ����ށj
            If Trim(txtUpperValue.Text) = "" Then
                txtUpperValue.Text = 99999999
            End If
                    
            '���l�`�F�b�N
            If (IsNumeric(txtLowerValue.Text) = False) Or _
               (IsNumeric(txtUpperValue.Text) = False) Then
                MsgBox "��l�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
                txtLowerValue.SetFocus
                Exit Do
            End If
                    
            '��l�̏㉺���t�Ȃ珟��ɃZ�b�g��������
            If CDbl(txtUpperValue.Text) < CDbl(txtLowerValue.Text) Then
                strWorkResult = txtUpperValue.Text
                txtUpperValue.Text = txtLowerValue.Text
                txtLowerValue.Text = strWorkResult
            End If
                    
        End If
        
        '���ʃ^�C�v���萫�̏ꍇ�A��l�i��j�ɓ������̂��Z�b�g
        If (mstrResultType = RESULTTYPE_TEISEI1) Or _
           (mstrResultType = RESULTTYPE_TEISEI2) Then
            txtUpperValue.Text = txtLowerValue.Text
        End If
        
        '����R�����g�R�[�h�̃`�F�b�N
        If EditJudCmtStc() = False Then
            txtJudCmtCd.SetFocus
            lblJudCmtStc.Caption = ""
            Exit Do
        End If
        
        '�w���X�|�C���g�̐��l�`�F�b�N
        If Trim(txtHealthPoint.Text) <> "" Then
            
            If (IsNumeric(txtHealthPoint.Text) = False) Then
                MsgBox "�w���X�|�C���g�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
                txtHealthPoint.SetFocus
                Exit Do
            End If
        
            If (CDbl(txtHealthPoint.Text) > 999.9) Or _
               (CDbl(txtHealthPoint.Text) < -999.9) Then
                MsgBox "�w���X�|�C���g�ɐݒ�\�Ȓl��-999.9�`999.9�ł��B", vbExclamation, App.Title
                txtHealthPoint.SetFocus
                Exit Do
            End If
        
        End If

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

Private Sub cmdSentence_Click()
    
    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '���ڃK�C�h�\���p
    Dim i               As Long     '�C���f�b�N�X
    Dim intRecordCount  As Integer
    Dim vntCode         As Variant
    Dim vntName         As Variant
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = mblnModeNew  '�����I���̓��[�h�ɂ���
        .TargetTable = getSentence
        .ItemType = mintItemType
        .ItemCd = mstrStcItemCd
    
        '���̓K�C�h��ʂ��J��
        .Show vbModal
    
        intRecordCount = .RecordCount
        vntCode = .RecordCode
        vntName = .RecordName
    
    End With
        
    '�I��������0���ȏ�Ȃ�
    If intRecordCount > 0 Then
    
        '�I�����R�[�h�����P�Ȃ�e�L�X�g�{�b�N�X�ɃZ�b�g
        If intRecordCount = 1 Then
            txtLowerValue.Text = vntCode(0)
            lblSentence.Caption = vntName(0)
        Else
            txtLowerValue.Text = "*"
            lblSentence.Caption = "�����̕��͂��I������Ă��܂��B"
        End If
        
        '���͊i�[�p�z��Ɋi�[
        Erase mvntStcCode
        Erase mvntSentence
        mintSentenceCount = 0

        ReDim Preserve mvntStcCode(intRecordCount)
        ReDim Preserve mvntSentence(intRecordCount)
        
        '�z��Ɋi�[
        For i = 0 To intRecordCount - 1
            mvntStcCode(i) = vntCode(i)
            mvntSentence(i) = vntName(i)
            mintSentenceCount = mintSentenceCount + 1
        Next i
        
    End If

    Set objCommonGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub Form_Load()

    Dim i       As Integer

    mblnUpdated = False

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)
    cboTeisei.Clear
    cboTeisei.Visible = False
    cmdSentence.Visible = False

    '�������ڗ������̕ҏW
    Call SetItemHistory

    '��l�t���O�̃R���{�Z�b�g
    With cboStdFlg
        .Clear
        .AddItem ""
        .AddItem "S:�W��"
        .AddItem "X:�W���i��l�O�j"
        .AddItem "@:�萫�y�x�ُ�"
        .AddItem "*:�萫�l�ُ�"
        .AddItem "L:�ُ�i���j"
        .AddItem "D:�y�x�ُ�i���j"
        .AddItem "U:�y�x�ُ�i��j"
        .AddItem "H:�ُ�i��j"
        .ListIndex = 0
    End With
    
    '��l�t���O�̃R���{�Ή��z��
    ReDim Preserve mstrArrStdFlg(8)
    mstrArrStdFlg(0) = ""
    mstrArrStdFlg(1) = "S"
    mstrArrStdFlg(2) = "X"
    mstrArrStdFlg(3) = "@"
    mstrArrStdFlg(4) = "*"
    mstrArrStdFlg(5) = "L"
    mstrArrStdFlg(6) = "D"
    mstrArrStdFlg(7) = "U"
    mstrArrStdFlg(8) = "H"
    
    '����R���{�̕ҏW
    If EditJud() = False Then
        Exit Sub
    End If
    
    '�v���p�e�B�l�̉�ʃZ�b�g
    txtStrAge.Text = mstrStrAge
    txtEndAge.Text = mstrEndAge
    
    '��l�����I���̏ꍇ�A�l�ɂ�"0"���Z�b�g
    If mblnMultiSelect = True Then
        txtLowerValue.Text = "0"
        txtUpperValue.Text = "0"
    Else
        txtLowerValue.Text = mstrLowerValue
        txtUpperValue.Text = mstrUpperValue
    End If
    
    '��l�i���j���Z�b�g����ĂȂ��Ƃ������Ƃ́A�V�K���[�h
    If Trim(mstrLowerValue) = "" Then
        mblnModeNew = True
    Else
        mblnModeNew = False
    End If
    
    txtHealthPoint.Text = mstrHealthPoint
    txtJudCmtCd.Text = mstrJudCmtCd
    
    '����R�����g�����̕\��
    Call EditJudCmtStc
    
    '�f�t�H���g�Z�b�g���ꂽ��l�Z�b�g
    If mstrStdFlg <> "" Then
        For i = 0 To UBound(mstrArrStdFlg)
            If mstrArrStdFlg(i) = mstrStdFlg Then
                cboStdFlg.ListIndex = i
            End If
        Next i
    End If
    
    '�f�t�H���g�Z�b�g���ꂽ����R�[�h�Z�b�g
    If mstrJudCd <> "" Then
        For i = 0 To UBound(mstrArrJudCd)
            If mstrArrJudCd(i) = mstrJudCd Then
                cboJud.ListIndex = i
            End If
        Next i
    End If
    
    '�N��Z�b�g����Ă��Ȃ��Ȃ�A����ɃZ�b�g�i�傫�Ȃ����b�V���[�Y�j
    If txtStrAge.Text = "" Then txtStrAge.Text = DefaultStrAge
    If txtEndAge.Text = "" Then txtEndAge.Text = DefaultEndAge
    
    Select Case mstrResultType
        
        '�萫�^�C�v�P
        Case RESULTTYPE_TEISEI1
            
            '���͗p�e�L�X�g�{�b�N�X�s�v
            txtLowerValue.Visible = False
            txtUpperValue.Visible = False
            LabelValue.Visible = False
            cboTeisei.Visible = True
            
            mstrArrTeisei(0) = "-"
            mstrArrTeisei(1) = "+-"
            mstrArrTeisei(2) = "+"
            With cboTeisei
                .AddItem "�i�|�j"
                .AddItem "�i�{�|�j"
                .AddItem "�i�{�j"
                .ListIndex = 0
            End With
                    
            For i = 0 To 2
                If (mstrArrTeisei(i) = txtLowerValue) Or _
                   (mstrArrTeisei(i) = txtUpperValue) Then
                    cboTeisei.ListIndex = i
                End If
            Next i
        
        '�萫�^�C�v�Q
        Case RESULTTYPE_TEISEI2
            
            '���͗p�e�L�X�g�{�b�N�X�s�v
            txtLowerValue.Visible = False
            txtUpperValue.Visible = False
            LabelValue.Visible = False
            cboTeisei.Visible = True
            
            mstrArrTeisei(0) = "-"
            mstrArrTeisei(1) = "+-"
            With cboTeisei
                .AddItem "�i�|�j"
                .AddItem "�i�{�|�j"
                For i = 1 To 9
'## 2003.02.12 Mod 4Lines By T.Takagi@FSIT ���ʓ��͂Łu�P�{�v�͓��͂ł��Ȃ��i�����́u�{�v�j�Ȃ̂ō��v����悤�C��
'                    .AddItem "�i" & StrConv(CStr(i), vbWide) & "�{�j"
'                    mstrArrTeisei(i + 1) = i & "+"
                    .AddItem "�i" & StrConv(IIf(i >= 2, CStr(i), ""), vbWide) & "�{�j"
                    mstrArrTeisei(i + 1) = IIf(i >= 2, CStr(i), "") & "+"
'## 2003.02.12 Mod End
                Next i
            End With
                    
            For i = 0 To 10
                If (mstrArrTeisei(i) = txtLowerValue) Or _
                   (mstrArrTeisei(i) = txtUpperValue) Then
                    cboTeisei.ListIndex = i
                End If
            Next i
        
        '���̓^�C�v�̃Z�b�g
        Case RESULTTYPE_SENTENCE
        
            '�J�n���͗p�e�L�X�g�{�b�N�X�s�v
            txtUpperValue.Visible = False
            LabelValue.Visible = False
            cmdSentence.Visible = True
            
            '���̓^�C�v�̏ꍇ�A���͂͊�l�i��j�Ɋi�[����Ă���
            lblSentence.Caption = Trim(mstrUpperValue)
        
    End Select
    
    '��l�����I���̏ꍇ�A��l���͊֌W�̃R���g���[���͑S���g�p�s��
    If mblnMultiSelect = True Then
        txtUpperValue.Visible = False
        txtLowerValue.Visible = False
        LabelValue.Visible = False
        cmdSentence.Visible = False
        lblSentence.Visible = False
    
        '���͑I���ς݂̃n���h�����O
        mintSentenceCount = 1
    End If

End Sub

Private Sub SetItemHistory()

    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim objItemHistory      As ItemHistory
    Dim strDateInterval     As String
    Dim i                   As Long             '�C���f�b�N�X
    
    '�w�b�_�̕ҏW
    lsvUnit.ListItems.Clear
    Set objHeader = lsvUnit.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�L������", 2600, lvwColumnLeft
    objHeader.Add , , "������", 800, lvwColumnRight
    objHeader.Add , , "������", 800, lvwColumnRight
    objHeader.Add , , "�ŏ��l", 900, lvwColumnRight
    objHeader.Add , , "�ő�l", 900, lvwColumnRight
        
    lsvUnit.View = lvwReport
    
    '���X�g�̕ҏW
    For Each objItemHistory In mcolItemHistory
        With objItemHistory
            strDateInterval = .strDate & "�`" & .endDate
            Set objItem = lsvUnit.ListItems.Add(, .UniqueKey, strDateInterval, , "DEFAULTLIST")
            objItem.SubItems(1) = .Figure1
            objItem.SubItems(2) = .Figure2
            objItem.SubItems(3) = .MinValue
            objItem.SubItems(4) = .MaxValue
        End With
    Next objItemHistory
    
    '�I�u�W�F�N�g�p��
    Set objItemHistory = Nothing

End Sub

'
' �@�\�@�@ : ����R�����g���͕ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditJudCmtStc() As Boolean

    Dim objJudCmtStc    As Object           '����R�����g�A�N�Z�X�p
    
    Dim vntJudCmtStc    As Variant          '����R�����g��
    Dim vntJudClassCd   As Variant          '���蕪�ރR�[�h
    Dim Ret             As Boolean          '�߂�l
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    EditJudCmtStc = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    Do
        '����R�����g�R�[�h���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If Trim(txtJudCmtCd.Text) = "" Then
            Ret = True
            Exit Do
        End If
        
        '����R�����g�e�[�u�����R�[�h�ǂݍ���
        If objJudCmtStc.SelectJudCmtStc(Trim(txtJudCmtCd.Text), _
                                        vntJudCmtStc, _
                                        vntJudClassCd) = False Then
            MsgBox "�w�肳�ꂽ����R�����g�R�[�h�̏����𖞂������R�[�h�����݂��܂���B", vbExclamation, App.Title
            Exit Do
        End If
    
        '�v��ׁ̈A���s�R�[�h���������ăZ�b�g
        lblJudCmtStc.Caption = OmitCrLf(CStr(vntJudCmtStc))
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditJudCmtStc = Ret
    
    Exit Function

ErrorHandle:

    EditJudCmtStc = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' �@�\�@�@ : ���̓f�[�^�ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditSentence() As Boolean

    Dim objSentence     As Object           '���̓A�N�Z�X�p
    Dim vntShortStc     As Variant          '����
    Dim Ret             As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    Do
        
        '���̓R�[�h���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If Trim(txtLowerValue.Text) = "" Then
            Ret = False
            Exit Do
        End If
        
        '���̓e�[�u�����R�[�h�ǂݍ���
        If objSentence.SelectSentence(mstrStcItemCd, _
                                      mintItemType, _
                                      Trim(txtLowerValue.Text), _
                                      vntShortStc) = False Then
            MsgBox "�w�肳�ꂽ���̓R�[�h�̏����𖞂������R�[�h�����݂��܂���B", vbExclamation, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        lblSentence.Caption = vntShortStc
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditSentence = Ret
    
    Exit Function

ErrorHandle:

    EditSentence = False
    MsgBox Err.Description, vbCritical
    
End Function



Friend Property Get ResultType() As Variant
    
    ResultType = mstrResultType

End Property

Friend Property Let ResultType(ByVal vNewValue As Variant)

    mstrResultType = vNewValue

End Property

Friend Property Get StrAge() As Variant
    
    StrAge = mstrStrAge

End Property

Friend Property Let StrAge(ByVal vNewValue As Variant)

    mstrStrAge = vNewValue

End Property

Friend Property Get EndAge() As Variant

    EndAge = mstrEndAge

End Property

Friend Property Let EndAge(ByVal vNewValue As Variant)

    mstrEndAge = vNewValue

End Property

Friend Property Get LowerValue() As Variant

    LowerValue = mstrLowerValue

End Property

Friend Property Let LowerValue(ByVal vNewValue As Variant)

    mstrLowerValue = vNewValue

End Property

Friend Property Get UpperValue() As Variant

    UpperValue = mstrUpperValue

End Property

Friend Property Let UpperValue(ByVal vNewValue As Variant)

    mstrUpperValue = vNewValue
    
End Property

Friend Property Get StdFlg() As Variant

    StdFlg = mstrStdFlg

End Property

Friend Property Let StdFlg(ByVal vNewValue As Variant)

    mstrStdFlg = vNewValue
    
End Property

Friend Property Get JudCd() As Variant

    JudCd = mstrJudCd

End Property

Friend Property Let JudCd(ByVal vNewValue As Variant)

    mstrJudCd = vNewValue

End Property

Friend Property Get JudCmtCd() As Variant

    JudCmtCd = mstrJudCmtCd

End Property

Friend Property Let JudCmtCd(ByVal vNewValue As Variant)

    mstrJudCmtCd = vNewValue

End Property

Friend Property Get HealthPoint() As Variant

    HealthPoint = mstrHealthPoint

End Property

Friend Property Let HealthPoint(ByVal vNewValue As Variant)

    mstrHealthPoint = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Private Sub txtJudCmtCd_Change()

    lblJudCmtStc.Caption = ""

End Sub

Private Sub txtJudCmtCd_LostFocus()

    If Trim(txtJudCmtCd.Text) = "" Then
        lblJudCmtStc.Caption = ""
    End If

End Sub

Friend Property Let ItemType(ByVal vNewValue As String)

    mintItemType = vNewValue

End Property

Friend Property Let StcItemCd(ByVal vNewValue As String)

    mstrStcItemCd = vNewValue

End Property

Friend Property Let MultiSelect(ByVal vNewValue As Boolean)

    mblnMultiSelect = vNewValue

End Property

Friend Property Get SentenceCount() As Integer

    SentenceCount = mintSentenceCount

End Property

Friend Property Get StcCd() As Variant

    StcCd = mvntStcCode

End Property

Friend Property Get Sentence() As Variant

    Sentence = mvntSentence

End Property

Private Sub txtLowerValue_Change()

    '���̓N���A�i���̓^�C�v�ȊO�͊֌W����܂��񂪁j
    lblSentence.Caption = ""

    '���͔z��N���A
    Erase mvntStcCode
    Erase mvntSentence
    mintSentenceCount = 0

End Sub

Friend Property Let ItemHistory(ByVal vNewValue As Collection)

    Set mcolItemHistory = vNewValue
    
End Property
