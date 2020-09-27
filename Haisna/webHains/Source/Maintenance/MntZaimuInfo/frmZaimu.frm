VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmZaimu 
   Caption         =   "�����A�g��񃁃��e�i���X"
   ClientHeight    =   6285
   ClientLeft      =   270
   ClientTop       =   1170
   ClientWidth     =   11055
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmZaimu.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6285
   ScaleWidth      =   11055
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame1 
      Caption         =   "����"
      Height          =   795
      Left            =   120
      TabIndex        =   9
      Top             =   540
      Width           =   10755
      Begin VB.CommandButton cmdClear 
         Caption         =   "���ߏ��N���A(&R)"
         Height          =   375
         Left            =   8580
         Picture         =   "frmZaimu.frx":000C
         TabIndex        =   13
         Top             =   300
         Width           =   2055
      End
      Begin VB.CommandButton cmdSendZaimuData 
         Caption         =   "�����f�[�^���M(&S)"
         Height          =   375
         Left            =   4380
         TabIndex        =   12
         Top             =   300
         Width           =   2055
      End
      Begin VB.CommandButton cmdPrint 
         Caption         =   "����������(&P)"
         Height          =   375
         Left            =   2280
         Picture         =   "frmZaimu.frx":010E
         TabIndex        =   11
         Top             =   300
         Width           =   2055
      End
      Begin VB.CommandButton cmdCreateZaimu 
         Caption         =   "�����A�g�f�[�^�쐬(&C)"
         Height          =   375
         Left            =   180
         TabIndex        =   10
         Top             =   300
         Width           =   2055
      End
      Begin VB.Label lblSendLamp 
         Caption         =   "�������M�ł�"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   195
         Left            =   6540
         TabIndex        =   14
         Top             =   420
         Width           =   1455
      End
   End
   Begin VB.Frame fraMain 
      Caption         =   "���x���e"
      Height          =   4335
      Left            =   120
      TabIndex        =   0
      Top             =   1440
      Width           =   10815
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "�ǉ�(&A)..."
         Height          =   315
         Left            =   6540
         TabIndex        =   2
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "�폜(&R)"
         Height          =   315
         Left            =   9300
         TabIndex        =   3
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdEdit 
         Caption         =   "�ҏW(&E)"
         Height          =   315
         Left            =   7920
         TabIndex        =   4
         Top             =   3840
         Width           =   1275
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   3495
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   10515
         _ExtentX        =   18547
         _ExtentY        =   6165
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
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   8100
      TabIndex        =   5
      Top             =   5880
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   9540
      TabIndex        =   6
      Top             =   5880
      Width           =   1335
   End
   Begin VB.Label lblMode 
      Caption         =   "Label1"
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
      TabIndex        =   8
      Top             =   180
      Width           =   1755
   End
   Begin VB.Label lblFileName 
      Caption         =   "2002�N4��1���̎��x�f�[�^�ł��B"
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
      TabIndex        =   7
      Top             =   180
      Width           =   2895
   End
End
Attribute VB_Name = "frmZaimu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrZaimuDate           As String       '�����A�g���t
Private mblnInitialize          As Boolean      'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean      'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private Const KEY_PREFIX        As String = "K" '�R���N�V�����p�L�[�v���t�B�b�N�X

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����
Private mcolZaimuInfoCollection As Collection   '�����f�[�^�R���N�V����
Private mcolTekiyouCollection   As Collection   '�K�p�R�[�h�̃R���N�V����
Private mintListViewIndex       As Integer

Friend Property Let ZaimuDate(ByVal vntNewValue As Variant)

    mstrZaimuDate = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

'
' �@�\�@�@ : �f�[�^�\���p�ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu        As Object           '�����A�g�A�N�Z�X�p
    Dim lngFileCount    As Long
    Dim i               As Integer
    
    Dim vntSysCd        As Variant
    Dim vntYY           As Variant
    Dim vntMMDD         As Variant
    Dim vntOrgCd        As Variant
    Dim vntOrgName      As Variant
    Dim vntTekiyouCd    As Variant
    Dim vntTekiyouName  As Variant
    Dim vntPrice        As Variant
    Dim vntKubun        As Variant
    Dim vntShubetsu     As Variant
    Dim vntTaxPrice     As Variant
    Dim vntTax          As Variant
    Dim vntCsCd         As Variant
    Dim vntKanendo      As Variant
