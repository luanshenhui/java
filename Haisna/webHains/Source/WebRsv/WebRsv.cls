VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "WebRsv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-UI-Y0101-107
'修正日  ：2010.06.21（修正）
'担当者  ：TCS)小松
'修正内容：web予約よりキャンセルの取込も可能とする。
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.2.27
'担当者  ：T.Takagi@RD
'修正内容：国籍を追加
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.11
'担当者  ：T.Takagi@RD
'修正内容：web予約受診オプションの取得方法変更

Option Explicit

Implements ObjectControl

Private mobjContext                         As ObjectContext        'オブジェクトコンテキスト

Private mobjOraSession                      As OraSession           'OraSessionオブジェクト
Private mobjOraDb                           As OraDatabase          'OraDatabaseオブジェクト

Private Const PREFIX_PERID                  As String = "ID:"       '検索時の個人ＩＤ指定
Private Const PREFIX_BIRTH                  As String = "BIRTH:"    '検索時の生年月日指定
Private Const PREFIX_GENDER                 As String = "GENDER:"   '検索時の性別指定

Private Const CSCSOPTION1_STOMAC_XRAY       As String = "W001"      '胃検査オプション(胃X線)
Private Const CSCSOPTION1_STOMAC_CAMERA     As String = "W002"      '胃検査オプション(胃内視鏡)

Private Const CSCSOPTION2_CHEST_XRAY        As String = "W003"      '胸部検査(胸部X線)
Private Const CSCSOPTION2_CHEST_CT          As String = "W004"      '胸部検査(胸部CT)

Private Const CSCSOPTION3_BREAST_XRAY       As String = "W005"      '乳房検査オプション(乳房X線)
Private Const CSCSOPTION3_BREAST_ECHO       As String = "W006"      '乳房検査オプション(乳房超音波)
Private Const CSCSOPTION3_BREAST_XRAY_ECHO  As String = "W013"      '乳房検査オプション(乳房X線＋乳房超音波)

'
' 機能　　 : 生年月日条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_Birth(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim strParamName    As String           'パラメータ名
    Dim strBirth        As String           '生年月日

    '先頭６文字が"BIRTH:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_BIRTH))) = PREFIX_BIRTH Then
        strBirth = Right(strBuffer, Len(strBuffer) - Len(PREFIX_BIRTH))
    Else
        strBirth = strBuffer
    End If
    
    'すでに日付型である場合
    If IsDate(strBirth) Then
        
        'そのまま適用
        strBirth = Format(CDate(strBirth), "yyyymmdd")
    
    '日付型でない(すなわち８桁の数字列である)場合
    Else
    
        '年がゼロの場合はシステム年を適用し、さもなくばそのまま日付型にして適用
        strBirth = IIf(Left(strBirth, 4) = "0000", Year(Date) & Right(strBirth, 4), strBirth)
    
    End If
    
    'パラメータ名の定義
    strParamName = "BIRTH" & CStr(lngParamNo)
    
    'パラメータ追加
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, CLng(strBirth), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '条件節の編集
    strStmt = "V_WEB_YOYAKU.BIRTH = :" & strParamName
    
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
    Set objCommon = Nothing
    
End Sub

'
' 機能　　 : 性別条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_Gender(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim strParamName    As String           'パラメータ名
    Dim strGender       As String           '性別

    '先頭６文字が"GENDER:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_GENDER))) = PREFIX_GENDER Then
        strGender = UCase(Right(strBuffer, Len(strBuffer) - Len(PREFIX_GENDER)))
    Else
        strGender = UCase(strBuffer)
    End If

    'パラメータ名の定義
    strParamName = "GENDER" & CStr(lngParamNo)
    
    'パラメータ追加
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, CStr(IIf(strGender = "M", GENDER_MALE, GENDER_FEMALE)), ORAPARM_INPUT, ORATYPE_CHAR

    strStmt = "V_WEB_YOYAKU.SEXFLG = :" & strParamName
    
    '条件節の編集
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
    Set objCommon = Nothing
    Set objOraParam = Nothing
    
End Sub

'
' 機能　　 : 個人ＩＤ条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_PerId(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim strParamName    As String           'パラメータ名
    Dim strPerId        As String           '個人ＩＤ

    '先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_PERID))) = PREFIX_PERID Then
        strPerId = Right(strBuffer, Len(strBuffer) - Len(PREFIX_PERID))
    Else
        strPerId = strBuffer
    End If

    'パラメータ追加
    strParamName = "PERID" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    '条件節の編集
    If Right(strPerId, 1) = "*" Then
    
        '文字列の末尾が"*"なら部分検索
        objOraParam(strParamName).Value = Trim(Left(strPerId, Len(strPerId) - 1)) & "%"
        strStmt = "V_WEB_YOYAKU.KARNO LIKE :" & strParamName

    Else
    
        'さもなければ直接指定
        objOraParam(strParamName).Value = Trim(strPerId)
        strStmt = "V_WEB_YOYAKU.KARNO = :" & strParamName
    
    End If

    Set objCommon = CreateObject("HainsCommon.Common")

    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
    Set objCommon = Nothing
    Set objOraParam = Nothing
    
End Sub

