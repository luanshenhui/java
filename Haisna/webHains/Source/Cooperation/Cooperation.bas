Attribute VB_Name = "Cooperation"
Option Explicit

Public Const MODE_INSERT        As String = "I" '処理モード(挿入)
Public Const MODE_UPDATE        As String = "U" '処理モード(更新)

Public Const RELATIONCD_SELF    As String = "0" '本人用続柄コード
Public Const BRANCHNO_SELF      As Long = 0     '本人用枝番

'個人情報レコード
Public Type PERSON_INF
    DelFlg      As Long     '削除フラグ
    TransferDiv As Long     '出向区分
    LastName    As String   '姓
    FirstName   As String   '名
    LastKName   As String   'カナ姓
    FirstKName  As String   'カナ名
    Birth       As Date     '生年月日
    Gender      As Long     '性別
    OrgBsdCd    As String   '事業部コード
    OrgBsdName  As String   '事業部名称
    OrgRoomCd   As String   '室部コード
    OrgRoomName As String   '室部名称
    OrgPostCd   As String   '所属コード
    OrgPostName As String   '所属名称
    JobCd       As String   '職名コード
    JobName     As String   '職名
    DutyCd      As String   '職責コード
    DutyName    As String   '職責名称
    QualifyCd   As String   '資格コード
    QualifyName As String   '資格名称
    IsrSign     As String   '健保記号
    IsrNo       As String   '健保番号
    RelationCd  As String   '続柄コード
    BranchNo    As Long     '枝番
    EmpNo       As String   '従業員番号
    HireDate    As Date     '入社年月日
    EmpDiv      As String   '従業員区分
'## 2003.01.29 Add 1Line By T.Takagi@FSIT 従業員区分名称対応
    EmpName     As String   '従業員区分名称
'## 2003.01.29 Add End
    HongenDiv   As String   '本現区分
    Tel1        As String   '電話番号１
    Tel2        As String   '電話番号２
    Tel3        As String   '電話番号３
    ZipCd1      As String   '郵便番号１
    ZipCd2      As String   '郵便番号２
    Address1    As String   '住所１
    Address2    As String   '住所２
'## 2003.02.07 Add 1Line By T.Takagi@FSIT 受診希望日対応
    CslDate     As Date     '受診希望日
'## 2003.02.07 Add End
End Type

'キー情報
Public Type KEY_REC
    CslDate     As String * 8   '受診日
    Seq         As String * 5   '健診通番
    Space1      As String * 7   '空白
End Type

'被険者レコード
Public Type REQUEST_REC
    RecDiv      As String * 2   'レコード区分
    CenterDiv   As String * 6   'センター区分
    ReqKey      As KEY_REC      '依頼者キー情報
    ReqCd       As String * 4   '依頼元コード
    Space1      As String * 11  '空白
    CsDiv       As String * 1   '健診種別
    Space2      As String * 14  '空白
    EnterDiv    As String * 1   '入院・外来区分
    DoctorCd    As String * 4   'ドクターコード
    Space3      As String * 6   '空白
    Id          As String * 15  '被検者ＩＤ
    PatientNo   As String * 10  '患者番号
    Space4      As String * 5   '空白
    KanaName    As String * 20  '被検者名
    Gender      As String * 1   '性別
    AgeDiv      As String * 1   '年齢区分
    Age         As String * 3   '年齢
    BirthDiv    As String * 1   '生年月日区分
    Birth       As String * 6   '生年月日
    TakeDate    As String * 6   '採取日
    TakeTime    As String * 4   '採取時間
    ItemCount   As String * 3   '項目数
    Height      As String * 4   '身長
    Weight      As String * 4   '体重
    Urine       As String * 4   '尿量
    UrineUnit   As String * 2   '尿量単位
    Conception  As String * 2   '妊娠週数
    Dislysis    As String * 1   '透析前後
    Rapid       As String * 1   '至急報告
    Comment     As String * 20  '依頼コメント内容
    Name        As String * 8   '漢字氏名
    TestTubeNo  As String * 4   '検体番号
    Space5      As String * 54  '空白
End Type

'検査項目レコード(ヘッダ部)
Public Type ITEM_HEADER
    RecDiv      As String * 2   'レコード区分
    CenterDiv   As String * 6   'センター区分
    CslDate     As String * 8   '受診日
    Seq         As String * 6   '健診通番
    Space1      As String * 6   '空白
