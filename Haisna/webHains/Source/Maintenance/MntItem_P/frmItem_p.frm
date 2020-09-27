VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmItem_P 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "依頼項目メンテナンス"
   ClientHeight    =   6810
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7470
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItem_p.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6810
   ScaleWidth      =   7470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6000
      TabIndex        =   30
      Top             =   6360
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4560
      TabIndex        =   29
      Top             =   6360
      Width           =   1335
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   6075
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   7215
      _ExtentX        =   12726
      _ExtentY        =   10716
      _Version        =   393216
      Style           =   1
      Tab             =   2
      TabHeight       =   520
      TabCaption(0)   =   "基本情報"
      TabPicture(0)   =   "frmItem_p.frx":000C
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "fraMain(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "オーダ送信情報"
      TabPicture(1)   =   "frmItem_p.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraMain(1)"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "請求情報"
      TabPicture(2)   =   "frmItem_p.frx":0044
      Tab(2).ControlEnabled=   -1  'True
      Tab(2).Control(0)=   "Frame3"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).ControlCount=   1
      Begin VB.Frame Frame3 
         Height          =   3435
         Left            =   240
         TabIndex        =   36
         Top             =   420
         Visible         =   0   'False
         Width           =   6795
         Begin VB.CommandButton cmdItem_P_Price 
            Caption         =   "団体、健保毎の単価を設定する(&M)..."
            Height          =   375
            Left            =   2400
            TabIndex        =   43
            Top             =   360
            Width           =   2955
         End
         Begin VB.ComboBox cboRoundClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":0060
            Left            =   2400
            List            =   "frmItem_p.frx":0082
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   40
            Top             =   2340
            Width           =   4230
         End
         Begin VB.ComboBox cboIsrDmdLineClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":00A4
            Left            =   2400
            List            =   "frmItem_p.frx":00C6
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   39
            Top             =   1380
            Width           =   4230
         End
         Begin VB.ComboBox cboDmdLineClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":00E8
            Left            =   2400
            List            =   "frmItem_p.frx":010A
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   37
            Top             =   1020
            Width           =   4230
         End
         Begin VB.Label Label3 
            Caption         =   "項目単価設定(&P):"
            Height          =   195
            Index           =   9
            Left            =   240
            TabIndex        =   44
            Top             =   480
            Width           =   1575
         End
         Begin VB.Label Label3 
            Caption         =   "健保向け請求分類(&I):"
            Height          =   195
            Index           =   7
            Left            =   180
            TabIndex        =   42
            Top             =   1440
            Width           =   1815
         End
         Begin VB.Label Label3 
            Caption         =   "まるめ分類(&R):"
            Height          =   195
            Index           =   8
            Left            =   180
            TabIndex        =   41
            Top             =   2400
            Width           =   1635
         End
         Begin VB.Label Label3 
            Caption         =   "一般団体向け請求分類(&O):"
            Height          =   195
            Index           =   6
            Left            =   180
            TabIndex        =   38
            Top             =   1080
            Width           =   2115
         End
      End
      Begin VB.Frame fraMain 
         Height          =   2895
         Index           =   1
         Left            =   -74760
         TabIndex        =   28
         Top             =   420
         Visible         =   0   'False
         Width           =   6795
         Begin VB.TextBox txtDocCd 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1980
            MaxLength       =   4
            TabIndex        =   25
            Text            =   "1234"
            Top             =   1440
            Width           =   795
         End
         Begin VB.TextBox txtOrderFileName 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1980
            MaxLength       =   20
            TabIndex        =   27
            Text            =   "1234567"
            Top             =   1860
            Width           =   4575
         End
         Begin VB.Label Label3 
            Caption         =   "文書種別コード(&B):"
            Height          =   195
            Index           =   5
            Left            =   300
            TabIndex        =   24
            Top             =   1500
            Width           =   1515
         End
         Begin VB.Label lblOrderDoc 
            Caption         =   "Label2"
            Height          =   675
            Left            =   360
            TabIndex        =   35
            Top             =   420
            Width           =   5955
         End
         Begin VB.Label Label3 
            Caption         =   "オーダファイル名(&O):"
            Height          =   195
            Index           =   4
            Left            =   300
            TabIndex        =   26
            Top             =   1920
            Width           =   1515
         End
      End
      Begin VB.Frame fraMain 
         Height          =   5355
         Index           =   0
         Left            =   -74760
         TabIndex        =   31
         Top             =   420
         Width           =   6795
         Begin VB.Frame Frame1 
            Height          =   1215
            Left            =   1980
            TabIndex        =   33
            Top             =   2940
            Width           =   4635
            Begin VB.OptionButton optEntryOk 
               Caption         =   "１つでも結果がセットされたら入力完了(&1)"
               Height          =   255
               Index           =   0
               Left            =   180
               TabIndex        =   15
               ToolTipText     =   "この依頼項目が管理する検査項目に一つでも結果がセットされた場合、入力完了とします。"
               Top             =   240
               Value           =   -1  'True
               Width           =   3855
            End
            Begin VB.OptionButton optEntryOk 
               Caption         =   "全ての項目に結果がセットされたら入力完了(&2)"
               Height          =   255
               Index           =   1
               Left            =   180
               TabIndex        =   16
               ToolTipText     =   "この依頼項目が管理する検査項目全てに結果がセットされないと入力完了とみなしません。"
               Top             =   540
               Width           =   4155
            End
            Begin VB.OptionButton optEntryOk 
               Caption         =   "未入力チェックをしない(&3)"
               Height          =   255
               Index           =   2
               Left            =   180
               TabIndex        =   17
               ToolTipText     =   "未入力チェックを行いません"
               Top             =   840
               Width           =   2115
            End
         End
         Begin VB.ComboBox cboItemClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":012C
            Left            =   1980
            List            =   "frmItem_p.frx":014E
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   10
            Top             =   1800
            Width           =   4665
         End
         Begin VB.TextBox txtItemCd 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1980
            MaxLength       =   6
            TabIndex        =   2
            Text            =   "@@@@@@"
            Top             =   360
            Width           =   855
         End
         Begin VB.TextBox txtRequestName 
            Height          =   300
            IMEMode         =   4  '全角ひらがな
            Left            =   1980
            MaxLength       =   20
            TabIndex        =   6
            Text            =   "＠＠＠＠＠＠＠＠＠＠"
            Top             =   840
            Width           =   2055
         End
         Begin VB.TextBox txtRequestSName 
            Height          =   300
            IMEMode         =   4  '全角ひらがな
            Left            =   1980
            MaxLength       =   10
            TabIndex        =   8
            Text            =   "＠＠＠＠＠"
            Top             =   1200
            Width           =   1035
         End
         Begin VB.ComboBox cboProgress 
            Height          =   300
            ItemData        =   "frmItem_p.frx":0170
            Left            =   1980
            List            =   "frmItem_p.frx":0192
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   12
            Top             =   2160
            Width           =   4650
         End
         Begin VB.ComboBox cboSearchChar 
            Height          =   300
            ItemData        =   "frmItem_p.frx":01B4
            Left            =   1980
            List            =   "frmItem_p.frx":01D6
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   19
            Top             =   4260
            Width           =   810
         End
         Begin VB.ComboBox cboOpeClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":01F8
            Left            =   1980
            List            =   "frmItem_p.frx":021A
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   14
            Top             =   2520
            Visible         =   0   'False
            Width           =   4650
         End
         Begin VB.Frame Frame2 
            Height          =   495
            Left            =   2940
            TabIndex        =   32
            Top             =   240
            Width           =   3375
            Begin VB.OptionButton optRslQue 
               Caption         =   "検査項目(&K)"
               Height          =   255
               Index           =   0
               Left            =   180
               TabIndex        =   3
               Top             =   180
               Value           =   -1  'True
               Width           =   1275
            End
            Begin VB.OptionButton optRslQue 
               Caption         =   "問診項目(&M)"
               Height          =   255
               Index           =   1
               Left            =   1620
               TabIndex        =   4
               Top             =   180
               Width           =   1275
            End
         End
         Begin VB.TextBox txtPrice2 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   5700
            MaxLength       =   7
            TabIndex        =   23
            Text            =   "1234567"
            Top             =   4260
            Visible         =   0   'False
            Width           =   795
         End
         Begin VB.TextBox txtPrice1 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   3840
            MaxLength       =   7
            TabIndex        =   21
            Text            =   "1234567"
            Top             =   4260
            Visible         =   0   'False
            Width           =   795
         End
         Begin VB.Label Label8 
            Caption         =   "検査項目コード(&C):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   1
            Top             =   420
            Width           =   1455
         End
         Begin VB.Label Label1 
            Caption         =   "依頼項目名(&N):"
            Height          =   180
            Index           =   1
            Left            =   300
            TabIndex        =   5
            Top             =   900
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "依頼項目略称(&R):"
            Height          =   180
            Index           =   3
            Left            =   300
            TabIndex        =   7
            Top             =   1260
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "検査分類(&L):"
            Height          =   180
            Index           =   4
            Left            =   300
            TabIndex        =   9
            Top             =   1860
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "進捗分類(&P):"
            Height          =   180
            Index           =   5
            Left            =   300
            TabIndex        =   11
            Top             =   2220
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "未入力チェック:"
            Height          =   180
            Index           =   6
            Left            =   300
            TabIndex        =   34
            Top             =   3120
            Width           =   1350
         End
         Begin VB.Label Label3 
            Caption         =   "検索用文字列(&S):"
            Height          =   195
            Index           =   2
            Left            =   300
            TabIndex        =   18
            Top             =   4320
            Width           =   1395
         End
         Begin VB.Label Label3 
            Caption         =   "検査実施日分類(&J):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   13
            Top             =   2580
            Visible         =   0   'False
            Width           =   1635
         End
         Begin VB.Label Label3 
            Caption         =   "基本料金２(&2):"
            Height          =   195
            Index           =   1
            Left            =   4500
            TabIndex        =   22
            Top             =   4320
            Visible         =   0   'False
            Width           =   1095
         End
         Begin VB.Label Label3 
            Caption         =   "基本料金１(&1):"
            Height          =   195
            Index           =   3
            Left            =   2820
            TabIndex        =   20
            Top             =   4320
            Visible         =   0   'False
            Width           =   1095
         End
      End
   End
