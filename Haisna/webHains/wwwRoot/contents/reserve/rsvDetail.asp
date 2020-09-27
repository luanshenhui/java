<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       予約情報詳細(基本情報) (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<% '## 2004/04/20 Add By T.Takagi@FSIT 近い受診日で健診歴がある場合のワーニング対応 %>
<!-- #include virtual = "/webHains/includes/recentConsult.inc" -->
<% '## 2004/04/20 Add End %>
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_SAVE               = "save"                  '処理モード(保存)
Const MODE_CANCEL             = "cancel"                '処理モード(予約キャンセル)
Const MODE_CANCELRECEIPT      = "cancelreceipt"         '処理モード(受付取り消し)
Const MODE_CANCELRECEIPTFORCE = "cancelreceiptforce"    '処理モード(強制受付取り消し)
Const MODE_DELETE             = "delete"                '処理モード(削除)
Const MODE_RESTORE            = "restore"               '処理モード(復元)

Const FREECD_CANCEL = "CANCEL"          '汎用コード(キャンセル理由)
Const ORG_DUMMY     = "0000000000"      'ダミー用団体事業部・室部・所属コード

Const IGNORE_EXCEPT_NO_RSVFRA = "1"     '予約枠無視権限(枠なしの日付を除く強制予約が可能)
Const IGNORE_ANY              = "2"     '予約枠無視権限(あらゆる強制予約が可能)

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objConsult          '受診情報アクセス用
Dim objContract         '契約情報アクセス用
Dim objFree             '汎用情報アクセス用
Dim objSchedule         'スケジュール情報アクセス用
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
Dim objOrganization    '団体情報アクセス用
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###


'### 2013.08.03 特定保健指導対象者チェックの為追加　Start ###
Dim objSpecialInterview '特定保健指導チェック用
'### 2013.08.03 特定保健指導対象者チェックの為追加　End   ###

'前画面から送信されるパラメータ値(更新のみ)
Dim strRsvNo            '予約番号

'前画面から送信されるパラメータ値(処理モード)
Dim strMode             '処理モード

'前画面から送信されるパラメータ値(その他)
Dim lngIgnoreFlg        '予約枠無視フラグ

'受診情報
Dim strPerId            '個人ＩＤ
Dim strAge              '受診時年齢
Dim strOrgCd1           '団体コード１
Dim strOrgCd2           '団体コード２
Dim strOrgName          '団体名称
Dim strCsCd             'コースコード
Dim strCslDivCd         '受診区分コード
Dim strCslYear          '受診年
Dim strCslMonth         '受診月
Dim strCslDay           '受診日
Dim strRsvGrpCd         '予約群コード
Dim strFirstRsvNo       '１次健診予約番号
Dim strFirstCslDate     '１次健診受診日
Dim strFirstCsName      '１次健診コース名
Dim strCtrPtCd          '契約パターンコード
Dim strReceiptMode      '受付処理モード
Dim strReceiptDayId     '発番を行う当日ＩＤ
Dim lngCurDayId         '現在の当日ＩＤ
Dim strCancelFlg        'キャンセルフラグ
Dim lngCurCancelFlg     '現在のキャンセルフラグ
'## 2004.10.13 Add By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
Dim strBefPerId         '現在の個人ＩＤ
'## 2004.10.13 Add End

'個人情報
Dim strLastName         '姓
Dim strFirstName        '名
Dim strLastKName        'カナ姓
Dim strFirstKName       'カナ名
Dim strBirth            '生年月日(西暦)
Dim strEraBirth         '生年月日(和暦)
Dim strGender           '性別

'受診付属情報
Dim lngRsvStatus        '予約状況
Dim	lngPrtOnSave        '保存時印刷
Dim	strCardAddrDiv      '確認はがき宛先
Dim	lngCardOutEng       '確認はがき英文出力
Dim	strFormAddrDiv      '一式書式宛先
Dim	lngFormOutEng       '一式書式英文出力
Dim	strReportAddrDiv    '成績書宛先
Dim	lngReportOutEng     '成績書英文出力
Dim	strVolunteer        'ボランティア
Dim	strVolunteerName    'ボランティア名
Dim	strCollectTicket    '利用券回収
Dim	lngIssueCslTicket   '診察券発行
Dim	strBillPrint        '請求書出力
Dim	strIsrSign          '保険証記号
Dim	strIsrNo            '保険証番号
Dim	strIsrManNo         '保険者番号
Dim	strEmpNo            '社員番号
Dim	strIntroductor      '紹介者
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Dim strSendMailDiv      '予約確認メール送信先
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

'オプション検査情報
Dim strOptCd            'オプションコード
Dim strOptBranchNo      'オプション枝番

'コース情報
Dim strArrCsCd          'コースコード
Dim strArrCsName        'コース名
Dim lngCsCount          'コース数

'受診区分情報
Dim strArrCslDivCd      '受診区分コード
Dim strArrCslDivName    '受診区分名
Dim lngCslDivCount      '受診区分数

'予約群情報
Dim strArrRsvGrpCd      '予約群コード
Dim strArrRsvGrpName    '予約群名称
Dim lngRsvGrpCount      '予約群数

'汎用情報
Dim strFreeCd           '汎用コード
Dim strFreeField1       '汎用フィールド１

Dim strUpdUser          '更新者
Dim dtmCslDate          '受診年月日
Dim strDayId            '当日ＩＤ
Dim strEditOptCd        'オプションコード(hiddenタグ編集用)
Dim strEditOptBranchNo  'オプション枝番(hiddenタグ編集用)
Dim strHTML             'HTML文字列
Dim strMessage          'エラーメッセージ
Dim strArrMessage       'エラーメッセージの配列
Dim Ret                 '関数戻り値
Dim i                   'インデックス

'### 2013.08.03 特定保健指導対象者チェックの為追加　Start ###
Dim lngSpCheck    '特定保健指導対象かチェック
'### 2013.08.03 特定保健指導対象者チェックの為追加　End   ###

Dim strWkCslDate        '受診日
Dim strRealAge          '実年齢

'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
Dim strHighLight    ' 団体名称ハイライト表示区分
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###


'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###

'### 2013.08.03 特定保健指導対象者チェックの為追加　Start ###
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2013.08.03 特定保健指導対象者チェックの為追加　End   ###

'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得(受診情報)
strRsvNo        = Request("rsvNo")
strMode         = Request("mode")
lngIgnoreFlg    = CLng("0" & Request("ignoreFlg"))
strPerId        = Request("perId")
strAge          = Request("age")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgName      = Request("orgName")
strCsCd         = Request("csCd")
strCslDivCd     = Request("cslDivCd")
strCslYear      = Request("cslYear")
strCslMonth     = Request("cslMonth")
strCslDay       = Request("cslDay")
strRsvGrpCd     = Request("rsvGrpCd")
strFirstRsvNo   = Request("firstRsvNo")
strFirstCslDate = Request("firstCslDate")
strFirstCsName  = Request("firstCsName")
strCtrPtCd      = Request("ctrPtCd")
strReceiptMode  = Request("receiptMode")
strReceiptDayId = Request("dayId")
lngCurDayId     = CLng("0" & Request("curDayId"))
strCancelFlg    = Request("cancelFlg")
lngCurCancelFlg = CLng("0" & Request("curCancelFlg"))
'## 2004.10.13 Add By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
strBefPerId     = Request("befPerId")
'## 2004.10.13 Add End

'引数値の取得(個人情報)
strLastName      = Request("lastName")
strFirstName     = Request("firstName")
strLastKName     = Request("lastKName")
strFirstKName    = Request("firstKName")
strBirth         = Request("birth")
strEraBirth      = Request("eraBirth")
strGender        = Request("gender")

'引数値の取得(受診付属情報)
lngRsvStatus      = CLng("0" & Request("rsvStatus"))
lngPrtOnSave      = CLng("0" & Request("prtOnSave"))
strCardAddrDiv    = Request("cardAddrDiv")
lngCardOutEng     = CLng("0" & Request("cardOutEng"))
strFormAddrDiv    = Request("formAddrDiv")
lngFormOutEng     = CLng("0" & Request("formOutEng"))
strReportAddrDiv  = Request("reportAddrDiv")
lngReportOutEng   = CLng("0" & Request("reportOutEng"))
strVolunteer      = Request("volunteer")
strVolunteerName  = Request("volunteerName")
strCollectTicket  = Request("collectTicket")
lngIssueCslTicket = CLng("0" & Request("issueCslTicket"))
strBillPrint      = Request("billPrint")
strIsrSign        = Request("isrSign")
strIsrNo          = Request("isrNo")
strIsrManNo       = Request("isrManNo")
strEmpNo          = Request("empNo")
strIntroductor    = Request("introductor")
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
strSendMailDiv    = Request("sendMailDiv")
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

'引数値の取得(オプション検査情報)
strOptCd        = IIf(Request("optCd")       <> "", ConvIStringToArray(Request("optCd")),       Empty)
strOptBranchNo  = IIf(Request("optBranchNo") <> "", ConvIStringToArray(Request("optBranchNo")), Empty)

'受診年月日が渡されていない場合、システム年月日を適用する
If strCslYear = "" Then
    strCslYear  = CStr(Year(Now))
    strCslMonth = CStr(Month(Now))
    strCslDay   = CStr(Day(Now))
End If

'チェック・更新・読み込み処理の制御
Do

    '各モードごとの更新処理分岐
    Select Case strMode

        '保存時
        Case MODE_SAVE

            '入力チェック
            strArrMessage = CheckValue()
            If Not IsEmpty(strArrMessage) Then
                Exit Do
            End If

            '受診日の編集
            dtmCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)