End Type

'検査項目レコード(検査項目部)
Public Type ITEM_REC
    ItemCd      As String * 5   '検査項目コード(分析物コード)
    DisCd       As String * 4   '識別コード
    MtrCd       As String * 3   '材料コード
    MesCd       As String * 3   '測定法コード
    LoadTime    As String * 10  '負荷時間
End Type

'検査結果レコード(検査結果部)
Public Type RESULT_REC
    ItemCd      As String * 5   '検査項目コード(分析物コード)
    DisCd       As String * 4   '識別コード
    MtrCd       As String * 3   '材料コード
    MesCd       As String * 3   '測定法コード
    Suffix      As String * 2   '項目コード枝番
    Result      As String * 8   '検査結果
    State       As String * 1   '検査値状態
    RslCmtCd1   As String * 3   '結果コメントコード１
    RslCmtCd2   As String * 3   '結果コメントコード２
End Type

'検査結果レコード
Public Type RESPONSE_REC
    RecDiv      As String * 2   'レコード区分
    CenterDiv   As String * 6   'センター区分
    ReqKey      As KEY_REC      '依頼者キー情報
    CslKey      As KEY_REC      '受診者キー情報
    KanaName    As String * 20  '被険者名
    RepCd       As String * 1   '報告状況コード
    Nyubi       As String * 3   '乳び
    Yoketsu     As String * 3   '溶血
    Bil         As String * 3   'ビリルビン
    Results(4)  As RESULT_REC   '検査結果
    PatientNo   As String * 10  '患者番号
    CsDiv       As String * 1   '健診種別
    Space1      As String * 7   '空白
End Type

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
' 機能　　 : 健保記号、健保番号の比較
'
' 引数　　 : (In)     udtPerson     個人情報レコード
' 　　　　   (In)     strIsrSign    健保記号
' 　　　　   (In)     strIsrNo      健保番号
' 　　　　   (In)     strPerId      個人ＩＤ
' 　　　　   (In)     strLastName   性
' 　　　　   (In)     strFirstName  名
' 　　　　   (Out)    vntMessage1   メッセージ１
' 　　　　   (Out)    vntMessage2   メッセージ２
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub CompareIsr( _
    ByRef udtPerson As PERSON_INF, _
    ByVal strIsrSign As String, _
    ByVal strIsrNo As String, _
    ByVal strPerId As String, _
    ByVal strLastName As String, _
    ByVal strFirstName As String, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
)

    Dim strBuffer   As String   '文字列バッファ
    Dim strMessage  As String   'メッセージ
    
    '初期処理
    vntMessage1 = Empty
    vntMessage2 = Empty
    
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ログ修正
'    strBuffer = "、氏名=" & Trim(strLastName & "　" & strFirstName) & "（" & strPerId & "）"
    strBuffer = "従業員番号=" & udtPerson.EmpNo & "、氏名=" & Trim(strLastName & "　" & strFirstName) & "（" & strPerId & "）"
'## 2003.04.22 Mod End
    
    '健保記号の比較
    If strIsrSign <> "" And strIsrSign <> udtPerson.IsrSign Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ログ修正
'        strMessage = "健保記号=" & IIf(udtPerson.IsrSign <> "", udtPerson.IsrSign, "なし") & "、現在の健保記号=" & IIf(strIsrSign <> "", strIsrSign, "なし") & strBuffer
        strMessage = strBuffer & "、健保記号=" & IIf(udtPerson.IsrSign <> "", udtPerson.IsrSign, "なし") & "、現在の健保記号=" & IIf(strIsrSign <> "", strIsrSign, "なし")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "現在の個人情報と健保記号が異なります。", strMessage
    End If

    '健保番号の比較
    If strIsrNo <> "" And strIsrNo <> udtPerson.IsrNo Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ログ修正
'        strMessage = "健保番号=" & IIf(udtPerson.IsrNo <> "", udtPerson.IsrNo, "なし") & "、現在の健保番号=" & IIf(strIsrNo <> "", strIsrNo, "なし") & strBuffer
        strMessage = strBuffer & "、健保番号=" & IIf(udtPerson.IsrNo <> "", udtPerson.IsrNo, "なし") & "、現在の健保番号=" & IIf(strIsrNo <> "", strIsrNo, "なし")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "現在の個人情報と健保番号が異なります。", strMessage
    End If
    
