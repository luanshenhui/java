VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Free"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 受診日時点の年齢計算
'
' 引数　　 : (In)     strBirth    生年月日
' 　　　　 : (In)     vntCslDate  受診日
' 　　　　 : (In)     vntBsDate   起算日
'
' 戻り値　 : 年齢＋月齢
'
' 備考　　 :
'
Public Function CalcAge(ByVal dtmBirth As Date, Optional vntCslDate As Variant, Optional vntBsDate As Variant) As Variant

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
'### 2004/1/14 Added by Ishihara@FSIT 原因不明のエラー追及のため
    Dim strTrapBirth        As String
    Dim strTrapCslDate      As String
    Dim strTrapBsDate       As String

    strTrapBirth = CStr(dtmBirth)
    If Not IsMissing(vntCslDate) Then strTrapCslDate = CStr(vntCslDate)
    If Not IsMissing(vntBsDate) Then strTrapBsDate = CStr(vntBsDate)
'### 2004/1/14 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '引数値のバインド変数定義
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BIRTH", dtmBirth, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSLDATE", Now(), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BSDATE", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '引数値の設定
    If Not IsMissing(vntCslDate) Then
        objOraParam("CSLDATE").Value = CDate(vntCslDate)
    End If
    
    If Not IsMissing(vntBsDate) Then
        If vntBsDate <> "" Then
            objOraParam("BSDATE").Value = CStr(vntBsDate)
        End If
    End If
    
    '年齢計算
    strStmt = "SELECT GetCslAge(:BIRTH, :CSLDATE, :BSDATE) AGE FROM DUAL"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '戻り値の設定
    CalcAge = objOraDyna.Fields("AGE").Value & ""

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.CalcAge"
    
'### 2004/1/14 Added by Ishihara@FSIT 原因不明のエラー追及のため
    App.LogEvent "Free.CalcAge Error Trap" & vbLf & _
                 "Birth=" & strTrapBirth & vbLf & _
                 "CslDate=" & strTrapCslDate & vbLf & _
                 "BsDate=" & strTrapBsDate
'### 2004/1/14 Added End
    
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
' 機能　　 : 汎用テーブルレコード挿入
'
' 引数　　 : (In)     strFreeCd       汎用コード
' 　　　　   (In)     strFreeClassCd  汎用分類コード
' 　　　　   (In)     strFreeName     汎用名
' 　　　　   (In)     vntFreeDate     汎用日付
' 　　　　   (In)     vntFreeField1   汎用フィールド1
' 　　　　   (In)     vntFreeField2   汎用フィールド2
' 　　　　   (In)     vntFreeField3   汎用フィールド3
' 　　　　   (In)     vntFreeField4   汎用フィールド4
' 　　　　   (In)     vntFreeField5   汎用フィールド5
' 　　　　   (In)     vntFreeField6   汎用フィールド6
' 　　　　   (In)     vntFreeField7   汎用フィールド7
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function InsertFree( _
    ByVal strFreeCd As String, _
    ByVal strFreeClassCd As String, _
    ByVal strFreeName As String, _
    Optional ByVal vntFreeDate As Variant, _
    Optional ByVal vntFreeField1 As Variant, _
    Optional ByVal vntFreeField2 As Variant, _
    Optional ByVal vntFreeField3 As Variant, _
    Optional ByVal vntFreeField4 As Variant, _
    Optional ByVal vntFreeField5 As Variant, _
    Optional ByVal vntFreeField6 As Variant, _
    Optional ByVal vntFreeField7 As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim strInsFreeName  As String           '汎用名

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    InsertFree = INSERT_ERROR
    
    'デフォルト値の設定
    Select Case Trim(strFreeCd)
        Case "DOCNO"
            strInsFreeName = "文書番号発番管理"
        Case "ORDERNO"
            strInsFreeName = "オーダ番号発番管理"
        Case Else
            strInsFreeName = Trim(strFreeName)
    End Select
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FREECD", Trim(strFreeCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREECLASSCD", Trim(strFreeClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREENAME", strInsFreeName, ORAPARM_INPUT, ORATYPE_VARCHAR2

    If Not IsMissing(vntFreeDate) Then
        If Trim(vntFreeDate) <> "" Then
            objOraParam.Add "FREEDATE", CDate(vntFreeDate), ORAPARM_INPUT, ORATYPE_DATE
        End If
    End If
    
    If Not IsMissing(vntFreeField1) Then
        objOraParam.Add "FREEFIELD1", Trim(vntFreeField1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField2) Then
        objOraParam.Add "FREEFIELD2", Trim(vntFreeField2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField3) Then
        objOraParam.Add "FREEFIELD3", Trim(vntFreeField3), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField4) Then
        objOraParam.Add "FREEFIELD4", Trim(vntFreeField4), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField5) Then
        objOraParam.Add "FREEFIELD5", Trim(vntFreeField5), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField6) Then
        objOraParam.Add "FREEFIELD6", Trim(vntFreeField6), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField7) Then
        objOraParam.Add "FREEFIELD7", Trim(vntFreeField7), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
'### 2003.02.15 Added End
    
    '汎用テーブルレコードの挿入
    strStmt = "INSERT INTO FREE (        " & vbLf & _
              "            FREECD,       " & vbLf & _
              "            FREECLASSCD,  " & vbLf & _
              "            FREENAME"
              
    '汎用日付指定時の処理
    If Not IsMissing(vntFreeDate) Then
        If Trim(vntFreeDate) <> "" Then
            strStmt = strStmt & ", " & vbLf & _
                  "            FREEDATE"
        End If
    End If

    '汎用フィールド指定時の処理
    If Not IsMissing(vntFreeField1) Then
        strStmt = strStmt & ", " & vbLf & _
              "            FREEFIELD1"
    End If

    If Not IsMissing(vntFreeField2) Then
        strStmt = strStmt & ", " & vbLf & _
              "            FREEFIELD2"
    End If

    If Not IsMissing(vntFreeField3) Then
        strStmt = strStmt & ", " & vbLf & _
              "            FREEFIELD3"
    End If

    If Not IsMissing(vntFreeField4) Then
        strStmt = strStmt & ", " & vbLf & _
              "            FREEFIELD4"
    End If

    If Not IsMissing(vntFreeField5) Then
        strStmt = strStmt & ", " & vbLf & _
              "            FREEFIELD5"
    End If

'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField6) Then
        strStmt = strStmt & ", " & vbLf & _
              "            FREEFIELD6"
    End If

    If Not IsMissing(vntFreeField7) Then
        strStmt = strStmt & ", " & vbLf & _
              "            FREEFIELD7"
    End If
