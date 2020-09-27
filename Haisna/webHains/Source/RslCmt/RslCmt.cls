VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "RslCmt"
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
' 機能　　 : 結果コメントの一覧を取得する
'
' 引数　　 : (Out)    vntRslCmtCd   結果コメントコード
' 　　　　 : (Out)    vntRslCmtName 結果コメント名
' 　　　　 : (Out)    vntEntryOk    入力完了フラグ（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectRslCmtList(ByRef vntRslCmtCd As Variant, _
                                 ByRef vntRslCmtName As Variant, _
                                 Optional ByRef vntEntryOk As Variant _
                                ) As Long
    
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRslCmtCd         As OraField         '結果コメントコード
    Dim objRslCmtName       As OraField         '結果コメント名
    Dim objEntryOk          As OraField         '入力完了フラグ
    
    Dim vntArrRslCmtCd()    As Variant          '結果コメントコードの配列
    Dim vntArrRslCmtName()  As Variant          '結果コメント名の配列
    Dim vntArrEntryOk()     As Variant          '入力完了フラグの配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRslCmtCd = Empty
    vntRslCmtName = Empty
    SelectRslCmtList = 0
    lngCount = 0
    
    '結果コメントテーブルよりレコードを取得
    strStmt = "SELECT RSLCMTCD, RSLCMTNAME, ENTRYOK " & vbLf & _
              "  FROM RSLCMT               " & vbLf & _
              " ORDER BY RSLCMTCD         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRslCmtCd = objFields("RSLCMTCD")
        Set objRslCmtName = objFields("RSLCMTNAME")
        Set objEntryOk = objFields("ENTRYOK")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRslCmtCd(lngCount)
            ReDim Preserve vntArrRslCmtName(lngCount)
            ReDim Preserve vntArrEntryOk(lngCount)
            vntArrRslCmtCd(lngCount) = objRslCmtCd.Value & ""
            vntArrRslCmtName(lngCount) = objRslCmtName.Value & ""
            vntArrEntryOk(lngCount) = objEntryOk.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntRslCmtCd = vntArrRslCmtCd
    vntRslCmtName = vntArrRslCmtName
    If IsMissing(vntEntryOk) = False Then
        vntEntryOk = vntArrEntryOk
    End If
    
    SelectRslCmtList = lngCount
        
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RslCmt.SelectRslCmtList"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 結果コメントデータを取得する
'
' 引数　　 : (In)     strRslCmtCd    結果コメントコード
' 　　　　   (Out)    vntRslCmtName  結果コメント名
' 　　　　   (Out)    vntEntryOk     入力完了フラグ
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectRslCmt(ByVal strRslCmtCd As String, _
                             ByRef vntRslCmtName As Variant, _
                             ByRef vntEntryOk As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objRslCmtName   As OraField         '結果コメント名
    Dim objEntryOk      As OraField         '入力完了フラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RslCmtCD", Trim(strRslCmtCd), ORAPARM_INPUT
    
    '検索条件を満たす結果コメントテーブルのレコードを取得
    strStmt = "SELECT RSLCMTNAME, ENTRYOK FROM RSLCMT WHERE RSLCMTCD = :RslCmtCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRslCmtName = objFields("RSLCMTNAME")
        Set objEntryOk = objFields("ENTRYOK")
    
        '戻り値の設定
        vntRslCmtName = objRslCmtName.Value
        vntEntryOk = objEntryOk.Value
        
        SelectRslCmt = True
        
    End If
    
    'バインド変数の削除
    objOraParam.Remove "RslCmtCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RslCmt.SelectRslCmt"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "RslCmt.SelectRslCmt", Err.Description
    
End Function

'## 2003.12.12 Add Function By T.Takagi@FSIT
'
' 機能　　 : 指定予約番号における指定汎用コード内グループの結果コメントを取得
'
' 引数　　 : (In)    lngRsvNo       予約番号
' 　　　　   (In)    strFreeCd      汎用コード
' 　　　　   (In)    vntGrpCd       グループコード
' 　　　　   (In)    vntGrpName     グループ名
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
' 　　　　   (In)    vntConsults    受診フラグ(値があれば依頼あり)
' 　　　　   (In)    vntRslCmtCd    結果コメントコード
'## 2004.01.01 Add End
' 　　　　   (In)    vntRslCmtName  結果コメント名
'
' 戻り値　 : レコード件数
'
' 備考　　 : 受診セット変更画面専用
'
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
'Public Function SelectRslCmtListForChangeSet(
'    ByVal lngRsvNo As Long,
'    ByVal strFreeCd As String,
'    Optional ByRef vntGrpCd As Variant,
'    Optional ByRef vntGrpName As Variant,
'    Optional ByRef vntRslCmtName As Variant
') As Long
Public Function SelectRslCmtListForChangeSet( _
    ByVal lngRsvNo As Long, _
    ByVal strFreeCd As String, _
    Optional ByRef vntGrpCd As Variant, _
    Optional ByRef vntGrpName As Variant, _
    Optional ByRef vntConsults As Variant, _
    Optional ByRef vntRslCmtCd As Variant, _
    Optional ByRef vntRslCmtName As Variant _
) As Long
'## 2004.01.01 Add End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objGrpCd            As OraField         'グループコード
    Dim objGrpName          As OraField         'グループ名
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
    Dim objItemCd           As OraField         '検査項目コード
    Dim objRslCmtCd         As OraField         '結果コメントコード
'## 2004.01.01 Add End
    Dim objRslCmtName       As OraField         '結果コメント名

    Dim vntArrGrpCd()       As Variant          'グループコード
    Dim vntArrGrpName()     As Variant          'グループ名
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
    Dim vntArrConsults()    As Variant          '受診フラグ
    Dim vntArrRslCmtCd()    As Variant          '結果コメントコード
'## 2004.01.01 Add End
    Dim vntArrRslCmtName()  As Variant          '結果コメント名
    Dim lngCount            As Long             'レコード数

'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
    Dim strPrevGrpCd        As String           '現レコードのグループコード
    Dim vntEditGrpCd        As Variant          '編集済み結果コメントコードの配列
    Dim blnEdit             As Boolean          '編集済みフラグ
    Dim i                   As Long             'インデックス
'## 2004.01.01 Add End

    '初期値
    If Not IsMissing(vntGrpCd) Then vntGrpCd = Empty
    If Not IsMissing(vntGrpName) Then vntGrpName = Empty
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
    If Not IsMissing(vntConsults) Then vntConsults = Empty
    If Not IsMissing(vntRslCmtCd) Then vntRslCmtCd = Empty
'## 2004.01.01 Add End
    If Not IsMissing(vntRslCmtName) Then vntRslCmtName = Empty
    lngCount = 0

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FREECD", strFreeCd & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2

'## 2003.12.23 Mod by T.Takagi@FSIT
'    strStmt = "SELECT DISTINCT                             " & vbLf & _
'              "       GRP_P.GRPCD,   GRP_P.GRPNAME,        " & vbLf & _
'              "       RSL.RSLCMTCD2, RSLCMT.RSLCMTNAME     " & vbLf & _
'              "  FROM RSLCMT, RSL, GRP_I, GRP_P, FREE      " & vbLf & _
'              " WHERE FREE.FREECD LIKE :FREECD             " & vbLf & _
'              "   AND FREE.FREEFIELD1 = GRP_P.GRPCD        " & vbLf & _
'              "   AND GRP_P.GRPCD     = GRP_I.GRPCD(+)     " & vbLf & _
'              "   AND :RSVNO          = RSL.RSVNO(+)       " & vbLf & _
'              "   AND GRP_I.ITEMCD    = RSL.ITEMCD(+)      " & vbLf & _
'              "   AND GRP_I.SUFFIX    = RSL.SUFFIX(+)      " & vbLf & _
'              "   AND RSL.RSLCMTCD2   = RSLCMT.RSLCMTCD(+) "
'## 2004.01.01 Mod By T.Takagi 依頼＆コメントコード取得
'    strStmt = "SELECT DISTINCT                             " & vbLf & _
'              "       GRP_P.GRPCD,   GRP_P.GRPNAME,        " & vbLf & _
'              "       RSL.RSLCMTCD2, RSLCMT.RSLCMTNAME     " & vbLf & _
'              "  FROM RSLCMT, RSL, GRP_R, GRP_P, FREE      " & vbLf & _
'              " WHERE FREE.FREECD LIKE :FREECD             " & vbLf & _
'              "   AND FREE.FREEFIELD1 = GRP_P.GRPCD        " & vbLf & _
'              "   AND GRP_P.GRPCD     = GRP_R.GRPCD(+)     " & vbLf & _
'              "   AND :RSVNO          = RSL.RSVNO(+)       " & vbLf & _
'              "   AND GRP_R.ITEMCD    = RSL.ITEMCD(+)      " & vbLf & _
'              "   AND RSL.RSLCMTCD2   = RSLCMT.RSLCMTCD(+) "
    strStmt = " SELECT GRP_P.GRPCD,   GRP_P.GRPNAME,            " & vbLf & _
              "        RSL.ITEMCD,    RSL.SUFFIX,               " & vbLf & _
              "        RSL.RSLCMTCD2, RSLCMT.RSLCMTNAME         " & vbLf & _
              "   FROM RSLCMT, RSL, GRP_R, GRP_P,               " & vbLf & _
              "        ( SELECT DISTINCT FREEFIELD1 GRPCD       " & vbLf & _
              "            FROM FREE                            " & vbLf & _
              "           WHERE FREECD LIKE :FREECD             " & vbLf & _
              "             AND FREEFIELD1 IS NOT NULL          " & vbLf & _
              "        ) CHGSETGRP                              " & vbLf & _
              "  WHERE CHGSETGRP.GRPCD = GRP_P.GRPCD            " & vbLf & _
              "    AND GRP_P.GRPCD     = GRP_R.GRPCD(+)         " & vbLf & _
              "    AND :RSVNO          = RSL.RSVNO(+)           " & vbLf & _
              "    AND GRP_R.ITEMCD    = RSL.ITEMCD(+)          " & vbLf & _
              "    AND RSL.RSLCMTCD2   = RSLCMT.RSLCMTCD(+)     " & vbLf & _
              "  ORDER BY GRP_P.GRPCD, GRP_R.ITEMCD, RSL.SUFFIX "
'## 2004.01.01 Mod End
'## 2003.12.23 Mod End

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
        Set objItemCd = objFields("ITEMCD")
        Set objRslCmtCd = objFields("RSLCMTCD2")
'## 2004.01.01 Add End
        Set objRslCmtName = objFields("RSLCMTNAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
'## 2004.01.01 Mod By T.Takagi 依頼＆コメントコード取得
'            ReDim Preserve vntArrGrpCd(lngCount)
'            ReDim Preserve vntArrGrpName(lngCount)
'            ReDim Preserve vntArrRslCmtName(lngCount)
'            vntArrGrpCd(lngCount) = objGrpCd.Value & ""
'            vntArrGrpName(lngCount) = objGrpName.Value & ""
'            vntArrRslCmtName(lngCount) = objRslCmtName.Value & ""
'            lngCount = lngCount + 1
           
            '直前レコードとグループが異なった時点で空の配列を作成
            If objGrpCd.Value & "" <> strPrevGrpCd Then
                ReDim Preserve vntArrGrpCd(lngCount)
                ReDim Preserve vntArrGrpName(lngCount)
                ReDim Preserve vntArrConsults(lngCount)
                ReDim Preserve vntArrRslCmtCd(lngCount)
                ReDim Preserve vntArrRslCmtName(lngCount)
                lngCount = lngCount + 1
            End If

            'グループコード、名称は常に編集
            vntArrGrpCd(lngCount - 1) = objGrpCd.Value & ""
            vntArrGrpName(lngCount - 1) = objGrpName.Value & ""
        
            '検査結果テーブルの検査項目コードが１つでもあれば受診対象とする
            If Not IsNull(objItemCd.Value) Then
                vntArrConsults(lngCount - 1) = "1"
            End If
        
            '結果コメントコードが存在する場合はその内容をスタックする
            If Not IsNull(objRslCmtCd.Value) Then
                
                'すでに何らかが編集されている場合
                If vntArrRslCmtCd(lngCount - 1) <> "" Then
                
                    '編集済み結果コメントコードを配列化する
                    vntEditGrpCd = Split(vntArrRslCmtCd(lngCount - 1), Chr(1))

                    '今から編集するコードがすでに存在するかをチェック
                    blnEdit = False
                    For i = 0 To UBound(vntEditGrpCd)
                        If vntEditGrpCd(i) = objRslCmtCd.Value Then
                            blnEdit = True
                            Exit For
                        End If
                    Next i

                    '未編集であれば追加
                    If Not blnEdit Then
                        vntArrRslCmtCd(lngCount - 1) = vntArrRslCmtCd(lngCount - 1) & Chr(1) & objRslCmtCd.Value
                        vntArrRslCmtName(lngCount - 1) = vntArrRslCmtName(lngCount - 1) & Chr(1) & objRslCmtName.Value
                    End If
                    
                '初めて追加する場合はそのまま編集
                Else
                    vntArrRslCmtCd(lngCount - 1) = objRslCmtCd.Value & ""
                    vntArrRslCmtName(lngCount - 1) = objRslCmtName.Value & ""
                End If
            End If
            
            '現レコードのグループコードを退避
            strPrevGrpCd = objGrpCd.Value
'## 2004.01.01 Mod End
            
            objOraDyna.MoveNext
        Loop

        Set objGrpCd = Nothing
        Set objGrpName = Nothing
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
        Set objItemCd = Nothing
        Set objRslCmtCd = Nothing
'## 2004.01.01 Add End
        Set objRslCmtName = Nothing
        Set objFields = Nothing

        '戻り値の設定
        If Not IsMissing(vntGrpCd) Then vntGrpCd = vntArrGrpCd
        If Not IsMissing(vntGrpName) Then vntGrpName = vntArrGrpName
'## 2004.01.01 Add By T.Takagi 依頼＆コメントコード取得
        If Not IsMissing(vntConsults) Then vntConsults = vntArrConsults
        If Not IsMissing(vntRslCmtCd) Then vntRslCmtCd = vntArrRslCmtCd
'## 2004.01.01 Add End
        If Not IsMissing(vntRslCmtName) Then vntRslCmtName = vntArrRslCmtName

    End If

    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Set objOraParam = Nothing

    '戻り値の設定
    SelectRslCmtListForChangeSet = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectRslCmtListForChangeSet = -1

    'イベントログ書き込み
    WriteErrorLog "RslCmrSelectRslCmtListForChangeSet"

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
' 機能　　 : 結果コメントテーブルレコードを登録する
'
' 引数　　 : (In)    strMode         登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strRslCmtCd     結果コメントコード
' 　　　　   (In)    vntRslCmtName   結果コメント名
' 　　　　   (In)    vntEntryOk      入力完了フラグ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistRslCmt(ByVal strMode As String, _
                             ByVal strRslCmtCd As String, _
                             ByVal strRslCmtName As String, _
                             ByVal intEntryOk As Integer) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RslCmtCD", Trim(strRslCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RslCmtNAME", Trim(strRslCmtName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EntryOk", Trim(intEntryOk), ORAPARM_INPUT, ORATYPE_NUMBER

    Do
        '結果コメントテーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE RSLCMT " & _
                      "   SET RSLCMTNAME = :RslCmtNAME," & _
                      "       ENTRYOK    = :EntryOk" & _
                      " WHERE RSLCMTCD   = :RslCmtCD"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす結果コメントテーブルのレコードを取得
        strStmt = "SELECT RSLCMTCD FROM RSLCMT WHERE RSLCMTCD = :RslCmtCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO RSLCMT (RSLCMTCD, RSLCMTNAME, ENTRYOK) VALUES (:RslCmtCD, :RslCmtNAME, :EntryOk)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    objOraParam.Remove "RslCmtCD"
    objOraParam.Remove "RslCmtNAME"
    objOraParam.Remove "EntryOk"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistRslCmt = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RslCmt.RegistRslCmt"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistRslCmt = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "RslCmt.RegistRslCmt", Err.Description

End Function

'
' 機能　　 : 結果コメントテーブルレコードを削除する
'
' 引数　　 : (In)    strRslCmtCd    結果コメントコード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteRslCmt(ByVal strRslCmtCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RslCmtCD", Trim(strRslCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '結果コメントテーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE RSLCMT WHERE RSLCMTCD = :RslCmtCD"
    
    'バインド変数の削除
    objOraParam.Remove "RslCmtCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteRslCmt = True

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RslCmt.DeleteRslCmt"

    DeleteRslCmt = False

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "RslCmt.DeleteRslCmt", Err.Description

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
