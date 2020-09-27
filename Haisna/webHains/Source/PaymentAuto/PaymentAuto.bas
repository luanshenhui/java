Attribute VB_Name = "PaymentAuto"
Option Explicit

Public Const MODE_INSERT        As String = "I" '処理モード(挿入)
Public Const MODE_UPDATE        As String = "U" '処理モード(更新)

'構造体←→文字列変換のための構造体
Public Type BUFFER_REC
    Buffer      As String * 256
End Type

'
' 機能　　 : 配列への要素追加
'
' 引数　　 : (In/Out) vntArray1    配列１
' 　　　　   (In/Out) vntArray2    配列２
' 　　　　   (In)     strMessage1  メッセージ１
' 　　　　   (In)     strMessage2  メッセージ２
'
' 備考　　 : バリアント配列の最後部に要素を追加する
'
Public Sub AppendMessage(ByRef vntArray1 As Variant, ByRef vntArray2 As Variant, ByVal strMessage1 As String, Optional ByVal strMessage2 As String = "")

    Dim i   As Long 'インデックス
    
    '要素がなければ何もしない
    If Trim(strMessage1) = "" Then
        Exit Sub
    End If
    
    '配列でない場合は新規配列を作成
    If Not IsArray(vntArray1) Then
        vntArray1 = Array(Trim(strMessage1))
        vntArray2 = Array(Trim(strMessage2))
        Exit Sub
    End If
    
    '配列の最後部に要素を追加
    i = UBound(vntArray1) + 1
    ReDim Preserve vntArray1(i)
    ReDim Preserve vntArray2(i)
    vntArray1(i) = Trim(strMessage1)
    vntArray2(i) = Trim(strMessage2)
    
End Sub

'
' 機能　　 : 日付チェック
'
' 引数　　 : (In)     strExpression  文字列式
' 　　　　   (In)     lngMode        チェックモード(0:年月日、1:年月)
'
' 戻り値　 : True   日付として認識可能
' 　　　　   False  日付として認識不能
'
' 備考　　 :
'
Public Function CheckDate(ByVal strExpression As String, Optional ByVal lngMode As Long = 0) As Boolean

    Dim vntToken    As Variant  'トークン
    Dim strYear     As String   '年
    Dim strMonth    As String   '月
    Dim strDay      As String   '日
    
    Dim Ret As Boolean  '関数戻り値
    Dim i   As Long     'インデックス
    
    strExpression = Trim(strExpression)
    If strExpression = "" Then
        Exit Function
    End If
    
    'スラッシュによる区切りが存在する場合
    If InStr(strExpression, "/") > 0 Then
    
        'スラッシュで文字列を分割
        vntToken = Split(strExpression, "/")
        
        '年月日の場合は要素が３個以外なら、年月の場合は２個以外ならばそれぞれエラー
        If UBound(vntToken) <> IIf(lngMode = 0, 2, 1) Then
            Exit Function
        End If
        
        '年・月・日を編集
        strYear = vntToken(0)
        strMonth = vntToken(1)
        If lngMode = 0 Then
            strDay = vntToken(2)
        Else
            strDay = "1"    '年月の場合における後のチェックのための暫定的処置
        End If
    
        '半角数字チェック
        If Not CheckNumber(strYear) Then
            Exit Function
        End If
    
        '半角数字チェック
        If Not CheckNumber(strMonth) Then
            Exit Function
        End If
    
        '半角数字チェック
        If Not CheckNumber(strDay) Then
            Exit Function
        End If
    
    '区切りが存在しない場合
    Else
    
        '年月日の場合は８桁以外なら、年月の場合６桁以外ならばそれぞれはエラー
        If Len(strExpression) <> IIf(lngMode = 0, 8, 6) Then
            Exit Function
        End If
        
        '半角数字チェック
        If Not CheckNumber(strExpression) Then
            Exit Function
        End If
        
        '年・月・日を編集
        strYear = Left(strExpression, 4)
        strMonth = Mid(strExpression, 5, 2)
        If lngMode = 0 Then
            strDay = Right(strExpression, 2)
        Else
            strDay = "1"    '年月の場合における後のチェックのための暫定的処置
        End If
    
    End If
    
    '日付チェックを行い、正常なら日付とみなす
    CheckDate = IsDate(strYear & "/" & strMonth & "/" & strDay)
    
