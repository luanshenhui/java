VERSION 5.00
Begin VB.Form frmTax 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�K�p�Ŋz�̐ݒ�"
   ClientHeight    =   1890
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4695
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmTax.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1890
   ScaleWidth      =   4695
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtTax 
      Alignment       =   1  '�E����
      Height          =   315
      Index           =   1
      Left            =   3420
      MaxLength       =   6
      TabIndex        =   11
      Text            =   "0.5"
      Top             =   780
      Width           =   615
   End
   Begin VB.TextBox txtTax 
      Alignment       =   1  '�E����
      Height          =   315
      Index           =   0
      Left            =   1320
      MaxLength       =   6
      TabIndex        =   9
      Text            =   "0.5"
      Top             =   240
      Width           =   615
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmTax.frx":000C
      Left            =   240
      List            =   "frmTax.frx":0013
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   4
      Top             =   780
      Width           =   735
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmTax.frx":001D
      Left            =   1260
      List            =   "frmTax.frx":0024
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   3
      Top             =   780
      Width           =   555
   End
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmTax.frx":002C
      Left            =   2160
      List            =   "frmTax.frx":0033
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   2
      Top             =   780
      Width           =   555
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   3180
      TabIndex        =   1
      Top             =   1440
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1740
      TabIndex        =   0
      Top             =   1440
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "��"
      Height          =   180
      Index           =   1
      Left            =   4080
      TabIndex        =   12
      Top             =   840
      Width           =   390
   End
   Begin VB.Label Label1 
      Caption         =   "��"
      Height          =   180
      Index           =   2
      Left            =   1980
      TabIndex        =   10
      Top             =   300
      Width           =   390
   End
   Begin VB.Label Label1 
      Caption         =   "��{�Ŋz(&B):"
      Height          =   180
      Index           =   0
      Left            =   240
      TabIndex        =   8
      Top             =   300
      Width           =   1110
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   1020
      TabIndex        =   7
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   1860
      TabIndex        =   6
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "���ȍ~"
      Height          =   255
      Index           =   3
      Left            =   2760
      TabIndex        =   5
      Top             =   840
      Width           =   555
   End
End
Attribute VB_Name = "frmTax"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrFreeCd      As String   '�s���{���R�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnModeNew     As Boolean  'TRUE:�V�K�AFALSE:�X�V

Private mintField1      As Integer
Private mintField2      As Integer
Private mdtnFreeDate    As Date

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Get Initialize() As Boolean

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

    Dim Ret         As Boolean  '�֐��߂�l
    Dim blnRet      As Boolean
    Dim i           As Integer
    
    CheckValue = False
    
        
    For i = 0 To 1
    
        '�g���~���O
        txtTax(i).Text = Trim(txtTax(i).Text)
    
        '�󔒃`�F�b�N
        If txtTax(i).Text = "" Then
            MsgBox "�ŗ������͂���Ă��܂���B", vbCritical, App.Title
            txtTax(i).SetFocus
            Exit Function
        End If
    
        '���l�`�F�b�N
        If IsNumeric(txtTax(i).Text) = False Then
            MsgBox "�ŗ��ɂ͐��l����͂��Ă��������B", vbCritical, App.Title
            txtTax(i).SetFocus
            Exit Function
        End If
    
        '�͈̓`�F�b�N
        If (CDbl(txtTax(i).Text) > 100) Or (CDbl(txtTax(i).Text) < 0) Then
            MsgBox "�L���Ȑŗ�����͂��Ă��������B", vbCritical, App.Title
            txtTax(i).SetFocus
            Exit Function
        End If
    
    Next i
        
    
    '�߂�l�̐ݒ�
    CheckValue = True
    
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
Private Function RegistFree() As Boolean

    Dim objFree As Object       '�ėp�e�[�u���A�N�Z�X�p
    Dim Ret     As Long
    
    On Error GoTo ErrorHandle
    
    mdtnFreeDate = CDate((cboYear.List(cboYear.ListIndex) & "/" & cboMonth.List(cboMonth.ListIndex) & "/" & cboDay.List(cboDay.ListIndex)))
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")

    '�ėp�e�[�u�����R�[�h�̓o�^
    If mblnModeNew = True Then
    
        '�V�K�o�^
        Ret = objFree.InsertFree(SYSPRO_TAX_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_TAX_NAME, _
                                 mdtnFreeDate, _
                                 (txtTax(0).Text / 100), _
                                 (txtTax(1).Text / 100))
        
    
    Else
    
        '�X�V
        Ret = objFree.UpdateFree(SYSPRO_TAX_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_TAX_NAME, _
                                 mdtnFreeDate, _
                                 (txtTax(0).Text / 100), _
                                 (txtTax(1).Text / 100))
    
        If Ret = True Then Ret = INSERT_NORMAL
        
    End If

    If Ret <> INSERT_NORMAL Then
        MsgBox "�f�[�^�X�V���ɃG���[���������܂����B", vbCritical
        RegistFree = False
        Exit Function
    End If

    '�f�[�^���݂̂��߁A�X�V���[�h
    mblnModeNew = False
    
    RegistFree = True
    
    Exit Function
    
