<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   受診日一括変更 (Ver0.0.1)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const DEFAULT_ROW    = 0	'デフォルト表示行数
Const INCREASE_COUNT = 5	'表示行数の増分単位

Const MODE_NORMAL      = "0"	'予約人数再帰検索モード(通常検索)
Const MODE_SAME_RSVGRP = "1"	'予約人数再帰検索モード(同じ予約群グループで検索)

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用

'引数値
Dim strRsvNo			'予約番号

'お連れ様情報
Dim strFriCslDate		'受診日
Dim strFriSeq			'ＳＥＱ
Dim strFriRsvNo			'予約番号
Dim strFriPerId			'個人ＩＤ
Dim strFriCsCd			'コースコード
Dim strFriCsName		'コース名
Dim strFriOrgSName		'団体略称
Dim strFriLastName		'姓
Dim strFriFirstName		'名
Dim strFriLastKName		'カナ姓
Dim strFriFirstKName	'カナ名
Dim strFriDayId			'当日ＩＤ
Dim strFriRsvGrpCd		'予約群コード
Dim strFriRsvGrpName	'予約群名称
Dim strFriCancelFlg		'キャンセルフラグ
Dim lngFriCount			'お連れ様レコード数

Dim strCslDate			'受診日
Dim Ret					'関数戻り値
Dim i					'インデックス

dim lngdispcnt

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strRsvNo = Request("rsvNo")

Set objConsult = Server.CreateObject("HainsConsult.Consult")

'受診情報を読み、現在の受診日を取得
Ret = objConsult.SelectConsult(strRsvNo, , strCslDate)

Set objConsult = Nothing

If Ret = False Then
	Err.Raise 1000, , "受診情報が存在しません。"
End If

Sub EditRsvGrp(strCsCd, strRsvGrpCd)

	Dim objSchedule			'スケジュール情報アクセス用

	Dim strArrRsvGrpCd		'予約群コード
	Dim strArrRsvGrpName	'予約群名称
	Dim lngRsvGrpCount		'予約群数

	Dim i					'インデックス
%>
	<SELECT NAME="rsvGrpCd">
		<OPTION VALUE="">&nbsp;
<%
		'オブジェクトのインスタンス作成
		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'日付がシステム日付を含む以降の場合はコースで有効な群を、過去日の場合はすべての群を取得
		If CDate(strCslDate) >= Date() Then

			'指定コースにおける有効な予約群コース受診予約群情報を元に読み込む
			lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

		Else

			'すべての予約群を読み込む
			lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strArrRsvGrpCd, strArrRsvGrpName)

		End If

		Set objSchedule = Nothing

		'配列添字数分のリストを追加
		For i = 0 To lngRsvGrpCount - 1
%>
			<OPTION VALUE="<%= strArrRsvGrpCd(i) %>"<%= IIf(strArrRsvGrpCd(i) = strRsvGrpCd, " SELECTED", "") %>><%= strArrRsvGrpName(i) %>
<%
		Next
%>
	</SELECT>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診日一括変更</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winCalendar;		// カレンダー検索画面

