<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		請求書発送確認日設定処理 (Ver0.0.1)
'		AUTHER  : C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求書発送確認日設定</TITLE>

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction			'処理状態（submit / next)
Dim strMode				'処理モード("delete"：削除 "update":上書き)
Dim lngSendYear			'発送日(年)
Dim lngSendMonth		'発送日(月)
Dim lngSendDay			'発送日(日)
Dim strSeq				'発送Seq
Dim strBillNo			'請求書番号

Dim lngCloseYear		'締め日（年）
Dim lngCloseMonth		'締め日（月）
Dim lngCloseDay			'締め日（日）
Dim strCloseDate		'締め日
Dim lngBillSeq			'請求書Seq
Dim lngBranchNo			'請求書枝番
Dim lngSeq				'発送Seq
Dim strDispatchDate		'発送日
Dim strUpdUser			'更新者


'COMオブジェクト
Dim objDemand			'請求情報アクセス用COMオブジェクト

'指定条件
Dim strEditSendDate	'発送日

'入力チェック
Dim strArrMessage		'エラーメッセージ
Dim lngMax
Dim lngDelFlg

Dim url					'
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction    = Request("action") & ""
strMode      = Request("mode") & ""
strBillNo    = Request("billNo") & ""
strSeq       = Request("seq") & ""
lngSendYear  = CLng("0" & Request("sendYear"))
lngSendMonth = CLng("0" & Request("sendMonth"))
lngSendDay   = CLng("0" & Request("sendDay"))
strUpdUser      = Session("userid")


'発送日のデフォルト値(システム日付)を設定
lngSendYear  = IIf(lngSendYear  = 0, Year(Now()),  lngSendYear )
lngSendMonth = IIf(lngSendMonth = 0, Month(Now()), lngSendMonth)
lngSendDay   = IIf(lngSendDay   = 0, Day(Now()),   lngSendDay  )


'初期設定
strArrMessage = Empty
strEditSendDate = Empty

'請求アクセス用COMオブジェクトの割り当て
Set objDemand        = Server.CreateObject("HainsDemand.Demand")

'処理の制御
Do

	'必須
	If strMode = "update" Or strMode = "delete" Then		'基本情報からの遷移

		If strBillNo = "" Or strSeq = "" Then
			strArrMessage = Array("発送情報が指定されていません")
			Exit Do
		End If

		' Request から請求書キー
		If Len(strBillNo) <> 14 Then
			strArrMessage = Array("請求書番号が不正です")
			Exit Do
		Else 
			If Not IsNumeric(strBillNo) Then
				strArrMessage = Array("請求書番号が不正です")
				Exit Do
			End If	
		End If

		lngCloseYear  = CLng("0" & Mid(strBillNo, 1, 4))
		lngCloseMonth = CLng("0" & Mid(strBillNo, 5, 2))
		lngCloseDay   = CLng("0" & Mid(strBillNo, 7, 2))
		lngBillSeq    = CLng("0" & Mid(strBillNo, 9, 5))
		lngBranchNo   = CLng("0" & Mid(strBillNo, 14, 1))
		strCloseDate = lngCloseYear & "/" & lngCloseMonth & "/" & lngCloseDay
		If Not IsDate(strCloseDate) Then	
			strArrMessage = Array("請求書番号が不正です")
			Exit Do
		End If
		strCloseDate = CDate(strCloseDate)

		'取消伝票は発送しない
		If Not objDemand.GetDispatchSeqMax(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngMax, _
											lngDelFlg ) Then
			strArrMessage = Array("発送情報の取得に失敗しました")
			Exit Do
		End If


		' 基本情報から遷移した場合は発送Seqは指定されたものを使用する
		lngSeq = CLng(strSeq)

		If strAction = "submit" Then
			If CLng(lngDelFlg) = 1 Then
				strArrMessage = Array("取消伝票は発送情報を変更できません")

			Else 
				If strMode = "delete" Then
					' 削除処理
					If Not objDemand.DeleteDispatch(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngSeq) Then 
						strArrMessage = Array("発送情報は削除できませんでした")
						Exit Do
					End If

				Else 

					'入力チェック
					strArrMessage = objDemand.CheckValueSendCheckDay(lngSendYear, lngSendMonth, lngSendDay, strDispatchDate)

					'入力エラー時は何もしない
					If Not IsEmpty(strArrMessage) Then
						Exit Do
					End If

					If strCloseDate > strDispatchDate Then 
						strArrMessage = Array("発送日は締め日以降の日付を入力してください。")
						Exit Do
					End If

					' 更新処理
					If Not objDemand.UpdateDispatch(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngSeq, _
													strDispatchDate, _
													strUpdUser) Then
						strArrMessage = Array("発送情報は更新できませんでした")
						Exit Do
					End If

				End If
				strAction = "saveend"
				Response.Write "<BODY ONLOAD=""goBackPage()"">"
			End If
		End If

		'発送情報取得
		If Not objDemand.SelectDispatch(strCloseDate, _
							lngBillSeq, _
							lngBranchNo, _
							lngSeq, _
							strDispatchDate) Then
			strArrMessage = Array("発送情報の取得に失敗しました")
			Exit Do
		End If

		lngSendYear  = Year(strDispatchDate)
		lngSendMonth = Month(strDispatchDate)
		lngSendDay   = Day(strDispatchDate)

	End If

	'modeにより処理分岐
	If strAction = "next" Then 
		' 次へ押下 確認画面へ遷移

		url = "/webHains/contents/demand/dmdSendCheck.asp"
		url = url & "?sendYear=" & lngSendYear
		url = url & "&sendMonth=" & lngSendMonth 
		url = url & "&sendDay=" & lngSendDay

		Response.Redirect url
		Response.End

	End If
		
	Exit Do
