VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ImportPerWorkInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const TRANSACTIONDIV_PWKCSV As String = "LOGPWKCSV" '就労情報取り込み用のログ処理ＩＤ

Private Const INDEX_EMPNO           As Long = 0 '従業員番号
Private Const INDEX_NIGHTWORKCNT    As Long = 1 '夜業回数
Private Const INDEX_OVERTIME        As Long = 2 '時間外就労時間
Private Const INDEX_DATADATE        As Long = 3 '発生年月

Private Const LENGTH_EMPNO          As Long = 7 '従業員番号
Private Const LENGTH_NIGHTWORKCNT   As Long = 2 '夜業回数
Private Const LENGTH_OVERTIME_INT   As Long = 3 '時間外就労時間(整数部)
Private Const LENGTH_OVERTIME_DEC   As Long = 1 '時間外就労時間(小数部)

Private Const NAME_EMPNO            As String = "従業員番号"        '従業員番号
Private Const NAME_NIGHTWORKCNT     As String = "夜業回数"          '夜業回数
Private Const NAME_OVERTIME         As String = "時間外就労時間"    '時間外就労時間
Private Const NAME_DATADATE         As String = "発生年月"          '発生年月

'
' 機能　　 : 配列に格納されたCSVデータのチェックを行う
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
Private Sub CheckColumnValue(ByRef vntNames As Variant, ByRef vntColumns As Variant, ByRef vntMessage1 As Variant, ByRef vntMessage2 As Variant)

    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    
    Dim strExpression   As String   '文字列式
    Dim lngSize         As Long     '文字列長
    
    Dim strMessage      As String   'メッセージ
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    '項目単位のチェック
    For i = LBound(vntNames) To UBound(vntNames)
    
        strMessage = vntNames(i) & "=" & vntColumns(i)
        
        Do
            
            '各項目のチェック
            Select Case i
            
                '従業員番号
                Case INDEX_EMPNO
            
                    '必須チェック
                    If vntColumns(i) = "" Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。"
                        Exit Do
                    End If
                    
                    '項目長のチェック
                    If LenB(StrConv(vntColumns(i), vbFromUnicode)) > LENGTH_EMPNO Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "の値が長すぎます。", strMessage
                        Exit Do
                    End If
            
                '夜業回数
                Case INDEX_NIGHTWORKCNT
            
                    '数字チェック
                    If vntColumns(i) <> "" Then
                        If Not CheckNumber2(vntColumns(i), LENGTH_NIGHTWORKCNT) Then
                            AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "の値が正しくありません。", strMessage
                        End If
                    End If
                    
                '時間外就労時間
                Case INDEX_OVERTIME
                
                    '数字チェック
                    If vntColumns(i) <> "" Then
                        If Not CheckNumber2(vntColumns(i), LENGTH_OVERTIME_INT, LENGTH_OVERTIME_DEC) Then
                            AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "の値が正しくありません。", strMessage
                        End If
                    End If

                '発生年月
                Case INDEX_DATADATE
                
                    '必須チェック
                    If vntColumns(i) = "" Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。"
                        Exit Do
                    End If
                
                    '年月チェック
                    If Not CheckDate(vntColumns(i), 1) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が年月として認識できません。", strMessage
                        Exit Do
                    End If

            End Select
                    
            Exit Do
        Loop
        
    Next i

    '戻り値の設定
    vntMessage1 = vntArrMessage1
    vntMessage2 = vntArrMessage2

End Sub

