<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       成績書 (Ver0.0.1)
'       AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
'管理番号：SL-UI-Y0101-105
'修正日  ：2010.06.25
'担当者  ：TCS)田村
'修正内容：レイアウト変更対応（ページ８～１０に対応）
'管理番号：SL-SN-Y0101-004
'修正日  ：2011.08.25
'担当者  ：FJTH)村田
'修正内容：起動パラメータのエラーチェック追加（当日IDまたは団体Ｇまたは団体　必須）

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode             '印刷モード
Dim vntMessage          '通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon                               '共通クラス
Dim objOrganization                         '団体情報アクセス用
Dim objOrgBsd                               '事業部情報アクセス用
Dim objOrgRoom                              '室部情報アクセス用
Dim objOrgPost                              '所属情報アクセス用
Dim objPerson                               '個人情報アクセス用
Dim objReport                               '帳票情報アクセス用
Dim objFree                                 '汎用情報アクセス用

'パラメータ値
Dim strSCslYear, strSCslMonth, strSCslDay   '開始年月日
Dim strECslYear, strECslMonth, strECslDay   '終了年月日
Dim strDayId                                '当日ID
Dim strOrgGrpCd                             '団体グループコード
Dim strOrgCd11                              '団体コード１１
Dim strOrgCd12                              '団体コード１２
Dim strOrgCd21                              '団体コード２１
Dim strOrgCd22                              '団体コード２２
Dim strOrgCd31                              '団体コード３１
Dim strOrgCd32                              '団体コード３２
Dim strOrgCd41                              '団体コード４１
Dim strOrgCd42                              '団体コード４２
Dim strOrgCd51                              '団体コード５１
Dim strOrgCd52                              '団体コード５２
Dim strOrgCd61                              '団体コード６１
Dim strOrgCd62                              '団体コード６２
Dim strOrgCd71                              '団体コード７１
Dim strOrgCd72                              '団体コード７２
Dim strReportOutDate                        '出力日
Dim strReportOutput                         '出力様式
Dim strHistoryPrint                         '過去歴印刷
Dim strReportCd                             '帳票コード
Dim UID                                     'ユーザID
Dim strsort                                 '出力順
Dim strpage1                                '出力頁
Dim strpage2                                '出力頁
Dim strpage3                                '出力頁
Dim strpage4                                '出力頁
Dim strpage5                                '出力頁
Dim strpage6                                '出力頁
'### 2008.03.12 張 特定健診成績表対応のため追加 Start ###
Dim strpage7                                '出力頁
'### 2008.03.12 張 特定健診成績表対応のため追加 End   ###
'#### 2010.06.25 SL-UI-Y0101-105 ADD START ####'
Dim strpage8                                '出力頁
Dim strpage9                                '出力頁
Dim strpage10                               '出力頁
'#### 2010.06.25 SL-UI-Y0101-105 ADD END ####'

'作業用変数
Dim strSCslDate                             '開始日
Dim strECslDate                             '終了日
Dim strOrgGrpName                           '団体グループ名称
Dim strOrgName1                             '団体１名称
Dim strOrgName2                             '団体２名称
Dim strOrgName3                             '団体３名称
Dim strOrgName4                             '団体４名称
Dim strOrgName5                             '団体５名称
Dim strOrgName6                             '団体６名称
Dim strOrgName7                             '団体７名称

'帳票情報
Dim strArrReportCd                          '帳票コード
Dim strArrReportName                        '帳票名
Dim strArrHistoryPrint                      '過去歴印刷
Dim lngReportCount                          'レコード数

Dim i                   'ループインデックス
Dim j                   'ループインデックス

' 2005/12/14  Add by 李  --------------------
Dim strCslDivCd         '受診区分コード
Dim strBillPrint        '請求書出力区分コード

'汎用情報
Dim strFreeCd           '汎用コード
Dim strFreeDate         '汎用日付
Dim strFreeField1       'フィールド１
Dim strFreeField2       'フィールド２

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'共通引数値の取得
strMode = Request("mode")

