VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "RegistPerson"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 個人情報を登録する
'
' 引数　　 : (In)     vntPerId       個人ＩＤ
' 　　　　   (In)     strLastName    姓
' 　　　　   (In)     strFirstName   名
' 　　　　   (In)     strLastKName   カナ姓
' 　　　　   (In)     strFirstKName  カナ名
' 　　　　   (In)     dtmBirth       生年月日
' 　　　　   (In)     lngGender      性別
' 　　　　   (In)     strUserId      ユーザＩＤ
' 　　　　   (In)     strIsrSign     健保記号
' 　　　　   (In)     strIsrNo       健保番号
' 　　　　   (In)     strRelationCd  続柄コード
' 　　　　   (In)     lngBranchNo    枝番
' 　　　　   (In)     strTel1        電話番号１－市外局番
' 　　　　   (In)     strTel2        電話番号１－局番
' 　　　　   (In)     strTel3        電話番号１－番号
' 　　　　   (In)     strZipCd1      郵便番号１
' 　　　　   (In)     strZipCd2      郵便番号２
' 　　　　   (In)     strPrefCd      都道府県コード
' 　　　　   (In)     strCityName    市区町村名
' 　　　　   (In)     strAddress1    住所１
' 　　　　   (In)     strAddress2    住所２
' 　　　　   (Out)    strMessage1    メッセージ１
' 　　　　   (Out)    strMessage2    メッセージ２
' 　　　　   (In)     blnWriteTel    電話番号更新フラグ
' 　　　　   (In)     blnWriteZip    郵便番号更新フラグ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
'## 2003.02.07 Mod 41Lines By T.Takagi@FSIT 電話番号、郵便番号の警告化
'Public Function RegistPerson(
'    ByRef vntPerId As Variant,
'    ByVal strLastName As String,
'    ByVal strFirstName As String,
'    ByVal strLastKName As String,
'    ByVal strFirstKName As String,
'    ByVal dtmBirth As Date,
'    ByVal lngGender As Long,
'    ByVal strUserId As String,
'    ByVal strIsrSign As String,
'    ByVal strIsrNo As String,
'    ByVal strRelationCd As String,
'    ByVal lngBranchNo As Long,
'    ByVal strTel1 As String, ByVal strTel2 As String, ByVal strTel3 As String,
'    ByVal strZipCd1 As String, ByVal strZipCd2 As String,
'    ByVal strPrefCd As String, ByVal strCityName As String,
'    ByVal strAddress1 As String, ByVal strAddress2 As String,
'    ByRef strMessage1 As String,
'    ByRef strMessage2 As String
') As Boolean
Public Function RegistPerson( _
    ByRef vntPerId As Variant, _
    ByVal strLastName As String, _
    ByVal strFirstName As String, _
    ByVal strLastKName As String, _
    ByVal strFirstKName As String, _
    ByVal dtmBirth As Date, _
    ByVal lngGender As Long, _
    ByVal strUserId As String, _
    ByVal strIsrSign As String, _
    ByVal strIsrNo As String, _
    ByVal strRelationCd As String, _
    ByVal lngBranchNo As Long, _
    ByVal strTel1 As String, ByVal strTel2 As String, ByVal strTel3 As String, _
    ByVal strZipCd1 As String, ByVal strZipCd2 As String, _
    ByVal strPrefCd As String, ByVal strCityName As String, _
    ByVal strAddress1 As String, ByVal strAddress2 As String, _
    ByRef strMessage1 As String, _
    ByRef strMessage2 As String, _
    Optional ByVal blnWriteTel As Boolean = True, Optional ByRef blnWriteZip As Boolean = True _
) As Boolean
'## 2003.02.07 Mod End

    Dim objPerson       As Object       '個人情報アクセス用
    
    Dim vntPerId2       As Variant      '個人ＩＤ
    Dim strMode         As String       '処理モード
    
    Dim vntChildPerId   As Variant      '子個人ＩＤ
    Dim lngCount        As Long         '子個人ＩＤの数
    
    Dim udtPerson       As PERSON_INF   '個人情報レコード
    Dim Ret             As Boolean      '関数戻り値
    Dim Ret2            As Long         '関数戻り値
    Dim i               As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objPerson = CreateObject("HainsPerson.Person")
    
    '初期処理
    vntPerId2 = vntPerId
    strMessage1 = ""
    strMessage2 = ""
    
    '個人ＩＤの有無で挿入、更新の振り分けを行う
    strMode = IIf(vntPerId2 <> "", MODE_UPDATE, MODE_INSERT)
    
    Do
    
        '個人情報の登録
        Select Case strMode
        
            '個人情報の挿入
            Case MODE_INSERT
                
                Ret2 = objPerson.InsertPerson(vntPerId2, 0, 0, 0, 0, strLastName, strFirstName, strLastKName, strFirstKName, dtmBirth, lngGender, strUserId, , , , , , , , , strIsrSign, strIsrNo, strRelationCd, lngBranchNo)
    
            '個人情報の更新
            Case MODE_UPDATE
        
                Ret2 = objPerson.UpdatePerson(vntPerId2, , , , , strUserId, strLastName, strFirstName, strLastKName, strFirstKName, dtmBirth, lngGender, , , , , , , , , strIsrSign, strIsrNo, strRelationCd, lngBranchNo)
        
        End Select
        
        '更新エラーが発生した場合
        If Ret2 <= 0 Then
            
            'メッセージ取得時の引数設定
            With udtPerson
                .LastName = strLastName
                .FirstName = strFirstName
                .LastKName = strLastKName
                .FirstKName = strFirstKName
                .Birth = dtmBirth
                .Gender = lngGender
                .IsrSign = strIsrSign
                .IsrNo = strIsrNo
                .RelationCd = strRelationCd
                .BranchNo = lngBranchNo
            End With
            
            'メッセージを取得
            EditMessage 1, strMode, Ret2, vntPerId2, udtPerson, strUserId, strMessage1, strMessage2
            
            Exit Do
        End If
        
        '個人属性情報の登録
        Do
        
            '挿入かつ個人属性情報の更新値が何も存在しない場合はスキップ
            If strMode = MODE_INSERT And (strTel1 & strTel2 & strTel3 & strZipCd1 & strZipCd2 & strPrefCd & strCityName & strAddress1 & strAddress2) = "" Then
                Exit Do
            End If
        
            '個人属性情報の登録