'### 2003.02.15 Added End

    strStmt = strStmt & " " & vbLf & _
              "       ) VALUES (         " & vbLf & _
              "            :FREECD,      " & vbLf & _
              "            :FREECLASSCD, " & vbLf & _
              "            :FREENAME"

    '汎用日付指定時の処理
    If Not IsMissing(vntFreeDate) Then
        If Trim(vntFreeDate) <> "" Then
            strStmt = strStmt & ", " & vbLf & _
                  "            :FREEDATE"
        End If
    End If

    '汎用フィールド指定時の処理
    If Not IsMissing(vntFreeField1) Then
        strStmt = strStmt & ", " & vbLf & _
              "            :FREEFIELD1"
    End If

    If Not IsMissing(vntFreeField2) Then
        strStmt = strStmt & ", " & vbLf & _
              "            :FREEFIELD2"
    End If

    If Not IsMissing(vntFreeField3) Then
        strStmt = strStmt & ", " & vbLf & _
              "            :FREEFIELD3"
    End If

    If Not IsMissing(vntFreeField4) Then
        strStmt = strStmt & ", " & vbLf & _
              "            :FREEFIELD4"
    End If

    If Not IsMissing(vntFreeField5) Then
        strStmt = strStmt & ", " & vbLf & _
              "            :FREEFIELD5"
    End If
    
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField5) Then
        strStmt = strStmt & ", " & vbLf & _
              "            :FREEFIELD6"
    End If

    If Not IsMissing(vntFreeField5) Then
        strStmt = strStmt & ", " & vbLf & _
              "            :FREEFIELD7"
    End If
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    
    strStmt = strStmt & " " & vbLf & _
              "       )"
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    InsertFree = INSERT_NORMAL

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'キー重複時
    If mobjOraDb.LastServerErr = 1 Then
        
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
        
        '戻り値の設定
        InsertFree = INSERT_DUPLICATE
        
        Exit Function
    End If

    'イベントログ書き込み
    WriteErrorLog "Free.InsertFree"
    
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
' 機能　　 : 汎用テーブル読み込み
'
' 引数　　 : (In)     lngMode        検索モード(0:一意検索、1:前方一致検索、2:全件)
' 　　　　   (In)     strFreeCdKey   汎用コード(検索キー値)
' 　　　　   (Out)    vntFreeCd      汎用コード
' 　　　　   (Out)    vntFreeName    汎用名
' 　　　　   (Out)    vntFreeDate    汎用日付
' 　　　　   (Out)    vntFreeField1  汎用フィールド1
' 　　　　   (Out)    vntFreeField2  汎用フィールド2
' 　　　　   (Out)    vntFreeField3  汎用フィールド3
' 　　　　   (Out)    vntFreeField4  汎用フィールド4
' 　　　　   (Out)    vntFreeField5  汎用フィールド5
' 　　　　   (In)     blnLock        レコードロック実施有無
' 　　　　   (Out)    vntFreeClassCd 汎用分類コード
' 　　　　   (Out)    vntFreeField6  汎用フィールド6
' 　　　　   (Out)    vntFreeField7  汎用フィールド7
'
' 戻り値　 : レコード件数
'
' 備考　　 : 検索モードが前方一致検索の場合、Out引数は配列形式で返す
'
Public Function SelectFree( _
    ByVal lngMode As Long, _
    ByVal strFreeCdKey As String, _
    Optional ByRef vntFreeCd As Variant, _
    Optional ByRef vntFreeName As Variant, _
    Optional ByRef vntFreeDate As Variant, _
    Optional ByRef vntFreeField1 As Variant, _
    Optional ByRef vntFreeField2 As Variant, _
    Optional ByRef vntFreeField3 As Variant, _
    Optional ByRef vntFreeField4 As Variant, _
    Optional ByRef vntFreeField5 As Variant, _
    Optional ByVal blnLock As Boolean = False, _
    Optional ByRef vntFreeClassCd As Variant, _
    Optional ByRef vntFreeField6 As Variant, _
    Optional ByRef vntFreeField7 As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objFreeCd           As OraField         '汎用コード
    Dim objFreeName         As OraField         '汎用名
    Dim objFreeDate         As OraField         '汎用日付
    Dim objFreeField1       As OraField         '汎用フィールド1
    Dim objFreeField2       As OraField         '汎用フィールド2
    Dim objFreeField3       As OraField         '汎用フィールド3
    Dim objFreeField4       As OraField         '汎用フィールド4
    Dim objFreeField5       As OraField         '汎用フィールド5
    Dim objFreeClassCd      As OraField         '汎用分類コード
    
    Dim vntArrFreeCd()      As Variant          '汎用コードの配列
    Dim vntArrFreeName()    As Variant          '汎用名の配列
    Dim vntArrFreeDate()    As Variant          '汎用日付の配列
    Dim vntArrFreeField1()  As Variant          '汎用フィールド1の配列
    Dim vntArrFreeField2()  As Variant          '汎用フィールド2の配列
    Dim vntArrFreeField3()  As Variant          '汎用フィールド3の配列
    Dim vntArrFreeField4()  As Variant          '汎用フィールド4の配列
    Dim vntArrFreeField5()  As Variant          '汎用フィールド5の配列
    Dim vntArrFreeClassCd() As Variant          '汎用分類コードの配列
    
    Dim vntRetFreeCd        As Variant          '汎用コード
    Dim vntRetFreeName      As Variant          '汎用名
    Dim vntRetFreeDate      As Variant          '汎用日付
    Dim vntRetFreeField1    As Variant          '汎用フィールド1
    Dim vntRetFreeField2    As Variant          '汎用フィールド2
    Dim vntRetFreeField3    As Variant          '汎用フィールド3
    Dim vntRetFreeField4    As Variant          '汎用フィールド4
    Dim vntRetFreeField5    As Variant          '汎用フィールド5
    Dim vntRetFreeClassCd   As Variant          '汎用分類コード
    Dim strKey              As String           '検索キー
    Dim lngCount            As Long             'レコード数

'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    Dim objFreeField6       As OraField         '汎用フィールド6
    Dim objFreeField7       As OraField         '汎用フィールド7

    Dim vntArrFreeField6()  As Variant          '汎用フィールド6の配列
    Dim vntArrFreeField7()  As Variant          '汎用フィールド7の配列

    Dim vntRetFreeField6    As Variant          '汎用フィールド6
    Dim vntRetFreeField7    As Variant          '汎用フィールド7
'### 2003.02.15 Added End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntFreeCd) Then vntFreeCd = Empty
    If Not IsMissing(vntFreeName) Then vntFreeName = Empty
    If Not IsMissing(vntFreeDate) Then vntFreeDate = Empty
    If Not IsMissing(vntFreeField1) Then vntFreeField1 = Empty
    If Not IsMissing(vntFreeField2) Then vntFreeField2 = Empty
    If Not IsMissing(vntFreeField3) Then vntFreeField3 = Empty
    If Not IsMissing(vntFreeField4) Then vntFreeField4 = Empty
    If Not IsMissing(vntFreeField5) Then vntFreeField5 = Empty
    If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = Empty
    
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField6) Then vntFreeField6 = Empty
    If Not IsMissing(vntFreeField7) Then vntFreeField7 = Empty
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    
    lngCount = 0

    '検索モードごとの検索キー値設定
    strKey = Trim(strFreeCdKey) & IIf(lngMode = 1 Or lngMode = 3, "%", "")

    'キー値の設定
    If lngMode <> 2 Then
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "FREECD", strKey, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If

    '指定予約番号の受診オプション管理情報を取得する
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
'    strStmt = "SELECT FREECD,     FREENAME,   FREEDATE,   FREEFIELD1, " & vbLf & _
              "       FREEFIELD2, FREEFIELD3, FREEFIELD4, FREEFIELD5, FREECLASSCD  " & vbLf & _
              "  FROM FREE                                            "
    strStmt = "SELECT FREECD,     FREENAME,   FREEDATE,   FREEFIELD1, " & vbLf & _
              "       FREEFIELD2, FREEFIELD3, FREEFIELD4, FREEFIELD5, FREECLASSCD, " & vbLf & _
              "       FREEFIELD6, FREEFIELD7                                       " & vbLf & _
              "  FROM FREE                                            "
'### 2003.02.15 Added End
              
    '検索モードごとの条件節設定
    Select Case lngMode
        
        Case 0  '一意検索の場合
            
            strStmt = strStmt & vbLf & _
              " WHERE FREECD = :FREECD "
              
        Case 1  '前方一致検索の場合
        
            strStmt = strStmt & vbLf & _
              " WHERE FREECD LIKE :FREECD " & vbLf & _
              " ORDER BY FREECD           "
    
        Case 2  '全件取得の場合
            
            strStmt = strStmt & vbLf & _
              " ORDER BY FREECD"
        
'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため追加 Start ##
        
        Case 3  '前方一致検索で順番設定の場合
        
            strStmt = strStmt & vbLf & _
              " WHERE FREECD LIKE :FREECD " & vbLf & _
              " ORDER BY TO_NUMBER(FREEFIELD3)           "

'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため追加 End   ##
    
    End Select
    
    'レコードロック指定
    If blnLock Then
        strStmt = strStmt & vbLf & _
          "   FOR UPDATE"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objFreeCd = objFields("FREECD")
        Set objFreeName = objFields("FREENAME")
        Set objFreeDate = objFields("FREEDATE")
        Set objFreeField1 = objFields("FREEFIELD1")
        Set objFreeField2 = objFields("FREEFIELD2")
        Set objFreeField3 = objFields("FREEFIELD3")
        Set objFreeField4 = objFields("FREEFIELD4")
        Set objFreeField5 = objFields("FREEFIELD5")
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        Set objFreeField6 = objFields("FREEFIELD6")
        Set objFreeField7 = objFields("FREEFIELD7")
'### 2003.02.15 Added End
        Set objFreeClassCd = objFields("FREECLASSCD")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrFreeCd(lngCount)
            ReDim Preserve vntArrFreeName(lngCount)
            ReDim Preserve vntArrFreeDate(lngCount)
            ReDim Preserve vntArrFreeField1(lngCount)
            ReDim Preserve vntArrFreeField2(lngCount)
            ReDim Preserve vntArrFreeField3(lngCount)
            ReDim Preserve vntArrFreeField4(lngCount)
            ReDim Preserve vntArrFreeField5(lngCount)
            ReDim Preserve vntArrFreeClassCd(lngCount)
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
            ReDim Preserve vntArrFreeField6(lngCount)
            ReDim Preserve vntArrFreeField7(lngCount)
'### 2003.02.15 Added End
            vntArrFreeCd(lngCount) = objFreeCd.Value
            vntArrFreeName(lngCount) = objFreeName.Value
            vntArrFreeDate(lngCount) = objFreeDate.Value & ""
            vntArrFreeField1(lngCount) = objFreeField1.Value & ""
            vntArrFreeField2(lngCount) = objFreeField2.Value & ""
            vntArrFreeField3(lngCount) = objFreeField3.Value & ""
            vntArrFreeField4(lngCount) = objFreeField4.Value & ""
            vntArrFreeField5(lngCount) = objFreeField5.Value & ""
            vntArrFreeClassCd(lngCount) = objFreeClassCd.Value & ""
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
            vntArrFreeField6(lngCount) = objFreeField6.Value & ""
            vntArrFreeField7(lngCount) = objFreeField7.Value & ""
'### 2003.02.15 Added ENd
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '検索モードごとの戻り値設定
        Select Case lngMode
            
            Case 0  '一意検索の場合
                
                vntRetFreeCd = vntArrFreeCd(0)
                vntRetFreeName = vntArrFreeName(0)
                vntRetFreeDate = vntArrFreeDate(0)
                vntRetFreeField1 = vntArrFreeField1(0)
                vntRetFreeField2 = vntArrFreeField2(0)
                vntRetFreeField3 = vntArrFreeField3(0)
                vntRetFreeField4 = vntArrFreeField4(0)
                vntRetFreeField5 = vntArrFreeField5(0)
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
                vntRetFreeField6 = vntArrFreeField6(0)
                vntRetFreeField7 = vntArrFreeField7(0)