End
Attribute VB_Name = "frmItem_P"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd                  As String   '検査項目コード
Private mblnInitialize              As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated                 As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mstrRootClassCd()           As String   'コンボボックスに対応する検査分類コードの格納
Private mstrRootProgressCd()        As String   'コンボボックスに対応する進捗分類コードの格納
Private mstrRootOpeClassCd()        As String   'コンボボックスに対応する検査実施日分類コードの格納

Private mstrRootDmdLineClassCd()    As String   'コンボボックスに対応する請求明細分類（一般）コードの格納
Private mstrRootIsrDmdLineClassCd() As String   'コンボボックスに対応する請求明細分類（団体）コードの格納
Private mstrRootRoundClassCd()      As String   'コンボボックスに対応する請求明細分類コードの格納

Private mintDetailMaxKey            As Integer      '細情報のリストビューキーをユニークにするために保持
Private mcolGotFocusCollection      As Collection   'GotFocus時の文字選択用コレクション

Const mstrListViewKey               As String = "K"
Friend Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
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
    
    Ret = False
    
    Do
        
        'コードはとりみんぐ
        txtItemCd.Text = Trim(txtItemCd.Text)
        
        'コードの入力チェック
        If txtItemCd.Text = "" Then
            MsgBox "検査項目コードが入力されていません。", vbExclamation, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        'コードのハイフンチェック
        If InStr(txtItemCd.Text, "-") > 0 Then
            MsgBox "検査項目コードにハイフンを含めることはできません。", vbExclamation, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        '名称の入力チェック
        If Trim(txtRequestName.Text) = "" Then
            MsgBox "依頼項目名が入力されていません。", vbExclamation, App.Title
            txtRequestName.SetFocus
            Exit Do
        End If
        
        '略称の入力チェック
        If Trim(txtRequestSName.Text) = "" Then
            txtRequestSName.Text = Mid(Trim(txtRequestName.Text), 1, 5)
        End If
        
