VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Calendar"
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
' 機能　　 : 指定年月の予約空き状況取得
'
' 引数　　 : (In)     strMode         検索モード
' 　　　　   (In)     lngCslYear      年
' 　　　　   (In)     lngCslMonth     月
' 　　　　   (In)     vntPerId        個人ＩＤ
' 　　　　   (In)     vntManCnt       人数
' 　　　　   (In)     vntGender       性別
' 　　　　   (In)     vntBirth        生年月日
' 　　　　   (In)     vntAge          受診時年齢
' 　　　　   (In)     vntCslDivCd     受診区分コード
' 　　　　   (In)     vntCsCd         コースコード
' 　　　　   (In)     vntRsvGrpCd     予約群コード
' 　　　　   (In)     vntCtrPtCd      契約パターンコード
' 　　　　   (In)     vntOptCd        オプションコード
' 　　　　   (In)     vntOptBranchNo  オプション枝番
' 　　　　   (Out)    vntCslDate      受診日
' 　　　　   (Out)    vntHoliday      休診日
' 　　　　   (Out)    vntStatus       状態
'
' 戻り値　 : 日数
'
' 備考　　 :
'
Public Function GetEmptyCalendar( _
    ByVal strMode As String, _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByRef vntPerId As Variant, _
    ByRef vntManCnt As Variant, _
    ByRef vntGender As Variant, _
    ByRef vntBirth As Variant, _
    ByRef vntAge As Variant, _
    ByRef vntCsCd As Variant, _
    ByRef vntCslDivCd As Variant, _
    ByRef vntRsvGrpCd As Variant, _
    ByRef vntCtrPtCd As Variant, _
    ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, _
    ByRef vntCslDate As Variant, _
    ByRef vntHoliday As Variant, _
    ByRef vntStatus As Variant _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objPerId        As OraParamArray    '個人ＩＤ
    Dim objManCnt       As OraParamArray    '人数
    Dim objGender       As OraParamArray    '性別
    Dim objBirth        As OraParamArray    '生年月日
    Dim objAge          As OraParamArray    '受診時年齢
    Dim objCslDivCd     As OraParamArray    '受診区分コード
    Dim objCsCd         As OraParamArray    'コースコード
    Dim objRsvGrpCd     As OraParamArray    '予約群コード
    Dim objCtrPtCd      As OraParamArray    '契約パターンコード
    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objOptBranchNo  As OraParamArray    'オプション枝番
    
    Dim objCslDate      As OraParamArray    '受診日
    Dim objHoliday      As OraParamArray    '休診日
    Dim objStatus       As OraParamArray    '状態

    Dim lngInArraySize  As Long             '配列のサイズ
    Dim lngOutArraySize As Long             '配列のサイズ

    Dim vntArrCslDate() As Variant          '受診日
    Dim vntArrHoliday() As Variant          '休診日
    Dim vntArrStatus()  As Variant          '状態
    Dim lngCount        As Long             'レコード数
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntCslDate = Empty
    vntHoliday = Empty
    vntStatus = Empty

    'バインド変数の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "MODE", strMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLYEAR", lngCslYear, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLMONTH", lngCslMonth, ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値の仮の配列として個人ＩＤの配列サイズを指定
    lngInArraySize = UBound(vntPerId) + 1

    'バインド配列(引数)の設定
    objOraParam.AddTable "PERID", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, LENGTH_PERSON_PERID
    objOraParam.AddTable "MANCNT", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "GENDER", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "BIRTH", ORAPARM_INPUT, ORATYPE_DATE, lngInArraySize
    objOraParam.AddTable "AGE", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "CSLDIVCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, 12
    objOraParam.AddTable "CSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, LENGTH_COURSE_CSCD
    objOraParam.AddTable "RSVGRPCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "CTRPTCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, 500
    objOraParam.AddTable "OPTBRANCHNO", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, 300

    '戻り値の仮の配列として日数の最大値である31を設定
    lngOutArraySize = 31
    
    'バインド配列(戻り値)の設定
    objOraParam.AddTable "CSLDATE", ORAPARM_OUTPUT, ORATYPE_DATE, lngOutArraySize
    objOraParam.AddTable "HOLIDAY", ORAPARM_OUTPUT, ORATYPE_NUMBER, lngOutArraySize
    objOraParam.AddTable "STATUS", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngOutArraySize, 1

    'オブジェクトの参照設定
    Set objPerId = objOraParam("PERID")
    Set objManCnt = objOraParam("MANCNT")
    Set objGender = objOraParam("GENDER")
    Set objBirth = objOraParam("BIRTH")
    Set objAge = objOraParam("AGE")
    Set objCslDivCd = objOraParam("CSLDIVCD")
    Set objCsCd = objOraParam("CSCD")
    Set objRsvGrpCd = objOraParam("RSVGRPCD")
    Set objCtrPtCd = objOraParam("CTRPTCD")
    Set objOptCd = objOraParam("OPTCD")
    Set objOptBranchNo = objOraParam("OPTBRANCHNO")
    Set objCslDate = objOraParam("CSLDATE")
    Set objHoliday = objOraParam("HOLIDAY")
    Set objStatus = objOraParam("STATUS")

    '引数値の値設定
    For i = 0 To lngInArraySize - 1
        objPerId(i) = CStr(vntPerId(i))
        objManCnt(i) = IIf(vntManCnt(i) <> "", CLng("0" & vntManCnt(i)), Null)
        objGender(i) = IIf(vntGender(i) <> "", CLng("0" & vntGender(i)), Null)
        objBirth(i) = IIf(vntBirth(i) <> "", CDate("0" & vntBirth(i)), Null)
        objAge(i) = IIf(vntAge(i) <> "", CLng("0" & vntAge(i)), Null)
        objCslDivCd(i) = CStr(vntCslDivCd(i))
        objCsCd(i) = CStr(vntCsCd(i))
        objRsvGrpCd(i) = IIf(vntRsvGrpCd(i) <> "", CLng("0" & vntRsvGrpCd(i)), Null)
        objCtrPtCd(i) = CLng(vntCtrPtCd(i))
        objOptCd(i) = CStr(vntOptCd(i))
        objOptBranchNo(i) = CStr(vntOptBranchNo(i))
    Next i

    'ストアド呼び出し
    strStmt = "BEGIN                                 " & vbLf & _
              "    SchedulePackage.GetEmptyCalendar( " & vbLf & _
              "        :MODE,                        " & vbLf & _
              "        :CSLYEAR,                     " & vbLf & _
              "        :CSLMONTH,                    " & vbLf & _
              "        :PERID,                       " & vbLf & _
              "        :MANCNT,                      " & vbLf & _
              "        :GENDER,                      " & vbLf & _
              "        :BIRTH,                       " & vbLf & _
              "        :AGE,                         " & vbLf & _
              "        :CSLDIVCD,                    " & vbLf & _
              "        :CSCD,                        " & vbLf & _
              "        :RSVGRPCD,                    " & vbLf & _
              "        :CTRPTCD,                     " & vbLf & _
              "        :OPTCD,                       " & vbLf & _
              "        :OPTBRANCHNO,                 " & vbLf & _
              "        :CSLDATE,                     " & vbLf & _
              "        :HOLIDAY,                     " & vbLf & _
              "        :STATUS                       " & vbLf & _
              "    );                                " & vbLf & _
              "END;                                  "

    mobjOraDb.ExecuteSQL strStmt

    'バインド配列内容の検索
    Do Until lngCount >= objCslDate.ArraySize
        
        '受診日が格納されていなければここで終了
        If objCslDate(lngCount) = "" Then
            Exit Do
        End If
        
        '配列形式で格納する
        ReDim Preserve vntArrCslDate(lngCount)
        ReDim Preserve vntArrHoliday(lngCount)
        ReDim Preserve vntArrStatus(lngCount)
        vntArrCslDate(lngCount) = CStr(objCslDate(lngCount))
        vntArrHoliday(lngCount) = objHoliday(lngCount)
        vntArrStatus(lngCount) = CStr(objStatus(lngCount) & "")
        lngCount = lngCount + 1
    
    Loop

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    vntCslDate = vntArrCslDate
    vntHoliday = vntArrHoliday
    vntStatus = vntArrStatus
    
    GetEmptyCalendar = lngCount

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Calendar.GetEmptyCalendar"
    
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

'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更
'
' 機能　　 : 指定年月の予約空き状況取得(予約番号指定)
'
' 引数　　 : (In)     strMode      検索モード
' 　　　　   (In)     lngCslYear   年
' 　　　　   (In)     lngCslMonth  月
' 　　　　   (In)     vntRsvNo     予約番号
' 　　　　   (In)     vntRsvGrpCd  予約群コード
' 　　　　   (Out)    vntCslDate   受診日
' 　　　　   (Out)    vntHoliday   休診日
' 　　　　   (Out)    vntStatus    状態
'
' 戻り値　 : 0以上  日数
' 　　　　   -1     存在しない予約番号が指定された
' 　　　　   -2     受付済み、またはキャンセル受診情報が存在するため検索不能
'
' 備考　　 :
'
Public Function GetEmptyCalendarFromRsvNo( _
    ByVal strMode As String, _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByRef vntRsvNo As Variant, _
    ByRef vntRsvGrpCd As Variant, _
    ByRef vntCslDate As Variant, _
    ByRef vntHoliday As Variant, _
    ByRef vntStatus As Variant _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objRsvNo        As OraParamArray    '予約番号
    Dim objRsvGrpCd     As OraParamArray    '予約群コード
    
    Dim objCslDate      As OraParamArray    '受診日
    Dim objHoliday      As OraParamArray    '休診日
    Dim objStatus       As OraParamArray    '状態

    Dim lngInArraySize  As Long             '配列のサイズ
    Dim lngOutArraySize As Long             '配列のサイズ

    Dim vntArrCslDate() As Variant          '受診日
    Dim vntArrHoliday() As Variant          '休診日
    Dim vntArrStatus()  As Variant          '状態
    Dim lngCount        As Long             'レコード数
    
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntCslDate = Empty
    vntHoliday = Empty
    vntStatus = Empty

    'バインド変数の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "MODE", strMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLYEAR", lngCslYear, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLMONTH", lngCslMonth, ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値の仮の配列として予約番号の配列サイズを指定
    lngInArraySize = UBound(vntRsvNo) + 1

    'バインド配列(引数)の設定
    objOraParam.AddTable "RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "RSVGRPCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize

    '戻り値の仮の配列として日数の最大値である31を設定
    lngOutArraySize = 31
    
    'バインド変数(戻り値)の設定
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    'バインド配列(戻り値)の設定
    objOraParam.AddTable "CSLDATE", ORAPARM_OUTPUT, ORATYPE_DATE, lngOutArraySize
    objOraParam.AddTable "HOLIDAY", ORAPARM_OUTPUT, ORATYPE_NUMBER, lngOutArraySize
    objOraParam.AddTable "STATUS", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngOutArraySize, 1

    'オブジェクトの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objRsvGrpCd = objOraParam("RSVGRPCD")
    Set objCslDate = objOraParam("CSLDATE")
    Set objHoliday = objOraParam("HOLIDAY")
    Set objStatus = objOraParam("STATUS")

    '引数値の値設定
    For i = 0 To lngInArraySize - 1
        objRsvNo(i) = CLng(vntRsvNo(i))
        objRsvGrpCd(i) = IIf(vntRsvGrpCd(i) <> "", CLng("0" & vntRsvGrpCd(i)), Null)
    Next i

    'ストアド呼び出し
    strStmt = "BEGIN                                                  " & vbLf & _
              "    :RET := SchedulePackage.GetEmptyCalendarFromRsvNo( " & vbLf & _
              "        :MODE,                                         " & vbLf & _
              "        :CSLYEAR,                                      " & vbLf & _
              "        :CSLMONTH,                                     " & vbLf & _
              "        :RSVNO,                                        " & vbLf & _
              "        :RSVGRPCD,                                     " & vbLf & _
              "        :CSLDATE,                                      " & vbLf & _
              "        :HOLIDAY,                                      " & vbLf & _
              "        :STATUS                                        " & vbLf & _
              "    );                                                 " & vbLf & _
              "END;                                                   "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value
    
    '正常時
    If Ret = 0 Then
    
        'バインド配列内容の検索
        Do Until lngCount >= objCslDate.ArraySize
            
            '受診日が格納されていなければここで終了
            If objCslDate(lngCount) = "" Then
                Exit Do
            End If
            
            '配列形式で格納する
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrHoliday(lngCount)
            ReDim Preserve vntArrStatus(lngCount)
            vntArrCslDate(lngCount) = CStr(objCslDate(lngCount))
            vntArrHoliday(lngCount) = objHoliday(lngCount)
            vntArrStatus(lngCount) = CStr(objStatus(lngCount) & "")
            lngCount = lngCount + 1
        
        Loop

        Ret = lngCount
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    vntCslDate = vntArrCslDate
    vntHoliday = vntArrHoliday
    vntStatus = vntArrStatus
    
    GetEmptyCalendarFromRsvNo = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Calendar.GetEmptyCalendarFromRsvNo"
    
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

'## 2003.12.07 Add Function By T.Takagi@FSIT
'
' 機能　　 : 指定受診日の予約枠空き状況を取得
'
' 引数　　 : (In)     strMode         検索モード
' 　　　　   (In)     dtmCslDate      受診日
' 　　　　   (In)     vntPerId        個人ＩＤ
' 　　　　   (In)     vntManCnt       人数
' 　　　　   (In)     vntGender       性別
' 　　　　   (In)     vntBirth        生年月日
' 　　　　   (In)     vntAge          受診時年齢
' 　　　　   (In)     vntCslDivCd     受診区分コード
' 　　　　   (In)     vntCsCd         コースコード
' 　　　　   (In)     vntRsvGrpCd     予約群コード
' 　　　　   (In)     vntCtrPtCd      契約パターンコード
' 　　　　   (In)     vntOptCd        オプションコード
' 　　　　   (In)     vntOptBranchNo  オプション枝番
' 　　　　   (Out)    vntHoliday      休診日
' 　　　　   (Out)    vntStatus       状態
' 　　　　   (Out)    vntFindRsvGrpCd 各検索条件に対して検索された予約群のコレクション
'
' 戻り値　 : 日数
'
' 備考　　 :
'
Public Sub GetEmptyStatus( _
    ByVal strMode As String, _
    ByVal dtmCslDate As Date, _
    ByRef vntPerId As Variant, _
    ByRef vntManCnt As Variant, _
    ByRef vntGender As Variant, _
    ByRef vntBirth As Variant, _
    ByRef vntAge As Variant, _
    ByRef vntCsCd As Variant, _
    ByRef vntCslDivCd As Variant, _
    ByRef vntRsvGrpCd As Variant, _
    ByRef vntCtrPtCd As Variant, _
    ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, _
    ByRef vntHoliday As Variant, _
    ByRef vntStatus As Variant, _
    ByRef vntFindRsvGrpCd As Variant _
)
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objPerId            As OraParamArray    '個人ＩＤ
    Dim objManCnt           As OraParamArray    '人数
    Dim objGender           As OraParamArray    '性別
    Dim objBirth            As OraParamArray    '生年月日
    Dim objAge              As OraParamArray    '受診時年齢
    Dim objCslDivCd         As OraParamArray    '受診区分コード
    Dim objCsCd             As OraParamArray    'コースコード
    Dim objRsvGrpCd         As OraParamArray    '予約群コード
    Dim objCtrPtCd          As OraParamArray    '契約パターンコード
    Dim objOptCd            As OraParamArray    'オプションコード
    Dim objOptBranchNo      As OraParamArray    'オプション枝番
    
    Dim objHoliday          As OraParameter     '休診日
    Dim objStatus           As OraParameter     '状態
    Dim objFindRsvGrpCd     As OraParamArray    '検索された予約群のコレクション

    Dim lngInArraySize      As Long             '配列のサイズ
    Dim lngOutArraySize     As Long             '配列のサイズ

    Dim vntArrRsvGrpCd()    As Variant          '検索された予約群のコレクション
    
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntHoliday = Empty
    vntStatus = Empty
    vntFindRsvGrpCd = Empty

    'バインド変数の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "MODE", strMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '戻り値の仮の配列として個人ＩＤの配列サイズを指定
    lngInArraySize = UBound(vntPerId) + 1

    'バインド配列(引数)の設定
    objOraParam.AddTable "PERID", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, LENGTH_PERSON_PERID
    objOraParam.AddTable "MANCNT", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "GENDER", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "BIRTH", ORAPARM_INPUT, ORATYPE_DATE, lngInArraySize
    objOraParam.AddTable "AGE", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "CSLDIVCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, 12
    objOraParam.AddTable "CSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, LENGTH_COURSE_CSCD
    objOraParam.AddTable "RSVGRPCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "CTRPTCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngInArraySize
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, 500
    objOraParam.AddTable "OPTBRANCHNO", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngInArraySize, 300

    '戻り値の仮の配列として日数の最大値である31を設定
    lngOutArraySize = 31
    
    '戻り値の設定
    objOraParam.Add "HOLIDAY", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "STATUS", Null, ORAPARM_OUTPUT, ORATYPE_VARCHAR2
    
    '予約群の配列サイズは検索条件のそれといっしょ
    objOraParam.AddTable "FINDRSVGRPCD", ORAPARM_OUTPUT, ORATYPE_NUMBER, lngInArraySize

    'オブジェクトの参照設定
    Set objPerId = objOraParam("PERID")
    Set objManCnt = objOraParam("MANCNT")
    Set objGender = objOraParam("GENDER")
    Set objBirth = objOraParam("BIRTH")
    Set objAge = objOraParam("AGE")
    Set objCslDivCd = objOraParam("CSLDIVCD")
    Set objCsCd = objOraParam("CSCD")
    Set objRsvGrpCd = objOraParam("RSVGRPCD")
    Set objCtrPtCd = objOraParam("CTRPTCD")
    Set objOptCd = objOraParam("OPTCD")
    Set objOptBranchNo = objOraParam("OPTBRANCHNO")
    
    Set objHoliday = objOraParam("HOLIDAY")
    Set objStatus = objOraParam("STATUS")
    Set objFindRsvGrpCd = objOraParam("FINDRSVGRPCD")

    '引数値の値設定
    For i = 0 To lngInArraySize - 1
        objPerId(i) = CStr(vntPerId(i))
        objManCnt(i) = IIf(vntManCnt(i) <> "", CLng("0" & vntManCnt(i)), Null)
        objGender(i) = IIf(vntGender(i) <> "", CLng("0" & vntGender(i)), Null)
        objBirth(i) = IIf(vntBirth(i) <> "", CDate("0" & vntBirth(i)), Null)
        objAge(i) = IIf(vntAge(i) <> "", CLng("0" & vntAge(i)), Null)
        objCslDivCd(i) = CStr(vntCslDivCd(i))
        objCsCd(i) = CStr(vntCsCd(i))
        objRsvGrpCd(i) = IIf(vntRsvGrpCd(i) <> "", CLng("0" & vntRsvGrpCd(i)), Null)
        objCtrPtCd(i) = CLng(vntCtrPtCd(i))
        objOptCd(i) = CStr(vntOptCd(i))
        objOptBranchNo(i) = CStr(vntOptBranchNo(i))
    Next i

    'ストアド呼び出し
    strStmt = "BEGIN                               " & vbLf & _
              "    SchedulePackage.GetEmptyStatus( " & vbLf & _
              "        :MODE,                      " & vbLf & _
              "        :CSLDATE,                   " & vbLf & _
              "        :PERID,                     " & vbLf & _
              "        :MANCNT,                    " & vbLf & _
              "        :GENDER,                    " & vbLf & _
              "        :BIRTH,                     " & vbLf & _
              "        :AGE,                       " & vbLf & _
              "        :CSLDIVCD,                  " & vbLf & _
              "        :CSCD,                      " & vbLf & _
              "        :RSVGRPCD,                  " & vbLf & _
              "        :CTRPTCD,                   " & vbLf & _
              "        :OPTCD,                     " & vbLf & _
              "        :OPTBRANCHNO,               " & vbLf & _
              "        :HOLIDAY,                   " & vbLf & _
              "        :STATUS,                    " & vbLf & _
              "        :FINDRSVGRPCD               " & vbLf & _
              "    );                              " & vbLf & _
              "END;                                "

    mobjOraDb.ExecuteSQL strStmt

    '配列形式で格納する
    ReDim Preserve vntArrRsvGrpCd(lngInArraySize - 1)
    For i = 0 To lngInArraySize - 1
        vntArrRsvGrpCd(i) = Trim(CStr(objFindRsvGrpCd(i) & ""))
    Next i

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    vntHoliday = CStr(objHoliday.Value & "")
    vntStatus = CStr(objStatus.Value & "")
    vntFindRsvGrpCd = vntArrRsvGrpCd
    
    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Calendar.GetEmptyStatus"
    
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
    
End Sub

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

