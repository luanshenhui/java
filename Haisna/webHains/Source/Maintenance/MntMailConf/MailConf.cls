VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MailConf"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.3
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

Private mblnUpdated As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmMailConf
    
    '予約メール送信基本設定画面をロード
    Set objForm = New frmMailConf
    Load objForm
    
    Do
        '表示不能時は画面を閉じる
        If objForm.Initialize = False Then
            Unload objForm
            Exit Do
        End If
        
        '画面表示（モーダル以外では機能できない戻り値がとれない）
        objForm.Show vbModal
        mblnUpdated = objForm.Updated
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

