<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約枠検索(カレンダー検索) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<% '## 2004/04/20 Add By T.Takagi@FSIT 近い受診日で健診歴がある場合のワーニング対応 %>
<!-- #include virtual = "/webHains/includes/recentConsult.inc" -->
<% '## 2004/04/20 Add End %>
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const CALENDAR_HEIGHT = 23	'カレンダーの行当たりの高さ

Const STATUS_PAST        = "0"	'カレンダー日付状態(過去・強制予約可能)
Const STATUS_NORMAL      = "1"	'カレンダー日付状態(空きあり)
Const STATUS_OVER        = "2"	'カレンダー日付状態(オーバだが予約可能)
Const STATUS_FULL        = "3"	'カレンダー日付状態(空きなし・強制予約可能)
Const STATUS_NO_RSVFRA   = "4"	'カレンダー日付状態(枠なし・枠なし強制予約なら可能)
Const STATUS_NO_CONTRACT = "5"	'カレンダー日付状態(契約なし・予約不能)

Const COLOR_NOTHING     = "#ffffff"	'カレンダー表示色(なし)
Const COLOR_NORMAL      = "#afeeee"	'カレンダー表示色(空きあり)
Const COLOR_OVER        = "#ff6347"	'カレンダー表示色(オーバだが予約可能)
Const COLOR_FULL        = "#ff6347"	'カレンダー表示色(空きなし)
Const COLOR_NO_RSVFRA   = "#ffcccc"	'カレンダー表示色(枠なし)
Const COLOR_NO_CONTRACT = "#cccccc"	'カレンダー表示色(契約なし)
Const COLOR_HOLIDAY     = "#90ee90"	'カレンダー表示色(休日)

Const MARK_OVER = "★"	'オーバ時のマーク

Const IGNORE_EXCEPT_NO_RSVFRA = "1"	'予約枠無視権限(枠なしの日付を除く強制予約が可能)
Const IGNORE_ANY              = "2"	'予約枠無視権限(あらゆる強制予約が可能)

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objContract			'契約情報アクセス用
Dim objFree				'汎用情報アクセス用
Dim objOrganization		'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objSchedule			'スケジュール情報アクセス用

'引数値
Dim strMode				'検索モード(MODE_NORMAL:通常、MODE_SAME_RSVGRP:同じ予約群セットグループで検索)
Dim strCalledFrom		'呼び元識別(なし:予約枠検索、あり:受診情報)
Dim lngCslYear			'受診年
Dim lngCslMonth			'受診月
Dim lngCslDay			'受診日
Dim lngIgnoreFlg		'予約枠無視フラグ

'## 2003.12.12 Add By T.Takagi@FSIT 現在日を受け取る
Dim strCurCslYear		'現在の受診年
Dim strCurCslMonth		'現在の受診月
Dim strCurCslDay		'現在の受診日
'## 2003.12.12 Add End

Dim strParaPerId		'個人ＩＤ
Dim strParaManCnt		'人数
Dim strParaGender		'性別
Dim strParaBirth		'生年月日
Dim strParaAge			'受診時年齢
Dim strParaRomeName		'ローマ字名
Dim strParaOrgCd1		'団体コード１
Dim strParaOrgCd2		'団体コード２
Dim strParaCsCd			'コースコード
Dim strParaCslDivCd		'受診区分コード
Dim strParaRsvGrpCd		'予約群コード
Dim strParaCtrPtCd		'契約パターンコード
Dim strParaRsvNo		'継承すべき受診情報の予約番号
Dim strParaOptCd		'オプションコード
Dim strParaOptBranchNo	'オプション枝番

Dim strPerId			'個人ＩＤ
Dim strManCnt			'人数
Dim strGender			'性別
Dim strBirth			'生年月日
Dim strAge				'受診時年齢
Dim strRomeName			'ローマ字名
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCsCd				'コースコード
Dim strCslDivCd			'受診区分コード
Dim strRsvGrpCd			'予約群コード
Dim strCtrPtCd			'契約パターンコード
Dim strRsvNo			'継承すべき受診情報の予約番号
Dim strOptCd			'オプションコード
Dim strOptBranchNo		'オプション枝番

'契約情報
Dim strAgeCalc			'年齢起算日
Dim strCsName			'コース名

'オプション情報
Dim strSelOptCd			'オプションコード
Dim strSelOptBranchNo	'オプション枝番
Dim strArrOptCd			'オプションコード
Dim strArrOptBranchNo	'オプション枝番
Dim strArrOptSName		'オプション略称
Dim lngOptCount			'オプション数
Dim strSelOptName()		'オプション名の配列
Dim lngSelOptCount		'オプション数
Dim strDispOptName		'オプション名

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strPerBirth			'生年月日
Dim strPerGender		'性別
Dim strPerAge			'受診時年齢

'編集用の個人情報
Dim strPerName			'氏名
Dim strPerBirthJpn		'生年月日
Dim strPerGenderJpn		'性別
Dim strDispManCnt		'他何名か

'団体情報
Dim strOrgName			'団体名称
Dim strOrgKName			'団体カナ名称

'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
Dim strHighLight        ' 団体名称ハイライト表示区分
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###

'カレンダー情報
Dim strCslDate			'受診日
Dim strHoliday			'休診日
Dim strStatus			'状態
Dim lngCount			'日数

'カレンダー編集用(７日×表示に要する最大週数６＝４２個の配列)
Dim strEditDay(41)		'日付
Dim strEditHoliday(41)	'休診日
Dim strEditStatus(41)	'休診日

'空き予約群検索情報
Dim strFindHoliday		'休診日
Dim strFindStatus		'状態
Dim strFindRsvGrpCd		'検索された予約群

Dim lngWeekDay			'曜日(1:日曜～7:土曜)
Dim lngPtr				'編集用配列のポインタ
Dim strHeight			'HEIGHTプロパティ用
Dim strClass			'CLASSプロパティ用
Dim strColor			'セル色
Dim strDay				'日付