'### 2003/11/23 Deleted by Ishihara@FSIT 不要項目の削除
'        金額1の入力チェック
'        If Trim(txtPrice1.Text) = "" Then
'            txtPrice1.Text = 0
'        End If
'
'        金額1の数値チェック
'        If IsNumeric(Trim(txtPrice1.Text)) = False Then
'            MsgBox "金額１には数値を入力してください。", vbExclamation, App.Title
'            txtPrice1.SetFocus
'            Exit Do
'        End If
'
'        金額2の入力チェック
'        If Trim(txtPrice2.Text) = "" Then
'            txtPrice2.Text = 0
'        End If
'
'        金額2の数値チェック
'        If IsNumeric(Trim(txtPrice2.Text)) = False Then
'            MsgBox "金額２には数値を入力してください。", vbExclamation, App.Title
'            txtPrice2.SetFocus
'            Exit Do
'        End If
'
'        '請求分類は両方一度に登録する。
'        If (cboDmdLineClass.ListIndex = 0) And (cboIsrDmdLineClass.ListIndex <> 0) Then
'            tabMain.Tab = 2
'            cboDmdLineClass.SetFocus
'            MsgBox "請求分類を設定する場合は、必ず両方設定してください。", vbExclamation, App.Title
'            Exit Do
'        End If
'
'        If (cboDmdLineClass.ListIndex <> 0) And (cboIsrDmdLineClass.ListIndex = 0) Then
'            tabMain.Tab = 2
'            cboIsrDmdLineClass.SetFocus
'            MsgBox "請求分類を設定する場合は、必ず両方設定してください。", vbExclamation, App.Title
'            Exit Do
'        End If
'### 2003/11/23 Deleted End

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function



