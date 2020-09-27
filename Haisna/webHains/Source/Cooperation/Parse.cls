VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Parse"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 現在の検索位置から改行までの文字列取得を行う
'
' 引数　　 : (In)     vntStream  検索文字列
' 　　　　   (In/Out) lngPtr     文字列検索ポインタ
' 　　　　   (In/Out) blnEos     最後まで検索したか
'
' 戻り値　 : 取得文字列
'
' 備考　　 :
'
Private Function GetLine(ByRef vntStream As Variant, ByRef lngPtr As Long, ByRef blnEos As Boolean) As String

    Dim lngLength   As Long     '検索文字列長
    Dim strBuffer   As String   '文字列バッファ
    Dim lngNextPtr  As Long     '次の検索開始位置

    '初期設定
    blnEos = False
    lngLength = Len(vntStream)
    
    Do
    
        '検索ポインタが範囲外の場合(検索文字列が存在しない場合も必ずこの条件が成立する)
        If lngPtr < 1 Or lngPtr > lngLength Then
            blnEos = True
            lngPtr = 0
            Exit Do
        End If
    
        '現在の位置から次の改行位置を検索
        lngNextPtr = InStr(lngPtr, vntStream, vbCrLf)
        
        '見つからなかった場合
        If lngNextPtr <= 0 Then
        
            '現在の位置から最後までの文字列を取得
            strBuffer = Right(vntStream, lngLength - lngPtr + 1)
            
            blnEos = True
            lngPtr = 0
            
            Exit Do
        End If

        '現在の位置から次の改行位置までの文字列を取得
        strBuffer = Mid(vntStream, lngPtr, lngNextPtr - lngPtr)
    
        '次の検索開始位置を設定
        lngPtr = lngNextPtr + Len(vbCrLf)
    
        '次の検索開始位置が範囲外の場合にフラグ成立
        blnEos = (lngPtr > lngLength)
        
        Exit Do
    Loop
    
    '戻り値の設定
    GetLine = strBuffer
    
End Function