'## 2004/04/20 Add By T.Takagi@FSIT 近い受診日で健診歴がある場合のワーニング対応
            If lngIgnoreFlg = 0 Then
                strMessage = RecentConsult_CheckRecentConsult(strPerId, dtmCslDate, strCsCd, strRsvNo)
                If strMessage <> "" Then
                    strArrMessage = Array(strMessage)
                    Exit Do
                End If

'## 2005/09/08 Add By 李　年度内に２回目予約を行う場合、ワーニング対応　　
                strMessage = ""
                strMessage = objConsult.CheckConsult_Ctr(strPerId, dtmCslDate, strCsCd, strOrgCd1, strOrgCd2, strRsvNo)
                If strMessage <> "" Then
                    strArrMessage = Array(strMessage)
                    Exit Do
                End If
'## 2005/09/08 Add End  ---------------------------------------------

            End If
'## 2004/04/20 Add End


            '予約番号が指定されている場合
            If strRsvNo <> "" Then

                '受診情報の更新
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
'## 2004.10.13 Mod By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
''				Ret = objConsult.UpdateConsult( _
''						  strRsvNo,         dtmCslDate,         strPerId,         _
''						  strCsCd,          strOrgCd1,          strOrgCd2,        _
''						  strRsvGrpCd,      strAge,             strUpdUser,       _
''						  strCtrPtCd,       strFirstRsvNo,      "",               _
''						  "",               strCslDivCd,        lngRsvStatus,     _
''						  lngPrtOnSave,     strCardAddrDiv,     lngCardOutEng,    _
''						  strFormAddrDiv,   lngFormOutEng,      strReportAddrDiv, _
''						  lngReportOutEng,  strVolunteer,       strVolunteerName, _
''						  strCollectTicket, lngIssueCslTicket,  strBillPrint,     _
''						  strIsrSign,       strIsrNo,           strIsrManNo,      _
''						  strEmpNo,         strIntroductor,     lngCurDayId,      _
''						  strOptCd,         strOptBranchNo,     strReceiptMode,   _
''						  strReceiptDayId,  strMessage,         lngIgnoreFlg,     _
''						  Request.ServerVariables("REMOTE_ADDR")                  _
''				)
'                Ret = objConsult.UpdateConsult( _
'                          strRsvNo,         dtmCslDate,         strPerId,         _
'                          strCsCd,          strOrgCd1,          strOrgCd2,        _
'                          strRsvGrpCd,      strAge,             strUpdUser,       _
'                          strCtrPtCd,       strFirstRsvNo,      "",               _
'                          "",               strCslDivCd,        lngRsvStatus,     _
'                          lngPrtOnSave,     strCardAddrDiv,     lngCardOutEng,    _
'                          strFormAddrDiv,   lngFormOutEng,      strReportAddrDiv, _
'                          lngReportOutEng,  strVolunteer,       strVolunteerName, _
'                          strCollectTicket, lngIssueCslTicket,  strBillPrint,     _
'                          strIsrSign,       strIsrNo,           strIsrManNo,      _
'                          strEmpNo,         strIntroductor,     lngCurDayId,      _
'                          strOptCd,         strOptBranchNo,     strReceiptMode,   _
'                          strReceiptDayId,  strMessage,         lngIgnoreFlg,     _
'                          Request.ServerVariables("REMOTE_ADDR"),                 _
'                          strBefPerId                                             _
'                )
''## 2004.10.13 Mod End
                Ret = objConsult.UpdateConsult( _
                          strRsvNo,         dtmCslDate,         strPerId,         _
                          strCsCd,          strOrgCd1,          strOrgCd2,        _
                          strRsvGrpCd,      strAge,             strUpdUser,       _
                          strCtrPtCd,       strFirstRsvNo,      "",               _
                          "",               strCslDivCd,        lngRsvStatus,     _
                          lngPrtOnSave,     strCardAddrDiv,     lngCardOutEng,    _
                          strFormAddrDiv,   lngFormOutEng,      strReportAddrDiv, _
                          lngReportOutEng,  strVolunteer,       strVolunteerName, _
                          strCollectTicket, lngIssueCslTicket,  strBillPrint,     _
                          strIsrSign,       strIsrNo,           strIsrManNo,      _
                          strEmpNo,         strIntroductor,     lngCurDayId,      _
                          strOptCd,         strOptBranchNo,     strReceiptMode,   _
                          strReceiptDayId,  strMessage,         lngIgnoreFlg,     _
                          Request.ServerVariables("REMOTE_ADDR"),                 _
                          strBefPerId,      strSendMailDiv                        _
                )
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

            '予約番号が指定されていない場合
            Else

                '受診情報の挿入
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
'                Ret = objConsult.InsertConsult( _
'                          dtmCslDate,        strPerId,         strCsCd,          _
'                          strOrgCd1,         strOrgCd2,        strRsvGrpCd,      _
'                          strAge,            strUpdUser,       strCtrPtCd,       _
'                          strFirstRsvNo,     "",               "",               _
'                          strCslDivCd,       lngRsvStatus,     lngPrtOnSave,     _
'                          strCardAddrDiv,    lngCardOutEng,    strFormAddrDiv,   _
'                          lngFormOutEng,     strReportAddrDiv, lngReportOutEng,  _
'                          strVolunteer,      strVolunteerName, strCollectTicket, _
'                          lngIssueCslTicket, strBillPrint,     strIsrSign,       _
'                          strIsrNo,          strIsrManNo,      strEmpNo,         _
'                          strIntroductor,    strOptCd,         strOptBranchNo,   _
'                          strReceiptMode,    strReceiptDayId,  strMessage,       _
'                          lngIgnoreFlg,                                          _
'                          Request.ServerVariables("REMOTE_ADDR")                 _
'                )
                Ret = objConsult.InsertConsult( _
                          dtmCslDate,        strPerId,         strCsCd,          _
                          strOrgCd1,         strOrgCd2,        strRsvGrpCd,      _
                          strAge,            strUpdUser,       strCtrPtCd,       _
                          strFirstRsvNo,     "",               "",               _
                          strCslDivCd,       lngRsvStatus,     lngPrtOnSave,     _
                          strCardAddrDiv,    lngCardOutEng,    strFormAddrDiv,   _
                          lngFormOutEng,     strReportAddrDiv, lngReportOutEng,  _
                          strVolunteer,      strVolunteerName, strCollectTicket, _
                          lngIssueCslTicket, strBillPrint,     strIsrSign,       _
                          strIsrNo,          strIsrManNo,      strEmpNo,         _
                          strIntroductor,    strOptCd,         strOptBranchNo,   _
                          strReceiptMode,    strReceiptDayId,  strMessage,       _
                          lngIgnoreFlg,                                          _
                          Request.ServerVariables("REMOTE_ADDR"),                _
                          strSendMailDiv                                         _
                )
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

            End If

            'エラー時のメッセージ編集処理
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            'エラーがなければ予約番号付きで親フレームのURLをREPLACE。必要に応じて印刷ダイアログを表示。
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
            strHTML = strHTML & vbCrLf & "<!--"

            '「はがき」「送付案内」のいずれかの印刷を要する場合
            If lngRsvStatus = 0 Then

                Select Case lngPrtOnSave
                    Case 1
                        strHTML = strHTML & vbCrLf & "top.showPrintCardDialog('" & Ret & "','0','" & strCardAddrDiv & "','" & lngCardOutEng & "');"
                    Case 2
                        strHTML = strHTML & vbCrLf & "top.showPrintFormDialog('" & Ret & "','0','" & strFormAddrDiv & "','" & lngFormOutEng & "');"
                End Select

            End If

            strHTML = strHTML & vbCrLf & "top.location.replace('rsvMain.asp?rsvNo=" & Ret & "');"
            strHTML = strHTML & vbCrLf & "//-->"
            strHTML = strHTML & vbCrLf & "</SCRIPT>"
            strHTML = strHTML & vbCrLf & "</HTML>"
            Response.Write strHTML
            Response.End

        'キャンセル時
        Case MODE_CANCEL

            '受診情報のキャンセル
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'			Ret = objConsult.CancelConsult(strRsvNo, strCancelFlg, strMessage, (Request("cancelForce") <> ""))
            Ret = objConsult.CancelConsult(strRsvNo, strUpdUser, strCancelFlg, strMessage, (Request("cancelForce") <> ""))
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            'エラーがなければ親フレームのURLをRELOADする
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '受付取り消し時
        Case MODE_CANCELRECEIPT

            '受付取り消し処理
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'			Ret = objConsult.CancelReceipt(strRsvNo, strCslYear, strCslMonth, strCslDay, strMessage)
            Ret = objConsult.CancelReceipt(strRsvNo, strUpdUser, strCslYear, strCslMonth, strCslDay, strMessage)
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            'エラーがなければ親フレームのURLをRELOADする
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '強制受付取り消し時
        Case MODE_CANCELRECEIPTFORCE

            '受付取り消し処理
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'			Ret = objConsult.CancelReceipt(strRsvNo, strCslYear, strCslMonth, strCslDay, strMessage, True)
            Ret = objConsult.CancelReceipt(strRsvNo, strUpdUser, strCslYear, strCslMonth, strCslDay, strMessage, True)
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            'エラーがなければ親フレームのURLをRELOADする
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '削除時
        Case MODE_DELETE

            '削除処理
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'			Ret = objConsult.DeleteConsult(strRsvNo, strMessage)
            Ret = objConsult.DeleteConsult(strRsvNo, strUpdUser, strMessage)
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            'エラーがなければ親フレームのURLをREPLACEする
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.replace('rsvMain.asp')"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '復元時
        Case MODE_RESTORE

