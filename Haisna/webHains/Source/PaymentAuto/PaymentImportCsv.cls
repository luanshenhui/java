VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "PaymentImportCsv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession      As OraSession       'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase      'OraDatabaseオブジェクト

Private Const LENGTH_BILLNO             As Long = 14    '請求書番号
Private Const TRANSACTIONDIV_PAYMENTCSV As String = "LOGPAYCSV"         'ＣＳＶ一括入金処理用のログ処理ＩＤ

'項目位置情報
Private Const INDEX_REQUEST_DATE        As Long = 0                     '請求依頼日
Private Const INDEX_SLIP_NO             As Long = 1                     '請求書番号
Private Const INDEX_BOOK_DATE           As Long = 2                     '起票日
Private Const INDEX_BOOK_USER_ID        As Long = 3                     '起票者ユーザID
Private Const INDEX_H_SECTION_CODE      As Long = 4                     '起票部門コード
Private Const INDEX_CUSTOMER_CODE       As Long = 5                     '団体コード
Private Const INDEX_TOTAL_AMOUNT        As Long = 6                     '合計金額
Private Const INDEX_TE_TOTAL_AMOUNT     As Long = 7                     '合計金額（税抜き）
Private Const INDEX_TAX_FIX             As Long = 8                     '税額
Private Const INDEX_EXTRA_TEXT1         As Long = 9                     '予備テキスト１
Private Const INDEX_EXTRA_DATE1         As Long = 10                    '予備日付１
Private Const INDEX_ACCOUNT_DATE        As Long = 11                    '入金日
Private Const INDEX_CLEARING_DATE       As Long = 12                    '計上日

'項目長情報
Private Const LENGTH_REQUEST_DATE       As Long = 0                     '請求依頼日
Private Const LENGTH_SLIP_NO            As Long = 14                    '請求書番号
Private Const LENGTH_BOOK_DATE          As Long = 0                     '起票日
Private Const LENGTH_BOOK_USER_ID       As Long = 32                    '起票者ユーザID
Private Const LENGTH_H_SECTION_CODE     As Long = 22                    '起票部門コード
Private Const LENGTH_CUSTOMER_CODE      As Long = 10                    '団体コード
Private Const LENGTH_TOTAL_AMOUNT       As Long = 22                    '合計金額
Private Const LENGTH_TE_TOTAL_AMOUNT    As Long = 22                    '合計金額（税抜き）
Private Const LENGTH_TAX_FIX            As Long = 22                    '税額
Private Const LENGTH_EXTRA_TEXT1        As Long = 200                   '予備テキスト１
Private Const LENGTH_EXTRA_DATE1        As Long = 0                     '予備日付１
Private Const LENGTH_ACCOUNT_DATE       As Long = 0                     '入金日
Private Const LENGTH_CLEARING_DATE      As Long = 0                     '計上日

'項目名情報
Private Const NAME_REQUEST_DATE         As String = "請求依頼日"        '請求依頼日
Private Const NAME_SLIP_NO              As String = "請求書番号"        '請求書番号
Private Const NAME_BOOK_DATE            As String = "起票日"            '起票日
Private Const NAME_BOOK_USER_ID         As String = "起票者ユーザID"    '起票者ユーザID
Private Const NAME_H_SECTION_CODE       As String = "起票部門コード"    '起票部門コード
Private Const NAME_CUSTOMER_CODE        As String = "団体コード"        '団体コード
Private Const NAME_TOTAL_AMOUNT         As String = "合計金額"          '合計金額
Private Const NAME_TE_TOTAL_AMOUNT      As String = "合計金額（税抜き）" '合計金額（税抜き）
Private Const NAME_TAX_FIX              As String = "税額"              '税額
Private Const NAME_EXTRA_TEXT1          As String = "予備テキスト１"    '予備テキスト１
Private Const NAME_EXTRA_DATE1          As String = "予備日付１"        '予備日付１
Private Const NAME_ACCOUNT_DATE         As String = "入金日"            '入金日
Private Const NAME_CLEARING_DATE        As String = "計上日"            '計上日


