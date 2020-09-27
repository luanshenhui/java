<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   事前チャートスタディ用受診者リストCSV出力 (Ver0.0.1)
'   AUTHER  :
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
Dim objPerson       '個人情報アクセス用

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strSCslYear, strSCslMonth, strSCslDay   '開始年月日
Dim strECslYear, strECslMonth, strECslDay   '終了年月日
Dim strCsCd                                 'コースコード
Dim strObject                               '出力対象
'■■■■■■■■■■

'作業用変数
Dim strSCslDate         '開始日
Dim strECslDate         '終了日

Dim strCourseCd         '健診コース区分コード
Dim strSpItem           '特定健診項目と一般項目区分

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
    If Not IsEmpty(Request("endCslYear")) Then
        strECslYear   = Request("endCslYear")   '終了年
        strECslMonth  = Request("endCslMonth")  '開始月
        strECslDay    = Request("endCslDay")    '開始日
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay


    '健診コース
    strCourseCd = Request("Course")

    '健診項目
    strSpItem   = Request("SpItem")


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
'例)    .AppendArray vntArrMessage, コメント

        If strMode <> "" Then

            If Not IsDate(strECslDate) Then
                strECslDate = strSCslDate
            End If

            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "開始日付が正しくありません。"
            End If

            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "終了日付が正しくありません。"
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
'-------------------------------------------------------------------------------
Function Print()

    Dim objCommon   '共通クラス
    Dim objPrintCls '団体一覧出力用COMコンポーネント
    Dim Ret         '関数戻り値

    Dim strURL

    If Not IsArray(CheckValue()) Then

        '情報漏えい対策用ログ書き出し
        Call putPrivacyInfoLog("PH107", "事前チャートスタディ用受診者リストCSV出力よりファイル出力を行った")

        Set objPrintCls = Server.CreateObject("HainsAbsenceListStudy.AbsenceListStudy")
        Ret = objPrintCls.PrintAbsenceListStudy(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strCourseCd, strSpItem)

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

<TITLE>事前チャートスタディ用受診者リストCSV出力</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {


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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■事前チャートスタディ用受診者リストCSV出力 </SPAN></B></TD>
        </TR>
    </TABLE>
<%
'エラーメッセージ表示

    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

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
            <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, True) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, True) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, True) %></TD>
            <TD>日</TD>
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
                    <OPTION VALUE="105">職員定期健診（ドック）</OPTION>
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
                    <OPTION VALUE="A">ナースチェック用</OPTION>
                </SELECT>
            </TD>  
        </TR>
    </TABLE>
    <BR>

    <BR><BR>

<!--- 印刷モード -->
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--- 印刷ボタン -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する"><br>
    <%  End if  %>


    </BLOCKQUOTE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>