'## 2005/09/08 Add By 李　年度内に２回目予約を行う場合、ワーニング対応　　
            If lngIgnoreFlg = 0 Then
                strMessage = ""
                strMessage = objConsult.CheckConsult_Ctr(strPerId, dtmCslDate, strCsCd, strOrgCd1, strOrgCd2, strRsvNo)
                If strMessage <> "" Then
                    strArrMessage = Array(strMessage)
                    Exit Do
                End If
            End If
'## 2005/09/08 Add End  ---------------------------------------------

            '復元処理
            Ret = objConsult.RestoreConsult(strRsvNo, strUpdUser, strMessage, lngIgnoreFlg)
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            'エラーがなければ親フレームのURLをRELOADする
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

    End Select

    '予約番号が指定されている場合
    If strRsvNo <> "" Then

        '受診情報読み込み
        If objConsult.SelectConsult( _
               strRsvNo,      strCancelFlg,    dtmCslDate,           _
               strPerId,      strCsCd, ,       strOrgCd1,            _
               strOrgCd2,     strOrgName, , ,  strAge, , , , , , , , _
               strFirstRsvNo, strFirstCslDate, strFirstCsName, , ,   _
               strDayId, , , , , , , , , , , , , , , ,               _
               strCtrPtCd, ,  strLastName,     strFirstName,         _
               strLastKName,  strFirstKName,   strBirth,             _
               strGender, , , , , strCslDivCd, strRsvGrpCd           _
           ) = False Then
            Err.Raise 1000, ,"受診情報が存在しません。"
        End If

        '受診年月日の編集
        dtmCslDate = CDate(dtmCslDate)
        strCslYear  = CStr(Year(dtmCslDate))
        strCslMonth = CStr(Month(dtmCslDate))
        strCslDay   = CStr(Day(dtmCslDate))

        '生年月日(西暦＋和暦)の編集
        strEraBirth = objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d")

        '現当日ＩＤおよびキャンセルフラグの退避
        lngCurDayId     = CLng("0" & strDayId)
        lngCurCancelFlg = CLng("0" & strCancelFlg)

'## 2004.10.13 Add By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
        '現個人ＩＤの退避
        strBefPerId = strPerId
'## 2004.10.13 Add End

        'オプション検査情報の読み込み
        objConsult.SelectConsult_O strRsvNo, strOptCd, strOptBranchNo

        '### 2013.08.03 特定保健指導対象者チェックの為追加　Start ###
        '特定保険指導対象者チェック
        lngSpCheck = objSpecialInterview.CheckSpecialTarget(strRsvNo)
        '### 2013.08.03 特定保健指導対象者チェックの為追加　End   ###

        '### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
        objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight
        '### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###

    End If

    Exit Do
Loop

Set objConsult = Nothing

'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 : エラーメッセージの配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCourse       'コース情報アクセス用

    Dim strSecondFlg    '２次健診フラグ
    Dim strMessage      'エラーメッセージ
    Dim i, j            'インデックス

    'オブジェクトのインスタンス作成
    Set objCourse = Server.CreateObject("HainsCourse.Course")

    '指定コースが２次健診かを判定
    objCourse.SelectCourse strCsCd, , , , , , , strSecondFlg

    '２次健診の場合、１次健診予約番号は必須
    If strSecondFlg = "1" And strFirstRsvNo = "" Then
        objCommon.AppendArray strMessage, "関連健診を指定してください。"
    End If

    '保留状態での受付はできない
    '#### 2007/04/04 張 予約状況区分追加によって修正 Start ####
    'If CLng(strReceiptMode) > 0 And lngRsvStatus = 1 Then
    '    objCommon.AppendArray strMessage, "この受診情報は保留されています。受付できません。"
    'End If
    If CLng(strReceiptMode) > 0 And lngRsvStatus <> 0 Then
        objCommon.AppendArray strMessage, "この受診情報は【保留】又は【未確定】状態です。受付できません。"
    End If
    '#### 2007/04/04 張 予約状況区分追加によって修正 End   ####

    'ボランティア名、保険証記号・番号、保険者番号、社員番号
    objCommon.AppendArray strMessage, objCommon.CheckWideValue("ボランティア名", strVolunteerName, 50)

