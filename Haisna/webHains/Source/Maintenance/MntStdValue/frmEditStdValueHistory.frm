VERSION 5.00
Begin VB.Form frmEditStdValueHistory 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "��l�������̐ݒ�"
   ClientHeight    =   1245
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7185
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditStdValueHistory.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1245
   ScaleWidth      =   7185
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4260
      TabIndex        =   16
      Top             =   840
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5700
      TabIndex        =   15
      Top             =   840
      Width           =   1335
   End
   Begin VB.ComboBox cboCourse 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":000C
      Left            =   1380
      List            =   "frmEditStdValueHistory.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   13
      Top             =   600
      Visible         =   0   'False
      Width           =   5610
   End
   Begin VB.ComboBox cboEndDay 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":0050
      Left            =   6240
      List            =   "frmEditStdValueHistory.frx":0057
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   5
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndMonth 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":005F
      Left            =   5340
      List            =   "frmEditStdValueHistory.frx":0066
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   4
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndYear 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":006E
      Left            =   4320
      List            =   "frmEditStdValueHistory.frx":0075
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   3
      Top             =   240
      Width           =   735
   End
   Begin VB.ComboBox cboStrDay 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":007F
      Left            =   3300
      List            =   "frmEditStdValueHistory.frx":0086
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   2
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrMonth 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":008E
      Left            =   2400
      List            =   "frmEditStdValueHistory.frx":0095
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   1
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrYear 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":009D
      Left            =   1380
      List            =   "frmEditStdValueHistory.frx":00A4
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   0
      Top             =   240
      Width           =   735
   End
   Begin VB.Label Label8 
      Caption         =   "�R�[�X(&C):"
      Height          =   195
      Index           =   2
      Left            =   180
      TabIndex        =   14
      Top             =   660
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "�L������(&D):"
      Height          =   255
      Left            =   180
      TabIndex        =   12
      Top             =   300
      Width           =   1155
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   7
      Left            =   6840
      TabIndex        =   11
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   6
      Left            =   5940
      TabIndex        =   10
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   5
      Left            =   5100
      TabIndex        =   9
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "���`"
      Height          =   255
      Index           =   3
      Left            =   3900
      TabIndex        =   8
      Top             =   300
      Width           =   435
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   3000
      TabIndex        =   7
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   2160
      TabIndex        =   6
      Top             =   300
      Width           =   255
   End
End
Attribute VB_Name = "frmEditStdValueHistory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd       As String   '�R�[�X�R�[�h
Private mstrCsName     As String   '�R�[�X��
Private mstrStrDate    As String   '�J�n���t
Private mstrEndDate    As String   '�J�n���t

Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrRootCsCd()  As String   '�R���{�{�b�N�X�ɑΉ�����R�[�X�R�[�h�̊i�[
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����



Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X�f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditCourseConbo() As Boolean

    Dim objCourse       As Object   '�R�[�X�A�N�Z�X�p
    Dim vntCsCd         As Variant
    Dim vntCsName       As Variant
    Dim lngCount        As Long             '���R�[�h��
    Dim i               As Long             '�C���f�b�N�X
    
    EditCourseConbo = False
    
    cboCourse.Clear
    Erase mstrRootCsCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
'### 2002.12.22 Modified by H.Ishihara@FSIT �I���\�ȃR�[�X�̓��C���R�[�X�̂�
'    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName)
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName, , 3)
'### 2002.12.22 Modified End
    
    '�R�[�X�͖��w�肠��
    ReDim Preserve mstrRootCsCd(0)
    mstrRootCsCd(0) = ""
    cboCourse.AddItem ""
    cboCourse.ListIndex = 0
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootCsCd(i + 1)
        mstrRootCsCd(i + 1) = vntCsCd(i)
        cboCourse.AddItem vntCsName(i)
        If vntCsCd(i) = mstrCsCd Then
            cboCourse.ListIndex = i + 1
        End If
    Next i
    
    '�擪�R���{��I����Ԃɂ���
