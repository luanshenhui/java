VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Common"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const ORGCD1_PERSON     As String = "XXXXX"     '個人受診
Private Const ORGCD2_PERSON     As String = "XXXXX"     '個人受診
Private Const ORGCD1_WEB        As String = "WWWWW"     'ウェブ予約
Private Const ORGCD2_WEB        As String = "WWWWW"     'ウェブ予約

'初期化ファイル読み込み用各種定義
Private Const FILENAME          As String = "Hains.ini" 'INIファイル名
Private Const FILEHSPNAME       As String = "hospital.ini" 'INIファイル名
Private Const BUFFERSIZE        As Long = 128           '読込バッファのサイズ
    
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" _
                         (ByVal lpApplicationName As String, _
                          ByVal lpKeyName As Any, _
                          ByVal lpDefault As String, _
                          ByVal lpReturnedString As String, _
                          ByVal nSize As Long, _
                          ByVal lpFileName As String) As Long
                          
'
' 機能　　 : ConnectStringプロパティ
'
' 戻り値　 : Oracle接続文字列
'
' 備考　　 : 初期化ファイルより取得
'
Public Property Get ConnectString() As String
    
    ConnectString = ReadIniFile("CONNECTION", "CONNECTSTRING")

End Property

'
' 機能　　 : Passwordプロパティ
'
' 戻り値　 : Oracle接続ユーザのパスワード
'
' 備考　　 : 初期化ファイルより取得
'
Public Property Get Password() As String
    
    Password = ReadIniFile("CONNECTION", "PASSWORD")

End Property

'
' 機能　　 : UserNameプロパティ
'
' 戻り値　 : Oracle接続ユーザ
'
' 備考　　 : 初期化ファイルより取得
'
Public Property Get UserName() As String
    
    UserName = ReadIniFile("CONNECTION", "USERNAME")

End Property

'
' 機能　　 : 配列への要素追加
'
' 引数　　 : (In/Out) vntArray  配列
' 　　　　   (In)     strItem   要素
' 　　　　   (In)     blnForce  True指定時は要素が存在しない場合でも追加を行う
'
' 備考　　 : バリアント配列の最後部に要素を追加する
'
Public Sub AppendArray(ByRef vntArray As Variant, ByVal strItem As String, Optional blnForce As Boolean = False)

    Dim i   As Long 'インデックス
    
    '要素がなければ何もしない
    If blnForce = False And Trim(strItem) = "" Then
        Exit Sub
    End If
    
    '配列でない場合は新規配列を作成
    If Not IsArray(vntArray) Then
        vntArray = Array(Trim(strItem))
        Exit Sub
    End If
    
    '配列の最後部に要素を追加
    i = UBound(vntArray) + 1
    ReDim Preserve vntArray(i)
    vntArray(i) = Trim(strItem)
    
End Sub