'### 2003.02.15 Added End
                vntRetFreeClassCd = vntArrFreeClassCd(0)
                  
'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため修正 Start ##
            'Case 1, 2 '前方一致検索、全件の場合
            Case 1, 2, 3 '前方一致検索、全件の場合
'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため修正 End   ##
            
                vntRetFreeCd = vntArrFreeCd
                vntRetFreeName = vntArrFreeName
                vntRetFreeDate = vntArrFreeDate
                vntRetFreeField1 = vntArrFreeField1
                vntRetFreeField2 = vntArrFreeField2
                vntRetFreeField3 = vntArrFreeField3
                vntRetFreeField4 = vntArrFreeField4
                vntRetFreeField5 = vntArrFreeField5
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
                vntRetFreeField6 = vntArrFreeField6
                vntRetFreeField7 = vntArrFreeField7
'### 2003.02.15 Added End
                vntRetFreeClassCd = vntArrFreeClassCd
        
        End Select
        
        If Not IsMissing(vntFreeCd) Then vntFreeCd = vntRetFreeCd
        If Not IsMissing(vntFreeName) Then vntFreeName = vntRetFreeName
        If Not IsMissing(vntFreeDate) Then vntFreeDate = vntRetFreeDate
        If Not IsMissing(vntFreeField1) Then vntFreeField1 = vntRetFreeField1
        If Not IsMissing(vntFreeField2) Then vntFreeField2 = vntRetFreeField2
        If Not IsMissing(vntFreeField3) Then vntFreeField3 = vntRetFreeField3
        If Not IsMissing(vntFreeField4) Then vntFreeField4 = vntRetFreeField4
        If Not IsMissing(vntFreeField5) Then vntFreeField5 = vntRetFreeField5
        If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = vntRetFreeClassCd
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        If Not IsMissing(vntFreeField6) Then vntFreeField6 = vntRetFreeField6
        If Not IsMissing(vntFreeField7) Then vntFreeField7 = vntRetFreeField7
'### 2003.02.15 Added End
    
    End If
    
    'バインド変数の削除
    If lngMode <> 2 Then
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    SelectFree = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.SelectFree"
    
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
' 機能　　 : 汎用テーブル読み込み
'
' 引数　　 : (In)     lngMode        検索モード(0:一意検索、1:前方一致検索、2:全件)
' 　　　　   (In)     strFreeCdKey   汎用コード(検索キー値)
' 　　　　   (In)     strFreeCdKey   汎用コード(検索キー値)
' 　　　　   (Out)    vntFreeCd      汎用コード
' 　　　　   (Out)    vntFreeName    汎用名
' 　　　　   (Out)    vntFreeDate    汎用日付
' 　　　　   (Out)    vntFreeField1  汎用フィールド1
' 　　　　   (Out)    vntFreeField2  汎用フィールド2
' 　　　　   (Out)    vntFreeField3  汎用フィールド3
' 　　　　   (Out)    vntFreeField4  汎用フィールド4
' 　　　　   (Out)    vntFreeField5  汎用フィールド5
' 　　　　   (In)     blnLock        レコードロック実施有無
' 　　　　   (Out)    vntFreeClassCd 汎用分類コード
' 　　　　   (Out)    vntFreeField6  汎用フィールド6
' 　　　　   (Out)    vntFreeField7  汎用フィールド7
'
' 戻り値　 : レコード件数
'
' 備考　　 : 検索モードが前方一致検索の場合、Out引数は配列形式で返す
'
Public Function SelectFreeDate( _
    ByVal lngMode As Long, _
    ByVal strFreeCdKey As String, _
    ByVal strCslDate As String, _
    Optional ByRef vntFreeCd As Variant, _
    Optional ByRef vntFreeName As Variant, _
    Optional ByRef vntFreeDate As Variant, _
    Optional ByRef vntFreeField1 As Variant, _
    Optional ByRef vntFreeField2 As Variant, _
    Optional ByRef vntFreeField3 As Variant, _
    Optional ByRef vntFreeField4 As Variant, _
    Optional ByRef vntFreeField5 As Variant, _
    Optional ByVal blnLock As Boolean = False, _
    Optional ByRef vntFreeClassCd As Variant, _
    Optional ByRef vntFreeField6 As Variant, _
    Optional ByRef vntFreeField7 As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objFreeCd           As OraField         '汎用コード
    Dim objFreeName         As OraField         '汎用名
    Dim objFreeDate         As OraField         '汎用日付
    Dim objFreeField1       As OraField         '汎用フィールド1
    Dim objFreeField2       As OraField         '汎用フィールド2
    Dim objFreeField3       As OraField         '汎用フィールド3
    Dim objFreeField4       As OraField         '汎用フィールド4
    Dim objFreeField5       As OraField         '汎用フィールド5
    Dim objFreeClassCd      As OraField         '汎用分類コード
    
    Dim vntArrFreeCd()      As Variant          '汎用コードの配列
    Dim vntArrFreeName()    As Variant          '汎用名の配列
    Dim vntArrFreeDate()    As Variant          '汎用日付の配列
    Dim vntArrFreeField1()  As Variant          '汎用フィールド1の配列
    Dim vntArrFreeField2()  As Variant          '汎用フィールド2の配列
    Dim vntArrFreeField3()  As Variant          '汎用フィールド3の配列
    Dim vntArrFreeField4()  As Variant          '汎用フィールド4の配列
    Dim vntArrFreeField5()  As Variant          '汎用フィールド5の配列
    Dim vntArrFreeClassCd() As Variant          '汎用分類コードの配列
    
    Dim vntRetFreeCd        As Variant          '汎用コード
    Dim vntRetFreeName      As Variant          '汎用名
    Dim vntRetFreeDate      As Variant          '汎用日付
    Dim vntRetFreeField1    As Variant          '汎用フィールド1
    Dim vntRetFreeField2    As Variant          '汎用フィールド2
    Dim vntRetFreeField3    As Variant          '汎用フィールド3
    Dim vntRetFreeField4    As Variant          '汎用フィールド4
    Dim vntRetFreeField5    As Variant          '汎用フィールド5
    Dim vntRetFreeClassCd   As Variant          '汎用分類コード
    Dim strKey              As String           '検索キー
    Dim lngCount            As Long             'レコード数

'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    Dim objFreeField6       As OraField         '汎用フィールド6
    Dim objFreeField7       As OraField         '汎用フィールド7

    Dim vntArrFreeField6()  As Variant          '汎用フィールド6の配列
    Dim vntArrFreeField7()  As Variant          '汎用フィールド7の配列

    Dim vntRetFreeField6    As Variant          '汎用フィールド6
    Dim vntRetFreeField7    As Variant          '汎用フィールド7
'### 2003.02.15 Added End

    Dim dtmCslDate  As Date                     '受診年月日

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntFreeCd) Then vntFreeCd = Empty
    If Not IsMissing(vntFreeName) Then vntFreeName = Empty
    If Not IsMissing(vntFreeDate) Then vntFreeDate = Empty
    If Not IsMissing(vntFreeField1) Then vntFreeField1 = Empty
    If Not IsMissing(vntFreeField2) Then vntFreeField2 = Empty
    If Not IsMissing(vntFreeField3) Then vntFreeField3 = Empty
    If Not IsMissing(vntFreeField4) Then vntFreeField4 = Empty
    If Not IsMissing(vntFreeField5) Then vntFreeField5 = Empty
    If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = Empty
    
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField6) Then vntFreeField6 = Empty
    If Not IsMissing(vntFreeField7) Then vntFreeField7 = Empty
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    
    lngCount = 0

    '検索モードごとの検索キー値設定
    strKey = Trim(strFreeCdKey) & IIf(lngMode = 1 Or lngMode = 3, "%", "")

    '受診年月日の編集(日付タイプに変換）
    If strCslDate <> "" Then
        dtmCslDate = CDate(strCslDate)
    End If

    'キー値の設定
    If lngMode <> 2 Then
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "FREECD", strKey, ORAPARM_INPUT, ORATYPE_VARCHAR2
        If strCslDate <> "" Then
            objOraParam.Add "FREEDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
        End If
    End If

    '指定予約番号の受診オプション管理情報を取得する
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
'    strStmt = "SELECT FREECD,     FREENAME,   FREEDATE,   FREEFIELD1, " & vbLf & _
              "       FREEFIELD2, FREEFIELD3, FREEFIELD4, FREEFIELD5, FREECLASSCD  " & vbLf & _
              "  FROM FREE                                            "
    strStmt = "SELECT FREECD,     FREENAME,   FREEDATE,   FREEFIELD1, " & vbLf & _
              "       FREEFIELD2, FREEFIELD3, FREEFIELD4, FREEFIELD5, FREECLASSCD, " & vbLf & _
              "       FREEFIELD6, FREEFIELD7                                       " & vbLf & _
              "  FROM FREE                                            "
