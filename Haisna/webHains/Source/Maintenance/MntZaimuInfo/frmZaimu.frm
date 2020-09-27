VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmZaimu 
   Caption         =   "財務連携情報メンテナンス"
   ClientHeight    =   6285
   ClientLeft      =   270
   ClientTop       =   1170
   ClientWidth     =   11055
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmZaimu.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6285
   ScaleWidth      =   11055
   StartUpPosition =   2  '画面の中央
   Begin VB.Frame Frame1 
      Caption         =   "操作"
      Height          =   795
      Left            =   120
      TabIndex        =   9
      Top             =   540
      Width           =   10755
      Begin VB.CommandButton cmdClear 
         Caption         =   "締め情報クリア(&R)"
         Height          =   375
         Left            =   8580
         Picture         =   "frmZaimu.frx":000C
         TabIndex        =   13
         Top             =   300
         Width           =   2055
      End
      Begin VB.CommandButton cmdSendZaimuData 
         Caption         =   "財務データ送信(&S)"
         Height          =   375
         Left            =   4380
         TabIndex        =   12
         Top             =   300
         Width           =   2055
      End
      Begin VB.CommandButton cmdPrint 
         Caption         =   "収入日報印刷(&P)"
         Height          =   375
         Left            =   2280
         Picture         =   "frmZaimu.frx":010E
         TabIndex        =   11
         Top             =   300
         Width           =   2055
      End
      Begin VB.CommandButton cmdCreateZaimu 
         Caption         =   "財務連携データ作成(&C)"
         Height          =   375
         Left            =   180
         TabIndex        =   10
         Top             =   300
         Width           =   2055
      End
      Begin VB.Label lblSendLamp 
         Caption         =   "■未送信です"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   195
         Left            =   6540
         TabIndex        =   14
         Top             =   420
         Width           =   1455
      End
   End
   Begin VB.Frame fraMain 
      Caption         =   "収支内容"
      Height          =   4335
      Left            =   120
      TabIndex        =   0
      Top             =   1440
      Width           =   10815
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "追加(&A)..."
         Height          =   315
         Left            =   6540
         TabIndex        =   2
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "削除(&R)"
         Height          =   315
         Left            =   9300
         TabIndex        =   3
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdEdit 
         Caption         =   "編集(&E)"
         Height          =   315
         Left            =   7920
         TabIndex        =   4
         Top             =   3840
         Width           =   1275
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   3495
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   10515
         _ExtentX        =   18547
         _ExtentY        =   6165
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   8100
      TabIndex        =   5
      Top             =   5880
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   9540
      TabIndex        =   6
      Top             =   5880
      Width           =   1335
   End
   Begin VB.Label lblMode 
      Caption         =   "Label1"
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
      Left            =   3300
      TabIndex        =   8
      Top             =   180
      Width           =   1755
   End
   Begin VB.Label lblFileName 
      Caption         =   "2002年4月1日の収支データです。"
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
      Left            =   240
      TabIndex        =   7
      Top             =   180
      Width           =   2895
   End
End
Attribute VB_Name = "frmZaimu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrZaimuDate           As String       '財務連携日付
Private mblnInitialize          As Boolean      'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean      'TRUE:更新あり、FALSE:更新なし

Private Const KEY_PREFIX        As String = "K" 'コレクション用キープリフィックス

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション
Private mcolZaimuInfoCollection As Collection   '財務データコレクション
Private mcolTekiyouCollection   As Collection   '適用コードのコレクション
Private mintListViewIndex       As Integer

Friend Property Let ZaimuDate(ByVal vntNewValue As Variant)

    mstrZaimuDate = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

'
' 機能　　 : データ表示用編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu        As Object           '財務連携アクセス用
    Dim lngFileCount    As Long
    Dim i               As Integer
    
    Dim vntSysCd        As Variant
    Dim vntYY           As Variant
    Dim vntMMDD         As Variant
    Dim vntOrgCd        As Variant
    Dim vntOrgName      As Variant
    Dim vntTekiyouCd    As Variant
    Dim vntTekiyouName  As Variant
    Dim vntPrice        As Variant
    Dim vntKubun        As Variant
    Dim vntShubetsu     As Variant
    Dim vntTaxPrice     As Variant
    Dim vntTax          As Variant
    Dim vntCsCd         As Variant
    Dim vntKanendo      As Variant
