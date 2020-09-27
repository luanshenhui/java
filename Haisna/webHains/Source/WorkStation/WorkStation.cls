VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "WorkStation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 端末管理テーブルの一覧を取得する
'
' 引数　　 : (Out)    vntIpAddress      IPアドレス
' 　　　　 : (Out)    vntWkStnName      端末名
' 　　　　 : (Out)    vntGrpCd          グループコード
' 　　　　 : (Out)    vntGrpName        グループ名
' 　　　　 : (Out)    vntProgressCd     進捗分類コード
' 　　　　 : (Out)    vntProgressName   進捗分類名
' 　　　　   (Out)    vntIsPrintButton  印刷ボタン表示
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectWorkStationList(ByRef vntIpAddress As Variant, _
                                      ByRef vntWkStnName As Variant, _
                                      ByRef vntGrpCd As Variant, _
                                      ByRef vntGrpName As Variant, _
                                      Optional ByRef vntProgressCd As Variant, _
                                      Optional ByRef vntProgressName As Variant, _
                                      Optional ByRef vntIsPrintButton As Variant) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objIPAddress            As OraField         'IPアドレス
    Dim objWkStnName            As OraField         '端末名
    Dim objGrpCd                As OraField         'グループコード
    Dim objGrpName              As OraField         'グループ名
    Dim objProgressCd           As OraField         '進捗分類コード
    Dim objProgressName         As OraField         '進捗分類名
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
    Dim objIsPrintButton        As OraField         '印刷ボタン表示
'### 2003.02.19 Added End
    
    Dim vntArrIPAddress()       As Variant          'IPアドレスの配列
    Dim vntArrWkStnName()       As Variant          '端末名の配列
    Dim vntArrGrpCd()           As Variant          'グループコードの配列
    Dim vntArrGrpName()         As Variant          'グループ名の配列
    Dim vntArrProgressCd()      As Variant          '進捗分類コードの配列
    Dim vntArrProgressName()    As Variant          '進捗分類名の配列
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
    Dim vntArrIsPrintButton()   As Variant          '印刷ボタン表示
'### 2003.02.19 Added End
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectWorkStationList = 0
    lngCount = 0
    
    '端末管理テーブルよりレコードを取得
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
'    strStmt = "SELECT WORKSTATION.IPADDRESS, WORKSTATION.WKSTNNAME, WORKSTATION.GRPCD, GRP_P.GRPNAME," & vbLf & _
              "       WORKSTATION.PROGRESSCD, PROGRESS.PROGRESSNAME" & vbLf & _
              "  FROM PROGRESS, GRP_P, WORKSTATION" & vbLf & _
              " WHERE WORKSTATION.GRPCD = GRP_P.GRPCD(+)" & vbLf & _
              "   AND WORKSTATION.PROGRESSCD = PROGRESS.PROGRESSCD(+)" & vbLf & _
              " ORDER BY WORKSTATION.IPADDRESS"
    strStmt = "SELECT WORKSTATION.IPADDRESS, WORKSTATION.WKSTNNAME, WORKSTATION.GRPCD, GRP_P.GRPNAME," & vbLf & _
              "       WORKSTATION.PROGRESSCD, PROGRESS.PROGRESSNAME, WORKSTATION.ISPRINTBUTTON" & vbLf & _
              "  FROM PROGRESS, GRP_P, WORKSTATION" & vbLf & _
              " WHERE WORKSTATION.GRPCD = GRP_P.GRPCD(+)" & vbLf & _
              "   AND WORKSTATION.PROGRESSCD = PROGRESS.PROGRESSCD(+)" & vbLf & _
              " ORDER BY WORKSTATION.IPADDRESS"
'### 2003.02.19 Added End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objIPAddress = objFields("IPADDRESS")
        Set objWkStnName = objFields("WKSTNNAME")
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        Set objProgressCd = objFields("PROGRESSCD")
        Set objProgressName = objFields("PROGRESSNAME")
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
        Set objIsPrintButton = objFields("ISPRINTBUTTON")
'### 2003.02.19 Added End
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrIPAddress(lngCount)
            ReDim Preserve vntArrWkStnName(lngCount)
            ReDim Preserve vntArrGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            ReDim Preserve vntArrProgressCd(lngCount)
            ReDim Preserve vntArrProgressName(lngCount)
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
            ReDim Preserve vntArrIsPrintButton(lngCount)
'### 2003.02.19 Added End
            
            vntArrIPAddress(lngCount) = objIPAddress.Value & ""
            vntArrWkStnName(lngCount) = objWkStnName.Value & ""
            vntArrGrpCd(lngCount) = objGrpCd.Value & ""
            vntArrGrpName(lngCount) = objGrpName.Value & ""
            vntArrProgressCd(lngCount) = objProgressCd.Value & ""
            vntArrProgressName(lngCount) = objProgressName.Value & ""
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
            vntArrIsPrintButton(lngCount) = objIsPrintButton.Value & ""
