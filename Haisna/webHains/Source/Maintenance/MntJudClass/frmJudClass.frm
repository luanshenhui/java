VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmJudClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���蕪�ރe�[�u�������e�i���X"
   ClientHeight    =   6945
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6555
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmJudClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6945
   ScaleWidth      =   6555
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboResultDispMode 
      Height          =   300
      Left            =   1980
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   7
      ToolTipText     =   "�ʐڎx����ʂɂāA���薼�̂��N���b�N�����ꍇ�̌������ʉ�ʂ��w�肵�܂�"
      Top             =   1200
      Width           =   3855
   End
   Begin VB.CheckBox chkNotNormalFlg 
      Caption         =   "���̔��蕪�ނ͎������菈�����ɓ���v�Z���s��(&S)"
      Height          =   255
      Left            =   540
      TabIndex        =   15
      Top             =   5580
      Width           =   4335
   End
   Begin VB.CheckBox chkNotAutoFlg 
      Caption         =   "���̔��蕪�ނ͎������菈���̑ΏۂƂ��Ȃ�(&O)"
      Height          =   255
      Left            =   240
      TabIndex        =   14
      Top             =   5280
      Width           =   4335
   End
   Begin VB.CheckBox chkCommentOnly 
      Caption         =   "���̔��蕪�ނ̓R�����g���Ǘ����邽�߂̃_�~�[����(&D)"
      Height          =   255
      Left            =   240
      TabIndex        =   13
      Top             =   4980
      Width           =   4335
   End
   Begin VB.TextBox txtIsrOrganDiv 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   8220
      MaxLength       =   8
      TabIndex        =   20
      Text            =   "@@,@@,@@"
      Top             =   4500
      Width           =   1035
   End
   Begin VB.TextBox txtViewOrder 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1980
      MaxLength       =   3
      TabIndex        =   5
      Text            =   "@@"
      ToolTipText     =   "�ʐڎx����ʂɂāA�\�����鏇�Ԃ��w�肵�܂�"
      Top             =   840
      Width           =   495
   End
   Begin VB.Frame Frame2 
      Caption         =   "���̔��蕪�ނɊ܂܂�錟������(&I)"
      Height          =   3135
      Left            =   180
      TabIndex        =   8
      Top             =   1680
      Width           =   6255
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "�ǉ�(&A)..."
         Height          =   315
         Left            =   3360
         TabIndex        =   11
         Top             =   2700
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "�폜(&R)"
         Height          =   315
         Left            =   4740
         TabIndex        =   12
         Top             =   2700
         Width           =   1275
      End
      Begin VB.CommandButton cmdItemProperty 
         Caption         =   "�v���p�e�B(&P)"
         Height          =   315
         Left            =   1980
         TabIndex        =   10
         Top             =   2700
         Visible         =   0   'False
         Width           =   1275
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   2295
         Left            =   120
         TabIndex        =   9
         Top             =   300
         Width           =   5955
         _ExtentX        =   10504
         _ExtentY        =   4048
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
   Begin VB.CheckBox chkAllJudFlg 
      Caption         =   "���v���ɑ�������̑ΏۂƂ��ăJ�E���g����(&T)"
      Height          =   255
      Left            =   240
      TabIndex        =   18
      Top             =   5880
      Width           =   4035
   End
   Begin VB.TextBox txtJudClassName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1980
      MaxLength       =   25
      TabIndex        =   3
      Text            =   "��������"
      Top             =   480
      Width           =   3735
   End
   Begin VB.TextBox txtJudClassCd 
      Height          =   300
      Left            =   1980
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3600
      TabIndex        =   16
      Top             =   6420
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5040
      TabIndex        =   17
      Top             =   6420
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�ʐڎx������̃����N(&L):"
      Height          =   180
      Index           =   4
      Left            =   180
      TabIndex        =   6
      ToolTipText     =   "�ʐڎx����ʂɂāA���薼�̂��N���b�N�����ꍇ�̌������ʉ�ʂ��w�肵�܂�"
      Top             =   1260
      Width           =   1830
   End
   Begin VB.Label Label1 
      Caption         =   "�튯�敪�R�[�h(&K):"
      Height          =   180
      Index           =   3
      Left            =   6660
      TabIndex        =   19
      Top             =   4560
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "���蕪�ޕ\����(&J):"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   4
      ToolTipText     =   "�ʐڎx����ʂɂāA�\�����鏇�Ԃ��w�肵�܂�"
      Top             =   900
      Width           =   1590
   End
   Begin VB.Label Label1 
      Caption         =   "���蕪�ޖ�(&N):"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "���蕪�ރR�[�h(&C):"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmJudClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrJudClassCd  As String   '���蕪�ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mblnEditItem    As Boolean  '�Ǌ��������ڂ̍X�V�Ǘ��ATRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Const mstrListViewKey   As String = "K"

Friend Property Let JudClassCd(ByVal vntNewValue As Variant)

    mstrJudClassCd = vntNewValue
    
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
        
        '�R�[�h�̓��̓`�F�b�N
        If Trim(txtJudClassCd.Text) = "" Then
            MsgBox "���蕪�ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtJudClassCd.SetFocus
            Exit Do
        End If

        '�R�[�h�̐��l�`�F�b�N
        If IsNumeric(txtJudClassCd.Text) = False Then
            MsgBox "���蕪�ރR�[�h�͐��l�œ��͂��Ă��������B", vbCritical, App.Title
            txtJudClassCd.SetFocus
            Exit Do
        End If

        '�R�[�h�̐��l�`�F�b�N�Q
        If CInt(txtJudClassCd.Text) < 1 Then
            MsgBox "���蕪�ރR�[�h�ɂ͕����A�[�����w�肷�邱�Ƃ͂ł��܂���B", vbCritical, App.Title
            txtJudClassCd.SetFocus
            Exit Do
        End If

        '--------------------------------------------------------------------------------------------
        '���蕪�ޕ\�����̓��̓`�F�b�N
        If Trim(txtViewOrder.Text) = "" Then txtViewOrder.Text = "999"

        '���蕪�ޕ\�����̐��l�`�F�b�N
        If IsNumeric(txtViewOrder.Text) = False Then
            MsgBox "���蕪�ޕ\�����͐��l�œ��͂��Ă��������B", vbCritical, App.Title
            txtViewOrder.SetFocus
            Exit Do
        End If

        '���蕪�ޕ\�����̐��l�`�F�b�N�Q
        If CInt(txtViewOrder.Text) < 1 Then
            MsgBox "���蕪�ޕ\�����ɂ͕����A�[�����w�肷�邱�Ƃ͂ł��܂���B", vbCritical, App.Title
            txtViewOrder.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtJudClassName.Text) = "" Then
            MsgBox "���蕪�ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtJudClassName.SetFocus
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
Private Function EditJudClass() As Boolean

    Dim objJudClass     As Object           '���蕪�ރA�N�Z�X�p
    Dim vntJudClassName As Variant          '���蕪�ޖ�
    Dim vntAlljudFlg    As Variant          '���v�p��������t���O
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT �A�t�^�[�P�A�R�[�h�̒ǉ�
    Dim vntAfterCareCd  As Variant          '�A�t�^�[�P�A�R�[�h
'## 2002.11.10 Add End
    Dim vntIsrOrganDiv  As Variant          '�튯�敪�R�[�h
    Dim Ret             As Boolean          '�߂�l
    
'## 2004.02.13 Mod By H.Ishihara@FSIT ���H����p���ڂ̒ǉ�
    Dim vntCommentOnly      As Variant      '�R�����g�\�����[�h
    Dim vntViewOrder        As Variant      '���蕪�ޕ\����
    Dim vntResultDispMode   As Variant      '�������ʕ\�����[�h�i���胊���N�p�j
    Dim vntNotAutoFlg       As Variant      '��������ΏۊO�t���O
    Dim vntNotNormalFlg     As Variant      '�ʏ픻��ΏۊO�t���O
'## 2004.02.13 Mod End
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrJudClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '���蕪�ރe�[�u�����R�[�h�ǂݍ���
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT �A�t�^�[�P�A�R�[�h�̒ǉ�
'        If objJudClass.SelectJudClass(mstrJudClassCd, vntJudClassName, vntAlljudFlg) = False Then
'## 2004.02.13 Mod By H.Ishihara@FSIT ���H����p���ڂ̒ǉ�
'        If objJudClass.SelectJudClass(mstrJudClassCd, vntJudClassName, vntAlljudFlg, vntAfterCareCd, vntIsrOrganDiv) = False Then
        If objJudClass.SelectJudClass(mstrJudClassCd, vntJudClassName, vntAlljudFlg, vntAfterCareCd, vntIsrOrganDiv, vntCommentOnly, vntViewOrder, vntResultDispMode, vntNotAutoFlg, vntNotNormalFlg) = False Then
'## 2004.02.13 Mod End
'## 2002.11.10 Mod End
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtJudClassCd.Text = mstrJudClassCd
        txtJudClassName.Text = vntJudClassName
        If vntAlljudFlg = "1" Then
            chkAllJudFlg.Value = vbChecked
        End If
        txtIsrOrganDiv.Text = vntIsrOrganDiv
        
'## 2004.02.13 Add By H.Ishihara@FSIT ���H����p���ڂ̒ǉ�
        txtViewOrder.Text = vntViewOrder
        If vntCommentOnly = "1" Then chkCommentOnly.Value = vbChecked
        If vntNotAutoFlg = "1" Then chkNotAutoFlg.Value = vbChecked
        If vntNotNormalFlg = "1" Then chkNotNormalFlg.Value = vbChecked
        If IsNumeric(vntResultDispMode) Then
            If CInt(vntResultDispMode) <= cboResultDispMode.ListCount Then
                cboResultDispMode.ListIndex = CInt(vntResultDispMode)
            End If
        End If
'## 2004.02.13 Add End
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditJudClass = Ret
    
    Exit Function

ErrorHandle:

    EditJudClass = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : ���蕪�ފǊ��̌������ڕ\��
'
' �@�\���� : ���ݐݒ肳��Ă��锻�蕪�ޓ��������ڂ�\������
'
' ���l�@�@ :
'
Private Function EditListItem() As Boolean
    
On Error GoTo ErrorHandle

    Dim objJudClass     As Object               '���蕪�ލ��ڃA�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntItemCd       As Variant              '�R�[�h
    Dim vntItemName     As Variant              '����
    Dim vntClassName    As Variant              '�������ޖ���
    
    Dim vntSuffix       As Variant              '���ڋ敪
    Dim lngCount        As Long                 '���R�[�h��
    
    Dim i               As Long                 '�C���f�b�N�X

    EditListItem = False

    '���X�g�A�C�e���N���A
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    
    '���蕪�ފǊ��������ڌ����i�J�n�A�I�����͗���ԍ����w�肵�Ă��邽�߁A�s�v�j
    lngCount = objJudClass.SelectJudClassItemList(mstrJudClassCd, _
                                                  vntItemCd, _
                                                  , _
                                                  vntItemName, _
                                                  vntClassName)
    
    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�R�[�h", 1000, lvwColumnLeft
        .Add , , "����", 2800, lvwColumnLeft
        .Add , , "��������", 1200, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, mstrListViewKey & vntItemCd(i), vntItemCd(i))
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntClassName(i)
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


'
' �@�\�@�@ : �f�[�^�o�^
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function RegistJudClass() As Boolean

On Error GoTo ErrorHandle

    Dim objJudClass     As Object       '���蕪�ރA�N�Z�X�p
    Dim Ret             As Long
    Dim i               As Integer
    Dim j               As Integer
    Dim intItemCount    As Integer
    Dim vntItemCd()     As Variant
    
    RegistJudClass = False

    intItemCount = 0
    Erase vntItemCd
    j = 0

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        ReDim Preserve vntItemCd(j)
        vntItemCd(j) = lsvItem.ListItems.Item(i).Text
        
        j = j + 1
        intItemCount = intItemCount + 1
    
    Next i

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    
    '���蕪�ރe�[�u�����R�[�h�̓o�^
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT �A�t�^�[�P�A�R�[�h�̒ǉ�
'    Ret = objJudClass.RegistJudClass_All(IIf(txtJudClassCd.Enabled, "INS", "UPD"), _
                                         Trim(txtJudClassCd.Text), _
                                         Trim(txtJudClassName.Text), _
                                         IIf(chkAllJudFlg.Value = vbChecked, 1, 0), _
                                         intItemCount, _
                                         vntItemCd)
    Ret = objJudClass.RegistJudClass_All(IIf(txtJudClassCd.Enabled, "INS", "UPD"), _
                                         Trim(txtJudClassCd.Text), _
                                         Trim(txtJudClassName.Text), _
                                         IIf(chkAllJudFlg.Value = vbChecked, 1, 0), _
                                         Trim(txtViewOrder.Text), _
                                         intItemCount, _
                                         vntItemCd, _
                                         Trim(txtIsrOrganDiv.Text), _
                                         IIf(chkCommentOnly.Value = vbChecked, 1, ""), _
                                         CInt(Trim(txtViewOrder.Text)), _
                                         IIf(cboResultDispMode.ListIndex = 0, "", cboResultDispMode.ListIndex), _
                                         IIf(chkNotAutoFlg.Value = vbChecked, 1, ""), _
                                         IIf(chkNotNormalFlg.Value = vbChecked, 1, ""))
'## 2002.11.10 Mod End

    If Ret = 0 Then
        MsgBox "���͂��ꂽ���蕪�ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistJudClass = False
        Exit Function
    End If
    
    '�o�^�ςݔ��蕪�ރR�[�h�Ƃ��ăZ�b�g�i�V�K�{�������ړo�^�p�j
    mstrJudClassCd = Trim(txtJudClassCd.Text)
    RegistJudClass = True
    
    Exit Function
    
ErrorHandle:

    RegistJudClass = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub chkCommentOnly_Click()

    chkNotAutoFlg.Enabled = True
    
    If chkCommentOnly.Value = vbChecked Then
        chkNotAutoFlg.Value = vbChecked
        chkNotAutoFlg.Enabled = False
    End If

End Sub

Private Sub chkNotAutoFlg_Click()

    chkNotNormalFlg.Enabled = True
    
    If chkNotAutoFlg.Value = vbChecked Then
        chkNotNormalFlg.Value = vbUnchecked
        chkNotNormalFlg.Enabled = False
    End If
    
End Sub

Private Sub cmdAddItem_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    Dim objItem         As ListItem                 '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim lngCount        As Long     '���R�[�h��
    Dim i               As Long     '�C���f�b�N�X
    Dim strKey          As String   '�d���`�F�b�N�p�̃L�[
    
    Dim lngItemCount    As Long     '�I�����ڐ�
    Dim vntItemCd       As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntItemName     As Variant  '�I�����ꂽ���ږ�
    Dim vntClassName    As Variant  '�I�����ꂽ�������ޖ�
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_REQUEST
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
        
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntItemName = .ItemName
        vntClassName = .ClassName
    
    End With
            
    Screen.MousePointer = vbHourglass
    Me.Refresh
            
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then
    
        '���X�g�̕ҏW
        For i = 0 To lngItemCount - 1
            
            '���X�g��ɑ��݂��邩�`�F�b�N����
            strKey = mstrListViewKey & vntItemCd(i)
            If CheckExistsItemCd(lsvItem, strKey) = False Then
            
                '�Ȃ���Βǉ�����
                Set objItem = lsvItem.ListItems.Add(, strKey, vntItemCd(i))
                objItem.SubItems(1) = vntItemName(i)
                objItem.SubItems(2) = vntClassName(i)
            
                '�X�V��Ԃ��Ǘ�
                mblnEditItem = True
            
            End If
        Next i
    
    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

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
            '�X�V��Ԃ��Ǘ�
            mblnEditItem = True
        End If
    
    Next i

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
        If CheckValue() = False Then Exit Do
        
        '���蕪�ރe�[�u���̓o�^
        If RegistJudClass() = False Then Exit Do
            
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
    mblnEditItem = False

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    With cboResultDispMode
        .Clear
        .AddItem ""
        .AddItem "�f�@�A�̊i�A�����E�S����"
        .AddItem "�S�d�}"
        .AddItem "����X��"
        .AddItem "�㕔�����ǁE�֐����@�������ʕ\��"
        .AddItem "�㕠�������g"
        .AddItem "���t"
        .AddItem "����ӁE�������"
        .AddItem "�A�_�E�̋@�\�E�t�@�\"
        .AddItem "�d�����E�����E�A�����E�O���B"
        .AddItem "���́E���E���́E�����x"
        .AddItem "���[�E�w�l��"
        .AddItem "�咰������"
        .AddItem "����CT"
'#### 2011.07.07 SL-SN-Y0101-305 ADD START ####
        .AddItem ""
        .AddItem "�咰�R�c�|�b�s"
        .AddItem "�򓮖������g"
        .AddItem "�����d��"
        .AddItem "�������b�ʐ�"
        .AddItem "�S�s�S�X�N���[�j���O"
'#### 2011.07.07 SL-SN-Y0101-305 ADD END ####
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        .AddItem "�w�l�Ȓ����g"
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    End With

    Do
        '���蕪�ޏ��̕ҏW
        If EditJudClass() = False Then
            Exit Do
        End If
    
        '���蕪�ފǊ��̌������ڕҏW
        If EditListItem() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtJudClassCd.Enabled = (txtJudClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
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


