<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   成績表チェックリスト(Ver1.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-220~230
'       修正日  ：2010.05.18
'       担当者  ：ASC)齋藤
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

'引数値
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay, convStrSSendDate   '開始年月日
Dim strESendDate,strESendYear, strESendMonth, strESendDay, convStrESendDate   '終了年月日


Dim strOutPutCls                            '出力対象
Dim strArrOutputCls()                       '出力対象区分
Dim strArrOutputClsName()                   '出力対象区分名

'作業用変数
Dim i, j            'カウンタ
Dim strECslDate		'終了日

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")

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
'◆ 終了年月日
	If IsEmpty(Request("endSendYear")) Then
      //  strESendYear   = Year(Now())             '終了年
     //   strESendMonth  = Month(Now())            '終了月
      //  strESendDay    = Day(Now())              '終了日
	Else
        strESendYear   = Request("endSendYear")   '終了年
        strESendMonth  = Request("endSendMonth")  '終了月
        strESendDay    = Request("endSendDay")    '終了日
	End If

    If Len(strSSendMonth) = 1 Then
        strSSendMonth = "0" + strSSendMonth 
    Else 
        strSSendMonth = strSSendMonth
    End If 

    If Len(strSSendDay) = 1 Then
        strSSendDay = "0" + strSSendDay 
    Else 
        strSSendDay = strSSendDay
    End If 

    If Len(strESendMonth) = 1 Then
        strESendMonth = "0" + strESendMonth 
    Else 
        strESendMonth = strESendMonth
    End If 

    If Len(strESendDay) = 1 Then
        strESendDay = "0" + strESendDay 
    Else 
        strESendDay = strESendDay
    End If 

    strSSendDate   = strSSendYear & strSSendMonth & strSSendDay
    convStrSSendDate   = strSSendYear & "/" & strSSendMonth & "/" & strSSendDay
    strESendDate   = strESendYear & strESendMonth & strESendDay
    convStrESendDate   = strESendYear & "/" & strESendMonth & "/" & strESendDay


'◆ 出力対象
    strOutputCls    = Request("outputCls")      'チェックリスト対象

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

            '◆ 開始、終了チェック
            If Not IsDate(convStrESendDate) Then
                convStrESendDate = convStrSSendDate
            End If

            If Not IsDate(convStrSSendDate) Then
                .AppendArray vntArrMessage, "開始日が正しくありません。"
            End If
            If Not IsDate(convStrESendDate) Then
                .AppendArray vntArrMessage, "終了日が正しくありません。"
            End If
            If IsDate(convStrSSendDate) Then 
               IF IsDate(convStrESendDate) Then  
                  If DateDiff("y",CDate(convStrSSendDate),CDate(convStrESendDate)) > 13 Then
                       .AppendArray vntArrMessage, "日付範囲は2週間です。その以上のデータはシステム管理者にご連絡ください。" 
                  End If
                  If DateDiff("y",CDate(convStrSSendDate),CDate(convStrESendDate)) < 0 Then
                       .AppendArray vntArrMessage, "日付範囲が正しくありません。" 
                  End If
               End if
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

'#### 2010.05.18 SL-UI-Y0101-220~230 MOD START ####'
'        Set objCommon = Server.CreateObject("HainsCommon.Common")
'        strURL = "/webHains/contents/report_form/rd_35_prtReportCheckList.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_strSendDate=" & objCommon.FormatString(CDate(convStrSSendDate), "yyyymmdd")
'        strURL = strURL & "&p_strESendDate=" & objCommon.FormatString(CDate(convStrESendDate), "yyyymmdd")
'        strURL = strURL & "&p_Option=" & strOutputCls
'        Set objCommon = Nothing
'        Response.Redirect strURL
'        Response.End

        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		Select Case strOutputCls
			Case 0				'総合判定連絡表作成用
				Set objPrintCls = Server.CreateObject("HainsprtReportChecklist.prtRepChecklist")
			Case 1				'婦人科コメントチェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportGyneChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtGyneChk.prtReportGyneChecklist")
			Case 2				'眼底チェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtRepRetiphotoChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtRepRet.prtRepRetiphotoChecklist")
			Case 3				'腹部超音波チェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtRepAbdoEchoChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtAbdoEc.prtRepAbdoEchoChecklist")
			Case 4				'胸部Ｘ線チェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportChestXChecklist")
				Set objPrintCls = Server.CreateObject("HainsprtChestX.prtReportChestXChecklist")
			Case 5				'上部消化管（胃Ｘ線）チェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportGastroChecklist")
				Set objPrintCls = Server.CreateObject("HainsprtGastro.prtReportGastroChecklist")
			Case 6				'上部消化管（内視鏡）チェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportEndoChecklist")
				Set objPrintCls = Server.CreateObject("HainsprtEndo.prtReportEndoChecklist")
			Case 7				'胸部ＣＴチェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportCTChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtCTChk.prtReportCTChecklist")
			Case 8				'乳房Ｘ線チェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportMammoChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtMammo.prtReportMammoChecklist")
			Case 9				'乳房超音波チェックリスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtRepBreastsEchoChklist")
				Set objPrintCls = Server.CreateObject("HainsPrtBreast.prtRepBreastsEchoChklist")
			Case 11				'心電図判定所見リスト
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportECGlist")
				Set objPrintCls = Server.CreateObject("HainsPrtECG.prtReportECGlist")
			Case Else
				Exit Function 
'			Case 10				'乳房触診チェックリスト
'			Case 12				'メタボリックシンドローム
'			Case 13				'胸部ＣＴ再検査対象リスト
'			Case 14				'ＧＦ生検実施者リスト
'			Case 15				'骨密度チェックリスト
		End Select

		'情報漏えい対策用ログ書き出し
		Call putPrivacyInfoLog("PH057", "成績書チェックリスト の印刷を行った")

        'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
        PrintRet = objPrintCls.PrintOut(UID, _
                                       convStrSSendDate, _
                                       convStrESendDate)
        Print = PrintRet

'#### 2010.05.18 SL-UI-Y0101-220~230 MOD END ####'
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

    Redim Preserve strArrOutputCls(15)
    Redim Preserve strArrOutputClsName(15)

    strArrOutputCls(0) = "0":strArrOutputClsName(0) = "総合判定連絡表作成用"
    strArrOutputCls(1) = "1":strArrOutputClsName(1) = "婦人科コメントチェックリスト"
    strArrOutputCls(2) = "2":strArrOutputClsName(2) = "眼底チェックリスト"
    strArrOutputCls(3) = "3":strArrOutputClsName(3) = "腹部超音波チェックリスト"
    strArrOutputCls(4) = "4":strArrOutputClsName(4) = "胸部X線チェックリスト"
    strArrOutputCls(5) = "5":strArrOutputClsName(5) = "上部消化管（胃Ｘ線）チェックリスト"
    strArrOutputCls(6) = "6":strArrOutputClsName(6) = "上部消化管（内視鏡）チェックリスト"
    strArrOutputCls(7) = "7":strArrOutputClsName(7) = "胸部CTチェックリスト"
    strArrOutputCls(8) = "8":strArrOutputClsName(8) = "乳房Ｘ線チェックリスト"
    strArrOutputCls(9) = "9":strArrOutputClsName(9) = "乳房超音波チェックリスト"
    strArrOutputCls(10) = "10":strArrOutputClsName(10) = "乳房触診チェックリスト"
    strArrOutputCls(11) = "11":strArrOutputClsName(11) = "心電図判定所見リスト"
    strArrOutputCls(12) = "12":strArrOutputClsName(12) = "メタボリックシンドローム"
    strArrOutputCls(13) = "13":strArrOutputClsName(13) = "胸部CT再検査対象リスト"
    strArrOutputCls(14) = "14":strArrOutputClsName(14) = "GF生検実施者リスト"
    strArrOutputCls(15) = "15":strArrOutputClsName(15) = "骨密度チェックリスト"

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>成績表チェックリスト</TITLE>
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">成績表チェックリスト(後日判定表チェック）</FONT></B></TD>
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
            <TD WIDTH="100" NOWRAP>作成日</TD>
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
			<TD><%= EditNumberList("endSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strESendYear, True) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endSendMonth", 1, 12, strESendMonth, True) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("endSendDay", 1, 31, strESendDay, True) %></TD>
			<TD>日</TD>

        </TR>
    </TABLE>
<!--- 請求書番号 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="100" NOWRAP>チェックリスト選択</TD>
            <TD>：</TD>
            <TD><%= EditDropDownListFromArray("outputCls", strArrOutputCls, strArrOutputClsName , strOutputCls, NON_SELECTED_DEL) %></TD>
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