'### 2002.05.14 Added by Ishihara@FSIT ���M�ς݂��ǂ����̕\�����s��
    Dim blnAlreadySend  As Boolean
'### 2002.05.14 Added End
    
    Dim vntSyubetsu_NIP As Variant
    Dim vntTekiyou_NIP  As Variant
    Dim vntCount_NIP    As Variant
    Dim vntShunou_NIP   As Variant

    Dim lngRecordCount  As Long
    Dim objZaimuCsv     As ZaimuCsv
    
    EditZaimu = False
    
    '���X�g�r���[�N���A
    lsvItem.ListItems.Clear
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    Do
        '���t���w�肳��Ă��Ȃ��ꍇ�̓G���[
        If mstrZaimuDate = "" Then
            MsgBox "�����A�g���t���w�肳��Ă��܂���B", vbCritical, App.Title
            Exit Do
        End If
        
        '�����A�g���ǂݍ���
'### 2002.05.14 Modified by Ishihara@FSIT ���M�ς݂��ǂ����̕\�����s��
'        lngFileCount = objZaimu.SelectZaimuCsv(mstrZaimuDate, _
                                               , _
                                               vntSysCd, _
                                               vntYY, _
                                               vntMMDD, _
                                               vntOrgCd, _
                                               vntOrgName, _
                                               vntTekiyouCd, _
                                               vntTekiyouName, _
                                               vntPrice, _
                                               vntKubun, _
                                               vntShubetsu, _
                                               vntTaxPrice, _
                                               vntTax, _
                                               vntCsCd, _
                                               vntKanendo, _
                                               vntSyubetsu_NIP, _
                                               vntTekiyou_NIP, _
                                               vntCount_NIP, _
                                               lngRecordCount)
        blnAlreadySend = False
        lngFileCount = objZaimu.SelectZaimuCsv(mstrZaimuDate, _
                                               , _
                                               vntSysCd, _
                                               vntYY, _
                                               vntMMDD, _
                                               vntOrgCd, _
                                               vntOrgName, _
                                               vntTekiyouCd, _
                                               vntTekiyouName, _
                                               vntPrice, _
                                               vntKubun, _
                                               vntShubetsu, _
                                               vntTaxPrice, _
                                               vntTax, _
                                               vntCsCd, _
                                               vntKanendo, _
                                               vntSyubetsu_NIP, _
                                               vntTekiyou_NIP, _
                                               vntCount_NIP, _
                                               lngRecordCount, _
                                               blnAlreadySend)
'### 2002.05.14 Modified End
        
        If lngFileCount = -1 Then
            MsgBox "�����A�g�t�@�C���ǂݍ��ݎ��ɒv���I�ȃG���[���������܂����B", vbCritical, App.Title
            Exit Do
        End If
    
        If lngFileCount = 0 Then
            lblMode.Caption = "�i�V�K���[�h�j"
            EditZaimu = True
            Exit Do
        End If
    
        If lngRecordCount > 0 Then
        
            '���X�g�̕ҏW
            For i = 0 To lngRecordCount - 1
                
                '�R���N�V�����쐬
                Set objZaimuCsv = New ZaimuCsv
                With objZaimuCsv
                    .SysCd = vntSysCd(i)
                    .ZaimuYY = vntYY(i)
                    .ZaimuMMDD = vntMMDD(i)
                    .OrgCd = vntOrgCd(i)
                    .OrgName = vntOrgName(i)
                    .TekiyouCd = vntTekiyouCd(i)
                    .TekiyouName = vntTekiyouName(i)
                    .Price = vntPrice(i)
                    .Kubun = vntKubun(i)
                    .Shubetsu = vntShubetsu(i)
                    .TaxPrice = vntTaxPrice(i)
                    .Tax = vntTax(i)
                    .CsCd = vntCsCd(i)
                    .Kanendo = vntKanendo(i)
                    .Syubetsu_NIP = vntSyubetsu_NIP(i)
                    .Tekiyou_NIP = vntTekiyou_NIP(i)
                    .Count_NIP = vntCount_NIP(i)
                End With
                mcolZaimuInfoCollection.Add objZaimuCsv, KEY_PREFIX & mintListViewIndex
                
                '���X�g�r���[�ɃI�u�W�F�N�g����Z�b�g
                Call SetObjectToListView(objZaimuCsv, "")
                
                Set objZaimuCsv = Nothing
                
            Next i
        
            lblMode.Caption = "�i�X�V���[�h�j"
        