End Function

'
' 機能　　 : カナ文字チェック
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : True   カナ文字のみで構成
' 　　　　   False  カナ文字以外の文字が存在
'
' 備考　　 : Commonクラスのそれと同一なのでここで所持するのは好ましくないが(正解はSystem.basで所持し、双方から呼ぶ)、
' 　　　　   インスタンス作成時のオーバヘッドを考慮したのと、全コンパイルの回避を考えたうえで複製しました。
'
Public Function CheckKana(ByVal strExpression As String) As Boolean

    Const KANA_STRING   As String = "゛゜ゝゞァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ・ーヽヾ･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ"

    Dim strToken        As String   '検索文字

    Dim i               As Long     'インデックス
    Dim strNarrow       As String   '半角変換後の文字列
    
    '半角変換(漢字は半角変換できない特性を利用)
    strNarrow = StrConv(strExpression, vbNarrow)
    
    '文字列式の文字を１文字ずつ検索
    For i = 1 To Len(strNarrow)
    
        '検索文字の取得
        strToken = Mid(strNarrow, i, 1)
    
        '１文字ずつチェック
        Do
        
            '検索文字が空白であれば何もしない
            If Trim(strToken) = "" Then
                Exit Do
            End If
            
            'アスキーコードが０～２５５ならば正常
            Select Case Asc(strToken)
                Case 0 To 255
                    Exit Do
            End Select
                            
            'ただし、先に定義したカナ文字列の中に存在すれば正常
            If InStr(KANA_STRING, strToken) > 0 Then
                Exit Do
            End If
    
            '上記どの条件をも満たさない場合はエラー
            Exit Function
    
            Exit Do
        Loop
        
    Next i
    
    '全て正常に検索できた場合の戻り値設定
    CheckKana = True
    
End Function

'
' 機能　　 : 値存在チェック
'
' 引数　　 : (In)     strExpression  文字列式
' 　　　　   (In)     vntValue       取り得る値の集合
'
' 戻り値　 : True   値が存在
' 　　　　   False  値が存在しない
'
' 備考　　 :
'
Public Function CheckIntoValue(ByVal strExpression As String, ByRef vntValue As Variant) As Boolean

    Dim Ret As Boolean  '関数戻り値
    Dim i   As Long     'インデックス

    '配列の各要素との比較
    For i = LBound(vntValue) To UBound(vntValue)
        If Trim(strExpression) = Trim(vntValue(i)) Then
            Ret = True
            Exit For
        End If
    Next i
    
    '戻り値の設定
    CheckIntoValue = Ret
    
End Function

'## 2004.10.04 Add By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加
'
' 機能　　 : 半角英数字チェック
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : True   半角英数字として認識可能
' 　　　　   False  半角英数字として認識不能
'
' 備考　　 :
'
Public Function CheckNarrowValue(ByVal strExpression As String) As Boolean

    Dim i   As Long 'インデックス

    strExpression = Trim(strExpression)

    '半角英数字チェック
    For i = 1 To Len(strExpression)
        Select Case Asc(Mid(strExpression, i, 1))
            Case Is < 0, Asc("ｦ") To Asc("ﾟ"), Is > 255
                Exit Function
        End Select
    Next i

    '戻り値の設定
    CheckNarrowValue = True

End Function

'
' 機能　　 : 数字チェック
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : True   数字として認識可能
' 　　　　   False  数字として認識不能
'
' 備考　　 :
'
Public Function CheckNumber(ByVal strExpression As String) As Boolean

    Dim i   As Long 'インデックス
    
    strExpression = Trim(strExpression)
    
    '半角数字チェック
    For i = 1 To Len(strExpression)
        If InStr("0123456789", Mid(strExpression, i, 1)) <= 0 Then
            Exit Function
        End If
    Next i

    '戻り値の設定
    CheckNumber = True
    