Dim strStrRsvNo			'開始予約番号
Dim strEndRsvNo			'終了予約番号

Dim dtmCslDate			'受診日
Dim lngYear				'年
Dim lngMonth			'月
Dim blnAnchor			'アンカー要否
Dim strMessage			'メッセージ
Dim strHTML				'HTML文字列
Dim Ret					'関数戻り値
Dim i, j				'インデックス

'## 2004/04/20 Add By T.Takagi@FSIT 近い受診日で健診歴がある場合のワーニング対応
Dim strArrCslDate		'受診日の配列
Dim strArrRsvNo			'予約番号の配列
'## 2004/04/20 Add End

'## 2005/10/19 Add By 李
Dim lntRsvChk
'## 2005/10/19 Add End

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strMode            = Request("mode")
strCalledFrom      = Request("calledFrom")
lngCslYear         = CLng("0" & Request("cslYear"))
lngCslMonth        = CLng("0" & Request("cslMonth"))
lngCslDay          = CLng("0" & Request("cslDay"))
lngIgnoreFlg       = CLng("0" & Request("ignoreFlg"))
strParaPerId       = Request("perId")
strParaManCnt      = Request("manCnt")
strParaGender      = Request("gender")
strParaBirth       = Request("birth")
strParaAge         = Request("age")
strParaRomeName    = Request("romeName")
strParaOrgCd1      = Request("orgCd1")
strParaOrgCd2      = Request("orgCd2")
strParaCsCd        = Request("csCd")
strParaCslDivCd    = Request("cslDivCd")
strParaRsvGrpCd    = Request("rsvGrpCd")
strParaCtrPtCd     = Request("ctrPtCd")
strParaRsvNo       = Request("rsvNo")
strParaOptCd       = Request("optCd")
strParaOptBranchNo = Request("optBranchNo")

'## 2003.12.12 Add By T.Takagi@FSIT 現在日を受け取る
strCurCslYear  = Request("curCslYear")
strCurCslMonth = Request("curCslMonth")
strCurCslDay   = Request("curCslDay")
'## 2003.12.12 Add End

'## 2005/10/19 Add By 李
lntRsvChk = CInt("0" & Request("chkRsv"))
'## 2005/10/19 Add End

'セパレータで分割し、配列化
strPerId       = Split(strParaPerId,       Chr(1))
strManCnt      = Split(strParaManCnt,      Chr(1))
strGender      = Split(strParaGender,      Chr(1))
strBirth       = Split(strParaBirth,       Chr(1))
strAge         = Split(strParaAge,         Chr(1))
strRomeName    = Split(strParaRomeName,    Chr(1))
strOrgCd1      = Split(strParaOrgCd1,      Chr(1))
strOrgCd2      = Split(strParaOrgCd2,      Chr(1))
strCsCd        = Split(strParaCsCd,        Chr(1))
strCslDivCd    = Split(strParaCslDivCd,    Chr(1))
strRsvGrpCd    = Split(strParaRsvGrpCd,    Chr(1))
strCtrPtCd     = Split(strParaCtrPtCd,     Chr(1))
strRsvNo       = Split(strParaRsvNo,       Chr(1))
strOptCd       = Split(strParaOptCd,       Chr(1))
strOptBranchNo = Split(strParaOptBranchNo, Chr(1))

'検索条件を単数指定した場合、値が存在しないと配列とならない。
'そこでここでは必ず存在する項目の１つである契約パターンコードの配列数をもとに空の配列を作成する。
If UBound(strCtrPtCd) = 0 Then
    If UBound(strPerId)       < 0 Then ReDim Preserve strPerId(0)
    If UBound(strManCnt)      < 0 Then ReDim Preserve strManCnt(0)
    If UBound(strGender)      < 0 Then ReDim Preserve strGender(0)
    If UBound(strBirth)       < 0 Then ReDim Preserve strBirth(0)
    If UBound(strAge)         < 0 Then ReDim Preserve strAge(0)
    If UBound(strRomeName)    < 0 Then ReDim Preserve strRomeName(0)
    If UBound(strOrgCd1)      < 0 Then ReDim Preserve strOrgCd1(0)
    If UBound(strOrgCd2)      < 0 Then ReDim Preserve strOrgCd2(0)
    If UBound(strCsCd)        < 0 Then ReDim Preserve strCsCd(0)
    If UBound(strCslDivCd)    < 0 Then ReDim Preserve strCslDivCd(0)
    If UBound(strRsvGrpCd)    < 0 Then ReDim Preserve strRsvGrpCd(0)
    If UBound(strRsvNo)       < 0 Then ReDim Preserve strRsvNo(0)
    If UBound(strOptCd)       < 0 Then ReDim Preserve strOptCd(0)
    If UBound(strOptBranchNo) < 0 Then ReDim Preserve strOptBranchNo(0)
End If

'予約処理制御
Do

    '受診日未指定時は何もしない
    If lngCslDay = 0 Then
        Exit Do
    End If

    '受診年月日の設定
    dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

    '受診情報詳細画面から呼ばれた場合
    If strCalledFrom <> "" Then

        'オブジェクトのインスタンス作成
        Set objSchedule = Server.CreateObject("HainsSchedule.Calendar")

        '指定受診日の予約枠空き状況を取得
        objSchedule.GetEmptyStatus strMode, dtmCslDate, strPerId, strManCnt, strGender, strBirth, strAge, strCsCd, strCslDivCd, strRsvGrpCd, strCtrPtCd, strOptCd, strOptBranchNo, strFindHoliday, strFindStatus, strFindRsvGrpCd

        '呼び元に受診日および予約群(検索された場合)をセットし、自身を閉じる
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
        strHTML = strHTML & vbCrLf & "<!--"
        strHTML = strHTML & vbCrLf & "if ( opener != null ) {"
        strHTML = strHTML & vbCrLf & "    if ( opener.setDate != null ) {"

        '現契約期間から外れる日付を選択した場合、メッセージを表示
