VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmItemGuide 
   Caption         =   "���ڃK�C�h"
   ClientHeight    =   6555
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5115
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItemGuide.frx":0000
   LinkTopic       =   "Form1"
   MinButton       =   0   'False
   ScaleHeight     =   6555
   ScaleWidth      =   5115
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboResultType 
      Height          =   300
      ItemData        =   "frmItemGuide.frx":0442
      Left            =   1620
      List            =   "frmItemGuide.frx":0464
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   10
      Top             =   1440
      Width           =   3450
   End
   Begin VB.OptionButton optDiv 
      Caption         =   "��������(&I)"
      Height          =   255
      Index           =   1
      Left            =   3120
      TabIndex        =   8
      Top             =   780
      Width           =   1515
   End
   Begin VB.OptionButton optDiv 
      Caption         =   "�O���[�v(&G)"
      Height          =   255
      Index           =   0
      Left            =   1620
      TabIndex        =   7
      Top             =   780
      Width           =   1515
   End
   Begin VB.ComboBox cboItemClass 
      Height          =   300
      ItemData        =   "frmItemGuide.frx":0486
      Left            =   1620
      List            =   "frmItemGuide.frx":04A8
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   3
      Top             =   1080
      Width           =   3450
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2280
      TabIndex        =   0
      Top             =   6180
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   3720
      TabIndex        =   1
      Top             =   6180
      Width           =   1335
   End
   Begin MSComctlLib.ListView lsvItem 
      Height          =   4215
      Left            =   120
      TabIndex        =   2
      Top             =   1860
      Width           =   4935
      _ExtentX        =   8705
      _ExtentY        =   7435
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Label Label8 
      Caption         =   "���ʃ^�C�v(&T):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   9
      Top             =   1500
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "�\������(&P):"
      Height          =   195
      Index           =   2
      Left            =   180
      TabIndex        =   6
      Top             =   780
      Width           =   1335
   End
   Begin VB.Label LabelTitle 
      Caption         =   "���ڂ�I�����Ă�������"
      Height          =   375
      Left            =   780
      TabIndex        =   5
      Top             =   240
      Width           =   4275
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   0
      Picture         =   "frmItemGuide.frx":04CA
      Top             =   60
      Width           =   720
   End
   Begin VB.Label Label8 
      Caption         =   "�������ڕ���(&C):"
      Height          =   195
      Index           =   1
      Left            =   180
      TabIndex        =   4
      Top             =   1140
      Width           =   1455
   End
End
Attribute VB_Name = "frmItemGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p��`�̈�
Private mblnRet         As Boolean  '�߂�l