Loop

'請求アクセス用COMオブジェクトの解放
Set objDemand = Nothing
%>


<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
// 親ウインドウへ戻る
function goBackPage() {

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.dmdSendCheckDay_CalledFunction != null ) {
		opener.dmdSendCheckDay_CalledFunction();
	}
	close();

	return false;
}

function callDmdSendCheck() {

	// 発送日入力チェック
	if ( !isDate(document.entryForm.sendYear.value, document.entryForm.sendMonth.value, document.entryForm.sendDay.value) ) {
		self.alert('発送日の形式に誤りがあります。');
		return false;
	}

	// 自画面を送信
	document.entryForm.action.value = 'next';
	document.entryForm.submit();

	return false;

}
function DmdDispatchDelete() {
	var ret;		//戻り値

	ret = self.confirm('指定された発送情報を削除します。よろしいですか。');

	// OK
	if ( ret ) {
		// 自画面を送信
		document.entryForm.action.value = 'submit';
		document.entryForm.mode.value = 'delete';
		document.entryForm.submit();
	}
	return false;

}
function DmdDispatchUpdate() {

	// 入金日入力チェック
	if ( !isDate(document.entryForm.sendYear.value, document.entryForm.sendMonth.value, document.entryForm.sendDay.value) ) {
		self.alert('発送日の形式に誤りがあります。');
		return false;
	}

	// 自画面を送信
	document.entryForm.action.value = 'submit';
	document.entryForm.mode.value = 'update';
	document.entryForm.submit();

	return false;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY  ONUNLOAD="JavaScript:calGuide_closeGuideCalendar()" >
<BR>
<% If strMode = "" Then %>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<% End If %>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
<INPUT TYPE="hidden" NAME="seq" VALUE="<%= strSeq %>">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
<% If strBillNo = "" Then %>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><font color="#000000">請求書発送確認日設定</font></B></TD>
<% Else %>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><font color="#000000">請求書発送確認日修正</font></B></TD>
<% End If %>
	</TR>
</TABLE>
<!-- ここはエラーメッセージ -->
<%
	'メッセージの編集
	If Not IsEmpty(strArrMessage) Then

		'起動完了時は「起動完了」の通知
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>

<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD><FONT COLOR="#ff0000">■</FONT></TD>
		<TD WIDTH="90" NOWRAP>発送日</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('sendYear', 'sendMonth', 'sendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("sendYear", YEARRANGE_MIN, YEARRANGE_MAX, lngSendYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("sendMonth", 1, 12, lngSendMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("sendDay", 1, 31, lngSendDay, False) %></TD>
					<TD>日</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
<TR>
<!-- メニューからの遷移 -->
<% If strBillNo = "" Then %>
	
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return callDmdSendCheck();"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="発送を確認する"></A></TD>
    <%  end if  %>

<!-- 基本情報からの遷移 -->
<% Else %>

	<!-- 取消伝票の変更はできない -->
	<% If CLng(lngDelFlg) <> 1 Then %>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return DmdDispatchDelete();"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この発送情報を削除します"></A></TD>
		<TD WIDTH="190"></TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return DmdDispatchUpdate();"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この内容で確定する"></A></TD>
		<TD WIDTH="5"></TD>
	<% End If %>


	<TD><A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
<% End If %>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>

<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>