VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmWeb_Cs 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "WEB�R�[�X�ݒ胁���e�i���X"
   ClientHeight    =   5115
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8895
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmWeb_Cs.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5115
   ScaleWidth      =   8895
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   7560
      TabIndex        =   22
      Top             =   4620
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6120
      TabIndex        =   15
      Top             =   4620
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   4680
      TabIndex        =   14
      Top             =   4620
      Width           =   1335
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   4275
      Left            =   120
      TabIndex        =   16
      Top             =   120
      Width           =   8655
      _ExtentX        =   15266
      _ExtentY        =   7541
      _Version        =   393216
      Style           =   1
      Tab             =   1
      TabHeight       =   520
      TabCaption(0)   =   "��{���"
      TabPicture(0)   =   "frmWeb_Cs.frx":000C
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Label1(2)"
      Tab(0).Control(1)=   "Label8(0)"
      Tab(0).Control(2)=   "Label1(1)"
      Tab(0).Control(3)=   "Label1(0)"
      Tab(0).Control(4)=   "Label2"
      Tab(0).Control(5)=   "txtItemOutLine"
      Tab(0).Control(6)=   "cboCourse"
      Tab(0).Control(7)=   "txtCsName"
      Tab(0).Control(8)=   "txtOutLine"
      Tab(0).ControlCount=   9
      TabCaption(1)   =   "�ڍ׏��"
      TabPicture(1)   =   "frmWeb_Cs.frx":0028
      Tab(1).ControlEnabled=   -1  'True
      Tab(1).Control(0)=   "lsvCsDetail"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "cmdEditCsDetail"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).Control(2)=   "cmdUpItem"
      Tab(1).Control(2).Enabled=   0   'False
      Tab(1).Control(3)=   "cmdDownItem"
      Tab(1).Control(3).Enabled=   0   'False
      Tab(1).Control(4)=   "cmdDeleteCsDetail"
      Tab(1).Control(4).Enabled=   0   'False
      Tab(1).Control(5)=   "cmdAddCsDetail"
      Tab(1).Control(5).Enabled=   0   'False
      Tab(1).ControlCount=   6
      TabCaption(2)   =   "�I�v�V��������"
      TabPicture(2)   =   "frmWeb_Cs.frx":0044
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "cboCtrMng"
      Tab(2).Control(1)=   "cmdEditOpt"
      Tab(2).Control(2)=   "cmdClearOption"
      Tab(2).Control(3)=   "lsvOption"
      Tab(2).Control(4)=   "Label8(1)"
      Tab(2).ControlCount=   5
      Begin VB.ComboBox cboCtrMng 
         Height          =   300
         ItemData        =   "frmWeb_Cs.frx":0060
         Left            =   -73620
         List            =   "frmWeb_Cs.frx":0082
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   20
         Top             =   480
         Width           =   4650
      End
      Begin VB.CommandButton cmdEditOpt 
         Caption         =   "�ҏW(&E)"
         Height          =   315
         Left            =   -69240
         TabIndex        =   18
         Top             =   3780
         Width           =   1275
      End
      Begin VB.CommandButton cmdClearOption 
         Caption         =   "�N���A(&C)"
         Height          =   315
         Left            =   -67860
         TabIndex        =   17
         Top             =   3780
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddCsDetail 
         Caption         =   "�ǉ�(&D)..."
         Height          =   315
         Left            =   4380
         TabIndex        =   11
         Top             =   3780
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteCsDetail 
         Caption         =   "�폜(&R)"
         Height          =   315
         Left            =   7140
         TabIndex        =   13
         Top             =   3780
         Width           =   1275
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
         Left            =   240
         TabIndex        =   10
         Top             =   1860
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
         Left            =   240
         TabIndex        =   9
         Top             =   1320
         Width           =   315
      End
      Begin VB.CommandButton cmdEditCsDetail 
         Caption         =   "�ҏW(&E)"
         Height          =   315
         Left            =   5760
         TabIndex        =   12
         Top             =   3780
         Width           =   1275
      End
      Begin VB.TextBox txtOutLine 
         Height          =   600
         Left            =   -73320
         MaxLength       =   50
         MultiLine       =   -1  'True
         TabIndex        =   5
         Text            =   "frmWeb_Cs.frx":00A4
         Top             =   1500
         Width           =   6675
      End
      Begin VB.TextBox txtCsName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   -73320
         MaxLength       =   15
         TabIndex        =   3
         Text            =   "��������"
         Top             =   1020
         Width           =   6675
      End
      Begin VB.ComboBox cboCourse 
         Height          =   300
         ItemData        =   "frmWeb_Cs.frx":00A7
         Left            =   -73320
         List            =   "frmWeb_Cs.frx":00C9
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   1
         Top             =   600
         Width           =   4650
      End
      Begin VB.TextBox txtItemOutLine 
         Height          =   1440
         Left            =   -73320
         MaxLength       =   150
         MultiLine       =   -1  'True
         TabIndex        =   7
         Text            =   "frmWeb_Cs.frx":00EB
         Top             =   2220
         Width           =   6675
      End
      Begin MSComctlLib.ListView lsvCsDetail 
         Height          =   3075
         Left            =   660
         TabIndex        =   8
         Top             =   540
         Width           =   7755
         _ExtentX        =   13679
         _ExtentY        =   5424
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
      Begin MSComctlLib.ListView lsvOption 
         Height          =   2775
         Left            =   -74820
         TabIndex        =   19
         Top             =   900
         Width           =   8295
         _ExtentX        =   14631
         _ExtentY        =   4895
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
      Begin VB.Label Label2 
         Caption         =   "�R�[�X�T���ƌ������ڐ����͉��s������Ƃ��̂܂�WEB�y�[�W�ŕ\������܂��B"
         Height          =   255
         Left            =   -73260
         TabIndex        =   23
         Top             =   3780
         Width           =   6615
      End
      Begin VB.Label Label8 
         Caption         =   "�L������(&C):"
         Height          =   195
         Index           =   1
         Left            =   -74760
         TabIndex        =   21
         Top             =   540
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "�R�[�X�T��(&A)"
         Height          =   180
         Index           =   0
         Left            =   -74760
         TabIndex        =   4
         Top             =   1560
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "�R�[�X��(&N)"
         Height          =   180
         Index           =   1
         Left            =   -74760
         TabIndex        =   2
         Top             =   1080
         Width           =   1410
      End
      Begin VB.Label Label8 
         Caption         =   "�R�[�X(&C):"
         Height          =   195
         Index           =   0
         Left            =   -74760
         TabIndex        =   0
         Top             =   660
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "�������ڐ���(&K)"
         Height          =   180
         Index           =   2
         Left            =   -74760
         TabIndex        =   6
         Top             =   2280
         Width           =   1410
      End
   End
