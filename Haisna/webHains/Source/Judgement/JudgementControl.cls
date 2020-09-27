VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "JudgementControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号: SL-UI-Y0101-101
'修正日  ：2010.07.23
'担当者  ：TCS)田村
'修正内容: 自動判定時の総合コメント並び替え追加
'----------------------------
'管理番号:
'修正日  ：2013.03.29
'担当者  ：SL)張
'修正内容: HbA1c判定項目変更（HbA1c(JDS)→HbA1c(NGSP)）に伴う仕様変更


Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const AUTOJUDUSER               As String = "AUTOJUD"   '自動判定ユーザ
Private Const TOTALCMT_DISPMODE         As Long = 1             '総合コメント表示モード（総合コメント）
Private Const NYUBOU_JUDCLASSCD         As Long = 24            '乳房　判定分類コード
'### 眼科判定特殊処理用追加 2004.01.14 start
Private Const GANKA_JUDCLASSCD          As Long = 20          '眼科・眼圧　判定分類コード
'### 眼科判定特殊処理用追加 2004.01.14 end

'### 骨密度判定特殊処理用追加 2007.11.19 start
Private Const KOTSU_JUDCLASSCD          As Long = 23          '骨密度　判定分類コード
'### 骨密度判定特殊処理用追加 2007.11.19 end

'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために追加 Start
Private Const DIS_COMMENT               As String = "DIS"   '汎用マスターコード（婦人科以外現病歴関連総合コメント）
Private Const GYN_COMMENT               As String = "GYN"   '汎用マスターコード（婦人科関連現病歴関連総合コメント）
Private Const TOT_COMMENT               As String = "TOT"   '汎用マスターコード（すべて現病歴関連総合コメント）
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために追加 End

'### メタボリックシンドローム判定ロジック変更日追加（日付比較用） 2008.03.05 張
Private Const META_CDATE_20080401       As String = "2008/04/01"   'メタボリックシンドローム判定ロジック適用基準日

'### HbA1c判定基準変更（HbA1c(JDS)→HbA1c(NGSP)）に伴う判定ロジック変更日追加（日付比較用） 2013.03.29 張
Private Const HBA1C_CDATE_20130401      As String = "2013/04/01"   'HbA1c判定基準変更（HbA1c(JDS)→HbA1c(NGSP)）基準日

'### 喫煙総合コメント自動登録ロジック対応日追加（日付比較用） 2008.05.14 張
Private Const SMOKE_CDATE               As String = "2008/05/01"   '喫煙総合コメント自動登録ロジック適用基準日

'桁数
Private Const LENGTH_RECEIPT_DAYID      As Integer = 4      '当日ＩＤ
Private Const LENGTH_FREEJUDCMT         As Integer = 500    'フリー判定コメント

'## 2012.09.12 Add by T.Takagi@RD 切替日付による判定実施項目制御
Private Const FREECD_CHG201210 = "CHG201210"    '2012年対応　変更日付取得用

