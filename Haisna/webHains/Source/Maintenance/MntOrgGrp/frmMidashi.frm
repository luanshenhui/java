VERSION 5.00
Begin VB.Form frmMidashi 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���o���̐ݒ�"
   ClientHeight    =   2595
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2595
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame1 
      Caption         =   "���o������"
      BeginProperty Font 
         Name            =   "�l�r �o�S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1215
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   4455
      Begin VB.TextBox txtMidashi 
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   855
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   120
         MaxLength       =   100
         MultiLine       =   -1  'True
         ScrollBars      =   2  '����
         TabIndex        =   0
         Top             =   240
         Width           =   4215
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   3240
      TabIndex        =   2
      Top             =   2160
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1850
      TabIndex        =   1
      Top             =   2160
      Width           =   1275
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   0
      Left            =   300
      Picture         =   "frmMidashi.frx":0000
      Top             =   180
      Width           =   480
   End
   Begin VB.Label Label1 
      Caption         =   "���o�����ڂ�ݒ肵�܂��B"
      Height          =   255
      Left            =   960
      TabIndex        =   4
      Top             =   360
      Width           =   3315
   End
End
Attribute VB_Name = "frmMidashi"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'##2003.09.11 T-ISHI@FSIT ���o���R�����g�L���p�t�H�[���쐬

Option Explicit

Private mstrrslCaption   As String   '�L�����ꂽ���o������
Private Sub cmdCancel_Click()

    '��ʂ����
    Unload Me
    
End Sub
Private Sub cmdOk_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '���o���R�����g���擾����
    mstrrslCaption = txtMidashi.Text
    
    Screen.MousePointer = vbDefault
          
    '��ʂ����
    Unload Me

End Sub
Public Property Get rslCaption() As Variant

    rslCaption = mstrrslCaption
    
End Property
Public Property Let rslCaption(ByVal vNewValue As Variant)
    
    mstrrslCaption = vNewValue

End Property

Private Sub Form_Load()

    txtMidashi.Text = mstrrslCaption

    Screen.MousePointer = vbDefault
    
End Sub

Private Sub LabelCourseGuide_Click()

End Sub