'帳票出力処理制御
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'◆ 開始年月日
    If IsEmpty(Request("strCslYear")) Then
        strSCslYear   = Year(Now())             '開始年
        strSCslMonth  = Month(Now())            '開始月
        strSCslDay    = Day(Now())              '開始日
    Else
        strSCslYear   = Request("strCslYear")   '開始年
        strSCslMonth  = Request("strCslMonth")  '開始月
        strSCslDay    = Request("strCslDay")    '開始日
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'◆ 終了年月日
    If IsEmpty(Request("endCslYear")) Then
'       strECslYear   = Year(Now())             '終了年
'       strECslMonth  = Month(Now())            '開始月
'       strECslDay    = Day(Now())              '開始日
    Else
        strECslYear   = Request("endCslYear")   '終了年
        strECslMonth  = Request("endCslMonth")  '開始月
        strECslDay    = Request("endCslDay")    '開始日
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
'   If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
'      Right("00" & Trim(CStr(strSCslMonth)), 2) & _
'      Right("00" & Trim(CStr(strSCslDay)), 2) _
'    > Right("0000" & Trim(CStr(strECslYear)), 4) & _
'      Right("00" & Trim(CStr(strECslMonth)), 2) & _
'      Right("00" & Trim(CStr(strECslDay)), 2) Then
'       strSCslYear   = strECslYear
'       strSCslMonth  = strECslMonth
'       strSCslDay    = strECslDay
'       strSCslDate   = strECslDate
'       strECslYear   = Request("strCslYear")   '開始年
'       strECslMonth  = Request("strCslMonth")  '開始月
'       strECslDay    = Request("strCslDay")    '開始日
'       strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'   End If

'◆ 当日ID
    strDayId        = Request("DayId")

'◆ 団体グループコード
    strOrgGrpCd     = Request("OrgGrpCd")
    strOrgGrpName   = Request("OrgGrpName")

'◆ 団体コード
    '団体１
    strOrgCd11      = Request("OrgCd11")
    strOrgCd12      = Request("OrgCd12")
    strOrgName1     = Request("OrgName1")

    '団体２
    strOrgCd21      = Request("OrgCd21")
    strOrgCd22      = Request("OrgCd22")
    strOrgName2     = Request("OrgName2")
    '団体３
    strOrgCd31      = Request("OrgCd31")
    strOrgCd32      = Request("OrgCd32")
    strOrgName3     = Request("OrgName3")
    '団体４
    strOrgCd41      = Request("OrgCd41")
    strOrgCd42      = Request("OrgCd42")
    strOrgName4     = Request("OrgName4")
    '団体５
    strOrgCd51      = Request("OrgCd51")
    strOrgCd52      = Request("OrgCd52")
    strOrgName5     = Request("OrgName5")
    '団体６
    strOrgCd61      = Request("OrgCd61")
    strOrgCd62      = Request("OrgCd62")
    strOrgName6     = Request("OrgName6")
    '団体７
    strOrgCd71      = Request("OrgCd71")
    strOrgCd72      = Request("OrgCd72")
    strOrgName7     = Request("OrgName7")

'◆ 出力日
    strReportOutDate = Request("ReportOutDate")

'◆ 出力様式
    strReportOutput = Request("ReportOutput")
    strHistoryPrint = Request("HistoryPrint")
    strReportCd     = Request("Reportcd")

'◆ ユーザID
    UID             = Session("USERID")

'◆ 出力順
    strsort         = Request("sort")

'◆ 出力頁
    strpage1 = Request("checkpage1Val")
    strpage1 = IIf(strpage1 = "", 1, strpage1)
    strpage2 = Request("checkpage2Val")
    strpage2 = IIf(strpage2 = "", 1, strpage2)
    strpage3 = Request("checkpage3Val")
    strpage3 = IIf(strpage3 = "", 1, strpage3)
    strpage4 = Request("checkpage4Val")
    strpage4 = IIf(strpage4 = "", 1, strpage4)
    strpage5 = Request("checkpage5Val")
    strpage5 = IIf(strpage5 = "", 1, strpage5)
    strpage6 = Request("checkpage6Val")
    strpage6 = IIf(strpage6 = "", 1, strpage6)