End Function

'
' 機能　　 : 数値チェック
'
' 引数　　 : (In)     strExpression  文字列式
' 　　　　   (In)     lngIntLen      整数桁数
' 　　　　   (In)     lngDecLen      小数桁数
'
' 戻り値　 : True   数値として認識可能
' 　　　　   False  数値として認識不能
'
' 備考　　 :
'
Public Function CheckNumber2(ByVal strExpression As String, Optional ByVal lngIntLen As Long = 0, Optional ByVal lngDecLen As Long = 0) As Boolean

    Dim strToken        As String   'トークン
    Dim lngAnalyzeMode  As Long     '現在の解析モード
    Dim strInteger      As String   '整数値
    Dim strDecimal      As String   '小数値
    Dim lngSize         As Long     '文字列長
    Dim i               As Long     'インデックス
    
    strExpression = Trim(strExpression)
    If strExpression = "" Then
        Exit Function
    End If

    '(フェイズ１)構文解析
    i = 1
    
    Do

        'すべて走査した場合は終了
        If i > Len(strExpression) Then
            Exit Do
        End If

        '１文字取得
        strToken = Mid(strExpression, i, 1)

        Do
        
            '現解析モードごとの処理
            Select Case lngAnalyzeMode
    
                Case 0  'モード指定なし
                    
                    '符号であれば整数モードへ
                    If InStr("+-", strToken) > 0 Then
                        lngAnalyzeMode = 1
                        i = i + 1
                        Exit Do
                    End If

                    '数字であれば整数モードへ
                    If InStr("0123456789", strToken) > 0 Then
                        lngAnalyzeMode = 1
                        Exit Do
                    End If
                    
                    '小数点であれば小数モードへ
                    If strToken = "." Then
                        lngAnalyzeMode = 2
                        i = i + 1
                        Exit Do
                    End If

                    '上記以外の場合はエラー
                    Exit Function

                Case 1  '整数モード
            
                    '数字であれば整数値をスタック
                    If InStr("0123456789", strToken) > 0 Then
                        strInteger = strInteger & strToken
                        i = i + 1
                        Exit Do
                    End If
            
                    '小数点であれば小数モードへ
                    If strToken = "." Then
                        lngAnalyzeMode = 2
                        i = i + 1
                        Exit Do
                    End If

                    '上記以外の場合はエラー
                    Exit Function
            
                Case 2  '小数モード
            
                    '数字であれば小数値をスタック
                    If InStr("0123456789", strToken) > 0 Then
                        strDecimal = strDecimal & strToken
                        i = i + 1
                        Exit Do
                    End If
            
                    '上記以外の場合はエラー
                    Exit Function
            
            End Select
            
            Exit Do
        Loop
        
    Loop
            
    '(フェイズ２)整数桁数チェック
    If lngIntLen > 0 And strInteger <> "" Then
            
        '文字列を検索し、最初に０以外の値が現れる個所を検索することで桁数を求める
        lngSize = Len(strInteger)
        For i = 1 To Len(strInteger)
            If Mid(strInteger, i, 1) <> "0" Then
                Exit For
            End If
            lngSize = lngSize - 1
        Next i
            
        'この桁数が引数指定された桁数を超えればエラー
        If lngSize > lngIntLen Then
            Exit Function
        End If

    End If
    
    '(フェイズ３)小数桁数チェック
    If strDecimal <> "" Then
            
        '文字列を最後から検索し、最初に０以外の値が現れる個所を検索することで桁数を求める
        lngSize = Len(strDecimal)
        For i = Len(strDecimal) To 1 Step -1
            If Mid(strDecimal, i, 1) <> "0" Then
                Exit For
            End If
            lngSize = lngSize - 1
        Next i
            
        'この桁数が引数指定された桁数を超えればエラー
        If lngSize > lngDecLen Then
            Exit Function
        End If

    End If

    CheckNumber2 = True
    
End Function

