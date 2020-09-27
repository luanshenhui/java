VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "AfterCare"
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
' 機能　　 : 個人ＩＤ、面接日をキーにアフターケア／アフターケア管理項目／アフターケア面接文書テーブルレコードを削除する
'
' 引数　　 : (In)     strPerID          個人ＩＤ
' 　　　　   (In)     strContactDate    面接日
'
' 戻り値　 : 1   正常終了
' 　　　　   0   参照整合性制約のために削除不可
' 　　　　   -1  異常終了
'
' 備考　　 :
'
Public Function DeleteAfterData( _
    ByVal strPerID As String, _
    ByVal strContactDate As String _
                               ) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'アフターケア管理項目テーブルレコード削除処理
    Ret = DeleteAfterCareM(strPerID, strContactDate)
    
    If (Ret <> 1) Then
        DeleteAfterData = Ret
        Exit Function
    End If
    
    'アフターケア面接文書テーブルレコード削除処理
    Ret = DeleteAfterCareC(strPerID, strContactDate)
    
    If (Ret <> 1) Then
        DeleteAfterData = Ret
        Exit Function
    End If
    
    'アフターケアテーブルレコード削除処理
    Ret = DeleteAfterCare(strPerID, strContactDate)
    
    If (Ret <> 1) Then
        DeleteAfterData = Ret
        Exit Function
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    DeleteAfterData = 1
    
    Exit Function
    
ErrorHandle:

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 2292 Then
        DeleteAfterData = 0
        Exit Function
    End If
    
    DeleteAfterData = -1
    
    'イベントログ書き込み
    WriteErrorLog "AfterCare.DeleteAfterData"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人ＩＤ、面接日をキーにアフターケアテーブルレコードを削除する
'
' 引数　　 : (In)     strPerID          個人ＩＤ
' 　　　　   (In)     strContactDate    面接日
'
' 戻り値　 : 1   正常終了
' 　　　　   0   参照整合性制約のために削除不可
' 　　　　   -1  異常終了
'
' 備考　　 :
'
Public Function DeleteAfterCare( _
    ByVal strPerID As String, _
    ByVal strContactDate As String _
                               ) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTDATE", strContactDate, ORAPARM_INPUT, ORATYPE_DATE

    'アフターケアテーブルレコードの削除
    strStmt = "DELETE AFTERCARE " & vbLf & _
              " WHERE PERID         = :PERID  " & vbLf & _
              "   AND CONTACTDATE   = :CONTACTDATE "
              
    mobjOraDb.ExecuteSQL strStmt

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteAfterCare = 1
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 2292 Then
        DeleteAfterCare = 0
        Exit Function
    End If
    
    DeleteAfterCare = -1
    
    'イベントログ書き込み
    WriteErrorLog "AfterCare.DeleteAfterCare"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人ＩＤ、面接日をキーにアフターケア管理項目テーブルレコードを削除する
'
' 引数　　 : (In)     strPerID          個人ＩＤ
' 　　　　   (In)     strContactDate    面接日
'
' 戻り値　 : 1   正常終了
' 　　　　   0   参照整合性制約のために削除不可
' 　　　　   -1  異常終了
'
' 備考　　 :
'
Public Function DeleteAfterCareM( _
    ByVal strPerID As String, _
    ByVal strContactDate As String _
                               ) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTDATE", strContactDate, ORAPARM_INPUT, ORATYPE_DATE

    'アフターケアテーブルレコードの削除
    strStmt = "DELETE AFTERCARE_M " & vbLf & _
              " WHERE PERID         = :PERID  " & vbLf & _
              "   AND CONTACTDATE   = :CONTACTDATE "
              
    mobjOraDb.ExecuteSQL strStmt

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteAfterCareM = 1
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 2292 Then
        DeleteAfterCareM = 0
        Exit Function
    End If
    
    DeleteAfterCareM = -1
    
    'イベントログ書き込み
    WriteErrorLog "AfterCare.DeleteAfterCareM"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人ＩＤ、面接日をキーにアフターケア管理項目テーブルレコードを削除する
'
' 引数　　 : (In)     strPerID          個人ＩＤ
' 　　　　   (In)     strContactDate    面接日
'
' 戻り値　 : 1   正常終了
' 　　　　   0   参照整合性制約のために削除不可
' 　　　　   -1  異常終了
'
' 備考　　 :
'
Public Function DeleteAfterCareC( _
    ByVal strPerID As String, _
    ByVal strContactDate As String _
                               ) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTDATE", strContactDate, ORAPARM_INPUT, ORATYPE_DATE

    'アフターケアテーブルレコードの削除
    strStmt = "DELETE AFTERCARE_C " & vbLf & _
              " WHERE PERID         = :PERID  " & vbLf & _
              "   AND CONTACTDATE   = :CONTACTDATE "
              
    mobjOraDb.ExecuteSQL strStmt

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteAfterCareC = 1
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 2292 Then
        DeleteAfterCareC = 0
        Exit Function
    End If
    
    DeleteAfterCareC = -1
    
    'イベントログ書き込み
    WriteErrorLog "AfterCare.DeleteAfterCareC"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : アフターケアテーブルにレコードを挿入する
'
' 引数　　 : (In)     strMode               登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)     strPerID              個人ＩＤ
' 　　　　   (In)     strContactDate        面接日
' 　　　　   (In)     strContactYear        面接年度
' 　　　　   (In)     strUserId             ユーザーＩＤ
' 　　　　   (In)     strRsvNo              予約番号
' 　　　　   (In)     strBloodPressure_H    血圧（高）
' 　　　　   (In)     strBloodPressure_L    血圧（低）
' 　　　　   (In)     strCircumStances      面接状況
' 　　　　   (In)     strCareComment        コメント
' 　　　　   (In)     strJudClassCd         判定分類コード
' 　　　　   (In)     strGuidanceDiv        指導内容区分
' 　　　　   (In)     strContactStc         面接文書
' 　　　　   (In)     strOtherJudClassName  その他判定分類名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistAfterCare( _
    ByVal strMode As String, _
    ByVal strPerID As String, _
    ByVal strContactDate As String, _
    ByVal strContactYear As String, _
    ByVal strUserId As String, _
    ByVal strRsvNo As String, _
    ByVal strBloodPressure_H As String, _
    ByVal strBloodPressure_L As String, _
    ByVal strCircumStances As String, _
    ByVal strCareComment As String, _
    ByVal strJudClassCd As Variant, _
    ByVal strGuidanceDiv As Variant, _
    ByVal strContactStc As Variant, _
    ByVal strOtherJudClassName As Variant _
) As Long

    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim Ret             As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTDATE", strContactDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CONTACTYEAR", strContactYear, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "USERID", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVNO", strRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BLOODPRESSURE_H", strBloodPressure_H, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BLOODPRESSURE_L", strBloodPressure_L, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.06.11 Mod 4Lines By T.Takagi@FSIT 全角変換
'    objOraParam.Add "CIRCUMSTANCES", strCircumStances, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "CARECOMMENT", strCareComment, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CIRCUMSTANCES", StrConv(Trim(strCircumStances), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CARECOMMENT", StrConv(Trim(strCareComment), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.06.11 Mod End

    Do
        
        '依頼項目テーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = "UPDATE AFTERCARE SET CONTACTYEAR     = :CONTACTYEAR,    " & vbLf & _
                      "                     USERID          = :USERID,         " & vbLf & _
                      "                     RSVNO           = :RSVNO,          " & vbLf & _
                      "                     BLOODPRESSURE_H = :BLOODPRESSURE_H," & vbLf & _
                      "                     BLOODPRESSURE_L = :BLOODPRESSURE_L," & vbLf & _
                      "                     CIRCUMSTANCES   = :CIRCUMSTANCES," & vbLf & _
                      "                     CARECOMMENT     = :CARECOMMENT" & vbLf & _
                      " WHERE PERID       = :PERID          " & vbLf & _
                      "   AND CONTACTDATE = :CONTACTDATE    "
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret < 0 Then
                Ret = INSERT_DUPLICATE
                Exit Do
            End If
            
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        If (strMode = "INS" Or (strMode = "UPD" And Ret = 0)) Then

            '検索条件を満たす依頼項目テーブルのレコードを取得
            strStmt = "SELECT PERID FROM AFTERCARE WHERE PERID = :PERID  AND CONTACTDATE = :CONTACTDATE "
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
                
            If Not objOraDyna.EOF Then
                Ret = INSERT_DUPLICATE
                Exit Do
            End If
    
            '更新モードでない場合、または更新レコードがない場合は挿入を行う
            'アフターケアテーブルレコードの挿入
            strStmt = "INSERT INTO AFTERCARE (        " & vbLf & _
                      "            PERID,             " & vbLf & _
                      "            CONTACTDATE,       " & vbLf & _
                      "            CONTACTYEAR,       " & vbLf & _
                      "            USERID,            " & vbLf & _
                      "            RSVNO,             " & vbLf & _
                      "            BLOODPRESSURE_H,   " & vbLf & _
                      "            BLOODPRESSURE_L,   " & vbLf & _
                      "            CIRCUMSTANCES,     " & vbLf & _
                      "            CARECOMMENT        " & vbLf & _
                      "       ) VALUES (              " & vbLf & _
                      "            :PERID,            " & vbLf & _
                      "            :CONTACTDATE,      " & vbLf & _
                      "            :CONTACTYEAR,      " & vbLf & _
                      "            :USERID,           " & vbLf & _
                      "            :RSVNO,            " & vbLf & _
                      "            :BLOODPRESSURE_H,  " & vbLf & _
                      "            :BLOODPRESSURE_L,  " & vbLf & _
                      "            :CIRCUMSTANCES,    " & vbLf & _
                      "            :CARECOMMENT       " & vbLf & _
                      "       )                       "
                
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

            Ret = INSERT_NORMAL

        End If

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
    
'        '************************************************************************
'        '  UPDATEの場合は一度管理項目テーブルのデータを削除する。
'        '************************************************************************
'        If (strMode = "UPD") Then
'            '************************************************************************
'            '  アフターケア管理項目テーブル削除処理
'            '************************************************************************
'            strStmt = "DELETE AFTERCARE_M WHERE PERID = :PERID  AND CONTACTDATE = :CONTACTDATE "
'            Ret = mobjOraDb.ExecuteSQL(strStmt)
'
'            If Ret < 0 Then
'                Ret = INSERT_DUPLICATE
'                Exit Do
'            End If
'
'            '************************************************************************
'            '  アフターケア面接文書テーブル削除処理
'            '************************************************************************
'            strStmt = "DELETE AFTERCARE_C WHERE PERID = :PERID  AND CONTACTDATE = :CONTACTDATE "
'            Ret = mobjOraDb.ExecuteSQL(strStmt)
'
'            If Ret < 0 Then
'                Ret = INSERT_DUPLICATE
'                Exit Do
'            End If
'        End If
'
        'アフターケア管理項目／面接文書テーブル更新用に一度バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    
        '************************************************************************
        '  アフターケア管理項目テーブル追加処理
        '************************************************************************
        
        'アフターケア管理項目テーブルの登録
        Ret = RegistAfterCare_M(strMode, _
                                strPerID, _
                                strContactDate, _
                                strJudClassCd, _
                                strOtherJudClassName _
                                )

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
        
        '************************************************************************
        '  アフターケア管理項目テーブル追加処理
        '************************************************************************
        Ret = RegistAfterCare_C(strMode, _
                                strPerID, _
                                strContactDate, _
                                strGuidanceDiv, _
                                strContactStc)

        Exit Do

    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    If (Ret <> INSERT_NORMAL) Then
        '異常終了ならRollBack
        mobjContext.SetAbort
    Else
        'トランザクションをコミット
        mobjContext.SetComplete
    End If

    '戻り値の設定
    RegistAfterCare = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistAfterCare = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "AfterCare.RegistAfterCare"
    
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

'### 2003.02.13 Updated by Ishihara@FSIT プライベート関数に変更、及び配列一括セットに変更
'
' 機能　　 : アフターケア管理項目テーブルにレコードを挿入する
'
' 引数　　 : (In)     strMode               登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)     strPerID              個人ＩＤ
' 　　　　   (In)     strContactDate        面接日
' 　　　　   (In)     strJudClassCd         判定分類コード
' 　　　　   (In)     strOtherJudClassName  その他判定分類名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Private Function RegistAfterCare_M( _
    ByVal strMode As String, _
    ByVal strPerID As Variant, _
    ByVal strContactDate As Variant, _
    ByVal strJudClassCd As Variant, _
    ByVal strOtherJudClassName As Variant _
) As Long

    Const strSectionName = "OTHERJUDCLASS"
    Const strKeyName = "NAME"

    Dim objCommon               As Object           '共通クラスオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    Dim strOther                As String           '「その他」判定分類コード
    Dim objPerId                As Object
    Dim objContactDate          As Object
    Dim objJudClassCd           As Object
    Dim objOtherJudClassName    As Object
    
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'ループカウント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    RegistAfterCare_M = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTDATE", CDate(strContactDate), ORAPARM_INPUT, ORATYPE_DATE
    
    'アフターケア管理項目テーブルレコードをすべて削除する
    strStmt = "DELETE AFTERCARE_M WHERE PERID = :PERID AND CONTACTDATE = :CONTACTDATE "
    Ret = mobjOraDb.ExecuteSQL(strStmt)
    If Ret < 0 Then
        Exit Function
    End If
    
    'バインド変数削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '判定分類コードに何もセットされていなければ処理を終了させる
    If (IsEmpty(strJudClassCd)) Then
        RegistAfterCare_M = INSERT_NORMAL
        Exit Function
    End If

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'その他判定分類コードの取得（iniファイル）
    strOther = objCommon.ReadIniFile(strSectionName, strKeyName)

    'バインド変数の配列作成
    objOraParam.AddTable "PERID", ORAPARM_INPUT, ORATYPE_VARCHAR2, UBound(strJudClassCd) + 1, LENGTH_PERSON_PERID
    objOraParam.AddTable "CONTACTDATE", ORAPARM_INPUT, ORATYPE_DATE, UBound(strJudClassCd) + 1
    objOraParam.AddTable "JUDCLASSCD", ORAPARM_INPUT, ORATYPE_NUMBER, UBound(strJudClassCd) + 1, LENGTH_JUDCLASS_JUDCLASSCD
    objOraParam.AddTable "OTHERJUDCLASSNAME", ORAPARM_INPUT, ORATYPE_VARCHAR2, UBound(strJudClassCd) + 1, 20

    Set objPerId = objOraParam("PERID")
    Set objContactDate = objOraParam("CONTACTDATE")
    Set objJudClassCd = objOraParam("JUDCLASSCD")
    Set objOtherJudClassName = objOraParam("OTHERJUDCLASSNAME")

    'OraParameterオブジェクトの値設定
    For i = 0 To UBound(strJudClassCd)
        objPerId(i) = strPerID
        objContactDate(i) = CDate(strContactDate)
        objJudClassCd(i) = strJudClassCd(i)
        'その他判定分類コードの場合は判定分類名をセットする
        If (strJudClassCd(i) = strOther) Then
'## 2003.06.11 Mod 2Lines By T.Takagi@FSIT 全角変換
'            objOtherJudClassName(i) = strOtherJudClassName
            objOtherJudClassName(i) = StrConv(Trim(strOtherJudClassName), vbWide)
