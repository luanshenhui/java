VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmCommonGuide 
   Caption         =   "���ڃK�C�h"
   ClientHeight    =   5940
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5205
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCommonGuide.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5940
   ScaleWidth      =   5205
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdSearch 
      Caption         =   "����(&F)"
      Height          =   315
      Left            =   3840
      TabIndex        =   1
      Top             =   600
      Width           =   1215
   End
   Begin VB.TextBox txtOrgName 
      Height          =   315
      Left            =   780
      TabIndex        =   0
      Top             =   600
      Visible         =   0   'False
      Width           =   3015
   End
   Begin VB.ComboBox cboAnyClass 
      Height          =   300
      ItemData        =   "frmCommonGuide.frx":0442
      Left            =   780
      List            =   "frmCommonGuide.frx":0464
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   2
      Top             =   600
      Width           =   4290
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2340
      TabIndex        =   4
      Top             =   5520
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   3780
      TabIndex        =   5
      Top             =   5520
      Width           =   1335
   End
   Begin MSComctlLib.ListView lsvItem 
      Height          =   4275
      Left            =   120
      TabIndex        =   3
      Top             =   1080
      Width           =   4995
      _ExtentX        =   8811
      _ExtentY        =   7541
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      Icons           =   "imlToolbarIcons"
      SmallIcons      =   "imlToolbarIcons"
      ColHdrIcons     =   "imlToolbarIcons"
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   180
      Top             =   5340
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
            Picture         =   "frmCommonGuide.frx":0486
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCommonGuide.frx":08D8
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCommonGuide.frx":0D2A
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCommonGuide.frx":0E84
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Label Label5 
      Caption         =   "���ڂ�I�����Ă�������"
      Height          =   255
      Left            =   780
      TabIndex        =   6
      Top             =   300
      Width           =   4275
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   0
      Picture         =   "frmCommonGuide.frx":0FDE
      Top             =   60
      Width           =   720
   End
End
Attribute VB_Name = "frmCommonGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p��`�̈�
Private mblnRet             As Boolean  '�߂�l

Private mintTargetTable     As Integer  '�ǂݍ��݃e�[�u�����
Private mblnMultiSelect     As Boolean  '���X�g�r���[�̕����I��

Private mstrItemCd          As String   '�������ڃR�[�h�i���̓K�C�h�Ŏg�p�j
Private mstrItemType        As String   '���ڃ^�C�v�i���̓K�C�h�Ŏg�p�j

Private mblnNowEdit         As Boolean  'TRUE:�ҏW���AFALSE:�\���p�ҏW�\

Private mintRecordCount     As Integer  '�I�����ꂽ���ڐ�
Private mvntRecordCode()    As Variant  '�I�����ꂽ���ڃR�[�h
Private mvntRecordName()    As Variant  '�I�����ꂽ���ږ�

Private mstrClassCd()       As String   '�R���{�{�b�N�X�ɑΉ����镪�ރR�[�h

'�Œ�R�[�h�Ǘ�
Const KEY_PREFIX            As String = "K"

Public Property Get Ret() As Variant

    Ret = mblnRet

End Property

' @(e)
'
' �@�\�@�@ : �u�������ރR���{�vClick
'
' �@�\���� : �������ރR���{���e��ύX���ꂽ���ɁA�������ڕ\�����e��ύX����B
'
' ���l�@�@ :
'
Private Sub cboAnyClass_Click()

    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '���ڃ��X�g�ҏW
    Call SetListViewData

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

    mintRecordCount = 0
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

    Dim X           As Object
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
    mintRecordCount = 0
    j = 0
    Erase mvntRecordCode
    Erase mvntRecordName

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
                mintRecordCount = mintRecordCount + 1
                                
                '�z��g��
                ReDim Preserve mvntRecordCode(j)
                ReDim Preserve mvntRecordName(j)
                
                '���X�g�r���[�p�̃L�[�v���t�B�b�N�X���폜
                strWorkKey = Mid(lsvItem.ListItems(i).Key, 2, Len(lsvItem.ListItems(i).Key))
'                lngPointer = InStr(strWorkKey, "-")
'                If lngPointer <> 0 Then
'                    mvntRecordCode(j) = Mid(strWorkKey, 1, lngPointer - 1)
'                Else
                    mvntRecordCode(j) = strWorkKey
