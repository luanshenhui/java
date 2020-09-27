VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Request"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private Const TRANSACTIONDIV_REQUEST    As String = "LOGREQISP"     '検査依頼用のログ処理ＩＤ
Private Const FREECD_REQFILE            As String = "REQFILE"       '検査依頼ファイル情報
Private Const FREECD_REQCD              As String = "REQCD"         '依頼元コード用

'
' 機能　　 : ファイルコピー
'
' 引数　　 : (In)     strFromFile  コピー元ファイル
' 　　　　   (In)     strToFile    コピー先ファイル
'
' 戻り値　 : 0   正常終了
' 　　　　   -1  コピー元ファイルが存在しない
' 　　　　   -2  コピー元ファイルが使用中
' 　　　　   -3  コピー先ファイルが使用中
'
' 備考　　 :
'
Public Function CopyFile(ByVal strFromFile As String, ByVal strToFile As String) As Long

    Dim objFso          As Object   'ファイルシステムオブジェクト
    
    Dim intFromFileNo   As Integer  'ファイル番号
    Dim intToFileNo     As Integer  'ファイル番号
    
    Dim strStream       As String   '文字列ストリーム
    Dim Ret             As Long     '関数戻り値

'## 2003.04.16 Add 3Lines By T.Takagi@FSIT バックアップ機能
    Dim objCreateCsv    As Object   'CSVファイル作成用
    Dim strBackupFile   As String   'バックアップファイル名
    Dim lngPos          As Long     '検索位置
'## 2003.04.16 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFso = CreateObject("Scripting.FileSystemObject")

    Do
    
        'コピー元ファイルが存在しない場合は処理を終了する
        If objFso.FileExists(strFromFile) = False Then
            Ret = -1
            Exit Do
        End If

        'コピー元ファイルが使用中であれば処理を終了する
        If Locked(strFromFile) Then
            Ret = -2
            Exit Do
        End If

'## 2003.04.16 Add 16Lines By T.Takagi@FSIT バックアップ機能
        '後部からピリオドの位置を検索
        lngPos = InStrRev(strFromFile, ".")
        
        'バックアップファイル名の生成
        If lngPos > 0 Then
            strBackupFile = Left(strFromFile, lngPos) & "bak"
        Else
            strBackupFile = strFromFile & ".bak"
        End If

        'ファイル名が存在するかを検索し、存在すれば重複しない新しいファイル名を返す
        Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
        strBackupFile = objCreateCsv.GetNewFile(strBackupFile)

        'ファイルのコピー
        objFso.CopyFile strFromFile, strBackupFile, False
'## 2003.04.16 Add End
        
        'コピー元ファイルオープン
        intFromFileNo = FreeFile()
        Open strFromFile For Input Lock Read Write As #intFromFileNo
    
        'コピー先ファイルの存在を確認
        If objFso.FileExists(strToFile) = False Then
        
            '存在しなければ出力モードでファイルオープン
            intToFileNo = FreeFile()
            Open strToFile For Output Lock Read Write As #intToFileNo
        
        '存在する場合
        Else
        
            '使用中であれば他で検査依頼処理中と認識し、処理を終了する
            If Locked(strToFile) Then
                Ret = -3
                Exit Do
            End If
        
            '追加モードでファイルオープン
            intToFileNo = FreeFile()
            Open strToFile For Append Lock Read Write As #intToFileNo
        
        End If
    
        'コピー元ファイル読み込み
        Do Until EOF(intFromFileNo)
    
            '１行読み込み
            Line Input #intFromFileNo, strStream
    
            'コピー先ファイルに追加
            Print #intToFileNo, strStream
    
        Loop

        Ret = 0
        Exit Do
    Loop

ErrorExit:

    'コピー先ファイルクローズ
    Close #intToFileNo

    'コピー元ファイルクローズ
    Close #intFromFileNo

    '正常であればコピー元ファイルを削除
    If Ret = 0 Then
        Kill strFromFile
    End If
    
    '戻り値の設定
    CopyFile = Ret

    Exit Function
    
ErrorHandle:

    Ret = -4
    Resume ErrorExit
    
End Function

