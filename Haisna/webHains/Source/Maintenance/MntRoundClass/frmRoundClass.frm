VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmRoundClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�܂�ߕ��ރe�[�u�������e�i���X"
   ClientHeight    =   6270
   ClientLeft      =   1605
   ClientTop       =   1545
   ClientWidth     =   6345
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRoundClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6270
   ScaleWidth      =   6345
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtRoundClassName 
      Height          =   318
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1740
      MaxLength       =   25
      TabIndex        =   3
      Text            =   "�l�ԃh�b�N"
      Top             =   540
      Width           =   4335
   End
   Begin VB.TextBox txtRoundClassCd 
      Height          =   315
      IMEMode         =   3  '�̌Œ�
      Left            =   1740
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "123"
      Top             =   180
      Width           =   555
   End
   Begin VB.Frame Frame1 
      Caption         =   "�ݒ肵���l(&I)"
      Height          =   4335
      Left            =   180
      TabIndex        =   10
      Top             =   960
      Width           =   5955
      Begin VB.CommandButton cmdEditItem 
         Caption         =   "�ҏW(&E)..."
         Height          =   315
         Index           =   0
         Left            =   3060
         TabIndex        =   8
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "�ǉ�(&A)..."
         Height          =   315
         Index           =   0
         Left            =   1680
         TabIndex        =   7
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "�폜(&D)"
         Height          =   315
         Index           =   0
         Left            =   4440
         TabIndex        =   9
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdDownItem 
         Caption         =   "��"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9.75
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   0
         Left            =   180
         TabIndex        =   5
         Top             =   1980
         Width           =   435
      End
      Begin VB.CommandButton cmdUpItem 
         Caption         =   "��"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9.75
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   0
         Left            =   180
         TabIndex        =   4
         Top             =   1380
         Width           =   435
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   3495
         Index           =   0
         Left            =   720
         TabIndex        =   6
         Top             =   240
         Width           =   4995
         _ExtentX        =   8811
         _ExtentY        =   6165
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
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
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3480
      TabIndex        =   11
      Top             =   5820
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4920
      TabIndex        =   12
      Top             =   5820
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   300
      Top             =   5580
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
            Picture         =   "frmRoundClass.frx":000C
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmRoundClass.frx":045E
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmRoundClass.frx":08B0
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmRoundClass.frx":0A0A
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Label Label2 
      Caption         =   "�܂�ߕ��ޖ�(&N):"
      Height          =   195
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   600
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "�܂�ߕ��ރR�[�h(&C):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   240
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "���N��͈͂��d�������ꍇ�A�ォ�珇�ɓK�p����܂�"
      Height          =   195
      Left            =   240
      TabIndex        =   13
      Top             =   5460
      Width           =   5955
   End
End
Attribute VB_Name = "frmRoundClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrRoundClassCd              As String           '�܂�ߕ��ރR�[�h

Private mblnInitialize          As Boolean          'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����

Private mintUniqueKey           As Long             '���X�g�r���[��ӃL�[�Ǘ��p�ԍ�
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:�܂�ߕ��ދ��z�Ǘ������X�V����AFALSE:�܂�ߕ��ދ��z�Ǘ������X�V�Ȃ�
Private mblnItemUpdated         As Boolean          'TRUE:�܂�ߕ��ދ��z�Ǘ��ڍ׍X�V����AFALSE:�܂�ߕ��ދ��z�Ǘ��ڍ׍X�V�Ȃ�

Private mintBeforeIndex         As Integer          '�����R���{�ύX�L�����Z���p�̑OIndex
Private mblnNowEdit             As Boolean          'TRUE:�ҏW�������AFALSE:�����Ȃ�

Private mcolRoundClassPrice_Record As Collection       '�܂�ߕ��ދ��z�Ǘ����R�[�h�̃R���N�V����

Friend Property Let RoundClassCd(ByVal vntNewValue As Variant)

    mstrRoundClassCd = vntNewValue
    
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
    Dim strMsg      As String
    Dim intRet      As Integer

    Ret = False
    
    Do
        
        '���̃e�[�u�������e�i���X�ł͓��Ƀ`�F�b�N�͕K�v�Ȃ�
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

'
' �@�\�@�@ : �܂�ߕ��ދ��z�Ǘ��ڍ׏��̎擾
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function GetRoundClassInfo() As Boolean

    Dim objRoundClass           As Object       '�܂�ߕ��ދ��z�Ǘ��Ǘ��A�N�Z�X�p
    
    Dim vntRoundClassName       As Variant      '�܂�ߕ��ޖ�
    Dim vntSeq                  As Variant      'SEQ
    Dim vntStrCount             As Variant      '�J�n�N��
    Dim vntEndCount             As Variant      '�I���N��
    Dim vntBsdPrice             As Variant      '�c�̕��S���z
    Dim vntIsrPrice             As Variant      '���ە��S���z
    
    Dim lngCount                As Long         '���R�[�h��
    Dim i                       As Integer
    Dim Ret                     As Boolean      '�߂�l
    
    Dim objRoundClass_Record  As RoundClassPrice_Record    '�܂�ߕ��ދ��z�Ǘ����R�[�h�I�u�W�F�N�g
    
    On Error GoTo ErrorHandle
        
    '�R���N�V�����N���A
    Set mcolRoundClassPrice_Record = Nothing
    Set mcolRoundClassPrice_Record = New Collection

    Do
        '�܂�ߕ��ރR�[�h���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrRoundClassCd = "" Then
            Ret = True
            Exit Do
        End If
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")
        
        '�܂�ߕ��ރe�[�u�����R�[�h�ǂݍ���
        If objRoundClass.SelectRoundClass(mstrRoundClassCd, vntRoundClassName) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
        
        txtRoundClassCd.Text = mstrRoundClassCd
        txtRoundClassName.Text = vntRoundClassName
        
        '�܂�ߕ��ދ��z�Ǘ��e�[�u�����R�[�h�ǂݍ���
        lngCount = objRoundClass.SelectRoundClassPriceList(mstrRoundClassCd, _
                                                           vntSeq, _
                                                           vntStrCount, _
                                                           vntEndCount, _
                                                           vntBsdPrice, _
                                                           vntIsrPrice)
        
        '0���ł��s�v�c�Ȃ�
        If lngCount = 0 Then
            Ret = True
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW
        For i = 0 To lngCount - 1
            
            '�ǂݍ��ݓ��e���I�u�W�F�N�g�ɃZ�b�g
            Set objRoundClass_Record = New RoundClassPrice_Record
            With objRoundClass_Record
                .Key = KEY_PREFIX & vntSeq(i)
                .Seq = vntSeq(i)
                .StrCount = vntStrCount(i)
                .EndCount = vntEndCount(i)
                .BsdPrice = vntBsdPrice(i)
                .IsrPrice = vntIsrPrice(i)
            End With
            
            '�R���N�V�����ɒǉ�
            mcolRoundClassPrice_Record.Add objRoundClass_Record, KEY_PREFIX & vntSeq(i)
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objRoundClass = Nothing
    
    '�߂�l�̐ݒ�
    GetRoundClassInfo = Ret
    
    Exit Function

ErrorHandle:

    GetRoundClassInfo = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' �@�\�@�@ : �܂�ߕ��ދ��z�Ǘ����̕\���i�R���N�V��������j
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem                 As ListItem                 '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntCsCd                 As Variant                  '�R�[�X�R�[�h
    Dim vntCsName               As Variant                  '�R�[�X��
    Dim lngCount                As Long                     '���R�[�h��
    Dim i                       As Long                     '�C���f�b�N�X
    Dim objRoundClass_Record    As RoundClassPrice_Record   '�܂�ߕ��ދ��z�Ǘ����R�[�h�I�u�W�F�N�g
    
    EditListViewFromCollection = False

    '���X�g�r���[�p�w�b�_����
    For i = 0 To 0
        Call EditListViewHeader(CInt(i))
    Next i
    
    '���X�g�r���[�p���j�[�N�L�[������
    mintUniqueKey = 1
    
    '���X�g�̕ҏW
    For Each objRoundClass_Record In mcolRoundClassPrice_Record
        With objRoundClass_Record
            
            '���X�g�r���[�̔z��͖�������0
            i = 0
        
            Set objItem = lsvItem(i).ListItems.Add(, .Key, .StrCount, , "DEFAULTLIST")
            objItem.SubItems(1) = .EndCount
            objItem.SubItems(2) = .BsdPrice
            objItem.SubItems(3) = .IsrPrice
        
        End With
        mintUniqueKey = mintUniqueKey + 1
    
    Next objRoundClass_Record
    
    '�I�u�W�F�N�g�p��
    Set objRoundClass_Record = Nothing
    
    EditListViewFromCollection = True
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
Private Function RegistRoundClass() As Boolean

On Error GoTo ErrorHandle

    Dim objRoundClass           As Object       '�܂�ߕ��ދ��z�Ǘ��Ǘ��A�N�Z�X�p
    Dim Ret                     As Long
    
    '�V�K�o�^���̑ޔ�p
    Dim blnNewRecordFlg         As Boolean
    Dim strEscRoundClassCd      As String
    Dim strEscSuffix            As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscCsCd              As String

    '�܂�ߕ��ދ��z�Ǘ�
    Dim lngRoundClassPriceMngCd As Long

    '�܂�ߕ��ދ��z�Ǘ��̔z��֘A
    Dim intItemCount            As Integer
    Dim vntSeq                  As Variant
    Dim vntStrCount             As Variant
    Dim vntEndCount             As Variant
    Dim vntBsdPrice             As Variant
    Dim vntIsrPrice             As Variant
    
    Dim blnBeforeUpdatePoint    As Boolean      'TRUE:�X�V�O�AFALSE:�X�V�O�ł͂Ȃ�
    
    blnBeforeUpdatePoint = False
    
    '�܂�ߕ��ދ��z�Ǘ��ڍ׃e�[�u���̔z��Z�b�g
    Call EditArrayForUpdate(intItemCount, _
                            vntSeq, _
                            vntStrCount, _
                            vntEndCount, _
                            vntBsdPrice, _
                            vntIsrPrice)
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")

    blnBeforeUpdatePoint = True

    '�܂�ߕ��ދ��z�Ǘ��f�[�^�̓o�^
    Ret = objRoundClass.RegistRoundClass_All(IIf(txtRoundClassCd.Enabled, "INS", "UPD"), _
                                             txtRoundClassCd.Text, _
                                             txtRoundClassName.Text, _
                                             intItemCount, _
                                             vntSeq, _
                                             vntStrCount, _
                                             vntEndCount, _
                                             vntBsdPrice, _
                                             vntIsrPrice)
    
    blnBeforeUpdatePoint = False
    
    If Ret = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
        RegistRoundClass = False
        Exit Function
    End If
    
    '�X�V�ς݃t���O��������
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    RegistRoundClass = True
    
    Exit Function
    
ErrorHandle:

    RegistRoundClass = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : ���X�g�r���[�f�[�^�̔z��Z�b�g
'
' �����@�@ : (Out)   intItemCount        ���ڐ�
' �@�@�@�@   (Out)   vntSeq              Seq
' �@�@�@�@   (Out)   vntStrCount           �J�n�N��
' �@�@�@�@   (Out)   vntEndCount           �I���N��
' �@�@�@�@   (Out)   vntBsdPrice         �c�̕��S��
' �@�@�@�@   (Out)   vntIsrPrice         ���ە��S��
'
' �@�\���� : ���X�g�r���[��̃f�[�^��DB�i�[�p�Ƃ���Variant�z��ɕҏW����
'
' ���l�@�@ :
'
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                               vntSeq As Variant, _
                               vntStrCount As Variant, _
                               vntEndCount As Variant, _
                               vntBsdPrice As Variant, _
                               vntIsrPrice As Variant)

    Dim vntArrExistsIsr()       As Variant
    Dim vntArrSeq()             As Variant
    Dim vntArrStrCount()        As Variant
    Dim vntArrEndCount()        As Variant
    Dim vntArrbsdPrice()        As Variant
    Dim vntArrisrPrice()        As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim intSeqCount             As Integer
    Dim obTargetListView        As ListView

    intArrCount = 0

    '���X�g�r���[�̒��g���Z�b�g
    '�i�{���̓��X�g�r���[��z��ɂ���K�v�͑S���Ȃ����A�����I�Ɍ��ۑΉ�������ꂽ�ꍇ�̕ی��j
    For intListViewIndex = 0 To 0
    
        intSeqCount = 1
        Set obTargetListView = lsvItem(intListViewIndex)
    
        '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrSeq(intArrCount)
            ReDim Preserve vntArrStrCount(intArrCount)
            ReDim Preserve vntArrEndCount(intArrCount)
            ReDim Preserve vntArrbsdPrice(intArrCount)
            ReDim Preserve vntArrisrPrice(intArrCount)
    
            With obTargetListView.ListItems(i)
                
                vntArrSeq(intArrCount) = intSeqCount
                vntArrStrCount(intArrCount) = .Text
                vntArrEndCount(intArrCount) = .SubItems(1)
                vntArrbsdPrice(intArrCount) = .SubItems(2)
                vntArrisrPrice(intArrCount) = .SubItems(3)
            
            End With
            
            intArrCount = intArrCount + 1
            intSeqCount = intSeqCount + 1
            
        Next i
    
    Next intListViewIndex

    vntSeq = vntArrSeq
    vntStrCount = vntArrStrCount
    vntEndCount = vntArrEndCount
    vntBsdPrice = vntArrbsdPrice
    vntIsrPrice = vntArrisrPrice

    intItemCount = intArrCount

End Sub

Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrCount           As String           '�J�n�N��
    Dim strEndCount           As String           '�I���N��
    Dim strbsdPrice         As String           '�c�̕��S��
    Dim strisrPrice         As String           '���ە��S��
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ō��ۗL����I��
    Set obTargetListView = lsvItem(Index)

    With frmRoundClassPrice
        
        '�K�C�h�ɑ΂���v���p�e�B�Z�b�g
        .StrCount = "0"
        .EndCount = "999.99"
        .BsdPrice = "0"
        .IsrPrice = "0"
    
        .Show vbModal
    
        If .Updated = True Then
            
            strStrCount = .StrCount
            strEndCount = .EndCount
            strbsdPrice = .BsdPrice
            strisrPrice = .IsrPrice
            
            '�X�V����Ă���Ȃ�A���X�g�r���[�ɒǉ�
            Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrCount, , "DEFAULTLIST")
            objItem.SubItems(1) = strEndCount
            objItem.SubItems(2) = strbsdPrice
            objItem.SubItems(3) = strisrPrice
        
            mintUniqueKey = mintUniqueKey + 1
            
            '�܂�ߕ��ދ��z�Ǘ��ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
    End With
    
    '�I�u�W�F�N�g�̔p��
    Set frmRoundClassPrice = Nothing
    
End Sub

Private Function ApplyData(blnOkMode As Boolean) As Boolean

    ApplyData = False
    
    '���̓`�F�b�N
    If CheckValue() = False Then
        Exit Function
    End If
    
    '�܂�ߕ��ދ��z�Ǘ��Ǘ��e�[�u���̓o�^
    If RegistRoundClass() = False Then
        Exit Function
    End If
    
    '�X�V�ς݃t���O��TRUE��
    mblnUpdated = True
        
    'OK�{�^���������͂����ŏI��
    If blnOkMode = True Then
        ApplyData = True
        Exit Function
    End If

    ApplyData = True

End Function

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

Private Sub cmdDeleteItem_Click(Index As Integer)

    Dim i                   As Integer
    Dim obTargetListView    As ListView
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set obTargetListView = lsvItem(Index)
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To obTargetListView.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > obTargetListView.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ�폜
        If obTargetListView.ListItems(i).Selected = True Then
            obTargetListView.ListItems.Remove (obTargetListView.ListItems(i).Key)
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
            '�܂�ߕ��ދ��z�Ǘ��ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
    
    Next i

End Sub

Private Sub cmdDownItem_Click(Index As Integer)
    
    Call MoveListItem(1, Index)

End Sub

Private Sub cmdEditItem_Click(Index As Integer)

    Dim i                       As Integer
    Dim strTargetKey            As String
    Dim strTargetDiv            As String
    Dim strTargetCd             As String
    Dim obTargetListView        As ListView
    
    Dim intSelectedIndex        As Integer
    Dim intSelectedCount        As Integer
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ō��ۗL����I��
    Set obTargetListView = lsvItem(Index)
    
    '���X�g�r���[��̑I�����ڐ����J�E���g
    intSelectedIndex = 0
    intSelectedCount = 0
    With obTargetListView
        For i = 1 To .ListItems.Count
            If .ListItems(i).Selected = True Then
                intSelectedIndex = i
                intSelectedCount = intSelectedCount + 1
            End If
        Next i
    End With
    
    '�����I������Ă��Ȃ��Ȃ珈���I��
    If intSelectedCount = 0 Then Exit Sub
    
    '�����I����ԂȂ�G���[
    If intSelectedCount > 1 Then
        MsgBox "���ڂ������I������Ă��܂��B�����C������ꍇ�́A������I�����Ă��������B", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    With frmRoundClassPrice
        
        '�K�C�h�ɑ΂���v���p�e�B�Z�b�g
        .StrCount = obTargetListView.ListItems(intSelectedIndex).Text
        .EndCount = obTargetListView.ListItems(intSelectedIndex).SubItems(1)
        .BsdPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(2)
        .IsrPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(3)
    
        .Show vbModal
    
        If .Updated = True Then
            
            obTargetListView.ListItems(intSelectedIndex).Text = .StrCount
            obTargetListView.ListItems(intSelectedIndex).SubItems(1) = .EndCount
            obTargetListView.ListItems(intSelectedIndex).SubItems(2) = .BsdPrice
            obTargetListView.ListItems(intSelectedIndex).SubItems(3) = .IsrPrice
                
            '�܂�ߕ��ދ��z�Ǘ��ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
    End With

    '�I�u�W�F�N�g�̔p��
    Set frmRoundClassPrice = Nothing

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

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�f�[�^�̕ۑ�
    If ApplyData(True) = True Then
        '��ʂ����
        Unload Me
    End If
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub cmdUpItem_Click(Index As Integer)

    Call MoveListItem(-1, Index)
    
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
    Dim i   As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    mblnItemUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
    
        '�܂�ߕ��ޏ��̎擾
        If GetRoundClassInfo() = False Then Exit Do
        
        '�܂�ߕ��ދ��z�Ǘ����̃��X�g�r���[�i�[
        If EditListViewFromCollection() = False Then Exit Do
        
        Ret = True
        Exit Do
    Loop

    txtRoundClassCd.Enabled = (Trim(txtRoundClassCd.Text) = "")

    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
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
Private Sub MoveListItem(intMovePosition As Integer, intListViewIndex As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim objItem             As ListItem
    
    Dim intSelectedCount    As Integer      '���ݑI������Ă��鍀�ڐ�
    Dim intSelectedIndex    As Integer      '���ݑI������Ă���s
    Dim intTargetIndex      As Integer      '+-�ő������������Ώۍs
    
    Dim intScrollPoint      As Integer
    
    Dim strEscField()       As String       '���X�g�r���[�̍��ڂ�ޔ����邽�߂̂Q�����z��
    Dim intEscFieldCount    As Integer      '���X�g�r���[�P�s�̃T�u�A�C�e����
    
    Dim obTargetListView    As ListView
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set obTargetListView = lsvItem(intListViewIndex)
    
    intSelectedCount = 0

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To obTargetListView.ListItems.Count

        '�I������Ă��鍀�ڂȂ�
        If obTargetListView.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '�I�����ڐ����P�ȊO�Ȃ珈�����Ȃ�
    If intSelectedCount = 0 Then Exit Sub
    
    '�I�����ڐ����P�ȏ�Ȃ狃�����b�Z�[�W
    If intSelectedCount > 1 Then
        MsgBox "�����I���������ڂ̗D�揇�ʕύX�͂ł��܂���B", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    '����Up�w�肩�A�I�����ڂ��擪�Ȃ牽�����Ȃ�
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '����Down�w�肩�A�I�����ڂ��ŏI�Ȃ牽�����Ȃ�
    If (intSelectedIndex = obTargetListView.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '����Up�̏ꍇ�A��O�̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex - 1
    Else
        '����Down�̏ꍇ�A���݂̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex
    End If
    
    '���ݕ\����̐擪Index���擾
    intScrollPoint = obTargetListView.GetFirstVisible.Index
    
    '���X�g�r���[�����邭��񂵂đS���ڔz��쐬
    For i = 1 To obTargetListView.ListItems.Count
        
        '�T�u�A�C�e���̐����擾
        intEscFieldCount = obTargetListView.ListItems(i).ListSubItems.Count
'        intEscFieldCount = obTargetListView.ListItems(i).ListSubItems.Count + 2
        
        '�T�u�A�C�e���{�L�[�{�e�L�X�g�A�s���Ŕz��g��
        ReDim Preserve strEscField(intEscFieldCount + 2, i)
'        ReDim Preserve strEscField(intEscFieldCount, i)
        
        '�����Ώ۔z��ԍ�������
        If intTargetIndex = i Then
        
            '���ڑޔ�
            strEscField(0, i) = obTargetListView.ListItems(i + 1).Key
            strEscField(1, i) = obTargetListView.ListItems(i + 1)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(i + 1).SubItems(j)
            Next j
        
            i = i + 1
        
            '�T�u�A�C�e���{�L�[�{�e�L�X�g�A�s���Ŕz��g��
'            ReDim Preserve strEscField(10, i)
            ReDim Preserve strEscField(intEscFieldCount + 2, i)
        
            strEscField(0, i) = obTargetListView.ListItems(intTargetIndex).Key
            strEscField(1, i) = obTargetListView.ListItems(intTargetIndex)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(intTargetIndex).SubItems(j)
            Next j
        
        Else
            strEscField(0, i) = obTargetListView.ListItems(i).Key
            strEscField(1, i) = obTargetListView.ListItems(i)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(i).SubItems(j)
            Next j
        
        End If
    
    Next i
    
    '���X�g�r���[�p�w�b�_����
    Call EditListViewHeader(intListViewIndex)
    
    '���X�g�̕ҏW
    For i = 1 To UBound(strEscField, 2)
        Set objItem = obTargetListView.ListItems.Add(, strEscField(0, i), strEscField(1, i), , "DEFAULTLIST")
        For j = 1 To intEscFieldCount
            objItem.SubItems(j) = strEscField(j + 1, i)
        Next j
    Next i

    obTargetListView.ListItems(1).Selected = False
    
    '�ړ��������ڂ�I�������A�ړ��i�X�N���[���j������
    If intMovePosition = 1 Then
        obTargetListView.ListItems(intTargetIndex + 1).Selected = True
    Else
        obTargetListView.ListItems(intTargetIndex).Selected = True
    End If

    '�I������Ă��鍀�ڂ�\������
    obTargetListView.SelectedItem.EnsureVisible

    obTargetListView.SetFocus

End Sub

Private Sub lsvItem_DblClick(Index As Integer)

    Call cmdEditItem_Click(Index)

End Sub

Private Sub lsvItem_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem(Index).ListItems.Count
            lsvItem(Index).ListItems(i).Selected = True
        Next i
    End If

End Sub

Private Sub EditListViewHeader(intListViewIndex As Integer)
    
    Dim objHeader           As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objTargetListView   As ListView
    
    Set objTargetListView = lsvItem(intListViewIndex)
    objTargetListView.ListItems.Clear
    Set objHeader = objTargetListView.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�J�n��", 1000, lvwColumnLeft
        .Add , , "�I����", 1000, lvwColumnLeft
        .Add , , "�c�̕��S���z", 1300, lvwColumnRight
        .Add , , "���ە��S���z", 1300, lvwColumnRight
    End With
    objTargetListView.View = lvwReport

End Sub