End Sub

'
' 機能　　 : 氏名の比較
'
' 引数　　 : (In)     udtPerson      個人情報レコード
' 　　　　   (In)     strLastName    姓
' 　　　　   (In)     strFirstName   名
' 　　　　   (In)     strLastKName   カナ姓
' 　　　　   (In)     strFirstKName  カナ名
' 　　　　   (Out)    vntMessage1    メッセージ１
' 　　　　   (Out)    vntMessage2    メッセージ２
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub CompareName(ByRef udtPerson As PERSON_INF, ByVal strLastName As String, ByVal strFirstName As String, ByVal strLastKName As String, ByVal strFirstKName As String, ByRef vntMessage1 As Variant, ByRef vntMessage2 As Variant)

    Dim strCheckLastKName   As String   'カナ姓
    Dim strCheckFirstKName  As String   'カナ名
'## 2003.04.17 Add 2Lines By T.Takagi@FSIT 現在のカナ姓名についても一応変換をかける（残存移行データの対応）
    Dim strOriginLastKName  As String   '現在のカナ姓
    Dim strOriginFirstKName As String   '現在のカナ名
'## 2003.04.17 Add End
    Dim strMessage          As String   'メッセージ
    
    '初期処理
    vntMessage1 = Empty
    vntMessage2 = Empty
    
'## 2003.04.17 Add 43Lines By T.Takagi@FSIT 現在の姓名についても変換をかける
    strCheckLastKName = udtPerson.LastName
    strCheckLastKName = Replace(strCheckLastKName, "ァ", "ア")
    strCheckLastKName = Replace(strCheckLastKName, "ィ", "イ")
    strCheckLastKName = Replace(strCheckLastKName, "ゥ", "ウ")
    strCheckLastKName = Replace(strCheckLastKName, "ェ", "エ")
    strCheckLastKName = Replace(strCheckLastKName, "ォ", "オ")
    strCheckLastKName = Replace(strCheckLastKName, "ッ", "ツ")
    strCheckLastKName = Replace(strCheckLastKName, "ャ", "ヤ")
    strCheckLastKName = Replace(strCheckLastKName, "ュ", "ユ")
    strCheckLastKName = Replace(strCheckLastKName, "ョ", "ヨ")
        
    strCheckFirstKName = udtPerson.FirstName
    strCheckFirstKName = Replace(strCheckFirstKName, "ァ", "ア")
    strCheckFirstKName = Replace(strCheckFirstKName, "ィ", "イ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ゥ", "ウ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ェ", "エ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ォ", "オ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ッ", "ツ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ャ", "ヤ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ュ", "ユ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ョ", "ヨ")
    
    strOriginLastKName = strLastName
    strOriginLastKName = Replace(strOriginLastKName, "ァ", "ア")
    strOriginLastKName = Replace(strOriginLastKName, "ィ", "イ")
    strOriginLastKName = Replace(strOriginLastKName, "ゥ", "ウ")
    strOriginLastKName = Replace(strOriginLastKName, "ェ", "エ")
    strOriginLastKName = Replace(strOriginLastKName, "ォ", "オ")
    strOriginLastKName = Replace(strOriginLastKName, "ッ", "ツ")
    strOriginLastKName = Replace(strOriginLastKName, "ャ", "ヤ")
    strOriginLastKName = Replace(strOriginLastKName, "ュ", "ユ")
    strOriginLastKName = Replace(strOriginLastKName, "ョ", "ヨ")
        
    strOriginFirstKName = strFirstName
    strOriginFirstKName = Replace(strOriginFirstKName, "ァ", "ア")
    strOriginFirstKName = Replace(strOriginFirstKName, "ィ", "イ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ゥ", "ウ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ェ", "エ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ォ", "オ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ッ", "ツ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ャ", "ヤ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ュ", "ユ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ョ", "ヨ")
'## 2003.04.17 Add End
    
    '姓名の比較
'## 2003.04.17 Mod 2Lines By T.Takagi@FSIT 現在のカナ姓名についても一応変換をかける（残存移行データの対応）
'    If strLastName <> udtPerson.LastName Or strFirstName <> udtPerson.FirstName Then
    If strOriginLastKName <> strCheckLastKName Or strOriginFirstKName <> strCheckFirstKName Then