'
' 機能　　 : 依頼ファイルの作成
'
' 引数　　 : (In)     dtmCslDate      受診日
' 　　　　   (In)     strPerId        個人ＩＤ
' 　　　　   (In)     blnIncSentData  True時は検体番号発番済みの情報も含む
' 　　　　   (In)     lngRsvNo        予約番号
'
' 戻り値　 : 作成対象となった受診情報数
'
' 備考　　 :
'
Public Function CreateFile(Optional ByVal dtmCslDate As Date, Optional ByVal strPerId As String, Optional ByVal blnIncSentData As Boolean = False, Optional ByVal lngRsvNo As Long = 0) As Long

    Dim objConsult          As Object       '受診情報アクセス用
    Dim objFree             As Object       '汎用情報アクセス用
    Dim objFso              As Object       'ファイルシステムオブジェクト
    Dim objHainsLog         As Object       'ログ情報アクセス用
    Dim objRequest          As Request2     '検査依頼処理用

    Dim lngTransactionId    As Long         'トランザクションＩＤ
    
    Dim vntFilePath         As Variant      '検査依頼ファイル格納パス
    Dim vntFileName         As Variant      '検査依頼ファイル名
    Dim vntReqCd            As Variant      '依頼元コード
    
    Dim strFileName         As String       '検査依頼ファイル名

    Dim vntRsvNo            As Variant      '予約番号
    Dim vntDayId            As Variant      '当日ＩＤ
    Dim vntPerId            As Variant      '個人ＩＤ
    Dim vntLastName         As Variant      '姓
    Dim vntFirstName        As Variant      '名
    Dim vntLastKName        As Variant      'カナ姓
    Dim vntFirstKName       As Variant      'カナ名
    Dim vntGender           As Variant      '性別
    Dim vntBirth            As Variant      '生年月日
    Dim vntAge              As Variant      '年齢
    Dim vntCslDate          As Variant      '受診日
    Dim lngCount            As Long         '受診情報数

    Dim dblPatientNo        As Double       '患者番号

    Dim strName             As String       '氏名
    Dim strKanaName         As String       'カナ氏名

    Dim lngSentCount        As Long         '送信レコード数

    Dim Ret                 As Boolean      '関数戻り値
    Dim i                   As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'オブジェクトのインスタンス作成
    Set objConsult = CreateObject("HainsConsult.Consult")
    Set objFree = CreateObject("HainsFree.Free")
    Set objFso = CreateObject("Scripting.FileSystemObject")
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    Set objRequest = CreateObject("HainsCooperation.Request2")
    
    'トランザクションＩＤ・区分の取得
    lngTransactionId = objHainsLog.IncreaseTransactionId()
    
    '開始ログの発行
    objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", "検査依頼用のファイル作成処理を開始します。", ""
    
    Do
        
        '汎用テーブルから検査依頼ファイル情報を取得
        Ret = objFree.SelectFree(0, FREECD_REQFILE, , , , vntFilePath, vntFileName)
        If Ret = False Or vntFilePath = "" Or vntFileName = "" Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "検査依頼ファイル情報が汎用テーブルに存在しません。", ""
            Exit Do
        End If
        
        'パスが存在しない場合は処理を終了する
        If objFso.FolderExists(vntFilePath) = False Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "パスが存在しません。", "パス=" & vntFilePath
            Exit Do
        End If
        
        '汎用テーブルから依頼元コードを取得
        Ret = objFree.SelectFree(0, FREECD_REQCD, , , , vntReqCd)
        If Ret = False Or vntReqCd = "" Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "E", "", "依頼元コード情報が汎用テーブルに存在しません。", ""
            Exit Do
        End If
        
        'パスの最後は必ず"\"をつける
        vntFilePath = vntFilePath & IIf(Right(vntFilePath, 1) <> "\", "\", "")
    
        strFileName = vntFilePath & vntFileName
        
        'ログ発行
        If dtmCslDate > 0 Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", "■次の受診日が指定されました。", "受診日=" & Format(dtmCslDate, "yyyy/m/d")
        End If
        
        '予約番号指定でない場合は
        If lngRsvNo = 0 Then
        
            '受診者一覧取得
            lngCount = objConsult.SelectConsultList( _
                           dtmCslDate, 0, "", , , , , , , , , , , _
                           vntRsvNo, vntDayId, , , _
                           vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntGender, vntBirth, , vntAge)
    
            '受診者情報が存在しない場合は処理を終了する
            If lngCount <= 0 Then
                objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "W", "", "検査依頼対象となる受診者は存在しませんでした。", ""
                Exit Do
            End If
        
        '予約番号指定の場合は
        Else
        
            '受診情報読み込み
            Ret = objConsult.SelectConsult( _
                      lngRsvNo, CONSULT_USED, vntCslDate, vntPerId, , , , , , , , _
                      vntAge, , , , , , , , , , , , , _
                      vntDayId, , , , , , , , , , , , , , , , , , _
                      vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender)
        
            '受診情報が存在しない場合は処理を終了する
            If Ret = False Then
                objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "W", "", "受診情報が存在しません。", "予約番号=" & lngRsvNo
                Exit Do
            End If
        
            '未受付の場合は処理を終了する
            If vntDayId = "" Then
                objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "W", "", "この受診情報は受付されていません。", "氏名=" & Trim(vntLastName & "　" & vntFirstName) & "（" & vntPerId & "）、予約番号=" & lngRsvNo
                Exit Do
            End If
        
            '一覧の場合と同処理が行えるよう、配列に変換
            dtmCslDate = vntCslDate
            vntRsvNo = Array(lngRsvNo)
            vntDayId = Array(vntDayId)
            vntPerId = Array(vntPerId)
            vntLastName = Array(vntLastName)
            vntFirstName = Array(vntFirstName)
            vntLastKName = Array(vntLastKName)
            vntFirstKName = Array(vntFirstKName)
            vntGender = Array(vntGender)
            vntBirth = Array(vntBirth)
            vntAge = Array(vntAge)
            lngCount = 1
            
        End If
        
        '受診情報の検索
        For i = 0 To lngCount - 1
        
            '個人ＩＤ未指定時、または指定された個人ＩＤの場合に依頼処理を行う
            If strPerId = "" Or vntPerId(i) = strPerId Then
        
                '氏名の編集
                strName = Trim(vntLastName(i) & "　" & vntFirstName(i))
                strKanaName = Trim(StrConv(vntLastKName(i) & " " & vntFirstKName(i), vbNarrow))
        
                dblPatientNo = 0

                '独立したトランザクションにて患者番号を発番
                dblPatientNo = objRequest.CreatePatientNo(lngTransactionId, vntPerId(i), strName)
                If dblPatientNo <= 0 Then
                    Exit Do
                End If
        
                '検査依頼ファイル作成
                If objRequest.CreateFile(lngTransactionId, vntReqCd, strFileName, dtmCslDate, vntRsvNo(i), vntDayId(i), vntPerId(i), strName, strKanaName, vntGender(i), vntBirth(i), Int(vntAge(i)), dblPatientNo, blnIncSentData) = True Then
                    
                    '送信レコード数をインクリメント
                    lngSentCount = lngSentCount + 1
                    
                End If
        
            End If
            
            
        Next i
        
        '送信対象となる受診情報が存在しなかった場合はログを発行する
        If lngSentCount = 0 Then
            objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "W", "", "検査依頼対象となる受診者は存在しませんでした。", ""
            Exit Do
        End If
        
        '送信件数をログ発行
        objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", lngSentCount & "件の検査依頼情報が作成されました。", ""
        
        Exit Do
    Loop
    
    '終了ログの発行
    objHainsLog.PutHainsLog lngTransactionId, TRANSACTIONDIV_REQUEST, "I", "", "検査依頼用のファイル作成処理を終了します。", ""
    
    '戻り値の設定
    CreateFile = lngSentCount
    
    Exit Function
    
ErrorHandle:

    '戻り値の設定
    CreateFile = -1

    'イベントログ書き込み
    WriteErrorLog "Request.CreateFile"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : Activateイベント
'
' 備考　　 : COMオブジェクトがアクティブ化された時点でデータベースへの接続を行う
'
Private Sub ObjectControl_Activate()

    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
    
End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

'
' 機能　　 : DeaActivateイベント
'
' 備考　　 : COMオブジェクトが非アクティブ化された時点でデータベースからの切断を行う
'
Private Sub ObjectControl_Deactivate()

End Sub