'#### 2008/11/28 張 保険証記号・番号欄に全角文字も登録できるように修正 Start   ####
'    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("保険証記号",   strIsrSign,  16)
'    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("保険証番号",   strIsrNo,    16)
    objCommon.AppendArray strMessage, objCommon.CheckLength("保険証記号",   strIsrSign,  16)
    objCommon.AppendArray strMessage, objCommon.CheckLength("保険証番号",   strIsrNo,    16)
'#### 2008/11/28 張 保険証記号・番号欄に全角文字も登録できるように修正 End     ####

'#### 2008/09/22 張 保険者番号欄をコメント欄に用途変更（全角文字も登録できるように修正） Start   ####
'###### 2010/05/26 張 コメント欄を元の保険者番号欄に戻す Start   ####
    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("保険者番号",   strIsrManNo, 16)
'    objCommon.AppendArray strMessage, objCommon.CheckLength("コメント",   strIsrManNo, 16)
'###### 2010/05/26 張 コメント欄を元の保険者番号欄に戻す End     ####
'#### 2008/09/22 張 保険者番号欄をコメント欄に用途変更（全角文字も登録できるように修正） End     ####

    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("社員番号",     strEmpNo,    12)

    'エラーメッセージが存在する場合はその内容を返す
    If Not IsEmpty(strMessage) Then
        CheckValue = strMessage
    End If

    set objCourse = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>予約情報詳細</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winConsult;                 // 健診歴一覧画面

var curYear, curMonth, curDay;  // 日付ガイド呼び出し直前の日付退避用変数
var curOrgCd1, curOrgCd2;       // 団体検索ガイド呼び出し直前の団体退避用変数

// 現在日の取得
function getCurrentDate() {

    var myForm = document.entryForm;
    curYear  = myForm.cslYear.value;
    curMonth = myForm.cslMonth.value;
    curDay   = myForm.cslDay.value;

}

// 日付ガイドまたはカレンダー検索画面呼び出し
function callCalGuide() {

    var mainForm = top.main.document.entryForm; // メイン画面のフォームエレメント
    var optForm  = top.opt.document.entryForm;  // オプション検査画面のフォームエレメント

    // カレンダー検索に必要な項目のチェック
    for ( var ret = false; ; ) {
        if ( mainForm.perId.value == '' ) break;
        if ( mainForm.orgCd1.value == '' || mainForm.orgCd2.value == '' ) break;
        if ( mainForm.csCd.value == '' ) break;
        if ( mainForm.cslDivCd.value == '' ) break;
        if ( !top.isDate( mainForm.cslYear.value, mainForm.cslMonth.value, mainForm.cslDay.value ) ) break;
        if ( optForm == null ) break;
        if ( optForm.ctrPtCd.value == '' ) break;
        if ( mainForm.age.value == '' ) break;
        ret = true;
        break;
    }

    // ガイド呼び出し直前の日付を退避
    getCurrentDate();

    // 入力チェック
    if ( !ret ) {

        // チェックエラー、すなわちカレンダー検索できない場合は日付ガイドを呼ぶ

        // 日付ガイド表示
        calGuide_showGuideCalendar( 'cslYear', 'cslMonth', 'cslDay', checkDateChanged );

    // さもなくばカレンダー検索画面を呼ぶ
    } else {

        top.header.callCalendar();

    }

}

// 健診歴一覧画面呼び出し
function callConsultWindow() {

    var opened = false;     // 画面が開かれているか
    var url;                // 健診歴一覧画面のURL

    // 入力チェック
    if ( !top.checkValue( 2 ) ) {
        return;
    }

    // すでにガイドが開かれているかチェック
    if ( winConsult != null ) {
        if ( !winConsult.closed ) {
            opened = true;
        }
    }

    // 健診歴一覧画面のURL編集
    url = 'rsvConsultList.asp';
    url = url + '?perId='    + document.entryForm.perId.value;
    url = url + '&cslYear='  + document.entryForm.cslYear.value;
    url = url + '&cslMonth=' + document.entryForm.cslMonth.value;
    url = url + '&cslDay='   + document.entryForm.cslDay.value;
    url = url + '&rsvNo='    + document.entryForm.rsvNo.value;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winConsult.focus();
        winConsult.location.replace( url );
    } else {
        winConsult = open( url, '', 'toolbar=no,directories=no,menubar=no,resizable=no,scrollbars=yes,width=300,height=400' );
    }

}

// 団体検索ガイド呼び出し
function callOrgGuide() {

    // ガイド呼び出し直前の日付を退避
    curOrgCd1 = document.entryForm.orgCd1.value;
    curOrgCd2 = document.entryForm.orgCd2.value;

    // 団体検索ガイド表示
//    orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, 'dspOrgName', null, null, changeOrg );

    orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, 'dspOrgName', null, null, changeOrg, null, null, null, null, null, null, null, null, null, null, null, null, null, null, document.entryForm.sendComment);



}

// 個人検索ガイド呼び出し
function callPersonGuide() {

    // 編集用の関数定義
    perGuide_CalledFunction = setPersonInfo;

    // ガイド画面を表示
    var url = '/webHains/contents/guide/gdePersonal.asp?mode=1&defPerId=' + document.entryForm.perId.value;
<%
    If strRsvNo <> "" Then
%>
        url = url + '&defGender=' + document.entryForm.gender.value;
<%
    End If
%>
    perGuide_openWindow( url );

}

// コース変更時の処理
function changeCourse() {

    document.entryForm.csCd.value = document.entryForm.ctrCsCd.value;

    // １次健診歴情報の制御
    controlFirstCslInfo();

    // オプション検査画面の更新
    replaceOptionFrame( false, false, false );
}

// 受診日変更時の処理
function changeDate() {

    // １次健診歴の内容をクリアする
    clearFirstCslInfo();

    // 現表示中の健診歴一覧画面を閉じる
    closeConsultWindow();

    // オプション検査画面の更新
    replaceOptionFrame( false, false, true );

// ## 2003.01.13 Add By T.Takagi 保存時印刷制御方法変更
    // 保存時印刷制御
    top.controlPrtOnSave();
// ## 2003.01.13 Add end

}

// 受診日変更チェック
function checkDateChanged() {

    // 退避していた日付と異なる場合、受診日変更時の処理を呼び出す
    if ( document.entryForm.cslYear.value != curYear || document.entryForm.cslMonth.value != curMonth || document.entryForm.cslDay.value != curDay ) {
        changeDate();
    }

}

// 受診区分変更時の処理
function changeCslDiv() {

    document.entryForm.cslDivCd.value = document.entryForm.ctrCslDivCd.value;

    // オプション検査画面の更新
    replaceOptionFrame( false, false, false );
}

// 予約群変更時の処理
function changeRsvGrp() {

    document.entryForm.rsvGrpCd.value = document.entryForm.selRsvGrpCd.value;

}

// 団体変更時の処理
function changeOrg() {

    // 団体名称の格納
    document.entryForm.orgName.value = document.getElementById('dspOrgName').innerHTML;

    // 退避していた団体と異なる場合、オプション検査画面を更新する
    if ( document.entryForm.orgCd1.value != curOrgCd1 || document.entryForm.orgCd2.value != curOrgCd2 ) {
        replaceOptionFrame( false, false, false );
    }

    // 受診付属情報の請求書出力制御
// ## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
//  top.other.setBillPrintVisibility( ( orgGuide_BillCslDiv != '' ) );
    top.other.setBillPrintVisibility( ( orgGuide_BillCslDiv != '' || orgGuide_ReptCslDiv != '' ) );
// ## 2004.01.29 Mod End

/** 2016.09.19 張 団体情報送付案内コメント追加 STR **/
    top.other.document.getElementById('sendCommentVal').innerHTML = document.entryForm.sendComment.value;
/** 2016.09.19 張 団体情報送付案内コメント追加 END **/

}

