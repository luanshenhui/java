VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "PerBill"
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
' 機能　　 : 入金Ｓｅｑを取得する
'
' 引数　　 : (In)     strPaymentDate   入金日
'
' 戻り値　 : 正値   ＳｅｑＮｏ
' 　　　　   負値   異常終了
'
' 備考　　 :
'

Private Function GetPerPaymentSeq(ByRef strPaymentDate As Date) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim lngPaymentSeq           As Long             '入金Ｎｏ
    Dim lngCurrentMaxSeq        As Long             '現個人ＩＤの最大値
    
    Dim blnSuccess              As Boolean          '処理成功フラグ
    Dim i                       As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'    strStmt = "SELECT SYSDATE TODAY_DATE FROM DUAL"
'    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    '入金日取得
'    strPaymentDate = objOraDyna.Fields("TODAY_DATE").Value
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SRCPAYDATE", Format(Trim(strPaymentDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    
    lngPaymentSeq = -1
    
    Do
        
        strStmt = "SELECT /*+ INDEX_DESC(PERPAYMENT PERPAYMENT_PKEY) */ PAYMENTSEQ," & vbLf & _
                  "       GETTODAY.TODAY_DATE                                      " & vbLf & _
                  "  FROM PERPAYMENT,                                              " & vbLf & _
                  "       (SELECT SYSDATE TODAY_DATE FROM DUAL) GETTODAY           " & vbLf & _
                  " WHERE ROWNUM = 1                                               " & vbLf & _
                  "   AND PAYMENTDATE = :SRCPAYDATE                                " & vbLf & _
                  "   FOR UPDATE NOWAIT                                            "
        
        
        '現SEQの最大値を取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '現入金Ｓｅｑの最大値を取得する
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
            If blnSuccess Then
                Exit For
            End If
            
            'ちょっとだけ待つ
            Sleep 1000
            
        Next i

        '10回リトライしてもだめな場合は終了(発生しないとは思うが)
        If Not blnSuccess Then
            mobjOraDb.LastServerErrReset
            Err.Raise 1000, , "現在他業務にて入金情報を使用中のため、入金Ｎｏ発番処理は行えませんでした。"
        End If
        
        
        'レコードが存在しない場合は初期値を発番
        If objOraDyna.EOF Then
            lngPaymentSeq = 1
            Exit Do
        End If
        
        '先頭レコードのＳｅｑ（すなわち現在の最大値）を取得
        lngCurrentMaxSeq = objOraDyna.Fields("PAYMENTSEQ").Value
        
        
        'インクリメントしつつ新Ｓｅｑを求める
        lngPaymentSeq = lngCurrentMaxSeq + 1
        
        Exit Do
    Loop
    
    '戻り値の設定
    GetPerPaymentSeq = lngPaymentSeq
    
    Exit Function
    
ErrorHandle:

    'リソースビジーの場合は成功フラグをリセットして復帰
    If mobjOraDb.LastServerErr = 54 Then
        blnSuccess = False
        Resume Next
    End If

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.GetPerPaymentSeq"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 請求明細行Noを取得する
'
' 引数　　 : (In)     strDmdDate   請求日
' 　　　　 : (In)     lngBillSeq   請求書Ｓｅｑ
' 　　　　 : (In)     lngBranchNo  請求書枝番
'
' 戻り値　 : 正値   行Ｎｏ
' 　　　　   負値   異常終了
'
' 備考　　 :
'


Private Function GetBillLineNo(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As Long, _
                                ByVal lngBranchNo As Long _
                            ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim lngBillLineNo           As Long             '請求明細行Ｎｏ
    Dim lngCurrentMaxSeq        As Long             '現請求明細行Ｎｏの最大値
    
    Dim blnSuccess              As Boolean          '処理成功フラグ
    Dim i                       As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    lngBillLineNo = -1
    
    Do
        
        strStmt = "SELECT /*+ INDEX_DESC(PERBILL_C PERBILL_C_PKEY) */ BILLLINENO   " & vbLf & _
                  "  FROM PERBILL_C                                                " & vbLf & _
                  " WHERE ROWNUM = 1                                               " & vbLf & _
                  "   AND DMDDATE = :DMDDATE                                       " & vbLf & _
                  "   AND BILLSEQ = :BILLSEQ                                       " & vbLf & _
                  "   AND BRANCHNO = :BRANCHNO                                     " & vbLf & _
                  "   FOR UPDATE NOWAIT                                            "
        
        
        '現SEQの最大値を取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '現入金Ｓｅｑの最大値を取得する
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
            If blnSuccess Then
                Exit For
            End If
            
            'ちょっとだけ待つ
            Sleep 1000
            
        Next i

        '10回リトライしてもだめな場合は終了(発生しないとは思うが)
        If Not blnSuccess Then
            mobjOraDb.LastServerErrReset
            Err.Raise 1000, , "現在他業務にて請求書情報を使用中のため、明細行Ｎｏ発番処理は行えませんでした。"
        End If
        
        
        'レコードが存在しない場合は初期値を発番
        If objOraDyna.EOF Then
            lngBillLineNo = 1
            Exit Do
        End If
        
        '先頭レコードのＳｅｑ（すなわち現在の最大値）を取得
        lngCurrentMaxSeq = objOraDyna.Fields("BILLLINENO").Value
        
        
        'インクリメントしつつ新Ｓｅｑを求める
        lngBillLineNo = lngCurrentMaxSeq + 1
        
        Exit Do
    Loop
    
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    GetBillLineNo = lngBillLineNo
    
    Exit Function
    
ErrorHandle:

    'リソースビジーの場合は成功フラグをリセットして復帰
    If mobjOraDb.LastServerErr = 54 Then
        blnSuccess = False
        Resume Next
    End If

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.GetBillLineNo"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'##### person.dllよりコピーしました。　聖路加対応

'## 2002.12.02 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 団体条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_OrgCd(ByRef vntCondition As Variant, ByVal strOrgCd1 As String, ByVal strOrgCd2 As String)

'## 2003.02.13 Add 1Line By T.Takagi@FSIT バインド変数化
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
'## 2003.02.13 Add End

    Dim objCommon   As Common   '共通クラス
    Dim strStmt     As String   'SQLステートメント
    Dim strPerId    As String   '個人ＩＤ

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

'## 2003.02.13 Add 4Lines By T.Takagi@FSIT バインド変数化
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.02.13 Add End

    '団体コード１条件を追加
    If strOrgCd1 <> "" Then
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'        strStmt = "PERSON.ORGCD1 = '" & strOrgCd1 & "'"
        strStmt = "PERSON.ORGCD1 = :ORGCD1"
'## 2003.02.13 Mod End
    End If
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
    '団体コード２条件を追加
    If strOrgCd2 <> "" Then
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'        strStmt = "PERSON.ORGCD2 = '" & strOrgCd2 & "'"
        strStmt = "PERSON.ORGCD2 = :ORGCD2"
'## 2003.02.13 Mod End
    End If
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'##### person.dllよりコピーしました。　聖路加対応

'## 2002.12.02 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 全角文字条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 : 前方一致検索のみ対応
'
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'Public Sub AppendCondition_Wide(ByRef vntCondition As Variant, ByVal strBuffer As String)
Private Sub AppendCondition_Wide(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)
'## 2003.02.13 Mod End

'## 2003.02.13 Add 3Lines By T.Takagi@FSIT バインド変数化
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名
    Dim strParamName2   As String           'パラメータ名
'## 2003.02.13 Add End

    Dim objCommon   As Common   '共通クラス
    Dim strStmt     As String   'SQLステートメント
    Dim strNarrow   As String   '半角変換後の文字列
    Dim blnWideChar As Boolean  'カナ漢字チェック用変数
    Dim strBuffer2  As String   '文字列バッファ
    Dim i           As Long     'インデックス
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

'## 2003.02.13 Add 1Line By T.Takagi@FSIT バインド変数化
    Set objOraParam = mobjOraDb.Parameters
'## 2003.02.13 Add End

    '全角文字列が存在するかをチェック(カナは半角変換でき、漢字・ひらがなは半角変換できない性質を利用)
    strNarrow = StrConv(strBuffer, vbNarrow)
    blnWideChar = False
    For i = 1 To Len(strNarrow)
        If Asc(Mid(strNarrow, i, 1)) < 0 Then
            blnWideChar = True
            Exit For
        End If
    Next i
        
'## 2003.02.13 Add 3Lines By T.Takagi@FSIT バインド変数化
    'パラメータ追加
    strParamName = "NAME" & CStr(lngParamNo)
    objOraParam.Add strParamName, strBuffer & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.02.13 Add End
        
    Do
        'カナ以外の全角文字が含まれる場合
        If blnWideChar = True Then
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'            strStmt = "( PERSON.LASTNAME LIKE '" & strBuffer & "%' OR PERSON.FIRSTNAME LIKE '" & strBuffer & "%' ) "
            strStmt = "( PERSON.LASTNAME LIKE :" & strParamName & " OR PERSON.FIRSTNAME LIKE :" & strParamName & " ) "
'## 2003.02.13 Mod End
            Exit Do
        End If
                
        'カナ名しか存在しない場合、以下の処理にて文字列置換を行う
        strBuffer2 = strBuffer
        strBuffer2 = Replace(strBuffer2, "ァ", "ア")
        strBuffer2 = Replace(strBuffer2, "ィ", "イ")
        strBuffer2 = Replace(strBuffer2, "ゥ", "ウ")
        strBuffer2 = Replace(strBuffer2, "ェ", "エ")
        strBuffer2 = Replace(strBuffer2, "ォ", "オ")
        strBuffer2 = Replace(strBuffer2, "ッ", "ツ")
        strBuffer2 = Replace(strBuffer2, "ャ", "ヤ")
        strBuffer2 = Replace(strBuffer2, "ュ", "ユ")
        strBuffer2 = Replace(strBuffer2, "ョ", "ヨ")

        '置換前後で文字列値が異なる場合、双方の値で検索を行う
        If strBuffer2 <> strBuffer Then
'## 2003.02.13 Mod 6Lines By T.Takagi@FSIT バインド変数化
'            strStmt = "( PERSON.LASTKNAME LIKE '" & strBuffer & "%' OR PERSON.FIRSTKNAME LIKE '" & strBuffer & "%' OR PERSON.LASTKNAME LIKE '" & strBuffer2 & "%' OR PERSON.FIRSTKNAME LIKE '" & strBuffer2 & "%' )"
            'パラメータ追加
            strParamName2 = "CNVNAME" & CStr(lngParamNo)
            objOraParam.Add strParamName2, strBuffer2 & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2

            strStmt = "( PERSON.LASTKNAME LIKE :" & strParamName & " OR PERSON.FIRSTKNAME LIKE :" & strParamName & " OR PERSON.LASTKNAME LIKE :" & strParamName2 & " OR PERSON.FIRSTKNAME LIKE :" & strParamName2 & " )"
'## 2003.02.13 Mod End
            Exit Do
        End If

        '置換前後で文字列値が同一ならば通常の検索を行う
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'        strStmt = "( PERSON.LASTKNAME LIKE '" & strBuffer & "%' OR PERSON.FIRSTKNAME LIKE '" & strBuffer & "%' ) "
        strStmt = "( PERSON.LASTKNAME LIKE :" & strParamName & " OR PERSON.FIRSTKNAME LIKE :" & strParamName & " ) "
'## 2003.02.13 Mod End

        Exit Do
    Loop
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'##### person.dllよりコピーしました。　聖路加対応

'## 2002.12.02 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 個人ＩＤ条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'Public Sub AppendCondition_PerId(ByRef vntCondition As Variant, ByVal strBuffer As String)
Private Sub AppendCondition_PerId(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)
'## 2003.02.13 Mod End

    Dim objCommon   As Common   '共通クラス
    Dim strStmt     As String   'SQLステートメント
    Dim strPerId    As String   '個人ＩＤ

'## 2003.02.13 Add 2Lines By T.Takagi@FSIT バインド変数化
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名
'## 2003.02.13 Add End

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_PERID))) = PREFIX_PERID Then
        strPerId = Right(strBuffer, Len(strBuffer) - Len(PREFIX_PERID))
    Else
        strPerId = strBuffer
    End If

'## 2003.02.13 Add 4Lines By T.Takagi@FSIT バインド変数化
    'パラメータ追加
    strParamName = "PERID" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, "", ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.02.13 Add End

    '文字列の末尾が"*"なら部分検索
    If Right(strPerId, 1) = "*" Then
    
'## 2003.02.13 Mod 3Lines By T.Takagi@FSIT バインド変数化
'        strStmt = "PERSON.PERID LIKE '" & Left(strPerId, Len(strPerId) - 1) & "%'"
        objOraParam(strParamName).Value = Trim(Left(strPerId, Len(strPerId) - 1)) & "%"
        strStmt = "PERSON.PERID LIKE :" & strParamName
'## 2003.02.13 Mod End

    'さもなければ直接指定
    Else
    
'## 2003.02.13 Mod 3Lines By T.Takagi@FSIT バインド変数化
'        strStmt = "PERSON.PERID = '" & strPerId & "'"
        objOraParam(strParamName).Value = Trim(strPerId)
        strStmt = "PERSON.PERID = :" & strParamName
'## 2003.02.13 Mod End
    
    End If

    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'##### person.dllよりコピーして請求書検索用に修正しました。　聖路加対応

'## 2002.12.02 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 個人テーブル検索用条件節作成
'
' 引数　　 : (In/Out) vntKey            検索キーの集合
' 　　　　   (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     blnDelFlgUseOnly  True指定時は削除フラグが"0"(使用中)のレコードのみ検索
' 　　　　   (In)     blnSelectNoOrg    True指定時は団体未設定のレコードも検索
'
' 戻り値　 : 個人テーブル検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Private Function CreateConditionForPersonList( _
    ByVal vntKey As Variant, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal blnDelFlgUseOnly As Boolean, _
    ByVal blnSelectNoOrg As Boolean _
) As String

    Dim objCommon       As Common   '共通クラス
    Dim objPerson       As Object   'Personクラス
    Dim vntCondition    As Variant  '条件節の集合
    Dim strBuffer       As String   '文字列バッファ
    Dim i               As Long     'インデックス
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    'Personクラスのインスタンス作成
    Set objPerson = CreateObject("HainsPerson.Person")
    
    '団体コード指定時
    If strOrgCd1 <> "" Or strOrgCd2 <> "" Then
    
        '団体コード条件を追加
        Call AppendCondition_OrgCd(vntCondition, strOrgCd1, strOrgCd2)
    
    '団体コード未指定時
    Else
    
        '団体未設定のレコードを検索しない場合は条件を追加
        If Not blnSelectNoOrg Then
            objCommon.AppendArray vntCondition, "PERSON.ORGCD1 IS NOT NULL AND PERSON.ORGCD2 IS NOT NULL"
        End If
        
    End If
    
    '使用中レコードのみ検索する場合は条件を追加
    If blnDelFlgUseOnly Then
        objCommon.AppendArray vntCondition, "PERSON.DELFLG = " & DELFLG_USED
    End If
    
    '引数指定時
    If Not IsEmpty(vntKey) Then

        '検索キー数分の条件節を追加
        For i = 0 To UBound(vntKey)
    
'## 2003.02.13 Mod 3Lines By T.Takagi@FSIT バインド変数化
'            'アプストロフィはOracleの単一引用符と重複するので予め置換
'            strBuffer = Replace(vntKey(i), "'", "''")
            strBuffer = vntKey(i)
'## 2003.02.13 Mod End
    
            '検索キーのタイプを判別し、条件節に変換して追加
            Select Case True
            
                Case objPerson.IsWide(strBuffer)      '全角文字が含まれる(半角カナもここに含まれる)
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'                    Call AppendCondition_Wide(vntCondition, strBuffer)
                    Call AppendCondition_Wide(vntCondition, strBuffer, i)
'## 2003.02.13 Mod End
            
'                Case IsGender(strBuffer)    '性別
''## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
''                    Call AppendCondition_Gender(vntCondition, strBuffer)
'                    Call AppendCondition_Gender(vntCondition, strBuffer, i)
''## 2003.02.13 Mod End
    
                Case objPerson.IsPerId(strBuffer)     '個人ID
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'                    Call AppendCondition_PerId(vntCondition, strBuffer)
                    Call AppendCondition_PerId(vntCondition, strBuffer, i)
'## 2003.02.13 Mod End
    
'                Case IsInsured(strBuffer)   '被保険者
''## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
''                    Call AppendCondition_Insured(vntCondition, strBuffer)
'                    Call AppendCondition_Insured(vntCondition, strBuffer, i)
''## 2003.02.13 Mod End
    
'                Case IsBirth(strBuffer)     '生年月日
''## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
''                    Call AppendCondition_Birth(vntCondition, strBuffer)
'                    Call AppendCondition_Birth(vntCondition, strBuffer, i)
''## 2003.02.13 Mod End
    
                Case Else                   '上記以外は個人IDとして検索
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'                    Call AppendCondition_PerId(vntCondition, strBuffer)
                    Call AppendCondition_PerId(vntCondition, strBuffer, i)
'## 2003.02.13 Mod End
                
            End Select
            
        Next i
    
    End If
    
    'すべての条件節をANDで連結
    If Not IsEmpty(vntCondition) Then
        CreateConditionForPersonList = "WHERE " & Join(vntCondition, " AND ")
    End If
    
End Function

'
' 機能　　 : 請求日または請求書Ｎｏをキーに個人請求書一覧を検索するＳＱＬを作成する
'
' 引数　　 : (In)     objOraParam         OraParametersオブジェクト
' 　　　　   (Out)    strstmt             SQLステートメント
' 　　　　   (In)     vntPaymenflg        1:未収のみ 0:全て
' 　　　　   (In)     vntDelDisp          1:取消伝票除く 0:全て
' 　　　　   (In)     vntStartDmdDate     検索条件請求日（開始）
' 　　　　   (In)     vntEndDmdDate       検索条件請求日（終了）
' 　　　　   (In)     vntSearchDmdDate    検索条件請求日
' 　　　　   (In)     vntSearchBillSeq    検索条件請求書Ｓｅｑ
' 　　　　   (In)     vntSearchBranchNo   検索条件請求書枝番
'
' 戻り値　 : True    正常終了
' 　　　　   False   異常終了
'
' 備考　　 :
'

