VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Item"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext    'オブジェクトコンテキスト
Private mobjOraSession      As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase      'OraDatabaseオブジェクト

Private Const DUMMY_SUFFIX  As String = ""      '検査項目テーブル以外のサフィックスの値(ダミー)

'
' 機能　　 : 検査項目＆文章をJOINしたマスタデータ取得（OCRローカルチェック用）
'
' 引数　　 : (In)     dtmNowDate        取得日（検査履歴取得用）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function GetItemMasterForOcr(Optional ByVal dtmNowDate As Variant, _
                                    Optional ByRef vntItemCd As Variant, _
                                    Optional ByRef vntSuffix As Variant, _
                                    Optional ByRef vntResultType As Variant, _
                                    Optional ByRef vntItemType As Variant, _
                                    Optional ByRef vntItemName As Variant, _
                                    Optional ByRef vntItemSName As Variant, _
                                    Optional ByRef vntStcItemCd As Variant, _
                                    Optional ByRef vntStcCd As Variant, _
                                    Optional ByRef vntShortStc As Variant, _
                                    Optional ByRef vntLongStc As Variant, _
                                    Optional ByRef vntFigure1 As Variant, _
                                    Optional ByRef vntFigure2 As Variant, _
                                    Optional ByRef vntMaxValue As Variant, _
                                    Optional ByRef vntMinValue As Variant) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objItemName         As OraField         '検査項目名
    Dim objItemSName        As OraField         '検査項目略称
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objStcCd            As OraField         '文章コード
    Dim objShortStc         As OraField         '略文章
    Dim objLongStc          As OraField         '文章
    Dim objFigure1          As OraField         '整数部桁数
    Dim objFigure2          As OraField         '小数部桁数
    Dim objMaxValue         As OraField         '最大値
    Dim objMinValue         As OraField         '最小値
    
    Dim vntArrItemCd()      As Variant          '検査項目コード
    Dim vntArrSuffix()      As Variant          'サフィックス
    Dim vntArrResultType()  As Variant          '結果タイプ
    Dim vntArrItemType()    As Variant          '項目タイプ
    Dim vntArrItemName()    As Variant          '検査項目名
    Dim vntArrItemSName()   As Variant          '検査項目略称
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コード
    Dim vntArrStcCd()       As Variant          '文章コード
    Dim vntArrShortStc()    As Variant          '略文章
    Dim vntArrLongStc()     As Variant          '文章
    Dim vntArrFigure1()     As Variant          '整数部桁数
    Dim vntArrFigure2()     As Variant          '小数部桁数
    Dim vntArrMaxValue()    As Variant          '最大値
    Dim vntArrMinValue()    As Variant          '最小値
    
    Dim lngCount            As Long             'レコード数
    Dim blnDateSelect       As Boolean
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    blnDateSelect = False
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If IsMissing(dtmNowDate) = False Then
        If (Trim(dtmNowDate) <> "") And IsDate(dtmNowDate) Then
            objOraParam.Add "NOWDATE", CDate(dtmNowDate), ORAPARM_INPUT, ORATYPE_DATE
            blnDateSelect = True
        End If
    End If
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = "SELECT ITEM_C.ITEMCD,                          " & vbLf & _
              "       ITEM_C.SUFFIX,                          " & vbLf & _
              "       ITEM_C.RESULTTYPE,                      " & vbLf & _
              "       ITEM_C.ITEMTYPE,                        " & vbLf & _
              "       ITEM_C.ITEMNAME,                        " & vbLf & _
              "       ITEM_C.ITEMSNAME,                       " & vbLf & _
              "       ITEM_C.STCITEMCD,                       " & vbLf & _
              "       SENTENCE.STCCD,                         " & vbLf & _
              "       SENTENCE.SHORTSTC,                      " & vbLf & _
              "       SENTENCE.LONGSTC,                       " & vbLf & _
              "       ITEM_H.FIGURE1,                         " & vbLf & _
              "       ITEM_H.FIGURE2,                         " & vbLf & _
              "       ITEM_H.MAXVALUE,                        " & vbLf & _
              "       ITEM_H.MINVALUE                         " & vbLf & _
              "  FROM ITEM_H, SENTENCE, ITEM_C                " & vbLf & _
              " WHERE ITEM_C.STCITEMCD = SENTENCE.ITEMCD(+)   " & vbLf & _
              "   AND ITEM_C.ITEMTYPE  = SENTENCE.ITEMTYPE(+) " & vbLf & _
              "   AND ITEM_H.ITEMCD    = ITEM_C.ITEMCD        " & vbLf & _
              "   AND ITEM_H.SUFFIX    = ITEM_C.SUFFIX        " & vbLf
    
    '日付を指定されている場合、条件を変更
    If blnDateSelect = True Then
        strStmt = strStmt & _
                  "   AND :NOWDATE BETWEEN ITEM_H.STRDATE AND ITEM_H.ENDDATE " & vbLf
    Else
        strStmt = strStmt & _
                  "   AND SYSDATE BETWEEN ITEM_H.STRDATE AND ITEM_H.ENDDATE " & vbLf
    End If

    strStmt = strStmt & _
              " ORDER BY ITEM_C.ITEMCD, ITEM_C.SUFFIX, SENTENCE.STCCD                "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objItemName = objFields("ITEMNAME")
        Set objItemSName = objFields("ITEMSNAME")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objStcCd = objFields("STCCD")
        Set objShortStc = objFields("SHORTSTC")
        Set objLongStc = objFields("LONGSTC")
        Set objFigure1 = objFields("FIGURE1")
        Set objFigure2 = objFields("FIGURE2")
        Set objMaxValue = objFields("MAXVALUE")
        Set objMinValue = objFields("MINVALUE")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
                
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrItemSName(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrStcCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrLongStc(lngCount)
            ReDim Preserve vntArrFigure1(lngCount)
            ReDim Preserve vntArrFigure2(lngCount)
            ReDim Preserve vntArrMaxValue(lngCount)
            ReDim Preserve vntArrMinValue(lngCount)
        
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrResultType(lngCount) = objResultType.Value & ""
            vntArrItemType(lngCount) = objItemType.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrItemSName(lngCount) = objItemSName.Value & ""
            vntArrStcItemCd(lngCount) = objStcItemCd.Value & ""
            vntArrStcCd(lngCount) = objStcCd.Value & ""
            vntArrShortStc(lngCount) = objShortStc.Value & ""
            vntArrLongStc(lngCount) = objLongStc.Value & ""
            vntArrFigure1(lngCount) = objFigure1.Value & ""
            vntArrFigure2(lngCount) = objFigure2.Value & ""
            vntArrMaxValue(lngCount) = objMaxValue.Value & ""
            vntArrMinValue(lngCount) = objMinValue.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    If IsMissing(vntItemCd) = False Then vntItemCd = vntArrItemCd
    If IsMissing(vntSuffix) = False Then vntSuffix = vntArrSuffix
    If IsMissing(vntResultType) = False Then vntResultType = vntArrResultType
    If IsMissing(vntItemType) = False Then vntItemType = vntArrItemType
    If IsMissing(vntItemName) = False Then vntItemName = vntArrItemName
    If IsMissing(vntItemSName) = False Then vntItemSName = vntArrItemSName
    If IsMissing(vntStcItemCd) = False Then vntStcItemCd = vntArrStcItemCd
    If IsMissing(vntStcCd) = False Then vntStcCd = vntArrStcCd
    If IsMissing(vntShortStc) = False Then vntShortStc = vntArrShortStc
    If IsMissing(vntLongStc) = False Then vntLongStc = vntArrLongStc
    If IsMissing(vntFigure1) = False Then vntFigure1 = vntArrFigure1
    If IsMissing(vntFigure2) = False Then vntFigure2 = vntArrFigure2
    If IsMissing(vntMaxValue) = False Then vntMaxValue = vntArrMaxValue
    If IsMissing(vntMinValue) = False Then vntMinValue = vntArrMinValue
    
    GetItemMasterForOcr = lngCount
        
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
    WriteErrorLog "Item.GetItemMasterForOcr"
    
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
' 機能　　 : 検査分類名称の一覧を取得する
'
' 引数　　 : (Out)    vntClassCd   検査分類コード
' 　　　　 : (Out)    vntClassName 検査分類名称
'
' 戻り値　 : 検査分類テーブルに登録されているレコード件数
'
' 備考　　 :
'
Public Function SelectItemClassList(ByRef vntClassCd As Variant, ByRef vntClassName As Variant) As Long
                                   
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objClassCd          As OraField         '検査分類コード
    Dim objClassName        As OraField         '検査分類名称
    
    Dim vntArrClassCd()     As Variant          '検査分類コードの配列
    Dim vntArrClassName()   As Variant          '検査分類名称の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntClassCd = Empty
    vntClassName = Empty
          
    '検査分類テーブルのレコードを取得
    strStmt = "SELECT CLASSCD, CLASSNAME " & vbLf & _
              "  FROM ITEMCLASS          " & vbLf & _
              " ORDER BY CLASSCD         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objClassCd = objFields("CLASSCD")
        Set objClassName = objFields("CLASSNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrClassCd(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            vntArrClassCd(lngCount) = objClassCd.Value & ""
            vntArrClassName(lngCount) = objClassName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntClassCd = vntArrClassCd
    vntClassName = vntArrClassName
    SelectItemClassList = lngCount
        
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Item.SelectItemClassList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 検査分類データを取得する
'
' 引数　　 : (In)     strItemClassCd    検査分類コード
' 　　　　   (Out)    vntItemClassName  検査分類名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectItemClass(ByVal strItemClassCd As String, ByRef vntItemClassName As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objItemClassName As OraField         '検査分類名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ItemClassCD", Trim(strItemClassCd), ORAPARM_INPUT
    
    '検索条件を満たす検査分類テーブルのレコードを取得
    strStmt = "SELECT CLASSNAME FROM ITEMCLASS WHERE CLASSCD = :ItemClassCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemClassName = objFields("CLASSNAME")
    
        '戻り値の設定
        vntItemClassName = objItemClassName.Value
        
        SelectItemClass = True
        
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
    WriteErrorLog "Item.SelectItemClass"
    
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
' 機能　　 : 検査分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strItemClassCd     検査分類コード
' 　　　　   (In)    vntItemClassName   検査分類名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistItemClass(ByVal strMode As String, _
                                ByVal strItemClassCd As String, _
                                ByVal strItemClassName As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ItemClassCD", Trim(strItemClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ItemClassNAME", Trim(strItemClassName), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '検査分類テーブルレコードの更新
        If strMode = "UPD" Then
            Ret = mobjOraDb.ExecuteSQL("UPDATE ITEMCLASS SET CLASSNAME = :ItemClassNAME WHERE CLASSCD = :ItemClassCD")
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす検査分類テーブルのレコードを取得
        strStmt = "SELECT CLASSCD FROM ITEMCLASS WHERE CLASSCD = :ItemClassCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO ITEMCLASS (CLASSCD, CLASSNAME) VALUES (:ItemClassCD, :ItemClassNAME)"
    
        Ret = INSERT_NORMAL
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'これはRootトランザクションなのでCommit
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistItemClass = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistItemClass = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Item.RegistItemClass"
    
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
' 機能　　 : 検査項目履歴データを登録する
'
' 引数　　 : (In)    strItemCd          検査項目コード
' 　　　　   (In)    strSuffix          サフィックス
' 　　　　   (In)    intItemCount       検査項目履歴個数
' 　　　　   (In)    vntItemHNo         検査項目履歴Ｎｏ
' 　　　　   (In)    vntStrDate         使用開始日付
' 　　　　   (In)    vntEndDate         使用終了日付
' 　　　　   (In)    vntFigure1         整数部桁数
' 　　　　   (In)    vntFigure2         小数部桁数
' 　　　　   (In)    vntMaxValue        最大値
' 　　　　   (In)    vntMinValue        最小値
' 　　　　   (In)    vntInsItemCd       検査用項目コード
' 　　　　   (In)    vntUnit            単位
' 　　　　   (In)    vntDefResult       省略時検査結果
' 　　　　   (In)    vntDefRslCmtCd     省略時結果コメントコード
' 　　　　   (In)    vntReqItemCd       検査用依頼項目コード
' 　　　　   (In)    vntSepOrderDiv     オーダ分割区分
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　   (In)    vntReqItemCd       検査用依頼項目コード
' 　　　　   (In)    vntInsSuffix       検査用サフィックス
' 　　　　   (In)    vnteUnit           英語単位
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'## 2003.11.23 Modifed By H.Ishihara@FSIT 聖路加不要項目の削除
Public Function RegistItemHistory(ByVal strItemCd As String, _
                                  ByVal strSuffix As String, _
                                  ByVal intItemCount As Integer, _
                                  ByVal vntItemHNo As Variant, _
                                  ByVal vntStrDate As Variant, _
                                  ByVal vntEndDate As Variant, _
                                  ByVal vntFigure1 As Variant, _
                                  ByVal vntFigure2 As Variant, _
                                  ByVal vntMaxValue As Variant, _
                                  ByVal vntMinValue As Variant, _
                                  ByVal vntInsItemCd As Variant, _
                                  ByVal vntUnit As Variant, _
                                  ByVal vntDefResult As Variant, _
                                  ByVal vntDefRslCmtCd As Variant, _
                                  ByVal vntReqItemCd As Variant, _
                                  ByVal vntInsSuffix As Variant, ByVal vnteUnit As Variant) As Long
'Public Function RegistItemHistory(ByVal strItemCd As String, _
                                  ByVal strSuffix As String, _
                                  ByVal intItemCount As Integer, _
                                  ByVal vntItemHNo As Variant, _
                                  ByVal vntStrDate As Variant, _
                                  ByVal vntEndDate As Variant, _
                                  ByVal vntFigure1 As Variant, _
                                  ByVal vntFigure2 As Variant, _
                                  ByVal vntMaxValue As Variant, _
                                  ByVal vntMinValue As Variant, _
                                  ByVal vntInsItemCd As Variant, _
                                  ByVal vntUnit As Variant, _
                                  ByVal vntDefResult As Variant, _
                                  ByVal vntDefRslCmtCd As Variant, _
                                  ByVal vntReqItemCd As Variant, _
                                  ByVal vntSepOrderDiv As Variant _
                                  ) As Long
'## 2003.11.23 Modifed End
                               
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objItemCd           As OraParamArray    '検査項目コード
    Dim objSuffix           As OraParamArray    'サフィックス
    Dim objItemHNo          As OraParamArray
    Dim objStrDate          As OraParamArray
    Dim objEndDate          As OraParamArray
    Dim objFigure1          As OraParamArray
    Dim objFigure2          As OraParamArray
    Dim objMaxValue         As OraParamArray
    Dim objMinValue         As OraParamArray
    Dim objInsItemCd        As OraParamArray
    Dim objUnit             As OraParamArray
    Dim objDefResult        As OraParamArray
    Dim objDefRslCmtCd      As OraParamArray
    Dim objReqItemCd        As OraParamArray
'## 2003.11.23 Modifed By H.Ishihara@FSIT 聖路加不要項目の削除
'    Dim objSepOrderDiv      As OraParamArray
'## 2003.11.23 Modifed End

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim objInsSuffix        As OraParamArray
    Dim objeUnit            As OraParamArray
'### 2004/1/15 Added End

    Dim i                   As Integer
    Dim Ret                 As Long             '関数戻り値
    
    Dim vntChkInsItemCd     As Variant          '検査用検査項目コード
    Dim vntChkInsSuffix     As Variant          '検査用サフィックス
    Dim vntChkInsItemName   As Variant          '検査用項目名
    Dim lngChkInsCount      As Long
    
    Dim objCommon           As HainsCommon.Common
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    RegistItemHistory = Ret
    
    '主キーが設定されていない場合はエラー
    If (Trim(strItemCd) = "") Or (Trim(strSuffix) = "") Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    For i = 0 To intItemCount - 1
        '検査項目コードのダブリチェック
'## 2003.11.23 Modifed By H.Ishihara@FSIT 聖路加不要項目の削除
'        lngChkInsCount = SelectInsItemInfo(strItemCd, _
                                           strSuffix, _
                                           vntInsItemCd(i), _
                                           vntChkInsItemCd, _
                                           vntChkInsSuffix, _
                                           vntChkInsItemName, _
                                           vntSepOrderDiv(i))
        lngChkInsCount = SelectInsItemInfo(strItemCd, _
                                           strSuffix, _
                                           vntInsItemCd(i), _
                                           vntChkInsItemCd, _
                                           vntChkInsSuffix, _
                                           vntChkInsItemName)
        If (lngChkInsCount > 0) Or (lngChkInsCount < 0) Then
            Exit Function
        End If
    Next i
    
    '履歴データの重複チェック
    Set objCommon = New HainsCommon.Common
    If objCommon.CheckHistoryDuplicate(intItemCount, vntStrDate, vntEndDate) = False Then
        RegistItemHistory = INSERT_HISTORYDUPLICATE
        Exit Function
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検査項目履歴管理レコードの削除
    mobjOraDb.ExecuteSQL "DELETE ITEM_H WHERE ITEMCD = :ITEMCD AND SUFFIX = :SUFFIX"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "ITEMCD"
        objOraParam.Remove "SUFFIX"
        
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_C_SUFFIX
        objOraParam.AddTable "ITEMHNO", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "STRDATE", ORAPARM_INPUT, ORATYPE_DATE, intItemCount
        objOraParam.AddTable "ENDDATE", ORAPARM_INPUT, ORATYPE_DATE, intItemCount
        objOraParam.AddTable "FIGURE1", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "FIGURE2", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "MAXVALUE", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_H_MAXVALUE
        objOraParam.AddTable "MINVALUE", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_H_MINVALUE
        objOraParam.AddTable "INSITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_H_INSITEMCD
'## 2004.02.02 Updated By H.Ishihara@FSIT 聖路加のためにレングス拡張
'        objOraParam.AddTable "UNIT", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_H_UNIT
        objOraParam.AddTable "UNIT", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 12
'## 2004.02.02 Updated End
        objOraParam.AddTable "DEFRESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_H_DEFRESULT
        objOraParam.AddTable "DEFRSLCMTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_H_DEFRSLCMTCD
        objOraParam.AddTable "REQITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 17
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'        objOraParam.AddTable "SEPORDERDIV", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 1
'## 2003.11.23 Deleted End
        
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        objOraParam.AddTable "INSSUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 2
        objOraParam.AddTable "EUNIT", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 12
'### 2004/1/15 Added End
        
        'OraParameterオブジェクトの参照設定
        Set objItemCd = objOraParam("ITEMCD")
        Set objSuffix = objOraParam("SUFFIX")
        Set objItemHNo = objOraParam("ITEMHNO")
        Set objStrDate = objOraParam("STRDATE")
        Set objEndDate = objOraParam("ENDDATE")
        Set objFigure1 = objOraParam("FIGURE1")
        Set objFigure2 = objOraParam("FIGURE2")
        Set objMaxValue = objOraParam("MAXVALUE")
        Set objMinValue = objOraParam("MINVALUE")
        Set objInsItemCd = objOraParam("INSITEMCD")
        Set objUnit = objOraParam("UNIT")
        Set objDefResult = objOraParam("DEFRESULT")
        Set objDefRslCmtCd = objOraParam("DEFRSLCMTCD")
        Set objReqItemCd = objOraParam("REQITEMCD")
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'        Set objSepOrderDiv = objOraParam("SEPORDERDIV")
'## 2003.11.23 Deleted End
        
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        Set objInsSuffix = objOraParam("INSSUFFIX")
        Set objeUnit = objOraParam("EUNIT")
'### 2004/1/15 Added End
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objItemCd(i) = strItemCd
            objSuffix(i) = strSuffix
            objItemHNo(i) = vntItemHNo(i)
            objStrDate(i) = vntStrDate(i)
            objEndDate(i) = vntEndDate(i)
            objFigure1(i) = vntFigure1(i)
            objFigure2(i) = vntFigure2(i)
            objMaxValue(i) = vntMaxValue(i)
            objMinValue(i) = vntMinValue(i)
            objInsItemCd(i) = vntInsItemCd(i)
            objUnit(i) = vntUnit(i)
            objDefResult(i) = vntDefResult(i)
            objDefRslCmtCd(i) = vntDefRslCmtCd(i)
            objReqItemCd(i) = vntReqItemCd(i)
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'            objSepOrderDiv(i) = vntSepOrderDiv(i)
'## 2003.11.23 Deleted End
        
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            objInsSuffix(i) = vntInsSuffix(i)
            objeUnit(i) = vnteUnit(i)
'### 2004/1/15 Added End
        
        Next i
        
        '新規挿入
        strStmt = ""
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'        strStmt = "INSERT INTO ITEM_H" & vbLf & _
                  "              ( ITEMCD, SUFFIX, ITEMHNO, STRDATE, ENDDATE, FIGURE1, FIGURE2, MAXVALUE, MINVALUE, INSITEMCD,  UNIT, DEFRESULT, DEFRSLCMTCD, REQITEMCD,  SEPORDERDIV)" & vbLf & _
                  "       VALUES (:ITEMCD,:SUFFIX,:ITEMHNO,:STRDATE,:ENDDATE,:FIGURE1,:FIGURE2,:MAXVALUE,:MINVALUE,:INSITEMCD, :UNIT,:DEFRESULT,:DEFRSLCMTCD, :REQITEMCD, :SEPORDERDIV)"
'        strStmt = "INSERT INTO ITEM_H" & vbLf & _
                  "              ( ITEMCD, SUFFIX, ITEMHNO, STRDATE, ENDDATE, FIGURE1, FIGURE2, MAXVALUE, MINVALUE, INSITEMCD,  UNIT, DEFRESULT,  DEFRSLCMTCD,  REQITEMCD, )" & vbLf & _
                  "       VALUES (:ITEMCD,:SUFFIX,:ITEMHNO,:STRDATE,:ENDDATE,:FIGURE1,:FIGURE2,:MAXVALUE,:MINVALUE,:INSITEMCD, :UNIT,:DEFRESULT, :DEFRSLCMTCD, :REQITEMCD  )"
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
'        strStmt = "INSERT INTO ITEM_H" & vbLf & _
                  "              ( ITEMCD, SUFFIX, ITEMHNO, STRDATE, ENDDATE, FIGURE1, FIGURE2, MAXVALUE, MINVALUE, INSITEMCD,  UNIT, DEFRESULT,  DEFRSLCMTCD,  REQITEMCD )" & vbLf & _
                  "       VALUES (:ITEMCD,:SUFFIX,:ITEMHNO,:STRDATE,:ENDDATE,:FIGURE1,:FIGURE2,:MAXVALUE,:MINVALUE,:INSITEMCD, :UNIT,:DEFRESULT, :DEFRSLCMTCD, :REQITEMCD )"
        strStmt = "INSERT INTO ITEM_H" & vbLf & _
                  "              ( ITEMCD, SUFFIX, ITEMHNO, STRDATE, ENDDATE, FIGURE1, FIGURE2, MAXVALUE, MINVALUE, INSITEMCD,  UNIT, DEFRESULT,  DEFRSLCMTCD,  REQITEMCD,  INSSUFFIX,  EUNIT )" & vbLf & _
                  "       VALUES (:ITEMCD,:SUFFIX,:ITEMHNO,:STRDATE,:ENDDATE,:FIGURE1,:FIGURE2,:MAXVALUE,:MINVALUE,:INSITEMCD, :UNIT,:DEFRESULT, :DEFRSLCMTCD, :REQITEMCD, :INSSUFFIX, :EUNIT )"
'### 2004/1/15 Added End
'## 2003.11.23 Deleted End
    
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
    Else
        '更新件数０件も正常終了
        Ret = INSERT_NORMAL
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistItemHistory = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistItemHistory = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Item.RegistItemHistory"
    
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
' 機能　　 : 検査項目変換データを登録する
'
' 引数　　 : (In)    strItemCd          検査項目コード
' 　　　　   (In)    strSuffix          サフィックス
' 　　　　   (In)    intItemCount       検査項目履歴個数
' 　　　　   (In)    vntItemHNo         検査項目履歴Ｎｏ
' 　　　　   (In)    vntKarteDocCd      電カル用文書種別コード
' 　　　　   (In)    vntKarteItemAttr   電カル用項目属性
' 　　　　   (In)    vntKarteItemcd     電カル用項目コード
' 　　　　   (In)    vntKarteItemName   電カル用項目名
' 　　　　   (In)    vntKarteTagName    電カル用タグ名称
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
Private Function RegistKarteItem(ByVal strItemCd As String, _
                                ByVal strSuffix As String, _
                                ByVal intItemCount As Integer, _
                                ByVal vntItemHNo As Variant, _
                                ByVal vntKarteDocCd As Variant, _
                                ByVal vntKarteItemAttr As Variant, _
                                ByVal vntKarteItemcd As Variant, _
                                ByVal vntKarteItemName As Variant, _
                                ByVal vntKarteTagName As Variant _
                                ) As Long
                               
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objItemCd           As OraParamArray    '検査項目コード
    Dim objSuffix           As OraParamArray    'サフィックス
    Dim objItemHNo          As OraParamArray
    Dim objKarteDocCd       As OraParamArray
    Dim objKarteItemAttr    As OraParamArray
    Dim objKarteItemcd      As OraParamArray
    Dim objKarteItemName    As OraParamArray
    Dim objKarteTagName     As OraParamArray

    Dim i               As Integer
    Dim Ret             As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    '主キーが設定されていない場合はエラー
    If (Trim(strItemCd) = "") Or (Trim(strSuffix) = "") Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検査項目履歴管理レコードの削除
    mobjOraDb.ExecuteSQL "DELETE KARTEITEM WHERE ITEMCD = :ITEMCD AND SUFFIX = :SUFFIX"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "ITEMCD"
        objOraParam.Remove "SUFFIX"
        
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_C_SUFFIX
        objOraParam.AddTable "ITEMHNO", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "KARTEDOCCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_KARTEITEM_KARTEDOCCD
        objOraParam.AddTable "KARTEITEMATTR", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_KARTEITEM_KARTEITEMATTR
        objOraParam.AddTable "KARTEITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_KARTEITEM_KARTEITEMCD
        objOraParam.AddTable "KARTEITEMNAME", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_KARTEITEM_KARTEITEMNAME
        objOraParam.AddTable "KARTETAGNAME", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_KARTEITEM_KARTETAGNAME
        
        'OraParameterオブジェクトの参照設定
        Set objItemCd = objOraParam("ITEMCD")
        Set objSuffix = objOraParam("SUFFIX")
        Set objItemHNo = objOraParam("ITEMHNO")
        Set objKarteDocCd = objOraParam("KARTEDOCCD")
        Set objKarteItemAttr = objOraParam("KARTEITEMATTR")
        Set objKarteItemcd = objOraParam("KARTEITEMCD")
        Set objKarteItemName = objOraParam("KARTEITEMNAME")
        Set objKarteTagName = objOraParam("KARTETAGNAME")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objItemCd(i) = strItemCd
            objSuffix(i) = strSuffix
            objItemHNo(i) = vntItemHNo(i)
            objKarteDocCd(i) = vntKarteDocCd(i)
            objKarteItemAttr(i) = vntKarteItemAttr(i)
            objKarteItemcd(i) = vntKarteItemcd(i)
            objKarteItemName(i) = vntKarteItemName(i)
            objKarteTagName(i) = vntKarteTagName(i)
        Next i
        
        '新規挿入
        strStmt = ""
        strStmt = "INSERT INTO KARTEITEM" & vbLf & _
                  "              ( ITEMCD, SUFFIX, ITEMHNO, KARTEITEMCD, KARTEITEMNAME, KARTEITEMATTR, KARTEDOCCD, KARTETAGNAME)" & vbLf & _
                  "       VALUES (:ITEMCD,:SUFFIX,:ITEMHNO,:KARTEITEMCD,:KARTEITEMNAME,:KARTEITEMATTR,:KARTEDOCCD,:KARTETAGNAME)"
    
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
    Else
        '更新件数０件も正常終了
        Ret = INSERT_NORMAL
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistKarteItem = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistKarteItem = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Item.RegistKarteItem"
    
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
' 機能　　 : 依頼項目テーブルレコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strItemCd              検査項目コード
' 　　　　   (In)    strClassCd             検査分類コード
' 　　　　   (In)    intRslQue              結果問診フラグ
' 　　　　   (In)    strRequestName         依頼項目名
' 　　　　   (In)    strRequestSName        依頼項目略称
' 　　　　   (In)    strProgressCd          進捗分類コード
' 　　　　   (In)    intEntryOk             未入力チェック
' 　　　　   (In)    strSearchChar          ガイド検索用文字列
' 　　　　   (In)    strOpeClassCd          検査実施日分類コード
'### 2003/11/23 Deleted by Ishihara@FSIT 不要項目の削除
' 　　　　   (In)    lngPrice1              単価１
' 　　　　   (In)    lngPrice2              単価２
' 　　　　   (In)    strOrderFileName       オーダファイル名
' 　　　　   (In)    strDocCd               文書種別コード
' 　　　　   (In)    strDmdLineClassCd      請求明細分類コード
' 　　　　   (In)    strIsrDmdLineClassCd   健保請求明細分類コード
' 　　　　   (In)    strRoundClassCd        まるめ分類コード
'### 2003/11/23 Deleted End
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistItem_p(ByVal strMode As String, _
                             ByVal strItemCd As String, _
                             ByVal strClassCd As String, _
                             ByVal intRslQue As Integer, _
                             ByVal strRequestName As String, _
                             ByVal strRequestSName As String, _
                             ByVal strProgressCd As String, _
                             ByVal intEntryOk As Integer, _
                             ByVal strSearchChar As String, _
                             ByVal strOpeClassCd As String) As Long
'Public Function RegistItem_p(ByVal strMode As String, _
                             ByVal strItemCd As String, _
                             ByVal strClassCd As String, _
                             ByVal intRslQue As Integer, _
                             ByVal strRequestName As String, _
                             ByVal strRequestSName As String, _
                             ByVal strProgressCd As String, _
                             ByVal intEntryOk As Integer, _
                             ByVal strSearchChar As String, _
                             ByVal strOpeClassCd As String, _
                             ByVal lngPrice1 As Long, _
                             ByVal lngPrice2 As Long, _
                             ByVal strOrderFileName As String, _
                             ByVal strDocCd As String, _
                             ByVal strDmdLineClassCd As String, _
                             ByVal strIsrDmdLineClassCd As String, _
                             ByVal strRoundClassCd As String _
                             ) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント

    '新規作成時に検査項目履歴テーブルもぶちこむ為の領域
    Dim vntArrItemHNo(0)            As Variant
    Dim vntArrStrDate(0)            As Variant
    Dim vntArrEndDate(0)            As Variant
    Dim vntArrFigure1(0)            As Variant
    Dim vntArrFigure2(0)            As Variant
    Dim vntArrMaxValue(0)           As Variant
    Dim vntArrMinValue(0)           As Variant
    Dim vntArrInsItemCd(0)          As Variant
    Dim vntArrUnit(0)               As Variant
    Dim vntArrDefResult(0)          As Variant
    Dim vntArrDefRslCmtCd(0)        As Variant

    Dim vntArrKarteDocCd(0)         As Variant
    Dim vntArrKarteItemAttr(0)      As Variant
    Dim vntArrKarteItemcd(0)        As Variant
    Dim vntArrKarteItemName(0)      As Variant
    Dim vntArrKarteTagName(0)       As Variant

    Dim vntItemHNo                  As Variant
    Dim vntStrDate                  As Variant
    Dim vntEndDate                  As Variant
    Dim vntFigure1                  As Variant
    Dim vntFigure2                  As Variant
    Dim vntMaxValue                 As Variant
    Dim vntMinValue                 As Variant
    Dim vntInsItemCd                As Variant
    Dim vntUnit                     As Variant
    Dim vntDefResult                As Variant
    Dim vntDefRslCmtCd              As Variant

    Dim vntKarteDocCd               As Variant
    Dim vntKarteItemAttr            As Variant
    Dim vntKarteItemcd              As Variant
    Dim vntKarteItemName            As Variant
    Dim vntKarteTagName             As Variant
    Dim vntArrReqItemCd(0)          As String
    Dim vntArrSepOrderDiv(0)        As String

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim intCuTargetFlg              As Integer
    Dim strOrderDiv                 As String
    Dim strBuiCode                  As String
    Dim strExplanation              As String
    Dim vntInsSuffix(0)             As Variant
    Dim vnteUnit(0)                 As Variant
    Dim vntReqItemCd(0)             As Variant
'### 2004/1/15 Added End

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CLASSCD", Trim(strClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSLQUE", Trim(intRslQue), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REQUESTNAME", Trim(strRequestName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REQUESTSNAME", Trim(strRequestSName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PROGRESSCD", Trim(strProgressCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENTRYOK", Trim(intEntryOk), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEARCHCHAR", Trim(strSearchChar), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPECLASSCD", Trim(strOpeClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003/11/23 Deleted by Ishihara@FSIT 不要項目の削除
'    objOraParam.Add "PRICE1", Trim(lngPrice1), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "PRICE2", Trim(lngPrice2), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "ORDERFILENAME", Trim(strOrderFileName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "DOCCD", Trim(strDocCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "DMDLINECLASSCD", Trim(strDmdLineClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ISRDMDLINECLASSCD", Trim(strIsrDmdLineClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ROUNDCLASSCD", Trim(strRoundClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003/11/23 Deleted End

    Do
        '依頼項目テーブルレコードの更新
        If strMode = "UPD" Then
'### 2003/11/23 Modifed by Ishihara@FSIT 不要項目の削除
'            strStmt = "UPDATE ITEM_P SET CLASSCD           = :CLASSCD," & vbLf & _
                      "                  RSLQUE            = :RSLQUE," & vbLf & _
                      "                  REQUESTNAME       = :REQUESTNAME," & vbLf & _
                      "                  REQUESTSNAME      = :REQUESTSNAME," & vbLf & _
                      "                  PROGRESSCD        = :PROGRESSCD," & vbLf & _
                      "                  ENTRYOK           = :ENTRYOK," & vbLf & _
                      "                  SEARCHCHAR        = :SEARCHCHAR," & vbLf & _
                      "                  OPECLASSCD        = :OPECLASSCD," & vbLf & _
                      "                  PRICE1            = :PRICE1," & vbLf & _
                      "                  PRICE2            = :PRICE2," & vbLf & _
                      "                  ORDERFILENAME     = :ORDERFILENAME," & vbLf & _
                      "                  DOCCD             = :DOCCD," & vbLf & _
                      "                  DMDLINECLASSCD    = :DMDLINECLASSCD," & vbLf & _
                      "                  ISRDMDLINECLASSCD = :ISRDMDLINECLASSCD," & vbLf & _
                      "                  ROUNDCLASSCD      = :ROUNDCLASSCD" & vbLf & _
                      " WHERE ITEMCD = :ITEMCD"
            strStmt = "UPDATE ITEM_P SET CLASSCD           = :CLASSCD," & vbLf & _
                      "                  RSLQUE            = :RSLQUE," & vbLf & _
                      "                  REQUESTNAME       = :REQUESTNAME," & vbLf & _
                      "                  REQUESTSNAME      = :REQUESTSNAME," & vbLf & _
                      "                  PROGRESSCD        = :PROGRESSCD," & vbLf & _
                      "                  ENTRYOK           = :ENTRYOK," & vbLf & _
                      "                  SEARCHCHAR        = :SEARCHCHAR," & vbLf & _
                      "                  OPECLASSCD        = :OPECLASSCD" & vbLf & _
                      " WHERE ITEMCD = :ITEMCD"
'### 2003/11/23 Modifed End
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす依頼項目テーブルのレコードを取得
        strStmt = "SELECT ITEMCD FROM ITEM_P WHERE ITEMCD = :ITEMCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'### 2003/11/23 Modifed by Ishihara@FSIT 不要項目の削除
'        strStmt = "INSERT INTO ITEM_P" & vbLf & _
                  "       (  ITEMCD, CLASSCD, RSLQUE, REQUESTNAME, REQUESTSNAME, PROGRESSCD, ENTRYOK, SEARCHCHAR, OPECLASSCD, PRICE1, PRICE2, ORDERFILENAME,  DOCCD,  DMDLINECLASSCD,  ISRDMDLINECLASSCD,  ROUNDCLASSCD )" & vbLf & _
                  "VALUES ( :ITEMCD,:CLASSCD,:RSLQUE,:REQUESTNAME,:REQUESTSNAME,:PROGRESSCD,:ENTRYOK,:SEARCHCHAR,:OPECLASSCD,:PRICE1,:PRICE2,:ORDERFILENAME, :DOCCD, :DMDLINECLASSCD, :ISRDMDLINECLASSCD, :ROUNDCLASSCD )"
        strStmt = "INSERT INTO ITEM_P" & vbLf & _
                  "       (  ITEMCD, CLASSCD, RSLQUE, REQUESTNAME, REQUESTSNAME, PROGRESSCD, ENTRYOK, SEARCHCHAR, OPECLASSCD)" & vbLf & _
                  "VALUES ( :ITEMCD,:CLASSCD,:RSLQUE,:REQUESTNAME,:REQUESTSNAME,:PROGRESSCD,:ENTRYOK,:SEARCHCHAR,:OPECLASSCD)"
'### 2003/11/23 Modifed End
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        '検査項目テーブル更新用に一度バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    
        '新規モードが成功したら、そのまま子レコード（検査項目レコード）もぶちこみ（かっくい～）
        
        '検査項目履歴管理テーブルのデフォルト値セット
        vntArrItemHNo(0) = 0
        vntArrStrDate(0) = CDate(YEARRANGE_MIN & "/01/01")
        vntArrEndDate(0) = CDate(YEARRANGE_MAX & "/12/31")
        vntArrFigure1(0) = 8
        vntArrFigure2(0) = 0
        vntArrMaxValue(0) = ""
        vntArrMinValue(0) = ""
        vntArrInsItemCd(0) = ""
        vntArrUnit(0) = ""
        vntArrDefResult(0) = ""
        vntArrDefRslCmtCd(0) = ""
        
        vntArrKarteDocCd(0) = ""
        vntArrKarteItemAttr(0) = ""
        vntArrKarteItemcd(0) = ""
        vntArrKarteItemName(0) = ""
        vntArrKarteTagName(0) = ""
        
        vntItemHNo = vntArrItemHNo
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        vntFigure1 = vntArrFigure1
        vntFigure2 = vntArrFigure2
        vntMaxValue = vntArrMaxValue
        vntMinValue = vntArrMinValue
        vntInsItemCd = vntArrInsItemCd
        vntKarteItemcd = vntArrKarteItemcd
        vntKarteItemName = vntArrKarteItemName
        vntKarteItemAttr = vntArrKarteItemAttr
        vntKarteDocCd = vntArrKarteDocCd
        vntUnit = vntArrUnit
        vntDefResult = vntArrDefResult
        vntDefRslCmtCd = vntArrDefRslCmtCd
        vntArrReqItemCd(0) = ""
        vntArrSepOrderDiv(0) = ""
        
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        intCuTargetFlg = 0
        strOrderDiv = ""
        strBuiCode = ""
        strExplanation = ""
        vntInsSuffix(0) = ""
        vnteUnit(0) = ""
        vntReqItemCd(0) = ""
'### 2004/1/15 Added End
        
        '検査項目テーブルの登録
'## 2003.11.23 Modifed By H.Ishihara@FSIT 聖路加不要項目の削除
'        Ret = RegistItem_c_All(strMode, strItemCd, _
                                "00", RESULTTYPE_NUMERIC, _
                                ITEMTYPE_STANDARD, strRequestName, _
                                strRequestSName, strRequestName, _
                                "*", strItemCd, _
                                0, "", _
                                IIf(intRslQue = RSLQUE_Q, strRequestName, ""), "", _
                                "", "", _
                                "", "", _
                                True, 1, _
                                vntItemHNo, vntStrDate, _
                                vntEndDate, vntFigure1, _
                                vntFigure2, vntMaxValue, _
                                vntMinValue, vntInsItemCd, _
                                vntUnit, vntDefResult, _
                                vntDefRslCmtCd, _
                                0, vntItemHNo, _
                                vntKarteDocCd, vntKarteItemAttr, _
                                vntKarteItemcd, vntKarteItemName, _
                                vntKarteTagName, vntArrReqItemCd, vntArrSepOrderDiv, "", "", "", "", "", "")
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'        Ret = RegistItem_c_All(strMode, strItemCd, _
                                "00", RESULTTYPE_NUMERIC, _
                                ITEMTYPE_STANDARD, strRequestName, _
                                strRequestSName, strRequestName, _
                                "*", strItemCd, _
                                0, "", _
                                IIf(intRslQue = RSLQUE_Q, strRequestName, ""), "", _
                                "", "", _
                                "", "", _
                                True, 1, _
                                vntItemHNo, vntStrDate, _
                                vntEndDate, vntFigure1, _
                                vntFigure2, vntMaxValue, _
                                vntMinValue, vntInsItemCd, _
                                vntUnit, vntDefResult, _
                                vntDefRslCmtCd, vntArrReqItemCd, "")
        Ret = RegistItem_c_All(strMode, strItemCd, _
                                "00", RESULTTYPE_NUMERIC, _
                                ITEMTYPE_STANDARD, strRequestName, _
                                strRequestSName, strRequestName, _
                                "*", strItemCd, _
                                0, "", _
                                IIf(intRslQue = RSLQUE_Q, strRequestName, ""), "", _
                                "", "", _
                                "", "", _
                                True, 1, _
                                vntItemHNo, vntStrDate, _
                                vntEndDate, vntFigure1, _
                                vntFigure2, vntMaxValue, _
                                vntMinValue, vntInsItemCd, _
                                vntUnit, vntDefResult, _
                                vntDefRslCmtCd, vntArrReqItemCd, "", _
                                intCuTargetFlg, strOrderDiv, strBuiCode, strExplanation, _
                                vntInsSuffix, vnteUnit)
'### 2004/1/15 Modified End
'## 2003.11.23 Modifed End

'        Ret = INSERT_NORMAL
        Exit Do
    Loop
    
    '異常終了ならRollBack
    If Ret <> INSERT_NORMAL Then
        mobjContext.SetAbort
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistItem_p = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistItem_p = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Item.RegistItem_p"
    
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
' 機能　　 : 依頼項目単価テーブルを登録する
'
' 引数　　 : (In)    strItemCd      検査項目コード
' 　　　　   (In)    intItemCount   単価設定数
' 　　　　   (In)    vntExistsIsr   健保有無区分
' 　　　　   (In)    vntSeq         表示順番
' 　　　　   (In)    vntStrAge      開始年齢
' 　　　　   (In)    vntEndAge      終了年齢
' 　　　　   (In)    vntBsdPrice    団体負担金額
' 　　　　   (In)    vntIsrPrice    健保負担金額
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistItem_P_Price(ByVal strItemCd As String, _
                                   ByVal intItemCount As Integer, _
                                   ByVal vntExistsIsr As Variant, ByVal vntSeq As Variant, ByVal vntStrAge As Variant, ByVal vntEndAge As Variant, _
                                   ByVal vntBsdPrice As Variant, ByVal vntIsrPrice As Variant _
                                   ) As Long
                               
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objItemCd       As OraParamArray    '依頼項目コード
    Dim objExistsIsr    As OraParamArray    'SEQ
    Dim objSeq          As OraParamArray    'SEQ
    Dim objStrAge       As OraParamArray    '検査項目コード
    Dim objEndAge       As OraParamArray    'サフィックス
    Dim objBsdPrice     As OraParamArray    '団体負担金額
    Dim objIsrPrice     As OraParamArray    '健保負担金額

    Dim i           As Integer
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '依頼項目単価レコードの削除
    mobjOraDb.ExecuteSQL "DELETE ITEM_P_PRICE WHERE ITEMCD = :ITEMCD"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "ITEMCD"
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        objOraParam.AddTable "EXISTSISR", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_ITEM_P_PRICE_EXISTSISR
        objOraParam.AddTable "SEQ", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_ITEM_P_PRICE_SEQ
        objOraParam.AddTable "STRAGE", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_ITEM_P_PRICE_STRAGE
        objOraParam.AddTable "ENDAGE", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_ITEM_P_PRICE_ENDAGE
        objOraParam.AddTable "BSDPRICE", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_ITEM_P_PRICE_BSDPRICE
        objOraParam.AddTable "ISRPRICE", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_ITEM_P_PRICE_ISRPRICE
        
        'OraParameterオブジェクトの参照設定
        Set objItemCd = objOraParam("ITEMCD")
        Set objExistsIsr = objOraParam("EXISTSISR")
        Set objSeq = objOraParam("SEQ")
        Set objStrAge = objOraParam("STRAGE")
        Set objEndAge = objOraParam("ENDAGE")
        Set objBsdPrice = objOraParam("BSDPRICE")
        Set objIsrPrice = objOraParam("ISRPRICE")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objItemCd(i) = strItemCd
            objExistsIsr(i) = vntExistsIsr(i)
            objSeq(i) = vntSeq(i)
            objStrAge(i) = vntStrAge(i)
            objEndAge(i) = vntEndAge(i)
            objBsdPrice(i) = vntBsdPrice(i)
            objIsrPrice(i) = vntIsrPrice(i)
        Next i
        
        '新規挿入
        strStmt = "INSERT INTO ITEM_P_PRICE (ITEMCD, EXISTSISR, SEQ, STRAGE, ENDAGE, BSDPRICE, ISRPRICE) VALUES (:ITEMCD, :EXISTSISR, :SEQ, :STRAGE, :ENDAGE, :BSDPRICE, :ISRPRICE)"
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
        RegistItem_P_Price = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistItem_P_Price = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Item.RegistItem_P_Price"
    
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
' 機能　　 : 検査項目テーブルレコードを登録する（トランザクション対応）
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    stcItemCd          検査項目コード
' 　　　　   (In)    strSuffix          サフィックス
' 　　　　   (In)    intResultType      結果タイプ
' 　　　　   (In)    intItemType        項目タイプ
' 　　　　   (In)    strItemName        検査項目名
' 　　　　   (In)    strItemSName       検査項目略称
' 　　　　   (In)    strItemRName       報告書用項目名
' 　　　　   (In)    strSearchChar      ガイド検索用文字列
' 　　　　   (In)    strstcItemCd       文章参照用項目コード
' 　　　　   (In)    intRecentCount     最近使った文章管理数
' 　　　　   (In)    strItemEName       英語項目名
' 　　　　   (In)    strItemQName       問診文章
' 　　　　   (In)    strCollectCd       採取コード
' 　　　　   (In)    strContractCd      外注先コード
' 　　　　   (In)    strContractItemCd  外注結果コード
' 　　　　   (In)    strOldItemCd       旧検査項目コード
' 　　　　   (In)    strNoPrintFlg      報告書未出力フラグ
'
' 　　　　   -- 検査項目履歴管理テーブル関連
'
' 　　　　   (In)    blnEditItemHistory 検査項目履歴管理テーブルの更新有無(FALSEなら更新しない）
' 　　　　   (In)    intItemCount       検査項目履歴個数
' 　　　　   (In)    vntItemHNo         検査項目履歴Ｎｏ
' 　　　　   (In)    vntStrDate         使用開始日付
' 　　　　   (In)    vntEndDate         使用終了日付
' 　　　　   (In)    vntFigure1         整数部桁数
' 　　　　   (In)    vntFigure2         小数部桁数
' 　　　　   (In)    vntMaxValue        最大値
' 　　　　   (In)    vntMinValue        最小値
' 　　　　   (In)    vntInsItemCd       検査用項目コード
' 　　　　   (In)    vntUnit            単位
' 　　　　   (In)    vntDefResult       省略時検査結果
' 　　　　   (In)    vntDefRslCmtCd     省略時結果コメントコード
'
' 　　　　   -- 検査項目変換テーブル関連
'
' 　　　　   (In)    intKarteItemCount  電カル用項目コード更新数
' 　　　　   (In)    vntKarteItemHNo    電カル用項目コード
' 　　　　   (In)    vntKarteDocCd      電カル用文書種別コード
' 　　　　   (In)    vntKarteItemAttr   電カル用項目属性
' 　　　　   (In)    vntKarteItemcd     電カル用項目コード
' 　　　　   (In)    vntKarteItemName   電カル用項目名
' 　　　　   (In)    vntKarteTagName    電カル用タグ名称
'
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　   (In)    intCuTargetFlg     CU経年変化表示対象
' 　　　　   (In)    strOrderDiv        オーダ種別
' 　　　　   (In)    strBuiCode         部位コード
' 　　　　   (In)    strExplanation     項目説明
' 　　　　   (In)    vntInsSuffix       検査用サフィックス
' 　　　　   (In)    vnteUnit           英語単位
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　   (In)    vntHideInterview   面接非表示フラグ
'### 2004/1/29 Added End
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 : 検査項目テーブルと検査項目履歴管理テーブルを一度に更新
'
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
Public Function RegistItem_c_All(ByVal strMode As String, ByVal strItemCd As String, ByVal strSuffix As String, ByVal intResultType As Integer, _
                                 ByVal intItemType As Integer, ByVal strItemName As String, _
                                 ByVal strItemSName As String, ByVal strItemRName As String, _
                                 ByVal strSearchChar As String, ByVal strStcItemCd As String, _
                                 ByVal intRecentCount As Integer, ByVal strItemEName As String, _
                                 ByVal strItemQName As String, ByVal strCollectCd As String, _
                                 ByVal strContractCd As String, ByVal strContractItemCd As String, _
                                 ByVal strOldItemCd As String, ByVal strNoPrintFlg As String, _
                                 ByVal blnEditItemHistory As Boolean, ByVal intItemCount As Integer, _
                                 ByVal vntItemHNo As Variant, ByVal vntStrDate As Variant, ByVal vntEndDate As Variant, ByVal vntFigure1 As Variant, _
                                 ByVal vntFigure2 As Variant, ByVal vntMaxValue As Variant, ByVal vntMinValue As Variant, ByVal vntInsItemCd As Variant, _
                                 ByVal vntUnit As Variant, ByVal vntDefResult As Variant, ByVal vntDefRslCmtCd As Variant, ByVal vntReqItemCd As Variant, _
                                 ByVal vntMaterials As Variant, _
                                 ByVal intCuTargetFlg As Integer, ByVal strOrderDiv As String, ByVal strBuiCode As String, ByVal strExplanation As String, _
                                 ByVal vntInsSuffix As Variant, ByVal vnteUnit As Variant, Optional ByVal vntHideInterview As Variant = "0") As Long
'Public Function RegistItem_c_All(ByVal strMode As String, ByVal strItemCd As String, _
                                 ByVal strSuffix As String, ByVal intResultType As Integer, _
                                 ByVal intItemType As Integer, ByVal strItemName As String, _
                                 ByVal strItemSName As String, ByVal strItemRName As String, _
                                 ByVal strSearchChar As String, ByVal strStcItemCd As String, _
                                 ByVal intRecentCount As Integer, ByVal strItemEName As String, _
                                 ByVal strItemQName As String, ByVal strCollectCd As String, _
                                 ByVal strContractCd As String, ByVal strContractItemCd As String, _
                                 ByVal strOldItemCd As String, ByVal strNoPrintFlg As String, _
                                 ByVal blnEditItemHistory As Boolean, ByVal intItemCount As Integer, _
                                 ByVal vntItemHNo As Variant, ByVal vntStrDate As Variant, _
                                 ByVal vntEndDate As Variant, ByVal vntFigure1 As Variant, _
                                 ByVal vntFigure2 As Variant, ByVal vntMaxValue As Variant, _
                                 ByVal vntMinValue As Variant, ByVal vntInsItemCd As Variant, _
                                 ByVal vntUnit As Variant, ByVal vntDefResult As Variant, _
                                 ByVal vntDefRslCmtCd As Variant, _
                                 ByVal intKarteItemCount As Variant, ByVal vntKarteItemHNo As Variant, _
                                 ByVal vntKarteDocCd As Variant, ByVal vntKarteItemAttr As Variant, _
                                 ByVal vntKarteItemcd As Variant, ByVal vntKarteItemName As Variant, _
                                 ByVal vntKarteTagName As Variant, ByVal vntReqItemCd As Variant, _
                                 ByVal vntSepOrderDiv As Variant, _
                                 ByVal vntCollectTubeCd As Variant, ByVal vntMaterials As Variant, _
                                 ByVal vntLabelMark As Variant, ByVal vntWsCd As Variant, _
                                 ByVal vntLoadCd1 As Variant, ByVal vntLoadCd2 As Variant _
                                 ) As Long


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret         As Long             '関数戻り値
    
    Ret = INSERT_ERROR
    RegistItem_c_All = INSERT_ERROR
    
    Do
        
        '検査項目テーブルの更新
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'        Ret = RegistItem_c(strMode, _
                           strItemCd, _
                           strSuffix, _
                           intResultType, _
                           intItemType, _
                           strItemName, _
                           strItemSName, _
                           strItemRName, _
                           strSearchChar, _
                           strStcItemCd, _
                           intRecentCount, _
                           strItemEName, _
                           strItemQName, _
                           strCollectCd, _
                           strContractCd, _
                           strContractItemCd, _
                           strOldItemCd, _
                           strNoPrintFlg, _
                           vntCollectTubeCd, _
                           vntMaterials, _
                           vntLabelMark, _
                           vntWsCd, _
                           vntLoadCd1, _
                           vntLoadCd2)
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'        Ret = RegistItem_c(strMode, _
                           strItemCd, _
                           strSuffix, _
                           intResultType, _
                           intItemType, _
                           strItemName, _
                           strItemSName, _
                           strItemRName, _
                           strSearchChar, _
                           strStcItemCd, _
                           intRecentCount, _
                           strItemEName, _
                           strItemQName, _
                           strCollectCd, _
                           strContractCd, _
                           strContractItemCd, _
                           strOldItemCd, _
                           strNoPrintFlg, _
                           vntMaterials)
        Ret = RegistItem_c(strMode, _
                           strItemCd, _
                           strSuffix, _
                           intResultType, _
                           intItemType, _
                           strItemName, _
                           strItemSName, _
                           strItemRName, _
                           strSearchChar, _
                           strStcItemCd, _
                           intRecentCount, _
                           strItemEName, _
                           strItemQName, _
                           strCollectCd, _
                           strContractCd, _
                           strContractItemCd, _
                           strOldItemCd, _
                           strNoPrintFlg, _
                           vntMaterials, _
                           intCuTargetFlg, _
                           strOrderDiv, _
                           strBuiCode, _
                           strExplanation, _
                           vntHideInterview)
'### 2004/1/15 Modified End
'## 2003.11.23 Modified End
        
        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        If blnEditItemHistory = True Then
        
            '検査項目履歴管理テーブルの更新
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'            Ret = RegistItemHistory(strItemCd, _
                                    strSuffix, _
                                    intItemCount, _
                                    vntItemHNo, _
                                    vntStrDate, _
                                    vntEndDate, _
                                    vntFigure1, _
                                    vntFigure2, _
                                    vntMaxValue, _
                                    vntMinValue, _
                                    vntInsItemCd, _
                                    vntUnit, _
                                    vntDefResult, _
                                    vntDefRslCmtCd, _
                                    vntReqItemCd, _
                                    vntSepOrderDiv)
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'            Ret = RegistItemHistory(strItemCd, _
                                    strSuffix, _
                                    intItemCount, _
                                    vntItemHNo, _
                                    vntStrDate, _
                                    vntEndDate, _
                                    vntFigure1, _
                                    vntFigure2, _
                                    vntMaxValue, _
                                    vntMinValue, _
                                    vntInsItemCd, _
                                    vntUnit, _
                                    vntDefResult, _
                                    vntDefRslCmtCd, _
                                    vntReqItemCd)
            Ret = RegistItemHistory(strItemCd, _
                                    strSuffix, _
                                    intItemCount, _
                                    vntItemHNo, _
                                    vntStrDate, _
                                    vntEndDate, _
                                    vntFigure1, _
                                    vntFigure2, _
                                    vntMaxValue, _
                                    vntMinValue, _
                                    vntInsItemCd, _
                                    vntUnit, _
                                    vntDefResult, _
                                    vntDefRslCmtCd, _
                                    vntReqItemCd, _
                                    vntInsSuffix, _
                                    vnteUnit)
'### 2004/1/15 Modified End
'## 2003.11.23 Modified End

            '異常終了なら処理終了
            If Ret <> INSERT_NORMAL Then
                Exit Do
            End If
        
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'            '検査項目変換テーブルの更新
'            Ret = RegistKarteItem(strItemCd, _
'                                  strSuffix, _
'                                  intKarteItemCount, _
'                                  vntKarteItemHNo, _
'                                  vntKarteDocCd, _
'                                  vntKarteItemAttr, _
'                                  vntKarteItemcd, _
'                                  vntKarteItemName, _
'                                  vntKarteTagName)
'
'            '異常終了なら処理終了
'            If Ret <> INSERT_NORMAL Then
'                Exit Do
'            End If
'## 2003.11.23 Deleted End
        
        End If
        
        Exit Do
    Loop
 
    If Ret = INSERT_NORMAL Then
        '正常ならCommit これはRootトランザクションなのでCommit
        mobjContext.SetComplete
    Else
        '異常終了ならRollBack
        mobjContext.SetAbort
    End If
 
    '戻り値の設定
    RegistItem_c_All = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistItem_c_All = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Item.RegistItem_c_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 検査項目テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    stcItemCd          検査項目コード
' 　　　　   (In)    strSuffix          サフィックス
' 　　　　   (In)    intResultType      結果タイプ
' 　　　　   (In)    intItemType        項目タイプ
' 　　　　   (In)    strItemName        検査項目名
' 　　　　   (In)    strItemSName       検査項目略称
' 　　　　   (In)    strItemRName       報告書用項目名
' 　　　　   (In)    strSearchChar      ガイド検索用文字列
' 　　　　   (In)    strstcItemCd       文章参照用項目コード
' 　　　　   (In)    intRecentCount     最近使った文章管理数
' 　　　　   (In)    strItemEName       英語項目名
' 　　　　   (In)    strItemQName       問診文章
' 　　　　   (In)    strCollectCd       採取コード
' 　　　　   (In)    strContractCd      外注先コード
' 　　　　   (In)    strContractItemCd  外注結果コード
' 　　　　   (In)    strOldItemCd       単価２
' 　　　　   (In)    strNoPrintFlg      報告書未出力フラグ
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　   (In)    intCuTargetFlg     CU経年変化表示対象
' 　　　　   (In)    strOrderDiv        オーダ種別
' 　　　　   (In)    strBuiCode         部位コード
' 　　　　   (In)    strExplanation     項目説明
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　   (In)    vntHideInterview   面接支援非表示フラグ
'### 2004/1/29 Added End
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
Public Function RegistItem_c(ByVal strMode As String, ByVal stcItemCd As String, _
                             ByVal strSuffix As String, ByVal intResultType As Integer, _
                             ByVal intItemType As Integer, ByVal strItemName As String, _
                             ByVal strItemSName As String, ByVal strItemRName As String, _
                             ByVal strSearchChar As String, ByVal strStcItemCd As String, _
                             ByVal intRecentCount As Integer, ByVal strItemEName As String, _
                             ByVal strItemQName As String, ByVal strCollectCd As String, _
                             ByVal strContractCd As String, ByVal strContractItemCd As String, _
                             ByVal strOldItemCd As String, ByVal strNoPrintFlg As String, _
                             ByVal vntMaterials As Variant, _
                             ByVal intCuTargetFlg As Integer, ByVal strOrderDiv As String, ByVal strBuiCode As String, ByVal strExplanation As String, Optional ByVal vntHideInterview As Variant = "0") As Long
'Public Function RegistItem_c(ByVal strMode As String, _
                             ByVal stcItemCd As String, _
                             ByVal strSuffix As String, _
                             ByVal intResultType As Integer, _
                             ByVal intItemType As Integer, _
                             ByVal strItemName As String, _
                             ByVal strItemSName As String, _
                             ByVal strItemRName As String, _
                             ByVal strSearchChar As String, _
                             ByVal strStcItemCd As String, _
                             ByVal intRecentCount As Integer, _
                             ByVal strItemEName As String, _
                             ByVal strItemQName As String, _
                             ByVal strCollectCd As String, _
                             ByVal strContractCd As String, _
                             ByVal strContractItemCd As String, _
                             ByVal strOldItemCd As String, _
                             ByVal strNoPrintFlg As String, _
                             ByVal vntCollectTubeCd As Variant, _
                             ByVal vntMaterials As Variant, _
                             ByVal vntLabelMark As Variant, _
                             ByVal vntWsCd As Variant, _
                             ByVal vntLoadCd1 As Variant, _
                             ByVal vntLoadCd2 As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "ITEMCD", Trim(stcItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RESULTTYPE", Trim(intResultType), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMTYPE", Trim(intItemType), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMNAME", Trim(strItemName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMSNAME", Trim(strItemSName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMRNAME", Trim(strItemRName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHAR", Trim(strSearchChar), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STCITEMCD", Trim(strStcItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RECENTCOUNT", Trim(intRecentCount), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMENAME", Trim(strItemEName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMQNAME", Trim(strItemQName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "COLLECTCD", Trim(strCollectCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTRACTCD", Trim(strContractCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTRACTITEMCD", Trim(strContractItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OLDITEMCD", Trim(strOldItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOPRINTFLG", Trim(strNoPrintFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MATERIALS", Trim(vntMaterials), ORAPARM_INPUT, ORATYPE_VARCHAR2

'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'    objOraParam.Add "COLLECTTUBECD", Trim(vntCollectTubeCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "LABELMARK", Trim(vntLabelMark), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "WSCD", Trim(vntWsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "LOADCD1", Trim(vntLoadCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "LOADCD2", Trim(vntLoadCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.11.23 Modified End

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    objOraParam.Add "CUTARGETFLG", intCuTargetFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORDERDIV", Trim(strOrderDiv), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BUICODE", Trim(strBuiCode), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EXPLANATION", Trim(strExplanation), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加

'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
    objOraParam.Add "HIDEINTERVIEW", CInt(vntHideInterview), ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004/1/29 Added End

    Do
        '検査項目テーブルレコードの更新
        If strMode = "UPD" Then
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'            strStmt = "UPDATE ITEM_C SET RESULTTYPE     = :RESULTTYPE," & vbLf & _
                      "                  ITEMTYPE       = :ITEMTYPE," & vbLf & _
                      "                  ITEMNAME       = :ITEMNAME," & vbLf & _
                      "                  ITEMSNAME      = :ITEMSNAME," & vbLf & _
                      "                  ITEMRNAME      = :ITEMRNAME," & vbLf & _
                      "                  SEARCHCHAR     = :SEARCHCHAR," & vbLf & _
                      "                  STCITEMCD      = :STCITEMCD," & vbLf & _
                      "                  RECENTCOUNT    = :RECENTCOUNT," & vbLf & _
                      "                  ITEMENAME      = :ITEMENAME," & vbLf & _
                      "                  ITEMQNAME      = :ITEMQNAME," & vbLf & _
                      "                  COLLECTCD      = :COLLECTCD," & vbLf & _
                      "                  CONTRACTCD     = :CONTRACTCD," & vbLf & _
                      "                  CONTRACTITEMCD = :CONTRACTITEMCD," & vbLf & _
                      "                  OLDITEMCD      = :OLDITEMCD," & vbLf & _
                      "                  NOPRINTFLG     = :NOPRINTFLG," & vbLf & _
                      "                  COLLECTTUBECD  = :COLLECTTUBECD," & vbLf & _
                      "                  MATERIALS      = :MATERIALS    ," & vbLf & _
                      "                  LABELMARK      = :LABELMARK    ," & vbLf & _
                      "                  WSCD           = :WSCD         ," & vbLf & _
                      "                  LOADCD1        = :LOADCD1      ," & vbLf & _
                      "                  LOADCD2        = :LOADCD2      " & vbLf & _
                      " WHERE ITEMCD = :ITEMCD" & vbLf & _
                      "   AND SUFFIX = :SUFFIX"
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'            strStmt = "UPDATE ITEM_C SET RESULTTYPE     = :RESULTTYPE," & vbLf & _
                      "                  ITEMTYPE       = :ITEMTYPE," & vbLf & _
                      "                  ITEMNAME       = :ITEMNAME," & vbLf & _
                      "                  ITEMSNAME      = :ITEMSNAME," & vbLf & _
                      "                  ITEMRNAME      = :ITEMRNAME," & vbLf & _
                      "                  SEARCHCHAR     = :SEARCHCHAR," & vbLf & _
                      "                  STCITEMCD      = :STCITEMCD," & vbLf & _
                      "                  RECENTCOUNT    = :RECENTCOUNT," & vbLf & _
                      "                  ITEMENAME      = :ITEMENAME," & vbLf & _
                      "                  ITEMQNAME      = :ITEMQNAME," & vbLf & _
                      "                  COLLECTCD      = :COLLECTCD," & vbLf & _
                      "                  CONTRACTCD     = :CONTRACTCD," & vbLf & _
                      "                  CONTRACTITEMCD = :CONTRACTITEMCD," & vbLf & _
                      "                  OLDITEMCD      = :OLDITEMCD," & vbLf & _
                      "                  NOPRINTFLG     = :NOPRINTFLG," & vbLf & _
                      "                  MATERIALS      = :MATERIALS    " & vbLf & _
                      " WHERE ITEMCD = :ITEMCD" & vbLf & _
                      "   AND SUFFIX = :SUFFIX"
'### 2004/1/29 Modified by Ishihara@FSIT 聖路加項目の追加
'            strStmt = "UPDATE ITEM_C SET RESULTTYPE     = :RESULTTYPE,     " & vbLf & _
                      "                  ITEMTYPE       = :ITEMTYPE,       " & vbLf & _
                      "                  ITEMNAME       = :ITEMNAME,       " & vbLf & _
                      "                  ITEMSNAME      = :ITEMSNAME,      " & vbLf & _
                      "                  ITEMRNAME      = :ITEMRNAME,      " & vbLf & _
                      "                  SEARCHCHAR     = :SEARCHCHAR,     " & vbLf & _
                      "                  STCITEMCD      = :STCITEMCD,      " & vbLf & _
                      "                  RECENTCOUNT    = :RECENTCOUNT,    " & vbLf & _
                      "                  ITEMENAME      = :ITEMENAME,      " & vbLf & _
                      "                  ITEMQNAME      = :ITEMQNAME,      " & vbLf & _
                      "                  COLLECTCD      = :COLLECTCD,      " & vbLf & _
                      "                  CONTRACTCD     = :CONTRACTCD,     " & vbLf & _
                      "                  CONTRACTITEMCD = :CONTRACTITEMCD, " & vbLf & _
                      "                  OLDITEMCD      = :OLDITEMCD,      " & vbLf & _
                      "                  NOPRINTFLG     = :NOPRINTFLG,     " & vbLf & _
                      "                  MATERIALS      = :MATERIALS,      " & vbLf & _
                      "                  CUTARGETFLG    = :CUTARGETFLG,    " & vbLf & _
                      "                  ORDERDIV       = :ORDERDIV,       " & vbLf & _
                      "                  BUICODE        = :BUICODE,        " & vbLf & _
                      "                  EXPLANATION    = :EXPLANATION     " & vbLf & _
                      " WHERE ITEMCD = :ITEMCD" & vbLf & _
                      "   AND SUFFIX = :SUFFIX"
            strStmt = "UPDATE ITEM_C SET RESULTTYPE     = :RESULTTYPE,     " & vbLf & _
                      "                  ITEMTYPE       = :ITEMTYPE,       " & vbLf & _
                      "                  ITEMNAME       = :ITEMNAME,       " & vbLf & _
                      "                  ITEMSNAME      = :ITEMSNAME,      " & vbLf & _
                      "                  ITEMRNAME      = :ITEMRNAME,      " & vbLf & _
                      "                  SEARCHCHAR     = :SEARCHCHAR,     " & vbLf & _
                      "                  STCITEMCD      = :STCITEMCD,      " & vbLf & _
                      "                  RECENTCOUNT    = :RECENTCOUNT,    " & vbLf & _
                      "                  ITEMENAME      = :ITEMENAME,      " & vbLf & _
                      "                  ITEMQNAME      = :ITEMQNAME,      " & vbLf & _
                      "                  COLLECTCD      = :COLLECTCD,      " & vbLf & _
                      "                  CONTRACTCD     = :CONTRACTCD,     " & vbLf & _
                      "                  CONTRACTITEMCD = :CONTRACTITEMCD, " & vbLf & _
                      "                  OLDITEMCD      = :OLDITEMCD,      " & vbLf & _
                      "                  NOPRINTFLG     = :NOPRINTFLG,     " & vbLf & _
                      "                  MATERIALS      = :MATERIALS,      " & vbLf & _
                      "                  CUTARGETFLG    = :CUTARGETFLG,    " & vbLf & _
                      "                  ORDERDIV       = :ORDERDIV,       " & vbLf & _
                      "                  BUICODE        = :BUICODE,        " & vbLf & _
                      "                  EXPLANATION    = :EXPLANATION,    " & vbLf & _
                      "                  HIDEINTERVIEW  = :HIDEINTERVIEW   " & vbLf & _
                      " WHERE ITEMCD = :ITEMCD" & vbLf & _
                      "   AND SUFFIX = :SUFFIX"
'### 2004/1/29 Modified End
'### 2004/1/15 Modified End
'## 2003.11.23 Modified End
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす検査項目テーブルのレコードを取得
        strStmt = "SELECT ITEMCD FROM ITEM_C WHERE ITEMCD = :ITEMCD AND SUFFIX = :SUFFIX"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'        strStmt = "INSERT INTO ITEM_C" & vbLf & _
                  "       ( ITEMCD,  SUFFIX, RESULTTYPE, ITEMTYPE, ITEMNAME, ITEMSNAME, ITEMRNAME, SEARCHCHAR, STCITEMCD, RECENTCOUNT, ITEMENAME, ITEMQNAME, COLLECTCD, CONTRACTCD, CONTRACTITEMCD, OLDITEMCD,  NOPRINTFLG,  COLLECTTUBECD,  MATERIALS,  LABELMARK,  WSCD,  LOADCD1,  LOADCD2 )" & vbLf & _
                  "VALUES ( :ITEMCD,:SUFFIX,:RESULTTYPE,:ITEMTYPE,:ITEMNAME,:ITEMSNAME,:ITEMRNAME,:SEARCHCHAR,:STCITEMCD,:RECENTCOUNT,:ITEMENAME,:ITEMQNAME,:COLLECTCD,:CONTRACTCD,:CONTRACTITEMCD,:OLDITEMCD, :NOPRINTFLG, :COLLECTTUBECD, :MATERIALS, :LABELMARK, :WSCD, :LOADCD1, :LOADCD2 )"
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'        strStmt = "INSERT INTO ITEM_C" & vbLf & _
                  "       ( ITEMCD,  SUFFIX, RESULTTYPE, ITEMTYPE, ITEMNAME, ITEMSNAME, ITEMRNAME, SEARCHCHAR, STCITEMCD, RECENTCOUNT, ITEMENAME, ITEMQNAME, COLLECTCD, CONTRACTCD, CONTRACTITEMCD, OLDITEMCD,  NOPRINTFLG,  MATERIALS )" & vbLf & _
                  "VALUES ( :ITEMCD,:SUFFIX,:RESULTTYPE,:ITEMTYPE,:ITEMNAME,:ITEMSNAME,:ITEMRNAME,:SEARCHCHAR,:STCITEMCD,:RECENTCOUNT,:ITEMENAME,:ITEMQNAME,:COLLECTCD,:CONTRACTCD,:CONTRACTITEMCD,:OLDITEMCD, :NOPRINTFLG, :MATERIALS )"
'### 2004/1/29 Modified by Ishihara@FSIT 聖路加項目の追加
'        strStmt = "INSERT INTO ITEM_C" & vbLf & _
                  "       ( ITEMCD,  SUFFIX, RESULTTYPE, ITEMTYPE, ITEMNAME, ITEMSNAME, ITEMRNAME, SEARCHCHAR, STCITEMCD, RECENTCOUNT, ITEMENAME, ITEMQNAME, COLLECTCD, CONTRACTCD, CONTRACTITEMCD, OLDITEMCD,  NOPRINTFLG,  MATERIALS,  CUTARGETFLG,  ORDERDIV,  BUICODE,  EXPLANATION )" & vbLf & _
                  "VALUES ( :ITEMCD,:SUFFIX,:RESULTTYPE,:ITEMTYPE,:ITEMNAME,:ITEMSNAME,:ITEMRNAME,:SEARCHCHAR,:STCITEMCD,:RECENTCOUNT,:ITEMENAME,:ITEMQNAME,:COLLECTCD,:CONTRACTCD,:CONTRACTITEMCD,:OLDITEMCD, :NOPRINTFLG, :MATERIALS, :CUTARGETFLG, :ORDERDIV, :BUICODE, :EXPLANATION )"
        strStmt = "INSERT INTO ITEM_C" & vbLf & _
                  "       ( ITEMCD,  SUFFIX, RESULTTYPE, ITEMTYPE, ITEMNAME, ITEMSNAME, ITEMRNAME, SEARCHCHAR, STCITEMCD, RECENTCOUNT, ITEMENAME, ITEMQNAME, COLLECTCD, CONTRACTCD, CONTRACTITEMCD, OLDITEMCD,  NOPRINTFLG,  MATERIALS,  CUTARGETFLG,  ORDERDIV,  BUICODE,  EXPLANATION,  HIDEINTERVIEW )" & vbLf & _
                  "VALUES ( :ITEMCD,:SUFFIX,:RESULTTYPE,:ITEMTYPE,:ITEMNAME,:ITEMSNAME,:ITEMRNAME,:SEARCHCHAR,:STCITEMCD,:RECENTCOUNT,:ITEMENAME,:ITEMQNAME,:COLLECTCD,:CONTRACTCD,:CONTRACTITEMCD,:OLDITEMCD, :NOPRINTFLG, :MATERIALS, :CUTARGETFLG, :ORDERDIV, :BUICODE, :EXPLANATION, :HIDEINTERVIEW )"
'### 2004/1/29 Modified End
'### 2004/1/15 Modified End
'## 2003.11.23 Modified End

        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        Ret = INSERT_NORMAL
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistItem_c = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistItem_c = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Item.RegistItem_c"
    
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
' 機能　　 : 検査分類テーブルレコードを削除する
'
' 引数　　 : (In)    strItemClassCd    検査分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteItemClass(ByVal strItemClassCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ItemClassCD", Trim(strItemClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検査分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE ITEMCLASS WHERE CLASSCD = :ItemClassCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteItemClass = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteItemClass = False

    'イベントログ書き込み
    WriteErrorLog "Item.DeleteItemClass"
    
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
' 機能　　 : 依頼項目テーブルレコードを削除する
'
' 引数　　 : (In)    strItemCd    依頼項目コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteItem_p(ByVal strItemCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ItemCd", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '依頼項目テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE ITEM_P WHERE ITEMCD = :ITEMCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteItem_p = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteItem_p = False

    'イベントログ書き込み
    WriteErrorLog "Item.DeleteItem_p"
    
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
' 機能　　 : 依頼項目テーブルレコードを削除する
'
' 引数　　 : (In)    strItemCd    依頼項目コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteItem_p_Price(ByVal strItemCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ItemCd", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '依頼項目テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE ITEM_P_PRICE WHERE ITEMCD = :ITEMCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteItem_p_Price = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteItem_p_Price = False

    'イベントログ書き込み
    WriteErrorLog "Item.DeleteItem_p_Price"
    
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
' 機能　　 : 検査項目テーブルレコードを削除する
'
' 引数　　 : (In)    strItemCd    検査項目コード
' 　　　　 : (In)    strSuffix    サフィックス
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteItem_c(ByVal strItemCd As String, _
                             ByVal strSuffix As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '依頼項目テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE ITEM_C WHERE ITEMCD = :ITEMCD AND SUFFIX = :SUFFIX"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteItem_c = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteItem_c = False

    'イベントログ書き込み
    WriteErrorLog "Item.DeleteItem_c"
    
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
' 機能　　 : 検索条件を満たす依頼項目名の一覧を取得する
'
' 引数　　 : (In)     vntClassCdKey             検査分類コードキー
' 　　　　 : (In)     vntSearchCharKey          ガイド検索用文字列キー
' 　　　　 : (In)     vntQuestionKey            問診結果表示有無キー
' 　　　　 : (Out)    vntItemCd                 検査項目コード
' 　　　　 : (Out)    vntSuffix                 サフィックス(ダミー：空白固定)
' 　　　　 : (Out)    vntRequestName            検査項目名称
' 　　　　 : (Out)    vntRslQue                 結果問診フラグ（省略可）
' 　　　　 : (Out)    vntClassName              検査分類名称（省略可）
' 　　　　 : (Out)    vntProgressName           進捗分類名（省略可）
' 　　　　 : (Out)    vntEntryOk                未入力チェック（省略可）
' 　　　　 : (Out)    vntSearchChar             ガイド検索文字列（省略可）
' 　　　　 : (Out)    vntOpeClassName           検査実施日分類（省略可）
' 　　　　 : (Out)    vntPrice1                 単価１（省略可）
' 　　　　 : (Out)    vntPrice2                 単価２（省略可）
' 　　　　 : (In)     vntSearchCode             検索用コード（省略可）
' 　　　　 : (In)     vntSearchString           検索用文字列（省略可）
' 　　　　 : (Out)    vntDmdLineClassName       請求明細分類名
' 　　　　 : (Out)    vntIsrDmdLineClassName    健保請求明細分類名
' 　　　　 : (Out)    vntRoundClassName         まるめ分類名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectItem_pList(ByVal vntClassCdKey As Variant, _
                                 ByVal vntSearchCharKey As Variant, _
                                 ByVal vntQuestionKey As Variant, _
                                 ByRef vntItemCd As Variant, _
                                 ByRef vntSuffix As Variant, _
                                 ByRef vntRequestName As Variant, _
                                 Optional ByRef vntRslQue As Variant, _
                                 Optional ByRef vntClassName As Variant, _
                                 Optional ByRef vntProgressName As Variant, _
                                 Optional ByRef vntEntryOk As Variant, _
                                 Optional ByRef vntSearchChar As Variant, _
                                 Optional ByRef vntOpeClassName As Variant, _
                                 Optional ByRef vntPrice1 As Variant, _
                                 Optional ByRef vntPrice2 As Variant, _
                                 Optional ByVal vntSearchCode As Variant, _
                                 Optional ByVal vntSearchString As Variant, _
                                 Optional ByRef vntDmdLineClassName As Variant, _
                                 Optional ByRef vntIsrDmdLineClassName As Variant, _
                                 Optional ByRef vntRoundClassName As Variant _
                                 ) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    Dim blnClassCd              As Boolean          '検査分類コードの条件文がセットされた時、TRUE
    Dim blnSearchChar           As Boolean          '検索用文字列の条件文がセットされた時、TRUE
    Dim strSearchCharW          As String           '検索文字(全角)
    Dim strSearchCharN          As String           '検索文字(半角)
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objItemCd               As OraField         '検査項目コード
    Dim objRequestName          As OraField         '検査項目名称
    Dim objRslQue               As OraField         '結果問診フラグ
    Dim objClassName            As OraField         '検査分類名称
    Dim objProgressName         As OraField         '進捗分類名
    Dim objEntryOk              As OraField         '未入力チェック
    Dim objSearchChar           As OraField         'ガイド検索文字列
    Dim objOpeClassName         As OraField         '検査実施日分類
    Dim objPrice1               As OraField         '単価１
    Dim objPrice2               As OraField         '単価２
    Dim objDmdLineClassName     As OraField         '請求明細分類名
    Dim objIsrDmdLineClassName  As OraField         '健保請求明細分類名
    Dim objRoundClassName       As OraField         'まるめ分類名
    
    Dim vntArrItemCd()          As Variant          '検査項目コードの配列
    Dim vntArrSuffix()          As Variant          'サフィックスの配列
    Dim vntArrRequestName()     As Variant          '検査項目名称の配列
    Dim vntArrRslQue()          As Variant          '結果問診フラグの配列
    Dim vntArrClassName()       As Variant          '検査分類名称の配列
    Dim vntArrProgressName()    As Variant          '進捗分類名
    Dim vntArrEntryOk()         As Variant          '未入力チェック
    Dim vntArrSearchChar()      As Variant          'ガイド検索文字列
    Dim vntArrOpeClassName()    As Variant          '検査実施日分類
    Dim vntArrPrice1()          As Variant          '単価１
    Dim vntArrPrice2()          As Variant          '単価２
    
    Dim vntArrDmdLineClassName()        As Variant
    Dim vntArrIsrDmdLineClassName()     As Variant
    Dim vntArrRoundClassName()          As Variant

    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemCd = Empty
    vntSuffix = Empty
    vntRequestName = Empty
    vntClassName = Empty

    '問診項目表示有無条件が設定されていない場合はエラー
    If Not (vntQuestionKey = ITEM_NOTDISP Or vntQuestionKey = ITEM_DISP) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLASSCD", Trim(vntClassCdKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHARW", Trim(strSearchCharW), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHARN", Trim(strSearchCharN), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSLQUE", RSLQUE_R, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
'    strStmt = "SELECT ITEM_P.ITEMCD,  ITEM_P.REQUESTNAME, ITEM_P.RSLQUE, ITEMCLASS.CLASSNAME, PROGRESS.PROGRESSNAME," & vbLf & _
'              "       ITEM_P.ENTRYOK, ITEM_P.SEARCHCHAR, OPECLASS.OPECLASSNAME, ITEM_P.PRICE1, ITEM_P.PRICE2" & vbLf & _
'              "  FROM ITEM_P, ITEMCLASS, PROGRESS, OPECLASS" & vbLf & _
'              " WHERE ITEM_P.CLASSCD = ITEMCLASS.CLASSCD" & vbLf & _
'              "   AND ITEM_P.PROGRESSCD = PROGRESS.PROGRESSCD" & vbLf & _
'              "   AND ITEM_P.OPECLASSCD = OPECLASS.OPECLASSCD(+)" & vbLf
'    strStmt = "SELECT ITEM_P.ITEMCD,  ITEM_P.REQUESTNAME, ITEM_P.RSLQUE, ITEMCLASS.CLASSNAME, PROGRESS.PROGRESSNAME," & vbLf & _
'              "       ITEM_P.ENTRYOK, ITEM_P.SEARCHCHAR, OPECLASS.OPECLASSNAME, ITEM_P.PRICE1, ITEM_P.PRICE2, " & vbLf & _
'              "       DMDLINECLASS.DMDLINECLASSNAME DMDLINECLASSNAME, ISRDMDLINECLASS.DMDLINECLASSNAME ISRDMDLINECLASSNAME, ROUNDCLASS.ROUNDCLASSNAME" & vbLf & _
'              "  FROM DMDLINECLASS DMDLINECLASS, DMDLINECLASS ISRDMDLINECLASS, ROUNDCLASS," & vbLf & _
'              "       ITEM_P, ITEMCLASS, PROGRESS, OPECLASS" & vbLf & _
'              " WHERE ITEM_P.CLASSCD           = ITEMCLASS.CLASSCD" & vbLf & _
'              "   AND ITEM_P.PROGRESSCD        = PROGRESS.PROGRESSCD" & vbLf & _
'              "   AND ITEM_P.OPECLASSCD        = OPECLASS.OPECLASSCD(+)" & vbLf & _
'              "   AND ITEM_P.DMDLINECLASSCD    = DMDLINECLASS.DMDLINECLASSCD(+)" & vbLf & _
'              "   AND ITEM_P.ISRDMDLINECLASSCD = ISRDMDLINECLASS.DMDLINECLASSCD(+)" & vbLf & _
'              "   AND ITEM_P.ROUNDCLASSCD      = ROUNDCLASS.ROUNDCLASSCD(+)" & vbLf
    strStmt = "SELECT ITEM_P.ITEMCD,  ITEM_P.REQUESTNAME, ITEM_P.RSLQUE, ITEMCLASS.CLASSNAME, PROGRESS.PROGRESSNAME," & vbLf & _
              "       ITEM_P.ENTRYOK, ITEM_P.SEARCHCHAR, OPECLASS.OPECLASSNAME " & vbLf & _
              "  FROM ITEM_P, ITEMCLASS, PROGRESS, OPECLASS" & vbLf & _
              " WHERE ITEM_P.CLASSCD           = ITEMCLASS.CLASSCD" & vbLf & _
              "   AND ITEM_P.PROGRESSCD        = PROGRESS.PROGRESSCD" & vbLf & _
              "   AND ITEM_P.OPECLASSCD        = OPECLASS.OPECLASSCD(+)"

    'WHERE句の編集
    If Not ((vntClassCdKey = "") And (vntSearchCharKey = "") And (vntQuestionKey <> ITEM_NOTDISP)) Then
    
        strStmt = strStmt & " AND " & vbLf
    
        '条件セットフラグをFALSEにセット
        blnClassCd = False
        '検査分類コードキーの編集
        If Not (vntClassCdKey = "") Then
            '検索キー値を編集
            strStmt = strStmt & "ITEM_P.CLASSCD = :CLASSCD "
            '条件セットフラグをTRUEへ
            blnClassCd = True
        End If
    
        '条件セットフラグをFALSEにセット
        blnSearchChar = False
        'ガイド検索用文字列キーの編集
        If Not (vntSearchCharKey = "") Then
            '全角・半角両方に対応するよう変換
            strSearchCharW = StrConv(vntSearchCharKey, vbWide)
            strSearchCharN = StrConv(vntSearchCharKey, vbNarrow)
            'キー値の再設定
            objOraParam("SEARCHCHARW").Value = Trim(strSearchCharW)
            objOraParam("SEARCHCHARN").Value = Trim(strSearchCharN)
            '検査分類コードキーがセットされていれば条件節はANDで連結
            If (blnClassCd) Then
                strStmt = strStmt & vbLf & _
                          "   AND "
            End If
            '検索キー値を編集
            strStmt = strStmt & "ITEM_P.SEARCHCHAR IN ( :SEARCHCHARW, :SEARCHCHARN ) "
            '条件セットフラグをTRUEへ
            blnSearchChar = True
        End If

        '問診結果の編集
        If vntQuestionKey = ITEM_NOTDISP Then
            '問診結果を表示しないときは検査結果項目のみ抽出
            '検査分類コードキーかガイド検索文字列キーがセットされていれば条件節はANDで連結
            If (blnClassCd Or blnSearchChar) Then
                strStmt = strStmt & vbLf & _
                          "   AND "
            End If
            '検索キー値を編集
            strStmt = strStmt & "ITEM_P.RSLQUE = :RSLQUE "
        End If
    
    End If
    
    '検索用文字列の設定（マスタメンテ用？）
    If IsMissing(vntSearchCode) = False Then
        If Trim(vntSearchCode) <> "" Then
            strStmt = strStmt & " AND ITEM_P.ITEMCD LIKE '%" & vntSearchCode & "%'" & vbLf
        End If
    End If
                                 
    If IsMissing(vntSearchString) = False Then
        If Trim(vntSearchString) <> "" Then
            strStmt = strStmt & " AND ITEM_P.REQUESTNAME LIKE '%" & vntSearchString & "%'" & vbLf
        End If
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY ITEM_P.ITEMCD"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objRequestName = objFields("REQUESTNAME")
        Set objRslQue = objFields("RSLQUE")
        Set objClassName = objFields("CLASSNAME")
        Set objProgressName = objFields("PROGRESSNAME")
        Set objEntryOk = objFields("ENTRYOK")
        Set objSearchChar = objFields("SEARCHCHAR")
        Set objOpeClassName = objFields("OPECLASSNAME")
'        Set objPrice1 = objFields("PRICE1")
'        Set objPrice2 = objFields("PRICE2")
'        Set objDmdLineClassName = objFields("DMDLINECLASSNAME")
'        Set objIsrDmdLineClassName = objFields("ISRDMDLINECLASSNAME")
'        Set objRoundClassName = objFields("ROUNDCLASSNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrRequestName(lngCount)
            ReDim Preserve vntArrRslQue(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            ReDim Preserve vntArrProgressName(lngCount)
            ReDim Preserve vntArrEntryOk(lngCount)
            ReDim Preserve vntArrSearchChar(lngCount)
            ReDim Preserve vntArrOpeClassName(lngCount)
            ReDim Preserve vntArrPrice1(lngCount)
            ReDim Preserve vntArrPrice2(lngCount)
            ReDim Preserve vntArrDmdLineClassName(lngCount)
            ReDim Preserve vntArrIsrDmdLineClassName(lngCount)
            ReDim Preserve vntArrRoundClassName(lngCount)
            
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = DUMMY_SUFFIX
            vntArrRequestName(lngCount) = objRequestName.Value & ""
            vntArrRslQue(lngCount) = objRslQue.Value & ""
            vntArrClassName(lngCount) = objClassName.Value & ""
            vntArrProgressName(lngCount) = objProgressName.Value & ""
            vntArrEntryOk(lngCount) = objEntryOk.Value & ""
            vntArrSearchChar(lngCount) = objSearchChar.Value & ""
            vntArrOpeClassName(lngCount) = objOpeClassName.Value & ""
'            vntArrPrice1(lngCount) = objPrice1.Value & ""
'            vntArrPrice2(lngCount) = objPrice2.Value & ""
'            vntArrDmdLineClassName(lngCount) = objDmdLineClassName.Value & ""
'            vntArrIsrDmdLineClassName(lngCount) = objIsrDmdLineClassName.Value & ""
'            vntArrRoundClassName(lngCount) = objRoundClassName.Value & ""
            vntArrPrice1(lngCount) = ""
            vntArrPrice2(lngCount) = ""
            vntArrDmdLineClassName(lngCount) = ""
            vntArrIsrDmdLineClassName(lngCount) = ""
            vntArrRoundClassName(lngCount) = ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntRequestName = vntArrRequestName
    
    If IsMissing(vntRslQue) = False Then vntRslQue = vntArrRslQue
    If IsMissing(vntClassName) = False Then vntClassName = vntArrClassName
    If IsMissing(vntProgressName) = False Then vntProgressName = vntArrProgressName
    If IsMissing(vntEntryOk) = False Then vntEntryOk = vntArrEntryOk
    If IsMissing(vntSearchChar) = False Then vntSearchChar = vntArrSearchChar
    If IsMissing(vntOpeClassName) = False Then vntOpeClassName = vntArrOpeClassName
    If IsMissing(vntPrice1) = False Then vntPrice1 = vntArrPrice1
    If IsMissing(vntPrice2) = False Then vntPrice2 = vntArrPrice2
    If IsMissing(vntDmdLineClassName) = False Then vntDmdLineClassName = vntArrDmdLineClassName
    If IsMissing(vntIsrDmdLineClassName) = False Then vntIsrDmdLineClassName = vntArrIsrDmdLineClassName
    If IsMissing(vntRoundClassName) = False Then vntRoundClassName = vntArrRoundClassName

    SelectItem_pList = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Item.SelectItem_pList"
    
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
' 機能　　 : 依頼項目単価テーブル取得
'
' 引数　　 : (In)     strItemCd         検査項目コード
' 　　　　 : (Out)    vntExistsIsr      健保有無区分
' 　　　　 : (Out)    vntSeq            ＳＥＱ
' 　　　　 : (Out)    vntStrAge         開始年齢
' 　　　　 : (Out)    vntEndAge         終了年齢
' 　　　　 : (Out)    vntBsdPrice       団体負担金額
' 　　　　 : (Out)    vntIsrPrice       健保負担金額
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectItem_P_Price(ByVal strItemCd As String, _
                                   ByRef vntExistsIsr As Variant, _
                                   ByRef vntSeq As Variant, _
                                   ByRef vntStrAge As Variant, _
                                   ByRef vntEndAge As Variant, _
                                   ByRef vntBsdPrice As Variant, _
                                   ByRef vntIsrPrice As Variant _
                                   ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objExistsIsr        As OraField         '健保有無区分
    Dim objSeq              As OraField         'ＳＥＱ
    Dim objStrAge           As OraField         '開始年齢
    Dim objEndAge           As OraField         '終了年齢
    Dim objBsdPrice         As OraField         '団体負担金額
    Dim objIsrPrice         As OraField         '健保負担金額
    
    Dim vntArrExistsIsr()   As Variant          '検査項目コードの配列
    Dim vntArrSeq()         As Variant          '依頼項目名の配列
    Dim vntArrStrAge()      As Variant          '検査分類名称の配列
    Dim vntArrEndAge()      As Variant          '検査分類名称の配列
    Dim vntArrBsdPrice()    As Variant          '検査分類名称の配列
    Dim vntArrIsrPrice()    As Variant          '検査分類名称の配列
    
    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'グループコードが設定されていない場合はエラー
    If IsEmpty(strItemCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす受診歴情報のレコードを取得
    strStmt = "SELECT ITEMCD, EXISTSISR, SEQ, STRAGE, ENDAGE, BSDPRICE, ISRPRICE" & vbLf & _
              "  FROM ITEM_P_PRICE" & vbLf & _
              " WHERE ITEMCD = :ITEMCD" & vbLf & _
              " ORDER BY EXISTSISR, SEQ"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objExistsIsr = objFields("EXISTSISR")
        Set objSeq = objFields("SEQ")
        Set objStrAge = objFields("STRAGE")
        Set objEndAge = objFields("ENDAGE")
        Set objBsdPrice = objFields("BsdPrice")
        Set objIsrPrice = objFields("ISRPRICE")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrExistsIsr(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrStrAge(lngCount)
            ReDim Preserve vntArrEndAge(lngCount)
            ReDim Preserve vntArrBsdPrice(lngCount)
            ReDim Preserve vntArrIsrPrice(lngCount)
            
            vntArrExistsIsr(lngCount) = objExistsIsr.Value
            vntArrSeq(lngCount) = objSeq.Value
            vntArrStrAge(lngCount) = objStrAge.Value
            vntArrEndAge(lngCount) = objEndAge.Value
            vntArrBsdPrice(lngCount) = objBsdPrice.Value
            vntArrIsrPrice(lngCount) = objIsrPrice.Value
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntExistsIsr = vntArrExistsIsr
    vntSeq = vntArrSeq
    vntStrAge = vntArrStrAge
    vntEndAge = vntArrEndAge
    vntBsdPrice = vntArrBsdPrice
    vntIsrPrice = vntArrIsrPrice
    
    SelectItem_P_Price = lngCount
    
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
    WriteErrorLog "Grp.SelectItem_P_Price"
    
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
' 引数　　 : (In)     vntClassCdKey     検査分類コードキー
' 　　　　 : (In)     vntSearchCharKey  ガイド検索用文字列キー
' 　　　　 : (In)     vntQuestionKey    問診結果表示有無キー
' 　　　　 : (Out)    vntItemCd         検査項目コード
' 　　　　 : (Out)    vntSuffix         サフィックス
' 　　　　 : (Out)    vntItemName       検査項目名称
' 　　　　 : (Out)    vntClassName      検査分類名称（省略可）
' 　　　　 : (In/Out) vntResultType     結果タイプ（省略可）
' 　　　　 : (In)     vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)     vntSearchString   検索用文字列（省略可）
' 　　　　 : (Out)    vntItemType       項目タイプ
' 　　　　 : (In/Out) vntCUTargetFlg    CU経年変化表示対象（省略可）
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 結果タイプが数値以外の場合は、配列で結果を返す。
'
'## 2002.12.04 Mod 23Lines by T.Takagi@FSIT 東急対応
'Public Function SelectItem_cList(ByVal vntClassCdKey As Variant,
'                                 ByVal vntSearchCharKey As Variant,
'                                 ByVal vntQuestionKey As Variant,
'                                 ByRef vntItemCd As Variant,
'                                 ByRef vntSuffix As Variant,
'                                 ByRef vntItemName As Variant,
'                                 Optional ByRef vntClassName As Variant,
'                                 Optional ByRef vntResultType As Variant,
'                                 Optional ByVal vntSearchCode As Variant,
'                                 Optional ByVal vntSearchString As Variant
'                                 ) As Long
'## 2003.10.17 Mod 26Lines by K.Kagawai@FFCS 聖路加対応
'Public Function SelectItem_cList(ByVal vntClassCdKey As Variant, _
'                                 ByVal vntSearchCharKey As Variant, _
'                                 ByVal vntQuestionKey As Variant, _
'                                 ByRef vntItemCd As Variant, _
'                                 ByRef vntSuffix As Variant, _
'                                 ByRef vntItemName As Variant, _
'                                 Optional ByRef vntClassName As Variant, _
'                                 Optional ByRef vntResultType As Variant, _
'                                 Optional ByVal vntSearchCode As Variant, _
'                                 Optional ByVal vntSearchString As Variant, _
'                                 Optional ByRef vntItemType As Variant _
'                                 ) As Long
''## 2002.12.04 Mod End
Public Function SelectItem_cList(ByVal vntClassCdKey As Variant, _
                                 ByVal vntSearchCharKey As Variant, _
                                 ByVal vntQuestionKey As Variant, _
                                 ByRef vntItemCd As Variant, _
                                 ByRef vntSuffix As Variant, _
                                 ByRef vntItemName As Variant, _
                                 Optional ByRef vntClassName As Variant, _
                                 Optional ByRef vntResultType As Variant, _
                                 Optional ByVal vntSearchCode As Variant, _
                                 Optional ByVal vntSearchString As Variant, _
                                 Optional ByRef vntItemType As Variant, _
                                 Optional ByRef vntCuTargetFlg As Variant _
                                 ) As Long
'## 2003.10.17 Mod End

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim blnClassCd          As Boolean          '検査分類コードの条件文がセットされた時、TRUE
    Dim blnRslque           As Boolean          '問診結果の条件文がセットされた時、TRUE
    Dim strSearchCharW      As String           '検索文字(全角)
    Dim strSearchCharN      As String           '検索文字(半角)
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名称
    Dim objClassName        As OraField         '検査分類名称
    Dim objResultType       As OraField         '結果タイプ
'## 2002.12.04 Add 1Line by T.Takagi@FSIT 東急対応
    Dim objItemType         As OraField         '項目タイプ
'## 2002.12.04 Add End
'## 2003.10.17 Add 1Line by K.Kagawa@FFCS 聖路加対応
    Dim objCuTargetFlg      As OraField         'CU経年変化表示対象
'## 2003.10.17 Add End
   
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名称の配列
    Dim vntArrClassName()   As Variant          '検査分類名称の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
'## 2002.12.04 Add 1Line by T.Takagi@FSIT 東急対応
    Dim vntArrItemType()    As Variant          '項目タイプ
'## 2002.12.04 Add End
'## 2003.10.17 Add 1Line by K.Kagawa@FFCS 聖路加対応
    Dim vntArrCUTargetFlg() As Variant          'CU経年変化表示対象の配列
'## 2003.10.17 Add End
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemCd = Empty
    vntSuffix = Empty
    vntItemName = Empty
    vntClassName = Empty
'## 2002.12.04 Add 3Lines by T.Takagi@FSIT 東急対応
    If Not IsMissing(vntItemType) Then
        vntItemType = Empty
    End If
'## 2002.12.04 Add End
    
    '問診項目表示有無条件が設定されていない場合はエラー
    If Not (vntQuestionKey = ITEM_NOTDISP Or vntQuestionKey = ITEM_DISP) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLASSCD", Trim(vntClassCdKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHARW", Trim(strSearchCharW), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHARN", Trim(strSearchCharN), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSLQUE", RSLQUE_R, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '結果タイプが未指定、かつ数値の場合のみバインド変数作成
    If IsMissing(vntResultType) = False Then
        If (IsNumeric(vntResultType)) And (Trim(vntResultType) <> "") Then
            objOraParam.Add "RESULTTYPE", CInt(vntResultType), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    End If
'## 2003.10.17 Add 6Line by K.Kagawa@FFCS 聖路加対応
    'CU経年変化表示対象が未指定、かつ数値の場合のみバインド変数作成
    If IsMissing(vntCuTargetFlg) = False Then
        If (IsNumeric(vntCuTargetFlg)) And (Trim(vntCuTargetFlg) <> "") Then
            objOraParam.Add "CUTARGETFLG", CInt(vntCuTargetFlg), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    End If
'## 2003.10.17 Add End
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
'## 2003.10.17 Mod 17Lines by K.Kagawai@FFCS 聖路加対応
'## 2002.12.04 Mod 10Lines by T.Takagi@FSIT 東急対応
'    strStmt = "SELECT ITEM_C.ITEMCD, ITEM_C.SUFFIX, ITEM_C.ITEMNAME, " & vbLf & _
'              "       ITEMCLASS.CLASSNAME, ITEM_C.RESULTTYPE " & _
'              "  FROM ITEM_P, ITEM_C, ITEMCLASS " & _
'              " WHERE ITEM_P.ITEMCD  = ITEM_C.ITEMCD " & _
'              "   AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD "
'    strStmt = "SELECT ITEM_C.ITEMCD,     ITEM_C.SUFFIX,   ITEM_C.ITEMNAME,    " & vbLf & _
'              "       ITEM_C.RESULTTYPE, ITEM_C.ITEMTYPE, ITEMCLASS.CLASSNAME " & vbLf & _
'              "  FROM ITEM_P, ITEM_C, ITEMCLASS                               " & vbLf & _
'              " WHERE ITEM_P.ITEMCD  = ITEM_C.ITEMCD                          " & vbLf & _
'              "   AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD                      "
''## 2002.12.04 Mod End
    strStmt = "SELECT ITEM_C.ITEMCD,     ITEM_C.SUFFIX,   ITEM_C.ITEMNAME,    " & vbLf & _
              "       ITEM_C.RESULTTYPE, ITEM_C.ITEMTYPE, ITEMCLASS.CLASSNAME," & vbLf & _
              "       ITEM_C.CUTARGETFLG                                      " & vbLf & _
              "  FROM ITEM_P, ITEM_C, ITEMCLASS                               " & vbLf & _
              " WHERE ITEM_P.ITEMCD  = ITEM_C.ITEMCD                          " & vbLf & _
              "   AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD                      "
'## 2003.10.17 Mod End
                  
    '結果タイプが数値の場合のみ検索条件設定
    If IsMissing(vntResultType) = False Then
        If (IsNumeric(vntResultType)) And (Trim(vntResultType) <> "") Then
            strStmt = strStmt & "   AND ITEM_C.RESULTTYPE = :RESULTTYPE"
        End If
    End If
'## 2003.10.17 Add 6Line by K.Kagawa@FFCS 聖路加対応
    'CU経年変化表示対象が数値の場合のみ検索条件設定
    If IsMissing(vntCuTargetFlg) = False Then
        If (IsNumeric(vntCuTargetFlg)) And (Trim(vntCuTargetFlg) <> "") Then
            strStmt = strStmt & "   AND ITEM_C.CUTARGETFLG = :CUTARGETFLG"
        End If
    End If
'## 2003.10.17 Add End
    
    'WHERE句の編集
    If Not ((vntClassCdKey = "") And (vntSearchCharKey = "") And (vntQuestionKey <> ITEM_NOTDISP)) Then
    
        strStmt = strStmt & " AND " & vbLf

        '条件セットフラグをFALSEにセット
        blnClassCd = False
        blnRslque = False
        
        '検査分類コードおよび問診結果キーの編集
        If Not ((vntClassCdKey = "") And (vntQuestionKey <> ITEM_NOTDISP)) Then
            
            '依頼項目テーブルから指定の検査分類コードの項目コード・結果問診フラグを副問い合わせ
            strStmt = strStmt & "ITEM_C.ITEMCD IN ( SELECT ITEMCD " & vbLf & _
                         "                            FROM ITEM_P " & vbLf & _
                         "                           WHERE "
            '検査分類コード
            If (vntClassCdKey <> "") Then
                '検索キー値を編集
                strStmt = strStmt & "CLASSCD = :CLASSCD "
                '条件セットフラグをTRUEへ
                blnClassCd = True
            End If
            
            '結果問診フラグ
            If (vntQuestionKey = ITEM_NOTDISP) Then
                '検査分類コードキーがセットされていれば条件節はANDで連結
                If (blnClassCd) Then
                    strStmt = strStmt & vbLf & _
                         "                      AND "
                End If
                '問診結果キー値を編集
                strStmt = strStmt & "RSLQUE = :RSLQUE "
                '条件セットフラグをTRUEへ
                blnRslque = True
            End If
            
            '副問い合わせ終了
            strStmt = strStmt & vbLf & _
                        "                 ) "
        End If
    
        'ガイド検索用文字列キーの編集
        If Not (vntSearchCharKey = "") Then
            '全角・半角両方に対応するよう変換
            strSearchCharW = StrConv(vntSearchCharKey, vbWide)
            strSearchCharN = StrConv(vntSearchCharKey, vbNarrow)
            'キー値の再設定
            objOraParam("SEARCHCHARW").Value = Trim(strSearchCharW)
            objOraParam("SEARCHCHARN").Value = Trim(strSearchCharN)
            '検査分類コードキーか問診結果キーがセットされていれば条件節はANDで連結
            If (blnClassCd Or blnRslque) Then
                strStmt = strStmt & vbLf & _
                      "   AND "
            End If
            '検索キー値を編集
            strStmt = strStmt & "ITEM_P.SEARCHCHAR IN ( :SEARCHCHARW, :SEARCHCHARN ) "
        End If
    
    End If
    
    '検索用文字列の設定（マスタメンテ用）
    If IsMissing(vntSearchCode) = False Then
        If Trim(vntSearchCode) <> "" Then
            strStmt = strStmt & " AND ITEM_C.ITEMCD LIKE '%" & vntSearchCode & "%'" & vbLf
        End If
    End If
                                 
    If IsMissing(vntSearchString) = False Then
        If Trim(vntSearchString) <> "" Then
            strStmt = strStmt & " AND ITEM_C.ITEMNAME LIKE '%" & vntSearchString & "%'" & vbLf
        End If
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY ITEM_C.ITEMCD, ITEM_C.SUFFIX"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objClassName = objFields("CLASSNAME")
        Set objResultType = objFields("RESULTTYPE")
'## 2002.12.04 Add 1Line by T.Takagi@FSIT 東急対応
        Set objItemType = objFields("ITEMTYPE")
'## 2002.12.04 Add End
'## 2003.10.17 Add 1Line by K.Kagawa@FFCS 聖路加対応
        Set objCuTargetFlg = objFields("CUTARGETFLG")
'## 2003.10.17 Add End
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
'## 2002.12.04 Add 1Line by T.Takagi@FSIT 東急対応
            ReDim Preserve vntArrItemType(lngCount)
'## 2002.12.04 Add End
'## 2003.10.17 Add 1Line by K.Kagawa@FFCS 聖路加対応
            ReDim Preserve vntArrCUTargetFlg(lngCount)
'## 2003.10.17 Add End
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrClassName(lngCount) = objClassName.Value & ""
            vntArrResultType(lngCount) = objResultType.Value & ""
'## 2002.12.04 Add 1Line by T.Takagi@FSIT 東急対応
            vntArrItemType(lngCount) = objItemType.Value & ""
'## 2002.12.04 Add End
'## 2003.10.17 Add 1Line by K.Kagawa@FFCS 聖路加対応
            vntArrCUTargetFlg(lngCount) = objCuTargetFlg.Value & ""
'## 2003.10.17 Add End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    If IsMissing(vntClassName) = False Then vntClassName = vntArrClassName
    
    '結果タイプが引数として指定されており、かつ数値でない場合は配列をセット
    If IsMissing(vntResultType) = False Then
        If (IsNumeric(vntResultType) = False) Or (Trim(vntResultType) = "") Then
            vntResultType = vntArrResultType
        End If
    End If
    
'## 2002.12.04 Add 3Lines by T.Takagi@FSIT 東急対応
    If Not IsMissing(vntItemType) Then
        vntItemType = vntArrItemType
    End If
'## 2002.12.04 Add End
'## 2003.10.17 Add 6Line by K.Kagawa@FFCS 聖路加対応
    'CU経年変化表示対象が引数として指定されており、かつ数値でない場合は配列をセット
    If Not IsMissing(vntCuTargetFlg) Then
        If (IsNumeric(vntCuTargetFlg) = False) Or (Trim(vntCuTargetFlg) = "") Then
            vntCuTargetFlg = vntArrCUTargetFlg
        End If
    End If
'## 2003.10.17 Add End
   
    SelectItem_cList = lngCount
        
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
    WriteErrorLog "Item.SelectItem_cList"
    
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
' 機能　　 : 検査項目の基本情報を取得する
'
' 引数　　 : (In)   strItemCd           検査項目コード
' 　　　　 : (In)   strSuffix           サフィックス
' 　　　　 : (Out)  vntItemName         検査項目名
' 　　　　 : (Out)  vntItemEName        英語項目名
' 　　　　 : (Out)  vntClassName        検査分類名称
' 　　　　 : (Out)  vntRslque           結果問診フラグ
' 　　　　 : (Out)  vntRslqueName       結果問診フラグ名称
' 　　　　 : (Out)  vntItemType         項目タイプ
' 　　　　 : (Out)  vntItemTypeName     項目タイプ名称
' 　　　　 : (Out)  vntResultType       結果タイプ
' 　　　　 : (Out)  vntResultTypeName   結果タイプ名称
' 　　　　 : (Out)  vntitemSName        検査項目略称（省略可）
' 　　　　 : (Out)  vntitemRName        報告書表示用項目名（省略可）
' 　　　　 : (Out)  vntsearchChar       ガイド検索用文字列（省略可）
' 　　　　 : (Out)  vntstcItemCd        文章参照用項目コード（省略可）
' 　　　　 : (Out)  vntStcItemName      文章参照用項目名称（省略可）
' 　　　　 : (Out)  vntrecentCount      最近使った文章管理数（省略可）
' 　　　　 : (Out)  vntitemQName        問診文章（省略可）
' 　　　　 : (Out)  vntcollectCd        採取コード（省略可）
' 　　　　 : (Out)  vntcontractCd       外注先コード（省略可）
' 　　　　 : (Out)  vntcontractItemCd   外注結果コード（省略可）
' 　　　　 : (Out)  vntoldItemCd        移行時旧検査項目コード（省略可）
' 　　　　 : (Out)  vntRequestName      依頼項目名（省略可）
' 　　　　 : (Out)  vntNoPrintFlg       報告書未出力フラグ（省略可）
' 　　　　 : (Out)  vntCollectTubeCd    採取管コード
' 　　　　 : (Out)  vntMaterials        材料コード
' 　　　　 : (Out)  vntLabelMark        マーク
' 　　　　 : (Out)  vntWsCd             ＷＳコード
' 　　　　 : (Out)  vntLoadCd1          負荷コード１
' 　　　　 : (Out)  vntLoadCd2          負荷コード２
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　 : (Out)  vntCuTargetFlg      CU経年変化表示対象
' 　　　　 : (Out)  vntOrderDiv         オーダ種別
' 　　　　 : (Out)  vntBuiCode          部位コード
' 　　　　 : (Out)  vntExplanation      項目説明
'### 2004/1/15 Added End
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　 : (Out)  vntHideInterview    面接支援非表示フラグ
'### 2004/1/29 Added End
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectItemHeader(ByVal strItemCd As String, ByVal strSuffix As String, _
                                 ByRef vntItemName As Variant, ByRef vntitemEName As Variant, _
                                 ByRef vntClassName As Variant, _
                                 ByRef vntRslQue As Variant, _
                                 ByRef vntRslqueName As Variant, _
                                 ByRef vntItemType As Variant, _
                                 ByRef vntItemTypeName As Variant, _
                                 ByRef vntResultType As Variant, _
                                 ByRef vntResultTypeName As Variant, _
                                 Optional ByRef vntItemSName As Variant, Optional ByRef vntItemRName As Variant, _
                                 Optional ByRef vntSearchChar As Variant, Optional ByRef vntStcItemCd As Variant, _
                                 Optional ByRef vntStcItemName As Variant, Optional ByRef vntRecentCount As Variant, _
                                 Optional ByRef vntItemQName As Variant, Optional ByRef vntCollectCd As Variant, _
                                 Optional ByRef vntContractCd As Variant, Optional ByRef vntContractItemCd As Variant, _
                                 Optional ByRef vntOldItemCd As Variant, Optional ByRef vntRequestName As Variant, _
                                 Optional ByRef vntNoPrintFlg As Variant, Optional ByRef vntCollectTubeCd As Variant, _
                                 Optional ByRef vntMaterials As Variant, Optional ByRef vntLabelMark As Variant, _
                                 Optional ByRef vntWsCd As Variant, Optional ByRef vntLoadCd1 As Variant, _
                                 Optional ByRef vntLoadCd2 As Variant, _
                                 Optional ByRef vntCuTargetFlg As Variant, _
                                 Optional ByRef vntOrderDiv As Variant, _
                                 Optional ByRef vntBuiCode As Variant, _
                                 Optional ByRef vntExplanation As Variant, Optional ByRef vntHideInterview As Variant _
                                 ) As Boolean
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemName         As OraField         '検査項目名
    Dim objitemEName        As OraField         '英語項目名
    Dim objClassName        As OraField         '検査分類名称
    Dim objRslQue           As OraField         '結果問診フラグ
    Dim objItemType         As OraField         '項目タイプ
    Dim objResultType       As OraField         '結果タイプ
    
    Dim objItemSName        As OraField         '検査項目略称
    Dim objItemRName        As OraField         '報告書用項目名
    Dim objSearchChar       As OraField         'ガイド検索用文字列
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objStcItemName      As OraField         '文章参照用項目名称
    Dim objRecentCount      As OraField         '最近使った文章管理数
    Dim objItemQName        As OraField         '問診文章
    Dim objCollectCd        As OraField         '採取コード
    Dim objContractCd       As OraField         '外注先コード
    Dim objContractItemCd   As OraField         '外注結果コード
    Dim objOldItemCd        As OraField         '移行時旧検査項目コード
    Dim objRequestName      As OraField         '依頼項目名
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT 報告書未出力フラグ対応
    Dim objNoPrintFlg       As OraField         '報告書未出力フラグ
'## 2002.11.10 Add End
    
'## 2003.02.05 Add 6Lines By H.Ishihara@FSIT 検体ラベル関係の変数追加
    Dim objCollectTubeCd    As OraField         '採取管コード
    Dim objMaterials        As OraField         '材料コード
    Dim objLabelMark        As OraField         'マーク
    Dim objWsCd             As OraField         'ＷＳコード
    Dim objLoadCd1          As OraField         '負荷コード１
    Dim objLoadCd2          As OraField         '負荷コード２
'## 2003.02.05 Add End
    
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim objCuTargetFlg      As OraField         'CU経年変化表示対象
    Dim objOrderDiv         As OraField         'オーダ種別
    Dim objBuiCode          As OraField         '部位コード
    Dim objExplanation      As OraField         '項目説明
'### 2004/1/15 Added End
    
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
    Dim objHideInterview    As OraField         '面接支援非表示フラグ
'### 2004/1/29 Added End
    
    Dim objCommon           As Common           '共通クラス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemName = Empty
    vntitemEName = Empty
    vntClassName = Empty
    vntRslQue = Empty
    vntRslqueName = Empty
    vntItemType = Empty
    vntItemTypeName = Empty
    vntResultType = Empty
    vntResultTypeName = Empty
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT 報告書未出力フラグ対応
    vntNoPrintFlg = Empty
'## 2002.11.10 Add End
    
    '検索条件が設定されていない場合はエラー
    If Trim(strItemCd) = "" Or Trim(strSuffix) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす検査項目の基本情報を取得
'## 2003.11.23 Mod 1Line By H.Ishihara@FSIT 聖路加不要項目の削除
'    strStmt = "SELECT ic.ITEMNAME,      ic.ITEMENAME," & vbLf & _
              "       cl.CLASSNAME,     ip.RSLQUE," & vbLf & _
              "       ic.ITEMTYPE,      ic.RESULTTYPE," & vbLf & _
              "       ic.ITEMSNAME,     ic.ITEMRNAME," & vbLf & _
              "       ic.SEARCHCHAR,    ic.STCITEMCD," & vbLf & _
              "       ic.RECENTCOUNT,   ic.ITEMQNAME," & vbLf & _
              "       ic.COLLECTCD,     ic.CONTRACTCD," & vbLf & _
              "       ic.CONTRACTITEMCD,ic.OLDITEMCD," & vbLf & _
              "       i2.REQUESTNAME STCITEMNAME, ip.REQUESTNAME, ic.NOPRINTFLG," & vbLf & _
              "       ic.COLLECTTUBECD, ic.MATERIALS, ic.LABELMARK, ic.WSCD, ic.LOADCD1, ic.LOADCD2" & vbLf & _
              "  FROM ITEM_P i2, ITEM_P ip, ITEMCLASS cl, ITEM_C ic " & vbLf & _
              " WHERE ic.ITEMCD  = :ITEMCD       " & vbLf & _
              "   AND ic.SUFFIX  = :SUFFIX       " & vbLf & _
              "   AND i2.ITEMCD  = ic.STCITEMCD  " & vbLf & _
              "   AND ic.ITEMCD  = ip.ITEMCD (+) " & vbLf & _
              "   AND ip.CLASSCD = cl.CLASSCD (+)"
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
'    strStmt = "SELECT ic.ITEMNAME,      ic.ITEMENAME," & vbLf & _
              "       cl.CLASSNAME,     ip.RSLQUE," & vbLf & _
              "       ic.ITEMTYPE,      ic.RESULTTYPE," & vbLf & _
              "       ic.ITEMSNAME,     ic.ITEMRNAME," & vbLf & _
              "       ic.SEARCHCHAR,    ic.STCITEMCD," & vbLf & _
              "       ic.RECENTCOUNT,   ic.ITEMQNAME," & vbLf & _
              "       ic.COLLECTCD,     ic.CONTRACTCD," & vbLf & _
              "       ic.CONTRACTITEMCD,ic.OLDITEMCD," & vbLf & _
              "       i2.REQUESTNAME STCITEMNAME, ip.REQUESTNAME, ic.NOPRINTFLG," & vbLf & _
              "       ic.MATERIALS" & vbLf & _
              "  FROM ITEM_P i2, ITEM_P ip, ITEMCLASS cl, ITEM_C ic " & vbLf & _
              " WHERE ic.ITEMCD  = :ITEMCD       " & vbLf & _
              "   AND ic.SUFFIX  = :SUFFIX       " & vbLf & _
              "   AND i2.ITEMCD  = ic.STCITEMCD  " & vbLf & _
              "   AND ic.ITEMCD  = ip.ITEMCD (+) " & vbLf & _
              "   AND ip.CLASSCD = cl.CLASSCD (+)"
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
'    strStmt = "SELECT ic.ITEMNAME,      ic.ITEMENAME," & vbLf & _
              "       cl.CLASSNAME,     ip.RSLQUE," & vbLf & _
              "       ic.ITEMTYPE,      ic.RESULTTYPE," & vbLf & _
              "       ic.ITEMSNAME,     ic.ITEMRNAME," & vbLf & _
              "       ic.SEARCHCHAR,    ic.STCITEMCD," & vbLf & _
              "       ic.RECENTCOUNT,   ic.ITEMQNAME," & vbLf & _
              "       ic.COLLECTCD,     ic.CONTRACTCD," & vbLf & _
              "       ic.CONTRACTITEMCD,ic.OLDITEMCD," & vbLf & _
              "       i2.REQUESTNAME STCITEMNAME, ip.REQUESTNAME, ic.NOPRINTFLG," & vbLf & _
              "       ic.MATERIALS, " & vbLf & _
              "       ic.CuTargetFlg, ic.OrderDiv, ic.BuiCode, ic.Explanation " & vbLf & _
              "  FROM ITEM_P i2, ITEM_P ip, ITEMCLASS cl, ITEM_C ic " & vbLf & _
              " WHERE ic.ITEMCD  = :ITEMCD       " & vbLf & _
              "   AND ic.SUFFIX  = :SUFFIX       " & vbLf & _
              "   AND i2.ITEMCD  = ic.STCITEMCD  " & vbLf & _
              "   AND ic.ITEMCD  = ip.ITEMCD (+) " & vbLf & _
              "   AND ip.CLASSCD = cl.CLASSCD (+)"
    strStmt = "SELECT ic.ITEMNAME,      ic.ITEMENAME," & vbLf & _
              "       cl.CLASSNAME,     ip.RSLQUE," & vbLf & _
              "       ic.ITEMTYPE,      ic.RESULTTYPE," & vbLf & _
              "       ic.ITEMSNAME,     ic.ITEMRNAME," & vbLf & _
              "       ic.SEARCHCHAR,    ic.STCITEMCD," & vbLf & _
              "       ic.RECENTCOUNT,   ic.ITEMQNAME," & vbLf & _
              "       ic.COLLECTCD,     ic.CONTRACTCD," & vbLf & _
              "       ic.CONTRACTITEMCD,ic.OLDITEMCD," & vbLf & _
              "       i2.REQUESTNAME STCITEMNAME, ip.REQUESTNAME, ic.NOPRINTFLG," & vbLf & _
              "       ic.MATERIALS, " & vbLf & _
              "       ic.CuTargetFlg, ic.OrderDiv, ic.BuiCode, ic.Explanation, ic.HideInterview " & vbLf & _
              "  FROM ITEM_P i2, ITEM_P ip, ITEMCLASS cl, ITEM_C ic " & vbLf & _
              " WHERE ic.ITEMCD  = :ITEMCD       " & vbLf & _
              "   AND ic.SUFFIX  = :SUFFIX       " & vbLf & _
              "   AND i2.ITEMCD  = ic.STCITEMCD  " & vbLf & _
              "   AND ic.ITEMCD  = ip.ITEMCD (+) " & vbLf & _
              "   AND ip.CLASSCD = cl.CLASSCD (+)"
'### 2004/1/29 Added End
'### 2004/1/15 Added End
'## 2003.11.23 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
        Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemName = objFields("ITEMNAME")
        Set objitemEName = objFields("ITEMENAME")
        Set objClassName = objFields("CLASSNAME")
        Set objRslQue = objFields("RSLQUE")
        Set objItemType = objFields("ITEMTYPE")
        Set objResultType = objFields("RESULTTYPE")
    
        Set objItemSName = objFields("ITEMSNAME")
        Set objItemRName = objFields("ITEMRNAME")
        Set objSearchChar = objFields("SEARCHCHAR")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objStcItemName = objFields("STCITEMNAME")
        Set objRecentCount = objFields("RECENTCOUNT")
        Set objItemQName = objFields("ITEMQNAME")
        Set objCollectCd = objFields("COLLECTCD")
        Set objContractCd = objFields("CONTRACTCD")
        Set objContractItemCd = objFields("CONTRACTITEMCD")
        Set objOldItemCd = objFields("OLDITEMCD")
        Set objRequestName = objFields("REQUESTNAME")
        Set objNoPrintFlg = objFields("NOPRINTFLG")
        Set objMaterials = objFields("MATERIALS")
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'        Set objCollectTubeCd = objFields("COLLECTTUBECD")
'        Set objLabelMark = objFields("LABELMARK")
'        Set objWsCd = objFields("WSCD")
'        Set objLoadCd1 = objFields("LOADCD1")
'        Set objLoadCd2 = objFields("LOADCD2")
'## 2003.11.23 Deleted End
    
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        Set objCuTargetFlg = objFields("CUTARGETFLG")
        Set objOrderDiv = objFields("ORDERDIV")
        Set objBuiCode = objFields("BUICODE")
        Set objExplanation = objFields("EXPLANATION")
'### 2004/1/15 Added End
    
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
        Set objHideInterview = objFields("HIDEINTERVIEW")
'### 2004/1/29 Added End
    
        '戻り値の設定
        vntItemName = objItemName.Value & ""
        vntitemEName = objitemEName.Value & ""
        vntClassName = objClassName.Value & ""
        vntRslQue = CLng(objRslQue.Value & "")
        vntRslqueName = objCommon.SelectRslqueName(CStr(vntRslQue)) & ""
        vntItemType = CLng(objItemType.Value & "")
        vntItemTypeName = objCommon.SelectItemTypeName(CStr(vntItemType)) & ""
        vntResultType = CLng(objResultType.Value & "")
        vntResultTypeName = objCommon.SelectResultTypeName(CStr(vntResultType)) & ""
    
        If IsMissing(vntItemSName) = False Then vntItemSName = objItemSName.Value & ""
        If IsMissing(vntItemRName) = False Then vntItemRName = objItemRName.Value & ""
        If IsMissing(vntSearchChar) = False Then vntSearchChar = objSearchChar.Value & ""
        If IsMissing(vntStcItemCd) = False Then vntStcItemCd = objStcItemCd.Value & ""
        If IsMissing(vntStcItemName) = False Then vntStcItemName = objStcItemName.Value & ""
        If IsMissing(vntRecentCount) = False Then vntRecentCount = objRecentCount.Value & ""
        If IsMissing(vntItemQName) = False Then vntItemQName = objItemQName.Value & ""
        If IsMissing(vntCollectCd) = False Then vntCollectCd = objCollectCd.Value & ""
        If IsMissing(vntContractCd) = False Then vntContractCd = objContractCd.Value & ""
        If IsMissing(vntContractItemCd) = False Then vntContractItemCd = objContractItemCd.Value & ""
        If IsMissing(vntOldItemCd) = False Then vntOldItemCd = objOldItemCd.Value & ""
        If IsMissing(vntRequestName) = False Then vntRequestName = objRequestName.Value & ""
        If IsMissing(vntNoPrintFlg) = False Then vntNoPrintFlg = objNoPrintFlg.Value & ""
        If IsMissing(vntMaterials) = False Then vntMaterials = objMaterials.Value & ""
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'        If IsMissing(vntCollectTubeCd) = False Then vntCollectTubeCd = objCollectTubeCd.Value & ""
'        If IsMissing(vntLabelMark) = False Then vntLabelMark = objLabelMark.Value & ""
'        If IsMissing(vntWsCd) = False Then vntWsCd = objWsCd.Value & ""
'        If IsMissing(vntLoadCd1) = False Then vntLoadCd1 = objLoadCd1.Value & ""
'        If IsMissing(vntLoadCd2) = False Then vntLoadCd2 = objLoadCd2.Value & ""
        If IsMissing(vntCollectTubeCd) = False Then vntCollectTubeCd = ""
        If IsMissing(vntLabelMark) = False Then vntLabelMark = ""
        If IsMissing(vntWsCd) = False Then vntWsCd = ""
        If IsMissing(vntLoadCd1) = False Then vntLoadCd1 = ""
        If IsMissing(vntLoadCd2) = False Then vntLoadCd2 = ""
'## 2003.11.23 Modified End
    
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        If IsMissing(vntCuTargetFlg) = False Then vntCuTargetFlg = objCuTargetFlg.Value & ""
        If IsMissing(vntOrderDiv) = False Then vntOrderDiv = objOrderDiv.Value & ""
        If IsMissing(vntBuiCode) = False Then vntBuiCode = objBuiCode.Value & ""
        If IsMissing(vntExplanation) = False Then vntExplanation = objExplanation.Value & ""
'### 2004/1/15 Added End
    
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
        If IsMissing(vntHideInterview) = False Then vntHideInterview = objHideInterview.Value & ""
'### 2004/1/29 Added End
    
        Set objCommon = Nothing
    
        SelectItemHeader = True
    
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Item.SelectItemHeader"
    
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
' 機能　　 : 検査項目の履歴情報を取得する
'
' 引数　　 : (In)   strItemCd           検査項目コード
' 　　　　 : (In)   strSuffix           サフィックス
' 　　　　 : (In)   strCslDateYear      受診日（年）
' 　　　　 : (In)   strCslDateMonth     受診日（月）
' 　　　　 : (In)   strCslDateDay       受診日（日）
' 　　　　 : (Out)  vntHistoryCount     該当検査項目の履歴管理レコード件数
' 　　　　 : (Out)  vntUnit             単位
' 　　　　 : (Out)  vntFigure1          整数部桁数
' 　　　　 : (Out)  vntFigure2          小数部桁数
' 　　　　 : (Out)  vntMaxValue         最大値
' 　　　　 : (Out)  vntMinValue         最小値
' 　　　　 : (Out)  vntitemHNo          検査項目履歴Ｎｏ（省略可能）
' 　　　　 : (Out)  vntstrDate          使用開始日付（省略可能）
' 　　　　 : (Out)  vntendDate          使用終了日付（省略可能）
' 　　　　 : (Out)  vntinsItemCd        検査用項目コード（省略可能）
' 　　　　 : (Out)  vntdefResult        省略時検査結果（省略可能）
' 　　　　 : (Out)  vntdefRslCmtCd      省略時結果コメントコード（省略可能）
' 　　　　 : (Out)  vntReqItemCd        検査用依頼項目コード
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
' 　　　　 : (Out)  vntSepOrderDiv      オーダ分割区分
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
' 　　　　   (Out)  vntInsSuffix        検査用サフィックス
' 　　　　   (Out)  vnteUnit            英語単位
'### 2004/1/15 Added End
'
' 戻り値　 : True   正常終了
' 　　　　 : False  該当受診日のレコードなし、または異常終了
'
' 備考　　 : ①Inパラメタの受診日を指定していない場合、履歴を全て返す
' 　　　　 : ②Inパラメタの受診日を指定していない場合、配列ではない状態で返す
'
Public Function SelectItemHistory(ByVal strItemCd As String, _
                                  ByVal strSuffix As String, _
                                  ByVal strCslDateYear As String, _
                                  ByVal strCslDateMonth As String, _
                                  ByVal strCslDateDay As String, _
                                  ByRef vntHistoryCount As Variant, _
                                  ByRef vntUnit As Variant, _
                                  ByRef vntFigure1 As Variant, _
                                  ByRef vntFigure2 As Variant, _
                                  ByRef vntMaxValue As Variant, _
                                  ByRef vntMinValue As Variant, _
                                  Optional ByRef vntItemHNo As Variant, _
                                  Optional ByRef vntStrDate As Variant, _
                                  Optional ByRef vntEndDate As Variant, _
                                  Optional ByRef vntInsItemCd As Variant, _
                                  Optional ByRef vntDefResult As Variant, _
                                  Optional ByRef vntDefRslCmtCd As Variant, _
                                  Optional ByRef vntReqItemCd As Variant, _
                                  Optional ByRef vntInsSuffix As Variant, _
                                  Optional ByRef vnteUnit As Variant _
                                 ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objHistoryCount         As OraField         '該当検査項目の履歴管理レコード件数
    Dim objUnit                 As OraField         '単位
    Dim objFigure1              As OraField         '整数部桁数
    Dim objFigure2              As OraField         '小数部桁数
    Dim objMaxValue             As OraField         '最大値
    Dim objMinValue             As OraField         '最小値
    
    Dim objItemHNo              As OraField         '検査項目履歴番号
    Dim objStrDate              As OraField         '使用開始日
    Dim objEndDate              As OraField         '使用終了日
    Dim objInsItemCd            As OraField         '検査用項目コード
    Dim objDefResult            As OraField         '省略時検査結果
    Dim objDefRslCmtCd          As OraField         '省略時結果コメントコード
    Dim objReqItemCd            As OraField         '検査依頼用項目コード
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'    Dim objSepOrderDiv          As OraField         'オーダ分割区分
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim objInsSuffix            As OraField         '検査用サフィックス
    Dim objeUnit                As OraField         '英語単位
'### 2004/1/15 Added End

    Dim vntArrUnit()            As Variant
    Dim vntArrFigure1()         As Variant
    Dim vntArrFigure2()         As Variant
    Dim vntArrMaxValue()        As Variant
    Dim vntArrMinValue()        As Variant
    Dim vntArrItemHNo()         As Variant
    Dim vntArrStrDate()         As Variant
    Dim vntArrEndDate()         As Variant
    Dim vntArrInsItemCd()       As Variant
    Dim vntArrDefResult()       As Variant
    Dim vntArrDefRslCmtCd()     As Variant
    Dim vntArrReqItemCd()       As Variant          '検査依頼用項目コード
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'    Dim vntArrSepOrderDiv()     As Variant          'オーダ分割区分
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim vntArrInsSuffix()       As Variant          '検査用サフィックス
    Dim vntArreUnit()           As Variant          '英語単位
'### 2004/1/15 Added End
    
    Dim strDate                 As String           '日付編集用
    Dim blnDateSelect           As Boolean          '受診日範囲の抽出が必要かどうか？
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    blnDateSelect = False
    vntHistoryCount = CLng(0)
    vntUnit = Empty
    vntFigure1 = Empty
    vntFigure2 = Empty
    vntMaxValue = Empty
    vntMinValue = Empty
    
    '検索条件が設定されていない場合はエラー
    If Trim(strItemCd) = "" Or Trim(strSuffix) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '受診日をどれか一つでも設定されている場合は、日付妥当性チェック
    If (Trim(strCslDateYear) <> "") Or (Trim(strCslDateYear) <> "") Or (Trim(strCslDateYear) <> "") Then
        strDate = Trim(strCslDateYear) & "/" & Trim(strCslDateMonth) & "/" & Trim(strCslDateDay)
        If Not IsDate(strDate) Then
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        blnDateSelect = True
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '条件指定ありの場合に受診日バインド変数指定
    If blnDateSelect = True Then
        objOraParam.Add "CSLDATE", strDate, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '該当検査項目の履歴管理レコード件数を取得
    strStmt = "SELECT COUNT(*) HISTORYCOUNT" & vbLf & _
              "  FROM ITEM_H" & vbLf & _
              " WHERE ITEMCD = :ITEMCD" & vbLf & _
              "   AND SUFFIX = :SUFFIX"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objHistoryCount = objFields("HISTORYCOUNT")
    
        '戻り値の設定
        vntHistoryCount = CLng(objHistoryCount.Value & "")
    
    End If
    
    Set objOraDyna = Nothing
    
    '該当検査項目・受診日の情報を取得
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'    strStmt = "SELECT ITEMHNO,  STRDATE,  ENDDATE,   FIGURE1,   FIGURE2, UNIT," & vbLf & _
              "       MAXVALUE, MINVALUE, INSITEMCD, DEFRESULT, DEFRSLCMTCD, " & vbLf & _
              "       REQITEMCD, SEPORDERDIV" & vbLf & _
              "  FROM ITEM_H" & vbLf & _
              " WHERE ITEMCD = :ITEMCD" & vbLf & _
              "   AND SUFFIX = :SUFFIX" & vbLf
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'    strStmt = "SELECT ITEMHNO,  STRDATE,  ENDDATE,   FIGURE1,   FIGURE2, UNIT," & vbLf & _
              "       MAXVALUE, MINVALUE, INSITEMCD, DEFRESULT, DEFRSLCMTCD, " & vbLf & _
              "       REQITEMCD" & vbLf & _
              "  FROM ITEM_H" & vbLf & _
              " WHERE ITEMCD = :ITEMCD" & vbLf & _
              "   AND SUFFIX = :SUFFIX" & vbLf
    strStmt = "SELECT ITEMHNO,  STRDATE,  ENDDATE,   FIGURE1,   FIGURE2, UNIT," & vbLf & _
              "       MAXVALUE, MINVALUE, INSITEMCD, DEFRESULT, DEFRSLCMTCD, " & vbLf & _
              "       REQITEMCD, INSSUFFIX, EUNIT" & vbLf & _
              "  FROM ITEM_H" & vbLf & _
              " WHERE ITEMCD = :ITEMCD" & vbLf & _
              "   AND SUFFIX = :SUFFIX" & vbLf
'### 2004/1/15 Modified End
'## 2003.11.23 Deleted End
    
    If blnDateSelect = True Then
        '受診日指定ありの場合のみ、WHERE句条件追加
        strStmt = strStmt & "   AND STRDATE <= :CSLDATE" & vbLf & _
                            "   AND ENDDATE >= :CSLDATE" & vbLf & _
                            "   AND ROWNUM = 1" & vbLf & _
                            " ORDER BY ITEM_H.ITEMHNO DESC"
    Else
        '受診日指定ありの場合のみ、WHERE句条件追加
        strStmt = strStmt & " ORDER BY ENDDATE DESC"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objUnit = objFields("UNIT")
        Set objFigure1 = objFields("FIGURE1")
        Set objFigure2 = objFields("FIGURE2")
        Set objMaxValue = objFields("MAXVALUE")
        Set objMinValue = objFields("MINVALUE")
    
        Set objItemHNo = objFields("ITEMHNO")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objInsItemCd = objFields("INSITEMCD")
        Set objDefResult = objFields("DEFRESULT")
        Set objDefRslCmtCd = objFields("DEFRSLCMTCD")
        Set objReqItemCd = objFields("REQITEMCD")
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'        Set objSepOrderDiv = objFields("SEPORDERDIV")
'## 2003.11.23 Deleted End
    
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        Set objInsSuffix = objFields("INSSUFFIX")
        Set objeUnit = objFields("EUNIT")
'### 2004/1/15 Added End
        
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrUnit(lngCount)
            ReDim Preserve vntArrFigure1(lngCount)
            ReDim Preserve vntArrFigure2(lngCount)
            ReDim Preserve vntArrMaxValue(lngCount)
            ReDim Preserve vntArrMinValue(lngCount)
            ReDim Preserve vntArrItemHNo(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrInsItemCd(lngCount)
            ReDim Preserve vntArrDefResult(lngCount)
            ReDim Preserve vntArrDefRslCmtCd(lngCount)
            ReDim Preserve vntArrReqItemCd(lngCount)
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'            ReDim Preserve vntArrSepOrderDiv(lngCount)
'## 2003.11.23 Deleted End

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            ReDim Preserve vntArrInsSuffix(lngCount)
            ReDim Preserve vntArreUnit(lngCount)
'### 2004/1/15 Added End

            vntArrUnit(lngCount) = objUnit.Value & ""
            vntArrFigure1(lngCount) = objFigure1.Value & ""
            vntArrFigure2(lngCount) = objFigure2.Value & ""
            vntArrMaxValue(lngCount) = objMaxValue.Value & ""
            vntArrMinValue(lngCount) = objMinValue.Value & ""
            vntArrItemHNo(lngCount) = objItemHNo.Value & ""
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            vntArrInsItemCd(lngCount) = objInsItemCd.Value & ""
            vntArrDefResult(lngCount) = objDefResult.Value & ""
            vntArrDefRslCmtCd(lngCount) = objDefRslCmtCd.Value & ""
            vntArrReqItemCd(lngCount) = objReqItemCd.Value & ""
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'            vntArrSepOrderDiv(lngCount) = objSepOrderDiv.Value & ""
'## 2003.11.23 Deleted End
            
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            vntArrInsSuffix(lngCount) = objInsSuffix.Value & ""
            vntArreUnit(lngCount) = objeUnit.Value & ""
'### 2004/1/15 Added End
            
            '受診日指定の場合、１件のみ抽出して終了する
            If blnDateSelect = True Then Exit Do
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
    
        '戻り値の設定（受診日指定の場合は配列では渡さない）
        If blnDateSelect = True Then
            vntUnit = vntArrUnit(0)
            vntFigure1 = vntArrFigure1(0)
            vntFigure2 = vntArrFigure2(0)
            vntMaxValue = vntArrMaxValue(0)
            vntMinValue = vntArrMinValue(0)
            If IsMissing(vntItemHNo) = False Then vntItemHNo = vntArrItemHNo(0)
            If IsMissing(vntStrDate) = False Then vntStrDate = vntArrStrDate(0)
            If IsMissing(vntEndDate) = False Then vntEndDate = vntArrEndDate(0)
            If IsMissing(vntInsItemCd) = False Then vntInsItemCd = vntArrInsItemCd(0)
            If IsMissing(vntDefResult) = False Then vntDefResult = vntArrDefResult(0)
            If IsMissing(vntDefRslCmtCd) = False Then vntDefRslCmtCd = vntArrDefRslCmtCd(0)
            If IsMissing(vntReqItemCd) = False Then vntReqItemCd = vntArrReqItemCd(0)
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'            If IsMissing(vntSepOrderDiv) = False Then vntSepOrderDiv = vntArrSepOrderDiv(0)
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            If IsMissing(vntInsSuffix) = False Then vntInsSuffix = vntArrInsSuffix(0)
            If IsMissing(vnteUnit) = False Then vnteUnit = vntArreUnit(0)
'### 2004/1/15 Added End
        Else
            vntUnit = vntArrUnit
            vntFigure1 = vntArrFigure1
            vntFigure2 = vntArrFigure2
            vntMaxValue = vntArrMaxValue
            vntMinValue = vntArrMinValue
            If IsMissing(vntItemHNo) = False Then vntItemHNo = vntArrItemHNo
            If IsMissing(vntStrDate) = False Then vntStrDate = vntArrStrDate
            If IsMissing(vntEndDate) = False Then vntEndDate = vntArrEndDate
            If IsMissing(vntInsItemCd) = False Then vntInsItemCd = vntArrInsItemCd
            If IsMissing(vntDefResult) = False Then vntDefResult = vntArrDefResult
            If IsMissing(vntDefRslCmtCd) = False Then vntDefRslCmtCd = vntArrDefRslCmtCd
            If IsMissing(vntReqItemCd) = False Then vntReqItemCd = vntArrReqItemCd
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'            If IsMissing(vntSepOrderDiv) = False Then vntSepOrderDiv = vntArrSepOrderDiv
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            If IsMissing(vntInsSuffix) = False Then vntInsSuffix = vntArrInsSuffix
            If IsMissing(vnteUnit) = False Then vnteUnit = vntArreUnit
'### 2004/1/15 Added End
        End If
    
        SelectItemHistory = True
    
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Item.SelectItemHistory"
    
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
' 機能　　 : 検索条件を満たす電子カルテ用項目変換テーブルの一覧を取得する
'
' 引数　　 : (In)     strItemCd             検査項目コード
' 　　　　 : (In)     strSuffix             サフィックス
' 　　　　 : (In)     strItemHNo            検査項目履歴Ｎｏ
' 　　　　 : (Out)    strItemHNo            検査項目履歴Ｎｏ（配列）
' 　　　　 : (Out)    vntKarteDocCd         電カル用文書種別コード
' 　　　　 : (Out)    vntKarteItemAttr      電カル用項目属性
' 　　　　 : (Out)    vntKarteItemcd        電カル用項目コード
' 　　　　 : (Out)    vntKarteItemName      電カル用項目名
' 　　　　 : (Out)    vntKarteTagName       電カル用タグ名称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検査項目履歴Ｎｏ未指定時は、該当検査項目コードの変換テーブルを全てかえす
'
Public Function SelectKarteItemList(ByVal strItemCd As String, _
                                    ByVal strSuffix As String, _
                                    ByVal strItemHNo As String, _
                                    ByRef vntItemHNo As Variant, _
                                    ByRef vntKarteDocCd As Variant, _
                                    ByRef vntKarteItemAttr As Variant, _
                                    ByRef vntKarteItemcd As Variant, _
                                    ByRef vntKarteItemName As Variant, _
                                    ByRef vntKarteTagName As Variant _
                                    ) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
       
    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objItemHNo              As OraField         '検査項目履歴No
    Dim objKarteDocCd           As OraField         '電カル用文書種別コード
    Dim objKarteItemAttr        As OraField         '電カル用項目属性
    Dim objKarteItemcd          As OraField         '電カル用項目コード
    Dim objKarteItemName        As OraField         '電カル用項目名
    Dim objKarteTagName         As OraField         '電カル用タグ名称
    
    Dim vntArrItemHNo()         As Variant          '検査項目履歴No
    Dim vntArrKarteDocCd()      As Variant          '電カル用文書種別コード（配列）
    Dim vntArrKarteItemAttr()   As Variant          '電カル用項目属性（配列）
    Dim vntArrKarteItemcd()     As Variant          '電カル用項目コード（配列）
    Dim vntArrKarteItemName()   As Variant          '電カル用項目名（配列）
    Dim vntArrKarteTagName()    As Variant          '電カル用タグ名称（配列）
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'コードが設定されていない場合はエラー
    If (strItemCd = "") Or (strSuffix = "") Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    If Trim(strItemHNo) <> "" Then
        objOraParam.Add "ITEMHNO", CInt(Trim(strItemHNo)), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = "SELECT ITEMHNO, KARTEDOCCD, KARTEITEMATTR, KARTEITEMCD, KARTEITEMNAME, KARTETAGNAME" & vbLf & _
              "  FROM KARTEITEM" & vbLf & _
              " WHERE ITEMCD  = :ITEMCD" & vbLf & _
              "   AND SUFFIX  = :SUFFIX"
    
    If Trim(strItemHNo) <> "" Then
        strStmt = strStmt & "   AND ITEMHNO = :ITEMHNO"
    End If
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemHNo = objFields("ITEMHNO")
        Set objKarteDocCd = objFields("KARTEDOCCD")
        Set objKarteItemAttr = objFields("KARTEITEMATTR")
        Set objKarteItemcd = objFields("KARTEITEMCD")
        Set objKarteItemName = objFields("KARTEITEMNAME")
        Set objKarteTagName = objFields("KARTETAGNAME")
        
        '配列形式で格納する
        lngCount = 0
        
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemHNo(lngCount)
            ReDim Preserve vntArrKarteDocCd(lngCount)
            ReDim Preserve vntArrKarteItemAttr(lngCount)
            ReDim Preserve vntArrKarteItemcd(lngCount)
            ReDim Preserve vntArrKarteItemName(lngCount)
            ReDim Preserve vntArrKarteTagName(lngCount)
            
            vntArrItemHNo(lngCount) = objItemHNo.Value & ""
            vntArrKarteDocCd(lngCount) = objKarteDocCd.Value & ""
            vntArrKarteItemAttr(lngCount) = objKarteItemAttr.Value & ""
            vntArrKarteItemcd(lngCount) = objKarteItemcd.Value & ""
            vntArrKarteItemName(lngCount) = objKarteItemName.Value & ""
            vntArrKarteTagName(lngCount) = objKarteTagName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemHNo = vntArrItemHNo
    vntKarteDocCd = vntArrKarteDocCd
    vntKarteItemAttr = vntArrKarteItemAttr
    vntKarteItemcd = vntArrKarteItemcd
    vntKarteItemName = vntArrKarteItemName
    vntKarteTagName = vntArrKarteTagName
    
    SelectKarteItemList = lngCount
        
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
    WriteErrorLog "Item.SelectKarteItem"

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
' 機能　　 : 検査項目コードに対する検査項目名を取得する
'
' 引数　　 : (In)     strItemCd         検査分類コード
' 　　　　 : (In)     strSuffix         サフィックス
' 　　　　 : (Out)    vntItemName       検査項目名称
' 　　　　 : (Out)    vntItemQName      問診文章（省略可）
' 　　　　 : (Out)    vntResultType     結果タイプ（省略可）
' 　　　　 : (Out)    vntItemType       項目タイプ（省略可）
' 　　　　 : (Out)    vntStcItemCd      文章参照用項目コード（省略可）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectItemName(ByVal strItemCd As String, _
                               ByVal strSuffix As String, _
                               ByRef vntItemName As Variant, _
                               Optional ByRef vntItemQName As Variant, _
                               Optional ByRef vntResultType As Variant, _
                               Optional ByRef vntItemType As Variant, _
                               Optional ByRef vntStcItemCd As Variant _
                              ) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名称
    Dim objItemQName        As OraField         '問診文章
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strItemCd) = "" Or Trim(strSuffix) = "" Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = "SELECT ITEMNAME, ITEMQNAME, RESULTTYPE, ITEMTYPE," & vbLf & _
              "       STCITEMCD                                 " & vbLf & _
              "  FROM ITEM_C                                    " & vbLf & _
              " WHERE ITEMCD = :ITEMCD                          " & vbLf & _
              "   AND SUFFIX = :SUFFIX                          "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemName = objFields("ITEMNAME")
        Set objItemQName = objFields("ITEMQNAME")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        
        '戻り値の設定
        vntItemName = objItemName.Value & ""
        If Not IsMissing(vntItemQName) Then
            vntItemQName = objItemQName.Value & ""
        End If
        If Not IsMissing(vntResultType) Then
            vntResultType = CLng(objResultType.Value)
        End If
        If Not IsMissing(vntItemType) Then
            vntItemType = CLng(objItemType.Value)
        End If
        If Not IsMissing(vntStcItemCd) Then
            vntStcItemCd = objStcItemCd.Value
        End If
        
        SelectItemName = True
        
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Item.SelectItemName"
    
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
' 機能　　 : 検査用項目コードに対する検査項目名を取得する
'
' 引数　　 : (In)     strItemCd         検査項目コード
' 　　　　 : (In)     strSuffix         サフィックス
' 　　　　 : (In)     strInsItemCd      検査用項目コード
' 　　　　 : (Out)    vntItemCd         検査項目コード
' 　　　　 : (Out)    vntSuffix         サフィックス
' 　　　　 : (Out)    vntItemName       検査項目名称
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
' 　　　　   (In)    vntSepOrderDiv     オーダ分割区分
'
' 戻り値　 : レコード件数（-1はError）
'
' 備考　　 :
'
Public Function SelectInsItemInfo(ByVal strItemCd As String, _
                                  ByVal strSuffix As String, _
                                  ByVal strInsItemCd As String, _
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
    Dim lngRet              As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    lngRet = 0

    '検査項目コードが設定されていない場合（空白）正常終了にしちゃいましょう
    If Trim(strInsItemCd) = "" Then
        lngRet = 0
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INSITEMCD", Trim(strInsItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'    'オーダ分割区分が指定されている場合、それも検索条件に追加
'    If IsMissing(vntSepOrderDiv) = False Then
'        objOraParam.Add "SEPORDERDIV", Trim(vntSepOrderDiv), ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
'## 2003.11.23 Deleted End
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = "SELECT ITEM_H.ITEMCD, ITEM_H.SUFFIX, ITEM_C.ITEMNAME" & vbLf & _
              "  FROM ITEM_C, ITEM_H" & vbLf & _
              " WHERE ITEM_H.INSITEMCD =  :INSITEMCD" & vbLf & _
              "   AND ( (ITEM_H.ITEMCD != :ITEMCD) OR   " & vbLf & _
              "         (ITEM_H.SUFFIX != :SUFFIX))  " & vbLf & _
              "   AND ITEM_C.ITEMCD    =  ITEM_H.ITEMCD" & vbLf & _
              "   AND ITEM_C.SUFFIX    =  ITEM_H.SUFFIX"

'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'    'オーダ分割区分が指定されている場合、それも検索条件に追加
'    If IsMissing(vntSepOrderDiv) = False Then
'        strStmt = strStmt & _
'              "   AND ITEM_H.SEPORDERDIV = :SEPORDERDIV "
'
'    End If
'## 2003.11.23 Deleted End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        
        '戻り値の設定
        vntItemCd = objItemCd.Value & ""
        vntSuffix = objSuffix.Value & ""
        vntItemName = objItemName.Value & ""
        
        lngRet = 1
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Set objOraParam = Nothing
    SelectInsItemInfo = lngRet
    
    Exit Function
    
ErrorHandle:

    SelectInsItemInfo = -1

    'イベントログ書き込み
    WriteErrorLog "Item.SelectInsItemInfo"
    
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
' 機能　　 : 依頼項目情報を取得する
'
' 引数　　 : (In)     strItemCd             検査項目コード
' 　　　　 : (Out)    vntRequestName        依頼項目名
' 　　　　 : (Out)    vntRslQue             結果問診フラグ（省略可）
' 　　　　 : (Out)    vntClassCd            検査分類コード（省略可）
' 　　　　 : (Out)    vntRequestSName       依頼項目略称（省略可）
' 　　　　 : (Out)    vntProgressCd         進捗分類コード（省略可）
' 　　　　 : (Out)    vntEntryOk            未入力チェック（省略可）
' 　　　　 : (Out)    vntSearchChar         ガイド検索文字列（省略可）
' 　　　　 : (Out)    vntOpeClassCd         検査実施日分類（省略可）
'### 2003/11/23 Deleted by Ishihara@FSIT 不要項目の削除以下の項目は値が帰ってこない
' 　　　　 : (Out)    vntPrice1             単価１（省略可）
' 　　　　 : (Out)    vntPrice2             単価２（省略可）
' 　　　　 : (Out)    vntOrderFileName      オーダファイル名
' 　　　　 : (Out)    vntDocCd              文書種別コード
' 　　　　 : (Out)    vntDmdLineClassCd     請求明細分類コード
' 　　　　 : (Out)    vntIsrDmdLineClassCd  健保請求明細分類コード
' 　　　　 : (Out)    vntRoundClassCd       まるめ分類コード
'### 2003/11/23 Deleted End
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectItem_P(ByVal strItemCd As String, _
                             ByRef vntRequestName As Variant, _
                             Optional ByRef vntRslQue As Variant, _
                             Optional ByRef vntClassCd As Variant, _
                             Optional ByRef vntRequestSName As Variant, _
                             Optional ByRef vntProgressCd As Variant, _
                             Optional ByRef vntEntryOk As Variant, _
                             Optional ByRef vntSearchChar As Variant, _
                             Optional ByRef vntOpeClassCd As Variant, _
                             Optional ByRef vntPrice1 As Variant, _
                             Optional ByRef vntPrice2 As Variant, _
                             Optional ByRef vntOrderFileName As Variant, _
                             Optional ByRef vntDocCd As Variant, _
                             Optional ByRef vntDmdLineClassCd As Variant, _
                             Optional ByRef vntIsrDmdLineClassCd As Variant, _
                             Optional ByRef vntRoundClassCd As Variant _
                             ) As Long
                        

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objItemCd               As OraField         '検査項目コード
    Dim objRequestName          As OraField         '検査項目名称
    Dim objRslQue               As OraField         '結果問診フラグ
    Dim objClassCd              As OraField         '検査分類コード
    Dim objRequestSName         As OraField         '検査項目略称
    Dim objProgressCd           As OraField         '進捗分類コード
    Dim objEntryOk              As OraField         '未入力チェック
    Dim objSearchChar           As OraField         'ガイド検索文字列
    Dim objOpeClassCd           As OraField         '検査実施日分類コード
    Dim objPrice1               As OraField         '単価１
    Dim objPrice2               As OraField         '単価２
    Dim objOrderFileName        As OraField         'オーダファイル名
    Dim objDocCd                As OraField         '文書種別コード
    
    Dim objDmdLineClassCd       As OraField         '請求明細分類コード
    Dim objIsrDmdLineClassCd    As OraField         '健保請求明細分類コード
    Dim objRoundClassCd         As OraField         'まるめ分類コード
        
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strItemCd) = "" Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
'### 2003/11/23 Modified by Ishihara@FSIT 不要項目の削除
'    strStmt = "SELECT CLASSCD,    RSLQUE,  REQUESTNAME,   REQUESTSNAME," & vbLf & _
              "       PROGRESSCD, ENTRYOK, SEARCHCHAR,    OPECLASSCD," & vbLf & _
              "       PRICE1,     PRICE2,  ORDERFILENAME, DOCCD, " & vbLf & _
              "       DMDLINECLASSCD, ISRDMDLINECLASSCD, ROUNDCLASSCD " & vbLf & _
              "  FROM ITEM_P" & vbLf & _
              " WHERE ITEM_P.ITEMCD = :ITEMCD"
    strStmt = "SELECT CLASSCD,    RSLQUE,  REQUESTNAME,   REQUESTSNAME," & vbLf & _
              "       PROGRESSCD, ENTRYOK, SEARCHCHAR,    OPECLASSCD" & vbLf & _
              "  FROM ITEM_P" & vbLf & _
              " WHERE ITEM_P.ITEMCD = :ITEMCD"
'### 2003/11/23 Modified End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objRequestName = objFields("REQUESTNAME")
        
        Set objRslQue = objFields("RSLQUE")
        Set objClassCd = objFields("CLASSCD")
        Set objRequestSName = objFields("REQUESTSNAME")
        Set objProgressCd = objFields("PROGRESSCD")
        Set objEntryOk = objFields("ENTRYOK")
        Set objSearchChar = objFields("SEARCHCHAR")
        Set objOpeClassCd = objFields("OPECLASSCD")
'### 2003/11/23 Modified by Ishihara@FSIT 不要項目の削除
'        Set objPrice1 = objFields("PRICE1")
'        Set objPrice2 = objFields("PRICE2")
'        Set objOrderFileName = objFields("ORDERFILENAME")
'        Set objDocCd = objFields("DOCCD")
'        Set objDmdLineClassCd = objFields("DMDLINECLASSCD")
'        Set objIsrDmdLineClassCd = objFields("ISRDMDLINECLASSCD")
'        Set objRoundClassCd = objFields("ROUNDCLASSCD")
'### 2003/11/23 Modified End
        
        '戻り値の設定
        vntRequestName = objRequestName.Value & ""
        
        If Not IsMissing(vntRslQue) Then vntRslQue = objRslQue.Value & ""
        If Not IsMissing(vntClassCd) Then vntClassCd = objClassCd.Value & ""
        If Not IsMissing(vntRequestSName) Then vntRequestSName = objRequestSName.Value & ""
        If Not IsMissing(vntProgressCd) Then vntProgressCd = objProgressCd.Value & ""
        If Not IsMissing(vntEntryOk) Then vntEntryOk = objEntryOk.Value & ""
        If Not IsMissing(vntSearchChar) Then vntSearchChar = objSearchChar.Value & ""
        If Not IsMissing(vntOpeClassCd) Then vntOpeClassCd = objOpeClassCd.Value & ""
'### 2003/11/23 Modified by Ishihara@FSIT 不要項目の削除
'        If Not IsMissing(vntPrice1) Then vntPrice1 = objPrice1.Value & ""
'        If Not IsMissing(vntPrice2) Then vntPrice2 = objPrice2.Value & ""
'        If Not IsMissing(vntOrderFileName) Then vntOrderFileName = objOrderFileName.Value & ""
'        If Not IsMissing(vntDocCd) Then vntDocCd = objDocCd.Value & ""
'        If Not IsMissing(vntDmdLineClassCd) Then vntDmdLineClassCd = objDmdLineClassCd.Value & ""
'        If Not IsMissing(vntIsrDmdLineClassCd) Then vntIsrDmdLineClassCd = objIsrDmdLineClassCd.Value & ""
'        If Not IsMissing(vntRoundClassCd) Then vntRoundClassCd = objRoundClassCd.Value & ""
        If Not IsMissing(vntPrice1) Then vntPrice1 = 0
        If Not IsMissing(vntPrice2) Then vntPrice2 = 0
        If Not IsMissing(vntOrderFileName) Then vntOrderFileName = ""
        If Not IsMissing(vntDocCd) Then vntDocCd = ""
        If Not IsMissing(vntDmdLineClassCd) Then vntDmdLineClassCd = ""
        If Not IsMissing(vntIsrDmdLineClassCd) Then vntIsrDmdLineClassCd = ""
        If Not IsMissing(vntRoundClassCd) Then vntRoundClassCd = ""
'### 2003/11/23 Modified End
        
        SelectItem_P = True
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Item.SelectItem_P"
    
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
' 機能　　 : DeActivateイベント
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