'### 2008.03.12 張 特定健診成績表対応のため追加 Start ###
    strpage7 = Request("checkpage7Val")
    strpage7 = IIf(strpage7 = "", 1, strpage7)
'### 2008.03.12 張 特定健診成績表対応のため追加 End   ###
'#### 2010.06.25 SL-UI-Y0101-105 ADD START ####'
    strpage8 = Request("checkpage8Val")
    strpage8 = IIf(strpage8 = "", 1, strpage8)
    strpage9 = Request("checkpage9Val")
    strpage9 = IIf(strpage9 = "", 1, strpage9)
    strpage10= Request("checkpage10Val")
    strpage10= IIf(strpage10= "", 1, strpage10)
'#### 2010.06.25 SL-UI-Y0101-105 ADD END ####'

'◆ 受診区分コード
    strCslDivCd     = Request("cslDivCd")

'◆ 請求書出力区分コード
    strBillPrint    = Request("billPrint")
    
End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim vntArrMessage	'エラーメッセージの集合
    Dim blnErrFlg
    Dim aryChkString
    Dim aryChkString2
    
    aryChkString = Array("1","2","3","4","5","6","7","8","9","0",",","-")
    aryChkString2 = Array("1","2","3","4","5","6","7","8","9","0")

    'ここにチェック処理を記述
    With objCommon