'		If strFindStatus = STATUS_NO_CONTRACT Then
'			strHTML = strHTML & vbCrLf & "        alert('現在の契約情報と契約パターンが異なるか、契約期間外の日付が選択されました。\n検査セットの内容は変更されます。');"
'		End If

        strHTML = strHTML & vbCrLf & "        opener.setDate('" & lngCslYear & "','" & lngCslMonth & "','" & lngCslDay & "','" & strFindRsvGrpCd(0) & "'" & IIf(strFindStatus = STATUS_NO_CONTRACT, ",'1'", "") & ");"
        strHTML = strHTML & vbCrLf & "    }"
        strHTML = strHTML & vbCrLf & "}"
        strHTML = strHTML & vbCrLf & "close();"
        strHTML = strHTML & vbCrLf & "</SCRIPT>"
        strHTML = strHTML & vbCrLf & "</HTML>"
        Response.Write strHTML
        Response.End

        Exit Do
    End If
    

''## 2005.10.14 Add by 李 ---------------------------------------------> START
''## 年度内に２回目予約を行う場合、ワーニング対応  
        If lngIgnoreFlg = 0 Then
            Set objConsult = Server.CreateObject("HainsConsult.Consult")
            strMessage = ""
            strMessage = objConsult.CheckConsult_Ctr(strPerId(0), dtmCslDate, strCsCd(0), strOrgCd1(0), strOrgCd2(0), "",lntRsvChk)
            Set objConsult = Nothing

            If strMessage <> "" Then
                Exit Do
            End If
        End If
''## 2005.10.14 Add by 李 ---------------------------------------------> END


    'オブジェクトのインスタンス作成
    Set objConsult = Server.CreateObject("HainsConsult.ConsultAll")
    '予約処理
    Ret = objConsult.ReserveFromFrameReserve(strMode, Session("USERID"), lngIgnoreFlg, dtmCslDate, strPerId, strManCnt, strGender, strBirth, strAge, strRomeName, strOrgCd1, strOrgCd2, strCsCd, strCslDivCd, strRsvGrpCd, strCtrPtCd, strRsvNo, strOptCd, strOptBranchNo, strStrRsvNo, strEndRsvNo, strMessage)
    If Ret <= 0 Then
        Exit Do
    End If

    '正常時は完了通知画面へ
    Response.Clear
    Response.Redirect "fraRsvCslList.asp?cslDate=" & dtmCslDate & "&strRsvNo=" & strStrRsvNo & "&endRsvNo=" & strEndRsvNo
    Response.End

    Exit Do
Loop

'年齢計算に際し、受診日は指定年月の先頭日とする
dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/1")

'先頭の受診条件から各種情報を取得

'オブジェクトのインスタンス作成
Set objContract = Server.CreateObject("HainsContract.Contract")

'年齢起算日、コース名の取得
objContract.SelectCtrPt strCtrPtcd(0), , , strAgeCalc, , strCsName

'オプションコードが指定されている場合
If strOptCd(0) <> "" Then

    'オプションコード・枝番を配列に変換
    strSelOptCd       = Split(strOptCd(0),       ",")
    strSelOptBranchNo = Split(strOptBranchNo(0), ",")

    '指定契約パターンの全オプション検査読み込み
    lngOptCount = objContract.SelectCtrPtOptList(strCtrPtcd(0), strArrOptCd, strArrOptBranchNo, , strArrOptSName)

    'オプションの検索
    For i = 0 To UBound(strSelOptCd)

        For j = 0 To lngOptCount - 1

            '引数指定されたオプションと一致した場合、略称を配列に追加
            If strArrOptCd(j) = strSelOptCd(i) And strArrOptBranchNo(j) = strSelOptBranchNo(i) Then
                ReDim Preserve strSelOptName(lngSelOptCount)
                strSelOptName(lngSelOptCount) = strArrOptSName(j)
                lngSelOptCount = lngSelOptCount + 1
                Exit For
            End If

        Next

    Next

    'オプション名の編集
    If lngSelOptCount > 0 Then
        strDispOptName = "　（" & Join(strSelOptName, "、") & "）"
    End If

End If

Set objContract = Nothing

'個人ＩＤ指定の場合
If strPerId(0) <> "" Then

    'オブジェクトのインスタンス作成
    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '個人情報読み込み
    objPerson.SelectPerson_lukes strPerId(0), strLastName, strFirstName, strLastKName, strFirstKName, , strPerBirth, strPerGender

    Set objPerson = Nothing

    '姓名の編集
    strPerName = "<B>" & Trim(strLastName  & "　" & strFirstName) & "</B><FONT COLOR=""#999999"">（" & Trim(strLastKName & "　" & strFirstKName) & "）</FONT>"

    '年齢計算
    Set objFree = Server.CreateObject("HainsFree.Free")
    strPerAge = objFree.CalcAge(strPerBirth, dtmCslDate, strAgeCalc)
    If strPerAge <> "" Then
        strPerAge = CStr(CInt(strPerAge))	'小数点以下を除去
    End If

'性別・生年月日・年齢指定の場合
Else

    '姓名の編集
    strPerName = IIf(strRomeName(0) <> "", strRomeName(0), "<FONT COLOR=""#999999"">（受診者未確定）</FONT>")

    '生年月日・年齢・性別の取得
    strPerBirth = strBirth(0)
    strPerAge = strAge(0)
    strPerGender = strGender(0)

    '受診人数の編集
    If CLng("0" & strManCnt(0)) > 1 Then
        strDispManCnt = "他" & CStr(CLng("0" & strManCnt(0)) - 1 ) & "名"
    End If

End If

'生年月日の編集
If strPerBirth <> "" Then
    Set objCommon = Server.CreateObject("HainsCommon.Common")
    strPerBirthJpn = objCommon.FormatString(strPerBirth, "ge.m.d") & "生　"
    Set objCommon = Nothing