'### 2002.05.14 Added by Ishihara@FSIT 送信済みかどうかの表示を行う
    Dim blnAlreadySend  As Boolean
'### 2002.05.14 Added End
    
    Dim vntSyubetsu_NIP As Variant
    Dim vntTekiyou_NIP  As Variant
    Dim vntCount_NIP    As Variant
    Dim vntShunou_NIP   As Variant

    Dim lngRecordCount  As Long
    Dim objZaimuCsv     As ZaimuCsv
    
    EditZaimu = False
    
    'リストビュークリア
    lsvItem.ListItems.Clear
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    Do
        '日付が指定されていない場合はエラー
        If mstrZaimuDate = "" Then
            MsgBox "財務連携日付が指定されていません。", vbCritical, App.Title
            Exit Do
        End If
        
        '財務連携情報読み込み
'### 2002.05.14 Modified by Ishihara@FSIT 送信済みかどうかの表示を行う
'        lngFileCount = objZaimu.SelectZaimuCsv(mstrZaimuDate, _
                                               , _
                                               vntSysCd, _
                                               vntYY, _
                                               vntMMDD, _
                                               vntOrgCd, _
                                               vntOrgName, _
                                               vntTekiyouCd, _
                                               vntTekiyouName, _
                                               vntPrice, _
                                               vntKubun, _
                                               vntShubetsu, _
                                               vntTaxPrice, _
                                               vntTax, _
                                               vntCsCd, _
                                               vntKanendo, _
                                               vntSyubetsu_NIP, _
                                               vntTekiyou_NIP, _
                                               vntCount_NIP, _
                                               lngRecordCount)
        blnAlreadySend = False
        lngFileCount = objZaimu.SelectZaimuCsv(mstrZaimuDate, _
                                               , _
                                               vntSysCd, _
                                               vntYY, _
                                               vntMMDD, _
                                               vntOrgCd, _
                                               vntOrgName, _
                                               vntTekiyouCd, _
                                               vntTekiyouName, _
                                               vntPrice, _
                                               vntKubun, _
                                               vntShubetsu, _
                                               vntTaxPrice, _
                                               vntTax, _
                                               vntCsCd, _
                                               vntKanendo, _
                                               vntSyubetsu_NIP, _
                                               vntTekiyou_NIP, _
                                               vntCount_NIP, _
                                               lngRecordCount, _
                                               blnAlreadySend)
'### 2002.05.14 Modified End
        
        If lngFileCount = -1 Then
            MsgBox "財務連携ファイル読み込み時に致命的なエラーが発生しました。", vbCritical, App.Title
            Exit Do
        End If
    
        If lngFileCount = 0 Then
            lblMode.Caption = "（新規モード）"
            EditZaimu = True
            Exit Do
        End If
    
        If lngRecordCount > 0 Then
        
            'リストの編集
            For i = 0 To lngRecordCount - 1
                
                'コレクション作成
                Set objZaimuCsv = New ZaimuCsv
                With objZaimuCsv
                    .SysCd = vntSysCd(i)
                    .ZaimuYY = vntYY(i)
                    .ZaimuMMDD = vntMMDD(i)
                    .OrgCd = vntOrgCd(i)
                    .OrgName = vntOrgName(i)
                    .TekiyouCd = vntTekiyouCd(i)
                    .TekiyouName = vntTekiyouName(i)
                    .Price = vntPrice(i)
                    .Kubun = vntKubun(i)
                    .Shubetsu = vntShubetsu(i)
                    .TaxPrice = vntTaxPrice(i)
                    .Tax = vntTax(i)
                    .CsCd = vntCsCd(i)
                    .Kanendo = vntKanendo(i)
                    .Syubetsu_NIP = vntSyubetsu_NIP(i)
                    .Tekiyou_NIP = vntTekiyou_NIP(i)
                    .Count_NIP = vntCount_NIP(i)
                End With
                mcolZaimuInfoCollection.Add objZaimuCsv, KEY_PREFIX & mintListViewIndex
                
                'リストビューにオブジェクトからセット
                Call SetObjectToListView(objZaimuCsv, "")
                
                Set objZaimuCsv = Nothing
                
            Next i
        
            lblMode.Caption = "（更新モード）"
        
