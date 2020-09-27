<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約情報詳細(その他情報) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const FREECD_FREEDIV = "FREEDIV"	'汎用コード(フリー区分)

'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用
Dim objFree			'汎用情報アクセス用

'引数値
Dim strRsvNo		'予約番号
Dim lngCancelFlg	'キャンセルフラグ

Dim strTestTubeNo	'検体番号
Dim lngCount		'検体番号の数

'メモ
Dim strFreeCd		'汎用コード
Dim strFreeField1	'汎用フィールド1
Dim lngFreeCount	'汎用レコード数

Dim strBuffer		'文字列編集バッファ
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objFree    = Server.CreateObject("HainsFree.Free")

'引数値の取得
strRsvNo     = Request("rsvNo")
lngCancelFlg = CLng("0" & Request("cancelFlg"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>予約情報詳細</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winConsult;	// 健診歴一覧画面

// 健診歴一覧画面呼び出し
function callConsultWindow() {

	var opened   = false;						// 画面が開かれているか
	var mainForm = top.main.document.entryForm;	// メイン画面のフォームエレメント
	var url;									// 健診歴一覧画面のURL

	// 入力チェック
	if ( !top.checkValue( 2 ) ) {
		return;
	}

	// すでにガイドが開かれているかチェック
	if ( winConsult != null ) {
		if ( !winConsult.closed ) {
			opened = true;
		}
	}

	// 健診歴一覧画面のURL編集
	url = 'rsvConsultList.asp';
	url = url + '?perId='    + mainForm.perId.value;
	url = url + '&cslYear='  + mainForm.cslYear.value;
	url = url + '&cslMonth=' + mainForm.cslMonth.value;
	url = url + '&cslDay='   + mainForm.cslDay.value;
	url = url + '&rsvNo='    + mainForm.rsvNo.value;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winConsult.focus();
		winConsult.location.replace( url );
	} else {
		winConsult = window.open( url, '', 'toolbar=no,directories=no,menubar=no,resizable=no,scrollbars=yes,width=300,height=400' );
	}

}

// １次健診歴のクリア
function clearFirstCslInfo() {

	top.setFirstCslInfo( '', '', '' );

}

// 健診歴一覧画面を閉じる
function closeConsultWindow() {

	// 健診歴一覧画面を閉じる
	if ( winConsult != null ) {
		if ( !winConsult.closed ) {
			winConsult.close();
		}
	}

	winConsult = null;
}

// 初期値の編集
function setDefaultValue() {

	var myForm   = document.entryForm;			// 自画面のフォームエレメント
	var mainForm = top.main.document.entryForm;	// メイン画面のフォームエレメント

	// 自画面の各項目値をメイン画面より取得する
	document.getElementById('rsvDate').innerHTML = mainForm.rsvDate.value;
	document.getElementById('quePrintDate').innerHTML = mainForm.quePrintDate.value;

	myForm.ocrCslYear.value  = mainForm.ocrCslYear.value;
	myForm.ocrCslMonth.value = mainForm.ocrCslMonth.value;
	myForm.ocrCslDay.value   = mainForm.ocrCslDay.value;

	myForm.cameraCslYear.value  = mainForm.cameraCslYear.value;
	myForm.cameraCslMonth.value = mainForm.cameraCslMonth.value;
	myForm.cameraCslDay.value   = mainForm.cameraCslDay.value;

	myForm.firstRsvNo.value  = mainForm.firstRsvNo.value;

	document.getElementById('firstCslDate').innerHTML = mainForm.firstCslDate.value;
	document.getElementById('firstCsName' ).innerHTML = mainForm.firstCsName.value;

	myForm.freeDiv.value     = mainForm.freeDiv.value;
	myForm.freeComment.value = mainForm.freeComment.value;
<%
	'キャンセル受診情報表示時のイネーブル制御
	If lngCancelFlg <> CONSULT_USED Then
%>
		myForm.ocrCslYear.disabled  = true;
		myForm.ocrCslMonth.disabled = true;
		myForm.ocrCslDay.disabled   = true;

		myForm.cameraCslYear.disabled  = true;
		myForm.cameraCslMonth.disabled = true;
		myForm.cameraCslDay.disabled   = true;

		myForm.freeDiv.disabled     = true;
		myForm.freeComment.disabled = true;
<%
	End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 8px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setDefaultValue()" ONUNLOAD="javascript:closeConsultWindow()">
<FORM NAME="entryForm" action="#">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">その他</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD>予約日時</TD>
			<TD>：</TD>
			<TD NOWRAP><SPAN ID="rsvDate"></SPAN></TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD>問診票出力日</TD>
			<TD>：</TD>
			<TD NOWRAP><SPAN ID="quePrintDate"></SPAN></TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD>ＯＣＲ用受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
<%
						'キャンセル受診情報表示時のイネーブル制御
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('ocrCslYear', 'ocrCslMonth', 'ocrCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
<%
						End If
%>
						<TD><%= EditNumberList("ocrCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Empty, (strRsvNo = "")) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("ocrCslMonth", 1, 12, Empty, (strRsvNo = "")) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("ocrCslDay",   1, 31, Empty, (strRsvNo = "")) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>胃カメラ受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
<%
						'キャンセル受診情報表示時のイネーブル制御
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('cameraCslYear', 'cameraCslMonth', 'cameraCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
							<TD><A HREF="JavaScript:calGuide_clearDate('cameraCslYear', 'cameraCslMonth', 'cameraCslDay')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
<%
						End If
%>
						<TD><%= EditNumberList("cameraCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Empty, (strRsvNo = "")) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("cameraCslMonth", 1, 12, Empty, (strRsvNo = "")) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("cameraCslDay",   1, 31, Empty, (strRsvNo = "")) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>１次健診受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
<%
						'キャンセル受診情報表示時のイネーブル制御
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="JavaScript:callConsultWindow()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="健診歴ガイドを表示"></A></TD>
							<TD><A HREF="JavaScript:clearFirstCslInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
							<TD>&nbsp;</TD>
<%
						End If
%>
						<TD NOWRAP><INPUT TYPE="hidden" NAME="firstRsvNo" VALUE=""><SPAN ID="firstCslDate"></SPAN>&nbsp;<SPAN ID="firstCsName"></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>胃受診時間</TD>
			<TD>：</TD>
<%
			'汎用テーブルからフリー区分を読み込む
			lngFreeCount = objFree.SelectFree(1, FREECD_FREEDIV, strFreeCd, , ,strFreeField1)
%>
			<TD>
				<SELECT NAME="freeDiv">
					<OPTION VALUE="">&nbsp;
<%
					'配列添字数分のリストを追加
					For i = 0 To lngFreeCount - 1
%>
						<OPTION VALUE="<%= strFreeCd(i) %>"><%= strFreeField1(i) %>
<%
					Next
%>
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD VALIGN="top">メモ</TD>
			<TD VALIGN="top">：</TD>
			<TD><TEXTAREA NAME="freeComment" COLS="29" ROWS="4"></TEXTAREA></TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
<%
		'検体番号管理情報を読み込む
		If strRsvNo <> "" Then
			lngCount = objConsult.SelectTestTubeMng(strRsvNo, strTestTubeNo)
			For i = 0 To lngCount - 1
				strBuffer = strBuffer & IIf(i > 0, ", ", "") & strTestTubeNo(i)
			Next
		End If
%>
		<TR>
			<TD>検体番号</TD>
			<TD>：</TD>
			<TD NOWRAP><%= strBuffer %></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
