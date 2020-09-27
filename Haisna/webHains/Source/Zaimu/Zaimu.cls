VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Zaimu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const EXECUTEBATFILENAME    As String = "copyzaimu.bat"
Private Const NT_ZAIMUUSER          As String = "rinkai"        '財務連携用ユーザ名
Private Const NT_ZAIMUUSERPASS      As String = "rinkai"        '財務連携用パスワード

'
' 機能　　 : 財務連携CSVデータのコピー（財務サーバへのコピー）
'
' 引数　　 : (In)    dtmInsDate    収納対象日
'
' 戻り値　 : 1:正常終了、<= 0:異常終了
'
' 備考　　 :
'
Public Function CopyZaimuCsv(ByRef dtmInsDate As Date) As Long
                                
'エラーハンドラの設定
On Error GoTo ErrorHandle
                                
    Dim objFree                 As Object       '汎用テーブルアクセス用オブジェクト
    Dim objFileSystem           As Object       'ファイルシステムオブジェクト
    Dim objTextStream           As Object       '
    
    Dim strZaimuLocPath         As String       '財務側の格納パス（リモートサーバ）
    Dim strZaimuCpPath          As String       '健診側の財務データ格納パス
    Dim strZaimuSndPath         As String       '財務システム送信用ファイル格納フォルダ
    Dim strTempBatFile          As String       'コピー用バッチファイル名
    Dim strBatString            As String       'コピー用バッチファイルの文字列
    Dim vntRet                  As String       'Shell用Variant戻り値
    Dim strFileName             As String
                                
    Dim vntFreeCd               As Variant
    Dim vntFreeField1           As Variant
    Dim lngFreeCount            As Long
    Dim i                       As Integer
    
    CopyZaimuCsv = 0
    
    strZaimuLocPath = ""
    strZaimuCpPath = ""
    
    '財務連携用の固定コードアクセス
    Set objFree = mobjContext.CreateInstance("HainsFree.Free")
    lngFreeCount = objFree.SelectFree(1, "ZAIMU", vntFreeCd, , , vntFreeField1)
        
    If lngFreeCount < 3 Then
        CopyZaimuCsv = -9         '汎用テーブルに財務用設定がされていない
        App.LogEvent vbCrLf & _
                     "webHains Application Error: " & vbCrLf & _
                     "財務連携用CSVの格納先パス名が設定されていません。汎用テーブルの KEY=ZAIMULOCPATH, ZAIMUSYSCDの存在を確認してください。", vbLogEventTypeError
        Set objFree = Nothing
        Exit Function
    End If
    
    For i = 0 To lngFreeCount - 1
        
        Select Case vntFreeCd(i)
            
            Case "ZAIMUCPPATH"      '財務システム共有フォルダ
                strZaimuCpPath = vntFreeField1(i)
            
            Case "ZAIMUSNDPATH"     '財務システム送信用ファイル格納フォルダ
                strZaimuSndPath = vntFreeField1(i)
                strFileName = strZaimuSndPath & "\" & "健診." & Format(dtmInsDate, "YYYY") & Format(dtmInsDate, "MM") & Format(dtmInsDate, "DD") & ".csv"
            
