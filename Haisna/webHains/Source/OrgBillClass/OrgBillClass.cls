VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "OrgBillClass"
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
' 機能　　 : 団体請求書分類テーブルにレコードを追加する
'
' 引数　　 : (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
'
' 戻り値　 :  1  正常終了
' 　　　　   -1  異常終了
'
' 備考　　 : 請求書分類テーブルのデフォルトチェックが「１」のデータを追加する。
'
Public Function NewInsrtOrgBillClass( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2


    '団体請求書分類テーブルへのレコード追加
    '
    strStmt = "INSERT INTO ORGBILLCLASS (                       " & vbLf & _
              "                           ORGCD1,               " & vbLf & _
              "                           ORGCD2,               " & vbLf & _
              "                           BILLCLASSCD           " & vbLf & _
              "                         )                       " & vbLf & _
              "                         SELECT :ORGCD1,         " & vbLf & _
              "                                :ORGCD2,         " & vbLf & _
              "                                BILLCLASSCD      " & vbLf & _
              "                           FROM BILLCLASS        " & vbLf & _
              "                          WHERE DEFCHECK = 1     " & vbLf

    mobjOraDb.ExecuteSQL strStmt

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    NewInsrtOrgBillClass = 1
    
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
    
    '戻り値の設定
    NewInsrtOrgBillClass = -1
    
    'イベントログ書き込み
    WriteErrorLog "OrgBillClass.NewInsrtOrgBillClass"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 団体管理請求書分類テーブルからレコードを削除する
'
' 引数　　 : (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
'
' 戻り値　 : 1   正常終了
' 　　　　   -1  異常終了
'
' 備考　　 : 請求書分類テーブルのデフォルトチェックが「１」のデータを追加する。
'
Public Function DeleteOrgBillClass( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2


    '団体請求書分類テーブルへのレコード追加
    '
    strStmt = "DELETE ORGBILLCLASS              " & vbLf & _
              " WHERE ORGCD1  =  :ORGCD1        " & vbLf & _
              "   AND ORGCD2  =  :ORGCD2        " & vbLf

    mobjOraDb.ExecuteSQL strStmt

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteOrgBillClass = 1
    
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
    
    '戻り値の設定
    DeleteOrgBillClass = -1
    
    'イベントログ書き込み
    WriteErrorLog "OrgBillClass.DeleteOrgBillClass"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 請求書分類テーブルからレコードを取得する
'
' 引数　　 : (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (Out)    vntBillClassCd    該当フラグ
' 　　　　   (Out)    vntBillClassName  該当フラグ
' 　　　　   (In/Out) strCheckFlg       該当フラグ
'
' 戻り値　 : 1   正常終了
' 　　　　   -1  異常終了
'
' 備考　　 : 団体管理請求書分類テーブルに請求書分類コードが設定されていれば
' 　　　　   CheckFlgに団体コード１が設定される
' 　　　　   また、引数としてCheckFlgが設定されている場合は、チェックフラグの内容を設定し直す
'
Public Function SelectBillClass( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    Optional ByRef vntBillClassCd As Variant, _
    Optional ByRef vntBillClassName As Variant, _
    Optional ByRef vntCheckFlg As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim objBillClassCd          As OraField         '請求書分類コード
    Dim objBillClassName        As OraField         '請求書分類名
    Dim objCheckFlg             As OraField         '該当フラグ
    
    Dim vntArrBillClassCd()     As Variant          '続柄コード
    Dim vntArrBillClassName()   As Variant          '続柄名
    Dim vntArrCheckFlg()        As Variant          '該当フラグ
    
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'カウント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2


    '団体請求書分類テーブル検索
    strStmt = " SELECT BILLCLASS.BILLCLASSCD,                               " & vbLf & _
              "        BILLCLASS.BILLCLASSNAME,                             " & vbLf & _
              "        ( SELECT  ORGCD1  FROM  ORGBILLCLASS                 " & vbLf & _
                        "    WHERE  ORGBILLCLASS.ORGCD1 = :ORGCD1           " & vbLf & _
                        "      AND  ORGBILLCLASS.ORGCD2 = :ORGCD2           " & vbLf & _
                        "      AND  ORGBILLCLASS.BILLCLASSCD  = BILLCLASS.BILLCLASSCD " & vbLf & _
                        " ) ORGCD                                        " & vbLf & _
              "   FROM BILLCLASS                                            " & vbLf & _
              "  ORDER BY BILLCLASS.BILLCLASSCD                             " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillClassCd = objFields("BILLCLASSCD")
        Set objBillClassName = objFields("BILLCLASSNAME")
        Set objCheckFlg = objFields("ORGCD")

        '配列形式で格納する
        i = 0
        lngCount = 0
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrBillClassCd(lngCount)
            ReDim Preserve vntArrBillClassName(lngCount)
            ReDim Preserve vntArrCheckFlg(lngCount)

            vntArrBillClassCd(lngCount) = objBillClassCd.Value & ""
            vntArrBillClassName(lngCount) = objBillClassName.Value & ""
            vntArrCheckFlg(lngCount) = objCheckFlg.Value & ""
            
            'チェックフラグが引数として渡されていれば、該当する請求書分類コードのフラグを立てる
            If (Not IsEmpty(vntCheckFlg)) Then
                If (UBound(vntCheckFlg) >= i) Then
                    If (vntCheckFlg(i) = vntArrBillClassCd(lngCount)) Then
                        vntArrCheckFlg(lngCount) = vntArrBillClassCd(lngCount)
                        i = i + 1
                    End If
                End If
            End If

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

    End If
    
    '戻り値の設定
    vntBillClassCd = vntArrBillClassCd
    vntBillClassName = vntArrBillClassName
    vntCheckFlg = vntArrCheckFlg

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectBillClass = 1
    
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
    
    '戻り値の設定
    SelectBillClass = -1
    
    'イベントログ書き込み
    WriteErrorLog "OrgBillClass.SelectBillClass"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 団体管理請求書分類テーブルへレコードを追加する
'
' 引数　　 : (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     vntBillClassCd    請求書分類コード
'
' 戻り値　 :   1 正常終了
' 　　　　    -1 異常終了
' 　　　　   -10 コースコード重複あり
'
' 備考　　 :
'
Public Function InsertOrgBillClass( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal vntBillClassCd As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'ループカウント
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    '団体請求書分類テーブル削除
    If (DeleteOrgBillClass(strOrgCd1, strOrgCd2) < 0) Then
      mobjContext.SetAbort
      InsertOrgBillClass = -1
      Exit Function
    End If

    '団体請求分類テーブルへのレコード追加
    If (Not IsEmpty(vntBillClassCd)) Then

        For i = 0 To UBound(vntBillClassCd)
          objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
          objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
          objOraParam.Add "BILLCLASSCD", Trim(vntBillClassCd(i)), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
          strStmt = "INSERT INTO ORGBILLCLASS (     " & vbLf & _
                    "            ORGCD1,              " & vbLf & _
                    "            ORGCD2,              " & vbLf & _
                    "            BILLCLASSCD          " & vbLf & _
                    "       ) VALUES (                " & vbLf & _
                    "            :ORGCD1,             " & vbLf & _
                    "            :ORGCD2,             " & vbLf & _
                    "            :BILLCLASSCD         " & vbLf & _
                    "       )                          "
                    
            mobjOraDb.ExecuteSQL strStmt
    
            'バインド変数の削除
            objOraParam.Remove ("ORGCD1")
            objOraParam.Remove ("ORGCD2")
            objOraParam.Remove ("BILLCLASSCD")
    
        Next

    End If

    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    InsertOrgBillClass = 1
    
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
    
    '戻り値の設定
    InsertOrgBillClass = -1
    
    'イベントログ書き込み
    WriteErrorLog "OrgBillClass.InsertOrgBillClass"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
'
' 機能　　 : 団体請求書分類テーブルからレコードを取得する。
'
' 引数　　 : (In)     vntBillClassCd    請求書分類コード
' 　　　　   (Out)    vntCsCd           コースコード
'  　　　　  (Out)    vntLngCount       コースコードカウント
'
' 戻り値　 : 0             正常終了
' 　　　　   -1            異常終了
' 　　　　   -10           コースコード重複あり
'
' 備考　　 :
'
Public Function SelectBillClass_c( _
    ByVal vntBillClassCd As Variant, _
    ByRef vntCsCd As Variant, _
    ByRef vntLngCount As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim objCsCd                 As OraField         'コースコード
    Dim objLngCount             As OraField         'コースコードカウント

    Dim vntArrCsCd()            As Variant          'コースコード
    Dim vntArrLngCount()        As Variant          'コースコードカウント
    
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    
    '団体請求書分類テーブル検索
    strStmt = " SELECT CSCD,CSCDCOUNT FROM (                " & vbLf & _
              " SELECT CSCD,                                " & vbLf & _
              "        COUNT(CSCD) CSCDCOUNT                " & vbLf & _
              "   FROM BILLCLASS_C                          " & vbLf & _
              "  WHERE BILLCLASSCD = '" & vntBillClassCd(0) & "'" & vbLf
              
    For i = 1 To UBound(vntBillClassCd)
        strStmt = strStmt & "    OR  BILLCLASSCD  = '" & vntBillClassCd(i) & "'" & vbLf
    Next

    strStmt = strStmt & "  GROUP BY CSCD " & vbLf
    strStmt = strStmt & " )              " & vbLf & _
                        " WHERE CSCDCOUNT > 1 " & vbLf & _
                        " ORDER BY CSCD " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objLngCount = objFields("CSCDCOUNT")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrLngCount(lngCount)

            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrLngCount(lngCount) = IIf(IsNull(objLngCount.Value), 0, objLngCount.Value) & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntCsCd = vntArrCsCd
        vntLngCount = vntArrLngCount

    End If

    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectBillClass_c = 1
    
    Exit Function
    
ErrorHandle:

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '戻り値の設定
    SelectBillClass_c = -1
    
    'イベントログ書き込み
    WriteErrorLog "OrgBillClass.SelectBillClass_c"
    
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
