VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmGroup 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�O���[�v�e�[�u�������e�i���X"
   ClientHeight    =   7185
   ClientLeft      =   2040
   ClientTop       =   330
   ClientWidth     =   6225
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmGroup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7185
   ScaleWidth      =   6225
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.CheckBox chkSystemGrp 
      Caption         =   "���̃O���[�v�͒ʏ�Ɩ���ʂɕ\�����Ȃ�(&F):"
      Height          =   195
      Left            =   180
      TabIndex        =   25
      ToolTipText     =   "�V�X�e������p�ȂǓ����I�Ɏg�p����O���[�v�ɒ�`���܂��B"
      Top             =   6360
      Width           =   4335
   End
   Begin VB.Frame Frame2 
      Caption         =   "��������(&I)"
      Height          =   2895
      Left            =   120
      TabIndex        =   14
      Top             =   3360
      Width           =   6015
      Begin VB.CommandButton cmdInsert_Title 
         Caption         =   "�V�K���o��(&M)..."
         Height          =   315
         Left            =   1620
         TabIndex        =   26
         Top             =   2460
         Width           =   1515
      End
      Begin VB.CommandButton cmdDownItem 
         Caption         =   "��"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   180
         TabIndex        =   16
         Top             =   1380
         Width           =   315
      End
      Begin VB.CommandButton cmdUpItem 
         Caption         =   "��"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   180
         TabIndex        =   15
         Top             =   840
         Width           =   315
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "�ǉ�(&A)..."
         Height          =   315
         Left            =   3240
         TabIndex        =   18
         Top             =   2460
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "�폜(&R)"
         Height          =   315
         Left            =   4620
         TabIndex        =   19
         Top             =   2460
         Width           =   1275
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   2100
         Left            =   540
         TabIndex        =   17
         Top             =   300
         Width           =   5355
         _ExtentX        =   9446
         _ExtentY        =   3704
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   3480
      TabIndex        =   21
      Top             =   6720
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2100
      TabIndex        =   20
      Top             =   6720
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   4860
      TabIndex        =   22
      Top             =   6720
      Width           =   1275
   End
   Begin VB.Frame Frame1 
      Caption         =   "��{���(&B)"
      Height          =   2535
      Left            =   120
      TabIndex        =   0
      Top             =   720
      Width           =   6015
      Begin VB.TextBox txtOldSetCd 
         Enabled         =   0   'False
         Height          =   318
         Left            =   1680
         MaxLength       =   7
         TabIndex        =   28
         Text            =   "1234567"
         Top             =   2100
         Width           =   1155
      End
      Begin VB.ComboBox cboItemClass 
         Height          =   300
         ItemData        =   "frmGroup.frx":000C
         Left            =   1680
         List            =   "frmGroup.frx":002E
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   7
         Top             =   1380
         Width           =   2550
      End
      Begin VB.ComboBox cboSearchChar 
         Height          =   300
         ItemData        =   "frmGroup.frx":0050
         Left            =   1680
         List            =   "frmGroup.frx":0072
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   13
         Top             =   1740
         Width           =   810
      End
      Begin VB.TextBox txtPrice2 
         Height          =   318
         Left            =   4020
         MaxLength       =   7
         TabIndex        =   11
         Text            =   "1234567"
         Top             =   2100
         Visible         =   0   'False
         Width           =   795
      End
      Begin VB.TextBox txtPrice1 
         Height          =   318
         Left            =   4980
         MaxLength       =   7
         TabIndex        =   9
         Text            =   "1234567"
         Top             =   540
         Visible         =   0   'False
         Width           =   795
      End
      Begin VB.TextBox txtGrpCd 
         Height          =   315
         IMEMode         =   3  '�̌Œ�
         Left            =   1680
         MaxLength       =   5
         TabIndex        =   2
         Text            =   "1234G"
         Top             =   660
         Width           =   675
      End
      Begin VB.TextBox txtGrpName 
         Height          =   318
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   1680
         MaxLength       =   10
         TabIndex        =   4
         Text            =   "���������g�Q��"
         Top             =   1020
         Width           =   2055
      End
      Begin VB.Label Label4 
         Caption         =   "���Z�b�g�R�[�h(&T):"
         Height          =   195
         Left            =   240
         TabIndex        =   27
         Top             =   2160
         Width           =   1395
      End
      Begin VB.Label lblGrpDiv 
         Caption         =   "�˗����ڂ��Ǘ����܂�"
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
         Left            =   1680
         TabIndex        =   24
         Top             =   360
         Width           =   1875
      End
      Begin VB.Label Label8 
         Caption         =   "��������(&K)"
         Height          =   195
         Index           =   1
         Left            =   240
         TabIndex        =   6
         Top             =   1440
         Width           =   1335
      End
      Begin VB.Label LabelPrice2 
         Caption         =   "��{�����Q(&T):"
         Height          =   195
         Left            =   2700
         TabIndex        =   10
         Top             =   2160
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label Label3 
         Caption         =   "�����p������(&C):"
         Height          =   195
         Index           =   2
         Left            =   240
         TabIndex        =   12
         Top             =   1800
         Width           =   1395
      End
      Begin VB.Label LabelPrice1 
         Caption         =   "��{�����P(&T):"
         Height          =   195
         Left            =   3540
         TabIndex        =   8
         Top             =   600
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label Label8 
         Caption         =   "�O���[�v�̎��:"
         Height          =   195
         Index           =   0
         Left            =   240
         TabIndex        =   5
         Top             =   360
         Width           =   1395
      End
      Begin VB.Label Label1 
         Caption         =   "�O���[�v�R�[�h(&C):"
         Height          =   195
         Index           =   2
         Left            =   240
         TabIndex        =   1
         Top             =   720
         Width           =   1275
      End
      Begin VB.Label Label2 
         Caption         =   "�O���[�v��(&N):"
         Height          =   195
         Left            =   240
         TabIndex        =   3
         Top             =   1080
         Width           =   1095
      End
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   0
      Left            =   180
      Picture         =   "frmGroup.frx":0094
      Top             =   180
      Width           =   480
   End
   Begin VB.Label LabelCourseGuide 
      Caption         =   "�������ڂ��O���[�v�Ƃ��ĂƂ�܂Ƃ߂܂��B"
      Height          =   255
      Left            =   840
      TabIndex        =   23
      Top             =   300
      Width           =   3915
   End
End
Attribute VB_Name = "frmGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p�̈�
Private mstrGrpCd       As String   '�O���[�v�R�[�h
Private mintGrpDiv      As Integer  '�O���[�v�敪
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnShowOnly    As Boolean  'TRUE:�f�[�^�̍X�V�����Ȃ��i�Q�Ƃ̂݁j
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s

'���W���[���ŗL�̈�̈�
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����
Private mstrClassCd()   As String   '�������ރR�[�h�i�z��́A�R���{�{�b�N�X�ƑΉ��j

Private Midashicounter As Long
Const mstrListViewKey   As String = "K"


Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property


' @(e)
'
' �@�\�@�@ : �u���ڒǉ��vClick
'
' �@�\���� : �w��R�[�X�����Ɏ�f���ڂ�ǉ�����
'
' ���l�@�@ :
'
Private Sub cmdAddItem_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    Dim objItem         As ListItem                 '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim i               As Long     '�C���f�b�N�X
    Dim strKey          As String   '�d���`�F�b�N�p�̃L�[
    Dim strItemString   As String
    Dim strItemKey      As String   '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCdString As String   '�\���p�L�[�ҏW�̈�
    
    Dim lngItemCount    As Long     '�I�����ڐ�
    Dim vntItemCd       As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntSuffix       As Variant  '�I�����ꂽ�T�t�B�b�N�X
    Dim vntItemName     As Variant  '�I�����ꂽ���ږ�
    Dim vntClassName    As Variant  '�I�����ꂽ�������ޖ�
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = mintGrpDiv
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = mintGrpDiv - 1
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
        
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
        vntItemName = .ItemName
        vntClassName = .ClassName
    
    End With
        
    Screen.MousePointer = vbHourglass
    Me.Refresh
        
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then
    
        '���X�g�̕ҏW
        For i = 0 To lngItemCount - 1
            
            '�L�[�l�ƕ\���R�[�h�̕ҏW
            If mintGrpDiv = MODE_RESULT Then
                '�������ڂ̏ꍇ
                strItemCdString = vntItemCd(i) & "-" & vntSuffix(i)
                strItemKey = mstrListViewKey & strItemCdString
            Else
                '�˗����ڂ̏ꍇ
                strItemCdString = vntItemCd(i)
                strItemKey = mstrListViewKey & strItemCdString
            End If
            
            '���X�g��ɑ��݂��邩�`�F�b�N����
            If CheckExistsItemCd(lsvItem, strItemKey) = False Then
            
                '�Ȃ���Βǉ�����
                Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
                objItem.SubItems(1) = vntItemName(i)
                objItem.SubItems(2) = vntClassName(i)
            
            End If
        Next i
    
    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

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

    Dim Ctrl        As Object
    Dim i           As Integer
    Dim objHeader   As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objButton   As CommandButton        '�R�}���h�{�^���I�u�W�F�N�g
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������
    
    '�I�u�W�F�N�g�̃C���X�^���X�̍쐬
    Set objButton = cmdInsert_Title

    
    '�O���[�v�̎��
    If mintGrpDiv = MODE_REQUEST Then
        lblGrpDiv.Caption = "�˗����ڂ��Ǘ����܂�"
'##2003.09.11 add T-ISHI@FSIT �V�K���o���{�^���̔�E�\���̐ݒ�
'        objButton.Visible = False
'##add end
    Else
        lblGrpDiv.Caption = "�������ڂ��Ǘ����܂�"
        txtPrice1.Enabled = False
        txtPrice2.Enabled = False
        txtPrice1.BackColor = vbButtonFace
        txtPrice2.BackColor = vbButtonFace
        LabelPrice1.ForeColor = vbGrayText
        LabelPrice2.ForeColor = vbGrayText
'##2003.09.11 add T-ISHI@FSIT �V�K���o���{�^���̔�E�\���̐ݒ�
        objButton.Visible = True
'##add end
    End If
    
    txtPrice1.Text = 0
    txtPrice2.Text = 0
    
    '�����p������̎��
    Call InitSearchCharCombo(cboSearchChar)
    
End Sub
' @(e)
'
' �@�\�@�@ : �������ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditItemClass() As Boolean

    Dim objItem         As Object   '�R�[�X�A�N�Z�X�p
    
    Dim vntClassCd      As Variant
    Dim vntClassName    As Variant

    Dim lngCount    As Long             '���R�[�h��
    Dim i           As Long             '�C���f�b�N�X
    
    EditItemClass = False
    
    cboItemClass.Clear
    Erase mstrClassCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsItem.Item")
    lngCount = objItem.SelectItemClassList(vntClassCd, vntClassName)
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrClassCd(i)
        mstrClassCd(i) = vntClassCd(i)
        cboItemClass.AddItem vntClassName(i)
    Next i
    
    '�����f�[�^�����݂��Ȃ��Ȃ�A�G���[
    If lngCount <= 0 Then
        MsgBox "�������ނ����݂��܂���B�������ރf�[�^��o�^���Ȃ��ƃO���[�v�̍X�V���s�����Ƃ͂ł��܂���B", vbExclamation
        Exit Function
    End If
    
    '�擪�R���{��I����Ԃɂ���
    cboItemClass.ListIndex = 0
    EditItemClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function


' @(e)
'
' �@�\�@�@ : ��{�O���[�v����ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �O���[�v�̊�{������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditGrp() As Boolean

    Dim objGrp          As Object     '�O���[�v���A�N�Z�X�p
    
    Dim vntGrpName      As Variant
    Dim vntPrice1       As Variant
    Dim vntPrice2       As Variant
    Dim vntClassCd      As Variant
    Dim vntGrpDiv       As Variant
    Dim vntSearchChar   As Variant
    Dim vntSystemGrp    As Variant
    Dim vntOldSetCd     As Variant

    Dim Ret             As Boolean              '�߂�l
    Dim i               As Integer
    
    EditGrp = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrGrpCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�O���[�v�e�[�u�����R�[�h�ǂݍ���
        If objGrp.SelectGrp_P(mstrGrpCd, vntGrpName, vntPrice1, _
                              vntPrice2, vntClassCd, vntGrpDiv, vntSearchChar, vntSystemGrp, vntOldSetCd) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW�i�R�[�X��{���j
        txtGrpCd.Text = mstrGrpCd
        txtGrpName.Text = vntGrpName
        txtPrice1.Text = vntPrice1
        txtPrice2.Text = vntPrice2
        
        mintGrpDiv = vntGrpDiv
        If mintGrpDiv = MODE_REQUEST Then
            lblGrpDiv.Caption = "�˗����ڂ��Ǘ����܂�"
        Else
            lblGrpDiv.Caption = "�������ڂ��Ǘ����܂�"
        End If
        
        If vntSystemGrp = GRP_SYSTEMGRP Then
            chkSystemGrp.Value = vbChecked
        Else
            chkSystemGrp.Value = vbUnchecked
        End If
        
        '�������ރR���{�̐ݒ�
        For i = 0 To cboItemClass.ListCount - 1
            If mstrClassCd(i) = vntClassCd Then
                cboItemClass.ListIndex = i
            End If
        Next i
        
        '����������R���{�̐ݒ�
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i
    
        txtOldSetCd.Text = vntOldSetCd
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditGrp = Ret
    
    Exit Function

ErrorHandle:

    EditGrp = False
    MsgBox Err.Description, vbCritical
    
End Function
' @(e)
'
' �@�\�@�@ : �Ǘ��������ڕ\��
'
' �@�\���� : ���ݐݒ肳��Ă���O���[�v���������ڂ�\������
'
' ���l�@�@ :
'
Private Function EditListItem() As Boolean
    
On Error GoTo ErrorHandle

    Dim objGrp          As Object               '�O���[�v�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntClassName    As Variant              '�������ޖ���
    Dim vntItemDiv      As Variant              '���ڋ敪
    Dim vntItemCd       As Variant              '�R�[�h
    Dim vntItemSuffix   As Variant              '�T�t�B�b�N�X
    Dim vntItemName     As Variant              '����
    Dim vntseq          As Variant              'SEQ
    Dim lngCount        As Long                 '���R�[�h��
    Dim strItemKey      As String               '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCdString As String               '�\���p�L�[�ҏW�̈�
    Dim i               As Long                 '�C���f�b�N�X
'##2003.9.11�@add T-ISHI@FSIT�@���o���R�����g��ǉ�
    Dim vntrslCaption   As Variant              '���o��
'##add end
    EditListItem = False

    '���X�g�A�C�e���N���A
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    '�O���[�v���������ڌ���
    If mintGrpDiv = MODE_RESULT Then
        '�������ڂ̏ꍇ
'##2003.9.11�@add T-ISHI@FSIT�@���o���R�����g�����X�g�ɒǉ�
'        lngCount = objGrp.SelectGrp_I_ItemList_AddCaption(mstrGrpCd, vntItemCd, vntItemSuffix, _
'                                               vntItemName, , , , vntClassName, vntseq)
        lngCount = objGrp.SelectGrp_I_ItemList_AddCaption(mstrGrpCd, vntItemCd, vntItemSuffix, _
                                               vntItemName, , , , vntClassName, vntseq, vntrslCaption)
'##add end
    Else
        '�˗����ڂ̏ꍇ
        lngCount = objGrp.SelectGrp_R_ItemList(mstrGrpCd, vntItemCd, vntItemName, vntClassName)
                                               
    End If

    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�R�[�h", 1000, lvwColumnLeft
        .Add , , "����", 2000, lvwColumnLeft
        .Add , , "��������", 2000, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        
        '�L�[�l�ƕ\���R�[�h�̕ҏW
        If mintGrpDiv = MODE_RESULT Then
            '���ڃR�[�h�ɉ��������Ă��Ȃ��ꍇ
            Midashicounter = Midashicounter + 1
            If IsNull(vntItemCd(i)) Then
                strItemCdString = ""
                strItemKey = mstrListViewKey & Midashicounter
            Else
            '�������ڂ̏ꍇ
                strItemCdString = vntItemCd(i) & "-" & vntItemSuffix(i)
                strItemKey = mstrListViewKey & strItemCdString
            End If
        Else
            '�˗����ڂ̏ꍇ
            strItemCdString = vntItemCd(i)
            strItemKey = mstrListViewKey & vntItemCd(i)
        End If
        
        Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
'##2003.09.11 add T-ISHI@FSIT�@���X�g�r���[�Ɍ��o���R�����g�}��
            If IsNull(vntItemCd(i)) Then
                objItem.SubItems(1) = vntrslCaption(i)
            Else
                objItem.SubItems(1) = vntItemName(i)
                objItem.SubItems(2) = vntClassName(i)
            End If
'##add end
    Next i
        
   
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    EditListItem = True
    
    Exit Function
    
ErrorHandle:
    
    MsgBox Err.Description, vbCritical

End Function



' @(e)
'
' �@�\�@�@ : �u���ڍ폜�vClick
'
' �@�\���� : �I�����ꂽ���ڂ����X�g����폜����
'
' ���l�@�@ :
'
Private Sub cmdDeleteItem_Click()

    Dim i As Integer
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ�폜
        If lsvItem.ListItems(i).Selected = True Then
            lsvItem.ListItems.Remove (lsvItem.ListItems(i).Key)
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
        End If
    
    Next i

End Sub


Private Sub cmdDownItem_Click()
    
    Call MoveListItem(1)

End Sub
'##2003.09.11 T-ISHI@FSIT �V�K���o���R�����g�{�^���쐬
' @(e)
'
' �@�\�@�@ : �u�V�K���o���R�����g�̒ǉ��vClick
'
' �@�\���� : ���o����ǉ�����
'
' ���l�@�@ :
'
Private Sub cmdInsert_Title_Click()


On Error GoTo ErrorHandle

    Dim objItemTitle    As frmMidashi     '���o���\���p
    Dim objItem         As ListItem       '���X�g�A�C�e���I�u�W�F�N�g
    

    Dim i               As Long           '�C���f�b�N�X
    Dim strKey          As String         '�d���`�F�b�N�p�̃L�[
    Dim strItemString   As String
    Dim strItemKey      As String         '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCdString As String         '�\���p�L�[�ҏW�̈�

    Dim vntrslCaption   As Variant        '�L�����ꂽ���o���R�����g
    
    Dim intSelectedIndex    As Integer     '�I���������ڂ̃C���f�b�N�X
    Dim intTargetIndex      As Integer     '�^�[�Q�b�g�̃C���f�b�N�X
    Dim intSelectedCount    As Integer     '�I�����ڐ�
    
    Dim vntEscKey()         As Variant     '�d���`�F�b�N�p�̃L�[
    Dim vntEscCd()          As Variant     '���ڃR�[�h
    Dim vntEscName()        As Variant     '���ږ���
    Dim vntEscClassName()   As Variant     '�������ޖ�
    Dim vntEscrslCaption()  As Variant     '���o������
    
    '�I�����ڐ��̏����ݒ�
    intSelectedCount = 0
   
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemTitle = New frmMidashi
        
    '���o�����̋L����ʂ��J��
    objItemTitle.Show vbModal
    
    
    '�߂�l�Ƃ��Ẵv���p�e�B�擾
    vntrslCaption = objItemTitle.rslCaption

    '�߂�l��NULL�̏ꍇ
    If vntrslCaption = "" Then
        Screen.MousePointer = vbDefault
        Exit Sub
    End If
    
    '�L�[�l�ƕ\���R�[�h�̕ҏW
    Midashicounter = Midashicounter + 1
    strItemCdString = ""
    strItemKey = mstrListViewKey & Midashicounter
    
    '���X�g��ɑ��݂��邩�`�F�b�N����
    If CheckExistsItemCd(lsvItem, strItemKey) = False Then

        '�Ȃ���Βǉ�����
        Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
        
        '�I�����ڔz��쐬
        For i = 1 To lsvItem.ListItems.Count

            '�I������Ă��鍀�ڂȂ�
            If lsvItem.ListItems(i).Selected = True Then
                intSelectedCount = intSelectedCount + 1
                intSelectedIndex = i
            End If
            
        Next i
        
        '�}���ʒu���w�肳��Ă��Ȃ�������
        If intSelectedCount <> 1 Then
            objItem.SubItems(1) = vntrslCaption
        Else
            intTargetIndex = intSelectedIndex
        End If
        
        '�S���ڔz��쐬
        For i = 1 To lsvItem.ListItems.Count
            ReDim Preserve vntEscKey(i)
            ReDim Preserve vntEscCd(i)
            ReDim Preserve vntEscName(i)
            ReDim Preserve vntEscClassName(i)
        
            '�����Ώ۔z��ԍ�������
            If intTargetIndex >= i Then
            
                If intTargetIndex = i Then
                
                    vntEscKey(i) = strItemKey
                    vntEscCd(i) = ""
                    vntEscName(i) = vntrslCaption
                    vntEscClassName(i) = ""

                    i = i + 1
                
                    ReDim Preserve vntEscKey(i)
                    ReDim Preserve vntEscCd(i)
                    ReDim Preserve vntEscName(i)
                    ReDim Preserve vntEscClassName(i)
                
                    vntEscKey(i) = lsvItem.ListItems(intTargetIndex).Key
                    vntEscCd(i) = lsvItem.ListItems(intTargetIndex)
                    vntEscName(i) = lsvItem.ListItems(intTargetIndex).SubItems(1)
                    vntEscClassName(i) = lsvItem.ListItems(intTargetIndex).SubItems(2)
                    
                Else
                
                    vntEscKey(i) = lsvItem.ListItems(i).Key
                    vntEscCd(i) = lsvItem.ListItems(i)
                    vntEscName(i) = lsvItem.ListItems(i).SubItems(1)
                    vntEscClassName(i) = lsvItem.ListItems(i).SubItems(2)
                
                End If
                
            Else
                
                ReDim Preserve vntEscKey(i)
                ReDim Preserve vntEscCd(i)
                ReDim Preserve vntEscName(i)
                ReDim Preserve vntEscClassName(i)

                vntEscKey(i) = lsvItem.ListItems(i - 1).Key
                vntEscCd(i) = lsvItem.ListItems(i - 1)
                vntEscName(i) = lsvItem.ListItems(i - 1).SubItems(1)
                vntEscClassName(i) = lsvItem.ListItems(i - 1).SubItems(2)
            End If
    
        Next i
    
        lsvItem.ListItems.Clear
        
        '�w�b�_�̕ҏW
        With lsvItem.ColumnHeaders
            .Clear
            .Add , , "�R�[�h", 1000, lvwColumnLeft
            .Add , , "����", 2000, lvwColumnLeft
            .Add , , "��������", 1200, lvwColumnLeft
        End With
        
        '���X�g�̕ҏW
        For i = 1 To UBound(vntEscKey)
            Set objItem = lsvItem.ListItems.Add(, vntEscKey(i), vntEscCd(i))
            If IsNull(vntEscCd(i)) Then
                objItem.SubItems(1) = vntEscName(i)
            Else
                objItem.SubItems(1) = vntEscName(i)
                objItem.SubItems(2) = vntEscClassName(i)
            End If
        Next i
        
    End If

ErrorHandle:

    '��s�ڂ̃t�H�[�J�X���͂���
    lsvItem.ListItems(1).Selected = False
    
    If intSelectedCount <> 1 Then
        lsvItem.ListItems(lsvItem.ListItems.Count).Selected = True
    Else
        lsvItem.ListItems(intTargetIndex).Selected = True
    End If
    
    '�I������Ă��鍀�ڂ�\������
    lsvItem.SelectedItem.EnsureVisible

    lsvItem.SetFocus

    Set objItemTitle = Nothing
    Screen.MousePointer = vbDefault

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
Private Sub cmdOk_Click()
    
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
        
        '�O���[�v�e�[�u���̓o�^
        If RegistGrp() = False Then Exit Do
        
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

    Dim Ret             As Boolean  '�֐��߂�l
    
    '��������
    Ret = False
    
    Do
        
        If Trim(txtGrpCd.Text) = "" Then
            MsgBox "�O���[�v�R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            txtGrpCd.SetFocus
            Exit Do
        End If

        If Trim(txtGrpName.Text) = "" Then
            MsgBox "�O���[�v�������͂���Ă��܂���B", vbExclamation, App.Title
            txtGrpName.SetFocus
            Exit Do
        End If

        If Trim(txtPrice1.Text) = "" Then
            txtPrice1.Text = 0
        End If

        If Trim(txtPrice2.Text) = "" Then
            txtPrice2.Text = 0
        End If

        If (Trim(txtPrice1.Text) <> "") And (IsNumeric(Trim(txtPrice1.Text)) = False) Then
            MsgBox "��{�����ɂ͐��l����͂��Ă�������", vbExclamation, App.Title
            txtPrice1.SetFocus
            Exit Do
        End If

        If (Trim(txtPrice2.Text) <> "") And (IsNumeric(Trim(txtPrice2.Text)) = False) Then
            MsgBox "��{�����ɂ͐��l����͂��Ă�������", vbExclamation, App.Title
            txtPrice2.SetFocus
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
' �@�\�@�@ : �O���[�v��{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e���O���[�v�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistGrp() As Boolean

On Error GoTo ErrorHandle

    Dim objGrp          As Object     '�O���[�v�A�N�Z�X�p
    Dim strSearchChar   As String
    Dim lngRet          As Long
    
    Dim i               As Integer
    Dim j               As Integer
    Dim k               As Integer
    Dim intItemCount    As Integer
    
    Dim vntItemCd()     As Variant
    Dim vntSuffix()     As Variant
    Dim vntseq()        As Variant
'##2003.09.11 add T-ISHI@FSIT ���o���̔z���ǉ�
    Dim vntrslCaption() As Variant
'##add end
    Dim strWorkKey      As String
    Dim strItemCd       As String
    Dim strSuffix       As String
    
    RegistGrp = False

    intItemCount = 0
    Erase vntItemCd
    Erase vntSuffix
    Erase vntseq
'##2003.09.11 add T-ISHI@FSIT ���o���̏����ݒ��ǉ�
    Erase vntrslCaption
'##add end
    j = 0
    k = 0

    '�K�C�h����������̍ĕҏW
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "���̑�" Then
        strSearchChar = "*"
    End If

    '�O���[�v���������ڂ̔z��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        ReDim Preserve vntItemCd(j)
        ReDim Preserve vntSuffix(j)
        ReDim Preserve vntseq(j)
'##2003.09.11 add T-ISHI@FSIT �z��Ɍ��o����ǉ�
        ReDim Preserve vntrslCaption(j)
'##end add
        '���X�g�r���[�p�̃L�[�v���t�B�b�N�X���폜
        strWorkKey = Mid(lsvItem.ListItems(i).Key, 2, Len(lsvItem.ListItems(i).Key))
        
        '�O���[�v�敪�������^�C�v�Ȃ�T�t�B�b�N�X�ƕ���
        If mintGrpDiv = MODE_RESULT Then
            Call SplitItemAndSuffix(strWorkKey, strItemCd, strSuffix)
            If strItemCd = "" And strSuffix = "" Then
                vntItemCd(j) = strItemCd
                vntSuffix(j) = strSuffix
                vntseq(j) = i
'##2003.09.11 add T-ISHI@FSIT ���o���̖߂�l��ǉ�
                vntrslCaption(j) = Mid(lsvItem.ListItems(i).SubItems(1), 1, Len(lsvItem.ListItems(i).SubItems(1)))
'##add end
            Else
                vntItemCd(j) = strItemCd
                vntSuffix(j) = strSuffix
                vntseq(j) = i
 '##2003.09.11 add T-ISHI@FSIT ���o���̖߂�l��ǉ�
                vntrslCaption(j) = ""
'##add end
            End If
        Else
            vntItemCd(j) = strWorkKey
        End If
        
        j = j + 1
        intItemCount = intItemCount + 1
    
    Next i

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGrp = CreateObject("HainsGrp.Grp")

    '�O���[�v�e�[�u�����R�[�h�̓o�^
'##2003.09.11 add T-ISHI@FSIT ���o����ǉ�
''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT �V�X�e������O���[�v�t���O�̒ǉ�
''    lngRet = objGrp.RegistGrp_All(IIf(txtGrpCd.Enabled, "INS", "UPD"), _
'                                Trim(txtGrpCd.Text), _
'                                mstrClassCd(cboItemClass.ListIndex), _
'                                Trim(txtGrpName.Text), _
'                                Trim(txtPrice1.Text), _
'                                Trim(txtPrice2.Text), _
'                                mintGrpDiv, _
'                                strSearchChar, _
'                                intItemCount, _
'                                vntItemCd, _
'                                vntSuffix, _
'                                vntSeq)
'    lngRet = objGrp.RegistGrp_All(IIf(txtGrpCd.Enabled, "INS", "UPD"), _
                                Trim(txtGrpCd.Text), _
                                mstrClassCd(cboItemClass.ListIndex), _
                                Trim(txtGrpName.Text), _
                                Trim(txtPrice1.Text), _
                                Trim(txtPrice2.Text), _
                                mintGrpDiv, _
                                strSearchChar, _
                                IIf(chkSystemGrp.Value = vbChecked, "1", ""), _
                                intItemCount, _
                                vntItemCd, _
                                vntSuffix, _
                                vntseq)
'## 2002.11.10 Mod End
    lngRet = objGrp.RegistGrp_All(IIf(txtGrpCd.Enabled, "INS", "UPD"), _
                                Trim(txtGrpCd.Text), _
                                mstrClassCd(cboItemClass.ListIndex), _
                                Trim(txtGrpName.Text), _
                                Trim(txtPrice1.Text), _
                                Trim(txtPrice2.Text), _
                                mintGrpDiv, _
                                strSearchChar, _
                                IIf(chkSystemGrp.Value = vbChecked, "1", ""), _
                                intItemCount, _
                                vntItemCd, _
                                vntSuffix, _
                                vntseq, _
                                vntrslCaption)
'##add end
    
    If lngRet = 0 Then
        MsgBox "���͂��ꂽ�O���[�v�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        Exit Function
    End If
    
    mstrGrpCd = Trim(txtGrpCd.Text)
    txtGrpCd.Enabled = (txtGrpCd.Text = "")
    
    Set objGrp = Nothing
    RegistGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objGrp = Nothing
    RegistGrp = False
    
End Function

Private Sub Command1_Click()

End Sub

Private Sub cmdUpItem_Click()

    Call MoveListItem(-1)

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
    Dim objButton   As CommandButton        '�R�}���h�{�^���I�u�W�F�N�g
    
    '�I�u�W�F�N�g�̃C���X�^���X�̍쐬
    Set objButton = cmdInsert_Title

    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitializeForm

    Do
        '�������ރR���{�̕ҏW
        If EditItemClass() = False Then
            Exit Do
        End If
        
        '�O���[�v���̕\���ҏW
        If EditGrp() = False Then
            Exit Do
        End If
    
        '�O���[�v���������ڂ̕ҏW
        If EditListItem() = False Then
            Exit Do
        End If
        
'### 2003/11/23 Added by Ishihara@FSIT ��\��
objButton.Visible = False
        
        If mintGrpDiv = MODE_REQUEST Then
'            lblGrpDiv.Caption = "�˗����ڂ��Ǘ����܂�"
    '##2003.09.11 add T-ISHI@FSIT �V�K���o���{�^���̔�E�\���̐ݒ�
'            objButton.Visible = False
    '##add end
'### 2003/11/23 Added by Ishihara@FSIT ��\��
            cmdUpItem.Visible = False
            cmdDownItem.Visible = False
'### 2003/11/23 Added End
        End If
        
        '�C�l�[�u���ݒ�
        txtGrpCd.Enabled = (txtGrpCd.Text = "")
'        cboGrpDiv.Enabled = txtGrpCd.Enabled
        
        Ret = True
        Exit Do
    
    Loop
    
    '�Q�Ɛ�p�̏ꍇ�A�o�^�n�R���g���[�����~�߂�
    If mblnShowOnly = True Then
        LabelCourseGuide.Caption = txtGrpName.Text & "�̃v���p�e�B"
        
        txtGrpCd.Enabled = False
        txtGrpName.Enabled = False
        cboItemClass.Enabled = False
        txtPrice1.Enabled = False
        txtPrice2.Enabled = False
        cboSearchChar.Enabled = False
        
        cmdOk.Enabled = False
        cmdApply.Enabled = False
        cmdAddItem.Enabled = False
        cmdDeleteItem.Enabled = False
        cmdUpItem.Enabled = False
        cmdDownItem.Enabled = False
    End If
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
Friend Property Get GrpCd() As Variant

    GrpCd = mstrGrpCd
    
End Property

Friend Property Let GrpCd(ByVal vNewValue As Variant)
    
    mstrGrpCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property
Public Property Get GrpDiv() As Variant
    
    GrpDiv = mintGrpDiv

End Property

Public Property Let GrpDiv(ByVal vNewValue As Variant)

    mintGrpDiv = vNewValue

End Property

' @(e)
'
' �@�\�@�@ : ��f���ڈꗗ�J�����N���b�N
'
' �@�\���� : �N���b�N���ꂽ�J�������ڂ�Sort���s��
'
' ���l�@�@ :
'
Private Sub lsvItem_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    
    '�}�E�X�|�C���^�������v�̂Ƃ��͓��͖���
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�O���[�v�敪���������ڂ̏ꍇ�A�������Ȃ��i���Ԃ��߂��Ⴍ����ɂȂ邩��j
    If mintGrpDiv = MODE_RESULT Then Exit Sub
    
    With lsvItem
        .SortKey = ColumnHeader.Index - 1
        .Sorted = True
        .SortOrder = IIf(.SortOrder = lvwAscending, lvwDescending, lvwAscending)
    End With

End Sub



' @(e)
'
' �@�\�@�@ : �I�����ڂ̈ړ�
'
' �����@�@ : (In)   intMovePosition �ړ������i-1:���ցA1:������ցj
'
' �@�\���� : ���X�g�r���[��̍��ڂ��ړ�������
'
' ���l�@�@ :
'
Private Sub MoveListItem(intMovePosition As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim objItem             As ListItem
    
    Dim intSelectedCount    As Integer
    Dim intSelectedIndex    As Integer
    Dim intTargetIndex      As Integer
    Dim intScrollPoint      As Integer
    
    Dim strEscKey()         As String
    Dim strEscCd()          As String
    Dim strEscName()        As String
    Dim strEscClassName()   As String
    
    intSelectedCount = 0

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count

        '�I������Ă��鍀�ڂȂ�
        If lsvItem.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '�I�����ڐ����P�ȊO�Ȃ珈�����Ȃ�
    If intSelectedCount <> 1 Then Exit Sub
    
    '����Up�w�肩�A�I�����ڂ��擪�Ȃ牽�����Ȃ�
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '����Down�w�肩�A�I�����ڂ��ŏI�Ȃ牽�����Ȃ�
    If (intSelectedIndex = lsvItem.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '����Up�̏ꍇ�A��O�̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex - 1
    Else
        '����Down�̏ꍇ�A���݂̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex
    End If
    
    '���ݕ\����̐擪Index���擾
    intScrollPoint = lsvItem.GetFirstVisible.Index
    
    '���X�g�r���[�����邭��񂵂đS���ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        ReDim Preserve strEscKey(i)
        ReDim Preserve strEscCd(i)
        ReDim Preserve strEscName(i)
        ReDim Preserve strEscClassName(i)
        
        '�����Ώ۔z��ԍ�������
        If intTargetIndex = i Then
            
                strEscKey(i) = lsvItem.ListItems(i + 1).Key
                strEscCd(i) = lsvItem.ListItems(i + 1)
                strEscName(i) = lsvItem.ListItems(i + 1).SubItems(1)
                strEscClassName(i) = lsvItem.ListItems(i + 1).SubItems(2)
            i = i + 1
        
            ReDim Preserve strEscKey(i)
            ReDim Preserve strEscCd(i)
            ReDim Preserve strEscName(i)
            ReDim Preserve strEscClassName(i)
        
            strEscKey(i) = lsvItem.ListItems(intTargetIndex).Key
            strEscCd(i) = lsvItem.ListItems(intTargetIndex)
            strEscName(i) = lsvItem.ListItems(intTargetIndex).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(intTargetIndex).SubItems(2)
        
        Else
            strEscKey(i) = lsvItem.ListItems(i).Key
            strEscCd(i) = lsvItem.ListItems(i)
            strEscName(i) = lsvItem.ListItems(i).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(i).SubItems(2)
        
        End If
    
    Next i
    
    lsvItem.ListItems.Clear
    
    '�w�b�_�̕ҏW
    With lsvItem.ColumnHeaders
        .Clear
        .Add , , "�R�[�h", 1000, lvwColumnLeft
        .Add , , "����", 2000, lvwColumnLeft
        .Add , , "��������", 1200, lvwColumnLeft
    End With
    
    '���X�g�̕ҏW
    For i = 1 To UBound(strEscKey)
        Set objItem = lsvItem.ListItems.Add(, strEscKey(i), strEscCd(i))
        objItem.SubItems(1) = strEscName(i)
        objItem.SubItems(2) = strEscClassName(i)
    Next i

    lsvItem.ListItems(1).Selected = False
    
    '�ړ��������ڂ�I�������A�ړ��i�X�N���[���j������
    If intMovePosition = 1 Then
        lsvItem.ListItems(intTargetIndex + 1).Selected = True
    Else
        lsvItem.ListItems(intTargetIndex).Selected = True
    End If

    '�I������Ă��鍀�ڂ�\������
    lsvItem.SelectedItem.EnsureVisible

    lsvItem.SetFocus

End Sub
'##2003.09.11  T-ISHI@FSIT ���o���R�����g�C��
Private Sub lsvItem_DblClick()

On Error GoTo ErrorHandle


    Dim objItemTitle    As frmMidashi     '���o���\���p
    Dim objItem         As ListItem       '���X�g�A�C�e���I�u�W�F�N�g
    Dim i               As Long           '�C���f�b�N�X
    Dim vntrslCaption   As Variant        '�L�����ꂽ���o���R�����g
    Dim strKey          As String         '�d���`�F�b�N�p�̃L�[
    Dim strItemString   As String
    Dim strItemKey      As String         '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCdString As String         '�\���p�L�[�ҏW�̈�
        
        
    Set objItemTitle = frmMidashi

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Sub

    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�z����m�F
    For i = 1 To lsvItem.ListItems.Count
            '�I���������ڂ�������
            If lsvItem.ListItems(i).Selected = True Then
                If lsvItem.ListItems(i).SubItems(2) = "" Then
                    objItemTitle.rslCaption = lsvItem.ListItems(i).SubItems(1)
                
                    '���o���L����ʕ\��
                    objItemTitle.Show vbModal
                    
                    '�߂�l�Ƃ��Ẵv���p�e�B�擾
                    vntrslCaption = objItemTitle.rslCaption
                    
                    '�߂�l��NULL�̏ꍇ
                    If vntrslCaption = "" Then
                        Screen.MousePointer = vbDefault
                        Exit Sub
                    End If
                    
                    lsvItem.ListItems(i).SubItems(1) = vntrslCaption
                Else
'                    MsgBox "�I���������ڂ͕ύX�o���܂���B", vbExclamation
                    Screen.MousePointer = vbDefault
                    Exit Sub
                End If
            End If
    Next i
    
ErrorHandle:

    Set objItemTitle = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If

End Sub