End If

'性別の編集
strPerGenderJpn = IIf(strPerGender = CStr(GENDER_MALE), "男性", "女性")

'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'団体情報読み込み
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　Start ###
'objOrganization.SelectOrg_Lukes strOrgCd1(0), strOrgCd2(0), , strOrgKName, strOrgName
objOrganization.SelectOrg_Lukes strOrgCd1(0), strOrgCd2(0), , strOrgKName, strOrgName,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight
'### 2013.12.25 団体名称ハイライト表示有無をチェックの為追加　End   ###


Set objOrganization = Nothing

'オブジェクトのインスタンス作成
Set objSchedule = Server.CreateObject("HainsSchedule.Calendar")

'指定年月の予約空き状況取得
lngCount = objSchedule.GetEmptyCalendar(strMode, lngCslYear, lngCslMonth, strPerId, strManCnt, strGender, strBirth, strAge, strCsCd, strCslDivCd, strRsvGrpCd, strCtrPtCd, strOptCd, strOptBranchNo, strCslDate, strHoliday, strStatus)

Set objSchedule = Nothing

'先頭日の曜日を求める
lngWeekDay = WeekDay(strCslDate(0))

'先頭日に達するまでポインタを移動
lngPtr = lngWeekDay - 1

'編集用配列への格納
For i = 0 To lngCount - 1
    strEditDay(lngPtr)     = Day(strCslDate(i))
    strEditHoliday(lngPtr) = strHoliday(i)
    strEditStatus(lngPtr)  = strStatus(i)
    lngPtr = lngPtr + 1
Next

'-------------------------------------------------------------------------------
'
' 機能　　 : セル色の設定
'
' 引数　　 : (In)     strDay      日付
' 　　　　   (In)     strHoliday  休診日
' 　　　　   (In)     strStatus   状態
'
' 戻り値　 : セル色(詳細はConst定義を参照)
'
'-------------------------------------------------------------------------------
Function CellColor(strDay, strHoliday, strStatus)

    Dim strColor	'セル色

    'セル色(空き状態の色)の設定
    If strDay <> "" Then

        '日付存在時
        Select Case strStatus

            Case STATUS_PAST	'過去

                'strColor = IIf(strHoliday > 0, COLOR_HOLIDAY, COLOR_NOTHING)
                strColor = COLOR_NOTHING

            Case STATUS_NORMAL  '枠あり

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_NORMAL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_NORMAL)

            Case STATUS_OVER    '枠オーバ

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_OVER
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_OVER)

            Case STATUS_FULL    '空きなし

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_FULL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_FULL)

            Case STATUS_NO_RSVFRA   '枠なし

                'strColor = IIf(strHoliday > 0, COLOR_HOLIDAY, COLOR_NO_RSVFRA)
                strColor = COLOR_NO_RSVFRA

            Case STATUS_NO_CONTRACT '契約なし

                strColor = COLOR_NO_CONTRACT

            Case Else	'その他(一応)

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_NORMAL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_NORMAL)

        End Select

    '日付がなければ設定しない
    Else
        strColor = COLOR_NOTHING
    End If

    CellColor = strColor

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 予約群未指定検索条件の存在をチェック
'
' 引数　　 :
'
' 戻り値　 : True   あり
' 　　　　   False  なし
'
'-------------------------------------------------------------------------------
Function ExistsNoRsvFra()

    Dim Ret	'関数戻り値
    Dim i	'インデックス

    '予約群未指定検索条件の存在をチェック
    Ret = False
    For i = 0 To UBound(strRsvGrpCd)
        If strRsvGrpCd(i) = "" Then
            Ret = True
            Exit For
        End If
    Next

    ExistsNoRsvFra = Ret

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : アンカー要否(予約可否)の判定
'
' 引数　　 : (In)     strStatus  状態
'
' 戻り値　 : True   必要
' 　　　　   False  不要
'
'-------------------------------------------------------------------------------
Function NeedAnchor(strStatus)

    Dim Ret	'関数戻り値

    Do

        Ret = True

        '契約なしなら不要
        If strStatus = STATUS_NO_CONTRACT Then
            Ret = False
            Exit Do
        End If

        '予約群未指定検索条件が存在する場合、強制予約はできない(強制予約時に空きのある予約群を検索することが事実上不能)
        If ExistsNoRsvFra() Then
            Ret = (strStatus = STATUS_NORMAL Or strStatus = STATUS_OVER)
            Exit Do
        End If

        '予約群未指定検索条件が存在しなければ、権限による強制予約可否制御を行う
        Select Case Session("IGNORE")

            Case IGNORE_ANY	'あらゆる強制予約可能
                Exit Do

            Case IGNORE_EXCEPT_NO_RSVFRA	'枠なし以外の強制予約可能

                '枠なしなら不要
                If strStatus = STATUS_NO_RSVFRA Then
                    Ret = False
                    Exit Do
                End If

            Case Else	'通常

                '空きあり、オーバ以外なら不要
                If strStatus <> STATUS_NORMAL And strStatus <> STATUS_OVER Then
                    Ret = False
                    Exit Do
                End If

        End Select

        Exit Do
    Loop

    NeedAnchor = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>カレンダー検索</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 日付選択
function selDate( day, force ) {

    var entForm  = document.entryForm;
    var paraForm = document.paramForm;

    // 強制予約時は強制予約チェックが必要となる
    if ( force ) {
        if ( paraForm.ignoreFlg.value == '0' ) {
            alert('強制予約時は必ず「強制予約を行う」をチェック後、実施してください。');
            return;
        }
    }

    var year  = entForm.curCslYear.value;
    var month = entForm.curCslMonth.value;

    // メッセージの表示
    if ( !confirm( '受診日：' + year + '年' + month + '月' + day + '日で' + ( force ? '強制' : '' ) + '予約を行います。よろしいですか？' ) ) {
        return;
    }

// ## 2004/04/20 Add By T.Takagi@FSIT 近い受診日で健診歴がある場合のワーニング対応
    var msg = checkRecentConsult( year, month, day );
    if ( msg != '' ) {
        if ( !confirm( msg + '\n\n予約を行いますか？' ) ) {
            return;
        }

        // ## 2005/10/19 Add By 李
        paraForm.chkRsv.value  = '1'
        // ## 2005/10/19 Add End
    }
// ## 2004/04/20 Add End

    // submit処理
    paraForm.cslYear.value  = year;
    paraForm.cslMonth.value = month;
    paraForm.cslDay.value   = day;
    paraForm.submit();

}