'## 2003.02.07 Mod 2Lines By T.Takagi@FSIT 電話番号、郵便番号の警告化
'            RegistPersonDetail vntPerId2, strTel1, strTel2, strTel3, strZipCd1, strZipCd2, strPrefCd, strCityName, strAddress1, strAddress2
            RegistPersonDetail vntPerId2, strTel1, strTel2, strTel3, strZipCd1, strZipCd2, strPrefCd, strCityName, strAddress1, strAddress2, blnWriteTel, blnWriteZip
'## 2003.02.07 Mod End
        
            '本人以外の場合はここで処理終了
            If strRelationCd <> RELATIONCD_SELF Then
                Exit Do
            End If
            
            '子個人ＩＤ(家族情報)の取得
            lngCount = SelectChildPerId(vntPerId2, vntChildPerId)
            
            '家族住所等の上書き
            For i = 0 To lngCount - 1
            
                '個人属性情報の登録
'## 2003.02.07 Mod 2Lines By T.Takagi@FSIT 電話番号、郵便番号の警告化
'                RegistPersonDetail vntChildPerId(i), strTel1, strTel2, strTel3, strZipCd1, strZipCd2, strPrefCd, strCityName, strAddress1, strAddress2
                RegistPersonDetail vntChildPerId(i), strTel1, strTel2, strTel3, strZipCd1, strZipCd2, strPrefCd, strCityName, strAddress1, strAddress2, blnWriteTel, blnWriteZip
'## 2003.02.07 Mod End
            
            Next i
        
            Exit Do
        Loop
        
        'メッセージ取得時の引数設定
        With udtPerson
            .LastName = strLastName
            .FirstName = strFirstName
            .LastKName = strLastKName
            .FirstKName = strFirstKName
            .Birth = dtmBirth
            .Gender = lngGender
            .IsrSign = strIsrSign
            .IsrNo = strIsrNo
            .RelationCd = strRelationCd
            .BranchNo = lngBranchNo
        End With
            
        '正常終了時のメッセージを取得
        EditMessage 1, strMode, 1, vntPerId2, udtPerson, strUserId, strMessage1, strMessage2
        
        '戻り値の設定
        vntPerId = vntPerId2
        
        Ret = True
        Exit Do
    Loop
    
    '正常終了時のみコミットを行う
    If Ret = True Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    RegistPerson = Ret
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RegistPerson.RegistPerson"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人属性情報を登録する
'
' 引数　　 : (In)     strPerId     個人ＩＤ
' 　　　　   (In)     strTel1      電話番号１－市外局番
' 　　　　   (In)     strTel2      電話番号１－局番
' 　　　　   (In)     strTel3      電話番号１－番号
' 　　　　   (In)     strZipCd1    郵便番号１
' 　　　　   (In)     strZipCd2    郵便番号２
' 　　　　   (In)     strPrefCd    都道府県コード
' 　　　　   (In)     strCityName  市区町村名
' 　　　　   (In)     strAddress1  住所１
' 　　　　   (In)     strAddress2  住所２
' 　　　　   (In)     blnWriteTel  電話番号更新フラグ
' 　　　　   (In)     blnWriteZip  郵便番号更新フラグ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
'## 2003.02.07 Mod 25Lines By T.Takagi@FSIT 電話番号、郵便番号の警告化
'Private Function RegistPersonDetail(
'    ByVal strPerId As String,
'    ByVal strTel1 As String,
'    ByVal strTel2 As String,
'    ByVal strTel3 As String,
'    ByVal strZipCd1 As String,
'    ByVal strZipCd2 As String,
'    ByVal strPrefCd As String,
'    ByVal strCityName As String,
'    ByVal strAddress1 As String,
'    ByVal strAddress2 As String
') As Boolean
'## 2003.04.04 Mod 26Lines By T.Takagi@FSIT 個人情報削除機能追加
'Private Function RegistPersonDetail(
'    ByVal strPerId As String,
'    ByVal strTel1 As String,
'    ByVal strTel2 As String,
'    ByVal strTel3 As String,
'    ByVal strZipCd1 As String,
'    ByVal strZipCd2 As String,
'    ByVal strPrefCd As String,
'    ByVal strCityName As String,
'    ByVal strAddress1 As String,
'    ByVal strAddress2 As String,
'    Optional ByVal blnWriteTel As Boolean = True, Optional ByRef blnWriteZip As Boolean = True
') As Boolean
Public Function RegistPersonDetail( _
    ByVal strPerId As String, _
    ByVal strTel1 As String, _
    ByVal strTel2 As String, _
    ByVal strTel3 As String, _
    ByVal strZipCd1 As String, _
    ByVal strZipCd2 As String, _
    ByVal strPrefCd As String, _
    ByVal strCityName As String, _
    ByVal strAddress1 As String, _
    ByVal strAddress2 As String, _
    Optional ByVal blnWriteTel As Boolean = True, Optional ByRef blnWriteZip As Boolean = True _
) As Boolean
'## 2003.04.04 Mod End
'## 2003.02.07 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TEL1", strTel1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TEL2", strTel2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TEL3", strTel3, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ZIPCD1", strZipCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ZIPCD2", strZipCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PREFCD", strPrefCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CITYNAME", StrConv(strCityName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS1", StrConv(strAddress1, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS2", StrConv(strAddress2, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
    
        '個人属性情報テーブルレコードを更新する
