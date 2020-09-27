VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Course"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'### 2003/11/23 Modified by Ishihara@FSIT 聖路加モードで全面刷新
'
' 機能　　 : コースレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strCsCd            コースコード
' 　　　　   (In)    vntCsName          コース名
' 　　　　   (In)    vntCsSName         コース略称
' 　　　　   (In)    intCsDiv           コース区分
' 　　　　   (In)    vntMainCsCd        メインコースコード
' 　　　　   (In)    strWebColor        WEBカラー
' 　　　　   (In)    vntRegularFlg      定健フラグ
' 　　　　   (In)    strSecondFlg       ２次健診フラグ
' 　　　　   (In)    strStay            受診時泊数
' 　　　　   (In)    strStaDiv          統計区分
' 　　　　   (In)    strReportCd        統計区分
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCourse_p(ByVal strMode As String, _
                               ByVal strCsCd As String, _
                               ByVal strCsName As String, ByVal vntCsSName As Variant, _
                               ByVal intCsDiv As Integer, ByVal vntMainCsCd As Variant, _
                               ByVal strWebColor As String, _
                               ByVal vntRegularFlg As Variant, ByVal strSecondFlg As String, _
                               ByVal strStay As String, _
                               ByVal strStaDiv As String, _
                               ByVal strReportCd As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSNAME", Trim(strCsName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSSNAME", Trim(vntCsSName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSDIV", Trim(intCsDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAINCSCD", Trim(vntMainCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "WEBCOLOR", Trim(strWebColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REGULARFLG", Trim(vntRegularFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SECONDFLG", Trim(strSecondFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STAY", Trim(strStay), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STADIV", Trim(strStaDiv), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        'コーステーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = ""
            strStmt = strStmt & "UPDATE COURSE_P"
            strStmt = strStmt & "   SET CSNAME   = :CSNAME,   STADIV     = :STADIV,    "
            strStmt = strStmt & "       WEBCOLOR = :WEBCOLOR, SECONDFLG  = :SECONDFLG, "
            strStmt = strStmt & "       STAY     = :STAY,     REPORTCD   = :REPORTCD,  "
            strStmt = strStmt & "       CSSNAME  = :CSSNAME,  CSDIV      = :CSDIV,     "
            strStmt = strStmt & "       MAINCSCD = :MAINCSCD, REGULARFLG = :REGULARFLG "
            
            strStmt = strStmt & " WHERE CSCD = :CSCD"
            
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たすコーステーブルのレコードを取得
        strStmt = "SELECT CSCD FROM COURSE_P WHERE CSCD = :CSCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入不可
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '新規挿入
        strStmt = ""
        strStmt = strStmt & "INSERT INTO COURSE_P (CSCD, CSNAME,  STADIV, WEBCOLOR, SECONDFLG,"
        strStmt = strStmt & "                      STAY, CSSNAME, CSDIV,  MAINCSCD, REGULARFLG, REPORTCD)"
        strStmt = strStmt & "     VALUES (:CSCD, :CSNAME, :STADIV, :WEBCOLOR, :SECONDFLG,"
        strStmt = strStmt & "             :STAY, :CSSNAME, :CSDIV, :MAINCSCD, :REGULARFLG, :REPORTCD)"
        
        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistCourse_p = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCourse_p = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Course.RegistCourse_p"
    
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
' 引数　　 : --- 基本コース系
' 　　　　   (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strCsCd                コースコード
' 　　　　   (In)    vntCsName              コース名
' 　　　　   (In)    strStaDiv              統計区分
' 　　　　   (In)    strDayIDDiv            当日ＩＤ発番区分
' 　　　　   (In)    strWebColor            WEBカラー
' 　　　　   (In)    strSecondFlg           ２次健診フラグ
' 　　　　   (In)    strStay                受診時泊数
' 　　　　   (In)    strGovMng              政府管掌フラグ
' 　　　　   (In)    strGovMng12Div         政府管掌一次二次区分
' 　　　　   (In)    strGovMngDiv           政府管掌健診区分
' 　　　　   (In)    strGovMngShaho         政府管掌社保区分
' 　　　　   --- コース内項目、グループ系
' 　　　　   (In)    blnEditItem            コース内項目の更新有無（FALSEなら更新しない）
' 　　　　   (In)    intCsHNo               コース履歴Ｎｏ
' 　　　　   (In)    intItemCount           依頼項目数
' 　　　　   (In)    vntItemCd              依頼項目コード
' 　　　　   (In)    intGrpCount            グループ項目数
' 　　　　   (In)    vntGrpCd               グループコード
' 　　　　   --- コース内判定系
' 　　　　   (In)    blnEditJud             判定分類の更新有無（FALSEなら更新しない）
' 　　　　   (In)    intItemCount           判定分類個数
' 　　　　   (In)    vntJudClassCd          判定分類コード
' 　　　　   (In)    vntNoReason            無条件展開フラグ
' 　　　　   (In)    vntSeq                 表示順番
' 　　　　   --- 検査項目実施日関連
' 　　　　   (In)    blnEditCourseOpe       検査項目実施日の更新有無（FALSEなら更新しない）
' 　　　　   (In)    intOpeCount            項目実施日個数
' 　　　　   (In)    vntOpeClassCd          項目実施日コード
' 　　　　   (In)    vntMonMng              月曜受診時検査日
' 　　　　   (In)    vntTueMng              火曜受診時検査日
' 　　　　   (In)    vntWedMng              水曜受診時検査日
' 　　　　   (In)    vntThuMng              木曜受診時検査日
' 　　　　   (In)    vntFriMng              金曜受診時検査日
' 　　　　   (In)    vntSatMng              土曜受診時検査日
' 　　　　   (In)    vntSunMng              日曜受診時検査日
' 　　　　   --- 財務連携データ関連
' 　　　　   (In)    strZai_Per_Misyu       個人～未収
' 　　　　   (In)    strZai_Per_Nyu         個人～当日入金
' 　　　　   (In)    strZai_Per_Kakomi      個人～過去未収
' 　　　　   (In)    strZai_Per_Kanmi       個人～還付未払
' 　　　　   (In)    strZai_Per_Kantou      個人～還付当日払
' 　　　　   (In)    strZai_Per_Kango       個人～還付後日払
' 　　　　   (In)    strZai_Org_Misyu       団体～未収
' 　　　　   (In)    strZai_Org_Nyu         団体～当日入金
' 　　　　   (In)    strZai_Org_Kakomi      団体～過去未収
' 　　　　   (In)    strZai_Org_Kanmi       団体～還付未払
' 　　　　   (In)    strZai_Org_Kantou      団体～還付当日払
' 　　　　   (In)    strZai_Org_Kango       団体～還付後日払
' 　　　　   --- 東急殿追加データ関連
' 　　　　   (In)    vntCsSName             コース略称
' 　　　　   (In)    vntCsDiv               コース区分
' 　　　　   (In)    vntMainCsCd            メインコースコード
' 　　　　   (In)    vntRoundFlg            まるめフラグ
' 　　　　   (In)    vntRegularFlg          定健フラグ
' 　　　　   (In)    vntStartTime           開始時間
' 　　　　   (In)    vntEndTime             終了時間
' 　　　　   (In)    vntKarteReportCd       カルテ用帳票コード
' 　　　　   (In)    vntNoPrintMonoPrice    請求単価未出力フラグ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :　コース、コース判定分類、コース内検査項目、コース内グループを一括で。
'
'### 2003/11/23 Modified by Ishihara@FSIT 不要項目カット
Public Function RegistCourse_All(ByVal strMode As String, ByVal strCsCd As String, _
                                 ByVal strCsName As String, ByVal strStaDiv As String, _
                                 ByVal strDayIDDiv As String, ByVal strWebColor As String, _
                                 ByVal strSecondFlg As String, ByVal strStay As String, _
                                 ByVal strGovMng As String, ByVal strGovMng12Div As String, _
                                 ByVal strGovMngDiv As String, ByVal strGovMngShaho As String, _
                                 ByVal blnEditItem As Boolean, ByVal intCsHNo As Integer, _
                                 ByVal intItemCount As Integer, ByVal vntItemCd As Variant, _
                                 ByVal intGrpCount As Integer, ByVal vntGrpCd As Variant, _
                                 ByVal blnEditJud As Boolean, ByVal intJudClassCount As Integer, _
                                 ByVal vntJudClassCd As Variant, ByVal vntNoReason As Variant, _
                                 ByVal vntSeq As Variant, ByVal blnEditCourseOpe As Boolean, ByVal intOpeCount As Integer, _
                                 ByVal vntOpeClassCd As Variant, ByVal vntMonMng As Variant, _
                                 ByVal vntTueMng As Variant, ByVal vntWedMng As Variant, _
                                 ByVal vntThuMng As Variant, ByVal vntFriMng As Variant, _
                                 ByVal vntSatMng As Variant, ByVal vntSunMng As Variant, _
                                 ByVal vntCsSName As Variant, ByVal intCsDiv As Integer, _
                                 ByVal vntMainCsCd As Variant, ByVal vntRoundFlg As Variant, _
                                 ByVal vntRegularFlg As Variant, ByVal vntStartTime As Variant, _
                                 ByVal vntEndTime As Variant, ByVal vntKarteReportCd As Variant, ByVal vntNoPrintMonoPrice As Variant _
                                 ) As Long
'Public Function RegistCourse_All(ByVal strMode As String, ByVal strCsCd As String, _
                                 ByVal strCsName As String, ByVal strStaDiv As String, _
                                 ByVal strDayIDDiv As String, ByVal strWebColor As String, _
                                 ByVal strSecondFlg As String, ByVal strStay As String, _
                                 ByVal strGovMng As String, ByVal strGovMng12Div As String, _
                                 ByVal strGovMngDiv As String, ByVal strGovMngShaho As String, _
                                 ByVal blnEditItem As Boolean, ByVal intCsHNo As Integer, _
                                 ByVal intItemCount As Integer, ByVal vntItemCd As Variant, _
                                 ByVal intGrpCount As Integer, ByVal vntGrpCd As Variant, _
                                 ByVal blnEditJud As Boolean, ByVal intJudClassCount As Integer, _
                                 ByVal vntJudClassCd As Variant, ByVal vntNoReason As Variant, _
                                 ByVal vntSeq As Variant, ByVal blnEditCourseOpe As Boolean, ByVal intOpeCount As Integer, _
                                 ByVal vntOpeClassCd As Variant, ByVal vntMonMng As Variant, _
                                 ByVal vntTueMng As Variant, ByVal vntWedMng As Variant, _
                                 ByVal vntThuMng As Variant, ByVal vntFriMng As Variant, _
                                 ByVal vntSatMng As Variant, ByVal vntSunMng As Variant, _
                                 ByVal strZai_Per_Misyu As String, ByVal strZai_Per_Nyu As String, ByVal strZai_Per_Kakomi As String, ByVal strZai_Per_Kanmi As String, _
                                 ByVal strZai_Per_Kantou As String, ByVal strZai_Per_Kango As String, ByVal strZai_Org_Misyu As String, ByVal strZai_Org_Nyu As String, _
                                 ByVal strZai_Org_Kakomi As String, ByVal strZai_Org_Kanmi As String, ByVal strZai_Org_Kantou As String, ByVal strZai_Org_Kango As String, _
                                 ByVal vntCsSName As Variant, ByVal vntCsDiv As Variant, _
                                 ByVal vntMainCsCd As Variant, ByVal vntRoundFlg As Variant, _
                                 ByVal vntRegularFlg As Variant, ByVal vntStartTime As Variant, _
                                 ByVal vntEndTime As Variant, ByVal vntKarteReportCd As Variant, ByVal vntNoPrintMonoPrice As Variant _
                                 ) As Long

    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim lngRet      As Long             '関数戻り値
    
    lngRet = INSERT_ERROR
    
    Do
        
        'コーステーブルの更新
        
'### 2003/11/23 Modified by Ishihara@FSIT 不要項目カット
'        lngRet = RegistCourse_p(strMode, _
                                strCsCd, _
                                strCsName, _
                                strStaDiv, _
                                strDayIDDiv, _
                                strWebColor, _
                                strSecondFlg, _
                                strStay, _
                                strGovMng, _
                                strGovMng12Div, _
                                strGovMngDiv, _
                                strGovMngShaho, _
                                strZai_Per_Misyu, strZai_Per_Nyu, _
                                strZai_Per_Kakomi, strZai_Per_Kanmi, _
                                strZai_Per_Kantou, strZai_Per_Kango, _
                                strZai_Org_Misyu, strZai_Org_Nyu, _
                                strZai_Org_Kakomi, strZai_Org_Kanmi, _
                                strZai_Org_Kantou, strZai_Org_Kango, _
                                vntCsSName, vntCsDiv, _
                                vntMainCsCd, vntRoundFlg, _
                                vntRegularFlg, vntStartTime, _
                                vntEndTime, vntKarteReportCd, vntNoPrintMonoPrice)
Dim strReportCd As String
        lngRet = RegistCourse_p(strMode, _
                                strCsCd, _
                                strCsName, _
                                vntCsSName, _
                                intCsDiv, _
                                vntMainCsCd, _
                                strWebColor, _
                                vntRegularFlg, _
                                strSecondFlg, _
                                strStay, _
                                strStaDiv, _
                                strReportCd)
'### 2003/11/23 Modified End

        '異常終了なら処理終了
        If lngRet <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        If blnEditItem = True Then
            
            'コース内項目の更新
            lngRet = RegistCourse_Item(strCsCd, _
                                 intCsHNo, _
                                 intItemCount, _
                                 vntItemCd, _
                                 intGrpCount, _
                                 vntGrpCd)
                
            '異常終了なら処理終了
            If lngRet <> INSERT_NORMAL Then
                Exit Do
            End If
        
        End If
                         
        If blnEditJud = True Then
                         
            'コース内判定分類の更新
            lngRet = RegistCourse_Jud(strCsCd, intJudClassCount, vntJudClassCd, vntNoReason, vntSeq)
    
            '異常終了なら処理終了
            If lngRet <> INSERT_NORMAL Then
                Exit Do
            End If
        
        End If
        
        
        If blnEditCourseOpe = True Then
            '検査項目実施日の更新
            lngRet = RegistCourse_Ope(strCsCd, _
                                      intOpeCount, _
                                      vntOpeClassCd, _
                                      vntMonMng, _
                                      vntTueMng, _
                                      vntWedMng, _
                                      vntThuMng, _
                                      vntFriMng, _
                                      vntSatMng, _
                                      vntSunMng)
        
            '異常終了なら処理終了
            If lngRet <> INSERT_NORMAL Then
                Exit Do
            End If
        
        End If
        
        lngRet = INSERT_NORMAL
        Exit Do
    Loop
 
    '異常終了ならRollBack
    If lngRet <> INSERT_NORMAL Then
        mobjContext.SetAbort
    Else
        'トランザクションをコミット
        mobjContext.SetComplete
    End If
 
    '戻り値の設定
    RegistCourse_All = lngRet

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCourse_All = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Course.RegistCourse_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : コース履歴レコードを登録する
'
' 引数　　 : (In)     strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In/Out) intCsHNo       コース履歴No（新規時には発番したものをセット）
' 　　　　   (In)     dtmStrDate     使用開始日付
' 　　　　   (In)     dtmEndDate     使用終了日付
' 　　　　   (In)     lngPrice       コース基本料金
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCourse_h(ByVal strMode As String, _
                               ByVal strCsCd As String, ByRef intCsHNo As Integer, _
                               ByVal dtmStrDate As Date, ByVal dtmEndDate As Date, _
                               ByVal lngPrice As Long) As Long
    
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objNewSeq   As OraField         'これから発番する履歴Ｎｏ
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    RegistCourse_h = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CsCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "strDate", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "endDate", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "Price", lngPrice, ORAPARM_INPUT, ORATYPE_NUMBER

    '履歴データの重複チェック
    If strMode = "INS" Then
        strStmt = "SELECT CSCD FROM COURSE_H" & vbLf & _
                  " WHERE CSCD = :CSCD" & vbLf & _
                  "   AND (    :STRDATE BETWEEN  STRDATE AND ENDDATE " & vbLf & _
                  "         OR :ENDDATE BETWEEN  STRDATE AND ENDDATE )"
    Else
        
        '履歴番号のバインド変数
        objOraParam.Add "CsHNo", intCsHNo, ORAPARM_INPUT, ORATYPE_NUMBER
        
        strStmt = "SELECT CSCD FROM COURSE_H" & vbLf & _
                  " WHERE CSCD  = :CSCD" & vbLf & _
                  "   AND CSHNO != :CSHNO" & vbLf & _
                  "   AND (    :STRDATE BETWEEN  STRDATE AND ENDDATE " & vbLf & _
                  "         OR :ENDDATE BETWEEN  STRDATE AND ENDDATE )"
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        RegistCourse_h = INSERT_HISTORYDUPLICATE
        Exit Function
    End If

    If strMode = "UPD" Then
        
        'コース履歴管理テーブルレコードの更新
        strStmt = ""
        strStmt = strStmt & "UPDATE Course_h"
        strStmt = strStmt & "   SET CsCd    = :CsCd,    CsHNo = :CsHNo, "
        strStmt = strStmt & "       strDate = :strDate, endDate = :endDate, "
        strStmt = strStmt & "       Price   = :Price"
        strStmt = strStmt & " WHERE CsCD  = :CsCD"
        strStmt = strStmt & "   AND CsHNo = :CsHNo"
        
        Ret = mobjOraDb.ExecuteSQL(strStmt)
        If Ret > 0 Then
            Ret = INSERT_NORMAL
        End If
        
    Else
    
        '検索条件を満たすコーステーブルのレコードを取得
        strStmt = "SELECT NVL(MAX(CSHNO),0) + 1 NEWSEQ FROM COURSE_H WHERE CSCD = :CsCd"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        'オブジェクトの参照設定（絶対に１件は返ってくる）
        Set objFields = objOraDyna.Fields
        Set objNewSeq = objFields("NEWSEQ")
            
        '最新履歴番号が100以内なら
        If objNewSeq.Value < 100 Then
            
            '履歴番号のバインド変数
            objOraParam.Add "CsHNo", CInt(objNewSeq.Value), ORAPARM_INPUT, ORATYPE_NUMBER
        
            '新規挿入
            strStmt = ""
            strStmt = strStmt & "INSERT INTO Course_h (CsCD, CsHNo, strDate, endDate, Price)"
            strStmt = strStmt & "     VALUES (:CsCD, :CsHNo, :strDate, :endDate, :Price)"
            mobjOraDb.ExecuteSQL strStmt
        
            '発番した履歴番号を引数にセット
            intCsHNo = CInt(objNewSeq.Value)
            
            Ret = INSERT_NORMAL
            
        Else
            
            '履歴番号が最大数に達したらエラー（現時点では暫定的に、INSERT_DUPLICATEをセット）
            Ret = INSERT_DUPLICATE
        
        End If
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistCourse_h = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCourse_h = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Course.RegistCourse_h"
    
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
' 機能　　 : コース内受診項目を登録する
'
' 引数　　 : (In)    strCsCd        コースコード
' 　　　　   (In)    intCsHNo       コース履歴Ｎｏ
' 　　　　   (In)    intItemCount   依頼項目数
' 　　　　   (In)    vntItemCd      依頼項目コード
' 　　　　   (In)    intGrpCount    グループ項目数
' 　　　　   (In)    vntGrpCd       グループコード
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCourse_Item(ByVal strCsCd As String, _
                                  ByVal intCsHNo As Integer, _
                                  ByVal intItemCount As Integer, _
                                  ByVal vntItemCd As Variant, _
                                  ByVal intGrpCount As Integer, _
                                  ByVal vntGrpCd As Variant) As Long
                               
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim objCsCd     As OraParamArray    'コースコード
    Dim objCsHNo    As OraParamArray    'コース履歴番号
    Dim objItemCd   As OraParamArray    '検査項目コード
    Dim objGrpCd    As OraParamArray    'グループコード

    Dim i           As Integer
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CsCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CsHNo", intCsHNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'コース内グループ及び、コース内検査項目レコードの削除
    mobjOraDb.ExecuteSQL "DELETE Course_i WHERE CsCd = :CsCD AND CSHNO = :CsHNo"
    mobjOraDb.ExecuteSQL "DELETE Course_g WHERE CsCd = :CsCD AND CSHNO = :CsHNo"
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'コース内検査項目レコードが存在するなら
    If intItemCount > 0 Then
        
        '配列準備
        objOraParam.AddTable "CsCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_COURSE_CSCD
        objOraParam.AddTable "CsHNo", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_COURSE_H_CSHNO
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
    
        'OraParameterオブジェクトの参照設定
        Set objCsCd = objOraParam("CsCD")
        Set objCsHNo = objOraParam("CsHNo")
        Set objItemCd = objOraParam("ITEMCD")
    
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objCsCd(i) = strCsCd
            objCsHNo(i) = intCsHNo
            objItemCd(i) = vntItemCd(i)
        Next i
    
        '新規挿入
        strStmt = ""
        strStmt = strStmt & "INSERT INTO Course_i (CsCD, CsHNo, ItemCd)"
        strStmt = strStmt & "     VALUES (:CsCD, :CsHNo, :ITEMCD)"
        mobjOraDb.ExecuteSQL strStmt
    
        'キー及び更新値の設定解除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
   
    End If
    
    'コース内グループレコードが存在するなら
    If intGrpCount > 0 Then
        
        '配列準備
        objOraParam.AddTable "CsCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intGrpCount, LENGTH_COURSE_CSCD
        objOraParam.AddTable "CsHNo", ORAPARM_INPUT, ORATYPE_NUMBER, intGrpCount, LENGTH_COURSE_H_CSHNO
        objOraParam.AddTable "GRPCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intGrpCount, LENGTH_GRP_P_GRPCD
    
        'OraParameterオブジェクトの参照設定
        Set objCsCd = objOraParam("CsCD")
        Set objCsHNo = objOraParam("CsHNo")
        Set objGrpCd = objOraParam("GRPCD")
    
        'OraParameterオブジェクトの値設定
        For i = 0 To intGrpCount - 1
            objCsCd(i) = strCsCd
            objCsHNo(i) = intCsHNo
            objGrpCd(i) = vntGrpCd(i)
        Next i
    
        '新規挿入
        strStmt = ""
        strStmt = strStmt & "INSERT INTO Course_g (CsCD, CsHNo, GrpCd)"
        strStmt = strStmt & "     VALUES (:CsCD, :CsHNo, :GRPCD)"
        mobjOraDb.ExecuteSQL strStmt
    
        'キー及び更新値の設定解除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    
    End If
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistCourse_Item = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCourse_Item = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Course.RegistCourse_Item"
    
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
' 機能　　 : コーステーブルレコードを削除する
'
' 引数　　 : (In)    strCsCd    コースコード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteCourse_p(ByVal strCsCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
        DeleteCourse_p = False
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CsCd", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'コーステーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE Course_p WHERE CsCd = :CsCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    '戻り値の設定
    DeleteCourse_p = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCourse_p = False

    'イベントログ書き込み
    WriteErrorLog "Course.DeleteCourse_p"
    
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
' 機能　　 : コース履歴管理テーブルレコードを削除する
'
' 引数　　 : (In)    strCsCd    コースコード
' 引数　　 : (In)    intCsHNo   コース履歴No
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteCourse_h(ByVal strCsCd As String, ByVal intCsHNo As Integer) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    DeleteCourse_h = False
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CsCd", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CsHNo", intCsHNo, ORAPARM_INPUT, ORATYPE_NUMBER

    'コーステーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE Course_h WHERE CsCd = :CsCD and CsHNo = :CsHNo"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCourse_h = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteCourse_h = False

    'イベントログ書き込み
    WriteErrorLog "Course.DeleteCourse_h"
    
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
' 機能　　 : キーの大小比較
'
' 引数　　 : (In)     vntKey1  キー1
' 　　　　   (In)     vntKey2  キー2
'
' 戻り値　 : 1   キー1 > キー2
' 　　　　   0   キー1 = キー2
' 　　　　   -1  キー1 < キー2
'
' 備考　　 : キーについてはキーの個数分の配列を格納するものとする
'
Private Function CompareKey(ByRef vntKey1 As Variant, ByRef vntKey2 As Variant) As Variant

    Dim i   As Long     'インデックス
    Dim Ret As Variant  '文字列比較関数の戻り値
    
    '配列の各値を比較
    For i = 0 To UBound(vntKey1)
        
        '文字列比較
        Ret = StrComp(vntKey1(i), vntKey2(i))
                
        '差異がある場合は比較を終了
        If Ret <> 0 Then
            Exit For
        End If
        
    Next i
    
    '文字列比較の戻り値を編集
    CompareKey = Ret
    
End Function

'
' 機能　　 : 指定コースにおいて指定期間を適用期間として含む履歴数を検索
'
' 引数　　 : (In)     strCsCd     コースコード
' 　　　　 : (In)     dtmStrDate  開始日
' 　　　　 : (In)     dtmEndDate  終了日
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function GetHistoryCount(ByVal strCsCd As String, ByVal dtmStrDate As Date, ByVal dtmEndDate As Date) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objCount    As OraField         '履歴数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '検索条件が適用期間として含まれるコース履歴管理テーブルのレコード数をカウント
    strStmt = "SELECT COUNT(*) CNT        " & vbLf & _
              "  FROM COURSE_H            " & vbLf & _
              " WHERE CSCD     = :CSCD    " & vbLf & _
              "   AND ENDDATE >= :STRDATE "
    
    '終了日が指定されている場合は条件節に含む
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND STRDATE <= :ENDDATE "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'オブジェクトの参照設定
    Set objFields = objOraDyna.Fields
    Set objCount = objFields("CNT")
        
    '戻り値の設定
    GetHistoryCount = CLng(objCount.Value)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    GetHistoryCount = -1
    
    'イベントログ書き込み
    WriteErrorLog "Course.GetHistoryCount"
    
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
' 機能　　 : コースコードに対するコース名を取得する
'
' 引数　　 : (In)     strCsCd    コースコード
' 　　　　   (Out)    vntCsName  コース名
'
' 戻り値　 : True   正常終了
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectCourse(ByVal strCsCd As String, _
                             ByRef vntCsName As Variant, _
                             Optional ByRef vntStaDiv As Variant, _
                             Optional ByRef vntDayIDDiv As Variant, _
                             Optional ByRef vntStrDayID As Variant, _
                             Optional ByRef vntEndDayID As Variant, _
                             Optional ByRef vntWebColor As Variant, _
                             Optional ByRef vntSecondFlg As Variant, _
                             Optional ByRef vntStay As Variant, _
                             Optional ByRef vntGovMng As Variant, Optional ByRef vntGovMng12Div As Variant, _
                             Optional ByRef vntGovMngDiv As Variant, Optional ByRef vntGovMngShaho As Variant, _
                             Optional ByRef vntZai_per_misyu As Variant, Optional ByRef vntZai_per_nyu As Variant, _
                             Optional ByRef vntZai_per_kakomi As Variant, Optional ByRef vntZai_per_kanmi As Variant, _
                             Optional ByRef vntZai_per_kantou As Variant, Optional ByRef vntZai_per_kango As Variant, _
                             Optional ByRef vntZai_org_misyu As Variant, Optional ByRef vntZai_org_nyu As Variant, _
                             Optional ByRef vntZai_org_kakomi As Variant, Optional ByRef vntZai_org_kanmi As Variant, _
                             Optional ByRef vntZai_org_kantou As Variant, Optional ByRef vntZai_org_kango As Variant, _
                             Optional ByRef vntCsSName As Variant, _
                             Optional ByRef vntCsDiv As Variant, _
                             Optional ByRef vntMainCsCd As Variant, _
                             Optional ByRef vntRoundFlg As Variant, _
                             Optional ByRef vntRegularFlg As Variant, _
                             Optional ByRef vntStartTime As Variant, _
                             Optional ByRef vntEndTime As Variant, _
                             Optional ByRef vntKarteReportCd As Variant, Optional ByRef vntNoPrintMonoPrice As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCsName           As OraField         'コース名
    Dim objStaDiv           As OraField         '
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objDayIDDiv         As OraField         '
'    Dim objStrDayID         As OraField         '
'    Dim objEndDayID         As OraField         '
'## 2003.11.18 Del End
    Dim objWebColor         As OraField         '
    Dim objSecondFlg        As OraField         '
    Dim objStay             As OraField         '
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objGovMng           As OraField         '
'    Dim objGovMng12Div      As OraField         '
'    Dim objGovMngDiv        As OraField         '
'    Dim objGovMngShaho      As OraField         '
'    Dim objZai_Per_Misyu    As OraField
'    Dim objZai_Per_Nyu      As OraField
'    Dim objZai_Per_Kakomi   As OraField
'    Dim objZai_Per_Kanmi    As OraField
'    Dim objZai_Per_Kantou   As OraField
'    Dim objZai_Per_Kango    As OraField
'    Dim objZai_Org_Misyu    As OraField
'    Dim objZai_Org_Nyu      As OraField
'    Dim objZai_Org_Kakomi   As OraField
'    Dim objZai_Org_Kanmi    As OraField
'    Dim objZai_Org_Kantou   As OraField
'    Dim objZai_Org_Kango    As OraField
'## 2003.11.18 Del End
''### 2002.11.12 Mod By H.Ishihara@FSIT 東急殿仕様追加
    Dim objCsSName          As OraField
    Dim objCsDiv            As OraField
    Dim objMainCsCd         As OraField
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objRoundFlg         As OraField
'## 2003.11.18 Del End
    Dim objRegularFlg       As OraField
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objStartTime        As OraField
'    Dim objEndTime          As OraField
'    Dim objKarteReportCd    As OraField
'    Dim objNoPrintMonoPrice As OraField
'## 2003.11.18 Del End
''### 2002.11.12 Mod End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たすコーステーブルのレコードを取得
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = ""
'    strStmt = strStmt & "SELECT CSNAME,   STADIV,     WEBCOLOR,    SECONDFLG,"
'    strStmt = strStmt & "       STAY,     GOVMNG,     GOVMNG12DIV, GOVMNGDIV, GOVMNGSHAHO,"
'    strStmt = strStmt & "       DAYIDDIV, FREEFIELD1, FREEFIELD2, "
'    strStmt = strStmt & "       ZAI_PER_MISYU,  ZAI_PER_NYU,   ZAI_PER_KAKOMI, ZAI_PER_KANMI,"
'    strStmt = strStmt & "       ZAI_PER_KANTOU, ZAI_PER_KANGO,"
'    strStmt = strStmt & "       ZAI_ORG_MISYU,  ZAI_ORG_NYU,   ZAI_ORG_KAKOMI, ZAI_ORG_KANMI,"
''### 2002.11.12 Mod By H.Ishihara@FSIT 東急殿仕様追加
''    strStmt = strStmt & "       ZAI_ORG_KANTOU, ZAI_ORG_KANGO,"
'    strStmt = strStmt & "       ZAI_ORG_KANTOU, ZAI_ORG_KANGO, CSSNAME, CSDIV, MAINCSCD, ROUNDFLG, REGULARFLG, "
'    strStmt = strStmt & "       STARTTIME, ENDTIME, KARTEREPORTCD, NOPRINTMONOPRICE"
''### 2002.11.12 Mod By H.Ishihara@FSIT 東急殿仕様追加
'    strStmt = strStmt & "  FROM FREE, COURSE_P WHERE CSCD = :CSCD AND FREECD = DAYIDDIV"
    strStmt = "SELECT CSNAME, STADIV,  WEBCOLOR, SECONDFLG, " & vbLf & _
              "       STAY,   CSSNAME, CSDIV, MAINCSCD, REGULARFLG " & vbLf & _
              "  FROM COURSE_P " & vbLf & _
              " WHERE CSCD = :CSCD "
'## 2003.11.18 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsName = objFields("CSNAME")
        Set objStaDiv = objFields("STADIV")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objDayIDDiv = objFields("DAYIDDIV")
'        Set objStrDayID = objFields("FREEFIELD1")
'        Set objEndDayID = objFields("FREEFIELD2")
'## 2003.11.18 Del End
        Set objWebColor = objFields("WEBCOLOR")
        Set objSecondFlg = objFields("SECONDFLG")
        Set objStay = objFields("STAY")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objGovMng = objFields("GOVMNG")
'        Set objGovMng12Div = objFields("GOVMNG12DIV")
'        Set objGovMngDiv = objFields("GOVMNGDIV")
'        Set objGovMngShaho = objFields("GOVMNGSHAHo")
'        Set objZai_Per_Misyu = objFields("ZAI_PER_MISYU")
'        Set objZai_Per_Nyu = objFields("ZAI_PER_NYU")
'        Set objZai_Per_Kakomi = objFields("ZAI_PER_KAKOMI")
'        Set objZai_Per_Kanmi = objFields("ZAI_PER_KANMI")
'        Set objZai_Per_Kantou = objFields("ZAI_PER_KANTOU")
'        Set objZai_Per_Kango = objFields("ZAI_PER_KANGO")
'        Set objZai_Org_Misyu = objFields("ZAI_ORG_MISYU")
'        Set objZai_Org_Nyu = objFields("ZAI_ORG_NYU")
'        Set objZai_Org_Kakomi = objFields("ZAI_ORG_KAKOMI")
'        Set objZai_Org_Kanmi = objFields("ZAI_ORG_KANMI")
'        Set objZai_Org_Kantou = objFields("ZAI_ORG_KANTOU")
'        Set objZai_Org_Kango = objFields("ZAI_ORG_KANGO")
'## 2003.11.18 Del End
'### 2002.11.12 Mod By H.Ishihara@FSIT 東急殿仕様追加
        Set objCsSName = objFields("CSSNAME")
        Set objCsDiv = objFields("CSDIV")
        Set objMainCsCd = objFields("MAINCSCD")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objRoundFlg = objFields("ROUNDFLG")
'## 2003.11.18 Del End
        Set objRegularFlg = objFields("REGULARFLG")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objStartTime = objFields("STARTTIME")
'        Set objEndTime = objFields("ENDTIME")
'        Set objKarteReportCd = objFields("KARTEREPORTCD")
'        Set objNoPrintMonoPrice = objFields("NOPRINTMONOPRICE")
'## 2003.11.18 Del End
'### 2002.11.12 Mod End
    
        '戻り値の設定
        vntCsName = objCsName.Value & ""
        
        If IsMissing(vntStaDiv) = False Then vntStaDiv = objStaDiv.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If IsMissing(vntDayIDDiv) = False Then vntDayIDDiv = objDayIDDiv.Value & ""
'        If IsMissing(vntStrDayID) = False Then vntStrDayID = objStrDayID.Value & ""
'        If IsMissing(vntEndDayID) = False Then vntEndDayID = objEndDayID.Value & ""
'## 2003.11.18 Del End
        If IsMissing(vntWebColor) = False Then vntWebColor = objWebColor.Value & ""
        If IsMissing(vntSecondFlg) = False Then vntSecondFlg = objSecondFlg.Value & ""
        If IsMissing(vntStay) = False Then vntStay = objStay.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If IsMissing(vntGovMng) = False Then vntGovMng = objGovMng.Value & ""
'        If IsMissing(vntGovMng12Div) = False Then vntGovMng12Div = objGovMng12Div.Value & ""
'        If IsMissing(vntGovMngDiv) = False Then vntGovMngDiv = objGovMngDiv.Value & ""
'        If IsMissing(vntGovMngShaho) = False Then vntGovMngShaho = objGovMngShaho.Value & ""
'        If IsMissing(vntZai_per_misyu) = False Then vntZai_per_misyu = objZai_Per_Misyu.Value & ""
'        If IsMissing(vntZai_per_nyu) = False Then vntZai_per_nyu = objZai_Per_Nyu.Value & ""
'        If IsMissing(vntZai_per_kakomi) = False Then vntZai_per_kakomi = objZai_Per_Kakomi.Value & ""
'        If IsMissing(vntZai_per_kanmi) = False Then vntZai_per_kanmi = objZai_Per_Kanmi.Value & ""
'        If IsMissing(vntZai_per_kantou) = False Then vntZai_per_kantou = objZai_Per_Kantou.Value & ""
'        If IsMissing(vntZai_per_kango) = False Then vntZai_per_kango = objZai_Per_Kango.Value & ""
'        If IsMissing(vntZai_org_misyu) = False Then vntZai_org_misyu = objZai_Org_Misyu.Value & ""
'        If IsMissing(vntZai_org_nyu) = False Then vntZai_org_nyu = objZai_Org_Nyu.Value & ""
'        If IsMissing(vntZai_org_kakomi) = False Then vntZai_org_kakomi = objZai_Org_Kakomi.Value & ""
'        If IsMissing(vntZai_org_kanmi) = False Then vntZai_org_kanmi = objZai_Org_Kanmi.Value & ""
'        If IsMissing(vntZai_org_kantou) = False Then vntZai_org_kantou = objZai_Org_Kantou.Value & ""
'        If IsMissing(vntZai_org_kango) = False Then vntZai_org_kango = objZai_Org_Kango.Value & ""
'## 2003.11.18 Del End
'### 2002.11.12 Mod By H.Ishihara@FSIT 東急殿仕様追加
        If IsMissing(vntCsSName) = False Then vntCsSName = objCsSName.Value & ""
        If IsMissing(vntCsDiv) = False Then vntCsDiv = objCsDiv.Value & ""
        If IsMissing(vntMainCsCd) = False Then vntMainCsCd = objMainCsCd.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If IsMissing(vntRoundFlg) = False Then vntRoundFlg = objRoundFlg.Value & ""
'## 2003.11.18 Del End
        If IsMissing(vntRegularFlg) = False Then vntRegularFlg = objRegularFlg.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If IsMissing(vntStartTime) = False Then vntStartTime = objStartTime.Value & ""
'        If IsMissing(vntEndTime) = False Then vntEndTime = objEndTime.Value & ""
'        If IsMissing(vntKarteReportCd) = False Then vntKarteReportCd = objKarteReportCd.Value & ""
'        If IsMissing(vntNoPrintMonoPrice) = False Then vntNoPrintMonoPrice = objNoPrintMonoPrice.Value & ""
'## 2003.11.18 Del End
'### 2002.11.12 Mod End
        
        SelectCourse = True
        
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
    WriteErrorLog "Course.SelectCourse"
    
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
' 機能　　 : 指定契約情報におけるコース各履歴ごとの受診グループを取得する
'
' 引数　　 : (In)     strOrgCd1        団体コード1
' 　　　　   (In)     strOrgCd2        団体コード2
' 　　　　   (In)     lngCtrPtCd       契約パターンコード
' 　　　　   (Out)    vntHistory       適用期間
' 　　　　   (Out)    vntHistoryCount  適用期間数
' 　　　　   (Out)    vntGrpCd         グループコード
' 　　　　   (Out)    vntGrpName       グループ名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCourseGroupIntoContract( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntHistory As Variant, _
    ByRef vntHistoryCount As Variant, _
    ByRef vntGrpCd As Variant, _
    ByRef vntGrpName As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objGrpCd                As OraField         'グループコード
    Dim objGrpName              As OraField         'グループ名
    Dim objStrDate              As OraField         '適用開始日
    Dim objEndDate              As OraField         '適用終了日
    
    Dim vntArrHistory()         As Variant          '適用期間の配列
    Dim vntArrHistoryCount()    As Variant          '適用期間数の配列
    Dim vntArrItemDiv()         As Variant          '項目区分の配列
    Dim vntArrGrpCd()           As Variant          'コードの配列
    Dim vntArrGrpName()         As Variant          '名称の配列
    Dim lngCount                As Long             'レコード数
    
    Dim strGrpCd                As String           'グループコード
    Dim strGrpName              As String           'グループ名
    
    Dim strPrevGrpCd            As String           '直前レコードのグループコード
    Dim strPrevGrpName          As String           '直前レコードのグループ名
    
    Dim strHistory              As String           '適用期間格納文字列
    Dim lngHistoryCount         As Long             '適用期間数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntHistory = Empty
    vntGrpCd = Empty
    vntGrpName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定契約情報において受診対象となるグループを取得
    strStmt = "SELECT COURSE_G.GRPCD, GRP_P.GRPNAME,                      " & vbLf & _
              "       COURSE_H.STRDATE, COURSE_H.ENDDATE                  " & vbLf & _
              "  FROM GRP_P, COURSE_G, COURSE_H, CTRMNGWITHPERIOD         " & vbLf & _
              " WHERE CTRMNGWITHPERIOD.ORGCD1  = :ORGCD1                  " & vbLf & _
              "   AND CTRMNGWITHPERIOD.ORGCD2  = :ORGCD2                  " & vbLf & _
              "   AND CTRMNGWITHPERIOD.CTRPTCD = :CTRPTCD                 " & vbLf & _
              "   AND CTRMNGWITHPERIOD.CSCD    = COURSE_H.CSCD            " & vbLf & _
              "   AND COURSE_H.ENDDATE        >= CTRMNGWITHPERIOD.STRDATE " & vbLf & _
              "   AND COURSE_H.STRDATE        <= CTRMNGWITHPERIOD.ENDDATE " & vbLf & _
              "   AND COURSE_H.CSCD            = COURSE_G.CSCD            " & vbLf & _
              "   AND COURSE_H.CSHNO           = COURSE_G.CSHNO           "
    
    '基本コース削除項目は除く
    strStmt = strStmt & vbLf & _
              "   AND COURSE_G.GRPCD      NOT IN ( SELECT GRPCD                                 " & vbLf & _
              "                                      FROM CTRPT_GRP                             " & vbLf & _
              "                                     WHERE CTRPTCD = CTRMNGWITHPERIOD.CTRPTCD    " & vbLf & _
              "                                       AND OPTCD   = " & CStr(OPTCD_COURSE) & ") " & vbLf & _
              "   AND COURSE_G.GRPCD           = GRP_P.GRPCD                                    " & vbLf & _
              " ORDER BY GRPCD, STRDATE                                                         "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")

        Do Until objOraDyna.EOF

            'レコード内容を取得
            strGrpCd = objGrpCd.Value
            strGrpName = objGrpName.Value
            
            '直前レコードと項目が異なる場合
            If strPrevGrpCd <> "" Then
                
                If strGrpCd <> strPrevGrpCd Then
                
                    '適用期間・グループコード・グループ名を配列形式で格納する
                    ReDim Preserve vntArrHistory(lngCount)
                    ReDim Preserve vntArrHistoryCount(lngCount)
                    ReDim Preserve vntArrGrpCd(lngCount)
                    ReDim Preserve vntArrGrpName(lngCount)
                    vntArrHistory(lngCount) = strHistory
                    vntArrHistoryCount(lngCount) = lngHistoryCount
                    vntArrGrpCd(lngCount) = strPrevGrpCd
                    vntArrGrpName(lngCount) = strPrevGrpName
                    lngCount = lngCount + 1
                
                    '適用期間をクリア
                    strHistory = ""
                    lngHistoryCount = 0
                    
                End If
            
            End If
            
            '適用開始・終了日を連結し、適用期間として編集
            strHistory = strHistory & IIf(strHistory <> "", ",", "") & objStrDate.Value & "," & objEndDate.Value
            lngHistoryCount = lngHistoryCount + 1
            
            '直前レコードの値を現内容で更新する
            strPrevGrpCd = strGrpCd
            strPrevGrpName = strGrpName
            
            objOraDyna.MoveNext
        
        Loop

        '適用期間文字列が残っている場合は配列に追加する
        If strHistory <> "" Then
            ReDim Preserve vntArrHistory(lngCount)
            ReDim Preserve vntArrHistoryCount(lngCount)
            ReDim Preserve vntArrGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            vntArrHistory(lngCount) = strHistory
            vntArrHistoryCount(lngCount) = lngHistoryCount
            vntArrGrpCd(lngCount) = strPrevGrpCd
            vntArrGrpName(lngCount) = strPrevGrpName
            lngCount = lngCount + 1
        End If

        '適用期間、項目区分、項目コード順にソート
        ReDim Preserve vntArrItemDiv(lngCount - 1)  '←引数合わせのためだけに作成
        SortHistory vntArrHistory, vntArrItemDiv, vntArrGrpCd, vntArrGrpName, 0, UBound(vntArrHistory)
    
        '戻り値の設定
        vntHistory = vntArrHistory
        vntHistoryCount = vntArrHistoryCount
        vntGrpCd = vntArrGrpCd
        vntGrpName = vntArrGrpName
    
    End If

    '戻り値の設定
    SelectCourseGroupIntoContract = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectCourseGroupIntoContract"
    
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
' 機能　　 : コースの履歴を取得する
'
' 引数　　 : (In)     strCsCd     コースコード
' 　　　　   (In)     dtmStrDate  開始日
' 　　　　   (In)     dtmEndDate  終了日
' 　　　　   (Out)    vntStrDate  使用開始日付
' 　　　　   (Out)    vntEndDate  使用終了日付
' 　　　　   (Out)    vntPrice    コース基本料金
' 　　　　   (Out)    vntTax      消費税
' 　　　　   (Out)    vntCsHNo    コース履歴番号
'
' 戻り値　 : レコード件数
'
' 備考　　 : コースから取得される金額情報はあくまでも契約作成上の目安なので消費税端数は切り上げる
'
Public Function SelectCourseHistory( _
    ByVal strCsCd As String, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date, _
    ByRef vntStrDate As Variant, _
    ByRef vntEndDate As Variant, _
    ByRef vntPrice As Variant, _
    ByRef vntTax As Variant, _
    Optional ByRef vntCsHNo As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objStrDate      As OraField         '使用開始日付
    Dim objEndDate      As OraField         '使用終了日付
    Dim objPrice        As OraField         'コース基本料金
    Dim objTax          As OraField         '消費税
    Dim objCsHNo        As OraField         'コース履歴番号
    
    Dim vntArrStrDate() As Variant          '使用開始日付の配列
    Dim vntArrEndDate() As Variant          '使用終了日付の配列
    Dim vntArrPrice()   As Variant          'コース基本料金の配列
    Dim vntArrTax()     As Variant          '消費税の配列
    Dim vntArrCsHNo()   As Variant          'コース履歴番号の配列
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStrDate = Empty
    vntEndDate = Empty
    vntPrice = Empty
    vntTax = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '指定期間のコース履歴より負担金額、消費税を取得
    '(1) 適用開始を境に適用する税率を切り替える
    '(2) 小数点第１位で切り上げするため、0.9を加算して切り捨て処理を行う
    strStmt = "SELECT CSHNO, STRDATE, ENDDATE, PRICE,                                  " & vbLf & _
              "       TRUNC(PRICE * NVL(RATE, 0) + 0.9, 0) TAX                         " & vbLf & _
              "  FROM ( SELECT COURSE_H.CSHNO, COURSE_H.STRDATE, COURSE_H.ENDDATE, COURSE_H.PRICE,     " & vbLf & _
              "                CASE WHEN COURSE_H.STRDATE < FREE.FREEDATE              " & vbLf & _
              "                     THEN FREE.FREEFIELD1 ELSE FREE.FREEFIELD2 END RATE " & vbLf & _
              "           FROM FREE, COURSE_H                                          " & vbLf & _
              "          WHERE COURSE_H.CSCD     = :CSCD "
    
    '指定コースより、指定期間に対象となる全ての履歴(期間指定がなければ全履歴)を取得
    If dtmStrDate > 0 Then
        strStmt = strStmt & vbLf & _
              "            AND COURSE_H.ENDDATE >= :STRDATE "
    End If
              
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "            AND COURSE_H.STRDATE <= :ENDDATE "
    End If
    
    '消費税率を取得するため、汎用テーブルの消費税率情報を内部結合する
    strStmt = strStmt & vbLf & _
              "            AND FREE.FREECD       = 'TAX' "
              
    '適用開始日の昇順に取得
    strStmt = strStmt & vbLf & _
              "       )          " & vbLf & _
              " ORDER BY STRDATE "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objPrice = objFields("PRICE")
        Set objTax = objFields("TAX")
        Set objCsHNo = objFields("CSHNO")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrCsHNo(lngCount)
            vntArrStrDate(lngCount) = CDate(objStrDate.Value)
            vntArrEndDate(lngCount) = CDate(objEndDate.Value)
            vntArrPrice(lngCount) = CLng(objPrice.Value)
            vntArrTax(lngCount) = CLng(objTax.Value)
            vntArrCsHNo(lngCount) = CInt(objCsHNo.Value)
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        vntPrice = vntArrPrice
        vntTax = vntArrTax
        vntCsHNo = vntArrCsHNo
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCourseHistory = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectCourseHistory"
    
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
' 機能　　 : 指定期間におけるコース各検査分類ごとの受診項目を取得する
'
' 引数　　 : (In)     strCsCd       コースコード
' 　　　　   (In)     dtmStrDate    開始日
' 　　　　   (In)     dtmEndDate    終了日
' 　　　　   (Out)    vntClassName  検査分類名称
' 　　　　   (Out)    vntItemDiv    項目区分
' 　　　　   (Out)    vntItemCd     項目コード
' 　　　　   (Out)    vntItemName   名称
' 　　　　   (In)     intCdHNo      コース履歴番号（省略可能）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectCourseItemOrderByClass(ByVal strCsCd As String, _
                                             ByVal dtmStrDate As Date, _
                                             ByVal dtmEndDate As Date, _
                                             ByRef vntClassName As Variant, _
                                             ByRef vntItemDiv As Variant, _
                                             ByRef vntItemCd As Variant, _
                                             ByRef vntItemName As Variant, _
                                             Optional ByVal intCdHNo As Integer = -1) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objClassName        As OraField         '検査分類名称
    Dim objItemDiv          As OraField         '項目区分("G":グループ、"I":依頼項目)
    Dim objItemCd           As OraField         'グループコードもしくは依頼項目コード
    Dim objItemName         As OraField         'グループ名もしくは依頼項目名
    
    Dim vntArrClassName()   As Variant          '検査分類名称の配列
    Dim vntArrItemDiv()     As Variant          '項目区分の配列
    Dim vntArrItemCd()      As Variant          'コードの配列
    Dim vntArrItemName()    As Variant          '名称の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntClassName = Empty
    vntItemDiv = Empty
    vntItemCd = Empty
    vntItemName = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSHNO", intCdHNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定コース・適用期間に受診対象となるグループ・依頼項目を取得
    strStmt = "SELECT ITEMCLASS.CLASSCD,   " & vbLf & _
              "       ITEMCLASS.CLASSNAME, " & vbLf & _
              "       ITEMVIEW.ITEMDIV,    " & vbLf & _
              "       ITEMVIEW.ITEMCD,     " & vbLf & _
              "       ITEMVIEW.ITEMNAME    " & vbLf & _
              "  FROM ITEMCLASS,           "
              
    '指定コース・適用期間に受診対象となるグループを取得
    strStmt = strStmt & vbLf & _
              "       ( SELECT GRP_P.CLASSCD,               " & vbLf & _
              "                'G'            ITEMDIV,      " & vbLf & _
              "                COURSE_G.GRPCD ITEMCD,       " & vbLf & _
              "                GRP_P.GRPNAME  ITEMNAME      " & vbLf & _
              "           FROM GRP_P, COURSE_G, COURSE_H    " & vbLf & _
              "          WHERE COURSE_H.CSCD     = :CSCD    " & vbLf & _
              "            AND COURSE_H.ENDDATE >= :STRDATE "

    '終了日指定時は条件追加
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "            AND COURSE_H.STRDATE <= :ENDDATE "
    End If

    '履歴番号直指定の場合は、条件追加
    If intCdHNo > -1 Then
        strStmt = strStmt & vbLf & _
              "            AND COURSE_H.CSHNO = :CSHNO "
    End If
              
    '名称取得のためにグループテーブルを結合
    strStmt = strStmt & vbLf & _
              "            AND COURSE_H.CSCD     = COURSE_G.CSCD  " & vbLf & _
              "            AND COURSE_H.CSHNO    = COURSE_G.CSHNO " & vbLf & _
              "            AND COURSE_G.GRPCD    = GRP_P.GRPCD    "
    
    '指定コース・適用期間に受診対象となる検査項目を取得し、UNION結合
    '(UNION指定により、検査分類コード、項目区分、項目コード順のソートが行われる)
    strStmt = strStmt & vbLf & _
              "          UNION " & vbLf & _
              "         SELECT ITEM_P.CLASSCD,              " & vbLf & _
              "                'I'                ITEMDIV,  " & vbLf & _
              "                COURSE_I.ITEMCD    ITEMCD,   " & vbLf & _
              "                ITEM_P.REQUESTNAME ITEMNAME  " & vbLf & _
              "           FROM ITEM_P, COURSE_I, COURSE_H   " & vbLf & _
              "          WHERE COURSE_H.CSCD     = :CSCD    " & vbLf & _
              "            AND COURSE_H.ENDDATE >= :STRDATE "

    '終了日指定時は条件追加
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "            AND COURSE_H.STRDATE <= :ENDDATE "
    End If

    '履歴番号直指定の場合は、条件追加
    If intCdHNo > -1 Then
        strStmt = strStmt & vbLf & _
              "            AND COURSE_H.CSHNO <= :CSHNO "
    End If

    '名称取得のために依頼項目テーブルを結合
    strStmt = strStmt & vbLf & _
              "            AND COURSE_H.CSCD     = COURSE_I.CSCD  " & vbLf & _
              "            AND COURSE_H.CSHNO    = COURSE_I.CSHNO " & vbLf & _
              "            AND COURSE_I.ITEMCD   = ITEM_P.ITEMCD  " & vbLf & _
              "       ) ITEMVIEW                                  "

    '検査分類テーブルを結合
    strStmt = strStmt & vbLf & _
              " WHERE ITEMVIEW.CLASSCD = ITEMCLASS.CLASSCD        "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objClassName = objFields("CLASSNAME")
        Set objItemDiv = objFields("ITEMDIV")
        Set objItemCd = objFields("ITEMCD")
        Set objItemName = objFields("ITEMNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrClassName(lngCount)
            ReDim Preserve vntArrItemDiv(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            vntArrClassName(lngCount) = objClassName.Value
            vntArrItemDiv(lngCount) = objItemDiv.Value
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrItemName(lngCount) = objItemName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntClassName = vntArrClassName
        vntItemDiv = vntArrItemDiv
        vntItemCd = vntArrItemCd
        vntItemName = vntArrItemName
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCourseItemOrderByClass = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectCourseItemOrderByClass"
    
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
' 機能　　 : 指定期間におけるコース各履歴ごとの受診項目を取得する
'
' 引数　　 : (In)     strCsCd      コースコード
' 　　　　   (In)     dtmStrDate   開始日
' 　　　　   (In)     dtmEndDate   終了日
' 　　　　   (Out)    vntHistory   適用期間
' 　　　　   (Out)    vntItemDiv   項目区分
' 　　　　   (Out)    vntItemCd    項目コード
' 　　　　   (Out)    vntItemName  名称
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCourseItemOrderByHistory( _
    ByVal strCsCd As String, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date, _
    ByRef vntHistory As Variant, _
    ByRef vntItemDiv As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntItemName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemDiv          As OraField         '項目区分("G":グループ、"I":依頼項目)
    Dim objItemCd           As OraField         'グループコードもしくは依頼項目コード
    Dim objItemName         As OraField         'グループ名もしくは依頼項目名
    Dim objStrDate          As OraField         '適用開始日
    Dim objEndDate          As OraField         '適用終了日
    
    Dim vntArrHistory()     As Variant          '適用期間の配列
    Dim vntArrItemDiv()     As Variant          '項目区分の配列
    Dim vntArrItemCd()      As Variant          'コードの配列
    Dim vntArrItemName()    As Variant          '名称の配列
    Dim lngCount            As Long             'レコード数
    
    Dim strItemDiv          As String           '項目区分
    Dim strItemCd           As String           'コード
    Dim strItemName         As String           '名称
    
    Dim strPrevItemDiv      As String           '直前レコードの項目区分
    Dim strPrevItemCd       As String           '直前レコードのコード
    Dim strPrevItemName     As String           '直前レコードの名称
    
    Dim strHistory          As String           '適用期間格納文字列
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntHistory = Empty
    vntItemDiv = Empty
    vntItemCd = Empty
    vntItemName = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '指定コース・適用期間に受診対象となるグループ・依頼項目を取得
    strStmt = "SELECT 'G'               ITEMDIV,         " & vbLf & _
              "       COURSE_G.GRPCD    ITEMCD,          " & vbLf & _
              "       GRP_P.GRPNAME     ITEMNAME,        " & vbLf & _
              "       COURSE_H.STRDATE,                  " & vbLf & _
              "       COURSE_H.ENDDATE                   " & vbLf & _
              "  FROM GRP_P, COURSE_G, COURSE_H          " & vbLf & _
              " WHERE COURSE_H.CSCD     = :CSCD          " & vbLf & _
              "   AND COURSE_H.ENDDATE >= :STRDATE       "
              
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND COURSE_H.STRDATE <= :ENDDATE       "
    End If
    
    strStmt = strStmt & vbLf & _
              "   AND COURSE_H.CSCD     = COURSE_G.CSCD  " & vbLf & _
              "   AND COURSE_H.CSHNO    = COURSE_G.CSHNO " & vbLf & _
              "   AND COURSE_G.GRPCD    = GRP_P.GRPCD    " & vbLf & _
              " UNION                                    " & vbLf & _
              "SELECT 'I'                ITEMDIV,        " & vbLf & _
              "       COURSE_I.ITEMCD    ITEMCD,         " & vbLf & _
              "       ITEM_P.REQUESTNAME ITEMNAME,       " & vbLf & _
              "       COURSE_H.STRDATE,                  " & vbLf & _
              "       COURSE_H.ENDDATE                   " & vbLf & _
              "  FROM ITEM_P, COURSE_I, COURSE_H         " & vbLf & _
              " WHERE COURSE_H.CSCD     = :CSCD          " & vbLf & _
              "   AND COURSE_H.ENDDATE >= :STRDATE       "

    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND COURSE_H.STRDATE <= :ENDDATE       "
    End If
              
    strStmt = strStmt & vbLf & _
              "   AND COURSE_H.CSCD     = COURSE_I.CSCD  " & vbLf & _
              "   AND COURSE_H.CSHNO    = COURSE_I.CSHNO " & vbLf & _
              "   AND COURSE_I.ITEMCD = ITEM_P.ITEMCD    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemDiv = objFields("ITEMDIV")
        Set objItemCd = objFields("ITEMCD")
        Set objItemName = objFields("ITEMNAME")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        
        Do Until objOraDyna.EOF
        
            'レコード内容を取得
            strItemDiv = objItemDiv.Value
            strItemCd = objItemCd.Value
            strItemName = objItemName.Value
            
            '直前レコードと項目が異なる場合
            If strPrevItemDiv <> "" Then
                If strItemDiv <> strPrevItemDiv Or strItemCd <> strPrevItemCd Then
                
                    '適用期間・項目区分・コード・名称を配列形式で格納する
                    ReDim Preserve vntArrHistory(lngCount)
                    ReDim Preserve vntArrItemDiv(lngCount)
                    ReDim Preserve vntArrItemCd(lngCount)
                    ReDim Preserve vntArrItemName(lngCount)
                    vntArrHistory(lngCount) = strHistory
                    vntArrItemDiv(lngCount) = strPrevItemDiv
                    vntArrItemCd(lngCount) = strPrevItemCd
                    vntArrItemName(lngCount) = strPrevItemName
                    lngCount = lngCount + 1
                
                    '適用期間文字列をクリア
                    strHistory = ""
                    
                End If
            End If
            
            '適用開始・終了日を連結し、適用期間として編集
            strHistory = strHistory & IIf(strHistory <> "", ",", "") & objStrDate.Value & "," & objEndDate.Value
        
            '直前レコードの値を現内容で更新する
            strPrevItemDiv = strItemDiv
            strPrevItemCd = strItemCd
            strPrevItemName = strItemName
            
            objOraDyna.MoveNext
        
        Loop
        
        '適用期間文字列が残っている場合は配列に追加する
        If strHistory <> "" Then
            ReDim Preserve vntArrHistory(lngCount)
            ReDim Preserve vntArrItemDiv(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            vntArrHistory(lngCount) = strHistory
            vntArrItemDiv(lngCount) = strPrevItemDiv
            vntArrItemCd(lngCount) = strPrevItemCd
            vntArrItemName(lngCount) = strPrevItemName
            lngCount = lngCount + 1
        End If
        
        '適用期間、項目区分、項目コード順にソート
        SortHistory vntArrHistory, vntArrItemDiv, vntArrItemCd, vntArrItemName, 0, UBound(vntArrHistory)
    
        '戻り値の設定
        vntHistory = vntArrHistory
        vntItemDiv = vntArrItemDiv
        vntItemCd = vntArrItemCd
        vntItemName = vntArrItemName
    
    End If
    
    '戻り値の設定
    SelectCourseItemOrderByHistory = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectCourseItemOrderByHistory"
    
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
' 機能　　 : コースの一覧を取得する
'
' 引数　　 : (Out)    vntCsCd       コースコード
' 　　　　   (Out)    vntCsName     コース名
' 　　　　   (Out)    vntSecondFlg  ２次健診フラグ
' 　　　　   (In)     lngMode       取得モード（0:すべて、1:メインコース（契約可能なもの）のみ、2:サブコースのみ、3:メインコース（全て））
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
'## 2002.12.10 Mod By H.Ishihara@FSIT 取得する項目を増加
'## 2002.11.06 Mod 7Lines By T.Takagi@FSIT 東急対応
'Public Function SelectCourseList(ByRef vntCsCd As Variant, ByRef vntCsName As Variant, Optional ByRef vntSecondFlg As Variant) As Long
Public Function SelectCourseList(ByRef vntCsCd As Variant, _
                                 ByRef vntCsName As Variant, _
                                 Optional ByRef vntSecondFlg As Variant, _
                                 Optional ByVal lngMode As Long = 0, _
                                 Optional ByRef vntMainCsCd As Variant, _
                                 Optional ByRef vntMainCsName As Variant, _
                                 Optional ByRef vntCsDiv As Variant, _
                                 Optional ByRef vntRoundFlg As Variant, _
                                 Optional ByRef vntRegularFlg As Variant) As Long
                            
'## 2002.11.06 Mod End
'## 2002.12.10 Mod End

    Dim objOraDyna          As OraDynaset   'ダイナセット
    Dim strStmt             As String       'SQLステートメント
    
    Dim objFields           As OraFields    'フィールドオブジェクト
    Dim objCsCd             As OraField     'コースコード
    Dim objCsName           As OraField     'コース名
    Dim objSecondFlg        As OraField     '２次健診フラグ
'## 2002.12.10 Add 2Lines By H.Ishihara@FSIT 取得する項目を増加
    Dim objMainCsCd         As OraField     'メインコースコード
    Dim objMainCsName       As OraField     'メインコース名
    Dim objCsDiv            As OraField     'コース区分
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objRoundFlg         As OraField     'まるめフラグ
'## 2003.11.18 Del End
    Dim objRegularFlg       As OraField     '定期健診フラグ
'## 2002.12.10 Add End
    
    Dim vntArrCsCd()        As Variant      'コースコードの配列
    Dim vntArrCsName()      As Variant      'コース名の配列
    Dim vntArrSecondFlg()   As Variant      '２次健診フラグの配列
'## 2002.12.10 Add 2Lines By H.Ishihara@FSIT 取得する項目を増加
    Dim vntArrMainCsCd()    As Variant      'メインコースコード
    Dim vntArrMainCsName()  As Variant      'メインコース名
    Dim vntArrCsDiv()       As Variant      'コース区分
    Dim vntArrRoundFlg()    As Variant      'まるめフラグ
    Dim vntArrRegularFlg()  As Variant      '定期健診フラグ
'## 2002.12.10 Add End
    Dim lngCount            As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCsCd = Empty
    vntCsName = Empty
    If Not IsMissing(vntSecondFlg) Then vntSecondFlg = Empty
    lngCount = 0
    
    'コーステーブル読み込み
'## 2002.11.06 Mod 20Lines By T.Takagi@FSIT 東急対応
'    strStmt = "SELECT CSCD, CSNAME, SECONDFLG " & vbLf & _
               "  FROM COURSE_P                " & vbLf & _
               " ORDER BY CSCD"
'## 2002.12.10 Mod 2Lines By H.Ishihara@FSIT 取得する項目を増加
'    strStmt = "SELECT CSCD, CSNAME, SECONDFLG " & vbLf & _
              "  FROM COURSE_P                "
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = "SELECT COURSE_P.CSCD, COURSE_P.CSNAME, COURSE_P.SECONDFLG,        " & vbLf & _
'              "       COURSE_P.MAINCSCD MAINCSCD, MAINCOURSE.CSNAME MAINCSNAME,  " & vbLf & _
'              "       COURSE_P.CSDIV, COURSE_P.ROUNDFLG, COURSE_P.REGULARFLG     " & vbLf & _
'              "  FROM COURSE_P MAINCOURSE, COURSE_P                              " & vbLf & _
'              " WHERE MAINCOURSE.CSCD = COURSE_P.MAINCSCD                        " & vbLf
    strStmt = "SELECT COURSE_P.CSCD, COURSE_P.CSNAME, COURSE_P.SECONDFLG,       " & vbLf & _
              "       COURSE_P.MAINCSCD MAINCSCD, MAINCOURSE.CSNAME MAINCSNAME, " & vbLf & _
              "       COURSE_P.CSDIV, COURSE_P.REGULARFLG                       " & vbLf & _
              "  FROM COURSE_P MAINCOURSE, COURSE_P                             " & vbLf & _
              " WHERE MAINCOURSE.CSCD = COURSE_P.MAINCSCD                       " & vbLf
'## 2003.11.18 Mod End
'## 2002.12.10 Mod End
              
    'メインコース（契約可能なもの）のみ取得する場合の条件を追加
    If lngMode = 1 Then
'## 2002.12.10 Mod 2Lines By H.Ishihara@FSIT 取得する項目を増加
'        strStmt = strStmt & vbLf & _
              " WHERE CSDIV IN (0, 1) "
        strStmt = strStmt & vbLf & _
              "   AND COURSE_P.CSDIV IN (0, 1) "
'## 2002.12.10 Mod End
    End If
    
    'サブコースのみ取得する場合の条件を追加
    If lngMode = 2 Then
'## 2002.12.10 Mod 2Lines By H.Ishihara@FSIT 取得する項目を増加
'        strStmt = strStmt & vbLf & _
              " WHERE CSDIV IN (0, 3) "
        strStmt = strStmt & vbLf & _
              "   AND COURSE_P.CSDIV IN (0, 3) "
'## 2002.12.10 Mod End
    End If
    
    'メインコース（全て）を取得する場合の条件を追加
    If lngMode = 3 Then
'## 2002.12.10 Mod 2Lines By H.Ishihara@FSIT 取得する項目を増加
'        strStmt = strStmt & vbLf & _
              " WHERE CSDIV != 3"
        strStmt = strStmt & vbLf & _
              "   AND COURSE_P.CSDIV != 3"
'## 2002.12.10 Mod End
    End If
    
'## 2002.12.10 Mod 2Lines By H.Ishihara@FSIT 取得する項目を増加
'    strStmt = strStmt & vbLf & _
              " ORDER BY CSCD"
    strStmt = strStmt & vbLf & _
              " ORDER BY COURSE_P.CSCD"
'## 2002.12.10 Mod End
'## 2002.11.06 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objSecondFlg = objFields("SECONDFLG")
'## 2002.12.10 Add 2Lines By H.Ishihara@FSIT 取得する項目を増加
        Set objMainCsCd = objFields("MAINCSCD")
        Set objMainCsName = objFields("MAINCSNAME")
        Set objCsDiv = objFields("CSDIV")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objRoundFlg = objFields("ROUNDFLG")
'## 2003.11.18 Del End
        Set objRegularFlg = objFields("REGULARFLG")
'## 2002.12.10 Add End
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrSecondFlg(lngCount)
'## 2002.12.10 Add 2Lines By H.Ishihara@FSIT 取得する項目を増加
            ReDim Preserve vntArrMainCsCd(lngCount)
            ReDim Preserve vntArrMainCsName(lngCount)
            ReDim Preserve vntArrCsDiv(lngCount)
            ReDim Preserve vntArrRoundFlg(lngCount)
            ReDim Preserve vntArrRegularFlg(lngCount)
'## 2002.12.10 Add End
            vntArrCsCd(lngCount) = objCsCd.Value
            vntArrCsName(lngCount) = objCsName.Value
            vntArrSecondFlg(lngCount) = objSecondFlg.Value & ""
'## 2002.12.10 Add 2Lines By H.Ishihara@FSIT 取得する項目を増加
            vntArrMainCsCd(lngCount) = objMainCsCd.Value & ""
            vntArrMainCsName(lngCount) = objMainCsName.Value & ""
            vntArrCsDiv(lngCount) = objCsDiv.Value & ""
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'            vntArrRoundFlg(lngCount) = objRoundFlg.Value & ""
            vntArrRoundFlg(lngCount) = ""
'## 2003.11.18 Mod End
            vntArrRegularFlg(lngCount) = objRegularFlg.Value & ""
'## 2002.12.10 Add End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntCsCd = vntArrCsCd
        vntCsName = vntArrCsName
        If Not IsMissing(vntSecondFlg) Then vntSecondFlg = vntArrSecondFlg
'## 2002.12.10 Add 5Lines By H.Ishihara@FSIT 取得する項目を増加
        If Not IsMissing(vntMainCsCd) Then vntMainCsCd = vntArrMainCsCd
        If Not IsMissing(vntMainCsName) Then vntMainCsName = vntArrMainCsName
        If Not IsMissing(vntCsDiv) Then vntCsDiv = vntArrCsDiv
        If Not IsMissing(vntRoundFlg) Then vntRoundFlg = vntArrRoundFlg
        If Not IsMissing(vntRegularFlg) Then vntRegularFlg = vntArrRegularFlg
'## 2002.12.10 Add End
    
    End If
    
    '戻り値の設定
    SelectCourseList = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectCourseList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : コース判定分類の一覧を取得する
'
' 引数　　 : (In)     strCsCd           コースコード
' 　　　　   (Out)    vntJudClassCd     判定分類コード
' 　　　　   (Out)    vntJudClassName   判定分類名
' 　　　　   (Out)    vntNoReason       無条件展開フラグ
' 　　　　   (Out)    vntSeq            表示順番
'
' 戻り値　 : レコード件数
'
' 備考　　 : 指定されたコースコードの判定分類一覧を返す
'
Public Function SelectCourse_JudList(ByVal strCsCd As String, _
                                     ByRef vntJudClassCd As Variant, _
                                     ByRef vntJudClassName As Variant, _
                                     ByRef vntNoReason As Variant, _
                                     ByRef vntSeq As Variant _
                                     ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名
    Dim objNoReason             As OraField         '無条件展開フラグ
    Dim objSeq                  As OraField         '表示順番
    
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名の配列
    Dim vntArrNoReason()        As Variant          '無条件展開フラグの配列
    Dim vntArrSeq()             As Variant          '表示順番の配列
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CsCd", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'コース判定分類テーブルの全レコードを取得
    strStmt = "SELECT CS.JUDCLASSCD, JC.JUDCLASSNAME, CS.NOREASON, CS.SEQ" & vbLf & _
              "  FROM JUDCLASS JC, COURSE_JUD CS" & vbLf & _
              " WHERE CS.CSCD = :CsCd" & vbLf & _
              "   AND CS.JUDCLASSCD = JC.JUDCLASSCD" & vbLf & _
              " ORDER BY SEQ"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objNoReason = objFields("NOREASON")
        Set objSeq = objFields("SEQ")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrNoReason(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrJudClassName(lngCount) = objJudClassName.Value
            vntArrNoReason(lngCount) = objNoReason.Value
            vntArrSeq(lngCount) = objNoReason.Value
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
        '戻り値の設定
        vntJudClassCd = vntArrJudClassCd
        vntJudClassName = vntArrJudClassName
        vntNoReason = vntArrNoReason
        vntSeq = vntArrSeq
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCourse_JudList = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectCourse_JudList"
    
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
' 機能　　 : コース項目実施日の一覧を取得する
'
' 引数　　 : (In)     strCsCd           コースコード
' 　　　　   (Out)    vntOpeClassCd     検査実施日分類コード
' 　　　　   (Out)    vntOpeClassName   検査実施日分類名
' 　　　　   (Out)    vntMonMng         月曜受診時検査日
' 　　　　   (Out)    vntTueMng         火曜受診時検査日
' 　　　　   (Out)    vntWedMng         水曜受診時検査日
' 　　　　   (Out)    vntThuMng         木曜受診時検査日
' 　　　　   (Out)    vntFriMng         金曜受診時検査日
' 　　　　   (Out)    vntSatMng         土曜受診時検査日
' 　　　　   (Out)    vntSunMng         日曜受診時検査日
'
' 戻り値　 : レコード件数
'
' 備考　　 : 指定されたコースコードのコース項目実施日一覧を返す
'
Public Function SelectCourse_OpeList(ByVal strCsCd As String, _
                                     ByRef vntOpeClassCd As Variant, _
                                     ByRef vntOpeClassName As Variant, _
                                     ByRef vntMonMng As Variant, _
                                     ByRef vntTueMng As Variant, _
                                     ByRef vntWedMng As Variant, _
                                     ByRef vntThuMng As Variant, _
                                     ByRef vntFriMng As Variant, _
                                     ByRef vntSatMng As Variant, _
                                     ByRef vntSunMng As Variant _
                                     ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOpeClassCd           As OraField         '検査実施日分類コード
    Dim objOpeClassName         As OraField         '検査実施日分類名
    Dim objMonMng               As OraField         '月曜受診時検査日
    Dim objTueMng               As OraField         '火曜受診時検査日
    Dim objWedMng               As OraField         '水曜受診時検査日
    Dim objThuMng               As OraField         '木曜受診時検査日
    Dim objFriMng               As OraField         '金曜受診時検査日
    Dim objSatMng               As OraField         '土曜受診時検査日
    Dim objSunMng               As OraField         '日曜受診時検査日
    
    Dim vntArrOpeClassCd()      As Variant          '検査実施日分類コードの配列
    Dim vntArrOpeClassName()    As Variant          '検査実施日分類名の配列
    Dim vntArrMonMng()          As Variant          '月曜受診時検査日の配列
    Dim vntArrTueMng()          As Variant          '火曜受診時検査日の配列
    Dim vntArrWedMng()          As Variant          '水曜受診時検査日の配列
    Dim vntArrThuMng()          As Variant          '木曜受診時検査日の配列
    Dim vntArrFriMng()          As Variant          '金曜受診時検査日の配列
    Dim vntArrSatMng()          As Variant          '土曜受診時検査日の配列
    Dim vntArrSunMng()          As Variant          '日曜受診時検査日の配列
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'コース項目実施日テーブルのレコードを取得
    strStmt = "SELECT OPECLASS.OPECLASSCD, OPECLASS.OPECLASSNAME," & vbLf & _
              "       COURSE_OPE.MONMNG,     COURSE_OPE.TUEMNG," & vbLf & _
              "       COURSE_OPE.WEDMNG,     COURSE_OPE.THUMNG," & vbLf & _
              "       COURSE_OPE.FRIMNG,     COURSE_OPE.SATMNG," & vbLf & _
              "       COURSE_OPE.SUNMNG" & vbLf & _
              "  FROM (SELECT OPECLASS.OPECLASSCD, OPECLASS.OPECLASSNAME" & vbLf & _
              "          FROM OPECLASS) OPECLASS, COURSE_OPE" & vbLf & _
              " WHERE OPECLASS.OPECLASSCD = COURSE_OPE.OPECLASSCD(+)" & vbLf & _
              "   AND :CSCD               = COURSE_OPE.CSCD(+)"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOpeClassCd = objFields("OPECLASSCD")
        Set objOpeClassName = objFields("OPECLASSNAME")
        Set objMonMng = objFields("MONMNG")
        Set objTueMng = objFields("TUEMNG")
        Set objWedMng = objFields("WEDMNG")
        Set objThuMng = objFields("THUMNG")
        Set objFriMng = objFields("FRIMNG")
        Set objSatMng = objFields("SATMNG")
        Set objSunMng = objFields("SUNMNG")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOpeClassCd(lngCount)
            ReDim Preserve vntArrOpeClassName(lngCount)
            ReDim Preserve vntArrMonMng(lngCount)
            ReDim Preserve vntArrTueMng(lngCount)
            ReDim Preserve vntArrWedMng(lngCount)
            ReDim Preserve vntArrThuMng(lngCount)
            ReDim Preserve vntArrFriMng(lngCount)
            ReDim Preserve vntArrSatMng(lngCount)
            ReDim Preserve vntArrSunMng(lngCount)
            
            vntArrOpeClassCd(lngCount) = objOpeClassCd.Value
            vntArrOpeClassName(lngCount) = objOpeClassName.Value
            vntArrMonMng(lngCount) = objMonMng.Value & ""
            vntArrTueMng(lngCount) = objTueMng.Value & ""
            vntArrWedMng(lngCount) = objWedMng.Value & ""
            vntArrThuMng(lngCount) = objThuMng.Value & ""
            vntArrFriMng(lngCount) = objFriMng.Value & ""
            vntArrSatMng(lngCount) = objSatMng.Value & ""
            vntArrSunMng(lngCount) = objSunMng.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
        '戻り値の設定
        vntOpeClassCd = vntArrOpeClassCd
        vntOpeClassName = vntArrOpeClassName
        vntMonMng = vntArrMonMng
        vntTueMng = vntArrTueMng
        vntWedMng = vntArrWedMng
        vntThuMng = vntArrThuMng
        vntFriMng = vntArrFriMng
        vntSatMng = vntArrSatMng
        vntSunMng = vntArrSunMng
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCourse_OpeList = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectCourse_OpeList"
    
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
' 機能　　 : コース判定分類を登録する
'
' 引数　　 : (In)    strCsCd           コースコード
' 　　　　   (In)    intItemCount      判定分類個数
' 　　　　   (In)    vntJudClassCd     判定分類コード
' 　　　　   (In)    vntNoReason       無条件展開フラグ
' 　　　　   (In)    vntSeq            表示順番
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCourse_Jud(ByVal strCsCd As String, _
                                 ByVal intItemCount As Integer, _
                                 ByVal vntJudClassCd As Variant, _
                                 ByVal vntNoReason As Variant, _
                                 ByVal vntSeq As Variant _
                                 ) As Long
                               
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objCsCd         As OraParamArray    'コースコード
    Dim objJudClassCd   As OraParamArray    '判定分類コード
    Dim objNoReason     As OraParamArray    '無条件展開フラグ
    Dim objSeq          As OraParamArray    '表示順番

    Dim i               As Integer
    Dim Ret             As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CsCd", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'コース判定分類レコードの削除
    mobjOraDb.ExecuteSQL "DELETE COURSE_JUD WHERE CSCD = :CsCd"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "CsCd"
        
        objOraParam.AddTable "CsCd", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_COURSE_CSCD
        objOraParam.AddTable "JudClassCd", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_JUDCLASS_JUDCLASSCD
        objOraParam.AddTable "NoReason", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_COURSE_JUD_NOREASON
        objOraParam.AddTable "Seq", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_COURSE_JUD_SEQ
        
        'OraParameterオブジェクトの参照設定
        Set objCsCd = objOraParam("CsCd")
        Set objJudClassCd = objOraParam("JudClassCd")
        Set objNoReason = objOraParam("NoReason")
        Set objSeq = objOraParam("Seq")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objCsCd(i) = strCsCd
            objJudClassCd(i) = vntJudClassCd(i)
            objNoReason(i) = vntNoReason(i)
            objSeq(i) = vntSeq(i)
        Next i
        
        '新規挿入
        strStmt = ""
        strStmt = strStmt & "INSERT INTO COURSE_JUD (CSCD, JUDCLASSCD, NOREASON, SEQ) VALUES (:CsCd, :JudClassCd, :NoReason, :Seq)"
    
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistCourse_Jud = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCourse_Jud = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Course.RegistCourse_Jud"
    
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
' 機能　　 : コース項目実施日を登録する
'
' 引数　　 : (In)    strCsCd           コースコード
' 　　　　   (In)    intItemCount      項目実施日個数
' 　　　　   (In)    vntOpeClassCd     項目実施日コード
' 　　　　   (In)    vntMonMng         月曜受診時検査日
' 　　　　   (In)    vntTueMng         火曜受診時検査日
' 　　　　   (In)    vntWedMng         水曜受診時検査日
' 　　　　   (In)    vntThuMng         木曜受診時検査日
' 　　　　   (In)    vntFriMng         金曜受診時検査日
' 　　　　   (In)    vntSatMng         土曜受診時検査日
' 　　　　   (In)    vntSunMng         日曜受診時検査日
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCourse_Ope(ByVal strCsCd As String, _
                                 ByVal intItemCount As Integer, _
                                 ByVal vntOpeClassCd As Variant, _
                                 ByVal vntMonMng As Variant, _
                                 ByVal vntTueMng As Variant, _
                                 ByRef vntWedMng As Variant, _
                                 ByRef vntThuMng As Variant, _
                                 ByRef vntFriMng As Variant, _
                                 ByRef vntSatMng As Variant, _
                                 ByRef vntSunMng As Variant _
                                 ) As Long
                               
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objCsCd         As OraParamArray    'コースコード
    Dim objOpeClassCd   As OraParamArray    '項目実施日コード
    Dim objMonMng       As OraParamArray    '月曜受診時検査日
    Dim objTueMng       As OraParamArray    '火曜受診時検査日
    Dim objWedMng       As OraParamArray    '水曜受診時検査日
    Dim objThuMng       As OraParamArray    '木曜受診時検査日
    Dim objFriMng       As OraParamArray    '金曜受診時検査日
    Dim objSatMng       As OraParamArray    '土曜受診時検査日
    Dim objSunMng       As OraParamArray    '日曜受診時検査日

    Dim i               As Integer
    Dim Ret             As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'コース項目実施日レコードの削除
    mobjOraDb.ExecuteSQL "DELETE COURSE_OPE WHERE CSCD = :CSCD"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "CsCd"
        
        objOraParam.AddTable "CSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_COURSE_CSCD
        objOraParam.AddTable "OPECLASSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_OPECLASS_OPECLASSCD
        objOraParam.AddTable "MONMNG", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "TUEMNG", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "WEDMNG", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "THUMNG", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "FRIMNG", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "SATMNG", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "SUNMNG", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        
        'OraParameterオブジェクトの参照設定
        Set objCsCd = objOraParam("CSCD")
        Set objOpeClassCd = objOraParam("OPECLASSCD")
        Set objMonMng = objOraParam("MONMNG")
        Set objTueMng = objOraParam("TUEMNG")
        Set objWedMng = objOraParam("WEDMNG")
        Set objThuMng = objOraParam("THUMNG")
        Set objFriMng = objOraParam("FRIMNG")
        Set objSatMng = objOraParam("SATMNG")
        Set objSunMng = objOraParam("SUNMNG")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objCsCd(i) = strCsCd
            objOpeClassCd(i) = vntOpeClassCd(i)
            objMonMng(i) = vntMonMng(i)
            objTueMng(i) = vntTueMng(i)
            objWedMng(i) = vntWedMng(i)
            objThuMng(i) = vntThuMng(i)
            objFriMng(i) = vntFriMng(i)
            objSatMng(i) = vntSatMng(i)
            objSunMng(i) = vntSunMng(i)
        Next i
        
        '新規挿入
        strStmt = ""
        strStmt = "INSERT INTO COURSE_OPE " & vbLf & _
                  "       ( CSCD,  OPECLASSCD,  MONMNG,  TUEMNG,  WEDMNG,  THUMNG,  FRIMNG,  SATMNG,  SUNMNG)" & vbLf & _
                  "VALUES (:CSCD, :OPECLASSCD, :MONMNG, :TUEMNG, :WEDMNG, :THUMNG, :FRIMNG, :SATMNG, :SUNMNG)"
    
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistCourse_Ope = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCourse_Ope = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Course.RegistCourse_Ope"
    
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
' 機能　　 : コース各履歴ごとの受診項目情報をソートする
'
' 引数　　 : (In/Out) vntHistory     適用期間
' 　　　　   (In/Out) vntItemDiv     項目区分
' 　　　　   (In/Out) vntItemCd      項目コード
' 　　　　   (In/Out) vntItemName    名称
' 　　　　   (In)     lngStartIndex  ソート開始位置
' 　　　　   (In)     lngEndIndex    ソート終端位置
'
' 戻り値　 :
'
' 備考　　 : 適用期間、項目区分、項目コードの昇順にクイックソートを行う
'
Private Sub SortHistory(ByRef vntHistory As Variant, ByRef vntItemDiv As Variant, ByRef vntItemCd As Variant, ByRef vntItemName As Variant, ByVal lngStartIndex As Long, ByVal lngEndIndex As Long)

    Dim lngMiddleIndex  As Long     '中間位置のインデックス
    Dim vntMiddleKey    As Variant  '中間位置のキー情報
    Dim vntKey          As Variant  '現在検索位置のキー情報
    Dim lngStartPos     As Long     '前方検索の現在位置
    Dim lngEndPos       As Long     '後方検索の現在位置
    
    '開始・終了インデックスからの中間位置を求める
    lngMiddleIndex = (lngStartIndex + lngEndIndex) \ 2
  
    'インデックスの初期設定
    lngStartPos = lngStartIndex
    lngEndPos = lngEndIndex
    
    '中間位置のキー情報配列を作成
    vntMiddleKey = Array(vntHistory(lngMiddleIndex), vntItemDiv(lngMiddleIndex), vntItemCd(lngMiddleIndex))
    
    Do
        '前方から中間位置のキー情報以上の値を検索し、そのインデックスを取得
        Do
            vntKey = Array(vntHistory(lngStartPos), vntItemDiv(lngStartPos), vntItemCd(lngStartPos))
            If CompareKey(vntKey, vntMiddleKey) >= 0 Then
                Exit Do
            End If
            
            lngStartPos = lngStartPos + 1
        Loop
        
        '後方から中間位置のキー情報以下の値を検索し、そのインデックスを取得
        Do
            vntKey = Array(vntHistory(lngEndPos), vntItemDiv(lngEndPos), vntItemCd(lngEndPos))
            If CompareKey(vntKey, vntMiddleKey) <= 0 Then
                Exit Do
            End If
            
            lngEndPos = lngEndPos - 1
        Loop
        
        '前方検索と後方検索が交差すれば検索終了
        If lngStartPos >= lngEndPos Then
            Exit Do
        End If
    
        '前方検索位置と後方検索位置との値を交換
        Swap vntHistory(lngStartPos), vntHistory(lngEndPos)
        Swap vntItemDiv(lngStartPos), vntItemDiv(lngEndPos)
        Swap vntItemCd(lngStartPos), vntItemCd(lngEndPos)
        Swap vntItemName(lngStartPos), vntItemName(lngEndPos)
        
        lngStartPos = lngStartPos + 1
        lngEndPos = lngEndPos - 1
    Loop
  
    '前方検索部分のみでソート
    If lngStartIndex < lngStartPos - 1 Then
        SortHistory vntHistory, vntItemDiv, vntItemCd, vntItemName, lngStartIndex, lngStartPos - 1
    End If
    
    '後方検索部分のみでソート
    If lngEndIndex > lngEndPos + 1 Then
        SortHistory vntHistory, vntItemDiv, vntItemCd, vntItemName, lngEndPos + 1, lngEndIndex
    End If
    
End Sub

'
' 機能　　 : 値の交換
'
' 引数　　 : (In/Out) vntValue1  値1
' 　　　　   (In/Out) vntValue2  値2
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub Swap(ByRef vntValue1 As Variant, ByRef vntValue2 As Variant)

    Dim vntValue    As Variant   '退避域
    
    vntValue = vntValue1
    vntValue1 = vntValue2
    vntValue2 = vntValue
    
End Sub

'
' 機能　　 : 受診者数取得（コース別）
'
' 引数　　 : (In)     strDate               対象日付
' 　　　　 : (Out)    vntCsCode             コースコード
' 　　　　 : (Out)    vntCsName             コース名
' 　　　　 : (Out)    vntWebColor           Webカラー
' 　　　　 : (Out)    vntCsSu               人数
'
' 戻り値　 :レコード数
'
' 備考　　 :
'
Public Function SelectSelDateCourse( _
                                ByVal strDate As String, _
                                ByRef vntCsCode As Variant, _
                                ByRef vntCsName As Variant, _
                                ByRef vntWebColor As Variant, _
                                ByRef vntCsSu As Variant _
                            ) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    
    Dim objDate         As OraField         '指定日付
    Dim objCsCode       As OraField         'コースコード
    Dim objCsName       As OraField         'コース名
    Dim objWebColor     As OraField         'Webカラー
    Dim objCsSu         As OraField         'コース人数
    
'    Dim objCommon       As Common           '共通クラス
    
    Dim vntArrDate()      As Variant          '指定日付
    Dim vntArrCsCode()    As Variant          'コースコード
    Dim vntArrCsName()    As Variant          'コース名
    Dim vntArrWebColor()  As Variant          'Webカラー
    Dim vntArrCsSu()      As Variant          'コース人数
    
    Dim lngCount        As Long             'レコード数
    
    '初期値
    vntCsCode = Empty
    vntCsName = Empty
    vntWebColor = Empty
    vntCsSu = Empty
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SELDATE", strDate, ORAPARM_INPUT, ORATYPE_DATE
    
    'BBSテーブルから取得
    strStmt = "SELECT CONSULT.CSCD,COURSE_P.CSNAME,WEBCOLOR,COUNT(CONSULT.PERID) AS CSSU" & vbLf & _
              "  FROM COURSE_P, CONSULT" & vbLf & _
              " WHERE COURSE_P.CSCD     = CONSULT.CSCD" & vbLf & _
              "   AND CONSULT.CANCELFLG = '0'" & vbLf & _
              "   AND CONSULT.CSLDATE   = :SELDATE" & vbLf & _
              " GROUP BY CONSULT.CSCD,WEBCOLOR,COURSE_P.CSNAME"

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
'        Set objCommon = New Common
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCode = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsSu = objFields("CSSU")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
'            objCommon.AppendArray vntArrCsCode, objCsCode.Value
'            objCommon.AppendArray vntArrCsName, objCsName.Value
'            objCommon.AppendArray vntArrWebColor, objWebColor.Value
'            objCommon.AppendArray vntArrCsSu, objCsSu.Value
            
            ReDim Preserve vntArrCsCode(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrCsSu(lngCount)
            
            vntArrCsCode(lngCount) = objCsCode.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrCsSu(lngCount) = objCsSu.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntCsCode = vntArrCsCode
    vntCsName = vntArrCsName
    vntWebColor = vntArrWebColor
    vntCsSu = vntArrCsSu
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    SelectSelDateCourse = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectSelDateCourse"
    
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
    Dim strStmt     As String           'SQLステートメント
    
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