'### 2003.02.15 Added End
              
    '検索モードごとの条件節設定
    Select Case lngMode
        
        Case 0  '一意検索の場合
            
            strStmt = strStmt & vbLf & _
              " WHERE FREECD = :FREECD "
              
        Case 1  '前方一致検索の場合
        
            strStmt = strStmt & vbLf & _
              " WHERE FREECD LIKE :FREECD " & vbLf & _
              "   AND FREEDATE >= :FREEDATE " & vbLf & _
              " ORDER BY FREECD           "
    
        Case 2  '全件取得の場合
            
            strStmt = strStmt & vbLf & _
              " ORDER BY FREECD"
        
'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため追加 Start ##
        
        Case 3  '前方一致検索で順番設定の場合
        
            strStmt = strStmt & vbLf & _
              " WHERE FREECD LIKE :FREECD " & vbLf & _
              "   AND FREEDATE >= :FREEDATE " & vbLf & _
              " ORDER BY TO_NUMBER(FREEFIELD3)           "

'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため追加 End   ##
    
    End Select
    
    'レコードロック指定
    If blnLock Then
        strStmt = strStmt & vbLf & _
          "   FOR UPDATE"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objFreeCd = objFields("FREECD")
        Set objFreeName = objFields("FREENAME")
        Set objFreeDate = objFields("FREEDATE")
        Set objFreeField1 = objFields("FREEFIELD1")
        Set objFreeField2 = objFields("FREEFIELD2")
        Set objFreeField3 = objFields("FREEFIELD3")
        Set objFreeField4 = objFields("FREEFIELD4")
        Set objFreeField5 = objFields("FREEFIELD5")
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        Set objFreeField6 = objFields("FREEFIELD6")
        Set objFreeField7 = objFields("FREEFIELD7")
'### 2003.02.15 Added End
        Set objFreeClassCd = objFields("FREECLASSCD")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrFreeCd(lngCount)
            ReDim Preserve vntArrFreeName(lngCount)
            ReDim Preserve vntArrFreeDate(lngCount)
            ReDim Preserve vntArrFreeField1(lngCount)
            ReDim Preserve vntArrFreeField2(lngCount)
            ReDim Preserve vntArrFreeField3(lngCount)
            ReDim Preserve vntArrFreeField4(lngCount)
            ReDim Preserve vntArrFreeField5(lngCount)
            ReDim Preserve vntArrFreeClassCd(lngCount)
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
            ReDim Preserve vntArrFreeField6(lngCount)
            ReDim Preserve vntArrFreeField7(lngCount)
'### 2003.02.15 Added End
            vntArrFreeCd(lngCount) = objFreeCd.Value
            vntArrFreeName(lngCount) = objFreeName.Value
            vntArrFreeDate(lngCount) = objFreeDate.Value & ""
            vntArrFreeField1(lngCount) = objFreeField1.Value & ""
            vntArrFreeField2(lngCount) = objFreeField2.Value & ""
            vntArrFreeField3(lngCount) = objFreeField3.Value & ""
            vntArrFreeField4(lngCount) = objFreeField4.Value & ""
            vntArrFreeField5(lngCount) = objFreeField5.Value & ""
            vntArrFreeClassCd(lngCount) = objFreeClassCd.Value & ""
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
            vntArrFreeField6(lngCount) = objFreeField6.Value & ""
            vntArrFreeField7(lngCount) = objFreeField7.Value & ""
'### 2003.02.15 Added ENd
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '検索モードごとの戻り値設定
        Select Case lngMode
            
            Case 0  '一意検索の場合
                
                vntRetFreeCd = vntArrFreeCd(0)
                vntRetFreeName = vntArrFreeName(0)
                vntRetFreeDate = vntArrFreeDate(0)
                vntRetFreeField1 = vntArrFreeField1(0)
                vntRetFreeField2 = vntArrFreeField2(0)
                vntRetFreeField3 = vntArrFreeField3(0)
                vntRetFreeField4 = vntArrFreeField4(0)
                vntRetFreeField5 = vntArrFreeField5(0)
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
                vntRetFreeField6 = vntArrFreeField6(0)
                vntRetFreeField7 = vntArrFreeField7(0)
'### 2003.02.15 Added End
                vntRetFreeClassCd = vntArrFreeClassCd(0)
                  
'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため修正 Start ##
            'Case 1, 2 '前方一致検索、全件の場合
            Case 1, 2, 3, 4 '前方一致検索、全件の場合
'## 2006/10/25 張 汎用マスターに順番を設定し、その順番通り表示するため修正 End   ##
            
                vntRetFreeCd = vntArrFreeCd
                vntRetFreeName = vntArrFreeName
                vntRetFreeDate = vntArrFreeDate
                vntRetFreeField1 = vntArrFreeField1
                vntRetFreeField2 = vntArrFreeField2
                vntRetFreeField3 = vntArrFreeField3
                vntRetFreeField4 = vntArrFreeField4
                vntRetFreeField5 = vntArrFreeField5
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
                vntRetFreeField6 = vntArrFreeField6
                vntRetFreeField7 = vntArrFreeField7
'### 2003.02.15 Added End
                vntRetFreeClassCd = vntArrFreeClassCd
        
        End Select
        
        If Not IsMissing(vntFreeCd) Then vntFreeCd = vntRetFreeCd
        If Not IsMissing(vntFreeName) Then vntFreeName = vntRetFreeName
        If Not IsMissing(vntFreeDate) Then vntFreeDate = vntRetFreeDate
        If Not IsMissing(vntFreeField1) Then vntFreeField1 = vntRetFreeField1
        If Not IsMissing(vntFreeField2) Then vntFreeField2 = vntRetFreeField2
        If Not IsMissing(vntFreeField3) Then vntFreeField3 = vntRetFreeField3
        If Not IsMissing(vntFreeField4) Then vntFreeField4 = vntRetFreeField4
        If Not IsMissing(vntFreeField5) Then vntFreeField5 = vntRetFreeField5
        If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = vntRetFreeClassCd
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        If Not IsMissing(vntFreeField6) Then vntFreeField6 = vntRetFreeField6
        If Not IsMissing(vntFreeField7) Then vntFreeField7 = vntRetFreeField7
'### 2003.02.15 Added End
    
    End If
    
    'バインド変数の削除
    If lngMode <> 2 Then
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    SelectFreeDate = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.SelectFreeDate"
    
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

