VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Judgement"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession   As OraSession      'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase     'OraDatabaseオブジェクト
Private Const GDECMT_GRPCD         As String = "X051"    '生活指導コメント導出用グループコード
Private Const DISEASECMT_GRPCD     As String = "X055"    '現病歴コメント導出用グループコード

'### メタボリックシンドローム判定コメント特殊処理用追加 2006.06.12 張 Start
Private Const METACMT_GRPCD        As String = "X068"    'メタボリックシンドロームコメント導出用グループコード
'### メタボリックシンドローム判定コメント特殊処理用追加 2006.06.12 張 End

'### 喫煙コメント自動登録処理用グループコード設定 2008.05.07 張 Start ###
Private Const SMKCMT_GRPCD         As String = "X054"    '喫煙コメント導出用グループコード
'### 喫煙コメント自動登録処理用グループコード設定 2008.05.07 張 End   ###

Private Const GDECMT_DISPMODE      As Long = 2           '総合コメント表示モード（生活指導）
Private Const TOTALCMT_DISPMODE    As Long = 1           '総合コメント表示モード（総合コメント）
Private Const KNOWLEVEL_ITEMCD     As String = "64670"   '認識レベル　検査項目コード
Private Const KNOWLEVEL_SUFFIX     As String = "00"      '認識レベル　サフィックス
Private Const NYUBOU_JUDCLASSCD    As Long = 24          '乳房　判定分類コード
'### 眼科判定特殊処理用追加 2004.01.14 start
Private Const GANKA_JUDCLASSCD     As Long = 20          '眼科・眼圧　判定分類コード
Private Const ATSU_ITEMCD          As String = "11161"   '眼圧　検査項目コード
Private Const RAGAN_ITEMCD         As String = "11020"   '裸眼　検査項目コード
Private Const KYOU_ITEMCD          As String = "11022"   '矯正　検査項目コード
'### 眼科判定特殊処理用追加 2004.01.14 end
'### 内視鏡判定コメント特殊処理用追加 2004.01.14 start
Private Const TOP_ITEMCD           As String = "23200"   '内視鏡上部　検査項目コード
Private Const TOP_SUFFIX           As String = "00"      '内視鏡上部　サフィックス
Private Const LOWER1_ITEMCD        As String = "23710"   '内視鏡下部　主治医の指示　検査項目コード
Private Const LOWER1_SUFFIX        As String = "00"      '内視鏡下部　主治医の指示　サフィックス
Private Const LOWER2_ITEMCD        As String = "23711"   '内視鏡下部　次回内視鏡健保　検査項目コード
Private Const LOWER2_SUFFIX        As String = "00"      '内視鏡下部　次回内視鏡健保　サフィックス
'### 内視鏡判定コメント特殊処理用追加 2004.01.14 end

'### メタボリックシンドローム判定コメント特殊処理用追加 2006.06.12 張 Start
Private Const METACMT_CMTCD        As String = "105001"    'メタボリックシンドロームコメントコード
Private Const METACMT_CMTCD2       As String = "105002"    'メタボリックシンドロームコメントコード２
Private Const GLYCEMIA_ITEMCD      As String = "17520"   '空腹時血糖　検査項目コード
Private Const GLYCEMIA_SUFFIX      As String = "00"      '空腹時血糖　サフィックス
Private Const HDL_ITEMCD           As String = "17423"   'HDL　検査項目コード
Private Const HDL_SUFFIX           As String = "00"      'HDL　サフィックス
Private Const TG_ITEMCD            As String = "17420"   'TG　検査項目コード
Private Const TG_SUFFIX            As String = "00"      'TG　サフィックス
Private Const CBP_ITEMCD           As String = "13120"   '収縮期血圧　検査項目コード
Private Const CBP_SUFFIX           As String = "01"      '収縮期血圧　サフィックス
Private Const EBP_ITEMCD           As String = "13120"   '拡張期血圧　検査項目コード
Private Const EBP_SUFFIX           As String = "02"      '拡張期血圧　サフィックス
Private Const WAIST_ITEMCD         As String = "10041"   '腹囲　検査項目コード
Private Const WAIST_SUFFIX         As String = "00"      '腹囲　サフィックス
'### メタボリックシンドローム判定コメント特殊処理用追加 2006.06.12 張 End

'### メタボリックシンドローム判定ロジック変更（2008年4月1日以降受診者から）によって追加 2008.03.04 張 Start
Private Const METACMT_NEWCD        As String = "105005"  'メタボリックシンドロームコメントコード（基準に該当）
Private Const METACMT_NEWCD2       As String = "105004"  'メタボリックシンドロームコメントコード２（予備群に該当）
Private Const METACMT_NEWCD3       As String = "105003"  'メタボリックシンドロームコメントコード３（該当しない）
Private Const HBA1C_ITEMCD         As String = "17522"   'HbA1c(JDS)　検査項目コード
Private Const HBA1C_SUFFIX         As String = "00"      'HbA1c(JDS)　サフィックス
'### 2013.03.30 張 2013年4月1日からHbA1c検査項目変更に伴うコード追加
Private Const HBA1C_NGSP_ITEMCD    As String = "17524"   'HbA1c(NGSP)　検査項目コード
Private Const HBA1C_NGSP_SUFFIX    As String = "00"      'HbA1c(NGSP)　サフィックス
'### メタボリックシンドローム判定ロジック変更（2008年4月1日以降受診者から）によって追加 2008.03.04 張 End


'### 骨密度判定特殊処理用追加 2007.11.19 張 Start
Private Const KOTSU_JUDCLASSCD     As Long = 23          '骨密度　判定分類コード
Private Const TSCORE_ITEMCD        As String = "26615"   'Ｔスコア　検査項目コード
Private Const TSCORE_SUFFIX        As String = "00"      'Ｔスコア　サフィックス
Private Const SMOKE_ITEMCD         As String = "63070"   '喫煙　検査項目コード
Private Const SMOKE_SUFFIX         As String = "00"      '喫煙　サフィックス
Private Const KOTSU_CMTCD_D1       As String = "102303"  '骨密度（D1）コメントコード
'### 骨密度判定特殊処理用追加 2007.11.19 張 End

'桁数
Private Const LENGTH_TOTALJUDCMT_RSVNO    As Integer = 9      '予約番号
Private Const LENGTH_TOTALJUDCMT_DISPMODE As Integer = 1      '表示分類
Private Const LENGTH_TOTALJUDCMT_SEQ      As Integer = 3      '表示順
Private Const LENGTH_TOTALJUDCMT_JUDCMTCD As Integer = 8      '判定コメントコード