'例)	   .AppendArray vntArrMessage, コメント
        If strMode <> "" Then
            '受診日チェック
            If Not IsDate(strECslDate) Then
                strECslDate = strSCslDate
            End If
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "開始日付が正しくありません。"
            End If
            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "終了日付が正しくありません。"
            End If

            '当日IDチェック
            If Trim(strDayId) <> "" Then
                blnErrFlg = 0
                For j = 0 to UBound(aryChkString2)
                    If Trim(Mid(strDayId, len(strDayId), 1)) = Trim(aryChkString2(j)) Then
                        blnErrFlg = 1
                        Exit For
                    End if
                Next
                If blnErrFlg = 0 Then
                    .AppendArray vntArrMessage, "当日IDの最後の文字が正しくありません。"
                End If
            End If
            If Trim(strDayId) <> "" Then
                For i = 1 To Len(strDayId)
                    blnErrFlg = 0
                    For j = 0 to UBound(aryChkString)
                        If Trim(Mid(strDayId, i, 1)) = Trim(aryChkString(j)) Then
                            blnErrFlg = 1
                            Exit For
                        End if
                    Next
                    If blnErrFlg = 0 Then
                        .AppendArray vntArrMessage, "当日IDが正しくありません。"
                        Exit For
                    End If
                Next
            End If
            
            '出力様式のチェック
            If strReportCd = "" Then
                objCommon.appendArray vntArrMessage, "出力様式を選択して下さい。"
            End If

            '出力様式のチェック
            '#### 2007/08/02 張 成績表（企業用今回）も日付チェックができるように修正 ####
            'If Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308" Then
            If (Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308") or trim(strReportCd) = "000312" Then
'日付型でチェックする
'               if Trim(strSCslDate) < "2004/4/1" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 < "2004/04/01" Then
                    objCommon.appendArray vntArrMessage, "開始日が 2004年3月31日 以前です。"
                End If
            End If


            '出力様式のチェック
            If Trim(strReportCd) >= "000301"  and trim(strReportCd) <= "000304" Then
'日付型でチェックする
'               if Trim(strSCslDate) > "2004/3/31" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 > "2004/03/31" Then
                    objCommon.appendArray vntArrMessage, "開始日が 2004年4月1日 以降です。"
                End If
            End If

'## 2007.04.01 婦人科判定分類のため、成績書修正  START ############

            '出力様式のチェック
            '#### 2007/08/02 張 成績表（企業用今回）も日付チェックができるように修正 ####
            'If Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308" Then
            If (Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308") or trim(strReportCd) = "000312" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 > "2007/03/31" Then
                    objCommon.appendArray vntArrMessage, "開始日が 2007年4月1日 以降です。"
                End If
            End If
            
            
            '出力様式のチェック
            If Trim(strReportCd) >= "000320"  and trim(strReportCd) <= "000324" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 < "2007/04/01" Then
                    objCommon.appendArray vntArrMessage, "開始日が 2007年4月1日 以前です。"
                End If
            End If

'## 2007.04.01 婦人科判定分類のため、成績書修正  END ############


'## 2008.03.27 特定健診結果報告書追加によって、成績書修正  START ############
            '出力様式のチェック
            If (Trim(strReportCd) >= "000320"  and trim(strReportCd) <= "000324") or trim(strReportCd) = "000311" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 > "2008/03/31" Then
                    objCommon.appendArray vntArrMessage, "開始日が 2008年4月1日 以降です。"
                End If
            End If

            '出力様式のチェック
            If Trim(strReportCd) >= "000330"  and trim(strReportCd) <= "000339" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 < "2008/04/01" Then
                    objCommon.appendArray vntArrMessage, "開始日が 2008年4月1日 以前です。"
                End If
            End If
'## 2008.03.27 特定健診結果報告書追加によって、成績書修正  END   ############

            '印刷ページのチェック
            If Trim(strReportCd) = "000303"  or trim(strReportCd) = "000307"  or trim(strReportCd) = "000324"  Then
                if strpage1 <> "1" and strpage2 <> "1" and strpage3 <> "1"  Then
                    objCommon.appendArray vntArrMessage, "印刷ページを指定してください。"
                End If
            End If

            '印刷ページのチェック
            If Trim(strReportCd) = "000304"  or trim(strReportCd) = "000308" or trim(strReportCd) = "000309"  or trim(strReportCd) = "000322" Then
                if strpage1 <> "1"  Then
                    objCommon.appendArray vntArrMessage, "印刷ページを指定してください。"
                End If
            End If

'## 2011.08.25 SL-SN-Y0101-004 ADD START ##'
            If Trim(strDayId) = "" AND Trim(strOrgGrpCd) = "" AND Trim(strOrgCd11) = "" Then
                objCommon.appendArray vntArrMessage, "受診日範囲以外の条件を指定してください。"
            End If
'## 2011.08.25 SL-SN-Y0101-004 ADD END ##'


        End If

    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Print()

    Dim Ret             '関数戻り値
    Dim dtmStrCslDate   '開始受診日
    Dim dtmEndCslDate   '終了受診日
    Dim objFlexReport   '成績書出力用

    If Not IsArray(CheckValue()) Then

		'情報漏えい対策用ログ書き出し
		Call putPrivacyInfoLog("PH056", "成績書の印刷を行った")

        dtmStrCslDate = CDate(strSCslDate)
        dtmEndCslDate = CDate(strECslDate)

        Set objFlexReport   = Server.CreateObject("HainsFlexReport.FlexReportControl")
        
        '成績書ドキュメントファイル作成処理
'       Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72)

'       Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort)

'#### 2010.06.25 SL-UI-Y0101-105 MOD START ####'
''''### 2008.03.12 張 特定健診成績表対応のため追加 Start ###
''''        Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort, strpage1, strpage2, strpage3, strpage4, strpage5, strpage6, strCslDivCd, strBillPrint)
'''        Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort, strpage1, strpage2, strpage3, strpage4, strpage5, strpage6, strpage7, strCslDivCd, strBillPrint)
''''### 2008.03.12 張 特定健診成績表対応のため追加 End   ###
        Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort, strpage1, strpage2, strpage3, strpage4, strpage5, strpage6, strpage7, strCslDivCd, strBillPrint, strpage8, strpage9, strpage10)
'#### 2010.06.25 SL-UI-Y0101-105 MOD END ####'

        Print = Ret
    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>成績書</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体画面表示
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {

    // 団体情報エレメントの参照設定
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );
    // 画面表示
    orgPostGuide_showGuideOrg();

}

