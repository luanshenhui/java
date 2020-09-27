VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "FolRenkei"
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
' 機能　　 : 指定の病名ＳＭＩＬＥ情報を挿入する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     strKa                 診療科
' 　　　　   (In)     dtmBg_YMD             病名発症日
' 　　　　   (In)     strFlg_1              主病名フラグ
' 　　　　   (In)     strFlg_2              疑いフラグ
' 　　　　   (In)     strTenki_Kbn          転帰区分
' 　　　　   (In)     dtmTenki_YMD          転帰日
' 　　　　   (In)     strBmei_Cd            病名コード
' 　　　　   (In)     strBmei_Basecd        病名基本コード
' 　　　　   (In)     lngBmei_Moji_Su       病名文字数
' 　　　　   (In)     strBmei               病名名称
' 　　　　   (In)     strBmei_Eiji          病名名称英字
' 　　　　   (In)     strSbmei_Cd_1         修飾語コード１
' 　　　　   (In)     lngSbmei_Moji_Su_1    修飾語文字数１
' 　　　　   (In)     strSbmei_1            修飾語名称１
' 　　　　   (In)     strSbmei_Eiji_1       修飾語名称英字１
' 　　　　   (In)     strSbmei_Cd_2         修飾語コード２
' 　　　　   (In)     lngSbmei_Moji_Su_2    修飾語文字数２
' 　　　　   (In)     strSbmei_2            修飾語名称２
' 　　　　   (In)     strSbmei_Eiji_2       修飾語名称英字２
' 　　　　   (In)     strSbmei_Cd_3         修飾語コード３
' 　　　　   (In)     lngSbmei_Moji_Su_3    修飾語文字数３
' 　　　　   (In)     strSbmei_3            修飾語名称３
' 　　　　   (In)     strSbmei_Eiji_3       修飾語名称英字３
' 　　　　   (In)     strSbmei_Cd_4         修飾語コード４
' 　　　　   (In)     lngSbmei_Moji_Su_4    修飾語文字数４
' 　　　　   (In)     strSbmei_4            修飾語名称４
' 　　　　   (In)     strSbmei_Eiji_4       修飾語名称英字４
' 　　　　   (In)     strSbmei_Cd_5         修飾語コード５
' 　　　　   (In)     lngSbmei_Moji_Su_5    修飾語文字数５
' 　　　　   (In)     strSbmei_5            修飾語名称５
' 　　　　   (In)     strSbmei_Eiji_5       修飾語名称英字５
' 　　　　   (In)     dtmOp_Date_YMD        更新日
' 　　　　   (In)     strUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function InsertDisease_New( _
    ByVal strPerId As String, ByVal strKa As String, _
    ByVal dtmBg_YMD As Date, ByVal strFlg_1 As String, _
    ByVal strFlg_2 As String, ByVal strTenki_Kbn As String, _
    ByVal dtmTenki_YMD As Date, ByVal strBmei_Cd As String, _
    ByVal strBmei_Basecd As String, ByVal lngBmei_Moji_Su As Long, _
    ByVal strBmei As String, ByVal strBmei_Eiji As String, _
    ByVal strSbmei_Cd_1 As String, ByVal lngSbmei_Moji_Su_1 As Long, _
    ByVal strSbmei_1 As String, ByVal strSbmei_Eiji_1 As String, _
    ByVal strSbmei_Cd_2 As String, ByVal lngSbmei_Moji_Su_2 As Long, _
    ByVal strSbmei_2 As String, ByVal strSbmei_Eiji_2 As String, _
    ByVal strSbmei_Cd_3 As String, ByVal lngSbmei_Moji_Su_3 As Long, _
    ByVal strSbmei_3 As String, ByVal strSbmei_Eiji_3 As String, _
    ByVal strSbmei_Cd_4 As String, ByVal lngSbmei_Moji_Su_4 As Long, _
    ByVal strSbmei_4 As String, ByVal strSbmei_Eiji_4 As String, _
    ByVal strSbmei_Cd_5 As String, ByVal lngSbmei_Moji_Su_5 As Long, _
    ByVal strSbmei_5 As String, ByVal strSbmei_Eiji_5 As String, _
    ByVal dtmOp_Date_YMD As Date, ByVal strUpdUser As String _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim Ret                     As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    InsertDisease_New = INSERT_ERROR

    Ret = INSERT_ERROR

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "KA", strKa, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BG_YMD", IIf(dtmBg_YMD > 0, dtmBg_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "FLG_1", strFlg_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FLG_2", strFlg_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TENKI_KBN", strTenki_Kbn, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TENKI_YMD", IIf(dtmTenki_YMD > 0, dtmTenki_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BMEI_CD", strBmei_Cd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BMEI_BASECD", strBmei_Basecd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BMEI_MOJI_SU", lngBmei_Moji_Su, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BMEI", strBmei, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BMEI_EIJI", strBmei_Eiji, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_1", strSbmei_Cd_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_1", lngSbmei_Moji_Su_1, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_1", strSbmei_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_1", strSbmei_Eiji_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_2", strSbmei_Cd_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_2", lngSbmei_Moji_Su_2, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_2", strSbmei_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_2", strSbmei_Eiji_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_3", strSbmei_Cd_3, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_3", lngSbmei_Moji_Su_3, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_3", strSbmei_3, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_3", strSbmei_Eiji_3, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_4", strSbmei_Cd_4, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_4", lngSbmei_Moji_Su_4, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_4", strSbmei_4, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_4", strSbmei_Eiji_4, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_5", strSbmei_Cd_5, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_5", lngSbmei_Moji_Su_5, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_5", strSbmei_5, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_5", strSbmei_Eiji_5, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OP_DATE_YMD", IIf(dtmOp_Date_YMD > 0, dtmOp_Date_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす病名ＳＭＩＬＥテーブルのレコードを挿入
    strStmt = "INSERT INTO DISEASE_NEW (                                            " & vbLf & _
              "        PERID,        KA,               BG_YMD,     FLG_1,           " & vbLf & _
              "        FLG_2,        TENKI_KBN,        TENKI_YMD,  BMEI_CD,         " & vbLf & _
              "        BMEI_BASECD,  BMEI_MOJI_SU,     BMEI,       BMEI_EIJI,       " & vbLf & _
              "        SBMEI_CD_1,   SBMEI_MOJI_SU_1,  SBMEI_1,    SBMEI_EIJI_1,    " & vbLf & _
              "        SBMEI_CD_2,   SBMEI_MOJI_SU_2,  SBMEI_2,    SBMEI_EIJI_2,    " & vbLf & _
              "        SBMEI_CD_3,   SBMEI_MOJI_SU_3,  SBMEI_3,    SBMEI_EIJI_3,    " & vbLf & _
              "        SBMEI_CD_4,   SBMEI_MOJI_SU_4,  SBMEI_4,    SBMEI_EIJI_4,    " & vbLf & _
              "        SBMEI_CD_5,   SBMEI_MOJI_SU_5,  SBMEI_5,    SBMEI_EIJI_5,    " & vbLf & _
              "        OP_DATE_YMD,  UPDUSER,          UPDDATE)                     " & vbLf & _
              "VALUES(:PERID,       :KA,              :BG_YMD,    :FLG_1,           " & vbLf & _
              "       :FLG_2,       :TENKI_KBN,       :TENKI_YMD, :BMEI_CD,         " & vbLf & _
              "       :BMEI_BASECD, :BMEI_MOJI_SU,    :BMEI,      :BMEI_EIJI,       " & vbLf & _
              "       :SBMEI_CD_1,  :SBMEI_MOJI_SU_1, :SBMEI_1,   :SBMEI_EIJI_1,    " & vbLf & _
              "       :SBMEI_CD_2,  :SBMEI_MOJI_SU_2, :SBMEI_2,   :SBMEI_EIJI_2,    " & vbLf & _
              "       :SBMEI_CD_3,  :SBMEI_MOJI_SU_3, :SBMEI_3,   :SBMEI_EIJI_3,    " & vbLf & _
              "       :SBMEI_CD_4,  :SBMEI_MOJI_SU_4, :SBMEI_4,   :SBMEI_EIJI_4,    " & vbLf & _
              "       :SBMEI_CD_5,  :SBMEI_MOJI_SU_5, :SBMEI_5,   :SBMEI_EIJI_5,    " & vbLf & _
              "       :OP_DATE_YMD, :UPDUSER,          SYSDATE)                     " & vbLf

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    Ret = INSERT_NORMAL

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    InsertDisease_New = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsFolRenkei.InsertDisease_New"

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
' 機能　　 : 指定の入院歴ＳＭＩＬＥ情報を挿入する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     dtmNow_Date           入院日（転入日）
' 　　　　   (In)     strNow_Ka             診療科コード
' 　　　　   (In)     dtmTaiin_Date         退院日（転出日）
' 　　　　   (In)     strTenki              転帰
' 　　　　   (In)     strOpe_Flg            手術有無
' 　　　　   (In)     strDeath_Flg          死亡フラグ
' 　　　　   (In)     strUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function InsertInPatient_New( _
    ByVal strPerId As String, ByVal dtmNow_Date As Date, _
    ByVal strNow_Ka As String, ByVal dtmTaiin_Date As Date, _
    ByVal strTenki As String, ByVal strOpe_Flg As String, _
    ByVal strDeath_Flg As String, ByVal strUpdUser As String _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim Ret                     As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    InsertInPatient_New = INSERT_ERROR

    Ret = INSERT_ERROR

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOW_DATE", IIf(dtmNow_Date > 0, dtmNow_Date, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "NOW_KA", strNow_Ka, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TAIIN_DATE", IIf(dtmTaiin_Date > 0, dtmTaiin_Date, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "TENKI", strTenki, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPE_FLG", strOpe_Flg, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DEATH_FLG", strDeath_Flg, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす入院歴ＳＭＩＬＥテーブルのレコードを挿入
    strStmt = "INSERT INTO INPATIENT_NEW (                                " & vbLf & _
              "         PERID,  NOW_DATE,  NOW_KA,     TAIIN_DATE,      " & vbLf & _
              "         TENKI,  OPE_FLG,   DEATH_FLG,  UPDUSER,         " & vbLf & _
              "         UPDDATE)                                        " & vbLf & _
              "VALUES (:PERID, :NOW_DATE, :NOW_KA,    :TAIIN_DATE,      " & vbLf & _
              "        :TENKI, :OPE_FLG,  :DEATH_FLG, :UPDUSER,         " & vbLf & _
              "        SYSDATE)                                         " & vbLf

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    Ret = INSERT_NORMAL

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    InsertInPatient_New = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsFolRenkei.InsertInPatient_New"

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
' 機能　　 : 指定の外来受診歴ＳＭＩＬＥ情報を挿入する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     dtmUke_YMD            受付日
' 　　　　   (In)     strUke_Ka             受付診療科
' 　　　　   (In)     strUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function InsertOutPatient_New( _
    ByVal strPerId As String, ByVal dtmUke_YMD As Date, _
    ByVal strUke_Ka As String, ByVal strUpdUser As String _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim Ret                     As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    InsertOutPatient_New = -1

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UKE_YMD", IIf(dtmUke_YMD > 0, dtmUke_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UKE_KA", strUke_Ka, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす外来受診歴ＳＭＩＬＥテーブルのレコードを挿入
    strStmt = "INSERT INTO OUTPATIENT_NEW (                             " & vbLf & _
              "       PERID, UKE_YMD, UKE_KA, UPDUSER, UPDDATE)         " & vbLf & _
              "VALUES (:PERID, :UKE_YMD, :UKE_KA, :UPDUSER, SYSDATE)    " & vbLf

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    Ret = INSERT_NORMAL

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    InsertOutPatient_New = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsFolRenkei.InsertOutPatient_New"

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
' 機能　　 : 指定個人IDの受診情報件数を取得する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult( _
    ByVal strPerId As String _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim lngCount                As Long

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCount                As Object           '受診件数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectConsult = -1

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす受診情報テーブルのレコードを取得
    strStmt = "SELECT COUNT(*) FROM CONSULT                         " & vbLf & _
              " WHERE PERID       = :PERID                          " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        lngCount = objOraDyna.Fields(0).Value

        SelectConsult = lngCount

    Else
        SelectConsult = 0 '件数なし

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
    WriteErrorLog "HainsFolRenkei.SelectConsult"

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
' 機能　　 : 指定検索条件の病歴を取得する。
'
'
' 引数　　 : (In)     lngRsvNo              検索条件：予約番号
' 　　　　   (Out)    vntInDate             入院日
' 　　　　   (Out)    vntDisName            病名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectDiseaseHistory( _
        ByVal lngRsvNo As Long, _
        ByRef vntInDate As Variant, _
        ByRef vntDisName As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objInDate             As OraField     '入院日
    Dim objDisName            As OraField     '病名

    Dim vntArrInDate()        As Variant     '入院日の配列
    Dim vntArrDisName()       As Variant     '病名の配列
    
    Dim lngCount              As Long           'レコード数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntInDate) Then vntInDate = Empty
    If Not IsMissing(vntDisName) Then vntDisName = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT DISEASE_NEW.BG_YMD INDATE,                                         " & vbLf & _
              "       DISEASE_NEW.BMEI DISNAME                                           " & vbLf & _
              "  FROM DISEASE_NEW                                                        " & vbLf & _
              " WHERE DISEASE_NEW.PERID = (SELECT PERID FROM CONSULT WHERE RSVNO = :RSVNO) " & vbLf & _
              " ORDER BY DISEASE_NEW.BG_YMD DESC "

    'データ取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objInDate = objFields("INDATE")
        Set objDisName = objFields("DISNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrInDate(lngCount)
            ReDim Preserve vntArrDisName(lngCount)
            
            vntArrInDate(lngCount) = objInDate.Value & ""
            vntArrDisName(lngCount) = objDisName.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectDiseaseHistory = lngCount
    
    '戻り値の設定
    If Not IsMissing(vntInDate) Then vntInDate = vntArrInDate
    If Not IsMissing(vntDisName) Then vntDisName = vntArrDisName
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectDiseaseHistory = -1
    
    'イベントログ書き込み
    WriteErrorLog "Interview.SelectDiseaseHistory"
    
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
' 機能　　 : 指定検索条件の入院・外来歴を取得する。
'
'
' 引数　　 : (In)     lngRsvNo              検索条件：予約番号
' 　　　　   (Out)    vntKbn                入外区分（1:外来、2:入院）
' 　　　　   (Out)    vntCslDate            来院日
' 　　　　   (Out)    vntDeptName           科名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectPatientHistory( _
        ByVal lngRsvNo As Long, _
        ByRef vntKbn As Variant, _
        ByRef vntCslDate As Variant, _
        ByRef vntDeptName As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objKbn                As OraField     '入外区分
    Dim objCslDate            As OraField     '来院日
    Dim objDeptName           As OraField     '科名

    Dim vntArrKbn()           As Variant     '入外区分の配列
    Dim vntArrCslDate()       As Variant     '来院日の配列
    Dim vntArrDeptName()      As Variant     '科名の配列
    
    Dim lngCount              As Long           'レコード数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntKbn) Then vntKbn = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntDeptName) Then vntDeptName = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT PATIENTVIEW.KBN,                           " & vbLf & _
              "       PATIENTVIEW.CSLDATE, PATIENTVIEW.DEPTNAME  " & vbLf & _
              "  FROM (                                          "
    '外来歴
    strStmt = strStmt & vbLf & _
             "       (SELECT 1 KBN,                                                                   " & vbLf & _
              "            OUTPATIENT_NEW.UKE_YMD CSLDATE,                                            " & vbLf & _
              "               NVL( SMILEDEPT.DEPTNAME, OUTPATIENT_NEW.UKE_KA) DEPTNAME                " & vbLf & _
              "          FROM OUTPATIENT_NEW, SMILEDEPT                                               " & vbLf & _
              "         WHERE OUTPATIENT_NEW.PERID = (SELECT PERID FROM CONSULT WHERE RSVNO = :RSVNO) " & vbLf & _
              "           AND SMILEDEPT.DEPTCD(+) = OUTPATIENT_NEW.UKE_KA                             " & vbLf & _
              "    ) UNION                                                                            "
    '入院歴
    strStmt = strStmt & vbLf & _
              "    (SELECT 2 KBN,                                                                     " & vbLf & _
              "            INPATIENT_NEW.NOW_DATE CSLDATE,                                            " & vbLf & _
              "               NVL( SMILEDEPT.DEPTNAME, INPATIENT_NEW.NOW_KA) DEPTNAME                 " & vbLf & _
              "       FROM INPATIENT_NEW,  SMILEDEPT                                                  " & vbLf & _
              "         WHERE INPATIENT_NEW.PERID = (SELECT PERID FROM CONSULT WHERE RSVNO = :RSVNO)  " & vbLf & _
              "           AND SMILEDEPT.DEPTCD(+) = INPATIENT_NEW.NOW_KA                              " & vbLf & _
              "       )                                                                               " & vbLf & _
              "       ) PATIENTVIEW                                                                   "
    '新しい順
    strStmt = strStmt & vbLf & _
              " ORDER BY PATIENTVIEW.CSLDATE DESC "
       
    'データ取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objKbn = objFields("KBN")
        Set objCslDate = objFields("CSLDATE")
        Set objDeptName = objFields("DEPTNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrKbn(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDeptName(lngCount)
            
            vntArrKbn(lngCount) = objKbn.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrDeptName(lngCount) = objDeptName.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectPatientHistory = lngCount
    
    '戻り値の設定
    If Not IsMissing(vntKbn) Then vntKbn = vntArrKbn
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntDeptName) Then vntDeptName = vntArrDeptName
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPatientHistory = -1

    'イベントログ書き込み
    WriteErrorLog "HainsFolRenkei.SelectPatientHistory"

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
' 機能　　 : 指定の病名ＳＭＩＬＥ情報を取得する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     strKa                 診療科
' 　　　　   (In)     strBmei_Cd            病名コード
' 　　　　   (In)     dtmOp_Date_YMD        更新日
' 　　　　   (Out)    vntPerId              患者ＩＤ
' 　　　　   (Out)    vntKa                 診療科
' 　　　　   (Out)    vntBg_YMD             病名発症日
' 　　　　   (Out)    vntFlg_1              主病名フラグ
' 　　　　   (Out)    vntFlg_2              疑いフラグ
' 　　　　   (Out)    vntTenki_Kbn          転帰区分
' 　　　　   (Out)    vntTenki_YMD          転帰日
' 　　　　   (Out)    vntBmei_Cd            病名コード
' 　　　　   (Out)    vntBmei_Basecd        病名基本コード
' 　　　　   (Out)    vntBmei_Moji_Su       病名文字数
' 　　　　   (Out)    vntBmei               病名名称
' 　　　　   (Out)    vntBmei_Eiji          病名名称英字
' 　　　　   (Out)    vntSbmei_Cd_1         修飾語コード１
' 　　　　   (Out)    vntSbmei_Moji_Su_1    修飾語文字数１
' 　　　　   (Out)    vntSbmei_1            修飾語名称１
' 　　　　   (Out)    vntSbmei_Eiji_1       修飾語名称英字１
' 　　　　   (Out)    vntSbmei_Cd_2         修飾語コード２
' 　　　　   (Out)    vntSbmei_Moji_Su_2    修飾語文字数２
' 　　　　   (Out)    vntSbmei_2            修飾語名称２
' 　　　　   (Out)    vntSbmei_Eiji_2       修飾語名称英字２
' 　　　　   (Out)    vntSbmei_Cd_3         修飾語コード３
' 　　　　   (Out)    vntSbmei_Moji_Su_3    修飾語文字数３
' 　　　　   (Out)    vntSbmei_3            修飾語名称３
' 　　　　   (Out)    vntSbmei_Eiji_3       修飾語名称英字３
' 　　　　   (Out)    vntSbmei_Cd_4         修飾語コード４
' 　　　　   (Out)    vntSbmei_Moji_Su_4    修飾語文字数４
' 　　　　   (Out)    vntSbmei_4            修飾語名称４
' 　　　　   (Out)    vntSbmei_Eiji_4       修飾語名称英字４
' 　　　　   (Out)    vntSbmei_Cd_5         修飾語コード５
' 　　　　   (Out)    vntSbmei_Moji_Su_5    修飾語文字数５
' 　　　　   (Out)    vntSbmei_5            修飾語名称５
' 　　　　   (Out)    vntSbmei_Eiji_5       修飾語名称英字５
' 　　　　   (Out)    vntOp_Date_YMD        更新日
' 　　　　   (Out)    vntUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function SelectDisease_New( _
    ByVal strPerId As String, ByVal strKa As String, _
    ByVal strBmei_Cd As String, ByVal dtmOp_Date_YMD As Date, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntKa As Variant, _
    Optional ByRef vntBg_YMD As Variant, Optional ByRef vntFlg_1 As Variant, _
    Optional ByRef vntFlg_2 As Variant, Optional ByRef vntTenki_Kbn As Variant, _
    Optional ByRef vntTenki_YMD As Variant, Optional ByRef vntBmei_Cd As Variant, _
    Optional ByRef vntBmei_Basecd As Variant, Optional ByRef vntBmei_Moji_Su As Variant, _
    Optional ByRef vntBmei As Variant, Optional ByRef vntBmei_Eiji As Variant, _
    Optional ByRef vntSbmei_Cd_1 As Variant, Optional ByRef vntSbmei_Moji_Su_1 As Variant, _
    Optional ByRef vntSbmei_1 As Variant, Optional ByRef vntSbmei_Eiji_1 As Variant, _
    Optional ByRef vntSbmei_Cd_2 As Variant, Optional ByRef vntSbmei_Moji_Su_2 As Variant, _
    Optional ByRef vntSbmei_2 As Variant, Optional ByRef vntSbmei_Eiji_2 As Variant, _
    Optional ByRef vntSbmei_Cd_3 As Variant, Optional ByRef vntSbmei_Moji_Su_3 As Variant, _
    Optional ByRef vntSbmei_3 As Variant, Optional ByRef vntSbmei_Eiji_3 As Variant, _
    Optional ByRef vntSbmei_Cd_4 As Variant, Optional ByRef vntSbmei_Moji_Su_4 As Variant, _
    Optional ByRef vntSbmei_4 As Variant, Optional ByRef vntSbmei_Eiji_4 As Variant, _
    Optional ByRef vntSbmei_Cd_5 As Variant, Optional ByRef vntSbmei_Moji_Su_5 As Variant, _
    Optional ByRef vntSbmei_5 As Variant, Optional ByRef vntSbmei_Eiji_5 As Variant, _
    Optional ByRef vntOp_Date_YMD As Variant, Optional ByRef vntUpdUser As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim lngCount                As Long

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPerId                As Object           '患者ＩＤ
    Dim objKa                   As Object           '診療科
    Dim objBg_YMD               As Object           '病名発症日
    Dim objFlg_1                As Object           '主病名フラグ
    Dim objFlg_2                As Object           '疑いフラグ
    Dim objTenki_Kbn            As Object           '転帰区分
    Dim objTenki_YMD            As Object           '転帰日
    Dim objBmei_Cd              As Object           '病名コード
    Dim objBmei_Basecd          As Object           '病名基本コード
    Dim objBmei_Moji_Su         As Object           '病名文字数
    Dim objBmei                 As Object           '病名名称
    Dim objBmei_Eiji            As Object           '病名名称英字
    Dim objSbmei_Cd_1           As Object           '修飾語コード１
    Dim objSbmei_Moji_Su_1      As Object           '修飾語文字数１
    Dim objSbmei_1              As Object           '修飾語名称１
    Dim objSbmei_Eiji_1         As Object           '修飾語名称英字１
    Dim objSbmei_Cd_2           As Object           '修飾語コード２
    Dim objSbmei_Moji_Su_2      As Object           '修飾語文字数２
    Dim objSbmei_2              As Object           '修飾語名称２
    Dim objSbmei_Eiji_2         As Object           '修飾語名称英字２
    Dim objSbmei_Cd_3           As Object           '修飾語コード３
    Dim objSbmei_Moji_Su_3      As Object           '修飾語文字数３
    Dim objSbmei_3              As Object           '修飾語名称３
    Dim objSbmei_Eiji_3         As Object           '修飾語名称英字３
    Dim objSbmei_Cd_4           As Object           '修飾語コード４
    Dim objSbmei_Moji_Su_4      As Object           '修飾語文字数４
    Dim objSbmei_4              As Object           '修飾語名称４
    Dim objSbmei_Eiji_4         As Object           '修飾語名称英字４
    Dim objSbmei_Cd_5           As Object           '修飾語コード５
    Dim objSbmei_Moji_Su_5      As Object           '修飾語文字数５
    Dim objSbmei_5              As Object           '修飾語名称５
    Dim objSbmei_Eiji_5         As Object           '修飾語名称英字５
    Dim objOp_Date_YMD          As Object           '更新日
    Dim objUpdUser              As Object           '更新者

    Dim vntArrPerId()           As Variant          '患者ＩＤ
    Dim vntArrKa()              As Variant          '診療科
    Dim vntArrBg_YMD()          As Variant          '病名発症日
    Dim vntArrFlg_1()           As Variant          '主病名フラグ
    Dim vntArrFlg_2()           As Variant          '疑いフラグ
    Dim vntArrTenki_Kbn()       As Variant          '転帰区分
    Dim vntArrTenki_YMD()       As Variant          '転帰日
    Dim vntArrBmei_Cd()         As Variant          '病名コード
    Dim vntArrBmei_Basecd()     As Variant          '病名基本コード
    Dim vntArrBmei_Moji_Su()    As Variant          '病名文字数
    Dim vntArrBmei()            As Variant          '病名名称
    Dim vntArrBmei_Eiji()       As Variant          '病名名称英字
    Dim vntArrSbmei_Cd_1()      As Variant          '修飾語コード１
    Dim vntArrSbmei_Moji_Su_1() As Variant          '修飾語文字数１
    Dim vntArrSbmei_1()         As Variant          '修飾語名称１
    Dim vntArrSbmei_Eiji_1()    As Variant          '修飾語名称英字１
    Dim vntArrSbmei_Cd_2()      As Variant          '修飾語コード１
    Dim vntArrSbmei_Moji_Su_2() As Variant          '修飾語文字数１
    Dim vntArrSbmei_2()         As Variant          '修飾語名称１
    Dim vntArrSbmei_Eiji_2()    As Variant          '修飾語名称英字１
    Dim vntArrSbmei_Cd_3()      As Variant          '修飾語コード１
    Dim vntArrSbmei_Moji_Su_3() As Variant          '修飾語文字数１
    Dim vntArrSbmei_3()         As Variant          '修飾語名称１
    Dim vntArrSbmei_Eiji_3()    As Variant          '修飾語名称英字１
    Dim vntArrSbmei_Cd_4()      As Variant          '修飾語コード１
    Dim vntArrSbmei_Moji_Su_4() As Variant          '修飾語文字数１
    Dim vntArrSbmei_4()         As Variant          '修飾語名称１
    Dim vntArrSbmei_Eiji_4()    As Variant          '修飾語名称英字１
    Dim vntArrSbmei_Cd_5()      As Variant          '修飾語コード１
    Dim vntArrSbmei_Moji_Su_5() As Variant          '修飾語文字数１
    Dim vntArrSbmei_5()         As Variant          '修飾語名称１
    Dim vntArrSbmei_Eiji_5()    As Variant          '修飾語名称英字１
    Dim vntArrOp_Date_YMD()     As Variant          '更新日
    Dim vntArrUpdUser()         As Variant          '更新者

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectDisease_New = -1

    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntKa) Then vntKa = Empty
    If Not IsMissing(vntBg_YMD) Then vntBg_YMD = Empty
    If Not IsMissing(vntFlg_1) Then vntFlg_1 = Empty
    If Not IsMissing(vntFlg_2) Then vntFlg_2 = Empty
    If Not IsMissing(vntTenki_Kbn) Then vntTenki_Kbn = Empty
    If Not IsMissing(vntTenki_YMD) Then vntTenki_YMD = Empty
    If Not IsMissing(vntBmei_Cd) Then vntBmei_Cd = Empty
    If Not IsMissing(vntBmei_Basecd) Then vntBmei_Basecd = Empty
    If Not IsMissing(vntBmei_Moji_Su) Then vntBmei_Moji_Su = Empty
    If Not IsMissing(vntBmei) Then vntBmei = Empty
    If Not IsMissing(vntBmei_Eiji) Then vntBmei_Eiji = Empty
    If Not IsMissing(vntBmei) Then vntBmei = Empty
    If Not IsMissing(vntSbmei_Cd_1) Then vntSbmei_Cd_1 = Empty
    If Not IsMissing(vntSbmei_Moji_Su_1) Then vntSbmei_Moji_Su_1 = Empty
    If Not IsMissing(vntSbmei_1) Then vntSbmei_1 = Empty
    If Not IsMissing(vntSbmei_Eiji_1) Then vntSbmei_Eiji_1 = Empty
    If Not IsMissing(vntSbmei_Cd_2) Then vntSbmei_Cd_2 = Empty
    If Not IsMissing(vntSbmei_Moji_Su_2) Then vntSbmei_Moji_Su_2 = Empty
    If Not IsMissing(vntSbmei_2) Then vntSbmei_2 = Empty
    If Not IsMissing(vntSbmei_Eiji_2) Then vntSbmei_Eiji_2 = Empty
    If Not IsMissing(vntSbmei_Cd_3) Then vntSbmei_Cd_3 = Empty
    If Not IsMissing(vntSbmei_Moji_Su_3) Then vntSbmei_Moji_Su_3 = Empty
    If Not IsMissing(vntSbmei_3) Then vntSbmei_3 = Empty
    If Not IsMissing(vntSbmei_Eiji_3) Then vntSbmei_Eiji_3 = Empty
    If Not IsMissing(vntSbmei_Cd_4) Then vntSbmei_Cd_4 = Empty
    If Not IsMissing(vntSbmei_Moji_Su_4) Then vntSbmei_Moji_Su_4 = Empty
    If Not IsMissing(vntSbmei_4) Then vntSbmei_4 = Empty
    If Not IsMissing(vntSbmei_Eiji_4) Then vntSbmei_Eiji_4 = Empty
    If Not IsMissing(vntSbmei_Cd_5) Then vntSbmei_Cd_5 = Empty
    If Not IsMissing(vntSbmei_Moji_Su_5) Then vntSbmei_Moji_Su_5 = Empty
    If Not IsMissing(vntSbmei_5) Then vntSbmei_5 = Empty
    If Not IsMissing(vntSbmei_Eiji_5) Then vntSbmei_Eiji_5 = Empty
    If Not IsMissing(vntOp_Date_YMD) Then vntOp_Date_YMD = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "KA", strKa, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BMEI_CD", strBmei_Cd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OP_DATE_YMD", IIf(dtmOp_Date_YMD > 0, dtmOp_Date_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE

    '検索条件を満たす病名ＳＭＩＬＥテーブルのレコードを取得
    strStmt = "SELECT PERID,       KA,              BG_YMD,    FLG_1,           " & vbLf & _
              "       FLG_2,       TENKI_KBN,       TENKI_YMD, BMEI_CD,         " & vbLf & _
              "       BMEI_BASECD, BMEI_MOJI_SU,    BMEI,      BMEI_EIJI,       " & vbLf & _
              "       SBMEI_CD_1,  SBMEI_MOJI_SU_1, SBMEI_1,   SBMEI_EIJI_1,    " & vbLf & _
              "       SBMEI_CD_2,  SBMEI_MOJI_SU_2, SBMEI_2,   SBMEI_EIJI_2,    " & vbLf & _
              "       SBMEI_CD_3,  SBMEI_MOJI_SU_3, SBMEI_3,   SBMEI_EIJI_3,    " & vbLf & _
              "       SBMEI_CD_4,  SBMEI_MOJI_SU_4, SBMEI_4,   SBMEI_EIJI_4,    " & vbLf & _
              "       SBMEI_CD_5,  SBMEI_MOJI_SU_5, SBMEI_5,   SBMEI_EIJI_5,    " & vbLf & _
              "       OP_DATE_YMD, UPDUSER                                      " & vbLf & _
              "  FROM DISEASE_NEW                                               " & vbLf & _
              " WHERE PERID       = :PERID                                      " & vbLf & _
              "   AND KA          = :KA                                         " & vbLf & _
              "   AND BMEI_CD     = :BMEI_CD                                    " & vbLf & _
              "   AND OP_DATE_YMD = :OP_DATE_YMD                                " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objKa = objFields("KA")
        Set objBg_YMD = objFields("BG_YMD")
        Set objFlg_1 = objFields("FLG_1")
        Set objFlg_2 = objFields("FLG_2")
        Set objTenki_Kbn = objFields("TENKI_KBN")
        Set objTenki_YMD = objFields("TENKI_YMD")
        Set objBmei_Cd = objFields("BMEI_CD")
        Set objBmei_Basecd = objFields("BMEI_BASECD")
        Set objBmei_Moji_Su = objFields("BMEI_MOJI_SU")
        Set objBmei = objFields("BMEI")
        Set objBmei_Eiji = objFields("BMEI_EIJI")
        Set objSbmei_Cd_1 = objFields("SBMEI_CD_1")
        Set objSbmei_Moji_Su_1 = objFields("SBMEI_MOJI_SU_1")
        Set objSbmei_1 = objFields("SBMEI_1")
        Set objSbmei_Eiji_1 = objFields("SBMEI_EIJI_1")
        Set objSbmei_Cd_2 = objFields("SBMEI_CD_2")
        Set objSbmei_Moji_Su_2 = objFields("SBMEI_MOJI_SU_2")
        Set objSbmei_2 = objFields("SBMEI_2")
        Set objSbmei_Eiji_2 = objFields("SBMEI_EIJI_2")
        Set objSbmei_Cd_3 = objFields("SBMEI_CD_3")
        Set objSbmei_Moji_Su_3 = objFields("SBMEI_MOJI_SU_3")
        Set objSbmei_3 = objFields("SBMEI_3")
        Set objSbmei_Eiji_3 = objFields("SBMEI_EIJI_3")
        Set objSbmei_Cd_4 = objFields("SBMEI_CD_4")
        Set objSbmei_Moji_Su_4 = objFields("SBMEI_MOJI_SU_4")
        Set objSbmei_4 = objFields("SBMEI_4")
        Set objSbmei_Eiji_4 = objFields("SBMEI_EIJI_4")
        Set objSbmei_Cd_5 = objFields("SBMEI_CD_5")
        Set objSbmei_Moji_Su_5 = objFields("SBMEI_MOJI_SU_5")
        Set objSbmei_5 = objFields("SBMEI_5")
        Set objSbmei_Eiji_5 = objFields("SBMEI_EIJI_5")
        Set objOp_Date_YMD = objFields("OP_DATE_YMD")
        Set objUpdUser = objFields("UPDUSER")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrKa(lngCount)
            ReDim Preserve vntArrBg_YMD(lngCount)
            ReDim Preserve vntArrFlg_1(lngCount)
            ReDim Preserve vntArrFlg_2(lngCount)
            ReDim Preserve vntArrTenki_Kbn(lngCount)
            ReDim Preserve vntArrTenki_YMD(lngCount)
            ReDim Preserve vntArrBmei_Cd(lngCount)
            ReDim Preserve vntArrBmei_Basecd(lngCount)
            ReDim Preserve vntArrBmei_Moji_Su(lngCount)
            ReDim Preserve vntArrBmei(lngCount)
            ReDim Preserve vntArrBmei_Eiji(lngCount)
            ReDim Preserve vntArrSbmei_Cd_1(lngCount)
            ReDim Preserve vntArrSbmei_Moji_Su_1(lngCount)
            ReDim Preserve vntArrSbmei_1(lngCount)
            ReDim Preserve vntArrSbmei_Eiji_1(lngCount)
            ReDim Preserve vntArrSbmei_Cd_2(lngCount)
            ReDim Preserve vntArrSbmei_Moji_Su_2(lngCount)
            ReDim Preserve vntArrSbmei_2(lngCount)
            ReDim Preserve vntArrSbmei_Eiji_2(lngCount)
            ReDim Preserve vntArrSbmei_Cd_3(lngCount)
            ReDim Preserve vntArrSbmei_Moji_Su_3(lngCount)
            ReDim Preserve vntArrSbmei_3(lngCount)
            ReDim Preserve vntArrSbmei_Eiji_3(lngCount)
            ReDim Preserve vntArrSbmei_Cd_4(lngCount)
            ReDim Preserve vntArrSbmei_Moji_Su_4(lngCount)
            ReDim Preserve vntArrSbmei_4(lngCount)
            ReDim Preserve vntArrSbmei_Eiji_4(lngCount)
            ReDim Preserve vntArrSbmei_Cd_5(lngCount)
            ReDim Preserve vntArrSbmei_Moji_Su_5(lngCount)
            ReDim Preserve vntArrSbmei_5(lngCount)
            ReDim Preserve vntArrSbmei_Eiji_5(lngCount)
            ReDim Preserve vntArrOp_Date_YMD(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)

            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrKa(lngCount) = objKa.Value & ""
            vntArrBg_YMD(lngCount) = objBg_YMD.Value & ""
            vntArrFlg_1(lngCount) = objFlg_1.Value & ""
            vntArrFlg_2(lngCount) = objFlg_2.Value & ""
            vntArrTenki_Kbn(lngCount) = objTenki_Kbn.Value & ""
            vntArrTenki_YMD(lngCount) = objTenki_YMD.Value & ""
            vntArrBmei_Cd(lngCount) = objBmei_Cd.Value & ""
            vntArrBmei_Basecd(lngCount) = objBmei_Basecd.Value & ""
            vntArrBmei_Moji_Su(lngCount) = objBmei_Moji_Su.Value & ""
            vntArrBmei(lngCount) = objBmei.Value & ""
            vntArrBmei_Eiji(lngCount) = objBmei_Eiji.Value & ""
            vntArrSbmei_Cd_1(lngCount) = objSbmei_Cd_1.Value & ""
            vntArrSbmei_Moji_Su_1(lngCount) = objSbmei_Moji_Su_1.Value & ""
            vntArrSbmei_1(lngCount) = objSbmei_1.Value & ""
            vntArrSbmei_Eiji_1(lngCount) = objSbmei_Eiji_1.Value & ""
            vntArrSbmei_Cd_2(lngCount) = objSbmei_Cd_2.Value & ""
            vntArrSbmei_Moji_Su_2(lngCount) = objSbmei_Moji_Su_2.Value & ""
            vntArrSbmei_2(lngCount) = objSbmei_2.Value & ""
            vntArrSbmei_Eiji_2(lngCount) = objSbmei_Eiji_2.Value & ""
            vntArrSbmei_Cd_3(lngCount) = objSbmei_Cd_3.Value & ""
            vntArrSbmei_Moji_Su_3(lngCount) = objSbmei_Moji_Su_3.Value & ""
            vntArrSbmei_3(lngCount) = objSbmei_3.Value & ""
            vntArrSbmei_Eiji_3(lngCount) = objSbmei_Eiji_3.Value & ""
            vntArrSbmei_Cd_4(lngCount) = objSbmei_Cd_4.Value & ""
            vntArrSbmei_Moji_Su_4(lngCount) = objSbmei_Moji_Su_4.Value & ""
            vntArrSbmei_4(lngCount) = objSbmei_4.Value & ""
            vntArrSbmei_Eiji_4(lngCount) = objSbmei_Eiji_4.Value & ""
            vntArrSbmei_Cd_5(lngCount) = objSbmei_Cd_5.Value & ""
            vntArrSbmei_Moji_Su_5(lngCount) = objSbmei_Moji_Su_5.Value & ""
            vntArrSbmei_5(lngCount) = objSbmei_5.Value & ""
            vntArrSbmei_Eiji_5(lngCount) = objSbmei_Eiji_5.Value & ""
            vntArrOp_Date_YMD(lngCount) = objOp_Date_YMD.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntKa) Then vntKa = vntArrKa
        If Not IsMissing(vntBg_YMD) Then vntBg_YMD = vntArrBg_YMD
        If Not IsMissing(vntFlg_1) Then vntFlg_1 = vntArrFlg_1
        If Not IsMissing(vntFlg_2) Then vntFlg_2 = vntArrFlg_2
        If Not IsMissing(vntTenki_Kbn) Then vntTenki_Kbn = vntArrTenki_Kbn
        If Not IsMissing(vntTenki_YMD) Then vntTenki_YMD = vntArrTenki_YMD
        If Not IsMissing(vntBmei_Cd) Then vntBmei_Cd = vntArrBmei_Cd
        If Not IsMissing(vntBmei_Basecd) Then vntBmei_Basecd = vntArrBmei_Basecd
        If Not IsMissing(vntBmei_Moji_Su) Then vntBmei_Moji_Su = vntArrBmei_Moji_Su
        If Not IsMissing(vntBmei) Then vntBmei = vntArrBmei
        If Not IsMissing(vntBmei_Eiji) Then vntBmei_Eiji = vntArrBmei_Eiji
        If Not IsMissing(vntSbmei_Cd_1) Then vntSbmei_Cd_1 = vntArrSbmei_Cd_1
        If Not IsMissing(vntSbmei_Moji_Su_1) Then vntSbmei_Moji_Su_1 = vntArrSbmei_Moji_Su_1
        If Not IsMissing(vntSbmei_1) Then vntSbmei_1 = vntArrSbmei_1
        If Not IsMissing(vntSbmei_Eiji_1) Then vntSbmei_Eiji_1 = vntArrSbmei_Eiji_1
        If Not IsMissing(vntSbmei_Cd_2) Then vntSbmei_Cd_2 = vntArrSbmei_Cd_2
        If Not IsMissing(vntSbmei_Moji_Su_2) Then vntSbmei_Moji_Su_2 = vntArrSbmei_Moji_Su_2
        If Not IsMissing(vntSbmei_2) Then vntSbmei_2 = vntArrSbmei_2
        If Not IsMissing(vntSbmei_Eiji_2) Then vntSbmei_Eiji_2 = vntArrSbmei_Eiji_3
        If Not IsMissing(vntSbmei_Cd_3) Then vntSbmei_Cd_3 = vntArrSbmei_Cd_3
        If Not IsMissing(vntSbmei_Moji_Su_3) Then vntSbmei_Moji_Su_3 = vntArrSbmei_Moji_Su_3
        If Not IsMissing(vntSbmei_3) Then vntSbmei_3 = vntArrSbmei_3
        If Not IsMissing(vntSbmei_Eiji_3) Then vntSbmei_Eiji_3 = vntArrSbmei_Eiji_3
        If Not IsMissing(vntSbmei_Cd_4) Then vntSbmei_Cd_4 = vntArrSbmei_Cd_4
        If Not IsMissing(vntSbmei_Moji_Su_4) Then vntSbmei_Moji_Su_4 = vntArrSbmei_Moji_Su_4
        If Not IsMissing(vntSbmei_4) Then vntSbmei_4 = vntArrSbmei_4
        If Not IsMissing(vntSbmei_Eiji_4) Then vntSbmei_Eiji_4 = vntArrSbmei_Eiji_4
        If Not IsMissing(vntSbmei_Cd_5) Then vntSbmei_Cd_5 = vntArrSbmei_Cd_5
        If Not IsMissing(vntSbmei_Moji_Su_5) Then vntSbmei_Moji_Su_5 = vntArrSbmei_Moji_Su_5
        If Not IsMissing(vntSbmei_5) Then vntSbmei_5 = vntArrSbmei_5
        If Not IsMissing(vntSbmei_Eiji_5) Then vntSbmei_Eiji_5 = vntArrSbmei_Eiji_5
        If Not IsMissing(vntOp_Date_YMD) Then vntOp_Date_YMD = vntArrOp_Date_YMD
        If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser

        SelectDisease_New = lngCount

    Else
        SelectDisease_New = 0 '件数なし

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
    WriteErrorLog "HainsFolRenkei.SelectDisease_New"

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
' 機能　　 : 指定の入院歴ＳＭＩＬＥ情報を取得する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     strNow_Ka             診療科コード
' 　　　　   (In)     dtmTaiin_Date         退院日（転出日）
' 　　　　   (Out)    vntPerId              患者ＩＤ
' 　　　　   (Out)    vntNow_Date           入院日（転入日）
' 　　　　   (Out)    vntNow_Ka             診療科コード
' 　　　　   (Out)    vntTaiin_Date         退院日（転出日）
' 　　　　   (Out)    vntTenki              転帰
' 　　　　   (Out)    vntOpe_Flg            手術有無
' 　　　　   (Out)    vntDeath_Flg          死亡フラグ
' 　　　　   (Out)    vntUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function SelectInPatient_New( _
    ByVal strPerId As String, ByVal strNow_Ka As String, _
    ByVal dtmTaiin_Date As Date, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntNow_Date As Variant, _
    Optional ByRef vntNow_Ka As Variant, Optional ByRef vntTaiin_Date As Variant, _
    Optional ByRef vntTenki As Variant, Optional ByRef vntOpe_Flg As Variant, _
    Optional ByRef vntDeath_Flg As Variant, Optional ByRef vntUpdUser As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim lngCount                As Long

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPerId                As Object           '患者ＩＤ
    Dim objNow_Date             As Object           '入院日（転入日）
    Dim objNow_Ka               As Object           '診療科コード
    Dim objTaiin_Date           As Object           '退院日（転出日）
    Dim objTenki                As Object           '転帰
    Dim objOpe_Flg              As Object           '手術有無
    Dim objDeath_Flg            As Object           '死亡フラグ
    Dim objUpdUser              As Object           '更新者

    Dim vntArrPerId()           As Variant          '患者ＩＤ
    Dim vntArrNow_Date()        As Variant          '入院日（転入日）
    Dim vntArrNow_Ka()          As Variant          '診療科コード
    Dim vntArrTaiin_Date()      As Variant          '退院日（転出日）
    Dim vntArrTenki()           As Variant          '転帰
    Dim vntArrOpe_Flg()         As Variant          '手術有無
    Dim vntArrDeath_Flg()       As Variant          '死亡フラグ
    Dim vntArrUpdUser()         As Variant          '更新者

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectInPatient_New = -1

    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntNow_Date) Then vntNow_Date = Empty
    If Not IsMissing(vntNow_Ka) Then vntNow_Ka = Empty
    If Not IsMissing(vntTaiin_Date) Then vntTaiin_Date = Empty
    If Not IsMissing(vntTenki) Then vntTenki = Empty
    If Not IsMissing(vntOpe_Flg) Then vntOpe_Flg = Empty
    If Not IsMissing(vntDeath_Flg) Then vntDeath_Flg = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOW_KA", strNow_Ka, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TAIIN_DATE", IIf(dtmTaiin_Date > 0, dtmTaiin_Date, Null), ORAPARM_INPUT, ORATYPE_DATE

    '検索条件を満たす入院歴ＳＭＩＬＥテーブルのレコードを取得
    strStmt = "SELECT PERID, NOW_DATE, NOW_KA,    TAIIN_DATE,       " & vbLf & _
              "       TENKI, OPE_FLG,  DEATH_FLG, UPDUSER           " & vbLf & _
              "  FROM INPATIENT_NEW                                 " & vbLf & _
              " WHERE PERID       = :PERID                          " & vbLf & _
              "   AND NOW_KA      = :NOW_KA                         " & vbLf & _
              "   AND TAIIN_DATE  = :TAIIN_DATE                     " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objNow_Date = objFields("NOW_DATE")
        Set objNow_Ka = objFields("NOW_KA")
        Set objTaiin_Date = objFields("TAIIN_DATE")
        Set objTenki = objFields("TENKI")
        Set objOpe_Flg = objFields("OPE_FLG")
        Set objDeath_Flg = objFields("DEATH_FLG")
        Set objUpdUser = objFields("UPDUSER")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrNow_Date(lngCount)
            ReDim Preserve vntArrNow_Ka(lngCount)
            ReDim Preserve vntArrTaiin_Date(lngCount)
            ReDim Preserve vntArrTenki(lngCount)
            ReDim Preserve vntArrOpe_Flg(lngCount)
            ReDim Preserve vntArrDeath_Flg(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)

            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrNow_Date(lngCount) = objNow_Date.Value & ""
            vntArrNow_Ka(lngCount) = objNow_Ka.Value & ""
            vntArrTaiin_Date(lngCount) = objTaiin_Date.Value & ""
            vntArrTenki(lngCount) = objTenki.Value & ""
            vntArrOpe_Flg(lngCount) = objOpe_Flg.Value & ""
            vntArrDeath_Flg(lngCount) = objDeath_Flg.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntNow_Date) Then vntNow_Date = vntArrNow_Date
        If Not IsMissing(vntNow_Ka) Then vntNow_Ka = vntArrNow_Ka
        If Not IsMissing(vntTaiin_Date) Then vntTaiin_Date = vntArrTaiin_Date
        If Not IsMissing(vntTenki) Then vntTenki = vntArrTenki
        If Not IsMissing(vntOpe_Flg) Then vntOpe_Flg = vntArrOpe_Flg
        If Not IsMissing(vntDeath_Flg) Then vntDeath_Flg = vntArrDeath_Flg
        If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser

        SelectInPatient_New = lngCount

    Else
        SelectInPatient_New = 0 '件数なし

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
    WriteErrorLog "HainsFolRenkei.SelectInPatient_New"

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
' 機能　　 : 指定の外来受診歴ＳＭＩＬＥ情報を取得する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     dtmUke_YMD            受付日
' 　　　　   (In)     strUke_Ka             受付診療科
' 　　　　   (Out)    vntPerId              患者ＩＤ
' 　　　　   (Out)    vntUke_YMD            受付日
' 　　　　   (Out)    vntUke_Ka             受付診療科
' 　　　　   (Out)    vntUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function SelectOutPatient_New( _
    ByVal strPerId As String, ByVal dtmUke_YMD As Date, _
    ByVal strUke_Ka As String, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntUke_YMD As Variant, _
    Optional ByRef vntUke_Ka As Variant, Optional ByRef vntUpdUser As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim lngCount                As Long

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPerId                As Object           '患者ＩＤ
    Dim objUke_YMD              As Object           '受付日
    Dim objUke_Ka               As Object           '受付診療科
    Dim objUpdUser              As Object           '更新者

    Dim vntArrPerId()           As Variant          '患者ＩＤ
    Dim vntArrUke_YMD()         As Variant          '受付日
    Dim vntArrUke_Ka()          As Variant          '受付診療科
    Dim vntArrUpdUser()         As Variant          '更新者

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectOutPatient_New = -1

    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntUke_YMD) Then vntUke_YMD = Empty
    If Not IsMissing(vntUke_Ka) Then vntUke_Ka = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UKE_YMD", IIf(dtmUke_YMD > 0, dtmUke_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UKE_KA", strUke_Ka, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす外来受診歴ＳＭＩＬＥテーブルのレコードを取得
    strStmt = "SELECT PERID, UKE_YMD, UKE_KA, UPDUSER       " & vbLf & _
              "  FROM OUTPATIENT_NEW                        " & vbLf & _
              " WHERE PERID   = :PERID                      " & vbLf & _
              "   AND UKE_YMD = :UKE_YMD                    " & vbLf & _
              "   AND UKE_KA  = :UKE_KA                     " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objUke_YMD = objFields("UKE_YMD")
        Set objUke_Ka = objFields("UKE_KA")
        Set objUpdUser = objFields("UPDUSER")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrUke_YMD(lngCount)
            ReDim Preserve vntArrUke_Ka(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)

            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrUke_YMD(lngCount) = objUke_YMD.Value & ""
            vntArrUke_Ka(lngCount) = objUke_Ka.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntUke_YMD) Then vntUke_YMD = vntArrUke_YMD
        If Not IsMissing(vntUke_Ka) Then vntUke_Ka = vntArrUke_Ka
        If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser

        SelectOutPatient_New = lngCount

    Else
        SelectOutPatient_New = 0 '件数なし

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
    WriteErrorLog "HainsFolRenkei.SelectOutPatient_New"

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
' 機能　　 : 指定の病名ＳＭＩＬＥ情報を更新する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     strKa                 診療科
' 　　　　   (In)     dtmBg_YMD             病名発症日
' 　　　　   (In)     strFlg_1              主病名フラグ
' 　　　　   (In)     strFlg_2              疑いフラグ
' 　　　　   (In)     strTenki_Kbn          転帰区分
' 　　　　   (In)     dtmTenki_YMD          転帰日
' 　　　　   (In)     strBmei_Cd            病名コード
' 　　　　   (In)     strBmei_Basecd        病名基本コード
' 　　　　   (In)     lngBmei_Moji_Su       病名文字数
' 　　　　   (In)     strBmei               病名名称
' 　　　　   (In)     strBmei_Eiji          病名名称英字
' 　　　　   (In)     strSbmei_Cd_1         修飾語コード１
' 　　　　   (In)     lngSbmei_Moji_Su_1    修飾語文字数１
' 　　　　   (In)     strSbmei_1            修飾語名称１
' 　　　　   (In)     strSbmei_Eiji_1       修飾語名称英字１
' 　　　　   (In)     strSbmei_Cd_2         修飾語コード２
' 　　　　   (In)     lngSbmei_Moji_Su_2    修飾語文字数２
' 　　　　   (In)     strSbmei_2            修飾語名称２
' 　　　　   (In)     strSbmei_Eiji_2       修飾語名称英字２
' 　　　　   (In)     strSbmei_Cd_3         修飾語コード３
' 　　　　   (In)     lngSbmei_Moji_Su_3    修飾語文字数３
' 　　　　   (In)     strSbmei_3            修飾語名称３
' 　　　　   (In)     strSbmei_Eiji_3       修飾語名称英字３
' 　　　　   (In)     strSbmei_Cd_4         修飾語コード４
' 　　　　   (In)     lngSbmei_Moji_Su_4    修飾語文字数４
' 　　　　   (In)     strSbmei_4            修飾語名称４
' 　　　　   (In)     strSbmei_Eiji_4       修飾語名称英字４
' 　　　　   (In)     strSbmei_Cd_5         修飾語コード５
' 　　　　   (In)     lngSbmei_Moji_Su_5    修飾語文字数５
' 　　　　   (In)     strSbmei_5            修飾語名称５
' 　　　　   (In)     strSbmei_Eiji_5       修飾語名称英字５
' 　　　　   (In)     dtmOp_Date_YMD        更新日
' 　　　　   (In)     strUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function UpdateDisease_New( _
    ByVal strPerId As String, ByVal strKa As String, _
    ByVal dtmBg_YMD As Date, ByVal strFlg_1 As String, _
    ByVal strFlg_2 As String, ByVal strTenki_Kbn As String, _
    ByVal dtmTenki_YMD As Date, ByVal strBmei_Cd As String, _
    ByVal strBmei_Basecd As String, ByVal lngBmei_Moji_Su As Long, _
    ByVal strBmei As String, ByVal strBmei_Eiji As String, _
    ByVal strSbmei_Cd_1 As String, ByVal lngSbmei_Moji_Su_1 As Long, _
    ByVal strSbmei_1 As String, ByVal strSbmei_Eiji_1 As String, _
    ByVal strSbmei_Cd_2 As String, ByVal lngSbmei_Moji_Su_2 As Long, _
    ByVal strSbmei_2 As String, ByVal strSbmei_Eiji_2 As String, _
    ByVal strSbmei_Cd_3 As String, ByVal lngSbmei_Moji_Su_3 As Long, _
    ByVal strSbmei_3 As String, ByVal strSbmei_Eiji_3 As String, _
    ByVal strSbmei_Cd_4 As String, ByVal lngSbmei_Moji_Su_4 As Long, _
    ByVal strSbmei_4 As String, ByVal strSbmei_Eiji_4 As String, _
    ByVal strSbmei_Cd_5 As String, ByVal lngSbmei_Moji_Su_5 As Long, _
    ByVal strSbmei_5 As String, ByVal strSbmei_Eiji_5 As String, _
    ByVal dtmOp_Date_YMD As Date, ByVal strUpdUser As String _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim Ret                     As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    UpdateDisease_New = INSERT_ERROR

    Ret = INSERT_ERROR

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "KA", strKa, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BG_YMD", IIf(dtmBg_YMD > 0, dtmBg_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "FLG_1", strFlg_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FLG_2", strFlg_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TENKI_KBN", strTenki_Kbn, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TENKI_YMD", IIf(dtmTenki_YMD > 0, dtmTenki_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BMEI_CD", strBmei_Cd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BMEI_BASECD", strBmei_Basecd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BMEI_MOJI_SU", lngBmei_Moji_Su, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BMEI", strBmei, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BMEI_EIJI", strBmei_Eiji, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_1", strSbmei_Cd_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_1", lngSbmei_Moji_Su_1, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_1", strSbmei_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_1", strSbmei_Eiji_1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_2", strSbmei_Cd_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_2", lngSbmei_Moji_Su_2, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_2", strSbmei_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_2", strSbmei_Eiji_2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_3", strSbmei_Cd_3, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_3", lngSbmei_Moji_Su_3, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_3", strSbmei_3, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_3", strSbmei_Eiji_3, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_4", strSbmei_Cd_4, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_4", lngSbmei_Moji_Su_4, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_4", strSbmei_4, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_4", strSbmei_Eiji_4, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_CD_5", strSbmei_Cd_5, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_MOJI_SU_5", lngSbmei_Moji_Su_5, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SBMEI_5", strSbmei_5, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SBMEI_EIJI_5", strSbmei_Eiji_5, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OP_DATE_YMD", IIf(dtmOp_Date_YMD > 0, dtmOp_Date_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす病名ＳＭＩＬＥテーブルのレコードを更新
    strStmt = "UPDATE DISEASE_NEW SET                                                   " & vbLf & _
              "        PERID       = :PERID,       KA              = :KA,               " & vbLf & _
              "        BG_YMD      = :BG_YMD,      FLG_1           = :FLG_1,            " & vbLf & _
              "        FLG_2       = :FLG_2,       TENKI_KBN       = :TENKI_KBN,        " & vbLf & _
              "        TENKI_YMD   = :TENKI_YMD,   BMEI_CD         = :BMEI_CD,          " & vbLf & _
              "        BMEI_BASECD = :BMEI_BASECD, BMEI_MOJI_SU    = :BMEI_MOJI_SU,     " & vbLf & _
              "        BMEI        = :BMEI,        BMEI_EIJI       = :BMEI_EIJI,        " & vbLf & _
              "        SBMEI_CD_1  = :SBMEI_CD_1,  SBMEI_MOJI_SU_1 = :SBMEI_MOJI_SU_1,  " & vbLf & _
              "        SBMEI_1     = :SBMEI_1,     SBMEI_EIJI_1    = :SBMEI_EIJI_1,     " & vbLf & _
              "        SBMEI_CD_2  = :SBMEI_CD_2,  SBMEI_MOJI_SU_2 = :SBMEI_MOJI_SU_2,  " & vbLf & _
              "        SBMEI_2     = :SBMEI_2,     SBMEI_EIJI_2    = :SBMEI_EIJI_2,     " & vbLf & _
              "        SBMEI_CD_3  = :SBMEI_CD_3,  SBMEI_MOJI_SU_3 = :SBMEI_MOJI_SU_3,  " & vbLf & _
              "        SBMEI_3     = :SBMEI_3,     SBMEI_EIJI_3    = :SBMEI_EIJI_3,     " & vbLf & _
              "        SBMEI_CD_4  = :SBMEI_CD_4,  SBMEI_MOJI_SU_4 = :SBMEI_MOJI_SU_4,  " & vbLf & _
              "        SBMEI_4     = :SBMEI_4,     SBMEI_EIJI_4    = :SBMEI_EIJI_4,     " & vbLf & _
              "        SBMEI_CD_5  = :SBMEI_CD_5,  SBMEI_MOJI_SU_5 = :SBMEI_MOJI_SU_5,  " & vbLf & _
              "        SBMEI_5     = :SBMEI_5,     SBMEI_EIJI_5    = :SBMEI_EIJI_5,     " & vbLf & _
              "        OP_DATE_YMD = :OP_DATE_YMD, UPDUSER         = :UPDUSER,          " & vbLf & _
              "        UPDDATE     =  SYSDATE                                           " & vbLf & _
              " WHERE  PERID       = :PERID                                             " & vbLf & _
              "   AND  KA          = :KA                                                " & vbLf & _
              "   AND  BMEI_CD     = :BMEI_CD                                           " & vbLf & _
              "   AND  OP_DATE_YMD = :OP_DATE_YMD                                       " & vbLf

    Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))

    If Ret > 0 Then
        Ret = INSERT_NORMAL
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    UpdateDisease_New = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsFolRenkei.UpdateDisease_New"

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
' 機能　　 : 指定の入院歴ＳＭＩＬＥ情報を更新する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     dtmNow_Date           入院日（転入日）
' 　　　　   (In)     strNow_Ka             診療科コード
' 　　　　   (In)     dtmTaiin_Date         退院日（転出日）
' 　　　　   (In)     strTenki              転帰
' 　　　　   (In)     strOpe_Flg            手術有無
' 　　　　   (In)     strDeath_Flg          死亡フラグ
' 　　　　   (In)     strUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function UpdateInPatient_New( _
    ByVal strPerId As String, ByVal dtmNow_Date As Date, _
    ByVal strNow_Ka As String, ByVal dtmTaiin_Date As Date, _
    ByVal strTenki As String, ByVal strOpe_Flg As String, _
    ByVal strDeath_Flg As String, ByVal strUpdUser As String _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim Ret                     As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    UpdateInPatient_New = INSERT_ERROR

    Ret = INSERT_ERROR

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOW_DATE", IIf(dtmNow_Date > 0, dtmNow_Date, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "NOW_KA", strNow_Ka, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TAIIN_DATE", IIf(dtmTaiin_Date > 0, dtmTaiin_Date, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "TENKI", strTenki, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPE_FLG", strOpe_Flg, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DEATH_FLG", strDeath_Flg, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす入院歴ＳＭＩＬＥのレコードを更新
    strStmt = "UPDATE INPATIENT_NEW SET" & vbLf & _
              "         PERID      = :PERID,     NOW_DATE   = :NOW_DATE,    " & vbLf & _
              "         NOW_KA     = :NOW_KA,    TAIIN_DATE = :TAIIN_DATE,  " & vbLf & _
              "         TENKI      = :TENKI,     OPE_FLG    = :OPE_FLG,     " & vbLf & _
              "         DEATH_FLG  = :DEATH_FLG, UPDUSER    = :UPDUSER,     " & vbLf & _
              "         UPDDATE    =  SYSDATE                               " & vbLf & _
              " WHERE   PERID      = :PERID                                 " & vbLf & _
              "   AND   NOW_KA     = :NOW_KA                                " & vbLf & _
              "   AND   TAIIN_DATE = :TAIIN_DATE                            " & vbLf

    Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))

    If Ret > 0 Then
        Ret = INSERT_NORMAL
    End If


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    UpdateInPatient_New = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsFolRenkei.UpdateInPatient_New"

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
' 機能　　 : 指定の外来受診歴ＳＭＩＬＥ情報を更新する。
'
' 引数　　 : (In)     strPerId              患者ＩＤ
' 　　　　   (In)     dtmUke_YMD            受付日
' 　　　　   (In)     strUke_Ka             受付診療科
' 　　　　   (In)     strUpdUser            更新者
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function UpdateOutPatient_New( _
    ByVal strPerId As String, ByVal dtmUke_YMD As Date, _
    ByVal strUke_Ka As String, ByVal strUpdUser As String _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim Ret                     As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    UpdateOutPatient_New = INSERT_ERROR

    Ret = INSERT_ERROR

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UKE_YMD", IIf(dtmUke_YMD > 0, dtmUke_YMD, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UKE_KA", strUke_Ka, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす外来受診歴ＳＭＩＬＥテーブルのレコードを更新
    strStmt = "UPDATE OUTPATIENT_NEW SET                        " & vbLf & _
              "       PERID   = :PERID,  UKE_YMD = :UKE_YMD,    " & vbLf & _
              "       UKE_KA  = :UKE_KA, UPDUSER = :UPDUSER,    " & vbLf & _
              "       UPDDATE =  SYSDATE                        " & vbLf & _
              " WHERE PERID   = :PERID                          " & vbLf & _
              "   AND UKE_YMD = :UKE_YMD                        " & vbLf & _
              "   AND UKE_KA  = :UKE_KA                         " & vbLf

    Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))

    If Ret > 0 Then
        Ret = INSERT_NORMAL
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    UpdateOutPatient_New = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "HainsFolRenkei.UpdateOutPatient_New"

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