'
' 機能　　 : 日付変換
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : 変換後の日付（但し変換不能時との区別を行うため文字列型として返す）
'
' 備考　　 :
'
Public Function CnvDate(ByVal strExpression As String) As String

    Dim strEra      As String   '元号
    Dim strYear     As String   '年
    Dim strMonth    As String   '月
    Dim strDay      As String   '日
    
    Dim strDate     As String   '変換可能な日付
    Dim strWkDate   As String   '日付編集作業域
    
    Do
    
        '初期処理
        strDate = ""
        
        '未指定の場合
        strExpression = Trim(strExpression)
        If strExpression = "" Then
            Exit Do
        End If
    
        'ピリオドによる区切りが存在する場合、ピリオドをスラッシュに置換してチェック
        If InStr(strExpression, ".") > 0 Then
            strExpression = Replace(strExpression, ".", "/")
        End If
        
        '素のままで日付として認識可能な場合
        If IsDate(strExpression) Then
            strDate = strExpression
            Exit Do
        End If
    
        'それ以外
        
        Select Case Len(strExpression)
        
            '６桁、または８桁の場合、西暦指定かをチェック
            Case 6, 8
        
                '半角数字チェック
                If Not CheckNumber(strExpression) Then
                    Exit Do
                End If
            
                '年・月・日を編集
                If Len(strExpression) = 6 Then
                    strYear = Left(strExpression, 2)
                    strMonth = Mid(strExpression, 3, 2)
                    strDay = Right(strExpression, 2)
                Else
                    strYear = Left(strExpression, 4)
                    strMonth = Mid(strExpression, 5, 2)
                    strDay = Right(strExpression, 2)
                End If
                
                'スラッシュで連結し、日付認識可能かをチェック
                strWkDate = strYear & "/" & strMonth & "/" & strDay
                If Not IsDate(strWkDate) Then
                    Exit Do
                End If
                
                strDate = strWkDate
                Exit Do
        
            '７桁の場合、和暦指定かをチェック
            Case 7
    
                '先頭１文字は元号とし、それ以降が半角数字かをチェック
                If Not CheckNumber(Mid(strExpression, 2, 6)) Then
                    Exit Do
                End If
    
                '元号・年・月・日を編集
                strEra = Left(strExpression, 1)
                strYear = Mid(strExpression, 2, 2)
                strMonth = Mid(strExpression, 4, 2)
                strDay = Right(strExpression, 2)
    
                'スラッシュで連結し、日付認識可能かをチェック
                strWkDate = strEra & strYear & "/" & strMonth & "/" & strDay
                If Not IsDate(strWkDate) Then
                    Exit Do
                End If
                
                strDate = strWkDate
                Exit Do
    
            'それ以外はエラー
            Case Else
            
        End Select
    
        Exit Do
    Loop
    
    '戻り値の設定
    CnvDate = strDate
    
End Function

'
' 機能　　 : 指定されたファイルが使用中であるかを判定
'
' 引数　　 : (In)     strFileName  ファイル名
'
' 戻り値　 : True   使用中である
' 　　　　   False  使用されていない
'
' 備考　　 :
'
Public Function Locked(ByVal strFileName As String) As Boolean
    
    Dim Fn  As Integer  'ファイル番号
    Dim Ret As Boolean  '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '排他付き読み込みモードでファイルをオープンし、排他かを判断
    Fn = FreeFile()
    Open strFileName For Input Lock Read Write As #Fn
    
    Close #Fn
    
    '戻り値の設定
    Locked = Ret
    
    Exit Function

ErrorHandle:

    '「書き込みできません」のエラーが発生した場合に排他と判断
    If Err.Number = 70 Then
        Ret = True
        Resume Next
    End If

    'それ以外はエラーを発生させて終了する
    Err.Raise Err.Number

End Function