Private Function SetPerBillViewSql( _
    ByRef objOraParam As OraParameters, _
    ByRef strStmt As String, _
    ByVal vntPaymentflg As Variant, ByVal vntDelDisp As Variant, _
    ByVal vntStartDmdDate As Variant, ByVal vntEndDmdDate As Variant, _
    ByVal vntSearchDmdDate As Variant, ByVal vntSearchBillSeq As Variant, _
    ByVal vntSearchBranchNo As Variant _
) As Boolean


    strStmt = "FROM                                                 " & vbLf & _
              "(SELECT LASTVIEW.DMDDATE,                            " & vbLf & _
              "        LASTVIEW.BILLSEQ,                            " & vbLf & _
              "        LASTVIEW.BRANCHNO,                           " & vbLf & _
              "        LASTVIEW.RSVNO,                              " & vbLf & _
              "        LASTVIEW.CSCD,                               " & vbLf & _
              "        NVL(CTRPT.CSNAME, COURSE_P.CSNAME) CSNAME,   " & vbLf & _
              "        COURSE_P.WEBCOLOR,                           " & vbLf & _
              "        LASTVIEW.PERID,                              " & vbLf & _
              "        PERSON.LASTNAME,                             " & vbLf & _
              "        PERSON.FIRSTNAME,                            " & vbLf & _
              "        PERSON.LASTKNAME,                            " & vbLf & _
              "        PERSON.FIRSTKNAME,                           " & vbLf & _
              "        GetCslAge(PERSON.BIRTH) AGE,                 " & vbLf & _
              "        PERSON.GENDER,                               " & vbLf & _
              "        LASTVIEW.PERCOUNT,                           " & vbLf & _
              "        ORG.ORGSNAME,                                " & vbLf & _
              "        ORG.ORGKNAME,                                " & vbLf & _
              "        LASTVIEW.PRICE,                              " & vbLf & _
              "        LASTVIEW.TAX,                                " & vbLf & _
              "        ( LASTVIEW.PRICE + LASTVIEW.TAX ) TOTALPRICE," & vbLf & _
              "        LASTVIEW.PAYMENTDATE,                        " & vbLf & _
              "        LASTVIEW.PAYMENTSEQ,                         " & vbLf & _
              "        LASTVIEW.DELFLG                              "

              
    strStmt = strStmt & vbLf & _
              "   FROM CTRPT, COURSE_P, ORG, PERSON,                          " & vbLf & _
              "        (                                                      " & vbLf & _
              "        SELECT DMDDATE,                                        " & vbLf & _
              "               BILLSEQ,                                        " & vbLf & _
              "               BRANCHNO,                                       " & vbLf & _
              "               DELFLG,                                         " & vbLf & _
              "               PAYMENTDATE,                                    " & vbLf & _
              "               PAYMENTSEQ,                                     " & vbLf & _
              "               NVL(BASEPERBILL.PERID, CONSULT.PERID) PERID,    " & vbLf & _
              "               BASEPERBILL.RSVNO,                              " & vbLf & _
              "               CONSULT.ORGCD1,                                 " & vbLf & _
              "               CONSULT.ORGCD2,                                 " & vbLf & _
              "               CONSULT.CSCD,                                   " & vbLf & _
              "               CONSULT.CTRPTCD,                                " & vbLf & _
              "               PRICE,                                          " & vbLf & _
              "               TAX,                                            " & vbLf & _
              "               DECODE(CSLCOUNT, 0, PERCOUNT, CSLCOUNT) PERCOUNT"

              
    strStmt = strStmt & vbLf & _
              "          FROM CONSULT,                                                                   " & vbLf & _
              "               (                                                                          " & vbLf & _
              "               SELECT PERBILL.DMDDATE,     PERBILL.BILLSEQ,                               " & vbLf & _
              "                      PERBILL.BRANCHNO,    PERBILL.DELFLG,                                " & vbLf & _
              "                      PERBILL.PAYMENTDATE, PERBILL.PAYMENTSEQ,                            " & vbLf & _
              "                      ( SELECT RSVNO FROM PERBILL_CSL                                     " & vbLf & _
              "                         WHERE DMDDATE = PERBILL.DMDDATE   AND BILLSEQ = PERBILL.BILLSEQ  " & vbLf & _
              "                           AND BRANCHNO = PERBILL.BRANCHNO AND ROWNUM = 1) RSVNO,         " & vbLf & _
              "                      ( SELECT PERID FROM PERBILL_PERSON                                  " & vbLf & _
              "                         WHERE DMDDATE = PERBILL.DMDDATE   AND BILLSEQ = PERBILL.BILLSEQ  " & vbLf & _
              "                           AND BRANCHNO = PERBILL.BRANCHNO AND ROWNUM = 1) PERID,         " & vbLf & _
              "                      ( SELECT SUM( PRICE    + EDITPRICE ) FROM PERBILL_C                 " & vbLf & _
              "                         WHERE DMDDATE = PERBILL.DMDDATE    AND BILLSEQ = PERBILL.BILLSEQ " & vbLf & _
              "                           AND BRANCHNO = PERBILL.BRANCHNO) PRICE,                        " & vbLf & _
              "                      ( SELECT SUM( TAXPRICE + EDITTAX )   FROM PERBILL_C                 " & vbLf & _
              "                         WHERE DMDDATE = PERBILL.DMDDATE AND BILLSEQ = PERBILL.BILLSEQ    " & vbLf & _
              "                           AND BRANCHNO = PERBILL.BRANCHNO) TAX,                          " & vbLf & _
              "                      ( SELECT COUNT(DISTINCT RSVNO) FROM PERBILL_CSL                     " & vbLf & _
              "                         WHERE DMDDATE = PERBILL.DMDDATE AND BILLSEQ = PERBILL.BILLSEQ    " & vbLf & _
              "                           AND BRANCHNO = PERBILL.BRANCHNO) CSLCOUNT,                     " & vbLf & _
              "                      ( SELECT COUNT(DISTINCT PERID) FROM PERBILL_PERSON                  " & vbLf & _
              "                         WHERE DMDDATE = PERBILL.DMDDATE AND BILLSEQ = PERBILL.BILLSEQ    " & vbLf & _
              "                           AND BRANCHNO = PERBILL.BRANCHNO) PERCOUNT                      " & vbLf & _
              "                 FROM PERBILL                                                             "

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

              
    '請求書Ｎｏ指定
    If vntSearchDmdDate <> "" And vntSearchBillSeq <> "" And vntSearchBranchNo <> "" Then
        objOraParam.Add "DMDDATE", Format(Trim(vntSearchDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", vntSearchBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", vntSearchBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
              "                 WHERE PERBILL.DMDDATE  = :DMDDATE " & vbLf & _
              "                   AND PERBILL.BILLSEQ  = :BILLSEQ " & vbLf & _
              "                   AND PERBILL.BRANCHNO = :BRANCHNO "
    Else
        '請求日範囲指定
        If vntStartDmdDate <> "" And vntEndDmdDate <> "" Then
            objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            objOraParam.Add "EDMDDATE", Format(Trim(vntEndDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            strStmt = strStmt & vbLf & _
                "                 WHERE PERBILL.DMDDATE BETWEEN :SDMDDATE  AND :EDMDDATE"
        Else
            '請求日開始日のみ指定
            If vntStartDmdDate <> "" And vntEndDmdDate = "" Then
                objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
                strStmt = strStmt & vbLf & _
                    "                 WHERE PERBILL.DMDDATE = :SDMDDATE  "
            End If
        End If
    End If

              
    '未収のみ
    If vntPaymentflg = 1 Then
        strStmt = strStmt & vbLf & _
              "                   AND PERBILL.PAYMENTDATE IS NULL  "
    End If

              
    '取消伝票を除く
    If vntDelDisp = 1 Then
        strStmt = strStmt & vbLf & _
              "                   AND PERBILL.DELFLG = 0  "
    End If
        
    
    strStmt = strStmt & vbLf & _
              "               ) BASEPERBILL                       " & vbLf & _
              "        WHERE BASEPERBILL.RSVNO = CONSULT.RSVNO(+) " & vbLf & _
              "       ) LASTVIEW                                  " & vbLf & _
              "WHERE LASTVIEW.PERID   = PERSON.PERID (+)          " & vbLf & _
              "  AND LASTVIEW.ORGCD1  = ORG.ORGCD1 (+)            " & vbLf & _
              "  AND LASTVIEW.ORGCD2  = ORG.ORGCD2 (+)            " & vbLf & _
              "  AND LASTVIEW.CSCD    = COURSE_P.CSCD (+)         " & vbLf & _
              "  AND LASTVIEW.CTRPTCD = CTRPT.CTRPTCD (+)         " & vbLf & _
              ")LISTVIEW"
              
    SetPerBillViewSql = True
    
    
    Exit Function
    
ErrorHandle:

    SetPerBillViewSql = False
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.SetPerBillViewSql"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人情報をキーに個人請求書一覧を検索するＳＱＬを作成する
'
' 引数　　 : (In)     objOraParam         OraParametersオブジェクト
' 　　　　   (Out)    strstmt             SQLステートメント
' 　　　　   (In)     vntPaymenflg        1:未収のみ 0:全て
' 　　　　   (In)     vntDelDisp          1:取消伝票除く 0:全て
' 　　　　   (In)     vntKey              検索キー(空白で分割後のキー）
' 　　　　   (In)     vntSearchPer        検索条件個人ＩＤ
' 　　　　   (In)     vntStartDmdDate     検索条件請求日（開始）
' 　　　　   (In)     vntEndDmdDate       検索条件請求日（終了）
'
' 戻り値　 : True    正常終了
' 　　　　   False   異常終了
'
' 備考　　 :
'


Private Function SetPersonViewSql( _
    ByRef objOraParam As OraParameters, _
    ByRef strStmt As String, _
    ByVal vntPaymentflg As Variant, ByVal vntDelDisp As Variant, _
    ByVal vntKey As Variant, ByVal vntSearchPer As Variant, _
    ByVal vntStartDmdDate As Variant, ByVal vntEndDmdDate As Variant _
) As Boolean

    Dim strstmt2            As String
    
    Dim blnDelFlgUseOnly    As Boolean
    Dim blnSelectNoOrg      As Boolean

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    strStmt = "FROM                        " & vbLf & _
              "(SELECT PERBILL.DMDDATE,    " & vbLf & _
              "        PERBILL.BILLSEQ,    " & vbLf & _
              "        PERBILL.BRANCHNO,   " & vbLf & _
              "        LASTVIEW.RSVNO,     " & vbLf & _
              "        LASTVIEW.CSCD,      " & vbLf & _
              "        LASTVIEW.CSNAME,    " & vbLf & _
              "        LASTVIEW.WEBCOLOR,  " & vbLf & _
              "        LASTVIEW.PERID,     " & vbLf & _
              "        LASTVIEW.LASTNAME,  " & vbLf & _
              "        LASTVIEW.FIRSTNAME, " & vbLf & _
              "        LASTVIEW.LASTKNAME, " & vbLf & _
              "        LASTVIEW.FIRSTKNAME," & vbLf & _
              "        LASTVIEW.AGE,       " & vbLf & _
              "        LASTVIEW.GENDER,    "
    
    strStmt = strStmt & vbLf & _
              "        (                                                          " & vbLf & _
              "        ( SELECT COUNT(DISTINCT RSVNO)                             " & vbLf & _
              "            FROM PERBILL_CSL                                       " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) +                    " & vbLf & _
              "        ( SELECT COUNT(DISTINCT PERID)                             " & vbLf & _
              "            FROM PERBILL_PERSON                                       " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO)) PERCOUNT,           "
    
    strStmt = strStmt & vbLf & _
              "        LASTVIEW.ORGSNAME,  LASTVIEW.ORGKNAME,                     " & vbLf & _
              "        ( SELECT SUM( PRICE    + EDITPRICE )                       " & vbLf & _
              "            FROM PERBILL_C                                         " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) PRICE,               " & vbLf & _
              "        ( SELECT SUM( TAXPRICE + EDITTAX )                         " & vbLf & _
              "            FROM PERBILL_C                                         " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) TAX,                 " & vbLf & _
              "        ( SELECT SUM( PRICE    + EDITPRICE + TAXPRICE + EDITTAX )  " & vbLf & _
              "            FROM PERBILL_C                                         " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) TOTALPRICE,          " & vbLf & _
              "        PERBILL.PAYMENTDATE,                                       " & vbLf & _
              "        PERBILL.PAYMENTSEQ,                                        " & vbLf & _
              "        PERBILL.DELFLG                                             "

              
    strStmt = strStmt & vbLf & _
              "   FROM PERBILL,                                                  " & vbLf & _
              "        (                                                         " & vbLf & _
              "        (                                                         " & vbLf & _
              "        SELECT CONSULT.RSVNO,                                     " & vbLf & _
              "               CONSULT.ORGCD1,                                    " & vbLf & _
              "               CONSULT.ORGCD2,                                    " & vbLf & _
              "               ORG.ORGSNAME,                                      " & vbLf & _
              "               ORG.ORGKNAME,                                      " & vbLf & _
              "               CONSULT.CSCD,                                      " & vbLf & _
              "               NVL(CTRPT.CSNAME, COURSE_P.CSNAME) CSNAME,         " & vbLf & _
              "               COURSE_P.WEBCOLOR,                                 " & vbLf & _
              "               CONSULT.PERID,                                     " & vbLf & _
              "               PERSON.LASTNAME,                                   " & vbLf & _
              "               PERSON.FIRSTNAME,                                  " & vbLf & _
              "               PERSON.LASTKNAME,                                  " & vbLf & _
              "               PERSON.FIRSTKNAME,                                 " & vbLf & _
              "               GetCslAge(PERSON.BIRTH) AGE,                       " & vbLf & _
              "               PERSON.GENDER,                                     " & vbLf & _
              "               PERBILL_CSL.DMDDATE,                               " & vbLf & _
              "               PERBILL_CSL.BILLSEQ,                               " & vbLf & _
              "               PERBILL_CSL.BRANCHNO                               " & vbLf & _
              "          FROM PERBILL_CSL, ORG, PERSON, CTRPT, COURSE_P, CONSULT "

    '請求日範囲指定
    If vntStartDmdDate <> "" And vntEndDmdDate <> "" Then
        objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "EDMDDATE", Format(Trim(vntEndDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        strStmt = strStmt & vbLf & _
                "                 WHERE CONSULT.CSLDATE BETWEEN :SDMDDATE  AND :EDMDDATE"
    Else
        '請求日開始日のみ指定
        If vntStartDmdDate <> "" And vntEndDmdDate = "" Then
            objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            strStmt = strStmt & vbLf & _
                    "                 WHERE CONSULT.CSLDATE = :SDMDDATE  "
        End If
    End If

    '検索キー 指定？
    If vntKey(0) <> "" Then
        blnDelFlgUseOnly = False
        blnSelectNoOrg = True
        
        strstmt2 = CreateConditionForPersonList(vntKey, "", "", blnDelFlgUseOnly, blnSelectNoOrg)
        strStmt = strStmt & vbLf & _
                "                AND CONSULT.PERID IN                  " & vbLf & _
                "                   (SELECT DISTINCT PERID FROM PERSON " & vbLf & _
                "          " & strstmt2 & vbLf & _
                "                    )                                 "
    
    Else
        If vntSearchPer <> "" Then
            objOraParam.Add "PERID", Trim(vntSearchPer), ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & vbLf & _
                    "             AND CONSULT.PERID = :PERID  "
        End If
    End If
    strStmt = strStmt & vbLf & _
              "          AND CONSULT.CSCD    = COURSE_P.CSCD      " & vbLf & _
              "          AND CONSULT.CTRPTCD = CTRPT.CTRPTCD      " & vbLf & _
              "          AND CONSULT.PERID   = PERSON.PERID       " & vbLf & _
              "          AND ORG.ORGCD1      = CONSULT.ORGCD1     " & vbLf & _
              "          AND ORG.ORGCD2      = CONSULT.ORGCD2     " & vbLf & _
              "          AND CONSULT.RSVNO   = PERBILL_CSL.RSVNO  " & vbLf & _
              "       ) UNION                                     " & vbLf & _
              "       (                                           "
    
    strStmt = strStmt & vbLf & _
              "       SELECT NULL,                           " & vbLf & _
              "              NULL,                           " & vbLf & _
              "              NULL,                           " & vbLf & _
              "              NULL,                           " & vbLf & _
              "              NULL,                           " & vbLf & _
              "              NULL,                           " & vbLf & _
              "              NULL,                           " & vbLf & _
              "              NULL,                           " & vbLf & _
              "              PERBILL_PERSON.PERID,           " & vbLf & _
              "              PERSON.LASTNAME,                " & vbLf & _
              "              PERSON.FIRSTNAME,               " & vbLf & _
              "              PERSON.LASTKNAME,               " & vbLf & _
              "              PERSON.FIRSTKNAME,              " & vbLf & _
              "              GetCslAge(PERSON.BIRTH) AGE,    " & vbLf & _
              "              PERSON.GENDER,                  " & vbLf & _
              "              PERBILL_PERSON.DMDDATE,         " & vbLf & _
              "              PERBILL_PERSON.BILLSEQ,         " & vbLf & _
              "              PERBILL_PERSON.BRANCHNO         " & vbLf & _
              "         FROM PERSON, PERBILL, PERBILL_PERSON "
    '検索キー 指定？
    If vntKey(0) <> "" Then
'        blnDelFlgUseOnly = False
'        blnSelectNoOrg = True
        'Personクラスのインスタンス作成
'        Set objPerson = CreateObject("HainsPerson.Person")
'        strstmt = strstmt & vbLf & _
'               "          " & objPerson.CreateConditionForPersonList(vntKey, "", "", blnDelFlgUseOnly, blnSelectNoOrg)
        strStmt = strStmt & vbLf & _
                "              WHERE PERBILL_PERSON.PERID IN                  " & vbLf & _
                "                   (SELECT DISTINCT PERID FROM PERSON " & vbLf & _
                "          " & strstmt2 & vbLf & _
                "                    )                                 "
    Else
        If vntSearchPer <> "" Then
'            objOraParam.Add "PERID", Trim(vntSearchPer), ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & vbLf & _
                    "           WHERE PERBILL_PERSON.PERID = :PERID  "
        End If
    End If
    
    strStmt = strStmt & vbLf & _
              "          AND PERBILL.DMDDATE  = PERBILL_PERSON.DMDDATE " & vbLf & _
              "          AND PERBILL.BILLSEQ  = PERBILL_PERSON.BILLSEQ " & vbLf & _
              "          AND PERBILL.BRANCHNO = PERBILL_PERSON.BRANCHNO"

    '請求日範囲指定
    If vntStartDmdDate <> "" And vntEndDmdDate <> "" Then
'        objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
'        objOraParam.Add "EDMDDATE", Format(Trim(vntEndDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        strStmt = strStmt & vbLf & _
                "        AND PERBILL.DMDDATE BETWEEN :SDMDDATE  AND :EDMDDATE"
    Else
        '請求日開始日のみ指定
        If vntStartDmdDate <> "" And vntEndDmdDate = "" Then
'            objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            strStmt = strStmt & vbLf & _
                    "    AND PERBILL.DMDDATE = :SDMDDATE  "
        End If
    End If

    strStmt = strStmt & vbLf & _
              "           AND PERSON.PERID     = PERBILL_PERSON.PERID " & vbLf & _
              "        )                                              " & vbLf & _
              "        ) LASTVIEW                                     "

    strStmt = strStmt & vbLf & _
              " WHERE LASTVIEW.DMDDATE  = PERBILL.DMDDATE " & vbLf & _
              "   AND LASTVIEW.BILLSEQ  = PERBILL.BILLSEQ " & vbLf & _
              "   AND LASTVIEW.BRANCHNO = PERBILL.BRANCHNO"

              
    
    '未収のみ
    If vntPaymentflg = 1 Then
        strStmt = strStmt & vbLf & _
              "    AND PERBILL.PAYMENTDATE IS NULL  "
    End If

              
    '取消伝票を除く
    If vntDelDisp = 1 Then
        strStmt = strStmt & vbLf & _
              "     AND PERBILL.DELFLG = 0  "
    End If
        
    
    strStmt = strStmt & vbLf & _
              ")LISTVIEW"
              
    SetPersonViewSql = True
    
    
    Exit Function
    
ErrorHandle:

    SetPersonViewSql = False
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.SetPersonViewSql"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 団体情報をキーに個人請求書一覧を検索するＳＱＬを作成する
'
' 引数　　 : (In)     objOraParam         OraParametersオブジェクト
' 　　　　   (Out)    strstmt             SQLステートメント
' 　　　　   (In)     vntPaymenflg        1:未収のみ 0:全て
' 　　　　   (In)     vntDelDisp          1:取消伝票除く 0:全て
' 　　　　   (In)     vntSearchPerId      検索条件個人ＩＤ
' 　　　　   (In)     vntSearchOrg1       検索条件団体コード１
' 　　　　   (In)     vntSearchOrg2       検索条件団体コード２
' 　　　　   (In)     vntStartDmdDate     検索条件請求日（開始）
' 　　　　   (In)     vntEndDmdDate       検索条件請求日（終了）
'
' 戻り値　 : True    正常終了
' 　　　　   False   異常終了
'
' 備考　　 :
'

Private Function SetOrgViewSql( _
    ByRef objOraParam As OraParameters, _
    ByRef strStmt As String, _
    ByVal vntPaymentflg As Variant, ByVal vntDelDisp As Variant, _
    ByVal vntSearchPerId As Variant, _
    ByVal vntSearchOrg1 As Variant, ByVal vntSearchOrg2 As Variant, _
    ByVal vntStartDmdDate As Variant, ByVal vntEndDmdDate As Variant _
) As Boolean

    Dim strstmt2            As String
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    strStmt = "FROM                        " & vbLf & _
              "(SELECT PERBILL.DMDDATE,    " & vbLf & _
              "        PERBILL.BILLSEQ,    " & vbLf & _
              "        PERBILL.BRANCHNO,   " & vbLf & _
              "        LASTVIEW.RSVNO,     " & vbLf & _
              "        LASTVIEW.CSCD,      " & vbLf & _
              "        LASTVIEW.CSNAME,    " & vbLf & _
              "        LASTVIEW.WEBCOLOR,  " & vbLf & _
              "        LASTVIEW.PERID,     " & vbLf & _
              "        LASTVIEW.LASTNAME,  " & vbLf & _
              "        LASTVIEW.FIRSTNAME, " & vbLf & _
              "        LASTVIEW.LASTKNAME, " & vbLf & _
              "        LASTVIEW.FIRSTKNAME," & vbLf & _
              "        LASTVIEW.AGE,       " & vbLf & _
              "        LASTVIEW.GENDER,    "
    
    strStmt = strStmt & vbLf & _
              "        ( SELECT COUNT(DISTINCT RSVNO)                             " & vbLf & _
              "            FROM PERBILL_CSL                                       " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) PERCOUNT,            " & vbLf & _
              "        LASTVIEW.ORGSNAME,  LASTVIEW.ORGKNAME,                     " & vbLf & _
              "        ( SELECT SUM( PRICE    + EDITPRICE )                       " & vbLf & _
              "            FROM PERBILL_C                                         " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) PRICE,               " & vbLf & _
              "        ( SELECT SUM( TAXPRICE + EDITTAX )                         " & vbLf & _
              "            FROM PERBILL_C                                         " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) TAX,                 " & vbLf & _
              "        ( SELECT SUM( PRICE    + EDITPRICE + TAXPRICE + EDITTAX )  " & vbLf & _
              "            FROM PERBILL_C                                         " & vbLf & _
              "           WHERE DMDDATE = PERBILL.DMDDATE                         " & vbLf & _
              "             AND BILLSEQ = PERBILL.BILLSEQ                         " & vbLf & _
              "             AND BRANCHNO = PERBILL.BRANCHNO) TOTALPRICE,          " & vbLf & _
              "        PERBILL.PAYMENTDATE,                                       " & vbLf & _
              "        PERBILL.PAYMENTSEQ,                                        " & vbLf & _
              "        PERBILL.DELFLG                                             "

              
    strStmt = strStmt & vbLf & _
              "   FROM PERBILL,                                                  " & vbLf & _
              "        (                                                         " & vbLf & _
              "        SELECT CONSULT.RSVNO,                                     " & vbLf & _
              "               CONSULT.ORGCD1,                                    " & vbLf & _
              "               CONSULT.ORGCD2,                                    " & vbLf & _
              "               ORG.ORGSNAME,                                      " & vbLf & _
              "               ORG.ORGKNAME,                                      " & vbLf & _
              "               CONSULT.CSCD,                                      " & vbLf & _
              "               NVL(CTRPT.CSNAME, COURSE_P.CSNAME) CSNAME,         " & vbLf & _
              "               COURSE_P.WEBCOLOR,                                 " & vbLf & _
              "               CONSULT.PERID,                                     " & vbLf & _
              "               PERSON.LASTNAME,                                   " & vbLf & _
              "               PERSON.FIRSTNAME,                                  " & vbLf & _
              "               PERSON.LASTKNAME,                                  " & vbLf & _
              "               PERSON.FIRSTKNAME,                                 " & vbLf & _
              "               GetCslAge(PERSON.BIRTH) AGE,                       " & vbLf & _
              "               PERSON.GENDER,                                     " & vbLf & _
              "               PERBILL_CSL.DMDDATE,                               " & vbLf & _
              "               PERBILL_CSL.BILLSEQ,                               " & vbLf & _
              "               PERBILL_CSL.BRANCHNO                               " & vbLf & _
              "          FROM PERBILL_CSL, ORG, PERSON, CTRPT, COURSE_P, CONSULT "

    '請求日範囲指定
    If vntStartDmdDate <> "" And vntEndDmdDate <> "" Then
        objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "EDMDDATE", Format(Trim(vntEndDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        strStmt = strStmt & vbLf & _
                "                 WHERE CONSULT.CSLDATE BETWEEN :SDMDDATE  AND :EDMDDATE"
    Else
        '請求日開始日のみ指定
        If vntStartDmdDate <> "" And vntEndDmdDate = "" Then
            objOraParam.Add "SDMDDATE", Format(Trim(vntStartDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            strStmt = strStmt & vbLf & _
                    "                 WHERE CONSULT.CSLDATE = :SDMDDATE  "
        End If
    End If

    '団体コード指定
    If vntSearchOrg1 <> "" And vntSearchOrg2 <> "" Then
        objOraParam.Add "ORGCD1", Trim(vntSearchOrg1), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", Trim(vntSearchOrg2), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
                "             AND CONSULT.ORGCD1 = :ORGCD1  " & vbLf & _
                "             AND CONSULT.ORGCD2 = :ORGCD2  "

    End If
    
     '個人ＩＤ指定
    If vntSearchPerId <> "" Then
        objOraParam.Add "PERID", Trim(vntSearchPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
                "             AND CONSULT.PERID = :PERID  "

    End If
   
    strStmt = strStmt & vbLf & _
              "          AND CONSULT.CSCD    = COURSE_P.CSCD      " & vbLf & _
              "          AND CONSULT.CTRPTCD = CTRPT.CTRPTCD      " & vbLf & _
              "          AND CONSULT.PERID   = PERSON.PERID       " & vbLf & _
              "          AND ORG.ORGCD1      = CONSULT.ORGCD1     " & vbLf & _
              "          AND ORG.ORGCD2      = CONSULT.ORGCD2     " & vbLf & _
              "          AND CONSULT.RSVNO   = PERBILL_CSL.RSVNO  " & vbLf & _
              "        ) LASTVIEW                                 "

    strStmt = strStmt & vbLf & _
              " WHERE LASTVIEW.DMDDATE  = PERBILL.DMDDATE " & vbLf & _
              "   AND LASTVIEW.BILLSEQ  = PERBILL.BILLSEQ " & vbLf & _
              "   AND LASTVIEW.BRANCHNO = PERBILL.BRANCHNO"

              
    
    '未収のみ
    If vntPaymentflg = 1 Then
        strStmt = strStmt & vbLf & _
              "    AND PERBILL.PAYMENTDATE IS NULL  "
    End If

              
    '取消伝票を除く
    If vntDelDisp = 1 Then
        strStmt = strStmt & vbLf & _
              "     AND PERBILL.DELFLG = 0  "
    End If
        
    
    strStmt = strStmt & vbLf & _
              ")LISTVIEW"
              
    SetOrgViewSql = True
    
    
    Exit Function
    
ErrorHandle:

    SetOrgViewSql = False
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.SetOrgViewSql"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
'
' 機能　　 : 請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得する
'
' 引数　　 : (In)     strDmdDate     請求日
' 　　　　   (In)     lngBillSeq     請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo    請求書枝番
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntLastName    姓
' 　　　　   (Out)    vntFirstName   名
' 　　　　   (Out)    vntLastKName   カナ姓
' 　　　　   (Out)    vntFirstKName  カナ名
'
' 戻り値　 : 正値   抽出件数
' 　　　　   ０  　 レコードなし
' 　　　　   負値   異常終了
'
' 備考　　 :
'
Public Function SelectPerBill_person( _
    ByVal strDmdDate As String, _
    ByVal lngBillSeq As Long, _
    ByVal lngBranchNo As Long, _
    Optional ByRef vntPerID As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPerID        As OraField         '個人ＩＤ
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    
    Dim vntArrPerID()       As Variant      '個人ＩＤの配列
    Dim vntArrLastName()    As Variant      '姓の配列
    Dim vntArrFirstName()   As Variant      '名の配列
    Dim vntArrLastKName()   As Variant      'カナ姓の配列
    Dim vntArrFirstKName()  As Variant      'カナ名の配列
    
    Dim lngCount      As Long               'カウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectPerBill_person = -1
    
    '初期処理
    If Not IsMissing(vntPerID) Then vntPerID = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER


    '検索条件を満たす個人請求書管理情報テーブルのレコードを取得

    strStmt = "SELECT PERBILL_PERSON.PERID,                      " & vbLf & _
              "       PERSON.LASTNAME,     PERSON.FIRSTNAME,     " & vbLf & _
              "       PERSON.LASTKNAME,    PERSON.FIRSTKNAME     " & vbLf & _
              "  FROM PERBILL_PERSON, PERSON                     " & vbLf & _
              " WHERE PERBILL_PERSON.DMDDATE   = :DMDDATE        " & vbLf & _
              "   AND PERBILL_PERSON.BILLSEQ   = :BILLSEQ        " & vbLf & _
              "   AND PERBILL_PERSON.BRANCHNO  = :BRANCHNO       " & vbLf & _
              "   AND PERBILL_PERSON.PERID     = PERSON.PERID(+) " & vbLf & _
              " ORDER BY PERBILL_PERSON.PERID                    "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerID = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrPerID(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            
            vntArrPerID(lngCount) = objPerID.Value
            vntArrLastName(lngCount) = objLastName.Value
            vntArrFirstName(lngCount) = objFirstName.Value
            vntArrLastKName(lngCount) = objLastKName.Value
            vntArrFirstKName(lngCount) = objFirstKName.Value

            lngCount = lngCount + 1
                        
            objOraDyna.MoveNext
        Loop

        SelectPerBill_person = lngCount
        
    End If
    

    '戻り値の設定
    If Not IsMissing(vntPerID) Then vntPerID = vntArrPerID
    If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
    If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
    If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
    If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerBill_person = 0

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerBill_person"
    
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
' 機能　　 : 請求書Ｎｏから個人請求明細情報を取得する
'            （受診情報に関連付けされない個人情報の取得）
'
' 引数　　 : (In)     strDmdDate     請求日
' 　　　　   (In)     lngBillSeq     請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo    請求書枝番
' 　　　　   (Out)    vntBillLineNo  請求明細行No
' 　　　　   (Out)    vntPrice       金額
' 　　　　   (Out)    vntEditPrice   調整金額
' 　　　　   (Out)    vntTaxPrice    税額
' 　　　　   (Out)    vntEditTax     調整税額
' 　　　　   (Out)    vntLineName    明細名称
' 　　　　   (Out)    vntOtherLineDivCd セット外明細コード
' 　　　　   (Out)    vntOtherLineDivName セット外明細名
'
' 戻り値　 : 正値   抽出件数
' 　　　　   ０  　 レコードなし
' 　　　　   負値   異常終了
'
' 備考　　 :
'
Public Function SelectPerBill_Person_c( _
    ByVal strDmdDate As String, _
    ByVal lngBillSeq As Long, _
    ByVal lngBranchNo As Long, _
    Optional ByRef vntBillLineNo As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntEditPrice As Variant, _
    Optional ByRef vntTaxPrice As Variant, _
    Optional ByRef vntEditTax As Variant, _
    Optional ByRef vntLineName As Variant, _
    Optional ByRef vntOtherLineDivCd As Variant, _
    Optional ByRef vntOtherLineDivName As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objBillLineNo   As OraField         '請求明細行No
    Dim objPrice        As OraField         '金額
    Dim objEditPrice    As OraField         '調整金額
    Dim objTaxPrice     As OraField         '税額
    Dim objEditTax      As OraField         '調整税額
    Dim objLineName     As OraField         '明細名称
    Dim objOtherLineDivCd  As OraField         'セット外明細コード
    Dim objOtherLineDivName  As OraField       'セット外明細名
    
    Dim vntArrBillLineNo()      As Variant         '請求明細行Noの配列
    Dim vntArrPrice()           As Variant         '金額の配列
    Dim vntArrEditPrice()       As Variant         '調整金額の配列
    Dim vntArrTaxPrice()        As Variant         '税額の配列
    Dim vntArrEditTax()         As Variant         '調整税額の配列
    Dim vntArrLineName()        As Variant         '明細名称の配列
    Dim vntArrOtherLineDivCd()     As Variant      'セット外明細コードの配列
    Dim vntArrOtherLineDivName()   As Variant      'セット外明細名の配列
    
    Dim lngCount      As Long             'カウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectPerBill_Person_c = -1
    
    '初期処理
    If Not IsMissing(vntBillLineNo) Then vntBillLineNo = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntEditPrice) Then vntEditPrice = Empty
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = Empty
    If Not IsMissing(vntEditTax) Then vntEditTax = Empty
    If Not IsMissing(vntLineName) Then vntLineName = Empty
    If Not IsMissing(vntOtherLineDivCd) Then vntOtherLineDivCd = Empty
    If Not IsMissing(vntOtherLineDivName) Then vntOtherLineDivName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Trim(strDmdDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす個人請求書明細情報テーブルのレコードを取得
    strStmt = "SELECT PERBILL_C.BILLLINENO,      PERBILL_C.PRICE,                " & vbLf & _
              "       PERBILL_C.EDITPRICE,       PERBILL_C.TAXPRICE,             " & vbLf & _
              "       PERBILL_C.EDITTAX,                                         " & vbLf & _
              "       PERBILL_C.LINENAME,        PERBILL_C.OTHERLINEDIVCD,       " & vbLf & _
              "       OTHERLINEDIV.OTHERLINEDIVNAME                              "

    strStmt = strStmt & vbLf & _
              "  FROM PERBILL_C, OTHERLINEDIV                                    "

    strStmt = strStmt & vbLf & _
              " WHERE PERBILL_C.DMDDATE    = :DMDDATE                            " & vbLf & _
              "   AND PERBILL_C.BILLSEQ    = :BILLSEQ                            " & vbLf & _
              "   AND PERBILL_C.BRANCHNO   = :BRANCHNO                           " & vbLf & _
              "   AND PERBILL_C.OTHERLINEDIVCD   = OTHERLINEDIV.OTHERLINEDIVCD(+)"
    
    strStmt = strStmt & vbLf & _
              " ORDER BY PERBILL_C.DMDDATE,           PERBILL_C.BILLSEQ,          " & vbLf & _
              "          PERBILL_C.BRANCHNO                                       "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillLineNo = objFields("BILLLINENO")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objLineName = objFields("LINENAME")
        Set objOtherLineDivCd = objFields("OTHERLINEDIVCD")
        Set objOtherLineDivName = objFields("OTHERLINEDIVNAME")
        
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillLineNo(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrLineName(lngCount)
            ReDim Preserve vntArrOtherLineDivCd(lngCount)
            ReDim Preserve vntArrOtherLineDivName(lngCount)
            
            vntArrBillLineNo(lngCount) = objBillLineNo.Value
            vntArrPrice(lngCount) = objPrice.Value
            vntArrEditPrice(lngCount) = objEditPrice.Value
            vntArrTaxPrice(lngCount) = objTaxPrice.Value
            vntArrEditTax(lngCount) = objEditTax.Value
            vntArrLineName(lngCount) = objLineName.Value
            vntArrOtherLineDivCd(lngCount) = objOtherLineDivCd.Value
            vntArrOtherLineDivName(lngCount) = objOtherLineDivName.Value

            lngCount = lngCount + 1
                        
            objOraDyna.MoveNext
        Loop

        SelectPerBill_Person_c = lngCount
        
    End If
    

    '戻り値の設定
    If Not IsMissing(vntBillLineNo) Then vntBillLineNo = vntArrBillLineNo
    If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
    If Not IsMissing(vntEditPrice) Then vntEditPrice = vntArrEditPrice
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = vntArrTaxPrice
    If Not IsMissing(vntEditTax) Then vntEditTax = vntArrEditTax
    If Not IsMissing(vntLineName) Then vntLineName = vntArrLineName
    If Not IsMissing(vntOtherLineDivCd) Then vntOtherLineDivCd = vntArrOtherLineDivCd
    If Not IsMissing(vntOtherLineDivName) Then vntOtherLineDivName = vntArrOtherLineDivName


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
        
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerBill_Person_c = 0

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerBill_Person_c"
    
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
' 機能　　 : 個人入金情報テーブルレコードを削除する
'
' 引数　　 : (In)     strPaymentDate    入金日
' 　　　　   (In)     lngPaymentSeq     入金Ｓｅｑ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeletePerPayment( _
                        ByVal strPaymentDate As Variant, _
                        ByVal lngPaymentSeq As Variant _
                        ) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
            
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PAYMENTDATE", Format(Trim(strPaymentDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PAYMENTSEQ", lngPaymentSeq, ORAPARM_INPUT, ORATYPE_NUMBER
                  
'### 2004/11/05 Added by Ishihara@FSIT トリガー削除に伴い、入金情報は自力クリア
    '請求情報の入金情報クリア
    strStmt = "UPDATE PERBILL                     " & vbLf & _
              "   SET PAYMENTDATE = '',           " & vbLf & _
              "       PAYMENTSEQ  = ''            " & vbLf & _
              " WHERE PAYMENTDATE = :PAYMENTDATE  " & vbLf & _
              "   AND PAYMENTSEQ  = :PAYMENTSEQ   "
                  
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'### 2004/11/05 Added End

    '入金情報削除
    strStmt = "DELETE PERPAYMENT                  " & vbLf & _
              " WHERE PAYMENTDATE = :PAYMENTDATE  " & vbLf & _
              "   AND PAYMENTSEQ  = :PAYMENTSEQ   "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    DeletePerPayment = True
    
    Exit Function
    
ErrorHandle:

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    
    DeletePerPayment = False
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.DeletePerPayment"
    
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
' 機能　　 : 個人入金情報テーブルにレコードを挿入する
'
' 引数　　 : (In)     vntMode           1:入金　2:返金
' 　　　　   (In/Out) vntPaymentDate    入金日または返金
' 　　　　   (In/Out) vntPaymentSeq     入金または返金Ｓｅｑ
' 　　　　   (In)     vntOriginalDate   元の入金日（入金の場合"")
' 　　　　   (In)     vntOriginalSeq    元の入金Ｓｅｑ（入金の場合"")
' 　　　　   (In)     vntDmdDate        請求日（配列）
' 　　　　   (In)     vntBillSeq        請求書Ｓｅｑ（配列）
' 　　　　   (In)     vntBranchNo       請求書枝番（配列）
' 　　　　   (In)     lngRegisterno     レジ番号
' 　　　　   (In)     strUpdUser         ユーザＩＤ
' 　　　　   (In)     lngPriceTotal     請求金額合計
' 　　　　   (In)     lngCredit         現金預かり金
' 　　　　   (In)     lngHappy_ticket   ハッピー買物券
' 　　　　   (In)     lngCard           カード
' 　　　　   (In)     strCardKind       カード種別
' 　　　　   (In)     lngCreditslipno   伝票No
' 　　　　   (In)     lngJdebit         Ｊデビット
' 　　　　   (In)     strBankCode       金融機関コード
' 　　　　   (In)     lngCheque         小切手
' ## 振込み　追加 2003.12.25
' 　　　　   (In)     lngTransfer       振込み
' ### 2004/10/29 Add by gouda@FSIT 計上日を追加する
'            (In)     vntCalcDate       計上日
' ### 2004/10/29 Add
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
' ### 2004/10/29 Add by gouda@FSIT 計上日を追加する
'Public Function InsertPerPayment(
'    ByVal vntMode As Variant,
'    ByRef vntPaymentDate As Variant, ByRef vntPaymentSeq As Variant,
'    ByVal vntOriginalDate As Variant, ByVal vntOriginalSeq As Variant,
'    ByVal vntDmdDate As Variant, ByVal vntBillSeq As Variant,
'    ByVal vntBranchNo As Variant,
'    ByVal lngRegisterno As Long,
'    ByVal strUpdUser As String,
'    Optional ByVal lngPriceTotal As Long, Optional ByVal lngCredit As Long = 0,
'    Optional ByVal lngHappy_ticket As Long = 0, Optional ByVal lngCard As Long = 0,
'    Optional ByVal strCardKind As String = "", Optional ByVal lngCreditslipno As Long = 0,
'    Optional ByVal lngJdebit As Long = 0, Optional ByVal strBankCode As String = "",
'    Optional ByVal lngCheque As Long = 0, Optional ByVal lngTransfer As Long
') As Variant

Public Function InsertPerPayment( _
    ByVal vntMode As Variant, _
    ByRef vntPaymentDate As Variant, ByRef vntPaymentSeq As Variant, _
    ByVal vntOriginalDate As Variant, ByVal vntOriginalSeq As Variant, _
    ByVal vntDmdDate As Variant, ByVal vntBillSeq As Variant, _
    ByVal vntBranchNo As Variant, _
    ByVal lngRegisterno As Long, _
    ByVal strUpdUser As String, _
    Optional ByVal lngPriceTotal As Long, Optional ByVal lngCredit As Long = 0, _
    Optional ByVal lngHappy_ticket As Long = 0, Optional ByVal lngCard As Long = 0, _
    Optional ByVal strCardKind As String = "", Optional ByVal lngCreditslipno As Long = 0, _
    Optional ByVal lngJdebit As Long = 0, Optional ByVal strBankCode As String = "", _
    Optional ByVal lngCheque As Long = 0, Optional ByVal lngTransfer As Long, _
    Optional ByVal vntCalcDate As Variant _
) As Variant

' ### 2004/10/29 Add End

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objDmdDate              As OraParameter     '請求日
    Dim objBillSeq              As OraParameter     '請求書Ｓｅｑ
    Dim objBranchNo             As OraParameter     '請求書枝番

    Dim strPaymentDate          As Date             '入金日
    Dim lngPaymentSeq           As Long             '入金Ｓｅｑ
    Dim Ret                     As Long             '関数戻り値
    
    Dim vntPriceTotal           As Variant          '請求金額合計
    Dim vntCredit               As Variant          '現金預かり金
    Dim vntHappy_ticket         As Variant          'ハッピー買物券
    Dim vntCard                 As Variant          'カード
    Dim vntCardKind             As Variant          'カード種別
    Dim vntCreditslipno         As Variant          '伝票Ｎｏ
    Dim vntJdebit               As Variant          'Ｊデビット
    Dim vntBankCode             As Variant          '金融機関コード
    Dim vntCheque               As Variant          '小切手
    ' ### 振込み　追加 2003.12.25
    Dim vntTransfer             As Variant          '振込み
    
    Dim blnAns                  As Boolean          '関数戻り値
    
    Dim i                       As Long             'カウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    InsertPerPayment = Empty
    
    '請求書Ｎｏが存在するか？　とかチェックしたほうがいいかなぁ。。。
    
    strPaymentDate = vntPaymentDate
    '入金Ｓｅｑ発番処理
    lngPaymentSeq = GetPerPaymentSeq(strPaymentDate)
    
    '入金の場合
    If vntMode = 1 Then
    
        '入金金額が請求金額に達していない
        ' ### 振込み(lngTransfer)　追加　2003.12.25
        If lngPriceTotal > (lngCredit + lngHappy_ticket + lngCard + lngJdebit + lngCheque + lngTransfer) Then
            InsertPerPayment = Array("入金金額が請求金額に達していないため保存できません。")
            Exit Function
        End If
        

        'カード金額があるのにカード種別、伝票番号が入っていない
        If lngCard <> 0 And _
           (strCardKind = "" Or CLng(lngCreditslipno) = 0) Then
            InsertPerPayment = Array("カード情報が入力されていません。")
            Exit Function
        End If
        
        'Ｊデビット金額があるのに金融機関が無い
        If lngJdebit <> 0 And strBankCode = "" Then
            InsertPerPayment = Array("Ｊデビットの金融機関が指定されていません。")
            Exit Function
        End If

        'キー及び更新値の設定
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "PAYMENTDATE", Format(CDate(strPaymentDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "PAYMENTSEQ", lngPaymentSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        
        objOraParam.Add "PRICETOTAL", lngPriceTotal, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "CREDIT", lngCredit, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "HAPPY_TICKET", lngHappy_ticket, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "CARD", lngCard, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "CARDKIND", Trim(strCardKind), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "CREDITSLIPNO", lngCreditslipno, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "JDEBIT", lngJdebit, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BANKCODE", Trim(strBankCode), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "CHEQUE", lngCheque, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "TRANSFER", lngTransfer, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '返金の場合
    If vntMode = 2 Then
        
        '### 振込み（vntTransfer）　追加　（2003.12.25）
        blnAns = SelectPerPayment( _
                    vntOriginalDate, vntOriginalSeq, _
                    vntPriceTotal, vntCredit, _
                    vntHappy_ticket, vntCard, _
                    vntCardKind, , _
                    vntCreditslipno, _
                    vntJdebit, vntBankCode, _
                     , vntCheque, , , , , vntTransfer _
                    )
        'キー及び更新値の設定
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "PAYMENTDATE", Format(CDate(strPaymentDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "PAYMENTSEQ", lngPaymentSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        
        objOraParam.Add "PRICETOTAL", -1 * vntPriceTotal, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "CREDIT", -1 * vntCredit, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "HAPPY_TICKET", -1 * vntHappy_ticket, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "CARD", -1 * vntCard, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "CARDKIND", Trim(vntCardKind), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "CREDITSLIPNO", vntCreditslipno, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "JDEBIT", -1 * vntJdebit, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BANKCODE", Trim(vntBankCode), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "CHEQUE", -1 * vntCheque, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "TRANSFER", -1 * vntTransfer, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    objOraParam.Add "REGISTERNO", lngRegisterno, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDDATE", Trim(strPaymentDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
' ### 2004/10/29 Add by gouda@FSIT 計上日を追加する
    objOraParam.Add "CALCDATE", Format(CDate(vntCalcDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
' ### 2004/10/29 Add End

    '入金情報テーブルレコードの挿入
    ' ### 2004/10/29 Add by gouda@FSIT 計上日を追加する
    ' ### 振込み(TRANSFER)　追加 2003.12.25
    ' ### 入金処理者(INSUSER)　追加 2004.01.19 (入金処理日時はDEFAULT(SYSDATE))
'    strStmt = "INSERT INTO PERPAYMENT (     " & vbLf & _
'              "                PAYMENTDATE, " & vbLf & _
'              "                PAYMENTSEQ,  " & vbLf & _
'              "                PRICETOTAL,  " & vbLf & _
'              "                CREDIT,      " & vbLf & _
'              "                HAPPY_TICKET," & vbLf & _
'              "                CARD,        " & vbLf & _
'              "                CARDKIND,    " & vbLf & _
'              "                CREDITSLIPNO," & vbLf & _
'              "                JDEBIT,      " & vbLf & _
'              "                BANKCODE,    " & vbLf & _
'              "                CHEQUE,      " & vbLf & _
'              "                TRANSFER,    " & vbLf & _
'              "                REGISTERNO,  " & vbLf & _
'              "                UPDDATE,     " & vbLf & _
'              "                UPDUSER,     " & vbLf & _
'              "                INSUSER      "
'
'    strStmt = strStmt & vbLf & _
'              "            ) VALUES (           " & vbLf & _
'              "                :PAYMENTDATE,    " & vbLf & _
'              "                :PAYMENTSEQ,     " & vbLf & _
'              "                :PRICETOTAL,     " & vbLf & _
'              "                :CREDIT,         " & vbLf & _
'              "                :HAPPY_TICKET,   " & vbLf & _
'              "                :CARD,           " & vbLf & _
'              "                :CARDKIND,       " & vbLf & _
'              "                :CREDITSLIPNO,   " & vbLf & _
'              "                :JDEBIT,         " & vbLf & _
'              "                :BANKCODE,       " & vbLf & _
'              "                :CHEQUE,         " & vbLf & _
'              "                :TRANSFER,       " & vbLf & _
'              "                :REGISTERNO,     " & vbLf & _
'              "                SYSDATE,         " & vbLf & _
'              "                :UPDUSER,        " & vbLf & _
'              "                :UPDUSER         " & vbLf & _
'              "            )                    "
    
    strStmt = "INSERT INTO PERPAYMENT (     " & vbLf & _
              "                PAYMENTDATE, " & vbLf & _
              "                PAYMENTSEQ,  " & vbLf & _
              "                PRICETOTAL,  " & vbLf & _
              "                CREDIT,      " & vbLf & _
              "                HAPPY_TICKET," & vbLf & _
              "                CARD,        " & vbLf & _
              "                CARDKIND,    " & vbLf & _
              "                CREDITSLIPNO," & vbLf & _
              "                JDEBIT,      " & vbLf & _
              "                BANKCODE,    " & vbLf & _
              "                CHEQUE,      " & vbLf & _
              "                TRANSFER,    " & vbLf & _
              "                REGISTERNO,  " & vbLf & _
              "                UPDDATE,     " & vbLf & _
              "                UPDUSER,     " & vbLf & _
              "                INSUSER,     " & vbLf & _
              "                CALCDATE     "
              
    strStmt = strStmt & vbLf & _
              "            ) VALUES (           " & vbLf & _
              "                :PAYMENTDATE,    " & vbLf & _
              "                :PAYMENTSEQ,     " & vbLf & _
              "                :PRICETOTAL,     " & vbLf & _
              "                :CREDIT,         " & vbLf & _
              "                :HAPPY_TICKET,   " & vbLf & _
              "                :CARD,           " & vbLf & _
              "                :CARDKIND,       " & vbLf & _
              "                :CREDITSLIPNO,   " & vbLf & _
              "                :JDEBIT,         " & vbLf & _
              "                :BANKCODE,       " & vbLf & _
              "                :CHEQUE,         " & vbLf & _
              "                :TRANSFER,       " & vbLf & _
              "                :REGISTERNO,     " & vbLf & _
              "                SYSDATE,         " & vbLf & _
              "                :UPDUSER,        " & vbLf & _
              "                :UPDUSER,        " & vbLf & _
              "                :CALCDATE        " & vbLf & _
              "            )                    "
' ### 2004/10/29 Add End

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の設定
    vntPaymentDate = strPaymentDate
    vntPaymentSeq = lngPaymentSeq
    
    '個人請求管理テーブルレコードの入金日、入金Ｓｅｑセット
    blnAns = SetPayment_PerBill( _
                    strPaymentDate, lngPaymentSeq, _
                    vntDmdDate, vntBillSeq, vntBranchNo _
                    )
     
'### 2005/1/11 Added by Ishihara@FSIT 未使用未入金データクリア処理
    '未使用未入金データの削除
    blnAns = Delete_NotUsePerPayment(strPaymentDate)
'### 2005/1/11 Added End

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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

    'イベントログ書き込み
    WriteErrorLog "PerBill.InsertPerPayment"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人請求管理テーブルレコードの入金日、入金Ｓｅｑセットする
'
' 引数　　 : (In)     vntPaymentDate    入金日または返金
' 　　　　   (In)     vntPaymentSeq     入金または返金Ｓｅｑ
' 　　　　   (In)     vntOriginalDate   元の入金日（入金の場合"")
' 　　　　   (In)     vntOriginalSeq    元の入金Ｓｅｑ（入金の場合"")
' 　　　　   (In)     vntDmdDate        請求日（配列）
' 　　　　   (In)     vntBillSeq        請求書Ｓｅｑ（配列）
' 　　　　   (In)     vntBranchNo       請求書枝番（配列）
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Private Function SetPayment_PerBill( _
    ByVal strPaymentDate As String, ByVal lngPaymentSeq As Long, _
    ByVal vntDmdDate As Variant, ByVal vntBillSeq As Variant, _
    ByVal vntBranchNo As Variant _
) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt           As OraSqlStmt       'OraSQLStmtオブジェクト
'### 2004/12/10 Added by Ishihara@FSIT 安全のために別オブジェクト
    Dim objOraSQLStmt2          As OraSqlStmt       'OraSQLStmtオブジェクト
'### 2004/12/10 Added End
    Dim strStmt                 As String           'SQLステートメント
    
'### 2004/11/29 Added by Ishihara@FSIT 入金情報更新前に現在のキー情報を退避
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPaymentDate          As OraField         '入金日
    Dim objPaymentSeq           As OraField         '入金Ｓｅｑ

    Dim vntPaymentDate_back()   As Variant          '削除対象かもしれない入金日(Key)
    Dim vntPaymentSeq_back()    As Variant          '削除対象かもしれない入金Seq(Key)
    Dim lngPaymentKeyCount      As Long

    Dim objDelPaymentDate       As OraParameter     '入金日
    Dim objDelPaymentSeq        As OraParameter     '入金Ｓｅｑ

'### 2004/11/29 Added End
    
    Dim objDmdDate              As OraParameter     '請求日
    Dim objBillSeq              As OraParameter     '請求書Ｓｅｑ
    Dim objBranchNo             As OraParameter     '請求書枝番

    
    Dim i                       As Long             'カウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SETPAYMENTDATE", Format(CDate(strPaymentDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "SETPAYMENTSEQ", lngPaymentSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '個人請求管理テーブルレコードの入金日、入金Ｓｅｑセット
    objOraParam.Add "DMDDATE", "", ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", "", ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", "", ORAPARM_INPUT, ORATYPE_NUMBER
    
    Set objDmdDate = objOraParam("DMDDATE")
    Set objBillSeq = objOraParam("BILLSEQ")
    Set objBranchNo = objOraParam("BRANCHNO")
'### 2004/11/29 Added by Ishihara@FSIT 入金情報更新前に現在のキー情報を退避
    
    '現在の入金情報キーを退避
    strStmt = "SELECT PAYMENTDATE, PAYMENTSEQ         " & vbLf & _
              "  FROM PERBILL                         " & vbLf & _
              " WHERE PERBILL.DMDDATE  = :DMDDATE     " & vbLf & _
              "   AND PERBILL.BILLSEQ  = :BILLSEQ     " & vbLf & _
              "   AND PERBILL.BRANCHNO = :BRANCHNO    " & vbLf & _
              "   AND PERBILL.PAYMENTDATE IS NOT NULL " & vbLf & _
              "   AND PERBILL.PAYMENTSEQ  IS NOT NULL "
    
    lngPaymentKeyCount = 0
    For i = 0 To UBound(vntDmdDate)
        
        objDmdDate.Value = Trim(vntDmdDate(i))
        objBillSeq.Value = Trim(vntBillSeq(i))
        objBranchNo.Value = Trim(vntBranchNo(i))
    
        'SQL文の実行（初回のみCreateDynaset）
        If i = 0 Then
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objPaymentDate = objFields("PAYMENTDATE")
            Set objPaymentSeq = objFields("PAYMENTSEQ")
        
        Else
            objOraDyna.Refresh
        End If
    
        Do Until objOraDyna.EOF
            ReDim Preserve vntPaymentDate_back(lngPaymentKeyCount)
            ReDim Preserve vntPaymentSeq_back(lngPaymentKeyCount)
            vntPaymentDate_back(lngPaymentKeyCount) = objPaymentDate.Value
            vntPaymentSeq_back(lngPaymentKeyCount) = objPaymentSeq.Value
            lngPaymentKeyCount = lngPaymentKeyCount + 1
            objOraDyna.MoveNext
        Loop
    
    Next
'### 2004/11/29 Added End
    
    strStmt = "UPDATE PERBILL                             " & vbLf & _
              "   SET PAYMENTDATE      = :SETPAYMENTDATE, " & vbLf & _
              "       PAYMENTSEQ       = :SETPAYMENTSEQ   " & vbLf & _
              " WHERE PERBILL.DMDDATE  = :DMDDATE         " & vbLf & _
              "   AND PERBILL.BILLSEQ  = :BILLSEQ         " & vbLf & _
              "   AND PERBILL.BRANCHNO = :BRANCHNO        "
        
    For i = 0 To UBound(vntDmdDate)
        objDmdDate.Value = Trim(vntDmdDate(i))
        objBillSeq.Value = Trim(vntBillSeq(i))
        objBranchNo.Value = Trim(vntBranchNo(i))
    
        'SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
    Next
     
'### 2004/11/29 Added by Ishihara@FSIT 入金情報更新前に現在のキー情報を退避

    '入金情報削除（請求書伝票で全く使用していないもののみ）
    strStmt = "DELETE PERPAYMENT                                          " & vbLf & _
              " WHERE PERPAYMENT.PAYMENTDATE = :DELPAYMENTDATE            " & vbLf & _
              "   AND PERPAYMENT.PAYMENTSEQ  = :DELPAYMENTSEQ             " & vbLf & _
              "   AND 0 = ( SELECT COUNT(*)                               " & vbLf & _
              "               FROM PERBILL                                " & vbLf & _
              "              WHERE PERBILL.PAYMENTDATE = :DELPAYMENTDATE  " & vbLf & _
              "                AND PERBILL.PAYMENTSEQ  = :DELPAYMENTSEQ ) "

    '削除するキーセット
    objOraParam.Add "DELPAYMENTDATE", "", ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "DELPAYMENTSEQ", "", ORAPARM_INPUT, ORATYPE_NUMBER

    Set objDelPaymentDate = objOraParam("DELPAYMENTDATE")
    Set objDelPaymentSeq = objOraParam("DELPAYMENTSEQ")

    '更新前の入金キー情報から存在チェックを実施
    For i = 0 To lngPaymentKeyCount - 1
    
        objDelPaymentDate.Value = vntPaymentDate_back(i)
        objDelPaymentSeq.Value = vntPaymentSeq_back(i)
    
        'SQL文の実行（初回のみCreateSQL）
        If i = 0 Then
'### 2004/12/10 Added by Ishihara@FSIT 安全のために別オブジェクト
'            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
            Set objOraSQLStmt2 = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
'### 2004/12/10 Added End
        Else
'### 2004/12/10 Added by Ishihara@FSIT 安全のために別オブジェクト
'            objOraSQLStmt.Refresh
            objOraSQLStmt2.Refresh
'### 2004/12/10 Added End
        End If
    
    Next i

'### 2004/11/29 Added End
    
    SetPayment_PerBill = True

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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
    

    SetPayment_PerBill = False

    'イベントログ書き込み
    WriteErrorLog "PerBill.SetPayment_PerBill"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

' ### 2004.01.01 add
'
' 機能　　 : 個人請求管理テーブルレコードの入金日、入金Ｓｅｑをクリアする
'
' 引数　　 : (In)     vntDmdDate        請求日（配列）
' 　　　　   (In)     vntBillSeq        請求書Ｓｅｑ（配列）
' 　　　　   (In)     vntBranchNo       請求書枝番（配列）
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Private Function ClrPayment_PerBill( _
    ByVal vntDmdDate As Variant, ByVal vntBillSeq As Variant, _
    ByVal vntBranchNo As Variant _
) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt           As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objDmdDate              As OraParameter     '請求日
    Dim objBillSeq              As OraParameter     '請求書Ｓｅｑ
    Dim objBranchNo             As OraParameter     '請求書枝番

    
    Dim i                       As Long             'カウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    '個人請求管理テーブルレコードの入金日、入金Ｓｅｑクリア
    objOraParam.Add "DMDDATE", "", ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", "", ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", "", ORAPARM_INPUT, ORATYPE_NUMBER
    
    Set objDmdDate = objOraParam("DMDDATE")
    Set objBillSeq = objOraParam("BILLSEQ")
    Set objBranchNo = objOraParam("BRANCHNO")
    
    strStmt = "UPDATE PERBILL                             " & vbLf & _
              "   SET PAYMENTDATE      = NULL,            " & vbLf & _
              "       PAYMENTSEQ       = NULL             " & vbLf & _
              " WHERE PERBILL.DMDDATE  = :DMDDATE         " & vbLf & _
              "   AND PERBILL.BILLSEQ  = :BILLSEQ         " & vbLf & _
              "   AND PERBILL.BRANCHNO = :BRANCHNO        "
        
    For i = 0 To UBound(vntDmdDate)
        objDmdDate.Value = Trim(vntDmdDate(i))
        objBillSeq.Value = Trim(vntBillSeq(i))
        objBranchNo.Value = Trim(vntBranchNo(i))
    
        'SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
    Next
     

    
    ClrPayment_PerBill = True

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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
    

    ClrPayment_PerBill = False

    'イベントログ書き込み
    WriteErrorLog "PerBill.ClrPayment_PerBill"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人入金情報テーブルの１レコードを更新する
'
' 引数　　 : (In)     vntMode           1:入金　2:返金
' 　　　　   (In)     strKeyDate        更新前の入金日（キー）
' 　　　　   (In)     lngKeySeq         更新前の入金Ｓｅｑ（キー）
' 　　　　   (In)     strPaymentDate    入金日
' 　　　　   (In)     lngPaymentSeq     入金Ｓｅｑ
' 　　　　   (In)     vntDmdDate        請求日（配列）
' 　　　　   (In)     vntBillSeq        請求書Ｓｅｑ（配列）
' 　　　　   (In)     vntBranchNo       請求書枝番（配列）
' 　　　　   (In)     vntPriceTotal     請求金額合計
' 　　　　   (In)     vntRegisterno     レジ番号
' 　　　　   (In)     vntUpdUser        ユーザＩＤ
' 　　　　   (In)     vntCredit         現金預かり金
' 　　　　   (In)     vntHappy_ticket   ハッピー買物券
' 　　　　   (In)     vntCard           カード
' 　　　　   (In)     vntCardKind       カード種別
' 　　　　   (In)     vntCreditslipno   伝票No
' 　　　　   (In)     vntJdebit         Ｊデビット
' 　　　　   (In)     vntBankCode       金融機関コード
' 　　　　   (In)     vntCheque         小切手
' ## 振込み　追加 2003.12.25
' 　　　　   (In)     lngTransfer       振込み
' ### 2004/10/29 Add by gouda@FSIT 計上日を追加する
'            (In)     vntCalcDate       計上日
' ### 2004/10/29 Add
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
' ### 2004/10/29 Add by gouda@FSIT 計上日を追加する
'Public Function UpdatePerPayment(
'    ByVal vntMode As Variant,
'    ByVal strKeyDate As Variant, ByRef lngKeySeq As Variant,
'    ByVal strPaymentDate As Variant, ByRef lngPaymentSeq As Variant,
'    ByVal vntDmdDate As Variant, ByVal vntBillSeq As Variant,
'    ByVal vntBranchNo As Variant,
'    Optional ByVal vntPriceTotal As Variant, Optional ByVal vntRegisterno As Variant,
'    Optional ByVal vntUpdUser As Variant,
'    Optional ByVal vntCredit As Variant,
'    Optional ByVal vntHappy_ticket As Variant, Optional ByVal vntCard As Variant,
'    Optional ByVal vntCardKind As Variant, Optional ByVal vntCreditslipno As Variant,
'    Optional ByVal vntJdebit As Variant, Optional ByVal vntBankCode As Variant,
'    Optional ByVal vntCheque As Variant, Optional ByVal vntTransfer As Variant
') As Variant

Public Function UpdatePerPayment( _
    ByVal vntMode As Variant, _
    ByVal strKeyDate As Variant, ByRef lngKeySeq As Variant, _
    ByVal strPaymentDate As Variant, ByRef lngPaymentSeq As Variant, _
    ByVal vntDmdDate As Variant, ByVal vntBillSeq As Variant, _
    ByVal vntBranchNo As Variant, _
    Optional ByVal vntPriceTotal As Variant, Optional ByVal vntRegisterno As Variant, _
    Optional ByVal vntUpdUser As Variant, _
    Optional ByVal vntCredit As Variant, _
    Optional ByVal vntHappy_ticket As Variant, Optional ByVal vntCard As Variant, _
    Optional ByVal vntCardKind As Variant, Optional ByVal vntCreditslipno As Variant, _
    Optional ByVal vntJdebit As Variant, Optional ByVal vntBankCode As Variant, _
    Optional ByVal vntCheque As Variant, Optional ByVal vntTransfer As Variant, _
    Optional ByVal vntCalcDate _
) As Variant
' ### 2004/10/29 Add

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim Ret                     As Long             '関数戻り値
    Dim blnAns                  As Boolean          '関数戻り値
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    UpdatePerPayment = Empty

    '入金？
    If vntMode = 1 Then
        '入金日がない
        If strPaymentDate = "" Then
            UpdatePerPayment = Array("入金日が指定されていません。")
            Exit Function
        End If
    
        '入金金額が請求金額に達していない
        ' ## 振込み（vntTransfer)　を追加 2003.12.25
        If CLng(vntPriceTotal) > (CLng(vntCredit) + CLng(vntHappy_ticket) + CLng(vntCard) + CLng(vntJdebit) + CLng(vntCheque) + CLng(vntTransfer)) Then
            UpdatePerPayment = Array("入金金額が請求金額に達していないため保存できません。")
            Exit Function
        End If
        

        'カード金額があるのにカード種別、伝票番号が入っていない
        If CLng(vntCard) <> 0 And _
            (vntCardKind = "" Or CLng(vntCreditslipno) = 0) Then
            UpdatePerPayment = Array("カード情報が入力されていません。")
            Exit Function
        End If
        

        'Ｊデビット金額があるのに金融機関が無い
        If CLng(vntJdebit) <> 0 And vntBankCode = "" Then
            UpdatePerPayment = Array("Ｊデビットの金融機関が指定されていません。")
            Exit Function
        End If
    End If

    '返金？
    If vntMode = 2 Then
        '返金日がない
        If strPaymentDate = "" Then
            UpdatePerPayment = Array("返金日が指定されていません。")
            Exit Function
        End If
    End If
    
    '### 2004.01.01 add start
    '個人請求管理テーブルレコードの入金日、入金Ｓｅｑクリア
    blnAns = ClrPayment_PerBill( _
                    vntDmdDate, vntBillSeq, vntBranchNo _
                    )
    '### 2004.01.01 add start
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "KEYDATE", Format(Trim(strKeyDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "KEYSEQ", lngKeySeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "PAYMENTDATE", Format(Trim(strPaymentDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    
    If Trim(strPaymentDate) <> Trim(strKeyDate) Then
        '入金Ｓｅｑ発番処理
        lngPaymentSeq = GetPerPaymentSeq(CDate(Trim(strPaymentDate)))
    Else
        lngPaymentSeq = lngKeySeq
    End If
    
    objOraParam.Add "PAYMENTSEQ", lngPaymentSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
     
    '入金情報テーブルレコードの更新
    strStmt = "UPDATE PERPAYMENT                  " & vbLf & _
              "   SET PAYMENTDATE  = :PAYMENTDATE," & vbLf & _
              "       PAYMENTSEQ   = :PAYMENTSEQ  "
    

    If IsMissing(vntPriceTotal) = False Then
        objOraParam.Add "PRICETOTAL", vntPriceTotal, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                         " & vbLf & _
                "    PRICETOTAL  = :PRICETOTAL"
    End If

    If IsMissing(vntCredit) = False Then
        objOraParam.Add "CREDIT", vntCredit, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                         " & vbLf & _
                "    CREDIT  = :CREDIT        "
    End If
    
    If IsMissing(vntHappy_ticket) = False Then
        objOraParam.Add "HAPPY_TICKET", vntHappy_ticket, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                               " & vbLf & _
                "    HAPPY_TICKET  = :HAPPY_TICKET  "
    End If
    
    If IsMissing(vntCard) = False Then
        objOraParam.Add "CARD", vntCard, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,               " & vbLf & _
                "    CARD  = :CARD  "
    End If
    
    If IsMissing(vntCardKind) = False Then
        objOraParam.Add "CARDKIND", Trim(vntCardKind), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
                "   ,                       " & vbLf & _
                "    CARDKIND  = :CARDKIND  "
    End If
    
    If IsMissing(vntCreditslipno) = False Then
        objOraParam.Add "CREDITSLIPNO", vntCreditslipno, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                               " & vbLf & _
                "    CREDITSLIPNO  = :CREDITSLIPNO  "
    End If
    
    If IsMissing(vntJdebit) = False Then
        objOraParam.Add "JDEBIT", vntJdebit, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                   " & vbLf & _
                "    JDEBIT  = :JDEBIT  "
    End If
    
    If IsMissing(vntBankCode) = False Then
        objOraParam.Add "BANKCODE", Trim(vntBankCode), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
                "   ,                       " & vbLf & _
                "    BANKCODE  = :BANKCODE  "
    End If
    
    If IsMissing(vntCheque) = False Then
        objOraParam.Add "CHEQUE", vntCheque, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                   " & vbLf & _
                "    CHEQUE  = :CHEQUE  "
    End If
    
    ' ## 振込み　を追加 2003.12.25 start
    If IsMissing(vntTransfer) = False Then
        objOraParam.Add "TRANSFER", vntTransfer, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                   " & vbLf & _
                "    TRANSFER  = :TRANSFER  "
    End If
    ' ## 振込み　を追加 2003.12.25 end
    
    If IsMissing(vntRegisterno) = False Then
        objOraParam.Add "REGISTERNO", vntRegisterno, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
                "   ,                          " & vbLf & _
                "    REGISTERNO  = :REGISTERNO  "
    End If
        
    If IsMissing(vntUpdUser) = False Then
        objOraParam.Add "UPDUSER", Trim(vntUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
                "   ,                     " & vbLf & _
                "    UPDUSER  = :UPDUSER  "
    End If
        
    strStmt = strStmt & vbLf & _
            "   , UPDDATE = SYSDATE              "

' ### 2004/10/29 Add by gouda@FSIT 計上日を追加する
    If IsMissing(vntCalcDate) = False Then
        objOraParam.Add "CALCDATE", Format(CDate(vntCalcDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        strStmt = strStmt & vbLf & _
                "   ,                     " & vbLf & _
                "    CALCDATE  = :CALCDATE  "
    End If
' ### 2004/10/29 Add End
            
    strStmt = strStmt & vbLf & _
                " WHERE PAYMENTDATE = :KEYDATE " & vbLf & _
                "   AND PAYMENTSEQ  = :KEYSEQ  "
                            
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '個人請求管理テーブルレコードの入金日、入金Ｓｅｑセット
    blnAns = SetPayment_PerBill( _
                    strPaymentDate, lngPaymentSeq, _
                    vntDmdDate, vntBillSeq, vntBranchNo _
                    )
    
'### 2005/1/11 Added by Ishihara@FSIT 未使用未入金データクリア処理
    '未使用未入金データの削除
    blnAns = Delete_NotUsePerPayment(strPaymentDate)
'### 2005/1/11 Added End

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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
    

    'イベントログ書き込み
    WriteErrorLog "PerBill.UpdatePerPayment"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
'### 2005/1/11 Added Function by Ishihara@FSIT
'
' 機能　　 : 未使用入金データのクリア
'
' 引数　　 : (In)     strPaymentDate    入金日または返金
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Private Function Delete_NotUsePerPayment( _
    ByVal strPaymentDate As String _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
            
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PAYMENTDATE", Format(Trim(strPaymentDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
                  
    '未使用入金情報削除
    strStmt = "DELETE PERPAYMENT                                " & vbLf & _
              " WHERE (PAYMENTDATE, PAYMENTSEQ) IN              " & vbLf & _
              "       ( SELECT B.PAYMENTDATE, B.PAYMENTSEQ      " & vbLf & _
              "           FROM PERBILL A, PERPAYMENT B          " & vbLf & _
              "          WHERE A.PAYMENTDATE(+) = B.PAYMENTDATE " & vbLf & _
              "            AND A.PAYMENTSEQ (+) = B.PAYMENTSEQ  " & vbLf & _
              "            AND A.PAYMENTDATE IS NULL            " & vbLf & _
              "       )                                         " & vbLf & _
              "   AND PAYMENTDATE = :PAYMENTDATE                "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Delete_NotUsePerPayment = True
    
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
    
    Delete_NotUsePerPayment = False
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.Delete_NotUsePerPayment"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 予約番号から個人請求書管理情報を取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (Out)    vntDmdDate     請求日
' 　　　　   (Out)    vntBillSeq     請求書Ｓｅｑ
' 　　　　   (Out)    vntBranchNo    請求書枝番
' 　　　　   (Out)    vntDelflg      取消伝票フラグ
' 　　　　   (Out)    vntUpdDate     更新日時
' 　　　　   (Out)    vntUpdUser     ユーザＩＤ
' 　　　　   (Out)    vntUserName    ユーザ漢字氏名
' 　　　　   (Out)    vntBillcomment 請求書コメント
' 　　　　   (Out)    vntPaymentDate 入金日
' 　　　　   (Out)    vntPaymentSeq  入金Ｓｅｑ
' 　　　　   (Out)    vntPrice       金額（請求書合計）
' 　　　　   (Out)    vntEditPrice   調整金額（請求書合計）
' 　　　　   (Out)    vntTaxPrice    税額（請求書合計）
' 　　　　   (Out)    vntEditTax     調整税額（請求書合計）
' 　　　　   (Out)    vntSubTotal    小計（請求書合計）
' 　　　　   (Out)    vntTaxTotal    税合計（請求書合計）
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPerBill( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntDmdDate As Variant, _
    Optional ByRef vntBillSeq As Variant, _
    Optional ByRef vntBranchNo As Variant, _
    Optional ByRef vntDelflg As Variant, _
    Optional ByRef vntUpdDate As Variant, _
    Optional ByRef vntUpdUser As Variant, _
    Optional ByRef vntUserName As Variant, _
    Optional ByRef vntBillcomment As Variant, _
    Optional ByRef vntPaymentDate As Variant, _
    Optional ByRef vntPaymentSeq As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntEditPrice As Variant, _
    Optional ByRef vntTaxPrice As Variant, _
    Optional ByRef vntEditTax As Variant, _
    Optional ByRef vntSubTotal As Variant, _
    Optional ByRef vntTaxTotal As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objDmdDate      As OraField         '請求日
    Dim objBillSeq      As OraField         '請求書Ｓｅｑ
    Dim objBranchNo     As OraField         '請求書枝番
    Dim objDelflg       As OraField         '取消伝票フラグ
    Dim objUpdDate      As OraField         '更新日時
    Dim objUpdUser      As OraField         'ユーザＩＤ
    Dim objUserName     As OraField         'ユーザ漢字氏名
    Dim objBillcomment  As OraField         '請求書コメント
    Dim objPaymentDate  As OraField         '入金日
    Dim objPaymentSeq   As OraField         '入金Ｓｅｑ
    Dim objPrice        As OraField         '金額
    Dim objEditPrice    As OraField         '調整金額
    Dim objTaxPrice     As OraField         '税額
    Dim objEditTax      As OraField         '調整税額
    
    Dim vntArrDmdDate()     As Variant         '請求日の配列
    Dim vntArrBillSeq()     As Variant         '請求書Ｓｅｑの配列
    Dim vntArrBranchNo()    As Variant         '請求書枝番の配列
    Dim vntArrDelflg()      As Variant         '取消伝票フラグの配列
    Dim vntArrUpdDate()     As Variant         '更新日時の配列
    Dim vntArrUpdUser()     As Variant         'ユーザＩＤの配列
    Dim vntArrUserName()    As Variant         'ユーザ漢字氏名の配列
    Dim vntArrBillcomment() As Variant         '請求書コメントの配列
    Dim vntArrPaymentDate() As Variant         '入金日の配列
    Dim vntArrPaymentSeq()  As Variant         '入金Ｓｅｑの配列
    Dim vntArrPrice()       As Variant         '金額の配列
    Dim vntArrEditPrice()   As Variant         '調整金額の配列
    Dim vntArrTaxPrice()    As Variant         '税額の配列
    Dim vntArrEditTax()     As Variant         '調整税額の配列
    Dim vntArrSubTotal()    As Variant         '小計の配列
    Dim vntArrTaxTotal()    As Variant         '税合計の配列
    
    Dim lngCount      As Long             'カウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntDmdDate) Then vntDmdDate = Empty
    If Not IsMissing(vntBillSeq) Then vntBillSeq = Empty
    If Not IsMissing(vntBranchNo) Then vntBranchNo = Empty
    If Not IsMissing(vntDelflg) Then vntDelflg = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUserName) Then vntUserName = Empty
    If Not IsMissing(vntBillcomment) Then vntBillcomment = Empty
    If Not IsMissing(vntPaymentDate) Then vntPaymentDate = Empty
    If Not IsMissing(vntPaymentSeq) Then vntPaymentSeq = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntEditPrice) Then vntEditPrice = Empty
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = Empty
    If Not IsMissing(vntEditTax) Then vntEditTax = Empty
    If Not IsMissing(vntSubTotal) Then vntSubTotal = Empty
    If Not IsMissing(vntTaxTotal) Then vntTaxTotal = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす個人請求書管理情報テーブルのレコードを取得
    strStmt = "SELECT PERBILL.DMDDATE,           PERBILL.BILLSEQ,            " & vbLf & _
              "       PERBILL.BRANCHNO,                                      " & vbLf & _
              "       PERBILL.DELFLG,            PERBILL.UPDDATE,            " & vbLf & _
              "       PERBILL.UPDUSER,           PERBILL.BILLCOMMENT,        " & vbLf & _
              "       PERBILL.PAYMENTDATE,       PERBILL.PAYMENTSEQ,         " & vbLf & _
              "       BASED_PERBILL_C.PRICE_ALL,                             " & vbLf & _
              "       BASED_PERBILL_C.EDITPRICE_ALL,                         " & vbLf & _
              "       BASED_PERBILL_C.TAXPRICE_ALL,                          " & vbLf & _
              "       BASED_PERBILL_C.EDITTAX_ALL,                           " & vbLf & _
              "       HAINSUSER.USERNAME                                     "

    strStmt = strStmt & vbLf & _
              "  FROM HAINSUSER, PERBILL,                                    " & vbLf & _
              "       (SELECT  PERBILL_C.DMDDATE,      PERBILL_C.BILLSEQ,    " & vbLf & _
              "                PERBILL_C.BRANCHNO,                           " & vbLf & _
              "                SUM(PERBILL_C.PRICE) PRICE_ALL,               " & vbLf & _
              "                SUM(PERBILL_C.EDITPRICE) EDITPRICE_ALL,       " & vbLf & _
              "                SUM(PERBILL_C.TAXPRICE) TAXPRICE_ALL,         " & vbLf & _
              "                SUM(PERBILL_C.EDITTAX) EDITTAX_ALL            " & vbLf & _
              "           FROM PERBILL_C, PERBILL_CSL                        " & vbLf & _
              "          WHERE PERBILL_CSL.RSVNO    = :RSVNO                 " & vbLf & _
              "            AND PERBILL_C.DMDDATE    = PERBILL_CSL.DMDDATE    " & vbLf & _
              "            AND PERBILL_C.BILLSEQ    = PERBILL_CSL.BILLSEQ    " & vbLf & _
              "            AND PERBILL_C.BRANCHNO   = PERBILL_CSL.BRANCHNO   " & vbLf & _
              "          GROUP BY PERBILL_C.DMDDATE,      PERBILL_C.BILLSEQ, " & vbLf & _
              "                   PERBILL_C.BRANCHNO                         " & vbLf & _
              "         ) BASED_PERBILL_C                                    "

    strStmt = strStmt & vbLf & _
              " WHERE PERBILL.DMDDATE      = BASED_PERBILL_C.DMDDATE         " & vbLf & _
              "   AND PERBILL.BILLSEQ      = BASED_PERBILL_C.BILLSEQ         " & vbLf & _
              "   AND PERBILL.BRANCHNO     = BASED_PERBILL_C.BRANCHNO        " & vbLf & _
              "   AND PERBILL.UPDUSER      = HAINSUSER.USERID(+)             "
    
    strStmt = strStmt & vbLf & _
              " ORDER BY PERBILL.DELFLG,           PERBILL.DMDDATE,          " & vbLf & _
              "          PERBILL.BILLSEQ,          PERBILL.BRANCHNO          "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDmdDate = objFields("DMDDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objDelflg = objFields("DELFLG")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objBillcomment = objFields("BILLCOMMENT")
        Set objPaymentDate = objFields("PAYMENTDATE")
        Set objPaymentSeq = objFields("PAYMENTSEQ")
        Set objPrice = objFields("PRICE_ALL")
        Set objEditPrice = objFields("EDITPRICE_ALL")
        Set objTaxPrice = objFields("TAXPRICE_ALL")
        Set objEditTax = objFields("EDITTAX_ALL")
        
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrDmdDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrDelflg(lngCount)
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrUserName(lngCount)
            ReDim Preserve vntArrBillcomment(lngCount)
            ReDim Preserve vntArrPaymentDate(lngCount)
            ReDim Preserve vntArrPaymentSeq(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrSubTotal(lngCount)
            ReDim Preserve vntArrTaxTotal(lngCount)
            
            vntArrDmdDate(lngCount) = objDmdDate.Value
            vntArrBillSeq(lngCount) = objBillSeq.Value
            vntArrBranchNo(lngCount) = objBranchNo.Value
            vntArrDelflg(lngCount) = objDelflg.Value
            vntArrUpdDate(lngCount) = objUpdDate.Value
            vntArrUpdUser(lngCount) = objUpdUser.Value
            vntArrUserName(lngCount) = objUserName.Value
            vntArrBillcomment(lngCount) = objBillcomment.Value
            vntArrPaymentDate(lngCount) = objPaymentDate.Value
            vntArrPaymentSeq(lngCount) = objPaymentSeq.Value
            vntArrPrice(lngCount) = objPrice.Value
            vntArrEditPrice(lngCount) = objEditPrice.Value
            vntArrTaxPrice(lngCount) = objTaxPrice.Value
            vntArrEditTax(lngCount) = objEditTax.Value
            vntArrSubTotal(lngCount) = CLng(vntArrPrice(lngCount)) + CLng(vntArrEditPrice(lngCount)) _
                                       + CLng(vntArrTaxPrice(lngCount)) + CLng(vntArrEditTax(lngCount))
            vntArrTaxTotal(lngCount) = CLng(vntArrTaxPrice(lngCount)) + CLng(vntArrEditTax(lngCount))

            lngCount = lngCount + 1
                        
            objOraDyna.MoveNext
        Loop

        SelectPerBill = lngCount
        
    End If
    

    '戻り値の設定
    If Not IsMissing(vntDmdDate) Then vntDmdDate = vntArrDmdDate
    If Not IsMissing(vntBillSeq) Then vntBillSeq = vntArrBillSeq
    If Not IsMissing(vntBranchNo) Then vntBranchNo = vntArrBranchNo
    If Not IsMissing(vntDelflg) Then vntDelflg = vntArrDelflg
    If Not IsMissing(vntUpdDate) Then vntUpdDate = vntArrUpdDate
    If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser
    If Not IsMissing(vntUserName) Then vntUserName = vntArrUserName
    If Not IsMissing(vntBillcomment) Then vntBillcomment = vntArrBillcomment
    If Not IsMissing(vntPaymentDate) Then vntPaymentDate = vntArrPaymentDate
    If Not IsMissing(vntPaymentSeq) Then vntPaymentSeq = vntArrPaymentSeq
    If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
    If Not IsMissing(vntEditPrice) Then vntEditPrice = vntArrEditPrice
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = vntArrTaxPrice
    If Not IsMissing(vntEditTax) Then vntEditTax = vntArrEditTax
    If Not IsMissing(vntSubTotal) Then vntSubTotal = vntArrSubTotal
    If Not IsMissing(vntTaxTotal) Then vntTaxTotal = vntArrTaxTotal


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerBill = 0

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerBill"
    
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
' 機能　　 : 請求書Ｎｏから個人請求書管理情報を取得する
'
' 引数　　 : (In)     vntDmdDate     請求日
' 　　　　   (In)     vntBillSeq     請求書Ｓｅｑ
' 　　　　   (In)     vntBranchNo    請求書枝番
' 　　　　   (Out)    vntDelflg      取消伝票フラグ
' 　　　　   (Out)    vntUpdDate     更新日時
' 　　　　   (Out)    vntUpdUser     ユーザＩＤ
' 　　　　   (Out)    vntUserName    ユーザ漢字氏名
' 　　　　   (Out)    vntBillcomment 請求書コメント
' 　　　　   (Out)    vntPaymentDate 入金日
' 　　　　   (Out)    vntPaymentSeq  入金Ｓｅｑ
' 　　　　   (Out)    vntPrice       金額（請求書合計）
' 　　　　   (Out)    vntEditPrice   調整金額（請求書合計）
' 　　　　   (Out)    vntTaxPrice    税額（請求書合計）
' 　　　　   (Out)    vntEditTax     調整税額（請求書合計）
' 　　　　   (Out)    vntSubTotal    小計（請求書合計）
' 　　　　   (Out)    vntTaxTotal    税合計（請求書合計）
' 　　　　   (Out)    vntPrintDate   領収書印刷日
' 　　　　   (Out)    vntBillName    請求宛先　　(2003.12.19 add)
' 　　　　   (Out)    vntKeishou     敬称　　　　(2003.12.19 add)
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPerBill_BillNo( _
    ByVal strDmdDate As Variant, _
    ByVal lngBillSeq As Variant, _
    ByVal lngBranchNo As Variant, _
    Optional ByRef vntDelflg As Variant, _
    Optional ByRef vntUpdDate As Variant, _
    Optional ByRef vntUpdUser As Variant, _
    Optional ByRef vntUserName As Variant, _
    Optional ByRef vntBillcomment As Variant, _
    Optional ByRef vntPaymentDate As Variant, _
    Optional ByRef vntPaymentSeq As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntEditPrice As Variant, _
    Optional ByRef vntTaxPrice As Variant, _
    Optional ByRef vntEditTax As Variant, _
    Optional ByRef vntSubTotal As Variant, _
    Optional ByRef vntTaxTotal As Variant, _
    Optional ByRef vntPrintDate As Variant, _
    Optional ByRef vntBillName As Variant, _
    Optional ByRef vntKeishou As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objDelflg       As OraField         '取消伝票フラグ
    Dim objUpdDate      As OraField         '更新日時
    Dim objUpdUser      As OraField         'ユーザＩＤ
    Dim objUserName     As OraField         'ユーザ漢字氏名
    Dim objBillcomment  As OraField         '請求書コメント
    Dim objPaymentDate  As OraField         '入金日
    Dim objPaymentSeq   As OraField         '入金Ｓｅｑ
    Dim objPrice        As OraField         '金額
    Dim objEditPrice    As OraField         '調整金額
    Dim objTaxPrice     As OraField         '税額
    Dim objEditTax      As OraField         '調整税額
    Dim objPrintDate    As OraField         '領収書印刷日
    ''' 2003.12.19 add start
    Dim objBillName     As OraField         '請求宛先
    Dim objKeishou      As OraField         '敬称
    ''' 2003.12.19 add end
    
    Dim lngPrice        As Long             '金額（小計、税合計計算用）
    Dim lngEditPrice    As Long             '調整金額（小計、税合計計算用）
    Dim lngTaxPrice     As Long             '税額（小計、税合計計算用）
    Dim lngEditTax      As Long             '調整税額（小計、税合計計算用）

    
    Dim lngCount      As Long             'カウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

'## 2003.12.20 Del By T.Takagi@FSIT
'MsgBox strDmdDate & " " & lngBillSeq & " " & lngBranchNo
'## 2003.12.20 Del End

    '初期処理
    If Not IsMissing(vntDelflg) Then vntDelflg = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUserName) Then vntUserName = Empty
    If Not IsMissing(vntBillcomment) Then vntBillcomment = Empty
    If Not IsMissing(vntPaymentDate) Then vntPaymentDate = Empty
    If Not IsMissing(vntPaymentSeq) Then vntPaymentSeq = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntEditPrice) Then vntEditPrice = Empty
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = Empty
    If Not IsMissing(vntEditTax) Then vntEditTax = Empty
    If Not IsMissing(vntSubTotal) Then vntSubTotal = Empty
    If Not IsMissing(vntTaxTotal) Then vntTaxTotal = Empty
    If Not IsMissing(vntPrintDate) Then vntPrintDate = Empty
    ''' 2003.12.19 add start
    If Not IsMissing(vntBillName) Then vntBillName = Empty
    If Not IsMissing(vntKeishou) Then vntKeishou = Empty
    ''' 2003.12.19 add end

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Trim(strDmdDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす個人請求書管理情報テーブルのレコードを取得
    ''' 宛先、敬称　追加 2003.12.19
    strStmt = "SELECT PERBILL.DELFLG,            PERBILL.UPDDATE,           " & vbLf & _
              "       PERBILL.UPDUSER,           PERBILL.BILLCOMMENT,       " & vbLf & _
              "       PERBILL.PAYMENTDATE,       PERBILL.PAYMENTSEQ,        " & vbLf & _
              "       PERBILL.PRINTDATE,                                    " & vbLf & _
              "       PERBILL.BILLNAME,          PERBILL.KEISHOU,           " & vbLf & _
              "       BASED_PERBILL_C.PRICE_ALL,                            " & vbLf & _
              "       BASED_PERBILL_C.EDITPRICE_ALL,                        " & vbLf & _
              "       BASED_PERBILL_C.TAXPRICE_ALL,                         " & vbLf & _
              "       BASED_PERBILL_C.EDITTAX_ALL,                          " & vbLf & _
              "       HAINSUSER.USERNAME                                    "

    strStmt = strStmt & vbLf & _
              "  FROM HAINSUSER, PERBILL,                                   " & vbLf & _
              "       (SELECT  PERBILL_C.DMDDATE,      PERBILL_C.BILLSEQ,   " & vbLf & _
              "                PERBILL_C.BRANCHNO,                          " & vbLf & _
              "                SUM(PERBILL_C.PRICE) PRICE_ALL,              " & vbLf & _
              "                SUM(PERBILL_C.EDITPRICE) EDITPRICE_ALL,      " & vbLf & _
              "                SUM(PERBILL_C.TAXPRICE) TAXPRICE_ALL,        " & vbLf & _
              "                SUM(PERBILL_C.EDITTAX) EDITTAX_ALL           " & vbLf & _
              "           FROM PERBILL_C                                    " & vbLf & _
              "          WHERE PERBILL_C.DMDDATE          = :DMDDATE        " & vbLf & _
              "            AND PERBILL_C.BILLSEQ          = :BILLSEQ        " & vbLf & _
              "            AND PERBILL_C.BRANCHNO         = :BRANCHNO       " & vbLf & _
              "          GROUP BY PERBILL_C.DMDDATE,      PERBILL_C.BILLSEQ," & vbLf & _
              "                   PERBILL_C.BRANCHNO                        " & vbLf & _
              "         ) BASED_PERBILL_C                                   "

    strStmt = strStmt & vbLf & _
              " WHERE PERBILL.DMDDATE(+)       = BASED_PERBILL_C.DMDDATE    " & vbLf & _
              "   AND PERBILL.BILLSEQ(+)       = BASED_PERBILL_C.BILLSEQ    " & vbLf & _
              "   AND PERBILL.BRANCHNO(+)      = BASED_PERBILL_C.BRANCHNO   " & vbLf & _
              "   AND PERBILL.UPDUSER          = HAINSUSER.USERID(+)        "
    

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDelflg = objFields("DELFLG")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objBillcomment = objFields("BILLCOMMENT")
        Set objPaymentDate = objFields("PAYMENTDATE")
        Set objPaymentSeq = objFields("PAYMENTSEQ")
        Set objPrice = objFields("PRICE_ALL")
        Set objEditPrice = objFields("EDITPRICE_ALL")
        Set objTaxPrice = objFields("TAXPRICE_ALL")
        Set objEditTax = objFields("EDITTAX_ALL")
        Set objPrintDate = objFields("PRINTDATE")
        ''' 2003.12.19 add start
        Set objBillName = objFields("BILLNAME")
        Set objKeishou = objFields("KEISHOU")
        ''' 2003.12.19 add end
        
            
        '戻り値の設定
        If Not IsMissing(vntDelflg) Then vntDelflg = objDelflg.Value
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value
        If Not IsMissing(vntUserName) Then vntUserName = objUserName.Value
        If Not IsMissing(vntBillcomment) Then vntBillcomment = objBillcomment.Value
        If Not IsMissing(vntPaymentDate) Then vntPaymentDate = objPaymentDate.Value
        If Not IsMissing(vntPaymentSeq) Then vntPaymentSeq = objPaymentSeq.Value
        If Not IsMissing(vntPrintDate) Then vntPrintDate = objPrintDate.Value
        ''' 2003.12.19 add start
        If Not IsMissing(vntBillName) Then vntBillName = "" & objBillName.Value
        If Not IsMissing(vntKeishou) Then vntKeishou = "" & objKeishou.Value
        ''' 2003.12.19 add end
        If Not IsMissing(vntPrice) Then vntPrice = objPrice.Value
        lngPrice = objPrice.Value

        If Not IsMissing(vntEditPrice) Then vntEditPrice = objEditPrice.Value
        lngEditPrice = objEditPrice.Value

        If Not IsMissing(vntTaxPrice) Then vntTaxPrice = objTaxPrice.Value
        lngTaxPrice = objTaxPrice.Value

        If Not IsMissing(vntEditTax) Then vntEditTax = objEditTax.Value
        lngEditTax = objEditTax.Value

        If Not IsMissing(vntSubTotal) Then
            vntSubTotal = CLng(lngPrice) + CLng(lngEditPrice) _
                                       + CLng(lngTaxPrice) + CLng(lngEditTax)
        End If

        If Not IsMissing(vntTaxTotal) Then
            vntTaxTotal = CLng(lngTaxPrice) + CLng(lngEditTax)
        End If

        SelectPerBill_BillNo = True
        
    End If
    
'## 2003.12.20 Del By T.Takagi@FSIT
'MsgBox vntPaymentDate & " " & vntPaymentSeq
'## 2003.12.20 Del End

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
        
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerBill_BillNo = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerBill_BillNo"
    
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
' 機能　　 : 入金Ｎｏから請求書Ｎｏを取得する
'
' 引数　　 : (In)    vntPaymentDate 入金日
' 　　　　   (In)    vntPaymentSeq  入金Ｓｅｑ
' 　　　　   (Out)   vntDmdDate     請求日
' 　　　　   (Out)   vntBillSeq     請求書Ｓｅｑ
' 　　　　   (Out)   vntBranchNo    請求書枝番
' 　　　　   (Out)   vntLastName    姓 (2003.12.18 add)
' 　　　　   (Out)   vntFirstName   名 (2003.12.18 add)
'
' 戻り値　 : 正値   レコードあり
' 　　　　   負値  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectBillNo_Payment( _
    ByVal strPaymentDate As Variant, _
    ByVal lngPaymentSeq As Variant, _
    ByRef vntDmdDate As Variant, _
    ByRef vntBillSeq As Variant, _
    ByRef vntBranchNo As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objDmdDate      As OraField         '請求日
    Dim objBillSeq      As OraField         '請求書Ｓｅｑ
    Dim objBranchNo     As OraField         '請求書枝番
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    
    Dim vntArrDmdDate()      As Variant         '請求日の配列
    Dim vntArrBillSeq()      As Variant         '請求書Ｓｅｑの配列
    Dim vntArrBranchNo()     As Variant         '請求書枝番の配列
    Dim vntArrLastName()     As Variant         '姓の配列
    Dim vntArrFirstName()    As Variant         '名の配列
    
    Dim lngCount      As Long             'カウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntDmdDate = Empty
    vntBillSeq = Empty
    vntBranchNo = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty


    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PAYMENTDATE", Trim(strPaymentDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PAYMENTSEQ", lngPaymentSeq, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす個人請求書Noを取得
    '名前も取得するように修正 2003.12.18 modify start by FFCS
'    strStmt = "SELECT PERBILL.DMDDATE,      PERBILL.BILLSEQ, " & vbLf & _
'              "       PERBILL.BRANCHNO                       "

'    strStmt = strStmt & vbLf & _
'              "  FROM PERBILL                                " & vbLf & _
'              " WHERE PERBILL.PAYMENTDATE = :PAYMENTDATE     " & vbLf & _
'              "   AND PERBILL.PAYMENTSEQ  = :PAYMENTSEQ      "
    strStmt = "SELECT DISTINCT                               " & vbLf & _
              "       DMDVIEW.DMDDATE,     DMDVIEW.BILLSEQ,  " & vbLf & _
              "       DMDVIEW.BRANCHNO,                      " & vbLf & _
              "       DMDVIEW.LASTNAME,    DMDVIEW.FIRSTNAME "

    '受信情報がある場合
    strStmt = strStmt & vbLf & _
              "  FROM  (" & vbLf & _
              "        (SELECT PERBILL.DMDDATE,      PERBILL.BILLSEQ,      " & vbLf & _
              "                PERBILL.BRANCHNO,                           " & vbLf & _
              "                PERSON.LASTNAME,      PERSON.FIRSTNAME      " & vbLf & _
              "           FROM PERBILL, PERBILL_CSL, CONSULT, PERSON       " & vbLf & _
              "          WHERE PERBILL.PAYMENTDATE  = :PAYMENTDATE         " & vbLf & _
              "            AND PERBILL.PAYMENTSEQ   = :PAYMENTSEQ          " & vbLf & _
              "            AND PERBILL_CSL.DMDDATE  = PERBILL.DMDDATE      " & vbLf & _
              "            AND PERBILL_CSL.BILLSEQ  = PERBILL.BILLSEQ      " & vbLf & _
              "            AND PERBILL_CSL.BRANCHNO = PERBILL.BRANCHNO     " & vbLf & _
              "            AND CONSULT.RSVNO        = PERBILL_CSL.RSVNO    " & vbLf & _
              "            AND PERSON.PERID         = CONSULT.PERID        " & vbLf & _
              "        ) UNION                                             "
    '受信情報が無い場合
    strStmt = strStmt & vbLf & _
             "         (SELECT PERBILL.DMDDATE,     PERBILL.BILLSEQ,           " & vbLf & _
              "                PERBILL.BRANCHNO,                               " & vbLf & _
              "                PERSON.LASTNAME,      PERSON.FIRSTNAME          " & vbLf & _
              "           FROM PERBILL, PERBILL_PERSON, PERSON                 " & vbLf & _
              "          WHERE PERBILL.PAYMENTDATE     = :PAYMENTDATE          " & vbLf & _
              "            AND PERBILL.PAYMENTSEQ      = :PAYMENTSEQ           " & vbLf & _
              "            AND PERBILL_PERSON.DMDDATE  = PERBILL.DMDDATE       " & vbLf & _
              "            AND PERBILL_PERSON.BILLSEQ  = PERBILL.BILLSEQ       " & vbLf & _
              "            AND PERBILL_PERSON.BRANCHNO = PERBILL.BRANCHNO      " & vbLf & _
              "            AND PERSON.PERID            = PERBILL_PERSON.PERID  " & vbLf & _
              "        )) DMDVIEW                                              "
    '名前も取得するように修正 2003.12.18 modify END by FFCS
    

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDmdDate = objFields("DMDDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
            
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrDmdDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            
            vntArrDmdDate(lngCount) = objDmdDate.Value
            vntArrBillSeq(lngCount) = objBillSeq.Value
            vntArrBranchNo(lngCount) = objBranchNo.Value
            vntArrLastName(lngCount) = objLastName.Value
            vntArrFirstName(lngCount) = objFirstName.Value
            
            lngCount = lngCount + 1
                        
            objOraDyna.MoveNext
        Loop
        
    End If
        
    vntDmdDate = vntArrDmdDate
    vntBillSeq = vntArrBillSeq
    vntBranchNo = vntArrBranchNo
    If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
    If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        
    SelectBillNo_Payment = lngCount
        
    

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
        
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectBillNo_Payment = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectBillNo_Payment"
    
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
' 機能　　 : 請求書Ｎｏをキーに請求書の取消を行う
'
' 引数　　 : (In)     strDmdDate     請求日
' 　　　　   (In)     lngBillSeq     請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo    請求書枝番
' 　　　　   (In)     strUserId      更新者ＩＤ
'
' 戻り値　 : True      レコードあり
' 　　　　   False     レコードなし、または異常終了
'
' 備考　　 :
'
Public Function DeletePerBill( _
    ByVal strDmdDate As Variant, _
    ByVal lngBillSeq As Variant, _
    ByVal lngBranchNo As Variant, _
    ByVal strUserId As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPaymentDate  As OraField         '入金日
    Dim objPaymentSeq   As OraField         '入金Ｓｅｑ
    
    Dim strPaymentDate  As String           '入金日
    Dim lngPaymentSeq   As Long             '入金Ｓｅｑ
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    objOraParam.Add "DMDDATE", Trim(strDmdDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '請求書取消ストアド呼び出し
    mobjOraDb.ExecuteSQL "BEGIN :RET := DemandPackage.DeletePerBill(:DMDDATE,:BILLSEQ,:BRANCHNO,:USERID ); END;"

        
    '戻り値の設定
    DeletePerBill = True
        

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
        
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeletePerBill = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeletePerBill"
    
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
' 機能　　 : 検索条件に従い個人請求書一覧を抽出する
'
' 引数　　 : (In)     vntSortKind         ソート種別
'                                         0:請求書No
' 　　　　   (In)     vntSortMode         ソートモード
'                                         0:昇順　1:降順
' 　　　　   (In)     vntPaymenflg        1:未収のみ 0:全て
' 　　　　   (In)     vntDelDisp          1:取消伝票除く 0:全て
' 　　　　   (In)     vntKey              検索キー(空白で分割後のキー）
' 　　　　   (In)     vntStartDmdDate     検索条件請求日（開始）
' 　　　　   (In)     vntEndDmdDate       検索条件請求日（終了）
' 　　　　   (In)     vntSearchOrg1       検索条件団体コード１
' 　　　　   (In)     vntSearchOrg2       検索条件団体コード２
' 　　　　   (In)     vntSearchPer        検索条件個人ＩＤ
' 　　　　   (In)     vntSearchDmdDate    検索条件請求日
' 　　　　   (In)     vntSearchBillSeq    検索条件請求書Ｓｅｑ
' 　　　　   (In)     vntSearchBranchNo   検索条件請求書枝番
' 　　　　   (Out)    vntDmdDate          請求日
' 　　　　   (Out)    vntBillSeq          請求書Ｓｅｑ
' 　　　　   (Out)    vntBranchNo         請求書枝番
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntCsCd             コースコード
' 　　　　   (Out)    vntCsName           コース名
' 　　　　   (Out)    vntWebColor         コース色
' 　　　　   (Out)    vntPerId            個人ＩＤ
' 　　　　   (Out)    vntLastName         姓
' 　　　　   (Out)    vntFirstName        名
' 　　　　   (Out)    vntLastKName        カナ姓
' 　　　　   (Out)    vntFirstKName       カナ名
' 　　　　   (Out)    vntAge       　　　　年齢
' 　　　　   (Out)    vntGender           性別
' 　　　　   (Out)    vntPerCount         受信者数
' 　　　　   (Out)    vntOrgSName         団体略称
' 　　　　   (Out)    vntOrgKName         団体カナ名
' 　　　　   (Out)    vntPrice            金額合計
' 　　　　   (Out)    vntTax              税金合計
' 　　　　   (Out)    vntTotalPrice       請求金額合計
' 　　　　   (Out)    vntPaymentDate      入金日
' 　　　　   (Out)    vntPaymentSeq       入金Ｓｅｑ
' 　　　　   (Out)    vntDelflg           取消伝票フラグ
' 　　　　   (In)     lngStartPos           取得開始位置
' 　　　　   (In)     lngPageMaxLine        １ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
' 　　　　   (Out)    vntDayId            当日ID
'### 2004/9/29 Updated ENd
'
' 戻り値　 : 正値   抽出件数
' 　　　　   ０  　 レコードなし
' 　　　　   負値   異常終了
'
' 備考　　 :
'
Public Function SelectListPerBill( _
    ByVal vntSortKind As Variant, ByVal vntSortMode As Variant, _
    ByVal vntPaymentflg As Variant, ByVal vntDelDisp As Variant, _
    ByVal vntKey As Variant, ByVal vntStartDmdDate As Variant, ByVal vntEndDmdDate As Variant, _
    ByVal vntSearchOrg1 As Variant, ByVal vntSearchOrg2 As Variant, _
    ByVal vntSearchPer As Variant, _
    ByVal vntSearchDmdDate As Variant, ByVal vntSearchBillSeq As Variant, _
    ByVal vntSearchBranchNo As Variant, _
    Optional ByRef vntDmdDate As Variant, Optional ByRef vntBillSeq As Variant, _
    Optional ByRef vntBranchNo As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCsCd As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntPerID As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntAge As Variant, Optional ByRef vntGender As Variant, _
    Optional ByRef vntPerCount As Variant, _
    Optional ByRef vntOrgSName As Variant, Optional ByRef vntOrgKName As Variant, _
    Optional ByRef vntPrice As Variant, Optional ByRef vntTax As Variant, _
    Optional ByRef vntTotalPrice As Variant, _
    Optional ByRef vntPaymentDate As Variant, Optional ByRef vntPaymentSeq As Variant, _
    Optional ByRef vntDelflg As Variant, Optional ByRef lngStartPos As Variant = 1, _
    Optional ByRef lngPageMaxLine As Variant = 0, Optional ByRef vntDayId As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    Dim strstmt2        As String           'SQLステートメント
    Dim strStmt_count   As String           'SQLステートメント
    Dim strStmt_data    As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objDmdDate      As OraField         '請求日
    Dim objBillSeq      As OraField         '請求書Ｓｅｑ
    Dim objBranchNo     As OraField         '請求書枝番
    Dim objRsvNo        As OraField         '予約番号
    Dim objCsCd         As OraField         'コースコード
    Dim objCsName       As OraField         'コース名
    Dim objWebColor     As OraField         'コース色
    Dim objPerID        As OraField         '個人ＩＤ
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objAge          As OraField         '年齢
    Dim objGender       As OraField         '性別
    Dim objPerCount     As OraField         '受信者数
    Dim objOrgSName     As OraField         '団体略称
    Dim objOrgKName     As OraField         '団体カナ名
    Dim objPrice        As OraField         '金額合計
    Dim objTax          As OraField         '税金合計
    Dim objTotalPrice   As OraField         '請求金額合計
    Dim objPaymentDate  As OraField         '入金日
    Dim objPaymentSeq   As OraField         '入金Ｓｅｑ
    Dim objDelflg       As OraField         '取消伝票フラグ
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
    Dim objDayId        As OraField         '当日ID
'### 2004/9/29 Updated End
    
    Dim vntArrDmdDate()      As Variant         '請求日の配列
    Dim vntArrBillSeq()      As Variant         '請求書Ｓｅｑの配列
    Dim vntArrBranchNo()     As Variant         '請求書枝番の配列
    Dim vntArrRsvNo()        As Variant         '予約番号の配列
    Dim vntArrCsCd()         As Variant         'コースコードの配列
    Dim vntArrCsName()       As Variant         'コース名の配列
    Dim vntArrWebColor()     As Variant         'コース色の配列
    Dim vntArrPerID()        As Variant         '個人ＩＤの配列
    Dim vntArrLastName()     As Variant         '姓の配列
    Dim vntArrFirstName()    As Variant         '名の配列
    Dim vntArrLastKName()    As Variant         'カナ姓の配列
    Dim vntArrFirstKName()   As Variant         'カナ名の配列
    Dim vntArrAge()          As Variant         '年齢の配列
    Dim vntArrGender()       As Variant         '性別の配列
    Dim vntArrPerCount()     As Variant         '受信者数の配列
    Dim vntArrOrgSName()     As Variant         '団体略称の配列
    Dim vntArrOrgKName()     As Variant         '団体カナ名の配列
    Dim vntArrPrice()        As Variant         '金額合計の配列
    Dim vntArrTax()          As Variant         '税金合計の配列
    Dim vntArrTotalPrice()   As Variant         '請求金額合計の配列
    Dim vntArrPaymentDate()  As Variant         '入金日の配列
    Dim vntArrPaymentSeq()   As Variant         '入金Ｓｅｑの配列
    Dim vntArrDelflg()       As Variant         '取消伝票フラグの配列
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
    Dim vntArrDayId()        As Variant         '当日IDの配列
'### 2004/9/29 Updated End
        
    
    Dim lngAllCount   As Long             '全件数
    Dim lngCount      As Long             'カウンタ

    Dim blnAns          As Boolean
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle


    '初期処理
    If Not IsMissing(vntDmdDate) Then vntDmdDate = Empty
    If Not IsMissing(vntBillSeq) Then vntBillSeq = Empty
    If Not IsMissing(vntBranchNo) Then vntBranchNo = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntPerID) Then vntPerID = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntPerCount) Then vntPerCount = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntOrgKName) Then vntOrgKName = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntTax) Then vntTax = Empty
    If Not IsMissing(vntTotalPrice) Then vntTotalPrice = Empty
    If Not IsMissing(vntPaymentDate) Then vntPaymentDate = Empty
    If Not IsMissing(vntPaymentSeq) Then vntPaymentSeq = Empty
    If Not IsMissing(vntDelflg) Then vntDelflg = Empty
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
    If Not IsMissing(vntDayId) Then vntDayId = Empty
'### 2004/9/29 Updated End
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    '## ページングナビ対応 2004.01.04 start
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngPageMaxLine > 0 Then
        objOraParam.Add "ENDPOS", (CLng(lngStartPos) + CLng(lngPageMaxLine) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    '## ページングナビ対応 2004.01.04 end

    '## ページングナビ対応 2004.01.04 start
    '検索条件を満たす個人請求書データ件数を取得
    strStmt_count = _
              "SELECT COUNT(*)                                   "
              
    '検索条件を満たす個人請求書データを取得
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
'    strStmt_data = _
'              "SELECT FINALLISTVIEW2.DMDDATE,     FINALLISTVIEW2.BILLSEQ,    " & vbLf & _
'              "       FINALLISTVIEW2.BRANCHNO,    FINALLISTVIEW2.RSVNO,      " & vbLf & _
'              "       FINALLISTVIEW2.CSCD,        FINALLISTVIEW2.CSNAME,     " & vbLf & _
'              "       FINALLISTVIEW2.WEBCOLOR,                               " & vbLf & _
'              "       FINALLISTVIEW2.PERID,                                  " & vbLf & _
'              "       FINALLISTVIEW2.LASTNAME,    FINALLISTVIEW2.FIRSTNAME,  " & vbLf & _
'              "       FINALLISTVIEW2.LASTKNAME,   FINALLISTVIEW2.FIRSTKNAME, " & vbLf & _
'              "       FINALLISTVIEW2.AGE,         FINALLISTVIEW2.GENDER,     " & vbLf & _
'              "       FINALLISTVIEW2.PERCOUNT,                               " & vbLf & _
'              "       FINALLISTVIEW2.ORGSNAME,    FINALLISTVIEW2.ORGKNAME,   " & vbLf & _
'              "       FINALLISTVIEW2.PRICE,                                  " & vbLf & _
'              "       FINALLISTVIEW2.TAX,         FINALLISTVIEW2.TOTALPRICE, " & vbLf & _
'              "       FINALLISTVIEW2.PAYMENTDATE, FINALLISTVIEW2.PAYMENTSEQ, " & vbLf & _
'              "       FINALLISTVIEW2.DELFLG                                  "
    '検索条件を満たす個人請求書データを取得
    strStmt_data = _
              "SELECT FINALLISTVIEW2.DMDDATE,     FINALLISTVIEW2.BILLSEQ,    " & vbLf & _
              "       FINALLISTVIEW2.BRANCHNO,    FINALLISTVIEW2.RSVNO,      " & vbLf & _
              "       FINALLISTVIEW2.CSCD,        FINALLISTVIEW2.CSNAME,     " & vbLf & _
              "       FINALLISTVIEW2.WEBCOLOR,                               " & vbLf & _
              "       FINALLISTVIEW2.PERID,                                  " & vbLf & _
              "       FINALLISTVIEW2.LASTNAME,    FINALLISTVIEW2.FIRSTNAME,  " & vbLf & _
              "       FINALLISTVIEW2.LASTKNAME,   FINALLISTVIEW2.FIRSTKNAME, " & vbLf & _
              "       FINALLISTVIEW2.AGE,         FINALLISTVIEW2.GENDER,     " & vbLf & _
              "       FINALLISTVIEW2.PERCOUNT,                               " & vbLf & _
              "       FINALLISTVIEW2.ORGSNAME,    FINALLISTVIEW2.ORGKNAME,   " & vbLf & _
              "       FINALLISTVIEW2.PRICE,                                  " & vbLf & _
              "       FINALLISTVIEW2.TAX,         FINALLISTVIEW2.TOTALPRICE, " & vbLf & _
              "       FINALLISTVIEW2.PAYMENTDATE, FINALLISTVIEW2.PAYMENTSEQ, " & vbLf & _
              "       FINALLISTVIEW2.DELFLG,                                 " & vbLf & _
              "       (SELECT DAYID FROM RECEIPT WHERE RECEIPT.RSVNO = FINALLISTVIEW2.RSVNO) DAYID"
'### 2004/9/30 Updated End
    
    strStmt_data = strStmt_data & vbLf & _
              "FROM(                                                       " & vbLf & _
              "SELECT ROWNUM SEQ,                                          " & vbLf & _
              "       FINALLISTVIEW.DMDDATE,     FINALLISTVIEW.BILLSEQ,    " & vbLf & _
              "       FINALLISTVIEW.BRANCHNO,    FINALLISTVIEW.RSVNO,      " & vbLf & _
              "       FINALLISTVIEW.CSCD,        FINALLISTVIEW.CSNAME,     " & vbLf & _
              "       FINALLISTVIEW.WEBCOLOR,                              " & vbLf & _
              "       FINALLISTVIEW.PERID,                                 " & vbLf & _
              "       FINALLISTVIEW.LASTNAME,    FINALLISTVIEW.FIRSTNAME,  " & vbLf & _
              "       FINALLISTVIEW.LASTKNAME,   FINALLISTVIEW.FIRSTKNAME, " & vbLf & _
              "       FINALLISTVIEW.AGE,         FINALLISTVIEW.GENDER,     " & vbLf & _
              "       FINALLISTVIEW.PERCOUNT,                              " & vbLf & _
              "       FINALLISTVIEW.ORGSNAME,    FINALLISTVIEW.ORGKNAME,   " & vbLf & _
              "       FINALLISTVIEW.PRICE,                                 " & vbLf & _
              "       FINALLISTVIEW.TAX,         FINALLISTVIEW.TOTALPRICE, " & vbLf & _
              "       FINALLISTVIEW.PAYMENTDATE, FINALLISTVIEW.PAYMENTSEQ, " & vbLf & _
              "       FINALLISTVIEW.DELFLG                                 "
    '## ページングナビ対応 2004.01.04 end
              
    strStmt = "FROM(                                             " & vbLf & _
              "SELECT LISTVIEW.DMDDATE,     LISTVIEW.BILLSEQ,    " & vbLf & _
              "       LISTVIEW.BRANCHNO,    LISTVIEW.RSVNO,      " & vbLf & _
              "       LISTVIEW.CSCD,        LISTVIEW.CSNAME,     " & vbLf & _
              "       LISTVIEW.WEBCOLOR,                         " & vbLf & _
              "       LISTVIEW.PERID,                            " & vbLf & _
              "       LISTVIEW.LASTNAME,    LISTVIEW.FIRSTNAME,  " & vbLf & _
              "       LISTVIEW.LASTKNAME,   LISTVIEW.FIRSTKNAME, " & vbLf & _
              "       LISTVIEW.AGE,         LISTVIEW.GENDER,     " & vbLf & _
              "       LISTVIEW.PERCOUNT,                         " & vbLf & _
              "       LISTVIEW.ORGSNAME,    LISTVIEW.ORGKNAME,   " & vbLf & _
              "       LISTVIEW.PRICE,                            " & vbLf & _
              "       LISTVIEW.TAX,         LISTVIEW.TOTALPRICE, " & vbLf & _
              "       LISTVIEW.PAYMENTDATE, LISTVIEW.PAYMENTSEQ, " & vbLf & _
              "       LISTVIEW.DELFLG                            "

    '検索条件が請求書Ｎｏ？
    If IsNull(vntSearchDmdDate) = False And IsNull(vntSearchBillSeq) = False And _
       IsNull(vntSearchBranchNo) = False And _
       vntSearchDmdDate <> "" And vntSearchBillSeq <> "" And vntSearchBranchNo <> "" Then
        blnAns = SetPerBillViewSql(objOraParam, strstmt2, vntPaymentflg, vntDelDisp, "", "", vntSearchDmdDate, vntSearchBillSeq, vntSearchBranchNo)

    Else
        '検索条件が団体コード？
        If (IsNull(vntSearchOrg1) = False And IsNull(vntSearchOrg2) = False) And _
            (vntSearchOrg1 <> "" And vntSearchOrg2 <> "") Then
               blnAns = SetOrgViewSql(objOraParam, strstmt2, vntPaymentflg, vntDelDisp, vntSearchPer, vntSearchOrg1, vntSearchOrg2, vntStartDmdDate, vntEndDmdDate)
        Else
            '検索条件が検索キー または個人ＩＤ？
            If vntKey(0) <> "" Or _
              (IsNull(vntSearchPer) = False And vntSearchPer <> "") Then
                blnAns = SetPersonViewSql(objOraParam, strstmt2, vntPaymentflg, vntDelDisp, vntKey, vntSearchPer, vntStartDmdDate, vntEndDmdDate)
            Else
            'その他
                blnAns = SetPerBillViewSql(objOraParam, strstmt2, vntPaymentflg, vntDelDisp, vntStartDmdDate, vntEndDmdDate, "", "", "")
            End If
        End If
    End If
    
    strStmt = strStmt & vbLf & strstmt2

    'ソート
    Select Case vntSortKind
    '請求書No順
    Case 0
        Select Case vntSortMode
        Case 0
            strStmt = strStmt & vbLf & _
                " ORDER BY LISTVIEW.DMDDATE DESC, LISTVIEW.BILLSEQ ASC, " & vbLf & _
                "          LISTVIEW.BRANCHNO ASC, LISTVIEW.DELFLG ASC   "
        Case 1
            strStmt = strStmt & vbLf & _
                " ORDER BY LISTVIEW.DMDDATE ASC,    LISTVIEW.BILLSEQ DESC,  " & vbLf & _
                "          LISTVIEW.BRANCHNO DESC , LISTVIEW.DELFLG DESC    "
        End Select

    End Select
    
    strStmt = strStmt & vbLf & ") FINALLISTVIEW  "
    
    '全件数取得
    strStmt_count = strStmt_count & strStmt
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt_count), ORADYN_READONLY + ORADYN_NOCACHE)
        
    lngAllCount = objOraDyna.Fields(0).Value

    strStmt = strStmt & vbLf & ") FINALLISTVIEW2  "
    '取得件数で絞込み
    strStmt = strStmt & vbLf & _
              "  WHERE FINALLISTVIEW2.SEQ >= :STARTPOS "
    If lngPageMaxLine > 0 Then
        strStmt = strStmt & vbLf & _
              "    AND FINALLISTVIEW2.SEQ <= :ENDPOS "
    End If
      
    'データ取得
    strStmt_data = strStmt_data & vbLf & strStmt
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt_data), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDmdDate = objFields("DMDDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objRsvNo = objFields("RSVNO")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objWebColor = objFields("WEBCOLOR")
        Set objPerID = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objAge = objFields("AGE")
        Set objGender = objFields("GENDER")
        Set objPerCount = objFields("PERCOUNT")
        Set objOrgSName = objFields("ORGSNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objPrice = objFields("PRICE")
        Set objTax = objFields("TAX")
        Set objTotalPrice = objFields("TOTALPRICE")
        Set objPaymentDate = objFields("PAYMENTDATE")
        Set objPaymentSeq = objFields("PAYMENTSEQ")
        Set objDelflg = objFields("DELFLG")
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
        Set objDayId = objFields("DAYID")
'### 2004/9/29 Updated End
        
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrDmdDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrPerID(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrPerCount(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrOrgKName(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrTotalPrice(lngCount)
            ReDim Preserve vntArrPaymentDate(lngCount)
            ReDim Preserve vntArrPaymentSeq(lngCount)
            ReDim Preserve vntArrDelflg(lngCount)
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
            ReDim Preserve vntArrDayId(lngCount)
'### 2004/9/29 Updated End
            
            vntArrDmdDate(lngCount) = objDmdDate.Value
            vntArrBillSeq(lngCount) = objBillSeq.Value
            vntArrBranchNo(lngCount) = objBranchNo.Value
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrCsCd(lngCount) = objCsCd.Value
            vntArrCsName(lngCount) = objCsName.Value
            vntArrWebColor(lngCount) = objWebColor.Value
            vntArrPerID(lngCount) = objPerID.Value
            vntArrLastName(lngCount) = objLastName.Value
            vntArrFirstName(lngCount) = objFirstName.Value
            vntArrLastKName(lngCount) = objLastKName.Value
            vntArrFirstKName(lngCount) = objFirstKName.Value
            vntArrAge(lngCount) = objAge.Value
            vntArrGender(lngCount) = objGender.Value
            vntArrPerCount(lngCount) = objPerCount.Value
            vntArrOrgSName(lngCount) = objOrgSName.Value
            vntArrOrgKName(lngCount) = objOrgKName.Value
            vntArrPrice(lngCount) = objPrice.Value
            vntArrTax(lngCount) = objTax.Value
            If IsNull(objTotalPrice.Value) = False Then
                vntArrTotalPrice(lngCount) = objTotalPrice.Value
            Else
                vntArrTotalPrice(lngCount) = 0
            End If
            If IsNull(objPaymentDate.Value) = False Then
                vntArrPaymentDate(lngCount) = objPaymentDate.Value
            End If
            If IsNull(objPaymentSeq.Value) = False Then
                vntArrPaymentSeq(lngCount) = objPaymentSeq.Value
            End If
            vntArrDelflg(lngCount) = objDelflg.Value
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
            vntArrDayId(lngCount) = objDayId.Value
'### 2004/9/29 Updated End

            lngCount = lngCount + 1
                        
            objOraDyna.MoveNext
        Loop

        
    End If
    
'### 2004/1/4 Deleted by Ishihara@FSIT 藤井さんお仕置きです。
'MsgBox lngCount
'### 2004/1/4 Deleted End
    
    '戻り値の設定
    SelectListPerBill = lngAllCount
    
    If Not IsMissing(vntDmdDate) Then vntDmdDate = vntArrDmdDate
    If Not IsMissing(vntBillSeq) Then vntBillSeq = vntArrBillSeq
    If Not IsMissing(vntBranchNo) Then vntBranchNo = vntArrBranchNo
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
    If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
    If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
    If Not IsMissing(vntPerID) Then vntPerID = vntArrPerID
    If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
    If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
    If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
    If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
    If Not IsMissing(vntAge) Then vntAge = vntArrAge
    If Not IsMissing(vntGender) Then vntGender = vntArrGender
    If Not IsMissing(vntPerCount) Then vntPerCount = vntArrPerCount
    If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
    If Not IsMissing(vntOrgKName) Then vntOrgKName = vntArrOrgKName
    If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
    If Not IsMissing(vntTax) Then vntTax = vntArrTax
    If Not IsMissing(vntTotalPrice) Then vntTotalPrice = vntArrTotalPrice
    If Not IsMissing(vntPaymentDate) Then vntPaymentDate = vntArrPaymentDate
    If Not IsMissing(vntPaymentSeq) Then vntPaymentSeq = vntArrPaymentSeq
    If Not IsMissing(vntDelflg) Then vntDelflg = vntArrDelflg
'### 2004/9/29 Updated by FSIT)Gouda 個人請求書の検索画面に当日IDを表示する
    If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
'### 2004/9/29 Updated End


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectListPerBill = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectListPerBill"
    
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
' 機能　　 : 請求書Ｎｏから個人請求明細情報を取得する
'
' 引数　　 : (In)     strDmdDate     請求日
' 　　　　   (In)     lngBillSeq     請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo    請求書枝番
' 　　　　   (Out)    vntBillLineNo  請求明細行No
' 　　　　   (Out)    vntPrice       金額
' 　　　　   (Out)    vntEditPrice   調整金額
' 　　　　   (Out)    vntTaxPrice    税額
' 　　　　   (Out)    vntEditTax     調整税額
' 　　　　   (Out)    vntCtrPtCd     契約パターンコード
' 　　　　   (Out)    vntOptCd       オプションコード
' 　　　　   (Out)    vntOptBranchNo オプション枝番
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntPriceSeq    受信金額ＳＥＱ
' 　　　　   (Out)    vntLineName    明細名称
' 　　　　   (Out)    vntOtherLineDivCd セット外明細コード
' 　　　　   (Out)    vntOtherLineDivName セット外明細名
' 　　　　   (Out)    vntLastName     受診者名　姓
' 　　　　   (Out)    vntFirstName     受診者名　姓
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPerBill_c( _
    ByVal strDmdDate As String, _
    ByVal lngBillSeq As Long, _
    ByVal lngBranchNo As Long, _
    Optional ByRef vntBillLineNo As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntEditPrice As Variant, _
    Optional ByRef vntTaxPrice As Variant, _
    Optional ByRef vntEditTax As Variant, _
    Optional ByRef vntCtrPtCd As Variant, _
    Optional ByRef vntOptCd As Variant, _
    Optional ByRef vntOptBranchNo As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntPriceSeq As Variant, _
    Optional ByRef vntLineName As Variant, _
    Optional ByRef vntOtherLineDivCd As Variant, _
    Optional ByRef vntOtherLineDivName As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objBillLineNo   As OraField         '請求明細行No
    Dim objPrice        As OraField         '金額
    Dim objEditPrice    As OraField         '調整金額
    Dim objTaxPrice     As OraField         '税額
    Dim objEditTax      As OraField         '調整税額
    Dim objCtrPtCd      As OraField         '契約パターンコード
    Dim objOptCd        As OraField         'オプションコード
    Dim objOptBranchNo  As OraField         'オプション枝番
    Dim objRsvNo        As OraField         '予約番号
    Dim objPriceSeq     As OraField         '受信金額ＳＥＱ
    Dim objLineName     As OraField         '明細名称
    Dim objOtherLineDivCd  As OraField         'セット外明細コード
    Dim objOtherLineDivName  As OraField       'セット外明細名
    Dim objLastName     As OraField         '受診者名　姓
    Dim objFirstName    As OraField         '受診者名　名
    
    Dim vntArrBillLineNo()      As Variant         '請求明細行Noの配列
    Dim vntArrPrice()           As Variant         '金額の配列
    Dim vntArrEditPrice()       As Variant         '調整金額の配列
    Dim vntArrTaxPrice()        As Variant         '税額の配列
    Dim vntArrEditTax()         As Variant         '調整税額の配列
    Dim vntArrCtrPtCd()         As Variant         '契約パターンコードの配列
    Dim vntArrOptCd()           As Variant         'オプションコードの配列
    Dim vntArrOptBranchNo()     As Variant         'オプション枝番の配列
    Dim vntArrRsvNo()           As Variant         '予約番号の配列
    Dim vntArrPriceSeq()        As Variant         '受信金額ＳＥＱの配列
    Dim vntArrLineName()        As Variant         '明細名称の配列
    Dim vntArrOtherLineDivCd()     As Variant         'セット外明細コードの配列
    Dim vntArrOtherLineDivName()   As Variant         'セット外明細名の配列
    Dim vntArrLastName()        As Variant         '受診者名　姓の配列
    Dim vntArrFirstName()       As Variant         '受診者名　名の配列
    
    Dim lngCount      As Long             'カウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntBillLineNo) Then vntBillLineNo = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntEditPrice) Then vntEditPrice = Empty
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = Empty
    If Not IsMissing(vntEditTax) Then vntEditTax = Empty
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
    If Not IsMissing(vntOptCd) Then vntOptCd = Empty
    If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntPriceSeq) Then vntPriceSeq = Empty
    If Not IsMissing(vntLineName) Then vntLineName = Empty
    If Not IsMissing(vntOtherLineDivCd) Then vntOtherLineDivCd = Empty
    If Not IsMissing(vntOtherLineDivName) Then vntOtherLineDivName = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Trim(strDmdDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす個人請求書明細情報テーブルのレコードを取得
'### 2004/1/10 Updated by Ishihara@FSIT 領収書を複数人数でまとめた場合明細行がおかしくなる。
'    strStmt = "SELECT PERBILL_C.BILLLINENO,      PERBILL_C.PRICE,                " & vbLf & _
'              "       PERBILL_C.EDITPRICE,       PERBILL_C.TAXPRICE,             " & vbLf & _
'              "       PERBILL_C.EDITTAX,         PERBILL_C.CTRPTCD,              " & vbLf & _
'              "       PERBILL_C.OPTCD,           PERBILL_C.OPTBRANCHNO,          " & vbLf & _
'              "       PERBILL_C.RSVNO,           PERBILL_C.PRICESEQ,             " & vbLf & _
'              "       PERBILL_C.LINENAME,        PERBILL_C.OTHERLINEDIVCD,       " & vbLf & _
'              "       PERIDVIEW.PERID,                                             " & vbLf & _
'              "       PERSON.LASTNAME,           PERSON.FIRSTNAME,               " & vbLf & _
'              "       OTHERLINEDIV.OTHERLINEDIVNAME                              "
'
'    strStmt = strStmt & vbLf & _
'              "  FROM PERBILL_C, OTHERLINEDIV, PERSON,               "
'
'    strStmt = strStmt & vbLf & _
'              "       (                                              " & vbLf & _
'              "       (                                              " & vbLf & _
'              "        SELECT CONSULT.PERID PERID                    " & vbLf & _
'              "          FROM PERBILL_C, CONSULT                     " & vbLf & _
'              "         WHERE PERBILL_C.DMDDATE    = :DMDDATE        " & vbLf & _
'              "           AND PERBILL_C.BILLSEQ    = :BILLSEQ        " & vbLf & _
'              "           AND PERBILL_C.BRANCHNO   = :BRANCHNO       " & vbLf & _
'              "           AND CONSULT.RSVNO(+)     = PERBILL_C.RSVNO " & vbLf & _
'              "       ) UNION                                        " & vbLf & _
'              "       (                                              " & vbLf & _
'              "        SELECT PERBILL_PERSON.PERID PERID             " & vbLf & _
'              "          FROM PERBILL_PERSON                         " & vbLf & _
'              "         WHERE PERBILL_PERSON.DMDDATE    = :DMDDATE   " & vbLf & _
'              "           AND PERBILL_PERSON.BILLSEQ    = :BILLSEQ   " & vbLf & _
'              "           AND PERBILL_PERSON.BRANCHNO   = :BRANCHNO  " & vbLf & _
'              "       )                                              " & vbLf & _
'              "       )                                              " & vbLf & _
'              "       PERIDVIEW                                      "
'
'    strStmt = strStmt & vbLf & _
'              " WHERE PERBILL_C.DMDDATE    = :DMDDATE                            " & vbLf & _
'              "   AND PERBILL_C.BILLSEQ    = :BILLSEQ                            " & vbLf & _
'              "   AND PERBILL_C.BRANCHNO   = :BRANCHNO                           " & vbLf & _
'              "   AND PERSON.PERID         = PERIDVIEW.PERID                     " & vbLf & _
'              "   AND PERBILL_C.OTHERLINEDIVCD   = OTHERLINEDIV.OTHERLINEDIVCD(+)"
'
'    strStmt = strStmt & vbLf & _
'              " ORDER BY PERBILL_C.DMDDATE,           PERBILL_C.BILLSEQ,          " & vbLf & _
'              "          PERBILL_C.BRANCHNO                                       "
    strStmt = ""
    strStmt = strStmt & vbLf & _
              "SELECT BILLLINENO,      PRICE,                      " & vbLf & _
              "       EDITPRICE,       TAXPRICE,                   " & vbLf & _
              "       EDITTAX,         CTRPTCD,                    " & vbLf & _
              "       OPTCD,           OPTBRANCHNO,                " & vbLf & _
              "       RSVNO,           PRICESEQ,                   " & vbLf & _
              "       LINENAME,        OTHERLINEDIVCD,             " & vbLf & _
              "       LASTVIEW.PERID,                              " & vbLf & _
              "       PERSON.LASTNAME, PERSON.FIRSTNAME,           " & vbLf & _
              "       OTHERLINEDIVNAME                             " & vbLf & _
              "  FROM PERSON,                                      " & vbLf

    strStmt = strStmt & vbLf & _
              "       ( SELECT BILLLINENO,      PRICE,             " & vbLf & _
              "                EDITPRICE,       TAXPRICE,          " & vbLf & _
              "                EDITTAX,         CTRPTCD,           " & vbLf & _
              "                OPTCD,           OPTBRANCHNO,       " & vbLf & _
              "                RSVNO,           PRICESEQ,          " & vbLf & _
              "                LINENAME,        OTHERLINEDIVCD,    " & vbLf & _
              "                NVL(PERID1,PERID2) PERID,           " & vbLf & _
              "                OTHERLINEDIVNAME                    " & vbLf

    strStmt = strStmt & vbLf & _
              "           FROM ( SELECT PERBILL_C.BILLLINENO,      PERBILL_C.PRICE,                                        " & vbLf & _
              "                         PERBILL_C.EDITPRICE,       PERBILL_C.TAXPRICE,                                     " & vbLf & _
              "                         PERBILL_C.EDITTAX,         PERBILL_C.CTRPTCD,                                      " & vbLf & _
              "                         PERBILL_C.OPTCD,           PERBILL_C.OPTBRANCHNO,                                  " & vbLf & _
              "                         PERBILL_C.RSVNO,           PERBILL_C.PRICESEQ,                                     " & vbLf & _
              "                         PERBILL_C.LINENAME,        PERBILL_C.OTHERLINEDIVCD,                               " & vbLf & _
              "                         ( SELECT CONSULT.PERID FROM CONSULT WHERE CONSULT.RSVNO = PERBILL_C.RSVNO) PERID1, " & vbLf & _
              "                         ( SELECT PERBILL_PERSON.PERID PERID                                                " & vbLf & _
              "                             FROM PERBILL_PERSON                                                            " & vbLf & _
              "                            WHERE PERBILL_PERSON.DMDDATE    = :DMDDATE                                      " & vbLf & _
              "                              AND PERBILL_PERSON.BILLSEQ    = :BILLSEQ                                      " & vbLf & _
              "                              AND PERBILL_PERSON.BRANCHNO   = :BRANCHNO                                     " & vbLf & _
              "                         ) PERID2,                                                                          " & vbLf & _
              "                         OTHERLINEDIV.OTHERLINEDIVNAME                                                      " & vbLf & _
              "                    FROM PERBILL_C, OTHERLINEDIV                                                            " & vbLf & _
              "                   WHERE PERBILL_C.DMDDATE    = :DMDDATE                                                    " & vbLf & _
              "                     AND PERBILL_C.BILLSEQ    = :BILLSEQ                                                    " & vbLf & _
              "                     AND PERBILL_C.BRANCHNO   = :BRANCHNO                                                   " & vbLf & _
              "                     AND PERBILL_C.OTHERLINEDIVCD   = OTHERLINEDIV.OTHERLINEDIVCD(+)                        " & vbLf & _
              "                ) MAINVIEW               " & vbLf & _
              "       ) LASTVIEW                        " & vbLf

    strStmt = strStmt & vbLf & _
              " WHERE PERSON.PERID = LASTVIEW.PERID     " & vbLf & _
              " ORDER BY BILLLINENO                     "
'### 2004/1/10 Updated End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
     
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillLineNo = objFields("BILLLINENO")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objOptCd = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")
        Set objRsvNo = objFields("RSVNO")
        Set objPriceSeq = objFields("PRICESEQ")
        Set objLineName = objFields("LINENAME")
        Set objOtherLineDivCd = objFields("OTHERLINEDIVCD")
        Set objOtherLineDivName = objFields("OTHERLINEDIVNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillLineNo(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrCtrPtCd(lngCount)
            ReDim Preserve vntArrOptCd(lngCount)
            ReDim Preserve vntArrOptBranchNo(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrPriceSeq(lngCount)
            ReDim Preserve vntArrLineName(lngCount)
            ReDim Preserve vntArrOtherLineDivCd(lngCount)
            ReDim Preserve vntArrOtherLineDivName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            
            vntArrBillLineNo(lngCount) = objBillLineNo.Value
            vntArrPrice(lngCount) = objPrice.Value
            vntArrEditPrice(lngCount) = objEditPrice.Value
            vntArrTaxPrice(lngCount) = objTaxPrice.Value
            vntArrEditTax(lngCount) = objEditTax.Value
            vntArrCtrPtCd(lngCount) = objCtrPtCd.Value
            vntArrOptCd(lngCount) = objOptCd.Value
            vntArrOptBranchNo(lngCount) = objOptBranchNo.Value
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrPriceSeq(lngCount) = objPriceSeq.Value
            vntArrLineName(lngCount) = objLineName.Value
            vntArrOtherLineDivCd(lngCount) = objOtherLineDivCd.Value
            vntArrOtherLineDivName(lngCount) = objOtherLineDivName.Value
            vntArrLastName(lngCount) = objLastName.Value
            vntArrFirstName(lngCount) = objFirstName.Value

            lngCount = lngCount + 1
                        
            objOraDyna.MoveNext
        Loop

        SelectPerBill_c = lngCount
        
    End If
    

    '戻り値の設定
    If Not IsMissing(vntBillLineNo) Then vntBillLineNo = vntArrBillLineNo
    If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
    If Not IsMissing(vntEditPrice) Then vntEditPrice = vntArrEditPrice
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = vntArrTaxPrice
    If Not IsMissing(vntEditTax) Then vntEditTax = vntArrEditTax
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = vntArrCtrPtCd
    If Not IsMissing(vntOptCd) Then vntOptCd = vntArrOptCd
    If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = vntArrOptBranchNo
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntPriceSeq) Then vntPriceSeq = vntArrPriceSeq
    If Not IsMissing(vntLineName) Then vntLineName = vntArrLineName
    If Not IsMissing(vntOtherLineDivCd) Then vntOtherLineDivCd = vntArrOtherLineDivCd
    If Not IsMissing(vntOtherLineDivName) Then vntOtherLineDivName = vntArrOtherLineDivName
    If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
    If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
        
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerBill_c = 0

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerBill_c"
    
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
' 機能　　 : 請求書Ｎｏから予約番号を取得しそれぞれの受信情報を取得する
'
' 引数　　 : (In)     strDmdDate     請求日
' 　　　　   (In)     lngBillSeq     請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo    請求書枝番
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntLastName    姓
' 　　　　   (Out)    vntFirstName   名
' 　　　　   (Out)    vntLastKName   カナ姓
' 　　　　   (Out)    vntFirstKName  カナ名
' 　　　　   (Out)    vntCtrPtCd     契約パターンコード
' 　　　　   (Out)    vntCsName      コース名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPerBill_csl( _
    ByVal strDmdDate As String, _
    ByVal lngBillSeq As Long, _
    ByVal lngBranchNo As Long, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntPerID As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntCtrPtCd As Variant, _
    Optional ByRef vntCsName As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    Dim strStmt_count   As String           'SQLステートメント
    Dim strStmt_data    As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objRsvNo        As OraField         '予約番号
    Dim objCslDate      As OraField         '受診日
    Dim objPerID        As OraField         '個人ＩＤ
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objCtrPtCd      As OraField         '契約パターンコード
    Dim objCsName       As OraField         'コース名
    
    Dim vntArrRsvNo()       As Variant         '予約番号の配列
    Dim vntArrCslDate()     As Variant         '受診日の配列
    Dim vntArrPerID()       As Variant         '個人ＩＤの配列
    Dim vntArrLastName()    As Variant         '姓の配列
    Dim vntArrFirstName()   As Variant         '名の配列
    Dim vntArrLastKName()   As Variant         'カナ姓の配列
    Dim vntArrFirstKName()  As Variant         'カナ名の配列
    Dim vntArrCtrPtCd()     As Variant         '契約パターンコードの配列
    Dim vntArrCsName()      As Variant         'コース名の配列
    
    Dim lngCount      As Long             'カウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntPerID) Then vntPerID = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    


    '検索条件を満たす個人請求書管理情報テーブルのレコードを取得
    strStmt = "SELECT PERBILL_CSL.RSVNO,                        " & vbLf & _
              "       CONSULT.CSLDATE,     CONSULT.PERID,       " & vbLf & _
              "       CONSULT.CTRPTCD,                          " & vbLf & _
              "       PERSON.LASTNAME,     PERSON.FIRSTNAME,    " & vbLf & _
              "       PERSON.LASTKNAME,    PERSON.FIRSTKNAME,   " & vbLf & _
              "       CTRPT.CSNAME                              "

    strStmt = strStmt & vbLf & _
              "  FROM PERBILL_CSL, CONSULT, PERSON, CTRPT       "

    strStmt = strStmt & vbLf & _
              " WHERE PERBILL_CSL.DMDDATE   = :DMDDATE          " & vbLf & _
              "   AND PERBILL_CSL.BILLSEQ   = :BILLSEQ          " & vbLf & _
              "   AND PERBILL_CSL.BRANCHNO  = :BRANCHNO         " & vbLf & _
              "   AND CONSULT.RSVNO(+)      = PERBILL_CSL.RSVNO " & vbLf & _
              "   AND PERSON.PERID(+)       = CONSULT.PERID     " & vbLf & _
              "   AND CTRPT.CTRPTCD(+)      = CONSULT.CTRPTCD   "
    
    strStmt = strStmt & vbLf & _
              " ORDER BY PERBILL_CSL.RSVNO                      "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objPerID = objFields("PERID")
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objCsName = objFields("CSNAME")
        
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrPerID(lngCount)
            ReDim Preserve vntArrCtrPtCd(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrCslDate(lngCount) = objCslDate.Value
            vntArrPerID(lngCount) = objPerID.Value
            vntArrCtrPtCd(lngCount) = objCtrPtCd.Value
            vntArrLastName(lngCount) = objLastName.Value
            vntArrFirstName(lngCount) = objFirstName.Value
            vntArrLastKName(lngCount) = objLastKName.Value
            vntArrFirstKName(lngCount) = objFirstKName.Value
            vntArrCsName(lngCount) = objCsName.Value

            lngCount = lngCount + 1
                        
            objOraDyna.MoveNext
        Loop

        SelectPerBill_csl = lngCount
        
    End If
    

    '戻り値の設定
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntPerID) Then vntPerID = vntArrPerID
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = vntArrCtrPtCd
    If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
    If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
    If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
    If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
    If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerBill_csl = 0

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerBill_csl"
    
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
' 機能　　 : 入金Ｎｏから個人入金情報を取得する
'
' 引数　　 : (In)     strPaymentDate      入金日
' 　　　　   (In)     lngPaymentSeq       入金Ｓｅｑ
' 　　　　   (Out)    vntPriceTotal       請求金額合計
' 　　　　   (Out)    vntCredit           現金預かり金
' 　　　　   (Out)    vntHappy_ticket     ハッピー買物券
' 　　　　   (Out)    vntCard             カード
' 　　　　   (Out)    vntCardKind         カード種別
' 　　　　   (Out)    vntCardNAME         カード名称
' 　　　　   (Out)    vntCreditslipno     伝票Ｎｏ
' 　　　　   (Out)    vntJdebit           Ｊデビット
' 　　　　   (Out)    vntBankCode         金融機関コード
' 　　　　   (Out)    vntBankName         金融機関名
' 　　　　   (Out)    vntCheque           小切手
' 　　　　   (Out)    vntRegisterno       レジ番号
' 　　　　   (Out)    vntUpdDate          更新日付
' 　　　　   (Out)    vntUpdUser          ユーザＩＤ
' 　　　　   (Out)    vntUserName         ユーザ漢字氏名
' ## 2003.12.25 振込み　追加
' 　　　　   (Out)    vntTransfer         振込み
' ### 2004/11/1 Add by gouda@FSIT 計上日を追加する
'            (In)     vntCalcDate       計上日
' ### 2004/11/1 Add
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'

'### 2004/11/1 Add by gouda@FSIT 計上日を追加する
'Public Function SelectPerPayment(
'    ByVal strPaymentDate As String, ByVal lngPaymentSeq As Long,
'    Optional ByRef vntPriceTotal As Variant, Optional ByRef vntCredit As Variant,
'    Optional ByRef vntHappy_ticket As Variant, Optional ByRef vntCard As Variant,
'    Optional ByRef vntCardKind As Variant, Optional ByRef vntCardNAME As Variant,
'    Optional ByRef vntCreditslipno As Variant,
'    Optional ByRef vntJdebit As Variant, Optional ByRef vntBankCode As Variant,
'    Optional ByRef vntBankName As Variant, Optional ByRef vntCheque As Variant,
'    Optional ByRef vntRegisterno As Variant, Optional ByRef vntUpdDate As Variant,
'    Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant,
'    Optional ByRef vntTransfer As Variant
') As Boolean

Public Function SelectPerPayment( _
    ByVal strPaymentDate As String, ByVal lngPaymentSeq As Long, _
    Optional ByRef vntPriceTotal As Variant, Optional ByRef vntCredit As Variant, _
    Optional ByRef vntHappy_ticket As Variant, Optional ByRef vntCard As Variant, _
    Optional ByRef vntCardKind As Variant, Optional ByRef vntCardNAME As Variant, _
    Optional ByRef vntCreditslipno As Variant, _
    Optional ByRef vntJdebit As Variant, Optional ByRef vntBankCode As Variant, _
    Optional ByRef vntBankName As Variant, Optional ByRef vntCheque As Variant, _
    Optional ByRef vntRegisterno As Variant, Optional ByRef vntUpdDate As Variant, _
    Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant, _
    Optional ByRef vntTransfer As Variant, Optional ByRef vntCalcDate As Variant _
) As Boolean
'### 2004/11/1 Add End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPriceTotal       As Object           '請求金額合計
    Dim objCredit           As Object           '現金預かり金
    Dim objHappy_ticket     As Object           'ハッピー買物券
    Dim objCard             As Object           'カード
    Dim objCardKind         As Object           'カード種別
    Dim objCardName         As Object           'カード名称
    Dim objCreditslipno     As Object           '伝票Ｎｏ
    Dim objJdebit           As Object           'Ｊデビット
    Dim objBankCode         As Object           '金融機関コード
    Dim objBankName         As Object           '金融機関名
    Dim objCheque           As Object           '小切手
    Dim objRegisterno       As Object           'レジ番号
    Dim objUpdDate          As Object           '更新日付
    Dim objUpdUser          As Object           'ユーザＩＤ
    Dim objUserName         As Object           'ユーザ漢字氏名
    '## 2003.12.25 add 振込み
    Dim objTransfer         As Object           '振込み
    '### 2004/11/1 Add by gouda@FSIT 計上日を追加する
    Dim objCalcDate         As Object           '計上日
    '### 2004/11/1 Add End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntPriceTotal) Then vntPriceTotal = Empty
    If Not IsMissing(vntCredit) Then vntCredit = Empty
    If Not IsMissing(vntHappy_ticket) Then vntHappy_ticket = Empty
    If Not IsMissing(vntCard) Then vntCard = Empty
    If Not IsMissing(vntCardKind) Then vntCardKind = Empty
    If Not IsMissing(vntCardNAME) Then vntCardNAME = Empty
    If Not IsMissing(vntCreditslipno) Then vntCreditslipno = Empty
    If Not IsMissing(vntJdebit) Then vntJdebit = Empty
    If Not IsMissing(vntBankCode) Then vntBankCode = Empty
    If Not IsMissing(vntBankName) Then vntBankName = Empty
    If Not IsMissing(vntCheque) Then vntCheque = Empty
    If Not IsMissing(vntRegisterno) Then vntRegisterno = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUserName) Then vntUserName = Empty
    '## 2003.12.25 add 振込み
    If Not IsMissing(vntTransfer) Then vntTransfer = Empty
    '### 2004/11/1 Add by gouda@FSIT 計上日を追加する
    If Not IsMissing(vntCalcDate) Then vntCalcDate = Empty
    '### 2004/11/1 Add End

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PAYMENTDATE", Trim(strPaymentDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PAYMENTSEQ", lngPaymentSeq, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす個人入金情報テーブルのレコードを取得
    '### 2004/11/1 Add by gouda@FSIT 計上日を追加する
    '### 振込み（TRANSFER）追加 2003.12.25
'    strStmt = "SELECT PERPAYMENT.PRICETOTAL,       PERPAYMENT.CREDIT,       " & vbLf & _
'              "       PERPAYMENT.HAPPY_TICKET,     PERPAYMENT.CARD,         " & vbLf & _
'              "       PERPAYMENT.CARDKIND,         PERPAYMENT.CREDITSLIPNO, " & vbLf & _
'              "       PERPAYMENT.JDEBIT,           PERPAYMENT.BANKCODE,     " & vbLf & _
'              "       PERPAYMENT.CHEQUE,           PERPAYMENT.REGISTERNO,   " & vbLf & _
'              "       PERPAYMENT.UPDDATE,          PERPAYMENT.UPDUSER,      " & vbLf & _
'              "       PERPAYMENT.TRANSFER,                                  " & vbLf & _
'              "       HAINSUSER.USERNAME,                                   " & vbLf & _
'              "       CARD.CARDNAME,                                        " & vbLf & _
'              "       BANK.BANKNAME                                         "

    strStmt = "SELECT PERPAYMENT.PRICETOTAL,       PERPAYMENT.CREDIT,       " & vbLf & _
              "       PERPAYMENT.HAPPY_TICKET,     PERPAYMENT.CARD,         " & vbLf & _
              "       PERPAYMENT.CARDKIND,         PERPAYMENT.CREDITSLIPNO, " & vbLf & _
              "       PERPAYMENT.JDEBIT,           PERPAYMENT.BANKCODE,     " & vbLf & _
              "       PERPAYMENT.CHEQUE,           PERPAYMENT.REGISTERNO,   " & vbLf & _
              "       PERPAYMENT.UPDDATE,          PERPAYMENT.UPDUSER,      " & vbLf & _
              "       PERPAYMENT.TRANSFER,         PERPAYMENT.CALCDATE,     " & vbLf & _
              "       HAINSUSER.USERNAME,                                   " & vbLf & _
              "       CARD.CARDNAME,                                        " & vbLf & _
              "       BANK.BANKNAME                                         "
    '### 2004/11/1 Add End
    
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT FREECD BANKCODE, FREEFIELD1 BANKNAME         " & vbLf & _
              "           FROM FREE                                         " & vbLf & _
              "       ) BANK,                                               " & vbLf & _
              "       ( SELECT FREECD CARDKIND, FREEFIELD1 CARDNAME         " & vbLf & _
              "           FROM FREE                                         " & vbLf & _
              "       ) CARD,                                               " & vbLf & _
              "       PERPAYMENT, HAINSUSER                                 "
    strStmt = strStmt & vbLf & _
              " WHERE PERPAYMENT.PAYMENTDATE       = :PAYMENTDATE           " & vbLf & _
              "   AND PERPAYMENT.PAYMENTSEQ        = :PAYMENTSEQ            " & vbLf & _
              "   AND PERPAYMENT.UPDUSER           = HAINSUSER.USERID(+)    " & vbLf & _
              "   AND PERPAYMENT.CARDKIND          = CARD.CARDKIND(+)       " & vbLf & _
              "   AND PERPAYMENT.BANKCODE          = BANK.BANKCODE(+)       "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPriceTotal = objFields("PRICETOTAL")
        Set objCredit = objFields("CREDIT")
        Set objHappy_ticket = objFields("HAPPY_TICKET")
        Set objCard = objFields("CARD")
        Set objCardKind = objFields("CARDKIND")
        Set objCardName = objFields("CARDNAME")
        Set objCreditslipno = objFields("CREDITSLIPNO")
        Set objJdebit = objFields("JDEBIT")
        Set objBankCode = objFields("BANKCODE")
        Set objBankName = objFields("BANKNAME")
        Set objCheque = objFields("CHEQUE")
        Set objRegisterno = objFields("REGISTERNO")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        '## 2003.12.25 振込み　追加
        Set objTransfer = objFields("TRANSFER")
        '### 2004/11/1 Add by gouda@FSIT 計上日を追加する
        Set objCalcDate = objFields("CALCDATE")
        '### 2004/11/1 Add End

        '戻り値の設定
        If Not IsMissing(vntPriceTotal) Then vntPriceTotal = objPriceTotal.Value & ""
        If Not IsMissing(vntCredit) Then vntCredit = objCredit.Value & ""
        If Not IsMissing(vntHappy_ticket) Then vntHappy_ticket = objHappy_ticket.Value & ""
        If Not IsMissing(vntCard) Then vntCard = objCard.Value & ""
        If Not IsMissing(vntCardKind) Then vntCardKind = objCardKind.Value & ""
        If Not IsMissing(vntCardNAME) Then vntCardNAME = objCardName.Value & ""
        If Not IsMissing(vntCreditslipno) Then vntCreditslipno = objCreditslipno.Value & ""
        If Not IsMissing(vntJdebit) Then vntJdebit = objJdebit.Value & ""
        If Not IsMissing(vntBankCode) Then vntBankCode = objBankCode.Value & ""
        If Not IsMissing(vntBankName) Then vntBankName = objBankName.Value & ""
        If Not IsMissing(vntCheque) Then vntCheque = objCheque.Value & ""
        If Not IsMissing(vntRegisterno) Then vntRegisterno = objRegisterno.Value & ""
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUserName) Then vntUserName = objUserName.Value & ""
        '## 2003.12.25 振込み　追加
        If Not IsMissing(vntTransfer) Then vntTransfer = objTransfer.Value & ""
        '### 2004/11/1 Add by gouda@FSIT 計上日を追加する
        If Not IsMissing(vntCalcDate) Then vntCalcDate = objCalcDate.Value & ""
        '### 2004/11/1 Add End

        SelectPerPayment = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerPayment = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerPayment"
    
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
' 機能　　 : セット外請求明細を取得する。
'
' 引数　　 : (Out)    vntOtherLineDivCd      セット外請求明細コード
' 　　　　   (Out)    vntOtherLineDivName    セット外請求明細名
' 　　　　   (Out)    vntStdPrice            標準単価
' 　　　　   (Out)    vntStdTax              標準税額
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'

Public Function SelectOtherLineDiv( _
    Optional ByRef vntOtherLineDivCd As Variant, _
    Optional ByRef vntOtherLineDivName As Variant, _
    Optional ByRef vntstdPrice As Variant, _
    Optional ByRef vntstdTax As Variant _
) As Long

    Dim objOraParam               As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                As OraDynaset       'ダイナセット
    Dim strStmt                   As String           'SQLステートメント
    Dim lngCount                  As Long

    Dim objFields                 As OraFields        'フィールドオブジェクト
    Dim objOtherLineDivCd         As Object           'セット外請求明細コード
    Dim objOtherLineDivName       As Object           'セット外請求明細名
    Dim objstdPrice               As Object           '標準単価
    Dim objstdTax                 As Object           '標準税額

    Dim vntArrOtherLineDivCd()    As Variant     'セット外請求明細コード
    Dim vntArrOtherLineDivName()  As Variant     'セット外請求明細名
    Dim vntArrStdPrice()          As Variant     '標準単価
    Dim vntArrStdTax()            As Variant     '標準税額

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectOtherLineDiv = -1

    '初期処理
    If Not IsMissing(vntOtherLineDivCd) Then vntOtherLineDivCd = Empty
    If Not IsMissing(vntOtherLineDivName) Then vntOtherLineDivName = Empty
    If Not IsMissing(vntstdPrice) Then vntstdPrice = Empty
    If Not IsMissing(vntstdTax) Then vntstdTax = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    '検索条件を満たす個人入金情報テーブルのレコードを取得
'### 2004/1/9 Updated by Ishihara@FSIT ORDER BY くらい・・・
'    strStmt = "SELECT OTHERLINEDIV.OTHERLINEDIVCD,   OTHERLINEDIV.OTHERLINEDIVNAME,  " & vbLf & _
              "       OTHERLINEDIV.STDPRICE,         OTHERLINEDIV.STDTAX             " & vbLf & _
              "  FROM OTHERLINEDIV                                                   "
    strStmt = "SELECT OTHERLINEDIV.OTHERLINEDIVCD,   OTHERLINEDIV.OTHERLINEDIVNAME,  " & vbLf & _
              "       OTHERLINEDIV.STDPRICE,         OTHERLINEDIV.STDTAX             " & vbLf & _
              "  FROM OTHERLINEDIV                                                   " & vbLf & _
              " ORDER BY OTHERLINEDIV.OTHERLINEDIVCD                                 "
'### 2004/1/9 Updated End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOtherLineDivCd = objFields("OTHERLINEDIVCD")
        Set objOtherLineDivName = objFields("OTHERLINEDIVNAME")
        Set objstdPrice = objFields("STDPRICE")
        Set objstdTax = objFields("STDTAX")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOtherLineDivCd(lngCount)
            ReDim Preserve vntArrOtherLineDivName(lngCount)
            ReDim Preserve vntArrStdPrice(lngCount)
            ReDim Preserve vntArrStdTax(lngCount)

            vntArrOtherLineDivCd(lngCount) = objOtherLineDivCd.Value & ""
            vntArrOtherLineDivName(lngCount) = objOtherLineDivName.Value & ""
            vntArrStdPrice(lngCount) = objstdPrice.Value & ""
            vntArrStdTax(lngCount) = objstdTax.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        If Not IsMissing(vntOtherLineDivCd) Then vntOtherLineDivCd = vntArrOtherLineDivCd
        If Not IsMissing(vntOtherLineDivName) Then vntOtherLineDivName = vntArrOtherLineDivName
        If Not IsMissing(vntstdPrice) Then vntstdPrice = vntArrStdPrice
        If Not IsMissing(vntstdTax) Then vntstdTax = vntArrStdTax

        SelectOtherLineDiv = lngCount

    Else
        SelectOtherLineDiv = 0 '件数なし
        
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
    WriteErrorLog "Contract.SelectOtherLineDiv"
    
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

'### 2004/01/15 Added by Ishihara@FSIT　マスタメンテナンス用に新規追加
'
' 機能　　 : セット外請求明細情報を取得する
'
' 引数　　 : (In)     strOtherLineDivCd     セット外請求明細コード
' 　　　　 : (Out)    vntOtherLineDivName   セット外請求明細名称（省略可）
' 　　　　 : (Out)    vntstdPrice           標準単価（省略可）
' 　　　　 : (Out)    vntstdTax             標準税額（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 :
'
Public Function SelectOtherLineDivFromCode(ByVal strOtherLineDivCd As String, _
                                           Optional ByRef vntOtherLineDivName As Variant, _
                                           Optional ByRef vntstdPrice As Variant, _
                                           Optional ByRef vntstdTax As Variant) As Boolean


    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOtherLineDivName     As OraField         'セット外請求明細名称
    Dim objstdPrice             As OraField         '標準単価
    Dim objstdTax               As OraField         '標準税額

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "OtherLineDivCD", Trim(strOtherLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たすセット外請求明細テーブルのレコードを取得
    strStmt = "SELECT OTHERLINEDIVNAME, STDPRICE, STDTAX" & vbLf & _
              "  FROM OTHERLINEDIV " & vbLf & _
              " WHERE OTHERLINEDIVCD = :OTHERLINEDIVCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOtherLineDivName = objFields("OtherLineDivName")
        Set objstdPrice = objFields("stdPrice")
        Set objstdTax = objFields("stdTax")

        If IsMissing(vntOtherLineDivName) = False Then vntOtherLineDivName = objOtherLineDivName.Value & ""
        If IsMissing(vntOtherLineDivName) = False Then vntOtherLineDivName = objOtherLineDivName.Value & ""
        If IsMissing(vntstdPrice) = False Then vntstdPrice = objstdPrice.Value & ""
        If IsMissing(vntstdTax) = False Then vntstdTax = objstdTax.Value & ""
        
        SelectOtherLineDivFromCode = True
    
    Else
        
        If Not IsMissing(vntOtherLineDivName) Then vntOtherLineDivName = ""
    
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
    WriteErrorLog "PerBill.SelectOtherLineDivFromCode"
    
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

'### 2004/01/15 Added by Ishihara@FSIT　マスタメンテナンス用に新規追加
'
' 機能　　 : セット外請求明細テーブルレコードを削除する
'
' 引数　　 : (In)   strOtherLineDivCd    セット外請求明細コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteOtherLineDiv(ByVal strOtherLineDivCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "OtherLineDivCD", Trim(strOtherLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'セット外請求明細テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE OTHERLINEDIV WHERE OTHERLINEDIVCD = :OTHERLINEDIVCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteOtherLineDiv = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteOtherLineDiv = False

    'イベントログ書き込み
    WriteErrorLog "PerBill.DeleteOtherLineDiv"
    
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

'### 2004/01/15 Added by Ishihara@FSIT　マスタメンテナンス用に新規追加
'
' 機能　　 : セット外請求明細テーブルレコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strOtherLineDivCd      セット外請求明細コード
' 　　　　 : (In)    vntOtherLineDivName    セット外請求明細名称
' 　　　　 : (In)    strStdPrice            標準単価
' 　　　　 : (In)    vntStdTax              標準税額
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistOtherLineDiv(ByVal strMode As String, _
                                   ByVal strOtherLineDivCd As String, _
                                   ByVal strOtherLineDivName As String, _
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
    objOraParam.Add "OtherLineDivCD", Trim(strOtherLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OtherLineDivNAME", Trim(strOtherLineDivName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "StdPrice", Trim(strStdPrice), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "StdTax", Trim(strStdTax), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        'セット外請求明細テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE OTHERLINEDIV " & _
                      "   SET OTHERLINEDIVNAME = :OTHERLINEDIVNAME, " & _
                      "       STDPRICE       　= :STDPRICE, " & _
                      "       STDTAX           = :STDTAX " & _
                      " WHERE OTHERLINEDIVCD   = :OTHERLINEDIVCD"
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たすセット外請求明細テーブルのレコードを取得
        strStmt = "SELECT OTHERLINEDIVCD FROM OTHERLINEDIV WHERE OTHERLINEDIVCD = :OTHERLINEDIVCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = "INSERT INTO OTHERLINEDIV ( OTHERLINEDIVCD,  OTHERLINEDIVNAME,  STDPRICE,  STDTAX)" & _
                  "                  VALUES (:OTHERLINEDIVCD, :OTHERLINEDIVNAME, :STDPRICE, :STDTAX)"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistOtherLineDiv = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistOtherLineDiv = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "PerBill.RegistOtherLineDiv"
    
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
' 機能　　 : 同伴者（お連れ様）の請求書情報を取得する。
'
' 引数　　 : (In)     vntInCslDate           受診日
' 　　　　   (In)     vntInRsvNo             予約番号
' 　　　　   (Out)    vntDmdDate             請求日
' 　　　　   (Out)    vntBillSeq             請求書Ｓｅｑ
' 　　　　   (Out)    vntBranchNo            請求書枝番
' 　　　　   (Out)    vntPerID               個人ＩＤ
' 　　　　   (Out)    vntLastName            姓
' 　　　　   (Out)    vntFirstName           名
' 　　　　   (Out)    vntLastKName           カナ姓
' 　　　　   (Out)    vntFirstKName          カナ名
' 　　　　   (Out)    vntRsvNo               予約番号
' 　　　　   (Out)    vntAge                 年齢
' 　　　　   (Out)    vntGender              性別
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'

Public Function SelectFriendsPerBill( _
    ByRef vntInCslDate As Variant, _
    ByRef vntInRsvNo As Variant, _
    Optional ByRef vntDmdDate As Variant, _
    Optional ByRef vntBillSeq As Variant, _
    Optional ByRef vntBranchNo As Variant, _
    Optional ByRef vntPerID As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntAge As Variant, _
    Optional ByRef vntGender As Variant _
) As Long

    Dim objOraParam               As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                As OraDynaset       'ダイナセット
    Dim strStmt                   As String           'SQLステートメント
    Dim lngCount                  As Long

    Dim objInCslDate              As OraParameter     '受診日
    Dim objInRsvNo                As OraParameter     '予約番号
    
    Dim objFields                 As OraFields        'フィールドオブジェクト
    Dim objDmdDate                As Object           '請求日
    Dim objBillSeq                As Object           '請求書Ｓｅｑ
    Dim objBranchNo               As Object           '請求書枝番
    Dim objPerID                  As Object           '個人ＩＤ
    Dim objLastName               As Object           '姓
    Dim objFirstName              As Object           '名
    Dim objLastKName              As Object           'カナ姓
    Dim objFirstKName             As Object           'カナ名
    Dim objRsvNo                  As Object           '予約番号
    Dim objAge                    As Object           '年齢
    Dim objGender                 As Object           '性別

    Dim vntArrDmdDate()         As Variant     '請求日
    Dim vntArrBillSeq()         As Variant     '請求書Ｓｅｑ
    Dim vntArrBranchNo()        As Variant     '請求書枝番
    Dim vntArrPerID()           As Variant     '個人ＩＤ
    Dim vntArrLastName()        As Variant     '姓
    Dim vntArrFirstName()       As Variant     '名
    Dim vntArrLastKName()       As Variant     'カナ姓
    Dim vntArrFirstKName()      As Variant     'カナ名
    Dim vntArrRsvNo()           As Variant     '予約番号
    Dim vntArrAge()             As Variant     '年齢
    Dim vntArrGender()          As Variant     '性別
    
    Dim i                       As Long         'ループカウンタ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectFriendsPerBill = -1

    '初期処理
    If Not IsMissing(vntDmdDate) Then vntDmdDate = Empty
    If Not IsMissing(vntBillSeq) Then vntBillSeq = Empty
    If Not IsMissing(vntBranchNo) Then vntBranchNo = Empty
    If Not IsMissing(vntPerID) Then vntPerID = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "INCSLDATE", "", ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "INRSVNO", "", ORAPARM_INPUT, ORATYPE_NUMBER
    
    'パラメータの参照設定
    Set objInCslDate = objOraParam("INCSLDATE")
    Set objInRsvNo = objOraParam("INRSVNO")
    
    '検索条件を満たすお連れ様の請求書のレコードを取得
    strStmt = "SELECT DISTINCT                                             " & vbLf & _
              "       PERBILL_CSL.DMDDATE, PERBILL_CSL.BILLSEQ,            " & vbLf & _
              "       PERBILL_CSL.BRANCHNO,                                " & vbLf & _
              "       CONSULT.PERID,                                       " & vbLf & _
              "       PERSON.LASTNAME, PERSON.FIRSTNAME,                   " & vbLf & _
              "       PERSON.LASTKNAME, PERSON.FIRSTKNAME,                 " & vbLf & _
              "       CONSULT.AGE, PERSON.GENDER,                          " & vbLf & _
              "       FRIENDSVIEW.RSVNO                                    " & vbLf & _
              "  FROM PERSON, PERBILL_CSL, PERBILL, CONSULT,               " & vbLf & _
              "       (SELECT FRIENDS.RSVNO, FRIENDS.CSLDATE               " & vbLf & _
              "          FROM FRIENDS                                      " & vbLf & _
              "         WHERE FRIENDS.SEQ =                                " & vbLf & _
              "               (SELECT SEQ FROM FRIENDS                     " & vbLf & _
              "                 WHERE CSLDATE = :INCSLDATE                 " & vbLf & _
              "                   AND RSVNO = :INRSVNO )                   " & vbLf & _
              "           AND FRIENDS.CSLDATE = :INCSLDATE) FRIENDSVIEW    "
    
    strStmt = strStmt & vbLf & _
              " WHERE FRIENDSVIEW.RSVNO    = PERBILL_CSL.RSVNO             " & vbLf & _
              "   AND CONSULT.PERID        = PERSON.PERID                  " & vbLf & _
              "   AND PERBILL_CSL.BRANCHNO = 0                             " & vbLf & _
              "   AND PERBILL.DMDDATE      = PERBILL_CSL.DMDDATE           " & vbLf & _
              "   AND PERBILL.BILLSEQ      = PERBILL_CSL.BILLSEQ           " & vbLf & _
              "   AND PERBILL.BRANCHNO     = PERBILL_CSL.BRANCHNO          " & vbLf & _
              "   AND PERBILL.DELFLG       = 0                             " & vbLf & _
              "   AND PERBILL.PRINTDATE IS NULL                            " & vbLf & _
              "   AND FRIENDSVIEW.CSLDATE  = CONSULT.CSLDATE               " & vbLf & _
              "   AND FRIENDSVIEW.RSVNO    = CONSULT.RSVNO                 "

    lngCount = 0
    
    For i = 0 To UBound(vntInCslDate)
        objInCslDate.Value = Trim(vntInCslDate(i))
        objInRsvNo.Value = Trim(vntInRsvNo(i))
        'SQL文の実行
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'        If objOraSQLStmt Is Nothing Then
'            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
'        Else
'            objOraSQLStmt.Refresh
'        End If

    
        'レコードが存在する場合
        If Not objOraDyna.EOF Then
    
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objDmdDate = objFields("DMDDATE")
            Set objBillSeq = objFields("BILLSEQ")
            Set objBranchNo = objFields("BRANCHNO")
            Set objPerID = objFields("PERID")
            Set objLastName = objFields("LASTNAME")
            Set objFirstName = objFields("FIRSTNAME")
            Set objLastKName = objFields("LASTKNAME")
            Set objFirstKName = objFields("FIRSTKNAME")
            Set objRsvNo = objFields("RSVNO")
            Set objAge = objFields("AGE")
            Set objGender = objFields("GENDER")


            '配列形式で格納する
            Do Until objOraDyna.EOF
            
                ReDim Preserve vntArrDmdDate(lngCount)
                ReDim Preserve vntArrBillSeq(lngCount)
                ReDim Preserve vntArrBranchNo(lngCount)
                ReDim Preserve vntArrPerID(lngCount)
                ReDim Preserve vntArrLastName(lngCount)
                ReDim Preserve vntArrFirstName(lngCount)
                ReDim Preserve vntArrLastKName(lngCount)
                ReDim Preserve vntArrFirstKName(lngCount)
                ReDim Preserve vntArrRsvNo(lngCount)
                ReDim Preserve vntArrAge(lngCount)
                ReDim Preserve vntArrGender(lngCount)

               vntArrDmdDate(lngCount) = objDmdDate.Value & ""
               vntArrBillSeq(lngCount) = objBillSeq.Value & ""
               vntArrBranchNo(lngCount) = objBranchNo.Value & ""
               vntArrPerID(lngCount) = objPerID.Value & ""
               vntArrLastName(lngCount) = objLastName.Value & ""
               vntArrFirstName(lngCount) = objFirstName.Value & ""
               vntArrLastKName(lngCount) = objLastKName.Value & ""
               vntArrFirstKName(lngCount) = objFirstKName.Value & ""
               vntArrRsvNo(lngCount) = objRsvNo.Value & ""
               vntArrAge(lngCount) = objAge.Value & ""
               vntArrGender(lngCount) = objGender.Value & ""

                lngCount = lngCount + 1
                objOraDyna.MoveNext
        
            Loop

        End If
    Next i
    
    If lngCount > 0 Then
        '戻り値の設定
        If Not IsMissing(vntDmdDate) Then vntDmdDate = vntArrDmdDate
        If Not IsMissing(vntBillSeq) Then vntBillSeq = vntArrBillSeq
        If Not IsMissing(vntBranchNo) Then vntBranchNo = vntArrBranchNo
        If Not IsMissing(vntPerID) Then vntPerID = vntArrPerID
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
    End If

    SelectFriendsPerBill = lngCount

'MsgBox "count=" & lngCount

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.SelectFriendsPerBill"
    
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

' 機能　　 : 予約番号をキーに個人受診情報の消費税を一括免除する。
'
' 引数　　 : (In)     lngRsvNo          予約番号
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function OmitTaxSet( _
                        ByVal lngRsvNo As Long _
                        ) As Boolean
    
    Dim objDemand       As Object   'Demandクラス

    Dim lngCount        As Long     '個人受診金額情報件数

    Dim i               As Long     'ループカウンタ

    Dim blnAns          As Boolean  '関数復帰値

    Dim vntOrgCd1           As Variant
    Dim vntOrgCd2           As Variant
    Dim vntOrgSeq           As Variant
    Dim vntOrgName          As Variant
    Dim vntPrice_m          As Variant
    Dim vntEditPrice_m      As Variant
    Dim vntTaxPrice_m       As Variant
    Dim vntEditTax_m        As Variant
    Dim vntLineTotal        As Variant
    Dim vntPriceSeq         As Variant
    Dim vntCtrPtCd          As Variant
    Dim vntOptCd            As Variant
    Dim vntOptBranchNo      As Variant
    Dim vntOptName          As Variant
    Dim vntOtherLineDivCd   As Variant
    Dim vntLineName         As Variant
    Dim vntDmdDate_m        As Variant
    Dim vntBillSeq_m        As Variant
    Dim vntBranchNo_m       As Variant
    Dim vntBillLineNo       As Variant
    Dim vntPaymentDate_m    As Variant
    Dim vntPaymentSeq_m     As Variant
    Dim vntOmitTaxFlg       As Variant
    Dim vntPrintDate        As Variant
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
            
    'Demandクラスのインスタンス作成
    Set objDemand = CreateObject("HainsDemand.Demand")

    '個人受診金額情報取得
    lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, vntOrgCd1, vntOrgCd2, _
                                            vntOrgSeq, vntOrgName, _
                                            vntPrice_m, vntEditPrice_m, _
                                            vntTaxPrice_m, vntEditTax_m, _
                                            vntLineTotal, vntPriceSeq, _
                                            vntCtrPtCd, vntOptCd, _
                                            vntOptBranchNo, vntOptName, _
                                            vntOtherLineDivCd, vntLineName, _
                                            vntDmdDate_m, vntBillSeq_m, _
                                            vntBranchNo_m, vntBillLineNo, _
                                            vntPaymentDate_m, vntPaymentSeq_m, _
                                            vntOmitTaxFlg, vntPrintDate)


    '受診金額情報が存在しない場合
    If lngCount < 1 Then
        OmitTaxSet = False
        Exit Function
    End If
                  
    For i = 0 To lngCount - 1

        '領収書印刷未
        If vntPrintDate(i) = "" Then
            '負担元が個人の場合
            If ((vntOrgCd1(i) = "XXXXX") And (vntOrgCd2(i) = "XXXXX")) Then
                '個人請求詳細情報を更新する
                blnAns = UpdatePerBill_c(vntDmdDate_m(i), _
                                        IIf(vntBillSeq_m(i) = "", 0, vntBillSeq_m(i)), _
                                        IIf(vntBranchNo_m(i) = "", 0, vntBranchNo_m(i)), _
                                        IIf(vntBillLineNo(i) = "", 0, vntBillLineNo(i)), _
                                        vntPrice_m(i), vntEditPrice_m(i), _
                                        vntTaxPrice_m(i), vntEditTax_m(i), _
                                        vntLineName(i), _
                                        lngRsvNo, vntPriceSeq(i), 1)
            End If
        End If
    Next i
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    OmitTaxSet = True
    
    Exit Function
    
ErrorHandle:

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    OmitTaxSet = False
    
    'イベントログ書き込み
    WriteErrorLog "PerBill.OmitTaxSet"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 請求書Ｎｏ，請求明細行Ｎｏをキーに個人請求詳細情報を更新する
'
' 引数　　 : (In)     strDmdDate            請求日
' 　　　　   (In)     lngBillSeq            請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo           請求書枝番
' 　　　　   (In)     lngBillLineNo         請求明細行Ｎｏ
' 　　　　   (In)     vntPrice              金額
' 　　　　   (In)     vntEditPrice          調整金額
' 　　　　   (In)     vntTaxPrice           税額
' 　　　　   (In)     vntEditTax            調整税額
' 　　　　   (In)     vntLineName           明細名称
' 　　　　   (In)     vntRsvNo              予約番号
' 　　　　   (In)     vntPriceSeq           受診金額Ｓｅｑ
' 　　　　   (In)     vntOmitTaxFlg         消費税免除フラグ
' 　　　　   (In)     vntOtherLineDivCd     セット外明細コード（省略可）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdatePerBill_c(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As Long, _
                                ByVal lngBranchNo As Long, _
                                ByVal lngBillLineNo As Long, _
                                ByVal vntPrice As Variant, _
                                ByVal vntEditPrice As Variant, _
                                ByVal vntTaxPrice As Variant, _
                                ByVal vntEditTax As Variant, _
                                ByVal vntLineName As Variant, _
                                ByVal vntRsvNo As Variant, _
                                ByVal vntPriceSeq As Variant, _
                                ByVal vntOmitTaxFlg As Variant, _
                                Optional ByVal vntOtherLineDivCd As Variant _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objRsvNo        As OraField         '予約番号
    Dim objPriceSeq     As OraField         '受信金額ＳＥＱ
    
    Dim lngRsvNo        As Long             '予約番号
    Dim lngPriceSeq     As Long             '受信金額ＳＥＱ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '消費税免除の場合
    If vntOmitTaxFlg = 1 Then
        vntEditTax = -1 * vntTaxPrice
    End If
    
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    If strDmdDate <> "" Then
        objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BILLLINENO", lngBillLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "PRICE", vntPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITPRICE", vntEditPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", vntTaxPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITTAX", vntEditTax, ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "OMITTAXFLG", vntOmitTaxFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    
    If vntLineName <> "" And IsNull(vntLineName) = False Then
        objOraParam.Add "LINENAME", Trim(vntLineName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If

'    If IsMissing(vntRsvNo) = False Then
'        objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
    
'    If IsMissing(vntPriceSeq) = False Then
'        objOraParam.Add "PRICESEQ", vntPriceSeq, ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
    
    lngRsvNo = 0
    lngPriceSeq = 0
    If CLng(vntRsvNo) = 0 Or CLng(vntPriceSeq) = 0 Then
        '予約番号、受診金額Ｓｅｑ取得
        strStmt = "SELECT PERBILL_C.RSVNO, PERBILL_C.PRICESEQ    " & vbLf & _
                  "  FROM PERBILL_C                              " & vbLf & _
                  " WHERE PERBILL_C.DMDDATE    = :DMDDATE        " & vbLf & _
                  "   AND PERBILL_C.BILLSEQ    = :BILLSEQ        " & vbLf & _
                  "   AND PERBILL_C.BRANCHNO   = :BRANCHNO       " & vbLf & _
                  "   AND PERBILL_C.BILLLINENO = :BILLLINENO     " & vbLf & _
                  " FOR UPDATE NOWAIT                            "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
        'レコードが存在する場合
        If Not objOraDyna.EOF Then
    
            Set objFields = objOraDyna.Fields
            Set objRsvNo = objFields("RSVNO")
            Set objPriceSeq = objFields("PRICESEQ")
        
            lngRsvNo = objRsvNo.Value
            lngPriceSeq = objPriceSeq.Value
        End If
    
    Else
        lngRsvNo = CLng(vntRsvNo)
        lngPriceSeq = CLng(vntPriceSeq)
    End If

    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRICESEQ", lngPriceSeq, ORAPARM_INPUT, ORATYPE_NUMBER

    If IsMissing(vntOtherLineDivCd) = False Then
        If Trim(vntOtherLineDivCd) <> "" Then
            objOraParam.Add "OTHERLINEDIVCD", Trim(vntOtherLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        End If
    End If
    
    '請求日あり？
    If strDmdDate <> "" Then
        '個人請求明細情報テーブルレコードの更新
        strStmt = "UPDATE PERBILL_C                    " & vbLf & _
                  "   SET PRICE      = :PRICE,         " & vbLf & _
                  "       EDITPRICE  = :EDITPRICE,     " & vbLf & _
                  "       TAXPRICE   = :TAXPRICE,      " & vbLf & _
                  "       EDITTAX    = :EDITTAX        "
                  
        If vntLineName <> "" And IsNull(vntLineName) = False Then
            strStmt = strStmt & "," & vbLf & _
                  "   LINENAME          = :LINENAME "
        End If
    
        If IsMissing(vntRsvNo) = False Then
            strStmt = strStmt & "," & vbLf & _
                      "   RSVNO          = :RSVNO "
        End If
    
        If IsMissing(vntPriceSeq) = False Then
            strStmt = strStmt & "," & vbLf & _
                      "   PRICESEQ          = :PRICESEQ "
        End If
    
        If IsMissing(vntOtherLineDivCd) = False Then
            If Trim(vntOtherLineDivCd) <> "" Then
                strStmt = strStmt & "," & vbLf & _
                        "   OTHERLINEDIVCD          = :OTHERLINEDIVCD "
            End If
        End If
    
        strStmt = strStmt & vbLf & _
                " WHERE PERBILL_C.DMDDATE = :DMDDATE       " & vbLf & _
                "   AND PERBILL_C.BILLSEQ = :BILLSEQ       " & vbLf & _
                "   AND PERBILL_C.BRANCHNO = :BRANCHNO     " & vbLf & _
                "   AND PERBILL_C.BILLLINENO = :BILLLINENO "
     
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    End If

    '予約あり？
    If lngRsvNo <> 0 And lngPriceSeq <> 0 Then
        strStmt = "SELECT LINENAME                             " & vbLf & _
                  "  FROM CONSULT_M                            " & vbLf & _
                  " WHERE CONSULT_M.RSVNO    = :RSVNO          " & vbLf & _
                  "   AND CONSULT_M.PRICESEQ = :PRICESEQ       " & vbLf & _
                  " FOR UPDATE NOWAIT                          "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
        'レコードが存在する場合
        If Not objOraDyna.EOF Then
    
            '受診金額確定テーブルの明細名称更新
            strStmt = "UPDATE CONSULT_M                       " & vbLf & _
                      "   SET PRICE      = :PRICE,            " & vbLf & _
                      "       EDITPRICE  = :EDITPRICE,        " & vbLf & _
                      "       TAXPRICE   = :TAXPRICE,         " & vbLf & _
                      "       EDITTAX    = :EDITTAX,          " & vbLf & _
                      "       OMITTAXFLG = :OMITTAXFLG        "
            
            If vntLineName <> "" And IsNull(vntLineName) = False Then
                strStmt = strStmt & "," & vbLf & _
                      "   LINENAME          = :LINENAME "
            End If
            
            If IsMissing(vntOtherLineDivCd) = False Then
                If Trim(vntOtherLineDivCd) <> "" Then
                    strStmt = strStmt & "," & vbLf & _
                      "   OTHERLINEDIVCD          = :OTHERLINEDIVCD "
                End If
            End If
        
            strStmt = strStmt & vbLf & _
                      " WHERE CONSULT_M.RSVNO    = :RSVNO    " & vbLf & _
                      "   AND CONSULT_M.PRICESEQ = :PRICESEQ "

            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        End If

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdatePerBill_c = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.UpdatePerBill_c"
    
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
' 機能　　 : 請求書統合を行う
'
' 引数　　 : (In)     strDmdDate            統合先請求日
' 　　　　   (In)     lngBillSeq            統合先請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo           統合先請求書枝番
' 　　　　   (In)     strOldDmdDate         統合元請求日
' 　　　　   (In)     lngOldBillSeq         統合元請求書Ｓｅｑ
' 　　　　   (In)     lngOldBranchNo        統合元請求書枝番
''
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function MergePerBill(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As Long, _
                                ByVal lngBranchNo As Long, _
                                ByVal strOldDmdDate As String, _
                                ByVal lngOldBillSeq As Long, _
                                ByVal lngOldBranchNo As Long _
) As Boolean

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim lngBillLineNo           As Long             '明細行No
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '明細行Ｎｏ発番処理
    lngBillLineNo = GetBillLineNo(strDmdDate, lngBillSeq, lngBranchNo)
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLLINENO", lngBillLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OLDDMDDATE", Format(Trim(strOldDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "OLDBILLSEQ", lngOldBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OLDBRANCHNO", lngOldBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '個人請求明細情報テーブルレコードの挿入
    strStmt = "INSERT INTO PERBILL_C (           " & vbLf & _
              "                   DMDDATE,       " & vbLf & _
              "                   BILLSEQ,       " & vbLf & _
              "                   BRANCHNO,      " & vbLf & _
              "                   BILLLINENO,    " & vbLf & _
              "                   PRICE,         " & vbLf & _
              "                   EDITPRICE,     " & vbLf & _
              "                   TAXPRICE,      " & vbLf & _
              "                   EDITTAX,       " & vbLf & _
              "                   CTRPTCD,       " & vbLf & _
              "                   OPTCD,         " & vbLf & _
              "                   OPTBRANCHNO,   " & vbLf & _
              "                   LINENAME,      " & vbLf & _
              "                   RSVNO,         " & vbLf & _
              "                   PRICESEQ,      " & vbLf & _
              "                   OTHERLINEDIVCD "

    strStmt = strStmt & vbLf & _
              "   ) (  SELECT :DMDDATE,                          " & vbLf & _
              "               :BILLSEQ,                          " & vbLf & _
              "               :BRANCHNO,                         " & vbLf & _
              "               :BILLLINENO + BILLLINENO - 1,      " & vbLf & _
              "               PRICE,                             " & vbLf & _
              "               EDITPRICE,                         " & vbLf & _
              "               TAXPRICE,                          " & vbLf & _
              "               EDITTAX,                           " & vbLf & _
              "               CTRPTCD,                           " & vbLf & _
              "               OPTCD,                             " & vbLf & _
              "               OPTBRANCHNO,                       " & vbLf & _
              "               LINENAME,                          " & vbLf & _
              "               RSVNO,                             " & vbLf & _
              "               PRICESEQ,                          " & vbLf & _
              "               OTHERLINEDIVCD                     " & vbLf & _
              "          FROM PERBILL_C                          " & vbLf & _
              "         WHERE PERBILL_C.DMDDATE   = :OLDDMDDATE  " & vbLf & _
              "           AND PERBILL_C.BILLSEQ   = :OLDBILLSEQ  " & vbLf & _
              "           AND PERBILL_C.BRANCHNO  = :OLDBRANCHNO " & vbLf & _
              "        )"

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '個人請求書管理受診情報テーブルレコードの挿入
    strStmt = "INSERT INTO PERBILL_CSL (         " & vbLf & _
              "                   DMDDATE,       " & vbLf & _
              "                   BILLSEQ,       " & vbLf & _
              "                   BRANCHNO,      " & vbLf & _
              "                   RSVNO          "

    strStmt = strStmt & vbLf & _
              "   ) (  SELECT DISTINCT                           " & vbLf & _
              "               :DMDDATE,                          " & vbLf & _
              "               :BILLSEQ,                          " & vbLf & _
              "               :BRANCHNO,                         " & vbLf & _
              "                RSVNO                             " & vbLf & _
              "          FROM PERBILL_C                          " & vbLf & _
              "         WHERE PERBILL_C.DMDDATE   = :OLDDMDDATE  " & vbLf & _
              "           AND PERBILL_C.BILLSEQ   = :OLDBILLSEQ  " & vbLf & _
              "           AND PERBILL_C.BRANCHNO  = :OLDBRANCHNO " & vbLf & _
              "            )   "


    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    MergePerBill = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.MergePerBill"
    
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
' 機能　　 : 個人請求書管理受診情報テーブルにレコードを挿入する
'
' 引数　　 : (In)     strDmdDate            請求日
' 　　　　   (In)     lngBillSeq            請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo           請求書枝番
' 　　　　   (In)     vntRsvNo              予約番号
''
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertPerBill_csl(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As Long, _
                                ByVal lngBranchNo As Long, _
                                ByVal vntRsvNo As Variant _
) As Boolean

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPerCount             As OraField         '件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    

    strStmt = "SELECT COUNT(*) PERCOUNT                 " & vbLf & _
              "  FROM PERBILL_CSL                       " & vbLf & _
              " WHERE PERBILL_CSL.DMDDATE = :DMDDATE    " & vbLf & _
              "   AND PERBILL_CSL.BILLSEQ  = :BILLSEQ   " & vbLf & _
              "   AND PERBILL_CSL.BRANCHNO  = :BRANCHNO " & vbLf & _
              "   AND PERBILL_CSL.RSVNO  = :RSVNO       "
    

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        'オブジェクトの参照設定
    Set objFields = objOraDyna.Fields
    Set objPerCount = objFields("PERCOUNT")

    'レコードが存在しない　または　COUNT = 0 の場合
    If objOraDyna.EOF = True Or objPerCount.Value = 0 Then
        '個人請求書管理受診情報テーブルレコードの挿入
        strStmt = "INSERT INTO PERBILL_CSL (         " & vbLf & _
                  "                   DMDDATE,       " & vbLf & _
                  "                   BILLSEQ,       " & vbLf & _
                  "                   BRANCHNO,      " & vbLf & _
                  "                   RSVNO          "

        strStmt = strStmt & vbLf & _
                  "        ) VALUES (                " & vbLf & _
                  "                  :DMDDATE,       " & vbLf & _
                  "                  :BILLSEQ,       " & vbLf & _
                  "                  :BRANCHNO,      " & vbLf & _
                  "                  :RSVNO      )   "
     
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertPerBill_csl = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.InsertPerBill_csl"
    
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
' 機能　　 : 個人請求書管理個人情報テーブルにレコードを挿入する
'
' 引数　　 : (In)     strDmdDate            請求日
' 　　　　   (In)     lngBillSeq            請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo           請求書枝番
' 　　　　   (In)     vntPerId              個人ＩＤ
''
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertPerBill_person(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As Long, _
                                ByVal lngBranchNo As Long, _
                                ByVal vntPerID As Variant _
) As Boolean

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPerCount             As OraField         '件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PERID", vntPerID, ORAPARM_INPUT, ORATYPE_VARCHAR2
    

    strStmt = "SELECT COUNT(*) PERCOUNT                    " & vbLf & _
              "  FROM PERBILL_PERSON                       " & vbLf & _
              " WHERE PERBILL_PERSON.DMDDATE = :DMDDATE    " & vbLf & _
              "   AND PERBILL_PERSON.BILLSEQ  = :BILLSEQ   " & vbLf & _
              "   AND PERBILL_PERSON.BRANCHNO  = :BRANCHNO " & vbLf & _
              "   AND PERBILL_PERSON.PERID  = :PERID       "
    

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
        'オブジェクトの参照設定
    Set objFields = objOraDyna.Fields
    Set objPerCount = objFields("PERCOUNT")

    'レコードが存在しない　または　COUNT = 0 の場合
    If objOraDyna.EOF = True Or objPerCount.Value = 0 Then
        '個人請求書管理個人情報テーブルレコードの挿入
        strStmt = "INSERT INTO PERBILL_PERSON (      " & vbLf & _
                  "                   DMDDATE,       " & vbLf & _
                  "                   BILLSEQ,       " & vbLf & _
                  "                   BRANCHNO,      " & vbLf & _
                  "                   PERID          "

        strStmt = strStmt & vbLf & _
                  "        ) VALUES (                " & vbLf & _
                  "                  :DMDDATE,       " & vbLf & _
                  "                  :BILLSEQ,       " & vbLf & _
                  "                  :BRANCHNO,      " & vbLf & _
                  "                  :PERID     )    "
     
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertPerBill_person = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.InsertPerBill_person"
    
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
' 機能　　 : 個人請求詳細情報テーブルにレコードを挿入する
'
' 引数　　 : (In)     strDmdDate            請求日
' 　　　　   (In)     lngBillSeq            請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo           請求書枝番
' 　　　　   (In)     vntPrice              金額
' 　　　　   (In)     vntEditPrice          調整金額
' 　　　　   (In)     vntTaxPrice           税額
' 　　　　   (In)     vntEditTax            調整税額
' 　　　　   (In)     vntLineName           明細名称
' 　　　　   (In)     vntRsvNo              予約番号
' 　　　　   (In)     vntOtherLineDivCd     セット外明細コード
' 　　　　   (In)     vntPriceSeq           受診金額Ｓｅｑ（省略時、受診金額確定テーブルにも挿入）
' 　　　　   (In)     vntLineName_dmd       請求書詳細登録用　(2003.12.18 add )
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertPerBill_c(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As Long, _
                                ByVal lngBranchNo As Long, _
                                ByVal lngPrice As Long, _
                                ByVal lngEditPrice As Long, _
                                ByVal lngTaxPrice As Long, _
                                ByVal lngEditTax As Long, _
                                ByVal strLineName As String, _
                                ByVal lngRsvNo As Long, _
                                ByVal strOtherLineDivCd As String, _
                                Optional ByVal vntPriceSeq As Variant, _
                                Optional ByVal vntLineName_dmd As Variant _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim lngBillLineNo   As Long             '請求明細行No
    Dim lngPriceSeq     As Long             '受信金額ＳＥＱ
        
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '請求日あり？
    If strDmdDate <> "" Then
        '明細行Ｎｏ発番処理
        lngBillLineNo = GetBillLineNo(strDmdDate, lngBillSeq, lngBranchNo)
    
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    If strDmdDate <> "" Then
        objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BILLLINENO", lngBillLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    objOraParam.Add "PRICE", lngPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITPRICE", lngEditPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", lngTaxPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITTAX", lngEditTax, ORAPARM_INPUT, ORATYPE_NUMBER
    If strLineName <> "" Then
        objOraParam.Add "LINENAME", Trim(strLineName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    objOraParam.Add "OTHERLINEDIVCD", Trim(strOtherLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2


    '予約番号あり？　受診金額Ｓｅｑ無し？
    If CLng(lngRsvNo) <> 0 And IsMissing(vntPriceSeq) = True Then
        objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
        strStmt = "SELECT NVL(MAX(PRICESEQ)+1, 1) PRICESEQ " & vbLf & _
                  "  FROM CONSULT_M                        " & vbLf & _
                  " WHERE RSVNO = :RSVNO                   "

        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

        'レコードが存在しない場合は初期値を発番
        If objOraDyna.EOF Then
            lngPriceSeq = 1
        Else
            lngPriceSeq = objOraDyna.Fields("PRICESEQ").Value
        End If

        objOraParam.Add "PRICESEQ", lngPriceSeq, ORAPARM_INPUT, ORATYPE_NUMBER

        '受診金額確定テーブルにレコード挿入
        strStmt = "INSERT INTO CONSULT_M (               " & vbLf & _
                  "                       RSVNO,         " & vbLf & _
                  "                       PRICESEQ,      "
        If strLineName <> "" Then
            strStmt = strStmt & vbLf & _
                  "                       LINENAME,      "
        End If
        
        strStmt = strStmt & vbLf & _
                  "                       ORGCD1,        " & vbLf & _
                  "                       ORGCD2,        " & vbLf & _
                  "                       PRICE,         " & vbLf & _
                  "                       EDITPRICE,     " & vbLf & _
                  "                       TAXPRICE,      " & vbLf & _
                  "                       EDITTAX,       " & vbLf & _
                  "                       OTHERLINEDIVCD "
        If strDmdDate <> "" Then
            strStmt = strStmt & vbLf & _
                "                      ,DMDDATE,       " & vbLf & _
                "                       BILLSEQ,       " & vbLf & _
                "                       BRANCHNO,      " & vbLf & _
                "                       BILLLINENO     "
        End If

        strStmt = strStmt & vbLf & _
                "            ) VALUES (                " & vbLf & _
                "                      :RSVNO,         " & vbLf & _
                "                      :PRICESEQ,      "
        If strLineName <> "" Then
            strStmt = strStmt & vbLf & _
                "                      :LINENAME,      "
        End If
        strStmt = strStmt & vbLf & _
                "                      'XXXXX',        " & vbLf & _
                "                      'XXXXX',        " & vbLf & _
                "                      :PRICE,         " & vbLf & _
                "                      :EDITPRICE,     " & vbLf & _
                "                      :TAXPRICE,      " & vbLf & _
                "                      :EDITTAX,       " & vbLf & _
                "                      :OTHERLINEDIVCD "
        If strDmdDate <> "" Then
            strStmt = strStmt & vbLf & _
                "                    ,  :DMDDATE,      " & vbLf & _
                "                      :BILLSEQ,       " & vbLf & _
                "                      :BRANCHNO,      " & vbLf & _
                "                      :BILLLINENO     "
        End If
            strStmt = strStmt & vbLf & _
                "                    )                 "
    
'MsgBox "strStmt=" & strStmt
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    Else
        If CLng(lngRsvNo) <> 0 Then
            objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "PRICESEQ", vntPriceSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        End If

    End If

    '請求日あり？
    If strDmdDate <> "" Then
        '個人請求明細情報テーブルレコードの挿入
        strStmt = "INSERT INTO PERBILL_C (           " & vbLf & _
              "                       DMDDATE,       " & vbLf & _
              "                       BILLSEQ,       " & vbLf & _
              "                       BRANCHNO,      " & vbLf & _
              "                       BILLLINENO,    " & vbLf & _
              "                       PRICE,         " & vbLf & _
              "                       EDITPRICE,     " & vbLf & _
              "                       TAXPRICE,      " & vbLf & _
              "                       EDITTAX,       "
        If IsMissing(vntLineName_dmd) = False Then
            If vntLineName_dmd <> "" Then
                strStmt = strStmt & vbLf & _
                    "                       LINENAME,      "
            End If
        End If

        If lngRsvNo <> 0 Then
            strStmt = strStmt & vbLf & _
              "                       RSVNO,         " & vbLf & _
              "                       PRICESEQ,      "
        End If
        
        strStmt = strStmt & vbLf & _
              "                       OTHERLINEDIVCD "

        strStmt = strStmt & vbLf & _
              "            ) VALUES (                " & vbLf & _
              "                      :DMDDATE,       " & vbLf & _
              "                      :BILLSEQ,       " & vbLf & _
              "                      :BRANCHNO,      " & vbLf & _
              "                      :BILLLINENO,    " & vbLf & _
              "                      :PRICE,         " & vbLf & _
              "                      :EDITPRICE,     " & vbLf & _
              "                      :TAXPRICE,      " & vbLf & _
              "                      :EDITTAX,       "
        If IsMissing(vntLineName_dmd) = False Then
            If vntLineName_dmd <> "" Then
                objOraParam.Add "LINENAME_DMD", Trim(vntLineName_dmd), ORAPARM_INPUT, ORATYPE_VARCHAR2
                  strStmt = strStmt & vbLf & _
                      "                      :LINENAME_DMD,  "
            End If
        End If

        If lngRsvNo <> 0 Then
            strStmt = strStmt & vbLf & _
              "                      :RSVNO,         " & vbLf & _
              "                      :PRICESEQ,      "
        End If
        
        strStmt = strStmt & vbLf & _
              "                      :OTHERLINEDIVCD " & vbLf & _
              "              )"

     
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertPerBill_c = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.InsertPerBill_c"
    
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
' 機能　　 : セット外請求明細の削除を行う
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     lngPriceSeq           受診金額Ｓｅｑ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeletePerBill_c(ByVal lngRsvNo As Long, _
                                ByVal lngPriceSeq As Long _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim strDmdDate              As String           '請求日
    Dim vntBillSeq              As Variant          '請求書Ｓｅｑ
    Dim vntBranchNo             As Variant          '請求書枝番
    Dim vntBillLineNo           As Variant          '請求明細行No
    
    Dim lngPerBillDelFlg        As Long             '請求明細削除有無フラグ


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    lngPerBillDelFlg = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRICESEQ", lngPriceSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        
    strStmt = "SELECT DMDDATE, BILLSEQ, BRANCHNO, BILLLINENO    " & vbLf & _
              "  FROM CONSULT_M                                 " & vbLf & _
              " WHERE RSVNO = :RSVNO                            " & vbLf & _
              "   AND PRICESEQ = :PRICESEQ                      "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        strDmdDate = objOraDyna.Fields("DMDDATE").Value & ""
        vntBillSeq = objOraDyna.Fields("BILLSEQ").Value & ""
        vntBranchNo = objOraDyna.Fields("BRANCHNO").Value & ""
        vntBillLineNo = objOraDyna.Fields("BILLLINENO").Value & ""

        '個人請求明細情報のキーがある
        If strDmdDate <> "" Then
            'キー値の設定
            objOraParam.Add "DMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            objOraParam.Add "BILLSEQ", vntBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "BRANCHNO", vntBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "BILLLINENO", vntBillLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
            '個人請求明細情報削除
            strStmt = "DELETE PERBILL_C                     " & vbLf & _
                      " WHERE DMDDATE    = :DMDDATE         " & vbLf & _
                      "   AND BILLSEQ    = :BILLSEQ         " & vbLf & _
                      "   AND BRANCHNO   = :BRANCHNO        " & vbLf & _
                      "   AND BILLLINENO = :BILLLINENO      "
            
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
            lngPerBillDelFlg = 1
        End If
    End If
    
    '受診金額確定削除
    strStmt = "DELETE CONSULT_M                 " & vbLf & _
              " WHERE RSVNO = :RSVNO            " & vbLf & _
              "   AND PRICESEQ = :PRICESEQ      "
        
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '個人請求明細の削除を行ったか？
    If lngPerBillDelFlg = 1 Then
        strStmt = "SELECT COUNT(*) PERBILLCNT           " & vbLf & _
                  "  FROM PERBILL_C                     " & vbLf & _
                  " WHERE DMDDATE    = :DMDDATE         " & vbLf & _
                  "   AND BILLSEQ    = :BILLSEQ         " & vbLf & _
                  "   AND BRANCHNO   = :BRANCHNO        "
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        '明細が無くなった？
        If objOraDyna.Fields("PERBILLCNT").Value = 0 Then
            objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
            objOraParam.Add "USERID", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
            '請求書取消ストアド呼び出し
            mobjOraDb.ExecuteSQL "BEGIN :RET := DemandPackage.DeletePerBill(:DMDDATE,:BILLSEQ,:BRANCHNO,:USERID ); END;"
        End If
    End If
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeletePerBill_c = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.DeletePerBill_c"
    
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
' 機能　　 : 受診情報から個人請求書を作成する
'
' 引数　　 : (In)     lngSelectNo           MAX枚数
' 　　　　   (In)     strDmdDate            請求日
' 　　　　   (In)     vntRsvNo              予約番号
' 　　　　   (In)     vntPage               作成ページ（配列）
' 　　　　   (In)     vntAllPriceSeq        受診金額Ｓｅｑ（配列）
' 　　　　   (In)     vntUpdUser            更新者ＩＤ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function CreatePerBill_CSL(ByVal lngSelectNo As Long, _
                                  ByVal strDmdDate As String, _
                                  ByVal vntRsvNo As Variant, _
                                  ByVal vntPage As Variant, _
                                  ByVal vntAllPriceSeq As Variant, _
                                  ByVal vntUpdUser As Variant _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraSQLStmt           As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objBillSeq      As OraField         '請求書Ｓｅｑ
    
    Dim objBillLineNo   As OraParameter     '請求明細行No
    Dim objPriceSeq     As OraParameter     '受診金額Ｓｅｑ
    
    Dim lngBillSeq      As Long             '請求書Ｓｅｑ
    Dim lngBillLineNo   As Long             '請求明細行No
    
    Dim vntPriceSeq     As Variant          '受診金額Ｓｅｑ
        
    Dim i               As Long             'カウンタ
    Dim j               As Long             'カウンタ
    
    Dim cnt             As Long             '明細数
    
    Dim blnAns          As Long             '関数復帰値
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    

    For j = 0 To lngSelectNo - 1
        cnt = 0
        For i = 0 To UBound(vntAllPriceSeq)
            If CLng(vntPage(i)) = CLng(j + 1) Then
                If cnt = 0 Then
                    vntPriceSeq = Array()
                End If
                ReDim Preserve vntPriceSeq(cnt)
                vntPriceSeq(cnt) = vntAllPriceSeq(i)
                cnt = cnt + 1
            End If
        Next i
        
        If cnt > 0 Then
            'キー及び更新値の設定
            Set objOraParam = mobjOraDb.Parameters
            objOraParam.Add "NEWDMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            '請求書Ｓｅｑ　取得
            strStmt = "SELECT NVL(MAX(BILLSEQ) + 1, 1) MAXBILLSEQ    " & vbLf & _
                    "  FROM PERBILL                                " & vbLf & _
                    " WHERE PERBILL.DMDDATE = :NEWDMDDATE             "
    
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objBillSeq = objFields("MAXBILLSEQ")
    
            lngBillSeq = objBillSeq.Value
    
            '明細行Ｎｏ発番処理
            lngBillLineNo = GetBillLineNo(strDmdDate, lngBillSeq, 0)
    

            'キー及び更新値の設定
            Set objOraParam = mobjOraDb.Parameters
            objOraParam.Add "NEWDMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            objOraParam.Add "NEWBILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "UPDUSER", vntUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
            '個人請求書管理テーブルレコードの挿入
            strStmt = " INSERT INTO PERBILL (" & vbLf & _
                    "                      DMDDATE, " & vbLf & _
                    "                      BILLSEQ, " & vbLf & _
                    "                      BRANCHNO," & vbLf & _
                    "                      DELFLG,  " & vbLf & _
                    "                      UPDDATE, " & vbLf & _
                    "                      UPDUSER  "
            strStmt = strStmt & vbLf & _
                    "            ) VALUES (                " & vbLf & _
                    "                      :NEWDMDDATE,    " & vbLf & _
                    "                      :NEWBILLSEQ,    " & vbLf & _
                    "                      0,              " & vbLf & _
                    "                      0,              " & vbLf & _
                    "                      SYSDATE,        " & vbLf & _
                    "                      :UPDUSER        " & vbLf & _
                    "            )                         "
    
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)


            objOraParam.Add "NEWRSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
            objOraParam.Add "BILLLINENO", Null, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "PRICESEQ", Null, ORAPARM_INPUT, ORATYPE_NUMBER
            Set objBillLineNo = objOraParam("BILLLINENO")
            Set objPriceSeq = objOraParam("PRICESEQ")
            '個人請求明細情報テーブルレコードの挿入
            strStmt = "INSERT INTO PERBILL_C (           " & vbLf & _
                    "                       DMDDATE,       " & vbLf & _
                    "                       BILLSEQ,       " & vbLf & _
                    "                       BRANCHNO,      " & vbLf & _
                    "                       BILLLINENO,    " & vbLf & _
                    "                       PRICE,         " & vbLf & _
                    "                       EDITPRICE,     " & vbLf & _
                    "                       TAXPRICE,      " & vbLf & _
                    "                       EDITTAX,       " & vbLf & _
                    "                       LINENAME,      " & vbLf & _
                    "                       CTRPTCD,       " & vbLf & _
                    "                       OPTCD,         " & vbLf & _
                    "                       OPTBRANCHNO,   " & vbLf & _
                    "                       RSVNO,         " & vbLf & _
                    "                       PRICESEQ,      " & vbLf & _
                    "                       OTHERLINEDIVCD)"
        
            strStmt = strStmt & vbLf & _
                    "         SELECT                       " & vbLf & _
                    "                :NEWDMDDATE,          " & vbLf & _
                    "                :NEWBILLSEQ,          " & vbLf & _
                    "                0,                    " & vbLf & _
                    "                :BILLLINENO,          " & vbLf & _
                    "                MAINVIEW.PRICE,       " & vbLf & _
                    "                MAINVIEW.EDITPRICE,   " & vbLf & _
                    "                MAINVIEW.TAXPRICE,    " & vbLf & _
                    "                MAINVIEW.EDITTAX,     "
            
            strStmt = strStmt & vbLf & _
                    "                CASE      " & vbLf & _
                    "                    WHEN MAINVIEW.LINENAME IS NOT NULL  THEN MAINVIEW.LINENAME " & vbLf & _
                    "                    WHEN CTRPT_PRICE.BILLPRINTNAME IS NOT NULL  THEN CTRPT_PRICE.BILLPRINTNAME" & vbLf & _
                    "                    ELSE MAINVIEW.OPTNAME " & vbLf & _
                    "                END LINENAME, "
              
            strStmt = strStmt & vbLf & _
                    "                MAINVIEW.CTRPTCD,       " & vbLf & _
                    "                MAINVIEW.OPTCD,         " & vbLf & _
                    "                MAINVIEW.OPTBRANCHNO,   " & vbLf & _
                    "                :NEWRSVNO,              " & vbLf & _
                    "                :PRICESEQ,              " & vbLf & _
                    "                MAINVIEW.OTHERLINEDIVCD "
        
            strStmt = strStmt & vbLf & _
                    "           FROM CTRPT_PRICE,                                          " & vbLf & _
                    "                ( SELECT CONSULT_M.ORGCD1, CONSULT_M.ORGCD2,          " & vbLf & _
                    "                         ORGSEQVIEW.ORGSEQ,                           " & vbLf & _
                    "                         ORG.ORGNAME,                                 " & vbLf & _
                    "                         CONSULT_M.PRICE, CONSULT_M.EDITPRICE,        " & vbLf & _
                    "                         CONSULT_M.TAXPRICE, CONSULT_M.EDITTAX,       " & vbLf & _
                    "                         (CONSULT_M.PRICE + CONSULT_M.EDITPRICE + CONSULT_M.TAXPRICE + CONSULT_M.EDITTAX) LINETOTAL," & vbLf & _
                    "                         CONSULT_M.PRICESEQ,                          " & vbLf & _
                    "                         CONSULT_M.CTRPTCD,  CONSULT_M.OPTCD,         " & vbLf & _
                    "                         CONSULT_M.OPTBRANCHNO,                       " & vbLf & _
                    "                         CONSULT_M.OTHERLINEDIVCD,                    " & vbLf & _
                    "                         NVL(CTRPT_OPT.OPTNAME, OTHERLINEDIV.OTHERLINEDIVNAME) OPTNAME," & vbLf & _
                    "                         CONSULT_M.LINENAME"
            strStmt = strStmt & vbLf & _
                    "                    FROM OTHERLINEDIV,                                " & vbLf & _
                    "                         ( SELECT CTRPT_ORG.SEQ ORGSEQ,               " & vbLf & _
                    "                                  NVL(CTRPT_ORG.ORGCD1, CONSULT.ORGCD1) ORGCD1,       " & vbLf & _
                    "                                  NVL(CTRPT_ORG.ORGCD2, CONSULT.ORGCD2) ORGCD2        " & vbLf & _
                    "                             FROM CTRPT_ORG, CONSULT                  " & vbLf & _
                    "                            WHERE CONSULT.RSVNO     = :NEWRSVNO       " & vbLf & _
                    "                              AND CTRPT_ORG.CTRPTCD = CONSULT.CTRPTCD " & vbLf & _
                    "                         ) ORGSEQVIEW,                                " & vbLf & _
                    "                         CTRPT_OPT, ORG, CONSULT_M                    "

            strStmt = strStmt & vbLf & _
                    "                   WHERE CONSULT_M.RSVNO          = :NEWRSVNO                " & vbLf & _
                    "                     AND CONSULT_M.PRICESEQ       = :PRICESEQ                " & vbLf & _
                    "                     AND ORG.ORGCD1               = CONSULT_M.ORGCD1         " & vbLf & _
                    "                     AND ORG.ORGCD2               = CONSULT_M.ORGCD2         " & vbLf & _
                    "                     AND CONSULT_M.ORGCD1         = 'XXXXX'                  " & vbLf & _
                    "                     AND CONSULT_M.ORGCD2         = 'XXXXX'                  " & vbLf & _
                    "                     AND CONSULT_M.CTRPTCD        = CTRPT_OPT.CTRPTCD     (+)" & vbLf & _
                    "                     AND CONSULT_M.OPTCD          = CTRPT_OPT.OPTCD       (+)" & vbLf & _
                    "                     AND CONSULT_M.OPTBRANCHNO    = CTRPT_OPT.OPTBRANCHNO (+)" & vbLf & _
                    "                     AND ORGSEQVIEW.ORGCD1        = CONSULT_M.ORGCD1         " & vbLf & _
                    "                     AND ORGSEQVIEW.ORGCD2        = CONSULT_M.ORGCD2         " & vbLf & _
                    "                     AND CONSULT_M.OTHERLINEDIVCD = OTHERLINEDIV.OTHERLINEDIVCD (+)    " & vbLf & _
                    "                ) MAINVIEW                                                   " & vbLf & _
                    "          WHERE MAINVIEW.CTRPTCD     = CTRPT_PRICE.CTRPTCD     (+)           " & vbLf & _
                    "            AND MAINVIEW.OPTCD       = CTRPT_PRICE.OPTCD       (+)           " & vbLf & _
                    "            AND MAINVIEW.OPTBRANCHNO = CTRPT_PRICE.OPTBRANCHNO (+)           " & vbLf & _
                    "            AND MAINVIEW.ORGSEQ      = CTRPT_PRICE.SEQ         (+)           "
    
            For i = 0 To UBound(vntPriceSeq)
        
                objBillLineNo.Value = lngBillLineNo + i
                objPriceSeq.Value = CLng(vntPriceSeq(i))

                'SQL文の実行
                If objOraSQLStmt Is Nothing Then
                    Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
                Else
                    objOraSQLStmt.Refresh
                End If

            Next i

            '個人請求書管理受診情報テーブルにレコード挿入
            blnAns = InsertPerBill_csl(strDmdDate, lngBillSeq, 0, vntRsvNo)
    
            'キー及び更新値の設定
            Set objOraParam = mobjOraDb.Parameters
            objOraParam.Add "NEWDMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            objOraParam.Add "NEWBILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "NEWRSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "BILLLINENO", Null, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "PRICESEQ", Null, ORAPARM_INPUT, ORATYPE_NUMBER
            '受診金額確定に請求情報更新
            strStmt = " UPDATE CONSULT_M                   " & vbLf & _
                    "    SET DMDDATE  = :NEWDMDDATE,       " & vbLf & _
                    "        BILLSEQ  = :NEWBILLSEQ,       " & vbLf & _
                    "        BRANCHNO = 0                  " & vbLf & _
                    "        BILLLINENO = :BILLLINENO      " & vbLf & _
                    "  WHERE CONSULT_M.RSVNO = :NEWRSVNO   " & vbLf & _
                    "    AND CONSULT_M.PRICESEQ = :PRICESEQ" & vbLf & _
                    "    AND CONSULT_M.ORGCD1 = 'XXXXX'    " & vbLf & _
                    "    AND CONSULT_M.ORGCD2 = 'XXXXX'    "
    
            For i = 0 To UBound(vntPriceSeq)
        
                objBillLineNo.Value = lngBillLineNo + i
                objPriceSeq.Value = CLng(vntPriceSeq(i))

                'SQL文の実行
                If objOraSQLStmt Is Nothing Then
                    Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
                Else
                    objOraSQLStmt.Refresh
                End If

            Next i
    
            'バインド変数の削除
            Do Until objOraParam.Count <= 0
                objOraParam.Remove (objOraParam.Count - 1)
            Loop
        End If
    Next j
    
    '戻り値の設定
    CreatePerBill_CSL = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.CreatePerBill_CSL"
    
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
' 機能　　 : 個人請求書の新規作成、および修正をする
'
' 引数　　 : (In)     strMode               モード　insert:新規作成　update:修正
' 　　　　   (In)     strDmdDate            請求日
' 　　　　   (In)     vntPerId              個人ＩＤ（配列）
' 　　　　   (In)     vntPrice              金額（配列）
' 　　　　   (In)     vntEditPrice          調整金額（配列）
' 　　　　   (In)     vntTaxPrice           税額（配列）
' 　　　　   (In)     vntEditTax            調整税額（配列）
' 　　　　   (In)     vntLineName           明細名称（配列）
' 　　　　   (In)     vntOtherLineDivCd     セット外明細コード（配列）
' 　　　　   (In)     vntBillcomment        請求書コメント
' 　　　　   (In)     vntUpdUser            更新者ＩＤ
' 　　　　   (IN/OUT)    vntBillSeq            請求書Ｓｅｑ
' 　　　　   (IN/OUT)    vntBranchNo           請求書枝番
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function CreatePerBill_PERSON(ByVal strMode As String, _
                                  ByVal strDmdDate As String, _
                                  ByVal vntPerID As Variant, _
                                  ByVal vntPrice As Variant, _
                                  ByVal vntEditPrice As Variant, _
                                  ByVal vntTaxPrice As Variant, _
                                  ByVal vntEditTax As Variant, _
                                  ByVal vntLineName As Variant, _
                                  ByVal vntOtherLineDivCd As Variant, _
                                  ByVal vntBillcomment As Variant, _
                                  ByVal vntUpdUser As Variant, _
                                  ByRef vntBillSeq As Variant, _
                                  ByRef vntBranchNo As Variant _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraSQLStmt           As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objBillSeq      As OraField         '請求書Ｓｅｑ
    
    Dim objBillLineNo   As OraParameter     '請求明細行No
    
    Dim lngBillSeq      As Long             '請求書Ｓｅｑ
    Dim lngBranchNo     As Long             '請求書枝番
    Dim lngBillLineNo   As Long             '請求明細行No
    
        
    Dim i               As Long             'カウンタ
    Dim j               As Long             'カウンタ
    
    
    Dim blnAns          As Long             '関数復帰値
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    '修正の場合はいったんDELETEしてから、新規作成と同じ処理をする
    If strMode = "update" Then
            blnAns = DeletePerBill(strDmdDate, vntBillSeq, vntBranchNo, vntUpdUser)
    End If
        
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "NEWDMDDATE", Format(Trim(strDmdDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLCOMMENT", Trim(vntBillcomment), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", vntUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    If strMode = "insert" Then
        '請求書Ｓｅｑ　取得
        strStmt = "SELECT NVL(MAX(BILLSEQ) + 1, 1) MAXBILLSEQ    " & vbLf & _
                  "  FROM PERBILL                                " & vbLf & _
                  " WHERE PERBILL.DMDDATE = :NEWDMDDATE             "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillSeq = objFields("MAXBILLSEQ")
    
        lngBillSeq = objBillSeq.Value
        lngBranchNo = 0
    Else
        lngBillSeq = vntBillSeq
        lngBranchNo = vntBranchNo
    End If
    
    objOraParam.Add "NEWBILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NEWBRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

    
    '個人請求書管理テーブルレコードの挿入
    strStmt = " INSERT INTO PERBILL (" & vbLf & _
            "                      DMDDATE, " & vbLf & _
            "                      BILLSEQ, " & vbLf & _
            "                      BRANCHNO," & vbLf & _
            "                      DELFLG,  " & vbLf & _
            "                      UPDDATE, " & vbLf & _
            "                      UPDUSER, " & vbLf & _
            "                      BILLCOMMENT  "
    strStmt = strStmt & vbLf & _
            "            ) VALUES (                " & vbLf & _
            "                      :NEWDMDDATE,    " & vbLf & _
            "                      :NEWBILLSEQ,    " & vbLf & _
            "                      :NEWBRANCHNO,   " & vbLf & _
            "                      0,              " & vbLf & _
            "                      SYSDATE,        " & vbLf & _
            "                      :UPDUSER,       " & vbLf & _
            "                      :BILLCOMMENT    " & vbLf & _
            "            )                         "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)


    For i = 0 To UBound(vntPrice)
        If IsNumeric(vntPrice(i)) = True Then
            '個人請求明細情報テーブルレコードの挿入
            blnAns = InsertPerBill_c(strDmdDate, lngBillSeq, lngBranchNo, vntPrice(i), vntEditPrice(i), _
                                vntTaxPrice(i), vntEditTax(i), vntLineName(i), 0, vntOtherLineDivCd(i), , vntLineName(i))
        End If
    Next i


    '個人請求書管理個人情報テーブルにレコード挿入
    For i = 0 To UBound(vntPerID)
        If vntPerID(i) <> "" Then
            blnAns = InsertPerBill_person(strDmdDate, lngBillSeq, lngBranchNo, vntPerID(i))
        End If
    Next i
    
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    If strMode = "insert" Then
        vntBillSeq = lngBillSeq
        vntBranchNo = 0
    End If
    
    CreatePerBill_PERSON = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.CreatePerBill_PERSON"
    
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
' 機能　　 : 請求書Ｎｏをキーに請求書コメントを更新する
'
' 引数　　 : (In)     strDmdDate            請求日
' 　　　　   (In)     lngBillSeq            請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo           請求書枝番
' 　　　　   (In)     vntBillcomment        請求書コメント
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdatePerBill_coment(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As String, _
                                ByVal lngBranchNo As String, _
                                ByVal vntBillcomment As Variant _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    
    Dim objBillcomment         As OraParameter     '請求書コメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Trim(strDmdDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "BILLCOMMENT", Trim(vntBillcomment), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    '個人請求管理情報テーブル　請求書コメントの更新
    strStmt = "UPDATE PERBILL                      " & vbLf & _
              "   SET BILLCOMMENT = :BILLCOMMENT   "
    
    strStmt = strStmt & vbLf & _
              " WHERE PERBILL.DMDDATE = :DMDDATE   " & vbLf & _
              "   AND PERBILL.BILLSEQ = :BILLSEQ   " & vbLf & _
              "   AND PERBILL.BRANCHNO = :BRANCHNO "
     
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdatePerBill_coment = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.UpdatePerBill_coment"
    
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
' 機能　　 : 請求書Ｎｏをキーに請求書管理情報を更新する
'
' 引数　　 : (In)     strDmdDate            請求日
' 　　　　   (In)     lngBillSeq            請求書Ｓｅｑ
' 　　　　   (In)     lngBranchNo           請求書枝番
' 　　　　   (In)     vntBillName           請求書宛先
' 　　　　   (In)     vntKeishou            敬称
' 　　　　   (In)     vntPrintDate          領収書印刷日
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdatePerBill(ByVal strDmdDate As String, _
                                ByVal lngBillSeq As String, _
                                ByVal lngBranchNo As String, _
                                Optional ByRef vntBillName As Variant, _
                                Optional ByRef vntKeishou As Variant, _
                                Optional ByRef vntPrintDate As Variant _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim blnUpdChk               As Boolean          '更新有無チェック
    
    Dim objBillcomment         As OraParameter     '請求書コメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDDATE", Trim(strDmdDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    If Not IsMissing(vntBillName) Then
        objOraParam.Add "BILLNAME", Trim(vntBillName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    If Not IsMissing(vntKeishou) Then
        objOraParam.Add "KEISHOU", Trim(vntKeishou), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    If Not IsMissing(vntPrintDate) Then
        objOraParam.Add "PRINTDATE", Trim(vntPrintDate), ORAPARM_INPUT, ORATYPE_DATE
    End If
    
    
    blnUpdChk = False
    '個人請求管理情報テーブル　請求書コメントの更新
    strStmt = "UPDATE PERBILL                      "
    If Not IsMissing(vntBillName) Then
        strStmt = strStmt & vbLf & _
              "   SET BILLNAME = :BILLNAME   "
        blnUpdChk = True
    End If
    If Not IsMissing(vntKeishou) Then
        If blnUpdChk = True Then
            strStmt = strStmt & vbLf & _
              "     , KEISHOU = :KEISHOU   "
        Else
            strStmt = strStmt & vbLf & _
              "   SET KEISHOU = :KEISHOU   "
        End If
        blnUpdChk = True
    End If
    If Not IsMissing(vntPrintDate) Then
        If blnUpdChk = True Then
            strStmt = strStmt & vbLf & _
              "     , PRINTDATE = :PRINTDATE   "
        Else
            strStmt = strStmt & vbLf & _
              "   SET PRINTDATE = :PRINTDATE   "
        End If
        blnUpdChk = True
    End If
    
    strStmt = strStmt & vbLf & _
              " WHERE PERBILL.DMDDATE = :DMDDATE   " & vbLf & _
              "   AND PERBILL.BILLSEQ = :BILLSEQ   " & vbLf & _
              "   AND PERBILL.BRANCHNO = :BRANCHNO "
     
    If blnUpdChk = True Then
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdatePerBill = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerBill.UpdatePerBill"
    
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