'=====================================================
' 2005.3.23  ADD by 李
' 機能　　 : FreeClassCdで汎用テーブル読み込み
'======================================================
' 引数　　 : (In)     lngMode           検索モード(0:、1:、2:)
' 　　　　   (In)     strFreeClassCd    汎用コード(検索キー値)
' 　　　　   (Out)    vntFreeCd         汎用コード
' 　　　　   (Out)    vntFreeName       汎用名
' 　　　　   (Out)    vntFreeDate       汎用日付
' 　　　　   (Out)    vntFreeField1     汎用フィールド1
' 　　　　   (Out)    vntFreeField2     汎用フィールド2
' 　　　　   (Out)    vntFreeField3     汎用フィールド3
' 　　　　   (Out)    vntFreeField4     汎用フィールド4
' 　　　　   (Out)    vntFreeField5     汎用フィールド5
' 　　　　   (In)     blnLock           レコードロック実施有無
' 　　　　   (Out)    vntFreeClassCd    汎用分類コード
' 　　　　   (Out)    vntFreeField6     汎用フィールド6
' 　　　　   (Out)    vntFreeField7     汎用フィールド7
'
' 戻り値　 : レコード件数
'
' 備考　　 : 検索モードが前方一致検索の場合、Out引数は配列形式で返す
'
Public Function SelectFreeByClassCd( _
    ByVal lngMode As Integer, _
    ByVal strFreeClassCd As String, _
    Optional ByRef vntFreeCd As Variant, _
    Optional ByRef vntFreeName As Variant, _
    Optional ByRef vntFreeDate As Variant, _
    Optional ByRef vntFreeField1 As Variant, _
    Optional ByRef vntFreeField2 As Variant, _
    Optional ByRef vntFreeField3 As Variant, _
    Optional ByRef vntFreeField4 As Variant, _
    Optional ByRef vntFreeField5 As Variant, _
    Optional ByVal blnLock As Boolean = False, _
    Optional ByRef vntFreeClassCd As Variant, _
    Optional ByRef vntFreeField6 As Variant, _
    Optional ByRef vntFreeField7 As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objFreeCd           As OraField         '汎用コード
    Dim objFreeName         As OraField         '汎用名
    Dim objFreeDate         As OraField         '汎用日付
    Dim objFreeField1       As OraField         '汎用フィールド1
    Dim objFreeField2       As OraField         '汎用フィールド2
    Dim objFreeField3       As OraField         '汎用フィールド3
    Dim objFreeField4       As OraField         '汎用フィールド4
    Dim objFreeField5       As OraField         '汎用フィールド5
    Dim objFreeClassCd      As OraField         '汎用分類コード
    
    Dim vntArrFreeCd()      As Variant          '汎用コードの配列
    Dim vntArrFreeName()    As Variant          '汎用名の配列
    Dim vntArrFreeDate()    As Variant          '汎用日付の配列
    Dim vntArrFreeField1()  As Variant          '汎用フィールド1の配列
    Dim vntArrFreeField2()  As Variant          '汎用フィールド2の配列
    Dim vntArrFreeField3()  As Variant          '汎用フィールド3の配列
    Dim vntArrFreeField4()  As Variant          '汎用フィールド4の配列
    Dim vntArrFreeField5()  As Variant          '汎用フィールド5の配列
    Dim vntArrFreeClassCd() As Variant          '汎用分類コードの配列
    
    Dim vntRetFreeCd        As Variant          '汎用コード
    Dim vntRetFreeName      As Variant          '汎用名
    Dim vntRetFreeDate      As Variant          '汎用日付
    Dim vntRetFreeField1    As Variant          '汎用フィールド1
    Dim vntRetFreeField2    As Variant          '汎用フィールド2
    Dim vntRetFreeField3    As Variant          '汎用フィールド3
    Dim vntRetFreeField4    As Variant          '汎用フィールド4
    Dim vntRetFreeField5    As Variant          '汎用フィールド5
    Dim vntRetFreeClassCd   As Variant          '汎用分類コード
    Dim strKey              As String           '検索キー
    Dim lngCount            As Long             'レコード数

'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    Dim objFreeField6       As OraField         '汎用フィールド6
    Dim objFreeField7       As OraField         '汎用フィールド7

    Dim vntArrFreeField6()  As Variant          '汎用フィールド6の配列
    Dim vntArrFreeField7()  As Variant          '汎用フィールド7の配列

    Dim vntRetFreeField6    As Variant          '汎用フィールド6
    Dim vntRetFreeField7    As Variant          '汎用フィールド7
'### 2003.02.15 Added End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntFreeCd) Then vntFreeCd = Empty
    If Not IsMissing(vntFreeName) Then vntFreeName = Empty
    If Not IsMissing(vntFreeDate) Then vntFreeDate = Empty
    If Not IsMissing(vntFreeField1) Then vntFreeField1 = Empty
    If Not IsMissing(vntFreeField2) Then vntFreeField2 = Empty
    If Not IsMissing(vntFreeField3) Then vntFreeField3 = Empty
    If Not IsMissing(vntFreeField4) Then vntFreeField4 = Empty
    If Not IsMissing(vntFreeField5) Then vntFreeField5 = Empty
    If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = Empty
    
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField6) Then vntFreeField6 = Empty
    If Not IsMissing(vntFreeField7) Then vntFreeField7 = Empty
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    
    lngCount = 0

    '検索モードごとの検索キー値設定
    strKey = Trim(strFreeClassCd)

    Set objOraParam = mobjOraDb.Parameters
    
    'キー値の設定
    objOraParam.Add "FREEKEY", strKey, ORAPARM_INPUT, ORATYPE_VARCHAR2


    '指定予約番号の受診オプション管理情報を取得する
    strStmt = "SELECT FREECD,     FREENAME,   FREEDATE,   FREEFIELD1, " & vbLf & _
              "       FREEFIELD2, FREEFIELD3, FREEFIELD4, FREEFIELD5, FREECLASSCD, " & vbLf & _
              "       FREEFIELD6, FREEFIELD7                                       " & vbLf & _
              "  FROM FREE                                            "

    '検索モードごとの条件節設定
    Select Case lngMode
        Case 0  'FreeClassCdで検索の場合
            strStmt = strStmt & vbLf & _
              " WHERE FREECLASSCD = :FREEKEY      " & vbLf & _
              " ORDER BY FREECD                   "
              
        Case 1  'セキュリティーグループで検索の場合
        
            strStmt = strStmt & vbLf & _
              " WHERE FREECLASSCD = 'USR'         " & vbLf & _
              "     AND FREEFIELD2  = :FREEKEY    " & vbLf & _
              " ORDER BY FREECD                   "
    
        Case 2  'メニューグループ場合画面表示手順で...
            strStmt = strStmt & vbLf & _
              " WHERE FREECLASSCD = :FREEKEY    " & vbLf & _
              " ORDER BY TO_NUMBER(FREEFIELD3)             "
    
    
    End Select



    'レコードロック指定
    If blnLock Then
        strStmt = strStmt & vbLf & _
          "   FOR UPDATE"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objFreeCd = objFields("FREECD")
        Set objFreeName = objFields("FREENAME")
        Set objFreeDate = objFields("FREEDATE")
        Set objFreeField1 = objFields("FREEFIELD1")
        Set objFreeField2 = objFields("FREEFIELD2")
        Set objFreeField3 = objFields("FREEFIELD3")
        Set objFreeField4 = objFields("FREEFIELD4")
        Set objFreeField5 = objFields("FREEFIELD5")
        Set objFreeField6 = objFields("FREEFIELD6")
        Set objFreeField7 = objFields("FREEFIELD7")
        Set objFreeClassCd = objFields("FREECLASSCD")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrFreeCd(lngCount)
            ReDim Preserve vntArrFreeName(lngCount)
            ReDim Preserve vntArrFreeDate(lngCount)
            ReDim Preserve vntArrFreeField1(lngCount)
            ReDim Preserve vntArrFreeField2(lngCount)
            ReDim Preserve vntArrFreeField3(lngCount)
            ReDim Preserve vntArrFreeField4(lngCount)
            ReDim Preserve vntArrFreeField5(lngCount)
            ReDim Preserve vntArrFreeClassCd(lngCount)
            ReDim Preserve vntArrFreeField6(lngCount)
            ReDim Preserve vntArrFreeField7(lngCount)
            
            vntArrFreeCd(lngCount) = objFreeCd.Value
            vntArrFreeName(lngCount) = objFreeName.Value
            vntArrFreeDate(lngCount) = objFreeDate.Value & ""
            vntArrFreeField1(lngCount) = objFreeField1.Value & ""
            vntArrFreeField2(lngCount) = objFreeField2.Value & ""
            vntArrFreeField3(lngCount) = objFreeField3.Value & ""
            vntArrFreeField4(lngCount) = objFreeField4.Value & ""
            vntArrFreeField5(lngCount) = objFreeField5.Value & ""
            vntArrFreeClassCd(lngCount) = objFreeClassCd.Value & ""
            vntArrFreeField6(lngCount) = objFreeField6.Value & ""
            vntArrFreeField7(lngCount) = objFreeField7.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '検索モードごとの戻り値設定
        vntRetFreeCd = vntArrFreeCd
        vntRetFreeName = vntArrFreeName
        vntRetFreeDate = vntArrFreeDate
        vntRetFreeField1 = vntArrFreeField1
        vntRetFreeField2 = vntArrFreeField2
        vntRetFreeField3 = vntArrFreeField3
        vntRetFreeField4 = vntArrFreeField4
        vntRetFreeField5 = vntArrFreeField5
        vntRetFreeField6 = vntArrFreeField6
        vntRetFreeField7 = vntArrFreeField7
        vntRetFreeClassCd = vntArrFreeClassCd
        
        If Not IsMissing(vntFreeCd) Then vntFreeCd = vntRetFreeCd
        If Not IsMissing(vntFreeName) Then vntFreeName = vntRetFreeName
        If Not IsMissing(vntFreeDate) Then vntFreeDate = vntRetFreeDate
        If Not IsMissing(vntFreeField1) Then vntFreeField1 = vntRetFreeField1
        If Not IsMissing(vntFreeField2) Then vntFreeField2 = vntRetFreeField2
        If Not IsMissing(vntFreeField3) Then vntFreeField3 = vntRetFreeField3
        If Not IsMissing(vntFreeField4) Then vntFreeField4 = vntRetFreeField4
        If Not IsMissing(vntFreeField5) Then vntFreeField5 = vntRetFreeField5
        If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = vntRetFreeClassCd
        If Not IsMissing(vntFreeField6) Then vntFreeField6 = vntRetFreeField6
        If Not IsMissing(vntFreeField7) Then vntFreeField7 = vntRetFreeField7
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectFreeByClassCd = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.SelectFreeByClassCd"
    
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
' 機能　　 : 文書番号またはオーダ番号の読み込み
'
' 引数　　 : (In)     strFreeCd  汎用コード
' 　　　　   (Out)    vntSeqNo   文書番号またはオーダ番号
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function SelectFreeSeqNo(ByVal strFreeCd As String, ByRef vntSeqNo As Variant) As Boolean

    Dim vntRetSeqNo As Variant  '文書番号またはオーダ番号
    
    Dim Ret         As Long     '関数戻り値
    
    '初期処理
    vntSeqNo = Empty
    
    '文書番号、オーダ番号以外の場合は何もしない
    Select Case Trim(strFreeCd)
        Case "DOCNO", "ORDERNO"
        Case Else
            Exit Function
    End Select
    
    '文書番号またはオーダ番号の初期設定
    vntRetSeqNo = 0
    
    '汎用テーブルレコードの挿入処理
    Ret = InsertFree(strFreeCd, "KAR", "", , vntRetSeqNo)
    If Ret = INSERT_ERROR Then
        Exit Function
    End If
        
    'すでにレコードが存在する場合は既存レコードを読み込む
    If Ret = INSERT_DUPLICATE Then
        SelectFree 0, strFreeCd, , , , vntRetSeqNo, , , , , True
    End If
        
    '戻り値の設定
    vntSeqNo = vntRetSeqNo
        
    SelectFreeSeqNo = True
        
End Function