// 日付選択(受診情報詳細から呼ばれた場合)
function setDate( day ) {

    var paraForm = document.paramForm;
    var entForm  = document.entryForm;
    var year     = entForm.curCslYear.value;
    var month    = entForm.curCslMonth.value;

// ## 2003.12.12 Mod By T.Takagi@FSIT 現在日を受け取る
//	if ( !confirm( '受診日：' + year + '年' + month + '月' + day + '日に設定します。よろしいですか？' ) ) {
    var curYear  = paraForm.curCslYear.value;
    var curMonth = paraForm.curCslMonth.value;
    var curDay   = paraForm.curCslDay.value;

    var msg = '受診日を';

    if ( curYear != '' && curMonth != '' && curDay != '' ) {
        msg = msg + curYear + '年' + curMonth + '月' + curDay + '日から';
    }

    msg = msg + year + '年' + month + '月' + day + '日に設定します。よろしいですか？';

    if ( !confirm( msg ) ) {
// ## 2003.12.12 Mod End
        return;
    }

    // 予約群が指定されている場合
    if ( paraForm.rsvGrpCd.value != '' ) {

        if ( opener != null ) {
            if ( opener.setDate != null ) {
                opener.setDate( '<%= lngCslYear %>', '<%= lngCslMonth %>', day, '' );
            }
        }

        close();

    // 予約群未指定の場合
    } else {
    
        // submit処理
        paraForm.cslYear.value  = year;
        paraForm.cslMonth.value = month;
        paraForm.cslDay.value   = day;
        paraForm.submit();

    }

}

// 年月の変更
function changeDate( year, month ) {

    var objForm  = document.paramForm;
    var objYear  = objForm.cslYear;
    var objMonth = objForm.cslMonth;

    // 年月の設定
    if ( year != null ) {
        objYear.value  = year;
        objMonth.value = month;
    } else {
        objYear.value  = document.entryForm.cslYear.value;
        objMonth.value = document.entryForm.cslMonth.value;
    }

    objForm.submit();

}

function onChangeDate()
{
    changeDate();
}
//-->
</SCRIPT>
<style type="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">カレンダー検索</FONT></B></TD>
    </TR>
</TABLE>
<%
'エラーメッセージの編集
If strMessage <> "" Then
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)
End If
%>
<BR>
<%
'検索条件が複数存在する場合のメッセージ
If UBound(strPerId) > 0 Then
%>
    <FONT COLOR="#cc9999">●</FONT>先頭の検索条件のみ表示しています。<BR><BR>
<%
End If

'先頭の検索条件を編集
%>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
    <TR>
        <TD WIDTH="60" NOWRAP>個人名</TD>
        <TD>：</TD>
<%
        '個人ＩＤ指定の場合
        If strPerId(0) <> "" Then
%>
            <TD NOWRAP><%= strPerId(0) %></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP><%= strPerName %></TD>
<%
        '性別・生年月日・年齢指定の場合
        Else
%>
            <TD NOWRAP><%= strPerName %></TD>
            <TD>&nbsp;&nbsp;</TD>
            <TD NOWRAP><FONT COLOR="#ff8c00"><%= strDispManCnt %></FONT></TD>
<%
        End If
%>
    </TR>
    <TR>
        <TD COLSPAN="<%= IIf(strPerId(0) <> "", "4", "2") %>"></TD>
        <TD NOWRAP><%= strPerBirthJpn %><%= strPerAge %>歳　<%= strPerGenderJpn %></TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
    <TR>
        <TD WIDTH="60" NOWRAP>団体名</TD>
        <TD>：</TD>
<% '### 2013.12.25 張 団体名称ハイライト表示有無をチェックの為追加　Start ### %>
<%  If strHighLight = "1" Then           %>
        <TD NOWRAP><FONT style=' font-weight:bold; background-color:#00FFFF;'><B><%= strOrgCd1(0) %>-<%= strOrgCd2(0) %></B></FONT></TD>
        <TD>&nbsp;</TD>
        <TD NOWRAP><FONT style=' font-weight:bold; background-color:#00FFFF;'><B><%= strOrgName %></B></FONT><FONT style=' font-weight:bold; background-color:#00FFFF;' COLOR="#999999">（<%= strOrgKName %>）</FONT></TD>
<%  Else                                %>
        <TD NOWRAP><%= strOrgCd1(0) %>-<%= strOrgCd2(0) %></TD>
        <TD>&nbsp;</TD>
        <TD NOWRAP><B><%= strOrgName %></B><FONT COLOR="#999999">（<%= strOrgKName %>）</FONT></TD>
<%  End If                              %>
<% '### 2013.12.25 張 団体名称ハイライト表示有無をチェックの為追加　End   ### %>

    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
    <TR>
        <TD WIDTH="60" NOWRAP>コース</TD>
        <TD>：</TD>
        <TD NOWRAP><%= strCsName & strDispOptName %></TD>
    </TR>
</TABLE>
<BR>
<%
' ---------------------------------------- 凡例 ----------------------------------------
%>
<!--## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更 ##-->
<!--## 「予約枠なし」　⇒　「予約枠なし・休診日・祝日」                                   ##-->

