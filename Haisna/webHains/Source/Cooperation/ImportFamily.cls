VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ImportFamily"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const TRANSACTIONDIV_ISRFLM As String = "LOGISRFML" '健保家族情報取り込み用のログ処理ＩＤ

Private Const INDEX_ISRSIGN         As Long = 0             '健保記号
Private Const INDEX_ISRNO           As Long = 1             '健保番号
Private Const INDEX_RELATIONCD      As Long = 2             '続柄
Private Const INDEX_BRANCHNO        As Long = 3             '枝番
Private Const INDEX_RELATIONNAME    As Long = 4             '続柄名称
Private Const INDEX_NAME            As Long = 5             '漢字氏名
Private Const INDEX_KNAME           As Long = 6             'カナ氏名
Private Const INDEX_GENDER          As Long = 7             '性別
Private Const INDEX_BIRTH           As Long = 8             '生年月日
Private Const INDEX_GETDATE         As Long = 9             '取得日

Private Const LENGTH_ISRSIGN        As Long = 4             '健保記号
Private Const LENGTH_ISRNO          As Long = 8             '健保番号
Private Const LENGTH_RELATIONCD     As Long = 2             '続柄
Private Const LENGTH_BRANCHNO       As Long = 2             '枝番
Private Const LENGTH_RELATIONNAME   As Long = 10            '続柄名称
Private Const LENGTH_NAME           As Long = 32            '漢字氏名
Private Const LENGTH_KNAME          As Long = 32            'カナ氏名
Private Const LENGTH_GENDER         As Long = 0             '性別
Private Const LENGTH_BIRTH          As Long = 0             '生年月日
Private Const LENGTH_GETDATE        As Long = 0             '取得日

Private Const NAME_ISRSIGN          As String = "健保記号"  '健保記号
Private Const NAME_ISRNO            As String = "健保番号"  '健保番号
Private Const NAME_RELATIONCD       As String = "続柄"      '続柄
Private Const NAME_BRANCHNO         As String = "枝番"      '枝番
Private Const NAME_RELATIONNAME     As String = "続柄名称"  '続柄名称
Private Const NAME_NAME             As String = "漢字氏名"  '漢字氏名
Private Const NAME_KNAME            As String = "カナ氏名"  'カナ氏名
Private Const NAME_GENDER           As String = "性別"      '性別
Private Const NAME_BIRTH            As String = "生年月日"  '生年月日
Private Const NAME_GETDATE          As String = "取得日"    '取得日

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
Private Sub CheckColumnValue(ByRef vntNames As Variant, ByRef vntColumns As Variant, ByRef vntLengths As Variant, ByRef vntMessage1 As Variant, ByRef vntMessage2 As Variant)

    Dim objCommon       As Object   '共通クラス
    
    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    
    Dim strMessage1     As String   'メッセージ１
    Dim strMessage2     As String   'メッセージ２
    
    Dim strLastName     As String   '姓
    Dim strFirstName    As String   '名
    Dim strTel          As String   '電話番号
    Dim vntTel          As Variant  '電話番号
    Dim vntZipCd        As Variant  '郵便番号

    Dim blnTooLong      As Boolean  '項目長が長すぎる場合にTrue
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
'## 2003.04.23 Add 1Line By T.Takagi@FSIT ログ修正
    Dim strMessage      As String   'メッセージ
'## 2003.04.23 Add End
    
    'オブジェクトのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
'## 2003.04.23 Add 3Lines By T.Takagi@FSIT ログ修正
    strMessage = "健保記号=" & IIf(vntColumns(INDEX_ISRSIGN) <> "", vntColumns(INDEX_ISRSIGN), "なし")
    strMessage = strMessage & "、健保番号=" & IIf(vntColumns(INDEX_ISRNO) <> "", vntColumns(INDEX_ISRNO), "なし")
    strMessage = strMessage & "、氏名=" & IIf(vntColumns(INDEX_NAME) <> "", vntColumns(INDEX_NAME), "なし")
'## 2003.04.23 Add End
    
    '項目単位のチェック
    For i = LBound(vntNames) To UBound(vntNames)
    
        '必須項目のチェック
        Select Case i
        
            '健保記号、健保番号、続柄、枝番、漢字氏名、カナ氏名、性別、生年月日は必須チェックを行う
            Case INDEX_ISRSIGN, INDEX_ISRNO, INDEX_RELATIONCD, INDEX_BRANCHNO, INDEX_NAME, INDEX_KNAME, INDEX_GENDER, INDEX_BIRTH
                
                If vntColumns(i) = "" Then