'### 2002.05.14 Added by Ishihara@FSIT 送信済みかどうかの表示を行う
            If blnAlreadySend = True Then
                lblSendLamp.Caption = "■送信済みです。"
                lblSendLamp.ForeColor = vbBlack
            End If
'### 2002.05.14 Added End
        End If
    
        Exit Do
    Loop
    
'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing追加
    Set objZaimu = Nothing
'### 2002.05.08 Added End
    
    '戻り値の設定
    EditZaimu = True
    
    Exit Function

ErrorHandle:

    EditZaimu = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub SetObjectToListView(objZaimuCsv As ZaimuCsv, strListItemKey As String)

    Dim objItem         As ListItem         'リストアイテムオブジェクト

    'オブジェクトからリストビューにセット
    With objZaimuCsv
        
        
        If strListItemKey <> "" Then
            '更新モード
            Set objItem = lsvItem.ListItems(strListItemKey)
            objItem.Text = .OrgCd
        Else
            '挿入モード
            Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & mintListViewIndex, .OrgCd)
            
            'リストビュー用ユニークインデックスをインクリメント
            mintListViewIndex = mintListViewIndex + 1
        
        End If
    
        objItem.SubItems(1) = .OrgName
        objItem.SubItems(2) = .TekiyouCd
        objItem.SubItems(3) = .TekiyouName
        objItem.SubItems(4) = .CsCd
        
        Select Case .Kubun
            Case 1
                objItem.SubItems(5) = "窓口個人"
            Case 2
                objItem.SubItems(5) = "団体請求"
            Case 3
                objItem.SubItems(5) = "電話料金"
            Case 4
                objItem.SubItems(5) = "文書料"
            Case 5
                objItem.SubItems(5) = "雑収入"
        End Select
        
        Select Case .Shubetsu
            Case "1"
                objItem.SubItems(6) = "未収"
            Case "2"
                objItem.SubItems(6) = "入金"
            Case "3"
                objItem.SubItems(6) = "過去未収入金"
            Case "4"
                objItem.SubItems(6) = "還付"
            Case "5"
                objItem.SubItems(6) = "還付未払"
        End Select
        
        objItem.SubItems(7) = .Price
        objItem.SubItems(8) = .TaxPrice
        objItem.SubItems(9) = .Tax & "%"
        
        Select Case .Kanendo
            Case 0
                objItem.SubItems(10) = "当年度"
            Case 1
                objItem.SubItems(10) = "過年度"
            Case Else
                objItem.SubItems(10) = "？？？"
        End Select
        
        objItem.SubItems(11) = .ZaimuYY & .ZaimuMMDD
        objItem.SubItems(12) = .SysCd
    
    End With

End Sub