'## 2003.02.07 Mod 32Lines By T.Takagi@FSIT 電話番号、郵便番号の警告化
'        strStmt = "UPDATE PERSONDETAIL          " & vbLf & _
'                  "   SET TEL1     = :TEL1,     " & vbLf & _
'                  "       TEL2     = :TEL2,     " & vbLf & _
'                  "       TEL3     = :TEL3,     " & vbLf & _
'                  "       ZIPCD1   = :ZIPCD1,   " & vbLf & _
'                  "       ZIPCD2   = :ZIPCD2,   " & vbLf & _
'                  "       PREFCD   = :PREFCD,   " & vbLf & _
'                  "       CITYNAME = :CITYNAME, " & vbLf & _
'                  "       ADDRESS1 = :ADDRESS1, " & vbLf & _
'                  "       ADDRESS2 = :ADDRESS2  " & vbLf & _
'                  " WHERE PERID    = :PERID     "
        strStmt = "UPDATE PERSONDETAIL SET "
                  
        If blnWriteTel Then
            strStmt = strStmt & vbLf & _
                  "       TEL1     = :TEL1,     " & vbLf & _
                  "       TEL2     = :TEL2,     " & vbLf & _
                  "       TEL3     = :TEL3,     "
        End If
        
        If blnWriteZip Then
            strStmt = strStmt & vbLf & _
                  "       ZIPCD1   = :ZIPCD1,   " & vbLf & _
                  "       ZIPCD2   = :ZIPCD2,   "
        End If
                  
        strStmt = strStmt & vbLf & _
                  "       PREFCD   = :PREFCD,   " & vbLf & _
                  "       CITYNAME = :CITYNAME, " & vbLf & _
                  "       ADDRESS1 = :ADDRESS1, " & vbLf & _
                  "       ADDRESS2 = :ADDRESS2  " & vbLf & _
                  " WHERE PERID    = :PERID     "
'## 2003.02.07 Mod End
    
        Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
        If Ret > 0 Then
            Exit Do
        End If
        
        '更新レコードが存在しなかった場合は挿入を行う
'## 2003.02.07 Mod 66Lines By T.Takagi@FSIT 電話番号、郵便番号の警告化
'        strStmt = "INSERT INTO PERSONDETAIL ( " & vbLf & _
'                  "                PERID,     " & vbLf & _
'                  "                TEL1,      " & vbLf & _
'                  "                TEL2,      " & vbLf & _
'                  "                TEL3,      " & vbLf & _
'                  "                ZIPCD1,    " & vbLf & _
'                  "                ZIPCD2,    " & vbLf & _
'                  "                PREFCD,    " & vbLf & _
'                  "                CITYNAME,  " & vbLf & _
'                  "                ADDRESS1,  " & vbLf & _
'                  "                ADDRESS2   " & vbLf & _
'                  "            ) VALUES (     " & vbLf & _
'                  "                :PERID,    " & vbLf & _
'                  "                :TEL1,     " & vbLf & _
'                  "                :TEL2,     " & vbLf & _
'                  "                :TEL3,     " & vbLf & _
'                  "                :ZIPCD1,   " & vbLf & _
'                  "                :ZIPCD2,   " & vbLf & _
'                  "                :PREFCD,   " & vbLf & _
'                  "                :CITYNAME, " & vbLf & _
'                  "                :ADDRESS1, " & vbLf & _
'                  "                :ADDRESS2  " & vbLf & _
'                  "            )              "
        strStmt = "INSERT INTO PERSONDETAIL ( " & vbLf & _
                  "                PERID,     "

        If blnWriteTel Then
            strStmt = strStmt & vbLf & _
                  "                TEL1,      " & vbLf & _
                  "                TEL2,      " & vbLf & _
                  "                TEL3,      "
        End If
        
        If blnWriteZip Then
            strStmt = strStmt & vbLf & _
                  "                ZIPCD1,    " & vbLf & _
                  "                ZIPCD2,    "
        End If
                  
        strStmt = strStmt & vbLf & _
                  "                PREFCD,    " & vbLf & _
                  "                CITYNAME,  " & vbLf & _
                  "                ADDRESS1,  " & vbLf & _
                  "                ADDRESS2   " & vbLf & _
                  "            ) VALUES (     " & vbLf & _
                  "                :PERID,    "

        If blnWriteTel Then
            strStmt = strStmt & vbLf & _
                  "                :TEL1,     " & vbLf & _
                  "                :TEL2,     " & vbLf & _
                  "                :TEL3,     "
        End If
        
        If blnWriteZip Then
            strStmt = strStmt & vbLf & _
                  "                :ZIPCD1,   " & vbLf & _
                  "                :ZIPCD2,   "
        End If
                  
        strStmt = strStmt & vbLf & _
                  "                :PREFCD,   " & vbLf & _
                  "                :CITYNAME, " & vbLf & _
                  "                :ADDRESS1, " & vbLf & _
                  "                :ADDRESS2  " & vbLf & _
                  "            )              "