End
Attribute VB_Name = "frmWeb_Cs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd                As String       'WEB�R�[�X�ݒ�R�[�h
Private mblnInitialize          As Boolean      'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean      'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrRootCsCd()          As String       '�R���{�{�b�N�X�ɑΉ�����R�[�X�R�[�h�̊i�[
Private mintCtrPtCd()           As String       '�R���{�{�b�N�X�ɑΉ�����_��p�^�[���R�[�h�̊i�[

Private mintDetailMaxKey        As Integer      '�׏��̃��X�g�r���[�L�[�����j�[�N�ɂ��邽�߂ɕێ�
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private mblnNowEdit             As Boolean      'TRUE:�ҏW�������AFALSE:�����Ȃ�
Private mblnEditData            As Boolean      '��{�n�̃f�[�^�C���iTRUE:�X�V�AFALSE:���X�V�j
Private mblnEditOptData         As Boolean      '��{�n�̃f�[�^�C���iTRUE:�X�V�AFALSE:���X�V�j
Private mblnModeNew             As Boolean      'TRUE:�V�K�쐬�AFALSE:�X�V

Private mintCtrMngBeforeIndex   As Integer      '�����R���{�ύX�L�����Z���p�̑OIndex
Private mintCourseBeforeIndex   As Integer      '�R�[�X�R���{�̑OIndex

Const mstrListViewKey           As String = "K"

Friend Property Let CsCd(ByVal vntNewValue As Variant)

    mstrCsCd = vntNewValue
    
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

        '���̂̓��̓`�F�b�N
        If Trim(txtCsName.Text) = "" Then
            MsgBox "�R�[�X�������͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCsName.SetFocus
            Exit Do
        End If

        '�T���̓��̓`�F�b�N
        If Trim(txtOutLine.Text) = "" Then
            MsgBox "�R�[�X�T�������͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtOutLine.SetFocus
            Exit Do
        End If

        '�������ڐ����̓��̓`�F�b�N
        If Trim(txtItemOutLine.Text) = "" Then
            MsgBox "�������ڐ��������͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtItemOutLine.SetFocus
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
' �@�\�@�@ : �R�[�X�f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �R�[�X�f�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditCourseConbo() As Boolean

    Dim objCourse       As Object   '�R�[�X�A�N�Z�X�p
    Dim vntCsCd         As Variant
    Dim vntCsName       As Variant
    Dim vntWebColor     As Variant
    Dim vntStrDate      As Variant
    Dim vntEndDate      As Variant
    
    Dim lngCount        As Long             '���R�[�h��
    Dim lngTrueCount    As Long             '�^�̃��R�[�h���i�_�񂪑��݂�����́j
    Dim i               As Long             '�C���f�b�N�X
    Dim j               As Long             '�C���f�b�N�X