'
' 機能　　 : データ登録
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function RegistZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu            As Object       '財務連携アクセス用
    Dim vntSysCd()          As Variant
    Dim vntYY()             As Variant
    Dim vntMMDD()           As Variant
    Dim vntOrgCd()          As Variant
    Dim vntOrgName()        As Variant
    Dim vntTekiyouCd()      As Variant
    Dim vntTekiyouName()    As Variant
    Dim vntPrice()          As Variant
    Dim vntKubun()          As Variant
    Dim vntShubetsu()       As Variant
    Dim vntTaxPrice()       As Variant
    Dim vntTax()            As Variant
    Dim vntCsCd()           As Variant
    Dim vntKanendo()        As Variant
    
    Dim vntSyubetsu_NIP()   As Variant
    Dim vntTekiyou_NIP()    As Variant
    Dim vntCount_NIP()      As Variant

    Dim intRecordCount      As Integer
    Dim objZaimuCsv         As ZaimuCsv
    Dim Ret                 As Boolean
    
    RegistZaimu = False
    intRecordCount = 0

    For Each objZaimuCsv In mcolZaimuInfoCollection
        
        ReDim Preserve vntSysCd(intRecordCount)
        ReDim Preserve vntYY(intRecordCount)
        ReDim Preserve vntMMDD(intRecordCount)
        ReDim Preserve vntOrgCd(intRecordCount)
        ReDim Preserve vntOrgName(intRecordCount)
        ReDim Preserve vntTekiyouCd(intRecordCount)
        ReDim Preserve vntTekiyouName(intRecordCount)
        ReDim Preserve vntPrice(intRecordCount)
        ReDim Preserve vntKubun(intRecordCount)
        ReDim Preserve vntShubetsu(intRecordCount)
        ReDim Preserve vntTaxPrice(intRecordCount)
        ReDim Preserve vntTax(intRecordCount)
        ReDim Preserve vntCsCd(intRecordCount)
        ReDim Preserve vntKanendo(intRecordCount)
    
        ReDim Preserve vntSyubetsu_NIP(intRecordCount)
        ReDim Preserve vntTekiyou_NIP(intRecordCount)
        ReDim Preserve vntCount_NIP(intRecordCount)
    
    
        With objZaimuCsv
            vntSysCd(intRecordCount) = .SysCd
            vntYY(intRecordCount) = .ZaimuYY
            vntMMDD(intRecordCount) = .ZaimuMMDD
            vntOrgCd(intRecordCount) = .OrgCd
            vntOrgName(intRecordCount) = .OrgName
            vntTekiyouCd(intRecordCount) = .TekiyouCd
            vntTekiyouName(intRecordCount) = .TekiyouName
            vntPrice(intRecordCount) = .Price
            vntKubun(intRecordCount) = .Kubun
            vntShubetsu(intRecordCount) = .Shubetsu
            vntTaxPrice(intRecordCount) = .TaxPrice
            vntTax(intRecordCount) = .Tax
            vntCsCd(intRecordCount) = .CsCd
            vntKanendo(intRecordCount) = .Kanendo
            vntSyubetsu_NIP(intRecordCount) = .Syubetsu_NIP
            vntTekiyou_NIP(intRecordCount) = .Tekiyou_NIP
            vntCount_NIP(intRecordCount) = .Count_NIP
        End With
        intRecordCount = intRecordCount + 1
    
    Next objZaimuCsv


    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '財務連携テーブルレコードの登録
    Ret = objZaimu.RegistZaimuCsv(mstrZaimuDate, _
                                  vntSysCd, _
                                  vntYY, _
                                  vntMMDD, _
                                  vntOrgCd, _
                                  vntOrgName, _
                                  vntTekiyouCd, _
                                  vntTekiyouName, _
                                  vntPrice, _
                                  vntKubun, _
                                  vntShubetsu, _
                                  vntTaxPrice, _
                                  vntTax, _
                                  vntCsCd, _
                                  vntKanendo, _
                                  vntSyubetsu_NIP, _
                                  vntTekiyou_NIP, _
                                  vntCount_NIP, _
                                  intRecordCount)

'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing追加
    Set objZaimu = Nothing
'### 2002.05.08 Added End

    If Ret = False Then
        MsgBox "財務連携用CSVデータ保存時に致命的なエラーが発生しました。", vbExclamation
        RegistZaimu = False
        Exit Function
    End If
    
    RegistZaimu = True
    
    Exit Function
    
ErrorHandle:

    RegistZaimu = False
    MsgBox Err.Description, vbCritical
    
'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing追加
    Set objZaimu = Nothing
'### 2002.05.08 Added End
    
End Function

'
' 機能　　 : 財務データ追加_Click
'
' 備考　　 :
'
Private Sub cmdAddItem_Click()
    
    Dim objZaimuCsv     As ZaimuCsv
    Dim objItem         As ListItem         'リストアイテムオブジェク
    Dim Ret             As Boolean
    
    With frmZaimuInfo
        Set objZaimuCsv = New ZaimuCsv
        .InitialDate = mstrZaimuDate
        .ParaZaimuCsv = objZaimuCsv
        .TekiyouCollection = mcolTekiyouCollection
        .Mode = True
        .Show vbModal
        Ret = .Updated
        If Ret = True Then
            Set objZaimuCsv = .ParaZaimuCsv
        End If
    End With
    
    If Ret = True Then
        
        'コレクションに追加
        mcolZaimuInfoCollection.Add objZaimuCsv, KEY_PREFIX & mintListViewIndex
    
        'リストビューにオブジェクトからセット
        Call SetObjectToListView(objZaimuCsv, "")
    
        Set objZaimuCsv = Nothing
    End If