'## 2003.04.23 Mod 2Lines By T.Takagi@FSIT ログ修正
'                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。"
                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。", strMessage
'## 2003.04.23 Mod End
                End If
            
        End Select
            
        '項目値が存在する場合のチェック処理
        Do
        
            ''項目値が存在しなければ制御を抜ける
            If vntColumns(i) = "" Then
                Exit Do
            End If
        
            blnTooLong = False
            
            '基本メッセージの作成
            strMessage1 = vntNames(i) & "の値が長すぎます。"
'## 2003.04.23 Mod 2Lines By T.Takagi@FSIT ログ修正
'            strMessage2 = vntNames(i) & "=" & vntColumns(i)
            strMessage2 = strMessage & "、" & vntNames(i) & "=" & vntColumns(i)
'## 2003.04.23 Mod End
            
            '項目長のチェック
            Select Case i
            
                '続柄名称、取得日は未使用のためチェック非対象
                Case INDEX_RELATIONNAME, INDEX_GETDATE
            
                '枝番は数値形式のため以降のチェックを行う
                Case INDEX_BRANCHNO
                
                '生年月日は日付形式のため以降のチェックを行う
                Case INDEX_BIRTH
            
                '性別は以降の独自チェックを行う
                Case INDEX_GENDER
            
                '姓名、カナ姓名は全角変換かつ空白分離後の値でチェックを行う
                Case INDEX_NAME, INDEX_KNAME
            
                    '姓名に分割
                    SplitName vntColumns(i), strLastName, strFirstName
            
                    If LenB(StrConv(strLastName, vbFromUnicode)) > vntLengths(i) Or LenB(StrConv(strFirstName, vbFromUnicode)) > vntLengths(i) Then
'## 2003.04.23 Mod 6Lines By T.Takagi@FSIT ログ修正
'                        AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage2
                        If i = INDEX_NAME Then
                            AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage
                        Else
                            AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage2
                        End If
'## 2003.04.23 Mod End
                        blnTooLong = True
                    End If
        
                'それ以外の通常の項目長チェック
                Case Else
            
                    If LenB(StrConv(vntColumns(i), vbFromUnicode)) > vntLengths(i) Then
'## 2003.04.23 Mod 6Lines By T.Takagi@FSIT ログ修正
'                        AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage2
                        If i = INDEX_ISRSIGN Or i = INDEX_ISRNO Then
                            AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage
                        Else
                            AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage2
                        End If
'## 2003.04.23 Mod End
                        blnTooLong = True
                    End If
            
            End Select
            
            '項目長エラー時は処理を抜ける
            If blnTooLong Then
                Exit Do
            End If
            
            '基本メッセージの作成
            strMessage1 = vntNames(i) & "が無効です。"
            
            '項目タイプごとのチェック
            Select Case i
            
                '枝番の場合は数値チェックを行う
                Case INDEX_BRANCHNO
                
                    If Not CheckNumber2(vntColumns(i), LENGTH_BRANCHNO) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage2
                    End If
                
                'カナ姓名の場合はカナ文字チェックを行う
                Case INDEX_KNAME
            
                    If Not objCommon.CheckKana(vntColumns(i)) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "に不正な文字が含まれます。", strMessage2
                    End If
                    
                '性別は"男"、"女"しか許さない
                Case INDEX_GENDER
                
                    If Not CheckIntoValue(vntColumns(i), Array("男", "女")) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strMessage1, strMessage2
                    End If
                    
                '生年月日については日付チェックを行う
                Case INDEX_BIRTH
                    
                    If Not CheckDate(vntColumns(i)) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が日付として認識できません。", strMessage2
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
' 引数　　 : (In)     strCsvStream  ＣＳＶデータ
' 　　　　   (In)     vntNames      項目名の配列
' 　　　　   (In)     vntLengths    項目長の配列
' 　　　　   (Out)    udtPerson     個人情報レコード
' 　　　　   (Out)    vntMessage1   メッセージ１
' 　　　　   (Out)    vntMessage2   メッセージ２
'
' 戻り値　 : True   エラーなし
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Private Function CheckCsv(ByVal strCsvStream As String, ByRef vntNames As Variant, ByRef vntLengths As Variant, ByRef udtPerson As PERSON_INF, ByRef vntMessage1 As Variant, ByRef vntMessage2 As Variant) As Boolean

    Dim vntColumns      As Variant  '各カラムの集合
    
    Dim vntPerName      As Variant  '氏名
    Dim strTel          As String   '電話番号
    Dim vntTel          As Variant  '電話番号
    Dim vntZipCd        As Variant  '郵便番号
    
    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    Dim strMessage      As String   'メッセージ
    
    '初期処理
    Initialize udtPerson
    vntMessage1 = Empty
    vntMessage2 = Empty
    
    Do
    
        'レコードが存在しない場合はエラー
        If strCsvStream = "" Then
            AppendMessage vntArrMessage1, vntArrMessage2, "取り込みデータが存在しません。"
            Exit Do
        End If
    
        'レコード値の配列化
        SetColumnsArrayFromCsvString strCsvStream, INDEX_GETDATE, vntColumns
    
        'CSVデータの項目値チェック
        CheckColumnValue vntNames, vntColumns, vntLengths, vntArrMessage1, vntArrMessage2
        
        If Not IsEmpty(vntArrMessage1) Then
            Exit Do
        End If
        
        '戻り値の設定
        With udtPerson
            
            '健保記号、健保番号
            .IsrSign = vntColumns(INDEX_ISRSIGN)
            .IsrNo = vntColumns(INDEX_ISRNO)

            '続柄、枝番
            .RelationCd = vntColumns(INDEX_RELATIONCD)
            .BranchNo = vntColumns(INDEX_BRANCHNO)
            
            '姓名、カナ姓名
            SplitName vntColumns(INDEX_NAME), .LastName, .FirstName
            SplitName vntColumns(INDEX_KNAME), .LastKName, .FirstKName
            
            '性別
            .Gender = IIf(vntColumns(INDEX_GENDER) = "男", 1, 2)
            
            '生年月日
            .Birth = IIf(Not IsDate(vntColumns(INDEX_BIRTH)), Format(vntColumns(INDEX_BIRTH), "0000/00/00"), vntColumns(INDEX_BIRTH))
            
        End With
        
        CheckCsv = True
        
        Exit Do
    Loop
    
    'メッセージの編集
    vntMessage1 = vntArrMessage1
    vntMessage2 = vntArrMessage2
    
End Function

'
' 機能　　 : 健保家族情報の取り込み
'
' 引数　　 : (In)     strFileName      ファイル名
' 　　　　   (In)     strUserId        ユーザＩＤ
' 　　　　   (In)     blnSkipFirstRow  True指定時、先頭行を見出し行とみなしてスキップする
'
' 戻り値　 :
'
' 備考　　 :
'
'## 2003.02.07 Mod 2Lines By T.Takagi@FSIT 先頭行スキップ機能追加
'Public Sub ImportIsrFamily(ByVal strFileName As String, Optional ByVal strUserId As String = "")
Public Sub ImportIsrFamily(ByVal strFileName As String, Optional ByVal strUserId As String = "", Optional ByVal blnSkipFirstRow As Boolean = True)
'## 2003.02.07 Mod End

    Dim objFso              As Object       'ファイルシステムオブジェクト
    Dim objHainsLog         As Object       'ログ情報アクセス用
    Dim objRegistPerson     As RegistPerson '個人情報登録用
    
    Dim lngTransactionId    As Long         'トランザクションＩＤ
    
    Dim vntNames            As Variant      '項目名の配列
    Dim vntLengths          As Variant      '項目長の配列
    
    Dim intFileNo           As Integer      'ファイル番号
    Dim strBuffer           As String       '文字列バッファ
    
    Dim lngLineNo           As Long         '行番号
    
    Dim udtPerson           As PERSON_INF   '個人情報レコード

    Dim vntPerId            As Variant      '個人ＩＤ
    Dim vntLastName         As Variant      '姓
    Dim vntFirstName        As Variant      '名
    Dim vntLastKName        As Variant      'カナ姓
    Dim vntFirstKName       As Variant      'カナ名
    Dim vntBirth            As Variant      '生年月日
    Dim vntGender           As Variant      '性別
    Dim vntTel1             As Variant      '電話番号１－市外局番
    Dim vntTel2             As Variant      '電話番号１－局番
    Dim vntTel3             As Variant      '電話番号１－番号
    Dim vntZipCd1           As Variant      '郵便番号１
    Dim vntZipCd2           As Variant      '郵便番号２
    Dim vntPrefCd           As Variant      '都道府県コード
    Dim vntCityName         As Variant      '市区町村名
    Dim vntAddress1         As Variant      '住所１
    Dim vntAddress2         As Variant      '住所２

    Dim lngReadCount        As Long         '読み込みレコード数
    Dim lngPerCount         As Long         '作成／更新個人情報数
    
    Dim vntMessage1         As Variant      'メッセージ１
    Dim vntMessage2         As Variant      'メッセージ２
    Dim strMessage1         As String       'メッセージ１
    Dim strMessage2         As String       'メッセージ２
    Dim strInformationDiv   As String       '情報区分
    Dim Ret                 As Boolean      '関数戻り値
'## 2003.04.04 Add 1Line By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
    Dim Ret2                As Long         '関数戻り値
'## 2003.04.04 Add End
    
'## 2003.04.23 Add 3Lines By T.Takagi@FSIT ログ修正
    Dim i                   As Long         'インデックス
'## 2003.04.23 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFso = CreateObject("Scripting.FileSystemObject")
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    Set objRegistPerson = CreateObject("HainsCooperation.RegistPerson")
    
    'トランザクションＩＤ・区分・表題の取得
    lngTransactionId = objHainsLog.IncreaseTransactionId()
    
    '項目名の配列を作成
    vntNames = Array(NAME_ISRSIGN, NAME_ISRNO, NAME_RELATIONCD, NAME_BRANCHNO, NAME_RELATIONNAME, NAME_NAME, NAME_KNAME, NAME_GENDER, NAME_BIRTH, NAME_GETDATE)
    
    '項目長の配列を作成
    vntLengths = Array(LENGTH_ISRSIGN, LENGTH_ISRNO, LENGTH_RELATIONCD, LENGTH_BRANCHNO, LENGTH_RELATIONNAME, LENGTH_NAME, LENGTH_KNAME, LENGTH_GENDER, LENGTH_BIRTH, LENGTH_GETDATE)
    
    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "I", "", "健保家族データ取り込み処理を開始します。", ""
    
    Do
    
        'ファイルが存在しない場合は処理を終了する
        If objFso.FileExists(strFileName) = False Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "E", "", "ファイルが存在しません。", "ファイル名=" & strFileName
            Exit Do
        End If
    
        'ファイルオープン
        intFileNo = FreeFile()
        Open strFileName For Input Lock Read Write As #intFileNo
    
'## 2003.02.07 Add 3Lines By T.Takagi@FSIT 先頭行スキップ機能追加
        If Not EOF(intFileNo) And blnSkipFirstRow = True Then
            Line Input #intFileNo, strBuffer
        End If
'## 2003.02.07 Add End
    
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
                
                'CSVデータのチェック
                Ret = CheckCsv(strBuffer, vntNames, vntLengths, udtPerson, vntMessage1, vntMessage2)
    
                'エラー時はログを発行し、次レコードへ
                If Ret = False Then
                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "E", lngLineNo, vntMessage1, vntMessage2
                    Exit Do
                End If
    
                '健保記号・健保番号・続柄・枝番をキーに個人情報の有無を検索する
                With udtPerson
'## 2003.04.04 Mod 2Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
'                    Ret = objRegistPerson.SelectPersonFromIsr(.IsrSign, .IsrNo, .RelationCd, .BranchNo, vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender)
                    Ret2 = objRegistPerson.SelectPersonFromIsr(.IsrSign, .IsrNo, .RelationCd, .BranchNo, vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender)
'## 2003.04.04 Mod End
                End With
                
'## 2003.04.04 Add 9Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
                'レコードが複数存在する場合はログを発行して次レコードへ
                If Ret2 = 0 Then
                    strMessage2 = "健保記号=" & udtPerson.IsrSign
                    strMessage2 = strMessage2 & "、健保番号=" & udtPerson.IsrNo
                    strMessage2 = strMessage2 & "、続柄=" & udtPerson.RelationCd
                    strMessage2 = strMessage2 & "、枝番=" & udtPerson.BranchNo
                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "E", lngLineNo, "この健保記号、番号、続柄、枝番を持つ個人情報が複数存在します。", strMessage2
                    Exit Do
                End If
'## 2003.04.04 Add End
                
                'レコード存在時
'## 2003.04.04 Mod 2Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
'                If Ret = True Then
                If Ret2 > 0 Then