'            Case "ZAIMULOCPATH"     '健診システム側ネイティブファイルフォルダ
 '               strZaimuLocPath = vntFreeField1(i)
  '              strFileName = strZaimuLocPath & "\" & "健診." & Format(dtmInsDate, "YYYY") & Format(dtmInsDate, "MM") & Format(dtmInsDate, "DD") & ".csv"
            
        End Select
            
    Next i
    Set objFree = Nothing
    
    '財務連携用ファイルの作成
    If SelectZaimuCsv(Format(dtmInsDate, "YYYY") & Format(dtmInsDate, "MM") & Format(dtmInsDate, "DD"), strZaimuSndPath) <= 0 Then
        CopyZaimuCsv = -2
        Exit Function
    End If
    
    'コピー元ファイルの存在確認
    If Dir(strFileName) = "" Then
        CopyZaimuCsv = -1
        Exit Function
    End If
    
    'ファイルオブジェクト作成
    Set objFileSystem = CreateObject("Scripting.FileSystemObject")
    
    strTempBatFile = App.Path & "\" & EXECUTEBATFILENAME

    'Copy用バッチファイル作成
    On Error Resume Next
    Kill strTempBatFile        'コピー用一時バッチファイルを削除する
    On Error GoTo 0
    Set objTextStream = objFileSystem.CreateTextFile(strTempBatFile)
    
    '文字列組み立て
    strBatString = ""
    strBatString = strBatString & "NET USE Z: """ & strZaimuCpPath & """ " & NT_ZAIMUUSERPASS & " /USER:" & NT_ZAIMUUSER & vbCrLf
    strBatString = strBatString & "COPY " & strFileName & " Z: /Y" & vbCrLf
    strBatString = strBatString & "NET USE Z: /DELETE" & vbCrLf
    objTextStream.WriteLine (strBatString)
    objTextStream.Close
    
    'ファイルコピー
    vntRet = Shell(strTempBatFile, vbHide)
    
    CopyZaimuCsv = 1
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Zaimu.CopyZaimuCsv"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 財務適用データの一覧を取得する
'
' 引数　　 : (Out)    vntZaimuCd            財務コード
' 　　　　 : (Out)    vntZaimuName          財務適用名
' 　　　　 : (Out)    vntZaimuDiv           財務種別（省略可）
' 　　　　 : (Out)    vntZaimuClass         財務分類（省略可）
' 　　　　 : (In)     vntParaZaimuDiv       財務種別（省略可）
' 　　　　 : (Out)    vntDisAbled           未使用フラグ（省略可）
' 　　　　 : (In)     vntGetCancel          Empty以外:未使用データも取得する
' 　　　　 : (In)     vntParaZaimuClass     財務分類（省略可）
' 　　　　 : (In)     vntRsvNo              予約番号（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 : すいません、後からパラメタ追加したのでIn/Outがなんか変です。
'
Public Function SelectZaimuList(ByRef vntZaimucd As Variant, _
                                ByRef vntZaimuname As Variant, _
                                Optional ByRef vntZaimudiv As Variant, _
                                Optional ByRef vntZaimuClass As Variant, _
                                Optional ByVal vntParaZaimuDiv As Variant, _
                                Optional ByRef vntDisabled As Variant, _
                                Optional ByVal vntGetCancel As Variant, _
                                Optional ByRef vntParaZaimuClass As Variant, _
                                Optional ByRef vntRsvNo As Variant _
                                ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objZaimucd          As OraField         '財務コード
    Dim objZaimuname        As OraField         '財務適用名
    Dim objZaimuDiv         As OraField         '財務種別
    Dim objZaimuClass       As OraField         '財務分類
    Dim objDisabled         As OraField         '未使用フラグ
    
    Dim vntArrZaimucd()     As Variant          '財務コードの配列
    Dim vntArrZaimuname()   As Variant          '財務適用名の配列
    Dim vntArrZaimudiv()    As Variant          '財務種別の配列
    Dim vntArrZaimuClass()  As Variant          '財務分類の配列
    Dim vntArrDisabled()    As Variant          '未使用フラグの配列
    Dim lngCount            As Long             'レコード数
    Dim blnWhereFlg         As Boolean          'TRUE:条件分にWHERE追加済み
    Dim blnGetFromRsvFlg    As Boolean          'TRUE:予約番号からの取得
    Dim blnTargetData       As Boolean          'TRUE:ターゲットデータ（予約番号からの取得モードの場合機能する）
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntZaimucd = Empty
    vntZaimuname = Empty
    SelectZaimuList = 0
    lngCount = 0
    blnWhereFlg = False
    
    Set objOraParam = mobjOraDb.Parameters
    
    '財務テーブルよりレコードを取得
    strStmt = "SELECT ZAIMUCD, ZAIMUNAME, ZAIMUDIV, ZAIMUCLASS, DISABLED " & vbLf & _
              "  FROM ZAIMU" & vbLf
              
    '指定がなければ、使用可能なデータのみ取得
    If IsMissing(vntGetCancel) = True Then
        strStmt = strStmt & _
                  " WHERE DISABLED = 0"
        blnWhereFlg = True
    End If

    '財務種別が設定されている場合、条件を指定する
    If IsMissing(vntParaZaimuDiv) = False Then
        If IsNumeric(vntParaZaimuDiv) = True Then
            objOraParam.Add "ZAIMUDIV", CInt(vntParaZaimuDiv), ORAPARM_INPUT
            If blnWhereFlg = True Then
                strStmt = strStmt & _
                          " AND ZAIMUDIV = :ZAIMUDIV"
            Else
                strStmt = strStmt & _
                          " WHERE ZAIMUDIV = :ZAIMUDIV"
            End If
        End If
    End If
              
    '財務分類が設定されている場合、条件を指定する
    If IsMissing(vntParaZaimuClass) = False Then
        If IsNumeric(vntParaZaimuClass) = True Then
            objOraParam.Add "ZAIMUCLASS", CInt(vntParaZaimuClass), ORAPARM_INPUT
            If blnWhereFlg = True Then
                
                '財務分類が電話料金か雑収入なら未分類も含める（財務仕様上がちがちで仕方なし）
                If (vntParaZaimuClass = 3) Or (vntParaZaimuClass = 5) Then
                    strStmt = strStmt & _
                              " AND ( ZAIMUCLASS = :ZAIMUCLASS OR ZAIMUCLASS = 0 ) "
                Else
                    strStmt = strStmt & _
                              " AND ZAIMUCLASS = :ZAIMUCLASS"
                End If
            
            Else
                
                '財務分類が電話料金か雑収入なら未分類も含める（財務仕様上がちがちで仕方なし）
                If (vntParaZaimuClass = 3) Or (vntParaZaimuClass = 5) Then
                    strStmt = strStmt & _
                              " WHERE ( ZAIMUCLASS = :ZAIMUCLASS OR ZAIMUCLASS = 0 )"
                Else
                    strStmt = strStmt & _
                              " WHERE ZAIMUCLASS = :ZAIMUCLASS"
                End If
            
            End If
        End If
    End If
              
    strStmt = strStmt & _
      " ORDER BY ZAIMUCLASS, ZAIMUDIV"
    
    blnGetFromRsvFlg = False
    '予約番号と財務分類が指定されている
    If (IsMissing(vntRsvNo) = False) And (IsMissing(vntParaZaimuClass) = False) Then
        
        blnGetFromRsvFlg = True
        
        '予約番号は数値、かつ財務分類は健診料金指定なら、コースマスタの適用コードからひっぱる
        If (IsNumeric(vntRsvNo) = True) And ((vntParaZaimuClass = "1") Or (vntParaZaimuClass = "2")) Then
        
            objOraParam.Add "RSVNO", CLng(vntRsvNo), ORAPARM_INPUT
            strStmt = "( " & vbLf & _
                      "SELECT ZAIMU.ZAIMUCD, ZAIMU.ZAIMUNAME, ZAIMU.ZAIMUDIV, ZAIMU.ZAIMUCLASS, ZAIMU.DISABLED" & vbLf & _
                      "  FROM ZAIMU, ( SELECT ZAI_PER_NYU ZAIMUCD" & vbLf & _
                      "                  FROM COURSE_P, CONSULT" & vbLf & _
                      "                 WHERE CONSULT.RSVNO = :RSVNO" & vbLf & _
                      "                   AND COURSE_P.CSCD = CONSULT.CSCD" & vbLf & _
                      "              ) BASICZAIMU" & vbLf & _
                      " WHERE ZAIMU.ZAIMUCD = BASICZAIMU.ZAIMUCD" & vbLf & _
                      ") UNION (" & vbLf & _
                      "SELECT ZAIMU.ZAIMUCD, ZAIMU.ZAIMUNAME, ZAIMU.ZAIMUDIV, ZAIMU.ZAIMUCLASS, ZAIMU.DISABLED" & vbLf & _
                      "  FROM ZAIMU, ( SELECT ZAI_PER_MISYU ZAIMUCD" & vbLf & _
                      "                  FROM COURSE_P, CONSULT" & vbLf & _
                      "                 WHERE CONSULT.RSVNO = :RSVNO" & vbLf & _
                      "                   AND COURSE_P.CSCD = CONSULT.CSCD" & vbLf & _
                      "              ) BASICZAIMU" & vbLf & _
                      " WHERE ZAIMU.ZAIMUCD = BASICZAIMU.ZAIMUCD" & vbLf & _
                      ") UNION (" & vbLf & _
                      "SELECT ZAIMU.ZAIMUCD, ZAIMU.ZAIMUNAME, ZAIMU.ZAIMUDIV, ZAIMU.ZAIMUCLASS, ZAIMU.DISABLED" & vbLf & _
                      "  FROM ZAIMU, ( SELECT ZAI_PER_KAKOMI ZAIMUCD" & vbLf & _
                      "                  FROM COURSE_P, CONSULT" & vbLf & _
                      "                 WHERE CONSULT.RSVNO = :RSVNO" & vbLf & _
                      "                   AND COURSE_P.CSCD = CONSULT.CSCD" & vbLf & _
                      "              ) BASICZAIMU" & vbLf & _
                      " WHERE ZAIMU.ZAIMUCD = BASICZAIMU.ZAIMUCD)"
        
        End If
    
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objZaimucd = objFields("ZAIMUCD")
        Set objZaimuname = objFields("ZAIMUNAME")
        Set objZaimuDiv = objFields("ZAIMUDIV")
        Set objZaimuClass = objFields("ZAIMUCLASS")
        Set objDisabled = objFields("DISABLED")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            blnTargetData = True
            
            '予約番号からの抽出モードの場合、対象外データは抜かない
            If blnGetFromRsvFlg = True Then
            
                '財務種別が設定されている場合、条件を指定する
                If IsMissing(vntParaZaimuDiv) = False Then
                    If IsNumeric(vntParaZaimuDiv) = True Then
                        If vntParaZaimuDiv <> objZaimuDiv.Value Then
                            blnTargetData = False
                        End If
                    End If
                End If
                          
                '財務分類が設定されている場合、条件を指定する
                If IsMissing(vntParaZaimuClass) = False Then
                    If IsNumeric(vntParaZaimuClass) = True Then
                        If vntParaZaimuClass <> objZaimuClass.Value Then
                            blnTargetData = False
                        End If
                    End If
                End If
            End If
            
            If blnTargetData = True Then
                
                ReDim Preserve vntArrZaimucd(lngCount)
                ReDim Preserve vntArrZaimuname(lngCount)
                ReDim Preserve vntArrZaimudiv(lngCount)
                ReDim Preserve vntArrZaimuClass(lngCount)
                ReDim Preserve vntArrDisabled(lngCount)
                vntArrZaimucd(lngCount) = objZaimucd.Value & ""
                vntArrZaimuname(lngCount) = objZaimuname.Value & ""
                vntArrZaimudiv(lngCount) = objZaimuDiv.Value & ""
                vntArrZaimuClass(lngCount) = objZaimuClass.Value & ""
                vntArrDisabled(lngCount) = objDisabled.Value & ""
                lngCount = lngCount + 1
            
            End If
            
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntZaimucd = vntArrZaimucd
    vntZaimuname = vntArrZaimuname
    If IsMissing(vntZaimudiv) = False Then vntZaimudiv = vntArrZaimudiv
    If IsMissing(vntZaimuClass) = False Then vntZaimuClass = vntArrZaimuClass
    If IsMissing(vntDisabled) = False Then vntDisabled = vntArrDisabled
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    SelectZaimuList = lngCount
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Zaimu.SelectZaimuList"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 財務適用データを取得する
'
' 引数　　 : (In)     strZaimuCd        財務コード
' 　　　　   (Out)    vntZaimuName      財務適用名
' 　　　　   (Out)    vntZaimuDiv       財務種別
' 　　　　   (Out)    vntZaimuClass     財務分類
' 　　　　   (Out)    vntDisabled       未使用フラグ
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectZaimu(ByVal strZaimuCd As String, _
                            Optional ByRef vntZaimuname As Variant, _
                            Optional ByRef vntZaimudiv As Variant, _
                            Optional ByRef vntZaimuClass As Variant, _
                            Optional ByRef vntDisabled As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objZaimuname    As OraField         '財務適用名
    Dim objZaimuDiv     As OraField         '財務種別
    Dim objZaimuClass   As OraField         '財務分類
    Dim objDisabled     As OraField         '未使用フラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ZAIMUCD", Trim(strZaimuCd), ORAPARM_INPUT
    
    '検索条件を満たす財務テーブルのレコードを取得
    strStmt = "SELECT ZAIMUNAME, ZAIMUDIV, ZAIMUCLASS, DISABLED FROM ZAIMU WHERE ZAIMUCD = :ZAIMUCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objZaimuname = objFields("ZAIMUNAME")
        Set objZaimuDiv = objFields("ZAIMUDIV")
        Set objZaimuClass = objFields("ZAIMUCLASS")
        Set objDisabled = objFields("DISABLED")
    
        '戻り値の設定
        vntZaimuname = objZaimuname.Value & ""
        vntZaimudiv = objZaimuDiv.Value & ""
        vntZaimuClass = objZaimuClass.Value & ""
        If IsMissing(vntDisabled) = False Then vntDisabled = objDisabled.Value & ""
        
        SelectZaimu = True
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Zaimu.SelectZaimu"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 財務連携データを取得する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     vntZaimuseq       財務ＳＥＱ
' 　　　　   (Out)    vntZaimuseq       財務ＳＥＱ
' 　　　　   (Out)    vntCrtdate        作成日
' 　　　　   (Out)    vntInsdiv         収納区分
' 　　　　   (Out)    vntZaimucd        財務コード
' 　　　　   (Out)    vntZaimuname      財務適用名
' 　　　　   (Out)    vntZaimudiv       財務種別
' 　　　　   (Out)    vntOrgcd1         団体コード１
' 　　　　   (Out)    vntOrgcd2         団体コード２
' 　　　　   (Out)    vntOrgname        団体名
' 　　　　   (Out)    vntPrice          金額
' 　　　　   (Out)    vntTaxprice       税額
' 　　　　   (Out)    vntTax            税金
' 　　　　   (Out)    vntSenddate       財務送信日時
' 　　　　   (Out)    vntZaimuClass     財務分類
' 　　　　   (In)     vntNoPriceEdit    TRUE:金額の"1,234"編集を行わない
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectConsult_Zaimu(ByVal lngRsvNo As Long, _
                                    Optional ByVal strZaimuseq As String, _
                                    Optional ByRef vntZaimuseq As Variant, _
                                    Optional ByRef vntCrtdate As Variant, _
                                    Optional ByRef vntInsdiv As Variant, _
                                    Optional ByRef vntZaimucd As Variant, _
                                    Optional ByRef vntZaimuname As Variant, _
                                    Optional ByRef vntZaimudiv As Variant, _
                                    Optional ByRef vntOrgcd1 As Variant, _
                                    Optional ByRef vntOrgcd2 As Variant, _
                                    Optional ByRef vntOrgname As Variant, _
                                    Optional ByRef vntPrice As Variant, _
                                    Optional ByRef vntTaxprice As Variant, _
                                    Optional ByRef vntTax As Variant, _
                                    Optional ByRef vntSenddate As Variant, _
                                    Optional ByRef vntZaimuClass As Variant, _
                                    Optional ByRef vntNoPriceEdit As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objZaimuseq         As OraField
    Dim objCrtDate          As OraField
    Dim objInsdate          As OraField
    Dim objInsdiv           As OraField
    Dim objZaimucd          As OraField
    Dim objZaimuname        As OraField
    Dim objZaimuDiv         As OraField
    Dim objOrgCd1           As OraField
    Dim objOrgCd2           As OraField
    Dim objOrgName          As OraField
    Dim objPrice            As OraField
    Dim objTaxprice         As OraField
    Dim objTax              As OraField
    Dim objSendDate         As OraField
    Dim objZaimuClass       As OraField
    
    Dim vntArrZaimuseq()    As Variant
    Dim vntArrCrtdate()     As Variant
'    Dim vntArrInsdate()     As Variant
    Dim vntArrInsdiv()      As Variant
    Dim vntArrZaimucd()     As Variant
    Dim vntArrZaimuname()   As Variant
    Dim vntArrZaimudiv()    As Variant
    Dim vntArrOrgcd1()      As Variant
    Dim vntArrOrgcd2()      As Variant
    Dim vntArrOrgname()     As Variant
    Dim vntArrPrice()       As Variant
    Dim vntArrTaxprice()    As Variant
    Dim vntArrTax()         As Variant
    Dim vntArrSenddate()    As Variant
    Dim vntArrZaimuClass()  As Variant
    
    Dim lngCount            As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT
    If (Trim(strZaimuseq) <> "") And (IsNumeric(strZaimuseq) = True) Then
        objOraParam.Add "ZAIMUSEQ", CInt(strZaimuseq), ORAPARM_INPUT
    End If
    
    '検索条件を満たす財務連携テーブルのレコードを取得
    strStmt = "SELECT CONSULT_ZAIMU.ZAIMUSEQ, CONSULT_ZAIMU.CRTDATE,  " & vbLf & _
              "       CONSULT_ZAIMU.INSDIV,   CONSULT_ZAIMU.ZAIMUCD,  ZAIMU.ZAIMUNAME," & vbLf & _
              "       ZAIMU.ZAIMUDIV,         CONSULT_ZAIMU.ORGCD1,   CONSULT_ZAIMU.ORGCD2," & vbLf & _
              "       ORG.ORGNAME,            CONSULT_ZAIMU.PRICE,    CONSULT_ZAIMU.TAXPRICE," & vbLf & _
              "       CONSULT_ZAIMU.TAX,      CONSULT_ZAIMU.SENDDATE, ZAIMU.ZAIMUCLASS" & vbLf & _
              "  FROM ZAIMU, ORG, CONSULT_ZAIMU" & vbLf & _
              " WHERE CONSULT_ZAIMU.RSVNO    = :RSVNO" & vbLf

    '財務SEQの指定がある場合のみ、条件文追加
    If (Trim(strZaimuseq) <> "") And (IsNumeric(strZaimuseq) = True) Then
        strStmt = strStmt & _
              "   AND CONSULT_ZAIMU.ZAIMUSEQ = :ZAIMUSEQ" & vbLf
    End If

    strStmt = strStmt & _
              "   AND CONSULT_ZAIMU.ORGCD1   = ORG.ORGCD1" & vbLf & _
              "   AND CONSULT_ZAIMU.ORGCD2   = ORG.ORGCD2" & vbLf & _
              "   AND CONSULT_ZAIMU.ZAIMUCD  = ZAIMU.ZAIMUCD" & vbLf & _
              " ORDER BY CONSULT_ZAIMU.INSDIV, CONSULT_ZAIMU.ZAIMUSEQ"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    Do Until objOraDyna.EOF
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objZaimuseq = objFields("ZAIMUSEQ")
        Set objCrtDate = objFields("CRTDATE")
'        Set objInsdate = objFields("INSDATE")
        Set objInsdiv = objFields("INSDIV")
        Set objZaimucd = objFields("ZAIMUCD")
        Set objZaimuname = objFields("ZAIMUNAME")
        Set objZaimuDiv = objFields("ZAIMUDIV")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objPrice = objFields("PRICE")
        Set objTaxprice = objFields("TAXPRICE")
        Set objTax = objFields("TAX")
        Set objSendDate = objFields("SENDDATE")
        Set objZaimuClass = objFields("ZAIMUCLASS")
    
        '戻り値の設定
        ReDim Preserve vntArrZaimuseq(lngCount)
        ReDim Preserve vntArrCrtdate(lngCount)
'        ReDim Preserve vntArrInsdate(lngCount)
        ReDim Preserve vntArrInsdiv(lngCount)
        ReDim Preserve vntArrZaimucd(lngCount)
        ReDim Preserve vntArrZaimuname(lngCount)
        ReDim Preserve vntArrZaimudiv(lngCount)
        ReDim Preserve vntArrOrgcd1(lngCount)
        ReDim Preserve vntArrOrgcd2(lngCount)
        ReDim Preserve vntArrOrgname(lngCount)
        ReDim Preserve vntArrPrice(lngCount)
        ReDim Preserve vntArrTaxprice(lngCount)
        ReDim Preserve vntArrTax(lngCount)
        ReDim Preserve vntArrSenddate(lngCount)
        ReDim Preserve vntArrZaimuClass(lngCount)
        
        vntArrZaimuseq(lngCount) = objZaimuseq.Value & ""
        vntArrCrtdate(lngCount) = objCrtDate.Value & ""
'        vntArrInsdate(lngCount) = objInsdate.Value & ""
        vntArrInsdiv(lngCount) = objInsdiv.Value & ""
        vntArrZaimucd(lngCount) = objZaimucd.Value & ""
        vntArrZaimuname(lngCount) = objZaimuname.Value & ""
        vntArrZaimudiv(lngCount) = objZaimuDiv.Value & ""
        vntArrOrgcd1(lngCount) = objOrgCd1.Value & ""
        vntArrOrgcd2(lngCount) = objOrgCd2.Value & ""
        vntArrOrgname(lngCount) = objOrgName.Value & ""
        
        vntArrPrice(lngCount) = Format(CLng(objPrice.Value), "#,###")
        vntArrTaxprice(lngCount) = Format(CLng(objTaxprice.Value), "#,###")
        
        '編集なし指定の場合、金額をそのままセット
        If IsMissing(vntNoPriceEdit) = False Then
            If vntNoPriceEdit = True Then
                vntArrPrice(lngCount) = CLng(objPrice.Value)
                vntArrTaxprice(lngCount) = CLng(objTaxprice.Value)
            End If
        End If
        
        vntArrTax(lngCount) = objTax.Value & ""
        vntArrSenddate(lngCount) = objSendDate.Value & ""
        vntArrZaimuClass(lngCount) = objZaimuClass.Value & ""
        
        lngCount = lngCount + 1
        objOraDyna.MoveNext
        
    Loop
    
    If IsMissing(vntZaimuseq) = False Then vntZaimuseq = vntArrZaimuseq
    If IsMissing(vntCrtdate) = False Then vntCrtdate = vntArrCrtdate
'    If IsMissing(vntInsdate) = False Then vntInsdate = vntArrInsdate
    If IsMissing(vntInsdiv) = False Then vntInsdiv = vntArrInsdiv
    If IsMissing(vntZaimucd) = False Then vntZaimucd = vntArrZaimucd
    If IsMissing(vntZaimuname) = False Then vntZaimuname = vntArrZaimuname
    If IsMissing(vntZaimudiv) = False Then vntZaimudiv = vntArrZaimudiv
    If IsMissing(vntOrgcd1) = False Then vntOrgcd1 = vntArrOrgcd1
    If IsMissing(vntOrgcd2) = False Then vntOrgcd2 = vntArrOrgcd2
    If IsMissing(vntOrgname) = False Then vntOrgname = vntArrOrgname
    If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
    If IsMissing(vntTaxprice) = False Then vntTaxprice = vntArrTaxprice
    If IsMissing(vntTax) = False Then vntTax = vntArrTax
    If IsMissing(vntSenddate) = False Then vntSenddate = vntArrSenddate
    If IsMissing(vntZaimuClass) = False Then vntZaimuClass = vntArrZaimuClass
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    SelectConsult_Zaimu = lngCount

    Exit Function
    
ErrorHandle:

    SelectConsult_Zaimu = -1
    
    'イベントログ書き込み
    WriteErrorLog "Zaimu.SelectConsult_Zaimu"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 財務連携用CSVデータを作成する
'
' 引数　　 : (In)    dtmInsDate     収納対象日
' 　　　　   (In)    blnDateOnly    TRUE:収納対象日のみで作成、FALSE:未送信データは全て対象
' 　　　　   (In)    blnAppendMode  TRUE:既存データ追加型でCSV作成。FALSE:新規作成
' 　　　　   (In)    vntStrDate     対象締め範囲開始日（省略可）
' 　　　　   (In)    vntEndDate     対象締め範囲終了日（省略可）
'
' 戻り値　 : CSV作成件数（マイナスは異常終了）
'
' 備考　　 : 締め範囲が設定されている場合は、団体請求書データからも財務連携データを作成する。
'
Public Function CreateZaimuCsv(ByVal dtmInsDate As Date, _
                               ByVal blnDateOnly As Boolean, _
                               ByVal blnAppendMode As Boolean, _
                               Optional vntStrDate As Variant, _
                               Optional vntEndDate As Variant) As Long

'エラーハンドラの設定
On Error GoTo ErrorHandle

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim strPerName      As String
    Dim strCsvString    As String
    
    Dim objFree         As Object
    Dim vntFreeCd       As Variant
    Dim vntFreeField1   As Variant
    Dim lngFreeCount    As Long
    Dim i               As Integer
    
    Dim strZaimuLocPath As String
    Dim strZaimuSysCd   As String
    
    Dim objFileSystem   As Object
    Dim objTextStream   As Object
    Dim strFileName     As String
    
    Dim Ret             As Long             '関数戻り値
    Dim lngWkCount      As Long
    Dim lngCsvCount     As Long
    Dim lngOrgCsvCount  As Long
    Dim strCSVTekiyouName   As String
    Dim dtmNendo        As Date
    Dim intKanendo      As Integer
    
    CreateZaimuCsv = 0
    lngCsvCount = 0
    lngOrgCsvCount = 0
    intKanendo = 0
    
    strZaimuLocPath = ""
    strZaimuSysCd = ""
    
    '財務連携用の固定コードアクセス
    Set objFree = mobjContext.CreateInstance("HainsFree.Free")
    lngFreeCount = objFree.SelectFree(1, "ZAIMU", vntFreeCd, , , vntFreeField1)
        
    If lngFreeCount < 3 Then
        CreateZaimuCsv = -9         '汎用テーブルに財務用設定がされていない
        App.LogEvent vbCrLf & _
                     "webHains Application Error: " & vbCrLf & _
                     "財務連携用CSVの格納先パス名が設定されていません。汎用テーブルの KEY=ZAIMULOCPATH, ZAIMUSYSCDの存在を確認してください。", vbLogEventTypeError
        Set objFree = Nothing
        Exit Function
    End If
    
    For i = 0 To lngFreeCount - 1
        
        Select Case vntFreeCd(i)
            
            Case "ZAIMULOCPATH"
                strZaimuLocPath = vntFreeField1(i)
                strFileName = strZaimuLocPath & "\" & "健診." & Format(dtmInsDate, "YYYY") & Format(dtmInsDate, "MM") & Format(dtmInsDate, "DD") & ".txt"
            
            Case "ZAIMUSYSCD"
                strZaimuSysCd = vntFreeField1(i)
        
        End Select
            
    Next i
    
    'ファイルオブジェクト作成
    Set objFileSystem = CreateObject("Scripting.FileSystemObject")
    
    'ファイル追加モード毎のオープン処理
    If blnAppendMode = False Then
        
        '新規作成モード
        On Error Resume Next
        Kill strFileName        '既存ファイルを削除する
        On Error GoTo 0
        Set objTextStream = objFileSystem.CreateTextFile(strFileName)
    
    Else
        
        '追加モード
        If Dir(strFileName) = "" Then
            Set objTextStream = objFileSystem.CreateTextFile(strFileName)
        Else
            Set objTextStream = objFileSystem.OpenTextFile(strFileName, 8)
        End If
    
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "INSDATE", dtmInsDate, ORAPARM_INPUT, ORATYPE_DATE
    
    objOraParam.Add "CRTDATE", dtmInsDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'### 2002.04.05 Added By H.Ishihara@FSIT 対象受診者名を索引する場合は、財務種別の設定が必要
    objOraParam.Add "ZAIMUDIV", 0, ORAPARM_INPUT, ORATYPE_NUMBER
'### 2002.04.05 Added End
    
    
'### 2002.03.23 Updated By H.Ishihara@FSIT ストアド名称変更
    'Stored Call (引数:dtmCslDateに該当する当日IDから、受診金額確定テーブルを作成。また財務連携テーブルを作成する）
'    strStmt = "BEGIN :RET := ZAIMUPACKAGE.DecideAllConsultPrice(:INSDATE); END;"
    strStmt = "BEGIN :RET := ZAIMUPACKAGE.CreateAllZaimuData(:INSDATE); END;"
'### 2002.03.23 End

    mobjOraDb.ExecuteSQL strStmt
    
    '作成された財務連携テーブルをサマリして読み込み（財務種別が過去未収分入金を除くもの）
    strStmt = "SELECT ZAIMUSUMMARY.CRTDATE,    ZAIMUSUMMARY.ORGCD1,    ZAIMUSUMMARY.ORGCD2, ORG.ORGNAME," & _
              "       ZAIMUSUMMARY.INSDIV,     ZAIMUSUMMARY.ZAIMUCD,   ZAIMU.ZAIMUDIV," & _
              "       ZAIMUSUMMARY.PRICE,      ZAIMUSUMMARY.TAXPRICE,  ZAIMUSUMMARY.TAX,     " & _
              "       ZAIMUSUMMARY.ZAIMUCOUNT, COURSE_P.CSNAME,        ZAIMU.ZAIMUNAME," & _
              "       COURSE_P.CSCD" & _
              "  FROM ORG, COURSE_P, ZAIMU, (" & _
              "     SELECT CONSULT_ZAIMU.CRTDATE, CONSULT_ZAIMU.ORGCD1, CONSULT_ZAIMU.ORGCD2,  " & _
              "            CONSULT.CSCD,          CONSULT_ZAIMU.INSDIV, CONSULT_ZAIMU.ZAIMUCD," & _
              "            SUM(CONSULT_ZAIMU.PRICE) PRICE, SUM(CONSULT_ZAIMU.TAXPRICE) TAXPRICE, " & _
              "            CONSULT_ZAIMU.TAX,     COUNT(CONSULT_ZAIMU.ZAIMUCD) ZAIMUCOUNT" & _
              "       FROM CONSULT, CONSULT_ZAIMU"

    '収納日指定か、未送信全てか？
    If blnDateOnly = True Then
        strStmt = strStmt & " WHERE CONSULT_ZAIMU.CRTDATE = :INSDATE" & _
                            "   AND CONSULT.RSVNO         = CONSULT_ZAIMU.RSVNO"

    Else
        strStmt = strStmt & " WHERE CONSULT.RSVNO = CONSULT_ZAIMU.RSVNO"
    End If

    strStmt = strStmt & _
              "        AND SENDDATE IS NULL" & _
              "      GROUP BY CONSULT_ZAIMU.CRTDATE, CONSULT_ZAIMU.ORGCD1,  CONSULT_ZAIMU.ORGCD2, " & _
              "               CONSULT_ZAIMU.INSDIV,  CONSULT_ZAIMU.ZAIMUCD, CONSULT_ZAIMU.TAX, " & _
              "               CONSULT.CSCD" & _
              "     ) ZAIMUSUMMARY" & _
              " WHERE COURSE_P.CSCD  =  ZAIMUSUMMARY.CSCD" & _
              "   AND ZAIMU.ZAIMUCD  =  ZAIMUSUMMARY.ZAIMUCD" & _
              "   AND ZAIMU.ZAIMUDIV != 3" & _
              "   AND ORG.ORGCD1     =  ZAIMUSUMMARY.ORGCD1" & _
              "   AND ORG.ORGCD2     =  ZAIMUSUMMARY.ORGCD2"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'まず１回目（過去未収金除く）のCSVデータを書く
    lngWkCount = WriteCSVData(strZaimuSysCd, dtmInsDate, blnDateOnly, objOraDyna, objOraParam, objTextStream, intKanendo)
    lngCsvCount = lngCsvCount + lngWkCount
        
    '収納日から年度区切りを算出
    If (Month(dtmInsDate) >= 1) And (Month(dtmInsDate) <= 3) Then
        dtmNendo = CDate(Year(dtmInsDate) - 1 & "/" & "04/01")
    Else
        dtmNendo = CDate(Year(dtmInsDate) & "/" & "04/01")
    End If
    objOraParam.Add "NENDO", dtmNendo, ORAPARM_INPUT, ORATYPE_DATE
        
    '過去未収入金用２回Loop（過年度区分対応（泣））
    For i = 0 To 1
        
        'SQL Build
'### 2002/04/10 Updated by H.Ishihara@FSIT 過去未収のデータから未収元を索引した後に、未収元で計上していたm(__)m
'        strStmt = "SELECT ZAIMUSUMMARY.CRTDATE,    ZAIMUSUMMARY.ORGCD1,    ZAIMUSUMMARY.ORGCD2, ORG.ORGNAME," & vbLf & _
                  "       ZAIMUSUMMARY.INSDIV,     ZAIMUSUMMARY.ZAIMUCD,   ZAIMU.ZAIMUDIV," & vbLf & _
                  "       ZAIMUSUMMARY.PRICE,      ZAIMUSUMMARY.TAXPRICE,  ZAIMUSUMMARY.TAX,     " & vbLf & _
                  "       ZAIMUSUMMARY.ZAIMUCOUNT, COURSE_P.CSNAME,        ZAIMU.ZAIMUNAME," & vbLf & _
                  "       COURSE_P.CSCD" & vbLf & _
                  "  FROM ORG, COURSE_P, ZAIMU, " & vbLf & _
                  "     ( SELECT CONSULT_ZAIMU.CRTDATE, CONSULT_ZAIMU.ORGCD1, CONSULT_ZAIMU.ORGCD2,  " & vbLf & _
                  "              CONSULT.CSCD,          CONSULT_ZAIMU.INSDIV, CONSULT_ZAIMU.ZAIMUCD," & vbLf & _
                  "              SUM(CONSULT_ZAIMU.PRICE) PRICE, SUM(CONSULT_ZAIMU.TAXPRICE) TAXPRICE, " & vbLf & _
                  "              CONSULT_ZAIMU.TAX,     COUNT(CONSULT_ZAIMU.ZAIMUCD) ZAIMUCOUNT" & vbLf & _
                  "         FROM CONSULT, CONSULT_ZAIMU," & vbLf & _
                  "            ( SELECT CONSULT_ZAIMU.RSVNO, CONSULT_ZAIMU.ZAIMUSEQ" & vbLf & _
                  "                FROM CONSULT_ZAIMU, " & vbLf & _
                  "                   ( SELECT CONSULT_ZAIMU.RSVNO, CONSULT_ZAIMU.INZAIMUSEQ ZAIMUSEQ" & vbLf & _
                  "                       FROM ZAIMU, CONSULT_ZAIMU " & vbLf & _
                  "                      WHERE CONSULT_ZAIMU.CRTDATE = :INSDATE" & vbLf & _
                  "                        AND ZAIMU.ZAIMUCD         = CONSULT_ZAIMU.ZAIMUCD" & vbLf & _
                  "                        AND ZAIMU.ZAIMUDIV        = 3 " & vbLf & _
                  "                        AND CONSULT_ZAIMU.SENDDATE IS NULL) BASE" & vbLf & _
                  "               WHERE CONSULT_ZAIMU.RSVNO    = BASE.RSVNO" & vbLf & _
                  "                 AND CONSULT_ZAIMU.ZAIMUSEQ = BASE.ZAIMUSEQ" & vbLf
        strStmt = "SELECT ZAIMUSUMMARY.CRTDATE,    ZAIMUSUMMARY.ORGCD1,    ZAIMUSUMMARY.ORGCD2, ORG.ORGNAME," & vbLf & _
                  "       ZAIMUSUMMARY.INSDIV,     ZAIMUSUMMARY.ZAIMUCD,   ZAIMU.ZAIMUDIV," & vbLf & _
                  "       ZAIMUSUMMARY.PRICE,      ZAIMUSUMMARY.TAXPRICE,  ZAIMUSUMMARY.TAX,     " & vbLf & _
                  "       ZAIMUSUMMARY.ZAIMUCOUNT, COURSE_P.CSNAME,        ZAIMU.ZAIMUNAME," & vbLf & _
                  "       COURSE_P.CSCD" & vbLf & _
                  "  FROM ORG, COURSE_P, ZAIMU, " & vbLf & _
                  "     ( SELECT CONSULT_ZAIMU.CRTDATE, CONSULT_ZAIMU.ORGCD1, CONSULT_ZAIMU.ORGCD2,  " & vbLf & _
                  "              CONSULT.CSCD,          CONSULT_ZAIMU.INSDIV, CONSULT_ZAIMU.ZAIMUCD," & vbLf & _
                  "              SUM(CONSULT_ZAIMU.PRICE) PRICE, SUM(CONSULT_ZAIMU.TAXPRICE) TAXPRICE, " & vbLf & _
                  "              CONSULT_ZAIMU.TAX,     COUNT(CONSULT_ZAIMU.ZAIMUCD) ZAIMUCOUNT" & vbLf & _
                  "         FROM CONSULT, CONSULT_ZAIMU," & vbLf & _
                  "            ( SELECT CONSULT_ZAIMU.RSVNO, BASE.ZAIMUSEQ" & vbLf & _
                  "                FROM CONSULT_ZAIMU, " & vbLf & _
                  "                   ( SELECT CONSULT_ZAIMU.RSVNO, CONSULT_ZAIMU.ZAIMUSEQ ZAIMUSEQ, CONSULT_ZAIMU.INZAIMUSEQ INZAIMUSEQ" & vbLf & _
                  "                       FROM ZAIMU, CONSULT_ZAIMU " & vbLf & _
                  "                      WHERE CONSULT_ZAIMU.CRTDATE = :INSDATE" & vbLf & _
                  "                        AND ZAIMU.ZAIMUCD         = CONSULT_ZAIMU.ZAIMUCD" & vbLf & _
                  "                        AND ZAIMU.ZAIMUDIV        = 3 " & vbLf & _
                  "                        AND CONSULT_ZAIMU.SENDDATE IS NULL) BASE" & vbLf & _
                  "               WHERE CONSULT_ZAIMU.RSVNO    = BASE.RSVNO" & vbLf & _
                  "                 AND CONSULT_ZAIMU.ZAIMUSEQ = BASE.INZAIMUSEQ" & vbLf
'### 2002/04/10 Updated End
            
        If i = 0 Then
            '今年度の未収に対する入金を抽出
            strStmt = strStmt & _
                  "                 AND CONSULT_ZAIMU.CRTDATE >= :NENDO" & vbLf
        Else
            '前年度の未収に対する入金を抽出（過年度フラグ対象）
            strStmt = strStmt & _
                  "                 AND CONSULT_ZAIMU.CRTDATE <  :NENDO" & vbLf
        End If
            
        strStmt = strStmt & _
              "            ) BASEZAIMU" & vbLf & _
              "        WHERE CONSULT_ZAIMU.RSVNO    = BASEZAIMU.RSVNO" & vbLf & _
              "          AND CONSULT_ZAIMU.ZAIMUSEQ = BASEZAIMU.ZAIMUSEQ" & vbLf & _
              "          AND CONSULT.RSVNO          = CONSULT_ZAIMU.RSVNO" & vbLf & _
              "        GROUP BY CONSULT_ZAIMU.CRTDATE, CONSULT_ZAIMU.ORGCD1,  CONSULT_ZAIMU.ORGCD2, " & vbLf & _
              "                 CONSULT_ZAIMU.INSDIV,  CONSULT_ZAIMU.ZAIMUCD, CONSULT_ZAIMU.TAX, " & vbLf & _
              "                 CONSULT.CSCD" & vbLf & _
              "       ) ZAIMUSUMMARY" & vbLf & _
              "   WHERE COURSE_P.CSCD = ZAIMUSUMMARY.CSCD" & vbLf & _
              "     AND ZAIMU.ZAIMUCD = ZAIMUSUMMARY.ZAIMUCD" & vbLf & _
              "     AND ORG.ORGCD1    = ZAIMUSUMMARY.ORGCD1" & vbLf & _
              "     AND ORG.ORGCD2    = ZAIMUSUMMARY.ORGCD2"
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        intKanendo = i      '過年度区分セット
        lngWkCount = WriteCSVData(strZaimuSysCd, dtmInsDate, blnDateOnly, objOraDyna, objOraParam, objTextStream, intKanendo)
        lngCsvCount = lngCsvCount + lngWkCount
    
    Next i
        
    '送信済みとして、更新する
    strStmt = "UPDATE CONSULT_ZAIMU " & _
              "   SET SENDDATE = (SYSDATE)"
    
    '収納日指定か、未送信全てか？
    If blnDateOnly = True Then
        strStmt = strStmt & "WHERE CONSULT_ZAIMU.CRTDATE = :INSDATE"
        strStmt = strStmt & "  AND SENDDATE IS NULL"
    Else
        strStmt = strStmt & " WHERE SENDDATE IS NULL"
    End If
    
    Ret = mobjOraDb.ExecuteSQL(strStmt)
        
        
    '締め範囲日が指定されているなら、団体請求書からも財務連携データを作成する
    If (IsMissing(vntStrDate) = False) And (IsMissing(vntEndDate) = False) Then
        
        '団体締め情報からの財務連携データ作成
        lngOrgCsvCount = CreateZaimuCsvFromBill(strZaimuSysCd, dtmInsDate, CDate(vntStrDate), CDate(vntEndDate), objTextStream)
        If lngOrgCsvCount < 0 Then
            CreateZaimuCsv = -9
            Exit Function
        End If
        lngCsvCount = lngCsvCount + lngOrgCsvCount
    
    End If
    
    'CSVファイルクローズ
    objTextStream.Close
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    CreateZaimuCsv = lngCsvCount
    
    Exit Function
    
ErrorHandle:

    CreateZaimuCsv = -1

    'イベントログ書き込み
    WriteErrorLog "Zaimu.CreateZaimuCSV"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : CSVデータ書き込み（1行分、Private)
'
' 引数　　 : (In)    strZaimuSysCd      健診システムコード
' 　　　　   (In)    dtmInsDate         収納日
' 　　　　   (In)    blnDateOnly        TRUE:
' 　　　　   (In)    objOraDyna         Oracle ダイナセット
' 　　　　   (In)    objOraParam        Oracle パラメタ
' 　　　　   (In)    objTextStream      TextStreamObject(Open済み）
' 　　　　   (In)    intKanendo         過年度、当年度
'
' 戻り値　 : CSV書き込み件数
'
' 備考　　 :
'
Private Function WriteCSVData(strZaimuSysCd As String, _
                              dtmInsDate As Date, _
                              blnDateOnly As Boolean, _
                              objOraDyna As OraDynaset, _
                              objOraParam As OraParameters, _
                              objTextStream As Object, _
                              intKanendo As Integer) As Long

'エラーハンドラの設定
On Error GoTo ErrorHandle

    Dim objOraDyna2         As OraDynaset       'ダイナセット
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objFields2          As OraFields        'フィールドオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objCrtDate          As OraField         'データ作成日
    Dim objOrgCd1           As OraField         '団体コード１
    Dim objOrgCd2           As OraField         '団体コード２
    Dim objOrgName          As OraField         '団体名
    Dim objInsdiv           As OraField         '収納区分
    Dim objZaimucd          As OraField         '財務適用コード
    Dim objZaimuDiv         As OraField         '財務適用名
    Dim objPrice            As OraField         '金額
    Dim objTaxprice         As OraField         '税額
    Dim objTax              As OraField         '税率
    Dim objZaimuCount       As OraField         '財務データ対象件数
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objZaimuname        As OraField         '
    Dim objPerName          As OraField         '
    
    Dim strPerName          As String           '個人名
    Dim strCsvString        As String           'CSV用文字列ストリング
    Dim intLastInsDiv       As String           '収納区分
    Dim strCSVTekiyouName   As String
    Dim lngCsvCount         As Long
    Dim Ret As Long

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCrtDate = objFields("CRTDATE")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objInsdiv = objFields("INSDIV")
        Set objZaimucd = objFields("ZAIMUCD")
        Set objZaimuDiv = objFields("ZAIMUDIV")
        Set objPrice = objFields("PRICE")
        Set objTaxprice = objFields("TAXPRICE")
        Set objTax = objFields("TAX")
        Set objZaimuCount = objFields("ZAIMUCOUNT")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objZaimuname = objFields("ZAIMUNAME")
    
        Do Until objOraDyna.EOF
        
            'CSV文字列の初期化
            strCsvString = ""
            strCsvString = strCsvString & strZaimuSysCd & ","                       'システム種別コード
            strCsvString = strCsvString & Format(dtmInsDate, "YYYY") & ","          '年度
            strCsvString = strCsvString & Format(dtmInsDate, "MMDD") & ","          '月日
            strCsvString = strCsvString & objOrgCd1.Value & objOrgCd2.Value & ","   '団体コード
            strCsvString = strCsvString & objOrgName.Value & ","                    '団体名
            strCsvString = strCsvString & objZaimucd.Value & ","                    '財務適用コード
            
            '適用名称の編集
            objOraParam("CRTDATE").Value = objCrtDate.Value
            objOraParam("ORGCD1").Value = objOrgCd1.Value
            objOraParam("ORGCD2").Value = objOrgCd2.Value
            objOraParam("CSCD").Value = objCsCd.Value
'### 2002.04.05 Added By H.Ishihara@FSIT 対象受診者名を索引する場合は、財務種別の設定が必要
            objOraParam("ZAIMUDIV").Value = objZaimuDiv.Value
'### 2002.04.05 Added End

            '収納区分に関係なく対象受診者名称を索引
'### 2002.04.05 Modified By H.Ishihara@FSIT 対象受診者名を索引する場合は、財務種別の設定が必要
'            strStmt = "SELECT PERSON.LASTNAME || '　' || PERSON.FIRSTNAME PERNAME" & vbLf & _
                      "  FROM PERSON, CONSULT, CONSULT_ZAIMU" & vbLf & _
                      " WHERE CONSULT_ZAIMU.CRTDATE = :CRTDATE" & vbLf & _
                      "   AND CONSULT_ZAIMU.ORGCD1 = :ORGCD1" & vbLf & _
                      "   AND CONSULT_ZAIMU.ORGCD2 = :ORGCD2" & vbLf & _
                      "   AND CONSULT.RSVNO = CONSULT_ZAIMU.RSVNO" & vbLf & _
                      "   AND CONSULT.CSCD = :CSCD" & vbLf & _
                      "   AND PERSON.PERID = CONSULT.PERID" & vbLf & _
                      "   AND ROWNUM = 1"
            strStmt = "SELECT PERSON.LASTNAME || '　' || PERSON.FIRSTNAME PERNAME" & vbLf & _
                      "  FROM ZAIMU, PERSON, CONSULT, CONSULT_ZAIMU" & vbLf & _
                      " WHERE CONSULT_ZAIMU.CRTDATE = :CRTDATE" & vbLf & _
                      "   AND CONSULT_ZAIMU.ORGCD1  = :ORGCD1" & vbLf & _
                      "   AND CONSULT_ZAIMU.ORGCD2  = :ORGCD2" & vbLf & _
                      "   AND CONSULT.RSVNO         = CONSULT_ZAIMU.RSVNO" & vbLf & _
                      "   AND CONSULT.CSCD          = :CSCD" & vbLf & _
                      "   AND CONSULT_ZAIMU.ZAIMUCD = ZAIMU.ZAIMUCD" & vbLf & _
                      "   AND ZAIMU.ZAIMUDIV        = :ZAIMUDIV" & vbLf & _
                      "   AND PERSON.PERID          = CONSULT.PERID" & vbLf & _
                      "   AND ROWNUM = 1"
'### 2002.04.05 Modified End
            Set objOraDyna2 = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            Set objFields2 = objOraDyna2.Fields
            Set objPerName = objFields2("PERNAME")
            strPerName = ""
            If Not objOraDyna2.EOF Then
                strPerName = objPerName.Value
            End If
            Set objOraDyna2 = Nothing
            
            strCSVTekiyouName = ""
            If objInsdiv.Value = "0" Then
                '収納区分が”健診”の場合、コース名をセット
                strCSVTekiyouName = objCsName.Value
            Else
                '収納区分が”健診”以外の場合、適用名称をセット
                strCSVTekiyouName = objZaimuname.Value
            End If
            
            '適用名＋受診者名＋カウント数をセット
            If CLng(objZaimuCount.Value) > 1 Then
                '１人以上いる場合は、他人数から１ひく（日本語のつじつま合わせ）
                strCsvString = strCsvString & strCSVTekiyouName & " " & strPerName & "他 " & CLng(objZaimuCount.Value) - 1 & "名" & ","
            Else
                '一人しかいないなら人数表示は不要
                strCsvString = strCsvString & strCSVTekiyouName & " " & strPerName & ","
            End If
            
'---------------------------------------------------------------------------------------
            strCsvString = strCsvString & objPrice.Value & ","          '金額
            
            '区分のセット
            Select Case objInsdiv.Value
                
                Case "0"        '健診業務の場合
                    If ((objOrgCd1.Value = "XXXXX") And (objOrgCd2.Value = "XXXXX")) Or _
                       ((objOrgCd1.Value = "WWWWW") And (objOrgCd2.Value = "WWWWW")) Then
                        intLastInsDiv = 1                                       '窓口個人をセット
                    Else
                        intLastInsDiv = 2                                       '団体請求をセット
                    End If
            
                Case "1"        '電話代の場合
                    intLastInsDiv = 3
            
                Case "2"        '文書料の場合
                    intLastInsDiv = 4
            
                Case "3"        '雑収入の場合
                    intLastInsDiv = 5
            
            End Select
            strCsvString = strCsvString & intLastInsDiv & ","                 '窓口個人をセット
            
            strCsvString = strCsvString & objZaimuDiv.Value & ","           '種別
            strCsvString = strCsvString & objTaxprice.Value & ","           '税額
            strCsvString = strCsvString & objTax.Value & ","                '税率
            strCsvString = strCsvString & objCsCd.Value & ","               'コースコード
            strCsvString = strCsvString & intKanendo & ","                  '過年度・当年度区分

            'ここから後のデータは収入日報用データ   '-------------
            strCsvString = strCsvString & strCSVTekiyouName & ","           '種別
            strCsvString = strCsvString & strPerName & ","                  '適用（個人名）
            strCsvString = strCsvString & CLng(objZaimuCount.Value)         '件数
            
            objTextStream.WriteLine (strCsvString)
            
            lngCsvCount = lngCsvCount + 1
            objOraDyna.MoveNext
        
        Loop
        
    End If

    'オブジェクトクリア
    Set objOraDyna2 = Nothing
    Set objFields = Nothing
    Set objFields2 = Nothing

    WriteCSVData = lngCsvCount
    
    Exit Function
    
ErrorHandle:

    WriteCSVData = -1

    'イベントログ書き込み
    WriteErrorLog "Zaimu.WriteCSVData"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function
'
' 機能　　 : 団体請求書から財務連携用CSVを作成する財務適用データの一覧を取得する
'
' 引数　　 : (In)    strZaimuSysCd      財務用システム種別コード
' 　　　　 : (In)    dtmInsDate         収納日
' 　　　　 : (In)    dtmStrDate         処理開始日
' 　　　　 : (In)    dtmEndDate         処理終了日
' 　　　　 : (In)    objTextStream      テキストストリームオブジェクト
'
' 戻り値　 : レコード件数
'
' 備考　　 : この関数は基本的に、CreateZaimuCSVの追加関数として呼び出される
'
Private Function CreateZaimuCsvFromBill(strZaimuSysCd As String, _
                                        dtmInsDate As Date, _
                                        dtmStrDate As Date, _
                                        dtmEndDate As Date, _
                                        objTextStream As Object) As Long

    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objDemand           As Object           '請求アクセス用COMオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objBillNo           As OraField         '
    Dim objSeq              As OraField         '
    Dim objOrgCd1           As OraField         '
    Dim objOrgCd2           As OraField         '
    Dim objOrgName          As OraField         '
    Dim objCsCd             As OraField         '
    Dim objCsName           As OraField         '
    Dim objSubTotal         As OraField         '
    Dim objTekiyouCd        As OraField         '
    Dim objZaimuDiv         As OraField         '
    Dim objTax              As OraField         '
    Dim objTaxRates         As OraField         '
    Dim objSendDate         As OraField         '
    
    Dim strCsvString        As String
    Dim lngCount            As Long             'レコード数
    Dim Ret                 As Long
    Dim vntLastName         As Variant
    Dim vntFirstName        As Variant
    Dim strPerName          As String
    Dim lngOrgCslCount      As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    CreateZaimuCsvFromBill = 0
    
    '請求オブジェクト作成
    Set objDemand = mobjContext.CreateInstance("HainsDemand.Demand")
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    objOraParam.Add "PARA_BILLNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PARA_SEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '請求関連テーブルよりレコードを取得
'### 2002.03.20 Modified By H.Ishihara@FSIT 団体コードの検索元が異なっている
'    strStmt = "SELECT BILL.BILLNO, BILL_ORG.SEQ, BILL.ORGCD1, BILL.ORGCD2, ORG.ORGNAME, BILL_ORG.CSCD, COURSE_P.CSNAME, " & vbLf & _
              "       BILL_ORG.SUBTOTAL, COURSE_P.ZAI_ORG_MISYU TEKIYOUCD, ZAIMU.ZAIMUDIV, BILL_ORG.TAX, BILL.TAXRATES," & vbLf & _
              "       BILL_ORG.SENDDATE" & vbLf & _
              "  FROM ZAIMU, ORG, COURSE_P, BILL_ORG, BILL" & vbLf & _
              " WHERE BILL.CLOSEDATE >= :STRDATE" & vbLf & _
              "   AND BILL.CLOSEDATE <= :ENDDATE" & vbLf & _
              "   AND BILL.BILLNO     = BILL_ORG.BILLNO" & vbLf & _
              "   AND BILL_ORG.SENDDATE IS NULL" & vbLf & _
              "   AND BILL_ORG.CSCD   = COURSE_P.CSCD" & vbLf & _
              "   AND ORG.ORGCD1      = BILL.ORGCD1" & vbLf & _
              "   AND ORG.ORGCD2      = BILL.ORGCD2" & vbLf & _
              "   AND COURSE_P.ZAI_ORG_MISYU = ZAIMU.ZAIMUCD" & vbLf & _
              " ORDER BY BILL.ORGCD1, BILL.ORGCD2, BILL_ORG.CSCD"
'### 2002.04.30 Modified By H.Ishihara@FSIT 金額がゼロ円ならデータを取得しない
'    strStmt = "SELECT BILL.BILLNO, BILL_ORG.SEQ, BILL_ORG.CSLORGCD1 ORGCD1, BILL_ORG.CSLORGCD2 ORGCD2, ORG.ORGNAME, BILL_ORG.CSCD, COURSE_P.CSNAME, " & vbLf & _
              "       BILL_ORG.SUBTOTAL, COURSE_P.ZAI_ORG_MISYU TEKIYOUCD, ZAIMU.ZAIMUDIV, BILL_ORG.TAX, BILL.TAXRATES," & vbLf & _
              "       BILL_ORG.SENDDATE" & vbLf & _
              "  FROM ZAIMU, ORG, COURSE_P, BILL_ORG, BILL" & vbLf & _
              " WHERE BILL.CLOSEDATE >= :STRDATE" & vbLf & _
              "   AND BILL.CLOSEDATE <= :ENDDATE" & vbLf & _
              "   AND BILL.BILLNO     = BILL_ORG.BILLNO" & vbLf & _
              "   AND BILL_ORG.SENDDATE IS NULL" & vbLf & _
              "   AND BILL_ORG.CSCD   = COURSE_P.CSCD" & vbLf & _
              "   AND ORG.ORGCD1      = BILL.ORGCD1" & vbLf & _
              "   AND ORG.ORGCD2      = BILL.ORGCD2" & vbLf & _
              "   AND COURSE_P.ZAI_ORG_MISYU = ZAIMU.ZAIMUCD" & vbLf & _
              " ORDER BY BILL.ORGCD1, BILL.ORGCD2, BILL_ORG.CSCD"
    strStmt = "SELECT BILL.BILLNO, BILL_ORG.SEQ, BILL_ORG.CSLORGCD1 ORGCD1, BILL_ORG.CSLORGCD2 ORGCD2, ORG.ORGNAME, BILL_ORG.CSCD, COURSE_P.CSNAME, " & vbLf & _
              "       BILL_ORG.SUBTOTAL, COURSE_P.ZAI_ORG_MISYU TEKIYOUCD, ZAIMU.ZAIMUDIV, BILL_ORG.TAX, BILL.TAXRATES," & vbLf & _
              "       BILL_ORG.SENDDATE" & vbLf & _
              "  FROM ZAIMU, ORG, COURSE_P, BILL_ORG, BILL" & vbLf & _
              " WHERE BILL.CLOSEDATE    >= :STRDATE" & vbLf & _
              "   AND BILL.CLOSEDATE    <= :ENDDATE" & vbLf & _
              "   AND BILL.BILLNO       = BILL_ORG.BILLNO" & vbLf & _
              "   AND BILL_ORG.SENDDATE IS NULL" & vbLf & _
              "   AND BILL_ORG.CSCD     = COURSE_P.CSCD" & vbLf & _
              "   AND ( BILL_ORG.SUBTOTAL > 0 OR BILL_ORG.TAX > 0 )" & vbLf & _
              "   AND ORG.ORGCD1      = BILL.ORGCD1" & vbLf & _
              "   AND ORG.ORGCD2      = BILL.ORGCD2" & vbLf & _
              "   AND COURSE_P.ZAI_ORG_MISYU = ZAIMU.ZAIMUCD" & vbLf & _
              " ORDER BY BILL.ORGCD1, BILL.ORGCD2, BILL_ORG.CSCD"
'### 2002.04.30 Modified End
'### 2002.03.20 Modified End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
'    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_DEFAULT)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objBillNo = objFields("BILLNO")
        Set objSeq = objFields("SEQ")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objSubTotal = objFields("SUBTOTAL")
        Set objTekiyouCd = objFields("TEKIYOUCD")
        Set objZaimuDiv = objFields("ZAIMUDIV")
        Set objTax = objFields("TAX")
        Set objTaxRates = objFields("TAXRATES")
        Set objSendDate = objFields("SENDDATE")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            
            'CSV文字列の初期化
            strCsvString = ""
            strCsvString = strCsvString & strZaimuSysCd & ","                       'システム種別コード
            strCsvString = strCsvString & Format(dtmInsDate, "YYYY") & ","          '年度
            strCsvString = strCsvString & Format(dtmInsDate, "MMDD") & ","          '月日
            strCsvString = strCsvString & objOrgCd1.Value & objOrgCd2.Value & ","   '団体コード
            strCsvString = strCsvString & objOrgName.Value & ","                    '団体名
            strCsvString = strCsvString & objTekiyouCd.Value & ","                  '財務適用コード
            
            '代表受診者名の抽出
            strPerName = ""
            lngOrgCslCount = objDemand.SelectDmdOrgList(objBillNo.Value, _
                                                        objOrgCd1.Value, _
                                                        objOrgCd2.Value, _
                                                        objCsCd.Value, _
                                                        0, _
                                                        0, _
                                                        "", _
                                                        , _
                                                        , _
                                                        , _
                                                        , _
                                                        vntLastName, _
                                                        vntFirstName)
            If lngOrgCslCount > 0 Then
                strPerName = vntLastName(0) & "　" & vntFirstName(0)
            End If
                
            '適用名＋受診者名＋カウント数をセット
            If lngOrgCslCount > 1 Then
                '１人以上いる場合は、他人数から１ひく（日本語のつじつま合わせ）
                strCsvString = strCsvString & objCsName.Value & " " & strPerName & "他 " & lngOrgCslCount - 1 & "名" & ","
            Else
                '一人しかいないなら人数表示は不要
                strCsvString = strCsvString & objCsName.Value & " " & strPerName & ","
            End If
            
            strCsvString = strCsvString & objSubTotal.Value & ","                   '金額
            strCsvString = strCsvString & "2" & ","                                 '団体請求をセット
            strCsvString = strCsvString & objZaimuDiv.Value & ","                   '種別
            strCsvString = strCsvString & objTax.Value & ","                        '税額
            strCsvString = strCsvString & CDbl(objTaxRates.Value) * 100 & ","       '税率
            strCsvString = strCsvString & objCsCd.Value & ","                       'コースコード
'### 2002.04.30 Modified By Ishihara@FSIT カンマがない
'            strCsvString = strCsvString & "0"                                       '過年度・当年度区分（団体は入金がないので絶対当年度）
            strCsvString = strCsvString & "0" & ","                                  '過年度・当年度区分（団体は入金がないので絶対当年度）
'### 2002.04.30 Modified End
            
            'ここから後のデータは収入日報用データ   '-------------
            strCsvString = strCsvString & objCsName.Value & ","                     '種別
            strCsvString = strCsvString & strPerName & ","                          '適用（個人名）
            strCsvString = strCsvString & lngOrgCslCount                            '件数
            
            '送信日時を更新する
            objOraParam("PARA_BILLNO").Value = objBillNo.Value
            objOraParam("PARA_SEQ") = objSeq.Value

            strStmt = "UPDATE BILL_ORG SET SENDDATE = SYSDATE WHERE BILLNO = :PARA_BILLNO AND SEQ = :PARA_SEQ"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
        
            objTextStream.WriteLine (strCsvString)
        
            lngCount = lngCount + 1
            objOraDyna.MoveNext
            
        Loop
    
    End If
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Set objOraDyna = Nothing
    CreateZaimuCsvFromBill = lngCount
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Zaimu.CreateZaimuCsvFromBill"
    
    CreateZaimuCsvFromBill = -1
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 財務連携情報データ(CSVから）取得
'
' 引数　　 : (In)     strZaimuDate      取得する財務連携情報データ連携日
' 　　　　   (In)     vntSendDataPath   送信データ格納用パス
' 　　　　   (Out)    vntSysCd          健診システムコード
' 　　　　   (Out)    vntYY             年度
' 　　　　   (Out)    vntMMDD           月日
' 　　　　   (Out)    vntOrgCd          団体コード
' 　　　　   (Out)    vntOrgName        団体名
' 　　　　   (Out)    vntTekiyouCd      適用コード
' 　　　　   (Out)    vntTekiyouName    適用名
' 　　　　   (Out)    vntPrice          金額
' 　　　　   (Out)    vntKubun          区分
' 　　　　   (Out)    vntShubetsu       種別
' 　　　　   (Out)    vntTaxPrice       税額
' 　　　　   (Out)    vntTax            税率
' 　　　　   (Out)    vntCscd           コースコード
' 　　　　   (Out)    vntKanendo        過年度・当年度区分
' 　　　　   (Out)    vntSyubetsu_NIP   種別（日報用）
' 　　　　   (Out)    vntTekiyou_NIP    適用（日報用）
' 　　　　   (Out)    vntCount_NIP      件数（日報用）
' 　　　　   (Out)    vntRecordCount    レコード件数
' 　　　　   (Out)    blnAlreadySend    TRUE:送信済み、FALSE:未送信
'
' 戻り値　 :  1:データあり
' 　　　　    0:データなし
' 　　　　   -1:異常終了
'
' 備考　　 :
'
Public Function SelectZaimuCsv(ByVal strZaimuDate As String, _
                               Optional ByRef vntSendDataPath As Variant, _
                               Optional ByRef vntSysCd As Variant, _
                               Optional ByRef vntYY As Variant, _
                               Optional ByRef vntMMDD As Variant, _
                               Optional ByRef vntOrgCd As Variant, _
                               Optional ByRef vntOrgname As Variant, _
                               Optional ByRef vntTekiyouCd As Variant, _
                               Optional ByRef vntTekiyouName As Variant, _
                               Optional ByRef vntPrice As Variant, _
                               Optional ByRef vntKubun As Variant, _
                               Optional ByRef vntShubetsu As Variant, _
                               Optional ByRef vntTaxprice As Variant, _
                               Optional ByRef vntTax As Variant, _
                               Optional ByRef vntCscd As Variant, _
                               Optional ByRef vntKanendo As Variant, _
                               Optional ByRef vntSyubetsu_NIP As Variant, _
                               Optional ByRef vntTekiyou_NIP As Variant, _
                               Optional ByRef vntCount_NIP As Variant, _
                               Optional ByRef vntRecordCount As Variant, _
                               Optional ByRef blnAlreadySend As Boolean) As Long

'エラーハンドラの設定
On Error GoTo ErrorHandle

    Dim lngCount                As Long         'レコード数
    Dim objFileSystem           As Object
    Dim objTextStream           As Object
    Dim objTextStream2          As Object
    
    Dim strFileName             As String
    Dim strOutFileName          As String
    Dim intFileNo               As Integer
    Dim strRecord               As String
    
    Dim vntArrSysCd()           As Variant
    Dim vntArrYY()              As Variant
    Dim vntArrMMDD()            As Variant
    Dim vntArrOrgCd()           As Variant
    Dim vntArrOrgname()         As Variant
    Dim vntArrTekiyouCd()       As Variant
    Dim vntArrTekiyouName()     As Variant
    Dim vntArrPrice()           As Variant
    Dim vntArrKubun()           As Variant
    Dim vntArrShubetsu()        As Variant
    Dim vntArrTaxprice()        As Variant
    Dim vntArrTax()             As Variant
    Dim vntArrCsCd()            As Variant
    Dim vntArrKanendo()         As Variant
    Dim vntArrSyubetsu_NIP()    As Variant
    Dim vntArrTekiyou_NIP()     As Variant
    Dim vntArrCount_NIP()       As Variant
    
    Dim vntRecord               As Variant
    Dim lngRecCount             As Long
    Dim vntFreeCd               As Variant
    Dim vntFreeField1           As Variant
    Dim lngFreeCount            As Long
    Dim blnSendData             As Boolean
    Dim objFree                 As Object
    Dim strCsvString            As String
    Dim i                       As Integer
    
    SelectZaimuCsv = 0
    lngRecCount = 0
    
'### 2002.05.14 Added by Ishihara@FSIT 送信済みかどうかの表示を行う
    blnAlreadySend = False
'### 2002.05.14 Added End
    
    blnSendData = False
    'コピー先パスを指定されている場合は、ファイル作成
    If IsMissing(vntSendDataPath) = False Then
        blnSendData = True
    End If
    
    '財務連携用の固定コードアクセス
    Set objFree = mobjContext.CreateInstance("HainsFree.Free")
    lngFreeCount = objFree.SelectFree(0, "ZAIMULOCPATH", vntFreeCd, , , vntFreeField1)
    
    If lngFreeCount < 1 Then
        SelectZaimuCsv = -9         '汎用テーブルに財務用設定がされていない
        Set objFree = Nothing
        Exit Function
    End If
    
    '取得ファイル名編集
'    strFileName = vntFreeField1 & "\健診." & Mid(strZaimuDate, 1, 4) & _
                                            Mid(strZaimuDate, 5, 2) & _
                                            Mid(strZaimuDate, 7, 2) & ".csv"
    
    strFileName = vntFreeField1 & "\健診." & Mid(strZaimuDate, 1, 4) & _
                                            Mid(strZaimuDate, 5, 2) & _
                                            Mid(strZaimuDate, 7, 2)
    
    Do
        
        '検索ファイルがないなら処理終了
        Set objFileSystem = CreateObject("Scripting.FileSystemObject")
        If objFileSystem.FileExists(strFileName & ".txt") = False Then Exit Do
    
        'ファイル書き込みモードの場合、書き込み用のファイル(CSV)オープン
        If blnSendData = True Then
            strOutFileName = vntSendDataPath & "\健診." & Mid(strZaimuDate, 1, 4) & Mid(strZaimuDate, 5, 2) & Mid(strZaimuDate, 7, 2) & ".csv"
            On Error Resume Next
            Kill strOutFileName
            On Error GoTo 0
            Set objTextStream2 = objFileSystem.CreateTextFile(strOutFileName)
        End If
    
        'ファイル読み込み
        Set objTextStream = objFileSystem.OpenTextFile(strFileName & ".txt", 1, False)
        Do While objTextStream.AtEndOfLine <> True
            
            strRecord = objTextStream.Readline
        
'            vntRecord = Split(strRecord, ",", 14)
            vntRecord = Split(strRecord, ",", 17)
        
            ReDim Preserve vntArrSysCd(lngRecCount)
            ReDim Preserve vntArrYY(lngRecCount)
            ReDim Preserve vntArrMMDD(lngRecCount)
            ReDim Preserve vntArrOrgCd(lngRecCount)
            ReDim Preserve vntArrOrgname(lngRecCount)
            ReDim Preserve vntArrTekiyouCd(lngRecCount)
            ReDim Preserve vntArrTekiyouName(lngRecCount)
            ReDim Preserve vntArrPrice(lngRecCount)
            ReDim Preserve vntArrKubun(lngRecCount)
            ReDim Preserve vntArrShubetsu(lngRecCount)
            ReDim Preserve vntArrTaxprice(lngRecCount)
            ReDim Preserve vntArrTax(lngRecCount)
            ReDim Preserve vntArrCsCd(lngRecCount)
            ReDim Preserve vntArrKanendo(lngRecCount)
            ReDim Preserve vntArrSyubetsu_NIP(lngRecCount)
            ReDim Preserve vntArrTekiyou_NIP(lngRecCount)
            ReDim Preserve vntArrCount_NIP(lngRecCount)
        
            vntArrSysCd(lngRecCount) = vntRecord(0) & ""
            vntArrYY(lngRecCount) = vntRecord(1) & ""
            vntArrMMDD(lngRecCount) = vntRecord(2) & ""
            vntArrOrgCd(lngRecCount) = vntRecord(3) & ""
            vntArrOrgname(lngRecCount) = vntRecord(4) & ""
            vntArrTekiyouCd(lngRecCount) = vntRecord(5) & ""
            vntArrTekiyouName(lngRecCount) = vntRecord(6) & ""
            vntArrPrice(lngRecCount) = vntRecord(7) & ""
            vntArrKubun(lngRecCount) = vntRecord(8) & ""
            vntArrShubetsu(lngRecCount) = vntRecord(9) & ""
            vntArrTaxprice(lngRecCount) = vntRecord(10) & ""
            vntArrTax(lngRecCount) = vntRecord(11) & ""
            vntArrCsCd(lngRecCount) = vntRecord(12) & ""
            vntArrKanendo(lngRecCount) = vntRecord(13) & ""
            vntArrSyubetsu_NIP(lngRecCount) = vntRecord(14) & ""
            vntArrTekiyou_NIP(lngRecCount) = vntRecord(15) & ""
            vntArrCount_NIP(lngRecCount) = vntRecord(16) & ""
        
            If blnSendData = True Then
                strCsvString = ""
                For i = 0 To 13
                    strCsvString = strCsvString & vntRecord(i) & ","
                Next i
                strCsvString = Mid(strCsvString, 1, Len(strCsvString) - 1)
                objTextStream2.WriteLine (strCsvString)
            End If
        
            lngRecCount = lngRecCount + 1
        
        Loop
        
        objTextStream.Close
        If blnSendData = True Then objTextStream2.Close
        SelectZaimuCsv = 1
    
        Exit Do
    
    Loop
    
    'レコードが存在するならデータセット
    If lngRecCount > 0 Then
    
        If IsMissing(vntSysCd) = False Then vntSysCd = vntArrSysCd
        If IsMissing(vntYY) = False Then vntYY = vntArrYY
        If IsMissing(vntMMDD) = False Then vntMMDD = vntArrMMDD
        If IsMissing(vntOrgCd) = False Then vntOrgCd = vntArrOrgCd
        If IsMissing(vntOrgname) = False Then vntOrgname = vntArrOrgname
        If IsMissing(vntTekiyouCd) = False Then vntTekiyouCd = vntArrTekiyouCd
        If IsMissing(vntTekiyouName) = False Then vntTekiyouName = vntArrTekiyouName
        If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
        If IsMissing(vntKubun) = False Then vntKubun = vntArrKubun
        If IsMissing(vntShubetsu) = False Then vntShubetsu = vntArrShubetsu
        If IsMissing(vntTaxprice) = False Then vntTaxprice = vntArrTaxprice
        If IsMissing(vntTax) = False Then vntTax = vntArrTax
        If IsMissing(vntCscd) = False Then vntCscd = vntArrCsCd
        If IsMissing(vntKanendo) = False Then vntKanendo = vntArrKanendo
        
        If IsMissing(vntSyubetsu_NIP) = False Then vntSyubetsu_NIP = vntArrSyubetsu_NIP
        If IsMissing(vntTekiyou_NIP) = False Then vntTekiyou_NIP = vntArrTekiyou_NIP
        If IsMissing(vntCount_NIP) = False Then vntCount_NIP = vntArrCount_NIP
        
        If IsMissing(vntRecordCount) = False Then vntRecordCount = lngRecCount
    
    End If
    
'### 2002.05.14 Added by Ishihara@FSIT 送信済みかどうかの表示を行う
    If blnSendData = False Then
        'ファイル書きこみモードでないなら、送信済みファイルの存在チェック
        lngFreeCount = objFree.SelectFree(0, "ZAIMUSNDPATH", vntFreeCd, , , vntFreeField1)
        strOutFileName = vntFreeField1 & "\健診." & Mid(strZaimuDate, 1, 4) & Mid(strZaimuDate, 5, 2) & Mid(strZaimuDate, 7, 2) & ".csv"
        If Len(Trim(Dir(strOutFileName))) > 1 Then
            blnAlreadySend = True
        End If
    End If
'### 2002.05.14 Added End
    
    Set objFree = Nothing
    Set objFileSystem = Nothing
    Set objTextStream = Nothing
    Set objTextStream2 = Nothing
    
    Exit Function
    
ErrorHandle:

    SelectZaimuCsv = -1
    
    'イベントログ書き込み
    WriteErrorLog "Zaimu.SelectZaimuCsv"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 財務連携情報データ(CSV）の書き込み
'
' 引数　　 : (In)    strInsDate        収納日付(8桁の日付）
' 　　　　   (In)    vntSysCd          健診システムコード
' 　　　　   (In)    vntYY             年度
' 　　　　   (In)    vntMMDD           月日
' 　　　　   (In)    vntOrgCd          団体コード
' 　　　　   (In)    vntOrgName        団体名
' 　　　　   (In)    vntTekiyouCd      適用コード
' 　　　　   (In)    vntTekiyouName    適用名
' 　　　　   (In)    vntPrice          金額
' 　　　　   (In)    vntKubun          区分
' 　　　　   (In)    vntShubetsu       種別
' 　　　　   (In)    vntTaxPrice       税額
' 　　　　   (In)    vntTax            税率
' 　　　　   (In)    vntCsCd           コースコード
' 　　　　   (In)    vntKanendo        過年度、当年度区分
' 　　　　   (In)    vntSyubetsu_NIP   種別（日報用）
' 　　　　   (In)    vntTekiyou_NIP    適用（日報用）
' 　　　　   (In)    vntCount_NIP      件数（日報用）
' 　　　　   (In)    intRecordCount    レコード件数
'
' 戻り値　 :  TRUE  :正常終了
' 　　　　    FALSE :データなし
'
' 備考　　 :
'
Public Function RegistZaimuCsv(ByVal strInsDate As String, _
                               ByVal vntSysCd As Variant, _
                               ByVal vntYY As Variant, _
                               ByVal vntMMDD As Variant, _
                               ByVal vntOrgCd As Variant, _
                               ByVal vntOrgname As Variant, _
                               ByVal vntTekiyouCd As Variant, _
                               ByVal vntTekiyouName As Variant, _
                               ByVal vntPrice As Variant, _
                               ByVal vntKubun As Variant, _
                               ByVal vntShubetsu As Variant, _
                               ByVal vntTaxprice As Variant, _
                               ByVal vntTax As Variant, _
                               ByVal vntCscd As Variant, _
                               ByVal vntKanendo As Variant, _
                               ByVal vntSyubetsu_NIP As Variant, _
                               ByVal vntTekiyou_NIP As Variant, _
                               ByVal vntCount_NIP As Variant, _
                               ByVal intRecordCount As Integer) As Boolean

'エラーハンドラの設定
On Error GoTo ErrorHandle

    Dim lngCount                As Long         'レコード数
    Dim objFileSystem           As Object
    Dim objTextStream           As Object
    Dim strFileName             As String
    
    Dim vntRecord               As Variant
    Dim vntFreeCd               As Variant
    Dim vntFreeField1           As Variant
    Dim lngFreeCount            As Long
    
    Dim objFree                 As Object
    Dim i                       As Integer
    Dim strCsvString            As String
    
    RegistZaimuCsv = False
    
    '財務連携用の固定コードアクセス
    Set objFree = mobjContext.CreateInstance("HainsFree.Free")
    lngFreeCount = objFree.SelectFree(0, "ZAIMULOCPATH", vntFreeCd, , , vntFreeField1)
    
    If lngFreeCount < 1 Then
        RegistZaimuCsv = False         '汎用テーブルに財務用設定がされていない
        App.LogEvent vbCrLf & _
                     "webHains Application Error: " & vbCrLf & _
                     "財務連携用CSVの格納先パス名が設定されていません。汎用テーブルにKEY=ZAIMULOCPATHで登録してください。", vbLogEventTypeError
        
        Set objFree = Nothing
        Exit Function
    End If
    
    '取得ファイル名編集
'    strFileName = vntFreeField1 & "\健診." & strInsDate & ".csv"
    strFileName = vntFreeField1 & "\健診." & strInsDate & ".txt"
    
    '既存ファイルを削除する
    On Error Resume Next
    Kill strFileName
    On Error GoTo 0
    
    '更新するデータがなにもないなら、ファイルなし（でいい？）
    If intRecordCount < 1 Then
'### 2002.05.08 Added by Ishihara@FSIT データ削除時は正常終了
        RegistZaimuCsv = True
'### 2002.05.08 Added End
        Exit Function
    End If
    
    'ファイルオブジェクト作成
    Set objFileSystem = CreateObject("Scripting.FileSystemObject")
    Set objTextStream = objFileSystem.CreateTextFile(strFileName)
    
    For i = 0 To intRecordCount - 1
    
        'CSV文字列の初期化
        strCsvString = ""
        strCsvString = strCsvString & vntSysCd(i) & ","
        strCsvString = strCsvString & vntYY(i) & ","
        strCsvString = strCsvString & vntMMDD(i) & ","
        strCsvString = strCsvString & vntOrgCd(i) & ","
        strCsvString = strCsvString & vntOrgname(i) & ","
        strCsvString = strCsvString & vntTekiyouCd(i) & ","
        strCsvString = strCsvString & vntTekiyouName(i) & ","
        strCsvString = strCsvString & vntPrice(i) & ","
        strCsvString = strCsvString & vntKubun(i) & ","
        strCsvString = strCsvString & vntShubetsu(i) & ","
        strCsvString = strCsvString & vntTaxprice(i) & ","
        strCsvString = strCsvString & vntTax(i) & ","
        strCsvString = strCsvString & vntCscd(i) & ","
        strCsvString = strCsvString & vntKanendo(i) & ","
        strCsvString = strCsvString & vntSyubetsu_NIP(i) & ","
        strCsvString = strCsvString & vntTekiyou_NIP(i) & ","
        strCsvString = strCsvString & vntCount_NIP(i)

        objTextStream.WriteLine (strCsvString)
    
    Next i
    
    objTextStream.Close
    RegistZaimuCsv = True

    Exit Function
    
ErrorHandle:

    RegistZaimuCsv = False
    
    'イベントログ書き込み
    WriteErrorLog "Zaimu.RegistZaimuCsv"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 財務テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strZaimuCd         財務コード
' 　　　　   (In)    vntZaimuName       財務適用名
' 　　　　   (In)    intZaimuDiv        財務種別
' 　　　　   (In)    intZaimuClass      財務分類
' 　　　　   (In)    intDisabled        未使用フラグ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistZaimu(ByVal strMode As String, _
                             ByVal strZaimuCd As String, _
                             ByVal strZaimuName As String, _
                             ByVal intZaimuDiv As Integer, _
                             ByVal intZaimuClass As Integer, _
                             ByVal intDisabled As Integer) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    RegistZaimu = INSERT_ERROR
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ZAIMUCD", Trim(strZaimuCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ZAIMUNAME", Trim(strZaimuName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ZAIMUDIV", intZaimuDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ZAIMUCLASS", intZaimuClass, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISABLED", intDisabled, ORAPARM_INPUT, ORATYPE_NUMBER

    Do
        '財務テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE ZAIMU " & _
                      "   SET ZAIMUNAME  = :ZAIMUNAME," & _
                      "       ZAIMUDIV   = :ZAIMUDIV," & _
                      "       ZAIMUCLASS = :ZAIMUCLASS," & _
                      "       DISABLED   = :DISABLED" & _
                      " WHERE ZAIMUCD    = :ZAIMUCD"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす財務テーブルのレコードを取得
        strStmt = "SELECT ZAIMUCD FROM ZAIMU WHERE ZAIMUCD = :ZAIMUCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO ZAIMU (ZAIMUCD, ZAIMUNAME, ZAIMUDIV, ZAIMUCLASS, DISABLED) VALUES (:ZAIMUCD, :ZAIMUNAME, :ZAIMUDIV, :ZAIMUCLASS, :DISABLED)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    If Ret = INSERT_NORMAL Then
        'トランザクションをコミット
        mobjContext.SetComplete
    Else
        'エラー発生時はRollback
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    RegistZaimu = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistZaimu = INSERT_ERROR
    
    'イベントログ書き込み
    WriteErrorLog "Zaimu.RegistZaimu"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 財務テーブルレコードを登録する
'
' 引数　　 : (In)    lngRsvNo           予約番号
' 　　　　   (In)    intZaimuSeq        財務連携ＳＥＱ
' 　　　　   (In)    strCrtDate         財務データ作成日（空白ならシステム日付）
' 　　　　   (In)    intInsDiv          収納区分
' 　　　　   (In)    strZaimuCd         財務コード
' 　　　　   (In)    strOrgCd1          団体コード１
' 　　　　   (In)    strOrgCd2          団体コード２
' 　　　　   (In)    lngPrice           金額
' 　　　　   (In)    intTaxPrice        税額
' 　　　　   (In)    intTax             税率
' 　　　　   (In)    vntInZaimuSeq      入金対象財務連携SEQ
'
' 戻り値　 : INSERT_NORMAL      正常終了
' 　　　　   INSERT_DUPLICATE   同一キーのレコード存在
' 　　　　   INSERT_ERROR       異常終了
'            -9                 入金対象財務ＳＥＱ未指定
'
' 備考　　 : intZaimuSeqが0の場合は、新規挿入（主キーゼロなし）
'
Public Function RegistConsult_Zaimu(ByVal lngRsvNo As Long, _
                                    ByVal intZaimuSeq As Integer, _
                                    ByVal strCrtDate As String, _
                                    ByVal intInsDiv As Integer, _
                                    ByVal strZaimuCd As String, _
                                    ByVal strOrgCd1 As String, _
                                    ByVal strOrgCd2 As String, _
                                    ByVal lngPrice As Long, _
                                    ByVal intTaxPrice As Long, _
                                    ByVal intTax As Integer, _
                                    Optional ByVal vntInZaimuSeq As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objConsult          As Object
    Dim objDemand           As Object
    
    Dim strStmt             As String           'SQLステートメント
    Dim Ret                 As Long             '関数戻り値
    Dim blnSetInZaimuSeq    As Boolean          'TRUE:入金対象財務連携SEQセットあり
    Dim strMode             As String           'UPD:更新モード、INS:挿入モード
    Dim vntCancelFlg        As Variant
    Dim vntCslDate          As Variant
    Dim vntNowTax           As Variant
    
    Dim vntZaimudiv         As Variant
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    RegistConsult_Zaimu = INSERT_ERROR
    Ret = INSERT_ERROR
    blnSetInZaimuSeq = False
    
    '入金対象財務連携SEQのセット有無チェック
    If IsMissing(vntInZaimuSeq) = False Then
        If IsNumeric(vntInZaimuSeq) And vntInZaimuSeq <> 0 Then
            blnSetInZaimuSeq = True
        End If
    End If

    '指定された財務コードから財務種別を取得
    If SelectZaimu(strZaimuCd, , vntZaimudiv) = True Then
        
        '過去未収分入金時に、入金対象財務ＳＥＱがセットされていないならエラー
        If (vntZaimudiv = 3) And (IsMissing(vntInZaimuSeq)) Then
            RegistConsult_Zaimu = -9
            Exit Function
        End If
    
        If (vntZaimudiv = 3) And (IsNumeric(vntInZaimuSeq) = False) Then
            RegistConsult_Zaimu = -9
            Exit Function
        End If
    
        If (vntZaimudiv = 3) And (CLng(vntInZaimuSeq) < 1) Then
            RegistConsult_Zaimu = -9
            Exit Function
        End If
    
    End If

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(lngRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER

    '新規挿入時、入金SEQの最大値取得
    If intZaimuSeq = 0 Then
        strStmt = "SELECT NVL(MAX(ZAIMUSEQ) + 1,1) NEWNO FROM CONSULT_ZAIMU WHERE RSVNO = :RSVNO"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        Set objFields = objOraDyna.Fields
        intZaimuSeq = objFields("NEWNO").Value
        strMode = "INS"
    Else
        strMode = "UPD"
    End If
    
    objOraParam.Add "ZAIMUSEQ", Trim(intZaimuSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "INSDIV", Trim(intInsDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ZAIMUCD", Trim(strZaimuCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PRICE", Trim(lngPrice), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", Trim(intTaxPrice), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '収納日付が日付でない場合、システム日付セット
    If IsDate(strCrtDate) = False Then
        objOraParam.Add "CRTDATE", Date, ORAPARM_INPUT, ORATYPE_DATE
    Else
        objOraParam.Add "CRTDATE", Trim(strCrtDate), ORAPARM_INPUT, ORATYPE_DATE
    End If
    
    '団体コード未指定なら個人指定
    If (strOrgCd1 = "") And (strOrgCd1 = "") Then
        objOraParam.Add "ORGCD1", "XXXXX", ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", "XXXXX", ORAPARM_INPUT, ORATYPE_VARCHAR2
    Else
        objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '税率が数値でないなら、０セット
    If IsNumeric(intTax) = False Then
        intTax = 0
    End If
    
    '収納区分が”健診”なら税率取得
    If intInsDiv = 0 Then
        
        '受診情報オブジェクトのインスタンス作成
        Set objConsult = mobjContext.CreateInstance("HainsConsult.Consult")
        
        '受診日の取得
        If objConsult.SelectConsult(lngRsvNo, vntCancelFlg, vntCslDate) = False Then
            RegistConsult_Zaimu = -91       '有効な予約番号でない
            Set objConsult = Nothing
            Exit Function
        Else
            Set objConsult = Nothing        'とりあえずまずはNothing
            If vntCancelFlg <> 0 Then
                RegistConsult_Zaimu = -92   'キャンセルされた予約
                Exit Function
            End If
        End If
    
        '税額を取得
        Set objDemand = mobjContext.CreateInstance("HainsDemand.Demand")
        If objDemand.GetNowTax(CStr(vntCslDate), vntNowTax, 1) = "" Then
            'Percent変換
            intTax = CDbl(vntNowTax) * 100
        Else
            intTax = 0
        End If
    
    End If
    
    objOraParam.Add "TAX", Trim(intTax), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '入金対象財務連携SEQをセットする場合、条件追加
    If blnSetInZaimuSeq = True Then
        objOraParam.Add "INZAIMUSEQ", Trim(vntInZaimuSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    Do
        '財務連携テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE CONSULT_ZAIMU " & _
                      "   SET RSVNO    = :RSVNO," & _
                      "       ZAIMUSEQ = :ZAIMUSEQ," & _
                      "       CRTDATE  = :CRTDATE," & _
                      "       INSDIV   = :INSDIV," & _
                      "       ZAIMUCD  = :ZAIMUCD," & _
                      "       ORGCD1   = :ORGCD1," & _
                      "       ORGCD2   = :ORGCD2," & _
                      "       PRICE    = :PRICE," & _
                      "       TAXPRICE = :TAXPRICE," & _
                      "       TAX      = :TAX"
            
            '入金対象財務連携SEQをセットする場合、条件追加
            If blnSetInZaimuSeq = True Then
                strStmt = strStmt & _
                          "   ,INZAIMUSEQ = :INZAIMUSEQ"
            End If
            
            strStmt = strStmt & _
                      " WHERE RSVNO    = :RSVNO" & _
                      "   AND ZAIMUSEQ = :ZAIMUSEQ"
            
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        
        End If

        '新規挿入
        If blnSetInZaimuSeq = True Then
            '入金対象財務連携SEQをセットする場合
            strStmt = "INSERT INTO CONSULT_ZAIMU ( RSVNO,  ZAIMUSEQ,  CRTDATE,  INSDIV,  ZAIMUCD,  ORGCD1,  ORGCD2,  PRICE,  TAXPRICE,  TAX,  INZAIMUSEQ)" & vbLf & _
                      "                   VALUES (:RSVNO, :ZAIMUSEQ ,:CRTDATE, :INSDIV, :ZAIMUCD, :ORGCD1, :ORGCD2, :PRICE, :TAXPRICE, :TAX, :INZAIMUSEQ)"
        Else
            '入金対象財務連携SEQをセットしない場合
            strStmt = "INSERT INTO CONSULT_ZAIMU ( RSVNO,  ZAIMUSEQ,  CRTDATE,  INSDIV,  ZAIMUCD,  ORGCD1,  ORGCD2,  PRICE,  TAXPRICE,  TAX)" & vbLf & _
                      "                   VALUES (:RSVNO, :ZAIMUSEQ ,:CRTDATE, :INSDIV, :ZAIMUCD, :ORGCD1, :ORGCD2, :PRICE, :TAXPRICE, :TAX)"
        End If
        
        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    If Ret = INSERT_NORMAL Then
        'トランザクションをコミット
        mobjContext.SetComplete
    Else
        'エラー発生時はRollback
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    RegistConsult_Zaimu = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistConsult_Zaimu = INSERT_ERROR
    
    'イベントログ書き込み
    WriteErrorLog "Zaimu.RegistConsult_Zaimu"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 財務テーブルレコードを削除する
'
' 引数　　 : (In)    strZaimuCd    財務コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteZaimu(ByVal strZaimuCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ZaimuCD", Trim(strZaimuCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '財務テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE Zaimu WHERE ZaimuCD = :ZaimuCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteZaimu = True

    Exit Function
    
ErrorHandle:

    DeleteZaimu = False

    'イベントログ書き込み
    WriteErrorLog "Zaimu.DeleteZaimu"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 財務テーブルレコードを削除する
'
' 引数　　 : (In)    lngRsvNo       予約番号
' 　　　　 : (In)    intZaimuSeq    財務連携SEQ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteConsult_Zaimu(ByVal lngRsvNo As Long, ByVal intZaimuSeq As Integer) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ZAIMUSEQ", intZaimuSeq, ORAPARM_INPUT, ORATYPE_NUMBER

    '財務テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE CONSULT_ZAIMU WHERE RSVNO = :RSVNO AND ZAIMUSEQ = :ZAIMUSEQ"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteConsult_Zaimu = True

    Exit Function
    
ErrorHandle:

    DeleteConsult_Zaimu = False

    'イベントログ書き込み
    WriteErrorLog "Zaimu.DeleteConsult_Zaimu"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

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

'
' 機能　　 : 締めデータをクリアする
'
' 引数　　 : (In)    dtmCrtDate         対象締めデータ作成日（個人用）
' 　　　　 : (In)    dtmStrCloseDate    対象開始締め日（団体用～省略可）
' 　　　　 : (In)    dtmEndCloseDate    対象終了締め日（団体用～省略可）
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function ClearCloseDate(dtmCrtDate As Date, _
                               Optional vntStrCloseDate As Variant, _
                               Optional vntEndCloseDate As Variant) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    ClearCloseDate = False
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "TARGETDATE", dtmCrtDate, ORAPARM_INPUT, ORATYPE_DATE

    Do
        '財務ジャーナルのクリアする
        strStmt = "DELETE ZAIMU_JNL"
        Ret = mobjOraDb.ExecuteSQL(strStmt)
        
        '再度ジャーナルに対象データキーを挿入（過去日を考慮した場合、必要）
'### 2002.05.30 Updated by Ishihara@FSIT 主キーのためDISTINCTオプション必要
'        strStmt = "INSERT INTO ZAIMU_JNL SELECT RSVNO, SYSDATE FROM CONSULT_ZAIMU WHERE CRTDATE = :TARGETDATE"
        strStmt = "INSERT INTO ZAIMU_JNL SELECT DISTINCT RSVNO, TO_DATE(SYSDATE) FROM CONSULT_ZAIMU WHERE CRTDATE = :TARGETDATE"
'### 2002.05.30 Updated End
        Ret = mobjOraDb.ExecuteSQL(strStmt)

        '送信日時（締め日）をクリアする
        strStmt = "UPDATE CONSULT_ZAIMU SET SENDDATE = '' WHERE CRTDATE = :TARGETDATE"
        Ret = mobjOraDb.ExecuteSQL(strStmt)

        '団体締め日が設定されていない場合は、処理終了
        If IsMissing(vntStrCloseDate) Then Exit Do
        
        '団体締め日が日付でない場合、処理終了
        If IsDate(vntStrCloseDate) = False Then Exit Do
        
        '団体締め終了日がセットされていない場合、開始日付をセット
        If IsMissing(vntEndCloseDate) Then
            vntEndCloseDate = vntStrCloseDate
        End If
        
        '団体締め終了日が日付でない場合、開始日付をセット
        If IsDate(vntEndCloseDate) = False Then
            vntEndCloseDate = vntStrCloseDate
        End If
        
        '団体請求用の締め日を指定
        objOraParam.Add "STRCLOSEDATE", CDate(vntStrCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "ENDCLOSEDATE", CDate(vntEndCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        
        '団体請求情報の送信日時（締め日）をクリアする
        strStmt = "UPDATE BILL_ORG SET SENDDATE = '' WHERE BILLNO IN (SELECT BILLNO FROM BILL WHERE CLOSEDATE BETWEEN :STRCLOSEDATE AND :ENDCLOSEDATE)"
        Ret = mobjOraDb.ExecuteSQL(strStmt)
        
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    ClearCloseDate = True

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    ClearCloseDate = False
    
    'イベントログ書き込み
    WriteErrorLog "Zaimu.ClearCloseDate"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