// カレンダー検索画面呼び出し
function callCalendar() {

	// パラメータ編集開始
	var objForm  = document.entryForm;
	var rsvNo    = '';
	var rsvGrpCd = '';
	var sep      = '';

	var rsvGrpCount   = 0;
	var noRsvGrpCount = 0;

	// 検索可能な条件が存在しない場合は終了(エレメント自体が存在しない場合)
	if ( objForm.rsvNo == null ) {
		alert('検索可能な条件が存在しません。');
		return;
	}

	// 要素の追加
	if ( objForm.rsvNo.length != null ) {

		// 配列の検索
		for ( var i = 0; i < objForm.rsvNo.length; i++ ) {

			// 変更対象の受診情報であれば
			if ( objForm.rsvNo[ i ].checked ) {

				// 追加
				rsvNo    = rsvNo    + sep + objForm.rsvNo[ i ].value;
				rsvGrpCd = rsvGrpCd + sep + objForm.rsvGrpCd[ i ].value;
				sep      = '\x01';

				// 予約群指定数・未指定数をカウント
				if ( objForm.rsvGrpCd[ i ].value != '' ) {
					rsvGrpCount++;
				} else {
					noRsvGrpCount++;
				}

			}
		}

	} else {

		rsvNo    = objForm.rsvNo.value;
		rsvGrpCd = objForm.rsvGrpCd.value;

	}

	// 検索可能な条件が存在しない場合は終了(選択された要素が存在しない場合)
	if ( rsvNo == '' ) {
		alert('検索可能な条件が存在しません。');
		return;
	}

	// より近い時間枠で検索する場合
	if ( objForm.nearly.checked ) {

		// 予約群指定数・未指定数がともに存在する場合は検索できない
		if ( rsvGrpCount > 0 && noRsvGrpCount > 0 ) {
			alert('より近い時間枠で検索する場合、予約群は全て設定するか、もしくは全て未指定状態で検索してください。');
			return;
		}

	}

	var opened = false;	// 画面が開かれているか

	// すでに画面が開かれているかチェック
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			opened = true;
		}
	}

	// 開かれている場合
	if ( opened ) {

		// フォーカス移動
		winCalendar.focus();

	// 開かれていない場合
	} else {

		// 絶対に重複しないウィンドウ名を現在時間から作成
		var d = new Date();
		var windowName = 'W' + d.getHours() + d.getMinutes() + d.getSeconds() + d.getMilliseconds();

		// 新規画面を開く
		winCalendar = open('', windowName, 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no,width=700,height=500');

	}

	// エレメントへの編集
	var paraForm = document.paramForm;

	// 検索モードの決定
	if ( objForm.nearly.checked ) {
		paraForm.mode.value = '<%= MODE_SAME_RSVGRP %>';
	} else {
		paraForm.mode.value = '<%= MODE_NORMAL %>';
	}

	paraForm.cslYear.value  = objForm.cslYear.value;
	paraForm.cslMonth.value = objForm.cslMonth.value;
	paraForm.rsvNo.value    = rsvNo;
	paraForm.rsvGrpCd.value = rsvGrpCd;

	// ターゲットを指定してsubmit
	document.paramForm.target = winCalendar.name;
	document.paramForm.submit();

}

// 本画面を閉じる際の処理
function closeWindow() {

	// カレンダー検索画面が開かれている場合は同時に閉じる
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			winCalendar.close();
		}
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><SPAN CLASS="reserve">■</SPAN><B>受診日一括変更</B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD NOWRAP>現受診日：</TD>
		<TD NOWRAP COLSPAN="7"><B><%= Year(strCslDate) %>年<%= Month(strCslDate) %>月<%= Day(strCslDate) %>日</B></TD>
	</TR>
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD NOWRAP>検索年月：</TD>
		<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(strCslDate), False) %></TD>
		<TD>年</TD>
		<TD><%= EditNumberList("cslMonth", 1, 12, Month(strCslDate), False) %></TD>
		<TD>月</TD>
		<TD>&nbsp;&nbsp;<INPUT TYPE="checkbox" NAME="nearly" CHECKED></TD>
		<TD NOWRAP>より近い時間枠で検索</TD>
		<TD>&nbsp;&nbsp;<A HREF="javascript:callCalendar()"><IMG SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="この条件で確定"></A></TD>
	</TR>
</TABLE>
<%
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'お連れ様情報読み込み
lngFriCount = objConsult.SelectFriends(strCslDate, strRsvNo, strFriCslDate, strFriSeq, strFriRsvNo, , , , strFriPerId, strFriCsCd, strFriCsName, , , , strFriOrgSName, strFriLastName, strFriFirstName, strFriLastKName, strFriFirstKName, strFriDayId, strFriRsvGrpName, , strFriCancelFlg, strFriRsvGrpCd)

Set objConsult = Nothing

'お連れ様情報がなくとも、通常、受診者本人のレコードが１件必ず返る。よってそれすらない場合はエラー。
If lngFriCount <= 0 Then
	Err.Raise 1000, , "受診情報が存在しません。"
End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR>
		<TD NOWRAP><FONT COLOR="#cc9999">●</FONT>まとめて受診日変更を行う受診者をここで指定してください。</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
	<TR>
		<TD NOWRAP>操作／状態</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>個人ＩＤ</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>氏名</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>予約番号</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>受診団体</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>受診コース</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>予約群</TD>
	</TR>
	<TR>
		<TD COLSPAN="13" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" ALT="" HEIGHT="1" WIDTH="1"></TD>
	</TR>