'    cboCourse.ListIndex = 0
    EditCourseConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub cmdOk_Click()

    Dim strStrDate As String
    Dim strEndDate As String

    '���̓`�F�b�N
    If CheckValue(strStrDate, strEndDate) = False Then Exit Sub
    
    '�v���p�e�B�l�̉�ʃZ�b�g
    mstrStrDate = strStrDate
    mstrEndDate = strEndDate
    mstrCsCd = mstrRootCsCd(cboCourse.ListIndex)
    mstrCsName = cboCourse.Text

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
Private Function CheckValue(strStrDate As String, strEndDate As String) As Boolean

    Dim Ret             As Boolean  '�֐��߂�l
    Dim strWorkResult   As String
        
    '����R���g���[����SetFocus�ł͕�����I�����L���ɂȂ�Ȃ��̂Ń_�~�[�łƂ΂�
    cmdOk.SetFocus
    
    Ret = False
    
    Do
        
        '�J�n���t�`�F�b�N
        strStrDate = cboStrYear.Text & "/" & _
                     Format(cboStrMonth.Text, "00") & "/" & _
                     Format(cboStrDay.Text, "00")

        If IsDate(strStrDate) = False Then
            MsgBox "�������J�n���t����͂��Ă��������B", vbExclamation, App.Title
            cboStrYear.SetFocus
            Exit Do
        End If

        '�I�����t�`�F�b�N
        strEndDate = cboEndYear.Text & "/" & _
                     Format(cboEndMonth.Text, "00") & "/" & _
                     Format(cboEndDay.Text, "00")

        If IsDate(strEndDate) = False Then
            MsgBox "�������I�����t����͂��Ă��������B", vbExclamation, App.Title
            cboEndYear.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function



Private Sub Form_Load()

    Dim Ret             As Boolean  '�߂�l
    Dim i               As Integer
    Dim intWorkYear     As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    '�R���{�{�b�N�X�ɒl���Z�b�g
    For i = YEARRANGE_MIN To YEARRANGE_MAX
        cboStrYear.AddItem i
        cboEndYear.AddItem i
    Next i
    
    For i = 1 To 12
        cboStrMonth.AddItem i
        cboEndMonth.AddItem i
    Next i
    
    For i = 1 To 31
        cboStrDay.AddItem i
        cboEndDay.AddItem i
    Next i

    '�J�n���̐ݒ�
    If IsDate(mstrStrDate) = True Then
        intWorkYear = CInt(Format(CDate(mstrStrDate), "YYYY"))
        If intWorkYear >= YEARRANGE_MIN Then
            cboStrYear.ListIndex = intWorkYear - YEARRANGE_MIN
        End If
        cboStrMonth.ListIndex = CInt(Format(CDate(mstrStrDate), "MM")) - 1
        cboStrDay.ListIndex = CInt(Format(CDate(mstrStrDate), "DD")) - 1
    End If

    '�I�����̐ݒ�
    If IsDate(mstrEndDate) = True Then
        intWorkYear = CInt(Format(CDate(mstrEndDate), "YYYY"))
        If intWorkYear >= YEARRANGE_MIN Then
            cboEndYear.ListIndex = intWorkYear - YEARRANGE_MIN
        End If
        cboEndMonth.ListIndex = CInt(Format(CDate(mstrEndDate), "MM")) - 1
        cboEndDay.ListIndex = CInt(Format(CDate(mstrEndDate), "DD")) - 1
    End If

    Do
        '�R�[�X�R���{�̕ҏW
        If EditCourseConbo() = False Then
            Exit Do
        End If
                
        Ret = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Sub



Friend Property Get CsCd() As Variant

    CsCd = mstrCsCd

End Property

Friend Property Let CsCd(ByVal vNewValue As Variant)

    mstrCsCd = vNewValue

End Property

Friend Property Get strDate() As Variant

    strDate = mstrStrDate

End Property

Friend Property Let strDate(ByVal vNewValue As Variant)

    mstrStrDate = vNewValue

End Property

Friend Property Get endDate() As Variant

    endDate = mstrEndDate

End Property

Friend Property Let endDate(ByVal vNewValue As Variant)

    mstrEndDate = vNewValue

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

Friend Property Let Updated(ByVal vNewValue As Variant)

    mblnUpdated = vNewValue
    
End Property

Friend Property Get CsName() As Variant

    CsName = mstrCsName
    
End Property

