VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "SecondBill"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession      As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase      'OraDatabaseオブジェクト

Private Const PREFIX_PERID  As String = "ID:"       '検索時の個人ＩＤ指定

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'
' 機能　　 : 半角数字チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckNumeric(ByVal strItemName As String, _
                             ByVal strExpression As String, _
                             ByVal lngLength As Long, _
                             Optional lngNecessary As Long) As String

    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If Len(Trim(strExpression)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
            Exit Do
        End If
        
        '半角数字チェック
        For i = 1 To Len(Trim(strExpression))
        
            '半角数字以外の文字が現れたらチェックを中止する
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Asc("0") To Asc("9")
                Case Else
                    If i = 1 And Asc(Mid(Trim(strExpression), i, 1)) = Asc("-") Then
                    Else
                        strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
                        Exit Do
                    End If
            End Select
            
        Next i
        
        Exit Do
    Loop
    
    CheckNumeric = strMessage
    
End Function

'
' 機能　　 : ２次請求明細を取得する。
'
' 引数　　 : (Out)    vntSecondLineDivCd     ２次請求明細コード
' 　　　　   (Out)    vntSecondLineDivName   ２次請求明細名
' 　　　　   (Out)    vntStdPrice            標準単価
' 　　　　   (Out)    vntStdTax              標準税額
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'

Public Function SelectSecondLineDiv( _
    Optional ByRef vntSecondLineDivCd As Variant, _
    Optional ByRef vntSecondLineDivName As Variant, _
    Optional ByRef vntstdPrice As Variant, _
    Optional ByRef vntstdTax As Variant _
) As Long

    Dim objOraParam               As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                As OraDynaset       'ダイナセット
    Dim strStmt                   As String           'SQLステートメント
    Dim lngCount                  As Long

    Dim objFields                 As OraFields        'フィールドオブジェクト
    Dim objSecondLineDivCd        As Object           '２次請求明細コード
    Dim objSecondLineDivName      As Object           '２次請求明細名
    Dim objstdPrice               As Object           '標準単価
    Dim objstdTax                 As Object           '標準税額

    Dim vntArrSecondLineDivCd()   As Variant     '２次請求明細コード
    Dim vntArrSecondLineDivName() As Variant     '２次請求明細名
    Dim vntArrStdPrice()          As Variant     '標準単価
    Dim vntArrStdTax()            As Variant     '標準税額

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectSecondLineDiv = -1

    '初期処理
    If Not IsMissing(vntSecondLineDivCd) Then vntSecondLineDivCd = Empty
    If Not IsMissing(vntSecondLineDivName) Then vntSecondLineDivName = Empty
    If Not IsMissing(vntstdPrice) Then vntstdPrice = Empty
    If Not IsMissing(vntstdTax) Then vntstdTax = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    '検索条件を満たす個人入金情報テーブルのレコードを取得
    strStmt = "SELECT SECONDLINEDIV.SECONDLINEDIVCD,   SECONDLINEDIV.SECONDLINEDIVNAME,  " & vbLf & _
              "       SECONDLINEDIV.STDPRICE,         SECONDLINEDIV.STDTAX             " & vbLf & _
              "  FROM SECONDLINEDIV                                                   " & vbLf & _
              " ORDER BY SECONDLINEDIV.SECONDLINEDIVCD                                 "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSecondLineDivCd = objFields("SECONDLINEDIVCD")
        Set objSecondLineDivName = objFields("SECONDLINEDIVNAME")
        Set objstdPrice = objFields("STDPRICE")
        Set objstdTax = objFields("STDTAX")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrSecondLineDivCd(lngCount)
            ReDim Preserve vntArrSecondLineDivName(lngCount)
            ReDim Preserve vntArrStdPrice(lngCount)
            ReDim Preserve vntArrStdTax(lngCount)

            vntArrSecondLineDivCd(lngCount) = objSecondLineDivCd.Value & ""
            vntArrSecondLineDivName(lngCount) = objSecondLineDivName.Value & ""
            vntArrStdPrice(lngCount) = objstdPrice.Value & ""
            vntArrStdTax(lngCount) = objstdTax.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        If Not IsMissing(vntSecondLineDivCd) Then vntSecondLineDivCd = vntArrSecondLineDivCd
        If Not IsMissing(vntSecondLineDivName) Then vntSecondLineDivName = vntArrSecondLineDivName
        If Not IsMissing(vntstdPrice) Then vntstdPrice = vntArrStdPrice
        If Not IsMissing(vntstdTax) Then vntstdTax = vntArrStdTax

        SelectSecondLineDiv = lngCount

    Else
        SelectSecondLineDiv = 0 '件数なし
        
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
    WriteErrorLog "Contract.SelectSecondLineDiv"
    
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
' 機能　　 : ２次請求明細情報を取得する
'
' 引数　　 : (In)     strSecondLineDivCd    ２次請求明細コード
' 　　　　 : (Out)    vntSecondLineDivName  ２次請求明細名称（省略可）
' 　　　　 : (Out)    vntstdPrice           標準単価（省略可）
' 　　　　 : (Out)    vntstdTax             標準税額（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 :
'
Public Function SelectSecondLineDivFromCode(ByVal strSecondLineDivCd As String, _
                                           Optional ByRef vntSecondLineDivName As Variant, _
                                           Optional ByRef vntstdPrice As Variant, _
                                           Optional ByRef vntstdTax As Variant) As Boolean


    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objSecondLineDivName    As OraField         '２次請求明細名称
    Dim objstdPrice             As OraField         '標準単価
    Dim objstdTax               As OraField         '標準税額

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SecondLineDivCD", Trim(strSecondLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす２次請求明細テーブルのレコードを取得
    strStmt = "SELECT SECONDLINEDIVNAME, STDPRICE, STDTAX" & vbLf & _
              "  FROM SECONDLINEDIV " & vbLf & _
              " WHERE SECONDLINEDIVCD = :SECONDLINEDIVCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSecondLineDivName = objFields("SECONDLineDivName")
        Set objstdPrice = objFields("stdPrice")
        Set objstdTax = objFields("stdTax")

        If IsMissing(vntSecondLineDivName) = False Then vntSecondLineDivName = objSecondLineDivName.Value & ""
        If IsMissing(vntSecondLineDivName) = False Then vntSecondLineDivName = objSecondLineDivName.Value & ""
        If IsMissing(vntstdPrice) = False Then vntstdPrice = objstdPrice.Value & ""
        If IsMissing(vntstdTax) = False Then vntstdTax = objstdTax.Value & ""
        
        SelectSecondLineDivFromCode = True
    
    Else
        
        If Not IsMissing(vntSecondLineDivName) Then vntSecondLineDivName = ""
    
    End If

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
    WriteErrorLog "PerBill.SelectSecondLineDivFromCode"
    
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
' 機能　　 : ２次請求明細テーブルレコードを削除する
'
' 引数　　 : (In)   strSecondLineDivCd    ２次請求明細コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteSecondLineDiv(ByVal strSecondLineDivCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SecondLineDivCD", Trim(strSecondLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '２次請求明細テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE SECONDLINEDIV WHERE SECONDLINEDIVCD = :SECONDLINEDIVCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteSecondLineDiv = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteSecondLineDiv = False

    'イベントログ書き込み
    WriteErrorLog "PerBill.DeleteSecondLineDiv"
    
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
' 機能　　 : ２次請求明細テーブルレコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strSecondLineDivCd     ２次請求明細コード
' 　　　　 : (In)    vntSecondLineDivName   ２次請求明細名称
' 　　　　 : (In)    strStdPrice            標準単価
' 　　　　 : (In)    vntStdTax              標準税額
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistSecondLineDiv(ByVal strMode As String, _
                                   ByVal strSecondLineDivCd As String, _
                                   ByVal strSecondLineDivName As String, _
                                   ByVal strStdPrice As String, _
                                   ByVal strStdTax As String) As Long


    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SecondLineDivCD", Trim(strSecondLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SecondLineDivNAME", Trim(strSecondLineDivName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "StdPrice", Trim(strStdPrice), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "StdTax", Trim(strStdTax), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '２次請求明細テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE SECONDLINEDIV " & _
                      "   SET SECONDLINEDIVNAME = :SECONDLINEDIVNAME, " & _
                      "       STDPRICE       　= :STDPRICE, " & _
                      "       STDTAX           = :STDTAX " & _
                      " WHERE SECONDLINEDIVCD   = :SECONDLINEDIVCD"
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす２次請求明細テーブルのレコードを取得
        strStmt = "SELECT SECONDLINEDIVCD FROM SECONDLINEDIV WHERE SECONDLINEDIVCD = :SECONDLINEDIVCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = "INSERT INTO SECONDLINEDIV ( SECONDLINEDIVCD,  SECONDLINEDIVNAME,  STDPRICE,  STDTAX)" & _
                  "                  VALUES (:SECONDLINEDIVCD, :SECONDLINEDIVNAME, :STDPRICE, :STDTAX)"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistSecondLineDiv = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistSecondLineDiv = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "PerBill.RegistSecondLineDiv"
    
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
'
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