'
' 機能　　 : 半角英数字チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckAlphabetAndNumeric(ByVal strItemName As String, ByVal strExpression, ByVal lngLength As Long, Optional lngNecessary As Long) As String

    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If Len(Trim(strExpression)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角英数字で入力して下さい。"
            Exit Do
        End If
        
        '半角数字チェック
        For i = 1 To Len(Trim(strExpression))
        
            '半角数字以外の文字が現れたらチェックを中止する
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Asc("0") To Asc("9"), Asc("A") To Asc("Z"), Asc("a") To Asc("z")
                Case Else
                    strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角英数字で入力して下さい。"
                    Exit Do
            End Select
            
        Next i
        
        Exit Do
    Loop
    
    CheckAlphabetAndNumeric = strMessage
    
End Function

'
' 機能　　 : 権限チェック
'
' 引数　　 : (In)     lngBusinessCd   業務コード
' 　　　　   (In)     strURL          チェック対象ページのURL
' 　　　　   (In)     lngAuthority    権限
' 　　　　   (Out)    vntMessage      権限がない場合のメッセージ
'
' 戻り値　 : True   権限あり
' 　　　　   False  権限なし
'
' 備考　　 : ①今回は権限値のみをチェックし、更新の可否のみをチェックする。
' 　　　　   ②URL文字列に関しては将来的拡張機能のために用意。今回は未使用。
'
Public Function CheckAuthority( _
    ByVal lngBusinessCd As BUSINESSCD, _
    ByVal strURL As String, _
    ByVal lngAuthority As AUTHORITY, _
    ByRef vntMessage As Variant _
) As Boolean

    Dim strMessage  As String   'メッセージ
    Dim Ret         As Boolean  '関数戻り値
    
    '初期処理
    vntMessage = Empty
    Ret = True
    
    Do
        '更新権限を持つ場合は処理を終了する
        If lngAuthority = AUTHORITY_FULL Then
            Exit Do
        End If
        
        '権限がない場合のメッセージ作成
        Select Case lngBusinessCd
        
            'テーブルメンテナンス
            Case BUSINESSCD_MAINTENANCE
            
                strMessage = "テーブルメンテナンス"
                
            '予約
            Case BUSINESSCD_RESERVE
            
                strMessage = "予約"
                
            '結果入力
            Case BUSINESSCD_RESULT
            
                strMessage = "結果入力"
                
            '判定入力
            Case BUSINESSCD_JUDGEMENT
            
                strMessage = "判定入力"
                
            '印刷・データ抽出
            Case BUSINESSCD_PRINT
            
                strMessage = "印刷・データ抽出"
                
            '請求
            Case BUSINESSCD_DEMAND
                
                strMessage = "請求"
                
        End Select
        
        vntMessage = strMessage & "業務を行う権限がありません。"
        
        Ret = False
        Exit Do
    Loop
    
    '戻り値の設定
    CheckAuthority = Ret

End Function

'
' 機能　　 : 日付の妥当性チェックを行う
'
' 引数　　 : (In)     strItemName           項目名
' 　　　　 : (In)     vntYear               年
' 　　　　 : (In)     vntMonth              月
' 　　　　 : (In)     vntDay                日
' 　　　　 : (Out)    vntDate               年月日
' 　　　　 : (In)     lngNecessary          必須かどうか
'
' 戻り値　 : エラー値がある場合、エラーメッセージを返す
'
' 備考　　 : 妥当な日付の場合、年月日編集した日付を返す
'
Public Function CheckDate(ByVal strItemName As String, _
                          ByVal vntYear As Variant, _
                          ByVal vntMonth As Variant, _
                          ByVal vntDay As Variant, _
                          ByRef vntDate As Variant, _
                          Optional lngNecessary As Long _
                         ) As String

    Dim strDate     As String

    Do
        '必須指定の場合のみメッセージを返す
        If lngNecessary = CHECK_NECESSARY Then
            '未入力チェック
            If (Trim(vntYear) = "" And Trim(vntMonth) = "" And Trim(vntDay) = "") Or _
               (vntYear = 0 And vntMonth = 0 And vntDay = 0) Then
                CheckDate = strItemName & "を入力して下さい。"
                Exit Do
            End If
        End If

        '必須指定以外の場合、全て空白または0のとき何もしない
        If (Trim(vntYear) = "" And Trim(vntMonth) = "" And Trim(vntDay) = "") Or _
           (vntYear = 0 And vntMonth = 0 And vntDay = 0) Then
            Exit Do
        End If

        strDate = vntYear & "/" & vntMonth & "/" & vntDay

        '日付型でなかった場合
        If Trim(vntYear) = 0 Or Not IsDate(strDate) Then
            CheckDate = strItemName & "の入力形式が正しくありません。"
        Else
            vntDate = CDate(strDate)
        End If
        Exit Do
    Loop

End Function

'
' 機能　　 : E-Mail形式チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 : 以下の条件でチェックを行う
' 　　　　   (1)"@"がただ1つ存在
' 　　　　   (2)"@"の前後に文字列が存在
' 　　　　   (3)"@"の後の文字列に最低1つの"."が存在
'
Public Function CheckEMail(ByVal strItemName As String, ByVal strExpression) As String

    Dim lngPos      As Long     '"@"の検索位置
    Dim Ret         As Boolean  'チェック結果
    
    strExpression = Trim(strExpression)
    If strExpression = "" Then
        Exit Function
    End If
    
    Do
        '(1-1)"@"の存在チェック
        lngPos = InStr(1, strExpression, "@", vbBinaryCompare)
        If lngPos < 1 Then
            Exit Do
        End If
        
        '(1-2)"@"がもう1つ存在すれば不可
        If InStr(lngPos + 1, strExpression, "@", vbBinaryCompare) Then
            Exit Do
        End If
        
        '(2)"@"は先頭でも最後部でも不可
        If lngPos = 1 Or lngPos = Len(strExpression) Then
            Exit Do
        End If
        
        '(3)"@"の後に"."が存在
        If InStr(lngPos, strExpression, ".", vbBinaryCompare) < 1 Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    If Ret = False Then
        CheckEMail = strItemName & "の形式が正しくありません。"
    End If
        
End Function

'
' 機能　　 : カナ文字チェック
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : True   カナ文字のみで構成
' 　　　　   False  カナ文字以外の文字が存在
'
' 備考　　 :
'
Public Function CheckKana(ByVal strExpression As String) As Boolean

    Const KANA_STRING   As String = "゛゜ゝゞァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ・ーヽヾ･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ"

    Dim strToken        As String   '検索文字

    Dim i               As Long     'インデックス
'## 2002.12.18 Add 1Line by T.Takagi@FSIT 英数字は許可
    Dim strNarrow       As String   '半角変換後の文字列
'## 2002.12.18 Add End
    
'## 2002.12.18 Mod 52Lines by T.Takagi@FSIT 英数字は許可
'    '文字列式の文字を１文字ずつ検索
'    For i = 1 To Len(strExpression)
'
'        '検索文字の取得
'        strToken = Mid(strExpression, i, 1)
'
'        '検索文字が空白でなければ
'        If Trim(strToken) <> "" Then
'
'            '先に定義したカナ文字列の中に存在するかを検索
'            If InStr(KANA_STRING, strToken) <= 0 Then
'                Exit Function
'            End If
'
'        End If
'
'    Next i
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
'## 2002.12.18 Mod End
    
    '全て正常に検索できた場合の戻り値設定
    CheckKana = True
    
End Function

'
' 機能　　 : 文字列長チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckLength(ByVal strItemName As String, ByVal strExpression, ByVal lngLength As Long, Optional lngNecessary As Long) As Variant

    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '文字列長チェック
        If LenB(StrConv(Trim(strExpression), vbFromUnicode)) > lngLength Then
            strMessage = strItemName & "の入力内容が長すぎます。"
        End If
        
        Exit Do
    Loop
    
    CheckLength = strMessage
    
End Function

'
' 機能　　 : 半角チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 : 半角カナは許さない
'
Public Function CheckNarrowValue(ByVal strItemName As String, ByVal strExpression, ByVal lngLength As Long, Optional lngNecessary As Long) As String

    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If LenB(StrConv(Trim(strExpression), vbFromUnicode)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角文字で入力して下さい。"
            Exit Do
        End If
        
        '半角数字チェック
        For i = 1 To Len(Trim(strExpression))
        
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Is < 0, Asc("ｦ") To Asc("ﾟ"), Is > 255
                    strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角文字で入力して下さい。"
                    Exit Do
                Case Else
            End Select
            
        Next i
        
        Exit Do
    Loop
    
    CheckNarrowValue = strMessage
    
End Function

'
' 機能　　 : 半角数字チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckNumeric(ByVal strItemName As String, _
                             ByVal strExpression As String, _
                             ByVal lngLength As Long, _
                             Optional lngNecessary As Long) As String

    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If Len(Trim(strExpression)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
            Exit Do
        End If
        
        '半角数字チェック
        For i = 1 To Len(Trim(strExpression))
        
            '半角数字以外の文字が現れたらチェックを中止する
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Asc("0") To Asc("9")
                Case Else
                    strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
                    Exit Do
            End Select
            
        Next i
        
        Exit Do
    Loop
    
    CheckNumeric = strMessage
    
End Function
'
' 機能　　 : 半角数字・符号チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 : (-)返金発生の為、ファンクジョン追加 2005/09/30 張
'
Public Function CheckNumericSign(ByVal strItemName As String, _
                                 ByVal strExpression As String, _
                                 ByVal lngLength As Long, _
                                 Optional lngNecessary As Long) As String

    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If Len(Trim(strExpression)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
            Exit Do
        End If
        
        '半角数字チェック
        For i = 1 To Len(Trim(strExpression))
        
            '半角数字以外の文字が現れたらチェックを中止する
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Asc("0") To Asc("9")
                Case Asc("-")
                Case Else
                    strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
                    Exit Do
            End Select
            
        Next i
        
        Exit Do
    Loop
    
    CheckNumericSign = strMessage
    
End Function



'
' 機能　　 : 全角チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckWideValue(ByVal strItemName As String, ByVal strExpression, ByVal lngLength As Long, Optional lngNecessary As Long) As String

    Dim strMessage  As String   'エラーメッセージ
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If LenB(StrConv(StrConv(Trim(strExpression), vbWide), vbFromUnicode)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength / 2) & "文字以内の全角文字で入力して下さい。"
            Exit Do
        End If

        Exit Do
    Loop
    
    CheckWideValue = strMessage
    
End Function

'
' 機能　　 : Format関数の実装
'
' 引数　　 : (In)     strExpression  文字列式
' 　　　　 : (In)     strFormat      書式指定文字列
'
' 戻り値　 : 書式変換後の文字列
'
' 備考　　 :
'
Public Function FormatString(ByVal strExpression As String, ByVal strFormat As String) As Variant

    FormatString = Format(strExpression, strFormat)
    
End Function

'
' 機能　　 : 初期化ファイルから、指定されたセクション・キーにて定義された値を読み込む
'
' 引数　　 : (In)     strSectionName  セクション名
' 　　　　 : (In)     strKeyName      キー名
'
' 戻り値　 : 指定セクション・キーの定義値
'
' 備考　　 :
'
Public Function ReadIniFile(ByVal strSectionName As String, ByVal strKeyName As String) As String

    Dim strIniFileName  As String   '絶対パスによるINIファイル名
    Dim Buffer          As String   '読込内容格納バッファ
    
    '絶対パスによるINIファイル名の構築
    strIniFileName = App.Path & IIf(Right(App.Path, 1) <> "\", "\", "") & FILENAME
    
    'INIファイル読み込み
    Buffer = Space(BUFFERSIZE - 1)
    GetPrivateProfileString strSectionName, strKeyName, Empty, Buffer, BUFFERSIZE, strIniFileName
        
    ReadIniFile = Left(Buffer, InStr(Buffer, vbNullChar) - 1)

End Function

'
' 機能　　 : 初期化ファイルから、指定されたセクション・キーにて定義された値を読み込む
'
' 引数　　 : (In)     strSectionName  セクション名
' 　　　　 : (In)     strKeyName      キー名
'
' 戻り値　 : 指定セクション・キーの定義値
'
' 備考　　 :病院情報読み込み用
'
Private Function ReadHospitalIniFile(ByVal strSectionName As String, ByVal strKeyName As String) As String

    Dim strIniFileName  As String   '絶対パスによるINIファイル名
    Dim Buffer          As String   '読込内容格納バッファ
    
    '絶対パスによるINIファイル名の構築
    strIniFileName = App.Path & IIf(Right(App.Path, 1) <> "\", "\", "") & FILEHSPNAME
    
    'INIファイル読み込み
    Buffer = Space(BUFFERSIZE - 1)
    GetPrivateProfileString strSectionName, strKeyName, Empty, Buffer, BUFFERSIZE, strIniFileName
        
    ReadHospitalIniFile = Left(Buffer, InStr(Buffer, vbNullChar) - 1)

End Function

'
' 機能　　 : カナ文字の半角全角変換
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : 変換後の文字列
'
' 備考　　 :
'
Public Function StrConvKanaWide(ByVal strExpression As String) As String

    Dim strChar             As String   '検索文字
    Dim strKanaString       As String   '半角カナ文字列バッファ
    Dim strConvertedString  As String   '変換後の文字列
    Dim i                   As Long     'インデックス
        
    '文字列検索開始
    For i = 1 To Len(strExpression)
      
        '1文字取得
        strChar = Mid(strExpression, i, 1)

        '取得文字のASCIIコードを判定
        Select Case Asc(strChar)
        
            '半角カナ文字が連続している場合はカナ文字列として連結する
            Case Asc("ｦ") To Asc("ﾟ")
                strKanaString = strKanaString & strChar
        
            '半角カナ文字以外が現れたら
            Case Else
        
                'カナ文字列バッファに値が存在する場合はバッファ内容を全角変換し、変換後文字列に連結する
                If Len(strKanaString) > 0 Then
                    strConvertedString = strConvertedString & StrConv(strKanaString, vbWide)
                    strKanaString = ""
                End If
          
                '半角カナ以外の文字は単純に変換後の文字列に連結する
                strConvertedString = strConvertedString & strChar
      
        End Select
    
    Next i
    
    '全ての文字検索終了後、カナ文字列バッファに値が存在する場合はバッファ内容を全角変換し、変換後文字列に連結する
    If Len(strKanaString) > 0 Then
        strConvertedString = strConvertedString & StrConv(strKanaString, vbWide)
    End If
    
    StrConvKanaWide = strConvertedString

End Function

'
' 機能　　 : 本人扶養区分情報取得
'
' 引数　　 : (Out)    vntArrSupportFlg  本人扶養区分
' 　　　　   (Out)    vntArrSupportName 本人扶養区分名称
'
' 戻り値　 : 本人扶養区分情報件数
'
' 備考　　 :
'
Public Function SelectSupportList(ByRef vntArrSupportFlg As Variant, ByRef vntArrSupportName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("SUPPORTFLG", "CODE" & CStr(i))
        strName = ReadIniFile("SUPPORTFLG", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrSupportFlg) Then
            vntArrSupportFlg = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrSupportFlg) + 1
            ReDim Preserve vntArrSupportFlg(j)
            vntArrSupportFlg(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrSupportName) Then
            vntArrSupportName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrSupportName) + 1
            ReDim Preserve vntArrSupportName(j)
            vntArrSupportName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrSupportFlg) Then
        SelectSupportList = 0
    Else
        SelectSupportList = UBound(vntArrSupportFlg) + 1
    End If

End Function

'
' 機能　　 : 本人扶養区分名称取得
'
' 引数　　 : (In)     strSupportFlg   本人扶養区分
'
' 戻り値　 : 本人扶養区分名称
'
' 備考　　 :
'
Public Function SelectSupportFlgName(ByVal strSupportFlg As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strSupportName      As String   '本人扶養区分名称
    Dim i                   As Long     'インデックス
    
    Call SelectSupportList(vntCode, vntName)
    
    '本人扶養区分情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する本人扶養区分を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strSupportFlg Then
            '本人扶養区分名称を返す
            strSupportName = vntName(i)
            Exit For
        End If
    Next i

    SelectSupportFlgName = strSupportName

End Function

'
' 機能　　 : 婚姻区分情報取得
'
' 引数　　 : (Out)    vntArrMarriage        婚姻区分
' 　　　　   (Out)    vntArrMarriageName    婚姻区分名称
'
' 戻り値　 : 婚姻区分情報件数
'
' 備考　　 :
'
Public Function SelectMarriageList(ByRef vntArrMarriage As Variant, ByRef vntArrMarriageName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("MARRIAGE", "CODE" & CStr(i))
        strName = ReadIniFile("MARRIAGE", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrMarriage) Then
            vntArrMarriage = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrMarriage) + 1
            ReDim Preserve vntArrMarriage(j)
            vntArrMarriage(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrMarriageName) Then
            vntArrMarriageName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrMarriageName) + 1
            ReDim Preserve vntArrMarriageName(j)
            vntArrMarriageName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrMarriage) Then
        SelectMarriageList = 0
    Else
        SelectMarriageList = UBound(vntArrMarriage) + 1
    End If

End Function

'
' 機能　　 : 婚姻区分名称取得
'
' 引数　　 : (In)     strMarriage   婚姻区分
'
' 戻り値　 : 婚姻区分名称
'
' 備考　　 :
'
Public Function SelectMarriageName(ByVal strMarriage As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strMarriageName     As String   '婚姻区分名称
    Dim i                   As Long     'インデックス
    
    Call SelectMarriageList(vntCode, vntName)
    
    '婚姻区分情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する婚姻区分を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strMarriage Then
            '婚姻区分名称を返す
            strMarriageName = vntName(i)
            Exit For
        End If
    Next i

    SelectMarriageName = strMarriageName

End Function

'
' 機能　　 : 保険区分情報取得
'
' 引数　　 : (Out)    vntArrIsrDiv      保険区分
' 　　　　   (Out)    vntArrIsrDivName  保険区分名称
'
' 戻り値　 : 保険区分情報件数
'
' 備考　　 :
'
Public Function SelectIsrDivList(ByRef vntArrIsrDiv As Variant, ByRef vntArrIsrDivName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("ISRDIV", "CODE" & CStr(i))
        strName = ReadIniFile("ISRDIV", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrIsrDiv) Then
            vntArrIsrDiv = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrIsrDiv) + 1
            ReDim Preserve vntArrIsrDiv(j)
            vntArrIsrDiv(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrIsrDivName) Then
            vntArrIsrDivName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrIsrDivName) + 1
            ReDim Preserve vntArrIsrDivName(j)
            vntArrIsrDivName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrIsrDiv) Then
        SelectIsrDivList = 0
    Else
        SelectIsrDivList = UBound(vntArrIsrDiv) + 1
    End If

End Function

'
' 機能　　 : 保険区分名称取得
'
' 引数　　 : (In)     strIsrDiv     保険区分
'
' 戻り値　 : 保険区分名称
'
' 備考　　 :
'
Public Function SelectIsrDivName(ByVal strIsrDiv As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strIsrDivName       As String   '保険区分名称
    Dim i                   As Long     'インデックス
    
    Call SelectIsrDivList(vntCode, vntName)
    
    '保険区分情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する保険区分を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strIsrDiv Then
            '保険区分名称を返す
            strIsrDivName = vntName(i)
            Exit For
        End If
    Next i

    SelectIsrDivName = strIsrDivName

End Function

'
' 機能　　 : 外部キーによる整合性違反のキー番号チェック
'
' 引数　　 : (In)     strErrText            エラー内容（LastServerErrText）
'
' 戻り値　 : 整合性違反エラー値がある場合、キー識別番号を返す
' 　　　　   整合性違反エラー値がない場合、Trueを返す
'
' 備考　　 : LastServerErrが2291の時Callする
'
Public Function CheckFkeyErr(ByVal strErrText As String) As Long
    Dim i               As Long     'インデックス

    CheckFkeyErr = True
    
    'エラーメッセージがNullのとき、処理を抜ける
    If IsNull(strErrText) Then Exit Function
    
    '外部キー１～６までの整合性違反をチェックする
    For i = 1 To 6
        '"FKEY1"～"FKEY6"までの文字列を検索
        If InStr(1, strErrText, "FKEY" & CStr(i)) > 0 Then
            Select Case i
                Case 1: CheckFkeyErr = ALERT_FKEY1  '外部キー１の整合性違反
                Case 2: CheckFkeyErr = ALERT_FKEY2  '外部キー２の整合性違反
                Case 3: CheckFkeyErr = ALERT_FKEY3  '外部キー３の整合性違反
                Case 4: CheckFkeyErr = ALERT_FKEY4  '外部キー４の整合性違反
                Case 5: CheckFkeyErr = ALERT_FKEY5  '外部キー５の整合性違反
                Case 6: CheckFkeyErr = ALERT_FKEY6  '外部キー６の整合性違反
            End Select
            Exit For
        End If
    Next i

End Function

'
' 機能　　 : 表示行数情報取得（受診者一覧（結果入力））
'
' 引数　　 : (Out)    vntArrPageMaxLine     表示行数
' 　　　　   (Out)    vntArrPageMaxLineName 表示行数名称
'
' 戻り値　 : 表示行数情報件数
'
' 備考　　 :
'
Public Function SelectRslPageMaxLineList(ByRef vntArrPageMaxLine As Variant, ByRef vntArrPageMaxLineName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("RSLMAXLINE", "CODE" & CStr(i))
        strName = ReadIniFile("RSLMAXLINE", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrPageMaxLine) Then
            vntArrPageMaxLine = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrPageMaxLine) + 1
            ReDim Preserve vntArrPageMaxLine(j)
            vntArrPageMaxLine(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrPageMaxLineName) Then
            vntArrPageMaxLineName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrPageMaxLineName) + 1
            ReDim Preserve vntArrPageMaxLineName(j)
            vntArrPageMaxLineName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrPageMaxLine) Then
        SelectRslPageMaxLineList = 0
    Else
        SelectRslPageMaxLineList = UBound(vntArrPageMaxLine) + 1
    End If

