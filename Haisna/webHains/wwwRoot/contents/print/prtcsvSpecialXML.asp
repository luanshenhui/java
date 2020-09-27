<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	特定健診結果CSV出力（XML用） (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode         '印刷モード
Dim vntMessage      '通知メッセージ
Dim MSGMODE

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon       '共通クラス
Dim objOrganization '団体情報アクセス用
Dim objOrgBsd       '事業部情報アクセス用
Dim objOrgRoom      '室部情報アクセス用
Dim objOrgPost      '所属情報アクセス用
Dim objPerson       '個人情報アクセス用

'### 2013/02/04 張 出力条件に受診区分追加の為追加 ###
Dim objFree         '汎用情報アクセス用

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strSCslYear, strSCslMonth, strSCslDay   '開始年月日
Dim strECslYear, strECslMonth, strECslDay   '終了年月日
Dim strCsCd                                 'コースコード
Dim strOrgCd1, strOrgCd2                    '団体コード
Dim strOrgBsdCd, strOrgRoomCd               '事業部コード, 室部コード
Dim strSOrgPostCd, strEOrgPostCd            '開始所属コード, 終了所属コード
Dim strPerId                                '個人コード
Dim strObject                               '出力対象
'■■■■■■■■■■

'作業用変数
Dim strOrgName          '団体名
Dim strBsdName          '事業部名
Dim strRoomName         '室部名
Dim strSPostName        '開始所属名
Dim strEPostName        '終了所属名
Dim strLastName         '姓
Dim strFirstName        '名
Dim strPerName          '氏名
Dim strSCslDate         '開始日
Dim strECslDate         '終了日

Dim strOrgGrpCd         '団体グループコード
Dim strOrgCd11          '団体コード１１
Dim strOrgCd12          '団体コード１２
Dim strOrgCd21          '団体コード２１
Dim strOrgCd22          '団体コード２２
Dim strOrgCd31          '団体コード３１
Dim strOrgCd32          '団体コード３２
Dim strOrgCd41          '団体コード４１
Dim strOrgCd42          '団体コード４２
Dim strOrgCd51          '団体コード５１
Dim strOrgCd52          '団体コード５２

Dim strOrgGrpName           '団体グループ名称
Dim strOrgName1         '団体１名称
Dim strOrgName2         '団体２名称
Dim strOrgName3         '団体３名称
Dim strOrgName4         '団体４名称
Dim strOrgName5         '団体５名称

'2009.03.03（李）健診コース区分、出力項目区分
Dim strCourseCd         '健診コース区分コード
Dim strSpItem           '特定健診項目と一般項目区分

'### 2013/02/04 張 出力条件に受診区分追加 ###
Dim strCslDivCd         '受診区分コード

'### 2017/02/03 張 出力条件に請求書出力区分追加
Dim strBillPrint        '請求書出力区分コード

'2009.06.01 (李) 団体請求関連変数追加
Dim strOrgBill          '団体請求対象


Dim strBillOrgCd1       '請求対象団体コード１
Dim strBillOrgCd2       '請求対象団体コード２
Dim strBillOrgName      '請求対象団体名称

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
'■■■■■■■■■■ 画面項目にあわせて編集
    '括弧内の文字列はHTML部で記述した項目の名称となります

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
        strECslYear   = Year(Now())             '終了年
        strECslMonth  = Month(Now())            '開始月
        strECslDay    = Day(Now())              '開始日
    Else
        strECslYear   = Request("endCslYear")   '終了年
        strECslMonth  = Request("endCslMonth")  '開始月
        strECslDay    = Request("endCslDay")    '開始日
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay

'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
    If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
       Right("00" & Trim(CStr(strSCslMonth)), 2) & _
       Right("00" & Trim(CStr(strSCslDay)), 2) _
     > Right("0000" & Trim(CStr(strECslYear)), 4) & _
       Right("00" & Trim(CStr(strECslMonth)), 2) & _
       Right("00" & Trim(CStr(strECslDay)), 2) Then
        strSCslYear   = strECslYear
        strSCslMonth  = strECslMonth
        strSCslDay    = strECslDay
        strSCslDate   = strECslDate
        strECslYear   = Request("strCslYear")   '開始年
        strECslMonth  = Request("strCslMonth")  '開始月
        strECslDay    = Request("strCslDay")    '開始日
        strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
    End If


'◆ 団体グループコード
    strOrgGrpCd = Request("OrgGrpCd")
    strOrgGrpName = Request("OrgGrpName")

'◆ 団体コード
    '団体１
    strOrgCd11  = Request("OrgCd11")
    strOrgCd12  = Request("OrgCd12")
    strOrgName1 = Request("OrgName1")
    '団体２
    strOrgCd21  = Request("OrgCd21")
    strOrgCd22  = Request("OrgCd22")
    strOrgName2 = Request("OrgName2")
    '団体３
    strOrgCd31  = Request("OrgCd31")
    strOrgCd32  = Request("OrgCd32")
    strOrgName3 = Request("OrgName3")
    '団体４
    strOrgCd41  = Request("OrgCd41")
    strOrgCd42  = Request("OrgCd42")
    strOrgName4 = Request("OrgName4")
    '団体５
    strOrgCd51  = Request("OrgCd51")
    strOrgCd52  = Request("OrgCd52")
    strOrgName5 = Request("OrgName5")
    '健診コース
    strCourseCd = Request("Course")
    '健診項目
    strSpItem   = Request("SpItem")


'### 2012/10/30 張 2012年10月1日からの問診票変更に伴う項目区分設定（2012年10月1日基準）Start ###


'### 2013/03/08 張 2013年4月1日からの特定健診・特定保健指導改訂関連システム変更 Start ###
'    If CDate(GetVer201210()) <= CDate(strSCslDate)  Then
'        If strSpItem = "" Then
'            strSpItem = "1"
'        Else
'            strSpItem = "2"
'        End If
'    End If

    If CDate(GetVersion("CHG201304")) <= CDate(strSCslDate)  Then

        If strSpItem = "A" Then
            strSpItem = "A201304"
        Else
            strSpItem = "S201304"
        End If

    Elseif CDate(GetVersion("CHG201210")) <= CDate(strSCslDate)  Then

        If strSpItem = "A" Then
            strSpItem = "A201210"
        Else
            strSpItem = "S201210"
        End If

    End If
'### 2013/03/08 張 2013年4月1日からの特定健診・特定保健指導改訂関連システム変更 End   ###


'### 2012/10/30 張 2012年10月1日からの問診票変更に伴う項目区分設定（2012年10月1日基準）End   ###



'### 2013/02/04 張 出力条件に受診区分追加の為追加 ###
'◆ 受診区分コード
    strCslDivCd     = Request("cslDivCd")

'### 2017/02/03 張 出力条件に請求書出力区分追加 STR ###
'◆ 請求書出力区分コード
    strBillPrint    = Request("billPrint")
'### 2017/02/03 張 出力条件に請求書出力区分追加 END ###

    '団体請求対象
    strOrgBill  = Request("orgBill")

    '請求対象団体
    strBillOrgCd1  = Request("billOrgCd1")
    strBillOrgCd2  = Request("billOrgCd2")
    strBillOrgName = Request("BillOrgName")



'■■■■■■■■■■
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

    Dim vntArrMessage   'エラーメッセージの集合

'■■■■■■■■■■ 画面項目にあわせて編集
    'ここにチェック処理を記述
    With objCommon
'例)		.AppendArray vntArrMessage, コメント

        If strMode <> "" Then
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "開始日付が正しくありません。"
            End If

            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "終了日付が正しくありません。"
            End If
        End If

'### 2012/10/30 張 2012年10月1日からの問診票変更に伴う項目区分設定（2012年10月1日基準）Start ###
'        If CDate(strSCslDate) < CDate(GetVer201210()) and  CDate(strECslDate) >= CDate(GetVer201210()) Then
'            .AppendArray vntArrMessage, "2012年10月1日をまたがる日付設定はできません。（問診票変更の為）"
'        End If

        If CDate(strSCslDate) < CDate(GetVersion("CHG201210")) and  CDate(strECslDate) >= CDate(GetVersion("CHG201210")) Then
            .AppendArray vntArrMessage, "2012年10月1日をまたがる日付設定はできません。（問診票変更の為）"
        End If

'### 2012/10/30 張 2012年10月1日からの問診票変更に伴う項目区分設定（2012年10月1日基準）End   ###


'### 2013/03/08 張 2013年4月1日からの特定健診・特定保健指導改訂関連システム変更 Start ###
        If CDate(strSCslDate) < CDate(GetVersion("CHG201304")) and  CDate(strECslDate) >= CDate(GetVersion("CHG201304")) Then
            .AppendArray vntArrMessage, "2013年4月1日をまたがる日付設定はできません。（特定健診・特定保健指導改訂の為）"
        End If
'### 2013/03/08 張 2013年4月1日からの特定健診・特定保健指導改訂関連システム変更 End   ###

        If strOrgCd11 = "" and strOrgCd21 = "" and strOrgCd31 = "" and strOrgCd41 = "" and strOrgCd51 = "" and strOrgGrpCd = "" Then
            .AppendArray vntArrMessage, "団体を選択してください。"
        End If

        If strOrgBill = "1" then
            If strBillOrgCd1 = "" then
                .AppendArray vntArrMessage, "請求対象団体を選んでください。"
            End If
        End If

    End With
'■■■■■■■■■■

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
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objCommon   '共通クラス
    Dim objPrintCls '団体一覧出力用COMコンポーネント
    Dim Ret         '関数戻り値

    Dim strURL

    If Not IsArray(CheckValue()) Then

        '情報漏えい対策用ログ書き出し
        Call putPrivacyInfoLog("PH110", "特定健診項目健診結果XML変換用CSV出力①③よりファイル出力を行った")

''''''''''''''''''■■■■■■■■■■ 画面項目にあわせて編集
'''''''''''''''''       'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsAbsenceListXML.AbsenceListXML")
'''''''''''''''''       'プロジェクト名はソースを開いて確認。
'''''''''''''''''
'''''''''''''''''       '団体一覧表ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
''    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52)

