VERSION 5.00
Begin VB.Form frmAbout 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "webHains システム環境設定のバージョン情報"
   ClientHeight    =   2355
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6585
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmAbout.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2355
   ScaleWidth      =   6585
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.CommandButton s 
      Cancel          =   -1  'True
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   345
      Left            =   5040
      TabIndex        =   0
      Tag             =   "OK"
      Top             =   1860
      Width           =   1467
   End
   Begin VB.Label Label1 
      Caption         =   "All rights reserved, Copyright(C) Fujitsu Limited 2001-2002"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   1200
      TabIndex        =   4
      Tag             =   "ﾊﾞｰｼﾞｮﾝ"
      Top             =   1380
      Width           =   5175
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   240
      Picture         =   "frmAbout.frx":0442
      Top             =   180
      Width           =   480
   End
   Begin VB.Label lblTitle 
      Caption         =   "webHains システム環境設定"
      ForeColor       =   &H00000000&
      Height          =   240
      Left            =   1080
      TabIndex        =   3
      Tag             =   "ｱﾌﾟﾘｹｰｼｮﾝ ﾀｲﾄﾙ"
      Top             =   300
      Width           =   4095
   End
   Begin VB.Label lblVersion 
      Caption         =   "Version 1.0.0"
      Height          =   525
      Left            =   1200
      TabIndex        =   2
      Tag             =   "ﾊﾞｰｼﾞｮﾝ"
      Top             =   720
      Width           =   5235
   End
   Begin VB.Label lblDisclaimer 
      Caption         =   "警告: ..."
      ForeColor       =   &H00000000&
      Height          =   225
      Left            =   120
      TabIndex        =   1
      Tag             =   "警告: ..."
      Top             =   2040
      Visible         =   0   'False
      Width           =   750
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
    
    Unload Me
    
End Sub

Private Sub Form_Load()

    Dim strAppPath      As String
    
    lblVersion.Caption = "Version " & App.Major & "." & App.Minor & "." & App.Revision
    strAppPath = App.Path & "\" & App.EXEName & ".exe"
    If Dir(strAppPath) <> "" Then
        lblVersion.Caption = lblVersion.Caption & vbLf & "( LastUpdated : " & FileDateTime(strAppPath) & " )"
    End If
    
'    lblDisclaimer.Caption = "警告: この製品は､日本国著作権法および国際条約により保護されています｡この製品の全部または一部を無断で複製したり､無断で複製物を頒布すると､著作権の侵害となりますのでご注意ください｡"

End Sub