End Function

'
' 機能　　 : 結果入力表示行数取得（受診者一覧（結果入力））
'
' 引数　　 : なし
'
' 戻り値　 : 結果入力表示行数
'
' 備考　　 : 規定値は”すべて表示”
'
Public Function SelectRslPageMaxLine() As String

    Dim strPageMaxLine  As String

    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("RSLMAXLINE", "PAGEMAXLINE")

    '未設定時は”すべて表示”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "*"
    End If
    
    SelectRslPageMaxLine = strPageMaxLine

End Function

'
' 機能　　 : 表示順情報取得
'
' 引数　　 : (Out)    vntArrSortKey     表示順
' 　　　　   (Out)    vntArrSortKeyName 表示順名称
'
' 戻り値　 : 表示順情報件数
'
' 備考　　 :
'
Public Function SelectRslSortKeyList(ByRef vntArrSortKey As Variant, ByRef vntArrSortKeyName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("RSLSORTKEY", "CODE" & CStr(i))
        strName = ReadIniFile("RSLSORTKEY", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrSortKey) Then
            vntArrSortKey = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrSortKey) + 1
            ReDim Preserve vntArrSortKey(j)
            vntArrSortKey(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrSortKeyName) Then
            vntArrSortKeyName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrSortKeyName) + 1
            ReDim Preserve vntArrSortKeyName(j)
            vntArrSortKeyName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrSortKey) Then
        SelectRslSortKeyList = 0
    Else
        SelectRslSortKeyList = UBound(vntArrSortKey) + 1
    End If

End Function

'
' 機能　　 : カレンダー当月表示位置情報取得
'
' 引数　　 : なし
'
' 戻り値　 : カレンダー当月表示位置
'
' 備考　　 :
'
Public Function SelectCalenderLocate() As String

    Dim strLocate       As String

    'LOCATE情報取得
    strLocate = ReadIniFile("CALENDER", "LOCATE")

    '未設定時は先頭を規定値とする
    If IsEmpty(strLocate) Then
        strLocate = CALENDER_TOP
    End If
    
    SelectCalenderLocate = strLocate

End Function

'
' 機能　　 : 生年月日（年）開始情報取得
'
' 引数　　 : (Out)    vntBirthStart     開始年
' 　　　　   (Out)    vntBirthDefault   年規定値
'
' 戻り値　 : なし
'
' 備考　　 :
'
Public Sub SelectYearsRangeBirth(ByRef vntBirthStart As Variant, ByRef vntBirthDefault As Variant)

    'YEARS_RANGE情報取得
    vntBirthStart = ReadIniFile("YEARS_RANGE", "BIRTH_START")
    If Not IsNumeric(vntBirthStart) Then
        vntBirthStart = Year(Now)
    End If
    vntBirthDefault = ReadIniFile("YEARS_RANGE", "BIRTH_DEFAULT")

End Sub

'
' 機能　　 : システム管理日付年範囲取得
'
' 引数　　 : (Out)    vntStartYear      開始年
' 　　　　   (Out)    vntEndYear        終了年
'
' 戻り値　 : なし
'
' 備考　　 : システム管理日付の対象となる開始年～終了年を取得
'
Public Sub SelectYearsRangeSystem(ByRef vntStartYear As Variant, ByRef vntEndYear As Variant)

    Dim strBeforeYear   As String       '過去年数
    Dim strAfterYear    As String       '未来年数

    'YEARS_RANGE情報取得
    strBeforeYear = ReadIniFile("YEARS_RANGE", "BEFORE_YEAR")
    strAfterYear = ReadIniFile("YEARS_RANGE", "AFTER_YEAR")
    
    'システム日より年数を加減算
    If Not IsNumeric(strBeforeYear) Then
        strBeforeYear = 10
    End If
    If Not IsNumeric(strAfterYear) Then
        strAfterYear = 3
    End If
    vntStartYear = Year(Now) - CLng(strBeforeYear)
    vntEndYear = Year(Now) + CLng(strAfterYear)
    
End Sub


'
' 機能　　 : 続柄情報取得
'
' 引数　　 : (Out)    vntArrRelation        続柄
' 　　　　   (Out)    vntArrRelationName    続柄名称
'
' 戻り値　 : 続柄情報件数
'
' 備考　　 :
'
Public Function SelectRelationList(ByRef vntArrRelation As Variant, ByRef vntArrRelationName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("RELATION", "CODE" & CStr(i))
        strName = ReadIniFile("RELATION", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrRelation) Then
            vntArrRelation = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrRelation) + 1
            ReDim Preserve vntArrRelation(j)
            vntArrRelation(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrRelationName) Then
            vntArrRelationName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrRelationName) + 1
            ReDim Preserve vntArrRelationName(j)
            vntArrRelationName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrRelation) Then
        SelectRelationList = 0
    Else
        SelectRelationList = UBound(vntArrRelation) + 1
    End If