'## 2003.02.07 Mod End

        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

        Exit Do
    Loop

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    RegistPersonDetail = True
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RegistPerson.RegistPersonDetail"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定個人ＩＤと同一健保記号、番号をもつ子個人ＩＤを取得する
'
' 引数　　 : (In)     strPerId  個人ＩＤ
' 　　　　   (Out)    vntPerId  子個人ＩＤ
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Private Function SelectChildPerId(ByVal strPerId As String, ByRef vntPerId As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPerId        As OraField         '個人ＩＤ
    
    Dim vntArrPerId()   As Variant          '個人ＩＤ
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntPerId = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '指定個人ＩＤと同一健保記号、健保番号をもつ個人情報を取得
    strStmt = "SELECT PERID                     " & vbLf & _
              "  FROM PERSON                    " & vbLf & _
              " WHERE PERID != :PERID           " & vbLf & _
              "   AND ( ISRSIGN, ISRNO ) IN     " & vbLf & _
              "       ( SELECT ISRSIGN, ISRNO   " & vbLf & _
              "           FROM PERSON           " & vbLf & _
              "          WHERE PERID = :PERID ) "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPerId(lngCount)
            vntArrPerId(lngCount) = objPerId.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntPerId = vntArrPerId
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectChildPerId = lngCount
    
    Exit Function
    
ErrorHandle:

    SelectChildPerId = -1

    'イベントログ書き込み
    WriteErrorLog "RegistPerson.SelectChildPerId"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 指定健保記号・番号・続柄・枝番の個人情報を取得する
'
' 引数　　 : (In)     strIsrSign     健保記号
' 　　　　   (In)     strIsrNo       健保番号
' 　　　　   (In)     strRelationCd  続柄コード
' 　　　　   (In)     lngBranchNo    枝番
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntLastName    姓
' 　　　　   (Out)    vntFirstName   名
' 　　　　   (Out)    vntLastKName   カナ姓
' 　　　　   (Out)    vntFirstKName  カナ名
' 　　　　   (Out)    vntBirth       生年月日
' 　　　　   (Out)    vntGender      性別
' 　　　　   (Out)    vntTel1        電話番号１－市外局番
' 　　　　   (Out)    vntTel2        電話番号１－局番
' 　　　　   (Out)    vntTel3        電話番号１－番号
' 　　　　   (Out)    vntZipCd1      郵便番号１
' 　　　　   (Out)    vntZipCd2      郵便番号２
' 　　　　   (Out)    vntPrefCd      都道府県コード
' 　　　　   (Out)    vntCityName    市区町村名
' 　　　　   (Out)    vntAddress1    住所１
' 　　　　   (Out)    vntAddress2    住所２
' 　　　　   (In)     strOrgCd1      団体コード１
' 　　　　   (In)     strOrgCd2      団体コード２
' 　　　　   (Out)    vntEmpNo       従業員番号
'
' 戻り値　 : >0  レコードがただ１件のみ存在
' 　　　　   0   レコードが複数存在
' 　　　　   <0  レコードなし、または異常終了
'
' 備考　　 :
'
'## 2003.04.04 Mod 44Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
'Public Function SelectPersonFromIsr(
'    ByVal strIsrSign As String,
'    ByVal strIsrNo As String,
'    ByVal strRelationCd As String,
'    ByVal lngBranchNo As Long,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntLastName As Variant,
'    Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant,
'    Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntBirth As Variant,
'    Optional ByRef vntGender As Variant,
'    Optional ByRef vntTel1 As Variant,
'    Optional ByRef vntTel2 As Variant,
'    Optional ByRef vntTel3 As Variant,
'    Optional ByRef vntZipCd1 As Variant,
'    Optional ByRef vntZipCd2 As Variant,
'    Optional ByRef vntPrefCd As Variant,
'    Optional ByRef vntCityName As Variant,
'    Optional ByRef vntAddress1 As Variant,
'    Optional ByRef vntAddress2 As Variant
') As Boolean
'## 2003.04.22 Mod 47Lines By T.Takagi@FSIT 団体情報を引数に追加
'Public Function SelectPersonFromIsr(
'    ByVal strIsrSign As String,
'    ByVal strIsrNo As String,
'    ByVal strRelationCd As String,
'    ByVal lngBranchNo As Long,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntLastName As Variant,
'    Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant,
'    Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntBirth As Variant,
'    Optional ByRef vntGender As Variant,
'    Optional ByRef vntTel1 As Variant,
'    Optional ByRef vntTel2 As Variant,
'    Optional ByRef vntTel3 As Variant,
'    Optional ByRef vntZipCd1 As Variant,
'    Optional ByRef vntZipCd2 As Variant,
'    Optional ByRef vntPrefCd As Variant,
'    Optional ByRef vntCityName As Variant,
'    Optional ByRef vntAddress1 As Variant,
'    Optional ByRef vntAddress2 As Variant
') As Long
Public Function SelectPersonFromIsr( _
    ByVal strIsrSign As String, _
    ByVal strIsrNo As String, _
    ByVal strRelationCd As String, _
    ByVal lngBranchNo As Long, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntBirth As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntTel1 As Variant, _
    Optional ByRef vntTel2 As Variant, _
    Optional ByRef vntTel3 As Variant, _
    Optional ByRef vntZipCd1 As Variant, _
    Optional ByRef vntZipCd2 As Variant, _
    Optional ByRef vntPrefCd As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, _
    Optional ByRef vntAddress2 As Variant, _
    Optional ByVal strOrgCd1 As String, _
    Optional ByVal strOrgCd2 As String, _
    Optional ByRef vntEmpNo As Variant _
) As Long
'## 2003.04.22 Mod End
'## 2003.04.04 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPerId        As OraField         '個人ＩＤ
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objBirth        As OraField         '生年月日
    Dim objGender       As OraField         '性別
    Dim objTel1         As OraField         '電話番号１－市外局番
    Dim objTel2         As OraField         '電話番号１－局番
    Dim objTel3         As OraField         '電話番号１－番号
    Dim objZipCd1       As OraField         '郵便番号１
    Dim objZipCd2       As OraField         '郵便番号２
    Dim objPrefCd       As OraField         '都道府県コード
    Dim objCityName     As OraField         '市区町村名
    Dim objAddress1     As OraField         '住所１
    Dim objAddress2     As OraField         '住所２
'## 2003.04.22 Add 1Line By T.Takagi@FSIT 団体情報を引数に追加
    Dim objEmpNo        As OraField         '従業員番号
'## 2003.04.22 Add End

'## 2003.04.04 Add 16Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
    Dim strPerId        As String           '個人ＩＤ
    Dim strLastName     As String           '姓
    Dim strFirstName    As String           '名
    Dim strLastKName    As String           'カナ姓
    Dim strFirstKName   As String           'カナ名
    Dim strBirth        As String           '生年月日
    Dim strGender       As String           '性別
    Dim strTel1         As String           '電話番号１－市外局番
    Dim strTel2         As String           '電話番号１－局番
    Dim strTel3         As String           '電話番号１－番号
    Dim strZipCd1       As String           '郵便番号１
    Dim strZipCd2       As String           '郵便番号２
    Dim strPrefCd       As String           '都道府県コード
    Dim strCityName     As String           '市区町村名
    Dim strAddress1     As String           '住所１
    Dim strAddress2     As String           '住所２
'## 2003.04.04 Add End
'## 2003.04.22 Add 1Line By T.Takagi@FSIT 団体情報を引数に追加
    Dim strEmpNo        As String           '従業員番号
'## 2003.04.22 Add End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

'## 2003.04.04 Add 1Line By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
    SelectPersonFromIsr = -1
'## 2003.04.04 Add End

    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntTel1) Then vntTel1 = Empty
    If Not IsMissing(vntTel2) Then vntTel2 = Empty
    If Not IsMissing(vntTel3) Then vntTel3 = Empty
    If Not IsMissing(vntZipCd1) Then vntZipCd1 = Empty
    If Not IsMissing(vntZipCd2) Then vntZipCd2 = Empty
    If Not IsMissing(vntPrefCd) Then vntPrefCd = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