<%
	'受診者本人を最初に編集
	For i = 0 To lngFriCount - 1

		'受診者本人を最初に編集
		If strFriRsvNo(i) = strRsvNo Then
%>
			<TR>
<%
				Select Case True

					Case strFriDayId(i) <> ""
%>
						<TD NOWRAP>受付済み</TD>
<%
					Case strFriCancelFlg(i) <> CStr(CONSULT_USED)
%>
						<TD NOWRAP>キャンセル</TD>
<%
					Case Else
%>
						<TD>
							<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
								<TR>
									<TD><INPUT TYPE="checkbox" NAME="rsvNo" VALUE="<%= strFriRsvNo(i) %>" CHECKED ONCLICK="javascript:this.checked = true"></TD>
									<TD NOWRAP>変更する</TD>
								</TR>
							</TABLE>
						</TD>
<%
				End Select
%>
				<TD></TD>
				<TD NOWRAP><%= strFriPerId(i) %></TD>
				<TD></TD>
				<TD NOWRAP><B><%= Trim(strFriLastName(i) & "　" & strFriFirstName(i)) %></B><FONT SIZE="-1">（<%= Trim(strFriLastKname(i) & "　" & strFriFirstKName(i)) %>）</FONT></TD>
				<TD></TD>
				<TD NOWRAP><%= strFriRsvNo(i) %></TD>
				<TD></TD>
				<TD NOWRAP><%= strFriOrgSName(i) %></TD>
				<TD></TD>
				<TD NOWRAP><%= strFriCsName(i) %></TD>
				<TD></TD>
				<TD><% EditRsvGrp strFriCsCd(i), strFriRsvGrpCd(i) %></TD>
			</TR>
<%
			Exit For
		End If

	Next

	'自身以外の情報、即ちお連れ様が存在する場合
	If lngFriCount > 1 Then
%>
		<TR>
			<TD COLSPAN="13" NOWRAP><BR>お連れ様の一覧</TD>
		</TR>
		<TR>
			<TD COLSPAN="13" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" ALT="" HEIGHT="1" WIDTH="1"></TD>
		</TR>
<%
		'お連れ様一覧の編集
		For i = 0 To lngFriCount - 1

			'受診者本人の情報は除きつつ編集
			If strFriRsvNo(i) <> strRsvNo Then
%>
				<TR>
<%
					Select Case True

						Case strFriDayId(i) <> ""
%>
							<TD NOWRAP>受付済み</TD>
<%
						Case strFriCancelFlg(i) <> CStr(CONSULT_USED)
%>
							<TD NOWRAP>キャンセル</TD>
<%
						Case Else
%>
							<TD>
								<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
									<TR>
										<TD><INPUT TYPE="checkbox" NAME="rsvNo" VALUE="<%= strFriRsvNo(i) %>" CHECKED></TD>
										<TD NOWRAP>変更する</TD>
									</TR>
								</TABLE>
							</TD>
<%
					End Select
%>
					<TD></TD>
					<TD NOWRAP><%= strFriPerId(i) %></TD>
					<TD></TD>
					<TD NOWRAP><B><%= Trim(strFriLastName(i) & "　" & strFriFirstName(i)) %></B><FONT SIZE="-1">（<%= Trim(strFriLastKname(i) & "　" & strFriFirstKName(i)) %>）</FONT></TD>
					<TD></TD>
					<TD NOWRAP><%= strFriRsvNo(i) %></TD>
					<TD></TD>
					<TD NOWRAP><%= strFriOrgSName(i) %></TD>
					<TD></TD>
					<TD NOWRAP><%= strFriCsName(i) %></TD>
					<TD></TD>
					<TD><% EditRsvGrp strFriCsCd(i), strFriRsvGrpCd(i) %></TD>
				</TR>
<%
			End If

		Next

	End If
%>
</TABLE>
</FORM>
<FORM NAME="paramForm" ACTION="/webHains/contents/frameReserve/fraRsvCalendarFromRsvNo.asp" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode">
	<INPUT TYPE="hidden" NAME="cslYear">
	<INPUT TYPE="hidden" NAME="cslMonth">
	<INPUT TYPE="hidden" NAME="rsvNo">
	<INPUT TYPE="hidden" NAME="rsvGrpCd">
</FORM>
</BODY>
</HTML>