End Function

'
' 機能　　 : 続柄名称取得
'
' 引数　　 : (In)     strRelation   続柄
'
' 戻り値　 : 続柄名称
'
' 備考　　 :
'
Public Function SelectRelationName(ByVal strRelation As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strRelationName     As String   '続柄名称
    Dim i                   As Long     'インデックス
    
    Call SelectRelationList(vntCode, vntName)
    
    '続柄情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する続柄を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strRelation Then
            '続柄名称を返す
            strRelationName = vntName(i)
            Exit For
        End If
    Next i

    SelectRelationName = strRelationName

End Function

'
' 機能　　 : フィルム番号－検査項目コード取得
'
' 引数　　 : (In)     vntKeyName        キー名称
' 　　　　   (Out)    vntItemCd         検査項目コード
' 　　　　   (Out)    vntSuffix         サフィックス
'
' 戻り値　 : なし
'
' 備考　　 : 検査項目コード(6桁)+サフィックス(2桁)で返す
'
Public Sub SelectRslFilmNo(ByVal vntKeyName As Variant, ByRef vntItemCd As Variant, ByRef vntSuffix As Variant)

    Dim vntKeyValue         As Variant
    
    'RSLFILMNO情報取得
    vntKeyValue = ReadIniFile("RSLFILMNO", vntKeyName)
    vntItemCd = Mid$(vntKeyValue, 1, 6)
    vntSuffix = Mid$(vntKeyValue, 7, 2)

End Sub

'
' 機能　　 : 状態情報取得
'
' 引数　　 : (Out)    vntArrCondition       状態
' 　　　　   (Out)    vntArrConditionName   状態名称
'
' 戻り値　 : 状態情報件数
'
' 備考　　 :
'
Public Function SelectConditionList(ByRef vntArrCondition As Variant, ByRef vntArrConditionName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("CONDITION", "CODE" & CStr(i))
        strName = ReadIniFile("CONDITION", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrCondition) Then
            vntArrCondition = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrCondition) + 1
            ReDim Preserve vntArrCondition(j)
            vntArrCondition(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrConditionName) Then
            vntArrConditionName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrConditionName) + 1
            ReDim Preserve vntArrConditionName(j)
            vntArrConditionName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrCondition) Then
        SelectConditionList = 0
    Else
        SelectConditionList = UBound(vntArrCondition) + 1
    End If

End Function

'
' 機能　　 : 状態名称取得
'
' 引数　　 : (In)     strCondition   状態
'
' 戻り値　 : 状態名称
'
' 備考　　 :
'
Public Function SelectConditionName(ByVal strCondition As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strConditionName    As String   '状態名称
    Dim i                   As Long     'インデックス
    
    Call SelectConditionList(vntCode, vntName)
    
    '状態情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する状態を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strCondition Then
            '状態名称を返す
            strConditionName = vntName(i)
            Exit For
        End If
    Next i

    SelectConditionName = strConditionName

End Function

'
' 機能　　 : 結果問診フラグ情報取得
'
' 引数　　 : (Out)  vntArrRslque        結果問診フラグ
' 　　　　   (Out)  vntArrRslqueName    結果問診フラグ名称
'
' 戻り値　 : 結果問診フラグ情報件数
'
' 備考　　 :
'
Public Function SelectRslqueList(ByRef vntArrRslque As Variant, ByRef vntArrRslqueName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("RSLQUE", "CODE" & CStr(i))
        strName = ReadIniFile("RSLQUE", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrRslque) Then
            vntArrRslque = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrRslque) + 1
            ReDim Preserve vntArrRslque(j)
            vntArrRslque(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrRslqueName) Then
            vntArrRslqueName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrRslqueName) + 1
            ReDim Preserve vntArrRslqueName(j)
            vntArrRslqueName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrRslque) Then
        SelectRslqueList = 0
    Else
        SelectRslqueList = UBound(vntArrRslque) + 1
    End If

End Function

'
' 機能　　 : 結果問診フラグ名称取得
'
' 引数　　 : (In)   strRslque           結果問診フラグ
'
' 戻り値　 : 結果問診フラグ名称
'
' 備考　　 :
'
Public Function SelectRslqueName(ByVal strRslque As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strRslqueName       As String   '結果問診フラグ名称
    Dim i                   As Long     'インデックス
    
    Call SelectRslqueList(vntCode, vntName)
    
    '結果問診フラグ情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する結果問診フラグを検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strRslque Then
            '結果問診フラグ名称を返す
            strRslqueName = vntName(i)
            Exit For
        End If
    Next i

    SelectRslqueName = strRslqueName

End Function

'
' 機能　　 : 項目タイプ情報取得
'
' 引数　　 : (Out)  vntArrItemType      項目タイプ
' 　　　　   (Out)  vntArrItemTypeName  項目タイプ名称
'
' 戻り値　 : 項目タイプ情報件数
'
' 備考　　 :
'
Public Function SelectItemTypeList(ByRef vntArrItemType As Variant, ByRef vntArrItemTypeName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("ITEMTYPE", "CODE" & CStr(i))
        strName = ReadIniFile("ITEMTYPE", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrItemType) Then
            vntArrItemType = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrItemType) + 1
            ReDim Preserve vntArrItemType(j)
            vntArrItemType(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrItemTypeName) Then
            vntArrItemTypeName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrItemTypeName) + 1
            ReDim Preserve vntArrItemTypeName(j)
            vntArrItemTypeName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrItemType) Then
        SelectItemTypeList = 0
    Else
        SelectItemTypeList = UBound(vntArrItemType) + 1
    End If

End Function

'
' 機能　　 : 項目タイプ名称取得
'
' 引数　　 : (In)   strItemType         項目タイプ
'
' 戻り値　 : 項目タイプ名称
'
' 備考　　 :
'
Public Function SelectItemTypeName(ByVal strItemType As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strItemTypeName     As String   '項目タイプ名称
    Dim i                   As Long     'インデックス
    
    Call SelectItemTypeList(vntCode, vntName)
    
    '項目タイプ情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する項目タイプを検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strItemType Then
            '項目タイプ名称を返す
            strItemTypeName = vntName(i)
            Exit For
        End If
    Next i

    SelectItemTypeName = strItemTypeName

End Function

'
' 機能　　 : 結果タイプ情報取得
'
' 引数　　 : (Out)  vntArrResultType        結果タイプ
' 　　　　   (Out)  vntArrResultTypeName    結果タイプ名称
'
' 戻り値　 : 結果タイプ情報件数
'
' 備考　　 :
'
Public Function SelectResultTypeList(ByRef vntArrResultType As Variant, ByRef vntArrResultTypeName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("RESULTTYPE", "CODE" & CStr(i))
        strName = ReadIniFile("RESULTTYPE", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrResultType) Then
            vntArrResultType = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrResultType) + 1
            ReDim Preserve vntArrResultType(j)
            vntArrResultType(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrResultTypeName) Then
            vntArrResultTypeName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrResultTypeName) + 1
            ReDim Preserve vntArrResultTypeName(j)
            vntArrResultTypeName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrResultType) Then
        SelectResultTypeList = 0
    Else
        SelectResultTypeList = UBound(vntArrResultType) + 1
    End If

End Function

'
' 機能　　 : 結果タイプ名称取得
'
' 引数　　 : (In)   strResultType       結果タイプ
'
' 戻り値　 : 結果タイプ名称
'
' 備考　　 :
'
Public Function SelectResultTypeName(ByVal strResultType As String) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strResultTypeName   As String   '結果タイプ名称
    Dim i                   As Long     'インデックス
    
    Call SelectResultTypeList(vntCode, vntName)
    
    '結果タイプ情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する結果タイプを検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = strResultType Then
            '結果タイプ名称を返す
            strResultTypeName = vntName(i)
            Exit For
        End If
    Next i

    SelectResultTypeName = strResultTypeName

End Function

'
' 機能　　 : 基準値フラグ－表示色取得
'
' 引数　　 : (In)   vntKeyName          キー名称
' 　　　　   (Out)  vntColor            表示色
'
' 戻り値　 : なし
'
' 備考　　 :
'
Public Sub SelectStdFlgColor(ByVal vntKeyName As Variant, ByRef vntColor As Variant)

    'STDFLG_COLOR情報取得
    vntColor = ReadIniFile("STDFLG_COLOR", vntKeyName)

End Sub

'
' 機能　　 : 結果入力コード規定値取得
'
' 引数　　 : (In)   vntKeyName          キー名称
'
' 戻り値　 : コード規定値
'
' 備考　　 :
'
Public Function SelectRslCode(ByVal vntKeyName As Variant) As String

    'RSLCODE情報取得
    SelectRslCode = ReadIniFile("RSLCODE", vntKeyName)

End Function

'
' 機能　　 : 一覧表示行数取得（受診者一覧）
'
' 引数　　 : なし
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 : 規定値は”すべて表示”
'
Public Function SelectDailyPageMaxLine() As String
    
    Dim strPageMaxLine  As String
    
    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("DAILYMAXLINE", "PAGEMAXLINE")
    
    '未設定時は”すべて表示”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "*"
    End If
    
    SelectDailyPageMaxLine = strPageMaxLine
    
End Function