'
' 機能　　 : 判定入力チェック
'
' 引数　　 : (In)     strDoctorCd     判定医コード
' 　　　　 : (In)     vntJudClassCd   判定分類コード
' 　　　　 : (In)     vntJudClassName 判定分類名称
' 　　　　 : (In)     vntJudCd        判定コード
' 　　　　 : (In)     vntFreeJudCmt   フリー判定コード
' 　　　　 : (In)     vntJudDoctorCd  判定医コード
'
' 戻り値　 : エラーメッセージ
'
' 備考　　 :
'
Public Function CheckValue(ByVal strDoctorCd As String, _
                           ByVal vntJudClassCd As Variant, _
                           ByVal vntJudClassName As Variant, _
                           ByVal vntJudCd As Variant, _
                           ByVal vntStdJudCd As Variant, _
                           ByRef vntFreeJudCmt As Variant, _
                           ByVal vntJudDoctorCd As Variant _
                          ) As Variant

    Dim objCommon               As Common       '共通クラス
    Dim objJud                  As Object       '判定クラス
    Dim objStdJud               As Object       '定型所見クラス
    Dim objHainsUser            As Object       'ユーザクラス

    Dim vntArrJudClassCd()      As Variant      '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant      '判定分類名称の配列
    Dim vntArrJudCd()           As Variant      '判定コードの配列
    Dim vntArrStdJudCd()        As Variant      '定型所見コードの配列
    Dim vntArrFreeJudCmt()      As Variant      'フリー判定コメントの配列
    Dim vntArrJudDoctorCd()     As Variant      '判定医コードの配列
    
    Dim vntArrMessage           As Variant      'エラーメッセージの集合
    
    Dim strStdJudCd()           As String       '定型所見コード
    
    Dim i                       As Long         'インデックス
    Dim j                       As Long         'インデックス
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    '判定クラスのインスタンス作成
    Set objJud = mobjContext.CreateInstance("HainsJud.Jud")
    
    '定型所見クラスのインスタンス作成
    Set objStdJud = mobjContext.CreateInstance("HainsStdJud.StdJud")
    
    'ユーザクラスのインスタンス作成
    Set objHainsUser = mobjContext.CreateInstance("HainsHainsUser.HainsUser")

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '判定分類が配列の場合
    If IsArray(vntJudClassCd) Then
        '判定分類名・判定コード・定型所見コード・フリー判定コメント・判定医コードが配列でない場合は処理終了
        If Not IsArray(vntJudClassName) Or _
           Not IsArray(vntJudCd) Or _
           Not IsArray(vntStdJudCd) Or _
           Not IsArray(vntFreeJudCmt) Or _
           Not IsArray(vntJudDoctorCd) Then
            Err.Raise 9     '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        '判定分類名・判定コード・定型所見コード・フリー判定コメント・判定医コードのサイズが一致しない場合は処理終了
        If UBound(vntJudClassCd) <> UBound(vntJudClassName) Or _
           UBound(vntJudClassCd) <> UBound(vntJudCd) Or _
           UBound(vntJudClassCd) <> UBound(vntStdJudCd) Or _
           UBound(vntJudClassCd) <> UBound(vntFreeJudCmt) Or _
           UBound(vntJudClassCd) <> UBound(vntJudDoctorCd) Then
            Err.Raise 9     '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        vntArrJudClassCd = vntJudClassCd
        vntArrJudClassName = vntJudClassName
        vntArrJudCd = vntJudCd
        vntArrStdJudCd = vntStdJudCd
        vntArrFreeJudCmt = vntFreeJudCmt
        vntArrJudDoctorCd = vntJudDoctorCd
    Else
        '判定分類名・判定コード・定型所見コード・フリー判定コメント・判定医コードが配列の場合は処理終了
        If IsArray(vntJudClassName) Or _
           IsArray(vntJudCd) Or _
           IsArray(vntStdJudCd) Or _
           IsArray(vntFreeJudCmt) Or _
           IsArray(vntJudDoctorCd) Then
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        ReDim vntArrJudClassCd(0)
        ReDim vntArrJudClassName(0)
        ReDim vntArrJudCd(0)
        ReDim vntArrStdJudCd(0)
        ReDim vntArrFreeJudCmt(0)
        ReDim vntArrJudDoctorCd(0)
        vntArrJudClassCd(0) = vntJudClassCd
        vntArrJudClassName(0) = vntJudClassName
        vntArrJudCd(0) = vntJudCd
        vntArrStdJudCd(0) = vntStdJudCd
        vntArrFreeJudCmt(0) = vntFreeJudCmt
        vntArrJudDoctorCd(0) = vntJudDoctorCd
    End If
    
    With objCommon
        If strDoctorCd <> "" Then
            '判定医コードチェック
            If Not objHainsUser.SelectUserName(strDoctorCd) Then
                .AppendArray vntArrMessage, "登録されていない判定医コードです"
            End If
        End If
        For i = 0 To UBound(vntArrJudClassCd)
            If vntArrJudCd(i) <> "" Then
                '判定コードチェック
                If Not objJud.SelectJud(vntArrJudCd(i)) Then
                    .AppendArray vntArrMessage, vntArrJudClassName(i) & ":登録されていない判定コードです"
                End If
            End If
            If vntArrStdJudCd(i) <> "" Then
                strStdJudCd = Split(vntArrStdJudCd(i), ",")
                For j = 0 To UBound(strStdJudCd)
                    If Not objStdJud.SelectStdJudNote(vntArrJudClassCd(i), strStdJudCd(j)) Then
                        .AppendArray vntArrMessage, vntArrJudClassName(i) & ":" & strStdJudCd(j) & ":登録されていない定型所見コードです"
                    End If
                Next j
            End If
            'フリー判定コメントチェック
            .AppendArray vntArrMessage, .CheckWideValue(vntArrJudClassName(i) & ":コメント", vntArrFreeJudCmt(i), LENGTH_JUDRSL_FREEJUDCMT)
            If vntArrJudDoctorCd(i) <> "" Then
                '判定医コードチェック
                If Not objHainsUser.SelectUserName(vntArrJudDoctorCd(i), 1) Then
                    .AppendArray vntArrMessage, vntArrJudClassName(i) & ":登録されていない判定医コードです"
                End If
            End If
        Next i
    End With

    'メッセージを返す
    CheckValue = vntArrMessage
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.CheckValue"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 判定結果テーブルレコードを削除する
'
' 引数　　 : (In)     lngRsvNo  予約番号
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteJudRsl(ByVal lngRsvNo As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の判定情報テーブルレコードを削除
    strStmt = "DELETE JUDRSL         " & vbLf & _
              " WHERE RSVNO = :RSVNO "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    objOraParam.Remove "RSVNO"
    
    '戻り値の設定
    DeleteJudRsl = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteJudRsl = False

    'イベントログ書き込み
    WriteErrorLog "Judgement.DeleteJudRsl"
    
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
' 機能　　 : 判定結果をクリアする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     strPerId           個人ID
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     strJudClassCd      判定分類コード
' 　　　　   (In)     blnTotalJudgeOnly  True時、総合判定用判定分類の判定結果のみクリア
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteJudRslClear( _
    ByVal dtmCslDate As Date, _
    ByVal strPerId As String, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal blnTotalJudgeOnly As Boolean _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    If Trim(strPerId) <> "" Then
        objOraParam.Add "PERID", CLng(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2002.6.4 Add 3Lines by T.Takagi(FSIT) 判定分類指定
    If Trim(strJudClassCd) <> "" Then
        objOraParam.Add "JUDCLASSCD", CLng(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2002.6.4 Add End
    
    'クリアすべき判定結果情報を検索
    strStmt = "DELETE JUDRSL                                       " & vbLf & _
              " WHERE ( RSVNO, JUDCLASSCD ) IN                     " & vbLf & _
              "       ( SELECT CONSULT.RSVNO, CURJUDRSL.JUDCLASSCD " & vbLf & _
              "           FROM JUDCLASS,                           " & vbLf & _
              "                JUDRSL CURJUDRSL,                   " & vbLf & _
              "                CONSULT,                            " & vbLf & _
              "                RECEIPT                             "

    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE      = :CSLDATE      " & vbLf & _
              "            AND RECEIPT.RSVNO        = CONSULT.RSVNO "

    '個人ID指定時は条件節に加える
    If Trim(strPerId) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.PERID       >= :PERID "
    End If
              

    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD         = :CSCD "
    End If

    '対象受診者の現判定結果情報を取得
    strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVNO        = CURJUDRSL.RSVNO "
              
    '判定分類の総合判定フラグを取得
    strStmt = strStmt & vbLf & _
              "            AND CURJUDRSL.JUDCLASSCD = JUDCLASS.JUDCLASSCD "

    '総合判定用判定分類は無条件にクリア対象とする
    'フラグ非成立時は判定分類内検査項目が基準値判定情報を所有している場合にクリア対象とする
    If blnTotalJudgeOnly Then
        strStmt = strStmt & vbLf & _
              "            AND JUDCLASS.ALLJUDFLG   = 1 ) "
    Else
'## 2002.6.4 Mod 42Lines by T.Takagi(FSIT) 判定分類指定
'        strStmt = strStmt & vbLf & _
'              "            AND ( JUDCLASS.ALLJUDFLG = 1                                      " & vbLf & _
'              "                  OR                                                          " & vbLf & _
'              "                  EXISTS ( SELECT STDVALUE.ITEMCD                             " & vbLf & _
'              "                             FROM ITEM_JUD, STDVALUE                          " & vbLf & _
'              "                            WHERE STDVALUE.ITEMCD      = ITEM_JUD.ITEMCD      " & vbLf & _
'              "                              AND ITEM_JUD.JUDCLASSCD  = CURJUDRSL.JUDCLASSCD " & vbLf & _
'              "                              AND STDVALUE.STRDATE    <= CONSULT.CSLDATE      " & vbLf & _
'              "                              AND STDVALUE.ENDDATE    >= CONSULT.CSLDATE      " & vbLf & _
'              "                              AND ( STDVALUE.CSCD IS NULL OR                  " & vbLf & _
'              "                                    STDVALUE.CSCD = CONSULT.CSCD ) ) ) )      "
        '判定分類が指定されている場合
        If Trim(strJudClassCd) <> "" Then
            strStmt = strStmt & vbLf & _
                  "            AND ( JUDCLASS.ALLJUDFLG = 1                                        " & vbLf & _
                  "                  OR                                                            " & vbLf & _
                  "                  ( CURJUDRSL.JUDCLASSCD = :JUDCLASSCD                          " & vbLf & _
                  "                    AND                                                         " & vbLf & _
                  "                    EXISTS ( SELECT STDVALUE.ITEMCD                             " & vbLf & _
                  "                               FROM ITEM_JUD, STDVALUE                          " & vbLf & _
                  "                              WHERE STDVALUE.ITEMCD      = ITEM_JUD.ITEMCD      " & vbLf & _
                  "                                AND ITEM_JUD.JUDCLASSCD  = CURJUDRSL.JUDCLASSCD " & vbLf & _
                  "                                AND STDVALUE.STRDATE    <= CONSULT.CSLDATE      " & vbLf & _
                  "                                AND STDVALUE.ENDDATE    >= CONSULT.CSLDATE      " & vbLf & _
                  "                                AND ( STDVALUE.CSCD IS NULL OR                  " & vbLf & _
                  "                                      STDVALUE.CSCD = CONSULT.CSCD ) ) ) ) )    "
        '判定分類が指定されていない場合
        Else
            strStmt = strStmt & vbLf & _
                  "            AND ( JUDCLASS.ALLJUDFLG = 1                                      " & vbLf & _
                  "                  OR                                                          " & vbLf & _
                  "                  EXISTS ( SELECT STDVALUE.ITEMCD                             " & vbLf & _
                  "                             FROM ITEM_JUD, STDVALUE                          " & vbLf & _
                  "                            WHERE STDVALUE.ITEMCD      = ITEM_JUD.ITEMCD      " & vbLf & _
                  "                              AND ITEM_JUD.JUDCLASSCD  = CURJUDRSL.JUDCLASSCD " & vbLf & _
                  "                              AND STDVALUE.STRDATE    <= CONSULT.CSLDATE      " & vbLf & _
                  "                              AND STDVALUE.ENDDATE    >= CONSULT.CSLDATE      " & vbLf & _
                  "                              AND ( STDVALUE.CSCD IS NULL OR                  " & vbLf & _
                  "                                    STDVALUE.CSCD = CONSULT.CSCD ) ) ) )      "
        End If
        
    End If
'## 2002.6.4 Mod End
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteJudRslClear = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteJudRslClear = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.DeleteJudRslClear"
    
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
' 機能　　 : 判定結果をクリアする（当日ID指定可）
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     strJudClassCd      判定分類コード
' 　　　　   (In)     blnTotalJudgeOnly  True時、総合判定用判定分類の判定結果のみクリア
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteJudRslClearDayId( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal blnTotalJudgeOnly As Boolean _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim i               As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2002.6.4 Add 3Lines by T.Takagi(FSIT) 判定分類指定
    If Trim(strJudClassCd) <> "" Then
        objOraParam.Add "JUDCLASSCD", CLng(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2002.6.4 Add End
    
    'クリアすべき判定結果情報を検索
    strStmt = "DELETE JUDRSL                                       " & vbLf & _
              " WHERE ( RSVNO, JUDCLASSCD ) IN                     " & vbLf & _
              "       ( SELECT CONSULT.RSVNO, CURJUDRSL.JUDCLASSCD " & vbLf & _
              "           FROM JUDCLASS,                           " & vbLf & _
              "                JUDRSL CURJUDRSL,                   " & vbLf & _
              "                CONSULT,                            " & vbLf & _
              "                RECEIPT                             "

    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE      = :CSLDATE      " & vbLf & _
              "            AND RECEIPT.RSVNO        = CONSULT.RSVNO "

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "            AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              

    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD         = :CSCD "
    End If

    '対象受診者の現判定結果情報を取得
    strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVNO        = CURJUDRSL.RSVNO "
              
    '判定分類の総合判定フラグを取得
    strStmt = strStmt & vbLf & _
              "            AND CURJUDRSL.JUDCLASSCD = JUDCLASS.JUDCLASSCD "

    '総合判定用判定分類は無条件にクリア対象とする
    'フラグ非成立時は判定分類内検査項目が基準値判定情報を所有している場合にクリア対象とする
    If blnTotalJudgeOnly Then
        strStmt = strStmt & vbLf & _
              "            AND JUDCLASS.ALLJUDFLG   = 1 ) "
    Else
'## 2002.6.4 Mod 42Lines by T.Takagi(FSIT) 判定分類指定
'        strStmt = strStmt & vbLf & _
'              "            AND ( JUDCLASS.ALLJUDFLG = 1                                      " & vbLf & _
'              "                  OR                                                          " & vbLf & _
'              "                  EXISTS ( SELECT STDVALUE.ITEMCD                             " & vbLf & _
'              "                             FROM ITEM_JUD, STDVALUE                          " & vbLf & _
'              "                            WHERE STDVALUE.ITEMCD      = ITEM_JUD.ITEMCD      " & vbLf & _
'              "                              AND ITEM_JUD.JUDCLASSCD  = CURJUDRSL.JUDCLASSCD " & vbLf & _
'              "                              AND STDVALUE.STRDATE    <= CONSULT.CSLDATE      " & vbLf & _
'              "                              AND STDVALUE.ENDDATE    >= CONSULT.CSLDATE      " & vbLf & _
'              "                              AND ( STDVALUE.CSCD IS NULL OR                  " & vbLf & _
'              "                                    STDVALUE.CSCD = CONSULT.CSCD ) ) ) )      "
        '判定分類が指定されている場合
        If Trim(strJudClassCd) <> "" Then
            strStmt = strStmt & vbLf & _
                  "            AND ( JUDCLASS.ALLJUDFLG = 1                                        " & vbLf & _
                  "                  OR                                                            " & vbLf & _
                  "                  ( CURJUDRSL.JUDCLASSCD = :JUDCLASSCD                          " & vbLf & _
                  "                    AND                                                         " & vbLf & _
                  "                    EXISTS ( SELECT STDVALUE.ITEMCD                             " & vbLf & _
                  "                               FROM ITEM_JUD, STDVALUE                          " & vbLf & _
                  "                              WHERE STDVALUE.ITEMCD      = ITEM_JUD.ITEMCD      " & vbLf & _
                  "                                AND ITEM_JUD.JUDCLASSCD  = CURJUDRSL.JUDCLASSCD " & vbLf & _
                  "                                AND STDVALUE.STRDATE    <= CONSULT.CSLDATE      " & vbLf & _
                  "                                AND STDVALUE.ENDDATE    >= CONSULT.CSLDATE      " & vbLf & _
                  "                                AND ( STDVALUE.CSCD IS NULL OR                  " & vbLf & _
                  "                                      STDVALUE.CSCD = CONSULT.CSCD ) ) ) ) )    "
        '判定分類が指定されていない場合
        Else
            strStmt = strStmt & vbLf & _
                  "            AND ( JUDCLASS.ALLJUDFLG = 1                                      " & vbLf & _
                  "                  OR                                                          " & vbLf & _
                  "                  EXISTS ( SELECT STDVALUE.ITEMCD                             " & vbLf & _
                  "                             FROM ITEM_JUD, STDVALUE                          " & vbLf & _
                  "                            WHERE STDVALUE.ITEMCD      = ITEM_JUD.ITEMCD      " & vbLf & _
                  "                              AND ITEM_JUD.JUDCLASSCD  = CURJUDRSL.JUDCLASSCD " & vbLf & _
                  "                              AND STDVALUE.STRDATE    <= CONSULT.CSLDATE      " & vbLf & _
                  "                              AND STDVALUE.ENDDATE    >= CONSULT.CSLDATE      " & vbLf & _
                  "                              AND ( STDVALUE.CSCD IS NULL OR                  " & vbLf & _
                  "                                    STDVALUE.CSCD = CONSULT.CSCD ) ) ) )      "
        End If
        
    End If
'## 2002.6.4 Mod End
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)



    ' ### 総合コメントクリア
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    strStmt = "DELETE TOTALJUDCMT                                  " & vbLf & _
              " WHERE ( RSVNO ) IN                                 " & vbLf & _
              "       ( SELECT CONSULT.RSVNO                       " & vbLf & _
              "           FROM CONSULT,                            " & vbLf & _
              "                RECEIPT                             "

    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE      = :CSLDATE      " & vbLf & _
              "            AND RECEIPT.RSVNO        = CONSULT.RSVNO "

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "            AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              

    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD         = :CSCD "
    End If
    
    strStmt = strStmt & vbLf & _
              "   )                        " & vbLf & _
              "   AND DISPMODE = :DISPMODE "
              
    '##### 2004.01.14 Mod start by K.Fujii
    '指定した判定分類の判定が悪化した場合に良好コメントが残ったままというのはどうかと
    '思われるので修正しました
    '判定分類が指定されている場合
'    If Trim(strJudClassCd) <> "" Then
'        strStmt = strStmt & vbLf & _
'              "   AND EXISTS (SELECT JUDCLASSCD                        " & vbLf & _
'              "                 FROM JUDCMTSTC                         " & vbLf & _
'              "                WHERE JUDCMTCD   = TOTALJUDCMT.JUDCMTCD " & vbLf & _
'              "                  AND JUDCLASSCD = :JUDCLASSCD         )"
'    End If
    '判定分類が指定されている場合、当該判定分類のコメントと良好コメントを削除する
    If Trim(strJudClassCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND (EXISTS (SELECT JUDCLASSCD                        " & vbLf & _
              "                  FROM JUDCMTSTC                         " & vbLf & _
              "                 WHERE JUDCMTCD   = TOTALJUDCMT.JUDCMTCD " & vbLf & _
              "                   AND JUDCLASSCD = :JUDCLASSCD         )" & vbLf & _
              "    OR (JUDCMTCD = (SELECT FREE.FREEFIELD1 JUDCMTCD      " & vbLf & _
              "                      FROM FREE                          " & vbLf & _
              "                     WHERE FREECD = 'GOODCMT')))         "
    End If
    '##### 2004.01.14 Mod end by K.Fujii

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteJudRslClearDayId = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteJudRslClearDayId = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.DeleteJudRslClearDayId"
    
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

'#### 2004.01.16 add (不要なものが残りっぱなしになるバグ修正用）
'
' 機能　　 : 判定結果がNullのものをクリアする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     strJudClassCd      判定分類コード
' 　　　　   (In)     blnTotalJudgeOnly  True時、総合判定用判定分類の判定結果のみクリア
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteNullJudRslClearDayId( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal blnTotalJudgeOnly As Boolean _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim vntNyubouItemCd1        As Variant         '乳房触診検査項目コード
    Dim vntNyubouItemCd2        As Variant         '乳房Ｘ線検査項目コード
    Dim vntNyubouItemCd3        As Variant         '乳房超音波検査項目コード
    Dim vntNyubouJudClassCd1    As Variant         '乳房触診判定分類コード
    Dim vntNyubouJudClassCd2    As Variant         '乳房Ｘ線判定分類コード
    Dim vntNyubouJudClassCd3    As Variant         '乳房超音波判定分類コード
    
    Dim i               As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'       If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2002.6.4 Add 3Lines by T.Takagi(FSIT) 判定分類指定
    If Trim(strJudClassCd) <> "" Then
        objOraParam.Add "JUDCLASSCD", CLng(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2002.6.4 Add End
    
    'クリアすべき判定結果情報を検索
    strStmt = "DELETE JUDRSL                                       " & vbLf & _
              " WHERE ( RSVNO, JUDCLASSCD ) IN                     " & vbLf & _
              "       ( SELECT CONSULT.RSVNO, CURJUDRSL.JUDCLASSCD " & vbLf & _
              "           FROM JUDCLASS,                           " & vbLf & _
              "                JUDRSL CURJUDRSL,                   " & vbLf & _
              "                CONSULT,                            " & vbLf & _
              "                RECEIPT                             "

    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE      = :CSLDATE      " & vbLf & _
              "            AND RECEIPT.RSVNO        = CONSULT.RSVNO "

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "            AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              

    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD         = :CSCD "
    End If

    '対象受診者の現判定結果情報を取得
    strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVNO        = CURJUDRSL.RSVNO "
              
    '判定分類の総合判定フラグを取得
    strStmt = strStmt & vbLf & _
              "            AND CURJUDRSL.JUDCLASSCD = JUDCLASS.JUDCLASSCD "

    '判定結果、更新者がNullのもの
    strStmt = strStmt & vbLf & _
              "            AND CURJUDRSL.JUDCD   IS NULL " & vbLf & _
              "            AND CURJUDRSL.UPDUSER IS NULL "

    '総合判定用判定分類は無条件にクリア対象とする
    'フラグ非成立時は判定分類内検査項目が基準値判定情報を所有している場合にクリア対象とする
    If blnTotalJudgeOnly Then
        strStmt = strStmt & vbLf & _
              "            AND JUDCLASS.ALLJUDFLG   = 1 ) "
    Else
        '判定分類が指定されている場合
        If Trim(strJudClassCd) <> "" Then
            '乳房の場合
            If Trim(strJudClassCd) = Trim(NYUBOU_JUDCLASSCD) Then
                ' 乳房判定用のコード取得
                SelectNyubouCd vntNyubouItemCd1, vntNyubouItemCd2, vntNyubouItemCd3, _
                                    vntNyubouJudClassCd1, vntNyubouJudClassCd2, vntNyubouJudClassCd3
                objOraParam.Add "NYUJUDCLASSCD1", CLng(vntNyubouJudClassCd1), ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "NYUJUDCLASSCD2", CLng(vntNyubouJudClassCd2), ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "NYUJUDCLASSCD3", CLng(vntNyubouJudClassCd3), ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "NYUJUDCLASSCD", CLng(NYUBOU_JUDCLASSCD), ORAPARM_INPUT, ORATYPE_NUMBER
                strStmt = strStmt & vbLf & _
                        "    AND ( JUDCLASS.ALLJUDFLG = 1                     " & vbLf & _
                        "          OR                                         " & vbLf & _
                        "          CURJUDRSL.JUDCLASSCD IN ( :JUDCLASSCD, :NYUJUDCLASSCD1, :NYUJUDCLASSCD2, :NYUJUDCLASSCD3 ))) "
            Else
                strStmt = strStmt & vbLf & _
                        "    AND ( JUDCLASS.ALLJUDFLG = 1                     " & vbLf & _
                        "          OR                                         " & vbLf & _
                        "          CURJUDRSL.JUDCLASSCD = :JUDCLASSCD ))       "
            End If
        Else
            strStmt = strStmt & vbLf & _
                "             ) "
        End If
        
    End If
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteNullJudRslClearDayId = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteNullJudRslClearDayId = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.DeleteNullJudRslClearDayId"
    
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
' 機能　　 : 判定結果テーブルレコードを挿入する
'
' 引数　　 : (In)     vntRsvNo       予約番号
' 　　　　 : (In)     vntJudClassCd  判定分類コード
' 　　　　 : (In)     vntJudCd       判定コード
' 　　　　 : (In)     vntDoctorCd    判定医コード
' 　　　　 : (In)     vntFreeJudCmt  フリー判定コメント
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertJudRsl( _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    ByRef vntJudCd As Variant, _
    ByRef vntDoctorCd As Variant, _
    ByRef vntFreeJudCmt As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objRsvNo        As OraParameter     '予約番号
    Dim objJudClassCd   As OraParameter     '判定分類コード
    Dim objJudCd        As OraParameter     '判定コード
    Dim objDoctorCd     As OraParameter     '判定医コード
    Dim objFreeJudCmt   As OraParameter     'フリー判定コメント
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DOCTORCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREEJUDCMT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'パラメータの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objJudClassCd = objOraParam("JUDCLASSCD")
    Set objJudCd = objOraParam("JUDCD")
    Set objDoctorCd = objOraParam("DOCTORCD")
    Set objFreeJudCmt = objOraParam("FREEJUDCMT")
    
    '文字列バッファサイズの設定(意味不明。しかし本プロパティ設定がなければ異常終了する。)
    objFreeJudCmt.MinimumSize = 500
    
    '判定結果テーブルレコードの挿入
    strStmt = "INSERT INTO JUDRSL (     " & vbLf & _
              "            RSVNO,       " & vbLf & _
              "            JUDCLASSCD,  " & vbLf & _
              "            JUDCD,       " & vbLf & _
              "            DOCTORCD,    " & vbLf & _
              "            FREEJUDCMT   " & vbLf & _
              "       ) VALUES (        " & vbLf & _
              "            :RSVNO,      " & vbLf & _
              "            :JUDCLASSCD, " & vbLf & _
              "            :JUDCD,      " & vbLf & _
              "            :DOCTORCD,   " & vbLf & _
              "            :FREEJUDCMT  " & vbLf & _
              "       )"
              
    '各配列値の挿入処理
    For i = 0 To UBound(vntJudClassCd)
    
        '配列値の編集
        objRsvNo.Value = CLng(vntRsvNo(i))
        objJudClassCd.Value = CLng(vntJudClassCd(i))
        objJudCd.Value = CStr(vntJudCd(i))
        objDoctorCd.Value = CStr(vntDoctorCd(i))
        objFreeJudCmt.Value = CStr(vntFreeJudCmt(i))
    
        'SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
        
    Next i

    'バインド変数の削除
'    objOraParam.Remove "RSVNO"
'    objOraParam.Remove "JUDCLASSCD"
'    objOraParam.Remove "JUDCD"
'    objOraParam.Remove "DOCTORCD"
'    objOraParam.Remove "FREEJUDCMT"
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertJudRsl = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertJudRsl = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.InsertJudRsl"
    
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
' 機能　　 : 判定所見テーブルレコードを挿入する
'
' 引数　　 : (In)     vntRsvNo       予約番号
' 　　　　 : (In)     vntJudClassCd  判定分類コード
' 　　　　 : (In)     vntStdJudCd    定型所見コード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertJudRsl_C(ByRef vntRsvNo As Variant, ByRef vntJudClassCd As Variant, ByRef vntStdJudCd As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objRsvNo        As OraParameter     '予約番号
    Dim objJudClassCd   As OraParameter     '判定分類コード
    Dim objStdJudCd     As OraParameter     '定型所見コード
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STDJUDCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'パラメータの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objJudClassCd = objOraParam("JUDCLASSCD")
    Set objStdJudCd = objOraParam("STDJUDCD")
    
    '判定所見テーブルレコードの挿入
    strStmt = "INSERT INTO JUDRSL_C (   " & vbLf & _
              "            RSVNO,       " & vbLf & _
              "            JUDCLASSCD,  " & vbLf & _
              "            STDJUDCD     " & vbLf & _
              "       ) VALUES (        " & vbLf & _
              "            :RSVNO,      " & vbLf & _
              "            :JUDCLASSCD, " & vbLf & _
              "            :STDJUDCD    " & vbLf & _
              "       )"
    
    '各配列値の挿入処理
    For i = 0 To UBound(vntJudClassCd)
    
        '配列値の編集
        objRsvNo.Value = CLng(vntRsvNo(i))
        objJudClassCd.Value = CLng(vntJudClassCd(i))
        objStdJudCd.Value = CLng(vntStdJudCd(i))
    
        'SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
        
    Next i

    'バインド変数の削除
'    objOraParam.Remove "RSVNO"
'    objOraParam.Remove "JUDCLASSCD"
'    objOraParam.Remove "STDJUDCD"
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertJudRsl_C = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertJudRsl_C = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.InsertJudRsl_C"
    
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
' 機能　　 : 指定条件を満たす受診情報のデフォルト判定結果情報を作成する
'
' 引数　　 : (In)     dtmCslDate     受診日
' 　　　　   (In)     strPerId       個人ID
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     strJudClassCd  判定分類コード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertJudRslDefault( _
    ByVal dtmCslDate As Date, _
    ByVal strPerId As String, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String _
) As Boolean
'## 2002.6.4 Modify End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objRsvNo        As OraParameter     '予約番号
    Dim objJudClassCd   As OraParameter     '判定分類コード
    Dim objJudCd        As OraParameter     '判定コード
    Dim objDoctorCd     As OraParameter     '判定医コード
    Dim objFreeJudCmt   As OraParameter     'フリー判定コメント
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    If Trim(strPerId) <> "" Then
        objOraParam.Add "PERID", CLng(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2002.6.4 Add 3Lines by T.Takagi(FSIT) 判定分類指定
    If Trim(strJudClassCd) <> "" Then
        objOraParam.Add "JUDCLASSCD", CLng(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2002.6.4 Add End
    
    '判定結果テーブルレコードの挿入
    strStmt = "INSERT INTO JUDRSL ( RSVNO, JUDCLASSCD ) "
    
    '受診情報より挿入対象となる判定分類を求める
    strStmt = strStmt & vbLf & _
              "       SELECT CONSULT.RSVNO, COURSE_JUD.JUDCLASSCD " & vbLf & _
              "         FROM COURSE_JUD, CONSULT, RECEIPT         " & vbLf & _
              "        WHERE RECEIPT.CSLDATE = :CSLDATE           " & vbLf & _
              "          AND RECEIPT.RSVNO   = CONSULT.RSVNO      "

    '個人ID指定時は条件節に加える
    If Trim(strPerId) <> "" Then
        strStmt = strStmt & vbLf & _
              "          AND CONSULT.PERID  >= :PERID "
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "          AND CONSULT.CSCD    = :CSCD "
    End If

    'コースに属する判定分類を求める
    strStmt = strStmt & vbLf & _
              "          AND CONSULT.CSCD    = COURSE_JUD.CSCD "
              
'## 2002.6.4 Add 5Lines by T.Takagi(FSIT) 判定分類指定
    '判定分類指定時は条件節に追加
    If Trim(strJudClassCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "          AND COURSE_JUD.JUDCLASSCD = :JUDCLASSCD "
    End If
'## 2002.6.4 Add End
    
    'すでにレコードが存在する予約番号、判定分類の組み合わせは除外
    strStmt = strStmt & vbLf & _
              "          AND NOT EXISTS ( SELECT RSVNO                                " & vbLf & _
              "                             FROM JUDRSL                               " & vbLf & _
              "                            WHERE RSVNO      = CONSULT.RSVNO           " & vbLf & _
              "                              AND JUDCLASSCD = COURSE_JUD.JUDCLASSCD ) "

    '自動展開フラグが立っている、或いは判定分類内の検査項目が健診結果に存在するかを判定
    strStmt = strStmt & vbLf & _
              "          AND ( COURSE_JUD.NOREASON = 1                                         " & vbLf & _
              "                OR                                                              " & vbLf & _
              "                EXISTS ( SELECT RSL.RSVNO                                       " & vbLf & _
              "                           FROM ITEM_JUD, RSL                                   " & vbLf & _
              "                          WHERE RSL.RSVNO           = CONSULT.RSVNO             " & vbLf & _
              "                            AND RSL.ITEMCD          = ITEM_JUD.ITEMCD           " & vbLf & _
              "                            AND ITEM_JUD.JUDCLASSCD = COURSE_JUD.JUDCLASSCD ) ) "

    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertJudRslDefault = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertJudRslDefault = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.InsertJudRslDefault"
    
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
' 機能　　 : 指定条件を満たす受診情報のデフォルト判定結果情報を作成する（当日ＩＤ指定）
'
' 引数　　 : (In)     dtmCslDate     受診日
' 　　　　   (In)     lngDayIdFlg    1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId    検索開始ＩＤ
' 　　　　   (In)     lngEndDayId    検索終了ＩＤ
' 　　　　   (In)     vntArrDayId    検索ＩＤ（配列）
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     strJudClassCd  判定分類コード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertJudRslDefaultDayId( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objRsvNo        As OraParameter     '予約番号
    Dim objJudClassCd   As OraParameter     '判定分類コード
    Dim objJudCd        As OraParameter     '判定コード
    Dim objDoctorCd     As OraParameter     '判定医コード
    Dim objFreeJudCmt   As OraParameter     'フリー判定コメント
    
'#### 2004.01.14 add start 乳房判定分類指定時用
    Dim vntNyubouItemCd1        As Variant         '乳房触診検査項目コード
    Dim vntNyubouItemCd2        As Variant         '乳房Ｘ線検査項目コード
    Dim vntNyubouItemCd3        As Variant         '乳房超音波検査項目コード
    Dim vntNyubouJudClassCd1    As Variant         '乳房触診判定分類コード
    Dim vntNyubouJudClassCd2    As Variant         '乳房Ｘ線判定分類コード
    Dim vntNyubouJudClassCd3    As Variant         '乳房超音波判定分類コード
'#### 2004.01.14 add end 乳房判定分類指定時用
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'       If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2002.6.4 Add 3Lines by T.Takagi(FSIT) 判定分類指定
    If Trim(strJudClassCd) <> "" Then
        objOraParam.Add "JUDCLASSCD", CLng(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2002.6.4 Add End
    
    '判定結果テーブルレコードの挿入
    strStmt = "INSERT INTO JUDRSL ( RSVNO, JUDCLASSCD ) "
    
    '受診情報より挿入対象となる判定分類を求める
    strStmt = strStmt & vbLf & _
              "       SELECT CONSULT.RSVNO, COURSE_JUD.JUDCLASSCD " & vbLf & _
              "         FROM COURSE_JUD, CONSULT, RECEIPT         " & vbLf & _
              "        WHERE RECEIPT.CSLDATE = :CSLDATE           " & vbLf & _
              "          AND RECEIPT.RSVNO   = CONSULT.RSVNO      "

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "            AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "          AND CONSULT.CSCD    = :CSCD "
    End If

    'コースに属する判定分類を求める
    strStmt = strStmt & vbLf & _
              "          AND CONSULT.CSCD    = COURSE_JUD.CSCD "
              
'##### 2004.01.14  start 乳房判定のときはダミーの判定分類コードも判定を実施するので修正
'## 2002.6.4 Add 5Lines by T.Takagi(FSIT) 判定分類指定
'    '判定分類指定時は条件節に追加
'    If Trim(strJudClassCd) <> "" Then
'        strStmt = strStmt & vbLf & _
'              "          AND COURSE_JUD.JUDCLASSCD = :JUDCLASSCD "
'    End If
'## 2002.6.4 Add End
    ' 乳房判定用のコード取得
    SelectNyubouCd vntNyubouItemCd1, vntNyubouItemCd2, vntNyubouItemCd3, _
                                    vntNyubouJudClassCd1, vntNyubouJudClassCd2, vntNyubouJudClassCd3
    objOraParam.Add "NYUJUDCLASSCD1", CLng(vntNyubouJudClassCd1), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NYUJUDCLASSCD2", CLng(vntNyubouJudClassCd2), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NYUJUDCLASSCD3", CLng(vntNyubouJudClassCd3), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NYUJUDCLASSCD", CLng(NYUBOU_JUDCLASSCD), ORAPARM_INPUT, ORATYPE_NUMBER
    '判定分類指定時は条件節に追加
    If Trim(strJudClassCd) <> "" Then
        If Trim(strJudClassCd) = Trim(NYUBOU_JUDCLASSCD) Then
            strStmt = strStmt & vbLf & _
              "   AND COURSE_JUD.JUDCLASSCD IN ( :JUDCLASSCD, :NYUJUDCLASSCD1, :NYUJUDCLASSCD2, :NYUJUDCLASSCD3 ) "
        Else
            strStmt = strStmt & vbLf & _
              "   AND COURSE_JUD.JUDCLASSCD = :JUDCLASSCD "
        End If
    End If
'##### 2004.01.14  end 乳房判定のときはダミーの判定分類コードも判定を実施するので修正
    
    'すでにレコードが存在する予約番号、判定分類の組み合わせは除外
    strStmt = strStmt & vbLf & _
              "          AND NOT EXISTS ( SELECT RSVNO                                " & vbLf & _
              "                             FROM JUDRSL                               " & vbLf & _
              "                            WHERE RSVNO      = CONSULT.RSVNO           " & vbLf & _
              "                              AND JUDCLASSCD = COURSE_JUD.JUDCLASSCD ) "

    '自動展開フラグが立っている、或いは判定分類内の検査項目が健診結果に存在するかを判定
    strStmt = strStmt & vbLf & _
              "          AND ( COURSE_JUD.NOREASON = 1                                         " & vbLf & _
              "                OR                                                              " & vbLf & _
              "                EXISTS ( SELECT RSL.RSVNO                                       " & vbLf & _
              "                           FROM ITEM_JUD, RSL                                   " & vbLf & _
              "                          WHERE RSL.RSVNO           = CONSULT.RSVNO             " & vbLf & _
              "                            AND RSL.ITEMCD          = ITEM_JUD.ITEMCD           " & vbLf & _
              "                            AND ITEM_JUD.JUDCLASSCD = COURSE_JUD.JUDCLASSCD )   "
    '### 乳房特殊処理 2004.01.14 add start
    '### 乳房は触診、Ｘ線、超音波のいずれかの依頼があれば対象となる
    strStmt = strStmt & vbLf & _
              "                OR                                                              " & vbLf & _
              "                (EXISTS ( SELECT RSL.RSVNO                                      " & vbLf & _
              "                           FROM ITEM_JUD, RSL                                   " & vbLf & _
              "                          WHERE RSL.RSVNO           = CONSULT.RSVNO             " & vbLf & _
              "                            AND RSL.ITEMCD          = ITEM_JUD.ITEMCD           " & vbLf & _
              "                            AND ITEM_JUD.JUDCLASSCD                             " & vbLf & _
              "                            IN (:NYUJUDCLASSCD1, :NYUJUDCLASSCD2, :NYUJUDCLASSCD3 ) )  " & vbLf & _
              "                      AND COURSE_JUD.JUDCLASSCD = :NYUJUDCLASSCD )                 "
    '乳房ダミー判定分類は必ず作る
    strStmt = strStmt & vbLf & _
              "                OR COURSE_JUD.JUDCLASSCD = :NYUJUDCLASSCD1   " & vbLf & _
              "                OR COURSE_JUD.JUDCLASSCD = :NYUJUDCLASSCD2   " & vbLf & _
              "                OR COURSE_JUD.JUDCLASSCD = :NYUJUDCLASSCD3 ) "
    '### 乳房特殊処理 2004.01.14 add end

    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertJudRslDefaultDayId = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertJudRslDefaultDayId = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.InsertJudRslDefaultDayId"
    
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
' 機能　　 : 個人ＩＤの判定結果情報を取得する
'
' 引数　　 : (In)     strPerId        個人ＩＤ
' 　　　　 : (In)     strCslDate      指定受診日（以前）
' 　　　　 : (Out)    vntRsvNo        予約番号
' 　　　　 : (Out)    vntCslDate      受診日
' 　　　　 : (Out)    vntCsName       コース名
' 　　　　 : (Out)    vntJudClassCd   判定分類コード
' 　　　　 : (Out)    vntJudClassName 判定分類名称
' 　　　　 : (Out)    vntJudSName     略称
' 　　　　 : (Out)    vntStdJudNote   定型所見名称
' 　　　　 : (Out)    vntFreeJudCmt   フリー判定コメント
' 　　　　 : (Out)    vntGuidanceStc  指導内容
' 　　　　 : (Out)    vntJudCmtStc    判定コメント
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 指定受診日以前の判定結果をすべて返す
'
Public Function SelectHistoryJudRslList(ByVal strPerId As String, _
                                        ByVal strCslDate As String, _
                                        ByRef vntRsvNo As Variant, _
                                        ByRef vntCslDate As Variant, _
                                        ByRef vntCsName As Variant, _
                                        ByRef vntJudClassCd As Variant, _
                                        ByRef vntJudClassName As Variant, _
                                        ByRef vntJudSName As Variant, _
                                        ByRef vntStdJudNote As Variant, _
                                        ByRef vntFreeJudCmt As Variant, _
                                        Optional ByRef vntGuidanceStc As Variant, _
                                        Optional ByRef vntJudCmtStc As Variant _
                                       ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objRsvNo                As OraField         '予約番号
    Dim objCslDate              As OraField         '受診日
    Dim objCsName               As OraField         'コース名
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objJudSName             As OraField         '判定略称
    Dim objStdJudNote           As OraField         '定型所見名称
    Dim objFreeJudCmt           As OraField         'フリー判定コメント
    
    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrCslDate()         As Variant          '受診日の配列
    Dim vntArrCsName()          As Variant          'コース名の配列
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudSName()        As Variant          '判定略称の配列
    Dim vntArrStdJudNote()      As Variant          '定型所見名称の配列
    Dim vntArrFreeJudCmt()      As Variant          'フリー判定コメントの配列
    
'## 2003.02.17 Updated 1Line by H.Ishihara@FSIT 指導内容もJOINする
    Dim objGuidanceStc          As OraField         '指導内容
    Dim objJudCmtStc            As OraField         '判定コメント
    Dim vntArrGuidanceStc()     As Variant          '指導内容の配列
    Dim vntArrJudCmtStc()       As Variant          '判定コメントの配列
'## 2003.02.17 Updated End
    
    Dim lngCount                As Long             'レコード数
    
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ＩＤ・表示開始受診日が設定されていない場合はエラー
    If IsEmpty(strPerId) Or IsEmpty(strCslDate) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDATE", Trim(strCslDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす判定結果のレコードを取得
'## 2003.02.17 Updated 1Line by H.Ishihara@FSIT 指導内容もJOINする
'    strStmt = "SELECT JL.RSVNO, JL.CSLDATE, JL.CSNAME, JL.JUDCLASSCD, JL.JUDCLASSNAME,      " & vbLf & _
              "       JL.JUDSNAME, JL.STDJUDNOTE, JL.FREEJUDCMT                             " & vbLf & _
              "  FROM ( SELECT CN.RSVNO, CN.CSLDATE, CN.CSCD, CP.CSNAME, JC.JUDCLASSCD,     " & vbLf & _
              "                JC.JUDCLASSNAME, JD.JUDSNAME, SJ.STDJUDNOTE, JR.FREEJUDCMT   " & vbLf & _
              "           FROM CONSULT CN, COURSE_P CP, JUDRSL JR, JUDCLASS JC, JUD JD,     " & vbLf & _
              "                JUDRSL_C RC, STDJUD SJ                                       " & vbLf & _
              "          WHERE CN.PERID      = :PERID                                       " & vbLf & _
              "            AND CN.CSLDATE    < :CSLDATE                                     " & vbLf & _
              "            AND CN.RSVNO      = JR.RSVNO                                     " & vbLf & _
              "            AND CN.CSCD       = CP.CSCD                                      " & vbLf & _
              "            AND JR.JUDCLASSCD = JC.JUDCLASSCD                                " & vbLf & _
              "            AND JR.JUDCD      = JD.JUDCD(+)                                  " & vbLf & _
              "            AND JR.RSVNO      = RC.RSVNO(+)                                  " & vbLf & _
              "            AND JR.JUDCLASSCD = RC.JUDCLASSCD(+)                             " & vbLf & _
              "            AND RC.JUDCLASSCD = SJ.JUDCLASSCD(+)                             " & vbLf & _
              "            AND RC.STDJUDCD   = SJ.STDJUDCD(+)                               " & vbLf & _
              "       ) JL, COURSE_JUD CJ                                                   " & vbLf & _
              " WHERE JL.CSCD       = CJ.CSCD                                               " & vbLf & _
              "   AND JL.JUDCLASSCD = CJ.JUDCLASSCD                                         " & vbLf & _
              " ORDER BY JL.CSLDATE DESC, CJ.SEQ                                            "
'## 2003.03.08 Mod XXLines by T.Takagi@FSIT コース判定分類はみない
'    strStmt = "SELECT JL.RSVNO, JL.CSLDATE, JL.CSNAME, JL.JUDCLASSCD, JL.JUDCLASSNAME,      " & vbLf & _
'              "       JL.JUDSNAME, JL.STDJUDNOTE, JL.FREEJUDCMT,                            " & vbLf & _
'              "       JL.GUIDANCESTC, JL.JUDCMTSTC                                          " & vbLf & _
'              "  FROM ( SELECT CN.RSVNO, CN.CSLDATE, CN.CSCD, CP.CSNAME, JC.JUDCLASSCD,     " & vbLf & _
'              "                JC.JUDCLASSNAME, JD.JUDSNAME, SJ.STDJUDNOTE, JR.FREEJUDCMT,  " & vbLf & _
'              "                GUIDANCE.GUIDANCESTC, JUDCMTSTC.JUDCMTSTC                    " & vbLf & _
'              "           FROM CONSULT CN, COURSE_P CP, JUDRSL JR, JUDCLASS JC, JUD JD,     " & vbLf & _
'              "                JUDRSL_C RC, STDJUD SJ, GUIDANCE, JUDCMTSTC                  " & vbLf & _
'              "          WHERE CN.PERID      = :PERID                                       " & vbLf & _
'              "            AND CN.CSLDATE    < :CSLDATE                                     " & vbLf & _
'              "            AND CN.RSVNO      = JR.RSVNO                                     " & vbLf & _
'              "            AND CN.CSCD       = CP.CSCD                                      " & vbLf & _
'              "            AND JR.JUDCLASSCD = JC.JUDCLASSCD                                " & vbLf & _
'              "            AND JR.JUDCD      = JD.JUDCD(+)                                  " & vbLf & _
'              "            AND JR.RSVNO      = RC.RSVNO(+)                                  " & vbLf & _
'              "            AND JR.JUDCLASSCD = RC.JUDCLASSCD(+)                             " & vbLf & _
'              "            AND RC.JUDCLASSCD = SJ.JUDCLASSCD(+)                             " & vbLf & _
'              "            AND RC.STDJUDCD   = SJ.STDJUDCD(+)                               " & vbLf & _
'              "            AND JR.GUIDANCECD = GUIDANCE.GUIDANCECD(+)                       " & vbLf & _
'              "            AND JR.JUDCMTCD   = JUDCMTSTC.JUDCMTCD(+)                        " & vbLf & _
'              "       ) JL, COURSE_JUD CJ                                                   " & vbLf & _
'              " WHERE JL.CSCD       = CJ.CSCD                                               " & vbLf & _
'              "   AND JL.JUDCLASSCD = CJ.JUDCLASSCD                                         " & vbLf & _
'              " ORDER BY JL.CSLDATE DESC, CJ.SEQ                                            "
    strStmt = "SELECT JL.RSVNO, JL.CSLDATE, JL.CSNAME, JL.JUDCLASSCD, JL.JUDCLASSNAME,      " & vbLf & _
              "       JL.JUDSNAME, JL.STDJUDNOTE, JL.FREEJUDCMT,                            " & vbLf & _
              "       JL.GUIDANCESTC, JL.JUDCMTSTC                                          " & vbLf & _
              "  FROM ( SELECT CN.RSVNO, CN.CSLDATE, CN.CSCD, CP.CSNAME, JC.JUDCLASSCD,     " & vbLf & _
              "                JC.JUDCLASSNAME, JD.JUDSNAME, SJ.STDJUDNOTE, JR.FREEJUDCMT,  " & vbLf & _
              "                GUIDANCE.GUIDANCESTC, JUDCMTSTC.JUDCMTSTC                    " & vbLf & _
              "           FROM CONSULT CN, COURSE_P CP, JUDRSL JR, JUDCLASS JC, JUD JD,     " & vbLf & _
              "                JUDRSL_C RC, STDJUD SJ, GUIDANCE, JUDCMTSTC                  " & vbLf & _
              "          WHERE CN.PERID      = :PERID                                       " & vbLf & _
              "            AND CN.CSLDATE    < :CSLDATE                                     " & vbLf & _
              "            AND CN.RSVNO      = JR.RSVNO                                     " & vbLf & _
              "            AND CN.CSCD       = CP.CSCD                                      " & vbLf & _
              "            AND JR.JUDCLASSCD = JC.JUDCLASSCD                                " & vbLf & _
              "            AND JR.JUDCD      = JD.JUDCD(+)                                  " & vbLf & _
              "            AND JR.RSVNO      = RC.RSVNO(+)                                  " & vbLf & _
              "            AND JR.JUDCLASSCD = RC.JUDCLASSCD(+)                             " & vbLf & _
              "            AND RC.JUDCLASSCD = SJ.JUDCLASSCD(+)                             " & vbLf & _
              "            AND RC.STDJUDCD   = SJ.STDJUDCD(+)                               " & vbLf & _
              "            AND JR.GUIDANCECD = GUIDANCE.GUIDANCECD(+)                       " & vbLf & _
              "            AND JR.JUDCMTCD   = JUDCMTSTC.JUDCMTCD(+)                        " & vbLf & _
              "       ) JL                                                                  " & vbLf & _
              " ORDER BY JL.CSLDATE DESC, JL.JUDCLASSCD                                     "
'## 2003.03.08 Mod End
'## 2003.02.17 Updated End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objCsName = objFields("CSNAME")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudSName = objFields("JUDSNAME")
        Set objStdJudNote = objFields("STDJUDNOTE")
        Set objFreeJudCmt = objFields("FREEJUDCMT")
'## 2003.02.17 Updated 1Line by H.Ishihara@FSIT 指導内容もJOINする
        Set objGuidanceStc = objFields("GUIDANCESTC")
        Set objJudCmtStc = objFields("JUDCMTSTC")
'## 2003.02.17 Updated End
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrJudSName(lngCount)
            ReDim Preserve vntArrStdJudNote(lngCount)
            ReDim Preserve vntArrFreeJudCmt(lngCount)
'## 2003.02.17 Updated 1Line by H.Ishihara@FSIT 指導内容もJOINする
            ReDim Preserve vntArrGuidanceStc(lngCount)
            ReDim Preserve vntArrJudCmtStc(lngCount)
'## 2003.02.17 Updated End
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrCslDate(lngCount) = objCslDate.Value
            vntArrCsName(lngCount) = objCsName.Value
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrJudClassName(lngCount) = objJudClassName.Value
            vntArrJudSName(lngCount) = objJudSName.Value & ""
            vntArrStdJudNote(lngCount) = objStdJudNote.Value & ""
            vntArrFreeJudCmt(lngCount) = objFreeJudCmt.Value & ""
'## 2003.02.17 Updated 1Line by H.Ishihara@FSIT 指導内容もJOINする
            vntArrGuidanceStc(lngCount) = objGuidanceStc.Value & ""
            vntArrJudCmtStc(lngCount) = objJudCmtStc.Value & ""
'## 2003.02.17 Updated End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntRsvNo = vntArrRsvNo
    vntCslDate = vntArrCslDate
    vntCsName = vntArrCsName
    vntJudClassCd = vntArrJudClassCd
    vntJudClassName = vntArrJudClassName
    vntJudSName = vntArrJudSName
    vntStdJudNote = vntArrStdJudNote
    vntFreeJudCmt = vntArrFreeJudCmt
'## 2003.02.17 Updated 1Line by H.Ishihara@FSIT 指導内容もJOINする
    If IsMissing(vntGuidanceStc) = False Then vntGuidanceStc = vntArrGuidanceStc
    If IsMissing(vntJudCmtStc) = False Then vntJudCmtStc = vntArrJudCmtStc
'## 2003.02.17 Updated End
    
    SelectHistoryJudRslList = lngCount
    
    Set objOraDyna = Nothing
    
    'キー値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectHistoryJudRslList"
    
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
' 機能　　 : 予約番号の判定結果情報を取得する
'
' 引数　　 : (In)     strRsvNo        予約番号
' 　　　　 : (Out)    vntJudClassCd   判定分類コード
' 　　　　 : (Out)    vntJudClassName 判定分類名称
' 　　　　 : (Out)    vntJudSName     略称
' 　　　　 : (Out)    vntStdJudNote   定型所見名称
' 　　　　 : (Out)    vntFreeJudCmt   フリー判定コメント
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectInquiryJudRslList(ByVal strRsvNo As String, _
                                        ByRef vntJudClassCd As Variant, _
                                        ByRef vntJudClassName As Variant, _
                                        ByRef vntJudSName As Variant, _
                                        ByRef vntStdJudNote As Variant, _
                                        ByRef vntFreeJudCmt As Variant _
                                       ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objJudSName             As OraField         '判定略称
    Dim objStdJudNote           As OraField         '定型所見名称
    Dim objFreeJudCmt           As OraField         'フリー判定コメント
    
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudSName()        As Variant          '判定略称の配列
    Dim vntArrStdJudNote()      As Variant          '定型所見名称の配列
    Dim vntArrFreeJudCmt()      As Variant          'フリー判定コメントの配列
    
    Dim lngCount                As Long             'レコード数
    
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '予約番号が設定されていない場合はエラー
    If IsEmpty(strRsvNo) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす判定結果のレコードを取得
'    strStmt = "SELECT JL.JUDCLASSCD, JL.JUDCLASSNAME, JL.JUDSNAME, JL.STDJUDNOTE,       " & vbLf & _
              "       JL.FREEJUDCMT                                                     " & vbLf & _
              "  FROM ( SELECT CN.CSCD, JC.JUDCLASSCD, JC.JUDCLASSNAME, JD.JUDSNAME,    " & vbLf & _
              "                SJ.STDJUDNOTE, JR.FREEJUDCMT                             " & vbLf & _
              "           FROM CONSULT CN, COURSE_P CP, JUDRSL JR, JUDCLASS JC, JUD JD, " & vbLf & _
              "                JUDRSL_C RC, STDJUD SJ                                   " & vbLf & _
              "          WHERE CN.RSVNO      = :RSVNO                                   " & vbLf & _
              "            AND CN.RSVNO      = JR.RSVNO                                 " & vbLf & _
              "            AND CN.CSCD       = CP.CSCD                                  " & vbLf & _
              "            AND JR.JUDCLASSCD = JC.JUDCLASSCD                            " & vbLf & _
              "            AND JR.JUDCD      = JD.JUDCD(+)                              " & vbLf & _
              "            AND JR.RSVNO      = RC.RSVNO(+)                              " & vbLf & _
              "            AND JR.JUDCLASSCD = RC.JUDCLASSCD(+)                         " & vbLf & _
              "            AND RC.JUDCLASSCD = SJ.JUDCLASSCD(+)                         " & vbLf & _
              "            AND RC.STDJUDCD   = SJ.STDJUDCD(+)                           " & vbLf & _
              "       ) JL, COURSE_JUD CJ                                               " & vbLf & _
              " WHERE JL.CSCD       = CJ.CSCD                                           " & vbLf & _
              "   AND JL.JUDCLASSCD = CJ.JUDCLASSCD                                     " & vbLf & _
              " ORDER BY CJ.SEQ                                                         "
'## 2004.01.06 Mod By T.Takagi@FSIT
'    strStmt = "SELECT JL.JUDCLASSCD, JL.JUDCLASSNAME, JL.JUDSNAME, JL.STDJUDNOTE,       " & vbLf & _
'              "       JL.FREEJUDCMT                                                     " & vbLf & _
'              "  FROM ( SELECT CN.CSCD, JC.JUDCLASSCD, JC.JUDCLASSNAME, JD.JUDSNAME,    " & vbLf & _
'              "                SJ.STDJUDNOTE, JR.FREEJUDCMT                             " & vbLf & _
'              "           FROM CONSULT CN, COURSE_P CP, JUDRSL JR, JUDCLASS JC, JUD JD, " & vbLf & _
'              "                JUDRSL_C RC, STDJUD SJ                                   " & vbLf & _
'              "          WHERE CN.RSVNO      = :RSVNO                                   " & vbLf & _
'              "            AND CN.RSVNO      = JR.RSVNO                                 " & vbLf & _
'              "            AND CN.CSCD       = CP.CSCD                                  " & vbLf & _
'              "            AND JR.JUDCLASSCD = JC.JUDCLASSCD                            " & vbLf & _
'              "            AND JR.JUDCD      = JD.JUDCD(+)                              " & vbLf & _
'              "            AND JR.RSVNO      = RC.RSVNO(+)                              " & vbLf & _
'              "            AND JR.JUDCLASSCD = RC.JUDCLASSCD(+)                         " & vbLf & _
'              "            AND RC.JUDCLASSCD = SJ.JUDCLASSCD(+)                         " & vbLf & _
'              "            AND RC.STDJUDCD   = SJ.STDJUDCD(+)                           " & vbLf & _
'              "       ) JL                                                              " & vbLf & _
'              " ORDER BY JL.JUDCLASSCD                                                  "
    strStmt = "SELECT JL.JUDCLASSCD, JL.JUDCLASSNAME, JL.JUDSNAME, JL.STDJUDNOTE,       " & vbLf & _
              "       JL.FREEJUDCMT                                                     " & vbLf & _
              "  FROM ( SELECT CN.CSCD, JC.JUDCLASSCD, JC.JUDCLASSNAME, JD.JUDSNAME,    " & vbLf & _
              "                '' STDJUDNOTE, '' FREEJUDCMT                             " & vbLf & _
              "           FROM CONSULT CN, COURSE_P CP, JUDRSL JR, JUDCLASS JC, JUD JD, " & vbLf & _
              "                JUDRSL_C RC                                              " & vbLf & _
              "          WHERE CN.RSVNO      = :RSVNO                                   " & vbLf & _
              "            AND CN.RSVNO      = JR.RSVNO                                 " & vbLf & _
              "            AND CN.CSCD       = CP.CSCD                                  " & vbLf & _
              "            AND JR.JUDCLASSCD = JC.JUDCLASSCD                            " & vbLf & _
              "            AND JR.JUDCD      = JD.JUDCD(+)                              " & vbLf & _
              "            AND JR.RSVNO      = RC.RSVNO(+)                              " & vbLf & _
              "            AND JR.JUDCLASSCD = RC.JUDCLASSCD(+)                         " & vbLf & _
              "       ) JL                                                              " & vbLf & _
              " ORDER BY JL.JUDCLASSCD                                                  "
'## 2004.01.06 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudSName = objFields("JUDSNAME")
        Set objStdJudNote = objFields("STDJUDNOTE")
        Set objFreeJudCmt = objFields("FREEJUDCMT")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrJudSName(lngCount)
            ReDim Preserve vntArrStdJudNote(lngCount)
            ReDim Preserve vntArrFreeJudCmt(lngCount)
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrJudClassName(lngCount) = objJudClassName.Value
            vntArrJudSName(lngCount) = objJudSName.Value & ""
            vntArrStdJudNote(lngCount) = objStdJudNote.Value & ""
            vntArrFreeJudCmt(lngCount) = objFreeJudCmt.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntJudClassCd = vntArrJudClassCd
    vntJudClassName = vntArrJudClassName
    vntJudSName = vntArrJudSName
    vntStdJudNote = vntArrStdJudNote
    vntFreeJudCmt = vntArrFreeJudCmt
    
    SelectInquiryJudRslList = lngCount
    
    Set objOraDyna = Nothing
    
    'キー値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectInquiryJudRslList"
    
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
' 機能　　 : 予約番号の判定結果を取得する
'
' 引数　　 : (In)     strRsvNo        予約番号
' 　　　　 : (In)     strCsCd         コースコード
' 　　　　 : (In)     strSecondFlg    ２次健診対象フラグ
' 　　　　 :                          (RSLSECOND_NONE:２次健診は表示しない)
' 　　　　 :                          (RSLSECOND_ALL :２次健診も表示する)
' 　　　　 : (Out)    vntJudClassCd   判定分類コード
' 　　　　 : (Out)    vntJudClassName 判定分類名称
' 　　　　 : (Out)    vntNoReason     自動展開フラグ(0:自動展開しない 1:自動展開する)
' 　　　　 : (Out)    vntJudCd        判定コード
' 　　　　 : (Out)    vntBefJudSName  前回判定略称
' 　　　　 : (Out)    vntDoctorCd     判定医コード
' 　　　　 : (Out)    vntDoctorName   判定医名
' 　　　　 : (Out)    vntFreeJudCmt   フリー判定コメント
' 　　　　 : (Out)    vntStdJudCd     定型所見コード
' 　　　　 : (Out)    vntStdJudNote   定型所見名称
' 　　　　 : (Out)    vntJudCmtCd     判定コメントコード
' 　　　　 : (Out)    vntJudCmtStc    判定コメント
' 　　　　 : (Out)    vntGuidanceCd   指導内容コード
' 　　　　 : (Out)    vntGuidanceStc  指導内容
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 自動展開する判定分類を考慮する
'
Public Function SelectJudRslList(ByVal strRsvNo As String, _
                                 ByVal strCsCd As String, _
                                 ByVal strSecondFlg As String, _
                                 Optional ByRef vntJudClassCd As Variant, _
                                 Optional ByRef vntJudClassName As Variant, _
                                 Optional ByRef vntNoReason As Variant, _
                                 Optional ByRef vntJudCd As Variant, _
                                 Optional ByRef vntBefJudSName As Variant, _
                                 Optional ByRef vntDoctorCd As Variant, _
                                 Optional ByRef vntDoctorName As Variant, _
                                 Optional ByRef vntFreeJudCmt As Variant, _
                                 Optional ByRef vntStdJudCd As Variant, _
                                 Optional ByRef vntStdJudNote As Variant, _
                                 Optional ByRef vntJudCmtCd As Variant, _
                                 Optional ByRef vntJudCmtStc As Variant, _
                                 Optional ByRef vntGuidanceCd As Variant, _
                                 Optional ByRef vntGuidanceStc As Variant _
                                ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objCommon               As Common           '共通クラス
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objNoReason             As OraField         '無条件展開フラグ
    Dim objJudCd                As OraField         '判定コード
    Dim objBefJudSName          As OraField         '前回判定名称
    Dim objDoctorCd             As OraField         '判定医コード
    Dim objDoctorName           As OraField         '判定医名
    Dim objFreeJudCmt           As OraField         'フリー判定コメント
    Dim objStdJudCd             As OraField         '定型所見コード
    Dim objStdJudNote           As OraField         '定型所見名称
'## 2002.11.18 Added 3Lines by H.Ishihara(FSIT) 指導内容、判定コメントコードSelect
    Dim objJudCmtCd             As OraField         '判定コメントコード
    Dim objJudCmtStc            As OraField         '判定コメント
    Dim objGuidanceCd           As OraField         '指導内容コード
    Dim objGuidanceStc          As OraField         '指導内容
'## 2002.11.18 Added End
    
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudCd()           As Variant          '判定コードの配列
    Dim vntArrNoReason()        As Variant          '無条件展開フラグの配列
    Dim vntArrBefJudSName()     As Variant          '前回判定名称の配列
    Dim vntArrDoctorCd()        As Variant          '判定医コードの配列
    Dim vntArrDoctorName()      As Variant          '判定医名の配列
    Dim vntArrFreeJudCmt()      As Variant          'フリー判定コメントの配列
    Dim vntArrStdJudCd()        As Variant          '定型所見コードの配列
    Dim vntArrStdJudNote()      As Variant          '定型所見名称の配列
'## 2002.11.18 Added 3Lines by H.Ishihara(FSIT) 指導内容、判定コメントコードSelect
    Dim vntArrJudCmtCd()        As Variant          '判定コメントコードの配列
    Dim vntArrJudCmtStc()       As Variant          '判定コメントの配列
    Dim vntArrGuidanceCd()      As Variant          '指導内容コードの配列
    Dim vntArrGuidanceStc()     As Variant          '指導内容の配列
'## 2002.11.18 Added End
    
    Dim vntWrkStdJudCd()        As Variant
    Dim vntWrkStdJudNote()      As Variant
    
    Dim lngCount                As Long             'レコード数
    
    Dim i                       As Long             'インデックス
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '予約番号・コースコードが設定されていない場合はエラー
    If IsEmpty(strRsvNo) Or IsEmpty(strCsCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If strSecondFlg <> RSLSECOND_NONE And strSecondFlg <> RSLSECOND_ALL Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.04 Del 2Lines By T.Takagi@FSIT ストアドと共通化
'    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "CANCELFLG", CStr(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.04 Del End
    If strSecondFlg = RSLSECOND_NONE Then
        objOraParam.Add "SECONDFLG", CStr(COURSE_FIRST), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.04 Add 2Lines By T.Takagi@FSIT ストアドと共通化
    Else
        objOraParam.Add "SECONDFLG", COURSE_SECOND, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.04 Add End
    End If
    
    '検索条件を満たす判定結果のレコードを取得
'## 2003.02.04 Mod 205Lines By T.Takagi@FSIT ストアドと共通化
''## 2002.11.18 Modify 2Lines by H.Ishihara(FSIT) 指導内容、判定コメントコードSelect
''    strStmt = "SELECT CJ.JUDCLASSCD, CJ.JUDCLASSNAME, CJ.JUDCD, BJ.JUDSNAME BEFJUDSNAME,    " & vbLf & _
'              "       CJ.DOCTORCD, CJ.USERNAME, CJ.FREEJUDCMT, CJ.NOREASON                  " & vbLf & _
'              "  FROM ( SELECT SJ.SEQ, SJ.JUDCLASSCD, SJ.JUDCLASSNAME, SJ.JUDCD,            " & vbLf & _
'              "                SJ.DOCTORCD, HU.USERNAME, SJ.FREEJUDCMT, SJ.NOREASON         " & vbLf & _
'              "           FROM ( SELECT JC.SEQ, JC.JUDCLASSCD, JC.JUDCLASSNAME, JR.JUDCD,   " & vbLf & _
'              "                         JR.DOCTORCD, JR.FREEJUDCMT, JC.NOREASON             " & vbLf & _
'              "                    FROM ( SELECT CJ.SEQ, CJ.JUDCLASSCD, J.JUDCLASSNAME,     " & vbLf & _
'              "                                  CJ.NOREASON                                " & vbLf & _
'              "                             FROM COURSE_JUD CJ, JUDCLASS J                  " & vbLf & _
'              "                            WHERE CJ.CSCD = :CSCD                            " & vbLf & _
'              "                              AND CJ.NOREASON = 1                            " & vbLf & _
'              "                              AND CJ.JUDCLASSCD = J.JUDCLASSCD               " & vbLf & _
'              "                           UNION                                             " & vbLf & _
'              "                           SELECT CJ.SEQ, CJ.JUDCLASSCD, J.JUDCLASSNAME,     " & vbLf & _
'              "                                  CJ.NOREASON                                " & vbLf & _
'              "                             FROM COURSE_JUD CJ, ITEM_JUD IJ, JUDCLASS J     " & vbLf & _
'              "                            WHERE CJ.CSCD       = :CSCD                      " & vbLf & _
'              "                              AND CJ.NOREASON   = 0                          " & vbLf & _
'              "                              AND CJ.JUDCLASSCD = J.JUDCLASSCD               " & vbLf & _
'              "                              AND CJ.JUDCLASSCD = IJ.JUDCLASSCD              " & vbLf & _
'              "                              AND EXISTS ( SELECT R.ITEMCD                   " & vbLf & _
'              "                                             FROM RSL R                      " & vbLf & _
'              "                                            WHERE R.RSVNO  = :RSVNO          "
'
''    strStmt = strStmt & vbLf & _
'              "                                              AND R.ITEMCD = IJ.ITEMCD       " & vbLf & _
'              "                                         )                                   " & vbLf & _
'              "                         ) JC, JUDRSL JR                                     " & vbLf & _
'              "                   WHERE JC.JUDCLASSCD = JR.JUDCLASSCD(+)                    " & vbLf & _
'              "                     AND JR.RSVNO(+) = :RSVNO                                " & vbLf & _
'              "                ) SJ, HAINSUSER HU                                           " & vbLf & _
'              "          WHERE SJ.DOCTORCD = HU.USERID(+)                                   " & vbLf & _
'              "       ) CJ,                                                                 " & vbLf & _
'              "       ( SELECT JR.JUDCLASSCD, JR.JUDCD, J.JUDSNAME                          " & vbLf & _
'              "           FROM ( SELECT RSVNO                                               " & vbLf & _
'              "                    FROM ( SELECT BC.RSVNO, BC.PERID, BC.CSLDATE             " & vbLf & _
'              "                             FROM ( SELECT CN.PERID, (CN.CSLDATE - 1) BEFDATE" & vbLf & _
'              "                                      FROM CONSULT CN                        " & vbLf & _
'              "                                     WHERE CN.RSVNO = :RSVNO                 " & vbLf & _
'              "                                  ) CN, CONSULT BC, COURSE_P CP, RECEIPT RC  " & vbLf & _
'              "                            WHERE BC.PERID     =  CN.PERID                   " & vbLf & _
'              "                              AND BC.CSLDATE   <= CN.BEFDATE                 " & vbLf & _
'              "                              AND BC.CANCELFLG =  :CANCELFLG                 " & vbLf & _
'              "                              AND BC.CSCD      =  CP.CSCD                    " & vbLf & _
'              "                              AND BC.RSVNO     =  RC.RSVNO                   " & vbLf & _
'              "                              AND BC.CSLDATE   =  RC.CSLDATE                 "
'
''## 2002.12.05 Modify 2Lines by H.Ishihara(FSIT) 判定はサブコース、サブコース返しのメインを含める
''    strStmt = "SELECT CJ.JUDCLASSCD, CJ.JUDCLASSNAME, CJ.JUDCD, BJ.JUDSNAME BEFJUDSNAME,    " & vbLf & _
''              "       CJ.DOCTORCD, CJ.USERNAME, CJ.FREEJUDCMT, CJ.NOREASON, CJ.JUDCMTCD, CJ.JUDCMTSTC, CJ.GUIDANCECD, CJ.GUIDANCESTC                  " & vbLf & _
''              "  FROM ( SELECT SJ.SEQ, SJ.JUDCLASSCD, SJ.JUDCLASSNAME, SJ.JUDCD,            " & vbLf & _
''              "                SJ.DOCTORCD, HU.USERNAME, SJ.FREEJUDCMT, SJ.NOREASON, SJ.JUDCMTCD, JUDCMTSTC.JUDCMTSTC, SJ.GUIDANCECD, GUIDANCE.GUIDANCESTC " & vbLf & _
''              "           FROM ( SELECT JC.SEQ, JC.JUDCLASSCD, JC.JUDCLASSNAME, JR.JUDCD,   " & vbLf & _
''              "                         JR.DOCTORCD, JR.FREEJUDCMT, JC.NOREASON, JR.JUDCMTCD, JR.GUIDANCECD " & vbLf & _
''              "                    FROM ( SELECT CJ.SEQ, CJ.JUDCLASSCD, J.JUDCLASSNAME,     " & vbLf & _
''              "                                  CJ.NOREASON                                " & vbLf & _
''              "                             FROM COURSE_JUD CJ, JUDCLASS J                  " & vbLf & _
''              "                            WHERE CJ.CSCD = :CSCD                            " & vbLf & _
''              "                              AND CJ.NOREASON = 1                            " & vbLf & _
''              "                              AND CJ.JUDCLASSCD = J.JUDCLASSCD               " & vbLf & _
''              "                           UNION                                             " & vbLf & _
''              "                           SELECT CJ.SEQ, CJ.JUDCLASSCD, J.JUDCLASSNAME,     " & vbLf & _
''              "                                  CJ.NOREASON                                " & vbLf & _
''              "                             FROM COURSE_JUD CJ, ITEM_JUD IJ, JUDCLASS J     " & vbLf & _
''              "                            WHERE CJ.CSCD       = :CSCD                      " & vbLf & _
''              "                              AND CJ.NOREASON   = 0                          " & vbLf & _
''              "                              AND CJ.JUDCLASSCD = J.JUDCLASSCD               " & vbLf & _
''              "                              AND CJ.JUDCLASSCD = IJ.JUDCLASSCD              " & vbLf & _
''              "                              AND EXISTS ( SELECT R.ITEMCD                   " & vbLf & _
''              "                                             FROM RSL R                      " & vbLf & _
''              "                                            WHERE R.RSVNO  = :RSVNO          "
''    strStmt = strStmt & vbLf & _
''              "                                              AND R.ITEMCD = IJ.ITEMCD       " & vbLf & _
''              "                                         )                                   " & vbLf & _
''              "                         ) JC, JUDRSL JR                                     " & vbLf & _
''              "                   WHERE JC.JUDCLASSCD = JR.JUDCLASSCD(+)                    " & vbLf & _
''              "                     AND JR.RSVNO(+) = :RSVNO                                " & vbLf & _
''              "                ) SJ, HAINSUSER HU, GUIDANCE GUIDANCE, JUDCMTSTC JUDCMTSTC   " & vbLf & _
''              "          WHERE SJ.DOCTORCD   = HU.USERID(+)                                 " & vbLf & _
''              "            AND SJ.GUIDANCECD = GUIDANCE.GUIDANCECD(+)                       " & vbLf & _
''              "            AND SJ.JUDCMTCD   = JUDCMTSTC.JUDCMTCD(+)                        " & vbLf & _
''              "       ) CJ,                                                                 " & vbLf & _
''              "       ( SELECT JR.JUDCLASSCD, JR.JUDCD, J.JUDSNAME                          " & vbLf & _
''              "           FROM ( SELECT RSVNO                                               " & vbLf & _
''              "                    FROM ( SELECT BC.RSVNO, BC.PERID, BC.CSLDATE             " & vbLf & _
''              "                             FROM ( SELECT CN.PERID, (CN.CSLDATE - 1) BEFDATE" & vbLf & _
''              "                                      FROM CONSULT CN                        " & vbLf & _
''              "                                     WHERE CN.RSVNO = :RSVNO                 " & vbLf & _
''              "                                  ) CN, CONSULT BC, COURSE_P CP, RECEIPT RC  " & vbLf & _
''              "                            WHERE BC.PERID     =  CN.PERID                   " & vbLf & _
''              "                              AND BC.CSLDATE   <= CN.BEFDATE                 " & vbLf & _
''              "                              AND BC.CANCELFLG =  :CANCELFLG                 " & vbLf & _
''              "                              AND BC.CSCD      =  CP.CSCD                    " & vbLf & _
''              "                              AND BC.RSVNO     =  RC.RSVNO                   " & vbLf & _
''              "                              AND BC.CSLDATE   =  RC.CSLDATE                 "
''## 2002.12.17 Modify xLines by H.Ishihara(FSIT) 予約番号をテストのまま埋め込んでいた・・・
'    strStmt = "SELECT CJ.JUDCLASSCD, CJ.JUDCLASSNAME, CJ.JUDCD, BJ.JUDSNAME BEFJUDSNAME,    " & vbLf & _
'              "       CJ.DOCTORCD, CJ.USERNAME, CJ.FREEJUDCMT, CJ.NOREASON, CJ.JUDCMTCD, CJ.JUDCMTSTC, CJ.GUIDANCECD, CJ.GUIDANCESTC                  " & vbLf & _
'              "  FROM ( SELECT SJ.SEQ, SJ.JUDCLASSCD, SJ.JUDCLASSNAME, SJ.JUDCD,            " & vbLf & _
'              "                SJ.DOCTORCD, HU.USERNAME, SJ.FREEJUDCMT, SJ.NOREASON, SJ.JUDCMTCD, JUDCMTSTC.JUDCMTSTC, SJ.GUIDANCECD, GUIDANCE.GUIDANCESTC " & vbLf & _
'              "           FROM ( SELECT JC.SEQ, JC.JUDCLASSCD, JC.JUDCLASSNAME, JR.JUDCD,   " & vbLf & _
'              "                         JR.DOCTORCD, JR.FREEJUDCMT, JC.NOREASON, JR.JUDCMTCD, JR.GUIDANCECD " & vbLf
'
'    strStmt = strStmt & vbLf & _
'              "                    FROM ( SELECT CJ.SEQ, CJ.JUDCLASSCD, J.JUDCLASSNAME, CJ.NOREASON        " & vbLf & _
'              "                             FROM COURSE_JUD CJ, JUDCLASS J                                 " & vbLf & _
'              "                            WHERE CJ.CSCD IN ( SELECT CTRPT_OPT.CSCD CSCD                   " & vbLf & _
'              "                                                 FROM CTRPT_OPT, CONSULT_O                  " & vbLf & _
'              "                                                WHERE CONSULT_O.RSVNO = :RSVNO              " & vbLf & _
'              "                                                  AND CTRPT_OPT.CTRPTCD = CONSULT_O.CTRPTCD " & vbLf & _
'              "                                                  AND CTRPT_OPT.OPTCD = CONSULT_O.OPTCD     " & vbLf & _
'              "                                                GROUP BY CTRPT_OPT.CSCD                     " & vbLf & _
'              "                                                UNION                                       " & vbLf & _
'              "                                               SELECT COURSE_P.MAINCSCD CSCD                " & vbLf & _
'              "                                                 FROM COURSE_P, CTRPT_OPT, CONSULT_O        " & vbLf & _
'              "                                                WHERE CONSULT_O.RSVNO = :RSVNO              " & vbLf & _
'              "                                                  AND CTRPT_OPT.CTRPTCD = CONSULT_O.CTRPTCD " & vbLf & _
'              "                                                  AND CTRPT_OPT.OPTCD = CONSULT_O.OPTCD     " & vbLf & _
'              "                                                  AND COURSE_P.CSCD = CTRPT_OPT.CSCD        " & vbLf & _
'              "                                                GROUP BY COURSE_P.MAINCSCD )                " & vbLf & _
'              "                              AND CJ.NOREASON = 1                                           " & vbLf & _
'              "                              AND CJ.JUDCLASSCD = J.JUDCLASSCD                              " & vbLf & _
'              "                            UNION                                                           " & vbLf
'    strStmt = strStmt & vbLf & _
'              "                           SELECT CJ.SEQ, CJ.JUDCLASSCD, J.JUDCLASSNAME, CJ.NOREASON        " & vbLf & _
'              "                             FROM COURSE_JUD CJ, ITEM_JUD IJ, JUDCLASS J                    " & vbLf & _
'              "                            WHERE CJ.CSCD IN ( SELECT CTRPT_OPT.CSCD CSCD                   " & vbLf & _
'              "                                                 FROM CTRPT_OPT, CONSULT_O                  " & vbLf & _
'              "                                                WHERE CONSULT_O.RSVNO = :RSVNO              " & vbLf & _
'              "                                                  AND CTRPT_OPT.CTRPTCD = CONSULT_O.CTRPTCD " & vbLf & _
'              "                                                  AND CTRPT_OPT.OPTCD = CONSULT_O.OPTCD     " & vbLf & _
'              "                                                GROUP BY CTRPT_OPT.CSCD                     " & vbLf & _
'              "                                                UNION                                       " & vbLf & _
'              "                                               SELECT COURSE_P.MAINCSCD CSCD                " & vbLf & _
'              "                                                 FROM COURSE_P, CTRPT_OPT, CONSULT_O        " & vbLf & _
'              "                                                WHERE CONSULT_O.RSVNO = :RSVNO              " & vbLf & _
'              "                                                  AND CTRPT_OPT.CTRPTCD = CONSULT_O.CTRPTCD " & vbLf & _
'              "                                                  AND CTRPT_OPT.OPTCD = CONSULT_O.OPTCD     " & vbLf & _
'              "                                                  AND COURSE_P.CSCD = CTRPT_OPT.CSCD        " & vbLf & _
'              "                                                GROUP BY COURSE_P.MAINCSCD )                " & vbLf
'
'    strStmt = strStmt & vbLf & _
'              "                              AND CJ.NOREASON   = 0                     " & vbLf & _
'              "                              AND CJ.JUDCLASSCD = J.JUDCLASSCD          " & vbLf & _
'              "                              AND CJ.JUDCLASSCD = IJ.JUDCLASSCD         " & vbLf & _
'              "                              AND EXISTS ( SELECT R.ITEMCD              " & vbLf & _
'              "                                             FROM RSL R                 " & vbLf & _
'              "                                            WHERE R.RSVNO  = :RSVNO     " & vbLf & _
'              "                                              AND R.ITEMCD = IJ.ITEMCD) " & vbLf
'
''★★★★★★★★★★★★★★★★★★★
''ここでJUDRSLともう一度UNIONしないと、判定を登録した後に、コースから判定分類を削除すると
''判定画面には永遠に出てこなくなる。（そのくせ帳票にはでちゃうぞ、多分）
''もしくは、ちょっと変だけど、ここに入る前にこっそり削除する？
''消したくても消えないのでは？
''★★★★★★★★★★★★★★★★★★★
'
'
'    strStmt = strStmt & vbLf & _
'              "                         ) JC, JUDRSL JR                                     " & vbLf & _
'              "                   WHERE JC.JUDCLASSCD = JR.JUDCLASSCD(+)                    " & vbLf & _
'              "                     AND JR.RSVNO(+) = :RSVNO                                " & vbLf & _
'              "                ) SJ, HAINSUSER HU, GUIDANCE GUIDANCE, JUDCMTSTC JUDCMTSTC   " & vbLf & _
'              "          WHERE SJ.DOCTORCD   = HU.USERID(+)                                 " & vbLf & _
'              "            AND SJ.GUIDANCECD = GUIDANCE.GUIDANCECD(+)                       " & vbLf & _
'              "            AND SJ.JUDCMTCD   = JUDCMTSTC.JUDCMTCD(+)                        " & vbLf & _
'              "       ) CJ,                                                                 " & vbLf & _
'              "       ( SELECT JR.JUDCLASSCD, JR.JUDCD, J.JUDSNAME                          " & vbLf & _
'              "           FROM ( SELECT RSVNO                                               " & vbLf & _
'              "                    FROM ( SELECT BC.RSVNO, BC.PERID, BC.CSLDATE             " & vbLf & _
'              "                             FROM ( SELECT CN.PERID, (CN.CSLDATE - 1) BEFDATE" & vbLf & _
'              "                                      FROM CONSULT CN                        " & vbLf & _
'              "                                     WHERE CN.RSVNO = :RSVNO                 " & vbLf & _
'              "                                  ) CN, CONSULT BC, COURSE_P CP, RECEIPT RC  " & vbLf & _
'              "                            WHERE BC.PERID     =  CN.PERID                   " & vbLf & _
'              "                              AND BC.CSLDATE   <= CN.BEFDATE                 " & vbLf & _
'              "                              AND BC.CANCELFLG =  :CANCELFLG                 " & vbLf & _
'              "                              AND BC.CSCD      =  CP.CSCD                    " & vbLf & _
'              "                              AND BC.RSVNO     =  RC.RSVNO                   " & vbLf & _
'              "                              AND BC.CSLDATE   =  RC.CSLDATE                 "
''## 2002.12.05 Modify End
''## 2002.11.18 Modify End
'
'    '「２次健診は表示しない」場合
'    If strSecondFlg = RSLSECOND_NONE Then
'        strStmt = strStmt & vbLf & _
'              "                              AND CP.SECONDFLG =  :SECONDFLG                 "
'    End If
'    strStmt = strStmt & vbLf & _
'              "                            ORDER BY BC.CSLDATE DESC                         " & vbLf & _
'              "                         )                                                   " & vbLf & _
'              "                   WHERE ROWNUM = 1                                          " & vbLf & _
'              "                ) BC, JUDRSL JR, JUD J                                       " & vbLf & _
'              "          WHERE BC.RSVNO = JR.RSVNO                                          " & vbLf & _
'              "            AND JR.JUDCD = J.JUDCD                                           " & vbLf & _
'              "        ) BJ                                                                 " & vbLf & _
'              " WHERE CJ.JUDCLASSCD = BJ.JUDCLASSCD(+)                                      " & vbLf & _
'              " ORDER BY CJ.SEQ                                                             "
'
'    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    strStmt = "BEGIN JudgementPackage.SelectJudRslList(:RSVNO, :SECONDFLG, :CURSOR_JUDRSL); END;"
    
    Set objOraDyna = mobjOraDb.CreatePlsqlDynaset(strStmt, "CURSOR_JUDRSL", ORADYN_NOCACHE)
'## 2003.02.04 Mod End
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objNoReason = objFields("NOREASON")
        Set objJudCd = objFields("JUDCD")
        Set objBefJudSName = objFields("BEFJUDSNAME")
        Set objDoctorCd = objFields("DOCTORCD")
        Set objDoctorName = objFields("USERNAME")
        Set objFreeJudCmt = objFields("FREEJUDCMT")
        
'## 2002.11.18 Added 3Lines by H.Ishihara(FSIT) 指導内容、判定コメントコードSelect
        Set objJudCmtCd = objFields("JUDCMTCD")
        Set objJudCmtStc = objFields("JUDCMTSTC")
        Set objGuidanceCd = objFields("GUIDANCECD")
        Set objGuidanceStc = objFields("GUIDANCESTC")
'## 2002.11.18 Added End
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrNoReason(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrBefJudSName(lngCount)
            ReDim Preserve vntArrDoctorCd(lngCount)
            ReDim Preserve vntArrDoctorName(lngCount)
            ReDim Preserve vntArrFreeJudCmt(lngCount)
            ReDim Preserve vntArrStdJudCd(lngCount)
            ReDim Preserve vntArrStdJudNote(lngCount)
'## 2002.11.18 Added 3Lines by H.Ishihara(FSIT) 指導内容、判定コメントコードSelect
            ReDim Preserve vntArrJudCmtCd(lngCount)
            ReDim Preserve vntArrJudCmtStc(lngCount)
            ReDim Preserve vntArrGuidanceCd(lngCount)
            ReDim Preserve vntArrGuidanceStc(lngCount)
'## 2002.11.18 Added End
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrJudClassName(lngCount) = objJudClassName.Value
            vntArrNoReason(lngCount) = objNoReason.Value
            vntArrJudCd(lngCount) = objJudCd.Value & ""
            vntArrBefJudSName(lngCount) = objBefJudSName.Value & ""
            vntArrDoctorCd(lngCount) = objDoctorCd.Value & ""
            vntArrDoctorName(lngCount) = objDoctorName.Value & ""
            vntArrFreeJudCmt(lngCount) = objFreeJudCmt.Value & ""
            vntArrStdJudCd(lngCount) = ""
            vntArrStdJudNote(lngCount) = ""
'## 2002.11.18 Added 3Lines by H.Ishihara(FSIT) 指導内容、判定コメントコードSelect
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            vntArrJudCmtStc(lngCount) = objJudCmtStc.Value & ""
            vntArrGuidanceCd(lngCount) = objGuidanceCd.Value & ""
            vntArrGuidanceStc(lngCount) = objGuidanceStc.Value & ""
'## 2002.11.18 Added End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntJudClassCd = vntArrJudClassCd
    vntJudClassName = vntArrJudClassName
    vntNoReason = vntArrNoReason
    vntJudCd = vntArrJudCd
    vntBefJudSName = vntArrBefJudSName
    vntDoctorCd = vntArrDoctorCd
    vntDoctorName = vntArrDoctorName
    vntFreeJudCmt = vntArrFreeJudCmt
'## 2002.11.18 Added 3Lines by H.Ishihara(FSIT) 指導内容、判定コメントコードSelect
    If IsMissing(vntJudCmtCd) = False Then vntJudCmtCd = vntArrJudCmtCd
    If IsMissing(vntJudCmtStc) = False Then vntJudCmtStc = vntArrJudCmtStc
    If IsMissing(vntGuidanceCd) = False Then vntGuidanceCd = vntArrGuidanceCd
    If IsMissing(vntGuidanceStc) = False Then vntGuidanceStc = vntArrGuidanceStc
'## 2002.11.18 Added End

    SelectJudRslList = lngCount
    
    Set objOraDyna = Nothing
    
    'キー値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    If lngCount > 0 Then
        
        For i = 0 To UBound(vntJudClassCd)
            
            'キー値の設定
            objOraParam.Add "RSVNO", Trim(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "JUDCLASSCD", Trim(vntJudClassCd(i)), ORAPARM_INPUT, ORATYPE_NUMBER
            
            '検索条件を満たす判定所見のレコードを取得
            strStmt = "SELECT JC.JUDCLASSCD, JC.STDJUDCD, SJ.STDJUDNOTE " & vbLf & _
                      "  FROM JUDRSL_C JC, STDJUD SJ                    " & vbLf & _
                      " WHERE JC.RSVNO      = :RSVNO                    " & vbLf & _
                      "   AND JC.JUDCLASSCD = :JUDCLASSCD               " & vbLf & _
                      "   AND JC.JUDCLASSCD = SJ.JUDCLASSCD             " & vbLf & _
                      "   AND JC.STDJUDCD   = SJ.STDJUDCD               "
    
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
            '検索レコードが存在する場合
            If Not objOraDyna.EOF Then
    
                'オブジェクトの参照設定
                Set objFields = objOraDyna.Fields
                Set objStdJudCd = objFields("STDJUDCD")
                Set objStdJudNote = objFields("STDJUDNOTE")
    
                '配列形式で格納する
                lngCount = 0
                Do Until objOraDyna.EOF
                    ReDim Preserve vntWrkStdJudCd(lngCount)
                    ReDim Preserve vntWrkStdJudNote(lngCount)
                    vntWrkStdJudCd(lngCount) = objStdJudCd.Value
                    vntWrkStdJudNote(lngCount) = objStdJudNote.Value
                    lngCount = lngCount + 1
                    objOraDyna.MoveNext
                Loop
    
                vntArrStdJudCd(i) = Join(vntWrkStdJudCd, ",")
                vntArrStdJudNote(i) = Join(vntWrkStdJudNote, ",")
            
            End If
        
            Set objOraDyna = Nothing
    
            'キー値の設定解除
            Do Until objOraParam.Count <= 0
                objOraParam.Remove (objOraParam.Count - 1)
            Loop
    
        Next i
    
    End If
    
    '戻り値の設定
    vntStdJudCd = vntArrStdJudCd
    vntStdJudNote = vntArrStdJudNote
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectJudRslList"
    
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
' 機能　　 : 自動判定結果を取得する
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     strPerId           個人ID
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     strJudClassCd      判定分類コード
' 　　　　   (In)     lngLightestWeight  最も軽い判定の重み
' 　　　　   (In)     strLightestJudCd   最も軽い判定コード
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
' 　　　　   (Out)    vntRsvNo           予約番号
' 　　　　   (Out)    vntJudClassCd      判定分類コード
' 　　　　   (Out)    vntWeight          重み
' 　　　　   (Out)    vntJudCd           判定コード
' 　　　　   (Out)    vntJudCmtStc       判定コメント文章
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectJudRslAutomatically( _
    ByVal dtmCslDate As Date, _
    ByVal strPerId As String, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal lngLightestWeight As Long, _
    ByVal strLightestJudCd As String, _
    ByVal blnReJudge As Boolean, _
    ByVal blnEntryCheck As Boolean, _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    ByRef vntWeight As Variant, _
    ByRef vntJudCd As Variant, _
    ByRef vntJudCmtStc As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objJudClassCd       As OraField         '判定分類コード
    Dim objWeight           As OraField         '重み
    Dim objJudCd            As OraField         '判定コード
    Dim objJudCmtStc        As OraField         '判定コメント文章
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrJudClassCd()  As Variant          '判定分類コード
    Dim vntArrWeight()      As Variant          '重み
    Dim vntArrJudCd()       As Variant          '判定コード
    Dim vntArrJudCmtStc()   As Variant          '判定コメント文章
    
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRsvNo = Empty
    vntJudClassCd = Empty
    vntWeight = Empty
    vntJudCd = Empty
    vntJudCmtStc = Empty
    lngCount = 0
    
'MsgBox "SelectJudRslAutomatically START! =>" & dtmCslDate
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    If Trim(strPerId) <> "" Then
        objOraParam.Add "PERID", CLng(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2002.6.4 Add 3Lines by T.Takagi(FSIT) 判定分類指定
    If Trim(strJudClassCd) <> "" Then
        objOraParam.Add "JUDCLASSCD", CLng(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2002.6.4 Add End
    
    '検索条件を満たす受診情報から判定分類および基準値判定を検索する
    '・同一受診情報における同一判定分類、判定、及び判定コメントを持つ場合は重複を許さずに取得
    '・かつ重み、判定の軽い順に取得
    '・基準値判定の結果がNULL値の場合は最も軽い判定をデフォルト値として取得させる
    '### 聖路加ではNULLはNULLのままとする　2004.01.03
'    strStmt = "SELECT DISTINCT                                                  " & vbLf & _
'              "       CONSULT.RSVNO,                                            " & vbLf & _
'              "       ITEM_JUD.JUDCLASSCD,                                      " & vbLf & _
'              "       NVL(JUD.WEIGHT,        " & lngLightestWeight & ") WEIGHT, " & vbLf & _
'              "       NVL(STDVALUE_C.JUDCD, '" & strLightestJudCd & "') JUDCD,  " & vbLf & _
'              "       JUDCMTSTC.JUDCMTSTC                                       "
    strStmt = "SELECT DISTINCT              " & vbLf & _
              "       CONSULT.RSVNO,        " & vbLf & _
              "       ITEM_JUD.JUDCLASSCD,  " & vbLf & _
              "       JUD.WEIGHT,           " & vbLf & _
              "       STDVALUE_C.JUDCD,     " & vbLf & _
              "       JUDCMTSTC.JUDCMTSTC   "
    ' ### 2004.01.03 end
              
    '取得に要する表の定義
    strStmt = strStmt & vbLf & _
              "  FROM JUDCMTSTC,  " & vbLf & _
              "       JUD,        " & vbLf & _
              "       STDVALUE_C, " & vbLf & _
              "       JUDCLASS,   " & vbLf & _
              "       COURSE_JUD, " & vbLf & _
              "       ITEM_JUD,   " & vbLf & _
              "       RSL,        " & vbLf & _
              "       CONSULT,    " & vbLf & _
              "       RECEIPT     "
              
    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              " WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
              "   AND RECEIPT.RSVNO   = CONSULT.RSVNO "
              
    '個人ID指定時は条件節に加える
    If Trim(strPerId) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.PERID = :PERID "
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD = :CSCD "
    End If

    '結果未入力の検査項目は判定対象としない
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.RSVNO = RSL.RSVNO " & vbLf & _
              "   AND RSL.RESULT   IS NOT NULL  "
              
    'ある判定分類に属する検査項目を対象とする
    strStmt = strStmt & vbLf & _
              "   AND RSL.ITEMCD = ITEM_JUD.ITEMCD "
              
'## 2002.6.4 Add 5Lines by T.Takagi(FSIT) 判定分類指定
    '判定分類指定時は条件節に追加
    If Trim(strJudClassCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ITEM_JUD.JUDCLASSCD = :JUDCLASSCD "
    End If
'## 2002.6.4 Add End
              
    '検査項目から求まる判定分類が受診コースの判定分類として存在する場合に判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD        = COURSE_JUD.CSCD       " & vbLf & _
              "   AND ITEM_JUD.JUDCLASSCD = COURSE_JUD.JUDCLASSCD "
              
    '総合判定用の判定分類はここでは対象としない
    strStmt = strStmt & vbLf & _
              "   AND ITEM_JUD.JUDCLASSCD = JUDCLASS.JUDCLASSCD " & vbLf & _
              "   AND JUDCLASS.ALLJUDFLG  = 0                   "

    'コメント表示のみの分類コードは対象外 2003.11.25
    '自動判定対象外のものも通常判定ではないものも対象としない 2003.12.12
    strStmt = strStmt & vbLf & _
              "   AND JUDCLASS.COMMENTONLY IS NULL              " & vbLf & _
              "   AND JUDCLASS.NOTAUTOFLG  IS NULL              " & vbLf & _
              "   AND JUDCLASS.NOTNORMALFLG IS NULL             "

'## 2002.4.2 Modify 18Lines by T.Takagi(FSIT) (東京臨海殿仕様)判定情報の再作成はコメントの有無で判定する
'    '再判定でない場合、すでに判定が存在する判定分類は対象としない
'    If Not blnReJudge Then
'        strStmt = strStmt & vbLf & _
'              "   AND NOT EXISTS ( SELECT CURJUDRSL.RSVNO                             " & vbLf & _
'              "                      FROM JUDRSL CURJUDRSL                            " & vbLf & _
'              "                     WHERE CURJUDRSL.RSVNO       = CONSULT.RSVNO       " & vbLf & _
'              "                       AND CURJUDRSL.JUDCLASSCD  = ITEM_JUD.JUDCLASSCD " & vbLf & _
'              "                       AND CURJUDRSL.JUDCD      IS NOT NULL )          "
'    End If
    '再判定でない場合、すでに判定が存在する判定分類は対象としない
    If Not blnReJudge Then
        strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT CURJUDRSL.RSVNO                             " & vbLf & _
              "                      FROM JUDRSL CURJUDRSL                            " & vbLf & _
              "                     WHERE CURJUDRSL.RSVNO       = CONSULT.RSVNO       " & vbLf & _
              "                       AND CURJUDRSL.JUDCLASSCD  = ITEM_JUD.JUDCLASSCD " & vbLf & _
              "                       AND CURJUDRSL.JUDCD      IS NOT NULL )          "
'## 不要項目削除 FREEJUDCMT 2003.12.15 by FFCS start
'              "                       AND CURJUDRSL.JUDCLASSCD  = ITEM_JUD.JUDCLASSCD " & vbLf & _
'              "                       AND CURJUDRSL.FREEJUDCMT IS NOT NULL )          "
'## 不要項目削除 FREEJUDCMT 2003.12.15 by FFCS end
    End If
'## 2002.4.2 Modify End

    '基準値判定情報をもつ検査項目のみを判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND EXISTS ( SELECT ITEMCD                                    " & vbLf & _
              "                  FROM STDVALUE                                  " & vbLf & _
              "                 WHERE ITEMCD   = RSL.ITEMCD                     " & vbLf & _
              "                   AND SUFFIX   = RSL.SUFFIX                     " & vbLf & _
              "                   AND STRDATE <= CONSULT.CSLDATE                " & vbLf & _
              "                   AND ENDDATE >= CONSULT.CSLDATE                " & vbLf & _
              "                   AND ( CSCD IS NULL OR CSCD = CONSULT.CSCD ) ) "
              
'## 2002.6.4 Add 50Lines by T.Takagi(FSIT) 未入力チェック
    '現レコードの判定分類に属する検査項目のうち未入力項目が存在するかをチェック
    If blnEntryCheck Then
        
        '本ブロックで指定判定分類に属する検査項目の検査結果レコードを取得
        strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT ENTRYCHECK_RSL.RSVNO                                        " & vbLf & _
              "                      FROM ITEM_P,                                                     " & vbLf & _
              "                           ITEM_JUD ENTRYCHECK_ITEM_JUD,                               " & vbLf & _
              "                           RSL      ENTRYCHECK_RSL                                     " & vbLf & _
              "                     WHERE ENTRYCHECK_RSL.RSVNO           = CONSULT.RSVNO              " & vbLf & _
              "                       AND ENTRYCHECK_RSL.ITEMCD          = ENTRYCHECK_ITEM_JUD.ITEMCD " & vbLf & _
              "                       AND ENTRYCHECK_ITEM_JUD.JUDCLASSCD = ITEM_JUD.JUDCLASSCD        " & vbLf & _
              "                       AND ENTRYCHECK_RSL.ITEMCD          = ITEM_P.ITEMCD              "

        '「分画項目が１つでも入力されていれば検査完了」の場合、同一依頼項目で入力済みの検査結果が１つも存在しなければ未入力とみなす
        strStmt = strStmt & vbLf & _
              "                       AND ( ( ITEM_P.ENTRYOK = 0                                              " & vbLf & _
              "                               AND                                                             " & vbLf & _
              "                               NOT EXISTS ( SELECT CHECK_RSL.RSVNO                             " & vbLf & _
              "                                              FROM RSLCMT RSLCMT1,                             " & vbLf & _
              "                                                   RSLCMT RSLCMT2,                             " & vbLf & _
              "                                                   RSL    CHECK_RSL                            " & vbLf & _
              "                                             WHERE CHECK_RSL.RSVNO     = ENTRYCHECK_RSL.RSVNO  " & vbLf & _
              "                                               AND CHECK_RSL.ITEMCD    = ENTRYCHECK_RSL.ITEMCD " & vbLf & _
              "                                               AND CHECK_RSL.RSLCMTCD1 = RSLCMT1.RSLCMTCD(+)   " & vbLf & _
              "                                               AND CHECK_RSL.RSLCMTCD2 = RSLCMT2.RSLCMTCD(+)   " & vbLf & _
              "                                               AND ( CHECK_RSL.RESULT IS NOT NULL OR           " & vbLf & _
              "                                                     RSLCMT1.ENTRYOK = 1          OR           " & vbLf & _
              "                                                     RSLCMT2.ENTRYOK = 1        ) ) )          "

        '「全ての分画項目が入力されれば検査完了」の場合、同一依頼項目で未入力の検査結果が１つでも存在すれば未入力とみなす
        strStmt = strStmt & vbLf & _
              "                             OR                                                            " & vbLf & _
              "                             ( ITEM_P.ENTRYOK = 1                                          " & vbLf & _
              "                               AND                                                         " & vbLf & _
              "                               EXISTS ( SELECT CHECK_RSL.RSVNO                             " & vbLf & _
              "                                          FROM RSLCMT RSLCMT1,                             " & vbLf & _
              "                                               RSLCMT RSLCMT2,                             " & vbLf & _
              "                                               RSL    CHECK_RSL                            " & vbLf & _
              "                                         WHERE CHECK_RSL.RSVNO     = ENTRYCHECK_RSL.RSVNO  " & vbLf & _
              "                                           AND CHECK_RSL.ITEMCD    = ENTRYCHECK_RSL.ITEMCD " & vbLf & _
              "                                           AND CHECK_RSL.RSLCMTCD1 = RSLCMT1.RSLCMTCD(+)   " & vbLf & _
              "                                           AND CHECK_RSL.RSLCMTCD2 = RSLCMT2.RSLCMTCD(+)   " & vbLf & _
              "                                           AND CHECK_RSL.RESULT IS NULL                    " & vbLf & _
              "                                           AND NVL(RSLCMT1.ENTRYOK, 0) = 0                 " & vbLf & _
              "                                           AND NVL(RSLCMT2.ENTRYOK, 0) = 0 ) )             " & vbLf & _
              "                           )                                                               " & vbLf & _
              "                  )                                                                        "
              
    End If
'## 2002.6.4 Add End
    
    'ここまでの条件を満たす検査項目の基準値判定情報から判定コードと重み、及び判定コメントコードを取得する
    strStmt = strStmt & vbLf & _
              "   AND RSL.STDVALUECD   = STDVALUE_C.STDVALUECD(+) " & vbLf & _
              "   AND STDVALUE_C.JUDCD = JUD.JUDCD(+)             "

    '判定コメントコードをもとに対象判定分類の判定コメントを取得する
    strStmt = strStmt & vbLf & _
              "   AND STDVALUE_C.JUDCMTCD = JUDCMTSTC.JUDCMTCD(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objWeight = objFields("WEIGHT")
        Set objJudCd = objFields("JUDCD")
        Set objJudCmtStc = objFields("JUDCMTSTC")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrWeight(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrJudCmtStc(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrWeight(lngCount) = objWeight.Value
            vntArrJudCd(lngCount) = objJudCd.Value
            vntArrJudCmtStc(lngCount) = objJudCmtStc.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntRsvNo = vntArrRsvNo
        vntJudClassCd = vntArrJudClassCd
        vntWeight = vntArrWeight
        vntJudCd = vntArrJudCd
        vntJudCmtStc = vntArrJudCmtStc
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectJudRslAutomatically = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectJudRslAutomatically"
    
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
' 機能　　 : 指定条件を満たす総合コメントを取得する（当日ＩＤ指定）
'
' 引数　　 : (In)     dtmCslDate     受診日
' 　　　　   (In)     lngDayIdFlg    1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId    検索開始ＩＤ
' 　　　　   (In)     lngEndDayId    検索終了ＩＤ
' 　　　　   (In)     vntArrDayId    検索ＩＤ（配列）
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     lngDispMode    コメント種別
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntMaxSeq      SEQ
' 　　　　   (Out)    vntJudCmtCd    判定コメントコード
'
' 戻り値　 : 件数
' 　　　　 :
'
' 備考　　 :
'
Public Function SelectTotalCmtList( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal lngDispMode As Long, _
    ByRef vntRsvNo As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntJudCmtCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objSeq              As OraField         'SEQ
    Dim objJudCmtCd         As OraField         '判定コメントコード
    
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrSeq()         As Variant          'SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    
    Dim i               As Long             'インデックス
    
    Dim lngCount        As Long             '件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPMODE", CLng(lngDispMode), ORAPARM_INPUT, ORATYPE_NUMBER
    
    
    ' ### 総合コメントクリア
    strStmt = "SELECT RSVNO, SEQ, JUDCMTCD                  " & vbLf & _
              "  FROM TOTALJUDCMT                           " & vbLf & _
              " WHERE ( RSVNO ) IN                          " & vbLf & _
              "       ( SELECT CONSULT.RSVNO                " & vbLf & _
              "           FROM CONSULT,                     " & vbLf & _
              "                RECEIPT                      "

    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE      = :CSLDATE      " & vbLf & _
              "            AND RECEIPT.RSVNO        = CONSULT.RSVNO "

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "            AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              

    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD         = :CSCD "
    End If
    
    strStmt = strStmt & vbLf & _
              "   )                        " & vbLf & _
              "   AND DISPMODE = :DISPMODE "
    
    strStmt = strStmt & vbLf & _
              " ORDER BY RSVNO, SEQ "

    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objSeq = objFields("SEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrSeq(lngCount) = objSeq.Value
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    End If
    
    vntRsvNo = vntArrRsvNo
    vntSeq = vntArrSeq
    vntJudCmtCd = vntArrJudCmtCd
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectTotalCmtList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectTotalCmtList = -1
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectTotalCmtList"
    
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
' 機能　　 : 自動判定結果を取得する（当日ＩＤ指定）
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     strJudClassCd      判定分類コード
' 　　　　   (In)     lngLightestWeight  最も軽い判定の重み
' 　　　　   (In)     strLightestJudCd   最も軽い判定コード
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
' 　　　　   (Out)    vntRsvNo           予約番号
' 　　　　   (Out)    vntJudClassCd      判定分類コード
' 　　　　   (Out)    vntWeight          重み
' 　　　　   (Out)    vntJudCd           判定コード
' 　　　　   (Out)    vntJudCmtStc       判定コメント文章
' ### 2003.12.25 判定コメントコード追加
' 　　　　   (Out)    vntJudCmtCd        判定コメントコード
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
'---------------------------------------------------------------------
'-- 管理番号：SL-UI-Y0101-101
'-- 修正日  ：2010.06.01
'-- 担当者  ：TCS)澤田
'-- 修正内容：重み、判定の軽い順に取得されない不具合の修正
'---------------------------------------------------------------------
Public Function SelectJudRslAutomaticallyDayId( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal lngLightestWeight As Long, _
    ByVal strLightestJudCd As String, _
    ByVal blnReJudge As Boolean, _
    ByVal blnEntryCheck As Boolean, _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    ByRef vntWeight As Variant, _
    ByRef vntJudCd As Variant, _
    ByRef vntJudCmtStc As Variant, _
    ByRef vntJudCmtCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objJudClassCd       As OraField         '判定分類コード
    Dim objWeight           As OraField         '重み
    Dim objJudCd            As OraField         '判定コード
    Dim objJudCmtStc        As OraField         '判定コメント文章
    Dim objJudCmtCd         As OraField         '判定コメントコード
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrJudClassCd()  As Variant          '判定分類コード
    Dim vntArrWeight()      As Variant          '重み
    Dim vntArrJudCd()       As Variant          '判定コード
    Dim vntArrJudCmtStc()   As Variant          '判定コメント文章
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    
'#### 2004.01.14 add start 乳房判定分類指定時用
    Dim vntNyubouItemCd1        As Variant         '乳房触診検査項目コード
    Dim vntNyubouItemCd2        As Variant         '乳房Ｘ線検査項目コード
    Dim vntNyubouItemCd3        As Variant         '乳房超音波検査項目コード
    Dim vntNyubouJudClassCd1    As Variant         '乳房触診判定分類コード
    Dim vntNyubouJudClassCd2    As Variant         '乳房Ｘ線判定分類コード
    Dim vntNyubouJudClassCd3    As Variant         '乳房超音波判定分類コード
'#### 2004.01.14 add end 乳房判定分類指定時用
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRsvNo = Empty
    vntJudClassCd = Empty
    vntWeight = Empty
    vntJudCd = Empty
    vntJudCmtStc = Empty
    vntJudCmtCd = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2002.6.4 Add 3Lines by T.Takagi(FSIT) 判定分類指定
    If Trim(strJudClassCd) <> "" Then
        objOraParam.Add "JUDCLASSCD", CLng(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2002.6.4 Add End
    
    '検索条件を満たす受診情報から判定分類および基準値判定を検索する
    '・同一受診情報における同一判定分類、判定、及び判定コメントを持つ場合は重複を許さずに取得
    '・かつ重み、判定の軽い順に取得
    '・基準値判定の結果がNULL値の場合は最も軽い判定をデフォルト値として取得させる
    '### 聖路加ではNULLはNULLのままとする　2004.01.03
'    strStmt = "SELECT DISTINCT                                                  " & vbLf & _
'              "       CONSULT.RSVNO,                                            " & vbLf & _
'              "       ITEM_JUD.JUDCLASSCD,                                      " & vbLf & _
'              "       NVL(JUD.WEIGHT,        " & lngLightestWeight & ") WEIGHT, " & vbLf & _
'              "       NVL(STDVALUE_C.JUDCD, '" & strLightestJudCd & "') JUDCD,  " & vbLf & _
'              "       JUDCMTSTC.JUDCMTSTC,                                      " & vbLf & _
'              "       STDVALUE_C.JUDCMTCD                                       "
    strStmt = "SELECT DISTINCT                            " & vbLf & _
              "       CONSULT.RSVNO,                      " & vbLf & _
              "       ITEM_JUD.JUDCLASSCD,                " & vbLf & _
              "       NVL(JUD.WEIGHT,       '0' ) WEIGHT, " & vbLf & _
              "       NVL(STDVALUE_C.JUDCD, '0' ) JUDCD,  " & vbLf & _
              "       JUDCMTSTC.JUDCMTSTC,                " & vbLf & _
              "       STDVALUE_C.JUDCMTCD                 "
              
    '取得に要する表の定義
    strStmt = strStmt & vbLf & _
              "  FROM JUDCMTSTC,  " & vbLf & _
              "       JUD,        " & vbLf & _
              "       STDVALUE_C, " & vbLf & _
              "       JUDCLASS,   " & vbLf & _
              "       COURSE_JUD, " & vbLf & _
              "       ITEM_JUD,   " & vbLf & _
              "       RSL,        " & vbLf & _
              "       CONSULT,    " & vbLf & _
              "       RECEIPT     "
              
    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              " WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
              "   AND RECEIPT.RSVNO   = CONSULT.RSVNO "
              
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
'MsgBox lngStrDayId & " " & lngEndDayId
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "   AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD = :CSCD "
    End If

    '結果未入力の検査項目は判定対象としない
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.RSVNO = RSL.RSVNO " & vbLf & _
              "   AND RSL.RESULT   IS NOT NULL  "
              
    'ある判定分類に属する検査項目を対象とする
    strStmt = strStmt & vbLf & _
              "   AND RSL.ITEMCD = ITEM_JUD.ITEMCD "
              
'##### 2004.01.14  start 乳房判定のときはダミーの判定分類コードも判定を実施するので修正
'## 2002.6.4 Add 5Lines by T.Takagi(FSIT) 判定分類指定
'    '判定分類指定時は条件節に追加
'    If Trim(strJudClassCd) <> "" Then
'        strStmt = strStmt & vbLf & _
'              "   AND ITEM_JUD.JUDCLASSCD = :JUDCLASSCD "
'    End If
'## 2002.6.4 Add End
    '判定分類指定時は条件節に追加
    If Trim(strJudClassCd) <> "" Then
        If Trim(strJudClassCd) = Trim(NYUBOU_JUDCLASSCD) Then
            ' 乳房判定用のコード取得
            SelectNyubouCd vntNyubouItemCd1, vntNyubouItemCd2, vntNyubouItemCd3, _
                                    vntNyubouJudClassCd1, vntNyubouJudClassCd2, vntNyubouJudClassCd3
            objOraParam.Add "NYUJUDCLASSCD1", CLng(vntNyubouJudClassCd1), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "NYUJUDCLASSCD2", CLng(vntNyubouJudClassCd2), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "NYUJUDCLASSCD3", CLng(vntNyubouJudClassCd3), ORAPARM_INPUT, ORATYPE_NUMBER
            strStmt = strStmt & vbLf & _
              "   AND ITEM_JUD.JUDCLASSCD IN ( :JUDCLASSCD, :NYUJUDCLASSCD1, :NYUJUDCLASSCD2, :NYUJUDCLASSCD3 ) "
        Else
            strStmt = strStmt & vbLf & _
              "   AND ITEM_JUD.JUDCLASSCD = :JUDCLASSCD "
        End If
    End If
'##### 2004.01.14  end 乳房判定のときはダミーの判定分類コードも判定を実施するので修正
    
    '検査項目から求まる判定分類が受診コースの判定分類として存在する場合に判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD        = COURSE_JUD.CSCD       " & vbLf & _
              "   AND ITEM_JUD.JUDCLASSCD = COURSE_JUD.JUDCLASSCD "
              
    '総合判定用の判定分類はここでは対象としない
    strStmt = strStmt & vbLf & _
              "   AND ITEM_JUD.JUDCLASSCD = JUDCLASS.JUDCLASSCD " & vbLf & _
              "   AND JUDCLASS.ALLJUDFLG  = 0                   "

    'コメント表示のみの分類コードは対象外 2003.11.25
    ''' 乳房判定でコメント表示のみだが自動判定対象というパターンにしたいのでこの条件は除外 2004.01.02
    '自動判定対象外のものも通常判定ではないものも対象としない 2003.12.12
'    strStmt = strStmt & vbLf & _
'              "   AND JUDCLASS.COMMENTONLY IS NULL              " & vbLf & _
'              "   AND JUDCLASS.NOTAUTOFLG  IS NULL              " & vbLf & _
'              "   AND JUDCLASS.NOTNORMALFLG IS NULL             "
    strStmt = strStmt & vbLf & _
              "   AND JUDCLASS.NOTAUTOFLG  IS NULL              " & vbLf & _
              "   AND JUDCLASS.NOTNORMALFLG IS NULL             "

    '再判定でない場合、すでに判定が存在する判定分類は対象としない
    If Not blnReJudge Then
        strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT CURJUDRSL.RSVNO                             " & vbLf & _
              "                      FROM JUDRSL CURJUDRSL                            " & vbLf & _
              "                     WHERE CURJUDRSL.RSVNO       = CONSULT.RSVNO       " & vbLf & _
              "                       AND CURJUDRSL.JUDCLASSCD  = ITEM_JUD.JUDCLASSCD " & vbLf & _
              "                       AND CURJUDRSL.JUDCD      IS NOT NULL )          "
    End If

    '基準値判定情報をもつ検査項目のみを判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND EXISTS ( SELECT ITEMCD                                    " & vbLf & _
              "                  FROM STDVALUE                                  " & vbLf & _
              "                 WHERE ITEMCD   = RSL.ITEMCD                     " & vbLf & _
              "                   AND SUFFIX   = RSL.SUFFIX                     " & vbLf & _
              "                   AND STRDATE <= CONSULT.CSLDATE                " & vbLf & _
              "                   AND ENDDATE >= CONSULT.CSLDATE                " & vbLf & _
              "                   AND ( CSCD IS NULL OR CSCD = CONSULT.CSCD ) ) "
              
'## 2002.6.4 Add 50Lines by T.Takagi(FSIT) 未入力チェック
    '現レコードの判定分類に属する検査項目のうち未入力項目が存在するかをチェック
    If blnEntryCheck Then
        
        '本ブロックで指定判定分類に属する検査項目の検査結果レコードを取得
        strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT ENTRYCHECK_RSL.RSVNO                                        " & vbLf & _
              "                      FROM ITEM_P,                                                     " & vbLf & _
              "                           ITEM_JUD ENTRYCHECK_ITEM_JUD,                               " & vbLf & _
              "                           RSL      ENTRYCHECK_RSL                                     " & vbLf & _
              "                     WHERE ENTRYCHECK_RSL.RSVNO           = CONSULT.RSVNO              " & vbLf & _
              "                       AND ENTRYCHECK_RSL.ITEMCD          = ENTRYCHECK_ITEM_JUD.ITEMCD " & vbLf & _
              "                       AND ENTRYCHECK_ITEM_JUD.JUDCLASSCD = ITEM_JUD.JUDCLASSCD        " & vbLf & _
              "                       AND ENTRYCHECK_RSL.ITEMCD          = ITEM_P.ITEMCD              "

        '「分画項目が１つでも入力されていれば検査完了」の場合、同一依頼項目で入力済みの検査結果が１つも存在しなければ未入力とみなす
        strStmt = strStmt & vbLf & _
              "                       AND ( ( ITEM_P.ENTRYOK = 0                                              " & vbLf & _
              "                               AND                                                             " & vbLf & _
              "                               NOT EXISTS ( SELECT CHECK_RSL.RSVNO                             " & vbLf & _
              "                                              FROM RSLCMT RSLCMT1,                             " & vbLf & _
              "                                                   RSLCMT RSLCMT2,                             " & vbLf & _
              "                                                   RSL    CHECK_RSL                            " & vbLf & _
              "                                             WHERE CHECK_RSL.RSVNO     = ENTRYCHECK_RSL.RSVNO  " & vbLf & _
              "                                               AND CHECK_RSL.ITEMCD    = ENTRYCHECK_RSL.ITEMCD " & vbLf & _
              "                                               AND CHECK_RSL.RSLCMTCD1 = RSLCMT1.RSLCMTCD(+)   " & vbLf & _
              "                                               AND CHECK_RSL.RSLCMTCD2 = RSLCMT2.RSLCMTCD(+)   " & vbLf & _
              "                                               AND ( CHECK_RSL.RESULT IS NOT NULL OR           " & vbLf & _
              "                                                     RSLCMT1.ENTRYOK = 1          OR           " & vbLf & _
              "                                                     RSLCMT2.ENTRYOK = 1        ) ) )          "

        '「全ての分画項目が入力されれば検査完了」の場合、同一依頼項目で未入力の検査結果が１つでも存在すれば未入力とみなす
        strStmt = strStmt & vbLf & _
              "                             OR                                                            " & vbLf & _
              "                             ( ITEM_P.ENTRYOK = 1                                          " & vbLf & _
              "                               AND                                                         " & vbLf & _
              "                               EXISTS ( SELECT CHECK_RSL.RSVNO                             " & vbLf & _
              "                                          FROM RSLCMT RSLCMT1,                             " & vbLf & _
              "                                               RSLCMT RSLCMT2,                             " & vbLf & _
              "                                               RSL    CHECK_RSL                            " & vbLf & _
              "                                         WHERE CHECK_RSL.RSVNO     = ENTRYCHECK_RSL.RSVNO  " & vbLf & _
              "                                           AND CHECK_RSL.ITEMCD    = ENTRYCHECK_RSL.ITEMCD " & vbLf & _
              "                                           AND CHECK_RSL.RSLCMTCD1 = RSLCMT1.RSLCMTCD(+)   " & vbLf & _
              "                                           AND CHECK_RSL.RSLCMTCD2 = RSLCMT2.RSLCMTCD(+)   " & vbLf & _
              "                                           AND CHECK_RSL.RESULT IS NULL                    " & vbLf & _
              "                                           AND NVL(RSLCMT1.ENTRYOK, 0) = 0                 " & vbLf & _
              "                                           AND NVL(RSLCMT2.ENTRYOK, 0) = 0 ) )             " & vbLf & _
              "                           )                                                               " & vbLf & _
              "                  )                                                                        "
              
    End If
'## 2002.6.4 Add End
    
    'ここまでの条件を満たす検査項目の基準値判定情報から判定コードと重み、及び判定コメントコードを取得する
    strStmt = strStmt & vbLf & _
              "   AND RSL.STDVALUECD   = STDVALUE_C.STDVALUECD(+) " & vbLf & _
              "   AND STDVALUE_C.JUDCD = JUD.JUDCD(+)             "

    '判定コメントコードをもとに対象判定分類の判定コメントを取得する
    strStmt = strStmt & vbLf & _
              "   AND STDVALUE_C.JUDCMTCD = JUDCMTSTC.JUDCMTCD(+) "
'#### 2011/01/20 MOD STA TCS)Y.T ####
''''#### 2010.06.01 SL-UI-Y0101-101 ADD START ####
'''    strStmt = strStmt & vbLf & _
'''              "   ORDER BY WEIGHT "
''''#### 2010.06.01 SL-UI-Y0101-101 ADD END   ####
    strStmt = strStmt & vbLf & _
              "   ORDER BY RSVNO, JUDCLASSCD, WEIGHT "
'#### 2011/01/20 MOD END TCS)Y.T ####

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objWeight = objFields("WEIGHT")
        Set objJudCd = objFields("JUDCD")
        Set objJudCmtStc = objFields("JUDCMTSTC")
        Set objJudCmtCd = objFields("JUDCMTCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrWeight(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrJudCmtStc(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrWeight(lngCount) = objWeight.Value
            vntArrJudCd(lngCount) = objJudCd.Value
            vntArrJudCmtStc(lngCount) = objJudCmtStc.Value & ""
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntRsvNo = vntArrRsvNo
        vntJudClassCd = vntArrJudClassCd
        vntWeight = vntArrWeight
        vntJudCd = vntArrJudCd
        vntJudCmtStc = vntArrJudCmtStc
        vntJudCmtCd = vntArrJudCmtCd
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectJudRslAutomaticallyDayId = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectJudRslAutomaticallyDayId"
    
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

'## 2003.04.01 Add Function By T.Takagi@FSIT 判定入力状態取得用の関数追加
'
' 機能　　 : 指定予約番号の判定入力状態を取得する
'
' 引数　　 : (In)     lngRsvNo             予約番号
' 　　　　   (Out)    vntEntriedJudgement  判定入力状態
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function SelectJudgementStatus(ByVal lngRsvNo As Long, ByRef vntEntriedJudgement As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objEntriedJudgement As OraField         '判定入力状態

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntEntriedJudgement = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の判定入力状態を取得する
    strStmt = "SELECT CheckResultPackage.CheckExistsNoJudgement(:RSVNO) ENTRIEDJUDGEMENT FROM DUAL"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objEntriedJudgement = objFields("ENTRIEDJUDGEMENT")

        '戻り値の設定
        vntEntriedJudgement = objEntriedJudgement.Value & ""

        SelectJudgementStatus = True
        
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
    WriteErrorLog "Judgement.SelectJudgementStatus"
    
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
'## 2007.04.02 Add Function By 張 手動判定入力状態取得用の関数追加
'
' 機能　　 : 指定予約番号の判定入力状態を取得する
'
' 引数　　 : (In)     lngRsvNo             予約番号
' 　　　　   (Out)    vntEntriedJudgement  判定入力状態
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function SelectJudgementStatusAuto(ByVal lngRsvNo As Long, ByRef vntEntriedJudgement As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objEntriedJudgement As OraField         '判定入力状態

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntEntriedJudgement = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の判定入力状態を取得する
    'strStmt = "SELECT CheckResultPackage.CheckExistsNoJudgementManual(:RSVNO) ENTRIEDJUDGEMENT FROM DUAL"
    strStmt = "SELECT CheckResultPackage.CheckExistsNoJudgementAuto(:RSVNO) ENTRIEDJUDGEMENT FROM DUAL"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objEntriedJudgement = objFields("ENTRIEDJUDGEMENT")

        '戻り値の設定
        vntEntriedJudgement = objEntriedJudgement.Value & ""

        SelectJudgementStatusAuto = True
        
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
    WriteErrorLog "Judgement.SelectJudgementStatusAuto"
    
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



'## 2007.04.02 Add Function By 張 手動判定入力状態取得用の関数追加
'
' 機能　　 : 指定予約番号の判定入力状態を取得する
'
' 引数　　 : (In)     lngRsvNo             予約番号
' 　　　　   (Out)    vntEntriedJudgement  判定入力状態
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function SelectJudgementStatusManual(ByVal lngRsvNo As Long, ByRef vntEntriedJudgement As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objEntriedJudgement As OraField         '判定入力状態

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntEntriedJudgement = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の判定入力状態を取得する
    strStmt = "SELECT CheckResultPackage.CheckExistsNoJudgementManual(:RSVNO) ENTRIEDJUDGEMENT FROM DUAL"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objEntriedJudgement = objFields("ENTRIEDJUDGEMENT")

        '戻り値の設定
        vntEntriedJudgement = objEntriedJudgement.Value & ""

        SelectJudgementStatusManual = True
        
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
    WriteErrorLog "Judgement.SelectJudgementStatusManual"
    
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




'## 2003.01.02 Add 乳房判定用のコードを取得する
'
' 機能　　 : 乳房判定用のコードを取得する
'
' 引数　　 : (Out)    vntItemcd1           検査項目コード＋サフィックス（触診）
' 　　　　   (Out)    vntItemcd2           検査項目コード＋サフィックス（Ｘ線）
' 　　　　   (Out)    vntItemcd3           検査項目コード＋サフィックス（超音波）
' 　　　　   (Out)    vntJudClassCd1       判定分類コード（触診）
' 　　　　   (Out)    vntJudClassCd2       判定分類コード（Ｘ線）
' 　　　　   (Out)    vntJudClassCd3       判定分類コード（超音波）
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function SelectNyubouCd(ByRef vntItemcd1 As Variant, _
                               ByRef vntItemcd2 As Variant, _
                               ByRef vntItemcd3 As Variant, _
                               ByRef vntJudClassCd1 As Variant, _
                               ByRef vntJudClassCd2 As Variant, _
                               ByRef vntJudClassCd3 As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntItemcd1 = Empty
    vntItemcd2 = Empty
    vntItemcd3 = Empty
    vntJudClassCd1 = Empty
    vntJudClassCd2 = Empty
    vntJudClassCd3 = Empty


    '指定予約番号の判定入力状態を取得する
    strStmt = "SELECT FREEFIELD1 ITEMCD1,     FREEFIELD2 ITEMCD2,     " & vbLf & _
              "       FREEFIELD3 ITEMCD3,                             " & vbLf & _
              "       FREEFIELD4 JUDCLASSCD1, FREEFIELD5 JUDCLASSCD2, " & vbLf & _
              "       FREEFIELD6 JUDCLASSCD3                          " & vbLf & _
              "  FROM FREE                                            " & vbLf & _
              " WHERE FREECD = 'NYUBOU'                               "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        '戻り値の設定
        vntItemcd1 = objFields("ITEMCD1").Value & ""
        vntItemcd2 = objFields("ITEMCD2").Value & ""
        vntItemcd3 = objFields("ITEMCD3").Value & ""
        vntJudClassCd1 = objFields("JUDCLASSCD1").Value & ""
        vntJudClassCd2 = objFields("JUDCLASSCD2").Value & ""
        vntJudClassCd3 = objFields("JUDCLASSCD3").Value & ""

        SelectNyubouCd = True
        
    End If

    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectNyubouCd"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 乳房判定結果を取得する（当日ＩＤ指定）
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
' 　　　　   (Out)    vntRsvNo           予約番号
' 　　　　   (Out)    vntJudClassCd      判定分類コード
' 　　　　   (Out)    vntJudCd           判定コード
' 　　　　   (Out)    vntJudCmtCd        判定コメントコード
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectNyubouJudRsl( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal blnReJudge As Boolean, _
    ByVal blnEntryCheck As Boolean, _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    ByRef vntJudCd As Variant, _
    ByRef vntJudCmtCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objJudCd            As OraField         '判定コード
    
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrJudClassCd()  As Variant          '判定分類コード
    Dim vntArrJudCd()       As Variant          '判定コード
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    Dim vntGetJudCd         As Variant          '判定コード
    Dim vntGetJudCmtCd      As Variant          '判定コメントコード
    
    Dim vntCslRsvNo()       As Variant          '予約番号
    Dim vntCslJudCd()       As Variant          '判定コード
    
    Dim lngCount            As Long             'レコード数
    Dim lngCount2           As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRsvNo = Empty
    vntJudClassCd = Empty
    vntJudCd = Empty
    vntJudCmtCd = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "JUDCLASSCD", NYUBOU_JUDCLASSCD, ORAPARM_INPUT, ORATYPE_NUMBER
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす予約番号を検索する
    strStmt = "SELECT CONSULT.RSVNO," & vbLf & _
              "       JUDRSL.JUDCD  " & vbLf & _
              "  FROM CONSULT,      " & vbLf & _
              "       COURSE_JUD,   " & vbLf & _
              "       JUDRSL,       " & vbLf & _
              "       RECEIPT       "
              
    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              " WHERE RECEIPT.CSLDATE       = :CSLDATE      " & vbLf & _
              "   AND RECEIPT.RSVNO         = CONSULT.RSVNO " & vbLf & _
              "   AND JUDRSL.RSVNO          = CONSULT.RSVNO " & vbLf & _
              "   AND JUDRSL.JUDCLASSCD     = :JUDCLASSCD   "
              
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "   AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD = :CSCD "
    End If

    '乳房判定分類が受診コースの判定分類として存在する場合に判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD          = COURSE_JUD.CSCD    " & vbLf & _
              "   AND COURSE_JUD.JUDCLASSCD = :JUDCLASSCD        "

    '再判定でない場合、すでに判定コメントが存在する判定分類は対象としない
    ' ###　通常判定ですでに入っているかもしれないのでこの判定は無し
'    If Not blnReJudge Then
'        strStmt = strStmt & vbLf & _
'              "   AND NOT EXISTS ( SELECT CURJUDRSL.RSVNO                             " & vbLf & _
'              "                      FROM JUDRSL CURJUDRSL                            " & vbLf & _
'              "                     WHERE CURJUDRSL.RSVNO       = CONSULT.RSVNO       " & vbLf & _
'              "                       AND CURJUDRSL.JUDCD IS NOT NULL                 " & vbLf & _
'              "                       AND CURJUDRSL.JUDCLASSCD  = :JUDCLASSCD)        "
'    End If

                            

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objJudCd = objFields("JUDCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntCslRsvNo(lngCount)
            ReDim Preserve vntCslJudCd(lngCount)
            vntCslRsvNo(lngCount) = objRsvNo.Value
            vntCslJudCd(lngCount) = objJudCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
     End If
     
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
     
'MsgBox "乳房判定件数　" & lngCount
    '該当する予約番号がない場合は終了
    If lngCount <= 0 Then
    
        '戻り値の設定
        SelectNyubouJudRsl = 0
        
        'トランザクションをコミット
        mobjContext.SetComplete
    
        Exit Function
    End If
     
    lngCount = 0
    '各配列値の更新処理
    For i = 0 To UBound(vntCslRsvNo)
    
'MsgBox "乳房　予約番号 " & vntCslRsvNo(i)

        lngCount2 = SelectNyubouJudCd(vntCslRsvNo(i), vntGetJudCd, vntGetJudCmtCd)
        '検索レコードが存在する場合
        If lngCount2 > 0 And vntGetJudCd <> "" Then
    
'MsgBox "乳房　判定 " & vntGetJudCd
'MsgBox "乳房　前の判定 " & vntCslJudCd(i)
            '再判定ではなく既に判定が入っている場合は上書きしない
            If Not blnReJudge And vntCslJudCd(i) <> "" Then
            Else
    
'MsgBox "乳房　判定 " & vntGetJudCd
'MsgBox "乳房　判定コメント " & vntGetJudCmtCd
                '配列形式で格納する
                ReDim Preserve vntArrRsvNo(lngCount)
                ReDim Preserve vntArrJudClassCd(lngCount)
                ReDim Preserve vntArrJudCd(lngCount)
                ReDim Preserve vntArrJudCmtCd(lngCount)
                vntArrRsvNo(lngCount) = vntCslRsvNo(i)
                vntArrJudClassCd(lngCount) = NYUBOU_JUDCLASSCD
                vntArrJudCd(lngCount) = vntGetJudCd
                vntArrJudCmtCd(lngCount) = vntGetJudCmtCd
                lngCount = lngCount + 1
            End If
    
        End If
        
    Next i
     
     
     
    '戻り値の設定
    vntRsvNo = vntArrRsvNo
    vntJudClassCd = vntArrJudClassCd
    vntJudCd = vntArrJudCd
    vntJudCmtCd = vntArrJudCmtCd
    
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectNyubouJudRsl = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectNyubouJudRsl"
    
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
' 機能　　 : 指定予約番号の乳房判定結果を取得する
'
' 引数　　 : (In)     lngRsvNo           予約番号
' 　　　　   (Out)    vntJudCd           判定コード
' 　　　　   (Out)    vntJudCmtCd        判定コメントコード
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectNyubouJudCd( _
    ByVal lngRsvNo As Variant, _
    ByRef vntJudCd As Variant, _
    ByRef vntJudCmtCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objJudCd            As OraField         '判定コード
    Dim objJudCmtCd         As OraField         '判定コメントコード
    
    
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntJudCd = Empty
    vntJudCmtCd = Empty
    lngCount = 0
    
'MsgBox "SelectNyubouJudCd " & lngRsvNo
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    

'#### 2007/09/10 張 触診と乳房X線を受けた場合、重い判定を反映することに変更 Start ####
'    'グループ１：触診のみ、グループ２：Ｘ線、グループ３：超音波　それ以外は通常の乳房判定
'    strStmt = "SELECT NYUBOUJUDVIEW.JUDCD, NYUBOUJUDVIEW.JUDCMTCD                                                 " & vbLf & _
'              "  FROM (SELECT CASE                                                                                " & vbLf & _
'              "               WHEN NYUJUD1.ITEMCOUNT = 1 AND NYUJUD2.ITEMCOUNT = 0 AND NYUJUD3.ITEMCOUNT = 0 THEN " & vbLf & _
'              "                    1                                                                                 " & vbLf & _
'              "               WHEN NYUJUD2.ITEMCOUNT = 1 AND NYUJUD3.ITEMCOUNT = 0 THEN                           " & vbLf & _
'              "                    2                                                                              " & vbLf & _
'              "               WHEN NYUJUD3.ITEMCOUNT = 1 AND NYUJUD2.ITEMCOUNT = 0 THEN                           " & vbLf & _
'              "                    3                                                                                 " & vbLf & _
'              "               ELSE                                                                                " & vbLf & _
'              "                    0                                                                              " & vbLf & _
'              "               END  GRPNO                                                                          "

    'グループ１：乳房触診のみ、グループ２：乳房Ｘ線、グループ３：乳房超音波、グループ４：乳房触診＋乳房Ｘ線　それ以外は通常の乳房判定
    '2007/09/25 乳房触診＋乳房超音波を両方受けた場合、乳房自動判定未実施（総合判定医が判定）
    strStmt = "SELECT NYUBOUJUDVIEW.JUDCD, NYUBOUJUDVIEW.JUDCMTCD                                                 " & vbLf & _
              "  FROM (SELECT CASE                                                                                " & vbLf & _
              "               WHEN NYUJUD1.ITEMCOUNT = 1 AND NYUJUD2.ITEMCOUNT = 0 AND NYUJUD3.ITEMCOUNT = 0 THEN " & vbLf & _
              "                    1                                                                              " & vbLf & _
              "               WHEN NYUJUD1.ITEMCOUNT = 0 AND NYUJUD2.ITEMCOUNT = 1 AND NYUJUD3.ITEMCOUNT = 0 THEN " & vbLf & _
              "                    2                                                                              " & vbLf & _
              "               WHEN NYUJUD1.ITEMCOUNT = 0 AND NYUJUD2.ITEMCOUNT = 0 AND NYUJUD3.ITEMCOUNT = 1 THEN " & vbLf & _
              "                    3                                                                              " & vbLf & _
              "               WHEN NYUJUD1.ITEMCOUNT = 1 AND NYUJUD2.ITEMCOUNT = 1 AND NYUJUD3.ITEMCOUNT = 0 THEN " & vbLf & _
              "                    4                                                                              " & vbLf & _
              "               WHEN NYUJUD1.ITEMCOUNT = 1 AND NYUJUD2.ITEMCOUNT = 0 AND NYUJUD3.ITEMCOUNT = 1 THEN " & vbLf & _
              "                    5                                                                              " & vbLf & _
              "               ELSE                                                                                " & vbLf & _
              "                    0                                                                              " & vbLf & _
              "               END  GRPNO                                                                          "

'#### 2007/09/10 張 触診と乳房X線を受けた場合、重い判定を反映することに変更 End   ####


    '判定パターンを決める検査項目の有無
'#### 2007/09/26 張 キャンセル（中止）されてない検査項目のみ対象にするため修正 Start ####
'    strStmt = strStmt & vbLf & _
'              "          FROM (SELECT COUNT(*) ITEMCOUNT                                " & vbLf & _
'              "                  FROM RSL, FREE                                         " & vbLf & _
'              "                 WHERE FREE.FREECD = 'NYUBOU'                            " & vbLf & _
'              "                   AND FREE.FREEFIELD1 = RSL.ITEMCD || '-' || RSL.SUFFIX " & vbLf & _
'              "                   AND RSL.RSVNO = :RSVNO) NYUJUD1,                      " & vbLf & _
'              "               (SELECT COUNT(*) ITEMCOUNT                                " & vbLf & _
'              "                  FROM RSL, FREE                                         " & vbLf & _
'              "                 WHERE FREE.FREECD = 'NYUBOU'                            " & vbLf & _
'              "                   AND FREE.FREEFIELD2 = RSL.ITEMCD || '-' || RSL.SUFFIX " & vbLf & _
'              "                   AND RSL.RSVNO = :RSVNO) NYUJUD2,                      " & vbLf & _
'              "               (SELECT COUNT(*) ITEMCOUNT                                " & vbLf & _
'              "                  FROM RSL, FREE                                         " & vbLf & _
'              "                 WHERE FREE.FREECD = 'NYUBOU'                            " & vbLf & _
'              "                   AND FREE.FREEFIELD3 = RSL.ITEMCD || '-' || RSL.SUFFIX " & vbLf & _
'              "                   AND RSL.RSVNO = :RSVNO) NYUJUD3                       " & vbLf & _
'              "     　) GRPVIEW,                                                        "

    strStmt = strStmt & vbLf & _
              "          FROM (SELECT COUNT(*) ITEMCOUNT                                " & vbLf & _
              "                  FROM RSL, FREE                                         " & vbLf & _
              "                 WHERE FREE.FREECD = 'NYUBOU'                            " & vbLf & _
              "                   AND FREE.FREEFIELD1 = RSL.ITEMCD || '-' || RSL.SUFFIX " & vbLf & _
              "                   AND RSL.STOPFLG IS NULL                               " & vbLf & _
              "                   AND RSL.RSVNO = :RSVNO) NYUJUD1,                      " & vbLf & _
              "               (SELECT COUNT(*) ITEMCOUNT                                " & vbLf & _
              "                  FROM RSL, FREE                                         " & vbLf & _
              "                 WHERE FREE.FREECD = 'NYUBOU'                            " & vbLf & _
              "                   AND FREE.FREEFIELD2 = RSL.ITEMCD || '-' || RSL.SUFFIX " & vbLf & _
              "                   AND RSL.STOPFLG IS NULL                               " & vbLf & _
              "                   AND RSL.RSVNO = :RSVNO) NYUJUD2,                      " & vbLf & _
              "               (SELECT COUNT(*) ITEMCOUNT                                " & vbLf & _
              "                  FROM RSL, FREE                                         " & vbLf & _
              "                 WHERE FREE.FREECD = 'NYUBOU'                            " & vbLf & _
              "                   AND FREE.FREEFIELD3 = RSL.ITEMCD || '-' || RSL.SUFFIX " & vbLf & _
              "                   AND RSL.STOPFLG IS NULL                               " & vbLf & _
              "                   AND RSL.RSVNO = :RSVNO) NYUJUD3                       " & vbLf & _
              "     　) GRPVIEW,                                                        "

'#### 2007/09/26 張 キャンセル（中止）されてない検査項目のみ対象にするため修正 End   ####


    'それぞれのパターンの判定結果取得

'#### 2016/02/24 張 乳房触診のみ実施した場合は、乳房判定空欄に仕様変更 Start ##############################
'     strStmt = strStmt & vbLf & _
'             "        (                                                                      " & vbLf & _
'              "        (SELECT 1 GRPNO, JUDCD, JUDCMTCD FROM JUDRSL, FREE                    " & vbLf & _
'              "          WHERE JUDRSL.RSVNO = :RSVNO                                         " & vbLf & _
'              "            AND FREE.FREECD = 'NYUBOU'                                        " & vbLf & _
'              "            AND FREE.FREEFIELD4 = JUDRSL.JUDCLASSCD )                         " & vbLf & _
'              "        UNION                                                                 " & vbLf & _
'              "        (SELECT 2 GRPNO, JUDCD, JUDCMTCD FROM JUDRSL, FREE                    " & vbLf & _
'              "          WHERE JUDRSL.RSVNO = :RSVNO                                         " & vbLf & _
'              "            AND FREE.FREECD = 'NYUBOU'                                        " & vbLf & _
'              "            AND FREE.FREEFIELD5 = JUDRSL.JUDCLASSCD )                         " & vbLf & _
'              "        UNION                                                                 " & vbLf & _
'              "        (SELECT 3 GRPNO, JUDCD, JUDCMTCD FROM JUDRSL, FREE                    " & vbLf & _
'              "          WHERE JUDRSL.RSVNO = :RSVNO                                         " & vbLf & _
'              "            AND FREE.FREECD = 'NYUBOU'                                        " & vbLf & _
'              "            AND FREE.FREEFIELD6 = JUDRSL.JUDCLASSCD )                         "
              
     strStmt = strStmt & vbLf & _
             "        (                                                                      " & vbLf & _
              "        (SELECT 2 GRPNO, JUDCD, JUDCMTCD FROM JUDRSL, FREE                    " & vbLf & _
              "          WHERE JUDRSL.RSVNO = :RSVNO                                         " & vbLf & _
              "            AND FREE.FREECD = 'NYUBOU'                                        " & vbLf & _
              "            AND FREE.FREEFIELD5 = JUDRSL.JUDCLASSCD )                         " & vbLf & _
              "        UNION                                                                 " & vbLf & _
              "        (SELECT 3 GRPNO, JUDCD, JUDCMTCD FROM JUDRSL, FREE                    " & vbLf & _
              "          WHERE JUDRSL.RSVNO = :RSVNO                                         " & vbLf & _
              "            AND FREE.FREECD = 'NYUBOU'                                        " & vbLf & _
              "            AND FREE.FREEFIELD6 = JUDRSL.JUDCLASSCD )                         "
'#### 2016/02/24 張 乳房触診のみ実施した場合は、乳房判定空欄に仕様変更 End   ##############################
              
              
'#### 2007/09/10 張 触診と乳房X線を受けた場合、重い判定を反映する為に追加 Start ####
'#### 乳房触診と乳房Ｘ線、両方判定が終わっている受診者のみ自動判定処理           ####
    strStmt = strStmt & vbLf & _
              "        UNION                                                                     " & vbLf & _
              "        (SELECT 4 GRPNO, JUDCD, JUDCMTCD                                          " & vbLf & _
              "           FROM (                                                                 " & vbLf & _
              "                 SELECT JUD.WEIGHT       AS WEIGHT                                " & vbLf & _
              "                       ,JUDRSL.JUDCD     AS JUDCD                                 " & vbLf & _
              "                       ,JUDRSL.JUDCMTCD  AS JUDCMTCD                              " & vbLf & _
              "                   FROM JUDRSL, FREE, JUD                                         " & vbLf & _
              "                  WHERE JUDRSL.RSVNO = :RSVNO                                     " & vbLf & _
              "                    AND FREE.FREECD = 'NYUBOU'                                    " & vbLf & _
              "                    AND JUDRSL.JUDCLASSCD IN (FREE.FREEFIELD4, FREE.FREEFIELD5)   " & vbLf & _
              "                    AND JUDRSL.JUDCD = JUD.JUDCD                                  " & vbLf & _
              "                  ORDER BY JUD.WEIGHT DESC, JUDRSL.JUDCLASSCD DESC                " & vbLf & _
              "                ) JUDVIEW                                                         " & vbLf & _
              "          WHERE ROWNUM < 2                                                        " & vbLf & _
              "            AND (SELECT COUNT(JUDRSL.RSVNO)                                       " & vbLf & _
              "                   FROM JUDRSL, FREE                                              " & vbLf & _
              "                  WHERE JUDRSL.RSVNO = :RSVNO                                     " & vbLf & _
              "                    AND FREE.FREECD = 'NYUBOU'                                    " & vbLf & _
              "                    AND JUDRSL.JUDCLASSCD IN (FREE.FREEFIELD4, FREE.FREEFIELD5)   " & vbLf & _
              "                    AND JUDRSL.JUDCD IS NOT NULL ) = 2                            " & vbLf & _
              "        )                                                                         "
'#### 2007/09/10 張 触診と乳房X線を受けた場合、重い判定を反映する為に追加 End   ####


    '通常の乳房判定をするのでいらない"
'    strStmt = strStmt & vbLf & _
'              "        UNION                                                                 " & vbLf & _
'              "        (SELECT 4 GRPNO, JUDCDVIEW.JUDCD, JUDCDVIEW.JUDCMTCD                  " & vbLf & _
'              "           FROM (SELECT ROWNUM SEQ, JUDRSL.JUDCD, JUDRSL.JUDCMTCD, JUD.WEIGHT " & vbLf & _
'              "                   FROM JUDRSL, FREE, JUD                                     " & vbLf & _
'              "                  WHERE JUDRSL.RSVNO = :RSVNO                                 " & vbLf & _
'              "                    AND FREE.FREECD = 'NYUBOU'                                " & vbLf & _
'              "                    AND (FREE.FREEFIELD4 = JUDRSL.JUDCLASSCD                  " & vbLf & _
'              "                     OR  FREE.FREEFIELD5 = JUDRSL.JUDCLASSCD )                " & vbLf & _
'              "                    AND JUD.JUDCD = JUDRSL.JUDCD                              " & vbLf & _
'              "                  ORDER BY JUD.WEIGHT DESC ) JUDCDVIEW                        " & vbLf & _
'              "         WHERE JUDCDVIEW.SEQ = 1)                                             " & vbLf & _
'              "        ) NYUBOUJUDVIEW                                                       " & vbLf & _
'              "  WHERE GRPVIEW.GRPNO = NYUBOUJUDVIEW.GRPNO                                   "
    
    strStmt = strStmt & vbLf & _
               "        ) NYUBOUJUDVIEW                                                       " & vbLf & _
               "  WHERE GRPVIEW.GRPNO = NYUBOUJUDVIEW.GRPNO                                   "


    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCd = objFields("JUDCD")
        Set objJudCmtCd = objFields("JUDCMTCD")
    
'MsgBox "乳房　判定 " & objJudCd.Value
'MsgBox "乳房　判定コメント " & objJudCmtCd.Value
        vntJudCd = objJudCd.Value
        vntJudCmtCd = objJudCmtCd.Value
        lngCount = lngCount + 1
    
    End If


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectNyubouJudCd = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectNyubouJudCd"
    
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

' ##### 2004.01.14 追加
'
' 機能　　 : 眼科判定結果を取得する（当日ＩＤ指定）
'            裸眼のみ、眼圧、矯正の無い人をＡ判定にする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
' 　　　　   (Out)    vntRsvNo           予約番号
' 　　　　   (Out)    vntJudClassCd      判定分類コード
' 　　　　   (Out)    vntJudCd           判定コード
' 　　　　   (Out)    vntJudCmtCd        判定コメントコード
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectGankaJudRsl( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal blnReJudge As Boolean, _
    ByVal blnEntryCheck As Boolean, _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    ByRef vntJudCd As Variant, _
    ByRef vntJudCmtCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objJudCd            As OraField         '判定コード
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrJudClassCd()  As Variant          '判定分類コード
    Dim vntArrJudCd()       As Variant          '判定コード
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRsvNo = Empty
    vntJudClassCd = Empty
    vntJudCd = Empty
    vntJudCmtCd = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '眼科・眼圧判定分類コード
    objOraParam.Add "JUDCLASSCD", GANKA_JUDCLASSCD, ORAPARM_INPUT, ORATYPE_NUMBER
    '眼圧依頼コード
    objOraParam.Add "ITEMCD_ATSU", ATSU_ITEMCD, ORAPARM_INPUT, ORATYPE_NUMBER
    '裸眼依頼コード
    objOraParam.Add "ITEMCD_RAGAN", RAGAN_ITEMCD, ORAPARM_INPUT, ORATYPE_NUMBER
    '矯正依頼コード
    objOraParam.Add "ITEMCD_KYOU", KYOU_ITEMCD, ORAPARM_INPUT, ORATYPE_NUMBER
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす予約番号を検索する
    strStmt = "SELECT CONSULT.RSVNO," & vbLf & _
              "       JUDRSL.JUDCD  " & vbLf & _
              "  FROM CONSULT,      " & vbLf & _
              "       COURSE_JUD,   " & vbLf & _
              "       JUDRSL,       " & vbLf & _
              "       RECEIPT       "
              
    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              " WHERE RECEIPT.CSLDATE       = :CSLDATE      " & vbLf & _
              "   AND RECEIPT.RSVNO         = CONSULT.RSVNO " & vbLf & _
              "   AND JUDRSL.RSVNO          = CONSULT.RSVNO " & vbLf & _
              "   AND JUDRSL.JUDCLASSCD     = :JUDCLASSCD   "
              
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "   AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD = :CSCD "
    End If

    '眼科判定分類が受診コースの判定分類として存在する場合に判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD          = COURSE_JUD.CSCD    " & vbLf & _
              "   AND COURSE_JUD.JUDCLASSCD = :JUDCLASSCD        "

    '眼圧の依頼無し
    strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT RSL.RSVNO                      " & vbLf & _
              "                      FROM RSL                            " & vbLf & _
              "                     WHERE RSL.RSVNO   = CONSULT.RSVNO    " & vbLf & _
              "                       AND RSL.ITEMCD  = :ITEMCD_ATSU)     "
    '裸眼結果あり
    strStmt = strStmt & vbLf & _
              "   AND     EXISTS ( SELECT RSL.RSVNO                      " & vbLf & _
              "                      FROM RSL                            " & vbLf & _
              "                     WHERE RSL.RSVNO   = CONSULT.RSVNO    " & vbLf & _
              "                       AND RSL.RESULT IS NOT NULL         " & vbLf & _
              "                       AND RSL.STOPFLG IS NULL            " & vbLf & _
              "                       AND RSL.ITEMCD  = :ITEMCD_RAGAN)   "
    '矯正無し
    strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT RSL.RSVNO                      " & vbLf & _
              "                      FROM RSL                            " & vbLf & _
              "                     WHERE RSL.RSVNO   = CONSULT.RSVNO    " & vbLf & _
              "                       AND RSL.RESULT IS NOT NULL         " & vbLf & _
              "                       AND RSL.STOPFLG IS NULL            " & vbLf & _
              "                       AND RSL.ITEMCD  = :ITEMCD_KYOU)    "
              
    '再判定でない場合、すでに判定コメントが存在する判定分類は対象としない
    If Not blnReJudge Then
        strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT CURJUDRSL.RSVNO                             " & vbLf & _
              "                      FROM JUDRSL CURJUDRSL                            " & vbLf & _
              "                     WHERE CURJUDRSL.RSVNO       = CONSULT.RSVNO       " & vbLf & _
              "                       AND CURJUDRSL.JUDCD IS NOT NULL                 " & vbLf & _
              "                       AND CURJUDRSL.JUDCLASSCD  = :JUDCLASSCD)        "
    End If

                            

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objJudCd = objFields("JUDCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrJudClassCd(lngCount) = GANKA_JUDCLASSCD
            vntArrJudCd(lngCount) = "A"
            vntArrJudCmtCd(lngCount) = ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
     End If
     
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
     
     
    '戻り値の設定
    vntRsvNo = vntArrRsvNo
    vntJudClassCd = vntArrJudClassCd
    vntJudCd = vntArrJudCd
    vntJudCmtCd = vntArrJudCmtCd
    
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectGankaJudRsl = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectGankaJudRsl"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###
    
    'エラー発生時はトランザクションをアボートに設定+
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

' ##### 2007.11.19 追加 張
'
' 機能　　 : 骨密度判定結果を取得する（当日ＩＤ指定）
'            Ｔスコアの基準値によって判定結果が「B2」になった場合喫煙結果を見て再判定（現在喫煙の場合、「D1」に変更）
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
' 　　　　   (Out)    vntRsvNo           予約番号
' 　　　　   (Out)    vntJudClassCd      判定分類コード
' 　　　　   (Out)    vntJudCd           判定コード
' 　　　　   (Out)    vntJudCmtCd        判定コメントコード
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectKotsuJudRsl( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal blnReJudge As Boolean, _
    ByVal blnEntryCheck As Boolean, _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    ByRef vntJudCd As Variant, _
    ByRef vntJudCmtCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objJudCd            As OraField         '判定コード
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrJudClassCd()  As Variant          '判定分類コード
    Dim vntArrJudCd()       As Variant          '判定コード
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRsvNo = Empty
    vntJudClassCd = Empty
    vntJudCd = Empty
    vntJudCmtCd = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '骨密度判定分類コード
    objOraParam.Add "JUDCLASSCD", KOTSU_JUDCLASSCD, ORAPARM_INPUT, ORATYPE_NUMBER
    'Ｔスコア検査項目コード
    objOraParam.Add "ITEMCD_TSCORE", TSCORE_ITEMCD, ORAPARM_INPUT, ORATYPE_NUMBER
    'Ｔスコアサフィックス
    objOraParam.Add "SUFFIX_TSCORE", TSCORE_SUFFIX, ORAPARM_INPUT, ORATYPE_NUMBER
    '喫煙検査項目コード
    objOraParam.Add "ITEMCD_SMOKE", SMOKE_ITEMCD, ORAPARM_INPUT, ORATYPE_NUMBER
    '喫煙サフィックス
    objOraParam.Add "SUFFIX_SMOKE", SMOKE_SUFFIX, ORAPARM_INPUT, ORATYPE_NUMBER
    
    If lngDayIdFlg = 1 Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    '検索条件を満たす予約番号を検索する
    strStmt = "SELECT CONSULT.RSVNO        AS RSVNO " & vbLf & _
              "      ,STDVALUE_C.JUDCD     AS JUDCD " & vbLf & _
              "  FROM STDVALUE_C                    " & vbLf & _
              "      ,RSL                           " & vbLf & _
              "      ,CONSULT                       " & vbLf & _
              "      ,RECEIPT                       " & vbLf & _
              "      ,COURSE_JUD                    "
              
    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              " WHERE RECEIPT.CSLDATE       = :CSLDATE      " & vbLf & _
              "   AND RECEIPT.RSVNO         = CONSULT.RSVNO "
              
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "   AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD = :CSCD "
    End If

    '骨密度判定分類が受診コースの判定分類として存在する場合に判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD          = COURSE_JUD.CSCD    " & vbLf & _
              "   AND COURSE_JUD.JUDCLASSCD = :JUDCLASSCD        "

    '骨密度(Ｔスコア）判定結果が「B2」の場合、判定対象とする
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.RSVNO        = RSL.RSVNO              " & vbLf & _
              "   AND RSL.RESULT           IS NOT NULL              " & vbLf & _
              "   AND RSL.ITEMCD           = :ITEMCD_TSCORE         " & vbLf & _
              "   AND RSL.SUFFIX           = :SUFFIX_TSCORE         " & vbLf & _
              "   AND RSL.STDVALUECD       = STDVALUE_C.STDVALUECD  " & vbLf & _
              "   AND STDVALUE_C.JUDCD     = 'B2'                   "

    '現在喫煙の受診者のみ対象とする(1：吸っている、2：吸わない、3：過去に吸っていた）
    strStmt = strStmt & vbLf & _
              "   AND EXISTS ( SELECT RSL.RSVNO                         " & vbLf & _
              "                  FROM RSL CURRSL                        " & vbLf & _
              "                 WHERE CURRSL.RSVNO = CONSULT.RSVNO      " & vbLf & _
              "                   AND CURRSL.RESULT = '1'               " & vbLf & _
              "                   AND CURRSL.STOPFLG IS NULL            " & vbLf & _
              "                   AND CURRSL.ITEMCD  = :ITEMCD_SMOKE    " & vbLf & _
              "                   AND CURRSL.SUFFIX  = :SUFFIX_SMOKE)   "
              
    '再判定でない場合、すでに判定コメントが存在する判定分類は対象としない
    If Not blnReJudge Then
        strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT CURJUDRSL.RSVNO                             " & vbLf & _
              "                      FROM JUDRSL CURJUDRSL                            " & vbLf & _
              "                     WHERE CURJUDRSL.RSVNO       = CONSULT.RSVNO       " & vbLf & _
              "                       AND CURJUDRSL.JUDCD IS NOT NULL                 " & vbLf & _
              "                       AND CURJUDRSL.JUDCLASSCD  = :JUDCLASSCD)        "
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objJudCd = objFields("JUDCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrJudClassCd(lngCount) = KOTSU_JUDCLASSCD
            vntArrJudCd(lngCount) = "D1"
            ''#### 総合コメントを確認し適用予定 ####
            vntArrJudCmtCd(lngCount) = KOTSU_CMTCD_D1
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
     End If
     
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
     
    '戻り値の設定
    vntRsvNo = vntArrRsvNo
    vntJudClassCd = vntArrJudClassCd
    vntJudCd = vntArrJudCd
    vntJudCmtCd = vntArrJudCmtCd
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectKotsuJudRsl = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectKotsuJudRsl"
    
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
' 機能　　 : 自動総合判定結果を取得する
'
' 引数　　 : (In)     dtmCslDate     受診日
' 　　　　   (In)     strPerId       個人ID
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntJudClassCd  判定分類コード
' 　　　　   (Out)    vntJudCd       判定コード
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectTotalJudRslAutomatically( _
    ByVal dtmCslDate As Date, _
    ByVal strPerId As String, _
    ByVal strCsCd As String, _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    ByRef vntJudCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objJudClassCd       As OraField         '判定分類コード
    Dim objJudCd            As OraField         '判定コード
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrJudClassCd()  As Variant          '判定分類コード
    Dim vntArrJudCd()       As Variant          '判定コード
    
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRsvNo = Empty
    vntJudClassCd = Empty
    vntJudCd = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    If Trim(strPerId) <> "" Then
        objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '現在の判定分類別判定情報から総合判定結果を取得する
    '(先に連結した重み・判定コードを再度分割する)
    strStmt = "SELECT FINALJUDGE.RSVNO, JUDRSL.JUDCLASSCD, TRIM(SUBSTR(FINALJUDGE.JUDKEY, 3, 2)) JUDCD " & vbLf & _
              "  FROM JUDCLASS, JUDRSL, "

    '重み・判定コードを連結した値が最も大きい(重い)ものを総合判定とする
    strStmt = strStmt & vbLf & _
              "       ( SELECT JUDRSL.RSVNO, MAX(TRIM(TO_CHAR(JUD.WEIGHT, '00'))||JUDRSL.JUDCD) JUDKEY " & vbLf & _
              "           FROM JUD, JUDCLASS, JUDRSL, CONSULT, RECEIPT                                 "
              
    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE     = :CSLDATE      " & vbLf & _
              "            AND RECEIPT.RSVNO       = CONSULT.RSVNO "
              
    '個人ID指定時は条件節に加える
    If Trim(strPerId) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.PERID      = :PERID "
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD        = :CSCD "
    End If

    '対象受診者の現判定結果情報を取得
    strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVNO       = JUDRSL.RSVNO "
              
    '総合判定用の判定分類はここではグルーピングの対象としない
    strStmt = strStmt & vbLf & _
              "            AND JUDRSL.JUDCLASSCD   = JUDCLASS.JUDCLASSCD " & vbLf & _
              "            AND JUDCLASS.ALLJUDFLG  = 0                   "
              
    'コメント表示のみの分類コードも対象としない 2003.11.25
    strStmt = strStmt & vbLf & _
              "            AND JUDCLASS.COMMENTONLY IS NULL                   "
    
    '重みを取得するため判定テーブル情報を結合する(これにより未判定の判定結果はグルーピング対象とならない)
    strStmt = strStmt & vbLf & _
              "            AND JUDRSL.JUDCD        = JUD.JUDCD "
              
    '総合判定用の判定分類をもつ受診情報のみを判定対象とする
    strStmt = strStmt & vbLf & _
              "            AND EXISTS ( SELECT TOTALJUDRSL.RSVNO                            " & vbLf & _
              "                           FROM JUDCLASS, JUDRSL TOTALJUDRSL                 " & vbLf & _
              "                          WHERE TOTALJUDRSL.RSVNO      = JUDRSL.RSVNO        " & vbLf & _
              "                            AND TOTALJUDRSL.JUDCLASSCD = JUDCLASS.JUDCLASSCD " & vbLf & _
              "                            AND JUDCLASS.ALLJUDFLG     = 1 )                 "

    '予約番号単位で集計を行い、総合判定を求める
    strStmt = strStmt & vbLf & _
              "          GROUP BY JUDRSL.RSVNO " & vbLf & _
              "       ) FINALJUDGE             "

    '総合判定用の判定分類に判定結果を格納するため、結合を行う
    strStmt = strStmt & vbLf & _
              " WHERE FINALJUDGE.RSVNO   = JUDRSL.RSVNO        " & vbLf & _
              "   AND JUDRSL.JUDCLASSCD  = JUDCLASS.JUDCLASSCD " & vbLf & _
              "   AND JUDCLASS.ALLJUDFLG = 1                   "
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudCd = objFields("JUDCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrJudCd(lngCount) = objJudCd.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntRsvNo = vntArrRsvNo
        vntJudClassCd = vntArrJudClassCd
        vntJudCd = vntArrJudCd
    
    End If
    
    'バインド変数の削除
'    objOraParam.Remove "CSLDATE"
'    objOraParam.Remove "STRDAYID"
'    objOraParam.Remove "ENDDAYID"
'    objOraParam.Remove "CSCD"
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectTotalJudRslAutomatically = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.SelectTotalJudRslAutomatically"
    
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
' 機能　　 : 判定結果テーブルレコードを更新する
'
' 引数　　 : (In)     vntRsvNo       予約番号
' 　　　　 : (In)     vntJudClassCd  判定分類コード
' 　　　　 : (In)     vntJudCd       判定コード
' 　　　　 : (In)     vntUpdUser     更新者 (配列ではない）           2003.12.24 add
' 　　　　 : (In)     vntJudCmtCd    判定コメントコード 2004.01.02 add
' 　　　　 : (In)     vntUpdFlg      更新フラグ　(配列ではない）　　　 2004.01.03 add
' ## 不要項目削除 2003.12.17
' 　　　　 : (In)     vntDoctorCd    判定医コード
' 　　　　 : (In)     vntFreeJudCmt  フリー判定コメント
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
' ## 不要項目削除 2003.12.17 start
Public Function UpdateJudRsl( _
    ByRef vntRsvNo As Variant, _
    ByRef vntJudClassCd As Variant, _
    Optional ByRef vntJudCd As Variant, _
    Optional ByRef vntUpdUser As Variant, _
    Optional ByRef vntJudCmtCd As Variant, _
    Optional ByRef vntUpdFlg As Variant _
) As Boolean
'Public Function UpdateJudRsl( _
'    ByRef vntRsvNo As Variant, _
'    ByRef vntJudClassCd As Variant, _
'    Optional ByRef vntJudCd As Variant, _
'    Optional ByRef vntDoctorCd As Variant, _
'    Optional ByRef vntFreeJudCmt As Variant _
') As Boolean
' ## 不要項目削除 2003.12.17 end

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objRsvNo        As OraParameter     '予約番号
    Dim objJudClassCd   As OraParameter     '判定分類コード
    Dim objJudCd        As OraParameter     '判定コード
    Dim objJudCmtCd     As OraParameter     '判定コメントコード
' ## 不要項目削除 2003.12.17 start
'    Dim objDoctorCd     As OraParameter     '判定医コード
'    Dim objFreeJudCmt   As OraParameter     'フリー判定コメント
' ## 不要項目削除 2003.12.17 end
    
    Dim blnAdd          As Boolean          'UPDATE文のSET句に何かを追加したか
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    If Not IsMissing(vntUpdUser) Then
        objOraParam.Add "UPDUSER", Trim(vntUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "JUDCMTCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    If Not IsMissing(vntUpdFlg) Then
        objOraParam.Add "UPDFLG", Trim(vntUpdFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
' ## 不要項目削除 2003.12.17 start
'    objOraParam.Add "DOCTORCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "FREEJUDCMT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
' ## 不要項目削除 2003.12.17 end
    
    'パラメータの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objJudClassCd = objOraParam("JUDCLASSCD")
    Set objJudCd = objOraParam("JUDCD")
    Set objJudCmtCd = objOraParam("JUDCMTCD")
' ## 不要項目削除 2003.12.17 start
'    Set objDoctorCd = objOraParam("DOCTORCD")
'    Set objFreeJudCmt = objOraParam("FREEJUDCMT")
' ## 不要項目削除 2003.12.17 end
    
    '文字列バッファサイズの設定(意味不明。しかし本プロパティ設定がなければ異常終了する。)
' ## 不要項目削除 2003.12.17 start
'    objFreeJudCmt.MinimumSize = 500
' ## 不要項目削除 2003.12.17 end
    
    '判定結果テーブルレコードの更新
    strStmt = "UPDATE JUDRSL SET "

    '引数として存在する場合のみSET句に追加
    If Not IsMissing(vntJudCd) Then
        strStmt = strStmt & "JUDCD = :JUDCD"
        blnAdd = True
    End If
    If Not IsMissing(vntUpdUser) Then
        If blnAdd = True Then
            strStmt = strStmt & ", "
        End If
        strStmt = strStmt & "UPDUSER = :UPDUSER"
        blnAdd = True
    End If
    If Not IsMissing(vntJudCmtCd) Then
        If blnAdd = True Then
            strStmt = strStmt & ", "
        End If
        strStmt = strStmt & "JUDCMTCD = :JUDCMTCD"
        blnAdd = True
    End If
    If Not IsMissing(vntUpdFlg) Then
        If blnAdd = True Then
            strStmt = strStmt & ", "
        End If
        strStmt = strStmt & "UPDFLG = :UPDFLG"
        blnAdd = True
    End If

    '引数として存在する場合のみSET句に追加
' ## 不要項目削除 2003.12.17 start
'    If Not IsMissing(vntDoctorCd) Then
'        strStmt = strStmt & IIf(blnAdd, ", ", "") & "DOCTORCD = :DOCTORCD"
'        blnAdd = True
'    End If
' ## 不要項目削除 2003.12.17 end

    '引数として存在する場合のみSET句に追加
' ## 不要項目削除 2003.12.17 start
'    If Not IsMissing(vntFreeJudCmt) Then
'        strStmt = strStmt & IIf(blnAdd, ", ", "") & "FREEJUDCMT = :FREEJUDCMT"
'    End If
' ## 不要項目削除 2003.12.17 end

    '条件節の追加
    strStmt = strStmt & vbLf & " WHERE RSVNO = :RSVNO AND JUDCLASSCD = :JUDCLASSCD "

    '各配列値の更新処理
    For i = 0 To UBound(vntJudClassCd)
   
        '配列値の編集
        objRsvNo.Value = CLng(vntRsvNo(i))
        objJudClassCd.Value = CLng(vntJudClassCd(i))
        
        If Not IsMissing(vntJudCd) Then
            objJudCd.Value = CStr(vntJudCd(i))
        End If
        If Not IsMissing(vntJudCmtCd) Then
            If vntJudCmtCd(i) <> "" Then
                objJudCmtCd.Value = CStr(vntJudCmtCd(i))
            Else
                objJudCmtCd.Value = Null
            End If
        End If
' ## 不要項目削除 2003.12.17 start
'        If Not IsMissing(vntDoctorCd) Then
'            objDoctorCd.Value = CStr(vntDoctorCd(i))
'        End If
' ## 不要項目削除 2003.12.17 end
        
' ## 不要項目削除 2003.12.17 start
'        If Not IsMissing(vntFreeJudCmt) Then
'            objFreeJudCmt.Value = CStr(vntFreeJudCmt(i))
'        End If
' ## 不要項目削除 2003.12.17 end
    
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
    
    '戻り値の設定
    UpdateJudRsl = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateJudRsl = False
    
    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateJudRsl"
    
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
' 機能　　 : 判定結果テーブルレコードを更新する
' 　　　　   （存在すれば更新、なければ挿入）
'
' 引数　　 : (In)     vntRsvNo          予約番号
' 　　　　 : (In)     vntJudClassCd     判定分類コード
' 　　　　 : (In)     vntJudCd          判定コード
' 　　　　 : (In)     vntDoctorCd       判定医コード　　　　＝＝＞不要項目削除(2003.12.03)
' 　　　　 : (In)     vntFreeJudCmt     フリー判定コメント　＝＝＞不要項目削除(2003.12.03)
' 　　　　 : (In)     vntJudCmtCd       判定コメントコード
' 　　　　 : (In)     vntGuidanceCd     指導文章コード　　　＝＝＞不要項目削除(2003.12.03)
' 　　　　 : (In)     vntUpdUser        更新者      2003.12.24 add 配列ではない
' 　　　　 : (In)     vntUpdFlg         更新フラグ  2003.12.26 add 配列ではない
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertJudRslWithUpdate(ByRef vntRsvNo As Variant, _
                                       ByRef vntJudClassCd As Variant, _
                                       ByRef vntJudCd As Variant, _
                                       ByVal vntJudCmtCd As Variant, _
                                       Optional ByRef vntUpdUser As Variant, _
                                       Optional ByRef vntUpdFlg As Variant _
                                      ) As Boolean
'Public Function InsertJudRslWithUpdate(ByRef vntRsvNo As Variant, _
'                                       ByRef vntJudClassCd As Variant, _
'                                       ByRef vntJudCd As Variant, _
'                                       ByRef vntDoctorCd As Variant, _
'                                       ByRef vntFreeJudCmt As Variant, _
'                                       ByVal vntJudCmtCd As Variant, _
'                                       ByVal vntGuidanceCd As Variant _
'                                      ) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objRsvNo        As OraParameter     '予約番号
    Dim objJudClassCd   As OraParameter     '判定分類コード
    Dim objJudCd        As OraParameter     '判定コード
    Dim objJudCmtCd     As OraParameter     '判定コメントコード
    Dim objUpdUser      As OraParameter     '更新者
'## 不要項目削除(2003.12.03) start
'    Dim objDoctorCd     As OraParameter     '判定医コード
'    Dim objFreeJudCmt   As OraParameter     'フリー判定コメント
'    Dim objGuidanceCd   As OraParameter     '指導文章コード
'## 不要項目削除(2003.12.03) end

    Dim i               As Long             'インデックス
    Dim Ret             As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JUDCMTCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 不要項目削除(2003.12.03) start
'    objOraParam.Add "DOCTORCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "FREEJUDCMT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "GUIDANCECD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 不要項目削除(2003.12.03) end
    If Not IsMissing(vntUpdUser) Then
        objOraParam.Add "UPDUSER", Trim(vntUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
'MsgBox "InsertJudRslWithUpdate =>" & vntUpdFlg
    If Not IsMissing(vntUpdFlg) Then
        objOraParam.Add "UPDFLG", Trim(vntUpdFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    'パラメータの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objJudClassCd = objOraParam("JUDCLASSCD")
    Set objJudCd = objOraParam("JUDCD")
    Set objJudCmtCd = objOraParam("JUDCMTCD")
'## 不要項目削除(2003.12.03) start
'    Set objDoctorCd = objOraParam("DOCTORCD")
'    Set objFreeJudCmt = objOraParam("FREEJUDCMT")
'    Set objGuidanceCd = objOraParam("GUIDANCECD")
'## 不要項目削除(2003.12.03) end
    
    '文字列バッファサイズの設定(意味不明。しかし本プロパティ設定がなければ異常終了する。)
'## 不要項目削除(2003.12.03) start
'    objFreeJudCmt.MinimumSize = 500
'## 不要項目削除(2003.12.03) end

    '各配列値の更新処理
    For i = 0 To UBound(vntJudClassCd)

        '配列値の編集
        objRsvNo.Value = CLng(vntRsvNo(i))
        objJudClassCd.Value = CLng(vntJudClassCd(i))
        objJudCd.Value = CStr(vntJudCd(i))
        objJudCmtCd.Value = CStr(vntJudCmtCd(i))
'## 不要項目削除(2003.12.03) start
'        objDoctorCd.Value = CStr(vntDoctorCd(i))
'        objFreeJudCmt.Value = CStr(vntFreeJudCmt(i))
'        objGuidanceCd.Value = CStr(vntGuidanceCd(i))
'## 不要項目削除(2003.12.03) end

        '検索条件を満たす判定結果テーブルのレコードを取得
        strStmt = "SELECT RSVNO FROM JUDRSL WHERE RSVNO = :RSVNO AND JUDCLASSCD = :JUDCLASSCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If objOraDyna.EOF Then
'## 不要項目削除(2003.12.03) start
'            mobjOraDb.ExecuteSQL "INSERT INTO JUDRSL (RSVNO, JUDCLASSCD, JUDCD, DOCTORCD, FREEJUDCMT, JUDCMTCD, GUIDANCECD) VALUES (:RSVNO, :JUDCLASSCD, :JUDCD, :DOCTORCD, :FREEJUDCMT, :JUDCMTCD, :GUIDANCECD)"
'            mobjOraDb.ExecuteSQL "INSERT INTO JUDRSL (RSVNO, JUDCLASSCD, JUDCD, JUDCMTCD) VALUES (:RSVNO, :JUDCLASSCD, :JUDCD, :JUDCMTCD)"
'### 更新者　追加 2003.12.24
            strStmt = "INSERT INTO JUDRSL (RSVNO, JUDCLASSCD, JUDCD, JUDCMTCD"
            If Not IsMissing(vntUpdUser) Then
                strStmt = strStmt & ", UPDUSER"
            End If
            If Not IsMissing(vntUpdFlg) Then
                strStmt = strStmt & ", UPDFLG"
            End If
            strStmt = strStmt & ") VALUES (:RSVNO, :JUDCLASSCD, :JUDCD, :JUDCMTCD"
            If Not IsMissing(vntUpdUser) Then
                strStmt = strStmt & ", :UPDUSER"
            End If
            If Not IsMissing(vntUpdFlg) Then
                strStmt = strStmt & ", :UPDFLG"
            End If
            strStmt = strStmt & ")"
            mobjOraDb.ExecuteSQL strStmt
'## 不要項目削除(2003.12.03) end
        Else
'## 不要項目削除(2003.12.03) start
'            mobjOraDb.ExecuteSQL ("UPDATE JUDRSL SET JUDCD = :JUDCD, DOCTORCD = :DOCTORCD, FREEJUDCMT = :FREEJUDCMT, JUDCMTCD = :JUDCMTCD, GUIDANCECD = :GUIDANCECD WHERE RSVNO = :RSVNO AND JUDCLASSCD = :JUDCLASSCD")
'            mobjOraDb.ExecuteSQL ("UPDATE JUDRSL SET JUDCD = :JUDCD, JUDCMTCD = :JUDCMTCD WHERE RSVNO = :RSVNO AND JUDCLASSCD = :JUDCLASSCD")
'### 更新者　追加 2003.12.24
            strStmt = "UPDATE JUDRSL SET JUDCD = :JUDCD, JUDCMTCD = :JUDCMTCD "
            If Not IsMissing(vntUpdUser) Then
                strStmt = strStmt & ", UPDUSER = :UPDUSER "
            End If
            If Not IsMissing(vntUpdFlg) Then
                strStmt = strStmt & ", UPDFLG  = :UPDFLG "
            End If
            strStmt = strStmt & "WHERE RSVNO = :RSVNO AND JUDCLASSCD = :JUDCLASSCD"
            mobjOraDb.ExecuteSQL strStmt
'## 不要項目削除(2003.12.03) end
        End If
    
    Next i
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertJudRslWithUpdate = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    InsertJudRslWithUpdate = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Judgement.InsertJudRslWithUpdate"
    
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
'### 聖路加対応　追加 2003.12.12
'
' 機能　　 : 生活指導メッセージをセットする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 以下はいらないと思う
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
'
' 戻り値　 : True = 正常終了
' 　　　　 : False = 異常終了
'
' 備考　　 :
'
Public Function UpdateLifeGuideMsg( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objMaxSeq           As OraField         'MAX SEQ
    Dim objJudCmtCd         As OraField         '判定コメントコード
        
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
        
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '認識レベルのITEMCD，SUFFIX
    objOraParam.Add "KNOWITEMCD", Trim(KNOWLEVEL_ITEMCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "KNOWSUFFIX", Trim(KNOWLEVEL_SUFFIX), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '生活指導用のグループコード
    objOraParam.Add "GDEGRPCD", Trim(GDECMT_GRPCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", GDECMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件にあった受診者の前回の認識レベルと今回の失点から判定コメントコードを取得する
    strStmt = "SELECT NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                                " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO              " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ,    " & vbLf & _
              "       JUDCMTVIEW.RSVNO, JUDCMTVIEW.JUDCMTCD                                " & vbLf & _
              "  FROM   (SELECT CMTCDVIEW.RSVNO, DECODE( LEVELVIEW.KNOWLEVEL,              " & vbLf & _
              "                                        1, CMTCDVIEW.JUDCMTCD1,             " & vbLf & _
              "                                        2, CMTCDVIEW.JUDCMTCD2,             " & vbLf & _
              "                                        3, CMTCDVIEW.JUDCMTCD3,             " & vbLf & _
              "                                        4, CMTCDVIEW.JUDCMTCD4,             " & vbLf & _
              "                                        5, CMTCDVIEW.JUDCMTCD5,             " & vbLf & _
              "                                           CMTCDVIEW.JUDCMTCD1 ) JUDCMTCD   " & vbLf & _
              "          FROM "
    '直近の認識レベルの取得（０やｎｕｌｌなら認識レベル１とする）
    strStmt = strStmt & vbLf & _
              "            (SELECT DATEVIEW.PERID,                                                " & vbLf & _
              "                    DECODE( RSL.RESULT, 0, 1, NULL, 1, RSL.RESULT ) KNOWLEVEL      " & vbLf & _
              "               FROM RSL, CONSULT,                                                  "
    ' 個人ＩＤごとの認識レベルのある直近の受診日（５年前まで）
'### 2004.01.21 性能改善（参照するテーブルからRECEIPTを外す）
'    strStmt = strStmt & vbLf & _
'              "                     　 (SELECT PERVIEW.PERID, MAX(PERVIEW.CSLDATE) CSLDATE        " & vbLf & _
'              "                            FROM (SELECT PERIDVIEW.PERID, CONSULT.CSLDATE          " & vbLf & _
'              "                                   FROM CONSULT, RECEIPT, RSL,                     " & vbLf & _
'              "                                         (SELECT CONSULT.PERID                     " & vbLf & _
'              "                                            FROM RECEIPT, CONSULT                  " & vbLf & _
'              "                                           WHERE RECEIPT.CSLDATE = :CSLDATE        " & vbLf & _
'              "                                             AND RECEIPT.CSLDATE = CONSULT.CSLDATE " & vbLf & _
'              "                                             AND RECEIPT.RSVNO   = CONSULT.RSVNO   "
    
'### 2004/06/25 Updated by Ishihara@FSIT 生活指導コメントが１件でもセットされていたら、コメントセット対象としない
'    strStmt = strStmt & vbLf & _
              "                     　 (SELECT PERVIEW.PERID, MAX(PERVIEW.CSLDATE) CSLDATE        " & vbLf & _
              "                            FROM (SELECT PERIDVIEW.PERID, CONSULT.CSLDATE          " & vbLf & _
              "                                   FROM CONSULT, RSL, 　　　　　　　　　                    " & vbLf & _
              "                                         (SELECT CONSULT.PERID                     " & vbLf & _
              "                                            FROM RECEIPT, CONSULT                  " & vbLf & _
              "                                           WHERE RECEIPT.CSLDATE = :CSLDATE        " & vbLf & _
              "                                             AND RECEIPT.CSLDATE = CONSULT.CSLDATE " & vbLf & _
              "                                             AND RECEIPT.RSVNO   = CONSULT.RSVNO   "
    strStmt = strStmt & vbLf & _
              "                     　 (SELECT PERVIEW.PERID, MAX(PERVIEW.CSLDATE) CSLDATE        " & vbLf & _
              "                            FROM (SELECT PERIDVIEW.PERID, CONSULT.CSLDATE          " & vbLf & _
              "                                   FROM CONSULT, RSL, 　　　　　　　　　                    " & vbLf & _
              "                                         (SELECT CONSULT.PERID,                    " & vbLf & _
              "                                                 (SELECT COUNT(*) FROM TOTALJUDCMT WHERE RSVNO = CONSULT.RSVNO AND DISPMODE = 2 AND ROWNUM = 1) CMTCNT " & vbLf & _
              "                                            FROM RECEIPT, CONSULT                  " & vbLf & _
              "                                           WHERE RECEIPT.CSLDATE = :CSLDATE        " & vbLf & _
              "                                             AND RECEIPT.CSLDATE = CONSULT.CSLDATE " & vbLf & _
              "                                             AND RECEIPT.RSVNO   = CONSULT.RSVNO   "
'### 2004/06/25 Updated End
    
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                             AND RECEIPT.DAYID  >= :STRDAYID " & vbLf & _
              "                                             AND RECEIPT.DAYID  <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "                                             AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                             AND CONSULT.CSCD   = :CSCD    "
    End If
'### 2004.01.21 性能改善（参照するテーブルからRECEIPTを外す）
'    strStmt = strStmt & vbLf & _
'              "                                         ) PERIDVIEW                                  " & vbLf & _
'              "                                   WHERE CONSULT.PERID = PERIDVIEW.PERID              " & vbLf & _
'              "                                     AND RECEIPT.CSLDATE < :CSLDATE                   " & vbLf & _
'              "                                    AND RECEIPT.CSLDATE >= ADD_MONTHS(:CSLDATE, -60 ) " & vbLf & _
'              "                                     AND RECEIPT.RSVNO = CONSULT.RSVNO                " & vbLf & _
'              "                                     AND RSL.RSVNO  = CONSULT.RSVNO                   " & vbLf & _
'              "                                     AND RSL.ITEMCD = :KNOWITEMCD                     " & vbLf & _
'              "                                     AND RSL.SUFFIX = :KNOWSUFFIX                     " & vbLf & _
'              "                                    ORDER BY PERIDVIEW.PERID) PERVIEW                 " & vbLf & _
'              "                           GROUP BY PERVIEW.PERID ) DATEVIEW                          " & vbLf & _
'              "                   WHERE CONSULT.CSLDATE = DATEVIEW.CSLDATE                           " & vbLf & _
'              "                     AND CONSULT.PERID   = DATEVIEW.PERID                             " & vbLf & _
'              "                     AND RSL.RSVNO       = CONSULT.RSVNO                              " & vbLf & _
'              "                     AND RSL.ITEMCD      = :KNOWITEMCD                                " & vbLf & _
'              "                     AND RSL.SUFFIX      = :KNOWSUFFIX                                " & vbLf & _
'              "                  ) LEVELVIEW,                                                        "
'### 2004/06/25 Updated by Ishihara@FSIT 生活指導コメントが１件でもセットされていたら、コメントセット対象としない
'    strStmt = strStmt & vbLf & _
              "                                         ) PERIDVIEW                                  " & vbLf & _
              "                                   WHERE CONSULT.PERID = PERIDVIEW.PERID              " & vbLf & _
              "                                     AND CONSULT.CSLDATE < :CSLDATE                   " & vbLf & _
              "                                     AND CONSULT.CSLDATE >= ADD_MONTHS(:CSLDATE, -60 ) " & vbLf & _
              "                                     AND EXISTS(SELECT RECEIPT.RSVNO FROM RECEIPT WHERE RECEIPT.RSVNO = CONSULT.RSVNO) " & vbLf & _
              "                                     AND RSL.RSVNO  = CONSULT.RSVNO                   " & vbLf & _
              "                                     AND RSL.ITEMCD = :KNOWITEMCD                     " & vbLf & _
              "                                     AND RSL.SUFFIX = :KNOWSUFFIX                     " & vbLf & _
              "                                    ORDER BY PERIDVIEW.PERID) PERVIEW                 " & vbLf & _
              "                           GROUP BY PERVIEW.PERID ) DATEVIEW                          " & vbLf & _
              "                   WHERE CONSULT.CSLDATE = DATEVIEW.CSLDATE                           " & vbLf & _
              "                     AND CONSULT.PERID   = DATEVIEW.PERID                             " & vbLf & _
              "                     AND RSL.RSVNO       = CONSULT.RSVNO                              " & vbLf & _
              "                     AND RSL.ITEMCD      = :KNOWITEMCD                                " & vbLf & _
              "                     AND RSL.SUFFIX      = :KNOWSUFFIX                                " & vbLf & _
              "                  ) LEVELVIEW,                                                        "
    strStmt = strStmt & vbLf & _
              "                                         ) PERIDVIEW                                  " & vbLf & _
              "                                   WHERE CONSULT.PERID = PERIDVIEW.PERID              " & vbLf & _
              "                                     AND PERIDVIEW.CMTCNT = 0                         " & vbLf & _
              "                                     AND CONSULT.CSLDATE < :CSLDATE                   " & vbLf & _
              "                                     AND CONSULT.CSLDATE >= ADD_MONTHS(:CSLDATE, -60 ) " & vbLf & _
              "                                     AND EXISTS(SELECT RECEIPT.RSVNO FROM RECEIPT WHERE RECEIPT.RSVNO = CONSULT.RSVNO) " & vbLf & _
              "                                     AND RSL.RSVNO  = CONSULT.RSVNO                   " & vbLf & _
              "                                     AND RSL.ITEMCD = :KNOWITEMCD                     " & vbLf & _
              "                                     AND RSL.SUFFIX = :KNOWSUFFIX                     " & vbLf & _
              "                                    ORDER BY PERIDVIEW.PERID) PERVIEW                 " & vbLf & _
              "                           GROUP BY PERVIEW.PERID ) DATEVIEW                          " & vbLf & _
              "                   WHERE CONSULT.CSLDATE = DATEVIEW.CSLDATE                           " & vbLf & _
              "                     AND CONSULT.PERID   = DATEVIEW.PERID                             " & vbLf & _
              "                     AND RSL.RSVNO       = CONSULT.RSVNO                              " & vbLf & _
              "                     AND RSL.ITEMCD      = :KNOWITEMCD                                " & vbLf & _
              "                     AND RSL.SUFFIX      = :KNOWSUFFIX                                " & vbLf & _
              "                  ) LEVELVIEW,                                                        "
'### 2004/06/25 Updated End
    
    ' 検査結果に対応するコメントコード
    strStmt = strStmt & vbLf & _
              "             (SELECT RSLVIEW.PERID,              " & vbLf & _
              "                     RSLVIEW.RSVNO,              " & vbLf & _
              "                     FREEFIELD1 JUDCMTCD1,       " & vbLf & _
              "                         FREEFIELD2 JUDCMTCD2,   " & vbLf & _
              "                         FREEFIELD3 JUDCMTCD3,   " & vbLf & _
              "                         FREEFIELD4 JUDCMTCD4,   " & vbLf & _
              "                         FREEFIELD5 JUDCMTCD5    " & vbLf & _
              "                   FROM FREE,                    "
    ' 生活指導メッセージ取得用の検査結果
    strStmt = strStmt & vbLf & _
              "                     (SELECT RSL.ITEMCD, RSL.SUFFIX, RSL.RESULT,         " & vbLf & _
              "                                RSL.RSVNO, RSVNOVIEW.PERID               " & vbLf & _
              "                           FROM RSL, GRP_I,                              "
    ' 指定条件の予約番号とPERID群取得
'### 2004/06/25 Updated by Ishihara@FSIT 生活指導コメントが１件でもセットされていたら、コメントセット対象としない
'    strStmt = strStmt & vbLf & _
              "                               (SELECT CONSULT.PERID, CONSULT.RSVNO      " & vbLf & _
              "                                  FROM RECEIPT, CONSULT                  " & vbLf & _
              "                                 WHERE RECEIPT.CSLDATE = :CSLDATE        " & vbLf & _
              "                                   AND RECEIPT.CSLDATE = CONSULT.CSLDATE " & vbLf & _
              "                                   AND RECEIPT.RSVNO   = CONSULT.RSVNO   "
    strStmt = strStmt & vbLf & _
              "                               (SELECT CONSULT.PERID, CONSULT.RSVNO,     " & vbLf & _
              "                                       (SELECT COUNT(*) FROM TOTALJUDCMT WHERE RSVNO = CONSULT.RSVNO AND DISPMODE = 2 AND ROWNUM = 1) CMTCNT " & vbLf & _
              "                                  FROM RECEIPT, CONSULT                  " & vbLf & _
              "                                 WHERE RECEIPT.CSLDATE = :CSLDATE        " & vbLf & _
              "                                   AND RECEIPT.CSLDATE = CONSULT.CSLDATE " & vbLf & _
              "                                   AND RECEIPT.RSVNO   = CONSULT.RSVNO   "
'### 2004/06/25 Updated End
    
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                   AND RECEIPT.DAYID  >= :STRDAYID " & vbLf & _
              "                                   AND RECEIPT.DAYID  <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "   　　　　　　　　　　　　　　　　　　　　　　　AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                   AND CONSULT.CSCD   = :CSCD    "
    End If
    
'### 2004/06/25 Updated by Ishihara@FSIT 生活指導コメントが１件でもセットされていたら、コメントセット対象としない
'    strStmt = strStmt & vbLf & _
              "                               ) RSVNOVIEW                                                        " & vbLf & _
              "                          WHERE RSL.RSVNO = RSVNOVIEW.RSVNO                                       " & vbLf & _
              "                            AND GRP_I.GRPCD = :GDEGRPCD                                           " & vbLf & _
              "                            AND GRP_I.ITEMCD = RSL.ITEMCD                                         " & vbLf & _
              "                            AND GRP_I.SUFFIX = RSL.SUFFIX ) RSLVIEW                               " & vbLf & _
              "                  WHERE FREE.FREECD = 'GDE' || RSLVIEW.ITEMCD || RSLVIEW.SUFFIX || RSLVIEW.RESULT " & vbLf & _
              "                ) CMTCDVIEW                                                                       " & vbLf & _
              "         WHERE CMTCDVIEW.PERID = LEVELVIEW.PERID(+)                                               " & vbLf & _
              "        )JUDCMTVIEW                                                                               "
    strStmt = strStmt & vbLf & _
              "                               ) RSVNOVIEW                                                        " & vbLf & _
              "                          WHERE RSL.RSVNO = RSVNOVIEW.RSVNO                                       " & vbLf & _
              "                            AND RSVNOVIEW.CMTCNT = 0                                              " & vbLf & _
              "                            AND GRP_I.GRPCD = :GDEGRPCD                                           " & vbLf & _
              "                            AND GRP_I.ITEMCD = RSL.ITEMCD                                         " & vbLf & _
              "                            AND GRP_I.SUFFIX = RSL.SUFFIX ) RSLVIEW                               " & vbLf & _
              "                  WHERE FREE.FREECD = 'GDE' || RSLVIEW.ITEMCD || RSLVIEW.SUFFIX || RSLVIEW.RESULT " & vbLf & _
              "                ) CMTCDVIEW                                                                       " & vbLf & _
              "         WHERE CMTCDVIEW.PERID = LEVELVIEW.PERID(+)                                               " & vbLf & _
              "        )JUDCMTVIEW                                                                               "
'### 2004/06/25 Updated End
    
    ' 総合コメントテーブルに登録されていないもの
    strStmt = strStmt & vbLf & _
              " WHERE NOT EXISTS (SELECT * FROM TOTALJUDCMT                          " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO    = JUDCMTVIEW.RSVNO     " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE            " & vbLf & _
              "                      AND TOTALJUDCMT.JUDCMTCD = JUDCMTVIEW.JUDCMTCD) "

    strStmt = strStmt & vbLf & _
              " ORDER BY JUDCMTVIEW.RSVNO                                            "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objMaxSeq = objFields("MAXSEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrDispMode(lngCount)
            ReDim Preserve vntArrMaxSeq(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrDispMode(lngCount) = GDECMT_DISPMODE
            vntArrMaxSeq(lngCount) = objMaxSeq.Value
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop

        UpdateLifeGuideMsg = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    UpdateLifeGuideMsg = True
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateLifeGuideMsg"
    
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


'### 2008.05.07 張　追加 Start ###
'
' 機能　　 : 喫煙関連メッセージ（総合コメント）をセットする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
' 以下はいらないと思う
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
'
' 戻り値　 : True = 正常終了
' 　　　　 : False = 異常終了
'
' 備考　　 :
'
Public Function UpdateSmokeGuideMsg( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objMaxSeq           As OraField         'MAX SEQ
    Dim objJudCmtCd         As OraField         '判定コメントコード
        
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
        
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '喫煙コメント導出用のグループコード
    objOraParam.Add "SMKGRPCD", Trim(SMKCMT_GRPCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件にあった受診者の前回の認識レベルと今回の失点から判定コメントコードを取得する
    strStmt = "SELECT NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                                " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO              " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ,    " & vbLf & _
              "       JUDCMTVIEW.RSVNO, JUDCMTVIEW.JUDCMTCD                                " & vbLf & _
              "  FROM (SELECT CMTCDVIEW.RSVNO    AS RSVNO                                  " & vbLf & _
              "              ,CMTCDVIEW.JUDCMTCD AS JUDCMTCD                               " & vbLf & _
              "          FROM "
    
    ' 検査結果に対応するコメントコード
    strStmt = strStmt & vbLf & _
              "             (SELECT RSLVIEW.PERID,              " & vbLf & _
              "                     RSLVIEW.RSVNO,              " & vbLf & _
              "                     FREEFIELD1 JUDCMTCD         " & vbLf & _
              "                FROM FREE,                       "
    ' 生活指導メッセージ取得用の検査結果
    strStmt = strStmt & vbLf & _
              "                     (SELECT RSL.ITEMCD, RSL.SUFFIX, RSL.RESULT,         " & vbLf & _
              "                                RSL.RSVNO, RSVNOVIEW.PERID               " & vbLf & _
              "                           FROM RSL, GRP_I,                              "
    ' 指定条件の予約番号とPERID群取得
    strStmt = strStmt & vbLf & _
              "                               (SELECT CONSULT.PERID, CONSULT.RSVNO      " & vbLf & _
              "                                  FROM RECEIPT, CONSULT                  " & vbLf & _
              "                                 WHERE RECEIPT.CSLDATE = :CSLDATE        " & vbLf & _
              "                                   AND RECEIPT.CSLDATE = CONSULT.CSLDATE " & vbLf & _
              "                                   AND RECEIPT.RSVNO   = CONSULT.RSVNO   "
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                   AND RECEIPT.DAYID  >= :STRDAYID " & vbLf & _
              "                                   AND RECEIPT.DAYID  <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "   　　　　　　　　　　　　　　　　　　　　　　　AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                   AND CONSULT.CSCD   = :CSCD    "
    End If
    
'### 喫煙コメントがセットされていたら、コメントセット対象としない
    strStmt = strStmt & vbLf & _
              "                               ) RSVNOVIEW                                                        " & vbLf & _
              "                          WHERE RSL.RSVNO = RSVNOVIEW.RSVNO                                       " & vbLf & _
              "                            AND GRP_I.GRPCD = :SMKGRPCD                                           " & vbLf & _
              "                            AND GRP_I.ITEMCD = RSL.ITEMCD                                         " & vbLf & _
              "                            AND GRP_I.SUFFIX = RSL.SUFFIX ) RSLVIEW                               " & vbLf & _
              "                  WHERE FREE.FREECD = 'SMK' || RSLVIEW.ITEMCD || RSLVIEW.SUFFIX || RSLVIEW.RESULT " & vbLf & _
              "                ) CMTCDVIEW                                                                       " & vbLf & _
              "        )JUDCMTVIEW                                                                               "
    
    ' 総合コメントテーブルに登録されていないもの
    strStmt = strStmt & vbLf & _
              " WHERE NOT EXISTS (SELECT * FROM TOTALJUDCMT                          " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO    = JUDCMTVIEW.RSVNO     " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE            " & vbLf & _
              "                      AND TOTALJUDCMT.JUDCMTCD = JUDCMTVIEW.JUDCMTCD) "

    strStmt = strStmt & vbLf & _
              " ORDER BY JUDCMTVIEW.RSVNO                                            "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objMaxSeq = objFields("MAXSEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrDispMode(lngCount)
            ReDim Preserve vntArrMaxSeq(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
            vntArrMaxSeq(lngCount) = objMaxSeq.Value
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop

        UpdateSmokeGuideMsg = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    UpdateSmokeGuideMsg = True
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateSmokeGuideMsg"
    
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
'### 2008.05.07 張　追加 End   ###


'
'### 聖路加対応　追加 2003.12.12
'
' 機能　　 : 現病歴コメントをセットする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 Start
' 　　　　   (In)     strDisComment      現病歴コメント区分
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 End
' 以下はいらないと思う
' 　　　　   (In)     blnReJudge         再判定フラグ
' 　　　　   (In)     blnEntryCheck      未入力チェックフラグ
'
' 戻り値　 : True = 正常終了
' 　　　　 : False = 異常終了
'
' 備考　　 :
'
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 Start
'Public Function UpdateNowDiseaseCmt( _
'    ByVal dtmCslDate As Date, _
'    ByVal lngDayIdFlg As Long, _
'    ByVal lngStrDayId As Variant, _
'    ByVal lngEndDayId As Variant, _
'    ByRef vntArrDayId As Variant, _
'    ByVal strCsCd As String _
') As Boolean
Public Function UpdateNowDiseaseCmt( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal strDisComment As String _
) As Boolean
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objMaxSeq           As OraField         'MAX SEQ
    Dim objJudCmtCd         As OraField         '判定コメントコード
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために追加 Start
    '総合コメント分類（婦人科関連なのか）
    If Trim(strDisComment) <> "TOT" Then
        objOraParam.Add "DISCOMMENT", Trim(strDisComment), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために追加 End
    
    '現病歴コメント用のグループコード
    objOraParam.Add "GRPCD", Trim(DISEASECMT_GRPCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    
    
    ' 現病歴に対するコメント取得
    '### 2004.01.19 Mod By Fujii 同じコメントが重複して登録されないように修正
'    strStmt = "SELECT NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                      " & vbLf & _
'              "             WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO           " & vbLf & _
'              "               AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ, " & vbLf & _
'              "       JUDCMTVIEW.RSVNO, JUDCMTVIEW.JUDCMTCD                      " & vbLf & _
'              "  FROM (SELECT RSLVIEW.RSVNO, FREE.FREEFIELD1 JUDCMTCD            " & vbLf & _
'              "          FROM FREE,                                              "
    strStmt = "SELECT NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                      " & vbLf & _
              "             WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO           " & vbLf & _
              "               AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ, " & vbLf & _
              "       JUDCMTVIEW.RSVNO, JUDCMTVIEW.JUDCMTCD                      " & vbLf & _
              "  FROM (SELECT DISTINCT RSLVIEW.RSVNO, FREE.FREEFIELD1 JUDCMTCD   " & vbLf & _
              "          FROM FREE,                                              "

    ' 現病歴取得
    strStmt = strStmt & vbLf & _
              "            (SELECT RSL.RSVNO, RSL.RESULT,             " & vbLf & _
              "                    RSL.ITEMCD, RSL.SUFFIX             " & vbLf & _
              "                  FROM RSL, CONSULT, RECEIPT, GRP_I    " & vbLf & _
              "                 WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
              "                   AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
              "                   AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
              "                   AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
              "                   AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
              "                   AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
              "                   AND RSL.SUFFIX      = '01'          "

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                   AND RECEIPT.DAYID  <= :ENDDAYID     "
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                   AND CONSULT.CSCD   = :CSCD    "
    End If

    strStmt = strStmt & vbLf & _
              "                ) RSLVIEW,"
    ' 治療状態取得 (治療終了は除く）
    strStmt = strStmt & vbLf & _
              "            (SELECT RSL.RSVNO, RSL.RESULT,             " & vbLf & _
              "                    RSL.ITEMCD, RSL.SUFFIX             " & vbLf & _
              "                  FROM RSL, CONSULT, RECEIPT, GRP_I    " & vbLf & _
              "                 WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
              "                   AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
              "                   AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
              "                   AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
              "                   AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
              "                   AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
              "                   AND RSL.SUFFIX      = '03'          " & vbLf & _
              "                   AND RSL.RESULT NOT IN ( 7,8,9,10 )  "
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                   AND RECEIPT.DAYID  <= :ENDDAYID     "
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                   AND CONSULT.CSCD   = :CSCD    "
    End If

'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 Start
'    strStmt = strStmt & vbLf & _
'              "                ) STATVIEW                               " & vbLf & _
'              "         WHERE FREE.FREECD = 'DISEASE' || RSLVIEW.RESULT " & vbLf & _
'              "           AND RSLVIEW.RSVNO  = STATVIEW.RSVNO           " & vbLf & _
'              "           AND RSLVIEW.ITEMCD = STATVIEW.ITEMCD          " & vbLf & _
'              "        ) JUDCMTVIEW                                     "
    
    If Trim(strDisComment) = "TOT" Then
        strStmt = strStmt & vbLf & _
                  "                ) STATVIEW                               " & vbLf & _
                  "         WHERE FREE.FREECD = 'DISEASE' || RSLVIEW.RESULT " & vbLf & _
                  "           AND RSLVIEW.RSVNO  = STATVIEW.RSVNO           " & vbLf & _
                  "           AND RSLVIEW.ITEMCD = STATVIEW.ITEMCD          " & vbLf & _
                  "        ) JUDCMTVIEW                                     "
    Else
        strStmt = strStmt & vbLf & _
                  "                ) STATVIEW                               " & vbLf & _
                  "         WHERE FREE.FREECD = 'DISEASE' || RSLVIEW.RESULT " & vbLf & _
                  "           AND FREE.FREECLASSCD = :DISCOMMENT            " & vbLf & _
                  "           AND RSLVIEW.RSVNO  = STATVIEW.RSVNO           " & vbLf & _
                  "           AND RSLVIEW.ITEMCD = STATVIEW.ITEMCD          " & vbLf & _
                  "        ) JUDCMTVIEW                                     "
    End If
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 End


    ' 総合コメントテーブルに登録されていないもの
    strStmt = strStmt & vbLf & _
             " WHERE NOT EXISTS (SELECT * FROM TOTALJUDCMT                           " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO    = JUDCMTVIEW.RSVNO     " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE            " & vbLf & _
              "                      AND TOTALJUDCMT.JUDCMTCD = JUDCMTVIEW.JUDCMTCD) " & vbLf & _
              " ORDER BY JUDCMTVIEW.RSVNO                                            "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objMaxSeq = objFields("MAXSEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrDispMode(lngCount)
            ReDim Preserve vntArrMaxSeq(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
            vntArrMaxSeq(lngCount) = objMaxSeq.Value
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop

        UpdateNowDiseaseCmt = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    UpdateNowDiseaseCmt = True
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateNowDiseaseCmt"
    
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

'### 2006.06.12 張 メタボリックシンドローム総合コメント登録処理追加（2008年3月31日受診者まで） Start

Public Function UpdateMetaCmt( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objMaxSeq           As OraField         'MAX SEQ
    Dim objJudCmtCd         As OraField         '判定コメントコード
    Dim objJudCmtCd2        As OraField         '判定コメントコード２
    
    Dim objDayId            As OraField         '当日ID
    Dim objPerId            As OraField         '個人ID
    Dim objGender           As OraField         '性別
    Dim objGlycemiaRsl      As OraField         '空腹時血糖
    Dim objHDLRsl           As OraField         'HDL
    Dim objTGRsl            As OraField         'TG
    Dim objCBPRsl           As OraField         '収縮期血圧
    Dim objEBPRsl           As OraField         '拡張期血圧
    Dim objWaistRsl         As OraField         '腹囲
    Dim objKetsuatsu        As OraField         '高血圧
    Dim objTounyou          As OraField         '糖尿病
    Dim objShisitsu         As OraField         '高脂血症
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    Dim vntArrJudCmtCd2()   As Variant          '判定コメントコード２
    
    Dim metaCmtAdd          As Boolean          'メタボリックシンドローム関連総合コメント追加可否
    
    Dim lngCheck1           As Long             '脂質関連チェック
    Dim lngCheck2           As Long             '血圧関連チェック
    Dim lngCheck3           As Long             '血糖関連チェック
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    
    'メタボリックシンドローム総合コメント用のグループコード
    objOraParam.Add "GRPCD", Trim(METACMT_GRPCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    'メタボリックシンドローム用総合コメントコード
    objOraParam.Add "METACMTCD", METACMT_CMTCD, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "METACMTCD2", METACMT_CMTCD2, ORAPARM_INPUT, ORATYPE_NUMBER
    'メタボリックシンドローム関連検査項目コード
    objOraParam.Add "ITEMCD_GLYCEMIA", GLYCEMIA_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_GLYCEMIA", GLYCEMIA_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_HDL", HDL_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_HDL", HDL_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_TG", TG_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_TG", TG_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_CBP", CBP_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_CBP", CBP_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_EBP", EBP_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_EBP", EBP_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_WAIST", WAIST_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_WAIST", WAIST_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    ' メタボリックシンドロームチェック用結果データ取得（検査結果、病歴情報）
    strStmt = "SELECT JUDCMTVIEW.RSVNO     AS RSVNO                                 " & vbLf & _
              "       ,NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                        " & vbLf & _
              "              WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO             " & vbLf & _
              "                AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ    " & vbLf & _
              "       ,JUDCMTVIEW.JUDCMTCD      AS JUDCMTCD                         " & vbLf & _
              "       ,JUDCMTVIEW.JUDCMTCD2     AS JUDCMTCD2                        " & vbLf & _
              "       ,JUDCMTVIEW.DAYID         AS DAYID                            " & vbLf & _
              "       ,JUDCMTVIEW.PERID         AS PERID                            " & vbLf & _
              "       ,JUDCMTVIEW.GENDER        AS GENDER                           " & vbLf & _
              "       ,JUDCMTVIEW.GLYCEMIARSL   AS GLYCEMIARSL                      " & vbLf & _
              "       ,JUDCMTVIEW.HDLRSL        AS HDLRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.TGRSL         AS TGRSL                            " & vbLf & _
              "       ,JUDCMTVIEW.CBPRSL        AS CBPRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.EBPRSL        AS EBPRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.WAISTRSL      AS WAISTRSL                         " & vbLf & _
              "       ,JUDCMTVIEW.KETSUATSU     AS KETSUATSU                        " & vbLf & _
              "       ,JUDCMTVIEW.TOUNYOU       AS TOUNYOU                          " & vbLf & _
              "       ,JUDCMTVIEW.SHISITSU      AS SHISITSU                         " & vbLf

    strStmt = strStmt & vbLf & _
              "  FROM (                                             " & vbLf & _
              "         SELECT RECEIPT.RSVNO        AS RSVNO        " & vbLf & _
              "               ,RECEIPT.DAYID        AS DAYID        " & vbLf & _
              "               ,CONSULT.PERID        AS PERID        " & vbLf & _
              "               ,CONSULT.CSCD         AS CSCD         " & vbLf & _
              "               ,PERSON.LASTNAME      AS LASTNAME     " & vbLf & _
              "               ,PERSON.FIRSTNAME     AS FIRSTNAME    " & vbLf & _
              "               ,PERSON.GENDER        AS GENDER       " & vbLf & _
              "               ,:METACMTCD           AS JUDCMTCD     " & vbLf & _
              "               ,:METACMTCD2          AS JUDCMTCD2,   " & vbLf

    ' 糖代謝判定用の検査結果を取得する
    ' 空腹時血糖値
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_GLYCEMIA AND RSL.SUFFIX = :SUFFIX_GLYCEMIA) = 0 THEN   " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_GLYCEMIA     " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_GLYCEMIA)    " & vbLf & _
              "                       END RESULT                                        " & vbLf & _
              "                  FROM DUAL) GLYCEMIARSL,                                " & vbLf

    ' 脂質代謝判定用の検査結果を取得する
    ' HDL
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_HDL AND RSL.SUFFIX = :SUFFIX_HDL) = 0 THEN             " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_HDL          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_HDL)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) HDLRSL,                                     " & vbLf

    ' TG
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_TG AND RSL.SUFFIX = :SUFFIX_TG) = 0 THEN               " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_TG           " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_TG)          " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) TGRSL,                                      " & vbLf
    
    ' 収縮期血圧結果
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_CBP AND RSL.SUFFIX = :SUFFIX_CBP) = 0 THEN             " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_CBP          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_CBP)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) CBPRSL,                                     " & vbLf
    
    ' 拡張期血圧結果
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_EBP AND RSL.SUFFIX = :SUFFIX_EBP) = 0 THEN             " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_EBP          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_EBP)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) EBPRSL,                                     " & vbLf
    
    ' 腹囲結果、病歴情報
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_WAIST AND RSL.SUFFIX = :SUFFIX_WAIST) = 0 THEN         " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_WAIST        " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_WAIST)       " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) WAISTRSL                                    " & vbLf & _
              "                ,DECODE(LASTVIEW.KETSUATSU,NULL, 0, LASTVIEW.KETSUATSU)      AS KETSUATSU    " & vbLf & _
              "                ,DECODE(LASTVIEW.TOUNYOU,NULL, 0, LASTVIEW.TOUNYOU)          AS TOUNYOU      " & vbLf & _
              "                ,DECODE(LASTVIEW.SHISITSU,NULL, 0, LASTVIEW.SHISITSU)        AS SHISITSU     " & vbLf
    
    strStmt = strStmt & vbLf & _
              "            FROM RECEIPT, CONSULT, PERSON                                " & vbLf & _
              "                ,(                                                       " & vbLf & _
              "                  SELECT FINAL.RSVNO              AS RSVNO               " & vbLf & _
              "                        ,SUM(FINAL.KETSUATSU)     AS KETSUATSU           " & vbLf & _
              "                        ,SUM(FINAL.TOUNYOU)       AS TOUNYOU             " & vbLf & _
              "                        ,SUM(FINAL.SHISITSU)      AS SHISITSU            " & vbLf & _
              "                    FROM (                                               " & vbLf & _
              "                          SELECT RSLVIEW.RSVNO  AS RSVNO                 " & vbLf & _
              "                                ,RSLVIEW.RESULT AS DISEASEK              " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'19',COUNT(RSLVIEW.RSVNO),0) AS KETSUATSU     " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'48',COUNT(RSLVIEW.RSVNO),0) AS TOUNYOU       " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'47',COUNT(RSLVIEW.RSVNO),0) AS SHISITSU      " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 Start ###
'    strStmt = strStmt & vbLf & _
'              "                            FROM (SELECT RSL.RSVNO, RSL.RESULT,          " & vbLf & _
'              "                                         RSL.ITEMCD , RSL.SUFFIX         " & vbLf & _
'              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE    " & vbLf & _
'              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
'              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
'              "                                     AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
'              "                                     AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
'              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = '01'          " & vbLf & _
'              "                                     AND FREE.FREECD = 'METADIS' || RSL.RESULT  " & vbLf
    strStmt = strStmt & vbLf & _
              "                            FROM (SELECT RSL.RSVNO, FREE.FREEFIELD3 RESULT,  " & vbLf & _
              "                                         RSL.ITEMCD , RSL.SUFFIX             " & vbLf & _
              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE  " & vbLf & _
              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE          " & vbLf & _
              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO     " & vbLf & _
              "                                     AND GRP_I.GRPCD     = :GRPCD            " & vbLf & _
              "                                     AND RSL.RSVNO       = CONSULT.RSVNO     " & vbLf & _
              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD      " & vbLf & _
              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX      " & vbLf & _
              "                                     AND RSL.SUFFIX      = '01'              " & vbLf & _
              "                                     AND FREE.FREECD = 'METADIS' || RSL.RESULT  " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 End   ###
    
    
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                     AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                                     AND RECEIPT.DAYID  <= :ENDDAYID     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                     AND CONSULT.CSCD   = :CSCD          " & vbLf
    End If
    strStmt = strStmt & vbLf & _
              "                                 ) RSLVIEW,                              " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 Start ###
'    strStmt = strStmt & vbLf & _
'              "                                 (SELECT RSL.RSVNO, RSL.RESULT,          " & vbLf & _
'              "                                         RSL.ITEMCD , RSL.SUFFIX         " & vbLf & _
'              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I    " & vbLf & _
'              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
'              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
'              "                                     AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
'              "                                     AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
'              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = '03'          " & vbLf & _
'              "                                     AND RSL.RESULT IN ( '5' )           " & vbLf
    strStmt = strStmt & vbLf & _
              "                                 (SELECT RSL.RSVNO, RSL.RESULT,              " & vbLf & _
              "                                         RSL.ITEMCD , RSL.SUFFIX             " & vbLf & _
              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE  " & vbLf & _
              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE          " & vbLf & _
              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO     " & vbLf & _
              "                                     AND GRP_I.GRPCD     = :GRPCD            " & vbLf & _
              "                                     AND RSL.RSVNO       = CONSULT.RSVNO     " & vbLf & _
              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD      " & vbLf & _
              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX      " & vbLf & _
              "                                     AND RSL.SUFFIX      = '03'              " & vbLf & _
              "                                     AND FREE.FREECD = 'METASTS' || RSL.RESULT  " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 End   ###


    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                     AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                                     AND RECEIPT.DAYID  <= :ENDDAYID     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                     AND CONSULT.CSCD   = :CSCD          " & vbLf
    End If
    strStmt = strStmt & vbLf & _
              "                                 ) STATVIEW                                      " & vbLf & _
              "                            WHERE RSLVIEW.RSVNO  = STATVIEW.RSVNO                " & vbLf & _
              "                              AND RSLVIEW.ITEMCD = STATVIEW.ITEMCD               " & vbLf & _
              "                            GROUP BY RSLVIEW.RSVNO, RSLVIEW.RESULT               " & vbLf & _
              "                          ) FINAL                                                " & vbLf & _
              "                     GROUP BY FINAL.RSVNO                                        " & vbLf & _
              "                 ) LASTVIEW                                                      " & vbLf


    strStmt = strStmt & vbLf & _
              "           WHERE RECEIPT.CSLDATE = :CSLDATE                                      " & vbLf & _
              "             AND RECEIPT.RSVNO   = CONSULT.RSVNO                                 " & vbLf & _
              "             AND RECEIPT.CSLDATE = CONSULT.CSLDATE                               " & vbLf & _
              "             AND CONSULT.PERID   = PERSON.PERID                                  " & vbLf & _
              "             AND CONSULT.RSVNO   = LASTVIEW.RSVNO(+)                             " & vbLf

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "             AND RECEIPT.DAYID  >= :STRDAYID                                     " & vbLf & _
              "             AND RECEIPT.DAYID  <= :ENDDAYID                                     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "             AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "             AND CONSULT.CSCD   = :CSCD                                          " & vbLf
    End If

    
    strStmt = strStmt & vbLf & _
              "       ) JUDCMTVIEW                                                              " & vbLf & _
              " WHERE NOT EXISTS (SELECT * FROM TOTALJUDCMT                                     " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO                   " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE                       " & vbLf & _
              "                      AND TOTALJUDCMT.JUDCMTCD IN (JUDCMTVIEW.JUDCMTCD, JUDCMTVIEW.JUDCMTCD2))   " & vbLf & _
              " ORDER BY JUDCMTVIEW.RSVNO                                                       " & vbLf
    
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objMaxSeq = objFields("MAXSEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
        Set objJudCmtCd2 = objFields("JUDCMTCD2")
    
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objGender = objFields("GENDER")
        Set objGlycemiaRsl = objFields("GLYCEMIARSL")
        Set objHDLRsl = objFields("HDLRSL")
        Set objTGRsl = objFields("TGRSL")
        Set objCBPRsl = objFields("CBPRSL")
        Set objEBPRsl = objFields("EBPRSL")
        Set objWaistRsl = objFields("WAISTRSL")
        Set objKetsuatsu = objFields("KETSUATSU")
        Set objTounyou = objFields("TOUNYOU")
        Set objShisitsu = objFields("SHISITSU")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            lngCheck1 = 0
            lngCheck2 = 0
            lngCheck3 = 0
            
            '腹囲が基準値以上の受診者のみ対象にする（男性：85以上、女性：90以上）
            If (objGender.Value = 1 And objWaistRsl.Value >= 85) Or (objGender.Value = 2 And objWaistRsl.Value >= 90) Then
                
                '「TG：150以上」と「HDL：40未満」いずれか
                '或は「高脂血症」で薬剤治療中
                If objTGRsl.Value >= 150 Or objHDLRsl.Value < 40 Or objShisitsu.Value > 0 Then
                    lngCheck1 = 1
                End If
                
                '「収縮期血圧：130以上」と「拡張期血圧：80以上」いずれか
                '或は「高血圧」で薬剤治療中
                If objCBPRsl.Value >= 130 Or objEBPRsl.Value >= 85 Or objKetsuatsu.Value > 0 Then
                    lngCheck2 = 1
                End If
                
                '「FPG：110以上」
                '或は「糖尿症」で薬剤治療中
                If objGlycemiaRsl.Value >= 110 Or objTounyou.Value > 0 Then
                    lngCheck3 = 1
                End If
            
                'メタボリックシンドローム対象者のみ指定総合コメント登録
                '「脂質」、「血圧」、「血糖」中二つ以上異常の場合対象にする
                If (lngCheck1 + lngCheck2 + lngCheck3) >= 2 Then
                    ReDim Preserve vntArrRsvNo(lngCount)
                    ReDim Preserve vntArrDispMode(lngCount)
                    ReDim Preserve vntArrMaxSeq(lngCount)
                    ReDim Preserve vntArrJudCmtCd(lngCount)
                    ReDim Preserve vntArrJudCmtCd2(lngCount)
                    vntArrRsvNo(lngCount) = objRsvNo.Value
                    vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
                    vntArrMaxSeq(lngCount) = objMaxSeq.Value
                    vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
                    vntArrJudCmtCd2(lngCount) = objJudCmtCd2.Value & ""
                    
                    lngCount = lngCount + 1
                End If
            
            End If
            
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
        If lngCount > 0 Then
            '#### InsertTotalJudCmt()中では「vntArrMaxSeq」引数は使わない ####
            UpdateMetaCmt = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
            UpdateMetaCmt = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd2)
        End If
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    UpdateMetaCmt = True
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateMetaCmt"
    
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
'### 2006.06.12 張 メタボリックシンドローム総合コメント登録処理追加（2008年3月31日受診者まで） End

'### 2008.03.04 張 メタボリックシンドローム総合コメント登録処理新規追加（特定健診に合わせて、2008年4月1日以降受診者） Start
Public Function UpdateMetaCmt2( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objMaxSeq           As OraField         'MAX SEQ
    
    Dim objDayId            As OraField         '当日ID
    Dim objPerId            As OraField         '個人ID
    Dim objGender           As OraField         '性別
    Dim objGlycemiaRsl      As OraField         '空腹時血糖
    Dim objHbA1cRsl         As OraField         'HbA1c
    Dim objHDLRsl           As OraField         'HDL
    Dim objTGRsl            As OraField         'TG
    Dim objCBPRsl           As OraField         '収縮期血圧
    Dim objEBPRsl           As OraField         '拡張期血圧
    Dim objWaistRsl         As OraField         '腹囲
    Dim objKetsuatsu        As OraField         '高血圧
    Dim objTounyou          As OraField         '糖尿病
    Dim objShisitsu         As OraField         '高脂血症
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    Dim vntArrJudCmtCd2()   As Variant          '判定コメントコード２
    
    Dim metaCmtAdd          As Boolean          'メタボリックシンドローム関連総合コメント追加可否
    
    Dim lngCheck1           As Long             '脂質関連チェック
    Dim lngCheck2           As Long             '血圧関連チェック
    Dim lngCheck3           As Long             '血糖関連チェック
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    
    'メタボリックシンドローム総合コメント用のグループコード
    objOraParam.Add "GRPCD", Trim(METACMT_GRPCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    'メタボリックシンドローム用総合コメントコード
    objOraParam.Add "METACMTNEWCD", METACMT_NEWCD, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "METACMTNEWCD2", METACMT_NEWCD2, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "METACMTNEWCD3", METACMT_NEWCD3, ORAPARM_INPUT, ORATYPE_NUMBER

    'メタボリックシンドローム関連検査項目コード
    objOraParam.Add "ITEMCD_GLYCEMIA", GLYCEMIA_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_GLYCEMIA", GLYCEMIA_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_HBA1C", HBA1C_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_HBA1C", HBA1C_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_HDL", HDL_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_HDL", HDL_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_TG", TG_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_TG", TG_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_CBP", CBP_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_CBP", CBP_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_EBP", EBP_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_EBP", EBP_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_WAIST", WAIST_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_WAIST", WAIST_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    ' メタボリックシンドロームチェック用結果データ取得（検査結果、病歴情報）
    strStmt = "SELECT JUDCMTVIEW.RSVNO     AS RSVNO                                 " & vbLf & _
              "       ,NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                        " & vbLf & _
              "              WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO             " & vbLf & _
              "                AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ    " & vbLf & _
              "       ,JUDCMTVIEW.DAYID         AS DAYID                            " & vbLf & _
              "       ,JUDCMTVIEW.PERID         AS PERID                            " & vbLf & _
              "       ,JUDCMTVIEW.GENDER        AS GENDER                           " & vbLf & _
              "       ,JUDCMTVIEW.GLYCEMIARSL   AS GLYCEMIARSL                      " & vbLf & _
              "       ,JUDCMTVIEW.HBA1CRSL      AS HBA1CRSL                         " & vbLf & _
              "       ,JUDCMTVIEW.HDLRSL        AS HDLRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.TGRSL         AS TGRSL                            " & vbLf & _
              "       ,JUDCMTVIEW.CBPRSL        AS CBPRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.EBPRSL        AS EBPRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.WAISTRSL      AS WAISTRSL                         " & vbLf & _
              "       ,JUDCMTVIEW.KETSUATSU     AS KETSUATSU                        " & vbLf & _
              "       ,JUDCMTVIEW.TOUNYOU       AS TOUNYOU                          " & vbLf & _
              "       ,JUDCMTVIEW.SHISITSU      AS SHISITSU                         " & vbLf

    strStmt = strStmt & vbLf & _
              "  FROM (                                             " & vbLf & _
              "         SELECT RECEIPT.RSVNO        AS RSVNO        " & vbLf & _
              "               ,RECEIPT.DAYID        AS DAYID        " & vbLf & _
              "               ,CONSULT.PERID        AS PERID        " & vbLf & _
              "               ,CONSULT.CSCD         AS CSCD         " & vbLf & _
              "               ,PERSON.LASTNAME      AS LASTNAME     " & vbLf & _
              "               ,PERSON.FIRSTNAME     AS FIRSTNAME    " & vbLf & _
              "               ,PERSON.GENDER        AS GENDER,      " & vbLf

    ' 糖代謝判定用の検査結果を取得する
    ' 空腹時血糖値
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_GLYCEMIA AND RSL.SUFFIX = :SUFFIX_GLYCEMIA             " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL           AND RSL.RESULT IS NOT NULL) = 0 THEN          " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_GLYCEMIA     " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_GLYCEMIA)    " & vbLf & _
              "                       END RESULT                                        " & vbLf & _
              "                  FROM DUAL) GLYCEMIARSL,                                " & vbLf
    ' HbA1c
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_HBA1C AND RSL.SUFFIX = :SUFFIX_HBA1C                   " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL        AND RSL.RESULT IS NOT NULL) = 0 THEN             " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_HBA1C        " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_HBA1C)       " & vbLf & _
              "                       END RESULT                                        " & vbLf & _
              "                  FROM DUAL) HBA1CRSL,                                   " & vbLf

    ' 脂質代謝判定用の検査結果を取得する
    ' HDL
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_HDL AND RSL.SUFFIX = :SUFFIX_HDL                       " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL      AND RSL.RESULT IS NOT NULL) = 0 THEN               " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_HDL          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_HDL)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) HDLRSL,                                     " & vbLf

    ' TG
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_TG AND RSL.SUFFIX = :SUFFIX_TG                         " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL     AND RSL.RESULT IS NOT NULL) = 0 THEN                " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_TG           " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_TG)          " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) TGRSL,                                      " & vbLf
    
    ' 収縮期血圧結果
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_CBP AND RSL.SUFFIX = :SUFFIX_CBP                       " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL      AND RSL.RESULT IS NOT NULL) = 0 THEN               " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_CBP          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_CBP)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) CBPRSL,                                     " & vbLf
    
    ' 拡張期血圧結果
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_EBP AND RSL.SUFFIX = :SUFFIX_EBP                       " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL      AND RSL.RESULT IS NOT NULL) = 0 THEN               " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_EBP          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_EBP)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) EBPRSL,                                     " & vbLf
    
    ' 腹囲結果、病歴情報
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_WAIST AND RSL.SUFFIX = :SUFFIX_WAIST                   " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL        AND RSL.RESULT IS NOT NULL) = 0 THEN             " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_WAIST        " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_WAIST)       " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) WAISTRSL                                    " & vbLf & _
              "                ,DECODE(LASTVIEW.KETSUATSU,NULL, 0, LASTVIEW.KETSUATSU)      AS KETSUATSU    " & vbLf & _
              "                ,DECODE(LASTVIEW.TOUNYOU,NULL, 0, LASTVIEW.TOUNYOU)          AS TOUNYOU      " & vbLf & _
              "                ,DECODE(LASTVIEW.SHISITSU,NULL, 0, LASTVIEW.SHISITSU)        AS SHISITSU     " & vbLf
    
    strStmt = strStmt & vbLf & _
              "            FROM RECEIPT, CONSULT, PERSON                                " & vbLf & _
              "                ,(                                                       " & vbLf & _
              "                  SELECT FINAL.RSVNO              AS RSVNO               " & vbLf & _
              "                        ,SUM(FINAL.KETSUATSU)     AS KETSUATSU           " & vbLf & _
              "                        ,SUM(FINAL.TOUNYOU)       AS TOUNYOU             " & vbLf & _
              "                        ,SUM(FINAL.SHISITSU)      AS SHISITSU            " & vbLf & _
              "                    FROM (                                               " & vbLf & _
              "                          SELECT RSLVIEW.RSVNO  AS RSVNO                 " & vbLf & _
              "                                ,RSLVIEW.RESULT AS DISEASEK              " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'19',COUNT(RSLVIEW.RSVNO),0) AS KETSUATSU     " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'48',COUNT(RSLVIEW.RSVNO),0) AS TOUNYOU       " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'47',COUNT(RSLVIEW.RSVNO),0) AS SHISITSU      " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 Start ###
'    strStmt = strStmt & vbLf & _
'              "                            FROM (SELECT RSL.RSVNO, RSL.RESULT,          " & vbLf & _
'              "                                         RSL.ITEMCD , RSL.SUFFIX         " & vbLf & _
'              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE    " & vbLf & _
'              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
'              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
'              "                                     AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
'              "                                     AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
'              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = '01'          " & vbLf & _
'              "                                     AND FREE.FREECD = 'METADIS' || RSL.RESULT  " & vbLf
    strStmt = strStmt & vbLf & _
              "                            FROM (SELECT RSL.RSVNO, FREE.FREEFIELD3 RESULT,  " & vbLf & _
              "                                         RSL.ITEMCD , RSL.SUFFIX             " & vbLf & _
              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE  " & vbLf & _
              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE          " & vbLf & _
              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO     " & vbLf & _
              "                                     AND GRP_I.GRPCD     = :GRPCD            " & vbLf & _
              "                                     AND RSL.RSVNO       = CONSULT.RSVNO     " & vbLf & _
              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD      " & vbLf & _
              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX      " & vbLf & _
              "                                     AND RSL.SUFFIX      = '01'              " & vbLf & _
              "                                     AND FREE.FREECD = 'METADIS' || RSL.RESULT  " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 End   ###
    
    
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                     AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                                     AND RECEIPT.DAYID  <= :ENDDAYID     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                     AND CONSULT.CSCD   = :CSCD          " & vbLf
    End If
    strStmt = strStmt & vbLf & _
              "                                 ) RSLVIEW,                              " & vbLf
    
'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 Start ###
'    strStmt = strStmt & vbLf & _
'              "                                 (SELECT RSL.RSVNO, RSL.RESULT,          " & vbLf & _
'              "                                         RSL.ITEMCD , RSL.SUFFIX         " & vbLf & _
'              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I    " & vbLf & _
'              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
'              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
'              "                                     AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
'              "                                     AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
'              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = '03'          " & vbLf & _
'              "                                     AND RSL.RESULT IN ( '5' )           " & vbLf
    strStmt = strStmt & vbLf & _
              "                                 (SELECT RSL.RSVNO, RSL.RESULT,              " & vbLf & _
              "                                         RSL.ITEMCD , RSL.SUFFIX             " & vbLf & _
              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE  " & vbLf & _
              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE          " & vbLf & _
              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO     " & vbLf & _
              "                                     AND GRP_I.GRPCD     = :GRPCD            " & vbLf & _
              "                                     AND RSL.RSVNO       = CONSULT.RSVNO     " & vbLf & _
              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD      " & vbLf & _
              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX      " & vbLf & _
              "                                     AND RSL.SUFFIX      = '03'              " & vbLf & _
              "                                     AND FREE.FREECD = 'METASTS' || RSL.RESULT  " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 End   ###


    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                     AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                                     AND RECEIPT.DAYID  <= :ENDDAYID     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                     AND CONSULT.CSCD   = :CSCD          " & vbLf
    End If
    strStmt = strStmt & vbLf & _
              "                                 ) STATVIEW                                      " & vbLf & _
              "                            WHERE RSLVIEW.RSVNO  = STATVIEW.RSVNO                " & vbLf & _
              "                              AND RSLVIEW.ITEMCD = STATVIEW.ITEMCD               " & vbLf & _
              "                            GROUP BY RSLVIEW.RSVNO, RSLVIEW.RESULT               " & vbLf & _
              "                          ) FINAL                                                " & vbLf & _
              "                     GROUP BY FINAL.RSVNO                                        " & vbLf & _
              "                 ) LASTVIEW                                                      " & vbLf


    strStmt = strStmt & vbLf & _
              "           WHERE RECEIPT.CSLDATE = :CSLDATE                                      " & vbLf & _
              "             AND RECEIPT.RSVNO   = CONSULT.RSVNO                                 " & vbLf & _
              "             AND RECEIPT.CSLDATE = CONSULT.CSLDATE                               " & vbLf & _
              "             AND CONSULT.PERID   = PERSON.PERID                                  " & vbLf & _
              "             AND CONSULT.RSVNO   = LASTVIEW.RSVNO(+)                             " & vbLf

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "             AND RECEIPT.DAYID  >= :STRDAYID                                     " & vbLf & _
              "             AND RECEIPT.DAYID  <= :ENDDAYID                                     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "             AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "             AND CONSULT.CSCD   = :CSCD                                          " & vbLf
    End If

    
    strStmt = strStmt & vbLf & _
              "       ) JUDCMTVIEW                                                              " & vbLf & _
              " WHERE NOT EXISTS (SELECT * FROM TOTALJUDCMT                                     " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO                   " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE                       " & vbLf & _
              "                      AND TOTALJUDCMT.JUDCMTCD IN (:METACMTNEWCD, :METACMTNEWCD2, :METACMTNEWCD3))   " & vbLf & _
              " ORDER BY JUDCMTVIEW.RSVNO                                                       " & vbLf
    
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objMaxSeq = objFields("MAXSEQ")
    
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objGender = objFields("GENDER")
        Set objGlycemiaRsl = objFields("GLYCEMIARSL")
        Set objHbA1cRsl = objFields("HBA1CRSL")
        Set objHDLRsl = objFields("HDLRSL")
        Set objTGRsl = objFields("TGRSL")
        Set objCBPRsl = objFields("CBPRSL")
        Set objEBPRsl = objFields("EBPRSL")
        Set objWaistRsl = objFields("WAISTRSL")
        Set objKetsuatsu = objFields("KETSUATSU")
        Set objTounyou = objFields("TOUNYOU")
        Set objShisitsu = objFields("SHISITSU")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            lngCheck1 = 0
            lngCheck2 = 0
            lngCheck3 = 0
            
            '欠損値（結果未入力及び検査キャンセル）があった場合、メタボリックシンドロームコメント自動登録しない
            If objWaistRsl.Value <> "" And _
               objTGRsl.Value <> "" And _
               objHDLRsl.Value <> "" And _
               objCBPRsl.Value <> "" And _
               objEBPRsl.Value <> "" And _
               (objGlycemiaRsl.Value <> "" Or objHbA1cRsl.Value <> "") Then
               
                '腹囲が基準値以上の受診者のみ対象にする（男性：85以上、女性：90以上）
                If (objGender.Value = 1 And objWaistRsl.Value >= 85) Or (objGender.Value = 2 And objWaistRsl.Value >= 90) Then
                    
                    '「TG：150以上」と「HDL：40未満」いずれか
                    '或は「高脂血症」で薬剤治療中
                    If objTGRsl.Value >= 150 Or objHDLRsl.Value < 40 Or objShisitsu.Value > 0 Then
                        lngCheck1 = 1
                    End If
                    
                    '「収縮期血圧：130以上」と「拡張期血圧：80以上」いずれか
                    '或は「高血圧」で薬剤治療中
                    If objCBPRsl.Value >= 130 Or objEBPRsl.Value >= 85 Or objKetsuatsu.Value > 0 Then
                        lngCheck2 = 1
                    End If
                    
                    '「FPG：110以上」と「HbA1c：5.5以上」いずれか
                    '或は「糖尿症」で薬剤治療中
                    If objGlycemiaRsl.Value <> "" Then
                        If objGlycemiaRsl.Value >= 110 Or objTounyou.Value > 0 Then
                            lngCheck3 = 1
                        End If
                    Else
                        If objHbA1cRsl.Value >= 5.5 Or objTounyou.Value > 0 Then
                            lngCheck3 = 1
                        End If
                    End If
                
                    'メタボリックシンドローム対象者のみ指定総合コメント登録
                    '「脂質」、「血圧」、「血糖」のリスク（失点）によって該当コメントを格納
                    ReDim Preserve vntArrRsvNo(lngCount)
                    ReDim Preserve vntArrDispMode(lngCount)
                    ReDim Preserve vntArrMaxSeq(lngCount)
                    ReDim Preserve vntArrJudCmtCd(lngCount)
                    ReDim Preserve vntArrJudCmtCd2(lngCount)
                    vntArrRsvNo(lngCount) = objRsvNo.Value
                    vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
                    vntArrMaxSeq(lngCount) = objMaxSeq.Value
                    
                    If (lngCheck1 + lngCheck2 + lngCheck3) >= 2 Then
                        vntArrJudCmtCd(lngCount) = METACMT_NEWCD
                    Else
                        If (lngCheck1 + lngCheck2 + lngCheck3) = 1 Then
                            vntArrJudCmtCd(lngCount) = METACMT_NEWCD2
                        Else
                            vntArrJudCmtCd(lngCount) = METACMT_NEWCD3
                        End If
                    End If
                    lngCount = lngCount + 1
                
                Else
                    '腹囲が基準値範囲内の場合(腹囲が登録されていない受診者はコメント登録なし）
                    If objWaistRsl.Value <> "" Then
                        ReDim Preserve vntArrRsvNo(lngCount)
                        ReDim Preserve vntArrDispMode(lngCount)
                        ReDim Preserve vntArrMaxSeq(lngCount)
                        ReDim Preserve vntArrJudCmtCd(lngCount)
                        ReDim Preserve vntArrJudCmtCd2(lngCount)
                        vntArrRsvNo(lngCount) = objRsvNo.Value
                        vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
                        vntArrMaxSeq(lngCount) = objMaxSeq.Value
                        vntArrJudCmtCd(lngCount) = METACMT_NEWCD3

                        lngCount = lngCount + 1
                    End If
                End If
            End If
            
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
        If lngCount > 0 Then
            '#### InsertTotalJudCmt()中では「vntArrMaxSeq」引数は使わない ####
            UpdateMetaCmt2 = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
        End If
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If


    '戻り値の設定
    UpdateMetaCmt2 = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateMetaCmt2"
    
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
'### 2008.03.04 張 メタボリックシンドローム総合コメント登録処理新規追加（特定健診に合わせて、2008年4月1日以降受診者） End


'### 2013.03.30 張 HbA1c検査項目変更（HbA1c(JDS)→HbA1c(NGSP)）の為、メタボリックシンドローム総合コメント登録処理仕様変更（2013年4月1日以降受診者） Start
Public Function UpdateMetaCmt3( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objMaxSeq           As OraField         'MAX SEQ
    
    Dim objDayId            As OraField         '当日ID
    Dim objPerId            As OraField         '個人ID
    Dim objGender           As OraField         '性別
    Dim objGlycemiaRsl      As OraField         '空腹時血糖
    Dim objHbA1cRsl         As OraField         'HbA1c
    Dim objHDLRsl           As OraField         'HDL
    Dim objTGRsl            As OraField         'TG
    Dim objCBPRsl           As OraField         '収縮期血圧
    Dim objEBPRsl           As OraField         '拡張期血圧
    Dim objWaistRsl         As OraField         '腹囲
    Dim objKetsuatsu        As OraField         '高血圧
    Dim objTounyou          As OraField         '糖尿病
    Dim objShisitsu         As OraField         '高脂血症
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    Dim vntArrJudCmtCd2()   As Variant          '判定コメントコード２
    
    Dim metaCmtAdd          As Boolean          'メタボリックシンドローム関連総合コメント追加可否
    
    Dim lngCheck1           As Long             '脂質関連チェック
    Dim lngCheck2           As Long             '血圧関連チェック
    Dim lngCheck3           As Long             '血糖関連チェック
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    
    'メタボリックシンドローム総合コメント用のグループコード
    objOraParam.Add "GRPCD", Trim(METACMT_GRPCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    'メタボリックシンドローム用総合コメントコード
    objOraParam.Add "METACMTNEWCD", METACMT_NEWCD, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "METACMTNEWCD2", METACMT_NEWCD2, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "METACMTNEWCD3", METACMT_NEWCD3, ORAPARM_INPUT, ORATYPE_NUMBER

    'メタボリックシンドローム関連検査項目コード
    objOraParam.Add "ITEMCD_GLYCEMIA", GLYCEMIA_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_GLYCEMIA", GLYCEMIA_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_HBA1C_NGSP", HBA1C_NGSP_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_HBA1C_NGSP", HBA1C_NGSP_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_HDL", HDL_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_HDL", HDL_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_TG", TG_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_TG", TG_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_CBP", CBP_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_CBP", CBP_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_EBP", EBP_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_EBP", EBP_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD_WAIST", WAIST_ITEMCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX_WAIST", WAIST_SUFFIX, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    ' メタボリックシンドロームチェック用結果データ取得（検査結果、病歴情報）
    strStmt = "SELECT JUDCMTVIEW.RSVNO     AS RSVNO                                 " & vbLf & _
              "       ,NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                        " & vbLf & _
              "              WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO             " & vbLf & _
              "                AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ    " & vbLf & _
              "       ,JUDCMTVIEW.DAYID         AS DAYID                            " & vbLf & _
              "       ,JUDCMTVIEW.PERID         AS PERID                            " & vbLf & _
              "       ,JUDCMTVIEW.GENDER        AS GENDER                           " & vbLf & _
              "       ,JUDCMTVIEW.GLYCEMIARSL   AS GLYCEMIARSL                      " & vbLf & _
              "       ,JUDCMTVIEW.HBA1CRSL      AS HBA1CRSL                         " & vbLf & _
              "       ,JUDCMTVIEW.HDLRSL        AS HDLRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.TGRSL         AS TGRSL                            " & vbLf & _
              "       ,JUDCMTVIEW.CBPRSL        AS CBPRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.EBPRSL        AS EBPRSL                           " & vbLf & _
              "       ,JUDCMTVIEW.WAISTRSL      AS WAISTRSL                         " & vbLf & _
              "       ,JUDCMTVIEW.KETSUATSU     AS KETSUATSU                        " & vbLf & _
              "       ,JUDCMTVIEW.TOUNYOU       AS TOUNYOU                          " & vbLf & _
              "       ,JUDCMTVIEW.SHISITSU      AS SHISITSU                         " & vbLf

    strStmt = strStmt & vbLf & _
              "  FROM (                                             " & vbLf & _
              "         SELECT RECEIPT.RSVNO        AS RSVNO        " & vbLf & _
              "               ,RECEIPT.DAYID        AS DAYID        " & vbLf & _
              "               ,CONSULT.PERID        AS PERID        " & vbLf & _
              "               ,CONSULT.CSCD         AS CSCD         " & vbLf & _
              "               ,PERSON.LASTNAME      AS LASTNAME     " & vbLf & _
              "               ,PERSON.FIRSTNAME     AS FIRSTNAME    " & vbLf & _
              "               ,PERSON.GENDER        AS GENDER,      " & vbLf

    ' 糖代謝判定用の検査結果を取得する
    ' 空腹時血糖値
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_GLYCEMIA AND RSL.SUFFIX = :SUFFIX_GLYCEMIA             " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL           AND RSL.RESULT IS NOT NULL) = 0 THEN          " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_GLYCEMIA     " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_GLYCEMIA)    " & vbLf & _
              "                       END RESULT                                        " & vbLf & _
              "                  FROM DUAL) GLYCEMIARSL,                                " & vbLf
    ' HbA1c
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_HBA1C_NGSP AND RSL.SUFFIX = :SUFFIX_HBA1C_NGSP         " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL        AND RSL.RESULT IS NOT NULL) = 0 THEN             " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_HBA1C_NGSP   " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_HBA1C_NGSP)  " & vbLf & _
              "                       END RESULT                                        " & vbLf & _
              "                  FROM DUAL) HBA1CRSL,                                   " & vbLf

    ' 脂質代謝判定用の検査結果を取得する
    ' HDL
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_HDL AND RSL.SUFFIX = :SUFFIX_HDL                       " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL      AND RSL.RESULT IS NOT NULL) = 0 THEN               " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_HDL          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_HDL)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) HDLRSL,                                     " & vbLf

    ' TG
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_TG AND RSL.SUFFIX = :SUFFIX_TG                         " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL     AND RSL.RESULT IS NOT NULL) = 0 THEN                " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_TG           " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_TG)          " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) TGRSL,                                      " & vbLf
    
    ' 収縮期血圧結果
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_CBP AND RSL.SUFFIX = :SUFFIX_CBP                       " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL      AND RSL.RESULT IS NOT NULL) = 0 THEN               " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_CBP          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_CBP)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) CBPRSL,                                     " & vbLf
    
    ' 拡張期血圧結果
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_EBP AND RSL.SUFFIX = :SUFFIX_EBP                       " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL      AND RSL.RESULT IS NOT NULL) = 0 THEN               " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_EBP          " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_EBP)         " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) EBPRSL,                                     " & vbLf
    
    ' 腹囲結果、病歴情報
    strStmt = strStmt & vbLf & _
              "                (SELECT CASE                                             " & vbLf & _
              "                        WHEN (SELECT COUNT(*) FROM RSL WHERE RSL.RSVNO = RECEIPT.RSVNO                           " & vbLf & _
              "                                 AND RSL.ITEMCD = :ITEMCD_WAIST AND RSL.SUFFIX = :SUFFIX_WAIST                   " & vbLf & _
              "                                 AND RSL.STOPFLG IS NULL        AND RSL.RESULT IS NOT NULL) = 0 THEN             " & vbLf & _
              "                                 ''                                      " & vbLf & _
              "                        Else                                             " & vbLf & _
              "                             (SELECT RSL.RESULT FROM RSL                 " & vbLf & _
              "                               WHERE RSL.RSVNO = RECEIPT.RSVNO           " & vbLf & _
              "                                 AND RSL.ITEMCD   = :ITEMCD_WAIST        " & vbLf & _
              "                                 AND RSL.SUFFIX   = :SUFFIX_WAIST)       " & vbLf & _
              "                        END RESULT                                       " & vbLf & _
              "                  FROM DUAL) WAISTRSL                                    " & vbLf & _
              "                ,DECODE(LASTVIEW.KETSUATSU,NULL, 0, LASTVIEW.KETSUATSU)      AS KETSUATSU    " & vbLf & _
              "                ,DECODE(LASTVIEW.TOUNYOU,NULL, 0, LASTVIEW.TOUNYOU)          AS TOUNYOU      " & vbLf & _
              "                ,DECODE(LASTVIEW.SHISITSU,NULL, 0, LASTVIEW.SHISITSU)        AS SHISITSU     " & vbLf
    
    strStmt = strStmt & vbLf & _
              "            FROM RECEIPT, CONSULT, PERSON                                " & vbLf & _
              "                ,(                                                       " & vbLf & _
              "                  SELECT FINAL.RSVNO              AS RSVNO               " & vbLf & _
              "                        ,SUM(FINAL.KETSUATSU)     AS KETSUATSU           " & vbLf & _
              "                        ,SUM(FINAL.TOUNYOU)       AS TOUNYOU             " & vbLf & _
              "                        ,SUM(FINAL.SHISITSU)      AS SHISITSU            " & vbLf & _
              "                    FROM (                                               " & vbLf & _
              "                          SELECT RSLVIEW.RSVNO  AS RSVNO                 " & vbLf & _
              "                                ,RSLVIEW.RESULT AS DISEASEK              " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'19',COUNT(RSLVIEW.RSVNO),0) AS KETSUATSU     " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'48',COUNT(RSLVIEW.RSVNO),0) AS TOUNYOU       " & vbLf & _
              "                                ,DECODE(RSLVIEW.RESULT,'47',COUNT(RSLVIEW.RSVNO),0) AS SHISITSU      " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 Start ###
'    strStmt = strStmt & vbLf & _
'              "                            FROM (SELECT RSL.RSVNO, RSL.RESULT,          " & vbLf & _
'              "                                         RSL.ITEMCD , RSL.SUFFIX         " & vbLf & _
'              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE    " & vbLf & _
'              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
'              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
'              "                                     AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
'              "                                     AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
'              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = '01'          " & vbLf & _
'              "                                     AND FREE.FREECD = 'METADIS' || RSL.RESULT  " & vbLf
    strStmt = strStmt & vbLf & _
              "                            FROM (SELECT RSL.RSVNO, FREE.FREEFIELD3 RESULT,  " & vbLf & _
              "                                         RSL.ITEMCD , RSL.SUFFIX             " & vbLf & _
              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE  " & vbLf & _
              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE          " & vbLf & _
              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO     " & vbLf & _
              "                                     AND GRP_I.GRPCD     = :GRPCD            " & vbLf & _
              "                                     AND RSL.RSVNO       = CONSULT.RSVNO     " & vbLf & _
              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD      " & vbLf & _
              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX      " & vbLf & _
              "                                     AND RSL.SUFFIX      = '01'              " & vbLf & _
              "                                     AND FREE.FREECD = 'METADIS' || RSL.RESULT  " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 End   ###
    
    
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                     AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                                     AND RECEIPT.DAYID  <= :ENDDAYID     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                     AND CONSULT.CSCD   = :CSCD          " & vbLf
    End If
    strStmt = strStmt & vbLf & _
              "                                 ) RSLVIEW,                              " & vbLf
    
'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 Start ###
'    strStmt = strStmt & vbLf & _
'              "                                 (SELECT RSL.RSVNO, RSL.RESULT,          " & vbLf & _
'              "                                         RSL.ITEMCD , RSL.SUFFIX         " & vbLf & _
'              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I    " & vbLf & _
'              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
'              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO " & vbLf & _
'              "                                     AND GRP_I.GRPCD     = :GRPCD        " & vbLf & _
'              "                                     AND RSL.RSVNO       = CONSULT.RSVNO " & vbLf & _
'              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX  " & vbLf & _
'              "                                     AND RSL.SUFFIX      = '03'          " & vbLf & _
'              "                                     AND RSL.RESULT IN ( '5' )           " & vbLf
    strStmt = strStmt & vbLf & _
              "                                 (SELECT RSL.RSVNO, RSL.RESULT,              " & vbLf & _
              "                                         RSL.ITEMCD , RSL.SUFFIX             " & vbLf & _
              "                                    FROM RSL, CONSULT, RECEIPT, GRP_I, FREE  " & vbLf & _
              "                                   WHERE RECEIPT.CSLDATE = :CSLDATE          " & vbLf & _
              "                                     AND CONSULT.RSVNO   = RECEIPT.RSVNO     " & vbLf & _
              "                                     AND GRP_I.GRPCD     = :GRPCD            " & vbLf & _
              "                                     AND RSL.RSVNO       = CONSULT.RSVNO     " & vbLf & _
              "                                     AND RSL.ITEMCD      = GRP_I.ITEMCD      " & vbLf & _
              "                                     AND RSL.SUFFIX      = GRP_I.SUFFIX      " & vbLf & _
              "                                     AND RSL.SUFFIX      = '03'              " & vbLf & _
              "                                     AND FREE.FREECD = 'METASTS' || RSL.RESULT  " & vbLf

'### 2011.04.20 SL-SN-Y0101-002 MOD 張 階層化に含まれる病名コードや治療状況を汎用マスタで管理する為仕様変更 End   ###


    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "                                     AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "                                     AND RECEIPT.DAYID  <= :ENDDAYID     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "                   AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "                                     AND CONSULT.CSCD   = :CSCD          " & vbLf
    End If
    strStmt = strStmt & vbLf & _
              "                                 ) STATVIEW                                      " & vbLf & _
              "                            WHERE RSLVIEW.RSVNO  = STATVIEW.RSVNO                " & vbLf & _
              "                              AND RSLVIEW.ITEMCD = STATVIEW.ITEMCD               " & vbLf & _
              "                            GROUP BY RSLVIEW.RSVNO, RSLVIEW.RESULT               " & vbLf & _
              "                          ) FINAL                                                " & vbLf & _
              "                     GROUP BY FINAL.RSVNO                                        " & vbLf & _
              "                 ) LASTVIEW                                                      " & vbLf


    strStmt = strStmt & vbLf & _
              "           WHERE RECEIPT.CSLDATE = :CSLDATE                                      " & vbLf & _
              "             AND RECEIPT.RSVNO   = CONSULT.RSVNO                                 " & vbLf & _
              "             AND RECEIPT.CSLDATE = CONSULT.CSLDATE                               " & vbLf & _
              "             AND CONSULT.PERID   = PERSON.PERID                                  " & vbLf & _
              "             AND CONSULT.RSVNO   = LASTVIEW.RSVNO(+)                             " & vbLf

    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "             AND RECEIPT.DAYID  >= :STRDAYID                                     " & vbLf & _
              "             AND RECEIPT.DAYID  <= :ENDDAYID                                     " & vbLf
    Else
        strStmt = strStmt & vbLf & _
              "             AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
    
    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "             AND CONSULT.CSCD   = :CSCD                                          " & vbLf
    End If

    
    strStmt = strStmt & vbLf & _
              "       ) JUDCMTVIEW                                                              " & vbLf & _
              " WHERE NOT EXISTS (SELECT * FROM TOTALJUDCMT                                     " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO = JUDCMTVIEW.RSVNO                   " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE                       " & vbLf & _
              "                      AND TOTALJUDCMT.JUDCMTCD IN (:METACMTNEWCD, :METACMTNEWCD2, :METACMTNEWCD3))   " & vbLf & _
              " ORDER BY JUDCMTVIEW.RSVNO                                                       " & vbLf
    
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objMaxSeq = objFields("MAXSEQ")
    
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objGender = objFields("GENDER")
        Set objGlycemiaRsl = objFields("GLYCEMIARSL")
        Set objHbA1cRsl = objFields("HBA1CRSL")
        Set objHDLRsl = objFields("HDLRSL")
        Set objTGRsl = objFields("TGRSL")
        Set objCBPRsl = objFields("CBPRSL")
        Set objEBPRsl = objFields("EBPRSL")
        Set objWaistRsl = objFields("WAISTRSL")
        Set objKetsuatsu = objFields("KETSUATSU")
        Set objTounyou = objFields("TOUNYOU")
        Set objShisitsu = objFields("SHISITSU")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            lngCheck1 = 0
            lngCheck2 = 0
            lngCheck3 = 0
            
            '欠損値（結果未入力及び検査キャンセル）があった場合、メタボリックシンドロームコメント自動登録しない
            If objWaistRsl.Value <> "" And _
               objTGRsl.Value <> "" And _
               objHDLRsl.Value <> "" And _
               objCBPRsl.Value <> "" And _
               objEBPRsl.Value <> "" And _
               (objGlycemiaRsl.Value <> "" Or objHbA1cRsl.Value <> "") Then
               
                '腹囲が基準値以上の受診者のみ対象にする（男性：85以上、女性：90以上）
                If (objGender.Value = 1 And objWaistRsl.Value >= 85) Or (objGender.Value = 2 And objWaistRsl.Value >= 90) Then
                    
                    '「TG：150以上」と「HDL：40未満」いずれか
                    '或は「高脂血症」で薬剤治療中
                    If objTGRsl.Value >= 150 Or objHDLRsl.Value < 40 Or objShisitsu.Value > 0 Then
                        lngCheck1 = 1
                    End If
                    
                    '「収縮期血圧：130以上」と「拡張期血圧：80以上」いずれか
                    '或は「高血圧」で薬剤治療中
                    If objCBPRsl.Value >= 130 Or objEBPRsl.Value >= 85 Or objKetsuatsu.Value > 0 Then
                        lngCheck2 = 1
                    End If
                    
                    '## 2013.03.30 張 HbA1c(NGSP)値への検査項目変更に伴って判定基準変更（5.5以上→6.0以上）
                    '「FPG：110以上」FPG値が得られなかった場合「HbA1c：6.0以上」と
                    '或は「糖尿症」で薬剤治療中
                    If objGlycemiaRsl.Value <> "" Then
                        If objGlycemiaRsl.Value >= 110 Or objTounyou.Value > 0 Then
                            lngCheck3 = 1
                        End If
                    Else
                        If objHbA1cRsl.Value >= 6 Or objTounyou.Value > 0 Then
                            lngCheck3 = 1
                        End If
                    End If
                
                    'メタボリックシンドローム対象者のみ指定総合コメント登録
                    '「脂質」、「血圧」、「血糖」のリスク（失点）によって該当コメントを格納
                    ReDim Preserve vntArrRsvNo(lngCount)
                    ReDim Preserve vntArrDispMode(lngCount)
                    ReDim Preserve vntArrMaxSeq(lngCount)
                    ReDim Preserve vntArrJudCmtCd(lngCount)
                    ReDim Preserve vntArrJudCmtCd2(lngCount)
                    vntArrRsvNo(lngCount) = objRsvNo.Value
                    vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
                    vntArrMaxSeq(lngCount) = objMaxSeq.Value
                    
                    If (lngCheck1 + lngCheck2 + lngCheck3) >= 2 Then
                        vntArrJudCmtCd(lngCount) = METACMT_NEWCD
                    Else
                        If (lngCheck1 + lngCheck2 + lngCheck3) = 1 Then
                            vntArrJudCmtCd(lngCount) = METACMT_NEWCD2
                        Else
                            vntArrJudCmtCd(lngCount) = METACMT_NEWCD3
                        End If
                    End If
                    lngCount = lngCount + 1
                
                Else
                    '腹囲が基準値範囲内の場合(腹囲が登録されていない受診者はコメント登録なし）
                    If objWaistRsl.Value <> "" Then
                        ReDim Preserve vntArrRsvNo(lngCount)
                        ReDim Preserve vntArrDispMode(lngCount)
                        ReDim Preserve vntArrMaxSeq(lngCount)
                        ReDim Preserve vntArrJudCmtCd(lngCount)
                        ReDim Preserve vntArrJudCmtCd2(lngCount)
                        vntArrRsvNo(lngCount) = objRsvNo.Value
                        vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
                        vntArrMaxSeq(lngCount) = objMaxSeq.Value
                        vntArrJudCmtCd(lngCount) = METACMT_NEWCD3

                        lngCount = lngCount + 1
                    End If
                End If
            End If
            
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
        If lngCount > 0 Then
            '#### InsertTotalJudCmt()中では「vntArrMaxSeq」引数は使わない ####
            UpdateMetaCmt3 = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
        End If
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If


    '戻り値の設定
    UpdateMetaCmt3 = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateMetaCmt3"
    
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
'### 2013.03.30 張 HbA1c検査項目変更（HbA1c(JDS)→HbA1c(NGSP)）の為、メタボリックシンドローム総合コメント登録処理仕様変更（2013年4月1日以降受診者） End



'
'### 　追加 2004.01.14
'
' 機能　　 : 内視鏡総合コメントをセットする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
'
' 戻り値　 : True = 正常終了
' 　　　　 : False = 異常終了
'
' 備考　　 :
'
Public Function UpdateNaishikyouCmt( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objMaxSeq           As OraField         'MAX SEQ
    Dim objJudCmtCd         As OraField         '判定コメントコード
        
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
        
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '内視鏡コメント判定用のITEMCD，SUFFIX
    objOraParam.Add "ITEMCD1", Trim(TOP_ITEMCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX1", Trim(TOP_SUFFIX), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD2", Trim(LOWER1_ITEMCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX2", Trim(LOWER1_SUFFIX), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD3", Trim(LOWER2_ITEMCD), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX3", Trim(LOWER2_SUFFIX), ORAPARM_INPUT, ORATYPE_VARCHAR2
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件にあった受診者の判定コメントコードを取得する
    strStmt = "SELECT NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT                       " & vbLf & _
              "             WHERE TOTALJUDCMT.RSVNO = RSLVIEW.RSVNO               " & vbLf & _
              "               AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ,  " & vbLf & _
              "       RSLVIEW.RSVNO, RSLVIEW.JUDCMTCD                             " & vbLf & _
              "  FROM (SELECT RSL.RSVNO, STDVALUE_C.JUDCMTCD                      " & vbLf & _
              "          FROM STDVALUE_C, RSL,                                    " & vbLf & _
              "               CONSULT, RECEIPT                                    "

    '指定受診日の受付済み受診者を対象とする
    strStmt = strStmt & vbLf & _
              "         WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
              "           AND RECEIPT.RSVNO   = CONSULT.RSVNO "
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "           AND RECEIPT.DAYID       >= :STRDAYID " & vbLf & _
              "           AND RECEIPT.DAYID       <= :ENDDAYID "
    Else
        strStmt = strStmt & vbLf & _
              "           AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If
              
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "           AND CONSULT.CSCD = :CSCD "
    End If

    '対象の検査結果と判定コメントコードを取得
    strStmt = strStmt & vbLf & _
              "           AND RSL.RSVNO    = CONSULT.RSVNO                        " & vbLf & _
              "           AND ((RSL.ITEMCD = :ITEMCD1 AND RSL.SUFFIX = :SUFFIX1)  " & vbLf & _
              "            OR  (RSL.ITEMCD = :ITEMCD2 AND RSL.SUFFIX = :SUFFIX2)  " & vbLf & _
              "            OR  (RSL.ITEMCD = :ITEMCD3 AND RSL.SUFFIX = :SUFFIX3)) " & vbLf & _
              "           AND RSL.STDVALUECD = STDVALUE_C.STDVALUECD              " & vbLf & _
              "       ) RSLVIEW"
    ' 総合コメントテーブルに登録されていないもの
    strStmt = strStmt & vbLf & _
              " WHERE NOT EXISTS (SELECT * FROM TOTALJUDCMT                       " & vbLf & _
              "                    WHERE TOTALJUDCMT.RSVNO    = RSLVIEW.RSVNO     " & vbLf & _
              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE         " & vbLf & _
              "                      AND TOTALJUDCMT.JUDCMTCD = RSLVIEW.JUDCMTCD) "

    strStmt = strStmt & vbLf & _
              " ORDER BY RSLVIEW.RSVNO                                            "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objMaxSeq = objFields("MAXSEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrDispMode(lngCount)
            ReDim Preserve vntArrMaxSeq(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
            vntArrMaxSeq(lngCount) = objMaxSeq.Value
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop

        UpdateNaishikyouCmt = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    UpdateNaishikyouCmt = True
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateNaishikyouCmt"
    
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
'### 聖路加対応　追加 2003.12.12
'
' 機能　　 : コメントのない人に良好コメントをセットする
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     lngDayIdFlg        1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId        検索開始ＩＤ
' 　　　　   (In)     lngEndDayId        検索終了ＩＤ
' 　　　　   (In)     vntArrDayId        検索ＩＤ（配列）
' 　　　　   (In)     strCsCd            コースコード
'
' 戻り値　 : True = 正常終了
' 　　　　 : False = 異常終了
'
' 備考　　 :
'
Public Function UpdateGoodCmt( _
    ByVal dtmCslDate As Date, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objJudCmtCd         As OraField         '判定コメントコード
    Dim objMaxSeq           As OraField         '判定コメントSEQ最大値
    
    Dim vntArrRsvNo()       As Variant          '予約番号
    Dim vntArrDispMode()    As Variant          '表示モード
    Dim vntArrMaxSeq()      As Variant          'MAX SEQ
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコード
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    '当日ID範囲指定？
    If lngDayIdFlg = 1 Then
'### 2004.01.22 バグ修正
'        If lngStrDayId <= lngEndDayId Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", CLng(lngEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", CLng(lngStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        For i = 0 To UBound(vntArrDayId)
            objOraParam.Add "DAYID" & i, CLng(vntArrDayId(i)), ORAPARM_INPUT, ORATYPE_NUMBER
        Next i
    End If
    If Trim(strCsCd) <> "" Then
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '総合コメント登録用の表示モード
    objOraParam.Add "DISPMODE", TOTALCMT_DISPMODE, ORAPARM_INPUT, ORATYPE_NUMBER
    
'### 2004/2/12 Updated by Ishihara@FSIT 判定が全て揃い、かつコメントがセットされていない時のみセットする。
'    ' 総合コメントのない予約番号取得
'    strStmt = "SELECT RSLVIEW.RSVNO, FREE.FREEFIELD1 JUDCMTCD            " & vbLf & _
'              "  FROM FREE,                                              "
'
'    ' 対象の予約番号取得
'    strStmt = strStmt & vbLf & _
'              "       (SELECT CONSULT.RSVNO                   " & vbLf & _
'              "          FROM CONSULT, RECEIPT                " & vbLf & _
'              "         WHERE RECEIPT.CSLDATE = :CSLDATE      " & vbLf & _
'              "           AND CONSULT.RSVNO   = RECEIPT.RSVNO "
'
'    '当日ID範囲指定時
'    If lngDayIdFlg = 1 Then
'        strStmt = strStmt & vbLf & _
'              "           AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
'              "           AND RECEIPT.DAYID  <= :ENDDAYID     "
'    Else
'        strStmt = strStmt & vbLf & _
'              "           AND RECEIPT.DAYID IN ( "
'        For i = 0 To UBound(vntArrDayId)
'            If i > 0 Then
'                strStmt = strStmt & ","
'            End If
'            strStmt = strStmt & ":DAYID" & i
'        Next i
'        strStmt = strStmt & ")"
'    End If

'    'コースコードが指定されている場合
'    If Trim(strCsCd) <> "" Then
'        strStmt = strStmt & vbLf & _
'              "           AND CONSULT.CSCD   = :CSCD    "
'    End If
'
'    strStmt = strStmt & vbLf & _
'              "       ) RSLVIEW"
'
'    strStmt = strStmt & vbLf & _
'              " WHERE FREE.FREECD = 'GOODCMT'           "
'
'    ' 総合コメントテーブルに登録されていないもの
'    strStmt = strStmt & vbLf & _
'              "   AND NOT EXISTS (SELECT * FROM TOTALJUDCMT                       " & vbLf & _
'              "                    WHERE TOTALJUDCMT.RSVNO    = RSLVIEW.RSVNO     " & vbLf & _
'              "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE    )    " & vbLf & _
'              " ORDER BY RSLVIEW.RSVNO                                            "
    
    '①受診コース、結果テーブルの要素から、判定すべき分類を抽出
    '　※その際、乳房関連のダミー判定分類は、乳房の判定分類になるようCASE文で置き換え
    '②①で抽出した判定分類と実際の判定結果テーブルをJOIN。判定コードがセットされていなければフラグ成立
    '③フラグのカウントをサマリ。判定が全てセットされていると0になるはず。
    strStmt = strStmt & "SELECT RSLVIEW.RSVNO, FREE.FREEFIELD1 JUDCMTCD          " & vbLf
'### 2008/4/14 張 メタボリックシンドロームコメントは別として総合コメント有無チェック Start ###
'### 既に登録されている総合コメントのSEQ最大値を取得し、その後に良好コメント追加
'### InsertTotalJudCmt()では、参照していないが、念のため取得して送る
    strStmt = strStmt & "      ,NVL((SELECT MAX(SEQ) FROM TOTALJUDCMT            " & vbLf
    strStmt = strStmt & "             WHERE TOTALJUDCMT.RSVNO = RSLVIEW.RSVNO    " & vbLf
    strStmt = strStmt & "               AND TOTALJUDCMT.DISPMODE = :DISPMODE), 0 ) MAXSEQ    " & vbLf
'### 2008/4/14 張 メタボリックシンドロームコメントは別として総合コメント有無チェック End   ###
    strStmt = strStmt & "  FROM FREE,                                            " & vbLf
    strStmt = strStmt & "      (                                                 " & vbLf
    strStmt = strStmt & "       SELECT DISTINCT RSVNO                            " & vbLf
    strStmt = strStmt & "         FROM (                                         " & vbLf
    strStmt = strStmt & "                SELECT RSVNO, SUM(JUDCHECK) NOSETCOUNT  " & vbLf
    strStmt = strStmt & "                  FROM (                                " & vbLf
    strStmt = strStmt & "                         SELECT DISTINCT TARGETJUDCLASS.RSVNO, NVL2(JUDRSL.JUDCD, 0, 1) JUDCHECK " & vbLf
    strStmt = strStmt & "                           FROM JUDRSL,                                                          " & vbLf
    strStmt = strStmt & "                                (                                                                " & vbLf
    strStmt = strStmt & "                                  SELECT DISTINCT CONSULT.RSVNO,                                 " & vbLf
    strStmt = strStmt & "                                         CASE COURSE_JUD.JUDCLASSCD                              " & vbLf
    strStmt = strStmt & "                                         WHEN 54 THEN 24                                         " & vbLf
    strStmt = strStmt & "                                         WHEN 55 THEN 24                                         " & vbLf
    strStmt = strStmt & "                                         WHEN 56 THEN 24                                         " & vbLf
    strStmt = strStmt & "                                         ELSE COURSE_JUD.JUDCLASSCD END JUDCLASSCD,              " & vbLf
    strStmt = strStmt & "                                         CASE COURSE_JUD.JUDCLASSCD                              " & vbLf
    strStmt = strStmt & "                                         WHEN 54 THEN NULL                                       " & vbLf
    strStmt = strStmt & "                                         WHEN 55 THEN NULL                                       " & vbLf
    strStmt = strStmt & "                                         WHEN 56 THEN NULL                                       " & vbLf
    strStmt = strStmt & "                                         ELSE JUDCLASS.COMMENTONLY END COMMENTONLY               " & vbLf
    strStmt = strStmt & "                                    FROM RSL, ITEM_JUD, JUDCLASS, COURSE_JUD, CONSULT            " & vbLf
    strStmt = strStmt & "                                   WHERE CONSULT.RSVNO IN                                        " & vbLf
    strStmt = strStmt & "                                         ( SELECT CONSULT.RSVNO                                  " & vbLf
    strStmt = strStmt & "                                             FROM CONSULT, RECEIPT                               " & vbLf
    strStmt = strStmt & "                                            WHERE RECEIPT.CSLDATE  = :CSLDATE                    " & vbLf
    strStmt = strStmt & "                                              AND CONSULT.RSVNO    = RECEIPT.RSVNO               " & vbLf
    
    '当日ID範囲指定時
    If lngDayIdFlg = 1 Then
        strStmt = strStmt & vbLf & _
              "           AND RECEIPT.DAYID  >= :STRDAYID     " & vbLf & _
              "           AND RECEIPT.DAYID  <= :ENDDAYID     "
    Else
        strStmt = strStmt & vbLf & _
              "           AND RECEIPT.DAYID IN ( "
        For i = 0 To UBound(vntArrDayId)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & ":DAYID" & i
        Next i
        strStmt = strStmt & ")"
    End If

    'コースコードが指定されている場合
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "           AND CONSULT.CSCD   = :CSCD    "
    End If
    
    strStmt = strStmt & "                                         )                                                       " & vbLf
    strStmt = strStmt & "                                     AND RSL.RSVNO           = CONSULT.RSVNO                     " & vbLf
    strStmt = strStmt & "                                     AND COURSE_JUD.CSCD     = CONSULT.CSCD                      " & vbLf
'### 2007/7/13 張 婦人科判定分類変更によって総合コメント自動登録ロジック変更（婦人科判定分類を除いてチェック） Start ###
    strStmt = strStmt & "                                     AND COURSE_JUD.JUDCLASSCD NOT IN ('25')                     " & vbLf
'### 2007/7/13 張 婦人科判定分類変更によって総合コメント自動登録ロジック変更（婦人科判定分類を除いてチェック） End   ###
    strStmt = strStmt & "                                     AND JUDCLASS.JUDCLASSCD = COURSE_JUD.JUDCLASSCD             " & vbLf
    strStmt = strStmt & "                                     AND ITEM_JUD.JUDCLASSCD = COURSE_JUD.JUDCLASSCD             " & vbLf
    strStmt = strStmt & "                                     AND RSL.ITEMCD          = ITEM_JUD.ITEMCD                   " & vbLf
    strStmt = strStmt & "                                     AND RSL.STOPFLG IS NULL                                     " & vbLf
    strStmt = strStmt & "                                ) TARGETJUDCLASS                                                 " & vbLf
    strStmt = strStmt & "                          WHERE TARGETJUDCLASS.RSVNO      = JUDRSL.RSVNO(+)                      " & vbLf
    strStmt = strStmt & "                            AND TARGETJUDCLASS.JUDCLASSCD = JUDRSL.JUDCLASSCD(+)                 " & vbLf
    strStmt = strStmt & "                            AND TARGETJUDCLASS.COMMENTONLY IS NULL " & vbLf
    strStmt = strStmt & "                       )                                           " & vbLf
    strStmt = strStmt & "                 GROUP BY RSVNO                                    " & vbLf
    strStmt = strStmt & "              )                                                    " & vbLf
    strStmt = strStmt & "        WHERE NOSETCOUNT = 0                                       " & vbLf
    strStmt = strStmt & "       ) RSLVIEW                                                   " & vbLf
    strStmt = strStmt & " WHERE FREE.FREECD = 'GOODCMT'                                     " & vbLf
    strStmt = strStmt & "   AND NOT EXISTS (SELECT * FROM TOTALJUDCMT                       " & vbLf
    strStmt = strStmt & "                    WHERE TOTALJUDCMT.RSVNO    = RSLVIEW.RSVNO     " & vbLf

'### 2008/4/14 張 メタボリックシンドロームコメントは別として総合コメント有無チェック Start ###
    strStmt = strStmt & "                      AND TOTALJUDCMT.JUDCMTCD NOT IN (SELECT FREEFIELD1 FROM FREE     " & vbLf
    strStmt = strStmt & "                                                        WHERE FREECD LIKE 'METACMT%' ) " & vbLf
'### 2008/4/14 張 メタボリックシンドロームコメントは別として総合コメント有無チェック End   ###
    
    strStmt = strStmt & "                      AND TOTALJUDCMT.DISPMODE = :DISPMODE    )    " & vbLf
'### 2004/2/12 Updated End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objJudCmtCd = objFields("JUDCMTCD")
'### 2008/4/14 張 メタボリックシンドロームコメント以外に登録された総合コメントがなければ良好コメント登録 Start ###
        Set objMaxSeq = objFields("MAXSEQ")
'### 2008/4/14 張 メタボリックシンドロームコメント以外に登録された総合コメントがなければ良好コメント登録 End   ###
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrDispMode(lngCount)
            ReDim Preserve vntArrMaxSeq(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrDispMode(lngCount) = TOTALCMT_DISPMODE
'### 2008/4/14 張 メタボリックシンドロームコメント以外に登録された総合コメントがなければ良好コメント登録 Start ###
'            vntArrMaxSeq(lngCount) = 1
            vntArrMaxSeq(lngCount) = objMaxSeq + 1
'### 2008/4/14 張 メタボリックシンドロームコメント以外に登録された総合コメントがなければ良好コメント登録 End   ###
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop

        UpdateGoodCmt = InsertTotalJudCmt(vntArrRsvNo, vntArrDispMode, vntArrMaxSeq, vntArrJudCmtCd)
    Else
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    UpdateGoodCmt = True
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.UpdateGoodCmt"
    
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
'### 聖路加対応　追加 2003.12.12
'
' 機能　　 : 総合コメントを新規に追加する
'
' 引数　　 : (In)     vntRsvNo           予約番号
' 　　　　   (In)     vntDispMode        表示モード
' 　　　　   (In)     vntMaxSeq          当該予約番号、表示モードの最大Ｓｅｑ
'### 2004.01.15 連続してこの関数を呼ぶと破綻をきたしてしまったので引数のMAXSeqは使いません K.Fujii
' 　　　　   (In)     vntJudCmtCd        判定コメントコード
'
' 戻り値　 : True = 正常終了
' 　　　　 : False = 異常終了
'
' 備考　　 :
'
Public Function InsertTotalJudCmt( _
    ByRef vntRsvNo As Variant, _
    ByRef vntDispMode As Variant, _
    ByRef vntMaxSeq As Variant, _
    ByRef vntJudCmtCd As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
'### 2004.01.15 add start MAXSEQ 取得用
    Dim objOraDyna          As OraDynaset       'ダイナセット
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objMaxSeq           As OraField         'Seq最大値
    Dim lngMaxSeq           As Long             'Seq最大値
'### 2004.01.15 add end MAXSEQ 取得用
    
    Dim objUpdRsvNo         As OraParamArray    '予約番号
    Dim objUpdDispMode      As OraParamArray    '表示分類
    Dim objUpdSeq           As OraParamArray    '表示順
    Dim objUpdJudCmtCd      As OraParamArray    '判定コメントコード
    
    Dim lngArraySize        As Long             '更新レコード配列数
    
    Dim lngBakRsvNo         As Long             '予約番号（退避用）
'### 2004.01.15 add start MAXSEQ 取得用
    Dim lngBakDispMode      As Long             '表示分類（退避用）
'### 2004.01.15 add end MAXSEQ 取得用
    
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    lngArraySize = UBound(vntRsvNo) + 1
        
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.AddTable "UPDRSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_TOTALJUDCMT_RSVNO
    objOraParam.AddTable "UPDDISPMODE", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_TOTALJUDCMT_DISPMODE
    objOraParam.AddTable "UPDSEQ", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_TOTALJUDCMT_SEQ
    objOraParam.AddTable "UPDJUDCMTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_TOTALJUDCMT_JUDCMTCD
        
    
    'OraParameterオブジェクトの参照設定
    Set objUpdRsvNo = objOraParam("UPDRSVNO")
    Set objUpdDispMode = objOraParam("UPDDISPMODE")
    Set objUpdSeq = objOraParam("UPDSEQ")
    Set objUpdJudCmtCd = objOraParam("UPDJUDCMTCD")
        
    lngBakRsvNo = 0
    lngBakDispMode = 0
    'OraParameterオブジェクトの値設定
    For i = 0 To lngArraySize - 1
        objUpdRsvNo(i) = vntRsvNo(i)
        objUpdDispMode(i) = vntDispMode(i)
        '### 2004.01.15 Mod　1Line by K.Fujii 違うDISPMODEが渡ってくることは無いが念のため
'        If lngBakRsvNo <> vntRsvNo(i) Then
        If lngBakRsvNo <> vntRsvNo(i) Or lngBakDispMode <> vntDispMode(i) Then
            j = 1
            lngBakRsvNo = vntRsvNo(i)
            lngBakDispMode = vntDispMode(i)
            '### 2004.01.15 add start  by K.Fujii 引数で渡ってきたＭＡＸＳｅｑは使わない
            objOraParam.Add "SRCRSVNO", vntRsvNo(i), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "SRCDISPMODE", vntDispMode(i), ORAPARM_INPUT, ORATYPE_NUMBER
            strStmt = "SELECT NVL(MAX(SEQ), 0) MAXSEQ " & vbLf & _
                      "  FROM TOTALJUDCMT             " & vbLf & _
                      " WHERE RSVNO    = :SRCRSVNO    " & vbLf & _
                      "   AND DISPMODE = :SRCDISPMODE "
                          
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    
            '検索レコードが存在する場合
            If Not objOraDyna.EOF Then
                'オブジェクトの参照設定
                Set objFields = objOraDyna.Fields
                Set objMaxSeq = objFields("MAXSEQ")
                            
                lngMaxSeq = objMaxSeq.Value
            
            Else
                lngMaxSeq = 0
            End If
            objOraParam.Remove "SRCRSVNO"
            objOraParam.Remove "SRCDISPMODE"
            '### 2004.01.15 add start  by K.Fujii 引数で渡ってきたＭＡＸＳｅｑは使わない
        Else
            j = j + 1
        End If
        '### 2004.01.15 Mod 1Line  by K.Fujii 引数で渡ってきたＭＡＸＳｅｑは使わない
'        objUpdSeq(i) = vntMaxSeq(i) + j
        objUpdSeq(i) = lngMaxSeq + j
        objUpdJudCmtCd(i) = vntJudCmtCd(i)
    
    Next i
        
    '総合コメント更新
    strStmt = "INSERT INTO TOTALJUDCMT  " & vbLf & _
              "VALUES (                 " & vbLf & _
              "  :UPDRSVNO,             " & vbLf & _
              "  :UPDDISPMODE,          " & vbLf & _
              "  :UPDSEQ,               " & vbLf & _
              "  :UPDJUDCMTCD )         "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertTotalJudCmt = True
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Judgement.InsertTotalJudCmt"
    
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