'
' 機能　　 : 受診票出力パターンリストの取得
'
' 引数　　 : (Out)    vntFreeCd         汎用コード
' 　　　　 : (Out)    vntFreeName       汎用名
'
' 戻り値　 : 取得したレコード件数
'
' 備考　　 : 汎用コードがJ**00000となるもののリストを作成する
'
Public Function SelectJushinhyoPtnList(ByRef vntFreeCd As Variant, ByRef vntFreeName As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objFreeCd           As OraField         '汎用コード
    Dim objFreeName         As OraField         '汎用名

    Dim vntArrFreeCd()      As Variant          '汎用コード配列
    Dim vntArrFreeName()    As Variant          '汎用名配列
    Dim lngCount            As Long             'レコード件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntFreeCd = Empty
    vntFreeName = Empty

    '汎用テーブルの受診票印刷パターンのうち受診者対象情報を取得
'    strStmt = "SELECT FREECD, FREENAME                          " & vbLf & _
'              "  FROM FREE                                      " & vbLf & _
'              " WHERE FREECD IN ( SELECT FREECLASSCD || '00000' " & vbLf & _
'              "                     FROM FREECLASS              " & vbLf & _
'              "                    WHERE FREECLASSCD LIKE 'J%'  " & vbLf & _
'              "                 )                               " & vbLf & _
'              " ORDER BY FREECD                                 "
    strStmt = "SELECT FREECD, FREENAME       " & vbLf & _
              "  FROM FREE                   " & vbLf & _
              " WHERE FREECD LIKE 'J__00000' " & vbLf & _
              " ORDER BY FREECD              "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objFreeCd = objFields("FREECD")
        Set objFreeName = objFields("FREENAME")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrFreeCd(lngCount)
            ReDim Preserve vntArrFreeName(lngCount)
            vntArrFreeCd(lngCount) = objFreeCd.Value & ""
            vntArrFreeName(lngCount) = objFreeName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
        
    '戻り値の設定
    vntFreeCd = vntArrFreeCd
    vntFreeName = vntArrFreeName
    SelectJushinhyoPtnList = lngCount

    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.SelectJushinhyoPtnList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 指定の受診票印刷パターンコードからパターン情報を取得する
'
' 引数　　 : (In)     strPtnCd          パターンコード
' 　　　　 : (Out)    vntPtnName        パターン名
' 　　　　 : (Out)    vntFedFile        CoReports定義ファイル名
' 　　　　 : (Out)    vntRowNum         (配列)パターン内連番
' 　　　　 : (Out)    vntItemName       (配列)検査項目枠名
' 　　　　 : (Out)    vntRoom           (配列)検査室名
' 　　　　 : (Out)    vntFloor          (配列)フロア
' 　　　　 : (Out)    vntNote           (配列)備考
' 　　　　 : (Out)    vntItemCd         (配列)管理する検査項目コード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectJushinhyoPtn(ByVal strPtnCd As String, _
                                   ByRef vntPtnName As Variant, _
                                   ByRef vntFedFile As Variant, _
                                   ByRef vntRowNum As Variant, _
                                   ByRef vntItemName As Variant, _
                                   ByRef vntRoom As Variant, _
                                   ByRef vntFloor As Variant, _
                                   ByRef vntNote As Variant, _
                                   ByRef vntItemCd As Variant _
                                  ) As Boolean
    
    Const PTN_HEADER_INF    As String = "00000" '受診者対象情報
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objFreeCd           As OraField         '汎用コード
    Dim objFreeName         As OraField         '汎用名
    Dim objFreeField1       As OraField         '汎用フィールド1
    Dim objFreeField2       As OraField         '汎用フィールド2
    Dim objFreeField3       As OraField         '汎用フィールド3
    Dim objFreeField4       As OraField         '汎用フィールド4
    Dim objFreeField5       As OraField         '汎用フィールド5
    
    Dim vntArrFreeCd()      As Variant          '汎用コードの配列
    Dim vntArrFreeName()    As Variant          '汎用名の配列
    Dim vntArrFreeField1()  As Variant          '汎用フィールド1の配列
    Dim vntArrFreeField2()  As Variant          '汎用フィールド2の配列
    Dim vntArrFreeField3()  As Variant          '汎用フィールド3の配列
    Dim vntArrFreeField4()  As Variant          '汎用フィールド4の配列
    Dim vntArrFreeField5()  As Variant          '汎用フィールド5の配列
    
    Dim lngCount            As Long             'レコード件数
    Dim i, j                As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    '検索条件が設定されていない、または、パターンコードが"J**"以外の場合は処理を終了する
    If Trim(strPtnCd) = "" Or Left(Trim(strPtnCd), 1) <> "J" Then
        Exit Function
    End If
    
    '検索条件文字列数が3文字より大きい時はエラー
    If Len(Trim(strPtnCd)) > 3 Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '初期処理
    vntPtnName = Empty
    vntFedFile = Empty
    vntRowNum = Empty
    vntItemName = Empty
    vntRoom = Empty
    vntFloor = Empty
    vntNote = Empty
    vntItemCd = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FREECLASSCD", Trim(strPtnCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす汎用テーブルのレコードを取得
    strStmt = "SELECT FREECD,                       " & vbLf & _
              "       FREENAME,                     " & vbLf & _
              "       FREEFIELD1,                   " & vbLf & _
              "       FREEFIELD2,                   " & vbLf & _
              "       FREEFIELD3,                   " & vbLf & _
              "       FREEFIELD4,                   " & vbLf & _
              "       FREEFIELD5                    " & vbLf & _
              "  FROM FREE                          " & vbLf & _
              " WHERE FREECD LIKE :FREECLASSCD||'%' " & vbLf & _
              " ORDER BY FREECD                     "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objFreeCd = objFields("FREECD")
        Set objFreeName = objFields("FREENAME")
        Set objFreeField1 = objFields("FREEFIELD1")
        Set objFreeField2 = objFields("FREEFIELD2")
        Set objFreeField3 = objFields("FREEFIELD3")
        Set objFreeField4 = objFields("FREEFIELD4")
        Set objFreeField5 = objFields("FREEFIELD5")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrFreeCd(lngCount)
            ReDim Preserve vntArrFreeName(lngCount)
            ReDim Preserve vntArrFreeField1(lngCount)
            ReDim Preserve vntArrFreeField2(lngCount)
            ReDim Preserve vntArrFreeField3(lngCount)
            ReDim Preserve vntArrFreeField4(lngCount)
            ReDim Preserve vntArrFreeField5(lngCount)
            vntArrFreeCd(lngCount) = objFreeCd.Value & ""
            vntArrFreeName(lngCount) = objFreeName.Value & ""
            vntArrFreeField1(lngCount) = objFreeField1.Value & ""
            vntArrFreeField2(lngCount) = objFreeField2.Value & ""
            vntArrFreeField3(lngCount) = objFreeField3.Value & ""
            vntArrFreeField4(lngCount) = objFreeField4.Value & ""
            vntArrFreeField5(lngCount) = objFreeField5.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        j = 0
        For i = 0 To lngCount - 1
            If Mid(vntArrFreeCd(i), 4, 5) = PTN_HEADER_INF Then             '受診者対象情報ならパターン名と帳票定義ファイル名をセット
                vntPtnName = vntArrFreeName(i)
                vntFedFile = vntArrFreeField5(i)
            Else                                                            '受診検査項目情報を配列に格納
                If j = 0 Then
                    vntRowNum = Array(CLng(Mid(vntArrFreeCd(i), 4, 5)))
                    vntItemName = Array(Trim(vntArrFreeField1(i)))
                    vntRoom = Array(Trim(vntArrFreeField2(i)))
                    vntFloor = Array(Trim(vntArrFreeField3(i)))
                    vntNote = Array(Trim(vntArrFreeField4(i)))
                    vntItemCd = Array(Trim(vntArrFreeField5(i)))
                    j = j + 1
                Else
                    ReDim Preserve vntRowNum(j)
                    ReDim Preserve vntItemName(j)
                    ReDim Preserve vntRoom(j)
                    ReDim Preserve vntFloor(j)
                    ReDim Preserve vntNote(j)
                    ReDim Preserve vntItemCd(j)
                    vntRowNum(j) = CLng(Mid(vntArrFreeCd(i), 4, 5))
                    vntItemName(j) = Trim(vntArrFreeField1(i))
                    vntRoom(j) = Trim(vntArrFreeField2(i))
                    vntFloor(j) = Trim(vntArrFreeField3(i))
                    vntNote(j) = Trim(vntArrFreeField4(i))
                    vntItemCd(j) = Trim(vntArrFreeField5(i))
                    j = j + 1
                End If
            End If
        Next
        
    End If
    
    '帳票定義ファイル名が空でなければ正常終了
    If vntFedFile <> "" Then
        SelectJushinhyoPtn = True
    Else
        SelectJushinhyoPtn = False
    End If
    
    Set objOraDyna = Nothing
        
    'バインド変数の削除
    objOraParam.Remove "FREECLASSCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.SelectJushinhyoPtn"
    
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
' 機能　　 : 汎用テーブルレコード更新
'
' 引数　　 : (In)     strFreeCd       汎用コード
' 　　　　   (In)     vntFreeClassCd  汎用分類コード
' 　　　　   (In)     vntFreeName     汎用名
' 　　　　   (In)     vntFreeDate     汎用日付
' 　　　　   (In)     vntFreeField1   汎用フィールド1
' 　　　　   (In)     vntFreeField2   汎用フィールド2
' 　　　　   (In)     vntFreeField3   汎用フィールド3
' 　　　　   (In)     vntFreeField4   汎用フィールド4
' 　　　　   (In)     vntFreeField5   汎用フィールド5
' 　　　　   (In)     vntFreeField6   汎用フィールド6
' 　　　　   (In)     vntFreeField7   汎用フィールド7
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function UpdateFree( _
    ByVal strFreeCd As String, _
    Optional ByVal vntFreeClassCd As Variant, _
    Optional ByVal vntFreeName As Variant, _
    Optional ByVal vntFreeDate As Variant, _
    Optional ByVal vntFreeField1 As Variant, _
    Optional ByVal vntFreeField2 As Variant, _
    Optional ByVal vntFreeField3 As Variant, _
    Optional ByVal vntFreeField4 As Variant, _
    Optional ByVal vntFreeField5 As Variant, _
    Optional ByVal vntFreeField6 As Variant, _
    Optional ByVal vntFreeField7 As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim strUpdFreeName  As String           '汎用名
    Dim blnSet          As Boolean          'SET句を編集したか
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'デフォルト値の設定
    Select Case Trim(strFreeCd)
        Case "DOCNO"
            strUpdFreeName = "文書番号発番管理"
        Case "ORDERNO"
            strUpdFreeName = "オーダ番号発番管理"
        Case Else
            If Not IsMissing(vntFreeName) Then
                strUpdFreeName = Trim(vntFreeName)
            End If
    End Select
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FREECD", Trim(strFreeCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    If Not IsMissing(vntFreeClassCd) Then
        objOraParam.Add "FREECLASSCD", Trim(vntFreeClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeName) Then
        objOraParam.Add "FREENAME", strUpdFreeName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If

    If Not IsMissing(vntFreeDate) Then
        '日付空白の場合は、NULLセット
        If Trim(vntFreeDate) = "" Then
            objOraParam.Add "FREEDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
        Else
            objOraParam.Add "FREEDATE", CDate(vntFreeDate), ORAPARM_INPUT, ORATYPE_DATE
        End If
    End If
    
    If Not IsMissing(vntFreeField1) Then
        objOraParam.Add "FREEFIELD1", Trim(vntFreeField1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField2) Then
        objOraParam.Add "FREEFIELD2", Trim(vntFreeField2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField3) Then
        objOraParam.Add "FREEFIELD3", Trim(vntFreeField3), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField4) Then
        objOraParam.Add "FREEFIELD4", Trim(vntFreeField4), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField5) Then
        objOraParam.Add "FREEFIELD5", Trim(vntFreeField5), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField6) Then
        objOraParam.Add "FREEFIELD6", Trim(vntFreeField6), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    If Not IsMissing(vntFreeField7) Then
        objOraParam.Add "FREEFIELD7", Trim(vntFreeField7), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
