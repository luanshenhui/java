<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'	   入力結果種類の選択 (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc"   -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"   -->
<!-- #include virtual = "/webHains/includes/editRslDailyList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス

Dim lngCntlNoFlg	'管理番号制御フラグ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'管理番号の制御方法を取得
lngCntlNoFlg = CLng("0" & objCommon.SelectCntlFlg)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>入力結果種類の選択</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsltab  { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
// 入力チェック
function checkData() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var ret    = false;					// 関数戻り値
	
	// 受診日入力チェック
	for ( ; ; ) {

		if ( !isDate( myForm.cslYear.value, myForm.cslMonth.value, myForm.cslDay.value ) ) {
			alert('受診日の形式に誤りがあります。');
			break;
		}

		// 管理番号入力チェック
		if ( myForm.cntlNo.value != '' ) {
			if ( !myForm.cntlNo.value.match('^[0-9]+$') ) {
				alert('管理番号には1～9999の値を入力して下さい。');
				break;
			}
		}

		// 当日ID入力チェック
		if ( myForm.dayId.value != '' ) {
			if ( !myForm.dayId.value.match('^[0-9]+$') ) {
				alert('当日ＩＤには1～9999の値を入力して下さい。');
				break;
			}
		}

		// 当日ID指定時は前次受診者非遷移で開かせる
		myForm.noPrevNext.value = ( myForm.dayId.value == '') ? '' : '1';

		ret = true;
		break;
	}

	return ret;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.dayId.focus();">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="rslMain.asp" ONSUBMIT="return checkData()">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="noPrevNext">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
		<TR VALIGN="bottom">
			<TD COLSPAN="2"><FONT SIZE="+2"><B>結果入力</B></FONT></TD>
		</TR>
		<TR HEIGHT="2">
			<TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="500">
		<TR>
			<TD ROWSPAN="2" VALIGN="top"><IMG SRC="/webHains/images/keisoku.jpg" WIDTH="80" HEIGHT="60"></TD>
			<TD ROWSPAN="20" WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1"></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder">結果入力</SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">受診者毎の検査結果を入力します。問診結果入力もこちらからどうぞ</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD>受診日</TD>
						<TD>：</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
									<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Now()), False) %></TD>
									<TD>年</TD>
									<TD><%= EditNumberList("cslMonth", 1, 12, Month(Now()), False) %></TD>
									<TD>月</TD>
									<TD><%= EditNumberList("cslDay", 1, 31, Day(Now()), False) %></TD>
									<TD>日</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD>コース</TD>
						<TD>：</TD>
						<TD><%= EditCourseList("csCd", "", SELECTED_ALL) %></TD>
					</TR>
					<TR>
						<TD>表示順</TD>
						<TD>：</TD>
						<TD><%= EditSortKeyList("sortKey", "") %></TD>
					</TR>
<%
					'管理番号を使用する場合は入力テキストを表示
					If lngCntlNoFlg = CNTLNO_ENABLED Then
%>
						<TR>
							<TD NOWRAP>管理番号</TD>
							<TD>：</TD>
							<TD><INPUT TYPE="text" NAME="cntlNo" SIZE="<%= TextLength(4) %>" MAXLENGTH="4"></TD>
						</TR>
<%
					End If
%>
					<TR>
						<TD NOWRAP>当日ＩＤ</TD>
						<TD>：</TD>
						<TD>
<%
					'管理番号を未使用時はダミー管理番号
					If lngCntlNoFlg <> CNTLNO_ENABLED Then
%>
						<INPUT TYPE="hidden" NAME="cntlNo" VALUE="">
<%
					End If
%>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
									<TD><INPUT TYPE="text" NAME="dayId" SIZE="4" MAXLENGTH="4" STYLE="text-align:left;ime-mode:disabled;"></TD>
									<TD NOWRAP><FONT COLOR="#999999">（※未入力時には受診者一覧を表示します）</FONT></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD VALIGN="bottom" WIDTH="100%"><INPUT TYPE="image" NAME="next" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/resultAllSet/rslAllSet.asp?step=1"><IMG SRC="/webHains/images/doctor2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/resultAllSet/rslAllSet.asp?step=1">検査結果を一括して入力</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">正常判定などの定型検査結果を複数受診者に一括して入力します。</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/resultListSet/rslListSet.asp"><IMG SRC="/webHains/images/worksheet.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/resultListSet/rslListSet.asp">ワークシート形式の結果入力</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">分析器から出力された検査結果リスト、定期健康診断などのある範囲の検査結果を複数受診者に対して入力する場合に便利です。</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/common/progress.asp"><IMG SRC="/webHains/images/signal.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/common/progress.asp">進捗状況の確認</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">現在の検査進捗状況を表示します。</TD>
		</TR>
<!--	
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/aftercare/JigoList.asp"><IMG SRC="/webHains/images/aftercare.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/aftercare/JigoList.asp">事後措置の登録</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">事後措置、保健指導はこちらから。</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/FilmNo/SltFilmkind.asp"><IMG SRC="/webHains/images/filmcan.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/FilmNo/SltFilmkind.asp">フィルム番号入力</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">フィルム番号入力はこちらから。</TD>
		</TR>
-->
<% '2004.04.28 ADD STR ORB)T.Yaguchi %>
    <% '#### 2009.12.03 張 フォローアップシステム再構築の為、メニューから削除 Start %>
		<!--TR>
			<TD HEIGHT="80"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/followup/followupInfo.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/followup/followupInfo.asp">フォローアップ照会</A><SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">フォローアップ照会の画面を表示します。</TD>
		</TR>

		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/followup/followupMailInfo.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/followup/followupMailInfo.asp">フォローアップはがき印刷</A><SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">フォローアップはがき印刷の画面を表示します。</TD>
		</TR-->
    <% '#### 2009.12.03 張 フォローアップシステム再構築の為、メニューから削除 End   %>
<% '2004.04.28 ADD END%>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>