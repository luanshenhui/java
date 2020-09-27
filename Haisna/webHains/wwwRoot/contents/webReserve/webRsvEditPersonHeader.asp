<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ドック申し込み個人情報(ヘッダ) (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objWebRsv		'web予約情報アクセス用

'引数値
Dim dtmCslDate		'受診年月日
Dim lngWebNo		'webNo.
Dim dtmBirth		'生年月日
Dim blnReadOnly		'読み込み専用

Dim strZipNo		'郵便番号
Dim strAddress1		'住所1
Dim strAddress2		'住所2
Dim strAddress3		'住所3
Dim strTel			'電話番号
Dim strEMail		'e-mail
Dim strOfficeName	'勤務先名称
Dim strOfficeTel	'勤務先電話番号

Dim strZipNo1		'郵便番号1
Dim strZipNo2		'郵便番号2
Dim strEditZipNo	'編集用の郵便番号

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
dtmCslDate  = CDate(Request("cslDate"))
lngWebNo    = CLng("0" & Request("webNo"))
dtmBirth    = CDate(Request("birth"))
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
<SCRIPT TYPE="text/javascript">
<!--
function regist() {
	top.regist();
}
function closeWindow() {
	top.opener.closeEditPersonalWindow();
}

// 初期処理
function initialize() {

	// 基本情報での保持値を設定
	top.getHeader();
<%
	'読み取り専用時
	If blnReadOnly Then

		'すべての入力要素を使用不能にする
%>
		top.opener.top.disableElements( document.entryForm );
<%
		'ボタンのクリア
%>
		document.getElementById('saveButton').innerHTML  = '';
<%
	End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()">
<FORM NAME="entryForm" action="#">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">ドック申込個人情報</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3">
		<TR>
			<TD ID="saveButton"><A HREF="javascript:regist()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A></TD>
			<TD><A HREF="javascript:closeWindow()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A></TD>
		</TR>
	</TABLE>
	<SPAN ID="errMsg"></SPAN>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">個人ＩＤ</TD>
			<TD ID="perId" NOWRAP></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">フリガナ</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>姓&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="lastKName"  SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
						<TD>&nbsp;名&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="firstKName" SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">名前</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>姓&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="lastName"  SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
						<TD>&nbsp;名&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="firstName" SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">ローマ字名</td>
			<TD><INPUT TYPE="text" NAME="romeName" SIZE="111" MAXLENGTH="60" VALUE="" STYLE="ime-mode:disabled;"></TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">性別</TD>
			<TD ID="gender"></TD>
		</TR>
<%
		'オブジェクトのインスタンス作成
		Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">生年月日</TD>
			<TD><%= objCommon.FormatString(dtmBirth, "ggge（yyyy）年m月d日") %></TD>
		</TR>
<%
		'オブジェクトの解放
		Set objCommon = Nothing
%>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD>申し込み情報</TD>
		</TR>
<%
		'オブジェクトのインスタンス作成
		Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")
	
		'web予約情報読み込み
		objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , strZipNo, strAddress1, strAddress2, strAddress3, strTel, strEMail, strOfficeName, strOfficeTel

		'オブジェクトの解放
		Set objWebRsv = Nothing
%>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">住所</TD>
<%
			'郵便番号指定時
			If strZipNo <> "" Then
				strZipNo1 = Left(strZipNo, 3)
				strZipNo2 = Mid(strZipNo, 4, 4)
				strEditZipNo = strZipNo1 & IIf(strZipNo2 <> "", "-", "") & strZipNo2
			End If
%>
			<TD NOWRAP><%= strEditZipNo & "&nbsp;" & strAddress1 & strAddress2 & strAddress3 %></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">電話番号</TD>
			<TD NOWRAP><%= strTel %></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">E-mail</TD>
			<TD NOWRAP><%= strEMail %></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">勤務先</TD>
			<TD NOWRAP><%= strOfficeName %></TD>
		</TR>
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" ALIGN="right">勤務先電話番号</TD>
			<TD NOWRAP><%= strOfficeTel %></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