'
' 機能　　 : ログテーブルレコードを挿入する
'
' 引数　　 : (In)    objOraDb           OraDatabaseオブジェクト
' 　　　　   (In)    strTransactionId   トランザクションID
' 　　　　   (In)    strTransactionDiv  処理区分
' 　　　　   (In)    strInformationDiv  情報区分
' 　　　　   (In)    strLineNo          対象処理行
' 　　　　   (In)    vntMessage1        メッセージ１
' 　　　　   (In)    vntMessage2        メッセージ２
' 　　　　   (In)    blnNewTransaction  独立したトランザクションとして実行するか
'
' 戻り値　 : INSERT_NORMAL  正常終了
' 　　　　   INSERT_ERROR   異常終了
'
' 備考　　 :
'
Public Function PutHainsLog( _
    ByRef objOraDb As OraDatabase, _
    ByVal lngTransactionId As Long, _
    ByVal strTransactionDiv As String, _
    ByVal strInformationDiv As String, _
    ByVal strLineNo As String, _
    ByVal vntMessage1 As Variant, _
    ByVal vntMessage2 As Variant, _
    Optional ByVal blnNewTransaction As Boolean = True _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSqlStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objMessage1     As OraParameter     'メッセージ１
    Dim objMessage2     As OraParameter     'メッセージ２
    
    Dim vntArrMessage1  As Variant          'メッセージ１
    Dim vntArrMessage2  As Variant          'メッセージ２
    
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    '挿入処理に際し、引数値を配列形式に変換
    If Not IsArray(vntMessage1) Then
        vntArrMessage1 = Array(vntMessage1)
        vntArrMessage2 = Array(vntMessage2)
    Else
        vntArrMessage1 = vntMessage1
        vntArrMessage2 = vntMessage2
    End If
    
    'キー及び更新値の設定
    Set objOraParam = objOraDb.Parameters
    objOraParam.Add "TRANSACTIONID", lngTransactionId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TRANSACTIONDIV", strTransactionDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INFORMATIONDIV", strInformationDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LINENO", strLineNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RET", "", ORAPARM_OUTPUT, ORATYPE_NUMBER

    'パラメータの参照設定
    Set objMessage1 = objOraParam("MESSAGE1")
    Set objMessage2 = objOraParam("MESSAGE2")
    objMessage1.MinimumSize = 150
    objMessage2.MinimumSize = 150

    'ログレコード挿入用のSQLステートメント作成
    If blnNewTransaction Then
        strStmt = "BEGIN :RET := PutHainsLog(:TRANSACTIONID, :TRANSACTIONDIV, :INFORMATIONDIV, :LINENO, :MESSAGE1, :MESSAGE2); END;"
    Else
        strStmt = "INSERT INTO HAINSLOG (                            " & vbLf & _
                  "                TRANSACTIONID,                    " & vbLf & _
                  "                INSDATE,                          " & vbLf & _
                  "                TRANSACTIONDIV,                   " & vbLf & _
                  "                INFORMATIONDIV,                   " & vbLf & _
                  "                STATEMENTNO,                      " & vbLf & _
                  "                LINENO,                           " & vbLf & _
                  "                MESSAGE1,                         " & vbLf & _
                  "                MESSAGE2                          " & vbLf & _
                  "            ) VALUES (                            " & vbLf & _
                  "                :TRANSACTIONID,                   " & vbLf & _
                  "                SYSDATE,                          " & vbLf & _
                  "                :TRANSACTIONDIV,                  " & vbLf & _
                  "                :INFORMATIONDIV,                  " & vbLf & _
                  "                HAINSLOG_STATEMENTNO_SEQ.NEXTVAL, " & vbLf & _
                  "                :LINENO,                          " & vbLf & _
                  "                :MESSAGE1,                        " & vbLf & _
                  "                :MESSAGE2                         " & vbLf & _
                  "            )                                     "
    End If
    
    '各配列値の挿入処理
    For i = 0 To UBound(vntArrMessage1)

        '配列値の編集
        objMessage1.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage1(i), vbFromUnicode), 150), vbUnicode))
        objMessage2.Value = CStr(StrConv(LeftB(StrConv(vntArrMessage2(i), vbFromUnicode), 150), vbUnicode))

        '挿入SQL文の実行
        If objOraSqlStmt Is Nothing Then
            Set objOraSqlStmt = objOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSqlStmt.Refresh
        End If
    Next i

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    PutHainsLog = INSERT_NORMAL

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    PutHainsLog = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "PaymentAuto.PutHainsLog"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : ＣＳＶデータを配列化し、かつ項目名および項目長定義の配列を返す
'
' 引数　　 : (In)     strCsvStream     ＣＳＶデータ
' 　　　　   (In)     lngMaxArraySize  配列の最大サイズ
' 　　　　   (Out)    vntColumns       カラム値
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub SetColumnsArrayFromCsvString(ByRef strCsvStream As String, ByRef lngMaxArraySize As Long, ByRef vntColumns As Variant)

    Dim vntArrColumns   As Variant  '各カラムの集合

    Dim i               As Long     'インデックス
    
    '初期処理
    vntColumns = Empty
    
    'カンマ分離
    vntArrColumns = Split(strCsvStream, ",")

    '配列のサイズ調整
    ReDim Preserve vntArrColumns(lngMaxArraySize)
    
    'カラム値の検索
    For i = LBound(vntArrColumns) To UBound(vntArrColumns)
    
        '先端のダブルクォーテーションを除外
        If Left(vntArrColumns(i), 1) = """" Then
            vntArrColumns(i) = Right(vntArrColumns(i), Len(vntArrColumns(i)) - 1)
        End If
        
        '終端のダブルクォーテーションを除外
        If Right(vntArrColumns(i), 1) = """" Then
            vntArrColumns(i) = Left(vntArrColumns(i), Len(vntArrColumns(i)) - 1)
        End If
        
        '値のトリミング
        vntArrColumns(i) = Trim(vntArrColumns(i))
    
    Next i
    
    '戻り値の設定
    vntColumns = vntArrColumns
    
