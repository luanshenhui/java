VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "PrivacyInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl
Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

Private Const SEPARATESTRING = ","
Private Const WRAPCHAR = """"
Private Const LOGFIELDNAME = "分割区分,操作日付,端末ＩＤ,機能コード,利用者ＩＤ,患者ＩＤ,依頼医利用者ＩＤ,職種コード,科コード,病棟コード,担当区分,ログデータ（固定部）,ログデータ（可変部）"

'機能 ： 現在時間（ミリ秒含む）の取得
Private Type Type_SysTime
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type

Private Declare Sub GetLocalTime Lib "kernel32" (lpSystemTime As Type_SysTime)

'
' 機能　　 : 情報漏えい対策ログ出力
'
' 引数　　 : (In)   userid          ログインID
' 　　　　   (In)   functionCode    機能コード（各ASP個別指定。聖路加指定のため追加）
' 　　　　   (In)   logMessage      ログメッセージ（各ASP個別指定。聖路加指定のため追加）
' 　　　　   (In)   aspRequest      ASPリクエストObject
'
' 戻り値　 : -1     異常終了
' 　　　　   1      正常終了
'
' 備考　　 : 引数の値をログファイルに出力します。
'
Public Function putPrivacyInfoLog(ByVal userID As String, _
                                  ByVal functionCode As String, _
                                  ByVal logMessage As String, _
                                  ByVal aspRequest As Request) As Integer
    
    Dim eventLogMessage     As String
    eventLogMessage = ""
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret                 As Integer
    Ret = -1
    
    'UserIDの存在チェック実施
    If checkHainsUser(userID) = False Then
        eventLogMessage = "指定されたユーザIDがサーバに存在しません。引数を確認してください。functionCode=" & functionCode & ":userID=" & userID & ") HainsPrivacyInfo.putPrivacyInfoLog"
        Err.Raise 10000, "HainsPrivacyInfo.putPrivacyInfoLog", eventLogMessage
    End If
    
    Dim wkQueryString       As String
    Dim wkIPAddress         As String
    Dim wkAspName           As String
    
    'ASPのRequestオブジェクトから今回指示された内容を抽出する
    '（ログファイルの排他を極限までなくしたいので文字列編集を最初に処理）
    wkIPAddress = aspRequest.ServerVariables("REMOTE_ADDR")    'IPアドレス
    wkAspName = aspRequest.ServerVariables("PATH_INFO")        'ASPファイルパス
    wkQueryString = editQueryString(aspRequest)             'クエリーストリング
    
    '深夜日時代わりで出力先パスが変わるとよくないのでここで取得しておく
    Dim executeDate As Date
    executeDate = Now
    
    '出力先ログファイルフルパスの取得
    Dim logFileName As String
    logFileName = getLogFileName(executeDate)
    
    ' FileSystemObject (FSO) の新しいインスタンスを生成する
    Dim objFso As FileSystemObject
    Set objFso = New FileSystemObject
    
    'ログファイル存在チェック
    If Not objFso.FileExists(logFileName) Then
        '存在しないなら作成（フルパス取得時に存在チェックをしないのは、ログ出力のオーバヘッドを最小限にしたいため）
        Call createLogFile(objFso, executeDate, logFileName)
    End If
    
    'ログファイルに出力する（Requestオブジェクトから引数加工）
    Dim FsoTS As TextStream
    Set FsoTS = objFso.OpenTextFile(logFileName, ForAppending, True)
    
    'ログ明細行編集
    Dim logText As String
    logText = ""
    logText = logText & WRAPCHAR & "" & WRAPCHAR & SEPARATESTRING                 '分割区分
    logText = logText & WRAPCHAR & getNowTime() & WRAPCHAR & SEPARATESTRING       '操作日付
    logText = logText & WRAPCHAR & wkIPAddress & WRAPCHAR & SEPARATESTRING        '端末ID
    logText = logText & WRAPCHAR & functionCode & WRAPCHAR & SEPARATESTRING       '機能コード
    logText = logText & WRAPCHAR & userID & WRAPCHAR & SEPARATESTRING             '利用者ID
    logText = logText & WRAPCHAR & getPerIDFromQueryString(wkQueryString) & WRAPCHAR & SEPARATESTRING   '患者ID
    logText = logText & WRAPCHAR & "" & WRAPCHAR & SEPARATESTRING                 '依頼利用者ID
    logText = logText & WRAPCHAR & "" & WRAPCHAR & SEPARATESTRING                 '職種コード
    logText = logText & WRAPCHAR & "" & WRAPCHAR & SEPARATESTRING                 '科コード
    logText = logText & WRAPCHAR & "" & WRAPCHAR & SEPARATESTRING                 '病棟コード
    logText = logText & WRAPCHAR & "" & WRAPCHAR & SEPARATESTRING                 '担当区分
    logText = logText & WRAPCHAR & logMessage & WRAPCHAR & SEPARATESTRING         'ログデータ(固定部)
    logText = logText & WRAPCHAR & wkQueryString & WRAPCHAR                       'ログデータ（可変部）
    
    FsoTS.WriteLine logText
    FsoTS.Close
    
    '参照解放
    Set FsoTS = Nothing
    Set objFso = Nothing
    
    Ret = 1
    
    putPrivacyInfoLog = Ret

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PrivacyInfo.putPrivacyInfoLog"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '処理中でイベントログメッセージが設定されていないなら、ここで汎用メッセージを設定
    If eventLogMessage = "" Then
        eventLogMessage = "情報漏えい対策ログ書き込み処理に失敗しました (PrivacyInfo.putPrivacyInfoLog)" & vbLf & "WWWサーバのイベントログを参照してください。"
    End If
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, eventLogMessage

End Function

'
' 機能　　 : 処理時間編集(msec対応）
'
' 引数　　 :
'
' 戻り値　 : 処理時間
'
' 備考　　 :
'
Public Function getNowTime()
    
    Dim sysTime As Type_SysTime

    GetLocalTime sysTime
    
    getNowTime = Format$(sysTime.wYear, "0000") & "/" & _
                 Format$(sysTime.wMonth, "00") & "/" & _
                 Format$(sysTime.wDay, "00") & " " & _
                 Format$(sysTime.wHour, "00") & ":" & _
                 Format$(sysTime.wMinute, "00") & ":" & _
                 Format$(sysTime.wSecond, "00") & _
                 Format$(sysTime.wMilliseconds, "000")

End Function

'
' 機能　　 : HainsUser妥当性チェック
'
' 引数　　 : (In)   userID ユーザID
'
' 戻り値　 : true:存在、false:なし
'
' 備考　　 :
'
Private Function checkHainsUser(userID As String) As String

    'オブジェクトのインスタンス作成
    Dim objHainsUser        As Object
    Set objHainsUser = CreateObject("HainsHainsUser.HainsUser")

    '引数のuserIDを渡し存在チェックを返す
    checkHainsUser = objHainsUser.SelectHainsUser(userID, "")

    Set objHainsUser = Nothing

End Function

'
' 機能　　 : 個人ID抽出
'
' 引数　　 : (In)   queryString クエリー文字列
'
' 戻り値　 : 個人ID
'
' 備考　　 :
'
Private Function getPerIDFromQueryString(queryString As String) As String

    Dim stArrayData() As String
    Dim strPerId As String
    Dim i As Integer
    Dim stUpper As String
    
    strPerId = ""
    
    '&で分割して配列に格納する
    stArrayData = Split(queryString, "&")
    
    '配列をLoopしPerID指定されている変数を探す。
    For i = 0 To UBound(stArrayData())
        
        '変数をすべて大文字に
        stUpper = UCase$(stArrayData(i))
            
        '先頭がPERID=のものを検索。結果から値のみ抽出
        If InStr(1, stUpper, "PERID=") > 0 Then
            strPerId = Mid(stUpper, 7, Len(stUpper) - 6)
            Exit For
        End If
    
    Next i

    '取得したPerIDを返す
    getPerIDFromQueryString = strPerId


End Function


'
' 機能　　 : クエリーストリング文字列編集
'
' 引数　　 : (In)   aspRequest ASPリクエストオブジェクト
'
' 戻り値　 : 編集済みリクエスト文字列
'
' 備考　　 :
'
Private Function editQueryString(aspRequest As Request) As String

    Dim wkString As String
    wkString = ""
    
    '現状POSTGETが混在状態のため、どちらもログ出力する形とする。
    
    If aspRequest.ServerVariables("REQUEST_METHOD") = "POST" Then
        wkString = wkString & "POST:"
    Else
        wkString = wkString & "GET:"
    End If
    
    'POST系データ取得
    Dim formObjName As Variant
    For Each formObjName In aspRequest.Form()
        wkString = wkString & formObjName                         '名称
        wkString = wkString & "=" & aspRequest.Form(formObjName)  '値
        wkString = wkString & "&"
    Next
    
    'GET系データ取得
    Dim variableName As Variant
    For Each variableName In aspRequest.queryString()
        wkString = wkString & editQueryString & variableName               '名称
        wkString = wkString & "=" & aspRequest.queryString(variableName)   '値
        wkString = wkString & "&"
    Next
    
    editQueryString = wkString

End Function

'
' 機能　　 : ログファイル名取得
'
' 引数　　 : (In)   executeDate 実行日時
'
' 戻り値　 : ログファイル名
'
' 備考　　 : iniファイルのログ出力先、年度、実行日時からフルパスを返します
'
Private Function getLogFileName(executeDate As Date) As String

    Dim rootFolder As String
    Dim logFileName As String
    
    'iniファイルよりLog出力のルートディレクトリ情報を取得する
    Dim objCommon           As Common       '共通クラス
    Set objCommon = CreateObject("HainsCommon.Common")
    rootFolder = objCommon.ReadIniFile("PRIVACYINFO", "LOGPATH")
    Set objCommon = Nothing
    
    '実行年を取得しフォルダ名とする
    logFileName = rootFolder & "\" & Format$(executeDate, "yyyy")
    
    '実行日を取得しログファイル名とする
    logFileName = logFileName & "\" & Format$(executeDate, "yyyymmdd") & ".log"

    getLogFileName = logFileName

End Function

'
' 機能　　 :  ログファイル作成
'
' 引数　　 : (In)   objFso      FileSystemObject
' 　　　　   (In)   executeDate 実行日時
' 　　　　   (In)   logFileName ログファイル名フルパス
'
' 備考　　 : 指定されたログファイルを新規作成します（パスも作成）
'
Private Sub createLogFile(ByRef objFso As FileSystemObject, ByVal executeDate As Date, ByVal logFileName As String)

    'iniファイルよりLog出力のルートディレクトリ情報を取得する
    Dim rootFolder As String
    Dim objCommon           As Common       '共通クラス
    Set objCommon = CreateObject("HainsCommon.Common")
    rootFolder = objCommon.ReadIniFile("PRIVACYINFO", "LOGPATH")
    Set objCommon = Nothing

    'ルート・ディレクトリの存在チェックをしてなければ作成
    If Not objFso.FolderExists(rootFolder) Then
        Call objFso.CreateFolder(rootFolder)
    End If

    Dim yearDirectory As String
    yearDirectory = rootFolder & "\" & Format$(executeDate, "yyyy")
    
    '年度ディレクトリの存在チェックをしてなければ作成
    If Not objFso.FolderExists(yearDirectory) Then
        Call objFso.CreateFolder(yearDirectory)
    End If

    'ログファイル先頭に書き出し開始メッセージ出力
    Dim FsoTS As TextStream
    Set FsoTS = objFso.CreateTextFile(logFileName, False)
'    FsoTS.Write "#webHains Privacy Information Access Log Start" & vbCrLf
'    FsoTS.Write "#Date: " & Now & vbCrLf
    FsoTS.Write LOGFIELDNAME & vbCrLf
    FsoTS.Close

End Sub

Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス
    
    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
End Sub

Private Sub ObjectControl_Deactivate()

    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing
    
End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