'### 2002.05.14 Added by Ishihara@FSIT ���M�ς݂��ǂ����̕\�����s��
            If blnAlreadySend = True Then
                lblSendLamp.Caption = "�����M�ς݂ł��B"
                lblSendLamp.ForeColor = vbBlack
            End If
'### 2002.05.14 Added End
        End If
    
        Exit Do
    Loop
    
'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing�ǉ�
    Set objZaimu = Nothing
'### 2002.05.08 Added End
    
    '�߂�l�̐ݒ�
    EditZaimu = True
    
    Exit Function

ErrorHandle:

    EditZaimu = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub SetObjectToListView(objZaimuCsv As ZaimuCsv, strListItemKey As String)

    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g

    '�I�u�W�F�N�g���烊�X�g�r���[�ɃZ�b�g
    With objZaimuCsv
        
        
        If strListItemKey <> "" Then
            '�X�V���[�h
            Set objItem = lsvItem.ListItems(strListItemKey)
            objItem.Text = .OrgCd
        Else
            '�}�����[�h
            Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & mintListViewIndex, .OrgCd)
            
            '���X�g�r���[�p���j�[�N�C���f�b�N�X���C���N�������g
            mintListViewIndex = mintListViewIndex + 1
        
        End If
    
        objItem.SubItems(1) = .OrgName
        objItem.SubItems(2) = .TekiyouCd
        objItem.SubItems(3) = .TekiyouName
        objItem.SubItems(4) = .CsCd
        
        Select Case .Kubun
            Case 1
                objItem.SubItems(5) = "�����l"
            Case 2
                objItem.SubItems(5) = "�c�̐���"
            Case 3
                objItem.SubItems(5) = "�d�b����"
            Case 4
                objItem.SubItems(5) = "������"
            Case 5
                objItem.SubItems(5) = "�G����"
        End Select
        
        Select Case .Shubetsu
            Case "1"
                objItem.SubItems(6) = "����"
            Case "2"
                objItem.SubItems(6) = "����"
            Case "3"
                objItem.SubItems(6) = "�ߋ���������"
            Case "4"
                objItem.SubItems(6) = "�ҕt"
            Case "5"
                objItem.SubItems(6) = "�ҕt����"
        End Select
        
        objItem.SubItems(7) = .Price
        objItem.SubItems(8) = .TaxPrice
        objItem.SubItems(9) = .Tax & "%"
        
        Select Case .Kanendo
            Case 0
                objItem.SubItems(10) = "���N�x"
            Case 1
                objItem.SubItems(10) = "�ߔN�x"
            Case Else
                objItem.SubItems(10) = "�H�H�H"
        End Select
        
        objItem.SubItems(11) = .ZaimuYY & .ZaimuMMDD
        objItem.SubItems(12) = .SysCd
    
    End With

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
Private Function RegistZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu            As Object       '�����A�g�A�N�Z�X�p
    Dim vntSysCd()          As Variant
    Dim vntYY()             As Variant
    Dim vntMMDD()           As Variant
    Dim vntOrgCd()          As Variant
    Dim vntOrgName()        As Variant
    Dim vntTekiyouCd()      As Variant
    Dim vntTekiyouName()    As Variant
    Dim vntPrice()          As Variant
    Dim vntKubun()          As Variant
    Dim vntShubetsu()       As Variant
    Dim vntTaxPrice()       As Variant
    Dim vntTax()            As Variant
    Dim vntCsCd()           As Variant
    Dim vntKanendo()        As Variant
    
    Dim vntSyubetsu_NIP()   As Variant
    Dim vntTekiyou_NIP()    As Variant
    Dim vntCount_NIP()      As Variant

    Dim intRecordCount      As Integer
    Dim objZaimuCsv         As ZaimuCsv
    Dim Ret                 As Boolean
    
    RegistZaimu = False
    intRecordCount = 0

    For Each objZaimuCsv In mcolZaimuInfoCollection
        
        ReDim Preserve vntSysCd(intRecordCount)
        ReDim Preserve vntYY(intRecordCount)
        ReDim Preserve vntMMDD(intRecordCount)
        ReDim Preserve vntOrgCd(intRecordCount)
        ReDim Preserve vntOrgName(intRecordCount)
        ReDim Preserve vntTekiyouCd(intRecordCount)
        ReDim Preserve vntTekiyouName(intRecordCount)
        ReDim Preserve vntPrice(intRecordCount)
        ReDim Preserve vntKubun(intRecordCount)
        ReDim Preserve vntShubetsu(intRecordCount)
        ReDim Preserve vntTaxPrice(intRecordCount)
        ReDim Preserve vntTax(intRecordCount)
        ReDim Preserve vntCsCd(intRecordCount)
        ReDim Preserve vntKanendo(intRecordCount)
    
        ReDim Preserve vntSyubetsu_NIP(intRecordCount)
        ReDim Preserve vntTekiyou_NIP(intRecordCount)
        ReDim Preserve vntCount_NIP(intRecordCount)
    
    
        With objZaimuCsv
            vntSysCd(intRecordCount) = .SysCd
            vntYY(intRecordCount) = .ZaimuYY
            vntMMDD(intRecordCount) = .ZaimuMMDD
            vntOrgCd(intRecordCount) = .OrgCd
            vntOrgName(intRecordCount) = .OrgName
            vntTekiyouCd(intRecordCount) = .TekiyouCd
            vntTekiyouName(intRecordCount) = .TekiyouName
            vntPrice(intRecordCount) = .Price
            vntKubun(intRecordCount) = .Kubun
            vntShubetsu(intRecordCount) = .Shubetsu
            vntTaxPrice(intRecordCount) = .TaxPrice
            vntTax(intRecordCount) = .Tax
            vntCsCd(intRecordCount) = .CsCd
            vntKanendo(intRecordCount) = .Kanendo
            vntSyubetsu_NIP(intRecordCount) = .Syubetsu_NIP
            vntTekiyou_NIP(intRecordCount) = .Tekiyou_NIP
            vntCount_NIP(intRecordCount) = .Count_NIP
        End With
        intRecordCount = intRecordCount + 1
    
    Next objZaimuCsv


    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '�����A�g�e�[�u�����R�[�h�̓o�^
    Ret = objZaimu.RegistZaimuCsv(mstrZaimuDate, _
                                  vntSysCd, _
                                  vntYY, _
                                  vntMMDD, _
                                  vntOrgCd, _
                                  vntOrgName, _
                                  vntTekiyouCd, _
                                  vntTekiyouName, _
                                  vntPrice, _
                                  vntKubun, _
                                  vntShubetsu, _
                                  vntTaxPrice, _
                                  vntTax, _
                                  vntCsCd, _
                                  vntKanendo, _
                                  vntSyubetsu_NIP, _
                                  vntTekiyou_NIP, _
                                  vntCount_NIP, _
                                  intRecordCount)