'
' 機能　　 : 表示行数情報取得（受診者一覧）
'
' 引数　　 : (Out)  vntArrPageMaxLine       表示行数
' 　　　　   (Out)  vntArrPageMaxLineName   表示行数名称
'
' 戻り値　 : 表示行数情報件数
'
' 備考　　 :
'
Public Function SelectDailyPageMaxLineList(ByRef vntArrPageMaxLine As Variant, ByRef vntArrPageMaxLineName As Variant) As Long
    
    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("DAILYMAXLINE", "CODE" & CStr(i))
        strName = ReadIniFile("DAILYMAXLINE", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrPageMaxLine) Then
            vntArrPageMaxLine = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrPageMaxLine) + 1
            ReDim Preserve vntArrPageMaxLine(j)
            vntArrPageMaxLine(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrPageMaxLineName) Then
            vntArrPageMaxLineName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrPageMaxLineName) + 1
            ReDim Preserve vntArrPageMaxLineName(j)
            vntArrPageMaxLineName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop
    
    If Not IsArray(vntArrPageMaxLine) Then
        SelectDailyPageMaxLineList = 0
    Else
        SelectDailyPageMaxLineList = UBound(vntArrPageMaxLine) + 1
    End If
    
End Function

'
' 機能　　 : 時間枠情報取得
'
' 引数　　 : (Out)  vntArrTimeFra       時間枠
' 　　　　   (Out)  vntArrTimeFraName   時間枠名称
'
' 戻り値　 : 時間枠情報件数
'
' 備考　　 :
'
Public Function SelectTimeFraList(ByRef vntArrTimeFra As Variant, ByRef vntArrTimeFraName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("TIMEFRA", "CODE" & CStr(i))
        strName = ReadIniFile("TIMEFRA", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrTimeFra) Then
            vntArrTimeFra = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrTimeFra) + 1
            ReDim Preserve vntArrTimeFra(j)
            vntArrTimeFra(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrTimeFraName) Then
            vntArrTimeFraName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrTimeFraName) + 1
            ReDim Preserve vntArrTimeFraName(j)
            vntArrTimeFraName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrTimeFra) Then
        SelectTimeFraList = 0
    Else
        SelectTimeFraList = UBound(vntArrTimeFra) + 1
    End If

End Function

'
' 機能　　 : 時間枠名称取得
'
' 引数　　 : (In)   lngTimeFra          時間枠
'
' 戻り値　 : 時間枠名称
'
' 備考　　 :
'
Public Function SelectTimeFraName(ByVal lngTimeFra As Long) As String

    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strTimeFraName      As String   '時間枠名称
    Dim i                   As Long     'インデックス
    
    Call SelectTimeFraList(vntCode, vntName)
    
    '時間枠情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する時間枠を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = CStr(lngTimeFra) Then
            '時間枠名称を返す
            strTimeFraName = vntName(i)
            Exit For
        End If
    Next i

    SelectTimeFraName = strTimeFraName

End Function

'
' 機能　　 : 固定の団体コードの取得
'
' 引数　　 : (In)   strKey          検索キー
' 　　　　 : (Out)  vntOrgCd1       団体コード１
' 　　　　 : (Out)  vntOrgCd2       団体コード２
'
' 戻り値　 : なし
'
' 備考　　 :
'
Public Sub GetOrgCd(ByVal strKey As String, ByRef vntOrgCd1 As Variant, ByRef vntOrgCd2 As Variant)
    
    '初期値設定
    vntOrgCd1 = Empty
    vntOrgCd2 = Empty
    
    '指定された検索キーにより、固定の団体コードを返す
    Select Case strKey
        Case ORGCD_KEY_PERSON               '個人受診
            vntOrgCd1 = ORGCD1_PERSON
            vntOrgCd2 = ORGCD2_PERSON
        Case ORGCD_KEY_WEB                  'ウェブ予約
            vntOrgCd1 = ORGCD1_WEB
            vntOrgCd2 = ORGCD2_WEB
    End Select
    
End Sub

'
' 機能　　 : 病院情報取得
'
' 引数　　 : (Out)    vntName       病院名
' 　　　　   (Out)    vntCenter     センター名
' 　　　　   (Out)    vntZipCd      郵便番号
' 　　　　   (Out)    vntAddress1   住所１
' 　　　　   (Out)    vntAddress2   住所２
' 　　　　   (Out)    vntTel        電話番号
' 　　　　   (Out)    vntFax        ファックス番号
' 　　　　   (Out)    vntInLineNo   内線
'
' 戻り値　 : なし
'
' 備考　　 :
'
Public Function SelectHospitalInfomation( _
              ByRef vntName As Variant, _
              ByRef vntCenter As Variant, _
              ByRef vntZipCd As Variant, _
              ByRef vntAddress1 As Variant, _
              ByRef vntAddress2 As Variant, _
              ByRef vntTel As Variant, _
              ByRef vntFax As Variant, _
              ByRef vntInLineNo As Variant) As Long

        
    vntName = ReadHospitalIniFile("INFORMATION", "NAME")
    vntCenter = ReadHospitalIniFile("INFORMATION", "CENTER")
    vntZipCd = ReadHospitalIniFile("INFORMATION", "ZIPCD")
    vntAddress1 = ReadHospitalIniFile("INFORMATION", "ADDRESS1")
    vntAddress2 = ReadHospitalIniFile("INFORMATION", "ADDRESS2")
    vntTel = ReadHospitalIniFile("INFORMATION", "TEL")
    vntFax = ReadHospitalIniFile("INFORMATION", "FAX")
    vntInLineNo = ReadHospitalIniFile("INFORMATION", "INLINENO")

End Function

'
' 機能　　 : 一覧表示行数取得（団体予約～名簿）
'
' 引数　　 : (In)   lngListKind          一覧種別
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 : デフォルトは10
' 　　　　   一覧種別は1:名簿受診者一覧(MemInfo)
' 　　　　   　　　　　2:名簿(Member)
' 　　　　   　　　　　3:名簿一覧(MemList)
'
Public Function SelectRsvOrgPageMaxLine(ByVal lngListKind As Long) As String
    
    Dim strPageMaxLine  As String
    
    'PAGEMAXLINE情報取得
    Select Case lngListKind
        Case 1: strPageMaxLine = ReadIniFile("RESERVEORG", "MEMINFOPAGEMAXLINE")
        Case 2: strPageMaxLine = ReadIniFile("RESERVEORG", "MEMBERPAGEMAXLINE")
        Case 3: strPageMaxLine = ReadIniFile("RESERVEORG", "MEMLISTPAGEMAXLINE")
    End Select
    
    '未設定時は10行を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "10"
    End If
    
    SelectRsvOrgPageMaxLine = strPageMaxLine
    
End Function
'
' 機能　　 : 一覧表示行数取得（受診者進捗状況）
'
' 引数　　 : なし
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 : 規定値は”すべて表示”
'
Public Function SelectProgressPageMaxLine() As String
    
    Dim strPageMaxLine  As String
    
    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("PROGRESMAXLINE", "PAGEMAXLINE")
    
    '未設定時は”すべて表示”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "10"
    End If
    
    SelectProgressPageMaxLine = strPageMaxLine
    
End Function


'
' 機能　　 : 受診希望曜日指定フラグ取得
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectWeekDayFlg() As String

    'WEEKDAYFLG情報取得
    SelectWeekDayFlg = ReadIniFile("RESERVEORG", "WEEKDAYFLG")

End Function

'
' 機能　　 : 休日祝日フラグ取得
'
' 引数　　 : なし
'
' 戻り値　 : 値(0=予約を許さない 1=予約を許す)
'
' 備考　　 :
'
Public Function SelectHolidayFlg() As String

    'HOLIDAYFLG情報取得
    SelectHolidayFlg = ReadIniFile("RESERVE", "HOLIDAYFLG")

End Function

'
' 機能　　 : 帳票削除日数取得
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectDeleteInterval() As String

    'DELETEINTERVAL情報取得
    SelectDeleteInterval = ReadIniFile("REPORT", "DELETEINTERVAL")

End Function

'
' 機能　　 : 管理番号制御フラグ取得
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectCntlFlg() As String

    'CNTLNO_ENABLED情報取得
    SelectCntlFlg = ReadIniFile("RSLCNTL", "CNTLNO_ENABLED")

End Function

'
' 機能　　 : 結果入力カーソル方向
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectRslOrientation() As String

    Dim strOrientation      As String       '入力方向
    
    'ORIENTATION情報取得
    strOrientation = ReadIniFile("RSLORIENTATION", "ORIENTATION")

    If IsEmpty(strOrientation) Then
        strOrientation = ORIENTATION_PORTRAIT
    End If

    SelectRslOrientation = strOrientation

End Function

'
' 機能　　 : 受付・終了時間情報取得
'
' 引数　　 : (Out)    vntReSTimeH    受付時間（開始時）
' 　　　　 : (Out)    vntReSTimeM    受付時間 (開始分）
' 　　　　 : (Out)    vntReETimeH    受付時間（終了時）
' 　　　　 : (Out)    vntReETimeM    受付時間（終了分）
' 　　　　 : (Out)    vntEnSTimeH    終了時間（開始時）
' 　　　　 : (Out)    vntEnSTimeM    終了時間（開始分）
' 　　　　 : (Out)    vntEnETimeH    終了時間（終了時）
' 　　　　 : (Out)    vntEnETimeM    終了時間（終了分）
'
' 戻り値　 : なし
'
' 備考　　 :
'
Public Sub SelectPrtOshirase(ByRef vntReSTimeH As Variant, ByRef vntReSTimeM As Variant, _
                             ByRef vntReETimeH As Variant, ByRef vntReETimeM As Variant, _
                             ByRef vntEnSTimeH As Variant, ByRef vntEnSTimeM As Variant, _
                             ByRef vntEnETimeH As Variant, ByRef vntEnETimeM As Variant)

    '情報取得
    vntReSTimeH = ReadIniFile("PRTOSHIRASE", "RECEIPT_STIMEH")
    vntReSTimeM = ReadIniFile("PRTOSHIRASE", "RECEIPT_STIMEM")
    vntReETimeH = ReadIniFile("PRTOSHIRASE", "RECEIPT_ETIMEH")
    vntReETimeM = ReadIniFile("PRTOSHIRASE", "RECEIPT_ETIMEM")
    vntEnSTimeH = ReadIniFile("PRTOSHIRASE", "END_STIMEH")
    vntEnSTimeM = ReadIniFile("PRTOSHIRASE", "END_STIMEM")
    vntEnETimeH = ReadIniFile("PRTOSHIRASE", "END_ETIMEH")
    vntEnETimeM = ReadIniFile("PRTOSHIRASE", "END_ETIMEM")