// 健診歴一覧画面を閉じる
function closeConsultWindow() {

    // 健診歴一覧画面を閉じる
    if ( winConsult != null ) {
        if ( !winConsult.closed ) {
            winConsult.close();
        }
    }

    winConsult = null;
}

// サブ画面を閉じる
function closeWindow() {
    perGuide_closeGuidePersonal();  // 個人検索ガイド
    orgGuide_closeGuideOrg();       // 団体検索ガイド
    calGuide_closeGuideCalendar();  // 日付ガイド
    closeConsultWindow();           // 健診歴一覧ガイド
}

// １次健診歴のクリア
function clearFirstCslInfo() {
    top.setFirstCslInfo( '', '', '' );
}

// １次健診歴情報の制御
function controlFirstCslInfo() {

    // 変更後のコースが２次健診コースでない場合
    if ( !top.isSecondCourse( document.entryForm.csCd.value ) ) {

        // １次健診歴の内容をクリアする
        clearFirstCslInfo();

        // 現表示中の健診歴一覧画面を閉じる
        closeConsultWindow();

    }

}

// 個人情報の編集
function editPerson() {

    var perName    = '';    // 氏名
    var perKName   = '';    // カナ氏名
    var birthName  = '';    // 生年月日
    var ageName    = '';    // 年齢
    var genderName = '';    // 性別

    // 氏名の編集
    perName = document.entryForm.lastName.value;
    if ( document.entryForm.firstName.value != '' ) {
        perName = perName + '　' + document.entryForm.firstName.value;
    }

    // 氏名が存在する場合はアンカーを張る
    if ( perName != '' ) {
        perName = '<A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=' + document.entryForm.perId.value + '" TARGET="_blank"><B>' + perName + '<\/B><\/A>';
    }

    // カナ氏名の編集
    perKName = document.entryForm.lastKName.value;
    if ( document.entryForm.firstKName.value != '' ) {
        perKName = perKName + '　' + document.entryForm.firstKName.value;
    }

    // カナ氏名が存在する場合は括弧でくくる
    if ( perName != '' ) {
        perKName = '<FONT SIZE=\"1\">' + perKName + '</FONT>';
    }

    // 生年月日の編集
    if ( document.entryForm.eraBirth.value != '' ) {
        birthName = document.entryForm.eraBirth.value + '生';
    }

    // 実年齢の編集
    if ( document.entryForm.realAge.value != '' ) {
        ageName = document.entryForm.realAge.value + '歳';
    }

    // 受診情報の受診時年齢編集
    if ( document.entryForm.age.value != '' ) {
        ageName = ageName + '（' + document.entryForm.age.value.substring(0, document.entryForm.age.value.indexOf('.')) + '歳）';
    }

    // 性別の編集
    switch ( document.entryForm.gender.value ) {
        case '<%= GENDER_MALE %>':
            genderName = '男性';
            break;
        case '<%= GENDER_FEMALE %>':
            genderName = '女性';
        default:
    }

    // 個人情報の編集
    document.getElementById('dspPerId').innerHTML   = document.entryForm.perId.value;
    document.getElementById('dspPerName').innerHTML = perKName + '<BR>' + perName;
    document.getElementById('dspBirth').innerHTML   = birthName;
    document.getElementById('dspAge').innerHTML     = ageName;
    document.getElementById('dspGender').innerHTML  = genderName;

}

// オプション検査画面読み込み
function replaceOptionFrame( initFlg, perChanged, dateChanged ) {

    var myForm  = document.entryForm;           // 自画面のフォームエレメント
    var optForm = document.optionForm;          // 受診オプション検査保持用のフォームエレメント
    var setForm = top.opt.document.entryForm;   // オプション検査画面のフォームエレメント

    // 受付画面を開いたままオプション画面にリロードが発生すると、詳細画面と受付画面との整合性がとれなくなるため、ここで閉じる
    if ( top.header.closeReceiptWindow ) {
        top.header.closeReceiptWindow();
    }

    // オプション検査情報読み込み
    var url = '/webHains/contents/reserve/rsvOption.asp';
    url = url + '?rsvNo='     + myForm.rsvNo.value;
    url = url + '&cancelFlg=' + myForm.curCancelFlg.value;
    url = url + '&perId='     + myForm.perId.value;
    url = url + '&gender='    + myForm.gender.value;
    url = url + '&birth='     + myForm.birth.value;
    url = url + '&orgCd1='    + myForm.orgCd1.value;
    url = url + '&orgCd2='    + myForm.orgCd2.value;
    url = url + '&csCd='      + myForm.csCd.value;
    url = url + '&cslDate='   + myForm.cslYear.value + '/' + myForm.cslMonth.value + '/' + myForm.cslDay.value;
    url = url + '&cslDivCd='  + myForm.cslDivCd.value;
    url = url + '&rsvGrpCd='  + myForm.rsvGrpCd.value;

    // 読み込み直後のセット情報
    url = url + '&ctrPtCd='   + optForm.ctrPtCd.value;
    url = url + '&optCd='     + optForm.optCd.value;
    url = url + '&optBNo='    + optForm.optBranchNo.value;

    // オプション検査画面にてセット情報が表示されている場合
    if ( setForm ) {

        // オプション検査画面の現チェック状態を取得する
        var arrOptCd       = new Array();
        var arrOptBranchNo = new Array();
        top.convOptCd( top.opt.document.optList, arrOptCd, arrOptBranchNo );

        // 引数に追加
        url = url + '&nowCtrPtCd=' + setForm.ctrPtCd.value;
        url = url + '&nowOptCd='   + arrOptCd;
        url = url + '&notOptBNo='  + arrOptBranchNo;

    }

    url = url + '&showAll=' + optForm.showAll.value;

    // 初期読み込みか
    if ( initFlg ) {
        url = url + '&init=1';
    }

// ## 2004.10.27 Add By T.Takagi@FSIT 日付変更時はセット比較画面を自動表示
    if ( dateChanged ) {
        url = url + '&dateChanged=1';
    }
// ## 2004.10.27 Add End

    // オプション検査画面の読み込み
    top.opt.location.replace( url );

}