' @(e)
'
' 機能　　 : 検査分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditItemClassConbo() As Boolean

    Dim objItemClass        As Object   '検査分類アクセス用
    Dim vntClassCd      As Variant
    Dim vntItemClassName    As Variant
    Dim lngCount            As Long     'レコード数
    Dim i                   As Long     'インデックス
    
    EditItemClassConbo = False
    
    cboItemClass.Clear
    Erase mstrRootClassCd

    'オブジェクトのインスタンス作成
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntClassCd, vntItemClassName)
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootClassCd(i)
        mstrRootClassCd(i) = vntClassCd(i)
        cboItemClass.AddItem vntItemClassName(i)
    Next i
    
    'データが存在しないなら、エラー
    If lngCount <= 0 Then
        MsgBox "検査分類が存在しません。検査分類データを登録しないと依頼項目設定を行うことはできません。", vbExclamation
        Exit Function
    End If
    
    '先頭コンボを選択状態にする
    cboItemClass.ListIndex = 0
    EditItemClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' 機能　　 : 請求明細分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 請求明細分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditDmdLineClassConbo() As Boolean

    Dim objDmdLineClass     As Object   '検査実施日分類アクセス用
    Dim vntDmdLineClassCd   As Variant
    Dim vntDmdLineClassName As Variant
    Dim vntIsrFlg           As Variant
    
    Dim lngCount            As Long     'レコード数
    Dim i                   As Long     'インデックス
    Dim j                   As Long     'インデックス
    Dim k                   As Long     'インデックス
    
    EditDmdLineClassConbo = False
    
    cboDmdLineClass.Clear
    cboIsrDmdLineClass.Clear
    Erase mstrRootDmdLineClassCd
    Erase mstrRootIsrDmdLineClassCd

    'オブジェクトのインスタンス作成
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    lngCount = objDmdLineClass.SelectDmdLineClassItemList(vntDmdLineClassCd, vntDmdLineClassName, , vntIsrFlg)
    
    '請求明細分類は未指定あり
    ReDim Preserve mstrRootDmdLineClassCd(0)
    ReDim Preserve mstrRootIsrDmdLineClassCd(0)
    mstrRootDmdLineClassCd(0) = ""
    mstrRootIsrDmdLineClassCd(0) = ""
    
    cboDmdLineClass.AddItem ""
    cboIsrDmdLineClass.AddItem ""
    cboDmdLineClass.ListIndex = 0
    cboIsrDmdLineClass.ListIndex = 0
    
    'コンボボックスの編集
    j = 1
    k = 1
    For i = 0 To lngCount - 1
        
        Select Case vntIsrFlg(i)
            Case ""
                ReDim Preserve mstrRootDmdLineClassCd(j)
                mstrRootDmdLineClassCd(j) = vntDmdLineClassCd(i)
                cboDmdLineClass.AddItem vntDmdLineClassName(i)
                j = j + 1
            
                ReDim Preserve mstrRootIsrDmdLineClassCd(k)
                mstrRootIsrDmdLineClassCd(k) = vntDmdLineClassCd(i)
                cboIsrDmdLineClass.AddItem vntDmdLineClassName(i)
                k = k + 1
            
            Case "0"
                ReDim Preserve mstrRootDmdLineClassCd(j)
                mstrRootDmdLineClassCd(j) = vntDmdLineClassCd(i)
                cboDmdLineClass.AddItem vntDmdLineClassName(i)
                j = j + 1
            
            Case "1"
                ReDim Preserve mstrRootIsrDmdLineClassCd(k)
                mstrRootIsrDmdLineClassCd(k) = vntDmdLineClassCd(i)
                cboIsrDmdLineClass.AddItem vntDmdLineClassName(i)
                k = k + 1
        End Select
        
    Next i
    
    'データが存在しないなら、処理終了（請求分類の未登録はエラーではない）
    If lngCount <= 0 Then
        EditDmdLineClassConbo = True
        Exit Function
    End If
    
    EditDmdLineClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' 機能　　 : まるめ分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : まるめ分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditRoundClassConbo() As Boolean

    Dim objRoundClass       As Object   'まるめ分類アクセス用
    Dim vntRoundClassCd     As Variant
    Dim vntRoundClassName   As Variant
    Dim vntIsrFlg           As Variant
    
    Dim lngCount            As Long     'レコード数
    Dim i                   As Long     'インデックス
    
    EditRoundClassConbo = False
    
    cboRoundClass.Clear
    Erase mstrRootRoundClassCd

    'オブジェクトのインスタンス作成
    Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")
    lngCount = objRoundClass.SelectRoundClassList(vntRoundClassCd, vntRoundClassName)
    
    '請求明細分類は未指定あり
    ReDim Preserve mstrRootRoundClassCd(0)
    mstrRootRoundClassCd(0) = ""
    cboRoundClass.AddItem ""
    cboRoundClass.ListIndex = 0
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        
        ReDim Preserve mstrRootRoundClassCd(i + 1)
        mstrRootRoundClassCd(i + 1) = vntRoundClassCd(i)
        cboRoundClass.AddItem vntRoundClassName(i)
        
    Next i
    
    'データが存在しないなら、処理終了（まるめ分類の未登録はエラーではない）
    If lngCount <= 0 Then
        EditRoundClassConbo = True
        Exit Function
    End If
    
    EditRoundClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' 機能　　 : 検査実施日分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査実施日分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditOpeClassConbo() As Boolean

    Dim objOpeClass     As Object   '検査実施日分類アクセス用
    Dim vntOpeClassCd   As Variant
    Dim vntOpeClassName As Variant
    Dim lngCount        As Long     'レコード数
    Dim i               As Long     'インデックス
    
    EditOpeClassConbo = False
    
    cboOpeClass.Clear
    Erase mstrRootOpeClassCd

    'オブジェクトのインスタンス作成
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    lngCount = objOpeClass.SelectOpeClassList(vntOpeClassCd, vntOpeClassName)
    
    '検査実施日分類は未指定あり
    ReDim Preserve mstrRootOpeClassCd(0)
    mstrRootOpeClassCd(0) = ""
    cboOpeClass.AddItem ""
