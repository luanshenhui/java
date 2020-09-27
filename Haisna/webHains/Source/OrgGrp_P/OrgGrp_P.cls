VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "OrgGrp_P"
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
' 機能　　 : 団体グループの一覧を団体グループコードの昇順で取得する
'
' 引数　　 : (Out)    vntOrgGrpCd      団体グループコード
' 　　　　   (Out)    vntGrpName       団体グループ名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectOrgGrp_PList( _
    ByRef vntOrgGrpCd As Variant, _
    ByRef vntGrpName As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOrgGrpCd             As OraField         '団体グループコード
    Dim objGrpName              As OraField         '団体グループ名
    
    Dim vntArrOrgGrpCd()        As Variant          '団体グループコードの配列
    Dim vntArrGrpName()         As Variant          '団体グループ名
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntOrgGrpCd = Empty
    vntGrpName = Empty
    lngCount = 0
    
    '団体グループの一覧を団体グループコードの昇順で取得する。
'## 2004/6/2 UPD ST FAS)C.M
'    strStmt = "SELECT ORGGRPCD, GRPNAME " & vbLf & _
'              "  FROM ORGGRP_P          " & vbLf & _
'              "ORDER BY ORGGRPCD "
    strStmt = "SELECT ORGGRPCD, GRPNAME " & vbLf & _
              "  FROM ORGGRP_P          " & vbLf & _
              " WHERE SYSTEMGRP IS NULL " & vbLf & _
              "ORDER BY ORGGRPCD "
'## 2004/6/2 UPD ED

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgGrpCd = objFields("ORGGRPCD")
        Set objGrpName = objFields("GRPNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOrgGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            
            vntArrOrgGrpCd(lngCount) = objOrgGrpCd.Value
            vntArrGrpName(lngCount) = objGrpName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntOrgGrpCd = vntArrOrgGrpCd
        vntGrpName = vntArrGrpName
    
    End If
    
    '戻り値の設定
    SelectOrgGrp_PList = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrgGrp_PList = -1

    'イベントログ書き込み
    WriteErrorLog "OrgGrp_P.SelectOrgGrp_PList"
    
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


' 機能　　 : 団体グループの一覧を団体グループコードの昇順で取得する
'
' 引数　　 : (Out)    vntOrgGrpCd      団体グループコード
' 　　　　   (Out)    vntGrpName       団体グループ名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectOrgGrp_PList2(ByRef vntOrgGrpCd As Variant, _
                                    ByRef vntGrpName As Variant, _
                                    ByVal vntUseGrp As Variant _
                                    ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOrgGrpCd             As OraField         '団体グループコード
    Dim objGrpName              As OraField         '団体グループ名
    
    Dim vntArrOrgGrpCd()        As Variant          '団体グループコードの配列
    Dim vntArrGrpName()         As Variant          '団体グループ名
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntOrgGrpCd = Empty
    vntGrpName = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USEGRP", CInt(vntUseGrp), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '団体グループの一覧を団体グループコードの昇順で取得する。
    strStmt = " SELECT ORGGRPCD, GRPNAME                    " & vbLf & _
              " FROM ORGGRP_P                               " & vbLf & _
              " WHERE SYSTEMGRP IS NULL                     " & vbLf & _
              "       AND  USEGRP   =  :USEGRP              " & vbLf & _
              " ORDER BY ORGGRPCD                           "
'## 2004/6/2 UPD ED

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgGrpCd = objFields("ORGGRPCD")
        Set objGrpName = objFields("GRPNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOrgGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            
            vntArrOrgGrpCd(lngCount) = objOrgGrpCd.Value
            vntArrGrpName(lngCount) = objGrpName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntOrgGrpCd = vntArrOrgGrpCd
        vntGrpName = vntArrGrpName
    
    End If
    
    '戻り値の設定
    SelectOrgGrp_PList2 = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    'バインド変数の削除（帳票出力時に使用しているため）
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Exit Function
    
ErrorHandle:

    SelectOrgGrp_PList2 = -1

    'イベントログ書き込み
    WriteErrorLog "OrgGrp_P.SelectOrgGrp_PList2"
    
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