'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing�ǉ�
    Set objZaimu = Nothing
'### 2002.05.08 Added End

    If Ret = False Then
        MsgBox "�����A�g�pCSV�f�[�^�ۑ����ɒv���I�ȃG���[���������܂����B", vbExclamation
        RegistZaimu = False
        Exit Function
    End If
    
    RegistZaimu = True
    
    Exit Function
    
ErrorHandle:

    RegistZaimu = False
    MsgBox Err.Description, vbCritical
    
'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing�ǉ�
    Set objZaimu = Nothing
'### 2002.05.08 Added End
    
End Function

'
' �@�\�@�@ : �����f�[�^�ǉ�_Click
'
' ���l�@�@ :
'
Private Sub cmdAddItem_Click()
    
    Dim objZaimuCsv     As ZaimuCsv
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N
    Dim Ret             As Boolean
    
    With frmZaimuInfo
        Set objZaimuCsv = New ZaimuCsv
        .InitialDate = mstrZaimuDate
        .ParaZaimuCsv = objZaimuCsv
        .TekiyouCollection = mcolTekiyouCollection
        .Mode = True
        .Show vbModal
        Ret = .Updated
        If Ret = True Then
            Set objZaimuCsv = .ParaZaimuCsv
        End If
    End With
    
    If Ret = True Then
        
        '�R���N�V�����ɒǉ�
        mcolZaimuInfoCollection.Add objZaimuCsv, KEY_PREFIX & mintListViewIndex
    
        '���X�g�r���[�ɃI�u�W�F�N�g����Z�b�g
        Call SetObjectToListView(objZaimuCsv, "")
    
        Set objZaimuCsv = Nothing
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