'## 2002.02.12 ADD H.Ishihara@FSIT 実施日未登録対応
    cboOpeClass.ListIndex = 0
'## 2002.02.12 ADD END
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootOpeClassCd(i + 1)
        mstrRootOpeClassCd(i + 1) = vntOpeClassCd(i)
        cboOpeClass.AddItem vntOpeClassName(i)
    Next i
    
    'データが存在しないなら、処理終了（検査実施日の未登録はエラーではない）
    If lngCount <= 0 Then
'## 2002.02.12 ADD H.Ishihara@FSIT 未登録は正常終了
        EditOpeClassConbo = True
'## 2002.02.12 ADD END
        Exit Function
    End If
    
    '先頭コンボを選択状態にする
    cboOpeClass.ListIndex = 0
    EditOpeClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' 機能　　 : 進捗分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 進捗分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditProgressConbo() As Boolean

    Dim objProgress     As Object   '進捗分類アクセス用
    Dim vntProgressCd   As Variant
    Dim vntProgressName As Variant
    Dim lngCount        As Long     'レコード数
    Dim i               As Long     'インデックス
    
    EditProgressConbo = False
    
    cboProgress.Clear
    Erase mstrRootProgressCd

    'オブジェクトのインスタンス作成
    Set objProgress = CreateObject("HainsProgress.Progress")
    lngCount = objProgress.SelectProgressList(vntProgressCd, vntProgressName)
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootProgressCd(i)
        mstrRootProgressCd(i) = vntProgressCd(i)
        cboProgress.AddItem vntProgressName(i)
    Next i
    
    'データが存在しないなら、エラー
    If lngCount <= 0 Then
        MsgBox "進捗分類が存在しません。進捗分類データを登録しないと依頼項目設定を行うことはできません。", vbExclamation
        Exit Function
    End If
    
    '先頭コンボを選択状態にする
    cboProgress.ListIndex = 0
    EditProgressConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

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
Private Function EditItem_P() As Boolean

    Dim objItem_P           As Object          '依頼項目アクセス用
    
    Dim vntRequestName          As Variant          '検査項目名称
    Dim vntRslQue               As Variant          '結果問診フラグ
    Dim vntClassCd              As Variant          '検査分類コード
    Dim vntRequestSName         As Variant          '検査項目略称
    Dim vntProgressCd           As Variant          '進捗分類コード
    Dim vntEntryOk              As Variant          '未入力チェック
    Dim vntSearchChar           As Variant          'ガイド検索文字列
    Dim vntOpeClassCd           As Variant          '検査実施日分類コード
    Dim vntPrice1               As Variant          '単価１
    Dim vntPrice2               As Variant          '単価２
    Dim vntOrderFileName        As Variant          'オーダファイル名
    Dim vntDocCd                As Variant          '文書種別コード
    Dim vntDmdLineClassCd       As Variant          '請求明細分類コード
    Dim vntIsrDmdLineClassCd    As Variant          '健保請求明細分類コード
    Dim vntRoundClassCd         As Variant          'まるめ分類コード

    Dim Ret                 As Boolean          '戻り値
    Dim i                   As Integer
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objItem_P = CreateObject("HainsItem.Item")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrItemCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '依頼項目テーブルレコード読み込み
        If objItem_P.SelectItem_P(mstrItemCd, _
                                  vntRequestName, _
                                  vntRslQue, _
                                  vntClassCd, _
                                  vntRequestSName, _
                                  vntProgressCd, _
                                  vntEntryOk, _
                                  vntSearchChar, _
                                  vntOpeClassCd, _
                                  vntPrice1, _
                                  vntPrice2, _
                                  vntOrderFileName, _
                                  vntDocCd, _
                                  vntDmdLineClassCd, _
                                  vntIsrDmdLineClassCd, _
                                  vntRoundClassCd) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
        
        'テキストボックスのセット
        txtItemCd.Text = mstrItemCd
        txtRequestName.Text = vntRequestName
        txtRequestSName.Text = vntRequestSName
        txtPrice1.Text = vntPrice1
        txtPrice2.Text = vntPrice2
    
        'オプションボタンのセット
        optRslQue(CInt(vntRslQue)).Value = True
        optEntryOk(CInt(vntEntryOk)).Value = True
    
        '検査分類コンボの設定
        For i = 0 To cboItemClass.ListCount - 1
            If mstrRootClassCd(i) = vntClassCd Then
                cboItemClass.ListIndex = i
            End If
        Next i
    
        '進捗分類コンボの設定
        For i = 0 To cboProgress.ListCount - 1
            If mstrRootProgressCd(i) = vntProgressCd Then
                cboProgress.ListIndex = i
            End If
        Next i
        
        '検索文字列コンボの設定
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i
        
        '検査実施日分類コンボの設定
        If Trim(vntOpeClassCd) <> "" Then
            For i = 0 To cboOpeClass.ListCount - 1
                If mstrRootOpeClassCd(i) = vntOpeClassCd Then
                    cboOpeClass.ListIndex = i
                End If
            Next i
        End If
        
        '一般請求明細分類コンボの設定
        If Trim(vntDmdLineClassCd) <> "" Then
            For i = 0 To cboDmdLineClass.ListCount - 1
                If mstrRootDmdLineClassCd(i) = vntDmdLineClassCd Then
                    cboDmdLineClass.ListIndex = i
                End If
            Next i
        End If
    
        '健保請求明細分類コンボの設定
        If Trim(vntIsrDmdLineClassCd) <> "" Then
            For i = 0 To cboIsrDmdLineClass.ListCount - 1
                If mstrRootIsrDmdLineClassCd(i) = vntIsrDmdLineClassCd Then
                    cboIsrDmdLineClass.ListIndex = i
                End If
            Next i
        End If
    
        'まるめ分類コンボの設定
        If Trim(vntRoundClassCd) <> "" Then
            For i = 0 To cboRoundClass.ListCount - 1
                If mstrRootRoundClassCd(i) = vntRoundClassCd Then
                    cboRoundClass.ListIndex = i
                End If
            Next i
        End If
    
        '電カル連携関連情報の設定
        txtOrderFileName.Text = vntOrderFileName
        txtDocCd.Text = vntDocCd
    
        Ret = True
        Exit Do
    
    Loop
    
    '戻り値の設定
    EditItem_P = Ret
    
    Exit Function