'### 2003.02.15 Added End
    
    '汎用テーブルレコードの更新
    strStmt = "UPDATE FREE "
              
    '汎用分類コード指定時の処理
    If Not IsMissing(vntFreeClassCd) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREECLASSCD = :FREECLASSCD"
        blnSet = True
    End If
              
    '汎用名指定時の処理
    If Not IsMissing(vntFreeName) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREENAME = :FREENAME"
        blnSet = True
    End If
              
    '汎用日付指定時の処理
    If Not IsMissing(vntFreeDate) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEDATE = :FREEDATE"
        blnSet = True
    End If

    '汎用フィールド指定時の処理
    If Not IsMissing(vntFreeField1) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEFIELD1 = :FREEFIELD1"
        blnSet = True
    End If

    If Not IsMissing(vntFreeField2) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEFIELD2 = :FREEFIELD2"
        blnSet = True
    End If

    If Not IsMissing(vntFreeField3) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEFIELD3 = :FREEFIELD3"
        blnSet = True
    End If

    If Not IsMissing(vntFreeField4) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEFIELD4 = :FREEFIELD4"
        blnSet = True
    End If

    If Not IsMissing(vntFreeField5) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEFIELD5 = :FREEFIELD5"
        blnSet = True
    End If

'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    
    If Not IsMissing(vntFreeField6) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEFIELD6 = :FREEFIELD6"
        blnSet = True
    End If

    If Not IsMissing(vntFreeField7) Then
        strStmt = strStmt & IIf(blnSet, ",", "SET") & " FREEFIELD7 = :FREEFIELD7"
        blnSet = True
    End If

'### 2003.02.15 Added End

    'SET句が編集されない場合SQL文が成り立たないのでエラー
    If Not blnSet Then
        Err.Raise 5
    End If
    
    'WHERE句の編集
    strStmt = strStmt & " WHERE FREECD = :FREECD"
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    UpdateFree = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.UpdateFree"
    
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
' 機能　　 : 汎用テーブルレコードを削除する
'
' 引数　　 : (In)    strFreeCd    汎用コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteFree(ByVal strFreeCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FREECD", Trim(strFreeCd), ORAPARM_INPUT, ORATYPE_NUMBER

    '汎用テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE FREE WHERE FREECD = :FREECD"
    
    'バインド変数の削除
    objOraParam.Remove "FREECD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteFree = True

    Exit Function
    