// 個人情報のセット
function setPersonInfo( perInfo, calledMaintenance ) {

    var curPerId;   // 個人ＩＤ
    var curBirth;   // 生年月日
    var curGender;  // 性別

    var replaceOpt = false; // オプション検査画面更新の必要性
    var perChanged = false;

    var myForm = document.entryForm;

    // 現在の個人情報を退避
    curPerId  = myForm.perId.value;
    curBirth  = myForm.birth.value;
    curGender = myForm.gender.value;

    // 個人情報メンテナンス画面から呼ばれた場合
    if ( calledMaintenance ) {

        // 個人ＩＤが本画面と異なる場合は何もしない
        if ( perInfo.perId != curPerId ) {
            return;
        }

    }

    // hiddenエレメントの編集
    myForm.perId.value      = perInfo.perId;
    myForm.lastName.value   = perInfo.lastName;
    myForm.firstName.value  = perInfo.firstName;
    myForm.lastKName.value  = perInfo.lastKName;
    myForm.firstKName.value = perInfo.firstKName;
    myForm.birth.value      = perInfo.birth;
    myForm.eraBirth.value   = perInfo.birthFull;
    myForm.gender.value     = perInfo.gender;

    // 個人情報の編集
    editPerson();

    // 受診付属情報の住所を編集
    top.other.document.getElementById('addr1').innerHTML = perInfo.address[0];
    top.other.document.getElementById('addr2').innerHTML = perInfo.address[1];
    top.other.document.getElementById('addr3').innerHTML = perInfo.address[2];

/** 2016.09.16 張 電話番号、特記事項取得・編集の為追加 STR **/
    top.other.document.getElementById('tel1').innerHTML = perInfo.tel[0];
    top.other.document.getElementById('tel2').innerHTML = perInfo.tel[1];
    top.other.document.getElementById('tel3').innerHTML = perInfo.tel[2];

    top.other.document.getElementById('notes').innerHTML = perInfo.notes;
/** 2016.09.16 張 電話番号、特記事項取得・編集の為追加 END **/

    // 個人情報の変更チェック
    for ( ; ; ) {

        perChanged = false;

        // 個人ＩＤが変更された場合
        if ( perInfo.perId != curPerId ) {

// ## 2003.12.12 Add By T.Takagi@FSIT 仮ＩＤかで予約状況を制御
// ## 2004.10.13 Mod By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新(仮ＩＤ判断方法が統一されていない)
//          top.other.document.entryForm.rsvStatus.value = perInfo.vidFlg == '1' ? '1' : '0';
            top.other.document.entryForm.rsvStatus.value = perInfo.perId.substring(0, 1) == '@' ? '1' : '0';
// ## 2004.10.13 Mod End
// ## 2003.12.12 Add End

            // 現在の１次健診歴内容をクリア
            clearFirstCslInfo();

            // 健診歴一覧画面を開いている場合は閉じる
            closeConsultWindow();

            // オプション検査画面の更新が必要
            replaceOpt = true;
            perChanged = true;
            break;

        }

        // 個人ＩＤは同一だが生年月日・性別のいずれかが変わった場合はオプション検査画面の更新が必要
        if ( perInfo.birth != curBirth || perInfo.gender != curGender ) {
            replaceOpt = true;
            perChanged = false;
        }

        break;
    }

    // 受診歴が選択された場合
    if ( perInfo.csCd != null ) {

        // コースが変更された場合
        if ( perInfo.csCd != myForm.csCd.value ) {

            // 値の更新
            myForm.csCd.value = perInfo.csCd;

            // １次健診歴情報の制御
            controlFirstCslInfo();

            // オプション検査画面の更新が必要
            replaceOpt = true;

        }

        // 団体が変更された場合
        if ( perInfo.lastOrgCd1 != myForm.orgCd1.value || perInfo.lastOrgCd2 != myForm.orgCd2.value ) {

            // 再編集
            myForm.orgCd1.value  = perInfo.lastOrgCd1;
            myForm.orgCd2.value  = perInfo.lastOrgCd2;
            myForm.orgName.value = perInfo.lastOrgName;
            document.getElementById('dspOrgName').innerHTML = perInfo.lastOrgName;

            // オプション検査画面の更新が必要
            replaceOpt = true;

        }

        // 受診区分が変更された場合は更新し、かつオプション検査画面の更新が必要
        if ( perInfo.cslDivCd != myForm.cslDivCd.value ) {
            myForm.cslDivCd.value = perInfo.cslDivCd;
            replaceOpt = true;
        }

        // 継承すべき項目の編集
        var otherForm = top.other.document.entryForm;
        otherForm.cardAddrDiv.value   = perInfo.cardAddrDiv;    // 確認はがき宛先
        otherForm.formAddrDiv.value   = perInfo.formAddrDiv;    // 一式書式宛先
        otherForm.reportAddrDiv.value = perInfo.reportAddrDiv;  // 成績書宛先
        otherForm.volunteer.value     = perInfo.volunteer;      // ボランティア
        otherForm.volunteerName.value = perInfo.volunteerName;  // ボランティア名
        otherForm.isrSign.value       = perInfo.isrSign;        // 保険証記号
        otherForm.isrNo.value         = perInfo.isrNo;          // 保険証番号
        otherForm.isrManNo.value      = perInfo.isrManNo;       // 保険者番号
        otherForm.empNo.value         = perInfo.empNo;          // 社員番号
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
        otherForm.sendMailDiv.value   = perInfo.sendMailDiv;    // 予約確認メール送信先
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>

    }

    // オプション検査画面の更新が必要な場合
    if ( replaceOpt ) {

        // 現在の年齢値をクリア
        myForm.age.value = '';
        document.getElementById('dspAge').innerHTML = '';

        // オプション検査画面の更新
        replaceOptionFrame( false, perChanged, false );

    }

}