Private Sub cmdClear_Click()

    frmClearCloseDate.Show vbModal
    
End Sub

Private Sub cmdPrint_Click()

  Dim exl As Variant

'** Excel �N��
  On Local Error Resume Next
  Set exl = CreateObject("Excel.Application")
  Shell exl.Path & "\excel.exe " & """" & App.Path & "\��������.xls""", 1
  On Local Error GoTo 0

End Sub

'
' �@�\�@�@ : �����f�[�^���M_Click
'
' ���l�@�@ :
'
Private Sub cmdSendZaimuData_Click()

    Dim strMsg          As String
    Dim objZaimu        As Object       '�����A�g�A�N�Z�X�p
    Dim lngRet          As Long
    Dim dtmInsDate      As Date

    '�����f�[�^��������݂��Ȃ��Ȃ�G���[
    If lsvItem.ListItems.Count <= 0 Then
        MsgBox "�����f�[�^���P��������܂���B", vbExclamation, Me.Caption
        Exit Sub
    End If

    '���s�O�₢���킹
    strMsg = "���݂̃f�[�^�������V�X�e���ɑ��M���܂��B��낵���ł����H"
    If MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbQuestion, Me.Caption) = vbNo Then
        Exit Sub
    End If
    
    Screen.MousePointer = vbHourglass
    
    '�����A�g�e�[�u���̓o�^
    If RegistZaimu() = False Then
        Screen.MousePointer = vbDefault
        Exit Sub
    End If
    
    '�o�^��A���M
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    dtmInsDate = CDate(Mid(mstrZaimuDate, 1, 4) & "/" & Mid(mstrZaimuDate, 5, 2) & "/" & Mid(mstrZaimuDate, 7, 2))
    lngRet = objZaimu.CopyZaimuCsv(dtmInsDate)

    If lngRet < 1 Then
        MsgBox "�ُ�I�����܂����BErrCd = " & lngRet, vbExclamation
    Else
        MsgBox "����I�����܂����B", vbInformation
'### 2002.05.14 Added by Ishihara@FSIT ���M�ς݂��ǂ����̕\�����s��
        lblSendLamp.Caption = "�����M�ς݂ł��B"
        lblSendLamp.ForeColor = vbBlack
'### 2002.05.14 Added End
    End If
    
    Screen.MousePointer = vbDefault
    
End Sub

'
' �@�\�@�@ : �����f�[�^�쐬_Click
'
' ���l�@�@ :
'
Private Sub cmdCreateZaimu_Click()

    Dim lngRet          As Long
    Dim objZaimu        As Object       '�����A�g�A�N�Z�X�p
    Dim dtmInsDate      As Date
    Dim dtmStrDate       As Date
    Dim dtmEndDate       As Date
    Dim blnAllData      As Boolean
    Dim blnCalcOrg      As Boolean
    Dim blnAppendMode   As Boolean
    Dim strMsg          As String
    Dim blnRet          As Boolean
    
    With frmSelectExecuteDate
        .InitialDate = mstrZaimuDate
        .Show vbModal
        blnRet = .Updated
        If blnRet = True Then
            blnAllData = .AllData
            dtmInsDate = .InsDate
            blnCalcOrg = .CalcOrg
            blnAppendMode = .AppendMode
            If blnCalcOrg = True Then
                dtmStrDate = .strDate
                dtmEndDate = .endDate
            End If
        End If
    End With
        
    If blnRet = False Then Exit Sub
    
    If (lsvItem.ListItems.Count > 0) And (blnAppendMode = False) Then
        strMsg = "���݂̃f�[�^�͍폜����A�V�����A�g�t�@�C�����쐬�������܂��B��낵���ł����H"
    Else
        strMsg = "�����A�g�f�[�^(CSV)���쐬���܂��B��낵���ł����H"
    End If
    
    If MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation, Me.Caption) = vbNo Then
        Exit Sub
    End If
    Screen.MousePointer = vbHourglass
    