'                End If
                
                mvntRecordName(j) = lsvItem.ListItems(i).SubItems(1)
                j = j + 1
            
            End If
        Next i
            
        '�����I������Ă��Ȃ��Ȃ炨�I��
        If mintRecordCount = 0 Then
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

Private Sub cmdSearch_Click()

    Call EditListViewFromOrg

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
    mintRecordCount = 0
    mblnNowEdit = True
    lsvItem.MultiSelect = mblnMultiSelect

    Do

        '���ޗp�R���{�{�b�N�X�̃Z�b�g
        If SetConboData = False Then Exit Do
    
        '�w�胊�X�g�r���[�̃Z�b�g
        If SetListViewData = False Then Exit Do
    
        Ret = True
        Exit Do
    
    Loop
    
    '�߂�l�̐ݒ�
    mblnRet = Ret
    
    '�������̉���
    mblnNowEdit = False
    
    Screen.MousePointer = vbDefault

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
        lsvItem.Height = Me.Height - 2000
        cmdOk.Top = Me.Height - 795
        cmdCancel.Top = cmdOk.Top
    End If

End Sub

Private Sub lsvItem_DblClick()

    Call CMDok_Click
    
End Sub

Public Property Get RecordName() As Variant

    RecordName = mvntRecordName

End Property
Public Property Get RecordCount() As Variant

    RecordCount = mintRecordCount

End Property

Public Property Get RecordCode() As Variant

    RecordCode = mvntRecordCode
    
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

Friend Property Let TargetTable(ByVal vNewValue As Integer)

    mintTargetTable = vNewValue

End Property

Private Function SetConboData() As Boolean

    SetConboData = False
    
    Select Case mintTargetTable
        
        Case getSentence        '���̓K�C�h
            cboAnyClass.Visible = False
            
        Case getJudCmtStc       '����R�����g
                
            '���蕪�ރR���{�Z�b�g
            If EditJudClass() = False Then
                Exit Function
            End If
        
        Case getZaimu           '�����K�p�R�[�h�K�C�h
            cboAnyClass.Visible = False
        
        Case getZaimuOrg        '�����A�g�p�c�̃R�[�h�K�C�h
            cboAnyClass.Visible = False
            txtOrgName.Visible = True
            cmdSearch.Visible = True
            cmdOk.Default = False
        
        Case Else
            Exit Function
    End Select
    
    SetConboData = True
    
End Function

Private Function SetListViewData() As Boolean

    SetListViewData = False
    
    Select Case mintTargetTable
        Case getSentence        '����
                
            '���̓e�[�u���Z�b�g
            If EditListViewFromSentence() = False Then
                Exit Function
            End If
        
        Case getJudCmtStc       '����R�����g
                
            '����R�����g�Z�b�g
            If EditListViewFromJudCmtStc() = False Then
                Exit Function
            End If
        
        Case getZaimu           '�����K�p�R�[�h
                
            '�����K�p�R�[�h�Z�b�g
            If EditListViewFromZaimu() = False Then
                Exit Function
            End If
        
        Case getZaimuOrg        '�����p�c�̃R�[�h
                
            '�����K�p�R�[�h�Z�b�g
'            If EditListViewFromZaimu() = False Then
'                Exit Function
'            End If
        
        Case Else
            Exit Function
    End Select
    
    SetListViewData = True
    
End Function

'
' �@�\�@�@ : �����p�c�̃R�[�h�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : �R���{�Ŏw�肳�ꂽ���蕪�ރR�[�h�ɊY�����锻��R�����g��\������B
'
Private Function EditListViewFromOrg() As Boolean