End Sub

'
' 機能　　 : インターバル取得
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectInterval() As String

    'INTERVAL情報取得
    SelectInterval = ReadIniFile("RESERVEORG", "INTERVAL")

End Function
'
' 機能　　 : 予約枠が存在しない場合、予約を許さないフラグ取得
'
' 引数　　 : なし
'
' 戻り値　 : 値（0=許さない 1=許す）
'
' 備考　　 :
'
Public Function SelectReserveFra() As String

    'RESERVEFRA情報取得
    SelectReserveFra = ReadIniFile("RESERVEORG", "RESERVEFRA")

End Function

'
' 機能　　 : 検査結果時系列の表示歴数取得
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectHistoryCount() As Long

    'HISTORY_COUNT情報取得
    SelectHistoryCount = CLng("0" & ReadIniFile("RSLHISTORY", "HISTORY_COUNT"))

End Function

'
' 機能　　 : 「判定が悪い人」の重み取得
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectJudBadWeight() As Long

    'BAD_WEIGHT情報取得
    SelectJudBadWeight = CLng("0" & ReadIniFile("JUDGEMENT", "BAD_WEIGHT"))

End Function

'
' 機能　　 : 全角カナの小さい文字を大きい文字に置換
'
' 引数　　 : (In)     strStream  被変換文字列
'
' 戻り値　 : 変換後の文字列
'
' 備考　　 :
'
Public Function ReplaceKanaString(ByRef strStream As String) As String

    Dim strBuffer   As String   '文字列バッファ
    
    strBuffer = strStream
    strBuffer = Replace(strBuffer, "ァ", "ア")
    strBuffer = Replace(strBuffer, "ィ", "イ")
    strBuffer = Replace(strBuffer, "ゥ", "ウ")
    strBuffer = Replace(strBuffer, "ェ", "エ")
    strBuffer = Replace(strBuffer, "ォ", "オ")
    strBuffer = Replace(strBuffer, "ッ", "ツ")
    strBuffer = Replace(strBuffer, "ャ", "ヤ")
    strBuffer = Replace(strBuffer, "ュ", "ユ")
    strBuffer = Replace(strBuffer, "ョ", "ヨ")

    ReplaceKanaString = strBuffer
    
End Function

'
' 機能　　 : 「２次健診を前回判定表示に含めない」フラグ取得
'
' 引数　　 : なし
'
' 戻り値　 : 値
'
' 備考　　 :
'
Public Function SelectBefJudCourseFlg() As String

    'BEFORE_JUD_COURSE情報取得
    SelectBefJudCourseFlg = ReadIniFile("JUDGEMENT", "BEFORE_JUD_COURSE")

End Function

'
' 機能　　 : 一覧表示行数（判定コメントガイド）取得
'
' 引数　　 : なし
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 :
'
Public Function SelectJudCmtStcPageMaxLine() As Long

    'PAGEMAXLINE情報取得
    SelectJudCmtStcPageMaxLine = CLng("0" & ReadIniFile("JUDCMTSTC", "PAGEMAXLINE"))

End Function

'
' 機能　　 : 一覧表示行数取得（個人別請求金額修正の受診者一覧）
'
' 引数　　 : なし
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 : 規定値は”20”
'
Public Function SelectDmdSearchPageMaxLine() As String
    
    Dim strPageMaxLine  As String
    
    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("DMDSARHMAXLINE", "PAGEMAXLINE")
    
    '未設定時は”20”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "20"
    End If
    
    SelectDmdSearchPageMaxLine = strPageMaxLine
    
End Function

'
' 機能　　 : 一覧表示行数取得（負担元別請求情報一覧）
'
' 引数　　 : なし
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 : 規定値は”20”
'
Public Function SelectDmdBurdenListPageMaxLine() As String
    
    Dim strPageMaxLine  As String
    
    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("DMDBDNLISTMAXLINE", "PAGEMAXLINE")
    
    '未設定時は”20”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "20"
    End If
    
    SelectDmdBurdenListPageMaxLine = strPageMaxLine
    
End Function

'
' 機能　　 : 一覧表示行数取得（負担元別請求情報修正の受診者一覧）
'
' 引数　　 : なし
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 : 規定値は”20”
'
Public Function SelectDmdOrgListPageMaxLine() As String
    
    Dim strPageMaxLine  As String
    
    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("DMDORGLISTMAXLINE", "PAGEMAXLINE")
    
    '未設定時は”20”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "20"
    End If
    
    SelectDmdOrgListPageMaxLine = strPageMaxLine
    
End Function

'
' 機能　　 : 一覧表示行数取得（入金処理の団体一覧）
'
' 引数　　 : なし
'
' 戻り値　 : 一覧表示行数
'
' 備考　　 : 規定値は”20”
'
Public Function SelectDmdPaymentSearchPageMaxLine() As String
    
    Dim strPageMaxLine  As String
    
    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("DMDPAYSARHMAXLINE", "PAGEMAXLINE")
    
    '未設定時は”20”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "20"
    End If
    
    SelectDmdPaymentSearchPageMaxLine = strPageMaxLine
    
End Function

'
' 機能　　 : 表示行数取得（経年変化）
'
' 引数　　 : なし
'
' 戻り値　 : 結果入力表示行数
'
' 備考　　 : 規定値は”すべて表示”
'
Public Function SelectInqHistoryCount() As String

    Dim strHisCount  As String

    'PAGEMAXLINE情報取得
    strHisCount = ReadIniFile("INQHISTORY", "HISCOUNT")

    '未設定時は”すべて表示”を規定値とする
    If IsEmpty(strHisCount) Then
        strHisCount = "*"
    End If
    
    SelectInqHistoryCount = strHisCount

End Function

'
' 機能　　 : 表示行数情報取得（経年変化）
'
' 引数　　 : (Out)    vntArrHisCount     表示行数
' 　　　　   (Out)    vntArrHisCountName 表示行数名称
'
' 戻り値　 : 表示行数情報件数
'
' 備考　　 :
'
Public Function SelectInqHistoryCountList(ByRef vntArrHisCount As Variant, ByRef vntArrHisCountName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("INQHISTORY", "CODE" & CStr(i))
        strName = ReadIniFile("INQHISTORY", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrHisCount) Then
            vntArrHisCount = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrHisCount) + 1
            ReDim Preserve vntArrHisCount(j)
            vntArrHisCount(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrHisCountName) Then
            vntArrHisCountName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrHisCountName) + 1
            ReDim Preserve vntArrHisCountName(j)
            vntArrHisCountName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrHisCount) Then
        SelectInqHistoryCountList = 0
    Else
        SelectInqHistoryCountList = UBound(vntArrHisCount) + 1
    End If

End Function

'
' 機能　　 : 半角数字チェック（符号付き）
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckNumericWithSign(ByVal strItemName As String, ByVal strExpression, ByVal lngLength As Long, Optional lngNecessary As Long) As String
    
    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
    
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
    
            Exit Do
        End If
    
        '半角数字・マイナス符号チェック
        For i = 1 To Len(Trim(strExpression))
    
            '半角数字・マイナス符号以外の文字が現れたらチェックを中止する
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Asc("0") To Asc("9")
                Case Asc("-")
                Case Else
                    strMessage = strItemName & "は" & CStr(lngLength) & "桁以内の半角数字（小数なし）で入力して下さい。"
                    Exit Do
            End Select
    
        Next i
    
        '数値チェック
        If Not IsNumeric(Trim(strExpression)) Then
            strMessage = strItemName & "は" & CStr(lngLength) & "桁以内の半角数字（小数なし）で入力して下さい。"
            Exit Do
        End If
    
        '桁数チェック
        If CLng(Trim(strExpression)) > 0 And Len(Trim(strExpression)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength) & "桁以内の半角数字（小数なし）で入力して下さい。"
            Exit Do
        ElseIf CLng(Trim(strExpression)) < 0 And Len(Trim(strExpression)) > (lngLength + 1) Then
            strMessage = strItemName & "は" & CStr(lngLength) & "桁以内の半角数字（小数なし）で入力して下さい。"
            Exit Do
        End If
    
        Exit Do
    Loop
    
    CheckNumericWithSign = strMessage
    
End Function

'
' 機能　　 : 請求締め処理ＥＸＥ名取得
'
' 引数　　 : なし
'
' 戻り値　 : 請求締め処理ＥＸＥ名
'
' 備考　　 :
'
Public Function SelectDmdAddUpExeName() As String
    
    '請求締め処理ＥＸＥ名取得
    SelectDmdAddUpExeName = ReadIniFile("DMDADDUP", "EXENAME")
    
End Function

'
' 機能　　 : 請求締め処理ログ出力先フォルダ取得
'
' 引数　　 : なし
'
' 戻り値　 : 請求締め処理ログ出力先フォルダ
'
' 備考　　 :
'
Public Function SelectDmdAddUpLogPath() As String
    
    '請求締め処理ログ出力先フォルダ取得
    SelectDmdAddUpLogPath = ReadIniFile("DMDADDUP", "LOGPATH")
    
End Function

'
' 機能　　 : 請求締め処理ロールバックセグメント名取得
'
' 引数　　 : なし
'
' 戻り値　 : 請求締め処理ロールバックセグメント名
'
' 備考　　 :
'
Public Function SelectDmdAddUpRbsName() As String
    
    '請求締め処理ロールバックセグメント名取得
    SelectDmdAddUpRbsName = ReadIniFile("DMDADDUP", "RBSNAME")
    
End Function