'    dtmTargetDate = CDate(Mid(mstrZaimuDate, 1, 4) & "/" & Mid(mstrZaimuDate, 5, 2) & "/" & Mid(mstrZaimuDate, 7, 2))
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '�����A�g�e�[�u�����R�[�h�̓o�^
    If blnCalcOrg = True Then
        lngRet = objZaimu.CreateZaimuCSV(dtmInsDate, Not blnAllData, blnAppendMode, dtmStrDate, dtmEndDate)
    Else
        lngRet = objZaimu.CreateZaimuCSV(dtmInsDate, Not blnAllData, blnAppendMode)
    End If
    
'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing�ǉ�
    Set objZaimu = Nothing
'### 2002.05.08 Added End
    
    If lngRet < 0 Then
        MsgBox "�����A�g�e�[�u���쐬���ɒv���I�ȃG���[���������܂����B=" & lngRet, vbCritical
    Else
        
        '�����A�g���̕ҏW
        If EditZaimu() = False Then Exit Sub
        MsgBox lngRet & "���̃f�[�^���쐬���܂����B"
    
    End If
    
    Screen.MousePointer = vbDefault
    
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

    Dim i               As Integer
    Dim strKey          As String
    
    For i = 1 To lsvItem.ListItems.Count

        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For

        '�I������Ă��鍀�ڂȂ�폜
        If lsvItem.ListItems(i).Selected = True Then
            strKey = lsvItem.ListItems(i).Key
            lsvItem.ListItems.Remove (strKey)
            mcolZaimuInfoCollection.Remove (strKey)
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
        End If

    Next i

End Sub

Private Sub cmdEdit_Click()

    Dim i               As Integer
    Dim strKey          As String
    Dim blnSelected     As Boolean
    Dim objZaimuCsv     As ZaimuCsv
    Dim Ret             As Boolean
    
    If lsvItem.ListItems.Count < 1 Then
        MsgBox "�ҏW�\�ȍ��ڂ�����܂���B", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    '�I�𐔃`�F�b�N
    blnSelected = False
    For i = 1 To lsvItem.ListItems.Count

        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For

        '�I������Ă��鍀�ڂȂ�폜
        If lsvItem.ListItems(i).Selected = True Then
            If blnSelected = False Then
                strKey = lsvItem.ListItems(i).Key
                blnSelected = True
            Else
                MsgBox "�����I��������ԂŁA���e�C�����邱�Ƃ͂ł��܂���B", vbExclamation, Me.Caption
                Exit Sub
            End If
        End If

    Next i

    '�ҏW��ʕ\��
    With frmZaimuInfo
        .ParaZaimuCsv = mcolZaimuInfoCollection(strKey)
        .TekiyouCollection = mcolTekiyouCollection
        .Mode = False
        .Show vbModal
        Ret = .Updated
    End With
    
    If Ret = True Then
        
        '���X�g�r���[�̃I�u�W�F�N�g���X�V
        Call SetObjectToListView(mcolZaimuInfoCollection(strKey), strKey)
    
        '�R���N�V�����͂��������������Ă܂��E�E�E
    
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
Private Sub cmdOk_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    Do
        
