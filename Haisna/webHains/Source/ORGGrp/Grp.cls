VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Grp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト

Private Const DUMMY_SUFFIX  As String = ""      '検査項目テーブル以外のサフィックスの値(ダミー)

'
' 機能　　 : 検索条件を満たすグループの一覧を取得する
'
' 引数　　 : (In)     vntGrpDiv         検索グループ区分
' 　　　　 : (Out)    vntGrpCd          グループコード
' 　　　　 : (Out)    vntGrpName        グループ名
' 　　　　 : (In/Out) vntClassCd        検査分類コード（省略可）
' 　　　　 : (Out)    vntPrice1         単価１（省略可）
' 　　　　 : (Out)    vntPrice2         単価２（省略可）
' 　　　　 : (Out)    vntClassName      検査分類名（省略可）
' 　　　　 : (In)     vntNoDataFound    TRUE:検査項目なしでも索引する
' 　　　　 : (Out)    vntSystemGrp      1:システムで使用するグループ
' 　　　　 : (In)     vntOmitSystemGrp  TRUE:システムで使用するグループは除外する。
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrp_IList_GrpDiv(ByVal vntGrpDiv As Variant, _
                                       ByRef vntGrpCd As Variant, _
                                       ByRef vntGrpName As Variant, _
                                       Optional ByRef vntClassCd As Variant, _
                                       Optional ByRef vntPrice1 As Variant, _
                                       Optional ByRef vntPrice2 As Variant, _
                                       Optional ByRef vntClassName As Variant, _
                                       Optional ByVal vntNoDataFound As Variant, _
                                       Optional ByRef vntSystemGrp As Variant, _
                                       Optional ByVal vntOmitSystemGrp As Variant _
                                       ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objGrpDiv           As OraField         'グループ区分
    Dim objGrpCd            As OraField         'グループコード
    Dim objGrpName          As OraField         'グループ名
    Dim objClassCd          As OraField         '分類コード
    Dim objClassName        As OraField         '分類名
    Dim objPrice1           As OraField         '単価１
    Dim objPrice2           As OraField         '単価２
    
    Dim vntArrGrpDiv()      As Variant          'グループ区分の配列
    Dim vntArrGrpCd()       As Variant          'グループコードの配列
    Dim vntArrGrpName()     As Variant          'グループ名の配列
    Dim vntArrClassCd()     As Variant          '分類コードの配列
    Dim vntArrClassName()   As Variant          '分類名の配列
    Dim vntArrPrice1()      As Variant          '単価１の配列
    Dim vntArrPrice2()      As Variant          '単価２の配列
    Dim lngCount            As Long             'レコード数
    
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
    Dim objSystemGrp        As OraField         'システム制御用グループ
    Dim vntArrSystemGrp()   As Variant          'システム制御用グループの配列
'### 2003.2.17 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    Select Case vntGrpDiv
        Case GRPDIV_R, GRPDIV_I
        Case Else
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
        
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPDIV", Trim(vntGrpDiv), ORAPARM_INPUT
    
    '検索条件を満たすグループテーブルのレコードを取得
'### 2003.2.17 Updated by Ishihara@FSIT システム制御用グループ追加
'    strStmt = "SELECT GP.GRPDIV,    GP.GRPCD,   GP.GRPNAME, GP.CLASSCD, " & vbLf & _
              "       GP.PRICE1,    GP.PRICE2,  IT.CLASSNAME            " & vbLf & _
              "  FROM ITEMCLASS IT, GRP_P GP                            " & vbLf & _
              " WHERE GP.GRPDIV  = :GRPDIV                              " & vbLf & _
              "   AND GP.CLASSCD = IT.CLASSCD                           "
'### 2003.11.22 Deleted by Ishihara@FSIT 聖路加不要項目削除
'    strStmt = "SELECT GP.GRPDIV,    GP.GRPCD,   GP.GRPNAME, GP.CLASSCD, " & vbLf & _
              "       GP.PRICE1,    GP.PRICE2,  IT.CLASSNAME, GP.SYSTEMGRP " & vbLf & _
              "  FROM ITEMCLASS IT, GRP_P GP                            " & vbLf & _
              " WHERE GP.GRPDIV  = :GRPDIV                              " & vbLf & _
              "   AND GP.CLASSCD = IT.CLASSCD                           "
    strStmt = "SELECT GP.GRPDIV,    GP.GRPCD,   GP.GRPNAME, GP.CLASSCD, " & vbLf & _
              "       IT.CLASSNAME, GP.SYSTEMGRP " & vbLf & _
              "  FROM ITEMCLASS IT, GRP_P GP                            " & vbLf & _
              " WHERE GP.GRPDIV  = :GRPDIV                              " & vbLf & _
              "   AND GP.CLASSCD = IT.CLASSCD                           "
'### 2003.11.22 Deleted End
'### 2003.2.17 Updated End
    
'### 2003.2.17 Updated by Ishihara@FSIT システム制御用グループ非表示モード追加
    If IsMissing(vntOmitSystemGrp) = False Then
        If vntOmitSystemGrp = True Then
            strStmt = strStmt & _
                        " AND GP.SYSTEMGRP IS NULL" & vbLf
        End If
    End If
'### 2003.2.17 Updated End
    
    '検査分類コードが指定されている、かつ空白でない場合
    If IsMissing(vntClassCd) = False Then
        If Trim(vntClassCd) <> "" Then
            objOraParam.Add "CLASSCD", Trim(vntClassCd), ORAPARM_INPUT
            strStmt = strStmt & vbLf & _
                  "   AND GP.CLASSCD = :CLASSCD                             " & vbLf
        End If
    End If
    
    '依頼項目指定、かつアイテムなし検索が指定されていない場合
    If (vntGrpDiv = GRPDIV_R) And (IsMissing(vntNoDataFound)) Then
        strStmt = strStmt & vbLf & _
              "   AND EXISTS (SELECT GR.ITEMCD                          " & vbLf & _
              "                 FROM GRP_R GR                           " & vbLf & _
              "                WHERE GR.GRPCD = GP.GRPCD)               "
    End If
    
    '検査項目指定、かつアイテムなし検索が指定されていない場合
    If (vntGrpDiv = GRPDIV_I) And (IsMissing(vntNoDataFound)) Then
        strStmt = strStmt & vbLf & _
              "   AND EXISTS (SELECT GI.ITEMCD                          " & vbLf & _
              "                 FROM GRP_I GI                           " & vbLf & _
              "                WHERE GI.GRPCD = GP.GRPCD)               "
    End If
    strStmt = strStmt & vbLf & _
              " ORDER BY GP.GRPDIV, GP.GRPCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpDiv = objFields("GRPDIV")
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        Set objClassCd = objFields("CLASSCD")
        Set objClassName = objFields("CLASSNAME")
'### 2003.11.22 Deleted by Ishihara@FSIT 聖路加不要項目削除
'        Set objPrice1 = objFields("PRICE1")
'        Set objPrice2 = objFields("PRICE2")
'### 2003.11.22 Deleted End
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
        Set objSystemGrp = objFields("SYSTEMGRP")
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGrpDiv(lngCount)
            ReDim Preserve vntArrGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            ReDim Preserve vntArrClassCd(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            ReDim Preserve vntArrPrice1(lngCount)
            ReDim Preserve vntArrPrice2(lngCount)
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
            ReDim Preserve vntArrSystemGrp(lngCount)
'### 2003.2.17 Added End
            vntArrGrpDiv(lngCount) = objGrpDiv.Value & ""
            vntArrGrpCd(lngCount) = objGrpCd.Value & ""
            vntArrGrpName(lngCount) = objGrpName.Value & ""
            vntArrClassCd(lngCount) = objClassCd.Value & ""
            vntArrClassName(lngCount) = objClassName.Value & ""
'### 2003.11.22 Deleted by Ishihara@FSIT 聖路加不要項目削除
'            vntArrPrice1(lngCount) = objPrice1.Value & ""
'            vntArrPrice2(lngCount) = objPrice2.Value & ""
            vntArrPrice1(lngCount) = ""
            vntArrPrice2(lngCount) = ""
'### 2003.11.22 Deleted End
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
            vntArrSystemGrp(lngCount) = objSystemGrp.Value & ""
'### 2003.2.17 Added End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntGrpDiv = vntArrGrpDiv
    vntGrpCd = vntArrGrpCd
    vntGrpName = vntArrGrpName
    
    If Not IsMissing(vntClassCd) Then   '引数「検査分類コード」が定義されている場合
        vntClassCd = vntArrClassCd
    End If
    
'### 2003.11.22 Deleted by Ishihara@FSIT 聖路加不要項目削除
    If Not IsMissing(vntPrice1) Then    '引数「単価１」が定義されている場合
        vntPrice1 = vntArrPrice1
    End If
    
    If Not IsMissing(vntPrice2) Then    '引数「単価２」が定義されている場合
        vntPrice2 = vntArrPrice2
    End If
'### 2003.11.22 Deleted End
    
    If Not IsMissing(vntClassName) Then '引数「分類名」が定義されている場合
        vntClassName = vntArrClassName
    End If
    
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
    If Not IsMissing(vntSystemGrp) Then '引数「システム制御用グループ」が定義されている場合
        vntSystemGrp = vntArrSystemGrp
    End If
'### 2003.2.17 Added End
    
    SelectGrp_IList_GrpDiv = lngCount
    
    'キー値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_IList_GrpDiv"
    
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
' 機能　　 : 検索条件を満たすグループの基本情報を取得する
'
' 引数　　 : (In)     strGrpCd      グループコード
' 　　　　 : (Out)    vntGrpName    グループ名
' 　　　　 : (Out)    vntPrice1     単価１
' 　　　　 : (Out)    vntPrice2     単価２
' 　　　　 : (Out)    vntClassCd    検査分類コード
' 　　　　 : (Out)    vntGrpDiv     グループ区分
' 　　　　 : (Out)    vntSearchChar ガイド検索用文字列
' 　　　　 : (Out)    vntSystemGrp  システム制御グループ
' 　　　　 : (Out)    vntOldSetCd   旧セットコード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectGrp_P( _
    ByVal strGrpCd As String, _
    Optional ByRef vntGrpName As Variant, _
    Optional ByRef vntPrice1 As Variant, _
    Optional ByRef vntPrice2 As Variant, _
    Optional ByRef vntClassCd As Variant, _
    Optional ByRef vntGrpDiv As Variant, _
    Optional ByRef vntSearchChar As Variant, _
    Optional ByRef vntSystemGrp As Variant, _
    Optional ByRef vntOldSetCd As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objGrpName      As OraField         'グループ名
    Dim objClassCd      As OraField         '検査分類コード
    Dim objGrpDiv       As OraField         'グループ区分
    Dim objSearchChar   As OraField         'ガイド検査用文字列
    Dim objSystemGrp    As OraField         'システム制御グループ
    Dim objOldSetCd     As OraField         '旧セットコード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntGrpName = Empty
    vntPrice1 = Empty
    vntPrice2 = Empty
    vntClassCd = Empty
    vntGrpDiv = Empty
    vntSearchChar = Empty
    vntSystemGrp = Empty
    vntOldSetCd = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たすグループテーブルのレコードを取得
    strStmt = "SELECT GRPNAME,               " & vbLf & _
              "       CLASSCD,               " & vbLf & _
              "       GRPDIV,                " & vbLf & _
              "       SEARCHCHAR,            " & vbLf & _
              "       SYSTEMGRP,             " & vbLf & _
              "       OLDSETCD               " & vbLf & _
              "  FROM GRP_P                  " & vbLf & _
              " WHERE GRPCD = :GRPCD         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpName = objFields("GRPNAME")
        Set objClassCd = objFields("CLASSCD")
        Set objGrpDiv = objFields("GRPDIV")
        Set objSearchChar = objFields("SEARCHCHAR")
        Set objSystemGrp = objFields("SYSTEMGRP")
        Set objOldSetCd = objFields("OLDSETCD")
    
        '戻り値の設定
        vntGrpName = objGrpName.Value
        vntPrice1 = 0
        vntPrice2 = 0
        vntClassCd = objClassCd.Value & ""
        vntGrpDiv = CLng(objGrpDiv.Value & "")
        vntSearchChar = objSearchChar.Value & ""
        vntSystemGrp = objSystemGrp.Value & ""
        vntOldSetCd = objOldSetCd.Value & ""
        
        SelectGrp_P = True
        
    End If
    
    'バインド変数の削除
    objOraParam.Remove "GRPCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    SelectGrp_P = False
    
    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_P"
    
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
' 機能　　 : 検索条件を満たすグループ名の一覧を取得する
'
' 引数　　 : (In)     vntGrpDivKey      グループ区分キー
' 　　　　 : (In)     vntClassCdKey     検査分類コードキー
' 　　　　 : (In)     vntSearchCharKey  ガイド検索用文字列キー
' 　　　　 : (Out)    vntGrpCd          グループコード
' 　　　　 : (Out)    vntSuffix         サフィックス(ダミー：空白固定)
' 　　　　 : (Out)    vntGrpName        グループ名
' 　　　　 : (In)     vntOmitSystemGrp  TRUE:システムで使用するグループは除外する。
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrp_pList(ByVal vntGrpDivKey As Variant, _
                                ByVal vntClassCdKey As Variant, _
                                ByVal vntSearchCharKey As Variant, _
                                ByRef vntGrpCd As Variant, _
                                ByRef vntSuffix As Variant, _
                                ByRef vntGrpName As Variant, _
                                Optional ByVal vntOmitSystemGrp As Variant _
                               ) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim strSearchCharW      As String           '検索文字(全角)
    Dim strSearchCharN      As String           '検索文字(半角)
       
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objGrpCd            As OraField         'グループコード
    Dim objGrpName          As OraField         'グループ名
    
    Dim vntArrGrpCd()       As Variant          'グループコードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrGrpName()     As Variant          'グループ名の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntGrpCd = Empty
    vntSuffix = Empty
    vntGrpName = Empty
    
    '問診項目表示有無条件が設定されていない場合はエラー
    If Not ((vntGrpDivKey = GRPDIV_R) Or (vntGrpDivKey = GRPDIV_I)) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPDIV", vntGrpDivKey, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CLASSCD", Trim(vntClassCdKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHARW", Trim(strSearchCharW), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHARN", Trim(strSearchCharN), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = "SELECT GRPCD, GRPNAME " & vbLf & _
              "  FROM GRP_P "
              
    'WHERE句の編集
    strStmt = strStmt & vbLf & _
              " WHERE "
    
    'グループ区分による条件編集
    strStmt = strStmt & "GRPDIV = :GRPDIV "
    
'### 2003.2.17 Updated by Ishihara@FSIT システム制御用グループ非表示モード追加
    If IsMissing(vntOmitSystemGrp) = False Then
        If vntOmitSystemGrp = True Then
            strStmt = strStmt & _
                        " AND GRP_P.SYSTEMGRP IS NULL" & vbLf
        End If
    End If
'### 2003.2.17 Updated End
    
    '検査分類コードキーの編集
    If Not (vntClassCdKey = "") Then
        '条件節はANDで連結
        strStmt = strStmt & vbLf & _
                  "   AND "
        '検索キー値を編集
        strStmt = strStmt & "CLASSCD = :CLASSCD "
    End If
    
    'ガイド検索用文字列キーの編集
    If Not (vntSearchCharKey = "") Then
        '全角・半角両方に対応するよう変換
        strSearchCharW = StrConv(vntSearchCharKey, vbWide)
        strSearchCharN = StrConv(vntSearchCharKey, vbNarrow)
        'キー値の再設定
        objOraParam("SEARCHCHARW").Value = Trim(strSearchCharW)
        objOraParam("SEARCHCHARN").Value = Trim(strSearchCharN)
        '条件節はANDで連結
        strStmt = strStmt & vbLf & _
                  "   AND "
        '検索キー値を編集
        strStmt = strStmt & "SEARCHCHAR IN ( :SEARCHCHARW, :SEARCHCHARN ) "
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY GRPCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGrpCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            vntArrGrpCd(lngCount) = objGrpCd.Value & ""
            vntArrSuffix(lngCount) = DUMMY_SUFFIX
            vntArrGrpName(lngCount) = objGrpName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntGrpCd = vntArrGrpCd
    vntSuffix = vntArrSuffix
    vntGrpName = vntArrGrpName
    SelectGrp_pList = lngCount
        
    Set objOraDyna = Nothing
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Item.SelectGrp_pList"
    
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
' 機能　　 : 検索条件を満たす検査項目名の一覧を取得する
'
' 引数　　 : (In)     vntGrpCd          検査グループコード
' 　　　　 : (Out)    vntItemCd         検査項目コード
' 　　　　 : (Out)    vntSuffix         サフィックス
' 　　　　 : (Out)    vntItemName       検査項目名称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrpItem_cList(ByVal vntGrpCd As Variant, _
                                    ByRef vntItemCd As Variant, _
                                    ByRef vntSuffix As Variant, _
                                    ByRef vntItemName As Variant _
                                   ) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名称
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名称の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemCd = Empty
    vntSuffix = Empty
    vntItemName = Empty
    
    '対象検査グループコードが設定されていない場合はエラー
    If IsEmpty(vntGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(vntGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす検査項目テーブルのレコードを取得
    strStmt = "SELECT GI.ITEMCD, GI.SUFFIX, IC.ITEMNAME " & vbLf & _
              "  FROM GRP_I GI, ITEM_C IC               " & _
              " WHERE GI.GRPCD  = :GRPCD                " & _
              "   AND GI.ITEMCD = IC.ITEMCD             " & vbLf & _
              "   AND GI.SUFFIX = IC.SUFFIX             " & vbLf & _
              " ORDER BY GI.SEQ                         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    
    SelectGrpItem_cList = lngCount
        
    Set objOraDyna = Nothing
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Item.SelectGrpItem_cList"
    
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
' 機能　　 : グループ内の全検査項目を取得する（検査項目）
'
' 引数　　 : (In)     strGrpCd        グループコード
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名
' 　　　　 : (Out)    vntResultType   結果タイプ（省略可）
' 　　　　 : (Out)    vntItemType     項目タイプ（省略可）
' 　　　　 : (Out)    vntStcItemCd    文章参照用項目コード（省略可）
' 　　　　 : (Out)    vntClassName    検査分類名称（省略可）
' 　　　　 : (Out)    vntSeq          表示順番（省略可）
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrp_I_ItemList(ByVal strGrpCd As String, _
                                     ByRef vntItemCd As Variant, _
                                     ByRef vntSuffix As Variant, _
                                     ByRef vntItemName As Variant, _
                                     Optional ByRef vntResultType As Variant, _
                                     Optional ByRef vntItemType As Variant, _
                                     Optional ByRef vntStcItemCd As Variant, _
                                     Optional ByRef vntClassName As Variant, _
                                     Optional ByRef vntSeq As Variant _
                                    ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objClassName        As OraField         '検査分類名称
    Dim objSeq              As OraField         '表示順番
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrClassName()   As Variant          '検査分類名称の配列
    Dim vntArrSeq()         As Variant          '表示順番の配列
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'グループコードが設定されていない場合はエラー
    If IsEmpty(strGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす受診歴情報のレコードを取得
    strStmt = "SELECT GI.ITEMCD, GI.SUFFIX, IC.ITEMNAME, IC.RESULTTYPE, " & vbLf & _
              "       IC.ITEMTYPE, IC.STCITEMCD, CS.CLASSNAME, GI.SEQ   " & vbLf & _
              "  FROM ITEMCLASS CS, GRP_P GP, GRP_I GI,                 " & vbLf & _
              "       ITEM_C IC, ITEM_P IP                              " & vbLf & _
              " WHERE GP.GRPCD   = :GRPCD                               " & vbLf & _
              "   AND GP.GRPCD   = GI.GRPCD                             " & vbLf & _
              "   AND GI.ITEMCD  = IC.ITEMCD                            " & vbLf & _
              "   AND GI.SUFFIX  = IC.SUFFIX                            " & vbLf & _
              "   AND IP.ITEMCD  = IC.ITEMCD                            " & vbLf & _
              "   AND IP.CLASSCD = CS.CLASSCD                           " & vbLf & _
              " ORDER BY GI.SEQ"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objClassName = objFields("CLASSNAME")
        Set objSeq = objFields("SEQ")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            vntArrResultType(lngCount) = objResultType.Value
            vntArrItemType(lngCount) = objItemType.Value
            vntArrStcItemCd(lngCount) = objStcItemCd.Value & ""
            vntArrClassName(lngCount) = objClassName.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    If Not IsMissing(vntResultType) Then
        vntResultType = vntArrResultType
    End If
    If Not IsMissing(vntItemType) Then
        vntItemType = vntArrItemType
    End If
    If Not IsMissing(vntStcItemCd) Then
        vntStcItemCd = vntArrStcItemCd
    End If
    If Not IsMissing(vntClassName) Then
        vntClassName = vntArrClassName
    End If
    If Not IsMissing(vntSeq) Then
        vntSeq = vntArrSeq
    End If
    
    SelectGrp_I_ItemList = lngCount
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_I_ItemList"
    
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
' 機能　　 : グループ内の全検査項および見出しコメントを取得する（検査項目）
'
' 引数　　 : (In)     strGrpCd        グループコード
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名
' 　　　　 : (Out)    vntResultType   結果タイプ（省略可）
' 　　　　 : (Out)    vntItemType     項目タイプ（省略可）
' 　　　　 : (Out)    vntStcItemCd    文章参照用項目コード（省略可）
' 　　　　 : (Out)    vntClassName    検査分類名称（省略可）
' 　　　　 : (Out)    vntSeq          表示順番（省略可）
'          : (Out)    vntrslCaption   見出し
'
'戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrp_I_ItemList_AddCaption(ByVal strGrpCd As String, _
                                                ByRef vntItemCd As Variant, _
                                                ByRef vntSuffix As Variant, _
                                                ByRef vntItemName As Variant, _
                                                Optional ByRef vntResultType As Variant, _
                                                Optional ByRef vntItemType As Variant, _
                                                Optional ByRef vntStcItemCd As Variant, _
                                                Optional ByRef vntClassName As Variant, _
                                                Optional ByRef vntSeq As Variant, _
                                                Optional ByRef vntrslCaption _
                                               ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objClassName        As OraField         '検査分類名称
    Dim objSeq              As OraField         '表示順番
    Dim objrslCaption       As OraField         '見出し
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrClassName()   As Variant          '検査分類名称の配列
    Dim vntArrSeq()         As Variant          '表示順番の配列
    Dim vntArrrslCaption()  As Variant          '見出しの配列
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'グループコードが設定されていない場合はエラー
    If IsEmpty(strGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '検索条件を満たす受診歴情報のレコードを取得
strStmt = "SELECT GRP_I.ITEMCD, GRP_I.SUFFIX,ITEM_C.ITEMNAME,         " & vbLf & _
          "       ITEM_C.RESULTTYPE, ITEM_C.STCITEMCD,ITEM_P.ITEMCD,  " & vbLf & _
          "       ITEM_C.ITEMTYPE, ITEMCLASS.CLASSNAME,             　" & vbLf & _
          "       GRP_I.SEQ, GRP_I.RSLCAPTION                         " & vbLf & _
          "  FROM ITEM_C, GRP_P, GRP_I, ITEM_P, ITEMCLASS             " & vbLf & _
          " WHERE GRP_P.GRPCD    = :GRPCD                             " & vbLf & _
          "   AND GRP_I.GRPCD    = GRP_P.GRPCD                        " & vbLf & _
          "   AND GRP_I.ITEMCD   = ITEM_C.ITEMCD(+)                   " & vbLf & _
          "   AND GRP_I.SUFFIX   = ITEM_C.SUFFIX(+)                   " & vbLf & _
          "   AND ITEM_C.ITEMCD  = ITEM_P.ITEMCD(+)                   " & vbLf & _
          "   AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD(+)               " & vbLf & _
          " ORDER BY GRP_I.SEQ"
          
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objClassName = objFields("CLASSNAME")
        Set objSeq = objFields("SEQ")
        Set objrslCaption = objFields("RSLCAPTION")
           
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrrslCaption(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            vntArrResultType(lngCount) = objResultType.Value
            vntArrItemType(lngCount) = objItemType.Value
            vntArrStcItemCd(lngCount) = objStcItemCd.Value & ""
            vntArrClassName(lngCount) = objClassName.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrrslCaption(lngCount) = objrslCaption.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    If Not IsMissing(vntResultType) Then
        vntResultType = vntArrResultType
    End If
    If Not IsMissing(vntItemType) Then
        vntItemType = vntArrItemType
    End If
    If Not IsMissing(vntStcItemCd) Then
        vntStcItemCd = vntArrStcItemCd
    End If
    If Not IsMissing(vntClassName) Then
        vntClassName = vntArrClassName
    End If
    If Not IsMissing(vntSeq) Then
        vntSeq = vntArrSeq
    End If
    If Not IsMissing(vntrslCaption) Then
        vntrslCaption = vntArrrslCaption
    End If
    
    SelectGrp_I_ItemList_AddCaption = lngCount
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_I_ItemList_AddCaption"
    
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
' 機能　　 : グループ内の全検査項目を取得する（依頼項目）
'
' 引数　　 : (In)     strGrpCd        グループコード
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntRequestName  依頼項目名
' 　　　　 : (Out)    vntClassName    検査分類名称（省略可）
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrp_R_ItemList(ByVal strGrpCd As String, _
                                     ByRef vntItemCd As Variant, _
                                     ByRef vntRequestName As Variant, _
                                     Optional ByRef vntClassName As Variant _
                                    ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objRequestName      As OraField         '依頼項目名
    Dim objClassName        As OraField         '検査分類名称
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrRequestName()    As Variant       '依頼項目名の配列
    Dim vntArrClassName()   As Variant          '検査分類名称の配列
    
    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'グループコードが設定されていない場合はエラー
    If IsEmpty(strGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす受診歴情報のレコードを取得
    strStmt = "SELECT GRP_R.ITEMCD, ITEM_P.REQUESTNAME, ITEMCLASS.CLASSNAME" & vbLf & _
              "  FROM ITEMCLASS, ITEM_P, GRP_R" & vbLf & _
              " WHERE GRP_R.GRPCD    = :GRPCD" & vbLf & _
              "   AND GRP_R.ITEMCD   = ITEM_P.ITEMCD" & vbLf & _
              "   AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD" & vbLf & _
              " ORDER BY GRP_R.ITEMCD"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objRequestName = objFields("REQUESTNAME")
        Set objClassName = objFields("CLASSNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrRequestName(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrRequestName(lngCount) = objRequestName.Value
            vntArrClassName(lngCount) = objClassName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntRequestName = vntArrRequestName
    If Not IsMissing(vntClassName) Then
        vntClassName = vntArrClassName
    End If
    
    SelectGrp_R_ItemList = lngCount
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_R_ItemList"
    
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
' 機能　　 : グループ内の全検査項目および初期値を取得する
'
' 引数　　 : (In)     strGrpCd        グループコード
' 　　　　 : (In)     dtmCslDate      受診日
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名
' 　　　　 : (Out)    vntResultType   結果タイプ
' 　　　　 : (Out)    vntItemType     項目タイプ
' 　　　　 : (Out)    vntDefResult    省略時検査結果
' 　　　　 : (Out)    vntStcItemCd    文章参照用項目コード
' 　　　　 : (Out)    vntDefShortStc  省略時文章略称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrp_I_ItemDefResultList(ByVal strGrpCd As String, _
                                              ByVal dtmCslDate As Date, _
                                              ByRef vntItemCd As Variant, _
                                              ByRef vntSuffix As Variant, _
                                              ByRef vntItemName As Variant, _
                                              ByRef vntResultType As Variant, _
                                              ByRef vntItemType As Variant, _
                                              ByRef vntDefResult As Variant, _
                                              ByRef vntStcItemCd As Variant, _
                                              ByRef vntDefShortStc As Variant _
                                             ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objDefResult        As OraField         '省略時検査結果
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objDefShortStc      As OraField         '省略時文章略称
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrDefResult()   As Variant          '省略時検査結果の配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrDefShortStc() As Variant          '省略時文章略称の配列
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'グループコードが設定されていない場合はエラー
    If IsEmpty(strGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDATE", Trim(dtmCslDate), ORAPARM_INPUT, ORATYPE_DATE
    
    '検索条件を満たす受診歴情報のレコードを取得
    strStmt = "SELECT GL.ITEMCD, GL.SUFFIX, GL.ITEMNAME, GL.RESULTTYPE, GL.ITEMTYPE," & vbLf & _
              "       GL.DEFRESULT, GL.STCITEMCD, SC.SHORTSTC                       " & vbLf & _
              "  FROM ( SELECT GI.ITEMCD, GI.SUFFIX, IC.ITEMNAME, IC.RESULTTYPE,    " & vbLf & _
              "                IC.ITEMTYPE, IH.DEFRESULT, IC.STCITEMCD              " & vbLf & _
              "           FROM GRP_P GP, GRP_I GI, ITEM_C IC, ITEM_H IH             " & vbLf & _
              "          WHERE GP.GRPCD  = :GRPCD                                   " & vbLf & _
              "            AND GP.GRPCD  = GI.GRPCD                                 " & vbLf & _
              "            AND GI.ITEMCD = IC.ITEMCD                                " & vbLf & _
              "            AND GI.SUFFIX = IC.SUFFIX                                " & vbLf & _
              "            AND IC.ITEMCD = IH.ITEMCD(+)                             " & vbLf & _
              "            AND IC.SUFFIX = IH.SUFFIX(+)                             " & vbLf & _
              "            AND :CSLDATE BETWEEN IH.STRDATE(+) AND IH.ENDDATE(+)     " & vbLf & _
              "       ) GL, SENTENCE SC                                             " & vbLf & _
              " WHERE GL.STCITEMCD = SC.ITEMCD(+)                                   " & vbLf & _
              "   AND GL.ITEMTYPE  = SC.ITEMTYPE(+)                                 " & vbLf & _
              "   AND GL.DEFRESULT = SC.STCCD(+)                                    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objDefResult = objFields("DEFRESULT")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objDefShortStc = objFields("SHORTSTC")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrDefResult(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrDefShortStc(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            vntArrResultType(lngCount) = objResultType.Value
            vntArrItemType(lngCount) = objItemType.Value
            vntArrDefResult(lngCount) = objDefResult.Value & ""
            vntArrStcItemCd(lngCount) = objStcItemCd.Value & ""
            vntArrDefShortStc(lngCount) = objDefShortStc.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    vntResultType = vntArrResultType
    vntItemType = vntArrItemType
    vntDefResult = vntArrDefResult
    vntStcItemCd = vntArrStcItemCd
    vntDefShortStc = vntArrDefShortStc
    
    SelectGrp_I_ItemDefResultList = lngCount
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_I_ItemDefResultList"
    
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
' 機能　　 : コースレコードを登録する（トランザクション対応）
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strGrpCd       グループコード
' 　　　　   (In)    strClassCd     検査分類コード
' 　　　　   (In)    strGrpName     グループ名
' 　　　　   (In)    lngPrice1      単価１
' 　　　　   (In)    lngPrice2      単価２
' 　　　　   (In)    intGrpDiv      グループ区分
' 　　　　   (In)    strSearchChar  ガイド検索用文字列
' 　　　　   (In)    strSystemGrp   システム制御用グループ
' 　　　　   (In)    intItemCount   更新検査項目数
' 　　　　   (In)    vntItemCd      検査項目コード
' 　　　　   (In)    vntSuffix      サフィックス
' 　　　　   (In)    vntSeq         表示順番
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :　コーステーブルとコース内項目テーブルを１回で登録しちゃうよ
'
Public Function RegistGrp_All(ByVal strMode As String, _
                               ByVal strGrpCd As String, _
                               ByVal strClassCd As String, _
                               ByVal strGrpName As String, _
                               ByVal lngPrice1 As Long, _
                               ByVal lngPrice2 As Long, _
                               ByVal intGrpDiv As Integer, _
                               ByVal strSearchChar As String, _
                               ByVal strSystemGrp As String, _
                               ByVal intItemCount As Integer, _
                               ByVal vntItemCd As Variant, _
                               ByVal vntSuffix As Variant, _
                               ByVal vntSeq As Variant, _
                               ByVal vntrslCaption As Variant) As Long

    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret         As Long             '関数戻り値
    
    Ret = INSERT_ERROR
    
    Do
        
        'グループテーブルの更新
        Ret = RegistGrp_p(strMode, _
                          strGrpCd, _
                          strClassCd, _
                          strGrpName, _
                          lngPrice1, _
                          lngPrice2, _
                          intGrpDiv, _
                          strSearchChar, _
                          strSystemGrp)

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        'グループ内項目テーブルの更新
        Ret = RegistGrp_Item(intGrpDiv, _
                             strGrpCd, _
                             intItemCount, _
                             vntItemCd, _
                             vntSuffix, _
                             vntSeq, _
                             vntrslCaption)
        
        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
        
        Exit Do
    Loop
 
    If Ret = INSERT_NORMAL Then
        mobjContext.SetComplete
    Else
        '異常終了ならRollBack
        mobjContext.SetAbort
    End If
 
    '戻り値の設定
    RegistGrp_All = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistGrp_All = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Grp.RegistGrp_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : コースレコードを登録する
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strGrpCd       グループコード
' 　　　　   (In)    strClassCd     検査分類コード
' 　　　　   (In)    strGrpName     グループ名
' 　　　　   (In)    lngPrice1      単価１
' 　　　　   (In)    lngPrice2      単価２
' 　　　　   (In)    intGrpDiv      グループ区分
' 　　　　   (In)    strSearchChar  ガイド検索用文字列
' 　　　　   (In)    strSystemGrp   システム制御用グループ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistGrp_p(ByVal strMode As String, _
                            ByVal strGrpCd As String, _
                            ByVal strClassCd As String, _
                            ByVal strGrpName As String, _
                            ByVal lngPrice1 As Long, _
                            ByVal lngPrice2 As Long, _
                            ByVal intGrpDiv As Integer, _
                            ByVal strSearchChar As String, _
                            ByVal strSystemGrp As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GrpCd", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ClassCd", Trim(strClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GrpName", Trim(strGrpName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.11.22 Deleted by Ishihara@FSIT 聖路加不要項目削除
'    objOraParam.Add "Price1", lngPrice1, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "Price2", lngPrice2, ORAPARM_INPUT, ORATYPE_NUMBER
'### 2003.11.22 Deleted End
    objOraParam.Add "GrpDiv", intGrpDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SearchChar", strSearchChar, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT システム制御グループフラグの追加
    objOraParam.Add "SystemGrp", strSystemGrp, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2002.11.10 Add End

    Do
        'コーステーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = ""
'### 2003.11.22 Modified by Ishihara@FSIT 聖路加不要項目削除
'            strStmt = strStmt & "UPDATE GRP_P"
'            strStmt = strStmt & "   SET ClassCd = :ClassCd, GrpName    = :GrpName,  "
'            strStmt = strStmt & "       Price1  = :Price1,  Price2     = :Price2, "
''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT システム制御グループフラグの追加
''            strStmt = strStmt & "       GrpDiv  = :GrpDiv,  SearchChar = :SearchChar"
'            strStmt = strStmt & "       GrpDiv  = :GrpDiv,  SearchChar = :SearchChar, SystemGrp = :SystemGrp"
''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT システム制御グループフラグの追加
'            strStmt = strStmt & " WHERE GrpCd = :GrpCd"

            strStmt = strStmt & "UPDATE GRP_P"
            strStmt = strStmt & "   SET ClassCd = :ClassCd, GrpName    = :GrpName,  "
            strStmt = strStmt & "       GrpDiv  = :GrpDiv,  SearchChar = :SearchChar, SystemGrp = :SystemGrp"
            strStmt = strStmt & " WHERE GrpCd = :GrpCd"
'### 2003.11.22 Modified End
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たすコーステーブルのレコードを取得
        strStmt = "SELECT GrpCd FROM GRP_P WHERE GrpCd = :GrpCd"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入不可
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '新規挿入
        strStmt = ""
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT システム制御グループフラグの追加
'        strStmt = strStmt & "INSERT INTO GRP_P (GrpCd, ClassCd, GrpName, Price1, Price2, GrpDiv, SearchChar)"
'        strStmt = strStmt & "           VALUES (:GrpCd, :ClassCd, :GrpName, :Price1, :Price2, :GrpDiv, :SearchChar)"
'### 2003.11.22 Modified by Ishihara@FSIT 聖路加不要項目削除
'        strStmt = strStmt & "INSERT INTO GRP_P (GrpCd, ClassCd, GrpName, Price1, Price2, GrpDiv, SearchChar, SystemGrp)"
'        strStmt = strStmt & "           VALUES (:GrpCd, :ClassCd, :GrpName, :Price1, :Price2, :GrpDiv, :SearchChar, :SystemGrp)"
        strStmt = strStmt & "INSERT INTO GRP_P (GrpCd, ClassCd, GrpName, GrpDiv, SearchChar, SystemGrp)"
        strStmt = strStmt & "           VALUES (:GrpCd, :ClassCd, :GrpName, :GrpDiv, :SearchChar, :SystemGrp)"
'### 2003.11.22 Modified End
'## 2002.11.10 Mod End
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistGrp_p = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistGrp_p = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Grp.RegistGrp_p"
    
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
' 機能　　 : グループ内受診項目を登録する
'
' 引数　　 : (In)    intGrpDiv      グループ区分（依頼 or 検査）
' 　　　　   (In)    strGrpCd       グループコード
' 　　　　   (In)    intItemCount   更新検査項目数
' 　　　　   (In)    vntItemCd      検査項目コード
' 　　　　   (In)    vntSuffix      サフィックス
' 　　　　   (In)    vntSeq         表示順番
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistGrp_Item(ByVal intGrpDiv As Integer, ByVal strGrpCd As String, _
                               ByVal intItemCount As Integer, _
                               ByVal vntItemCd As Variant, ByVal vntSuffix As Variant, _
                               ByVal vntSeq As Variant, ByVal vntrslCaption As Variant) As Long
                               
    Const LENGTH_GRP_I_RSLCAPTION As Long = 100

    Dim objOraParam   As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna    As OraDynaset       'ダイナセット
    Dim strStmt       As String           'SQLステートメント

    Dim objGrpCd      As OraParamArray    'グループコード
    Dim objItemCd     As OraParamArray    '検査項目コード
    Dim objSuffix     As OraParamArray    'サフィックス
    Dim objSeq        As OraParamArray    '表示順番
    Dim objrslCaption As OraParamArray    '見出し

    Dim i             As Integer
    Dim Ret           As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'グループ内検査項目レコードの削除
    If intGrpDiv = GRPDIV_R Then
        'グループ区分が依頼の場合
        mobjOraDb.ExecuteSQL "DELETE GRP_R WHERE GRPCD = :GRPCD"
    Else
        'グループ区分が検査の場合
        mobjOraDb.ExecuteSQL "DELETE GRP_I WHERE GRPCD = :GRPCD"
    End If
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "GRPCD"
        objOraParam.AddTable "GRPCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_GRP_P_GRPCD
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        
        'OraParameterオブジェクトの参照設定
        Set objGrpCd = objOraParam("GRPCD")
        Set objItemCd = objOraParam("ITEMCD")
        
        'グループ区分が検査項目の場合、更にバインド変数追加
        If intGrpDiv = GRPDIV_I Then
            
            objOraParam.AddTable "Suffix", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_C_SUFFIX
            objOraParam.AddTable "Seq", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_GRP_I_SEQ
            objOraParam.AddTable "RSLCAPTION", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_GRP_I_RSLCAPTION
            
            Set objSuffix = objOraParam("Suffix")
            Set objSeq = objOraParam("Seq")
            Set objrslCaption = objOraParam("RSLCAPTION")
        
        End If
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objGrpCd(i) = strGrpCd
            objItemCd(i) = vntItemCd(i)
            If intGrpDiv = GRPDIV_I Then
                objSuffix(i) = vntSuffix(i)
                objSeq(i) = vntSeq(i)
                objrslCaption(i) = vntrslCaption(i)
            End If
        Next i
       
        '新規挿入
        strStmt = ""
        
        If intGrpDiv = GRPDIV_R Then
            strStmt = strStmt & "INSERT INTO GRP_R (GRPCD, ITEMCD) VALUES (:GRPCD, :ITEMCD)"
        Else
            strStmt = strStmt & "INSERT INTO GRP_I (GRPCD, ITEMCD, SUFFIX, SEQ,RSLCAPTION)" & vbLf & _
                                "VALUES (:GRPCD, :ITEMCD, :SUFFIX, :SEQ,:RSLCAPTION)"
        End If
    
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistGrp_Item = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistGrp_Item = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Grp.RegistGrp_Item"
    
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
' 機能　　 : グループテーブルレコードを削除する
'
' 引数　　 : (In)    strGrpCd    グループコード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteGrp_p(ByVal strGrpCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    DeleteGrp_p = False
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'グループテーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE ORGGRP_P WHERE ORGGRPCD = :GRPCD"
    
    'バインド変数の削除
    objOraParam.Remove "GRPCD"
    
    '戻り値の設定
    DeleteGrp_p = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteGrp_p = False

    'イベントログ書き込み
    WriteErrorLog "Grp.DeleteGrp_p"
    
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

Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス
    
    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'データベース接続
    Set mobjOraSession = mobjContext.CreateInstance("OracleInProcServer.XOraSession")
    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, 0)
    
End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

Private Sub ObjectControl_Deactivate()

    'データベース切断
    Set mobjOraSession = Nothing
    Set mobjOraDb = Nothing

    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing
    
End Sub


'
' 機能　　 : 検索条件を満たす団体グループの一覧を取得する
'
' 引数　　 : (In)     vntGrpDiv         検索グループ区分
' 　　　　 : (Out)    vntGrpCd          グループコード
' 　　　　 : (Out)    vntGrpName        グループ名
' 　　　　 : (In/Out) vntClassCd        検査分類コード（省略可）
' 　　　　 : (Out)    vntPrice1         単価１（省略可）
' 　　　　 : (Out)    vntPrice2         単価２（省略可）
' 　　　　 : (Out)    vntClassName      検査分類名（省略可）
' 　　　　 : (In)     vntNoDataFound    TRUE:検査項目なしでも索引する
' 　　　　 : (Out)    vntSystemGrp      1:システムで使用するグループ
' 　　　　 : (In)     vntOmitSystemGrp  TRUE:システムで使用するグループは除外する。
'
' 戻り値　 : 検索条件を満たす団体レコード件数
'
' 備考　　 :
'
Public Function SelectGrp_ORGList_GrpDiv(ByVal orgdiv As Variant, _
                                         ByRef vntGrpCd As Variant, _
                                         ByRef vntGrpName As Variant, _
                                         Optional ByRef vntSystemGrp As Variant, _
                                         Optional ByRef vntUseGrp As Variant _
                                         ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objGrpDiv           As OraField         'グループ区分
    Dim objGrpCd            As OraField         'グループコード
    Dim objGrpName          As OraField         'グループ名
    Dim objClassCd          As OraField         '分類コード
    Dim objClassName        As OraField         '分類名
    Dim objPrice1           As OraField         '単価１
    Dim objPrice2           As OraField         '単価２
    
    Dim vntArrGrpDiv()      As Variant          'グループ区分の配列
    Dim vntArrGrpCd()       As Variant          'グループコードの配列
    Dim vntArrGrpName()     As Variant          'グループ名の配列
    Dim vntArrClassCd()     As Variant          '分類コードの配列
    Dim vntArrClassName()   As Variant          '分類名の配列
    Dim vntArrPrice1()      As Variant          '単価１の配列
    Dim vntArrPrice2()      As Variant          '単価２の配列
    Dim lngCount            As Long             'レコード数
    
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
    Dim objSystemGrp        As OraField         'システム制御用グループ
    Dim vntArrSystemGrp()   As Variant          'システム制御用グループの配列
'### 2003.2.17 Added End
    
'## 2006/02/03 Add by 李  ST ------------->
    Dim objUseGrp           As OraField
    Dim vntArrUseGrp()      As Variant
'## 2006/02/03 Add by 李  End ------------>
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '検索条件を満たすグループテーブルのレコードを取得
    
'## 2006/02/03 Edit by 李 - UseGrp 追加 ST) ----------------------------------->
'    strStmt = "SELECT ORGGRPCD,GRPNAME,SYSTEMGRP " & vbLf & _
'              "  FROM ORGGRP_P                   "

    strStmt = "SELECT ORGGRPCD,GRPNAME,SYSTEMGRP, USEGRP " & vbLf & _
              "  FROM ORGGRP_P                   "
'## 2006/02/03 Edit by 李 - UseGrp 追加 END) ------------------------------------>
    
    
'### 2003.2.17 Updated by Ishihara@FSIT システム制御用グループ非表示モード追加
'    If IsMissing(vntOmitSystemGrp) = False Then
'        If vntOmitSystemGrp = True Then
'            strStmt = strStmt & _
'                        " AND GP.SYSTEMGRP IS NULL" & vbLf
'        End If
'    End If
'### 2003.2.17 Updated End
    
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpCd = objFields("ORGGRPCD")
        Set objGrpName = objFields("GRPNAME")
        Set objSystemGrp = objFields("SYSTEMGRP")
        Set objUseGrp = objFields("USEGRP")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            ReDim Preserve vntArrSystemGrp(lngCount)
            ReDim Preserve vntArrUseGrp(lngCount)
            
            vntArrGrpCd(lngCount) = objGrpCd.Value & ""
            vntArrGrpName(lngCount) = objGrpName.Value & ""
            vntArrSystemGrp(lngCount) = objSystemGrp.Value & ""
            vntArrUseGrp(lngCount) = objUseGrp.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntGrpCd = vntArrGrpCd
    vntGrpName = vntArrGrpName
    
    If Not IsMissing(vntSystemGrp) Then '引数「システム制御用グループ」が定義されている場合
        vntSystemGrp = vntArrSystemGrp
    End If
    
    If Not IsMissing(vntUseGrp) Then '引数「使用区分」が定義されている場合
        vntUseGrp = vntArrUseGrp
    End If
    
    
    SelectGrp_ORGList_GrpDiv = lngCount
    
    'キー値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_ORGList_GrpDiv"
    
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
' 機能　　 : 検索条件を満たすグループの基本情報を取得する
'
' 引数　　 : (In)     strGrpCd      グループコード
' 　　　　 : (Out)    vntGrpName    グループ名
' 　　　　 : (Out)    vntPrice1     単価１
' 　　　　 : (Out)    vntPrice2     単価２
' 　　　　 : (Out)    vntClassCd    検査分類コード
' 　　　　 : (Out)    vntGrpDiv     グループ区分
' 　　　　 : (Out)    vntSearchChar ガイド検索用文字列
' 　　　　 : (Out)    vntSystemGrp  システム制御グループ
' 　　　　 : (Out)    vntOldSetCd   旧セットコード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectGrp_ORG( _
    ByVal strGrpCd As String, _
    Optional ByRef vntGrpName As Variant, _
    Optional ByRef vntSystemGrp As Variant, _
    Optional ByRef vntUseGrp As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objGrpName      As OraField         'グループ名
    Dim objClassCd      As OraField         '検査分類コード
    Dim objGrpDiv       As OraField         'グループ区分
    Dim objSearchChar   As OraField         'ガイド検査用文字列
    Dim objSystemGrp    As OraField         'システム制御グループ
    Dim objOldSetCd     As OraField         '旧セットコード
    
    Dim objUseGrp    As OraField            '2006.02.05 Add by 李
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntGrpName = Empty
    vntSystemGrp = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たすグループテーブルのレコードを取得
    
    strStmt = "SELECT GRPNAME,                      " & vbCrLf & _
              "       SYSTEMGRP,                    " & vbCrLf & _
               "      NVL(USEGRP,0) USEGRP          " & vbCrLf & _
              "  FROM ORGGRP_P                      " & vbCrLf & _
              " WHERE ORGGRPCD = :GRPCD             "
    
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpName = objFields("GRPNAME")
        Set objSystemGrp = objFields("SYSTEMGRP")
        Set objUseGrp = objFields("USEGRP")
    
        '戻り値の設定
        vntGrpName = objGrpName.Value
        vntSystemGrp = objSystemGrp.Value & ""
        vntUseGrp = objUseGrp.Value & ""
        
        SelectGrp_ORG = True
        
    End If
    
    'バインド変数の削除
    objOraParam.Remove "GRPCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    SelectGrp_ORG = False
    
    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_P"
    
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
' 機能　　 : グループ内の全検査項目を取得する（検査項目）
'
' 引数　　 : (In)     strGrpCd        グループコード
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名
' 　　　　 : (Out)    vntResultType   結果タイプ（省略可）
' 　　　　 : (Out)    vntItemType     項目タイプ（省略可）
' 　　　　 : (Out)    vntStcItemCd    文章参照用項目コード（省略可）
' 　　　　 : (Out)    vntClassName    検査分類名称（省略可）
' 　　　　 : (Out)    vntSeq          表示順番（省略可）
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectGrp_ORG_ItemList(ByVal strGrpCd As String, _
                                     ByRef vntItemCd As Variant, ByRef vntItemCd1 As Variant, _
                                     ByRef vntItemName As Variant) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objItemCd1           As OraField         '検査項目コード
    Dim objItemName         As OraField         '検査項目名
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrItemCd1()      As Variant          '検査項目コードの配列
    
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrClassName()   As Variant          '検査分類名称の配列
    Dim vntArrSeq()         As Variant          '表示順番の配列
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'グループコードが設定されていない場合はエラー
    If IsEmpty(strGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
               
    strStmt = "  SELECT ORGGRP_I.ORGCD1, ORGGRP_I.ORGCD2 , ORG.ORGNAME    " & vbLf & _
              "  From ORGGRP_I, ORG                                       " & vbLf & _
              " WHERE ORGGRP_I.ORGGRPCD  = :GRPCD                          " & vbLf & _
              "   AND ORG.ORGCD1 =  ORGGRP_I.ORGCD1                        " & vbLf & _
               "  AND ORG.ORGCD2 =  ORGGRP_I.ORGCD2                       " & vbLf & _
              "ORDER BY ORGGRPCD"
              

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ORGCD1")
        Set objItemCd1 = objFields("ORGCD2")
        Set objItemName = objFields("ORGNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrItemCd1(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrItemCd1(lngCount) = objItemCd1.Value
            vntArrItemName(lngCount) = objItemName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntItemCd1 = vntArrItemCd1
    vntItemName = vntArrItemName
    
    SelectGrp_ORG_ItemList = lngCount
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Grp.SelectGrp_ORG_ItemList"
    
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
' 機能　　 : コースレコードを登録する（トランザクション対応）
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strGrpCd       グループコード
' 　　　　   (In)    strClassCd     検査分類コード
' 　　　　   (In)    strGrpName     グループ名
' 　　　　   (In)    lngPrice1      単価１
' 　　　　   (In)    lngPrice2      単価２
' 　　　　   (In)    intGrpDiv      グループ区分
' 　　　　   (In)    strSearchChar  ガイド検索用文字列
' 　　　　   (In)    strSystemGrp   システム制御用グループ
' 　　　　   (In)    intItemCount   更新検査項目数
' 　　　　   (In)    vntItemCd      検査項目コード
' 　　　　   (In)    vntSuffix      サフィックス
' 　　　　   (In)    vntSeq         表示順番
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :　コーステーブルとコース内項目テーブルを１回で登録しちゃうよ
'
'Public Function RegistGrp_ORG(ByVal strMode As String, _
'                               ByVal strGrpCd As String, _
'                               ByVal strGrpName As String, _
'                               ByVal strSystemGrp As String, _
'                               ByVal intItemCount As Integer, _
'                               ByVal vntItemCd As Variant, _
'                               ByVal vntSuffix As Variant, _
'                               ByVal vntrslCaption As Variant) As Long


'2006.02.03 UseGrp 追加 Add by 李 ST) ---------------------------->
Public Function RegistGrp_ORG(ByVal strMode As String, _
                               ByVal strGrpCd As String, _
                               ByVal strGrpName As String, _
                               ByVal strSystemGrp As String, _
                               ByVal intItemCount As Integer, _
                               ByVal vntItemCd As Variant, _
                               ByVal vntSuffix As Variant, _
                               ByVal vntrslCaption As Variant, _
                               Optional ByVal intUseGrp As Integer) As Long

'2006.02.03 UseGrp 追加 Add by 李 ED) ---------------------------->


    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret         As Long             '関数戻り値
    
    Ret = INSERT_ERROR
    
    Do
        
        'グループテーブルの更新
        Ret = RegistORG_p(strMode, _
                          strGrpCd, _
                          strGrpName, _
                          strSystemGrp, _
                          intUseGrp)

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        'グループ内項目テーブルの更新
        Ret = RegistORG_Item(strGrpCd, _
                             intItemCount, _
                             vntItemCd, _
                             vntSuffix, _
                             vntrslCaption)
        
        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
        
        Exit Do
    Loop
 
    If Ret = INSERT_NORMAL Then
        mobjContext.SetComplete
    Else
        '異常終了ならRollBack
        mobjContext.SetAbort
    End If
 
    '戻り値の設定
    RegistGrp_ORG = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistGrp_ORG = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Grp.RegistGrp_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' 機能　　 : 団体グループコードを登録する
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strGrpCd       グループコード
' 　　　　   (In)    strClassCd     検査分類コード
' 　　　　   (In)    strGrpName     グループ名
' 　　　　   (In)    lngPrice1      単価１
' 　　　　   (In)    lngPrice2      単価２
' 　　　　   (In)    intGrpDiv      グループ区分
' 　　　　   (In)    strSearchChar  ガイド検索用文字列
' 　　　　   (In)    strSystemGrp   システム制御用グループ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistORG_p(ByVal strMode As String, _
                            ByVal strGrpCd As String, _
                            ByVal strGrpName As String, _
                            ByVal strSystemGrp As String, _
                            Optional ByVal intUseGrp As Integer) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GrpCd", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GrpName", Trim(strGrpName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SystemGrp", strSystemGrp, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UseGrp", intUseGrp, ORAPARM_INPUT, ORATYPE_NUMBER

    Do
        'コーステーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = ""

            strStmt = strStmt & "UPDATE ORGGRP_P"
            strStmt = strStmt & "   SET GrpName    = :GrpName,  "
            strStmt = strStmt & "       SystemGrp = :SystemGrp "
            
            '## 2006.02.03 UseGrp追加 Add by 李　ST) ------------>
            strStmt = strStmt & "       ,UseGrp = :UseGrp "
            '## 2006.02.03 UseGrp追加 Add by 李　ED) ------------>
            
            strStmt = strStmt & " WHERE OrgGrpCd = :GrpCd "
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たすコーステーブルのレコードを取得
        strStmt = "SELECT OrgGrpCd FROM ORGGRP_P WHERE ORGGrpCd = :GrpCd"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入不可
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '新規挿入
        
'### 2006.02.03 UseGrp追加 Add by 李　ST) ------------------------------------------------->
'        strStmt = ""
'        strStmt = strStmt & "INSERT INTO ORGGRP_P (OrgGrpCd,  GrpName,  SystemGrp)"
'        strStmt = strStmt & "           VALUES (:GrpCd,  :GrpName,  :SystemGrp)"
        
        strStmt = ""
        strStmt = strStmt & "INSERT INTO ORGGRP_P (OrgGrpCd,  GrpName,  SystemGrp, UseGrp)"
        strStmt = strStmt & "           VALUES (:GrpCd,  :GrpName,  :SystemGrp , :UseGrp)"
'### 2006.02.03 UseGrp追加 Add by 李　ED) --------------------------------------------------->
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistORG_p = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistORG_p = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Grp.RegistGrp_p"
    
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
' 機能　　 : グループ内受診項目を登録する
'
' 引数　　 : (In)    intGrpDiv      グループ区分（依頼 or 検査）
' 　　　　   (In)    strGrpCd       グループコード
' 　　　　   (In)    intItemCount   更新検査項目数
' 　　　　   (In)    vntItemCd      検査項目コード
' 　　　　   (In)    vntSuffix      サフィックス
' 　　　　   (In)    vntSeq         表示順番
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistORG_Item(ByVal strGrpCd As String, _
                               ByVal intItemCount As Integer, _
                               ByVal vntItemCd As Variant, ByVal vntSuffix As Variant, _
                               ByVal vntrslCaption As Variant) As Long
                               
    Const LENGTH_GRP_I_RSLCAPTION As Long = 100

    Dim objOraParam   As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna    As OraDynaset       'ダイナセット
    Dim strStmt       As String           'SQLステートメント

    Dim objGrpCd      As OraParamArray    'グループコード
    Dim objItemCd     As OraParamArray    '検査項目コード
    Dim objItemCd1     As OraParamArray    '検査項目コード
    
    Dim objSuffix     As OraParamArray    'サフィックス
    Dim objSeq        As OraParamArray    '表示順番
    Dim objrslCaption As OraParamArray    '見出し

    Dim i             As Integer
    Dim Ret           As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'グループ内項目レコードの削除
        mobjOraDb.ExecuteSQL "DELETE ORGGRP_I WHERE ORGGRPCD = :GRPCD"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "GRPCD"
        objOraParam.AddTable "GRPCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 5
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 5
        objOraParam.AddTable "ITEMCD1", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 5
'        objOraParam.AddTable "NAME", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        
        
        'OraParameterオブジェクトの参照設定
        Set objGrpCd = objOraParam("GRPCD")      'GPコード
        Set objItemCd = objOraParam("ITEMCD")    'ORGコード
        Set objItemCd1 = objOraParam("ITEMCD1")  'ORGコード
'        Set objSuffix = objOraParam("NAME")
'
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objGrpCd(i) = strGrpCd
            objItemCd(i) = vntItemCd(i)
            objItemCd1(i) = vntSuffix(i)
'            objSuffix(i) = vntSeq(i)
        Next i
       
        '新規挿入
        strStmt = ""
        
        strStmt = strStmt & "INSERT INTO ORGGRP_I (ORGGRPCD, ORGCD1, ORGCD2)" & vbLf & _
                            "VALUES (:GRPCD, :ITEMCD, :ITEMCD1)"
    
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistORG_Item = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistORG_Item = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Grp.RegistGrp_Item"
    
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