// 団体情報削除
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {

    // 団体情報エレメントの参照設定
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );

    // 削除
    orgPostGuide_clearOrgInfo();

}

// 出力頁１チェック
function checkpage1Act() {

    with ( document.entryForm ) {
        checkpage1.value = (checkpage1.checked ? '1' : '0');
        checkpage1Val.value = (checkpage1.checked ? '1' : '0');
    }

}
// 出力頁２チェック
function checkpage2Act() {

    with ( document.entryForm ) {
        checkpage2.value = (checkpage2.checked ? '1' : '0');
        checkpage2Val.value = (checkpage2.checked ? '1' : '0');
    }

}
// 出力頁３チェック
function checkpage3Act() {

    with ( document.entryForm ) {
        checkpage3.value = (checkpage3.checked ? '1' : '0');
        checkpage3Val.value = (checkpage3.checked ? '1' : '0');
    }

}
// 出力頁４チェック
function checkpage4Act() {

    with ( document.entryForm ) {
        checkpage4.value = (checkpage4.checked ? '1' : '0');
        checkpage4Val.value = (checkpage4.checked ? '1' : '0');
    }

}
// 出力頁５チェック
function checkpage5Act() {

    with ( document.entryForm ) {
        checkpage5.value = (checkpage5.checked ? '1' : '0');
        checkpage5Val.value = (checkpage5.checked ? '1' : '0');
    }

}
// 出力頁６チェック
function checkpage6Act() {

    with ( document.entryForm ) {
        checkpage6.value = (checkpage6.checked ? '1' : '0');
        checkpage6Val.value = (checkpage6.checked ? '1' : '0');
    }

}

/** 2008.03.12 張 特定健診成績表対応のため追加 Start **/
// 出力頁７チェック
function checkpage7Act() {

    with ( document.entryForm ) {
        checkpage7.value = (checkpage7.checked ? '1' : '0');
        checkpage7Val.value = (checkpage7.checked ? '1' : '0');
    }
}
/** 2008.03.12 張 特定健診成績表対応のため追加 End   **/

//'#### 2010.06.25 SL-UI-Y0101-105 MOD START ####'
function checkpage8Act() {

    with ( document.entryForm ) {
        checkpage8.value = (checkpage8.checked ? '1' : '0');
        checkpage8Val.value = (checkpage8.checked ? '1' : '0');
    }

}
function checkpage9Act() {

    with ( document.entryForm ) {
        checkpage9.value = (checkpage9.checked ? '1' : '0');
        checkpage9Val.value = (checkpage9.checked ? '1' : '0');
    }

}
function checkpage10Act() {

    with ( document.entryForm ) {
        checkpage10.value = (checkpage10.checked ? '1' : '0');
        checkpage10Val.value = (checkpage10.checked ? '1' : '0');
    }

}
//'#### 2010.06.25 SL-UI-Y0101-105 MOD END ####'


// submit時の処理
function submitForm() {

    document.entryForm.submit();

}

//function selectHistoryPrint( index ) {

//	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;

//}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" method="post">
    <BLOCKQUOTE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■成績書</SPAN></B></TD>
        </TR>
    </TABLE>
<%
    'エラーメッセージ表示
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>
<%
    'モードはプレビュー固定