'### 2002.05.08 Modified by Ishihara@FSIT 0�������\�킸����
'        If lsvItem.ListItems.Count > 0 Then
'            '�����A�g�e�[�u���̓o�^
'            If RegistZaimu() = False Then Exit Do
'        End If
        '�����A�g�e�[�u���̓o�^
        If RegistZaimu() = False Then Exit Do
'### 2002.05.08 Modified End
            
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

    Dim Ret         As Boolean  '�߂�l
    Dim objHeader   As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False

    '�R���N�V�����ƃR���N�V�����p�L�[�̓N���G�C�g�i�V�K�쐬�z��j
    mintListViewIndex = 0
    Set mcolZaimuInfoCollection = New Collection

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

'### 2002.05.14 Added by Ishihara@FSIT ���M�ς݂��ǂ����̕\�����s��
    lblSendLamp.Caption = "�������M�ł��B"
    lblSendLamp.ForeColor = vbRed
'### 2002.05.14 Added End

    '�w�b�_�̕ҏW
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "������R�[�h", 1200, lvwColumnLeft
        .Add , , "�����於��", 1500, lvwColumnLeft
        .Add , , "�K�p�R�[�h", 1000, lvwColumnLeft
        .Add , , "�K�p����", 2000, lvwColumnLeft
        .Add , , "�R�[�X�R�[�h", 600, lvwColumnRight
        .Add , , "�敪", 1050, lvwColumnLeft
        .Add , , "���", 600, lvwColumnLeft
        .Add , , "���z", 900, lvwColumnRight
        .Add , , "�Ŋz", 900, lvwColumnRight
        .Add , , "�ŗ�", 600, lvwColumnRight
        .Add , , "�ߔN�x", 800, lvwColumnLeft
        .Add , , "���t", 1200, lvwColumnLeft
        .Add , , "�V�X�e����ʃR�[�h", 1200, lvwColumnLeft
    End With
    lsvItem.View = lvwReport

    lblFileName = Mid(mstrZaimuDate, 1, 4) & "�N"
    lblFileName = lblFileName & Mid(mstrZaimuDate, 5, 2) & "��"
    lblFileName = lblFileName & Mid(mstrZaimuDate, 7, 2) & "���̎��x�f�[�^�ł�"
    
    Do
        
        '�K�p�R�[�h�̃R���N�V������
        If CreateTekiyouCollection() = False Then
            Exit Do
        End If
        
        '�����A�g���̕ҏW
        If EditZaimu() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

'
' �@�\�@�@ : �K�p�R�[�h�̃R���N�V�����Z�b�g
'
' ���l�@�@ : �K�p�R�[�h�f�[�^��ǂݍ��݁A�R���N�V�����ɃZ�b�g����
'
Private Function CreateTekiyouCollection() As Boolean
    
On Error GoTo ErrorHandle
    
    Dim objZaimu            As Object           '�����K�p�R�[�h�A�N�Z�X�p
    Dim vntZaimuCd          As Variant          '�����R�[�h�R�[�h
    Dim vntZaimuName        As Variant          '�����K�p��
    
    Dim objTekiyouClass     As TekiyouClass
    Dim lngCount            As Long
    Dim i                   As Integer
    
    CreateTekiyouCollection = False
    
    lngCount = 0

    '�K�p�R�[�h�R���N�V�����̍쐬
    Set mcolTekiyouCollection = New Collection
    
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, , , , , True)
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        
        Set objTekiyouClass = New TekiyouClass
        objTekiyouClass.TekiyouCd = vntZaimuCd(i)
        objTekiyouClass.TekiyouName = vntZaimuName(i)

'        cboTekiyou.AddItem vntZaimuName(i)
'        objTekiyouClass.ListIndex = cboTekiyou.NewIndex
    
'        mcolTekiyouCollection.Add objTekiyouClass, KEY_PREFIX & objTekiyouClass.ListIndex
        mcolTekiyouCollection.Add objTekiyouClass, KEY_PREFIX & vntZaimuCd(i)
        Set objTekiyouClass = Nothing
    
    Next i
    
    If lngCount < 1 Then
        MsgBox "�����A�g�p�̓K�p�R�[�h���ݒ肳��Ă��܂���B", vbExclamation, Me.Caption
        Exit Function
    End If

    CreateTekiyouCollection = True
    Exit Function

ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub Form_Resize()
    
'### 2002.05.14 Deleted by Ishihara@FSIT �g���ĂȂ�������
'    If Me.WindowState <> vbMinimized Then
'        Call SizeControls
'    End If
'### 2002.05.14 Deleted End

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
    If Me.Width > 11175 Then

        fraMain.Width = Me.Width - (360)
        cmdAddItem.Left = fraMain.Width - 4275
        cmdEdit.Left = fraMain.Width - 2895
        cmdDeleteItem.Left = fraMain.Width - 1515
        cmdOk.Left = Me.Width - 3075
        cmdCancel.Left = Me.Width - 1635
        lsvItem.Width = fraMain.Width - 300
    
    End If
    
    '�����ύX
    If Me.Height > 5730 Then
        fraMain.Height = Me.Height - 1395
        lsvItem.Height = fraMain.Height - (540 + 240)
        cmdAddItem.Top = fraMain.Height - (495)
        cmdEdit.Top = cmdAddItem.Top
        cmdDeleteItem.Top = cmdAddItem.Top
        cmdOk.Top = Me.Height - (315 + 495)
        cmdCancel.Top = cmdOk.Top
        cmdCreateZaimu.Top = cmdOk.Top
        cmdSendZaimuData.Top = cmdOk.Top
    End If

End Sub

Private Sub lsvItem_DblClick()

    Call cmdEdit_Click
    
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