'    Dim k               As Long             '�C���f�b�N�X
    
    Dim blnDataExists   As Boolean          'TRUE:���ɃR�[�X�����݁AFALSE=�R�[�X���ǉ�
    
    EditCourseConbo = False
    
    cboCourse.Clear
    Erase mstrRootCsCd
    lngTrueCount = 0
'    k = 0

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsContract.Contract")
    lngCount = objCourse.SelectAllCourseCtrMng("WWWWW", _
                                               "WWWWW", _
                                               vntWebColor, _
                                               vntCsCd, _
                                               vntCsName, _
                                               vntStrDate, _
                                               vntEndDate)
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        If Trim(vntStrDate(i)) <> "" Then
            
            blnDataExists = False
            '���ɒǉ�����Ă��邩�ǂ����`�F�b�N����
            For j = 0 To cboCourse.ListCount - 1
                If mstrRootCsCd(j) = Trim(vntCsCd(i)) Then
                    blnDataExists = True
                    Exit For
                End If
            Next j
            
            '�R���{���ǉ��Ȃ�A�f�[�^�ǉ�
            If blnDataExists = False Then
                ReDim Preserve mstrRootCsCd(lngTrueCount)
                mstrRootCsCd(lngTrueCount) = vntCsCd(i)
                cboCourse.AddItem vntCsName(i)
                lngTrueCount = lngTrueCount + 1
            End If
        
        End If
    Next i
    
    If lngTrueCount <= 0 Then
        '�f�[�^�����݂��Ȃ��Ȃ�A�G���[
        MsgBox "WEB�p�c��(WWWWW-WWWWW)�ɗL���Ȍ_���ݒ肵�Ă���R�[�X�����݂��܂���B" & vbLf & _
               "�R�[�X�f�[�^�A�y�ь_���o�^���Ȃ���WEB�R�[�X�ݒ���s�����Ƃ͂ł��܂���B", vbExclamation
        Exit Function
    
    Else
        '�R�[�X�R�[�h���w�肳��Ă���Ȃ�A���̃R�[�X�R�[�h�ŃR���{�Z�b�g
        If mstrCsCd <> "" Then
            For i = 0 To UBound(mstrRootCsCd)
                If mstrRootCsCd(i) = mstrCsCd Then
                    cboCourse.ListIndex = i
                    Exit For
                End If
            Next i
        Else
            cboCourse.ListIndex = 0
            mstrCsCd = mstrRootCsCd(0)
        End If
    End If
    
    EditCourseConbo = True
    
    Exit Function
    
ErrorHandle:

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
Private Function EditWeb_Cs() As Boolean

    Dim objWeb_Cs       As Object           'WEB�R�[�X�ݒ�A�N�Z�X�p
    Dim vntCsName       As Variant          'WEB�R�[�X�ݒ薼
    Dim vntOutLine      As Variant          '�R�[�X�T��
    Dim vntItemOutLine  As Variant          '�������ڐ���
    Dim Ret             As Boolean          '�߂�l
    Dim i               As Integer
    
    Dim strItemOutLine  As String
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�i�V�K�j�͉������Ȃ�
        If mstrCsCd = "" Then
            
            '�R�[�X�R���{�̐擪��I����Ԃɂ���
            cboCourse.ListIndex = 0
            
            Ret = True
            Exit Do
        End If
        
        'WEB�R�[�X�ݒ�e�[�u�����R�[�h�ǂݍ���
        If objWeb_Cs.SelectWeb_Cs(mstrCsCd, vntCsName, vntOutLine, vntItemOutLine) = False Then
            
            mblnModeNew = True
            txtCsName.Text = ""
            txtOutLine.Text = ""
            txtItemOutLine.Text = ""
                    
            Ret = True
            Exit Do
        End If
    
        mblnModeNew = False
        
        '�ǂݍ��ݓ��e�̕ҏW
        For i = 0 To cboCourse.ListCount - 1
            If mstrRootCsCd(i) = mstrCsCd Then
                cboCourse.ListIndex = i
            End If
        Next i
        
        txtCsName.Text = vntCsName
        'WEB�p�Ƀ^�O�����s�R�[�h�ɕϊ�
        txtOutLine.Text = Replace(vntOutLine, "<BR>", vbCrLf)
        txtItemOutLine.Text = Replace(vntItemOutLine, "<BR>", vbCrLf)
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditWeb_Cs = Ret
    
    Exit Function