'
' 機能　　 : ＣＳＶデータ内各項目値のチェックを行う
'
' 引数　　 : (In)     strCsvStream     ＣＳＶデータ
' 　　　　   (In)     vntNames         項目名の配列
' 　　　　   (Out)    strEmpNo         従業員番号
' 　　　　   (Out)    dtmDataDate      発生日付
' 　　　　   (Out)    lngNightWorkCnt  夜業回数
' 　　　　   (Out)    dblOverTime      時間外就労時間
' 　　　　   (Out)    vntMessage1      メッセージ１
' 　　　　   (Out)    vntMessage2      メッセージ２
'
' 戻り値　 : True   エラーなし
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Private Function CheckCsv( _
    ByRef strCsvStream As String, _
    ByRef vntNames As Variant, _
    ByRef strEmpNo As String, _
    ByRef dtmDataDate As Date, _
    ByRef lngNightWorkCnt As Long, _
    ByRef dblOverTime As Double, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
) As Boolean

    Dim vntColumns      As Variant  '各カラムの集合
    
    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    Dim Ret             As Boolean  '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    strEmpNo = ""
    dtmDataDate = 0
    lngNightWorkCnt = 0
    dblOverTime = 0

    vntMessage1 = Empty
    vntMessage2 = Empty
    
    Do
        
        'レコードが存在しない場合はエラー
        If strCsvStream = "" Then
            AppendMessage vntArrMessage1, vntArrMessage2, "取り込みデータが存在しません。"
            Exit Do
        End If
    
        'レコード値の配列化
        SetColumnsArrayFromCsvString strCsvStream, INDEX_DATADATE, vntColumns
    
        'CSVデータの項目値チェック
        CheckColumnValue vntNames, vntColumns, vntArrMessage1, vntArrMessage2
        If Not IsEmpty(vntArrMessage1) Then
            Exit Do
        End If
        
        '戻り値の設定
        strEmpNo = vntColumns(INDEX_EMPNO)
        
        If vntColumns(INDEX_NIGHTWORKCNT) <> "" Then
            lngNightWorkCnt = vntColumns(INDEX_NIGHTWORKCNT)
        End If
        
        If vntColumns(INDEX_OVERTIME) <> "" Then
            dblOverTime = vntColumns(INDEX_OVERTIME)
        End If
        
        If InStr(vntColumns(INDEX_DATADATE), "/") > 0 Then
            dtmDataDate = vntColumns(INDEX_DATADATE) & "/1"
        Else
            dtmDataDate = Format(vntColumns(INDEX_DATADATE), "@@@@/@@/1")
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    vntMessage1 = vntArrMessage1
    vntMessage2 = vntArrMessage2
    
    CheckCsv = Ret
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ImportPerWorkInfo.CheckCsv"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 個人就労情報の取り込みを行う
'
' 引数　　 : (In)     strFileName      就労情報ファイル名
' 　　　　   (In)     strOrgCd1        団体コード１
' 　　　　   (In)     strOrgCd2        団体コード２
' 　　　　   (In)     blnSkipFirstRow  True指定時、先頭行を見出し行とみなしてスキップする
'
' 戻り値　 :
'
' 備考　　 :
'
'## 2003.01.29 Mod 21Lines By T.Takagi@FSIT 先頭行スキップ機能追加
'Public Sub ImportPerWorkInfo(ByVal strFileName As String, ByVal strOrgCd1 As String, ByVal strOrgCd2 As String)
Public Sub ImportPerWorkInfo(ByVal strFileName As String, ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, Optional ByVal blnSkipFirstRow As Boolean = True)
'## 2003.01.29 Mod End

    Dim objFso              As Object       'ファイルシステムオブジェクト
    Dim objHainsLog         As Object       'ログ情報アクセス用
    Dim objOrganization     As Object       '団体情報アクセス用
    Dim objPerWorkInfo      As Object       '個人就労情報アクセス用
    Dim objRegistPerson     As RegistPerson '個人情報登録用
    
    Dim lngTransactionId    As Long         'トランザクションＩＤ
    
    Dim vntNames            As Variant      '項目名の配列
   
    Dim vntOrgSName         As Variant      '団体略称
    
    Dim intFileNo           As Integer      'ファイル番号
    Dim strBuffer           As String       '文字列バッファ
    
    Dim lngLineNo           As Long         '行番号
    
    Dim strEmpNo            As String       '従業員番号
    Dim dtmDataDate         As Date         '発生年月
    Dim lngNightWorkCnt     As Long         '時間外就労期間
    Dim dblOverTime         As Double       '夜業回数

    Dim vntPerId            As Variant      '個人ＩＤ
    Dim vntLastName         As Variant      '姓
    Dim vntFirstName        As Variant      '名

    Dim lngReadCount        As Long         '読み込みレコード数
    Dim lngPerCount         As Long         '作成／更新個人就労情報数
    
    Dim vntMessage1         As Variant      'メッセージ１
    Dim vntMessage2         As Variant      'メッセージ２
    Dim strMessage          As String       'メッセージ１
    Dim Ret                 As Boolean      '関数戻り値
    
