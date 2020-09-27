VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TextGotFocus"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public WithEvents txtGotFocus  As TextBox
Attribute txtGotFocus.VB_VarHelpID = -1

Private Sub txtGotFocus_GotFocus()

    With txtGotFocus
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
    
End Sub

Friend Property Let TargetTextBox(ByVal vNewValue As TextBox)

'テキストボックスの配列有無をとるためにわざとこんな感じ
On Error Resume Next

    Set txtGotFocus = vNewValue
    
End Property