%>
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">

    <INPUT TYPE="hidden" NAME="OrgGrpName"    VALUE="<%= strOrgGrpName    %>">
    <INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11       %>">
    <INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12       %>">
    <INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21       %>">
    <INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22       %>">
    <INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31       %>">
    <INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32       %>">
    <INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41       %>">
    <INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42       %>">
    <INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51       %>">
    <INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52       %>">
    <INPUT TYPE="hidden" NAME="orgCd61"       VALUE="<%= strOrgCd61       %>">
    <INPUT TYPE="hidden" NAME="orgCd62"       VALUE="<%= strOrgCd62       %>">
    <INPUT TYPE="hidden" NAME="orgCd71"       VALUE="<%= strOrgCd71       %>">
    <INPUT TYPE="hidden" NAME="orgCd72"       VALUE="<%= strOrgCd72       %>">

    <!--- 日付 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>受診日</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>日</TD>
            <TD>～</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditSelectNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strECslYear)) %></TD>
            <TD>年</TD>
            <TD><%= EditSelectNumberList("endCslMonth", 1, 12, Clng("0" & strECslMonth)) %></TD>
            <TD>月</TD>
            <TD><%= EditSelectNumberList("endCslDay",   1, 31, Clng("0" & strECslDay  )) %></TD>
            <TD>日</TD>
        </TR>
    </TABLE>

    <!-- 当日ID -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD START ##-->
            <!--## <TD>□</TD> ##-->
            <TD><FONT COLOR="#ff0000">□</FONT></TD>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD END ##-->
            <TD WIDTH="90" NOWRAP>当日ID</TD>
            <TD>：</TD>
            <TD>
                <INPUT TYPE="text" NAME="DayId" SIZE="100" VALUE="<%= strDayId %>">
            </TD>
        </TR>
    </TABLE>

    <!-- 団体グループ-->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD START ##-->
            <!--## <TD>□</TD> ##-->
            <TD><FONT COLOR="#ff0000">□</FONT></TD>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD END ##-->
            <TD WIDTH="90" NOWRAP>団体グループ</TD>
            <TD>：</TD>
            <TD><%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD START ##-->
            <!--## <TD>□</TD> ##-->
            <TD><FONT COLOR="#ff0000">□</FONT></TD>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD END ##-->
            <TD WIDTH="90" NOWRAP>団体１</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName1"><% = strOrgName1 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体２</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd121, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName2"><% = strOrgName2 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体３</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd131, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体４</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd141, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName4"><% = strOrgName4 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体５</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd151, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName5"><% = strOrgName5 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体６</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd161, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName6"><% = strOrgName6 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体７</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd171, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName7"><% = strOrgName7 %></SPAN></TD>
        </TR>
    </TABLE>
                <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>出力様式</TD>
            <TD>：</TD>
            <TD>
<!--
                <SELECT NAME="reportCd" ONCHANGE="javascript:selectHistoryPrint(this.selectedIndex)">
-->
                <SELECT NAME="reportCd">
                    <OPTION VALUE="">&nbsp;
<%
                    '帳票テーブル読み込み
                    Set objReport = Server.CreateObject("HainsReport.Report")
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'                   lngReportCount = objReport.SelectReportList(strArrReportCd, strArrReportName, "1", , , , strArrHistoryPrint)
                    lngReportCount = objReport.SelectReportList(strArrReportCd, strArrReportName, "1", , , , strArrHistoryPrint, , , True)
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
                    For i = 0 To lngReportCount - 1
%>
                        <OPTION VALUE="<%= strArrReportCd(i) %>" <%= IIf(strArrReportCd(i) = strReportCd, "SELECTED", "") %>><%= strArrReportName(i) %>
<%
                    Next