ErrorHandle:

    EditItem_P = False
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
Private Function RegistItem_P() As Boolean

On Error GoTo ErrorHandle

    Dim objItem_P       As Object       '依頼項目アクセス用
    Dim Ret             As Long
    Dim intEntryOk      As Integer
    Dim strSearchChar   As String
    
    '未入力チェックの数値化
    intEntryOk = 0
    Select Case True
        Case optEntryOk(1).Value
            intEntryOk = 1
        Case optEntryOk(2).Value
            intEntryOk = 2
    End Select
        
    'ガイド検索文字列の再編集
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "その他" Then
        strSearchChar = "*"
    End If
        
    'オブジェクトのインスタンス作成
    Set objItem_P = CreateObject("HainsItem.Item")
    
    '依頼項目テーブルレコードの登録
'### 2003/11/23 Modifed by Ishihara@FSIT 不要項目の削除
'    Ret = objItem_P.RegistItem_P(IIf(txtItemCd.Enabled, "INS", "UPD"), _
                                 Trim(txtItemCd.Text), _
                                 mstrRootClassCd(cboItemClass.ListIndex), _
                                 IIf(optRslQue(0).Value = True, 0, 1), _
                                 Trim(txtRequestName.Text), _
                                 Trim(txtRequestSName.Text), _
                                 mstrRootProgressCd(cboProgress.ListIndex), _
                                 intEntryOk, _
                                 strSearchChar, _
                                 mstrRootOpeClassCd(cboOpeClass.ListIndex), _
                                 Trim(txtPrice1.Text), _
                                 Trim(txtPrice2.Text), _
                                 Trim(txtOrderFileName.Text), _
                                 Trim(txtDocCd.Text), _
                                 mstrRootDmdLineClassCd(cboDmdLineClass.ListIndex), _
                                 mstrRootIsrDmdLineClassCd(cboIsrDmdLineClass.ListIndex), _
                                 mstrRootRoundClassCd(cboRoundClass.ListIndex))
    Ret = objItem_P.RegistItem_P(IIf(txtItemCd.Enabled, "INS", "UPD"), _
                                 Trim(txtItemCd.Text), _
                                 mstrRootClassCd(cboItemClass.ListIndex), _
                                 IIf(optRslQue(0).Value = True, 0, 1), _
                                 Trim(txtRequestName.Text), _
                                 Trim(txtRequestSName.Text), _
                                 mstrRootProgressCd(cboProgress.ListIndex), _
                                 intEntryOk, _
                                 strSearchChar, _
                                 "")
