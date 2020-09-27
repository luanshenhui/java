VERSION 5.00
Begin VB.Form frmNutriFoodEnergy 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "食品群別摂取テーブルメンテナンス"
   ClientHeight    =   3765
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3615
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmNutriFoodEnergy.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3765
   ScaleWidth      =   3615
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Index           =   6
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   15
      Text            =   "9999"
      Top             =   2640
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Index           =   5
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   13
      Text            =   "9999"
      Top             =   2280
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Index           =   4
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   11
      Text            =   "9999"
      Top             =   1920
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Index           =   3
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   9
      Text            =   "9999"
      Top             =   1560
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Index           =   2
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   7
      Text            =   "9999"
      Top             =   1200
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Index           =   1
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   5
      Text            =   "9999"
      Top             =   840
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Index           =   0
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   3
      Text            =   "9999"
      Top             =   480
      Width           =   615
   End
   Begin VB.TextBox txtEnergy 
      Height          =   300
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   1
      Text            =   "9999"
      Top             =   120
      Width           =   615
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   480
      TabIndex        =   16
      Top             =   3180
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   1920
      TabIndex        =   17
      Top             =   3180
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "食品群７(&7)："
      Height          =   180
      Index           =   7
      Left            =   420
      TabIndex        =   14
      Top             =   2700
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "食品群６(&6)："
      Height          =   180
      Index           =   6
      Left            =   420
      TabIndex        =   12
      Top             =   2340
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "食品群５(&5)："
      Height          =   180
      Index           =   5
      Left            =   420
      TabIndex        =   10
      Top             =   1980
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "食品群４(&4)："
      Height          =   180
      Index           =   4
      Left            =   420
      TabIndex        =   8
      Top             =   1620
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "食品群３(&3)："
      Height          =   180
      Index           =   3
      Left            =   420
      TabIndex        =   6
      Top             =   1245
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "食品群２(&2)："
      Height          =   180
      Index           =   2
      Left            =   420
      TabIndex        =   4
      Top             =   885
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "食品群１(&1)："
      Height          =   180
      Index           =   1
      Left            =   420
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "エネルギー(&C)："
      Height          =   180
      Index           =   0
      Left            =   420
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmNutriFoodEnergy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrEnergy      As String   'エネルギー
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let Energy(ByVal vntNewValue As Variant)

    mstrEnergy = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

'
' 機能　　 : 入力データチェック
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常データ、FALSE:異常データあり
'
' 備考　　 :
'
Private Function CheckValue() As Boolean

    Dim Ret As Boolean  '関数戻り値
    Dim i   As Long
    
    Ret = False
    
    Do
        
        'コードの入力チェック
        If Trim(txtEnergy.Text) = "" Then
            MsgBox "エネルギーが入力されていません。", vbCritical, App.Title
            txtEnergy.SetFocus
            Exit Do
        End If

        For i = 0 To 6
            If (Trim(txtFoodGrp(i)) = "") Or (IsNumeric(txtFoodGrp(i)) = False) Then
                MsgBox "食品群" & (i) & "のエネルギーが正しく設定されていません。", vbCritical, App.Title
                txtFoodGrp(i).SetFocus
                Exit Do
            End If
        
        Next i

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

'
' 機能　　 : データ表示用編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditNutriFoodEnergy() As Boolean

    Dim objNutriFoodEnergy  As Object           '食品群別摂取テーブルアクセス用
    Dim vntFoodGrp1         As Variant          '食品群１
    Dim vntFoodGrp2         As Variant          '食品群２
    Dim vntFoodGrp3         As Variant          '食品群２
    Dim vntFoodGrp4         As Variant          '食品群２
    Dim vntFoodGrp5         As Variant          '食品群２
    Dim vntFoodGrp6         As Variant          '食品群２
    Dim vntFoodGrp7         As Variant          '食品群２
    Dim Ret                 As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objNutriFoodEnergy = CreateObject("HainsNourishment.Nourishment")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrEnergy = "" Then
            Ret = True
            Exit Do
        End If
        
        '食品群別摂取テーブルレコード読み込み
        If objNutriFoodEnergy.SelectNutriFoodEnergy(mstrEnergy, , vntFoodGrp1, vntFoodGrp2, vntFoodGrp3, vntFoodGrp4, vntFoodGrp5, vntFoodGrp6, vntFoodGrp7) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtEnergy.Text = mstrEnergy
        txtFoodGrp(0).Text = vntFoodGrp1(0)
        txtFoodGrp(1).Text = vntFoodGrp2(0)
        txtFoodGrp(2).Text = vntFoodGrp3(0)
        txtFoodGrp(3).Text = vntFoodGrp4(0)
        txtFoodGrp(4).Text = vntFoodGrp5(0)
        txtFoodGrp(5).Text = vntFoodGrp6(0)
        txtFoodGrp(6).Text = vntFoodGrp7(0)
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditNutriFoodEnergy = Ret
    
    Exit Function

ErrorHandle:

    EditNutriFoodEnergy = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : データ登録
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function RegistNutriFoodEnergy() As Boolean

On Error GoTo ErrorHandle

    Dim objNutriFoodEnergy      As Object       '食品群別摂取アクセス用
    Dim Ret                     As Long
    
    'オブジェクトのインスタンス作成
    Set objNutriFoodEnergy = CreateObject("HainsNourishment.Nourishment")
    
    '食品群別摂取テーブルレコードの登録
    Ret = objNutriFoodEnergy.RegistNutriFoodEnergy(IIf(txtEnergy.Enabled, "INS", "UPD"), _
                                                   Trim(txtEnergy.Text), _
                                                   Trim(txtFoodGrp(0).Text), _
                                                   Trim(txtFoodGrp(1).Text), _
                                                   Trim(txtFoodGrp(2).Text), _
                                                   Trim(txtFoodGrp(3).Text), _
                                                   Trim(txtFoodGrp(4).Text), _
                                                   Trim(txtFoodGrp(5).Text), _
                                                   Trim(txtFoodGrp(6).Text))

    If Ret = 0 Then
        MsgBox "入力されたエネルギーデータは既に存在します。", vbExclamation
        RegistNutriFoodEnergy = False
        Exit Function
    End If
    
    RegistNutriFoodEnergy = True
    
    Exit Function
    
ErrorHandle:

    RegistNutriFoodEnergy = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : 「キャンセル」Click
'
' 機能説明 : フォームを閉じる
'
' 備考　　 :
'
Private Sub CMDcancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : 「ＯＫ」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用し、画面を閉じる
'
' 備考　　 :
'
Private Sub CMDok_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    Do
        '入力チェック
        If CheckValue() = False Then
            Exit Do
        End If
        
        '食品群別摂取テーブルの登録
        If RegistNutriFoodEnergy() = False Then
            Exit Do
        End If
            
        '更新済みフラグをTRUEに
        mblnUpdated = True
    
        '画面を閉じる
        Unload Me
        
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' 機能　　 : 「フォーム」Load
'
' 機能説明 : フォームの初期表示を行う
'
' 備考　　 :
'
Private Sub Form_Load()

    Dim Ret As Boolean  '戻り値
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        '食品群別摂取情報の編集
        If EditNutriFoodEnergy() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtEnergy.Enabled = (txtEnergy.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