Private mintMode        As Integer  '�˗����ʃ��[�h�i1:�˗����[�h�A2:���ʃ��[�h�j
Private mintGroup       As Integer  '�O���[�v���ڕ\���L��
Private mintItem        As Integer  '�������ڕ\���L��
'Private mintResultType  As Integer  '���ʃ^�C�v
Private mvntResultType  As Variant  '���ʃ^�C�v�i�z��j
Private mintQuestion    As Integer  '��f���ڕ\���L��
Private mblnNowEdit     As Boolean  'TRUE:�ҏW���AFALSE:�\���p�ҏW�\
Private mblnMultiSelect As Boolean  '���X�g�r���[�̕����I��
Private mstrClassCd     As String   '�������ރR�[�h

Private mstrArrResultType() As String  '���ʃ^�C�v�R���{�Ή��L�[�i�[�̈�

Private mintItemCount   As Integer  '�I�����ꂽ���ڐ�
Private mstrItemDiv     As String   '�I�����ꂽ���[�h�iG:�O���[�v,I:�������ځj
Private mvntItemCd()    As Variant  '�I�����ꂽ���ڃR�[�h
Private mvntSuffix()    As Variant  '�I�����ꂽ���ڃR�[�h
Private mvntItemName()  As Variant  '�I�����ꂽ���ږ�
Private mvntClassName() As Variant  '�I�����ꂽ���ڂ̕��ޖ���

'���W���[�����x���ϐ�
Private mstrArrClassCd()   As String   '�������ރR�[�h

'�Œ�R�[�h�Ǘ�
Const mstrGrpName       As String = "�O���[�v"
Const mstrItemName      As String = "��������"
Const mstrListViewKey   As String = "K"

Const GRPDIV_ITEM       As String = "I"
Const GRPDIV_GRP        As String = "G"

Public Property Get Ret() As Variant

    Ret = mblnRet

End Property

' @(e)
'
' �@�\�@�@ : ���ڃ��X�g�ҏW
'
' �@�\���� : �R���{�{�b�N�X�Ŏw�肳�ꂽ���e�̍��ڈꗗ��\������B
'
' ���l�@�@ :
'
Private Sub EditItemList()

On Error GoTo ErrorHandle

    Dim objItem         As Object           '�������ڃA�N�Z�X�p
    Dim objGrp          As Object           '�O���[�v�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objListItem     As ListItem         '���X�g�A�C�e���I�u�W�F�N�g

    Dim Ret             As Boolean          '�߂�l
    Dim dtmStrDate      As Date
    Dim dtmEndDate      As Date

    Dim vntCd           As Variant          '�������ڃR�[�h
    Dim vntSuffix       As Variant          '�T�t�B�b�N�X
    Dim vntName         As Variant          '����
    Dim vntClassCd      As Variant          '�������ރR�[�h
    Dim vntClassName    As Variant          '�������ޖ�
    Dim strItemCd       As String
    
    Dim lngCount    As Long                 '���R�[�h��
    Dim i           As Long                 '�C���f�b�N�X

    Screen.MousePointer = vbHourglass
    
    mblnNowEdit = True
    
    '���X�g�A�C�e���N���A
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    vntClassCd = mstrArrClassCd(cboItemClass.ListIndex)
    
    '�\�����ڂ��O���[�v�̏ꍇ
    If optDiv(0).Value = True Then
        Set objGrp = CreateObject("HainsGrp.Grp")
        lngCount = objGrp.SelectGrp_IList_GrpDiv(mintMode, vntCd, vntName, vntClassCd, , , vntClassName, True)
                                                 
    End If
    
    '�\�����ڂ��������ځi�˗����ځj�̏ꍇ
    If optDiv(1).Value = True And _
       (mintMode = MODE_REQUEST) Then
        Set objItem = CreateObject("HainsItem.Item")
        lngCount = objItem.SelectItem_pList(vntClassCd, "", mintQuestion, vntCd, vntSuffix, vntName, , vntClassName)
                                           
    End If
    
    '�\�����ڂ��������ځi�������ځj�̏ꍇ
    If optDiv(1).Value = True And _
       (mintMode = MODE_RESULT) Then
        
        Set objItem = CreateObject("HainsItem.Item")
        
        '���ʃ^�C�v���w�肳��Ă���ꍇ�ƌďo�����킯��
'        If mintResultType <> -1 Then
        If Trim(mstrArrResultType(cboResultType.ListIndex)) <> "" Then
            lngCount = objItem.SelectItem_cList(vntClassCd, "", mintQuestion, vntCd, vntSuffix, vntName, vntClassName, mstrArrResultType(cboResultType.ListIndex))
        Else
            lngCount = objItem.SelectItem_cList(vntClassCd, "", mintQuestion, vntCd, vntSuffix, vntName, vntClassName)
        End If
                                           
    End If
    
    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "����", 1800, lvwColumnLeft
    objHeader.Add , , "��������", 1500, lvwColumnLeft
    lsvItem.View = lvwReport
    
    '���ڃ��X�g�̕ҏW
    For i = 0 To lngCount - 1
                
        '�������ځi���ʁj�̏ꍇ�́A�T�t�B�b�N�X��ҏW���ĕ\��
        If optDiv(1).Value = True And _
           (mintMode = MODE_RESULT) Then
            strItemCd = vntCd(i) & "-" & vntSuffix(i)
        Else
            strItemCd = vntCd(i)
        End If
                
        Set objListItem = lsvItem.ListItems.Add(, mstrListViewKey & strItemCd, strItemCd)
        objListItem.SubItems(1) = vntName(i)
        objListItem.SubItems(2) = vntClassName(i)
    
    Next i
    
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    Set objItem = Nothing
    Set objGrp = Nothing
    Screen.MousePointer = vbDefault
    mblnNowEdit = False
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem = Nothing
    Set objGrp = Nothing
    Screen.MousePointer = vbDefault
    mblnNowEdit = False
    
End Sub
' @(e)
'
' �@�\�@�@ : �u�������ރR���{�vClick
'
' �@�\���� : �������ރR���{���e��ύX���ꂽ���ɁA�������ڕ\�����e��ύX����B
'
' ���l�@�@ :
'
Private Sub cboItemClass_Click()

    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '���ڃ��X�g�ҏW
    Call EditItemList

End Sub


Private Sub cboResultType_Click()

    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '���ڃ��X�g�ҏW
    Call EditItemList

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

    mintItemCount = 0
    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�n�j�v�N���b�N
'
' �@�\���� : ���͓��e��K�p���A��ʂ����
'
' ���l�@�@ :
'
Private Sub CMDok_Click()

    Dim x           As Object
    Dim i           As Integer
    Dim j           As Integer
    Dim strWorkKey  As String
    Dim lngPointer  As Long

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�ϐ�������
    mintItemCount = 0
    j = 0
    Erase mvntItemCd
    Erase mvntItemName
    
    '���ݕ\�����̍��ڕ��ށi�O���[�vor�P���ځj
    If optDiv(0).Value = True Then
        mstrItemDiv = GRPDIV_GRP
    Else
        mstrItemDiv = GRPDIV_ITEM
    End If

    Do
    
        '�����I������Ă��Ȃ��Ȃ炨�I��
        If lsvItem.SelectedItem Is Nothing Then
            MsgBox "���ڂ������I������Ă��܂���B", vbExclamation
            Exit Do
        End If
        
        '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
        For i = 1 To lsvItem.ListItems.Count
            If lsvItem.ListItems(i).Selected = True Then
                
                '�J�E���g�A�b�v
                mintItemCount = mintItemCount + 1
                                
                '�z��g��
                ReDim Preserve mvntItemCd(j)
                ReDim Preserve mvntSuffix(j)
                ReDim Preserve mvntItemName(j)
                ReDim Preserve mvntClassName(j)
                
                '���X�g�r���[�p�̃L�[�v���t�B�b�N�X���폜
                strWorkKey = Mid(lsvItem.ListItems(i).Key, 2, Len(lsvItem.ListItems(i).Key))
                lngPointer = InStr(strWorkKey, "-")
                If lngPointer <> 0 Then
                    mvntItemCd(j) = Mid(strWorkKey, 1, lngPointer - 1)
                    mvntSuffix(j) = Mid(strWorkKey, lngPointer + 1, Len(strWorkKey))
                Else
                    mvntItemCd(j) = strWorkKey
                    mvntSuffix(j) = ""
                End If
                
                mvntItemName(j) = lsvItem.ListItems(i).SubItems(1)
                mvntClassName(j) = lsvItem.ListItems(i).SubItems(2)
                j = j + 1
            
            End If
        Next i
            
        '�����I������Ă��Ȃ��Ȃ炨�I��
        If mintItemCount = 0 Then
            MsgBox "���ڂ������I������Ă��܂���B", vbExclamation
            Exit Do
        End If
            
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
    mintItemCount = 0
    mblnNowEdit = True

    Do

        '�O���[�v�A�P���ڂǂ�������\���Ȃ炨���܂�
        If (mintGroup = GROUP_OFF) And (mintItem = ITEM_OFF) Then
            MsgBox "�O���[�v�A�P���ڂǂ������\���ɐݒ肳��Ă��܂��B�ݒ�v���p�e�B���������Ă��������B", vbCritical, "���ڃK�C�h"
            Exit Do
        End If
        
        '�I�u�V�����{�^���̏�����
        optDiv(0).Value = True
        
        '�O���[�v�\���s�Ȃ�A�O���[�v�I�v�V�����{�^���g�p�s��
        If mintGroup = GROUP_OFF Then
            optDiv(0).Enabled = False
            optDiv(1).Value = True
        End If
        
        '�P���ڕ\���s�Ȃ�A�I�v�V�����{�^���g�p�s��
        If mintItem = ITEM_OFF Then
            optDiv(1).Enabled = False
            optDiv(0).Value = True
        End If

        '�������ރR���{�Z�b�g
        If EditItemClassCombo() = False Then
            Exit Do
        End If
    
        '���ʃ^�C�v�R���{�̕ҏW
        Call EditResultType
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnRet = Ret
    
    '�������̉���
    mblnNowEdit = False
    
    '���ڃ��X�g�ҏW�i�����\���j
    Call EditItemList
    
    '���X�g�̃}���`�Z���N�g�Z�b�g
    lsvItem.MultiSelect = mblnMultiSelect
    
    Screen.MousePointer = vbDefault

End Sub

Private Sub EditResultType()

    Dim i   As Integer

    '���ʃ^�C�v�R���{������
    With cboResultType
        .Clear
    End With

    '�������ڔ�\�����́A���ʃ^�C�v�R���{�g�p�s��
    If mintItem = ITEM_OFF Then
        cboResultType.Enabled = False
        Exit Sub
    End If

    '�R���{�Ή��z�񏉊���
    Erase mstrArrResultType
    
    '���ʃ^�C�v�̈����l���`�F�b�N
    If IsArray(mvntResultType) Then
        
        '�z��w��̏ꍇ
        For i = 0 To UBound(mvntResultType)
            ReDim Preserve mstrArrResultType(i)
            mstrArrResultType(i) = mvntResultType(i)
        
            Select Case mvntResultType(i)
                Case RESULTTYPE_NUMERIC         '���l
                    cboResultType.AddItem "0:���l���i�[���܂�"
                Case RESULTTYPE_TEISEI1         '�萫�P
                    cboResultType.AddItem "1:�萫�i�W���F-,+-,+�j���i�[���܂�"
                Case RESULTTYPE_TEISEI2         '�萫�Q
                    cboResultType.AddItem "2:�萫�i�g���F-,+-,1+�`9+�j���i�[���܂�"
                Case RESULTTYPE_FREE            '�t���[
                    cboResultType.AddItem "3:���ʓ��e���Œ肵�܂���i�t���[�j"
                Case RESULTTYPE_SENTENCE        '����
                    cboResultType.AddItem "4:���͌��ʂ��i�[���܂�"
                Case RESULTTYPE_CALC            '�v�Z
                    cboResultType.AddItem "5:�v�Z���ڂł�"
                Case RESULTTYPE_DATE            '���t�^�C�v
                    cboResultType.AddItem "6:���t���i�[���܂�"
            End Select
        
        Next i
        cboResultType.ListIndex = 0
    
    Else
        '�P���w��̏ꍇ
        
        '�Ƃ肠�����P��Z�b�g
        With cboResultType
            .AddItem ""
            .AddItem "0:���l���i�[���܂�"
            .AddItem "1:�萫�i�W���F-,+-,+�j���i�[���܂�"
            .AddItem "2:�萫�i�g���F-,+-,1+�`9+�j���i�[���܂�"
            .AddItem "3:���ʓ��e���Œ肵�܂���i�t���[�j"
            .AddItem "4:���͌��ʂ��i�[���܂�"
            .AddItem "5:�v�Z���ڂł�"
            .AddItem "6:���t���i�[���܂�"
            .ListIndex = 0
        End With
        
        ReDim Preserve mstrArrResultType(7)
        mstrArrResultType(1) = RESULTTYPE_NUMERIC
        mstrArrResultType(2) = RESULTTYPE_TEISEI1
        mstrArrResultType(3) = RESULTTYPE_TEISEI2
        mstrArrResultType(4) = RESULTTYPE_FREE
        mstrArrResultType(5) = RESULTTYPE_SENTENCE
        mstrArrResultType(6) = RESULTTYPE_CALC
        mstrArrResultType(7) = RESULTTYPE_DATE
        
        '���l���A�L���Ȍ��ʃ^�C�v���w�肳��Ă���ꍇ���ꂾ���Z�b�g
        If IsNumeric(mvntResultType) Then
            If (CLng(mvntResultType) >= RESULTTYPE_NUMERIC) And (CLng(mvntResultType) <= RESULTTYPE_DATE) Then
                
                cboResultType.Clear
                Erase mstrArrResultType
                ReDim Preserve mstrArrResultType(0)
                Select Case mvntResultType
                    Case RESULTTYPE_NUMERIC         '���l
                        cboResultType.AddItem "0:���l���i�[���܂�"
                        mstrArrResultType(0) = RESULTTYPE_NUMERIC
                    Case RESULTTYPE_TEISEI1         '�萫�P
                        cboResultType.AddItem "1:�萫�i�W���F-,+-,+�j���i�[���܂�"
                        mstrArrResultType(0) = RESULTTYPE_TEISEI1
                    Case RESULTTYPE_TEISEI2         '�萫�Q
                        cboResultType.AddItem "2:�萫�i�g���F-,+-,1+�`9+�j���i�[���܂�"
                        mstrArrResultType(0) = RESULTTYPE_TEISEI2
                    Case RESULTTYPE_FREE            '�t���[
                        cboResultType.AddItem "3:���ʓ��e���Œ肵�܂���i�t���[�j"
                        mstrArrResultType(0) = RESULTTYPE_FREE
                    Case RESULTTYPE_SENTENCE        '����
                        cboResultType.AddItem "4:���͌��ʂ��i�[���܂�"
                        mstrArrResultType(0) = RESULTTYPE_SENTENCE
                    Case RESULTTYPE_CALC            '�v�Z
                        cboResultType.AddItem "5:�v�Z���ڂł�"
                        mstrArrResultType(0) = RESULTTYPE_CALC
                    Case RESULTTYPE_DATE            '���t�^�C�v
                        cboResultType.AddItem "6:���t���i�[���܂�"
                        mstrArrResultType(0) = RESULTTYPE_DATE
                End Select
                
                cboResultType.ListIndex = 0
                
            End If
        End If
    End If
    
    '���ʃ^�C�v�R���{�̎g�p��
    If mintMode = MODE_REQUEST Then
        cboResultType.Enabled = False
    Else
        cboResultType.Enabled = (optDiv(1).Value = True)
    End If

End Sub
Friend Property Let Mode(ByVal vNewValue As Integer)

    mintMode = vNewValue
    
End Property
Friend Property Let Group(ByVal vNewValue As Integer)

    mintGroup = vNewValue
    
End Property

Friend Property Let Item(ByVal vNewValue As Integer)

    mintItem = vNewValue
    
End Property

Friend Property Let Question(ByVal vNewValue As Integer)

    mintQuestion = vNewValue
    
End Property



' @(e)
'
' �@�\�@�@ : �������ރR���{�ҏW
'
' �@�\���� : �������ރe�[�u���ɐݒ肳��Ă�����e���A�������ރR���{�ɐݒ�
'
' ���l�@�@ :
'
Private Function EditItemClassCombo()
    
    Dim objItemClass    As Object           '�������ڕ��ރA�N�Z�X�p
    Dim vntClassCd      As Variant          '�������ޖ���
    Dim vntClassName    As Variant          '�������ޖ���
    Dim lngCount        As Long             '���R�[�h��
    Dim i               As Long             '�C���f�b�N�X
    
    EditItemClassCombo = False
    cboItemClass.Clear
    Erase mstrArrClassCd
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntClassCd, vntClassName)
    
    '�S�Ă̓f�t�H���g�Ƃ��Ēǉ�
    cboItemClass.AddItem "�S��"
    cboItemClass.ListIndex = 0
    ReDim Preserve mstrArrClassCd(0)
    mstrArrClassCd(0) = ""
    
    '�R���{���X�g�̕ҏW
    For i = 0 To lngCount - 1
        cboItemClass.AddItem vntClassName(i)
        ReDim Preserve mstrArrClassCd(i + 1)
        mstrArrClassCd(i + 1) = CStr(vntClassCd(i))
    
        '�������ރR�[�h���w�肳��Ă���ꍇ�A���̕��ނ��f�t�H���g�Ƃ���
        If (mstrClassCd <> "") And (CStr(vntClassCd(i)) = mstrClassCd) Then
            cboItemClass.ListIndex = i + 1
        End If
        
    Next i
    
    EditItemClassCombo = True
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    EditItemClassCombo = False