%>
                </SELECT>
            </TD>
        </TR>
    </TABLE>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD><FONT COLOR="#ff0000">■</FONT></TD>
                        <TD WIDTH="90" NOWRAP>出力順</TD>
                        <TD>：</TD>
                        <TD>
                            <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                                <TR>
                                    <TD><INPUT TYPE="Radio" NAME="sort" VALUE="0" <%= "CHECKED" %> checked>受診日＋当日ID</TD>
                                    <TD><INPUT TYPE="Radio" NAME="sort" VALUE="1" >団体＋受診日＋当日ID</TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD><FONT COLOR="#ff0000">■</FONT></TD>
                        <TD WIDTH="90" NOWRAP>印刷ページ</TD>
                        <TD>：</TD>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage1Val" VALUE="<%= strpage1 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage1" VALUE="1" <%= Iif(strpage1 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage1Act()" border="0">1page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage2Val" VALUE="<%= strpage2 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage2" VALUE="1" <%= Iif(strpage2 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage2Act()" border="0">2page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage3Val" VALUE="<%= strpage3 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage3" VALUE="1" <%= Iif(strpage3 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage3Act()" border="0">3page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage4Val" VALUE="<%= strpage4 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage4" VALUE="1" <%= Iif(strpage4 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage4Act()" border="0">4page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage5Val" VALUE="<%= strpage5 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage5" VALUE="1" <%= Iif(strpage5 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage5Act()" border="0">5page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage6Val" VALUE="<%= strpage6 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage6" VALUE="1" <%= Iif(strpage6 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage6Act()" border="0">6page</TD>
                                </TR>
                            </TABLE>
                        </td>

                        <!--#### 2008.03.12 張 特定健診成績表対応のため追加 Start ####-->
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage7Val" VALUE="<%= strpage7 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage7" VALUE="1" <%= Iif(strpage7 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage7Act()" border="0">7page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <!--#### 2008.03.12 張 特定健診成績表対応のため追加 End   ####-->
                        <!--'#### 2010.06.25 SL-UI-Y0101-105 MOD START ####'-->
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage8Val" VALUE="<%= strpage8 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage8" VALUE="1" <%= Iif(strpage8 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage8Act()" border="0">8page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage9Val" VALUE="<%= strpage9 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage9" VALUE="1" <%= Iif(strpage9 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage9Act()" border="0">9page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage10Val" VALUE="<%= strpage10 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage10" VALUE="1" <%= Iif(strpage10 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage10Act()" border="0">10page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <!--'#### 2010.06.25 SL-UI-Y0101-105 MOD END ####'-->

                        <td></td>
                    </TR>
                </TABLE>


        <!-- 請求書出力区分 -->
        <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
            <TR>
                <TD>□</TD>
                <TD WIDTH="90" NOWRAP>受診区分</TD>
                <TD>：</TD>
    <%
                '汎用テーブルから受診区分を読み込む
                Set objFree = Server.CreateObject("HainsFree.Free")
                objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
                Set objFree = Nothing
    %>
                <TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, NON_SELECTED_ADD) %></TD>
            </TR>
        </TABLE>

        
        <!-- 請求書出力区分 -->
        <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
            <TR>
                <TD>□</TD>
                <TD WIDTH="90" NOWRAP>請求書出力</TD>
                <TD>：</TD>
                <TD>
                    <SELECT NAME="billPrint">
                        <OPTION VALUE=""></OPTION>
                        <OPTION VALUE="1">本人</OPTION>
                        <OPTION VALUE="2">家族</OPTION>
                    </SELECT>
                </TD>
             
            </TR>
        </TABLE>

        <BR>

    <!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/print.gif" WIDTH="76" HEIGHT="23" ALT="印刷する"></A>
    <%  End if  %>

    </BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="orgname1" VALUE="<%= Server.HTMLEncode(strOrgName1) %>">
    <INPUT TYPE="hidden" NAME="orgname2" VALUE="<%= Server.HTMLEncode(strOrgName2) %>">
    <INPUT TYPE="hidden" NAME="orgname3" VALUE="<%= Server.HTMLEncode(strOrgName3) %>">
    <INPUT TYPE="hidden" NAME="orgname4" VALUE="<%= Server.HTMLEncode(strOrgName4) %>">
    <INPUT TYPE="hidden" NAME="orgname5" VALUE="<%= Server.HTMLEncode(strOrgName5) %>">
    <INPUT TYPE="hidden" NAME="orgname6" VALUE="<%= Server.HTMLEncode(strOrgName6) %>">
    <INPUT TYPE="hidden" NAME="orgname7" VALUE="<%= Server.HTMLEncode(strOrgName7) %>">
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/orgGuideExtension.inc" -->
<script type="text/javascript">
var orgGuide_setLastOrgName = function(name, value)
{
	var form = document.entryForm;
	 
	if ( form[name] ) {
		form[name].value = value || '';
	}
};

document.body.onload = function()
{
	for ( var i = 1; i <= 7; i++ ) {
		document.getElementById('OrgName' + i).innerHTML = document.entryForm['orgname' + i].value;
	}
};
</script>
</BODY>
</HTML>