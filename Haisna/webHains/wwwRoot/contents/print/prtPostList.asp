<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   郵便物受領書(請求書、成績表） (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-231~232
'       修正日  ：2010.05.11
'       担当者  ：ASC)三浦
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editDmdClassList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editJudClassList.inc" -->
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

'引数値
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '開始年月日
Dim strESendDate,strESendYear, strESendMonth, strESendDay   '終了年月日

Dim strLoginId                              '発行処理を行った担当者(ログイン）ID

Dim strOutPutCls                            '出力対象
Dim strOutPutCscd                           '出力対象

'##郵便物区分
Dim strArrOutputCls()                       '出力対象区分
Dim strArrOutputClsName()                   '出力対象区分名

'##コース区分
Dim strArrOutputCscd()                      '出力対象区分
Dim strArrOutputCscdName()                  '出力対象区分名

'作業用変数
Dim i, j            'カウンタ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'共通引数値の取得
strMode = Request("mode")

'出力対象区分，名称の生成
Call CreateOutputInfo()

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
    If IsEmpty(Request("strSendYear")) Then
        strSSendYear   = Year(Now())             '開始年
        strSSendMonth  = Month(Now())            '開始月
        strSSendDay    = Day(Now())              '開始日
    Else
        strSSendYear   = Request("strSendYear")   '開始年
        strSSendMonth  = Request("strSendMonth")  '開始月
        strSSendDay    = Request("strSendDay")    '開始日
    End If
    strSSendDate   = strSSendYear & "/" & strSSendMonth & "/" & strSsendDay

'◆ 終了年月日
    If IsEmpty(Request("endSendYear")) Then
'       strESendYear   = Year(Now())             '終了年
'       strESendMonth  = Month(Now())            '開始月
'       strESendDay    = Day(Now())              '開始日
    Else
        strESendYear   = Request("endSendYear")   '終了年
        strESendMonth  = Request("endSendMonth")  '開始月
        strESendDay    = Request("endSendDay")    '開始日
    End If
    strESendDate   = strESendYear & "/" & strESendMonth & "/" & strESendDay

'◆ 出力対象
    strOutputCls    = Request("outputCls")      '対象郵便物
    strOutputCscd   = Request("outputCscd")     '対象コース
    strLoginId      = Request("LoginId")        '対象発行担当者ID

    UID = Session("USERID")
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

    'ここにチェック処理を記述
    With objCommon
        If strMode <> "" Then

            '◆ 発送日チェック
            If Not IsDate(strESendDate) Then
                strESendDate = strSSendDate
            End If
            '◆ 開始日付整合性チェック
            If Not IsDate(strSSendDate) Then
                .AppendArray vntArrMessage, "開始日が正しくありません。"
            End If

            If Not IsDate(strESendDate) Then
                .AppendArray vntArrMessage, "終了日付が正しくありません。"
            End If

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

    Dim objPrintCls '団体一覧出力用COMコンポーネント
    Dim objBill     '請求書テーブル用COMコンポーネント
    Dim PrintRet    '関数戻り値
    Dim UpdateRet   '関数戻り値
    Dim objCommon
    If Not IsArray(CheckValue()) Then

		'情報漏えい対策用ログ書き出し
		Call putPrivacyInfoLog("PH034", "郵便物受領証 の印刷を行った")

'#### 2010.05.11 SL-UI-Y0101-231~232 MOD START ####'
'        Set objCommon = Server.CreateObject("HainsCommon.Common")
'        strURL = "/webHains/contents/report_form/rd_33_prtPostList.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_strSendDate=" & objCommon.FormatString(CDate(strSSendDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_endSendDate=" & objCommon.FormatString(CDate(strESendDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_strCscd=" & strOutputCscd
'        strURL = strURL & "&p_Option=" & strOutputCls
'        strURL = strURL & "&p_strLoginId=" & strLoginId
'        Set objCommon = Nothing
'        Response.Redirect strURL
'        Response.End

		Dim Ret			'関数戻り値
		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		if strOutputCls = "0" then
			Set objPrintCls = Server.CreateObject("HainsprtPostBill.prtPostBill")
		else
			Set objPrintCls = Server.CreateObject("HainsprtPostReport.prtPostReport")
		end if
		'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
		Ret = objPrintCls.PrintOut(UID, _
								   strSSendDate, _
							       strESendDate, _
							       strOutputCscd, _
							       strOutputCls, _
							       strLoginId)
		Print = Ret

'#### 2010.05.11 SL-UI-Y0101-231~232 MOD END ####'

    End If

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 出力対象に関する配列を生成する
'
' 引数　　 : 
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Sub CreateOutputInfo()

    Redim Preserve strArrOutputCls(1)
    Redim Preserve strArrOutputClsName(1)

    strArrOutputCls(0) = "0":strArrOutputClsName(0) = "(団体)請求書"
    strArrOutputCls(1) = "1":strArrOutputClsName(1) = "成績表"

    Redim Preserve strArrOutputCscd(4)
    Redim Preserve strArrOutputCscdName(4)

    strArrOutputCscd(0) = "100":strArrOutputCscdName(0) = "1日人間ドック"
    strArrOutputCscd(1) = "110":strArrOutputCscdName(1) = "企業健診"
    strArrOutputCscd(2) = "170":strArrOutputCscdName(2) = "渡航内科"
    strArrOutputCscd(3) = "150":strArrOutputCscdName(3) = "肺ドック"
    strArrOutputCscd(4) = "999":strArrOutputCscdName(4) = "その他"

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>郵便物発送リスト</TITLE>
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">郵便物受領書(団体請求書、成績表）</FONT></B></TD>
        </TR>
    </TABLE>
<%
'エラーメッセージ表示

    'メッセージの編集
    If( strMode <> "" )Then

        '保存完了時は「保存完了」の通知
        Call EditMessage(vntMessage, MESSAGETYPE_WARNING)

    End If
%>
    <BR>

<!--- 日付 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>発送日</TD>
<!--- 日付 -->
            <TD>：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strSendYear', 'strSendMonth', 'strSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("strSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSendYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strSendMonth", 1, 12, strSSendMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strSendDay", 1, 31, strSSendDay, False) %></TD>
            <TD>日</TD>
            <TD>～</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endSendYear', 'endSendMonth', 'endSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditSelectNumberList("endSendYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strESendYear)) %></TD>
            <TD>年</TD>
            <TD><%= EditSelectNumberList("endSendMonth", 1, 12, Clng("0" & strESendMonth)) %></TD>
            <TD>月</TD>
            <TD><%= EditSelectNumberList("endSendDay",   1, 31, Clng("0" & strESendDay  )) %></TD>
            <TD>日</TD>

        </TR>
    </TABLE>
<!--- 郵便物選択 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>郵便物選択</TD>
            <TD>：</TD>
            <TD><%= EditDropDownListFromArray("outputCls", strArrOutputCls, strArrOutputClsName , strOutputCls, NON_SELECTED_DEL) %></TD>
        </TR>
    </TABLE>
<!--- コース選択 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT>□</FONT></TD>
            <TD WIDTH="90" NOWRAP>コース選択</TD>
            <TD>：</TD>
            <TD><%= EditDropDownListFromArray("outputCscd", strArrOutputCscd, strArrOutputCscdName , strOutputCscd, NON_SELECTED_ADD) %>&nbsp;&nbsp;成績表のみ対応</TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR><TD COLSPAN="4">※空欄の場合、すべてのコースが対象</TD></TR>
        <TR><TD COLSPAN="4">※その他の場合、1日人間ドック、企業健診、渡航内科、肺ドック以外のコースが対象</TD></TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>発送者ID</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="LoginId" SIZE="20" VALUE="" MAXLENGTH="10">&nbsp;&nbsp;発送処理を行った担当者IDを入力（ 例：425XXX ）</TD>
        </TR>
    </TABLE>
    <p><BR><BR><BR>
<!--- 印刷モード -->
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--- 印刷ボタン -->
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
	    <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する"><br>
	<%  End if  %>

</FORM></p>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>