End Function

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    
    Dim strMsg  As String

    'Shift�������Ȃ���Form���N���b�N����ƁA���݂̐ݒ��\���i�f�o�b�O�p�j
    If Shift Then
    
        strMsg = "���݂̕\�����[�h" & vbLf & vbLf
        strMsg = strMsg & "�\�����[�h�F" & IIf(mintMode = MODE_REQUEST, "�˗����ڂ�\�����܂�", "�������ڂ�\�����܂�") & vbLf
        strMsg = strMsg & "�O���[�v�F" & IIf(mintGroup = GROUP_OFF, "�\�����܂���", "�\�����܂�") & vbLf
        strMsg = strMsg & "�������ځF" & IIf(mintItem = ITEM_OFF, "�\�����܂���", "�\�����܂�") & vbLf
        strMsg = strMsg & "��f���ځF" & IIf(mintQuestion = QUESTION_OFF, "�\�����܂���", "�\�����܂�") & vbLf
        
        MsgBox strMsg, vbInformation
    
    End If

End Sub

Private Sub Form_Resize()
    
    If Me.WindowState <> vbMinimized Then
        Call SizeControls
    End If

End Sub

'
' �@�\�@�@ : �e��R���g���[���̃T�C�Y�ύX
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ :
'
' ���l�@�@ : �c���[�r���[�E���X�g�r���[�E�X�v���b�^�[�E���x�����̃T�C�Y��ύX����
'
Private Sub SizeControls()
    
    '���ύX
    If Me.Width > 4546 Then
        lsvItem.Width = Me.Width - 320
        cmdOk.Left = Me.Width - 3015
        cmdCancel.Left = cmdOk.Left + 1440
    End If
    
    '�����ύX
    If Me.Height > 3000 Then
        lsvItem.Height = Me.Height - 2750
        cmdOk.Top = Me.Height - 795
        cmdCancel.Top = cmdOk.Top
    End If

