<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		請求締め処理 (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc" -->


<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction			'処理状態（確定ボタン押下時:"submit"，締め処理起動完了後:"submitend"）
Dim lngCloseYear		'締め日(年)
Dim lngCloseMonth		'締め日(月)
Dim lngCloseDay			'締め日(日)
Dim lngStrYear			'開始受診日(年)
Dim lngStrMonth			'開始受診日(月)
Dim lngStrDay			'開始受診日(日)
Dim lngEndYear			'終了受診日(年)
Dim lngEndMonth			'終了受診日(月)
Dim lngEndDay			'終了受診日(日)
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgCd5Char		'団体コードの先頭５桁
Dim strCsCd				'コースコード


'COMオブジェクト
Dim objDmdAddUp			'締め処理アクセス用COMオブジェクト
Dim objDmdAddUpControl	'締め処理アクセス用COMオブジェクト
Dim objOrganization		'団体アクセス用COMオブジェクト

'指定条件
Dim strEditCloseDate	'締め日
Dim strEditStrDate		'開始受診日
Dim strEditEndDate		'終了受診日
Dim strEditOrgCd1		'団体コード１
Dim strEditOrgCd2		'団体コード２
Dim strEditCsCd			'コースコード

'団体読み込み
Dim strOrgName			'団体名称

'入力チェック
Dim strArrMessage		'エラーメッセージ
Dim dtmDate				'受診日デフォルト値計算用の日付
Dim lngRet				'戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction     = Request("action") & ""
lngCloseYear  = CLng("0" & Request("closeYear"))
lngCloseMonth = CLng("0" & Request("closeMonth"))
lngCloseDay   = CLng("0" & Request("closeDay"))
lngStrYear    = CLng("0" & Request("strYear"))
lngStrMonth   = CLng("0" & Request("strMonth"))
lngStrDay     = CLng("0" & Request("strDay"))
lngEndYear    = CLng("0" & Request("endYear"))
lngEndMonth   = CLng("0" & Request("endMonth"))
lngEndDay     = CLng("0" & Request("endDay"))
strOrgCd1     = Request("orgCd1") & ""
strOrgCd2     = Request("orgCd2") & ""
strOrgCd5Char = Request("orgCd5Char") & ""
strCsCd       = Request("CsCd") & ""



''締め日のデフォルト値(システム日付)を設定
'lngCloseYear  = IIf(lngCloseYear  = 0, Year(Now()),  lngCloseYear )
'lngCloseMonth = IIf(lngCloseMonth = 0, Month(Now()), lngCloseMonth)
'lngCloseDay   = IIf(lngCloseDay   = 0, Day(Now()),   lngCloseDay  )
'締め日のデフォルト値(前月の末日)を設定 ..... updated by C's
dtmDate = CDate(Year(Now()) & "/" & Month(Now()) & "/1") - 1
lngCloseYear  = IIf(lngCloseYear  = 0, Year(dtmDate),  lngCloseYear )
lngCloseMonth = IIf(lngCloseMonth = 0, Month(dtmDate), lngCloseMonth)
lngCloseDay   = IIf(lngCloseDay   = 0, Day(dtmDate),   lngCloseDay  )

'受診日(開始)のデフォルト値(前月の先頭日)を設定
dtmDate = DateAdd("m", -1, Year(Now()) & "/" & Month(Now()) & "/1")
lngStrYear    = IIf(lngStrYear  = 0, Year(dtmDate),  lngStrYear )
lngStrMonth   = IIf(lngStrMonth = 0, Month(dtmDate), lngStrMonth)
lngStrDay     = IIf(lngStrDay   = 0, Day(dtmDate),   lngStrDay  )

'受診日(終了)のデフォルト値(前月の末日)を設定
dtmDate = CDate(Year(Now()) & "/" & Month(Now()) & "/1") - 1
lngEndYear    = IIf(lngEndYear  = 0, Year(dtmDate),  lngEndYear )
lngEndMonth   = IIf(lngEndMonth = 0, Month(dtmDate), lngEndMonth)
lngEndDay     = IIf(lngEndDay   = 0, Day(dtmDate),   lngEndDay  )

'団体コード先頭５桁かどうか？
'If Trim(strOrgCd5Char) = "" Then
	strEditOrgCd1 = Trim(strOrgCd1)
	strEditOrgCd2 = Trim(strOrgCd2)
'Else
'	strEditOrgCd1 = Trim(strOrgCd5Char)
'	strEditOrgCd2 = ""
'End If

'初期設定
strArrMessage = Empty
strEditCloseDate = Empty
strEditStrDate = Empty
strEditEndDate = Empty

'団体名称の取得
If Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" Then
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
	Set objOrganization = Nothing
End If

'請求アクセス用COMオブジェクトの割り当て
Set objDmdAddUp        = Server.CreateObject("HainsDmdAddUp.DmdAddUp")

'処理の制御
Do

	'確定ボタン押下時
	If strAction = "submit" Then

		'入力チェック
		strArrMessage = objDmdAddUp.CheckValueDmdAddUp(lngCloseYear, lngCloseMonth, lngCloseDay, lngStrYear, lngStrMonth, lngStrDay, lngEndYear, lngEndMonth, lngEndDay, strEditOrgCd1, strEditOrgCd2, strEditCloseDate, strEditStrDate, strEditEndDate)

		'チェックエラー時は処理を抜ける
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'締め処理起動
		Set objDmdAddUpControl = Server.CreateObject("HainsDmdAddUp.DmdAddUpControl")
		lngRet = objDmdAddUpControl.ExecuteDmdAddUp(strEditCloseDate, strEditStrDate, strEditEndDate, strEditOrgCd1, strEditOrgCd2, strCsCd, Session.Contents("userid"))
		Set objDmdAddUpControl = Nothing

		'起動に成功した場合、起動完了後モードへ遷移（完了メッセージを表示する）
		If lngRet >= 0 Then
			strAction = "submitend"
		Else 
			strArrMessage = Array("請求締め処理に失敗しました。")
		End If

	End If

	Exit Do
Loop

'請求アクセス用COMオブジェクトの解放
Set objDmdAddUp = Nothing
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求締め処理</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->

<SCRIPT TYPE="text/javascript">
<!--
// 団体検索ガイド呼び出し
function callOrgGuide() {

	// 団体検索ガイド表示
	orgGuide_showGuideOrg(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName', null, null, setOrgByGuide);


}

// 団体検索ガイドで団体を選択した時の処理
function setOrgByGuide() {

	// 団体コードの先頭５桁入力値のクリア
	document.entryCondition.CheckboxOrgCd5Char.checked = false;
	document.entryCondition.orgCd5Char.value           = document.entryCondition.orgCd1.value;

}
// 団体コード・名称のクリア
function clearOrgInfo() {

	orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// 「団体コードの先頭５桁を指定する」が変更された時の処理
function ChangeOrgCd5Char( targetsel ) {

	// チェックされた時
	if ( targetsel.checked ) {
		// 団体コード・名称のクリア
		clearOrgInfo();
	// チェックがはずされた時
	} else {
		// 団体コードの先頭５桁入力値のクリア
		document.entryCondition.orgCd5Char.value = '';
	}

	return false;
}

// 確定ボタン押下時の処理
function goFinish() {

	var myCheck
	var msg;
	msg = '';

	// 団体コードの先頭５桁チェックがはいっていないならクリア
	if ( document.entryCondition.CheckboxOrgCd5Char.checked == false ) {
		document.entryCondition.orgCd5Char.value = '';
	}

	// 団体コードの先頭５桁が未入力時、チェックがはいっているなら
	if ( document.entryCondition.orgCd5Char.value == '' && document.entryCondition.CheckboxOrgCd5Char.checked ) {
		// 団体コードの先頭５桁指定チェックをはずす
		msg = msg + '団体コードの先頭５桁の指定は無視されます。\n';
		document.entryCondition.CheckboxOrgCd5Char.checked = false;
	}

	// 確認ＯＫ時、実行へ
	if ( msg != '') {
		msg = msg + '\n';
	}
	msg = msg + '指定された条件で締め処理を実行します。';
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
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg(); calGuide_closeGuideCalendar()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">請求締め処理</FONT></B></TD>
	</TR>
</TABLE>
<!-- ここはエラーメッセージ -->
<%
	'メッセージの編集
	If strAction <> "" Then

		'起動完了時は「起動完了」の通知
		If strAction = "submitend" Then
			If lngRet = 0 Then
				strArrMessage = "<FONT COLOR=""#ff6600""><B>請求締め処理を実行しましたが対象データがありませんでした。</B></FONT>"
			Else
				strArrMessage = "<FONT COLOR=""#ff6600""><B>請求締め処理を完了しました。</B></FONT>"
			End If
			Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)

		'さもなくばエラーメッセージを編集
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD>締め日</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('closeYear', 'closeMonth', 'closeDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("closeYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCloseYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("closeMonth", 1, 12, lngCloseMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("closeDay", 1, 31, lngCloseDay, False) %></TD>
					<TD>日</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>受診日範囲</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
					<TD>日</TD>
					<TD>～</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
					<TD>日</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>負担団体</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示します"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD WIDTH="5"></TD>
					<TD WIDTH="300">
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="checkbox" NAME="CheckboxOrgCd5Char" <%= IIf(Trim(strOrgCd5Char) = "", "", "CHECKED") %> ONCLICK="JavaScript:ChangeOrgCd5Char(this);" VALUE="1">
					<TD>団体コードの先頭５桁を指定する</TD>
					<TD><INPUT TYPE="text" NAME="orgCd5Char" SIZE="6" MAXLENGTH="5" VALUE="<%= strOrgCd5Char %>">
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>コース</TD>
		<TD>：</TD>
		<TD><%= EditCourseList("csCd", strCsCd, "全てのコース") %></TD>
	</TR>

</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="500">
<TR>
	<TD><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGBILLC"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="実行ログを参照します"></A></TD>
	
	<TD ALIGN="RIGHT">
	<% '2005.08.22 権限管理 Add by 李　--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
		<A HREF="javascript:function voi(){};voi()" ONCLICK="return goFinish()" METHOD="post"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="請求締め確定"></A>
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
