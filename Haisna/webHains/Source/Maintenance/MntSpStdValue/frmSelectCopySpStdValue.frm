VERSION 5.00
Begin VB.Form frmSelectCopySpStdValue 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���茒�f��l�����f�[�^�I��"
   ClientHeight    =   1845
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7185
   Icon            =   "frmSelectCopySpStdValue.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1845
   ScaleWidth      =   7185
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.ComboBox cboHistory 
      Height          =   300
      ItemData        =   "frmSelectCopySpStdValue.frx":000C
      Left            =   1080
      List            =   "frmSelectCopySpStdValue.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   2
      Top             =   780
      Width           =   5370
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5700
      TabIndex        =   1
      Top             =   1380
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4260
      TabIndex        =   0
      Top             =   1380
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�R�s�[�����l������I�����Ă��������B"
      Height          =   315
      Left            =   1080
      TabIndex        =   3
      Top             =   300
      Width           =   4875
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   240
      Picture         =   "frmSelectCopySpStdValue.frx":0050
      Top             =   180
      Width           =   480
   End
End
Attribute VB_Name = "frmSelectCopySpStdValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mblnUpdated             As Boolean
Private mcolHistoryCollection   As Collection
Private mintIndex               As Integer

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    mintIndex = cboHistory.ListIndex + 1

    mblnUpdated = True
    Unload Me

End Sub

Private Sub Form_Load()

    Dim i   As Integer
    Dim objHistory  As SpStdValue_Record

    '������
    mintIndex = 0
    cboHistory.Clear

    '�v���p�e�B�œn���ꂽ�R���N�V�������R���{�Z�b�g
    With mcolHistoryCollection
        For i = 1 To .Count
            Set objHistory = mcolHistoryCollection(i)
            '�z��쐬
            If Trim(objHistory.CsName) = "" Then
                cboHistory.AddItem CStr(objHistory.strDate) & "�`" & CStr(objHistory.endDate) & "�ɓK�p����f�[�^"
            Else
                cboHistory.AddItem CStr(objHistory.strDate) & "�`" & CStr(objHistory.endDate) & "�i" & objHistory.CsName & "�j�ɓK�p����f�[�^"
            End If
        Next i
    End With

    cboHistory.ListIndex = 0
    mblnUpdated = False
    
End Sub

Friend Property Let HistoryCollection(ByVal vNewValue As Collection)

    Set mcolHistoryCollection = vNewValue
    
End Property

Public Property Get Index() As Integer

    Index = mintIndex
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
