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
<TITLE>請求書発送確認</TITLE>

<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction			'処理状態（submit)
Dim strMode				'処理モード("update":上書き "insert":追加 "cancel":キャンセル)
Dim lngSendYear			'発送日(年)
Dim lngSendMonth		'発送日(月)
Dim lngSendDay			'発送日(日)
Dim strBillNo			'請求書番号
Dim strUpdUser			'更新者

Dim lngCloseYear		'締め日（年）
Dim lngCloseMonth		'締め日（月）
Dim lngCloseDay			'締め日（日）
Dim strCloseDate		'締め日
Dim lngBillSeq			'請求書Seq
Dim lngBranchNo			'請求書枝番
Dim lngSeq				'発送Seq
Dim strDispatchDate		'発送日
Dim strRet				'戻り値

Dim flgConfirm			'処理選択メッセージ表示フラグ （1:表示する）
Dim lngMax				'発送Seqの最大値
Dim lngDelFlg			'削除フラグ
Dim lngTotal				'請求金額
Dim lngNotPayment			'未収金額
Dim strOrgName				'負担元団体名
Dim strOrgKName				'負担元団体名
Dim strDispTotal

'COMオブジェクト
Dim objDemand			'請求情報アクセス用COMオブジェクト

'入力チェック
Dim strArrMessage		'エラーメッセージ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction    = Request("action") & ""
strMode      = Request("mode") & ""
strBillNo    = Request("billNo") & ""
lngSendYear  = CLng("0" & Request("sendYear"))
lngSendMonth = CLng("0" & Request("sendMonth"))
lngSendDay   = CLng("0" & Request("sendDay"))
strUpdUser   = Session("userid")

'初期設定
strArrMessage = Empty
flgConfirm = 0
strDispTotal = Empty

'請求アクセス用COMオブジェクトの割り当て
Set objDemand        = Server.CreateObject("HainsDemand.Demand")

'処理の制御
Do

	'パラメタチェック（発送日）
	strArrMessage = objDemand.CheckValueSendCheckDay(lngSendYear, lngSendMonth, lngSendDay, strDispatchDate)
	
	'エラー時は何もしない
	If Not IsEmpty(strArrMessage) Then
		strBillNo = ""
		Exit Do
	End If

	If strAction = "submit" Then
		If strBillNo = "" Then
			strArrMessage = Array("請求書番号を指定してください")
			Exit Do
		End If

		' Request から請求書キー
		If Len(strBillNo) <> 14 Then
			strArrMessage = Array("請求書番号が不正です")
			strBillNo = ""
			Exit Do
		Else 
			If Not IsNumeric(strBillNo) Then
				strArrMessage = Array("請求書番号が不正です")
				strBillNo = ""
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
			strBillNo = ""
			Exit Do
		End If
		strCloseDate = CDate(strCloseDate)

		If Not objDemand.GetDispatchSeqMax(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngMax, _
											lngDelFlg ) Then
			strArrMessage = Array("発送情報の取得に失敗しました")
			strBillNo = ""
			Exit Do
		End If

		'取り消し伝票は発送しない
		If CLng(lngDelFlg) = 1 Then
			strArrMessage = Array("取消伝票は発送できません")
			Exit Do
		End If

		If strCloseDate > strDispatchDate Then 
			strArrMessage = Array("発送日は締め日以降の日付を入力してください。")
			Exit Do
		End If

		'すでに発送データが存在するか
		'存在するなら上書きか追加か選択させる
		'存在しなければ追加
		If strMode = "" Then
			If lngMax = 0 Then
				strMode = "insert"
			Else 
				'選択ボタン表示
				flgConfirm = 1
				Exit Do
			End If

		End If

		'キャンセルは何もしない(請求書番号テキストボックスクリアする？)
		If strMode = "cancel" Then
			strBillNo = ""
			Exit Do

		'画面遷移中に全部削除されてしまったかもしれないので
		ElseIf strMode = "update" and lngMax <> 0 Then

			' 更新処理 この画面では MAX(SEQ) を更新する
			If Not objDemand.UpdateDispatch(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngMax, _
											strDispatchDate, _
											strUpdUser, lngMax ) Then
				strArrMessage = Array("発送情報は更新できませんでした")
				strBillNo = ""
				Exit Do
			End If

		Else 

			' 追加処理
			strRet = objDemand.InsertDispatch(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											strDispatchDate, _
											strUpdUser )
			'キー重複時はエラーメッセージを編集する
			If strRet = INSERT_DUPLICATE Then
				strArrMessage = Array("同一索引の発送情報がすでに存在します。")
				strBillNo = ""
				Exit Do
			End If

		End If

		'処理成功メッセージ表示
		'請求情報を取得する
		If Not objDemand.SelectDmdPaymentBillSum(lngCloseYear, _
												lngCloseMonth, _
												lngCloseDay, _
												strCloseDate, _
												lngBillSeq, _
												lngBranchNo, _
												lngDelFlg, _
												strOrgName, _
												lngTotal, _
												lngNotPayment, _
												strOrgKName ) Then
			strArrMessage = Array("請求書番号が不正です")
			strBillNo = ""
			Exit Do
		End If

		strDispTotal = FormatCurrency(lngTotal)

		strAction = "submitend"

	End If
	Exit Do