End Sub

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

Private Sub cmdClear_Click()

    frmClearCloseDate.Show vbModal
    
End Sub

Private Sub cmdPrint_Click()

  Dim exl As Variant

'** Excel 起動
  On Local Error Resume Next
  Set exl = CreateObject("Excel.Application")
  Shell exl.Path & "\excel.exe " & """" & App.Path & "\収入日報.xls""", 1
  On Local Error GoTo 0

End Sub

'
' 機能　　 : 財務データ送信_Click
'
' 備考　　 :
'
Private Sub cmdSendZaimuData_Click()

    Dim strMsg          As String
    Dim objZaimu        As Object       '財務連携アクセス用
    Dim lngRet          As Long
    Dim dtmInsDate      As Date

    '財務データが一つも存在しないならエラー
    If lsvItem.ListItems.Count <= 0 Then
        MsgBox "財務データが１件もありません。", vbExclamation, Me.Caption
        Exit Sub
    End If

    '実行前問い合わせ
    strMsg = "現在のデータを財務システムに送信します。よろしいですか？"
    If MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbQuestion, Me.Caption) = vbNo Then
        Exit Sub
    End If
    
    Screen.MousePointer = vbHourglass
    
    '財務連携テーブルの登録
    If RegistZaimu() = False Then
        Screen.MousePointer = vbDefault
        Exit Sub
    End If
    
    '登録後、送信
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    dtmInsDate = CDate(Mid(mstrZaimuDate, 1, 4) & "/" & Mid(mstrZaimuDate, 5, 2) & "/" & Mid(mstrZaimuDate, 7, 2))
    lngRet = objZaimu.CopyZaimuCsv(dtmInsDate)

    If lngRet < 1 Then
        MsgBox "異常終了しました。ErrCd = " & lngRet, vbExclamation
    Else
        MsgBox "正常終了しました。", vbInformation
'### 2002.05.14 Added by Ishihara@FSIT 送信済みかどうかの表示を行う
        lblSendLamp.Caption = "■送信済みです。"
        lblSendLamp.ForeColor = vbBlack
'### 2002.05.14 Added End
    End If
    
    Screen.MousePointer = vbDefault
    
End Sub

'
' 機能　　 : 財務データ作成_Click
'
' 備考　　 :
'
Private Sub cmdCreateZaimu_Click()

    Dim lngRet          As Long
    Dim objZaimu        As Object       '財務連携アクセス用
    Dim dtmInsDate      As Date
    Dim dtmStrDate       As Date
    Dim dtmEndDate       As Date
    Dim blnAllData      As Boolean
    Dim blnCalcOrg      As Boolean
    Dim blnAppendMode   As Boolean
    Dim strMsg          As String
    Dim blnRet          As Boolean
    
    With frmSelectExecuteDate
        .InitialDate = mstrZaimuDate
        .Show vbModal
        blnRet = .Updated
        If blnRet = True Then
            blnAllData = .AllData
            dtmInsDate = .InsDate
            blnCalcOrg = .CalcOrg
            blnAppendMode = .AppendMode
            If blnCalcOrg = True Then
                dtmStrDate = .strDate
                dtmEndDate = .endDate
            End If
        End If
    End With
        
    If blnRet = False Then Exit Sub
    
    If (lsvItem.ListItems.Count > 0) And (blnAppendMode = False) Then
        strMsg = "現在のデータは削除され、新しく連携ファイルを作成いたします。よろしいですか？"
    Else
        strMsg = "財務連携データ(CSV)を作成します。よろしいですか？"
    End If
    
    If MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation, Me.Caption) = vbNo Then
        Exit Sub
    End If
    Screen.MousePointer = vbHourglass
    
'    dtmTargetDate = CDate(Mid(mstrZaimuDate, 1, 4) & "/" & Mid(mstrZaimuDate, 5, 2) & "/" & Mid(mstrZaimuDate, 7, 2))
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '財務連携テーブルレコードの登録
    If blnCalcOrg = True Then
        lngRet = objZaimu.CreateZaimuCSV(dtmInsDate, Not blnAllData, blnAppendMode, dtmStrDate, dtmEndDate)
    Else
        lngRet = objZaimu.CreateZaimuCSV(dtmInsDate, Not blnAllData, blnAppendMode)
    End If
    