<FONT COLOR="<%= COLOR_NORMAL %>">■</FONT>：空きあり、<FONT COLOR="<%= COLOR_FULL %>">■</FONT>：空きなし、<FONT COLOR="<%= COLOR_NO_RSVFRA %>">■</FONT>：予約枠なし・休診日・祝日、<FONT COLOR="<%= COLOR_NO_CONTRACT %>">■</FONT>：契約期間外<!--、<FONT COLOR="<%= COLOR_HOLIDAY %>">■</FONT>：休日--><BR><BR>
<FONT COLOR="#cc9999">●</FONT>オーバとなるが予約可能な日には<%= MARK_OVER %>を表示しています。
<%
' ---------------------------------------- 凡例 ----------------------------------------

If strCalledFrom <> "" Then
%>
    <BR><FONT COLOR="#cc9999">●</FONT>契約期間外の日を選択した場合、入力された検査セットの内容は変更されることがあります。
<%
End If
%>
<FORM NAME="entryForm" ACTION="" STYLE="margin:0px;">
<INPUT TYPE="hidden" NAME="curCslYear"  VALUE="<%= lngCslYear  %>">
<INPUT TYPE="hidden" NAME="curCslMonth" VALUE="<%= lngCslMonth %>">
<%
'予約枠無視権限による制御
Do

    '受診情報詳細画面から呼ばれた場合は何もしない
    If strCalledFrom <> "" Then
        Response.Write "<BR>"
        Exit Do
    End If

    '強制予約権限がない場合は何もしない
    Select Case Session("IGNORE")
        Case IGNORE_ANY
        Case IGNORE_EXCEPT_NO_RSVFRA
        Case Else
            Response.Write "<BR>"
            Exit Do
    End Select

    '予約群未指定検索条件が存在する場合、強制予約はできない
    If ExistsNoRsvFra() Then
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD HEIGHT="35"><IMG SRC="/webHains/images/ico_w.gif" WIDTH="16" HEIGHT="16" ALIGN="left" ALT=""></TD>
                <TD NOWRAP><FONT COLOR="#ff9900"><B>予約群の指定されていない検索条件があります。強制予約はできません。</B></FONT></TD>
            </TR>
        </TABLE>
<%
        Exit Do
    End If
%>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="35"><INPUT TYPE="checkbox"<%= IIf(lngIgnoreFlg > 0, " CHECKED", "") %> ONCLICK="javascript:document.paramForm.ignoreFlg.value = this.checked ? '<%= Session("IGNORE") %>' : '0'"></TD>
            <TD NOWRAP>強制予約を行う</TD>
        </TR>
    </TABLE>
<%
    Exit Do
Loop
%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD>
            <TABLE BORDER="1" CELLSPACING="0" CELLPADDING="1">
                <TR>
                    <TD COLSPAN="7" ALIGN="center" VALIGN="bottom" HEIGHT="20"><B><%= lngCslYear %></B>年<B><%= lngCslMonth %></B>月</TD>
                </TR>
                <TR ALIGN="center">
                    <TD CLASS="holiday"  WIDTH="35"><B>日</B></TD>
                    <TD CLASS="weekday"  WIDTH="35"><B>月</B></TD>
                    <TD CLASS="weekday"  WIDTH="35"><B>火</B></TD>
                    <TD CLASS="weekday"  WIDTH="35"><B>水</B></TD>
                    <TD CLASS="weekday"  WIDTH="35"><B>木</B></TD>
                    <TD CLASS="weekday"  WIDTH="35"><B>金</B></TD>
                    <TD CLASS="saturday" WIDTH="35"><B>土</B></TD>
                </TR>
<%
                'カレンダ編集開始
                i = 0
                Do Until i >= UBound(strEditDay)
%>
                    <TR ALIGN="right">
