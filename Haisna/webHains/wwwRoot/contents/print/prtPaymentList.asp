<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   団体入金台帳 (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"          -->
<!-- #include virtual = "/webHains/includes/common.inc"                -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"           -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"        -->
<!-- #include virtual = "/webHains/includes/print.inc"                 -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"  -->
<%

'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode         '印刷モード
Dim vntMessage      '通知メッセージ
Dim strURL          'URL
Dim UID
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

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strSCslYear, strSCslMonth, strSCslDay       '締め日(自)
Dim strECslYear, strECslMonth, strECslDay       '締め日(至)
Dim strSCslYear2, strSCslMonth2, strSCslDay2    '入金日(自)
Dim strECslYear2, strECslMonth2, strECslDay2    '入金日(至)
Dim strOutPutCls                                '区分（０：全て　１：未収　２：入金）
'## 2011.08.31 MOD 張 並び順選択できるように変更（「入金日＞入金種別＞請求番号」と「入金日＞入金種別＞団体カナ名称」中で選択） START
Dim strSortKind                                 '並び順（１：請求番号順　２：団体名称順）
'## 2011.08.31 MOD 張 並び順選択できるように変更（「入金日＞入金種別＞請求番号」と「入金日＞入金種別＞団体カナ名称」中で選択） END
'■■■■■■■■■■

'作業用変数
Dim strOrgName      '団体名
Dim strBsdName      '事業部名
Dim strRoomName     '室部名
Dim strSPostName    '開始所属名
Dim strEPostName    '終了所属名
Dim strLastName     '姓
Dim strFirstName    '名
Dim strPerName      '氏名
Dim strSCslDate     '締め開始日
Dim strECslDate     '締め終了日
Dim strSCslDate2    '入金開始日
Dim strECslDate2    '入金終了日
Dim strArrCourse    'コースコード
Dim strArrSubCourse 'サブコースコード
Dim i, j            'カウンタ

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
'◆ 開始入金年月日
    If IsEmpty(Request("strCslYear2")) Then
    Else
        strSCslYear2   = Request("strCslYear2")     '開始年
        strSCslMonth2  = Request("strCslMonth2")    '開始月
        strSCslDay2   = Request("strCslDay2")       '開始日
    End If
    strSCslDate2   = strSCslYear2 & "/" & strSCslMonth2 & "/" & strSCslDay2
'◆ 終了入金年月日
    If IsEmpty(Request("endCslYear2")) Then
    Else
        strECslYear2   = Request("endCslYear2")     '終了年
        strECslMonth2  = Request("endCslMonth2")    '開始月
        strECslDay2    = Request("endCslDay2")      '開始日
    End If
    strECslDate2    = strECslYear2 & "/" & strECslMonth2 & "/" & strECslDay2
'◆ 区分
    strOutputCls    = Request("outputCls")

'## 2011.08.31 MOD 張 並び順選択できるように変更（「入金日＞入金種別＞請求番号」と「入金日＞入金種別＞団体カナ名称」中で選択） START
'◆ 並び順
    strSortKind    = Request("sortKind")
'## 2011.08.31 MOD 張 並び順選択できるように変更（「入金日＞入金種別＞請求番号」と「入金日＞入金種別＞団体カナ名称」中で選択） END


UID = Session("USERID")

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

    Dim vntArrMessage	'エラーメッセージの集合

'■■■■■■■■■■ 画面項目にあわせて編集
    'ここにチェック処理を記述
    With objCommon
'例)        .AppendArray vntArrMessage, コメント

'       If strMode <> "" Then
            If Not IsDate(strECslDate2) Then
                strECslDate2 = strSCslDate2
            End If
'　　　　　 End If

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

    Dim objPrintCls 'COMコンポーネント
    Dim Ret         '関数戻り値
'Dim objCommon
    If Not IsArray(CheckValue()) Then

'■■■■■■■■■■ 画面項目にあわせて編集
'		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
'		Set objPrintCls = Server.CreateObject("HainsCameraList.CameraList")
'		'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
'		Ret = objPrintCls.PrintCameraList(Session("USERID"), , strSCslDate, strECslDate, strCsCd, strFilmNo)
'■■■■■■■■■■
'		Print = Ret
'Set objCommon = Server.CreateObject("HainsCommon.Common")
'strURL = "/webHains/contents/report_form/rd_31_prtNurseCheck.asp"
'strURL = strURL & "?p_Uid=" & UID
'strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'Set objCommon = Nothing
'Response.Redirect strURL
'Response.End


        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsprtPaymentList.prtPaymentList")
        'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）

'## 2011.08.31 MOD 張 並び順選択できるように変更（「入金日＞入金種別＞請求番号」と「入金日＞入金種別＞団体カナ名称」中で選択） START
'        Ret = objPrintCls.Printout(UID, strSCslDate, strECslDate, strOutputCls, strSCslDate2, strECslDate2)
        Ret = objPrintCls.Printout(UID, strSCslDate, strECslDate, strOutputCls, strSCslDate2, strECslDate2, strSortKind)
'## 2011.08.31 MOD 張 並び順選択できるように変更（「入金日＞入金種別＞請求番号」と「入金日＞入金種別＞団体カナ名称」中で選択） END

        print=Ret
'       print=strScslDate
'       print=strEcslDate

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
<TITLE>団体入金台帳</TITLE>
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■団体入金台帳</SPAN></B></TD>
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
            <TD WIDTH="90" NOWRAP>締め日</TD>
            <TD> ：</TD>
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
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <td><font color="#ff0000">■</font></td>
            <TD WIDTH="90" NOWRAP>出力区分</TD>
            <TD>：</TD>
            <TD><select name="outputCls" size="1">
                    <option selected value="0">全て</option>
                    <option value="1">未収</option>
                    <option value="2">入金済み</option>
                </select></TD>
        </TR>
    </table>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>入金日</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear2', 'strCslMonth2', 'strCslDay2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditSelectNumberList("strCslYear2", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strSCslYear2)) %></TD>
            <TD>年</TD>
            <TD><%= EditSelectNumberList("strCslMonth2", 1, 12, Clng("0" & strSCslMonth2)) %></TD>
            <TD>月</TD>
            <TD><%= EditSelectNumberList("strCslDay2",   1, 31, Clng("0" & strSCslDay2  )) %></TD>
            <TD>日</TD>
            <TD>～</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear2', 'endCslMonth2', 'endCslDay2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditSelectNumberList("endCslYear2", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strECslYear2)) %></TD>
            <TD>年</TD>
            <TD><%= EditSelectNumberList("endCslMonth2", 1, 12, Clng("0" & strECslMonth2)) %></TD>
            <TD>月</TD>
            <TD><%= EditSelectNumberList("endCslDay2",   1, 31, Clng("0" & strECslDay2  )) %></TD>
            <TD>日</TD>
        </TR>
    </TABLE>
    <font color="#a9a9a9">※出力区分が入金済みのとき入金日範囲が有効となります。</font><br>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <td><font color="#ff0000">■</font></td>
            <TD WIDTH="90" NOWRAP>並び順</TD>
            <TD>：</TD>
            <TD><select name="sortKind" size="1">
                    <option selected value="1">請求番号順</option>
                    <option value="2">団体名称順</option>
                </select>
            </TD>
        </TR>
    </table>

    <!--- 印刷モード -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
<!--  2003/02/27  START  START  E.Yamamoto  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/02/27  START  END    E.Yamamoto  -->
<!--  2003/02/27  DEL  START  E.Yamamoto  -->
<!--
            <TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
            <TD NOWRAP>プレビュー</TD>

            <TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
            <TD NOWRAP>直接出力</TD>
        </TR>
-->
<!--  2003/02/27  DEL  END    E.Yamamoto  -->
        </TR>
    </TABLE>

    <BR><BR>

<!--- 印刷ボタン -->
    <!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
    <%  End if  %>

    </BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>