// 初期表示時の編集処理
function setValue() {
    editPerson();                               // 個人情報編集
    replaceOptionFrame( true, false, false );   // オプション検査画面読み込み
    top.setFirstCslInfo('<%= strFirstRsvNo %>','<%= strFirstCslDate %>','<%= strFirstCsName %>');	// １次健診情報編集
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 20px 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setValue()" ONUNLOAD="JavaScript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="mode"       VALUE="">
<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= strRsvNo      %>">
<INPUT TYPE="hidden" NAME="perId"      VALUE="<%= strPerId      %>">
<INPUT TYPE="hidden" NAME="orgCd1"     VALUE="<%= strOrgCd1     %>">
<INPUT TYPE="hidden" NAME="orgCd2"     VALUE="<%= strOrgCd2     %>">
<INPUT TYPE="hidden" NAME="orgName"    VALUE="<%= strOrgName    %>">
<INPUT TYPE="hidden" NAME="lastName"   VALUE="<%= strLastName   %>">
<INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= strFirstName  %>">
<INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= strLastKName  %>">
<INPUT TYPE="hidden" NAME="firstKName" VALUE="<%= strFirstKName %>">
<INPUT TYPE="hidden" NAME="birth"      VALUE="<%= strBirth      %>">
<INPUT TYPE="hidden" NAME="eraBirth"   VALUE="<%= strEraBirth   %>">
<INPUT TYPE="hidden" NAME="age"        VALUE="<%= strAge        %>">
<INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender     %>">
<%'### 2016.09.19 張 %>
<INPUT TYPE="hidden" NAME="sendComment"     VALUE="">

<%
    '実年齢の計算
    strWkCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
    If IsDate(strWkCslDate) And strBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(strBirth, strWkCslDate)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '小数点以下の切り捨て
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If
%>
    <INPUT TYPE="hidden" NAME="realAge" VALUE="<%= strRealAge %>">

    <INPUT TYPE="hidden" NAME="firstRsvNo"   VALUE="">
    <INPUT TYPE="hidden" NAME="firstCslDate" VALUE="">
    <INPUT TYPE="hidden" NAME="firstCsName"  VALUE="">
<%
    '現当日ＩＤ、現キャンセルフラグを保持する
%>
    <INPUT TYPE="hidden" NAME="curDayId"     VALUE="<%= lngCurDayId     %>">
    <INPUT TYPE="hidden" NAME="curCancelFlg" VALUE="<%= lngCurCancelFlg %>">
<%
    '最新の受診オプション検査を格納するためのエレメント
%>
    <INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="">
    <INPUT TYPE="hidden" NAME="optCd"       VALUE="">
    <INPUT TYPE="hidden" NAME="optBranchNo" VALUE="">
<%
    '受付処理のためのエレメント
%>
    <INPUT TYPE="hidden" NAME="receiptMode" VALUE="0">
    <INPUT TYPE="hidden" NAME="dayId"       VALUE="0">
<%
    'キャンセル処理のためのエレメント
%>
    <INPUT TYPE="hidden" NAME="cancelFlg"   VALUE="<%= strCancelFlg %>">
    <INPUT TYPE="hidden" NAME="cancelForce" VALUE="">
<%
    'その他検査画面の更新項目を格納するためのエレメント
%>
    <INPUT TYPE="hidden" NAME="rsvStatus"      VALUE="">
    <INPUT TYPE="hidden" NAME="prtOnSave"      VALUE="">
    <INPUT TYPE="hidden" NAME="cardAddrDiv"    VALUE="">
    <INPUT TYPE="hidden" NAME="cardOutEng"     VALUE="">
    <INPUT TYPE="hidden" NAME="formAddrDiv"    VALUE="">
    <INPUT TYPE="hidden" NAME="formOutEng"     VALUE="">
    <INPUT TYPE="hidden" NAME="reportAddrDiv"  VALUE="">
    <INPUT TYPE="hidden" NAME="reportOutEng"   VALUE="">
    <INPUT TYPE="hidden" NAME="volunteer"      VALUE="">
    <INPUT TYPE="hidden" NAME="volunteerName"  VALUE="">
    <INPUT TYPE="hidden" NAME="collectTicket"  VALUE="">
    <INPUT TYPE="hidden" NAME="issueCslTicket" VALUE="">
    <INPUT TYPE="hidden" NAME="billPrint"      VALUE="">
    <INPUT TYPE="hidden" NAME="isrSign"        VALUE="">
    <INPUT TYPE="hidden" NAME="isrNo"          VALUE="">
    <INPUT TYPE="hidden" NAME="isrManNo"       VALUE="">
    <INPUT TYPE="hidden" NAME="empNo"          VALUE="">
    <INPUT TYPE="hidden" NAME="introductor"    VALUE="">
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
    <INPUT TYPE="hidden" NAME="sendMailDiv"    VALUE="">
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>
<%
'## 2004.10.13 Add By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新

    '読み込み直後の個人ＩＤを保持
%>
    <INPUT TYPE="hidden" NAME="befPerId" VALUE="<%= strBefPerId %>">
<%
'## 2004.10.13 Add End
%>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">基本情報</FONT></B></TD>
        </TR>
    </TABLE>
    <SPAN ID="msgArea"></SPAN>
<%
    'エラーメッセージの編集
    If Not IsEmpty(strArrMessage) Then

        Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
        <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0"><TR><TD HEIGHT="5"></TD></TR></TABLE>
<%
    End If

    'キャンセル者の場合
    If lngCurCancelFlg <> CONSULT_USED Then

        Set objFree = Server.CreateObject("HainsFree.Free")

        'キャンセル理由を読み込む
        objFree.SelectFree 0, FREECD_CANCEL & lngCurCancelFlg, , , ,strFreeField1

        Set objFree = Nothing
%>
        <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
            <TR>
                <TD HEIGHT="5"></TD>
            </TR>
            <TR>
                <TD NOWRAP><FONT COLOR="#ff6600"><B>この受診情報はキャンセルされています。</B></FONT>&nbsp;&nbsp;キャンセル理由：<FONT COLOR="#ff6600"><B><%= strFreeField1 %></B></FONT></TD>
            </TR>
        </TABLE>
<%
    End If
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" WIDTH="70" NOWRAP>個人名</TD>
            <TD>：</TD>
            <TD ID="gdePerson"><A HREF="JavaScript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示します"></A></TD>
            <TD NOWRAP ID="dspPerId"></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP ID="dspPerName"></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP ID="dspBirth"></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP ID="dspAge"></TD>
            <TD>&nbsp;</TD>
            <TD WIDTH="100%" NOWRAP ID="dspGender"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" WIDTH="70" NOWRAP>団体</TD>
            <TD>：</TD>
            <TD ID="gdeOrg"><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示します"></A></TD>
            <TD WIDTH="100%" NOWRAP ID="dspOrgName"><%'= strOrgName %>

<%          If strHighLight = "1" Then  %>
                <font style='font-weight:bold; background-color:#00FFFF;'><b><%= strOrgName %></b></font>
<%          Else                        %>
                <%= strOrgName %>
<%          End If                      %>

<%          If lngSpCheck > 0 Then      %>
                <IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="特定保健指導対象"><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT="">
<%          End If                      %>
            </TD>

        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD WIDTH="70" NOWRAP>コース</TD>
            <TD>：</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD>
                            <INPUT TYPE="hidden" NAME="csCd" VALUE="<%= strCsCd %>">
                            <SELECT NAME="ctrCsCd" STYLE="width:140;" ONCHANGE="javascript:changeCourse()">
<%
                                '新規時以外(新規の場合はセレクションボックスを空にする)
                                If strRsvNo <> "" Then

                                    Set objContract = Server.CreateObject("HainsContract.Contract")

                                    '指定団体における受診日時点で有効なコースを契約管理情報を元に読み込む
                                    lngCsCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", dtmCslDate, dtmCslDate, , strArrCsCd, , strArrCsName)

                                    Set objContract = Nothing

                                    '配列添字数分のリストを追加
                                    For i = 0 To lngCsCount - 1
%>
                                        <OPTION VALUE="<%= strArrCsCd(i) %>"<%= IIf(strArrCsCd(i) = strCsCd, " SELECTED", "") %>><%= strArrCsName(i) %>
<%
                                    Next

                                End If
%>
                            </SELECT>
                        </TD>
                        <TD NOWRAP>&nbsp;受診区分：</TD>
<%
                        Set objFree = Server.CreateObject("HainsFree.Free")

                        '汎用テーブルから受診区分を読み込む
                        objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1

                        Set objFree = Nothing
%>
                        <TD>
                            <INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= strCslDivCd %>">
                            <SELECT NAME="ctrCslDivCd" STYLE="width:85;" ONCHANGE="javascript:changeCslDiv()">
<%
                                '新規時以外(新規の場合はセレクションボックスを空にする)
                                If strRsvNo <> "" Then

                                    Set objContract = Server.CreateObject("HainsContract.Contract")

                                    '指定団体における受診日時点で有効な受診区分を契約管理情報を元に読み込む(コース指定時はさらにそのコースで有効なもの)
                                    lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strCsCd, dtmCslDate, dtmCslDate, strArrCslDivCd, strArrCslDivName)

                                    Set objContract = Nothing

                                    '配列添字数分のリストを追加
                                    For i = 0 To lngCslDivCount - 1
%>
                                        <OPTION VALUE="<%= strArrCslDivCd(i) %>"<%= IIf(strArrCslDivCd(i) = strCslDivCd, " SELECTED", "") %>><%= strArrCslDivName(i) %>
<%
                                    Next

                                End If
%>
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <TD ID="dspRsvNo" NOWRAP>予約番号</TD>
            <TD ID="dspRsvNoColon">：</TD>
            <TD ALIGN="right" NOWRAP><B><%= strRsvNo %></B></TD>
        </TR>
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD>受診日時</TD>
            <TD>：</TD>
<!--
            <TD ID="gdeDate"><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示します"></A></TD>
-->
            <TD ID="gdeDate"><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="受診日を選択します"></A></TD>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("cslDay", 1, 31, strCslDay, False) %></TD>
                        <TD>日</TD>
                        <TD>
                            <INPUT TYPE="hidden" NAME="rsvGrpCd" VALUE="<%= strRsvGrpCd %>">
                            <!--SELECT NAME="selRsvGrpCd" STYLE="width:115;" ONCHANGE="javascript:changeRsvGrp()"-->
                            <!--SELECT NAME="selRsvGrpCd" STYLE="width:140;" ONCHANGE="javascript:changeRsvGrp()"-->
                            <SELECT NAME="selRsvGrpCd" STYLE="width:160;" ONCHANGE="javascript:changeRsvGrp()">
<%
                                '新規時以外(新規の場合はセレクションボックスを空にする)
                                If strRsvNo <> "" Then

                                    'オブジェクトのインスタンス作成
                                    Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

                                    '日付がシステム日付を含む以降の場合はコースで有効な群を、過去日の場合はすべての群を取得
                                    If dtmCslDate >= Date() Then

                                        '指定コースにおける有効な予約群コース受診予約群情報を元に読み込む
                                        lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

                                    Else

                                        'すべての予約群を読み込む
                                        lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strArrRsvGrpCd, strArrRsvGrpName)

                                    End If

                                    Set objSchedule = Nothing

                                    '配列添字数分のリストを追加
                                    For i = 0 To lngRsvGrpCount - 1
%>
                                        <OPTION VALUE="<%= strArrRsvGrpCd(i) %>"<%= IIf(strArrRsvGrpCd(i) = strRsvGrpCd, " SELECTED", "") %>><%= strArrRsvGrpName(i) %>