'## 2003.04.24 Add 2Lines By T.Takagi@FSIT ログ対応
    Dim vntColumns          As Variant      '各カラムの集合
    Dim i                   As Long         'インデックス
'## 2003.04.24 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFso = CreateObject("Scripting.FileSystemObject")
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    Set objOrganization = CreateObject("HainsOrganization.Organization")
    Set objPerWorkInfo = CreateObject("HainsPerWorkInfo.PerWorkInfo")
    Set objRegistPerson = CreateObject("HainsCooperation.RegistPerson")
    
    'トランザクションＩＤ・区分・表題の取得
    lngTransactionId = objHainsLog.IncreaseTransactionId()
    
    '項目名の配列を作成
    vntNames = Array(NAME_EMPNO, NAME_NIGHTWORKCNT, NAME_OVERTIME, NAME_DATADATE)
    
    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "I", "", "個人就労情報取り込み処理を開始します。", ""
    
    '指定されたパラメータ情報を編集する
    Do
    
        '団体略称の取得
        If objOrganization.SelectOrg(strOrgCd1, strOrgCd2, , , , vntOrgSName) = False Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "E", "", "団体情報が存在しません。", "団体コード=" & strOrgCd1 & "-" & strOrgCd2
            Exit Do
        End If
        
        'ログ発行
        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "I", "", "■次の団体が指定されました。", "団体=" & vntOrgSName & "（" & strOrgCd1 & "-" & strOrgCd2 & "）"
    
        'ファイルが存在しない場合は処理を終了する
        If objFso.FileExists(strFileName) = False Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "E", "", "ファイルが存在しません。", "ファイル名=" & strFileName
            Exit Do
        End If
    
        'ファイルオープン
        intFileNo = FreeFile()
        Open strFileName For Input Lock Read Write As #intFileNo
    
'## 2003.01.29 Add 3Lines By T.Takagi@FSIT 先頭行スキップ機能追加
        If Not EOF(intFileNo) And blnSkipFirstRow = True Then
            Line Input #intFileNo, strBuffer
        End If
'## 2003.01.29 Add End
        
        'ファイル読み込み
        Do Until EOF(intFileNo)
   
            Do
                
                '１行読み込み
                Line Input #intFileNo, strBuffer

                '行番号をインクリメント
                lngLineNo = lngLineNo + 1

                '行データが存在しない場合はスキップ
                If Trim(strBuffer) = "" Then
                    Exit Do
                End If
                
                '読み込みレコード数のインクリメント
                lngReadCount = lngReadCount + 1
                