'### 2003.02.19 Added End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntIpAddress = vntArrIPAddress
    vntWkStnName = vntArrWkStnName
    vntGrpCd = vntArrGrpCd
    vntGrpName = vntArrGrpName
    If IsMissing(vntProgressCd) = False Then vntProgressCd = vntArrProgressCd
    If IsMissing(vntProgressName) = False Then vntProgressName = vntArrProgressName
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
    If IsMissing(vntIsPrintButton) = False Then vntIsPrintButton = vntArrIsPrintButton
'### 2003.02.19 Added End
        
    Set objOraDyna = Nothing
    Set objOraParam = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    SelectWorkStationList = lngCount
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "WorkStation.SelectWorkStationList"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 端末管理データを取得する
'
' 引数　　 : (In)     strIPADDRESS      IPアドレス
' 　　　　   (Out)    vntWkStnName      端末名
' 　　　　   (Out)    vntGrpCd          グループコード
' 　　　　   (Out)    vntGrpName        グループ名
' 　　　　   (Out)    vntProgressCd     進捗分類コード（省略可）
' 　　　　   (Out)    vntIsPrintButton  印刷ボタン表示（省略可）
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectWorkStation(ByVal strIpAddress As String, _
                                  ByRef vntWkStnName As Variant, _
                                  ByRef vntGrpCd As Variant, _
                                  ByRef vntGrpName As Variant, _
                                  Optional ByRef vntProgressCd As Variant, _
                                  Optional ByRef vntIsPrintButton As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objWkStnName        As OraField         '端末名
    Dim objGrpCd            As OraField         'グループコード
    Dim objGrpName          As OraField         'グループ名
    Dim objProgressCd       As OraField         '進捗分類コード
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
    Dim objIsPrintButton    As OraField         '進捗分類コード
'### 2003.02.19 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If strIpAddress = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "IPADDRESS", Trim(strIpAddress), ORAPARM_INPUT
    
    '検索条件を満たす端末管理テーブルのレコードを取得
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
'    strStmt = " SELECT WORKSTATION.IPADDRESS, WORKSTATION.WKSTNNAME, WORKSTATION.GRPCD, GRP_P.GRPNAME, WORKSTATION.PROGRESSCD" & vbLf & _
              "   FROM GRP_P, WORKSTATION" & vbLf & _
              "  WHERE IPADDRESS = :IPADDRESS" & vbLf & _
              "    AND WORKSTATION.GRPCD = GRP_P.GRPCD(+)"
    strStmt = " SELECT WORKSTATION.IPADDRESS, WORKSTATION.WKSTNNAME, WORKSTATION.GRPCD, " & vbLf & _
              "        GRP_P.GRPNAME, WORKSTATION.PROGRESSCD, WORKSTATION.ISPRINTBUTTON" & vbLf & _
              "   FROM GRP_P, WORKSTATION" & vbLf & _
              "  WHERE IPADDRESS = :IPADDRESS" & vbLf & _
              "    AND WORKSTATION.GRPCD = GRP_P.GRPCD(+)"
'### 2003.02.19 Added End
'              "  ORDER BY WORKSTATION.IPADDRESS"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objWkStnName = objFields("WKSTNNAME")
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        Set objProgressCd = objFields("PROGRESSCD")
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
        Set objIsPrintButton = objFields("ISPRINTBUTTON")
'### 2003.02.19 Added End
    
        '戻り値の設定
        vntWkStnName = objWkStnName.Value & ""
        vntGrpCd = objGrpCd.Value & ""
        vntGrpName = objGrpName.Value & ""
        If Not IsMissing(vntProgressCd) Then vntProgressCd = objProgressCd.Value & ""
        If Not IsMissing(vntIsPrintButton) Then vntIsPrintButton = objIsPrintButton.Value & ""
        
        SelectWorkStation = True
        
    End If
    
    'バインド変数の削除
    objOraParam.Remove "IPADDRESS"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "WkStnName.SelectWorkStation"
    
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
' 機能　　 : 端末管理データを取得する
'
' 引数　　 : (In)    dtmClsDate         受診日
' 　　　　   (In)    dtmClsDate         管理番号
' 　　　　   (In)    intDayID           当日ＩＤ
' 　　　　   (In)    vntIpAddress       IPアドレス（省略可）
' 　　　　   (Out)   vntRetIpAddress    IPアドレス～戻り値（省略可）
' 　　　　   (Out)   vntUpdDate         更新日時～戻り値（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectPassedInfo(ByVal dtmClsDate As Date, _
                                 ByVal intCntlNo As Integer, _
                                 ByVal intDayID As Integer, _
                                 Optional ByVal vntIpAddress As Variant, _
                                 Optional ByRef vntRetIpAddress As Variant, _
                                 Optional ByRef vntUpdDate As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objIPAddress        As OraField         'IPアドレス
    Dim objUpdDate          As OraField         '更新日時
    
    Dim vntArrIPAddress()   As Variant          'IPアドレス（配列）
    Dim vntArrUpdDate()     As Variant          '更新日時（配列）
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectPassedInfo = INSERT_ERROR
    
    '検索条件が設定されていない場合はエラー
    If intDayID = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmClsDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", intCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", intDayID, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす端末通過情報テーブルのレコードを取得
    strStmt = "SELECT IPADDRESS, UPDDATE " & _
              "  FROM PASSEDINFO " & _
              " WHERE CSLDATE   = :CSLDATE " & _
              "   AND CNTLNO    = :CNTLNO " & _
              "   AND DAYID     = :DAYID "
    
    'IPアドレス指定の場合
    If IsMissing(vntIpAddress) = False Then
        objOraParam.Add "IPADDRESS", Trim(vntIpAddress), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & " AND IPADDRESS = :IPADDRESS"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    Do Until objOraDyna.EOF
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objIPAddress = objFields("IPADDRESS")
        Set objUpdDate = objFields("UPDDATE")
    
        '戻り値の設定
        ReDim Preserve vntArrIPAddress(lngCount)
        ReDim Preserve vntArrUpdDate(lngCount)
        
        vntArrIPAddress(lngCount) = objIPAddress.Value & ""
        vntArrUpdDate(lngCount) = objUpdDate.Value & ""
        
        lngCount = lngCount + 1
        objOraDyna.MoveNext
        
    Loop
    
    '戻り値の設定
    If Not IsMissing(vntRetIpAddress) Then
        If lngCount = 1 Then
            vntRetIpAddress = vntArrIPAddress(0)
        Else
            vntRetIpAddress = vntArrIPAddress
        End If
    End If
    
    If Not IsMissing(vntUpdDate) Then
        If lngCount = 1 Then
            vntUpdDate = vntArrUpdDate(0)
        Else
            vntUpdDate = vntArrUpdDate
        End If
    End If
    
    SelectPassedInfo = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPassedInfo = INSERT_ERROR
    
    'イベントログ書き込み
    WriteErrorLog "IPAddress.SelectPassedInfo"
    
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
' 機能　　 : 端末管理テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strIPADDRESS       IPアドレス
' 　　　　   (In)    vntWorkStation     端末名
' 　　　　   (In)    vntGrpCd           グループコード
' 　　　　   (In)    strProgressCd      進捗分類コード
' 　　　　   (In)    vntIsPrintButton   印刷ボタン表示（省略可）
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistWorkStation(ByVal strMode As String, _
                                  ByVal strIpAddress As String, _
                                  ByVal strWkStnName As String, _
                                  ByVal strGrpCd As String, _
                                  ByVal strProgressCd As String, _
                                  ByVal strIsPrintButton As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "IPADDRESS", Trim(strIpAddress), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "WKSTNNAME", Trim(strWkStnName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PROGRESSCD", Trim(strProgressCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
    objOraParam.Add "ISPRINTBUTTON", Trim(strIsPrintButton), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.02.19 Added End

    Do
        '端末管理テーブルレコードの更新
        If strMode = "UPD" Then
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
'            strStmt = "UPDATE WORKSTATION " & _
                      "   SET WKSTNNAME = :WKSTNNAME," & _
                      "       GRPCD       = :GRPCD," & _
                      "       PROGRESSCD  = :PROGRESSCD" & _
                      " WHERE IPADDRESS   = :IPADDRESS"
            strStmt = "UPDATE WORKSTATION " & _
                      "   SET WKSTNNAME     = :WKSTNNAME," & _
                      "       GRPCD         = :GRPCD," & _
                      "       PROGRESSCD    = :PROGRESSCD," & _
                      "       ISPRINTBUTTON = :ISPRINTBUTTON" & _
                      " WHERE IPADDRESS     = :IPADDRESS"
'### 2003.02.19 Added End
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす端末管理テーブルのレコードを取得
        strStmt = "SELECT IPADDRESS FROM WORKSTATION WHERE IPADDRESS = :IPADDRESS"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'### 2003.02.19 Added by Ishihara@FSIT 印刷ボタン表示追加
'        mobjOraDb.ExecuteSQL "INSERT INTO WORKSTATION (IPADDRESS, WKSTNNAME, GRPCD, PROGRESSCD) VALUES (:IPADDRESS, :WKSTNNAME, :GRPCD, :PROGRESSCD)"
        mobjOraDb.ExecuteSQL "INSERT INTO WORKSTATION (IPADDRESS, WKSTNNAME, GRPCD, PROGRESSCD, ISPRINTBUTTON) VALUES (:IPADDRESS, :WKSTNNAME, :GRPCD, :PROGRESSCD, :ISPRINTBUTTON)"
'### 2003.02.19 Added End
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistWorkStation = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistWorkStation = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "WorkStation.RegistWorkStation"
    
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
' 機能　　 : 端末通過情報テーブルを更新する
'
' 引数　　 : (In)    dtmClsDate         受診日
' 　　　　   (In)    dtmClsDate         管理番号
' 　　　　   (In)    intDayID           当日ＩＤ
' 　　　　   (In)    strIPADDRESS       IPアドレス
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function UpdatePassedInfo(ByVal dtmClsDate As Date, _
                                 ByVal intCntlNo As Integer, _
                                 ByVal intDayID As Integer, _
                                 ByVal strIpAddress As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    UpdatePassedInfo = INSERT_ERROR
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmClsDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", intCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", intDayID, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", Trim(strIpAddress), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす端末管理テーブルのレコードを取得
    strStmt = "SELECT CSLDATE FROM PASSEDINFO " & _
              " WHERE CSLDATE   = :CSLDATE " & _
              "   AND CNTLNO    = :CNTLNO " & _
              "   AND DAYID     = :DAYID " & _
              "   AND IPADDRESS = :IPADDRESS"
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    If Not objOraDyna.EOF Then
        
        '更新モード
        strStmt = "UPDATE PASSEDINFO " & _
                  "   SET UPDDATE = SYSDATE" & _
                  " WHERE CSLDATE   = :CSLDATE " & _
                  "   AND CNTLNO    = :CNTLNO " & _
                  "   AND DAYID     = :DAYID " & _
                  "   AND IPADDRESS = :IPADDRESS"
        
        Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
        If Ret > 0 Then
            Ret = INSERT_NORMAL
        End If
            
    Else
        
        '新規作成モード
        
        '受付済みか確認
        strStmt = "SELECT CSLDATE FROM RECEIPT " & _
                  " WHERE CSLDATE   = :CSLDATE " & _
                  "   AND CNTLNO    = :CNTLNO " & _
                  "   AND DAYID     = :DAYID "
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
        If objOraDyna.EOF Then
            '存在しないならエラー
            Ret = INSERT_NOPARENT
        Else
            '存在するなら受付
            mobjOraDb.ExecuteSQL "INSERT INTO PASSEDINFO (CSLDATE, CNTLNO, DAYID, IPADDRESS) VALUES (:CSLDATE, :CNTLNO, :DAYID, :IPADDRESS)"
            Ret = INSERT_NORMAL
        End If
        
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    UpdatePassedInfo = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    UpdatePassedInfo = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "WorkStation.UpdatePassedInfo"
    
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
' 機能　　 : 端末管理テーブルレコードを削除する
'
' 引数　　 : (In)    strIPADDRESS    IPアドレス
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteWorkStation(ByVal strIpAddress As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "IPADDRESS", Trim(strIpAddress), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '端末管理テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE WORKSTATION WHERE IPADDRESS = :IPADDRESS"
    
    'バインド変数の削除
    objOraParam.Remove "IPADDRESS"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteWorkStation = True

    Exit Function
    
ErrorHandle:

    DeleteWorkStation = False

    'イベントログ書き込み
    WriteErrorLog "WorkStation.DeleteWorkStation"
    
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
' 機能　　 : 端末通過情報テーブルレコードを削除する
'
' 引数　　 : (In)    dtmClsDate         受診日
' 　　　　   (In)    dtmClsDate         管理番号
' 　　　　   (In)    intDayID           当日ＩＤ
' 　　　　   (In)    strIPADDRESS       IPアドレス
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeletePassedInfo(ByVal dtmClsDate As Date, _
                                 ByVal intCntlNo As Integer, _
                                 ByVal intDayID As Integer, _
                                 ByVal strIpAddress As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmClsDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", intCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", intDayID, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", Trim(strIpAddress), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '端末通過情報テーブルレコードの削除
    strStmt = "DELETE PASSEDINFO " & _
              " WHERE CSLDATE   = :CSLDATE " & _
              "   AND CNTLNO    = :CNTLNO " & _
              "   AND DAYID     = :DAYID " & _
              "   AND IPADDRESS = :IPADDRESS"
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeletePassedInfo = True

    Exit Function
    
ErrorHandle:

    DeletePassedInfo = False

    'イベントログ書き込み
    WriteErrorLog "WorkStation.DeletePassedInfo"
    
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

End Sub