'### 2003/11/23 Modifed End
    
    If Ret = 0 Then
        MsgBox "入力された依頼項目コードは既に存在します。", vbExclamation
        RegistItem_P = False
        Exit Function
    End If
    
    RegistItem_P = True
    
    Exit Function
    
ErrorHandle:

    RegistItem_P = False
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
Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdItem_P_Price_Click()

    Dim objItem_P_Price   As Object   'メンテナンスウインドウオブジェクト

    Set objItem_P_Price = New mntItem_P_Price.Item_P_Price
    With objItem_P_Price
        .ItemCd = mstrItemCd
        .RequestName = Trim(txtRequestName.Text)
    End With

    'テーブルメンテナンス画面を開く
    objItem_P_Price.Show vbModal
    
    'オブジェクトの廃棄（トランザクションがCommitされない）
    Set objItem_P_Price = Nothing

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
Private Sub cmdOk_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    Do
        '入力チェック
        If CheckValue() = False Then Exit Do
        
        '依頼項目テーブルの登録
        If RegistItem_P() = False Then Exit Do
            
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
    tabMain.Tab = 0         '先頭タブをActive
    mintDetailMaxKey = 0

    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    'オーダ連携設定の説明
    lblOrderDoc.Caption = "ここで設定されたオーダファイル名、文書番号を使用してオーダ送信を行います。" & vbLf & "オーダ送信にはここで指定する方法と検査項目毎に変換コードを指定する場合の２通りが存在します。"

    '検索文字列コンボ初期化
    Call InitSearchCharCombo(cboSearchChar)
    
    Do
        '検査分類コンボの編集
        If EditItemClassConbo() = False Then
            Exit Do
        End If
        
        '進捗分類コンボの編集
        If EditProgressConbo() = False Then
            Exit Do
        End If
        
'### 2003/11/23 Deleted by Ishihara@FSIT 不要項目の削除
'        検査実施日分類コンボの編集
'        If EditOpeClassConbo() = False Then
'            Exit Do
'        End If
'
'        '請求分類コンボの編集
'        If EditDmdLineClassConbo() = False Then
'            Exit Do
'        End If
'
'        まるめ分類コンボの編集
'        If EditRoundClassConbo() = False Then
'            Exit Do
'        End If
'### 2003/11/23 Deleted End
        
        '依頼項目情報の編集
        If EditItem_P() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtItemCd.Enabled = (mstrItemCd = "")
        cmdItem_P_Price.Enabled = (mstrItemCd <> "")
                
        Ret = True
        Exit Do
    Loop
    
    tabMain.Tab = 0
    Call tabMain_Click(1)
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub tabMain_Click(PreviousTab As Integer)

'    fraMain(tabMain.Tab).Enabled = True
'    fraMain(PreviousTab).Enabled = False

End Sub

