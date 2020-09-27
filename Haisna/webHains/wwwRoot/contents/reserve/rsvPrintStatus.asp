<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		印刷状況確認 (Ver0.0.1)
'		AUTHER  : Tsutomu Ishida@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checksession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditIsrDivList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim blnOpAnchor			'操作用アンカー制御
Dim dtmCardPrintDate	'確認はがき出力日時
Dim dtmFormPrintDate	'一式書式出日時
Dim objCommon			'共通アクセス用
Dim objConsult			'受診情報アクセス用
Dim strAction			'処理状態(保存ボタン押下時:"save")
Dim strRsvNo			'予約番号力
Dim strHTML				'仮想ページ


'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'共通クラスのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'引数値の取得
strAction        = Request("act")
dtmCardPrintDate = Request("CardPrintDate")
dtmFormPrintDate = Request("FormPrintDate")
strRsvNo         = Request("rsvNo")

'読込み処理の制御
Do
'保存ボタン押下時
	If strAction = "save" Then
		'受診情報テーブルレコード更新
		objConsult.UpdateConsultPrintStatus strRsvNo, dtmCardPrintDate, dtmFormPrintDate
		'エラーがなければ自身を閉じる
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'## 2003.01.13 Mod By T.Takagi 保存時印刷制御方法変更
		'保存内容を予約情報詳細画面に返し、かつ保存時印刷制御を行う
'		strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
'		strHTML = strHTML & "</BODY>"
'		strHTML = strHTML & "</HTML>"
		strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
		strHTML = strHTML & vbCrLf & "<!--"
		strHTML = strHTML & vbCrLf & "if ( opener ) {"
		strHTML = strHTML & vbCrLf & "    if ( opener.top ) {"
		strHTML = strHTML & vbCrLf & "        if ( opener.top.cardPrinted != null ) {"
		strHTML = strHTML & vbCrLf & "            opener.top.cardPrinted = " & IIf(dtmCardPrintDate <> "", "true", "false") & ";"
		strHTML = strHTML & vbCrLf & "        }"
		strHTML = strHTML & vbCrLf & "        if ( opener.top.formPrinted != null ) {"
		strHTML = strHTML & vbCrLf & "            opener.top.formPrinted = " & IIf(dtmFormPrintDate <> "", "true", "false") & ";"
		strHTML = strHTML & vbCrLf & "        }"
		strHTML = strHTML & vbCrLf & "        if ( opener.top.controlPrtOnSave != null ) {"
		strHTML = strHTML & vbCrLf & "            opener.top.controlPrtOnSave();"
		strHTML = strHTML & vbCrLf & "        }"
		strHTML = strHTML & vbCrLf & "    }"
		strHTML = strHTML & vbCrLf & "}"
		strHTML = strHTML & vbCrLf & "close();"
		strHTML = strHTML & vbCrLf & "//-->"
		strHTML = strHTML & vbCrLf & "</SCRIPT>"
		strHTML = strHTML & vbCrLf & "</HTML>"
'## 2003.01.13 Mod End
		Response.Write strHTML
		Response.End
	End If
	'受診情報テーブルレコード読込み処理
	objConsult.SelectConsultPrintStatus strRsvNo, dtmCardPrintDate, dtmFormPrintDate
	Exit Do
Loop
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>印刷状況確認</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 印刷日時の保存
function saveData() {
	
	document.entryForm.act.value = 'save';
	document.entryForm.submit();
}

// 印刷日時のクリア
 function ClearDate(updating) {

	// 印刷日時のクリア
	document.getElementById(updating).innerHTML = '<FONT COLOR="#999999">未出力</FONT>';
	
	if (updating == 'dspCardPrintDate') {
		document.entryForm.CardPrintDate.value = '';		//確認はがき出力日時をNULLにする
	} else if (updating == 'dspFormPrintDate') {
		document.entryForm.FormPrintDate.value = '';	//一式書式出力日時をNULLにする
	}
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="act" VALUE="">
	<INPUT TYPE="hidden" NAME="CardPrintDate" VALUE="<%= dtmCardPrintDate %>">
	<INPUT TYPE="hidden" NAME="FormPrintDate" VALUE="<%= dtmFormPrintDate %>">
	<INPUT TYPE="hidden" NAME="rsvNo" VALUE="<%= strRsvNo %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">印刷状況</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD HEIGHT="8"></TD>
		</TR>
		<TR>
			<TD NOWRAP>確認はがき出力</TD>
			<TD>：</TD>
<%
		If dtmCardPrintDate = "" Then
%>
			<TD WIDTH="160"><SPAN ID="dspCardPrintDate"><FONT COLOR="#999999">未出力</FONT></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspCardPrintDate')">クリア</A></TD>
<%
		Else
%>
			<TD WIDTH="160"><SPAN ID="dspCardPrintDate"><%= objcommon.FormatString(dtmCardPrintDate,"yyyy年mm月dd日 hh:nn:ss") %></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspCardPrintDate')">クリア<ALT="設定した値をクリア"></A></TD>
<%
		End If
%>
		</TR>
		<TR>
			<TD HEIGHT="21" NOWRAP>一式書式出力</TD>
			<TD>：</TD>
<%
		If dtmFormPrintDate = "" Then
%>
			<TD WIDTH="160"><SPAN ID="dspFormPrintDate"><FONT COLOR="#999999">未出力</FONT></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspFormPrintDate')">クリア<ALT="設定した値をクリア"></A></TD>
<%
		Else
%>			
			<TD NOWRAP><SPAN ID="dspFormPrintDate"><%= objcommon.FormatString(dtmFormPrintDate,"yyyy年mm月dd日 hh:nn:ss") %></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspFormPrintDate')">クリア</A></TD>
<%
		End If
%>
		</TR>
	</TABLE>
	<BR>
	<%  If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then   %>
        <A HREF="javascript:saveData()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="変更した内容を保存します" BORDER="0"></A>
	<%  End IF  %>
    <A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルします" BORDER="0"></A></TD>
</FORM>
</BODY>
</HTML>