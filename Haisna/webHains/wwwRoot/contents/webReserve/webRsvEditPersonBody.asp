<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ドック申し込み個人情報(ボディ) (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim blnReadOnly	'読み込み専用

Dim strTitle	'見出し
Dim i			'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
blnReadOnly = (Request("readOnly") <> "")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>ドック申込個人情報</TITLE>
<!-- #include virtual = "/webHains/includes/zipGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 郵便番号ガイド呼び出し
function callZipGuide( index ) {

	var objForm = document.entryForm;

	zipGuide_showGuideZip( objForm.prefCd[ index ].value, objForm.zipCd[ index ], objForm.prefCd[ index ], objForm.cityName[ index ], objForm.address1[ index ] );

}

// 郵便番号のクリア
function clearZipInfo( index ) {

	zipGuide_clearZipInfo( document.entryForm.zipCd[ index ] );

}

// 初期処理
function initialize() {

	// 基本情報での保持値を設定
	top.getBody();
<%
	'読み取り専用時はすべての入力要素を使用不能にする
	If blnReadOnly Then
%>
		top.opener.top.disableElements( document.entryForm );
<%
	End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()" ONUNLOAD="javascript:zipGuide_closeGuideZip()">
<FORM NAME="entryForm" action="#">
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To 2

			'見出しの編集
			Select Case i
				Case 0
					strTitle = "自宅"
				Case 1
					strTitle = "勤務先"
				Case 2
					strTitle = "その他"
			End Select
%>
			<TR>
				<TD NOWRAP>住所（<%= strTitle %>）</TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">郵便番号</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
						If Not blnReadOnly Then
%>
							<TD><A HREF="javascript:callZipGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="郵便番号ガイド表示"></A></TD>
							<TD><A HREF="javascript:clearZipInfo(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="郵便番号を削除します"></A></TD>
<%
						End If
%>
						<TD><INPUT TYPE="text" NAME="zipCd" VALUE="" SIZE="9" MAXLENGTH="7" STYLE="ime-mode:disabled;"></TD>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">都道府県</TD>
				<TD><%= EditPrefList("prefCd", "") %></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">市区町村</TD>
				<TD><INPUT TYPE="text" NAME="cityName" SIZE="65" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;"></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">住所１</TD>
				<TD><INPUT TYPE="text" NAME="address1" SIZE="78" MAXLENGTH="60" VALUE="" STYLE="ime-mode:active;"></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">住所２</TD>
				<TD><INPUT TYPE="text" NAME="address2" SIZE="78" MAXLENGTH="60" VALUE="" STYLE="ime-mode:active;"></TD>
			</TR>
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
			<TR>
				<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">電話番号１</TD>
				<TD><INPUT TYPE="text" NAME="tel1"  SIZE="19" MAXLENGTH="15" VALUE="" STYLE="ime-mode:disabled;"></TD>
			</TR>
			<TR>
				<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">携帯番号</TD>
				<TD><INPUT TYPE="text" NAME="phone" SIZE="19" MAXLENGTH="15" VALUE="" STYLE="ime-mode:disabled;"></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">電話番号２</TD>
				<TD>&nbsp;<SPAN ID="tel2_<%= i %>"></SPAN></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">内線</TD>
				<TD>&nbsp;<SPAN ID="extension_<%= i %>"></SPAN></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">FAX番号</TD>
				<TD>&nbsp;<SPAN ID="fax_<%= i %>"></SPAN></TD>
			</TR>
			<TR>
				<TD NOWRAP BGCOLOR="#eeeeee" ALIGN="right">E-mailアドレス</TD>
				<TD><INPUT TYPE="text" NAME="eMail" SIZE="52" MAXLENGTH="40" VALUE="" STYLE="ime-mode:disabled;"></TD>
			</TR>
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
<%
		Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
