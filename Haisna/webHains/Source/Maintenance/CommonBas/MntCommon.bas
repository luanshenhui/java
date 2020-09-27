Attribute VB_Name = "MntCommon"
Option Explicit


' @(e)
'
' 機能　　 : フォームコントロールの初期化
'
' 引数　　 : (In)      TargetForm  コントロールを初期化するForm
'
' 機能説明 : フォーム上のコントロールを初期化する
'
' 備考　　 :
'
Public Sub InitFormControls(TargetForm As Form, colGotFocusCollection As Collection)

    Dim Ctrl            As Object
    Dim i               As Integer
    Dim objTxtGotFocus  As TextGotFocus
    
    If TargetForm Is Nothing Then Exit Sub
    
    Set colGotFocusCollection = New Collection
    
    ''各コントロールの設定値をクリアする
    For Each Ctrl In TargetForm.Controls
        
        '''テキストボックス
        If TypeOf Ctrl Is TextBox Then
            Ctrl.Text = Empty
            Ctrl.ToolTipText = Empty
            Ctrl.BackColor = vbWindowBackground
        
            Set objTxtGotFocus = New TextGotFocus
            objTxtGotFocus.TargetTextBox = Ctrl
            colGotFocusCollection.Add objTxtGotFocus
        End If
        
        '''コンボボックス
        If TypeOf Ctrl Is ComboBox Then
            Ctrl.Clear
            Ctrl.ToolTipText = Empty
        End If
        
        '''ラベル（項目表示用のみ）
        If TypeOf Ctrl Is Label Then
            If Left(Ctrl.Name, 3) = "lbl" Then
                Ctrl.Caption = Empty
            End If
        End If
        
        '''チェックボックス
        If TypeOf Ctrl Is CheckBox Then
            Ctrl.Value = vbUnchecked
        End If
    Next

End Sub
' @(e)
'
' 機能　　 : コードの分割
'
' 引数　　 : (In)   strTargetKey    ハイフン付きの項目コード
' 　　　　 : (Out)  strItem1        検査項目コード
' 　　　　 : (Out)  strItem2        サフィックス
' 　　　　 : (In)   intStartPoint   検索開始位置（省略可）
'
' 機能説明 : リストビューの一意キーの為にセットしたハイフン付きのコードを分割する
'
' 備考　　 :
'
Public Sub SplitItemAndSuffix(strTargetKey As String, _
                              strItem1 As String, _
                              strItem2 As String, _
                              Optional intStartPoint As Integer)

    Dim lngPointer  As Long     'ハイフン位置検出用ポインター
        
    '初期化
    strTargetKey = Trim(strTargetKey)
    strItem1 = ""
    strItem2 = ""
        
    'キーが指定されていないなら処理終了
    If strTargetKey = "" Then Exit Sub
    
    '開始位置が指定されていないなら１セット
    If intStartPoint = 0 Then
        intStartPoint = 1
    End If
    
    '分割
    lngPointer = InStr(intStartPoint, strTargetKey, "-")
    If lngPointer <> 0 Then
        strItem1 = Mid(strTargetKey, 1, lngPointer - 1)
        strItem2 = Mid(strTargetKey, lngPointer + 1, Len(strTargetKey))
    End If

End Sub

' @(e)
'
' 機能　　 : 項目の存在チェック
'
' 引数　　 : (In)      TargetListView  チェックするリストビュー
' 　　　　 : (In)      strKey          (リストアイテムの)アイテムキー
'
' 戻り値　 : TRUE:存在します、FALSE:存在しません
'
' 機能説明 : 指定されたキーがリストアイテム上に存在するかチェックする。
'
' 備考　　 :
'
Public Function CheckExistsItemCd(TargetListView As Object, strKey As String) As Boolean

On Error GoTo ErrorHandle
    
'    Dim objTestItems    As ListItem
    Dim objTestItems    As Object

    CheckExistsItemCd = False
    
    '指定されたキー値でオブジェクト作成（なければError Raise)
    Set objTestItems = TargetListView.ListItems(strKey)
    
    CheckExistsItemCd = True
    Exit Function
    
ErrorHandle:
    CheckExistsItemCd = False
    
End Function

' @(e)
'
' 機能　　 : 検索用文字列コンボの初期化
'
' 引数　　 : (In)      objTargetCombo  セットするコンボボックス
'
' 機能説明 : 引数のコンボボックスに初期状態の文字列をセット
'
' 備考　　 :
'
Public Sub InitSearchCharCombo(objTargetCombo As ComboBox)
    
    Dim i As Integer
    
    With objTargetCombo
        
        '英文字セット
        For i = 65 To 90
            .AddItem Chr(i)
        Next i
        
        'かなセット
        .AddItem "あ"
        .AddItem "か"
        .AddItem "さ"
        .AddItem "た"
        .AddItem "な"
        .AddItem "は"
        .AddItem "ま"
        .AddItem "や"
        .AddItem "ら"
        .AddItem "わ"
    
        '数値セット
        For i = 0 To 10
            .AddItem i
        Next i
        
        .AddItem "その他"
        .ListIndex = objTargetCombo.NewIndex
    
    End With

End Sub