'### 2002.05.08 Added by Ishihara@FSIT ObjectNothing追加
    Set objZaimu = Nothing
'### 2002.05.08 Added End
    
    If lngRet < 0 Then
        MsgBox "財務連携テーブル作成時に致命的なエラーが発生しました。=" & lngRet, vbCritical
    Else
        
        '財務連携情報の編集
        If EditZaimu() = False Then Exit Sub
        MsgBox lngRet & "件のデータを作成しました。"
    
    End If
    
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' 機能　　 : 「項目削除」Click
'
' 機能説明 : 選択された項目をリストから削除する
'
' 備考　　 :
'
Private Sub cmdDeleteItem_Click()

    Dim i               As Integer
    Dim strKey          As String
    
    For i = 1 To lsvItem.ListItems.Count

        'インデックスがリスト項目を越えたら終了
        If i > lsvItem.ListItems.Count Then Exit For

        '選択されている項目なら削除
        If lsvItem.ListItems(i).Selected = True Then
            strKey = lsvItem.ListItems(i).Key
            lsvItem.ListItems.Remove (strKey)
            mcolZaimuInfoCollection.Remove (strKey)
            'アイテム数が変わるので-1して再検査
            i = i - 1
        End If

    Next i

End Sub

Private Sub cmdEdit_Click()

    Dim i               As Integer
    Dim strKey          As String
    Dim blnSelected     As Boolean
    Dim objZaimuCsv     As ZaimuCsv
    Dim Ret             As Boolean
    
    If lsvItem.ListItems.Count < 1 Then
        MsgBox "編集可能な項目がありません。", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    '選択数チェック
    blnSelected = False
    For i = 1 To lsvItem.ListItems.Count

        'インデックスがリスト項目を越えたら終了
        If i > lsvItem.ListItems.Count Then Exit For

        '選択されている項目なら削除
        If lsvItem.ListItems(i).Selected = True Then
            If blnSelected = False Then
                strKey = lsvItem.ListItems(i).Key
                blnSelected = True
            Else
                MsgBox "複数選択した状態で、内容修正することはできません。", vbExclamation, Me.Caption
                Exit Sub
            End If
        End If

    Next i

    '編集画面表示
    With frmZaimuInfo
        .ParaZaimuCsv = mcolZaimuInfoCollection(strKey)
        .TekiyouCollection = mcolTekiyouCollection
        .Mode = False
        .Show vbModal
        Ret = .Updated
    End With
    
    If Ret = True Then
        
        'リストビューのオブジェクトを更新
        Call SetObjectToListView(mcolZaimuInfoCollection(strKey), strKey)
    
        'コレクションはもう書き換えられてます・・・
    
    End If
    
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
        
'### 2002.05.08 Modified by Ishihara@FSIT 0件時も構わず処理
'        If lsvItem.ListItems.Count > 0 Then
'            '財務連携テーブルの登録
'            If RegistZaimu() = False Then Exit Do
'        End If
        '財務連携テーブルの登録
        If RegistZaimu() = False Then Exit Do
'### 2002.05.08 Modified End
            
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

    Dim Ret         As Boolean  '戻り値
    Dim objHeader   As ColumnHeaders    'カラムヘッダオブジェクト
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False

    'コレクションとコレクション用キーはクリエイト（新規作成想定）
    mintListViewIndex = 0
    Set mcolZaimuInfoCollection = New Collection

    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

'### 2002.05.14 Added by Ishihara@FSIT 送信済みかどうかの表示を行う
    lblSendLamp.Caption = "■未送信です。"
    lblSendLamp.ForeColor = vbRed