End Sub

Private Sub lsvItem_DblClick()

    Call CMDok_Click
    
End Sub


' @(e)
'
' �@�\�@�@ : �u�X�e�[�^�X�o�[�vClick
'
' �@�\���� : ���݂̕\�����[�h��\������
'
' ���l�@�@ :
'
Private Sub stbMain_PanelClick(ByVal Panel As MSComctlLib.Panel)
    
End Sub

Public Property Get ItemName() As Variant

    ItemName = mvntItemName

End Property
Public Property Get ItemCount() As Variant

    ItemCount = mintItemCount

End Property

Public Property Get ItemCd() As Variant

    ItemCd = mvntItemCd
    
End Property

Public Property Get ClassName() As Variant

    ClassName = mvntClassName
    
End Property


Public Property Get Suffix() As Variant

    Suffix = mvntSuffix
    
End Property


Public Property Get ItemDiv() As Variant

    ItemDiv = mstrItemDiv
    
End Property

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If
    
End Sub



Friend Property Let MultiSelect(ByVal vNewValue As Boolean)

    mblnMultiSelect = vNewValue

End Property

Friend Property Let ResultType(ByVal vNewValue As Variant)

'    mintResultType = vNewValue
    mvntResultType = vNewValue
    
End Property

Private Sub optDiv_Click(Index As Integer)

    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '���ʃ^�C�v�R���{�̎g�p��
    If mintMode = MODE_REQUEST Then
        cboResultType.Enabled = False
    Else
        cboResultType.Enabled = (Index = 1)
    End If

    '���ڃ��X�g�ҏW
    Call EditItemList

End Sub

Friend Property Let ClassCd(ByVal vNewValue As String)

    mstrClassCd = vNewValue
    
End Property