ErrorHandle:

    RegistFree = False
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
Private Function EditFree() As Boolean

    Dim objFree         As Object           '�ėp�e�[�u���A�N�Z�X�p
    
    Dim lngMode         As Long
    Dim strFreeCdKey    As String
    Dim vntFreeCd       As Variant
    Dim vntFreeName     As Variant
    Dim vntFreeDate     As Variant
    Dim vntFreeField1   As Variant
    Dim vntFreeField2   As Variant

    Dim Ret             As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")
    
    Do
        
        '����Ŋz���R�[�h�ǂݍ���
        If objFree.SelectFree(0, _
                              SYSPRO_TAX_KEY, _
                              vntFreeCd, _
                              vntFreeName, _
                              vntFreeDate, _
                              vntFreeField1, _
                              vntFreeField2) = False Then
            
            '�f�[�^�Ȃ��ł��A��ʂ͊J��
            Ret = True
            Exit Do
        End If
    
        '�f�[�^���݂̂��߁A�X�V���[�h
        mblnModeNew = False
    
        '�ǂݍ��ݓ��e�̕ҏW
        If IsDate(vntFreeDate) Then
            mdtnFreeDate = vntFreeDate
        End If
        
        If IsNumeric(vntFreeField1) Then
            txtTax(0).Text = vntFreeField1 * 100
        End If

        If IsNumeric(vntFreeField2) Then
            txtTax(1).Text = vntFreeField2 * 100
        End If

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditFree = Ret
    
    Exit Function

ErrorHandle:

    EditFree = False
    
    MsgBox Err.Description, vbCritical
    
End Function

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
        If CheckValue() = False Then
            Exit Do
        End If
        
        '�f�[�^�̓o�^
        If RegistFree() = False Then
            Exit Do
        End If
            
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
    Dim i   As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    mblnModeNew = True

    mdtnFreeDate = Now
    mintField1 = 1
    mintField2 = 2
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
        '�ėp�e�[�u������̃f�[�^�ҏW
        If EditFree() = False Then
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�R���{�{�b�N�X�ɒl���Z�b�g
    With cboYear
        .Clear
        For i = YEARRANGE_MIN To YEARRANGE_MAX
            .AddItem i
            If (i = Year(mdtnFreeDate)) And _
               (YEARRANGE_MIN <= Year(mdtnFreeDate)) And _
               (YEARRANGE_MAX >= Year(mdtnFreeDate)) Then
                .ListIndex = i - YEARRANGE_MIN
            End If
        Next i
    End With
    
    With cboMonth
        .Clear
        For i = 1 To 12
            .AddItem i
            If i = Month(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    With cboDay
        .Clear
        For i = 1 To 31
            .AddItem i
            If i = Day(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub


