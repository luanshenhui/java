VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Nourishment"
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
' 機能　　 : 食品群別摂取の一覧を取得する
'
' 引数　　 : (In)     strEnergy     エネルギー（空白時は全件）
' 　　　　 : (Out)    vntEnergy     エネルギー
' 　　　　 : (Out)    vntFoodGrp1   食品群１
' 　　　　 : (Out)    vntFoodGrp2   食品群２
' 　　　　 : (Out)    vntFoodGrp3   食品群３
' 　　　　 : (Out)    vntFoodGrp4   食品群４
' 　　　　 : (Out)    vntFoodGrp5   食品群５
' 　　　　 : (Out)    vntFoodGrp6   食品群６
' 　　　　 : (Out)    vntFoodGrp7   食品群７
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectNutriFoodEnergy(ByVal strEnergy As String, _
                                      Optional ByRef vntEnergy As Variant, _
                                      Optional ByRef vntFoodGrp1 As Variant, _
                                      Optional ByRef vntFoodGrp2 As Variant, _
                                      Optional ByRef vntFoodGrp3 As Variant, _
                                      Optional ByRef vntFoodGrp4 As Variant, _
                                      Optional ByRef vntFoodGrp5 As Variant, _
                                      Optional ByRef vntFoodGrp6 As Variant, _
                                      Optional ByRef vntFoodGrp7 As Variant _
                                      ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objEnergy           As OraField         'エネルギー
    Dim objFoodGrp1         As OraField         '食品群１
    Dim objFoodGrp2         As OraField         '食品群２
    Dim objFoodGrp3         As OraField         '食品群３
    Dim objFoodGrp4         As OraField         '食品群４
    Dim objFoodGrp5         As OraField         '食品群５
    Dim objFoodGrp6         As OraField         '食品群６
    Dim objFoodGrp7         As OraField         '食品群７
    
    Dim vntArrEnergy()      As Variant          'エネルギーの配列
    Dim vntArrFoodGrp1()    As Variant          '食品群１の配列
    Dim vntArrFoodGrp2()    As Variant          '食品群２の配列
    Dim vntArrFoodGrp3()    As Variant          '食品群３の配列
    Dim vntArrFoodGrp4()    As Variant          '食品群４の配列
    Dim vntArrFoodGrp5()    As Variant          '食品群５の配列
    Dim vntArrFoodGrp6()    As Variant          '食品群６の配列
    Dim vntArrFoodGrp7()    As Variant          '食品群７の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntEnergy = Empty
    vntFoodGrp1 = Empty
    vntFoodGrp2 = Empty
    vntFoodGrp3 = Empty
    vntFoodGrp4 = Empty
    vntFoodGrp5 = Empty
    vntFoodGrp6 = Empty
    vntFoodGrp7 = Empty
    SelectNutriFoodEnergy = 0
    lngCount = 0
    
    'キー値の設定
    If Trim(strEnergy) <> "" And IsNumeric(strEnergy) Then
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "Energy", Trim(strEnergy), ORAPARM_INPUT
    End If
    
    '食品群別摂取テーブルよりレコードを取得
    strStmt = "SELECT ENERGY,   " & vbLf & _
              "       FOODGRP1 ," & vbLf & _
              "       FOODGRP2 ," & vbLf & _
              "       FOODGRP3 ," & vbLf & _
              "       FOODGRP4 ," & vbLf & _
              "       FOODGRP5 ," & vbLf & _
              "       FOODGRP6 ," & vbLf & _
              "       FOODGRP7  " & vbLf & _
              "  FROM NUTRIFOODENERGY " & vbLf
    
    If Trim(strEnergy) <> "" And IsNumeric(strEnergy) Then
        strStmt = strStmt & _
                  " WHERE ENERGY = :ENERGY "
    Else
        strStmt = strStmt & _
                  " ORDER BY ENERGY "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objEnergy = objFields("Energy")
        Set objFoodGrp1 = objFields("FoodGrp1")
        Set objFoodGrp2 = objFields("FoodGrp2")
        Set objFoodGrp3 = objFields("FoodGrp3")
        Set objFoodGrp4 = objFields("FoodGrp4")
        Set objFoodGrp5 = objFields("FoodGrp5")
        Set objFoodGrp6 = objFields("FoodGrp6")
        Set objFoodGrp7 = objFields("FoodGrp7")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrEnergy(lngCount)
            ReDim Preserve vntArrFoodGrp1(lngCount)
            ReDim Preserve vntArrFoodGrp2(lngCount)
            ReDim Preserve vntArrFoodGrp3(lngCount)
            ReDim Preserve vntArrFoodGrp4(lngCount)
            ReDim Preserve vntArrFoodGrp5(lngCount)
            ReDim Preserve vntArrFoodGrp6(lngCount)
            ReDim Preserve vntArrFoodGrp7(lngCount)
            
            vntArrEnergy(lngCount) = objEnergy.Value & ""
            vntArrFoodGrp1(lngCount) = objFoodGrp1.Value & ""
            vntArrFoodGrp2(lngCount) = objFoodGrp2.Value & ""
            vntArrFoodGrp3(lngCount) = objFoodGrp3.Value & ""
            vntArrFoodGrp4(lngCount) = objFoodGrp4.Value & ""
            vntArrFoodGrp5(lngCount) = objFoodGrp5.Value & ""
            vntArrFoodGrp6(lngCount) = objFoodGrp6.Value & ""
            vntArrFoodGrp7(lngCount) = objFoodGrp7.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    If IsMissing(vntEnergy) = False Then vntEnergy = vntArrEnergy
    If IsMissing(vntFoodGrp1) = False Then vntFoodGrp1 = vntArrFoodGrp1
    If IsMissing(vntFoodGrp2) = False Then vntFoodGrp2 = vntArrFoodGrp2
    If IsMissing(vntFoodGrp3) = False Then vntFoodGrp3 = vntArrFoodGrp3
    If IsMissing(vntFoodGrp4) = False Then vntFoodGrp4 = vntArrFoodGrp4
    If IsMissing(vntFoodGrp5) = False Then vntFoodGrp5 = vntArrFoodGrp5
    If IsMissing(vntFoodGrp6) = False Then vntFoodGrp6 = vntArrFoodGrp6
    If IsMissing(vntFoodGrp7) = False Then vntFoodGrp7 = vntArrFoodGrp7
    
    SelectNutriFoodEnergy = lngCount
        
    Set objOraDyna = Nothing
        
    'バインド変数の削除
    If Trim(strEnergy) <> "" And IsNumeric(strEnergy) Then
        With objOraParam
            Do Until .Count <= 0
                .Remove (.Count - 1)
            Loop
        End With
    End If
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Nourishment.SelectNutriFoodEnergy"

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
' 機能　　 : 食品群別摂取テーブルレコードを登録する
'
' 引数　　 : (In)    strMode          登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strEnergy        エネルギー
' 　　　　   (In)    lngFoodGrp1      食品群１
' 　　　　   (In)    lngFoodGrp2      食品群２
' 　　　　   (In)    lngFoodGrp3      食品群３
' 　　　　   (In)    lngFoodGrp4      食品群４
' 　　　　   (In)    lngFoodGrp5      食品群５
' 　　　　   (In)    lngFoodGrp6      食品群６
' 　　　　   (In)    lngFoodGrp7      食品群７
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistNutriFoodEnergy(ByVal strMode As String, _
                                      ByVal lngEnergy As Long, _
                                      ByVal lngFoodGrp1 As Long, _
                                      ByVal lngFoodGrp2 As Long, _
                                      ByVal lngFoodGrp3 As Long, _
                                      ByVal lngFoodGrp4 As Long, _
                                      ByVal lngFoodGrp5 As Long, _
                                      ByVal lngFoodGrp6 As Long, _
                                      ByVal lngFoodGrp7 As Long) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    With objOraParam
        .Add "ENERGY", lngEnergy, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "FOODGRP1", lngFoodGrp1, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "FOODGRP2", lngFoodGrp2, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "FOODGRP3", lngFoodGrp3, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "FOODGRP4", lngFoodGrp4, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "FOODGRP5", lngFoodGrp5, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "FOODGRP6", lngFoodGrp6, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "FOODGRP7", lngFoodGrp7, ORAPARM_INPUT, ORATYPE_NUMBER
    End With

    Do
        '食品群別摂取テーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = "UPDATE NUTRIFOODENERGY      " & _
                      "   SET FOODGRP1 = :FOODGRP1," & _
                      "       FOODGRP2 = :FOODGRP2," & _
                      "       FOODGRP3 = :FOODGRP3," & _
                      "       FOODGRP4 = :FOODGRP4," & _
                      "       FOODGRP5 = :FOODGRP5," & _
                      "       FOODGRP6 = :FOODGRP6," & _
                      "       FOODGRP7 = :FOODGRP7 " & _
                      " WHERE ENERGY   = :ENERGY   "
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        
        End If

        '検索条件を満たす食品群別摂取テーブルのレコードを取得
        strStmt = "SELECT ENERGY FROM NUTRIFOODENERGY WHERE ENERGY = :ENERGY"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = ""
        strStmt = strStmt & "INSERT INTO NUTRIFOODENERGY " & vbLf
        strStmt = strStmt & "       ( ENERGY,  FOODGRP1,  FOODGRP2,  FOODGRP3,  FOODGRP4,  FOODGRP5,  FOODGRP6,  FOODGRP7 ) " & vbLf
        strStmt = strStmt & "VALUES (:ENERGY, :FOODGRP1, :FOODGRP2, :FOODGRP3, :FOODGRP4, :FOODGRP5, :FOODGRP6, :FOODGRP7 ) "
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    With objOraParam
        Do Until .Count <= 0
            .Remove (.Count - 1)
        Loop
    End With
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistNutriFoodEnergy = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Nourishment.RegistNutriFoodEnergy"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistNutriFoodEnergy = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "NutriFoodEnergy.RegistNutriFoodEnergy", Err.Description

End Function

'
' 機能　　 : 食品群別摂取テーブルレコードを削除する
'
' 引数　　 : (In)    lngEnergy    エネルギー
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteNutriFoodEnergy(ByVal lngEnergy As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ENERGY", lngEnergy, ORAPARM_INPUT, ORATYPE_NUMBER

    '食品群別摂取テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE NUTRIFOODENERGY WHERE ENERGY = :ENERGY"
    
    'バインド変数の削除
    With objOraParam
        Do Until .Count <= 0
            .Remove (.Count - 1)
        Loop
    End With
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteNutriFoodEnergy = True

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Nourishment.DeleteNutriFoodEnergy"

    DeleteNutriFoodEnergy = False

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "NutriFoodEnergy.DeleteNutriFoodEnergy", Err.Description

End Function

'
' 機能　　 : 構成食品テーブルの一覧を取得する
'
' 引数　　 : (In)     strComposeFoodCd      構成食品コード（空白時は全件）
' 　　　　 : (Out)    vntComposeFoodCd      構成食品コード
' 　　　　 : (Out)    vntComposeFoodName    構成食品名
' 　　　　 : (Out)    vntFoodClassCd        食品分類
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectNutriCompFood(ByVal strComposeFoodCd As String, _
                                    Optional ByRef vntComposeFoodCd As Variant, _
                                    Optional ByRef vntComposeFoodName As Variant, _
                                    Optional ByRef vntFoodClassCd As Variant _
                                    ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objComposeFoodCd        As OraField         '構成食品コード
    Dim objComposeFoodName      As OraField         '構成食品名
    Dim objFoodClassCd          As OraField         '食品分類
    
    Dim vntArrComposeFoodCd()   As Variant          '構成食品コードの配列
    Dim vntArrComposeFoodName() As Variant          '構成食品名の配列
    Dim vntArrFoodClassCd()     As Variant          '食品分類の配列
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntComposeFoodCd = Empty
    vntComposeFoodName = Empty
    vntFoodClassCd = Empty
    SelectNutriCompFood = 0
    lngCount = 0
    
    'キー値の設定
    If Trim(strComposeFoodCd) <> "" And IsNumeric(strComposeFoodCd) Then
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "COMPOSEFOODCD", Trim(strComposeFoodCd), ORAPARM_INPUT
    End If
    
    '構成食品テーブルよりレコードを取得
    strStmt = "SELECT COMPOSEFOODCD,   " & vbLf & _
              "       COMPOSEFOODNAME, " & vbLf & _
              "       FOODCLASSCD      " & vbLf & _
              "  FROM NUTRICOMPFOOD " & vbLf
    
    If Trim(strComposeFoodCd) <> "" And IsNumeric(strComposeFoodCd) Then
        strStmt = strStmt & _
                  " WHERE COMPOSEFOODCD = :COMPOSEFOODCD "
    Else
        strStmt = strStmt & _
                  " ORDER BY COMPOSEFOODCD "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objComposeFoodCd = objFields("ComposeFoodCd")
        Set objComposeFoodName = objFields("ComposeFoodName")
        Set objFoodClassCd = objFields("FoodClassCd")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrComposeFoodCd(lngCount)
            ReDim Preserve vntArrComposeFoodName(lngCount)
            ReDim Preserve vntArrFoodClassCd(lngCount)
            
            vntArrComposeFoodCd(lngCount) = objComposeFoodCd.Value & ""
            vntArrComposeFoodName(lngCount) = objComposeFoodName.Value & ""
            vntArrFoodClassCd(lngCount) = objFoodClassCd.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    If IsMissing(vntComposeFoodCd) = False Then vntComposeFoodCd = vntArrComposeFoodCd
    If IsMissing(vntComposeFoodName) = False Then vntComposeFoodName = vntArrComposeFoodName
    If IsMissing(vntFoodClassCd) = False Then vntFoodClassCd = vntArrFoodClassCd
    
    SelectNutriCompFood = lngCount
        
    Set objOraDyna = Nothing
        
    'バインド変数の削除
    If Trim(strComposeFoodCd) <> "" And IsNumeric(strComposeFoodCd) Then
        With objOraParam
            Do Until .Count <= 0
                .Remove (.Count - 1)
            Loop
        End With
    End If
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Nourishment.SelectNutricompFood"

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
' 機能　　 : 構成食品テーブルレコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    lngComposeFoodCd       構成食品コード
' 　　　　   (In)    strComposeFoodName     構成食品名
' 　　　　   (In)    lngFOODCLASSCD         食品分類
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistNutriCompFood(ByVal strMode As String, _
                                      ByVal lngComposeFoodCd As Long, _
                                      ByVal strComposeFoodName As String, _
                                      ByVal lngFoodClassCd As Long) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    With objOraParam
        .Add "COMPOSEFOODCD", lngComposeFoodCd, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "COMPOSEFOODNAME", strComposeFoodName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "FOODCLASSCD", lngFoodClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    End With

    Do
        '食品群別摂取テーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = "UPDATE NUTRICOMPFOOD                      " & _
                      "   SET COMPOSEFOODNAME = :COMPOSEFOODNAME," & _
                      "       FOODCLASSCD     = :FOODCLASSCD     " & _
                      " WHERE COMPOSEFOODCD   = :COMPOSEFOODCD   "
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        
        End If

        '検索条件を満たす食品群別摂取テーブルのレコードを取得
        strStmt = "SELECT COMPOSEFOODCD FROM NUTRICOMPFOOD WHERE COMPOSEFOODCD = :COMPOSEFOODCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = ""
        strStmt = strStmt & "INSERT INTO NUTRICOMPFOOD " & vbLf
        strStmt = strStmt & "       ( COMPOSEFOODCD,  COMPOSEFOODNAME,  FOODCLASSCD ) " & vbLf
        strStmt = strStmt & "VALUES (:COMPOSEFOODCD, :COMPOSEFOODNAME, :FOODCLASSCD ) "
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    With objOraParam
        Do Until .Count <= 0
            .Remove (.Count - 1)
        Loop
    End With
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistNutriCompFood = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Nourishment.RegistNutriCompFood"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistNutriCompFood = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Nourishment.RegistNutriCompFood", Err.Description

End Function

'
' 機能　　 : 構成食品テーブルレコードを削除する
'
' 引数　　 : (In)    lngComposeFoodCd    構成食品コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteNutriCompFood(ByVal lngComposeFoodCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "COMPOSEFOODCD", lngComposeFoodCd, ORAPARM_INPUT, ORATYPE_NUMBER

    '食品群別摂取テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE NUTRICOMPFOOD WHERE COMPOSEFOODCD = :COMPOSEFOODCD"
    
    'バインド変数の削除
    With objOraParam
        Do Until .Count <= 0
            .Remove (.Count - 1)
        Loop
    End With
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteNutriCompFood = True

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Nourishment.DeleteNutriCompFood"

    DeleteNutriCompFood = False

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Nourishment.DeleteNutriCompFood", Err.Description

End Function
'
' 機能      : 検索条件を満たす栄養計算目標量テーブルの一覧を取得する
'
' 引数　　 : (In)     strGender                 '性別
' 　　　　   (In)     strLowerAge               '年齢以上
' 　　　　   (In)     strUpperAge               '年齢以下
' 　　　　   (In)     strLowerHeight            '身長以上
' 　　　　   (In)     strUpperHeight            '身長以下
' 　　　　   (In)     strActStrength            '生活活動強度
' 　　　　   (In)     strTotalEnergy            '総エネルギー
' 　　　　   (Out)    vntGender                 '性別
' 　　　　   (Out)    vntLowerAge               '年齢以上
' 　　　　   (Out)    vntUpperAge               '年齢以下
' 　　　　   (Out)    vntLowerHeight            '身長以上
' 　　　　   (Out)    vntUpperHeight            '身長以下
' 　　　　   (Out)    vntActStrength            '生活活動強度
' 　　　　   (Out)    vntTotalEnergy            '総エネルギー
' 　　　　   (Out)    vntProtein                'たんぱく質
' 　　　　   (Out)    vntFat                    '脂質
' 　　　　   (Out)    vntCarbohydrate           '炭水化物
' 　　　　   (Out)    vntCalcium                'カルシウム
' 　　　　   (Out)    vntIron                   '鉄
' 　　　　   (Out)    vntCholesterol            'コレステロール
' 　　　　   (Out)    vntSalt                   '塩分
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectNutriTarget(ByVal strGender As String, _
                                  ByVal strLowerAge As String, _
                                  ByVal strUpperAge As String, _
                                  ByVal strLowerHeight As String, _
                                  ByVal strUpperHeight As String, _
                                  ByVal strActStrength As String, _
                                  ByVal strTotalEnergy As String, _
                                  Optional ByRef vntGender As Variant, _
                                  Optional ByRef vntLowerAge As Variant, _
                                  Optional ByRef vntUpperAge As Variant, _
                                  Optional ByRef vntLowerHeight As Variant, _
                                  Optional ByRef vntUpperHeight As Variant, _
                                  Optional ByRef vntActStrength As Variant, _
                                  Optional ByRef vntTotalEnergy As Variant, _
                                  Optional ByRef vntProtein As Variant, _
                                  Optional ByRef vntFat As Variant, _
                                  Optional ByRef vntCarbohydrate As Variant, _
                                  Optional ByRef vntCalcium As Variant, _
                                  Optional ByRef vntIron As Variant, _
                                  Optional ByRef vntCholesterol As Variant, _
                                  Optional ByRef vntSalt As Variant _
                                 ) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント

    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objGender                   As OraField         '性別
    Dim objLowerAge                 As OraField         '年齢以上
    Dim objUpperAge                 As OraField         '年齢以下
    Dim objLowerHeight              As OraField         '身長以上
    Dim objUpperHeight              As OraField         '身長以下
    Dim objActStrength              As OraField         '生活活動強度
    Dim objTotalEnergy              As OraField         '総エネルギー
    Dim objProtein                  As OraField         'たんぱく質
    Dim objFat                      As OraField         '脂質
    Dim objCarbohydrate             As OraField         '炭水化物
    Dim objCalcium                  As OraField         'カルシウム
    Dim objIron                     As OraField         '鉄
    Dim objCholesterol              As OraField         'コレステロール
    Dim objSalt                     As OraField         '塩分

    Dim lngCount                    As Long             '関数戻り値

    Dim vntArrGender()              As Variant         '性別
    Dim vntArrLowerAge()            As Variant         '年齢以上
    Dim vntArrUpperAge()            As Variant         '年齢以下
    Dim vntArrLowerHeight()         As Variant         '身長以上
    Dim vntArrUpperHeight()         As Variant         '身長以下
    Dim vntArrActStrength()         As Variant         '生活活動強度
    Dim vntArrTotalEnergy()         As Variant         '総エネルギー
    Dim vntArrProtein()             As Variant         'たんぱく質
    Dim vntArrFat()                 As Variant         '脂質
    Dim vntArrCarbohydrate()        As Variant         '炭水化物
    Dim vntArrCalcium()             As Variant         'カルシウム
    Dim vntArrIron()                As Variant         '鉄
    Dim vntArrCholesterol()         As Variant         'コレステロール
    Dim vntArrSalt()                As Variant         '塩分

    Dim blnExistKey                 As Boolean          'KEY値指定あり

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期値
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntLowerAge) Then vntLowerAge = Empty
    If Not IsMissing(vntUpperAge) Then vntUpperAge = Empty
    If Not IsMissing(vntLowerHeight) Then vntLowerHeight = Empty
    If Not IsMissing(vntUpperHeight) Then vntUpperHeight = Empty
    If Not IsMissing(vntActStrength) Then vntActStrength = Empty
    If Not IsMissing(vntTotalEnergy) Then vntTotalEnergy = Empty
    If Not IsMissing(vntProtein) Then vntProtein = Empty
    If Not IsMissing(vntFat) Then vntFat = Empty
    If Not IsMissing(vntCarbohydrate) Then vntCarbohydrate = Empty
    If Not IsMissing(vntCalcium) Then vntCalcium = Empty
    If Not IsMissing(vntIron) Then vntIron = Empty
    If Not IsMissing(vntCholesterol) Then vntCholesterol = Empty
    If Not IsMissing(vntSalt) Then vntSalt = Empty

    lngCount = 0

    '検索キー指定の有無チェック
    blnExistKey = False
    
    If Trim(strGender) <> "" And _
       Trim(strLowerAge) <> "" And _
       Trim(strUpperAge) <> "" And _
       Trim(strLowerHeight) <> "" And _
       Trim(strUpperHeight) <> "" And _
       Trim(strActStrength) <> "" And _
       Trim(strTotalEnergy) <> "" Then
    
        If IsNumeric(strGender) And _
           IsNumeric(strLowerAge) And _
           IsNumeric(strUpperAge) And _
           IsNumeric(strLowerHeight) And _
           IsNumeric(strUpperHeight) And _
           IsNumeric(strActStrength) And _
           IsNumeric(strTotalEnergy) Then
    
            blnExistKey = True
    
        End If
    
    End If

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters

    If blnExistKey = True Then
        With objOraParam
            .Add "GENDER", Trim(strGender), ORAPARM_INPUT, ORATYPE_NUMBER
            .Add "LOWERAGE", Trim(strLowerAge), ORAPARM_INPUT, ORATYPE_NUMBER
            .Add "UPPERAGE", Trim(strUpperAge), ORAPARM_INPUT, ORATYPE_NUMBER
            .Add "LOWERHEIGHT", Trim(strLowerHeight), ORAPARM_INPUT, ORATYPE_NUMBER
            .Add "UPPERHEIGHT", Trim(strUpperHeight), ORAPARM_INPUT, ORATYPE_NUMBER
            .Add "ACTSTRENGTH", Trim(strActStrength), ORAPARM_INPUT, ORATYPE_NUMBER
            .Add "TOTALENERGY", Trim(strTotalEnergy), ORAPARM_INPUT, ORATYPE_NUMBER
        End With
    End If

    '栄養計算目標量テーブルよりレコードを取得
    strStmt = ""
    strStmt = "SELECT GENDER,       " & vbLf & _
              "       LOWERAGE,     " & vbLf & _
              "       UPPERAGE,     " & vbLf & _
              "       LOWERHEIGHT,  " & vbLf & _
              "       UPPERHEIGHT,  " & vbLf & _
              "       ACTSTRENGTH,  " & vbLf & _
              "       TOTALENERGY,  " & vbLf & _
              "       PROTEIN,      " & vbLf & _
              "       FAT,          " & vbLf & _
              "       CARBOHYDRATE, " & vbLf & _
              "       CALCIUM,      " & vbLf & _
              "       IRON,         " & vbLf & _
              "       CHOLESTEROL,  " & vbLf & _
              "       SALT          " & vbLf & _
              "  FROM NUTRITARGET   " & vbLf

    If blnExistKey = True Then
        strStmt = strStmt & _
                  " WHERE GENDER      = :GENDER      " & vbLf & _
                  "       LOWERAGE    = :LOWERAGE    " & vbLf & _
                  "       UPPERAGE    = :UPPERAGE    " & vbLf & _
                  "       LOWERHEIGHT = :LOWERHEIGHT " & vbLf & _
                  "       UPPERHEIGHT = :UPPERHEIGHT " & vbLf & _
                  "       ACTSTRENGTH = :ACTSTRENGTH " & vbLf & _
                  "       TOTALENERGY = :TOTALENERGY " & vbLf
    Else
        strStmt = strStmt & _
                  " ORDER BY GENDER, ACTSTRENGTH, LOWERAGE, LOWERHEIGHT, TOTALENERGY "
    End If

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGender = objFields("GENDER")
        Set objLowerAge = objFields("LOWERAGE")
        Set objUpperAge = objFields("UPPERAGE")
        Set objLowerHeight = objFields("LOWERHEIGHT")
        Set objUpperHeight = objFields("UPPERHEIGHT")
        Set objActStrength = objFields("ACTSTRENGTH")
        Set objTotalEnergy = objFields("TOTALENERGY")
        Set objProtein = objFields("PROTEIN")
        Set objFat = objFields("FAT")
        Set objCarbohydrate = objFields("CARBOHYDRATE")
        Set objCalcium = objFields("CALCIUM")
        Set objIron = objFields("IRON")
        Set objCholesterol = objFields("CHOLESTEROL")
        Set objSalt = objFields("SALT")

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrLowerAge(lngCount)
            ReDim Preserve vntArrUpperAge(lngCount)
            ReDim Preserve vntArrLowerHeight(lngCount)
            ReDim Preserve vntArrUpperHeight(lngCount)
            ReDim Preserve vntArrActStrength(lngCount)
            ReDim Preserve vntArrTotalEnergy(lngCount)
            ReDim Preserve vntArrProtein(lngCount)
            ReDim Preserve vntArrFat(lngCount)
            ReDim Preserve vntArrCarbohydrate(lngCount)
            ReDim Preserve vntArrCalcium(lngCount)
            ReDim Preserve vntArrIron(lngCount)
            ReDim Preserve vntArrCholesterol(lngCount)
            ReDim Preserve vntArrSalt(lngCount)

            vntArrGender(lngCount) = objGender.Value & ""
            vntArrLowerAge(lngCount) = objLowerAge.Value & ""
            vntArrUpperAge(lngCount) = objUpperAge.Value & ""
            vntArrLowerHeight(lngCount) = objLowerHeight.Value & ""
            vntArrUpperHeight(lngCount) = objUpperHeight.Value & ""
            vntArrActStrength(lngCount) = objActStrength.Value & ""
            vntArrTotalEnergy(lngCount) = objTotalEnergy.Value & ""
            vntArrProtein(lngCount) = objProtein.Value & ""
            vntArrFat(lngCount) = objFat.Value & ""
            vntArrCarbohydrate(lngCount) = objCarbohydrate.Value & ""
            vntArrCalcium(lngCount) = objCalcium.Value & ""
            vntArrIron(lngCount) = objIron.Value & ""
            vntArrCholesterol(lngCount) = objCholesterol.Value & ""
            vntArrSalt(lngCount) = objSalt.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntLowerAge) Then vntLowerAge = vntArrLowerAge
        If Not IsMissing(vntUpperAge) Then vntUpperAge = vntArrUpperAge
        If Not IsMissing(vntLowerHeight) Then vntLowerHeight = vntArrLowerHeight
        If Not IsMissing(vntUpperHeight) Then vntUpperHeight = vntArrUpperHeight
        If Not IsMissing(vntActStrength) Then vntActStrength = vntArrActStrength
        If Not IsMissing(vntTotalEnergy) Then vntTotalEnergy = vntArrTotalEnergy
        If Not IsMissing(vntProtein) Then vntProtein = vntArrProtein
        If Not IsMissing(vntFat) Then vntFat = vntArrFat
        If Not IsMissing(vntCarbohydrate) Then vntCarbohydrate = vntArrCarbohydrate
        If Not IsMissing(vntCalcium) Then vntCalcium = vntArrCalcium
        If Not IsMissing(vntIron) Then vntIron = vntArrIron
        If Not IsMissing(vntCholesterol) Then vntCholesterol = vntArrCholesterol
        If Not IsMissing(vntSalt) Then vntSalt = vntArrSalt

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectNutriTarget = lngCount

    Exit Function

ErrorHandle:

    SelectNutriTarget = -1

    'イベントログ書き込み
    WriteErrorLog "Nourishment.SelectNutriTarget"

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
' 機能      : 検索条件を満たす栄養献立リストテーブルの一覧を取得する
'
' 引数　　 : (In)     strItemCd                 検査項目コード
' 　　　　   (In)     strSuffix                 サフィックス
' 　　　　   (In)     strComposeFoodCd          構成食品コード
' 　　　　   (Out)    vntItemCd                 項目コード
' 　　　　   (Out)    vntSuffix                 サフィックス
' 　　　　   (Out)    vntItemName               項目名
' 　　　　   (Out)    vntComposeFoodCd          構成食品コード
' 　　　　   (Out)    vntComposeFoodName        構成食品名
' 　　　　   (Out)    vntFoodClassCd            食品分類
' 　　　　   (Out)    vntTakeAmount             摂取量
' 　　　　   (Out)    vntTotalEnergy            総エネルギー
' 　　　　   (Out)    vntProtein                蛋白質
' 　　　　   (Out)    vntFat                    脂質
' 　　　　   (Out)    vntSugar                  糖質
' 　　　　   (Out)    vntCalcium                カルシウム
' 　　　　   (Out)    vntIron                   鉄
' 　　　　   (Out)    vntCholesterol            コレステロール
' 　　　　   (Out)    vntSalt                   塩分
' 　　　　   (Out)    vntLowSaltFlg             減塩フラグ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectNutriMenuList(ByVal strItemCd As String, _
                                    ByVal strSuffix As String, _
                                    ByVal strComposeFoodCd As String, _
                                    Optional ByRef vntItemCd As Variant, _
                                    Optional ByRef vntSuffix As Variant, _
                                    Optional ByRef vntItemName As Variant, _
                                    Optional ByRef vntComposeFoodCd As Variant, _
                                    Optional ByRef vntComposeFoodName As Variant, _
                                    Optional ByRef vntFoodClassCd As Variant, _
                                    Optional ByRef vntTakeAmount As Variant, _
                                    Optional ByRef vntTotalEnergy As Variant, _
                                    Optional ByRef vntProtein As Variant, _
                                    Optional ByRef vntFat As Variant, _
                                    Optional ByRef vntSugar As Variant, _
                                    Optional ByRef vntCalcium As Variant, _
                                    Optional ByRef vntIron As Variant, _
                                    Optional ByRef vntCholesterol As Variant, _
                                    Optional ByRef vntSalt As Variant, _
                                    Optional ByRef vntLowSaltFlg As Variant _
                                    ) As Long

    Dim objOraParam                As OraParameters     'OraParametersオブジェクト
    Dim objOraDyna                 As OraDynaset        'ダイナセット
    Dim strStmt                    As String            'SQLステートメント

    Dim objFields                  As OraFields         'フィールドオブジェクト
    Dim objItemCd                  As OraField          '検査項目コード
    Dim objSuffix                  As OraField          'サフィックス
    Dim objItemName                As OraField          '項目名
    Dim objComposeFoodCd           As OraField          '構成食品コード
    Dim objComposeFoodName         As OraField          '構成食品名
    Dim objFoodClassCd             As OraField          '食品分類
    Dim objTakeAmount              As OraField          '摂取量
    Dim objTotalEnergy             As OraField          '総エネルギー
    Dim objProtein                 As OraField          '蛋白質
    Dim objFat                     As OraField          '脂質
    Dim objSugar                   As OraField          '糖質
    Dim objCalcium                 As OraField          'カルシウム
    Dim objIron                    As OraField          '鉄
    Dim objCholesterol             As OraField          'コレステロール
    Dim objSalt                    As OraField          '塩分
    Dim objLowSaltFlg              As OraField          '減塩フラグ

    Dim lngCount                   As Long              '関数戻り値

    Dim vntArrItemCd()             As Variant           '検査項目コード
    Dim vntArrSuffix()             As Variant           'サフィックス
    Dim vntArrItemName()           As Variant           '項目名
    Dim vntArrComposeFoodCd()      As Variant           '構成食品コード
    Dim vntArrComposeFoodName()    As Variant           '構成食品名
    Dim vntArrFoodClassCd()        As Variant           '食品分類
    Dim vntArrTakeAmount()         As Variant           '摂取量
    Dim vntArrTotalEnergy()        As Variant           '総エネルギー
    Dim vntArrProtein()            As Variant           '蛋白質
    Dim vntArrFat()                As Variant           '脂質
    Dim vntArrSugar()              As Variant           '糖質
    Dim vntArrCalcium()            As Variant           'カルシウム
    Dim vntArrIron()               As Variant           '鉄
    Dim vntArrCholesterol()        As Variant           'コレステロール
    Dim vntArrSalt()               As Variant           '塩分
    Dim vntArrLowSaltFlg()         As Variant           '減塩フラグ

    Dim blnExistKey                 As Boolean          'KEY値指定あり

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期値
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntComposeFoodCd) Then vntComposeFoodCd = Empty
    If Not IsMissing(vntComposeFoodName) Then vntComposeFoodName = Empty
    If Not IsMissing(vntFoodClassCd) Then vntFoodClassCd = Empty
    If Not IsMissing(vntTakeAmount) Then vntTakeAmount = Empty
    If Not IsMissing(vntTotalEnergy) Then vntTotalEnergy = Empty
    If Not IsMissing(vntProtein) Then vntProtein = Empty
    If Not IsMissing(vntFat) Then vntFat = Empty
    If Not IsMissing(vntSugar) Then vntSugar = Empty
    If Not IsMissing(vntCalcium) Then vntCalcium = Empty
    If Not IsMissing(vntIron) Then vntIron = Empty
    If Not IsMissing(vntCholesterol) Then vntCholesterol = Empty
    If Not IsMissing(vntSalt) Then vntSalt = Empty
    If Not IsMissing(vntLowSaltFlg) Then vntLowSaltFlg = Empty

    lngCount = 0

    '検索キー指定の有無チェック
    blnExistKey = False
    If Trim(strItemCd) <> "" And Trim(strSuffix) <> "" And Trim(strComposeFoodCd) <> "" Then
        blnExistKey = True
    End If

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters

    If blnExistKey = True Then
        With objOraParam
            .Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
            .Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
            .Add "COMPOSEFOODCD", Trim(strComposeFoodCd), ORAPARM_INPUT, ORATYPE_NUMBER
        End With
    End If

    strStmt = ""
    strStmt = "SELECT NUTRIMENULIST.ITEMCD,                     " & vbLf & _
              "       NUTRIMENULIST.SUFFIX,                     " & vbLf & _
              "       ITEM_C.ITEMNAME,                          " & vbLf & _
              "       NUTRIMENULIST.COMPOSEFOODCD,              " & vbLf & _
              "       NUTRICOMPFOOD.COMPOSEFOODNAME,            " & vbLf & _
              "       NUTRICOMPFOOD.FOODCLASSCD,                " & vbLf & _
              "       NUTRIMENULIST.TAKEAMOUNT,                 " & vbLf & _
              "       NUTRIMENULIST.TOTALENERGY,                " & vbLf & _
              "       NUTRIMENULIST.PROTEIN,                    " & vbLf & _
              "       NUTRIMENULIST.FAT,                        " & vbLf & _
              "       NUTRIMENULIST.SUGAR,                      " & vbLf & _
              "       NUTRIMENULIST.CALCIUM,                    " & vbLf & _
              "       NUTRIMENULIST.IRON,                       " & vbLf & _
              "       NUTRIMENULIST.CHOLESTEROL,                " & vbLf & _
              "       NUTRIMENULIST.SALT,                       " & vbLf & _
              "       NUTRIMENULIST.LOWSALTFLG                  " & vbLf & _
              "  FROM NUTRICOMPFOOD, ITEM_C, NUTRIMENULIST      " & vbLf & _
              " WHERE NUTRIMENULIST.ITEMCD = ITEM_C.ITEMCD(+)   " & vbLf & _
              "   AND NUTRIMENULIST.SUFFIX = ITEM_C.SUFFIX(+)   " & vbLf & _
              "   AND NUTRIMENULIST.COMPOSEFOODCD = NUTRICOMPFOOD.COMPOSEFOODCD(+)         " & vbLf

    If blnExistKey = True Then
        strStmt = strStmt & _
                  " AND ITEMCD        = :ITEMCD        " & vbLf & _
                  "     SUFFIX        = :SUFFIX        " & vbLf & _
                  "     COMPOSEFOODCD = :COMPOSEFOODCD " & vbLf
    Else
        strStmt = strStmt & _
                " ORDER BY NUTRIMENULIST.SUFFIX, NUTRIMENULIST.ITEMCD, NUTRIMENULIST.SUFFIX, " & vbLf & _
                "          NUTRIMENULIST.COMPOSEFOODCD            "
    End If


    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objComposeFoodCd = objFields("COMPOSEFOODCD")
        Set objComposeFoodName = objFields("COMPOSEFOODNAME")
        Set objFoodClassCd = objFields("FOODCLASSCD")
        Set objTakeAmount = objFields("TAKEAMOUNT")
        Set objTotalEnergy = objFields("TOTALENERGY")
        Set objProtein = objFields("PROTEIN")
        Set objFat = objFields("FAT")
        Set objSugar = objFields("SUGAR")
        Set objCalcium = objFields("CALCIUM")
        Set objIron = objFields("IRON")
        Set objCholesterol = objFields("CHOLESTEROL")
        Set objSalt = objFields("SALT")
        Set objLowSaltFlg = objFields("LOWSALTFLG")

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrComposeFoodCd(lngCount)
            ReDim Preserve vntArrComposeFoodName(lngCount)
            ReDim Preserve vntArrFoodClassCd(lngCount)
            ReDim Preserve vntArrTakeAmount(lngCount)
            ReDim Preserve vntArrTotalEnergy(lngCount)
            ReDim Preserve vntArrProtein(lngCount)
            ReDim Preserve vntArrFat(lngCount)
            ReDim Preserve vntArrSugar(lngCount)
            ReDim Preserve vntArrCalcium(lngCount)
            ReDim Preserve vntArrIron(lngCount)
            ReDim Preserve vntArrCholesterol(lngCount)
            ReDim Preserve vntArrSalt(lngCount)
            ReDim Preserve vntArrLowSaltFlg(lngCount)

            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrComposeFoodCd(lngCount) = objComposeFoodCd.Value & ""
            vntArrComposeFoodName(lngCount) = objComposeFoodName.Value & ""
            vntArrFoodClassCd(lngCount) = objFoodClassCd.Value & ""
            vntArrTakeAmount(lngCount) = objTakeAmount.Value & ""
            vntArrTotalEnergy(lngCount) = objTotalEnergy.Value & ""
            vntArrProtein(lngCount) = objProtein.Value & ""
            vntArrFat(lngCount) = objFat.Value & ""
            vntArrSugar(lngCount) = objSugar.Value & ""
            vntArrCalcium(lngCount) = objCalcium.Value & ""
            vntArrIron(lngCount) = objIron.Value & ""
            vntArrCholesterol(lngCount) = objCholesterol.Value & ""
            vntArrSalt(lngCount) = objSalt.Value & ""
            vntArrLowSaltFlg(lngCount) = objLowSaltFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
        If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
        If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
        If Not IsMissing(vntComposeFoodCd) Then vntComposeFoodCd = vntArrComposeFoodCd
        If Not IsMissing(vntComposeFoodName) Then vntComposeFoodName = vntArrComposeFoodName
        If Not IsMissing(vntFoodClassCd) Then vntFoodClassCd = vntArrFoodClassCd
        If Not IsMissing(vntTakeAmount) Then vntTakeAmount = vntArrTakeAmount
        If Not IsMissing(vntTotalEnergy) Then vntTotalEnergy = vntArrTotalEnergy
        If Not IsMissing(vntProtein) Then vntProtein = vntArrProtein
        If Not IsMissing(vntFat) Then vntFat = vntArrFat
        If Not IsMissing(vntSugar) Then vntSugar = vntArrSugar
        If Not IsMissing(vntCalcium) Then vntCalcium = vntArrCalcium
        If Not IsMissing(vntIron) Then vntIron = vntArrIron
        If Not IsMissing(vntCholesterol) Then vntCholesterol = vntArrCholesterol
        If Not IsMissing(vntSalt) Then vntSalt = vntArrSalt
        If Not IsMissing(vntLowSaltFlg) Then vntLowSaltFlg = vntArrLowSaltFlg

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectNutriMenuList = lngCount

    Exit Function

ErrorHandle:

    SelectNutriMenuList = -1

    'イベントログ書き込み
    WriteErrorLog "Nourishment.SelectNutriMenuList"

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