'## 2003.04.22 Add 1Line By T.Takagi@FSIT 団体情報を引数に追加
    If Not IsMissing(vntEmpNo) Then vntEmpNo = Empty
'## 2003.04.22 Add End
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRNO", strIsrNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RELATIONCD", strRelationCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.04.22 Add 2Lines By T.Takagi@FSIT 団体情報を引数に追加
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.04.22 Add End

    '検索条件を満たす個人テーブルおよび個人属性テーブルのレコードを取得
    strStmt = "SELECT PERSON.PERID,      PERSON.LASTNAME,  " & vbLf & _
              "       PERSON.FIRSTNAME,  PERSON.LASTKNAME, " & vbLf & _
              "       PERSON.FIRSTKNAME, PERSON.BIRTH,     " & vbLf & _
              "       PERSON.GENDER,                       "

'## 2003.04.22 Add 2Lines By T.Takagi@FSIT 団体情報を引数に追加
    strStmt = strStmt & vbLf & _
              "       PERSON.EMPNO, "
'## 2003.04.22 Add End

    strStmt = strStmt & vbLf & _
              "       PERSONDETAIL.TEL1,     PERSONDETAIL.TEL2,     " & vbLf & _
              "       PERSONDETAIL.TEL3,     PERSONDETAIL.ZIPCD1,   " & vbLf & _
              "       PERSONDETAIL.ZIPCD2,   PERSONDETAIL.PREFCD,   " & vbLf & _
              "       PERSONDETAIL.CITYNAME, PERSONDETAIL.ADDRESS1, " & vbLf & _
              "       PERSONDETAIL.ADDRESS2                         " & vbLf & _
              "  FROM PERSONDETAIL, PERSON                          "
              
    strStmt = strStmt & vbLf & _
              " WHERE PERSON.ISRSIGN    = :ISRSIGN              " & vbLf & _
              "   AND PERSON.ISRNO      = :ISRNO                " & vbLf & _
              "   AND PERSON.RELATIONCD = :RELATIONCD           " & vbLf & _
              "   AND PERSON.BRANCHNO   = :BRANCHNO             " & vbLf & _
              "   AND PERSON.PERID      = PERSONDETAIL.PERID(+) "

'## 2003.04.22 Add 5Lines By T.Takagi@FSIT 団体情報を引数に追加
    If strOrgCd1 <> "" And strOrgCd2 <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND PERSON.ORGCD1     = :ORGCD1 " & vbLf & _
              "   AND PERSON.ORGCD2     = :ORGCD2 "
    End If
'## 2003.04.22 Add End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objTel1 = objFields("TEL1")
        Set objTel2 = objFields("TEL2")
        Set objTel3 = objFields("TEL3")
        Set objZipCd1 = objFields("ZIPCD1")
        Set objZipCd2 = objFields("ZIPCD2")
        Set objPrefCd = objFields("PREFCD")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
'## 2003.04.22 Add 1Line By T.Takagi@FSIT 団体情報を引数に追加
        Set objEmpNo = objFields("EMPNO")
'## 2003.04.22 Add End

