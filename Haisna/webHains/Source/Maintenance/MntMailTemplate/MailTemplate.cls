VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MailTemplate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.4
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

Private mstrTemplateCd  As String   'テンプレートコード
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly    As Boolean  'TRUE:データの更新をしない（参照のみ）

Public Property Get TemplateCd() As Variant

    TemplateCd = mstrTemplateCd
    
End Property

Public Property Let TemplateCd(ByVal vntNewValue As Variant)

    mstrTemplateCd = vntNewValue
    
End Property

Public Property Let ShowOnly(ByVal vntNewValue As Boolean)

    mblnShowOnly = vntNewValue
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmMailTemplate
    
    'メールテンプレートテーブルメンテナンス画面をロード
    Set objForm = New frmMailTemplate
    
    With objForm
        .TemplateCd = mstrTemplateCd
        .ShowOnly = mblnShowOnly
    End With
    
    Load objForm
    
    Do
        '表示不能時は画面を閉じる
        If objForm.Initialize = False Then
            Unload objForm
            Exit Do
        End If
        
        '画面表示
        objForm.Show lngStyle
        mblnUpdated = objForm.Updated
        
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub
