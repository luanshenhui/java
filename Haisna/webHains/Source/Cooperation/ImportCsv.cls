VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ImportCsv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession      As OraSession       'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase      'OraDatabaseオブジェクト

Private mvntPrefCd          As Variant          '都道府県コード
Private mvntPrefName        As Variant          '都道府県名

Private mvntCslDivCd        As Variant          '受診区分コード
Private mvntCslDivName      As Variant          '受診区分名

Private mvntSetClassCd      As Variant          'セット分類コード
Private mvntSetClassName    As Variant          'セット分類名

'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
Private mvntRsvGrpCd        As Variant          '予約群コード
Private mvntRsvGrpName      As Variant          '予約群名

Private mvntCourseRsvGrpCd      As Variant      'コース内予約群コード
Private mvntCourseRsvGrpName    As Variant      'コース内予約群名
'## 2004.10.04 Add End

Private Const TRANSACTIONDIV_RSVCSV As String = "LOGRSVCSV"         'ＣＳＶ一括予約用のログ処理ＩＤ

'項目位置情報
Private Const INDEX_CSLDATE1        As Long = 0                     '受診希望日１
Private Const INDEX_CSLDATE2        As Long = 1                     '受診希望日２
Private Const INDEX_CSLDATE3        As Long = 2                     '受診希望日３
'## 2004.10.04 Mod By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加、予約群を第３受診希望日と漢字氏名の間に追加
'Private Const INDEX_NAME            As Long = 3                     '姓名
'Private Const INDEX_KNAME           As Long = 4                     'カナ姓名
'Private Const INDEX_BIRTH           As Long = 5                     '生年月日
'Private Const INDEX_GENDER          As Long = 6                     '性別
'Private Const INDEX_CSLDIVCD        As Long = 7                     '受診区分コード
'Private Const INDEX_PERID           As Long = 8                     '個人ＩＤ
'Private Const INDEX_ZIPCD           As Long = 9                     '郵便番号
'Private Const INDEX_TEL             As Long = 10                    '電話番号
'Private Const INDEX_ADDRESS         As Long = 11                    '住所
'Private Const INDEX_EMPNO           As Long = 12                    '従業員番号（または保険証番号）
'Private Const INDEX_SETCLASSCD      As Long = 13                    'セット分類コード
Private Const INDEX_RSVGRPCD        As Long = 3                     '予約群コード
Private Const INDEX_NAME            As Long = 4                     '姓名
Private Const INDEX_KNAME           As Long = 5                     'カナ姓名
Private Const INDEX_ROMENAME        As Long = 6                     'ローマ字名
Private Const INDEX_BIRTH           As Long = 7                     '生年月日
Private Const INDEX_GENDER          As Long = 8                     '性別
Private Const INDEX_CSLDIVCD        As Long = 9                     '受診区分コード
Private Const INDEX_PERID           As Long = 10                    '個人ＩＤ
Private Const INDEX_ZIPCD           As Long = 11                    '郵便番号
Private Const INDEX_TEL             As Long = 12                    '電話番号
Private Const INDEX_ADDRESS         As Long = 13                    '住所
Private Const INDEX_EMPNO           As Long = 14                    '従業員番号（または保険証番号）
Private Const INDEX_SETCLASSCD      As Long = 15                    'セット分類コード
'## 2004.10.04 Mod End

'項目長情報
Private Const LENGTH_CSLDATE1       As Long = 0                     '受診希望日１
Private Const LENGTH_CSLDATE2       As Long = 0                     '受診希望日２
Private Const LENGTH_CSLDATE3       As Long = 0                     '受診希望日３
'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
Private Const LENGTH_RSVGRPCD       As Long = 3                     '予約群コード
'## 2004.10.04 Add End
Private Const LENGTH_NAME           As Long = 50                    '姓名
Private Const LENGTH_KNAME          As Long = 50                    'カナ姓名
'## 2004.10.04 Add By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加
Private Const LENGTH_ROMENAME       As Long = 60                    'ローマ字名
'## 2004.10.04 Add End
Private Const LENGTH_BIRTH          As Long = 0                     '生年月日
Private Const LENGTH_GENDER         As Long = 0                     '性別
Private Const LENGTH_CSLDIVCD       As Long = 12                    '受診区分コード
Private Const LENGTH_PERID          As Long = 12                    '個人ＩＤ
Private Const LENGTH_ZIPCD          As Long = 7                     '郵便番号
Private Const LENGTH_TEL            As Long = 15                    '電話番号
Private Const LENGTH_ADDRESS        As Long = 60                    '住所
Private Const LENGTH_EMPNO          As Long = 12                    '従業員番号
Private Const LENGTH_ISRNO          As Long = 16                    '保険証番号
Private Const LENGTH_SETCLASSCD     As Long = 3                     'セット分類コード

'項目名情報
Private Const NAME_CSLDATE          As String = "受診希望日"        '受診希望日
Private Const NAME_CSLDATE1         As String = "第１受診希望日"    '受診希望日１
Private Const NAME_CSLDATE2         As String = "第２受診希望日"    '受診希望日２
Private Const NAME_CSLDATE3         As String = "第３受診希望日"    '受診希望日３
'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
Private Const NAME_RSVGRPCD         As String = "予約群"            '予約群コード
'## 2004.10.04 Add End
Private Const NAME_NAME             As String = "漢字名"            '姓名
Private Const NAME_KNAME            As String = "カナ名"            'カナ姓名
'## 2004.10.04 Add By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加
Private Const NAME_ROMENAME         As String = "ローマ字氏名"      'ローマ字名
'## 2004.10.04 Add End
Private Const NAME_BIRTH            As String = "生年月日"          '生年月日
Private Const NAME_GENDER           As String = "性別"              '性別
Private Const NAME_CSLDIVCD         As String = "受診区分"          '受診区分コード
Private Const NAME_PERID            As String = "患者ＩＤ"          '個人ＩＤ
Private Const NAME_ZIPCD            As String = "郵便番号"          '郵便番号
Private Const NAME_TEL              As String = "電話番号"          '電話番号
Private Const NAME_ADDRESS          As String = "住所"              '住所
Private Const NAME_EMPNO            As String = "従業員番号"        '従業員番号
Private Const NAME_ISRNO            As String = "保険証番号"        '保険証番号
Private Const NAME_SETCLASSCD       As String = "セット分類コード"  'セット分類コード

Private Const CSLDATE_MAXCOUNT      As Long = 3                     '指定可能な受診希望日の最大数
'Private Const SETCLASSCD_MAXCOUNT   As Long = 20                    '指定可能なセット分類コードの最大数

'
' 機能　　 : 配列に格納されたＣＳＶデータのチェックを行う
'
' 引数　　 : (In)     lngNoDiv     番号選択(1:従業員番号、2:保険証番号)
' 　　　　   (In)     vntNames     項目名
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
    ByRef lngNoDiv As Long, _
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
    
    Dim strLastName     As String   '姓
    Dim strFirstName    As String   '名
    
    Dim strPrefCd       As String   '都道府県コード
    Dim strCityName     As String   '市区町村コード
    Dim strAddress1     As String   '住所１
    Dim strAddress2     As String   '住所２
    
    Dim vntZipCd        As Variant  '郵便番号
    
    Dim blnTooLong      As Boolean  '項目長が長すぎる場合にTrue
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    Dim lngNameIndex    As Long     '項目名情報のインデックス
    Dim strMessage      As String   'メッセージ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '基本メッセージの作成(患者ＩＤと姓名をもって基本メッセージとする)
    strMessage = ""
    strMessage = strMessage & NAME_PERID & "=" & IIf(vntColumns(INDEX_PERID) <> "", vntColumns(INDEX_PERID), "なし")
    strMessage = strMessage & "、"
    strMessage = strMessage & NAME_NAME & "=" & IIf(vntColumns(INDEX_NAME) <> "", vntColumns(INDEX_NAME), "なし")
    
    '項目単位のチェック
    For i = LBound(vntColumns) To UBound(vntColumns)
    
        'セット分類に注意しつつ、現在チェック対象である項目の、項目名情報におけるインデックスを定義
        lngNameIndex = IIf(i >= INDEX_SETCLASSCD, INDEX_SETCLASSCD, i)
    
        '必須項目のチェック
        Select Case i
        
            '姓名、カナ姓名、生年月日、性別、受診区分コードは必須チェックを行う
            Case INDEX_NAME, INDEX_KNAME, INDEX_BIRTH, INDEX_GENDER, INDEX_CSLDIVCD

                If vntColumns(i) = "" Then
                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。", strMessage
                End If
            
            '受診希望日の場合は複合チェックを行う
'## 2004.10.04 Mod By T.Takagi@FSIT たまたまインデックス値が一緒なために動作していたことが発覚
'            Case LENGTH_CSLDATE1
            Case INDEX_CSLDATE1
'## 2004.10.04 Mod End
            
                If vntColumns(INDEX_CSLDATE1) = "" And vntColumns(INDEX_CSLDATE2) = "" And vntColumns(INDEX_CSLDATE3) = "" Then
                    AppendMessage vntArrMessage1, vntArrMessage2, NAME_CSLDATE & "が設定されていません。", strMessage
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
            
                '受診希望日１、２、３、生年月日については日付形式のため以降のチェックを行う
                Case INDEX_CSLDATE1, INDEX_CSLDATE2, INDEX_CSLDATE3, INDEX_BIRTH
            
                '姓名、カナ姓名は全角変換かつ空白分離後の値でチェックを行う
                Case INDEX_NAME, INDEX_KNAME
            
                    '姓名に分割
                    SplitName vntColumns(i), strLastName, strFirstName
            
                    If LenB(StrConv(strLastName, vbFromUnicode)) > vntLengths(i) Or LenB(StrConv(strFirstName, vbFromUnicode)) > vntLengths(i) Then
                        If i = INDEX_NAME Then
                            AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strMessage
                        Else
                            AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        End If
                        blnTooLong = True
                    End If
            
                '住所は最大項目長分割後の値でチェック
                Case INDEX_ADDRESS

                    '住所の分割
                    SplitAddress vntColumns(i), strPrefCd, strCityName, strAddress1, strAddress2
                
                    '都道府県コードはさておき、市区町村名、住所１は必ず項目長内に収まるよう分割される。よってここでは住所２の項目長チェックを行えばよい。
                    If LenB(StrConv(strAddress2, vbFromUnicode)) > vntLengths(i) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        blnTooLong = True
                    End If
                
                'セット分類の開始位置以降の場合、すべてセット分類とみなしてチェック
                Case Is >= INDEX_SETCLASSCD
                
                    If LenB(StrConv(vntColumns(i), vbFromUnicode)) > vntLengths(INDEX_SETCLASSCD) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        blnTooLong = True
                    End If
                
                '性別、郵便番号は以降の独自チェックを行う
                Case INDEX_GENDER, INDEX_ZIPCD
            
                '個人ＩＤの場合
                Case INDEX_PERID

                    'ゼロトリミングした状態で項目長チェックを行う
                    If LenB(StrConv(LTrimZero(vntColumns(i)), vbFromUnicode)) > vntLengths(i) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strMessage
                        blnTooLong = True
                    End If

'## 2004.10.04 Add By T.Takagi@FSIT 予約群を追加
                '予約群は以降の独自チェックを行う
                Case INDEX_RSVGRPCD
'## 2004.10.04 Add End

                'それ以外の通常の項目長チェック
                Case Else
            
                    If LenB(StrConv(vntColumns(i), vbFromUnicode)) > vntLengths(i) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        blnTooLong = True
                    End If
            
            End Select
            
            '項目長エラー時は処理を抜ける
            If blnTooLong Then
                Exit Do
            End If
            
            '基本メッセージの作成
            strStdMessage1 = vntNames(lngNameIndex) & "が無効です。"
            
            '項目タイプごとのチェック
            Select Case i
            
                '受診希望日１、２、３、生年月日については日付チェックを行う
                Case INDEX_CSLDATE1, INDEX_CSLDATE2, INDEX_CSLDATE3, INDEX_BIRTH
                    
                    If CnvDate(vntColumns(i)) = "" Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が日付として認識できません。", strStdMessage2
                    End If
                    
                'カナ姓名の場合はカナ文字チェックを行う
                Case INDEX_KNAME
            
                    If Not CheckKana(vntColumns(i)) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "に不正な文字が含まれます。", strStdMessage2
                    End If
                    
                '性別は"1"、"2"しか許さない
                Case INDEX_GENDER
                
                    If Not CheckIntoValue(vntColumns(i), Array("1", "2")) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                    End If
                    
                '受診区分コードについてはレコード存在チェックを行う
                Case INDEX_CSLDIVCD
            
                    If Not CheckIntoValue(vntColumns(i), mvntCslDivCd) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                    End If
            
                '郵便番号の場合
                Case INDEX_ZIPCD
                
                    'ハイフンが存在しない場合
                    If InStr(vntColumns(i), "-") <= 0 Then
                        
                        '指定の項目長以外はエラー
                        If vntColumns(i) <> "" Then
                            If LenB(StrConv(vntColumns(i), vbFromUnicode)) <> vntLengths(i) Then
                                AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                            End If
                        End If
                        
                        Exit Do
                    End If
                    
                    'ハイフンが存在する場合、ハイフンで分割
                    vntZipCd = Split(vntColumns(i), "-")
                
                    '要素が３つ以上ある場合はエラー
                    If UBound(vntZipCd) >= 2 Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        Exit Do
                    End If
                
                    'この時点で要素は２個のはずなので各要素ごとに項目長チェックを行う
                    For j = 0 To UBound(vntZipCd)
                        If LenB(StrConv(Trim(vntZipCd(j)), vbFromUnicode)) <> IIf(j = 0, LENGTH_ZIPCD1, LENGTH_ZIPCD2) Then
                            AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                            Exit Do
                        End If
                    Next
            
'## 2004.10.04 Add By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加
                'ローマ字名の場合
                Case INDEX_ROMENAME

                    '半角英数字チェック
                    If Not CheckNarrowValue(vntColumns(i)) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "に不正な文字が含まれます。", strStdMessage2
                    End If
'## 2004.10.04 Add End
            
'## 2004.10.04 Add By T.Takagi@FSIT 予約群を追加
                '予約群の場合
                Case INDEX_RSVGRPCD
                
                    '数字チェック
                    If Not CheckNumber(vntColumns(i)) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                         Exit Do
                    End If
            
                    'ゼロトリミングした状態で項目長チェックを行う
                    If LenB(StrConv(LTrimZero(vntColumns(i)), vbFromUnicode)) > LENGTH_RSVGRPCD Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "の値が長すぎます。", strStdMessage2
                        Exit Do
                    End If
                    
                    '予約群レコード存在チェック
                    If Not CheckIntoValue(CLng(vntColumns(i)), mvntRsvGrpCd) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        Exit Do
                    End If

                    'コース予約群レコード存在チェック
                    If Not CheckIntoValue(CLng(vntColumns(i)), mvntCourseRsvGrpCd) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "は指定契約パターンのコース予約群として存在しません。", strStdMessage2
                    End If
'## 2004.10.04 Add End
                
                'セット分類コードについてはレコード存在チェックを行う
                Case Is >= INDEX_SETCLASSCD
            
                    If Not CheckIntoValue(vntColumns(i), mvntSetClassCd) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
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
    WriteErrorLog "ImportCsv.CheckColumnValue"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : ＣＳＶデータ内各項目値のチェックを行う
'
' 引数　　 : (In)     lngNoDiv      番号選択(1:従業員番号、2:保険証番号)
' 　　　　   (In)     strCsvStream  ＣＳＶデータ
' 　　　　   (In)     strOrgCd1     団体コード１
' 　　　　   (In)     strOrgCd2     団体コード２
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
    ByRef lngNoDiv As Long, _
    ByRef strCsvStream As String, _
    ByRef strOrgCd1 As String, _
    ByRef strOrgCd2 As String, _
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
    
        'セット分類の開始インデックスまで要素が満たない場合
        If UBound(vntArrColumns) < INDEX_SETCLASSCD Then
        
            'セット分類は指定されていないものとし、最大要素数はその直前値までとする
            lngMaxArraySize = INDEX_SETCLASSCD - 1
            
        '何らかのセット分類が指定されている(正確には空のカラムを含めてセット分類列が存在する、の意)場合
        Else
        
            '最大要素数は今検索した配列の要素数そのものとする
            lngMaxArraySize = UBound(vntArrColumns)
            
        End If
    
        vntArrColumns = Empty
        
        'レコード値の配列化
        SetColumnsArrayFromCsvString strCsvStream, lngMaxArraySize, vntArrColumns
    
        'CSVデータの項目値チェック
        CheckColumnValue lngNoDiv, vntNames, vntArrColumns, vntLengths, vntArrMessage1, vntArrMessage2
        
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
    WriteErrorLog "ImportCsv.CheckCsv"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ＣＳＶファイルから受診情報の作成を行う
'
' 引数　　 : (In)     strFileName     ＣＳＶファイル名
' 　　　　   (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     strUserId       ユーザＩＤ
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     lngStartPos     読み込み開始位置
' 　　　　   (In)     lngAddrDiv      住所選択(1:自宅、2:会社)
' 　　　　   (In)     lngNoDiv        番号選択(1:従業員番号、2:保険証番号)
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
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strUserId As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal lngStartPos As Long, _
    ByVal lngAddrDiv As Long, _
    ByVal lngNoDiv As Long, _
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
    Dim objOrganization     As Object       '団体情報アクセス用
    Dim objPref             As Object       '都道府県情報アクセス用
    Dim objSetClass         As Object       'セット分類情報アクセス用
'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
    Dim objSchedule         As Object       'スケジュール情報アクセス用
'## 2004.10.04 Add End

    Dim vntNames            As Variant      '項目名の配列
    Dim vntLengths          As Variant      '項目長の配列
    Dim vntColumns          As Variant      '項目値の配列
    Dim lngElemCount        As Long         '配列の要素数
    
    Dim lngTransId          As Long         'トランザクションＩＤ

    Dim vntTitle            As Variant      '表題
    Dim vntOrgSName         As Variant      '団体略称

    Dim vntCsCd             As Variant      'コースコード
    Dim vntCsName           As Variant      'コース名
    Dim vntStrDate          As Variant      '契約開始日
    Dim vntEndDate          As Variant      '契約終了日

    Dim intInFileNo         As Integer      'ファイル番号
    Dim intOutFileNo        As Integer      'ファイル番号
    Dim strTempFileName     As String       '出力用一時ファイル名
    Dim strOutFileName      As String       '出力ファイル名
    Dim strBuffer           As String       '文字列バッファ
    Dim strOutBuffer        As String       '文字列バッファ

    Dim lngLineNo           As Long         '行番号

    Dim strCslDate          As String       '受診日
    Dim strRsvNo            As String       '予約番号
    Dim strPerId            As String       '個人ＩＤ
    Dim strRsvGrpName       As String       '予約群名称
    Dim strStatus()         As String       '各受診希望日毎の検索結果

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
'## 2004.10.04 Mod By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加、予約群を第３受診希望日と漢字氏名の間に追加
'    vntNames = Array(NAME_CSLDATE1, NAME_CSLDATE2, NAME_CSLDATE3, NAME_NAME, NAME_KNAME, NAME_BIRTH, NAME_GENDER, NAME_CSLDIVCD, NAME_PERID, NAME_ZIPCD, NAME_TEL, NAME_ADDRESS)
    vntNames = Array(NAME_CSLDATE1, NAME_CSLDATE2, NAME_CSLDATE3, NAME_RSVGRPCD, NAME_NAME, NAME_KNAME, NAME_ROMENAME, NAME_BIRTH, NAME_GENDER, NAME_CSLDIVCD, NAME_PERID, NAME_ZIPCD, NAME_TEL, NAME_ADDRESS)
'## 2004.10.04 Mod End
    lngElemCount = UBound(vntNames) + 1

    '従業員番号／保険証番号については引数値に応じて設定
    ReDim Preserve vntNames(lngElemCount)
    Select Case lngNoDiv
        Case 1
            vntNames(lngElemCount) = NAME_EMPNO
        Case 2
            vntNames(lngElemCount) = NAME_ISRNO
    End Select
    lngElemCount = lngElemCount + 1
    
    'セット分類情報を追加
    ReDim Preserve vntNames(lngElemCount)
    vntNames(lngElemCount) = NAME_SETCLASSCD
    lngElemCount = lngElemCount + 1
    
    '項目長の配列を作成
'## 2004.10.04 Mod By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加、予約群を第３受診希望日と漢字氏名の間に追加
'    vntLengths = Array(LENGTH_CSLDATE1, LENGTH_CSLDATE2, LENGTH_CSLDATE3, LENGTH_NAME, LENGTH_KNAME, LENGTH_BIRTH, LENGTH_GENDER, LENGTH_CSLDIVCD, LENGTH_PERID, LENGTH_ZIPCD, LENGTH_TEL, LENGTH_ADDRESS)
    vntLengths = Array(LENGTH_CSLDATE1, LENGTH_CSLDATE2, LENGTH_CSLDATE3, LENGTH_RSVGRPCD, LENGTH_NAME, LENGTH_KNAME, LENGTH_ROMENAME, LENGTH_BIRTH, LENGTH_GENDER, LENGTH_CSLDIVCD, LENGTH_PERID, LENGTH_ZIPCD, LENGTH_TEL, LENGTH_ADDRESS)
'## 2004.10.04 Mod End
    lngElemCount = UBound(vntLengths) + 1

    '従業員番号／保険証番号については引数値に応じて設定
    ReDim Preserve vntLengths(lngElemCount)
    Select Case lngNoDiv
        Case 1
            vntLengths(lngElemCount) = LENGTH_EMPNO
        Case 2
            vntLengths(lngElemCount) = LENGTH_ISRNO
    End Select
    lngElemCount = lngElemCount + 1
    
    'セット分類情報を追加
    ReDim Preserve vntLengths(lngElemCount)
    vntLengths(lngElemCount) = LENGTH_SETCLASSCD
    lngElemCount = lngElemCount + 1
    
    Set objFree = CreateObject("HainsFree.Free")

    '汎用テーブルから表題を取得
    objFree.SelectFree 0, TRANSACTIONDIV_RSVCSV, , vntTitle

    '汎用テーブルから受診区分を読み込む
    objFree.SelectFree 1, "CSLDIV", mvntCslDivCd, , , mvntCslDivName

    Set objFree = Nothing

    Set objPref = CreateObject("HainsPref.Pref")
    
    '都道府県名→コードへの変換情報取得
    objPref.SelectPrefList mvntPrefCd, mvntPrefName
    
    Set objPref = Nothing

    Set objSetClass = CreateObject("HainsSetClass.SetClass")

    'セット分類情報の読み込み
    objSetClass.SelectSetClassList mvntSetClassCd, mvntSetClassName

    Set objSetClass = Nothing

'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
    Set objSchedule = CreateObject("HainsSchedule.Schedule")

    '予約群情報の読み込み
    objSchedule.SelectRsvGrpList 0, mvntRsvGrpCd, mvntRsvGrpName

    Set objSchedule = Nothing
'## 2004.10.04 Add End
    
    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "I", "", vntTitle & "処理を開始します。", ""

    '指定されたパラメータ情報を編集する
    Do

        Set objOrganization = CreateObject("HainsOrganization.Organization")

        '団体略称の取得
        Ret = objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , , , vntOrgSName)
        
        Set objOrganization = Nothing
        
        '団体情報が存在しない場合は処理終了
        If Ret = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "E", "", "団体情報が存在しません。", "団体コード=" & strOrgCd1 & "-" & strOrgCd2
            Exit Do
        End If

        'ログ発行
        PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "I", "", "■次の団体が指定されました。", "団体=" & vntOrgSName & "（" & strOrgCd1 & "-" & strOrgCd2 & "）"

        Set objContract = CreateObject("HainsContract.Contract")

        '契約管理情報の読み込み
        Ret = objContract.SelectCtrMng(strOrgCd1, strOrgCd2, lngCtrPtCd, , vntCsCd, vntCsName, vntStrDate, vntEndDate)
        
        Set objContract = Nothing
        
        If Ret = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "E", "", "契約情報が存在しません。", "契約パターンコード=" & lngCtrPtCd
            Exit Do
        End If

'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
        Set objSchedule = CreateObject("HainsSchedule.Schedule")
    
        'コース予約群情報の読み込み
        objSchedule.SelectCourseRsvGrpListSelCourse vntCsCd, 0, mvntCourseRsvGrpCd, mvntCourseRsvGrpName
    
        Set objSchedule = Nothing
'## 2004.10.04 Add End
        
        'ログ発行
        strMessage = ""
        strMessage = strMessage & "契約パターンコード=" & lngCtrPtCd
        strMessage = strMessage & "、"
        strMessage = strMessage & "コース=" & vntCsName & "（" & vntCsCd & "）"
        strMessage = strMessage & "、"
        strMessage = strMessage & "契約期間=" & vntStrDate & "～" & vntEndDate
        PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "I", "", "■次の契約情報が指定されました。", strMessage

        Set objFso = CreateObject("Scripting.FileSystemObject")
        
        'ファイルの存在をチェック
        Ret = objFso.FileExists(strFileName)
        
        Set objFso = Nothing
        
        'ファイルが存在しない場合は処理を終了する
        If Ret = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "E", "", "ファイルが存在しません。", "ファイル名=" & strFileName
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

                '検索結果の初期化
                Erase strStatus
                
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

                'CSVデータのチェック
                Ret = CheckCsv(lngNoDiv, strBuffer, strOrgCd1, strOrgCd2, vntNames, vntLengths, vntColumns, vntMessage1, vntMessage2)

                'データエラー時
                If Ret = False Then
                    
                    'ログを発行
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "E", lngLineNo, vntMessage1, vntMessage2
                    
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

                ReDim Preserve strStatus(CSLDATE_MAXCOUNT - 1)

                '個人情報の作成、予約空き状況のチェック、受診情報の作成を行う
                Ret2 = InsertConsult(lngTransId, strUserId, strOrgCd1, strOrgCd2, lngCtrPtCd, lngAddrDiv, lngNoDiv, lngLineNo, vntColumns, strCslDate, strRsvNo, strPerId, strRsvGrpName, strStatus)

                '出力ファイル用のレコード編集
                strOutBuffer = strBuffer
                strOutBuffer = strOutBuffer & "," & IIf(Ret2 = 0, "○", "×")
                strOutBuffer = strOutBuffer & "," & strCslDate
                strOutBuffer = strOutBuffer & "," & strRsvNo
                strOutBuffer = strOutBuffer & "," & strPerId
                strOutBuffer = strOutBuffer & "," & strRsvGrpName
                
                '処理結果を追加
                Select Case Ret2
                    
                    Case 0  '正常時
                        strOutBuffer = strOutBuffer & "," & ",,"
                
                    Case -1 '契約情報が存在しない
                        strOutBuffer = strOutBuffer & "," & "契約情報がありません。,,"
                
                    Case -2 '指定受診区分が契約セットに存在しない
                        strOutBuffer = strOutBuffer & "," & "受診区分が契約セットに存在しません。,,"
                
                    Case -3 '個人情報作成エラー
                        strOutBuffer = strOutBuffer & "," & "個人情報の作成エラーが発生しました。,,"
                
                    Case -4 '個人情報が存在しない
                        strOutBuffer = strOutBuffer & "," & "個人情報が存在しません。,,"
                
                    Case -5 'カナ氏名、生年月日、性別不一致
                        strOutBuffer = strOutBuffer & "," & "個人情報とカナ氏名、生年月日、性別が異なります。,,"
                
                    Case -6 '個人情報使用不可
                        strOutBuffer = strOutBuffer & "," & "個人情報が使用できません。,,"
                
                    Case -7 'すべての受診希望日に対して予約不可
                        For i = 0 To UBound(strStatus)
                            strOutBuffer = strOutBuffer & "," & strStatus(i)
                        Next i
                        
                End Select
                
                '出力ファイル書き出し
                Print #intOutFileNo, strOutBuffer

                '作成受診情報数のインクリメント
                If Ret2 = 0 Then
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
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "I", "", lngReadCount & "件のレコードが読み込まれました。", ""
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "I", "", lngWriteCount & "件の受診情報が作成されました。", ""
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVCSV, "I", "", vntTitle & "処理を終了します。", ""

    Exit Sub

ErrorHandle:

    'ファイルクローズ
    Close #intInFileNo
    Close #intOutFileNo

    'イベントログ書き込み
    WriteErrorLog "ImportCsv.ImportCsv"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : 個人情報の作成、予約空き状況のチェック、受診情報の作成を行う
'
' 引数　　 : (In)     lngTransId     トランザクションＩＤ
' 　　　　   (In)     strUserId      ユーザＩＤ
' 　　　　   (In)     strOrgCd1      団体コード１
' 　　　　   (In)     strOrgCd2      団体コード２
' 　　　　   (In)     lngCtrPtCd     契約パターンコード
' 　　　　   (In)     lngAddrDiv     住所選択(1:自宅、2:会社)
' 　　　　   (In)     lngNoDiv       番号選択(1:従業員番号、2:保険証番号)
' 　　　　   (In)     lngLineNo      行番号
' 　　　　   (In)     vntColumns     項目値の配列
' 　　　　   (Out)    strCslDate     受診日
' 　　　　   (Out)    strRsvNo       予約番号
' 　　　　   (Out)    strPerId       個人ＩＤ
' 　　　　   (Out)    strRsvGrpName  予約群名称
' 　　　　   (Out)    strStatus      各受診希望日毎の検索結果
'
' 戻り値　 : ※ストアドが完璧になってから記述する
'
' 備考　　 :
'
Private Function InsertConsult( _
    ByRef lngTransId As Long, _
    ByRef strUserId As String, _
    ByRef strOrgCd1 As String, _
    ByRef strOrgCd2 As String, _
    ByRef lngCtrPtCd As Long, _
    ByRef lngAddrDiv As Long, _
    ByRef lngNoDiv As Long, _
    ByRef lngLineNo As Long, _
    ByRef vntColumns As Variant, _
    ByRef strCslDate As String, _
    ByRef strRsvNo As String, _
    ByRef strPerId As String, _
    ByRef strRsvGrpName As String, _
    ByRef strStatus() As String _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント

    Dim objCslDate          As OraParamArray    '受診希望日
    Dim objSetClassCd       As OraParamArray    'セット分類コード
    Dim objStatus           As OraParamArray    '各受診希望日毎の検索結果

    Dim strLastName         As String           '姓
    Dim strFirstName        As String           '名

    Dim strPrefCd           As String           '都道府県コード
    Dim strCityName         As String           '市区町村コード
    Dim strAddress1         As String           '住所１
    Dim strAddress2         As String           '住所２

    Dim lngSetClassCount    As Long             'セット分類数
    Dim Ret                 As Long             '関数戻り値
    Dim i                   As Long             'インデックス
    Dim j                   As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    strCslDate = ""
    strRsvNo = ""
    strPerId = ""
    strRsvGrpName = ""

    Set objOraParam = mobjOraDb.Parameters
    
    'パラメータ設定
    With objOraParam
        
        '共通項目
        .Add "TRANSID", lngTransId, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "TRANSDIV", TRANSACTIONDIV_RSVCSV, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "UPDUSER", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "ADDRDIV", lngAddrDiv, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "LINENO", lngLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
        
        '受診希望日のバインド配列
        .AddTable "CSLDATE", ORAPARM_INPUT, ORATYPE_DATE, CSLDATE_MAXCOUNT
        
'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
        .Add "RSVGRPCD", IIf(vntColumns(INDEX_RSVGRPCD) <> "", CLng("0" & vntColumns(INDEX_RSVGRPCD)), Null), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.10.04 Add End
        
        '氏名を姓名に分割して編集
        SplitName vntColumns(INDEX_NAME), strLastName, strFirstName
        .Add "LASTNAME", strLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "FIRSTNAME", strFirstName, ORAPARM_INPUT, ORATYPE_VARCHAR2

        'カナ氏名を姓名に分割して編集
        SplitName vntColumns(INDEX_KNAME), strLastName, strFirstName
        .Add "LASTKNAME", strLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "FIRSTKNAME", strFirstName, ORAPARM_INPUT, ORATYPE_VARCHAR2

'## 2004.10.04 Add By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加
        .Add "ROMENAME", CStr(vntColumns(INDEX_ROMENAME)), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.10.04 Add End
        
        '生年月日、性別、受診区分コード、個人ＩＤ
        .Add "BIRTH", CDate(CnvDate(vntColumns(INDEX_BIRTH))), ORAPARM_INPUT, ORATYPE_DATE
        .Add "GENDER", CLng(vntColumns(INDEX_GENDER)), ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "CSLDIVCD", CStr(vntColumns(INDEX_CSLDIVCD)), ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "PERID", CStr(LTrimZero(vntColumns(INDEX_PERID))), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        '郵便番号はハイフンを除去
        .Add "ZIPCD", CStr(Replace(vntColumns(INDEX_ZIPCD), "-", "")), ORAPARM_INPUT, ORATYPE_VARCHAR2

        '住所を分割して編集
        SplitAddress vntColumns(INDEX_ADDRESS), strPrefCd, strCityName, strAddress1, strAddress2
        .Add "PREFCD", strPrefCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "CITYNAME", strCityName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ADDRESS1", strAddress1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ADDRESS2", strAddress2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        '電話番号
        .Add "TEL", CStr(vntColumns(INDEX_TEL)), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        '従業員番号、保険証番号は引数値に応じて編集
        Select Case lngNoDiv
            Case 1
                .Add "EMPNO", CStr(vntColumns(INDEX_EMPNO)), ORAPARM_INPUT, ORATYPE_VARCHAR2
                .Add "ISRNO", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
            Case 2
                .Add "EMPNO", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
                .Add "ISRNO", CStr(vntColumns(INDEX_EMPNO)), ORAPARM_INPUT, ORATYPE_VARCHAR2
            Case Else
                .Add "EMPNO", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
                .Add "ISRNO", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
        End Select

        'セット分類のバインド配列定義に際し、セット分類数を求める
        '(項目値配列のセット分類開始位置以降はすべてセット分類とみなす)
        lngSetClassCount = UBound(vntColumns) - (INDEX_SETCLASSCD - 1)
        
        'ただし上記の式でセット分類数が得られない場合、セット分類数は暫定で１とする
        '(OO4Oからストアドへ索引付き表を渡す際、配列の要素数が０では異常終了する)
        If lngSetClassCount <= 0 Then
            lngSetClassCount = 1
        End If
        
        'セット分類のバインド配列定義
        .AddTable "SETCLASSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngSetClassCount, LENGTH_SETCLASSCD

        '出力用のバインド変数定義
        .Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
        .Add "ENTCSLDATE", Null, ORAPARM_OUTPUT, ORATYPE_DATE
        .Add "RSVNO", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
        .Add "ENTPERID", Null, ORAPARM_OUTPUT, ORATYPE_VARCHAR2
        .Add "RSVGRPNAME", Null, ORAPARM_OUTPUT, ORATYPE_VARCHAR2

        '受診希望日毎の検索結果用バインド配列
        .AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, CSLDATE_MAXCOUNT, 256

    End With
    
    'オブジェクトの参照設定
    Set objCslDate = objOraParam("CSLDATE")
    Set objSetClassCd = objOraParam("SETCLASSCD")
    Set objStatus = objOraParam("MESSAGE")

    '受診希望日の編集
    For i = 0 To CSLDATE_MAXCOUNT - 1
        objCslDate(i) = Null
    Next i
    If vntColumns(INDEX_CSLDATE1) <> "" Then objCslDate(0) = CDate(CnvDate(vntColumns(INDEX_CSLDATE1)))
    If vntColumns(INDEX_CSLDATE2) <> "" Then objCslDate(1) = CDate(CnvDate(vntColumns(INDEX_CSLDATE2)))
    If vntColumns(INDEX_CSLDATE3) <> "" Then objCslDate(2) = CDate(CnvDate(vntColumns(INDEX_CSLDATE3)))

    'セット分類の編集
    For i = INDEX_SETCLASSCD To UBound(vntColumns)
        objSetClassCd(j) = CStr(vntColumns(i))
        j = j + 1
    Next i

    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN                                                 " & vbLf & _
              "    :RET := ConsultAllPackage.InsertConsultFromPerId( "

'## 2004.10.04 Mod By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加、予約群を第３受診希望日と漢字氏名の間に追加
'    strStmt = strStmt & vbLf & _
'              "                :TRANSID,    " & vbLf & _
'              "                :TRANSDIV,   " & vbLf & _
'              "                :UPDUSER,    " & vbLf & _
'              "                :ORGCD1,     " & vbLf & _
'              "                :ORGCD2,     " & vbLf & _
'              "                :CTRPTCD,    " & vbLf & _
'              "                :ADDRDIV,    " & vbLf & _
'              "                :LINENO,     " & vbLf & _
'              "                :CSLDATE,    " & vbLf & _
'              "                :LASTNAME,   " & vbLf & _
'              "                :FIRSTNAME,  " & vbLf & _
'              "                :LASTKNAME,  " & vbLf & _
'              "                :FIRSTKNAME, " & vbLf & _
'              "                :BIRTH,      " & vbLf & _
'              "                :GENDER,     "
    strStmt = strStmt & vbLf & _
              "                :TRANSID,    " & vbLf & _
              "                :TRANSDIV,   " & vbLf & _
              "                :UPDUSER,    " & vbLf & _
              "                :ORGCD1,     " & vbLf & _
              "                :ORGCD2,     " & vbLf & _
              "                :CTRPTCD,    " & vbLf & _
              "                :ADDRDIV,    " & vbLf & _
              "                :LINENO,     " & vbLf & _
              "                :CSLDATE,    " & vbLf & _
              "                :RSVGRPCD,   " & vbLf & _
              "                :LASTNAME,   " & vbLf & _
              "                :FIRSTNAME,  " & vbLf & _
              "                :LASTKNAME,  " & vbLf & _
              "                :FIRSTKNAME, " & vbLf & _
              "                :ROMENAME,   " & vbLf & _
              "                :BIRTH,      " & vbLf & _
              "                :GENDER,     "
'## 2004.10.04 Mod End
    strStmt = strStmt & vbLf & _
              "                :CSLDIVCD,   " & vbLf & _
              "                :PERID,      " & vbLf & _
              "                :ZIPCD,      " & vbLf & _
              "                :PREFCD,     " & vbLf & _
              "                :CITYNAME,   " & vbLf & _
              "                :ADDRESS1,   " & vbLf & _
              "                :ADDRESS2,   " & vbLf & _
              "                :TEL,        " & vbLf & _
              "                :EMPNO,      " & vbLf & _
              "                :ISRNO,      " & vbLf & _
              "                :SETCLASSCD, " & vbLf & _
              "                :ENTCSLDATE, " & vbLf & _
              "                :RSVNO,      " & vbLf & _
              "                :ENTPERID,   " & vbLf & _
              "                :RSVGRPNAME, " & vbLf & _
              "                :MESSAGE     "

    strStmt = strStmt & vbLf & _
              "    ); " & vbLf & _
              "END;   "

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    strCslDate = objOraParam("ENTCSLDATE").Value & ""
    strRsvNo = objOraParam("RSVNO").Value & ""
    strPerId = objOraParam("ENTPERID").Value & ""
    strRsvGrpName = objOraParam("RSVGRPNAME").Value & ""
    
    For i = 0 To CSLDATE_MAXCOUNT - 1
        strStatus(i) = objStatus(i) & ""
    Next i
    
    Ret = objOraParam("RET").Value

    '戻り値の設定
    InsertConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ImportCsv.InsertConsult"

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
' 機能　　 : 先頭からのゼロ値を除去
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : トリミング後の値
'
' 備考　　 : ただし数値として認識できない場合は何もしない
'
Private Function LTrimZero(ByVal strExpression As String) As String

    Dim strBuffer   As String   '文字列編集用バッファ
    Dim lngPos      As Long     'ゼロ以外の文字が最初に現れた位置
    Dim i           As Long     'インデックス
    
    Do
    
        strBuffer = Trim(strExpression)
    
        '未指定時は何もしない
        If strBuffer = "" Then
            Exit Do
        End If
        
        '半角数字チェック
        If Not CheckNumber(strBuffer) Then
            Exit Do
        End If

        'ゼロ以外の文字が最初に現れる位置を検索
        For i = 1 To Len(strBuffer)
            If Mid(strBuffer, i, 1) <> "0" Then
                lngPos = i
                Exit For
            End If
        Next i
                
        '結局すべてゼロだった場合は何もしないことにする
        If lngPos = 0 Then
            Exit Do
        End If
                
        'ゼロトリミング
        strBuffer = Right(strBuffer, Len(strBuffer) - (lngPos - 1))
        Exit Do
    Loop
    
    LTrimZero = strBuffer
    
End Function

'
' 機能　　 : 住所の分割
'
' 引数　　 : (In)     strAddress   住所
' 　　　　   (Out)    strPrefCd    都道府県コード
' 　　　　   (Out)    strCityName  市区町村コード
' 　　　　   (Out)    strAddress1  住所１
' 　　　　   (Out)    strAddress2  住所２
'
' 戻り値　 :
'
' 備考　　 : 日本語的意味合いでの区切り位置を求めることは不可能なため、項目最大長に達する時点で分割。
'
Private Sub SplitAddress(ByVal strAddress As String, ByRef strPrefCd As String, ByRef strCityName As String, ByRef strAddress1 As String, ByRef strAddress2 As String)

    Dim i   As Long 'インデックス
    
    '初期処理
    strPrefCd = ""
    strCityName = ""
    strAddress1 = ""
    strAddress2 = ""

    strAddress = Trim(strAddress)
    If strAddress = "" Then
        Exit Sub
    End If

    '全角変換(さもないと区切り位置が全角文字の１バイト目と２バイト目の間に発生することがある)
    strAddress = StrConv(strAddress, vbWide)

    '先頭文字が都道府県変換情報の都道府県名と一致するかを検索
    If IsArray(mvntPrefCd) Then
        For i = 0 To UBound(mvntPrefCd)
            If InStr(strAddress, mvntPrefName(i)) = 1 Then
            
                '一致する場合、都道府県名は対応するコードに変換し、住所本体からは除外
                strPrefCd = mvntPrefCd(i)
                strAddress = Replace(strAddress, mvntPrefName(i), "", , 1)
                Exit For
                
            End If
        Next i
    End If

    '残りを50バイト(市区町村コード)、60バイト(住所１)、60バイト(住所２)に分割
    '(ただしCSVデータでは何バイト存在するかわからない。そこでここでは住所２に残りをありったけ格納し、あとは項目長チェックに委ねる。)
    strCityName = Left(strAddress, 25)
    strAddress1 = Mid(strAddress, 26, 30)
    If Len(strAddress) > 55 Then
        strAddress2 = Right(strAddress, Len(strAddress) - 55)
    End If

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