'## 2003.04.04 Mod End
        
                    'CSVデータの生年月日、性別と個人情報の各値とを比較し、エラー時はログを発行して次レコードへ
                    ComparePerson udtPerson, vntBirth, vntGender, vntPerId, vntLastName, vntFirstName, vntMessage1, vntMessage2
                    If Not IsEmpty(vntMessage1) Then
'## 2003.04.23 Add 3Lines By T.Takagi@FSIT ログ修正
                        For i = 0 To UBound(vntMessage1)
                            vntMessage2(i) = "健保記号=" & udtPerson.IsrSign & "、健保番号=" & udtPerson.IsrNo & "、" & vntMessage2(i)
                        Next i
'## 2003.04.23 Add End
                        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "E", lngLineNo, vntMessage1, vntMessage2
                        Exit Do
                    End If
                        
                    'CSVデータの姓名と個人情報とのそれとを比較し、エラー時は警告ログを発行する
                    CompareName udtPerson, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntMessage1, vntMessage2
                    If Not IsEmpty(vntMessage1) Then
'## 2003.04.23 Add 3Lines By T.Takagi@FSIT ログ修正
                        For i = 0 To UBound(vntMessage1)
                            vntMessage2(i) = "健保記号=" & udtPerson.IsrSign & "、健保番号=" & udtPerson.IsrNo & "、" & vntMessage2(i)
                        Next i
'## 2003.04.23 Add End
                        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "W", lngLineNo, vntMessage1, vntMessage2
                    End If
                        
                End If
    
                '健保記号・健保番号・続柄・枝番をキーに本人個人属性情報を取得
                With udtPerson
'## 2003.04.04 Mod 2Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
'                    Ret = objRegistPerson.SelectPersonFromIsr(.IsrSign, .IsrNo, RELATIONCD_SELF, BRANCHNO_SELF, , , , , , , , vntTel1, vntTel2, vntTel3, vntZipCd1, vntZipCd2, vntPrefCd, vntCityName, vntAddress1, vntAddress2)
                    Ret2 = objRegistPerson.SelectPersonFromIsr(.IsrSign, .IsrNo, RELATIONCD_SELF, BRANCHNO_SELF, , , , , , , , vntTel1, vntTel2, vntTel3, vntZipCd1, vntZipCd2, vntPrefCd, vntCityName, vntAddress1, vntAddress2)
'## 2003.04.04 Mod End
                End With
    
'## 2003.04.04 Add 9Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
                'レコードが複数存在する場合はワーニング
                If Ret2 = 0 Then
                    strMessage2 = "健保記号=" & udtPerson.IsrSign
                    strMessage2 = strMessage2 & "、健保番号=" & udtPerson.IsrNo
                    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "W", lngLineNo, "この健保記号、番号を持つ健保本人情報が複数存在します。住所情報は更新されません。", strMessage2
                End If
'## 2003.04.04 Add End
    
                '個人情報の登録
                With udtPerson
                    Ret = objRegistPerson.RegistPerson( _
                              vntPerId, _
                              .LastName, .FirstName, _
                              .LastKName, .FirstKName, _
                              .Birth, .Gender, _
                              strUserId, _
                              .IsrSign, .IsrNo, _
                              .RelationCd, .BranchNo, _
                              vntTel1, vntTel2, vntTel3, _
                              vntZipCd1, vntZipCd2, _
                              vntPrefCd, vntCityName, _
                              vntAddress1, vntAddress2, _
                              strMessage1, strMessage2 _
                          )
                End With
                
                'ログ発行
                strInformationDiv = IIf(Ret = True, "I", "E")
                PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, strInformationDiv, lngLineNo, strMessage1, strMessage2
    
                'エラー時は次レコードへ
                If Ret = False Then
                    Exit Do
                End If
    
                '作成／更新個人情報数のインクリメント
                lngPerCount = lngPerCount + 1
    
                Exit Do
            Loop
        
        Loop
        
        'ファイルクローズ
        Close #intFileNo
        
        Exit Do
    Loop

    'ログ発行
    strMessage2 = "読み込まれた個人情報数=" & lngReadCount
    strMessage2 = strMessage2 & "、作成された受診情報数=" & lngPerCount
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "I", "", "以下の件数の受診情報が処理されました。", strMessage2

    '終了ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_ISRFLM, "I", "", "健保家族データ取り込み処理を終了します。", ""

    Exit Sub
    
ErrorHandle:

    'ファイルクローズ
    Close #intFileNo

    'イベントログ書き込み
    WriteErrorLog "ImportFamily.ImportIsrFamily"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
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

