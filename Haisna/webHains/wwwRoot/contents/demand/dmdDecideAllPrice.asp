<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		個人受診金額再作成 (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction			'処理状態（確定ボタン押下時:"submit"，締め処理起動完了後:"submitend"）
Dim lngStrYear			'開始受診日(年)
Dim lngStrMonth			'開始受診日(月)
Dim lngStrDay			'開始受診日(日)
Dim lngEndYear			'終了受診日(年)
Dim lngEndMonth			'終了受診日(月)
Dim lngEndDay			'終了受診日(日)
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgName			'団体名称
Dim strForceUpdate		'
Dim strPutLog			'

'COMオブジェクト
Dim objDemand			'請求処理アクセス用COMオブジェクト
Dim objCommon			'共通クラス

'指定条件
Dim strStrDate			'開始受診日
Dim strEndDate			'終了受診日

'入力チェック
Dim vntArrMessage		'エラーメッセージ
Dim dtmDate				'受診日デフォルト値計算用の日付
Dim lngRet				'戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction     = Request("action") & ""
lngStrYear    = CLng("0" & Request("strYear"))
lngStrMonth   = CLng("0" & Request("strMonth"))
lngStrDay     = CLng("0" & Request("strDay"))
lngEndYear    = CLng("0" & Request("endYear"))
lngEndMonth   = CLng("0" & Request("endMonth"))
lngEndDay     = CLng("0" & Request("endDay"))
strOrgCd1     = Request("orgCd1") & ""
strOrgCd2     = Request("orgCd2") & ""


'受診日(開始)のデフォルト値(前月の先頭日)を設定
dtmDate = DateAdd("m", -1, Year(Now()) & "/" & Month(Now()) & "/1")
lngStrYear    = IIf(lngStrYear  = 0, Year(dtmDate),  lngStrYear )
lngStrMonth   = IIf(lngStrMonth = 0, Month(dtmDate), lngStrMonth)
lngStrDay     = IIf(lngStrDay   = 0, Day(dtmDate),   lngStrDay  )
strStrDate    = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay

'受診日(終了)のデフォルト値(前月の末日)を設定
dtmDate = CDate(Year(Now()) & "/" & Month(Now()) & "/1") - 1
lngEndYear    = IIf(lngEndYear  = 0, Year(dtmDate),  lngEndYear )
lngEndMonth   = IIf(lngEndMonth = 0, Month(dtmDate), lngEndMonth)
lngEndDay     = IIf(lngEndDay   = 0, Day(dtmDate),   lngEndDay  )
strEndDate    = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay

strForceUpdate = Request("forceUpdate")
strPutLog      = Request("logMode")

'初期設定
vntArrMessage = Empty

'処理の制御
Do

	'確定ボタン押下時
	If strAction = "submit" Then

		Set objCommon = Server.CreateObject("HainsCommon.Common")

		With objCommon
			'日付整合性チェック
			If Not IsDate(strStrDate) Then
				.AppendArray vntArrMessage, "開始日付が正しくありません。"
			End If
	
			'日付整合性チェック
			If Not IsDate(strEndDate) Then
				.AppendArray vntArrMessage, "終了日付が正しくありません。"
			End If
	
		End With
		Set objCommon = Nothing

		'チェックエラー時は処理を抜ける
		If Not IsEmpty(vntArrMessage) Then
			Exit Do
		End If

		'締め処理起動
		Set objDemand = Server.CreateObject("HainsDmdAddUp.DecideAllConsultPrice")
		lngRet = objDemand.DecideAllConsultPrice(strStrDate, strEndDate, strOrgCd1, strOrgCd2, strForceUpdate, strPutLog)
		Set objDemand = Nothing

		'起動に成功した場合、起動完了後モードへ遷移（完了メッセージを表示する）
		If lngRet >= 0 Then
			strAction = "submitend"
		Else
			vntArrMessage = Array("受診金額再作成に失敗しました。")
		End If

	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人受診金額再作成</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体検索ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName', '', '', null);

}

// 団体コード・名称のクリア
function clearOrgInfo() {

	orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// 確定ボタン押下時の処理
function goFinish() {

	var msg;
	msg = '';

	msg = msg + '指定された条件で個人受診金額を再作成します。';
	if ( confirm(msg) ) {
		document.entryCondition.action.value = 'submit';
		document.entryCondition.submit();
	}

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">個人受診金額再作成</FONT></B></TD>
	</TR>
</TABLE>
<!-- ここはエラーメッセージ -->
<%
	'メッセージの編集
	If strAction <> "" Then

		'起動完了時は「起動完了」の通知
		If strAction = "submitend" Then
			If lngRet = 0 Then
				vntArrMessage = "<FONT COLOR=""#ff6600""><B>受診金額再作成を実行しましたが対象データがありませんでした。</B></FONT>"
			Else
				vntArrMessage = "<FONT COLOR=""#ff6600""><B>受診金額再作成が完了しました。件数=" & lngRet & "件</B></FONT>"
			End If
			Call EditMessage(vntArrMessage, MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(vntArrMessage, MESSAGETYPE_WARNING)
		End If
	
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD NOWRAP>受診日範囲</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Now()), False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, Month(Now()), False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("strDay", 1, 31, Day(Now()), False) %></TD>
					<TD>日</TD>
					<TD>～</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Now()), False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("endMonth", 1, 12, Month(Now()), False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("endDay", 1, 31, Day(Now()), False) %></TD>
					<TD>日</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>

	<TR>
		<TD NOWRAP>団体</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示します"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>

	<TR>
		<TD NOWRAP>実行ログ</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="RADIO" NAME="logMode" VALUE="0" <%= IIf(strPutLog = "0", "CHECKED", "") %>>開始終了のみ出力
			<INPUT TYPE="RADIO" NAME="logMode" VALUE="1" <%= IIf(strPutLog = "1", "CHECKED", "") %>>エラーのみ出力
			<INPUT TYPE="RADIO" NAME="logMode" VALUE="2" <%= IIf(strPutLog = "2", "CHECKED", "") %>>全て出力
		</TD>
	</TR>
<!--
	<TR>
		<TD NOWRAP>対象データ</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="CHECKBOX" NAME="forceUpdate" VALUE="1">指定受診日範囲内の受診金額をすべて再作成</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD><FONT COLOR="#999999">　　※このオプションを指定すると、請求締め済みデータ、未受付データも全て再作成します。</FONT></TD>
	</TR>
-->
</TABLE>

<INPUT TYPE="HIDDEN" NAME="forceUpdate" VALUE="0">

<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="500">
<TR>
	<TD><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGREMONEY"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="実行ログを参照します"></A></TD>
	<TD ALIGN="RIGHT">
	<% '2005.08.22 権限管理 Add by 李　--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
		<A HREF="javascript:function voi(){};voi()" ONCLICK="return goFinish()" METHOD="post"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="個人受診金額を再作成します"></A>
	<%  else    %>
		 &nbsp;
	<%  end if  %>
	<% '2005.08.22 権限管理 Add by 李　--- END %>
	</TD>

</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