'
' 機能　　 : 配列に格納されたＣＳＶデータのチェックを行う
'
' 引数　　 : (In)     vntNames     項目名
' 　　　　   (In)     vntColumns   カラム値
' 　　　　   (In)     vntLengths   項目長
' 　　　　   (Out)    vntMessage1  メッセージ１
' 　　　　   (Out)    vntMessage2  メッセージ２
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub CheckColumnValue( _
    ByRef vntNames As Variant, _
    ByRef vntColumns As Variant, _
    ByRef vntLengths As Variant, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
)

    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    
    Dim strStdMessage1  As String   '基本メッセージ１
    Dim strStdMessage2  As String   '基本メッセージ２
    
    Dim blnTooLong      As Boolean  '項目長が長すぎる場合にTrue
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    Dim lngNameIndex    As Long     '項目名情報のインデックス
    Dim strMessage      As String   'メッセージ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '基本メッセージの作成(請求番号と金額をもって基本メッセージとする)
    strMessage = ""
    strMessage = strMessage & NAME_CUSTOMER_CODE & "=" & IIf(vntColumns(INDEX_CUSTOMER_CODE) <> "", vntColumns(INDEX_CUSTOMER_CODE), "なし")
    strMessage = strMessage & "、"
    strMessage = strMessage & NAME_SLIP_NO & "=" & IIf(vntColumns(INDEX_SLIP_NO) <> "", vntColumns(INDEX_SLIP_NO), "なし")
    strMessage = strMessage & "、"
    strMessage = strMessage & NAME_TOTAL_AMOUNT & "=" & IIf(vntColumns(INDEX_TOTAL_AMOUNT) <> "", vntColumns(INDEX_TOTAL_AMOUNT), "なし")
    
    
    '項目単位のチェック
    For i = LBound(vntColumns) To UBound(vntColumns)
    
        'セット分類に注意しつつ、現在チェック対象である項目の、項目名情報におけるインデックスを定義
        lngNameIndex = IIf(i >= INDEX_CLEARING_DATE, INDEX_CLEARING_DATE, i)
    
        '必須項目のチェック
        Select Case i
        
            '請求書番号、起票部門コード、団体コード、合計金額、計上日は必須チェックを行う
            Case INDEX_SLIP_NO, INDEX_H_SECTION_CODE, INDEX_CUSTOMER_CODE, INDEX_TOTAL_AMOUNT, INDEX_CLEARING_DATE

                If vntColumns(i) = "" Then
                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。", strMessage
                End If
            
            Case Else
        
        End Select
            
        '項目値が存在する場合のチェック処理
        Do
        
            ''項目値が存在しなければ制御を抜ける
            If vntColumns(i) = "" Then
                Exit Do
            End If
        
            blnTooLong = False
            
            '基本メッセージの作成
            strStdMessage1 = vntNames(lngNameIndex) & "の値が長すぎます。"
            strStdMessage2 = strMessage & "、" & vntNames(lngNameIndex) & "=" & vntColumns(i)
            
            '項目長のチェック
            Select Case i
            
                '請求書番号のチェックを行う
                Case INDEX_SLIP_NO
                    
                    If LenB(StrConv(vntColumns(i), vbFromUnicode)) > vntLengths(i) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        blnTooLong = True
                    End If
                
                '請求依頼日、起票日、入金日、計上日については日付形式のため以降のチェックを行う
                Case INDEX_REQUEST_DATE, INDEX_BOOK_DATE, INDEX_ACCOUNT_DATE, INDEX_CLEARING_DATE
            
                'それ以外の通常の項目長チェック
                Case Else
            
            End Select
            
            
            
            '項目長エラー時は処理を抜ける
            If blnTooLong Then
                Exit Do
            End If
            
            '基本メッセージの作成
            strStdMessage1 = vntNames(lngNameIndex) & "が無効です。"
            
            '項目タイプごとのチェック
            Select Case i
            
                '請求依頼日、起票日、入金日、計上日については日付チェックを行う
                Case INDEX_REQUEST_DATE, INDEX_BOOK_DATE, INDEX_ACCOUNT_DATE, INDEX_CLEARING_DATE
                    
                    If CnvDate(vntColumns(i)) = "" Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が日付として認識できません。", strStdMessage2
                    End If
                    
                    
            End Select
                    
            Exit Do
        Loop
        
    Next i

    '戻り値の設定
    vntMessage1 = vntArrMessage1
    vntMessage2 = vntArrMessage2

    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PaymentImportCsv.CheckColumnValue"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : ＣＳＶデータ内各項目値のチェックを行う