'
' 機能　　 : 請求明細の明細区分情報取得
'
' 引数　　 : (Out)  vntArrLineDiv       明細区分
' 　　　　   (Out)  vntArrLineDivName   明細区分名称
'
' 戻り値　 : 明細区分情報件数
'
' 備考　　 :
'
Public Function SelectLineDivList(ByRef vntArrLineDiv As Variant, ByRef vntArrLineDivName As Variant) As Long
    
    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
    
        'CODE,NAME情報取得
        strCode = ReadIniFile("BILLDETAIL_LINEDIV", "CODE" & CStr(i))
        strName = ReadIniFile("BILLDETAIL_LINEDIV", "NAME" & CStr(i))
    
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
    
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrLineDiv) Then
            vntArrLineDiv = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrLineDiv) + 1
            ReDim Preserve vntArrLineDiv(j)
            vntArrLineDiv(j) = Trim(strCode)
        End If
    
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrLineDivName) Then
            vntArrLineDivName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrLineDivName) + 1
            ReDim Preserve vntArrLineDivName(j)
            vntArrLineDivName(j) = Trim(strName)
        End If
    
        i = i + 1
    Loop
    
    If Not IsArray(vntArrLineDiv) Then
        SelectLineDivList = 0
    Else
        SelectLineDivList = UBound(vntArrLineDiv) + 1
    End If
    
End Function

'
' 機能　　 : 請求明細の明細区分名称取得
'
' 引数　　 : (In)   lngLineDiv          明細区分
'
' 戻り値　 : 明細区分名称
'
' 備考　　 :
'
Public Function SelectLineDivName(ByVal lngLineDiv As Long) As String
    
    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strLineDivName      As String   '明細区分名称
    Dim i                   As Long     'インデックス
    
    Call SelectLineDivList(vntCode, vntName)
    
    '明細区分情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する明細区分を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = CStr(lngLineDiv) Then
            '明細区分名称を返す
            strLineDivName = vntName(i)
            Exit For
        End If
    Next i
    
    SelectLineDivName = strLineDivName
    
End Function

'
' 機能　　 : 入金種別情報取得
'
' 引数　　 : (Out)  vntArrPaymentDiv        入金種別
' 　　　　   (Out)  vntArrPaymentDivName    入金種別名称
'
' 戻り値　 : 入金種別情報件数
'
' 備考　　 :
'
Public Function SelectPaymentDivList(ByRef vntArrPaymentDiv As Variant, ByRef vntArrPaymentDivName As Variant) As Long
    
    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
    
        'CODE,NAME情報取得
        strCode = ReadIniFile("PAYMENTDIV", "CODE" & CStr(i))
        strName = ReadIniFile("PAYMENTDIV", "NAME" & CStr(i))
    
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
    
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrPaymentDiv) Then
            vntArrPaymentDiv = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrPaymentDiv) + 1
            ReDim Preserve vntArrPaymentDiv(j)
            vntArrPaymentDiv(j) = Trim(strCode)
        End If
    
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrPaymentDivName) Then
            vntArrPaymentDivName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrPaymentDivName) + 1
            ReDim Preserve vntArrPaymentDivName(j)
            vntArrPaymentDivName(j) = Trim(strName)
        End If
    
        i = i + 1
    Loop
    
    If Not IsArray(vntArrPaymentDiv) Then
        SelectPaymentDivList = 0
    Else
        SelectPaymentDivList = UBound(vntArrPaymentDiv) + 1
    End If
    
End Function

'
' 機能　　 : 入金種別名称取得
'
' 引数　　 : (In)   lngPaymentDiv       入金種別
'
' 戻り値　 : 入金種別名称
'
' 備考　　 :
'
Public Function SelectPaymentDivName(ByVal lngPaymentDiv As Long) As String
    
    Dim vntCode             As Variant
    Dim vntName             As Variant
    Dim strPaymentDivName   As String   '入金種別名称
    Dim i                   As Long     'インデックス
    
    Call SelectPaymentDivList(vntCode, vntName)
    
    '入金種別情報が登録されていない場合何もしない
    If Not IsArray(vntCode) Then
        Exit Function
    End If
    
    '一致する入金種別を検索
    For i = LBound(vntCode) To UBound(vntCode)
        If vntCode(i) = CStr(lngPaymentDiv) Then
            '入金種別名称を返す
            strPaymentDivName = vntName(i)
            Exit For
        End If
    Next i
    
    SelectPaymentDivName = strPaymentDivName
    
End Function

'
' 機能　　 : 結果入力表示行数取得（受診者一覧（結果入力））
'
' 引数　　 : なし
'
' 戻り値　 : 結果入力表示行数
'
' 備考　　 : 規定値は”すべて表示”
'
Public Function SelectPaymentPageMaxLine() As String

    Dim strPageMaxLine  As String

    'PAGEMAXLINE情報取得
    strPageMaxLine = ReadIniFile("DMDPAYMENT", "PAGEMAXLINE")

    '未設定時は”すべて表示”を規定値とする
    If IsEmpty(strPageMaxLine) Then
        strPageMaxLine = "*"
    End If
    
    SelectPaymentPageMaxLine = strPageMaxLine

End Function

'
' 機能　　 : 半角数字チェック（小数点あり）
'
' 引数　　 : (In)     strItemName        項目名
' 　　　　   (In)     strExpression      文字列式
' 　　　　   (In)     lngLength          桁数（全体）
' 　　　　   (In)     lngDecPointLength  桁数（小数部）
' 　　　　   (In)     lngNecessary       必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckNumericDecimalPoint(ByVal strItemName As String, ByVal strExpression, ByVal lngLength As Long, ByVal lngDecPointLength As Long, Optional lngNecessary As Long) As String

    Dim strMessage      As String   'エラーメッセージ
    Dim vntExpression   As Variant  '文字列式
    Dim i               As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If Len(Trim(strExpression)) > (lngLength + 1) Then
            strMessage = strItemName & "は整数" & CStr(lngLength - lngDecPointLength) & "桁、小数" & CStr(lngDecPointLength) & "桁以内の半角数字で入力して下さい。"
            Exit Do
        End If
        
        '半角数字チェック
        For i = 1 To Len(Trim(strExpression))
        
            '半角数字以外の文字が現れたらチェックを中止する
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Asc("0") To Asc("9"), Asc(".")
                Case Else
                    strMessage = strItemName & "は整数" & CStr(lngLength - lngDecPointLength) & "桁、小数" & CStr(lngDecPointLength) & "桁以内の半角数字で入力して下さい。"
                    Exit Do
            End Select
            
        Next i
        
        '小数点数チェック
        vntExpression = Split(strExpression, ".")
        If IsArray(vntExpression) Then
            If UBound(vntExpression) > 1 Then
                strMessage = strItemName & "は小数点を１つまでの整数" & CStr(lngLength - lngDecPointLength) & "桁、小数" & CStr(lngDecPointLength) & "桁以内の半角数字で入力して下さい。"
                Exit Do
            End If
        End If
        
        '整数部と小数部に分解
        If InStr(strExpression, ".") = 0 Then
            vntExpression = Split(strExpression & ".", ".")
        Else
            vntExpression = Split(strExpression, ".")
        End If
        
        '整数部桁数チェック
        If Len(Trim(vntExpression(0))) > (lngLength - lngDecPointLength) Then
            strMessage = strItemName & "は整数" & CStr(lngLength - lngDecPointLength) & "桁、小数" & CStr(lngDecPointLength) & "桁以内の半角数字で入力して下さい。"
            Exit Do
        End If
        
        '小数部桁数チェック
        If Len(Trim(vntExpression(1))) > lngDecPointLength Then
            strMessage = strItemName & "は整数" & CStr(lngLength - lngDecPointLength) & "桁、小数" & CStr(lngDecPointLength) & "桁以内の半角数字で入力して下さい。"
            Exit Do
        End If
        Exit Do
    Loop
    
    CheckNumericDecimalPoint = strMessage
    
End Function

'
' 機能　　 : 入金済み請求書データ削除可否フラグ取得
'
' 引数　　 : なし
'
' 戻り値　 : 入金済み請求書データ削除可否フラグ
'
' 備考　　 : 規定値は”可”
'
Public Function SelectPaymentBillDelete() As String

    'BILLDELETE_ENABLED情報取得
    SelectPaymentBillDelete = ReadIniFile("PAYMENTBILL", "BILLDELETE_ENABLED")
    
    If SelectPaymentBillDelete = "" Then
        SelectPaymentBillDelete = PAYMENTBILL_DELETE_ENABLED
    End If

End Function

'
' 機能　　 : 表示行数取得（請求情報修正処理）
'
' 引数　　 : (Out)    strNewLines     新規行数
' 　　　　 : (Out)    strAddLines     追加行数
'
' 戻り値　 : なし
'
' 備考　　 :
'
Public Sub SelectBurdenModifyLines(ByRef vntNewLines As Variant, ByRef vntAddLines As Variant)

    'NEWLINES情報取得
    vntNewLines = ReadIniFile("DMDBURDENMODIFY", "NEWLINES")
    
    'ADDLINES情報取得
    vntAddLines = ReadIniFile("DMDBURDENMODIFY", "ADDLINES")
    
End Sub