'''''''''''''''''       '2009.03.03 (李) 健診コース区分、出力項目区分パラメーター追加       
''    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem)

'''''''''''''''''       '2009.06.01 (李) 団体請求対象のみ出力するためパラメーター追加
''    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem, strOrgBill, strBillOrgCd1, strBillOrgCd2)

'### 2013/02/04 張 出力条件に受診区分追加の為パラメータ追加 ###
'### 2017/02/03 張 出力条件に請求書区分（strBillPrint）追加の為パラメータ追加 ###
'    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem, strCslDivCd, strOrgBill, strBillOrgCd1, strBillOrgCd2)
    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem, strCslDivCd, strBillPrint, strOrgBill, strBillOrgCd1, strBillOrgCd2)


''''''''''''''''''■■■■■■■■■■
'''''''''''''''''
      Print = Ret

    End If

End Function
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">

<!--- ◆ ↓<Title>の修正を忘れないように ◆ -->

<TITLE>特定健診結果CSV出力</TITLE>
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

    // エレメントの参照設定
    function setElement() {
    }

    function checkBillOrg(){
        with(document.entryForm)
        {
            if(orgBill.checked == true && billOrgCd1.value == ""){
                alert("請求団体を選択してください！！！");
            }else{
                submit();
            }
        }
    }

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

<!--- タイトル -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN>特定健診結果CSV出力（XML用）</B></TD>
        </TR>
    </TABLE>
<%
'エラーメッセージ表示

    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

    <INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11 %>">
    <INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12 %>">
    <INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21 %>">
    <INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22 %>">
    <INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31 %>">
    <INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32 %>">
    <INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41 %>">
    <INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42 %>">
    <INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51 %>">
    <INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52 %>">
<!-- 請求団体対象チェック -->
    <INPUT TYPE="hidden" NAME="billOrgCd1"       VALUE="<%= strBillOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="billOrgCd2"       VALUE="<%= strBillOrgCd2 %>">

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
            <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
            <TD>日</TD>
        </TR>
    </TABLE>
    <BR>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>□</TD>
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
    </TABLE>

    <!-- 団体グループ -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体グループ</TD>
            <TD>：</TD>
            <TD><%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
        </TR>
    </TABLE> 
    <BR>

    <!-- 健診コース区分 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>健診コース区分</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="Course">
                    <OPTION VALUE=""></OPTION>
                    <OPTION VALUE="100">一日人間ドック</OPTION>
<!--### 2011.04.25 SL-SN-Y0101-002 ADD 張 職員定期健康診断（ドック）も抽出対象にする為仕様変更 Start ###-->
                    <OPTION VALUE="105">職員定期健診（ドック）</OPTION>
<!--### 2011.04.25 SL-SN-Y0101-002 ADD 張 職員定期健康診断（ドック）も抽出対象にする為仕様変更 End   ###-->
                    <OPTION VALUE="110">企業健診</OPTION>
                </SELECT>
            </TD>
         
        </TR>
    </TABLE>

    <!-- 出力項目区分 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>出力項目区分</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="SpItem">
                    <!--一般健診項目と特定健診項目を区分して結果取得-->
                    <!--OPTION VALUE="">聖路加フォーマット</OPTION>
                    <OPTION VALUE="0">特定健診項目</OPTION-->
                    <OPTION VALUE="A">聖路加フォーマット</OPTION>
                    <OPTION VALUE="S">特定健診項目</OPTION>
                </SELECT>
            </TD>  
        </TR>
    </TABLE>
    <BR>

<!-- 2009.06.01 団体請求対象のみ出力するため追加 START -->
    <!--  団体請求対象者 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体請求対象</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="CHECKBOX" NAME="orgBill" VALUE="1" <%= IIF(strOrgBill = "1","CHECKED","") %>>団体請求対象者のみ</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>請求対象団体</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.billOrgCd1, document.entryForm.billOrgCd2, 'BillOrgName')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.billOrgCd1, document.entryForm.billOrgCd2, 'BillOrgName')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="BillOrgName"><% = strBillOrgName %></SPAN></TD>
        </TR>
    </TABLE>
<!-- 2009.06.01 団体請求対象のみ出力するため追加 END -->

<% '### 2013/02/04 張 出力条件に受診区分追加 Start ### %>
    <!-- 受診区分 -->
    <BR>
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
<% '### 2013/02/04 張 出力条件に受診区分追加 End   ### %>

<% '### 2017/02/03 張 出力条件に請求書出力区分追加 STR ### %>
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
<% '### 2017/02/03 張 出力条件に請求書出力区分追加 END ### %>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
    </TABLE>

    <BR><BR>

<!--- 印刷ボタン -->
    <!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <a href="javascript:checkBillOrg();"><img src="/webHains/images/print.gif"></a>
    <%  End if  %>

    </BLOCKQUOTE>
<!--
<%= strSCslDate %>
<BR>
<%= strECslDate %>
<br>
<%=  strCsCd %>
<BR>
<%= strOrgCd1 %>
<BR>
<%= strOrgCd2 %>
<BR>
-->


</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>