'## 2003.06.11 Mod End
        Else
            objOtherJudClassName(i) = ""
        End If
    Next i

    'アフターケアテーブルレコードの挿入
    strStmt = "INSERT INTO AFTERCARE_M (      " & vbLf & _
              "            PERID,             " & vbLf & _
              "            CONTACTDATE,       " & vbLf & _
              "            JUDCLASSCD,        " & vbLf & _
              "            OTHERJUDCLASSNAME  " & vbLf & _
              "       ) VALUES (              " & vbLf & _
              "            :PERID,            " & vbLf & _
              "            :CONTACTDATE,      " & vbLf & _
              "            :JUDCLASSCD,       " & vbLf & _
              "            :OTHERJUDCLASSNAME " & vbLf & _
              "       )                       "
        
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
    Ret = INSERT_NORMAL

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    If Ret = INSERT_NORMAL Then
        '正常ならCommit
        mobjContext.SetComplete
    Else
        '異常終了ならRollBack
        mobjContext.SetAbort
    End If
 
    '戻り値の設定
    RegistAfterCare_M = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistAfterCare_M = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "AfterCare.RegistAfterCare_M"
    
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
' 機能　　 : アフターケア面接文書テーブルにレコードを挿入する
'
' 引数　　 : (In)     strMode               登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)     strPerID              個人ＩＤ
' 　　　　   (In)     strContactDate        面接日
' 　　　　   (In)     vntGuidanceDiv        指導内容区分
' 　　　　   (In)     vntContactStcCd       面接文書
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'### 2003.02.13 Updated by Ishihara@FSIT プライベート関数に変更し、関数内容を前面刷新
Private Function RegistAfterCare_C( _
    ByVal strMode As String, _
    ByVal strPerID As String, _
    ByVal strContactDate As String, _
    ByVal vntGuidanceDiv As Variant, _
    ByVal vntContactStcCd As Variant _
) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    Dim objPerId                As Object
    Dim objContactDate          As Object
    Dim objSeq                  As Object
    Dim objGuidanceDiv          As Object
    Dim objContactStcCd         As Object
    Dim vntArrContactStcCd()    As Variant
    
    Dim Ret                     As Long             '関数戻り値
    Dim i                       As Long             'ループカウント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    RegistAfterCare_C = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTDATE", CDate(strContactDate), ORAPARM_INPUT, ORATYPE_DATE
    
    strStmt = "DELETE AFTERCARE_C WHERE PERID = :PERID AND CONTACTDATE = :CONTACTDATE "
    Ret = mobjOraDb.ExecuteSQL(strStmt)
    If Ret < 0 Then
        Exit Function
    End If
    
    'バインド変数削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '指導内容区分に何もセットされていなければ処理を終了させる
    If (IsEmpty(vntGuidanceDiv)) Then
        RegistAfterCare_C = INSERT_NORMAL
        Exit Function
    End If

    '定型面接文章が配列でないなら、配列化する
    If IsArray(vntContactStcCd) = False Then
        ReDim vntArrContactStcCd(UBound(vntGuidanceDiv))
        For i = 0 To UBound(vntGuidanceDiv)
            vntArrContactStcCd(i) = ""
        Next i
        vntContactStcCd = vntArrContactStcCd
    End If

    'バインド変数の配列作成
    objOraParam.AddTable "PERID", ORAPARM_INPUT, ORATYPE_VARCHAR2, UBound(vntGuidanceDiv) + 1, LENGTH_PERSON_PERID
    objOraParam.AddTable "CONTACTDATE", ORAPARM_INPUT, ORATYPE_DATE, UBound(vntGuidanceDiv) + 1
    objOraParam.AddTable "SEQ", ORAPARM_INPUT, ORATYPE_NUMBER, UBound(vntGuidanceDiv) + 1, 1
    objOraParam.AddTable "GUIDANCEDIV", ORAPARM_INPUT, ORATYPE_NUMBER, UBound(vntGuidanceDiv) + 1, 1
    objOraParam.AddTable "STDCONTACTSTCCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, UBound(vntGuidanceDiv) + 1, 4

    Set objPerId = objOraParam("PERID")
    Set objContactDate = objOraParam("CONTACTDATE")
    Set objSeq = objOraParam("SEQ")
    Set objGuidanceDiv = objOraParam("GUIDANCEDIV")
    Set objContactStcCd = objOraParam("STDCONTACTSTCCD")
    
    For i = 0 To UBound(vntGuidanceDiv)

        objPerId(i) = strPerID
        objContactDate(i) = CDate(strContactDate)
        objSeq(i) = i + 1
        objGuidanceDiv(i) = vntGuidanceDiv(i)
        objContactStcCd(i) = vntContactStcCd(i)
        
    Next i
        
    '更新モードでない場合、または更新レコードがない場合は挿入を行う
    'アフターケアテーブルレコードの挿入
    strStmt = "INSERT INTO AFTERCARE_C (      " & vbLf & _
              "            PERID,             " & vbLf & _
              "            CONTACTDATE,       " & vbLf & _
              "            SEQ,               " & vbLf & _
              "            GUIDANCEDIV,       " & vbLf & _
              "            STDCONTACTSTCCD       " & vbLf & _
              "       ) VALUES (              " & vbLf & _
              "            :PERID,            " & vbLf & _
              "            :CONTACTDATE,      " & vbLf & _
              "            :SEQ,              " & vbLf & _
              "            :GUIDANCEDIV,      " & vbLf & _
              "            :STDCONTACTSTCCD      " & vbLf & _
              "       )                       "
    
    mobjOraDb.ExecuteSQL strStmt

    Ret = INSERT_NORMAL

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    If Ret = INSERT_NORMAL Then
        '正常ならCommit
        mobjContext.SetComplete
    Else
        '異常終了ならRollBack
        mobjContext.SetAbort
    End If
     
    '戻り値の設定
    RegistAfterCare_C = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistAfterCare_C = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "AfterCare.RegistAfterCare_C"
    
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
' 機能　　 : 個人ＩＤをキーにアフターケアテーブルを読み込む
'
' 引数　　 : (In)       strPerID           個人ＩＤ
' 　　　　   (In/Out)   vntContactDate     面接日
' 　　　　   (Out)      vntContactYear     面接年度
' 　　　　   (Out)      vntUserId          ユーザーＩＤ
' 　　　　   (Out)      vntRsvNo           予約番号
' 　　　　   (Out)      vntBlood_H         血圧（高）
' 　　　　   (Out)      vntBlood_L         血圧（低）
' 　　　　   (Out)      vntCircumStances   面接状況
' 　　　　   (Out)      vntCareComment     コメント
' 　　　　   (Out)      vntUserName        ユーザー名
'
' 戻り値　 : 読み込み件数
'
' 備考　　 :
'
Public Function SelectAfterCare( _
    ByVal strPerID As Variant, _
    Optional ByRef vntContactDate As Variant, _
    Optional ByRef vntContactYear As Variant, _
    Optional ByRef vntUserId As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntBlood_H As Variant, _
    Optional ByRef vntBlood_L As Variant, _
    Optional ByRef vntCircumStances As Variant, _
    Optional ByRef vntCareComment As Variant, _
    Optional ByRef vntUserName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト

    Dim objContactDate      As OraField         '面接日
    Dim objContactYear      As OraField         '面接年度
    Dim objUserId           As OraField         'ユーザーＩＤ
    Dim objRsvNo            As OraField         '予約番号
    Dim objBlood_H          As OraField         '血圧（高）
    Dim objBlood_L          As OraField         '血圧（低）
    Dim objCircumStances    As OraField         '面接状況
    Dim objCareComment      As OraField         'コメント
    Dim objUserName         As OraField         'ユーザー名
    
    Dim vntArrContactDate()   As Variant        '面接日
    Dim vntArrContactYear()   As Variant        '面接年度
    Dim vntArrUserId()        As Variant        'ユーザーＩＤ
    Dim vntArrRsvNo()         As Variant        '予約番号
    Dim vntArrBlood_H()       As Variant        '血圧（高）
    Dim vntArrBlood_L()       As Variant        '血圧（低）
    Dim vntArrCircumStances() As Variant        '面接状況
    Dim vntArrCareComment()   As Variant        'コメント
    Dim vntArrUserName()      As Variant        'ユーザー名
    
    Dim lngCount        As Long             'レコード数
    
    '初期値
    If (vntContactDate = "") Then vntContactDate = Empty
    vntContactYear = Empty
    vntUserId = Empty
    vntRsvNo = Empty
    vntBlood_H = Empty
    vntBlood_L = Empty
    vntCircumStances = Empty
    vntCareComment = Empty
    vntUserName = Empty
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If (strPerID <> "") Then objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (vntContactDate <> "") Then objOraParam.Add "CONTACTDATE", vntContactDate, ORAPARM_INPUT, ORATYPE_DATE

    '検索条件を満たすアフターケアテーブルのレコードを取得
    strStmt = " SELECT af.CONTACTDATE, af.CONTACTYEAR , af.USERID , af.RSVNO ,     " & vbLf & _
              "        af.BLOODPRESSURE_H , af.BLOODPRESSURE_L , af.CIRCUMSTANCES, " & _
              "        af.CARECOMMENT, hu.USERNAME                                                     " & vbLf & _
              "   FROM AFTERCARE  af, HAINSUSER hu  " & vbLf & _
              "  WHERE af.PERID        = :PERID          "
    
    '面接日が設定されていれば条件に追加
    If (Not IsEmpty(vntContactDate) Or vntContactDate <> "") Then
        strStmt = strStmt & "    AND af.CONTACTDATE        = :CONTACTDATE       " & vbLf
    End If

    strStmt = strStmt & "  AND af.USERID       = hu.USERID                      " & vbLf & _
                        "  ORDER BY af.PERID,af.CONTACTDATE DESC                "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objContactDate = objFields("CONTACTDATE")
        Set objContactYear = objFields("CONTACTYEAR")
        Set objUserId = objFields("USERID")
        Set objRsvNo = objFields("RSVNO")
        Set objBlood_H = objFields("BLOODPRESSURE_H")
        Set objBlood_L = objFields("BLOODPRESSURE_L")
        Set objCircumStances = objFields("CIRCUMSTANCES")
        Set objCareComment = objFields("CARECOMMENT")
        Set objUserName = objFields("USERNAME")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrContactDate(lngCount)
            ReDim Preserve vntArrContactYear(lngCount)
            ReDim Preserve vntArrUserId(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrBlood_H(lngCount)
            ReDim Preserve vntArrBlood_L(lngCount)
            ReDim Preserve vntArrCircumStances(lngCount)
            ReDim Preserve vntArrCareComment(lngCount)
            ReDim Preserve vntArrUserName(lngCount)

            vntArrContactDate(lngCount) = objContactDate.Value & ""
            vntArrContactYear(lngCount) = objContactYear.Value & ""
            vntArrUserId(lngCount) = objUserId.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrBlood_H(lngCount) = objBlood_H.Value & ""
            vntArrBlood_L(lngCount) = objBlood_L.Value & ""
            vntArrCircumStances(lngCount) = objCircumStances.Value & ""
            vntArrCareComment(lngCount) = objCareComment.Value & ""
            vntArrUserName(lngCount) = objUserName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

    End If
    
    '戻り値の設定
    vntContactDate = vntArrContactDate
    vntContactYear = vntArrContactYear
    vntUserId = vntArrUserId
    vntRsvNo = vntArrRsvNo
    vntBlood_H = vntArrBlood_H
    vntBlood_L = vntArrBlood_L
    vntCircumStances = vntArrCircumStances
    vntCareComment = vntArrCareComment
    vntUserName = vntArrUserName

    SelectAfterCare = lngCount

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
        
ErrorHandle:

    SelectAfterCare = -1

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectAfterCare"
    
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
' 機能　　 : 個人ＩＤをキーに２次健診の受診日を取得する
'
' 引数　　 : (In)    strPerID           個人ＩＤ
' 　　　　   (Out)   vntCslDate         ２次健診受診日
' 　　　　   (Out)   vntRsvNo           予約番号
'
' 戻り値　 : 読み込み件数
'
' 備考　　 :
'
Public Function SelectSecondCslDate( _
    ByVal strPerID As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntRsvNo As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト

    Dim objCslDate          As OraField         '受診日
    Dim objRsvNo            As OraField         '予約番号
    
    Dim vntArrCslDate()     As Variant          '受診日
    Dim vntArrRsvNo()       As Variant          '予約番号
    
    Dim lngCount            As Long             'レコード数
    
    '初期値
    vntCslDate = Empty
    vntRsvNo = Empty

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    If (IsEmpty(strPerID) Or strPerID = "") Then
        SelectSecondCslDate = -1
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If (strPerID <> "") Then objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす受診情報のレコードを取得
    strStmt = " SELECT cs.CSLDATE, cs.RSVNO       " & vbLf & _
              "   FROM CONSULT cs , COURSE_P cp   " & vbLf & _
              "  WHERE cs.PERID       = :PERID    " & vbLf & _
              "    AND cs.CSCD        = cp.CSCD   " & vbLf & _
              "    AND cp.SECONDFLG  <> 0         " & vbLf & _
              "  ORDER BY CSLDATE DESC            "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objRsvNo = objFields("RSVNO")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)

            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

    End If
    
    '戻り値の設定
    vntCslDate = vntArrCslDate
    vntRsvNo = vntArrRsvNo

    SelectSecondCslDate = lngCount

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
        
ErrorHandle:

    SelectSecondCslDate = -1

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectSecondCslDate"
    
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
' 機能　　 : アフターケアに関連する判定分類リストを取得する
'
' 引数　　 : (Out)    vntJudClassCd     判定分類コード
' 　　　　 : (Out)    vntJudClassName   判定分類名
' 　　　　 : (Out)    vntAllJudFlg      統計用総合判定フラグ
' 　　　　 : (Out)    vntAfterCareCd    アフターケアコード
'
' 戻り値　 : 0 <=   取得件数
' 　　　　 : 0 >    異常終了
'
' 備考　　 :
'
Public Function SelectJudClassAfterCare( _
    ByRef vntJudClassCd As Variant, _
    ByRef vntJudClassName As Variant, _
    ByRef vntAllJudFlg As Variant, _
    ByRef vntAfterCareCd As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名
    Dim objAllJudFl             As OraField         '統計用総合判定フラグ
    Dim objAfterCareCd          As OraField         'アフターケアコード

    Dim vntArrJudClassCd()      As Variant          '判定分類コード
    Dim vntArrJudClassName()    As Variant          '判定分類名
    Dim vntArrAllJudFlg()       As Variant          '統計用総合判定フラグ
    Dim vntArrAfterCareCd()     As Variant          'アフターケアコード
    Dim lngCount                As Long             'レコード数

    '初期値
    vntJudClassCd = Empty
    vntJudClassName = Empty
    vntAllJudFlg = Empty
    vntAfterCareCd = Empty

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '検索条件を満たす判定分類テーブルのレコードを取得
'### 2003.02.13 Updated by Ishihara@FSIT 取得順を変更
'    strStmt = "SELECT JUDCLASSCD,JUDCLASSNAME,ALLJUDFLG,AFTERCARECD  " & vbLf & _
              "  FROM JUDCLASS WHERE AFTERCARECD IS NOT NULL " & vbLf & _
              " ORDER BY JUDCLASSCD                          "
    strStmt = "SELECT JUDCLASSCD,JUDCLASSNAME,ALLJUDFLG,AFTERCARECD  " & vbLf & _
              "  FROM JUDCLASS WHERE AFTERCARECD IS NOT NULL " & vbLf & _
              " ORDER BY AFTERCARECD                         "
'### 2003.02.13 Updated End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objAllJudFl = objFields("ALLJUDFLG")
        Set objAfterCareCd = objFields("AFTERCARECD")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            '配列拡張
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrAllJudFlg(lngCount)
            ReDim Preserve vntArrAfterCareCd(lngCount)

            '値セット
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrJudClassName(lngCount) = objJudClassName.Value
            vntArrAllJudFlg(lngCount) = objAllJudFl.Value
            vntArrAfterCareCd(lngCount) = objAfterCareCd.Value
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
    End If
    
    '戻り値の設定
    vntJudClassCd = vntArrJudClassCd
    vntJudClassName = vntArrJudClassName
    vntAllJudFlg = vntArrAllJudFlg
    vntAfterCareCd = vntArrAfterCareCd

    SelectJudClassAfterCare = lngCount
        
    'キー値の解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectJudClassAfterCare"
    
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

' 機能    ： 指導内容をiniファイルより取得する。
'
' 引数　　 : (Out)    vntGuidanceDiv     判定分類コード
'
' 戻り値　 : 0 <=   取得件数
' 　　　　 : 0 >    異常終了
'
' 備考　　 :
'

Public Function GetGuidanceDiv( _
    vntGuidanceDivCd As Variant, _
    vntGuidanceDiv As Variant _
) As Long

    Dim objCommon               As Common   '共通クラス
    
    Dim vntArrGuidanceDivCd()   As Variant  '指導内容区分
    Dim vntArrGuidanceDiv()     As Variant  '指導内容
    Dim strKeyName              As Variant  'iniファイルKey
    Dim lngCount                As Long     'インデックス

    Const strBaseKeyName = "GUIDANCEDIV"  'iniファイルKey

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    '初期値
    vntGuidanceDivCd = Empty
    vntGuidanceDiv = Empty

    lngCount = 0
    Do
        '配列拡張
        ReDim Preserve vntArrGuidanceDivCd(lngCount)
        ReDim Preserve vntArrGuidanceDiv(lngCount)
        
        'キー文字列の編集
        strKeyName = strBaseKeyName & CStr(lngCount + 1)
        
        vntArrGuidanceDivCd(lngCount) = lngCount + 1
        vntArrGuidanceDiv(lngCount) = objCommon.ReadIniFile("GUIDANCEDIV", strKeyName)
        
        If (vntArrGuidanceDiv(lngCount) = "") Then
            'iniファイルに定義されている場合は数値，配列を調整
            If (lngCount <> 0) Then
                ReDim Preserve vntArrGuidanceDivCd(lngCount - 1)
                ReDim Preserve vntArrGuidanceDiv(lngCount - 1)
            End If

            Exit Do
        End If
        
        lngCount = lngCount + 1

    Loop
    
    '戻り値の設定
    vntGuidanceDivCd = vntArrGuidanceDivCd
    vntGuidanceDiv = vntArrGuidanceDiv
    
    GetGuidanceDiv = lngCount


End Function

'
' 機能　　 : 指定の個人ＩＤ，面接日に該当するアフターケア管理項目情報の件数を取得する
'
' 引数　　 : (In)     vntPerId              個人ＩＤ
' 　　　　 : (In)     strContactDate        面接日
' 　　　　 : (Out)    vntJudClassCd         判定分類コード
' 　　　　 : (Out)    vntJudClassName       判定分類名称
' 　　　　 : (Out)    vntOtherJudClassName  その他判定分類名
' 　　　　 : (In)     vntRsvNo              予約番号
'
' 戻り値　 : 該当件数
'
' 備考　　 :
'
Public Function SelectAfterCareM( _
    ByVal strPerID As Variant, _
    ByVal strContactDate As Variant, _
    Optional ByRef vntJudClassCd As Variant, _
    Optional ByRef vntJudClassName As Variant, _
    Optional ByRef vntOtherJudClassName As Variant, _
    Optional ByVal vntRsvNo As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objJudClassCd               As OraField         '判定分類コード
    Dim objJudClassName             As OraField         '判定分類名称
    Dim objOtherJudClassName        As OraField         'その他判定分類名称
    Dim vntArrJudClassCd()          As Variant          '判定分類コード
    Dim vntArrJudClassName()        As Variant          '判定分類名称
    Dim vntArrOtherJudClassName()   As Variant          'その他判定分類名称
    Dim lngCount                    As Long             'レコード数
    
    Dim objJudgement                As Object
    Dim vntSecondJudClassCd         As Variant          '２次健診での判定分類
    Dim vntSecondJudClassName       As Variant          '２次健診での判定分類名
    Dim i                           As Integer
    
    '初期値
    vntJudClassCd = Empty
    vntJudClassName = Empty
    vntOtherJudClassName = Empty
    lngCount = 0

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
'### 2003.02.14 Updated by Ishihara@FSIT IF文の意味なし
'    If (strPerID <> "") Then objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strContactDate <> "") Then objOraParam.Add "CONTACTDATE", strContactDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTDATE", strContactDate, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たすアフターケア管理項目テーブルのレコードを取得
'### 2003.02.13 Updated by Ishihara@FSIT 取得順を変更
'    strStmt = " SELECT am.JUDCLASSCD, am.OTHERJUDCLASSNAME, jc.JUDCLASSNAME    " & vbLf & _
              "   FROM AFTERCARE_M am ,JUDCLASS jc       " & vbLf & _
              "  WHERE am.PERID        = :PERID          " & vbLf & _
              "    AND am.CONTACTDATE  = :CONTACTDATE    " & vbLf & _
              "    AND am.JUDCLASSCD   = jc.JUDCLASSCD   " & vbLf & _
              "    AND jc.AFTERCARECD IS NOT NULL        " & vbLf & _
              "  ORDER BY PERID                          "
    strStmt = " SELECT am.JUDCLASSCD, am.OTHERJUDCLASSNAME, jc.JUDCLASSNAME, jc.AFTERCARECD " & vbLf & _
              "   FROM AFTERCARE_M am ,JUDCLASS jc       " & vbLf & _
              "  WHERE am.PERID        = :PERID          " & vbLf & _
              "    AND am.CONTACTDATE  = :CONTACTDATE    " & vbLf & _
              "    AND am.JUDCLASSCD   = jc.JUDCLASSCD   " & vbLf & _
              "    AND jc.AFTERCARECD IS NOT NULL        " & vbLf & _
              "  ORDER BY jc.AFTERCARECD                 "
'### 2003.02.13 Updated End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objOtherJudClassName = objFields("OTHERJUDCLASSNAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrOtherJudClassName(lngCount)

            vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
            vntArrJudClassName(lngCount) = objJudClassName.Value & ""
            vntArrOtherJudClassName(lngCount) = objOtherJudClassName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If (lngCount > 0) Then
            vntJudClassCd = vntArrJudClassCd
            vntJudClassName = vntArrJudClassName
            vntOtherJudClassName = vntArrOtherJudClassName
        End If

    Else
    
'### 2003.02.14 ADD *Lines by Ishihara@FSIT 予約番号を指定された場合、デフォルトチェック判定をひっぱる。
        'データ0件（=新規）かつ、予約番号を引数で指定されている場合、デフォルト判定をひっぱる。
        If IsMissing(vntRsvNo) = False Then
            If IsNumeric(vntRsvNo) And Trim(vntRsvNo) <> "" Then
            
                '判定オブジェクトから情報取得
                Set objJudgement = mobjContext.CreateInstance("HainsJudgement.Judgement")
                lngCount = objJudgement.SelectJudRslList(CStr(vntRsvNo), "", RSLSECOND_NONE, vntSecondJudClassCd, vntSecondJudClassName)
                Set objJudgement = Nothing
            
                '取得できたなら
                If lngCount > 0 Then
                    
                    'その他検査結果の配列を自力拡張する
                    ReDim Preserve vntArrOtherJudClassName(UBound(vntSecondJudClassCd))
                    For i = 0 To UBound(vntSecondJudClassCd)
                        vntArrOtherJudClassName(i) = ""
                    Next i
                
                    '戻り値セット
                    vntJudClassCd = vntSecondJudClassCd
                    vntJudClassName = vntSecondJudClassName
                    vntOtherJudClassName = vntArrOtherJudClassName
                
                End If
            
            End If
        End If
    
    End If

    SelectAfterCareM = lngCount

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
        
ErrorHandle:

    SelectAfterCareM = -1

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectAfterCareM"
    
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
' 機能　　 : 指定の個人ＩＤ，面接日に該当するアフターケア面接文書情報を読み込む
'
' 引数　　 : (In)     vntPerId          個人ＩＤ
' 　　　　 : (In)     strContactDate    面接日
' 　　　　 : (Out)    vntSeq            ＳＥＱＮＯ
' 　　　　 : (Out)    vntGuidanceDiv    指導内容区分
' 　　　　 : (Out)    vntContactStCd    面接文書コード
' 　　　　 : (Out)    vntContactStName  面接文書
'
' 戻り値　 : 該当件数
'
' 備考　　 :
'
Public Function SelectAfterCareC( _
    ByVal strPerID As Variant, _
    ByVal strContactDate As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntGuidanceDiv As Variant, _
    ByRef vntContactStcCd As Variant, _
    ByRef vntContactStcName As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim objSeq                  As OraField         'SEQNO
    Dim objGuidanceDiv          As OraField         '指導内容区分
    Dim objContactStcCd         As OraField         '面接文書コード
    Dim objContactStcName       As OraField         '面接文書
    
    Dim vntArrSeq()             As Variant          'SEQNO
    Dim vntArrGuidanceDiv()     As Variant          '指導内容区分
    Dim vntArrContactStcCd()    As Variant          '面接内容コード
    Dim vntArrContactStcName()  As Variant          '面接内容コード
    
    Dim lngCount                As Long             'レコード数
    
    '初期値
    vntSeq = Empty
    vntGuidanceDiv = Empty
    vntContactStcCd = Empty

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If (strPerID <> "") Then objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strContactDate <> "") Then objOraParam.Add "CONTACTDATE", strContactDate, ORAPARM_INPUT, ORATYPE_DATE

    '検索条件を満たすアフターケア面接文章テーブルのレコードを取得
'### 2003.02.13 Updated by Ishihara@FSIT 指導文章は省略可
'    strStmt = " SELECT ac.SEQ,ac.GUIDANCEDIV,ac.STDCONTACTSTCCD ,       " & vbLf & _
              "        stc.CONTACTSTC                                   " & vbLf & _
              "   FROM AFTERCARE_C ac ,STDCONTACTSTC stc                " & vbLf & _
              "  WHERE ac.PERID             = :PERID                    " & vbLf & _
              "    AND ac.CONTACTDATE       = :CONTACTDATE              " & vbLf & _
              "    AND ac.GUIDANCEDIV       = stc.GUIDANCEDIV           " & vbLf & _
              "    AND ac.STDCONTACTSTCCD   = stc.STDCONTACTSTCCD       " & vbLf & _
              "  ORDER BY ac.SEQ                                        "
    strStmt = " SELECT ac.SEQ,ac.GUIDANCEDIV,ac.STDCONTACTSTCCD ,       " & vbLf & _
              "        stc.CONTACTSTC                                   " & vbLf & _
              "   FROM AFTERCARE_C ac ,STDCONTACTSTC stc                " & vbLf & _
              "  WHERE ac.PERID             = :PERID                    " & vbLf & _
              "    AND ac.CONTACTDATE       = :CONTACTDATE              " & vbLf & _
              "    AND ac.GUIDANCEDIV       = stc.GUIDANCEDIV (+)       " & vbLf & _
              "    AND ac.STDCONTACTSTCCD   = stc.STDCONTACTSTCCD (+)   " & vbLf & _
              "  ORDER BY ac.SEQ                                        "
'### 2003.02.13 Updated End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objGuidanceDiv = objFields("GUIDANCEDIV")
        Set objContactStcCd = objFields("STDCONTACTSTCCD")
        Set objContactStcName = objFields("CONTACTSTC")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrGuidanceDiv(lngCount)
            ReDim Preserve vntArrContactStcCd(lngCount)
            ReDim Preserve vntArrContactStcName(lngCount)

            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrGuidanceDiv(lngCount) = objGuidanceDiv.Value & ""
            vntArrContactStcCd(lngCount) = objContactStcCd.Value & ""
            vntArrContactStcName(lngCount) = objContactStcName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

    End If
    
    '戻り値の設定
    vntSeq = vntArrSeq
    vntGuidanceDiv = vntArrGuidanceDiv
    vntContactStcCd = vntArrContactStcCd
    vntContactStcName = vntArrContactStcName

    SelectAfterCareC = lngCount

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
        
ErrorHandle:

    SelectAfterCareC = -1

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectAfterCareC"
    
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
' 機能　　 : 検索条件を満たす定型面接文章の一覧を取得する
'
' 引数　　 : (In)     vntKey                検索キーの集合
' 　　　　   (In)     strGuidanceDiv        指導内容区分
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectStdContactStcListCount( _
    ByVal vntKey As Variant, _
    ByVal strGuidanceDiv As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '開始位置から取得件数分のレコードを取得
    strStmt = "SELECT COUNT(*)         " & vbLf & _
              "  FROM STDCONTACTSTC    " & vbLf
              
              
    '検索条件(key)が省略されている場合は全件検索とする
    If (Not IsEmpty(vntKey)) Then
    
        '検索条件の追加
        strStmt = strStmt & vbLf & _
                  "          " & CreateConditionForStdContactStcList(vntKey)
        
        '指導内容区分が存在する場合は条件節に追加
        If (strGuidanceDiv <> "") Then
            strStmt = strStmt & vbLf & _
                  "   AND GUIDANCEDIV = " & Trim(strGuidanceDiv)
        End If

    Else
        '指導内容区分が存在する場合は条件節に追加
        If (strGuidanceDiv <> "") Then
            strStmt = strStmt & vbLf & _
                  " WHERE GUIDANCEDIV = " & Trim(strGuidanceDiv)
        End If


    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    If Not objOraDyna.EOF Then
        SelectStdContactStcListCount = IIf(IsNull(objOraDyna.Fields(0).Value), 0, objOraDyna.Fields(0).Value)
    End If

    'トランザクションをコミット
    mobjContext.SetComplete
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectStdContactStcListCount"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 検索条件を満たす定型面接文章の一覧を取得する
'
' 引数　　 : (In)     vntKey                検索キーの集合
' 　　　　   (In)     strGuidanceDiv        指導内容区分
' 　　　　   (In)     lngStartPos           開始位置
' 　　　　   (In)     lngGetCount           取得件数
' 　　　　   (Out)    vntGuidanceDiv        指導内容区分
' 　　　　   (Out)    vntStdContactStcCd    定型面接文書コード
' 　　　　   (Out)    vntContactStc         面接文章
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectStdContactStc( _
    ByVal vntKey As Variant, _
    ByVal strGuidanceDiv As Variant, _
    ByVal lngStartPos As Long, _
    ByVal lngGetCount As Long, _
    ByRef vntGuidanceDiv As Variant, _
    ByRef vntStdContactStcCd As Variant, _
    ByRef vntContactStc As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objGuidanceDiv          As OraField     '指導内容区分
    Dim objStdContactStcCd      As OraField     '定型面接文書コード
    Dim objContactStc           As OraField     '面接文章
    
    Dim vntArrGuidanceDiv()     As Variant      '指導内容区分の配列
    Dim vntArrStdContactStcCd() As Variant      '定型面接文書コードの配列
    Dim vntArrContactStc()      As Variant      '面接文章の配列
    
    Dim lngCount            As Long             '検索件数カウント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntGuidanceDiv = Empty
    vntStdContactStcCd = Empty
    vntContactStc = Empty
    lngCount = 0

    
    '開始位置から取得件数分のレコードを取得
    strStmt = "SELECT GUIDANCEDIV,      " & vbLf & _
              "       STDCONTACTSTCCD,   " & vbLf & _
              "       CONTACTSTC    "
              
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT ROWNUM SEQ,         " & vbLf & _
              "                GUIDANCEDIV,              " & vbLf & _
              "                STDCONTACTSTCCD,            " & vbLf & _
              "                CONTACTSTC            " & vbLf & _
              "           FROM STDCONTACTSTC             "
              
    '検索条件(key)が省略されている場合は全件検索とする
    If (Not IsEmpty(vntKey)) Then
    
        '検索条件の追加
        strStmt = strStmt & vbLf & _
                  "          " & CreateConditionForStdContactStcList(vntKey)
        
        '指導内容区分が存在する場合は条件節に追加
        If (strGuidanceDiv <> "") Then
            strStmt = strStmt & vbLf & _
                  "   AND GUIDANCEDIV = " & Trim(strGuidanceDiv)
        End If

    Else
        '指導内容区分が存在する場合は条件節に追加
        If (strGuidanceDiv <> "") Then
            strStmt = strStmt & vbLf & _
                  " WHERE GUIDANCEDIV = " & Trim(strGuidanceDiv)
        End If


    End If

    '指導内容区分，定型面接文章コードの順にソート
    strStmt = strStmt & vbLf & _
              "          ORDER BY GUIDANCEDIV,STDCONTACTSTCCD " & vbLf & _
              "       )                                 "
              
    '取得開始・終了位置を条件として追加
    strStmt = strStmt & vbLf & _
              " WHERE SEQ BETWEEN " & CStr(lngStartPos) & " AND " & CStr(lngStartPos + lngGetCount - 1)
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGuidanceDiv = objFields("GUIDANCEDIV")
        Set objStdContactStcCd = objFields("STDCONTACTSTCCD")
        Set objContactStc = objFields("CONTACTSTC")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGuidanceDiv(lngCount)
            ReDim Preserve vntArrStdContactStcCd(lngCount)
            ReDim Preserve vntArrContactStc(lngCount)
            
            vntArrGuidanceDiv(lngCount) = objGuidanceDiv.Value
            vntArrStdContactStcCd(lngCount) = objStdContactStcCd.Value
            vntArrContactStc(lngCount) = objContactStc.Value

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntGuidanceDiv = vntArrGuidanceDiv
        vntStdContactStcCd = vntArrStdContactStcCd
        vntContactStc = vntArrContactStc
        
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectStdContactStc = lngCount
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectStdContactStc"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 定型面接文章テーブル検索用条件節作成
'
' 引数　　 : (In/Out) vntKey  検索キーの集合
'
' 戻り値　 : 個人テーブル検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Private Function CreateConditionForStdContactStcList(ByRef vntKey As Variant) As String

    Dim objCommon       As Common   '共通クラス
    
    Dim strStmt         As String   'SQLステートメント
    Dim strCondition    As String   '検索キー
    Dim blnNarrow       As Boolean  '検索キーが半角文字のみの場合にTrue
    Dim strCheckText    As String   'カナ漢字チェック用変数
    Dim strCheckDate    As String   '日付タイプチェック用
    Dim blnWideChar     As Boolean  'カナ漢字チェック用変数
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    Dim k               As Long     'インデックス
    
    Dim strCheckText2   As String   'カナ漢字チェック用変数
    
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '最初はWHERE句から開始
    strStmt = "WHERE "
    
    '検索キー数分の条件節を追加
    For i = 0 To UBound(vntKey)
              
        '2番目以降の条件節はANDで連結
        If i >= 1 Then
            strStmt = strStmt & "AND "
        End If
        
        '検索キー中の半角カナを全角カナに変換する
        vntKey(i) = objCommon.StrConvKanaWide(vntKey(i))
        
        '検索キーが半角文字のみかチェック
        blnNarrow = (LenB(StrConv(vntKey(i), vbFromUnicode)) = Len(vntKey(i)))
        
        'アプストロフィはOracleの単一引用符と重複するので予め置換
        strCondition = Replace(vntKey(i), "'", "''")
        
        If blnNarrow Then
        
            '部分検索
            strStmt = strStmt & " STDCONTACTSTCCD LIKE '%" & strCondition & "%' "
        
        Else

            strStmt = strStmt & " CONTACTSTC LIKE '%" & strCondition & "%'  "
            
        End If
        
    Next i

    CreateConditionForStdContactStcList = strStmt
    
End Function

'### 2003.02.14 Updated by Ishihara@FSIT 関数前面刷新
'
' 機能　　 : データ日付、個人ＩＤ、団体コード１、団体コード２、事業所コード、
' 　　    　 室部コード、所属コード１、所属コード２、就業措置区分、超過勤務区分、
' 　　    　 判定分類、判定コード、年齢（生年月日）、性別をキーに受診情報を読み込む
' 　　    　 （アフターケアが必要なデータを抽出）
'
' 引数　　 : (In)     strMode               処理モード(CNT:件数カウント,SRC:検索)
' 　　　　   (In)     strOutputOrder        出力順
' 　　　　   (In)     strPerID              個人ＩＤ
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (In)     strOrgBsdCd           事業所コード
' 　　　　   (In)     strOrgRoomCd          室部コード
' 　　　　   (In)     strOrgPostCd1         所属コード１
' 　　　　   (In)     strOrgPostCd2         所属コード２
' 　　　　   (In)     strWorkMeasureDiv     就業措置区分
' 　　　　   (In)     strOverTimeDiv        超過勤務区分
' 　　　　   (In)     strJudClassCd         判定分類
' 　　　　   (In)     strJudCd              判定
' 　　　　   (In)     strStrAge             開始年齢
' 　　　　   (In)     strEndAge             終了年齢
' 　　　　   (In)     strGender             性別
' 　　　　   (In)     vntStartPos           SELECT開始位置
' 　　　　   (In)     vntGetCount           取得件数
' 　　　　   (Out)    vntPerId              個人ＩＤ
' 　　　　   (Out)    vntEmpNo              従業員番号
' 　　　　   (Out)    vntLastName           姓
' 　　　　   (Out)    vntFirstName          名
' 　　　　   (Out)    vntLastKName          姓（カナ）
' 　　　　   (Out)    vntFirstKName         名（カナ）
' 　　　　   (Out)    vntAge                年齢
' 　　　　   (Out)    vntGender             性別
' 　　　　   (Out)    vntOrgName            団体名称
' 　　　　   (Out)    vntOrgPostName        所属名称
' 　　　　   (Out)    vntWorkMeasureName    就業措置区分
' 　　　　   (Out)    vntOverTimeDiv        超過勤務区分
' 　　　　   (Out)    vntJudString          判定文字列
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectAfterCareTarget( _
    ByVal strMode As String, _
    Optional ByVal strOutputOrder As String, Optional ByVal strPerID As String, _
    Optional ByVal strOrgCd1 As String, Optional ByVal strOrgCd2 As String, _
    Optional ByVal strOrgBsdCd As String, Optional ByVal strOrgRoomCd As String, _
    Optional ByVal strOrgPostCd1 As String, Optional ByVal strOrgPostCd2 As String, _
    Optional ByVal strWorkMeasureDiv As String, Optional ByVal strOverTimeDiv As String, _
    Optional ByVal strJudClassCd As String, Optional ByVal strJudCd As String, _
    Optional ByVal strStrAge As String, Optional ByVal strEndAge As String, _
    Optional ByVal strGender As String, _
    Optional ByVal vntStartPos As Variant, Optional ByVal vntGetCount As Variant, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntEmpNo As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntAge As Variant, Optional ByRef vntGender As Variant, _
    Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgPostName As Variant, _
    Optional ByRef vntWorkMeasureName As Variant, Optional ByRef vntOverTimeDiv As Variant, _
    Optional ByRef vntJudString As Variant _
) As Long

    Const strSectionName = "JUDWEIGHTPOINT"         'iniファイルSECTION名
    Const strKeyName = "WEIGHTPOINT"                'iniファイルKey

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim objPerId                As OraField         '個人ＩＤ
    Dim objEmpNo                As OraField         '従業員番号
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    Dim objLastKName            As OraField         '姓（カナ）
    Dim objFirstKName           As OraField         '名（カナ）
    Dim objAge                  As OraField         '年齢
    Dim objGender               As OraField         '性別
    Dim objOrgName              As OraField         '団体名称
    Dim objOrgPostName          As OraField         '所属名称
    Dim objWorkMeasureName      As OraField         '就業区分名
    Dim objOverTimeDiv          As OraField         '超過勤務区分
    Dim objJudString            As OraField         '判定文字列
    Dim objRecordCount          As OraField
    
    Dim vntArrPerId()           As Variant          '個人ＩＤ
    Dim vntArrEmpNo()           As Variant          '従業員番号
    Dim vntArrLastName()        As Variant          '姓
    Dim vntArrFirstName()       As Variant          '名
    Dim vntArrLastKName()       As Variant          '姓（カナ）
    Dim vntArrFirstKName()      As Variant          '名（カナ）
    Dim vntArrAge()             As Variant          '年齢
    Dim vntArrGender()          As Variant          '性別
    Dim vntArrOrgName()         As Variant          '団体名称
    Dim vntArrOrgPostName()     As Variant          '所属名称
    Dim vntArrWorkMeasureName() As Variant          '就業区分名
    Dim vntArrOverTimeDiv()     As Variant          '超過勤務区分
    Dim vntArrJudString()       As Variant          '判定文字列

    Dim lngCount                As Long             'レコード数
    
    Dim objCommon               As Object           '共用オブジェクト
    Dim objJud                  As Object           '判定オブジェクト
    Dim strWeightPoint          As String           '判定用重み
    Dim strTargetWeightPoint    As String           '判定用重み（検索条件に判定を指定された場合の重み）
    Dim strStrBirth             As String
    Dim strEndBirth             As String
    Dim strWorkBirth            As String

    '判定重みの取得（iniファイル）
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    strWeightPoint = objCommon.ReadIniFile(strSectionName, strKeyName)
    Set objCommon = Nothing

    '初期値
    vntPerId = Empty
    vntEmpNo = Empty
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntAge = Empty
    vntGender = Empty
    vntOrgName = Empty
    vntOrgPostName = Empty
    vntWorkMeasureName = Empty
    vntOverTimeDiv = Empty
    vntJudString = Empty
   
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '所属の範囲指定が片方のみなら、未設定部分にもセットする。
    If (Trim(strOrgPostCd1) <> "") And (Trim(strOrgPostCd2) = "") Then
        strOrgPostCd2 = strOrgPostCd1
    End If
    
    '検索条件に判定が指定されているなら・・・（やめてほしいけど）
    If (strJudClassCd <> "") And (strJudCd <> "") Then
        
        '指定された判定から合致する重みを取得する
        Set objJud = mobjContext.CreateInstance("HainsJud.Jud")
        Call objJud.SelectJud(strJudCd, , , strTargetWeightPoint)
        Set objJud = Nothing
    
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strPerID <> "") Then objOraParam.Add "PERID", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgBsdCd <> "") Then objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgRoomCd <> "") Then objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgPostCd1 <> "") Then objOraParam.Add "ORGPOSTCD1", strOrgPostCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgPostCd2 <> "") Then objOraParam.Add "ORGPOSTCD2", strOrgPostCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strWorkMeasureDiv <> "") Then objOraParam.Add "WORKMEASUREDIV", strWorkMeasureDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOverTimeDiv <> "") Then objOraParam.Add "OVERTIMEDIV", strOverTimeDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    If (strGender <> "") Then objOraParam.Add "GENDER", strGender, ORAPARM_INPUT, ORATYPE_NUMBER
    If (strJudClassCd <> "") Then objOraParam.Add "JUDCLASSCD", strJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
'    If (strJudCd <> "") Then objOraParam.Add "JUDCD", strJudCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strWeightPoint <> "") Then objOraParam.Add "WEIGHTPOINT", strWeightPoint, ORAPARM_INPUT, ORATYPE_NUMBER
    If (strTargetWeightPoint <> "") Then objOraParam.Add "TARWEIGHTPOINT", strTargetWeightPoint, ORAPARM_INPUT, ORATYPE_NUMBER

'    If (strPerID <> "") Then objOraParam.Add "PERID_SRC", strPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1_SRC", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2_SRC", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strOrgBsdCd <> "") Then objOraParam.Add "ORGBSDCD_SRC", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strOrgRoomCd <> "") Then objOraParam.Add "ORGROOMCD_SRC", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strOrgPostCd1 <> "") Then objOraParam.Add "ORGPOSTCD_SRC1", strOrgPostCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strOrgPostCd2 <> "") Then objOraParam.Add "ORGPOSTCD2_SRC", strOrgPostCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strWorkMeasureDiv <> "") Then objOraParam.Add "WORKMEASUREDIV_SRC", strWorkMeasureDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    If (strOverTimeDiv <> "") Then objOraParam.Add "OVERTIMEDIV_SRC", strOverTimeDiv, ORAPARM_INPUT, ORATYPE_NUMBER
'    If (strGender <> "") Then objOraParam.Add "GENDER_SRC", strGender, ORAPARM_INPUT, ORATYPE_NUMBER

    '年齢を片方しかセットされていない場合、両方にセットする。
    If (strStrAge <> "") And (strEndAge = "") Then strEndAge = strStrAge
    If (strStrAge = "") And (strEndAge <> "") Then strStrAge = strEndAge
    
    '年齢を２つセット。かつ、逆転している場合は、セットしかえし。
    If (strStrAge <> "") And (strEndAge <> "") Then
        If strStrAge > strEndAge Then
            strWorkBirth = strStrAge
            strStrAge = strEndAge
            strEndAge = strWorkBirth
        End If
    End If

    '開始年齢から生年月日を算出し設定する
    '～年齢範囲からの西暦は開始終了範囲が逆転するため、セット先に注意する。
    If (strStrAge <> "") Then
        strEndBirth = Format(DateAdd("yyyy", CLng("0" & strStrAge) * -1, Date), "yyyy/mm/dd")
        objOraParam.Add "BIRTH2", strEndBirth, ORAPARM_INPUT, ORATYPE_DATE
    End If
    
    '終了年齢から生年月日を算出し設定する
    '～年齢範囲からの西暦は開始終了範囲が逆転するため、セット先に注意する。
    If (strEndAge <> "") Then
        strStrBirth = Format(DateAdd("yyyy", (CLng("0" & strEndAge) + 1) * -1, Date), "yyyy/mm/dd")
        strStrBirth = DateAdd("d", 1, CDate(strStrBirth))
        objOraParam.Add "BIRTH1", strStrBirth, ORAPARM_INPUT, ORATYPE_DATE
    End If

    '取得件数と開始位置が設定されている場合
    If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
        objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    'SQL文BUILD
    If strMode = "CNT" Then
        strStmt = _
                "SELECT COUNT(LASTVIEW.PERID) RECORDCOUNT                           " & vbLf
    Else
        
        '最終的に取得するデータ部分で性別、年齢、判定をデータ加工する。（速度重視）
        strStmt = _
                "SELECT LASTVIEW.PERID,                                             " & vbLf & _
                "       LASTVIEW.ORGNAME,                                           " & vbLf & _
                "       LASTVIEW.EMPNO,                                             " & vbLf & _
                "       LASTVIEW.LASTNAME, LASTVIEW.FIRSTNAME,                      " & vbLf & _
                "       LASTVIEW.LASTKNAME, LASTVIEW.FIRSTKNAME,                    " & vbLf & _
                "       DECODE(LASTVIEW.GENDER,'1','男性','2','女性',NULL) GENDER,  " & vbLf & _
                "       GETCSLAGE(LASTVIEW.BIRTH, SYSDATE, NULL) AGE,               " & vbLf & _
                "       LASTVIEW.ORGPOSTNAME,                                       " & vbLf & _
                "       LASTVIEW.WORKMEASURENAME,                                   " & vbLf & _
                "       LASTVIEW.OVERTIMEDIV,                                       " & vbLf & _
                "       GetLatestJudgement(LASTVIEW.PERID, :WEIGHTPOINT, NULL) JUDSTRING " & vbLf
                
    End If
        
    strStmt = strStmt & _
            "  FROM (                                                          " & vbLf & _
            "SELECT SEQVIEW.PERID,                                             " & vbLf & _
            "       SEQVIEW.ORGNAME,                                           " & vbLf & _
            "       SEQVIEW.EMPNO,                                             " & vbLf & _
            "       SEQVIEW.LASTNAME, SEQVIEW.FIRSTNAME,                       " & vbLf & _
            "       SEQVIEW.LASTKNAME, SEQVIEW.FIRSTKNAME,                     " & vbLf & _
            "       SEQVIEW.GENDER,                                            " & vbLf & _
            "       SEQVIEW.BIRTH,                                             " & vbLf & _
            "       SEQVIEW.ORGPOSTNAME,                                       " & vbLf & _
            "       SEQVIEW.WORKMEASURENAME,                                   " & vbLf & _
            "       SEQVIEW.OVERTIMEDIV,                                       " & vbLf & _
            "       SEQVIEW.ROWSEQ                                             " & vbLf
        
    strStmt = strStmt & _
            "  FROM (                                                            " & vbLf & _
            "SELECT BASICVIEW.PERID,                                             " & vbLf & _
            "       BASICVIEW.ORGNAME,                                           " & vbLf & _
            "       BASICVIEW.EMPNO,                                             " & vbLf & _
            "       BASICVIEW.LASTNAME, BASICVIEW.FIRSTNAME,                     " & vbLf & _
            "       BASICVIEW.LASTKNAME, BASICVIEW.FIRSTKNAME,                   " & vbLf & _
            "       BASICVIEW.GENDER,                                            " & vbLf & _
            "       BASICVIEW.BIRTH,                                             " & vbLf & _
            "       BASICVIEW.ORGPOSTNAME,                                       " & vbLf & _
            "       BASICVIEW.WORKMEASURENAME,                                   " & vbLf & _
            "       BASICVIEW.OVERTIMEDIV,                                       " & vbLf & _
            "       ROWNUM ROWSEQ                                                " & vbLf
    
    strStmt = strStmt & _
            "  FROM ( SELECT DISTINCT PERSON.PERID,                              " & vbLf & _
            "                ORG.ORGNAME,                                        " & vbLf & _
            "                PERSON.EMPNO,                                       " & vbLf & _
            "                PERSON.LASTNAME, PERSON.FIRSTNAME,                  " & vbLf & _
            "                PERSON.LASTKNAME, PERSON.FIRSTKNAME,                " & vbLf & _
            "                PERSON.GENDER,                                      " & vbLf & _
            "                PERSON.ORGPOSTCD,                                   " & vbLf & _
            "                PERSON.JOBCD,                                       " & vbLf & _
            "                PERSON.BIRTH,                                       " & vbLf & _
            "                ORGPOST.ORGPOSTNAME,                                " & vbLf & _
            "                FREE.FREEFIELD1 WORKMEASURENAME,                    " & vbLf

    '検索条件に判定が指定されているなら・・・（やめてほしいけど）
    If (strJudClassCd <> "") And (strJudCd <> "") Then
        strStmt = strStmt & _
                "            GetLatestJudgement(PERSON.PERID, :TARWEIGHTPOINT, :JUDCLASSCD) TARJUDSTRING, " & vbLf
    End If
    
    strStmt = strStmt & _
            "                PERSON.OVERTIMEDIV                                  " & vbLf & _
            "           FROM FREE, ORGPOST, ORG, PERSON                          " & vbLf
    
    If (strPerID <> "") Then
        '個人IDが指定されている場合
        strStmt = strStmt & _
                "          WHERE PERSON.PERID     = :PERID                       " & vbLf
    Else
        
        '団体IDが指定されている場合
        strStmt = strStmt & _
                "          WHERE PERSON.ORGCD1    = :ORGCD1      " & vbLf & _
                "            AND PERSON.ORGCD2    = :ORGCD2      " & vbLf

        '事業所コードが設定されている場合は条件を付加
        If (strOrgBsdCd <> "") Then
            strStmt = strStmt & _
                "            AND  PERSON.ORGBSDCD      = :ORGBSDCD      " & vbLf
        End If
   
        '室部コードが設定されている場合は条件を付加
        If (strOrgRoomCd <> "") Then
            strStmt = strStmt & _
                 "           AND  PERSON.ORGROOMCD     = :ORGROOMCD    " & vbLf
         End If
 
        '所属コード１が設定されている場合は条件を付加
        If (strOrgPostCd1 <> "") Then
             strStmt = strStmt & _
                 "           AND  PERSON.ORGPOSTCD    >= :ORGPOSTCD1   " & vbLf
        End If
            
        '所属コード２が設定されている場合は条件を付加
        If (strOrgPostCd2 <> "") Then
            strStmt = strStmt & _
                "            AND  PERSON.ORGPOSTCD    <= :ORGPOSTCD2    " & vbLf
        End If
    
        '就業措置区分が設定されている場合は条件を追加
        If (strWorkMeasureDiv <> "") Then
            strStmt = strStmt & _
                "            AND PERSON.WORKMEASUREDIV   = :WORKMEASUREDIV " & vbLf
        End If
        
        '超過勤務区分が設定されている場合は条件を追加
        If (strOverTimeDiv <> "") Then
            strStmt = strStmt & _
                "            AND PERSON.OVERTIMEDIV      = :OVERTIMEDIV    " & vbLf
        End If
       
        '年齢１が設定されている場合は条件を追加
        If (strStrAge <> "") Then
            strStmt = strStmt & _
                "            AND PERSON.BIRTH           >= :BIRTH1         " & vbLf
        End If
    
        '年齢２が設定されている場合は条件を追加
        If (strEndAge <> "") Then
            strStmt = strStmt & _
                "            AND PERSON.BIRTH           <= :BIRTH2         " & vbLf
        End If
    
        '性別が設定されている場合は条件を追加
        If (strGender <> "") Then
            strStmt = strStmt & _
                "            AND PERSON.GENDER           = :GENDER         " & vbLf
        End If
    
    End If
    
    strStmt = strStmt & _
            "            AND PERSON.ORGCD1    = ORG.ORGCD1(+)                    " & vbLf & _
            "            AND PERSON.ORGCD2    = ORG.ORGCD2(+)                    " & vbLf & _
            "            AND PERSON.ORGCD1    = ORGPOST.ORGCD1 (+)               " & vbLf & _
            "            AND PERSON.ORGCD2    = ORGPOST.ORGCD2 (+)               " & vbLf & _
            "            AND PERSON.ORGBSDCD  = ORGPOST.ORGBSDCD (+)             " & vbLf & _
            "            AND PERSON.ORGROOMCD = ORGPOST.ORGROOMCD (+)            " & vbLf & _
            "            AND PERSON.ORGPOSTCD = ORGPOST.ORGPOSTCD (+)            " & vbLf & _
            "            AND PERSON.WORKMEASUREDIV = FREE.FREECD (+)             " & vbLf

    '表示出力順が設定されている場合は条件を追加
    If (strOutputOrder <> "") Then
        Select Case strOutputOrder
            Case "1"
                strStmt = strStmt & " ORDER BY PERSON.LASTKNAME,PERSON.FIRSTKNAME " & vbLf
            Case "2"
                strStmt = strStmt & " ORDER BY PERSON.EMPNO " & vbLf
            Case "3"
                strStmt = strStmt & " ORDER BY PERSON.ORGPOSTCD " & vbLf
            Case "4"
                strStmt = strStmt & " ORDER BY PERSON.JOBCD " & vbLf
        End Select
    End If

    strStmt = strStmt & _
            "        ) BASICVIEW                                                 "
    
    '検索条件に判定が指定されているなら・・・（やめてほしいけど）
    If (strJudClassCd <> "") And (strJudCd <> "") Then
            strStmt = strStmt & _
                " WHERE BASICVIEW.TARJUDSTRING IS NOT NULL                   " & vbLf
    End If
    
    strStmt = strStmt & _
            "        ) SEQVIEW                                                 "
    
    '取得件数と開始位置が設定されている場合
    If strMode <> "CNT" Then
        If (IsMissing(vntStartPos) = False) And (IsMissing(vntGetCount) = False) Then
            If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) And _
               Trim(vntStartPos) <> "" And Trim(vntGetCount) <> "" Then
                    strStmt = strStmt & vbLf & _
                              "   WHERE SEQVIEW.ROWSEQ BETWEEN :SEQ_F AND :SEQ_T " & vbLf
            End If
        End If
    End If
    
    strStmt = strStmt & _
            "        ) LASTVIEW                                                 "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        If strMode = "CNT" Then
            Set objRecordCount = objFields("RECORDCOUNT")
        Else
            Set objPerId = objFields("PERID")
            Set objOrgName = objFields("ORGNAME")
            Set objEmpNo = objFields("EMPNO")
            Set objLastName = objFields("LASTNAME")
            Set objFirstName = objFields("FIRSTNAME")
            Set objLastKName = objFields("LASTKNAME")
            Set objFirstKName = objFields("FIRSTKNAME")
            Set objGender = objFields("GENDER")
            Set objAge = objFields("AGE")
            Set objOrgPostName = objFields("ORGPOSTNAME")
            Set objWorkMeasureName = objFields("WORKMEASURENAME")
            Set objOverTimeDiv = objFields("OVERTIMEDIV")
            Set objJudString = objFields("JUDSTRING")
        End If
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF

            If strMode = "CNT" Then
                'カウントのみの場合は、ここで終了
                lngCount = CLng(objRecordCount.Value & "")
                Exit Do
            Else
                ReDim Preserve vntArrPerId(lngCount)
                ReDim Preserve vntArrEmpNo(lngCount)
                ReDim Preserve vntArrLastName(lngCount)
                ReDim Preserve vntArrFirstName(lngCount)
                ReDim Preserve vntArrLastKName(lngCount)
                ReDim Preserve vntArrFirstKName(lngCount)
                ReDim Preserve vntArrAge(lngCount)
                ReDim Preserve vntArrGender(lngCount)
                ReDim Preserve vntArrOrgName(lngCount)
                ReDim Preserve vntArrOrgPostName(lngCount)
                ReDim Preserve vntArrWorkMeasureName(lngCount)
                ReDim Preserve vntArrOverTimeDiv(lngCount)
                ReDim Preserve vntArrJudString(lngCount)
    
                vntArrPerId(lngCount) = objPerId.Value & ""
                vntArrEmpNo(lngCount) = objEmpNo.Value & ""
                vntArrLastName(lngCount) = objLastName.Value & ""
                vntArrFirstName(lngCount) = objFirstName.Value & ""
                vntArrLastKName(lngCount) = objLastKName.Value & ""
                vntArrFirstKName(lngCount) = objFirstKName.Value & ""
                vntArrAge(lngCount) = objAge.Value & ""
                vntArrGender(lngCount) = objGender.Value & ""
                vntArrOrgName(lngCount) = objOrgName.Value & ""
                vntArrOrgPostName(lngCount) = objOrgPostName.Value & ""
                vntArrWorkMeasureName(lngCount) = objWorkMeasureName.Value & ""
                vntArrOverTimeDiv(lngCount) = objOverTimeDiv.Value & ""
                vntArrJudString(lngCount) = objJudString.Value & ""
    
                lngCount = lngCount + 1
                objOraDyna.MoveNext
            End If
        Loop
    
    End If
    
    '戻り値の設定
    If IsMissing(vntPerId) = False Then vntPerId = vntArrPerId
    If IsMissing(vntEmpNo) = False Then vntEmpNo = vntArrEmpNo
    If IsMissing(vntLastName) = False Then vntLastName = vntArrLastName
    If IsMissing(vntFirstName) = False Then vntFirstName = vntArrFirstName
    If IsMissing(vntLastKName) = False Then vntLastKName = vntArrLastKName
    If IsMissing(vntFirstKName) = False Then vntFirstKName = vntArrFirstKName
    If IsMissing(vntAge) = False Then vntAge = vntArrAge
    If IsMissing(vntGender) = False Then vntGender = vntArrGender
    If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
    If IsMissing(vntOrgPostName) = False Then vntOrgPostName = vntArrOrgPostName
    If IsMissing(vntWorkMeasureName) = False Then vntWorkMeasureName = vntArrWorkMeasureName
    If IsMissing(vntOverTimeDiv) = False Then vntOverTimeDiv = vntArrOverTimeDiv
    If IsMissing(vntJudString) = False Then vntJudString = vntArrJudString

    SelectAfterCareTarget = lngCount

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
        
ErrorHandle:

    SelectAfterCareTarget = -1

    'イベントログ書き込み
    WriteErrorLog "AfterCare.SelectAfterCareTarget"
    
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