ErrorHandle:

    EditWeb_Cs = False
    MsgBox Err.Description, vbCritical
    
End Function
' @(e)
'
' �@�\�@�@ : �Ǘ��������ڕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���ݐݒ肳��Ă���O���[�v���������ڂ�\������
'
' ���l�@�@ :
'
Private Function EditWeb_CsDetail() As Boolean
    
On Error GoTo ErrorHandle

    Dim objWeb_Cs       As Object               '�O���[�v�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntSeq          As Variant              'SEQ
    Dim vntInspect      As Variant              '����
    Dim vntInsDetail    As Variant              '�������ޖ���
    Dim lngCount        As Long                 '���R�[�h��
    
    Dim i               As Long                 '�C���f�b�N�X

    EditWeb_CsDetail = False

    '���X�g�A�C�e���N���A
    lsvCsDetail.ListItems.Clear
    lsvCsDetail.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    
    '�O���[�v���������ڌ���
    lngCount = objWeb_Cs.SelectWeb_CsDetailList(mstrCsCd, vntSeq, vntInspect, vntInsDetail)

    '�w�b�_�̕ҏW
    Set objHeader = lsvCsDetail.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "������", 2000, lvwColumnLeft
        .Add , , "��������", 4000, lvwColumnLeft
    End With
        
    lsvCsDetail.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvCsDetail.ListItems.Add(, mstrListViewKey & vntSeq(i), vntInspect(i))
        'WEB�p�ɉ��s�R�[�h���^�O�ɕϊ�
        objItem.SubItems(1) = Replace(vntInsDetail(i), "<BR>", vbCrLf)
    Next i
    
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvCsDetail.ListItems.Count > 0 Then
        lsvCsDetail.ListItems(1).Selected = False
    End If
    
    mintDetailMaxKey = lngCount
    EditWeb_CsDetail = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'
' �@�\�@�@ : �_����ԃR���{�i�I�v�V���������p�j�Z�b�g
'
' �����@�@ :
'
' �߂�l�@ : �擾����
'
' ���l�@�@ :
'
Private Function SetCtrMng() As Long

On Error GoTo ErrorHandle

    Dim objCtrMng       As Object           '���ʃR�����g�A�N�Z�X�p
    
    Dim vntCtrPtCd      As Variant          '�_��p�^�[���R�[�h
    Dim vntStrDate      As Variant          '�_��J�n��
    Dim vntEndDate      As Variant          '�_��I����

    Dim lngCount        As Long             '���R�[�h��
    Dim i               As Long             '�C���f�b�N�X
    
    SetCtrMng = 0
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCtrMng = CreateObject("HainsContract.Contract")
    

    lngCount = objCtrMng.SelectCtrMngWithPeriod("WWWWW", _
                                                "WWWWW", _
                                                mstrRootCsCd(cboCourse.ListIndex), _
                                                vntCtrPtCd, _
                                                vntStrDate, _
                                                vntEndDate)
    
    cboCtrMng.Clear
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mintCtrPtCd(i)
        mintCtrPtCd(i) = CInt(vntCtrPtCd(i))
        cboCtrMng.AddItem vntStrDate(i) & "�`" & vntEndDate(i) & "�܂ŗL���Ȍ_����"
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objCtrMng = Nothing
    
    If lngCount > 0 Then
        cboCtrMng.ListIndex = 0
    End If
    
    SetCtrMng = lngCount
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �I�v�V���������\��
'
' �@�\���� : ���ݐݒ肳��Ă���I�v�V����������\������
'
' ���l�@�@ :
'
Private Function EditOptList() As Boolean
    