<%
                        '１列目のみHEIGHTプロパティの設定を行う
                        strHeight = " HEIGHT=""" & CALENDAR_HEIGHT & """"

                        Do

                            'CLASSプロパティ(日付の色)の設定(index値で判断、weekday関数の値とは異なる)
                            Select Case i Mod 7

                                Case 0	'日曜

                                    strClass = "holiday"

                                Case 6	'土曜

                                    strClass = "saturday"

                                    '祝日はそれを優先
'### 2004/09/06 Updated by Takagi@FSIT 高木の詫び
'                                   If strEditHoliday(i) = "2" Then
                                    If strEditHoliday(i) <> "" Then
'### 2004/09/06 Updated End
                                        strClass = "holiday"
                                    End If

                                Case Else	'平日

                                    strClass = "weekday"

                                    '休診日、祝日はそれを優先
                                    If strEditHoliday(i) <> "" Then
                                        strClass = "holiday"
                                    End If

                            End Select

                            'セル色(空き状態の色)の設定
                            strColor = CellColor(strEditDay(i), strEditHoliday(i), strEditStatus(i))

                            '## 2006.07.12 張 休診日、祝日の場合、枠状況に関係なく選択できないように変更 Start
''                            'アンカー要否の設定(予約詳細から呼ばれた場合はすべて選択可能)
''                            If strCalledFrom <> "" Then
''                                blnAnchor = True
''                            Else
''                                blnAnchor = NeedAnchor(strEditStatus(i))
''                            End If
                            If strEditHoliday(i) <>"" Then
                                blnAnchor = False
                            Else
                                If strCalledFrom <> "" Then
                                    '## 2006.07.12 張 過去の日付以外はすべて選択できるように変更
                                    If strEditStatus(i) = STATUS_PAST Then
                                        blnAnchor = False
                                    Else
                                        blnAnchor = True
                                    End If
                                Else
                                    '## 2006.07.12 張 過去の日付の場合、枠状況に関係なく選択できないように変更
                                    If strEditStatus(i) = STATUS_PAST Then
                                        blnAnchor = False
                                    Else
                                        blnAnchor = NeedAnchor(strEditStatus(i))
                                    End If
                                End If
                            End If
                            '## 2006.07.12 張 休診日、祝日の場合、枠状況に関係なく選択できないように変更 End

                            'セル値の設定
                            Do

                                If strEditDay(i) = "" Then
                                    strDay = "&nbsp;"
                                    Exit Do
                                End If

                                '編集文字列自体の編集
                                strDay = IIf(strEditStatus(i) = STATUS_OVER, MARK_OVER, "") & strEditDay(i)

                                'アンカーを要する場合
                                If blnAnchor Then

                                    'javascriptの編集(強制時は第２引数も編集)
                                    If strCalledFrom <> "" Then
                                        strDay = "<A CLASS=""" & strClass & """ HREF=""javascript:setDate(" & strEditDay(i) & ")"">" & strDay &  "</A>"
                                    Else
                                        strDay = "<A CLASS=""" & strClass & """ HREF=""javascript:selDate(" & strEditDay(i) & IIf(strEditStatus(i) <> STATUS_NORMAL And strEditStatus(i) <> STATUS_OVER , ",true", "") & ")"">" & strDay &  "</A>"
                                    End If

                                    Exit Do
                                End If

                                '通常
                                strDay = "<SPAN CLASS=""" & strClass & """>" & strDay & "</SPAN>"

                                Exit Do
                            Loop
%>
                            <TD<%= strHeight %> BGCOLOR="<%= strColor %>"><%= strDay %></TD>
<%
                            'HEIGHTプロパティのクリア
                            strHeight = ""

                            i = i + 1
                        Loop Until i Mod 7 = 0
%>
                    </TR>
<%
                Loop
%>
            </TABLE>
        </TD>
    </TR>
    <TR><TD HEIGHT="5"></TD></TR>
    <TR>
        <TD>
            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0" WIDTH="100%" BGCOLOR="#666666">
                <TR>
                    <TD BGCOLOR="#ffffff" ALIGN="center">
                        <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                            <TR>
<%
                                lngYear  = lngCslYear - IIf(lngCslMonth = 1, 1, 0)
                                lngMonth = IIf(lngCslMonth = 1, 12, lngCslMonth - 1)
%>
                                <TD><A HREF="javascript:changeDate(<%= lngYear %>, <%= lngMonth %>)"><IMG SRC="../../images/replay.gif" ALT="前月を表示" HEIGHT="21" WIDTH="21"></A></TD>
                                <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
                                <TD>年</TD>
                                <TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
                                <TD>月</TD>
<%
                                lngYear  = lngCslYear + IIf(lngCslMonth = 12, 1, 0)
                                lngMonth = IIf(lngCslMonth = 12, 1, lngCslMonth + 1)
%>
                                <TD><A HREF="javascript:changeDate(<%= lngYear %>, <%= lngMonth %>)"><IMG SRC="../../images/play.gif" ALT="次月を表示" HEIGHT="21" WIDTH="21"></A></TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
</FORM>
<FORM NAME="paramForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="mode"       VALUE="<%= strMode       %>">
    <INPUT TYPE="hidden" NAME="calledFrom" VALUE="<%= strCalledFrom %>">
    <INPUT TYPE="hidden" NAME="cslYear">
    <INPUT TYPE="hidden" NAME="cslMonth">
    <INPUT TYPE="hidden" NAME="cslDay">
    <INPUT TYPE="hidden" NAME="ignoreFlg"   VALUE="<%= lngIgnoreFlg       %>">
    <INPUT TYPE="hidden" NAME="perId"       VALUE="<%= strParaPerId       %>">
    <INPUT TYPE="hidden" NAME="manCnt"      VALUE="<%= strParaManCnt      %>">
    <INPUT TYPE="hidden" NAME="gender"      VALUE="<%= strParaGender      %>">
    <INPUT TYPE="hidden" NAME="birth"       VALUE="<%= strParaBirth       %>">
    <INPUT TYPE="hidden" NAME="age"         VALUE="<%= strParaAge         %>">
    <INPUT TYPE="hidden" NAME="romeName"    VALUE="<%= strParaRomeName    %>">
    <INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strParaOrgCd1      %>">
    <INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strParaOrgCd2      %>">
    <INPUT TYPE="hidden" NAME="cslDivCd"    VALUE="<%= strParaCslDivCd    %>">
    <INPUT TYPE="hidden" NAME="csCd"        VALUE="<%= strParaCsCd        %>">
    <INPUT TYPE="hidden" NAME="rsvGrpCd"    VALUE="<%= strParaRsvGrpCd    %>">
    <INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= strParaRsvNo       %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strParaCtrPtCd     %>">
    <INPUT TYPE="hidden" NAME="optCd"       VALUE="<%= strParaOptCd       %>">
    <INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strParaOptBranchNo %>">
<% '## 2003.12.12 Add By T.Takagi@FSIT 現在日を受け取る %>
    <INPUT TYPE="hidden" NAME="curCslYear"  VALUE="<%= strCurCslYear  %>">
    <INPUT TYPE="hidden" NAME="curCslMonth" VALUE="<%= strCurCslMonth %>">
    <INPUT TYPE="hidden" NAME="curCslDay"   VALUE="<%= strCurCslDay   %>">
<% '## 2003.12.12 Add End %>

<% '## 2005.10.19 Add By 李 %>
    <INPUT TYPE="hidden" NAME="chkRsv">
<% '## 2005.10.19 Add End %>
</FORM>
<!--
<%
'for debug
for i = 0 to ubound(strperid)
Response.Write "条件" & i + 1 & vbCrLf
Response.Write "prid=" & strPerid(i)       & vbCrLf
Response.Write "manc=" & strManCnt(i)      & vbCrLf
Response.Write "gend=" & strGender(i)      & vbCrLf
Response.Write "birt=" & strBirth(i)       & vbCrLf
Response.Write "cage=" & strAge(i)         & vbCrLf
Response.Write "rnam=" & strRomeName(i)    & vbCrLf
Response.Write "orgc=" & strOrgCd1(i) & "-" & strOrgCd2(i) & vbCrLf
Response.Write "cscd=" & strCsCd(i)        & vbCrLf
Response.Write "csdv=" & strCslDivCd(i)    & vbCrLf
Response.Write "rvgp=" & strRsvGrpCd(i)    & vbCrLf
Response.Write "ctpt=" & strCtrPtCd(i)     & vbCrLf
Response.Write "rvno=" & strRsvNo(i)       & vbCrLf
Response.Write "optc=" & strOptCd(i)       & vbCrLf
Response.Write "optb=" & strOptbranchNo(i) & vbCrLf
Next
%>
-->
<SCRIPT TYPE="text/javascript">
<!--
// イベントハンドラの設定
document.entryForm.cslYear.onchange  = onChangeDate;
document.entryForm.cslMonth.onchange = onChangeDate;
<%
'## 2004/04/20 Add By T.Takagi@FSIT 近い受診日で健診歴がある場合のワーニング対応
%>
// 近範囲受診歴情報の配列
var recentConsults = new Array();

// 近範囲受診歴情報クラス
function recentConsult() {
    this.perId   = '';
    this.perName = '';
    this.csCd    = '';
    this.cslDate = new Array();
}
<%
'オブジェクトのインスタンス作成
Set objPerson = Server.CreateObject("HainsPerson.Person")

For i = 0 To UBound(strPerId)

    'クラスのインスタンス作成
%>
    recentConsults[<%= i %>] = new recentConsult();
<%
    '個人ＩＤ指定時に各種情報を格納する
    If strPerid(i) <> "" Then
%>
        recentConsults[<%= i %>].perId = '<%= strPerid(i) %>';
        recentConsults[<%= i %>].csCd  = '<%= strCsCd(i)  %>';
<%
        '個人情報読み込み
        objPerson.SelectPerson_lukes strPerId(i), strLastName, strFirstName
%>
        recentConsults[<%= i %>].perName  = '<%= Trim(strLastName  & "　" & strFirstName) %>';
<%
        '指定年月の受診情報、翌月以降で最古の受診情報、前月以前で最新の受診情報を取得
        Call RecentConsult_GetRecentConsultHistory(strPerId(i), lngCslYear, lngCslMonth, "", strArrCslDate, strArrRsvNo)

        '受診日情報存在時
        If IsArray(strArrCslDate) Then

            'その内容を編集
            For j = 0 To UBound(strArrCslDate)
%>
                recentConsults[<%= i %>].cslDate[<%= j %>] = '<%= strArrCslDate(j) %>';
<%
            Next
        End If

    End If

Next

Set objPerson = Nothing
%>
// 指定受診日にて保存する際、ワーニング対象となる受診情報が存在するかを判定
function checkRecentConsult( cslYear, cslMonth, cslDay ) {

    var warnCslDate;	// ワーニング対象となる受診日

    var wkDate;			// 日付ワーク
    var msg = '';		// メッセージ

    // 指定月数前の受診日、指定月数後の受診日を算出
    var minCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH * -1 %> );
    var maxCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH      %> );

    for ( var ret = true, i = 0; i < recentConsults.length; i++ ) {

        // 個人ＩＤ未指定ならばスキップ
        if ( recentConsults[ i ].perId == '' ) continue;

        // ドック、定期健診を除くコースの場合はスキップ
        if ( recentConsults[ i ].csCd != '100' && recentConsults[ i ].csCd != '110' ) continue;

        warnCslDate = new Array();

        // 受診日を検索
        for ( var j = recentConsults[ i ].cslDate.length - 1; j >= 0; j-- ) {

            // 指定月数前の受診日、指定月数後の受診日の範囲外ならば対象外
            if ( recentConsults[ i ].cslDate[ j ] < minCslDate || recentConsults[ i ].cslDate[ j ] > maxCslDate ) continue;

            // 上記除外条件に該当しない場合はワーニング対象となる受診情報のため、スタック
            wkDate = recentConsults[ i ].cslDate[ j ].split( '/' );
            warnCslDate[ warnCslDate.length ] = parseInt( wkDate[ 0 ], 10 ) + '年' + parseInt( wkDate[ 1 ], 10 ) + '月' + parseInt( wkDate[ 2 ], 10 ) + '日';

        }

        // ワーニング対象となる受診日存在時はメッセージを編集
        if ( warnCslDate.length > 0 ) {
            msg = msg + ( msg != '' ? '\n' : '');
            msg = msg + recentConsults[ i ].perId   + '：';
            msg = msg + recentConsults[ i ].perName + '　';
            msg = msg + warnCslDate.join( '、' ) + 'にこの受診者の受診情報がすでに存在します。';
        }

    }

    return msg;

}

// 月の加算
function monthAdd( cslYear, cslMonth, cslDay, addMonth ) {

    var wkDate;	// 日付ワーク

    // 指定年月の先頭日に対してDateクラスを絡めた演算を行い、まず年・月を求める
    wkDate = new Date( parseInt( cslYear, 10 ), parseInt( cslMonth, 10 ) - 1 + addMonth, 1 );
    var calcYear  = wkDate.getFullYear();
    var calcMonth = wkDate.getMonth();

    var calcDay = parseInt( cslDay, 10 );

    for ( ; ; ) {

        // 求められた年・月に対して指定された日を付加してDateクラスを構成。
        wkDate = new Date( calcYear, calcMonth, calcDay );

        // この結果、(末日の関係上)月の値が変わる場合は日付をデクリメントし、再度構成。正しい末日を求める。
        if ( wkDate.getMonth() == calcMonth ) {
            break;
        }

        calcDay--;
    }

    // 月を1～12の形式に変換
    calcMonth++;

    // ゼロ、スラッシュ付き日付文字列形式で返す
    return calcYear + '/' + ('0' + calcMonth).slice( -2 ) + '/' + ('0' + calcDay).slice( -2 );

}
<%
'## 2004/04/20 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>
