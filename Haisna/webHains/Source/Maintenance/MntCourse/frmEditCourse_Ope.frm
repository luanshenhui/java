VERSION 5.00
Begin VB.Form frmEditCourse_Ope 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�������ڂ����{������ɂ���ݒ肵�Ă��������B"
   ClientHeight    =   5505
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6180
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditCourse_Ope.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5505
   ScaleWidth      =   6180
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame1 
      Caption         =   "���{���ݒ�"
      Height          =   4275
      Left            =   120
      TabIndex        =   12
      Top             =   600
      Width           =   5895
      Begin VB.CommandButton cmdAllZero 
         Caption         =   "�S�ď����ɐݒ�(&Y)"
         Height          =   375
         Left            =   300
         TabIndex        =   35
         Top             =   3600
         Width           =   2355
      End
      Begin VB.CheckBox chkNoDefine 
         Caption         =   "���{���ݒ���s��Ȃ�(&N)"
         Height          =   195
         Left            =   300
         TabIndex        =   34
         Top             =   480
         Width           =   3015
      End
      Begin VB.CommandButton cmdClear 
         Caption         =   "���{���ݒ���N���A����(&C)"
         Height          =   375
         Left            =   3060
         TabIndex        =   33
         Top             =   3600
         Width           =   2355
      End
      Begin VB.CheckBox chkToday 
         Caption         =   "���̓��Ɍ�������"
         Height          =   195
         Index           =   6
         Left            =   2160
         TabIndex        =   26
         Top             =   3180
         Value           =   1  '����
         Width           =   1635
      End
      Begin VB.CheckBox chkToday 
         Caption         =   "���̓��Ɍ�������"
         Height          =   195
         Index           =   5
         Left            =   2160
         TabIndex        =   22
         Top             =   2820
         Value           =   1  '����
         Width           =   1635
      End
      Begin VB.CheckBox chkToday 
         Caption         =   "���̓��Ɍ�������"
         Height          =   195
         Index           =   4
         Left            =   2160
         TabIndex        =   18
         Top             =   2340
         Value           =   1  '����
         Width           =   1635
      End
      Begin VB.CheckBox chkToday 
         Caption         =   "���̓��Ɍ�������"
         Height          =   195
         Index           =   3
         Left            =   2160
         TabIndex        =   14
         Top             =   1980
         Value           =   1  '����
         Width           =   1635
      End
      Begin VB.CheckBox chkToday 
         Caption         =   "���̓��Ɍ�������"
         Height          =   195
         Index           =   2
         Left            =   2160
         TabIndex        =   9
         Top             =   1620
         Value           =   1  '����
         Width           =   1635
      End
      Begin VB.CheckBox chkToday 
         Caption         =   "���̓��Ɍ�������"
         Height          =   195
         Index           =   1
         Left            =   2160
         TabIndex        =   5
         Top             =   1260
         Value           =   1  '����
         Width           =   1635
      End
      Begin VB.CheckBox chkToday 
         Caption         =   "���̓��Ɍ�������"
         Height          =   195
         Index           =   0
         Left            =   2160
         TabIndex        =   1
         Top             =   900
         Value           =   1  '����
         Width           =   1635
      End
      Begin VB.TextBox txtDay 
         Alignment       =   1  '�E����
         Height          =   315
         Index           =   6
         Left            =   3960
         TabIndex        =   27
         Text            =   "1"
         Top             =   3120
         Width           =   495
      End
      Begin VB.TextBox txtDay 
         Alignment       =   1  '�E����
         Height          =   315
         Index           =   5
         Left            =   3960
         TabIndex        =   23
         Text            =   "1"
         Top             =   2760
         Width           =   495
      End
      Begin VB.TextBox txtDay 
         Alignment       =   1  '�E����
         Height          =   315
         Index           =   4
         Left            =   3960
         TabIndex        =   19
         Text            =   "1"
         Top             =   2280
         Width           =   495
      End
      Begin VB.TextBox txtDay 
         Alignment       =   1  '�E����
         Height          =   315
         Index           =   3
         Left            =   3960
         TabIndex        =   15
         Text            =   "1"
         Top             =   1920
         Width           =   495
      End
      Begin VB.TextBox txtDay 
         Alignment       =   1  '�E����
         Height          =   315
         Index           =   2
         Left            =   3960
         TabIndex        =   10
         Text            =   "1"
         Top             =   1560
         Width           =   495
      End
      Begin VB.TextBox txtDay 
         Alignment       =   1  '�E����
         Height          =   315
         Index           =   1
         Left            =   3960
         TabIndex        =   6
         Text            =   "1"
         Top             =   1200
         Width           =   495
      End
      Begin VB.TextBox txtDay 
         Alignment       =   1  '�E����
         Height          =   315
         Index           =   0
         Left            =   3960
         TabIndex        =   2
         Text            =   "1"
         Top             =   840
         Width           =   495
      End
      Begin VB.Label LabelKensa 
         Caption         =   "����Ɍ���"
         Height          =   255
         Index           =   6
         Left            =   4560
         TabIndex        =   28
         Top             =   3180
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "���j���������Ȃ�(&N):"
         ForeColor       =   &H000000FF&
         Height          =   195
         Index           =   6
         Left            =   300
         TabIndex        =   25
         Top             =   3180
         Width           =   1695
      End
      Begin VB.Label LabelKensa 
         Caption         =   "����Ɍ���"
         Height          =   255
         Index           =   5
         Left            =   4560
         TabIndex        =   24
         Top             =   2820
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "�y�j���������Ȃ�(&S):"
         ForeColor       =   &H00FF0000&
         Height          =   195
         Index           =   5
         Left            =   300
         TabIndex        =   21
         Top             =   2820
         Width           =   1695
      End
      Begin VB.Label LabelKensa 
         Caption         =   "����Ɍ���"
         Height          =   255
         Index           =   4
         Left            =   4560
         TabIndex        =   20
         Top             =   2340
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "���j���������Ȃ�(&F):"
         Height          =   195
         Index           =   4
         Left            =   300
         TabIndex        =   17
         Top             =   2340
         Width           =   1695
      End
      Begin VB.Label LabelKensa 
         Caption         =   "����Ɍ���"
         Height          =   255
         Index           =   3
         Left            =   4560
         TabIndex        =   16
         Top             =   1980
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "�ؗj���������Ȃ�(&H):"
         Height          =   195
         Index           =   3
         Left            =   300
         TabIndex        =   13
         Top             =   1980
         Width           =   1695
      End
      Begin VB.Label LabelKensa 
         Caption         =   "����Ɍ���"
         Height          =   255
         Index           =   2
         Left            =   4560
         TabIndex        =   11
         Top             =   1620
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "���j���������Ȃ�(&W):"
         Height          =   195
         Index           =   2
         Left            =   300
         TabIndex        =   8
         Top             =   1620
         Width           =   1695
      End
      Begin VB.Label LabelKensa 
         Caption         =   "����Ɍ���"
         Height          =   255
         Index           =   1
         Left            =   4560
         TabIndex        =   7
         Top             =   1260
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "�Ηj���������Ȃ�(&T):"
         Height          =   195
         Index           =   1
         Left            =   300
         TabIndex        =   4
         Top             =   1260
         Width           =   1695
      End
      Begin VB.Label LabelKensa 
         Caption         =   "����Ɍ���"
         Height          =   255
         Index           =   0
         Left            =   4560
         TabIndex        =   3
         Top             =   900
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "���j���������Ȃ�(&M):"
         Height          =   195
         Index           =   0
         Left            =   300
         TabIndex        =   0
         Top             =   900
         Width           =   1695
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4680
      TabIndex        =   30
      Top             =   5040
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3300
      TabIndex        =   29
      Top             =   5040
      Width           =   1275
   End
   Begin VB.Label lblOpeClassInfo 
      Caption         =   "002�F�����V�X�e���˗���"
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
      Left            =   1500
      TabIndex        =   32
      Top             =   240
      Width           =   3435
   End
   Begin VB.Label Label1 
      Caption         =   "�������ڕ��ށF"
      Height          =   195
      Index           =   7
      Left            =   240
      TabIndex        =   31
      Top             =   240
      Width           =   1275
   End
End
Attribute VB_Name = "frmEditCourse_Ope"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mintStay            As Integer
Private mstrOpeClassCd      As String
Private mstrOpeClassName    As String

Private mstrMonMng          As String
Private mstrTueMng          As String
Private mstrWedMng          As String
Private mstrThuMng          As String
Private mstrFriMng          As String
Private mstrSatMng          As String
Private mstrSunMng          As String

Private Sub chkNoDefine_Click()

    Dim i As Integer

    If chkNoDefine.Value = vbChecked Then
        For i = 0 To 6
            chkToday(i).Enabled = False
            txtDay(i).Enabled = False
            LabelKensa(i).ForeColor = vbGrayText
        Next i
        cmdClear.Enabled = False
        cmdAllZero.Enabled = False
    Else
        For i = 0 To 6
            chkToday(i).Enabled = True
            Call chkToday_Click(i)
        Next i
        cmdClear.Enabled = True
        cmdAllZero.Enabled = True
    End If
    
End Sub

Private Sub chkToday_Click(Index As Integer)

    txtDay(Index).Enabled = Not (chkToday(Index).Value = vbChecked)
    
    If chkToday(Index).Value = vbChecked Then
        LabelKensa(Index).ForeColor = vbGrayText
    Else
        LabelKensa(Index).ForeColor = vbButtonText
    End If
    
End Sub

Private Sub cmdAllZero_Click()
    
    Dim i As Integer
    
    For i = 0 To 6
        chkToday(i).Value = vbChecked
        txtDay(i).Text = "0"
    Next i

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdClear_Click()

    Dim i     As Integer

    For i = 0 To 6
        chkToday(i).Value = vbUnchecked
        txtDay(i).Text = ""
    Next i

End Sub

Private Sub cmdOk_Click()

    Dim i               As Integer

    If chkNoDefine.Value = vbUnchecked Then
    
        '���t�̃`�F�b�N
        For i = 0 To 6
            
            '�`�F�b�N�{�b�N�X�Ȃ��������ݒ��0�Ȃ玩���I�Ƀ`�F�b�N
            If (chkToday(i).Value = vbUnchecked) And _
               (txtDay(i).Text = "0") Then
                chkToday(i).Value = vbChecked
            End If
            
            '�`�F�b�N�{�b�N�X�Ȃ��������ݒ�󔒂��X�V���[�h�Ȃ�G���[
            If (chkToday(i).Value = vbUnchecked) And _
               (Trim(txtDay(i).Text) = "") Then
                MsgBox "����������͂��Ă��������B", vbExclamation
                txtDay(i).SetFocus
                Exit Sub
            End If
            
            If (chkToday(i).Value = vbUnchecked) And _
               (txtDay(i).Text <> "") Then
            
                If IsNumeric(txtDay(i).Text) = False Then
                    MsgBox "�������͐��l����͂��Ă��������B", vbExclamation
                    txtDay(i).SetFocus
                    Exit Sub
                End If
            
                If txtDay(i).Text < 0 Then
                    MsgBox "�������͐�������͂��Ă��������B", vbExclamation
                    txtDay(i).SetFocus
                    Exit Sub
                End If
            
        
                If mintStay = 0 Then
                    
                    If txtDay(i).Text > 0 Then
                        MsgBox "�R�[�X�̔����� " & mintStay & "�ɐݒ肳��Ă��܂��B" & _
                               "�w�肳�ꂽ�������͊i�[���邱�Ƃ��ł��܂���B", vbExclamation
                        txtDay(i).SetFocus
                        Exit Sub
                    End If
                
                Else
            
                    If txtDay(i).Text > mintStay + 1 Then
                        MsgBox "�R�[�X�̔����� " & mintStay & "�ɐݒ肳��Ă��܂��B" & _
                               "�w�肳�ꂽ�������͊i�[���邱�Ƃ��ł��܂���B", vbExclamation
                        txtDay(i).SetFocus
                        Exit Sub
                    End If
                
                End If
            
            End If
        
        Next i

    End If
    

    If chkNoDefine.Value = vbUnchecked Then
        For i = 0 To 6
            If chkToday(i).Value = vbChecked Then
                txtDay(i).Text = "0"
            End If
        Next i
    Else
        For i = 0 To 6
            txtDay(i).Text = ""
        Next i
    End If

    '���t�̃Z�b�g
    mstrMonMng = txtDay(0).Text
    mstrTueMng = txtDay(1).Text
    mstrWedMng = txtDay(2).Text
    mstrThuMng = txtDay(3).Text
    mstrFriMng = txtDay(4).Text
    mstrSatMng = txtDay(5).Text
    mstrSunMng = txtDay(6).Text
    
'    For i = 0 To 6
'        If chkToday(i).Value = vbChecked Then
'            Select Case i
'                Case 0
'                    mstrMonMng = 0
'                Case 1
'                    mstrTueMng = 0
'                Case 2
'                    mstrWedMng = 0
'                Case 3
'                    mstrThuMng = 0
'                Case 4
'                    mstrFriMng = 0
'                Case 5
'                    mstrSatMng = 0
'                Case 6
'                    mstrSunMng = 0
'            End Select
'        End If
'    Next i
    
    mblnUpdated = True
    Unload Me
    
End Sub


Private Sub Form_Load()

    Dim i   As Integer

    mblnUpdated = False
    
    chkNoDefine.Value = vbChecked
    
    '���o���Z�b�g
    lblOpeClassInfo.Caption = mstrOpeClassCd & "�F" & mstrOpeClassName
    
    '�j�����̃Z�b�g
    txtDay(0).Text = mstrMonMng
    txtDay(1).Text = mstrTueMng
    txtDay(2).Text = mstrWedMng
    txtDay(3).Text = mstrThuMng
    txtDay(4).Text = mstrFriMng
    txtDay(5).Text = mstrSatMng
    txtDay(6).Text = mstrSunMng
    
    '�`�F�b�N�{�b�N�X�̐���
    For i = 0 To 6
        If txtDay(i).Text = "0" Then
            chkToday(i).Value = vbChecked
            chkNoDefine.Value = vbUnchecked
        Else
            chkToday(i).Value = vbUnchecked
            If Trim(txtDay(i).Text) <> "" Then
                chkNoDefine.Value = vbUnchecked
            End If
        End If
        Call chkToday_Click(i)
    Next i
    
    Call chkNoDefine_Click
    
End Sub

Friend Property Let OpeClassCd(ByVal vNewValue As Variant)

    mstrOpeClassCd = vNewValue
    
End Property

Friend Property Let OpeClassName(ByVal vNewValue As Variant)

    mstrOpeClassName = vNewValue

End Property

Private Sub txtDay_GotFocus(Index As Integer)

    With txtDay(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Public Property Get MonMng() As String

    MonMng = mstrMonMng
    
End Property

Public Property Let MonMng(ByVal vNewValue As String)

    mstrMonMng = vNewValue
    
End Property

Public Property Get TueMng() As String

    TueMng = mstrTueMng

End Property

Public Property Let TueMng(ByVal vNewValue As String)

    mstrTueMng = vNewValue

End Property

Public Property Get WedMng() As String

    WedMng = mstrWedMng

End Property

Public Property Let WedMng(ByVal vNewValue As String)

    mstrWedMng = vNewValue

End Property

Public Property Get ThuMng() As String

    ThuMng = mstrThuMng

End Property

Public Property Let ThuMng(ByVal vNewValue As String)

    mstrThuMng = vNewValue

End Property

Public Property Get FriMng() As String

    FriMng = mstrFriMng

End Property

Public Property Let FriMng(ByVal vNewValue As String)
    
    mstrFriMng = vNewValue

End Property

Public Property Get SatMng() As String

    SatMng = mstrSatMng

End Property

Public Property Let SatMng(ByVal vNewValue As String)

    mstrSatMng = vNewValue

End Property

Public Property Get SunMng() As String

    SunMng = mstrSunMng

End Property

Public Property Let SunMng(ByVal vNewValue As String)

    mstrSunMng = vNewValue

End Property

Public Property Let Stay(ByVal vNewValue As Variant)

    mintStay = vNewValue

End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated
    
End Property