ErrorHandle:

    DeleteFree = False

    'イベントログ書き込み
    WriteErrorLog "Free.DeleteFree"
    
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
' 機能　　 : 汎用テーブル読み込み
'
' 引数　　 : (In)     strFreeCdKey   汎用コード(検索キー値)
' 　　　　   (In)     lngStartPos    開始位置
' 　　　　   (In)     lngGetCount    取得件数
' 　　　　   (Out)    vntFreeCd      汎用コード
' 　　　　   (Out)    vntFreeClassCd 汎用分類コード
' 　　　　   (Out)    vntFreeName    汎用名
' 　　　　   (Out)    vntFreeDate    汎用日付
' 　　　　   (Out)    vntFreeField1  汎用フィールド1
' 　　　　   (Out)    vntFreeField2  汎用フィールド2
' 　　　　   (Out)    vntFreeField3  汎用フィールド3
' 　　　　   (Out)    vntFreeField4  汎用フィールド4
' 　　　　   (Out)    vntFreeField5  汎用フィールド5
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function GdeSelectFree( _
    ByVal strFreeCdKey As String, _
    ByVal lngStartPos As Long, _
    ByVal lngGetCount As Long, _
    Optional ByRef vntFreeCd As Variant, _
    Optional ByRef vntFreeClassCd As Variant, _
    Optional ByRef vntFreeName As Variant, _
    Optional ByRef vntFreeDate As Variant, _
    Optional ByRef vntFreeField1 As Variant, _
    Optional ByRef vntFreeField2 As Variant, _
    Optional ByRef vntFreeField3 As Variant, _
    Optional ByRef vntFreeField4 As Variant, _
    Optional ByRef vntFreeField5 As Variant, _
    Optional ByRef vntFreeField6 As Variant, _
    Optional ByRef vntFreeField7 As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objFreeCd           As OraField         '汎用コード
    Dim objFreeClassCd      As OraField         '汎用分類コード
    Dim objFreeName         As OraField         '汎用名
    Dim objFreeDate         As OraField         '汎用日付
    Dim objFreeField1       As OraField         '汎用フィールド1
    Dim objFreeField2       As OraField         '汎用フィールド2
    Dim objFreeField3       As OraField         '汎用フィールド3
    Dim objFreeField4       As OraField         '汎用フィールド4
    Dim objFreeField5       As OraField         '汎用フィールド5
    
    Dim vntArrFreeCd()      As Variant          '汎用コードの配列
    Dim vntArrFreeClassCd() As Variant          '汎用分類コードの配列
    Dim vntArrFreeName()    As Variant          '汎用名の配列
    Dim vntArrFreeDate()    As Variant          '汎用日付の配列
    Dim vntArrFreeField1()  As Variant          '汎用フィールド1の配列
    Dim vntArrFreeField2()  As Variant          '汎用フィールド2の配列
    Dim vntArrFreeField3()  As Variant          '汎用フィールド3の配列
    Dim vntArrFreeField4()  As Variant          '汎用フィールド4の配列
    Dim vntArrFreeField5()  As Variant          '汎用フィールド5の配列
    
    Dim vntRetFreeCd        As Variant          '汎用コード
    Dim vntRetFreeClassCd   As Variant          '汎用分類コード
    Dim vntRetFreeName      As Variant          '汎用名
    Dim vntRetFreeDate      As Variant          '汎用日付
    Dim vntRetFreeField1    As Variant          '汎用フィールド1
    Dim vntRetFreeField2    As Variant          '汎用フィールド2
    Dim vntRetFreeField3    As Variant          '汎用フィールド3
    Dim vntRetFreeField4    As Variant          '汎用フィールド4
    Dim vntRetFreeField5    As Variant          '汎用フィールド5
    Dim strKey              As String           '検索キー
    Dim lngCount            As Long             'レコード数

'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    Dim objFreeField6       As OraField         '汎用フィールド6
    Dim objFreeField7       As OraField         '汎用フィールド7
    
    Dim vntArrFreeField6()  As Variant          '汎用フィールド6の配列
    Dim vntArrFreeField7()  As Variant          '汎用フィールド7の配列
    
    Dim vntRetFreeField6    As Variant          '汎用フィールド6
    Dim vntRetFreeField7    As Variant          '汎用フィールド7

'### 2003.02.15 Added End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntFreeCd) Then vntFreeCd = Empty
    If Not IsMissing(vntFreeName) Then vntFreeCd = Empty
    If Not IsMissing(vntFreeDate) Then vntFreeDate = Empty
    If Not IsMissing(vntFreeField1) Then vntFreeDate = Empty
    If Not IsMissing(vntFreeField2) Then vntFreeField2 = Empty
    If Not IsMissing(vntFreeField3) Then vntFreeField3 = Empty
    If Not IsMissing(vntFreeField4) Then vntFreeField4 = Empty
    If Not IsMissing(vntFreeField5) Then vntFreeField5 = Empty
    If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = Empty
    
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    If Not IsMissing(vntFreeField6) Then vntFreeField6 = Empty
    If Not IsMissing(vntFreeField7) Then vntFreeField7 = Empty
'### 2003.02.15 Added End
    
    lngCount = 0

    '開始位置から取得件数分のレコードを取得
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
'    strStmt = "SELECT FREECD,      " & vbLf & _
'              "       FREECLASSCD,   " & vbLf & _
'              "       FREENAME,   " & vbLf & _
'              "       FREEDATE,   " & vbLf & _
'              "       FREEFIELD1,   " & vbLf & _
'              "       FREEFIELD2,   " & vbLf & _
'              "       FREEFIELD3,   " & vbLf & _
'              "       FREEFIELD4,   " & vbLf & _
'              "       FREEFIELD5    "
'
'    '検索条件を満たす個人テーブルのレコードを取得
'    strStmt = strStmt & vbLf & _
'              "  FROM ( SELECT ROWNUM SEQ,         " & vbLf & _
'              "                FREECD,              " & vbLf & _
'              "                FREECLASSCD,              " & vbLf & _
'              "                FREENAME,              " & vbLf & _
'              "                FREEDATE,              " & vbLf & _
'              "                FREEFIELD1,              " & vbLf & _
'              "                FREEFIELD2,            " & vbLf & _
'              "                FREEFIELD3,            " & vbLf & _
'              "                FREEFIELD4,            " & vbLf & _
'              "                FREEFIELD5            " & vbLf & _
'              "           FROM FREE             " & vbLf & _
'              " WHERE FREECD LIKE '" & strFreeCdKey & "%'" & vbLf
    strStmt = "SELECT FREECD,      " & vbLf & _
              "       FREECLASSCD,   " & vbLf & _
              "       FREENAME,   " & vbLf & _
              "       FREEDATE,   " & vbLf & _
              "       FREEFIELD1,   " & vbLf & _
              "       FREEFIELD2,   " & vbLf & _
              "       FREEFIELD3,   " & vbLf & _
              "       FREEFIELD4,   " & vbLf & _
              "       FREEFIELD5,   " & vbLf & _
              "       FREEFIELD6,   " & vbLf & _
              "       FREEFIELD7    "
              
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT ROWNUM SEQ,         " & vbLf & _
              "                FREECD,              " & vbLf & _
              "                FREECLASSCD,              " & vbLf & _
              "                FREENAME,              " & vbLf & _
              "                FREEDATE,              " & vbLf & _
              "                FREEFIELD1,              " & vbLf & _
              "                FREEFIELD2,            " & vbLf & _
              "                FREEFIELD3,            " & vbLf & _
              "                FREEFIELD4,            " & vbLf & _
              "                FREEFIELD5,            " & vbLf & _
              "                FREEFIELD6,            " & vbLf & _
              "                FREEFIELD7            " & vbLf & _
              "           FROM FREE             " & vbLf & _
              " WHERE FREECD LIKE '" & strFreeCdKey & "%'" & vbLf
'### 2003.02.15 Added End

    '指導内容区分，定型面接文章コードの順にソート
    strStmt = strStmt & vbLf & _
              "          ORDER BY FREECD " & vbLf & _
              "       )                                 "
              
    '取得開始・終了位置を条件として追加
    strStmt = strStmt & vbLf & _
              " WHERE SEQ BETWEEN " & CStr(lngStartPos) & " AND " & CStr(lngStartPos + lngGetCount - 1)

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objFreeCd = objFields("FREECD")
        Set objFreeClassCd = objFields("FREECLASSCD")
        Set objFreeName = objFields("FREENAME")
        Set objFreeDate = objFields("FREEDATE")
        Set objFreeField1 = objFields("FREEFIELD1")
        Set objFreeField2 = objFields("FREEFIELD2")
        Set objFreeField3 = objFields("FREEFIELD3")
        Set objFreeField4 = objFields("FREEFIELD4")
        Set objFreeField5 = objFields("FREEFIELD5")
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        Set objFreeField6 = objFields("FREEFIELD6")
        Set objFreeField7 = objFields("FREEFIELD7")
'### 2003.02.15 Added End
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrFreeCd(lngCount)
            ReDim Preserve vntArrFreeClassCd(lngCount)
            ReDim Preserve vntArrFreeName(lngCount)
            ReDim Preserve vntArrFreeDate(lngCount)
            ReDim Preserve vntArrFreeField1(lngCount)
            ReDim Preserve vntArrFreeField2(lngCount)
            ReDim Preserve vntArrFreeField3(lngCount)
            ReDim Preserve vntArrFreeField4(lngCount)
            ReDim Preserve vntArrFreeField5(lngCount)
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
            ReDim Preserve vntArrFreeField6(lngCount)
            ReDim Preserve vntArrFreeField7(lngCount)
'### 2003.02.15 Added End
            vntArrFreeCd(lngCount) = objFreeCd.Value
            vntArrFreeClassCd(lngCount) = objFreeClassCd.Value & ""
            vntArrFreeName(lngCount) = objFreeName.Value
            vntArrFreeDate(lngCount) = objFreeDate.Value & ""
            vntArrFreeField1(lngCount) = objFreeField1.Value & ""
            vntArrFreeField2(lngCount) = objFreeField2.Value & ""
            vntArrFreeField3(lngCount) = objFreeField3.Value & ""
            vntArrFreeField4(lngCount) = objFreeField4.Value & ""
            vntArrFreeField5(lngCount) = objFreeField5.Value & ""
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
            vntArrFreeField6(lngCount) = objFreeField6.Value & ""
            vntArrFreeField7(lngCount) = objFreeField7.Value & ""
'### 2003.02.15 Added End
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        vntRetFreeCd = vntArrFreeCd
        vntRetFreeClassCd = vntArrFreeClassCd
        vntRetFreeName = vntArrFreeName
        vntRetFreeDate = vntArrFreeDate
        vntRetFreeField1 = vntArrFreeField1
        vntRetFreeField2 = vntArrFreeField2
        vntRetFreeField3 = vntArrFreeField3
        vntRetFreeField4 = vntArrFreeField4
        vntRetFreeField5 = vntArrFreeField5
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        vntRetFreeField6 = vntArrFreeField6
        vntRetFreeField7 = vntArrFreeField7
'### 2003.02.15 Added End
        
        If Not IsMissing(vntFreeCd) Then vntFreeCd = vntRetFreeCd
        If Not IsMissing(vntFreeName) Then vntFreeName = vntRetFreeName
        If Not IsMissing(vntFreeDate) Then vntFreeDate = vntRetFreeDate
        If Not IsMissing(vntFreeField1) Then vntFreeField1 = vntRetFreeField1
        If Not IsMissing(vntFreeField2) Then vntFreeField2 = vntRetFreeField2
        If Not IsMissing(vntFreeField3) Then vntFreeField3 = vntRetFreeField3
        If Not IsMissing(vntFreeField4) Then vntFreeField4 = vntRetFreeField4
        If Not IsMissing(vntFreeField5) Then vntFreeField5 = vntRetFreeField5
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        If Not IsMissing(vntFreeField6) Then vntFreeField6 = vntRetFreeField6
        If Not IsMissing(vntFreeField7) Then vntFreeField7 = vntRetFreeField7
'### 2003.02.15 Added End
        If Not IsMissing(vntFreeClassCd) Then vntFreeClassCd = vntRetFreeClassCd
    
    End If
    
    '戻り値の設定
    GdeSelectFree = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.GdeSelectFree"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function
'
' 機能　　 : 検索条件を満たす汎用テーブルの一覧を取得する
'
' 引数　　 : (In)     strFreeCdKey                検索キーの集合
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function GdeSelectFreeCount( _
    ByVal strFreeCdKey As String _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '開始位置から取得件数分のレコードを取得
    strStmt = "SELECT COUNT(*)         " & vbLf & _
              "  FROM FREE    " & vbLf & _
              " WHERE FREECD LIKE '" & strFreeCdKey & "%'" & vbLf & _
              " ORDER BY FREECD           " & vbLf
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    If Not objOraDyna.EOF Then
        GdeSelectFreeCount = IIf(IsNull(objOraDyna.Fields(0).Value), 0, objOraDyna.Fields(0).Value)
    End If

    'トランザクションをコミット
    mobjContext.SetComplete
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Free.GdeSelectFreeCount"
    
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
'    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, 0)
    
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