On Error GoTo ErrorHandle

    Dim objOptList      As Object               '�I�v�V���������A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntOptCd        As Variant              '�I�v�V�����R�[�h
    Dim vntCtrOptName   As Variant              '�I�v�V�����������i�_���j
    Dim vntOptName      As Variant              '�I�v�V�����������iWEB�\��ݒ�l�j
    Dim vntOptPurpose   As Variant              '�I�v�V���������ړI
    Dim vntOptDetail    As Variant              '�I�v�V���������ڍ�
    Dim lngCount        As Long                 '���R�[�h��
    
    Dim i               As Long                 '�C���f�b�N�X

    EditOptList = False

    '���X�g�A�C�e���N���A
    lsvOption.ListItems.Clear
    lsvOption.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOptList = CreateObject("HainsWeb_Cs.Web_Cs")
    
    '�I�v�V�����������擾
    lngCount = objOptList.SelectWeb_OptList(mintCtrPtCd(cboCtrMng.ListIndex), _
                                            vntOptCd, _
                                            vntCtrOptName, _
                                            vntOptName, _
                                            vntOptPurpose, _
                                            vntOptDetail)
    
    '�w�b�_�̕ҏW
    Set objHeader = lsvOption.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�I�v�V������", 1800, lvwColumnLeft
        .Add , , "�ݒ薼��", 1800, lvwColumnLeft
        .Add , , "�����ړI", 2000, lvwColumnLeft
        .Add , , "�����ڍ�", 3000, lvwColumnLeft
        .Add , , "�I�v�V�����R�[�h", 2000, lvwColumnLeft
    End With
        
    lsvOption.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvOption.ListItems.Add(, mstrListViewKey & vntOptCd(i), vntCtrOptName(i))
        objItem.SubItems(1) = vntOptName(i)
        objItem.SubItems(2) = vntOptPurpose(i)
        objItem.SubItems(3) = Replace(vntOptDetail(i), "<BR>", vbCrLf)
        objItem.SubItems(4) = vntOptCd(i)
    Next i
    
    EditOptList = True
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
Private Function RegistWeb_Cs() As Boolean

On Error GoTo ErrorHandle

    Dim objWeb_Cs       As Object       'WEB�R�[�X�ݒ�A�N�Z�X�p
    Dim Ret             As Long
    Dim i               As Integer
    Dim j               As Integer
    Dim intItemCount    As Integer
    Dim intOptCount    As Integer
    
    Dim vntSeq()        As Variant
    Dim vntInspect()    As Variant
    Dim vntInsDetail()  As Variant
    
    Dim vntOptCd()      As Variant
    Dim vntOptName()    As Variant
    Dim vntOptPurpose() As Variant
    Dim vntOptDetail()  As Variant
    
    intItemCount = 0
    intOptCount = 0
    Erase vntSeq
    Erase vntInspect
    Erase vntInsDetail
    j = 0

    'WEB�R�[�X�ڍ׃e�[�u���̊i�[���e��z��ɃZ�b�g
    For i = 1 To lsvCsDetail.ListItems.Count
        
        ReDim Preserve vntSeq(j)
        ReDim Preserve vntInspect(j)
        ReDim Preserve vntInsDetail(j)
        
        vntSeq(j) = i
        vntInspect(j) = Trim(lsvCsDetail.ListItems(i).Text)
        vntInsDetail(j) = Replace(Trim(lsvCsDetail.ListItems(i).SubItems(1)), vbCrLf, "<BR>")
        
        j = j + 1
        intItemCount = intItemCount + 1
    
    Next i
    
    j = 0
    'WEB�I�v�V���������e�[�u���̊i�[���e��z��ɃZ�b�g
    For i = 1 To lsvOption.ListItems.Count
        
        If lsvOption.ListItems(i).SubItems(1) <> "" Then
                
            ReDim Preserve vntOptCd(j)
            ReDim Preserve vntOptName(j)
            ReDim Preserve vntOptPurpose(j)
            ReDim Preserve vntOptDetail(j)
            
            With lsvOption.ListItems(i)
                vntOptCd(j) = Trim(.SubItems(4))
                vntOptName(j) = Trim(.SubItems(1))
                vntOptPurpose(j) = Trim(.SubItems(2))
                vntOptDetail(j) = Replace(Trim(.SubItems(3)), vbCrLf, "<BR>")
            End With
            
            j = j + 1
            intOptCount = intOptCount + 1
    
        End If
    
    Next i
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    
    'WEB�R�[�X�ݒ�e�[�u�����R�[�h�̓o�^
    Ret = objWeb_Cs.RegistWeb_Cs_All(IIf(mblnModeNew, "INS", "UPD"), _
                                     mstrRootCsCd(cboCourse.ListIndex), _
                                     Trim(txtCsName.Text), _
                                     Replace(Trim(txtOutLine.Text), vbCrLf, "<BR>"), _
                                     Replace(Trim(txtItemOutLine.Text), vbCrLf, "<BR>"), _
                                     lsvCsDetail.ListItems.Count, _
                                     vntSeq, _
                                     vntInspect, _
                                     vntInsDetail, _
                                     mintCtrPtCd(cboCtrMng.ListIndex), _
                                     intOptCount, _
                                     vntOptCd, _
                                     vntOptName, _
                                     vntOptPurpose, _
                                     vntOptDetail)
    
    If Ret = 0 Then
        MsgBox "���͂��ꂽWEB�R�[�X�ݒ�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistWeb_Cs = False
        Exit Function
    End If
    
    RegistWeb_Cs = True
        
    Exit Function
    
ErrorHandle:

    RegistWeb_Cs = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub cboCourse_Click()
    
    Dim lngHistoryCount     As Long
    Dim strMsg              As String
    Dim intRet              As Integer
    
    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    '���݂̏�Ԃ��X�V����Ă�����A�x��
    If (mblnEditData = True) Or (mblnEditOptData = True) Then
        strMsg = "�f�[�^���X�V����Ă��܂��B�I���R�[�X��ύX����Ɠ��͓��e���j������܂�" & vbLf & _
                 "��낵���ł����H"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then
            mblnNowEdit = True                              '����Loop�h�~�̂��߁A��������
            cboCourse.ListIndex = mintCourseBeforeIndex     '�R���{�C���f�b�N�X�����ɖ߂�
            mblnNowEdit = False                             '����������
            Exit Sub
        End If
    End If

    '�������ɂ���
    mblnNowEdit = True

    '���݂�Index��ێ�
    mintCourseBeforeIndex = cboCourse.ListIndex
    mstrCsCd = mstrRootCsCd(mintCourseBeforeIndex)

    'WEB�R�[�X�ݒ���̕ҏW
    Call EditWeb_Cs

    'WEB�R�[�X�ڍ׏��̕ҏW
    Call EditWeb_CsDetail
    
    '�R�[�X�L���_����ԃR���{�̕ҏW
    lngHistoryCount = SetCtrMng()
    
    '�I�v�V�����������̕ҏW
    Call EditOptList

    '���X�V��Ԃɏ�����
    mblnEditData = False
    mblnEditOptData = False
    mblnNowEdit = False
    
End Sub

Private Sub cboCtrMng_Click()

    Dim strMsg      As String
    Dim intRet      As Integer
    
    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    '�����R���{��������Ȃ��ꍇ�́A�����I��
    If cboCtrMng.ListCount = 1 Then Exit Sub
    
    '���݂̏�Ԃ��X�V����Ă�����A�x��
    If mblnEditOptData = True Then
        
        strMsg = "�f�[�^���X�V����Ă��܂��B�L�����ԃf�[�^���ĕ\������ƕύX���e���j������܂�" & vbLf & _
                 "��낵���ł����H"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then
            mblnNowEdit = True                         '����Loop�h�~�̂��߁A��������
            cboCtrMng.ListIndex = mintCtrMngBeforeIndex      '�R���{�C���f�b�N�X�����ɖ߂�
            mblnNowEdit = False                        '����������
            Exit Sub
        End If
    End If
    
    '�I�v�V�����������̕ҏW
    Call EditOptList

    '���݂�Index��ێ�
    mintCtrMngBeforeIndex = cboCtrMng.ListIndex

    '���X�V��Ԃɏ�����
    mblnEditOptData = False
    mblnNowEdit = False

End Sub

Private Sub cmdAddCsDetail_Click()

    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    If lsvCsDetail.ListItems.Count > 98 Then
        MsgBox "�������ڂ̐����p�ݒ�͂X�X�ȏ�ݒ肷�邱�Ƃ͂ł��܂���B", vbInformation
    End If

    With frmWeb_CsDetail
        '�v���p�e�B�Z�b�g
        .Inspect = ""
        .InsDetail = ""
                
        '�ҏW��ʕ\��
        .Show vbModal
    
        '�X�V����Ă���ꍇ�A���e�ύX
        If .Updated = True Then
            
            mintDetailMaxKey = mintDetailMaxKey + 1
            Set objItem = lsvCsDetail.ListItems.Add(, mstrListViewKey & mintDetailMaxKey, .Inspect)
            objItem.SubItems(1) = .InsDetail
            
            '�X�V��Ԃ��Ǘ�
            mblnEditData = True
        
        End If
                
    End With

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
    If ApplyData() = True Then
        MsgBox "���͓��e��ۑ����܂����B", vbInformation
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
Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdClearOption_Click()

    Dim i As Integer
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvOption.ListItems.Count
        
        '�I������Ă��鍀�ڂȂ�폜
        If lsvOption.ListItems(i).Selected = True Then
            lsvOption.ListItems(i).SubItems(1) = ""
            lsvOption.ListItems(i).SubItems(2) = ""
            lsvOption.ListItems(i).SubItems(3) = ""
        End If
    
    Next i

    '�X�V��Ԃ��Ǘ�
    mblnEditData = True
    mblnEditOptData = True

End Sub

' @(e)
'
' �@�\�@�@ : �u���ڍ폜�vClick
'
' �@�\���� : �I�����ꂽ���ڂ����X�g����폜����
'
' ���l�@�@ :
'
Private Sub cmdDeleteCsDetail_Click()

    Dim i As Integer
    
    If lsvCsDetail.ListItems.Count = 0 Then Exit Sub
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvCsDetail.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvCsDetail.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ�폜
        If lsvCsDetail.ListItems(i).Selected = True Then
            lsvCsDetail.ListItems.Remove (lsvCsDetail.ListItems(i).Key)
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
        End If
    
    Next i

    mblnEditData = True

End Sub


Private Sub cmdDownItem_Click()

    Call MoveListItem(1)

End Sub

Private Sub cmdEditCsDetail_Click()

    Dim i       As Integer
    Dim objItem As ListItem
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvCsDetail.ListItems.Count
        
        '�I������Ă��鍀�ڂȂ�\��
        If lsvCsDetail.ListItems(i).Selected = True Then
            
            Set objItem = lsvCsDetail.ListItems(i)
            
            With frmWeb_CsDetail
                '�v���p�e�B�Z�b�g
                .Inspect = objItem.Text
                .InsDetail = objItem.SubItems(1)
                
                '�ҏW��ʕ\��
                .Show vbModal
            
                '�X�V����Ă���ꍇ�A���e�ύX
                If .Updated = True Then
                    objItem.Text = .Inspect
                    objItem.SubItems(1) = .InsDetail
                End If
                
                '�X�V��Ԃ��Ǘ�
                mblnEditData = True
            
            End With
            
            '1�ҏW������\��
            Exit For
        End If
    
    Next i

End Sub

Private Sub cmdEditOpt_Click()

    Dim i       As Integer
    Dim objItem As ListItem
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvOption.ListItems.Count
        
        '�I������Ă��鍀�ڂȂ�\��
        If lsvOption.ListItems(i).Selected = True Then
            
            Set objItem = lsvOption.ListItems(i)
            
            With frmWeb_CsOpt
                '�v���p�e�B�Z�b�g
                .CtrOptName = objItem.Text
                .OptName = objItem.SubItems(1)
                .OptPurpose = objItem.SubItems(2)
                .OptDetail = objItem.SubItems(3)
                
                '�ҏW��ʕ\��
                .Show vbModal
            
                '�X�V����Ă���ꍇ�A���e�ύX
                If .Updated = True Then
                    objItem.SubItems(1) = .OptName
                    objItem.SubItems(2) = .OptPurpose
                    objItem.SubItems(3) = .OptDetail
                
                    '�X�V��Ԃ��Ǘ�
                    mblnEditData = True
                    mblnEditOptData = True
                
                End If
            
            End With
            
            '1�ҏW������\��
            Exit For
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
Private Sub cmdOk_Click()

    '�f�[�^�K�p�������s��
    If ApplyData() = False Then Exit Sub

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
        
        'WEB�R�[�X�e�[�u���̓o�^
        If RegistWeb_Cs() = False Then Exit Do

        '�X�V�ς݃t���O��TRUE��
        mblnUpdated = True
        
        '�f�[�^�X�V����t���O��������
        mblnEditData = False
        mblnEditOptData = False
        mblnModeNew = False
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Function

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
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    mblnEditData = False
    mblnEditOptData = False
    mblnModeNew = False
    tabMain.Tab = 0     '�擪�^�u��Active
    mintDetailMaxKey = 0

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        '�R�[�X�R���{�̕ҏW
        If EditCourseConbo() = False Then
            Exit Do
        End If
        
        'WEB�R�[�X�ݒ���̕ҏW
        If EditWeb_Cs() = False Then
            Exit Do
        End If
    
        'WEB�R�[�X�ڍ׏��̕ҏW
        If EditWeb_CsDetail() = False Then
            Exit Do
        End If
        
        '�R�[�X�L���_����ԃR���{�̕ҏW
        If SetCtrMng() > 0 Then
        
            '�I�v�V�����������̕ҏW
            If EditOptList() = False Then
                Exit Do
            End If
        
        End If
                
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub lsvCsDetail_DblClick()

    Call cmdEditCsDetail_Click
    
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
    Dim strEscInspect()     As String
    Dim strEscInsDetail()   As String
    
    intSelectedCount = 0

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvCsDetail.ListItems.Count

        '�I������Ă��鍀�ڂȂ�
        If lsvCsDetail.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '�I�����ڐ����P�ȊO�Ȃ珈�����Ȃ�
    If intSelectedCount <> 1 Then Exit Sub
    
    '����Up�w�肩�A�I�����ڂ��擪�Ȃ牽�����Ȃ�
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '����Down�w�肩�A�I�����ڂ��ŏI�Ȃ牽�����Ȃ�
    If (intSelectedIndex = lsvCsDetail.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    '�X�V��Ԃ��Ǘ�
    mblnEditData = True
    
    If intMovePosition = -1 Then
        '����Up�̏ꍇ�A��O�̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex - 1
    Else
        '����Down�̏ꍇ�A���݂̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex
    End If
    
    '���ݕ\����̐擪Index���擾
    intScrollPoint = lsvCsDetail.GetFirstVisible.Index
    
    '���X�g�r���[�����邭��񂵂đS���ڔz��쐬
    For i = 1 To lsvCsDetail.ListItems.Count
        ReDim Preserve strEscKey(i)
        ReDim Preserve strEscInspect(i)
        ReDim Preserve strEscInsDetail(i)
        
        '�����Ώ۔z��ԍ�������
        If intTargetIndex = i Then
        
            '���ڑޔ�
            strEscKey(i) = lsvCsDetail.ListItems(i + 1).Key
            strEscInspect(i) = lsvCsDetail.ListItems(i + 1).Text
            strEscInsDetail(i) = lsvCsDetail.ListItems(i + 1).SubItems(1)
        
            i = i + 1
        
            ReDim Preserve strEscKey(i)
            ReDim Preserve strEscInspect(i)
            ReDim Preserve strEscInsDetail(i)
        
            strEscKey(i) = lsvCsDetail.ListItems(intTargetIndex).Key
            strEscInspect(i) = lsvCsDetail.ListItems(intTargetIndex).Text
            strEscInsDetail(i) = lsvCsDetail.ListItems(intTargetIndex).SubItems(1)
        
        Else
            strEscKey(i) = lsvCsDetail.ListItems(i).Key
            strEscInspect(i) = lsvCsDetail.ListItems(i).Text
            strEscInsDetail(i) = lsvCsDetail.ListItems(i).SubItems(1)
        
        End If
    
    Next i
    
    lsvCsDetail.ListItems.Clear
    
    '�w�b�_�̕ҏW
    With lsvCsDetail.ColumnHeaders
        .Clear
        .Add , , "������", 2000, lvwColumnLeft
        .Add , , "��������", 4000, lvwColumnLeft
    End With
    
    '���X�g�̕ҏW
    For i = 1 To UBound(strEscKey)
        Set objItem = lsvCsDetail.ListItems.Add(, strEscKey(i), strEscInspect(i))
        objItem.SubItems(1) = strEscInsDetail(i)
    Next i

    lsvCsDetail.ListItems(1).Selected = False
    
    '�ړ��������ڂ�I�������A�ړ��i�X�N���[���j������
    If intMovePosition = 1 Then
        lsvCsDetail.ListItems(intTargetIndex + 1).Selected = True
'        lsvCsDetail.ListItems(intTargetIndex).EnsureVisible
    Else
        lsvCsDetail.ListItems(intTargetIndex).Selected = True
'        lsvCsDetail.ListItems(intScrollPoint + 7).EnsureVisible
    End If

    lsvCsDetail.SetFocus

End Sub

Private Sub lsvOption_DblClick()

    Call cmdEditOpt_Click
    
End Sub

Private Sub txtCsName_Change()
    
    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    mblnEditData = True
    
End Sub

Private Sub txtItemOutLine_Change()
    
    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    mblnEditData = True

End Sub

Private Sub txtOutLine_Change()
    
    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    mblnEditData = True

End Sub