'
' 機能　　 : 全角文字条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 : 前方一致検索のみ対応
'
Private Sub AppendCondition_Wide(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim strParamName    As String           'パラメータ名

    Dim strNarrow       As String           '半角変換後の文字列
    Dim blnWideChar     As Boolean          'カナ漢字チェック用変数
    Dim i               As Long             'インデックス
    
    'カナ以外の全角文字が存在するかをチェック(カナは半角変換でき、漢字・ひらがなは半角変換できない性質を利用)
    strNarrow = StrConv(strBuffer, vbNarrow)
    blnWideChar = False
    For i = 1 To Len(strNarrow)
        If Asc(Mid(strNarrow, i, 1)) < 0 Then
            blnWideChar = True
            Exit For
        End If
    Next i
        
    'パラメータ名定義
    strParamName = "FULLNAME" & CStr(lngParamNo)
        
    'パラメータ追加
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, strBuffer & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '条件節の編集
    If blnWideChar = True Then
        
        'カナ以外の全角文字が含まれる場合
        strStmt = "V_WEB_YOYAKU.NAMEJ LIKE :" & strParamName
    
    Else
    
        'カナのみの場合
        strStmt = "TO_ZENKAKU(V_WEB_YOYAKU.NAMEA) LIKE :" & strParamName
    
    End If
                    
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
    Set objCommon = Nothing
    Set objOraParam = Nothing
    
End Sub

'
' 機能　　 : web予約一覧検索用基本SQL作成
'
' 引数　　 : (In)     dtmStrCslDate  開始受診年月日
' 　　　　   (In)     dtmEndCslDate  終了受診年月日
' 　　　　   (In)     strKey         検索キー
' 　　　　   (In)     dtmStrOpDate   開始処理年月日
' 　　　　   (In)     dtmEndOpDate   終了処理年月日
' 　　　　   (In)     lngOpMode      処理モード(1:申込日で検索、2:予約処理日で検索)
' 　　　　   (In)     lngRegFlg      本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)
'#### 2010.08.07 SL-UI-Y0101-107 MOD START ####'
' 　　　　   (In)     lngMoushiKbn   申し込み区分(0:指定なし、1:新規のみ、2:キャンセルのみ)
'#### 2010.08.07 SL-UI-Y0101-107 MOD END ####'
'
' 戻り値　 : SQLステートメント
'
' 備考　　 :
'
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
Private Function CreateBasedSqlForWebRsvList( _
    ByVal dtmStrCslDate As Date, _
    ByVal dtmEndCslDate As Date, _
    ByVal strKey As String, _
    ByVal dtmStrOpDate As Date, _
    ByVal dtmEndOpDate As Date, _
    ByVal lngOpMode As Long, _
    ByVal lngRegFlg As Long, _
    ByVal lngMoushiKbn As Long _
) As String
''Private Function CreateBasedSqlForWebRsvList( _
''    ByVal dtmStrCslDate As Date, _
''    ByVal dtmEndCslDate As Date, _
''    ByVal strKey As String, _
''    ByVal dtmStrOpDate As Date, _
''    ByVal dtmEndOpDate As Date, _
''    ByVal lngOpMode As Long, _
''    ByVal lngRegFlg As Long _
'') As String
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    
    Dim strStmt     As String           'SQLステートメント
    Dim dtmDate     As Date             '日付比較時退避用
    
    '受診年月日について日付範囲順逆逆転時は値を交換
    If dtmStrCslDate > dtmEndCslDate Then
        dtmDate = dtmStrCslDate
        dtmStrCslDate = dtmEndCslDate
        dtmEndCslDate = dtmDate
    End If
    
    '処理年月日について
    Select Case True
    
        '開始終了共に指定されている場合、日付範囲順逆逆転時は値を交換
        Case dtmStrOpDate > 0 And dtmEndOpDate > 0
            If dtmStrOpDate > dtmEndOpDate Then
                dtmDate = dtmStrOpDate
                dtmStrOpDate = dtmEndOpDate
                dtmEndOpDate = dtmDate
            End If
        
        '開始のみ指定時、終了＝開始とする
        Case dtmStrOpDate > 0 And dtmEndOpDate = 0
            dtmEndOpDate = dtmStrOpDate
            
        '終了のみ指定時、開始＝終了とする
        Case dtmStrOpDate = 0 And dtmEndOpDate > 0
            dtmStrOpDate = dtmEndOpDate
            
    End Select
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", DateAdd("d", 1, dtmEndCslDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "STROPDATE", dtmStrOpDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDOPDATE", DateAdd("d", 1, dtmEndOpDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "REGFLG", CStr(lngRegFlg), ORAPARM_INPUT, ORATYPE_CHAR
    
    '基本SQLステートメントの編集開始
    strStmt = "SELECT *                                 " & vbLf & _
              "  FROM WEBRESERVE.V_WEB_YOYAKU           " & vbLf & _
              " WHERE V_WEB_YOYAKU.JDATE >= :STRCSLDATE " & vbLf & _
              "   AND V_WEB_YOYAKU.JDATE <  :ENDCSLDATE "
              
    '検索キー指定時は条件追加
    If strKey <> "" Then
        strStmt = strStmt & vbLf & "   AND " & CreateConditionForWebRsvList(strKey)
    End If
    
    '処理年月日指定時は条件追加
    If dtmStrOpDate > 0 Or dtmEndOpDate > 0 Then
        
        Select Case lngOpMode
            
            Case 1  '申込日で検索
                
                strStmt = strStmt & vbLf & _
                          "   AND V_WEB_YOYAKU.INSERTDATE >= :STROPDATE " & vbLf & _
                          "   AND V_WEB_YOYAKU.INSERTDATE <  :ENDOPDATE "
            
            Case 2  '予約処理日で検索
                
                strStmt = strStmt & vbLf & _
                          "   AND V_WEB_YOYAKU.UPDATEDATE >= :STROPDATE " & vbLf & _
                          "   AND V_WEB_YOYAKU.UPDATEDATE <  :ENDOPDATE " & vbLf & _
                          "   AND V_WEB_YOYAKU.YKBN       =  2          "

        End Select
    
    End If
              
    '状態指定時は条件追加
    If lngRegFlg > 0 Then
        strStmt = strStmt & vbLf & "   AND V_WEB_YOYAKU.YKBN = :REGFLG "
    End If
              
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
    '申込区分による条件追加
    Select Case lngMoushiKbn
    Case 0
        '0：すべての場合：条件なし
    Case 1
        '1：新規の場合：キャンセル申込日付が空のもの
        strStmt = strStmt & vbLf & _
              "   AND V_WEB_YOYAKU.CANCEL_REQDT IS NULL             "
    Case 2
        '2：キャンセルの場合：キャンセル申込日付にデータがあるもの
        strStmt = strStmt & vbLf & _
              "   AND V_WEB_YOYAKU.CANCEL_REQDT IS NOT NULL         "
    End Select
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'
              
    CreateBasedSqlForWebRsvList = OmitCharSpc(strStmt)

End Function

'
' 機能　　 : web予約一覧検索用条件節作成
'
' 引数　　 : (In)     strKey  検索キー
'
' 戻り値　 : 条件節
'
' 備考　　 :
'
Private Function CreateConditionForWebRsvList(ByVal strKey As String) As String

    Dim objCommon       As Common   '共通クラス
    Dim objPerson       As Object   '個人情報アクセス用
    
    Dim vntKey          As Variant  '検索キーの集合
    Dim vntCondition    As Variant  '条件節の集合
    Dim strBuffer       As String   '文字列バッファ
    Dim i               As Long     'インデックス
    
    '引数未設定時は何もしない
    If Trim(strKey) = "" Then
        Exit Function
    End If

    Set objCommon = CreateObject("HainsCommon.Common")
    
    '検索キー中の半角カナを全角カナに変換する
    strBuffer = objCommon.StrConvKanaWide(strKey)
    
    Set objCommon = Nothing
    
    '検索キー中の小文字を大文字に変換する
    strBuffer = UCase(strBuffer)
    
    '全角空白を半角空白に置換する
    strBuffer = Replace(Trim(strBuffer), "　", " ")
    
    '2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
    Do Until InStr(1, strBuffer, "  ") = 0
        strBuffer = Replace(strBuffer, "  ", " ")
    Loop

    '文字列の分割
    vntKey = Split(strBuffer, " ")
    
    'オブジェクトのインスタンス作成
    Set objPerson = CreateObject("HainsPerson.Person")
    
    '検索キー数分の条件節を追加
    For i = 0 To UBound(vntKey)

        '検索キーのタイプを判別し、条件節に変換して追加
        Select Case True
        
            Case objPerson.IsWide(vntKey(i))    '全角文字が含まれる(半角カナもここに含まれる)
                AppendCondition_Wide vntCondition, vntKey(i), i
        
            Case objPerson.IsGender(vntKey(i))  '性別
                AppendCondition_Gender vntCondition, vntKey(i), i

            Case objPerson.IsPerId(vntKey(i))   '個人ID
                AppendCondition_PerId vntCondition, vntKey(i), i

            Case objPerson.IsBirth(vntKey(i))   '生年月日
                AppendCondition_Birth vntCondition, vntKey(i), i

            Case Else                           '上記以外は個人IDとして検索
                AppendCondition_PerId vntCondition, vntKey(i), i
            
        End Select
        
    Next i
    
    Set objPerson = Nothing
    
    'すべての条件節をANDで連結
    CreateConditionForWebRsvList = Join(vntCondition, " AND ")
    
End Function

'
' 機能　　 : バインド変数値の編集
'
' 引数　　 : (In/Out) objCode     各種コード
' 　　　　   (In/Out) objEditFlg  修正区分
' 　　　　   (In)     vntCode     各種コード
' 　　　　   (In)     vntEditFlg  修正区分
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditBindArray(ByRef objCode As OraParamArray, ByRef objEditFlg As OraParamArray, ByRef vntCode As Variant, ByRef vntEditFlg As Variant)

    Dim i   As Long 'インデックス

    '編集値自体が存在しない場合は何もしない
    If IsEmpty(vntCode) Or IsEmpty(vntEditFlg) Then
        Exit Sub
    End If

    '編集値が配列でない場合は添字の０番目に編集
    If Not IsArray(vntCode) Then
        objCode(0) = vntCode
        objEditFlg(0) = vntEditFlg
        Exit Sub
    End If

    '配列数分の編集
    For i = 0 To UBound(vntCode)
        objCode(i) = vntCode(i)
        objEditFlg(i) = vntEditFlg(i)
    Next i

End Sub

'
' 機能　　 : 引数値の要素数を取得
'
' 引数　　 : (In)     vntValue  任意のVariant値
'
' 戻り値　 : 要素数
'
' 備考　　 :
'
Private Function GetElementCount(ByVal vntValue As Variant) As Long

    Dim lngCount    As Long '要素数

    Do
        'オプションコード未指定時はZERO
        If IsEmpty(vntValue) Then
            lngCount = 0
            Exit Do
        End If

        '配列形式でない場合は1
        If Not IsArray(vntValue) Then
            lngCount = 1
            Exit Do
        End If

        '配列形式の場合は要素数とする
        lngCount = UBound(vntValue) + 1

        Exit Do
    Loop

    GetElementCount = lngCount

End Function

'
' 機能　　 : 2文字以上の全角空白が連結している場合、存在しなくなるまで置換を繰り返す
'
' 引数　　 : (In)     strExpression  文字列
'
' 戻り値　 : 空白オミット後の文字列
'
' 備考　　 :
'
Private Function OmitWideSpace(ByVal strExpression As String) As String

    Dim strBuffer   As String   '文字列バッファ

    strBuffer = strExpression

    '2文字以上の全角空白が連結している場合、存在しなくなるまで置換を繰り返す
    Do Until InStr(1, strBuffer, "　　") = 0
        strBuffer = Replace(strBuffer, "　　", "　")
    Loop

    '戻り値の設定
    OmitWideSpace = strBuffer
    
End Function

'
' 機能　　 : 出力順に対応するORDER BY句の取得
'
' 引数　　 : (In)     lngOrder  出力順(1:受診日順、2:個人ID順)
'
' 戻り値　 : ORDER BY句
'
' 備考　　 :
'
Private Function OrderByStatement(ByVal lngOrder As Long) As String

    Dim strOrderBy  As String   'ORDER BY句

    'ORDER BY項目の設定
    Select Case lngOrder

        Case 1  '受診日順
    
            strOrderBy = "ORDER BY V_WEB_YOYAKU.JDATE, V_WEB_YOYAKU.UKAITM NULLS FIRST, V_WEB_YOYAKU.KARNO NULLS FIRST"

        Case 2  '個人ID順
    
            strOrderBy = "ORDER BY V_WEB_YOYAKU.KARNO NULLS FIRST, V_WEB_YOYAKU.JDATE, V_WEB_YOYAKU.UKAITM NULLS FIRST"
    
    End Select

    '戻り値の設定
    OrderByStatement = strOrderBy
    
End Function

'
' 機能　　 : web予約情報登録
'
' 引数　　 : (In)     dtmCslDate         受診年月日
' 　　　　   (In)     lngWebNo           webNo.
' 　　　　   (In)     strUpdUser         更新者
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     lngRsvGrpCd        予約群コード
' 　　　　   (In)     strPerId           個人ID
' 　　　　   (In)     strLastName        姓
' 　　　　   (In)     strFirstName       名
' 　　　　   (In)     strLastKName       カナ姓
' 　　　　   (In)     strFirstKName      カナ名
' 　　　　   (In)     lngGender          性別
' 　　　　   (In)     dtmBirth           生年月日
' 　　　　   (In)     strOrgCd1          団体コード1
' 　　　　   (In)     strOrgCd2          団体コード2
' 　　　　   (In)     strAge             受診時年齢
' 　　　　   (In)     strCslDivCd        受診区分コード
' 　　　　   (In)     lngCtrPtCd         契約パターンコード
' 　　　　   (In)     strRomeName        ローマ字名
' 　　　　   (In)     vntAddrDiv         住所区分
' 　　　　   (In)     vntZipCd           郵便番号
' 　　　　   (In)     vntPrefCd          都道府県コード
' 　　　　   (In)     vntCityName        市区町村名
' 　　　　   (In)     vntAddress1        住所１
' 　　　　   (In)     vntAddress2        住所２
' 　　　　   (In)     vntTel1            電話番号1
' 　　　　   (In)     vntPhone           携帯番号
' 　　　　   (In)     vntEMail           e-Mail
' 　　　　   (In)     lngRsvStatus       予約状況
' 　　　　   (In)     lngPrtOnSave       保存時印刷
' 　　　　   (In)     strCardAddrDiv     確認はがき宛先
' 　　　　   (In)     lngCardOutEng      確認はがき英文出力
' 　　　　   (In)     strFormAddrDiv     一式書式宛先
' 　　　　   (In)     lngFormOutEng      一式書式英文出力
' 　　　　   (In)     strReportAddrDiv   成績書宛先
' 　　　　   (In)     lngReportOutEng    成績書英文出力
' 　　　　   (In)     strVolunteer       ボランティア
' 　　　　   (In)     strVolunteerName   ボランティア名
' 　　　　   (In)     strCollectTicket   利用券回収
' 　　　　   (In)     strIssueCslTicket  診察券発行
' 　　　　   (In)     strBillPrint       請求書出力
' 　　　　   (In)     strIsrSign         保険証記号
' 　　　　   (In)     strIsrNo           保険証番号
' 　　　　   (In)     strIsrManNo        保険者番号
' 　　　　   (In)     strEmpNo           社員番号
' 　　　　   (In)     strIntroductor     紹介者
' 　　　　   (In)     vntOptCd           オプションコード
' 　　　　   (In)     vntOptBranchNo     オプション枝番
' 　　　　   (In)     lngIgnoreFlg       強制登録フラグ
' 　　　　   (Out)    vntMessage         メッセージ
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
Public Function Regist( _
    ByVal dtmCslDate As Date, ByVal lngWebNo As Long, ByVal strUpdUser As String, _
    ByVal strCsCd As String, ByVal lngRsvGrpCd As Long, ByVal strPerId As String, _
    ByVal strLastName As String, ByVal strFirstName As String, ByVal strLastKName As String, _
    ByVal strFirstKName As String, ByVal lngGender As Long, ByVal dtmBirth As Date, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal strAge As String, _
    ByVal strCslDivCd As String, ByVal lngCtrPtCd As Long, ByVal strRomeName As String, _
    ByVal vntAddrDiv As Variant, ByVal vntZipCd As Variant, ByVal vntPrefCd As Variant, _
    ByVal vntCityName As Variant, ByVal vntAddress1 As Variant, ByVal vntAddress2 As Variant, _
    ByVal vntTel1 As Variant, ByVal vntPhone As Variant, ByVal vntEMail As Variant, _
    ByVal lngRsvStatus As Long, ByVal lngPrtOnSave As Long, ByVal strCardAddrDiv As String, _
    ByVal lngCardOutEng As Long, ByVal strFormAddrDiv As String, ByVal lngFormOutEng As Long, _
    ByVal strReportAddrDiv As String, ByVal lngReportOutEng As Long, ByVal strVolunteer As String, _
    ByVal strVolunteerName As String, ByVal strCollectTicket As String, ByVal strIssueCslTicket As String, _
    ByVal strBillPrint As String, ByVal strIsrSign As String, ByVal strIsrNo As String, _
    ByVal strIsrManNo As String, ByVal strEmpNo As String, ByVal strIntroductor As String, _
    ByVal vntOptCd As Variant, ByVal vntOptBranchNo As Variant, ByVal lngIgnoreFlg As Long, _
    ByRef vntMessage As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objAddrDiv      As OraParamArray    '住所区分
    Dim objZipCd        As OraParamArray    '郵便番号
    Dim objPrefCd       As OraParamArray    '都道府県コード
    Dim objCityName     As OraParamArray    '市区町村名
    Dim objAddress1     As OraParamArray    '住所１
    Dim objAddress2     As OraParamArray    '住所２
    Dim objTel1         As OraParamArray    '電話番号1
    Dim objPhone        As OraParamArray    '携帯番号
    Dim objEMail        As OraParamArray    'e-Mail

    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objOptBranchNo  As OraParamArray    'オプション枝番
    Dim lngCount        As Long             'オプション検査数

    Dim lngArraySize    As Long             'バインド配列のサイズ
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定開始
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "WEBNO", lngWebNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LASTNAME", strLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FIRSTNAME", strFirstName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LASTKNAME", strLastKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FIRSTKNAME", strFirstKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GENDER", lngGender, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BIRTH", dtmBirth, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "AGE", strAge, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDIVCD", strCslDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ROMENAME", strRomeName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '個人住所情報のバインド配列定義
    lngArraySize = UBound(vntAddrDiv) + 1
    objOraParam.AddTable "ADDRDIV", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "ZIPCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 7
    objOraParam.AddTable "PREFCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 2
    objOraParam.AddTable "CITYNAME", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_CITYNAME
    objOraParam.AddTable "ADDRESS1", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ADDRESS
    objOraParam.AddTable "ADDRESS2", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ADDRESS
    objOraParam.AddTable "TEL1", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 15
    objOraParam.AddTable "PHONE", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 15
    objOraParam.AddTable "EMAIL", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_EMAIL
    
    '受診付属情報
    objOraParam.Add "RSVSTATUS", lngRsvStatus, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRTONSAVE", lngPrtOnSave, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CARDADDRDIV", IIf(strCardAddrDiv <> "", CLng("0" & strCardAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CARDOUTENG", lngCardOutEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FORMADDRDIV", IIf(strFormAddrDiv <> "", CLng("0" & strFormAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FORMOUTENG", lngFormOutEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTADDRDIV", IIf(strReportAddrDiv <> "", CLng("0" & strReportAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTOUTENG", lngReportOutEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "VOLUNTEER", IIf(strVolunteer <> "", CLng("0" & strVolunteer), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "VOLUNTEERNAME", StrConv(strVolunteerName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "COLLECTTICKET", IIf(strCollectTicket <> "", CLng("0" & strCollectTicket), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ISSUECSLTICKET", IIf(strIssueCslTicket <> "", CLng("0" & strIssueCslTicket), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLPRINT", IIf(strBillPrint <> "", CLng("0" & strBillPrint), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRNO", strIsrNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRMANNO", strIsrManNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMPNO", strEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INTRODUCTOR", strIntroductor, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'オプション数の取得
    lngCount = GetElementCount(vntOptCd)

    'オプション検査のバインド変数定義
    lngArraySize = IIf(lngCount < 1, 1, lngCount)
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 4
    objOraParam.AddTable "OPTBRANCHNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 2
    objOraParam.Add "OPTCOUNT", lngCount, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '強制登録フラグ
    objOraParam.Add "IGNOREFLG", lngIgnoreFlg, ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値(予約番号・メッセージ)のバインド変数定義
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    'オブジェクトの参照設定
    Set objAddrDiv = objOraParam("ADDRDIV")
    Set objZipCd = objOraParam("ZIPCD")
    Set objPrefCd = objOraParam("PREFCD")
    Set objCityName = objOraParam("CITYNAME")
    Set objAddress1 = objOraParam("ADDRESS1")
    Set objAddress2 = objOraParam("ADDRESS2")
    Set objTel1 = objOraParam("TEL1")
    Set objPhone = objOraParam("PHONE")
    Set objEMail = objOraParam("EMAIL")
    Set objOptCd = objOraParam("OPTCD")
    Set objOptBranchNo = objOraParam("OPTBRANCHNO")

    '個人住所情報の編集
    For i = 0 To UBound(vntAddrDiv)
        objAddrDiv(i) = CLng(vntAddrDiv(i))
        objZipCd(i) = CStr(vntZipCd(i))
        objPrefCd(i) = CStr(vntPrefCd(i))
        objCityName(i) = CStr(vntCityName(i))
        objAddress1(i) = CStr(vntAddress1(i))
        objAddress2(i) = CStr(vntAddress2(i))
        objTel1(i) = CStr(vntTel1(i))
        objPhone(i) = CStr(vntPhone(i))
        objEMail(i) = CStr(vntEMail(i))
    Next i
    
    'オプションコードの編集
    Do
        
        'オプションコードが存在しない場合は何もしない
        If lngCount <= 0 Or IsEmpty(vntOptCd) Then
            Exit Do
        End If
        
        '編集値が配列でない場合は添字の０番目に編集
        If Not IsArray(vntOptCd) Then
            objOptCd(0) = CStr(vntOptCd)
            objOptBranchNo(0) = CLng(vntOptBranchNo)
            Exit Do
        End If

        '配列数分の編集
        For i = 0 To UBound(vntOptCd)
            objOptCd(i) = CStr(vntOptCd(i))
            objOptBranchNo(i) = CLng(vntOptBranchNo(i))
        Next i
        
        Exit Do
    Loop

    'web予約情報登録用ストアド呼び出し
    strStmt = "BEGIN                                 " & vbLf & _
              "    :RET := WebReservePackage.Regist( "

    strStmt = strStmt & vbLf & _
              "                :CSLDATE,    " & vbLf & _
              "                :WEBNO,      " & vbLf & _
              "                :UPDUSER,    " & vbLf & _
              "                :CSCD,       " & vbLf & _
              "                :RSVGRPCD,   " & vbLf & _
              "                :PERID,      " & vbLf & _
              "                :LASTNAME,   " & vbLf & _
              "                :FIRSTNAME,  " & vbLf & _
              "                :LASTKNAME,  " & vbLf & _
              "                :FIRSTKNAME, " & vbLf & _
              "                :GENDER,     " & vbLf & _
              "                :BIRTH,      " & vbLf & _
              "                :ORGCD1,     " & vbLf & _
              "                :ORGCD2,     " & vbLf & _
              "                :AGE,        " & vbLf & _
              "                :CSLDIVCD,   " & vbLf & _
              "                :CTRPTCD,    " & vbLf & _
              "                :ROMENAME,   " & vbLf & _
              "                :ADDRDIV,    " & vbLf & _
              "                :ZIPCD,      " & vbLf & _
              "                :PREFCD,     " & vbLf & _
              "                :CITYNAME,   " & vbLf & _
              "                :ADDRESS1,   "

    strStmt = strStmt & vbLf & _
              "                :ADDRESS2,       " & vbLf & _
              "                :TEL1,           " & vbLf & _
              "                :PHONE,          " & vbLf & _
              "                :EMAIL,          " & vbLf & _
              "                :RSVSTATUS,      " & vbLf & _
              "                :PRTONSAVE,      " & vbLf & _
              "                :CARDADDRDIV,    " & vbLf & _
              "                :CARDOUTENG,     " & vbLf & _
              "                :FORMADDRDIV,    " & vbLf & _
              "                :FORMOUTENG,     " & vbLf & _
              "                :REPORTADDRDIV,  " & vbLf & _
              "                :REPORTOUTENG,   " & vbLf & _
              "                :VOLUNTEER,      " & vbLf & _
              "                :VOLUNTEERNAME,  " & vbLf & _
              "                :COLLECTTICKET,  " & vbLf & _
              "                :ISSUECSLTICKET, " & vbLf & _
              "                :BILLPRINT,      " & vbLf & _
              "                :ISRSIGN,        " & vbLf & _
              "                :ISRNO,          " & vbLf & _
              "                :ISRMANNO,       " & vbLf & _
              "                :EMPNO,          " & vbLf & _
              "                :INTRODUCTOR,    " & vbLf & _
              "                :OPTCD,          "

    strStmt = strStmt & vbLf & _
              "                :OPTBRANCHNO, " & vbLf & _
              "                :OPTCOUNT,    " & vbLf & _
              "                :IGNOREFLG,   " & vbLf & _
              "                :MESSAGE      " & vbLf & _
              "            );                " & vbLf & _
              "END;                          "

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    Regist = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "WebRsv.Regist"
    
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
' 機能　　 : 指定受診日、webNoのweb予約情報を取得する
'
' 引数　　 : (In)     dtmCslDate       受診日
' 　　　　   (In)     lngWebNo         webNo.
' 　　　　   (Out)    vntRegFlg        本登録フラグ
' 　　　　   (Out)    vntCsCd          コースコード
' 　　　　   (Out)    vntRsvGrpCd      予約群コード
' 　　　　   (Out)    vntPerId         個人ID
' 　　　　   (Out)    vntFullName      姓名
' 　　　　   (Out)    vntKanaName      カナ姓名
' 　　　　   (Out)    vntLastName      (個人情報の)姓
' 　　　　   (Out)    vntFirstName     (個人情報の)名
' 　　　　   (Out)    vntLastKName     (個人情報の)カナ姓
' 　　　　   (Out)    vntFirstKName    (個人情報の)カナ名
' 　　　　   (Out)    vntGender        性別
' 　　　　   (Out)    vntBirth         生年月日
' 　　　　   (Out)    vntZipNo         郵便番号
' 　　　　   (Out)    vntAddress1      住所1
' 　　　　   (Out)    vntAddress2      住所2
' 　　　　   (Out)    vntAddress3      住所3
' 　　　　   (Out)    vntTel           電話番号
' 　　　　   (Out)    vntEMail         e-mail
' 　　　　   (Out)    vntOfficeName    勤務先名称
' 　　　　   (Out)    vntOfficeTel     勤務先電話番号
' 　　　　   (Out)    vntOrgName       契約団体名
' 　　　　   (Out)    vntRsvDiv        申し込み区分(1:一般、2:契約団体(健康保険組合または会社等)、3:健康保険組合連合会)
' 　　　　   (Out)    vntSupportDiv    本人家族区分(1:本人(被保険者)、2:家族(被扶養者))
' 　　　　   (Out)    vntOptionStomac  胃検査(0:胃なし、1:胃X線、2:胃内視鏡)
' 　　　　   (Out)    vntOptionBreast  乳房検査(0:乳房なし、1:乳房X線、2:乳房超音波、3:乳房X線＋乳房超音波)
' 　　　　   (Out)    vntMessage       メッセージ
' 　　　　   (Out)    vntInsDate       申し込み年月日
' 　　　　   (Out)    vntUpdDate       予約処理年月日
' 　　　　   (Out)    vntRsvNo         予約番号
' 　　　　   (Out)    vntIsrSign       保険書記号
' 　　　　   (Out)    vntIsrNo         保険書番号
' 　　　　   (Out)    vntVolunteer     ボランティア区分(0:利用なし、1:通訳要、2:介護要、3:通訳＆介護要、4:車椅子要)
' 　　　　   (Out)    vntCardOutEng    確認はがき英文出力(0:なし、1:あり)
' 　　　　   (Out)    vntFormOutEng    一式英文出力(0:なし、1:あり)
' 　　　　   (Out)    vntReportOutEng  成績書英文出力(0:なし、1:あり)
' 　　　　   (Out)    vntOptionCT      胸部検査(1:胸部X線、2:胸部CT)
' 　　　　   (Out)    vntCanDate       キャンセル年月日
' 　　　　   (Out)    vntNation        国籍
' 　　　　   (Out)    vntCslOptions    受診オプション
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'

'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
'#### 2011/01/20 MOD STA TCS)Y.T ####
''### 2010/05/14 張　新WEB予約システム導入に伴う仕様変更 Start #############
''Public Function SelectWebRsv(
''    ByVal dtmCslDate As Date,
''    ByVal lngWebNo As Long,
''    Optional ByRef vntRegFlg As Variant,
''    Optional ByRef vntCsCd As Variant,
''    Optional ByRef vntRsvGrpCd As Variant,
''    Optional ByRef vntPerId As Variant,
''    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant,
''    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
''    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
''    Optional ByRef vntGender As Variant,
''    Optional ByRef vntBirth As Variant,
''    Optional ByRef vntZipNo As Variant,
''    Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, Optional ByRef vntAddress3 As Variant,
''    Optional ByRef vntTel As Variant,
''    Optional ByRef vntEMail As Variant,
''    Optional ByRef vntOfficeName As Variant, Optional ByRef vntOfficeTel As Variant,
''    Optional ByRef vntOrgName As Variant,
''    Optional ByRef vntRsvDiv As Variant,
''    Optional ByRef vntSupportDiv As Variant,
''    Optional ByRef vntOptionStomac As Variant, Optional ByRef vntOptionBreast As Variant,
''    Optional ByRef vntMessage As Variant,
''    Optional ByRef vntInsDate As Variant, Optional ByRef vntUpdDate As Variant,
''    Optional ByRef vntRsvNo As Variant
'') As Boolean
'
''#### 2010.06.21 SL-UI-Y0101-107 MOD START ####'
''Public Function SelectWebRsv(
''    ByVal dtmCslDate As Date,
''    ByVal lngWebNo As Long,
''    Optional ByRef vntRegFlg As Variant,
''    Optional ByRef vntCsCd As Variant,
''    Optional ByRef vntRsvGrpCd As Variant,
''    Optional ByRef vntPerId As Variant,
''    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant,
''    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
''    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
''    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, Optional ByRef vntZipNo As Variant,
''    Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, Optional ByRef vntAddress3 As Variant,
''    Optional ByRef vntTel As Variant, Optional ByRef vntEMail As Variant,
''    Optional ByRef vntOfficeName As Variant, Optional ByRef vntOfficeTel As Variant,
''    Optional ByRef vntOrgName As Variant,
''    Optional ByRef vntRsvDiv As Variant, Optional ByRef vntSupportDiv As Variant,
''    Optional ByRef vntOptionStomac As Variant, Optional ByRef vntOptionBreast As Variant,
''    Optional ByRef vntMessage As Variant,
''    Optional ByRef vntInsDate As Variant, Optional ByRef vntUpdDate As Variant,
''    Optional ByRef vntRsvNo As Variant,
''    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, Optional ByRef vntVolunteer As Variant,
''    Optional ByRef vntCardOutEng As Variant, Optional ByRef vntFormOutEng As Variant, Optional ByRef vntReportOutEng As Variant, Optional ByRef vntOptionCT As Variant
'') As Boolean
'Public Function SelectWebRsv(
'    ByVal dtmCslDate As Date,
'    ByVal lngWebNo As Long,
'    Optional ByRef vntRegFlg As Variant,
'    Optional ByRef vntCsCd As Variant,
'    Optional ByRef vntRsvGrpCd As Variant,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, Optional ByRef vntZipNo As Variant,
'    Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, Optional ByRef vntAddress3 As Variant,
'    Optional ByRef vntTel As Variant, Optional ByRef vntEMail As Variant,
'    Optional ByRef vntOfficeName As Variant, Optional ByRef vntOfficeTel As Variant,
'    Optional ByRef vntOrgName As Variant,
'    Optional ByRef vntRsvDiv As Variant, Optional ByRef vntSupportDiv As Variant,
'    Optional ByRef vntOptionStomac As Variant, Optional ByRef vntOptionBreast As Variant,
'    Optional ByRef vntMessage As Variant,
'    Optional ByRef vntInsDate As Variant, Optional ByRef vntCanDate As Variant, Optional ByRef vntUpdDate As Variant,
'    Optional ByRef vntRsvNo As Variant,
'    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, Optional ByRef vntVolunteer As Variant,
'    Optional ByRef vntCardOutEng As Variant, Optional ByRef vntFormOutEng As Variant, Optional ByRef vntReportOutEng As Variant, Optional ByRef vntOptionCT As Variant
') As Boolean
''#### 2010.06.21 SL-UI-Y0101-107 MOD END ####'
''### 2010/05/14 張　新WEB予約システム導入に伴う仕様変更 End   #############
'Public Function SelectWebRsv(
'    ByVal dtmCslDate As Date,
'    ByVal lngWebNo As Long,
'    Optional ByRef vntRegFlg As Variant,
'    Optional ByRef vntCsCd As Variant,
'    Optional ByRef vntRsvGrpCd As Variant,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, Optional ByRef vntZipNo As Variant,
'    Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, Optional ByRef vntAddress3 As Variant,
'    Optional ByRef vntTel As Variant, Optional ByRef vntEMail As Variant,
'    Optional ByRef vntOfficeName As Variant, Optional ByRef vntOfficeTel As Variant,
'    Optional ByRef vntOrgName As Variant,
'    Optional ByRef vntRsvDiv As Variant, Optional ByRef vntSupportDiv As Variant,
'    Optional ByRef vntOptionStomac As Variant, Optional ByRef vntOptionBreast As Variant,
'    Optional ByRef vntMessage As Variant,
'    Optional ByRef vntInsDate As Variant, Optional ByRef vntUpdDate As Variant,
'    Optional ByRef vntRsvNo As Variant,
'    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, Optional ByRef vntVolunteer As Variant,
'    Optional ByRef vntCardOutEng As Variant, Optional ByRef vntFormOutEng As Variant, Optional ByRef vntReportOutEng As Variant, Optional ByRef vntOptionCT As Variant,
'    Optional ByRef vntCanDate As Variant
') As Boolean
'#### 2011/01/20 MOD END TCS)Y.T ####
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 STR ###
'Public Function SelectWebRsv( _
'    ByVal dtmCslDate As Date, _
'    ByVal lngWebNo As Long, _
'    Optional ByRef vntRegFlg As Variant, _
'    Optional ByRef vntCsCd As Variant, _
'    Optional ByRef vntRsvGrpCd As Variant, _
'    Optional ByRef vntPerId As Variant, _
'    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant, _
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
'    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, Optional ByRef vntZipNo As Variant, _
'    Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, Optional ByRef vntAddress3 As Variant, _
'    Optional ByRef vntTel As Variant, Optional ByRef vntEMail As Variant, _
'    Optional ByRef vntOfficeName As Variant, Optional ByRef vntOfficeTel As Variant, _
'    Optional ByRef vntOrgName As Variant, _
'    Optional ByRef vntRsvDiv As Variant, Optional ByRef vntSupportDiv As Variant, _
'    Optional ByRef vntOptionStomac As Variant, Optional ByRef vntOptionBreast As Variant, _
'    Optional ByRef vntMessage As Variant, _
'    Optional ByRef vntInsDate As Variant, Optional ByRef vntUpdDate As Variant, _
'    Optional ByRef vntRsvNo As Variant, _
'    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, Optional ByRef vntVolunteer As Variant, _
'    Optional ByRef vntCardOutEng As Variant, Optional ByRef vntFormOutEng As Variant, Optional ByRef vntReportOutEng As Variant, Optional ByRef vntOptionCT As Variant, _
'    Optional ByRef vntCanDate As Variant, _
'    Optional ByRef vntNation As Variant, Optional ByRef vntCslOptions As Variant _
') As Boolean
Public Function SelectWebRsv( _
    ByVal dtmCslDate As Date, _
    ByVal lngWebNo As Long, _
    Optional ByRef vntRegFlg As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntRsvGrpCd As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, Optional ByRef vntZipNo As Variant, _
    Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, Optional ByRef vntAddress3 As Variant, _
    Optional ByRef vntTel As Variant, Optional ByRef vntEMail As Variant, _
    Optional ByRef vntOfficeName As Variant, Optional ByRef vntOfficeTel As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntRsvDiv As Variant, Optional ByRef vntSupportDiv As Variant, _
    Optional ByRef vntOptionStomac As Variant, Optional ByRef vntOptionBreast As Variant, _
    Optional ByRef vntMessage As Variant, _
    Optional ByRef vntInsDate As Variant, Optional ByRef vntUpdDate As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, Optional ByRef vntVolunteer As Variant, _
    Optional ByRef vntCardOutEng As Variant, Optional ByRef vntFormOutEng As Variant, Optional ByRef vntReportOutEng As Variant, Optional ByRef vntOptionCT As Variant, _
    Optional ByRef vntCanDate As Variant, _
    Optional ByRef vntNation As Variant, Optional ByRef vntCslOptions As Variant, Optional ByRef vntWebReqNo As Variant _
) As Boolean
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 END ###

'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objRegFlg       As OraField         '本登録フラグ
    Dim objCsCd         As OraField         'コースコード
    Dim objRsvGrpCd     As OraField         '予約群コード
    Dim objPerId        As OraField         '個人ID
    Dim objFullName     As OraField         '姓名
    Dim objKanaName     As OraField         'カナ姓名
    Dim objLastName     As OraField         '(個人情報の)姓
    Dim objFirstName    As OraField         '(個人情報の)名
    Dim objLastKName    As OraField         '(個人情報の)カナ姓
    Dim objFirstKName   As OraField         '(個人情報の)カナ名
    Dim objGender       As OraField         '性別
    Dim objBirth        As OraField         '生年月日
    Dim objZipNo        As OraField         '郵便番号
    Dim objAddress1     As OraField         '住所1
    Dim objAddress2     As OraField         '住所2
    Dim objAddress3     As OraField         '住所3
    Dim objTel          As OraField         '電話番号
    Dim objEMail        As OraField         'e-mail
    Dim objOfficeName   As OraField         '勤務先名称
    Dim objOfficeTel    As OraField         '勤務先電話番号
    Dim objOrgName      As OraField         '契約団体名
    Dim objRsvDiv       As OraField         '申し込み区分(1:一般、2:契約団体(健康保険組合または会社等)、3:健康保険組合連合会)
    Dim objSupportDiv   As OraField         '本人家族区分(1:本人(被保険者)、2:家族(被扶養者))
    Dim objOptionStomac As OraField         '胃検査(0:胃なし、1:胃X線、2:胃内視鏡)
    Dim objOptionBreast As OraField         '乳房検査(0:乳房なし、1:乳房X線、2:乳房超音波、3:乳房X線＋乳房超音波)
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 Start #############
    Dim objOptionCT     As OraField         '胸部検査(1:胸部X線、2:胸部CT)
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 End   #############
    Dim objMessage      As OraField         'メッセージ
    Dim objInsDate      As OraField         '申し込み年月日
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
    Dim objCanDate      As OraField         'キャンセル年月日
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
    Dim objUpdDate      As OraField         '予約処理年月日
    Dim objRsvNo        As OraField         '予約番号
    
'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 Start #############
    Dim objIsrSign      As OraField         '保険書記号
    Dim objIsrNo        As OraField         '保険書番号
    Dim objVolunteer    As OraField         'ボランティア区分(0:利用なし、1:通訳要、2:介護要、3:通訳＆介護要、4:車椅子要)
    Dim objCardOutEng   As OraField         '確認はがき英文出力(0:なし、1:あり)
    Dim objFormOutEng   As OraField         '一式英文出力(0:なし、1:あり)
    Dim objReportOutEng As OraField         '成績書英文出力(0:なし、1:あり)
'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 End   #############

'#### 2013.2.27 SL-SN-Y0101-612 ADD START ####
    Dim objNation       As OraField         '国籍
'#### 2013.2.27 SL-SN-Y0101-612 ADD END   ####
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
    Dim objCslOptions   As OraField         '受診オプション
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####
    
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 STR ###
    Dim objWebReqNo     As OraField         '申し込み番号
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 END ###
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRegFlg) Then vntRegFlg = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntFullName) Then vntFullName = Empty
    If Not IsMissing(vntKanaName) Then vntKanaName = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntZipNo) Then vntZipNo = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
    If Not IsMissing(vntAddress3) Then vntAddress3 = Empty
    If Not IsMissing(vntTel) Then vntTel = Empty
    If Not IsMissing(vntEMail) Then vntEMail = Empty
    If Not IsMissing(vntOfficeName) Then vntOfficeName = Empty
    If Not IsMissing(vntOfficeTel) Then vntOfficeTel = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntRsvDiv) Then vntRsvDiv = Empty
    If Not IsMissing(vntSupportDiv) Then vntSupportDiv = Empty
    If Not IsMissing(vntOptionStomac) Then vntOptionStomac = Empty
    If Not IsMissing(vntOptionBreast) Then vntOptionBreast = Empty
    If Not IsMissing(vntMessage) Then vntMessage = Empty
    If Not IsMissing(vntInsDate) Then vntInsDate = Empty
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
    If Not IsMissing(vntCanDate) Then vntCanDate = Empty
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    
'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 Start #############
    If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If Not IsMissing(vntIsrNo) Then vntIsrNo = Empty
    If Not IsMissing(vntVolunteer) Then vntVolunteer = Empty
    If Not IsMissing(vntCardOutEng) Then vntCardOutEng = Empty
    If Not IsMissing(vntFormOutEng) Then vntFormOutEng = Empty
    If Not IsMissing(vntReportOutEng) Then vntReportOutEng = Empty
'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 End   #############
    
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 Start #############
    If Not IsMissing(vntOptionCT) Then vntOptionCT = Empty
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 End   #############
'#### 2013.2.27 SL-SN-Y0101-612 ADD START ####
    If Not IsMissing(vntNation) Then vntNation = Empty
'#### 2013.2.27 SL-SN-Y0101-612 ADD END   ####
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
    If Not IsMissing(vntCslOptions) Then vntCslOptions = Empty
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 STR ###
    If Not IsMissing(vntWebReqNo) Then vntWebReqNo = Empty
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 END ###
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "WEBNO", lngWebNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たすweb予約情報テーブルのレコードを取得
    strStmt = "SELECT V_WEB_YOYAKU.YKBN            REGFLG,       " & vbLf & _
              "       V_WEB_YOYAKU.CSCD,                         " & vbLf & _
              "       CSRSVGRP.RSVGRPCD,                         " & vbLf & _
              "       V_WEB_YOYAKU.KARNO           PERID,        " & vbLf & _
              "       TO_ZENKAKU(V_WEB_YOYAKU.NAMEJ) FULLNAME,   " & vbLf & _
              "       TO_ZENKAKU(V_WEB_YOYAKU.NAMEA) KANANAME,   " & vbLf & _
              "       PERSON.LASTNAME,                           " & vbLf & _
              "       PERSON.FIRSTNAME,                          " & vbLf & _
              "       PERSON.LASTKNAME,                          " & vbLf & _
              "       PERSON.FIRSTKNAME,                         " & vbLf & _
              "       V_WEB_YOYAKU.SEXFLG          GENDER,       " & vbLf & _
              "       V_WEB_YOYAKU.BIRTH,                        " & vbLf & _
              "       V_WEB_YOYAKU.ZIPNO,                        " & vbLf & _
              "       V_WEB_YOYAKU.ADRS1           ADDRESS1,     " & vbLf & _
              "       V_WEB_YOYAKU.ADRS2           ADDRESS2,     " & vbLf & _
              "       V_WEB_YOYAKU.ADRS3           ADDRESS3,     " & vbLf & _
              "       V_WEB_YOYAKU.TELNO           TEL,          " & vbLf & _
              "       V_WEB_YOYAKU.EMAIL,                        " & vbLf & _
              "       V_WEB_YOYAKU.KNMNM           OFFICENAME,   " & vbLf & _
              "       V_WEB_YOYAKU.TELNO2          OFFICETEL,    " & vbLf & _
              "       V_WEB_YOYAKU.GRPNAME         ORGNAME,      " & vbLf & _
              "       V_WEB_YOYAKU.MKBN            RSVDIV,       " & vbLf & _
              "       V_WEB_YOYAKU.HNKZKBN         SUPPORTDIV,   "
    
    '胃検査コースオプションのフラグ変換
    strStmt = strStmt & vbLf & _
              "       DECODE(V_WEB_YOYAKU.CSCDOPTION1,               " & vbLf & _
              "              '" & CSCSOPTION1_STOMAC_XRAY & "',   1, " & vbLf & _
              "              '" & CSCSOPTION1_STOMAC_CAMERA & "', 2, " & vbLf & _
              "              0                                       " & vbLf & _
              "       ) OPTIONSTOMAC,                                "

'### 2010/05/28 張　新WEB予約システム導入に伴う仕様変更 Start #############
    '胸部検査コースのフラグ変換
    strStmt = strStmt & vbLf & _
              "       DECODE(V_WEB_YOYAKU.CSCDOPTION2,                  " & vbLf & _
              "              '" & CSCSOPTION2_CHEST_XRAY & "',    1,    " & vbLf & _
              "              '" & CSCSOPTION2_CHEST_CT & "',    2,    " & vbLf & _
              "              0                                          " & vbLf & _
              "       ) OPTIONCHEST,                                   "
'### 2010/05/28 張　新WEB予約システム導入に伴う仕様変更 End   #############


    '乳房検査コースオプションのフラグ変換
    strStmt = strStmt & vbLf & _
              "       DECODE(V_WEB_YOYAKU.CSCDOPTION3,                  " & vbLf & _
              "              '" & CSCSOPTION3_BREAST_XRAY & "',      1, " & vbLf & _
              "              '" & CSCSOPTION3_BREAST_ECHO & "',      2, " & vbLf & _
              "              '" & CSCSOPTION3_BREAST_XRAY_ECHO & "', 3, " & vbLf & _
              "              0                                          " & vbLf & _
              "       ) OPTIONBREAST,                                   "


'### 2010/05/14 張　新WEB予約システム導入に伴う仕様変更 Start #############
'    strStmt = strStmt & vbLf & _
'              "       V_WEB_YOYAKU.MSG        MESSAGE, " & vbLf & _
'              "       V_WEB_YOYAKU.INSERTDATE INSDATE, " & vbLf & _
'              "       V_WEB_YOYAKU.UPDATEDATE UPDDATE, " & vbLf & _
'              "       WEB_RELATION.RSVNO               "
'#### 2010.06.21 SL-UI-Y0101-107 MOD START ####'
'    strStmt = strStmt & vbLf & _
'              "       V_WEB_YOYAKU.MSG          MESSAGE,        " & vbLf & _
'              "       V_WEB_YOYAKU.INSERTDATE   INSDATE,        " & vbLf & _
'              "       V_WEB_YOYAKU.UPDATEDATE   UPDDATE,        " & vbLf & _
'              "       WEB_RELATION.RSVNO,                       " & vbLf & _
'              "       V_WEB_YOYAKU.ISRSIGN      ISRSIGN,        " & vbLf & _
'              "       V_WEB_YOYAKU.ISRNO        ISRNO,          " & vbLf & _
'              "       V_WEB_YOYAKU.VOLUNTEER    VOLUNTEER,      " & vbLf & _
'              "       V_WEB_YOYAKU.CARDOUTENG   CARDOUTENG,     " & vbLf & _
'              "       V_WEB_YOYAKU.FORMOUTENG   FORMOUTENG,     " & vbLf & _
'              "       V_WEB_YOYAKU.REPORTOUTENG REPORTOUTENG    "
    strStmt = strStmt & vbLf & _
              "       V_WEB_YOYAKU.MSG          MESSAGE,        " & vbLf & _
              "       V_WEB_YOYAKU.INSERTDATE   INSDATE,        " & vbLf & _
              "       V_WEB_YOYAKU.CANCEL_REQDT CANDATE,        " & vbLf & _
              "       V_WEB_YOYAKU.UPDATEDATE   UPDDATE,        " & vbLf & _
              "       WEB_RELATION.RSVNO,                       " & vbLf & _
              "       V_WEB_YOYAKU.ISRSIGN      ISRSIGN,        " & vbLf & _
              "       V_WEB_YOYAKU.ISRNO        ISRNO,          " & vbLf & _
              "       V_WEB_YOYAKU.VOLUNTEER    VOLUNTEER,      " & vbLf & _
              "       V_WEB_YOYAKU.CARDOUTENG   CARDOUTENG,     " & vbLf & _
              "       V_WEB_YOYAKU.FORMOUTENG   FORMOUTENG,     " & vbLf & _
              "       V_WEB_YOYAKU.REPORTOUTENG REPORTOUTENG    "
'#### 2010.06.21 SL-UI-Y0101-107 MOD END ####'
'### 2010/05/14 張　新WEB予約システム導入に伴う仕様変更 End   #############

'#### 2013.2.27 SL-SN-Y0101-612 ADD START ####
    strStmt = strStmt & vbLf & _
              "       ,V_WEB_YOYAKU.NATION NATION "
'#### 2013.2.27 SL-SN-Y0101-612 ADD END   ####
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
    strStmt = strStmt & vbLf & _
              "       ,V_WEB_YOYAKU.OP_CONCAT CSLOPTIONS "
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 STR ###
    strStmt = strStmt & vbLf & _
              "       ,V_WEB_YOYAKU.WEBREQNO WEBREQNO "
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 END ###

    'FROM句
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT COURSE_RSVGRP.CSCD, COURSE_RSVGRP.RSVGRPCD, " & vbLf & _
              "                RSVGRP.STRTIME                              " & vbLf & _
              "           FROM RSVGRP, COURSE_RSVGRP                       " & vbLf & _
              "          WHERE COURSE_RSVGRP.RSVGRPCD = RSVGRP.RSVGRPCD    " & vbLf & _
              "       ) CSRSVGRP,                                          " & vbLf & _
              "       WEB_RELATION, PERSON,                                " & vbLf & _
              "       WEBRESERVE.V_WEB_YOYAKU                              "
    
    'WHERE句
    strStmt = strStmt & vbLf & _
              " WHERE V_WEB_YOYAKU.JDATE  = :CSLDATE                " & vbLf & _
              "   AND V_WEB_YOYAKU.WEBNO  = :WEBNO                  " & vbLf & _
              "   AND V_WEB_YOYAKU.KARNO  = PERSON.PERID(+)         " & vbLf & _
              "   AND V_WEB_YOYAKU.JDATE  = WEB_RELATION.CSLDATE(+) " & vbLf & _
              "   AND V_WEB_YOYAKU.WEBNO  = WEB_RELATION.WEBNO(+)   " & vbLf & _
              "   AND V_WEB_YOYAKU.CSCD   = CSRSVGRP.CSCD(+)        " & vbLf & _
              "   AND V_WEB_YOYAKU.UKAITM = CSRSVGRP.STRTIME(+)     "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRegFlg = objFields("REGFLG")
        Set objCsCd = objFields("CSCD")
        Set objRsvGrpCd = objFields("RSVGRPCD")
        Set objPerId = objFields("PERID")
        Set objFullName = objFields("FULLNAME")
        Set objKanaName = objFields("KANANAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objZipNo = objFields("ZIPNO")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objAddress3 = objFields("ADDRESS3")
        Set objTel = objFields("TEL")
        Set objEMail = objFields("EMAIL")
        Set objOfficeName = objFields("OFFICENAME")
        Set objOfficeTel = objFields("OFFICETEL")
        Set objOrgName = objFields("ORGNAME")
        Set objRsvDiv = objFields("RSVDIV")
        Set objSupportDiv = objFields("SUPPORTDIV")
        Set objOptionStomac = objFields("OPTIONSTOMAC")
        Set objOptionBreast = objFields("OPTIONBREAST")
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 Start #############
        Set objOptionCT = objFields("OPTIONCHEST")
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 End   #############
        Set objMessage = objFields("MESSAGE")
        Set objInsDate = objFields("INSDATE")
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
        Set objCanDate = objFields("CANDATE")
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
        Set objUpdDate = objFields("UPDDATE")
        Set objRsvNo = objFields("RSVNO")

'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 Start #############
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrNo = objFields("ISRNO")
        Set objVolunteer = objFields("VOLUNTEER")
        Set objCardOutEng = objFields("CARDOUTENG")
        Set objFormOutEng = objFields("FORMOUTENG")
        Set objReportOutEng = objFields("REPORTOUTENG")
'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 End   #############

'#### 2013.2.27 SL-SN-Y0101-612 ADD START ####
        Set objNation = objFields("NATION")
'#### 2013.2.27 SL-SN-Y0101-612 ADD END   ####
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
        Set objCslOptions = objFields("CSLOPTIONS")
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 STR ###
        Set objWebReqNo = objFields("WEBREQNO")
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 END ###

        '戻り値の設定
        If Not IsMissing(vntRegFlg) Then vntRegFlg = objRegFlg.Value & ""
        If Not IsMissing(vntCsCd) Then vntCsCd = objCsCd.Value & ""
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = objRsvGrpCd.Value & ""
        If Not IsMissing(vntPerId) Then vntPerId = objPerId.Value & ""
        If Not IsMissing(vntFullName) Then vntFullName = OmitWideSpace(objFullName.Value & "")
        If Not IsMissing(vntKanaName) Then vntKanaName = OmitWideSpace(objKanaName.Value & "")
        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value & ""
        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value & ""
        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
        If Not IsMissing(vntGender) Then vntGender = objGender.Value & ""
        If Not IsMissing(vntBirth) Then vntBirth = Format(CLng("0" & objBirth.Value), "0000/00/00")
        If Not IsMissing(vntZipNo) Then vntZipNo = objZipNo.Value & ""
        If Not IsMissing(vntAddress1) Then vntAddress1 = objAddress1.Value & ""
        If Not IsMissing(vntAddress2) Then vntAddress2 = objAddress2.Value & ""
        If Not IsMissing(vntAddress3) Then vntAddress3 = objAddress3.Value & ""
        If Not IsMissing(vntTel) Then vntTel = objTel.Value & ""
        If Not IsMissing(vntEMail) Then vntEMail = objEMail.Value & ""
        If Not IsMissing(vntOfficeName) Then vntOfficeName = objOfficeName.Value & ""
        If Not IsMissing(vntOfficeTel) Then vntOfficeTel = objOfficeTel.Value & ""
        If Not IsMissing(vntOrgName) Then vntOrgName = objOrgName.Value & ""
        If Not IsMissing(vntRsvDiv) Then vntRsvDiv = objRsvDiv.Value & ""
        If Not IsMissing(vntSupportDiv) Then vntSupportDiv = objSupportDiv.Value & ""
        If Not IsMissing(vntOptionStomac) Then vntOptionStomac = objOptionStomac.Value & ""
        If Not IsMissing(vntOptionBreast) Then vntOptionBreast = objOptionBreast.Value & ""
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 Start #############
        If Not IsMissing(vntOptionCT) Then vntOptionCT = objOptionCT.Value & ""
'### 2010/05/28 張　新WEB予約システム導入に伴う項目追加 End   #############
        If Not IsMissing(vntMessage) Then vntMessage = objMessage.Value & ""
        If Not IsMissing(vntInsDate) Then vntInsDate = objInsDate.Value & ""
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
        If Not IsMissing(vntCanDate) Then vntCanDate = objCanDate.Value & ""
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntRsvNo) Then vntRsvNo = objRsvNo.Value & ""
        
'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 Start #############
        If Not IsMissing(vntIsrSign) Then vntIsrSign = objIsrSign.Value & ""
        If Not IsMissing(vntIsrNo) Then vntIsrNo = objIsrNo.Value & ""
        If Not IsMissing(vntVolunteer) Then vntVolunteer = objVolunteer.Value & ""
        If Not IsMissing(vntCardOutEng) Then vntCardOutEng = objCardOutEng.Value & ""
        If Not IsMissing(vntFormOutEng) Then vntFormOutEng = objFormOutEng.Value & ""
        If Not IsMissing(vntReportOutEng) Then vntReportOutEng = objReportOutEng.Value & ""
'### 2010/05/14 張　新WEB予約システム導入に伴う項目追加 End   #############
        
'#### 2013.2.27 SL-SN-Y0101-612 ADD START ####
        If Not IsMissing(vntNation) Then vntNation = objNation.Value & ""
'#### 2013.2.27 SL-SN-Y0101-612 ADD END   ####

'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
        If Not IsMissing(vntCslOptions) Then vntCslOptions = objCslOptions.Value & ""
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 STR ###
        If Not IsMissing(vntWebReqNo) Then vntWebReqNo = objWebReqNo.Value & ""
'#### 2017.03.20 張 WEB申し込み番号追加取得の為修正 END ###

        SelectWebRsv = True

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
    WriteErrorLog "WebRsv.SelectWebRsv"
    
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
' 機能　　 : 指定検索条件のweb予約情報を取得する
'
' 引数　　 : (In)     dtmStrCslDate  開始受診年月日
' 　　　　   (In)     dtmEndCslDate  終了受診年月日
' 　　　　   (In)     strKey         検索キー
' 　　　　   (In)     dtmStrOpDate   開始処理年月日
' 　　　　   (In)     dtmEndOpDate   終了処理年月日
' 　　　　   (In)     lngOpMode      処理モード(1:申込日で検索、2:予約処理日で検索)
' 　　　　   (In)     lngRegFlg      本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)
'#### 2010.08.07 SL-UI-Y0101-107 ADD START ####'
' 　　　　   (In)     lngMoushiKbn   申込区分（0：すべて　1:新規　2:キャンセル）
'#### 2010.08.07 SL-UI-Y0101-107 ADD END ####'
' 　　　　   (In)     lngOrder       出力順(1:受診日順、2:個人ID順)
' 　　　　   (In)     lngStartPos    取得開始位置
' 　　　　   (In)     lngGetCount    取得件数(0:全件)
' 　　　　   (Out)    vntCslDate     受診年月日
' 　　　　   (Out)    vntWebNo       webNo.
' 　　　　   (Out)    vntStartTime   受付開始時間
' 　　　　   (Out)    vntRsvGrpName  予約群名称
' 　　　　   (Out)    vntPerId       個人ID
' 　　　　   (Out)    vntFullName    姓名
' 　　　　   (Out)    vntKanaName    カナ姓名
' 　　　　   (Out)    vntLastName    (個人情報の)姓
' 　　　　   (Out)    vntFirstName   (個人情報の)名
' 　　　　   (Out)    vntLastKName   (個人情報の)カナ姓
' 　　　　   (Out)    vntFirstKName  (個人情報の)カナ名
' 　　　　   (Out)    vntGender      性別
' 　　　　   (Out)    vntBirth       生年月日
' 　　　　   (Out)    vntOrgName     団体名
' 　　　　   (Out)    vntInsDate     申し込み年月日
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
' 　　　　   (Out)    vntCanDate     キャンセル年月日
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
' 　　　　   (Out)    vntUpdDate     予約処理年月日
' 　　　　   (Out)    vntRegFlg      本登録フラグ(1:未登録者、2:編集済み受診者)
' 　　　　   (Out)    vntRsvNo       予約番号
'
' 戻り値　 : 検索条件を満たすレコード件数（取得開始位置に関わらず全件数）
'
' 備考　　 :
'
'#### 2010.08.07 SL-UI-Y0101-107 MOD START ####'
''#### 2010.06.21 SL-UI-Y0101-107 MOD START ####'
''Public Function SelectWebRsvList( _
''    ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, _
''    ByVal strKey As String, _
''    ByVal dtmStrOpDate As Date, ByVal dtmEndOpDate As Date, _
''    ByVal lngOpMode As Long, _
''    ByVal lngRegFlg As Long, _
''    ByVal lngOrder As Long, _
''    Optional ByVal lngStartPos As Long = 1, _
''    Optional ByVal lngGetCount As Long = 0, _
''    Optional ByRef vntCslDate As Variant, _
''    Optional ByRef vntWebNo As Variant, _
''    Optional ByRef vntStartTime As Variant, _
''    Optional ByRef vntRsvGrpName As Variant, _
''    Optional ByRef vntPerId As Variant, _
''    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant, _
''    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
''    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
''    Optional ByRef vntGender As Variant, _
''    Optional ByRef vntBirth As Variant, _
''    Optional ByRef vntOrgName As Variant, _
''    Optional ByRef vntInsDate As Variant, _
''    Optional ByRef vntUpdDate As Variant, _
''    Optional ByRef vntRegFlg As Variant, _
''    Optional ByRef vntRsvNo As Variant _
'') As Long
'Public Function SelectWebRsvList( _
'    ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, _
'    ByVal strKey As String, _
'    ByVal dtmStrOpDate As Date, ByVal dtmEndOpDate As Date, _
'    ByVal lngOpMode As Long, _
'    ByVal lngRegFlg As Long, _
'    ByVal lngOrder As Long, _
'    Optional ByVal lngStartPos As Long = 1, _
'    Optional ByVal lngGetCount As Long = 0, _
'    Optional ByRef vntCslDate As Variant, _
'    Optional ByRef vntWebNo As Variant, _
'    Optional ByRef vntStartTime As Variant, _
'    Optional ByRef vntRsvGrpName As Variant, _
'    Optional ByRef vntPerId As Variant, _
'    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant, _
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
'    Optional ByRef vntGender As Variant, _
'    Optional ByRef vntBirth As Variant, _
'    Optional ByRef vntOrgName As Variant, _
'    Optional ByRef vntInsDate As Variant, Optional ByRef vntCanDate As Variant, Optional ByRef vntUpdDate As Variant, _
'    Optional ByRef vntRegFlg As Variant, _
'    Optional ByRef vntRsvNo As Variant _
') As Long
''#### 2010.06.21 SL-UI-Y0101-107 MOD END ####'
Public Function SelectWebRsvList( _
    ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, _
    ByVal strKey As String, _
    ByVal dtmStrOpDate As Date, ByVal dtmEndOpDate As Date, _
    ByVal lngOpMode As Long, _
    ByVal lngRegFlg As Long, _
    ByVal lngMoushiKbn As Long, _
    ByVal lngOrder As Long, _
    Optional ByVal lngStartPos As Long = 1, _
    Optional ByVal lngGetCount As Long = 0, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntWebNo As Variant, _
    Optional ByRef vntStartTime As Variant, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntFullName As Variant, Optional ByRef vntKanaName As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntBirth As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntInsDate As Variant, Optional ByRef vntCanDate As Variant, Optional ByRef vntUpdDate As Variant, _
    Optional ByRef vntRegFlg As Variant, _
    Optional ByRef vntRsvNo As Variant _
) As Long
'#### 2010.08.07 SL-UI-Y0101-107 MOD END ####'

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim strBasedStmt        As String           '基本SQLステートメント
                                                
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDate          As OraField         '受診年月日
    Dim objWebNo            As OraField         'webNo.
    Dim objStartTime        As OraField         '受付開始時間
    Dim objRsvGrpName       As OraField         '予約群名称
    Dim objPerId            As OraField         '個人ID
    Dim objFullName         As OraField         '姓名
    Dim objKanaName         As OraField         'カナ姓名
    Dim objLastName         As OraField         '(個人情報の)姓
    Dim objFirstName        As OraField         '(個人情報の)名
    Dim objLastKName        As OraField         '(個人情報の)カナ姓
    Dim objFirstKName       As OraField         '(個人情報の)カナ名
    Dim objGender           As OraField         '性別
    Dim objBirth            As OraField         '生年月日
    Dim objOrgName          As OraField         '団体名
    Dim objInsDate          As OraField         '申し込み年月日
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
    Dim objCanDate          As OraField         'キャンセル年月日
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
    Dim objUpdDate          As OraField         '予約処理年月日
    Dim objRegFlg           As OraField         '本登録フラグ
    Dim objRsvNo            As OraField         '予約番号
                                                
    Dim vntArrCslDate()     As Variant          '受診年月日の配列
    Dim vntArrWebNo()       As Variant          'webNoの配列
    Dim vntArrStartTime()   As Variant          '受付開始時間の配列
    Dim vntArrRsvGrpName()  As Variant          '予約群名称の配列
    Dim vntArrPerId()       As Variant          '個人IDの配列
    Dim vntArrFullName()    As Variant          '姓名の配列
    Dim vntArrKanaName()    As Variant          'カナ姓名の配列
    Dim vntArrLastName()    As Variant          '(個人情報の)姓の配列
    Dim vntArrFirstName()   As Variant          '(個人情報の)名の配列
    Dim vntArrLastKName()   As Variant          '(個人情報の)カナ姓の配列
    Dim vntArrFirstKName()  As Variant          '(個人情報の)カナ名の配列
    Dim vntArrGender()      As Variant          '性別の配列
    Dim vntArrBirth()       As Variant          '生年月日の配列
    Dim vntArrOrgName()     As Variant          '団体名の配列
    Dim vntArrInsDate()     As Variant          '申し込み年月日の配列
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
    Dim vntArrCanDate()     As Variant          'キャンセル年月日の配列
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
    Dim vntArrUpdDate()     As Variant          '予約処理年月日の配列
    Dim vntArrRegFlg()      As Variant          '本登録フラグの配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
                                                
    Dim lngAllCount         As Long             '全レコード件数
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntWebNo) Then vntWebNo = Empty
    If Not IsMissing(vntStartTime) Then vntStartTime = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntFullName) Then vntFullName = Empty
    If Not IsMissing(vntKanaName) Then vntKanaName = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntInsDate) Then vntInsDate = Empty
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
    If Not IsMissing(vntCanDate) Then vntCanDate = Empty
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntRegFlg) Then vntRegFlg = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    
    'バインド変数の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDPOS", lngStartPos + lngGetCount - 1, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '基本SQL作成
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
''    strBasedStmt = CreateBasedSqlForWebRsvList(dtmStrCslDate, dtmEndCslDate, strKey, dtmStrOpDate, dtmEndOpDate, lngOpMode, lngRegFlg)
    strBasedStmt = CreateBasedSqlForWebRsvList(dtmStrCslDate, dtmEndCslDate, strKey, dtmStrOpDate, dtmEndOpDate, lngOpMode, lngRegFlg, lngMoushiKbn)
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'
    
    Do
    
        '①全レコード件数取得
        Set objOraDyna = mobjOraDb.CreateDynaset("SELECT COUNT(*) FROM ( " & strBasedStmt & " )", ORADYN_READONLY + ORADYN_NOCACHE)
        lngAllCount = objOraDyna.Fields(0).Value
        Set objOraDyna = Nothing
    
        'レコードが存在しない場合は終了
        If lngAllCount <= 0 Then
            Exit Do
        End If
    
        'SQLステートメントの編集
'#### 2010.06.21 SL-UI-Y0101-107 MOD START ####'
'        strStmt = "SELECT WEBRSV.JDATE      CSLDATE,         " & vbLf & _
'                  "       WEBRSV.WEBNO,                      " & vbLf & _
'                  "       WEBRSV.UKAITM     STARTTIME,       " & vbLf & _
'                  "       CSRSVGRP.RSVGRPNAME,               " & vbLf & _
'                  "       WEBRSV.KARNO      PERID,           " & vbLf & _
'                  "       TO_ZENKAKU(WEBRSV.NAMEJ) FULLNAME, " & vbLf & _
'                  "       TO_ZENKAKU(WEBRSV.NAMEA) KANANAME, " & vbLf & _
'                  "       PERSON.LASTNAME,                   " & vbLf & _
'                  "       PERSON.FIRSTNAME,                  " & vbLf & _
'                  "       PERSON.LASTKNAME,                  " & vbLf & _
'                  "       PERSON.FIRSTKNAME,                 " & vbLf & _
'                  "       WEBRSV.SEXFLG     GENDER,          " & vbLf & _
'                  "       WEBRSV.BIRTH,                      " & vbLf & _
'                  "       WEBRSV.GRPNAME    ORGNAME,         " & vbLf & _
'                  "       TRUNC(WEBRSV.INSERTDATE) INSDATE,  " & vbLf & _
'                  "       DECODE(WEBRSV.YKBN,                " & vbLf & _
'                  "              2, WEBRSV.UPDATEDATE,       " & vbLf & _
'                  "              NULL)      UPDDATE,         " & vbLf & _
'                  "       WEBRSV.YKBN       REGFLG,          " & vbLf & _
'                  "       WEB_RELATION.RSVNO                 " & vbLf & _
'                  "  FROM WEB_RELATION, PERSON,              "
        strStmt = "SELECT WEBRSV.JDATE      CSLDATE,         " & vbLf & _
                  "       WEBRSV.WEBNO,                      " & vbLf & _
                  "       WEBRSV.UKAITM     STARTTIME,       " & vbLf & _
                  "       CSRSVGRP.RSVGRPNAME,               " & vbLf & _
                  "       WEBRSV.KARNO      PERID,           " & vbLf & _
                  "       TO_ZENKAKU(WEBRSV.NAMEJ) FULLNAME, " & vbLf & _
                  "       TO_ZENKAKU(WEBRSV.NAMEA) KANANAME, " & vbLf & _
                  "       PERSON.LASTNAME,                   " & vbLf & _
                  "       PERSON.FIRSTNAME,                  " & vbLf & _
                  "       PERSON.LASTKNAME,                  " & vbLf & _
                  "       PERSON.FIRSTKNAME,                 " & vbLf & _
                  "       WEBRSV.SEXFLG     GENDER,          " & vbLf & _
                  "       WEBRSV.BIRTH,                      " & vbLf & _
                  "       WEBRSV.GRPNAME    ORGNAME,         " & vbLf & _
                  "       TRUNC(WEBRSV.INSERTDATE) INSDATE,  " & vbLf & _
                  "       TRUNC(WEBRSV.CANCEL_REQDT) CANDATE," & vbLf & _
                  "       DECODE(WEBRSV.YKBN,                " & vbLf & _
                  "              2, WEBRSV.UPDATEDATE,       " & vbLf & _
                  "              NULL)      UPDDATE,         " & vbLf & _
                  "       WEBRSV.YKBN       REGFLG,          " & vbLf & _
                  "       WEB_RELATION.RSVNO                 " & vbLf & _
                  "  FROM WEB_RELATION, PERSON,              "
'#### 2010.06.21 SL-UI-Y0101-107 MOD END ####'
                  
        strStmt = strStmt & vbLf & _
                  "       ( SELECT COURSE_RSVGRP.CSCD, COURSE_RSVGRP.RSVGRPCD, " & vbLf & _
                  "                RSVGRP.RSVGRPNAME,  RSVGRP.STRTIME          " & vbLf & _
                  "           FROM RSVGRP, COURSE_RSVGRP                       " & vbLf & _
                  "          WHERE COURSE_RSVGRP.RSVGRPCD = RSVGRP.RSVGRPCD    " & vbLf & _
                  "       ) CSRSVGRP,                                          "

        '開始位置、終了位置による絞り込み
        strStmt = strStmt & vbLf & _
                  "       ( SELECT WEBRSV2.* "
          
        '基本SQL＋ORDER BY句にSEQを付加
        strStmt = strStmt & vbLf & _
                  "           FROM ( SELECT ROWNUM SEQ, WEBRSV1.* "

        '基本SQLにORDER BY句を追加
        strStmt = strStmt & vbLf & _
                  "                    FROM ( " & strBasedStmt & " " & OrderByStatement(lngOrder) & " ) WEBRSV1 "

        '基本SQL＋ORDER BY句にSEQを付加
        strStmt = strStmt & vbLf & _
                  "                ) WEBRSV2 "
          
        '開始位置、取得件数指定時は絞り込み
        If lngStartPos > 0 And lngGetCount > 0 Then
            strStmt = strStmt & vbLf & _
                  "          WHERE SEQ BETWEEN :STARTPOS AND :ENDPOS "
        End If

        '開始位置、終了位置による絞り込み
        strStmt = strStmt & vbLf & _
                  "       ) WEBRSV "
          
'#### 2010.08.07 SL-UI-Y0101-107 MOD START ####'
'        strStmt = strStmt & vbLf & _
'                  " WHERE WEBRSV.CSCD   = CSRSVGRP.CSCD(+)        " & vbLf & _
'                  "   AND WEBRSV.UKAITM = CSRSVGRP.STRTIME(+)     " & vbLf & _
'                  "   AND WEBRSV.KARNO  = PERSON.PERID(+)         " & vbLf & _
'                  "   AND WEBRSV.JDATE  = WEB_RELATION.CSLDATE(+) " & vbLf & _
'                  "   AND WEBRSV.WEBNO  = WEB_RELATION.WEBNO(+)   " & vbLf & _
'                  " ORDER BY WEBRSV.SEQ                           "
        strStmt = strStmt & vbLf & _
                  " WHERE WEBRSV.CSCD   = CSRSVGRP.CSCD(+)        " & vbLf & _
                  "   AND WEBRSV.UKAITM = CSRSVGRP.STRTIME(+)     " & vbLf & _
                  "   AND WEBRSV.KARNO  = PERSON.PERID(+)         " & vbLf & _
                  "   AND WEBRSV.JDATE  = WEB_RELATION.CSLDATE(+) " & vbLf & _
                  "   AND WEBRSV.WEBNO  = WEB_RELATION.WEBNO(+)   "
        '申込区分による条件追加
        Select Case lngMoushiKbn
        Case 0
            '0：すべての場合：条件なし
        Case 1
            '1：新規の場合：キャンセル申込日付が空のもの
            strStmt = strStmt & vbLf & _
                  "   AND WEBRSV.CANCEL_REQDT IS NULL             "
        Case 2
            '2：キャンセルの場合：キャンセル申込日付にデータがあるもの
            strStmt = strStmt & vbLf & _
                  "   AND WEBRSV.CANCEL_REQDT IS NOT NULL         "
        End Select
        strStmt = strStmt & vbLf & _
                  " ORDER BY WEBRSV.SEQ                           " & vbLf
'#### 2010.08.07 SL-UI-Y0101-107 MOD END ####'

        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在しない場合は処理終了
        If objOraDyna.EOF Then
            Exit Do
        End If
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objWebNo = objFields("WEBNO")
        Set objStartTime = objFields("STARTTIME")
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objPerId = objFields("PERID")
        Set objFullName = objFields("FULLNAME")
        Set objKanaName = objFields("KANANAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objOrgName = objFields("ORGNAME")
        Set objInsDate = objFields("INSDATE")
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
        Set objCanDate = objFields("CANDATE")
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
        Set objUpdDate = objFields("UPDDATE")
        Set objRegFlg = objFields("REGFLG")
        Set objRsvNo = objFields("RSVNO")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrWebNo(lngCount)
            ReDim Preserve vntArrStartTime(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrFullName(lngCount)
            ReDim Preserve vntArrKanaName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrBirth(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrInsDate(lngCount)
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
            ReDim Preserve vntArrCanDate(lngCount)
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrRegFlg(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrWebNo(lngCount) = objWebNo.Value & ""
            vntArrStartTime(lngCount) = objStartTime.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrFullName(lngCount) = OmitWideSpace(objFullName.Value & "")
            vntArrKanaName(lngCount) = OmitWideSpace(objKanaName.Value & "")
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrBirth(lngCount) = Format(CLng("0" & objBirth.Value), "0000/00/00")
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrInsDate(lngCount) = objInsDate.Value & ""
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
            vntArrCanDate(lngCount) = objCanDate.Value & ""
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrRegFlg(lngCount) = objRegFlg.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        'オブジェクトの解放
        Set objCslDate = Nothing
        Set objWebNo = Nothing
        Set objStartTime = Nothing
        Set objRsvGrpName = Nothing
        Set objPerId = Nothing
        Set objFullName = Nothing
        Set objKanaName = Nothing
        Set objLastName = Nothing
        Set objFirstName = Nothing
        Set objLastKName = Nothing
        Set objFirstKName = Nothing
        Set objGender = Nothing
        Set objBirth = Nothing
        Set objOrgName = Nothing
        Set objInsDate = Nothing
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
        Set objCanDate = Nothing
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
        Set objUpdDate = Nothing
        Set objRegFlg = Nothing
        Set objRsvNo = Nothing
        Set objFields = Nothing
        
        '戻り値の設定
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntWebNo) Then vntWebNo = vntArrWebNo
        If Not IsMissing(vntStartTime) Then vntStartTime = vntArrStartTime
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntFullName) Then vntFullName = vntArrFullName
        If Not IsMissing(vntKanaName) Then vntKanaName = vntArrKanaName
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
        If Not IsMissing(vntInsDate) Then vntInsDate = vntArrInsDate
'#### 2010.06.21 SL-UI-Y0101-107 ADD START ####'
        If Not IsMissing(vntCanDate) Then vntCanDate = vntArrCanDate
'#### 2010.06.21 SL-UI-Y0101-107 ADD END ####'
        If Not IsMissing(vntUpdDate) Then vntUpdDate = vntArrUpdDate
        If Not IsMissing(vntRegFlg) Then vntRegFlg = vntArrRegFlg
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        
        Exit Do
    Loop
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    '戻り値の設定
    SelectWebRsvList = lngAllCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectWebRsvList = -1
    
    'イベントログ書き込み
    WriteErrorLog "WebRsv.SelectWebRsvList"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Resume Next
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 指定検索条件のweb予約情報のうち、指定受診年月日、webNoの次レコードを取得
'
' 引数　　 : (In)     dtmStrCslDate  開始受診年月日
' 　　　　   (In)     dtmEndCslDate  終了受診年月日
' 　　　　   (In)     strKey         検索キー
' 　　　　   (In)     dtmStrOpDate   開始処理年月日
' 　　　　   (In)     dtmEndOpDate   終了処理年月日
' 　　　　   (In)     lngOpMode      処理モード(1:申込日で検索、2:予約処理日で検索)
' 　　　　   (In)     lngRegFlg      本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)
' 　　　　   (In)     lngOrder       出力順(1:受診日順、2:個人ID順)
' 　　　　   (In)     dtmCslDate     受診年月日
' 　　　　   (In)     lngWebNo       webNo.
' 　　　　   (Out)    vntCslDate     (次レコードの)受診年月日
' 　　　　   (Out)    vntWebNo       (次レコードの)webNo.
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
''#### 2010.06.21 SL-UI-Y0101-107 MOD START ####'
Public Function SelectWebRsvNext( _
    ByVal dtmStrCslDate As Date, _
    ByVal dtmEndCslDate As Date, _
    ByVal strKey As String, _
    ByVal dtmStrOpDate As Date, _
    ByVal dtmEndOpDate As Date, _
    ByVal lngOpMode As Long, _
    ByVal lngRegFlg As Long, _
    ByVal lngMoushiKbn As Long, _
    ByVal lngOrder As Long, _
    ByVal dtmCslDate As Date, _
    ByVal lngWebNo As Long, _
    ByRef vntCslDate As Variant, _
    ByRef vntWebNo As Variant _
) As Boolean
''Public Function SelectWebRsvNext( _
''    ByVal dtmStrCslDate As Date, _
''    ByVal dtmEndCslDate As Date, _
''    ByVal strKey As String, _
''    ByVal dtmStrOpDate As Date, _
''    ByVal dtmEndOpDate As Date, _
''    ByVal lngOpMode As Long, _
''    ByVal lngRegFlg As Long, _
''    ByVal lngOrder As Long, _
''    ByVal dtmCslDate As Date, _
''    ByVal lngWebNo As Long, _
''    ByRef vntCslDate As Variant, _
''    ByRef vntWebNo As Variant _
'') As Boolean
''#### 2010.06.21 SL-UI-Y0101-107 MOD END ####'

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim strBasedStmt    As String           '基本SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCslDate      As OraField         '受診年月日
    Dim objWebNo        As OraField         'webNo.
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntWebNo) Then vntWebNo = Empty
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "WEBNO", lngWebNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '基本SQL作成
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
''    strBasedStmt = CreateBasedSqlForWebRsvList(dtmStrCslDate, dtmEndCslDate, strKey, dtmStrOpDate, dtmEndOpDate, lngOpMode, lngRegFlg)
    strBasedStmt = CreateBasedSqlForWebRsvList(dtmStrCslDate, dtmEndCslDate, strKey, dtmStrOpDate, dtmEndOpDate, lngOpMode, lngRegFlg, lngMoushiKbn)
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'
    
    'SQLステートメントの編集
    strStmt = "SELECT WEBRSV.NEXTCSLDATE, " & vbLf & _
              "       WEBRSV.NEXTWEBNO    "
              
    '分析関数LAGを使用し、自レコードの次SEQ値のレコードを付加
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT LAG(WEBRSV2.JDATE, 1, NULL) OVER (ORDER BY WEBRSV2.SEQ DESC) NEXTCSLDATE, " & vbLf & _
              "                LAG(WEBRSV2.WEBNO, 1, NULL) OVER (ORDER BY WEBRSV2.SEQ DESC) NEXTWEBNO,   " & vbLf & _
              "                WEBRSV2.JDATE,                                                            " & vbLf & _
              "                WEBRSV2.WEBNO                                                             "

    '基本SQL＋ORDER BY句にSEQを付加
    strStmt = strStmt & vbLf & _
              "           FROM ( SELECT ROWNUM SEQ, WEBRSV1.* "

    '基本SQLにORDER BY句を追加
    strStmt = strStmt & vbLf & _
              "                    FROM ( " & strBasedStmt & " " & OrderByStatement(lngOrder) & " ) WEBRSV1 "

    '基本SQL＋ORDER BY句にSEQを付加
    strStmt = strStmt & vbLf & _
              "                ) WEBRSV2 "
      
    '分析関数LAGを使用し、自レコードの次SEQ値のレコードを付加
    strStmt = strStmt & vbLf & _
              "       ) WEBRSV "
      
    '指定受診年月日、webNoのレコードのみを取得、但し次SEQのレコードが存在しない(最終レコード)ものは除く
    strStmt = strStmt & vbLf & _
              " WHERE WEBRSV.JDATE        = :CSLDATE " & vbLf & _
              "   AND WEBRSV.WEBNO        = :WEBNO   " & vbLf & _
              "   AND WEBRSV.NEXTCSLDATE IS NOT NULL " & vbLf & _
              "   AND WEBRSV.NEXTWEBNO   IS NOT NULL "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("NEXTCSLDATE")
        Set objWebNo = objFields("NEXTWEBNO")

        '戻り値の設定
        If Not IsMissing(vntCslDate) Then vntCslDate = objCslDate.Value & ""
        If Not IsMissing(vntWebNo) Then vntWebNo = objWebNo.Value & ""
        
        SelectWebRsvNext = True

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
    WriteErrorLog "WebRsv.SelectWebRsvNext"
    
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