'
' 引数　　 : (In)     strCsvStream  ＣＳＶデータ
' 　　　　   (In)     vntNames      項目名の配列
' 　　　　   (In)     vntLengths    項目長の配列
' 　　　　   (Out)    vntColumns    項目値の配列
' 　　　　   (Out)    vntMessage1   メッセージ１
' 　　　　   (Out)    vntMessage2   メッセージ２
'
' 戻り値　 : True   エラーなし
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Private Function CheckCsv( _
    ByRef strCsvStream As String, _
    ByRef vntNames As Variant, _
    ByRef vntLengths As Variant, _
    ByRef vntColumns As Variant, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
) As Boolean

    Dim vntArrColumns   As Variant  '項目値の配列
    Dim lngMaxArraySize As Long     '設定すべき配列の最大サイズ
    
    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntColumns = Empty
    vntMessage1 = Empty
    vntMessage2 = Empty
    
    Do
    
        'レコードが存在しない場合はエラー
        If strCsvStream = "" Then
            AppendMessage vntArrMessage1, vntArrMessage2, "取り込みデータが存在しません。"
            Exit Do
        End If
    
        '一旦カンマ分離を行い、要素数がいくつ存在するかを検索
        vntArrColumns = Split(strCsvStream, ",")
    
        '最大要素数は今検索した配列の要素数そのものとする
        lngMaxArraySize = UBound(vntArrColumns)
    
        vntArrColumns = Empty
        
        'レコード値の配列化
        SetColumnsArrayFromCsvString strCsvStream, lngMaxArraySize, vntArrColumns
    
        'CSVデータの項目値チェック
        CheckColumnValue vntNames, vntArrColumns, vntLengths, vntArrMessage1, vntArrMessage2
        
        'エラー存在時は処理終了
        If Not IsEmpty(vntArrMessage1) Then
            Exit Do
        End If
        
        CheckCsv = True
        
        Exit Do
    Loop
    
    '戻り値の編集
    vntColumns = vntArrColumns
    vntMessage1 = vntArrMessage1
    vntMessage2 = vntArrMessage2
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PaymentImportCsv.CheckCsv"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ＣＳＶファイルから入金情報の作成を行う
'
' 引数　　 : (In)     strFileName     ＣＳＶファイル名
' 　　　　   (In)     strUserId       ユーザＩＤ
' 　　　　   (In)     lngStartPos     読み込み開始位置
' 　　　　   (In)     strOutFilePath  出力ファイルの書き出し位置
' 　　　　   (In/Out) vntOutFileName  出力ファイル名
' 　　　　   (Out)    vntReadCount    読み込みレコード数
' 　　　　   (Out)    vntWriteCount   作成受診情報数
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub ImportCsv( _
    ByVal strFileName As String, _
    ByVal strUserId As String, _
    ByVal lngStartPos As Long, _
    ByVal strOutFilePath As String, _
    ByRef vntOutFileName As Variant, _
    Optional ByRef vntReadCount As Variant, _
    Optional ByRef vntWriteCount As Variant _
)
    
    Dim objFso              As Object       'ファイルシステムオブジェクト
    Dim objContract         As Object       '契約情報アクセス用
    Dim objCreateCsv        As Object       'ＣＳＶデータ作成用
    Dim objFree             As Object       '汎用情報アクセス用
    Dim objHainsLog         As Object       'ログ情報アクセス用

    Dim vntNames            As Variant      '項目名の配列
    Dim vntLengths          As Variant      '項目長の配列
    Dim vntColumns          As Variant      '項目値の配列
    Dim lngElemCount        As Long         '配列の要素数
    
    Dim lngTransId          As Long         'トランザクションＩＤ

    Dim vntTitle            As Variant      '表題

    Dim intInFileNo         As Integer      'ファイル番号
    Dim intOutFileNo        As Integer      'ファイル番号
    Dim strTempFileName     As String       '出力用一時ファイル名
    Dim strOutFileName      As String       '出力ファイル名
    Dim strBuffer           As String       '文字列バッファ
    Dim strOutBuffer        As String       '文字列バッファ

    Dim lngLineNo           As Long         '行番号

    Dim strBillNo           As String       '請求番号（締め日＋請求書SEQ＋請求書枝番）
    Dim strOgrName          As String       '団体名称
    Dim strBillPrice        As String       '請求額（Hains）
    Dim strPaymentPrice     As String       '入金額（Hains）
    Dim strTotalAmount      As String       '入金額（COMPANY）
    Dim strStatement        As String       'SQL
    
    Dim lngReadCount        As Long         '読み込みレコード数
    Dim lngWriteCount       As Long         '作成受診情報数

    Dim vntMessage1         As Variant      'メッセージ１の配列
    Dim vntMessage2         As Variant      'メッセージ２の配列

    Dim strWkFileName       As String       'ファイル名
    Dim strMessage          As String       'メッセージ
    Dim Ret                 As Boolean      '関数戻り値
    Dim Ret2                As Long         '関数戻り値
    Dim i                   As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '出力ファイルパス値の補正
    strOutFilePath = strOutFilePath & IIf(Right(strOutFilePath, 1) <> "\", "\", "")
    
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    
    'トランザクションＩＤの取得
    lngTransId = objHainsLog.IncreaseTransactionId()
    
    Set objHainsLog = Nothing


    '項目名の配列を作成
    vntNames = Array(NAME_REQUEST_DATE, NAME_SLIP_NO, NAME_BOOK_DATE, NAME_BOOK_USER_ID, NAME_H_SECTION_CODE, NAME_CUSTOMER_CODE, NAME_TOTAL_AMOUNT, NAME_TE_TOTAL_AMOUNT, NAME_TAX_FIX, NAME_EXTRA_TEXT1, NAME_EXTRA_DATE1, NAME_ACCOUNT_DATE, NAME_CLEARING_DATE)
    lngElemCount = UBound(vntNames) + 1

    '項目長の配列を作成
    vntLengths = Array(LENGTH_REQUEST_DATE, LENGTH_SLIP_NO, LENGTH_BOOK_DATE, LENGTH_BOOK_USER_ID, LENGTH_H_SECTION_CODE, LENGTH_CUSTOMER_CODE, LENGTH_TOTAL_AMOUNT, LENGTH_TE_TOTAL_AMOUNT, LENGTH_TAX_FIX, LENGTH_EXTRA_TEXT1, LENGTH_EXTRA_DATE1, LENGTH_ACCOUNT_DATE, LENGTH_CLEARING_DATE)
    lngElemCount = UBound(vntLengths) + 1

    
    
    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_PAYMENTCSV, "I", "", vntTitle & "処理を開始します。", ""

    '指定されたパラメータ情報を編集する
    Do

        Set objFso = CreateObject("Scripting.FileSystemObject")
        
        'ファイルの存在をチェック
        Ret = objFso.FileExists(strFileName)
        
        Set objFso = Nothing
        
        'ファイルが存在しない場合は処理を終了する
        If Ret = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_PAYMENTCSV, "E", "", "ファイルが存在しません。", "ファイル名=" & strFileName
            Exit Do
        End If

        Set objFso = CreateObject("Scripting.FileSystemObject")
    
        '一時ファイル名をランダムに作成
        strTempFileName = objFso.GetTempName
    
        Set objFso = Nothing
    
        'CSVファイルオープン
        intInFileNo = FreeFile()
        Open strFileName For Input Lock Read Write As #intInFileNo

        '出力用一時ファイルオープン
        intOutFileNo = FreeFile()
        Open strOutFilePath & strTempFileName For Output As #intOutFileNo

        'ファイル読み込み
        Do Until EOF(intInFileNo)

            Do

                '１行読み込み
                Line Input #intInFileNo, strBuffer

                '行番号をインクリメント
                lngLineNo = lngLineNo + 1
                
                '行番号が読み込み開始位置に達していない場合はスキップ
                If lngLineNo < lngStartPos Then
                    Print #intOutFileNo, strBuffer & ",,,,,,,,"
                    Exit Do
                End If

                '行データが存在しない場合はスキップ
                If Trim(strBuffer) = "" Then
                    Print #intOutFileNo, ""
                    Exit Do
                End If

                '読み込みレコード数のインクリメント
                lngReadCount = lngReadCount + 1
                
'##################################################################################################################################################
                'CSVデータのチェック
                Ret = CheckCsv(strBuffer, vntNames, vntLengths, vntColumns, vntMessage1, vntMessage2)
'##################################################################################################################################################

                'データエラー時
                If Ret = False Then
                    
                    'ログを発行
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_PAYMENTCSV, "E", lngLineNo, vntMessage1, vntMessage2
                    
                    '出力ファイル用のレコード編集
                    strOutBuffer = strBuffer
                    strOutBuffer = strOutBuffer & "," & "×"
                    strOutBuffer = strOutBuffer & "," & ""
                    strOutBuffer = strOutBuffer & "," & ""
                    strOutBuffer = strOutBuffer & "," & ""
                    strOutBuffer = strOutBuffer & "," & ""
                    strOutBuffer = strOutBuffer & "," & "不正なデータがあります。,,"
                    
                    '出力ファイル書き出し
                    Print #intOutFileNo, strOutBuffer
                    
                    Exit Do
                End If

'##################################################################################################################################################
                '請求情報チェック、入金情報チェック、入金情報の作成を行う
                Ret2 = InsertPayment(lngTransId, strUserId, lngLineNo, vntColumns, strBillNo, strOgrName, strBillPrice, strPaymentPrice, strTotalAmount)
'##################################################################################################################################################

                '出力ファイル用のレコード編集
                strOutBuffer = strBuffer
                strOutBuffer = strOutBuffer & "," & IIf(Ret2 = 1, "○", "×")
                strOutBuffer = strOutBuffer & "," & strBillNo
                strOutBuffer = strOutBuffer & "," & strOgrName
                strOutBuffer = strOutBuffer & "," & strBillPrice
                strOutBuffer = strOutBuffer & "," & strPaymentPrice
                strOutBuffer = strOutBuffer & "," & strTotalAmount
                
                '処理結果を追加
                Select Case Ret2
                    
                    Case 0  '正常時
                    
                        strOutBuffer = strOutBuffer & "," & "正常に入金処理できました。,,"
                
                    Case 1  '正常時
                        strOutBuffer = strOutBuffer & "," & "正常に入金処理できました。,,"
                    
                    Case -1 '請求情報が存在しない
                        strOutBuffer = strOutBuffer & "," & "請求情報がありません。,,"
                
                    Case -2 '既に入金情報が存在する（入金済）
                        strOutBuffer = strOutBuffer & "," & "既に入金情報が存在します。,,"
                
                    Case -3 '請求額と入金額が異なる
                        strOutBuffer = strOutBuffer & "," & "請求額と入金額が一致しません。,,"
                
                    Case -4 '取消請求情報
                        strOutBuffer = strOutBuffer & "," & "取消請求情報です。,,"
                
                    Case -5 '団体コードが異なる
                        strOutBuffer = strOutBuffer & "," & "団体情報が一致しません。,,"
                
                End Select
                
                '出力ファイル書き出し
                Print #intOutFileNo, strOutBuffer

                '作成受診情報数のインクリメント
                If Ret2 = 1 Then
                    lngWriteCount = lngWriteCount + 1
                End If
                
                Exit Do
            Loop

        Loop

        'ファイルクローズ
        Close #intInFileNo
        Close #intOutFileNo

        Exit Do
    Loop

    Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
    
    '重複しないファイル名取得
    strWkFileName = objCreateCsv.GetNewFile(strOutFilePath & vntOutFileName)
    
    Set objCreateCsv = Nothing
    
    '出力用一時ファイルを変名
    Name strOutFilePath & strTempFileName As strWkFileName
    
    'パス部を除去し、戻り値として返す
    vntOutFileName = Right(strWkFileName, Len(strWkFileName) - InStrRev(strWkFileName, "\"))
    
    '他戻り値の設定
    If Not IsMissing(vntReadCount) Then vntReadCount = lngReadCount
    If Not IsMissing(vntWriteCount) Then vntWriteCount = lngWriteCount
    
    '終了ログの発行
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_PAYMENTCSV, "I", "", lngReadCount & "件のレコードが読み込まれました。", ""
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_PAYMENTCSV, "I", "", lngWriteCount & "件の入金情報が作成されました。", ""
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_PAYMENTCSV, "I", "", vntTitle & "処理を終了します。", ""

    Exit Sub

ErrorHandle:

    'ファイルクローズ
    Close #intInFileNo
    Close #intOutFileNo

    'イベントログ書き込み
    WriteErrorLog "PaymentImportCsv.ImportCsv"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub


' 機能　　 : 入金情報を挿入する
'
' 引数　　 : (In)     lngTransId        トランザクションＩＤ
' 　　　　   (In)     strUserId         ユーザＩＤ
' 　　　　   (In)     lngLineNo         行番号
' 　　　　   (In)     vntColumns        項目値の配列
' 　　　　   (Out)    strBillNo         請求番号
' 　　　　   (Out)    strOgrName        団体名称
' 　　　　   (Out)    strBillPrice      請求額
' 　　　　   (Out)    strPaymentPrice   入金額（Hains）
' 　　　　   (Out)    strTotalAmount    入金額（COMPANY）
'
' 戻り値　 : 1   正常終了
' 　　　　 : 0   同一キーのレコード存在
' 　　　　 : -1  異常終了
'
' 備考　　 :
'
Public Function InsertPayment(ByRef lngTransId As Long, _
                              ByRef strUserId As String, _
                              ByRef lngLineNo As Long, _
                              ByRef vntColumns As Variant, _
                              ByRef strBillNo As String, _
                              ByRef strOrgName As String, _
                              ByRef strBillPrice As String, _
                              ByRef strPaymentPrice As String, _
                              ByRef strTotalAmount As String _
                             ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objDemand           As Object           '入金情報登録用
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCloseDate        As OraField         '締め日
    Dim objBillSeq          As OraField         '請求書SEQ
    Dim objBranchNo         As OraField         '請求書枝番
    Dim objDelFlg           As OraField         '削除フラグ
    Dim objOrgCd            As OraField         '団体コード
    Dim objOrgName          As OraField         '団体名
    Dim objBillPrice        As OraField         '請求金額（税込）
    Dim objPaymentPrice     As OraField         '入金金額
    
    
    Dim strCloseDate        As String   '締め日
    Dim lngBillSeq          As Long     '請求書SEQ
    Dim lngBranchNo         As Long     '請求書枝番
    Dim lngDelFlg           As Long     '取消区分
    Dim lngBillPrice        As Long     '請求額
    Dim strPaymentDate      As String   '入金日
    Dim lngPaymentPrice     As Long     '入金額
    Dim lngPaymentDiv       As Long     '入金種別
    
    Dim strOrgCd            As String   '団体コード
    
    Dim lngCount            As Long     'レコードカウント
    Dim Ret                 As Long     '関数戻り値
    Dim blnIsBillNo         As Boolean  'パラメタに請求書番号が指定されている
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    blnIsBillNo = False
    
    '請求書番号の妥当性チェック
    If Trim(CStr(vntColumns(INDEX_SLIP_NO))) <> "" Then
        
        strBillNo = Trim(CStr(vntColumns(INDEX_SLIP_NO)))
        
        If IsNumeric(strBillNo) = True Then
            If CDbl(strBillNo) > 0 Then
                If (Len(strBillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(strBillNo, 1, 4) & "/" & Mid(strBillNo, 5, 2) & "/" & Mid(strBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(strBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(strBillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If
    
    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
'    '入金日、計上日中どちらを入金日として登録するか要確認
'    objOraParam.Add "PAYMENTDATE", CDate(CnvDate(vntColumns(INDEX_CLEARING_DATE))), ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "PAYMENTPRICE", CLng(vntColumns(INDEX_TOTAL_AMOUNT)), ORAPARM_INPUT, ORATYPE_NUMBER
'
'    '入金種別は「3：振込固定」
'    objOraParam.Add "PAYMENTDIV", 3, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "UPDUSER", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'    objOraParam.Add "PAYNOTE", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "CARDKIND", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "CREDITSLIPNO", Null, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "BANKCODE", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "REGISTERNO", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "CASH", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '########################################################################################################
    '請求情報、入金情報チェック
    '########################################################################################################
    
    strStmt = "SELECT BILL.CLOSEDATE                      AS CLOSEDATE                          " & vbLf & _
              "      ,BILL.BILLSEQ                        AS BILLSEQ                            " & vbLf & _
              "      ,BILL.BRANCHNO                       AS BRANCHNO                           " & vbLf & _
              "      ,BILL.DELFLG                         AS DELFLG                             " & vbLf & _
              "      ,BILL.ORGCD1 || '-' || BILL.ORGCD2   AS ORGCD                              " & vbLf & _
              "      ,ORG.ORGNAME                         AS ORGNAME                            " & vbLf & _
              "      ,NVL(TOTALBASE.TOTAL, 0)+NVL(TOTALBASE_ITEMS.TOTAL, 0)   AS BILLPRICE      " & vbLf & _
              "      ,NVL(PAYMENTBASE.PAYMENTPRICE, 0)                        AS PAYMENTPRICE   "

    strStmt = strStmt & vbLf & _
              "  FROM BILL                                                              " & vbLf & _
              "      ,ORG                                                               " & vbLf & _
              "      ,( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                            " & vbLf & _
              "                SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX) TOTAL        " & vbLf & _
              "           FROM BILLDETAIL                                               " & vbLf & _
              "          WHERE CLOSEDATE = :CLOSEDATE                                   " & vbLf & _
              "            AND BILLSEQ   = :BILLSEQ                                     " & vbLf & _
              "            AND BRANCHNO  = :BRANCHNO                                    " & vbLf & _
              "          GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                          " & vbLf & _
              "       ) TOTALBASE                                                       "

    strStmt = strStmt & vbLf & _
              "      ,( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                            " & vbLf & _
              "                SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX) TOTAL        " & vbLf & _
              "           FROM BILLDETAIL_ITEMS                                         " & vbLf & _
              "          WHERE CLOSEDATE = :CLOSEDATE                                   " & vbLf & _
              "            AND BILLSEQ   = :BILLSEQ                                     " & vbLf & _
              "            AND BRANCHNO  = :BRANCHNO                                    " & vbLf & _
              "          GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                          " & vbLf & _
              "       ) TOTALBASE_ITEMS                                                 "

    strStmt = strStmt & vbLf & _
              "      ,( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                            " & vbLf & _
              "                SUM(PAYMENTPRICE) PAYMENTPRICE                           " & vbLf & _
              "           FROM PAYMENT                                                  " & vbLf & _
              "          WHERE CLOSEDATE = :CLOSEDATE                                   " & vbLf & _
              "            AND BILLSEQ   = :BILLSEQ                                     " & vbLf & _
              "            AND BRANCHNO  = :BRANCHNO                                    " & vbLf & _
              "          GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                          " & vbLf & _
              "       ) PAYMENTBASE                                                     "

    strStmt = strStmt & vbLf & _
              " WHERE BILL.CLOSEDATE        = :CLOSEDATE                                " & vbLf & _
              "   AND BILL.BILLSEQ          = :BILLSEQ                                  " & vbLf & _
              "   AND BILL.BRANCHNO         = :BRANCHNO                                 " & vbLf & _
              "   AND ORG.ORGCD1            = BILL.ORGCD1                               " & vbLf & _
              "   AND ORG.ORGCD2            = BILL.ORGCD2                               " & vbLf & _
              "   AND BILL.CLOSEDATE        = TOTALBASE.CLOSEDATE(+)                    " & vbLf & _
              "   AND BILL.BILLSEQ          = TOTALBASE.BILLSEQ(+)                      " & vbLf & _
              "   AND BILL.BRANCHNO         = TOTALBASE.BRANCHNO(+)                     " & vbLf & _
              "   AND BILL.CLOSEDATE        = PAYMENTBASE.CLOSEDATE(+)                  " & vbLf & _
              "   AND BILL.BILLSEQ          = PAYMENTBASE.BILLSEQ(+)                    " & vbLf & _
              "   AND BILL.BRANCHNO         = PAYMENTBASE.BRANCHNO(+)                   " & vbLf & _
              "   AND BILL.CLOSEDATE        = TOTALBASE_ITEMS.CLOSEDATE(+)              " & vbLf & _
              "   AND BILL.BILLSEQ          = TOTALBASE_ITEMS.BILLSEQ(+)                " & vbLf & _
              "   AND BILL.BRANCHNO         = TOTALBASE_ITEMS.BRANCHNO(+)               "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objDelFlg = objFields("DELFLG")
        Set objOrgCd = objFields("ORGCD")
        Set objOrgName = objFields("ORGNAME")
        Set objBillPrice = objFields("BILLPRICE")
        Set objPaymentPrice = objFields("PAYMENTPRICE")

        lngDelFlg = objDelFlg.Value
        strOrgCd = objOrgCd.Value
        strOrgName = objOrgName.Value
        lngBillPrice = objBillPrice.Value
        lngPaymentPrice = objPaymentPrice.Value

        strBillPrice = objBillPrice.Value & ""
        strPaymentPrice = objPaymentPrice.Value & ""
        strTotalAmount = CStr(vntColumns(INDEX_TOTAL_AMOUNT))

        Do
            '入金済チェック
            If lngPaymentPrice > 0 Then
                Ret = -2
                Exit Do
            End If

            '請求額と入金額チェック
            If lngBillPrice <> CLng(vntColumns(INDEX_TOTAL_AMOUNT)) Then
                Ret = -3
                Exit Do
            End If

            '請求書取消チェック
            If lngDelFlg = 1 Then
                Ret = -4
                Exit Do
            End If

            '団体コードチェック
            If strOrgCd <> CStr(vntColumns(INDEX_CUSTOMER_CODE)) Then
                Ret = -5
                Exit Do
            End If
            
            
            '########################################################################################################
            '入金情報登録
            '########################################################################################################
            
            Set objDemand = CreateObject("HainsDemand.Demand")
    
            '入金情報の書き込み
            Ret = objDemand.InsertPayment(CDate(strCloseDate), lngBillSeq, lngBranchNo, _
                                          CDate(CnvDate(vntColumns(INDEX_CLEARING_DATE))), _
                                          CLng(vntColumns(INDEX_TOTAL_AMOUNT)), _
                                          3, _
                                          strUserId, "", "", "", "", "", "")
            Set objDemand = Nothing
            
            '########################################################################################################
        
        
'            strStmt = "INSERT INTO PAYMENT (" & vbLf & _
'                      "       CLOSEDATE,    " & vbLf & _
'                      "       BILLSEQ,      " & vbLf & _
'                      "       BRANCHNO,     " & vbLf & _
'                      "       SEQ,          " & vbLf & _
'                      "       PAYMENTDATE,  " & vbLf & _
'                      "       PAYMENTPRICE, " & vbLf & _
'                      "       PAYMENTDIV,   " & vbLf & _
'                      "       UPDUSER,      " & vbLf & _
'                      "       PAYNOTE,      " & vbLf & _
'                      "       CARDKIND,     " & vbLf & _
'                      "       CREDITSLIPNO, " & vbLf & _
'                      "       BANKCODE,     " & vbLf & _
'                      "       REGISTERNO,   " & vbLf & _
'                      "       CASH          "
'
'            strStmt = strStmt & vbLf & _
'                      "       ) VALUES (    " & vbLf & _
'                      "       :CLOSEDATE,   " & vbLf & _
'                      "       :BILLSEQ,     " & vbLf & _
'                      "       :BRANCHNO,    " & vbLf & _
'                      "       1,            " & vbLf & _
'                      "       :PAYMENTDATE, " & vbLf & _
'                      "       :PAYMENTPRICE," & vbLf & _
'                      "       :PAYMENTDIV,  " & vbLf & _
'                      "       :UPDUSER,     " & vbLf & _
'                      "       :PAYNOTE,     " & vbLf & _
'                      "       :CARDKIND,    " & vbLf & _
'                      "       :CREDITSLIPNO," & vbLf & _
'                      "       :BANKCODE,    " & vbLf & _
'                      "       :REGISTERNO,  " & vbLf & _
'                      "       :CASH         " & vbLf & _
'                      "       )"
'
'            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
            
'            '登録ログの発行
'            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_PAYMENTCSV, "I", "", objOraParam("CLOSEDATE").Value & " " & CStr(CnvDate(vntColumns(INDEX_CLEARING_DATE))) & "  " & CStr(vntColumns(INDEX_TOTAL_AMOUNT)) & " 登録を1件完了しました。", ""
            
            Exit Do
        Loop

    Else
        '請求情報が存在しない
        Ret = -1
    End If
    
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'    Set objOraParam = Nothing
    
    '戻り値の設定
    InsertPayment = Ret
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "PaymentImportCsv.InsertPayment"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : Activateイベント
'
' 備考　　 : COMオブジェクトがアクティブ化された時点でデータベースへの接続を行う
'
Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス

    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    'データベース接続
    Set mobjOraSession = mobjContext.CreateInstance("OracleInProcServer.XOraSession")
    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, ORADB_ENLIST_IN_MTS)


End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

'
' 機能　　 : DeaActivateイベント
'
' 備考　　 : COMオブジェクトが非アクティブ化された時点でデータベースからの切断を行う
'
Private Sub ObjectControl_Deactivate()

    'データベース切断
    Set mobjOraSession = Nothing
    Set mobjOraDb = Nothing

    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing

End Sub