On Error GoTo ErrorHandle

    Dim objOrg              As Object           '����R�����g�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntOrgCd1           As Variant          '�c�̃R�[�h�P
    Dim vntOrgCd2           As Variant          '�c�̃R�[�h�Q
    Dim vntOrgName          As Variant          '�c�̖�
    Dim vntOrgSName         As Variant          '����
    Dim vntOrgKName         As Variant          '�J�i����
    
    Dim i                   As Long             '�C���f�b�N�X
    Dim lngCount            As Long
    Dim strArrKey           As Variant
    
    EditListViewFromOrg = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOrg = CreateObject("HainsOrganization.Organization")
    
    '�����L�[���󔒂ŕ�������
    strArrKey = SplitByBlank(txtOrgName.Text)
    lngCount = objOrg.SelectOrgList(strArrKey, _
                                    1, _
                                    30000, _
                                    vntOrgCd1, _
                                    vntOrgCd2, _
                                    vntOrgName, _
                                    vntOrgSName, _
                                    vntOrgKName)
    
    '�w�b�_�̕ҏW
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�c�̃R�[�h", 1300, lvwColumnLeft
    objHeader.Add , , "�c�̖�", 5000, lvwColumnLeft
    objHeader.Add , , "�c�̃J�i��", 5000, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntOrgCd1(i) & vntOrgCd2(i), vntOrgCd1(i) & vntOrgCd2(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntOrgName(i)
        objItem.SubItems(2) = vntOrgKName(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objOrg = Nothing
    
    EditListViewFromOrg = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �󔒂ɂ�镶����̕���
'
' �����@�@ : (In)     strExpression  ������
'
' �߂�l�@ : �������ꂽ������̔z��
'
' ���l�@�@ : �ʏ��Split�֐��ł͋󔒕������������񂾏ꍇ�ɑΉ��ł��Ȃ����ߍ쐬
'
'-------------------------------------------------------------------------------
Private Function SplitByBlank(strExpression As String) As Variant

    Dim strBuffer  As String '�ϊ�������̕�����o�b�t�@

    If Trim(strExpression) = "" Then
        SplitByBlank = Empty
        Exit Function
    End If

    '�S�p�󔒂𔼊p�󔒂ɒu������
    strBuffer = Replace(Trim(strExpression), "�@", " ")

    '2�o�C�g�ȏ�̔��p�󔒕��������݂��Ȃ��Ȃ�܂Œu�����J��Ԃ�
    Do Until InStr(1, strBuffer, "  ") = 0
        strBuffer = Replace(strBuffer, "  ", " ")
    Loop

    '1�o�C�g���p�󔒂��f���~�^�Ƃ��Ĕz����쐬
    SplitByBlank = Split(strBuffer, " ")

End Function

' @(e)
'
' �@�\�@�@ : ���蕪�ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���蕪�ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditJudClass() As Boolean

    Dim objJudClass         As Object       '���蕪�ރA�N�Z�X�p
    Dim vntJudClassCd       As Variant
    Dim vntJudClassName     As Variant

    Dim lngCount    As Long             '���R�[�h��
    Dim i           As Long             '�C���f�b�N�X
    
    EditJudClass = False
    
    cboAnyClass.Clear
    Erase mstrClassCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)
    
    '���蕪�ރR�[�h�͖��I������
    ReDim Preserve mstrClassCd(0)
    mstrClassCd(0) = ""
    cboAnyClass.AddItem ""
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrClassCd(i + 1)
        mstrClassCd(i + 1) = vntJudClassCd(i)
        cboAnyClass.AddItem vntJudClassName(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���i���蕪�ނ͖��I������j
    cboAnyClass.ListIndex = 0
    
    EditJudClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'
' �@�\�@�@ : ����R�����g�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : �R���{�Ŏw�肳�ꂽ���蕪�ރR�[�h�ɊY�����锻��R�����g��\������B
'
Private Function EditListViewFromJudCmtStc() As Boolean

On Error GoTo ErrorHandle

    Dim objJudCmtStc        As Object           '����R�����g�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntJudCmtCd         As Variant          '����R�����g�R�[�h
    Dim vntJudCmtStcName    As Variant          '����R�����g��
    Dim vntDummy(2)         As Variant          'COM+�����p�_�~�[�ϐ�
    
    Dim i                   As Long             '�C���f�b�N�X
    Dim lngCount            As Long
    
    EditListViewFromJudCmtStc = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    lngCount = objJudCmtStc.SelectJudCmtStcList(mstrClassCd(cboAnyClass.ListIndex), _
                                                vntDummy(0), _
                                                1, _
                                                "", _
                                                vntJudCmtCd, _
                                                vntJudCmtStcName, _
                                                vntDummy(1), _
                                                vntDummy(2))
    
    '�w�b�_�̕ҏW
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 1300, lvwColumnLeft
    objHeader.Add , , "����R�����g", 5000, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntJudCmtCd(i), vntJudCmtCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntJudCmtStcName(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objJudCmtStc = Nothing
    
    EditListViewFromJudCmtStc = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

'
' �@�\�@�@ : �����K�p�R�[�h�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Function EditListViewFromZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu            As Object           '�����K�p�R�[�h�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntZaimuCd          As Variant          '�����R�[�h�R�[�h
    Dim vntZaimuName        As Variant            '�����K�p��
    Dim vntZaimuDiv         As Variant          '�������
    Dim vntZaimuClass       As Variant          '��������
    Dim i                   As Long             '�C���f�b�N�X
    Dim strZaimuClassName   As String
    Dim strZaimuDivName     As String
    Dim lngCount            As Long
    
    EditListViewFromZaimu = False
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass)
    
    '�w�b�_�̕ҏW
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�����K�p�R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�����K�p��", 3300, lvwColumnLeft
    objHeader.Add , , "�������", 1500, lvwColumnLeft
    objHeader.Add , , "��������", 1300, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Select Case vntZaimuClass(i)
            Case 0
                strZaimuClassName = "������"
            Case 1
                strZaimuClassName = "�l"
            Case 2
                strZaimuClassName = "�c��"
            Case 3
                strZaimuClassName = "�d�b����"
            Case 4
                strZaimuClassName = "�����쐬"
            Case 5
                strZaimuClassName = "���̑�����"
            Case Else
                strZaimuClassName = vntZaimuClass(i)
        End Select
        
        Select Case vntZaimuDiv(i)
            Case 1
                strZaimuDivName = "����"
            Case 2
                strZaimuDivName = "����"
            Case 3
                strZaimuDivName = "�ߋ�������"
            Case 4
                strZaimuDivName = "�ҕt"
            Case 5
                strZaimuDivName = "�ҕt����"
            Case Else
                strZaimuDivName = vntZaimuDiv(i)
        End Select
        
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntZaimuCd(i), vntZaimuCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntZaimuName(i)
        objItem.SubItems(2) = strZaimuDivName
        objItem.SubItems(3) = strZaimuClassName
    
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objZaimu = Nothing
    
    EditListViewFromZaimu = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

'
' �@�\�@�@ : ���͈ꗗ�\��
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Function EditListViewFromSentence() As Boolean

On Error GoTo ErrorHandle

    Dim objSentence     As Object           '���̓A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntItemCd       As Variant          '�������ڃR�[�h
    Dim vntItemType     As Variant          '���ڃ^�C�v
    Dim vntStcCd        As Variant          '���̓R�[�h
    Dim vntShortStc     As Variant          '����
    Dim lngCount        As Long
    
    Dim i               As Long             '�C���f�b�N�X
    
    EditListViewFromSentence = False

    '�������ڃR�[�h�ƍ��ڃ^�C�v���w�肳��Ă��Ȃ��Ȃ當�̓K�C�h�͕\���ł��܂��`��
    If (Trim(mstrItemCd) = "") Or (Trim(mstrItemType) = "") Then
        MsgBox "�������ڃR�[�h�A�������͍��ڃ^�C�v���w�肳��Ă��܂���B" & vbLf & _
               "���ڃK�C�h�͕\���ł��܂���B" & vbLf & vbLf & _
               "�������ڃR�[�h�F" & mstrItemCd & vbLf & _
               "���ڃ^�C�v�F" & mstrItemType, vbCritical, Me.Caption
        Exit Function
    End If
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSentence = CreateObject("HainsSentence.Sentence")
    lngCount = objSentence.SelectSentenceList(mstrItemCd, _
                                              mstrItemType, _
                                              vntStcCd, _
                                              vntShortStc)
    
    '���R�[�h�������P�����Ȃ��Ȃ�K�C�h�\������Ӗ��Ȃ�
    If lngCount < 1 Then
        MsgBox "���͌��ʂ��P�����o�^����Ă��܂���", vbExclamation, Me.Caption
        Exit Function
    End If
    
    '�w�b�_�̕ҏW
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ڃR�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "���͖�", 2200, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntStcCd(i), vntStcCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntShortStc(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objSentence = Nothing
    
    EditListViewFromSentence = True
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

Public Property Let ItemCd(ByVal vNewValue As String)

    mstrItemCd = vNewValue

End Property

Public Property Let ItemType(ByVal vNewValue As String)

    mstrItemType = vNewValue

End Property

Private Sub txtOrgName_GotFocus()
    
    With txtOrgName
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Private Sub txtOrgName_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = vbKeyReturn Then
        Call cmdSearch_Click
    End If
    
End Sub
