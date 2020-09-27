<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   団体別契約セット情報CSV出力 (Ver0.0.1)
'   AUTHER  : 張
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
Dim strMode             '印刷モード
Dim vntMessage          '通知メッセージ
Dim MSGMODE

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon           '共通クラス
Dim objOrganization     '団体情報アクセス用
Dim objPerson           '個人情報アクセス用

Dim objFree             '汎用情報アクセス用


'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strSCslYear, strSCslMonth, strSCslDay   '開始年月日
Dim strCsCd                                 'コースコード
Dim strOrgCd1, strOrgCd2                    '団体コード
Dim strPerId                                '個人コード
Dim strObject                               '出力対象
'■■■■■■■■■■

'作業用変数
Dim strOrgName          '団体名
Dim strSCslDate         '開始日

Dim strCourseCd         '健診コース区分コード
Dim strPriceCheck       '「0」金額セット出力区分

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


'◆ 団体コード
    strOrgCd1       = Request("OrgCd1")
    strOrgCd2       = Request("OrgCd2")
    strOrgName      = Request("OrgName")


    '健診コース
    strCourseCd = Request("Course")


'◆ 問診項目出力区分フラグ(Y：出力)
    strPriceCheck = Request("priceFlg")


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

    With objCommon
'例)    .AppendArray vntArrMessage, コメント

        If strMode <> "" Then
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "基準日が正しくありません。"
            End If
        End If

        if strOrgCd1 = "" and strOrgCd2 = "" Then
            .AppendArray vntArrMessage, "団体を選択してください。"
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
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objCommon       '共通クラス
    Dim objPrintCls     '団体一覧出力用COMコンポーネント
    Dim Ret             '関数戻り値

    Dim strURL

    If Not IsArray(CheckValue()) Then

'''■■■■■■■■■■ 画面項目にあわせて編集
'''オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsAbsenceCompany.AbsenceCompany")

        Ret = objPrintCls.PrintAbsenceListCompany(Session("USERID"), CDate(strSCslDate), strOrgCd1, strOrgCd2, strCourseCd, strPriceCheck)

'''■■■■■■■■■■

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

<TITLE>団体別契約セット情報CSV出力</TITLE>
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

    function check(){
        with(document.entryForm)
        {
            if(orgCd1.value == "" && orgCd2.value == "") {
                alert("団体を選択してください！！！");
                return;
            }
            submit();
        }
    }

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

<!--- タイトル -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■団体別契約セット情報CSV出力</SPAN></B></TD>
        </TR>
    </TABLE>
<%
'エラーメッセージ表示

    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

    <INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2 %>">

<!--- 日付 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="120" NOWRAP>基準日</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>日</TD>

        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="120" NOWRAP>団体</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'OrgName')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'OrgName')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><% = strOrgName %><SPAN ID="OrgName"></SPAN></TD>
        </TR>

    <!-- 健診コース区分 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="120" NOWRAP>健診コース</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="Course">
                    <OPTION VALUE="100">一日人間ドック</OPTION>
                    <OPTION VALUE="105">職員定期健康診断（ドック）</OPTION>
                    <OPTION VALUE="110">企業健診</OPTION>
                </SELECT>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="120" NOWRAP>「0」金額セット出力</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="Radio" NAME="priceFlg" VALUE="N" checked>しない</TD>
                        <TD><INPUT TYPE="Radio" NAME="priceFlg" VALUE="Y">する</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <!--- 印刷モード -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <INPUT TYPE="hidden" NAME="mode" VALUE="0">
    </TABLE>

    <BR><BR>

<!--- 印刷ボタン -->
    <!---### ユーザグループ別操作権限管理 ###-->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <a href="javascript:check();"><img src="/webHains/images/DataSelect.gif"></a>
    <%  End if  %>

    </BLOCKQUOTE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>