<%
                                    Next

                                End If
%>
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <TD ID="dspDayId" NOWRAP>当日ＩＤ</TD>
            <TD ID="dspDayIdColon">：</TD>
            <TD ALIGN="right" NOWRAP><B><%= IIf(lngCurDayId > 0, objCommon.FormatString(lngCurDayId, "0000"), "") %></B></TD>
        </TR>
    </TABLE>
<% '## 2003.12.12 Add By T.Takagi@FSIT 変更前の日付を出す %>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD WIDTH="70" NOWRAP>現受診日</TD>
            <TD>：</TD>
<%'### 2016.09.14 張 受診日の曜日表示 STR ###%>
            <!--TD WIDTH="100%"><B><%= objCommon.FormatString(dtmCslDate, "yyyy年mm月dd日") %></B></TD-->
            <TD WIDTH="100%"><B><%= objCommon.FormatString(dtmCslDate, "yyyy年mm月dd日 （aaa）") %></B></TD>
<%'### 2016.09.14 張 受診日の曜日表示 END ###%>
        </TR>
    </TABLE>
<% '## 2003.12.12 Add End %>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD WIDTH="70" NOWRAP>関連健診</TD>
            <TD>：</TD>
            <TD ID="gdeConsult"><A HREF="javascript:callConsultWindow()"><IMG SRC="/webHains/images/question.gif" ALT="１次健診歴ガイドを表示します" HEIGHT="21" WIDTH="21"></A></TD>
            <TD ID="delConsult"><A HREF="javascript:clearFirstCslInfo()"><IMG SRC="/webHains/images/delicon.gif" HEIGHT="21" WIDTH="21" ALT="１次健診情報をクリアします"></A></TD>
            <TD WIDTH="100%"><SPAN ID="dspFirstCslDate"></SPAN>&nbsp;<SPAN ID="dspFirstCsName"></SPAN></TD>
        </TR>
    </TABLE>
<%
'## 2004.01.27 Mod By T.Takagi@FSIT
'	'未受付、かつ予約枠無視フラグにて強制登録権限をもつユーザの場合、強制登録用のチェックボックスを表示
'	If lngCurDayId = 0 And (Session("IGNORE") = IGNORE_EXCEPT_NO_RSVFRA Or Session("IGNORE") = IGNORE_ANY) Then
    '予約枠無視フラグにて強制登録権限をもつユーザの場合、強制登録用のチェックボックスを表示
    If Session("IGNORE") = IGNORE_EXCEPT_NO_RSVFRA Or Session("IGNORE") = IGNORE_ANY Then
'## 2004.01.27 Mod End
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD HEIGHT="35"><INPUT TYPE="checkbox" NAME="ignoreFlg" VALUE="<%= Session("IGNORE") %>"<%= IIf(lngIgnoreFlg = CLng(Session("IGNORE")), " CHECKED", "") %>></TD>
                <TD NOWRAP>強制登録を行う</TD>
            </TR>
        </TABLE>
<%
    End If
%>
</FORM>
<%
'読み込み直後の受診オプション検査情報等々
%>
<FORM NAME="optionForm" action="#">

    <% '読み込み直後の基本情報 %>
    <INPUT TYPE="hidden" NAME="perId"    VALUE="<%= strPerId    %>">
    <INPUT TYPE="hidden" NAME="gender"   VALUE="<%= strGender   %>">
    <INPUT TYPE="hidden" NAME="birth"    VALUE="<%= strBirth    %>">
    <INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1   %>">
    <INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2   %>">
    <INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
    <INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= strCslDivCd %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd  %>">
<%
    'カンマ付き文字列に変換
    If Not IsEmpty(strOptCd) Then
        strEditOptCd = Join(strOptCd, ",")
    End If

    If Not IsEmpty(strOptBranchNo) Then
        strEditOptBranchNo = Join(strOptBranchNo, ",")
    End If
%>
    <INPUT TYPE="hidden" NAME="optCd" VALUE="<%= strEditOptCd %>">
    <INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strEditOptBranchNo %>">

    <% 'オプション一覧の表示方法(オプション一覧画面でセットした値が本エレメントにも反映される) %>
    <INPUT TYPE="hidden" NAME="showAll" VALUE="">
</FORM>
<%
'現表示契約のリピータ割引セットの有無およびその受診状態を管理
%>
<FORM NAME="repInfo" action="#">
    <INPUT TYPE="hidden" NAME="hasRepeaterSet"  VALUE="">
    <INPUT TYPE="hidden" NAME="repeaterConsult" VALUE="">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
var myForm = document.entryForm;
var wkNode;

<% 'イベントハンドラの設定 %>
myForm.cslYear.onchange  = changeDate;
myForm.cslMonth.onchange = changeDate;
myForm.cslDay.onchange   = changeDate;
<%
'If strRsvNo <> "" Then
%>
    myForm.cslYear.disabled  = true;
    myForm.cslMonth.disabled = true;
    myForm.cslDay.disabled   = true;
<%
'End If

'キャンセル者の場合
If lngCurCancelFlg <> CONSULT_USED Then
%>
    myForm.ctrCsCd.disabled = true;
    myForm.ctrCslDivCd.disabled = true;

    document.getElementById('gdeOrg').innerHTML     = '';
    document.getElementById('gdeConsult').innerHTML = '';
    document.getElementById('delConsult').innerHTML = '';
<%
End If

'キャンセル者、または受付済みの場合
If lngCurCancelFlg <> CONSULT_USED Or lngCurDayId <> 0 Then
%>
//	myForm.cslYear.disabled     = true;
//	myForm.cslMonth.disabled    = true;
//	myForm.cslDay.disabled      = true;
    myForm.selRsvGrpCd.disabled = true;
    myForm.ctrCsCd.disabled     = true;

    document.getElementById('gdePerson').innerHTML  = '';
    document.getElementById('gdeDate').innerHTML    = '';
<%
End If

'予約番号の表示可否
If strRsvNo = "" Then
%>
    wkNode = document.getElementById('dspRsvNo').innerHTML = '';
    wkNode = document.getElementById('dspRsvNoColon').innerHTML = '';
<%
End If

'当日ＩＤ欄の表示可否
If lngCurDayId = 0 Then
%>
    wkNode = document.getElementById('dspDayId').innerHTML = '';
    wkNode = document.getElementById('dspDayIdColon').innerHTML = '';
<%
End If
%>
<%
'## 2003.12.12 Add By T.Takagi@FSIT 保存完了メッセージ対応
'エラーが存在しない場合
If IsEmpty(strArrMessage) Then
%>
    // cookie値の取得
    var searchStr = 'rsvDetailOnSaving=';
    var strCookie = document.cookie;
    var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
    var onSaveVal = strCookie.substring(startPos, startPos + 1);

    // 保存系処理にてcookieが書かれ、かつフラグ成立時、保存完了メッセージを出す
    if ( onSaveVal == '1' ) {
        var html = '';
        html = html + '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
        html = html + '<TR>';
        html = html + '<TD HEIGHT="5"><\/TD>';
        html = html + '<\/TR>';
        html = html + '<TR>';
        html = html + '<TD><IMG SRC="/webHains/images/ico_i.gif" WIDTH="16" HEIGHT="16" ALIGN="left"><\/TD>';
        html = html + '<TD VALIGN="bottom"><SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">保存が完了しました。<\/SPAN><\/TD>';
        html = html + '<\/TR>';
        html = html + '	</\TABLE>';
        document.getElementById('msgArea').innerHTML = html;
    }

    // 以後出ないよう、フラグをクリア
    document.cookie = 'rsvDetailOnSaving=0';
<%
End If
'## 2003.12.12 Add End
'## 2004/04/20 Add By T.Takagi@FSIT エラー時にフラグが残存する
%>
document.cookie = 'rsvDetailOnSaving=0';
<%
'## 2004/04/20 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>