'
' 機能　　 : 指定された条件の計算処理を起動する
'
' 引数　　 : (In)     strUpdUser          更新者
' 　　　　   (In)     strIpAddress        ＩＰアドレス
' 　　　　   (In)     strCslDate          受診日
' 　　　　   (In)     vntCalcFlg          配列（Ａ型行動パターン,栄養計算,失点判定,
'                                              ストレス点数, 自動判定)
'                                         0:計算非対象　1:計算対象
' 　　　　   (In)     lngDayIdFlg         1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId         検索開始ＩＤ
' 　　　　   (In)     lngEndDayId         検索終了ＩＤ
' 　　　　   (In)     vntArrDayId         検索ＩＤ（配列）
' 　　　　   (In)     strCsCd             コースコード
' 　　　　   (In)     strJudClassCd       判定分類コード
' 　　　　   (In)     lngEntryCheck       未入力チェックフラグ(0:未入力チェックしない 1:する)
' 　　　　   (In)     lngReJudge          再判定フラグ(0:再判定しない 1:する)
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function JudgeAutomaticallyMain( _
    ByVal strUpdUser As String, _
    ByVal strIpAddress As String, _
    ByVal strCslDate As String, _
    ByRef vntCalcFlg As Variant, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal lngEntryCheck As Long, _
    ByVal lngReJudge As Long _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objArrDayId         As OraParamArray    '当日ＩＤ
    
    Dim objRet              As OraParameter     '関数復帰値
    
    Dim objJudgement        As Object           '判定情報アクセス用
'#### 2010.07.23 SL-UI-Y0101-101 ADD START ####　総合コメント並び替え関数追加'
    Dim objInterview        As Object
'#### 2010.07.23 SL-UI-Y0101-101 ADD END ####　'
    
    Dim lngArraySize        As Long             '配列サイズ

    Dim i                   As Long             'ループカウンタ
    
    Dim lngMsgCnt           As Long             'エラーメッセージ件数
    
    Dim Ret                 As Long             '復帰値
    Dim blnRet              As Long             '復帰値

'## 2012.09.12 Add by T.Takagi@RD 切替日付による判定実施項目制御
    Dim objFree             As Object           '汎用情報アクセス用
    Dim vntChgDate          As Variant          '切替日
    Dim blnActNutrition     As Boolean          '栄養指導判定有無
    Dim blnActEatingHabits  As Boolean          '食習慣判定有無
'## 2012.09.12 Add End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    

    'オブジェクトのインスタンス作成
    Set objJudgement = mobjContext.CreateInstance("HainsJudgement.Judgement")
    
    If lngDayIdFlg = 2 Then
        '配列数
        lngArraySize = UBound(vntArrDayId) + 1
    Else
        lngArraySize = 1
    End If

    Ret = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDATE", strCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DAYIDFLG", lngDayIdFlg, ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004.01.22 Mod start 大小逆を指定された場合の対応ができていなかった
'    objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004.01.23 複数指定されたときは開始／終了ＩＤが数値ではない　（条件追加）
    If IsNumeric(lngStrDayId) And IsNumeric(lngEndDayId) Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
        objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'### 2004.01.22 Mod end  大小逆を指定された場合の対応ができていなかった
    objOraParam.AddTable "ARRDAYID", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_RECEIPT_DAYID

    If lngDayIdFlg = 2 Then
        Set objArrDayId = objOraParam("ARRDAYID")
    
        'OraParameterオブジェクトの値設定
        For i = 0 To lngArraySize - 1
            objArrDayId(i) = vntArrDayId(i)
        Next i
    End If
    
'## 2012.09.12 Add by T.Takagi@RD 切替日付による判定実施項目制御
    Set objFree = CreateObject("HainsFree.Free")

    '切替日の取得
    objFree.SelectFree 0, FREECD_CHG201210, , , , vntChgDate

    '切替日以降の受診日であれば食習慣を、さもなくば栄養指導を判定
    If vntChgDate <> "" And CDate(strCslDate) >= CDate(vntChgDate) Then
        blnActEatingHabits = True
    Else
        blnActNutrition = True
    End If
'## 2012.09.11 Add End
    
    For i = 0 To 3
        If vntCalcFlg(i) = 1 Then
            Select Case i
                'Ａ型行動パターン
                Case 0
                    'Ａ型行動パターン計算ストアド呼び出し
                    mobjOraDb.ExecuteSQL "BEGIN :RET := APatternCalcPackage.APatternCalc(:UPDUSER, :IPADDRESS, :CSLDATE,:CSCD,:DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
                '失点判定
                Case 1
                    '失点判定ストアド呼び出し
                    mobjOraDb.ExecuteSQL "BEGIN :RET := LostPointCalcPackage.LostPointCalc(:UPDUSER, :IPADDRESS, :CSLDATE,:CSCD,:DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
                '栄養計算
                Case 2
                    '栄養計算ストアド呼び出し
'## 2012.09.12 Update by T.Takagi@RD 切替日付による判定実施項目制御
                    'mobjOraDb.ExecuteSQL "BEGIN :RET := NutritionCalcPackage.NutritionCalc(:UPDUSER, :IPADDRESS, :CSLDATE,:CSCD, :DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
                    If blnActNutrition Then
                        mobjOraDb.ExecuteSQL "BEGIN :RET := NutritionCalcPackage.NutritionCalc(:UPDUSER, :IPADDRESS, :CSLDATE,:CSCD, :DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
                    End If
'## 2012.09.12 Update End
                'ストレス点数
                Case 3
                    'ストレス計算ストアド呼び出し
                    mobjOraDb.ExecuteSQL "BEGIN :RET := StressCalcPackage.StressCalc(:UPDUSER, :IPADDRESS, :CSLDATE,:CSCD,:DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
            End Select
        End If
    Next i

'### 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 Start
'### 2008.04.01 以降の受診者のみ判定処理
'### 2013.03.30 HbA1c(NGSP)値対応は、SpecialMetaCalcPackage.SpecialMetaCalc()中で行う
    If vntCalcFlg(6) = 1 And CDate(strCslDate) >= CDate(META_CDATE_20080401) Then
        mobjOraDb.ExecuteSQL "BEGIN :RET := SpecialMetaCalcPackage.SpecialMetaCalc(:UPDUSER, :IPADDRESS, :CSLDATE,:CSCD,:DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
    End If
'### 2008.03.04 張 特定健診（階層化）自動判定ロジック追加 End


'## 2012.09.12 Add by T.Takagi@RD 食習慣の自動判定
    If blnActEatingHabits And (vntCalcFlg(7) = 1) Then
        mobjOraDb.ExecuteSQL "BEGIN :RET := EatingHabitsCalcPackage.EatingHabitsCalc(:UPDUSER, :IPADDRESS, :CSLDATE, :CSCD, :DAYIDFLG, :STRDAYID, :ENDDAYID, :ARRDAYID); END;"
    End If
'## 2012.09.12 Add End

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために追加 Start
    '自動判定？
'    If vntCalcFlg(4) = 1 Then
'        blnRet = JudgeAutomatically(strCslDate, strCsCd, strJudClassCd, _
'                                    lngDayIdFlg, lngStrDayId, lngEndDayId, vntArrDayId, _
'                                    lngEntryCheck, lngReJudge)
'    End If
    
    If vntCalcFlg(4) = 1 Then
        If vntCalcFlg(5) = 1 Then
            blnRet = JudgeAutomatically(strCslDate, strCsCd, strJudClassCd, _
                                        lngDayIdFlg, lngStrDayId, lngEndDayId, vntArrDayId, _
                                        lngEntryCheck, lngReJudge, TOT_COMMENT)
        Else
            blnRet = JudgeAutomatically(strCslDate, strCsCd, strJudClassCd, _
                                        lngDayIdFlg, lngStrDayId, lngEndDayId, vntArrDayId, _
                                        lngEntryCheck, lngReJudge, DIS_COMMENT)
        End If
    Else
        If vntCalcFlg(5) = 1 Then
            '現病歴コメント（婦人科関連）コメントセット
            objJudgement.UpdateNowDiseaseCmt strCslDate, lngDayIdFlg, lngStrDayId, _
                                            lngEndDayId, vntArrDayId, strCsCd, GYN_COMMENT
        End If
    End If
    
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために追加 End
    


'### 2006.06.19 張 メタボリックシンドローム関連総合コメント登録のため追加 Start
'    If vntCalcFlg(4) = 1 Then
    If vntCalcFlg(4) = 1 Then
        'メタボリックシンドローム関連コメントセット
'### 2013.03.30 張 メタボリックシンドローム判定ロジックが「2013年4月1日」を基準で変更になるため修正 Start
'        '### 2008.03.04 張 メタボリックシンドローム判定ロジックが「2008年4月1日」を基準で変更になるため修正 Start
'        'objJudgement.UpdateMetaCmt strCslDate, lngDayIdFlg, lngStrDayId, _
'        '                                lngEndDayId, vntArrDayId, strCsCd
'        If CDate(strCslDate) < CDate(META_CDATE_20080401) Then
'            objJudgement.UpdateMetaCmt strCslDate, lngDayIdFlg, lngStrDayId, _
'                                            lngEndDayId, vntArrDayId, strCsCd
'        Else
'            objJudgement.UpdateMetaCmt2 strCslDate, lngDayIdFlg, lngStrDayId, _
'                                            lngEndDayId, vntArrDayId, strCsCd
'        End If
'        '### 2008.03.04 張 メタボリックシンドローム判定ロジックが「2008年4月1日」を基準で変更になるため修正 End
    
        If CDate(strCslDate) < CDate(META_CDATE_20080401) Then
            
            objJudgement.UpdateMetaCmt strCslDate, lngDayIdFlg, lngStrDayId, _
                                            lngEndDayId, vntArrDayId, strCsCd
        
        ElseIf CDate(strCslDate) < CDate(HBA1C_CDATE_20130401) Then
            
            objJudgement.UpdateMetaCmt2 strCslDate, lngDayIdFlg, lngStrDayId, _
                                            lngEndDayId, vntArrDayId, strCsCd
        
        Else
            
            objJudgement.UpdateMetaCmt3 strCslDate, lngDayIdFlg, lngStrDayId, _
                                            lngEndDayId, vntArrDayId, strCsCd
        End If
    
    End If
'### 2013.03.30 張 メタボリックシンドローム判定ロジックが「2013年4月1日」を基準で変更になるため修正 End

'### 2006.06.19 張 メタボリックシンドローム関連総合コメント登録のため追加 End
    
    
    
    
    
'#### 2010.07.23 SL-UI-Y0101-101 ADD START ####　総合コメント並び替え関数追加'
    If Not fncSortTotalJudCmtAll(strCslDate, strCsCd, lngDayIdFlg, lngStrDayId, lngEndDayId, vntArrDayId) Then
        Err.Raise 5
        Exit Function
    End If
'#### 2010.07.23 SL-UI-Y0101-101 ADD END ####　'
    
    '戻り値の設定
    JudgeAutomaticallyMain = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    JudgeAutomaticallyMain = -99

    'イベントログ書き込み
    WriteErrorLog "JudgementControl.JudgeAutomaticallyMain"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###　※バインド変数未使用の場合エラーになるので一旦削除
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 自動判定
'
' 引数　　 : (In)     dtmCslDate     受診日
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     strJudClassCd  判定分類コード
' 　　　　   (In)     lngDayIdFlg    1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId    検索開始ＩＤ
' 　　　　   (In)     lngEndDayId    検索終了ＩＤ
' 　　　　   (In)     vntArrDayId    検索ＩＤ（配列）
' 　　　　   (In)     lngEntryCheck  未入力チェックフラグ(0:未入力チェックしない 1:する)
' 　　　　   (In)     lngReJudge     再判定フラグ(0:再判定しない 1:する)
' 　　　　   (In)     strDisCheck    現病歴総合コメント区分("TOT":現病歴総合コメントすべて "DIS":婦人科以外、"GYN"：婦人科のみ)
'
''' 以前はあったものたち。参考までにちょっと退避。そのうち消します。
' 　　　　   (In)     blnSetComment  判定コメント付加フラグ
' 　　　　   (In)     blnTotalJudge  総合判定フラグ
' 　　　　   (In)     strPerId       個人ＩＤ
' 　　　　   (In)     strStrDayId    開始当日ID
' 　　　　   (In)     strEndDayId    終了当日ID
' 戻り値　 : True     正常終了
' 　　　　   False    異常終了
'
' 備考　　 :
'
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 Start
'Public Function JudgeAutomatically( _
'    ByVal dtmCslDate As Date, _
'    ByVal strCsCd As String, _
'    ByVal strJudClassCd As String, _
'    ByVal lngDayIdFlg As Long, _
'    ByVal lngStrDayId As Variant, _
'    ByVal lngEndDayId As Variant, _
'    ByRef vntArrDayId As Variant, _
'    ByVal lngEntryCheck As Long, _
'    ByVal lngReJudge As Long _
') As Boolean

Public Function JudgeAutomatically( _
    ByVal dtmCslDate As Date, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal lngDayIdFlg As Long, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByVal lngEntryCheck As Long, _
    ByVal lngReJudge As Long, _
    ByVal strDisCheck As String _
) As Boolean
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objArrDayId         As OraParamArray    '当日ＩＤ
    
    Dim objJud                  As Object       '判定情報アクセス用
    Dim objJudgement            As Object       '判定情報アクセス用
    
    Dim vntLightestWeight       As Variant      '最も軽い判定の重み
    Dim vntLightestJudCd        As Variant      '最も軽い判定コード
    
    Dim vntRsvNo                As Variant      '予約番号
    Dim vntJudClassCd           As Variant      '判定分類コード
    Dim vntWeight               As Variant      '重み
    Dim vntJudCd                As Variant      '判定コード
    Dim vntJudCmtStc            As Variant      '判定コメント文章
    Dim vntJudCmtCd             As Variant      '判定コメントコード
    Dim lngCount                As Long         'レコード数
    
    Dim vntUpdRsvNo()           As Variant      '予約番号
    Dim vntUpdJudClassCd()      As Variant      '判定分類コード
    Dim vntUpdJudCd()           As Variant      '判定コード
    Dim vntUpdJudCmtStc()       As Variant      '判定コメント文章
    Dim vntUpdJudCmtCd()        As Variant      '判定コメントコード
    Dim lngUpdCount             As Long         '更新レコード数
    
    Dim vntCurRsvNo             As Variant      '現在の予約番号
    Dim vntCurJudClassCd        As Variant      '現在の判定分類コード
    Dim vntCurWeight            As Variant      '現在の重み
    Dim vntCurJudCd             As Variant      '現在の判定コード
    Dim vntCurJudCmtStc         As Variant      '現在の判定コメント文章
    Dim vntCurJudCmtCd          As Variant      '現在の判定コメントコード
    
    Dim blnClearTotalJudgeOnly  As Boolean      '総合判定のみをクリアするか
    Dim vntJoinJudCmtStc        As Variant      '結合用の判定コメント文章
    Dim i, j                    As Long         'インデックス
        
    Dim vntTtlCmtRsvNo()        As Variant      '予約番号
    Dim vntTtlCmtDispMode()     As Variant      '表示モード
    Dim vntTtlCmtMaxSeq()       As Variant      'MAX SEQ
    Dim vntTtlCmtJudCmtCd()     As Variant      '判定コメントコード
    Dim lngTotalCmtCount        As Long         '更新レコード数
    
    Dim vntOrgRsvNo             As Variant      '更新前予約番号
    Dim vntOrgSeq               As Variant      '更新前SEQ
    Dim vntOrgJudCmtCd          As Variant      '更新前判定コメントコード
    Dim vntOrgMaxSeq            As Variant      '更新前MAXSEQ
    Dim lngTotalCmtPreCnt       As Long         '更新前レコード数
    Dim lngHitFlg               As Long         '一致チェックフラグ
    
    Dim blnEntryCheck           As Boolean      '未入力チェックフラグ
    Dim blnReJudge              As Boolean      '再判定フラグ
    
    Dim lngArraySize            As Long             '配列サイズ
    
    Dim vntNyubouItemCd1        As Variant         '乳房触診検査項目コード
    Dim vntNyubouItemCd2        As Variant         '乳房Ｘ線検査項目コード
    Dim vntNyubouItemCd3        As Variant         '乳房超音波検査項目コード
    Dim vntNyubouJudClassCd1    As Variant         '乳房触診判定分類コード
    Dim vntNyubouJudClassCd2    As Variant         '乳房Ｘ線判定分類コード
    Dim vntNyubouJudClassCd3    As Variant         '乳房超音波判定分類コード
    
    ''' 以前は引数だったものたち
'    Dim blnSetComment           As Boolean      '判定コメント付加フラグ
    Dim blnTotalJudge           As Boolean      '総合判定フラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    ''' 以前は引数だったものたち
'    blnSetComment = True
    blnTotalJudge = False
    

    'オブジェクトのインスタンス作成
    Set objJud = mobjContext.CreateInstance("HainsJud.Jud")
    Set objJudgement = mobjContext.CreateInstance("HainsJudgement.Judgement")
    
    If lngEntryCheck = 0 Then
        blnEntryCheck = False
    Else
        blnEntryCheck = True
    End If
    
    If lngReJudge = 0 Then
        blnReJudge = False
    Else
        blnReJudge = True
    End If
    
    '最も軽い判定を取得
    If objJud.SelectJudLightest(vntLightestJudCd, vntLightestWeight) = False Then
        Err.Raise 1000, , "判定コード情報が登録されていません。"
    End If
    
    Do
        '判定情報クリア要否判定
        Do

            '再判定も行わず、かつ総合判定も行わない場合、クリア処理は不要
            If Not blnReJudge And Not blnTotalJudge Then
                '登録されている総合コメントを取得
                lngTotalCmtPreCnt = objJudgement.SelectTotalCmtList( _
                                                dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                                lngEndDayId, vntArrDayId, _
                                                strCsCd, TOTALCMT_DISPMODE, _
                                                vntOrgRsvNo, vntOrgSeq, vntOrgJudCmtCd)
                Exit Do
            End If

            '総合判定のみをクリアするかそれ以外の判定分類の判定もクリアするかを判定

            '再判定を行うならばすべてクリア
            If blnReJudge Then
                blnClearTotalJudgeOnly = False
            Else
                'ここへ到達するパターンは、再判定は行わないが総合判定のみを行う場合、ゆえにフラグ成立
                blnClearTotalJudgeOnly = True
            End If

            '判定情報のクリア処理 （当日ＩＤ指定できるように修正 2003.12.17）
'            objJudgement.DeleteJudRslClear dtmCslDate, strPerId, strCsCd, strJudClassCd, blnClearTotalJudgeOnly
            objJudgement.DeleteJudRslClearDayId dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                                lngEndDayId, vntArrDayId, _
                                                strCsCd, strJudClassCd, blnClearTotalJudgeOnly
'### 2004/1/9 Updated by Ishihara@FSIT 総合コメント登録数は再度読み直し
'            lngTotalCmtPreCnt = 0
                lngTotalCmtPreCnt = objJudgement.SelectTotalCmtList( _
                                                dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                                lngEndDayId, vntArrDayId, _
                                                strCsCd, TOTALCMT_DISPMODE, _
                                                vntOrgRsvNo, vntOrgSeq, vntOrgJudCmtCd)
'### 2004/1/9 Updated End

            Exit Do
        Loop
    
        ''' ## 2004.01.02 add
        ' 乳房判定用のコード取得
        objJudgement.SelectNyubouCd vntNyubouItemCd1, vntNyubouItemCd2, vntNyubouItemCd3, _
                                    vntNyubouJudClassCd1, vntNyubouJudClassCd2, vntNyubouJudClassCd3
                                    
        'デフォルト判定結果情報を作成する （当日ＩＤ指定できるように修正 2003.12.17）
'        objJudgement.InsertJudRslDefault dtmCslDate, strPerId, strCsCd, strJudClassCd
        objJudgement.InsertJudRslDefaultDayId dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                              lngEndDayId, vntArrDayId, strCsCd, strJudClassCd
    
        '自動判定結果の読み込み （当日ＩＤ指定できるように修正 2003.12.17）
'''        lngCount = objJudgement.SelectJudRslAutomatically(dtmCslDate, _
                                                          strPerId, _
                                                          strCsCd, _
                                                          strJudClassCd, _
                                                          vntLightestWeight, _
                                                          vntLightestJudCd, _
                                                          blnReJudge, _
                                                          blnEntryCheck, _
                                                          vntRsvNo, _
                                                          vntJudClassCd, _
                                                          vntWeight, _
                                                          vntJudCd, _
                                                          vntJudCmtStc)
        lngCount = objJudgement.SelectJudRslAutomaticallyDayId(dtmCslDate, _
                                                          lngDayIdFlg, _
                                                          lngStrDayId, _
                                                          lngEndDayId, _
                                                          vntArrDayId, _
                                                          strCsCd, _
                                                          strJudClassCd, _
                                                          vntLightestWeight, _
                                                          vntLightestJudCd, _
                                                          blnReJudge, _
                                                          blnEntryCheck, _
                                                          vntRsvNo, _
                                                          vntJudClassCd, _
                                                          vntWeight, _
                                                          vntJudCd, _
                                                          vntJudCmtStc, _
                                                          vntJudCmtCd)
                                                          


        If lngCount > 0 Then
            
            '初期処理として先頭レコードの予約番号、判定分類コード、重み、判定コードを退避
            vntCurRsvNo = vntRsvNo(0)
            vntCurJudClassCd = vntJudClassCd(0)
        
            '判定情報を検索
            For i = 0 To lngCount - 1
            
                
                '直前レコードと予約番号、判定分類コードのいずれかが異なる場合
                If CLng(vntRsvNo(i)) <> CLng(vntCurRsvNo) Or CLng(vntJudClassCd(i)) <> CLng(vntCurJudClassCd) Then
                
                    If CStr(vntCurJudCd) <> "0" Then
'MsgBox "書き込み　" & vntCurRsvNo & " " & vntCurJudClassCd & " " & vntCurJudCd
                        '更新情報への追加
                        ReDim Preserve vntUpdRsvNo(lngUpdCount)
                        ReDim Preserve vntUpdJudClassCd(lngUpdCount)
                        ReDim Preserve vntUpdJudCd(lngUpdCount)
                        ReDim Preserve vntUpdJudCmtStc(lngUpdCount)
                        ReDim Preserve vntUpdJudCmtCd(lngUpdCount)
                        vntUpdRsvNo(lngUpdCount) = vntCurRsvNo
                        vntUpdJudClassCd(lngUpdCount) = vntCurJudClassCd
                        vntUpdJudCd(lngUpdCount) = vntCurJudCd
                        vntUpdJudCmtStc(lngUpdCount) = vntCurJudCmtStc
                        vntUpdJudCmtCd(lngUpdCount) = vntCurJudCmtCd
                        lngUpdCount = lngUpdCount + 1
                    
                        '判定コメントコードあり？
                        ' ## 2004.01.02 乳房以外
                        If vntCurJudCmtCd <> "" And _
                            (vntCurJudClassCd <> vntNyubouJudClassCd1 And _
                             vntCurJudClassCd <> vntNyubouJudClassCd2 And _
                             vntCurJudClassCd <> vntNyubouJudClassCd3) Then
                            lngHitFlg = 0
                            For j = 0 To lngTotalCmtPreCnt - 1
                                If vntOrgRsvNo(j) = vntCurRsvNo Then
                                    '既に登録されているコメント
                                    If vntOrgJudCmtCd(j) = vntCurJudCmtCd Then
                                        lngHitFlg = 1
                                        Exit For
                                    End If
                                    vntOrgMaxSeq = vntOrgSeq(j)
                                End If
                            Next j
                            If lngHitFlg = 0 Then
                                ReDim Preserve vntTtlCmtRsvNo(lngTotalCmtCount)
                                ReDim Preserve vntTtlCmtDispMode(lngTotalCmtCount)
                                ReDim Preserve vntTtlCmtMaxSeq(lngTotalCmtCount)
                                ReDim Preserve vntTtlCmtJudCmtCd(lngTotalCmtCount)
                                vntTtlCmtRsvNo(lngTotalCmtCount) = vntCurRsvNo
                                vntTtlCmtDispMode(lngTotalCmtCount) = TOTALCMT_DISPMODE
                                vntTtlCmtMaxSeq(lngTotalCmtCount) = vntOrgMaxSeq
                                vntTtlCmtJudCmtCd(lngTotalCmtCount) = vntCurJudCmtCd
                                lngTotalCmtCount = lngTotalCmtCount + 1
                            End If
                        End If
                    
                    End If
                    '現レコードの予約番号、判定分類コードを退避
                    vntCurRsvNo = vntRsvNo(i)
                    vntCurJudClassCd = vntJudClassCd(i)
    
                    '重み、判定コードの内容をクリア
                    vntCurWeight = Empty
                    vntCurJudCd = Empty
                    vntCurJudCmtCd = Empty
                    
                End If
                
                '直前レコードと重み、判定コードのいずれかが異なる場合(判定クリア直後も含む)
                If CLng(vntWeight(i)) <> CLng(vntCurWeight) Or CStr(vntJudCd(i)) <> CStr(vntCurJudCd) Then
                
'MsgBox i & " : " & vntRsvNo(i) & " " & vntJudClassCd(i) & " " & vntJudCd(i)
                    '重み、判定コードの内容を置き換える
                    vntCurWeight = vntWeight(i)
                    vntCurJudCd = vntJudCd(i)
                    vntCurJudCmtCd = vntJudCmtCd(i)
                
                    '判定コメント内容をクリア
                    vntCurJudCmtStc = Empty
                
                End If
                
                '判定コメント文章が存在する場合
'                If vntJudCmtStc(i) <> "" Then
                
                    'まず保持中の判定コメントに現検索中の判定コメントを結合する
'                    vntJoinJudCmtStc = vntCurJudCmtStc & IIf(Not IsEmpty(vntCurJudCmtStc), vbCrLf, Empty) & vntJudCmtStc(i)
                
                    '結合した状態で格納最大領域を超えない場合は適用する
'                    If LenB(StrConv(vntJoinJudCmtStc, vbFromUnicode)) <= LENGTH_FREEJUDCMT Then
'                        vntCurJudCmtStc = vntJoinJudCmtStc
'                    End If
'
'                End If
                   
            Next i
        
            If CStr(vntCurJudCd) <> "0" Then
'MsgBox "書き込み　" & vntCurRsvNo & " " & vntCurJudClassCd & " " & vntCurJudCd
                '全検索終了後、現退避中の内容を更新情報へ追加
                ReDim Preserve vntUpdRsvNo(lngUpdCount)
                ReDim Preserve vntUpdJudClassCd(lngUpdCount)
                ReDim Preserve vntUpdJudCd(lngUpdCount)
                ReDim Preserve vntUpdJudCmtStc(lngUpdCount)
                ReDim Preserve vntUpdJudCmtCd(lngUpdCount)
                vntUpdRsvNo(lngUpdCount) = vntCurRsvNo
                vntUpdJudClassCd(lngUpdCount) = vntCurJudClassCd
                vntUpdJudCd(lngUpdCount) = vntCurJudCd
                vntUpdJudCmtStc(lngUpdCount) = vntCurJudCmtStc
                vntUpdJudCmtCd(lngUpdCount) = vntCurJudCmtCd
                lngUpdCount = lngUpdCount + 1
            End If
        
            '判定コメントコードあり？
            ' ## 2004.01.02 乳房以外
            If vntCurJudCmtCd <> "" And _
                (vntCurJudClassCd <> vntNyubouJudClassCd1 And _
                 vntCurJudClassCd <> vntNyubouJudClassCd2 And _
                 vntCurJudClassCd <> vntNyubouJudClassCd3) Then
                lngHitFlg = 0
                For j = 0 To lngTotalCmtPreCnt - 1
                    If vntOrgRsvNo(j) = vntCurRsvNo Then
                        '既に登録されているコメント
                        If vntOrgJudCmtCd(j) = vntCurJudCmtCd Then
                            lngHitFlg = 1
                            Exit For
                        End If
                        vntOrgMaxSeq = vntOrgSeq(j)
                    End If
                Next j
                If lngHitFlg = 0 Then
                    ReDim Preserve vntTtlCmtRsvNo(lngTotalCmtCount)
                    ReDim Preserve vntTtlCmtDispMode(lngTotalCmtCount)
                    ReDim Preserve vntTtlCmtMaxSeq(lngTotalCmtCount)
                    ReDim Preserve vntTtlCmtJudCmtCd(lngTotalCmtCount)
                    vntTtlCmtRsvNo(lngTotalCmtCount) = vntCurRsvNo
                    vntTtlCmtDispMode(lngTotalCmtCount) = TOTALCMT_DISPMODE
                    vntTtlCmtMaxSeq(lngTotalCmtCount) = vntOrgMaxSeq
                    vntTtlCmtJudCmtCd(lngTotalCmtCount) = vntCurJudCmtCd
                    lngTotalCmtCount = lngTotalCmtCount + 1
                End If
            End If
        End If
        
            
            '判定結果テーブルレコード更新
'            If blnSetComment Then
'                objJudgement.UpdateJudRsl vntUpdRsvNo, vntUpdJudClassCd, vntUpdJudCd, , vntUpdJudCmtStc
'            Else
                ' ### 2004.01.02 JudCmtCd 追加
'MsgBox "updateJudRsl count=" & lngUpdCount
        If lngUpdCount > 0 Then
            objJudgement.UpdateJudRsl vntUpdRsvNo, vntUpdJudClassCd, vntUpdJudCd, AUTOJUDUSER, vntUpdJudCmtCd, 0
        End If
'            End If
        If lngTotalCmtCount > 0 Then
            objJudgement.InsertTotalJudCmt vntTtlCmtRsvNo, vntTtlCmtDispMode, vntTtlCmtMaxSeq, vntTtlCmtJudCmtCd
        End If
            
        '判定分類指定無し　または乳房？
        If strJudClassCd = "" Or strJudClassCd = CStr(NYUBOU_JUDCLASSCD) Then

            lngUpdCount = 0
            lngTotalCmtCount = 0
            '乳房判定呼び出し
            lngCount = objJudgement.SelectNyubouJudRsl(dtmCslDate, _
                                                          lngDayIdFlg, _
                                                          lngStrDayId, _
                                                          lngEndDayId, _
                                                          vntArrDayId, _
                                                          strCsCd, _
                                                          blnReJudge, _
                                                          blnEntryCheck, _
                                                          vntRsvNo, _
                                                          vntJudClassCd, _
                                                          vntJudCd, _
                                                          vntJudCmtCd)
            '判定情報を検索
            For i = 0 To lngCount - 1
                
                '更新情報への追加
                ReDim Preserve vntUpdRsvNo(lngUpdCount)
                ReDim Preserve vntUpdJudClassCd(lngUpdCount)
                ReDim Preserve vntUpdJudCd(lngUpdCount)
                ReDim Preserve vntUpdJudCmtStc(lngUpdCount)
                ReDim Preserve vntUpdJudCmtCd(lngUpdCount)
                vntUpdRsvNo(lngUpdCount) = vntRsvNo(i)
                vntUpdJudClassCd(lngUpdCount) = vntJudClassCd(i)
                vntUpdJudCd(lngUpdCount) = vntJudCd(i)
                vntUpdJudCmtStc(lngUpdCount) = ""
                vntUpdJudCmtCd(lngUpdCount) = vntJudCmtCd(i)
                lngUpdCount = lngUpdCount + 1
                    
                '判定コメントコードあり？
                If vntJudCmtCd(i) <> "" Then
                    lngHitFlg = 0
                    For j = 0 To lngTotalCmtPreCnt - 1
                        If vntOrgRsvNo(j) = vntRsvNo(i) Then
                            '既に登録されているコメント
                            If vntOrgJudCmtCd(j) = vntJudCmtCd(i) Then
                                lngHitFlg = 1
                                Exit For
                            End If
                            vntOrgMaxSeq = vntOrgSeq(j)
                        End If
                    Next j
                    If lngHitFlg = 0 Then
                        ReDim Preserve vntTtlCmtRsvNo(lngTotalCmtCount)
                        ReDim Preserve vntTtlCmtDispMode(lngTotalCmtCount)
                        ReDim Preserve vntTtlCmtMaxSeq(lngTotalCmtCount)
                        ReDim Preserve vntTtlCmtJudCmtCd(lngTotalCmtCount)
                        vntTtlCmtRsvNo(lngTotalCmtCount) = vntRsvNo(i)
                        vntTtlCmtDispMode(lngTotalCmtCount) = TOTALCMT_DISPMODE
                        vntTtlCmtMaxSeq(lngTotalCmtCount) = vntOrgMaxSeq
                        vntTtlCmtJudCmtCd(lngTotalCmtCount) = vntJudCmtCd(i)
                        lngTotalCmtCount = lngTotalCmtCount + 1
                    End If
                End If
                    
                    
            Next i
            If lngUpdCount > 0 Then
                '判定結果セット
                objJudgement.UpdateJudRsl vntUpdRsvNo, vntUpdJudClassCd, vntUpdJudCd, AUTOJUDUSER, vntUpdJudCmtCd, 0
            End If
            If lngTotalCmtCount > 0 Then
                '総合コメントセット
                objJudgement.InsertTotalJudCmt vntTtlCmtRsvNo, vntTtlCmtDispMode, vntTtlCmtMaxSeq, vntTtlCmtJudCmtCd
            End If
        End If
        
        
        '************ 2007.11.19 張 自動判定特殊処理ストアドによって視力判定を行う時は、下記特殊処理は実施しない Start *************
''        '### 2004.01.14 start   眼科判定特殊処理追加　by K.Fujii
''        '判定分類指定無し　または眼科？
''        If strJudClassCd = "" Or strJudClassCd = CStr(GANKA_JUDCLASSCD) Then
''
''            lngUpdCount = 0
''            lngTotalCmtCount = 0
''            '眼科判定呼び出し
''            lngCount = objJudgement.SelectGankaJudRsl(dtmCslDate, lngDayIdFlg, _
''                                                      lngStrDayId, lngEndDayId, vntArrDayId, _
''                                                      strCsCd, blnReJudge, blnEntryCheck, _
''                                                      vntRsvNo, vntJudClassCd, _
''                                                      vntJudCd, vntJudCmtCd)
''            '判定情報を検索
''            For i = 0 To lngCount - 1
''
''                '更新情報への追加
''                ReDim Preserve vntUpdRsvNo(lngUpdCount)
''                ReDim Preserve vntUpdJudClassCd(lngUpdCount)
''                ReDim Preserve vntUpdJudCd(lngUpdCount)
''                ReDim Preserve vntUpdJudCmtStc(lngUpdCount)
''                ReDim Preserve vntUpdJudCmtCd(lngUpdCount)
''                vntUpdRsvNo(lngUpdCount) = vntRsvNo(i)
''                vntUpdJudClassCd(lngUpdCount) = vntJudClassCd(i)
''                vntUpdJudCd(lngUpdCount) = vntJudCd(i)
''                vntUpdJudCmtStc(lngUpdCount) = ""
''                vntUpdJudCmtCd(lngUpdCount) = vntJudCmtCd(i)
''                lngUpdCount = lngUpdCount + 1
''
''                '判定コメントコードあり？
''                If vntJudCmtCd(i) <> "" Then
''                    lngHitFlg = 0
''                    For j = 0 To lngTotalCmtPreCnt - 1
''                        If vntOrgRsvNo(j) = vntRsvNo(i) Then
''                            '既に登録されているコメント
''                            If vntOrgJudCmtCd(j) = vntJudCmtCd(i) Then
''                                lngHitFlg = 1
''                                Exit For
''                            End If
''                            vntOrgMaxSeq = vntOrgSeq(j)
''                        End If
''                    Next j
''                    If lngHitFlg = 0 Then
''                        ReDim Preserve vntTtlCmtRsvNo(lngTotalCmtCount)
''                        ReDim Preserve vntTtlCmtDispMode(lngTotalCmtCount)
''                        ReDim Preserve vntTtlCmtMaxSeq(lngTotalCmtCount)
''                        ReDim Preserve vntTtlCmtJudCmtCd(lngTotalCmtCount)
''                        vntTtlCmtRsvNo(lngTotalCmtCount) = vntRsvNo(i)
''                        vntTtlCmtDispMode(lngTotalCmtCount) = TOTALCMT_DISPMODE
''                        vntTtlCmtMaxSeq(lngTotalCmtCount) = vntOrgMaxSeq
''                        vntTtlCmtJudCmtCd(lngTotalCmtCount) = vntJudCmtCd(i)
''                        lngTotalCmtCount = lngTotalCmtCount + 1
''                    End If
''                End If
''            Next i
''
''            If lngUpdCount > 0 Then
''                '判定結果セット
''                objJudgement.UpdateJudRsl vntUpdRsvNo, vntUpdJudClassCd, vntUpdJudCd, AUTOJUDUSER, vntUpdJudCmtCd, 0
''            End If
''            If lngTotalCmtCount > 0 Then
''                '総合コメントセット
''                objJudgement.InsertTotalJudCmt vntTtlCmtRsvNo, vntTtlCmtDispMode, vntTtlCmtMaxSeq, vntTtlCmtJudCmtCd
''            End If
''        End If
''        '### 2004.01.14 end   眼科判定特殊処理追加　by K.Fujii
        '************ 2007.11.19 張 自動判定特殊処理ストアドによって視力判定を行う時は、下記特殊処理は実施しない End   *************


        '************ 2007.12.04 張 自動判定特殊処理ストアドによって視力判定を行う時は、下記特殊処理は実施しない Start *************
''        '### 2007.11.19 張 骨密度判定特殊処理追加 Start
''        '判定分類指定無しまたは骨密度の場合実行
''        If strJudClassCd = "" Or strJudClassCd = CStr(KOTSU_JUDCLASSCD) Then
''
''            lngUpdCount = 0
''            lngTotalCmtCount = 0
''            '骨密度判定呼び出し
''            lngCount = objJudgement.SelectKotsuJudRsl(dtmCslDate, lngDayIdFlg, _
''                                                      lngStrDayId, lngEndDayId, vntArrDayId, _
''                                                      strCsCd, blnReJudge, blnEntryCheck, _
''                                                      vntRsvNo, vntJudClassCd, _
''                                                      vntJudCd, vntJudCmtCd)
''            '判定情報を検索
''            For i = 0 To lngCount - 1
''
''                '更新情報への追加
''                ReDim Preserve vntUpdRsvNo(lngUpdCount)
''                ReDim Preserve vntUpdJudClassCd(lngUpdCount)
''                ReDim Preserve vntUpdJudCd(lngUpdCount)
''                ReDim Preserve vntUpdJudCmtStc(lngUpdCount)
''                ReDim Preserve vntUpdJudCmtCd(lngUpdCount)
''                vntUpdRsvNo(lngUpdCount) = vntRsvNo(i)
''                vntUpdJudClassCd(lngUpdCount) = vntJudClassCd(i)
''                vntUpdJudCd(lngUpdCount) = vntJudCd(i)
''                vntUpdJudCmtStc(lngUpdCount) = ""
''                vntUpdJudCmtCd(lngUpdCount) = vntJudCmtCd(i)
''                lngUpdCount = lngUpdCount + 1
''
''                '判定コメントコードあり？
''                If vntJudCmtCd(i) <> "" Then
''                    lngHitFlg = 0
''                    For j = 0 To lngTotalCmtPreCnt - 1
''                        If vntOrgRsvNo(j) = vntRsvNo(i) Then
''                            '既に登録されているコメント
''                            If vntOrgJudCmtCd(j) = vntJudCmtCd(i) Then
''                                lngHitFlg = 1
''                                Exit For
''                            End If
''                            vntOrgMaxSeq = vntOrgSeq(j)
''                        End If
''                    Next j
''                    If lngHitFlg = 0 Then
''                        ReDim Preserve vntTtlCmtRsvNo(lngTotalCmtCount)
''                        ReDim Preserve vntTtlCmtDispMode(lngTotalCmtCount)
''                        ReDim Preserve vntTtlCmtMaxSeq(lngTotalCmtCount)
''                        ReDim Preserve vntTtlCmtJudCmtCd(lngTotalCmtCount)
''                        vntTtlCmtRsvNo(lngTotalCmtCount) = vntRsvNo(i)
''                        vntTtlCmtDispMode(lngTotalCmtCount) = TOTALCMT_DISPMODE
''                        vntTtlCmtMaxSeq(lngTotalCmtCount) = vntOrgMaxSeq
''                        vntTtlCmtJudCmtCd(lngTotalCmtCount) = vntJudCmtCd(i)
''                        lngTotalCmtCount = lngTotalCmtCount + 1
''                    End If
''                End If
''            Next i
''
''            If lngUpdCount > 0 Then
''                '判定結果セット
''                objJudgement.UpdateJudRsl vntUpdRsvNo, vntUpdJudClassCd, vntUpdJudCd, AUTOJUDUSER, vntUpdJudCmtCd, 0
''            End If
''            If lngTotalCmtCount > 0 Then
''                '総合コメントセット
''                objJudgement.InsertTotalJudCmt vntTtlCmtRsvNo, vntTtlCmtDispMode, vntTtlCmtMaxSeq, vntTtlCmtJudCmtCd
''            End If
''        End If
''        '### 2007.11.19 張 骨密度判定特殊処理追加 End
        '************ 2007.12.04 張 自動判定特殊処理ストアドによって視力判定を行う時は、下記特殊処理は実施しない End   *************


'MsgBox "自動判定特殊処理=>" & lngDayIdFlg
        '自動判定特殊処理ストアド呼び出し
        'キー値の設定
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
        objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "JUDCLASSCD", Trim(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "DAYIDFLG", lngDayIdFlg, ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004.01.22 Mod start 大小逆を指定された場合の対応ができていなかった
'        objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
'        objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004.01.23 複数指定されたときは開始／終了ＩＤが数値ではない　（条件追加）
        If IsNumeric(lngStrDayId) And IsNumeric(lngEndDayId) Then
            If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
                objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
            Else
                objOraParam.Add "STRDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "ENDDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
            End If
        Else
            objOraParam.Add "STRDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        End If
'### 2004.01.22 Mod end  大小逆を指定された場合の対応ができていなかった
        If lngDayIdFlg = 2 Then
            '配列数
            lngArraySize = UBound(vntArrDayId) + 1
        Else
            lngArraySize = 1
        End If
        objOraParam.AddTable "ARRDAYID", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_RECEIPT_DAYID
        If lngDayIdFlg = 2 Then
            Set objArrDayId = objOraParam("ARRDAYID")
    
            'OraParameterオブジェクトの値設定
            For i = 0 To lngArraySize - 1
                objArrDayId(i) = vntArrDayId(i)
            Next i
        End If
        '未入力チェックしない場合
        If Not blnEntryCheck Then
            lngEntryCheck = 0
        Else
            lngEntryCheck = 1
        End If
'MsgBox "未入力チェックは？　" & lngEntryCheck
        objOraParam.Add "ENTRYCHECK", lngEntryCheck, ORAPARM_INPUT, ORATYPE_NUMBER
        
        '再判定でない場合
        If Not blnReJudge Then
            lngReJudge = 0
        Else
            lngReJudge = 1
        End If
        objOraParam.Add "REJUDGE", lngReJudge, ORAPARM_INPUT, ORATYPE_NUMBER
        
        '判定特殊処理呼び出し
        mobjOraDb.ExecuteSQL "BEGIN :RET := SpecialJudCalcPackage.SpecialJudCalc(:CSLDATE, :CSCD, :JUDCLASSCD, :ENTRYCHECK,:REJUDGE, :DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
'MsgBox "自動判定特殊処理　終了"
        
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop

        '生活指導コメントをセットする
        objJudgement.UpdateLifeGuideMsg dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                        lngEndDayId, vntArrDayId, strCsCd
        
'### 2008.05.07 張 喫煙情報（吸っている場合）によって喫煙関連総合コメントを自動登録するロジック追加 Start ###
'### 良好コメント追加ロジックには影響しないように汎用マスター設定が必要
        '### 2008.05.14 張 喫煙コメント自動登録ロジックは「2008/05/01」受診者から適用
        If CDate(dtmCslDate) >= CDate(SMOKE_CDATE) Then
            '喫煙情報によって総合コメントをセットする
            objJudgement.UpdateSmokeGuideMsg dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                            lngEndDayId, vntArrDayId, strCsCd
        End If
'### 2008.05.07 張 喫煙情報（吸っている場合）によって喫煙関連総合コメントを自動登録するロジック追加 End   ###
        
        
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 Start
        '現病歴コメントをセットする
        'objJudgement.UpdateNowDiseaseCmt dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                        lngEndDayId, vntArrDayId, strCsCd
        
        '現病歴コメント（婦人科以外）をセットする
        objJudgement.UpdateNowDiseaseCmt dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                        lngEndDayId, vntArrDayId, strCsCd, strDisCheck
        
'### 2006.04.26 張 現病歴関連総合コメント登録処理を分類するために変更 Start
        
        
        '### 2004.01.14 add start
        '内視鏡コメントをセットする
        objJudgement.UpdateNaishikyouCmt dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                        lngEndDayId, vntArrDayId, strCsCd
        '### 2004.01.14 add end
        
        '良好コメントをセットする
        objJudgement.UpdateGoodCmt dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                        lngEndDayId, vntArrDayId, strCsCd
        
'### 2004.01.16 add 4Line
        '判定結果の入っていないものクリア
        objJudgement.DeleteNullJudRslClearDayId dtmCslDate, lngDayIdFlg, lngStrDayId, _
                                                lngEndDayId, vntArrDayId, _
                                                strCsCd, strJudClassCd, blnClearTotalJudgeOnly
'''聖路加は無いはず
        '総合判定を行わない場合はここで処理を終了する
'        If Not blnTotalJudge Then
'            Exit Do
'        End If
        
        '自動総合判定結果の読み込み
'        lngCount = objJudgement.SelectTotalJudRslAutomatically(dtmCslDate, strPerId, strCsCd, vntRsvNo, vntJudClassCd, vntJudCd)
'        If lngCount <= 0 Then
'            Exit Do
'        End If
        
        '判定結果テーブルレコード更新
'        objJudgement.UpdateJudRsl vntRsvNo, vntJudClassCd, vntJudCd
        
        Exit Do
    Loop
    
    JudgeAutomatically = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudgementControl.JudgeAutomatically"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###　※バインド変数未使用の場合エラーになるので一旦削除
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 判定結果を更新する
'
' 引数　　 : (In)     strRsvNo          予約番号
' 　　　　 : (In)     vntJudClassCd     判定分類コード
' 　　　　 : (In)     vntJudCd          判定コード
' 　　　　 : (In)     vntDoctorCd       判定医コード
' 　　　　 : (In)     vntFreeJudCmt     フリー判定コメント
' 　　　　 : (In)     vntStdJudCd       定型所見コード
' 　　　　 : (In)     vntJudCmtCd       判定コメントコード
' 　　　　 : (In)     vntGuidanceCd     指導文章コード
'
' 戻り値　 : True     正常終了
' 　　　　 : False    異常終了
'
' 備考　　 :
'
Public Function UpdateJudRsl(ByVal strRsvNo As String, _
                             ByVal strDoctorCd As String, _
                             ByVal strUserId As String, _
                             ByVal vntJudClassCd As Variant, _
                             ByVal vntJudCd As Variant, _
                             ByVal vntDoctorCd As Variant, _
                             ByVal vntFreeJudCmt As Variant, _
                             ByVal vntStdJudCd As Variant, _
                             ByVal vntJudCmtCd As Variant, _
                             ByVal vntGuidanceCd As Variant _
                            ) As Boolean

    Dim objConsult          As Object       '受診情報アクセス用
    Dim objJudgement        As Object       '判定情報アクセス用

    Dim vntArrRsvNo()       As Variant      '予約番号の配列
    Dim vntArrJudClassCd()  As Variant      '判定分類コードの配列
    Dim vntArrJudCd()       As Variant      '判定コードの配列
    Dim vntArrDoctorCd()    As Variant      '判定医コードの配列
    Dim vntArrFreeJudCmt()  As Variant      'フリー判定コメントの配列
    Dim vntArrStdJudCd()    As Variant      '定型所見コードの配列
    Dim vntArrJudCmtCd()    As Variant      '判定コメントコードの配列
    Dim vntArrGuidanceCd()  As Variant      '指導文章コードの配列
    
    Dim strStdJudCd()       As String       '編集用定型所見コード
    Dim vntJudClassCd_c()   As Variant      '判定分類コードの配列
    Dim vntStdJudCd_c()     As Variant      '定型所見コードの配列
    
    Dim lngArraySize        As Long         '更新レコード配列数
    
    Dim i                   As Long         'インデックス
    Dim j                   As Long         'インデックス
    
'### 2003.05.13 Added by Ishihara@FSIT 何もデータがセットされていない判定は削除する
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
'### 2003.05.13 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'### 2003.05.13 Added by Ishihara@FSIT なぜ戻り値がない？
    UpdateJudRsl = False
'### 2003.05.13 Added End
    
    'オブジェクトのインスタンス作成
    Set objConsult = mobjContext.CreateInstance("HainsConsult.Consult")
    Set objJudgement = mobjContext.CreateInstance("HainsJudgement.Judgement")
    
    '判定分類コードが配列の場合
    If IsArray(vntJudClassCd) Then
        
        '判定コード・判定医コード・フリー判定コメント・定型所見コードが配列でない場合は処理終了
        If Not IsArray(vntJudCd) Or _
           Not IsArray(vntDoctorCd) Or _
           Not IsArray(vntFreeJudCmt) Or _
           Not IsArray(vntStdJudCd) Or _
           Not IsArray(vntJudCmtCd) Or _
           Not IsArray(vntGuidanceCd) Then
            Err.Raise 9     '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        
        '判定コード・判定医コード・フリー判定コメント・定型所見コードが一致しない場合は処理終了
        If UBound(vntJudClassCd) <> UBound(vntJudCd) Or _
           UBound(vntJudClassCd) <> UBound(vntDoctorCd) Or _
           UBound(vntJudClassCd) <> UBound(vntFreeJudCmt) Or _
           UBound(vntJudClassCd) <> UBound(vntStdJudCd) Or _
           UBound(vntJudClassCd) <> UBound(vntJudCmtCd) Or _
           UBound(vntJudClassCd) <> UBound(vntGuidanceCd) Then
            Err.Raise 9     '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        
        '予約番号を配列化
        ReDim Preserve vntArrRsvNo(UBound(vntJudClassCd))
        For i = 0 To UBound(vntJudClassCd)
            vntArrRsvNo(i) = CLng("0" & strRsvNo)
        Next
        
        'あとはそのまま使用
        vntArrJudClassCd = vntJudClassCd
        vntArrJudCd = vntJudCd
        vntArrDoctorCd = vntDoctorCd
        vntArrFreeJudCmt = vntFreeJudCmt
        vntArrStdJudCd = vntStdJudCd
        vntArrJudCmtCd = vntJudCmtCd
        vntArrGuidanceCd = vntGuidanceCd
    
    Else
        
        '判定コード・判定医コード・フリー判定コメント・定型所見コードが配列の場合は処理終了
        If IsArray(vntJudCd) Or _
           IsArray(vntDoctorCd) Or _
           IsArray(vntFreeJudCmt) Or _
           IsArray(vntStdJudCd) Or _
           IsArray(vntJudCmtCd) Or _
           IsArray(vntGuidanceCd) Then
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        
        'サイズ１の配列に変換
        ReDim Preserve vntArrRsvNo(0)
        ReDim Preserve vntArrJudClassCd(0)
        ReDim Preserve vntArrJudCd(0)
        ReDim Preserve vntArrDoctorCd(0)
        ReDim Preserve vntArrFreeJudCmt(0)
        ReDim Preserve vntArrStdJudCd(0)
        ReDim Preserve vntArrJudCmtCd(0)
        ReDim Preserve vntArrGuidanceCd(0)
        
        vntArrRsvNo(0) = CLng("0" & strRsvNo)
        vntArrJudClassCd(0) = vntJudClassCd
        vntArrJudCd(0) = vntJudCd
        vntArrDoctorCd(0) = vntDoctorCd
        vntArrFreeJudCmt(0) = vntFreeJudCmt
        vntArrStdJudCd(0) = vntStdJudCd
        vntArrJudCmtCd(0) = vntJudCmtCd
        vntArrGuidanceCd(0) = vntGuidanceCd
    
    End If
    
    '判定医コード更新
    objConsult.UpdateConsultDoctor strRsvNo, strDoctorCd, strUserId
    
'### 2002.03.27 Updated by H.Ishihara@FSIT 更新されたものだけ処理を行う
'    '判定結果テーブルレコードの削除
'    objJudgement.DeleteJudRsl strRsvNo
'
'    '判定結果テーブルレコードの挿入
'    objJudgement.InsertJudRsl vntArrRsvNo, vntArrJudClassCd, vntArrJudCd, vntArrDoctorCd, vntArrFreeJudCmt

    '判定分類コードの配列が存在、かつ１つ目の配列が数値なら判定結果の格納処理を行う
    If (UBound(vntJudClassCd) >= 0) And (IsNumeric(vntJudClassCd(0)) = True) Then
' ## 不要項目削除 2003.12.03 start
'        objJudgement.InsertJudRslWithUpdate vntArrRsvNo, vntArrJudClassCd, vntArrJudCd, vntArrDoctorCd, vntArrFreeJudCmt, vntArrJudCmtCd, vntArrGuidanceCd
        objJudgement.InsertJudRslWithUpdate vntArrRsvNo, vntArrJudClassCd, vntArrJudCd, vntArrJudCmtCd, , 0
' ## 不要項目削除 2003.12.03 end
    End If

'### 2002.03.27 Updated End
  
    '判定所見情報の編集
    lngArraySize = 0
    For i = 0 To UBound(vntArrJudClassCd)
        If vntArrStdJudCd(i) <> "" Then
            strStdJudCd = Split(vntArrStdJudCd(i), ",")
            For j = 0 To UBound(strStdJudCd)
                ReDim Preserve vntJudClassCd_c(lngArraySize)
                ReDim Preserve vntStdJudCd_c(lngArraySize)
                vntJudClassCd_c(lngArraySize) = vntArrJudClassCd(i)
                vntStdJudCd_c(lngArraySize) = strStdJudCd(j)
                lngArraySize = lngArraySize + 1
            Next j
        End If
    Next i
    
    '判定所見テーブルレコードの挿入
    If lngArraySize > 0 Then
        objJudgement.InsertJudRsl_C vntArrRsvNo, vntJudClassCd_c, vntStdJudCd_c
    End If
    
'### 2003.05.13 Added by Ishihara@FSIT 何もデータがセットされていない判定は削除する
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", CLng(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の判定情報テーブルレコードを削除
    strStmt = "DELETE JUDRSL               " & vbLf & _
              " WHERE RSVNO       = :RSVNO " & vbLf & _
              "   AND JUDCD       IS NULL  " & vbLf & _
              "   AND DOCTORCD    IS NULL  " & vbLf & _
              "   AND JUDCMTCD    IS NULL  " & vbLf & _
              "   AND GUIDANCECD  IS NULL  " & vbLf & _
              "   AND FREEJUDCMT  IS NULL  "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    objOraParam.Remove "RSVNO"

    UpdateJudRsl = True

'### 2003.05.13 Added End
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudgementControl.UpdateJudRsl"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###　※バインド変数未使用の場合エラーになるので一旦削除
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'#### 2010.07.23 SL-UI-Y0101-101 ADD START ####　総合コメント並び替え関数追加'
'
' 機能　　 : 総合判定コメントの並び替え（ＳＥＱ再設定）
'
' 引数　　 : (In)     dtmCslDate     受診日
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     lngDayIdFlg    1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     lngStrDayId    検索開始ＩＤ
' 　　　　   (In)     lngEndDayId    検索終了ＩＤ
' 　　　　   (In)     vntArrDayId    検索ＩＤ（配列）
' 戻り値　 : True     正常終了
' 　　　　 : False    異常終了
'
' 備考　　 :
'
Public Function fncSortTotalJudCmtAll(ByVal dtmCslDate As Date _
                                    , ByVal strCsCd As String _
                                    , ByVal lngDayIdFlg As Long _
                                    , ByVal lngStrDayId As Variant _
                                    , ByVal lngEndDayId As Variant _
                                    , ByRef vntArrDayId As Variant _
                                     ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim blnRet              As Boolean
    
    Dim lngArraySize        As Long
    Dim objArrDayId         As Object
    
    Dim i                   As Long

On Error GoTo ErrorProc

    blnRet = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DAYIDFLG", lngDayIdFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    If IsNumeric(lngStrDayId) And IsNumeric(lngEndDayId) Then
        If CLng(lngStrDayId) <= CLng(lngEndDayId) Then
            objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        Else
            objOraParam.Add "STRDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "ENDDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    Else
'#### 2011/01/20 ADD STA TCS)Y.T ####
'        objOraParam.Add "STRDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
'        objOraParam.Add "ENDDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
'#### 2011/01/20 ADD END TCS)Y.T ####
    End If
    If lngDayIdFlg = 2 Then
        '配列数
        lngArraySize = UBound(vntArrDayId) + 1
    Else
        lngArraySize = 1
    End If
    objOraParam.AddTable "ARRDAYID", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_RECEIPT_DAYID
    If lngDayIdFlg = 2 Then
        Set objArrDayId = objOraParam("ARRDAYID")

        'OraParameterオブジェクトの値設定
        For i = 0 To lngArraySize - 1
            objArrDayId(i) = vntArrDayId(i)
        Next i
    End If

    '並び替え実行
    mobjOraDb.ExecuteSQL "BEGIN :RET := SpecialJudCalcPackage.SortTotalJudCmtAll(:CSLDATE, :CSCD,  :DAYIDFLG, :STRDAYID, :ENDDAYID, :ARRDAYID ); END;"

    blnRet = True

ExitProc:

    If Err.Number <> 0 Then
        Err.Clear
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    fncSortTotalJudCmtAll = blnRet

    Exit Function

ErrorProc:
    blnRet = False

    GoTo ExitProc

End Function
'#### 2010.07.23 SL-UI-Y0101-101 ADD END ####'

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