Loop

'請求アクセス用COMオブジェクトの解放
Set objDemand = Nothing

%>


<SCRIPT TYPE="text/javascript">
<!--

function setFocus() {

	if ( document.entryForm.confirm.value != 1 ) {
		document.entryForm.billNo.focus();
		document.entryForm.billNo.value = '';

//	} else {
//		document.entryForm.billNo.blur();
	}
	return false;
}

function callDispatchCancel() {

	document.entryForm.mode.value ='cancel';
	document.entryForm.action.value = 'submit';
	document.entryForm.submit();
	return false;

}
function callDispatchUpdate() {

	document.entryForm.mode.value ='update';
	document.entryForm.action.value = 'submit';
	document.entryForm.submit();
	return false;

}
function callDispatchInsert() {

	document.entryForm.mode.value ='insert';
	document.entryForm.action.value = 'submit';
	document.entryForm.submit();
	return false;

}
function submitDispatch() {

	document.entryForm.action.value = 'submit';

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="JavaScript:setFocus();">

<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="JavaScript:submitDispatch()">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<INPUT TYPE="hidden" NAME="mode" VALUE="">
<INPUT TYPE="hidden" NAME="sendYear" VALUE="<%= lngSendYear %>">
<INPUT TYPE="hidden" NAME="sendMonth" VALUE="<%= lngSendMonth %>">
<INPUT TYPE="hidden" NAME="sendDay" VALUE="<%= lngSendDay %>">
<INPUT TYPE="hidden" NAME="confirm" VALUE="<%= flgConfirm %>">
<BLOCKQUOTE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">請求書発送確認</FONT></B></TD>
	</TR>
</TABLE>
<BR>

<IMG SRC="../../images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:setFocus();">
<IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="320" ALIGN="left"><BR>
<table width="180" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="middle" nowrap><font size="6">発送日：</font></td>
		<td nowrap><font size="6" color="#ff4500"><b><%= FormatDateTime(strDispatchDate, vbShortDate) %></b></font></td>
		<td nowrap><font size="6">の確認処理を行います。</font></td>
	</tr>
</table>
<br>
<br>
<br>

<!-- 完了メッセージ -->
<% If strAction = "submitend" Then %>
<FONT SIZE="6">発送確認しました。</FONT>
<% End If %>

<!-- エラーメッセージ -->
<%
	'メッセージの編集
	If Not IsEmpty(strArrMessage) Then

		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>

<!-- 選択メッセージを表示するときはテキストボックスを隠す -->
<% If flgConfirm <> 1 Then %>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>BarCode：</TD>
			<TD><INPUT TYPE="text" NAME="billNo" SIZE="30" STYLE="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

<% Else %>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
	<TR>
		<TD colspan="5"><FONT SIZE="6">発送確認ずみです。</FONT></TD>
	</TR>

	<TR>
		<TD width="5">
			<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" onClick="return callDispatchCancel();"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルします" border="0"></A>
		</TD>
		<TD width="20">
		<TD width="5">
			<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" onClick="return callDispatchUpdate();"><IMG SRC="../../images/b_replace.gif" WIDTH="77" HEIGHT="24" ALT="発送日を変更します" border="0"></A>
		</TD>
		<TD width="20">
		<TD width="5">
			<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" onClick="return callDispatchInsert();"><IMG SRC="../../images/b_append.gif" WIDTH="77" HEIGHT="24" ALT="発送日を追加します" border="0"></A>
		</TD>
	</TR>
	</TABLE>

<% End If %>


<% If strAction = "submitend" Then %>
<TABLE>
	<TR>
		<TD NOWRAP><B><FONT COLOR="#ff0000"><%= FormatDateTime(Now(), vbShortDate) & " " &  FormatDateTime(Now(), vbShortTime) %> &nbsp;発送確認完了</FONT></B></TD>
	</TR</TABLE>

<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
	<TR>
		<TD NOWRAP>請求書No:</TD>
		<TD NOWRAP><B><%= strBillNo %></B></TD>
		<TD></TD>
	</TR>
	<TR>
		<TD ROWSPAN="3"></TD>
		<TD NOWRAP><B><%= strOrgName %></B>（<%= strOrgKName %>）</TD>
	</TR>

	<TR>
		<TD NOWRAP><%= strDispTotal %></TD>
	</TR>
</TABLE>
<% End If %>

<BR><BR>

<% If strBillNo <> "" Then %>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
	<TR>
		<TD><A HREF="/webHains/contents/demand/dmdBurdenModify.asp?billNo=<%= strBillNo %>">請求情報を参照</A></TD>
	</TR>
</TABLE>
<% End If %>
</BLOCKQUOTE>
</FORM>

<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>