'## 2003.04.24 Mod 82Lines By T.Takagi@FSIT ログ対応
'                'CSVデータのチェック
'                Ret = CheckCsv(strBuffer, vntNames, strEmpNo, dtmDataDate, lngNightWorkCnt, dblOverTime, vntMessage1, vntMessage2)
'                If Ret = False Then
'                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "E", lngLineNo, vntMessage1, vntMessage2
'                    Exit Do
'                End If
'
'                strMessage = "従業員番号=" & strEmpNo
'
'                '団体・従業員番号をキーに個人情報の有無を検索する
'                Ret = objRegistPerson.SelectPersonFromOrg(strOrgCd1, strOrgCd2, strEmpNo, vntPerId, vntLastName, vntFirstName)
'                If Ret = False Then
'                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "E", lngLineNo, "指定された従業員は存在しません。", strMessage
'                    Exit Do
'                End If
                
                '初期化
                strEmpNo = ""
                dtmDataDate = 0
                lngNightWorkCnt = 0
                dblOverTime = 0
    
                'レコードが存在しない場合はエラー
                If strBuffer = "" Then
                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "E", lngLineNo, "取り込みデータが存在しません。", ""
                    Exit Do
                End If
    
                'レコード値の配列化
                SetColumnsArrayFromCsvString strBuffer, INDEX_DATADATE, vntColumns
    
                'CSVデータの項目値チェック
                CheckColumnValue vntNames, vntColumns, vntMessage1, vntMessage2
                
                '従業員番号の取得
                strEmpNo = vntColumns(INDEX_EMPNO)
                
                strMessage = "従業員番号=" & IIf(strEmpNo <> "", strEmpNo, "なし")
                
                '団体・従業員番号をキーに個人情報の有無を検索する
                If strEmpNo <> "" Then
                    Ret = objRegistPerson.SelectPersonFromOrg(strOrgCd1, strOrgCd2, strEmpNo, vntPerId, vntLastName, vntFirstName)
                    If Ret = True Then
                        strMessage = strMessage & "、氏名=" & Trim(vntLastName & "　" & vntFirstName) & "（" & vntPerId & "）"
                    End If
                End If
                
                '先の項目値チェックでエラーがある場合
                If Not IsEmpty(vntMessage1) Then
                    
                    'エラー情報に従業員情報を結合
                    For i = 0 To UBound(vntMessage1)
                        If InStr(vntMessage2(i), "従業員番号") <= 0 Then
                            vntMessage2(i) = strMessage & "、" & vntMessage2(i)
                        End If
                    Next i
                    
                    'ログ発行
                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "E", lngLineNo, vntMessage1, vntMessage2
                    
                    Exit Do
                End If
        
                '従業員情報が存在しない場合
                If Ret = False Then
                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "E", lngLineNo, "指定された従業員は存在しません。", "従業員番号=" & strEmpNo
                    Exit Do
                End If
                
                '戻り値の設定
                If vntColumns(INDEX_NIGHTWORKCNT) <> "" Then
                    lngNightWorkCnt = vntColumns(INDEX_NIGHTWORKCNT)
                End If
                
                If vntColumns(INDEX_OVERTIME) <> "" Then
                    dblOverTime = vntColumns(INDEX_OVERTIME)
                End If
                
                If InStr(vntColumns(INDEX_DATADATE), "/") > 0 Then
                    dtmDataDate = vntColumns(INDEX_DATADATE) & "/1"
                Else
                    dtmDataDate = Format(vntColumns(INDEX_DATADATE), "@@@@/@@/1")
                End If
'## 2003.04.24 Mod End
                    
                '個人就労情報の登録
                objPerWorkInfo.RegistPerWorkInfo vntPerId, dtmDataDate, lngNightWorkCnt, dblOverTime

                '個人情報の夜勤者健診対象、超過勤務区分を更新
                UpdatePerson vntPerId
                
                'ログ発行
'## 2003.04.24 Add 1Line By T.Takagi@FSIT ログ対応
                strMessage = "従業員番号=" & strEmpNo
'## 2003.04.24 Add End
                strMessage = strMessage & "、氏名=" & Trim(vntLastName & "　" & vntFirstName) & "（" & vntPerId & "）、年月=" & Format(dtmDataDate, "yyyy/m")
                
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "I", lngLineNo, "個人就労情報が登録されました。", strMessage
    
                '作成／更新個人情報数のインクリメント
                lngPerCount = lngPerCount + 1
    
                Exit Do
            Loop
        
        Loop
        
        'ファイルクローズ
        Close #intFileNo
        
        Exit Do
    Loop

    '終了ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_PWKCSV, "I", "", "個人就労情報取り込み処理を終了します。", ""

    Exit Sub
    
ErrorHandle:

    'ファイルクローズ
    Close #intFileNo

    'イベントログ書き込み
    WriteErrorLog "ImportPerWorkInfo.ImportPerWorkInfo"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : 個人テーブルレコードの夜勤者健診対象、超過勤務区分を更新する
'
' 引数　　 : (In)     strPerId  個人ＩＤ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Private Function UpdatePerson(ByVal strPerId As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '個人テーブルレコードの更新
    mobjOraDb.ExecuteSQL "UPDATE PERSON SET NIGHTDUTYFLG=GetNightDutyFlg(PERID), OVERTIMEDIV=GetOverTimeDiv(PERID) WHERE PERID=:PERID"
    
    '戻り値の設定
    UpdatePerson = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdatePerson = False
    
    'イベントログ書き込み
    WriteErrorLog "ImportPerWorkInfo.UpdatePerson"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
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
    Set objCommon = CreateObject("HainsCommon.Common")

    'データベース接続
    Set mobjOraSession = CreateObject("OracleInProcServer.XOraSession")
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