'
' 機能　　 : 表示行数情報取得（請求情報修正処理）
'
' 引数　　 : (Out)    vntArrAddLine     表示追加行数
' 　　　　   (Out)    vntArrAddLineName 表示追加行数名称
'
' 戻り値　 : 表示行数情報件数
'
' 備考　　 :
'
Public Function SelectBurdenModifyLinesList(ByRef vntArrAddLine As Variant, ByRef vntArrAddLineName As Variant) As Long

    Dim strCode         As String
    Dim strName         As String
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    i = 1
    Do
        
        'CODE,NAME情報取得
        strCode = ReadIniFile("DMDBURDENMODIFY", "CODE" & CStr(i))
        strName = ReadIniFile("DMDBURDENMODIFY", "NAME" & CStr(i))
        
        'これ以上値が存在しないとき、処理を抜ける
        If strCode = "" And strName = "" Then
            Exit Do
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrAddLine) Then
            vntArrAddLine = Array(Trim(strCode))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrAddLine) + 1
            ReDim Preserve vntArrAddLine(j)
            vntArrAddLine(j) = Trim(strCode)
        End If
        
        '配列でない場合は新規配列を作成
        If Not IsArray(vntArrAddLineName) Then
            vntArrAddLineName = Array(Trim(strName))
        Else
            '配列の最後部に要素を追加
            j = UBound(vntArrAddLineName) + 1
            ReDim Preserve vntArrAddLineName(j)
            vntArrAddLineName(j) = Trim(strName)
        End If
        
        i = i + 1
    Loop

    If Not IsArray(vntArrAddLine) Then
        SelectBurdenModifyLinesList = 0
    Else
        SelectBurdenModifyLinesList = UBound(vntArrAddLine) + 1
    End If

End Function

'
' 機能　　 : ＤＭラベルサイズ（行・列）取得（印刷：ＤＭラベル）
'
' 引数　　 : (In)     strLabelID        ＤＭラベルＩＤ（PER:個人用、ORG:団体用）
' 　　　　 : (Out)    vntRowCount       ＤＭ行数
' 　　　　   (Out)    vntColCount       ＤＭ列数
'
' 戻り値　 : True :データ取得時
' 　　　　 : False:データ未取得時
'
' 備考　　 : 規定値なし（0扱い）
'
Public Function SelectDMLabelSize(ByVal strLabelID As String, ByRef vntRowCount As Variant, ByRef vntColCount As Variant) As Boolean
    
    Dim strRowCount     As String   '行数
    Dim strColCount     As String   '列数
    
    'DMLABELSIZE情報取得
    strRowCount = ReadIniFile("DMLABELSIZE", strLabelID & "ROW")
    strColCount = ReadIniFile("DMLABELSIZE", strLabelID & "COL")
    
    '未設定時の判定
    If strRowCount = "" Or strColCount = "" Then
        SelectDMLabelSize = False
        Exit Function
    End If
    
    vntRowCount = CLng("0" & strRowCount)
    vntColCount = CLng("0" & strColCount)
    
    '戻り値の設定
    SelectDMLabelSize = True
    
End Function

'
' 機能　　 : 結果入力・前回値コース選択取得
'
' 引数　　 : なし
'
' 戻り値　 : コース選択
'
' 備考　　 :
'
Public Function SelectRslCourseFlg() As Long

    'COURSEFLG情報取得
    SelectRslCourseFlg = CLng("0" & ReadIniFile("RSL", "COURSEFLG"))

End Function

'
' 機能　　 : 結果入力・前回値２次検査コース選択取得
'
' 引数　　 : なし
'
' 戻り値　 : ２次検査コース選択
'
' 備考　　 :
'
Public Function SelectRslSecondFlg() As Long

    'SECONDFLG情報取得
    SelectRslSecondFlg = CLng("0" & ReadIniFile("RSL", "SECONDFLG"))

End Function

'
' 機能　　 : 履歴日付の重複チェック
'
' 引数　　 : (In)     intItemCount  履歴数
' 　　　　 : (In)     vntStrDate    開始日付（配列）
' 　　　　 : (In)     vntEndDate    終了日付（配列）
'
' 戻り値　 : TRUE:重複なし、FALSE:重複あり
'
' 備考　　 :
'
Public Function CheckHistoryDuplicate(intItemCount As Integer, _
                                      vntStrDate As Variant, _
                                      vntEndDate As Variant) As Boolean

    Dim i   As Integer
    Dim j   As Integer

    CheckHistoryDuplicate = False
    
    '履歴管理数が複数存在しないなら処理終了
    If intItemCount < 2 Then
        CheckHistoryDuplicate = True
        Exit Function
    End If
    
    '履歴項目数分Loop
    For i = 0 To intItemCount - 1
        j = i + 1
        
        '現在位置＋１から検索
        For j = i + 1 To intItemCount - 1
        
            '開始日付の重複チェック
            If (CDate(vntStrDate(i) >= vntStrDate(j))) And (CDate(vntStrDate(i) <= vntEndDate(j))) Then
                Exit Function
            End If
    
            '終了日付の重複チェック
            If (CDate(vntEndDate(i) >= vntStrDate(j))) And (CDate(vntEndDate(i) <= vntEndDate(j))) Then
                Exit Function
            End If
    
        Next j
    Next i
        
    CheckHistoryDuplicate = True

End Function

'
' 機能　　 : 指定フォルダ内のファイル名の一覧を取得する
'
' 引数　　 : (In)     lngStartValue  開始西暦年
' 　　　　   (In)     lngEndValue    終了西暦年
' 　　　　   (Out)    vntYear        西暦年の配列
' 　　　　   (Out)    vntEraCode     元号(コード表記)の配列
' 　　　　   (Out)    vntEraName     元号(日本語表記)の配列
'
' 戻り値　 : 配列の要素数
'
' 備考　　 :
'
Public Function GetEraYearArray(ByVal lngStartValue As Long, ByVal lngEndValue As Long, ByRef vntYear As Variant, ByRef vntEraCode As Variant, ByRef vntEraName As Variant) As Long

    Dim vntArrYear()            As Variant  '西暦年
    Dim vntArrEraCode()         As Variant  '元号(コード表記)
    Dim vntArrEraName()         As Variant  '元号(日本語表記)
    Dim lngCount                As Long     '元号配列の要素数
    
    Dim lngCurrentYear          As Long     '現在の検索年

    Dim strEraCodeOfStartDay    As String   '現編集年の元旦時点での元号(コード表記)
    Dim strEraNameOfStartDay    As String   '現編集年の元旦時点での元号(日本語表記)
    Dim strEraCodeOfEndDay      As String   '現編集年の大晦日時点での元号(コード表記)
    Dim strEraNameOfEndDay      As String   '現編集年の大晦日時点での元号(日本語表記)

    '初期処理
    vntYear = Empty
    vntEraCode = Empty
    vntEraName = Empty

    '西暦年の検索
    For lngCurrentYear = lngStartValue To lngEndValue

        '現編集年の元旦時点での元号を求める
        strEraCodeOfStartDay = Format(CDate(lngCurrentYear & "/1/1"), "ge")
        strEraNameOfStartDay = Format(CDate(lngCurrentYear & "/1/1"), "gggee")

        '配列に追加
        ReDim Preserve vntArrYear(lngCount)
        ReDim Preserve vntArrEraCode(lngCount)
        ReDim Preserve vntArrEraName(lngCount)
        vntArrYear(lngCount) = lngCurrentYear
        vntArrEraCode(lngCount) = strEraCodeOfStartDay
        vntArrEraName(lngCount) = strEraNameOfStartDay
        lngCount = lngCount + 1
        
        '現編集年の大晦日時点での元号を求める
        strEraCodeOfEndDay = Format(CDate(lngCurrentYear & "/12/31"), "ge")
        strEraNameOfEndDay = Format(CDate(lngCurrentYear & "/12/31"), "gggee")

        '以下は同一西暦年にて元号が変わる場合の対応
        
        '大晦日時点での元号が元旦時点のそれと異なる場合
        If strEraNameOfEndDay <> strEraNameOfStartDay Then

            '配列に追加
            ReDim Preserve vntArrYear(lngCount)
            ReDim Preserve vntArrEraCode(lngCount)
            ReDim Preserve vntArrEraName(lngCount)
            vntArrYear(lngCount) = lngCurrentYear
            vntArrEraCode(lngCount) = strEraCodeOfEndDay
            vntArrEraName(lngCount) = strEraNameOfEndDay
            lngCount = lngCount + 1

        End If

    Next lngCurrentYear

    '戻り値の設定
    vntYear = vntArrYear
    vntEraCode = vntArrEraCode
    vntEraName = vntArrEraName
    
    GetEraYearArray = lngCount

End Function

'
' 機能　　 : 指定フォルダ内のファイル名の一覧を取得する
'
' 引数　　 : (In)     strPath      フォルダパス
' 　　　　   (In)     dtmOpDate    処理日付(タイムスタンプがこの日付以降のファイルを対象とする)
' 　　　　   (Out)    vntFileName  ファイル名
'
' 戻り値　 : ファイル数
'
' 備考　　 :
'
Public Function GetFileList(ByVal strPath As String, ByVal dtmOpDate As Date, ByRef vntFileName As Variant) As Long

    Dim objFso              As Object   'ファイルシステムオブジェクト
    Dim objFolder           As Object   'Folderオブジェクト
    Dim colFiles            As Object   'Filesコレクション
    Dim objFile             As Object   'Fileオブジェクト
    
    Dim vntArrFileName()    As Variant  'ファイル名の配列
    Dim lngCount            As Long     'ファイル数
    
    '初期処理
    vntFileName = Empty
    
    'オブジェクトのインスタンス作成
    Set objFso = CreateObject("Scripting.FileSystemObject")

    'フォルダの存在チェック
    If Not objFso.FolderExists(strPath) Then
        Err.Raise 76    '「パスが見つかりません。」
    End If

    'フォルダの取得
    Set objFolder = objFso.GetFolder(strPath)

    'Filesコレクションの取得
    Set colFiles = objFolder.Files
    
    'コレクション内の全ファイルを検索
    For Each objFile In colFiles
        
        '引数にて指定された日付以降に変更されたファイルであれば追加
        If DateValue(objFile.DateLastModified) >= DateValue(dtmOpDate) Then
            ReDim Preserve vntArrFileName(lngCount)
            vntArrFileName(lngCount) = objFile.Name
            lngCount = lngCount + 1
        End If
        
    Next
    
    '戻り値の設定
    vntFileName = vntArrFileName
    
    GetFileList = lngCount
    
End Function