'
' 機能　　 : RFC1867形式でアップロードされたHTTPデータの解析を行う
'
' 引数　　 : (In)     strContentType  content-type値
' 　　　　   (In)     bytStream       アップロードされたデータ
' 　　　　   (Out)    vntName         エレメント名
' 　　　　   (Out)    vntFileName     アップロードされたデータがファイルであった場合、そのファイル名
' 　　　　   (Out)    vntContentType  アップロードされたデータがファイルであった場合、そのcontent-type
' 　　　　   (Out)    vntContent      エレメント値
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub ParseMulti( _
    ByVal strContentType As String, _
    ByRef bytStream As Variant, _
    ByRef vntName As Variant, _
    ByRef vntFileName As Variant, _
    ByRef vntContentType As Variant, _
    ByRef vntContent As Variant _
)

    Const STRING_BOUNDARY       As String = "boundary="             'boundary接頭辞
    Const STRING_DISPOSITION    As String = "content-disposition: " 'content-disposition接頭辞
    Const STRING_FORM_DATA      As String = "form-data"             'form-data接頭辞
    Const STRING_NAME           As String = "name="""               'name接頭辞
    Const STRING_FILENAME       As String = "filename="""           'filename接頭辞
    Const STRING_CONTENT_TYPE   As String = "content-type"          'content-type接頭辞
    
    Dim strBoundary             As String   'boundary文字列
    Dim strStream               As String   'Unicode変換後のアップロードデータ
    
    Dim strBuffer               As String   '文字列バッファ
    Dim lngPtr                  As Long     '文字列検索ポインタ
    Dim blnEos                  As Boolean  '文字列を最後まで検索したか
    
    Dim strDisposition          As String   'disposition文字列
    Dim strName                 As String   'name値
    Dim strFileName             As String   'filename値
    Dim strSubContentType       As String   'content-type値
    
    Dim lngStrPtr               As Long     '文字列部分検索時の開始位置
    Dim lngEndPtr               As Long     '文字列部分検索時の終了位置
    
    Dim strContent              As String   'エレメント値
    Dim lngNextPtr              As Long     '次の検索開始位置
    
    Dim vntArrName()            As Variant  'エレメント名
    Dim vntArrFileName()        As Variant  'アップロードされたデータがファイルであった場合、そのファイル名
    Dim vntArrContentType()     As Variant  'アップロードされたデータがファイルであった場合、そのcontent-type
    Dim vntArrContent()         As Variant  'エレメント値
    Dim lngCount                As Long     'エレメント数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntName = Empty
    vntFileName = Empty
    vntContentType = Empty
    vntContent = Empty

    '"boundary"の検索
    lngPtr = InStr(strContentType, STRING_BOUNDARY)
    If lngPtr <= 0 Then
        Err.Raise 1000, , "content-typeの指定に誤りがあります。"
    End If
    
    'boundary文字列の編集
    strBoundary = "--" & Right(strContentType, Len(strContentType) - (lngPtr + Len(STRING_BOUNDARY) - 1))

    'Unicode変換
    strStream = StrConv(bytStream, vbUnicode)
    
    lngPtr = 1
    
    Do
    
        '１行読み込み(以下致命的エラー発生時はデータがRFC1867仕様を満たしていない)
        strBuffer = GetLine(strStream, lngPtr, blnEos)
        If strBuffer = "" Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 0)"
        End If
        
        '読み込みデータの接頭辞をチェック
        If InStr(strBuffer, strBoundary) <> 1 Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 1)"
        End If
        
        '文字列を最後まで検索した場合は終了
        If blnEos Then
            Exit Do
        End If
        
        '１行読み込み
        strBuffer = GetLine(strStream, lngPtr, blnEos)
    
        '小文字変換
        strBuffer = LCase(strBuffer)
        
        '文字列が"content-disposition:"で始まる場合
        lngStrPtr = InStr(strBuffer, STRING_DISPOSITION)
        If lngStrPtr <= 0 Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 2)"
        End If
        
        'セミコロンの位置を検索
        lngEndPtr = InStr(strBuffer, ";")
        If lngEndPtr <= 0 Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 3)"
        End If
        
        '"content-disposition:"からセミコロンまでのdisposition文字列を取得
        strDisposition = Mid(strBuffer, lngStrPtr + Len(STRING_DISPOSITION), lngEndPtr - (lngStrPtr + Len(STRING_DISPOSITION)))
        If strDisposition <> STRING_FORM_DATA Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 4)"
        End If

        'name値開始位置の検索
        lngStrPtr = InStr(strBuffer, STRING_NAME)
        If lngStrPtr <= 0 Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 5)"
        End If
        
        'name値終了位置の検索
        lngEndPtr = InStr(lngStrPtr + Len(STRING_NAME), strBuffer, """")
        If lngEndPtr <= 0 Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 6)"
        End If

        'name値の取得
        strName = Mid(strBuffer, lngStrPtr + Len(STRING_NAME), lngEndPtr - (lngStrPtr + Len(STRING_NAME)))

        'filename値開始・終了位置の検索
        lngStrPtr = InStr(strBuffer, STRING_FILENAME)
        If lngStrPtr > 0 Then
            lngEndPtr = InStr(lngStrPtr + Len(STRING_FILENAME), strBuffer, """")
        Else
            lngEndPtr = 0
        End If

        'filename値の取得
        If lngStrPtr > 0 And lngEndPtr > 0 Then
            strFileName = Mid(strBuffer, lngStrPtr + Len(STRING_FILENAME), lngEndPtr - (lngStrPtr + Len(STRING_FILENAME)))
        Else
            strFileName = ""
        End If

        '１行読み込み
        strBuffer = GetLine(strStream, lngPtr, blnEos)

        '小文字変換
        strBuffer = LCase(strBuffer)
            
        strSubContentType = ""
        
        '文字列が"content-type"で始まる場合
        lngStrPtr = InStr(strBuffer, STRING_CONTENT_TYPE)
        If lngStrPtr = 1 Then
        
            'content-type値の取得
            lngStrPtr = InStr(strBuffer, " ")
            If lngStrPtr <= 0 Then
                Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 7)"
            End If
            strSubContentType = Right(strBuffer, Len(strBuffer) - lngStrPtr)

            '１行読み込み
            strBuffer = GetLine(strStream, lngPtr, blnEos)

        End If
            
        '空行チェック
        If strBuffer <> "" Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 8)"
        End If

        'boundary文字列の直前までをcontentとして取得
        lngNextPtr = InStr(lngPtr, strStream, strBoundary, vbBinaryCompare)
        If lngNextPtr <= 0 Then
            Err.Raise 1000, , "アップロードされたデータがRFC1867仕様を満たしていません。(error 9)"
        End If
        strContent = Mid(strStream, lngPtr, lngNextPtr - lngPtr)

        '最後部の改行カット
        strContent = Left(strContent, Len(strContent) - Len(vbCrLf))

        'これまでに取得した値を配列に編集
        ReDim Preserve vntArrName(lngCount)
        ReDim Preserve vntArrFileName(lngCount)
        ReDim Preserve vntArrContentType(lngCount)
        ReDim Preserve vntArrContent(lngCount)
        vntArrName(lngCount) = strName
        vntArrFileName(lngCount) = strFileName
        vntArrContentType(lngCount) = strSubContentType
        vntArrContent(lngCount) = RTrim(strContent)
        lngCount = lngCount + 1
        
        '次の検索位置へ
        lngPtr = lngNextPtr
        
    Loop
   
    '戻り値の設定
    If lngCount > 0 Then
        vntName = vntArrName
        vntFileName = vntArrFileName
        vntContentType = vntArrContentType
        vntContent = vntArrContent
    End If
    
    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Import.ParseMulti"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

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