'## 2003.04.17 Mod End
        strMessage = "氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
        strMessage = strMessage & "、現在の氏名=" & Trim(strLastName & "　" & strFirstName)
        AppendMessage vntMessage1, vntMessage2, "現在の個人情報と氏名が異なります。氏名は更新されます。", strMessage
    End If
        
    strCheckLastKName = udtPerson.LastKName
    strCheckLastKName = Replace(strCheckLastKName, "ァ", "ア")
    strCheckLastKName = Replace(strCheckLastKName, "ィ", "イ")
    strCheckLastKName = Replace(strCheckLastKName, "ゥ", "ウ")
    strCheckLastKName = Replace(strCheckLastKName, "ェ", "エ")
    strCheckLastKName = Replace(strCheckLastKName, "ォ", "オ")
    strCheckLastKName = Replace(strCheckLastKName, "ッ", "ツ")
    strCheckLastKName = Replace(strCheckLastKName, "ャ", "ヤ")
    strCheckLastKName = Replace(strCheckLastKName, "ュ", "ユ")
    strCheckLastKName = Replace(strCheckLastKName, "ョ", "ヨ")
        
    strCheckFirstKName = udtPerson.FirstKName
    strCheckFirstKName = Replace(strCheckFirstKName, "ァ", "ア")
    strCheckFirstKName = Replace(strCheckFirstKName, "ィ", "イ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ゥ", "ウ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ェ", "エ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ォ", "オ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ッ", "ツ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ャ", "ヤ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ュ", "ユ")
    strCheckFirstKName = Replace(strCheckFirstKName, "ョ", "ヨ")
        
'## 2003.04.17 Add 21Lines By T.Takagi@FSIT 現在のカナ姓名についても一応変換をかける（残存移行データの対応）
    strOriginLastKName = strLastKName
    strOriginLastKName = Replace(strOriginLastKName, "ァ", "ア")
    strOriginLastKName = Replace(strOriginLastKName, "ィ", "イ")
    strOriginLastKName = Replace(strOriginLastKName, "ゥ", "ウ")
    strOriginLastKName = Replace(strOriginLastKName, "ェ", "エ")
    strOriginLastKName = Replace(strOriginLastKName, "ォ", "オ")
    strOriginLastKName = Replace(strOriginLastKName, "ッ", "ツ")
    strOriginLastKName = Replace(strOriginLastKName, "ャ", "ヤ")
    strOriginLastKName = Replace(strOriginLastKName, "ュ", "ユ")
    strOriginLastKName = Replace(strOriginLastKName, "ョ", "ヨ")
        
    strOriginFirstKName = strFirstKName
    strOriginFirstKName = Replace(strOriginFirstKName, "ァ", "ア")
    strOriginFirstKName = Replace(strOriginFirstKName, "ィ", "イ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ゥ", "ウ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ェ", "エ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ォ", "オ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ッ", "ツ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ャ", "ヤ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ュ", "ユ")
    strOriginFirstKName = Replace(strOriginFirstKName, "ョ", "ヨ")
'## 2003.04.17 Add End
        
    'カナ姓名の比較
'## 2003.04.17 Mod 2Lines By T.Takagi@FSIT 現在のカナ姓名についても一応変換をかける（残存移行データの対応）
'    If strLastKName <> strCheckLastKName Or strFirstKName <> strCheckFirstKName Then
    If strOriginLastKName <> strCheckLastKName Or strOriginFirstKName <> strCheckFirstKName Then
'## 2003.04.17 Mod End
        strMessage = "カナ氏名=" & Trim(udtPerson.LastKName & "　" & udtPerson.FirstKName)
        strMessage = strMessage & "、現在のカナ氏名=" & Trim(strLastKName & "　" & strFirstKName)
        AppendMessage vntMessage1, vntMessage2, "現在の個人情報とカナ氏名が異なります。カナ氏名は更新されます。", strMessage
    End If
    
End Sub