End Sub

'
' 機能　　 : 姓名の分割
'
' 引数　　 : (In)    strName       姓名
' 　　　　   (Out)   strLastName   姓
' 　　　　   (Out)   strFirstName  名
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub SplitName(ByVal strName As String, ByRef strLastName As String, ByRef strFirstName As String)

    Dim lngPtr  As Long '最初に空白が発生した位置
    
    '初期処理
    strLastName = ""
    strFirstName = ""

    strName = Trim(strName)
    If strName = "" Then
        Exit Sub
    End If

    '全角変換
    strName = StrConv(strName, vbWide)

    '全角空白を検索
    lngPtr = InStr(strName, "　")

    '全角空白が存在しない場合
    If lngPtr <= 0 Then
        strLastName = strName
        Exit Sub
    End If

    '全角空白が存在する場合
    strLastName = Trim(Left(strName, lngPtr - 1))
    strFirstName = Trim(Right(strName, Len(strName) - lngPtr))

End Sub


'
' 機能　　 : 団体コードの分割
'
' 引数　　 : (In)    strOrgcd      団体コード（XXXXX-XXXXX）
' 　　　　   (Out)   strOrgcd1     団体コード１
' 　　　　   (Out)   strOrgcd2     団体コード２
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub SplitOrgcd(ByVal strOrgCd As String, ByRef strOrgCd1 As String, ByRef strOrgCd2 As String)

    Dim lngPtr  As Long '最初に"-"が発生した位置
    
    '初期処理
    strOrgCd1 = ""
    strOrgCd2 = ""

    strOrgCd = Trim(strOrgCd)
    If strOrgCd = "" Then
        Exit Sub
    End If

    '全角変換
    strOrgCd = StrConv(strOrgCd, vbNarrow)

    '半角"-"を検索
    lngPtr = InStr(strOrgCd, "-")

    '半角"-"が存在しない場合
    If lngPtr <= 0 Then
        strOrgCd1 = strOrgCd
        Exit Sub
    End If

    '半角"-"が存在する場合
    strOrgCd1 = Trim(Left(strOrgCd, lngPtr - 1))
    strOrgCd2 = Trim(Right(strOrgCd, Len(strOrgCd) - lngPtr))

End Sub