'### 2002.05.14 Added End

    'ヘッダの編集
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "請求先コード", 1200, lvwColumnLeft
        .Add , , "請求先名称", 1500, lvwColumnLeft
        .Add , , "適用コード", 1000, lvwColumnLeft
        .Add , , "適用名称", 2000, lvwColumnLeft
        .Add , , "コースコード", 600, lvwColumnRight
        .Add , , "区分", 1050, lvwColumnLeft
        .Add , , "種別", 600, lvwColumnLeft
        .Add , , "金額", 900, lvwColumnRight
        .Add , , "税額", 900, lvwColumnRight
        .Add , , "税率", 600, lvwColumnRight
        .Add , , "過年度", 800, lvwColumnLeft
        .Add , , "日付", 1200, lvwColumnLeft
        .Add , , "システム種別コード", 1200, lvwColumnLeft
    End With
    lsvItem.View = lvwReport

    lblFileName = Mid(mstrZaimuDate, 1, 4) & "年"
    lblFileName = lblFileName & Mid(mstrZaimuDate, 5, 2) & "月"
    lblFileName = lblFileName & Mid(mstrZaimuDate, 7, 2) & "日の収支データです"
    
    Do
        
        '適用コードのコレクション化
        If CreateTekiyouCollection() = False Then
            Exit Do
        End If
        
        '財務連携情報の編集
        If EditZaimu() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

'
' 機能　　 : 適用コードのコレクションセット
'
' 備考　　 : 適用コードデータを読み込み、コレクションにセットする
'
Private Function CreateTekiyouCollection() As Boolean
    
On Error GoTo ErrorHandle
    
    Dim objZaimu            As Object           '財務適用コードアクセス用
    Dim vntZaimuCd          As Variant          '財務コードコード
    Dim vntZaimuName        As Variant          '財務適用名
    
    Dim objTekiyouClass     As TekiyouClass
    Dim lngCount            As Long
    Dim i                   As Integer
    
    CreateTekiyouCollection = False
    
    lngCount = 0

    '適用コードコレクションの作成
    Set mcolTekiyouCollection = New Collection
    
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, , , , , True)
    
    'リストの編集
    For i = 0 To lngCount - 1
        
        Set objTekiyouClass = New TekiyouClass
        objTekiyouClass.TekiyouCd = vntZaimuCd(i)
        objTekiyouClass.TekiyouName = vntZaimuName(i)

'        cboTekiyou.AddItem vntZaimuName(i)
'        objTekiyouClass.ListIndex = cboTekiyou.NewIndex
    
'        mcolTekiyouCollection.Add objTekiyouClass, KEY_PREFIX & objTekiyouClass.ListIndex
        mcolTekiyouCollection.Add objTekiyouClass, KEY_PREFIX & vntZaimuCd(i)
        Set objTekiyouClass = Nothing
    
    Next i
    
    If lngCount < 1 Then
        MsgBox "財務連携用の適用コードが設定されていません。", vbExclamation, Me.Caption
        Exit Function
    End If

    CreateTekiyouCollection = True
    Exit Function

ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub Form_Resize()
    
'### 2002.05.14 Deleted by Ishihara@FSIT 使ってないからやめ
'    If Me.WindowState <> vbMinimized Then
'        Call SizeControls
'    End If
'### 2002.05.14 Deleted End

End Sub

'
' 機能　　 : 各種コントロールのサイズ変更
'
' 引数　　 : なし
'
' 戻り値　 :
'
' 備考　　 : ツリービュー・リストビュー・スプリッター・ラベル等のサイズを変更する
'
Private Sub SizeControls()
    
    '幅変更
    If Me.Width > 11175 Then

        fraMain.Width = Me.Width - (360)
        cmdAddItem.Left = fraMain.Width - 4275
        cmdEdit.Left = fraMain.Width - 2895
        cmdDeleteItem.Left = fraMain.Width - 1515
        cmdOk.Left = Me.Width - 3075
        cmdCancel.Left = Me.Width - 1635
        lsvItem.Width = fraMain.Width - 300
    
    End If
    
    '高さ変更
    If Me.Height > 5730 Then
        fraMain.Height = Me.Height - 1395
        lsvItem.Height = fraMain.Height - (540 + 240)
        cmdAddItem.Top = fraMain.Height - (495)
        cmdEdit.Top = cmdAddItem.Top
        cmdDeleteItem.Top = cmdAddItem.Top
        cmdOk.Top = Me.Height - (315 + 495)
        cmdCancel.Top = cmdOk.Top
        cmdCreateZaimu.Top = cmdOk.Top
        cmdSendZaimuData.Top = cmdOk.Top
    End If

End Sub

Private Sub lsvItem_DblClick()

    Call cmdEdit_Click
    
End Sub

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If

End Sub