'
' 機能　　 : 生年月日、性別の比較
'
' 引数　　 : (In)     udtPerson     個人情報レコード
' 　　　　   (In)     dtmBirth      生年月日
' 　　　　   (In)     lngGender     性別
' 　　　　   (In)     strPerId      個人ＩＤ
' 　　　　   (In)     strLastName   性
' 　　　　   (In)     strFirstName  名
' 　　　　   (Out)    vntMessage1   メッセージ１
' 　　　　   (Out)    vntMessage2   メッセージ２
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub ComparePerson( _
    ByRef udtPerson As PERSON_INF, _
    ByVal dtmBirth As Date, _
    ByVal lngGender As Long, _
    ByVal strPerId As String, _
    ByVal strLastName As String, _
    ByVal strFirstName As String, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
)

    Dim strBuffer   As String   '文字列バッファ
    Dim strMessage  As String   'メッセージ
    
    '初期処理
    vntMessage1 = Empty
    vntMessage2 = Empty
    
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ログ修正
'    strBuffer = "、氏名=" & Trim(strLastName & "　" & strFirstName) & "（" & strPerId & "）"
    strBuffer = "氏名=" & Trim(strLastName & "　" & strFirstName) & "（" & strPerId & "）"
'## 2003.04.22 Mod End
    
    '生年月日の比較
    If dtmBirth <> udtPerson.Birth Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ログ修正
'        strMessage = "生年月日=" & Format(udtPerson.Birth, "ge.m.d") & "、現在の生年月日=" & Format(dtmBirth, "ge.m.d") & strBuffer
        strMessage = strBuffer & "、生年月日=" & Format(udtPerson.Birth, "ge.m.d") & "、現在の生年月日=" & Format(dtmBirth, "ge.m.d")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "現在の個人情報と生年月日が異なります。", strMessage
    End If

    '性別の比較
    If lngGender <> udtPerson.Gender Then
'## 2003.04.22 Mod 2Lines By T.Takagi@FSIT ログ修正
'        strMessage = "性別=" & IIf(udtPerson.Gender = 1, "男性", "女性") & "、現在の性別=" & IIf(lngGender = 1, "男性", "女性") & strBuffer
        strMessage = strBuffer & "、性別=" & IIf(udtPerson.Gender = 1, "男性", "女性") & "、現在の性別=" & IIf(lngGender = 1, "男性", "女性")
'## 2003.04.22 Mod End
        AppendMessage vntMessage1, vntMessage2, "現在の個人情報と性別が異なります。", strMessage
    End If
    
End Sub

