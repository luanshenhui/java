VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmRsvFra 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�\��g�e�[�u�������e�i���X"
   ClientHeight    =   7620
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6720
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRsvFra.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7620
   ScaleWidth      =   6720
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin TabDlg.SSTab tabMain 
      Height          =   6975
      Left            =   120
      TabIndex        =   41
      Top             =   120
      Width           =   6495
      _ExtentX        =   11456
      _ExtentY        =   12303
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "��{���"
      TabPicture(0)   =   "frmRsvFra.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Image1(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "LabelCourseGuide"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Frame1"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Frame3(0)"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "Frame3(1)"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).ControlCount=   5
      TabCaption(1)   =   "�g�Ǘ����鍀��"
      TabPicture(1)   =   "frmRsvFra.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraItemMain"
      Tab(1).ControlCount=   1
      Begin VB.Frame Frame3 
         Caption         =   "�g�ݒ莞�̃f�t�H���g�l��"
         Height          =   2355
         Index           =   1
         Left            =   300
         TabIndex        =   13
         Top             =   4320
         Visible         =   0   'False
         Width           =   6015
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   9
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   33
            Text            =   "Text1"
            Top             =   1800
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   8
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   29
            Text            =   "Text1"
            Top             =   1440
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   7
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   25
            Text            =   "Text1"
            Top             =   1080
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   6
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   21
            Text            =   "Text1"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   5
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   17
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   4
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   31
            Text            =   "Text1"
            Top             =   1800
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   3
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   27
            Text            =   "Text1"
            Top             =   1440
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   2
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   23
            Text            =   "Text1"
            Top             =   1080
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   1
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   19
            Text            =   "Text1"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   0
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   15
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   9
            Left            =   2340
            TabIndex        =   32
            Top             =   1860
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   8
            Left            =   2340
            TabIndex        =   28
            Top             =   1500
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   7
            Left            =   2340
            TabIndex        =   24
            Top             =   1140
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   6
            Left            =   2340
            TabIndex        =   20
            Top             =   780
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   5
            Left            =   2340
            TabIndex        =   16
            Top             =   420
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   4
            Left            =   300
            TabIndex        =   30
            Top             =   1860
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   3
            Left            =   300
            TabIndex        =   26
            Top             =   1500
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   2
            Left            =   300
            TabIndex        =   22
            Top             =   1140
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   1
            Left            =   300
            TabIndex        =   18
            Top             =   780
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "���ԑјg�P(&1):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   14
            Top             =   420
            Width           =   1395
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "�g�l���̃I�[�o�[�o�^"
         Height          =   1095
         Index           =   0
         Left            =   300
         TabIndex        =   10
         Top             =   3120
         Visible         =   0   'False
         Width           =   6015
         Begin VB.OptionButton optOverRsv 
            Caption         =   "�g�l�����z�����\�������(&T)"
            Height          =   255
            Index           =   1
            Left            =   300
            TabIndex        =   12
            Top             =   660
            Width           =   4095
         End
         Begin VB.OptionButton optOverRsv 
            Caption         =   "�g�l�����z�����\��͋����Ȃ�(&F)"
            Height          =   255
            Index           =   0
            Left            =   300
            TabIndex        =   11
            Top             =   360
            Value           =   -1  'True
            Width           =   4095
         End
      End
      Begin VB.Frame fraItemMain 
         Caption         =   "��������(&I)"
         Height          =   4395
         Left            =   -74820
         TabIndex        =   34
         Top             =   480
         Width           =   6075
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "�폜(&R)"
            Height          =   315
            Left            =   4620
            TabIndex        =   37
            Top             =   3900
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "�ǉ�(&A)..."
            Height          =   315
            Left            =   3240
            TabIndex        =   36
            Top             =   3900
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3480
            Left            =   180
            TabIndex        =   35
            Top             =   300
            Width           =   5715
            _ExtentX        =   10081
            _ExtentY        =   6138
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
      Begin VB.Frame Frame1 
         Caption         =   "��{���(&B)"
         Height          =   1935
         Left            =   300
         TabIndex        =   0
         Top             =   1080
         Width           =   6015
         Begin VB.CheckBox chkIncOpenGrp 
            Caption         =   "�I�[�v���g�\��Q���ݎ��͌����Ɋ܂߂�(&E)"
            Height          =   180
            Left            =   1680
            TabIndex        =   9
            Top             =   1500
            Width           =   3495
         End
         Begin VB.OptionButton optFraType 
            Caption         =   "�������ڗ\��g(&R)"
            Height          =   255
            Index           =   1
            Left            =   3420
            TabIndex        =   7
            Top             =   1080
            Value           =   -1  'True
            Visible         =   0   'False
            Width           =   2055
         End
         Begin VB.OptionButton optFraType 
            Caption         =   "�R�[�X�\��g(&R)"
            Height          =   255
            Index           =   0
            Left            =   1680
            TabIndex        =   6
            Top             =   1080
            Width           =   1575
         End
         Begin VB.TextBox txtRsvFraName 
            Height          =   318
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1680
            MaxLength       =   10
            TabIndex        =   4
            Text            =   "���������g�Q��"
            Top             =   660
            Width           =   2055
         End
         Begin VB.TextBox txtRsvFraCd 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   2
            Text            =   "@@@"
            Top             =   300
            Width           =   495
         End
         Begin VB.Label Label8 
            Caption         =   "�I�[�v���g(&O):"
            Height          =   195
            Index           =   1
            Left            =   240
            TabIndex        =   8
            Top             =   1500
            Width           =   1395
         End
         Begin VB.Label Label2 
            Caption         =   "�\��g��(&N):"
            Height          =   195
            Left            =   240
            TabIndex        =   3
            Top             =   720
            Width           =   1095
         End
         Begin VB.Label Label1 
            Caption         =   "�\��g�R�[�h(&C):"
            Height          =   195
            Index           =   2
            Left            =   240
            TabIndex        =   1
            Top             =   360
            Width           =   1275
         End
         Begin VB.Label Label8 
            Caption         =   "�\��g�̎��(&K):"
            Height          =   195
            Index           =   0
            Left            =   240
            TabIndex        =   5
            Top             =   1125
            Width           =   1395
         End
      End
      Begin VB.Label LabelCourseGuide 
         Caption         =   "�\����e�̎�ނɂ���Đl������������e��ݒ肵�܂��B"
         Height          =   255
         Left            =   960
         TabIndex        =   42
         Top             =   600
         Width           =   5055
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   0
         Left            =   300
         Picture         =   "frmRsvFra.frx":0044
         Top             =   480
         Width           =   480
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   3960
      TabIndex        =   39
      Top             =   7200
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2580
      TabIndex        =   38
      Top             =   7200
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   5340
      TabIndex        =   40
      Top             =   7200
      Width           =   1275
   End
End
Attribute VB_Name = "frmRsvFra"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.2.25
'�S����  �FT.Takagi@RD
'�C�����e�F�I�[�v���g�\��Q��ǉ�

Option Explicit

'�v���p�e�B�p�̈�
Private mstrRsvFraCd    As String   '�\��g�R�[�h
Private mintFraType     As Integer  '�g�Ǘ��^�C�v
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnShowOnly    As Boolean  'TRUE:�f�[�^�̍X�V�����Ȃ��i�Q�Ƃ̂݁j
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s

'���W���[���ŗL�̈�̈�
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private mstrClassCd()   As String   '�������ރR�[�h�i�z��́A�R���{�{�b�N�X�ƑΉ��j

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
' �@�\���� : �@�R�[�X�̏ꍇ�`�Ǘ�����R�[�X��ǉ�����
' �@�@�@�@ : �A�������ڂ̏ꍇ�`�Ǘ����鍀�ڂ�ǉ�����
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
    Dim vntItemName     As Variant  '�I�����ꂽ���ږ�
    
    If mintFraType = 0 Then
        
        '�g�Ǘ��^�C�v���R�[�X�Ȃ�A���X�g�r���[��̊Ǘ��A��Ǘ���ύX����
        Call ChangeItemMode(True)
    
    Else
        '�g�Ǘ��^�C�v���������ڂȂ�A�K�C�h��\������
        
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objItemGuide = New mntItemGuide.ItemGuide
        
        With objItemGuide
            .Mode = MODE_REQUEST
            .Group = GROUP_OFF
            .Item = ITEM_SHOW
            .Question = QUESTION_SHOW
        
            '�������ڃK�C�h���J��
            .Show vbModal
            
            '�߂�l�Ƃ��Ẵv���p�e�B�擾
            lngItemCount = .ItemCount
            vntItemCd = .ItemCd
            vntItemName = .ItemName
        
        End With
    
        Screen.MousePointer = vbHourglass
        Me.Refresh
            
        '�I��������0���ȏ�Ȃ�
        If lngItemCount > 0 Then
        
            '���X�g�̕ҏW
            For i = 0 To lngItemCount - 1
                
                '�˗����ڂ̏ꍇ
                strItemCdString = vntItemCd(i)
                strItemKey = mstrListViewKey & strItemCdString
                
                '���X�g��ɑ��݂��邩�`�F�b�N����
                If CheckExistsItemCd(lsvItem, strItemKey) = False Then
                
                    '�Ȃ���Βǉ�����
                    Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
                    objItem.SubItems(1) = vntItemName(i)
                
                End If
            Next i
        
        End If
    
        Set objItemGuide = Nothing
    
    End If
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
    
        
'���Ȃ�ŁI�z�񂪂���e�L�X�g�{�b�N�X�őΉ��ł��Ȃ��I
'    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������
        
    ''�e�R���g���[���̐ݒ�l���N���A����
    For Each Ctrl In Me
        
        '''�e�L�X�g�{�b�N�X
        If TypeOf Ctrl Is TextBox Then
            Ctrl.Text = Empty
            Ctrl.ToolTipText = Empty
            Ctrl.BackColor = vbWindowBackground
        
        End If
    
    Next Ctrl
    
    '�ǂݍ��ݓ��e�̕ҏW
    For i = 0 To 9
        lblDefCnt(i).Visible = False
        txtDefCnt(i).Visible = False
    Next i
    
    tabMain.Tab = 0
    optFraType(0).Value = True
    
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
Private Function EditTimeFra() As Boolean

    Dim objCommon           As Object     '�\��g���A�N�Z�X�p
    
    Dim vntArrTimeFra       As Variant
    Dim vntArrTimeFraName   As Variant

    Dim lngRet          As Long
    Dim i               As Integer
    
    EditTimeFra = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommon = CreateObject("HainsCommon.Common")
    
    Do
        
        '���Ԙg���ǂݍ���
        lngRet = objCommon.SelectTimeFraList(vntArrTimeFra, vntArrTimeFraName)

        '�ǂݍ��ݓ��e�̕ҏW
        For i = 0 To lngRet - 1
            lblDefCnt(i).Caption = CStr(vntArrTimeFraName(i))
            lblDefCnt(i).Visible = True
            txtDefCnt(i).Visible = True
        Next i
        
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditTimeFra = True
    
    Exit Function

ErrorHandle:

    EditTimeFra = False
    MsgBox Err.Description, vbCritical
    
End Function


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
Private Function EditRsvFra_p() As Boolean

    Dim objRsvFra       As Object     '�\��g���A�N�Z�X�p
    
    Dim vntRsvFraName   As Variant
    Dim vntOverRsv      As Variant
    Dim vntFraType      As Variant
    Dim vntDefCnt(9)    As Variant
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    Dim vntIncOpenGrp   As Variant  '�I�[�v���g�\��Q����
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####

    Dim Ret             As Boolean              '�߂�l
    Dim i               As Integer
    
    EditRsvFra_p = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrRsvFraCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�R�[�X�e�[�u�����R�[�h�ǂݍ���
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        If objRsvFra.SelectRsvFra(mstrRsvFraCd, _
'                                  vntRsvFraName, _
'                                  vntOverRsv, _
'                                  vntFraType, _
'                                  vntDefCnt(0), _
'                                  vntDefCnt(1), _
'                                  vntDefCnt(2), _
'                                  vntDefCnt(3), _
'                                  vntDefCnt(4), _
'                                  vntDefCnt(5), _
'                                  vntDefCnt(6), _
'                                  vntDefCnt(7), _
'                                  vntDefCnt(8), _
'                                  vntDefCnt(9)) = False Then
        If objRsvFra.SelectRsvFra(mstrRsvFraCd, _
                                  vntRsvFraName, _
                                  vntOverRsv, _
                                  vntFraType, _
                                  vntDefCnt(0), _
                                  vntDefCnt(1), _
                                  vntDefCnt(2), _
                                  vntDefCnt(3), _
                                  vntDefCnt(4), _
                                  vntDefCnt(5), _
                                  vntDefCnt(6), _
                                  vntDefCnt(7), _
                                  vntDefCnt(8), _
                                  vntDefCnt(9), _
                                  vntIncOpenGrp) = False Then
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW�i�R�[�X��{���j
        txtRsvFraCd.Text = mstrRsvFraCd
        txtRsvFraName.Text = vntRsvFraName
        mintFraType = CInt(vntFraType)
        optFraType(CInt(vntFraType)).Value = True
        optOverRsv(CInt(vntOverRsv)).Value = True
    
        For i = 0 To 9
            txtDefCnt(i).Text = CStr(vntDefCnt(i))
        Next i
        
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        chkIncOpenGrp.Value = IIf(vntIncOpenGrp > 0, vbChecked, vbUnchecked)
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditRsvFra_p = Ret
    
    Exit Function

ErrorHandle:

    EditRsvFra_p = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �\��g�Ǘ����ڕ\��
'
' �@�\���� : ���ݐݒ肳��Ă���\��g���Ǘ����ځi�R�[�Xor�������ځj��\������
'
' ���l�@�@ :
'
Private Function EditRsvFraItem() As Boolean
    
On Error GoTo ErrorHandle

    Dim objRsvFra       As Object               '�\��g�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntClassName    As Variant              '�������ޖ���
    Dim vntItemCode     As Variant              '�R�[�h
    Dim vntItemName     As Variant              '����
    Dim vntCsCd         As Variant              '�R�[�X�R�[�h
    Dim lngCount        As Long                 '���R�[�h��
    Dim strItemKey      As String               '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCodeString As String             '�\���p�L�[�ҏW�̈�
    
    Dim i               As Long                 '�C���f�b�N�X

    EditRsvFraItem = False

    '���X�g�A�C�e���N���A
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")
    
    lngCount = objRsvFra.SelectRsvFraItemList(mstrRsvFraCd, _
                                              mintFraType, _
                                              vntItemCode, _
                                              vntItemName, _
                                              vntCsCd)

    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�R�[�h", 1000, lvwColumnLeft
        If mintFraType = 0 Then
            .Add , , "�R�[�X����", 2000, lvwColumnLeft
            .Add , , "�Ǘ��Ώ�", 2000, lvwColumnLeft
        Else
            .Add , , "�������ږ���", 2000, lvwColumnLeft
        End If
    End With
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, mstrListViewKey & vntItemCode(i), vntItemCode(i))
        objItem.SubItems(1) = vntItemName(i)
        If (mintFraType = 0) And (vntCsCd(i) <> "") Then
            objItem.SubItems(2) = "�g�Ǘ��Ώ�"
        End If
    Next i
    
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    '�g�Ǘ��^�C�v�ɂ���ă{�^�����̂�ύX
    If mintFraType = 0 Then
        fraItemMain.Caption = "�Ǘ�����R�[�X"
        cmdAddItem.Caption = "�Ǘ�����(&A)"
        cmdDeleteItem.Caption = "�Ǘ����Ȃ�(&R)"
    Else
        fraItemMain.Caption = "�Ǘ����錟������"
        cmdAddItem.Caption = "�ǉ�(&A)..."
        cmdDeleteItem.Caption = "�폜(&R)"
    End If
    
    EditRsvFraItem = True
    
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
    
    If mintFraType = 0 Then
        
        '�g�Ǘ��^�C�v���R�[�X�Ȃ�A���X�g�r���[��̊Ǘ��A��Ǘ���ύX����
        Call ChangeItemMode(False)
        
    Else
        
        '�g�Ǘ��^�C�v���������ڂȂ�A�A�C�e���폜���s��
        
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
        
        '�\��g�e�[�u���̓o�^
        If RegistRsvFra() = False Then Exit Do
        
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
    Dim i               As Integer
    
    '��������
    Ret = False
    
    Do
        
        If Trim(txtRsvFraCd.Text) = "" Then
            MsgBox "�\��g�R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            txtRsvFraCd.SetFocus
            Exit Do
        End If

        If Trim(txtRsvFraName.Text) = "" Then
            MsgBox "�\��g�������͂���Ă��܂���B", vbExclamation, App.Title
            txtRsvFraName.SetFocus
            Exit Do
        End If

        For i = 0 To 9
            
            '�f�t�H���g�l���󔒂Ȃ�O�Z�b�g
            If Trim(txtDefCnt(i).Text) = "" Then
                txtDefCnt(i).Text = 0
            End If
            
            '���l�`�F�b�N
            If IsNumeric(txtDefCnt(i).Text) = False Then
                MsgBox "�f�t�H���g�l���ɂ͐��l���Z�b�g���Ă�������", vbExclamation, App.Title
                txtDefCnt(i).SetFocus
                Exit Do
            End If
                    
        Next i

        '�Ǘ����ڐ��̃`�F�b�N
        If CheckItemSelect = False Then
            MsgBox "�Ǘ����鍀�ڂ��P���o�^����Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 1
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
' �@�\�@�@ : �\��g��{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e��\��g�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistRsvFra() As Boolean

On Error GoTo ErrorHandle

    Dim objRsvFra       As Object     '�\��g�A�N�Z�X�p
    Dim lngRet          As Long
    Dim intOverRsv      As Integer
    Dim i               As Integer
    Dim j               As Integer
    Dim intItemCount    As Integer
    Dim vntItemCode()   As Variant
    
    RegistRsvFra = False
    intItemCount = 0
    Erase vntItemCode
    j = 0

    '�g�l���I�[�o�o�^�̐ݒ�
    intOverRsv = 0
    If optOverRsv(1).Value = True Then intOverRsv = 1

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        If mintFraType = 0 Then
            
            '�R�[�X�̏ꍇ�A�Ǘ��Ώۂ̂��̂̂݃Z�b�g
            If Trim(lsvItem.ListItems(i).SubItems(2)) <> "" Then
                ReDim Preserve vntItemCode(j)
                vntItemCode(j) = lsvItem.ListItems(i).Text
                j = j + 1
                intItemCount = intItemCount + 1
            End If
        
        Else
            '�������ڂ̏ꍇ�A�R�[�h�����̂܂܃Z�b�g
            ReDim Preserve vntItemCode(j)
            vntItemCode(j) = lsvItem.ListItems(i).Text
            j = j + 1
            intItemCount = intItemCount + 1
        End If
    
    Next i

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")

    '�\��g�e�[�u�����R�[�h�̓o�^
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'    lngRet = objRsvFra.RegistRsvFra_All(IIf(txtRsvFraCd.Enabled, "INS", "UPD"), _
'                                        Trim(txtRsvFraCd.Text), _
'                                        Trim(txtRsvFraName.Text), _
'                                        intOverRsv, _
'                                        mintFraType, _
'                                        Trim(txtDefCnt(0).Text), _
'                                        Trim(txtDefCnt(1).Text), _
'                                        Trim(txtDefCnt(2).Text), _
'                                        Trim(txtDefCnt(3).Text), _
'                                        Trim(txtDefCnt(4).Text), _
'                                        Trim(txtDefCnt(5).Text), _
'                                        Trim(txtDefCnt(6).Text), _
'                                        Trim(txtDefCnt(7).Text), _
'                                        Trim(txtDefCnt(8).Text), _
'                                        Trim(txtDefCnt(9).Text), _
'                                        intItemCount, _
'                                        vntItemCode)
    lngRet = objRsvFra.RegistRsvFra_All( _
        IIf(txtRsvFraCd.Enabled, "INS", "UPD"), _
        Trim(txtRsvFraCd.Text), _
        Trim(txtRsvFraName.Text), _
        intOverRsv, _
        mintFraType, _
        Trim(txtDefCnt(0).Text), _
        Trim(txtDefCnt(1).Text), _
        Trim(txtDefCnt(2).Text), _
        Trim(txtDefCnt(3).Text), _
        Trim(txtDefCnt(4).Text), _
        Trim(txtDefCnt(5).Text), _
        Trim(txtDefCnt(6).Text), _
        Trim(txtDefCnt(7).Text), _
        Trim(txtDefCnt(8).Text), _
        Trim(txtDefCnt(9).Text), _
        intItemCount, _
        vntItemCode, _
        IIf(chkIncOpenGrp.Value = vbUnchecked, 0, 1) _
    )
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "���͂��ꂽ��l�Ǘ��R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistRsvFra = False
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
        RegistRsvFra = False
        Exit Function
    End If
    
    mstrRsvFraCd = Trim(txtRsvFraCd.Text)
    txtRsvFraCd.Enabled = (txtRsvFraCd.Text = "")
    
    RegistRsvFra = True
    
    Exit Function
    
ErrorHandle:

    RegistRsvFra = False
    
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
        
        '���Ԙg���̕\���ҏW
        If EditTimeFra() = False Then
            Exit Do
        End If
        
        '�\��g���̕\���ҏW
        If EditRsvFra_p() = False Then
            Exit Do
        End If
    
        '�\��g�����ڂ̕ҏW
        If EditRsvFraItem() = False Then
            Exit Do
        End If
        
        '�C�l�[�u���ݒ�
        txtRsvFraCd.Enabled = (txtRsvFraCd.Text = "")
'        cboRsvFraDiv.Enabled = txtRsvFraCd.Enabled
        
        Ret = True
        Exit Do
    
    Loop
    
    '�Q�Ɛ�p�̏ꍇ�A�o�^�n�R���g���[�����~�߂�
    If mblnShowOnly = True Then
        LabelCourseGuide.Caption = txtRsvFraName.Text & "�̃v���p�e�B"
        
        txtRsvFraCd.Enabled = False
        txtRsvFraName.Enabled = False
        
        cmdOk.Enabled = False
        cmdApply.Enabled = False
        cmdAddItem.Enabled = False
        cmdDeleteItem.Enabled = False
    End If
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
Friend Property Get RsvFraCd() As Variant

    RsvFraCd = mstrRsvFraCd
    
End Property

Friend Property Let RsvFraCd(ByVal vNewValue As Variant)
    
    mstrRsvFraCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

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
    
    '�\��g�敪���������ڂ̏ꍇ�A�������Ȃ��i���Ԃ��߂��Ⴍ����ɂȂ邩��j
    If mintFraType = MODE_ITEM Then Exit Sub
    
    With lsvItem
        .SortKey = ColumnHeader.Index - 1
        .Sorted = True
        .SortOrder = IIf(.SortOrder = lvwAscending, lvwDescending, lvwAscending)
    End With

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

' @(e)
'
' �@�\�@�@ : �g�Ǘ��I�v�V�����{�^���N���b�N
'
' �@�\���� : �g�Ǘ���Ԃ��ύX���ꂽ�ꍇ�̑Ώ����s��
'
' ���l�@�@ :
'
Private Sub optFraType_Click(Index As Integer)

    Dim strMsg      As String
    Dim intRet      As Integer
    
    '�N���b�N���ꂽ�^�C�v�����݂̂��̂ƈقȂ�A�����ڂ��I���ς݂Ȃ烁�b�Z�[�W
    If (mintFraType <> Index) And (CheckItemSelect = True) Then
        strMsg = "���ݕ\�����Ă���g�Ǘ��^�C�v�ƈقȂ���̂��I������܂����B" & vbLf & _
                 "���ݑI������Ă��鍀�ڂ͑S�ăN���A����܂��B" & vbLf & _
                 "��낵���ł����H"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then Exit Sub
    End If

    '���݂̘g�Ǘ��^�C�v��ύX
    mintFraType = Index
    
    '�\��g�����ڂ̕ҏW
    If EditRsvFraItem() = False Then
        Exit Sub
    End If

End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X�Ǘ���Ԃ̕ύX
'
' �����@ �@: TRUE:�Ǘ�����AFALSE:�Ǘ�����͂���
'
' �@�\���� : �\��g���R�[�X���ڂ̊Ǘ���Ԃ�ύX����
'
' ���l�@�@ :
'
Private Sub ChangeItemMode(blnMode As Boolean)

    Dim i As Integer
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ珈��
        If lsvItem.ListItems(i).Selected = True Then
            If blnMode = True Then
                lsvItem.ListItems(i).SubItems(2) = "�g�Ǘ��Ώ�"
            Else
                lsvItem.ListItems(i).SubItems(2) = ""
            End If
        End If
    
    Next i

End Sub

' @(e)
'
' �@�\�@�@ : �Ǘ����ڗL���`�F�b�N
'
' �߂�l�@ : TRUE:����AFALSE:�Ȃ�
'
' �@�\���� : �\��g���̊Ǘ����ڂ����[�U���o�^�ς݂��ǂ����`�F�b�N����
'
' ���l�@�@ :
'
Private Function CheckItemSelect() As Boolean

    Dim i As Integer

    CheckItemSelect = False

    If mintFraType = FRA_TYPE_ITEM Then
        
        '���݂̃��[�h���������ژg�Ȃ烊�X�g�r���[�̍��ڐ����`�F�b�N
        If lsvItem.ListItems.Count > 0 Then CheckItemSelect = True
    
    Else
        
        '���݂̃��[�h���R�[�X�g�̏ꍇ�A���X�g�r���[�̊Ǘ���Ԃ��`�F�b�N
    
        '���X�g�r���[�����邭���
        For i = 1 To lsvItem.ListItems.Count
            
            '�C���f�b�N�X�����X�g���ڂ��z������I��
            If i > lsvItem.ListItems.Count Then Exit For
            
            '�I������Ă��鍀�ڂȂ珈��
            If lsvItem.ListItems(i).SubItems(2) <> "" Then
                CheckItemSelect = True
                Exit For
            End If
        Next i
    End If
    
End Function