'## 2003.04.04 Mod 60Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
'        '戻り値の設定
'        If Not IsMissing(vntPerId) Then vntPerId = objPerId.Value & ""
'        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value & ""
'        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
'        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value & ""
'        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
'        If Not IsMissing(vntBirth) Then vntBirth = objBirth.Value & ""
'        If Not IsMissing(vntGender) Then vntGender = objGender.Value & ""
'        If Not IsMissing(vntTel1) Then vntTel1 = objTel1.Value & ""
'        If Not IsMissing(vntTel2) Then vntTel2 = objTel2.Value & ""
'        If Not IsMissing(vntTel3) Then vntTel3 = objTel3.Value & ""
'        If Not IsMissing(vntZipCd1) Then vntZipCd1 = objZipCd1.Value & ""
'        If Not IsMissing(vntZipCd2) Then vntZipCd2 = objZipCd2.Value & ""
'        If Not IsMissing(vntPrefCd) Then vntPrefCd = objPrefCd.Value & ""
'        If Not IsMissing(vntCityName) Then vntCityName = objCityName.Value & ""
'        If Not IsMissing(vntAddress1) Then vntAddress1 = objAddress1.Value & ""
'        If Not IsMissing(vntAddress2) Then vntAddress2 = objAddress2.Value & ""
'
'        SelectPersonFromIsr = True
        'まずは先頭レコードの内容を退避
        strPerId = objPerId.Value & ""
        strLastName = objLastName.Value & ""
        strFirstName = objFirstName.Value & ""
        strLastKName = objLastKName.Value & ""
        strFirstKName = objFirstKName.Value & ""
        strBirth = objBirth.Value & ""
        strGender = objGender.Value & ""
        strTel1 = objTel1.Value & ""
        strTel2 = objTel2.Value & ""
        strTel3 = objTel3.Value & ""
        strZipCd1 = objZipCd1.Value & ""
        strZipCd2 = objZipCd2.Value & ""
        strPrefCd = objPrefCd.Value & ""
        strCityName = objCityName.Value & ""
        strAddress1 = objAddress1.Value & ""
        strAddress2 = objAddress2.Value & ""
'## 2003.04.22 Add 1Line By T.Takagi@FSIT 団体情報を引数に追加
        strEmpNo = objEmpNo.Value & ""
'## 2003.04.22 Add End
        
        'これ以上レコードがあれば複数存在として戻り値を返し、なければ先頭レコードの内容を返す
        objOraDyna.MoveNext
        If Not objOraDyna.EOF Then
            SelectPersonFromIsr = 0
        Else
            If Not IsMissing(vntPerId) Then vntPerId = strPerId
            If Not IsMissing(vntLastName) Then vntLastName = strLastName
            If Not IsMissing(vntFirstName) Then vntFirstName = strFirstName
            If Not IsMissing(vntLastKName) Then vntLastKName = strLastKName
            If Not IsMissing(vntFirstKName) Then vntFirstKName = strFirstKName
            If Not IsMissing(vntBirth) Then vntBirth = strBirth
            If Not IsMissing(vntGender) Then vntGender = strGender
            If Not IsMissing(vntTel1) Then vntTel1 = strTel1
            If Not IsMissing(vntTel2) Then vntTel2 = strTel2
            If Not IsMissing(vntTel3) Then vntTel3 = strTel3
            If Not IsMissing(vntZipCd1) Then vntZipCd1 = strZipCd1
            If Not IsMissing(vntZipCd2) Then vntZipCd2 = strZipCd2
            If Not IsMissing(vntPrefCd) Then vntPrefCd = strPrefCd
            If Not IsMissing(vntCityName) Then vntCityName = strCityName
            If Not IsMissing(vntAddress1) Then vntAddress1 = strAddress1
            If Not IsMissing(vntAddress2) Then vntAddress2 = strAddress2
'## 2003.04.22 Add 1Line By T.Takagi@FSIT 団体情報を引数に追加
            If Not IsMissing(vntEmpNo) Then vntEmpNo = strEmpNo
'## 2003.04.22 Add End
            SelectPersonFromIsr = 1
        End If
'## 2003.04.04 Mod End
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

'## 2003.04.04 Mod 2Lines By T.Takagi@FSIT 健保記号、健保番号、続柄、枝番の重複を許すため、戻り値を変更
'    SelectPersonFromIsr = False
    SelectPersonFromIsr = -1
'## 2003.04.04 Mod End

    'イベントログ書き込み
    WriteErrorLog "RegistPerson.SelectPersonFromIsr"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 指定団体・従業員番号の個人情報を取得する