'
' 機能　　 : 個人情報更新時のメッセージを編集する
'
' 引数　　 : (In)     lngCalled    呼び元(0:人事情報から、1:健保本人から)
' 　　　　   (In)     strMode      処理モード
' 　　　　   (In)     lngStatus    状態
' 　　　　   (In)     strPerId     個人ＩＤ
' 　　　　   (In)     udtPerson    個人情報レコード
' 　　　　   (In)     strUserId    ユーザＩＤ
' 　　　　   (Out)    strMessage1  メッセージ１
' 　　　　   (Out)    strMessage2  メッセージ２
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub EditMessage(ByVal lngCalled As Long, ByVal strMode As String, ByVal lngStatus As Long, ByVal strPerId As String, ByRef udtPerson As PERSON_INF, ByVal strUserId As String, ByRef strMessage1 As String, ByRef strMessage2 As String)

    Dim strMessage  As String   'メッセージ
    
    '初期処理
    strMessage1 = ""
    strMessage2 = ""
    
    'メッセージ基本部分の編集
    Select Case lngCalled
        Case 0
            strMessage = "従業員番号=" & udtPerson.EmpNo
        Case 1
            strMessage = "健保記号=" & udtPerson.IsrSign & "、健保番号=" & udtPerson.IsrNo
    End Select
    
    strMessage = strMessage & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
    
    '状態ごとのメッセージ編集
    Select Case lngStatus
        
        Case Is > 0 '正常時
            
            strMessage1 = "個人情報が" & IIf(strMode = MODE_INSERT, "作成", "更新") & "されました。"
            strMessage2 = strMessage & "（" & strPerId & "）"
            
        Case 0      '個人ＩＤ重複時
            
            '挿入時は必ず個人ＩＤを発番するので本処理は絶対発生しない。よって更新時のメッセージのみ記す。
            If strMode = MODE_UPDATE Then
                strMessage1 = "この個人情報はすでに削除されています。更新できません。"
                strMessage2 = strMessage
            End If
            
        Case -1     '団体情報重複時
            
            strMessage1 = "同一団体、従業員番号の個人情報がすでに存在します。"
            strMessage2 = strMessage
        
        Case -2     '健保情報重複時
            
            strMessage1 = "同一健保、続柄、枝番の個人情報がすでに存在します。"
            strMessage2 = strMessage
            
            If lngCalled = 0 Then
                strMessage2 = strMessage2 & "、健保記号=" & udtPerson.IsrSign
                strMessage2 = strMessage2 & "、健保番号=" & udtPerson.IsrNo
            End If
            
            strMessage2 = strMessage2 & "、続柄=" & udtPerson.RelationCd
            strMessage2 = strMessage2 & "、枝番=" & udtPerson.BranchNo
        
        Case -3     'ユーザ情報非存在時
            
            strMessage1 = "ユーザＩＤが存在しません。"
            strMessage2 = "ユーザＩＤ=" & strUserId
            
        Case -4     '所属情報非存在時
            
            strMessage1 = "所属情報が存在しません。"
            strMessage2 = strMessage
            strMessage2 = strMessage2 & "、事業部コード=" & IIf(udtPerson.OrgBsdCd <> "", udtPerson.OrgBsdCd, "なし")
            strMessage2 = strMessage2 & "、室部コード=" & IIf(udtPerson.OrgRoomCd <> "", udtPerson.OrgRoomCd, "なし")
            strMessage2 = strMessage2 & "、所属コード=" & IIf(udtPerson.OrgPostCd <> "", udtPerson.OrgPostCd, "なし")
        
        Case -5     '続柄非存在時
        
            strMessage1 = "続柄が存在しません。"
            strMessage2 = strMessage & "、続柄=" & udtPerson.RelationCd
        
        Case -6     'ここで親個人ＩＤは更新しないので本処理は発生しない
            
        Case -7     '職名非存在時
            
            strMessage1 = "職名情報が存在しません。"
            strMessage2 = strMessage & "、職名コード=" & udtPerson.JobCd
        
        Case -8     '職責非存在時
            
            strMessage1 = "職責情報が存在しません。"
            strMessage2 = strMessage & "、職責コード=" & udtPerson.DutyCd
        
        Case -9     '資格非存在時
        
            strMessage1 = "資格情報が存在しません。"
            strMessage2 = strMessage & "、資格コード=" & udtPerson.QualifyCd
        
        Case -10    'ここでは就業措置区分は更新しないので本処理は発生しない
        
        Case Else
            
            strMessage1 = "個人情報の更新処理でその他エラーが発生しました。"
            strMessage2 = strMessage & "、エラーコード=" & lngStatus
    
    End Select

End Sub

'
' 機能　　 : 個人情報レコード構造体の初期化
'
' 引数　　 : (In)     udtPerson  個人情報レコード構造体
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub Initialize(ByRef udtPerson As PERSON_INF)

    With udtPerson
        .DelFlg = 0
        .TransferDiv = 0
        .LastName = ""
        .FirstName = ""
        .LastKName = ""
        .FirstKName = ""
        .Birth = 0
        .Gender = 0
        .OrgBsdCd = ""
        .OrgBsdName = ""
        .OrgRoomCd = ""
        .OrgRoomName = ""
        .OrgPostCd = ""
        .OrgPostName = ""
        .JobCd = ""
        .JobName = ""
        .DutyCd = ""
        .DutyName = ""
        .QualifyCd = ""
        .QualifyName = ""
        .IsrSign = ""
        .IsrNo = ""
        .RelationCd = ""
        .BranchNo = 0
        .EmpNo = ""
        .HireDate = 0
        .EmpDiv = ""
'## 2003.01.29 Add 1Line By T.Takagi@FSIT 従業員区分名称対応
        .EmpName = ""
'## 2003.01.29 Add End
        .HongenDiv = ""
        .Tel1 = ""
        .Tel2 = ""
        .Tel3 = ""
        .ZipCd1 = ""
        .ZipCd2 = ""
        .Address1 = ""
        .Address2 = ""
'## 2003.02.07 Add 1Line By T.Takagi@FSIT 受診希望日対応
        .CslDate = 0
'## 2003.02.07 Add End
    End With

End Sub

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
    WriteErrorLog "Cooperation.PutHainsLog"
    
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