'
' 引数　　 : (In)     strOrgCd1      団体コード１
' 　　　　   (In)     strOrgCd2      団体コード２
' 　　　　   (In)     strEmpNo       従業員番号
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntLastName    姓
' 　　　　   (Out)    vntFirstName   名
' 　　　　   (Out)    vntLastKName   カナ姓
' 　　　　   (Out)    vntFirstKName  カナ名
' 　　　　   (Out)    vntBirth       生年月日
' 　　　　   (Out)    vntGender      性別
' 　　　　   (Out)    vntIsrSign     健保記号
' 　　　　   (Out)    vntIsrNo       健保番号
' 　　　　   (Out)    vntRelationCd  続柄コード
' 　　　　   (Out)    vntBranchNo    枝番
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPersonFromOrg( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strEmpNo As String, _
    ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntBirth As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntIsrSign As Variant, _
    Optional ByRef vntIsrNo As Variant, _
    Optional ByRef vntRelationCd As Variant, _
    Optional ByRef vntBranchNo As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPerId        As Object           '個人ＩＤ
    Dim objLastName     As Object           '姓
    Dim objFirstName    As Object           '名
    Dim objLastKName    As Object           'カナ姓
    Dim objFirstKName   As Object           'カナ名
    Dim objBirth        As Object           '生年月日
    Dim objGender       As Object           '性別
    Dim objIsrSign      As Object           '健保記号
    Dim objIsrNo        As Object           '健保番号
    Dim objRelationCd   As Object           '続柄コード
    Dim objBranchNo     As Object           '枝番

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If Not IsMissing(vntIsrNo) Then vntIsrNo = Empty
    If Not IsMissing(vntRelationCd) Then vntRelationCd = Empty
    If Not IsMissing(vntBranchNo) Then vntBranchNo = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMPNO", strEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす個人属性テーブルのレコードを取得
    strStmt = "SELECT PERID,      LASTNAME,   " & vbLf & _
              "       FIRSTNAME,  LASTKNAME,  " & vbLf & _
              "       FIRSTKNAME, BIRTH,      " & vbLf & _
              "       GENDER,     ISRSIGN,    " & vbLf & _
              "       ISRNO,      RELATIONCD, " & vbLf & _
              "       BRANCHNO                " & vbLf & _
              "  FROM PERSON                  " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1        " & vbLf & _
              "   AND ORGCD2 = :ORGCD2        " & vbLf & _
              "   AND EMPNO  = :EMPNO         "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrNo = objFields("ISRNO")
        Set objRelationCd = objFields("RELATIONCD")
        Set objBranchNo = objFields("BRANCHNO")

        '戻り値の設定
        vntPerId = objPerId.Value & ""
        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value & ""
        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value & ""
        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
        If Not IsMissing(vntBirth) Then vntBirth = objBirth.Value & ""
        If Not IsMissing(vntGender) Then vntGender = objGender.Value & ""
        If Not IsMissing(vntIsrSign) Then vntIsrSign = objIsrSign.Value & ""
        If Not IsMissing(vntIsrNo) Then vntIsrNo = objIsrNo.Value & ""
        If Not IsMissing(vntRelationCd) Then vntRelationCd = objRelationCd.Value & ""
        If Not IsMissing(vntBranchNo) Then vntBranchNo = objBranchNo.Value & ""
        
        SelectPersonFromOrg = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPersonFromOrg = False

    'イベントログ書き込み
    WriteErrorLog "RegistPerson.SelectPersonFromOrg"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'## 2003.04.24 Add Function By T.Takagi@FSIT 未受診者取得機能追加
'
' 機能　　 : 指定団体から指定期間に受診していない個人情報を取得
'
' 引数　　 : (In)     strOrgCd1      団体コード１
' 　　　　   (In)     strOrgCd2      団体コード２
' 　　　　   (In)     dtmStrCslDate  開始受診日
' 　　　　   (In)     dtmEndCslDate  終了受診日
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntLastName    姓
' 　　　　   (Out)    vntFirstName   名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectPersonNotConsult(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, ByRef vntPerId As Variant, ByRef vntLastName As Variant, ByRef vntFirstName As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrLastName()    As Variant          '姓の配列
    Dim vntArrFirstName()   As Variant          '名の配列
    Dim lngCount            As Long             'レコード数

    Dim dtmCslDate          As Date             '受診日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntPerId = Empty
    vntLastName = Empty
    vntFirstName = Empty
    lngCount = 0

    '受診日の大小による値の交換(ByVal渡しなので直接交換しても問題なし)
    If dtmStrCslDate > dtmEndCslDate Then
        dtmCslDate = dtmStrCslDate
        dtmStrCslDate = dtmEndCslDate
        dtmEndCslDate = dtmCslDate
    End If

    'キー値及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '指定期間に受診していない個人情報を取得
    strStmt = "SELECT PERID, LASTNAME, FIRSTNAME                                              " & vbLf & _
              "  FROM PERSON                                                                  " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1                                                        " & vbLf & _
              "   AND ORGCD2 = :ORGCD2                                                        " & vbLf & _
              "   AND NOT EXISTS ( SELECT CONSULT.PERID                                       " & vbLf & _
              "                      FROM RECEIPT, CONSULT                                    " & vbLf & _
              "                     WHERE CONSULT.PERID = PERSON.PERID                        " & vbLf & _
              "                       AND CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE " & vbLf & _
              "                       AND CONSULT.RSVNO = RECEIPT.RSVNO )                     "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntPerId = vntArrPerId
        vntLastName = vntArrLastName
        vntFirstName = vntArrFirstName
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectPersonNotConsult = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RegistPerson.SelectPersonNotConsult"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2003.04.04 Add Function By T.Takagi@FSIT 個人情報削除機能追加
'
' 機能　　 : 指定個人ＩＤと同一健保記号、番号、続柄、枝番を持つ、従業員情報が未設定である個人情報を取得
'
' 引数　　 : (In)     strPerId        個人ＩＤ
' 　　　　   (Out)    vntPerId        個人ＩＤ
' 　　　　   (Out)    vntLastName     姓
' 　　　　   (Out)    vntFirstName    名
' 　　　　   (Out)    vntTel1         電話番号１－市外局番
' 　　　　   (Out)    vntTel2         電話番号１－局番
' 　　　　   (Out)    vntTel3         電話番号１－番号
' 　　　　   (Out)    vntZipCd1       郵便番号１
' 　　　　   (Out)    vntZipCd2       郵便番号２
' 　　　　   (Out)    vntPrefCd       都道府県コード
' 　　　　   (Out)    vntCityName     市区町村名
' 　　　　   (Out)    vntAddress1     住所１
' 　　　　   (Out)    vntAddress2     住所２
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectPersonSameIsr( _
    ByVal strPerId As String, _
    ByRef vntPerId As Variant, _
    ByRef vntLastName As Variant, _
    ByRef vntFirstName As Variant, _
    ByRef vntTel1 As Variant, _
    ByRef vntTel2 As Variant, _
    ByRef vntTel3 As Variant, _
    ByRef vntZipCd1 As Variant, _
    ByRef vntZipCd2 As Variant, _
    ByRef vntPrefCd As Variant, _
    ByRef vntCityName As Variant, _
    ByRef vntAddress1 As Variant, _
    ByRef vntAddress2 As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objTel1             As OraField         '電話番号１－市外局番
    Dim objTel2             As OraField         '電話番号１－局番
    Dim objTel3             As OraField         '電話番号１－番号
    Dim objZipCd1           As OraField         '郵便番号１
    Dim objZipCd2           As OraField         '郵便番号２
    Dim objPrefCd           As OraField         '都道府県コード
    Dim objCityName         As OraField         '市区町村名
    Dim objAddress1         As OraField         '住所１
    Dim objAddress2         As OraField         '住所２
    
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrLastName()    As Variant          '姓の配列
    Dim vntArrFirstName()   As Variant          '名の配列
    Dim vntArrTel1()        As Variant          '電話番号１－市外局番の配列
    Dim vntArrTel2()        As Variant          '電話番号１－局番の配列
    Dim vntArrTel3()        As Variant          '電話番号１－番号の配列
    Dim vntArrZipCd1()      As Variant          '郵便番号１の配列
    Dim vntArrZipCd2()      As Variant          '郵便番号２の配列
    Dim vntArrPrefCd()      As Variant          '都道府県コードの配列
    Dim vntArrCityName()    As Variant          '市区町村名の配列
    Dim vntArrAddress1()    As Variant          '住所１の配列
    Dim vntArrAddress2()    As Variant          '住所２の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntPerId = Empty
    vntLastName = Empty
    vntFirstName = Empty
    vntTel1 = Empty
    vntTel2 = Empty
    vntTel3 = Empty
    vntZipCd1 = Empty
    vntZipCd2 = Empty
    vntPrefCd = Empty
    vntCityName = Empty
    vntAddress1 = Empty
    vntAddress2 = Empty
    lngCount = 0

    'キー値及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '指定個人ＩＤと同一健保記号、番号、続柄、枝番を持つ、従業員情報が未設定である個人情報を取得
    '(通常、このようなデータは健保からの取り込みデータである。)
    strStmt = "SELECT PERSON.PERID,          " & vbLf & _
              "       PERSON.LASTNAME,       " & vbLf & _
              "       PERSON.FIRSTNAME,      " & vbLf & _
              "       PERSON.UPDDATE,        " & vbLf & _
              "       PERSONDETAIL.TEL1,     " & vbLf & _
              "       PERSONDETAIL.TEL2,     " & vbLf & _
              "       PERSONDETAIL.TEL3,     " & vbLf & _
              "       PERSONDETAIL.ZIPCD1,   " & vbLf & _
              "       PERSONDETAIL.ZIPCD2,   " & vbLf & _
              "       PERSONDETAIL.PREFCD,   " & vbLf & _
              "       PERSONDETAIL.CITYNAME, " & vbLf & _
              "       PERSONDETAIL.ADDRESS1, " & vbLf & _
              "       PERSONDETAIL.ADDRESS2  "

    strStmt = strStmt & vbLf & _
              "  FROM PERSONDETAIL, PERSON,                                                      " & vbLf & _
              "       ( SELECT PERID, ISRSIGN, ISRNO, RELATIONCD, BRANCHNO                       " & vbLf & _
              "           FROM PERSON                                                            " & vbLf & _
              "          WHERE PERID = :PERID                                                    " & vbLf & _
              "       ) BASEDPERSON                                                              " & vbLf & _
              " WHERE PERSON.ISRSIGN    = BASEDPERSON.ISRSIGN                                    " & vbLf & _
              "   AND PERSON.ISRNO      = BASEDPERSON.ISRNO                                      " & vbLf & _
              "   AND PERSON.RELATIONCD = BASEDPERSON.RELATIONCD                                 " & vbLf & _
              "   AND PERSON.BRANCHNO   = BASEDPERSON.BRANCHNO                                   " & vbLf & _
              "   AND PERSON.PERID     != BASEDPERSON.PERID                                      " & vbLf & _
              "   AND ( PERSON.ORGCD1 IS NULL OR PERSON.ORGCD2 IS NULL OR PERSON.EMPNO IS NULL ) " & vbLf & _
              "   AND PERSON.PERID      = PERSONDETAIL.PERID(+)                                  " & vbLf & _
              " ORDER BY PERSON.UPDDATE                                                          "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objTel1 = objFields("TEL1")
        Set objTel2 = objFields("TEL2")
        Set objTel3 = objFields("TEL3")
        Set objZipCd1 = objFields("ZIPCD1")
        Set objZipCd2 = objFields("ZIPCD2")
        Set objPrefCd = objFields("PREFCD")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrTel1(lngCount)
            ReDim Preserve vntArrTel2(lngCount)
            ReDim Preserve vntArrTel3(lngCount)
            ReDim Preserve vntArrZipCd1(lngCount)
            ReDim Preserve vntArrZipCd2(lngCount)
            ReDim Preserve vntArrPrefCd(lngCount)
            ReDim Preserve vntArrCityName(lngCount)
            ReDim Preserve vntArrAddress1(lngCount)
            ReDim Preserve vntArrAddress2(lngCount)
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrTel1(lngCount) = objTel1.Value & ""
            vntArrTel2(lngCount) = objTel2.Value & ""
            vntArrTel3(lngCount) = objTel3.Value & ""
            vntArrZipCd1(lngCount) = objZipCd1.Value & ""
            vntArrZipCd2(lngCount) = objZipCd2.Value & ""
            vntArrPrefCd(lngCount) = objPrefCd.Value & ""
            vntArrCityName(lngCount) = objCityName.Value & ""
            vntArrAddress1(lngCount) = objAddress1.Value & ""
            vntArrAddress2(lngCount) = objAddress2.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntPerId = vntArrPerId
        vntLastName = vntArrLastName
        vntFirstName = vntArrFirstName
        vntTel1 = vntArrTel1
        vntTel2 = vntArrTel2
        vntTel3 = vntArrTel3
        vntZipCd1 = vntArrZipCd1
        vntZipCd2 = vntArrZipCd2
        vntPrefCd = vntArrPrefCd
        vntCityName = vntArrCityName
        vntAddress1 = vntArrAddress1
        vntAddress2 = vntArrAddress2
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectPersonSameIsr = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RegistPerson.SelectPersonSameIsr"
    
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
    Set objCommon = CreateObject("HainsCommon.Common")

    'データベース接続
    Set mobjOraSession = CreateObject("OracleInProcServer.XOraSession")
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
